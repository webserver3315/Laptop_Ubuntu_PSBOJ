#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

#include "sleeplock.h"
#include "fs.h"
#include "file.h"
// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

// my code
int page_fault_handler(char* addr, struct trapframe* tf){
  /*
  1. check va is within a valid mapping
  if(va is not within any valid mappings) kill process;
  else pg = kalloc();

  if(FILEBACKED) pg[0~length] = read(fd, 0~length); // 물리주소임에 유의
  else(ANONYMOUS) pg[0~length] = 0;

  if(pgtable NOT EXIST) pgtable kalloc()

  pte[0~1024] = protection.bits, protection.pfn
  return;
  */
  if((uint)addr>=(uint)KERNBASE) return -1;
  struct proc *cp = myproc();
  int valid = 0;
  int i;
  for (i = 0; i < 100; i++) {
    if(cp->mm_arr[i].fd==0) continue; // valid => 따라서 allocate 된 mapped region 이 아님
    if((cp->mm_arr[i].start_va <= addr) && (cp->mm_arr[i].end_va > addr)){
      valid = 1;
      break;
    }
  }
  if(valid==0){
    // cprintf("page_fault_handler: unvalid mapped region\n");
    return -1; // kill process
  }

  if(((tf->err)&0x02)!=0){ // when access is WRITE
    if((cp->mm_arr[i].flags&0x02)==0){ // and when mapped region is READONLY
      // cprintf("page_fault_handler: write access at readonly file\n");
      return -1;
    }
  }
  struct file *fp = cp->mm_arr[i].f;
  uint offset = cp->mm_arr[i].offset;
  fp->off = offset;
  pde_t *pgdir = cp->pgdir;

  uint old_start = PGROUNDDOWN((uint)addr);
  char *mem = kalloc();
  if(mem==0){
    // cprintf("page_fault_handler: kalloc failed");
    return -1;
  }
  memset(mem, 0, PGSIZE);
  if(cp->mm_arr[i].fd != -1){
    // cprintf("pgflthandler: fileread: mem is %x\n", mem);
    fileread(fp, mem, PGSIZE);
  }
  // cprintf("pgflthandler: mappages: V2P(mem) is %x\n", V2P(mem));
  uint new_flag = 0;
  if(cp->mm_arr[i].flags & MAP_PROT_WRITE)
    new_flag |= MAP_PROT_WRITE;
  mappages(pgdir, (char *)old_start, PGSIZE, V2P(mem), new_flag | PTE_U);

  /*
  (16페이지)
  if (user virtual memories) => page fault handler 호출
  How? => virtual memory 를 KERNBASE 와 비교(?!?!)
  else => page fault handler 호출 X
  fault 가 발생했는데, faulted virtual address 를 어케 아느냐? => CR2 register(확인하는 함수 있음)
  read fault, write fault 구분
  */
  return 0;
}
// my code end

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  // my code
  if(tf->trapno == T_PGFLT){
    // cprintf("Page Fault Occured\n");
    // struct proc *cp = myproc();
    int flt_addr = rcr2();
    if(page_fault_handler((char*)flt_addr, tf)!=-1){// if successfully handled, do not kill
      return;
    }
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
//  case T_IRQ0 + IRQ_IDE2:
//	ide2intr();
//	lpaiceoi();
//	break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
