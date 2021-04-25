#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

// my code
// #include "file.h"
// #include "string.h"
// #define VMASTART PGROUNDDOWN(MAXVA - 2 * PGSIZE)

struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE } type;
  int ref; // reference count
  char readable;
  char writable;
  struct pipe *pipe;
  struct inode *ip;
  uint off;
};

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  // my code
  for (int i=0; i < 100;i++){
    p->vmas[i].fd = 0;
  }
  p->vmas_cnt = 0;
  p->vmas_sz = 0;
  // my code end

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  // My Code
  /*
  if p has mmap area => unmap it
  if mmaped physical area exist => free it
  */

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

void pagefaulthandler(){
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
}

/*
void *mmap2(int fd, int offset, int length, int flags){
  struct proc *curproc = myproc();
  //uint cur_max = curproc->cur_max;
  uint start_addr = PGROUNDDOWN(cur_max - length);

  struct VMA *vm = 0;
  for (int I=0; I<100; I++) {
    if (curproc->vmas[I].valid == 0) {
      vm = &curproc->vmas[I];
      break;
    }
  }
  if (vm) {
    vm->valid = 1;
    vm->start_ad = start_addr;
    vm->end_ad = cur_max;
    vm->len = length;
    vm->prot = flags;
    vm->flags = flags;
    vm->fd = fd;
    vm->file = curproc->ofile[fd];
    vm->file->ref++;
    // reset process current max available
    //curproc->cur_max = start_addr;
  } else {
    return MAP_FAILED;
  }
  return start_addr;
}
*/

int is_mmap_available(struct file* fp, int fd, int flags){
  if(!((flags&MAP_PROT_READ)||(flags&MAP_PROT_WRITE))) return -1;
  if(fd!=-1){ // file backed mapping 인 경우, flag 고려 필요
    if(fp->readable!=0 && fp->writable==0){ // O_RDONLY
      if((flags&MAP_PROT_READ)&&(!(flags&MAP_PROT_WRITE))) return -1;
    } else if (fp->readable != 0 && fp->writable != 0) { // O_RDWR
      if(!((flags&MAP_PROT_READ)||(flags&MAP_PROT_WRITE))) return -1; // 솔직히 필요없긴한데
    }
  }
  return 0;
}

void* mmap_fileback_prepaging(int fd, int offset, int length, int flags, struct file* fp){
  // struct proc *p = myproc();

  // pde_t *pgdir = (p->pgdir);
  // char *mem;
  
  // uint start_va = p->sz + p->vmas_sz;
  // uint end_va = p->sz + p->vmas_sz + length;
  // uint tmp_va;
  // for (tmp_va = start_va; tmp_va < end_va; tmp_va += PGSIZE){
  //   mem = kalloc();
  //   if(mem == 0){
  //     panic(" Not enough Memory. kalloc failed during mmap.\n");
  //     return -1;
  //   }
  //   memset(mem, 0, PGSIZE); // 일단 lazy allocation 이니 0으로 초기화
  //   mappages(pgdir, (char *)tmp_va, PGSIZE, V2P(mem), PTE_W | PTE_U);
  //   while(fileread(fp, tmp_va, 1)>0){
  //     ;
  //   }
  //   //readi(fp->ip, (char *)tmp_va, end_va - start_va, PGSIZE);
  // }
  // p->vmas_sz += length;
  // switchuvm(p);
  // return start_va;
  
  /* Your Code */
  // pde_t *pgdir = proc->pgdir;
  // char * mem;

  // uint oldsz = proc->mmap_sz + MMAP_BASE;
  // uint fsz =  PGROUNDUP(oldsz + f->ip->size);
  // uint newsz = oldsz;
  // uint a;
  // for(a = PGROUNDUP(oldsz); a < fsz; a += PGSIZE, newsz += PGSIZE) {
  //   mem = kalloc();
  //   if(mem == 0) { 
  //     return -1;
  //   }
  //   memset(mem, 0, PGSIZE);
  //   mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  //   readi(f->ip, (char*)a, newsz-oldsz, PGSIZE);
  // }
  // proc->mmap_sz = newsz-MMAP_BASE;
  // switchuvm(proc);
  // return oldsz;

}

void* mmap_fileback_demandpaging(int fd, int offset, int length, int flags, struct file* fp){
  struct proc *p = myproc();
  pde_t *pgdir = (p->pgdir);
  char *mem;
  
  uint start_va = p->sz + p->vmas_sz;
  uint end_va = p->sz + p->vmas_sz + length;
  uint tmp_va;

  struct VMA *vma = &(p->vmas[p->vmas_cnt]);
  p->vmas_cnt++;
  vma->start_ad = (char *)(p->sz + p->vmas_sz);
  vma->end_ad = (char *)(p->sz + p->vmas_sz);

  /* Your Code */
  // uint oldsz = proc->mmap_sz + MMAP_BASE; // pointer to last (accessible) byte in mmap region (currently, not absolutely)
  // // make a new lazy-mmap job
  // struct mmap_job *job = &(proc->mmjobs[proc->mmjobs_count]);
  // proc->mmjobs_count++; 
  // job->beg = (char*) proc->mmap_sz + MMAP_BASE; // inclusive
  // job->end = (char*) PGROUNDUP((uint) (job->beg + f->ip->size)); // exclusive
  // job->fd = fd;
  // job->f = f;
  // proc->mmap_sz += (uint) (job->end - job->beg); // reserve mmap-region space, but don't allocate or map yet

  /* reset is handled by sys_lazymm() 
  which wil be called by trap.c on pagefault */

  // return oldsz; // we promise to load file into this virtual address

  return -1;
}

void* mmap_anonymous_prepaging(int fd, int offset, int length, int flags, struct file* fp){
  struct proc *p = myproc();

  pde_t *pgdir = (p->pgdir);
  char *mem;
  
  uint start_va = p->sz + p->vmas_sz;
  uint end_va = p->sz + p->vmas_sz + length;
  uint tmp_va;
  for (tmp_va = start_va; tmp_va < end_va; tmp_va += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      panic(" Not enough Memory. kalloc failed during mmap.\n");
      return -1;
    }
    memset(mem, 0, PGSIZE); // 일단 lazy allocation 이니 0으로 초기화
    mappages(pgdir, (char *)tmp_va, PGSIZE, V2P(mem), PTE_W | PTE_U);
    //readi(fp->ip, (char *)tmp_va, end_va - start_va, PGSIZE);
  }
  p->vmas_sz += length;
  switchuvm(p);
  return start_va;

  return -1;
}

void* mmap_anonymous_demandpaging(int fd, int offset, int length, int flags, struct file* fp){
  // struct proc *p = myproc();
  // int found = 0;
  // int i;
  // struct VMA *vma = 0;
  // for (i = 0; i < 100;i++){
  //   if(p->vmas[i].fd!=0){
  //     vma = &p->vmas[i];
  //     p->vmas_cnt = i;
  //     break;
  //   }
  // }
  // if(found==0) return -1;
  // if(vma){
  //   uint vm_beg = PGROUNDDOWN()
  //   uint vm_end = PGROUNDDOWN(p->sz+)
  // }
  // return 0;
  return -1;
}

void *mmap(int fd, int offset, int length, int flags){
  if(length%4096!=0) return MAP_FAILED;
  struct proc *curproc = myproc();
  struct file *fp = curproc->ofile[fd];
  if(is_mmap_available(fp, fd, flags)==-1) return MAP_FAILED;
  if((flags&MAP_POPULATE)){ // prepaging
    if(fd==-1){
      cprintf("mmap_anonymous_prepaging called\n");
      return mmap_anonymous_prepaging(fd, offset, length, flags, fp);
    } 
    else{
      cprintf("mmap_fileback_prepaging called\n");
      return mmap_fileback_prepaging(fd, offset, length, flags, fp);
    }
  }
  else{
    if(fd==-1){
      cprintf("mmap_anonymous_demandpaging called\n");
      return mmap_anonymous_demandpaging(fd, offset, length, flags, fp);
    }
    else{
      cprintf("mmap_fileback_prepaging called\n");
      return mmap_fileback_prepaging(fd, offset, length, flags, fp);
    } 
  }
  return MAP_FAILED;
}

int munmap(void* addr, int length){
  int addr_int = *((int *)addr);
  if (addr_int % 4096 != 0) return -1;
  if (length % 4096 != 0) return -1;

  // uint start_base = PGROUNDDOWN(addr_int);
  // uint end_base = PGROUNDDOWN(addr_int+length);
  cprintf("munmap returned successfully\n");
  return 0; // success
}

// My Code End