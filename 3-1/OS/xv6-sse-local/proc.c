#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

//My Code
#define MINIMUM_INT (int)0x80000000
#define MAXIMUM_INT (int)0x7FFFFFFF
//My Code End

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
  // My Code
  p->priority=0;	// Process's Default Priority is 0 
//  p->starttime=ticks;
  p->runtime=0;
//  p->endtime=0;
  // My Code End

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
  // My Code
  np->priority = curproc->priority; 	// Child Inherits Parent's nice
  np->vruntime = curproc->vruntime;	// Child Inherits Parent's vruntime
  // My Code End
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
  // My code
  //curproc->endtime=ticks;

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

// My Code
int nice2weight_arr[11] = {3121, 2501, 1991, 1586, 1277, 1024, 820, 655, 526, 423, 335};
int nice2weight(int nice){
	int idx = nice+5;
	return nice2weight_arr[idx];
}
// My Code End

int total_weight_of_runnable_process(){
	struct proc *p1;
	uint ret=0;	
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
	if(p1->state!=RUNNABLE)				// Select RUNNABLE Only
		continue;
	else
		ret+=nice2weight(p1->priority);
      }
      return ret;
}

// My Code
//long long ceil(long long a, long long b){ // return ceil(a/b)
//	return (a+b-1)/b;
//}
// My Code End


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
  struct proc *p, *p1;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // My Code
    struct proc *low_vruntime_p;
    // My Code End
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
 
      // My Code
      // 1. Pick the lowest vruntime Process in for loop
      // 2. Set Weight, Timeslice of next process
      // 3. Reset runtime, starttime of next process
      // cprintf("scheduler entered\n");
      low_vruntime_p = p;
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
	if(p1->state!=RUNNABLE)				// Select RUNNABLE Only
		continue;
	if(low_vruntime_p->vruntime > p1->vruntime) // Lower vruntime, Highter Real-Priority
		low_vruntime_p=p1;
      }
      // cprintf("process name == %s\n", p->name);
      p=low_vruntime_p;
      p->weight=nice2weight(p->priority);
//      p->starttime=ticks;
//      p->runtime=0;
      p->runtime_interval=0;
      uint total_weight = total_weight_of_runnable_process();
      uint weight_by_10 = 10*(p->weight);
      int time_slice = (1000*weight_by_10 + total_weight - 1) / (total_weight); // Ceil(10*1000*W/sum(W))
      p->timeslice=time_slice; // Get Time Slice

      // My Code End

      // Routine to select The Next Process
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      // Call swtch to change context of CPU from Scheduler to the context of NEXT PROCESS 
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
{// Invoking Dispatcher
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
  struct proc *p, *p1;
  // My Code
  int min_vruntime = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	  if(p->state == RUNNING || p-> state == RUNNABLE){
		  if(min_vruntime>p->vruntime){
		//	      cprintf("541th: min_vruntime %d <- %d\n", min_vruntime, p->vruntime);
			  min_vruntime=p->vruntime;
		  }
	  }
  }
  int notempty=0; // 0 means All Processes are Sleeping
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == SLEEPING && p->chan == chan){
      p->state = RUNNABLE;
      //cprintf("Process %s woken up\n",p->name);
      for(p1 = ptable.proc; p1<&ptable.proc[NPROC];p1++){	// Update min_vruntime
        if(p->pid == p1->pid)     // Piazza Notice: Don't count self-vruntime at minimum
          continue;
        if (p1->state == RUNNING || p1->state == RUNNABLE)
        {
          notempty=1; // At least one process is NOT sleeping
		      if(min_vruntime>p1->vruntime){
		//	      cprintf("557th: min_vruntime %d <- %d\n", min_vruntime, p1->vruntime);
			      min_vruntime=p1->vruntime;
		      }
        }
      }
      if(notempty){
      		int one_tick_vruntime = (1000*1024)/nice2weight(p->priority);
		//cprintf("min_vruntime(%d) VS -1*one_tick_vruntime(%d)\n",min_vruntime,-1*one_tick_vruntime);
          if(is_overflow(min_vruntime, -1*one_tick_vruntime)){
		  //cprintf("proc.c 564th: OVERFLOW HAPPENED\n");
            p->vruntime = MINIMUM_INT;
          }
          else{
		 // cprintf("proc.c 568th: OVERFLOW NOT HAPPENED\n");
            p->vruntime=min_vruntime-one_tick_vruntime;
          }
      }
      else{
		    p->vruntime=0;
      }
    }
  }
  // My Code End
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

// My code
int setnice(int pid, int nice){ // Set Process Priority, Args: PID, Nice, Return val: fail->-1 success->0
	struct proc* p;
	int success=0;
	if(nice<-5 || nice>5) return -1;
	acquire(&ptable.lock);
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
		if(p->pid==pid){
			p->priority=nice;
			success=1;
			break;
		}
	}
	release(&ptable.lock);
//	cprintf("SETNICE returned %d\n",success);
	if(success) return 0;
	else return -1;
}

int getnice(int pid){ // Return Process Priority, Args: PID, Return value: Can't find PID -> -1, else nice
	struct proc* p;
	int ret=0;
	int success=0;
	acquire(&ptable.lock);
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
		if(p->pid==pid){
			ret=p->priority;
			success=1;
		}
	}
	release(&ptable.lock);
//	cprintf("GETNICE returned %d with success %d\n",ret,success);
	if(success) return ret;
	else return -1;
}

void str_align_print(char* str){ // print %10s
	const int width = 15;
	int length=0;
	while(str[length]!=0){
		length++;
	}
	int diff = width - length;
	cprintf("%s",str);
	while(diff--){
		cprintf(" ");
	}
}

void int_align_print(int num){ // print %10d
	const int width = 15;
	int maxdigit=0;
	int tmp = num;
	while(tmp!=0){
		tmp/=10;
		maxdigit++;
	}
	if(num==0)
		maxdigit=1;
	int diff = width - maxdigit;
	cprintf("%d",num);
	while(diff--){
		cprintf(" ");
	}
}

void align_print(struct proc* p, char* status){
	str_align_print(p->name);
	cprintf(" ");
	int_align_print(p->pid);
	cprintf(" ");
	str_align_print(status);
	cprintf(" ");
	int_align_print(p->priority);
	cprintf(" ");
	int_align_print(p->runtime / nice2weight(p->priority));
	cprintf(" ");
	int_align_print(p->runtime);
	cprintf(" ");
	int_align_print(p->vruntime);
	cprintf("\n");
}
void align_print_init(){
	str_align_print("name");
	cprintf(" ");
	str_align_print("pid");
	cprintf(" ");
	str_align_print("state");
	cprintf(" ");
	str_align_print("priority");
	cprintf(" ");
	str_align_print("runtime/weight");
	cprintf(" ");
	str_align_print("runtime");
	cprintf(" ");
	str_align_print("vruntime");
	cprintf(" ");
	cprintf("tick: %d \n", ticks);
}



int is_overflow(int a, int b){ // Does a+b OVERFLOWS? => 1 == true, 0 == false
  if (b > 0){ // a + |b|
    if(a>MAXIMUM_INT-b){
      return 1;
    }
  }
  else if(b<0){ // a - |b|
    if(a<MINIMUM_INT-b){
      return 1;
    }
  }
  return 0;
}

void overflow_handler(int i){ // if i == 1, UP OVFL, i == -1, DOWN OVFL
	struct proc* p;
  //cprintf("OVERFLOW HANDLING\n");
  if (i > 0){ // SOMEONE OVERED MAX
    for(p=ptable.proc; p<&ptable.proc[NPROC];p++){
			if(p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING){
          int diff = (int)0x0FFFFFFF*-1;
          if(is_overflow(p->vruntime, diff)){ // during minus, overflow detected, saturate it
            p->vruntime = MINIMUM_INT;
          }
          else{
            p->vruntime += diff;
          }
		  }
	  }
  }
  else if(i<0){ // SOMEONE UNDERED MIN
  	for(p=ptable.proc; p<&ptable.proc[NPROC];p++){
			if(p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING){
        int diff = (int)0x0FFFFFFF;
        if(is_overflow(p->vruntime, diff)){ // during plus, OVERFLOW detected, Saturate it
          p->vruntime = MAXIMUM_INT;
        }
        else{
          p->vruntime += diff;	// Else, Simply Add them
        }
			}
		}
	}
	else{
		//cprintf("VRUNTIME_OVERFLOW_HANDLER'S ARGUMENT Can't be 0\n");
    return;
  }
  return;
}

void ps(){
	struct proc* p;
	sti();
	acquire(&ptable.lock);
	p=ptable.proc;
/*	cprintf("name \t\t pid \t\t state \t\t priority \t\t runtime/weight \t\t \
			runtime \t\t vruntime \t\t tick: %d \n",ticks * 1000);
*/
	align_print_init();
	for(;p<&ptable.proc[NPROC];p++){
		if(p->state==SLEEPING){
			align_print(p,"SLEEPING");
		}
		else if(p->state==RUNNING){
			align_print(p,"RUNNING");
		}
		else if(p->state==RUNNABLE){
			align_print(p,"RUNNABLE");
		}
//		else if(p->state==UNUSED){
//			cprintf("%s \t %d \t UNUSED \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
//		}
//		else if(p->state==EMBRYO){
//			align_print(p,"EMBRYO");
//		}
		else if(p->state==ZOMBIE){
			align_print(p,"ZOMBIE");
		}
	}
//	cprintf("ps command ENDED\n");
	release(&ptable.lock);
	return;
}
