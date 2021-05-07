
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 33 10 80       	mov    $0x801033c0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 a0 75 10 80       	push   $0x801075a0
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 11 47 00 00       	call   80104770 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 75 10 80       	push   $0x801075a7
80100097:	50                   	push   %eax
80100098:	e8 93 45 00 00       	call   80104630 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 03 48 00 00       	call   801048f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 49 48 00 00       	call   801049b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 44 00 00       	call   80104670 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 21 00 00       	call   80102390 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ae 75 10 80       	push   $0x801075ae
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 49 45 00 00       	call   80104710 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 21 00 00       	jmp    80102390 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 75 10 80       	push   $0x801075bf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 08 45 00 00       	call   80104710 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 b8 44 00 00       	call   801046d0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 cc 46 00 00       	call   801048f0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 3b 47 00 00       	jmp    801049b0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 75 10 80       	push   $0x801075c6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 3a 46 00 00       	call   801048f0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 c6 3f 00 00       	call   801042b0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 e1 39 00 00       	call   80103ce0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 9d 46 00 00       	call   801049b0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 46 46 00 00       	call   801049b0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 6e 28 00 00       	call   80102c20 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 75 10 80       	push   $0x801075cd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 83 7f 10 80 	movl   $0x80107f83,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 af 43 00 00       	call   80104790 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 75 10 80       	push   $0x801075e1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 51 5d 00 00       	call   80106180 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 66 5c 00 00       	call   80106180 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 5a 5c 00 00       	call   80106180 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 4e 5c 00 00       	call   80106180 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 3a 45 00 00       	call   80104aa0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 44 00 00       	call   80104a00 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 75 10 80       	push   $0x801075e5
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 10 76 10 80 	movzbl -0x7fef89f0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 8c 42 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 14 43 00 00       	call   801049b0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb f8 75 10 80       	mov    $0x801075f8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 2e 41 00 00       	call   801048f0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 83 41 00 00       	call   801049b0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 75 10 80       	push   $0x801075ff
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 74 40 00 00       	call   801048f0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 dc 3f 00 00       	call   801049b0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 5c 3b 00 00       	jmp    80104560 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 4b 3a 00 00       	call   80104470 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 08 76 10 80       	push   $0x80107608
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 27 3d 00 00       	call   80104770 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 1a 00 00       	call   80102540 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 4b 32 00 00       	call   80103ce0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 10 26 00 00       	call   801030b0 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 38 26 00 00       	call   80103120 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 ef 67 00 00       	call   80107300 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 a8 65 00 00       	call   80107120 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 a2 64 00 00       	call   80107050 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 90 66 00 00       	call   80107280 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 fa 24 00 00       	call   80103120 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 e9 64 00 00       	call   80107120 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 48 67 00 00       	call   801073a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 58 3f 00 00       	call   80104c00 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 45 3f 00 00       	call   80104c00 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 44 68 00 00       	call   80107510 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 9a 65 00 00       	call   80107280 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 d8 67 00 00       	call   80107510 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 4a 3e 00 00       	call   80104bc0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 1e 61 00 00       	call   80106ec0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 d6 64 00 00       	call   80107280 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 67 23 00 00       	call   80103120 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 21 76 10 80       	push   $0x80107621
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 2d 76 10 80       	push   $0x8010762d
80100def:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df4:	e8 77 39 00 00       	call   80104770 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e15:	e8 d6 3a 00 00       	call   801048f0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 6a 3b 00 00       	call   801049b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 51 3b 00 00       	call   801049b0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e83:	e8 68 3a 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea0:	e8 0b 3b 00 00       	call   801049b0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 34 76 10 80       	push   $0x80107634
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed5:	e8 16 3a 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 9b 3a 00 00       	call   801049b0 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 6d 3a 00 00       	jmp    801049b0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 63 21 00 00       	call   801030b0 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 b9 21 00 00       	jmp    80103120 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 02 29 00 00       	call   80103880 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 3c 76 10 80       	push   $0x8010763c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 b6 29 00 00       	jmp    80103a20 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 46 76 10 80       	push   $0x80107646
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 2a 20 00 00       	call   80103120 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 91 1f 00 00       	call   801030b0 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 ca 1f 00 00       	call   80103120 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 4f 76 10 80       	push   $0x8010764f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 8a 27 00 00       	jmp    80103920 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 55 76 10 80       	push   $0x80107655
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011b9:	8b 0d c4 09 11 80    	mov    0x801109c4,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 dc 09 11 80    	add    0x801109dc,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
80101202:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101207:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	89 fa                	mov    %edi,%edx
8010121b:	85 df                	test   %ebx,%edi
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 b4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c4 09 11 80    	cmp    %eax,0x801109c4
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 5f 76 10 80       	push   $0x8010765f
80101259:	e8 32 f1 ff ff       	call   80100390 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 1e 20 00 00       	call   80103290 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 76 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101285:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101288:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010128a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 66 37 00 00       	call   80104a00 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 ee 1f 00 00       	call   80103290 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 46 ef ff ff       	call   801001f0 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012bf:	90                   	nop

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	89 c7                	mov    %eax,%edi
801012c6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c7:	31 f6                	xor    %esi,%esi
{
801012c9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 00 0a 11 80       	push   $0x80110a00
801012da:	e8 11 36 00 00       	call   801048f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801012e2:	83 c4 10             	add    $0x10,%esp
801012e5:	eb 1b                	jmp    80101302 <iget+0x42>
801012e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ee:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012f0:	39 3b                	cmp    %edi,(%ebx)
801012f2:	74 6c                	je     80101360 <iget+0xa0>
801012f4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101300:	73 26                	jae    80101328 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101302:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101305:	85 c9                	test   %ecx,%ecx
80101307:	7f e7                	jg     801012f0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e7                	jne    801012f4 <iget+0x34>
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101315:	85 c9                	test   %ecx,%ecx
80101317:	75 6e                	jne    80101387 <iget+0xc7>
80101319:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131b:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101321:	72 df                	jb     80101302 <iget+0x42>
80101323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101327:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101328:	85 f6                	test   %esi,%esi
8010132a:	74 73                	je     8010139f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010132c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010132f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101331:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101334:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010133b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101342:	68 00 0a 11 80       	push   $0x80110a00
80101347:	e8 64 36 00 00       	call   801049b0 <release>

  return ip;
8010134c:	83 c4 10             	add    $0x10,%esp
}
8010134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101352:	89 f0                	mov    %esi,%eax
80101354:	5b                   	pop    %ebx
80101355:	5e                   	pop    %esi
80101356:	5f                   	pop    %edi
80101357:	5d                   	pop    %ebp
80101358:	c3                   	ret    
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101360:	39 53 04             	cmp    %edx,0x4(%ebx)
80101363:	75 8f                	jne    801012f4 <iget+0x34>
      release(&icache.lock);
80101365:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101368:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010136b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010136d:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
80101372:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101375:	e8 36 36 00 00       	call   801049b0 <release>
      return ip;
8010137a:	83 c4 10             	add    $0x10,%esp
}
8010137d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101380:	89 f0                	mov    %esi,%eax
80101382:	5b                   	pop    %ebx
80101383:	5e                   	pop    %esi
80101384:	5f                   	pop    %edi
80101385:	5d                   	pop    %ebp
80101386:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101387:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010138d:	73 10                	jae    8010139f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101392:	85 c9                	test   %ecx,%ecx
80101394:	0f 8f 56 ff ff ff    	jg     801012f0 <iget+0x30>
8010139a:	e9 6e ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 75 76 10 80       	push   $0x80107675
801013a7:	e8 e4 ef ff ff       	call   80100390 <panic>
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	89 c6                	mov    %eax,%esi
801013b7:	53                   	push   %ebx
801013b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013bb:	83 fa 0b             	cmp    $0xb,%edx
801013be:	0f 86 84 00 00 00    	jbe    80101448 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013c7:	83 fb 7f             	cmp    $0x7f,%ebx
801013ca:	0f 87 98 00 00 00    	ja     80101468 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013d6:	8b 16                	mov    (%esi),%edx
801013d8:	85 c0                	test   %eax,%eax
801013da:	74 54                	je     80101430 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013dc:	83 ec 08             	sub    $0x8,%esp
801013df:	50                   	push   %eax
801013e0:	52                   	push   %edx
801013e1:	e8 ea ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013e6:	83 c4 10             	add    $0x10,%esp
801013e9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013ed:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013ef:	8b 1a                	mov    (%edx),%ebx
801013f1:	85 db                	test   %ebx,%ebx
801013f3:	74 1b                	je     80101410 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	57                   	push   %edi
801013f9:	e8 f2 ed ff ff       	call   801001f0 <brelse>
    return addr;
801013fe:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101404:	89 d8                	mov    %ebx,%eax
80101406:	5b                   	pop    %ebx
80101407:	5e                   	pop    %esi
80101408:	5f                   	pop    %edi
80101409:	5d                   	pop    %ebp
8010140a:	c3                   	ret    
8010140b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010140f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101410:	8b 06                	mov    (%esi),%eax
80101412:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101415:	e8 96 fd ff ff       	call   801011b0 <balloc>
8010141a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010141d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101420:	89 c3                	mov    %eax,%ebx
80101422:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101424:	57                   	push   %edi
80101425:	e8 66 1e 00 00       	call   80103290 <log_write>
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	eb c6                	jmp    801013f5 <bmap+0x45>
8010142f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101430:	89 d0                	mov    %edx,%eax
80101432:	e8 79 fd ff ff       	call   801011b0 <balloc>
80101437:	8b 16                	mov    (%esi),%edx
80101439:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010143f:	eb 9b                	jmp    801013dc <bmap+0x2c>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101448:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010144b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010144e:	85 db                	test   %ebx,%ebx
80101450:	75 af                	jne    80101401 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101452:	8b 00                	mov    (%eax),%eax
80101454:	e8 57 fd ff ff       	call   801011b0 <balloc>
80101459:	89 47 5c             	mov    %eax,0x5c(%edi)
8010145c:	89 c3                	mov    %eax,%ebx
}
8010145e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101461:	89 d8                	mov    %ebx,%eax
80101463:	5b                   	pop    %ebx
80101464:	5e                   	pop    %esi
80101465:	5f                   	pop    %edi
80101466:	5d                   	pop    %ebp
80101467:	c3                   	ret    
  panic("bmap: out of range");
80101468:	83 ec 0c             	sub    $0xc,%esp
8010146b:	68 85 76 10 80       	push   $0x80107685
80101470:	e8 1b ef ff ff       	call   80100390 <panic>
80101475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101480 <readsb>:
{
80101480:	f3 0f 1e fb          	endbr32 
80101484:	55                   	push   %ebp
80101485:	89 e5                	mov    %esp,%ebp
80101487:	56                   	push   %esi
80101488:	53                   	push   %ebx
80101489:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010148c:	83 ec 08             	sub    $0x8,%esp
8010148f:	6a 01                	push   $0x1
80101491:	ff 75 08             	pushl  0x8(%ebp)
80101494:	e8 37 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101499:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010149c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010149e:	8d 40 5c             	lea    0x5c(%eax),%eax
801014a1:	6a 1c                	push   $0x1c
801014a3:	50                   	push   %eax
801014a4:	56                   	push   %esi
801014a5:	e8 f6 35 00 00       	call   80104aa0 <memmove>
  brelse(bp);
801014aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014ad:	83 c4 10             	add    $0x10,%esp
}
801014b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014b3:	5b                   	pop    %ebx
801014b4:	5e                   	pop    %esi
801014b5:	5d                   	pop    %ebp
  brelse(bp);
801014b6:	e9 35 ed ff ff       	jmp    801001f0 <brelse>
801014bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014bf:	90                   	nop

801014c0 <bfree>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	89 c6                	mov    %eax,%esi
801014c6:	53                   	push   %ebx
801014c7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 c4 09 11 80       	push   $0x801109c4
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 dc 09 11 80    	add    0x801109dc,%eax
801014e4:	50                   	push   %eax
801014e5:	56                   	push   %esi
801014e6:	e8 e5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014f0:	ba 01 00 00 00       	mov    $0x1,%edx
801014f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101503:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 25                	je     80101531 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010150c:	f7 d2                	not    %edx
  log_write(bp);
8010150e:	83 ec 0c             	sub    $0xc,%esp
80101511:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101513:	21 ca                	and    %ecx,%edx
80101515:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101519:	50                   	push   %eax
8010151a:	e8 71 1d 00 00       	call   80103290 <log_write>
  brelse(bp);
8010151f:	89 34 24             	mov    %esi,(%esp)
80101522:	e8 c9 ec ff ff       	call   801001f0 <brelse>
}
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152d:	5b                   	pop    %ebx
8010152e:	5e                   	pop    %esi
8010152f:	5d                   	pop    %ebp
80101530:	c3                   	ret    
    panic("freeing free block");
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	68 98 76 10 80       	push   $0x80107698
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 ab 76 10 80       	push   $0x801076ab
80101555:	68 00 0a 11 80       	push   $0x80110a00
8010155a:	e8 11 32 00 00       	call   80104770 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 b2 76 10 80       	push   $0x801076b2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 b4 30 00 00       	call   80104630 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c4 09 11 80       	push   $0x801109c4
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 dc 09 11 80    	pushl  0x801109dc
8010159d:	ff 35 d8 09 11 80    	pushl  0x801109d8
801015a3:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015a9:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015af:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015b5:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015bb:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015c1:	68 34 77 10 80       	push   $0x80107734
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d cc 09 11 80 01 	cmpl   $0x1,0x801109cc
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d cc 09 11 80    	cmp    0x801109cc,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 9d 33 00 00       	call   80104a00 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 1b 1c 00 00       	call   80103290 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 30 fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 b8 76 10 80       	push   $0x801076b8
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 96 33 00 00       	call   80104aa0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 7e 1b 00 00       	call   80103290 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 00 0a 11 80       	push   $0x80110a00
80101743:	e8 a8 31 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101753:	e8 58 32 00 00       	call   801049b0 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 e5 2e 00 00       	call   80104670 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 a3 32 00 00       	call   80104aa0 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 d0 76 10 80       	push   $0x801076d0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ca 76 10 80       	push   $0x801076ca
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 b4 2e 00 00       	call   80104710 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 58 2e 00 00       	jmp    801046d0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 df 76 10 80       	push   $0x801076df
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 c7 2d 00 00       	call   80104670 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 0d 2e 00 00       	call   801046d0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801018ca:	e8 21 30 00 00       	call   801048f0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 c7 30 00 00       	jmp    801049b0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 0a 11 80       	push   $0x80110a00
801018f8:	e8 f3 2f 00 00       	call   801048f0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101907:	e8 a4 30 00 00       	call   801049b0 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 84 fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 fc fa ff ff       	call   801014c0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 d5 fa ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 e1 f8 ff ff       	call   801013b0 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 94 2f 00 00       	call   80104aa0 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 e1 f7 ff ff       	call   801013b0 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 98 2e 00 00       	call   80104aa0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 80 16 00 00       	call   80103290 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 69 2e 00 00       	call   80104b10 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 06 2e 00 00       	call   80104b10 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 81 f5 ff ff       	call   801012c0 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 f9 76 10 80       	push   $0x801076f9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 e7 76 10 80       	push   $0x801076e7
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 51 1f 00 00       	call   80103ce0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 0a 11 80       	push   $0x80110a00
80101d9c:	e8 4f 2b 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101dac:	e8 ff 2b 00 00       	call   801049b0 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 84 2c 00 00       	call   80104aa0 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 f8 2b 00 00       	call   80104aa0 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 9f f3 ff ff       	call   801012c0 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 86 2b 00 00       	call   80104b60 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 08 77 10 80       	push   $0x80107708
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 6a 7d 10 80       	push   $0x80107d6a
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010206f:	90                   	nop

80102070 <swapread>:

void swapread(char* ptr, int blkno)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
80102075:	89 e5                	mov    %esp,%ebp
80102077:	57                   	push   %edi
80102078:	56                   	push   %esi
80102079:	53                   	push   %ebx
8010207a:	83 ec 1c             	sub    $0x1c,%esp
8010207d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX / 8)
80102080:	81 ff 94 30 00 00    	cmp    $0x3094,%edi
80102086:	77 5f                	ja     801020e7 <swapread+0x77>
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		nr_sectors_read++;
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80102088:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
8010208f:	8b 75 08             	mov    0x8(%ebp),%esi
80102092:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
80102098:	05 fc 01 00 00       	add    $0x1fc,%eax
8010209d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020a0:	83 ec 08             	sub    $0x8,%esp
		nr_sectors_read++;
801020a3:	83 05 c0 09 11 80 01 	addl   $0x1,0x801109c0
		bp = bread(0, blkno * 8 + SWAPBASE + i);
801020aa:	57                   	push   %edi
801020ab:	83 c7 01             	add    $0x1,%edi
801020ae:	6a 00                	push   $0x0
801020b0:	e8 1b e0 ff ff       	call   801000d0 <bread>
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
801020b5:	83 c4 0c             	add    $0xc,%esp
		bp = bread(0, blkno * 8 + SWAPBASE + i);
801020b8:	89 c3                	mov    %eax,%ebx
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
801020ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801020bd:	68 00 02 00 00       	push   $0x200
801020c2:	50                   	push   %eax
801020c3:	56                   	push   %esi
801020c4:	81 c6 00 02 00 00    	add    $0x200,%esi
801020ca:	e8 d1 29 00 00       	call   80104aa0 <memmove>
		brelse(bp);
801020cf:	89 1c 24             	mov    %ebx,(%esp)
801020d2:	e8 19 e1 ff ff       	call   801001f0 <brelse>
	for ( i=0; i < 8; ++i ) {
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801020dd:	75 c1                	jne    801020a0 <swapread+0x30>
	}
}
801020df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e2:	5b                   	pop    %ebx
801020e3:	5e                   	pop    %esi
801020e4:	5f                   	pop    %edi
801020e5:	5d                   	pop    %ebp
801020e6:	c3                   	ret    
		panic("swapread: blkno exceed range");
801020e7:	83 ec 0c             	sub    $0xc,%esp
801020ea:	68 15 77 10 80       	push   $0x80107715
801020ef:	e8 9c e2 ff ff       	call   80100390 <panic>
801020f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020ff:	90                   	nop

80102100 <swapwrite>:

void swapwrite(char* ptr, int blkno)
{
80102100:	f3 0f 1e fb          	endbr32 
80102104:	55                   	push   %ebp
80102105:	89 e5                	mov    %esp,%ebp
80102107:	57                   	push   %edi
80102108:	56                   	push   %esi
80102109:	53                   	push   %ebx
8010210a:	83 ec 1c             	sub    $0x1c,%esp
8010210d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX / 8)
80102110:	81 ff 94 30 00 00    	cmp    $0x3094,%edi
80102116:	77 67                	ja     8010217f <swapwrite+0x7f>
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		nr_sectors_write++;
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80102118:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
8010211f:	8b 75 08             	mov    0x8(%ebp),%esi
80102122:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
80102128:	05 fc 01 00 00       	add    $0x1fc,%eax
8010212d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102130:	83 ec 08             	sub    $0x8,%esp
		nr_sectors_write++;
80102133:	83 05 e0 09 11 80 01 	addl   $0x1,0x801109e0
		bp = bread(0, blkno * 8 + SWAPBASE + i);
8010213a:	57                   	push   %edi
8010213b:	83 c7 01             	add    $0x1,%edi
8010213e:	6a 00                	push   $0x0
80102140:	e8 8b df ff ff       	call   801000d0 <bread>
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
80102145:	83 c4 0c             	add    $0xc,%esp
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80102148:	89 c3                	mov    %eax,%ebx
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
8010214a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010214d:	68 00 02 00 00       	push   $0x200
80102152:	56                   	push   %esi
80102153:	81 c6 00 02 00 00    	add    $0x200,%esi
80102159:	50                   	push   %eax
8010215a:	e8 41 29 00 00       	call   80104aa0 <memmove>
		bwrite(bp);
8010215f:	89 1c 24             	mov    %ebx,(%esp)
80102162:	e8 49 e0 ff ff       	call   801001b0 <bwrite>
		brelse(bp);
80102167:	89 1c 24             	mov    %ebx,(%esp)
8010216a:	e8 81 e0 ff ff       	call   801001f0 <brelse>
	for ( i=0; i < 8; ++i ) {
8010216f:	83 c4 10             	add    $0x10,%esp
80102172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80102175:	75 b9                	jne    80102130 <swapwrite+0x30>
	}
}
80102177:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217a:	5b                   	pop    %ebx
8010217b:	5e                   	pop    %esi
8010217c:	5f                   	pop    %edi
8010217d:	5d                   	pop    %ebp
8010217e:	c3                   	ret    
		panic("swapread: blkno exceed range");
8010217f:	83 ec 0c             	sub    $0xc,%esp
80102182:	68 15 77 10 80       	push   $0x80107715
80102187:	e8 04 e2 ff ff       	call   80100390 <panic>
8010218c:	66 90                	xchg   %ax,%ax
8010218e:	66 90                	xchg   %ax,%ax

80102190 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	56                   	push   %esi
80102194:	53                   	push   %ebx
  if(b == 0)
80102195:	85 c0                	test   %eax,%eax
80102197:	0f 84 af 00 00 00    	je     8010224c <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010219d:	8b 70 08             	mov    0x8(%eax),%esi
801021a0:	89 c3                	mov    %eax,%ebx
801021a2:	81 fe 9f 86 01 00    	cmp    $0x1869f,%esi
801021a8:	0f 87 91 00 00 00    	ja     8010223f <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ae:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b7:	90                   	nop
801021b8:	89 ca                	mov    %ecx,%edx
801021ba:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021bb:	83 e0 c0             	and    $0xffffffc0,%eax
801021be:	3c 40                	cmp    $0x40,%al
801021c0:	75 f6                	jne    801021b8 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c2:	31 c0                	xor    %eax,%eax
801021c4:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021c9:	ee                   	out    %al,(%dx)
801021ca:	b8 01 00 00 00       	mov    $0x1,%eax
801021cf:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021d4:	ee                   	out    %al,(%dx)
801021d5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021da:	89 f0                	mov    %esi,%eax
801021dc:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021dd:	89 f0                	mov    %esi,%eax
801021df:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021e4:	c1 f8 08             	sar    $0x8,%eax
801021e7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
801021e8:	89 f0                	mov    %esi,%eax
801021ea:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021ef:	c1 f8 10             	sar    $0x10,%eax
801021f2:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021f3:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021f7:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021fc:	c1 e0 04             	shl    $0x4,%eax
801021ff:	83 e0 10             	and    $0x10,%eax
80102202:	83 c8 e0             	or     $0xffffffe0,%eax
80102205:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102206:	f6 03 04             	testb  $0x4,(%ebx)
80102209:	75 15                	jne    80102220 <idestart+0x90>
8010220b:	b8 20 00 00 00       	mov    $0x20,%eax
80102210:	89 ca                	mov    %ecx,%edx
80102212:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102213:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102216:	5b                   	pop    %ebx
80102217:	5e                   	pop    %esi
80102218:	5d                   	pop    %ebp
80102219:	c3                   	ret    
8010221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102220:	b8 30 00 00 00       	mov    $0x30,%eax
80102225:	89 ca                	mov    %ecx,%edx
80102227:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102228:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010222d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102230:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102235:	fc                   	cld    
80102236:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102238:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010223b:	5b                   	pop    %ebx
8010223c:	5e                   	pop    %esi
8010223d:	5d                   	pop    %ebp
8010223e:	c3                   	ret    
    panic("incorrect blockno");
8010223f:	83 ec 0c             	sub    $0xc,%esp
80102242:	68 90 77 10 80       	push   $0x80107790
80102247:	e8 44 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
8010224c:	83 ec 0c             	sub    $0xc,%esp
8010224f:	68 87 77 10 80       	push   $0x80107787
80102254:	e8 37 e1 ff ff       	call   80100390 <panic>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideinit>:
{
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010226a:	68 a2 77 10 80       	push   $0x801077a2
8010226f:	68 80 a5 10 80       	push   $0x8010a580
80102274:	e8 f7 24 00 00       	call   80104770 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102279:	58                   	pop    %eax
8010227a:	a1 40 8d 20 80       	mov    0x80208d40,%eax
8010227f:	5a                   	pop    %edx
80102280:	83 e8 01             	sub    $0x1,%eax
80102283:	50                   	push   %eax
80102284:	6a 0e                	push   $0xe
80102286:	e8 b5 02 00 00       	call   80102540 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010228b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010228e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102297:	90                   	nop
80102298:	ec                   	in     (%dx),%al
80102299:	83 e0 c0             	and    $0xffffffc0,%eax
8010229c:	3c 40                	cmp    $0x40,%al
8010229e:	75 f8                	jne    80102298 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022aa:	ee                   	out    %al,(%dx)
801022ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022b5:	eb 0e                	jmp    801022c5 <ideinit+0x65>
801022b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801022c0:	83 e9 01             	sub    $0x1,%ecx
801022c3:	74 0f                	je     801022d4 <ideinit+0x74>
801022c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022c6:	84 c0                	test   %al,%al
801022c8:	74 f6                	je     801022c0 <ideinit+0x60>
      havedisk1 = 1;
801022ca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801022d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022de:	ee                   	out    %al,(%dx)
}
801022df:	c9                   	leave  
801022e0:	c3                   	ret    
801022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022f0:	f3 0f 1e fb          	endbr32 
801022f4:	55                   	push   %ebp
801022f5:	89 e5                	mov    %esp,%ebp
801022f7:	57                   	push   %edi
801022f8:	56                   	push   %esi
801022f9:	53                   	push   %ebx
801022fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022fd:	68 80 a5 10 80       	push   $0x8010a580
80102302:	e8 e9 25 00 00       	call   801048f0 <acquire>

  if((b = idequeue) == 0){
80102307:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 db                	test   %ebx,%ebx
80102312:	74 5f                	je     80102373 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102314:	8b 43 58             	mov    0x58(%ebx),%eax
80102317:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010231c:	8b 33                	mov    (%ebx),%esi
8010231e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102324:	75 2b                	jne    80102351 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102326:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010232b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010232f:	90                   	nop
80102330:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102331:	89 c1                	mov    %eax,%ecx
80102333:	83 e1 c0             	and    $0xffffffc0,%ecx
80102336:	80 f9 40             	cmp    $0x40,%cl
80102339:	75 f5                	jne    80102330 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010233b:	a8 21                	test   $0x21,%al
8010233d:	75 12                	jne    80102351 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010233f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102342:	b9 80 00 00 00       	mov    $0x80,%ecx
80102347:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010234c:	fc                   	cld    
8010234d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010234f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102351:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102354:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102357:	83 ce 02             	or     $0x2,%esi
8010235a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010235c:	53                   	push   %ebx
8010235d:	e8 0e 21 00 00       	call   80104470 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102362:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102367:	83 c4 10             	add    $0x10,%esp
8010236a:	85 c0                	test   %eax,%eax
8010236c:	74 05                	je     80102373 <ideintr+0x83>
    idestart(idequeue);
8010236e:	e8 1d fe ff ff       	call   80102190 <idestart>
    release(&idelock);
80102373:	83 ec 0c             	sub    $0xc,%esp
80102376:	68 80 a5 10 80       	push   $0x8010a580
8010237b:	e8 30 26 00 00       	call   801049b0 <release>

  release(&idelock);
}
80102380:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102383:	5b                   	pop    %ebx
80102384:	5e                   	pop    %esi
80102385:	5f                   	pop    %edi
80102386:	5d                   	pop    %ebp
80102387:	c3                   	ret    
80102388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop

80102390 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
80102395:	89 e5                	mov    %esp,%ebp
80102397:	53                   	push   %ebx
80102398:	83 ec 10             	sub    $0x10,%esp
8010239b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010239e:	8d 43 0c             	lea    0xc(%ebx),%eax
801023a1:	50                   	push   %eax
801023a2:	e8 69 23 00 00       	call   80104710 <holdingsleep>
801023a7:	83 c4 10             	add    $0x10,%esp
801023aa:	85 c0                	test   %eax,%eax
801023ac:	0f 84 cf 00 00 00    	je     80102481 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023b2:	8b 03                	mov    (%ebx),%eax
801023b4:	83 e0 06             	and    $0x6,%eax
801023b7:	83 f8 02             	cmp    $0x2,%eax
801023ba:	0f 84 b4 00 00 00    	je     80102474 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023c0:	8b 53 04             	mov    0x4(%ebx),%edx
801023c3:	85 d2                	test   %edx,%edx
801023c5:	74 0d                	je     801023d4 <iderw+0x44>
801023c7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801023cc:	85 c0                	test   %eax,%eax
801023ce:	0f 84 93 00 00 00    	je     80102467 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 80 a5 10 80       	push   $0x8010a580
801023dc:	e8 0f 25 00 00       	call   801048f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801023e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	85 c0                	test   %eax,%eax
801023f2:	74 6c                	je     80102460 <iderw+0xd0>
801023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023f8:	89 c2                	mov    %eax,%edx
801023fa:	8b 40 58             	mov    0x58(%eax),%eax
801023fd:	85 c0                	test   %eax,%eax
801023ff:	75 f7                	jne    801023f8 <iderw+0x68>
80102401:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102404:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102406:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010240c:	74 42                	je     80102450 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010240e:	8b 03                	mov    (%ebx),%eax
80102410:	83 e0 06             	and    $0x6,%eax
80102413:	83 f8 02             	cmp    $0x2,%eax
80102416:	74 23                	je     8010243b <iderw+0xab>
80102418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop
    sleep(b, &idelock);
80102420:	83 ec 08             	sub    $0x8,%esp
80102423:	68 80 a5 10 80       	push   $0x8010a580
80102428:	53                   	push   %ebx
80102429:	e8 82 1e 00 00       	call   801042b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 c4 10             	add    $0x10,%esp
80102433:	83 e0 06             	and    $0x6,%eax
80102436:	83 f8 02             	cmp    $0x2,%eax
80102439:	75 e5                	jne    80102420 <iderw+0x90>
  }


  release(&idelock);
8010243b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102445:	c9                   	leave  
  release(&idelock);
80102446:	e9 65 25 00 00       	jmp    801049b0 <release>
8010244b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010244f:	90                   	nop
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 39 fd ff ff       	call   80102190 <idestart>
80102457:	eb b5                	jmp    8010240e <iderw+0x7e>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102465:	eb 9d                	jmp    80102404 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	68 d1 77 10 80       	push   $0x801077d1
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 bc 77 10 80       	push   $0x801077bc
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 a6 77 10 80       	push   $0x801077a6
80102489:	e8 02 df ff ff       	call   80100390 <panic>
8010248e:	66 90                	xchg   %ax,%ax

80102490 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102490:	f3 0f 1e fb          	endbr32 
80102494:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102495:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010249c:	00 c0 fe 
{
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	56                   	push   %esi
801024a2:	53                   	push   %ebx
  ioapic->reg = reg;
801024a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024aa:	00 00 00 
  return ioapic->data;
801024ad:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801024b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024bc:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024c2:	0f b6 15 a0 87 20 80 	movzbl 0x802087a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024c9:	c1 ee 10             	shr    $0x10,%esi
801024cc:	89 f0                	mov    %esi,%eax
801024ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801024d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024d7:	39 c2                	cmp    %eax,%edx
801024d9:	74 16                	je     801024f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024db:	83 ec 0c             	sub    $0xc,%esp
801024de:	68 f0 77 10 80       	push   $0x801077f0
801024e3:	e8 c8 e1 ff ff       	call   801006b0 <cprintf>
801024e8:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801024ee:	83 c4 10             	add    $0x10,%esp
801024f1:	83 c6 21             	add    $0x21,%esi
{
801024f4:	ba 10 00 00 00       	mov    $0x10,%edx
801024f9:	b8 20 00 00 00       	mov    $0x20,%eax
801024fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102500:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102502:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102504:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010250a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010250d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102513:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102516:	8d 5a 01             	lea    0x1(%edx),%ebx
80102519:	83 c2 02             	add    $0x2,%edx
8010251c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010251e:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102524:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010252b:	39 f0                	cmp    %esi,%eax
8010252d:	75 d1                	jne    80102500 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010252f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102532:	5b                   	pop    %ebx
80102533:	5e                   	pop    %esi
80102534:	5d                   	pop    %ebp
80102535:	c3                   	ret    
80102536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253d:	8d 76 00             	lea    0x0(%esi),%esi

80102540 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102540:	f3 0f 1e fb          	endbr32 
80102544:	55                   	push   %ebp
  ioapic->reg = reg;
80102545:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
8010254b:	89 e5                	mov    %esp,%ebp
8010254d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102550:	8d 50 20             	lea    0x20(%eax),%edx
80102553:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102557:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102559:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102562:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102565:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102568:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010256a:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010256f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102572:	89 50 10             	mov    %edx,0x10(%eax)
}
80102575:	5d                   	pop    %ebp
80102576:	c3                   	ret    
80102577:	66 90                	xchg   %ax,%ax
80102579:	66 90                	xchg   %ax,%ax
8010257b:	66 90                	xchg   %ax,%ax
8010257d:	66 90                	xchg   %ax,%ax
8010257f:	90                   	nop

80102580 <get_available_bitmap>:
struct LRU *lru = &(LRU_hontai);

// Update
char bitmap[BITMAP_SIZE];

int get_available_bitmap(){ // failed, return -1;
80102580:	f3 0f 1e fb          	endbr32 
  for (int i = 0; i < BITMAP_SIZE;i++){
80102584:	31 c0                	xor    %eax,%eax
80102586:	eb 12                	jmp    8010259a <get_available_bitmap+0x1a>
80102588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258f:	90                   	nop
80102590:	83 c0 01             	add    $0x1,%eax
80102593:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80102598:	74 0e                	je     801025a8 <get_available_bitmap+0x28>
    if(bitmap[i]==0)
8010259a:	80 b8 a0 26 11 80 00 	cmpb   $0x0,-0x7feed960(%eax)
801025a1:	75 ed                	jne    80102590 <get_available_bitmap+0x10>
      return i;
  }
  cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
  return -1; // NOT FOUND
}
801025a3:	c3                   	ret    
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int get_available_bitmap(){ // failed, return -1;
801025a8:	55                   	push   %ebp
801025a9:	89 e5                	mov    %esp,%ebp
801025ab:	83 ec 14             	sub    $0x14,%esp
  cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
801025ae:	68 24 78 10 80       	push   $0x80107824
801025b3:	e8 f8 e0 ff ff       	call   801006b0 <cprintf>
  return -1; // NOT FOUND
801025b8:	83 c4 10             	add    $0x10,%esp
801025bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801025c0:	c9                   	leave  
801025c1:	c3                   	ret    
801025c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801025d0 <get_available_linked_list>:

int get_available_linked_list(){
801025d0:	f3 0f 1e fb          	endbr32 
  for (int i = 0; i < LRU_LENGTH;i++){
    if(lru->is_used[i]){
801025d4:	8b 15 00 80 10 80    	mov    0x80108000,%edx
  for (int i = 0; i < LRU_LENGTH;i++){
801025da:	31 c0                	xor    %eax,%eax
801025dc:	eb 0c                	jmp    801025ea <get_available_linked_list+0x1a>
801025de:	66 90                	xchg   %ax,%ax
801025e0:	83 c0 01             	add    $0x1,%eax
801025e3:	3d 00 e0 00 00       	cmp    $0xe000,%eax
801025e8:	74 0e                	je     801025f8 <get_available_linked_list+0x28>
    if(lru->is_used[i]){
801025ea:	80 7c 02 04 00       	cmpb   $0x0,0x4(%edx,%eax,1)
801025ef:	74 ef                	je     801025e0 <get_available_linked_list+0x10>
      return i;
    }
  }
  return -1;
}
801025f1:	c3                   	ret    
801025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801025f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801025fd:	c3                   	ret    
801025fe:	66 90                	xchg   %ax,%ax

80102600 <init_lru>:

void init_lru(){
80102600:	f3 0f 1e fb          	endbr32 
  for (int i = 0; i < LRU_LENGTH; i++){
    linked_list[i].next = 0;
    linked_list[i].prev = 0;
    linked_list[i].pgdir = 0;
    linked_list[i].vaddr = 0;
    lru->is_used[i] = 0;
80102604:	8b 0d 00 80 10 80    	mov    0x80108000,%ecx
8010260a:	b8 a0 a6 11 80       	mov    $0x8011a6a0,%eax
8010260f:	8d 51 04             	lea    0x4(%ecx),%edx
80102612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    linked_list[i].next = 0;
80102618:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    linked_list[i].prev = 0;
8010261e:	83 c0 10             	add    $0x10,%eax
80102621:	83 c2 01             	add    $0x1,%edx
80102624:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    linked_list[i].pgdir = 0;
8010262b:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    linked_list[i].vaddr = 0;
80102632:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    lru->is_used[i] = 0;
80102639:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  for (int i = 0; i < LRU_LENGTH; i++){
8010263d:	3d a0 a6 1f 80       	cmp    $0x801fa6a0,%eax
80102642:	75 d4                	jne    80102618 <init_lru+0x18>
  }
  lru->head = 0;
80102644:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  lru->num_free_pages = LRU_LENGTH;
8010264a:	a1 00 80 10 80       	mov    0x80108000,%eax
8010264f:	c7 80 04 e0 00 00 00 	movl   $0xe000,0xe004(%eax)
80102656:	e0 00 00 
  lru->num_lru_pages = 0;
80102659:	c7 80 08 e0 00 00 00 	movl   $0x0,0xe008(%eax)
80102660:	00 00 00 
}
80102663:	c3                   	ret    
80102664:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010266f:	90                   	nop

80102670 <lru_append>:

int lru_append(struct page *at, pde_t *pgdir, char* vaddr){ // at 의 next에 ll[idx], 즉 which를 pgdir, vaddr 값으로 append
80102670:	f3 0f 1e fb          	endbr32 
80102674:	55                   	push   %ebp
    if(lru->is_used[i]){
80102675:	8b 15 00 80 10 80    	mov    0x80108000,%edx
  for (int i = 0; i < LRU_LENGTH;i++){
8010267b:	31 c0                	xor    %eax,%eax
int lru_append(struct page *at, pde_t *pgdir, char* vaddr){ // at 의 next에 ll[idx], 즉 which를 pgdir, vaddr 값으로 append
8010267d:	89 e5                	mov    %esp,%ebp
8010267f:	56                   	push   %esi
80102680:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102683:	53                   	push   %ebx
80102684:	eb 14                	jmp    8010269a <lru_append+0x2a>
80102686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268d:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i = 0; i < LRU_LENGTH;i++){
80102690:	83 c0 01             	add    $0x1,%eax
80102693:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80102698:	74 4e                	je     801026e8 <lru_append+0x78>
    if(lru->is_used[i]){
8010269a:	80 7c 02 04 00       	cmpb   $0x0,0x4(%edx,%eax,1)
8010269f:	74 ef                	je     80102690 <lru_append+0x20>
801026a1:	89 c2                	mov    %eax,%edx
801026a3:	c1 e2 04             	shl    $0x4,%edx
  int idx = get_available_linked_list();
  struct page *which = &(linked_list[idx]);
  if (at->vaddr == 0)
801026a6:	8b 59 0c             	mov    0xc(%ecx),%ebx
  struct page *which = &(linked_list[idx]);
801026a9:	81 c2 a0 a6 11 80    	add    $0x8011a6a0,%edx
  if (at->vaddr == 0)
801026af:	85 db                	test   %ebx,%ebx
801026b1:	74 41                	je     801026f4 <lru_append+0x84>
    return -1;
  struct page *nextnext;
  nextnext = at->next;
801026b3:	8b 31                	mov    (%ecx),%esi
  at->next = which;
  which->next = nextnext;
801026b5:	c1 e0 04             	shl    $0x4,%eax
  at->next = which;
801026b8:	89 11                	mov    %edx,(%ecx)
  which->next = nextnext;
801026ba:	8d 98 a0 a6 11 80    	lea    -0x7fee5960(%eax),%ebx
  which->prev = at;
801026c0:	89 88 a4 a6 11 80    	mov    %ecx,-0x7fee595c(%eax)
  which->next = nextnext;
801026c6:	89 b0 a0 a6 11 80    	mov    %esi,-0x7fee5960(%eax)
  nextnext->prev = which;

  which->pgdir = pgdir;
801026cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  nextnext->prev = which;
801026cf:	89 56 04             	mov    %edx,0x4(%esi)
  which->pgdir = pgdir;
801026d2:	89 43 08             	mov    %eax,0x8(%ebx)
  which->vaddr = vaddr;
801026d5:	8b 45 10             	mov    0x10(%ebp),%eax
801026d8:	89 43 0c             	mov    %eax,0xc(%ebx)
  return 0;
801026db:	31 c0                	xor    %eax,%eax
}
801026dd:	5b                   	pop    %ebx
801026de:	5e                   	pop    %esi
801026df:	5d                   	pop    %ebp
801026e0:	c3                   	ret    
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026e8:	ba f0 ff ff ff       	mov    $0xfffffff0,%edx
  return -1;
801026ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026f2:	eb b2                	jmp    801026a6 <lru_append+0x36>
    return -1;
801026f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026f9:	eb e2                	jmp    801026dd <lru_append+0x6d>
801026fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop

80102700 <lru_delete>:

void lru_delete(struct page* node){ // lru head 라면 next 를 head로
80102700:	f3 0f 1e fb          	endbr32 
80102704:	55                   	push   %ebp
80102705:	89 e5                	mov    %esp,%ebp
80102707:	8b 45 08             	mov    0x8(%ebp),%eax
  node->vaddr = 0;
  node->prev->next = (node->next);
8010270a:	8b 50 04             	mov    0x4(%eax),%edx
8010270d:	8b 08                	mov    (%eax),%ecx
  node->vaddr = 0;
8010270f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  node->prev->next = (node->next);
80102716:	89 0a                	mov    %ecx,(%edx)
  node->next->prev = (node->prev);
80102718:	8b 10                	mov    (%eax),%edx
8010271a:	8b 48 04             	mov    0x4(%eax),%ecx
8010271d:	89 4a 04             	mov    %ecx,0x4(%edx)
  if(node == lru->head){
80102720:	8b 15 00 80 10 80    	mov    0x80108000,%edx
80102726:	39 02                	cmp    %eax,(%edx)
80102728:	74 06                	je     80102730 <lru_delete+0x30>
    lru->head = node->next;
  }
}
8010272a:	5d                   	pop    %ebp
8010272b:	c3                   	ret    
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lru->head = node->next;
80102730:	8b 00                	mov    (%eax),%eax
80102732:	89 02                	mov    %eax,(%edx)
}
80102734:	5d                   	pop    %ebp
80102735:	c3                   	ret    
80102736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273d:	8d 76 00             	lea    0x0(%esi),%esi

80102740 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102740:	f3 0f 1e fb          	endbr32 
80102744:	55                   	push   %ebp
80102745:	89 e5                	mov    %esp,%ebp
80102747:	53                   	push   %ebx
80102748:	83 ec 04             	sub    $0x4,%esp
8010274b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010274e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102754:	75 7a                	jne    801027d0 <kfree+0x90>
80102756:	81 fb e8 b4 20 80    	cmp    $0x8020b4e8,%ebx
8010275c:	72 72                	jb     801027d0 <kfree+0x90>
8010275e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102764:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102769:	77 65                	ja     801027d0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010276b:	83 ec 04             	sub    $0x4,%esp
8010276e:	68 00 10 00 00       	push   $0x1000
80102773:	6a 01                	push   $0x1
80102775:	53                   	push   %ebx
80102776:	e8 85 22 00 00       	call   80104a00 <memset>

  if(kmem.use_lock)
8010277b:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102781:	83 c4 10             	add    $0x10,%esp
80102784:	85 d2                	test   %edx,%edx
80102786:	75 20                	jne    801027a8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102788:	a1 98 26 11 80       	mov    0x80112698,%eax
8010278d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010278f:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102794:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
8010279a:	85 c0                	test   %eax,%eax
8010279c:	75 22                	jne    801027c0 <kfree+0x80>
    release(&kmem.lock);
}
8010279e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a1:	c9                   	leave  
801027a2:	c3                   	ret    
801027a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a7:	90                   	nop
    acquire(&kmem.lock);
801027a8:	83 ec 0c             	sub    $0xc,%esp
801027ab:	68 60 26 11 80       	push   $0x80112660
801027b0:	e8 3b 21 00 00       	call   801048f0 <acquire>
801027b5:	83 c4 10             	add    $0x10,%esp
801027b8:	eb ce                	jmp    80102788 <kfree+0x48>
801027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801027c0:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801027c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ca:	c9                   	leave  
    release(&kmem.lock);
801027cb:	e9 e0 21 00 00       	jmp    801049b0 <release>
    panic("kfree");
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 52 78 10 80       	push   $0x80107852
801027d8:	e8 b3 db ff ff       	call   80100390 <panic>
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <freerange>:
{
801027e0:	f3 0f 1e fb          	endbr32 
801027e4:	55                   	push   %ebp
801027e5:	89 e5                	mov    %esp,%ebp
801027e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801027e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801027ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102801:	39 de                	cmp    %ebx,%esi
80102803:	72 1f                	jb     80102824 <freerange+0x44>
80102805:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102808:	83 ec 0c             	sub    $0xc,%esp
8010280b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102811:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102817:	50                   	push   %eax
80102818:	e8 23 ff ff ff       	call   80102740 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	39 f3                	cmp    %esi,%ebx
80102822:	76 e4                	jbe    80102808 <freerange+0x28>
}
80102824:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102827:	5b                   	pop    %ebx
80102828:	5e                   	pop    %esi
80102829:	5d                   	pop    %ebp
8010282a:	c3                   	ret    
8010282b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop

80102830 <kinit1>:
{
80102830:	f3 0f 1e fb          	endbr32 
80102834:	55                   	push   %ebp
80102835:	89 e5                	mov    %esp,%ebp
80102837:	56                   	push   %esi
80102838:	53                   	push   %ebx
80102839:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010283c:	83 ec 08             	sub    $0x8,%esp
8010283f:	68 58 78 10 80       	push   $0x80107858
80102844:	68 60 26 11 80       	push   $0x80112660
80102849:	e8 22 1f 00 00       	call   80104770 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102851:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102854:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
8010285b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010285e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102864:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010286a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102870:	39 de                	cmp    %ebx,%esi
80102872:	72 20                	jb     80102894 <kinit1+0x64>
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102878:	83 ec 0c             	sub    $0xc,%esp
8010287b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102881:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102887:	50                   	push   %eax
80102888:	e8 b3 fe ff ff       	call   80102740 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010288d:	83 c4 10             	add    $0x10,%esp
80102890:	39 de                	cmp    %ebx,%esi
80102892:	73 e4                	jae    80102878 <kinit1+0x48>
}
80102894:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102897:	5b                   	pop    %ebx
80102898:	5e                   	pop    %esi
80102899:	5d                   	pop    %ebp
8010289a:	c3                   	ret    
8010289b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010289f:	90                   	nop

801028a0 <kinit2>:
{
801028a0:	f3 0f 1e fb          	endbr32 
801028a4:	55                   	push   %ebp
801028a5:	89 e5                	mov    %esp,%ebp
801028a7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801028a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028ab:	8b 75 0c             	mov    0xc(%ebp),%esi
801028ae:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028af:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028b5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028c1:	39 de                	cmp    %ebx,%esi
801028c3:	72 1f                	jb     801028e4 <kinit2+0x44>
801028c5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801028c8:	83 ec 0c             	sub    $0xc,%esp
801028cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028d7:	50                   	push   %eax
801028d8:	e8 63 fe ff ff       	call   80102740 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	39 de                	cmp    %ebx,%esi
801028e2:	73 e4                	jae    801028c8 <kinit2+0x28>
  kmem.use_lock = 1;
801028e4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801028eb:	00 00 00 
}
801028ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f1:	5b                   	pop    %ebx
801028f2:	5e                   	pop    %esi
801028f3:	5d                   	pop    %ebp
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <clock>:

// my code
struct page* clock(){
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
80102905:	89 e5                	mov    %esp,%ebp
80102907:	83 ec 08             	sub    $0x8,%esp
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (;;lru->head=lru->head->prev){
    if(lru->head->vaddr){
80102910:	a1 00 80 10 80       	mov    0x80108000,%eax
80102915:	8b 10                	mov    (%eax),%edx
80102917:	8b 4a 0c             	mov    0xc(%edx),%ecx
8010291a:	85 c9                	test   %ecx,%ecx
8010291c:	74 24                	je     80102942 <clock+0x42>
      pte_t *cur_pte = walkpgdir(lru->head->pgdir, lru->head->vaddr, 1);
8010291e:	83 ec 04             	sub    $0x4,%esp
80102921:	6a 01                	push   $0x1
80102923:	51                   	push   %ecx
80102924:	ff 72 08             	pushl  0x8(%edx)
80102927:	e8 a4 43 00 00       	call   80106cd0 <walkpgdir>
      if(*cur_pte&PTE_A){     // if PTE_A == 1
8010292c:	83 c4 10             	add    $0x10,%esp
8010292f:	8b 10                	mov    (%eax),%edx
80102931:	f6 c2 20             	test   $0x20,%dl
80102934:	74 05                	je     8010293b <clock+0x3b>
        *cur_pte |= ~(PTE_A);
80102936:	83 ca df             	or     $0xffffffdf,%edx
80102939:	89 10                	mov    %edx,(%eax)
8010293b:	a1 00 80 10 80       	mov    0x80108000,%eax
80102940:	8b 10                	mov    (%eax),%edx
  for (;;lru->head=lru->head->prev){
80102942:	8b 52 04             	mov    0x4(%edx),%edx
80102945:	89 10                	mov    %edx,(%eax)
    if(lru->head->vaddr){
80102947:	eb c7                	jmp    80102910 <clock+0x10>
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102950 <no_freepg>:
      }
    }
  }
}

void no_freepg(){
80102950:	f3 0f 1e fb          	endbr32 
80102954:	55                   	push   %ebp
80102955:	89 e5                	mov    %esp,%ebp
80102957:	83 ec 08             	sub    $0x8,%esp
  if(lru->num_free_pages == 0){
8010295a:	8b 15 00 80 10 80    	mov    0x80108000,%edx
80102960:	8b 82 04 e0 00 00    	mov    0xe004(%edx),%eax
80102966:	85 c0                	test   %eax,%eax
80102968:	74 1e                	je     80102988 <no_freepg+0x38>
8010296a:	31 c0                	xor    %eax,%eax
8010296c:	eb 0c                	jmp    8010297a <no_freepg+0x2a>
8010296e:	66 90                	xchg   %ax,%ax
  for (int i = 0; i < BITMAP_SIZE;i++){
80102970:	83 c0 01             	add    $0x1,%eax
80102973:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80102978:	74 1b                	je     80102995 <no_freepg+0x45>
    if(bitmap[i]==0)
8010297a:	80 b8 a0 26 11 80 00 	cmpb   $0x0,-0x7feed960(%eax)
80102981:	75 ed                	jne    80102970 <no_freepg+0x20>
    panic("OOM Error");
  }
  int empty_bitmap = get_available_bitmap();
  struct page *victim = clock();
80102983:	e8 78 ff ff ff       	call   80102900 <clock>
    panic("OOM Error");
80102988:	83 ec 0c             	sub    $0xc,%esp
8010298b:	68 5d 78 10 80       	push   $0x8010785d
80102990:	e8 fb d9 ff ff       	call   80100390 <panic>
  cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
80102995:	83 ec 0c             	sub    $0xc,%esp
80102998:	68 24 78 10 80       	push   $0x80107824
8010299d:	e8 0e dd ff ff       	call   801006b0 <cprintf>
  return -1; // NOT FOUND
801029a2:	83 c4 10             	add    $0x10,%esp
801029a5:	eb dc                	jmp    80102983 <no_freepg+0x33>
801029a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ae:	66 90                	xchg   %ax,%ax

801029b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801029b0:	f3 0f 1e fb          	endbr32 
801029b4:	55                   	push   %ebp
801029b5:	89 e5                	mov    %esp,%ebp
801029b7:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

//try_again:
  if(kmem.use_lock)
801029ba:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
801029c0:	85 c9                	test   %ecx,%ecx
801029c2:	75 3c                	jne    80102a00 <kalloc+0x50>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029c4:	a1 98 26 11 80       	mov    0x80112698,%eax
//  if(!r && reclaim())
//	  goto try_again;
  if(r){
801029c9:	85 c0                	test   %eax,%eax
801029cb:	74 45                	je     80102a12 <kalloc+0x62>
    kmem.freelist = r->next;
801029cd:	8b 10                	mov    (%eax),%edx
801029cf:	89 15 98 26 11 80    	mov    %edx,0x80112698
  }
  else{
    no_freepg();
  }
  if(kmem.use_lock)
801029d5:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801029db:	85 d2                	test   %edx,%edx
801029dd:	75 09                	jne    801029e8 <kalloc+0x38>
    release(&kmem.lock);
  return (char*)r;
}
801029df:	c9                   	leave  
801029e0:	c3                   	ret    
801029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029ee:	68 60 26 11 80       	push   $0x80112660
801029f3:	e8 b8 1f 00 00       	call   801049b0 <release>
801029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fb:	83 c4 10             	add    $0x10,%esp
}
801029fe:	c9                   	leave  
801029ff:	c3                   	ret    
    acquire(&kmem.lock);
80102a00:	83 ec 0c             	sub    $0xc,%esp
80102a03:	68 60 26 11 80       	push   $0x80112660
80102a08:	e8 e3 1e 00 00       	call   801048f0 <acquire>
80102a0d:	83 c4 10             	add    $0x10,%esp
80102a10:	eb b2                	jmp    801029c4 <kalloc+0x14>
    no_freepg();
80102a12:	e8 39 ff ff ff       	call   80102950 <no_freepg>
80102a17:	66 90                	xchg   %ax,%ax
80102a19:	66 90                	xchg   %ax,%ax
80102a1b:	66 90                	xchg   %ax,%ax
80102a1d:	66 90                	xchg   %ax,%ax
80102a1f:	90                   	nop

80102a20 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102a20:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a24:	ba 64 00 00 00       	mov    $0x64,%edx
80102a29:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a2a:	a8 01                	test   $0x1,%al
80102a2c:	0f 84 be 00 00 00    	je     80102af0 <kbdgetc+0xd0>
{
80102a32:	55                   	push   %ebp
80102a33:	ba 60 00 00 00       	mov    $0x60,%edx
80102a38:	89 e5                	mov    %esp,%ebp
80102a3a:	53                   	push   %ebx
80102a3b:	ec                   	in     (%dx),%al
  return data;
80102a3c:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102a42:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102a45:	3c e0                	cmp    $0xe0,%al
80102a47:	74 57                	je     80102aa0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a49:	89 d9                	mov    %ebx,%ecx
80102a4b:	83 e1 40             	and    $0x40,%ecx
80102a4e:	84 c0                	test   %al,%al
80102a50:	78 5e                	js     80102ab0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a52:	85 c9                	test   %ecx,%ecx
80102a54:	74 09                	je     80102a5f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a56:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a59:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a5c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a5f:	0f b6 8a a0 79 10 80 	movzbl -0x7fef8660(%edx),%ecx
  shift ^= togglecode[data];
80102a66:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
  shift |= shiftcode[data];
80102a6d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102a6f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a71:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a73:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a79:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a7c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a7f:	8b 04 85 80 78 10 80 	mov    -0x7fef8780(,%eax,4),%eax
80102a86:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a8a:	74 0b                	je     80102a97 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102a8c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a8f:	83 fa 19             	cmp    $0x19,%edx
80102a92:	77 44                	ja     80102ad8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a94:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a97:	5b                   	pop    %ebx
80102a98:	5d                   	pop    %ebp
80102a99:	c3                   	ret    
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102aa0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102aa3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102aa5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
80102aab:	5b                   	pop    %ebx
80102aac:	5d                   	pop    %ebp
80102aad:	c3                   	ret    
80102aae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102ab0:	83 e0 7f             	and    $0x7f,%eax
80102ab3:	85 c9                	test   %ecx,%ecx
80102ab5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102ab8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102aba:	0f b6 8a a0 79 10 80 	movzbl -0x7fef8660(%edx),%ecx
80102ac1:	83 c9 40             	or     $0x40,%ecx
80102ac4:	0f b6 c9             	movzbl %cl,%ecx
80102ac7:	f7 d1                	not    %ecx
80102ac9:	21 d9                	and    %ebx,%ecx
}
80102acb:	5b                   	pop    %ebx
80102acc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102acd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102ad8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102adb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102ade:	5b                   	pop    %ebx
80102adf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102ae0:	83 f9 1a             	cmp    $0x1a,%ecx
80102ae3:	0f 42 c2             	cmovb  %edx,%eax
}
80102ae6:	c3                   	ret    
80102ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aee:	66 90                	xchg   %ax,%ax
    return -1;
80102af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102af5:	c3                   	ret    
80102af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102afd:	8d 76 00             	lea    0x0(%esi),%esi

80102b00 <kbdintr>:

void
kbdintr(void)
{
80102b00:	f3 0f 1e fb          	endbr32 
80102b04:	55                   	push   %ebp
80102b05:	89 e5                	mov    %esp,%ebp
80102b07:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b0a:	68 20 2a 10 80       	push   $0x80102a20
80102b0f:	e8 4c dd ff ff       	call   80100860 <consoleintr>
}
80102b14:	83 c4 10             	add    $0x10,%esp
80102b17:	c9                   	leave  
80102b18:	c3                   	ret    
80102b19:	66 90                	xchg   %ax,%ax
80102b1b:	66 90                	xchg   %ax,%ax
80102b1d:	66 90                	xchg   %ax,%ax
80102b1f:	90                   	nop

80102b20 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102b20:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102b24:	a1 ac 86 20 80       	mov    0x802086ac,%eax
80102b29:	85 c0                	test   %eax,%eax
80102b2b:	0f 84 c7 00 00 00    	je     80102bf8 <lapicinit+0xd8>
  lapic[index] = value;
80102b31:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b38:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b3e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b45:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b48:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b4b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b52:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b55:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b58:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b5f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b62:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b65:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b6c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b72:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b79:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b7f:	8b 50 30             	mov    0x30(%eax),%edx
80102b82:	c1 ea 10             	shr    $0x10,%edx
80102b85:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b8b:	75 73                	jne    80102c00 <lapicinit+0xe0>
  lapic[index] = value;
80102b8d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b9a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ba1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bae:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bbb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102bc8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bcb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bce:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102bd5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd8:	8b 50 20             	mov    0x20(%eax),%edx
80102bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bdf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102be0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102be6:	80 e6 10             	and    $0x10,%dh
80102be9:	75 f5                	jne    80102be0 <lapicinit+0xc0>
  lapic[index] = value;
80102beb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bf2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bf8:	c3                   	ret    
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102c00:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c07:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c0a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102c0d:	e9 7b ff ff ff       	jmp    80102b8d <lapicinit+0x6d>
80102c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c20 <lapicid>:

int
lapicid(void)
{
80102c20:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102c24:	a1 ac 86 20 80       	mov    0x802086ac,%eax
80102c29:	85 c0                	test   %eax,%eax
80102c2b:	74 0b                	je     80102c38 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102c2d:	8b 40 20             	mov    0x20(%eax),%eax
80102c30:	c1 e8 18             	shr    $0x18,%eax
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102c38:	31 c0                	xor    %eax,%eax
}
80102c3a:	c3                   	ret    
80102c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c3f:	90                   	nop

80102c40 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102c40:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102c44:	a1 ac 86 20 80       	mov    0x802086ac,%eax
80102c49:	85 c0                	test   %eax,%eax
80102c4b:	74 0d                	je     80102c5a <lapiceoi+0x1a>
  lapic[index] = value;
80102c4d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c57:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c5a:	c3                   	ret    
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop

80102c60 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c60:	f3 0f 1e fb          	endbr32 
}
80102c64:	c3                   	ret    
80102c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c70 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c70:	f3 0f 1e fb          	endbr32 
80102c74:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c75:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c7a:	ba 70 00 00 00       	mov    $0x70,%edx
80102c7f:	89 e5                	mov    %esp,%ebp
80102c81:	53                   	push   %ebx
80102c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c88:	ee                   	out    %al,(%dx)
80102c89:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c8e:	ba 71 00 00 00       	mov    $0x71,%edx
80102c93:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c94:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c96:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c99:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c9f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ca1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102ca4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102ca6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ca9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102cac:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102cb2:	a1 ac 86 20 80       	mov    0x802086ac,%eax
80102cb7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cbd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cc0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102cc7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cca:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ccd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102cd4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cda:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ce0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ce3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ce9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cec:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cf2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102cfb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102cfc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102cff:	5d                   	pop    %ebp
80102d00:	c3                   	ret    
80102d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop

80102d10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d10:	f3 0f 1e fb          	endbr32 
80102d14:	55                   	push   %ebp
80102d15:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d1a:	ba 70 00 00 00       	mov    $0x70,%edx
80102d1f:	89 e5                	mov    %esp,%ebp
80102d21:	57                   	push   %edi
80102d22:	56                   	push   %esi
80102d23:	53                   	push   %ebx
80102d24:	83 ec 4c             	sub    $0x4c,%esp
80102d27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d28:	ba 71 00 00 00       	mov    $0x71,%edx
80102d2d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d2e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d31:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d36:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d40:	31 c0                	xor    %eax,%eax
80102d42:	89 da                	mov    %ebx,%edx
80102d44:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d45:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d4a:	89 ca                	mov    %ecx,%edx
80102d4c:	ec                   	in     (%dx),%al
80102d4d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d50:	89 da                	mov    %ebx,%edx
80102d52:	b8 02 00 00 00       	mov    $0x2,%eax
80102d57:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d58:	89 ca                	mov    %ecx,%edx
80102d5a:	ec                   	in     (%dx),%al
80102d5b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d5e:	89 da                	mov    %ebx,%edx
80102d60:	b8 04 00 00 00       	mov    $0x4,%eax
80102d65:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d66:	89 ca                	mov    %ecx,%edx
80102d68:	ec                   	in     (%dx),%al
80102d69:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d6c:	89 da                	mov    %ebx,%edx
80102d6e:	b8 07 00 00 00       	mov    $0x7,%eax
80102d73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d74:	89 ca                	mov    %ecx,%edx
80102d76:	ec                   	in     (%dx),%al
80102d77:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d7a:	89 da                	mov    %ebx,%edx
80102d7c:	b8 08 00 00 00       	mov    $0x8,%eax
80102d81:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d82:	89 ca                	mov    %ecx,%edx
80102d84:	ec                   	in     (%dx),%al
80102d85:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d87:	89 da                	mov    %ebx,%edx
80102d89:	b8 09 00 00 00       	mov    $0x9,%eax
80102d8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8f:	89 ca                	mov    %ecx,%edx
80102d91:	ec                   	in     (%dx),%al
80102d92:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d94:	89 da                	mov    %ebx,%edx
80102d96:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9c:	89 ca                	mov    %ecx,%edx
80102d9e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d9f:	84 c0                	test   %al,%al
80102da1:	78 9d                	js     80102d40 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102da3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102da7:	89 fa                	mov    %edi,%edx
80102da9:	0f b6 fa             	movzbl %dl,%edi
80102dac:	89 f2                	mov    %esi,%edx
80102dae:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102db1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102db5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db8:	89 da                	mov    %ebx,%edx
80102dba:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102dbd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102dc0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102dc4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102dc7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102dca:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102dce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102dd1:	31 c0                	xor    %eax,%eax
80102dd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd4:	89 ca                	mov    %ecx,%edx
80102dd6:	ec                   	in     (%dx),%al
80102dd7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dda:	89 da                	mov    %ebx,%edx
80102ddc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ddf:	b8 02 00 00 00       	mov    $0x2,%eax
80102de4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de5:	89 ca                	mov    %ecx,%edx
80102de7:	ec                   	in     (%dx),%al
80102de8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102deb:	89 da                	mov    %ebx,%edx
80102ded:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102df0:	b8 04 00 00 00       	mov    $0x4,%eax
80102df5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df6:	89 ca                	mov    %ecx,%edx
80102df8:	ec                   	in     (%dx),%al
80102df9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dfc:	89 da                	mov    %ebx,%edx
80102dfe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e01:	b8 07 00 00 00       	mov    $0x7,%eax
80102e06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e07:	89 ca                	mov    %ecx,%edx
80102e09:	ec                   	in     (%dx),%al
80102e0a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e0d:	89 da                	mov    %ebx,%edx
80102e0f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e12:	b8 08 00 00 00       	mov    $0x8,%eax
80102e17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e18:	89 ca                	mov    %ecx,%edx
80102e1a:	ec                   	in     (%dx),%al
80102e1b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e1e:	89 da                	mov    %ebx,%edx
80102e20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e23:	b8 09 00 00 00       	mov    $0x9,%eax
80102e28:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e29:	89 ca                	mov    %ecx,%edx
80102e2b:	ec                   	in     (%dx),%al
80102e2c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e2f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e35:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e38:	6a 18                	push   $0x18
80102e3a:	50                   	push   %eax
80102e3b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e3e:	50                   	push   %eax
80102e3f:	e8 0c 1c 00 00       	call   80104a50 <memcmp>
80102e44:	83 c4 10             	add    $0x10,%esp
80102e47:	85 c0                	test   %eax,%eax
80102e49:	0f 85 f1 fe ff ff    	jne    80102d40 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102e4f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e53:	75 78                	jne    80102ecd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e55:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e58:	89 c2                	mov    %eax,%edx
80102e5a:	83 e0 0f             	and    $0xf,%eax
80102e5d:	c1 ea 04             	shr    $0x4,%edx
80102e60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e66:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e69:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e6c:	89 c2                	mov    %eax,%edx
80102e6e:	83 e0 0f             	and    $0xf,%eax
80102e71:	c1 ea 04             	shr    $0x4,%edx
80102e74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e7a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e7d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e80:	89 c2                	mov    %eax,%edx
80102e82:	83 e0 0f             	and    $0xf,%eax
80102e85:	c1 ea 04             	shr    $0x4,%edx
80102e88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e8e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e94:	89 c2                	mov    %eax,%edx
80102e96:	83 e0 0f             	and    $0xf,%eax
80102e99:	c1 ea 04             	shr    $0x4,%edx
80102e9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ea2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ea5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ea8:	89 c2                	mov    %eax,%edx
80102eaa:	83 e0 0f             	and    $0xf,%eax
80102ead:	c1 ea 04             	shr    $0x4,%edx
80102eb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102eb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eb6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102eb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ebc:	89 c2                	mov    %eax,%edx
80102ebe:	83 e0 0f             	and    $0xf,%eax
80102ec1:	c1 ea 04             	shr    $0x4,%edx
80102ec4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ec7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eca:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ecd:	8b 75 08             	mov    0x8(%ebp),%esi
80102ed0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ed3:	89 06                	mov    %eax,(%esi)
80102ed5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ed8:	89 46 04             	mov    %eax,0x4(%esi)
80102edb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ede:	89 46 08             	mov    %eax,0x8(%esi)
80102ee1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ee4:	89 46 0c             	mov    %eax,0xc(%esi)
80102ee7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102eea:	89 46 10             	mov    %eax,0x10(%esi)
80102eed:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ef0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ef3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102efd:	5b                   	pop    %ebx
80102efe:	5e                   	pop    %esi
80102eff:	5f                   	pop    %edi
80102f00:	5d                   	pop    %ebp
80102f01:	c3                   	ret    
80102f02:	66 90                	xchg   %ax,%ax
80102f04:	66 90                	xchg   %ax,%ax
80102f06:	66 90                	xchg   %ax,%ax
80102f08:	66 90                	xchg   %ax,%ax
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f10:	8b 0d 08 87 20 80    	mov    0x80208708,%ecx
80102f16:	85 c9                	test   %ecx,%ecx
80102f18:	0f 8e 8a 00 00 00    	jle    80102fa8 <install_trans+0x98>
{
80102f1e:	55                   	push   %ebp
80102f1f:	89 e5                	mov    %esp,%ebp
80102f21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102f22:	31 ff                	xor    %edi,%edi
{
80102f24:	56                   	push   %esi
80102f25:	53                   	push   %ebx
80102f26:	83 ec 0c             	sub    $0xc,%esp
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f30:	a1 f4 86 20 80       	mov    0x802086f4,%eax
80102f35:	83 ec 08             	sub    $0x8,%esp
80102f38:	01 f8                	add    %edi,%eax
80102f3a:	83 c0 01             	add    $0x1,%eax
80102f3d:	50                   	push   %eax
80102f3e:	ff 35 04 87 20 80    	pushl  0x80208704
80102f44:	e8 87 d1 ff ff       	call   801000d0 <bread>
80102f49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f4b:	58                   	pop    %eax
80102f4c:	5a                   	pop    %edx
80102f4d:	ff 34 bd 0c 87 20 80 	pushl  -0x7fdf78f4(,%edi,4)
80102f54:	ff 35 04 87 20 80    	pushl  0x80208704
  for (tail = 0; tail < log.lh.n; tail++) {
80102f5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f5d:	e8 6e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f6a:	68 00 02 00 00       	push   $0x200
80102f6f:	50                   	push   %eax
80102f70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f73:	50                   	push   %eax
80102f74:	e8 27 1b 00 00       	call   80104aa0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f79:	89 1c 24             	mov    %ebx,(%esp)
80102f7c:	e8 2f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f81:	89 34 24             	mov    %esi,(%esp)
80102f84:	e8 67 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f89:	89 1c 24             	mov    %ebx,(%esp)
80102f8c:	e8 5f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	39 3d 08 87 20 80    	cmp    %edi,0x80208708
80102f9a:	7f 94                	jg     80102f30 <install_trans+0x20>
  }
}
80102f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f9f:	5b                   	pop    %ebx
80102fa0:	5e                   	pop    %esi
80102fa1:	5f                   	pop    %edi
80102fa2:	5d                   	pop    %ebp
80102fa3:	c3                   	ret    
80102fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	c3                   	ret    
80102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fb7:	ff 35 f4 86 20 80    	pushl  0x802086f4
80102fbd:	ff 35 04 87 20 80    	pushl  0x80208704
80102fc3:	e8 08 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102fc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fcb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102fcd:	a1 08 87 20 80       	mov    0x80208708,%eax
80102fd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102fd5:	85 c0                	test   %eax,%eax
80102fd7:	7e 19                	jle    80102ff2 <write_head+0x42>
80102fd9:	31 d2                	xor    %edx,%edx
80102fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fdf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102fe0:	8b 0c 95 0c 87 20 80 	mov    -0x7fdf78f4(,%edx,4),%ecx
80102fe7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102feb:	83 c2 01             	add    $0x1,%edx
80102fee:	39 d0                	cmp    %edx,%eax
80102ff0:	75 ee                	jne    80102fe0 <write_head+0x30>
  }
  bwrite(buf);
80102ff2:	83 ec 0c             	sub    $0xc,%esp
80102ff5:	53                   	push   %ebx
80102ff6:	e8 b5 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ffb:	89 1c 24             	mov    %ebx,(%esp)
80102ffe:	e8 ed d1 ff ff       	call   801001f0 <brelse>
}
80103003:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103006:	83 c4 10             	add    $0x10,%esp
80103009:	c9                   	leave  
8010300a:	c3                   	ret    
8010300b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010300f:	90                   	nop

80103010 <initlog>:
{
80103010:	f3 0f 1e fb          	endbr32 
80103014:	55                   	push   %ebp
80103015:	89 e5                	mov    %esp,%ebp
80103017:	53                   	push   %ebx
80103018:	83 ec 2c             	sub    $0x2c,%esp
8010301b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010301e:	68 a0 7a 10 80       	push   $0x80107aa0
80103023:	68 c0 86 20 80       	push   $0x802086c0
80103028:	e8 43 17 00 00       	call   80104770 <initlock>
  readsb(dev, &sb);
8010302d:	58                   	pop    %eax
8010302e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103031:	5a                   	pop    %edx
80103032:	50                   	push   %eax
80103033:	53                   	push   %ebx
80103034:	e8 47 e4 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80103039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010303c:	59                   	pop    %ecx
  log.dev = dev;
8010303d:	89 1d 04 87 20 80    	mov    %ebx,0x80208704
  log.size = sb.nlog;
80103043:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103046:	a3 f4 86 20 80       	mov    %eax,0x802086f4
  log.size = sb.nlog;
8010304b:	89 15 f8 86 20 80    	mov    %edx,0x802086f8
  struct buf *buf = bread(log.dev, log.start);
80103051:	5a                   	pop    %edx
80103052:	50                   	push   %eax
80103053:	53                   	push   %ebx
80103054:	e8 77 d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103059:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010305c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010305f:	89 0d 08 87 20 80    	mov    %ecx,0x80208708
  for (i = 0; i < log.lh.n; i++) {
80103065:	85 c9                	test   %ecx,%ecx
80103067:	7e 19                	jle    80103082 <initlog+0x72>
80103069:	31 d2                	xor    %edx,%edx
8010306b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010306f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103070:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103074:	89 1c 95 0c 87 20 80 	mov    %ebx,-0x7fdf78f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010307b:	83 c2 01             	add    $0x1,%edx
8010307e:	39 d1                	cmp    %edx,%ecx
80103080:	75 ee                	jne    80103070 <initlog+0x60>
  brelse(buf);
80103082:	83 ec 0c             	sub    $0xc,%esp
80103085:	50                   	push   %eax
80103086:	e8 65 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010308b:	e8 80 fe ff ff       	call   80102f10 <install_trans>
  log.lh.n = 0;
80103090:	c7 05 08 87 20 80 00 	movl   $0x0,0x80208708
80103097:	00 00 00 
  write_head(); // clear the log
8010309a:	e8 11 ff ff ff       	call   80102fb0 <write_head>
}
8010309f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030a2:	83 c4 10             	add    $0x10,%esp
801030a5:	c9                   	leave  
801030a6:	c3                   	ret    
801030a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ae:	66 90                	xchg   %ax,%ax

801030b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801030b0:	f3 0f 1e fb          	endbr32 
801030b4:	55                   	push   %ebp
801030b5:	89 e5                	mov    %esp,%ebp
801030b7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801030ba:	68 c0 86 20 80       	push   $0x802086c0
801030bf:	e8 2c 18 00 00       	call   801048f0 <acquire>
801030c4:	83 c4 10             	add    $0x10,%esp
801030c7:	eb 1c                	jmp    801030e5 <begin_op+0x35>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030d0:	83 ec 08             	sub    $0x8,%esp
801030d3:	68 c0 86 20 80       	push   $0x802086c0
801030d8:	68 c0 86 20 80       	push   $0x802086c0
801030dd:	e8 ce 11 00 00       	call   801042b0 <sleep>
801030e2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030e5:	a1 00 87 20 80       	mov    0x80208700,%eax
801030ea:	85 c0                	test   %eax,%eax
801030ec:	75 e2                	jne    801030d0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030ee:	a1 fc 86 20 80       	mov    0x802086fc,%eax
801030f3:	8b 15 08 87 20 80    	mov    0x80208708,%edx
801030f9:	83 c0 01             	add    $0x1,%eax
801030fc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030ff:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103102:	83 fa 1e             	cmp    $0x1e,%edx
80103105:	7f c9                	jg     801030d0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103107:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010310a:	a3 fc 86 20 80       	mov    %eax,0x802086fc
      release(&log.lock);
8010310f:	68 c0 86 20 80       	push   $0x802086c0
80103114:	e8 97 18 00 00       	call   801049b0 <release>
      break;
    }
  }
}
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	c9                   	leave  
8010311d:	c3                   	ret    
8010311e:	66 90                	xchg   %ax,%ax

80103120 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103120:	f3 0f 1e fb          	endbr32 
80103124:	55                   	push   %ebp
80103125:	89 e5                	mov    %esp,%ebp
80103127:	57                   	push   %edi
80103128:	56                   	push   %esi
80103129:	53                   	push   %ebx
8010312a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010312d:	68 c0 86 20 80       	push   $0x802086c0
80103132:	e8 b9 17 00 00       	call   801048f0 <acquire>
  log.outstanding -= 1;
80103137:	a1 fc 86 20 80       	mov    0x802086fc,%eax
  if(log.committing)
8010313c:	8b 35 00 87 20 80    	mov    0x80208700,%esi
80103142:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103145:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103148:	89 1d fc 86 20 80    	mov    %ebx,0x802086fc
  if(log.committing)
8010314e:	85 f6                	test   %esi,%esi
80103150:	0f 85 1e 01 00 00    	jne    80103274 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103156:	85 db                	test   %ebx,%ebx
80103158:	0f 85 f2 00 00 00    	jne    80103250 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010315e:	c7 05 00 87 20 80 01 	movl   $0x1,0x80208700
80103165:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103168:	83 ec 0c             	sub    $0xc,%esp
8010316b:	68 c0 86 20 80       	push   $0x802086c0
80103170:	e8 3b 18 00 00       	call   801049b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103175:	8b 0d 08 87 20 80    	mov    0x80208708,%ecx
8010317b:	83 c4 10             	add    $0x10,%esp
8010317e:	85 c9                	test   %ecx,%ecx
80103180:	7f 3e                	jg     801031c0 <end_op+0xa0>
    acquire(&log.lock);
80103182:	83 ec 0c             	sub    $0xc,%esp
80103185:	68 c0 86 20 80       	push   $0x802086c0
8010318a:	e8 61 17 00 00       	call   801048f0 <acquire>
    wakeup(&log);
8010318f:	c7 04 24 c0 86 20 80 	movl   $0x802086c0,(%esp)
    log.committing = 0;
80103196:	c7 05 00 87 20 80 00 	movl   $0x0,0x80208700
8010319d:	00 00 00 
    wakeup(&log);
801031a0:	e8 cb 12 00 00       	call   80104470 <wakeup>
    release(&log.lock);
801031a5:	c7 04 24 c0 86 20 80 	movl   $0x802086c0,(%esp)
801031ac:	e8 ff 17 00 00       	call   801049b0 <release>
801031b1:	83 c4 10             	add    $0x10,%esp
}
801031b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031b7:	5b                   	pop    %ebx
801031b8:	5e                   	pop    %esi
801031b9:	5f                   	pop    %edi
801031ba:	5d                   	pop    %ebp
801031bb:	c3                   	ret    
801031bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031c0:	a1 f4 86 20 80       	mov    0x802086f4,%eax
801031c5:	83 ec 08             	sub    $0x8,%esp
801031c8:	01 d8                	add    %ebx,%eax
801031ca:	83 c0 01             	add    $0x1,%eax
801031cd:	50                   	push   %eax
801031ce:	ff 35 04 87 20 80    	pushl  0x80208704
801031d4:	e8 f7 ce ff ff       	call   801000d0 <bread>
801031d9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031db:	58                   	pop    %eax
801031dc:	5a                   	pop    %edx
801031dd:	ff 34 9d 0c 87 20 80 	pushl  -0x7fdf78f4(,%ebx,4)
801031e4:	ff 35 04 87 20 80    	pushl  0x80208704
  for (tail = 0; tail < log.lh.n; tail++) {
801031ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031ed:	e8 de ce ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801031f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031f5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801031fa:	68 00 02 00 00       	push   $0x200
801031ff:	50                   	push   %eax
80103200:	8d 46 5c             	lea    0x5c(%esi),%eax
80103203:	50                   	push   %eax
80103204:	e8 97 18 00 00       	call   80104aa0 <memmove>
    bwrite(to);  // write the log
80103209:	89 34 24             	mov    %esi,(%esp)
8010320c:	e8 9f cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103211:	89 3c 24             	mov    %edi,(%esp)
80103214:	e8 d7 cf ff ff       	call   801001f0 <brelse>
    brelse(to);
80103219:	89 34 24             	mov    %esi,(%esp)
8010321c:	e8 cf cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103221:	83 c4 10             	add    $0x10,%esp
80103224:	3b 1d 08 87 20 80    	cmp    0x80208708,%ebx
8010322a:	7c 94                	jl     801031c0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010322c:	e8 7f fd ff ff       	call   80102fb0 <write_head>
    install_trans(); // Now install writes to home locations
80103231:	e8 da fc ff ff       	call   80102f10 <install_trans>
    log.lh.n = 0;
80103236:	c7 05 08 87 20 80 00 	movl   $0x0,0x80208708
8010323d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103240:	e8 6b fd ff ff       	call   80102fb0 <write_head>
80103245:	e9 38 ff ff ff       	jmp    80103182 <end_op+0x62>
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103250:	83 ec 0c             	sub    $0xc,%esp
80103253:	68 c0 86 20 80       	push   $0x802086c0
80103258:	e8 13 12 00 00       	call   80104470 <wakeup>
  release(&log.lock);
8010325d:	c7 04 24 c0 86 20 80 	movl   $0x802086c0,(%esp)
80103264:	e8 47 17 00 00       	call   801049b0 <release>
80103269:	83 c4 10             	add    $0x10,%esp
}
8010326c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010326f:	5b                   	pop    %ebx
80103270:	5e                   	pop    %esi
80103271:	5f                   	pop    %edi
80103272:	5d                   	pop    %ebp
80103273:	c3                   	ret    
    panic("log.committing");
80103274:	83 ec 0c             	sub    $0xc,%esp
80103277:	68 a4 7a 10 80       	push   $0x80107aa4
8010327c:	e8 0f d1 ff ff       	call   80100390 <panic>
80103281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop

80103290 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103290:	f3 0f 1e fb          	endbr32 
80103294:	55                   	push   %ebp
80103295:	89 e5                	mov    %esp,%ebp
80103297:	53                   	push   %ebx
80103298:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010329b:	8b 15 08 87 20 80    	mov    0x80208708,%edx
{
801032a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032a4:	83 fa 1d             	cmp    $0x1d,%edx
801032a7:	0f 8f 91 00 00 00    	jg     8010333e <log_write+0xae>
801032ad:	a1 f8 86 20 80       	mov    0x802086f8,%eax
801032b2:	83 e8 01             	sub    $0x1,%eax
801032b5:	39 c2                	cmp    %eax,%edx
801032b7:	0f 8d 81 00 00 00    	jge    8010333e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032bd:	a1 fc 86 20 80       	mov    0x802086fc,%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	0f 8e 81 00 00 00    	jle    8010334b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032ca:	83 ec 0c             	sub    $0xc,%esp
801032cd:	68 c0 86 20 80       	push   $0x802086c0
801032d2:	e8 19 16 00 00       	call   801048f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032d7:	8b 15 08 87 20 80    	mov    0x80208708,%edx
801032dd:	83 c4 10             	add    $0x10,%esp
801032e0:	85 d2                	test   %edx,%edx
801032e2:	7e 4e                	jle    80103332 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032e4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801032e7:	31 c0                	xor    %eax,%eax
801032e9:	eb 0c                	jmp    801032f7 <log_write+0x67>
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	83 c0 01             	add    $0x1,%eax
801032f3:	39 c2                	cmp    %eax,%edx
801032f5:	74 29                	je     80103320 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032f7:	39 0c 85 0c 87 20 80 	cmp    %ecx,-0x7fdf78f4(,%eax,4)
801032fe:	75 f0                	jne    801032f0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103300:	89 0c 85 0c 87 20 80 	mov    %ecx,-0x7fdf78f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103307:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010330a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010330d:	c7 45 08 c0 86 20 80 	movl   $0x802086c0,0x8(%ebp)
}
80103314:	c9                   	leave  
  release(&log.lock);
80103315:	e9 96 16 00 00       	jmp    801049b0 <release>
8010331a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103320:	89 0c 95 0c 87 20 80 	mov    %ecx,-0x7fdf78f4(,%edx,4)
    log.lh.n++;
80103327:	83 c2 01             	add    $0x1,%edx
8010332a:	89 15 08 87 20 80    	mov    %edx,0x80208708
80103330:	eb d5                	jmp    80103307 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103332:	8b 43 08             	mov    0x8(%ebx),%eax
80103335:	a3 0c 87 20 80       	mov    %eax,0x8020870c
  if (i == log.lh.n)
8010333a:	75 cb                	jne    80103307 <log_write+0x77>
8010333c:	eb e9                	jmp    80103327 <log_write+0x97>
    panic("too big a transaction");
8010333e:	83 ec 0c             	sub    $0xc,%esp
80103341:	68 b3 7a 10 80       	push   $0x80107ab3
80103346:	e8 45 d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010334b:	83 ec 0c             	sub    $0xc,%esp
8010334e:	68 c9 7a 10 80       	push   $0x80107ac9
80103353:	e8 38 d0 ff ff       	call   80100390 <panic>
80103358:	66 90                	xchg   %ax,%ax
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	53                   	push   %ebx
80103364:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103367:	e8 54 09 00 00       	call   80103cc0 <cpuid>
8010336c:	89 c3                	mov    %eax,%ebx
8010336e:	e8 4d 09 00 00       	call   80103cc0 <cpuid>
80103373:	83 ec 04             	sub    $0x4,%esp
80103376:	53                   	push   %ebx
80103377:	50                   	push   %eax
80103378:	68 e4 7a 10 80       	push   $0x80107ae4
8010337d:	e8 2e d3 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103382:	e8 49 2a 00 00       	call   80105dd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103387:	e8 c4 08 00 00       	call   80103c50 <mycpu>
8010338c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010338e:	b8 01 00 00 00       	mov    $0x1,%eax
80103393:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010339a:	e8 21 0c 00 00       	call   80103fc0 <scheduler>
8010339f:	90                   	nop

801033a0 <mpenter>:
{
801033a0:	f3 0f 1e fb          	endbr32 
801033a4:	55                   	push   %ebp
801033a5:	89 e5                	mov    %esp,%ebp
801033a7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801033aa:	e8 f1 3a 00 00       	call   80106ea0 <switchkvm>
  seginit();
801033af:	e8 8c 38 00 00       	call   80106c40 <seginit>
  lapicinit();
801033b4:	e8 67 f7 ff ff       	call   80102b20 <lapicinit>
  mpmain();
801033b9:	e8 a2 ff ff ff       	call   80103360 <mpmain>
801033be:	66 90                	xchg   %ax,%ax

801033c0 <main>:
{
801033c0:	f3 0f 1e fb          	endbr32 
801033c4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801033c8:	83 e4 f0             	and    $0xfffffff0,%esp
801033cb:	ff 71 fc             	pushl  -0x4(%ecx)
801033ce:	55                   	push   %ebp
801033cf:	89 e5                	mov    %esp,%ebp
801033d1:	53                   	push   %ebx
801033d2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033d3:	83 ec 08             	sub    $0x8,%esp
801033d6:	68 00 00 40 80       	push   $0x80400000
801033db:	68 e8 b4 20 80       	push   $0x8020b4e8
801033e0:	e8 4b f4 ff ff       	call   80102830 <kinit1>
  kvmalloc();      // kernel page table
801033e5:	e8 96 3f 00 00       	call   80107380 <kvmalloc>
  mpinit();        // detect other processors
801033ea:	e8 81 01 00 00       	call   80103570 <mpinit>
  lapicinit();     // interrupt controller
801033ef:	e8 2c f7 ff ff       	call   80102b20 <lapicinit>
  seginit();       // segment descriptors
801033f4:	e8 47 38 00 00       	call   80106c40 <seginit>
  picinit();       // disable pic
801033f9:	e8 52 03 00 00       	call   80103750 <picinit>
  ioapicinit();    // another interrupt controller
801033fe:	e8 8d f0 ff ff       	call   80102490 <ioapicinit>
  consoleinit();   // console hardware
80103403:	e8 28 d6 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103408:	e8 b3 2c 00 00       	call   801060c0 <uartinit>
  pinit();         // process table
8010340d:	e8 1e 08 00 00       	call   80103c30 <pinit>
  tvinit();        // trap vectors
80103412:	e8 39 29 00 00       	call   80105d50 <tvinit>
  binit();         // buffer cache
80103417:	e8 24 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010341c:	e8 bf d9 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103421:	e8 3a ee ff ff       	call   80102260 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103426:	83 c4 0c             	add    $0xc,%esp
80103429:	68 8a 00 00 00       	push   $0x8a
8010342e:	68 8c a4 10 80       	push   $0x8010a48c
80103433:	68 00 70 00 80       	push   $0x80007000
80103438:	e8 63 16 00 00       	call   80104aa0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010343d:	83 c4 10             	add    $0x10,%esp
80103440:	69 05 40 8d 20 80 b0 	imul   $0xb0,0x80208d40,%eax
80103447:	00 00 00 
8010344a:	05 c0 87 20 80       	add    $0x802087c0,%eax
8010344f:	3d c0 87 20 80       	cmp    $0x802087c0,%eax
80103454:	76 7a                	jbe    801034d0 <main+0x110>
80103456:	bb c0 87 20 80       	mov    $0x802087c0,%ebx
8010345b:	eb 1c                	jmp    80103479 <main+0xb9>
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
80103460:	69 05 40 8d 20 80 b0 	imul   $0xb0,0x80208d40,%eax
80103467:	00 00 00 
8010346a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103470:	05 c0 87 20 80       	add    $0x802087c0,%eax
80103475:	39 c3                	cmp    %eax,%ebx
80103477:	73 57                	jae    801034d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103479:	e8 d2 07 00 00       	call   80103c50 <mycpu>
8010347e:	39 c3                	cmp    %eax,%ebx
80103480:	74 de                	je     80103460 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103482:	e8 29 f5 ff ff       	call   801029b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103487:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010348a:	c7 05 f8 6f 00 80 a0 	movl   $0x801033a0,0x80006ff8
80103491:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103494:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010349b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010349e:	05 00 10 00 00       	add    $0x1000,%eax
801034a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801034a8:	0f b6 03             	movzbl (%ebx),%eax
801034ab:	68 00 70 00 00       	push   $0x7000
801034b0:	50                   	push   %eax
801034b1:	e8 ba f7 ff ff       	call   80102c70 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034b6:	83 c4 10             	add    $0x10,%esp
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801034c6:	85 c0                	test   %eax,%eax
801034c8:	74 f6                	je     801034c0 <main+0x100>
801034ca:	eb 94                	jmp    80103460 <main+0xa0>
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034d0:	83 ec 08             	sub    $0x8,%esp
801034d3:	68 00 00 00 8e       	push   $0x8e000000
801034d8:	68 00 00 40 80       	push   $0x80400000
801034dd:	e8 be f3 ff ff       	call   801028a0 <kinit2>
  userinit();      // first user process
801034e2:	e8 29 08 00 00       	call   80103d10 <userinit>
  mpmain();        // finish this processor's setup
801034e7:	e8 74 fe ff ff       	call   80103360 <mpmain>
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034fb:	53                   	push   %ebx
  e = addr+len;
801034fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103502:	39 de                	cmp    %ebx,%esi
80103504:	72 10                	jb     80103516 <mpsearch1+0x26>
80103506:	eb 50                	jmp    80103558 <mpsearch1+0x68>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop
80103510:	89 fe                	mov    %edi,%esi
80103512:	39 fb                	cmp    %edi,%ebx
80103514:	76 42                	jbe    80103558 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103516:	83 ec 04             	sub    $0x4,%esp
80103519:	8d 7e 10             	lea    0x10(%esi),%edi
8010351c:	6a 04                	push   $0x4
8010351e:	68 f8 7a 10 80       	push   $0x80107af8
80103523:	56                   	push   %esi
80103524:	e8 27 15 00 00       	call   80104a50 <memcmp>
80103529:	83 c4 10             	add    $0x10,%esp
8010352c:	85 c0                	test   %eax,%eax
8010352e:	75 e0                	jne    80103510 <mpsearch1+0x20>
80103530:	89 f2                	mov    %esi,%edx
80103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103538:	0f b6 0a             	movzbl (%edx),%ecx
8010353b:	83 c2 01             	add    $0x1,%edx
8010353e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103540:	39 fa                	cmp    %edi,%edx
80103542:	75 f4                	jne    80103538 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103544:	84 c0                	test   %al,%al
80103546:	75 c8                	jne    80103510 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103548:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010354b:	89 f0                	mov    %esi,%eax
8010354d:	5b                   	pop    %ebx
8010354e:	5e                   	pop    %esi
8010354f:	5f                   	pop    %edi
80103550:	5d                   	pop    %ebp
80103551:	c3                   	ret    
80103552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103558:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010355b:	31 f6                	xor    %esi,%esi
}
8010355d:	5b                   	pop    %ebx
8010355e:	89 f0                	mov    %esi,%eax
80103560:	5e                   	pop    %esi
80103561:	5f                   	pop    %edi
80103562:	5d                   	pop    %ebp
80103563:	c3                   	ret    
80103564:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010356b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010356f:	90                   	nop

80103570 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103570:	f3 0f 1e fb          	endbr32 
80103574:	55                   	push   %ebp
80103575:	89 e5                	mov    %esp,%ebp
80103577:	57                   	push   %edi
80103578:	56                   	push   %esi
80103579:	53                   	push   %ebx
8010357a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010357d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103584:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010358b:	c1 e0 08             	shl    $0x8,%eax
8010358e:	09 d0                	or     %edx,%eax
80103590:	c1 e0 04             	shl    $0x4,%eax
80103593:	75 1b                	jne    801035b0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103595:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010359c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801035a3:	c1 e0 08             	shl    $0x8,%eax
801035a6:	09 d0                	or     %edx,%eax
801035a8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801035ab:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801035b0:	ba 00 04 00 00       	mov    $0x400,%edx
801035b5:	e8 36 ff ff ff       	call   801034f0 <mpsearch1>
801035ba:	89 c6                	mov    %eax,%esi
801035bc:	85 c0                	test   %eax,%eax
801035be:	0f 84 4c 01 00 00    	je     80103710 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035c4:	8b 5e 04             	mov    0x4(%esi),%ebx
801035c7:	85 db                	test   %ebx,%ebx
801035c9:	0f 84 61 01 00 00    	je     80103730 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801035cf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035d2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801035d8:	6a 04                	push   $0x4
801035da:	68 fd 7a 10 80       	push   $0x80107afd
801035df:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801035e3:	e8 68 14 00 00       	call   80104a50 <memcmp>
801035e8:	83 c4 10             	add    $0x10,%esp
801035eb:	85 c0                	test   %eax,%eax
801035ed:	0f 85 3d 01 00 00    	jne    80103730 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801035f3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801035fa:	3c 01                	cmp    $0x1,%al
801035fc:	74 08                	je     80103606 <mpinit+0x96>
801035fe:	3c 04                	cmp    $0x4,%al
80103600:	0f 85 2a 01 00 00    	jne    80103730 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103606:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010360d:	66 85 d2             	test   %dx,%dx
80103610:	74 26                	je     80103638 <mpinit+0xc8>
80103612:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103615:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103617:	31 d2                	xor    %edx,%edx
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103620:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103627:	83 c0 01             	add    $0x1,%eax
8010362a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010362c:	39 f8                	cmp    %edi,%eax
8010362e:	75 f0                	jne    80103620 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103630:	84 d2                	test   %dl,%dl
80103632:	0f 85 f8 00 00 00    	jne    80103730 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103638:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010363e:	a3 ac 86 20 80       	mov    %eax,0x802086ac
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103643:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103649:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103650:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103655:	03 55 e4             	add    -0x1c(%ebp),%edx
80103658:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010365b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010365f:	90                   	nop
80103660:	39 c2                	cmp    %eax,%edx
80103662:	76 15                	jbe    80103679 <mpinit+0x109>
    switch(*p){
80103664:	0f b6 08             	movzbl (%eax),%ecx
80103667:	80 f9 02             	cmp    $0x2,%cl
8010366a:	74 5c                	je     801036c8 <mpinit+0x158>
8010366c:	77 42                	ja     801036b0 <mpinit+0x140>
8010366e:	84 c9                	test   %cl,%cl
80103670:	74 6e                	je     801036e0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103672:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103675:	39 c2                	cmp    %eax,%edx
80103677:	77 eb                	ja     80103664 <mpinit+0xf4>
80103679:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010367c:	85 db                	test   %ebx,%ebx
8010367e:	0f 84 b9 00 00 00    	je     8010373d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103684:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103688:	74 15                	je     8010369f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010368a:	b8 70 00 00 00       	mov    $0x70,%eax
8010368f:	ba 22 00 00 00       	mov    $0x22,%edx
80103694:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103695:	ba 23 00 00 00       	mov    $0x23,%edx
8010369a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010369b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010369e:	ee                   	out    %al,(%dx)
  }
}
8010369f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036a2:	5b                   	pop    %ebx
801036a3:	5e                   	pop    %esi
801036a4:	5f                   	pop    %edi
801036a5:	5d                   	pop    %ebp
801036a6:	c3                   	ret    
801036a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ae:	66 90                	xchg   %ax,%ax
    switch(*p){
801036b0:	83 e9 03             	sub    $0x3,%ecx
801036b3:	80 f9 01             	cmp    $0x1,%cl
801036b6:	76 ba                	jbe    80103672 <mpinit+0x102>
801036b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801036bf:	eb 9f                	jmp    80103660 <mpinit+0xf0>
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801036c8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801036cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801036cf:	88 0d a0 87 20 80    	mov    %cl,0x802087a0
      continue;
801036d5:	eb 89                	jmp    80103660 <mpinit+0xf0>
801036d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036de:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801036e0:	8b 0d 40 8d 20 80    	mov    0x80208d40,%ecx
801036e6:	83 f9 07             	cmp    $0x7,%ecx
801036e9:	7f 19                	jg     80103704 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036eb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801036f1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801036f5:	83 c1 01             	add    $0x1,%ecx
801036f8:	89 0d 40 8d 20 80    	mov    %ecx,0x80208d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036fe:	88 9f c0 87 20 80    	mov    %bl,-0x7fdf7840(%edi)
      p += sizeof(struct mpproc);
80103704:	83 c0 14             	add    $0x14,%eax
      continue;
80103707:	e9 54 ff ff ff       	jmp    80103660 <mpinit+0xf0>
8010370c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103710:	ba 00 00 01 00       	mov    $0x10000,%edx
80103715:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010371a:	e8 d1 fd ff ff       	call   801034f0 <mpsearch1>
8010371f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103721:	85 c0                	test   %eax,%eax
80103723:	0f 85 9b fe ff ff    	jne    801035c4 <mpinit+0x54>
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 02 7b 10 80       	push   $0x80107b02
80103738:	e8 53 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010373d:	83 ec 0c             	sub    $0xc,%esp
80103740:	68 1c 7b 10 80       	push   $0x80107b1c
80103745:	e8 46 cc ff ff       	call   80100390 <panic>
8010374a:	66 90                	xchg   %ax,%ax
8010374c:	66 90                	xchg   %ax,%ax
8010374e:	66 90                	xchg   %ax,%ax

80103750 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103750:	f3 0f 1e fb          	endbr32 
80103754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103759:	ba 21 00 00 00       	mov    $0x21,%edx
8010375e:	ee                   	out    %al,(%dx)
8010375f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103764:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103765:	c3                   	ret    
80103766:	66 90                	xchg   %ax,%ax
80103768:	66 90                	xchg   %ax,%ax
8010376a:	66 90                	xchg   %ax,%ax
8010376c:	66 90                	xchg   %ax,%ax
8010376e:	66 90                	xchg   %ax,%ax

80103770 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103770:	f3 0f 1e fb          	endbr32 
80103774:	55                   	push   %ebp
80103775:	89 e5                	mov    %esp,%ebp
80103777:	57                   	push   %edi
80103778:	56                   	push   %esi
80103779:	53                   	push   %ebx
8010377a:	83 ec 0c             	sub    $0xc,%esp
8010377d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103780:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103783:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103789:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010378f:	e8 6c d6 ff ff       	call   80100e00 <filealloc>
80103794:	89 03                	mov    %eax,(%ebx)
80103796:	85 c0                	test   %eax,%eax
80103798:	0f 84 ac 00 00 00    	je     8010384a <pipealloc+0xda>
8010379e:	e8 5d d6 ff ff       	call   80100e00 <filealloc>
801037a3:	89 06                	mov    %eax,(%esi)
801037a5:	85 c0                	test   %eax,%eax
801037a7:	0f 84 8b 00 00 00    	je     80103838 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801037ad:	e8 fe f1 ff ff       	call   801029b0 <kalloc>
801037b2:	89 c7                	mov    %eax,%edi
801037b4:	85 c0                	test   %eax,%eax
801037b6:	0f 84 b4 00 00 00    	je     80103870 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801037bc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037c3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801037c6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801037c9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037d0:	00 00 00 
  p->nwrite = 0;
801037d3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037da:	00 00 00 
  p->nread = 0;
801037dd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037e4:	00 00 00 
  initlock(&p->lock, "pipe");
801037e7:	68 3b 7b 10 80       	push   $0x80107b3b
801037ec:	50                   	push   %eax
801037ed:	e8 7e 0f 00 00       	call   80104770 <initlock>
  (*f0)->type = FD_PIPE;
801037f2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801037f4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037fd:	8b 03                	mov    (%ebx),%eax
801037ff:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103803:	8b 03                	mov    (%ebx),%eax
80103805:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103809:	8b 03                	mov    (%ebx),%eax
8010380b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010380e:	8b 06                	mov    (%esi),%eax
80103810:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103816:	8b 06                	mov    (%esi),%eax
80103818:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010381c:	8b 06                	mov    (%esi),%eax
8010381e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103822:	8b 06                	mov    (%esi),%eax
80103824:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103827:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010382a:	31 c0                	xor    %eax,%eax
}
8010382c:	5b                   	pop    %ebx
8010382d:	5e                   	pop    %esi
8010382e:	5f                   	pop    %edi
8010382f:	5d                   	pop    %ebp
80103830:	c3                   	ret    
80103831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103838:	8b 03                	mov    (%ebx),%eax
8010383a:	85 c0                	test   %eax,%eax
8010383c:	74 1e                	je     8010385c <pipealloc+0xec>
    fileclose(*f0);
8010383e:	83 ec 0c             	sub    $0xc,%esp
80103841:	50                   	push   %eax
80103842:	e8 79 d6 ff ff       	call   80100ec0 <fileclose>
80103847:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010384a:	8b 06                	mov    (%esi),%eax
8010384c:	85 c0                	test   %eax,%eax
8010384e:	74 0c                	je     8010385c <pipealloc+0xec>
    fileclose(*f1);
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	50                   	push   %eax
80103854:	e8 67 d6 ff ff       	call   80100ec0 <fileclose>
80103859:	83 c4 10             	add    $0x10,%esp
}
8010385c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010385f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103864:	5b                   	pop    %ebx
80103865:	5e                   	pop    %esi
80103866:	5f                   	pop    %edi
80103867:	5d                   	pop    %ebp
80103868:	c3                   	ret    
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103870:	8b 03                	mov    (%ebx),%eax
80103872:	85 c0                	test   %eax,%eax
80103874:	75 c8                	jne    8010383e <pipealloc+0xce>
80103876:	eb d2                	jmp    8010384a <pipealloc+0xda>
80103878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop

80103880 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	56                   	push   %esi
80103888:	53                   	push   %ebx
80103889:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010388c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010388f:	83 ec 0c             	sub    $0xc,%esp
80103892:	53                   	push   %ebx
80103893:	e8 58 10 00 00       	call   801048f0 <acquire>
  if(writable){
80103898:	83 c4 10             	add    $0x10,%esp
8010389b:	85 f6                	test   %esi,%esi
8010389d:	74 41                	je     801038e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010389f:	83 ec 0c             	sub    $0xc,%esp
801038a2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801038a8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801038af:	00 00 00 
    wakeup(&p->nread);
801038b2:	50                   	push   %eax
801038b3:	e8 b8 0b 00 00       	call   80104470 <wakeup>
801038b8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801038bb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801038c1:	85 d2                	test   %edx,%edx
801038c3:	75 0a                	jne    801038cf <pipeclose+0x4f>
801038c5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038cb:	85 c0                	test   %eax,%eax
801038cd:	74 31                	je     80103900 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038d5:	5b                   	pop    %ebx
801038d6:	5e                   	pop    %esi
801038d7:	5d                   	pop    %ebp
    release(&p->lock);
801038d8:	e9 d3 10 00 00       	jmp    801049b0 <release>
801038dd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038f0:	00 00 00 
    wakeup(&p->nwrite);
801038f3:	50                   	push   %eax
801038f4:	e8 77 0b 00 00       	call   80104470 <wakeup>
801038f9:	83 c4 10             	add    $0x10,%esp
801038fc:	eb bd                	jmp    801038bb <pipeclose+0x3b>
801038fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	53                   	push   %ebx
80103904:	e8 a7 10 00 00       	call   801049b0 <release>
    kfree((char*)p);
80103909:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010390c:	83 c4 10             	add    $0x10,%esp
}
8010390f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103912:	5b                   	pop    %ebx
80103913:	5e                   	pop    %esi
80103914:	5d                   	pop    %ebp
    kfree((char*)p);
80103915:	e9 26 ee ff ff       	jmp    80102740 <kfree>
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103920 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	55                   	push   %ebp
80103925:	89 e5                	mov    %esp,%ebp
80103927:	57                   	push   %edi
80103928:	56                   	push   %esi
80103929:	53                   	push   %ebx
8010392a:	83 ec 28             	sub    $0x28,%esp
8010392d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103930:	53                   	push   %ebx
80103931:	e8 ba 0f 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++){
80103936:	8b 45 10             	mov    0x10(%ebp),%eax
80103939:	83 c4 10             	add    $0x10,%esp
8010393c:	85 c0                	test   %eax,%eax
8010393e:	0f 8e bc 00 00 00    	jle    80103a00 <pipewrite+0xe0>
80103944:	8b 45 0c             	mov    0xc(%ebp),%eax
80103947:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010394d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103953:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103956:	03 45 10             	add    0x10(%ebp),%eax
80103959:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010395c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103962:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103968:	89 ca                	mov    %ecx,%edx
8010396a:	05 00 02 00 00       	add    $0x200,%eax
8010396f:	39 c1                	cmp    %eax,%ecx
80103971:	74 3b                	je     801039ae <pipewrite+0x8e>
80103973:	eb 63                	jmp    801039d8 <pipewrite+0xb8>
80103975:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103978:	e8 63 03 00 00       	call   80103ce0 <myproc>
8010397d:	8b 48 24             	mov    0x24(%eax),%ecx
80103980:	85 c9                	test   %ecx,%ecx
80103982:	75 34                	jne    801039b8 <pipewrite+0x98>
      wakeup(&p->nread);
80103984:	83 ec 0c             	sub    $0xc,%esp
80103987:	57                   	push   %edi
80103988:	e8 e3 0a 00 00       	call   80104470 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010398d:	58                   	pop    %eax
8010398e:	5a                   	pop    %edx
8010398f:	53                   	push   %ebx
80103990:	56                   	push   %esi
80103991:	e8 1a 09 00 00       	call   801042b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103996:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010399c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801039a2:	83 c4 10             	add    $0x10,%esp
801039a5:	05 00 02 00 00       	add    $0x200,%eax
801039aa:	39 c2                	cmp    %eax,%edx
801039ac:	75 2a                	jne    801039d8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801039ae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	75 c0                	jne    80103978 <pipewrite+0x58>
        release(&p->lock);
801039b8:	83 ec 0c             	sub    $0xc,%esp
801039bb:	53                   	push   %ebx
801039bc:	e8 ef 0f 00 00       	call   801049b0 <release>
        return -1;
801039c1:	83 c4 10             	add    $0x10,%esp
801039c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801039c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039cc:	5b                   	pop    %ebx
801039cd:	5e                   	pop    %esi
801039ce:	5f                   	pop    %edi
801039cf:	5d                   	pop    %ebp
801039d0:	c3                   	ret    
801039d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039db:	8d 4a 01             	lea    0x1(%edx),%ecx
801039de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039e4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801039ea:	0f b6 06             	movzbl (%esi),%eax
801039ed:	83 c6 01             	add    $0x1,%esi
801039f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801039f3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039f7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039fa:	0f 85 5c ff ff ff    	jne    8010395c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a00:	83 ec 0c             	sub    $0xc,%esp
80103a03:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a09:	50                   	push   %eax
80103a0a:	e8 61 0a 00 00       	call   80104470 <wakeup>
  release(&p->lock);
80103a0f:	89 1c 24             	mov    %ebx,(%esp)
80103a12:	e8 99 0f 00 00       	call   801049b0 <release>
  return n;
80103a17:	8b 45 10             	mov    0x10(%ebp),%eax
80103a1a:	83 c4 10             	add    $0x10,%esp
80103a1d:	eb aa                	jmp    801039c9 <pipewrite+0xa9>
80103a1f:	90                   	nop

80103a20 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	57                   	push   %edi
80103a28:	56                   	push   %esi
80103a29:	53                   	push   %ebx
80103a2a:	83 ec 18             	sub    $0x18,%esp
80103a2d:	8b 75 08             	mov    0x8(%ebp),%esi
80103a30:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a33:	56                   	push   %esi
80103a34:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a3a:	e8 b1 0e 00 00       	call   801048f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a3f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103a4e:	74 33                	je     80103a83 <piperead+0x63>
80103a50:	eb 3b                	jmp    80103a8d <piperead+0x6d>
80103a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103a58:	e8 83 02 00 00       	call   80103ce0 <myproc>
80103a5d:	8b 48 24             	mov    0x24(%eax),%ecx
80103a60:	85 c9                	test   %ecx,%ecx
80103a62:	0f 85 88 00 00 00    	jne    80103af0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a68:	83 ec 08             	sub    $0x8,%esp
80103a6b:	56                   	push   %esi
80103a6c:	53                   	push   %ebx
80103a6d:	e8 3e 08 00 00       	call   801042b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a72:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a78:	83 c4 10             	add    $0x10,%esp
80103a7b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a81:	75 0a                	jne    80103a8d <piperead+0x6d>
80103a83:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a89:	85 c0                	test   %eax,%eax
80103a8b:	75 cb                	jne    80103a58 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a8d:	8b 55 10             	mov    0x10(%ebp),%edx
80103a90:	31 db                	xor    %ebx,%ebx
80103a92:	85 d2                	test   %edx,%edx
80103a94:	7f 28                	jg     80103abe <piperead+0x9e>
80103a96:	eb 34                	jmp    80103acc <piperead+0xac>
80103a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103aa0:	8d 48 01             	lea    0x1(%eax),%ecx
80103aa3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103aa8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103aae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103ab3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ab6:	83 c3 01             	add    $0x1,%ebx
80103ab9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103abc:	74 0e                	je     80103acc <piperead+0xac>
    if(p->nread == p->nwrite)
80103abe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ac4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103aca:	75 d4                	jne    80103aa0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103acc:	83 ec 0c             	sub    $0xc,%esp
80103acf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ad5:	50                   	push   %eax
80103ad6:	e8 95 09 00 00       	call   80104470 <wakeup>
  release(&p->lock);
80103adb:	89 34 24             	mov    %esi,(%esp)
80103ade:	e8 cd 0e 00 00       	call   801049b0 <release>
  return i;
80103ae3:	83 c4 10             	add    $0x10,%esp
}
80103ae6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ae9:	89 d8                	mov    %ebx,%eax
80103aeb:	5b                   	pop    %ebx
80103aec:	5e                   	pop    %esi
80103aed:	5f                   	pop    %edi
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    
      release(&p->lock);
80103af0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103af3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103af8:	56                   	push   %esi
80103af9:	e8 b2 0e 00 00       	call   801049b0 <release>
      return -1;
80103afe:	83 c4 10             	add    $0x10,%esp
}
80103b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b04:	89 d8                	mov    %ebx,%eax
80103b06:	5b                   	pop    %ebx
80103b07:	5e                   	pop    %esi
80103b08:	5f                   	pop    %edi
80103b09:	5d                   	pop    %ebp
80103b0a:	c3                   	ret    
80103b0b:	66 90                	xchg   %ax,%ax
80103b0d:	66 90                	xchg   %ax,%ax
80103b0f:	90                   	nop

80103b10 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b14:	bb 94 8d 20 80       	mov    $0x80208d94,%ebx
{
80103b19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103b1c:	68 60 8d 20 80       	push   $0x80208d60
80103b21:	e8 ca 0d 00 00       	call   801048f0 <acquire>
80103b26:	83 c4 10             	add    $0x10,%esp
80103b29:	eb 10                	jmp    80103b3b <allocproc+0x2b>
80103b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b30:	83 c3 7c             	add    $0x7c,%ebx
80103b33:	81 fb 94 ac 20 80    	cmp    $0x8020ac94,%ebx
80103b39:	74 75                	je     80103bb0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103b3b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b3e:	85 c0                	test   %eax,%eax
80103b40:	75 ee                	jne    80103b30 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b42:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103b47:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b4a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b51:	89 43 10             	mov    %eax,0x10(%ebx)
80103b54:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103b57:	68 60 8d 20 80       	push   $0x80208d60
  p->pid = nextpid++;
80103b5c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103b62:	e8 49 0e 00 00       	call   801049b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b67:	e8 44 ee ff ff       	call   801029b0 <kalloc>
80103b6c:	83 c4 10             	add    $0x10,%esp
80103b6f:	89 43 08             	mov    %eax,0x8(%ebx)
80103b72:	85 c0                	test   %eax,%eax
80103b74:	74 53                	je     80103bc9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b76:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b7c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b7f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b84:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b87:	c7 40 14 36 5d 10 80 	movl   $0x80105d36,0x14(%eax)
  p->context = (struct context*)sp;
80103b8e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b91:	6a 14                	push   $0x14
80103b93:	6a 00                	push   $0x0
80103b95:	50                   	push   %eax
80103b96:	e8 65 0e 00 00       	call   80104a00 <memset>
  p->context->eip = (uint)forkret;
80103b9b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103b9e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103ba1:	c7 40 10 e0 3b 10 80 	movl   $0x80103be0,0x10(%eax)
}
80103ba8:	89 d8                	mov    %ebx,%eax
80103baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bad:	c9                   	leave  
80103bae:	c3                   	ret    
80103baf:	90                   	nop
  release(&ptable.lock);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103bb3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103bb5:	68 60 8d 20 80       	push   $0x80208d60
80103bba:	e8 f1 0d 00 00       	call   801049b0 <release>
}
80103bbf:	89 d8                	mov    %ebx,%eax
  return 0;
80103bc1:	83 c4 10             	add    $0x10,%esp
}
80103bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc7:	c9                   	leave  
80103bc8:	c3                   	ret    
    p->state = UNUSED;
80103bc9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103bd0:	31 db                	xor    %ebx,%ebx
}
80103bd2:	89 d8                	mov    %ebx,%eax
80103bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bd7:	c9                   	leave  
80103bd8:	c3                   	ret    
80103bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103be0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103bea:	68 60 8d 20 80       	push   $0x80208d60
80103bef:	e8 bc 0d 00 00       	call   801049b0 <release>

  if (first) {
80103bf4:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103bf9:	83 c4 10             	add    $0x10,%esp
80103bfc:	85 c0                	test   %eax,%eax
80103bfe:	75 08                	jne    80103c08 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c00:	c9                   	leave  
80103c01:	c3                   	ret    
80103c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103c08:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103c0f:	00 00 00 
    iinit(ROOTDEV);
80103c12:	83 ec 0c             	sub    $0xc,%esp
80103c15:	6a 01                	push   $0x1
80103c17:	e8 24 d9 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103c1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c23:	e8 e8 f3 ff ff       	call   80103010 <initlog>
}
80103c28:	83 c4 10             	add    $0x10,%esp
80103c2b:	c9                   	leave  
80103c2c:	c3                   	ret    
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi

80103c30 <pinit>:
{
80103c30:	f3 0f 1e fb          	endbr32 
80103c34:	55                   	push   %ebp
80103c35:	89 e5                	mov    %esp,%ebp
80103c37:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c3a:	68 40 7b 10 80       	push   $0x80107b40
80103c3f:	68 60 8d 20 80       	push   $0x80208d60
80103c44:	e8 27 0b 00 00       	call   80104770 <initlock>
}
80103c49:	83 c4 10             	add    $0x10,%esp
80103c4c:	c9                   	leave  
80103c4d:	c3                   	ret    
80103c4e:	66 90                	xchg   %ax,%ax

80103c50 <mycpu>:
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	56                   	push   %esi
80103c58:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c59:	9c                   	pushf  
80103c5a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c5b:	f6 c4 02             	test   $0x2,%ah
80103c5e:	75 4a                	jne    80103caa <mycpu+0x5a>
  apicid = lapicid();
80103c60:	e8 bb ef ff ff       	call   80102c20 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c65:	8b 35 40 8d 20 80    	mov    0x80208d40,%esi
  apicid = lapicid();
80103c6b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103c6d:	85 f6                	test   %esi,%esi
80103c6f:	7e 2c                	jle    80103c9d <mycpu+0x4d>
80103c71:	31 d2                	xor    %edx,%edx
80103c73:	eb 0a                	jmp    80103c7f <mycpu+0x2f>
80103c75:	8d 76 00             	lea    0x0(%esi),%esi
80103c78:	83 c2 01             	add    $0x1,%edx
80103c7b:	39 f2                	cmp    %esi,%edx
80103c7d:	74 1e                	je     80103c9d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103c7f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103c85:	0f b6 81 c0 87 20 80 	movzbl -0x7fdf7840(%ecx),%eax
80103c8c:	39 d8                	cmp    %ebx,%eax
80103c8e:	75 e8                	jne    80103c78 <mycpu+0x28>
}
80103c90:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c93:	8d 81 c0 87 20 80    	lea    -0x7fdf7840(%ecx),%eax
}
80103c99:	5b                   	pop    %ebx
80103c9a:	5e                   	pop    %esi
80103c9b:	5d                   	pop    %ebp
80103c9c:	c3                   	ret    
  panic("unknown apicid\n");
80103c9d:	83 ec 0c             	sub    $0xc,%esp
80103ca0:	68 47 7b 10 80       	push   $0x80107b47
80103ca5:	e8 e6 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103caa:	83 ec 0c             	sub    $0xc,%esp
80103cad:	68 2c 7c 10 80       	push   $0x80107c2c
80103cb2:	e8 d9 c6 ff ff       	call   80100390 <panic>
80103cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbe:	66 90                	xchg   %ax,%ax

80103cc0 <cpuid>:
cpuid() {
80103cc0:	f3 0f 1e fb          	endbr32 
80103cc4:	55                   	push   %ebp
80103cc5:	89 e5                	mov    %esp,%ebp
80103cc7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103cca:	e8 81 ff ff ff       	call   80103c50 <mycpu>
}
80103ccf:	c9                   	leave  
  return mycpu()-cpus;
80103cd0:	2d c0 87 20 80       	sub    $0x802087c0,%eax
80103cd5:	c1 f8 04             	sar    $0x4,%eax
80103cd8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103cde:	c3                   	ret    
80103cdf:	90                   	nop

80103ce0 <myproc>:
myproc(void) {
80103ce0:	f3 0f 1e fb          	endbr32 
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	53                   	push   %ebx
80103ce8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ceb:	e8 00 0b 00 00       	call   801047f0 <pushcli>
  c = mycpu();
80103cf0:	e8 5b ff ff ff       	call   80103c50 <mycpu>
  p = c->proc;
80103cf5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cfb:	e8 40 0b 00 00       	call   80104840 <popcli>
}
80103d00:	83 c4 04             	add    $0x4,%esp
80103d03:	89 d8                	mov    %ebx,%eax
80103d05:	5b                   	pop    %ebx
80103d06:	5d                   	pop    %ebp
80103d07:	c3                   	ret    
80103d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0f:	90                   	nop

80103d10 <userinit>:
{
80103d10:	f3 0f 1e fb          	endbr32 
80103d14:	55                   	push   %ebp
80103d15:	89 e5                	mov    %esp,%ebp
80103d17:	53                   	push   %ebx
80103d18:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d1b:	e8 f0 fd ff ff       	call   80103b10 <allocproc>
80103d20:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d22:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103d27:	e8 d4 35 00 00       	call   80107300 <setupkvm>
80103d2c:	89 43 04             	mov    %eax,0x4(%ebx)
80103d2f:	85 c0                	test   %eax,%eax
80103d31:	0f 84 d6 00 00 00    	je     80103e0d <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80103d37:	83 ec 04             	sub    $0x4,%esp
80103d3a:	68 2c 00 00 00       	push   $0x2c
80103d3f:	68 60 a4 10 80       	push   $0x8010a460
80103d44:	68 70 7b 10 80       	push   $0x80107b70
80103d49:	e8 62 c9 ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d4e:	83 c4 0c             	add    $0xc,%esp
80103d51:	68 2c 00 00 00       	push   $0x2c
80103d56:	68 60 a4 10 80       	push   $0x8010a460
80103d5b:	ff 73 04             	pushl  0x4(%ebx)
80103d5e:	e8 6d 32 00 00       	call   80106fd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d63:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d66:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d6c:	6a 4c                	push   $0x4c
80103d6e:	6a 00                	push   $0x0
80103d70:	ff 73 18             	pushl  0x18(%ebx)
80103d73:	e8 88 0c 00 00       	call   80104a00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d78:	8b 43 18             	mov    0x18(%ebx),%eax
80103d7b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d80:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d83:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d88:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d8f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d93:	8b 43 18             	mov    0x18(%ebx),%eax
80103d96:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d9a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d9e:	8b 43 18             	mov    0x18(%ebx),%eax
80103da1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103da5:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103da9:	8b 43 18             	mov    0x18(%ebx),%eax
80103dac:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103db3:	8b 43 18             	mov    0x18(%ebx),%eax
80103db6:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103dbd:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dc7:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103dca:	6a 10                	push   $0x10
80103dcc:	68 77 7b 10 80       	push   $0x80107b77
80103dd1:	50                   	push   %eax
80103dd2:	e8 e9 0d 00 00       	call   80104bc0 <safestrcpy>
  p->cwd = namei("/");
80103dd7:	c7 04 24 80 7b 10 80 	movl   $0x80107b80,(%esp)
80103dde:	e8 4d e2 ff ff       	call   80102030 <namei>
80103de3:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103de6:	c7 04 24 60 8d 20 80 	movl   $0x80208d60,(%esp)
80103ded:	e8 fe 0a 00 00       	call   801048f0 <acquire>
  p->state = RUNNABLE;
80103df2:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103df9:	c7 04 24 60 8d 20 80 	movl   $0x80208d60,(%esp)
80103e00:	e8 ab 0b 00 00       	call   801049b0 <release>
}
80103e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e08:	83 c4 10             	add    $0x10,%esp
80103e0b:	c9                   	leave  
80103e0c:	c3                   	ret    
    panic("userinit: out of memory?");
80103e0d:	83 ec 0c             	sub    $0xc,%esp
80103e10:	68 57 7b 10 80       	push   $0x80107b57
80103e15:	e8 76 c5 ff ff       	call   80100390 <panic>
80103e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e20 <growproc>:
{
80103e20:	f3 0f 1e fb          	endbr32 
80103e24:	55                   	push   %ebp
80103e25:	89 e5                	mov    %esp,%ebp
80103e27:	56                   	push   %esi
80103e28:	53                   	push   %ebx
80103e29:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e2c:	e8 bf 09 00 00       	call   801047f0 <pushcli>
  c = mycpu();
80103e31:	e8 1a fe ff ff       	call   80103c50 <mycpu>
  p = c->proc;
80103e36:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e3c:	e8 ff 09 00 00       	call   80104840 <popcli>
  sz = curproc->sz;
80103e41:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e43:	85 f6                	test   %esi,%esi
80103e45:	7f 19                	jg     80103e60 <growproc+0x40>
  } else if(n < 0){
80103e47:	75 37                	jne    80103e80 <growproc+0x60>
  switchuvm(curproc);
80103e49:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e4c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e4e:	53                   	push   %ebx
80103e4f:	e8 6c 30 00 00       	call   80106ec0 <switchuvm>
  return 0;
80103e54:	83 c4 10             	add    $0x10,%esp
80103e57:	31 c0                	xor    %eax,%eax
}
80103e59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e5c:	5b                   	pop    %ebx
80103e5d:	5e                   	pop    %esi
80103e5e:	5d                   	pop    %ebp
80103e5f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e60:	83 ec 04             	sub    $0x4,%esp
80103e63:	01 c6                	add    %eax,%esi
80103e65:	56                   	push   %esi
80103e66:	50                   	push   %eax
80103e67:	ff 73 04             	pushl  0x4(%ebx)
80103e6a:	e8 b1 32 00 00       	call   80107120 <allocuvm>
80103e6f:	83 c4 10             	add    $0x10,%esp
80103e72:	85 c0                	test   %eax,%eax
80103e74:	75 d3                	jne    80103e49 <growproc+0x29>
      return -1;
80103e76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e7b:	eb dc                	jmp    80103e59 <growproc+0x39>
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e80:	83 ec 04             	sub    $0x4,%esp
80103e83:	01 c6                	add    %eax,%esi
80103e85:	56                   	push   %esi
80103e86:	50                   	push   %eax
80103e87:	ff 73 04             	pushl  0x4(%ebx)
80103e8a:	e8 c1 33 00 00       	call   80107250 <deallocuvm>
80103e8f:	83 c4 10             	add    $0x10,%esp
80103e92:	85 c0                	test   %eax,%eax
80103e94:	75 b3                	jne    80103e49 <growproc+0x29>
80103e96:	eb de                	jmp    80103e76 <growproc+0x56>
80103e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9f:	90                   	nop

80103ea0 <fork>:
{
80103ea0:	f3 0f 1e fb          	endbr32 
80103ea4:	55                   	push   %ebp
80103ea5:	89 e5                	mov    %esp,%ebp
80103ea7:	57                   	push   %edi
80103ea8:	56                   	push   %esi
80103ea9:	53                   	push   %ebx
80103eaa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ead:	e8 3e 09 00 00       	call   801047f0 <pushcli>
  c = mycpu();
80103eb2:	e8 99 fd ff ff       	call   80103c50 <mycpu>
  p = c->proc;
80103eb7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ebd:	e8 7e 09 00 00       	call   80104840 <popcli>
  if((np = allocproc()) == 0){
80103ec2:	e8 49 fc ff ff       	call   80103b10 <allocproc>
80103ec7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103eca:	85 c0                	test   %eax,%eax
80103ecc:	0f 84 bb 00 00 00    	je     80103f8d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ed2:	83 ec 08             	sub    $0x8,%esp
80103ed5:	ff 33                	pushl  (%ebx)
80103ed7:	89 c7                	mov    %eax,%edi
80103ed9:	ff 73 04             	pushl  0x4(%ebx)
80103edc:	e8 ef 34 00 00       	call   801073d0 <copyuvm>
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	89 47 04             	mov    %eax,0x4(%edi)
80103ee7:	85 c0                	test   %eax,%eax
80103ee9:	0f 84 a5 00 00 00    	je     80103f94 <fork+0xf4>
  np->sz = curproc->sz;
80103eef:	8b 03                	mov    (%ebx),%eax
80103ef1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ef4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ef6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ef9:	89 c8                	mov    %ecx,%eax
80103efb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103efe:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f03:	8b 73 18             	mov    0x18(%ebx),%esi
80103f06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f08:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f0a:	8b 40 18             	mov    0x18(%eax),%eax
80103f0d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103f18:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f1c:	85 c0                	test   %eax,%eax
80103f1e:	74 13                	je     80103f33 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	50                   	push   %eax
80103f24:	e8 47 cf ff ff       	call   80100e70 <filedup>
80103f29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f2c:	83 c4 10             	add    $0x10,%esp
80103f2f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f33:	83 c6 01             	add    $0x1,%esi
80103f36:	83 fe 10             	cmp    $0x10,%esi
80103f39:	75 dd                	jne    80103f18 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103f3b:	83 ec 0c             	sub    $0xc,%esp
80103f3e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f41:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f44:	e8 e7 d7 ff ff       	call   80101730 <idup>
80103f49:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f4c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f4f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f52:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f55:	6a 10                	push   $0x10
80103f57:	53                   	push   %ebx
80103f58:	50                   	push   %eax
80103f59:	e8 62 0c 00 00       	call   80104bc0 <safestrcpy>
  pid = np->pid;
80103f5e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f61:	c7 04 24 60 8d 20 80 	movl   $0x80208d60,(%esp)
80103f68:	e8 83 09 00 00       	call   801048f0 <acquire>
  np->state = RUNNABLE;
80103f6d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f74:	c7 04 24 60 8d 20 80 	movl   $0x80208d60,(%esp)
80103f7b:	e8 30 0a 00 00       	call   801049b0 <release>
  return pid;
80103f80:	83 c4 10             	add    $0x10,%esp
}
80103f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f86:	89 d8                	mov    %ebx,%eax
80103f88:	5b                   	pop    %ebx
80103f89:	5e                   	pop    %esi
80103f8a:	5f                   	pop    %edi
80103f8b:	5d                   	pop    %ebp
80103f8c:	c3                   	ret    
    return -1;
80103f8d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f92:	eb ef                	jmp    80103f83 <fork+0xe3>
    kfree(np->kstack);
80103f94:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f97:	83 ec 0c             	sub    $0xc,%esp
80103f9a:	ff 73 08             	pushl  0x8(%ebx)
80103f9d:	e8 9e e7 ff ff       	call   80102740 <kfree>
    np->kstack = 0;
80103fa2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103fa9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103fac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103fb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fb8:	eb c9                	jmp    80103f83 <fork+0xe3>
80103fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fc0 <scheduler>:
{
80103fc0:	f3 0f 1e fb          	endbr32 
80103fc4:	55                   	push   %ebp
80103fc5:	89 e5                	mov    %esp,%ebp
80103fc7:	57                   	push   %edi
80103fc8:	56                   	push   %esi
80103fc9:	53                   	push   %ebx
80103fca:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103fcd:	e8 7e fc ff ff       	call   80103c50 <mycpu>
  c->proc = 0;
80103fd2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103fd9:	00 00 00 
  struct cpu *c = mycpu();
80103fdc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103fde:	8d 78 04             	lea    0x4(%eax),%edi
80103fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103fe8:	fb                   	sti    
    acquire(&ptable.lock);
80103fe9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fec:	bb 94 8d 20 80       	mov    $0x80208d94,%ebx
    acquire(&ptable.lock);
80103ff1:	68 60 8d 20 80       	push   $0x80208d60
80103ff6:	e8 f5 08 00 00       	call   801048f0 <acquire>
80103ffb:	83 c4 10             	add    $0x10,%esp
80103ffe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104000:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104004:	75 33                	jne    80104039 <scheduler+0x79>
      switchuvm(p);
80104006:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104009:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010400f:	53                   	push   %ebx
80104010:	e8 ab 2e 00 00       	call   80106ec0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104015:	58                   	pop    %eax
80104016:	5a                   	pop    %edx
80104017:	ff 73 1c             	pushl  0x1c(%ebx)
8010401a:	57                   	push   %edi
      p->state = RUNNING;
8010401b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104022:	e8 fc 0b 00 00       	call   80104c23 <swtch>
      switchkvm();
80104027:	e8 74 2e 00 00       	call   80106ea0 <switchkvm>
      c->proc = 0;
8010402c:	83 c4 10             	add    $0x10,%esp
8010402f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104036:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104039:	83 c3 7c             	add    $0x7c,%ebx
8010403c:	81 fb 94 ac 20 80    	cmp    $0x8020ac94,%ebx
80104042:	75 bc                	jne    80104000 <scheduler+0x40>
    release(&ptable.lock);
80104044:	83 ec 0c             	sub    $0xc,%esp
80104047:	68 60 8d 20 80       	push   $0x80208d60
8010404c:	e8 5f 09 00 00       	call   801049b0 <release>
    sti();
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	eb 92                	jmp    80103fe8 <scheduler+0x28>
80104056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405d:	8d 76 00             	lea    0x0(%esi),%esi

80104060 <sched>:
{
80104060:	f3 0f 1e fb          	endbr32 
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	56                   	push   %esi
80104068:	53                   	push   %ebx
  pushcli();
80104069:	e8 82 07 00 00       	call   801047f0 <pushcli>
  c = mycpu();
8010406e:	e8 dd fb ff ff       	call   80103c50 <mycpu>
  p = c->proc;
80104073:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104079:	e8 c2 07 00 00       	call   80104840 <popcli>
  if(!holding(&ptable.lock))
8010407e:	83 ec 0c             	sub    $0xc,%esp
80104081:	68 60 8d 20 80       	push   $0x80208d60
80104086:	e8 15 08 00 00       	call   801048a0 <holding>
8010408b:	83 c4 10             	add    $0x10,%esp
8010408e:	85 c0                	test   %eax,%eax
80104090:	74 4f                	je     801040e1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104092:	e8 b9 fb ff ff       	call   80103c50 <mycpu>
80104097:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010409e:	75 68                	jne    80104108 <sched+0xa8>
  if(p->state == RUNNING)
801040a0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801040a4:	74 55                	je     801040fb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040a6:	9c                   	pushf  
801040a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040a8:	f6 c4 02             	test   $0x2,%ah
801040ab:	75 41                	jne    801040ee <sched+0x8e>
  intena = mycpu()->intena;
801040ad:	e8 9e fb ff ff       	call   80103c50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801040b2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801040b5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801040bb:	e8 90 fb ff ff       	call   80103c50 <mycpu>
801040c0:	83 ec 08             	sub    $0x8,%esp
801040c3:	ff 70 04             	pushl  0x4(%eax)
801040c6:	53                   	push   %ebx
801040c7:	e8 57 0b 00 00       	call   80104c23 <swtch>
  mycpu()->intena = intena;
801040cc:	e8 7f fb ff ff       	call   80103c50 <mycpu>
}
801040d1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801040d4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801040da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040dd:	5b                   	pop    %ebx
801040de:	5e                   	pop    %esi
801040df:	5d                   	pop    %ebp
801040e0:	c3                   	ret    
    panic("sched ptable.lock");
801040e1:	83 ec 0c             	sub    $0xc,%esp
801040e4:	68 82 7b 10 80       	push   $0x80107b82
801040e9:	e8 a2 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801040ee:	83 ec 0c             	sub    $0xc,%esp
801040f1:	68 ae 7b 10 80       	push   $0x80107bae
801040f6:	e8 95 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
801040fb:	83 ec 0c             	sub    $0xc,%esp
801040fe:	68 a0 7b 10 80       	push   $0x80107ba0
80104103:	e8 88 c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	68 94 7b 10 80       	push   $0x80107b94
80104110:	e8 7b c2 ff ff       	call   80100390 <panic>
80104115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104120 <exit>:
{
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	57                   	push   %edi
80104128:	56                   	push   %esi
80104129:	53                   	push   %ebx
8010412a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010412d:	e8 be 06 00 00       	call   801047f0 <pushcli>
  c = mycpu();
80104132:	e8 19 fb ff ff       	call   80103c50 <mycpu>
  p = c->proc;
80104137:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010413d:	e8 fe 06 00 00       	call   80104840 <popcli>
  if(curproc == initproc)
80104142:	8d 5e 28             	lea    0x28(%esi),%ebx
80104145:	8d 7e 68             	lea    0x68(%esi),%edi
80104148:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
8010414e:	0f 84 f3 00 00 00    	je     80104247 <exit+0x127>
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104158:	8b 03                	mov    (%ebx),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	74 12                	je     80104170 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	50                   	push   %eax
80104162:	e8 59 cd ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104167:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010416d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104170:	83 c3 04             	add    $0x4,%ebx
80104173:	39 df                	cmp    %ebx,%edi
80104175:	75 e1                	jne    80104158 <exit+0x38>
  begin_op();
80104177:	e8 34 ef ff ff       	call   801030b0 <begin_op>
  iput(curproc->cwd);
8010417c:	83 ec 0c             	sub    $0xc,%esp
8010417f:	ff 76 68             	pushl  0x68(%esi)
80104182:	e8 09 d7 ff ff       	call   80101890 <iput>
  end_op();
80104187:	e8 94 ef ff ff       	call   80103120 <end_op>
  curproc->cwd = 0;
8010418c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104193:	c7 04 24 60 8d 20 80 	movl   $0x80208d60,(%esp)
8010419a:	e8 51 07 00 00       	call   801048f0 <acquire>
  wakeup1(curproc->parent);
8010419f:	8b 56 14             	mov    0x14(%esi),%edx
801041a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041a5:	b8 94 8d 20 80       	mov    $0x80208d94,%eax
801041aa:	eb 0e                	jmp    801041ba <exit+0x9a>
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b0:	83 c0 7c             	add    $0x7c,%eax
801041b3:	3d 94 ac 20 80       	cmp    $0x8020ac94,%eax
801041b8:	74 1c                	je     801041d6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801041ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041be:	75 f0                	jne    801041b0 <exit+0x90>
801041c0:	3b 50 20             	cmp    0x20(%eax),%edx
801041c3:	75 eb                	jne    801041b0 <exit+0x90>
      p->state = RUNNABLE;
801041c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041cc:	83 c0 7c             	add    $0x7c,%eax
801041cf:	3d 94 ac 20 80       	cmp    $0x8020ac94,%eax
801041d4:	75 e4                	jne    801041ba <exit+0x9a>
      p->parent = initproc;
801041d6:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041dc:	ba 94 8d 20 80       	mov    $0x80208d94,%edx
801041e1:	eb 10                	jmp    801041f3 <exit+0xd3>
801041e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e7:	90                   	nop
801041e8:	83 c2 7c             	add    $0x7c,%edx
801041eb:	81 fa 94 ac 20 80    	cmp    $0x8020ac94,%edx
801041f1:	74 3b                	je     8010422e <exit+0x10e>
    if(p->parent == curproc){
801041f3:	39 72 14             	cmp    %esi,0x14(%edx)
801041f6:	75 f0                	jne    801041e8 <exit+0xc8>
      if(p->state == ZOMBIE)
801041f8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041ff:	75 e7                	jne    801041e8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104201:	b8 94 8d 20 80       	mov    $0x80208d94,%eax
80104206:	eb 12                	jmp    8010421a <exit+0xfa>
80104208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420f:	90                   	nop
80104210:	83 c0 7c             	add    $0x7c,%eax
80104213:	3d 94 ac 20 80       	cmp    $0x8020ac94,%eax
80104218:	74 ce                	je     801041e8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010421a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010421e:	75 f0                	jne    80104210 <exit+0xf0>
80104220:	3b 48 20             	cmp    0x20(%eax),%ecx
80104223:	75 eb                	jne    80104210 <exit+0xf0>
      p->state = RUNNABLE;
80104225:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010422c:	eb e2                	jmp    80104210 <exit+0xf0>
  curproc->state = ZOMBIE;
8010422e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104235:	e8 26 fe ff ff       	call   80104060 <sched>
  panic("zombie exit");
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	68 cf 7b 10 80       	push   $0x80107bcf
80104242:	e8 49 c1 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	68 c2 7b 10 80       	push   $0x80107bc2
8010424f:	e8 3c c1 ff ff       	call   80100390 <panic>
80104254:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010425f:	90                   	nop

80104260 <yield>:
{
80104260:	f3 0f 1e fb          	endbr32 
80104264:	55                   	push   %ebp
80104265:	89 e5                	mov    %esp,%ebp
80104267:	53                   	push   %ebx
80104268:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010426b:	68 60 8d 20 80       	push   $0x80208d60
80104270:	e8 7b 06 00 00       	call   801048f0 <acquire>
  pushcli();
80104275:	e8 76 05 00 00       	call   801047f0 <pushcli>
  c = mycpu();
8010427a:	e8 d1 f9 ff ff       	call   80103c50 <mycpu>
  p = c->proc;
8010427f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104285:	e8 b6 05 00 00       	call   80104840 <popcli>
  myproc()->state = RUNNABLE;
8010428a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104291:	e8 ca fd ff ff       	call   80104060 <sched>
  release(&ptable.lock);
80104296:	c7 04 24 60 8d 20 80 	movl   $0x80208d60,(%esp)
8010429d:	e8 0e 07 00 00       	call   801049b0 <release>
}
801042a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042a5:	83 c4 10             	add    $0x10,%esp
801042a8:	c9                   	leave  
801042a9:	c3                   	ret    
801042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042b0 <sleep>:
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	57                   	push   %edi
801042b8:	56                   	push   %esi
801042b9:	53                   	push   %ebx
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	8b 7d 08             	mov    0x8(%ebp),%edi
801042c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042c3:	e8 28 05 00 00       	call   801047f0 <pushcli>
  c = mycpu();
801042c8:	e8 83 f9 ff ff       	call   80103c50 <mycpu>
  p = c->proc;
801042cd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d3:	e8 68 05 00 00       	call   80104840 <popcli>
  if(p == 0)
801042d8:	85 db                	test   %ebx,%ebx
801042da:	0f 84 83 00 00 00    	je     80104363 <sleep+0xb3>
  if(lk == 0)
801042e0:	85 f6                	test   %esi,%esi
801042e2:	74 72                	je     80104356 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042e4:	81 fe 60 8d 20 80    	cmp    $0x80208d60,%esi
801042ea:	74 4c                	je     80104338 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042ec:	83 ec 0c             	sub    $0xc,%esp
801042ef:	68 60 8d 20 80       	push   $0x80208d60
801042f4:	e8 f7 05 00 00       	call   801048f0 <acquire>
    release(lk);
801042f9:	89 34 24             	mov    %esi,(%esp)
801042fc:	e8 af 06 00 00       	call   801049b0 <release>
  p->chan = chan;
80104301:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104304:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010430b:	e8 50 fd ff ff       	call   80104060 <sched>
  p->chan = 0;
80104310:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104317:	c7 04 24 60 8d 20 80 	movl   $0x80208d60,(%esp)
8010431e:	e8 8d 06 00 00       	call   801049b0 <release>
    acquire(lk);
80104323:	89 75 08             	mov    %esi,0x8(%ebp)
80104326:	83 c4 10             	add    $0x10,%esp
}
80104329:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432c:	5b                   	pop    %ebx
8010432d:	5e                   	pop    %esi
8010432e:	5f                   	pop    %edi
8010432f:	5d                   	pop    %ebp
    acquire(lk);
80104330:	e9 bb 05 00 00       	jmp    801048f0 <acquire>
80104335:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104338:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010433b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104342:	e8 19 fd ff ff       	call   80104060 <sched>
  p->chan = 0;
80104347:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010434e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104351:	5b                   	pop    %ebx
80104352:	5e                   	pop    %esi
80104353:	5f                   	pop    %edi
80104354:	5d                   	pop    %ebp
80104355:	c3                   	ret    
    panic("sleep without lk");
80104356:	83 ec 0c             	sub    $0xc,%esp
80104359:	68 e1 7b 10 80       	push   $0x80107be1
8010435e:	e8 2d c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104363:	83 ec 0c             	sub    $0xc,%esp
80104366:	68 db 7b 10 80       	push   $0x80107bdb
8010436b:	e8 20 c0 ff ff       	call   80100390 <panic>

80104370 <wait>:
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	56                   	push   %esi
80104378:	53                   	push   %ebx
  pushcli();
80104379:	e8 72 04 00 00       	call   801047f0 <pushcli>
  c = mycpu();
8010437e:	e8 cd f8 ff ff       	call   80103c50 <mycpu>
  p = c->proc;
80104383:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104389:	e8 b2 04 00 00       	call   80104840 <popcli>
  acquire(&ptable.lock);
8010438e:	83 ec 0c             	sub    $0xc,%esp
80104391:	68 60 8d 20 80       	push   $0x80208d60
80104396:	e8 55 05 00 00       	call   801048f0 <acquire>
8010439b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010439e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a0:	bb 94 8d 20 80       	mov    $0x80208d94,%ebx
801043a5:	eb 14                	jmp    801043bb <wait+0x4b>
801043a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	83 c3 7c             	add    $0x7c,%ebx
801043b3:	81 fb 94 ac 20 80    	cmp    $0x8020ac94,%ebx
801043b9:	74 1b                	je     801043d6 <wait+0x66>
      if(p->parent != curproc)
801043bb:	39 73 14             	cmp    %esi,0x14(%ebx)
801043be:	75 f0                	jne    801043b0 <wait+0x40>
      if(p->state == ZOMBIE){
801043c0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043c4:	74 32                	je     801043f8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801043c9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ce:	81 fb 94 ac 20 80    	cmp    $0x8020ac94,%ebx
801043d4:	75 e5                	jne    801043bb <wait+0x4b>
    if(!havekids || curproc->killed){
801043d6:	85 c0                	test   %eax,%eax
801043d8:	74 74                	je     8010444e <wait+0xde>
801043da:	8b 46 24             	mov    0x24(%esi),%eax
801043dd:	85 c0                	test   %eax,%eax
801043df:	75 6d                	jne    8010444e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801043e1:	83 ec 08             	sub    $0x8,%esp
801043e4:	68 60 8d 20 80       	push   $0x80208d60
801043e9:	56                   	push   %esi
801043ea:	e8 c1 fe ff ff       	call   801042b0 <sleep>
    havekids = 0;
801043ef:	83 c4 10             	add    $0x10,%esp
801043f2:	eb aa                	jmp    8010439e <wait+0x2e>
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801043fe:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104401:	e8 3a e3 ff ff       	call   80102740 <kfree>
        freevm(p->pgdir);
80104406:	5a                   	pop    %edx
80104407:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010440a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104411:	e8 6a 2e 00 00       	call   80107280 <freevm>
        release(&ptable.lock);
80104416:	c7 04 24 60 8d 20 80 	movl   $0x80208d60,(%esp)
        p->pid = 0;
8010441d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104424:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010442b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010442f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104436:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010443d:	e8 6e 05 00 00       	call   801049b0 <release>
        return pid;
80104442:	83 c4 10             	add    $0x10,%esp
}
80104445:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104448:	89 f0                	mov    %esi,%eax
8010444a:	5b                   	pop    %ebx
8010444b:	5e                   	pop    %esi
8010444c:	5d                   	pop    %ebp
8010444d:	c3                   	ret    
      release(&ptable.lock);
8010444e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104451:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104456:	68 60 8d 20 80       	push   $0x80208d60
8010445b:	e8 50 05 00 00       	call   801049b0 <release>
      return -1;
80104460:	83 c4 10             	add    $0x10,%esp
80104463:	eb e0                	jmp    80104445 <wait+0xd5>
80104465:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104470:	f3 0f 1e fb          	endbr32 
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	53                   	push   %ebx
80104478:	83 ec 10             	sub    $0x10,%esp
8010447b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010447e:	68 60 8d 20 80       	push   $0x80208d60
80104483:	e8 68 04 00 00       	call   801048f0 <acquire>
80104488:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010448b:	b8 94 8d 20 80       	mov    $0x80208d94,%eax
80104490:	eb 10                	jmp    801044a2 <wakeup+0x32>
80104492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104498:	83 c0 7c             	add    $0x7c,%eax
8010449b:	3d 94 ac 20 80       	cmp    $0x8020ac94,%eax
801044a0:	74 1c                	je     801044be <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
801044a2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044a6:	75 f0                	jne    80104498 <wakeup+0x28>
801044a8:	3b 58 20             	cmp    0x20(%eax),%ebx
801044ab:	75 eb                	jne    80104498 <wakeup+0x28>
      p->state = RUNNABLE;
801044ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044b4:	83 c0 7c             	add    $0x7c,%eax
801044b7:	3d 94 ac 20 80       	cmp    $0x8020ac94,%eax
801044bc:	75 e4                	jne    801044a2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801044be:	c7 45 08 60 8d 20 80 	movl   $0x80208d60,0x8(%ebp)
}
801044c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c8:	c9                   	leave  
  release(&ptable.lock);
801044c9:	e9 e2 04 00 00       	jmp    801049b0 <release>
801044ce:	66 90                	xchg   %ax,%ax

801044d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	53                   	push   %ebx
801044d8:	83 ec 10             	sub    $0x10,%esp
801044db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044de:	68 60 8d 20 80       	push   $0x80208d60
801044e3:	e8 08 04 00 00       	call   801048f0 <acquire>
801044e8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044eb:	b8 94 8d 20 80       	mov    $0x80208d94,%eax
801044f0:	eb 10                	jmp    80104502 <kill+0x32>
801044f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044f8:	83 c0 7c             	add    $0x7c,%eax
801044fb:	3d 94 ac 20 80       	cmp    $0x8020ac94,%eax
80104500:	74 36                	je     80104538 <kill+0x68>
    if(p->pid == pid){
80104502:	39 58 10             	cmp    %ebx,0x10(%eax)
80104505:	75 f1                	jne    801044f8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104507:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010450b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104512:	75 07                	jne    8010451b <kill+0x4b>
        p->state = RUNNABLE;
80104514:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	68 60 8d 20 80       	push   $0x80208d60
80104523:	e8 88 04 00 00       	call   801049b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104528:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010452b:	83 c4 10             	add    $0x10,%esp
8010452e:	31 c0                	xor    %eax,%eax
}
80104530:	c9                   	leave  
80104531:	c3                   	ret    
80104532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	68 60 8d 20 80       	push   $0x80208d60
80104540:	e8 6b 04 00 00       	call   801049b0 <release>
}
80104545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104548:	83 c4 10             	add    $0x10,%esp
8010454b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104550:	c9                   	leave  
80104551:	c3                   	ret    
80104552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104560 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	57                   	push   %edi
80104568:	56                   	push   %esi
80104569:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010456c:	53                   	push   %ebx
8010456d:	bb 00 8e 20 80       	mov    $0x80208e00,%ebx
80104572:	83 ec 3c             	sub    $0x3c,%esp
80104575:	eb 28                	jmp    8010459f <procdump+0x3f>
80104577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104580:	83 ec 0c             	sub    $0xc,%esp
80104583:	68 83 7f 10 80       	push   $0x80107f83
80104588:	e8 23 c1 ff ff       	call   801006b0 <cprintf>
8010458d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104590:	83 c3 7c             	add    $0x7c,%ebx
80104593:	81 fb 00 ad 20 80    	cmp    $0x8020ad00,%ebx
80104599:	0f 84 81 00 00 00    	je     80104620 <procdump+0xc0>
    if(p->state == UNUSED)
8010459f:	8b 43 a0             	mov    -0x60(%ebx),%eax
801045a2:	85 c0                	test   %eax,%eax
801045a4:	74 ea                	je     80104590 <procdump+0x30>
      state = "???";
801045a6:	ba f2 7b 10 80       	mov    $0x80107bf2,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045ab:	83 f8 05             	cmp    $0x5,%eax
801045ae:	77 11                	ja     801045c1 <procdump+0x61>
801045b0:	8b 14 85 54 7c 10 80 	mov    -0x7fef83ac(,%eax,4),%edx
      state = "???";
801045b7:	b8 f2 7b 10 80       	mov    $0x80107bf2,%eax
801045bc:	85 d2                	test   %edx,%edx
801045be:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801045c1:	53                   	push   %ebx
801045c2:	52                   	push   %edx
801045c3:	ff 73 a4             	pushl  -0x5c(%ebx)
801045c6:	68 f6 7b 10 80       	push   $0x80107bf6
801045cb:	e8 e0 c0 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801045d0:	83 c4 10             	add    $0x10,%esp
801045d3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045d7:	75 a7                	jne    80104580 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045d9:	83 ec 08             	sub    $0x8,%esp
801045dc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045df:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045e2:	50                   	push   %eax
801045e3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045e6:	8b 40 0c             	mov    0xc(%eax),%eax
801045e9:	83 c0 08             	add    $0x8,%eax
801045ec:	50                   	push   %eax
801045ed:	e8 9e 01 00 00       	call   80104790 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801045f2:	83 c4 10             	add    $0x10,%esp
801045f5:	8d 76 00             	lea    0x0(%esi),%esi
801045f8:	8b 17                	mov    (%edi),%edx
801045fa:	85 d2                	test   %edx,%edx
801045fc:	74 82                	je     80104580 <procdump+0x20>
        cprintf(" %p", pc[i]);
801045fe:	83 ec 08             	sub    $0x8,%esp
80104601:	83 c7 04             	add    $0x4,%edi
80104604:	52                   	push   %edx
80104605:	68 e1 75 10 80       	push   $0x801075e1
8010460a:	e8 a1 c0 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010460f:	83 c4 10             	add    $0x10,%esp
80104612:	39 fe                	cmp    %edi,%esi
80104614:	75 e2                	jne    801045f8 <procdump+0x98>
80104616:	e9 65 ff ff ff       	jmp    80104580 <procdump+0x20>
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop
  }
}
80104620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104623:	5b                   	pop    %ebx
80104624:	5e                   	pop    %esi
80104625:	5f                   	pop    %edi
80104626:	5d                   	pop    %ebp
80104627:	c3                   	ret    
80104628:	66 90                	xchg   %ax,%ax
8010462a:	66 90                	xchg   %ax,%ax
8010462c:	66 90                	xchg   %ax,%ax
8010462e:	66 90                	xchg   %ax,%ax

80104630 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	53                   	push   %ebx
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010463e:	68 6c 7c 10 80       	push   $0x80107c6c
80104643:	8d 43 04             	lea    0x4(%ebx),%eax
80104646:	50                   	push   %eax
80104647:	e8 24 01 00 00       	call   80104770 <initlock>
  lk->name = name;
8010464c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010464f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104655:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104658:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010465f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104665:	c9                   	leave  
80104666:	c3                   	ret    
80104667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466e:	66 90                	xchg   %ax,%ax

80104670 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	56                   	push   %esi
80104678:	53                   	push   %ebx
80104679:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010467c:	8d 73 04             	lea    0x4(%ebx),%esi
8010467f:	83 ec 0c             	sub    $0xc,%esp
80104682:	56                   	push   %esi
80104683:	e8 68 02 00 00       	call   801048f0 <acquire>
  while (lk->locked) {
80104688:	8b 13                	mov    (%ebx),%edx
8010468a:	83 c4 10             	add    $0x10,%esp
8010468d:	85 d2                	test   %edx,%edx
8010468f:	74 1a                	je     801046ab <acquiresleep+0x3b>
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104698:	83 ec 08             	sub    $0x8,%esp
8010469b:	56                   	push   %esi
8010469c:	53                   	push   %ebx
8010469d:	e8 0e fc ff ff       	call   801042b0 <sleep>
  while (lk->locked) {
801046a2:	8b 03                	mov    (%ebx),%eax
801046a4:	83 c4 10             	add    $0x10,%esp
801046a7:	85 c0                	test   %eax,%eax
801046a9:	75 ed                	jne    80104698 <acquiresleep+0x28>
  }
  lk->locked = 1;
801046ab:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801046b1:	e8 2a f6 ff ff       	call   80103ce0 <myproc>
801046b6:	8b 40 10             	mov    0x10(%eax),%eax
801046b9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046bc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c2:	5b                   	pop    %ebx
801046c3:	5e                   	pop    %esi
801046c4:	5d                   	pop    %ebp
  release(&lk->lk);
801046c5:	e9 e6 02 00 00       	jmp    801049b0 <release>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801046d0:	f3 0f 1e fb          	endbr32 
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	56                   	push   %esi
801046d8:	53                   	push   %ebx
801046d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046dc:	8d 73 04             	lea    0x4(%ebx),%esi
801046df:	83 ec 0c             	sub    $0xc,%esp
801046e2:	56                   	push   %esi
801046e3:	e8 08 02 00 00       	call   801048f0 <acquire>
  lk->locked = 0;
801046e8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046ee:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046f5:	89 1c 24             	mov    %ebx,(%esp)
801046f8:	e8 73 fd ff ff       	call   80104470 <wakeup>
  release(&lk->lk);
801046fd:	89 75 08             	mov    %esi,0x8(%ebp)
80104700:	83 c4 10             	add    $0x10,%esp
}
80104703:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104706:	5b                   	pop    %ebx
80104707:	5e                   	pop    %esi
80104708:	5d                   	pop    %ebp
  release(&lk->lk);
80104709:	e9 a2 02 00 00       	jmp    801049b0 <release>
8010470e:	66 90                	xchg   %ax,%ax

80104710 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	57                   	push   %edi
80104718:	31 ff                	xor    %edi,%edi
8010471a:	56                   	push   %esi
8010471b:	53                   	push   %ebx
8010471c:	83 ec 18             	sub    $0x18,%esp
8010471f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104722:	8d 73 04             	lea    0x4(%ebx),%esi
80104725:	56                   	push   %esi
80104726:	e8 c5 01 00 00       	call   801048f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010472b:	8b 03                	mov    (%ebx),%eax
8010472d:	83 c4 10             	add    $0x10,%esp
80104730:	85 c0                	test   %eax,%eax
80104732:	75 1c                	jne    80104750 <holdingsleep+0x40>
  release(&lk->lk);
80104734:	83 ec 0c             	sub    $0xc,%esp
80104737:	56                   	push   %esi
80104738:	e8 73 02 00 00       	call   801049b0 <release>
  return r;
}
8010473d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104740:	89 f8                	mov    %edi,%eax
80104742:	5b                   	pop    %ebx
80104743:	5e                   	pop    %esi
80104744:	5f                   	pop    %edi
80104745:	5d                   	pop    %ebp
80104746:	c3                   	ret    
80104747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104750:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104753:	e8 88 f5 ff ff       	call   80103ce0 <myproc>
80104758:	39 58 10             	cmp    %ebx,0x10(%eax)
8010475b:	0f 94 c0             	sete   %al
8010475e:	0f b6 c0             	movzbl %al,%eax
80104761:	89 c7                	mov    %eax,%edi
80104763:	eb cf                	jmp    80104734 <holdingsleep+0x24>
80104765:	66 90                	xchg   %ax,%ax
80104767:	66 90                	xchg   %ax,%ax
80104769:	66 90                	xchg   %ax,%ax
8010476b:	66 90                	xchg   %ax,%ax
8010476d:	66 90                	xchg   %ax,%ax
8010476f:	90                   	nop

80104770 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010477a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010477d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104783:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104786:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010478d:	5d                   	pop    %ebp
8010478e:	c3                   	ret    
8010478f:	90                   	nop

80104790 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104795:	31 d2                	xor    %edx,%edx
{
80104797:	89 e5                	mov    %esp,%ebp
80104799:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010479a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010479d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801047a0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801047a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047a8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047ae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047b4:	77 1a                	ja     801047d0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047b6:	8b 58 04             	mov    0x4(%eax),%ebx
801047b9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047bc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047c1:	83 fa 0a             	cmp    $0xa,%edx
801047c4:	75 e2                	jne    801047a8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047c6:	5b                   	pop    %ebx
801047c7:	5d                   	pop    %ebp
801047c8:	c3                   	ret    
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801047d0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801047d3:	8d 51 28             	lea    0x28(%ecx),%edx
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801047e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047e6:	83 c0 04             	add    $0x4,%eax
801047e9:	39 d0                	cmp    %edx,%eax
801047eb:	75 f3                	jne    801047e0 <getcallerpcs+0x50>
}
801047ed:	5b                   	pop    %ebx
801047ee:	5d                   	pop    %ebp
801047ef:	c3                   	ret    

801047f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047f0:	f3 0f 1e fb          	endbr32 
801047f4:	55                   	push   %ebp
801047f5:	89 e5                	mov    %esp,%ebp
801047f7:	53                   	push   %ebx
801047f8:	83 ec 04             	sub    $0x4,%esp
801047fb:	9c                   	pushf  
801047fc:	5b                   	pop    %ebx
  asm volatile("cli");
801047fd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047fe:	e8 4d f4 ff ff       	call   80103c50 <mycpu>
80104803:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104809:	85 c0                	test   %eax,%eax
8010480b:	74 13                	je     80104820 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010480d:	e8 3e f4 ff ff       	call   80103c50 <mycpu>
80104812:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104819:	83 c4 04             	add    $0x4,%esp
8010481c:	5b                   	pop    %ebx
8010481d:	5d                   	pop    %ebp
8010481e:	c3                   	ret    
8010481f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104820:	e8 2b f4 ff ff       	call   80103c50 <mycpu>
80104825:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010482b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104831:	eb da                	jmp    8010480d <pushcli+0x1d>
80104833:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104840 <popcli>:

void
popcli(void)
{
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010484a:	9c                   	pushf  
8010484b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010484c:	f6 c4 02             	test   $0x2,%ah
8010484f:	75 31                	jne    80104882 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104851:	e8 fa f3 ff ff       	call   80103c50 <mycpu>
80104856:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010485d:	78 30                	js     8010488f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010485f:	e8 ec f3 ff ff       	call   80103c50 <mycpu>
80104864:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010486a:	85 d2                	test   %edx,%edx
8010486c:	74 02                	je     80104870 <popcli+0x30>
    sti();
}
8010486e:	c9                   	leave  
8010486f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104870:	e8 db f3 ff ff       	call   80103c50 <mycpu>
80104875:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010487b:	85 c0                	test   %eax,%eax
8010487d:	74 ef                	je     8010486e <popcli+0x2e>
  asm volatile("sti");
8010487f:	fb                   	sti    
}
80104880:	c9                   	leave  
80104881:	c3                   	ret    
    panic("popcli - interruptible");
80104882:	83 ec 0c             	sub    $0xc,%esp
80104885:	68 77 7c 10 80       	push   $0x80107c77
8010488a:	e8 01 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010488f:	83 ec 0c             	sub    $0xc,%esp
80104892:	68 8e 7c 10 80       	push   $0x80107c8e
80104897:	e8 f4 ba ff ff       	call   80100390 <panic>
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <holding>:
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	53                   	push   %ebx
801048a9:	8b 75 08             	mov    0x8(%ebp),%esi
801048ac:	31 db                	xor    %ebx,%ebx
  pushcli();
801048ae:	e8 3d ff ff ff       	call   801047f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048b3:	8b 06                	mov    (%esi),%eax
801048b5:	85 c0                	test   %eax,%eax
801048b7:	75 0f                	jne    801048c8 <holding+0x28>
  popcli();
801048b9:	e8 82 ff ff ff       	call   80104840 <popcli>
}
801048be:	89 d8                	mov    %ebx,%eax
801048c0:	5b                   	pop    %ebx
801048c1:	5e                   	pop    %esi
801048c2:	5d                   	pop    %ebp
801048c3:	c3                   	ret    
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801048c8:	8b 5e 08             	mov    0x8(%esi),%ebx
801048cb:	e8 80 f3 ff ff       	call   80103c50 <mycpu>
801048d0:	39 c3                	cmp    %eax,%ebx
801048d2:	0f 94 c3             	sete   %bl
  popcli();
801048d5:	e8 66 ff ff ff       	call   80104840 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801048da:	0f b6 db             	movzbl %bl,%ebx
}
801048dd:	89 d8                	mov    %ebx,%eax
801048df:	5b                   	pop    %ebx
801048e0:	5e                   	pop    %esi
801048e1:	5d                   	pop    %ebp
801048e2:	c3                   	ret    
801048e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048f0 <acquire>:
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	56                   	push   %esi
801048f8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801048f9:	e8 f2 fe ff ff       	call   801047f0 <pushcli>
  if(holding(lk))
801048fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104901:	83 ec 0c             	sub    $0xc,%esp
80104904:	53                   	push   %ebx
80104905:	e8 96 ff ff ff       	call   801048a0 <holding>
8010490a:	83 c4 10             	add    $0x10,%esp
8010490d:	85 c0                	test   %eax,%eax
8010490f:	0f 85 7f 00 00 00    	jne    80104994 <acquire+0xa4>
80104915:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104917:	ba 01 00 00 00       	mov    $0x1,%edx
8010491c:	eb 05                	jmp    80104923 <acquire+0x33>
8010491e:	66 90                	xchg   %ax,%ax
80104920:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104923:	89 d0                	mov    %edx,%eax
80104925:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104928:	85 c0                	test   %eax,%eax
8010492a:	75 f4                	jne    80104920 <acquire+0x30>
  __sync_synchronize();
8010492c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104934:	e8 17 f3 ff ff       	call   80103c50 <mycpu>
80104939:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010493c:	89 e8                	mov    %ebp,%eax
8010493e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104940:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104946:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010494c:	77 22                	ja     80104970 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010494e:	8b 50 04             	mov    0x4(%eax),%edx
80104951:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104955:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104958:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010495a:	83 fe 0a             	cmp    $0xa,%esi
8010495d:	75 e1                	jne    80104940 <acquire+0x50>
}
8010495f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104962:	5b                   	pop    %ebx
80104963:	5e                   	pop    %esi
80104964:	5d                   	pop    %ebp
80104965:	c3                   	ret    
80104966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104970:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104974:	83 c3 34             	add    $0x34,%ebx
80104977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104986:	83 c0 04             	add    $0x4,%eax
80104989:	39 d8                	cmp    %ebx,%eax
8010498b:	75 f3                	jne    80104980 <acquire+0x90>
}
8010498d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104990:	5b                   	pop    %ebx
80104991:	5e                   	pop    %esi
80104992:	5d                   	pop    %ebp
80104993:	c3                   	ret    
    panic("acquire");
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	68 95 7c 10 80       	push   $0x80107c95
8010499c:	e8 ef b9 ff ff       	call   80100390 <panic>
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049af:	90                   	nop

801049b0 <release>:
{
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	53                   	push   %ebx
801049b8:	83 ec 10             	sub    $0x10,%esp
801049bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801049be:	53                   	push   %ebx
801049bf:	e8 dc fe ff ff       	call   801048a0 <holding>
801049c4:	83 c4 10             	add    $0x10,%esp
801049c7:	85 c0                	test   %eax,%eax
801049c9:	74 22                	je     801049ed <release+0x3d>
  lk->pcs[0] = 0;
801049cb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801049d9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801049e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e7:	c9                   	leave  
  popcli();
801049e8:	e9 53 fe ff ff       	jmp    80104840 <popcli>
    panic("release");
801049ed:	83 ec 0c             	sub    $0xc,%esp
801049f0:	68 9d 7c 10 80       	push   $0x80107c9d
801049f5:	e8 96 b9 ff ff       	call   80100390 <panic>
801049fa:	66 90                	xchg   %ax,%ax
801049fc:	66 90                	xchg   %ax,%ax
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	57                   	push   %edi
80104a08:	8b 55 08             	mov    0x8(%ebp),%edx
80104a0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a0e:	53                   	push   %ebx
80104a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104a12:	89 d7                	mov    %edx,%edi
80104a14:	09 cf                	or     %ecx,%edi
80104a16:	83 e7 03             	and    $0x3,%edi
80104a19:	75 25                	jne    80104a40 <memset+0x40>
    c &= 0xFF;
80104a1b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a1e:	c1 e0 18             	shl    $0x18,%eax
80104a21:	89 fb                	mov    %edi,%ebx
80104a23:	c1 e9 02             	shr    $0x2,%ecx
80104a26:	c1 e3 10             	shl    $0x10,%ebx
80104a29:	09 d8                	or     %ebx,%eax
80104a2b:	09 f8                	or     %edi,%eax
80104a2d:	c1 e7 08             	shl    $0x8,%edi
80104a30:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a32:	89 d7                	mov    %edx,%edi
80104a34:	fc                   	cld    
80104a35:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104a37:	5b                   	pop    %ebx
80104a38:	89 d0                	mov    %edx,%eax
80104a3a:	5f                   	pop    %edi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104a40:	89 d7                	mov    %edx,%edi
80104a42:	fc                   	cld    
80104a43:	f3 aa                	rep stos %al,%es:(%edi)
80104a45:	5b                   	pop    %ebx
80104a46:	89 d0                	mov    %edx,%eax
80104a48:	5f                   	pop    %edi
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    
80104a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a4f:	90                   	nop

80104a50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	56                   	push   %esi
80104a58:	8b 75 10             	mov    0x10(%ebp),%esi
80104a5b:	8b 55 08             	mov    0x8(%ebp),%edx
80104a5e:	53                   	push   %ebx
80104a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a62:	85 f6                	test   %esi,%esi
80104a64:	74 2a                	je     80104a90 <memcmp+0x40>
80104a66:	01 c6                	add    %eax,%esi
80104a68:	eb 10                	jmp    80104a7a <memcmp+0x2a>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a70:	83 c0 01             	add    $0x1,%eax
80104a73:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a76:	39 f0                	cmp    %esi,%eax
80104a78:	74 16                	je     80104a90 <memcmp+0x40>
    if(*s1 != *s2)
80104a7a:	0f b6 0a             	movzbl (%edx),%ecx
80104a7d:	0f b6 18             	movzbl (%eax),%ebx
80104a80:	38 d9                	cmp    %bl,%cl
80104a82:	74 ec                	je     80104a70 <memcmp+0x20>
      return *s1 - *s2;
80104a84:	0f b6 c1             	movzbl %cl,%eax
80104a87:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret    
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
80104a90:	5b                   	pop    %ebx
  return 0;
80104a91:	31 c0                	xor    %eax,%eax
}
80104a93:	5e                   	pop    %esi
80104a94:	5d                   	pop    %ebp
80104a95:	c3                   	ret    
80104a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	57                   	push   %edi
80104aa8:	8b 55 08             	mov    0x8(%ebp),%edx
80104aab:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104aae:	56                   	push   %esi
80104aaf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ab2:	39 d6                	cmp    %edx,%esi
80104ab4:	73 2a                	jae    80104ae0 <memmove+0x40>
80104ab6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ab9:	39 fa                	cmp    %edi,%edx
80104abb:	73 23                	jae    80104ae0 <memmove+0x40>
80104abd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104ac0:	85 c9                	test   %ecx,%ecx
80104ac2:	74 13                	je     80104ad7 <memmove+0x37>
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104ac8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104acc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104acf:	83 e8 01             	sub    $0x1,%eax
80104ad2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104ad5:	75 f1                	jne    80104ac8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ad7:	5e                   	pop    %esi
80104ad8:	89 d0                	mov    %edx,%eax
80104ada:	5f                   	pop    %edi
80104adb:	5d                   	pop    %ebp
80104adc:	c3                   	ret    
80104add:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104ae0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104ae3:	89 d7                	mov    %edx,%edi
80104ae5:	85 c9                	test   %ecx,%ecx
80104ae7:	74 ee                	je     80104ad7 <memmove+0x37>
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104af0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104af1:	39 f0                	cmp    %esi,%eax
80104af3:	75 fb                	jne    80104af0 <memmove+0x50>
}
80104af5:	5e                   	pop    %esi
80104af6:	89 d0                	mov    %edx,%eax
80104af8:	5f                   	pop    %edi
80104af9:	5d                   	pop    %ebp
80104afa:	c3                   	ret    
80104afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop

80104b00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b00:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104b04:	eb 9a                	jmp    80104aa0 <memmove>
80104b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	56                   	push   %esi
80104b18:	8b 75 10             	mov    0x10(%ebp),%esi
80104b1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b1e:	53                   	push   %ebx
80104b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104b22:	85 f6                	test   %esi,%esi
80104b24:	74 32                	je     80104b58 <strncmp+0x48>
80104b26:	01 c6                	add    %eax,%esi
80104b28:	eb 14                	jmp    80104b3e <strncmp+0x2e>
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b30:	38 da                	cmp    %bl,%dl
80104b32:	75 14                	jne    80104b48 <strncmp+0x38>
    n--, p++, q++;
80104b34:	83 c0 01             	add    $0x1,%eax
80104b37:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b3a:	39 f0                	cmp    %esi,%eax
80104b3c:	74 1a                	je     80104b58 <strncmp+0x48>
80104b3e:	0f b6 11             	movzbl (%ecx),%edx
80104b41:	0f b6 18             	movzbl (%eax),%ebx
80104b44:	84 d2                	test   %dl,%dl
80104b46:	75 e8                	jne    80104b30 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b48:	0f b6 c2             	movzbl %dl,%eax
80104b4b:	29 d8                	sub    %ebx,%eax
}
80104b4d:	5b                   	pop    %ebx
80104b4e:	5e                   	pop    %esi
80104b4f:	5d                   	pop    %ebp
80104b50:	c3                   	ret    
80104b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b58:	5b                   	pop    %ebx
    return 0;
80104b59:	31 c0                	xor    %eax,%eax
}
80104b5b:	5e                   	pop    %esi
80104b5c:	5d                   	pop    %ebp
80104b5d:	c3                   	ret    
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	57                   	push   %edi
80104b68:	56                   	push   %esi
80104b69:	8b 75 08             	mov    0x8(%ebp),%esi
80104b6c:	53                   	push   %ebx
80104b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b70:	89 f2                	mov    %esi,%edx
80104b72:	eb 1b                	jmp    80104b8f <strncpy+0x2f>
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b78:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b7f:	83 c2 01             	add    $0x1,%edx
80104b82:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104b86:	89 f9                	mov    %edi,%ecx
80104b88:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b8b:	84 c9                	test   %cl,%cl
80104b8d:	74 09                	je     80104b98 <strncpy+0x38>
80104b8f:	89 c3                	mov    %eax,%ebx
80104b91:	83 e8 01             	sub    $0x1,%eax
80104b94:	85 db                	test   %ebx,%ebx
80104b96:	7f e0                	jg     80104b78 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b98:	89 d1                	mov    %edx,%ecx
80104b9a:	85 c0                	test   %eax,%eax
80104b9c:	7e 15                	jle    80104bb3 <strncpy+0x53>
80104b9e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104ba0:	83 c1 01             	add    $0x1,%ecx
80104ba3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104ba7:	89 c8                	mov    %ecx,%eax
80104ba9:	f7 d0                	not    %eax
80104bab:	01 d0                	add    %edx,%eax
80104bad:	01 d8                	add    %ebx,%eax
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	7f ed                	jg     80104ba0 <strncpy+0x40>
  return os;
}
80104bb3:	5b                   	pop    %ebx
80104bb4:	89 f0                	mov    %esi,%eax
80104bb6:	5e                   	pop    %esi
80104bb7:	5f                   	pop    %edi
80104bb8:	5d                   	pop    %ebp
80104bb9:	c3                   	ret    
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	56                   	push   %esi
80104bc8:	8b 55 10             	mov    0x10(%ebp),%edx
80104bcb:	8b 75 08             	mov    0x8(%ebp),%esi
80104bce:	53                   	push   %ebx
80104bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104bd2:	85 d2                	test   %edx,%edx
80104bd4:	7e 21                	jle    80104bf7 <safestrcpy+0x37>
80104bd6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104bda:	89 f2                	mov    %esi,%edx
80104bdc:	eb 12                	jmp    80104bf0 <safestrcpy+0x30>
80104bde:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104be0:	0f b6 08             	movzbl (%eax),%ecx
80104be3:	83 c0 01             	add    $0x1,%eax
80104be6:	83 c2 01             	add    $0x1,%edx
80104be9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bec:	84 c9                	test   %cl,%cl
80104bee:	74 04                	je     80104bf4 <safestrcpy+0x34>
80104bf0:	39 d8                	cmp    %ebx,%eax
80104bf2:	75 ec                	jne    80104be0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bf4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104bf7:	89 f0                	mov    %esi,%eax
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5d                   	pop    %ebp
80104bfc:	c3                   	ret    
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <strlen>:

int
strlen(const char *s)
{
80104c00:	f3 0f 1e fb          	endbr32 
80104c04:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c05:	31 c0                	xor    %eax,%eax
{
80104c07:	89 e5                	mov    %esp,%ebp
80104c09:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c0c:	80 3a 00             	cmpb   $0x0,(%edx)
80104c0f:	74 10                	je     80104c21 <strlen+0x21>
80104c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c18:	83 c0 01             	add    $0x1,%eax
80104c1b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c1f:	75 f7                	jne    80104c18 <strlen+0x18>
    ;
  return n;
}
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret    

80104c23 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c23:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c27:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c2b:	55                   	push   %ebp
  pushl %ebx
80104c2c:	53                   	push   %ebx
  pushl %esi
80104c2d:	56                   	push   %esi
  pushl %edi
80104c2e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c2f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c31:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c33:	5f                   	pop    %edi
  popl %esi
80104c34:	5e                   	pop    %esi
  popl %ebx
80104c35:	5b                   	pop    %ebx
  popl %ebp
80104c36:	5d                   	pop    %ebp
  ret
80104c37:	c3                   	ret    
80104c38:	66 90                	xchg   %ax,%ax
80104c3a:	66 90                	xchg   %ax,%ax
80104c3c:	66 90                	xchg   %ax,%ax
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	53                   	push   %ebx
80104c48:	83 ec 04             	sub    $0x4,%esp
80104c4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c4e:	e8 8d f0 ff ff       	call   80103ce0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c53:	8b 00                	mov    (%eax),%eax
80104c55:	39 d8                	cmp    %ebx,%eax
80104c57:	76 17                	jbe    80104c70 <fetchint+0x30>
80104c59:	8d 53 04             	lea    0x4(%ebx),%edx
80104c5c:	39 d0                	cmp    %edx,%eax
80104c5e:	72 10                	jb     80104c70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c60:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c63:	8b 13                	mov    (%ebx),%edx
80104c65:	89 10                	mov    %edx,(%eax)
  return 0;
80104c67:	31 c0                	xor    %eax,%eax
}
80104c69:	83 c4 04             	add    $0x4,%esp
80104c6c:	5b                   	pop    %ebx
80104c6d:	5d                   	pop    %ebp
80104c6e:	c3                   	ret    
80104c6f:	90                   	nop
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c75:	eb f2                	jmp    80104c69 <fetchint+0x29>
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c80:	f3 0f 1e fb          	endbr32 
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	53                   	push   %ebx
80104c88:	83 ec 04             	sub    $0x4,%esp
80104c8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c8e:	e8 4d f0 ff ff       	call   80103ce0 <myproc>

  if(addr >= curproc->sz)
80104c93:	39 18                	cmp    %ebx,(%eax)
80104c95:	76 31                	jbe    80104cc8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104c97:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c9e:	39 d3                	cmp    %edx,%ebx
80104ca0:	73 26                	jae    80104cc8 <fetchstr+0x48>
80104ca2:	89 d8                	mov    %ebx,%eax
80104ca4:	eb 11                	jmp    80104cb7 <fetchstr+0x37>
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
80104cb0:	83 c0 01             	add    $0x1,%eax
80104cb3:	39 c2                	cmp    %eax,%edx
80104cb5:	76 11                	jbe    80104cc8 <fetchstr+0x48>
    if(*s == 0)
80104cb7:	80 38 00             	cmpb   $0x0,(%eax)
80104cba:	75 f4                	jne    80104cb0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104cbc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104cbf:	29 d8                	sub    %ebx,%eax
}
80104cc1:	5b                   	pop    %ebx
80104cc2:	5d                   	pop    %ebp
80104cc3:	c3                   	ret    
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cc8:	83 c4 04             	add    $0x4,%esp
    return -1;
80104ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cd0:	5b                   	pop    %ebx
80104cd1:	5d                   	pop    %ebp
80104cd2:	c3                   	ret    
80104cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ce0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	56                   	push   %esi
80104ce8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce9:	e8 f2 ef ff ff       	call   80103ce0 <myproc>
80104cee:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf1:	8b 40 18             	mov    0x18(%eax),%eax
80104cf4:	8b 40 44             	mov    0x44(%eax),%eax
80104cf7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cfa:	e8 e1 ef ff ff       	call   80103ce0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d02:	8b 00                	mov    (%eax),%eax
80104d04:	39 c6                	cmp    %eax,%esi
80104d06:	73 18                	jae    80104d20 <argint+0x40>
80104d08:	8d 53 08             	lea    0x8(%ebx),%edx
80104d0b:	39 d0                	cmp    %edx,%eax
80104d0d:	72 11                	jb     80104d20 <argint+0x40>
  *ip = *(int*)(addr);
80104d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d12:	8b 53 04             	mov    0x4(%ebx),%edx
80104d15:	89 10                	mov    %edx,(%eax)
  return 0;
80104d17:	31 c0                	xor    %eax,%eax
}
80104d19:	5b                   	pop    %ebx
80104d1a:	5e                   	pop    %esi
80104d1b:	5d                   	pop    %ebp
80104d1c:	c3                   	ret    
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d25:	eb f2                	jmp    80104d19 <argint+0x39>
80104d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	56                   	push   %esi
80104d38:	53                   	push   %ebx
80104d39:	83 ec 10             	sub    $0x10,%esp
80104d3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d3f:	e8 9c ef ff ff       	call   80103ce0 <myproc>
 
  if(argint(n, &i) < 0)
80104d44:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104d47:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104d49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d4c:	50                   	push   %eax
80104d4d:	ff 75 08             	pushl  0x8(%ebp)
80104d50:	e8 8b ff ff ff       	call   80104ce0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d55:	83 c4 10             	add    $0x10,%esp
80104d58:	85 c0                	test   %eax,%eax
80104d5a:	78 24                	js     80104d80 <argptr+0x50>
80104d5c:	85 db                	test   %ebx,%ebx
80104d5e:	78 20                	js     80104d80 <argptr+0x50>
80104d60:	8b 16                	mov    (%esi),%edx
80104d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d65:	39 c2                	cmp    %eax,%edx
80104d67:	76 17                	jbe    80104d80 <argptr+0x50>
80104d69:	01 c3                	add    %eax,%ebx
80104d6b:	39 da                	cmp    %ebx,%edx
80104d6d:	72 11                	jb     80104d80 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d72:	89 02                	mov    %eax,(%edx)
  return 0;
80104d74:	31 c0                	xor    %eax,%eax
}
80104d76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d79:	5b                   	pop    %ebx
80104d7a:	5e                   	pop    %esi
80104d7b:	5d                   	pop    %ebp
80104d7c:	c3                   	ret    
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d85:	eb ef                	jmp    80104d76 <argptr+0x46>
80104d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d9d:	50                   	push   %eax
80104d9e:	ff 75 08             	pushl  0x8(%ebp)
80104da1:	e8 3a ff ff ff       	call   80104ce0 <argint>
80104da6:	83 c4 10             	add    $0x10,%esp
80104da9:	85 c0                	test   %eax,%eax
80104dab:	78 13                	js     80104dc0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104dad:	83 ec 08             	sub    $0x8,%esp
80104db0:	ff 75 0c             	pushl  0xc(%ebp)
80104db3:	ff 75 f4             	pushl  -0xc(%ebp)
80104db6:	e8 c5 fe ff ff       	call   80104c80 <fetchstr>
80104dbb:	83 c4 10             	add    $0x10,%esp
}
80104dbe:	c9                   	leave  
80104dbf:	c3                   	ret    
80104dc0:	c9                   	leave  
    return -1;
80104dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc6:	c3                   	ret    
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	53                   	push   %ebx
80104dd8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ddb:	e8 00 ef ff ff       	call   80103ce0 <myproc>
80104de0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104de2:	8b 40 18             	mov    0x18(%eax),%eax
80104de5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104de8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104deb:	83 fa 17             	cmp    $0x17,%edx
80104dee:	77 20                	ja     80104e10 <syscall+0x40>
80104df0:	8b 14 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%edx
80104df7:	85 d2                	test   %edx,%edx
80104df9:	74 15                	je     80104e10 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104dfb:	ff d2                	call   *%edx
80104dfd:	89 c2                	mov    %eax,%edx
80104dff:	8b 43 18             	mov    0x18(%ebx),%eax
80104e02:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e08:	c9                   	leave  
80104e09:	c3                   	ret    
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e10:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e11:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e14:	50                   	push   %eax
80104e15:	ff 73 10             	pushl  0x10(%ebx)
80104e18:	68 a5 7c 10 80       	push   $0x80107ca5
80104e1d:	e8 8e b8 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104e22:	8b 43 18             	mov    0x18(%ebx),%eax
80104e25:	83 c4 10             	add    $0x10,%esp
80104e28:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e32:	c9                   	leave  
80104e33:	c3                   	ret    
80104e34:	66 90                	xchg   %ax,%ax
80104e36:	66 90                	xchg   %ax,%ax
80104e38:	66 90                	xchg   %ax,%ax
80104e3a:	66 90                	xchg   %ax,%ax
80104e3c:	66 90                	xchg   %ax,%ax
80104e3e:	66 90                	xchg   %ax,%ax

80104e40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e45:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e48:	53                   	push   %ebx
80104e49:	83 ec 44             	sub    $0x44,%esp
80104e4c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e52:	57                   	push   %edi
80104e53:	50                   	push   %eax
{
80104e54:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104e57:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e5a:	e8 f1 d1 ff ff       	call   80102050 <nameiparent>
80104e5f:	83 c4 10             	add    $0x10,%esp
80104e62:	85 c0                	test   %eax,%eax
80104e64:	0f 84 46 01 00 00    	je     80104fb0 <create+0x170>
    return 0;
  ilock(dp);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	89 c3                	mov    %eax,%ebx
80104e6f:	50                   	push   %eax
80104e70:	e8 eb c8 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104e75:	83 c4 0c             	add    $0xc,%esp
80104e78:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104e7b:	50                   	push   %eax
80104e7c:	57                   	push   %edi
80104e7d:	53                   	push   %ebx
80104e7e:	e8 2d ce ff ff       	call   80101cb0 <dirlookup>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	89 c6                	mov    %eax,%esi
80104e88:	85 c0                	test   %eax,%eax
80104e8a:	74 54                	je     80104ee0 <create+0xa0>
    iunlockput(dp);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	53                   	push   %ebx
80104e90:	e8 6b cb ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104e95:	89 34 24             	mov    %esi,(%esp)
80104e98:	e8 c3 c8 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e9d:	83 c4 10             	add    $0x10,%esp
80104ea0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ea5:	75 19                	jne    80104ec0 <create+0x80>
80104ea7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104eac:	75 12                	jne    80104ec0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb1:	89 f0                	mov    %esi,%eax
80104eb3:	5b                   	pop    %ebx
80104eb4:	5e                   	pop    %esi
80104eb5:	5f                   	pop    %edi
80104eb6:	5d                   	pop    %ebp
80104eb7:	c3                   	ret    
80104eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebf:	90                   	nop
    iunlockput(ip);
80104ec0:	83 ec 0c             	sub    $0xc,%esp
80104ec3:	56                   	push   %esi
    return 0;
80104ec4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ec6:	e8 35 cb ff ff       	call   80101a00 <iunlockput>
    return 0;
80104ecb:	83 c4 10             	add    $0x10,%esp
}
80104ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed1:	89 f0                	mov    %esi,%eax
80104ed3:	5b                   	pop    %ebx
80104ed4:	5e                   	pop    %esi
80104ed5:	5f                   	pop    %edi
80104ed6:	5d                   	pop    %ebp
80104ed7:	c3                   	ret    
80104ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ee0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ee4:	83 ec 08             	sub    $0x8,%esp
80104ee7:	50                   	push   %eax
80104ee8:	ff 33                	pushl  (%ebx)
80104eea:	e8 f1 c6 ff ff       	call   801015e0 <ialloc>
80104eef:	83 c4 10             	add    $0x10,%esp
80104ef2:	89 c6                	mov    %eax,%esi
80104ef4:	85 c0                	test   %eax,%eax
80104ef6:	0f 84 cd 00 00 00    	je     80104fc9 <create+0x189>
  ilock(ip);
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	50                   	push   %eax
80104f00:	e8 5b c8 ff ff       	call   80101760 <ilock>
  ip->major = major;
80104f05:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104f09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f0d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104f11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f15:	b8 01 00 00 00       	mov    $0x1,%eax
80104f1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f1e:	89 34 24             	mov    %esi,(%esp)
80104f21:	e8 7a c7 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f26:	83 c4 10             	add    $0x10,%esp
80104f29:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f2e:	74 30                	je     80104f60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f30:	83 ec 04             	sub    $0x4,%esp
80104f33:	ff 76 04             	pushl  0x4(%esi)
80104f36:	57                   	push   %edi
80104f37:	53                   	push   %ebx
80104f38:	e8 33 d0 ff ff       	call   80101f70 <dirlink>
80104f3d:	83 c4 10             	add    $0x10,%esp
80104f40:	85 c0                	test   %eax,%eax
80104f42:	78 78                	js     80104fbc <create+0x17c>
  iunlockput(dp);
80104f44:	83 ec 0c             	sub    $0xc,%esp
80104f47:	53                   	push   %ebx
80104f48:	e8 b3 ca ff ff       	call   80101a00 <iunlockput>
  return ip;
80104f4d:	83 c4 10             	add    $0x10,%esp
}
80104f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f53:	89 f0                	mov    %esi,%eax
80104f55:	5b                   	pop    %ebx
80104f56:	5e                   	pop    %esi
80104f57:	5f                   	pop    %edi
80104f58:	5d                   	pop    %ebp
80104f59:	c3                   	ret    
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f68:	53                   	push   %ebx
80104f69:	e8 32 c7 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f6e:	83 c4 0c             	add    $0xc,%esp
80104f71:	ff 76 04             	pushl  0x4(%esi)
80104f74:	68 60 7d 10 80       	push   $0x80107d60
80104f79:	56                   	push   %esi
80104f7a:	e8 f1 cf ff ff       	call   80101f70 <dirlink>
80104f7f:	83 c4 10             	add    $0x10,%esp
80104f82:	85 c0                	test   %eax,%eax
80104f84:	78 18                	js     80104f9e <create+0x15e>
80104f86:	83 ec 04             	sub    $0x4,%esp
80104f89:	ff 73 04             	pushl  0x4(%ebx)
80104f8c:	68 5f 7d 10 80       	push   $0x80107d5f
80104f91:	56                   	push   %esi
80104f92:	e8 d9 cf ff ff       	call   80101f70 <dirlink>
80104f97:	83 c4 10             	add    $0x10,%esp
80104f9a:	85 c0                	test   %eax,%eax
80104f9c:	79 92                	jns    80104f30 <create+0xf0>
      panic("create dots");
80104f9e:	83 ec 0c             	sub    $0xc,%esp
80104fa1:	68 53 7d 10 80       	push   $0x80107d53
80104fa6:	e8 e5 b3 ff ff       	call   80100390 <panic>
80104fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop
}
80104fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104fb3:	31 f6                	xor    %esi,%esi
}
80104fb5:	5b                   	pop    %ebx
80104fb6:	89 f0                	mov    %esi,%eax
80104fb8:	5e                   	pop    %esi
80104fb9:	5f                   	pop    %edi
80104fba:	5d                   	pop    %ebp
80104fbb:	c3                   	ret    
    panic("create: dirlink");
80104fbc:	83 ec 0c             	sub    $0xc,%esp
80104fbf:	68 62 7d 10 80       	push   $0x80107d62
80104fc4:	e8 c7 b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104fc9:	83 ec 0c             	sub    $0xc,%esp
80104fcc:	68 44 7d 10 80       	push   $0x80107d44
80104fd1:	e8 ba b3 ff ff       	call   80100390 <panic>
80104fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi

80104fe0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	89 d6                	mov    %edx,%esi
80104fe6:	53                   	push   %ebx
80104fe7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104fe9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104fec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fef:	50                   	push   %eax
80104ff0:	6a 00                	push   $0x0
80104ff2:	e8 e9 fc ff ff       	call   80104ce0 <argint>
80104ff7:	83 c4 10             	add    $0x10,%esp
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	78 2a                	js     80105028 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105002:	77 24                	ja     80105028 <argfd.constprop.0+0x48>
80105004:	e8 d7 ec ff ff       	call   80103ce0 <myproc>
80105009:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010500c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105010:	85 c0                	test   %eax,%eax
80105012:	74 14                	je     80105028 <argfd.constprop.0+0x48>
  if(pfd)
80105014:	85 db                	test   %ebx,%ebx
80105016:	74 02                	je     8010501a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105018:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010501a:	89 06                	mov    %eax,(%esi)
  return 0;
8010501c:	31 c0                	xor    %eax,%eax
}
8010501e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105021:	5b                   	pop    %ebx
80105022:	5e                   	pop    %esi
80105023:	5d                   	pop    %ebp
80105024:	c3                   	ret    
80105025:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502d:	eb ef                	jmp    8010501e <argfd.constprop.0+0x3e>
8010502f:	90                   	nop

80105030 <sys_dup>:
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105035:	31 c0                	xor    %eax,%eax
{
80105037:	89 e5                	mov    %esp,%ebp
80105039:	56                   	push   %esi
8010503a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010503b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010503e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105041:	e8 9a ff ff ff       	call   80104fe0 <argfd.constprop.0>
80105046:	85 c0                	test   %eax,%eax
80105048:	78 1e                	js     80105068 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010504a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010504d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010504f:	e8 8c ec ff ff       	call   80103ce0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105058:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010505c:	85 d2                	test   %edx,%edx
8010505e:	74 20                	je     80105080 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105060:	83 c3 01             	add    $0x1,%ebx
80105063:	83 fb 10             	cmp    $0x10,%ebx
80105066:	75 f0                	jne    80105058 <sys_dup+0x28>
}
80105068:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010506b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105070:	89 d8                	mov    %ebx,%eax
80105072:	5b                   	pop    %ebx
80105073:	5e                   	pop    %esi
80105074:	5d                   	pop    %ebp
80105075:	c3                   	ret    
80105076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105080:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	ff 75 f4             	pushl  -0xc(%ebp)
8010508a:	e8 e1 bd ff ff       	call   80100e70 <filedup>
  return fd;
8010508f:	83 c4 10             	add    $0x10,%esp
}
80105092:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105095:	89 d8                	mov    %ebx,%eax
80105097:	5b                   	pop    %ebx
80105098:	5e                   	pop    %esi
80105099:	5d                   	pop    %ebp
8010509a:	c3                   	ret    
8010509b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010509f:	90                   	nop

801050a0 <sys_read>:
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a5:	31 c0                	xor    %eax,%eax
{
801050a7:	89 e5                	mov    %esp,%ebp
801050a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050ac:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050af:	e8 2c ff ff ff       	call   80104fe0 <argfd.constprop.0>
801050b4:	85 c0                	test   %eax,%eax
801050b6:	78 48                	js     80105100 <sys_read+0x60>
801050b8:	83 ec 08             	sub    $0x8,%esp
801050bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050be:	50                   	push   %eax
801050bf:	6a 02                	push   $0x2
801050c1:	e8 1a fc ff ff       	call   80104ce0 <argint>
801050c6:	83 c4 10             	add    $0x10,%esp
801050c9:	85 c0                	test   %eax,%eax
801050cb:	78 33                	js     80105100 <sys_read+0x60>
801050cd:	83 ec 04             	sub    $0x4,%esp
801050d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050d3:	ff 75 f0             	pushl  -0x10(%ebp)
801050d6:	50                   	push   %eax
801050d7:	6a 01                	push   $0x1
801050d9:	e8 52 fc ff ff       	call   80104d30 <argptr>
801050de:	83 c4 10             	add    $0x10,%esp
801050e1:	85 c0                	test   %eax,%eax
801050e3:	78 1b                	js     80105100 <sys_read+0x60>
  return fileread(f, p, n);
801050e5:	83 ec 04             	sub    $0x4,%esp
801050e8:	ff 75 f0             	pushl  -0x10(%ebp)
801050eb:	ff 75 f4             	pushl  -0xc(%ebp)
801050ee:	ff 75 ec             	pushl  -0x14(%ebp)
801050f1:	e8 fa be ff ff       	call   80100ff0 <fileread>
801050f6:	83 c4 10             	add    $0x10,%esp
}
801050f9:	c9                   	leave  
801050fa:	c3                   	ret    
801050fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop
80105100:	c9                   	leave  
    return -1;
80105101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105106:	c3                   	ret    
80105107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510e:	66 90                	xchg   %ax,%ax

80105110 <sys_write>:
{
80105110:	f3 0f 1e fb          	endbr32 
80105114:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105115:	31 c0                	xor    %eax,%eax
{
80105117:	89 e5                	mov    %esp,%ebp
80105119:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010511c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010511f:	e8 bc fe ff ff       	call   80104fe0 <argfd.constprop.0>
80105124:	85 c0                	test   %eax,%eax
80105126:	78 48                	js     80105170 <sys_write+0x60>
80105128:	83 ec 08             	sub    $0x8,%esp
8010512b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010512e:	50                   	push   %eax
8010512f:	6a 02                	push   $0x2
80105131:	e8 aa fb ff ff       	call   80104ce0 <argint>
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	85 c0                	test   %eax,%eax
8010513b:	78 33                	js     80105170 <sys_write+0x60>
8010513d:	83 ec 04             	sub    $0x4,%esp
80105140:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105143:	ff 75 f0             	pushl  -0x10(%ebp)
80105146:	50                   	push   %eax
80105147:	6a 01                	push   $0x1
80105149:	e8 e2 fb ff ff       	call   80104d30 <argptr>
8010514e:	83 c4 10             	add    $0x10,%esp
80105151:	85 c0                	test   %eax,%eax
80105153:	78 1b                	js     80105170 <sys_write+0x60>
  return filewrite(f, p, n);
80105155:	83 ec 04             	sub    $0x4,%esp
80105158:	ff 75 f0             	pushl  -0x10(%ebp)
8010515b:	ff 75 f4             	pushl  -0xc(%ebp)
8010515e:	ff 75 ec             	pushl  -0x14(%ebp)
80105161:	e8 2a bf ff ff       	call   80101090 <filewrite>
80105166:	83 c4 10             	add    $0x10,%esp
}
80105169:	c9                   	leave  
8010516a:	c3                   	ret    
8010516b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010516f:	90                   	nop
80105170:	c9                   	leave  
    return -1;
80105171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105176:	c3                   	ret    
80105177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517e:	66 90                	xchg   %ax,%ax

80105180 <sys_close>:
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010518a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010518d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105190:	e8 4b fe ff ff       	call   80104fe0 <argfd.constprop.0>
80105195:	85 c0                	test   %eax,%eax
80105197:	78 27                	js     801051c0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105199:	e8 42 eb ff ff       	call   80103ce0 <myproc>
8010519e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801051a1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051a4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051ab:	00 
  fileclose(f);
801051ac:	ff 75 f4             	pushl  -0xc(%ebp)
801051af:	e8 0c bd ff ff       	call   80100ec0 <fileclose>
  return 0;
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	31 c0                	xor    %eax,%eax
}
801051b9:	c9                   	leave  
801051ba:	c3                   	ret    
801051bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051bf:	90                   	nop
801051c0:	c9                   	leave  
    return -1;
801051c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c6:	c3                   	ret    
801051c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <sys_fstat>:
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051d5:	31 c0                	xor    %eax,%eax
{
801051d7:	89 e5                	mov    %esp,%ebp
801051d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051dc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051df:	e8 fc fd ff ff       	call   80104fe0 <argfd.constprop.0>
801051e4:	85 c0                	test   %eax,%eax
801051e6:	78 30                	js     80105218 <sys_fstat+0x48>
801051e8:	83 ec 04             	sub    $0x4,%esp
801051eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ee:	6a 14                	push   $0x14
801051f0:	50                   	push   %eax
801051f1:	6a 01                	push   $0x1
801051f3:	e8 38 fb ff ff       	call   80104d30 <argptr>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	78 19                	js     80105218 <sys_fstat+0x48>
  return filestat(f, st);
801051ff:	83 ec 08             	sub    $0x8,%esp
80105202:	ff 75 f4             	pushl  -0xc(%ebp)
80105205:	ff 75 f0             	pushl  -0x10(%ebp)
80105208:	e8 93 bd ff ff       	call   80100fa0 <filestat>
8010520d:	83 c4 10             	add    $0x10,%esp
}
80105210:	c9                   	leave  
80105211:	c3                   	ret    
80105212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105218:	c9                   	leave  
    return -1;
80105219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010521e:	c3                   	ret    
8010521f:	90                   	nop

80105220 <sys_link>:
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
80105225:	89 e5                	mov    %esp,%ebp
80105227:	57                   	push   %edi
80105228:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105229:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010522c:	53                   	push   %ebx
8010522d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105230:	50                   	push   %eax
80105231:	6a 00                	push   $0x0
80105233:	e8 58 fb ff ff       	call   80104d90 <argstr>
80105238:	83 c4 10             	add    $0x10,%esp
8010523b:	85 c0                	test   %eax,%eax
8010523d:	0f 88 ff 00 00 00    	js     80105342 <sys_link+0x122>
80105243:	83 ec 08             	sub    $0x8,%esp
80105246:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105249:	50                   	push   %eax
8010524a:	6a 01                	push   $0x1
8010524c:	e8 3f fb ff ff       	call   80104d90 <argstr>
80105251:	83 c4 10             	add    $0x10,%esp
80105254:	85 c0                	test   %eax,%eax
80105256:	0f 88 e6 00 00 00    	js     80105342 <sys_link+0x122>
  begin_op();
8010525c:	e8 4f de ff ff       	call   801030b0 <begin_op>
  if((ip = namei(old)) == 0){
80105261:	83 ec 0c             	sub    $0xc,%esp
80105264:	ff 75 d4             	pushl  -0x2c(%ebp)
80105267:	e8 c4 cd ff ff       	call   80102030 <namei>
8010526c:	83 c4 10             	add    $0x10,%esp
8010526f:	89 c3                	mov    %eax,%ebx
80105271:	85 c0                	test   %eax,%eax
80105273:	0f 84 e8 00 00 00    	je     80105361 <sys_link+0x141>
  ilock(ip);
80105279:	83 ec 0c             	sub    $0xc,%esp
8010527c:	50                   	push   %eax
8010527d:	e8 de c4 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105282:	83 c4 10             	add    $0x10,%esp
80105285:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010528a:	0f 84 b9 00 00 00    	je     80105349 <sys_link+0x129>
  iupdate(ip);
80105290:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105293:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105298:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010529b:	53                   	push   %ebx
8010529c:	e8 ff c3 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801052a1:	89 1c 24             	mov    %ebx,(%esp)
801052a4:	e8 97 c5 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052a9:	58                   	pop    %eax
801052aa:	5a                   	pop    %edx
801052ab:	57                   	push   %edi
801052ac:	ff 75 d0             	pushl  -0x30(%ebp)
801052af:	e8 9c cd ff ff       	call   80102050 <nameiparent>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	89 c6                	mov    %eax,%esi
801052b9:	85 c0                	test   %eax,%eax
801052bb:	74 5f                	je     8010531c <sys_link+0xfc>
  ilock(dp);
801052bd:	83 ec 0c             	sub    $0xc,%esp
801052c0:	50                   	push   %eax
801052c1:	e8 9a c4 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052c6:	8b 03                	mov    (%ebx),%eax
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	39 06                	cmp    %eax,(%esi)
801052cd:	75 41                	jne    80105310 <sys_link+0xf0>
801052cf:	83 ec 04             	sub    $0x4,%esp
801052d2:	ff 73 04             	pushl  0x4(%ebx)
801052d5:	57                   	push   %edi
801052d6:	56                   	push   %esi
801052d7:	e8 94 cc ff ff       	call   80101f70 <dirlink>
801052dc:	83 c4 10             	add    $0x10,%esp
801052df:	85 c0                	test   %eax,%eax
801052e1:	78 2d                	js     80105310 <sys_link+0xf0>
  iunlockput(dp);
801052e3:	83 ec 0c             	sub    $0xc,%esp
801052e6:	56                   	push   %esi
801052e7:	e8 14 c7 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
801052ec:	89 1c 24             	mov    %ebx,(%esp)
801052ef:	e8 9c c5 ff ff       	call   80101890 <iput>
  end_op();
801052f4:	e8 27 de ff ff       	call   80103120 <end_op>
  return 0;
801052f9:	83 c4 10             	add    $0x10,%esp
801052fc:	31 c0                	xor    %eax,%eax
}
801052fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105301:	5b                   	pop    %ebx
80105302:	5e                   	pop    %esi
80105303:	5f                   	pop    %edi
80105304:	5d                   	pop    %ebp
80105305:	c3                   	ret    
80105306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105310:	83 ec 0c             	sub    $0xc,%esp
80105313:	56                   	push   %esi
80105314:	e8 e7 c6 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105319:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010531c:	83 ec 0c             	sub    $0xc,%esp
8010531f:	53                   	push   %ebx
80105320:	e8 3b c4 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105325:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010532a:	89 1c 24             	mov    %ebx,(%esp)
8010532d:	e8 6e c3 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105332:	89 1c 24             	mov    %ebx,(%esp)
80105335:	e8 c6 c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010533a:	e8 e1 dd ff ff       	call   80103120 <end_op>
  return -1;
8010533f:	83 c4 10             	add    $0x10,%esp
80105342:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105347:	eb b5                	jmp    801052fe <sys_link+0xde>
    iunlockput(ip);
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	53                   	push   %ebx
8010534d:	e8 ae c6 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105352:	e8 c9 dd ff ff       	call   80103120 <end_op>
    return -1;
80105357:	83 c4 10             	add    $0x10,%esp
8010535a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535f:	eb 9d                	jmp    801052fe <sys_link+0xde>
    end_op();
80105361:	e8 ba dd ff ff       	call   80103120 <end_op>
    return -1;
80105366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536b:	eb 91                	jmp    801052fe <sys_link+0xde>
8010536d:	8d 76 00             	lea    0x0(%esi),%esi

80105370 <sys_unlink>:
{
80105370:	f3 0f 1e fb          	endbr32 
80105374:	55                   	push   %ebp
80105375:	89 e5                	mov    %esp,%ebp
80105377:	57                   	push   %edi
80105378:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105379:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010537c:	53                   	push   %ebx
8010537d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105380:	50                   	push   %eax
80105381:	6a 00                	push   $0x0
80105383:	e8 08 fa ff ff       	call   80104d90 <argstr>
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	85 c0                	test   %eax,%eax
8010538d:	0f 88 7d 01 00 00    	js     80105510 <sys_unlink+0x1a0>
  begin_op();
80105393:	e8 18 dd ff ff       	call   801030b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105398:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010539b:	83 ec 08             	sub    $0x8,%esp
8010539e:	53                   	push   %ebx
8010539f:	ff 75 c0             	pushl  -0x40(%ebp)
801053a2:	e8 a9 cc ff ff       	call   80102050 <nameiparent>
801053a7:	83 c4 10             	add    $0x10,%esp
801053aa:	89 c6                	mov    %eax,%esi
801053ac:	85 c0                	test   %eax,%eax
801053ae:	0f 84 66 01 00 00    	je     8010551a <sys_unlink+0x1aa>
  ilock(dp);
801053b4:	83 ec 0c             	sub    $0xc,%esp
801053b7:	50                   	push   %eax
801053b8:	e8 a3 c3 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053bd:	58                   	pop    %eax
801053be:	5a                   	pop    %edx
801053bf:	68 60 7d 10 80       	push   $0x80107d60
801053c4:	53                   	push   %ebx
801053c5:	e8 c6 c8 ff ff       	call   80101c90 <namecmp>
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	85 c0                	test   %eax,%eax
801053cf:	0f 84 03 01 00 00    	je     801054d8 <sys_unlink+0x168>
801053d5:	83 ec 08             	sub    $0x8,%esp
801053d8:	68 5f 7d 10 80       	push   $0x80107d5f
801053dd:	53                   	push   %ebx
801053de:	e8 ad c8 ff ff       	call   80101c90 <namecmp>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	0f 84 ea 00 00 00    	je     801054d8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053ee:	83 ec 04             	sub    $0x4,%esp
801053f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053f4:	50                   	push   %eax
801053f5:	53                   	push   %ebx
801053f6:	56                   	push   %esi
801053f7:	e8 b4 c8 ff ff       	call   80101cb0 <dirlookup>
801053fc:	83 c4 10             	add    $0x10,%esp
801053ff:	89 c3                	mov    %eax,%ebx
80105401:	85 c0                	test   %eax,%eax
80105403:	0f 84 cf 00 00 00    	je     801054d8 <sys_unlink+0x168>
  ilock(ip);
80105409:	83 ec 0c             	sub    $0xc,%esp
8010540c:	50                   	push   %eax
8010540d:	e8 4e c3 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105412:	83 c4 10             	add    $0x10,%esp
80105415:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010541a:	0f 8e 23 01 00 00    	jle    80105543 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105420:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105425:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105428:	74 66                	je     80105490 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010542a:	83 ec 04             	sub    $0x4,%esp
8010542d:	6a 10                	push   $0x10
8010542f:	6a 00                	push   $0x0
80105431:	57                   	push   %edi
80105432:	e8 c9 f5 ff ff       	call   80104a00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105437:	6a 10                	push   $0x10
80105439:	ff 75 c4             	pushl  -0x3c(%ebp)
8010543c:	57                   	push   %edi
8010543d:	56                   	push   %esi
8010543e:	e8 1d c7 ff ff       	call   80101b60 <writei>
80105443:	83 c4 20             	add    $0x20,%esp
80105446:	83 f8 10             	cmp    $0x10,%eax
80105449:	0f 85 e7 00 00 00    	jne    80105536 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010544f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105454:	0f 84 96 00 00 00    	je     801054f0 <sys_unlink+0x180>
  iunlockput(dp);
8010545a:	83 ec 0c             	sub    $0xc,%esp
8010545d:	56                   	push   %esi
8010545e:	e8 9d c5 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105463:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105468:	89 1c 24             	mov    %ebx,(%esp)
8010546b:	e8 30 c2 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105470:	89 1c 24             	mov    %ebx,(%esp)
80105473:	e8 88 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105478:	e8 a3 dc ff ff       	call   80103120 <end_op>
  return 0;
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	31 c0                	xor    %eax,%eax
}
80105482:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105485:	5b                   	pop    %ebx
80105486:	5e                   	pop    %esi
80105487:	5f                   	pop    %edi
80105488:	5d                   	pop    %ebp
80105489:	c3                   	ret    
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105490:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105494:	76 94                	jbe    8010542a <sys_unlink+0xba>
80105496:	ba 20 00 00 00       	mov    $0x20,%edx
8010549b:	eb 0b                	jmp    801054a8 <sys_unlink+0x138>
8010549d:	8d 76 00             	lea    0x0(%esi),%esi
801054a0:	83 c2 10             	add    $0x10,%edx
801054a3:	39 53 58             	cmp    %edx,0x58(%ebx)
801054a6:	76 82                	jbe    8010542a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054a8:	6a 10                	push   $0x10
801054aa:	52                   	push   %edx
801054ab:	57                   	push   %edi
801054ac:	53                   	push   %ebx
801054ad:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801054b0:	e8 ab c5 ff ff       	call   80101a60 <readi>
801054b5:	83 c4 10             	add    $0x10,%esp
801054b8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801054bb:	83 f8 10             	cmp    $0x10,%eax
801054be:	75 69                	jne    80105529 <sys_unlink+0x1b9>
    if(de.inum != 0)
801054c0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054c5:	74 d9                	je     801054a0 <sys_unlink+0x130>
    iunlockput(ip);
801054c7:	83 ec 0c             	sub    $0xc,%esp
801054ca:	53                   	push   %ebx
801054cb:	e8 30 c5 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054d7:	90                   	nop
  iunlockput(dp);
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	56                   	push   %esi
801054dc:	e8 1f c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
801054e1:	e8 3a dc ff ff       	call   80103120 <end_op>
  return -1;
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ee:	eb 92                	jmp    80105482 <sys_unlink+0x112>
    iupdate(dp);
801054f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801054f3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801054f8:	56                   	push   %esi
801054f9:	e8 a2 c1 ff ff       	call   801016a0 <iupdate>
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	e9 54 ff ff ff       	jmp    8010545a <sys_unlink+0xea>
80105506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105515:	e9 68 ff ff ff       	jmp    80105482 <sys_unlink+0x112>
    end_op();
8010551a:	e8 01 dc ff ff       	call   80103120 <end_op>
    return -1;
8010551f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105524:	e9 59 ff ff ff       	jmp    80105482 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	68 84 7d 10 80       	push   $0x80107d84
80105531:	e8 5a ae ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105536:	83 ec 0c             	sub    $0xc,%esp
80105539:	68 96 7d 10 80       	push   $0x80107d96
8010553e:	e8 4d ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105543:	83 ec 0c             	sub    $0xc,%esp
80105546:	68 72 7d 10 80       	push   $0x80107d72
8010554b:	e8 40 ae ff ff       	call   80100390 <panic>

80105550 <sys_open>:

int
sys_open(void)
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
80105555:	89 e5                	mov    %esp,%ebp
80105557:	57                   	push   %edi
80105558:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105559:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010555c:	53                   	push   %ebx
8010555d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105560:	50                   	push   %eax
80105561:	6a 00                	push   $0x0
80105563:	e8 28 f8 ff ff       	call   80104d90 <argstr>
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	85 c0                	test   %eax,%eax
8010556d:	0f 88 8a 00 00 00    	js     801055fd <sys_open+0xad>
80105573:	83 ec 08             	sub    $0x8,%esp
80105576:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105579:	50                   	push   %eax
8010557a:	6a 01                	push   $0x1
8010557c:	e8 5f f7 ff ff       	call   80104ce0 <argint>
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	85 c0                	test   %eax,%eax
80105586:	78 75                	js     801055fd <sys_open+0xad>
    return -1;

  begin_op();
80105588:	e8 23 db ff ff       	call   801030b0 <begin_op>

  if(omode & O_CREATE){
8010558d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105591:	75 75                	jne    80105608 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105593:	83 ec 0c             	sub    $0xc,%esp
80105596:	ff 75 e0             	pushl  -0x20(%ebp)
80105599:	e8 92 ca ff ff       	call   80102030 <namei>
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	89 c6                	mov    %eax,%esi
801055a3:	85 c0                	test   %eax,%eax
801055a5:	74 7e                	je     80105625 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801055a7:	83 ec 0c             	sub    $0xc,%esp
801055aa:	50                   	push   %eax
801055ab:	e8 b0 c1 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055b0:	83 c4 10             	add    $0x10,%esp
801055b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055b8:	0f 84 c2 00 00 00    	je     80105680 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055be:	e8 3d b8 ff ff       	call   80100e00 <filealloc>
801055c3:	89 c7                	mov    %eax,%edi
801055c5:	85 c0                	test   %eax,%eax
801055c7:	74 23                	je     801055ec <sys_open+0x9c>
  struct proc *curproc = myproc();
801055c9:	e8 12 e7 ff ff       	call   80103ce0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055ce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801055d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055d4:	85 d2                	test   %edx,%edx
801055d6:	74 60                	je     80105638 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801055d8:	83 c3 01             	add    $0x1,%ebx
801055db:	83 fb 10             	cmp    $0x10,%ebx
801055de:	75 f0                	jne    801055d0 <sys_open+0x80>
    if(f)
      fileclose(f);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	57                   	push   %edi
801055e4:	e8 d7 b8 ff ff       	call   80100ec0 <fileclose>
801055e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	56                   	push   %esi
801055f0:	e8 0b c4 ff ff       	call   80101a00 <iunlockput>
    end_op();
801055f5:	e8 26 db ff ff       	call   80103120 <end_op>
    return -1;
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105602:	eb 6d                	jmp    80105671 <sys_open+0x121>
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105608:	83 ec 0c             	sub    $0xc,%esp
8010560b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010560e:	31 c9                	xor    %ecx,%ecx
80105610:	ba 02 00 00 00       	mov    $0x2,%edx
80105615:	6a 00                	push   $0x0
80105617:	e8 24 f8 ff ff       	call   80104e40 <create>
    if(ip == 0){
8010561c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010561f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105621:	85 c0                	test   %eax,%eax
80105623:	75 99                	jne    801055be <sys_open+0x6e>
      end_op();
80105625:	e8 f6 da ff ff       	call   80103120 <end_op>
      return -1;
8010562a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010562f:	eb 40                	jmp    80105671 <sys_open+0x121>
80105631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105638:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010563b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010563f:	56                   	push   %esi
80105640:	e8 fb c1 ff ff       	call   80101840 <iunlock>
  end_op();
80105645:	e8 d6 da ff ff       	call   80103120 <end_op>

  f->type = FD_INODE;
8010564a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105650:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105653:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105656:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105659:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010565b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105662:	f7 d0                	not    %eax
80105664:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105667:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010566a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010566d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105671:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105674:	89 d8                	mov    %ebx,%eax
80105676:	5b                   	pop    %ebx
80105677:	5e                   	pop    %esi
80105678:	5f                   	pop    %edi
80105679:	5d                   	pop    %ebp
8010567a:	c3                   	ret    
8010567b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010567f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105680:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105683:	85 c9                	test   %ecx,%ecx
80105685:	0f 84 33 ff ff ff    	je     801055be <sys_open+0x6e>
8010568b:	e9 5c ff ff ff       	jmp    801055ec <sys_open+0x9c>

80105690 <sys_mkdir>:

int
sys_mkdir(void)
{
80105690:	f3 0f 1e fb          	endbr32 
80105694:	55                   	push   %ebp
80105695:	89 e5                	mov    %esp,%ebp
80105697:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010569a:	e8 11 da ff ff       	call   801030b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010569f:	83 ec 08             	sub    $0x8,%esp
801056a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056a5:	50                   	push   %eax
801056a6:	6a 00                	push   $0x0
801056a8:	e8 e3 f6 ff ff       	call   80104d90 <argstr>
801056ad:	83 c4 10             	add    $0x10,%esp
801056b0:	85 c0                	test   %eax,%eax
801056b2:	78 34                	js     801056e8 <sys_mkdir+0x58>
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ba:	31 c9                	xor    %ecx,%ecx
801056bc:	ba 01 00 00 00       	mov    $0x1,%edx
801056c1:	6a 00                	push   $0x0
801056c3:	e8 78 f7 ff ff       	call   80104e40 <create>
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	85 c0                	test   %eax,%eax
801056cd:	74 19                	je     801056e8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056cf:	83 ec 0c             	sub    $0xc,%esp
801056d2:	50                   	push   %eax
801056d3:	e8 28 c3 ff ff       	call   80101a00 <iunlockput>
  end_op();
801056d8:	e8 43 da ff ff       	call   80103120 <end_op>
  return 0;
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	31 c0                	xor    %eax,%eax
}
801056e2:	c9                   	leave  
801056e3:	c3                   	ret    
801056e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801056e8:	e8 33 da ff ff       	call   80103120 <end_op>
    return -1;
801056ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f2:	c9                   	leave  
801056f3:	c3                   	ret    
801056f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ff:	90                   	nop

80105700 <sys_mknod>:

int
sys_mknod(void)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010570a:	e8 a1 d9 ff ff       	call   801030b0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010570f:	83 ec 08             	sub    $0x8,%esp
80105712:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105715:	50                   	push   %eax
80105716:	6a 00                	push   $0x0
80105718:	e8 73 f6 ff ff       	call   80104d90 <argstr>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	78 64                	js     80105788 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105724:	83 ec 08             	sub    $0x8,%esp
80105727:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010572a:	50                   	push   %eax
8010572b:	6a 01                	push   $0x1
8010572d:	e8 ae f5 ff ff       	call   80104ce0 <argint>
  if((argstr(0, &path)) < 0 ||
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	78 4f                	js     80105788 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105739:	83 ec 08             	sub    $0x8,%esp
8010573c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573f:	50                   	push   %eax
80105740:	6a 02                	push   $0x2
80105742:	e8 99 f5 ff ff       	call   80104ce0 <argint>
     argint(1, &major) < 0 ||
80105747:	83 c4 10             	add    $0x10,%esp
8010574a:	85 c0                	test   %eax,%eax
8010574c:	78 3a                	js     80105788 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010574e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105752:	83 ec 0c             	sub    $0xc,%esp
80105755:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105759:	ba 03 00 00 00       	mov    $0x3,%edx
8010575e:	50                   	push   %eax
8010575f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105762:	e8 d9 f6 ff ff       	call   80104e40 <create>
     argint(2, &minor) < 0 ||
80105767:	83 c4 10             	add    $0x10,%esp
8010576a:	85 c0                	test   %eax,%eax
8010576c:	74 1a                	je     80105788 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010576e:	83 ec 0c             	sub    $0xc,%esp
80105771:	50                   	push   %eax
80105772:	e8 89 c2 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105777:	e8 a4 d9 ff ff       	call   80103120 <end_op>
  return 0;
8010577c:	83 c4 10             	add    $0x10,%esp
8010577f:	31 c0                	xor    %eax,%eax
}
80105781:	c9                   	leave  
80105782:	c3                   	ret    
80105783:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105787:	90                   	nop
    end_op();
80105788:	e8 93 d9 ff ff       	call   80103120 <end_op>
    return -1;
8010578d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105792:	c9                   	leave  
80105793:	c3                   	ret    
80105794:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010579f:	90                   	nop

801057a0 <sys_chdir>:

int
sys_chdir(void)
{
801057a0:	f3 0f 1e fb          	endbr32 
801057a4:	55                   	push   %ebp
801057a5:	89 e5                	mov    %esp,%ebp
801057a7:	56                   	push   %esi
801057a8:	53                   	push   %ebx
801057a9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057ac:	e8 2f e5 ff ff       	call   80103ce0 <myproc>
801057b1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057b3:	e8 f8 d8 ff ff       	call   801030b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057b8:	83 ec 08             	sub    $0x8,%esp
801057bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057be:	50                   	push   %eax
801057bf:	6a 00                	push   $0x0
801057c1:	e8 ca f5 ff ff       	call   80104d90 <argstr>
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	85 c0                	test   %eax,%eax
801057cb:	78 73                	js     80105840 <sys_chdir+0xa0>
801057cd:	83 ec 0c             	sub    $0xc,%esp
801057d0:	ff 75 f4             	pushl  -0xc(%ebp)
801057d3:	e8 58 c8 ff ff       	call   80102030 <namei>
801057d8:	83 c4 10             	add    $0x10,%esp
801057db:	89 c3                	mov    %eax,%ebx
801057dd:	85 c0                	test   %eax,%eax
801057df:	74 5f                	je     80105840 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057e1:	83 ec 0c             	sub    $0xc,%esp
801057e4:	50                   	push   %eax
801057e5:	e8 76 bf ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057f2:	75 2c                	jne    80105820 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	53                   	push   %ebx
801057f8:	e8 43 c0 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
801057fd:	58                   	pop    %eax
801057fe:	ff 76 68             	pushl  0x68(%esi)
80105801:	e8 8a c0 ff ff       	call   80101890 <iput>
  end_op();
80105806:	e8 15 d9 ff ff       	call   80103120 <end_op>
  curproc->cwd = ip;
8010580b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	31 c0                	xor    %eax,%eax
}
80105813:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105816:	5b                   	pop    %ebx
80105817:	5e                   	pop    %esi
80105818:	5d                   	pop    %ebp
80105819:	c3                   	ret    
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	53                   	push   %ebx
80105824:	e8 d7 c1 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105829:	e8 f2 d8 ff ff       	call   80103120 <end_op>
    return -1;
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105836:	eb db                	jmp    80105813 <sys_chdir+0x73>
80105838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop
    end_op();
80105840:	e8 db d8 ff ff       	call   80103120 <end_op>
    return -1;
80105845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584a:	eb c7                	jmp    80105813 <sys_chdir+0x73>
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_exec>:

int
sys_exec(void)
{
80105850:	f3 0f 1e fb          	endbr32 
80105854:	55                   	push   %ebp
80105855:	89 e5                	mov    %esp,%ebp
80105857:	57                   	push   %edi
80105858:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105859:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010585f:	53                   	push   %ebx
80105860:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105866:	50                   	push   %eax
80105867:	6a 00                	push   $0x0
80105869:	e8 22 f5 ff ff       	call   80104d90 <argstr>
8010586e:	83 c4 10             	add    $0x10,%esp
80105871:	85 c0                	test   %eax,%eax
80105873:	0f 88 8b 00 00 00    	js     80105904 <sys_exec+0xb4>
80105879:	83 ec 08             	sub    $0x8,%esp
8010587c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105882:	50                   	push   %eax
80105883:	6a 01                	push   $0x1
80105885:	e8 56 f4 ff ff       	call   80104ce0 <argint>
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	85 c0                	test   %eax,%eax
8010588f:	78 73                	js     80105904 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105891:	83 ec 04             	sub    $0x4,%esp
80105894:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010589a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010589c:	68 80 00 00 00       	push   $0x80
801058a1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801058a7:	6a 00                	push   $0x0
801058a9:	50                   	push   %eax
801058aa:	e8 51 f1 ff ff       	call   80104a00 <memset>
801058af:	83 c4 10             	add    $0x10,%esp
801058b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058b8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058be:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801058c5:	83 ec 08             	sub    $0x8,%esp
801058c8:	57                   	push   %edi
801058c9:	01 f0                	add    %esi,%eax
801058cb:	50                   	push   %eax
801058cc:	e8 6f f3 ff ff       	call   80104c40 <fetchint>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	85 c0                	test   %eax,%eax
801058d6:	78 2c                	js     80105904 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801058d8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058de:	85 c0                	test   %eax,%eax
801058e0:	74 36                	je     80105918 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058e2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801058e8:	83 ec 08             	sub    $0x8,%esp
801058eb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801058ee:	52                   	push   %edx
801058ef:	50                   	push   %eax
801058f0:	e8 8b f3 ff ff       	call   80104c80 <fetchstr>
801058f5:	83 c4 10             	add    $0x10,%esp
801058f8:	85 c0                	test   %eax,%eax
801058fa:	78 08                	js     80105904 <sys_exec+0xb4>
  for(i=0;; i++){
801058fc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801058ff:	83 fb 20             	cmp    $0x20,%ebx
80105902:	75 b4                	jne    801058b8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105904:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010590c:	5b                   	pop    %ebx
8010590d:	5e                   	pop    %esi
8010590e:	5f                   	pop    %edi
8010590f:	5d                   	pop    %ebp
80105910:	c3                   	ret    
80105911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105918:	83 ec 08             	sub    $0x8,%esp
8010591b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105921:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105928:	00 00 00 00 
  return exec(path, argv);
8010592c:	50                   	push   %eax
8010592d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105933:	e8 48 b1 ff ff       	call   80100a80 <exec>
80105938:	83 c4 10             	add    $0x10,%esp
}
8010593b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010593e:	5b                   	pop    %ebx
8010593f:	5e                   	pop    %esi
80105940:	5f                   	pop    %edi
80105941:	5d                   	pop    %ebp
80105942:	c3                   	ret    
80105943:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105950 <sys_pipe>:

int
sys_pipe(void)
{
80105950:	f3 0f 1e fb          	endbr32 
80105954:	55                   	push   %ebp
80105955:	89 e5                	mov    %esp,%ebp
80105957:	57                   	push   %edi
80105958:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105959:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010595c:	53                   	push   %ebx
8010595d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105960:	6a 08                	push   $0x8
80105962:	50                   	push   %eax
80105963:	6a 00                	push   $0x0
80105965:	e8 c6 f3 ff ff       	call   80104d30 <argptr>
8010596a:	83 c4 10             	add    $0x10,%esp
8010596d:	85 c0                	test   %eax,%eax
8010596f:	78 4e                	js     801059bf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105971:	83 ec 08             	sub    $0x8,%esp
80105974:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105977:	50                   	push   %eax
80105978:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010597b:	50                   	push   %eax
8010597c:	e8 ef dd ff ff       	call   80103770 <pipealloc>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	85 c0                	test   %eax,%eax
80105986:	78 37                	js     801059bf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105988:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010598b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010598d:	e8 4e e3 ff ff       	call   80103ce0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105998:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010599c:	85 f6                	test   %esi,%esi
8010599e:	74 30                	je     801059d0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801059a0:	83 c3 01             	add    $0x1,%ebx
801059a3:	83 fb 10             	cmp    $0x10,%ebx
801059a6:	75 f0                	jne    80105998 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	ff 75 e0             	pushl  -0x20(%ebp)
801059ae:	e8 0d b5 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801059b3:	58                   	pop    %eax
801059b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801059b7:	e8 04 b5 ff ff       	call   80100ec0 <fileclose>
    return -1;
801059bc:	83 c4 10             	add    $0x10,%esp
801059bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c4:	eb 5b                	jmp    80105a21 <sys_pipe+0xd1>
801059c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801059d0:	8d 73 08             	lea    0x8(%ebx),%esi
801059d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801059da:	e8 01 e3 ff ff       	call   80103ce0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059df:	31 d2                	xor    %edx,%edx
801059e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059ec:	85 c9                	test   %ecx,%ecx
801059ee:	74 20                	je     80105a10 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801059f0:	83 c2 01             	add    $0x1,%edx
801059f3:	83 fa 10             	cmp    $0x10,%edx
801059f6:	75 f0                	jne    801059e8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801059f8:	e8 e3 e2 ff ff       	call   80103ce0 <myproc>
801059fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a04:	00 
80105a05:	eb a1                	jmp    801059a8 <sys_pipe+0x58>
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105a10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a1f:	31 c0                	xor    %eax,%eax
}
80105a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a24:	5b                   	pop    %ebx
80105a25:	5e                   	pop    %esi
80105a26:	5f                   	pop    %edi
80105a27:	5d                   	pop    %ebp
80105a28:	c3                   	ret    
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_swapread>:

int sys_swapread(void)
{
80105a30:	f3 0f 1e fb          	endbr32 
80105a34:	55                   	push   %ebp
80105a35:	89 e5                	mov    %esp,%ebp
80105a37:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105a3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a3d:	68 00 10 00 00       	push   $0x1000
80105a42:	50                   	push   %eax
80105a43:	6a 00                	push   $0x0
80105a45:	e8 e6 f2 ff ff       	call   80104d30 <argptr>
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	85 c0                	test   %eax,%eax
80105a4f:	78 2f                	js     80105a80 <sys_swapread+0x50>
80105a51:	83 ec 08             	sub    $0x8,%esp
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a57:	50                   	push   %eax
80105a58:	6a 01                	push   $0x1
80105a5a:	e8 81 f2 ff ff       	call   80104ce0 <argint>
80105a5f:	83 c4 10             	add    $0x10,%esp
80105a62:	85 c0                	test   %eax,%eax
80105a64:	78 1a                	js     80105a80 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105a66:	83 ec 08             	sub    $0x8,%esp
80105a69:	ff 75 f4             	pushl  -0xc(%ebp)
80105a6c:	ff 75 f0             	pushl  -0x10(%ebp)
80105a6f:	e8 fc c5 ff ff       	call   80102070 <swapread>
	return 0;
80105a74:	83 c4 10             	add    $0x10,%esp
80105a77:	31 c0                	xor    %eax,%eax
}
80105a79:	c9                   	leave  
80105a7a:	c3                   	ret    
80105a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a7f:	90                   	nop
80105a80:	c9                   	leave  
		return -1;
80105a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a86:	c3                   	ret    
80105a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105a90:	f3 0f 1e fb          	endbr32 
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105a9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a9d:	68 00 10 00 00       	push   $0x1000
80105aa2:	50                   	push   %eax
80105aa3:	6a 00                	push   $0x0
80105aa5:	e8 86 f2 ff ff       	call   80104d30 <argptr>
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	85 c0                	test   %eax,%eax
80105aaf:	78 2f                	js     80105ae0 <sys_swapwrite+0x50>
80105ab1:	83 ec 08             	sub    $0x8,%esp
80105ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ab7:	50                   	push   %eax
80105ab8:	6a 01                	push   $0x1
80105aba:	e8 21 f2 ff ff       	call   80104ce0 <argint>
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	85 c0                	test   %eax,%eax
80105ac4:	78 1a                	js     80105ae0 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105ac6:	83 ec 08             	sub    $0x8,%esp
80105ac9:	ff 75 f4             	pushl  -0xc(%ebp)
80105acc:	ff 75 f0             	pushl  -0x10(%ebp)
80105acf:	e8 2c c6 ff ff       	call   80102100 <swapwrite>
	return 0;
80105ad4:	83 c4 10             	add    $0x10,%esp
80105ad7:	31 c0                	xor    %eax,%eax
}
80105ad9:	c9                   	leave  
80105ada:	c3                   	ret    
80105adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop
80105ae0:	c9                   	leave  
		return -1;
80105ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ae6:	c3                   	ret    
80105ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aee:	66 90                	xchg   %ax,%ax

80105af0 <sys_swapstat>:

int sys_swapstat(void)
{
80105af0:	f3 0f 1e fb          	endbr32 
80105af4:	55                   	push   %ebp
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105af8:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80105afb:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105afe:	6a 04                	push   $0x4
80105b00:	50                   	push   %eax
80105b01:	6a 00                	push   $0x0
80105b03:	e8 28 f2 ff ff       	call   80104d30 <argptr>
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	85 c0                	test   %eax,%eax
80105b0d:	75 39                	jne    80105b48 <sys_swapstat+0x58>
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
80105b0f:	83 ec 04             	sub    $0x4,%esp
80105b12:	89 c3                	mov    %eax,%ebx
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b17:	6a 04                	push   $0x4
80105b19:	50                   	push   %eax
80105b1a:	6a 01                	push   $0x1
80105b1c:	e8 0f f2 ff ff       	call   80104d30 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105b21:	83 c4 10             	add    $0x10,%esp
80105b24:	85 c0                	test   %eax,%eax
80105b26:	78 20                	js     80105b48 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
80105b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2b:	8b 15 c0 09 11 80    	mov    0x801109c0,%edx
80105b31:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
80105b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b36:	8b 15 e0 09 11 80    	mov    0x801109e0,%edx
80105b3c:	89 10                	mov    %edx,(%eax)
	return 0;
}
80105b3e:	89 d8                	mov    %ebx,%eax
80105b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b43:	c9                   	leave  
80105b44:	c3                   	ret    
80105b45:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
80105b48:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b4d:	eb ef                	jmp    80105b3e <sys_swapstat+0x4e>
80105b4f:	90                   	nop

80105b50 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105b50:	f3 0f 1e fb          	endbr32 
  return fork();
80105b54:	e9 47 e3 ff ff       	jmp    80103ea0 <fork>
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_exit>:
}

int
sys_exit(void)
{
80105b60:	f3 0f 1e fb          	endbr32 
80105b64:	55                   	push   %ebp
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b6a:	e8 b1 e5 ff ff       	call   80104120 <exit>
  return 0;  // not reached
}
80105b6f:	31 c0                	xor    %eax,%eax
80105b71:	c9                   	leave  
80105b72:	c3                   	ret    
80105b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b80 <sys_wait>:

int
sys_wait(void)
{
80105b80:	f3 0f 1e fb          	endbr32 
  return wait();
80105b84:	e9 e7 e7 ff ff       	jmp    80104370 <wait>
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_kill>:
}

int
sys_kill(void)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b9d:	50                   	push   %eax
80105b9e:	6a 00                	push   $0x0
80105ba0:	e8 3b f1 ff ff       	call   80104ce0 <argint>
80105ba5:	83 c4 10             	add    $0x10,%esp
80105ba8:	85 c0                	test   %eax,%eax
80105baa:	78 14                	js     80105bc0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bac:	83 ec 0c             	sub    $0xc,%esp
80105baf:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb2:	e8 19 e9 ff ff       	call   801044d0 <kill>
80105bb7:	83 c4 10             	add    $0x10,%esp
}
80105bba:	c9                   	leave  
80105bbb:	c3                   	ret    
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc0:	c9                   	leave  
    return -1;
80105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bc6:	c3                   	ret    
80105bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <sys_getpid>:

int
sys_getpid(void)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105bda:	e8 01 e1 ff ff       	call   80103ce0 <myproc>
80105bdf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105be2:	c9                   	leave  
80105be3:	c3                   	ret    
80105be4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop

80105bf0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105bf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bfb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bfe:	50                   	push   %eax
80105bff:	6a 00                	push   $0x0
80105c01:	e8 da f0 ff ff       	call   80104ce0 <argint>
80105c06:	83 c4 10             	add    $0x10,%esp
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	78 23                	js     80105c30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c0d:	e8 ce e0 ff ff       	call   80103ce0 <myproc>
  if(growproc(n) < 0)
80105c12:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c15:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c17:	ff 75 f4             	pushl  -0xc(%ebp)
80105c1a:	e8 01 e2 ff ff       	call   80103e20 <growproc>
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	85 c0                	test   %eax,%eax
80105c24:	78 0a                	js     80105c30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c26:	89 d8                	mov    %ebx,%eax
80105c28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c2b:	c9                   	leave  
80105c2c:	c3                   	ret    
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c35:	eb ef                	jmp    80105c26 <sys_sbrk+0x36>
80105c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3e:	66 90                	xchg   %ax,%ax

80105c40 <sys_sleep>:

int
sys_sleep(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c48:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c4b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c4e:	50                   	push   %eax
80105c4f:	6a 00                	push   $0x0
80105c51:	e8 8a f0 ff ff       	call   80104ce0 <argint>
80105c56:	83 c4 10             	add    $0x10,%esp
80105c59:	85 c0                	test   %eax,%eax
80105c5b:	0f 88 86 00 00 00    	js     80105ce7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c61:	83 ec 0c             	sub    $0xc,%esp
80105c64:	68 a0 ac 20 80       	push   $0x8020aca0
80105c69:	e8 82 ec ff ff       	call   801048f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c71:	8b 1d e0 b4 20 80    	mov    0x8020b4e0,%ebx
  while(ticks - ticks0 < n){
80105c77:	83 c4 10             	add    $0x10,%esp
80105c7a:	85 d2                	test   %edx,%edx
80105c7c:	75 23                	jne    80105ca1 <sys_sleep+0x61>
80105c7e:	eb 50                	jmp    80105cd0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c80:	83 ec 08             	sub    $0x8,%esp
80105c83:	68 a0 ac 20 80       	push   $0x8020aca0
80105c88:	68 e0 b4 20 80       	push   $0x8020b4e0
80105c8d:	e8 1e e6 ff ff       	call   801042b0 <sleep>
  while(ticks - ticks0 < n){
80105c92:	a1 e0 b4 20 80       	mov    0x8020b4e0,%eax
80105c97:	83 c4 10             	add    $0x10,%esp
80105c9a:	29 d8                	sub    %ebx,%eax
80105c9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c9f:	73 2f                	jae    80105cd0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ca1:	e8 3a e0 ff ff       	call   80103ce0 <myproc>
80105ca6:	8b 40 24             	mov    0x24(%eax),%eax
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	74 d3                	je     80105c80 <sys_sleep+0x40>
      release(&tickslock);
80105cad:	83 ec 0c             	sub    $0xc,%esp
80105cb0:	68 a0 ac 20 80       	push   $0x8020aca0
80105cb5:	e8 f6 ec ff ff       	call   801049b0 <release>
  }
  release(&tickslock);
  return 0;
}
80105cba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105cbd:	83 c4 10             	add    $0x10,%esp
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	68 a0 ac 20 80       	push   $0x8020aca0
80105cd8:	e8 d3 ec ff ff       	call   801049b0 <release>
  return 0;
80105cdd:	83 c4 10             	add    $0x10,%esp
80105ce0:	31 c0                	xor    %eax,%eax
}
80105ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ce5:	c9                   	leave  
80105ce6:	c3                   	ret    
    return -1;
80105ce7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cec:	eb f4                	jmp    80105ce2 <sys_sleep+0xa2>
80105cee:	66 90                	xchg   %ax,%ax

80105cf0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	53                   	push   %ebx
80105cf8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105cfb:	68 a0 ac 20 80       	push   $0x8020aca0
80105d00:	e8 eb eb ff ff       	call   801048f0 <acquire>
  xticks = ticks;
80105d05:	8b 1d e0 b4 20 80    	mov    0x8020b4e0,%ebx
  release(&tickslock);
80105d0b:	c7 04 24 a0 ac 20 80 	movl   $0x8020aca0,(%esp)
80105d12:	e8 99 ec ff ff       	call   801049b0 <release>
  return xticks;
}
80105d17:	89 d8                	mov    %ebx,%eax
80105d19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d1c:	c9                   	leave  
80105d1d:	c3                   	ret    

80105d1e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d1e:	1e                   	push   %ds
  pushl %es
80105d1f:	06                   	push   %es
  pushl %fs
80105d20:	0f a0                	push   %fs
  pushl %gs
80105d22:	0f a8                	push   %gs
  pushal
80105d24:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d25:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d29:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d2b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d2d:	54                   	push   %esp
  call trap
80105d2e:	e8 dd 00 00 00       	call   80105e10 <trap>
  addl $4, %esp
80105d33:	83 c4 04             	add    $0x4,%esp

80105d36 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d36:	61                   	popa   
  popl %gs
80105d37:	0f a9                	pop    %gs
  popl %fs
80105d39:	0f a1                	pop    %fs
  popl %es
80105d3b:	07                   	pop    %es
  popl %ds
80105d3c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d3d:	83 c4 08             	add    $0x8,%esp
  iret
80105d40:	cf                   	iret   
80105d41:	66 90                	xchg   %ax,%ax
80105d43:	66 90                	xchg   %ax,%ax
80105d45:	66 90                	xchg   %ax,%ax
80105d47:	66 90                	xchg   %ax,%ax
80105d49:	66 90                	xchg   %ax,%ax
80105d4b:	66 90                	xchg   %ax,%ax
80105d4d:	66 90                	xchg   %ax,%ax
80105d4f:	90                   	nop

80105d50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d50:	f3 0f 1e fb          	endbr32 
80105d54:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d55:	31 c0                	xor    %eax,%eax
{
80105d57:	89 e5                	mov    %esp,%ebp
80105d59:	83 ec 08             	sub    $0x8,%esp
80105d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d60:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105d67:	c7 04 c5 e2 ac 20 80 	movl   $0x8e000008,-0x7fdf531e(,%eax,8)
80105d6e:	08 00 00 8e 
80105d72:	66 89 14 c5 e0 ac 20 	mov    %dx,-0x7fdf5320(,%eax,8)
80105d79:	80 
80105d7a:	c1 ea 10             	shr    $0x10,%edx
80105d7d:	66 89 14 c5 e6 ac 20 	mov    %dx,-0x7fdf531a(,%eax,8)
80105d84:	80 
  for(i = 0; i < 256; i++)
80105d85:	83 c0 01             	add    $0x1,%eax
80105d88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d8d:	75 d1                	jne    80105d60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d92:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105d97:	c7 05 e2 ae 20 80 08 	movl   $0xef000008,0x8020aee2
80105d9e:	00 00 ef 
  initlock(&tickslock, "time");
80105da1:	68 a5 7d 10 80       	push   $0x80107da5
80105da6:	68 a0 ac 20 80       	push   $0x8020aca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dab:	66 a3 e0 ae 20 80    	mov    %ax,0x8020aee0
80105db1:	c1 e8 10             	shr    $0x10,%eax
80105db4:	66 a3 e6 ae 20 80    	mov    %ax,0x8020aee6
  initlock(&tickslock, "time");
80105dba:	e8 b1 e9 ff ff       	call   80104770 <initlock>
}
80105dbf:	83 c4 10             	add    $0x10,%esp
80105dc2:	c9                   	leave  
80105dc3:	c3                   	ret    
80105dc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop

80105dd0 <idtinit>:

void
idtinit(void)
{
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
  pd[0] = size-1;
80105dd5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dda:	89 e5                	mov    %esp,%ebp
80105ddc:	83 ec 10             	sub    $0x10,%esp
80105ddf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105de3:	b8 e0 ac 20 80       	mov    $0x8020ace0,%eax
80105de8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105dec:	c1 e8 10             	shr    $0x10,%eax
80105def:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105df3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105df6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105df9:	c9                   	leave  
80105dfa:	c3                   	ret    
80105dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dff:	90                   	nop

80105e00 <page_fault_handler>:

int page_fault_handler(){ // 완성할 것
80105e00:	f3 0f 1e fb          	endbr32 
  return -1;
}
80105e04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e09:	c3                   	ret    
80105e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e10 <trap>:

void
trap(struct trapframe *tf)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	57                   	push   %edi
80105e18:	56                   	push   %esi
80105e19:	53                   	push   %ebx
80105e1a:	83 ec 1c             	sub    $0x1c,%esp
80105e1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e20:	8b 43 30             	mov    0x30(%ebx),%eax
80105e23:	83 f8 40             	cmp    $0x40,%eax
80105e26:	0f 84 9c 01 00 00    	je     80105fc8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }
  // My Code
  if(tf->trapno == T_PGFLT){
80105e2c:	83 f8 0e             	cmp    $0xe,%eax
80105e2f:	74 10                	je     80105e41 <trap+0x31>
      goto KILL;
    }
    return;
  }

  switch(tf->trapno){
80105e31:	83 e8 20             	sub    $0x20,%eax
80105e34:	83 f8 1f             	cmp    $0x1f,%eax
80105e37:	77 08                	ja     80105e41 <trap+0x31>
80105e39:	3e ff 24 85 4c 7e 10 	notrack jmp *-0x7fef81b4(,%eax,4)
80105e40:	80 
    lapiceoi();
    break;

  KILL:
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e41:	e8 9a de ff ff       	call   80103ce0 <myproc>
80105e46:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e49:	85 c0                	test   %eax,%eax
80105e4b:	0f 84 c6 01 00 00    	je     80106017 <trap+0x207>
80105e51:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e55:	0f 84 bc 01 00 00    	je     80106017 <trap+0x207>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e5b:	0f 20 d1             	mov    %cr2,%ecx
80105e5e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e61:	e8 5a de ff ff       	call   80103cc0 <cpuid>
80105e66:	8b 73 30             	mov    0x30(%ebx),%esi
80105e69:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e6c:	8b 43 34             	mov    0x34(%ebx),%eax
80105e6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105e72:	e8 69 de ff ff       	call   80103ce0 <myproc>
80105e77:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e7a:	e8 61 de ff ff       	call   80103ce0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e7f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e82:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e85:	51                   	push   %ecx
80105e86:	57                   	push   %edi
80105e87:	52                   	push   %edx
80105e88:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e8b:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e8c:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e8f:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e92:	56                   	push   %esi
80105e93:	ff 70 10             	pushl  0x10(%eax)
80105e96:	68 08 7e 10 80       	push   $0x80107e08
80105e9b:	e8 10 a8 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105ea0:	83 c4 20             	add    $0x20,%esp
80105ea3:	e8 38 de ff ff       	call   80103ce0 <myproc>
80105ea8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eaf:	e8 2c de ff ff       	call   80103ce0 <myproc>
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	74 1d                	je     80105ed5 <trap+0xc5>
80105eb8:	e8 23 de ff ff       	call   80103ce0 <myproc>
80105ebd:	8b 50 24             	mov    0x24(%eax),%edx
80105ec0:	85 d2                	test   %edx,%edx
80105ec2:	74 11                	je     80105ed5 <trap+0xc5>
80105ec4:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ec8:	83 e0 03             	and    $0x3,%eax
80105ecb:	66 83 f8 03          	cmp    $0x3,%ax
80105ecf:	0f 84 2b 01 00 00    	je     80106000 <trap+0x1f0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ed5:	e8 06 de ff ff       	call   80103ce0 <myproc>
80105eda:	85 c0                	test   %eax,%eax
80105edc:	74 0f                	je     80105eed <trap+0xdd>
80105ede:	e8 fd dd ff ff       	call   80103ce0 <myproc>
80105ee3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ee7:	0f 84 c3 00 00 00    	je     80105fb0 <trap+0x1a0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
       yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eed:	e8 ee dd ff ff       	call   80103ce0 <myproc>
80105ef2:	85 c0                	test   %eax,%eax
80105ef4:	74 1d                	je     80105f13 <trap+0x103>
80105ef6:	e8 e5 dd ff ff       	call   80103ce0 <myproc>
80105efb:	8b 40 24             	mov    0x24(%eax),%eax
80105efe:	85 c0                	test   %eax,%eax
80105f00:	74 11                	je     80105f13 <trap+0x103>
80105f02:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f06:	83 e0 03             	and    $0x3,%eax
80105f09:	66 83 f8 03          	cmp    $0x3,%ax
80105f0d:	0f 84 de 00 00 00    	je     80105ff1 <trap+0x1e1>
    exit();
}
80105f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f16:	5b                   	pop    %ebx
80105f17:	5e                   	pop    %esi
80105f18:	5f                   	pop    %edi
80105f19:	5d                   	pop    %ebp
80105f1a:	c3                   	ret    
    ideintr();
80105f1b:	e8 d0 c3 ff ff       	call   801022f0 <ideintr>
    lapiceoi();
80105f20:	e8 1b cd ff ff       	call   80102c40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f25:	e8 b6 dd ff ff       	call   80103ce0 <myproc>
80105f2a:	85 c0                	test   %eax,%eax
80105f2c:	75 8a                	jne    80105eb8 <trap+0xa8>
80105f2e:	eb a5                	jmp    80105ed5 <trap+0xc5>
    if(cpuid() == 0){
80105f30:	e8 8b dd ff ff       	call   80103cc0 <cpuid>
80105f35:	85 c0                	test   %eax,%eax
80105f37:	75 e7                	jne    80105f20 <trap+0x110>
      acquire(&tickslock);
80105f39:	83 ec 0c             	sub    $0xc,%esp
80105f3c:	68 a0 ac 20 80       	push   $0x8020aca0
80105f41:	e8 aa e9 ff ff       	call   801048f0 <acquire>
      wakeup(&ticks);
80105f46:	c7 04 24 e0 b4 20 80 	movl   $0x8020b4e0,(%esp)
      ticks++;
80105f4d:	83 05 e0 b4 20 80 01 	addl   $0x1,0x8020b4e0
      wakeup(&ticks);
80105f54:	e8 17 e5 ff ff       	call   80104470 <wakeup>
      release(&tickslock);
80105f59:	c7 04 24 a0 ac 20 80 	movl   $0x8020aca0,(%esp)
80105f60:	e8 4b ea ff ff       	call   801049b0 <release>
80105f65:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f68:	eb b6                	jmp    80105f20 <trap+0x110>
    kbdintr();
80105f6a:	e8 91 cb ff ff       	call   80102b00 <kbdintr>
    lapiceoi();
80105f6f:	e8 cc cc ff ff       	call   80102c40 <lapiceoi>
    break;
80105f74:	e9 36 ff ff ff       	jmp    80105eaf <trap+0x9f>
    uartintr();
80105f79:	e8 32 02 00 00       	call   801061b0 <uartintr>
    lapiceoi();
80105f7e:	e8 bd cc ff ff       	call   80102c40 <lapiceoi>
    break;
80105f83:	e9 27 ff ff ff       	jmp    80105eaf <trap+0x9f>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f88:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f8b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f8f:	e8 2c dd ff ff       	call   80103cc0 <cpuid>
80105f94:	57                   	push   %edi
80105f95:	56                   	push   %esi
80105f96:	50                   	push   %eax
80105f97:	68 b0 7d 10 80       	push   $0x80107db0
80105f9c:	e8 0f a7 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105fa1:	e8 9a cc ff ff       	call   80102c40 <lapiceoi>
    break;
80105fa6:	83 c4 10             	add    $0x10,%esp
80105fa9:	e9 01 ff ff ff       	jmp    80105eaf <trap+0x9f>
80105fae:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80105fb0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105fb4:	0f 85 33 ff ff ff    	jne    80105eed <trap+0xdd>
       yield();
80105fba:	e8 a1 e2 ff ff       	call   80104260 <yield>
80105fbf:	e9 29 ff ff ff       	jmp    80105eed <trap+0xdd>
80105fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105fc8:	e8 13 dd ff ff       	call   80103ce0 <myproc>
80105fcd:	8b 70 24             	mov    0x24(%eax),%esi
80105fd0:	85 f6                	test   %esi,%esi
80105fd2:	75 3c                	jne    80106010 <trap+0x200>
    myproc()->tf = tf;
80105fd4:	e8 07 dd ff ff       	call   80103ce0 <myproc>
80105fd9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105fdc:	e8 ef ed ff ff       	call   80104dd0 <syscall>
    if(myproc()->killed)
80105fe1:	e8 fa dc ff ff       	call   80103ce0 <myproc>
80105fe6:	8b 48 24             	mov    0x24(%eax),%ecx
80105fe9:	85 c9                	test   %ecx,%ecx
80105feb:	0f 84 22 ff ff ff    	je     80105f13 <trap+0x103>
}
80105ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff4:	5b                   	pop    %ebx
80105ff5:	5e                   	pop    %esi
80105ff6:	5f                   	pop    %edi
80105ff7:	5d                   	pop    %ebp
      exit();
80105ff8:	e9 23 e1 ff ff       	jmp    80104120 <exit>
80105ffd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106000:	e8 1b e1 ff ff       	call   80104120 <exit>
80106005:	e9 cb fe ff ff       	jmp    80105ed5 <trap+0xc5>
8010600a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106010:	e8 0b e1 ff ff       	call   80104120 <exit>
80106015:	eb bd                	jmp    80105fd4 <trap+0x1c4>
80106017:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010601a:	e8 a1 dc ff ff       	call   80103cc0 <cpuid>
8010601f:	83 ec 0c             	sub    $0xc,%esp
80106022:	56                   	push   %esi
80106023:	57                   	push   %edi
80106024:	50                   	push   %eax
80106025:	ff 73 30             	pushl  0x30(%ebx)
80106028:	68 d4 7d 10 80       	push   $0x80107dd4
8010602d:	e8 7e a6 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106032:	83 c4 14             	add    $0x14,%esp
80106035:	68 aa 7d 10 80       	push   $0x80107daa
8010603a:	e8 51 a3 ff ff       	call   80100390 <panic>
8010603f:	90                   	nop

80106040 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106040:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106044:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80106049:	85 c0                	test   %eax,%eax
8010604b:	74 1b                	je     80106068 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010604d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106052:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106053:	a8 01                	test   $0x1,%al
80106055:	74 11                	je     80106068 <uartgetc+0x28>
80106057:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010605c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010605d:	0f b6 c0             	movzbl %al,%eax
80106060:	c3                   	ret    
80106061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010606d:	c3                   	ret    
8010606e:	66 90                	xchg   %ax,%ax

80106070 <uartputc.part.0>:
uartputc(int c)
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	57                   	push   %edi
80106074:	89 c7                	mov    %eax,%edi
80106076:	56                   	push   %esi
80106077:	be fd 03 00 00       	mov    $0x3fd,%esi
8010607c:	53                   	push   %ebx
8010607d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106082:	83 ec 0c             	sub    $0xc,%esp
80106085:	eb 1b                	jmp    801060a2 <uartputc.part.0+0x32>
80106087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	6a 0a                	push   $0xa
80106095:	e8 c6 cb ff ff       	call   80102c60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010609a:	83 c4 10             	add    $0x10,%esp
8010609d:	83 eb 01             	sub    $0x1,%ebx
801060a0:	74 07                	je     801060a9 <uartputc.part.0+0x39>
801060a2:	89 f2                	mov    %esi,%edx
801060a4:	ec                   	in     (%dx),%al
801060a5:	a8 20                	test   $0x20,%al
801060a7:	74 e7                	je     80106090 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ae:	89 f8                	mov    %edi,%eax
801060b0:	ee                   	out    %al,(%dx)
}
801060b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b4:	5b                   	pop    %ebx
801060b5:	5e                   	pop    %esi
801060b6:	5f                   	pop    %edi
801060b7:	5d                   	pop    %ebp
801060b8:	c3                   	ret    
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060c0 <uartinit>:
{
801060c0:	f3 0f 1e fb          	endbr32 
801060c4:	55                   	push   %ebp
801060c5:	31 c9                	xor    %ecx,%ecx
801060c7:	89 c8                	mov    %ecx,%eax
801060c9:	89 e5                	mov    %esp,%ebp
801060cb:	57                   	push   %edi
801060cc:	56                   	push   %esi
801060cd:	53                   	push   %ebx
801060ce:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801060d3:	89 da                	mov    %ebx,%edx
801060d5:	83 ec 0c             	sub    $0xc,%esp
801060d8:	ee                   	out    %al,(%dx)
801060d9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801060de:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060e3:	89 fa                	mov    %edi,%edx
801060e5:	ee                   	out    %al,(%dx)
801060e6:	b8 0c 00 00 00       	mov    $0xc,%eax
801060eb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060f0:	ee                   	out    %al,(%dx)
801060f1:	be f9 03 00 00       	mov    $0x3f9,%esi
801060f6:	89 c8                	mov    %ecx,%eax
801060f8:	89 f2                	mov    %esi,%edx
801060fa:	ee                   	out    %al,(%dx)
801060fb:	b8 03 00 00 00       	mov    $0x3,%eax
80106100:	89 fa                	mov    %edi,%edx
80106102:	ee                   	out    %al,(%dx)
80106103:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106108:	89 c8                	mov    %ecx,%eax
8010610a:	ee                   	out    %al,(%dx)
8010610b:	b8 01 00 00 00       	mov    $0x1,%eax
80106110:	89 f2                	mov    %esi,%edx
80106112:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106113:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106118:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106119:	3c ff                	cmp    $0xff,%al
8010611b:	74 52                	je     8010616f <uartinit+0xaf>
  uart = 1;
8010611d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80106124:	00 00 00 
80106127:	89 da                	mov    %ebx,%edx
80106129:	ec                   	in     (%dx),%al
8010612a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010612f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106130:	83 ec 08             	sub    $0x8,%esp
80106133:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106138:	bb cc 7e 10 80       	mov    $0x80107ecc,%ebx
  ioapicenable(IRQ_COM1, 0);
8010613d:	6a 00                	push   $0x0
8010613f:	6a 04                	push   $0x4
80106141:	e8 fa c3 ff ff       	call   80102540 <ioapicenable>
80106146:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106149:	b8 78 00 00 00       	mov    $0x78,%eax
8010614e:	eb 04                	jmp    80106154 <uartinit+0x94>
80106150:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106154:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
8010615a:	85 d2                	test   %edx,%edx
8010615c:	74 08                	je     80106166 <uartinit+0xa6>
    uartputc(*p);
8010615e:	0f be c0             	movsbl %al,%eax
80106161:	e8 0a ff ff ff       	call   80106070 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106166:	89 f0                	mov    %esi,%eax
80106168:	83 c3 01             	add    $0x1,%ebx
8010616b:	84 c0                	test   %al,%al
8010616d:	75 e1                	jne    80106150 <uartinit+0x90>
}
8010616f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106172:	5b                   	pop    %ebx
80106173:	5e                   	pop    %esi
80106174:	5f                   	pop    %edi
80106175:	5d                   	pop    %ebp
80106176:	c3                   	ret    
80106177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617e:	66 90                	xchg   %ax,%ax

80106180 <uartputc>:
{
80106180:	f3 0f 1e fb          	endbr32 
80106184:	55                   	push   %ebp
  if(!uart)
80106185:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
8010618b:	89 e5                	mov    %esp,%ebp
8010618d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106190:	85 d2                	test   %edx,%edx
80106192:	74 0c                	je     801061a0 <uartputc+0x20>
}
80106194:	5d                   	pop    %ebp
80106195:	e9 d6 fe ff ff       	jmp    80106070 <uartputc.part.0>
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061a0:	5d                   	pop    %ebp
801061a1:	c3                   	ret    
801061a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061b0 <uartintr>:

void
uartintr(void)
{
801061b0:	f3 0f 1e fb          	endbr32 
801061b4:	55                   	push   %ebp
801061b5:	89 e5                	mov    %esp,%ebp
801061b7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061ba:	68 40 60 10 80       	push   $0x80106040
801061bf:	e8 9c a6 ff ff       	call   80100860 <consoleintr>
}
801061c4:	83 c4 10             	add    $0x10,%esp
801061c7:	c9                   	leave  
801061c8:	c3                   	ret    

801061c9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $0
801061cb:	6a 00                	push   $0x0
  jmp alltraps
801061cd:	e9 4c fb ff ff       	jmp    80105d1e <alltraps>

801061d2 <vector1>:
.globl vector1
vector1:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $1
801061d4:	6a 01                	push   $0x1
  jmp alltraps
801061d6:	e9 43 fb ff ff       	jmp    80105d1e <alltraps>

801061db <vector2>:
.globl vector2
vector2:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $2
801061dd:	6a 02                	push   $0x2
  jmp alltraps
801061df:	e9 3a fb ff ff       	jmp    80105d1e <alltraps>

801061e4 <vector3>:
.globl vector3
vector3:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $3
801061e6:	6a 03                	push   $0x3
  jmp alltraps
801061e8:	e9 31 fb ff ff       	jmp    80105d1e <alltraps>

801061ed <vector4>:
.globl vector4
vector4:
  pushl $0
801061ed:	6a 00                	push   $0x0
  pushl $4
801061ef:	6a 04                	push   $0x4
  jmp alltraps
801061f1:	e9 28 fb ff ff       	jmp    80105d1e <alltraps>

801061f6 <vector5>:
.globl vector5
vector5:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $5
801061f8:	6a 05                	push   $0x5
  jmp alltraps
801061fa:	e9 1f fb ff ff       	jmp    80105d1e <alltraps>

801061ff <vector6>:
.globl vector6
vector6:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $6
80106201:	6a 06                	push   $0x6
  jmp alltraps
80106203:	e9 16 fb ff ff       	jmp    80105d1e <alltraps>

80106208 <vector7>:
.globl vector7
vector7:
  pushl $0
80106208:	6a 00                	push   $0x0
  pushl $7
8010620a:	6a 07                	push   $0x7
  jmp alltraps
8010620c:	e9 0d fb ff ff       	jmp    80105d1e <alltraps>

80106211 <vector8>:
.globl vector8
vector8:
  pushl $8
80106211:	6a 08                	push   $0x8
  jmp alltraps
80106213:	e9 06 fb ff ff       	jmp    80105d1e <alltraps>

80106218 <vector9>:
.globl vector9
vector9:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $9
8010621a:	6a 09                	push   $0x9
  jmp alltraps
8010621c:	e9 fd fa ff ff       	jmp    80105d1e <alltraps>

80106221 <vector10>:
.globl vector10
vector10:
  pushl $10
80106221:	6a 0a                	push   $0xa
  jmp alltraps
80106223:	e9 f6 fa ff ff       	jmp    80105d1e <alltraps>

80106228 <vector11>:
.globl vector11
vector11:
  pushl $11
80106228:	6a 0b                	push   $0xb
  jmp alltraps
8010622a:	e9 ef fa ff ff       	jmp    80105d1e <alltraps>

8010622f <vector12>:
.globl vector12
vector12:
  pushl $12
8010622f:	6a 0c                	push   $0xc
  jmp alltraps
80106231:	e9 e8 fa ff ff       	jmp    80105d1e <alltraps>

80106236 <vector13>:
.globl vector13
vector13:
  pushl $13
80106236:	6a 0d                	push   $0xd
  jmp alltraps
80106238:	e9 e1 fa ff ff       	jmp    80105d1e <alltraps>

8010623d <vector14>:
.globl vector14
vector14:
  pushl $14
8010623d:	6a 0e                	push   $0xe
  jmp alltraps
8010623f:	e9 da fa ff ff       	jmp    80105d1e <alltraps>

80106244 <vector15>:
.globl vector15
vector15:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $15
80106246:	6a 0f                	push   $0xf
  jmp alltraps
80106248:	e9 d1 fa ff ff       	jmp    80105d1e <alltraps>

8010624d <vector16>:
.globl vector16
vector16:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $16
8010624f:	6a 10                	push   $0x10
  jmp alltraps
80106251:	e9 c8 fa ff ff       	jmp    80105d1e <alltraps>

80106256 <vector17>:
.globl vector17
vector17:
  pushl $17
80106256:	6a 11                	push   $0x11
  jmp alltraps
80106258:	e9 c1 fa ff ff       	jmp    80105d1e <alltraps>

8010625d <vector18>:
.globl vector18
vector18:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $18
8010625f:	6a 12                	push   $0x12
  jmp alltraps
80106261:	e9 b8 fa ff ff       	jmp    80105d1e <alltraps>

80106266 <vector19>:
.globl vector19
vector19:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $19
80106268:	6a 13                	push   $0x13
  jmp alltraps
8010626a:	e9 af fa ff ff       	jmp    80105d1e <alltraps>

8010626f <vector20>:
.globl vector20
vector20:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $20
80106271:	6a 14                	push   $0x14
  jmp alltraps
80106273:	e9 a6 fa ff ff       	jmp    80105d1e <alltraps>

80106278 <vector21>:
.globl vector21
vector21:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $21
8010627a:	6a 15                	push   $0x15
  jmp alltraps
8010627c:	e9 9d fa ff ff       	jmp    80105d1e <alltraps>

80106281 <vector22>:
.globl vector22
vector22:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $22
80106283:	6a 16                	push   $0x16
  jmp alltraps
80106285:	e9 94 fa ff ff       	jmp    80105d1e <alltraps>

8010628a <vector23>:
.globl vector23
vector23:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $23
8010628c:	6a 17                	push   $0x17
  jmp alltraps
8010628e:	e9 8b fa ff ff       	jmp    80105d1e <alltraps>

80106293 <vector24>:
.globl vector24
vector24:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $24
80106295:	6a 18                	push   $0x18
  jmp alltraps
80106297:	e9 82 fa ff ff       	jmp    80105d1e <alltraps>

8010629c <vector25>:
.globl vector25
vector25:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $25
8010629e:	6a 19                	push   $0x19
  jmp alltraps
801062a0:	e9 79 fa ff ff       	jmp    80105d1e <alltraps>

801062a5 <vector26>:
.globl vector26
vector26:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $26
801062a7:	6a 1a                	push   $0x1a
  jmp alltraps
801062a9:	e9 70 fa ff ff       	jmp    80105d1e <alltraps>

801062ae <vector27>:
.globl vector27
vector27:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $27
801062b0:	6a 1b                	push   $0x1b
  jmp alltraps
801062b2:	e9 67 fa ff ff       	jmp    80105d1e <alltraps>

801062b7 <vector28>:
.globl vector28
vector28:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $28
801062b9:	6a 1c                	push   $0x1c
  jmp alltraps
801062bb:	e9 5e fa ff ff       	jmp    80105d1e <alltraps>

801062c0 <vector29>:
.globl vector29
vector29:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $29
801062c2:	6a 1d                	push   $0x1d
  jmp alltraps
801062c4:	e9 55 fa ff ff       	jmp    80105d1e <alltraps>

801062c9 <vector30>:
.globl vector30
vector30:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $30
801062cb:	6a 1e                	push   $0x1e
  jmp alltraps
801062cd:	e9 4c fa ff ff       	jmp    80105d1e <alltraps>

801062d2 <vector31>:
.globl vector31
vector31:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $31
801062d4:	6a 1f                	push   $0x1f
  jmp alltraps
801062d6:	e9 43 fa ff ff       	jmp    80105d1e <alltraps>

801062db <vector32>:
.globl vector32
vector32:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $32
801062dd:	6a 20                	push   $0x20
  jmp alltraps
801062df:	e9 3a fa ff ff       	jmp    80105d1e <alltraps>

801062e4 <vector33>:
.globl vector33
vector33:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $33
801062e6:	6a 21                	push   $0x21
  jmp alltraps
801062e8:	e9 31 fa ff ff       	jmp    80105d1e <alltraps>

801062ed <vector34>:
.globl vector34
vector34:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $34
801062ef:	6a 22                	push   $0x22
  jmp alltraps
801062f1:	e9 28 fa ff ff       	jmp    80105d1e <alltraps>

801062f6 <vector35>:
.globl vector35
vector35:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $35
801062f8:	6a 23                	push   $0x23
  jmp alltraps
801062fa:	e9 1f fa ff ff       	jmp    80105d1e <alltraps>

801062ff <vector36>:
.globl vector36
vector36:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $36
80106301:	6a 24                	push   $0x24
  jmp alltraps
80106303:	e9 16 fa ff ff       	jmp    80105d1e <alltraps>

80106308 <vector37>:
.globl vector37
vector37:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $37
8010630a:	6a 25                	push   $0x25
  jmp alltraps
8010630c:	e9 0d fa ff ff       	jmp    80105d1e <alltraps>

80106311 <vector38>:
.globl vector38
vector38:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $38
80106313:	6a 26                	push   $0x26
  jmp alltraps
80106315:	e9 04 fa ff ff       	jmp    80105d1e <alltraps>

8010631a <vector39>:
.globl vector39
vector39:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $39
8010631c:	6a 27                	push   $0x27
  jmp alltraps
8010631e:	e9 fb f9 ff ff       	jmp    80105d1e <alltraps>

80106323 <vector40>:
.globl vector40
vector40:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $40
80106325:	6a 28                	push   $0x28
  jmp alltraps
80106327:	e9 f2 f9 ff ff       	jmp    80105d1e <alltraps>

8010632c <vector41>:
.globl vector41
vector41:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $41
8010632e:	6a 29                	push   $0x29
  jmp alltraps
80106330:	e9 e9 f9 ff ff       	jmp    80105d1e <alltraps>

80106335 <vector42>:
.globl vector42
vector42:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $42
80106337:	6a 2a                	push   $0x2a
  jmp alltraps
80106339:	e9 e0 f9 ff ff       	jmp    80105d1e <alltraps>

8010633e <vector43>:
.globl vector43
vector43:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $43
80106340:	6a 2b                	push   $0x2b
  jmp alltraps
80106342:	e9 d7 f9 ff ff       	jmp    80105d1e <alltraps>

80106347 <vector44>:
.globl vector44
vector44:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $44
80106349:	6a 2c                	push   $0x2c
  jmp alltraps
8010634b:	e9 ce f9 ff ff       	jmp    80105d1e <alltraps>

80106350 <vector45>:
.globl vector45
vector45:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $45
80106352:	6a 2d                	push   $0x2d
  jmp alltraps
80106354:	e9 c5 f9 ff ff       	jmp    80105d1e <alltraps>

80106359 <vector46>:
.globl vector46
vector46:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $46
8010635b:	6a 2e                	push   $0x2e
  jmp alltraps
8010635d:	e9 bc f9 ff ff       	jmp    80105d1e <alltraps>

80106362 <vector47>:
.globl vector47
vector47:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $47
80106364:	6a 2f                	push   $0x2f
  jmp alltraps
80106366:	e9 b3 f9 ff ff       	jmp    80105d1e <alltraps>

8010636b <vector48>:
.globl vector48
vector48:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $48
8010636d:	6a 30                	push   $0x30
  jmp alltraps
8010636f:	e9 aa f9 ff ff       	jmp    80105d1e <alltraps>

80106374 <vector49>:
.globl vector49
vector49:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $49
80106376:	6a 31                	push   $0x31
  jmp alltraps
80106378:	e9 a1 f9 ff ff       	jmp    80105d1e <alltraps>

8010637d <vector50>:
.globl vector50
vector50:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $50
8010637f:	6a 32                	push   $0x32
  jmp alltraps
80106381:	e9 98 f9 ff ff       	jmp    80105d1e <alltraps>

80106386 <vector51>:
.globl vector51
vector51:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $51
80106388:	6a 33                	push   $0x33
  jmp alltraps
8010638a:	e9 8f f9 ff ff       	jmp    80105d1e <alltraps>

8010638f <vector52>:
.globl vector52
vector52:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $52
80106391:	6a 34                	push   $0x34
  jmp alltraps
80106393:	e9 86 f9 ff ff       	jmp    80105d1e <alltraps>

80106398 <vector53>:
.globl vector53
vector53:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $53
8010639a:	6a 35                	push   $0x35
  jmp alltraps
8010639c:	e9 7d f9 ff ff       	jmp    80105d1e <alltraps>

801063a1 <vector54>:
.globl vector54
vector54:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $54
801063a3:	6a 36                	push   $0x36
  jmp alltraps
801063a5:	e9 74 f9 ff ff       	jmp    80105d1e <alltraps>

801063aa <vector55>:
.globl vector55
vector55:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $55
801063ac:	6a 37                	push   $0x37
  jmp alltraps
801063ae:	e9 6b f9 ff ff       	jmp    80105d1e <alltraps>

801063b3 <vector56>:
.globl vector56
vector56:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $56
801063b5:	6a 38                	push   $0x38
  jmp alltraps
801063b7:	e9 62 f9 ff ff       	jmp    80105d1e <alltraps>

801063bc <vector57>:
.globl vector57
vector57:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $57
801063be:	6a 39                	push   $0x39
  jmp alltraps
801063c0:	e9 59 f9 ff ff       	jmp    80105d1e <alltraps>

801063c5 <vector58>:
.globl vector58
vector58:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $58
801063c7:	6a 3a                	push   $0x3a
  jmp alltraps
801063c9:	e9 50 f9 ff ff       	jmp    80105d1e <alltraps>

801063ce <vector59>:
.globl vector59
vector59:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $59
801063d0:	6a 3b                	push   $0x3b
  jmp alltraps
801063d2:	e9 47 f9 ff ff       	jmp    80105d1e <alltraps>

801063d7 <vector60>:
.globl vector60
vector60:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $60
801063d9:	6a 3c                	push   $0x3c
  jmp alltraps
801063db:	e9 3e f9 ff ff       	jmp    80105d1e <alltraps>

801063e0 <vector61>:
.globl vector61
vector61:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $61
801063e2:	6a 3d                	push   $0x3d
  jmp alltraps
801063e4:	e9 35 f9 ff ff       	jmp    80105d1e <alltraps>

801063e9 <vector62>:
.globl vector62
vector62:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $62
801063eb:	6a 3e                	push   $0x3e
  jmp alltraps
801063ed:	e9 2c f9 ff ff       	jmp    80105d1e <alltraps>

801063f2 <vector63>:
.globl vector63
vector63:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $63
801063f4:	6a 3f                	push   $0x3f
  jmp alltraps
801063f6:	e9 23 f9 ff ff       	jmp    80105d1e <alltraps>

801063fb <vector64>:
.globl vector64
vector64:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $64
801063fd:	6a 40                	push   $0x40
  jmp alltraps
801063ff:	e9 1a f9 ff ff       	jmp    80105d1e <alltraps>

80106404 <vector65>:
.globl vector65
vector65:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $65
80106406:	6a 41                	push   $0x41
  jmp alltraps
80106408:	e9 11 f9 ff ff       	jmp    80105d1e <alltraps>

8010640d <vector66>:
.globl vector66
vector66:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $66
8010640f:	6a 42                	push   $0x42
  jmp alltraps
80106411:	e9 08 f9 ff ff       	jmp    80105d1e <alltraps>

80106416 <vector67>:
.globl vector67
vector67:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $67
80106418:	6a 43                	push   $0x43
  jmp alltraps
8010641a:	e9 ff f8 ff ff       	jmp    80105d1e <alltraps>

8010641f <vector68>:
.globl vector68
vector68:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $68
80106421:	6a 44                	push   $0x44
  jmp alltraps
80106423:	e9 f6 f8 ff ff       	jmp    80105d1e <alltraps>

80106428 <vector69>:
.globl vector69
vector69:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $69
8010642a:	6a 45                	push   $0x45
  jmp alltraps
8010642c:	e9 ed f8 ff ff       	jmp    80105d1e <alltraps>

80106431 <vector70>:
.globl vector70
vector70:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $70
80106433:	6a 46                	push   $0x46
  jmp alltraps
80106435:	e9 e4 f8 ff ff       	jmp    80105d1e <alltraps>

8010643a <vector71>:
.globl vector71
vector71:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $71
8010643c:	6a 47                	push   $0x47
  jmp alltraps
8010643e:	e9 db f8 ff ff       	jmp    80105d1e <alltraps>

80106443 <vector72>:
.globl vector72
vector72:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $72
80106445:	6a 48                	push   $0x48
  jmp alltraps
80106447:	e9 d2 f8 ff ff       	jmp    80105d1e <alltraps>

8010644c <vector73>:
.globl vector73
vector73:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $73
8010644e:	6a 49                	push   $0x49
  jmp alltraps
80106450:	e9 c9 f8 ff ff       	jmp    80105d1e <alltraps>

80106455 <vector74>:
.globl vector74
vector74:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $74
80106457:	6a 4a                	push   $0x4a
  jmp alltraps
80106459:	e9 c0 f8 ff ff       	jmp    80105d1e <alltraps>

8010645e <vector75>:
.globl vector75
vector75:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $75
80106460:	6a 4b                	push   $0x4b
  jmp alltraps
80106462:	e9 b7 f8 ff ff       	jmp    80105d1e <alltraps>

80106467 <vector76>:
.globl vector76
vector76:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $76
80106469:	6a 4c                	push   $0x4c
  jmp alltraps
8010646b:	e9 ae f8 ff ff       	jmp    80105d1e <alltraps>

80106470 <vector77>:
.globl vector77
vector77:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $77
80106472:	6a 4d                	push   $0x4d
  jmp alltraps
80106474:	e9 a5 f8 ff ff       	jmp    80105d1e <alltraps>

80106479 <vector78>:
.globl vector78
vector78:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $78
8010647b:	6a 4e                	push   $0x4e
  jmp alltraps
8010647d:	e9 9c f8 ff ff       	jmp    80105d1e <alltraps>

80106482 <vector79>:
.globl vector79
vector79:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $79
80106484:	6a 4f                	push   $0x4f
  jmp alltraps
80106486:	e9 93 f8 ff ff       	jmp    80105d1e <alltraps>

8010648b <vector80>:
.globl vector80
vector80:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $80
8010648d:	6a 50                	push   $0x50
  jmp alltraps
8010648f:	e9 8a f8 ff ff       	jmp    80105d1e <alltraps>

80106494 <vector81>:
.globl vector81
vector81:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $81
80106496:	6a 51                	push   $0x51
  jmp alltraps
80106498:	e9 81 f8 ff ff       	jmp    80105d1e <alltraps>

8010649d <vector82>:
.globl vector82
vector82:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $82
8010649f:	6a 52                	push   $0x52
  jmp alltraps
801064a1:	e9 78 f8 ff ff       	jmp    80105d1e <alltraps>

801064a6 <vector83>:
.globl vector83
vector83:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $83
801064a8:	6a 53                	push   $0x53
  jmp alltraps
801064aa:	e9 6f f8 ff ff       	jmp    80105d1e <alltraps>

801064af <vector84>:
.globl vector84
vector84:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $84
801064b1:	6a 54                	push   $0x54
  jmp alltraps
801064b3:	e9 66 f8 ff ff       	jmp    80105d1e <alltraps>

801064b8 <vector85>:
.globl vector85
vector85:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $85
801064ba:	6a 55                	push   $0x55
  jmp alltraps
801064bc:	e9 5d f8 ff ff       	jmp    80105d1e <alltraps>

801064c1 <vector86>:
.globl vector86
vector86:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $86
801064c3:	6a 56                	push   $0x56
  jmp alltraps
801064c5:	e9 54 f8 ff ff       	jmp    80105d1e <alltraps>

801064ca <vector87>:
.globl vector87
vector87:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $87
801064cc:	6a 57                	push   $0x57
  jmp alltraps
801064ce:	e9 4b f8 ff ff       	jmp    80105d1e <alltraps>

801064d3 <vector88>:
.globl vector88
vector88:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $88
801064d5:	6a 58                	push   $0x58
  jmp alltraps
801064d7:	e9 42 f8 ff ff       	jmp    80105d1e <alltraps>

801064dc <vector89>:
.globl vector89
vector89:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $89
801064de:	6a 59                	push   $0x59
  jmp alltraps
801064e0:	e9 39 f8 ff ff       	jmp    80105d1e <alltraps>

801064e5 <vector90>:
.globl vector90
vector90:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $90
801064e7:	6a 5a                	push   $0x5a
  jmp alltraps
801064e9:	e9 30 f8 ff ff       	jmp    80105d1e <alltraps>

801064ee <vector91>:
.globl vector91
vector91:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $91
801064f0:	6a 5b                	push   $0x5b
  jmp alltraps
801064f2:	e9 27 f8 ff ff       	jmp    80105d1e <alltraps>

801064f7 <vector92>:
.globl vector92
vector92:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $92
801064f9:	6a 5c                	push   $0x5c
  jmp alltraps
801064fb:	e9 1e f8 ff ff       	jmp    80105d1e <alltraps>

80106500 <vector93>:
.globl vector93
vector93:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $93
80106502:	6a 5d                	push   $0x5d
  jmp alltraps
80106504:	e9 15 f8 ff ff       	jmp    80105d1e <alltraps>

80106509 <vector94>:
.globl vector94
vector94:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $94
8010650b:	6a 5e                	push   $0x5e
  jmp alltraps
8010650d:	e9 0c f8 ff ff       	jmp    80105d1e <alltraps>

80106512 <vector95>:
.globl vector95
vector95:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $95
80106514:	6a 5f                	push   $0x5f
  jmp alltraps
80106516:	e9 03 f8 ff ff       	jmp    80105d1e <alltraps>

8010651b <vector96>:
.globl vector96
vector96:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $96
8010651d:	6a 60                	push   $0x60
  jmp alltraps
8010651f:	e9 fa f7 ff ff       	jmp    80105d1e <alltraps>

80106524 <vector97>:
.globl vector97
vector97:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $97
80106526:	6a 61                	push   $0x61
  jmp alltraps
80106528:	e9 f1 f7 ff ff       	jmp    80105d1e <alltraps>

8010652d <vector98>:
.globl vector98
vector98:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $98
8010652f:	6a 62                	push   $0x62
  jmp alltraps
80106531:	e9 e8 f7 ff ff       	jmp    80105d1e <alltraps>

80106536 <vector99>:
.globl vector99
vector99:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $99
80106538:	6a 63                	push   $0x63
  jmp alltraps
8010653a:	e9 df f7 ff ff       	jmp    80105d1e <alltraps>

8010653f <vector100>:
.globl vector100
vector100:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $100
80106541:	6a 64                	push   $0x64
  jmp alltraps
80106543:	e9 d6 f7 ff ff       	jmp    80105d1e <alltraps>

80106548 <vector101>:
.globl vector101
vector101:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $101
8010654a:	6a 65                	push   $0x65
  jmp alltraps
8010654c:	e9 cd f7 ff ff       	jmp    80105d1e <alltraps>

80106551 <vector102>:
.globl vector102
vector102:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $102
80106553:	6a 66                	push   $0x66
  jmp alltraps
80106555:	e9 c4 f7 ff ff       	jmp    80105d1e <alltraps>

8010655a <vector103>:
.globl vector103
vector103:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $103
8010655c:	6a 67                	push   $0x67
  jmp alltraps
8010655e:	e9 bb f7 ff ff       	jmp    80105d1e <alltraps>

80106563 <vector104>:
.globl vector104
vector104:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $104
80106565:	6a 68                	push   $0x68
  jmp alltraps
80106567:	e9 b2 f7 ff ff       	jmp    80105d1e <alltraps>

8010656c <vector105>:
.globl vector105
vector105:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $105
8010656e:	6a 69                	push   $0x69
  jmp alltraps
80106570:	e9 a9 f7 ff ff       	jmp    80105d1e <alltraps>

80106575 <vector106>:
.globl vector106
vector106:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $106
80106577:	6a 6a                	push   $0x6a
  jmp alltraps
80106579:	e9 a0 f7 ff ff       	jmp    80105d1e <alltraps>

8010657e <vector107>:
.globl vector107
vector107:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $107
80106580:	6a 6b                	push   $0x6b
  jmp alltraps
80106582:	e9 97 f7 ff ff       	jmp    80105d1e <alltraps>

80106587 <vector108>:
.globl vector108
vector108:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $108
80106589:	6a 6c                	push   $0x6c
  jmp alltraps
8010658b:	e9 8e f7 ff ff       	jmp    80105d1e <alltraps>

80106590 <vector109>:
.globl vector109
vector109:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $109
80106592:	6a 6d                	push   $0x6d
  jmp alltraps
80106594:	e9 85 f7 ff ff       	jmp    80105d1e <alltraps>

80106599 <vector110>:
.globl vector110
vector110:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $110
8010659b:	6a 6e                	push   $0x6e
  jmp alltraps
8010659d:	e9 7c f7 ff ff       	jmp    80105d1e <alltraps>

801065a2 <vector111>:
.globl vector111
vector111:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $111
801065a4:	6a 6f                	push   $0x6f
  jmp alltraps
801065a6:	e9 73 f7 ff ff       	jmp    80105d1e <alltraps>

801065ab <vector112>:
.globl vector112
vector112:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $112
801065ad:	6a 70                	push   $0x70
  jmp alltraps
801065af:	e9 6a f7 ff ff       	jmp    80105d1e <alltraps>

801065b4 <vector113>:
.globl vector113
vector113:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $113
801065b6:	6a 71                	push   $0x71
  jmp alltraps
801065b8:	e9 61 f7 ff ff       	jmp    80105d1e <alltraps>

801065bd <vector114>:
.globl vector114
vector114:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $114
801065bf:	6a 72                	push   $0x72
  jmp alltraps
801065c1:	e9 58 f7 ff ff       	jmp    80105d1e <alltraps>

801065c6 <vector115>:
.globl vector115
vector115:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $115
801065c8:	6a 73                	push   $0x73
  jmp alltraps
801065ca:	e9 4f f7 ff ff       	jmp    80105d1e <alltraps>

801065cf <vector116>:
.globl vector116
vector116:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $116
801065d1:	6a 74                	push   $0x74
  jmp alltraps
801065d3:	e9 46 f7 ff ff       	jmp    80105d1e <alltraps>

801065d8 <vector117>:
.globl vector117
vector117:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $117
801065da:	6a 75                	push   $0x75
  jmp alltraps
801065dc:	e9 3d f7 ff ff       	jmp    80105d1e <alltraps>

801065e1 <vector118>:
.globl vector118
vector118:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $118
801065e3:	6a 76                	push   $0x76
  jmp alltraps
801065e5:	e9 34 f7 ff ff       	jmp    80105d1e <alltraps>

801065ea <vector119>:
.globl vector119
vector119:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $119
801065ec:	6a 77                	push   $0x77
  jmp alltraps
801065ee:	e9 2b f7 ff ff       	jmp    80105d1e <alltraps>

801065f3 <vector120>:
.globl vector120
vector120:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $120
801065f5:	6a 78                	push   $0x78
  jmp alltraps
801065f7:	e9 22 f7 ff ff       	jmp    80105d1e <alltraps>

801065fc <vector121>:
.globl vector121
vector121:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $121
801065fe:	6a 79                	push   $0x79
  jmp alltraps
80106600:	e9 19 f7 ff ff       	jmp    80105d1e <alltraps>

80106605 <vector122>:
.globl vector122
vector122:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $122
80106607:	6a 7a                	push   $0x7a
  jmp alltraps
80106609:	e9 10 f7 ff ff       	jmp    80105d1e <alltraps>

8010660e <vector123>:
.globl vector123
vector123:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $123
80106610:	6a 7b                	push   $0x7b
  jmp alltraps
80106612:	e9 07 f7 ff ff       	jmp    80105d1e <alltraps>

80106617 <vector124>:
.globl vector124
vector124:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $124
80106619:	6a 7c                	push   $0x7c
  jmp alltraps
8010661b:	e9 fe f6 ff ff       	jmp    80105d1e <alltraps>

80106620 <vector125>:
.globl vector125
vector125:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $125
80106622:	6a 7d                	push   $0x7d
  jmp alltraps
80106624:	e9 f5 f6 ff ff       	jmp    80105d1e <alltraps>

80106629 <vector126>:
.globl vector126
vector126:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $126
8010662b:	6a 7e                	push   $0x7e
  jmp alltraps
8010662d:	e9 ec f6 ff ff       	jmp    80105d1e <alltraps>

80106632 <vector127>:
.globl vector127
vector127:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $127
80106634:	6a 7f                	push   $0x7f
  jmp alltraps
80106636:	e9 e3 f6 ff ff       	jmp    80105d1e <alltraps>

8010663b <vector128>:
.globl vector128
vector128:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $128
8010663d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106642:	e9 d7 f6 ff ff       	jmp    80105d1e <alltraps>

80106647 <vector129>:
.globl vector129
vector129:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $129
80106649:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010664e:	e9 cb f6 ff ff       	jmp    80105d1e <alltraps>

80106653 <vector130>:
.globl vector130
vector130:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $130
80106655:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010665a:	e9 bf f6 ff ff       	jmp    80105d1e <alltraps>

8010665f <vector131>:
.globl vector131
vector131:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $131
80106661:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106666:	e9 b3 f6 ff ff       	jmp    80105d1e <alltraps>

8010666b <vector132>:
.globl vector132
vector132:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $132
8010666d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106672:	e9 a7 f6 ff ff       	jmp    80105d1e <alltraps>

80106677 <vector133>:
.globl vector133
vector133:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $133
80106679:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010667e:	e9 9b f6 ff ff       	jmp    80105d1e <alltraps>

80106683 <vector134>:
.globl vector134
vector134:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $134
80106685:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010668a:	e9 8f f6 ff ff       	jmp    80105d1e <alltraps>

8010668f <vector135>:
.globl vector135
vector135:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $135
80106691:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106696:	e9 83 f6 ff ff       	jmp    80105d1e <alltraps>

8010669b <vector136>:
.globl vector136
vector136:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $136
8010669d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066a2:	e9 77 f6 ff ff       	jmp    80105d1e <alltraps>

801066a7 <vector137>:
.globl vector137
vector137:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $137
801066a9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066ae:	e9 6b f6 ff ff       	jmp    80105d1e <alltraps>

801066b3 <vector138>:
.globl vector138
vector138:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $138
801066b5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066ba:	e9 5f f6 ff ff       	jmp    80105d1e <alltraps>

801066bf <vector139>:
.globl vector139
vector139:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $139
801066c1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066c6:	e9 53 f6 ff ff       	jmp    80105d1e <alltraps>

801066cb <vector140>:
.globl vector140
vector140:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $140
801066cd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066d2:	e9 47 f6 ff ff       	jmp    80105d1e <alltraps>

801066d7 <vector141>:
.globl vector141
vector141:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $141
801066d9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066de:	e9 3b f6 ff ff       	jmp    80105d1e <alltraps>

801066e3 <vector142>:
.globl vector142
vector142:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $142
801066e5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066ea:	e9 2f f6 ff ff       	jmp    80105d1e <alltraps>

801066ef <vector143>:
.globl vector143
vector143:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $143
801066f1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066f6:	e9 23 f6 ff ff       	jmp    80105d1e <alltraps>

801066fb <vector144>:
.globl vector144
vector144:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $144
801066fd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106702:	e9 17 f6 ff ff       	jmp    80105d1e <alltraps>

80106707 <vector145>:
.globl vector145
vector145:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $145
80106709:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010670e:	e9 0b f6 ff ff       	jmp    80105d1e <alltraps>

80106713 <vector146>:
.globl vector146
vector146:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $146
80106715:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010671a:	e9 ff f5 ff ff       	jmp    80105d1e <alltraps>

8010671f <vector147>:
.globl vector147
vector147:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $147
80106721:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106726:	e9 f3 f5 ff ff       	jmp    80105d1e <alltraps>

8010672b <vector148>:
.globl vector148
vector148:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $148
8010672d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106732:	e9 e7 f5 ff ff       	jmp    80105d1e <alltraps>

80106737 <vector149>:
.globl vector149
vector149:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $149
80106739:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010673e:	e9 db f5 ff ff       	jmp    80105d1e <alltraps>

80106743 <vector150>:
.globl vector150
vector150:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $150
80106745:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010674a:	e9 cf f5 ff ff       	jmp    80105d1e <alltraps>

8010674f <vector151>:
.globl vector151
vector151:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $151
80106751:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106756:	e9 c3 f5 ff ff       	jmp    80105d1e <alltraps>

8010675b <vector152>:
.globl vector152
vector152:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $152
8010675d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106762:	e9 b7 f5 ff ff       	jmp    80105d1e <alltraps>

80106767 <vector153>:
.globl vector153
vector153:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $153
80106769:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010676e:	e9 ab f5 ff ff       	jmp    80105d1e <alltraps>

80106773 <vector154>:
.globl vector154
vector154:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $154
80106775:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010677a:	e9 9f f5 ff ff       	jmp    80105d1e <alltraps>

8010677f <vector155>:
.globl vector155
vector155:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $155
80106781:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106786:	e9 93 f5 ff ff       	jmp    80105d1e <alltraps>

8010678b <vector156>:
.globl vector156
vector156:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $156
8010678d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106792:	e9 87 f5 ff ff       	jmp    80105d1e <alltraps>

80106797 <vector157>:
.globl vector157
vector157:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $157
80106799:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010679e:	e9 7b f5 ff ff       	jmp    80105d1e <alltraps>

801067a3 <vector158>:
.globl vector158
vector158:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $158
801067a5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067aa:	e9 6f f5 ff ff       	jmp    80105d1e <alltraps>

801067af <vector159>:
.globl vector159
vector159:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $159
801067b1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067b6:	e9 63 f5 ff ff       	jmp    80105d1e <alltraps>

801067bb <vector160>:
.globl vector160
vector160:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $160
801067bd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067c2:	e9 57 f5 ff ff       	jmp    80105d1e <alltraps>

801067c7 <vector161>:
.globl vector161
vector161:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $161
801067c9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067ce:	e9 4b f5 ff ff       	jmp    80105d1e <alltraps>

801067d3 <vector162>:
.globl vector162
vector162:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $162
801067d5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067da:	e9 3f f5 ff ff       	jmp    80105d1e <alltraps>

801067df <vector163>:
.globl vector163
vector163:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $163
801067e1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067e6:	e9 33 f5 ff ff       	jmp    80105d1e <alltraps>

801067eb <vector164>:
.globl vector164
vector164:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $164
801067ed:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067f2:	e9 27 f5 ff ff       	jmp    80105d1e <alltraps>

801067f7 <vector165>:
.globl vector165
vector165:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $165
801067f9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067fe:	e9 1b f5 ff ff       	jmp    80105d1e <alltraps>

80106803 <vector166>:
.globl vector166
vector166:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $166
80106805:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010680a:	e9 0f f5 ff ff       	jmp    80105d1e <alltraps>

8010680f <vector167>:
.globl vector167
vector167:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $167
80106811:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106816:	e9 03 f5 ff ff       	jmp    80105d1e <alltraps>

8010681b <vector168>:
.globl vector168
vector168:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $168
8010681d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106822:	e9 f7 f4 ff ff       	jmp    80105d1e <alltraps>

80106827 <vector169>:
.globl vector169
vector169:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $169
80106829:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010682e:	e9 eb f4 ff ff       	jmp    80105d1e <alltraps>

80106833 <vector170>:
.globl vector170
vector170:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $170
80106835:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010683a:	e9 df f4 ff ff       	jmp    80105d1e <alltraps>

8010683f <vector171>:
.globl vector171
vector171:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $171
80106841:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106846:	e9 d3 f4 ff ff       	jmp    80105d1e <alltraps>

8010684b <vector172>:
.globl vector172
vector172:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $172
8010684d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106852:	e9 c7 f4 ff ff       	jmp    80105d1e <alltraps>

80106857 <vector173>:
.globl vector173
vector173:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $173
80106859:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010685e:	e9 bb f4 ff ff       	jmp    80105d1e <alltraps>

80106863 <vector174>:
.globl vector174
vector174:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $174
80106865:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010686a:	e9 af f4 ff ff       	jmp    80105d1e <alltraps>

8010686f <vector175>:
.globl vector175
vector175:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $175
80106871:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106876:	e9 a3 f4 ff ff       	jmp    80105d1e <alltraps>

8010687b <vector176>:
.globl vector176
vector176:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $176
8010687d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106882:	e9 97 f4 ff ff       	jmp    80105d1e <alltraps>

80106887 <vector177>:
.globl vector177
vector177:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $177
80106889:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010688e:	e9 8b f4 ff ff       	jmp    80105d1e <alltraps>

80106893 <vector178>:
.globl vector178
vector178:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $178
80106895:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010689a:	e9 7f f4 ff ff       	jmp    80105d1e <alltraps>

8010689f <vector179>:
.globl vector179
vector179:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $179
801068a1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068a6:	e9 73 f4 ff ff       	jmp    80105d1e <alltraps>

801068ab <vector180>:
.globl vector180
vector180:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $180
801068ad:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068b2:	e9 67 f4 ff ff       	jmp    80105d1e <alltraps>

801068b7 <vector181>:
.globl vector181
vector181:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $181
801068b9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068be:	e9 5b f4 ff ff       	jmp    80105d1e <alltraps>

801068c3 <vector182>:
.globl vector182
vector182:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $182
801068c5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068ca:	e9 4f f4 ff ff       	jmp    80105d1e <alltraps>

801068cf <vector183>:
.globl vector183
vector183:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $183
801068d1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068d6:	e9 43 f4 ff ff       	jmp    80105d1e <alltraps>

801068db <vector184>:
.globl vector184
vector184:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $184
801068dd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068e2:	e9 37 f4 ff ff       	jmp    80105d1e <alltraps>

801068e7 <vector185>:
.globl vector185
vector185:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $185
801068e9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068ee:	e9 2b f4 ff ff       	jmp    80105d1e <alltraps>

801068f3 <vector186>:
.globl vector186
vector186:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $186
801068f5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068fa:	e9 1f f4 ff ff       	jmp    80105d1e <alltraps>

801068ff <vector187>:
.globl vector187
vector187:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $187
80106901:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106906:	e9 13 f4 ff ff       	jmp    80105d1e <alltraps>

8010690b <vector188>:
.globl vector188
vector188:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $188
8010690d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106912:	e9 07 f4 ff ff       	jmp    80105d1e <alltraps>

80106917 <vector189>:
.globl vector189
vector189:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $189
80106919:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010691e:	e9 fb f3 ff ff       	jmp    80105d1e <alltraps>

80106923 <vector190>:
.globl vector190
vector190:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $190
80106925:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010692a:	e9 ef f3 ff ff       	jmp    80105d1e <alltraps>

8010692f <vector191>:
.globl vector191
vector191:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $191
80106931:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106936:	e9 e3 f3 ff ff       	jmp    80105d1e <alltraps>

8010693b <vector192>:
.globl vector192
vector192:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $192
8010693d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106942:	e9 d7 f3 ff ff       	jmp    80105d1e <alltraps>

80106947 <vector193>:
.globl vector193
vector193:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $193
80106949:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010694e:	e9 cb f3 ff ff       	jmp    80105d1e <alltraps>

80106953 <vector194>:
.globl vector194
vector194:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $194
80106955:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010695a:	e9 bf f3 ff ff       	jmp    80105d1e <alltraps>

8010695f <vector195>:
.globl vector195
vector195:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $195
80106961:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106966:	e9 b3 f3 ff ff       	jmp    80105d1e <alltraps>

8010696b <vector196>:
.globl vector196
vector196:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $196
8010696d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106972:	e9 a7 f3 ff ff       	jmp    80105d1e <alltraps>

80106977 <vector197>:
.globl vector197
vector197:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $197
80106979:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010697e:	e9 9b f3 ff ff       	jmp    80105d1e <alltraps>

80106983 <vector198>:
.globl vector198
vector198:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $198
80106985:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010698a:	e9 8f f3 ff ff       	jmp    80105d1e <alltraps>

8010698f <vector199>:
.globl vector199
vector199:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $199
80106991:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106996:	e9 83 f3 ff ff       	jmp    80105d1e <alltraps>

8010699b <vector200>:
.globl vector200
vector200:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $200
8010699d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069a2:	e9 77 f3 ff ff       	jmp    80105d1e <alltraps>

801069a7 <vector201>:
.globl vector201
vector201:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $201
801069a9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069ae:	e9 6b f3 ff ff       	jmp    80105d1e <alltraps>

801069b3 <vector202>:
.globl vector202
vector202:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $202
801069b5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069ba:	e9 5f f3 ff ff       	jmp    80105d1e <alltraps>

801069bf <vector203>:
.globl vector203
vector203:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $203
801069c1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069c6:	e9 53 f3 ff ff       	jmp    80105d1e <alltraps>

801069cb <vector204>:
.globl vector204
vector204:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $204
801069cd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069d2:	e9 47 f3 ff ff       	jmp    80105d1e <alltraps>

801069d7 <vector205>:
.globl vector205
vector205:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $205
801069d9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069de:	e9 3b f3 ff ff       	jmp    80105d1e <alltraps>

801069e3 <vector206>:
.globl vector206
vector206:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $206
801069e5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069ea:	e9 2f f3 ff ff       	jmp    80105d1e <alltraps>

801069ef <vector207>:
.globl vector207
vector207:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $207
801069f1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069f6:	e9 23 f3 ff ff       	jmp    80105d1e <alltraps>

801069fb <vector208>:
.globl vector208
vector208:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $208
801069fd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a02:	e9 17 f3 ff ff       	jmp    80105d1e <alltraps>

80106a07 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $209
80106a09:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a0e:	e9 0b f3 ff ff       	jmp    80105d1e <alltraps>

80106a13 <vector210>:
.globl vector210
vector210:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $210
80106a15:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a1a:	e9 ff f2 ff ff       	jmp    80105d1e <alltraps>

80106a1f <vector211>:
.globl vector211
vector211:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $211
80106a21:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a26:	e9 f3 f2 ff ff       	jmp    80105d1e <alltraps>

80106a2b <vector212>:
.globl vector212
vector212:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $212
80106a2d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a32:	e9 e7 f2 ff ff       	jmp    80105d1e <alltraps>

80106a37 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $213
80106a39:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a3e:	e9 db f2 ff ff       	jmp    80105d1e <alltraps>

80106a43 <vector214>:
.globl vector214
vector214:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $214
80106a45:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a4a:	e9 cf f2 ff ff       	jmp    80105d1e <alltraps>

80106a4f <vector215>:
.globl vector215
vector215:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $215
80106a51:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a56:	e9 c3 f2 ff ff       	jmp    80105d1e <alltraps>

80106a5b <vector216>:
.globl vector216
vector216:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $216
80106a5d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a62:	e9 b7 f2 ff ff       	jmp    80105d1e <alltraps>

80106a67 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $217
80106a69:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a6e:	e9 ab f2 ff ff       	jmp    80105d1e <alltraps>

80106a73 <vector218>:
.globl vector218
vector218:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $218
80106a75:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a7a:	e9 9f f2 ff ff       	jmp    80105d1e <alltraps>

80106a7f <vector219>:
.globl vector219
vector219:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $219
80106a81:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a86:	e9 93 f2 ff ff       	jmp    80105d1e <alltraps>

80106a8b <vector220>:
.globl vector220
vector220:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $220
80106a8d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a92:	e9 87 f2 ff ff       	jmp    80105d1e <alltraps>

80106a97 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $221
80106a99:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a9e:	e9 7b f2 ff ff       	jmp    80105d1e <alltraps>

80106aa3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $222
80106aa5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106aaa:	e9 6f f2 ff ff       	jmp    80105d1e <alltraps>

80106aaf <vector223>:
.globl vector223
vector223:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $223
80106ab1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ab6:	e9 63 f2 ff ff       	jmp    80105d1e <alltraps>

80106abb <vector224>:
.globl vector224
vector224:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $224
80106abd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ac2:	e9 57 f2 ff ff       	jmp    80105d1e <alltraps>

80106ac7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $225
80106ac9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106ace:	e9 4b f2 ff ff       	jmp    80105d1e <alltraps>

80106ad3 <vector226>:
.globl vector226
vector226:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $226
80106ad5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ada:	e9 3f f2 ff ff       	jmp    80105d1e <alltraps>

80106adf <vector227>:
.globl vector227
vector227:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $227
80106ae1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ae6:	e9 33 f2 ff ff       	jmp    80105d1e <alltraps>

80106aeb <vector228>:
.globl vector228
vector228:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $228
80106aed:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106af2:	e9 27 f2 ff ff       	jmp    80105d1e <alltraps>

80106af7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $229
80106af9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106afe:	e9 1b f2 ff ff       	jmp    80105d1e <alltraps>

80106b03 <vector230>:
.globl vector230
vector230:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $230
80106b05:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b0a:	e9 0f f2 ff ff       	jmp    80105d1e <alltraps>

80106b0f <vector231>:
.globl vector231
vector231:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $231
80106b11:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b16:	e9 03 f2 ff ff       	jmp    80105d1e <alltraps>

80106b1b <vector232>:
.globl vector232
vector232:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $232
80106b1d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b22:	e9 f7 f1 ff ff       	jmp    80105d1e <alltraps>

80106b27 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $233
80106b29:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b2e:	e9 eb f1 ff ff       	jmp    80105d1e <alltraps>

80106b33 <vector234>:
.globl vector234
vector234:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $234
80106b35:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b3a:	e9 df f1 ff ff       	jmp    80105d1e <alltraps>

80106b3f <vector235>:
.globl vector235
vector235:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $235
80106b41:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b46:	e9 d3 f1 ff ff       	jmp    80105d1e <alltraps>

80106b4b <vector236>:
.globl vector236
vector236:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $236
80106b4d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b52:	e9 c7 f1 ff ff       	jmp    80105d1e <alltraps>

80106b57 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $237
80106b59:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b5e:	e9 bb f1 ff ff       	jmp    80105d1e <alltraps>

80106b63 <vector238>:
.globl vector238
vector238:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $238
80106b65:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b6a:	e9 af f1 ff ff       	jmp    80105d1e <alltraps>

80106b6f <vector239>:
.globl vector239
vector239:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $239
80106b71:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b76:	e9 a3 f1 ff ff       	jmp    80105d1e <alltraps>

80106b7b <vector240>:
.globl vector240
vector240:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $240
80106b7d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b82:	e9 97 f1 ff ff       	jmp    80105d1e <alltraps>

80106b87 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $241
80106b89:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b8e:	e9 8b f1 ff ff       	jmp    80105d1e <alltraps>

80106b93 <vector242>:
.globl vector242
vector242:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $242
80106b95:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b9a:	e9 7f f1 ff ff       	jmp    80105d1e <alltraps>

80106b9f <vector243>:
.globl vector243
vector243:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $243
80106ba1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ba6:	e9 73 f1 ff ff       	jmp    80105d1e <alltraps>

80106bab <vector244>:
.globl vector244
vector244:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $244
80106bad:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bb2:	e9 67 f1 ff ff       	jmp    80105d1e <alltraps>

80106bb7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $245
80106bb9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bbe:	e9 5b f1 ff ff       	jmp    80105d1e <alltraps>

80106bc3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $246
80106bc5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bca:	e9 4f f1 ff ff       	jmp    80105d1e <alltraps>

80106bcf <vector247>:
.globl vector247
vector247:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $247
80106bd1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106bd6:	e9 43 f1 ff ff       	jmp    80105d1e <alltraps>

80106bdb <vector248>:
.globl vector248
vector248:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $248
80106bdd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106be2:	e9 37 f1 ff ff       	jmp    80105d1e <alltraps>

80106be7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $249
80106be9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106bee:	e9 2b f1 ff ff       	jmp    80105d1e <alltraps>

80106bf3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $250
80106bf5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106bfa:	e9 1f f1 ff ff       	jmp    80105d1e <alltraps>

80106bff <vector251>:
.globl vector251
vector251:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $251
80106c01:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c06:	e9 13 f1 ff ff       	jmp    80105d1e <alltraps>

80106c0b <vector252>:
.globl vector252
vector252:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $252
80106c0d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c12:	e9 07 f1 ff ff       	jmp    80105d1e <alltraps>

80106c17 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $253
80106c19:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c1e:	e9 fb f0 ff ff       	jmp    80105d1e <alltraps>

80106c23 <vector254>:
.globl vector254
vector254:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $254
80106c25:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c2a:	e9 ef f0 ff ff       	jmp    80105d1e <alltraps>

80106c2f <vector255>:
.globl vector255
vector255:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $255
80106c31:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c36:	e9 e3 f0 ff ff       	jmp    80105d1e <alltraps>
80106c3b:	66 90                	xchg   %ax,%ax
80106c3d:	66 90                	xchg   %ax,%ax
80106c3f:	90                   	nop

80106c40 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106c40:	f3 0f 1e fb          	endbr32 
80106c44:	55                   	push   %ebp
80106c45:	89 e5                	mov    %esp,%ebp
80106c47:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106c4a:	e8 71 d0 ff ff       	call   80103cc0 <cpuid>
  pd[0] = size-1;
80106c4f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c54:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c5a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c5e:	c7 80 38 88 20 80 ff 	movl   $0xffff,-0x7fdf77c8(%eax)
80106c65:	ff 00 00 
80106c68:	c7 80 3c 88 20 80 00 	movl   $0xcf9a00,-0x7fdf77c4(%eax)
80106c6f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c72:	c7 80 40 88 20 80 ff 	movl   $0xffff,-0x7fdf77c0(%eax)
80106c79:	ff 00 00 
80106c7c:	c7 80 44 88 20 80 00 	movl   $0xcf9200,-0x7fdf77bc(%eax)
80106c83:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c86:	c7 80 48 88 20 80 ff 	movl   $0xffff,-0x7fdf77b8(%eax)
80106c8d:	ff 00 00 
80106c90:	c7 80 4c 88 20 80 00 	movl   $0xcffa00,-0x7fdf77b4(%eax)
80106c97:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c9a:	c7 80 50 88 20 80 ff 	movl   $0xffff,-0x7fdf77b0(%eax)
80106ca1:	ff 00 00 
80106ca4:	c7 80 54 88 20 80 00 	movl   $0xcff200,-0x7fdf77ac(%eax)
80106cab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cae:	05 30 88 20 80       	add    $0x80208830,%eax
  pd[1] = (uint)p;
80106cb3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106cb7:	c1 e8 10             	shr    $0x10,%eax
80106cba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cbe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106cc1:	0f 01 10             	lgdtl  (%eax)
}
80106cc4:	c9                   	leave  
80106cc5:	c3                   	ret    
80106cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ccd:	8d 76 00             	lea    0x0(%esi),%esi

80106cd0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cd0:	f3 0f 1e fb          	endbr32 
80106cd4:	55                   	push   %ebp
80106cd5:	89 e5                	mov    %esp,%ebp
80106cd7:	57                   	push   %edi
80106cd8:	56                   	push   %esi
80106cd9:	53                   	push   %ebx
80106cda:	83 ec 0c             	sub    $0xc,%esp
80106cdd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ce0:	8b 55 08             	mov    0x8(%ebp),%edx
80106ce3:	89 fe                	mov    %edi,%esi
80106ce5:	c1 ee 16             	shr    $0x16,%esi
80106ce8:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106ceb:	8b 1e                	mov    (%esi),%ebx
80106ced:	f6 c3 01             	test   $0x1,%bl
80106cf0:	74 26                	je     80106d18 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cf2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106cf8:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106cfe:	89 f8                	mov    %edi,%eax
}
80106d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106d03:	c1 e8 0a             	shr    $0xa,%eax
80106d06:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d0b:	01 d8                	add    %ebx,%eax
}
80106d0d:	5b                   	pop    %ebx
80106d0e:	5e                   	pop    %esi
80106d0f:	5f                   	pop    %edi
80106d10:	5d                   	pop    %ebp
80106d11:	c3                   	ret    
80106d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d18:	8b 45 10             	mov    0x10(%ebp),%eax
80106d1b:	85 c0                	test   %eax,%eax
80106d1d:	74 31                	je     80106d50 <walkpgdir+0x80>
80106d1f:	e8 8c bc ff ff       	call   801029b0 <kalloc>
80106d24:	89 c3                	mov    %eax,%ebx
80106d26:	85 c0                	test   %eax,%eax
80106d28:	74 26                	je     80106d50 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
80106d2a:	83 ec 04             	sub    $0x4,%esp
80106d2d:	68 00 10 00 00       	push   $0x1000
80106d32:	6a 00                	push   $0x0
80106d34:	50                   	push   %eax
80106d35:	e8 c6 dc ff ff       	call   80104a00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d3a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d40:	83 c4 10             	add    $0x10,%esp
80106d43:	83 c8 07             	or     $0x7,%eax
80106d46:	89 06                	mov    %eax,(%esi)
80106d48:	eb b4                	jmp    80106cfe <walkpgdir+0x2e>
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106d53:	31 c0                	xor    %eax,%eax
}
80106d55:	5b                   	pop    %ebx
80106d56:	5e                   	pop    %esi
80106d57:	5f                   	pop    %edi
80106d58:	5d                   	pop    %ebp
80106d59:	c3                   	ret    
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d60 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d66:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106d6a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106d70:	89 d6                	mov    %edx,%esi
{
80106d72:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d73:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106d79:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d82:	29 f0                	sub    %esi,%eax
80106d84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d87:	eb 1f                	jmp    80106da8 <mappages+0x48>
80106d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106d90:	f6 00 01             	testb  $0x1,(%eax)
80106d93:	75 45                	jne    80106dda <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d95:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106d98:	83 cb 01             	or     $0x1,%ebx
80106d9b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106d9d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106da0:	74 2e                	je     80106dd0 <mappages+0x70>
      break;
    a += PGSIZE;
80106da2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106da8:	83 ec 04             	sub    $0x4,%esp
80106dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dae:	6a 01                	push   $0x1
80106db0:	56                   	push   %esi
80106db1:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106db4:	57                   	push   %edi
80106db5:	e8 16 ff ff ff       	call   80106cd0 <walkpgdir>
80106dba:	83 c4 10             	add    $0x10,%esp
80106dbd:	85 c0                	test   %eax,%eax
80106dbf:	75 cf                	jne    80106d90 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106dc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dc9:	5b                   	pop    %ebx
80106dca:	5e                   	pop    %esi
80106dcb:	5f                   	pop    %edi
80106dcc:	5d                   	pop    %ebp
80106dcd:	c3                   	ret    
80106dce:	66 90                	xchg   %ax,%ax
80106dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106dd3:	31 c0                	xor    %eax,%eax
}
80106dd5:	5b                   	pop    %ebx
80106dd6:	5e                   	pop    %esi
80106dd7:	5f                   	pop    %edi
80106dd8:	5d                   	pop    %ebp
80106dd9:	c3                   	ret    
      panic("remap");
80106dda:	83 ec 0c             	sub    $0xc,%esp
80106ddd:	68 d4 7e 10 80       	push   $0x80107ed4
80106de2:	e8 a9 95 ff ff       	call   80100390 <panic>
80106de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dee:	66 90                	xchg   %ax,%ax

80106df0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	89 c6                	mov    %eax,%esi
80106df7:	53                   	push   %ebx
80106df8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106dfa:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106e00:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e06:	83 ec 1c             	sub    $0x1c,%esp
80106e09:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e0c:	39 da                	cmp    %ebx,%edx
80106e0e:	73 5c                	jae    80106e6c <deallocuvm.part.0+0x7c>
80106e10:	89 d7                	mov    %edx,%edi
80106e12:	eb 0e                	jmp    80106e22 <deallocuvm.part.0+0x32>
80106e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e18:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e1e:	39 fb                	cmp    %edi,%ebx
80106e20:	76 4a                	jbe    80106e6c <deallocuvm.part.0+0x7c>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e22:	83 ec 04             	sub    $0x4,%esp
80106e25:	6a 00                	push   $0x0
80106e27:	57                   	push   %edi
80106e28:	56                   	push   %esi
80106e29:	e8 a2 fe ff ff       	call   80106cd0 <walkpgdir>
    if(!pte)
80106e2e:	83 c4 10             	add    $0x10,%esp
80106e31:	85 c0                	test   %eax,%eax
80106e33:	74 4b                	je     80106e80 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e35:	8b 08                	mov    (%eax),%ecx
80106e37:	f6 c1 01             	test   $0x1,%cl
80106e3a:	74 dc                	je     80106e18 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e3c:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106e42:	74 4c                	je     80106e90 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e44:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106e47:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80106e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106e50:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e56:	51                   	push   %ecx
80106e57:	e8 e4 b8 ff ff       	call   80102740 <kfree>
      *pte = 0;
80106e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e5f:	83 c4 10             	add    $0x10,%esp
80106e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106e68:	39 fb                	cmp    %edi,%ebx
80106e6a:	77 b6                	ja     80106e22 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106e6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e72:	5b                   	pop    %ebx
80106e73:	5e                   	pop    %esi
80106e74:	5f                   	pop    %edi
80106e75:	5d                   	pop    %ebp
80106e76:	c3                   	ret    
80106e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e7e:	66 90                	xchg   %ax,%ax
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e80:	89 fa                	mov    %edi,%edx
80106e82:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106e88:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106e8e:	eb 8e                	jmp    80106e1e <deallocuvm.part.0+0x2e>
        panic("kfree");
80106e90:	83 ec 0c             	sub    $0xc,%esp
80106e93:	68 52 78 10 80       	push   $0x80107852
80106e98:	e8 f3 94 ff ff       	call   80100390 <panic>
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ea0 <switchkvm>:
{
80106ea0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ea4:	a1 e4 b4 20 80       	mov    0x8020b4e4,%eax
80106ea9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eae:	0f 22 d8             	mov    %eax,%cr3
}
80106eb1:	c3                   	ret    
80106eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <switchuvm>:
{
80106ec0:	f3 0f 1e fb          	endbr32 
80106ec4:	55                   	push   %ebp
80106ec5:	89 e5                	mov    %esp,%ebp
80106ec7:	57                   	push   %edi
80106ec8:	56                   	push   %esi
80106ec9:	53                   	push   %ebx
80106eca:	83 ec 1c             	sub    $0x1c,%esp
80106ecd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ed0:	85 f6                	test   %esi,%esi
80106ed2:	0f 84 cb 00 00 00    	je     80106fa3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106ed8:	8b 46 08             	mov    0x8(%esi),%eax
80106edb:	85 c0                	test   %eax,%eax
80106edd:	0f 84 da 00 00 00    	je     80106fbd <switchuvm+0xfd>
  if(p->pgdir == 0)
80106ee3:	8b 46 04             	mov    0x4(%esi),%eax
80106ee6:	85 c0                	test   %eax,%eax
80106ee8:	0f 84 c2 00 00 00    	je     80106fb0 <switchuvm+0xf0>
  pushcli();
80106eee:	e8 fd d8 ff ff       	call   801047f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ef3:	e8 58 cd ff ff       	call   80103c50 <mycpu>
80106ef8:	89 c3                	mov    %eax,%ebx
80106efa:	e8 51 cd ff ff       	call   80103c50 <mycpu>
80106eff:	89 c7                	mov    %eax,%edi
80106f01:	e8 4a cd ff ff       	call   80103c50 <mycpu>
80106f06:	83 c7 08             	add    $0x8,%edi
80106f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f0c:	e8 3f cd ff ff       	call   80103c50 <mycpu>
80106f11:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f14:	ba 67 00 00 00       	mov    $0x67,%edx
80106f19:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f20:	83 c0 08             	add    $0x8,%eax
80106f23:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f2a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f2f:	83 c1 08             	add    $0x8,%ecx
80106f32:	c1 e8 18             	shr    $0x18,%eax
80106f35:	c1 e9 10             	shr    $0x10,%ecx
80106f38:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f3e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f44:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f49:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f50:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f55:	e8 f6 cc ff ff       	call   80103c50 <mycpu>
80106f5a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f61:	e8 ea cc ff ff       	call   80103c50 <mycpu>
80106f66:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f6a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f6d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f73:	e8 d8 cc ff ff       	call   80103c50 <mycpu>
80106f78:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f7b:	e8 d0 cc ff ff       	call   80103c50 <mycpu>
80106f80:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f84:	b8 28 00 00 00       	mov    $0x28,%eax
80106f89:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f8c:	8b 46 04             	mov    0x4(%esi),%eax
80106f8f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f94:	0f 22 d8             	mov    %eax,%cr3
}
80106f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f9a:	5b                   	pop    %ebx
80106f9b:	5e                   	pop    %esi
80106f9c:	5f                   	pop    %edi
80106f9d:	5d                   	pop    %ebp
  popcli();
80106f9e:	e9 9d d8 ff ff       	jmp    80104840 <popcli>
    panic("switchuvm: no process");
80106fa3:	83 ec 0c             	sub    $0xc,%esp
80106fa6:	68 da 7e 10 80       	push   $0x80107eda
80106fab:	e8 e0 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106fb0:	83 ec 0c             	sub    $0xc,%esp
80106fb3:	68 05 7f 10 80       	push   $0x80107f05
80106fb8:	e8 d3 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106fbd:	83 ec 0c             	sub    $0xc,%esp
80106fc0:	68 f0 7e 10 80       	push   $0x80107ef0
80106fc5:	e8 c6 93 ff ff       	call   80100390 <panic>
80106fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fd0 <inituvm>:
{
80106fd0:	f3 0f 1e fb          	endbr32 
80106fd4:	55                   	push   %ebp
80106fd5:	89 e5                	mov    %esp,%ebp
80106fd7:	57                   	push   %edi
80106fd8:	56                   	push   %esi
80106fd9:	53                   	push   %ebx
80106fda:	83 ec 1c             	sub    $0x1c,%esp
80106fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fe0:	8b 75 10             	mov    0x10(%ebp),%esi
80106fe3:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fe6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106fe9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fef:	77 4c                	ja     8010703d <inituvm+0x6d>
  mem = kalloc();
80106ff1:	e8 ba b9 ff ff       	call   801029b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106ff6:	83 ec 04             	sub    $0x4,%esp
80106ff9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106ffe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107000:	6a 00                	push   $0x0
80107002:	50                   	push   %eax
80107003:	e8 f8 d9 ff ff       	call   80104a00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107008:	58                   	pop    %eax
80107009:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010700f:	5a                   	pop    %edx
80107010:	6a 06                	push   $0x6
80107012:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107017:	31 d2                	xor    %edx,%edx
80107019:	50                   	push   %eax
8010701a:	89 f8                	mov    %edi,%eax
8010701c:	e8 3f fd ff ff       	call   80106d60 <mappages>
  memmove(mem, init, sz);
80107021:	83 c4 0c             	add    $0xc,%esp
80107024:	56                   	push   %esi
80107025:	ff 75 e4             	pushl  -0x1c(%ebp)
80107028:	53                   	push   %ebx
80107029:	e8 72 da ff ff       	call   80104aa0 <memmove>
  init_lru();
8010702e:	83 c4 10             	add    $0x10,%esp
}
80107031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107034:	5b                   	pop    %ebx
80107035:	5e                   	pop    %esi
80107036:	5f                   	pop    %edi
80107037:	5d                   	pop    %ebp
  init_lru();
80107038:	e9 c3 b5 ff ff       	jmp    80102600 <init_lru>
    panic("inituvm: more than a page");
8010703d:	83 ec 0c             	sub    $0xc,%esp
80107040:	68 19 7f 10 80       	push   $0x80107f19
80107045:	e8 46 93 ff ff       	call   80100390 <panic>
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107050 <loaduvm>:
{
80107050:	f3 0f 1e fb          	endbr32 
80107054:	55                   	push   %ebp
80107055:	89 e5                	mov    %esp,%ebp
80107057:	57                   	push   %edi
80107058:	56                   	push   %esi
80107059:	53                   	push   %ebx
8010705a:	83 ec 1c             	sub    $0x1c,%esp
8010705d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107060:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107063:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107068:	0f 85 99 00 00 00    	jne    80107107 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010706e:	01 f0                	add    %esi,%eax
80107070:	89 f3                	mov    %esi,%ebx
80107072:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107075:	8b 45 14             	mov    0x14(%ebp),%eax
80107078:	01 f0                	add    %esi,%eax
8010707a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010707d:	85 f6                	test   %esi,%esi
8010707f:	75 15                	jne    80107096 <loaduvm+0x46>
80107081:	eb 6d                	jmp    801070f0 <loaduvm+0xa0>
80107083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107087:	90                   	nop
80107088:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010708e:	89 f0                	mov    %esi,%eax
80107090:	29 d8                	sub    %ebx,%eax
80107092:	39 c6                	cmp    %eax,%esi
80107094:	76 5a                	jbe    801070f0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107099:	83 ec 04             	sub    $0x4,%esp
8010709c:	6a 00                	push   $0x0
8010709e:	29 d8                	sub    %ebx,%eax
801070a0:	50                   	push   %eax
801070a1:	ff 75 08             	pushl  0x8(%ebp)
801070a4:	e8 27 fc ff ff       	call   80106cd0 <walkpgdir>
801070a9:	83 c4 10             	add    $0x10,%esp
801070ac:	85 c0                	test   %eax,%eax
801070ae:	74 4a                	je     801070fa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801070b0:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801070b5:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070bf:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801070c5:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070c8:	29 d9                	sub    %ebx,%ecx
801070ca:	05 00 00 00 80       	add    $0x80000000,%eax
801070cf:	57                   	push   %edi
801070d0:	51                   	push   %ecx
801070d1:	50                   	push   %eax
801070d2:	ff 75 10             	pushl  0x10(%ebp)
801070d5:	e8 86 a9 ff ff       	call   80101a60 <readi>
801070da:	83 c4 10             	add    $0x10,%esp
801070dd:	39 f8                	cmp    %edi,%eax
801070df:	74 a7                	je     80107088 <loaduvm+0x38>
}
801070e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070e9:	5b                   	pop    %ebx
801070ea:	5e                   	pop    %esi
801070eb:	5f                   	pop    %edi
801070ec:	5d                   	pop    %ebp
801070ed:	c3                   	ret    
801070ee:	66 90                	xchg   %ax,%ax
801070f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070f3:	31 c0                	xor    %eax,%eax
}
801070f5:	5b                   	pop    %ebx
801070f6:	5e                   	pop    %esi
801070f7:	5f                   	pop    %edi
801070f8:	5d                   	pop    %ebp
801070f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	68 33 7f 10 80       	push   $0x80107f33
80107102:	e8 89 92 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107107:	83 ec 0c             	sub    $0xc,%esp
8010710a:	68 d4 7f 10 80       	push   $0x80107fd4
8010710f:	e8 7c 92 ff ff       	call   80100390 <panic>
80107114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop

80107120 <allocuvm>:
{
80107120:	f3 0f 1e fb          	endbr32 
80107124:	55                   	push   %ebp
80107125:	89 e5                	mov    %esp,%ebp
80107127:	57                   	push   %edi
80107128:	56                   	push   %esi
80107129:	53                   	push   %ebx
8010712a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010712d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107130:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107133:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107136:	85 c0                	test   %eax,%eax
80107138:	0f 88 b2 00 00 00    	js     801071f0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010713e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107141:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107144:	0f 82 96 00 00 00    	jb     801071e0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010714a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107150:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107156:	39 75 10             	cmp    %esi,0x10(%ebp)
80107159:	77 40                	ja     8010719b <allocuvm+0x7b>
8010715b:	e9 83 00 00 00       	jmp    801071e3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107160:	83 ec 04             	sub    $0x4,%esp
80107163:	68 00 10 00 00       	push   $0x1000
80107168:	6a 00                	push   $0x0
8010716a:	50                   	push   %eax
8010716b:	e8 90 d8 ff ff       	call   80104a00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107170:	58                   	pop    %eax
80107171:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107177:	5a                   	pop    %edx
80107178:	6a 06                	push   $0x6
8010717a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010717f:	89 f2                	mov    %esi,%edx
80107181:	50                   	push   %eax
80107182:	89 f8                	mov    %edi,%eax
80107184:	e8 d7 fb ff ff       	call   80106d60 <mappages>
80107189:	83 c4 10             	add    $0x10,%esp
8010718c:	85 c0                	test   %eax,%eax
8010718e:	78 78                	js     80107208 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107190:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107196:	39 75 10             	cmp    %esi,0x10(%ebp)
80107199:	76 48                	jbe    801071e3 <allocuvm+0xc3>
    mem = kalloc();
8010719b:	e8 10 b8 ff ff       	call   801029b0 <kalloc>
801071a0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071a2:	85 c0                	test   %eax,%eax
801071a4:	75 ba                	jne    80107160 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	68 51 7f 10 80       	push   $0x80107f51
801071ae:	e8 fd 94 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801071b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071b6:	83 c4 10             	add    $0x10,%esp
801071b9:	39 45 10             	cmp    %eax,0x10(%ebp)
801071bc:	74 32                	je     801071f0 <allocuvm+0xd0>
801071be:	8b 55 10             	mov    0x10(%ebp),%edx
801071c1:	89 c1                	mov    %eax,%ecx
801071c3:	89 f8                	mov    %edi,%eax
801071c5:	e8 26 fc ff ff       	call   80106df0 <deallocuvm.part.0>
      return 0;
801071ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071d7:	5b                   	pop    %ebx
801071d8:	5e                   	pop    %esi
801071d9:	5f                   	pop    %edi
801071da:	5d                   	pop    %ebp
801071db:	c3                   	ret    
801071dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801071e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801071e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e9:	5b                   	pop    %ebx
801071ea:	5e                   	pop    %esi
801071eb:	5f                   	pop    %edi
801071ec:	5d                   	pop    %ebp
801071ed:	c3                   	ret    
801071ee:	66 90                	xchg   %ax,%ax
    return 0;
801071f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071fd:	5b                   	pop    %ebx
801071fe:	5e                   	pop    %esi
801071ff:	5f                   	pop    %edi
80107200:	5d                   	pop    %ebp
80107201:	c3                   	ret    
80107202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107208:	83 ec 0c             	sub    $0xc,%esp
8010720b:	68 69 7f 10 80       	push   $0x80107f69
80107210:	e8 9b 94 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107215:	8b 45 0c             	mov    0xc(%ebp),%eax
80107218:	83 c4 10             	add    $0x10,%esp
8010721b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010721e:	74 0c                	je     8010722c <allocuvm+0x10c>
80107220:	8b 55 10             	mov    0x10(%ebp),%edx
80107223:	89 c1                	mov    %eax,%ecx
80107225:	89 f8                	mov    %edi,%eax
80107227:	e8 c4 fb ff ff       	call   80106df0 <deallocuvm.part.0>
      kfree(mem);
8010722c:	83 ec 0c             	sub    $0xc,%esp
8010722f:	53                   	push   %ebx
80107230:	e8 0b b5 ff ff       	call   80102740 <kfree>
      return 0;
80107235:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010723c:	83 c4 10             	add    $0x10,%esp
}
8010723f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107242:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
8010724a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107250 <deallocuvm>:
{
80107250:	f3 0f 1e fb          	endbr32 
80107254:	55                   	push   %ebp
80107255:	89 e5                	mov    %esp,%ebp
80107257:	8b 55 0c             	mov    0xc(%ebp),%edx
8010725a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010725d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107260:	39 d1                	cmp    %edx,%ecx
80107262:	73 0c                	jae    80107270 <deallocuvm+0x20>
}
80107264:	5d                   	pop    %ebp
80107265:	e9 86 fb ff ff       	jmp    80106df0 <deallocuvm.part.0>
8010726a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107270:	89 d0                	mov    %edx,%eax
80107272:	5d                   	pop    %ebp
80107273:	c3                   	ret    
80107274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010727f:	90                   	nop

80107280 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107280:	f3 0f 1e fb          	endbr32 
80107284:	55                   	push   %ebp
80107285:	89 e5                	mov    %esp,%ebp
80107287:	57                   	push   %edi
80107288:	56                   	push   %esi
80107289:	53                   	push   %ebx
8010728a:	83 ec 0c             	sub    $0xc,%esp
8010728d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107290:	85 f6                	test   %esi,%esi
80107292:	74 55                	je     801072e9 <freevm+0x69>
  if(newsz >= oldsz)
80107294:	31 c9                	xor    %ecx,%ecx
80107296:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010729b:	89 f0                	mov    %esi,%eax
8010729d:	89 f3                	mov    %esi,%ebx
8010729f:	e8 4c fb ff ff       	call   80106df0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072a4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072aa:	eb 0b                	jmp    801072b7 <freevm+0x37>
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072b0:	83 c3 04             	add    $0x4,%ebx
801072b3:	39 df                	cmp    %ebx,%edi
801072b5:	74 23                	je     801072da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072b7:	8b 03                	mov    (%ebx),%eax
801072b9:	a8 01                	test   $0x1,%al
801072bb:	74 f3                	je     801072b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072c2:	83 ec 0c             	sub    $0xc,%esp
801072c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072cd:	50                   	push   %eax
801072ce:	e8 6d b4 ff ff       	call   80102740 <kfree>
801072d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072d6:	39 df                	cmp    %ebx,%edi
801072d8:	75 dd                	jne    801072b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e0:	5b                   	pop    %ebx
801072e1:	5e                   	pop    %esi
801072e2:	5f                   	pop    %edi
801072e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072e4:	e9 57 b4 ff ff       	jmp    80102740 <kfree>
    panic("freevm: no pgdir");
801072e9:	83 ec 0c             	sub    $0xc,%esp
801072ec:	68 85 7f 10 80       	push   $0x80107f85
801072f1:	e8 9a 90 ff ff       	call   80100390 <panic>
801072f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072fd:	8d 76 00             	lea    0x0(%esi),%esi

80107300 <setupkvm>:
{
80107300:	f3 0f 1e fb          	endbr32 
80107304:	55                   	push   %ebp
80107305:	89 e5                	mov    %esp,%ebp
80107307:	56                   	push   %esi
80107308:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107309:	e8 a2 b6 ff ff       	call   801029b0 <kalloc>
8010730e:	89 c6                	mov    %eax,%esi
80107310:	85 c0                	test   %eax,%eax
80107312:	74 42                	je     80107356 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107314:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107317:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
8010731c:	68 00 10 00 00       	push   $0x1000
80107321:	6a 00                	push   $0x0
80107323:	50                   	push   %eax
80107324:	e8 d7 d6 ff ff       	call   80104a00 <memset>
80107329:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010732c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010732f:	83 ec 08             	sub    $0x8,%esp
80107332:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107335:	ff 73 0c             	pushl  0xc(%ebx)
80107338:	8b 13                	mov    (%ebx),%edx
8010733a:	50                   	push   %eax
8010733b:	29 c1                	sub    %eax,%ecx
8010733d:	89 f0                	mov    %esi,%eax
8010733f:	e8 1c fa ff ff       	call   80106d60 <mappages>
80107344:	83 c4 10             	add    $0x10,%esp
80107347:	85 c0                	test   %eax,%eax
80107349:	78 15                	js     80107360 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010734b:	83 c3 10             	add    $0x10,%ebx
8010734e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107354:	75 d6                	jne    8010732c <setupkvm+0x2c>
}
80107356:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107359:	89 f0                	mov    %esi,%eax
8010735b:	5b                   	pop    %ebx
8010735c:	5e                   	pop    %esi
8010735d:	5d                   	pop    %ebp
8010735e:	c3                   	ret    
8010735f:	90                   	nop
      freevm(pgdir);
80107360:	83 ec 0c             	sub    $0xc,%esp
80107363:	56                   	push   %esi
      return 0;
80107364:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107366:	e8 15 ff ff ff       	call   80107280 <freevm>
      return 0;
8010736b:	83 c4 10             	add    $0x10,%esp
}
8010736e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107371:	89 f0                	mov    %esi,%eax
80107373:	5b                   	pop    %ebx
80107374:	5e                   	pop    %esi
80107375:	5d                   	pop    %ebp
80107376:	c3                   	ret    
80107377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737e:	66 90                	xchg   %ax,%ax

80107380 <kvmalloc>:
{
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
80107387:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010738a:	e8 71 ff ff ff       	call   80107300 <setupkvm>
8010738f:	a3 e4 b4 20 80       	mov    %eax,0x8020b4e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107394:	05 00 00 00 80       	add    $0x80000000,%eax
80107399:	0f 22 d8             	mov    %eax,%cr3
}
8010739c:	c9                   	leave  
8010739d:	c3                   	ret    
8010739e:	66 90                	xchg   %ax,%ax

801073a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073a0:	f3 0f 1e fb          	endbr32 
801073a4:	55                   	push   %ebp
801073a5:	89 e5                	mov    %esp,%ebp
801073a7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073aa:	6a 00                	push   $0x0
801073ac:	ff 75 0c             	pushl  0xc(%ebp)
801073af:	ff 75 08             	pushl  0x8(%ebp)
801073b2:	e8 19 f9 ff ff       	call   80106cd0 <walkpgdir>
  if(pte == 0)
801073b7:	83 c4 10             	add    $0x10,%esp
801073ba:	85 c0                	test   %eax,%eax
801073bc:	74 05                	je     801073c3 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801073be:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073c1:	c9                   	leave  
801073c2:	c3                   	ret    
    panic("clearpteu");
801073c3:	83 ec 0c             	sub    $0xc,%esp
801073c6:	68 96 7f 10 80       	push   $0x80107f96
801073cb:	e8 c0 8f ff ff       	call   80100390 <panic>

801073d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073d0:	f3 0f 1e fb          	endbr32 
801073d4:	55                   	push   %ebp
801073d5:	89 e5                	mov    %esp,%ebp
801073d7:	57                   	push   %edi
801073d8:	56                   	push   %esi
801073d9:	53                   	push   %ebx
801073da:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801073dd:	e8 1e ff ff ff       	call   80107300 <setupkvm>
801073e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073e5:	85 c0                	test   %eax,%eax
801073e7:	0f 84 a0 00 00 00    	je     8010748d <copyuvm+0xbd>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073f0:	85 c9                	test   %ecx,%ecx
801073f2:	0f 84 95 00 00 00    	je     8010748d <copyuvm+0xbd>
801073f8:	31 f6                	xor    %esi,%esi
801073fa:	eb 46                	jmp    80107442 <copyuvm+0x72>
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107400:	83 ec 04             	sub    $0x4,%esp
80107403:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107409:	68 00 10 00 00       	push   $0x1000
8010740e:	57                   	push   %edi
8010740f:	50                   	push   %eax
80107410:	e8 8b d6 ff ff       	call   80104aa0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107415:	58                   	pop    %eax
80107416:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010741c:	5a                   	pop    %edx
8010741d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107420:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107425:	89 f2                	mov    %esi,%edx
80107427:	50                   	push   %eax
80107428:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010742b:	e8 30 f9 ff ff       	call   80106d60 <mappages>
80107430:	83 c4 10             	add    $0x10,%esp
80107433:	85 c0                	test   %eax,%eax
80107435:	78 69                	js     801074a0 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
80107437:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010743d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107440:	76 4b                	jbe    8010748d <copyuvm+0xbd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107442:	83 ec 04             	sub    $0x4,%esp
80107445:	6a 00                	push   $0x0
80107447:	56                   	push   %esi
80107448:	ff 75 08             	pushl  0x8(%ebp)
8010744b:	e8 80 f8 ff ff       	call   80106cd0 <walkpgdir>
80107450:	83 c4 10             	add    $0x10,%esp
80107453:	85 c0                	test   %eax,%eax
80107455:	74 64                	je     801074bb <copyuvm+0xeb>
    if(!(*pte & PTE_P))
80107457:	8b 00                	mov    (%eax),%eax
80107459:	a8 01                	test   $0x1,%al
8010745b:	74 51                	je     801074ae <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
8010745d:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010745f:	25 ff 0f 00 00       	and    $0xfff,%eax
80107464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107467:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010746d:	e8 3e b5 ff ff       	call   801029b0 <kalloc>
80107472:	89 c3                	mov    %eax,%ebx
80107474:	85 c0                	test   %eax,%eax
80107476:	75 88                	jne    80107400 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107478:	83 ec 0c             	sub    $0xc,%esp
8010747b:	ff 75 e0             	pushl  -0x20(%ebp)
8010747e:	e8 fd fd ff ff       	call   80107280 <freevm>
  return 0;
80107483:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010748a:	83 c4 10             	add    $0x10,%esp
}
8010748d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107490:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107493:	5b                   	pop    %ebx
80107494:	5e                   	pop    %esi
80107495:	5f                   	pop    %edi
80107496:	5d                   	pop    %ebp
80107497:	c3                   	ret    
80107498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749f:	90                   	nop
      kfree(mem);
801074a0:	83 ec 0c             	sub    $0xc,%esp
801074a3:	53                   	push   %ebx
801074a4:	e8 97 b2 ff ff       	call   80102740 <kfree>
      goto bad;
801074a9:	83 c4 10             	add    $0x10,%esp
801074ac:	eb ca                	jmp    80107478 <copyuvm+0xa8>
      panic("copyuvm: page not present");
801074ae:	83 ec 0c             	sub    $0xc,%esp
801074b1:	68 ba 7f 10 80       	push   $0x80107fba
801074b6:	e8 d5 8e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801074bb:	83 ec 0c             	sub    $0xc,%esp
801074be:	68 a0 7f 10 80       	push   $0x80107fa0
801074c3:	e8 c8 8e ff ff       	call   80100390 <panic>
801074c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074cf:	90                   	nop

801074d0 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801074d0:	f3 0f 1e fb          	endbr32 
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074da:	6a 00                	push   $0x0
801074dc:	ff 75 0c             	pushl  0xc(%ebp)
801074df:	ff 75 08             	pushl  0x8(%ebp)
801074e2:	e8 e9 f7 ff ff       	call   80106cd0 <walkpgdir>
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
801074e7:	83 c4 10             	add    $0x10,%esp
  if((*pte & PTE_P) == 0)
801074ea:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801074ec:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801074ed:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801074f4:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074f7:	05 00 00 00 80       	add    $0x80000000,%eax
801074fc:	83 fa 05             	cmp    $0x5,%edx
801074ff:	ba 00 00 00 00       	mov    $0x0,%edx
80107504:	0f 45 c2             	cmovne %edx,%eax
}
80107507:	c3                   	ret    
80107508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750f:	90                   	nop

80107510 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107510:	f3 0f 1e fb          	endbr32 
80107514:	55                   	push   %ebp
80107515:	89 e5                	mov    %esp,%ebp
80107517:	57                   	push   %edi
80107518:	56                   	push   %esi
80107519:	53                   	push   %ebx
8010751a:	83 ec 0c             	sub    $0xc,%esp
8010751d:	8b 75 14             	mov    0x14(%ebp),%esi
80107520:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107523:	85 f6                	test   %esi,%esi
80107525:	75 3c                	jne    80107563 <copyout+0x53>
80107527:	eb 67                	jmp    80107590 <copyout+0x80>
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107530:	8b 55 0c             	mov    0xc(%ebp),%edx
80107533:	89 fb                	mov    %edi,%ebx
80107535:	29 d3                	sub    %edx,%ebx
80107537:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010753d:	39 f3                	cmp    %esi,%ebx
8010753f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107542:	29 fa                	sub    %edi,%edx
80107544:	83 ec 04             	sub    $0x4,%esp
80107547:	01 c2                	add    %eax,%edx
80107549:	53                   	push   %ebx
8010754a:	ff 75 10             	pushl  0x10(%ebp)
8010754d:	52                   	push   %edx
8010754e:	e8 4d d5 ff ff       	call   80104aa0 <memmove>
    len -= n;
    buf += n;
80107553:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107556:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010755c:	83 c4 10             	add    $0x10,%esp
8010755f:	29 de                	sub    %ebx,%esi
80107561:	74 2d                	je     80107590 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107563:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107565:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107568:	89 55 0c             	mov    %edx,0xc(%ebp)
8010756b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107571:	57                   	push   %edi
80107572:	ff 75 08             	pushl  0x8(%ebp)
80107575:	e8 56 ff ff ff       	call   801074d0 <uva2ka>
    if(pa0 == 0)
8010757a:	83 c4 10             	add    $0x10,%esp
8010757d:	85 c0                	test   %eax,%eax
8010757f:	75 af                	jne    80107530 <copyout+0x20>
  }
  return 0;
}
80107581:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107584:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107589:	5b                   	pop    %ebx
8010758a:	5e                   	pop    %esi
8010758b:	5f                   	pop    %edi
8010758c:	5d                   	pop    %ebp
8010758d:	c3                   	ret    
8010758e:	66 90                	xchg   %ax,%ax
80107590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107593:	31 c0                	xor    %eax,%eax
}
80107595:	5b                   	pop    %ebx
80107596:	5e                   	pop    %esi
80107597:	5f                   	pop    %edi
80107598:	5d                   	pop    %ebp
80107599:	c3                   	ret    
