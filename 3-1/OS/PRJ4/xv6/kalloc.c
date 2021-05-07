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

#define BITMAP_SIZE 32767 // My Code
#define PTE_A 0x20
#define LRU_LENGTH PHYSTOP/PGSIZE

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run {
  struct run *next; // NULL when Tail
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist; // Head of the Linked List
} kmem;

struct page linked_list[LRU_LENGTH];
struct LRU{
  struct page* head;
  char is_used[LRU_LENGTH]; // 0: available, 1: filled => 굳이 필요하려나?
  int num_free_pages;
  int num_lru_pages;  // number of filled linked_list, increment when ????uvm called kalloc
} LRU_hontai;
struct LRU *lru = &(LRU_hontai);

// Update
char bitmap[BITMAP_SIZE];

int get_available_bitmap(){ // failed, return -1;
  for (int i = 0; i < BITMAP_SIZE;i++){
    if(bitmap[i]==0)
      return i;
  }
  cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
  return -1; // NOT FOUND
}

int get_available_linked_list(){
  for (int i = 0; i < LRU_LENGTH;i++){
    if(lru->is_used[i]){
      return i;
    }
  }
  return -1;
}

void init_lru(){
  for (int i = 0; i < LRU_LENGTH; i++){
    linked_list[i].next = 0;
    linked_list[i].prev = 0;
    linked_list[i].pgdir = 0;
    linked_list[i].vaddr = 0;
    lru->is_used[i] = 0;
  }
  lru->head = 0;
  lru->num_free_pages = LRU_LENGTH;
  lru->num_lru_pages = 0;
}

int lru_append(struct page *at, pde_t *pgdir, char* vaddr){ // at 의 next에 ll[idx], 즉 which를 pgdir, vaddr 값으로 append
  int idx = get_available_linked_list();
  struct page *which = &(linked_list[idx]);
  if (at->vaddr == 0)
    return -1;
  struct page *nextnext;
  nextnext = at->next;
  at->next = which;
  which->next = nextnext;
  which->prev = at;
  nextnext->prev = which;

  which->pgdir = pgdir;
  which->vaddr = vaddr;
  return 0;
}

void lru_delete(struct page* node){ // lru head 라면 next 를 head로
  node->vaddr = 0;
  node->prev->next = (node->next);
  node->next->prev = (node->prev);
  if(node == lru->head){
    lru->head = node->next;
  }
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
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}

// my code
struct page* clock(){
  for (;;lru->head=lru->head->prev){
    if(lru->head->vaddr){
      pte_t *cur_pte = walkpgdir(lru->head->pgdir, lru->head->vaddr, 1);
      if(*cur_pte&PTE_A){     // if PTE_A == 1
        *cur_pte |= ~(PTE_A);
      }
      else
      { 
        // if PTE_A == 0, swap out this page
        // HOW?
      }
    }
  }
}

void no_freepg(){
  if(lru->num_free_pages == 0){
    panic("OOM Error");
  }
  int empty_bitmap = get_available_bitmap();
  struct page *victim = clock();
  swapwrite((char*)victim, empty_bitmap); // 누구를 어디 적었다 이거 기록해놔야할것같은데?
  pte_t* pte = walkpgdir(victim->pgdir, victim->vaddr, 1);
  if(pte == 0){
    panic("no_freepg: walkpgdir failed");
  }
  pte_t tmp_pte = empty_bitmap << 12;
  tmp_pte |= ((*pte) & 0x00000FFE);   // update pte
  lru_delete(victim);       // remove victim page from lru list
  bitmap[empty_bitmap] = 1; // setup bitmap
  lcr3(V2P(victim->pgdir)); // flush TLB
  kfree(victim->vaddr);
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
    kmem.freelist = r->next;
  }
  else{
    no_freepg();
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

