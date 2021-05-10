// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"

#include "x86.h"

struct page *clock();
char *swapout();

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld
int global_i;

struct run {
  struct run *next; // NULL when Tail
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist; // Head of the Linked List
} kmem;

struct spinlock lock_lru;
int use_lock_lru;
struct spinlock lock_bitmap;
int use_lock_bitmap;

struct page linked_list[LRU_LENGTH]; // LRU_LENGTH = 1536
struct page* head;
int num_free_pages;
int num_lru_pages;  // number of filled linked_list, increment when ????uvm called kalloc

// Update
// char bitmap[BITMAP_SIZE];
int bitmap[BITMAP_SIZE];


void print_bitmap(int from, int to){
  for (int i = from; i <= to;i++){
    cprintf("bitmap[%d]=%d\n", i, bitmap[i]);
  }
}

void change_bitmap(int idx, int val){
  cprintf("change_bitmap: %d %d\n", idx, val);
  bitmap[idx] = val;
  print_bitmap(0, idx + 3);
}

int get_available_bitmap(){ // failed, return -1;
  cprintf("get_available_bitmap: started\n");
  print_bitmap(0,11);
  for (int i = 0; i < BITMAP_SIZE;i++){
    if(bitmap[i]==0){
      cprintf("get_available_bitmap: returning %d\n", i);
      return i;
    }
  }
  cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
  return -1; // NOT FOUND
}

int is_struct_page_available(struct page* node){
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
    return 1;
  return 0;
}

int get_available_linked_list(){
  // cprintf("get_available_linked_list called %d\n",global_i++);
  for (int i = 0; i < LRU_LENGTH;i++){
    if(is_struct_page_available(&(linked_list[i]))){
      return i;
    }
  }
  // cprintf("get_available_linked_list: NO AVAILABLE LINKED LIST\n");
  panic("get_available_linked_list: NO AVAILABLE LINKED LIST\n");
  return -1;
}

void init_lru(){
  cprintf("init_lru called %d\n",global_i++);
  for (int i = 0; i < LRU_LENGTH; i++){
    linked_list[i].next = 0;
    linked_list[i].prev = 0;
    linked_list[i].pgdir = 0;
    linked_list[i].vaddr = 0;
  }
  head = 0;
  num_free_pages = LRU_LENGTH;
  num_lru_pages = 0;
}

void print_linked_list(int sig){
  cprintf("print_linked_list START\n");
  if(sig!=10)
    return;
  cprintf("print_linked_list START2\n");
  if(num_lru_pages==0)
    return;
  cprintf("print_linked_list START3\n");
  struct page *cur = head;
  for (int i = 0; i < num_lru_pages+3;i++){
    if(is_struct_page_available(&(linked_list[i])))
      continue;
    cprintf("print_linked_list START4\n");
    cur = &linked_list[i];
    cprintf("print_linked_list START5\n");
    cprintf(">>>linked_list[%d/%d]: cur->pgdir=%p | cur->vaddr=%p | cur->prev=%p | cur=%p | cur->next=%p\n", i, num_lru_pages, cur->pgdir, cur->vaddr, cur->prev, cur, cur->next);
    pte_t *pte = walkpgdir(cur->pgdir, (void *)cur->vaddr, 1);
    cprintf("print_linked_list START6\n");
    // pte_t *pte = (pte_t*)1;
    cprintf(">>>linked_list[%d/%d]: cur->pgdir=%p | cur->vaddr=%p | *pte=%p | cur->prev=%p | cur=%p | cur->next=%p",\
            i + 1, num_lru_pages, cur->pgdir, cur->vaddr, *pte, cur->prev, cur, cur->next);
    if(cur == head){
      cprintf(" ===> HEAD");
    }
    cprintf("\n");
  }
  cprintf("print_linked_list END\n\n");
}

// Achtung: use USER VIRTUAL ADDRESS
int lru_append(pde_t *pgdir, char* vaddr){ // head 의 next에 ll[idx], 즉 which를 pgdir, vaddr 값으로 append
  int idx = get_available_linked_list(); // get vaddr->0
  // cprintf("lru_append: idx = %d\n", idx);
  struct page *insert = &(linked_list[idx]);

  cprintf("lru_append: started %p %p, insert at idx=%d\n", pgdir, vaddr,idx);
  if(num_free_pages == 0){ // FULL
    panic("PANIC: lru_append: num_free_pages == 0");
    return -1;
  }

  insert->pgdir = pgdir;
  insert->vaddr = vaddr;
  if(num_lru_pages == 0){ // head is NULL -> 0 entry
    cprintf("lru_append: num_lru_pages == 0\n");
    head = insert;
    head->prev = head;
    head->next = head;
  }
  else if(num_lru_pages == 1){
    cprintf("lru_append: num_lru_pages == 1\n");
    head->next = insert;
    head->prev = insert;
    insert->prev = head;
    insert->next = head;

    head = insert;
  }
  else
  {
    cprintf("lru_append: num_lru_pages == %d\n", num_lru_pages);
    struct page *tmp;
    tmp = head->next; // save 3's address
    head->next = insert; // 2->2.5
    insert->next = tmp; // 2.5->3
    insert->prev = head; // 2->2.5
    tmp->prev = insert; // 2.5<-3

    head = insert;
  }
  num_free_pages--;
  num_lru_pages++;
  // cprintf("node: sz %d %p %p appended successfully\n", num_lru_pages,insert->pgdir, insert->vaddr);
  // if(num_lru_pages>1)
    // print_linked_list(10);
  /* cprintf("lru_append: %d/%dth: cur->pgdir=%p | cur->vaddr=%p | cur->prev=%p | cur=%p | cur->next=%p\n", \
   num_lru_pages, num_free_pages, insert->pgdir, insert->vaddr, insert->prev, insert, insert->next); */
  return idx;
}

void lru_delete(struct page* node){ // lru head 라면 next 를 head로
  cprintf("lru_delete: %d/%dth %p %p %p %p delete start\n", num_lru_pages, num_free_pages, node->pgdir, node->vaddr, node->prev, node->next);
  if (num_lru_pages == 0)
  { // 0 entry
    panic("lru_delete: Tried to delete when NO ENTRY here\n");
    return;
  }
  if(node == head){ // 만일 delete하는 노드가 head 라면 head 를 next 로 승계
    head = head->next;
  }
  if(num_lru_pages == 1){ // nokori == only head
    head = 0;
  }
  else{
    node->prev->next = node->next;
    node->next->prev = node->prev;
  }
  num_free_pages++;
  num_lru_pages--;
  node->vaddr = 0;
  node->pgdir = 0;
  cprintf("lru_delete: ended1\n");
  node->next = 0;
  cprintf("lru_delete: ended2\n");
  node->prev = 0;
  cprintf("lru_delete: ended3\n");
  // print_linked_list(10);
  cprintf("lru_delete: %d/%dth %p %p %p %p deleted successfully\n", num_lru_pages,num_free_pages, node->pgdir, node->vaddr, node->prev, node->next);
  cprintf("lru_delete: ended4\n");
  return;
}

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}


// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

//try_again:
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
//  if(!r && reclaim())
//	  goto try_again;
  if(r){
    // cprintf("kalloc if\n");
    kmem.freelist = r->next;
  }
  else{
    // cprintf("***********************SWAPOUT CALLED****************\n");
    r = (struct run*)swapout();
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}



// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v) // kmem.use_lock 해제할것
{ // kernel virtual memory
  struct run *r;
  // cprintf("kfree: just started, v=%p\n", v);

  if((uint)v % PGSIZE){
    cprintf("PANIC1: virtual address is %p\n", v);
    panic("kfree");
  }
  if(v < end){
    cprintf("PANIC2: virtual address is %p\n", v);
    panic("kfree");
  }
  if(V2P(v) >= PHYSTOP){
    cprintf("PANIC3: virtual address is %p\n", v);
    panic("kfree");
  }

  struct page *cur;
  for (int i = 0; i < num_lru_pages; i++){
    // cprintf("kfree: for loop start\n");
    cur = head;
    pte_t *pte = walkpgdir(cur->pgdir, cur->vaddr, 0);
    cprintf("kfree: V2P(%p)==%p ?= PTE_ADDR(%p)==%p\n", v, V2P(v), *pte, PTE_ADDR(*pte));
    // uint pa = (((uint)pte & 0xFFFFF000)); // make physical addr from user.va
    // uint user_pa = (uint)pte >> 12;
    if (V2P(v) == PTE_ADDR(*pte)){ // if page struct's vaddr(user vaddr) points v(kern vaddr)
      cprintf("kfree: LRU list also should be deleted\n");
      lru_delete(cur);
      cprintf("kfree: LRU list deleted completed\n");
      // pte = 0;
    }
  }

  // cprintf("kfree: for loop ended, before memset\n");
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
  // cprintf("kfree: successfully ended\n");
}


char* swapout(){
  if (num_free_pages == 0)
  {
    panic("OOM Error");
  }
  int block_number = get_available_bitmap();
  struct page *victim = clock();
  char *ret = victim->vaddr;
  cprintf("swapout: before swapwrite at block_number=%d\n", block_number);

  if(kmem.use_lock)
    release(&kmem.lock);
  swapwrite((char *)victim, block_number); // 누구를 어디 적었다 이거 기록해놔야할것같은데?
  if(kmem.use_lock)
    acquire(&kmem.lock);
  change_bitmap(block_number, 1); // setup bitmap
  
  // print_bitmap(0, 11);
  // if(num_free_pages>1)
    // print_linked_list(10);
  cprintf("swapout: before kfree: %p %p P2V(PTE_ADDR(vaddr))=%p\n", victim->pgdir, victim->vaddr, P2V(PTE_ADDR(victim->vaddr)));
  if(kmem.use_lock)
    release(&kmem.lock);
  kfree(P2V(PTE_ADDR(victim->vaddr)));     // free victim page
  if(kmem.use_lock)
    acquire(&kmem.lock);

  // victim->vaddr 은 kfree 에서 LRU에서 제거되었을 것이므로 필요없음
  // lru_delete(victim);       // remove victim page from lru list
  cprintf("swapout: Does Victim Really Deleted from LRU? %p %p %p %p\n", victim->pgdir, victim->vaddr, victim->prev, victim->next);

  cprintf("swapout: before walkpgdir: %p %p\n", victim->pgdir, victim->vaddr);
  pte_t* pte = walkpgdir(victim->pgdir, victim->vaddr, 1);
  pte_t tmp_pte = block_number << 12; // PFN
  tmp_pte |= ((*pte) & 0x00000FFE);   // clear the PTE_P
  *pte = tmp_pte;
  cprintf("swapout: walkpgdir succeed: %p %p\n", victim->pgdir, victim->vaddr);
  lcr3(V2P(victim->pgdir)); // flush TLB
  cprintf("swapout: walkpgdir succeed: %p %p\n", victim->pgdir, victim->vaddr);


  cprintf("SWAPOUT ENDED SUCCESSFULLY, returning %p\n", ret);
  return P2V(PTE_ADDR(*ret));
}

// my code
struct page* clock(){ // only select victim, not killing yet
  int finished = 0;
  struct page *ret;
  for (; !finished; head = head->prev)
  {
    if (!(head->vaddr)){
      panic("clock: invalid head");
    }
    cprintf("clock: scanning node %p %p\n", head->pgdir, head->vaddr);
    pte_t *cur_pte = walkpgdir(head->pgdir, head->vaddr, 1);
    int pte_a = (*cur_pte & PTE_A);
    if (pte_a){ // if PTE_A == 1
      cprintf("cur_pte cleared: %p -> %p\n", *cur_pte, (*cur_pte) & (~PTE_A));
      *cur_pte &= ~(PTE_A);
      continue;
    }
    else
    {
      // if PTE_A == 0, swap out this page => do at swapout
      finished = 1;
      ret = head;
      cprintf("clock: Victim selected: %p %p\n", head->pgdir, head->vaddr);
      cprintf("clock: Victim selected: cur->pgdir=%p | cur->vaddr=%p | cur->prev=%p | cur=%p | cur->next=%p\n", ret->pgdir, ret->vaddr, ret->prev, ret, ret->next);
    }
  }
  cprintf("clock: finally ret %p != head %p\n", ret, head);
  cprintf("clock ended successfully\n");
  return ret;
}