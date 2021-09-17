
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 38 10 80       	mov    $0x80103830,%eax
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
80100048:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 60 7b 10 80       	push   $0x80107b60
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 91 4b 00 00       	call   80104bf0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 0c 11 80       	mov    $0x80110cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
80100078:	0c 11 80 
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
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 7b 10 80       	push   $0x80107b67
80100097:	50                   	push   %eax
80100098:	e8 13 4a 00 00       	call   80104ab0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 0a 11 80    	cmp    $0x80110a80,%ebx
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
801000e3:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e8:	e8 83 4c 00 00       	call   80104d70 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 c9 4c 00 00       	call   80104e30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 49 00 00       	call   80104af0 <acquiresleep>
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
8010018c:	e8 0f 22 00 00       	call   801023a0 <iderw>
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
801001a3:	68 6e 7b 10 80       	push   $0x80107b6e
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
801001c2:	e8 c9 49 00 00       	call   80104b90 <holdingsleep>
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
801001d8:	e9 c3 21 00 00       	jmp    801023a0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 7f 7b 10 80       	push   $0x80107b7f
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
80100203:	e8 88 49 00 00       	call   80104b90 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 38 49 00 00       	call   80104b50 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 4c 4b 00 00       	call   80104d70 <acquire>
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
80100246:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 0d 11 80       	mov    0x80110d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 bb 4b 00 00       	jmp    80104e30 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 7b 10 80       	push   $0x80107b86
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
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 ba 4a 00 00       	call   80104d70 <acquire>
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
801002c6:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002cb:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 c0 0f 11 80       	push   $0x80110fc0
801002e5:	e8 46 44 00 00       	call   80104730 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 51 3e 00 00       	call   80104150 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 1d 4b 00 00       	call   80104e30 <release>
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
80100333:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%ecx
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
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 c6 4a 00 00       	call   80104e30 <release>
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
80100386:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
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
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 de 2c 00 00       	call   80103090 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 7b 10 80       	push   $0x80107b8d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 3d 7f 10 80 	movl   $0x80107f3d,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 2f 48 00 00       	call   80104c10 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 7b 10 80       	push   $0x80107ba1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
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
8010042a:	e8 e1 62 00 00       	call   80106710 <uartputc>
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
80100515:	e8 f6 61 00 00       	call   80106710 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ea 61 00 00       	call   80106710 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 de 61 00 00       	call   80106710 <uartputc>
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
80100561:	e8 ba 49 00 00       	call   80104f20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 05 49 00 00       	call   80104e80 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 a5 7b 10 80       	push   $0x80107ba5
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
801005c9:	0f b6 92 d0 7b 10 80 	movzbl -0x7fef8430(%edx),%edx
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
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 0c 47 00 00       	call   80104d70 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 94 47 00 00       	call   80104e30 <release>
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
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
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
8010077d:	bb b8 7b 10 80       	mov    $0x80107bb8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 ae 45 00 00       	call   80104d70 <acquire>
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
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 03 46 00 00       	call   80104e30 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 bf 7b 10 80       	push   $0x80107bbf
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
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 f4 44 00 00       	call   80104d70 <acquire>
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
801008b4:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 0f 11 80    	mov    %ecx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 0f 11 80    	mov    %bl,-0x7feef0c0(%eax)
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
80100908:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100925:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
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
8010096a:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010096f:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100985:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
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
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 5c 44 00 00       	call   80104e30 <release>
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
801009e3:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
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
801009ff:	e9 dc 3f 00 00       	jmp    801049e0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100a1b:	68 c0 0f 11 80       	push   $0x80110fc0
80100a20:	e8 cb 3e 00 00       	call   801048f0 <wakeup>
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
80100a3a:	68 c8 7b 10 80       	push   $0x80107bc8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 a7 41 00 00       	call   80104bf0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 8c 19 11 80 40 	movl   $0x80100640,0x8011198c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 88 19 11 80 90 	movl   $0x80100290,0x80111988
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 de 1a 00 00       	call   80102550 <ioapicenable>
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
80100a90:	e8 bb 36 00 00       	call   80104150 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 80 2a 00 00       	call   80103520 <begin_op>

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
80100ae3:	e8 a8 2a 00 00       	call   80103590 <end_op>
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
80100b0c:	e8 af 6d 00 00       	call   801078c0 <setupkvm>
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
80100b73:	e8 58 6b 00 00       	call   801076d0 <allocuvm>
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
80100ba9:	e8 52 6a 00 00       	call   80107600 <loaduvm>
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
80100beb:	e8 50 6c 00 00       	call   80107840 <freevm>
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
80100c21:	e8 6a 29 00 00       	call   80103590 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 99 6a 00 00       	call   801076d0 <allocuvm>
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
80100c53:	e8 08 6d 00 00       	call   80107960 <clearpteu>
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
80100ca3:	e8 d8 43 00 00       	call   80105080 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 c5 43 00 00       	call   80105080 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 04 6e 00 00       	call   80107ad0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 5a 6b 00 00       	call   80107840 <freevm>
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
80100d33:	e8 98 6d 00 00       	call   80107ad0 <copyout>
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
80100d71:	e8 ca 42 00 00       	call   80105040 <safestrcpy>
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
80100d9d:	e8 be 66 00 00       	call   80107460 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 96 6a 00 00       	call   80107840 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 d7 27 00 00       	call   80103590 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 e1 7b 10 80       	push   $0x80107be1
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
80100dea:	68 ed 7b 10 80       	push   $0x80107bed
80100def:	68 e0 0f 11 80       	push   $0x80110fe0
80100df4:	e8 f7 3d 00 00       	call   80104bf0 <initlock>
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
80100e08:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 e0 0f 11 80       	push   $0x80110fe0
80100e15:	e8 56 3f 00 00       	call   80104d70 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
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
80100e3c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e41:	e8 ea 3f 00 00       	call   80104e30 <release>
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
80100e55:	68 e0 0f 11 80       	push   $0x80110fe0
80100e5a:	e8 d1 3f 00 00       	call   80104e30 <release>
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
80100e7e:	68 e0 0f 11 80       	push   $0x80110fe0
80100e83:	e8 e8 3e 00 00       	call   80104d70 <acquire>
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
80100e9b:	68 e0 0f 11 80       	push   $0x80110fe0
80100ea0:	e8 8b 3f 00 00       	call   80104e30 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 f4 7b 10 80       	push   $0x80107bf4
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
80100ed0:	68 e0 0f 11 80       	push   $0x80110fe0
80100ed5:	e8 96 3e 00 00       	call   80104d70 <acquire>
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
80100f08:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 1b 3f 00 00       	call   80104e30 <release>

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
80100f30:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 ed 3e 00 00       	jmp    80104e30 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 d3 25 00 00       	call   80103520 <begin_op>
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
80100f62:	e9 29 26 00 00       	jmp    80103590 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 72 2d 00 00       	call   80103cf0 <pipeclose>
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
80100f8c:	68 fc 7b 10 80       	push   $0x80107bfc
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
80101065:	e9 26 2e 00 00       	jmp    80103e90 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 06 7c 10 80       	push   $0x80107c06
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
801010f1:	e8 9a 24 00 00       	call   80103590 <end_op>

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
8010111a:	e8 01 24 00 00       	call   80103520 <begin_op>
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
80101151:	e8 3a 24 00 00       	call   80103590 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 0f 7c 10 80       	push   $0x80107c0f
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
80101191:	e9 fa 2b 00 00       	jmp    80103d90 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 15 7c 10 80       	push   $0x80107c15
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
801011b9:	8b 0d e4 19 11 80    	mov    0x801119e4,%ecx
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
801011dc:	03 05 fc 19 11 80    	add    0x801119fc,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 e4 19 11 80       	mov    0x801119e4,%eax
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
80101249:	39 05 e4 19 11 80    	cmp    %eax,0x801119e4
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 1f 7c 10 80       	push   $0x80107c1f
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
8010126d:	e8 8e 24 00 00       	call   80103700 <log_write>
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
80101295:	e8 e6 3b 00 00       	call   80104e80 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 5e 24 00 00       	call   80103700 <log_write>
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
801012ca:	bb 54 1a 11 80       	mov    $0x80111a54,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 20 1a 11 80       	push   $0x80111a20
801012da:	e8 91 3a 00 00       	call   80104d70 <acquire>
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
801012fa:	81 fb 74 36 11 80    	cmp    $0x80113674,%ebx
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
8010131b:	81 fb 74 36 11 80    	cmp    $0x80113674,%ebx
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
80101342:	68 20 1a 11 80       	push   $0x80111a20
80101347:	e8 e4 3a 00 00       	call   80104e30 <release>

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
8010136d:	68 20 1a 11 80       	push   $0x80111a20
      ip->ref++;
80101372:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101375:	e8 b6 3a 00 00       	call   80104e30 <release>
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
80101387:	81 fb 74 36 11 80    	cmp    $0x80113674,%ebx
8010138d:	73 10                	jae    8010139f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101392:	85 c9                	test   %ecx,%ecx
80101394:	0f 8f 56 ff ff ff    	jg     801012f0 <iget+0x30>
8010139a:	e9 6e ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 35 7c 10 80       	push   $0x80107c35
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
80101425:	e8 d6 22 00 00       	call   80103700 <log_write>
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
8010146b:	68 45 7c 10 80       	push   $0x80107c45
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
801014a5:	e8 76 3a 00 00       	call   80104f20 <memmove>
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
801014cc:	68 e4 19 11 80       	push   $0x801119e4
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 fc 19 11 80    	add    0x801119fc,%eax
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
8010151a:	e8 e1 21 00 00       	call   80103700 <log_write>
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
80101534:	68 58 7c 10 80       	push   $0x80107c58
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 60 1a 11 80       	mov    $0x80111a60,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 6b 7c 10 80       	push   $0x80107c6b
80101555:	68 20 1a 11 80       	push   $0x80111a20
8010155a:	e8 91 36 00 00       	call   80104bf0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 72 7c 10 80       	push   $0x80107c72
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 34 35 00 00       	call   80104ab0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 80 36 11 80    	cmp    $0x80113680,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 e4 19 11 80       	push   $0x801119e4
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 fc 19 11 80    	pushl  0x801119fc
8010159d:	ff 35 f8 19 11 80    	pushl  0x801119f8
801015a3:	ff 35 f4 19 11 80    	pushl  0x801119f4
801015a9:	ff 35 f0 19 11 80    	pushl  0x801119f0
801015af:	ff 35 ec 19 11 80    	pushl  0x801119ec
801015b5:	ff 35 e8 19 11 80    	pushl  0x801119e8
801015bb:	ff 35 e4 19 11 80    	pushl  0x801119e4
801015c1:	68 10 7d 10 80       	push   $0x80107d10
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
801015f0:	83 3d ec 19 11 80 01 	cmpl   $0x1,0x801119ec
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
8010161f:	3b 3d ec 19 11 80    	cmp    0x801119ec,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 f8 19 11 80    	add    0x801119f8,%eax
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
8010165e:	e8 1d 38 00 00       	call   80104e80 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 8b 20 00 00       	call   80103700 <log_write>
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
80101693:	68 78 7c 10 80       	push   $0x80107c78
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
801016b8:	03 05 f8 19 11 80    	add    0x801119f8,%eax
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
80101705:	e8 16 38 00 00       	call   80104f20 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 ee 1f 00 00       	call   80103700 <log_write>
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
8010173e:	68 20 1a 11 80       	push   $0x80111a20
80101743:	e8 28 36 00 00       	call   80104d70 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
80101753:	e8 d8 36 00 00       	call   80104e30 <release>
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
80101786:	e8 65 33 00 00       	call   80104af0 <acquiresleep>
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
801017a9:	03 05 f8 19 11 80    	add    0x801119f8,%eax
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
801017f8:	e8 23 37 00 00       	call   80104f20 <memmove>
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
8010181d:	68 90 7c 10 80       	push   $0x80107c90
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 8a 7c 10 80       	push   $0x80107c8a
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
80101857:	e8 34 33 00 00       	call   80104b90 <holdingsleep>
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
80101873:	e9 d8 32 00 00       	jmp    80104b50 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 9f 7c 10 80       	push   $0x80107c9f
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
801018a4:	e8 47 32 00 00       	call   80104af0 <acquiresleep>
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
801018be:	e8 8d 32 00 00       	call   80104b50 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
801018ca:	e8 a1 34 00 00       	call   80104d70 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 20 1a 11 80 	movl   $0x80111a20,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 47 35 00 00       	jmp    80104e30 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 20 1a 11 80       	push   $0x80111a20
801018f8:	e8 73 34 00 00       	call   80104d70 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
80101907:	e8 24 35 00 00       	call   80104e30 <release>
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
80101b07:	e8 14 34 00 00       	call   80104f20 <memmove>
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
80101b3a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
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
80101c03:	e8 18 33 00 00       	call   80104f20 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 f0 1a 00 00       	call   80103700 <log_write>
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
80101c4a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
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
80101ca2:	e8 e9 32 00 00       	call   80104f90 <strncmp>
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
80101d05:	e8 86 32 00 00       	call   80104f90 <strncmp>
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
80101d4a:	68 b9 7c 10 80       	push   $0x80107cb9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 a7 7c 10 80       	push   $0x80107ca7
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
80101d8a:	e8 c1 23 00 00       	call   80104150 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 20 1a 11 80       	push   $0x80111a20
80101d9c:	e8 cf 2f 00 00       	call   80104d70 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
80101dac:	e8 7f 30 00 00       	call   80104e30 <release>
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
80101e17:	e8 04 31 00 00       	call   80104f20 <memmove>
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
80101ea3:	e8 78 30 00 00       	call   80104f20 <memmove>
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
80101fd5:	e8 06 30 00 00       	call   80104fe0 <strncpy>
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
80102013:	68 c8 7c 10 80       	push   $0x80107cc8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 aa 84 10 80       	push   $0x801084aa
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

void swapread(char* ptr, int blkno) // kernel virtual memory 첫 주소
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
80102075:	89 e5                	mov    %esp,%ebp
80102077:	57                   	push   %edi
80102078:	56                   	push   %esi
80102079:	53                   	push   %ebx
8010207a:	83 ec 20             	sub    $0x20,%esp
8010207d:	8b 75 08             	mov    0x8(%ebp),%esi
80102080:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;
  cprintf("swapread: ptr %p blkno %d\n", ptr, blkno);
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	68 d5 7c 10 80       	push   $0x80107cd5
8010208a:	e8 21 e6 ff ff       	call   801006b0 <cprintf>

  if ( blkno < 0 || blkno >= SWAPMAX / 8)
8010208f:	83 c4 10             	add    $0x10,%esp
80102092:	81 ff 94 30 00 00    	cmp    $0x3094,%edi
80102098:	77 5d                	ja     801020f7 <swapread+0x87>
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		nr_sectors_read++;
		bp = bread(0, blkno * 8 + SWAPBASE + i);
8010209a:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
801020a1:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
801020a7:	05 fc 01 00 00       	add    $0x1fc,%eax
801020ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020af:	90                   	nop
801020b0:	83 ec 08             	sub    $0x8,%esp
		nr_sectors_read++;
801020b3:	83 05 e0 19 11 80 01 	addl   $0x1,0x801119e0
		bp = bread(0, blkno * 8 + SWAPBASE + i);
801020ba:	57                   	push   %edi
801020bb:	83 c7 01             	add    $0x1,%edi
801020be:	6a 00                	push   $0x0
801020c0:	e8 0b e0 ff ff       	call   801000d0 <bread>
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
801020c5:	83 c4 0c             	add    $0xc,%esp
		bp = bread(0, blkno * 8 + SWAPBASE + i);
801020c8:	89 c3                	mov    %eax,%ebx
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
801020ca:	8d 40 5c             	lea    0x5c(%eax),%eax
801020cd:	68 00 02 00 00       	push   $0x200
801020d2:	50                   	push   %eax
801020d3:	56                   	push   %esi
801020d4:	81 c6 00 02 00 00    	add    $0x200,%esi
801020da:	e8 41 2e 00 00       	call   80104f20 <memmove>
		brelse(bp);
801020df:	89 1c 24             	mov    %ebx,(%esp)
801020e2:	e8 09 e1 ff ff       	call   801001f0 <brelse>
	for ( i=0; i < 8; ++i ) {
801020e7:	83 c4 10             	add    $0x10,%esp
801020ea:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801020ed:	75 c1                	jne    801020b0 <swapread+0x40>
	}
}
801020ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f2:	5b                   	pop    %ebx
801020f3:	5e                   	pop    %esi
801020f4:	5f                   	pop    %edi
801020f5:	5d                   	pop    %ebp
801020f6:	c3                   	ret    
		panic("swapread: blkno exceed range");
801020f7:	83 ec 0c             	sub    $0xc,%esp
801020fa:	68 f0 7c 10 80       	push   $0x80107cf0
801020ff:	e8 8c e2 ff ff       	call   80100390 <panic>
80102104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010210f:	90                   	nop

80102110 <swapwrite>:

void swapwrite(char* ptr, int blkno) // kernel virtual memory 첫 주소
{
80102110:	f3 0f 1e fb          	endbr32 
80102114:	55                   	push   %ebp
80102115:	89 e5                	mov    %esp,%ebp
80102117:	57                   	push   %edi
80102118:	56                   	push   %esi
80102119:	53                   	push   %ebx
8010211a:	83 ec 1c             	sub    $0x1c,%esp
8010211d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX / 8)
80102120:	81 ff 94 30 00 00    	cmp    $0x3094,%edi
80102126:	77 67                	ja     8010218f <swapwrite+0x7f>
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		nr_sectors_write++;
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80102128:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
8010212f:	8b 75 08             	mov    0x8(%ebp),%esi
80102132:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
80102138:	05 fc 01 00 00       	add    $0x1fc,%eax
8010213d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102140:	83 ec 08             	sub    $0x8,%esp
		nr_sectors_write++;
80102143:	83 05 00 1a 11 80 01 	addl   $0x1,0x80111a00
		bp = bread(0, blkno * 8 + SWAPBASE + i);
8010214a:	57                   	push   %edi
8010214b:	83 c7 01             	add    $0x1,%edi
8010214e:	6a 00                	push   $0x0
80102150:	e8 7b df ff ff       	call   801000d0 <bread>
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
80102155:	83 c4 0c             	add    $0xc,%esp
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80102158:	89 c3                	mov    %eax,%ebx
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
8010215a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010215d:	68 00 02 00 00       	push   $0x200
80102162:	56                   	push   %esi
80102163:	81 c6 00 02 00 00    	add    $0x200,%esi
80102169:	50                   	push   %eax
8010216a:	e8 b1 2d 00 00       	call   80104f20 <memmove>
		bwrite(bp);
8010216f:	89 1c 24             	mov    %ebx,(%esp)
80102172:	e8 39 e0 ff ff       	call   801001b0 <bwrite>
		brelse(bp);
80102177:	89 1c 24             	mov    %ebx,(%esp)
8010217a:	e8 71 e0 ff ff       	call   801001f0 <brelse>
	for ( i=0; i < 8; ++i ) {
8010217f:	83 c4 10             	add    $0x10,%esp
80102182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80102185:	75 b9                	jne    80102140 <swapwrite+0x30>
	}
}
80102187:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218a:	5b                   	pop    %ebx
8010218b:	5e                   	pop    %esi
8010218c:	5f                   	pop    %edi
8010218d:	5d                   	pop    %ebp
8010218e:	c3                   	ret    
		panic("swapread: blkno exceed range");
8010218f:	83 ec 0c             	sub    $0xc,%esp
80102192:	68 f0 7c 10 80       	push   $0x80107cf0
80102197:	e8 f4 e1 ff ff       	call   80100390 <panic>
8010219c:	66 90                	xchg   %ax,%ax
8010219e:	66 90                	xchg   %ax,%ax

801021a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	56                   	push   %esi
801021a4:	53                   	push   %ebx
  if(b == 0)
801021a5:	85 c0                	test   %eax,%eax
801021a7:	0f 84 af 00 00 00    	je     8010225c <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021ad:	8b 70 08             	mov    0x8(%eax),%esi
801021b0:	89 c3                	mov    %eax,%ebx
801021b2:	81 fe 9f 86 01 00    	cmp    $0x1869f,%esi
801021b8:	0f 87 91 00 00 00    	ja     8010224f <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021be:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c7:	90                   	nop
801021c8:	89 ca                	mov    %ecx,%edx
801021ca:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021cb:	83 e0 c0             	and    $0xffffffc0,%eax
801021ce:	3c 40                	cmp    $0x40,%al
801021d0:	75 f6                	jne    801021c8 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d2:	31 c0                	xor    %eax,%eax
801021d4:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021d9:	ee                   	out    %al,(%dx)
801021da:	b8 01 00 00 00       	mov    $0x1,%eax
801021df:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021e4:	ee                   	out    %al,(%dx)
801021e5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021ea:	89 f0                	mov    %esi,%eax
801021ec:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021ed:	89 f0                	mov    %esi,%eax
801021ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021f4:	c1 f8 08             	sar    $0x8,%eax
801021f7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
801021f8:	89 f0                	mov    %esi,%eax
801021fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021ff:	c1 f8 10             	sar    $0x10,%eax
80102202:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102203:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80102207:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010220c:	c1 e0 04             	shl    $0x4,%eax
8010220f:	83 e0 10             	and    $0x10,%eax
80102212:	83 c8 e0             	or     $0xffffffe0,%eax
80102215:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102216:	f6 03 04             	testb  $0x4,(%ebx)
80102219:	75 15                	jne    80102230 <idestart+0x90>
8010221b:	b8 20 00 00 00       	mov    $0x20,%eax
80102220:	89 ca                	mov    %ecx,%edx
80102222:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102223:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102226:	5b                   	pop    %ebx
80102227:	5e                   	pop    %esi
80102228:	5d                   	pop    %ebp
80102229:	c3                   	ret    
8010222a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102230:	b8 30 00 00 00       	mov    $0x30,%eax
80102235:	89 ca                	mov    %ecx,%edx
80102237:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102238:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010223d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102240:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102245:	fc                   	cld    
80102246:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102248:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010224b:	5b                   	pop    %ebx
8010224c:	5e                   	pop    %esi
8010224d:	5d                   	pop    %ebp
8010224e:	c3                   	ret    
    panic("incorrect blockno");
8010224f:	83 ec 0c             	sub    $0xc,%esp
80102252:	68 6c 7d 10 80       	push   $0x80107d6c
80102257:	e8 34 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
8010225c:	83 ec 0c             	sub    $0xc,%esp
8010225f:	68 63 7d 10 80       	push   $0x80107d63
80102264:	e8 27 e1 ff ff       	call   80100390 <panic>
80102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102270 <ideinit>:
{
80102270:	f3 0f 1e fb          	endbr32 
80102274:	55                   	push   %ebp
80102275:	89 e5                	mov    %esp,%ebp
80102277:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010227a:	68 7e 7d 10 80       	push   $0x80107d7e
8010227f:	68 80 b5 10 80       	push   $0x8010b580
80102284:	e8 67 29 00 00       	call   80104bf0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102289:	58                   	pop    %eax
8010228a:	a1 e0 9d 13 80       	mov    0x80139de0,%eax
8010228f:	5a                   	pop    %edx
80102290:	83 e8 01             	sub    $0x1,%eax
80102293:	50                   	push   %eax
80102294:	6a 0e                	push   $0xe
80102296:	e8 b5 02 00 00       	call   80102550 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010229b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010229e:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022a7:	90                   	nop
801022a8:	ec                   	in     (%dx),%al
801022a9:	83 e0 c0             	and    $0xffffffc0,%eax
801022ac:	3c 40                	cmp    $0x40,%al
801022ae:	75 f8                	jne    801022a8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022b0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022b5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ba:	ee                   	out    %al,(%dx)
801022bb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022c5:	eb 0e                	jmp    801022d5 <ideinit+0x65>
801022c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ce:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801022d0:	83 e9 01             	sub    $0x1,%ecx
801022d3:	74 0f                	je     801022e4 <ideinit+0x74>
801022d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022d6:	84 c0                	test   %al,%al
801022d8:	74 f6                	je     801022d0 <ideinit+0x60>
      havedisk1 = 1;
801022da:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801022e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ee:	ee                   	out    %al,(%dx)
}
801022ef:	c9                   	leave  
801022f0:	c3                   	ret    
801022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop

80102300 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102300:	f3 0f 1e fb          	endbr32 
80102304:	55                   	push   %ebp
80102305:	89 e5                	mov    %esp,%ebp
80102307:	57                   	push   %edi
80102308:	56                   	push   %esi
80102309:	53                   	push   %ebx
8010230a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010230d:	68 80 b5 10 80       	push   $0x8010b580
80102312:	e8 59 2a 00 00       	call   80104d70 <acquire>

  if((b = idequeue) == 0){
80102317:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 db                	test   %ebx,%ebx
80102322:	74 5f                	je     80102383 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102324:	8b 43 58             	mov    0x58(%ebx),%eax
80102327:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010232c:	8b 33                	mov    (%ebx),%esi
8010232e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102334:	75 2b                	jne    80102361 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102336:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
80102340:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102341:	89 c1                	mov    %eax,%ecx
80102343:	83 e1 c0             	and    $0xffffffc0,%ecx
80102346:	80 f9 40             	cmp    $0x40,%cl
80102349:	75 f5                	jne    80102340 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010234b:	a8 21                	test   $0x21,%al
8010234d:	75 12                	jne    80102361 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010234f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102352:	b9 80 00 00 00       	mov    $0x80,%ecx
80102357:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010235c:	fc                   	cld    
8010235d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010235f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102361:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102364:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102367:	83 ce 02             	or     $0x2,%esi
8010236a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010236c:	53                   	push   %ebx
8010236d:	e8 7e 25 00 00       	call   801048f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102372:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102377:	83 c4 10             	add    $0x10,%esp
8010237a:	85 c0                	test   %eax,%eax
8010237c:	74 05                	je     80102383 <ideintr+0x83>
    idestart(idequeue);
8010237e:	e8 1d fe ff ff       	call   801021a0 <idestart>
    release(&idelock);
80102383:	83 ec 0c             	sub    $0xc,%esp
80102386:	68 80 b5 10 80       	push   $0x8010b580
8010238b:	e8 a0 2a 00 00       	call   80104e30 <release>

  release(&idelock);
}
80102390:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102393:	5b                   	pop    %ebx
80102394:	5e                   	pop    %esi
80102395:	5f                   	pop    %edi
80102396:	5d                   	pop    %ebp
80102397:	c3                   	ret    
80102398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop

801023a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023a0:	f3 0f 1e fb          	endbr32 
801023a4:	55                   	push   %ebp
801023a5:	89 e5                	mov    %esp,%ebp
801023a7:	53                   	push   %ebx
801023a8:	83 ec 10             	sub    $0x10,%esp
801023ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801023b1:	50                   	push   %eax
801023b2:	e8 d9 27 00 00       	call   80104b90 <holdingsleep>
801023b7:	83 c4 10             	add    $0x10,%esp
801023ba:	85 c0                	test   %eax,%eax
801023bc:	0f 84 cf 00 00 00    	je     80102491 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023c2:	8b 03                	mov    (%ebx),%eax
801023c4:	83 e0 06             	and    $0x6,%eax
801023c7:	83 f8 02             	cmp    $0x2,%eax
801023ca:	0f 84 b4 00 00 00    	je     80102484 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023d0:	8b 53 04             	mov    0x4(%ebx),%edx
801023d3:	85 d2                	test   %edx,%edx
801023d5:	74 0d                	je     801023e4 <iderw+0x44>
801023d7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801023dc:	85 c0                	test   %eax,%eax
801023de:	0f 84 93 00 00 00    	je     80102477 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023e4:	83 ec 0c             	sub    $0xc,%esp
801023e7:	68 80 b5 10 80       	push   $0x8010b580
801023ec:	e8 7f 29 00 00       	call   80104d70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023f1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801023f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	85 c0                	test   %eax,%eax
80102402:	74 6c                	je     80102470 <iderw+0xd0>
80102404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102408:	89 c2                	mov    %eax,%edx
8010240a:	8b 40 58             	mov    0x58(%eax),%eax
8010240d:	85 c0                	test   %eax,%eax
8010240f:	75 f7                	jne    80102408 <iderw+0x68>
80102411:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102414:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102416:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010241c:	74 42                	je     80102460 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010241e:	8b 03                	mov    (%ebx),%eax
80102420:	83 e0 06             	and    $0x6,%eax
80102423:	83 f8 02             	cmp    $0x2,%eax
80102426:	74 23                	je     8010244b <iderw+0xab>
80102428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242f:	90                   	nop
    sleep(b, &idelock);
80102430:	83 ec 08             	sub    $0x8,%esp
80102433:	68 80 b5 10 80       	push   $0x8010b580
80102438:	53                   	push   %ebx
80102439:	e8 f2 22 00 00       	call   80104730 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010243e:	8b 03                	mov    (%ebx),%eax
80102440:	83 c4 10             	add    $0x10,%esp
80102443:	83 e0 06             	and    $0x6,%eax
80102446:	83 f8 02             	cmp    $0x2,%eax
80102449:	75 e5                	jne    80102430 <iderw+0x90>
  }


  release(&idelock);
8010244b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102455:	c9                   	leave  
  release(&idelock);
80102456:	e9 d5 29 00 00       	jmp    80104e30 <release>
8010245b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010245f:	90                   	nop
    idestart(b);
80102460:	89 d8                	mov    %ebx,%eax
80102462:	e8 39 fd ff ff       	call   801021a0 <idestart>
80102467:	eb b5                	jmp    8010241e <iderw+0x7e>
80102469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102470:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102475:	eb 9d                	jmp    80102414 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 ad 7d 10 80       	push   $0x80107dad
8010247f:	e8 0c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102484:	83 ec 0c             	sub    $0xc,%esp
80102487:	68 98 7d 10 80       	push   $0x80107d98
8010248c:	e8 ff de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102491:	83 ec 0c             	sub    $0xc,%esp
80102494:	68 82 7d 10 80       	push   $0x80107d82
80102499:	e8 f2 de ff ff       	call   80100390 <panic>
8010249e:	66 90                	xchg   %ax,%ax

801024a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024a0:	f3 0f 1e fb          	endbr32 
801024a4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024a5:	c7 05 74 36 11 80 00 	movl   $0xfec00000,0x80113674
801024ac:	00 c0 fe 
{
801024af:	89 e5                	mov    %esp,%ebp
801024b1:	56                   	push   %esi
801024b2:	53                   	push   %ebx
  ioapic->reg = reg;
801024b3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024ba:	00 00 00 
  return ioapic->data;
801024bd:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024c3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024c6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024cc:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024d2:	0f b6 15 40 98 13 80 	movzbl 0x80139840,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024d9:	c1 ee 10             	shr    $0x10,%esi
801024dc:	89 f0                	mov    %esi,%eax
801024de:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024e1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801024e4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024e7:	39 c2                	cmp    %eax,%edx
801024e9:	74 16                	je     80102501 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024eb:	83 ec 0c             	sub    $0xc,%esp
801024ee:	68 cc 7d 10 80       	push   $0x80107dcc
801024f3:	e8 b8 e1 ff ff       	call   801006b0 <cprintf>
801024f8:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
801024fe:	83 c4 10             	add    $0x10,%esp
80102501:	83 c6 21             	add    $0x21,%esi
{
80102504:	ba 10 00 00 00       	mov    $0x10,%edx
80102509:	b8 20 00 00 00       	mov    $0x20,%eax
8010250e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102510:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102512:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102514:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
8010251a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010251d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102523:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102526:	8d 5a 01             	lea    0x1(%edx),%ebx
80102529:	83 c2 02             	add    $0x2,%edx
8010252c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010252e:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
80102534:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010253b:	39 f0                	cmp    %esi,%eax
8010253d:	75 d1                	jne    80102510 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010253f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102542:	5b                   	pop    %ebx
80102543:	5e                   	pop    %esi
80102544:	5d                   	pop    %ebp
80102545:	c3                   	ret    
80102546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010254d:	8d 76 00             	lea    0x0(%esi),%esi

80102550 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102550:	f3 0f 1e fb          	endbr32 
80102554:	55                   	push   %ebp
  ioapic->reg = reg;
80102555:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
{
8010255b:	89 e5                	mov    %esp,%ebp
8010255d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102560:	8d 50 20             	lea    0x20(%eax),%edx
80102563:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102567:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102569:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010256f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102572:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102575:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102578:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010257a:	a1 74 36 11 80       	mov    0x80113674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010257f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102582:	89 50 10             	mov    %edx,0x10(%eax)
}
80102585:	5d                   	pop    %ebp
80102586:	c3                   	ret    
80102587:	66 90                	xchg   %ax,%ax
80102589:	66 90                	xchg   %ax,%ax
8010258b:	66 90                	xchg   %ax,%ax
8010258d:	66 90                	xchg   %ax,%ax
8010258f:	90                   	nop

80102590 <print_bitmap>:
// Update
// char bitmap[BITMAP_SIZE];
int bitmap[BITMAP_SIZE];


void print_bitmap(int from, int to){
80102590:	f3 0f 1e fb          	endbr32 
  for (int i = from; i <= to;i++){
    // cprintf("bitmap[%d]=%d\n", i, bitmap[i]);
  }
}
80102594:	c3                   	ret    
80102595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025a0 <change_bitmap>:

void change_bitmap(int idx, int val){
801025a0:	f3 0f 1e fb          	endbr32 
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
  // cprintf("change_bitmap: %d %d\n", idx, val);
  bitmap[idx] = val;
801025a7:	8b 45 08             	mov    0x8(%ebp),%eax
801025aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  // print_bitmap(0, idx + 3);
}
801025ad:	5d                   	pop    %ebp
  bitmap[idx] = val;
801025ae:	89 14 85 c0 36 11 80 	mov    %edx,-0x7feec940(,%eax,4)
}
801025b5:	c3                   	ret    
801025b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025bd:	8d 76 00             	lea    0x0(%esi),%esi

801025c0 <get_available_bitmap>:

int get_available_bitmap(){ // failed, return -1;
801025c0:	f3 0f 1e fb          	endbr32 
  // cprintf("get_available_bitmap: started\n");
  // print_bitmap(0,11);
  for (int i = 1; i < BITMAP_SIZE; i++){ // 0번 bitmap 은 결번
801025c4:	b8 01 00 00 00       	mov    $0x1,%eax
801025c9:	eb 0f                	jmp    801025da <get_available_bitmap+0x1a>
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop
801025d0:	83 c0 01             	add    $0x1,%eax
801025d3:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801025d8:	74 16                	je     801025f0 <get_available_bitmap+0x30>
    if(bitmap[i]==0){
801025da:	8b 14 85 c0 36 11 80 	mov    -0x7feec940(,%eax,4),%edx
801025e1:	85 d2                	test   %edx,%edx
801025e3:	75 eb                	jne    801025d0 <get_available_bitmap+0x10>
      return i;
    }
  }
  // cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
  return -1; // NOT FOUND
}
801025e5:	c3                   	ret    
801025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ed:	8d 76 00             	lea    0x0(%esi),%esi
  return -1; // NOT FOUND
801025f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801025f5:	c3                   	ret    
801025f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025fd:	8d 76 00             	lea    0x0(%esi),%esi

80102600 <is_struct_page_available>:

int is_struct_page_available(struct page* node){
80102600:	f3 0f 1e fb          	endbr32 
80102604:	55                   	push   %ebp
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
    return 1;
  return 0;
80102605:	31 c0                	xor    %eax,%eax
int is_struct_page_available(struct page* node){
80102607:	89 e5                	mov    %esp,%ebp
80102609:	8b 55 08             	mov    0x8(%ebp),%edx
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
8010260c:	8b 4a 0c             	mov    0xc(%edx),%ecx
8010260f:	85 c9                	test   %ecx,%ecx
80102611:	74 05                	je     80102618 <is_struct_page_available+0x18>
}
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    
80102615:	8d 76 00             	lea    0x0(%esi),%esi
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
80102618:	8b 4a 08             	mov    0x8(%edx),%ecx
8010261b:	85 c9                	test   %ecx,%ecx
8010261d:	75 f4                	jne    80102613 <is_struct_page_available+0x13>
8010261f:	8b 0a                	mov    (%edx),%ecx
80102621:	85 c9                	test   %ecx,%ecx
80102623:	75 ee                	jne    80102613 <is_struct_page_available+0x13>
80102625:	8b 52 04             	mov    0x4(%edx),%edx
80102628:	31 c0                	xor    %eax,%eax
}
8010262a:	5d                   	pop    %ebp
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
8010262b:	85 d2                	test   %edx,%edx
8010262d:	0f 94 c0             	sete   %al
}
80102630:	c3                   	ret    
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263f:	90                   	nop

80102640 <get_available_linked_list>:

int get_available_linked_list(){
80102640:	f3 0f 1e fb          	endbr32 
  // cprintf("get_available_linked_list called %d\n",global_i++);
  for (int i = 0; i < LRU_LENGTH;i++){
80102644:	31 c0                	xor    %eax,%eax
80102646:	eb 12                	jmp    8010265a <get_available_linked_list+0x1a>
80102648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264f:	90                   	nop
80102650:	83 c0 01             	add    $0x1,%eax
80102653:	3d 00 06 00 00       	cmp    $0x600,%eax
80102658:	74 36                	je     80102690 <get_available_linked_list+0x50>
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
8010265a:	89 c2                	mov    %eax,%edx
8010265c:	c1 e2 04             	shl    $0x4,%edx
8010265f:	8b 8a cc 36 13 80    	mov    -0x7fecc934(%edx),%ecx
80102665:	85 c9                	test   %ecx,%ecx
80102667:	75 e7                	jne    80102650 <get_available_linked_list+0x10>
80102669:	8b 8a c8 36 13 80    	mov    -0x7fecc938(%edx),%ecx
8010266f:	85 c9                	test   %ecx,%ecx
80102671:	75 dd                	jne    80102650 <get_available_linked_list+0x10>
80102673:	8b 8a c0 36 13 80    	mov    -0x7fecc940(%edx),%ecx
80102679:	85 c9                	test   %ecx,%ecx
8010267b:	75 d3                	jne    80102650 <get_available_linked_list+0x10>
8010267d:	8b 92 c4 36 13 80    	mov    -0x7fecc93c(%edx),%edx
80102683:	85 d2                	test   %edx,%edx
80102685:	75 c9                	jne    80102650 <get_available_linked_list+0x10>
    }
  }
  // cprintf("get_available_linked_list: NO AVAILABLE LINKED LIST\n");
  panic("get_available_linked_list: NO AVAILABLE LINKED LIST\n");
  return -1;
}
80102687:	c3                   	ret    
80102688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop
int get_available_linked_list(){
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	83 ec 14             	sub    $0x14,%esp
  panic("get_available_linked_list: NO AVAILABLE LINKED LIST\n");
80102696:	68 00 7e 10 80       	push   $0x80107e00
8010269b:	e8 f0 dc ff ff       	call   80100390 <panic>

801026a0 <get_linked_list>:

struct page* get_linked_list(int idx){
801026a0:	f3 0f 1e fb          	endbr32 
801026a4:	55                   	push   %ebp
801026a5:	89 e5                	mov    %esp,%ebp
  return &(linked_list[idx]);
801026a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801026aa:	5d                   	pop    %ebp
  return &(linked_list[idx]);
801026ab:	c1 e0 04             	shl    $0x4,%eax
801026ae:	05 c0 36 13 80       	add    $0x801336c0,%eax
}
801026b3:	c3                   	ret    
801026b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop

801026c0 <init_lru>:

void init_lru(){
801026c0:	f3 0f 1e fb          	endbr32 
  // cprintf("init_lru called %d\n",global_i++);
  for (int i = 0; i < LRU_LENGTH; i++){
801026c4:	b8 c0 36 13 80       	mov    $0x801336c0,%eax
801026c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    linked_list[i].next = 0;
801026d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    linked_list[i].prev = 0;
801026d6:	83 c0 10             	add    $0x10,%eax
801026d9:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    linked_list[i].pgdir = 0;
801026e0:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    linked_list[i].vaddr = 0;
801026e7:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (int i = 0; i < LRU_LENGTH; i++){
801026ee:	3d c0 96 13 80       	cmp    $0x801396c0,%eax
801026f3:	75 db                	jne    801026d0 <init_lru+0x10>
  }
  head = 0;
801026f5:	c7 05 c0 96 13 80 00 	movl   $0x0,0x801396c0
801026fc:	00 00 00 
  num_free_pages = LRU_LENGTH;
801026ff:	c7 05 54 97 13 80 00 	movl   $0x600,0x80139754
80102706:	06 00 00 
  num_lru_pages = 0;
80102709:	c7 05 c4 96 13 80 00 	movl   $0x0,0x801396c4
80102710:	00 00 00 
}
80102713:	c3                   	ret    
80102714:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010271f:	90                   	nop

80102720 <init_bitmap>:

void init_bitmap(){
80102720:	f3 0f 1e fb          	endbr32 
  for (int i = 0; i < BITMAP_SIZE;i++){
80102724:	31 c0                	xor    %eax,%eax
80102726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272d:	8d 76 00             	lea    0x0(%esi),%esi
    bitmap[i] = 0;
80102730:	c7 04 85 c0 36 11 80 	movl   $0x0,-0x7feec940(,%eax,4)
80102737:	00 00 00 00 
  for (int i = 0; i < BITMAP_SIZE;i++){
8010273b:	83 c0 01             	add    $0x1,%eax
8010273e:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80102743:	75 eb                	jne    80102730 <init_bitmap+0x10>
  }
}
80102745:	c3                   	ret    
80102746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274d:	8d 76 00             	lea    0x0(%esi),%esi

80102750 <print_linked_list>:

void print_linked_list(int sig){
80102750:	f3 0f 1e fb          	endbr32 
80102754:	55                   	push   %ebp
80102755:	89 e5                	mov    %esp,%ebp
80102757:	56                   	push   %esi
  // cprintf("print_linked_list START\n");
  if(sig!=10)
80102758:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
void print_linked_list(int sig){
8010275c:	53                   	push   %ebx
  if(sig!=10)
8010275d:	0f 85 9d 00 00 00    	jne    80102800 <print_linked_list+0xb0>
    return;
  // cprintf("print_linked_list START2\n");
  if(num_lru_pages==0)
80102763:	8b 15 c4 96 13 80    	mov    0x801396c4,%edx
80102769:	85 d2                	test   %edx,%edx
8010276b:	0f 84 8f 00 00 00    	je     80102800 <print_linked_list+0xb0>
    return;
  // cprintf("print_linked_list START3\n");
  struct page *cur = head;
  for (int i = 0; i < num_lru_pages+3;i++){
80102771:	bb c0 36 13 80       	mov    $0x801336c0,%ebx
80102776:	31 f6                	xor    %esi,%esi
80102778:	83 fa fe             	cmp    $0xfffffffe,%edx
8010277b:	7d 62                	jge    801027df <print_linked_list+0x8f>
8010277d:	e9 a6 00 00 00       	jmp    80102828 <print_linked_list+0xd8>
80102782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cur = &linked_list[i];
    // cprintf("print_linked_list START5\n");
    // cprintf(">>>linked_list[%d/%d]: cur->pgdir=%p | cur->vaddr=%p | cur->prev=%p | cur=%p | cur->next=%p\n", i, num_lru_pages, cur->pgdir, cur->vaddr, cur->prev, cur, cur->next);
    
    
    pte_t *pte = walkpgdir(cur->pgdir, (void *)cur->vaddr, 1);
80102788:	83 ec 04             	sub    $0x4,%esp
8010278b:	6a 01                	push   $0x1
8010278d:	50                   	push   %eax
8010278e:	51                   	push   %ecx
8010278f:	e8 cc 4a 00 00       	call   80107260 <walkpgdir>
    

    // cprintf("print_linked_list START6\n");
    // pte_t *pte = (pte_t*)1;
    cprintf(">>>linked_list[%d/%d]: cur->pgdir=%p | cur->vaddr=%p | *pte=%p | cur->prev=%p | cur=%p | cur->next=%p",\
80102794:	5a                   	pop    %edx
80102795:	ff 33                	pushl  (%ebx)
80102797:	53                   	push   %ebx
80102798:	ff 73 04             	pushl  0x4(%ebx)
8010279b:	ff 30                	pushl  (%eax)
8010279d:	ff 73 0c             	pushl  0xc(%ebx)
801027a0:	ff 73 08             	pushl  0x8(%ebx)
801027a3:	ff 35 c4 96 13 80    	pushl  0x801396c4
801027a9:	56                   	push   %esi
801027aa:	68 38 7e 10 80       	push   $0x80107e38
801027af:	e8 fc de ff ff       	call   801006b0 <cprintf>
            i + 1, num_lru_pages, cur->pgdir, cur->vaddr, *pte, cur->prev, cur, cur->next);
            
    if(cur == head){
801027b4:	83 c4 30             	add    $0x30,%esp
801027b7:	3b 1d c0 96 13 80    	cmp    0x801396c0,%ebx
801027bd:	74 51                	je     80102810 <print_linked_list+0xc0>
      cprintf(" ===> HEAD");
      
    }
    cprintf("\n");
801027bf:	83 ec 0c             	sub    $0xc,%esp
801027c2:	68 3d 7f 10 80       	push   $0x80107f3d
801027c7:	e8 e4 de ff ff       	call   801006b0 <cprintf>
801027cc:	8b 15 c4 96 13 80    	mov    0x801396c4,%edx
801027d2:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < num_lru_pages+3;i++){
801027d5:	8d 42 02             	lea    0x2(%edx),%eax
801027d8:	83 c3 10             	add    $0x10,%ebx
801027db:	39 f0                	cmp    %esi,%eax
801027dd:	7c 49                	jl     80102828 <print_linked_list+0xd8>
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
801027df:	8b 43 0c             	mov    0xc(%ebx),%eax
801027e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801027e5:	83 c6 01             	add    $0x1,%esi
801027e8:	85 c0                	test   %eax,%eax
801027ea:	75 9c                	jne    80102788 <print_linked_list+0x38>
801027ec:	85 c9                	test   %ecx,%ecx
801027ee:	75 98                	jne    80102788 <print_linked_list+0x38>
801027f0:	83 3b 00             	cmpl   $0x0,(%ebx)
801027f3:	75 93                	jne    80102788 <print_linked_list+0x38>
801027f5:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
801027f9:	75 8d                	jne    80102788 <print_linked_list+0x38>
801027fb:	eb d8                	jmp    801027d5 <print_linked_list+0x85>
801027fd:	8d 76 00             	lea    0x0(%esi),%esi
  }
  cprintf("print_linked_list END\n\n");
  
  return;
}
80102800:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102803:	5b                   	pop    %ebx
80102804:	5e                   	pop    %esi
80102805:	5d                   	pop    %ebp
80102806:	c3                   	ret    
80102807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010280e:	66 90                	xchg   %ax,%ax
      cprintf(" ===> HEAD");
80102810:	83 ec 0c             	sub    $0xc,%esp
80102813:	68 3f 7f 10 80       	push   $0x80107f3f
80102818:	e8 93 de ff ff       	call   801006b0 <cprintf>
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	eb 9d                	jmp    801027bf <print_linked_list+0x6f>
80102822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cprintf("print_linked_list END\n\n");
80102828:	c7 45 08 27 7f 10 80 	movl   $0x80107f27,0x8(%ebp)
}
8010282f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102832:	5b                   	pop    %ebx
80102833:	5e                   	pop    %esi
80102834:	5d                   	pop    %ebp
  cprintf("print_linked_list END\n\n");
80102835:	e9 76 de ff ff       	jmp    801006b0 <cprintf>
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <lru_append>:

// Achtung: use USER VIRTUAL ADDRESS
int lru_append(pde_t *pgdir, char* vaddr){ // head 의 next에 ll[idx], 즉 which를 pgdir, vaddr 값으로 append
80102840:	f3 0f 1e fb          	endbr32 
80102844:	55                   	push   %ebp
80102845:	89 e5                	mov    %esp,%ebp
80102847:	56                   	push   %esi
80102848:	53                   	push   %ebx
  int idx = get_available_linked_list(); // get vaddr->0
80102849:	e8 f2 fd ff ff       	call   80102640 <get_available_linked_list>
  // cprintf("lru_append: idx = %d\n", idx);
  struct page *insert = &(linked_list[idx]);

  // cprintf("lru_append: started %p %p, insert at idx=%d\n", pgdir, vaddr,idx);
  if(num_free_pages == 0){ // FULL
8010284e:	8b 1d 54 97 13 80    	mov    0x80139754,%ebx
  struct page *insert = &(linked_list[idx]);
80102854:	89 c6                	mov    %eax,%esi
80102856:	c1 e6 04             	shl    $0x4,%esi
  if(num_free_pages == 0){ // FULL
80102859:	85 db                	test   %ebx,%ebx
8010285b:	0f 84 af 00 00 00    	je     80102910 <lru_append+0xd0>
    panic("PANIC: lru_append: num_free_pages == 0");
    return -1;
  }

  insert->pgdir = pgdir;
80102861:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102864:	8d 96 c0 36 13 80    	lea    -0x7fecc940(%esi),%edx
8010286a:	89 4a 08             	mov    %ecx,0x8(%edx)
  insert->vaddr = vaddr;
8010286d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102870:	89 4a 0c             	mov    %ecx,0xc(%edx)
  if(num_lru_pages == 0){ // head is NULL -> 0 entry
80102873:	8b 0d c4 96 13 80    	mov    0x801396c4,%ecx
80102879:	85 c9                	test   %ecx,%ecx
8010287b:	74 53                	je     801028d0 <lru_append+0x90>
    */
    head = insert;
    head->prev = head;
    head->next = head;
  }
  else if(num_lru_pages == 1){
8010287d:	8b 1d c0 96 13 80    	mov    0x801396c0,%ebx
80102883:	83 f9 01             	cmp    $0x1,%ecx
80102886:	74 60                	je     801028e8 <lru_append+0xa8>
  }
  else
  {
    // cprintf("lru_append: num_lru_pages == %d\n", num_lru_pages);
    struct page *tmp;
    tmp = head->next; // save 3's address
80102888:	8b 0b                	mov    (%ebx),%ecx
    head->next = insert; // 2->2.5
8010288a:	89 13                	mov    %edx,(%ebx)
    insert->prev = head; // 2->2.5
8010288c:	8b 1d c0 96 13 80    	mov    0x801396c0,%ebx
    tmp->prev = insert; // 2.5<-3
    insert->next = tmp; // 2.5->3

    head = insert;
80102892:	89 15 c0 96 13 80    	mov    %edx,0x801396c0
    insert->prev = head; // 2->2.5
80102898:	89 5a 04             	mov    %ebx,0x4(%edx)
    tmp->prev = insert; // 2.5<-3
8010289b:	8b 1d 54 97 13 80    	mov    0x80139754,%ebx
801028a1:	89 51 04             	mov    %edx,0x4(%ecx)
    insert->next = tmp; // 2.5->3
801028a4:	89 8e c0 36 13 80    	mov    %ecx,-0x7fecc940(%esi)
    head = insert;
801028aa:	8b 0d c4 96 13 80    	mov    0x801396c4,%ecx
  }
  num_free_pages--;
801028b0:	83 eb 01             	sub    $0x1,%ebx
  num_lru_pages++;
801028b3:	83 c1 01             	add    $0x1,%ecx
  num_free_pages--;
801028b6:	89 1d 54 97 13 80    	mov    %ebx,0x80139754
  num_lru_pages++;
801028bc:	89 0d c4 96 13 80    	mov    %ecx,0x801396c4
  // if(num_lru_pages>1)
    // print_linked_list(10);
  /* cprintf("lru_append: %d/%dth: cur->pgdir=%p | cur->vaddr=%p | cur->prev=%p | cur=%p | cur->next=%p\n", \
   num_lru_pages, num_free_pages, insert->pgdir, insert->vaddr, insert->prev, insert, insert->next); */
  return idx;
}
801028c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028c5:	5b                   	pop    %ebx
801028c6:	5e                   	pop    %esi
801028c7:	5d                   	pop    %ebp
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    head = insert;
801028d0:	89 15 c0 96 13 80    	mov    %edx,0x801396c0
    head->prev = head;
801028d6:	89 52 04             	mov    %edx,0x4(%edx)
    head->next = head;
801028d9:	89 96 c0 36 13 80    	mov    %edx,-0x7fecc940(%esi)
801028df:	eb cf                	jmp    801028b0 <lru_append+0x70>
801028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    head->next = insert;
801028e8:	89 13                	mov    %edx,(%ebx)
    head->prev = insert;
801028ea:	8b 0d c0 96 13 80    	mov    0x801396c0,%ecx
801028f0:	8b 1d 54 97 13 80    	mov    0x80139754,%ebx
    head = insert;
801028f6:	89 15 c0 96 13 80    	mov    %edx,0x801396c0
    head->prev = insert;
801028fc:	89 51 04             	mov    %edx,0x4(%ecx)
    insert->prev = head;
801028ff:	89 4a 04             	mov    %ecx,0x4(%edx)
    insert->next = head;
80102902:	89 8e c0 36 13 80    	mov    %ecx,-0x7fecc940(%esi)
    head = insert;
80102908:	8b 0d c4 96 13 80    	mov    0x801396c4,%ecx
8010290e:	eb a0                	jmp    801028b0 <lru_append+0x70>
    panic("PANIC: lru_append: num_free_pages == 0");
80102910:	83 ec 0c             	sub    $0xc,%esp
80102913:	68 a0 7e 10 80       	push   $0x80107ea0
80102918:	e8 73 da ff ff       	call   80100390 <panic>
8010291d:	8d 76 00             	lea    0x0(%esi),%esi

80102920 <lru_delete>:

void lru_delete(struct page* node){ // lru head 라면 next 를 head로
80102920:	f3 0f 1e fb          	endbr32 
80102924:	55                   	push   %ebp
80102925:	89 e5                	mov    %esp,%ebp
80102927:	83 ec 08             	sub    $0x8,%esp
  // cprintf("lru_delete: %d/%dth pgdir=%p vaddr=%p prev=%p node=%p next=%p DELETE START\n", num_lru_pages, num_free_pages, node->pgdir, node->vaddr, node->prev, node, node->next);
  if (num_lru_pages == 0)
8010292a:	8b 15 c4 96 13 80    	mov    0x801396c4,%edx
void lru_delete(struct page* node){ // lru head 라면 next 를 head로
80102930:	8b 45 08             	mov    0x8(%ebp),%eax
  if (num_lru_pages == 0)
80102933:	85 d2                	test   %edx,%edx
80102935:	74 6b                	je     801029a2 <lru_delete+0x82>
  { // 0 entry
    panic("lru_delete: OOM Error\n");
    return;
  }
  if(node == head){ // 만일 delete하는 노드가 head 라면 head 를 next 로 승계
80102937:	39 05 c0 96 13 80    	cmp    %eax,0x801396c0
8010293d:	74 59                	je     80102998 <lru_delete+0x78>
    head = head->next;
  }
  if(num_lru_pages == 1){ // nokori == only head
8010293f:	83 fa 01             	cmp    $0x1,%edx
80102942:	74 44                	je     80102988 <lru_delete+0x68>
    head = 0;
  }
  else{
    node->prev->next = node->next;
80102944:	8b 48 04             	mov    0x4(%eax),%ecx
80102947:	8b 10                	mov    (%eax),%edx
80102949:	89 11                	mov    %edx,(%ecx)
    node->next->prev = node->prev;
8010294b:	8b 48 04             	mov    0x4(%eax),%ecx
8010294e:	89 4a 04             	mov    %ecx,0x4(%edx)
80102951:	8b 15 c4 96 13 80    	mov    0x801396c4,%edx
  }
  num_free_pages++;
  num_lru_pages--;
80102957:	83 ea 01             	sub    $0x1,%edx
  num_free_pages++;
8010295a:	83 05 54 97 13 80 01 	addl   $0x1,0x80139754
  num_lru_pages--;
80102961:	89 15 c4 96 13 80    	mov    %edx,0x801396c4
  node->vaddr = 0;
80102967:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  node->pgdir = 0;
8010296e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // cprintf("lru_delete: ended1\n");
  node->next = 0;
80102975:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  // cprintf("lru_delete: ended2\n");
  node->prev = 0;
8010297b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  // cprintf("lru_delete: ended3\n");
  // print_linked_list(10);
  // cprintf("lru_delete: %d/%dth %p %p %p %p deleted successfully\n", num_lru_pages,num_free_pages, node->pgdir, node->vaddr, node->prev, node->next);
  // cprintf("lru_delete: ended4\n");
  return;
}
80102982:	c9                   	leave  
80102983:	c3                   	ret    
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    head = 0;
80102988:	c7 05 c0 96 13 80 00 	movl   $0x0,0x801396c0
8010298f:	00 00 00 
80102992:	eb c3                	jmp    80102957 <lru_delete+0x37>
80102994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    head = head->next;
80102998:	8b 08                	mov    (%eax),%ecx
8010299a:	89 0d c0 96 13 80    	mov    %ecx,0x801396c0
801029a0:	eb 9d                	jmp    8010293f <lru_delete+0x1f>
    panic("lru_delete: OOM Error\n");
801029a2:	83 ec 0c             	sub    $0xc,%esp
801029a5:	68 4a 7f 10 80       	push   $0x80107f4a
801029aa:	e8 e1 d9 ff ff       	call   80100390 <panic>
801029af:	90                   	nop

801029b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v) // kmem.use_lock 해제할것
{ // kernel virtual memory
801029b0:	f3 0f 1e fb          	endbr32 
801029b4:	55                   	push   %ebp
801029b5:	89 e5                	mov    %esp,%ebp
801029b7:	57                   	push   %edi
801029b8:	56                   	push   %esi
801029b9:	53                   	push   %ebx
801029ba:	83 ec 1c             	sub    $0x1c,%esp
801029bd:	8b 45 08             	mov    0x8(%ebp),%eax
801029c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct run *r;
  // cprintf("kfree: just started, v=%p\n", v);

  if((uint)v % PGSIZE){
801029c3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801029c8:	0f 85 20 01 00 00    	jne    80102aee <kfree+0x13e>
    cprintf("PANIC1: virtual address is %p\n", v);
    panic("kfree");
  }
  if(v < end){
801029ce:	81 7d e4 88 c5 13 80 	cmpl   $0x8013c588,-0x1c(%ebp)
801029d5:	0f 82 f8 00 00 00    	jb     80102ad3 <kfree+0x123>
    cprintf("PANIC2: virtual address is %p\n", v);
    panic("kfree");
  }
  if(V2P(v) >= PHYSTOP){
801029db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801029de:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
801029e4:	81 fe ff ff 5f 00    	cmp    $0x5fffff,%esi
801029ea:	0f 87 ca 00 00 00    	ja     80102aba <kfree+0x10a>
    cprintf("PANIC3: virtual address is %p\n", v);
    panic("kfree");
  }

  struct page *cur = head;
801029f0:	8b 1d c0 96 13 80    	mov    0x801396c0,%ebx
  if(head!=0){
801029f6:	85 db                	test   %ebx,%ebx
801029f8:	74 4d                	je     80102a47 <kfree+0x97>
    // cprintf("kfree: for loop start\n");
    for (int i = 0; i < num_lru_pages; i++, cur = cur->next){
801029fa:	8b 0d c4 96 13 80    	mov    0x801396c4,%ecx
80102a00:	85 c9                	test   %ecx,%ecx
80102a02:	7e 43                	jle    80102a47 <kfree+0x97>
80102a04:	31 ff                	xor    %edi,%edi
80102a06:	eb 15                	jmp    80102a1d <kfree+0x6d>
80102a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0f:	90                   	nop
80102a10:	8b 1b                	mov    (%ebx),%ebx
80102a12:	83 c7 01             	add    $0x1,%edi
80102a15:	39 3d c4 96 13 80    	cmp    %edi,0x801396c4
80102a1b:	7e 2a                	jle    80102a47 <kfree+0x97>
      // cprintf("i=%d, num_lru_pages=%d\n", i, num_lru_pages);
      pte_t *pte = walkpgdir(cur->pgdir, cur->vaddr, 0);
80102a1d:	83 ec 04             	sub    $0x4,%esp
80102a20:	6a 00                	push   $0x0
80102a22:	ff 73 0c             	pushl  0xc(%ebx)
80102a25:	ff 73 08             	pushl  0x8(%ebx)
80102a28:	e8 33 48 00 00       	call   80107260 <walkpgdir>
      // cprintf("kfree: V2P(%p)==%p ?= PTE_ADDR(%p)==%p\n", v, V2P(v), *pte, PTE_ADDR(*pte));
      // uint pa = (((uint)pte & 0xFFFFF000)); // make physical addr from user.va
      // uint user_pa = (uint)pte >> 12;
      if (V2P(v) == PTE_ADDR(*pte)){ // if page struct's vaddr(user vaddr) points v(kern vaddr)
80102a2d:	83 c4 10             	add    $0x10,%esp
80102a30:	8b 00                	mov    (%eax),%eax
80102a32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a37:	39 c6                	cmp    %eax,%esi
80102a39:	75 d5                	jne    80102a10 <kfree+0x60>
        // cprintf("kfree: LRU list also should be deleted\n");
        lru_delete(cur);
80102a3b:	83 ec 0c             	sub    $0xc,%esp
80102a3e:	53                   	push   %ebx
80102a3f:	e8 dc fe ff ff       	call   80102920 <lru_delete>
        // cprintf("kfree: LRU list deleted completed\n");
        // pte = 0;
        break;
80102a44:	83 c4 10             	add    $0x10,%esp
      }
    }
  }
  // cprintf("kfree: for loop ended, before memset\n");
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a47:	83 ec 04             	sub    $0x4,%esp
80102a4a:	68 00 10 00 00       	push   $0x1000
80102a4f:	6a 01                	push   $0x1
80102a51:	ff 75 e4             	pushl  -0x1c(%ebp)
80102a54:	e8 27 24 00 00       	call   80104e80 <memset>

  if(kmem.use_lock)
80102a59:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
80102a5f:	83 c4 10             	add    $0x10,%esp
80102a62:	85 d2                	test   %edx,%edx
80102a64:	75 42                	jne    80102aa8 <kfree+0xf8>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102a66:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102a6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102a6e:	89 02                	mov    %eax,(%edx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102a70:	a1 b4 36 11 80       	mov    0x801136b4,%eax
  kmem.freelist = r;
80102a75:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  if(kmem.use_lock)
80102a7b:	85 c0                	test   %eax,%eax
80102a7d:	75 11                	jne    80102a90 <kfree+0xe0>
    release(&kmem.lock);
  // cprintf("kfree: successfully ended\n");
}
80102a7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a82:	5b                   	pop    %ebx
80102a83:	5e                   	pop    %esi
80102a84:	5f                   	pop    %edi
80102a85:	5d                   	pop    %ebp
80102a86:	c3                   	ret    
80102a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8e:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102a90:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9a:	5b                   	pop    %ebx
80102a9b:	5e                   	pop    %esi
80102a9c:	5f                   	pop    %edi
80102a9d:	5d                   	pop    %ebp
    release(&kmem.lock);
80102a9e:	e9 8d 23 00 00       	jmp    80104e30 <release>
80102aa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa7:	90                   	nop
    acquire(&kmem.lock);
80102aa8:	83 ec 0c             	sub    $0xc,%esp
80102aab:	68 80 36 11 80       	push   $0x80113680
80102ab0:	e8 bb 22 00 00       	call   80104d70 <acquire>
80102ab5:	83 c4 10             	add    $0x10,%esp
80102ab8:	eb ac                	jmp    80102a66 <kfree+0xb6>
    cprintf("PANIC3: virtual address is %p\n", v);
80102aba:	53                   	push   %ebx
80102abb:	53                   	push   %ebx
80102abc:	50                   	push   %eax
80102abd:	68 08 7f 10 80       	push   $0x80107f08
80102ac2:	e8 e9 db ff ff       	call   801006b0 <cprintf>
    panic("kfree");
80102ac7:	c7 04 24 61 7f 10 80 	movl   $0x80107f61,(%esp)
80102ace:	e8 bd d8 ff ff       	call   80100390 <panic>
    cprintf("PANIC2: virtual address is %p\n", v);
80102ad3:	56                   	push   %esi
80102ad4:	56                   	push   %esi
80102ad5:	ff 75 e4             	pushl  -0x1c(%ebp)
80102ad8:	68 e8 7e 10 80       	push   $0x80107ee8
80102add:	e8 ce db ff ff       	call   801006b0 <cprintf>
    panic("kfree");
80102ae2:	c7 04 24 61 7f 10 80 	movl   $0x80107f61,(%esp)
80102ae9:	e8 a2 d8 ff ff       	call   80100390 <panic>
    cprintf("PANIC1: virtual address is %p\n", v);
80102aee:	57                   	push   %edi
80102aef:	57                   	push   %edi
80102af0:	50                   	push   %eax
80102af1:	68 c8 7e 10 80       	push   $0x80107ec8
80102af6:	e8 b5 db ff ff       	call   801006b0 <cprintf>
    panic("kfree");
80102afb:	c7 04 24 61 7f 10 80 	movl   $0x80107f61,(%esp)
80102b02:	e8 89 d8 ff ff       	call   80100390 <panic>
80102b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0e:	66 90                	xchg   %ax,%ax

80102b10 <freerange>:
{
80102b10:	f3 0f 1e fb          	endbr32 
80102b14:	55                   	push   %ebp
80102b15:	89 e5                	mov    %esp,%ebp
80102b17:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b18:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b1b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102b1e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b1f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b25:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b2b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b31:	39 de                	cmp    %ebx,%esi
80102b33:	72 1f                	jb     80102b54 <freerange+0x44>
80102b35:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102b38:	83 ec 0c             	sub    $0xc,%esp
80102b3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b47:	50                   	push   %eax
80102b48:	e8 63 fe ff ff       	call   801029b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b4d:	83 c4 10             	add    $0x10,%esp
80102b50:	39 f3                	cmp    %esi,%ebx
80102b52:	76 e4                	jbe    80102b38 <freerange+0x28>
}
80102b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b57:	5b                   	pop    %ebx
80102b58:	5e                   	pop    %esi
80102b59:	5d                   	pop    %ebp
80102b5a:	c3                   	ret    
80102b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b5f:	90                   	nop

80102b60 <kinit1>:
{
80102b60:	f3 0f 1e fb          	endbr32 
80102b64:	55                   	push   %ebp
80102b65:	89 e5                	mov    %esp,%ebp
80102b67:	56                   	push   %esi
80102b68:	53                   	push   %ebx
80102b69:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102b6c:	83 ec 08             	sub    $0x8,%esp
80102b6f:	68 67 7f 10 80       	push   $0x80107f67
80102b74:	68 80 36 11 80       	push   $0x80113680
80102b79:	e8 72 20 00 00       	call   80104bf0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b81:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b84:	c7 05 b4 36 11 80 00 	movl   $0x0,0x801136b4
80102b8b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102b8e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b94:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b9a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ba0:	39 de                	cmp    %ebx,%esi
80102ba2:	72 20                	jb     80102bc4 <kinit1+0x64>
80102ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102ba8:	83 ec 0c             	sub    $0xc,%esp
80102bab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bb1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102bb7:	50                   	push   %eax
80102bb8:	e8 f3 fd ff ff       	call   801029b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bbd:	83 c4 10             	add    $0x10,%esp
80102bc0:	39 de                	cmp    %ebx,%esi
80102bc2:	73 e4                	jae    80102ba8 <kinit1+0x48>
}
80102bc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bc7:	5b                   	pop    %ebx
80102bc8:	5e                   	pop    %esi
80102bc9:	5d                   	pop    %ebp
80102bca:	c3                   	ret    
80102bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop

80102bd0 <kinit2>:
{
80102bd0:	f3 0f 1e fb          	endbr32 
80102bd4:	55                   	push   %ebp
80102bd5:	89 e5                	mov    %esp,%ebp
80102bd7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102bd8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102bdb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102bde:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102bdf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102be5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102beb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bf1:	39 de                	cmp    %ebx,%esi
80102bf3:	72 1f                	jb     80102c14 <kinit2+0x44>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102bf8:	83 ec 0c             	sub    $0xc,%esp
80102bfb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c07:	50                   	push   %eax
80102c08:	e8 a3 fd ff ff       	call   801029b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c0d:	83 c4 10             	add    $0x10,%esp
80102c10:	39 de                	cmp    %ebx,%esi
80102c12:	73 e4                	jae    80102bf8 <kinit2+0x28>
  kmem.use_lock = 1;
80102c14:	c7 05 b4 36 11 80 01 	movl   $0x1,0x801136b4
80102c1b:	00 00 00 
}
80102c1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c21:	5b                   	pop    %ebx
80102c22:	5e                   	pop    %esi
80102c23:	5d                   	pop    %ebp
80102c24:	c3                   	ret    
80102c25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c30 <clock>:
  // cprintf("SWAPOUT ENDED SUCCESSFULLY, returning %p\n", *kvaddr);
  return kvaddr;
}

// my code
struct page* clock(){ // only select victim, not killing yet
80102c30:	f3 0f 1e fb          	endbr32 
80102c34:	55                   	push   %ebp
80102c35:	89 e5                	mov    %esp,%ebp
80102c37:	83 ec 08             	sub    $0x8,%esp
  int finished = 0;
  struct page *ret;
  for (; !finished; head = head->prev)
  {
    if (!(head->vaddr)){
80102c3a:	a1 c0 96 13 80       	mov    0x801396c0,%eax
80102c3f:	8b 50 0c             	mov    0xc(%eax),%edx
80102c42:	85 d2                	test   %edx,%edx
80102c44:	74 53                	je     80102c99 <clock+0x69>
80102c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4d:	8d 76 00             	lea    0x0(%esi),%esi
      panic("clock: invalid head");
    }
    // cprintf("clock: scanning node %p %p\n", head->pgdir, head->vaddr);
    pte_t *cur_pte = walkpgdir(head->pgdir, head->vaddr, 1);
80102c50:	83 ec 04             	sub    $0x4,%esp
80102c53:	6a 01                	push   $0x1
80102c55:	52                   	push   %edx
80102c56:	ff 70 08             	pushl  0x8(%eax)
80102c59:	e8 02 46 00 00       	call   80107260 <walkpgdir>
    int pte_a = (*cur_pte & PTE_A);
    if (pte_a){ // if PTE_A == 1
80102c5e:	83 c4 10             	add    $0x10,%esp
    int pte_a = (*cur_pte & PTE_A);
80102c61:	8b 10                	mov    (%eax),%edx
    if (pte_a){ // if PTE_A == 1
80102c63:	f6 c2 20             	test   $0x20,%dl
80102c66:	75 18                	jne    80102c80 <clock+0x50>
    }
    else
    {
      // if PTE_A == 0, swap out this page => do at swapout
      finished = 1;
      ret = head;
80102c68:	a1 c0 96 13 80       	mov    0x801396c0,%eax
  for (; !finished; head = head->prev)
80102c6d:	8b 50 04             	mov    0x4(%eax),%edx
80102c70:	89 15 c0 96 13 80    	mov    %edx,0x801396c0
    }
  }
  // cprintf("clock: finally ret %p != head %p\n", ret, head);
  // cprintf("clock ended successfully\n");
  return ret;
80102c76:	c9                   	leave  
80102c77:	c3                   	ret    
80102c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c7f:	90                   	nop
      *cur_pte &= ~(PTE_A);
80102c80:	83 e2 df             	and    $0xffffffdf,%edx
80102c83:	89 10                	mov    %edx,(%eax)
  for (; !finished; head = head->prev)
80102c85:	a1 c0 96 13 80       	mov    0x801396c0,%eax
80102c8a:	8b 40 04             	mov    0x4(%eax),%eax
80102c8d:	a3 c0 96 13 80       	mov    %eax,0x801396c0
    if (!(head->vaddr)){
80102c92:	8b 50 0c             	mov    0xc(%eax),%edx
80102c95:	85 d2                	test   %edx,%edx
80102c97:	75 b7                	jne    80102c50 <clock+0x20>
      panic("clock: invalid head");
80102c99:	83 ec 0c             	sub    $0xc,%esp
80102c9c:	68 6c 7f 10 80       	push   $0x80107f6c
80102ca1:	e8 ea d6 ff ff       	call   80100390 <panic>
80102ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cad:	8d 76 00             	lea    0x0(%esi),%esi

80102cb0 <swapout>:
char* swapout(){
80102cb0:	f3 0f 1e fb          	endbr32 
80102cb4:	55                   	push   %ebp
80102cb5:	89 e5                	mov    %esp,%ebp
80102cb7:	57                   	push   %edi
80102cb8:	56                   	push   %esi
80102cb9:	53                   	push   %ebx
80102cba:	83 ec 1c             	sub    $0x1c,%esp
  if (num_free_pages == 0)
80102cbd:	a1 54 97 13 80       	mov    0x80139754,%eax
80102cc2:	85 c0                	test   %eax,%eax
80102cc4:	0f 84 47 01 00 00    	je     80102e11 <swapout+0x161>
  for (int i = 1; i < BITMAP_SIZE; i++){ // 0번 bitmap 은 결번
80102cca:	bf 01 00 00 00       	mov    $0x1,%edi
80102ccf:	eb 16                	jmp    80102ce7 <swapout+0x37>
80102cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cd8:	83 c7 01             	add    $0x1,%edi
80102cdb:	81 ff ff 7f 00 00    	cmp    $0x7fff,%edi
80102ce1:	0f 84 19 01 00 00    	je     80102e00 <swapout+0x150>
    if(bitmap[i]==0){
80102ce7:	8b 04 bd c0 36 11 80 	mov    -0x7feec940(,%edi,4),%eax
80102cee:	85 c0                	test   %eax,%eax
80102cf0:	75 e6                	jne    80102cd8 <swapout+0x28>
80102cf2:	89 f8                	mov    %edi,%eax
80102cf4:	c1 e0 0c             	shl    $0xc,%eax
80102cf7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  struct page *victim = clock();
80102cfa:	e8 31 ff ff ff       	call   80102c30 <clock>
  pte_t *pte = walkpgdir(victim->pgdir, uvaddr, 1);
80102cff:	83 ec 04             	sub    $0x4,%esp
  struct page *victim = clock();
80102d02:	89 c1                	mov    %eax,%ecx
  pde_t *pgdir = victim->pgdir;
80102d04:	8b 40 08             	mov    0x8(%eax),%eax
  pte_t *pte = walkpgdir(victim->pgdir, uvaddr, 1);
80102d07:	6a 01                	push   $0x1
80102d09:	ff 71 0c             	pushl  0xc(%ecx)
80102d0c:	50                   	push   %eax
80102d0d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  pde_t *pgdir = victim->pgdir;
80102d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte_t *pte = walkpgdir(victim->pgdir, uvaddr, 1);
80102d13:	e8 48 45 00 00       	call   80107260 <walkpgdir>
  if(kmem.use_lock)
80102d18:	83 c4 10             	add    $0x10,%esp
80102d1b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  char *kvaddr = P2V(PTE_ADDR(*pte));
80102d1e:	8b 18                	mov    (%eax),%ebx
  pte_t *pte = walkpgdir(victim->pgdir, uvaddr, 1);
80102d20:	89 c6                	mov    %eax,%esi
  if(kmem.use_lock)
80102d22:	a1 b4 36 11 80       	mov    0x801136b4,%eax
  char *kvaddr = P2V(PTE_ADDR(*pte));
80102d27:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102d2d:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  if(kmem.use_lock)
80102d33:	85 c0                	test   %eax,%eax
80102d35:	75 59                	jne    80102d90 <swapout+0xe0>
  swapwrite((char *)victim, block_number); // 누구를 어디 적었다 이거 기록해놔야할것같은데?
80102d37:	83 ec 08             	sub    $0x8,%esp
80102d3a:	57                   	push   %edi
80102d3b:	51                   	push   %ecx
80102d3c:	e8 cf f3 ff ff       	call   80102110 <swapwrite>
  if(kmem.use_lock)
80102d41:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
80102d47:	83 c4 10             	add    $0x10,%esp
80102d4a:	85 c9                	test   %ecx,%ecx
80102d4c:	75 72                	jne    80102dc0 <swapout+0x110>
  bitmap[idx] = val;
80102d4e:	c7 04 bd c0 36 11 80 	movl   $0x1,-0x7feec940(,%edi,4)
80102d55:	01 00 00 00 
  kfree(kvaddr);     // free victim page
80102d59:	83 ec 0c             	sub    $0xc,%esp
80102d5c:	53                   	push   %ebx
80102d5d:	e8 4e fc ff ff       	call   801029b0 <kfree>
  if(kmem.use_lock)
80102d62:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102d67:	83 c4 10             	add    $0x10,%esp
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 3a                	jne    80102da8 <swapout+0xf8>
  *pte = (block_number << 12) | ((*pte) & 0x00000FFE); // PFN set to block_number, clear the PTE_P
80102d6e:	8b 06                	mov    (%esi),%eax
  lcr3(V2P(pgdir)); // flush TLB
80102d70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  *pte = (block_number << 12) | ((*pte) & 0x00000FFE); // PFN set to block_number, clear the PTE_P
80102d73:	25 fe 0f 00 00       	and    $0xffe,%eax
80102d78:	0b 45 e0             	or     -0x20(%ebp),%eax
  lcr3(V2P(pgdir)); // flush TLB
80102d7b:	81 c7 00 00 00 80    	add    $0x80000000,%edi
  *pte = (block_number << 12) | ((*pte) & 0x00000FFE); // PFN set to block_number, clear the PTE_P
80102d81:	89 06                	mov    %eax,(%esi)
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80102d83:	0f 22 df             	mov    %edi,%cr3
}
80102d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d89:	89 d8                	mov    %ebx,%eax
80102d8b:	5b                   	pop    %ebx
80102d8c:	5e                   	pop    %esi
80102d8d:	5f                   	pop    %edi
80102d8e:	5d                   	pop    %ebp
80102d8f:	c3                   	ret    
    release(&kmem.lock);
80102d90:	83 ec 0c             	sub    $0xc,%esp
80102d93:	68 80 36 11 80       	push   $0x80113680
80102d98:	e8 93 20 00 00       	call   80104e30 <release>
80102d9d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80102da0:	83 c4 10             	add    $0x10,%esp
80102da3:	eb 92                	jmp    80102d37 <swapout+0x87>
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102da8:	83 ec 0c             	sub    $0xc,%esp
80102dab:	68 80 36 11 80       	push   $0x80113680
80102db0:	e8 bb 1f 00 00       	call   80104d70 <acquire>
80102db5:	83 c4 10             	add    $0x10,%esp
80102db8:	eb b4                	jmp    80102d6e <swapout+0xbe>
80102dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102dc0:	83 ec 0c             	sub    $0xc,%esp
80102dc3:	68 80 36 11 80       	push   $0x80113680
80102dc8:	e8 a3 1f 00 00       	call   80104d70 <acquire>
  if(kmem.use_lock)
80102dcd:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
80102dd3:	83 c4 10             	add    $0x10,%esp
  bitmap[idx] = val;
80102dd6:	c7 04 bd c0 36 11 80 	movl   $0x1,-0x7feec940(,%edi,4)
80102ddd:	01 00 00 00 
  if(kmem.use_lock)
80102de1:	85 d2                	test   %edx,%edx
80102de3:	0f 84 70 ff ff ff    	je     80102d59 <swapout+0xa9>
    release(&kmem.lock);
80102de9:	83 ec 0c             	sub    $0xc,%esp
80102dec:	68 80 36 11 80       	push   $0x80113680
80102df1:	e8 3a 20 00 00       	call   80104e30 <release>
80102df6:	83 c4 10             	add    $0x10,%esp
80102df9:	e9 5b ff ff ff       	jmp    80102d59 <swapout+0xa9>
80102dfe:	66 90                	xchg   %ax,%ax
80102e00:	c7 45 e0 00 f0 ff ff 	movl   $0xfffff000,-0x20(%ebp)
  return -1; // NOT FOUND
80102e07:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80102e0c:	e9 e9 fe ff ff       	jmp    80102cfa <swapout+0x4a>
    panic("OOM Error");
80102e11:	83 ec 0c             	sub    $0xc,%esp
80102e14:	68 80 7f 10 80       	push   $0x80107f80
80102e19:	e8 72 d5 ff ff       	call   80100390 <panic>
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <kalloc>:
{
80102e20:	f3 0f 1e fb          	endbr32 
80102e24:	55                   	push   %ebp
80102e25:	89 e5                	mov    %esp,%ebp
80102e27:	83 ec 18             	sub    $0x18,%esp
  if(kmem.use_lock)
80102e2a:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
80102e30:	85 c9                	test   %ecx,%ecx
80102e32:	75 3c                	jne    80102e70 <kalloc+0x50>
  r = kmem.freelist;
80102e34:	a1 b8 36 11 80       	mov    0x801136b8,%eax
  if(r){
80102e39:	85 c0                	test   %eax,%eax
80102e3b:	74 4c                	je     80102e89 <kalloc+0x69>
    kmem.freelist = r->next;
80102e3d:	8b 10                	mov    (%eax),%edx
80102e3f:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  if(kmem.use_lock)
80102e45:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
80102e4b:	85 d2                	test   %edx,%edx
80102e4d:	75 09                	jne    80102e58 <kalloc+0x38>
}
80102e4f:	c9                   	leave  
80102e50:	c3                   	ret    
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102e58:	83 ec 0c             	sub    $0xc,%esp
80102e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102e5e:	68 80 36 11 80       	push   $0x80113680
80102e63:	e8 c8 1f 00 00       	call   80104e30 <release>
80102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e6b:	83 c4 10             	add    $0x10,%esp
}
80102e6e:	c9                   	leave  
80102e6f:	c3                   	ret    
    acquire(&kmem.lock);
80102e70:	83 ec 0c             	sub    $0xc,%esp
80102e73:	68 80 36 11 80       	push   $0x80113680
80102e78:	e8 f3 1e 00 00       	call   80104d70 <acquire>
  r = kmem.freelist;
80102e7d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
    acquire(&kmem.lock);
80102e82:	83 c4 10             	add    $0x10,%esp
  if(r){
80102e85:	85 c0                	test   %eax,%eax
80102e87:	75 b4                	jne    80102e3d <kalloc+0x1d>
    r = (struct run*)swapout();
80102e89:	e8 22 fe ff ff       	call   80102cb0 <swapout>
80102e8e:	eb b5                	jmp    80102e45 <kalloc+0x25>

80102e90 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e90:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e94:	ba 64 00 00 00       	mov    $0x64,%edx
80102e99:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102e9a:	a8 01                	test   $0x1,%al
80102e9c:	0f 84 be 00 00 00    	je     80102f60 <kbdgetc+0xd0>
{
80102ea2:	55                   	push   %ebp
80102ea3:	ba 60 00 00 00       	mov    $0x60,%edx
80102ea8:	89 e5                	mov    %esp,%ebp
80102eaa:	53                   	push   %ebx
80102eab:	ec                   	in     (%dx),%al
  return data;
80102eac:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102eb2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102eb5:	3c e0                	cmp    $0xe0,%al
80102eb7:	74 57                	je     80102f10 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102eb9:	89 d9                	mov    %ebx,%ecx
80102ebb:	83 e1 40             	and    $0x40,%ecx
80102ebe:	84 c0                	test   %al,%al
80102ec0:	78 5e                	js     80102f20 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ec2:	85 c9                	test   %ecx,%ecx
80102ec4:	74 09                	je     80102ecf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ec6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102ec9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102ecc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102ecf:	0f b6 8a c0 80 10 80 	movzbl -0x7fef7f40(%edx),%ecx
  shift ^= togglecode[data];
80102ed6:	0f b6 82 c0 7f 10 80 	movzbl -0x7fef8040(%edx),%eax
  shift |= shiftcode[data];
80102edd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102edf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ee1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102ee3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102ee9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102eec:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102eef:	8b 04 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%eax
80102ef6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102efa:	74 0b                	je     80102f07 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102efc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102eff:	83 fa 19             	cmp    $0x19,%edx
80102f02:	77 44                	ja     80102f48 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102f04:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102f07:	5b                   	pop    %ebx
80102f08:	5d                   	pop    %ebp
80102f09:	c3                   	ret    
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102f10:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102f13:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102f15:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102f1b:	5b                   	pop    %ebx
80102f1c:	5d                   	pop    %ebp
80102f1d:	c3                   	ret    
80102f1e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102f20:	83 e0 7f             	and    $0x7f,%eax
80102f23:	85 c9                	test   %ecx,%ecx
80102f25:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102f28:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102f2a:	0f b6 8a c0 80 10 80 	movzbl -0x7fef7f40(%edx),%ecx
80102f31:	83 c9 40             	or     $0x40,%ecx
80102f34:	0f b6 c9             	movzbl %cl,%ecx
80102f37:	f7 d1                	not    %ecx
80102f39:	21 d9                	and    %ebx,%ecx
}
80102f3b:	5b                   	pop    %ebx
80102f3c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102f3d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102f43:	c3                   	ret    
80102f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102f48:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102f4b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102f4e:	5b                   	pop    %ebx
80102f4f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102f50:	83 f9 1a             	cmp    $0x1a,%ecx
80102f53:	0f 42 c2             	cmovb  %edx,%eax
}
80102f56:	c3                   	ret    
80102f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5e:	66 90                	xchg   %ax,%ax
    return -1;
80102f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f65:	c3                   	ret    
80102f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6d:	8d 76 00             	lea    0x0(%esi),%esi

80102f70 <kbdintr>:

void
kbdintr(void)
{
80102f70:	f3 0f 1e fb          	endbr32 
80102f74:	55                   	push   %ebp
80102f75:	89 e5                	mov    %esp,%ebp
80102f77:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102f7a:	68 90 2e 10 80       	push   $0x80102e90
80102f7f:	e8 dc d8 ff ff       	call   80100860 <consoleintr>
}
80102f84:	83 c4 10             	add    $0x10,%esp
80102f87:	c9                   	leave  
80102f88:	c3                   	ret    
80102f89:	66 90                	xchg   %ax,%ax
80102f8b:	66 90                	xchg   %ax,%ax
80102f8d:	66 90                	xchg   %ax,%ax
80102f8f:	90                   	nop

80102f90 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102f90:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102f94:	a1 58 97 13 80       	mov    0x80139758,%eax
80102f99:	85 c0                	test   %eax,%eax
80102f9b:	0f 84 c7 00 00 00    	je     80103068 <lapicinit+0xd8>
  lapic[index] = value;
80102fa1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102fa8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fae:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102fb5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fbb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102fc2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102fc5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fc8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102fcf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102fd2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fd5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102fdc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102fdf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fe2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102fe9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102fec:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fef:	8b 50 30             	mov    0x30(%eax),%edx
80102ff2:	c1 ea 10             	shr    $0x10,%edx
80102ff5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102ffb:	75 73                	jne    80103070 <lapicinit+0xe0>
  lapic[index] = value;
80102ffd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103004:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103007:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010300a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103011:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103014:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103017:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010301e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103021:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103024:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010302b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010302e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103031:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103038:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010303b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010303e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103045:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103048:	8b 50 20             	mov    0x20(%eax),%edx
8010304b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010304f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103050:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103056:	80 e6 10             	and    $0x10,%dh
80103059:	75 f5                	jne    80103050 <lapicinit+0xc0>
  lapic[index] = value;
8010305b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103062:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103065:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103068:	c3                   	ret    
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103070:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103077:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010307a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010307d:	e9 7b ff ff ff       	jmp    80102ffd <lapicinit+0x6d>
80103082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103090 <lapicid>:

int
lapicid(void)
{
80103090:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103094:	a1 58 97 13 80       	mov    0x80139758,%eax
80103099:	85 c0                	test   %eax,%eax
8010309b:	74 0b                	je     801030a8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010309d:	8b 40 20             	mov    0x20(%eax),%eax
801030a0:	c1 e8 18             	shr    $0x18,%eax
801030a3:	c3                   	ret    
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801030a8:	31 c0                	xor    %eax,%eax
}
801030aa:	c3                   	ret    
801030ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030af:	90                   	nop

801030b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030b0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801030b4:	a1 58 97 13 80       	mov    0x80139758,%eax
801030b9:	85 c0                	test   %eax,%eax
801030bb:	74 0d                	je     801030ca <lapiceoi+0x1a>
  lapic[index] = value;
801030bd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030c7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801030ca:	c3                   	ret    
801030cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030cf:	90                   	nop

801030d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030d0:	f3 0f 1e fb          	endbr32 
}
801030d4:	c3                   	ret    
801030d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801030e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030e0:	f3 0f 1e fb          	endbr32 
801030e4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030e5:	b8 0f 00 00 00       	mov    $0xf,%eax
801030ea:	ba 70 00 00 00       	mov    $0x70,%edx
801030ef:	89 e5                	mov    %esp,%ebp
801030f1:	53                   	push   %ebx
801030f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801030f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801030f8:	ee                   	out    %al,(%dx)
801030f9:	b8 0a 00 00 00       	mov    $0xa,%eax
801030fe:	ba 71 00 00 00       	mov    $0x71,%edx
80103103:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103104:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103106:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103109:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010310f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103111:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103114:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103116:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103119:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010311c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103122:	a1 58 97 13 80       	mov    0x80139758,%eax
80103127:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010312d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103130:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103137:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010313a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010313d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103144:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103147:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010314a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103150:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103153:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103159:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010315c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103162:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103165:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010316b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010316c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010316f:	5d                   	pop    %ebp
80103170:	c3                   	ret    
80103171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop

80103180 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103180:	f3 0f 1e fb          	endbr32 
80103184:	55                   	push   %ebp
80103185:	b8 0b 00 00 00       	mov    $0xb,%eax
8010318a:	ba 70 00 00 00       	mov    $0x70,%edx
8010318f:	89 e5                	mov    %esp,%ebp
80103191:	57                   	push   %edi
80103192:	56                   	push   %esi
80103193:	53                   	push   %ebx
80103194:	83 ec 4c             	sub    $0x4c,%esp
80103197:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103198:	ba 71 00 00 00       	mov    $0x71,%edx
8010319d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010319e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a1:	bb 70 00 00 00       	mov    $0x70,%ebx
801031a6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b0:	31 c0                	xor    %eax,%eax
801031b2:	89 da                	mov    %ebx,%edx
801031b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b5:	b9 71 00 00 00       	mov    $0x71,%ecx
801031ba:	89 ca                	mov    %ecx,%edx
801031bc:	ec                   	in     (%dx),%al
801031bd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031c0:	89 da                	mov    %ebx,%edx
801031c2:	b8 02 00 00 00       	mov    $0x2,%eax
801031c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c8:	89 ca                	mov    %ecx,%edx
801031ca:	ec                   	in     (%dx),%al
801031cb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ce:	89 da                	mov    %ebx,%edx
801031d0:	b8 04 00 00 00       	mov    $0x4,%eax
801031d5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d6:	89 ca                	mov    %ecx,%edx
801031d8:	ec                   	in     (%dx),%al
801031d9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031dc:	89 da                	mov    %ebx,%edx
801031de:	b8 07 00 00 00       	mov    $0x7,%eax
801031e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031e4:	89 ca                	mov    %ecx,%edx
801031e6:	ec                   	in     (%dx),%al
801031e7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ea:	89 da                	mov    %ebx,%edx
801031ec:	b8 08 00 00 00       	mov    $0x8,%eax
801031f1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031f2:	89 ca                	mov    %ecx,%edx
801031f4:	ec                   	in     (%dx),%al
801031f5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031f7:	89 da                	mov    %ebx,%edx
801031f9:	b8 09 00 00 00       	mov    $0x9,%eax
801031fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031ff:	89 ca                	mov    %ecx,%edx
80103201:	ec                   	in     (%dx),%al
80103202:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103204:	89 da                	mov    %ebx,%edx
80103206:	b8 0a 00 00 00       	mov    $0xa,%eax
8010320b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010320c:	89 ca                	mov    %ecx,%edx
8010320e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010320f:	84 c0                	test   %al,%al
80103211:	78 9d                	js     801031b0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103213:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103217:	89 fa                	mov    %edi,%edx
80103219:	0f b6 fa             	movzbl %dl,%edi
8010321c:	89 f2                	mov    %esi,%edx
8010321e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103221:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103225:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103228:	89 da                	mov    %ebx,%edx
8010322a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010322d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103230:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103234:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103237:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010323a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010323e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103241:	31 c0                	xor    %eax,%eax
80103243:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103244:	89 ca                	mov    %ecx,%edx
80103246:	ec                   	in     (%dx),%al
80103247:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010324a:	89 da                	mov    %ebx,%edx
8010324c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010324f:	b8 02 00 00 00       	mov    $0x2,%eax
80103254:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103255:	89 ca                	mov    %ecx,%edx
80103257:	ec                   	in     (%dx),%al
80103258:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010325b:	89 da                	mov    %ebx,%edx
8010325d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103260:	b8 04 00 00 00       	mov    $0x4,%eax
80103265:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103266:	89 ca                	mov    %ecx,%edx
80103268:	ec                   	in     (%dx),%al
80103269:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010326c:	89 da                	mov    %ebx,%edx
8010326e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103271:	b8 07 00 00 00       	mov    $0x7,%eax
80103276:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103277:	89 ca                	mov    %ecx,%edx
80103279:	ec                   	in     (%dx),%al
8010327a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010327d:	89 da                	mov    %ebx,%edx
8010327f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103282:	b8 08 00 00 00       	mov    $0x8,%eax
80103287:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103288:	89 ca                	mov    %ecx,%edx
8010328a:	ec                   	in     (%dx),%al
8010328b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010328e:	89 da                	mov    %ebx,%edx
80103290:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103293:	b8 09 00 00 00       	mov    $0x9,%eax
80103298:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103299:	89 ca                	mov    %ecx,%edx
8010329b:	ec                   	in     (%dx),%al
8010329c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010329f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801032a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801032a5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801032a8:	6a 18                	push   $0x18
801032aa:	50                   	push   %eax
801032ab:	8d 45 b8             	lea    -0x48(%ebp),%eax
801032ae:	50                   	push   %eax
801032af:	e8 1c 1c 00 00       	call   80104ed0 <memcmp>
801032b4:	83 c4 10             	add    $0x10,%esp
801032b7:	85 c0                	test   %eax,%eax
801032b9:	0f 85 f1 fe ff ff    	jne    801031b0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801032bf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801032c3:	75 78                	jne    8010333d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801032c8:	89 c2                	mov    %eax,%edx
801032ca:	83 e0 0f             	and    $0xf,%eax
801032cd:	c1 ea 04             	shr    $0x4,%edx
801032d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032d6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801032d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801032dc:	89 c2                	mov    %eax,%edx
801032de:	83 e0 0f             	and    $0xf,%eax
801032e1:	c1 ea 04             	shr    $0x4,%edx
801032e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032ea:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801032ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
801032f0:	89 c2                	mov    %eax,%edx
801032f2:	83 e0 0f             	and    $0xf,%eax
801032f5:	c1 ea 04             	shr    $0x4,%edx
801032f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103301:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103304:	89 c2                	mov    %eax,%edx
80103306:	83 e0 0f             	and    $0xf,%eax
80103309:	c1 ea 04             	shr    $0x4,%edx
8010330c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010330f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103312:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103315:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103318:	89 c2                	mov    %eax,%edx
8010331a:	83 e0 0f             	and    $0xf,%eax
8010331d:	c1 ea 04             	shr    $0x4,%edx
80103320:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103323:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103326:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103329:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010332c:	89 c2                	mov    %eax,%edx
8010332e:	83 e0 0f             	and    $0xf,%eax
80103331:	c1 ea 04             	shr    $0x4,%edx
80103334:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103337:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010333a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010333d:	8b 75 08             	mov    0x8(%ebp),%esi
80103340:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103343:	89 06                	mov    %eax,(%esi)
80103345:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103348:	89 46 04             	mov    %eax,0x4(%esi)
8010334b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010334e:	89 46 08             	mov    %eax,0x8(%esi)
80103351:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103354:	89 46 0c             	mov    %eax,0xc(%esi)
80103357:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010335a:	89 46 10             	mov    %eax,0x10(%esi)
8010335d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103360:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103363:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010336a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010336d:	5b                   	pop    %ebx
8010336e:	5e                   	pop    %esi
8010336f:	5f                   	pop    %edi
80103370:	5d                   	pop    %ebp
80103371:	c3                   	ret    
80103372:	66 90                	xchg   %ax,%ax
80103374:	66 90                	xchg   %ax,%ax
80103376:	66 90                	xchg   %ax,%ax
80103378:	66 90                	xchg   %ax,%ax
8010337a:	66 90                	xchg   %ax,%ax
8010337c:	66 90                	xchg   %ax,%ax
8010337e:	66 90                	xchg   %ax,%ax

80103380 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103380:	8b 0d a8 97 13 80    	mov    0x801397a8,%ecx
80103386:	85 c9                	test   %ecx,%ecx
80103388:	0f 8e 8a 00 00 00    	jle    80103418 <install_trans+0x98>
{
8010338e:	55                   	push   %ebp
8010338f:	89 e5                	mov    %esp,%ebp
80103391:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103392:	31 ff                	xor    %edi,%edi
{
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 0c             	sub    $0xc,%esp
80103399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033a0:	a1 94 97 13 80       	mov    0x80139794,%eax
801033a5:	83 ec 08             	sub    $0x8,%esp
801033a8:	01 f8                	add    %edi,%eax
801033aa:	83 c0 01             	add    $0x1,%eax
801033ad:	50                   	push   %eax
801033ae:	ff 35 a4 97 13 80    	pushl  0x801397a4
801033b4:	e8 17 cd ff ff       	call   801000d0 <bread>
801033b9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033bb:	58                   	pop    %eax
801033bc:	5a                   	pop    %edx
801033bd:	ff 34 bd ac 97 13 80 	pushl  -0x7fec6854(,%edi,4)
801033c4:	ff 35 a4 97 13 80    	pushl  0x801397a4
  for (tail = 0; tail < log.lh.n; tail++) {
801033ca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033cd:	e8 fe cc ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033d5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033d7:	8d 46 5c             	lea    0x5c(%esi),%eax
801033da:	68 00 02 00 00       	push   $0x200
801033df:	50                   	push   %eax
801033e0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801033e3:	50                   	push   %eax
801033e4:	e8 37 1b 00 00       	call   80104f20 <memmove>
    bwrite(dbuf);  // write dst to disk
801033e9:	89 1c 24             	mov    %ebx,(%esp)
801033ec:	e8 bf cd ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801033f1:	89 34 24             	mov    %esi,(%esp)
801033f4:	e8 f7 cd ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801033f9:	89 1c 24             	mov    %ebx,(%esp)
801033fc:	e8 ef cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103401:	83 c4 10             	add    $0x10,%esp
80103404:	39 3d a8 97 13 80    	cmp    %edi,0x801397a8
8010340a:	7f 94                	jg     801033a0 <install_trans+0x20>
  }
}
8010340c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010340f:	5b                   	pop    %ebx
80103410:	5e                   	pop    %esi
80103411:	5f                   	pop    %edi
80103412:	5d                   	pop    %ebp
80103413:	c3                   	ret    
80103414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103418:	c3                   	ret    
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103420 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	53                   	push   %ebx
80103424:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103427:	ff 35 94 97 13 80    	pushl  0x80139794
8010342d:	ff 35 a4 97 13 80    	pushl  0x801397a4
80103433:	e8 98 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103438:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010343b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010343d:	a1 a8 97 13 80       	mov    0x801397a8,%eax
80103442:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103445:	85 c0                	test   %eax,%eax
80103447:	7e 19                	jle    80103462 <write_head+0x42>
80103449:	31 d2                	xor    %edx,%edx
8010344b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010344f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103450:	8b 0c 95 ac 97 13 80 	mov    -0x7fec6854(,%edx,4),%ecx
80103457:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010345b:	83 c2 01             	add    $0x1,%edx
8010345e:	39 d0                	cmp    %edx,%eax
80103460:	75 ee                	jne    80103450 <write_head+0x30>
  }
  bwrite(buf);
80103462:	83 ec 0c             	sub    $0xc,%esp
80103465:	53                   	push   %ebx
80103466:	e8 45 cd ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010346b:	89 1c 24             	mov    %ebx,(%esp)
8010346e:	e8 7d cd ff ff       	call   801001f0 <brelse>
}
80103473:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103476:	83 c4 10             	add    $0x10,%esp
80103479:	c9                   	leave  
8010347a:	c3                   	ret    
8010347b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010347f:	90                   	nop

80103480 <initlog>:
{
80103480:	f3 0f 1e fb          	endbr32 
80103484:	55                   	push   %ebp
80103485:	89 e5                	mov    %esp,%ebp
80103487:	53                   	push   %ebx
80103488:	83 ec 2c             	sub    $0x2c,%esp
8010348b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010348e:	68 c0 81 10 80       	push   $0x801081c0
80103493:	68 60 97 13 80       	push   $0x80139760
80103498:	e8 53 17 00 00       	call   80104bf0 <initlock>
  readsb(dev, &sb);
8010349d:	58                   	pop    %eax
8010349e:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034a1:	5a                   	pop    %edx
801034a2:	50                   	push   %eax
801034a3:	53                   	push   %ebx
801034a4:	e8 d7 df ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
801034a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801034ac:	59                   	pop    %ecx
  log.dev = dev;
801034ad:	89 1d a4 97 13 80    	mov    %ebx,0x801397a4
  log.size = sb.nlog;
801034b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801034b6:	a3 94 97 13 80       	mov    %eax,0x80139794
  log.size = sb.nlog;
801034bb:	89 15 98 97 13 80    	mov    %edx,0x80139798
  struct buf *buf = bread(log.dev, log.start);
801034c1:	5a                   	pop    %edx
801034c2:	50                   	push   %eax
801034c3:	53                   	push   %ebx
801034c4:	e8 07 cc ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801034c9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801034cc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801034cf:	89 0d a8 97 13 80    	mov    %ecx,0x801397a8
  for (i = 0; i < log.lh.n; i++) {
801034d5:	85 c9                	test   %ecx,%ecx
801034d7:	7e 19                	jle    801034f2 <initlog+0x72>
801034d9:	31 d2                	xor    %edx,%edx
801034db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034df:	90                   	nop
    log.lh.block[i] = lh->block[i];
801034e0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801034e4:	89 1c 95 ac 97 13 80 	mov    %ebx,-0x7fec6854(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034eb:	83 c2 01             	add    $0x1,%edx
801034ee:	39 d1                	cmp    %edx,%ecx
801034f0:	75 ee                	jne    801034e0 <initlog+0x60>
  brelse(buf);
801034f2:	83 ec 0c             	sub    $0xc,%esp
801034f5:	50                   	push   %eax
801034f6:	e8 f5 cc ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801034fb:	e8 80 fe ff ff       	call   80103380 <install_trans>
  log.lh.n = 0;
80103500:	c7 05 a8 97 13 80 00 	movl   $0x0,0x801397a8
80103507:	00 00 00 
  write_head(); // clear the log
8010350a:	e8 11 ff ff ff       	call   80103420 <write_head>
}
8010350f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103512:	83 c4 10             	add    $0x10,%esp
80103515:	c9                   	leave  
80103516:	c3                   	ret    
80103517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010351e:	66 90                	xchg   %ax,%ax

80103520 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103520:	f3 0f 1e fb          	endbr32 
80103524:	55                   	push   %ebp
80103525:	89 e5                	mov    %esp,%ebp
80103527:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010352a:	68 60 97 13 80       	push   $0x80139760
8010352f:	e8 3c 18 00 00       	call   80104d70 <acquire>
80103534:	83 c4 10             	add    $0x10,%esp
80103537:	eb 1c                	jmp    80103555 <begin_op+0x35>
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	68 60 97 13 80       	push   $0x80139760
80103548:	68 60 97 13 80       	push   $0x80139760
8010354d:	e8 de 11 00 00       	call   80104730 <sleep>
80103552:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103555:	a1 a0 97 13 80       	mov    0x801397a0,%eax
8010355a:	85 c0                	test   %eax,%eax
8010355c:	75 e2                	jne    80103540 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010355e:	a1 9c 97 13 80       	mov    0x8013979c,%eax
80103563:	8b 15 a8 97 13 80    	mov    0x801397a8,%edx
80103569:	83 c0 01             	add    $0x1,%eax
8010356c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010356f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103572:	83 fa 1e             	cmp    $0x1e,%edx
80103575:	7f c9                	jg     80103540 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103577:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010357a:	a3 9c 97 13 80       	mov    %eax,0x8013979c
      release(&log.lock);
8010357f:	68 60 97 13 80       	push   $0x80139760
80103584:	e8 a7 18 00 00       	call   80104e30 <release>
      break;
    }
  }
}
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	c9                   	leave  
8010358d:	c3                   	ret    
8010358e:	66 90                	xchg   %ax,%ax

80103590 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103590:	f3 0f 1e fb          	endbr32 
80103594:	55                   	push   %ebp
80103595:	89 e5                	mov    %esp,%ebp
80103597:	57                   	push   %edi
80103598:	56                   	push   %esi
80103599:	53                   	push   %ebx
8010359a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010359d:	68 60 97 13 80       	push   $0x80139760
801035a2:	e8 c9 17 00 00       	call   80104d70 <acquire>
  log.outstanding -= 1;
801035a7:	a1 9c 97 13 80       	mov    0x8013979c,%eax
  if(log.committing)
801035ac:	8b 35 a0 97 13 80    	mov    0x801397a0,%esi
801035b2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801035b8:	89 1d 9c 97 13 80    	mov    %ebx,0x8013979c
  if(log.committing)
801035be:	85 f6                	test   %esi,%esi
801035c0:	0f 85 1e 01 00 00    	jne    801036e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801035c6:	85 db                	test   %ebx,%ebx
801035c8:	0f 85 f2 00 00 00    	jne    801036c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801035ce:	c7 05 a0 97 13 80 01 	movl   $0x1,0x801397a0
801035d5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801035d8:	83 ec 0c             	sub    $0xc,%esp
801035db:	68 60 97 13 80       	push   $0x80139760
801035e0:	e8 4b 18 00 00       	call   80104e30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801035e5:	8b 0d a8 97 13 80    	mov    0x801397a8,%ecx
801035eb:	83 c4 10             	add    $0x10,%esp
801035ee:	85 c9                	test   %ecx,%ecx
801035f0:	7f 3e                	jg     80103630 <end_op+0xa0>
    acquire(&log.lock);
801035f2:	83 ec 0c             	sub    $0xc,%esp
801035f5:	68 60 97 13 80       	push   $0x80139760
801035fa:	e8 71 17 00 00       	call   80104d70 <acquire>
    wakeup(&log);
801035ff:	c7 04 24 60 97 13 80 	movl   $0x80139760,(%esp)
    log.committing = 0;
80103606:	c7 05 a0 97 13 80 00 	movl   $0x0,0x801397a0
8010360d:	00 00 00 
    wakeup(&log);
80103610:	e8 db 12 00 00       	call   801048f0 <wakeup>
    release(&log.lock);
80103615:	c7 04 24 60 97 13 80 	movl   $0x80139760,(%esp)
8010361c:	e8 0f 18 00 00       	call   80104e30 <release>
80103621:	83 c4 10             	add    $0x10,%esp
}
80103624:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103627:	5b                   	pop    %ebx
80103628:	5e                   	pop    %esi
80103629:	5f                   	pop    %edi
8010362a:	5d                   	pop    %ebp
8010362b:	c3                   	ret    
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103630:	a1 94 97 13 80       	mov    0x80139794,%eax
80103635:	83 ec 08             	sub    $0x8,%esp
80103638:	01 d8                	add    %ebx,%eax
8010363a:	83 c0 01             	add    $0x1,%eax
8010363d:	50                   	push   %eax
8010363e:	ff 35 a4 97 13 80    	pushl  0x801397a4
80103644:	e8 87 ca ff ff       	call   801000d0 <bread>
80103649:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010364b:	58                   	pop    %eax
8010364c:	5a                   	pop    %edx
8010364d:	ff 34 9d ac 97 13 80 	pushl  -0x7fec6854(,%ebx,4)
80103654:	ff 35 a4 97 13 80    	pushl  0x801397a4
  for (tail = 0; tail < log.lh.n; tail++) {
8010365a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010365d:	e8 6e ca ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103662:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103665:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103667:	8d 40 5c             	lea    0x5c(%eax),%eax
8010366a:	68 00 02 00 00       	push   $0x200
8010366f:	50                   	push   %eax
80103670:	8d 46 5c             	lea    0x5c(%esi),%eax
80103673:	50                   	push   %eax
80103674:	e8 a7 18 00 00       	call   80104f20 <memmove>
    bwrite(to);  // write the log
80103679:	89 34 24             	mov    %esi,(%esp)
8010367c:	e8 2f cb ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103681:	89 3c 24             	mov    %edi,(%esp)
80103684:	e8 67 cb ff ff       	call   801001f0 <brelse>
    brelse(to);
80103689:	89 34 24             	mov    %esi,(%esp)
8010368c:	e8 5f cb ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	3b 1d a8 97 13 80    	cmp    0x801397a8,%ebx
8010369a:	7c 94                	jl     80103630 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010369c:	e8 7f fd ff ff       	call   80103420 <write_head>
    install_trans(); // Now install writes to home locations
801036a1:	e8 da fc ff ff       	call   80103380 <install_trans>
    log.lh.n = 0;
801036a6:	c7 05 a8 97 13 80 00 	movl   $0x0,0x801397a8
801036ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801036b0:	e8 6b fd ff ff       	call   80103420 <write_head>
801036b5:	e9 38 ff ff ff       	jmp    801035f2 <end_op+0x62>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	68 60 97 13 80       	push   $0x80139760
801036c8:	e8 23 12 00 00       	call   801048f0 <wakeup>
  release(&log.lock);
801036cd:	c7 04 24 60 97 13 80 	movl   $0x80139760,(%esp)
801036d4:	e8 57 17 00 00       	call   80104e30 <release>
801036d9:	83 c4 10             	add    $0x10,%esp
}
801036dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036df:	5b                   	pop    %ebx
801036e0:	5e                   	pop    %esi
801036e1:	5f                   	pop    %edi
801036e2:	5d                   	pop    %ebp
801036e3:	c3                   	ret    
    panic("log.committing");
801036e4:	83 ec 0c             	sub    $0xc,%esp
801036e7:	68 c4 81 10 80       	push   $0x801081c4
801036ec:	e8 9f cc ff ff       	call   80100390 <panic>
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ff:	90                   	nop

80103700 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103700:	f3 0f 1e fb          	endbr32 
80103704:	55                   	push   %ebp
80103705:	89 e5                	mov    %esp,%ebp
80103707:	53                   	push   %ebx
80103708:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010370b:	8b 15 a8 97 13 80    	mov    0x801397a8,%edx
{
80103711:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103714:	83 fa 1d             	cmp    $0x1d,%edx
80103717:	0f 8f 91 00 00 00    	jg     801037ae <log_write+0xae>
8010371d:	a1 98 97 13 80       	mov    0x80139798,%eax
80103722:	83 e8 01             	sub    $0x1,%eax
80103725:	39 c2                	cmp    %eax,%edx
80103727:	0f 8d 81 00 00 00    	jge    801037ae <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010372d:	a1 9c 97 13 80       	mov    0x8013979c,%eax
80103732:	85 c0                	test   %eax,%eax
80103734:	0f 8e 81 00 00 00    	jle    801037bb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010373a:	83 ec 0c             	sub    $0xc,%esp
8010373d:	68 60 97 13 80       	push   $0x80139760
80103742:	e8 29 16 00 00       	call   80104d70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103747:	8b 15 a8 97 13 80    	mov    0x801397a8,%edx
8010374d:	83 c4 10             	add    $0x10,%esp
80103750:	85 d2                	test   %edx,%edx
80103752:	7e 4e                	jle    801037a2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103754:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103757:	31 c0                	xor    %eax,%eax
80103759:	eb 0c                	jmp    80103767 <log_write+0x67>
8010375b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010375f:	90                   	nop
80103760:	83 c0 01             	add    $0x1,%eax
80103763:	39 c2                	cmp    %eax,%edx
80103765:	74 29                	je     80103790 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103767:	39 0c 85 ac 97 13 80 	cmp    %ecx,-0x7fec6854(,%eax,4)
8010376e:	75 f0                	jne    80103760 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103770:	89 0c 85 ac 97 13 80 	mov    %ecx,-0x7fec6854(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103777:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010377a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010377d:	c7 45 08 60 97 13 80 	movl   $0x80139760,0x8(%ebp)
}
80103784:	c9                   	leave  
  release(&log.lock);
80103785:	e9 a6 16 00 00       	jmp    80104e30 <release>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103790:	89 0c 95 ac 97 13 80 	mov    %ecx,-0x7fec6854(,%edx,4)
    log.lh.n++;
80103797:	83 c2 01             	add    $0x1,%edx
8010379a:	89 15 a8 97 13 80    	mov    %edx,0x801397a8
801037a0:	eb d5                	jmp    80103777 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801037a2:	8b 43 08             	mov    0x8(%ebx),%eax
801037a5:	a3 ac 97 13 80       	mov    %eax,0x801397ac
  if (i == log.lh.n)
801037aa:	75 cb                	jne    80103777 <log_write+0x77>
801037ac:	eb e9                	jmp    80103797 <log_write+0x97>
    panic("too big a transaction");
801037ae:	83 ec 0c             	sub    $0xc,%esp
801037b1:	68 d3 81 10 80       	push   $0x801081d3
801037b6:	e8 d5 cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801037bb:	83 ec 0c             	sub    $0xc,%esp
801037be:	68 e9 81 10 80       	push   $0x801081e9
801037c3:	e8 c8 cb ff ff       	call   80100390 <panic>
801037c8:	66 90                	xchg   %ax,%ax
801037ca:	66 90                	xchg   %ax,%ax
801037cc:	66 90                	xchg   %ax,%ax
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
801037d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801037d7:	e8 54 09 00 00       	call   80104130 <cpuid>
801037dc:	89 c3                	mov    %eax,%ebx
801037de:	e8 4d 09 00 00       	call   80104130 <cpuid>
801037e3:	83 ec 04             	sub    $0x4,%esp
801037e6:	53                   	push   %ebx
801037e7:	50                   	push   %eax
801037e8:	68 04 82 10 80       	push   $0x80108204
801037ed:	e8 be ce ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801037f2:	e8 59 2a 00 00       	call   80106250 <idtinit>
  // cprintf("mpmain-1\n");
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801037f7:	e8 c4 08 00 00       	call   801040c0 <mycpu>
801037fc:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
801037fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103803:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  // cprintf("mpmain-2\n");
  scheduler();     // start running processes
8010380a:	e8 31 0c 00 00       	call   80104440 <scheduler>
8010380f:	90                   	nop

80103810 <mpenter>:
{
80103810:	f3 0f 1e fb          	endbr32 
80103814:	55                   	push   %ebp
80103815:	89 e5                	mov    %esp,%ebp
80103817:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010381a:	e8 21 3c 00 00       	call   80107440 <switchkvm>
  seginit();
8010381f:	e8 ac 39 00 00       	call   801071d0 <seginit>
  lapicinit();
80103824:	e8 67 f7 ff ff       	call   80102f90 <lapicinit>
  mpmain();
80103829:	e8 a2 ff ff ff       	call   801037d0 <mpmain>
8010382e:	66 90                	xchg   %ax,%ax

80103830 <main>:
{
80103830:	f3 0f 1e fb          	endbr32 
80103834:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103838:	83 e4 f0             	and    $0xfffffff0,%esp
8010383b:	ff 71 fc             	pushl  -0x4(%ecx)
8010383e:	55                   	push   %ebp
8010383f:	89 e5                	mov    %esp,%ebp
80103841:	53                   	push   %ebx
80103842:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103843:	83 ec 08             	sub    $0x8,%esp
80103846:	68 00 00 40 80       	push   $0x80400000
8010384b:	68 88 c5 13 80       	push   $0x8013c588
80103850:	e8 0b f3 ff ff       	call   80102b60 <kinit1>
  kvmalloc();      // kernel page table
80103855:	e8 e6 40 00 00       	call   80107940 <kvmalloc>
  mpinit();        // detect other processors
8010385a:	e8 81 01 00 00       	call   801039e0 <mpinit>
  lapicinit();     // interrupt controller
8010385f:	e8 2c f7 ff ff       	call   80102f90 <lapicinit>
  seginit();       // segment descriptors
80103864:	e8 67 39 00 00       	call   801071d0 <seginit>
  picinit();       // disable pic
80103869:	e8 52 03 00 00       	call   80103bc0 <picinit>
  ioapicinit();    // another interrupt controller
8010386e:	e8 2d ec ff ff       	call   801024a0 <ioapicinit>
  consoleinit();   // console hardware
80103873:	e8 b8 d1 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103878:	e8 d3 2d 00 00       	call   80106650 <uartinit>
  pinit();         // process table
8010387d:	e8 1e 08 00 00       	call   801040a0 <pinit>
  tvinit();        // trap vectors
80103882:	e8 49 29 00 00       	call   801061d0 <tvinit>
  binit();         // buffer cache
80103887:	e8 b4 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010388c:	e8 4f d5 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103891:	e8 da e9 ff ff       	call   80102270 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103896:	83 c4 0c             	add    $0xc,%esp
80103899:	68 8a 00 00 00       	push   $0x8a
8010389e:	68 8c b4 10 80       	push   $0x8010b48c
801038a3:	68 00 70 00 80       	push   $0x80007000
801038a8:	e8 73 16 00 00       	call   80104f20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038ad:	83 c4 10             	add    $0x10,%esp
801038b0:	69 05 e0 9d 13 80 b0 	imul   $0xb0,0x80139de0,%eax
801038b7:	00 00 00 
801038ba:	05 60 98 13 80       	add    $0x80139860,%eax
801038bf:	3d 60 98 13 80       	cmp    $0x80139860,%eax
801038c4:	76 7a                	jbe    80103940 <main+0x110>
801038c6:	bb 60 98 13 80       	mov    $0x80139860,%ebx
801038cb:	eb 1c                	jmp    801038e9 <main+0xb9>
801038cd:	8d 76 00             	lea    0x0(%esi),%esi
801038d0:	69 05 e0 9d 13 80 b0 	imul   $0xb0,0x80139de0,%eax
801038d7:	00 00 00 
801038da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801038e0:	05 60 98 13 80       	add    $0x80139860,%eax
801038e5:	39 c3                	cmp    %eax,%ebx
801038e7:	73 57                	jae    80103940 <main+0x110>
    if(c == mycpu())  // We've started already.
801038e9:	e8 d2 07 00 00       	call   801040c0 <mycpu>
801038ee:	39 c3                	cmp    %eax,%ebx
801038f0:	74 de                	je     801038d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038f2:	e8 29 f5 ff ff       	call   80102e20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801038f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801038fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103810,0x80006ff8
80103901:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103904:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010390b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010390e:	05 00 10 00 00       	add    $0x1000,%eax
80103913:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103918:	0f b6 03             	movzbl (%ebx),%eax
8010391b:	68 00 70 00 00       	push   $0x7000
80103920:	50                   	push   %eax
80103921:	e8 ba f7 ff ff       	call   801030e0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103926:	83 c4 10             	add    $0x10,%esp
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103930:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103936:	85 c0                	test   %eax,%eax
80103938:	74 f6                	je     80103930 <main+0x100>
8010393a:	eb 94                	jmp    801038d0 <main+0xa0>
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103940:	83 ec 08             	sub    $0x8,%esp
80103943:	68 00 00 60 80       	push   $0x80600000
80103948:	68 00 00 40 80       	push   $0x80400000
8010394d:	e8 7e f2 ff ff       	call   80102bd0 <kinit2>
  userinit();      // first user process
80103952:	e8 29 08 00 00       	call   80104180 <userinit>
  mpmain();        // finish this processor's setup
80103957:	e8 74 fe ff ff       	call   801037d0 <mpmain>
8010395c:	66 90                	xchg   %ax,%ax
8010395e:	66 90                	xchg   %ax,%ax

80103960 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	57                   	push   %edi
80103964:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103965:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010396b:	53                   	push   %ebx
  e = addr+len;
8010396c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010396f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103972:	39 de                	cmp    %ebx,%esi
80103974:	72 10                	jb     80103986 <mpsearch1+0x26>
80103976:	eb 50                	jmp    801039c8 <mpsearch1+0x68>
80103978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop
80103980:	89 fe                	mov    %edi,%esi
80103982:	39 fb                	cmp    %edi,%ebx
80103984:	76 42                	jbe    801039c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103986:	83 ec 04             	sub    $0x4,%esp
80103989:	8d 7e 10             	lea    0x10(%esi),%edi
8010398c:	6a 04                	push   $0x4
8010398e:	68 18 82 10 80       	push   $0x80108218
80103993:	56                   	push   %esi
80103994:	e8 37 15 00 00       	call   80104ed0 <memcmp>
80103999:	83 c4 10             	add    $0x10,%esp
8010399c:	85 c0                	test   %eax,%eax
8010399e:	75 e0                	jne    80103980 <mpsearch1+0x20>
801039a0:	89 f2                	mov    %esi,%edx
801039a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801039a8:	0f b6 0a             	movzbl (%edx),%ecx
801039ab:	83 c2 01             	add    $0x1,%edx
801039ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801039b0:	39 fa                	cmp    %edi,%edx
801039b2:	75 f4                	jne    801039a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039b4:	84 c0                	test   %al,%al
801039b6:	75 c8                	jne    80103980 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801039b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039bb:	89 f0                	mov    %esi,%eax
801039bd:	5b                   	pop    %ebx
801039be:	5e                   	pop    %esi
801039bf:	5f                   	pop    %edi
801039c0:	5d                   	pop    %ebp
801039c1:	c3                   	ret    
801039c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039cb:	31 f6                	xor    %esi,%esi
}
801039cd:	5b                   	pop    %ebx
801039ce:	89 f0                	mov    %esi,%eax
801039d0:	5e                   	pop    %esi
801039d1:	5f                   	pop    %edi
801039d2:	5d                   	pop    %ebp
801039d3:	c3                   	ret    
801039d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	57                   	push   %edi
801039e8:	56                   	push   %esi
801039e9:	53                   	push   %ebx
801039ea:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801039ed:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801039f4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801039fb:	c1 e0 08             	shl    $0x8,%eax
801039fe:	09 d0                	or     %edx,%eax
80103a00:	c1 e0 04             	shl    $0x4,%eax
80103a03:	75 1b                	jne    80103a20 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a05:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103a0c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103a13:	c1 e0 08             	shl    $0x8,%eax
80103a16:	09 d0                	or     %edx,%eax
80103a18:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103a1b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103a20:	ba 00 04 00 00       	mov    $0x400,%edx
80103a25:	e8 36 ff ff ff       	call   80103960 <mpsearch1>
80103a2a:	89 c6                	mov    %eax,%esi
80103a2c:	85 c0                	test   %eax,%eax
80103a2e:	0f 84 4c 01 00 00    	je     80103b80 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a34:	8b 5e 04             	mov    0x4(%esi),%ebx
80103a37:	85 db                	test   %ebx,%ebx
80103a39:	0f 84 61 01 00 00    	je     80103ba0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103a3f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a42:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103a48:	6a 04                	push   $0x4
80103a4a:	68 1d 82 10 80       	push   $0x8010821d
80103a4f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103a53:	e8 78 14 00 00       	call   80104ed0 <memcmp>
80103a58:	83 c4 10             	add    $0x10,%esp
80103a5b:	85 c0                	test   %eax,%eax
80103a5d:	0f 85 3d 01 00 00    	jne    80103ba0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103a63:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103a6a:	3c 01                	cmp    $0x1,%al
80103a6c:	74 08                	je     80103a76 <mpinit+0x96>
80103a6e:	3c 04                	cmp    $0x4,%al
80103a70:	0f 85 2a 01 00 00    	jne    80103ba0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103a76:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103a7d:	66 85 d2             	test   %dx,%dx
80103a80:	74 26                	je     80103aa8 <mpinit+0xc8>
80103a82:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103a85:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103a87:	31 d2                	xor    %edx,%edx
80103a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103a90:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103a97:	83 c0 01             	add    $0x1,%eax
80103a9a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103a9c:	39 f8                	cmp    %edi,%eax
80103a9e:	75 f0                	jne    80103a90 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103aa0:	84 d2                	test   %dl,%dl
80103aa2:	0f 85 f8 00 00 00    	jne    80103ba0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103aa8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103aae:	a3 58 97 13 80       	mov    %eax,0x80139758
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ab3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103ab9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103ac0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ac5:	03 55 e4             	add    -0x1c(%ebp),%edx
80103ac8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103acf:	90                   	nop
80103ad0:	39 c2                	cmp    %eax,%edx
80103ad2:	76 15                	jbe    80103ae9 <mpinit+0x109>
    switch(*p){
80103ad4:	0f b6 08             	movzbl (%eax),%ecx
80103ad7:	80 f9 02             	cmp    $0x2,%cl
80103ada:	74 5c                	je     80103b38 <mpinit+0x158>
80103adc:	77 42                	ja     80103b20 <mpinit+0x140>
80103ade:	84 c9                	test   %cl,%cl
80103ae0:	74 6e                	je     80103b50 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ae2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ae5:	39 c2                	cmp    %eax,%edx
80103ae7:	77 eb                	ja     80103ad4 <mpinit+0xf4>
80103ae9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103aec:	85 db                	test   %ebx,%ebx
80103aee:	0f 84 b9 00 00 00    	je     80103bad <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103af4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103af8:	74 15                	je     80103b0f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103afa:	b8 70 00 00 00       	mov    $0x70,%eax
80103aff:	ba 22 00 00 00       	mov    $0x22,%edx
80103b04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b05:	ba 23 00 00 00       	mov    $0x23,%edx
80103b0a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b0b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b0e:	ee                   	out    %al,(%dx)
  }
}
80103b0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b12:	5b                   	pop    %ebx
80103b13:	5e                   	pop    %esi
80103b14:	5f                   	pop    %edi
80103b15:	5d                   	pop    %ebp
80103b16:	c3                   	ret    
80103b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103b20:	83 e9 03             	sub    $0x3,%ecx
80103b23:	80 f9 01             	cmp    $0x1,%cl
80103b26:	76 ba                	jbe    80103ae2 <mpinit+0x102>
80103b28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103b2f:	eb 9f                	jmp    80103ad0 <mpinit+0xf0>
80103b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103b38:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103b3c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103b3f:	88 0d 40 98 13 80    	mov    %cl,0x80139840
      continue;
80103b45:	eb 89                	jmp    80103ad0 <mpinit+0xf0>
80103b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103b50:	8b 0d e0 9d 13 80    	mov    0x80139de0,%ecx
80103b56:	83 f9 07             	cmp    $0x7,%ecx
80103b59:	7f 19                	jg     80103b74 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b5b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103b61:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103b65:	83 c1 01             	add    $0x1,%ecx
80103b68:	89 0d e0 9d 13 80    	mov    %ecx,0x80139de0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b6e:	88 9f 60 98 13 80    	mov    %bl,-0x7fec67a0(%edi)
      p += sizeof(struct mpproc);
80103b74:	83 c0 14             	add    $0x14,%eax
      continue;
80103b77:	e9 54 ff ff ff       	jmp    80103ad0 <mpinit+0xf0>
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103b80:	ba 00 00 01 00       	mov    $0x10000,%edx
80103b85:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103b8a:	e8 d1 fd ff ff       	call   80103960 <mpsearch1>
80103b8f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b91:	85 c0                	test   %eax,%eax
80103b93:	0f 85 9b fe ff ff    	jne    80103a34 <mpinit+0x54>
80103b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	68 22 82 10 80       	push   $0x80108222
80103ba8:	e8 e3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103bad:	83 ec 0c             	sub    $0xc,%esp
80103bb0:	68 3c 82 10 80       	push   $0x8010823c
80103bb5:	e8 d6 c7 ff ff       	call   80100390 <panic>
80103bba:	66 90                	xchg   %ax,%ax
80103bbc:	66 90                	xchg   %ax,%ax
80103bbe:	66 90                	xchg   %ax,%ax

80103bc0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103bc0:	f3 0f 1e fb          	endbr32 
80103bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bc9:	ba 21 00 00 00       	mov    $0x21,%edx
80103bce:	ee                   	out    %al,(%dx)
80103bcf:	ba a1 00 00 00       	mov    $0xa1,%edx
80103bd4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103bd5:	c3                   	ret    
80103bd6:	66 90                	xchg   %ax,%ax
80103bd8:	66 90                	xchg   %ax,%ax
80103bda:	66 90                	xchg   %ax,%ax
80103bdc:	66 90                	xchg   %ax,%ax
80103bde:	66 90                	xchg   %ax,%ax

80103be0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	57                   	push   %edi
80103be8:	56                   	push   %esi
80103be9:	53                   	push   %ebx
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bf0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103bf3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103bf9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103bff:	e8 fc d1 ff ff       	call   80100e00 <filealloc>
80103c04:	89 03                	mov    %eax,(%ebx)
80103c06:	85 c0                	test   %eax,%eax
80103c08:	0f 84 ac 00 00 00    	je     80103cba <pipealloc+0xda>
80103c0e:	e8 ed d1 ff ff       	call   80100e00 <filealloc>
80103c13:	89 06                	mov    %eax,(%esi)
80103c15:	85 c0                	test   %eax,%eax
80103c17:	0f 84 8b 00 00 00    	je     80103ca8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c1d:	e8 fe f1 ff ff       	call   80102e20 <kalloc>
80103c22:	89 c7                	mov    %eax,%edi
80103c24:	85 c0                	test   %eax,%eax
80103c26:	0f 84 b4 00 00 00    	je     80103ce0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103c2c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c33:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103c36:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103c39:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c40:	00 00 00 
  p->nwrite = 0;
80103c43:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c4a:	00 00 00 
  p->nread = 0;
80103c4d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c54:	00 00 00 
  initlock(&p->lock, "pipe");
80103c57:	68 5b 82 10 80       	push   $0x8010825b
80103c5c:	50                   	push   %eax
80103c5d:	e8 8e 0f 00 00       	call   80104bf0 <initlock>
  (*f0)->type = FD_PIPE;
80103c62:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103c64:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103c67:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c6d:	8b 03                	mov    (%ebx),%eax
80103c6f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103c73:	8b 03                	mov    (%ebx),%eax
80103c75:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103c79:	8b 03                	mov    (%ebx),%eax
80103c7b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103c7e:	8b 06                	mov    (%esi),%eax
80103c80:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103c86:	8b 06                	mov    (%esi),%eax
80103c88:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103c8c:	8b 06                	mov    (%esi),%eax
80103c8e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103c92:	8b 06                	mov    (%esi),%eax
80103c94:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103c97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103c9a:	31 c0                	xor    %eax,%eax
}
80103c9c:	5b                   	pop    %ebx
80103c9d:	5e                   	pop    %esi
80103c9e:	5f                   	pop    %edi
80103c9f:	5d                   	pop    %ebp
80103ca0:	c3                   	ret    
80103ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103ca8:	8b 03                	mov    (%ebx),%eax
80103caa:	85 c0                	test   %eax,%eax
80103cac:	74 1e                	je     80103ccc <pipealloc+0xec>
    fileclose(*f0);
80103cae:	83 ec 0c             	sub    $0xc,%esp
80103cb1:	50                   	push   %eax
80103cb2:	e8 09 d2 ff ff       	call   80100ec0 <fileclose>
80103cb7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103cba:	8b 06                	mov    (%esi),%eax
80103cbc:	85 c0                	test   %eax,%eax
80103cbe:	74 0c                	je     80103ccc <pipealloc+0xec>
    fileclose(*f1);
80103cc0:	83 ec 0c             	sub    $0xc,%esp
80103cc3:	50                   	push   %eax
80103cc4:	e8 f7 d1 ff ff       	call   80100ec0 <fileclose>
80103cc9:	83 c4 10             	add    $0x10,%esp
}
80103ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103ccf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103cd4:	5b                   	pop    %ebx
80103cd5:	5e                   	pop    %esi
80103cd6:	5f                   	pop    %edi
80103cd7:	5d                   	pop    %ebp
80103cd8:	c3                   	ret    
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103ce0:	8b 03                	mov    (%ebx),%eax
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	75 c8                	jne    80103cae <pipealloc+0xce>
80103ce6:	eb d2                	jmp    80103cba <pipealloc+0xda>
80103ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cef:	90                   	nop

80103cf0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103cf0:	f3 0f 1e fb          	endbr32 
80103cf4:	55                   	push   %ebp
80103cf5:	89 e5                	mov    %esp,%ebp
80103cf7:	56                   	push   %esi
80103cf8:	53                   	push   %ebx
80103cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103cff:	83 ec 0c             	sub    $0xc,%esp
80103d02:	53                   	push   %ebx
80103d03:	e8 68 10 00 00       	call   80104d70 <acquire>
  if(writable){
80103d08:	83 c4 10             	add    $0x10,%esp
80103d0b:	85 f6                	test   %esi,%esi
80103d0d:	74 41                	je     80103d50 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103d0f:	83 ec 0c             	sub    $0xc,%esp
80103d12:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103d18:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d1f:	00 00 00 
    wakeup(&p->nread);
80103d22:	50                   	push   %eax
80103d23:	e8 c8 0b 00 00       	call   801048f0 <wakeup>
80103d28:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d2b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103d31:	85 d2                	test   %edx,%edx
80103d33:	75 0a                	jne    80103d3f <pipeclose+0x4f>
80103d35:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103d3b:	85 c0                	test   %eax,%eax
80103d3d:	74 31                	je     80103d70 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103d3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d45:	5b                   	pop    %ebx
80103d46:	5e                   	pop    %esi
80103d47:	5d                   	pop    %ebp
    release(&p->lock);
80103d48:	e9 e3 10 00 00       	jmp    80104e30 <release>
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103d50:	83 ec 0c             	sub    $0xc,%esp
80103d53:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103d59:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d60:	00 00 00 
    wakeup(&p->nwrite);
80103d63:	50                   	push   %eax
80103d64:	e8 87 0b 00 00       	call   801048f0 <wakeup>
80103d69:	83 c4 10             	add    $0x10,%esp
80103d6c:	eb bd                	jmp    80103d2b <pipeclose+0x3b>
80103d6e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	53                   	push   %ebx
80103d74:	e8 b7 10 00 00       	call   80104e30 <release>
    kfree((char*)p);
80103d79:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103d7c:	83 c4 10             	add    $0x10,%esp
}
80103d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d82:	5b                   	pop    %ebx
80103d83:	5e                   	pop    %esi
80103d84:	5d                   	pop    %ebp
    kfree((char*)p);
80103d85:	e9 26 ec ff ff       	jmp    801029b0 <kfree>
80103d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d90 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80103d90:	f3 0f 1e fb          	endbr32 
80103d94:	55                   	push   %ebp
80103d95:	89 e5                	mov    %esp,%ebp
80103d97:	57                   	push   %edi
80103d98:	56                   	push   %esi
80103d99:	53                   	push   %ebx
80103d9a:	83 ec 28             	sub    $0x28,%esp
80103d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103da0:	53                   	push   %ebx
80103da1:	e8 ca 0f 00 00       	call   80104d70 <acquire>
  for(i = 0; i < n; i++){
80103da6:	8b 45 10             	mov    0x10(%ebp),%eax
80103da9:	83 c4 10             	add    $0x10,%esp
80103dac:	85 c0                	test   %eax,%eax
80103dae:	0f 8e bc 00 00 00    	jle    80103e70 <pipewrite+0xe0>
80103db4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103dbd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103dc6:	03 45 10             	add    0x10(%ebp),%eax
80103dc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dcc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103dd2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dd8:	89 ca                	mov    %ecx,%edx
80103dda:	05 00 02 00 00       	add    $0x200,%eax
80103ddf:	39 c1                	cmp    %eax,%ecx
80103de1:	74 3b                	je     80103e1e <pipewrite+0x8e>
80103de3:	eb 63                	jmp    80103e48 <pipewrite+0xb8>
80103de5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103de8:	e8 63 03 00 00       	call   80104150 <myproc>
80103ded:	8b 48 24             	mov    0x24(%eax),%ecx
80103df0:	85 c9                	test   %ecx,%ecx
80103df2:	75 34                	jne    80103e28 <pipewrite+0x98>
      wakeup(&p->nread);
80103df4:	83 ec 0c             	sub    $0xc,%esp
80103df7:	57                   	push   %edi
80103df8:	e8 f3 0a 00 00       	call   801048f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103dfd:	58                   	pop    %eax
80103dfe:	5a                   	pop    %edx
80103dff:	53                   	push   %ebx
80103e00:	56                   	push   %esi
80103e01:	e8 2a 09 00 00       	call   80104730 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e06:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103e0c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e12:	83 c4 10             	add    $0x10,%esp
80103e15:	05 00 02 00 00       	add    $0x200,%eax
80103e1a:	39 c2                	cmp    %eax,%edx
80103e1c:	75 2a                	jne    80103e48 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103e1e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e24:	85 c0                	test   %eax,%eax
80103e26:	75 c0                	jne    80103de8 <pipewrite+0x58>
        release(&p->lock);
80103e28:	83 ec 0c             	sub    $0xc,%esp
80103e2b:	53                   	push   %ebx
80103e2c:	e8 ff 0f 00 00       	call   80104e30 <release>
        return -1;
80103e31:	83 c4 10             	add    $0x10,%esp
80103e34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e3c:	5b                   	pop    %ebx
80103e3d:	5e                   	pop    %esi
80103e3e:	5f                   	pop    %edi
80103e3f:	5d                   	pop    %ebp
80103e40:	c3                   	ret    
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e48:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103e4e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103e54:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103e5a:	0f b6 06             	movzbl (%esi),%eax
80103e5d:	83 c6 01             	add    $0x1,%esi
80103e60:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103e63:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103e67:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103e6a:	0f 85 5c ff ff ff    	jne    80103dcc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e70:	83 ec 0c             	sub    $0xc,%esp
80103e73:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103e79:	50                   	push   %eax
80103e7a:	e8 71 0a 00 00       	call   801048f0 <wakeup>
  release(&p->lock);
80103e7f:	89 1c 24             	mov    %ebx,(%esp)
80103e82:	e8 a9 0f 00 00       	call   80104e30 <release>
  return n;
80103e87:	8b 45 10             	mov    0x10(%ebp),%eax
80103e8a:	83 c4 10             	add    $0x10,%esp
80103e8d:	eb aa                	jmp    80103e39 <pipewrite+0xa9>
80103e8f:	90                   	nop

80103e90 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103e90:	f3 0f 1e fb          	endbr32 
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	57                   	push   %edi
80103e98:	56                   	push   %esi
80103e99:	53                   	push   %ebx
80103e9a:	83 ec 18             	sub    $0x18,%esp
80103e9d:	8b 75 08             	mov    0x8(%ebp),%esi
80103ea0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103ea3:	56                   	push   %esi
80103ea4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103eaa:	e8 c1 0e 00 00       	call   80104d70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103eaf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103eb5:	83 c4 10             	add    $0x10,%esp
80103eb8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103ebe:	74 33                	je     80103ef3 <piperead+0x63>
80103ec0:	eb 3b                	jmp    80103efd <piperead+0x6d>
80103ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103ec8:	e8 83 02 00 00       	call   80104150 <myproc>
80103ecd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ed0:	85 c9                	test   %ecx,%ecx
80103ed2:	0f 85 88 00 00 00    	jne    80103f60 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ed8:	83 ec 08             	sub    $0x8,%esp
80103edb:	56                   	push   %esi
80103edc:	53                   	push   %ebx
80103edd:	e8 4e 08 00 00       	call   80104730 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ee2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103ee8:	83 c4 10             	add    $0x10,%esp
80103eeb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103ef1:	75 0a                	jne    80103efd <piperead+0x6d>
80103ef3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103ef9:	85 c0                	test   %eax,%eax
80103efb:	75 cb                	jne    80103ec8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103efd:	8b 55 10             	mov    0x10(%ebp),%edx
80103f00:	31 db                	xor    %ebx,%ebx
80103f02:	85 d2                	test   %edx,%edx
80103f04:	7f 28                	jg     80103f2e <piperead+0x9e>
80103f06:	eb 34                	jmp    80103f3c <piperead+0xac>
80103f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f10:	8d 48 01             	lea    0x1(%eax),%ecx
80103f13:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f18:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103f1e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103f23:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f26:	83 c3 01             	add    $0x1,%ebx
80103f29:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103f2c:	74 0e                	je     80103f3c <piperead+0xac>
    if(p->nread == p->nwrite)
80103f2e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f34:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103f3a:	75 d4                	jne    80103f10 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f3c:	83 ec 0c             	sub    $0xc,%esp
80103f3f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103f45:	50                   	push   %eax
80103f46:	e8 a5 09 00 00       	call   801048f0 <wakeup>
  release(&p->lock);
80103f4b:	89 34 24             	mov    %esi,(%esp)
80103f4e:	e8 dd 0e 00 00       	call   80104e30 <release>
  return i;
80103f53:	83 c4 10             	add    $0x10,%esp
}
80103f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f59:	89 d8                	mov    %ebx,%eax
80103f5b:	5b                   	pop    %ebx
80103f5c:	5e                   	pop    %esi
80103f5d:	5f                   	pop    %edi
80103f5e:	5d                   	pop    %ebp
80103f5f:	c3                   	ret    
      release(&p->lock);
80103f60:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f68:	56                   	push   %esi
80103f69:	e8 c2 0e 00 00       	call   80104e30 <release>
      return -1;
80103f6e:	83 c4 10             	add    $0x10,%esp
}
80103f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f74:	89 d8                	mov    %ebx,%eax
80103f76:	5b                   	pop    %ebx
80103f77:	5e                   	pop    %esi
80103f78:	5f                   	pop    %edi
80103f79:	5d                   	pop    %ebp
80103f7a:	c3                   	ret    
80103f7b:	66 90                	xchg   %ax,%ax
80103f7d:	66 90                	xchg   %ax,%ax
80103f7f:	90                   	nop

80103f80 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f84:	bb 34 9e 13 80       	mov    $0x80139e34,%ebx
{
80103f89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103f8c:	68 00 9e 13 80       	push   $0x80139e00
80103f91:	e8 da 0d 00 00       	call   80104d70 <acquire>
80103f96:	83 c4 10             	add    $0x10,%esp
80103f99:	eb 10                	jmp    80103fab <allocproc+0x2b>
80103f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa0:	83 c3 7c             	add    $0x7c,%ebx
80103fa3:	81 fb 34 bd 13 80    	cmp    $0x8013bd34,%ebx
80103fa9:	74 75                	je     80104020 <allocproc+0xa0>
    if(p->state == UNUSED)
80103fab:	8b 43 0c             	mov    0xc(%ebx),%eax
80103fae:	85 c0                	test   %eax,%eax
80103fb0:	75 ee                	jne    80103fa0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103fb2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103fb7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103fba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103fc1:	89 43 10             	mov    %eax,0x10(%ebx)
80103fc4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103fc7:	68 00 9e 13 80       	push   $0x80139e00
  p->pid = nextpid++;
80103fcc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103fd2:	e8 59 0e 00 00       	call   80104e30 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103fd7:	e8 44 ee ff ff       	call   80102e20 <kalloc>
80103fdc:	83 c4 10             	add    $0x10,%esp
80103fdf:	89 43 08             	mov    %eax,0x8(%ebx)
80103fe2:	85 c0                	test   %eax,%eax
80103fe4:	74 53                	je     80104039 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103fe6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103fec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103fef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ff4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ff7:	c7 40 14 b6 61 10 80 	movl   $0x801061b6,0x14(%eax)
  p->context = (struct context*)sp;
80103ffe:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104001:	6a 14                	push   $0x14
80104003:	6a 00                	push   $0x0
80104005:	50                   	push   %eax
80104006:	e8 75 0e 00 00       	call   80104e80 <memset>
  p->context->eip = (uint)forkret;
8010400b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010400e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104011:	c7 40 10 50 40 10 80 	movl   $0x80104050,0x10(%eax)
}
80104018:	89 d8                	mov    %ebx,%eax
8010401a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010401d:	c9                   	leave  
8010401e:	c3                   	ret    
8010401f:	90                   	nop
  release(&ptable.lock);
80104020:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104023:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104025:	68 00 9e 13 80       	push   $0x80139e00
8010402a:	e8 01 0e 00 00       	call   80104e30 <release>
}
8010402f:	89 d8                	mov    %ebx,%eax
  return 0;
80104031:	83 c4 10             	add    $0x10,%esp
}
80104034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104037:	c9                   	leave  
80104038:	c3                   	ret    
    p->state = UNUSED;
80104039:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104040:	31 db                	xor    %ebx,%ebx
}
80104042:	89 d8                	mov    %ebx,%eax
80104044:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104047:	c9                   	leave  
80104048:	c3                   	ret    
80104049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104050 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104050:	f3 0f 1e fb          	endbr32 
80104054:	55                   	push   %ebp
80104055:	89 e5                	mov    %esp,%ebp
80104057:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010405a:	68 00 9e 13 80       	push   $0x80139e00
8010405f:	e8 cc 0d 00 00       	call   80104e30 <release>

  if (first) {
80104064:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104069:	83 c4 10             	add    $0x10,%esp
8010406c:	85 c0                	test   %eax,%eax
8010406e:	75 08                	jne    80104078 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104070:	c9                   	leave  
80104071:	c3                   	ret    
80104072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104078:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010407f:	00 00 00 
    iinit(ROOTDEV);
80104082:	83 ec 0c             	sub    $0xc,%esp
80104085:	6a 01                	push   $0x1
80104087:	e8 b4 d4 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010408c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104093:	e8 e8 f3 ff ff       	call   80103480 <initlog>
}
80104098:	83 c4 10             	add    $0x10,%esp
8010409b:	c9                   	leave  
8010409c:	c3                   	ret    
8010409d:	8d 76 00             	lea    0x0(%esi),%esi

801040a0 <pinit>:
{
801040a0:	f3 0f 1e fb          	endbr32 
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801040aa:	68 60 82 10 80       	push   $0x80108260
801040af:	68 00 9e 13 80       	push   $0x80139e00
801040b4:	e8 37 0b 00 00       	call   80104bf0 <initlock>
}
801040b9:	83 c4 10             	add    $0x10,%esp
801040bc:	c9                   	leave  
801040bd:	c3                   	ret    
801040be:	66 90                	xchg   %ax,%ax

801040c0 <mycpu>:
{
801040c0:	f3 0f 1e fb          	endbr32 
801040c4:	55                   	push   %ebp
801040c5:	89 e5                	mov    %esp,%ebp
801040c7:	56                   	push   %esi
801040c8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040c9:	9c                   	pushf  
801040ca:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040cb:	f6 c4 02             	test   $0x2,%ah
801040ce:	75 4a                	jne    8010411a <mycpu+0x5a>
  apicid = lapicid();
801040d0:	e8 bb ef ff ff       	call   80103090 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801040d5:	8b 35 e0 9d 13 80    	mov    0x80139de0,%esi
  apicid = lapicid();
801040db:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801040dd:	85 f6                	test   %esi,%esi
801040df:	7e 2c                	jle    8010410d <mycpu+0x4d>
801040e1:	31 d2                	xor    %edx,%edx
801040e3:	eb 0a                	jmp    801040ef <mycpu+0x2f>
801040e5:	8d 76 00             	lea    0x0(%esi),%esi
801040e8:	83 c2 01             	add    $0x1,%edx
801040eb:	39 f2                	cmp    %esi,%edx
801040ed:	74 1e                	je     8010410d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801040ef:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801040f5:	0f b6 81 60 98 13 80 	movzbl -0x7fec67a0(%ecx),%eax
801040fc:	39 d8                	cmp    %ebx,%eax
801040fe:	75 e8                	jne    801040e8 <mycpu+0x28>
}
80104100:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104103:	8d 81 60 98 13 80    	lea    -0x7fec67a0(%ecx),%eax
}
80104109:	5b                   	pop    %ebx
8010410a:	5e                   	pop    %esi
8010410b:	5d                   	pop    %ebp
8010410c:	c3                   	ret    
  panic("unknown apicid\n");
8010410d:	83 ec 0c             	sub    $0xc,%esp
80104110:	68 67 82 10 80       	push   $0x80108267
80104115:	e8 76 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010411a:	83 ec 0c             	sub    $0xc,%esp
8010411d:	68 4c 83 10 80       	push   $0x8010834c
80104122:	e8 69 c2 ff ff       	call   80100390 <panic>
80104127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412e:	66 90                	xchg   %ax,%ax

80104130 <cpuid>:
cpuid() {
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010413a:	e8 81 ff ff ff       	call   801040c0 <mycpu>
}
8010413f:	c9                   	leave  
  return mycpu()-cpus;
80104140:	2d 60 98 13 80       	sub    $0x80139860,%eax
80104145:	c1 f8 04             	sar    $0x4,%eax
80104148:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010414e:	c3                   	ret    
8010414f:	90                   	nop

80104150 <myproc>:
myproc(void) {
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	53                   	push   %ebx
80104158:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010415b:	e8 10 0b 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104160:	e8 5b ff ff ff       	call   801040c0 <mycpu>
  p = c->proc;
80104165:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010416b:	e8 50 0b 00 00       	call   80104cc0 <popcli>
}
80104170:	83 c4 04             	add    $0x4,%esp
80104173:	89 d8                	mov    %ebx,%eax
80104175:	5b                   	pop    %ebx
80104176:	5d                   	pop    %ebp
80104177:	c3                   	ret    
80104178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417f:	90                   	nop

80104180 <userinit>:
{
80104180:	f3 0f 1e fb          	endbr32 
80104184:	55                   	push   %ebp
80104185:	89 e5                	mov    %esp,%ebp
80104187:	53                   	push   %ebx
80104188:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010418b:	e8 f0 fd ff ff       	call   80103f80 <allocproc>
80104190:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104192:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104197:	e8 24 37 00 00       	call   801078c0 <setupkvm>
8010419c:	89 43 04             	mov    %eax,0x4(%ebx)
8010419f:	85 c0                	test   %eax,%eax
801041a1:	0f 84 e5 00 00 00    	je     8010428c <userinit+0x10c>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
801041a7:	83 ec 04             	sub    $0x4,%esp
801041aa:	68 2c 00 00 00       	push   $0x2c
801041af:	68 60 b4 10 80       	push   $0x8010b460
801041b4:	68 90 82 10 80       	push   $0x80108290
801041b9:	e8 f2 c4 ff ff       	call   801006b0 <cprintf>
  cprintf("userinit: call inituvm p->pgdir %p\n", p->pgdir);
801041be:	58                   	pop    %eax
801041bf:	5a                   	pop    %edx
801041c0:	ff 73 04             	pushl  0x4(%ebx)
801041c3:	68 74 83 10 80       	push   $0x80108374
801041c8:	e8 e3 c4 ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801041cd:	83 c4 0c             	add    $0xc,%esp
801041d0:	68 2c 00 00 00       	push   $0x2c
801041d5:	68 60 b4 10 80       	push   $0x8010b460
801041da:	ff 73 04             	pushl  0x4(%ebx)
801041dd:	e8 8e 33 00 00       	call   80107570 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801041e2:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801041e5:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801041eb:	6a 4c                	push   $0x4c
801041ed:	6a 00                	push   $0x0
801041ef:	ff 73 18             	pushl  0x18(%ebx)
801041f2:	e8 89 0c 00 00       	call   80104e80 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041f7:	8b 43 18             	mov    0x18(%ebx),%eax
801041fa:	b9 1b 00 00 00       	mov    $0x1b,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041ff:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104202:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104207:	66 89 48 3c          	mov    %cx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010420b:	8b 43 18             	mov    0x18(%ebx),%eax
8010420e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104212:	8b 43 18             	mov    0x18(%ebx),%eax
80104215:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104219:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010421d:	8b 43 18             	mov    0x18(%ebx),%eax
80104220:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104224:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104228:	8b 43 18             	mov    0x18(%ebx),%eax
8010422b:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104232:	8b 43 18             	mov    0x18(%ebx),%eax
80104235:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010423c:	8b 43 18             	mov    0x18(%ebx),%eax
8010423f:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104246:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104249:	6a 10                	push   $0x10
8010424b:	68 97 82 10 80       	push   $0x80108297
80104250:	50                   	push   %eax
80104251:	e8 ea 0d 00 00       	call   80105040 <safestrcpy>
  p->cwd = namei("/");
80104256:	c7 04 24 a0 82 10 80 	movl   $0x801082a0,(%esp)
8010425d:	e8 ce dd ff ff       	call   80102030 <namei>
80104262:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104265:	c7 04 24 00 9e 13 80 	movl   $0x80139e00,(%esp)
8010426c:	e8 ff 0a 00 00       	call   80104d70 <acquire>
  p->state = RUNNABLE;
80104271:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104278:	c7 04 24 00 9e 13 80 	movl   $0x80139e00,(%esp)
8010427f:	e8 ac 0b 00 00       	call   80104e30 <release>
}
80104284:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	c9                   	leave  
8010428b:	c3                   	ret    
    panic("userinit: out of memory?");
8010428c:	83 ec 0c             	sub    $0xc,%esp
8010428f:	68 77 82 10 80       	push   $0x80108277
80104294:	e8 f7 c0 ff ff       	call   80100390 <panic>
80104299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042a0 <growproc>:
{
801042a0:	f3 0f 1e fb          	endbr32 
801042a4:	55                   	push   %ebp
801042a5:	89 e5                	mov    %esp,%ebp
801042a7:	56                   	push   %esi
801042a8:	53                   	push   %ebx
801042a9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801042ac:	e8 bf 09 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801042b1:	e8 0a fe ff ff       	call   801040c0 <mycpu>
  p = c->proc;
801042b6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042bc:	e8 ff 09 00 00       	call   80104cc0 <popcli>
  sz = curproc->sz;
801042c1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801042c3:	85 f6                	test   %esi,%esi
801042c5:	7f 19                	jg     801042e0 <growproc+0x40>
  } else if(n < 0){
801042c7:	75 37                	jne    80104300 <growproc+0x60>
  switchuvm(curproc);
801042c9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801042cc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801042ce:	53                   	push   %ebx
801042cf:	e8 8c 31 00 00       	call   80107460 <switchuvm>
  return 0;
801042d4:	83 c4 10             	add    $0x10,%esp
801042d7:	31 c0                	xor    %eax,%eax
}
801042d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042dc:	5b                   	pop    %ebx
801042dd:	5e                   	pop    %esi
801042de:	5d                   	pop    %ebp
801042df:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801042e0:	83 ec 04             	sub    $0x4,%esp
801042e3:	01 c6                	add    %eax,%esi
801042e5:	56                   	push   %esi
801042e6:	50                   	push   %eax
801042e7:	ff 73 04             	pushl  0x4(%ebx)
801042ea:	e8 e1 33 00 00       	call   801076d0 <allocuvm>
801042ef:	83 c4 10             	add    $0x10,%esp
801042f2:	85 c0                	test   %eax,%eax
801042f4:	75 d3                	jne    801042c9 <growproc+0x29>
      return -1;
801042f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042fb:	eb dc                	jmp    801042d9 <growproc+0x39>
801042fd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104300:	83 ec 04             	sub    $0x4,%esp
80104303:	01 c6                	add    %eax,%esi
80104305:	56                   	push   %esi
80104306:	50                   	push   %eax
80104307:	ff 73 04             	pushl  0x4(%ebx)
8010430a:	e8 01 35 00 00       	call   80107810 <deallocuvm>
8010430f:	83 c4 10             	add    $0x10,%esp
80104312:	85 c0                	test   %eax,%eax
80104314:	75 b3                	jne    801042c9 <growproc+0x29>
80104316:	eb de                	jmp    801042f6 <growproc+0x56>
80104318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431f:	90                   	nop

80104320 <fork>:
{
80104320:	f3 0f 1e fb          	endbr32 
80104324:	55                   	push   %ebp
80104325:	89 e5                	mov    %esp,%ebp
80104327:	57                   	push   %edi
80104328:	56                   	push   %esi
80104329:	53                   	push   %ebx
8010432a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010432d:	e8 3e 09 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104332:	e8 89 fd ff ff       	call   801040c0 <mycpu>
  p = c->proc;
80104337:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010433d:	e8 7e 09 00 00       	call   80104cc0 <popcli>
  if((np = allocproc()) == 0){
80104342:	e8 39 fc ff ff       	call   80103f80 <allocproc>
80104347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010434a:	85 c0                	test   %eax,%eax
8010434c:	0f 84 bb 00 00 00    	je     8010440d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104352:	83 ec 08             	sub    $0x8,%esp
80104355:	ff 33                	pushl  (%ebx)
80104357:	89 c7                	mov    %eax,%edi
80104359:	ff 73 04             	pushl  0x4(%ebx)
8010435c:	e8 2f 36 00 00       	call   80107990 <copyuvm>
80104361:	83 c4 10             	add    $0x10,%esp
80104364:	89 47 04             	mov    %eax,0x4(%edi)
80104367:	85 c0                	test   %eax,%eax
80104369:	0f 84 a5 00 00 00    	je     80104414 <fork+0xf4>
  np->sz = curproc->sz;
8010436f:	8b 03                	mov    (%ebx),%eax
80104371:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104374:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104376:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104379:	89 c8                	mov    %ecx,%eax
8010437b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010437e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104383:	8b 73 18             	mov    0x18(%ebx),%esi
80104386:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104388:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010438a:	8b 40 18             	mov    0x18(%eax),%eax
8010438d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104398:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010439c:	85 c0                	test   %eax,%eax
8010439e:	74 13                	je     801043b3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	50                   	push   %eax
801043a4:	e8 c7 ca ff ff       	call   80100e70 <filedup>
801043a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043ac:	83 c4 10             	add    $0x10,%esp
801043af:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801043b3:	83 c6 01             	add    $0x1,%esi
801043b6:	83 fe 10             	cmp    $0x10,%esi
801043b9:	75 dd                	jne    80104398 <fork+0x78>
  np->cwd = idup(curproc->cwd);
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043c1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801043c4:	e8 67 d3 ff ff       	call   80101730 <idup>
801043c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043cc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801043cf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043d2:	8d 47 6c             	lea    0x6c(%edi),%eax
801043d5:	6a 10                	push   $0x10
801043d7:	53                   	push   %ebx
801043d8:	50                   	push   %eax
801043d9:	e8 62 0c 00 00       	call   80105040 <safestrcpy>
  pid = np->pid;
801043de:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801043e1:	c7 04 24 00 9e 13 80 	movl   $0x80139e00,(%esp)
801043e8:	e8 83 09 00 00       	call   80104d70 <acquire>
  np->state = RUNNABLE;
801043ed:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801043f4:	c7 04 24 00 9e 13 80 	movl   $0x80139e00,(%esp)
801043fb:	e8 30 0a 00 00       	call   80104e30 <release>
  return pid;
80104400:	83 c4 10             	add    $0x10,%esp
}
80104403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104406:	89 d8                	mov    %ebx,%eax
80104408:	5b                   	pop    %ebx
80104409:	5e                   	pop    %esi
8010440a:	5f                   	pop    %edi
8010440b:	5d                   	pop    %ebp
8010440c:	c3                   	ret    
    return -1;
8010440d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104412:	eb ef                	jmp    80104403 <fork+0xe3>
    kfree(np->kstack);
80104414:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104417:	83 ec 0c             	sub    $0xc,%esp
8010441a:	ff 73 08             	pushl  0x8(%ebx)
8010441d:	e8 8e e5 ff ff       	call   801029b0 <kfree>
    np->kstack = 0;
80104422:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104429:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010442c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104433:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104438:	eb c9                	jmp    80104403 <fork+0xe3>
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <scheduler>:
{
80104440:	f3 0f 1e fb          	endbr32 
80104444:	55                   	push   %ebp
80104445:	89 e5                	mov    %esp,%ebp
80104447:	57                   	push   %edi
80104448:	56                   	push   %esi
80104449:	53                   	push   %ebx
8010444a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010444d:	e8 6e fc ff ff       	call   801040c0 <mycpu>
  c->proc = 0;
80104452:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104459:	00 00 00 
  struct cpu *c = mycpu();
8010445c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010445e:	8d 78 04             	lea    0x4(%eax),%edi
80104461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104468:	fb                   	sti    
    acquire(&ptable.lock);
80104469:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010446c:	bb 34 9e 13 80       	mov    $0x80139e34,%ebx
    acquire(&ptable.lock);
80104471:	68 00 9e 13 80       	push   $0x80139e00
80104476:	e8 f5 08 00 00       	call   80104d70 <acquire>
8010447b:	83 c4 10             	add    $0x10,%esp
8010447e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104480:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104484:	75 33                	jne    801044b9 <scheduler+0x79>
      switchuvm(p);
80104486:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104489:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010448f:	53                   	push   %ebx
80104490:	e8 cb 2f 00 00       	call   80107460 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104495:	58                   	pop    %eax
80104496:	5a                   	pop    %edx
80104497:	ff 73 1c             	pushl  0x1c(%ebx)
8010449a:	57                   	push   %edi
      p->state = RUNNING;
8010449b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801044a2:	e8 fc 0b 00 00       	call   801050a3 <swtch>
      switchkvm();
801044a7:	e8 94 2f 00 00       	call   80107440 <switchkvm>
      c->proc = 0;
801044ac:	83 c4 10             	add    $0x10,%esp
801044af:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801044b6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b9:	83 c3 7c             	add    $0x7c,%ebx
801044bc:	81 fb 34 bd 13 80    	cmp    $0x8013bd34,%ebx
801044c2:	75 bc                	jne    80104480 <scheduler+0x40>
    release(&ptable.lock);
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	68 00 9e 13 80       	push   $0x80139e00
801044cc:	e8 5f 09 00 00       	call   80104e30 <release>
    sti();
801044d1:	83 c4 10             	add    $0x10,%esp
801044d4:	eb 92                	jmp    80104468 <scheduler+0x28>
801044d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044dd:	8d 76 00             	lea    0x0(%esi),%esi

801044e0 <sched>:
{
801044e0:	f3 0f 1e fb          	endbr32 
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
801044e7:	56                   	push   %esi
801044e8:	53                   	push   %ebx
  pushcli();
801044e9:	e8 82 07 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801044ee:	e8 cd fb ff ff       	call   801040c0 <mycpu>
  p = c->proc;
801044f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f9:	e8 c2 07 00 00       	call   80104cc0 <popcli>
  if(!holding(&ptable.lock))
801044fe:	83 ec 0c             	sub    $0xc,%esp
80104501:	68 00 9e 13 80       	push   $0x80139e00
80104506:	e8 15 08 00 00       	call   80104d20 <holding>
8010450b:	83 c4 10             	add    $0x10,%esp
8010450e:	85 c0                	test   %eax,%eax
80104510:	74 4f                	je     80104561 <sched+0x81>
  if(mycpu()->ncli != 1)
80104512:	e8 a9 fb ff ff       	call   801040c0 <mycpu>
80104517:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010451e:	75 68                	jne    80104588 <sched+0xa8>
  if(p->state == RUNNING)
80104520:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104524:	74 55                	je     8010457b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104526:	9c                   	pushf  
80104527:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104528:	f6 c4 02             	test   $0x2,%ah
8010452b:	75 41                	jne    8010456e <sched+0x8e>
  intena = mycpu()->intena;
8010452d:	e8 8e fb ff ff       	call   801040c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104532:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104535:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010453b:	e8 80 fb ff ff       	call   801040c0 <mycpu>
80104540:	83 ec 08             	sub    $0x8,%esp
80104543:	ff 70 04             	pushl  0x4(%eax)
80104546:	53                   	push   %ebx
80104547:	e8 57 0b 00 00       	call   801050a3 <swtch>
  mycpu()->intena = intena;
8010454c:	e8 6f fb ff ff       	call   801040c0 <mycpu>
}
80104551:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104554:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010455a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010455d:	5b                   	pop    %ebx
8010455e:	5e                   	pop    %esi
8010455f:	5d                   	pop    %ebp
80104560:	c3                   	ret    
    panic("sched ptable.lock");
80104561:	83 ec 0c             	sub    $0xc,%esp
80104564:	68 a2 82 10 80       	push   $0x801082a2
80104569:	e8 22 be ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010456e:	83 ec 0c             	sub    $0xc,%esp
80104571:	68 ce 82 10 80       	push   $0x801082ce
80104576:	e8 15 be ff ff       	call   80100390 <panic>
    panic("sched running");
8010457b:	83 ec 0c             	sub    $0xc,%esp
8010457e:	68 c0 82 10 80       	push   $0x801082c0
80104583:	e8 08 be ff ff       	call   80100390 <panic>
    panic("sched locks");
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	68 b4 82 10 80       	push   $0x801082b4
80104590:	e8 fb bd ff ff       	call   80100390 <panic>
80104595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <exit>:
{
801045a0:	f3 0f 1e fb          	endbr32 
801045a4:	55                   	push   %ebp
801045a5:	89 e5                	mov    %esp,%ebp
801045a7:	57                   	push   %edi
801045a8:	56                   	push   %esi
801045a9:	53                   	push   %ebx
801045aa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045ad:	e8 be 06 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801045b2:	e8 09 fb ff ff       	call   801040c0 <mycpu>
  p = c->proc;
801045b7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045bd:	e8 fe 06 00 00       	call   80104cc0 <popcli>
  if(curproc == initproc)
801045c2:	8d 5e 28             	lea    0x28(%esi),%ebx
801045c5:	8d 7e 68             	lea    0x68(%esi),%edi
801045c8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801045ce:	0f 84 f3 00 00 00    	je     801046c7 <exit+0x127>
801045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801045d8:	8b 03                	mov    (%ebx),%eax
801045da:	85 c0                	test   %eax,%eax
801045dc:	74 12                	je     801045f0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801045de:	83 ec 0c             	sub    $0xc,%esp
801045e1:	50                   	push   %eax
801045e2:	e8 d9 c8 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
801045e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801045ed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801045f0:	83 c3 04             	add    $0x4,%ebx
801045f3:	39 df                	cmp    %ebx,%edi
801045f5:	75 e1                	jne    801045d8 <exit+0x38>
  begin_op();
801045f7:	e8 24 ef ff ff       	call   80103520 <begin_op>
  iput(curproc->cwd);
801045fc:	83 ec 0c             	sub    $0xc,%esp
801045ff:	ff 76 68             	pushl  0x68(%esi)
80104602:	e8 89 d2 ff ff       	call   80101890 <iput>
  end_op();
80104607:	e8 84 ef ff ff       	call   80103590 <end_op>
  curproc->cwd = 0;
8010460c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104613:	c7 04 24 00 9e 13 80 	movl   $0x80139e00,(%esp)
8010461a:	e8 51 07 00 00       	call   80104d70 <acquire>
  wakeup1(curproc->parent);
8010461f:	8b 56 14             	mov    0x14(%esi),%edx
80104622:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104625:	b8 34 9e 13 80       	mov    $0x80139e34,%eax
8010462a:	eb 0e                	jmp    8010463a <exit+0x9a>
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104630:	83 c0 7c             	add    $0x7c,%eax
80104633:	3d 34 bd 13 80       	cmp    $0x8013bd34,%eax
80104638:	74 1c                	je     80104656 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
8010463a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010463e:	75 f0                	jne    80104630 <exit+0x90>
80104640:	3b 50 20             	cmp    0x20(%eax),%edx
80104643:	75 eb                	jne    80104630 <exit+0x90>
      p->state = RUNNABLE;
80104645:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010464c:	83 c0 7c             	add    $0x7c,%eax
8010464f:	3d 34 bd 13 80       	cmp    $0x8013bd34,%eax
80104654:	75 e4                	jne    8010463a <exit+0x9a>
      p->parent = initproc;
80104656:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465c:	ba 34 9e 13 80       	mov    $0x80139e34,%edx
80104661:	eb 10                	jmp    80104673 <exit+0xd3>
80104663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104667:	90                   	nop
80104668:	83 c2 7c             	add    $0x7c,%edx
8010466b:	81 fa 34 bd 13 80    	cmp    $0x8013bd34,%edx
80104671:	74 3b                	je     801046ae <exit+0x10e>
    if(p->parent == curproc){
80104673:	39 72 14             	cmp    %esi,0x14(%edx)
80104676:	75 f0                	jne    80104668 <exit+0xc8>
      if(p->state == ZOMBIE)
80104678:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010467c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010467f:	75 e7                	jne    80104668 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104681:	b8 34 9e 13 80       	mov    $0x80139e34,%eax
80104686:	eb 12                	jmp    8010469a <exit+0xfa>
80104688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop
80104690:	83 c0 7c             	add    $0x7c,%eax
80104693:	3d 34 bd 13 80       	cmp    $0x8013bd34,%eax
80104698:	74 ce                	je     80104668 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010469a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010469e:	75 f0                	jne    80104690 <exit+0xf0>
801046a0:	3b 48 20             	cmp    0x20(%eax),%ecx
801046a3:	75 eb                	jne    80104690 <exit+0xf0>
      p->state = RUNNABLE;
801046a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046ac:	eb e2                	jmp    80104690 <exit+0xf0>
  curproc->state = ZOMBIE;
801046ae:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801046b5:	e8 26 fe ff ff       	call   801044e0 <sched>
  panic("zombie exit");
801046ba:	83 ec 0c             	sub    $0xc,%esp
801046bd:	68 ef 82 10 80       	push   $0x801082ef
801046c2:	e8 c9 bc ff ff       	call   80100390 <panic>
    panic("init exiting");
801046c7:	83 ec 0c             	sub    $0xc,%esp
801046ca:	68 e2 82 10 80       	push   $0x801082e2
801046cf:	e8 bc bc ff ff       	call   80100390 <panic>
801046d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <yield>:
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	53                   	push   %ebx
801046e8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801046eb:	68 00 9e 13 80       	push   $0x80139e00
801046f0:	e8 7b 06 00 00       	call   80104d70 <acquire>
  pushcli();
801046f5:	e8 76 05 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801046fa:	e8 c1 f9 ff ff       	call   801040c0 <mycpu>
  p = c->proc;
801046ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104705:	e8 b6 05 00 00       	call   80104cc0 <popcli>
  myproc()->state = RUNNABLE;
8010470a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104711:	e8 ca fd ff ff       	call   801044e0 <sched>
  release(&ptable.lock);
80104716:	c7 04 24 00 9e 13 80 	movl   $0x80139e00,(%esp)
8010471d:	e8 0e 07 00 00       	call   80104e30 <release>
}
80104722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104725:	83 c4 10             	add    $0x10,%esp
80104728:	c9                   	leave  
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <sleep>:
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	57                   	push   %edi
80104738:	56                   	push   %esi
80104739:	53                   	push   %ebx
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104740:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104743:	e8 28 05 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104748:	e8 73 f9 ff ff       	call   801040c0 <mycpu>
  p = c->proc;
8010474d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104753:	e8 68 05 00 00       	call   80104cc0 <popcli>
  if(p == 0)
80104758:	85 db                	test   %ebx,%ebx
8010475a:	0f 84 83 00 00 00    	je     801047e3 <sleep+0xb3>
  if(lk == 0)
80104760:	85 f6                	test   %esi,%esi
80104762:	74 72                	je     801047d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104764:	81 fe 00 9e 13 80    	cmp    $0x80139e00,%esi
8010476a:	74 4c                	je     801047b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010476c:	83 ec 0c             	sub    $0xc,%esp
8010476f:	68 00 9e 13 80       	push   $0x80139e00
80104774:	e8 f7 05 00 00       	call   80104d70 <acquire>
    release(lk);
80104779:	89 34 24             	mov    %esi,(%esp)
8010477c:	e8 af 06 00 00       	call   80104e30 <release>
  p->chan = chan;
80104781:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104784:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010478b:	e8 50 fd ff ff       	call   801044e0 <sched>
  p->chan = 0;
80104790:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104797:	c7 04 24 00 9e 13 80 	movl   $0x80139e00,(%esp)
8010479e:	e8 8d 06 00 00       	call   80104e30 <release>
    acquire(lk);
801047a3:	89 75 08             	mov    %esi,0x8(%ebp)
801047a6:	83 c4 10             	add    $0x10,%esp
}
801047a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ac:	5b                   	pop    %ebx
801047ad:	5e                   	pop    %esi
801047ae:	5f                   	pop    %edi
801047af:	5d                   	pop    %ebp
    acquire(lk);
801047b0:	e9 bb 05 00 00       	jmp    80104d70 <acquire>
801047b5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801047b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047c2:	e8 19 fd ff ff       	call   801044e0 <sched>
  p->chan = 0;
801047c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801047ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047d1:	5b                   	pop    %ebx
801047d2:	5e                   	pop    %esi
801047d3:	5f                   	pop    %edi
801047d4:	5d                   	pop    %ebp
801047d5:	c3                   	ret    
    panic("sleep without lk");
801047d6:	83 ec 0c             	sub    $0xc,%esp
801047d9:	68 01 83 10 80       	push   $0x80108301
801047de:	e8 ad bb ff ff       	call   80100390 <panic>
    panic("sleep");
801047e3:	83 ec 0c             	sub    $0xc,%esp
801047e6:	68 fb 82 10 80       	push   $0x801082fb
801047eb:	e8 a0 bb ff ff       	call   80100390 <panic>

801047f0 <wait>:
{
801047f0:	f3 0f 1e fb          	endbr32 
801047f4:	55                   	push   %ebp
801047f5:	89 e5                	mov    %esp,%ebp
801047f7:	56                   	push   %esi
801047f8:	53                   	push   %ebx
  pushcli();
801047f9:	e8 72 04 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801047fe:	e8 bd f8 ff ff       	call   801040c0 <mycpu>
  p = c->proc;
80104803:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104809:	e8 b2 04 00 00       	call   80104cc0 <popcli>
  acquire(&ptable.lock);
8010480e:	83 ec 0c             	sub    $0xc,%esp
80104811:	68 00 9e 13 80       	push   $0x80139e00
80104816:	e8 55 05 00 00       	call   80104d70 <acquire>
8010481b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010481e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104820:	bb 34 9e 13 80       	mov    $0x80139e34,%ebx
80104825:	eb 14                	jmp    8010483b <wait+0x4b>
80104827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482e:	66 90                	xchg   %ax,%ax
80104830:	83 c3 7c             	add    $0x7c,%ebx
80104833:	81 fb 34 bd 13 80    	cmp    $0x8013bd34,%ebx
80104839:	74 1b                	je     80104856 <wait+0x66>
      if(p->parent != curproc)
8010483b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010483e:	75 f0                	jne    80104830 <wait+0x40>
      if(p->state == ZOMBIE){
80104840:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104844:	74 32                	je     80104878 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104846:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104849:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010484e:	81 fb 34 bd 13 80    	cmp    $0x8013bd34,%ebx
80104854:	75 e5                	jne    8010483b <wait+0x4b>
    if(!havekids || curproc->killed){
80104856:	85 c0                	test   %eax,%eax
80104858:	74 74                	je     801048ce <wait+0xde>
8010485a:	8b 46 24             	mov    0x24(%esi),%eax
8010485d:	85 c0                	test   %eax,%eax
8010485f:	75 6d                	jne    801048ce <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104861:	83 ec 08             	sub    $0x8,%esp
80104864:	68 00 9e 13 80       	push   $0x80139e00
80104869:	56                   	push   %esi
8010486a:	e8 c1 fe ff ff       	call   80104730 <sleep>
    havekids = 0;
8010486f:	83 c4 10             	add    $0x10,%esp
80104872:	eb aa                	jmp    8010481e <wait+0x2e>
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104878:	83 ec 0c             	sub    $0xc,%esp
8010487b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010487e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104881:	e8 2a e1 ff ff       	call   801029b0 <kfree>
        freevm(p->pgdir);
80104886:	5a                   	pop    %edx
80104887:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010488a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104891:	e8 aa 2f 00 00       	call   80107840 <freevm>
        release(&ptable.lock);
80104896:	c7 04 24 00 9e 13 80 	movl   $0x80139e00,(%esp)
        p->pid = 0;
8010489d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801048a4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801048ab:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801048af:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801048b6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801048bd:	e8 6e 05 00 00       	call   80104e30 <release>
        return pid;
801048c2:	83 c4 10             	add    $0x10,%esp
}
801048c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048c8:	89 f0                	mov    %esi,%eax
801048ca:	5b                   	pop    %ebx
801048cb:	5e                   	pop    %esi
801048cc:	5d                   	pop    %ebp
801048cd:	c3                   	ret    
      release(&ptable.lock);
801048ce:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048d1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801048d6:	68 00 9e 13 80       	push   $0x80139e00
801048db:	e8 50 05 00 00       	call   80104e30 <release>
      return -1;
801048e0:	83 c4 10             	add    $0x10,%esp
801048e3:	eb e0                	jmp    801048c5 <wait+0xd5>
801048e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	53                   	push   %ebx
801048f8:	83 ec 10             	sub    $0x10,%esp
801048fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048fe:	68 00 9e 13 80       	push   $0x80139e00
80104903:	e8 68 04 00 00       	call   80104d70 <acquire>
80104908:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010490b:	b8 34 9e 13 80       	mov    $0x80139e34,%eax
80104910:	eb 10                	jmp    80104922 <wakeup+0x32>
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104918:	83 c0 7c             	add    $0x7c,%eax
8010491b:	3d 34 bd 13 80       	cmp    $0x8013bd34,%eax
80104920:	74 1c                	je     8010493e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104922:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104926:	75 f0                	jne    80104918 <wakeup+0x28>
80104928:	3b 58 20             	cmp    0x20(%eax),%ebx
8010492b:	75 eb                	jne    80104918 <wakeup+0x28>
      p->state = RUNNABLE;
8010492d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104934:	83 c0 7c             	add    $0x7c,%eax
80104937:	3d 34 bd 13 80       	cmp    $0x8013bd34,%eax
8010493c:	75 e4                	jne    80104922 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010493e:	c7 45 08 00 9e 13 80 	movl   $0x80139e00,0x8(%ebp)
}
80104945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104948:	c9                   	leave  
  release(&ptable.lock);
80104949:	e9 e2 04 00 00       	jmp    80104e30 <release>
8010494e:	66 90                	xchg   %ax,%ax

80104950 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	53                   	push   %ebx
80104958:	83 ec 10             	sub    $0x10,%esp
8010495b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010495e:	68 00 9e 13 80       	push   $0x80139e00
80104963:	e8 08 04 00 00       	call   80104d70 <acquire>
80104968:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010496b:	b8 34 9e 13 80       	mov    $0x80139e34,%eax
80104970:	eb 10                	jmp    80104982 <kill+0x32>
80104972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104978:	83 c0 7c             	add    $0x7c,%eax
8010497b:	3d 34 bd 13 80       	cmp    $0x8013bd34,%eax
80104980:	74 36                	je     801049b8 <kill+0x68>
    if(p->pid == pid){
80104982:	39 58 10             	cmp    %ebx,0x10(%eax)
80104985:	75 f1                	jne    80104978 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104987:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010498b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104992:	75 07                	jne    8010499b <kill+0x4b>
        p->state = RUNNABLE;
80104994:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010499b:	83 ec 0c             	sub    $0xc,%esp
8010499e:	68 00 9e 13 80       	push   $0x80139e00
801049a3:	e8 88 04 00 00       	call   80104e30 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801049a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801049ab:	83 c4 10             	add    $0x10,%esp
801049ae:	31 c0                	xor    %eax,%eax
}
801049b0:	c9                   	leave  
801049b1:	c3                   	ret    
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801049b8:	83 ec 0c             	sub    $0xc,%esp
801049bb:	68 00 9e 13 80       	push   $0x80139e00
801049c0:	e8 6b 04 00 00       	call   80104e30 <release>
}
801049c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801049c8:	83 c4 10             	add    $0x10,%esp
801049cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049d0:	c9                   	leave  
801049d1:	c3                   	ret    
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	57                   	push   %edi
801049e8:	56                   	push   %esi
801049e9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801049ec:	53                   	push   %ebx
801049ed:	bb a0 9e 13 80       	mov    $0x80139ea0,%ebx
801049f2:	83 ec 3c             	sub    $0x3c,%esp
801049f5:	eb 28                	jmp    80104a1f <procdump+0x3f>
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a00:	83 ec 0c             	sub    $0xc,%esp
80104a03:	68 3d 7f 10 80       	push   $0x80107f3d
80104a08:	e8 a3 bc ff ff       	call   801006b0 <cprintf>
80104a0d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a10:	83 c3 7c             	add    $0x7c,%ebx
80104a13:	81 fb a0 bd 13 80    	cmp    $0x8013bda0,%ebx
80104a19:	0f 84 81 00 00 00    	je     80104aa0 <procdump+0xc0>
    if(p->state == UNUSED)
80104a1f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a22:	85 c0                	test   %eax,%eax
80104a24:	74 ea                	je     80104a10 <procdump+0x30>
      state = "???";
80104a26:	ba 12 83 10 80       	mov    $0x80108312,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a2b:	83 f8 05             	cmp    $0x5,%eax
80104a2e:	77 11                	ja     80104a41 <procdump+0x61>
80104a30:	8b 14 85 98 83 10 80 	mov    -0x7fef7c68(,%eax,4),%edx
      state = "???";
80104a37:	b8 12 83 10 80       	mov    $0x80108312,%eax
80104a3c:	85 d2                	test   %edx,%edx
80104a3e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104a41:	53                   	push   %ebx
80104a42:	52                   	push   %edx
80104a43:	ff 73 a4             	pushl  -0x5c(%ebx)
80104a46:	68 16 83 10 80       	push   $0x80108316
80104a4b:	e8 60 bc ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104a50:	83 c4 10             	add    $0x10,%esp
80104a53:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104a57:	75 a7                	jne    80104a00 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a59:	83 ec 08             	sub    $0x8,%esp
80104a5c:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a5f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a62:	50                   	push   %eax
80104a63:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a66:	8b 40 0c             	mov    0xc(%eax),%eax
80104a69:	83 c0 08             	add    $0x8,%eax
80104a6c:	50                   	push   %eax
80104a6d:	e8 9e 01 00 00       	call   80104c10 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a72:	83 c4 10             	add    $0x10,%esp
80104a75:	8d 76 00             	lea    0x0(%esi),%esi
80104a78:	8b 17                	mov    (%edi),%edx
80104a7a:	85 d2                	test   %edx,%edx
80104a7c:	74 82                	je     80104a00 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104a7e:	83 ec 08             	sub    $0x8,%esp
80104a81:	83 c7 04             	add    $0x4,%edi
80104a84:	52                   	push   %edx
80104a85:	68 a1 7b 10 80       	push   $0x80107ba1
80104a8a:	e8 21 bc ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a8f:	83 c4 10             	add    $0x10,%esp
80104a92:	39 fe                	cmp    %edi,%esi
80104a94:	75 e2                	jne    80104a78 <procdump+0x98>
80104a96:	e9 65 ff ff ff       	jmp    80104a00 <procdump+0x20>
80104a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop
  }
}
80104aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa3:	5b                   	pop    %ebx
80104aa4:	5e                   	pop    %esi
80104aa5:	5f                   	pop    %edi
80104aa6:	5d                   	pop    %ebp
80104aa7:	c3                   	ret    
80104aa8:	66 90                	xchg   %ax,%ax
80104aaa:	66 90                	xchg   %ax,%ax
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	53                   	push   %ebx
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104abe:	68 b0 83 10 80       	push   $0x801083b0
80104ac3:	8d 43 04             	lea    0x4(%ebx),%eax
80104ac6:	50                   	push   %eax
80104ac7:	e8 24 01 00 00       	call   80104bf0 <initlock>
  lk->name = name;
80104acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104acf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ad5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ad8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104adf:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae5:	c9                   	leave  
80104ae6:	c3                   	ret    
80104ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	56                   	push   %esi
80104af8:	53                   	push   %ebx
80104af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104afc:	8d 73 04             	lea    0x4(%ebx),%esi
80104aff:	83 ec 0c             	sub    $0xc,%esp
80104b02:	56                   	push   %esi
80104b03:	e8 68 02 00 00       	call   80104d70 <acquire>
  while (lk->locked) {
80104b08:	8b 13                	mov    (%ebx),%edx
80104b0a:	83 c4 10             	add    $0x10,%esp
80104b0d:	85 d2                	test   %edx,%edx
80104b0f:	74 1a                	je     80104b2b <acquiresleep+0x3b>
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104b18:	83 ec 08             	sub    $0x8,%esp
80104b1b:	56                   	push   %esi
80104b1c:	53                   	push   %ebx
80104b1d:	e8 0e fc ff ff       	call   80104730 <sleep>
  while (lk->locked) {
80104b22:	8b 03                	mov    (%ebx),%eax
80104b24:	83 c4 10             	add    $0x10,%esp
80104b27:	85 c0                	test   %eax,%eax
80104b29:	75 ed                	jne    80104b18 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104b2b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b31:	e8 1a f6 ff ff       	call   80104150 <myproc>
80104b36:	8b 40 10             	mov    0x10(%eax),%eax
80104b39:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b3c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b42:	5b                   	pop    %ebx
80104b43:	5e                   	pop    %esi
80104b44:	5d                   	pop    %ebp
  release(&lk->lk);
80104b45:	e9 e6 02 00 00       	jmp    80104e30 <release>
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	56                   	push   %esi
80104b58:	53                   	push   %ebx
80104b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b5c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b5f:	83 ec 0c             	sub    $0xc,%esp
80104b62:	56                   	push   %esi
80104b63:	e8 08 02 00 00       	call   80104d70 <acquire>
  lk->locked = 0;
80104b68:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b6e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b75:	89 1c 24             	mov    %ebx,(%esp)
80104b78:	e8 73 fd ff ff       	call   801048f0 <wakeup>
  release(&lk->lk);
80104b7d:	89 75 08             	mov    %esi,0x8(%ebp)
80104b80:	83 c4 10             	add    $0x10,%esp
}
80104b83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b86:	5b                   	pop    %ebx
80104b87:	5e                   	pop    %esi
80104b88:	5d                   	pop    %ebp
  release(&lk->lk);
80104b89:	e9 a2 02 00 00       	jmp    80104e30 <release>
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	57                   	push   %edi
80104b98:	31 ff                	xor    %edi,%edi
80104b9a:	56                   	push   %esi
80104b9b:	53                   	push   %ebx
80104b9c:	83 ec 18             	sub    $0x18,%esp
80104b9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ba2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ba5:	56                   	push   %esi
80104ba6:	e8 c5 01 00 00       	call   80104d70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104bab:	8b 03                	mov    (%ebx),%eax
80104bad:	83 c4 10             	add    $0x10,%esp
80104bb0:	85 c0                	test   %eax,%eax
80104bb2:	75 1c                	jne    80104bd0 <holdingsleep+0x40>
  release(&lk->lk);
80104bb4:	83 ec 0c             	sub    $0xc,%esp
80104bb7:	56                   	push   %esi
80104bb8:	e8 73 02 00 00       	call   80104e30 <release>
  return r;
}
80104bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bc0:	89 f8                	mov    %edi,%eax
80104bc2:	5b                   	pop    %ebx
80104bc3:	5e                   	pop    %esi
80104bc4:	5f                   	pop    %edi
80104bc5:	5d                   	pop    %ebp
80104bc6:	c3                   	ret    
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104bd0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104bd3:	e8 78 f5 ff ff       	call   80104150 <myproc>
80104bd8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bdb:	0f 94 c0             	sete   %al
80104bde:	0f b6 c0             	movzbl %al,%eax
80104be1:	89 c7                	mov    %eax,%edi
80104be3:	eb cf                	jmp    80104bb4 <holdingsleep+0x24>
80104be5:	66 90                	xchg   %ax,%ax
80104be7:	66 90                	xchg   %ax,%ax
80104be9:	66 90                	xchg   %ax,%ax
80104beb:	66 90                	xchg   %ax,%ax
80104bed:	66 90                	xchg   %ax,%ax
80104bef:	90                   	nop

80104bf0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104bfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c03:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c0d:	5d                   	pop    %ebp
80104c0e:	c3                   	ret    
80104c0f:	90                   	nop

80104c10 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c15:	31 d2                	xor    %edx,%edx
{
80104c17:	89 e5                	mov    %esp,%ebp
80104c19:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c1a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c20:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c27:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c28:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c2e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c34:	77 1a                	ja     80104c50 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c36:	8b 58 04             	mov    0x4(%eax),%ebx
80104c39:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c3c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c3f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c41:	83 fa 0a             	cmp    $0xa,%edx
80104c44:	75 e2                	jne    80104c28 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c46:	5b                   	pop    %ebx
80104c47:	5d                   	pop    %ebp
80104c48:	c3                   	ret    
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104c50:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c53:	8d 51 28             	lea    0x28(%ecx),%edx
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c66:	83 c0 04             	add    $0x4,%eax
80104c69:	39 d0                	cmp    %edx,%eax
80104c6b:	75 f3                	jne    80104c60 <getcallerpcs+0x50>
}
80104c6d:	5b                   	pop    %ebx
80104c6e:	5d                   	pop    %ebp
80104c6f:	c3                   	ret    

80104c70 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	53                   	push   %ebx
80104c78:	83 ec 04             	sub    $0x4,%esp
80104c7b:	9c                   	pushf  
80104c7c:	5b                   	pop    %ebx
  asm volatile("cli");
80104c7d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c7e:	e8 3d f4 ff ff       	call   801040c0 <mycpu>
80104c83:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c89:	85 c0                	test   %eax,%eax
80104c8b:	74 13                	je     80104ca0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c8d:	e8 2e f4 ff ff       	call   801040c0 <mycpu>
80104c92:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c99:	83 c4 04             	add    $0x4,%esp
80104c9c:	5b                   	pop    %ebx
80104c9d:	5d                   	pop    %ebp
80104c9e:	c3                   	ret    
80104c9f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104ca0:	e8 1b f4 ff ff       	call   801040c0 <mycpu>
80104ca5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104cab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104cb1:	eb da                	jmp    80104c8d <pushcli+0x1d>
80104cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cc0 <popcli>:

void
popcli(void)
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104cca:	9c                   	pushf  
80104ccb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ccc:	f6 c4 02             	test   $0x2,%ah
80104ccf:	75 31                	jne    80104d02 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104cd1:	e8 ea f3 ff ff       	call   801040c0 <mycpu>
80104cd6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104cdd:	78 30                	js     80104d0f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cdf:	e8 dc f3 ff ff       	call   801040c0 <mycpu>
80104ce4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104cea:	85 d2                	test   %edx,%edx
80104cec:	74 02                	je     80104cf0 <popcli+0x30>
    sti();
}
80104cee:	c9                   	leave  
80104cef:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cf0:	e8 cb f3 ff ff       	call   801040c0 <mycpu>
80104cf5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104cfb:	85 c0                	test   %eax,%eax
80104cfd:	74 ef                	je     80104cee <popcli+0x2e>
  asm volatile("sti");
80104cff:	fb                   	sti    
}
80104d00:	c9                   	leave  
80104d01:	c3                   	ret    
    panic("popcli - interruptible");
80104d02:	83 ec 0c             	sub    $0xc,%esp
80104d05:	68 bb 83 10 80       	push   $0x801083bb
80104d0a:	e8 81 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d0f:	83 ec 0c             	sub    $0xc,%esp
80104d12:	68 d2 83 10 80       	push   $0x801083d2
80104d17:	e8 74 b6 ff ff       	call   80100390 <panic>
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d20 <holding>:
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	56                   	push   %esi
80104d28:	53                   	push   %ebx
80104d29:	8b 75 08             	mov    0x8(%ebp),%esi
80104d2c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d2e:	e8 3d ff ff ff       	call   80104c70 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d33:	8b 06                	mov    (%esi),%eax
80104d35:	85 c0                	test   %eax,%eax
80104d37:	75 0f                	jne    80104d48 <holding+0x28>
  popcli();
80104d39:	e8 82 ff ff ff       	call   80104cc0 <popcli>
}
80104d3e:	89 d8                	mov    %ebx,%eax
80104d40:	5b                   	pop    %ebx
80104d41:	5e                   	pop    %esi
80104d42:	5d                   	pop    %ebp
80104d43:	c3                   	ret    
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d48:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d4b:	e8 70 f3 ff ff       	call   801040c0 <mycpu>
80104d50:	39 c3                	cmp    %eax,%ebx
80104d52:	0f 94 c3             	sete   %bl
  popcli();
80104d55:	e8 66 ff ff ff       	call   80104cc0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d5a:	0f b6 db             	movzbl %bl,%ebx
}
80104d5d:	89 d8                	mov    %ebx,%eax
80104d5f:	5b                   	pop    %ebx
80104d60:	5e                   	pop    %esi
80104d61:	5d                   	pop    %ebp
80104d62:	c3                   	ret    
80104d63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <acquire>:
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	56                   	push   %esi
80104d78:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104d79:	e8 f2 fe ff ff       	call   80104c70 <pushcli>
  if(holding(lk))
80104d7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d81:	83 ec 0c             	sub    $0xc,%esp
80104d84:	53                   	push   %ebx
80104d85:	e8 96 ff ff ff       	call   80104d20 <holding>
80104d8a:	83 c4 10             	add    $0x10,%esp
80104d8d:	85 c0                	test   %eax,%eax
80104d8f:	0f 85 7f 00 00 00    	jne    80104e14 <acquire+0xa4>
80104d95:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104d97:	ba 01 00 00 00       	mov    $0x1,%edx
80104d9c:	eb 05                	jmp    80104da3 <acquire+0x33>
80104d9e:	66 90                	xchg   %ax,%ax
80104da0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104da3:	89 d0                	mov    %edx,%eax
80104da5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104da8:	85 c0                	test   %eax,%eax
80104daa:	75 f4                	jne    80104da0 <acquire+0x30>
  __sync_synchronize();
80104dac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104db1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104db4:	e8 07 f3 ff ff       	call   801040c0 <mycpu>
80104db9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104dbc:	89 e8                	mov    %ebp,%eax
80104dbe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104dc0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104dc6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104dcc:	77 22                	ja     80104df0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104dce:	8b 50 04             	mov    0x4(%eax),%edx
80104dd1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104dd5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104dd8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104dda:	83 fe 0a             	cmp    $0xa,%esi
80104ddd:	75 e1                	jne    80104dc0 <acquire+0x50>
}
80104ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104de2:	5b                   	pop    %ebx
80104de3:	5e                   	pop    %esi
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104df0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104df4:	83 c3 34             	add    $0x34,%ebx
80104df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e06:	83 c0 04             	add    $0x4,%eax
80104e09:	39 d8                	cmp    %ebx,%eax
80104e0b:	75 f3                	jne    80104e00 <acquire+0x90>
}
80104e0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e10:	5b                   	pop    %ebx
80104e11:	5e                   	pop    %esi
80104e12:	5d                   	pop    %ebp
80104e13:	c3                   	ret    
    panic("acquire");
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	68 d9 83 10 80       	push   $0x801083d9
80104e1c:	e8 6f b5 ff ff       	call   80100390 <panic>
80104e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop

80104e30 <release>:
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	53                   	push   %ebx
80104e38:	83 ec 10             	sub    $0x10,%esp
80104e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104e3e:	53                   	push   %ebx
80104e3f:	e8 dc fe ff ff       	call   80104d20 <holding>
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	85 c0                	test   %eax,%eax
80104e49:	74 22                	je     80104e6d <release+0x3d>
  lk->pcs[0] = 0;
80104e4b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e52:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e59:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e5e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e67:	c9                   	leave  
  popcli();
80104e68:	e9 53 fe ff ff       	jmp    80104cc0 <popcli>
    panic("release");
80104e6d:	83 ec 0c             	sub    $0xc,%esp
80104e70:	68 e1 83 10 80       	push   $0x801083e1
80104e75:	e8 16 b5 ff ff       	call   80100390 <panic>
80104e7a:	66 90                	xchg   %ax,%ax
80104e7c:	66 90                	xchg   %ax,%ax
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	57                   	push   %edi
80104e88:	8b 55 08             	mov    0x8(%ebp),%edx
80104e8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e8e:	53                   	push   %ebx
80104e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e92:	89 d7                	mov    %edx,%edi
80104e94:	09 cf                	or     %ecx,%edi
80104e96:	83 e7 03             	and    $0x3,%edi
80104e99:	75 25                	jne    80104ec0 <memset+0x40>
    c &= 0xFF;
80104e9b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e9e:	c1 e0 18             	shl    $0x18,%eax
80104ea1:	89 fb                	mov    %edi,%ebx
80104ea3:	c1 e9 02             	shr    $0x2,%ecx
80104ea6:	c1 e3 10             	shl    $0x10,%ebx
80104ea9:	09 d8                	or     %ebx,%eax
80104eab:	09 f8                	or     %edi,%eax
80104ead:	c1 e7 08             	shl    $0x8,%edi
80104eb0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104eb2:	89 d7                	mov    %edx,%edi
80104eb4:	fc                   	cld    
80104eb5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104eb7:	5b                   	pop    %ebx
80104eb8:	89 d0                	mov    %edx,%eax
80104eba:	5f                   	pop    %edi
80104ebb:	5d                   	pop    %ebp
80104ebc:	c3                   	ret    
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104ec0:	89 d7                	mov    %edx,%edi
80104ec2:	fc                   	cld    
80104ec3:	f3 aa                	rep stos %al,%es:(%edi)
80104ec5:	5b                   	pop    %ebx
80104ec6:	89 d0                	mov    %edx,%eax
80104ec8:	5f                   	pop    %edi
80104ec9:	5d                   	pop    %ebp
80104eca:	c3                   	ret    
80104ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ecf:	90                   	nop

80104ed0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	56                   	push   %esi
80104ed8:	8b 75 10             	mov    0x10(%ebp),%esi
80104edb:	8b 55 08             	mov    0x8(%ebp),%edx
80104ede:	53                   	push   %ebx
80104edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104ee2:	85 f6                	test   %esi,%esi
80104ee4:	74 2a                	je     80104f10 <memcmp+0x40>
80104ee6:	01 c6                	add    %eax,%esi
80104ee8:	eb 10                	jmp    80104efa <memcmp+0x2a>
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104ef0:	83 c0 01             	add    $0x1,%eax
80104ef3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104ef6:	39 f0                	cmp    %esi,%eax
80104ef8:	74 16                	je     80104f10 <memcmp+0x40>
    if(*s1 != *s2)
80104efa:	0f b6 0a             	movzbl (%edx),%ecx
80104efd:	0f b6 18             	movzbl (%eax),%ebx
80104f00:	38 d9                	cmp    %bl,%cl
80104f02:	74 ec                	je     80104ef0 <memcmp+0x20>
      return *s1 - *s2;
80104f04:	0f b6 c1             	movzbl %cl,%eax
80104f07:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f09:	5b                   	pop    %ebx
80104f0a:	5e                   	pop    %esi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
80104f10:	5b                   	pop    %ebx
  return 0;
80104f11:	31 c0                	xor    %eax,%eax
}
80104f13:	5e                   	pop    %esi
80104f14:	5d                   	pop    %ebp
80104f15:	c3                   	ret    
80104f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi

80104f20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	57                   	push   %edi
80104f28:	8b 55 08             	mov    0x8(%ebp),%edx
80104f2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f2e:	56                   	push   %esi
80104f2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f32:	39 d6                	cmp    %edx,%esi
80104f34:	73 2a                	jae    80104f60 <memmove+0x40>
80104f36:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f39:	39 fa                	cmp    %edi,%edx
80104f3b:	73 23                	jae    80104f60 <memmove+0x40>
80104f3d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f40:	85 c9                	test   %ecx,%ecx
80104f42:	74 13                	je     80104f57 <memmove+0x37>
80104f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104f48:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f4c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f4f:	83 e8 01             	sub    $0x1,%eax
80104f52:	83 f8 ff             	cmp    $0xffffffff,%eax
80104f55:	75 f1                	jne    80104f48 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f57:	5e                   	pop    %esi
80104f58:	89 d0                	mov    %edx,%eax
80104f5a:	5f                   	pop    %edi
80104f5b:	5d                   	pop    %ebp
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f60:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f63:	89 d7                	mov    %edx,%edi
80104f65:	85 c9                	test   %ecx,%ecx
80104f67:	74 ee                	je     80104f57 <memmove+0x37>
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f70:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f71:	39 f0                	cmp    %esi,%eax
80104f73:	75 fb                	jne    80104f70 <memmove+0x50>
}
80104f75:	5e                   	pop    %esi
80104f76:	89 d0                	mov    %edx,%eax
80104f78:	5f                   	pop    %edi
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    
80104f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f7f:	90                   	nop

80104f80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104f80:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104f84:	eb 9a                	jmp    80104f20 <memmove>
80104f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
80104f95:	89 e5                	mov    %esp,%ebp
80104f97:	56                   	push   %esi
80104f98:	8b 75 10             	mov    0x10(%ebp),%esi
80104f9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f9e:	53                   	push   %ebx
80104f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104fa2:	85 f6                	test   %esi,%esi
80104fa4:	74 32                	je     80104fd8 <strncmp+0x48>
80104fa6:	01 c6                	add    %eax,%esi
80104fa8:	eb 14                	jmp    80104fbe <strncmp+0x2e>
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fb0:	38 da                	cmp    %bl,%dl
80104fb2:	75 14                	jne    80104fc8 <strncmp+0x38>
    n--, p++, q++;
80104fb4:	83 c0 01             	add    $0x1,%eax
80104fb7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104fba:	39 f0                	cmp    %esi,%eax
80104fbc:	74 1a                	je     80104fd8 <strncmp+0x48>
80104fbe:	0f b6 11             	movzbl (%ecx),%edx
80104fc1:	0f b6 18             	movzbl (%eax),%ebx
80104fc4:	84 d2                	test   %dl,%dl
80104fc6:	75 e8                	jne    80104fb0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104fc8:	0f b6 c2             	movzbl %dl,%eax
80104fcb:	29 d8                	sub    %ebx,%eax
}
80104fcd:	5b                   	pop    %ebx
80104fce:	5e                   	pop    %esi
80104fcf:	5d                   	pop    %ebp
80104fd0:	c3                   	ret    
80104fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fd8:	5b                   	pop    %ebx
    return 0;
80104fd9:	31 c0                	xor    %eax,%eax
}
80104fdb:	5e                   	pop    %esi
80104fdc:	5d                   	pop    %ebp
80104fdd:	c3                   	ret    
80104fde:	66 90                	xchg   %ax,%ax

80104fe0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104fe0:	f3 0f 1e fb          	endbr32 
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	57                   	push   %edi
80104fe8:	56                   	push   %esi
80104fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80104fec:	53                   	push   %ebx
80104fed:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ff0:	89 f2                	mov    %esi,%edx
80104ff2:	eb 1b                	jmp    8010500f <strncpy+0x2f>
80104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ff8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ffc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104fff:	83 c2 01             	add    $0x1,%edx
80105002:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105006:	89 f9                	mov    %edi,%ecx
80105008:	88 4a ff             	mov    %cl,-0x1(%edx)
8010500b:	84 c9                	test   %cl,%cl
8010500d:	74 09                	je     80105018 <strncpy+0x38>
8010500f:	89 c3                	mov    %eax,%ebx
80105011:	83 e8 01             	sub    $0x1,%eax
80105014:	85 db                	test   %ebx,%ebx
80105016:	7f e0                	jg     80104ff8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105018:	89 d1                	mov    %edx,%ecx
8010501a:	85 c0                	test   %eax,%eax
8010501c:	7e 15                	jle    80105033 <strncpy+0x53>
8010501e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105020:	83 c1 01             	add    $0x1,%ecx
80105023:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105027:	89 c8                	mov    %ecx,%eax
80105029:	f7 d0                	not    %eax
8010502b:	01 d0                	add    %edx,%eax
8010502d:	01 d8                	add    %ebx,%eax
8010502f:	85 c0                	test   %eax,%eax
80105031:	7f ed                	jg     80105020 <strncpy+0x40>
  return os;
}
80105033:	5b                   	pop    %ebx
80105034:	89 f0                	mov    %esi,%eax
80105036:	5e                   	pop    %esi
80105037:	5f                   	pop    %edi
80105038:	5d                   	pop    %ebp
80105039:	c3                   	ret    
8010503a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105040 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	56                   	push   %esi
80105048:	8b 55 10             	mov    0x10(%ebp),%edx
8010504b:	8b 75 08             	mov    0x8(%ebp),%esi
8010504e:	53                   	push   %ebx
8010504f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105052:	85 d2                	test   %edx,%edx
80105054:	7e 21                	jle    80105077 <safestrcpy+0x37>
80105056:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010505a:	89 f2                	mov    %esi,%edx
8010505c:	eb 12                	jmp    80105070 <safestrcpy+0x30>
8010505e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105060:	0f b6 08             	movzbl (%eax),%ecx
80105063:	83 c0 01             	add    $0x1,%eax
80105066:	83 c2 01             	add    $0x1,%edx
80105069:	88 4a ff             	mov    %cl,-0x1(%edx)
8010506c:	84 c9                	test   %cl,%cl
8010506e:	74 04                	je     80105074 <safestrcpy+0x34>
80105070:	39 d8                	cmp    %ebx,%eax
80105072:	75 ec                	jne    80105060 <safestrcpy+0x20>
    ;
  *s = 0;
80105074:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105077:	89 f0                	mov    %esi,%eax
80105079:	5b                   	pop    %ebx
8010507a:	5e                   	pop    %esi
8010507b:	5d                   	pop    %ebp
8010507c:	c3                   	ret    
8010507d:	8d 76 00             	lea    0x0(%esi),%esi

80105080 <strlen>:

int
strlen(const char *s)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105085:	31 c0                	xor    %eax,%eax
{
80105087:	89 e5                	mov    %esp,%ebp
80105089:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010508c:	80 3a 00             	cmpb   $0x0,(%edx)
8010508f:	74 10                	je     801050a1 <strlen+0x21>
80105091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105098:	83 c0 01             	add    $0x1,%eax
8010509b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010509f:	75 f7                	jne    80105098 <strlen+0x18>
    ;
  return n;
}
801050a1:	5d                   	pop    %ebp
801050a2:	c3                   	ret    

801050a3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050a7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050ab:	55                   	push   %ebp
  pushl %ebx
801050ac:	53                   	push   %ebx
  pushl %esi
801050ad:	56                   	push   %esi
  pushl %edi
801050ae:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050af:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050b1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801050b3:	5f                   	pop    %edi
  popl %esi
801050b4:	5e                   	pop    %esi
  popl %ebx
801050b5:	5b                   	pop    %ebx
  popl %ebp
801050b6:	5d                   	pop    %ebp
  ret
801050b7:	c3                   	ret    
801050b8:	66 90                	xchg   %ax,%ax
801050ba:	66 90                	xchg   %ax,%ax
801050bc:	66 90                	xchg   %ax,%ax
801050be:	66 90                	xchg   %ax,%ax

801050c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	53                   	push   %ebx
801050c8:	83 ec 04             	sub    $0x4,%esp
801050cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050ce:	e8 7d f0 ff ff       	call   80104150 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050d3:	8b 00                	mov    (%eax),%eax
801050d5:	39 d8                	cmp    %ebx,%eax
801050d7:	76 17                	jbe    801050f0 <fetchint+0x30>
801050d9:	8d 53 04             	lea    0x4(%ebx),%edx
801050dc:	39 d0                	cmp    %edx,%eax
801050de:	72 10                	jb     801050f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801050e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801050e3:	8b 13                	mov    (%ebx),%edx
801050e5:	89 10                	mov    %edx,(%eax)
  return 0;
801050e7:	31 c0                	xor    %eax,%eax
}
801050e9:	83 c4 04             	add    $0x4,%esp
801050ec:	5b                   	pop    %ebx
801050ed:	5d                   	pop    %ebp
801050ee:	c3                   	ret    
801050ef:	90                   	nop
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f5:	eb f2                	jmp    801050e9 <fetchint+0x29>
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax

80105100 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	53                   	push   %ebx
80105108:	83 ec 04             	sub    $0x4,%esp
8010510b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010510e:	e8 3d f0 ff ff       	call   80104150 <myproc>

  if(addr >= curproc->sz)
80105113:	39 18                	cmp    %ebx,(%eax)
80105115:	76 31                	jbe    80105148 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105117:	8b 55 0c             	mov    0xc(%ebp),%edx
8010511a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010511c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010511e:	39 d3                	cmp    %edx,%ebx
80105120:	73 26                	jae    80105148 <fetchstr+0x48>
80105122:	89 d8                	mov    %ebx,%eax
80105124:	eb 11                	jmp    80105137 <fetchstr+0x37>
80105126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
80105130:	83 c0 01             	add    $0x1,%eax
80105133:	39 c2                	cmp    %eax,%edx
80105135:	76 11                	jbe    80105148 <fetchstr+0x48>
    if(*s == 0)
80105137:	80 38 00             	cmpb   $0x0,(%eax)
8010513a:	75 f4                	jne    80105130 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010513c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010513f:	29 d8                	sub    %ebx,%eax
}
80105141:	5b                   	pop    %ebx
80105142:	5d                   	pop    %ebp
80105143:	c3                   	ret    
80105144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105148:	83 c4 04             	add    $0x4,%esp
    return -1;
8010514b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105150:	5b                   	pop    %ebx
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    
80105153:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105160 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	56                   	push   %esi
80105168:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105169:	e8 e2 ef ff ff       	call   80104150 <myproc>
8010516e:	8b 55 08             	mov    0x8(%ebp),%edx
80105171:	8b 40 18             	mov    0x18(%eax),%eax
80105174:	8b 40 44             	mov    0x44(%eax),%eax
80105177:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010517a:	e8 d1 ef ff ff       	call   80104150 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010517f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105182:	8b 00                	mov    (%eax),%eax
80105184:	39 c6                	cmp    %eax,%esi
80105186:	73 18                	jae    801051a0 <argint+0x40>
80105188:	8d 53 08             	lea    0x8(%ebx),%edx
8010518b:	39 d0                	cmp    %edx,%eax
8010518d:	72 11                	jb     801051a0 <argint+0x40>
  *ip = *(int*)(addr);
8010518f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105192:	8b 53 04             	mov    0x4(%ebx),%edx
80105195:	89 10                	mov    %edx,(%eax)
  return 0;
80105197:	31 c0                	xor    %eax,%eax
}
80105199:	5b                   	pop    %ebx
8010519a:	5e                   	pop    %esi
8010519b:	5d                   	pop    %ebp
8010519c:	c3                   	ret    
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051a5:	eb f2                	jmp    80105199 <argint+0x39>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	56                   	push   %esi
801051b8:	53                   	push   %ebx
801051b9:	83 ec 10             	sub    $0x10,%esp
801051bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801051bf:	e8 8c ef ff ff       	call   80104150 <myproc>
 
  if(argint(n, &i) < 0)
801051c4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801051c7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801051c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051cc:	50                   	push   %eax
801051cd:	ff 75 08             	pushl  0x8(%ebp)
801051d0:	e8 8b ff ff ff       	call   80105160 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	85 c0                	test   %eax,%eax
801051da:	78 24                	js     80105200 <argptr+0x50>
801051dc:	85 db                	test   %ebx,%ebx
801051de:	78 20                	js     80105200 <argptr+0x50>
801051e0:	8b 16                	mov    (%esi),%edx
801051e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e5:	39 c2                	cmp    %eax,%edx
801051e7:	76 17                	jbe    80105200 <argptr+0x50>
801051e9:	01 c3                	add    %eax,%ebx
801051eb:	39 da                	cmp    %ebx,%edx
801051ed:	72 11                	jb     80105200 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801051ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801051f2:	89 02                	mov    %eax,(%edx)
  return 0;
801051f4:	31 c0                	xor    %eax,%eax
}
801051f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f9:	5b                   	pop    %ebx
801051fa:	5e                   	pop    %esi
801051fb:	5d                   	pop    %ebp
801051fc:	c3                   	ret    
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105205:	eb ef                	jmp    801051f6 <argptr+0x46>
80105207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520e:	66 90                	xchg   %ax,%ax

80105210 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010521a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521d:	50                   	push   %eax
8010521e:	ff 75 08             	pushl  0x8(%ebp)
80105221:	e8 3a ff ff ff       	call   80105160 <argint>
80105226:	83 c4 10             	add    $0x10,%esp
80105229:	85 c0                	test   %eax,%eax
8010522b:	78 13                	js     80105240 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010522d:	83 ec 08             	sub    $0x8,%esp
80105230:	ff 75 0c             	pushl  0xc(%ebp)
80105233:	ff 75 f4             	pushl  -0xc(%ebp)
80105236:	e8 c5 fe ff ff       	call   80105100 <fetchstr>
8010523b:	83 c4 10             	add    $0x10,%esp
}
8010523e:	c9                   	leave  
8010523f:	c3                   	ret    
80105240:	c9                   	leave  
    return -1;
80105241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105246:	c3                   	ret    
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax

80105250 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	53                   	push   %ebx
80105258:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010525b:	e8 f0 ee ff ff       	call   80104150 <myproc>
80105260:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105262:	8b 40 18             	mov    0x18(%eax),%eax
80105265:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105268:	8d 50 ff             	lea    -0x1(%eax),%edx
8010526b:	83 fa 17             	cmp    $0x17,%edx
8010526e:	77 20                	ja     80105290 <syscall+0x40>
80105270:	8b 14 85 20 84 10 80 	mov    -0x7fef7be0(,%eax,4),%edx
80105277:	85 d2                	test   %edx,%edx
80105279:	74 15                	je     80105290 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010527b:	ff d2                	call   *%edx
8010527d:	89 c2                	mov    %eax,%edx
8010527f:	8b 43 18             	mov    0x18(%ebx),%eax
80105282:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105288:	c9                   	leave  
80105289:	c3                   	ret    
8010528a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105290:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105291:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105294:	50                   	push   %eax
80105295:	ff 73 10             	pushl  0x10(%ebx)
80105298:	68 e9 83 10 80       	push   $0x801083e9
8010529d:	e8 0e b4 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801052a2:	8b 43 18             	mov    0x18(%ebx),%eax
801052a5:	83 c4 10             	add    $0x10,%esp
801052a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052b2:	c9                   	leave  
801052b3:	c3                   	ret    
801052b4:	66 90                	xchg   %ax,%ax
801052b6:	66 90                	xchg   %ax,%ax
801052b8:	66 90                	xchg   %ax,%ax
801052ba:	66 90                	xchg   %ax,%ax
801052bc:	66 90                	xchg   %ax,%ax
801052be:	66 90                	xchg   %ax,%ax

801052c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052c5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 44             	sub    $0x44,%esp
801052cc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801052cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801052d2:	57                   	push   %edi
801052d3:	50                   	push   %eax
{
801052d4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801052d7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052da:	e8 71 cd ff ff       	call   80102050 <nameiparent>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	85 c0                	test   %eax,%eax
801052e4:	0f 84 46 01 00 00    	je     80105430 <create+0x170>
    return 0;
  ilock(dp);
801052ea:	83 ec 0c             	sub    $0xc,%esp
801052ed:	89 c3                	mov    %eax,%ebx
801052ef:	50                   	push   %eax
801052f0:	e8 6b c4 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801052f5:	83 c4 0c             	add    $0xc,%esp
801052f8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801052fb:	50                   	push   %eax
801052fc:	57                   	push   %edi
801052fd:	53                   	push   %ebx
801052fe:	e8 ad c9 ff ff       	call   80101cb0 <dirlookup>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	89 c6                	mov    %eax,%esi
80105308:	85 c0                	test   %eax,%eax
8010530a:	74 54                	je     80105360 <create+0xa0>
    iunlockput(dp);
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	53                   	push   %ebx
80105310:	e8 eb c6 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105315:	89 34 24             	mov    %esi,(%esp)
80105318:	e8 43 c4 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010531d:	83 c4 10             	add    $0x10,%esp
80105320:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105325:	75 19                	jne    80105340 <create+0x80>
80105327:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010532c:	75 12                	jne    80105340 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010532e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105331:	89 f0                	mov    %esi,%eax
80105333:	5b                   	pop    %ebx
80105334:	5e                   	pop    %esi
80105335:	5f                   	pop    %edi
80105336:	5d                   	pop    %ebp
80105337:	c3                   	ret    
80105338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533f:	90                   	nop
    iunlockput(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	56                   	push   %esi
    return 0;
80105344:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105346:	e8 b5 c6 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010534b:	83 c4 10             	add    $0x10,%esp
}
8010534e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105351:	89 f0                	mov    %esi,%eax
80105353:	5b                   	pop    %ebx
80105354:	5e                   	pop    %esi
80105355:	5f                   	pop    %edi
80105356:	5d                   	pop    %ebp
80105357:	c3                   	ret    
80105358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105360:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105364:	83 ec 08             	sub    $0x8,%esp
80105367:	50                   	push   %eax
80105368:	ff 33                	pushl  (%ebx)
8010536a:	e8 71 c2 ff ff       	call   801015e0 <ialloc>
8010536f:	83 c4 10             	add    $0x10,%esp
80105372:	89 c6                	mov    %eax,%esi
80105374:	85 c0                	test   %eax,%eax
80105376:	0f 84 cd 00 00 00    	je     80105449 <create+0x189>
  ilock(ip);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	50                   	push   %eax
80105380:	e8 db c3 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105385:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105389:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010538d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105391:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105395:	b8 01 00 00 00       	mov    $0x1,%eax
8010539a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010539e:	89 34 24             	mov    %esi,(%esp)
801053a1:	e8 fa c2 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053a6:	83 c4 10             	add    $0x10,%esp
801053a9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801053ae:	74 30                	je     801053e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801053b0:	83 ec 04             	sub    $0x4,%esp
801053b3:	ff 76 04             	pushl  0x4(%esi)
801053b6:	57                   	push   %edi
801053b7:	53                   	push   %ebx
801053b8:	e8 b3 cb ff ff       	call   80101f70 <dirlink>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 78                	js     8010543c <create+0x17c>
  iunlockput(dp);
801053c4:	83 ec 0c             	sub    $0xc,%esp
801053c7:	53                   	push   %ebx
801053c8:	e8 33 c6 ff ff       	call   80101a00 <iunlockput>
  return ip;
801053cd:	83 c4 10             	add    $0x10,%esp
}
801053d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d3:	89 f0                	mov    %esi,%eax
801053d5:	5b                   	pop    %ebx
801053d6:	5e                   	pop    %esi
801053d7:	5f                   	pop    %edi
801053d8:	5d                   	pop    %ebp
801053d9:	c3                   	ret    
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801053e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801053e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053e8:	53                   	push   %ebx
801053e9:	e8 b2 c2 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053ee:	83 c4 0c             	add    $0xc,%esp
801053f1:	ff 76 04             	pushl  0x4(%esi)
801053f4:	68 a0 84 10 80       	push   $0x801084a0
801053f9:	56                   	push   %esi
801053fa:	e8 71 cb ff ff       	call   80101f70 <dirlink>
801053ff:	83 c4 10             	add    $0x10,%esp
80105402:	85 c0                	test   %eax,%eax
80105404:	78 18                	js     8010541e <create+0x15e>
80105406:	83 ec 04             	sub    $0x4,%esp
80105409:	ff 73 04             	pushl  0x4(%ebx)
8010540c:	68 9f 84 10 80       	push   $0x8010849f
80105411:	56                   	push   %esi
80105412:	e8 59 cb ff ff       	call   80101f70 <dirlink>
80105417:	83 c4 10             	add    $0x10,%esp
8010541a:	85 c0                	test   %eax,%eax
8010541c:	79 92                	jns    801053b0 <create+0xf0>
      panic("create dots");
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	68 93 84 10 80       	push   $0x80108493
80105426:	e8 65 af ff ff       	call   80100390 <panic>
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop
}
80105430:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105433:	31 f6                	xor    %esi,%esi
}
80105435:	5b                   	pop    %ebx
80105436:	89 f0                	mov    %esi,%eax
80105438:	5e                   	pop    %esi
80105439:	5f                   	pop    %edi
8010543a:	5d                   	pop    %ebp
8010543b:	c3                   	ret    
    panic("create: dirlink");
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	68 a2 84 10 80       	push   $0x801084a2
80105444:	e8 47 af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	68 84 84 10 80       	push   $0x80108484
80105451:	e8 3a af ff ff       	call   80100390 <panic>
80105456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545d:	8d 76 00             	lea    0x0(%esi),%esi

80105460 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	89 d6                	mov    %edx,%esi
80105466:	53                   	push   %ebx
80105467:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105469:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010546c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010546f:	50                   	push   %eax
80105470:	6a 00                	push   $0x0
80105472:	e8 e9 fc ff ff       	call   80105160 <argint>
80105477:	83 c4 10             	add    $0x10,%esp
8010547a:	85 c0                	test   %eax,%eax
8010547c:	78 2a                	js     801054a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010547e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105482:	77 24                	ja     801054a8 <argfd.constprop.0+0x48>
80105484:	e8 c7 ec ff ff       	call   80104150 <myproc>
80105489:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010548c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105490:	85 c0                	test   %eax,%eax
80105492:	74 14                	je     801054a8 <argfd.constprop.0+0x48>
  if(pfd)
80105494:	85 db                	test   %ebx,%ebx
80105496:	74 02                	je     8010549a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105498:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010549a:	89 06                	mov    %eax,(%esi)
  return 0;
8010549c:	31 c0                	xor    %eax,%eax
}
8010549e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a1:	5b                   	pop    %ebx
801054a2:	5e                   	pop    %esi
801054a3:	5d                   	pop    %ebp
801054a4:	c3                   	ret    
801054a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ad:	eb ef                	jmp    8010549e <argfd.constprop.0+0x3e>
801054af:	90                   	nop

801054b0 <sys_dup>:
{
801054b0:	f3 0f 1e fb          	endbr32 
801054b4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801054b5:	31 c0                	xor    %eax,%eax
{
801054b7:	89 e5                	mov    %esp,%ebp
801054b9:	56                   	push   %esi
801054ba:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801054bb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801054be:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801054c1:	e8 9a ff ff ff       	call   80105460 <argfd.constprop.0>
801054c6:	85 c0                	test   %eax,%eax
801054c8:	78 1e                	js     801054e8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801054ca:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054cd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054cf:	e8 7c ec ff ff       	call   80104150 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054d8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054dc:	85 d2                	test   %edx,%edx
801054de:	74 20                	je     80105500 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801054e0:	83 c3 01             	add    $0x1,%ebx
801054e3:	83 fb 10             	cmp    $0x10,%ebx
801054e6:	75 f0                	jne    801054d8 <sys_dup+0x28>
}
801054e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801054eb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801054f0:	89 d8                	mov    %ebx,%eax
801054f2:	5b                   	pop    %ebx
801054f3:	5e                   	pop    %esi
801054f4:	5d                   	pop    %ebp
801054f5:	c3                   	ret    
801054f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054fd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105500:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	ff 75 f4             	pushl  -0xc(%ebp)
8010550a:	e8 61 b9 ff ff       	call   80100e70 <filedup>
  return fd;
8010550f:	83 c4 10             	add    $0x10,%esp
}
80105512:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105515:	89 d8                	mov    %ebx,%eax
80105517:	5b                   	pop    %ebx
80105518:	5e                   	pop    %esi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop

80105520 <sys_read>:
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105525:	31 c0                	xor    %eax,%eax
{
80105527:	89 e5                	mov    %esp,%ebp
80105529:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010552c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010552f:	e8 2c ff ff ff       	call   80105460 <argfd.constprop.0>
80105534:	85 c0                	test   %eax,%eax
80105536:	78 48                	js     80105580 <sys_read+0x60>
80105538:	83 ec 08             	sub    $0x8,%esp
8010553b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010553e:	50                   	push   %eax
8010553f:	6a 02                	push   $0x2
80105541:	e8 1a fc ff ff       	call   80105160 <argint>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	78 33                	js     80105580 <sys_read+0x60>
8010554d:	83 ec 04             	sub    $0x4,%esp
80105550:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105553:	ff 75 f0             	pushl  -0x10(%ebp)
80105556:	50                   	push   %eax
80105557:	6a 01                	push   $0x1
80105559:	e8 52 fc ff ff       	call   801051b0 <argptr>
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	85 c0                	test   %eax,%eax
80105563:	78 1b                	js     80105580 <sys_read+0x60>
  return fileread(f, p, n);
80105565:	83 ec 04             	sub    $0x4,%esp
80105568:	ff 75 f0             	pushl  -0x10(%ebp)
8010556b:	ff 75 f4             	pushl  -0xc(%ebp)
8010556e:	ff 75 ec             	pushl  -0x14(%ebp)
80105571:	e8 7a ba ff ff       	call   80100ff0 <fileread>
80105576:	83 c4 10             	add    $0x10,%esp
}
80105579:	c9                   	leave  
8010557a:	c3                   	ret    
8010557b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010557f:	90                   	nop
80105580:	c9                   	leave  
    return -1;
80105581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105586:	c3                   	ret    
80105587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558e:	66 90                	xchg   %ax,%ax

80105590 <sys_write>:
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105595:	31 c0                	xor    %eax,%eax
{
80105597:	89 e5                	mov    %esp,%ebp
80105599:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010559c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010559f:	e8 bc fe ff ff       	call   80105460 <argfd.constprop.0>
801055a4:	85 c0                	test   %eax,%eax
801055a6:	78 48                	js     801055f0 <sys_write+0x60>
801055a8:	83 ec 08             	sub    $0x8,%esp
801055ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055ae:	50                   	push   %eax
801055af:	6a 02                	push   $0x2
801055b1:	e8 aa fb ff ff       	call   80105160 <argint>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	78 33                	js     801055f0 <sys_write+0x60>
801055bd:	83 ec 04             	sub    $0x4,%esp
801055c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c3:	ff 75 f0             	pushl  -0x10(%ebp)
801055c6:	50                   	push   %eax
801055c7:	6a 01                	push   $0x1
801055c9:	e8 e2 fb ff ff       	call   801051b0 <argptr>
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	85 c0                	test   %eax,%eax
801055d3:	78 1b                	js     801055f0 <sys_write+0x60>
  return filewrite(f, p, n);
801055d5:	83 ec 04             	sub    $0x4,%esp
801055d8:	ff 75 f0             	pushl  -0x10(%ebp)
801055db:	ff 75 f4             	pushl  -0xc(%ebp)
801055de:	ff 75 ec             	pushl  -0x14(%ebp)
801055e1:	e8 aa ba ff ff       	call   80101090 <filewrite>
801055e6:	83 c4 10             	add    $0x10,%esp
}
801055e9:	c9                   	leave  
801055ea:	c3                   	ret    
801055eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop
801055f0:	c9                   	leave  
    return -1;
801055f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f6:	c3                   	ret    
801055f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fe:	66 90                	xchg   %ax,%ax

80105600 <sys_close>:
{
80105600:	f3 0f 1e fb          	endbr32 
80105604:	55                   	push   %ebp
80105605:	89 e5                	mov    %esp,%ebp
80105607:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010560a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010560d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105610:	e8 4b fe ff ff       	call   80105460 <argfd.constprop.0>
80105615:	85 c0                	test   %eax,%eax
80105617:	78 27                	js     80105640 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105619:	e8 32 eb ff ff       	call   80104150 <myproc>
8010561e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105621:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105624:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010562b:	00 
  fileclose(f);
8010562c:	ff 75 f4             	pushl  -0xc(%ebp)
8010562f:	e8 8c b8 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	31 c0                	xor    %eax,%eax
}
80105639:	c9                   	leave  
8010563a:	c3                   	ret    
8010563b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop
80105640:	c9                   	leave  
    return -1;
80105641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105646:	c3                   	ret    
80105647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564e:	66 90                	xchg   %ax,%ax

80105650 <sys_fstat>:
{
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105655:	31 c0                	xor    %eax,%eax
{
80105657:	89 e5                	mov    %esp,%ebp
80105659:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010565c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010565f:	e8 fc fd ff ff       	call   80105460 <argfd.constprop.0>
80105664:	85 c0                	test   %eax,%eax
80105666:	78 30                	js     80105698 <sys_fstat+0x48>
80105668:	83 ec 04             	sub    $0x4,%esp
8010566b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566e:	6a 14                	push   $0x14
80105670:	50                   	push   %eax
80105671:	6a 01                	push   $0x1
80105673:	e8 38 fb ff ff       	call   801051b0 <argptr>
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	85 c0                	test   %eax,%eax
8010567d:	78 19                	js     80105698 <sys_fstat+0x48>
  return filestat(f, st);
8010567f:	83 ec 08             	sub    $0x8,%esp
80105682:	ff 75 f4             	pushl  -0xc(%ebp)
80105685:	ff 75 f0             	pushl  -0x10(%ebp)
80105688:	e8 13 b9 ff ff       	call   80100fa0 <filestat>
8010568d:	83 c4 10             	add    $0x10,%esp
}
80105690:	c9                   	leave  
80105691:	c3                   	ret    
80105692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105698:	c9                   	leave  
    return -1;
80105699:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569e:	c3                   	ret    
8010569f:	90                   	nop

801056a0 <sys_link>:
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	57                   	push   %edi
801056a8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056a9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056ac:	53                   	push   %ebx
801056ad:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056b0:	50                   	push   %eax
801056b1:	6a 00                	push   $0x0
801056b3:	e8 58 fb ff ff       	call   80105210 <argstr>
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	85 c0                	test   %eax,%eax
801056bd:	0f 88 ff 00 00 00    	js     801057c2 <sys_link+0x122>
801056c3:	83 ec 08             	sub    $0x8,%esp
801056c6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	6a 01                	push   $0x1
801056cc:	e8 3f fb ff ff       	call   80105210 <argstr>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	0f 88 e6 00 00 00    	js     801057c2 <sys_link+0x122>
  begin_op();
801056dc:	e8 3f de ff ff       	call   80103520 <begin_op>
  if((ip = namei(old)) == 0){
801056e1:	83 ec 0c             	sub    $0xc,%esp
801056e4:	ff 75 d4             	pushl  -0x2c(%ebp)
801056e7:	e8 44 c9 ff ff       	call   80102030 <namei>
801056ec:	83 c4 10             	add    $0x10,%esp
801056ef:	89 c3                	mov    %eax,%ebx
801056f1:	85 c0                	test   %eax,%eax
801056f3:	0f 84 e8 00 00 00    	je     801057e1 <sys_link+0x141>
  ilock(ip);
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	50                   	push   %eax
801056fd:	e8 5e c0 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010570a:	0f 84 b9 00 00 00    	je     801057c9 <sys_link+0x129>
  iupdate(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105713:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105718:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010571b:	53                   	push   %ebx
8010571c:	e8 7f bf ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105721:	89 1c 24             	mov    %ebx,(%esp)
80105724:	e8 17 c1 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105729:	58                   	pop    %eax
8010572a:	5a                   	pop    %edx
8010572b:	57                   	push   %edi
8010572c:	ff 75 d0             	pushl  -0x30(%ebp)
8010572f:	e8 1c c9 ff ff       	call   80102050 <nameiparent>
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	89 c6                	mov    %eax,%esi
80105739:	85 c0                	test   %eax,%eax
8010573b:	74 5f                	je     8010579c <sys_link+0xfc>
  ilock(dp);
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	50                   	push   %eax
80105741:	e8 1a c0 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105746:	8b 03                	mov    (%ebx),%eax
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	39 06                	cmp    %eax,(%esi)
8010574d:	75 41                	jne    80105790 <sys_link+0xf0>
8010574f:	83 ec 04             	sub    $0x4,%esp
80105752:	ff 73 04             	pushl  0x4(%ebx)
80105755:	57                   	push   %edi
80105756:	56                   	push   %esi
80105757:	e8 14 c8 ff ff       	call   80101f70 <dirlink>
8010575c:	83 c4 10             	add    $0x10,%esp
8010575f:	85 c0                	test   %eax,%eax
80105761:	78 2d                	js     80105790 <sys_link+0xf0>
  iunlockput(dp);
80105763:	83 ec 0c             	sub    $0xc,%esp
80105766:	56                   	push   %esi
80105767:	e8 94 c2 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010576c:	89 1c 24             	mov    %ebx,(%esp)
8010576f:	e8 1c c1 ff ff       	call   80101890 <iput>
  end_op();
80105774:	e8 17 de ff ff       	call   80103590 <end_op>
  return 0;
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	31 c0                	xor    %eax,%eax
}
8010577e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105781:	5b                   	pop    %ebx
80105782:	5e                   	pop    %esi
80105783:	5f                   	pop    %edi
80105784:	5d                   	pop    %ebp
80105785:	c3                   	ret    
80105786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	56                   	push   %esi
80105794:	e8 67 c2 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105799:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010579c:	83 ec 0c             	sub    $0xc,%esp
8010579f:	53                   	push   %ebx
801057a0:	e8 bb bf ff ff       	call   80101760 <ilock>
  ip->nlink--;
801057a5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057aa:	89 1c 24             	mov    %ebx,(%esp)
801057ad:	e8 ee be ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801057b2:	89 1c 24             	mov    %ebx,(%esp)
801057b5:	e8 46 c2 ff ff       	call   80101a00 <iunlockput>
  end_op();
801057ba:	e8 d1 dd ff ff       	call   80103590 <end_op>
  return -1;
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c7:	eb b5                	jmp    8010577e <sys_link+0xde>
    iunlockput(ip);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	53                   	push   %ebx
801057cd:	e8 2e c2 ff ff       	call   80101a00 <iunlockput>
    end_op();
801057d2:	e8 b9 dd ff ff       	call   80103590 <end_op>
    return -1;
801057d7:	83 c4 10             	add    $0x10,%esp
801057da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057df:	eb 9d                	jmp    8010577e <sys_link+0xde>
    end_op();
801057e1:	e8 aa dd ff ff       	call   80103590 <end_op>
    return -1;
801057e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057eb:	eb 91                	jmp    8010577e <sys_link+0xde>
801057ed:	8d 76 00             	lea    0x0(%esi),%esi

801057f0 <sys_unlink>:
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	57                   	push   %edi
801057f8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801057f9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057fc:	53                   	push   %ebx
801057fd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105800:	50                   	push   %eax
80105801:	6a 00                	push   $0x0
80105803:	e8 08 fa ff ff       	call   80105210 <argstr>
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	85 c0                	test   %eax,%eax
8010580d:	0f 88 7d 01 00 00    	js     80105990 <sys_unlink+0x1a0>
  begin_op();
80105813:	e8 08 dd ff ff       	call   80103520 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105818:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010581b:	83 ec 08             	sub    $0x8,%esp
8010581e:	53                   	push   %ebx
8010581f:	ff 75 c0             	pushl  -0x40(%ebp)
80105822:	e8 29 c8 ff ff       	call   80102050 <nameiparent>
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	89 c6                	mov    %eax,%esi
8010582c:	85 c0                	test   %eax,%eax
8010582e:	0f 84 66 01 00 00    	je     8010599a <sys_unlink+0x1aa>
  ilock(dp);
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	50                   	push   %eax
80105838:	e8 23 bf ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010583d:	58                   	pop    %eax
8010583e:	5a                   	pop    %edx
8010583f:	68 a0 84 10 80       	push   $0x801084a0
80105844:	53                   	push   %ebx
80105845:	e8 46 c4 ff ff       	call   80101c90 <namecmp>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	0f 84 03 01 00 00    	je     80105958 <sys_unlink+0x168>
80105855:	83 ec 08             	sub    $0x8,%esp
80105858:	68 9f 84 10 80       	push   $0x8010849f
8010585d:	53                   	push   %ebx
8010585e:	e8 2d c4 ff ff       	call   80101c90 <namecmp>
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	0f 84 ea 00 00 00    	je     80105958 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010586e:	83 ec 04             	sub    $0x4,%esp
80105871:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105874:	50                   	push   %eax
80105875:	53                   	push   %ebx
80105876:	56                   	push   %esi
80105877:	e8 34 c4 ff ff       	call   80101cb0 <dirlookup>
8010587c:	83 c4 10             	add    $0x10,%esp
8010587f:	89 c3                	mov    %eax,%ebx
80105881:	85 c0                	test   %eax,%eax
80105883:	0f 84 cf 00 00 00    	je     80105958 <sys_unlink+0x168>
  ilock(ip);
80105889:	83 ec 0c             	sub    $0xc,%esp
8010588c:	50                   	push   %eax
8010588d:	e8 ce be ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010589a:	0f 8e 23 01 00 00    	jle    801059c3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058a8:	74 66                	je     80105910 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058aa:	83 ec 04             	sub    $0x4,%esp
801058ad:	6a 10                	push   $0x10
801058af:	6a 00                	push   $0x0
801058b1:	57                   	push   %edi
801058b2:	e8 c9 f5 ff ff       	call   80104e80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058b7:	6a 10                	push   $0x10
801058b9:	ff 75 c4             	pushl  -0x3c(%ebp)
801058bc:	57                   	push   %edi
801058bd:	56                   	push   %esi
801058be:	e8 9d c2 ff ff       	call   80101b60 <writei>
801058c3:	83 c4 20             	add    $0x20,%esp
801058c6:	83 f8 10             	cmp    $0x10,%eax
801058c9:	0f 85 e7 00 00 00    	jne    801059b6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801058cf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058d4:	0f 84 96 00 00 00    	je     80105970 <sys_unlink+0x180>
  iunlockput(dp);
801058da:	83 ec 0c             	sub    $0xc,%esp
801058dd:	56                   	push   %esi
801058de:	e8 1d c1 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
801058e3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058e8:	89 1c 24             	mov    %ebx,(%esp)
801058eb:	e8 b0 bd ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801058f0:	89 1c 24             	mov    %ebx,(%esp)
801058f3:	e8 08 c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
801058f8:	e8 93 dc ff ff       	call   80103590 <end_op>
  return 0;
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	31 c0                	xor    %eax,%eax
}
80105902:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105905:	5b                   	pop    %ebx
80105906:	5e                   	pop    %esi
80105907:	5f                   	pop    %edi
80105908:	5d                   	pop    %ebp
80105909:	c3                   	ret    
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105910:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105914:	76 94                	jbe    801058aa <sys_unlink+0xba>
80105916:	ba 20 00 00 00       	mov    $0x20,%edx
8010591b:	eb 0b                	jmp    80105928 <sys_unlink+0x138>
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
80105920:	83 c2 10             	add    $0x10,%edx
80105923:	39 53 58             	cmp    %edx,0x58(%ebx)
80105926:	76 82                	jbe    801058aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105928:	6a 10                	push   $0x10
8010592a:	52                   	push   %edx
8010592b:	57                   	push   %edi
8010592c:	53                   	push   %ebx
8010592d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105930:	e8 2b c1 ff ff       	call   80101a60 <readi>
80105935:	83 c4 10             	add    $0x10,%esp
80105938:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010593b:	83 f8 10             	cmp    $0x10,%eax
8010593e:	75 69                	jne    801059a9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105940:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105945:	74 d9                	je     80105920 <sys_unlink+0x130>
    iunlockput(ip);
80105947:	83 ec 0c             	sub    $0xc,%esp
8010594a:	53                   	push   %ebx
8010594b:	e8 b0 c0 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105950:	83 c4 10             	add    $0x10,%esp
80105953:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105957:	90                   	nop
  iunlockput(dp);
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	56                   	push   %esi
8010595c:	e8 9f c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105961:	e8 2a dc ff ff       	call   80103590 <end_op>
  return -1;
80105966:	83 c4 10             	add    $0x10,%esp
80105969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596e:	eb 92                	jmp    80105902 <sys_unlink+0x112>
    iupdate(dp);
80105970:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105973:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105978:	56                   	push   %esi
80105979:	e8 22 bd ff ff       	call   801016a0 <iupdate>
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	e9 54 ff ff ff       	jmp    801058da <sys_unlink+0xea>
80105986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105995:	e9 68 ff ff ff       	jmp    80105902 <sys_unlink+0x112>
    end_op();
8010599a:	e8 f1 db ff ff       	call   80103590 <end_op>
    return -1;
8010599f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a4:	e9 59 ff ff ff       	jmp    80105902 <sys_unlink+0x112>
      panic("isdirempty: readi");
801059a9:	83 ec 0c             	sub    $0xc,%esp
801059ac:	68 c4 84 10 80       	push   $0x801084c4
801059b1:	e8 da a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801059b6:	83 ec 0c             	sub    $0xc,%esp
801059b9:	68 d6 84 10 80       	push   $0x801084d6
801059be:	e8 cd a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801059c3:	83 ec 0c             	sub    $0xc,%esp
801059c6:	68 b2 84 10 80       	push   $0x801084b2
801059cb:	e8 c0 a9 ff ff       	call   80100390 <panic>

801059d0 <sys_open>:

int
sys_open(void)
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
801059d5:	89 e5                	mov    %esp,%ebp
801059d7:	57                   	push   %edi
801059d8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801059dc:	53                   	push   %ebx
801059dd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059e0:	50                   	push   %eax
801059e1:	6a 00                	push   $0x0
801059e3:	e8 28 f8 ff ff       	call   80105210 <argstr>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	85 c0                	test   %eax,%eax
801059ed:	0f 88 8a 00 00 00    	js     80105a7d <sys_open+0xad>
801059f3:	83 ec 08             	sub    $0x8,%esp
801059f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059f9:	50                   	push   %eax
801059fa:	6a 01                	push   $0x1
801059fc:	e8 5f f7 ff ff       	call   80105160 <argint>
80105a01:	83 c4 10             	add    $0x10,%esp
80105a04:	85 c0                	test   %eax,%eax
80105a06:	78 75                	js     80105a7d <sys_open+0xad>
    return -1;

  begin_op();
80105a08:	e8 13 db ff ff       	call   80103520 <begin_op>

  if(omode & O_CREATE){
80105a0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a11:	75 75                	jne    80105a88 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a13:	83 ec 0c             	sub    $0xc,%esp
80105a16:	ff 75 e0             	pushl  -0x20(%ebp)
80105a19:	e8 12 c6 ff ff       	call   80102030 <namei>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	89 c6                	mov    %eax,%esi
80105a23:	85 c0                	test   %eax,%eax
80105a25:	74 7e                	je     80105aa5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a27:	83 ec 0c             	sub    $0xc,%esp
80105a2a:	50                   	push   %eax
80105a2b:	e8 30 bd ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a38:	0f 84 c2 00 00 00    	je     80105b00 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a3e:	e8 bd b3 ff ff       	call   80100e00 <filealloc>
80105a43:	89 c7                	mov    %eax,%edi
80105a45:	85 c0                	test   %eax,%eax
80105a47:	74 23                	je     80105a6c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a49:	e8 02 e7 ff ff       	call   80104150 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a4e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a54:	85 d2                	test   %edx,%edx
80105a56:	74 60                	je     80105ab8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a58:	83 c3 01             	add    $0x1,%ebx
80105a5b:	83 fb 10             	cmp    $0x10,%ebx
80105a5e:	75 f0                	jne    80105a50 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	57                   	push   %edi
80105a64:	e8 57 b4 ff ff       	call   80100ec0 <fileclose>
80105a69:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	56                   	push   %esi
80105a70:	e8 8b bf ff ff       	call   80101a00 <iunlockput>
    end_op();
80105a75:	e8 16 db ff ff       	call   80103590 <end_op>
    return -1;
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a82:	eb 6d                	jmp    80105af1 <sys_open+0x121>
80105a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a8e:	31 c9                	xor    %ecx,%ecx
80105a90:	ba 02 00 00 00       	mov    $0x2,%edx
80105a95:	6a 00                	push   $0x0
80105a97:	e8 24 f8 ff ff       	call   801052c0 <create>
    if(ip == 0){
80105a9c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a9f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	75 99                	jne    80105a3e <sys_open+0x6e>
      end_op();
80105aa5:	e8 e6 da ff ff       	call   80103590 <end_op>
      return -1;
80105aaa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aaf:	eb 40                	jmp    80105af1 <sys_open+0x121>
80105ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105abb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105abf:	56                   	push   %esi
80105ac0:	e8 7b bd ff ff       	call   80101840 <iunlock>
  end_op();
80105ac5:	e8 c6 da ff ff       	call   80103590 <end_op>

  f->type = FD_INODE;
80105aca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ad0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ad3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ad6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ad9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105adb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105ae2:	f7 d0                	not    %eax
80105ae4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ae7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105aea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af4:	89 d8                	mov    %ebx,%eax
80105af6:	5b                   	pop    %ebx
80105af7:	5e                   	pop    %esi
80105af8:	5f                   	pop    %edi
80105af9:	5d                   	pop    %ebp
80105afa:	c3                   	ret    
80105afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b00:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b03:	85 c9                	test   %ecx,%ecx
80105b05:	0f 84 33 ff ff ff    	je     80105a3e <sys_open+0x6e>
80105b0b:	e9 5c ff ff ff       	jmp    80105a6c <sys_open+0x9c>

80105b10 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b10:	f3 0f 1e fb          	endbr32 
80105b14:	55                   	push   %ebp
80105b15:	89 e5                	mov    %esp,%ebp
80105b17:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b1a:	e8 01 da ff ff       	call   80103520 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b1f:	83 ec 08             	sub    $0x8,%esp
80105b22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b25:	50                   	push   %eax
80105b26:	6a 00                	push   $0x0
80105b28:	e8 e3 f6 ff ff       	call   80105210 <argstr>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 34                	js     80105b68 <sys_mkdir+0x58>
80105b34:	83 ec 0c             	sub    $0xc,%esp
80105b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3a:	31 c9                	xor    %ecx,%ecx
80105b3c:	ba 01 00 00 00       	mov    $0x1,%edx
80105b41:	6a 00                	push   $0x0
80105b43:	e8 78 f7 ff ff       	call   801052c0 <create>
80105b48:	83 c4 10             	add    $0x10,%esp
80105b4b:	85 c0                	test   %eax,%eax
80105b4d:	74 19                	je     80105b68 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b4f:	83 ec 0c             	sub    $0xc,%esp
80105b52:	50                   	push   %eax
80105b53:	e8 a8 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105b58:	e8 33 da ff ff       	call   80103590 <end_op>
  return 0;
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	31 c0                	xor    %eax,%eax
}
80105b62:	c9                   	leave  
80105b63:	c3                   	ret    
80105b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b68:	e8 23 da ff ff       	call   80103590 <end_op>
    return -1;
80105b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b72:	c9                   	leave  
80105b73:	c3                   	ret    
80105b74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b7f:	90                   	nop

80105b80 <sys_mknod>:

int
sys_mknod(void)
{
80105b80:	f3 0f 1e fb          	endbr32 
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
80105b87:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b8a:	e8 91 d9 ff ff       	call   80103520 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b8f:	83 ec 08             	sub    $0x8,%esp
80105b92:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b95:	50                   	push   %eax
80105b96:	6a 00                	push   $0x0
80105b98:	e8 73 f6 ff ff       	call   80105210 <argstr>
80105b9d:	83 c4 10             	add    $0x10,%esp
80105ba0:	85 c0                	test   %eax,%eax
80105ba2:	78 64                	js     80105c08 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105ba4:	83 ec 08             	sub    $0x8,%esp
80105ba7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105baa:	50                   	push   %eax
80105bab:	6a 01                	push   $0x1
80105bad:	e8 ae f5 ff ff       	call   80105160 <argint>
  if((argstr(0, &path)) < 0 ||
80105bb2:	83 c4 10             	add    $0x10,%esp
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	78 4f                	js     80105c08 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105bb9:	83 ec 08             	sub    $0x8,%esp
80105bbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bbf:	50                   	push   %eax
80105bc0:	6a 02                	push   $0x2
80105bc2:	e8 99 f5 ff ff       	call   80105160 <argint>
     argint(1, &major) < 0 ||
80105bc7:	83 c4 10             	add    $0x10,%esp
80105bca:	85 c0                	test   %eax,%eax
80105bcc:	78 3a                	js     80105c08 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bce:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105bd9:	ba 03 00 00 00       	mov    $0x3,%edx
80105bde:	50                   	push   %eax
80105bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105be2:	e8 d9 f6 ff ff       	call   801052c0 <create>
     argint(2, &minor) < 0 ||
80105be7:	83 c4 10             	add    $0x10,%esp
80105bea:	85 c0                	test   %eax,%eax
80105bec:	74 1a                	je     80105c08 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bee:	83 ec 0c             	sub    $0xc,%esp
80105bf1:	50                   	push   %eax
80105bf2:	e8 09 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105bf7:	e8 94 d9 ff ff       	call   80103590 <end_op>
  return 0;
80105bfc:	83 c4 10             	add    $0x10,%esp
80105bff:	31 c0                	xor    %eax,%eax
}
80105c01:	c9                   	leave  
80105c02:	c3                   	ret    
80105c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c07:	90                   	nop
    end_op();
80105c08:	e8 83 d9 ff ff       	call   80103590 <end_op>
    return -1;
80105c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c12:	c9                   	leave  
80105c13:	c3                   	ret    
80105c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop

80105c20 <sys_chdir>:

int
sys_chdir(void)
{
80105c20:	f3 0f 1e fb          	endbr32 
80105c24:	55                   	push   %ebp
80105c25:	89 e5                	mov    %esp,%ebp
80105c27:	56                   	push   %esi
80105c28:	53                   	push   %ebx
80105c29:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c2c:	e8 1f e5 ff ff       	call   80104150 <myproc>
80105c31:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c33:	e8 e8 d8 ff ff       	call   80103520 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c38:	83 ec 08             	sub    $0x8,%esp
80105c3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c3e:	50                   	push   %eax
80105c3f:	6a 00                	push   $0x0
80105c41:	e8 ca f5 ff ff       	call   80105210 <argstr>
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	78 73                	js     80105cc0 <sys_chdir+0xa0>
80105c4d:	83 ec 0c             	sub    $0xc,%esp
80105c50:	ff 75 f4             	pushl  -0xc(%ebp)
80105c53:	e8 d8 c3 ff ff       	call   80102030 <namei>
80105c58:	83 c4 10             	add    $0x10,%esp
80105c5b:	89 c3                	mov    %eax,%ebx
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	74 5f                	je     80105cc0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c61:	83 ec 0c             	sub    $0xc,%esp
80105c64:	50                   	push   %eax
80105c65:	e8 f6 ba ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105c6a:	83 c4 10             	add    $0x10,%esp
80105c6d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c72:	75 2c                	jne    80105ca0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c74:	83 ec 0c             	sub    $0xc,%esp
80105c77:	53                   	push   %ebx
80105c78:	e8 c3 bb ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105c7d:	58                   	pop    %eax
80105c7e:	ff 76 68             	pushl  0x68(%esi)
80105c81:	e8 0a bc ff ff       	call   80101890 <iput>
  end_op();
80105c86:	e8 05 d9 ff ff       	call   80103590 <end_op>
  curproc->cwd = ip;
80105c8b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	31 c0                	xor    %eax,%eax
}
80105c93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c96:	5b                   	pop    %ebx
80105c97:	5e                   	pop    %esi
80105c98:	5d                   	pop    %ebp
80105c99:	c3                   	ret    
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	53                   	push   %ebx
80105ca4:	e8 57 bd ff ff       	call   80101a00 <iunlockput>
    end_op();
80105ca9:	e8 e2 d8 ff ff       	call   80103590 <end_op>
    return -1;
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb6:	eb db                	jmp    80105c93 <sys_chdir+0x73>
80105cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop
    end_op();
80105cc0:	e8 cb d8 ff ff       	call   80103590 <end_op>
    return -1;
80105cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cca:	eb c7                	jmp    80105c93 <sys_chdir+0x73>
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <sys_exec>:

int
sys_exec(void)
{
80105cd0:	f3 0f 1e fb          	endbr32 
80105cd4:	55                   	push   %ebp
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	57                   	push   %edi
80105cd8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cd9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105cdf:	53                   	push   %ebx
80105ce0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ce6:	50                   	push   %eax
80105ce7:	6a 00                	push   $0x0
80105ce9:	e8 22 f5 ff ff       	call   80105210 <argstr>
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	85 c0                	test   %eax,%eax
80105cf3:	0f 88 8b 00 00 00    	js     80105d84 <sys_exec+0xb4>
80105cf9:	83 ec 08             	sub    $0x8,%esp
80105cfc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d02:	50                   	push   %eax
80105d03:	6a 01                	push   $0x1
80105d05:	e8 56 f4 ff ff       	call   80105160 <argint>
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	78 73                	js     80105d84 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d11:	83 ec 04             	sub    $0x4,%esp
80105d14:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105d1a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d1c:	68 80 00 00 00       	push   $0x80
80105d21:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d27:	6a 00                	push   $0x0
80105d29:	50                   	push   %eax
80105d2a:	e8 51 f1 ff ff       	call   80104e80 <memset>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d38:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d3e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d45:	83 ec 08             	sub    $0x8,%esp
80105d48:	57                   	push   %edi
80105d49:	01 f0                	add    %esi,%eax
80105d4b:	50                   	push   %eax
80105d4c:	e8 6f f3 ff ff       	call   801050c0 <fetchint>
80105d51:	83 c4 10             	add    $0x10,%esp
80105d54:	85 c0                	test   %eax,%eax
80105d56:	78 2c                	js     80105d84 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105d58:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d5e:	85 c0                	test   %eax,%eax
80105d60:	74 36                	je     80105d98 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d62:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105d68:	83 ec 08             	sub    $0x8,%esp
80105d6b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105d6e:	52                   	push   %edx
80105d6f:	50                   	push   %eax
80105d70:	e8 8b f3 ff ff       	call   80105100 <fetchstr>
80105d75:	83 c4 10             	add    $0x10,%esp
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	78 08                	js     80105d84 <sys_exec+0xb4>
  for(i=0;; i++){
80105d7c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d7f:	83 fb 20             	cmp    $0x20,%ebx
80105d82:	75 b4                	jne    80105d38 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d8c:	5b                   	pop    %ebx
80105d8d:	5e                   	pop    %esi
80105d8e:	5f                   	pop    %edi
80105d8f:	5d                   	pop    %ebp
80105d90:	c3                   	ret    
80105d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105d98:	83 ec 08             	sub    $0x8,%esp
80105d9b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105da1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105da8:	00 00 00 00 
  return exec(path, argv);
80105dac:	50                   	push   %eax
80105dad:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105db3:	e8 c8 ac ff ff       	call   80100a80 <exec>
80105db8:	83 c4 10             	add    $0x10,%esp
}
80105dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dbe:	5b                   	pop    %ebx
80105dbf:	5e                   	pop    %esi
80105dc0:	5f                   	pop    %edi
80105dc1:	5d                   	pop    %ebp
80105dc2:	c3                   	ret    
80105dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105dd0 <sys_pipe>:

int
sys_pipe(void)
{
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	57                   	push   %edi
80105dd8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dd9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ddc:	53                   	push   %ebx
80105ddd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105de0:	6a 08                	push   $0x8
80105de2:	50                   	push   %eax
80105de3:	6a 00                	push   $0x0
80105de5:	e8 c6 f3 ff ff       	call   801051b0 <argptr>
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	85 c0                	test   %eax,%eax
80105def:	78 4e                	js     80105e3f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105df1:	83 ec 08             	sub    $0x8,%esp
80105df4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105df7:	50                   	push   %eax
80105df8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dfb:	50                   	push   %eax
80105dfc:	e8 df dd ff ff       	call   80103be0 <pipealloc>
80105e01:	83 c4 10             	add    $0x10,%esp
80105e04:	85 c0                	test   %eax,%eax
80105e06:	78 37                	js     80105e3f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e08:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e0b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e0d:	e8 3e e3 ff ff       	call   80104150 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105e18:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e1c:	85 f6                	test   %esi,%esi
80105e1e:	74 30                	je     80105e50 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105e20:	83 c3 01             	add    $0x1,%ebx
80105e23:	83 fb 10             	cmp    $0x10,%ebx
80105e26:	75 f0                	jne    80105e18 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e28:	83 ec 0c             	sub    $0xc,%esp
80105e2b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e2e:	e8 8d b0 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105e33:	58                   	pop    %eax
80105e34:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e37:	e8 84 b0 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105e3c:	83 c4 10             	add    $0x10,%esp
80105e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e44:	eb 5b                	jmp    80105ea1 <sys_pipe+0xd1>
80105e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105e50:	8d 73 08             	lea    0x8(%ebx),%esi
80105e53:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e5a:	e8 f1 e2 ff ff       	call   80104150 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e5f:	31 d2                	xor    %edx,%edx
80105e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e68:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e6c:	85 c9                	test   %ecx,%ecx
80105e6e:	74 20                	je     80105e90 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105e70:	83 c2 01             	add    $0x1,%edx
80105e73:	83 fa 10             	cmp    $0x10,%edx
80105e76:	75 f0                	jne    80105e68 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105e78:	e8 d3 e2 ff ff       	call   80104150 <myproc>
80105e7d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e84:	00 
80105e85:	eb a1                	jmp    80105e28 <sys_pipe+0x58>
80105e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e90:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e94:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e97:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e9c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e9f:	31 c0                	xor    %eax,%eax
}
80105ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea4:	5b                   	pop    %ebx
80105ea5:	5e                   	pop    %esi
80105ea6:	5f                   	pop    %edi
80105ea7:	5d                   	pop    %ebp
80105ea8:	c3                   	ret    
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_swapread>:

int sys_swapread(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105eba:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ebd:	68 00 10 00 00       	push   $0x1000
80105ec2:	50                   	push   %eax
80105ec3:	6a 00                	push   $0x0
80105ec5:	e8 e6 f2 ff ff       	call   801051b0 <argptr>
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	85 c0                	test   %eax,%eax
80105ecf:	78 2f                	js     80105f00 <sys_swapread+0x50>
80105ed1:	83 ec 08             	sub    $0x8,%esp
80105ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed7:	50                   	push   %eax
80105ed8:	6a 01                	push   $0x1
80105eda:	e8 81 f2 ff ff       	call   80105160 <argint>
80105edf:	83 c4 10             	add    $0x10,%esp
80105ee2:	85 c0                	test   %eax,%eax
80105ee4:	78 1a                	js     80105f00 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105ee6:	83 ec 08             	sub    $0x8,%esp
80105ee9:	ff 75 f4             	pushl  -0xc(%ebp)
80105eec:	ff 75 f0             	pushl  -0x10(%ebp)
80105eef:	e8 7c c1 ff ff       	call   80102070 <swapread>
	return 0;
80105ef4:	83 c4 10             	add    $0x10,%esp
80105ef7:	31 c0                	xor    %eax,%eax
}
80105ef9:	c9                   	leave  
80105efa:	c3                   	ret    
80105efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eff:	90                   	nop
80105f00:	c9                   	leave  
		return -1;
80105f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f06:	c3                   	ret    
80105f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105f10:	f3 0f 1e fb          	endbr32 
80105f14:	55                   	push   %ebp
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105f1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f1d:	68 00 10 00 00       	push   $0x1000
80105f22:	50                   	push   %eax
80105f23:	6a 00                	push   $0x0
80105f25:	e8 86 f2 ff ff       	call   801051b0 <argptr>
80105f2a:	83 c4 10             	add    $0x10,%esp
80105f2d:	85 c0                	test   %eax,%eax
80105f2f:	78 2f                	js     80105f60 <sys_swapwrite+0x50>
80105f31:	83 ec 08             	sub    $0x8,%esp
80105f34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f37:	50                   	push   %eax
80105f38:	6a 01                	push   $0x1
80105f3a:	e8 21 f2 ff ff       	call   80105160 <argint>
80105f3f:	83 c4 10             	add    $0x10,%esp
80105f42:	85 c0                	test   %eax,%eax
80105f44:	78 1a                	js     80105f60 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105f46:	83 ec 08             	sub    $0x8,%esp
80105f49:	ff 75 f4             	pushl  -0xc(%ebp)
80105f4c:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4f:	e8 bc c1 ff ff       	call   80102110 <swapwrite>
	return 0;
80105f54:	83 c4 10             	add    $0x10,%esp
80105f57:	31 c0                	xor    %eax,%eax
}
80105f59:	c9                   	leave  
80105f5a:	c3                   	ret    
80105f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f5f:	90                   	nop
80105f60:	c9                   	leave  
		return -1;
80105f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f66:	c3                   	ret    
80105f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6e:	66 90                	xchg   %ax,%ax

80105f70 <sys_swapstat>:

int sys_swapstat(void)
{
80105f70:	f3 0f 1e fb          	endbr32 
80105f74:	55                   	push   %ebp
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105f78:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80105f7b:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105f7e:	6a 04                	push   $0x4
80105f80:	50                   	push   %eax
80105f81:	6a 00                	push   $0x0
80105f83:	e8 28 f2 ff ff       	call   801051b0 <argptr>
80105f88:	83 c4 10             	add    $0x10,%esp
80105f8b:	85 c0                	test   %eax,%eax
80105f8d:	75 39                	jne    80105fc8 <sys_swapstat+0x58>
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
80105f8f:	83 ec 04             	sub    $0x4,%esp
80105f92:	89 c3                	mov    %eax,%ebx
80105f94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f97:	6a 04                	push   $0x4
80105f99:	50                   	push   %eax
80105f9a:	6a 01                	push   $0x1
80105f9c:	e8 0f f2 ff ff       	call   801051b0 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105fa1:	83 c4 10             	add    $0x10,%esp
80105fa4:	85 c0                	test   %eax,%eax
80105fa6:	78 20                	js     80105fc8 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
80105fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fab:	8b 15 e0 19 11 80    	mov    0x801119e0,%edx
80105fb1:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
80105fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb6:	8b 15 00 1a 11 80    	mov    0x80111a00,%edx
80105fbc:	89 10                	mov    %edx,(%eax)
	return 0;
}
80105fbe:	89 d8                	mov    %ebx,%eax
80105fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fc3:	c9                   	leave  
80105fc4:	c3                   	ret    
80105fc5:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
80105fc8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fcd:	eb ef                	jmp    80105fbe <sys_swapstat+0x4e>
80105fcf:	90                   	nop

80105fd0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105fd0:	f3 0f 1e fb          	endbr32 
  return fork();
80105fd4:	e9 47 e3 ff ff       	jmp    80104320 <fork>
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <sys_exit>:
}

int
sys_exit(void)
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
80105fe5:	89 e5                	mov    %esp,%ebp
80105fe7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105fea:	e8 b1 e5 ff ff       	call   801045a0 <exit>
  return 0;  // not reached
}
80105fef:	31 c0                	xor    %eax,%eax
80105ff1:	c9                   	leave  
80105ff2:	c3                   	ret    
80105ff3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106000 <sys_wait>:

int
sys_wait(void)
{
80106000:	f3 0f 1e fb          	endbr32 
  return wait();
80106004:	e9 e7 e7 ff ff       	jmp    801047f0 <wait>
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106010 <sys_kill>:
}

int
sys_kill(void)
{
80106010:	f3 0f 1e fb          	endbr32 
80106014:	55                   	push   %ebp
80106015:	89 e5                	mov    %esp,%ebp
80106017:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010601a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010601d:	50                   	push   %eax
8010601e:	6a 00                	push   $0x0
80106020:	e8 3b f1 ff ff       	call   80105160 <argint>
80106025:	83 c4 10             	add    $0x10,%esp
80106028:	85 c0                	test   %eax,%eax
8010602a:	78 14                	js     80106040 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010602c:	83 ec 0c             	sub    $0xc,%esp
8010602f:	ff 75 f4             	pushl  -0xc(%ebp)
80106032:	e8 19 e9 ff ff       	call   80104950 <kill>
80106037:	83 c4 10             	add    $0x10,%esp
}
8010603a:	c9                   	leave  
8010603b:	c3                   	ret    
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106040:	c9                   	leave  
    return -1;
80106041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106046:	c3                   	ret    
80106047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604e:	66 90                	xchg   %ax,%ax

80106050 <sys_getpid>:

int
sys_getpid(void)
{
80106050:	f3 0f 1e fb          	endbr32 
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010605a:	e8 f1 e0 ff ff       	call   80104150 <myproc>
8010605f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106062:	c9                   	leave  
80106063:	c3                   	ret    
80106064:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010606f:	90                   	nop

80106070 <sys_sbrk>:

int
sys_sbrk(void)
{
80106070:	f3 0f 1e fb          	endbr32 
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106078:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010607b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010607e:	50                   	push   %eax
8010607f:	6a 00                	push   $0x0
80106081:	e8 da f0 ff ff       	call   80105160 <argint>
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	85 c0                	test   %eax,%eax
8010608b:	78 23                	js     801060b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010608d:	e8 be e0 ff ff       	call   80104150 <myproc>
  if(growproc(n) < 0)
80106092:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106095:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106097:	ff 75 f4             	pushl  -0xc(%ebp)
8010609a:	e8 01 e2 ff ff       	call   801042a0 <growproc>
8010609f:	83 c4 10             	add    $0x10,%esp
801060a2:	85 c0                	test   %eax,%eax
801060a4:	78 0a                	js     801060b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801060a6:	89 d8                	mov    %ebx,%eax
801060a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060ab:	c9                   	leave  
801060ac:	c3                   	ret    
801060ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060b5:	eb ef                	jmp    801060a6 <sys_sbrk+0x36>
801060b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060be:	66 90                	xchg   %ax,%ax

801060c0 <sys_sleep>:

int
sys_sleep(void)
{
801060c0:	f3 0f 1e fb          	endbr32 
801060c4:	55                   	push   %ebp
801060c5:	89 e5                	mov    %esp,%ebp
801060c7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801060c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060cb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060ce:	50                   	push   %eax
801060cf:	6a 00                	push   $0x0
801060d1:	e8 8a f0 ff ff       	call   80105160 <argint>
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	85 c0                	test   %eax,%eax
801060db:	0f 88 86 00 00 00    	js     80106167 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801060e1:	83 ec 0c             	sub    $0xc,%esp
801060e4:	68 40 bd 13 80       	push   $0x8013bd40
801060e9:	e8 82 ec ff ff       	call   80104d70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801060f1:	8b 1d 80 c5 13 80    	mov    0x8013c580,%ebx
  while(ticks - ticks0 < n){
801060f7:	83 c4 10             	add    $0x10,%esp
801060fa:	85 d2                	test   %edx,%edx
801060fc:	75 23                	jne    80106121 <sys_sleep+0x61>
801060fe:	eb 50                	jmp    80106150 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106100:	83 ec 08             	sub    $0x8,%esp
80106103:	68 40 bd 13 80       	push   $0x8013bd40
80106108:	68 80 c5 13 80       	push   $0x8013c580
8010610d:	e8 1e e6 ff ff       	call   80104730 <sleep>
  while(ticks - ticks0 < n){
80106112:	a1 80 c5 13 80       	mov    0x8013c580,%eax
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	29 d8                	sub    %ebx,%eax
8010611c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010611f:	73 2f                	jae    80106150 <sys_sleep+0x90>
    if(myproc()->killed){
80106121:	e8 2a e0 ff ff       	call   80104150 <myproc>
80106126:	8b 40 24             	mov    0x24(%eax),%eax
80106129:	85 c0                	test   %eax,%eax
8010612b:	74 d3                	je     80106100 <sys_sleep+0x40>
      release(&tickslock);
8010612d:	83 ec 0c             	sub    $0xc,%esp
80106130:	68 40 bd 13 80       	push   $0x8013bd40
80106135:	e8 f6 ec ff ff       	call   80104e30 <release>
  }
  release(&tickslock);
  return 0;
}
8010613a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106145:	c9                   	leave  
80106146:	c3                   	ret    
80106147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	68 40 bd 13 80       	push   $0x8013bd40
80106158:	e8 d3 ec ff ff       	call   80104e30 <release>
  return 0;
8010615d:	83 c4 10             	add    $0x10,%esp
80106160:	31 c0                	xor    %eax,%eax
}
80106162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106165:	c9                   	leave  
80106166:	c3                   	ret    
    return -1;
80106167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616c:	eb f4                	jmp    80106162 <sys_sleep+0xa2>
8010616e:	66 90                	xchg   %ax,%ax

80106170 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	53                   	push   %ebx
80106178:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010617b:	68 40 bd 13 80       	push   $0x8013bd40
80106180:	e8 eb eb ff ff       	call   80104d70 <acquire>
  xticks = ticks;
80106185:	8b 1d 80 c5 13 80    	mov    0x8013c580,%ebx
  release(&tickslock);
8010618b:	c7 04 24 40 bd 13 80 	movl   $0x8013bd40,(%esp)
80106192:	e8 99 ec ff ff       	call   80104e30 <release>
  return xticks;
}
80106197:	89 d8                	mov    %ebx,%eax
80106199:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010619c:	c9                   	leave  
8010619d:	c3                   	ret    

8010619e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010619e:	1e                   	push   %ds
  pushl %es
8010619f:	06                   	push   %es
  pushl %fs
801061a0:	0f a0                	push   %fs
  pushl %gs
801061a2:	0f a8                	push   %gs
  pushal
801061a4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801061a5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801061a9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801061ab:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801061ad:	54                   	push   %esp
  call trap
801061ae:	e8 8d 01 00 00       	call   80106340 <trap>
  addl $4, %esp
801061b3:	83 c4 04             	add    $0x4,%esp

801061b6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801061b6:	61                   	popa   
  popl %gs
801061b7:	0f a9                	pop    %gs
  popl %fs
801061b9:	0f a1                	pop    %fs
  popl %es
801061bb:	07                   	pop    %es
  popl %ds
801061bc:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801061bd:	83 c4 08             	add    $0x8,%esp
  iret
801061c0:	cf                   	iret   
801061c1:	66 90                	xchg   %ax,%ax
801061c3:	66 90                	xchg   %ax,%ax
801061c5:	66 90                	xchg   %ax,%ax
801061c7:	66 90                	xchg   %ax,%ax
801061c9:	66 90                	xchg   %ax,%ax
801061cb:	66 90                	xchg   %ax,%ax
801061cd:	66 90                	xchg   %ax,%ax
801061cf:	90                   	nop

801061d0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061d0:	f3 0f 1e fb          	endbr32 
801061d4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801061d5:	31 c0                	xor    %eax,%eax
{
801061d7:	89 e5                	mov    %esp,%ebp
801061d9:	83 ec 08             	sub    $0x8,%esp
801061dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061e0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801061e7:	c7 04 c5 82 bd 13 80 	movl   $0x8e000008,-0x7fec427e(,%eax,8)
801061ee:	08 00 00 8e 
801061f2:	66 89 14 c5 80 bd 13 	mov    %dx,-0x7fec4280(,%eax,8)
801061f9:	80 
801061fa:	c1 ea 10             	shr    $0x10,%edx
801061fd:	66 89 14 c5 86 bd 13 	mov    %dx,-0x7fec427a(,%eax,8)
80106204:	80 
  for(i = 0; i < 256; i++)
80106205:	83 c0 01             	add    $0x1,%eax
80106208:	3d 00 01 00 00       	cmp    $0x100,%eax
8010620d:	75 d1                	jne    801061e0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010620f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106212:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106217:	c7 05 82 bf 13 80 08 	movl   $0xef000008,0x8013bf82
8010621e:	00 00 ef 
  initlock(&tickslock, "time");
80106221:	68 e5 84 10 80       	push   $0x801084e5
80106226:	68 40 bd 13 80       	push   $0x8013bd40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010622b:	66 a3 80 bf 13 80    	mov    %ax,0x8013bf80
80106231:	c1 e8 10             	shr    $0x10,%eax
80106234:	66 a3 86 bf 13 80    	mov    %ax,0x8013bf86
  initlock(&tickslock, "time");
8010623a:	e8 b1 e9 ff ff       	call   80104bf0 <initlock>
}
8010623f:	83 c4 10             	add    $0x10,%esp
80106242:	c9                   	leave  
80106243:	c3                   	ret    
80106244:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010624f:	90                   	nop

80106250 <idtinit>:

void
idtinit(void)
{
80106250:	f3 0f 1e fb          	endbr32 
80106254:	55                   	push   %ebp
  pd[0] = size-1;
80106255:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010625a:	89 e5                	mov    %esp,%ebp
8010625c:	83 ec 10             	sub    $0x10,%esp
8010625f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106263:	b8 80 bd 13 80       	mov    $0x8013bd80,%eax
80106268:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010626c:	c1 e8 10             	shr    $0x10,%eax
8010626f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106273:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106276:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106279:	c9                   	leave  
8010627a:	c3                   	ret    
8010627b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010627f:	90                   	nop

80106280 <swapin>:

int swapin(struct trapframe* tf, int flt_addr){ // -1: KILL, 0: success
80106280:	f3 0f 1e fb          	endbr32 
80106284:	55                   	push   %ebp
80106285:	89 e5                	mov    %esp,%ebp
80106287:	57                   	push   %edi
80106288:	56                   	push   %esi
80106289:	53                   	push   %ebx
8010628a:	83 ec 1c             	sub    $0x1c,%esp
  // rcr2 = user.vaddr
  struct proc *cp = myproc();
8010628d:	e8 be de ff ff       	call   80104150 <myproc>
  // cprintf("here0\n");
  pde_t *pde = cp->pgdir;
  pte_t *pte = walkpgdir(pde, (void *)flt_addr, 1);
80106292:	83 ec 04             	sub    $0x4,%esp
  pde_t *pde = cp->pgdir;
80106295:	8b 78 04             	mov    0x4(%eax),%edi
  pte_t *pte = walkpgdir(pde, (void *)flt_addr, 1);
80106298:	6a 01                	push   $0x1
  struct proc *cp = myproc();
8010629a:	89 c6                	mov    %eax,%esi
  pte_t *pte = walkpgdir(pde, (void *)flt_addr, 1);
8010629c:	ff 75 0c             	pushl  0xc(%ebp)
8010629f:	57                   	push   %edi
801062a0:	e8 bb 0f 00 00       	call   80107260 <walkpgdir>
  // cprintf("swapin: walkpgdir pgdir=%p flt_addr=%p *pte=%p\n", cp->pgdir, flt_addr, *pte);
  // cprintf("here1\n");
  if((!(*pte & PTE_P) && (*pte != (pte_t)0))){
801062a5:	83 c4 10             	add    $0x10,%esp
801062a8:	8b 18                	mov    (%eax),%ebx
801062aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801062ad:	f6 c3 01             	test   $0x1,%bl
801062b0:	75 7e                	jne    80106330 <swapin+0xb0>
801062b2:	85 db                	test   %ebx,%ebx
801062b4:	74 7a                	je     80106330 <swapin+0xb0>
    // cprintf("swapin: swapin really required for *pte=%p\n",*pte);
    // print_bitmap(0, 11);
    uint block_number = (uint)(*pte) >> 12; // PFN 구하기(==block index)
    char *mem = kalloc(); // get 'empty allocated kernel virtual address'
801062b6:	e8 65 cb ff ff       	call   80102e20 <kalloc>
    uint block_number = (uint)(*pte) >> 12; // PFN 구하기(==block index)
801062bb:	c1 eb 0c             	shr    $0xc,%ebx
    if(bitmap[block_number]){
801062be:	8b 0c 9d c0 36 11 80 	mov    -0x7feec940(,%ebx,4),%ecx
801062c5:	85 c9                	test   %ecx,%ecx
801062c7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801062ca:	75 44                	jne    80106310 <swapin+0x90>
        // release(&kmem.lock);
      swapread(mem, block_number);
      // if(kmem.use_lock)
        // acquire(&kmem.lock);
    }
    uint pte_flag = *pte & 0x00000FFF;
801062cc:	8b 11                	mov    (%ecx),%edx
    pte_flag |= PTE_P;  // set FLAG[0]=1
    *pte = V2P(mem) | pte_flag; // set pte[31:12]=PhyAddr(flt_addr) => 맞나?
801062ce:	05 00 00 00 80       	add    $0x80000000,%eax
    lru_append(cp->pgdir, (char*)flt_addr); // lru_append 에 va 인 flt_addr 를 넣는다 => cp=>pgdir 맞나?
801062d3:	83 ec 08             	sub    $0x8,%esp
    change_bitmap(block_number, 0); // clear corresponding bit in the bitmap
    lcr3(V2P(pde));
801062d6:	81 c7 00 00 00 80    	add    $0x80000000,%edi
    uint pte_flag = *pte & 0x00000FFF;
801062dc:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    *pte = V2P(mem) | pte_flag; // set pte[31:12]=PhyAddr(flt_addr) => 맞나?
801062e2:	09 d0                	or     %edx,%eax
801062e4:	83 c8 01             	or     $0x1,%eax
801062e7:	89 01                	mov    %eax,(%ecx)
    lru_append(cp->pgdir, (char*)flt_addr); // lru_append 에 va 인 flt_addr 를 넣는다 => cp=>pgdir 맞나?
801062e9:	ff 75 0c             	pushl  0xc(%ebp)
801062ec:	ff 76 04             	pushl  0x4(%esi)
801062ef:	e8 4c c5 ff ff       	call   80102840 <lru_append>
    change_bitmap(block_number, 0); // clear corresponding bit in the bitmap
801062f4:	58                   	pop    %eax
801062f5:	5a                   	pop    %edx
801062f6:	6a 00                	push   $0x0
801062f8:	53                   	push   %ebx
801062f9:	e8 a2 c2 ff ff       	call   801025a0 <change_bitmap>
  asm volatile("movl %0,%%cr3" : : "r" (val));
801062fe:	0f 22 df             	mov    %edi,%cr3
  else{
    // panic("swapin don't needed => Code ERROR\n"); //
    return -1;
  }
  // cprintf("swapin ended successfully\n");
  return 0;
80106301:	31 c0                	xor    %eax,%eax
80106303:	83 c4 10             	add    $0x10,%esp
}
80106306:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106309:	5b                   	pop    %ebx
8010630a:	5e                   	pop    %esi
8010630b:	5f                   	pop    %edi
8010630c:	5d                   	pop    %ebp
8010630d:	c3                   	ret    
8010630e:	66 90                	xchg   %ax,%ax
      swapread(mem, block_number);
80106310:	83 ec 08             	sub    $0x8,%esp
80106313:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106316:	53                   	push   %ebx
80106317:	50                   	push   %eax
80106318:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010631b:	e8 50 bd ff ff       	call   80102070 <swapread>
80106320:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106326:	83 c4 10             	add    $0x10,%esp
80106329:	eb a1                	jmp    801062cc <swapin+0x4c>
8010632b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010632f:	90                   	nop
    return -1;
80106330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106335:	eb cf                	jmp    80106306 <swapin+0x86>
80106337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010633e:	66 90                	xchg   %ax,%ax

80106340 <trap>:

void
trap(struct trapframe *tf)
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
80106345:	89 e5                	mov    %esp,%ebp
80106347:	57                   	push   %edi
80106348:	56                   	push   %esi
80106349:	53                   	push   %ebx
8010634a:	83 ec 1c             	sub    $0x1c,%esp
8010634d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106350:	8b 43 30             	mov    0x30(%ebx),%eax
80106353:	83 f8 40             	cmp    $0x40,%eax
80106356:	0f 84 bc 01 00 00    	je     80106518 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }
  // My Code
  if(tf->trapno == T_PGFLT){
8010635c:	83 f8 0e             	cmp    $0xe,%eax
8010635f:	74 17                	je     80106378 <trap+0x38>
      goto KILL;
    }
    return;
  }

  switch(tf->trapno){
80106361:	83 e8 20             	sub    $0x20,%eax
80106364:	83 f8 1f             	cmp    $0x1f,%eax
80106367:	77 28                	ja     80106391 <trap+0x51>
80106369:	3e ff 24 85 8c 85 10 	notrack jmp *-0x7fef7a74(,%eax,4)
80106370:	80 
80106371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106378:	0f 20 d0             	mov    %cr2,%eax
    if (swapin(tf, flt_addr) == -1)
8010637b:	83 ec 08             	sub    $0x8,%esp
8010637e:	50                   	push   %eax
8010637f:	53                   	push   %ebx
80106380:	e8 fb fe ff ff       	call   80106280 <swapin>
80106385:	83 c4 10             	add    $0x10,%esp
80106388:	83 f8 ff             	cmp    $0xffffffff,%eax
8010638b:	0f 85 d2 00 00 00    	jne    80106463 <trap+0x123>
    lapiceoi();
    break;

  KILL:
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106391:	e8 ba dd ff ff       	call   80104150 <myproc>
80106396:	8b 7b 38             	mov    0x38(%ebx),%edi
80106399:	85 c0                	test   %eax,%eax
8010639b:	0f 84 03 02 00 00    	je     801065a4 <trap+0x264>
801063a1:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801063a5:	0f 84 f9 01 00 00    	je     801065a4 <trap+0x264>
801063ab:	0f 20 d1             	mov    %cr2,%ecx
801063ae:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063b1:	e8 7a dd ff ff       	call   80104130 <cpuid>
801063b6:	8b 73 30             	mov    0x30(%ebx),%esi
801063b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063bc:	8b 43 34             	mov    0x34(%ebx),%eax
801063bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063c2:	e8 89 dd ff ff       	call   80104150 <myproc>
801063c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063ca:	e8 81 dd ff ff       	call   80104150 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063cf:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063d5:	51                   	push   %ecx
801063d6:	57                   	push   %edi
801063d7:	52                   	push   %edx
801063d8:	ff 75 e4             	pushl  -0x1c(%ebp)
801063db:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063dc:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063df:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063e2:	56                   	push   %esi
801063e3:	ff 70 10             	pushl  0x10(%eax)
801063e6:	68 48 85 10 80       	push   $0x80108548
801063eb:	e8 c0 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063f0:	83 c4 20             	add    $0x20,%esp
801063f3:	e8 58 dd ff ff       	call   80104150 <myproc>
801063f8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ff:	e8 4c dd ff ff       	call   80104150 <myproc>
80106404:	85 c0                	test   %eax,%eax
80106406:	74 1d                	je     80106425 <trap+0xe5>
80106408:	e8 43 dd ff ff       	call   80104150 <myproc>
8010640d:	8b 50 24             	mov    0x24(%eax),%edx
80106410:	85 d2                	test   %edx,%edx
80106412:	74 11                	je     80106425 <trap+0xe5>
80106414:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106418:	83 e0 03             	and    $0x3,%eax
8010641b:	66 83 f8 03          	cmp    $0x3,%ax
8010641f:	0f 84 2b 01 00 00    	je     80106550 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106425:	e8 26 dd ff ff       	call   80104150 <myproc>
8010642a:	85 c0                	test   %eax,%eax
8010642c:	74 0f                	je     8010643d <trap+0xfd>
8010642e:	e8 1d dd ff ff       	call   80104150 <myproc>
80106433:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106437:	0f 84 c3 00 00 00    	je     80106500 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
       yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010643d:	e8 0e dd ff ff       	call   80104150 <myproc>
80106442:	85 c0                	test   %eax,%eax
80106444:	74 1d                	je     80106463 <trap+0x123>
80106446:	e8 05 dd ff ff       	call   80104150 <myproc>
8010644b:	8b 40 24             	mov    0x24(%eax),%eax
8010644e:	85 c0                	test   %eax,%eax
80106450:	74 11                	je     80106463 <trap+0x123>
80106452:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106456:	83 e0 03             	and    $0x3,%eax
80106459:	66 83 f8 03          	cmp    $0x3,%ax
8010645d:	0f 84 de 00 00 00    	je     80106541 <trap+0x201>
    exit();
}
80106463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106466:	5b                   	pop    %ebx
80106467:	5e                   	pop    %esi
80106468:	5f                   	pop    %edi
80106469:	5d                   	pop    %ebp
8010646a:	c3                   	ret    
    if(cpuid() == 0){
8010646b:	e8 c0 dc ff ff       	call   80104130 <cpuid>
80106470:	85 c0                	test   %eax,%eax
80106472:	0f 84 f8 00 00 00    	je     80106570 <trap+0x230>
    lapiceoi();
80106478:	e8 33 cc ff ff       	call   801030b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010647d:	e8 ce dc ff ff       	call   80104150 <myproc>
80106482:	85 c0                	test   %eax,%eax
80106484:	75 82                	jne    80106408 <trap+0xc8>
80106486:	eb 9d                	jmp    80106425 <trap+0xe5>
    kbdintr();
80106488:	e8 e3 ca ff ff       	call   80102f70 <kbdintr>
    lapiceoi();
8010648d:	e8 1e cc ff ff       	call   801030b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106492:	e8 b9 dc ff ff       	call   80104150 <myproc>
80106497:	85 c0                	test   %eax,%eax
80106499:	0f 85 69 ff ff ff    	jne    80106408 <trap+0xc8>
8010649f:	eb 84                	jmp    80106425 <trap+0xe5>
    uartintr();
801064a1:	e8 9a 02 00 00       	call   80106740 <uartintr>
    lapiceoi();
801064a6:	e8 05 cc ff ff       	call   801030b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064ab:	e8 a0 dc ff ff       	call   80104150 <myproc>
801064b0:	85 c0                	test   %eax,%eax
801064b2:	0f 85 50 ff ff ff    	jne    80106408 <trap+0xc8>
801064b8:	e9 68 ff ff ff       	jmp    80106425 <trap+0xe5>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064bd:	8b 7b 38             	mov    0x38(%ebx),%edi
801064c0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064c4:	e8 67 dc ff ff       	call   80104130 <cpuid>
801064c9:	57                   	push   %edi
801064ca:	56                   	push   %esi
801064cb:	50                   	push   %eax
801064cc:	68 f0 84 10 80       	push   $0x801084f0
801064d1:	e8 da a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801064d6:	e8 d5 cb ff ff       	call   801030b0 <lapiceoi>
    break;
801064db:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064de:	e8 6d dc ff ff       	call   80104150 <myproc>
801064e3:	85 c0                	test   %eax,%eax
801064e5:	0f 85 1d ff ff ff    	jne    80106408 <trap+0xc8>
801064eb:	e9 35 ff ff ff       	jmp    80106425 <trap+0xe5>
    ideintr();
801064f0:	e8 0b be ff ff       	call   80102300 <ideintr>
801064f5:	eb 81                	jmp    80106478 <trap+0x138>
801064f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fe:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80106500:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106504:	0f 85 33 ff ff ff    	jne    8010643d <trap+0xfd>
       yield();
8010650a:	e8 d1 e1 ff ff       	call   801046e0 <yield>
8010650f:	e9 29 ff ff ff       	jmp    8010643d <trap+0xfd>
80106514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106518:	e8 33 dc ff ff       	call   80104150 <myproc>
8010651d:	8b 70 24             	mov    0x24(%eax),%esi
80106520:	85 f6                	test   %esi,%esi
80106522:	75 3c                	jne    80106560 <trap+0x220>
    myproc()->tf = tf;
80106524:	e8 27 dc ff ff       	call   80104150 <myproc>
80106529:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010652c:	e8 1f ed ff ff       	call   80105250 <syscall>
    if(myproc()->killed)
80106531:	e8 1a dc ff ff       	call   80104150 <myproc>
80106536:	8b 48 24             	mov    0x24(%eax),%ecx
80106539:	85 c9                	test   %ecx,%ecx
8010653b:	0f 84 22 ff ff ff    	je     80106463 <trap+0x123>
}
80106541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106544:	5b                   	pop    %ebx
80106545:	5e                   	pop    %esi
80106546:	5f                   	pop    %edi
80106547:	5d                   	pop    %ebp
      exit();
80106548:	e9 53 e0 ff ff       	jmp    801045a0 <exit>
8010654d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106550:	e8 4b e0 ff ff       	call   801045a0 <exit>
80106555:	e9 cb fe ff ff       	jmp    80106425 <trap+0xe5>
8010655a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106560:	e8 3b e0 ff ff       	call   801045a0 <exit>
80106565:	eb bd                	jmp    80106524 <trap+0x1e4>
80106567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010656e:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
80106570:	83 ec 0c             	sub    $0xc,%esp
80106573:	68 40 bd 13 80       	push   $0x8013bd40
80106578:	e8 f3 e7 ff ff       	call   80104d70 <acquire>
      wakeup(&ticks);
8010657d:	c7 04 24 80 c5 13 80 	movl   $0x8013c580,(%esp)
      ticks++;
80106584:	83 05 80 c5 13 80 01 	addl   $0x1,0x8013c580
      wakeup(&ticks);
8010658b:	e8 60 e3 ff ff       	call   801048f0 <wakeup>
      release(&tickslock);
80106590:	c7 04 24 40 bd 13 80 	movl   $0x8013bd40,(%esp)
80106597:	e8 94 e8 ff ff       	call   80104e30 <release>
8010659c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010659f:	e9 d4 fe ff ff       	jmp    80106478 <trap+0x138>
801065a4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065a7:	e8 84 db ff ff       	call   80104130 <cpuid>
801065ac:	83 ec 0c             	sub    $0xc,%esp
801065af:	56                   	push   %esi
801065b0:	57                   	push   %edi
801065b1:	50                   	push   %eax
801065b2:	ff 73 30             	pushl  0x30(%ebx)
801065b5:	68 14 85 10 80       	push   $0x80108514
801065ba:	e8 f1 a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801065bf:	83 c4 14             	add    $0x14,%esp
801065c2:	68 ea 84 10 80       	push   $0x801084ea
801065c7:	e8 c4 9d ff ff       	call   80100390 <panic>
801065cc:	66 90                	xchg   %ax,%ax
801065ce:	66 90                	xchg   %ax,%ax

801065d0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801065d0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801065d4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801065d9:	85 c0                	test   %eax,%eax
801065db:	74 1b                	je     801065f8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065dd:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065e2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801065e3:	a8 01                	test   $0x1,%al
801065e5:	74 11                	je     801065f8 <uartgetc+0x28>
801065e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ec:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801065ed:	0f b6 c0             	movzbl %al,%eax
801065f0:	c3                   	ret    
801065f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801065f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065fd:	c3                   	ret    
801065fe:	66 90                	xchg   %ax,%ax

80106600 <uartputc.part.0>:
uartputc(int c)
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	89 c7                	mov    %eax,%edi
80106606:	56                   	push   %esi
80106607:	be fd 03 00 00       	mov    $0x3fd,%esi
8010660c:	53                   	push   %ebx
8010660d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106612:	83 ec 0c             	sub    $0xc,%esp
80106615:	eb 1b                	jmp    80106632 <uartputc.part.0+0x32>
80106617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	6a 0a                	push   $0xa
80106625:	e8 a6 ca ff ff       	call   801030d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010662a:	83 c4 10             	add    $0x10,%esp
8010662d:	83 eb 01             	sub    $0x1,%ebx
80106630:	74 07                	je     80106639 <uartputc.part.0+0x39>
80106632:	89 f2                	mov    %esi,%edx
80106634:	ec                   	in     (%dx),%al
80106635:	a8 20                	test   $0x20,%al
80106637:	74 e7                	je     80106620 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106639:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010663e:	89 f8                	mov    %edi,%eax
80106640:	ee                   	out    %al,(%dx)
}
80106641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106644:	5b                   	pop    %ebx
80106645:	5e                   	pop    %esi
80106646:	5f                   	pop    %edi
80106647:	5d                   	pop    %ebp
80106648:	c3                   	ret    
80106649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106650 <uartinit>:
{
80106650:	f3 0f 1e fb          	endbr32 
80106654:	55                   	push   %ebp
80106655:	31 c9                	xor    %ecx,%ecx
80106657:	89 c8                	mov    %ecx,%eax
80106659:	89 e5                	mov    %esp,%ebp
8010665b:	57                   	push   %edi
8010665c:	56                   	push   %esi
8010665d:	53                   	push   %ebx
8010665e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106663:	89 da                	mov    %ebx,%edx
80106665:	83 ec 0c             	sub    $0xc,%esp
80106668:	ee                   	out    %al,(%dx)
80106669:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010666e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106673:	89 fa                	mov    %edi,%edx
80106675:	ee                   	out    %al,(%dx)
80106676:	b8 0c 00 00 00       	mov    $0xc,%eax
8010667b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106680:	ee                   	out    %al,(%dx)
80106681:	be f9 03 00 00       	mov    $0x3f9,%esi
80106686:	89 c8                	mov    %ecx,%eax
80106688:	89 f2                	mov    %esi,%edx
8010668a:	ee                   	out    %al,(%dx)
8010668b:	b8 03 00 00 00       	mov    $0x3,%eax
80106690:	89 fa                	mov    %edi,%edx
80106692:	ee                   	out    %al,(%dx)
80106693:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106698:	89 c8                	mov    %ecx,%eax
8010669a:	ee                   	out    %al,(%dx)
8010669b:	b8 01 00 00 00       	mov    $0x1,%eax
801066a0:	89 f2                	mov    %esi,%edx
801066a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066a3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066a8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801066a9:	3c ff                	cmp    $0xff,%al
801066ab:	74 52                	je     801066ff <uartinit+0xaf>
  uart = 1;
801066ad:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801066b4:	00 00 00 
801066b7:	89 da                	mov    %ebx,%edx
801066b9:	ec                   	in     (%dx),%al
801066ba:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066bf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801066c0:	83 ec 08             	sub    $0x8,%esp
801066c3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801066c8:	bb 0c 86 10 80       	mov    $0x8010860c,%ebx
  ioapicenable(IRQ_COM1, 0);
801066cd:	6a 00                	push   $0x0
801066cf:	6a 04                	push   $0x4
801066d1:	e8 7a be ff ff       	call   80102550 <ioapicenable>
801066d6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801066d9:	b8 78 00 00 00       	mov    $0x78,%eax
801066de:	eb 04                	jmp    801066e4 <uartinit+0x94>
801066e0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801066e4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801066ea:	85 d2                	test   %edx,%edx
801066ec:	74 08                	je     801066f6 <uartinit+0xa6>
    uartputc(*p);
801066ee:	0f be c0             	movsbl %al,%eax
801066f1:	e8 0a ff ff ff       	call   80106600 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801066f6:	89 f0                	mov    %esi,%eax
801066f8:	83 c3 01             	add    $0x1,%ebx
801066fb:	84 c0                	test   %al,%al
801066fd:	75 e1                	jne    801066e0 <uartinit+0x90>
}
801066ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106702:	5b                   	pop    %ebx
80106703:	5e                   	pop    %esi
80106704:	5f                   	pop    %edi
80106705:	5d                   	pop    %ebp
80106706:	c3                   	ret    
80106707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010670e:	66 90                	xchg   %ax,%ax

80106710 <uartputc>:
{
80106710:	f3 0f 1e fb          	endbr32 
80106714:	55                   	push   %ebp
  if(!uart)
80106715:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010671b:	89 e5                	mov    %esp,%ebp
8010671d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106720:	85 d2                	test   %edx,%edx
80106722:	74 0c                	je     80106730 <uartputc+0x20>
}
80106724:	5d                   	pop    %ebp
80106725:	e9 d6 fe ff ff       	jmp    80106600 <uartputc.part.0>
8010672a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106730:	5d                   	pop    %ebp
80106731:	c3                   	ret    
80106732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106740 <uartintr>:

void
uartintr(void)
{
80106740:	f3 0f 1e fb          	endbr32 
80106744:	55                   	push   %ebp
80106745:	89 e5                	mov    %esp,%ebp
80106747:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010674a:	68 d0 65 10 80       	push   $0x801065d0
8010674f:	e8 0c a1 ff ff       	call   80100860 <consoleintr>
}
80106754:	83 c4 10             	add    $0x10,%esp
80106757:	c9                   	leave  
80106758:	c3                   	ret    

80106759 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $0
8010675b:	6a 00                	push   $0x0
  jmp alltraps
8010675d:	e9 3c fa ff ff       	jmp    8010619e <alltraps>

80106762 <vector1>:
.globl vector1
vector1:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $1
80106764:	6a 01                	push   $0x1
  jmp alltraps
80106766:	e9 33 fa ff ff       	jmp    8010619e <alltraps>

8010676b <vector2>:
.globl vector2
vector2:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $2
8010676d:	6a 02                	push   $0x2
  jmp alltraps
8010676f:	e9 2a fa ff ff       	jmp    8010619e <alltraps>

80106774 <vector3>:
.globl vector3
vector3:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $3
80106776:	6a 03                	push   $0x3
  jmp alltraps
80106778:	e9 21 fa ff ff       	jmp    8010619e <alltraps>

8010677d <vector4>:
.globl vector4
vector4:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $4
8010677f:	6a 04                	push   $0x4
  jmp alltraps
80106781:	e9 18 fa ff ff       	jmp    8010619e <alltraps>

80106786 <vector5>:
.globl vector5
vector5:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $5
80106788:	6a 05                	push   $0x5
  jmp alltraps
8010678a:	e9 0f fa ff ff       	jmp    8010619e <alltraps>

8010678f <vector6>:
.globl vector6
vector6:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $6
80106791:	6a 06                	push   $0x6
  jmp alltraps
80106793:	e9 06 fa ff ff       	jmp    8010619e <alltraps>

80106798 <vector7>:
.globl vector7
vector7:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $7
8010679a:	6a 07                	push   $0x7
  jmp alltraps
8010679c:	e9 fd f9 ff ff       	jmp    8010619e <alltraps>

801067a1 <vector8>:
.globl vector8
vector8:
  pushl $8
801067a1:	6a 08                	push   $0x8
  jmp alltraps
801067a3:	e9 f6 f9 ff ff       	jmp    8010619e <alltraps>

801067a8 <vector9>:
.globl vector9
vector9:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $9
801067aa:	6a 09                	push   $0x9
  jmp alltraps
801067ac:	e9 ed f9 ff ff       	jmp    8010619e <alltraps>

801067b1 <vector10>:
.globl vector10
vector10:
  pushl $10
801067b1:	6a 0a                	push   $0xa
  jmp alltraps
801067b3:	e9 e6 f9 ff ff       	jmp    8010619e <alltraps>

801067b8 <vector11>:
.globl vector11
vector11:
  pushl $11
801067b8:	6a 0b                	push   $0xb
  jmp alltraps
801067ba:	e9 df f9 ff ff       	jmp    8010619e <alltraps>

801067bf <vector12>:
.globl vector12
vector12:
  pushl $12
801067bf:	6a 0c                	push   $0xc
  jmp alltraps
801067c1:	e9 d8 f9 ff ff       	jmp    8010619e <alltraps>

801067c6 <vector13>:
.globl vector13
vector13:
  pushl $13
801067c6:	6a 0d                	push   $0xd
  jmp alltraps
801067c8:	e9 d1 f9 ff ff       	jmp    8010619e <alltraps>

801067cd <vector14>:
.globl vector14
vector14:
  pushl $14
801067cd:	6a 0e                	push   $0xe
  jmp alltraps
801067cf:	e9 ca f9 ff ff       	jmp    8010619e <alltraps>

801067d4 <vector15>:
.globl vector15
vector15:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $15
801067d6:	6a 0f                	push   $0xf
  jmp alltraps
801067d8:	e9 c1 f9 ff ff       	jmp    8010619e <alltraps>

801067dd <vector16>:
.globl vector16
vector16:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $16
801067df:	6a 10                	push   $0x10
  jmp alltraps
801067e1:	e9 b8 f9 ff ff       	jmp    8010619e <alltraps>

801067e6 <vector17>:
.globl vector17
vector17:
  pushl $17
801067e6:	6a 11                	push   $0x11
  jmp alltraps
801067e8:	e9 b1 f9 ff ff       	jmp    8010619e <alltraps>

801067ed <vector18>:
.globl vector18
vector18:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $18
801067ef:	6a 12                	push   $0x12
  jmp alltraps
801067f1:	e9 a8 f9 ff ff       	jmp    8010619e <alltraps>

801067f6 <vector19>:
.globl vector19
vector19:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $19
801067f8:	6a 13                	push   $0x13
  jmp alltraps
801067fa:	e9 9f f9 ff ff       	jmp    8010619e <alltraps>

801067ff <vector20>:
.globl vector20
vector20:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $20
80106801:	6a 14                	push   $0x14
  jmp alltraps
80106803:	e9 96 f9 ff ff       	jmp    8010619e <alltraps>

80106808 <vector21>:
.globl vector21
vector21:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $21
8010680a:	6a 15                	push   $0x15
  jmp alltraps
8010680c:	e9 8d f9 ff ff       	jmp    8010619e <alltraps>

80106811 <vector22>:
.globl vector22
vector22:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $22
80106813:	6a 16                	push   $0x16
  jmp alltraps
80106815:	e9 84 f9 ff ff       	jmp    8010619e <alltraps>

8010681a <vector23>:
.globl vector23
vector23:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $23
8010681c:	6a 17                	push   $0x17
  jmp alltraps
8010681e:	e9 7b f9 ff ff       	jmp    8010619e <alltraps>

80106823 <vector24>:
.globl vector24
vector24:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $24
80106825:	6a 18                	push   $0x18
  jmp alltraps
80106827:	e9 72 f9 ff ff       	jmp    8010619e <alltraps>

8010682c <vector25>:
.globl vector25
vector25:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $25
8010682e:	6a 19                	push   $0x19
  jmp alltraps
80106830:	e9 69 f9 ff ff       	jmp    8010619e <alltraps>

80106835 <vector26>:
.globl vector26
vector26:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $26
80106837:	6a 1a                	push   $0x1a
  jmp alltraps
80106839:	e9 60 f9 ff ff       	jmp    8010619e <alltraps>

8010683e <vector27>:
.globl vector27
vector27:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $27
80106840:	6a 1b                	push   $0x1b
  jmp alltraps
80106842:	e9 57 f9 ff ff       	jmp    8010619e <alltraps>

80106847 <vector28>:
.globl vector28
vector28:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $28
80106849:	6a 1c                	push   $0x1c
  jmp alltraps
8010684b:	e9 4e f9 ff ff       	jmp    8010619e <alltraps>

80106850 <vector29>:
.globl vector29
vector29:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $29
80106852:	6a 1d                	push   $0x1d
  jmp alltraps
80106854:	e9 45 f9 ff ff       	jmp    8010619e <alltraps>

80106859 <vector30>:
.globl vector30
vector30:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $30
8010685b:	6a 1e                	push   $0x1e
  jmp alltraps
8010685d:	e9 3c f9 ff ff       	jmp    8010619e <alltraps>

80106862 <vector31>:
.globl vector31
vector31:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $31
80106864:	6a 1f                	push   $0x1f
  jmp alltraps
80106866:	e9 33 f9 ff ff       	jmp    8010619e <alltraps>

8010686b <vector32>:
.globl vector32
vector32:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $32
8010686d:	6a 20                	push   $0x20
  jmp alltraps
8010686f:	e9 2a f9 ff ff       	jmp    8010619e <alltraps>

80106874 <vector33>:
.globl vector33
vector33:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $33
80106876:	6a 21                	push   $0x21
  jmp alltraps
80106878:	e9 21 f9 ff ff       	jmp    8010619e <alltraps>

8010687d <vector34>:
.globl vector34
vector34:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $34
8010687f:	6a 22                	push   $0x22
  jmp alltraps
80106881:	e9 18 f9 ff ff       	jmp    8010619e <alltraps>

80106886 <vector35>:
.globl vector35
vector35:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $35
80106888:	6a 23                	push   $0x23
  jmp alltraps
8010688a:	e9 0f f9 ff ff       	jmp    8010619e <alltraps>

8010688f <vector36>:
.globl vector36
vector36:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $36
80106891:	6a 24                	push   $0x24
  jmp alltraps
80106893:	e9 06 f9 ff ff       	jmp    8010619e <alltraps>

80106898 <vector37>:
.globl vector37
vector37:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $37
8010689a:	6a 25                	push   $0x25
  jmp alltraps
8010689c:	e9 fd f8 ff ff       	jmp    8010619e <alltraps>

801068a1 <vector38>:
.globl vector38
vector38:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $38
801068a3:	6a 26                	push   $0x26
  jmp alltraps
801068a5:	e9 f4 f8 ff ff       	jmp    8010619e <alltraps>

801068aa <vector39>:
.globl vector39
vector39:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $39
801068ac:	6a 27                	push   $0x27
  jmp alltraps
801068ae:	e9 eb f8 ff ff       	jmp    8010619e <alltraps>

801068b3 <vector40>:
.globl vector40
vector40:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $40
801068b5:	6a 28                	push   $0x28
  jmp alltraps
801068b7:	e9 e2 f8 ff ff       	jmp    8010619e <alltraps>

801068bc <vector41>:
.globl vector41
vector41:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $41
801068be:	6a 29                	push   $0x29
  jmp alltraps
801068c0:	e9 d9 f8 ff ff       	jmp    8010619e <alltraps>

801068c5 <vector42>:
.globl vector42
vector42:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $42
801068c7:	6a 2a                	push   $0x2a
  jmp alltraps
801068c9:	e9 d0 f8 ff ff       	jmp    8010619e <alltraps>

801068ce <vector43>:
.globl vector43
vector43:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $43
801068d0:	6a 2b                	push   $0x2b
  jmp alltraps
801068d2:	e9 c7 f8 ff ff       	jmp    8010619e <alltraps>

801068d7 <vector44>:
.globl vector44
vector44:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $44
801068d9:	6a 2c                	push   $0x2c
  jmp alltraps
801068db:	e9 be f8 ff ff       	jmp    8010619e <alltraps>

801068e0 <vector45>:
.globl vector45
vector45:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $45
801068e2:	6a 2d                	push   $0x2d
  jmp alltraps
801068e4:	e9 b5 f8 ff ff       	jmp    8010619e <alltraps>

801068e9 <vector46>:
.globl vector46
vector46:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $46
801068eb:	6a 2e                	push   $0x2e
  jmp alltraps
801068ed:	e9 ac f8 ff ff       	jmp    8010619e <alltraps>

801068f2 <vector47>:
.globl vector47
vector47:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $47
801068f4:	6a 2f                	push   $0x2f
  jmp alltraps
801068f6:	e9 a3 f8 ff ff       	jmp    8010619e <alltraps>

801068fb <vector48>:
.globl vector48
vector48:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $48
801068fd:	6a 30                	push   $0x30
  jmp alltraps
801068ff:	e9 9a f8 ff ff       	jmp    8010619e <alltraps>

80106904 <vector49>:
.globl vector49
vector49:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $49
80106906:	6a 31                	push   $0x31
  jmp alltraps
80106908:	e9 91 f8 ff ff       	jmp    8010619e <alltraps>

8010690d <vector50>:
.globl vector50
vector50:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $50
8010690f:	6a 32                	push   $0x32
  jmp alltraps
80106911:	e9 88 f8 ff ff       	jmp    8010619e <alltraps>

80106916 <vector51>:
.globl vector51
vector51:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $51
80106918:	6a 33                	push   $0x33
  jmp alltraps
8010691a:	e9 7f f8 ff ff       	jmp    8010619e <alltraps>

8010691f <vector52>:
.globl vector52
vector52:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $52
80106921:	6a 34                	push   $0x34
  jmp alltraps
80106923:	e9 76 f8 ff ff       	jmp    8010619e <alltraps>

80106928 <vector53>:
.globl vector53
vector53:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $53
8010692a:	6a 35                	push   $0x35
  jmp alltraps
8010692c:	e9 6d f8 ff ff       	jmp    8010619e <alltraps>

80106931 <vector54>:
.globl vector54
vector54:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $54
80106933:	6a 36                	push   $0x36
  jmp alltraps
80106935:	e9 64 f8 ff ff       	jmp    8010619e <alltraps>

8010693a <vector55>:
.globl vector55
vector55:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $55
8010693c:	6a 37                	push   $0x37
  jmp alltraps
8010693e:	e9 5b f8 ff ff       	jmp    8010619e <alltraps>

80106943 <vector56>:
.globl vector56
vector56:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $56
80106945:	6a 38                	push   $0x38
  jmp alltraps
80106947:	e9 52 f8 ff ff       	jmp    8010619e <alltraps>

8010694c <vector57>:
.globl vector57
vector57:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $57
8010694e:	6a 39                	push   $0x39
  jmp alltraps
80106950:	e9 49 f8 ff ff       	jmp    8010619e <alltraps>

80106955 <vector58>:
.globl vector58
vector58:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $58
80106957:	6a 3a                	push   $0x3a
  jmp alltraps
80106959:	e9 40 f8 ff ff       	jmp    8010619e <alltraps>

8010695e <vector59>:
.globl vector59
vector59:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $59
80106960:	6a 3b                	push   $0x3b
  jmp alltraps
80106962:	e9 37 f8 ff ff       	jmp    8010619e <alltraps>

80106967 <vector60>:
.globl vector60
vector60:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $60
80106969:	6a 3c                	push   $0x3c
  jmp alltraps
8010696b:	e9 2e f8 ff ff       	jmp    8010619e <alltraps>

80106970 <vector61>:
.globl vector61
vector61:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $61
80106972:	6a 3d                	push   $0x3d
  jmp alltraps
80106974:	e9 25 f8 ff ff       	jmp    8010619e <alltraps>

80106979 <vector62>:
.globl vector62
vector62:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $62
8010697b:	6a 3e                	push   $0x3e
  jmp alltraps
8010697d:	e9 1c f8 ff ff       	jmp    8010619e <alltraps>

80106982 <vector63>:
.globl vector63
vector63:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $63
80106984:	6a 3f                	push   $0x3f
  jmp alltraps
80106986:	e9 13 f8 ff ff       	jmp    8010619e <alltraps>

8010698b <vector64>:
.globl vector64
vector64:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $64
8010698d:	6a 40                	push   $0x40
  jmp alltraps
8010698f:	e9 0a f8 ff ff       	jmp    8010619e <alltraps>

80106994 <vector65>:
.globl vector65
vector65:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $65
80106996:	6a 41                	push   $0x41
  jmp alltraps
80106998:	e9 01 f8 ff ff       	jmp    8010619e <alltraps>

8010699d <vector66>:
.globl vector66
vector66:
  pushl $0
8010699d:	6a 00                	push   $0x0
  pushl $66
8010699f:	6a 42                	push   $0x42
  jmp alltraps
801069a1:	e9 f8 f7 ff ff       	jmp    8010619e <alltraps>

801069a6 <vector67>:
.globl vector67
vector67:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $67
801069a8:	6a 43                	push   $0x43
  jmp alltraps
801069aa:	e9 ef f7 ff ff       	jmp    8010619e <alltraps>

801069af <vector68>:
.globl vector68
vector68:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $68
801069b1:	6a 44                	push   $0x44
  jmp alltraps
801069b3:	e9 e6 f7 ff ff       	jmp    8010619e <alltraps>

801069b8 <vector69>:
.globl vector69
vector69:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $69
801069ba:	6a 45                	push   $0x45
  jmp alltraps
801069bc:	e9 dd f7 ff ff       	jmp    8010619e <alltraps>

801069c1 <vector70>:
.globl vector70
vector70:
  pushl $0
801069c1:	6a 00                	push   $0x0
  pushl $70
801069c3:	6a 46                	push   $0x46
  jmp alltraps
801069c5:	e9 d4 f7 ff ff       	jmp    8010619e <alltraps>

801069ca <vector71>:
.globl vector71
vector71:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $71
801069cc:	6a 47                	push   $0x47
  jmp alltraps
801069ce:	e9 cb f7 ff ff       	jmp    8010619e <alltraps>

801069d3 <vector72>:
.globl vector72
vector72:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $72
801069d5:	6a 48                	push   $0x48
  jmp alltraps
801069d7:	e9 c2 f7 ff ff       	jmp    8010619e <alltraps>

801069dc <vector73>:
.globl vector73
vector73:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $73
801069de:	6a 49                	push   $0x49
  jmp alltraps
801069e0:	e9 b9 f7 ff ff       	jmp    8010619e <alltraps>

801069e5 <vector74>:
.globl vector74
vector74:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $74
801069e7:	6a 4a                	push   $0x4a
  jmp alltraps
801069e9:	e9 b0 f7 ff ff       	jmp    8010619e <alltraps>

801069ee <vector75>:
.globl vector75
vector75:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $75
801069f0:	6a 4b                	push   $0x4b
  jmp alltraps
801069f2:	e9 a7 f7 ff ff       	jmp    8010619e <alltraps>

801069f7 <vector76>:
.globl vector76
vector76:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $76
801069f9:	6a 4c                	push   $0x4c
  jmp alltraps
801069fb:	e9 9e f7 ff ff       	jmp    8010619e <alltraps>

80106a00 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $77
80106a02:	6a 4d                	push   $0x4d
  jmp alltraps
80106a04:	e9 95 f7 ff ff       	jmp    8010619e <alltraps>

80106a09 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $78
80106a0b:	6a 4e                	push   $0x4e
  jmp alltraps
80106a0d:	e9 8c f7 ff ff       	jmp    8010619e <alltraps>

80106a12 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $79
80106a14:	6a 4f                	push   $0x4f
  jmp alltraps
80106a16:	e9 83 f7 ff ff       	jmp    8010619e <alltraps>

80106a1b <vector80>:
.globl vector80
vector80:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $80
80106a1d:	6a 50                	push   $0x50
  jmp alltraps
80106a1f:	e9 7a f7 ff ff       	jmp    8010619e <alltraps>

80106a24 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $81
80106a26:	6a 51                	push   $0x51
  jmp alltraps
80106a28:	e9 71 f7 ff ff       	jmp    8010619e <alltraps>

80106a2d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a2d:	6a 00                	push   $0x0
  pushl $82
80106a2f:	6a 52                	push   $0x52
  jmp alltraps
80106a31:	e9 68 f7 ff ff       	jmp    8010619e <alltraps>

80106a36 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a36:	6a 00                	push   $0x0
  pushl $83
80106a38:	6a 53                	push   $0x53
  jmp alltraps
80106a3a:	e9 5f f7 ff ff       	jmp    8010619e <alltraps>

80106a3f <vector84>:
.globl vector84
vector84:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $84
80106a41:	6a 54                	push   $0x54
  jmp alltraps
80106a43:	e9 56 f7 ff ff       	jmp    8010619e <alltraps>

80106a48 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a48:	6a 00                	push   $0x0
  pushl $85
80106a4a:	6a 55                	push   $0x55
  jmp alltraps
80106a4c:	e9 4d f7 ff ff       	jmp    8010619e <alltraps>

80106a51 <vector86>:
.globl vector86
vector86:
  pushl $0
80106a51:	6a 00                	push   $0x0
  pushl $86
80106a53:	6a 56                	push   $0x56
  jmp alltraps
80106a55:	e9 44 f7 ff ff       	jmp    8010619e <alltraps>

80106a5a <vector87>:
.globl vector87
vector87:
  pushl $0
80106a5a:	6a 00                	push   $0x0
  pushl $87
80106a5c:	6a 57                	push   $0x57
  jmp alltraps
80106a5e:	e9 3b f7 ff ff       	jmp    8010619e <alltraps>

80106a63 <vector88>:
.globl vector88
vector88:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $88
80106a65:	6a 58                	push   $0x58
  jmp alltraps
80106a67:	e9 32 f7 ff ff       	jmp    8010619e <alltraps>

80106a6c <vector89>:
.globl vector89
vector89:
  pushl $0
80106a6c:	6a 00                	push   $0x0
  pushl $89
80106a6e:	6a 59                	push   $0x59
  jmp alltraps
80106a70:	e9 29 f7 ff ff       	jmp    8010619e <alltraps>

80106a75 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a75:	6a 00                	push   $0x0
  pushl $90
80106a77:	6a 5a                	push   $0x5a
  jmp alltraps
80106a79:	e9 20 f7 ff ff       	jmp    8010619e <alltraps>

80106a7e <vector91>:
.globl vector91
vector91:
  pushl $0
80106a7e:	6a 00                	push   $0x0
  pushl $91
80106a80:	6a 5b                	push   $0x5b
  jmp alltraps
80106a82:	e9 17 f7 ff ff       	jmp    8010619e <alltraps>

80106a87 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $92
80106a89:	6a 5c                	push   $0x5c
  jmp alltraps
80106a8b:	e9 0e f7 ff ff       	jmp    8010619e <alltraps>

80106a90 <vector93>:
.globl vector93
vector93:
  pushl $0
80106a90:	6a 00                	push   $0x0
  pushl $93
80106a92:	6a 5d                	push   $0x5d
  jmp alltraps
80106a94:	e9 05 f7 ff ff       	jmp    8010619e <alltraps>

80106a99 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a99:	6a 00                	push   $0x0
  pushl $94
80106a9b:	6a 5e                	push   $0x5e
  jmp alltraps
80106a9d:	e9 fc f6 ff ff       	jmp    8010619e <alltraps>

80106aa2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106aa2:	6a 00                	push   $0x0
  pushl $95
80106aa4:	6a 5f                	push   $0x5f
  jmp alltraps
80106aa6:	e9 f3 f6 ff ff       	jmp    8010619e <alltraps>

80106aab <vector96>:
.globl vector96
vector96:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $96
80106aad:	6a 60                	push   $0x60
  jmp alltraps
80106aaf:	e9 ea f6 ff ff       	jmp    8010619e <alltraps>

80106ab4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $97
80106ab6:	6a 61                	push   $0x61
  jmp alltraps
80106ab8:	e9 e1 f6 ff ff       	jmp    8010619e <alltraps>

80106abd <vector98>:
.globl vector98
vector98:
  pushl $0
80106abd:	6a 00                	push   $0x0
  pushl $98
80106abf:	6a 62                	push   $0x62
  jmp alltraps
80106ac1:	e9 d8 f6 ff ff       	jmp    8010619e <alltraps>

80106ac6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ac6:	6a 00                	push   $0x0
  pushl $99
80106ac8:	6a 63                	push   $0x63
  jmp alltraps
80106aca:	e9 cf f6 ff ff       	jmp    8010619e <alltraps>

80106acf <vector100>:
.globl vector100
vector100:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $100
80106ad1:	6a 64                	push   $0x64
  jmp alltraps
80106ad3:	e9 c6 f6 ff ff       	jmp    8010619e <alltraps>

80106ad8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ad8:	6a 00                	push   $0x0
  pushl $101
80106ada:	6a 65                	push   $0x65
  jmp alltraps
80106adc:	e9 bd f6 ff ff       	jmp    8010619e <alltraps>

80106ae1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106ae1:	6a 00                	push   $0x0
  pushl $102
80106ae3:	6a 66                	push   $0x66
  jmp alltraps
80106ae5:	e9 b4 f6 ff ff       	jmp    8010619e <alltraps>

80106aea <vector103>:
.globl vector103
vector103:
  pushl $0
80106aea:	6a 00                	push   $0x0
  pushl $103
80106aec:	6a 67                	push   $0x67
  jmp alltraps
80106aee:	e9 ab f6 ff ff       	jmp    8010619e <alltraps>

80106af3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $104
80106af5:	6a 68                	push   $0x68
  jmp alltraps
80106af7:	e9 a2 f6 ff ff       	jmp    8010619e <alltraps>

80106afc <vector105>:
.globl vector105
vector105:
  pushl $0
80106afc:	6a 00                	push   $0x0
  pushl $105
80106afe:	6a 69                	push   $0x69
  jmp alltraps
80106b00:	e9 99 f6 ff ff       	jmp    8010619e <alltraps>

80106b05 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b05:	6a 00                	push   $0x0
  pushl $106
80106b07:	6a 6a                	push   $0x6a
  jmp alltraps
80106b09:	e9 90 f6 ff ff       	jmp    8010619e <alltraps>

80106b0e <vector107>:
.globl vector107
vector107:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $107
80106b10:	6a 6b                	push   $0x6b
  jmp alltraps
80106b12:	e9 87 f6 ff ff       	jmp    8010619e <alltraps>

80106b17 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $108
80106b19:	6a 6c                	push   $0x6c
  jmp alltraps
80106b1b:	e9 7e f6 ff ff       	jmp    8010619e <alltraps>

80106b20 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b20:	6a 00                	push   $0x0
  pushl $109
80106b22:	6a 6d                	push   $0x6d
  jmp alltraps
80106b24:	e9 75 f6 ff ff       	jmp    8010619e <alltraps>

80106b29 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b29:	6a 00                	push   $0x0
  pushl $110
80106b2b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b2d:	e9 6c f6 ff ff       	jmp    8010619e <alltraps>

80106b32 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b32:	6a 00                	push   $0x0
  pushl $111
80106b34:	6a 6f                	push   $0x6f
  jmp alltraps
80106b36:	e9 63 f6 ff ff       	jmp    8010619e <alltraps>

80106b3b <vector112>:
.globl vector112
vector112:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $112
80106b3d:	6a 70                	push   $0x70
  jmp alltraps
80106b3f:	e9 5a f6 ff ff       	jmp    8010619e <alltraps>

80106b44 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b44:	6a 00                	push   $0x0
  pushl $113
80106b46:	6a 71                	push   $0x71
  jmp alltraps
80106b48:	e9 51 f6 ff ff       	jmp    8010619e <alltraps>

80106b4d <vector114>:
.globl vector114
vector114:
  pushl $0
80106b4d:	6a 00                	push   $0x0
  pushl $114
80106b4f:	6a 72                	push   $0x72
  jmp alltraps
80106b51:	e9 48 f6 ff ff       	jmp    8010619e <alltraps>

80106b56 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b56:	6a 00                	push   $0x0
  pushl $115
80106b58:	6a 73                	push   $0x73
  jmp alltraps
80106b5a:	e9 3f f6 ff ff       	jmp    8010619e <alltraps>

80106b5f <vector116>:
.globl vector116
vector116:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $116
80106b61:	6a 74                	push   $0x74
  jmp alltraps
80106b63:	e9 36 f6 ff ff       	jmp    8010619e <alltraps>

80106b68 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b68:	6a 00                	push   $0x0
  pushl $117
80106b6a:	6a 75                	push   $0x75
  jmp alltraps
80106b6c:	e9 2d f6 ff ff       	jmp    8010619e <alltraps>

80106b71 <vector118>:
.globl vector118
vector118:
  pushl $0
80106b71:	6a 00                	push   $0x0
  pushl $118
80106b73:	6a 76                	push   $0x76
  jmp alltraps
80106b75:	e9 24 f6 ff ff       	jmp    8010619e <alltraps>

80106b7a <vector119>:
.globl vector119
vector119:
  pushl $0
80106b7a:	6a 00                	push   $0x0
  pushl $119
80106b7c:	6a 77                	push   $0x77
  jmp alltraps
80106b7e:	e9 1b f6 ff ff       	jmp    8010619e <alltraps>

80106b83 <vector120>:
.globl vector120
vector120:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $120
80106b85:	6a 78                	push   $0x78
  jmp alltraps
80106b87:	e9 12 f6 ff ff       	jmp    8010619e <alltraps>

80106b8c <vector121>:
.globl vector121
vector121:
  pushl $0
80106b8c:	6a 00                	push   $0x0
  pushl $121
80106b8e:	6a 79                	push   $0x79
  jmp alltraps
80106b90:	e9 09 f6 ff ff       	jmp    8010619e <alltraps>

80106b95 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b95:	6a 00                	push   $0x0
  pushl $122
80106b97:	6a 7a                	push   $0x7a
  jmp alltraps
80106b99:	e9 00 f6 ff ff       	jmp    8010619e <alltraps>

80106b9e <vector123>:
.globl vector123
vector123:
  pushl $0
80106b9e:	6a 00                	push   $0x0
  pushl $123
80106ba0:	6a 7b                	push   $0x7b
  jmp alltraps
80106ba2:	e9 f7 f5 ff ff       	jmp    8010619e <alltraps>

80106ba7 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $124
80106ba9:	6a 7c                	push   $0x7c
  jmp alltraps
80106bab:	e9 ee f5 ff ff       	jmp    8010619e <alltraps>

80106bb0 <vector125>:
.globl vector125
vector125:
  pushl $0
80106bb0:	6a 00                	push   $0x0
  pushl $125
80106bb2:	6a 7d                	push   $0x7d
  jmp alltraps
80106bb4:	e9 e5 f5 ff ff       	jmp    8010619e <alltraps>

80106bb9 <vector126>:
.globl vector126
vector126:
  pushl $0
80106bb9:	6a 00                	push   $0x0
  pushl $126
80106bbb:	6a 7e                	push   $0x7e
  jmp alltraps
80106bbd:	e9 dc f5 ff ff       	jmp    8010619e <alltraps>

80106bc2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106bc2:	6a 00                	push   $0x0
  pushl $127
80106bc4:	6a 7f                	push   $0x7f
  jmp alltraps
80106bc6:	e9 d3 f5 ff ff       	jmp    8010619e <alltraps>

80106bcb <vector128>:
.globl vector128
vector128:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $128
80106bcd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106bd2:	e9 c7 f5 ff ff       	jmp    8010619e <alltraps>

80106bd7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $129
80106bd9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106bde:	e9 bb f5 ff ff       	jmp    8010619e <alltraps>

80106be3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $130
80106be5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106bea:	e9 af f5 ff ff       	jmp    8010619e <alltraps>

80106bef <vector131>:
.globl vector131
vector131:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $131
80106bf1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106bf6:	e9 a3 f5 ff ff       	jmp    8010619e <alltraps>

80106bfb <vector132>:
.globl vector132
vector132:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $132
80106bfd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c02:	e9 97 f5 ff ff       	jmp    8010619e <alltraps>

80106c07 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $133
80106c09:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c0e:	e9 8b f5 ff ff       	jmp    8010619e <alltraps>

80106c13 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $134
80106c15:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c1a:	e9 7f f5 ff ff       	jmp    8010619e <alltraps>

80106c1f <vector135>:
.globl vector135
vector135:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $135
80106c21:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c26:	e9 73 f5 ff ff       	jmp    8010619e <alltraps>

80106c2b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $136
80106c2d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c32:	e9 67 f5 ff ff       	jmp    8010619e <alltraps>

80106c37 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $137
80106c39:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c3e:	e9 5b f5 ff ff       	jmp    8010619e <alltraps>

80106c43 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $138
80106c45:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c4a:	e9 4f f5 ff ff       	jmp    8010619e <alltraps>

80106c4f <vector139>:
.globl vector139
vector139:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $139
80106c51:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c56:	e9 43 f5 ff ff       	jmp    8010619e <alltraps>

80106c5b <vector140>:
.globl vector140
vector140:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $140
80106c5d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c62:	e9 37 f5 ff ff       	jmp    8010619e <alltraps>

80106c67 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $141
80106c69:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c6e:	e9 2b f5 ff ff       	jmp    8010619e <alltraps>

80106c73 <vector142>:
.globl vector142
vector142:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $142
80106c75:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c7a:	e9 1f f5 ff ff       	jmp    8010619e <alltraps>

80106c7f <vector143>:
.globl vector143
vector143:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $143
80106c81:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c86:	e9 13 f5 ff ff       	jmp    8010619e <alltraps>

80106c8b <vector144>:
.globl vector144
vector144:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $144
80106c8d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c92:	e9 07 f5 ff ff       	jmp    8010619e <alltraps>

80106c97 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $145
80106c99:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c9e:	e9 fb f4 ff ff       	jmp    8010619e <alltraps>

80106ca3 <vector146>:
.globl vector146
vector146:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $146
80106ca5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106caa:	e9 ef f4 ff ff       	jmp    8010619e <alltraps>

80106caf <vector147>:
.globl vector147
vector147:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $147
80106cb1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106cb6:	e9 e3 f4 ff ff       	jmp    8010619e <alltraps>

80106cbb <vector148>:
.globl vector148
vector148:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $148
80106cbd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106cc2:	e9 d7 f4 ff ff       	jmp    8010619e <alltraps>

80106cc7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $149
80106cc9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106cce:	e9 cb f4 ff ff       	jmp    8010619e <alltraps>

80106cd3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $150
80106cd5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106cda:	e9 bf f4 ff ff       	jmp    8010619e <alltraps>

80106cdf <vector151>:
.globl vector151
vector151:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $151
80106ce1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ce6:	e9 b3 f4 ff ff       	jmp    8010619e <alltraps>

80106ceb <vector152>:
.globl vector152
vector152:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $152
80106ced:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106cf2:	e9 a7 f4 ff ff       	jmp    8010619e <alltraps>

80106cf7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $153
80106cf9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106cfe:	e9 9b f4 ff ff       	jmp    8010619e <alltraps>

80106d03 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $154
80106d05:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d0a:	e9 8f f4 ff ff       	jmp    8010619e <alltraps>

80106d0f <vector155>:
.globl vector155
vector155:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $155
80106d11:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d16:	e9 83 f4 ff ff       	jmp    8010619e <alltraps>

80106d1b <vector156>:
.globl vector156
vector156:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $156
80106d1d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d22:	e9 77 f4 ff ff       	jmp    8010619e <alltraps>

80106d27 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $157
80106d29:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d2e:	e9 6b f4 ff ff       	jmp    8010619e <alltraps>

80106d33 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $158
80106d35:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d3a:	e9 5f f4 ff ff       	jmp    8010619e <alltraps>

80106d3f <vector159>:
.globl vector159
vector159:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $159
80106d41:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d46:	e9 53 f4 ff ff       	jmp    8010619e <alltraps>

80106d4b <vector160>:
.globl vector160
vector160:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $160
80106d4d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d52:	e9 47 f4 ff ff       	jmp    8010619e <alltraps>

80106d57 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $161
80106d59:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d5e:	e9 3b f4 ff ff       	jmp    8010619e <alltraps>

80106d63 <vector162>:
.globl vector162
vector162:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $162
80106d65:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d6a:	e9 2f f4 ff ff       	jmp    8010619e <alltraps>

80106d6f <vector163>:
.globl vector163
vector163:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $163
80106d71:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d76:	e9 23 f4 ff ff       	jmp    8010619e <alltraps>

80106d7b <vector164>:
.globl vector164
vector164:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $164
80106d7d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d82:	e9 17 f4 ff ff       	jmp    8010619e <alltraps>

80106d87 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $165
80106d89:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d8e:	e9 0b f4 ff ff       	jmp    8010619e <alltraps>

80106d93 <vector166>:
.globl vector166
vector166:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $166
80106d95:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d9a:	e9 ff f3 ff ff       	jmp    8010619e <alltraps>

80106d9f <vector167>:
.globl vector167
vector167:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $167
80106da1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106da6:	e9 f3 f3 ff ff       	jmp    8010619e <alltraps>

80106dab <vector168>:
.globl vector168
vector168:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $168
80106dad:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106db2:	e9 e7 f3 ff ff       	jmp    8010619e <alltraps>

80106db7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $169
80106db9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106dbe:	e9 db f3 ff ff       	jmp    8010619e <alltraps>

80106dc3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $170
80106dc5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106dca:	e9 cf f3 ff ff       	jmp    8010619e <alltraps>

80106dcf <vector171>:
.globl vector171
vector171:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $171
80106dd1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106dd6:	e9 c3 f3 ff ff       	jmp    8010619e <alltraps>

80106ddb <vector172>:
.globl vector172
vector172:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $172
80106ddd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106de2:	e9 b7 f3 ff ff       	jmp    8010619e <alltraps>

80106de7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $173
80106de9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106dee:	e9 ab f3 ff ff       	jmp    8010619e <alltraps>

80106df3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $174
80106df5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106dfa:	e9 9f f3 ff ff       	jmp    8010619e <alltraps>

80106dff <vector175>:
.globl vector175
vector175:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $175
80106e01:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e06:	e9 93 f3 ff ff       	jmp    8010619e <alltraps>

80106e0b <vector176>:
.globl vector176
vector176:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $176
80106e0d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e12:	e9 87 f3 ff ff       	jmp    8010619e <alltraps>

80106e17 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $177
80106e19:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e1e:	e9 7b f3 ff ff       	jmp    8010619e <alltraps>

80106e23 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $178
80106e25:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e2a:	e9 6f f3 ff ff       	jmp    8010619e <alltraps>

80106e2f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $179
80106e31:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e36:	e9 63 f3 ff ff       	jmp    8010619e <alltraps>

80106e3b <vector180>:
.globl vector180
vector180:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $180
80106e3d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e42:	e9 57 f3 ff ff       	jmp    8010619e <alltraps>

80106e47 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $181
80106e49:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e4e:	e9 4b f3 ff ff       	jmp    8010619e <alltraps>

80106e53 <vector182>:
.globl vector182
vector182:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $182
80106e55:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e5a:	e9 3f f3 ff ff       	jmp    8010619e <alltraps>

80106e5f <vector183>:
.globl vector183
vector183:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $183
80106e61:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e66:	e9 33 f3 ff ff       	jmp    8010619e <alltraps>

80106e6b <vector184>:
.globl vector184
vector184:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $184
80106e6d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e72:	e9 27 f3 ff ff       	jmp    8010619e <alltraps>

80106e77 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $185
80106e79:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e7e:	e9 1b f3 ff ff       	jmp    8010619e <alltraps>

80106e83 <vector186>:
.globl vector186
vector186:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $186
80106e85:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e8a:	e9 0f f3 ff ff       	jmp    8010619e <alltraps>

80106e8f <vector187>:
.globl vector187
vector187:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $187
80106e91:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e96:	e9 03 f3 ff ff       	jmp    8010619e <alltraps>

80106e9b <vector188>:
.globl vector188
vector188:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $188
80106e9d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ea2:	e9 f7 f2 ff ff       	jmp    8010619e <alltraps>

80106ea7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $189
80106ea9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106eae:	e9 eb f2 ff ff       	jmp    8010619e <alltraps>

80106eb3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $190
80106eb5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106eba:	e9 df f2 ff ff       	jmp    8010619e <alltraps>

80106ebf <vector191>:
.globl vector191
vector191:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $191
80106ec1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ec6:	e9 d3 f2 ff ff       	jmp    8010619e <alltraps>

80106ecb <vector192>:
.globl vector192
vector192:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $192
80106ecd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ed2:	e9 c7 f2 ff ff       	jmp    8010619e <alltraps>

80106ed7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $193
80106ed9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106ede:	e9 bb f2 ff ff       	jmp    8010619e <alltraps>

80106ee3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $194
80106ee5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106eea:	e9 af f2 ff ff       	jmp    8010619e <alltraps>

80106eef <vector195>:
.globl vector195
vector195:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $195
80106ef1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ef6:	e9 a3 f2 ff ff       	jmp    8010619e <alltraps>

80106efb <vector196>:
.globl vector196
vector196:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $196
80106efd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f02:	e9 97 f2 ff ff       	jmp    8010619e <alltraps>

80106f07 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $197
80106f09:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f0e:	e9 8b f2 ff ff       	jmp    8010619e <alltraps>

80106f13 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $198
80106f15:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f1a:	e9 7f f2 ff ff       	jmp    8010619e <alltraps>

80106f1f <vector199>:
.globl vector199
vector199:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $199
80106f21:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f26:	e9 73 f2 ff ff       	jmp    8010619e <alltraps>

80106f2b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $200
80106f2d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f32:	e9 67 f2 ff ff       	jmp    8010619e <alltraps>

80106f37 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $201
80106f39:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f3e:	e9 5b f2 ff ff       	jmp    8010619e <alltraps>

80106f43 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $202
80106f45:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f4a:	e9 4f f2 ff ff       	jmp    8010619e <alltraps>

80106f4f <vector203>:
.globl vector203
vector203:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $203
80106f51:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f56:	e9 43 f2 ff ff       	jmp    8010619e <alltraps>

80106f5b <vector204>:
.globl vector204
vector204:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $204
80106f5d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f62:	e9 37 f2 ff ff       	jmp    8010619e <alltraps>

80106f67 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $205
80106f69:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f6e:	e9 2b f2 ff ff       	jmp    8010619e <alltraps>

80106f73 <vector206>:
.globl vector206
vector206:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $206
80106f75:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f7a:	e9 1f f2 ff ff       	jmp    8010619e <alltraps>

80106f7f <vector207>:
.globl vector207
vector207:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $207
80106f81:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f86:	e9 13 f2 ff ff       	jmp    8010619e <alltraps>

80106f8b <vector208>:
.globl vector208
vector208:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $208
80106f8d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f92:	e9 07 f2 ff ff       	jmp    8010619e <alltraps>

80106f97 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $209
80106f99:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f9e:	e9 fb f1 ff ff       	jmp    8010619e <alltraps>

80106fa3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $210
80106fa5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106faa:	e9 ef f1 ff ff       	jmp    8010619e <alltraps>

80106faf <vector211>:
.globl vector211
vector211:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $211
80106fb1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106fb6:	e9 e3 f1 ff ff       	jmp    8010619e <alltraps>

80106fbb <vector212>:
.globl vector212
vector212:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $212
80106fbd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106fc2:	e9 d7 f1 ff ff       	jmp    8010619e <alltraps>

80106fc7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $213
80106fc9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106fce:	e9 cb f1 ff ff       	jmp    8010619e <alltraps>

80106fd3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $214
80106fd5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106fda:	e9 bf f1 ff ff       	jmp    8010619e <alltraps>

80106fdf <vector215>:
.globl vector215
vector215:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $215
80106fe1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106fe6:	e9 b3 f1 ff ff       	jmp    8010619e <alltraps>

80106feb <vector216>:
.globl vector216
vector216:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $216
80106fed:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ff2:	e9 a7 f1 ff ff       	jmp    8010619e <alltraps>

80106ff7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $217
80106ff9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106ffe:	e9 9b f1 ff ff       	jmp    8010619e <alltraps>

80107003 <vector218>:
.globl vector218
vector218:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $218
80107005:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010700a:	e9 8f f1 ff ff       	jmp    8010619e <alltraps>

8010700f <vector219>:
.globl vector219
vector219:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $219
80107011:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107016:	e9 83 f1 ff ff       	jmp    8010619e <alltraps>

8010701b <vector220>:
.globl vector220
vector220:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $220
8010701d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107022:	e9 77 f1 ff ff       	jmp    8010619e <alltraps>

80107027 <vector221>:
.globl vector221
vector221:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $221
80107029:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010702e:	e9 6b f1 ff ff       	jmp    8010619e <alltraps>

80107033 <vector222>:
.globl vector222
vector222:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $222
80107035:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010703a:	e9 5f f1 ff ff       	jmp    8010619e <alltraps>

8010703f <vector223>:
.globl vector223
vector223:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $223
80107041:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107046:	e9 53 f1 ff ff       	jmp    8010619e <alltraps>

8010704b <vector224>:
.globl vector224
vector224:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $224
8010704d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107052:	e9 47 f1 ff ff       	jmp    8010619e <alltraps>

80107057 <vector225>:
.globl vector225
vector225:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $225
80107059:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010705e:	e9 3b f1 ff ff       	jmp    8010619e <alltraps>

80107063 <vector226>:
.globl vector226
vector226:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $226
80107065:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010706a:	e9 2f f1 ff ff       	jmp    8010619e <alltraps>

8010706f <vector227>:
.globl vector227
vector227:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $227
80107071:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107076:	e9 23 f1 ff ff       	jmp    8010619e <alltraps>

8010707b <vector228>:
.globl vector228
vector228:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $228
8010707d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107082:	e9 17 f1 ff ff       	jmp    8010619e <alltraps>

80107087 <vector229>:
.globl vector229
vector229:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $229
80107089:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010708e:	e9 0b f1 ff ff       	jmp    8010619e <alltraps>

80107093 <vector230>:
.globl vector230
vector230:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $230
80107095:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010709a:	e9 ff f0 ff ff       	jmp    8010619e <alltraps>

8010709f <vector231>:
.globl vector231
vector231:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $231
801070a1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070a6:	e9 f3 f0 ff ff       	jmp    8010619e <alltraps>

801070ab <vector232>:
.globl vector232
vector232:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $232
801070ad:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070b2:	e9 e7 f0 ff ff       	jmp    8010619e <alltraps>

801070b7 <vector233>:
.globl vector233
vector233:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $233
801070b9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070be:	e9 db f0 ff ff       	jmp    8010619e <alltraps>

801070c3 <vector234>:
.globl vector234
vector234:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $234
801070c5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070ca:	e9 cf f0 ff ff       	jmp    8010619e <alltraps>

801070cf <vector235>:
.globl vector235
vector235:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $235
801070d1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070d6:	e9 c3 f0 ff ff       	jmp    8010619e <alltraps>

801070db <vector236>:
.globl vector236
vector236:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $236
801070dd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070e2:	e9 b7 f0 ff ff       	jmp    8010619e <alltraps>

801070e7 <vector237>:
.globl vector237
vector237:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $237
801070e9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801070ee:	e9 ab f0 ff ff       	jmp    8010619e <alltraps>

801070f3 <vector238>:
.globl vector238
vector238:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $238
801070f5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801070fa:	e9 9f f0 ff ff       	jmp    8010619e <alltraps>

801070ff <vector239>:
.globl vector239
vector239:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $239
80107101:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107106:	e9 93 f0 ff ff       	jmp    8010619e <alltraps>

8010710b <vector240>:
.globl vector240
vector240:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $240
8010710d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107112:	e9 87 f0 ff ff       	jmp    8010619e <alltraps>

80107117 <vector241>:
.globl vector241
vector241:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $241
80107119:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010711e:	e9 7b f0 ff ff       	jmp    8010619e <alltraps>

80107123 <vector242>:
.globl vector242
vector242:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $242
80107125:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010712a:	e9 6f f0 ff ff       	jmp    8010619e <alltraps>

8010712f <vector243>:
.globl vector243
vector243:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $243
80107131:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107136:	e9 63 f0 ff ff       	jmp    8010619e <alltraps>

8010713b <vector244>:
.globl vector244
vector244:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $244
8010713d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107142:	e9 57 f0 ff ff       	jmp    8010619e <alltraps>

80107147 <vector245>:
.globl vector245
vector245:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $245
80107149:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010714e:	e9 4b f0 ff ff       	jmp    8010619e <alltraps>

80107153 <vector246>:
.globl vector246
vector246:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $246
80107155:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010715a:	e9 3f f0 ff ff       	jmp    8010619e <alltraps>

8010715f <vector247>:
.globl vector247
vector247:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $247
80107161:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107166:	e9 33 f0 ff ff       	jmp    8010619e <alltraps>

8010716b <vector248>:
.globl vector248
vector248:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $248
8010716d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107172:	e9 27 f0 ff ff       	jmp    8010619e <alltraps>

80107177 <vector249>:
.globl vector249
vector249:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $249
80107179:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010717e:	e9 1b f0 ff ff       	jmp    8010619e <alltraps>

80107183 <vector250>:
.globl vector250
vector250:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $250
80107185:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010718a:	e9 0f f0 ff ff       	jmp    8010619e <alltraps>

8010718f <vector251>:
.globl vector251
vector251:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $251
80107191:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107196:	e9 03 f0 ff ff       	jmp    8010619e <alltraps>

8010719b <vector252>:
.globl vector252
vector252:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $252
8010719d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071a2:	e9 f7 ef ff ff       	jmp    8010619e <alltraps>

801071a7 <vector253>:
.globl vector253
vector253:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $253
801071a9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071ae:	e9 eb ef ff ff       	jmp    8010619e <alltraps>

801071b3 <vector254>:
.globl vector254
vector254:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $254
801071b5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071ba:	e9 df ef ff ff       	jmp    8010619e <alltraps>

801071bf <vector255>:
.globl vector255
vector255:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $255
801071c1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071c6:	e9 d3 ef ff ff       	jmp    8010619e <alltraps>
801071cb:	66 90                	xchg   %ax,%ax
801071cd:	66 90                	xchg   %ax,%ax
801071cf:	90                   	nop

801071d0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801071d0:	f3 0f 1e fb          	endbr32 
801071d4:	55                   	push   %ebp
801071d5:	89 e5                	mov    %esp,%ebp
801071d7:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801071da:	e8 51 cf ff ff       	call   80104130 <cpuid>
  pd[0] = size-1;
801071df:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071e4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071ea:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071ee:	c7 80 d8 98 13 80 ff 	movl   $0xffff,-0x7fec6728(%eax)
801071f5:	ff 00 00 
801071f8:	c7 80 dc 98 13 80 00 	movl   $0xcf9a00,-0x7fec6724(%eax)
801071ff:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107202:	c7 80 e0 98 13 80 ff 	movl   $0xffff,-0x7fec6720(%eax)
80107209:	ff 00 00 
8010720c:	c7 80 e4 98 13 80 00 	movl   $0xcf9200,-0x7fec671c(%eax)
80107213:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107216:	c7 80 e8 98 13 80 ff 	movl   $0xffff,-0x7fec6718(%eax)
8010721d:	ff 00 00 
80107220:	c7 80 ec 98 13 80 00 	movl   $0xcffa00,-0x7fec6714(%eax)
80107227:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010722a:	c7 80 f0 98 13 80 ff 	movl   $0xffff,-0x7fec6710(%eax)
80107231:	ff 00 00 
80107234:	c7 80 f4 98 13 80 00 	movl   $0xcff200,-0x7fec670c(%eax)
8010723b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010723e:	05 d0 98 13 80       	add    $0x801398d0,%eax
  pd[1] = (uint)p;
80107243:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107247:	c1 e8 10             	shr    $0x10,%eax
8010724a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010724e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107251:	0f 01 10             	lgdtl  (%eax)
}
80107254:	c9                   	leave  
80107255:	c3                   	ret    
80107256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725d:	8d 76 00             	lea    0x0(%esi),%esi

80107260 <walkpgdir>:
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
int walkpgdircnt = 0;
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107260:	f3 0f 1e fb          	endbr32 
80107264:	55                   	push   %ebp
80107265:	89 e5                	mov    %esp,%ebp
80107267:	57                   	push   %edi
80107268:	56                   	push   %esi
80107269:	53                   	push   %ebx
8010726a:	83 ec 0c             	sub    $0xc,%esp
8010726d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  walkpgdircnt++;

  pde = &pgdir[PDX(va)];
80107270:	8b 55 08             	mov    0x8(%ebp),%edx
  walkpgdircnt++;
80107273:	83 05 c0 b5 10 80 01 	addl   $0x1,0x8010b5c0
  pde = &pgdir[PDX(va)];
8010727a:	89 fe                	mov    %edi,%esi
8010727c:	c1 ee 16             	shr    $0x16,%esi
8010727f:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80107282:	8b 1e                	mov    (%esi),%ebx
80107284:	f6 c3 01             	test   $0x1,%bl
80107287:	74 27                	je     801072b0 <walkpgdir+0x50>
    // if(walkpgdircnt>150000) cprintf("walkpgdir: if\n");
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80107289:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010728f:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    // cprintf("walkpgdir: if\n");
  }
  return &pgtab[PTX(va)];
80107295:	89 f8                	mov    %edi,%eax
}
80107297:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010729a:	c1 e8 0a             	shr    $0xa,%eax
8010729d:	25 fc 0f 00 00       	and    $0xffc,%eax
801072a2:	01 d8                	add    %ebx,%eax
}
801072a4:	5b                   	pop    %ebx
801072a5:	5e                   	pop    %esi
801072a6:	5f                   	pop    %edi
801072a7:	5d                   	pop    %ebp
801072a8:	c3                   	ret    
801072a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072b0:	8b 45 10             	mov    0x10(%ebp),%eax
801072b3:	85 c0                	test   %eax,%eax
801072b5:	74 31                	je     801072e8 <walkpgdir+0x88>
801072b7:	e8 64 bb ff ff       	call   80102e20 <kalloc>
801072bc:	89 c3                	mov    %eax,%ebx
801072be:	85 c0                	test   %eax,%eax
801072c0:	74 26                	je     801072e8 <walkpgdir+0x88>
    memset(pgtab, 0, PGSIZE);
801072c2:	83 ec 04             	sub    $0x4,%esp
801072c5:	68 00 10 00 00       	push   $0x1000
801072ca:	6a 00                	push   $0x0
801072cc:	50                   	push   %eax
801072cd:	e8 ae db ff ff       	call   80104e80 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072d2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072d8:	83 c4 10             	add    $0x10,%esp
801072db:	83 c8 07             	or     $0x7,%eax
801072de:	89 06                	mov    %eax,(%esi)
801072e0:	eb b3                	jmp    80107295 <walkpgdir+0x35>
801072e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
801072e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801072eb:	31 c0                	xor    %eax,%eax
}
801072ed:	5b                   	pop    %ebx
801072ee:	5e                   	pop    %esi
801072ef:	5f                   	pop    %edi
801072f0:	5d                   	pop    %ebp
801072f1:	c3                   	ret    
801072f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107300 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107306:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010730a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010730b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107310:	89 d6                	mov    %edx,%esi
{
80107312:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107313:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107319:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010731c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010731f:	8b 45 08             	mov    0x8(%ebp),%eax
80107322:	29 f0                	sub    %esi,%eax
80107324:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107327:	eb 1f                	jmp    80107348 <mappages+0x48>
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107330:	f6 00 01             	testb  $0x1,(%eax)
80107333:	75 45                	jne    8010737a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107335:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107338:	83 cb 01             	or     $0x1,%ebx
8010733b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010733d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107340:	74 2e                	je     80107370 <mappages+0x70>
      break;
    a += PGSIZE;
80107342:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107348:	83 ec 04             	sub    $0x4,%esp
8010734b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010734e:	6a 01                	push   $0x1
80107350:	56                   	push   %esi
80107351:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107354:	57                   	push   %edi
80107355:	e8 06 ff ff ff       	call   80107260 <walkpgdir>
8010735a:	83 c4 10             	add    $0x10,%esp
8010735d:	85 c0                	test   %eax,%eax
8010735f:	75 cf                	jne    80107330 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107361:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107369:	5b                   	pop    %ebx
8010736a:	5e                   	pop    %esi
8010736b:	5f                   	pop    %edi
8010736c:	5d                   	pop    %ebp
8010736d:	c3                   	ret    
8010736e:	66 90                	xchg   %ax,%ax
80107370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107373:	31 c0                	xor    %eax,%eax
}
80107375:	5b                   	pop    %ebx
80107376:	5e                   	pop    %esi
80107377:	5f                   	pop    %edi
80107378:	5d                   	pop    %ebp
80107379:	c3                   	ret    
      panic("remap");
8010737a:	83 ec 0c             	sub    $0xc,%esp
8010737d:	68 14 86 10 80       	push   $0x80108614
80107382:	e8 09 90 ff ff       	call   80100390 <panic>
80107387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738e:	66 90                	xchg   %ax,%ax

80107390 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) // exit할때 이게 호출되는데, 해당 exit하는 프로세스가 kalloc한 모든 메모리를 kfree해주는 코드, 즉 bitmap, lru 전부 해제해줘야함
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	89 c6                	mov    %eax,%esi
80107397:	53                   	push   %ebx
80107398:	89 d3                	mov    %edx,%ebx
  // cprintf("deallocuvm: started\n");

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010739a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801073a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) // exit할때 이게 호출되는데, 해당 exit하는 프로세스가 kalloc한 모든 메모리를 kfree해주는 코드, 즉 bitmap, lru 전부 해제해줘야함
801073a6:	83 ec 1c             	sub    $0x1c,%esp
801073a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801073ac:	39 da                	cmp    %ebx,%edx
801073ae:	73 5c                	jae    8010740c <deallocuvm.part.0+0x7c>
801073b0:	89 d7                	mov    %edx,%edi
801073b2:	eb 0e                	jmp    801073c2 <deallocuvm.part.0+0x32>
801073b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073b8:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073be:	39 fb                	cmp    %edi,%ebx
801073c0:	76 4a                	jbe    8010740c <deallocuvm.part.0+0x7c>
    pte = walkpgdir(pgdir, (char*)a, 0);
801073c2:	83 ec 04             	sub    $0x4,%esp
801073c5:	6a 00                	push   $0x0
801073c7:	57                   	push   %edi
801073c8:	56                   	push   %esi
801073c9:	e8 92 fe ff ff       	call   80107260 <walkpgdir>
    if(!pte)
801073ce:	83 c4 10             	add    $0x10,%esp
801073d1:	85 c0                	test   %eax,%eax
801073d3:	74 4b                	je     80107420 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801073d5:	8b 08                	mov    (%eax),%ecx
801073d7:	f6 c1 01             	test   $0x1,%cl
801073da:	74 dc                	je     801073b8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801073dc:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801073e2:	74 4c                	je     80107430 <deallocuvm.part.0+0xa0>
      //   if(cur->vaddr ==(char*) a){
      //     lru_delete(cur);
      //   }
      // }

      kfree(v);
801073e4:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801073e7:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
801073ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801073f0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073f6:	51                   	push   %ecx
801073f7:	e8 b4 b5 ff ff       	call   801029b0 <kfree>
      *pte = 0;
801073fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073ff:	83 c4 10             	add    $0x10,%esp
80107402:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107408:	39 fb                	cmp    %edi,%ebx
8010740a:	77 b6                	ja     801073c2 <deallocuvm.part.0+0x32>
    }
  }
  // init_lru();
  // init_bitmap();
  return newsz;
}
8010740c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010740f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107412:	5b                   	pop    %ebx
80107413:	5e                   	pop    %esi
80107414:	5f                   	pop    %edi
80107415:	5d                   	pop    %ebp
80107416:	c3                   	ret    
80107417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010741e:	66 90                	xchg   %ax,%ax
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107420:	89 fa                	mov    %edi,%edx
80107422:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107428:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010742e:	eb 8e                	jmp    801073be <deallocuvm.part.0+0x2e>
        panic("kfree");
80107430:	83 ec 0c             	sub    $0xc,%esp
80107433:	68 61 7f 10 80       	push   $0x80107f61
80107438:	e8 53 8f ff ff       	call   80100390 <panic>
8010743d:	8d 76 00             	lea    0x0(%esi),%esi

80107440 <switchkvm>:
{
80107440:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107444:	a1 84 c5 13 80       	mov    0x8013c584,%eax
80107449:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010744e:	0f 22 d8             	mov    %eax,%cr3
}
80107451:	c3                   	ret    
80107452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107460 <switchuvm>:
{
80107460:	f3 0f 1e fb          	endbr32 
80107464:	55                   	push   %ebp
80107465:	89 e5                	mov    %esp,%ebp
80107467:	57                   	push   %edi
80107468:	56                   	push   %esi
80107469:	53                   	push   %ebx
8010746a:	83 ec 1c             	sub    $0x1c,%esp
8010746d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107470:	85 f6                	test   %esi,%esi
80107472:	0f 84 cb 00 00 00    	je     80107543 <switchuvm+0xe3>
  if(p->kstack == 0)
80107478:	8b 46 08             	mov    0x8(%esi),%eax
8010747b:	85 c0                	test   %eax,%eax
8010747d:	0f 84 da 00 00 00    	je     8010755d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107483:	8b 46 04             	mov    0x4(%esi),%eax
80107486:	85 c0                	test   %eax,%eax
80107488:	0f 84 c2 00 00 00    	je     80107550 <switchuvm+0xf0>
  pushcli();
8010748e:	e8 dd d7 ff ff       	call   80104c70 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107493:	e8 28 cc ff ff       	call   801040c0 <mycpu>
80107498:	89 c3                	mov    %eax,%ebx
8010749a:	e8 21 cc ff ff       	call   801040c0 <mycpu>
8010749f:	89 c7                	mov    %eax,%edi
801074a1:	e8 1a cc ff ff       	call   801040c0 <mycpu>
801074a6:	83 c7 08             	add    $0x8,%edi
801074a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074ac:	e8 0f cc ff ff       	call   801040c0 <mycpu>
801074b1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801074b4:	ba 67 00 00 00       	mov    $0x67,%edx
801074b9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801074c0:	83 c0 08             	add    $0x8,%eax
801074c3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074ca:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074cf:	83 c1 08             	add    $0x8,%ecx
801074d2:	c1 e8 18             	shr    $0x18,%eax
801074d5:	c1 e9 10             	shr    $0x10,%ecx
801074d8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801074de:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801074e4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801074e9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074f0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801074f5:	e8 c6 cb ff ff       	call   801040c0 <mycpu>
801074fa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107501:	e8 ba cb ff ff       	call   801040c0 <mycpu>
80107506:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010750a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010750d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107513:	e8 a8 cb ff ff       	call   801040c0 <mycpu>
80107518:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010751b:	e8 a0 cb ff ff       	call   801040c0 <mycpu>
80107520:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107524:	b8 28 00 00 00       	mov    $0x28,%eax
80107529:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010752c:	8b 46 04             	mov    0x4(%esi),%eax
8010752f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107534:	0f 22 d8             	mov    %eax,%cr3
}
80107537:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010753a:	5b                   	pop    %ebx
8010753b:	5e                   	pop    %esi
8010753c:	5f                   	pop    %edi
8010753d:	5d                   	pop    %ebp
  popcli();
8010753e:	e9 7d d7 ff ff       	jmp    80104cc0 <popcli>
    panic("switchuvm: no process");
80107543:	83 ec 0c             	sub    $0xc,%esp
80107546:	68 1a 86 10 80       	push   $0x8010861a
8010754b:	e8 40 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107550:	83 ec 0c             	sub    $0xc,%esp
80107553:	68 45 86 10 80       	push   $0x80108645
80107558:	e8 33 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010755d:	83 ec 0c             	sub    $0xc,%esp
80107560:	68 30 86 10 80       	push   $0x80108630
80107565:	e8 26 8e ff ff       	call   80100390 <panic>
8010756a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107570 <inituvm>:
{
80107570:	f3 0f 1e fb          	endbr32 
80107574:	55                   	push   %ebp
80107575:	89 e5                	mov    %esp,%ebp
80107577:	57                   	push   %edi
80107578:	56                   	push   %esi
80107579:	53                   	push   %ebx
8010757a:	83 ec 1c             	sub    $0x1c,%esp
8010757d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107580:	8b 75 10             	mov    0x10(%ebp),%esi
80107583:	8b 7d 08             	mov    0x8(%ebp),%edi
80107586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107589:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010758f:	77 5b                	ja     801075ec <inituvm+0x7c>
  mem = kalloc();
80107591:	e8 8a b8 ff ff       	call   80102e20 <kalloc>
  memset(mem, 0, PGSIZE);
80107596:	83 ec 04             	sub    $0x4,%esp
80107599:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010759e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801075a0:	6a 00                	push   $0x0
801075a2:	50                   	push   %eax
801075a3:	e8 d8 d8 ff ff       	call   80104e80 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801075a8:	58                   	pop    %eax
801075a9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075af:	5a                   	pop    %edx
801075b0:	6a 06                	push   $0x6
801075b2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075b7:	31 d2                	xor    %edx,%edx
801075b9:	50                   	push   %eax
801075ba:	89 f8                	mov    %edi,%eax
801075bc:	e8 3f fd ff ff       	call   80107300 <mappages>
  memmove(mem, init, sz);
801075c1:	83 c4 0c             	add    $0xc,%esp
801075c4:	56                   	push   %esi
801075c5:	ff 75 e4             	pushl  -0x1c(%ebp)
801075c8:	53                   	push   %ebx
801075c9:	e8 52 d9 ff ff       	call   80104f20 <memmove>
  init_lru();
801075ce:	e8 ed b0 ff ff       	call   801026c0 <init_lru>
  lru_append(pgdir, 0); // 맞나?
801075d3:	89 7d 08             	mov    %edi,0x8(%ebp)
801075d6:	83 c4 10             	add    $0x10,%esp
801075d9:	c7 45 0c 00 00 00 00 	movl   $0x0,0xc(%ebp)
}
801075e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075e3:	5b                   	pop    %ebx
801075e4:	5e                   	pop    %esi
801075e5:	5f                   	pop    %edi
801075e6:	5d                   	pop    %ebp
  lru_append(pgdir, 0); // 맞나?
801075e7:	e9 54 b2 ff ff       	jmp    80102840 <lru_append>
    panic("inituvm: more than a page");
801075ec:	83 ec 0c             	sub    $0xc,%esp
801075ef:	68 59 86 10 80       	push   $0x80108659
801075f4:	e8 97 8d ff ff       	call   80100390 <panic>
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107600 <loaduvm>:
{
80107600:	f3 0f 1e fb          	endbr32 
80107604:	55                   	push   %ebp
80107605:	89 e5                	mov    %esp,%ebp
80107607:	57                   	push   %edi
80107608:	56                   	push   %esi
80107609:	53                   	push   %ebx
8010760a:	83 ec 1c             	sub    $0x1c,%esp
8010760d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107610:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107613:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107618:	0f 85 99 00 00 00    	jne    801076b7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010761e:	01 f0                	add    %esi,%eax
80107620:	89 f3                	mov    %esi,%ebx
80107622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107625:	8b 45 14             	mov    0x14(%ebp),%eax
80107628:	01 f0                	add    %esi,%eax
8010762a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010762d:	85 f6                	test   %esi,%esi
8010762f:	75 15                	jne    80107646 <loaduvm+0x46>
80107631:	eb 6d                	jmp    801076a0 <loaduvm+0xa0>
80107633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107637:	90                   	nop
80107638:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010763e:	89 f0                	mov    %esi,%eax
80107640:	29 d8                	sub    %ebx,%eax
80107642:	39 c6                	cmp    %eax,%esi
80107644:	76 5a                	jbe    801076a0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107649:	83 ec 04             	sub    $0x4,%esp
8010764c:	6a 00                	push   $0x0
8010764e:	29 d8                	sub    %ebx,%eax
80107650:	50                   	push   %eax
80107651:	ff 75 08             	pushl  0x8(%ebp)
80107654:	e8 07 fc ff ff       	call   80107260 <walkpgdir>
80107659:	83 c4 10             	add    $0x10,%esp
8010765c:	85 c0                	test   %eax,%eax
8010765e:	74 4a                	je     801076aa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107660:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107662:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107665:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
8010766a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010766f:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107675:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107678:	29 d9                	sub    %ebx,%ecx
8010767a:	05 00 00 00 80       	add    $0x80000000,%eax
8010767f:	57                   	push   %edi
80107680:	51                   	push   %ecx
80107681:	50                   	push   %eax
80107682:	ff 75 10             	pushl  0x10(%ebp)
80107685:	e8 d6 a3 ff ff       	call   80101a60 <readi>
8010768a:	83 c4 10             	add    $0x10,%esp
8010768d:	39 f8                	cmp    %edi,%eax
8010768f:	74 a7                	je     80107638 <loaduvm+0x38>
}
80107691:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107699:	5b                   	pop    %ebx
8010769a:	5e                   	pop    %esi
8010769b:	5f                   	pop    %edi
8010769c:	5d                   	pop    %ebp
8010769d:	c3                   	ret    
8010769e:	66 90                	xchg   %ax,%ax
801076a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076a3:	31 c0                	xor    %eax,%eax
}
801076a5:	5b                   	pop    %ebx
801076a6:	5e                   	pop    %esi
801076a7:	5f                   	pop    %edi
801076a8:	5d                   	pop    %ebp
801076a9:	c3                   	ret    
      panic("loaduvm: address should exist");
801076aa:	83 ec 0c             	sub    $0xc,%esp
801076ad:	68 73 86 10 80       	push   $0x80108673
801076b2:	e8 d9 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801076b7:	83 ec 0c             	sub    $0xc,%esp
801076ba:	68 14 87 10 80       	push   $0x80108714
801076bf:	e8 cc 8c ff ff       	call   80100390 <panic>
801076c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076cf:	90                   	nop

801076d0 <allocuvm>:
{
801076d0:	f3 0f 1e fb          	endbr32 
801076d4:	55                   	push   %ebp
801076d5:	89 e5                	mov    %esp,%ebp
801076d7:	57                   	push   %edi
801076d8:	56                   	push   %esi
801076d9:	53                   	push   %ebx
801076da:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801076dd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801076e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801076e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076e6:	85 c0                	test   %eax,%eax
801076e8:	0f 88 c2 00 00 00    	js     801077b0 <allocuvm+0xe0>
  if(newsz < oldsz)
801076ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801076f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801076f4:	0f 82 a6 00 00 00    	jb     801077a0 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
801076fa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107700:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE, cnt++){
80107706:	39 75 10             	cmp    %esi,0x10(%ebp)
80107709:	77 51                	ja     8010775c <allocuvm+0x8c>
8010770b:	e9 93 00 00 00       	jmp    801077a3 <allocuvm+0xd3>
    memset(mem, 0, PGSIZE);
80107710:	83 ec 04             	sub    $0x4,%esp
80107713:	68 00 10 00 00       	push   $0x1000
80107718:	6a 00                	push   $0x0
8010771a:	50                   	push   %eax
8010771b:	e8 60 d7 ff ff       	call   80104e80 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107720:	58                   	pop    %eax
80107721:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107727:	5a                   	pop    %edx
80107728:	6a 06                	push   $0x6
8010772a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010772f:	89 f2                	mov    %esi,%edx
80107731:	50                   	push   %eax
80107732:	89 f8                	mov    %edi,%eax
80107734:	e8 c7 fb ff ff       	call   80107300 <mappages>
80107739:	83 c4 10             	add    $0x10,%esp
8010773c:	85 c0                	test   %eax,%eax
8010773e:	0f 88 84 00 00 00    	js     801077c8 <allocuvm+0xf8>
    lru_append(pgdir, (void *)a); // My code
80107744:	83 ec 08             	sub    $0x8,%esp
80107747:	56                   	push   %esi
  for (; a < newsz; a += PGSIZE, cnt++){
80107748:	81 c6 00 10 00 00    	add    $0x1000,%esi
    lru_append(pgdir, (void *)a); // My code
8010774e:	57                   	push   %edi
8010774f:	e8 ec b0 ff ff       	call   80102840 <lru_append>
  for (; a < newsz; a += PGSIZE, cnt++){
80107754:	83 c4 10             	add    $0x10,%esp
80107757:	39 75 10             	cmp    %esi,0x10(%ebp)
8010775a:	76 47                	jbe    801077a3 <allocuvm+0xd3>
    mem = kalloc();
8010775c:	e8 bf b6 ff ff       	call   80102e20 <kalloc>
80107761:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107763:	85 c0                	test   %eax,%eax
80107765:	75 a9                	jne    80107710 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107767:	83 ec 0c             	sub    $0xc,%esp
8010776a:	68 91 86 10 80       	push   $0x80108691
8010776f:	e8 3c 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107774:	8b 45 0c             	mov    0xc(%ebp),%eax
80107777:	83 c4 10             	add    $0x10,%esp
8010777a:	39 45 10             	cmp    %eax,0x10(%ebp)
8010777d:	74 31                	je     801077b0 <allocuvm+0xe0>
8010777f:	8b 55 10             	mov    0x10(%ebp),%edx
80107782:	89 c1                	mov    %eax,%ecx
80107784:	89 f8                	mov    %edi,%eax
80107786:	e8 05 fc ff ff       	call   80107390 <deallocuvm.part.0>
      return 0;
8010778b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107795:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107798:	5b                   	pop    %ebx
80107799:	5e                   	pop    %esi
8010779a:	5f                   	pop    %edi
8010779b:	5d                   	pop    %ebp
8010779c:	c3                   	ret    
8010779d:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
801077a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801077a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077a9:	5b                   	pop    %ebx
801077aa:	5e                   	pop    %esi
801077ab:	5f                   	pop    %edi
801077ac:	5d                   	pop    %ebp
801077ad:	c3                   	ret    
801077ae:	66 90                	xchg   %ax,%ax
    return 0;
801077b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077bd:	5b                   	pop    %ebx
801077be:	5e                   	pop    %esi
801077bf:	5f                   	pop    %edi
801077c0:	5d                   	pop    %ebp
801077c1:	c3                   	ret    
801077c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801077c8:	83 ec 0c             	sub    $0xc,%esp
801077cb:	68 a9 86 10 80       	push   $0x801086a9
801077d0:	e8 db 8e ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801077d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801077d8:	83 c4 10             	add    $0x10,%esp
801077db:	39 45 10             	cmp    %eax,0x10(%ebp)
801077de:	74 0c                	je     801077ec <allocuvm+0x11c>
801077e0:	8b 55 10             	mov    0x10(%ebp),%edx
801077e3:	89 c1                	mov    %eax,%ecx
801077e5:	89 f8                	mov    %edi,%eax
801077e7:	e8 a4 fb ff ff       	call   80107390 <deallocuvm.part.0>
      kfree(mem);
801077ec:	83 ec 0c             	sub    $0xc,%esp
801077ef:	53                   	push   %ebx
801077f0:	e8 bb b1 ff ff       	call   801029b0 <kfree>
      return 0;
801077f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801077fc:	83 c4 10             	add    $0x10,%esp
}
801077ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107802:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107805:	5b                   	pop    %ebx
80107806:	5e                   	pop    %esi
80107807:	5f                   	pop    %edi
80107808:	5d                   	pop    %ebp
80107809:	c3                   	ret    
8010780a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107810 <deallocuvm>:
{
80107810:	f3 0f 1e fb          	endbr32 
80107814:	55                   	push   %ebp
80107815:	89 e5                	mov    %esp,%ebp
80107817:	8b 55 0c             	mov    0xc(%ebp),%edx
8010781a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010781d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107820:	39 d1                	cmp    %edx,%ecx
80107822:	73 0c                	jae    80107830 <deallocuvm+0x20>
}
80107824:	5d                   	pop    %ebp
80107825:	e9 66 fb ff ff       	jmp    80107390 <deallocuvm.part.0>
8010782a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107830:	89 d0                	mov    %edx,%eax
80107832:	5d                   	pop    %ebp
80107833:	c3                   	ret    
80107834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010783b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010783f:	90                   	nop

80107840 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107840:	f3 0f 1e fb          	endbr32 
80107844:	55                   	push   %ebp
80107845:	89 e5                	mov    %esp,%ebp
80107847:	57                   	push   %edi
80107848:	56                   	push   %esi
80107849:	53                   	push   %ebx
8010784a:	83 ec 0c             	sub    $0xc,%esp
8010784d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107850:	85 f6                	test   %esi,%esi
80107852:	74 55                	je     801078a9 <freevm+0x69>
  if(newsz >= oldsz)
80107854:	31 c9                	xor    %ecx,%ecx
80107856:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010785b:	89 f0                	mov    %esi,%eax
8010785d:	89 f3                	mov    %esi,%ebx
8010785f:	e8 2c fb ff ff       	call   80107390 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107864:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010786a:	eb 0b                	jmp    80107877 <freevm+0x37>
8010786c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107870:	83 c3 04             	add    $0x4,%ebx
80107873:	39 df                	cmp    %ebx,%edi
80107875:	74 23                	je     8010789a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107877:	8b 03                	mov    (%ebx),%eax
80107879:	a8 01                	test   $0x1,%al
8010787b:	74 f3                	je     80107870 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010787d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107882:	83 ec 0c             	sub    $0xc,%esp
80107885:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107888:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010788d:	50                   	push   %eax
8010788e:	e8 1d b1 ff ff       	call   801029b0 <kfree>
80107893:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107896:	39 df                	cmp    %ebx,%edi
80107898:	75 dd                	jne    80107877 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010789a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010789d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078a0:	5b                   	pop    %ebx
801078a1:	5e                   	pop    %esi
801078a2:	5f                   	pop    %edi
801078a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801078a4:	e9 07 b1 ff ff       	jmp    801029b0 <kfree>
    panic("freevm: no pgdir");
801078a9:	83 ec 0c             	sub    $0xc,%esp
801078ac:	68 c5 86 10 80       	push   $0x801086c5
801078b1:	e8 da 8a ff ff       	call   80100390 <panic>
801078b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078bd:	8d 76 00             	lea    0x0(%esi),%esi

801078c0 <setupkvm>:
{
801078c0:	f3 0f 1e fb          	endbr32 
801078c4:	55                   	push   %ebp
801078c5:	89 e5                	mov    %esp,%ebp
801078c7:	56                   	push   %esi
801078c8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801078c9:	e8 52 b5 ff ff       	call   80102e20 <kalloc>
801078ce:	89 c6                	mov    %eax,%esi
801078d0:	85 c0                	test   %eax,%eax
801078d2:	74 42                	je     80107916 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801078d4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078d7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801078dc:	68 00 10 00 00       	push   $0x1000
801078e1:	6a 00                	push   $0x0
801078e3:	50                   	push   %eax
801078e4:	e8 97 d5 ff ff       	call   80104e80 <memset>
801078e9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801078ec:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078ef:	83 ec 08             	sub    $0x8,%esp
801078f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801078f5:	ff 73 0c             	pushl  0xc(%ebx)
801078f8:	8b 13                	mov    (%ebx),%edx
801078fa:	50                   	push   %eax
801078fb:	29 c1                	sub    %eax,%ecx
801078fd:	89 f0                	mov    %esi,%eax
801078ff:	e8 fc f9 ff ff       	call   80107300 <mappages>
80107904:	83 c4 10             	add    $0x10,%esp
80107907:	85 c0                	test   %eax,%eax
80107909:	78 15                	js     80107920 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010790b:	83 c3 10             	add    $0x10,%ebx
8010790e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107914:	75 d6                	jne    801078ec <setupkvm+0x2c>
}
80107916:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107919:	89 f0                	mov    %esi,%eax
8010791b:	5b                   	pop    %ebx
8010791c:	5e                   	pop    %esi
8010791d:	5d                   	pop    %ebp
8010791e:	c3                   	ret    
8010791f:	90                   	nop
      freevm(pgdir);
80107920:	83 ec 0c             	sub    $0xc,%esp
80107923:	56                   	push   %esi
      return 0;
80107924:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107926:	e8 15 ff ff ff       	call   80107840 <freevm>
      return 0;
8010792b:	83 c4 10             	add    $0x10,%esp
}
8010792e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107931:	89 f0                	mov    %esi,%eax
80107933:	5b                   	pop    %ebx
80107934:	5e                   	pop    %esi
80107935:	5d                   	pop    %ebp
80107936:	c3                   	ret    
80107937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010793e:	66 90                	xchg   %ax,%ax

80107940 <kvmalloc>:
{
80107940:	f3 0f 1e fb          	endbr32 
80107944:	55                   	push   %ebp
80107945:	89 e5                	mov    %esp,%ebp
80107947:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010794a:	e8 71 ff ff ff       	call   801078c0 <setupkvm>
8010794f:	a3 84 c5 13 80       	mov    %eax,0x8013c584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107954:	05 00 00 00 80       	add    $0x80000000,%eax
80107959:	0f 22 d8             	mov    %eax,%cr3
}
8010795c:	c9                   	leave  
8010795d:	c3                   	ret    
8010795e:	66 90                	xchg   %ax,%ax

80107960 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107960:	f3 0f 1e fb          	endbr32 
80107964:	55                   	push   %ebp
80107965:	89 e5                	mov    %esp,%ebp
80107967:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010796a:	6a 00                	push   $0x0
8010796c:	ff 75 0c             	pushl  0xc(%ebp)
8010796f:	ff 75 08             	pushl  0x8(%ebp)
80107972:	e8 e9 f8 ff ff       	call   80107260 <walkpgdir>
  if(pte == 0)
80107977:	83 c4 10             	add    $0x10,%esp
8010797a:	85 c0                	test   %eax,%eax
8010797c:	74 05                	je     80107983 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010797e:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107981:	c9                   	leave  
80107982:	c3                   	ret    
    panic("clearpteu");
80107983:	83 ec 0c             	sub    $0xc,%esp
80107986:	68 d6 86 10 80       	push   $0x801086d6
8010798b:	e8 00 8a ff ff       	call   80100390 <panic>

80107990 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107990:	f3 0f 1e fb          	endbr32 
80107994:	55                   	push   %ebp
80107995:	89 e5                	mov    %esp,%ebp
80107997:	57                   	push   %edi
80107998:	56                   	push   %esi
80107999:	53                   	push   %ebx
8010799a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010799d:	e8 1e ff ff ff       	call   801078c0 <setupkvm>
801079a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079a5:	85 c0                	test   %eax,%eax
801079a7:	0f 84 a0 00 00 00    	je     80107a4d <copyuvm+0xbd>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079b0:	85 c9                	test   %ecx,%ecx
801079b2:	0f 84 95 00 00 00    	je     80107a4d <copyuvm+0xbd>
801079b8:	31 f6                	xor    %esi,%esi
801079ba:	eb 46                	jmp    80107a02 <copyuvm+0x72>
801079bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801079c0:	83 ec 04             	sub    $0x4,%esp
801079c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801079c9:	68 00 10 00 00       	push   $0x1000
801079ce:	57                   	push   %edi
801079cf:	50                   	push   %eax
801079d0:	e8 4b d5 ff ff       	call   80104f20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801079d5:	58                   	pop    %eax
801079d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079dc:	5a                   	pop    %edx
801079dd:	ff 75 e4             	pushl  -0x1c(%ebp)
801079e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079e5:	89 f2                	mov    %esi,%edx
801079e7:	50                   	push   %eax
801079e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079eb:	e8 10 f9 ff ff       	call   80107300 <mappages>
801079f0:	83 c4 10             	add    $0x10,%esp
801079f3:	85 c0                	test   %eax,%eax
801079f5:	78 69                	js     80107a60 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
801079f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a00:	76 4b                	jbe    80107a4d <copyuvm+0xbd>
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80107a02:	83 ec 04             	sub    $0x4,%esp
80107a05:	6a 00                	push   $0x0
80107a07:	56                   	push   %esi
80107a08:	ff 75 08             	pushl  0x8(%ebp)
80107a0b:	e8 50 f8 ff ff       	call   80107260 <walkpgdir>
80107a10:	83 c4 10             	add    $0x10,%esp
80107a13:	85 c0                	test   %eax,%eax
80107a15:	74 64                	je     80107a7b <copyuvm+0xeb>
    if(!(*pte & PTE_P))
80107a17:	8b 00                	mov    (%eax),%eax
80107a19:	a8 01                	test   $0x1,%al
80107a1b:	74 51                	je     80107a6e <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
80107a1d:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a1f:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a27:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a2d:	e8 ee b3 ff ff       	call   80102e20 <kalloc>
80107a32:	89 c3                	mov    %eax,%ebx
80107a34:	85 c0                	test   %eax,%eax
80107a36:	75 88                	jne    801079c0 <copyuvm+0x30>
    // lru_append(d, (void *)i); // My code
  }
  return d;

bad:
  freevm(d);
80107a38:	83 ec 0c             	sub    $0xc,%esp
80107a3b:	ff 75 e0             	pushl  -0x20(%ebp)
80107a3e:	e8 fd fd ff ff       	call   80107840 <freevm>
  return 0;
80107a43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a4a:	83 c4 10             	add    $0x10,%esp
}
80107a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a53:	5b                   	pop    %ebx
80107a54:	5e                   	pop    %esi
80107a55:	5f                   	pop    %edi
80107a56:	5d                   	pop    %ebp
80107a57:	c3                   	ret    
80107a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a5f:	90                   	nop
      kfree(mem);
80107a60:	83 ec 0c             	sub    $0xc,%esp
80107a63:	53                   	push   %ebx
80107a64:	e8 47 af ff ff       	call   801029b0 <kfree>
      goto bad;
80107a69:	83 c4 10             	add    $0x10,%esp
80107a6c:	eb ca                	jmp    80107a38 <copyuvm+0xa8>
      panic("copyuvm: page not present");
80107a6e:	83 ec 0c             	sub    $0xc,%esp
80107a71:	68 fa 86 10 80       	push   $0x801086fa
80107a76:	e8 15 89 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107a7b:	83 ec 0c             	sub    $0xc,%esp
80107a7e:	68 e0 86 10 80       	push   $0x801086e0
80107a83:	e8 08 89 ff ff       	call   80100390 <panic>
80107a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a8f:	90                   	nop

80107a90 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a90:	f3 0f 1e fb          	endbr32 
80107a94:	55                   	push   %ebp
80107a95:	89 e5                	mov    %esp,%ebp
80107a97:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a9a:	6a 00                	push   $0x0
80107a9c:	ff 75 0c             	pushl  0xc(%ebp)
80107a9f:	ff 75 08             	pushl  0x8(%ebp)
80107aa2:	e8 b9 f7 ff ff       	call   80107260 <walkpgdir>
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
80107aa7:	83 c4 10             	add    $0x10,%esp
  if((*pte & PTE_P) == 0)
80107aaa:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107aac:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107aad:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107aaf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ab4:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ab7:	05 00 00 00 80       	add    $0x80000000,%eax
80107abc:	83 fa 05             	cmp    $0x5,%edx
80107abf:	ba 00 00 00 00       	mov    $0x0,%edx
80107ac4:	0f 45 c2             	cmovne %edx,%eax
}
80107ac7:	c3                   	ret    
80107ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107acf:	90                   	nop

80107ad0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ad0:	f3 0f 1e fb          	endbr32 
80107ad4:	55                   	push   %ebp
80107ad5:	89 e5                	mov    %esp,%ebp
80107ad7:	57                   	push   %edi
80107ad8:	56                   	push   %esi
80107ad9:	53                   	push   %ebx
80107ada:	83 ec 0c             	sub    $0xc,%esp
80107add:	8b 75 14             	mov    0x14(%ebp),%esi
80107ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ae3:	85 f6                	test   %esi,%esi
80107ae5:	75 3c                	jne    80107b23 <copyout+0x53>
80107ae7:	eb 67                	jmp    80107b50 <copyout+0x80>
80107ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107af0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107af3:	89 fb                	mov    %edi,%ebx
80107af5:	29 d3                	sub    %edx,%ebx
80107af7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107afd:	39 f3                	cmp    %esi,%ebx
80107aff:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b02:	29 fa                	sub    %edi,%edx
80107b04:	83 ec 04             	sub    $0x4,%esp
80107b07:	01 c2                	add    %eax,%edx
80107b09:	53                   	push   %ebx
80107b0a:	ff 75 10             	pushl  0x10(%ebp)
80107b0d:	52                   	push   %edx
80107b0e:	e8 0d d4 ff ff       	call   80104f20 <memmove>
    len -= n;
    buf += n;
80107b13:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b16:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b1c:	83 c4 10             	add    $0x10,%esp
80107b1f:	29 de                	sub    %ebx,%esi
80107b21:	74 2d                	je     80107b50 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b23:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b25:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b28:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b2b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b31:	57                   	push   %edi
80107b32:	ff 75 08             	pushl  0x8(%ebp)
80107b35:	e8 56 ff ff ff       	call   80107a90 <uva2ka>
    if(pa0 == 0)
80107b3a:	83 c4 10             	add    $0x10,%esp
80107b3d:	85 c0                	test   %eax,%eax
80107b3f:	75 af                	jne    80107af0 <copyout+0x20>
  }
  return 0;
}
80107b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b49:	5b                   	pop    %ebx
80107b4a:	5e                   	pop    %esi
80107b4b:	5f                   	pop    %edi
80107b4c:	5d                   	pop    %ebp
80107b4d:	c3                   	ret    
80107b4e:	66 90                	xchg   %ax,%ax
80107b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b53:	31 c0                	xor    %eax,%eax
}
80107b55:	5b                   	pop    %ebx
80107b56:	5e                   	pop    %esi
80107b57:	5f                   	pop    %edi
80107b58:	5d                   	pop    %ebp
80107b59:	c3                   	ret    
