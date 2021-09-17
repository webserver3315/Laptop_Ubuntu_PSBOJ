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

int swapin(struct trapframe* tf, int flt_addr){ // -1: KILL, 0: success
  // rcr2 = user.vaddr
  struct proc *cp = myproc();
  // cprintf("here0\n");
  pde_t *pde = cp->pgdir;
  pte_t *pte = walkpgdir(pde, (void *)flt_addr, 1);
  // cprintf("swapin: walkpgdir pgdir=%p flt_addr=%p *pte=%p\n", cp->pgdir, flt_addr, *pte);
  // cprintf("here1\n");
  if((!(*pte & PTE_P) && (*pte != (pte_t)0))){
    // cprintf("swapin: swapin really required for *pte=%p\n",*pte);
    // print_bitmap(0, 11);
    uint block_number = (uint)(*pte) >> 12; // PFN 구하기(==block index)
    char *mem = kalloc(); // get 'empty allocated kernel virtual address'
    if(bitmap[block_number]){
      // 락 걸 것
      // if(kmem.use_lock)
        // release(&kmem.lock);
      swapread(mem, block_number);
      // if(kmem.use_lock)
        // acquire(&kmem.lock);
    }
    uint pte_flag = *pte & 0x00000FFF;
    pte_flag |= PTE_P;  // set FLAG[0]=1
    *pte = V2P(mem) | pte_flag; // set pte[31:12]=PhyAddr(flt_addr) => 맞나?
    lru_append(cp->pgdir, (char*)flt_addr); // lru_append 에 va 인 flt_addr 를 넣는다 => cp=>pgdir 맞나?
    change_bitmap(block_number, 0); // clear corresponding bit in the bitmap
    lcr3(V2P(pde));
  }
  else{
    // panic("swapin don't needed => Code ERROR\n"); //
    return -1;
  }
  // cprintf("swapin ended successfully\n");
  return 0;
}

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
  // My Code
  if(tf->trapno == T_PGFLT){
    int flt_addr = rcr2();
    // cprintf("trap(): T_PGFLT pgdir=%p, rcr2=%p\n",myproc()->pgdir, flt_addr);
    if (swapin(tf, flt_addr) == -1)
    {
      goto KILL;
    }
    return;
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

  KILL:
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
