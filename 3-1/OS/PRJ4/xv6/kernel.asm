
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 3b 10 80       	mov    $0x80103b80,%eax
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
80100048:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 00 80 10 80       	push   $0x80108000
80100055:	68 e0 d5 10 80       	push   $0x8010d5e0
8010005a:	e8 11 4f 00 00       	call   80104f70 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 1c 11 80       	mov    $0x80111cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
8010006e:	1c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
80100078:	1c 11 80 
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
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 80 10 80       	push   $0x80108007
80100097:	50                   	push   %eax
80100098:	e8 93 4d 00 00       	call   80104e30 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 1a 11 80    	cmp    $0x80111a80,%ebx
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
801000e3:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e8:	e8 03 50 00 00       	call   801050f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
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
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
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
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 49 50 00 00       	call   801051b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 4c 00 00       	call   80104e70 <acquiresleep>
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
801001a3:	68 0e 80 10 80       	push   $0x8010800e
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
801001c2:	e8 49 4d 00 00       	call   80104f10 <holdingsleep>
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
801001e0:	68 1f 80 10 80       	push   $0x8010801f
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
80100203:	e8 08 4d 00 00       	call   80104f10 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 b8 4c 00 00       	call   80104ed0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010021f:	e8 cc 4e 00 00       	call   801050f0 <acquire>
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
80100246:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 1d 11 80       	mov    0x80111d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 3b 4f 00 00       	jmp    801051b0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 26 80 10 80       	push   $0x80108026
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
801002aa:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002b1:	e8 3a 4e 00 00       	call   801050f0 <acquire>
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
801002c6:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002cb:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 c5 10 80       	push   $0x8010c520
801002e0:	68 c0 1f 11 80       	push   $0x80111fc0
801002e5:	e8 c6 47 00 00       	call   80104ab0 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 d1 41 00 00       	call   801044d0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 c5 10 80       	push   $0x8010c520
8010030e:	e8 9d 4e 00 00       	call   801051b0 <release>
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
80100333:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 1f 11 80 	movsbl -0x7feee0c0(%edx),%ecx
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
80100360:	68 20 c5 10 80       	push   $0x8010c520
80100365:	e8 46 4e 00 00       	call   801051b0 <release>
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
80100386:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
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
8010039d:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 0e 30 00 00       	call   801033c0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 2d 80 10 80       	push   $0x8010802d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 3a 83 10 80 	movl   $0x8010833a,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 af 4b 00 00       	call   80104f90 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 41 80 10 80       	push   $0x80108041
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
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
8010042a:	e8 d1 66 00 00       	call   80106b00 <uartputc>
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
80100515:	e8 e6 65 00 00       	call   80106b00 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 da 65 00 00       	call   80106b00 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ce 65 00 00       	call   80106b00 <uartputc>
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
80100561:	e8 3a 4d 00 00       	call   801052a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 4c 00 00       	call   80105200 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 45 80 10 80       	push   $0x80108045
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
801005c9:	0f b6 92 70 80 10 80 	movzbl -0x7fef7f90(%edx),%edx
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
80100603:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
80100658:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010065f:	e8 8c 4a 00 00       	call   801050f0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
80100692:	68 20 c5 10 80       	push   $0x8010c520
80100697:	e8 14 4b 00 00       	call   801051b0 <release>
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
801006bd:	a1 54 c5 10 80       	mov    0x8010c554,%eax
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
801006ec:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
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
8010077d:	bb 58 80 10 80       	mov    $0x80108058,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
801007b8:	68 20 c5 10 80       	push   $0x8010c520
801007bd:	e8 2e 49 00 00       	call   801050f0 <acquire>
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
801007e0:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 c5 10 80       	push   $0x8010c520
80100828:	e8 83 49 00 00       	call   801051b0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 5f 80 10 80       	push   $0x8010805f
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
80100872:	68 20 c5 10 80       	push   $0x8010c520
80100877:	e8 74 48 00 00       	call   801050f0 <acquire>
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
801008b4:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 1f 11 80    	sub    0x80111fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 1f 11 80    	mov    %ecx,0x80111fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 1f 11 80    	mov    %bl,-0x7feee0c0(%eax)
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
80100908:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 1f 11 80    	cmp    %eax,0x80111fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100925:	39 05 c4 1f 11 80    	cmp    %eax,0x80111fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
        input.e--;
8010094c:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
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
8010096a:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
8010096f:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100985:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
  if(panicked){
80100999:	a1 58 c5 10 80       	mov    0x8010c558,%eax
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
801009ca:	68 20 c5 10 80       	push   $0x8010c520
801009cf:	e8 dc 47 00 00       	call   801051b0 <release>
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
801009e3:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
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
801009ff:	e9 5c 43 00 00       	jmp    80104d60 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
          wakeup(&input.r);
80100a1b:	68 c0 1f 11 80       	push   $0x80111fc0
80100a20:	e8 4b 42 00 00       	call   80104c70 <wakeup>
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
80100a3a:	68 68 80 10 80       	push   $0x80108068
80100a3f:	68 20 c5 10 80       	push   $0x8010c520
80100a44:	e8 27 45 00 00       	call   80104f70 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 8c 29 11 80 40 	movl   $0x80100640,0x8011298c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 88 29 11 80 90 	movl   $0x80100290,0x80112988
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
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
80100a90:	e8 3b 3a 00 00       	call   801044d0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 b0 2d 00 00       	call   80103850 <begin_op>

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
80100ae3:	e8 d8 2d 00 00       	call   801038c0 <end_op>
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
80100b0c:	e8 2f 72 00 00       	call   80107d40 <setupkvm>
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
80100b73:	e8 88 6f 00 00       	call   80107b00 <allocuvm>
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
80100ba9:	e8 82 6e 00 00       	call   80107a30 <loaduvm>
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
80100beb:	e8 d0 70 00 00       	call   80107cc0 <freevm>
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
80100c21:	e8 9a 2c 00 00       	call   801038c0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 c9 6e 00 00       	call   80107b00 <allocuvm>
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
80100c53:	e8 88 71 00 00       	call   80107de0 <clearpteu>
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
80100ca3:	e8 58 47 00 00       	call   80105400 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 45 47 00 00       	call   80105400 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 a4 72 00 00       	call   80107f70 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 da 6f 00 00       	call   80107cc0 <freevm>
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
80100d33:	e8 38 72 00 00       	call   80107f70 <copyout>
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
80100d71:	e8 4a 46 00 00       	call   801053c0 <safestrcpy>
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
80100d9d:	e8 ae 6a 00 00       	call   80107850 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 16 6f 00 00       	call   80107cc0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 07 2b 00 00       	call   801038c0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 81 80 10 80       	push   $0x80108081
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
80100dea:	68 8d 80 10 80       	push   $0x8010808d
80100def:	68 e0 1f 11 80       	push   $0x80111fe0
80100df4:	e8 77 41 00 00       	call   80104f70 <initlock>
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
80100e08:	bb 14 20 11 80       	mov    $0x80112014,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 e0 1f 11 80       	push   $0x80111fe0
80100e15:	e8 d6 42 00 00       	call   801050f0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
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
80100e3c:	68 e0 1f 11 80       	push   $0x80111fe0
80100e41:	e8 6a 43 00 00       	call   801051b0 <release>
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
80100e55:	68 e0 1f 11 80       	push   $0x80111fe0
80100e5a:	e8 51 43 00 00       	call   801051b0 <release>
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
80100e7e:	68 e0 1f 11 80       	push   $0x80111fe0
80100e83:	e8 68 42 00 00       	call   801050f0 <acquire>
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
80100e9b:	68 e0 1f 11 80       	push   $0x80111fe0
80100ea0:	e8 0b 43 00 00       	call   801051b0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 94 80 10 80       	push   $0x80108094
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
80100ed0:	68 e0 1f 11 80       	push   $0x80111fe0
80100ed5:	e8 16 42 00 00       	call   801050f0 <acquire>
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
80100f08:	68 e0 1f 11 80       	push   $0x80111fe0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 9b 42 00 00       	call   801051b0 <release>

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
80100f30:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 6d 42 00 00       	jmp    801051b0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 03 29 00 00       	call   80103850 <begin_op>
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
80100f62:	e9 59 29 00 00       	jmp    801038c0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 f2 30 00 00       	call   80104070 <pipeclose>
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
80100f8c:	68 9c 80 10 80       	push   $0x8010809c
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
80101065:	e9 a6 31 00 00       	jmp    80104210 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 a6 80 10 80       	push   $0x801080a6
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
801010f1:	e8 ca 27 00 00       	call   801038c0 <end_op>

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
8010111a:	e8 31 27 00 00       	call   80103850 <begin_op>
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
80101151:	e8 6a 27 00 00       	call   801038c0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 af 80 10 80       	push   $0x801080af
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
80101191:	e9 7a 2f 00 00       	jmp    80104110 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 b5 80 10 80       	push   $0x801080b5
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
801011b9:	8b 0d e4 29 11 80    	mov    0x801129e4,%ecx
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
801011dc:	03 05 fc 29 11 80    	add    0x801129fc,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 e4 29 11 80       	mov    0x801129e4,%eax
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
80101249:	39 05 e4 29 11 80    	cmp    %eax,0x801129e4
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 bf 80 10 80       	push   $0x801080bf
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
8010126d:	e8 be 27 00 00       	call   80103a30 <log_write>
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
80101295:	e8 66 3f 00 00       	call   80105200 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 8e 27 00 00       	call   80103a30 <log_write>
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
801012ca:	bb 54 2a 11 80       	mov    $0x80112a54,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 20 2a 11 80       	push   $0x80112a20
801012da:	e8 11 3e 00 00       	call   801050f0 <acquire>
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
801012fa:	81 fb 74 46 11 80    	cmp    $0x80114674,%ebx
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
8010131b:	81 fb 74 46 11 80    	cmp    $0x80114674,%ebx
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
80101342:	68 20 2a 11 80       	push   $0x80112a20
80101347:	e8 64 3e 00 00       	call   801051b0 <release>

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
8010136d:	68 20 2a 11 80       	push   $0x80112a20
      ip->ref++;
80101372:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101375:	e8 36 3e 00 00       	call   801051b0 <release>
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
80101387:	81 fb 74 46 11 80    	cmp    $0x80114674,%ebx
8010138d:	73 10                	jae    8010139f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101392:	85 c9                	test   %ecx,%ecx
80101394:	0f 8f 56 ff ff ff    	jg     801012f0 <iget+0x30>
8010139a:	e9 6e ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 d5 80 10 80       	push   $0x801080d5
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
80101425:	e8 06 26 00 00       	call   80103a30 <log_write>
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
8010146b:	68 e5 80 10 80       	push   $0x801080e5
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
801014a5:	e8 f6 3d 00 00       	call   801052a0 <memmove>
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
801014cc:	68 e4 29 11 80       	push   $0x801129e4
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 fc 29 11 80    	add    0x801129fc,%eax
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
8010151a:	e8 11 25 00 00       	call   80103a30 <log_write>
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
80101534:	68 f8 80 10 80       	push   $0x801080f8
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 60 2a 11 80       	mov    $0x80112a60,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 0b 81 10 80       	push   $0x8010810b
80101555:	68 20 2a 11 80       	push   $0x80112a20
8010155a:	e8 11 3a 00 00       	call   80104f70 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 12 81 10 80       	push   $0x80108112
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 b4 38 00 00       	call   80104e30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 80 46 11 80    	cmp    $0x80114680,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 e4 29 11 80       	push   $0x801129e4
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 fc 29 11 80    	pushl  0x801129fc
8010159d:	ff 35 f8 29 11 80    	pushl  0x801129f8
801015a3:	ff 35 f4 29 11 80    	pushl  0x801129f4
801015a9:	ff 35 f0 29 11 80    	pushl  0x801129f0
801015af:	ff 35 ec 29 11 80    	pushl  0x801129ec
801015b5:	ff 35 e8 29 11 80    	pushl  0x801129e8
801015bb:	ff 35 e4 29 11 80    	pushl  0x801129e4
801015c1:	68 b0 81 10 80       	push   $0x801081b0
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
801015f0:	83 3d ec 29 11 80 01 	cmpl   $0x1,0x801129ec
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
8010161f:	3b 3d ec 29 11 80    	cmp    0x801129ec,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 f8 29 11 80    	add    0x801129f8,%eax
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
8010165e:	e8 9d 3b 00 00       	call   80105200 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 bb 23 00 00       	call   80103a30 <log_write>
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
80101693:	68 18 81 10 80       	push   $0x80108118
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
801016b8:	03 05 f8 29 11 80    	add    0x801129f8,%eax
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
80101705:	e8 96 3b 00 00       	call   801052a0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 1e 23 00 00       	call   80103a30 <log_write>
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
8010173e:	68 20 2a 11 80       	push   $0x80112a20
80101743:	e8 a8 39 00 00       	call   801050f0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 20 2a 11 80 	movl   $0x80112a20,(%esp)
80101753:	e8 58 3a 00 00       	call   801051b0 <release>
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
80101786:	e8 e5 36 00 00       	call   80104e70 <acquiresleep>
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
801017a9:	03 05 f8 29 11 80    	add    0x801129f8,%eax
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
801017f8:	e8 a3 3a 00 00       	call   801052a0 <memmove>
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
8010181d:	68 30 81 10 80       	push   $0x80108130
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 2a 81 10 80       	push   $0x8010812a
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
80101857:	e8 b4 36 00 00       	call   80104f10 <holdingsleep>
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
80101873:	e9 58 36 00 00       	jmp    80104ed0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 3f 81 10 80       	push   $0x8010813f
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
801018a4:	e8 c7 35 00 00       	call   80104e70 <acquiresleep>
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
801018be:	e8 0d 36 00 00       	call   80104ed0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 20 2a 11 80 	movl   $0x80112a20,(%esp)
801018ca:	e8 21 38 00 00       	call   801050f0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 20 2a 11 80 	movl   $0x80112a20,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 c7 38 00 00       	jmp    801051b0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 20 2a 11 80       	push   $0x80112a20
801018f8:	e8 f3 37 00 00       	call   801050f0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 20 2a 11 80 	movl   $0x80112a20,(%esp)
80101907:	e8 a4 38 00 00       	call   801051b0 <release>
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
80101b07:	e8 94 37 00 00       	call   801052a0 <memmove>
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
80101b3a:	8b 04 c5 80 29 11 80 	mov    -0x7feed680(,%eax,8),%eax
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
80101c03:	e8 98 36 00 00       	call   801052a0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 20 1e 00 00       	call   80103a30 <log_write>
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
80101c4a:	8b 04 c5 84 29 11 80 	mov    -0x7feed67c(,%eax,8),%eax
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
80101ca2:	e8 69 36 00 00       	call   80105310 <strncmp>
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
80101d05:	e8 06 36 00 00       	call   80105310 <strncmp>
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
80101d4a:	68 59 81 10 80       	push   $0x80108159
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 47 81 10 80       	push   $0x80108147
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
80101d8a:	e8 41 27 00 00       	call   801044d0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 20 2a 11 80       	push   $0x80112a20
80101d9c:	e8 4f 33 00 00       	call   801050f0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 20 2a 11 80 	movl   $0x80112a20,(%esp)
80101dac:	e8 ff 33 00 00       	call   801051b0 <release>
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
80101e17:	e8 84 34 00 00       	call   801052a0 <memmove>
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
80101ea3:	e8 f8 33 00 00       	call   801052a0 <memmove>
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
80101fd5:	e8 86 33 00 00       	call   80105360 <strncpy>
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
80102013:	68 68 81 10 80       	push   $0x80108168
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 ea 8e 10 80       	push   $0x80108eea
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
80102085:	68 75 81 10 80       	push   $0x80108175
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
801020b3:	83 05 e0 29 11 80 01 	addl   $0x1,0x801129e0
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
801020da:	e8 c1 31 00 00       	call   801052a0 <memmove>
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
801020fa:	68 90 81 10 80       	push   $0x80108190
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
80102143:	83 05 00 2a 11 80 01 	addl   $0x1,0x80112a00
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
8010216a:	e8 31 31 00 00       	call   801052a0 <memmove>
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
80102192:	68 90 81 10 80       	push   $0x80108190
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
80102252:	68 0c 82 10 80       	push   $0x8010820c
80102257:	e8 34 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
8010225c:	83 ec 0c             	sub    $0xc,%esp
8010225f:	68 03 82 10 80       	push   $0x80108203
80102264:	e8 27 e1 ff ff       	call   80100390 <panic>
80102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102270 <ideinit>:
{
80102270:	f3 0f 1e fb          	endbr32 
80102274:	55                   	push   %ebp
80102275:	89 e5                	mov    %esp,%ebp
80102277:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010227a:	68 1e 82 10 80       	push   $0x8010821e
8010227f:	68 80 c5 10 80       	push   $0x8010c580
80102284:	e8 e7 2c 00 00       	call   80104f70 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102289:	58                   	pop    %eax
8010228a:	a1 e0 ad 13 80       	mov    0x8013ade0,%eax
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
801022da:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
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
8010230d:	68 80 c5 10 80       	push   $0x8010c580
80102312:	e8 d9 2d 00 00       	call   801050f0 <acquire>

  if((b = idequeue) == 0){
80102317:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 db                	test   %ebx,%ebx
80102322:	74 5f                	je     80102383 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102324:	8b 43 58             	mov    0x58(%ebx),%eax
80102327:	a3 64 c5 10 80       	mov    %eax,0x8010c564

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
8010236d:	e8 fe 28 00 00       	call   80104c70 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102372:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102377:	83 c4 10             	add    $0x10,%esp
8010237a:	85 c0                	test   %eax,%eax
8010237c:	74 05                	je     80102383 <ideintr+0x83>
    idestart(idequeue);
8010237e:	e8 1d fe ff ff       	call   801021a0 <idestart>
    release(&idelock);
80102383:	83 ec 0c             	sub    $0xc,%esp
80102386:	68 80 c5 10 80       	push   $0x8010c580
8010238b:	e8 20 2e 00 00       	call   801051b0 <release>

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
801023b2:	e8 59 2b 00 00       	call   80104f10 <holdingsleep>
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
801023d7:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801023dc:	85 c0                	test   %eax,%eax
801023de:	0f 84 93 00 00 00    	je     80102477 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023e4:	83 ec 0c             	sub    $0xc,%esp
801023e7:	68 80 c5 10 80       	push   $0x8010c580
801023ec:	e8 ff 2c 00 00       	call   801050f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023f1:	a1 64 c5 10 80       	mov    0x8010c564,%eax
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
80102416:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
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
80102433:	68 80 c5 10 80       	push   $0x8010c580
80102438:	53                   	push   %ebx
80102439:	e8 72 26 00 00       	call   80104ab0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010243e:	8b 03                	mov    (%ebx),%eax
80102440:	83 c4 10             	add    $0x10,%esp
80102443:	83 e0 06             	and    $0x6,%eax
80102446:	83 f8 02             	cmp    $0x2,%eax
80102449:	75 e5                	jne    80102430 <iderw+0x90>
  }


  release(&idelock);
8010244b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102455:	c9                   	leave  
  release(&idelock);
80102456:	e9 55 2d 00 00       	jmp    801051b0 <release>
8010245b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010245f:	90                   	nop
    idestart(b);
80102460:	89 d8                	mov    %ebx,%eax
80102462:	e8 39 fd ff ff       	call   801021a0 <idestart>
80102467:	eb b5                	jmp    8010241e <iderw+0x7e>
80102469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102470:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102475:	eb 9d                	jmp    80102414 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 4d 82 10 80       	push   $0x8010824d
8010247f:	e8 0c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102484:	83 ec 0c             	sub    $0xc,%esp
80102487:	68 38 82 10 80       	push   $0x80108238
8010248c:	e8 ff de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102491:	83 ec 0c             	sub    $0xc,%esp
80102494:	68 22 82 10 80       	push   $0x80108222
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
801024a5:	c7 05 74 46 11 80 00 	movl   $0xfec00000,0x80114674
801024ac:	00 c0 fe 
{
801024af:	89 e5                	mov    %esp,%ebp
801024b1:	56                   	push   %esi
801024b2:	53                   	push   %ebx
  ioapic->reg = reg;
801024b3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024ba:	00 00 00 
  return ioapic->data;
801024bd:	8b 15 74 46 11 80    	mov    0x80114674,%edx
801024c3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024c6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024cc:	8b 0d 74 46 11 80    	mov    0x80114674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024d2:	0f b6 15 40 a8 13 80 	movzbl 0x8013a840,%edx
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
801024ee:	68 6c 82 10 80       	push   $0x8010826c
801024f3:	e8 b8 e1 ff ff       	call   801006b0 <cprintf>
801024f8:	8b 0d 74 46 11 80    	mov    0x80114674,%ecx
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
80102514:	8b 0d 74 46 11 80    	mov    0x80114674,%ecx
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
8010252e:	8b 0d 74 46 11 80    	mov    0x80114674,%ecx
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
80102555:	8b 0d 74 46 11 80    	mov    0x80114674,%ecx
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
80102569:	8b 0d 74 46 11 80    	mov    0x80114674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010256f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102572:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102575:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102578:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010257a:	a1 74 46 11 80       	mov    0x80114674,%eax
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
80102594:	55                   	push   %ebp
80102595:	89 e5                	mov    %esp,%ebp
80102597:	56                   	push   %esi
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
8010259b:	53                   	push   %ebx
8010259c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = from; i <= to;i++){
8010259f:	39 f3                	cmp    %esi,%ebx
801025a1:	7f 2c                	jg     801025cf <print_bitmap+0x3f>
801025a3:	83 c6 01             	add    $0x1,%esi
801025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ad:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("bitmap[%d]=%d\n", i, bitmap[i]);
801025b0:	83 ec 04             	sub    $0x4,%esp
801025b3:	ff 34 9d c0 46 11 80 	pushl  -0x7feeb940(,%ebx,4)
801025ba:	53                   	push   %ebx
  for (int i = from; i <= to;i++){
801025bb:	83 c3 01             	add    $0x1,%ebx
    cprintf("bitmap[%d]=%d\n", i, bitmap[i]);
801025be:	68 9e 82 10 80       	push   $0x8010829e
801025c3:	e8 e8 e0 ff ff       	call   801006b0 <cprintf>
  for (int i = from; i <= to;i++){
801025c8:	83 c4 10             	add    $0x10,%esp
801025cb:	39 f3                	cmp    %esi,%ebx
801025cd:	75 e1                	jne    801025b0 <print_bitmap+0x20>
  }
}
801025cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d2:	5b                   	pop    %ebx
801025d3:	5e                   	pop    %esi
801025d4:	5d                   	pop    %ebp
801025d5:	c3                   	ret    
801025d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025dd:	8d 76 00             	lea    0x0(%esi),%esi

801025e0 <change_bitmap>:

void change_bitmap(int idx, int val){
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
801025e8:	53                   	push   %ebx
801025e9:	8b 75 08             	mov    0x8(%ebp),%esi
801025ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  cprintf("change_bitmap: %d %d\n", idx, val);
801025ef:	83 ec 04             	sub    $0x4,%esp
801025f2:	53                   	push   %ebx
801025f3:	56                   	push   %esi
801025f4:	68 ad 82 10 80       	push   $0x801082ad
801025f9:	e8 b2 e0 ff ff       	call   801006b0 <cprintf>
  bitmap[idx] = val;
801025fe:	89 1c b5 c0 46 11 80 	mov    %ebx,-0x7feeb940(,%esi,4)
  for (int i = from; i <= to;i++){
80102605:	83 c4 10             	add    $0x10,%esp
80102608:	83 fe fd             	cmp    $0xfffffffd,%esi
8010260b:	7c 2a                	jl     80102637 <change_bitmap+0x57>
8010260d:	83 c6 04             	add    $0x4,%esi
80102610:	31 db                	xor    %ebx,%ebx
80102612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("bitmap[%d]=%d\n", i, bitmap[i]);
80102618:	83 ec 04             	sub    $0x4,%esp
8010261b:	ff 34 9d c0 46 11 80 	pushl  -0x7feeb940(,%ebx,4)
80102622:	53                   	push   %ebx
  for (int i = from; i <= to;i++){
80102623:	83 c3 01             	add    $0x1,%ebx
    cprintf("bitmap[%d]=%d\n", i, bitmap[i]);
80102626:	68 9e 82 10 80       	push   $0x8010829e
8010262b:	e8 80 e0 ff ff       	call   801006b0 <cprintf>
  for (int i = from; i <= to;i++){
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	39 f3                	cmp    %esi,%ebx
80102635:	75 e1                	jne    80102618 <change_bitmap+0x38>
  print_bitmap(0, idx + 3);
}
80102637:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010263a:	5b                   	pop    %ebx
8010263b:	5e                   	pop    %esi
8010263c:	5d                   	pop    %ebp
8010263d:	c3                   	ret    
8010263e:	66 90                	xchg   %ax,%ax

80102640 <get_available_bitmap>:

int get_available_bitmap(){ // failed, return -1;
80102640:	f3 0f 1e fb          	endbr32 
80102644:	55                   	push   %ebp
80102645:	89 e5                	mov    %esp,%ebp
80102647:	53                   	push   %ebx
  for (int i = from; i <= to;i++){
80102648:	31 db                	xor    %ebx,%ebx
int get_available_bitmap(){ // failed, return -1;
8010264a:	83 ec 10             	sub    $0x10,%esp
  cprintf("get_available_bitmap: started\n");
8010264d:	68 60 84 10 80       	push   $0x80108460
80102652:	e8 59 e0 ff ff       	call   801006b0 <cprintf>
80102657:	83 c4 10             	add    $0x10,%esp
8010265a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("bitmap[%d]=%d\n", i, bitmap[i]);
80102660:	83 ec 04             	sub    $0x4,%esp
80102663:	ff 34 9d c0 46 11 80 	pushl  -0x7feeb940(,%ebx,4)
8010266a:	53                   	push   %ebx
  for (int i = from; i <= to;i++){
8010266b:	83 c3 01             	add    $0x1,%ebx
    cprintf("bitmap[%d]=%d\n", i, bitmap[i]);
8010266e:	68 9e 82 10 80       	push   $0x8010829e
80102673:	e8 38 e0 ff ff       	call   801006b0 <cprintf>
  for (int i = from; i <= to;i++){
80102678:	83 c4 10             	add    $0x10,%esp
8010267b:	83 fb 0c             	cmp    $0xc,%ebx
8010267e:	75 e0                	jne    80102660 <get_available_bitmap+0x20>
  print_bitmap(0,11);
  for (int i = 0; i < BITMAP_SIZE;i++){
80102680:	31 db                	xor    %ebx,%ebx
80102682:	eb 0f                	jmp    80102693 <get_available_bitmap+0x53>
80102684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102688:	83 c3 01             	add    $0x1,%ebx
8010268b:	81 fb ff 7f 00 00    	cmp    $0x7fff,%ebx
80102691:	74 2d                	je     801026c0 <get_available_bitmap+0x80>
    if(bitmap[i]==0){
80102693:	8b 04 9d c0 46 11 80 	mov    -0x7feeb940(,%ebx,4),%eax
8010269a:	85 c0                	test   %eax,%eax
8010269c:	75 ea                	jne    80102688 <get_available_bitmap+0x48>
      cprintf("get_available_bitmap: returning %d\n", i);
8010269e:	83 ec 08             	sub    $0x8,%esp
801026a1:	53                   	push   %ebx
801026a2:	68 80 84 10 80       	push   $0x80108480
801026a7:	e8 04 e0 ff ff       	call   801006b0 <cprintf>
      return i;
    }
  }
  cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
  return -1; // NOT FOUND
}
801026ac:	89 d8                	mov    %ebx,%eax
      return i;
801026ae:	83 c4 10             	add    $0x10,%esp
}
801026b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b4:	c9                   	leave  
801026b5:	c3                   	ret    
801026b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026bd:	8d 76 00             	lea    0x0(%esi),%esi
  cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
801026c0:	83 ec 0c             	sub    $0xc,%esp
  return -1; // NOT FOUND
801026c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  cprintf("get_available_bitmap: empty bitmap NOT FOUND\n");
801026c8:	68 a4 84 10 80       	push   $0x801084a4
801026cd:	e8 de df ff ff       	call   801006b0 <cprintf>
}
801026d2:	89 d8                	mov    %ebx,%eax
  return -1; // NOT FOUND
801026d4:	83 c4 10             	add    $0x10,%esp
}
801026d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026da:	c9                   	leave  
801026db:	c3                   	ret    
801026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026e0 <is_struct_page_available>:

int is_struct_page_available(struct page* node){
801026e0:	f3 0f 1e fb          	endbr32 
801026e4:	55                   	push   %ebp
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
    return 1;
  return 0;
801026e5:	31 c0                	xor    %eax,%eax
int is_struct_page_available(struct page* node){
801026e7:	89 e5                	mov    %esp,%ebp
801026e9:	8b 55 08             	mov    0x8(%ebp),%edx
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
801026ec:	8b 4a 0c             	mov    0xc(%edx),%ecx
801026ef:	85 c9                	test   %ecx,%ecx
801026f1:	74 05                	je     801026f8 <is_struct_page_available+0x18>
}
801026f3:	5d                   	pop    %ebp
801026f4:	c3                   	ret    
801026f5:	8d 76 00             	lea    0x0(%esi),%esi
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
801026f8:	8b 4a 08             	mov    0x8(%edx),%ecx
801026fb:	85 c9                	test   %ecx,%ecx
801026fd:	75 f4                	jne    801026f3 <is_struct_page_available+0x13>
801026ff:	8b 0a                	mov    (%edx),%ecx
80102701:	85 c9                	test   %ecx,%ecx
80102703:	75 ee                	jne    801026f3 <is_struct_page_available+0x13>
80102705:	8b 52 04             	mov    0x4(%edx),%edx
80102708:	31 c0                	xor    %eax,%eax
}
8010270a:	5d                   	pop    %ebp
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
8010270b:	85 d2                	test   %edx,%edx
8010270d:	0f 94 c0             	sete   %al
}
80102710:	c3                   	ret    
80102711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271f:	90                   	nop

80102720 <get_available_linked_list>:

int get_available_linked_list(){
80102720:	f3 0f 1e fb          	endbr32 
  // cprintf("get_available_linked_list called %d\n",global_i++);
  for (int i = 0; i < LRU_LENGTH;i++){
80102724:	31 c0                	xor    %eax,%eax
80102726:	eb 12                	jmp    8010273a <get_available_linked_list+0x1a>
80102728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272f:	90                   	nop
80102730:	83 c0 01             	add    $0x1,%eax
80102733:	3d 00 06 00 00       	cmp    $0x600,%eax
80102738:	74 36                	je     80102770 <get_available_linked_list+0x50>
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
8010273a:	89 c2                	mov    %eax,%edx
8010273c:	c1 e2 04             	shl    $0x4,%edx
8010273f:	8b 8a cc 46 13 80    	mov    -0x7fecb934(%edx),%ecx
80102745:	85 c9                	test   %ecx,%ecx
80102747:	75 e7                	jne    80102730 <get_available_linked_list+0x10>
80102749:	8b 8a c8 46 13 80    	mov    -0x7fecb938(%edx),%ecx
8010274f:	85 c9                	test   %ecx,%ecx
80102751:	75 dd                	jne    80102730 <get_available_linked_list+0x10>
80102753:	8b 8a c0 46 13 80    	mov    -0x7fecb940(%edx),%ecx
80102759:	85 c9                	test   %ecx,%ecx
8010275b:	75 d3                	jne    80102730 <get_available_linked_list+0x10>
8010275d:	8b 92 c4 46 13 80    	mov    -0x7fecb93c(%edx),%edx
80102763:	85 d2                	test   %edx,%edx
80102765:	75 c9                	jne    80102730 <get_available_linked_list+0x10>
    }
  }
  // cprintf("get_available_linked_list: NO AVAILABLE LINKED LIST\n");
  panic("get_available_linked_list: NO AVAILABLE LINKED LIST\n");
  return -1;
}
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
int get_available_linked_list(){
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 14             	sub    $0x14,%esp
  panic("get_available_linked_list: NO AVAILABLE LINKED LIST\n");
80102776:	68 d4 84 10 80       	push   $0x801084d4
8010277b:	e8 10 dc ff ff       	call   80100390 <panic>

80102780 <init_lru>:

void init_lru(){
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 10             	sub    $0x10,%esp
  cprintf("init_lru called %d\n",global_i++);
8010278a:	a1 cc a6 13 80       	mov    0x8013a6cc,%eax
8010278f:	50                   	push   %eax
80102790:	8d 50 01             	lea    0x1(%eax),%edx
80102793:	68 c3 82 10 80       	push   $0x801082c3
80102798:	89 15 cc a6 13 80    	mov    %edx,0x8013a6cc
8010279e:	e8 0d df ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < LRU_LENGTH; i++){
801027a3:	b8 c0 46 13 80       	mov    $0x801346c0,%eax
801027a8:	83 c4 10             	add    $0x10,%esp
801027ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027af:	90                   	nop
    linked_list[i].next = 0;
801027b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    linked_list[i].prev = 0;
801027b6:	83 c0 10             	add    $0x10,%eax
801027b9:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    linked_list[i].pgdir = 0;
801027c0:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    linked_list[i].vaddr = 0;
801027c7:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (int i = 0; i < LRU_LENGTH; i++){
801027ce:	3d c0 a6 13 80       	cmp    $0x8013a6c0,%eax
801027d3:	75 db                	jne    801027b0 <init_lru+0x30>
  }
  head = 0;
801027d5:	c7 05 c0 a6 13 80 00 	movl   $0x0,0x8013a6c0
801027dc:	00 00 00 
  num_free_pages = LRU_LENGTH;
801027df:	c7 05 54 a7 13 80 00 	movl   $0x600,0x8013a754
801027e6:	06 00 00 
  num_lru_pages = 0;
801027e9:	c7 05 c4 a6 13 80 00 	movl   $0x0,0x8013a6c4
801027f0:	00 00 00 
}
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    
801027f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102800 <print_linked_list>:

void print_linked_list(int sig){
80102800:	f3 0f 1e fb          	endbr32 
80102804:	55                   	push   %ebp
80102805:	89 e5                	mov    %esp,%ebp
80102807:	57                   	push   %edi
80102808:	56                   	push   %esi
80102809:	53                   	push   %ebx
8010280a:	83 ec 18             	sub    $0x18,%esp
8010280d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("print_linked_list START\n");
80102810:	68 d7 82 10 80       	push   $0x801082d7
80102815:	e8 96 de ff ff       	call   801006b0 <cprintf>
  if(sig!=10)
8010281a:	83 c4 10             	add    $0x10,%esp
8010281d:	83 fb 0a             	cmp    $0xa,%ebx
80102820:	74 0e                	je     80102830 <print_linked_list+0x30>
      cprintf(" ===> HEAD");
    }
    cprintf("\n");
  }
  cprintf("print_linked_list END\n\n");
}
80102822:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102825:	5b                   	pop    %ebx
80102826:	5e                   	pop    %esi
80102827:	5f                   	pop    %edi
80102828:	5d                   	pop    %ebp
80102829:	c3                   	ret    
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cprintf("print_linked_list START2\n");
80102830:	83 ec 0c             	sub    $0xc,%esp
80102833:	68 f0 82 10 80       	push   $0x801082f0
80102838:	e8 73 de ff ff       	call   801006b0 <cprintf>
  if(num_lru_pages==0)
8010283d:	a1 c4 a6 13 80       	mov    0x8013a6c4,%eax
80102842:	83 c4 10             	add    $0x10,%esp
80102845:	85 c0                	test   %eax,%eax
80102847:	74 d9                	je     80102822 <print_linked_list+0x22>
  cprintf("print_linked_list START3\n");
80102849:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num_lru_pages+3;i++){
8010284c:	31 f6                	xor    %esi,%esi
8010284e:	bb c0 46 13 80       	mov    $0x801346c0,%ebx
  cprintf("print_linked_list START3\n");
80102853:	68 0a 83 10 80       	push   $0x8010830a
80102858:	e8 53 de ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num_lru_pages+3;i++){
8010285d:	83 c4 10             	add    $0x10,%esp
80102860:	83 3d c4 a6 13 80 fe 	cmpl   $0xfffffffe,0x8013a6c4
80102867:	0f 8d a9 00 00 00    	jge    80102916 <print_linked_list+0x116>
8010286d:	e9 f6 00 00 00       	jmp    80102968 <print_linked_list+0x168>
80102872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("print_linked_list START4\n");
80102878:	83 ec 0c             	sub    $0xc,%esp
8010287b:	68 3c 83 10 80       	push   $0x8010833c
80102880:	e8 2b de ff ff       	call   801006b0 <cprintf>
    cprintf("print_linked_list START5\n");
80102885:	c7 04 24 56 83 10 80 	movl   $0x80108356,(%esp)
8010288c:	e8 1f de ff ff       	call   801006b0 <cprintf>
    cprintf(">>>linked_list[%d/%d]: cur->pgdir=%p | cur->vaddr=%p | cur->prev=%p | cur=%p | cur->next=%p\n", i, num_lru_pages, cur->pgdir, cur->vaddr, cur->prev, cur, cur->next);
80102891:	ff 33                	pushl  (%ebx)
80102893:	53                   	push   %ebx
80102894:	ff 73 04             	pushl  0x4(%ebx)
80102897:	ff 73 0c             	pushl  0xc(%ebx)
8010289a:	ff 73 08             	pushl  0x8(%ebx)
8010289d:	ff 35 c4 a6 13 80    	pushl  0x8013a6c4
801028a3:	57                   	push   %edi
801028a4:	68 0c 85 10 80       	push   $0x8010850c
801028a9:	e8 02 de ff ff       	call   801006b0 <cprintf>
    pte_t *pte = walkpgdir(cur->pgdir, (void *)cur->vaddr, 1);
801028ae:	83 c4 2c             	add    $0x2c,%esp
801028b1:	6a 01                	push   $0x1
801028b3:	ff 73 0c             	pushl  0xc(%ebx)
801028b6:	ff 73 08             	pushl  0x8(%ebx)
801028b9:	e8 92 4d 00 00       	call   80107650 <walkpgdir>
    cprintf("print_linked_list START6\n");
801028be:	c7 04 24 70 83 10 80 	movl   $0x80108370,(%esp)
    pte_t *pte = walkpgdir(cur->pgdir, (void *)cur->vaddr, 1);
801028c5:	89 c7                	mov    %eax,%edi
    cprintf("print_linked_list START6\n");
801028c7:	e8 e4 dd ff ff       	call   801006b0 <cprintf>
    cprintf(">>>linked_list[%d/%d]: cur->pgdir=%p | cur->vaddr=%p | *pte=%p | cur->prev=%p | cur=%p | cur->next=%p",\
801028cc:	58                   	pop    %eax
801028cd:	ff 33                	pushl  (%ebx)
801028cf:	53                   	push   %ebx
801028d0:	ff 73 04             	pushl  0x4(%ebx)
801028d3:	ff 37                	pushl  (%edi)
801028d5:	ff 73 0c             	pushl  0xc(%ebx)
801028d8:	ff 73 08             	pushl  0x8(%ebx)
801028db:	ff 35 c4 a6 13 80    	pushl  0x8013a6c4
801028e1:	56                   	push   %esi
801028e2:	68 6c 85 10 80       	push   $0x8010856c
801028e7:	e8 c4 dd ff ff       	call   801006b0 <cprintf>
    if(cur == head){
801028ec:	83 c4 30             	add    $0x30,%esp
801028ef:	3b 1d c0 a6 13 80    	cmp    0x8013a6c0,%ebx
801028f5:	74 59                	je     80102950 <print_linked_list+0x150>
    cprintf("\n");
801028f7:	83 ec 0c             	sub    $0xc,%esp
801028fa:	68 3a 83 10 80       	push   $0x8010833a
801028ff:	e8 ac dd ff ff       	call   801006b0 <cprintf>
80102904:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < num_lru_pages+3;i++){
80102907:	a1 c4 a6 13 80       	mov    0x8013a6c4,%eax
8010290c:	83 c3 10             	add    $0x10,%ebx
8010290f:	83 c0 02             	add    $0x2,%eax
80102912:	39 f0                	cmp    %esi,%eax
80102914:	7c 52                	jl     80102968 <print_linked_list+0x168>
  if(node->vaddr==0 && node->pgdir==0 && node->next==0 && node->prev==0)
80102916:	8b 43 0c             	mov    0xc(%ebx),%eax
80102919:	89 f7                	mov    %esi,%edi
8010291b:	83 c6 01             	add    $0x1,%esi
8010291e:	85 c0                	test   %eax,%eax
80102920:	0f 85 52 ff ff ff    	jne    80102878 <print_linked_list+0x78>
80102926:	8b 43 08             	mov    0x8(%ebx),%eax
80102929:	85 c0                	test   %eax,%eax
8010292b:	0f 85 47 ff ff ff    	jne    80102878 <print_linked_list+0x78>
80102931:	8b 0b                	mov    (%ebx),%ecx
80102933:	85 c9                	test   %ecx,%ecx
80102935:	0f 85 3d ff ff ff    	jne    80102878 <print_linked_list+0x78>
8010293b:	8b 53 04             	mov    0x4(%ebx),%edx
8010293e:	85 d2                	test   %edx,%edx
80102940:	0f 85 32 ff ff ff    	jne    80102878 <print_linked_list+0x78>
80102946:	eb bf                	jmp    80102907 <print_linked_list+0x107>
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop
      cprintf(" ===> HEAD");
80102950:	83 ec 0c             	sub    $0xc,%esp
80102953:	68 8a 83 10 80       	push   $0x8010838a
80102958:	e8 53 dd ff ff       	call   801006b0 <cprintf>
8010295d:	83 c4 10             	add    $0x10,%esp
80102960:	eb 95                	jmp    801028f7 <print_linked_list+0xf7>
80102962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cprintf("print_linked_list END\n\n");
80102968:	c7 45 08 24 83 10 80 	movl   $0x80108324,0x8(%ebp)
}
8010296f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102972:	5b                   	pop    %ebx
80102973:	5e                   	pop    %esi
80102974:	5f                   	pop    %edi
80102975:	5d                   	pop    %ebp
  cprintf("print_linked_list END\n\n");
80102976:	e9 35 dd ff ff       	jmp    801006b0 <cprintf>
8010297b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010297f:	90                   	nop

80102980 <lru_append>:

// Achtung: use USER VIRTUAL ADDRESS
int lru_append(pde_t *pgdir, char* vaddr){ // head 의 next에 ll[idx], 즉 which를 pgdir, vaddr 값으로 append
80102980:	f3 0f 1e fb          	endbr32 
80102984:	55                   	push   %ebp
80102985:	89 e5                	mov    %esp,%ebp
80102987:	57                   	push   %edi
80102988:	56                   	push   %esi
80102989:	53                   	push   %ebx
8010298a:	83 ec 0c             	sub    $0xc,%esp
  int idx = get_available_linked_list(); // get vaddr->0
8010298d:	e8 8e fd ff ff       	call   80102720 <get_available_linked_list>
  // cprintf("lru_append: idx = %d\n", idx);
  struct page *insert = &(linked_list[idx]);

  cprintf("lru_append: started %p %p, insert at idx=%d\n", pgdir, vaddr,idx);
80102992:	50                   	push   %eax
  struct page *insert = &(linked_list[idx]);
80102993:	89 c7                	mov    %eax,%edi
  int idx = get_available_linked_list(); // get vaddr->0
80102995:	89 c6                	mov    %eax,%esi
  cprintf("lru_append: started %p %p, insert at idx=%d\n", pgdir, vaddr,idx);
80102997:	ff 75 0c             	pushl  0xc(%ebp)
  struct page *insert = &(linked_list[idx]);
8010299a:	c1 e7 04             	shl    $0x4,%edi
  cprintf("lru_append: started %p %p, insert at idx=%d\n", pgdir, vaddr,idx);
8010299d:	ff 75 08             	pushl  0x8(%ebp)
801029a0:	68 d4 85 10 80       	push   $0x801085d4
801029a5:	e8 06 dd ff ff       	call   801006b0 <cprintf>
  if(num_free_pages == 0){ // FULL
801029aa:	a1 54 a7 13 80       	mov    0x8013a754,%eax
801029af:	83 c4 10             	add    $0x10,%esp
801029b2:	85 c0                	test   %eax,%eax
801029b4:	0f 84 cf 00 00 00    	je     80102a89 <lru_append+0x109>
    panic("PANIC: lru_append: num_free_pages == 0");
    return -1;
  }

  insert->pgdir = pgdir;
801029ba:	8b 45 08             	mov    0x8(%ebp),%eax
801029bd:	8d 9f c0 46 13 80    	lea    -0x7fecb940(%edi),%ebx
  insert->vaddr = vaddr;
  if(num_lru_pages == 0){ // head is NULL -> 0 entry
801029c3:	8b 0d c4 a6 13 80    	mov    0x8013a6c4,%ecx
  insert->pgdir = pgdir;
801029c9:	89 43 08             	mov    %eax,0x8(%ebx)
  insert->vaddr = vaddr;
801029cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801029cf:	89 43 0c             	mov    %eax,0xc(%ebx)
  if(num_lru_pages == 0){ // head is NULL -> 0 entry
801029d2:	85 c9                	test   %ecx,%ecx
801029d4:	0f 84 8e 00 00 00    	je     80102a68 <lru_append+0xe8>
    cprintf("lru_append: num_lru_pages == 0\n");
    head = insert;
    head->prev = head;
    head->next = head;
  }
  else if(num_lru_pages == 1){
801029da:	83 f9 01             	cmp    $0x1,%ecx
801029dd:	74 51                	je     80102a30 <lru_append+0xb0>

    head = insert;
  }
  else
  {
    cprintf("lru_append: num_lru_pages == %d\n", num_lru_pages);
801029df:	83 ec 08             	sub    $0x8,%esp
801029e2:	51                   	push   %ecx
801029e3:	68 6c 86 10 80       	push   $0x8010866c
801029e8:	e8 c3 dc ff ff       	call   801006b0 <cprintf>
    struct page *tmp;
    tmp = head->next; // save 3's address
801029ed:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
    head->next = insert; // 2->2.5
    insert->next = tmp; // 2.5->3
    insert->prev = head; // 2->2.5
    tmp->prev = insert; // 2.5<-3

    head = insert;
801029f2:	83 c4 10             	add    $0x10,%esp
    tmp = head->next; // save 3's address
801029f5:	8b 08                	mov    (%eax),%ecx
    head->next = insert; // 2->2.5
801029f7:	89 18                	mov    %ebx,(%eax)
    insert->prev = head; // 2->2.5
801029f9:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
    head = insert;
801029fe:	89 1d c0 a6 13 80    	mov    %ebx,0x8013a6c0
    insert->next = tmp; // 2.5->3
80102a04:	89 8f c0 46 13 80    	mov    %ecx,-0x7fecb940(%edi)
    insert->prev = head; // 2->2.5
80102a0a:	89 43 04             	mov    %eax,0x4(%ebx)
    tmp->prev = insert; // 2.5<-3
80102a0d:	89 59 04             	mov    %ebx,0x4(%ecx)
  }
  num_free_pages--;
80102a10:	83 2d 54 a7 13 80 01 	subl   $0x1,0x8013a754
  // if(num_lru_pages>1)
    // print_linked_list(10);
  /* cprintf("lru_append: %d/%dth: cur->pgdir=%p | cur->vaddr=%p | cur->prev=%p | cur=%p | cur->next=%p\n", \
   num_lru_pages, num_free_pages, insert->pgdir, insert->vaddr, insert->prev, insert, insert->next); */
  return idx;
}
80102a17:	89 f0                	mov    %esi,%eax
  num_lru_pages++;
80102a19:	83 05 c4 a6 13 80 01 	addl   $0x1,0x8013a6c4
}
80102a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a23:	5b                   	pop    %ebx
80102a24:	5e                   	pop    %esi
80102a25:	5f                   	pop    %edi
80102a26:	5d                   	pop    %ebp
80102a27:	c3                   	ret    
80102a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2f:	90                   	nop
    cprintf("lru_append: num_lru_pages == 1\n");
80102a30:	83 ec 0c             	sub    $0xc,%esp
80102a33:	68 4c 86 10 80       	push   $0x8010864c
80102a38:	e8 73 dc ff ff       	call   801006b0 <cprintf>
    head->next = insert;
80102a3d:	8b 0d c0 a6 13 80    	mov    0x8013a6c0,%ecx
80102a43:	83 c4 10             	add    $0x10,%esp
80102a46:	89 19                	mov    %ebx,(%ecx)
    head->prev = insert;
80102a48:	8b 0d c0 a6 13 80    	mov    0x8013a6c0,%ecx
    head = insert;
80102a4e:	89 1d c0 a6 13 80    	mov    %ebx,0x8013a6c0
    head->prev = insert;
80102a54:	89 59 04             	mov    %ebx,0x4(%ecx)
    insert->prev = head;
80102a57:	89 4b 04             	mov    %ecx,0x4(%ebx)
    insert->next = head;
80102a5a:	89 8f c0 46 13 80    	mov    %ecx,-0x7fecb940(%edi)
    head = insert;
80102a60:	eb ae                	jmp    80102a10 <lru_append+0x90>
80102a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("lru_append: num_lru_pages == 0\n");
80102a68:	83 ec 0c             	sub    $0xc,%esp
80102a6b:	68 2c 86 10 80       	push   $0x8010862c
80102a70:	e8 3b dc ff ff       	call   801006b0 <cprintf>
    head = insert;
80102a75:	89 1d c0 a6 13 80    	mov    %ebx,0x8013a6c0
    head->prev = head;
80102a7b:	83 c4 10             	add    $0x10,%esp
80102a7e:	89 5b 04             	mov    %ebx,0x4(%ebx)
    head->next = head;
80102a81:	89 9f c0 46 13 80    	mov    %ebx,-0x7fecb940(%edi)
80102a87:	eb 87                	jmp    80102a10 <lru_append+0x90>
    panic("PANIC: lru_append: num_free_pages == 0");
80102a89:	83 ec 0c             	sub    $0xc,%esp
80102a8c:	68 04 86 10 80       	push   $0x80108604
80102a91:	e8 fa d8 ff ff       	call   80100390 <panic>
80102a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a9d:	8d 76 00             	lea    0x0(%esi),%esi

80102aa0 <lru_delete>:

void lru_delete(struct page* node){ // lru head 라면 next 를 head로
80102aa0:	f3 0f 1e fb          	endbr32 
80102aa4:	55                   	push   %ebp
80102aa5:	89 e5                	mov    %esp,%ebp
80102aa7:	53                   	push   %ebx
80102aa8:	83 ec 08             	sub    $0x8,%esp
80102aab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("lru_delete: %d/%dth %p %p %p %p delete start\n", num_lru_pages, num_free_pages, node->pgdir, node->vaddr, node->prev, node->next);
80102aae:	ff 33                	pushl  (%ebx)
80102ab0:	ff 73 04             	pushl  0x4(%ebx)
80102ab3:	ff 73 0c             	pushl  0xc(%ebx)
80102ab6:	ff 73 08             	pushl  0x8(%ebx)
80102ab9:	ff 35 54 a7 13 80    	pushl  0x8013a754
80102abf:	ff 35 c4 a6 13 80    	pushl  0x8013a6c4
80102ac5:	68 90 86 10 80       	push   $0x80108690
80102aca:	e8 e1 db ff ff       	call   801006b0 <cprintf>
  if (num_lru_pages == 0)
80102acf:	a1 c4 a6 13 80       	mov    0x8013a6c4,%eax
80102ad4:	83 c4 20             	add    $0x20,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 84 ce 00 00 00    	je     80102bad <lru_delete+0x10d>
  { // 0 entry
    panic("lru_delete: Tried to delete when NO ENTRY here\n");
    return;
  }
  if(node == head){ // 만일 delete하는 노드가 head 라면 head 를 next 로 승계
80102adf:	39 1d c0 a6 13 80    	cmp    %ebx,0x8013a6c0
80102ae5:	0f 84 b5 00 00 00    	je     80102ba0 <lru_delete+0x100>
    head = head->next;
  }
  if(num_lru_pages == 1){ // nokori == only head
80102aeb:	83 f8 01             	cmp    $0x1,%eax
80102aee:	0f 84 9c 00 00 00    	je     80102b90 <lru_delete+0xf0>
    head = 0;
  }
  else{
    node->prev->next = node->next;
80102af4:	8b 53 04             	mov    0x4(%ebx),%edx
80102af7:	8b 03                	mov    (%ebx),%eax
80102af9:	89 02                	mov    %eax,(%edx)
    node->next->prev = node->prev;
80102afb:	8b 53 04             	mov    0x4(%ebx),%edx
80102afe:	89 50 04             	mov    %edx,0x4(%eax)
80102b01:	a1 c4 a6 13 80       	mov    0x8013a6c4,%eax
  }
  num_free_pages++;
  num_lru_pages--;
  node->vaddr = 0;
  node->pgdir = 0;
  cprintf("lru_delete: ended1\n");
80102b06:	83 ec 0c             	sub    $0xc,%esp
  node->vaddr = 0;
80102b09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  num_lru_pages--;
80102b10:	83 e8 01             	sub    $0x1,%eax
  node->pgdir = 0;
80102b13:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  cprintf("lru_delete: ended1\n");
80102b1a:	68 95 83 10 80       	push   $0x80108395
  num_lru_pages--;
80102b1f:	a3 c4 a6 13 80       	mov    %eax,0x8013a6c4
  num_free_pages++;
80102b24:	83 05 54 a7 13 80 01 	addl   $0x1,0x8013a754
  cprintf("lru_delete: ended1\n");
80102b2b:	e8 80 db ff ff       	call   801006b0 <cprintf>
  node->next = 0;
80102b30:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  cprintf("lru_delete: ended2\n");
80102b36:	c7 04 24 a9 83 10 80 	movl   $0x801083a9,(%esp)
80102b3d:	e8 6e db ff ff       	call   801006b0 <cprintf>
  node->prev = 0;
80102b42:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  cprintf("lru_delete: ended3\n");
80102b49:	c7 04 24 bd 83 10 80 	movl   $0x801083bd,(%esp)
80102b50:	e8 5b db ff ff       	call   801006b0 <cprintf>
  // print_linked_list(10);
  cprintf("lru_delete: %d/%dth %p %p %p %p deleted successfully\n", num_lru_pages,num_free_pages, node->pgdir, node->vaddr, node->prev, node->next);
80102b55:	83 c4 0c             	add    $0xc,%esp
80102b58:	ff 33                	pushl  (%ebx)
80102b5a:	ff 73 04             	pushl  0x4(%ebx)
80102b5d:	ff 73 0c             	pushl  0xc(%ebx)
80102b60:	ff 73 08             	pushl  0x8(%ebx)
80102b63:	ff 35 54 a7 13 80    	pushl  0x8013a754
80102b69:	ff 35 c4 a6 13 80    	pushl  0x8013a6c4
80102b6f:	68 f0 86 10 80       	push   $0x801086f0
80102b74:	e8 37 db ff ff       	call   801006b0 <cprintf>
  cprintf("lru_delete: ended4\n");
80102b79:	c7 45 08 d1 83 10 80 	movl   $0x801083d1,0x8(%ebp)
  return;
}
80102b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  cprintf("lru_delete: ended4\n");
80102b83:	83 c4 20             	add    $0x20,%esp
}
80102b86:	c9                   	leave  
  cprintf("lru_delete: ended4\n");
80102b87:	e9 24 db ff ff       	jmp    801006b0 <cprintf>
80102b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    head = 0;
80102b90:	c7 05 c0 a6 13 80 00 	movl   $0x0,0x8013a6c0
80102b97:	00 00 00 
80102b9a:	e9 67 ff ff ff       	jmp    80102b06 <lru_delete+0x66>
80102b9f:	90                   	nop
    head = head->next;
80102ba0:	8b 13                	mov    (%ebx),%edx
80102ba2:	89 15 c0 a6 13 80    	mov    %edx,0x8013a6c0
80102ba8:	e9 3e ff ff ff       	jmp    80102aeb <lru_delete+0x4b>
    panic("lru_delete: Tried to delete when NO ENTRY here\n");
80102bad:	83 ec 0c             	sub    $0xc,%esp
80102bb0:	68 c0 86 10 80       	push   $0x801086c0
80102bb5:	e8 d6 d7 ff ff       	call   80100390 <panic>
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102bc0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v) // kmem.use_lock 해제할것
{ // kernel virtual memory
80102bc0:	f3 0f 1e fb          	endbr32 
80102bc4:	55                   	push   %ebp
80102bc5:	89 e5                	mov    %esp,%ebp
80102bc7:	57                   	push   %edi
80102bc8:	56                   	push   %esi
80102bc9:	53                   	push   %ebx
80102bca:	83 ec 1c             	sub    $0x1c,%esp
80102bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  struct run *r;
  // cprintf("kfree: just started, v=%p\n", v);

  if((uint)v % PGSIZE){
80102bd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102bd8:	0f 85 2d 01 00 00    	jne    80102d0b <kfree+0x14b>
    cprintf("PANIC1: virtual address is %p\n", v);
    panic("kfree");
  }
  if(v < end){
80102bde:	81 7d e0 88 d5 13 80 	cmpl   $0x8013d588,-0x20(%ebp)
80102be5:	0f 82 54 01 00 00    	jb     80102d3f <kfree+0x17f>
    cprintf("PANIC2: virtual address is %p\n", v);
    panic("kfree");
  }
  if(V2P(v) >= PHYSTOP){
80102beb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102bee:	05 00 00 00 80       	add    $0x80000000,%eax
80102bf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102bf6:	3d ff ff 5f 00       	cmp    $0x5fffff,%eax
80102bfb:	0f 87 23 01 00 00    	ja     80102d24 <kfree+0x164>
    cprintf("PANIC3: virtual address is %p\n", v);
    panic("kfree");
  }

  struct page *cur;
  for (int i = 0; i < num_lru_pages; i++){
80102c01:	8b 1d c4 a6 13 80    	mov    0x8013a6c4,%ebx
80102c07:	31 ff                	xor    %edi,%edi
80102c09:	85 db                	test   %ebx,%ebx
80102c0b:	7f 16                	jg     80102c23 <kfree+0x63>
80102c0d:	e9 8e 00 00 00       	jmp    80102ca0 <kfree+0xe0>
80102c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c18:	83 c7 01             	add    $0x1,%edi
80102c1b:	39 3d c4 a6 13 80    	cmp    %edi,0x8013a6c4
80102c21:	7e 7d                	jle    80102ca0 <kfree+0xe0>
    // cprintf("kfree: for loop start\n");
    cur = head;
80102c23:	8b 35 c0 a6 13 80    	mov    0x8013a6c0,%esi
    pte_t *pte = walkpgdir(cur->pgdir, cur->vaddr, 0);
80102c29:	83 ec 04             	sub    $0x4,%esp
80102c2c:	6a 00                	push   $0x0
80102c2e:	ff 76 0c             	pushl  0xc(%esi)
80102c31:	ff 76 08             	pushl  0x8(%esi)
80102c34:	e8 17 4a 00 00       	call   80107650 <walkpgdir>
80102c39:	89 c3                	mov    %eax,%ebx
    cprintf("kfree: V2P(%p)==%p ?= PTE_ADDR(%p)==%p\n", v, V2P(v), *pte, PTE_ADDR(*pte));
80102c3b:	8b 00                	mov    (%eax),%eax
80102c3d:	89 c1                	mov    %eax,%ecx
80102c3f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80102c45:	89 0c 24             	mov    %ecx,(%esp)
80102c48:	50                   	push   %eax
80102c49:	ff 75 e4             	pushl  -0x1c(%ebp)
80102c4c:	ff 75 e0             	pushl  -0x20(%ebp)
80102c4f:	68 88 87 10 80       	push   $0x80108788
80102c54:	e8 57 da ff ff       	call   801006b0 <cprintf>
    // uint pa = (((uint)pte & 0xFFFFF000)); // make physical addr from user.va
    // uint user_pa = (uint)pte >> 12;
    if (V2P(v) == PTE_ADDR(*pte)){ // if page struct's vaddr(user vaddr) points v(kern vaddr)
80102c59:	8b 03                	mov    (%ebx),%eax
80102c5b:	83 c4 20             	add    $0x20,%esp
80102c5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c63:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
80102c66:	75 b0                	jne    80102c18 <kfree+0x58>
      cprintf("kfree: LRU list also should be deleted\n");
80102c68:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num_lru_pages; i++){
80102c6b:	83 c7 01             	add    $0x1,%edi
      cprintf("kfree: LRU list also should be deleted\n");
80102c6e:	68 b0 87 10 80       	push   $0x801087b0
80102c73:	e8 38 da ff ff       	call   801006b0 <cprintf>
      lru_delete(cur);
80102c78:	89 34 24             	mov    %esi,(%esp)
80102c7b:	e8 20 fe ff ff       	call   80102aa0 <lru_delete>
      cprintf("kfree: LRU list deleted completed\n");
80102c80:	c7 04 24 d8 87 10 80 	movl   $0x801087d8,(%esp)
80102c87:	e8 24 da ff ff       	call   801006b0 <cprintf>
80102c8c:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < num_lru_pages; i++){
80102c8f:	39 3d c4 a6 13 80    	cmp    %edi,0x8013a6c4
80102c95:	7f 8c                	jg     80102c23 <kfree+0x63>
80102c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c9e:	66 90                	xchg   %ax,%ax
    }
  }

  // cprintf("kfree: for loop ended, before memset\n");
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ca0:	83 ec 04             	sub    $0x4,%esp
80102ca3:	68 00 10 00 00       	push   $0x1000
80102ca8:	6a 01                	push   $0x1
80102caa:	ff 75 e0             	pushl  -0x20(%ebp)
80102cad:	e8 4e 25 00 00       	call   80105200 <memset>

  if(kmem.use_lock)
80102cb2:	8b 15 b4 46 11 80    	mov    0x801146b4,%edx
80102cb8:	83 c4 10             	add    $0x10,%esp
80102cbb:	85 d2                	test   %edx,%edx
80102cbd:	75 21                	jne    80102ce0 <kfree+0x120>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102cbf:	a1 b8 46 11 80       	mov    0x801146b8,%eax
80102cc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102cc7:	89 02                	mov    %eax,(%edx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102cc9:	a1 b4 46 11 80       	mov    0x801146b4,%eax
  kmem.freelist = r;
80102cce:	89 15 b8 46 11 80    	mov    %edx,0x801146b8
  if(kmem.use_lock)
80102cd4:	85 c0                	test   %eax,%eax
80102cd6:	75 20                	jne    80102cf8 <kfree+0x138>
    release(&kmem.lock);
  // cprintf("kfree: successfully ended\n");
}
80102cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cdb:	5b                   	pop    %ebx
80102cdc:	5e                   	pop    %esi
80102cdd:	5f                   	pop    %edi
80102cde:	5d                   	pop    %ebp
80102cdf:	c3                   	ret    
    acquire(&kmem.lock);
80102ce0:	83 ec 0c             	sub    $0xc,%esp
80102ce3:	68 80 46 11 80       	push   $0x80114680
80102ce8:	e8 03 24 00 00       	call   801050f0 <acquire>
80102ced:	83 c4 10             	add    $0x10,%esp
80102cf0:	eb cd                	jmp    80102cbf <kfree+0xff>
80102cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102cf8:	c7 45 08 80 46 11 80 	movl   $0x80114680,0x8(%ebp)
}
80102cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d02:	5b                   	pop    %ebx
80102d03:	5e                   	pop    %esi
80102d04:	5f                   	pop    %edi
80102d05:	5d                   	pop    %ebp
    release(&kmem.lock);
80102d06:	e9 a5 24 00 00       	jmp    801051b0 <release>
    cprintf("PANIC1: virtual address is %p\n", v);
80102d0b:	57                   	push   %edi
80102d0c:	57                   	push   %edi
80102d0d:	50                   	push   %eax
80102d0e:	68 28 87 10 80       	push   $0x80108728
80102d13:	e8 98 d9 ff ff       	call   801006b0 <cprintf>
    panic("kfree");
80102d18:	c7 04 24 e5 83 10 80 	movl   $0x801083e5,(%esp)
80102d1f:	e8 6c d6 ff ff       	call   80100390 <panic>
    cprintf("PANIC3: virtual address is %p\n", v);
80102d24:	51                   	push   %ecx
80102d25:	51                   	push   %ecx
80102d26:	ff 75 e0             	pushl  -0x20(%ebp)
80102d29:	68 68 87 10 80       	push   $0x80108768
80102d2e:	e8 7d d9 ff ff       	call   801006b0 <cprintf>
    panic("kfree");
80102d33:	c7 04 24 e5 83 10 80 	movl   $0x801083e5,(%esp)
80102d3a:	e8 51 d6 ff ff       	call   80100390 <panic>
    cprintf("PANIC2: virtual address is %p\n", v);
80102d3f:	56                   	push   %esi
80102d40:	56                   	push   %esi
80102d41:	ff 75 e0             	pushl  -0x20(%ebp)
80102d44:	68 48 87 10 80       	push   $0x80108748
80102d49:	e8 62 d9 ff ff       	call   801006b0 <cprintf>
    panic("kfree");
80102d4e:	c7 04 24 e5 83 10 80 	movl   $0x801083e5,(%esp)
80102d55:	e8 36 d6 ff ff       	call   80100390 <panic>
80102d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102d60 <freerange>:
{
80102d60:	f3 0f 1e fb          	endbr32 
80102d64:	55                   	push   %ebp
80102d65:	89 e5                	mov    %esp,%ebp
80102d67:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d68:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d6e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d6f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102d75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102d81:	39 de                	cmp    %ebx,%esi
80102d83:	72 1f                	jb     80102da4 <freerange+0x44>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102d88:	83 ec 0c             	sub    $0xc,%esp
80102d8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102d97:	50                   	push   %eax
80102d98:	e8 23 fe ff ff       	call   80102bc0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d9d:	83 c4 10             	add    $0x10,%esp
80102da0:	39 f3                	cmp    %esi,%ebx
80102da2:	76 e4                	jbe    80102d88 <freerange+0x28>
}
80102da4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102da7:	5b                   	pop    %ebx
80102da8:	5e                   	pop    %esi
80102da9:	5d                   	pop    %ebp
80102daa:	c3                   	ret    
80102dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102daf:	90                   	nop

80102db0 <kinit1>:
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	56                   	push   %esi
80102db8:	53                   	push   %ebx
80102db9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102dbc:	83 ec 08             	sub    $0x8,%esp
80102dbf:	68 eb 83 10 80       	push   $0x801083eb
80102dc4:	68 80 46 11 80       	push   $0x80114680
80102dc9:	e8 a2 21 00 00       	call   80104f70 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102dce:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dd1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102dd4:	c7 05 b4 46 11 80 00 	movl   $0x0,0x801146b4
80102ddb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102dde:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102de4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102df0:	39 de                	cmp    %ebx,%esi
80102df2:	72 20                	jb     80102e14 <kinit1+0x64>
80102df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e07:	50                   	push   %eax
80102e08:	e8 b3 fd ff ff       	call   80102bc0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e0d:	83 c4 10             	add    $0x10,%esp
80102e10:	39 de                	cmp    %ebx,%esi
80102e12:	73 e4                	jae    80102df8 <kinit1+0x48>
}
80102e14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e17:	5b                   	pop    %ebx
80102e18:	5e                   	pop    %esi
80102e19:	5d                   	pop    %ebp
80102e1a:	c3                   	ret    
80102e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e1f:	90                   	nop

80102e20 <kinit2>:
{
80102e20:	f3 0f 1e fb          	endbr32 
80102e24:	55                   	push   %ebp
80102e25:	89 e5                	mov    %esp,%ebp
80102e27:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102e28:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102e2b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102e2e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102e2f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e35:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e41:	39 de                	cmp    %ebx,%esi
80102e43:	72 1f                	jb     80102e64 <kinit2+0x44>
80102e45:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102e48:	83 ec 0c             	sub    $0xc,%esp
80102e4b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e57:	50                   	push   %eax
80102e58:	e8 63 fd ff ff       	call   80102bc0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e5d:	83 c4 10             	add    $0x10,%esp
80102e60:	39 de                	cmp    %ebx,%esi
80102e62:	73 e4                	jae    80102e48 <kinit2+0x28>
  kmem.use_lock = 1;
80102e64:	c7 05 b4 46 11 80 01 	movl   $0x1,0x801146b4
80102e6b:	00 00 00 
}
80102e6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e71:	5b                   	pop    %ebx
80102e72:	5e                   	pop    %esi
80102e73:	5d                   	pop    %ebp
80102e74:	c3                   	ret    
80102e75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e80 <clock>:
  cprintf("SWAPOUT ENDED SUCCESSFULLY, returning %p\n", ret);
  return P2V(PTE_ADDR(*ret));
}

// my code
struct page* clock(){ // only select victim, not killing yet
80102e80:	f3 0f 1e fb          	endbr32 
80102e84:	55                   	push   %ebp
80102e85:	89 e5                	mov    %esp,%ebp
80102e87:	53                   	push   %ebx
80102e88:	83 ec 04             	sub    $0x4,%esp
  int finished = 0;
  struct page *ret;
  for (; !finished; head = head->prev)
  {
    if (!(head->vaddr)){
80102e8b:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
80102e90:	8b 50 0c             	mov    0xc(%eax),%edx
80102e93:	85 d2                	test   %edx,%edx
80102e95:	0f 84 cf 00 00 00    	je     80102f6a <clock+0xea>
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop
      panic("clock: invalid head");
    }
    cprintf("clock: scanning node %p %p\n", head->pgdir, head->vaddr);
80102ea0:	83 ec 04             	sub    $0x4,%esp
80102ea3:	52                   	push   %edx
80102ea4:	ff 70 08             	pushl  0x8(%eax)
80102ea7:	68 04 84 10 80       	push   $0x80108404
80102eac:	e8 ff d7 ff ff       	call   801006b0 <cprintf>
    pte_t *cur_pte = walkpgdir(head->pgdir, head->vaddr, 1);
80102eb1:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
80102eb6:	83 c4 0c             	add    $0xc,%esp
80102eb9:	6a 01                	push   $0x1
80102ebb:	ff 70 0c             	pushl  0xc(%eax)
80102ebe:	ff 70 08             	pushl  0x8(%eax)
80102ec1:	e8 8a 47 00 00       	call   80107650 <walkpgdir>
    int pte_a = (*cur_pte & PTE_A);
    if (pte_a){ // if PTE_A == 1
80102ec6:	83 c4 10             	add    $0x10,%esp
    pte_t *cur_pte = walkpgdir(head->pgdir, head->vaddr, 1);
80102ec9:	89 c3                	mov    %eax,%ebx
    int pte_a = (*cur_pte & PTE_A);
80102ecb:	8b 00                	mov    (%eax),%eax
    if (pte_a){ // if PTE_A == 1
80102ecd:	a8 20                	test   $0x20,%al
80102ecf:	75 67                	jne    80102f38 <clock+0xb8>
    }
    else
    {
      // if PTE_A == 0, swap out this page => do at swapout
      finished = 1;
      ret = head;
80102ed1:	8b 1d c0 a6 13 80    	mov    0x8013a6c0,%ebx
      cprintf("clock: Victim selected: %p %p\n", head->pgdir, head->vaddr);
80102ed7:	83 ec 04             	sub    $0x4,%esp
80102eda:	ff 73 0c             	pushl  0xc(%ebx)
80102edd:	ff 73 08             	pushl  0x8(%ebx)
80102ee0:	68 fc 87 10 80       	push   $0x801087fc
80102ee5:	e8 c6 d7 ff ff       	call   801006b0 <cprintf>
      cprintf("clock: Victim selected: cur->pgdir=%p | cur->vaddr=%p | cur->prev=%p | cur=%p | cur->next=%p\n", ret->pgdir, ret->vaddr, ret->prev, ret, ret->next);
80102eea:	58                   	pop    %eax
80102eeb:	5a                   	pop    %edx
80102eec:	ff 33                	pushl  (%ebx)
80102eee:	53                   	push   %ebx
80102eef:	ff 73 04             	pushl  0x4(%ebx)
80102ef2:	ff 73 0c             	pushl  0xc(%ebx)
80102ef5:	ff 73 08             	pushl  0x8(%ebx)
80102ef8:	68 1c 88 10 80       	push   $0x8010881c
80102efd:	e8 ae d7 ff ff       	call   801006b0 <cprintf>
  for (; !finished; head = head->prev)
80102f02:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
    }
  }
  cprintf("clock: finally ret %p != head %p\n", ret, head);
80102f07:	83 c4 1c             	add    $0x1c,%esp
  for (; !finished; head = head->prev)
80102f0a:	8b 40 04             	mov    0x4(%eax),%eax
  cprintf("clock: finally ret %p != head %p\n", ret, head);
80102f0d:	50                   	push   %eax
80102f0e:	53                   	push   %ebx
80102f0f:	68 7c 88 10 80       	push   $0x8010887c
  for (; !finished; head = head->prev)
80102f14:	a3 c0 a6 13 80       	mov    %eax,0x8013a6c0
  cprintf("clock: finally ret %p != head %p\n", ret, head);
80102f19:	e8 92 d7 ff ff       	call   801006b0 <cprintf>
  cprintf("clock ended successfully\n");
80102f1e:	c7 04 24 3b 84 10 80 	movl   $0x8010843b,(%esp)
80102f25:	e8 86 d7 ff ff       	call   801006b0 <cprintf>
  return ret;
80102f2a:	89 d8                	mov    %ebx,%eax
80102f2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f2f:	c9                   	leave  
80102f30:	c3                   	ret    
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("cur_pte cleared: %p -> %p\n", *cur_pte, (*cur_pte) & (~PTE_A));
80102f38:	89 c2                	mov    %eax,%edx
80102f3a:	83 ec 04             	sub    $0x4,%esp
80102f3d:	83 e2 df             	and    $0xffffffdf,%edx
80102f40:	52                   	push   %edx
80102f41:	50                   	push   %eax
80102f42:	68 20 84 10 80       	push   $0x80108420
80102f47:	e8 64 d7 ff ff       	call   801006b0 <cprintf>
      *cur_pte &= ~(PTE_A);
80102f4c:	83 23 df             	andl   $0xffffffdf,(%ebx)
  for (; !finished; head = head->prev)
80102f4f:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
    if (!(head->vaddr)){
80102f54:	83 c4 10             	add    $0x10,%esp
  for (; !finished; head = head->prev)
80102f57:	8b 40 04             	mov    0x4(%eax),%eax
    if (!(head->vaddr)){
80102f5a:	8b 50 0c             	mov    0xc(%eax),%edx
  for (; !finished; head = head->prev)
80102f5d:	a3 c0 a6 13 80       	mov    %eax,0x8013a6c0
    if (!(head->vaddr)){
80102f62:	85 d2                	test   %edx,%edx
80102f64:	0f 85 36 ff ff ff    	jne    80102ea0 <clock+0x20>
      panic("clock: invalid head");
80102f6a:	83 ec 0c             	sub    $0xc,%esp
80102f6d:	68 f0 83 10 80       	push   $0x801083f0
80102f72:	e8 19 d4 ff ff       	call   80100390 <panic>
80102f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7e:	66 90                	xchg   %ax,%ax

80102f80 <swapout>:
char* swapout(){
80102f80:	f3 0f 1e fb          	endbr32 
80102f84:	55                   	push   %ebp
80102f85:	89 e5                	mov    %esp,%ebp
80102f87:	57                   	push   %edi
80102f88:	56                   	push   %esi
80102f89:	53                   	push   %ebx
80102f8a:	83 ec 0c             	sub    $0xc,%esp
  if (num_free_pages == 0)
80102f8d:	a1 54 a7 13 80       	mov    0x8013a754,%eax
80102f92:	85 c0                	test   %eax,%eax
80102f94:	0f 84 a3 01 00 00    	je     8010313d <swapout+0x1bd>
  int block_number = get_available_bitmap();
80102f9a:	e8 a1 f6 ff ff       	call   80102640 <get_available_bitmap>
80102f9f:	89 c6                	mov    %eax,%esi
  struct page *victim = clock();
80102fa1:	e8 da fe ff ff       	call   80102e80 <clock>
  cprintf("swapout: before swapwrite at block_number=%d\n", block_number);
80102fa6:	83 ec 08             	sub    $0x8,%esp
  char *ret = victim->vaddr;
80102fa9:	8b 78 0c             	mov    0xc(%eax),%edi
  cprintf("swapout: before swapwrite at block_number=%d\n", block_number);
80102fac:	56                   	push   %esi
  struct page *victim = clock();
80102fad:	89 c3                	mov    %eax,%ebx
  cprintf("swapout: before swapwrite at block_number=%d\n", block_number);
80102faf:	68 a0 88 10 80       	push   $0x801088a0
80102fb4:	e8 f7 d6 ff ff       	call   801006b0 <cprintf>
  if(kmem.use_lock)
80102fb9:	a1 b4 46 11 80       	mov    0x801146b4,%eax
80102fbe:	83 c4 10             	add    $0x10,%esp
80102fc1:	85 c0                	test   %eax,%eax
80102fc3:	0f 85 17 01 00 00    	jne    801030e0 <swapout+0x160>
  swapwrite((char *)victim, block_number); // 누구를 어디 적었다 이거 기록해놔야할것같은데?
80102fc9:	83 ec 08             	sub    $0x8,%esp
80102fcc:	56                   	push   %esi
80102fcd:	53                   	push   %ebx
80102fce:	e8 3d f1 ff ff       	call   80102110 <swapwrite>
  if(kmem.use_lock)
80102fd3:	a1 b4 46 11 80       	mov    0x801146b4,%eax
80102fd8:	83 c4 10             	add    $0x10,%esp
80102fdb:	85 c0                	test   %eax,%eax
80102fdd:	0f 85 45 01 00 00    	jne    80103128 <swapout+0x1a8>
  change_bitmap(block_number, 1); // setup bitmap
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	6a 01                	push   $0x1
80102fe8:	56                   	push   %esi
80102fe9:	e8 f2 f5 ff ff       	call   801025e0 <change_bitmap>
  cprintf("swapout: before kfree: %p %p P2V(PTE_ADDR(vaddr))=%p\n", victim->pgdir, victim->vaddr, P2V(PTE_ADDR(victim->vaddr)));
80102fee:	8b 53 0c             	mov    0xc(%ebx),%edx
80102ff1:	89 d0                	mov    %edx,%eax
80102ff3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ff8:	05 00 00 00 80       	add    $0x80000000,%eax
80102ffd:	50                   	push   %eax
80102ffe:	52                   	push   %edx
80102fff:	ff 73 08             	pushl  0x8(%ebx)
80103002:	68 d0 88 10 80       	push   $0x801088d0
80103007:	e8 a4 d6 ff ff       	call   801006b0 <cprintf>
  if(kmem.use_lock)
8010300c:	a1 b4 46 11 80       	mov    0x801146b4,%eax
80103011:	83 c4 20             	add    $0x20,%esp
80103014:	85 c0                	test   %eax,%eax
80103016:	0f 85 f4 00 00 00    	jne    80103110 <swapout+0x190>
  kfree(P2V(PTE_ADDR(victim->vaddr)));     // free victim page
8010301c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010301f:	83 ec 0c             	sub    $0xc,%esp
80103022:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80103027:	05 00 00 00 80       	add    $0x80000000,%eax
8010302c:	50                   	push   %eax
8010302d:	e8 8e fb ff ff       	call   80102bc0 <kfree>
  if(kmem.use_lock)
80103032:	8b 0d b4 46 11 80    	mov    0x801146b4,%ecx
80103038:	83 c4 10             	add    $0x10,%esp
8010303b:	85 c9                	test   %ecx,%ecx
8010303d:	0f 85 b5 00 00 00    	jne    801030f8 <swapout+0x178>
  cprintf("swapout: Does Victim Really Deleted from LRU? %p %p %p %p\n", victim->pgdir, victim->vaddr, victim->prev, victim->next);
80103043:	83 ec 0c             	sub    $0xc,%esp
80103046:	ff 33                	pushl  (%ebx)
  pte_t tmp_pte = block_number << 12; // PFN
80103048:	c1 e6 0c             	shl    $0xc,%esi
  cprintf("swapout: Does Victim Really Deleted from LRU? %p %p %p %p\n", victim->pgdir, victim->vaddr, victim->prev, victim->next);
8010304b:	ff 73 04             	pushl  0x4(%ebx)
8010304e:	ff 73 0c             	pushl  0xc(%ebx)
80103051:	ff 73 08             	pushl  0x8(%ebx)
80103054:	68 08 89 10 80       	push   $0x80108908
80103059:	e8 52 d6 ff ff       	call   801006b0 <cprintf>
  cprintf("swapout: before walkpgdir: %p %p\n", victim->pgdir, victim->vaddr);
8010305e:	83 c4 1c             	add    $0x1c,%esp
80103061:	ff 73 0c             	pushl  0xc(%ebx)
80103064:	ff 73 08             	pushl  0x8(%ebx)
80103067:	68 44 89 10 80       	push   $0x80108944
8010306c:	e8 3f d6 ff ff       	call   801006b0 <cprintf>
  pte_t* pte = walkpgdir(victim->pgdir, victim->vaddr, 1);
80103071:	83 c4 0c             	add    $0xc,%esp
80103074:	6a 01                	push   $0x1
80103076:	ff 73 0c             	pushl  0xc(%ebx)
80103079:	ff 73 08             	pushl  0x8(%ebx)
8010307c:	e8 cf 45 00 00       	call   80107650 <walkpgdir>
  cprintf("swapout: walkpgdir succeed: %p %p\n", victim->pgdir, victim->vaddr);
80103081:	83 c4 0c             	add    $0xc,%esp
  tmp_pte |= ((*pte) & 0x00000FFE);   // clear the PTE_P
80103084:	8b 10                	mov    (%eax),%edx
80103086:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
8010308c:	09 d6                	or     %edx,%esi
8010308e:	89 30                	mov    %esi,(%eax)
  cprintf("swapout: walkpgdir succeed: %p %p\n", victim->pgdir, victim->vaddr);
80103090:	ff 73 0c             	pushl  0xc(%ebx)
80103093:	ff 73 08             	pushl  0x8(%ebx)
80103096:	68 68 89 10 80       	push   $0x80108968
8010309b:	e8 10 d6 ff ff       	call   801006b0 <cprintf>
  lcr3(V2P(victim->pgdir)); // flush TLB
801030a0:	8b 43 08             	mov    0x8(%ebx),%eax
801030a3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801030a9:	0f 22 da             	mov    %edx,%cr3
  cprintf("swapout: walkpgdir succeed: %p %p\n", victim->pgdir, victim->vaddr);
801030ac:	83 c4 0c             	add    $0xc,%esp
801030af:	ff 73 0c             	pushl  0xc(%ebx)
801030b2:	50                   	push   %eax
801030b3:	68 68 89 10 80       	push   $0x80108968
801030b8:	e8 f3 d5 ff ff       	call   801006b0 <cprintf>
  cprintf("SWAPOUT ENDED SUCCESSFULLY, returning %p\n", ret);
801030bd:	58                   	pop    %eax
801030be:	5a                   	pop    %edx
801030bf:	57                   	push   %edi
801030c0:	68 8c 89 10 80       	push   $0x8010898c
801030c5:	e8 e6 d5 ff ff       	call   801006b0 <cprintf>
  return P2V(PTE_ADDR(*ret));
801030ca:	0f be 07             	movsbl (%edi),%eax
}
801030cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030d0:	5b                   	pop    %ebx
801030d1:	5e                   	pop    %esi
  return P2V(PTE_ADDR(*ret));
801030d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801030d7:	5f                   	pop    %edi
801030d8:	5d                   	pop    %ebp
  return P2V(PTE_ADDR(*ret));
801030d9:	05 00 00 00 80       	add    $0x80000000,%eax
}
801030de:	c3                   	ret    
801030df:	90                   	nop
    release(&kmem.lock);
801030e0:	83 ec 0c             	sub    $0xc,%esp
801030e3:	68 80 46 11 80       	push   $0x80114680
801030e8:	e8 c3 20 00 00       	call   801051b0 <release>
801030ed:	83 c4 10             	add    $0x10,%esp
801030f0:	e9 d4 fe ff ff       	jmp    80102fc9 <swapout+0x49>
801030f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801030f8:	83 ec 0c             	sub    $0xc,%esp
801030fb:	68 80 46 11 80       	push   $0x80114680
80103100:	e8 eb 1f 00 00       	call   801050f0 <acquire>
80103105:	83 c4 10             	add    $0x10,%esp
80103108:	e9 36 ff ff ff       	jmp    80103043 <swapout+0xc3>
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103110:	83 ec 0c             	sub    $0xc,%esp
80103113:	68 80 46 11 80       	push   $0x80114680
80103118:	e8 93 20 00 00       	call   801051b0 <release>
8010311d:	83 c4 10             	add    $0x10,%esp
80103120:	e9 f7 fe ff ff       	jmp    8010301c <swapout+0x9c>
80103125:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80103128:	83 ec 0c             	sub    $0xc,%esp
8010312b:	68 80 46 11 80       	push   $0x80114680
80103130:	e8 bb 1f 00 00       	call   801050f0 <acquire>
80103135:	83 c4 10             	add    $0x10,%esp
80103138:	e9 a6 fe ff ff       	jmp    80102fe3 <swapout+0x63>
    panic("OOM Error");
8010313d:	83 ec 0c             	sub    $0xc,%esp
80103140:	68 55 84 10 80       	push   $0x80108455
80103145:	e8 46 d2 ff ff       	call   80100390 <panic>
8010314a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103150 <kalloc>:
{
80103150:	f3 0f 1e fb          	endbr32 
80103154:	55                   	push   %ebp
80103155:	89 e5                	mov    %esp,%ebp
80103157:	83 ec 18             	sub    $0x18,%esp
  if(kmem.use_lock)
8010315a:	8b 0d b4 46 11 80    	mov    0x801146b4,%ecx
80103160:	85 c9                	test   %ecx,%ecx
80103162:	75 3c                	jne    801031a0 <kalloc+0x50>
  r = kmem.freelist;
80103164:	a1 b8 46 11 80       	mov    0x801146b8,%eax
  if(r){
80103169:	85 c0                	test   %eax,%eax
8010316b:	74 4c                	je     801031b9 <kalloc+0x69>
    kmem.freelist = r->next;
8010316d:	8b 10                	mov    (%eax),%edx
8010316f:	89 15 b8 46 11 80    	mov    %edx,0x801146b8
  if(kmem.use_lock)
80103175:	8b 15 b4 46 11 80    	mov    0x801146b4,%edx
8010317b:	85 d2                	test   %edx,%edx
8010317d:	75 09                	jne    80103188 <kalloc+0x38>
}
8010317f:	c9                   	leave  
80103180:	c3                   	ret    
80103181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80103188:	83 ec 0c             	sub    $0xc,%esp
8010318b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010318e:	68 80 46 11 80       	push   $0x80114680
80103193:	e8 18 20 00 00       	call   801051b0 <release>
80103198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010319b:	83 c4 10             	add    $0x10,%esp
}
8010319e:	c9                   	leave  
8010319f:	c3                   	ret    
    acquire(&kmem.lock);
801031a0:	83 ec 0c             	sub    $0xc,%esp
801031a3:	68 80 46 11 80       	push   $0x80114680
801031a8:	e8 43 1f 00 00       	call   801050f0 <acquire>
  r = kmem.freelist;
801031ad:	a1 b8 46 11 80       	mov    0x801146b8,%eax
    acquire(&kmem.lock);
801031b2:	83 c4 10             	add    $0x10,%esp
  if(r){
801031b5:	85 c0                	test   %eax,%eax
801031b7:	75 b4                	jne    8010316d <kalloc+0x1d>
    r = (struct run*)swapout();
801031b9:	e8 c2 fd ff ff       	call   80102f80 <swapout>
801031be:	eb b5                	jmp    80103175 <kalloc+0x25>

801031c0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801031c0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c4:	ba 64 00 00 00       	mov    $0x64,%edx
801031c9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801031ca:	a8 01                	test   $0x1,%al
801031cc:	0f 84 be 00 00 00    	je     80103290 <kbdgetc+0xd0>
{
801031d2:	55                   	push   %ebp
801031d3:	ba 60 00 00 00       	mov    $0x60,%edx
801031d8:	89 e5                	mov    %esp,%ebp
801031da:	53                   	push   %ebx
801031db:	ec                   	in     (%dx),%al
  return data;
801031dc:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801031e2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801031e5:	3c e0                	cmp    $0xe0,%al
801031e7:	74 57                	je     80103240 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801031e9:	89 d9                	mov    %ebx,%ecx
801031eb:	83 e1 40             	and    $0x40,%ecx
801031ee:	84 c0                	test   %al,%al
801031f0:	78 5e                	js     80103250 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801031f2:	85 c9                	test   %ecx,%ecx
801031f4:	74 09                	je     801031ff <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801031f6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801031f9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801031fc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801031ff:	0f b6 8a e0 8a 10 80 	movzbl -0x7fef7520(%edx),%ecx
  shift ^= togglecode[data];
80103206:	0f b6 82 e0 89 10 80 	movzbl -0x7fef7620(%edx),%eax
  shift |= shiftcode[data];
8010320d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010320f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80103211:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80103213:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80103219:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010321c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010321f:	8b 04 85 c0 89 10 80 	mov    -0x7fef7640(,%eax,4),%eax
80103226:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010322a:	74 0b                	je     80103237 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010322c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010322f:	83 fa 19             	cmp    $0x19,%edx
80103232:	77 44                	ja     80103278 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103234:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103237:	5b                   	pop    %ebx
80103238:	5d                   	pop    %ebp
80103239:	c3                   	ret    
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80103240:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103243:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103245:	89 1d b4 c5 10 80    	mov    %ebx,0x8010c5b4
}
8010324b:	5b                   	pop    %ebx
8010324c:	5d                   	pop    %ebp
8010324d:	c3                   	ret    
8010324e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80103250:	83 e0 7f             	and    $0x7f,%eax
80103253:	85 c9                	test   %ecx,%ecx
80103255:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80103258:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010325a:	0f b6 8a e0 8a 10 80 	movzbl -0x7fef7520(%edx),%ecx
80103261:	83 c9 40             	or     $0x40,%ecx
80103264:	0f b6 c9             	movzbl %cl,%ecx
80103267:	f7 d1                	not    %ecx
80103269:	21 d9                	and    %ebx,%ecx
}
8010326b:	5b                   	pop    %ebx
8010326c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010326d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80103273:	c3                   	ret    
80103274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80103278:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010327b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010327e:	5b                   	pop    %ebx
8010327f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103280:	83 f9 1a             	cmp    $0x1a,%ecx
80103283:	0f 42 c2             	cmovb  %edx,%eax
}
80103286:	c3                   	ret    
80103287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328e:	66 90                	xchg   %ax,%ax
    return -1;
80103290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103295:	c3                   	ret    
80103296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010329d:	8d 76 00             	lea    0x0(%esi),%esi

801032a0 <kbdintr>:

void
kbdintr(void)
{
801032a0:	f3 0f 1e fb          	endbr32 
801032a4:	55                   	push   %ebp
801032a5:	89 e5                	mov    %esp,%ebp
801032a7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801032aa:	68 c0 31 10 80       	push   $0x801031c0
801032af:	e8 ac d5 ff ff       	call   80100860 <consoleintr>
}
801032b4:	83 c4 10             	add    $0x10,%esp
801032b7:	c9                   	leave  
801032b8:	c3                   	ret    
801032b9:	66 90                	xchg   %ax,%ax
801032bb:	66 90                	xchg   %ax,%ax
801032bd:	66 90                	xchg   %ax,%ax
801032bf:	90                   	nop

801032c0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801032c0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801032c4:	a1 58 a7 13 80       	mov    0x8013a758,%eax
801032c9:	85 c0                	test   %eax,%eax
801032cb:	0f 84 c7 00 00 00    	je     80103398 <lapicinit+0xd8>
  lapic[index] = value;
801032d1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801032d8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032de:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801032e5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032e8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032eb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801032f2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801032f5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032f8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801032ff:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103302:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103305:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010330c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010330f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103312:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103319:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010331c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010331f:	8b 50 30             	mov    0x30(%eax),%edx
80103322:	c1 ea 10             	shr    $0x10,%edx
80103325:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010332b:	75 73                	jne    801033a0 <lapicinit+0xe0>
  lapic[index] = value;
8010332d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103334:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103337:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010333a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103341:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103344:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103347:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010334e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103351:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103354:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010335b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010335e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103361:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103368:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010336b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010336e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103375:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103378:	8b 50 20             	mov    0x20(%eax),%edx
8010337b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010337f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103380:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103386:	80 e6 10             	and    $0x10,%dh
80103389:	75 f5                	jne    80103380 <lapicinit+0xc0>
  lapic[index] = value;
8010338b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103392:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103395:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103398:	c3                   	ret    
80103399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801033a0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801033a7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801033aa:	8b 50 20             	mov    0x20(%eax),%edx
}
801033ad:	e9 7b ff ff ff       	jmp    8010332d <lapicinit+0x6d>
801033b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033c0 <lapicid>:

int
lapicid(void)
{
801033c0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801033c4:	a1 58 a7 13 80       	mov    0x8013a758,%eax
801033c9:	85 c0                	test   %eax,%eax
801033cb:	74 0b                	je     801033d8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801033cd:	8b 40 20             	mov    0x20(%eax),%eax
801033d0:	c1 e8 18             	shr    $0x18,%eax
801033d3:	c3                   	ret    
801033d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801033d8:	31 c0                	xor    %eax,%eax
}
801033da:	c3                   	ret    
801033db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop

801033e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801033e4:	a1 58 a7 13 80       	mov    0x8013a758,%eax
801033e9:	85 c0                	test   %eax,%eax
801033eb:	74 0d                	je     801033fa <lapiceoi+0x1a>
  lapic[index] = value;
801033ed:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801033f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801033f7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801033fa:	c3                   	ret    
801033fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033ff:	90                   	nop

80103400 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103400:	f3 0f 1e fb          	endbr32 
}
80103404:	c3                   	ret    
80103405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103410 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103410:	f3 0f 1e fb          	endbr32 
80103414:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103415:	b8 0f 00 00 00       	mov    $0xf,%eax
8010341a:	ba 70 00 00 00       	mov    $0x70,%edx
8010341f:	89 e5                	mov    %esp,%ebp
80103421:	53                   	push   %ebx
80103422:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103425:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103428:	ee                   	out    %al,(%dx)
80103429:	b8 0a 00 00 00       	mov    $0xa,%eax
8010342e:	ba 71 00 00 00       	mov    $0x71,%edx
80103433:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103434:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103436:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103439:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010343f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103441:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103444:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103446:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103449:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010344c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103452:	a1 58 a7 13 80       	mov    0x8013a758,%eax
80103457:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010345d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103460:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103467:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010346a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010346d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103474:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103477:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010347a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103480:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103483:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103489:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010348c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103492:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103495:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010349b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010349c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010349f:	5d                   	pop    %ebp
801034a0:	c3                   	ret    
801034a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034af:	90                   	nop

801034b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801034b0:	f3 0f 1e fb          	endbr32 
801034b4:	55                   	push   %ebp
801034b5:	b8 0b 00 00 00       	mov    $0xb,%eax
801034ba:	ba 70 00 00 00       	mov    $0x70,%edx
801034bf:	89 e5                	mov    %esp,%ebp
801034c1:	57                   	push   %edi
801034c2:	56                   	push   %esi
801034c3:	53                   	push   %ebx
801034c4:	83 ec 4c             	sub    $0x4c,%esp
801034c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034c8:	ba 71 00 00 00       	mov    $0x71,%edx
801034cd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801034ce:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d1:	bb 70 00 00 00       	mov    $0x70,%ebx
801034d6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801034d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034e0:	31 c0                	xor    %eax,%eax
801034e2:	89 da                	mov    %ebx,%edx
801034e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034e5:	b9 71 00 00 00       	mov    $0x71,%ecx
801034ea:	89 ca                	mov    %ecx,%edx
801034ec:	ec                   	in     (%dx),%al
801034ed:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f0:	89 da                	mov    %ebx,%edx
801034f2:	b8 02 00 00 00       	mov    $0x2,%eax
801034f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034f8:	89 ca                	mov    %ecx,%edx
801034fa:	ec                   	in     (%dx),%al
801034fb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034fe:	89 da                	mov    %ebx,%edx
80103500:	b8 04 00 00 00       	mov    $0x4,%eax
80103505:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103506:	89 ca                	mov    %ecx,%edx
80103508:	ec                   	in     (%dx),%al
80103509:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010350c:	89 da                	mov    %ebx,%edx
8010350e:	b8 07 00 00 00       	mov    $0x7,%eax
80103513:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103514:	89 ca                	mov    %ecx,%edx
80103516:	ec                   	in     (%dx),%al
80103517:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010351a:	89 da                	mov    %ebx,%edx
8010351c:	b8 08 00 00 00       	mov    $0x8,%eax
80103521:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103522:	89 ca                	mov    %ecx,%edx
80103524:	ec                   	in     (%dx),%al
80103525:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103527:	89 da                	mov    %ebx,%edx
80103529:	b8 09 00 00 00       	mov    $0x9,%eax
8010352e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010352f:	89 ca                	mov    %ecx,%edx
80103531:	ec                   	in     (%dx),%al
80103532:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103534:	89 da                	mov    %ebx,%edx
80103536:	b8 0a 00 00 00       	mov    $0xa,%eax
8010353b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010353c:	89 ca                	mov    %ecx,%edx
8010353e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010353f:	84 c0                	test   %al,%al
80103541:	78 9d                	js     801034e0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103543:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103547:	89 fa                	mov    %edi,%edx
80103549:	0f b6 fa             	movzbl %dl,%edi
8010354c:	89 f2                	mov    %esi,%edx
8010354e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103551:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103555:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103558:	89 da                	mov    %ebx,%edx
8010355a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010355d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103560:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103564:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103567:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010356a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010356e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103571:	31 c0                	xor    %eax,%eax
80103573:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103574:	89 ca                	mov    %ecx,%edx
80103576:	ec                   	in     (%dx),%al
80103577:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010357a:	89 da                	mov    %ebx,%edx
8010357c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010357f:	b8 02 00 00 00       	mov    $0x2,%eax
80103584:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103585:	89 ca                	mov    %ecx,%edx
80103587:	ec                   	in     (%dx),%al
80103588:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010358b:	89 da                	mov    %ebx,%edx
8010358d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103590:	b8 04 00 00 00       	mov    $0x4,%eax
80103595:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103596:	89 ca                	mov    %ecx,%edx
80103598:	ec                   	in     (%dx),%al
80103599:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010359c:	89 da                	mov    %ebx,%edx
8010359e:	89 45 d8             	mov    %eax,-0x28(%ebp)
801035a1:	b8 07 00 00 00       	mov    $0x7,%eax
801035a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035a7:	89 ca                	mov    %ecx,%edx
801035a9:	ec                   	in     (%dx),%al
801035aa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035ad:	89 da                	mov    %ebx,%edx
801035af:	89 45 dc             	mov    %eax,-0x24(%ebp)
801035b2:	b8 08 00 00 00       	mov    $0x8,%eax
801035b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035b8:	89 ca                	mov    %ecx,%edx
801035ba:	ec                   	in     (%dx),%al
801035bb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035be:	89 da                	mov    %ebx,%edx
801035c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801035c3:	b8 09 00 00 00       	mov    $0x9,%eax
801035c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035c9:	89 ca                	mov    %ecx,%edx
801035cb:	ec                   	in     (%dx),%al
801035cc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801035cf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801035d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801035d5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801035d8:	6a 18                	push   $0x18
801035da:	50                   	push   %eax
801035db:	8d 45 b8             	lea    -0x48(%ebp),%eax
801035de:	50                   	push   %eax
801035df:	e8 6c 1c 00 00       	call   80105250 <memcmp>
801035e4:	83 c4 10             	add    $0x10,%esp
801035e7:	85 c0                	test   %eax,%eax
801035e9:	0f 85 f1 fe ff ff    	jne    801034e0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801035ef:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801035f3:	75 78                	jne    8010366d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801035f5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801035f8:	89 c2                	mov    %eax,%edx
801035fa:	83 e0 0f             	and    $0xf,%eax
801035fd:	c1 ea 04             	shr    $0x4,%edx
80103600:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103603:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103606:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103609:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010360c:	89 c2                	mov    %eax,%edx
8010360e:	83 e0 0f             	and    $0xf,%eax
80103611:	c1 ea 04             	shr    $0x4,%edx
80103614:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103617:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010361a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010361d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103620:	89 c2                	mov    %eax,%edx
80103622:	83 e0 0f             	and    $0xf,%eax
80103625:	c1 ea 04             	shr    $0x4,%edx
80103628:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010362b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010362e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103631:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103634:	89 c2                	mov    %eax,%edx
80103636:	83 e0 0f             	and    $0xf,%eax
80103639:	c1 ea 04             	shr    $0x4,%edx
8010363c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010363f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103642:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103645:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103648:	89 c2                	mov    %eax,%edx
8010364a:	83 e0 0f             	and    $0xf,%eax
8010364d:	c1 ea 04             	shr    $0x4,%edx
80103650:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103653:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103656:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103659:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010365c:	89 c2                	mov    %eax,%edx
8010365e:	83 e0 0f             	and    $0xf,%eax
80103661:	c1 ea 04             	shr    $0x4,%edx
80103664:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103667:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010366a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010366d:	8b 75 08             	mov    0x8(%ebp),%esi
80103670:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103673:	89 06                	mov    %eax,(%esi)
80103675:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103678:	89 46 04             	mov    %eax,0x4(%esi)
8010367b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010367e:	89 46 08             	mov    %eax,0x8(%esi)
80103681:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103684:	89 46 0c             	mov    %eax,0xc(%esi)
80103687:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010368a:	89 46 10             	mov    %eax,0x10(%esi)
8010368d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103690:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103693:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010369a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369d:	5b                   	pop    %ebx
8010369e:	5e                   	pop    %esi
8010369f:	5f                   	pop    %edi
801036a0:	5d                   	pop    %ebp
801036a1:	c3                   	ret    
801036a2:	66 90                	xchg   %ax,%ax
801036a4:	66 90                	xchg   %ax,%ax
801036a6:	66 90                	xchg   %ax,%ax
801036a8:	66 90                	xchg   %ax,%ax
801036aa:	66 90                	xchg   %ax,%ax
801036ac:	66 90                	xchg   %ax,%ax
801036ae:	66 90                	xchg   %ax,%ax

801036b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036b0:	8b 0d a8 a7 13 80    	mov    0x8013a7a8,%ecx
801036b6:	85 c9                	test   %ecx,%ecx
801036b8:	0f 8e 8a 00 00 00    	jle    80103748 <install_trans+0x98>
{
801036be:	55                   	push   %ebp
801036bf:	89 e5                	mov    %esp,%ebp
801036c1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801036c2:	31 ff                	xor    %edi,%edi
{
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 0c             	sub    $0xc,%esp
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801036d0:	a1 94 a7 13 80       	mov    0x8013a794,%eax
801036d5:	83 ec 08             	sub    $0x8,%esp
801036d8:	01 f8                	add    %edi,%eax
801036da:	83 c0 01             	add    $0x1,%eax
801036dd:	50                   	push   %eax
801036de:	ff 35 a4 a7 13 80    	pushl  0x8013a7a4
801036e4:	e8 e7 c9 ff ff       	call   801000d0 <bread>
801036e9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036eb:	58                   	pop    %eax
801036ec:	5a                   	pop    %edx
801036ed:	ff 34 bd ac a7 13 80 	pushl  -0x7fec5854(,%edi,4)
801036f4:	ff 35 a4 a7 13 80    	pushl  0x8013a7a4
  for (tail = 0; tail < log.lh.n; tail++) {
801036fa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036fd:	e8 ce c9 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103702:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103705:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103707:	8d 46 5c             	lea    0x5c(%esi),%eax
8010370a:	68 00 02 00 00       	push   $0x200
8010370f:	50                   	push   %eax
80103710:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103713:	50                   	push   %eax
80103714:	e8 87 1b 00 00       	call   801052a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103719:	89 1c 24             	mov    %ebx,(%esp)
8010371c:	e8 8f ca ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103721:	89 34 24             	mov    %esi,(%esp)
80103724:	e8 c7 ca ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103729:	89 1c 24             	mov    %ebx,(%esp)
8010372c:	e8 bf ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103731:	83 c4 10             	add    $0x10,%esp
80103734:	39 3d a8 a7 13 80    	cmp    %edi,0x8013a7a8
8010373a:	7f 94                	jg     801036d0 <install_trans+0x20>
  }
}
8010373c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010373f:	5b                   	pop    %ebx
80103740:	5e                   	pop    %esi
80103741:	5f                   	pop    %edi
80103742:	5d                   	pop    %ebp
80103743:	c3                   	ret    
80103744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103748:	c3                   	ret    
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103750 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
80103754:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103757:	ff 35 94 a7 13 80    	pushl  0x8013a794
8010375d:	ff 35 a4 a7 13 80    	pushl  0x8013a7a4
80103763:	e8 68 c9 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103768:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010376b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010376d:	a1 a8 a7 13 80       	mov    0x8013a7a8,%eax
80103772:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103775:	85 c0                	test   %eax,%eax
80103777:	7e 19                	jle    80103792 <write_head+0x42>
80103779:	31 d2                	xor    %edx,%edx
8010377b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010377f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103780:	8b 0c 95 ac a7 13 80 	mov    -0x7fec5854(,%edx,4),%ecx
80103787:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010378b:	83 c2 01             	add    $0x1,%edx
8010378e:	39 d0                	cmp    %edx,%eax
80103790:	75 ee                	jne    80103780 <write_head+0x30>
  }
  bwrite(buf);
80103792:	83 ec 0c             	sub    $0xc,%esp
80103795:	53                   	push   %ebx
80103796:	e8 15 ca ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010379b:	89 1c 24             	mov    %ebx,(%esp)
8010379e:	e8 4d ca ff ff       	call   801001f0 <brelse>
}
801037a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	c9                   	leave  
801037aa:	c3                   	ret    
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop

801037b0 <initlog>:
{
801037b0:	f3 0f 1e fb          	endbr32 
801037b4:	55                   	push   %ebp
801037b5:	89 e5                	mov    %esp,%ebp
801037b7:	53                   	push   %ebx
801037b8:	83 ec 2c             	sub    $0x2c,%esp
801037bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801037be:	68 e0 8b 10 80       	push   $0x80108be0
801037c3:	68 60 a7 13 80       	push   $0x8013a760
801037c8:	e8 a3 17 00 00       	call   80104f70 <initlock>
  readsb(dev, &sb);
801037cd:	58                   	pop    %eax
801037ce:	8d 45 dc             	lea    -0x24(%ebp),%eax
801037d1:	5a                   	pop    %edx
801037d2:	50                   	push   %eax
801037d3:	53                   	push   %ebx
801037d4:	e8 a7 dc ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
801037d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801037dc:	59                   	pop    %ecx
  log.dev = dev;
801037dd:	89 1d a4 a7 13 80    	mov    %ebx,0x8013a7a4
  log.size = sb.nlog;
801037e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801037e6:	a3 94 a7 13 80       	mov    %eax,0x8013a794
  log.size = sb.nlog;
801037eb:	89 15 98 a7 13 80    	mov    %edx,0x8013a798
  struct buf *buf = bread(log.dev, log.start);
801037f1:	5a                   	pop    %edx
801037f2:	50                   	push   %eax
801037f3:	53                   	push   %ebx
801037f4:	e8 d7 c8 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801037f9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801037fc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801037ff:	89 0d a8 a7 13 80    	mov    %ecx,0x8013a7a8
  for (i = 0; i < log.lh.n; i++) {
80103805:	85 c9                	test   %ecx,%ecx
80103807:	7e 19                	jle    80103822 <initlog+0x72>
80103809:	31 d2                	xor    %edx,%edx
8010380b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103810:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103814:	89 1c 95 ac a7 13 80 	mov    %ebx,-0x7fec5854(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010381b:	83 c2 01             	add    $0x1,%edx
8010381e:	39 d1                	cmp    %edx,%ecx
80103820:	75 ee                	jne    80103810 <initlog+0x60>
  brelse(buf);
80103822:	83 ec 0c             	sub    $0xc,%esp
80103825:	50                   	push   %eax
80103826:	e8 c5 c9 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010382b:	e8 80 fe ff ff       	call   801036b0 <install_trans>
  log.lh.n = 0;
80103830:	c7 05 a8 a7 13 80 00 	movl   $0x0,0x8013a7a8
80103837:	00 00 00 
  write_head(); // clear the log
8010383a:	e8 11 ff ff ff       	call   80103750 <write_head>
}
8010383f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103842:	83 c4 10             	add    $0x10,%esp
80103845:	c9                   	leave  
80103846:	c3                   	ret    
80103847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010384e:	66 90                	xchg   %ax,%ax

80103850 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103850:	f3 0f 1e fb          	endbr32 
80103854:	55                   	push   %ebp
80103855:	89 e5                	mov    %esp,%ebp
80103857:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010385a:	68 60 a7 13 80       	push   $0x8013a760
8010385f:	e8 8c 18 00 00       	call   801050f0 <acquire>
80103864:	83 c4 10             	add    $0x10,%esp
80103867:	eb 1c                	jmp    80103885 <begin_op+0x35>
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103870:	83 ec 08             	sub    $0x8,%esp
80103873:	68 60 a7 13 80       	push   $0x8013a760
80103878:	68 60 a7 13 80       	push   $0x8013a760
8010387d:	e8 2e 12 00 00       	call   80104ab0 <sleep>
80103882:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103885:	a1 a0 a7 13 80       	mov    0x8013a7a0,%eax
8010388a:	85 c0                	test   %eax,%eax
8010388c:	75 e2                	jne    80103870 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010388e:	a1 9c a7 13 80       	mov    0x8013a79c,%eax
80103893:	8b 15 a8 a7 13 80    	mov    0x8013a7a8,%edx
80103899:	83 c0 01             	add    $0x1,%eax
8010389c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010389f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801038a2:	83 fa 1e             	cmp    $0x1e,%edx
801038a5:	7f c9                	jg     80103870 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801038a7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801038aa:	a3 9c a7 13 80       	mov    %eax,0x8013a79c
      release(&log.lock);
801038af:	68 60 a7 13 80       	push   $0x8013a760
801038b4:	e8 f7 18 00 00       	call   801051b0 <release>
      break;
    }
  }
}
801038b9:	83 c4 10             	add    $0x10,%esp
801038bc:	c9                   	leave  
801038bd:	c3                   	ret    
801038be:	66 90                	xchg   %ax,%ax

801038c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	57                   	push   %edi
801038c8:	56                   	push   %esi
801038c9:	53                   	push   %ebx
801038ca:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801038cd:	68 60 a7 13 80       	push   $0x8013a760
801038d2:	e8 19 18 00 00       	call   801050f0 <acquire>
  log.outstanding -= 1;
801038d7:	a1 9c a7 13 80       	mov    0x8013a79c,%eax
  if(log.committing)
801038dc:	8b 35 a0 a7 13 80    	mov    0x8013a7a0,%esi
801038e2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801038e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801038e8:	89 1d 9c a7 13 80    	mov    %ebx,0x8013a79c
  if(log.committing)
801038ee:	85 f6                	test   %esi,%esi
801038f0:	0f 85 1e 01 00 00    	jne    80103a14 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801038f6:	85 db                	test   %ebx,%ebx
801038f8:	0f 85 f2 00 00 00    	jne    801039f0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801038fe:	c7 05 a0 a7 13 80 01 	movl   $0x1,0x8013a7a0
80103905:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103908:	83 ec 0c             	sub    $0xc,%esp
8010390b:	68 60 a7 13 80       	push   $0x8013a760
80103910:	e8 9b 18 00 00       	call   801051b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103915:	8b 0d a8 a7 13 80    	mov    0x8013a7a8,%ecx
8010391b:	83 c4 10             	add    $0x10,%esp
8010391e:	85 c9                	test   %ecx,%ecx
80103920:	7f 3e                	jg     80103960 <end_op+0xa0>
    acquire(&log.lock);
80103922:	83 ec 0c             	sub    $0xc,%esp
80103925:	68 60 a7 13 80       	push   $0x8013a760
8010392a:	e8 c1 17 00 00       	call   801050f0 <acquire>
    wakeup(&log);
8010392f:	c7 04 24 60 a7 13 80 	movl   $0x8013a760,(%esp)
    log.committing = 0;
80103936:	c7 05 a0 a7 13 80 00 	movl   $0x0,0x8013a7a0
8010393d:	00 00 00 
    wakeup(&log);
80103940:	e8 2b 13 00 00       	call   80104c70 <wakeup>
    release(&log.lock);
80103945:	c7 04 24 60 a7 13 80 	movl   $0x8013a760,(%esp)
8010394c:	e8 5f 18 00 00       	call   801051b0 <release>
80103951:	83 c4 10             	add    $0x10,%esp
}
80103954:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103957:	5b                   	pop    %ebx
80103958:	5e                   	pop    %esi
80103959:	5f                   	pop    %edi
8010395a:	5d                   	pop    %ebp
8010395b:	c3                   	ret    
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103960:	a1 94 a7 13 80       	mov    0x8013a794,%eax
80103965:	83 ec 08             	sub    $0x8,%esp
80103968:	01 d8                	add    %ebx,%eax
8010396a:	83 c0 01             	add    $0x1,%eax
8010396d:	50                   	push   %eax
8010396e:	ff 35 a4 a7 13 80    	pushl  0x8013a7a4
80103974:	e8 57 c7 ff ff       	call   801000d0 <bread>
80103979:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010397b:	58                   	pop    %eax
8010397c:	5a                   	pop    %edx
8010397d:	ff 34 9d ac a7 13 80 	pushl  -0x7fec5854(,%ebx,4)
80103984:	ff 35 a4 a7 13 80    	pushl  0x8013a7a4
  for (tail = 0; tail < log.lh.n; tail++) {
8010398a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010398d:	e8 3e c7 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103992:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103995:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103997:	8d 40 5c             	lea    0x5c(%eax),%eax
8010399a:	68 00 02 00 00       	push   $0x200
8010399f:	50                   	push   %eax
801039a0:	8d 46 5c             	lea    0x5c(%esi),%eax
801039a3:	50                   	push   %eax
801039a4:	e8 f7 18 00 00       	call   801052a0 <memmove>
    bwrite(to);  // write the log
801039a9:	89 34 24             	mov    %esi,(%esp)
801039ac:	e8 ff c7 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801039b1:	89 3c 24             	mov    %edi,(%esp)
801039b4:	e8 37 c8 ff ff       	call   801001f0 <brelse>
    brelse(to);
801039b9:	89 34 24             	mov    %esi,(%esp)
801039bc:	e8 2f c8 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801039c1:	83 c4 10             	add    $0x10,%esp
801039c4:	3b 1d a8 a7 13 80    	cmp    0x8013a7a8,%ebx
801039ca:	7c 94                	jl     80103960 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801039cc:	e8 7f fd ff ff       	call   80103750 <write_head>
    install_trans(); // Now install writes to home locations
801039d1:	e8 da fc ff ff       	call   801036b0 <install_trans>
    log.lh.n = 0;
801039d6:	c7 05 a8 a7 13 80 00 	movl   $0x0,0x8013a7a8
801039dd:	00 00 00 
    write_head();    // Erase the transaction from the log
801039e0:	e8 6b fd ff ff       	call   80103750 <write_head>
801039e5:	e9 38 ff ff ff       	jmp    80103922 <end_op+0x62>
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801039f0:	83 ec 0c             	sub    $0xc,%esp
801039f3:	68 60 a7 13 80       	push   $0x8013a760
801039f8:	e8 73 12 00 00       	call   80104c70 <wakeup>
  release(&log.lock);
801039fd:	c7 04 24 60 a7 13 80 	movl   $0x8013a760,(%esp)
80103a04:	e8 a7 17 00 00       	call   801051b0 <release>
80103a09:	83 c4 10             	add    $0x10,%esp
}
80103a0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a0f:	5b                   	pop    %ebx
80103a10:	5e                   	pop    %esi
80103a11:	5f                   	pop    %edi
80103a12:	5d                   	pop    %ebp
80103a13:	c3                   	ret    
    panic("log.committing");
80103a14:	83 ec 0c             	sub    $0xc,%esp
80103a17:	68 e4 8b 10 80       	push   $0x80108be4
80103a1c:	e8 6f c9 ff ff       	call   80100390 <panic>
80103a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a2f:	90                   	nop

80103a30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103a30:	f3 0f 1e fb          	endbr32 
80103a34:	55                   	push   %ebp
80103a35:	89 e5                	mov    %esp,%ebp
80103a37:	53                   	push   %ebx
80103a38:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103a3b:	8b 15 a8 a7 13 80    	mov    0x8013a7a8,%edx
{
80103a41:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103a44:	83 fa 1d             	cmp    $0x1d,%edx
80103a47:	0f 8f 91 00 00 00    	jg     80103ade <log_write+0xae>
80103a4d:	a1 98 a7 13 80       	mov    0x8013a798,%eax
80103a52:	83 e8 01             	sub    $0x1,%eax
80103a55:	39 c2                	cmp    %eax,%edx
80103a57:	0f 8d 81 00 00 00    	jge    80103ade <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103a5d:	a1 9c a7 13 80       	mov    0x8013a79c,%eax
80103a62:	85 c0                	test   %eax,%eax
80103a64:	0f 8e 81 00 00 00    	jle    80103aeb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	68 60 a7 13 80       	push   $0x8013a760
80103a72:	e8 79 16 00 00       	call   801050f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103a77:	8b 15 a8 a7 13 80    	mov    0x8013a7a8,%edx
80103a7d:	83 c4 10             	add    $0x10,%esp
80103a80:	85 d2                	test   %edx,%edx
80103a82:	7e 4e                	jle    80103ad2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103a84:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103a87:	31 c0                	xor    %eax,%eax
80103a89:	eb 0c                	jmp    80103a97 <log_write+0x67>
80103a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a8f:	90                   	nop
80103a90:	83 c0 01             	add    $0x1,%eax
80103a93:	39 c2                	cmp    %eax,%edx
80103a95:	74 29                	je     80103ac0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103a97:	39 0c 85 ac a7 13 80 	cmp    %ecx,-0x7fec5854(,%eax,4)
80103a9e:	75 f0                	jne    80103a90 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103aa0:	89 0c 85 ac a7 13 80 	mov    %ecx,-0x7fec5854(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103aa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80103aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103aad:	c7 45 08 60 a7 13 80 	movl   $0x8013a760,0x8(%ebp)
}
80103ab4:	c9                   	leave  
  release(&log.lock);
80103ab5:	e9 f6 16 00 00       	jmp    801051b0 <release>
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103ac0:	89 0c 95 ac a7 13 80 	mov    %ecx,-0x7fec5854(,%edx,4)
    log.lh.n++;
80103ac7:	83 c2 01             	add    $0x1,%edx
80103aca:	89 15 a8 a7 13 80    	mov    %edx,0x8013a7a8
80103ad0:	eb d5                	jmp    80103aa7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103ad2:	8b 43 08             	mov    0x8(%ebx),%eax
80103ad5:	a3 ac a7 13 80       	mov    %eax,0x8013a7ac
  if (i == log.lh.n)
80103ada:	75 cb                	jne    80103aa7 <log_write+0x77>
80103adc:	eb e9                	jmp    80103ac7 <log_write+0x97>
    panic("too big a transaction");
80103ade:	83 ec 0c             	sub    $0xc,%esp
80103ae1:	68 f3 8b 10 80       	push   $0x80108bf3
80103ae6:	e8 a5 c8 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103aeb:	83 ec 0c             	sub    $0xc,%esp
80103aee:	68 09 8c 10 80       	push   $0x80108c09
80103af3:	e8 98 c8 ff ff       	call   80100390 <panic>
80103af8:	66 90                	xchg   %ax,%ax
80103afa:	66 90                	xchg   %ax,%ax
80103afc:	66 90                	xchg   %ax,%ax
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
80103b04:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103b07:	e8 a4 09 00 00       	call   801044b0 <cpuid>
80103b0c:	89 c3                	mov    %eax,%ebx
80103b0e:	e8 9d 09 00 00       	call   801044b0 <cpuid>
80103b13:	83 ec 04             	sub    $0x4,%esp
80103b16:	53                   	push   %ebx
80103b17:	50                   	push   %eax
80103b18:	68 24 8c 10 80       	push   $0x80108c24
80103b1d:	e8 8e cb ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103b22:	e8 a9 2a 00 00       	call   801065d0 <idtinit>
  cprintf("mpmain-1\n");
80103b27:	c7 04 24 38 8c 10 80 	movl   $0x80108c38,(%esp)
80103b2e:	e8 7d cb ff ff       	call   801006b0 <cprintf>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103b33:	e8 08 09 00 00       	call   80104440 <mycpu>
80103b38:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
80103b3a:	b8 01 00 00 00       	mov    $0x1,%eax
80103b3f:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  cprintf("mpmain-2\n");
80103b46:	c7 04 24 42 8c 10 80 	movl   $0x80108c42,(%esp)
80103b4d:	e8 5e cb ff ff       	call   801006b0 <cprintf>
  scheduler();     // start running processes
80103b52:	e8 69 0c 00 00       	call   801047c0 <scheduler>
80103b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <mpenter>:
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103b6a:	e8 c1 3c 00 00       	call   80107830 <switchkvm>
  seginit();
80103b6f:	e8 4c 3a 00 00       	call   801075c0 <seginit>
  lapicinit();
80103b74:	e8 47 f7 ff ff       	call   801032c0 <lapicinit>
  mpmain();
80103b79:	e8 82 ff ff ff       	call   80103b00 <mpmain>
80103b7e:	66 90                	xchg   %ax,%ax

80103b80 <main>:
{
80103b80:	f3 0f 1e fb          	endbr32 
80103b84:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103b88:	83 e4 f0             	and    $0xfffffff0,%esp
80103b8b:	ff 71 fc             	pushl  -0x4(%ecx)
80103b8e:	55                   	push   %ebp
80103b8f:	89 e5                	mov    %esp,%ebp
80103b91:	53                   	push   %ebx
80103b92:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103b93:	83 ec 08             	sub    $0x8,%esp
80103b96:	68 00 00 40 80       	push   $0x80400000
80103b9b:	68 88 d5 13 80       	push   $0x8013d588
80103ba0:	e8 0b f2 ff ff       	call   80102db0 <kinit1>
  kvmalloc();      // kernel page table
80103ba5:	e8 16 42 00 00       	call   80107dc0 <kvmalloc>
  mpinit();        // detect other processors
80103baa:	e8 b1 01 00 00       	call   80103d60 <mpinit>
  lapicinit();     // interrupt controller
80103baf:	e8 0c f7 ff ff       	call   801032c0 <lapicinit>
  seginit();       // segment descriptors
80103bb4:	e8 07 3a 00 00       	call   801075c0 <seginit>
  picinit();       // disable pic
80103bb9:	e8 82 03 00 00       	call   80103f40 <picinit>
  ioapicinit();    // another interrupt controller
80103bbe:	e8 dd e8 ff ff       	call   801024a0 <ioapicinit>
  consoleinit();   // console hardware
80103bc3:	e8 68 ce ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103bc8:	e8 73 2e 00 00       	call   80106a40 <uartinit>
  pinit();         // process table
80103bcd:	e8 4e 08 00 00       	call   80104420 <pinit>
  tvinit();        // trap vectors
80103bd2:	e8 79 29 00 00       	call   80106550 <tvinit>
  binit();         // buffer cache
80103bd7:	e8 64 c4 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103bdc:	e8 ff d1 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103be1:	e8 8a e6 ff ff       	call   80102270 <ideinit>
  cprintf("main-1\n");
80103be6:	c7 04 24 3a 8c 10 80 	movl   $0x80108c3a,(%esp)
80103bed:	e8 be ca ff ff       	call   801006b0 <cprintf>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103bf2:	83 c4 0c             	add    $0xc,%esp
80103bf5:	68 8a 00 00 00       	push   $0x8a
80103bfa:	68 8c c4 10 80       	push   $0x8010c48c
80103bff:	68 00 70 00 80       	push   $0x80007000
80103c04:	e8 97 16 00 00       	call   801052a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103c09:	83 c4 10             	add    $0x10,%esp
80103c0c:	69 05 e0 ad 13 80 b0 	imul   $0xb0,0x8013ade0,%eax
80103c13:	00 00 00 
80103c16:	05 60 a8 13 80       	add    $0x8013a860,%eax
80103c1b:	3d 60 a8 13 80       	cmp    $0x8013a860,%eax
80103c20:	76 7e                	jbe    80103ca0 <main+0x120>
80103c22:	bb 60 a8 13 80       	mov    $0x8013a860,%ebx
80103c27:	eb 20                	jmp    80103c49 <main+0xc9>
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c30:	69 05 e0 ad 13 80 b0 	imul   $0xb0,0x8013ade0,%eax
80103c37:	00 00 00 
80103c3a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103c40:	05 60 a8 13 80       	add    $0x8013a860,%eax
80103c45:	39 c3                	cmp    %eax,%ebx
80103c47:	73 57                	jae    80103ca0 <main+0x120>
    if(c == mycpu())  // We've started already.
80103c49:	e8 f2 07 00 00       	call   80104440 <mycpu>
80103c4e:	39 c3                	cmp    %eax,%ebx
80103c50:	74 de                	je     80103c30 <main+0xb0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103c52:	e8 f9 f4 ff ff       	call   80103150 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103c57:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103c5a:	c7 05 f8 6f 00 80 60 	movl   $0x80103b60,0x80006ff8
80103c61:	3b 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103c64:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103c6b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103c6e:	05 00 10 00 00       	add    $0x1000,%eax
80103c73:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103c78:	0f b6 03             	movzbl (%ebx),%eax
80103c7b:	68 00 70 00 00       	push   $0x7000
80103c80:	50                   	push   %eax
80103c81:	e8 8a f7 ff ff       	call   80103410 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103c86:	83 c4 10             	add    $0x10,%esp
80103c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c90:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103c96:	85 c0                	test   %eax,%eax
80103c98:	74 f6                	je     80103c90 <main+0x110>
80103c9a:	eb 94                	jmp    80103c30 <main+0xb0>
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  cprintf("main-2\n");
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	68 44 8c 10 80       	push   $0x80108c44
80103ca8:	e8 03 ca ff ff       	call   801006b0 <cprintf>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103cad:	58                   	pop    %eax
80103cae:	5a                   	pop    %edx
80103caf:	68 00 00 60 80       	push   $0x80600000
80103cb4:	68 00 00 40 80       	push   $0x80400000
80103cb9:	e8 62 f1 ff ff       	call   80102e20 <kinit2>
  cprintf("main-3\n");
80103cbe:	c7 04 24 4c 8c 10 80 	movl   $0x80108c4c,(%esp)
80103cc5:	e8 e6 c9 ff ff       	call   801006b0 <cprintf>
  userinit();      // first user process
80103cca:	e8 31 08 00 00       	call   80104500 <userinit>
  cprintf("main-4\n");
80103ccf:	c7 04 24 54 8c 10 80 	movl   $0x80108c54,(%esp)
80103cd6:	e8 d5 c9 ff ff       	call   801006b0 <cprintf>
  mpmain();        // finish this processor's setup
80103cdb:	e8 20 fe ff ff       	call   80103b00 <mpmain>

80103ce0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103ce5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103ceb:	53                   	push   %ebx
  e = addr+len;
80103cec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103cef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103cf2:	39 de                	cmp    %ebx,%esi
80103cf4:	72 10                	jb     80103d06 <mpsearch1+0x26>
80103cf6:	eb 50                	jmp    80103d48 <mpsearch1+0x68>
80103cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop
80103d00:	89 fe                	mov    %edi,%esi
80103d02:	39 fb                	cmp    %edi,%ebx
80103d04:	76 42                	jbe    80103d48 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103d06:	83 ec 04             	sub    $0x4,%esp
80103d09:	8d 7e 10             	lea    0x10(%esi),%edi
80103d0c:	6a 04                	push   $0x4
80103d0e:	68 5c 8c 10 80       	push   $0x80108c5c
80103d13:	56                   	push   %esi
80103d14:	e8 37 15 00 00       	call   80105250 <memcmp>
80103d19:	83 c4 10             	add    $0x10,%esp
80103d1c:	85 c0                	test   %eax,%eax
80103d1e:	75 e0                	jne    80103d00 <mpsearch1+0x20>
80103d20:	89 f2                	mov    %esi,%edx
80103d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103d28:	0f b6 0a             	movzbl (%edx),%ecx
80103d2b:	83 c2 01             	add    $0x1,%edx
80103d2e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103d30:	39 fa                	cmp    %edi,%edx
80103d32:	75 f4                	jne    80103d28 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103d34:	84 c0                	test   %al,%al
80103d36:	75 c8                	jne    80103d00 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d3b:	89 f0                	mov    %esi,%eax
80103d3d:	5b                   	pop    %ebx
80103d3e:	5e                   	pop    %esi
80103d3f:	5f                   	pop    %edi
80103d40:	5d                   	pop    %ebp
80103d41:	c3                   	ret    
80103d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d4b:	31 f6                	xor    %esi,%esi
}
80103d4d:	5b                   	pop    %ebx
80103d4e:	89 f0                	mov    %esi,%eax
80103d50:	5e                   	pop    %esi
80103d51:	5f                   	pop    %edi
80103d52:	5d                   	pop    %ebp
80103d53:	c3                   	ret    
80103d54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d5f:	90                   	nop

80103d60 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103d60:	f3 0f 1e fb          	endbr32 
80103d64:	55                   	push   %ebp
80103d65:	89 e5                	mov    %esp,%ebp
80103d67:	57                   	push   %edi
80103d68:	56                   	push   %esi
80103d69:	53                   	push   %ebx
80103d6a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103d6d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103d74:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103d7b:	c1 e0 08             	shl    $0x8,%eax
80103d7e:	09 d0                	or     %edx,%eax
80103d80:	c1 e0 04             	shl    $0x4,%eax
80103d83:	75 1b                	jne    80103da0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d85:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103d8c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103d93:	c1 e0 08             	shl    $0x8,%eax
80103d96:	09 d0                	or     %edx,%eax
80103d98:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103d9b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103da0:	ba 00 04 00 00       	mov    $0x400,%edx
80103da5:	e8 36 ff ff ff       	call   80103ce0 <mpsearch1>
80103daa:	89 c6                	mov    %eax,%esi
80103dac:	85 c0                	test   %eax,%eax
80103dae:	0f 84 4c 01 00 00    	je     80103f00 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103db4:	8b 5e 04             	mov    0x4(%esi),%ebx
80103db7:	85 db                	test   %ebx,%ebx
80103db9:	0f 84 61 01 00 00    	je     80103f20 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103dbf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103dc2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103dc8:	6a 04                	push   $0x4
80103dca:	68 61 8c 10 80       	push   $0x80108c61
80103dcf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103dd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103dd3:	e8 78 14 00 00       	call   80105250 <memcmp>
80103dd8:	83 c4 10             	add    $0x10,%esp
80103ddb:	85 c0                	test   %eax,%eax
80103ddd:	0f 85 3d 01 00 00    	jne    80103f20 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103de3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103dea:	3c 01                	cmp    $0x1,%al
80103dec:	74 08                	je     80103df6 <mpinit+0x96>
80103dee:	3c 04                	cmp    $0x4,%al
80103df0:	0f 85 2a 01 00 00    	jne    80103f20 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103df6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103dfd:	66 85 d2             	test   %dx,%dx
80103e00:	74 26                	je     80103e28 <mpinit+0xc8>
80103e02:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103e05:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103e07:	31 d2                	xor    %edx,%edx
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103e10:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103e17:	83 c0 01             	add    $0x1,%eax
80103e1a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103e1c:	39 f8                	cmp    %edi,%eax
80103e1e:	75 f0                	jne    80103e10 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103e20:	84 d2                	test   %dl,%dl
80103e22:	0f 85 f8 00 00 00    	jne    80103f20 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103e28:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103e2e:	a3 58 a7 13 80       	mov    %eax,0x8013a758
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e33:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103e39:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103e40:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e45:	03 55 e4             	add    -0x1c(%ebp),%edx
80103e48:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop
80103e50:	39 c2                	cmp    %eax,%edx
80103e52:	76 15                	jbe    80103e69 <mpinit+0x109>
    switch(*p){
80103e54:	0f b6 08             	movzbl (%eax),%ecx
80103e57:	80 f9 02             	cmp    $0x2,%cl
80103e5a:	74 5c                	je     80103eb8 <mpinit+0x158>
80103e5c:	77 42                	ja     80103ea0 <mpinit+0x140>
80103e5e:	84 c9                	test   %cl,%cl
80103e60:	74 6e                	je     80103ed0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e62:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e65:	39 c2                	cmp    %eax,%edx
80103e67:	77 eb                	ja     80103e54 <mpinit+0xf4>
80103e69:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103e6c:	85 db                	test   %ebx,%ebx
80103e6e:	0f 84 b9 00 00 00    	je     80103f2d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103e74:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103e78:	74 15                	je     80103e8f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e7a:	b8 70 00 00 00       	mov    $0x70,%eax
80103e7f:	ba 22 00 00 00       	mov    $0x22,%edx
80103e84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e85:	ba 23 00 00 00       	mov    $0x23,%edx
80103e8a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e8b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e8e:	ee                   	out    %al,(%dx)
  }
}
80103e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e92:	5b                   	pop    %ebx
80103e93:	5e                   	pop    %esi
80103e94:	5f                   	pop    %edi
80103e95:	5d                   	pop    %ebp
80103e96:	c3                   	ret    
80103e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103ea0:	83 e9 03             	sub    $0x3,%ecx
80103ea3:	80 f9 01             	cmp    $0x1,%cl
80103ea6:	76 ba                	jbe    80103e62 <mpinit+0x102>
80103ea8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103eaf:	eb 9f                	jmp    80103e50 <mpinit+0xf0>
80103eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103eb8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103ebc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103ebf:	88 0d 40 a8 13 80    	mov    %cl,0x8013a840
      continue;
80103ec5:	eb 89                	jmp    80103e50 <mpinit+0xf0>
80103ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ece:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103ed0:	8b 0d e0 ad 13 80    	mov    0x8013ade0,%ecx
80103ed6:	83 f9 07             	cmp    $0x7,%ecx
80103ed9:	7f 19                	jg     80103ef4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103edb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103ee1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103ee5:	83 c1 01             	add    $0x1,%ecx
80103ee8:	89 0d e0 ad 13 80    	mov    %ecx,0x8013ade0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103eee:	88 9f 60 a8 13 80    	mov    %bl,-0x7fec57a0(%edi)
      p += sizeof(struct mpproc);
80103ef4:	83 c0 14             	add    $0x14,%eax
      continue;
80103ef7:	e9 54 ff ff ff       	jmp    80103e50 <mpinit+0xf0>
80103efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103f00:	ba 00 00 01 00       	mov    $0x10000,%edx
80103f05:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103f0a:	e8 d1 fd ff ff       	call   80103ce0 <mpsearch1>
80103f0f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f11:	85 c0                	test   %eax,%eax
80103f13:	0f 85 9b fe ff ff    	jne    80103db4 <mpinit+0x54>
80103f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	68 66 8c 10 80       	push   $0x80108c66
80103f28:	e8 63 c4 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103f2d:	83 ec 0c             	sub    $0xc,%esp
80103f30:	68 80 8c 10 80       	push   $0x80108c80
80103f35:	e8 56 c4 ff ff       	call   80100390 <panic>
80103f3a:	66 90                	xchg   %ax,%ax
80103f3c:	66 90                	xchg   %ax,%ax
80103f3e:	66 90                	xchg   %ax,%ax

80103f40 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f49:	ba 21 00 00 00       	mov    $0x21,%edx
80103f4e:	ee                   	out    %al,(%dx)
80103f4f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103f54:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103f55:	c3                   	ret    
80103f56:	66 90                	xchg   %ax,%ax
80103f58:	66 90                	xchg   %ax,%ax
80103f5a:	66 90                	xchg   %ax,%ax
80103f5c:	66 90                	xchg   %ax,%ax
80103f5e:	66 90                	xchg   %ax,%ax

80103f60 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	57                   	push   %edi
80103f68:	56                   	push   %esi
80103f69:	53                   	push   %ebx
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f70:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103f73:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f79:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f7f:	e8 7c ce ff ff       	call   80100e00 <filealloc>
80103f84:	89 03                	mov    %eax,(%ebx)
80103f86:	85 c0                	test   %eax,%eax
80103f88:	0f 84 ac 00 00 00    	je     8010403a <pipealloc+0xda>
80103f8e:	e8 6d ce ff ff       	call   80100e00 <filealloc>
80103f93:	89 06                	mov    %eax,(%esi)
80103f95:	85 c0                	test   %eax,%eax
80103f97:	0f 84 8b 00 00 00    	je     80104028 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f9d:	e8 ae f1 ff ff       	call   80103150 <kalloc>
80103fa2:	89 c7                	mov    %eax,%edi
80103fa4:	85 c0                	test   %eax,%eax
80103fa6:	0f 84 b4 00 00 00    	je     80104060 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103fac:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103fb3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103fb6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103fb9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fc0:	00 00 00 
  p->nwrite = 0;
80103fc3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fca:	00 00 00 
  p->nread = 0;
80103fcd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fd4:	00 00 00 
  initlock(&p->lock, "pipe");
80103fd7:	68 9f 8c 10 80       	push   $0x80108c9f
80103fdc:	50                   	push   %eax
80103fdd:	e8 8e 0f 00 00       	call   80104f70 <initlock>
  (*f0)->type = FD_PIPE;
80103fe2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103fe4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103fe7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103fed:	8b 03                	mov    (%ebx),%eax
80103fef:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ff3:	8b 03                	mov    (%ebx),%eax
80103ff5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ff9:	8b 03                	mov    (%ebx),%eax
80103ffb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ffe:	8b 06                	mov    (%esi),%eax
80104000:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104006:	8b 06                	mov    (%esi),%eax
80104008:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010400c:	8b 06                	mov    (%esi),%eax
8010400e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104012:	8b 06                	mov    (%esi),%eax
80104014:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80104017:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010401a:	31 c0                	xor    %eax,%eax
}
8010401c:	5b                   	pop    %ebx
8010401d:	5e                   	pop    %esi
8010401e:	5f                   	pop    %edi
8010401f:	5d                   	pop    %ebp
80104020:	c3                   	ret    
80104021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104028:	8b 03                	mov    (%ebx),%eax
8010402a:	85 c0                	test   %eax,%eax
8010402c:	74 1e                	je     8010404c <pipealloc+0xec>
    fileclose(*f0);
8010402e:	83 ec 0c             	sub    $0xc,%esp
80104031:	50                   	push   %eax
80104032:	e8 89 ce ff ff       	call   80100ec0 <fileclose>
80104037:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010403a:	8b 06                	mov    (%esi),%eax
8010403c:	85 c0                	test   %eax,%eax
8010403e:	74 0c                	je     8010404c <pipealloc+0xec>
    fileclose(*f1);
80104040:	83 ec 0c             	sub    $0xc,%esp
80104043:	50                   	push   %eax
80104044:	e8 77 ce ff ff       	call   80100ec0 <fileclose>
80104049:	83 c4 10             	add    $0x10,%esp
}
8010404c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010404f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104054:	5b                   	pop    %ebx
80104055:	5e                   	pop    %esi
80104056:	5f                   	pop    %edi
80104057:	5d                   	pop    %ebp
80104058:	c3                   	ret    
80104059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104060:	8b 03                	mov    (%ebx),%eax
80104062:	85 c0                	test   %eax,%eax
80104064:	75 c8                	jne    8010402e <pipealloc+0xce>
80104066:	eb d2                	jmp    8010403a <pipealloc+0xda>
80104068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406f:	90                   	nop

80104070 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104070:	f3 0f 1e fb          	endbr32 
80104074:	55                   	push   %ebp
80104075:	89 e5                	mov    %esp,%ebp
80104077:	56                   	push   %esi
80104078:	53                   	push   %ebx
80104079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010407c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010407f:	83 ec 0c             	sub    $0xc,%esp
80104082:	53                   	push   %ebx
80104083:	e8 68 10 00 00       	call   801050f0 <acquire>
  if(writable){
80104088:	83 c4 10             	add    $0x10,%esp
8010408b:	85 f6                	test   %esi,%esi
8010408d:	74 41                	je     801040d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010408f:	83 ec 0c             	sub    $0xc,%esp
80104092:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104098:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010409f:	00 00 00 
    wakeup(&p->nread);
801040a2:	50                   	push   %eax
801040a3:	e8 c8 0b 00 00       	call   80104c70 <wakeup>
801040a8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040ab:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801040b1:	85 d2                	test   %edx,%edx
801040b3:	75 0a                	jne    801040bf <pipeclose+0x4f>
801040b5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801040bb:	85 c0                	test   %eax,%eax
801040bd:	74 31                	je     801040f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801040bf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801040c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040c5:	5b                   	pop    %ebx
801040c6:	5e                   	pop    %esi
801040c7:	5d                   	pop    %ebp
    release(&p->lock);
801040c8:	e9 e3 10 00 00       	jmp    801051b0 <release>
801040cd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801040d0:	83 ec 0c             	sub    $0xc,%esp
801040d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801040d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801040e0:	00 00 00 
    wakeup(&p->nwrite);
801040e3:	50                   	push   %eax
801040e4:	e8 87 0b 00 00       	call   80104c70 <wakeup>
801040e9:	83 c4 10             	add    $0x10,%esp
801040ec:	eb bd                	jmp    801040ab <pipeclose+0x3b>
801040ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801040f0:	83 ec 0c             	sub    $0xc,%esp
801040f3:	53                   	push   %ebx
801040f4:	e8 b7 10 00 00       	call   801051b0 <release>
    kfree((char*)p);
801040f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801040fc:	83 c4 10             	add    $0x10,%esp
}
801040ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104102:	5b                   	pop    %ebx
80104103:	5e                   	pop    %esi
80104104:	5d                   	pop    %ebp
    kfree((char*)p);
80104105:	e9 b6 ea ff ff       	jmp    80102bc0 <kfree>
8010410a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104110 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80104110:	f3 0f 1e fb          	endbr32 
80104114:	55                   	push   %ebp
80104115:	89 e5                	mov    %esp,%ebp
80104117:	57                   	push   %edi
80104118:	56                   	push   %esi
80104119:	53                   	push   %ebx
8010411a:	83 ec 28             	sub    $0x28,%esp
8010411d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80104120:	53                   	push   %ebx
80104121:	e8 ca 0f 00 00       	call   801050f0 <acquire>
  for(i = 0; i < n; i++){
80104126:	8b 45 10             	mov    0x10(%ebp),%eax
80104129:	83 c4 10             	add    $0x10,%esp
8010412c:	85 c0                	test   %eax,%eax
8010412e:	0f 8e bc 00 00 00    	jle    801041f0 <pipewrite+0xe0>
80104134:	8b 45 0c             	mov    0xc(%ebp),%eax
80104137:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010413d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80104143:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104146:	03 45 10             	add    0x10(%ebp),%eax
80104149:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010414c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104152:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104158:	89 ca                	mov    %ecx,%edx
8010415a:	05 00 02 00 00       	add    $0x200,%eax
8010415f:	39 c1                	cmp    %eax,%ecx
80104161:	74 3b                	je     8010419e <pipewrite+0x8e>
80104163:	eb 63                	jmp    801041c8 <pipewrite+0xb8>
80104165:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80104168:	e8 63 03 00 00       	call   801044d0 <myproc>
8010416d:	8b 48 24             	mov    0x24(%eax),%ecx
80104170:	85 c9                	test   %ecx,%ecx
80104172:	75 34                	jne    801041a8 <pipewrite+0x98>
      wakeup(&p->nread);
80104174:	83 ec 0c             	sub    $0xc,%esp
80104177:	57                   	push   %edi
80104178:	e8 f3 0a 00 00       	call   80104c70 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010417d:	58                   	pop    %eax
8010417e:	5a                   	pop    %edx
8010417f:	53                   	push   %ebx
80104180:	56                   	push   %esi
80104181:	e8 2a 09 00 00       	call   80104ab0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104186:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010418c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104192:	83 c4 10             	add    $0x10,%esp
80104195:	05 00 02 00 00       	add    $0x200,%eax
8010419a:	39 c2                	cmp    %eax,%edx
8010419c:	75 2a                	jne    801041c8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010419e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801041a4:	85 c0                	test   %eax,%eax
801041a6:	75 c0                	jne    80104168 <pipewrite+0x58>
        release(&p->lock);
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	53                   	push   %ebx
801041ac:	e8 ff 0f 00 00       	call   801051b0 <release>
        return -1;
801041b1:	83 c4 10             	add    $0x10,%esp
801041b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801041b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041bc:	5b                   	pop    %ebx
801041bd:	5e                   	pop    %esi
801041be:	5f                   	pop    %edi
801041bf:	5d                   	pop    %ebp
801041c0:	c3                   	ret    
801041c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801041c8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801041cb:	8d 4a 01             	lea    0x1(%edx),%ecx
801041ce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801041d4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801041da:	0f b6 06             	movzbl (%esi),%eax
801041dd:	83 c6 01             	add    $0x1,%esi
801041e0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801041e3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801041e7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801041ea:	0f 85 5c ff ff ff    	jne    8010414c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801041f9:	50                   	push   %eax
801041fa:	e8 71 0a 00 00       	call   80104c70 <wakeup>
  release(&p->lock);
801041ff:	89 1c 24             	mov    %ebx,(%esp)
80104202:	e8 a9 0f 00 00       	call   801051b0 <release>
  return n;
80104207:	8b 45 10             	mov    0x10(%ebp),%eax
8010420a:	83 c4 10             	add    $0x10,%esp
8010420d:	eb aa                	jmp    801041b9 <pipewrite+0xa9>
8010420f:	90                   	nop

80104210 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104210:	f3 0f 1e fb          	endbr32 
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	57                   	push   %edi
80104218:	56                   	push   %esi
80104219:	53                   	push   %ebx
8010421a:	83 ec 18             	sub    $0x18,%esp
8010421d:	8b 75 08             	mov    0x8(%ebp),%esi
80104220:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104223:	56                   	push   %esi
80104224:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010422a:	e8 c1 0e 00 00       	call   801050f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010422f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104235:	83 c4 10             	add    $0x10,%esp
80104238:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010423e:	74 33                	je     80104273 <piperead+0x63>
80104240:	eb 3b                	jmp    8010427d <piperead+0x6d>
80104242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80104248:	e8 83 02 00 00       	call   801044d0 <myproc>
8010424d:	8b 48 24             	mov    0x24(%eax),%ecx
80104250:	85 c9                	test   %ecx,%ecx
80104252:	0f 85 88 00 00 00    	jne    801042e0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104258:	83 ec 08             	sub    $0x8,%esp
8010425b:	56                   	push   %esi
8010425c:	53                   	push   %ebx
8010425d:	e8 4e 08 00 00       	call   80104ab0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104262:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104268:	83 c4 10             	add    $0x10,%esp
8010426b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104271:	75 0a                	jne    8010427d <piperead+0x6d>
80104273:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104279:	85 c0                	test   %eax,%eax
8010427b:	75 cb                	jne    80104248 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010427d:	8b 55 10             	mov    0x10(%ebp),%edx
80104280:	31 db                	xor    %ebx,%ebx
80104282:	85 d2                	test   %edx,%edx
80104284:	7f 28                	jg     801042ae <piperead+0x9e>
80104286:	eb 34                	jmp    801042bc <piperead+0xac>
80104288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104290:	8d 48 01             	lea    0x1(%eax),%ecx
80104293:	25 ff 01 00 00       	and    $0x1ff,%eax
80104298:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010429e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801042a3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042a6:	83 c3 01             	add    $0x1,%ebx
801042a9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801042ac:	74 0e                	je     801042bc <piperead+0xac>
    if(p->nread == p->nwrite)
801042ae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801042b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801042ba:	75 d4                	jne    80104290 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042bc:	83 ec 0c             	sub    $0xc,%esp
801042bf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801042c5:	50                   	push   %eax
801042c6:	e8 a5 09 00 00       	call   80104c70 <wakeup>
  release(&p->lock);
801042cb:	89 34 24             	mov    %esi,(%esp)
801042ce:	e8 dd 0e 00 00       	call   801051b0 <release>
  return i;
801042d3:	83 c4 10             	add    $0x10,%esp
}
801042d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d9:	89 d8                	mov    %ebx,%eax
801042db:	5b                   	pop    %ebx
801042dc:	5e                   	pop    %esi
801042dd:	5f                   	pop    %edi
801042de:	5d                   	pop    %ebp
801042df:	c3                   	ret    
      release(&p->lock);
801042e0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801042e8:	56                   	push   %esi
801042e9:	e8 c2 0e 00 00       	call   801051b0 <release>
      return -1;
801042ee:	83 c4 10             	add    $0x10,%esp
}
801042f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f4:	89 d8                	mov    %ebx,%eax
801042f6:	5b                   	pop    %ebx
801042f7:	5e                   	pop    %esi
801042f8:	5f                   	pop    %edi
801042f9:	5d                   	pop    %ebp
801042fa:	c3                   	ret    
801042fb:	66 90                	xchg   %ax,%ax
801042fd:	66 90                	xchg   %ax,%ax
801042ff:	90                   	nop

80104300 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104304:	bb 34 ae 13 80       	mov    $0x8013ae34,%ebx
{
80104309:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010430c:	68 00 ae 13 80       	push   $0x8013ae00
80104311:	e8 da 0d 00 00       	call   801050f0 <acquire>
80104316:	83 c4 10             	add    $0x10,%esp
80104319:	eb 10                	jmp    8010432b <allocproc+0x2b>
8010431b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010431f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104320:	83 c3 7c             	add    $0x7c,%ebx
80104323:	81 fb 34 cd 13 80    	cmp    $0x8013cd34,%ebx
80104329:	74 75                	je     801043a0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010432b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010432e:	85 c0                	test   %eax,%eax
80104330:	75 ee                	jne    80104320 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104332:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80104337:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010433a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104341:	89 43 10             	mov    %eax,0x10(%ebx)
80104344:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104347:	68 00 ae 13 80       	push   $0x8013ae00
  p->pid = nextpid++;
8010434c:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80104352:	e8 59 0e 00 00       	call   801051b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104357:	e8 f4 ed ff ff       	call   80103150 <kalloc>
8010435c:	83 c4 10             	add    $0x10,%esp
8010435f:	89 43 08             	mov    %eax,0x8(%ebx)
80104362:	85 c0                	test   %eax,%eax
80104364:	74 53                	je     801043b9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104366:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010436c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010436f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104374:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104377:	c7 40 14 36 65 10 80 	movl   $0x80106536,0x14(%eax)
  p->context = (struct context*)sp;
8010437e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104381:	6a 14                	push   $0x14
80104383:	6a 00                	push   $0x0
80104385:	50                   	push   %eax
80104386:	e8 75 0e 00 00       	call   80105200 <memset>
  p->context->eip = (uint)forkret;
8010438b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010438e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104391:	c7 40 10 d0 43 10 80 	movl   $0x801043d0,0x10(%eax)
}
80104398:	89 d8                	mov    %ebx,%eax
8010439a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010439d:	c9                   	leave  
8010439e:	c3                   	ret    
8010439f:	90                   	nop
  release(&ptable.lock);
801043a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801043a3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801043a5:	68 00 ae 13 80       	push   $0x8013ae00
801043aa:	e8 01 0e 00 00       	call   801051b0 <release>
}
801043af:	89 d8                	mov    %ebx,%eax
  return 0;
801043b1:	83 c4 10             	add    $0x10,%esp
}
801043b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b7:	c9                   	leave  
801043b8:	c3                   	ret    
    p->state = UNUSED;
801043b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801043c0:	31 db                	xor    %ebx,%ebx
}
801043c2:	89 d8                	mov    %ebx,%eax
801043c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c7:	c9                   	leave  
801043c8:	c3                   	ret    
801043c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801043d0:	f3 0f 1e fb          	endbr32 
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
801043d7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801043da:	68 00 ae 13 80       	push   $0x8013ae00
801043df:	e8 cc 0d 00 00       	call   801051b0 <release>

  if (first) {
801043e4:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801043e9:	83 c4 10             	add    $0x10,%esp
801043ec:	85 c0                	test   %eax,%eax
801043ee:	75 08                	jne    801043f8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801043f0:	c9                   	leave  
801043f1:	c3                   	ret    
801043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801043f8:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801043ff:	00 00 00 
    iinit(ROOTDEV);
80104402:	83 ec 0c             	sub    $0xc,%esp
80104405:	6a 01                	push   $0x1
80104407:	e8 34 d1 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010440c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104413:	e8 98 f3 ff ff       	call   801037b0 <initlog>
}
80104418:	83 c4 10             	add    $0x10,%esp
8010441b:	c9                   	leave  
8010441c:	c3                   	ret    
8010441d:	8d 76 00             	lea    0x0(%esi),%esi

80104420 <pinit>:
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010442a:	68 a4 8c 10 80       	push   $0x80108ca4
8010442f:	68 00 ae 13 80       	push   $0x8013ae00
80104434:	e8 37 0b 00 00       	call   80104f70 <initlock>
}
80104439:	83 c4 10             	add    $0x10,%esp
8010443c:	c9                   	leave  
8010443d:	c3                   	ret    
8010443e:	66 90                	xchg   %ax,%ax

80104440 <mycpu>:
{
80104440:	f3 0f 1e fb          	endbr32 
80104444:	55                   	push   %ebp
80104445:	89 e5                	mov    %esp,%ebp
80104447:	56                   	push   %esi
80104448:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104449:	9c                   	pushf  
8010444a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010444b:	f6 c4 02             	test   $0x2,%ah
8010444e:	75 4a                	jne    8010449a <mycpu+0x5a>
  apicid = lapicid();
80104450:	e8 6b ef ff ff       	call   801033c0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104455:	8b 35 e0 ad 13 80    	mov    0x8013ade0,%esi
  apicid = lapicid();
8010445b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010445d:	85 f6                	test   %esi,%esi
8010445f:	7e 2c                	jle    8010448d <mycpu+0x4d>
80104461:	31 d2                	xor    %edx,%edx
80104463:	eb 0a                	jmp    8010446f <mycpu+0x2f>
80104465:	8d 76 00             	lea    0x0(%esi),%esi
80104468:	83 c2 01             	add    $0x1,%edx
8010446b:	39 f2                	cmp    %esi,%edx
8010446d:	74 1e                	je     8010448d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010446f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104475:	0f b6 81 60 a8 13 80 	movzbl -0x7fec57a0(%ecx),%eax
8010447c:	39 d8                	cmp    %ebx,%eax
8010447e:	75 e8                	jne    80104468 <mycpu+0x28>
}
80104480:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104483:	8d 81 60 a8 13 80    	lea    -0x7fec57a0(%ecx),%eax
}
80104489:	5b                   	pop    %ebx
8010448a:	5e                   	pop    %esi
8010448b:	5d                   	pop    %ebp
8010448c:	c3                   	ret    
  panic("unknown apicid\n");
8010448d:	83 ec 0c             	sub    $0xc,%esp
80104490:	68 ab 8c 10 80       	push   $0x80108cab
80104495:	e8 f6 be ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010449a:	83 ec 0c             	sub    $0xc,%esp
8010449d:	68 88 8d 10 80       	push   $0x80108d88
801044a2:	e8 e9 be ff ff       	call   80100390 <panic>
801044a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ae:	66 90                	xchg   %ax,%ax

801044b0 <cpuid>:
cpuid() {
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801044ba:	e8 81 ff ff ff       	call   80104440 <mycpu>
}
801044bf:	c9                   	leave  
  return mycpu()-cpus;
801044c0:	2d 60 a8 13 80       	sub    $0x8013a860,%eax
801044c5:	c1 f8 04             	sar    $0x4,%eax
801044c8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801044ce:	c3                   	ret    
801044cf:	90                   	nop

801044d0 <myproc>:
myproc(void) {
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	53                   	push   %ebx
801044d8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801044db:	e8 10 0b 00 00       	call   80104ff0 <pushcli>
  c = mycpu();
801044e0:	e8 5b ff ff ff       	call   80104440 <mycpu>
  p = c->proc;
801044e5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044eb:	e8 50 0b 00 00       	call   80105040 <popcli>
}
801044f0:	83 c4 04             	add    $0x4,%esp
801044f3:	89 d8                	mov    %ebx,%eax
801044f5:	5b                   	pop    %ebx
801044f6:	5d                   	pop    %ebp
801044f7:	c3                   	ret    
801044f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ff:	90                   	nop

80104500 <userinit>:
{
80104500:	f3 0f 1e fb          	endbr32 
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	53                   	push   %ebx
80104508:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010450b:	e8 f0 fd ff ff       	call   80104300 <allocproc>
80104510:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104512:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80104517:	e8 24 38 00 00       	call   80107d40 <setupkvm>
8010451c:	89 43 04             	mov    %eax,0x4(%ebx)
8010451f:	85 c0                	test   %eax,%eax
80104521:	0f 84 e5 00 00 00    	je     8010460c <userinit+0x10c>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80104527:	83 ec 04             	sub    $0x4,%esp
8010452a:	68 2c 00 00 00       	push   $0x2c
8010452f:	68 60 c4 10 80       	push   $0x8010c460
80104534:	68 19 84 10 80       	push   $0x80108419
80104539:	e8 72 c1 ff ff       	call   801006b0 <cprintf>
  cprintf("userinit: call inituvm p->pgdir %p\n", p->pgdir);
8010453e:	58                   	pop    %eax
8010453f:	5a                   	pop    %edx
80104540:	ff 73 04             	pushl  0x4(%ebx)
80104543:	68 b0 8d 10 80       	push   $0x80108db0
80104548:	e8 63 c1 ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010454d:	83 c4 0c             	add    $0xc,%esp
80104550:	68 2c 00 00 00       	push   $0x2c
80104555:	68 60 c4 10 80       	push   $0x8010c460
8010455a:	ff 73 04             	pushl  0x4(%ebx)
8010455d:	e8 fe 33 00 00       	call   80107960 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104562:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104565:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010456b:	6a 4c                	push   $0x4c
8010456d:	6a 00                	push   $0x0
8010456f:	ff 73 18             	pushl  0x18(%ebx)
80104572:	e8 89 0c 00 00       	call   80105200 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104577:	8b 43 18             	mov    0x18(%ebx),%eax
8010457a:	b9 1b 00 00 00       	mov    $0x1b,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010457f:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104582:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104587:	66 89 48 3c          	mov    %cx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010458b:	8b 43 18             	mov    0x18(%ebx),%eax
8010458e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104592:	8b 43 18             	mov    0x18(%ebx),%eax
80104595:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104599:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010459d:	8b 43 18             	mov    0x18(%ebx),%eax
801045a0:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801045a4:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045a8:	8b 43 18             	mov    0x18(%ebx),%eax
801045ab:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045b2:	8b 43 18             	mov    0x18(%ebx),%eax
801045b5:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045bc:	8b 43 18             	mov    0x18(%ebx),%eax
801045bf:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801045c6:	8d 43 6c             	lea    0x6c(%ebx),%eax
801045c9:	6a 10                	push   $0x10
801045cb:	68 d4 8c 10 80       	push   $0x80108cd4
801045d0:	50                   	push   %eax
801045d1:	e8 ea 0d 00 00       	call   801053c0 <safestrcpy>
  p->cwd = namei("/");
801045d6:	c7 04 24 dd 8c 10 80 	movl   $0x80108cdd,(%esp)
801045dd:	e8 4e da ff ff       	call   80102030 <namei>
801045e2:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801045e5:	c7 04 24 00 ae 13 80 	movl   $0x8013ae00,(%esp)
801045ec:	e8 ff 0a 00 00       	call   801050f0 <acquire>
  p->state = RUNNABLE;
801045f1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801045f8:	c7 04 24 00 ae 13 80 	movl   $0x8013ae00,(%esp)
801045ff:	e8 ac 0b 00 00       	call   801051b0 <release>
}
80104604:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104607:	83 c4 10             	add    $0x10,%esp
8010460a:	c9                   	leave  
8010460b:	c3                   	ret    
    panic("userinit: out of memory?");
8010460c:	83 ec 0c             	sub    $0xc,%esp
8010460f:	68 bb 8c 10 80       	push   $0x80108cbb
80104614:	e8 77 bd ff ff       	call   80100390 <panic>
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <growproc>:
{
80104620:	f3 0f 1e fb          	endbr32 
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	56                   	push   %esi
80104628:	53                   	push   %ebx
80104629:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010462c:	e8 bf 09 00 00       	call   80104ff0 <pushcli>
  c = mycpu();
80104631:	e8 0a fe ff ff       	call   80104440 <mycpu>
  p = c->proc;
80104636:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010463c:	e8 ff 09 00 00       	call   80105040 <popcli>
  sz = curproc->sz;
80104641:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104643:	85 f6                	test   %esi,%esi
80104645:	7f 19                	jg     80104660 <growproc+0x40>
  } else if(n < 0){
80104647:	75 37                	jne    80104680 <growproc+0x60>
  switchuvm(curproc);
80104649:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010464c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010464e:	53                   	push   %ebx
8010464f:	e8 fc 31 00 00       	call   80107850 <switchuvm>
  return 0;
80104654:	83 c4 10             	add    $0x10,%esp
80104657:	31 c0                	xor    %eax,%eax
}
80104659:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010465c:	5b                   	pop    %ebx
8010465d:	5e                   	pop    %esi
8010465e:	5d                   	pop    %ebp
8010465f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104660:	83 ec 04             	sub    $0x4,%esp
80104663:	01 c6                	add    %eax,%esi
80104665:	56                   	push   %esi
80104666:	50                   	push   %eax
80104667:	ff 73 04             	pushl  0x4(%ebx)
8010466a:	e8 91 34 00 00       	call   80107b00 <allocuvm>
8010466f:	83 c4 10             	add    $0x10,%esp
80104672:	85 c0                	test   %eax,%eax
80104674:	75 d3                	jne    80104649 <growproc+0x29>
      return -1;
80104676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010467b:	eb dc                	jmp    80104659 <growproc+0x39>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104680:	83 ec 04             	sub    $0x4,%esp
80104683:	01 c6                	add    %eax,%esi
80104685:	56                   	push   %esi
80104686:	50                   	push   %eax
80104687:	ff 73 04             	pushl  0x4(%ebx)
8010468a:	e8 01 36 00 00       	call   80107c90 <deallocuvm>
8010468f:	83 c4 10             	add    $0x10,%esp
80104692:	85 c0                	test   %eax,%eax
80104694:	75 b3                	jne    80104649 <growproc+0x29>
80104696:	eb de                	jmp    80104676 <growproc+0x56>
80104698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469f:	90                   	nop

801046a0 <fork>:
{
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	57                   	push   %edi
801046a8:	56                   	push   %esi
801046a9:	53                   	push   %ebx
801046aa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801046ad:	e8 3e 09 00 00       	call   80104ff0 <pushcli>
  c = mycpu();
801046b2:	e8 89 fd ff ff       	call   80104440 <mycpu>
  p = c->proc;
801046b7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046bd:	e8 7e 09 00 00       	call   80105040 <popcli>
  if((np = allocproc()) == 0){
801046c2:	e8 39 fc ff ff       	call   80104300 <allocproc>
801046c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801046ca:	85 c0                	test   %eax,%eax
801046cc:	0f 84 bb 00 00 00    	je     8010478d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801046d2:	83 ec 08             	sub    $0x8,%esp
801046d5:	ff 33                	pushl  (%ebx)
801046d7:	89 c7                	mov    %eax,%edi
801046d9:	ff 73 04             	pushl  0x4(%ebx)
801046dc:	e8 2f 37 00 00       	call   80107e10 <copyuvm>
801046e1:	83 c4 10             	add    $0x10,%esp
801046e4:	89 47 04             	mov    %eax,0x4(%edi)
801046e7:	85 c0                	test   %eax,%eax
801046e9:	0f 84 a5 00 00 00    	je     80104794 <fork+0xf4>
  np->sz = curproc->sz;
801046ef:	8b 03                	mov    (%ebx),%eax
801046f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801046f4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801046f6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801046f9:	89 c8                	mov    %ecx,%eax
801046fb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801046fe:	b9 13 00 00 00       	mov    $0x13,%ecx
80104703:	8b 73 18             	mov    0x18(%ebx),%esi
80104706:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104708:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010470a:	8b 40 18             	mov    0x18(%eax),%eax
8010470d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104718:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010471c:	85 c0                	test   %eax,%eax
8010471e:	74 13                	je     80104733 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104720:	83 ec 0c             	sub    $0xc,%esp
80104723:	50                   	push   %eax
80104724:	e8 47 c7 ff ff       	call   80100e70 <filedup>
80104729:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010472c:	83 c4 10             	add    $0x10,%esp
8010472f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104733:	83 c6 01             	add    $0x1,%esi
80104736:	83 fe 10             	cmp    $0x10,%esi
80104739:	75 dd                	jne    80104718 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010473b:	83 ec 0c             	sub    $0xc,%esp
8010473e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104741:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104744:	e8 e7 cf ff ff       	call   80101730 <idup>
80104749:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010474c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010474f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104752:	8d 47 6c             	lea    0x6c(%edi),%eax
80104755:	6a 10                	push   $0x10
80104757:	53                   	push   %ebx
80104758:	50                   	push   %eax
80104759:	e8 62 0c 00 00       	call   801053c0 <safestrcpy>
  pid = np->pid;
8010475e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104761:	c7 04 24 00 ae 13 80 	movl   $0x8013ae00,(%esp)
80104768:	e8 83 09 00 00       	call   801050f0 <acquire>
  np->state = RUNNABLE;
8010476d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104774:	c7 04 24 00 ae 13 80 	movl   $0x8013ae00,(%esp)
8010477b:	e8 30 0a 00 00       	call   801051b0 <release>
  return pid;
80104780:	83 c4 10             	add    $0x10,%esp
}
80104783:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104786:	89 d8                	mov    %ebx,%eax
80104788:	5b                   	pop    %ebx
80104789:	5e                   	pop    %esi
8010478a:	5f                   	pop    %edi
8010478b:	5d                   	pop    %ebp
8010478c:	c3                   	ret    
    return -1;
8010478d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104792:	eb ef                	jmp    80104783 <fork+0xe3>
    kfree(np->kstack);
80104794:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104797:	83 ec 0c             	sub    $0xc,%esp
8010479a:	ff 73 08             	pushl  0x8(%ebx)
8010479d:	e8 1e e4 ff ff       	call   80102bc0 <kfree>
    np->kstack = 0;
801047a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801047a9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801047ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801047b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047b8:	eb c9                	jmp    80104783 <fork+0xe3>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <scheduler>:
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	57                   	push   %edi
801047c8:	56                   	push   %esi
801047c9:	53                   	push   %ebx
801047ca:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801047cd:	e8 6e fc ff ff       	call   80104440 <mycpu>
  c->proc = 0;
801047d2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047d9:	00 00 00 
  struct cpu *c = mycpu();
801047dc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801047de:	8d 78 04             	lea    0x4(%eax),%edi
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801047e8:	fb                   	sti    
    acquire(&ptable.lock);
801047e9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047ec:	bb 34 ae 13 80       	mov    $0x8013ae34,%ebx
    acquire(&ptable.lock);
801047f1:	68 00 ae 13 80       	push   $0x8013ae00
801047f6:	e8 f5 08 00 00       	call   801050f0 <acquire>
801047fb:	83 c4 10             	add    $0x10,%esp
801047fe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104800:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104804:	75 33                	jne    80104839 <scheduler+0x79>
      switchuvm(p);
80104806:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104809:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010480f:	53                   	push   %ebx
80104810:	e8 3b 30 00 00       	call   80107850 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104815:	58                   	pop    %eax
80104816:	5a                   	pop    %edx
80104817:	ff 73 1c             	pushl  0x1c(%ebx)
8010481a:	57                   	push   %edi
      p->state = RUNNING;
8010481b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104822:	e8 fc 0b 00 00       	call   80105423 <swtch>
      switchkvm();
80104827:	e8 04 30 00 00       	call   80107830 <switchkvm>
      c->proc = 0;
8010482c:	83 c4 10             	add    $0x10,%esp
8010482f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104836:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104839:	83 c3 7c             	add    $0x7c,%ebx
8010483c:	81 fb 34 cd 13 80    	cmp    $0x8013cd34,%ebx
80104842:	75 bc                	jne    80104800 <scheduler+0x40>
    release(&ptable.lock);
80104844:	83 ec 0c             	sub    $0xc,%esp
80104847:	68 00 ae 13 80       	push   $0x8013ae00
8010484c:	e8 5f 09 00 00       	call   801051b0 <release>
    sti();
80104851:	83 c4 10             	add    $0x10,%esp
80104854:	eb 92                	jmp    801047e8 <scheduler+0x28>
80104856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485d:	8d 76 00             	lea    0x0(%esi),%esi

80104860 <sched>:
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	56                   	push   %esi
80104868:	53                   	push   %ebx
  pushcli();
80104869:	e8 82 07 00 00       	call   80104ff0 <pushcli>
  c = mycpu();
8010486e:	e8 cd fb ff ff       	call   80104440 <mycpu>
  p = c->proc;
80104873:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104879:	e8 c2 07 00 00       	call   80105040 <popcli>
  if(!holding(&ptable.lock))
8010487e:	83 ec 0c             	sub    $0xc,%esp
80104881:	68 00 ae 13 80       	push   $0x8013ae00
80104886:	e8 15 08 00 00       	call   801050a0 <holding>
8010488b:	83 c4 10             	add    $0x10,%esp
8010488e:	85 c0                	test   %eax,%eax
80104890:	74 4f                	je     801048e1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104892:	e8 a9 fb ff ff       	call   80104440 <mycpu>
80104897:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010489e:	75 68                	jne    80104908 <sched+0xa8>
  if(p->state == RUNNING)
801048a0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801048a4:	74 55                	je     801048fb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048a6:	9c                   	pushf  
801048a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048a8:	f6 c4 02             	test   $0x2,%ah
801048ab:	75 41                	jne    801048ee <sched+0x8e>
  intena = mycpu()->intena;
801048ad:	e8 8e fb ff ff       	call   80104440 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801048b2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801048b5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801048bb:	e8 80 fb ff ff       	call   80104440 <mycpu>
801048c0:	83 ec 08             	sub    $0x8,%esp
801048c3:	ff 70 04             	pushl  0x4(%eax)
801048c6:	53                   	push   %ebx
801048c7:	e8 57 0b 00 00       	call   80105423 <swtch>
  mycpu()->intena = intena;
801048cc:	e8 6f fb ff ff       	call   80104440 <mycpu>
}
801048d1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801048d4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801048da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048dd:	5b                   	pop    %ebx
801048de:	5e                   	pop    %esi
801048df:	5d                   	pop    %ebp
801048e0:	c3                   	ret    
    panic("sched ptable.lock");
801048e1:	83 ec 0c             	sub    $0xc,%esp
801048e4:	68 df 8c 10 80       	push   $0x80108cdf
801048e9:	e8 a2 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801048ee:	83 ec 0c             	sub    $0xc,%esp
801048f1:	68 0b 8d 10 80       	push   $0x80108d0b
801048f6:	e8 95 ba ff ff       	call   80100390 <panic>
    panic("sched running");
801048fb:	83 ec 0c             	sub    $0xc,%esp
801048fe:	68 fd 8c 10 80       	push   $0x80108cfd
80104903:	e8 88 ba ff ff       	call   80100390 <panic>
    panic("sched locks");
80104908:	83 ec 0c             	sub    $0xc,%esp
8010490b:	68 f1 8c 10 80       	push   $0x80108cf1
80104910:	e8 7b ba ff ff       	call   80100390 <panic>
80104915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104920 <exit>:
{
80104920:	f3 0f 1e fb          	endbr32 
80104924:	55                   	push   %ebp
80104925:	89 e5                	mov    %esp,%ebp
80104927:	57                   	push   %edi
80104928:	56                   	push   %esi
80104929:	53                   	push   %ebx
8010492a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010492d:	e8 be 06 00 00       	call   80104ff0 <pushcli>
  c = mycpu();
80104932:	e8 09 fb ff ff       	call   80104440 <mycpu>
  p = c->proc;
80104937:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010493d:	e8 fe 06 00 00       	call   80105040 <popcli>
  if(curproc == initproc)
80104942:	8d 5e 28             	lea    0x28(%esi),%ebx
80104945:	8d 7e 68             	lea    0x68(%esi),%edi
80104948:	39 35 b8 c5 10 80    	cmp    %esi,0x8010c5b8
8010494e:	0f 84 f3 00 00 00    	je     80104a47 <exit+0x127>
80104954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104958:	8b 03                	mov    (%ebx),%eax
8010495a:	85 c0                	test   %eax,%eax
8010495c:	74 12                	je     80104970 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010495e:	83 ec 0c             	sub    $0xc,%esp
80104961:	50                   	push   %eax
80104962:	e8 59 c5 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104967:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010496d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104970:	83 c3 04             	add    $0x4,%ebx
80104973:	39 df                	cmp    %ebx,%edi
80104975:	75 e1                	jne    80104958 <exit+0x38>
  begin_op();
80104977:	e8 d4 ee ff ff       	call   80103850 <begin_op>
  iput(curproc->cwd);
8010497c:	83 ec 0c             	sub    $0xc,%esp
8010497f:	ff 76 68             	pushl  0x68(%esi)
80104982:	e8 09 cf ff ff       	call   80101890 <iput>
  end_op();
80104987:	e8 34 ef ff ff       	call   801038c0 <end_op>
  curproc->cwd = 0;
8010498c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104993:	c7 04 24 00 ae 13 80 	movl   $0x8013ae00,(%esp)
8010499a:	e8 51 07 00 00       	call   801050f0 <acquire>
  wakeup1(curproc->parent);
8010499f:	8b 56 14             	mov    0x14(%esi),%edx
801049a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049a5:	b8 34 ae 13 80       	mov    $0x8013ae34,%eax
801049aa:	eb 0e                	jmp    801049ba <exit+0x9a>
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049b0:	83 c0 7c             	add    $0x7c,%eax
801049b3:	3d 34 cd 13 80       	cmp    $0x8013cd34,%eax
801049b8:	74 1c                	je     801049d6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801049ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049be:	75 f0                	jne    801049b0 <exit+0x90>
801049c0:	3b 50 20             	cmp    0x20(%eax),%edx
801049c3:	75 eb                	jne    801049b0 <exit+0x90>
      p->state = RUNNABLE;
801049c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049cc:	83 c0 7c             	add    $0x7c,%eax
801049cf:	3d 34 cd 13 80       	cmp    $0x8013cd34,%eax
801049d4:	75 e4                	jne    801049ba <exit+0x9a>
      p->parent = initproc;
801049d6:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049dc:	ba 34 ae 13 80       	mov    $0x8013ae34,%edx
801049e1:	eb 10                	jmp    801049f3 <exit+0xd3>
801049e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e7:	90                   	nop
801049e8:	83 c2 7c             	add    $0x7c,%edx
801049eb:	81 fa 34 cd 13 80    	cmp    $0x8013cd34,%edx
801049f1:	74 3b                	je     80104a2e <exit+0x10e>
    if(p->parent == curproc){
801049f3:	39 72 14             	cmp    %esi,0x14(%edx)
801049f6:	75 f0                	jne    801049e8 <exit+0xc8>
      if(p->state == ZOMBIE)
801049f8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801049fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801049ff:	75 e7                	jne    801049e8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a01:	b8 34 ae 13 80       	mov    $0x8013ae34,%eax
80104a06:	eb 12                	jmp    80104a1a <exit+0xfa>
80104a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop
80104a10:	83 c0 7c             	add    $0x7c,%eax
80104a13:	3d 34 cd 13 80       	cmp    $0x8013cd34,%eax
80104a18:	74 ce                	je     801049e8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80104a1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a1e:	75 f0                	jne    80104a10 <exit+0xf0>
80104a20:	3b 48 20             	cmp    0x20(%eax),%ecx
80104a23:	75 eb                	jne    80104a10 <exit+0xf0>
      p->state = RUNNABLE;
80104a25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a2c:	eb e2                	jmp    80104a10 <exit+0xf0>
  curproc->state = ZOMBIE;
80104a2e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104a35:	e8 26 fe ff ff       	call   80104860 <sched>
  panic("zombie exit");
80104a3a:	83 ec 0c             	sub    $0xc,%esp
80104a3d:	68 2c 8d 10 80       	push   $0x80108d2c
80104a42:	e8 49 b9 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104a47:	83 ec 0c             	sub    $0xc,%esp
80104a4a:	68 1f 8d 10 80       	push   $0x80108d1f
80104a4f:	e8 3c b9 ff ff       	call   80100390 <panic>
80104a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a5f:	90                   	nop

80104a60 <yield>:
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	53                   	push   %ebx
80104a68:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a6b:	68 00 ae 13 80       	push   $0x8013ae00
80104a70:	e8 7b 06 00 00       	call   801050f0 <acquire>
  pushcli();
80104a75:	e8 76 05 00 00       	call   80104ff0 <pushcli>
  c = mycpu();
80104a7a:	e8 c1 f9 ff ff       	call   80104440 <mycpu>
  p = c->proc;
80104a7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a85:	e8 b6 05 00 00       	call   80105040 <popcli>
  myproc()->state = RUNNABLE;
80104a8a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104a91:	e8 ca fd ff ff       	call   80104860 <sched>
  release(&ptable.lock);
80104a96:	c7 04 24 00 ae 13 80 	movl   $0x8013ae00,(%esp)
80104a9d:	e8 0e 07 00 00       	call   801051b0 <release>
}
80104aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa5:	83 c4 10             	add    $0x10,%esp
80104aa8:	c9                   	leave  
80104aa9:	c3                   	ret    
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ab0 <sleep>:
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	57                   	push   %edi
80104ab8:	56                   	push   %esi
80104ab9:	53                   	push   %ebx
80104aba:	83 ec 0c             	sub    $0xc,%esp
80104abd:	8b 7d 08             	mov    0x8(%ebp),%edi
80104ac0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104ac3:	e8 28 05 00 00       	call   80104ff0 <pushcli>
  c = mycpu();
80104ac8:	e8 73 f9 ff ff       	call   80104440 <mycpu>
  p = c->proc;
80104acd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ad3:	e8 68 05 00 00       	call   80105040 <popcli>
  if(p == 0)
80104ad8:	85 db                	test   %ebx,%ebx
80104ada:	0f 84 83 00 00 00    	je     80104b63 <sleep+0xb3>
  if(lk == 0)
80104ae0:	85 f6                	test   %esi,%esi
80104ae2:	74 72                	je     80104b56 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ae4:	81 fe 00 ae 13 80    	cmp    $0x8013ae00,%esi
80104aea:	74 4c                	je     80104b38 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104aec:	83 ec 0c             	sub    $0xc,%esp
80104aef:	68 00 ae 13 80       	push   $0x8013ae00
80104af4:	e8 f7 05 00 00       	call   801050f0 <acquire>
    release(lk);
80104af9:	89 34 24             	mov    %esi,(%esp)
80104afc:	e8 af 06 00 00       	call   801051b0 <release>
  p->chan = chan;
80104b01:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b04:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b0b:	e8 50 fd ff ff       	call   80104860 <sched>
  p->chan = 0;
80104b10:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b17:	c7 04 24 00 ae 13 80 	movl   $0x8013ae00,(%esp)
80104b1e:	e8 8d 06 00 00       	call   801051b0 <release>
    acquire(lk);
80104b23:	89 75 08             	mov    %esi,0x8(%ebp)
80104b26:	83 c4 10             	add    $0x10,%esp
}
80104b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b2c:	5b                   	pop    %ebx
80104b2d:	5e                   	pop    %esi
80104b2e:	5f                   	pop    %edi
80104b2f:	5d                   	pop    %ebp
    acquire(lk);
80104b30:	e9 bb 05 00 00       	jmp    801050f0 <acquire>
80104b35:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104b38:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b3b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b42:	e8 19 fd ff ff       	call   80104860 <sched>
  p->chan = 0;
80104b47:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b51:	5b                   	pop    %ebx
80104b52:	5e                   	pop    %esi
80104b53:	5f                   	pop    %edi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
    panic("sleep without lk");
80104b56:	83 ec 0c             	sub    $0xc,%esp
80104b59:	68 3e 8d 10 80       	push   $0x80108d3e
80104b5e:	e8 2d b8 ff ff       	call   80100390 <panic>
    panic("sleep");
80104b63:	83 ec 0c             	sub    $0xc,%esp
80104b66:	68 38 8d 10 80       	push   $0x80108d38
80104b6b:	e8 20 b8 ff ff       	call   80100390 <panic>

80104b70 <wait>:
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	56                   	push   %esi
80104b78:	53                   	push   %ebx
  pushcli();
80104b79:	e8 72 04 00 00       	call   80104ff0 <pushcli>
  c = mycpu();
80104b7e:	e8 bd f8 ff ff       	call   80104440 <mycpu>
  p = c->proc;
80104b83:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b89:	e8 b2 04 00 00       	call   80105040 <popcli>
  acquire(&ptable.lock);
80104b8e:	83 ec 0c             	sub    $0xc,%esp
80104b91:	68 00 ae 13 80       	push   $0x8013ae00
80104b96:	e8 55 05 00 00       	call   801050f0 <acquire>
80104b9b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b9e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ba0:	bb 34 ae 13 80       	mov    $0x8013ae34,%ebx
80104ba5:	eb 14                	jmp    80104bbb <wait+0x4b>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax
80104bb0:	83 c3 7c             	add    $0x7c,%ebx
80104bb3:	81 fb 34 cd 13 80    	cmp    $0x8013cd34,%ebx
80104bb9:	74 1b                	je     80104bd6 <wait+0x66>
      if(p->parent != curproc)
80104bbb:	39 73 14             	cmp    %esi,0x14(%ebx)
80104bbe:	75 f0                	jne    80104bb0 <wait+0x40>
      if(p->state == ZOMBIE){
80104bc0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104bc4:	74 32                	je     80104bf8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104bc9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bce:	81 fb 34 cd 13 80    	cmp    $0x8013cd34,%ebx
80104bd4:	75 e5                	jne    80104bbb <wait+0x4b>
    if(!havekids || curproc->killed){
80104bd6:	85 c0                	test   %eax,%eax
80104bd8:	74 74                	je     80104c4e <wait+0xde>
80104bda:	8b 46 24             	mov    0x24(%esi),%eax
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	75 6d                	jne    80104c4e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104be1:	83 ec 08             	sub    $0x8,%esp
80104be4:	68 00 ae 13 80       	push   $0x8013ae00
80104be9:	56                   	push   %esi
80104bea:	e8 c1 fe ff ff       	call   80104ab0 <sleep>
    havekids = 0;
80104bef:	83 c4 10             	add    $0x10,%esp
80104bf2:	eb aa                	jmp    80104b9e <wait+0x2e>
80104bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104bfe:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104c01:	e8 ba df ff ff       	call   80102bc0 <kfree>
        freevm(p->pgdir);
80104c06:	5a                   	pop    %edx
80104c07:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104c0a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104c11:	e8 aa 30 00 00       	call   80107cc0 <freevm>
        release(&ptable.lock);
80104c16:	c7 04 24 00 ae 13 80 	movl   $0x8013ae00,(%esp)
        p->pid = 0;
80104c1d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104c24:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104c2b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c2f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104c36:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104c3d:	e8 6e 05 00 00       	call   801051b0 <release>
        return pid;
80104c42:	83 c4 10             	add    $0x10,%esp
}
80104c45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c48:	89 f0                	mov    %esi,%eax
80104c4a:	5b                   	pop    %ebx
80104c4b:	5e                   	pop    %esi
80104c4c:	5d                   	pop    %ebp
80104c4d:	c3                   	ret    
      release(&ptable.lock);
80104c4e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104c51:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104c56:	68 00 ae 13 80       	push   $0x8013ae00
80104c5b:	e8 50 05 00 00       	call   801051b0 <release>
      return -1;
80104c60:	83 c4 10             	add    $0x10,%esp
80104c63:	eb e0                	jmp    80104c45 <wait+0xd5>
80104c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c70 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	53                   	push   %ebx
80104c78:	83 ec 10             	sub    $0x10,%esp
80104c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104c7e:	68 00 ae 13 80       	push   $0x8013ae00
80104c83:	e8 68 04 00 00       	call   801050f0 <acquire>
80104c88:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c8b:	b8 34 ae 13 80       	mov    $0x8013ae34,%eax
80104c90:	eb 10                	jmp    80104ca2 <wakeup+0x32>
80104c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c98:	83 c0 7c             	add    $0x7c,%eax
80104c9b:	3d 34 cd 13 80       	cmp    $0x8013cd34,%eax
80104ca0:	74 1c                	je     80104cbe <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104ca2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104ca6:	75 f0                	jne    80104c98 <wakeup+0x28>
80104ca8:	3b 58 20             	cmp    0x20(%eax),%ebx
80104cab:	75 eb                	jne    80104c98 <wakeup+0x28>
      p->state = RUNNABLE;
80104cad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cb4:	83 c0 7c             	add    $0x7c,%eax
80104cb7:	3d 34 cd 13 80       	cmp    $0x8013cd34,%eax
80104cbc:	75 e4                	jne    80104ca2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
80104cbe:	c7 45 08 00 ae 13 80 	movl   $0x8013ae00,0x8(%ebp)
}
80104cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc8:	c9                   	leave  
  release(&ptable.lock);
80104cc9:	e9 e2 04 00 00       	jmp    801051b0 <release>
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	53                   	push   %ebx
80104cd8:	83 ec 10             	sub    $0x10,%esp
80104cdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104cde:	68 00 ae 13 80       	push   $0x8013ae00
80104ce3:	e8 08 04 00 00       	call   801050f0 <acquire>
80104ce8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ceb:	b8 34 ae 13 80       	mov    $0x8013ae34,%eax
80104cf0:	eb 10                	jmp    80104d02 <kill+0x32>
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf8:	83 c0 7c             	add    $0x7c,%eax
80104cfb:	3d 34 cd 13 80       	cmp    $0x8013cd34,%eax
80104d00:	74 36                	je     80104d38 <kill+0x68>
    if(p->pid == pid){
80104d02:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d05:	75 f1                	jne    80104cf8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d07:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104d0b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104d12:	75 07                	jne    80104d1b <kill+0x4b>
        p->state = RUNNABLE;
80104d14:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d1b:	83 ec 0c             	sub    $0xc,%esp
80104d1e:	68 00 ae 13 80       	push   $0x8013ae00
80104d23:	e8 88 04 00 00       	call   801051b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104d28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104d2b:	83 c4 10             	add    $0x10,%esp
80104d2e:	31 c0                	xor    %eax,%eax
}
80104d30:	c9                   	leave  
80104d31:	c3                   	ret    
80104d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	68 00 ae 13 80       	push   $0x8013ae00
80104d40:	e8 6b 04 00 00       	call   801051b0 <release>
}
80104d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104d48:	83 c4 10             	add    $0x10,%esp
80104d4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d50:	c9                   	leave  
80104d51:	c3                   	ret    
80104d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d60 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104d60:	f3 0f 1e fb          	endbr32 
80104d64:	55                   	push   %ebp
80104d65:	89 e5                	mov    %esp,%ebp
80104d67:	57                   	push   %edi
80104d68:	56                   	push   %esi
80104d69:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104d6c:	53                   	push   %ebx
80104d6d:	bb a0 ae 13 80       	mov    $0x8013aea0,%ebx
80104d72:	83 ec 3c             	sub    $0x3c,%esp
80104d75:	eb 28                	jmp    80104d9f <procdump+0x3f>
80104d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104d80:	83 ec 0c             	sub    $0xc,%esp
80104d83:	68 3a 83 10 80       	push   $0x8010833a
80104d88:	e8 23 b9 ff ff       	call   801006b0 <cprintf>
80104d8d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d90:	83 c3 7c             	add    $0x7c,%ebx
80104d93:	81 fb a0 cd 13 80    	cmp    $0x8013cda0,%ebx
80104d99:	0f 84 81 00 00 00    	je     80104e20 <procdump+0xc0>
    if(p->state == UNUSED)
80104d9f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104da2:	85 c0                	test   %eax,%eax
80104da4:	74 ea                	je     80104d90 <procdump+0x30>
      state = "???";
80104da6:	ba 4f 8d 10 80       	mov    $0x80108d4f,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104dab:	83 f8 05             	cmp    $0x5,%eax
80104dae:	77 11                	ja     80104dc1 <procdump+0x61>
80104db0:	8b 14 85 d4 8d 10 80 	mov    -0x7fef722c(,%eax,4),%edx
      state = "???";
80104db7:	b8 4f 8d 10 80       	mov    $0x80108d4f,%eax
80104dbc:	85 d2                	test   %edx,%edx
80104dbe:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104dc1:	53                   	push   %ebx
80104dc2:	52                   	push   %edx
80104dc3:	ff 73 a4             	pushl  -0x5c(%ebx)
80104dc6:	68 53 8d 10 80       	push   $0x80108d53
80104dcb:	e8 e0 b8 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104dd0:	83 c4 10             	add    $0x10,%esp
80104dd3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104dd7:	75 a7                	jne    80104d80 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104dd9:	83 ec 08             	sub    $0x8,%esp
80104ddc:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104ddf:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104de2:	50                   	push   %eax
80104de3:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104de6:	8b 40 0c             	mov    0xc(%eax),%eax
80104de9:	83 c0 08             	add    $0x8,%eax
80104dec:	50                   	push   %eax
80104ded:	e8 9e 01 00 00       	call   80104f90 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104df2:	83 c4 10             	add    $0x10,%esp
80104df5:	8d 76 00             	lea    0x0(%esi),%esi
80104df8:	8b 17                	mov    (%edi),%edx
80104dfa:	85 d2                	test   %edx,%edx
80104dfc:	74 82                	je     80104d80 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104dfe:	83 ec 08             	sub    $0x8,%esp
80104e01:	83 c7 04             	add    $0x4,%edi
80104e04:	52                   	push   %edx
80104e05:	68 41 80 10 80       	push   $0x80108041
80104e0a:	e8 a1 b8 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	39 fe                	cmp    %edi,%esi
80104e14:	75 e2                	jne    80104df8 <procdump+0x98>
80104e16:	e9 65 ff ff ff       	jmp    80104d80 <procdump+0x20>
80104e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop
  }
}
80104e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e23:	5b                   	pop    %ebx
80104e24:	5e                   	pop    %esi
80104e25:	5f                   	pop    %edi
80104e26:	5d                   	pop    %ebp
80104e27:	c3                   	ret    
80104e28:	66 90                	xchg   %ax,%ax
80104e2a:	66 90                	xchg   %ax,%ax
80104e2c:	66 90                	xchg   %ax,%ax
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	53                   	push   %ebx
80104e38:	83 ec 0c             	sub    $0xc,%esp
80104e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104e3e:	68 ec 8d 10 80       	push   $0x80108dec
80104e43:	8d 43 04             	lea    0x4(%ebx),%eax
80104e46:	50                   	push   %eax
80104e47:	e8 24 01 00 00       	call   80104f70 <initlock>
  lk->name = name;
80104e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104e4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104e55:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104e58:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104e5f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
80104e75:	89 e5                	mov    %esp,%ebp
80104e77:	56                   	push   %esi
80104e78:	53                   	push   %ebx
80104e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e7c:	8d 73 04             	lea    0x4(%ebx),%esi
80104e7f:	83 ec 0c             	sub    $0xc,%esp
80104e82:	56                   	push   %esi
80104e83:	e8 68 02 00 00       	call   801050f0 <acquire>
  while (lk->locked) {
80104e88:	8b 13                	mov    (%ebx),%edx
80104e8a:	83 c4 10             	add    $0x10,%esp
80104e8d:	85 d2                	test   %edx,%edx
80104e8f:	74 1a                	je     80104eab <acquiresleep+0x3b>
80104e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104e98:	83 ec 08             	sub    $0x8,%esp
80104e9b:	56                   	push   %esi
80104e9c:	53                   	push   %ebx
80104e9d:	e8 0e fc ff ff       	call   80104ab0 <sleep>
  while (lk->locked) {
80104ea2:	8b 03                	mov    (%ebx),%eax
80104ea4:	83 c4 10             	add    $0x10,%esp
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	75 ed                	jne    80104e98 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104eab:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104eb1:	e8 1a f6 ff ff       	call   801044d0 <myproc>
80104eb6:	8b 40 10             	mov    0x10(%eax),%eax
80104eb9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ebc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec2:	5b                   	pop    %ebx
80104ec3:	5e                   	pop    %esi
80104ec4:	5d                   	pop    %ebp
  release(&lk->lk);
80104ec5:	e9 e6 02 00 00       	jmp    801051b0 <release>
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ed0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	56                   	push   %esi
80104ed8:	53                   	push   %ebx
80104ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104edc:	8d 73 04             	lea    0x4(%ebx),%esi
80104edf:	83 ec 0c             	sub    $0xc,%esp
80104ee2:	56                   	push   %esi
80104ee3:	e8 08 02 00 00       	call   801050f0 <acquire>
  lk->locked = 0;
80104ee8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104eee:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ef5:	89 1c 24             	mov    %ebx,(%esp)
80104ef8:	e8 73 fd ff ff       	call   80104c70 <wakeup>
  release(&lk->lk);
80104efd:	89 75 08             	mov    %esi,0x8(%ebp)
80104f00:	83 c4 10             	add    $0x10,%esp
}
80104f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f06:	5b                   	pop    %ebx
80104f07:	5e                   	pop    %esi
80104f08:	5d                   	pop    %ebp
  release(&lk->lk);
80104f09:	e9 a2 02 00 00       	jmp    801051b0 <release>
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	57                   	push   %edi
80104f18:	31 ff                	xor    %edi,%edi
80104f1a:	56                   	push   %esi
80104f1b:	53                   	push   %ebx
80104f1c:	83 ec 18             	sub    $0x18,%esp
80104f1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104f22:	8d 73 04             	lea    0x4(%ebx),%esi
80104f25:	56                   	push   %esi
80104f26:	e8 c5 01 00 00       	call   801050f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104f2b:	8b 03                	mov    (%ebx),%eax
80104f2d:	83 c4 10             	add    $0x10,%esp
80104f30:	85 c0                	test   %eax,%eax
80104f32:	75 1c                	jne    80104f50 <holdingsleep+0x40>
  release(&lk->lk);
80104f34:	83 ec 0c             	sub    $0xc,%esp
80104f37:	56                   	push   %esi
80104f38:	e8 73 02 00 00       	call   801051b0 <release>
  return r;
}
80104f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f40:	89 f8                	mov    %edi,%eax
80104f42:	5b                   	pop    %ebx
80104f43:	5e                   	pop    %esi
80104f44:	5f                   	pop    %edi
80104f45:	5d                   	pop    %ebp
80104f46:	c3                   	ret    
80104f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104f50:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104f53:	e8 78 f5 ff ff       	call   801044d0 <myproc>
80104f58:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f5b:	0f 94 c0             	sete   %al
80104f5e:	0f b6 c0             	movzbl %al,%eax
80104f61:	89 c7                	mov    %eax,%edi
80104f63:	eb cf                	jmp    80104f34 <holdingsleep+0x24>
80104f65:	66 90                	xchg   %ax,%ax
80104f67:	66 90                	xchg   %ax,%ax
80104f69:	66 90                	xchg   %ax,%ax
80104f6b:	66 90                	xchg   %ax,%ax
80104f6d:	66 90                	xchg   %ax,%ax
80104f6f:	90                   	nop

80104f70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104f7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104f83:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104f86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f8d:	5d                   	pop    %ebp
80104f8e:	c3                   	ret    
80104f8f:	90                   	nop

80104f90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f95:	31 d2                	xor    %edx,%edx
{
80104f97:	89 e5                	mov    %esp,%ebp
80104f99:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104f9a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104fa0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fa7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fa8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104fae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104fb4:	77 1a                	ja     80104fd0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104fb6:	8b 58 04             	mov    0x4(%eax),%ebx
80104fb9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104fbc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104fbf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104fc1:	83 fa 0a             	cmp    $0xa,%edx
80104fc4:	75 e2                	jne    80104fa8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104fc6:	5b                   	pop    %ebx
80104fc7:	5d                   	pop    %ebp
80104fc8:	c3                   	ret    
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104fd0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104fd3:	8d 51 28             	lea    0x28(%ecx),%edx
80104fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104fe0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104fe6:	83 c0 04             	add    $0x4,%eax
80104fe9:	39 d0                	cmp    %edx,%eax
80104feb:	75 f3                	jne    80104fe0 <getcallerpcs+0x50>
}
80104fed:	5b                   	pop    %ebx
80104fee:	5d                   	pop    %ebp
80104fef:	c3                   	ret    

80104ff0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	53                   	push   %ebx
80104ff8:	83 ec 04             	sub    $0x4,%esp
80104ffb:	9c                   	pushf  
80104ffc:	5b                   	pop    %ebx
  asm volatile("cli");
80104ffd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104ffe:	e8 3d f4 ff ff       	call   80104440 <mycpu>
80105003:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105009:	85 c0                	test   %eax,%eax
8010500b:	74 13                	je     80105020 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010500d:	e8 2e f4 ff ff       	call   80104440 <mycpu>
80105012:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105019:	83 c4 04             	add    $0x4,%esp
8010501c:	5b                   	pop    %ebx
8010501d:	5d                   	pop    %ebp
8010501e:	c3                   	ret    
8010501f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105020:	e8 1b f4 ff ff       	call   80104440 <mycpu>
80105025:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010502b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105031:	eb da                	jmp    8010500d <pushcli+0x1d>
80105033:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105040 <popcli>:

void
popcli(void)
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010504a:	9c                   	pushf  
8010504b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010504c:	f6 c4 02             	test   $0x2,%ah
8010504f:	75 31                	jne    80105082 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105051:	e8 ea f3 ff ff       	call   80104440 <mycpu>
80105056:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010505d:	78 30                	js     8010508f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010505f:	e8 dc f3 ff ff       	call   80104440 <mycpu>
80105064:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010506a:	85 d2                	test   %edx,%edx
8010506c:	74 02                	je     80105070 <popcli+0x30>
    sti();
}
8010506e:	c9                   	leave  
8010506f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105070:	e8 cb f3 ff ff       	call   80104440 <mycpu>
80105075:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010507b:	85 c0                	test   %eax,%eax
8010507d:	74 ef                	je     8010506e <popcli+0x2e>
  asm volatile("sti");
8010507f:	fb                   	sti    
}
80105080:	c9                   	leave  
80105081:	c3                   	ret    
    panic("popcli - interruptible");
80105082:	83 ec 0c             	sub    $0xc,%esp
80105085:	68 f7 8d 10 80       	push   $0x80108df7
8010508a:	e8 01 b3 ff ff       	call   80100390 <panic>
    panic("popcli");
8010508f:	83 ec 0c             	sub    $0xc,%esp
80105092:	68 0e 8e 10 80       	push   $0x80108e0e
80105097:	e8 f4 b2 ff ff       	call   80100390 <panic>
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050a0 <holding>:
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
801050a5:	89 e5                	mov    %esp,%ebp
801050a7:	56                   	push   %esi
801050a8:	53                   	push   %ebx
801050a9:	8b 75 08             	mov    0x8(%ebp),%esi
801050ac:	31 db                	xor    %ebx,%ebx
  pushcli();
801050ae:	e8 3d ff ff ff       	call   80104ff0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801050b3:	8b 06                	mov    (%esi),%eax
801050b5:	85 c0                	test   %eax,%eax
801050b7:	75 0f                	jne    801050c8 <holding+0x28>
  popcli();
801050b9:	e8 82 ff ff ff       	call   80105040 <popcli>
}
801050be:	89 d8                	mov    %ebx,%eax
801050c0:	5b                   	pop    %ebx
801050c1:	5e                   	pop    %esi
801050c2:	5d                   	pop    %ebp
801050c3:	c3                   	ret    
801050c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801050c8:	8b 5e 08             	mov    0x8(%esi),%ebx
801050cb:	e8 70 f3 ff ff       	call   80104440 <mycpu>
801050d0:	39 c3                	cmp    %eax,%ebx
801050d2:	0f 94 c3             	sete   %bl
  popcli();
801050d5:	e8 66 ff ff ff       	call   80105040 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801050da:	0f b6 db             	movzbl %bl,%ebx
}
801050dd:	89 d8                	mov    %ebx,%eax
801050df:	5b                   	pop    %ebx
801050e0:	5e                   	pop    %esi
801050e1:	5d                   	pop    %ebp
801050e2:	c3                   	ret    
801050e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050f0 <acquire>:
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
801050f5:	89 e5                	mov    %esp,%ebp
801050f7:	56                   	push   %esi
801050f8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801050f9:	e8 f2 fe ff ff       	call   80104ff0 <pushcli>
  if(holding(lk))
801050fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105101:	83 ec 0c             	sub    $0xc,%esp
80105104:	53                   	push   %ebx
80105105:	e8 96 ff ff ff       	call   801050a0 <holding>
8010510a:	83 c4 10             	add    $0x10,%esp
8010510d:	85 c0                	test   %eax,%eax
8010510f:	0f 85 7f 00 00 00    	jne    80105194 <acquire+0xa4>
80105115:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105117:	ba 01 00 00 00       	mov    $0x1,%edx
8010511c:	eb 05                	jmp    80105123 <acquire+0x33>
8010511e:	66 90                	xchg   %ax,%ax
80105120:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105123:	89 d0                	mov    %edx,%eax
80105125:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105128:	85 c0                	test   %eax,%eax
8010512a:	75 f4                	jne    80105120 <acquire+0x30>
  __sync_synchronize();
8010512c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105131:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105134:	e8 07 f3 ff ff       	call   80104440 <mycpu>
80105139:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010513c:	89 e8                	mov    %ebp,%eax
8010513e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105140:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105146:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010514c:	77 22                	ja     80105170 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010514e:	8b 50 04             	mov    0x4(%eax),%edx
80105151:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105155:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105158:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010515a:	83 fe 0a             	cmp    $0xa,%esi
8010515d:	75 e1                	jne    80105140 <acquire+0x50>
}
8010515f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105162:	5b                   	pop    %ebx
80105163:	5e                   	pop    %esi
80105164:	5d                   	pop    %ebp
80105165:	c3                   	ret    
80105166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105170:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105174:	83 c3 34             	add    $0x34,%ebx
80105177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105186:	83 c0 04             	add    $0x4,%eax
80105189:	39 d8                	cmp    %ebx,%eax
8010518b:	75 f3                	jne    80105180 <acquire+0x90>
}
8010518d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105190:	5b                   	pop    %ebx
80105191:	5e                   	pop    %esi
80105192:	5d                   	pop    %ebp
80105193:	c3                   	ret    
    panic("acquire");
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	68 15 8e 10 80       	push   $0x80108e15
8010519c:	e8 ef b1 ff ff       	call   80100390 <panic>
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051af:	90                   	nop

801051b0 <release>:
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	53                   	push   %ebx
801051b8:	83 ec 10             	sub    $0x10,%esp
801051bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801051be:	53                   	push   %ebx
801051bf:	e8 dc fe ff ff       	call   801050a0 <holding>
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	85 c0                	test   %eax,%eax
801051c9:	74 22                	je     801051ed <release+0x3d>
  lk->pcs[0] = 0;
801051cb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801051d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801051d9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801051de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801051e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051e7:	c9                   	leave  
  popcli();
801051e8:	e9 53 fe ff ff       	jmp    80105040 <popcli>
    panic("release");
801051ed:	83 ec 0c             	sub    $0xc,%esp
801051f0:	68 1d 8e 10 80       	push   $0x80108e1d
801051f5:	e8 96 b1 ff ff       	call   80100390 <panic>
801051fa:	66 90                	xchg   %ax,%ax
801051fc:	66 90                	xchg   %ax,%ax
801051fe:	66 90                	xchg   %ax,%ax

80105200 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	57                   	push   %edi
80105208:	8b 55 08             	mov    0x8(%ebp),%edx
8010520b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010520e:	53                   	push   %ebx
8010520f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105212:	89 d7                	mov    %edx,%edi
80105214:	09 cf                	or     %ecx,%edi
80105216:	83 e7 03             	and    $0x3,%edi
80105219:	75 25                	jne    80105240 <memset+0x40>
    c &= 0xFF;
8010521b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010521e:	c1 e0 18             	shl    $0x18,%eax
80105221:	89 fb                	mov    %edi,%ebx
80105223:	c1 e9 02             	shr    $0x2,%ecx
80105226:	c1 e3 10             	shl    $0x10,%ebx
80105229:	09 d8                	or     %ebx,%eax
8010522b:	09 f8                	or     %edi,%eax
8010522d:	c1 e7 08             	shl    $0x8,%edi
80105230:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105232:	89 d7                	mov    %edx,%edi
80105234:	fc                   	cld    
80105235:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105237:	5b                   	pop    %ebx
80105238:	89 d0                	mov    %edx,%eax
8010523a:	5f                   	pop    %edi
8010523b:	5d                   	pop    %ebp
8010523c:	c3                   	ret    
8010523d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105240:	89 d7                	mov    %edx,%edi
80105242:	fc                   	cld    
80105243:	f3 aa                	rep stos %al,%es:(%edi)
80105245:	5b                   	pop    %ebx
80105246:	89 d0                	mov    %edx,%eax
80105248:	5f                   	pop    %edi
80105249:	5d                   	pop    %ebp
8010524a:	c3                   	ret    
8010524b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010524f:	90                   	nop

80105250 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	56                   	push   %esi
80105258:	8b 75 10             	mov    0x10(%ebp),%esi
8010525b:	8b 55 08             	mov    0x8(%ebp),%edx
8010525e:	53                   	push   %ebx
8010525f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105262:	85 f6                	test   %esi,%esi
80105264:	74 2a                	je     80105290 <memcmp+0x40>
80105266:	01 c6                	add    %eax,%esi
80105268:	eb 10                	jmp    8010527a <memcmp+0x2a>
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105270:	83 c0 01             	add    $0x1,%eax
80105273:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105276:	39 f0                	cmp    %esi,%eax
80105278:	74 16                	je     80105290 <memcmp+0x40>
    if(*s1 != *s2)
8010527a:	0f b6 0a             	movzbl (%edx),%ecx
8010527d:	0f b6 18             	movzbl (%eax),%ebx
80105280:	38 d9                	cmp    %bl,%cl
80105282:	74 ec                	je     80105270 <memcmp+0x20>
      return *s1 - *s2;
80105284:	0f b6 c1             	movzbl %cl,%eax
80105287:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105289:	5b                   	pop    %ebx
8010528a:	5e                   	pop    %esi
8010528b:	5d                   	pop    %ebp
8010528c:	c3                   	ret    
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
80105290:	5b                   	pop    %ebx
  return 0;
80105291:	31 c0                	xor    %eax,%eax
}
80105293:	5e                   	pop    %esi
80105294:	5d                   	pop    %ebp
80105295:	c3                   	ret    
80105296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529d:	8d 76 00             	lea    0x0(%esi),%esi

801052a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052a0:	f3 0f 1e fb          	endbr32 
801052a4:	55                   	push   %ebp
801052a5:	89 e5                	mov    %esp,%ebp
801052a7:	57                   	push   %edi
801052a8:	8b 55 08             	mov    0x8(%ebp),%edx
801052ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
801052ae:	56                   	push   %esi
801052af:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052b2:	39 d6                	cmp    %edx,%esi
801052b4:	73 2a                	jae    801052e0 <memmove+0x40>
801052b6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801052b9:	39 fa                	cmp    %edi,%edx
801052bb:	73 23                	jae    801052e0 <memmove+0x40>
801052bd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801052c0:	85 c9                	test   %ecx,%ecx
801052c2:	74 13                	je     801052d7 <memmove+0x37>
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801052c8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801052cc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801052cf:	83 e8 01             	sub    $0x1,%eax
801052d2:	83 f8 ff             	cmp    $0xffffffff,%eax
801052d5:	75 f1                	jne    801052c8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801052d7:	5e                   	pop    %esi
801052d8:	89 d0                	mov    %edx,%eax
801052da:	5f                   	pop    %edi
801052db:	5d                   	pop    %ebp
801052dc:	c3                   	ret    
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801052e0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801052e3:	89 d7                	mov    %edx,%edi
801052e5:	85 c9                	test   %ecx,%ecx
801052e7:	74 ee                	je     801052d7 <memmove+0x37>
801052e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801052f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801052f1:	39 f0                	cmp    %esi,%eax
801052f3:	75 fb                	jne    801052f0 <memmove+0x50>
}
801052f5:	5e                   	pop    %esi
801052f6:	89 d0                	mov    %edx,%eax
801052f8:	5f                   	pop    %edi
801052f9:	5d                   	pop    %ebp
801052fa:	c3                   	ret    
801052fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052ff:	90                   	nop

80105300 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105300:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105304:	eb 9a                	jmp    801052a0 <memmove>
80105306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530d:	8d 76 00             	lea    0x0(%esi),%esi

80105310 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	56                   	push   %esi
80105318:	8b 75 10             	mov    0x10(%ebp),%esi
8010531b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010531e:	53                   	push   %ebx
8010531f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105322:	85 f6                	test   %esi,%esi
80105324:	74 32                	je     80105358 <strncmp+0x48>
80105326:	01 c6                	add    %eax,%esi
80105328:	eb 14                	jmp    8010533e <strncmp+0x2e>
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105330:	38 da                	cmp    %bl,%dl
80105332:	75 14                	jne    80105348 <strncmp+0x38>
    n--, p++, q++;
80105334:	83 c0 01             	add    $0x1,%eax
80105337:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010533a:	39 f0                	cmp    %esi,%eax
8010533c:	74 1a                	je     80105358 <strncmp+0x48>
8010533e:	0f b6 11             	movzbl (%ecx),%edx
80105341:	0f b6 18             	movzbl (%eax),%ebx
80105344:	84 d2                	test   %dl,%dl
80105346:	75 e8                	jne    80105330 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105348:	0f b6 c2             	movzbl %dl,%eax
8010534b:	29 d8                	sub    %ebx,%eax
}
8010534d:	5b                   	pop    %ebx
8010534e:	5e                   	pop    %esi
8010534f:	5d                   	pop    %ebp
80105350:	c3                   	ret    
80105351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105358:	5b                   	pop    %ebx
    return 0;
80105359:	31 c0                	xor    %eax,%eax
}
8010535b:	5e                   	pop    %esi
8010535c:	5d                   	pop    %ebp
8010535d:	c3                   	ret    
8010535e:	66 90                	xchg   %ax,%ax

80105360 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105360:	f3 0f 1e fb          	endbr32 
80105364:	55                   	push   %ebp
80105365:	89 e5                	mov    %esp,%ebp
80105367:	57                   	push   %edi
80105368:	56                   	push   %esi
80105369:	8b 75 08             	mov    0x8(%ebp),%esi
8010536c:	53                   	push   %ebx
8010536d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105370:	89 f2                	mov    %esi,%edx
80105372:	eb 1b                	jmp    8010538f <strncpy+0x2f>
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105378:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010537c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010537f:	83 c2 01             	add    $0x1,%edx
80105382:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105386:	89 f9                	mov    %edi,%ecx
80105388:	88 4a ff             	mov    %cl,-0x1(%edx)
8010538b:	84 c9                	test   %cl,%cl
8010538d:	74 09                	je     80105398 <strncpy+0x38>
8010538f:	89 c3                	mov    %eax,%ebx
80105391:	83 e8 01             	sub    $0x1,%eax
80105394:	85 db                	test   %ebx,%ebx
80105396:	7f e0                	jg     80105378 <strncpy+0x18>
    ;
  while(n-- > 0)
80105398:	89 d1                	mov    %edx,%ecx
8010539a:	85 c0                	test   %eax,%eax
8010539c:	7e 15                	jle    801053b3 <strncpy+0x53>
8010539e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801053a0:	83 c1 01             	add    $0x1,%ecx
801053a3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801053a7:	89 c8                	mov    %ecx,%eax
801053a9:	f7 d0                	not    %eax
801053ab:	01 d0                	add    %edx,%eax
801053ad:	01 d8                	add    %ebx,%eax
801053af:	85 c0                	test   %eax,%eax
801053b1:	7f ed                	jg     801053a0 <strncpy+0x40>
  return os;
}
801053b3:	5b                   	pop    %ebx
801053b4:	89 f0                	mov    %esi,%eax
801053b6:	5e                   	pop    %esi
801053b7:	5f                   	pop    %edi
801053b8:	5d                   	pop    %ebp
801053b9:	c3                   	ret    
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	56                   	push   %esi
801053c8:	8b 55 10             	mov    0x10(%ebp),%edx
801053cb:	8b 75 08             	mov    0x8(%ebp),%esi
801053ce:	53                   	push   %ebx
801053cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801053d2:	85 d2                	test   %edx,%edx
801053d4:	7e 21                	jle    801053f7 <safestrcpy+0x37>
801053d6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801053da:	89 f2                	mov    %esi,%edx
801053dc:	eb 12                	jmp    801053f0 <safestrcpy+0x30>
801053de:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801053e0:	0f b6 08             	movzbl (%eax),%ecx
801053e3:	83 c0 01             	add    $0x1,%eax
801053e6:	83 c2 01             	add    $0x1,%edx
801053e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801053ec:	84 c9                	test   %cl,%cl
801053ee:	74 04                	je     801053f4 <safestrcpy+0x34>
801053f0:	39 d8                	cmp    %ebx,%eax
801053f2:	75 ec                	jne    801053e0 <safestrcpy+0x20>
    ;
  *s = 0;
801053f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801053f7:	89 f0                	mov    %esi,%eax
801053f9:	5b                   	pop    %ebx
801053fa:	5e                   	pop    %esi
801053fb:	5d                   	pop    %ebp
801053fc:	c3                   	ret    
801053fd:	8d 76 00             	lea    0x0(%esi),%esi

80105400 <strlen>:

int
strlen(const char *s)
{
80105400:	f3 0f 1e fb          	endbr32 
80105404:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105405:	31 c0                	xor    %eax,%eax
{
80105407:	89 e5                	mov    %esp,%ebp
80105409:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010540c:	80 3a 00             	cmpb   $0x0,(%edx)
8010540f:	74 10                	je     80105421 <strlen+0x21>
80105411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105418:	83 c0 01             	add    $0x1,%eax
8010541b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010541f:	75 f7                	jne    80105418 <strlen+0x18>
    ;
  return n;
}
80105421:	5d                   	pop    %ebp
80105422:	c3                   	ret    

80105423 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105423:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105427:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010542b:	55                   	push   %ebp
  pushl %ebx
8010542c:	53                   	push   %ebx
  pushl %esi
8010542d:	56                   	push   %esi
  pushl %edi
8010542e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010542f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105431:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105433:	5f                   	pop    %edi
  popl %esi
80105434:	5e                   	pop    %esi
  popl %ebx
80105435:	5b                   	pop    %ebx
  popl %ebp
80105436:	5d                   	pop    %ebp
  ret
80105437:	c3                   	ret    
80105438:	66 90                	xchg   %ax,%ax
8010543a:	66 90                	xchg   %ax,%ax
8010543c:	66 90                	xchg   %ax,%ax
8010543e:	66 90                	xchg   %ax,%ax

80105440 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	53                   	push   %ebx
80105448:	83 ec 04             	sub    $0x4,%esp
8010544b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010544e:	e8 7d f0 ff ff       	call   801044d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105453:	8b 00                	mov    (%eax),%eax
80105455:	39 d8                	cmp    %ebx,%eax
80105457:	76 17                	jbe    80105470 <fetchint+0x30>
80105459:	8d 53 04             	lea    0x4(%ebx),%edx
8010545c:	39 d0                	cmp    %edx,%eax
8010545e:	72 10                	jb     80105470 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105460:	8b 45 0c             	mov    0xc(%ebp),%eax
80105463:	8b 13                	mov    (%ebx),%edx
80105465:	89 10                	mov    %edx,(%eax)
  return 0;
80105467:	31 c0                	xor    %eax,%eax
}
80105469:	83 c4 04             	add    $0x4,%esp
8010546c:	5b                   	pop    %ebx
8010546d:	5d                   	pop    %ebp
8010546e:	c3                   	ret    
8010546f:	90                   	nop
    return -1;
80105470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105475:	eb f2                	jmp    80105469 <fetchint+0x29>
80105477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010547e:	66 90                	xchg   %ax,%ax

80105480 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105480:	f3 0f 1e fb          	endbr32 
80105484:	55                   	push   %ebp
80105485:	89 e5                	mov    %esp,%ebp
80105487:	53                   	push   %ebx
80105488:	83 ec 04             	sub    $0x4,%esp
8010548b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010548e:	e8 3d f0 ff ff       	call   801044d0 <myproc>

  if(addr >= curproc->sz)
80105493:	39 18                	cmp    %ebx,(%eax)
80105495:	76 31                	jbe    801054c8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105497:	8b 55 0c             	mov    0xc(%ebp),%edx
8010549a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010549c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010549e:	39 d3                	cmp    %edx,%ebx
801054a0:	73 26                	jae    801054c8 <fetchstr+0x48>
801054a2:	89 d8                	mov    %ebx,%eax
801054a4:	eb 11                	jmp    801054b7 <fetchstr+0x37>
801054a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ad:	8d 76 00             	lea    0x0(%esi),%esi
801054b0:	83 c0 01             	add    $0x1,%eax
801054b3:	39 c2                	cmp    %eax,%edx
801054b5:	76 11                	jbe    801054c8 <fetchstr+0x48>
    if(*s == 0)
801054b7:	80 38 00             	cmpb   $0x0,(%eax)
801054ba:	75 f4                	jne    801054b0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801054bc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801054bf:	29 d8                	sub    %ebx,%eax
}
801054c1:	5b                   	pop    %ebx
801054c2:	5d                   	pop    %ebp
801054c3:	c3                   	ret    
801054c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054c8:	83 c4 04             	add    $0x4,%esp
    return -1;
801054cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054d0:	5b                   	pop    %ebx
801054d1:	5d                   	pop    %ebp
801054d2:	c3                   	ret    
801054d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	56                   	push   %esi
801054e8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054e9:	e8 e2 ef ff ff       	call   801044d0 <myproc>
801054ee:	8b 55 08             	mov    0x8(%ebp),%edx
801054f1:	8b 40 18             	mov    0x18(%eax),%eax
801054f4:	8b 40 44             	mov    0x44(%eax),%eax
801054f7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801054fa:	e8 d1 ef ff ff       	call   801044d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054ff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105502:	8b 00                	mov    (%eax),%eax
80105504:	39 c6                	cmp    %eax,%esi
80105506:	73 18                	jae    80105520 <argint+0x40>
80105508:	8d 53 08             	lea    0x8(%ebx),%edx
8010550b:	39 d0                	cmp    %edx,%eax
8010550d:	72 11                	jb     80105520 <argint+0x40>
  *ip = *(int*)(addr);
8010550f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105512:	8b 53 04             	mov    0x4(%ebx),%edx
80105515:	89 10                	mov    %edx,(%eax)
  return 0;
80105517:	31 c0                	xor    %eax,%eax
}
80105519:	5b                   	pop    %ebx
8010551a:	5e                   	pop    %esi
8010551b:	5d                   	pop    %ebp
8010551c:	c3                   	ret    
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105525:	eb f2                	jmp    80105519 <argint+0x39>
80105527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552e:	66 90                	xchg   %ax,%ax

80105530 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	56                   	push   %esi
80105538:	53                   	push   %ebx
80105539:	83 ec 10             	sub    $0x10,%esp
8010553c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010553f:	e8 8c ef ff ff       	call   801044d0 <myproc>
 
  if(argint(n, &i) < 0)
80105544:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105547:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105549:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010554c:	50                   	push   %eax
8010554d:	ff 75 08             	pushl  0x8(%ebp)
80105550:	e8 8b ff ff ff       	call   801054e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105555:	83 c4 10             	add    $0x10,%esp
80105558:	85 c0                	test   %eax,%eax
8010555a:	78 24                	js     80105580 <argptr+0x50>
8010555c:	85 db                	test   %ebx,%ebx
8010555e:	78 20                	js     80105580 <argptr+0x50>
80105560:	8b 16                	mov    (%esi),%edx
80105562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105565:	39 c2                	cmp    %eax,%edx
80105567:	76 17                	jbe    80105580 <argptr+0x50>
80105569:	01 c3                	add    %eax,%ebx
8010556b:	39 da                	cmp    %ebx,%edx
8010556d:	72 11                	jb     80105580 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010556f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105572:	89 02                	mov    %eax,(%edx)
  return 0;
80105574:	31 c0                	xor    %eax,%eax
}
80105576:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105579:	5b                   	pop    %ebx
8010557a:	5e                   	pop    %esi
8010557b:	5d                   	pop    %ebp
8010557c:	c3                   	ret    
8010557d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105585:	eb ef                	jmp    80105576 <argptr+0x46>
80105587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558e:	66 90                	xchg   %ax,%ax

80105590 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
80105595:	89 e5                	mov    %esp,%ebp
80105597:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010559a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010559d:	50                   	push   %eax
8010559e:	ff 75 08             	pushl  0x8(%ebp)
801055a1:	e8 3a ff ff ff       	call   801054e0 <argint>
801055a6:	83 c4 10             	add    $0x10,%esp
801055a9:	85 c0                	test   %eax,%eax
801055ab:	78 13                	js     801055c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801055ad:	83 ec 08             	sub    $0x8,%esp
801055b0:	ff 75 0c             	pushl  0xc(%ebp)
801055b3:	ff 75 f4             	pushl  -0xc(%ebp)
801055b6:	e8 c5 fe ff ff       	call   80105480 <fetchstr>
801055bb:	83 c4 10             	add    $0x10,%esp
}
801055be:	c9                   	leave  
801055bf:	c3                   	ret    
801055c0:	c9                   	leave  
    return -1;
801055c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055c6:	c3                   	ret    
801055c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ce:	66 90                	xchg   %ax,%ax

801055d0 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
801055d5:	89 e5                	mov    %esp,%ebp
801055d7:	53                   	push   %ebx
801055d8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801055db:	e8 f0 ee ff ff       	call   801044d0 <myproc>
801055e0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801055e2:	8b 40 18             	mov    0x18(%eax),%eax
801055e5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801055eb:	83 fa 17             	cmp    $0x17,%edx
801055ee:	77 20                	ja     80105610 <syscall+0x40>
801055f0:	8b 14 85 60 8e 10 80 	mov    -0x7fef71a0(,%eax,4),%edx
801055f7:	85 d2                	test   %edx,%edx
801055f9:	74 15                	je     80105610 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801055fb:	ff d2                	call   *%edx
801055fd:	89 c2                	mov    %eax,%edx
801055ff:	8b 43 18             	mov    0x18(%ebx),%eax
80105602:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105608:	c9                   	leave  
80105609:	c3                   	ret    
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105610:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105611:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105614:	50                   	push   %eax
80105615:	ff 73 10             	pushl  0x10(%ebx)
80105618:	68 25 8e 10 80       	push   $0x80108e25
8010561d:	e8 8e b0 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105622:	8b 43 18             	mov    0x18(%ebx),%eax
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010562f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105632:	c9                   	leave  
80105633:	c3                   	ret    
80105634:	66 90                	xchg   %ax,%ax
80105636:	66 90                	xchg   %ax,%ax
80105638:	66 90                	xchg   %ax,%ax
8010563a:	66 90                	xchg   %ax,%ax
8010563c:	66 90                	xchg   %ax,%ax
8010563e:	66 90                	xchg   %ax,%ax

80105640 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105645:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105648:	53                   	push   %ebx
80105649:	83 ec 44             	sub    $0x44,%esp
8010564c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010564f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105652:	57                   	push   %edi
80105653:	50                   	push   %eax
{
80105654:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105657:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010565a:	e8 f1 c9 ff ff       	call   80102050 <nameiparent>
8010565f:	83 c4 10             	add    $0x10,%esp
80105662:	85 c0                	test   %eax,%eax
80105664:	0f 84 46 01 00 00    	je     801057b0 <create+0x170>
    return 0;
  ilock(dp);
8010566a:	83 ec 0c             	sub    $0xc,%esp
8010566d:	89 c3                	mov    %eax,%ebx
8010566f:	50                   	push   %eax
80105670:	e8 eb c0 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105675:	83 c4 0c             	add    $0xc,%esp
80105678:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010567b:	50                   	push   %eax
8010567c:	57                   	push   %edi
8010567d:	53                   	push   %ebx
8010567e:	e8 2d c6 ff ff       	call   80101cb0 <dirlookup>
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	89 c6                	mov    %eax,%esi
80105688:	85 c0                	test   %eax,%eax
8010568a:	74 54                	je     801056e0 <create+0xa0>
    iunlockput(dp);
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	53                   	push   %ebx
80105690:	e8 6b c3 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105695:	89 34 24             	mov    %esi,(%esp)
80105698:	e8 c3 c0 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801056a5:	75 19                	jne    801056c0 <create+0x80>
801056a7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801056ac:	75 12                	jne    801056c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b1:	89 f0                	mov    %esi,%eax
801056b3:	5b                   	pop    %ebx
801056b4:	5e                   	pop    %esi
801056b5:	5f                   	pop    %edi
801056b6:	5d                   	pop    %ebp
801056b7:	c3                   	ret    
801056b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bf:	90                   	nop
    iunlockput(ip);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	56                   	push   %esi
    return 0;
801056c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801056c6:	e8 35 c3 ff ff       	call   80101a00 <iunlockput>
    return 0;
801056cb:	83 c4 10             	add    $0x10,%esp
}
801056ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056d1:	89 f0                	mov    %esi,%eax
801056d3:	5b                   	pop    %ebx
801056d4:	5e                   	pop    %esi
801056d5:	5f                   	pop    %edi
801056d6:	5d                   	pop    %ebp
801056d7:	c3                   	ret    
801056d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801056e0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	50                   	push   %eax
801056e8:	ff 33                	pushl  (%ebx)
801056ea:	e8 f1 be ff ff       	call   801015e0 <ialloc>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	89 c6                	mov    %eax,%esi
801056f4:	85 c0                	test   %eax,%eax
801056f6:	0f 84 cd 00 00 00    	je     801057c9 <create+0x189>
  ilock(ip);
801056fc:	83 ec 0c             	sub    $0xc,%esp
801056ff:	50                   	push   %eax
80105700:	e8 5b c0 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105705:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105709:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010570d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105711:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105715:	b8 01 00 00 00       	mov    $0x1,%eax
8010571a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010571e:	89 34 24             	mov    %esi,(%esp)
80105721:	e8 7a bf ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010572e:	74 30                	je     80105760 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105730:	83 ec 04             	sub    $0x4,%esp
80105733:	ff 76 04             	pushl  0x4(%esi)
80105736:	57                   	push   %edi
80105737:	53                   	push   %ebx
80105738:	e8 33 c8 ff ff       	call   80101f70 <dirlink>
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	85 c0                	test   %eax,%eax
80105742:	78 78                	js     801057bc <create+0x17c>
  iunlockput(dp);
80105744:	83 ec 0c             	sub    $0xc,%esp
80105747:	53                   	push   %ebx
80105748:	e8 b3 c2 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010574d:	83 c4 10             	add    $0x10,%esp
}
80105750:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105753:	89 f0                	mov    %esi,%eax
80105755:	5b                   	pop    %ebx
80105756:	5e                   	pop    %esi
80105757:	5f                   	pop    %edi
80105758:	5d                   	pop    %ebp
80105759:	c3                   	ret    
8010575a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105760:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105763:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105768:	53                   	push   %ebx
80105769:	e8 32 bf ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010576e:	83 c4 0c             	add    $0xc,%esp
80105771:	ff 76 04             	pushl  0x4(%esi)
80105774:	68 e0 8e 10 80       	push   $0x80108ee0
80105779:	56                   	push   %esi
8010577a:	e8 f1 c7 ff ff       	call   80101f70 <dirlink>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	85 c0                	test   %eax,%eax
80105784:	78 18                	js     8010579e <create+0x15e>
80105786:	83 ec 04             	sub    $0x4,%esp
80105789:	ff 73 04             	pushl  0x4(%ebx)
8010578c:	68 df 8e 10 80       	push   $0x80108edf
80105791:	56                   	push   %esi
80105792:	e8 d9 c7 ff ff       	call   80101f70 <dirlink>
80105797:	83 c4 10             	add    $0x10,%esp
8010579a:	85 c0                	test   %eax,%eax
8010579c:	79 92                	jns    80105730 <create+0xf0>
      panic("create dots");
8010579e:	83 ec 0c             	sub    $0xc,%esp
801057a1:	68 d3 8e 10 80       	push   $0x80108ed3
801057a6:	e8 e5 ab ff ff       	call   80100390 <panic>
801057ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop
}
801057b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801057b3:	31 f6                	xor    %esi,%esi
}
801057b5:	5b                   	pop    %ebx
801057b6:	89 f0                	mov    %esi,%eax
801057b8:	5e                   	pop    %esi
801057b9:	5f                   	pop    %edi
801057ba:	5d                   	pop    %ebp
801057bb:	c3                   	ret    
    panic("create: dirlink");
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	68 e2 8e 10 80       	push   $0x80108ee2
801057c4:	e8 c7 ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	68 c4 8e 10 80       	push   $0x80108ec4
801057d1:	e8 ba ab ff ff       	call   80100390 <panic>
801057d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057dd:	8d 76 00             	lea    0x0(%esi),%esi

801057e0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	56                   	push   %esi
801057e4:	89 d6                	mov    %edx,%esi
801057e6:	53                   	push   %ebx
801057e7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801057e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801057ec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801057ef:	50                   	push   %eax
801057f0:	6a 00                	push   $0x0
801057f2:	e8 e9 fc ff ff       	call   801054e0 <argint>
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	85 c0                	test   %eax,%eax
801057fc:	78 2a                	js     80105828 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105802:	77 24                	ja     80105828 <argfd.constprop.0+0x48>
80105804:	e8 c7 ec ff ff       	call   801044d0 <myproc>
80105809:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010580c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105810:	85 c0                	test   %eax,%eax
80105812:	74 14                	je     80105828 <argfd.constprop.0+0x48>
  if(pfd)
80105814:	85 db                	test   %ebx,%ebx
80105816:	74 02                	je     8010581a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105818:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010581a:	89 06                	mov    %eax,(%esi)
  return 0;
8010581c:	31 c0                	xor    %eax,%eax
}
8010581e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105821:	5b                   	pop    %ebx
80105822:	5e                   	pop    %esi
80105823:	5d                   	pop    %ebp
80105824:	c3                   	ret    
80105825:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582d:	eb ef                	jmp    8010581e <argfd.constprop.0+0x3e>
8010582f:	90                   	nop

80105830 <sys_dup>:
{
80105830:	f3 0f 1e fb          	endbr32 
80105834:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105835:	31 c0                	xor    %eax,%eax
{
80105837:	89 e5                	mov    %esp,%ebp
80105839:	56                   	push   %esi
8010583a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010583b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010583e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105841:	e8 9a ff ff ff       	call   801057e0 <argfd.constprop.0>
80105846:	85 c0                	test   %eax,%eax
80105848:	78 1e                	js     80105868 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010584a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010584d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010584f:	e8 7c ec ff ff       	call   801044d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105858:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010585c:	85 d2                	test   %edx,%edx
8010585e:	74 20                	je     80105880 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105860:	83 c3 01             	add    $0x1,%ebx
80105863:	83 fb 10             	cmp    $0x10,%ebx
80105866:	75 f0                	jne    80105858 <sys_dup+0x28>
}
80105868:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010586b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105870:	89 d8                	mov    %ebx,%eax
80105872:	5b                   	pop    %ebx
80105873:	5e                   	pop    %esi
80105874:	5d                   	pop    %ebp
80105875:	c3                   	ret    
80105876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105880:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105884:	83 ec 0c             	sub    $0xc,%esp
80105887:	ff 75 f4             	pushl  -0xc(%ebp)
8010588a:	e8 e1 b5 ff ff       	call   80100e70 <filedup>
  return fd;
8010588f:	83 c4 10             	add    $0x10,%esp
}
80105892:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105895:	89 d8                	mov    %ebx,%eax
80105897:	5b                   	pop    %ebx
80105898:	5e                   	pop    %esi
80105899:	5d                   	pop    %ebp
8010589a:	c3                   	ret    
8010589b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010589f:	90                   	nop

801058a0 <sys_read>:
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058a5:	31 c0                	xor    %eax,%eax
{
801058a7:	89 e5                	mov    %esp,%ebp
801058a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058ac:	8d 55 ec             	lea    -0x14(%ebp),%edx
801058af:	e8 2c ff ff ff       	call   801057e0 <argfd.constprop.0>
801058b4:	85 c0                	test   %eax,%eax
801058b6:	78 48                	js     80105900 <sys_read+0x60>
801058b8:	83 ec 08             	sub    $0x8,%esp
801058bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058be:	50                   	push   %eax
801058bf:	6a 02                	push   $0x2
801058c1:	e8 1a fc ff ff       	call   801054e0 <argint>
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	85 c0                	test   %eax,%eax
801058cb:	78 33                	js     80105900 <sys_read+0x60>
801058cd:	83 ec 04             	sub    $0x4,%esp
801058d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d3:	ff 75 f0             	pushl  -0x10(%ebp)
801058d6:	50                   	push   %eax
801058d7:	6a 01                	push   $0x1
801058d9:	e8 52 fc ff ff       	call   80105530 <argptr>
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 1b                	js     80105900 <sys_read+0x60>
  return fileread(f, p, n);
801058e5:	83 ec 04             	sub    $0x4,%esp
801058e8:	ff 75 f0             	pushl  -0x10(%ebp)
801058eb:	ff 75 f4             	pushl  -0xc(%ebp)
801058ee:	ff 75 ec             	pushl  -0x14(%ebp)
801058f1:	e8 fa b6 ff ff       	call   80100ff0 <fileread>
801058f6:	83 c4 10             	add    $0x10,%esp
}
801058f9:	c9                   	leave  
801058fa:	c3                   	ret    
801058fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
80105900:	c9                   	leave  
    return -1;
80105901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105906:	c3                   	ret    
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_write>:
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105915:	31 c0                	xor    %eax,%eax
{
80105917:	89 e5                	mov    %esp,%ebp
80105919:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010591c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010591f:	e8 bc fe ff ff       	call   801057e0 <argfd.constprop.0>
80105924:	85 c0                	test   %eax,%eax
80105926:	78 48                	js     80105970 <sys_write+0x60>
80105928:	83 ec 08             	sub    $0x8,%esp
8010592b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010592e:	50                   	push   %eax
8010592f:	6a 02                	push   $0x2
80105931:	e8 aa fb ff ff       	call   801054e0 <argint>
80105936:	83 c4 10             	add    $0x10,%esp
80105939:	85 c0                	test   %eax,%eax
8010593b:	78 33                	js     80105970 <sys_write+0x60>
8010593d:	83 ec 04             	sub    $0x4,%esp
80105940:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105943:	ff 75 f0             	pushl  -0x10(%ebp)
80105946:	50                   	push   %eax
80105947:	6a 01                	push   $0x1
80105949:	e8 e2 fb ff ff       	call   80105530 <argptr>
8010594e:	83 c4 10             	add    $0x10,%esp
80105951:	85 c0                	test   %eax,%eax
80105953:	78 1b                	js     80105970 <sys_write+0x60>
  return filewrite(f, p, n);
80105955:	83 ec 04             	sub    $0x4,%esp
80105958:	ff 75 f0             	pushl  -0x10(%ebp)
8010595b:	ff 75 f4             	pushl  -0xc(%ebp)
8010595e:	ff 75 ec             	pushl  -0x14(%ebp)
80105961:	e8 2a b7 ff ff       	call   80101090 <filewrite>
80105966:	83 c4 10             	add    $0x10,%esp
}
80105969:	c9                   	leave  
8010596a:	c3                   	ret    
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop
80105970:	c9                   	leave  
    return -1;
80105971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105976:	c3                   	ret    
80105977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597e:	66 90                	xchg   %ax,%ax

80105980 <sys_close>:
{
80105980:	f3 0f 1e fb          	endbr32 
80105984:	55                   	push   %ebp
80105985:	89 e5                	mov    %esp,%ebp
80105987:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010598a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010598d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105990:	e8 4b fe ff ff       	call   801057e0 <argfd.constprop.0>
80105995:	85 c0                	test   %eax,%eax
80105997:	78 27                	js     801059c0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105999:	e8 32 eb ff ff       	call   801044d0 <myproc>
8010599e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801059a1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801059a4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801059ab:	00 
  fileclose(f);
801059ac:	ff 75 f4             	pushl  -0xc(%ebp)
801059af:	e8 0c b5 ff ff       	call   80100ec0 <fileclose>
  return 0;
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	31 c0                	xor    %eax,%eax
}
801059b9:	c9                   	leave  
801059ba:	c3                   	ret    
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop
801059c0:	c9                   	leave  
    return -1;
801059c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c6:	c3                   	ret    
801059c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ce:	66 90                	xchg   %ax,%ax

801059d0 <sys_fstat>:
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059d5:	31 c0                	xor    %eax,%eax
{
801059d7:	89 e5                	mov    %esp,%ebp
801059d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059dc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801059df:	e8 fc fd ff ff       	call   801057e0 <argfd.constprop.0>
801059e4:	85 c0                	test   %eax,%eax
801059e6:	78 30                	js     80105a18 <sys_fstat+0x48>
801059e8:	83 ec 04             	sub    $0x4,%esp
801059eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ee:	6a 14                	push   $0x14
801059f0:	50                   	push   %eax
801059f1:	6a 01                	push   $0x1
801059f3:	e8 38 fb ff ff       	call   80105530 <argptr>
801059f8:	83 c4 10             	add    $0x10,%esp
801059fb:	85 c0                	test   %eax,%eax
801059fd:	78 19                	js     80105a18 <sys_fstat+0x48>
  return filestat(f, st);
801059ff:	83 ec 08             	sub    $0x8,%esp
80105a02:	ff 75 f4             	pushl  -0xc(%ebp)
80105a05:	ff 75 f0             	pushl  -0x10(%ebp)
80105a08:	e8 93 b5 ff ff       	call   80100fa0 <filestat>
80105a0d:	83 c4 10             	add    $0x10,%esp
}
80105a10:	c9                   	leave  
80105a11:	c3                   	ret    
80105a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a18:	c9                   	leave  
    return -1;
80105a19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1e:	c3                   	ret    
80105a1f:	90                   	nop

80105a20 <sys_link>:
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	57                   	push   %edi
80105a28:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a29:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105a2c:	53                   	push   %ebx
80105a2d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a30:	50                   	push   %eax
80105a31:	6a 00                	push   $0x0
80105a33:	e8 58 fb ff ff       	call   80105590 <argstr>
80105a38:	83 c4 10             	add    $0x10,%esp
80105a3b:	85 c0                	test   %eax,%eax
80105a3d:	0f 88 ff 00 00 00    	js     80105b42 <sys_link+0x122>
80105a43:	83 ec 08             	sub    $0x8,%esp
80105a46:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105a49:	50                   	push   %eax
80105a4a:	6a 01                	push   $0x1
80105a4c:	e8 3f fb ff ff       	call   80105590 <argstr>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	85 c0                	test   %eax,%eax
80105a56:	0f 88 e6 00 00 00    	js     80105b42 <sys_link+0x122>
  begin_op();
80105a5c:	e8 ef dd ff ff       	call   80103850 <begin_op>
  if((ip = namei(old)) == 0){
80105a61:	83 ec 0c             	sub    $0xc,%esp
80105a64:	ff 75 d4             	pushl  -0x2c(%ebp)
80105a67:	e8 c4 c5 ff ff       	call   80102030 <namei>
80105a6c:	83 c4 10             	add    $0x10,%esp
80105a6f:	89 c3                	mov    %eax,%ebx
80105a71:	85 c0                	test   %eax,%eax
80105a73:	0f 84 e8 00 00 00    	je     80105b61 <sys_link+0x141>
  ilock(ip);
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	50                   	push   %eax
80105a7d:	e8 de bc ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a8a:	0f 84 b9 00 00 00    	je     80105b49 <sys_link+0x129>
  iupdate(ip);
80105a90:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105a93:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105a98:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a9b:	53                   	push   %ebx
80105a9c:	e8 ff bb ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105aa1:	89 1c 24             	mov    %ebx,(%esp)
80105aa4:	e8 97 bd ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105aa9:	58                   	pop    %eax
80105aaa:	5a                   	pop    %edx
80105aab:	57                   	push   %edi
80105aac:	ff 75 d0             	pushl  -0x30(%ebp)
80105aaf:	e8 9c c5 ff ff       	call   80102050 <nameiparent>
80105ab4:	83 c4 10             	add    $0x10,%esp
80105ab7:	89 c6                	mov    %eax,%esi
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	74 5f                	je     80105b1c <sys_link+0xfc>
  ilock(dp);
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	50                   	push   %eax
80105ac1:	e8 9a bc ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ac6:	8b 03                	mov    (%ebx),%eax
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	39 06                	cmp    %eax,(%esi)
80105acd:	75 41                	jne    80105b10 <sys_link+0xf0>
80105acf:	83 ec 04             	sub    $0x4,%esp
80105ad2:	ff 73 04             	pushl  0x4(%ebx)
80105ad5:	57                   	push   %edi
80105ad6:	56                   	push   %esi
80105ad7:	e8 94 c4 ff ff       	call   80101f70 <dirlink>
80105adc:	83 c4 10             	add    $0x10,%esp
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	78 2d                	js     80105b10 <sys_link+0xf0>
  iunlockput(dp);
80105ae3:	83 ec 0c             	sub    $0xc,%esp
80105ae6:	56                   	push   %esi
80105ae7:	e8 14 bf ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80105aec:	89 1c 24             	mov    %ebx,(%esp)
80105aef:	e8 9c bd ff ff       	call   80101890 <iput>
  end_op();
80105af4:	e8 c7 dd ff ff       	call   801038c0 <end_op>
  return 0;
80105af9:	83 c4 10             	add    $0x10,%esp
80105afc:	31 c0                	xor    %eax,%eax
}
80105afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b01:	5b                   	pop    %ebx
80105b02:	5e                   	pop    %esi
80105b03:	5f                   	pop    %edi
80105b04:	5d                   	pop    %ebp
80105b05:	c3                   	ret    
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	56                   	push   %esi
80105b14:	e8 e7 be ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105b19:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105b1c:	83 ec 0c             	sub    $0xc,%esp
80105b1f:	53                   	push   %ebx
80105b20:	e8 3b bc ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105b25:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b2a:	89 1c 24             	mov    %ebx,(%esp)
80105b2d:	e8 6e bb ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105b32:	89 1c 24             	mov    %ebx,(%esp)
80105b35:	e8 c6 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105b3a:	e8 81 dd ff ff       	call   801038c0 <end_op>
  return -1;
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b47:	eb b5                	jmp    80105afe <sys_link+0xde>
    iunlockput(ip);
80105b49:	83 ec 0c             	sub    $0xc,%esp
80105b4c:	53                   	push   %ebx
80105b4d:	e8 ae be ff ff       	call   80101a00 <iunlockput>
    end_op();
80105b52:	e8 69 dd ff ff       	call   801038c0 <end_op>
    return -1;
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5f:	eb 9d                	jmp    80105afe <sys_link+0xde>
    end_op();
80105b61:	e8 5a dd ff ff       	call   801038c0 <end_op>
    return -1;
80105b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6b:	eb 91                	jmp    80105afe <sys_link+0xde>
80105b6d:	8d 76 00             	lea    0x0(%esi),%esi

80105b70 <sys_unlink>:
{
80105b70:	f3 0f 1e fb          	endbr32 
80105b74:	55                   	push   %ebp
80105b75:	89 e5                	mov    %esp,%ebp
80105b77:	57                   	push   %edi
80105b78:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105b79:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b7c:	53                   	push   %ebx
80105b7d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105b80:	50                   	push   %eax
80105b81:	6a 00                	push   $0x0
80105b83:	e8 08 fa ff ff       	call   80105590 <argstr>
80105b88:	83 c4 10             	add    $0x10,%esp
80105b8b:	85 c0                	test   %eax,%eax
80105b8d:	0f 88 7d 01 00 00    	js     80105d10 <sys_unlink+0x1a0>
  begin_op();
80105b93:	e8 b8 dc ff ff       	call   80103850 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b98:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105b9b:	83 ec 08             	sub    $0x8,%esp
80105b9e:	53                   	push   %ebx
80105b9f:	ff 75 c0             	pushl  -0x40(%ebp)
80105ba2:	e8 a9 c4 ff ff       	call   80102050 <nameiparent>
80105ba7:	83 c4 10             	add    $0x10,%esp
80105baa:	89 c6                	mov    %eax,%esi
80105bac:	85 c0                	test   %eax,%eax
80105bae:	0f 84 66 01 00 00    	je     80105d1a <sys_unlink+0x1aa>
  ilock(dp);
80105bb4:	83 ec 0c             	sub    $0xc,%esp
80105bb7:	50                   	push   %eax
80105bb8:	e8 a3 bb ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bbd:	58                   	pop    %eax
80105bbe:	5a                   	pop    %edx
80105bbf:	68 e0 8e 10 80       	push   $0x80108ee0
80105bc4:	53                   	push   %ebx
80105bc5:	e8 c6 c0 ff ff       	call   80101c90 <namecmp>
80105bca:	83 c4 10             	add    $0x10,%esp
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	0f 84 03 01 00 00    	je     80105cd8 <sys_unlink+0x168>
80105bd5:	83 ec 08             	sub    $0x8,%esp
80105bd8:	68 df 8e 10 80       	push   $0x80108edf
80105bdd:	53                   	push   %ebx
80105bde:	e8 ad c0 ff ff       	call   80101c90 <namecmp>
80105be3:	83 c4 10             	add    $0x10,%esp
80105be6:	85 c0                	test   %eax,%eax
80105be8:	0f 84 ea 00 00 00    	je     80105cd8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105bee:	83 ec 04             	sub    $0x4,%esp
80105bf1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105bf4:	50                   	push   %eax
80105bf5:	53                   	push   %ebx
80105bf6:	56                   	push   %esi
80105bf7:	e8 b4 c0 ff ff       	call   80101cb0 <dirlookup>
80105bfc:	83 c4 10             	add    $0x10,%esp
80105bff:	89 c3                	mov    %eax,%ebx
80105c01:	85 c0                	test   %eax,%eax
80105c03:	0f 84 cf 00 00 00    	je     80105cd8 <sys_unlink+0x168>
  ilock(ip);
80105c09:	83 ec 0c             	sub    $0xc,%esp
80105c0c:	50                   	push   %eax
80105c0d:	e8 4e bb ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c1a:	0f 8e 23 01 00 00    	jle    80105d43 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c20:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c25:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105c28:	74 66                	je     80105c90 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105c2a:	83 ec 04             	sub    $0x4,%esp
80105c2d:	6a 10                	push   $0x10
80105c2f:	6a 00                	push   $0x0
80105c31:	57                   	push   %edi
80105c32:	e8 c9 f5 ff ff       	call   80105200 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c37:	6a 10                	push   $0x10
80105c39:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c3c:	57                   	push   %edi
80105c3d:	56                   	push   %esi
80105c3e:	e8 1d bf ff ff       	call   80101b60 <writei>
80105c43:	83 c4 20             	add    $0x20,%esp
80105c46:	83 f8 10             	cmp    $0x10,%eax
80105c49:	0f 85 e7 00 00 00    	jne    80105d36 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80105c4f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c54:	0f 84 96 00 00 00    	je     80105cf0 <sys_unlink+0x180>
  iunlockput(dp);
80105c5a:	83 ec 0c             	sub    $0xc,%esp
80105c5d:	56                   	push   %esi
80105c5e:	e8 9d bd ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105c63:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c68:	89 1c 24             	mov    %ebx,(%esp)
80105c6b:	e8 30 ba ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105c70:	89 1c 24             	mov    %ebx,(%esp)
80105c73:	e8 88 bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c78:	e8 43 dc ff ff       	call   801038c0 <end_op>
  return 0;
80105c7d:	83 c4 10             	add    $0x10,%esp
80105c80:	31 c0                	xor    %eax,%eax
}
80105c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c85:	5b                   	pop    %ebx
80105c86:	5e                   	pop    %esi
80105c87:	5f                   	pop    %edi
80105c88:	5d                   	pop    %ebp
80105c89:	c3                   	ret    
80105c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c90:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105c94:	76 94                	jbe    80105c2a <sys_unlink+0xba>
80105c96:	ba 20 00 00 00       	mov    $0x20,%edx
80105c9b:	eb 0b                	jmp    80105ca8 <sys_unlink+0x138>
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
80105ca0:	83 c2 10             	add    $0x10,%edx
80105ca3:	39 53 58             	cmp    %edx,0x58(%ebx)
80105ca6:	76 82                	jbe    80105c2a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ca8:	6a 10                	push   $0x10
80105caa:	52                   	push   %edx
80105cab:	57                   	push   %edi
80105cac:	53                   	push   %ebx
80105cad:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105cb0:	e8 ab bd ff ff       	call   80101a60 <readi>
80105cb5:	83 c4 10             	add    $0x10,%esp
80105cb8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105cbb:	83 f8 10             	cmp    $0x10,%eax
80105cbe:	75 69                	jne    80105d29 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105cc0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105cc5:	74 d9                	je     80105ca0 <sys_unlink+0x130>
    iunlockput(ip);
80105cc7:	83 ec 0c             	sub    $0xc,%esp
80105cca:	53                   	push   %ebx
80105ccb:	e8 30 bd ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105cd0:	83 c4 10             	add    $0x10,%esp
80105cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cd7:	90                   	nop
  iunlockput(dp);
80105cd8:	83 ec 0c             	sub    $0xc,%esp
80105cdb:	56                   	push   %esi
80105cdc:	e8 1f bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105ce1:	e8 da db ff ff       	call   801038c0 <end_op>
  return -1;
80105ce6:	83 c4 10             	add    $0x10,%esp
80105ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cee:	eb 92                	jmp    80105c82 <sys_unlink+0x112>
    iupdate(dp);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105cf3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105cf8:	56                   	push   %esi
80105cf9:	e8 a2 b9 ff ff       	call   801016a0 <iupdate>
80105cfe:	83 c4 10             	add    $0x10,%esp
80105d01:	e9 54 ff ff ff       	jmp    80105c5a <sys_unlink+0xea>
80105d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d15:	e9 68 ff ff ff       	jmp    80105c82 <sys_unlink+0x112>
    end_op();
80105d1a:	e8 a1 db ff ff       	call   801038c0 <end_op>
    return -1;
80105d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d24:	e9 59 ff ff ff       	jmp    80105c82 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105d29:	83 ec 0c             	sub    $0xc,%esp
80105d2c:	68 04 8f 10 80       	push   $0x80108f04
80105d31:	e8 5a a6 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105d36:	83 ec 0c             	sub    $0xc,%esp
80105d39:	68 16 8f 10 80       	push   $0x80108f16
80105d3e:	e8 4d a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105d43:	83 ec 0c             	sub    $0xc,%esp
80105d46:	68 f2 8e 10 80       	push   $0x80108ef2
80105d4b:	e8 40 a6 ff ff       	call   80100390 <panic>

80105d50 <sys_open>:

int
sys_open(void)
{
80105d50:	f3 0f 1e fb          	endbr32 
80105d54:	55                   	push   %ebp
80105d55:	89 e5                	mov    %esp,%ebp
80105d57:	57                   	push   %edi
80105d58:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d59:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105d5c:	53                   	push   %ebx
80105d5d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d60:	50                   	push   %eax
80105d61:	6a 00                	push   $0x0
80105d63:	e8 28 f8 ff ff       	call   80105590 <argstr>
80105d68:	83 c4 10             	add    $0x10,%esp
80105d6b:	85 c0                	test   %eax,%eax
80105d6d:	0f 88 8a 00 00 00    	js     80105dfd <sys_open+0xad>
80105d73:	83 ec 08             	sub    $0x8,%esp
80105d76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 01                	push   $0x1
80105d7c:	e8 5f f7 ff ff       	call   801054e0 <argint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 75                	js     80105dfd <sys_open+0xad>
    return -1;

  begin_op();
80105d88:	e8 c3 da ff ff       	call   80103850 <begin_op>

  if(omode & O_CREATE){
80105d8d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105d91:	75 75                	jne    80105e08 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105d93:	83 ec 0c             	sub    $0xc,%esp
80105d96:	ff 75 e0             	pushl  -0x20(%ebp)
80105d99:	e8 92 c2 ff ff       	call   80102030 <namei>
80105d9e:	83 c4 10             	add    $0x10,%esp
80105da1:	89 c6                	mov    %eax,%esi
80105da3:	85 c0                	test   %eax,%eax
80105da5:	74 7e                	je     80105e25 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105da7:	83 ec 0c             	sub    $0xc,%esp
80105daa:	50                   	push   %eax
80105dab:	e8 b0 b9 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105db0:	83 c4 10             	add    $0x10,%esp
80105db3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105db8:	0f 84 c2 00 00 00    	je     80105e80 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105dbe:	e8 3d b0 ff ff       	call   80100e00 <filealloc>
80105dc3:	89 c7                	mov    %eax,%edi
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	74 23                	je     80105dec <sys_open+0x9c>
  struct proc *curproc = myproc();
80105dc9:	e8 02 e7 ff ff       	call   801044d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105dd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105dd4:	85 d2                	test   %edx,%edx
80105dd6:	74 60                	je     80105e38 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105dd8:	83 c3 01             	add    $0x1,%ebx
80105ddb:	83 fb 10             	cmp    $0x10,%ebx
80105dde:	75 f0                	jne    80105dd0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105de0:	83 ec 0c             	sub    $0xc,%esp
80105de3:	57                   	push   %edi
80105de4:	e8 d7 b0 ff ff       	call   80100ec0 <fileclose>
80105de9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105dec:	83 ec 0c             	sub    $0xc,%esp
80105def:	56                   	push   %esi
80105df0:	e8 0b bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105df5:	e8 c6 da ff ff       	call   801038c0 <end_op>
    return -1;
80105dfa:	83 c4 10             	add    $0x10,%esp
80105dfd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e02:	eb 6d                	jmp    80105e71 <sys_open+0x121>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105e08:	83 ec 0c             	sub    $0xc,%esp
80105e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e0e:	31 c9                	xor    %ecx,%ecx
80105e10:	ba 02 00 00 00       	mov    $0x2,%edx
80105e15:	6a 00                	push   $0x0
80105e17:	e8 24 f8 ff ff       	call   80105640 <create>
    if(ip == 0){
80105e1c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105e1f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105e21:	85 c0                	test   %eax,%eax
80105e23:	75 99                	jne    80105dbe <sys_open+0x6e>
      end_op();
80105e25:	e8 96 da ff ff       	call   801038c0 <end_op>
      return -1;
80105e2a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e2f:	eb 40                	jmp    80105e71 <sys_open+0x121>
80105e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105e38:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e3b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105e3f:	56                   	push   %esi
80105e40:	e8 fb b9 ff ff       	call   80101840 <iunlock>
  end_op();
80105e45:	e8 76 da ff ff       	call   801038c0 <end_op>

  f->type = FD_INODE;
80105e4a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e53:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e56:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105e59:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105e5b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e62:	f7 d0                	not    %eax
80105e64:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e67:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e6a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e6d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e74:	89 d8                	mov    %ebx,%eax
80105e76:	5b                   	pop    %ebx
80105e77:	5e                   	pop    %esi
80105e78:	5f                   	pop    %edi
80105e79:	5d                   	pop    %ebp
80105e7a:	c3                   	ret    
80105e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e7f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e80:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105e83:	85 c9                	test   %ecx,%ecx
80105e85:	0f 84 33 ff ff ff    	je     80105dbe <sys_open+0x6e>
80105e8b:	e9 5c ff ff ff       	jmp    80105dec <sys_open+0x9c>

80105e90 <sys_mkdir>:

int
sys_mkdir(void)
{
80105e90:	f3 0f 1e fb          	endbr32 
80105e94:	55                   	push   %ebp
80105e95:	89 e5                	mov    %esp,%ebp
80105e97:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e9a:	e8 b1 d9 ff ff       	call   80103850 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105e9f:	83 ec 08             	sub    $0x8,%esp
80105ea2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea5:	50                   	push   %eax
80105ea6:	6a 00                	push   $0x0
80105ea8:	e8 e3 f6 ff ff       	call   80105590 <argstr>
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	85 c0                	test   %eax,%eax
80105eb2:	78 34                	js     80105ee8 <sys_mkdir+0x58>
80105eb4:	83 ec 0c             	sub    $0xc,%esp
80105eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eba:	31 c9                	xor    %ecx,%ecx
80105ebc:	ba 01 00 00 00       	mov    $0x1,%edx
80105ec1:	6a 00                	push   $0x0
80105ec3:	e8 78 f7 ff ff       	call   80105640 <create>
80105ec8:	83 c4 10             	add    $0x10,%esp
80105ecb:	85 c0                	test   %eax,%eax
80105ecd:	74 19                	je     80105ee8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ecf:	83 ec 0c             	sub    $0xc,%esp
80105ed2:	50                   	push   %eax
80105ed3:	e8 28 bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105ed8:	e8 e3 d9 ff ff       	call   801038c0 <end_op>
  return 0;
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	31 c0                	xor    %eax,%eax
}
80105ee2:	c9                   	leave  
80105ee3:	c3                   	ret    
80105ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ee8:	e8 d3 d9 ff ff       	call   801038c0 <end_op>
    return -1;
80105eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ef2:	c9                   	leave  
80105ef3:	c3                   	ret    
80105ef4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eff:	90                   	nop

80105f00 <sys_mknod>:

int
sys_mknod(void)
{
80105f00:	f3 0f 1e fb          	endbr32 
80105f04:	55                   	push   %ebp
80105f05:	89 e5                	mov    %esp,%ebp
80105f07:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f0a:	e8 41 d9 ff ff       	call   80103850 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f0f:	83 ec 08             	sub    $0x8,%esp
80105f12:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f15:	50                   	push   %eax
80105f16:	6a 00                	push   $0x0
80105f18:	e8 73 f6 ff ff       	call   80105590 <argstr>
80105f1d:	83 c4 10             	add    $0x10,%esp
80105f20:	85 c0                	test   %eax,%eax
80105f22:	78 64                	js     80105f88 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105f24:	83 ec 08             	sub    $0x8,%esp
80105f27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f2a:	50                   	push   %eax
80105f2b:	6a 01                	push   $0x1
80105f2d:	e8 ae f5 ff ff       	call   801054e0 <argint>
  if((argstr(0, &path)) < 0 ||
80105f32:	83 c4 10             	add    $0x10,%esp
80105f35:	85 c0                	test   %eax,%eax
80105f37:	78 4f                	js     80105f88 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105f39:	83 ec 08             	sub    $0x8,%esp
80105f3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f3f:	50                   	push   %eax
80105f40:	6a 02                	push   $0x2
80105f42:	e8 99 f5 ff ff       	call   801054e0 <argint>
     argint(1, &major) < 0 ||
80105f47:	83 c4 10             	add    $0x10,%esp
80105f4a:	85 c0                	test   %eax,%eax
80105f4c:	78 3a                	js     80105f88 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105f4e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105f52:	83 ec 0c             	sub    $0xc,%esp
80105f55:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105f59:	ba 03 00 00 00       	mov    $0x3,%edx
80105f5e:	50                   	push   %eax
80105f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f62:	e8 d9 f6 ff ff       	call   80105640 <create>
     argint(2, &minor) < 0 ||
80105f67:	83 c4 10             	add    $0x10,%esp
80105f6a:	85 c0                	test   %eax,%eax
80105f6c:	74 1a                	je     80105f88 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f6e:	83 ec 0c             	sub    $0xc,%esp
80105f71:	50                   	push   %eax
80105f72:	e8 89 ba ff ff       	call   80101a00 <iunlockput>
  end_op();
80105f77:	e8 44 d9 ff ff       	call   801038c0 <end_op>
  return 0;
80105f7c:	83 c4 10             	add    $0x10,%esp
80105f7f:	31 c0                	xor    %eax,%eax
}
80105f81:	c9                   	leave  
80105f82:	c3                   	ret    
80105f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f87:	90                   	nop
    end_op();
80105f88:	e8 33 d9 ff ff       	call   801038c0 <end_op>
    return -1;
80105f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f92:	c9                   	leave  
80105f93:	c3                   	ret    
80105f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f9f:	90                   	nop

80105fa0 <sys_chdir>:

int
sys_chdir(void)
{
80105fa0:	f3 0f 1e fb          	endbr32 
80105fa4:	55                   	push   %ebp
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	56                   	push   %esi
80105fa8:	53                   	push   %ebx
80105fa9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105fac:	e8 1f e5 ff ff       	call   801044d0 <myproc>
80105fb1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105fb3:	e8 98 d8 ff ff       	call   80103850 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105fb8:	83 ec 08             	sub    $0x8,%esp
80105fbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fbe:	50                   	push   %eax
80105fbf:	6a 00                	push   $0x0
80105fc1:	e8 ca f5 ff ff       	call   80105590 <argstr>
80105fc6:	83 c4 10             	add    $0x10,%esp
80105fc9:	85 c0                	test   %eax,%eax
80105fcb:	78 73                	js     80106040 <sys_chdir+0xa0>
80105fcd:	83 ec 0c             	sub    $0xc,%esp
80105fd0:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd3:	e8 58 c0 ff ff       	call   80102030 <namei>
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	89 c3                	mov    %eax,%ebx
80105fdd:	85 c0                	test   %eax,%eax
80105fdf:	74 5f                	je     80106040 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105fe1:	83 ec 0c             	sub    $0xc,%esp
80105fe4:	50                   	push   %eax
80105fe5:	e8 76 b7 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ff2:	75 2c                	jne    80106020 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	53                   	push   %ebx
80105ff8:	e8 43 b8 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105ffd:	58                   	pop    %eax
80105ffe:	ff 76 68             	pushl  0x68(%esi)
80106001:	e8 8a b8 ff ff       	call   80101890 <iput>
  end_op();
80106006:	e8 b5 d8 ff ff       	call   801038c0 <end_op>
  curproc->cwd = ip;
8010600b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	31 c0                	xor    %eax,%eax
}
80106013:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106016:	5b                   	pop    %ebx
80106017:	5e                   	pop    %esi
80106018:	5d                   	pop    %ebp
80106019:	c3                   	ret    
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	53                   	push   %ebx
80106024:	e8 d7 b9 ff ff       	call   80101a00 <iunlockput>
    end_op();
80106029:	e8 92 d8 ff ff       	call   801038c0 <end_op>
    return -1;
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106036:	eb db                	jmp    80106013 <sys_chdir+0x73>
80106038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603f:	90                   	nop
    end_op();
80106040:	e8 7b d8 ff ff       	call   801038c0 <end_op>
    return -1;
80106045:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604a:	eb c7                	jmp    80106013 <sys_chdir+0x73>
8010604c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106050 <sys_exec>:

int
sys_exec(void)
{
80106050:	f3 0f 1e fb          	endbr32 
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	57                   	push   %edi
80106058:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106059:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010605f:	53                   	push   %ebx
80106060:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106066:	50                   	push   %eax
80106067:	6a 00                	push   $0x0
80106069:	e8 22 f5 ff ff       	call   80105590 <argstr>
8010606e:	83 c4 10             	add    $0x10,%esp
80106071:	85 c0                	test   %eax,%eax
80106073:	0f 88 8b 00 00 00    	js     80106104 <sys_exec+0xb4>
80106079:	83 ec 08             	sub    $0x8,%esp
8010607c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106082:	50                   	push   %eax
80106083:	6a 01                	push   $0x1
80106085:	e8 56 f4 ff ff       	call   801054e0 <argint>
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	85 c0                	test   %eax,%eax
8010608f:	78 73                	js     80106104 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106091:	83 ec 04             	sub    $0x4,%esp
80106094:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010609a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010609c:	68 80 00 00 00       	push   $0x80
801060a1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801060a7:	6a 00                	push   $0x0
801060a9:	50                   	push   %eax
801060aa:	e8 51 f1 ff ff       	call   80105200 <memset>
801060af:	83 c4 10             	add    $0x10,%esp
801060b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801060b8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801060be:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801060c5:	83 ec 08             	sub    $0x8,%esp
801060c8:	57                   	push   %edi
801060c9:	01 f0                	add    %esi,%eax
801060cb:	50                   	push   %eax
801060cc:	e8 6f f3 ff ff       	call   80105440 <fetchint>
801060d1:	83 c4 10             	add    $0x10,%esp
801060d4:	85 c0                	test   %eax,%eax
801060d6:	78 2c                	js     80106104 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801060d8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801060de:	85 c0                	test   %eax,%eax
801060e0:	74 36                	je     80106118 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801060e2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801060e8:	83 ec 08             	sub    $0x8,%esp
801060eb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801060ee:	52                   	push   %edx
801060ef:	50                   	push   %eax
801060f0:	e8 8b f3 ff ff       	call   80105480 <fetchstr>
801060f5:	83 c4 10             	add    $0x10,%esp
801060f8:	85 c0                	test   %eax,%eax
801060fa:	78 08                	js     80106104 <sys_exec+0xb4>
  for(i=0;; i++){
801060fc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801060ff:	83 fb 20             	cmp    $0x20,%ebx
80106102:	75 b4                	jne    801060b8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106104:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106107:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010610c:	5b                   	pop    %ebx
8010610d:	5e                   	pop    %esi
8010610e:	5f                   	pop    %edi
8010610f:	5d                   	pop    %ebp
80106110:	c3                   	ret    
80106111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106118:	83 ec 08             	sub    $0x8,%esp
8010611b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106121:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106128:	00 00 00 00 
  return exec(path, argv);
8010612c:	50                   	push   %eax
8010612d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106133:	e8 48 a9 ff ff       	call   80100a80 <exec>
80106138:	83 c4 10             	add    $0x10,%esp
}
8010613b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010613e:	5b                   	pop    %ebx
8010613f:	5e                   	pop    %esi
80106140:	5f                   	pop    %edi
80106141:	5d                   	pop    %ebp
80106142:	c3                   	ret    
80106143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106150 <sys_pipe>:

int
sys_pipe(void)
{
80106150:	f3 0f 1e fb          	endbr32 
80106154:	55                   	push   %ebp
80106155:	89 e5                	mov    %esp,%ebp
80106157:	57                   	push   %edi
80106158:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106159:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010615c:	53                   	push   %ebx
8010615d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106160:	6a 08                	push   $0x8
80106162:	50                   	push   %eax
80106163:	6a 00                	push   $0x0
80106165:	e8 c6 f3 ff ff       	call   80105530 <argptr>
8010616a:	83 c4 10             	add    $0x10,%esp
8010616d:	85 c0                	test   %eax,%eax
8010616f:	78 4e                	js     801061bf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106171:	83 ec 08             	sub    $0x8,%esp
80106174:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106177:	50                   	push   %eax
80106178:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010617b:	50                   	push   %eax
8010617c:	e8 df dd ff ff       	call   80103f60 <pipealloc>
80106181:	83 c4 10             	add    $0x10,%esp
80106184:	85 c0                	test   %eax,%eax
80106186:	78 37                	js     801061bf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106188:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010618b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010618d:	e8 3e e3 ff ff       	call   801044d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106198:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010619c:	85 f6                	test   %esi,%esi
8010619e:	74 30                	je     801061d0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801061a0:	83 c3 01             	add    $0x1,%ebx
801061a3:	83 fb 10             	cmp    $0x10,%ebx
801061a6:	75 f0                	jne    80106198 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801061a8:	83 ec 0c             	sub    $0xc,%esp
801061ab:	ff 75 e0             	pushl  -0x20(%ebp)
801061ae:	e8 0d ad ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801061b3:	58                   	pop    %eax
801061b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801061b7:	e8 04 ad ff ff       	call   80100ec0 <fileclose>
    return -1;
801061bc:	83 c4 10             	add    $0x10,%esp
801061bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c4:	eb 5b                	jmp    80106221 <sys_pipe+0xd1>
801061c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801061d0:	8d 73 08             	lea    0x8(%ebx),%esi
801061d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801061da:	e8 f1 e2 ff ff       	call   801044d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801061df:	31 d2                	xor    %edx,%edx
801061e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801061e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801061ec:	85 c9                	test   %ecx,%ecx
801061ee:	74 20                	je     80106210 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801061f0:	83 c2 01             	add    $0x1,%edx
801061f3:	83 fa 10             	cmp    $0x10,%edx
801061f6:	75 f0                	jne    801061e8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801061f8:	e8 d3 e2 ff ff       	call   801044d0 <myproc>
801061fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106204:	00 
80106205:	eb a1                	jmp    801061a8 <sys_pipe+0x58>
80106207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106210:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106214:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106217:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106219:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010621c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010621f:	31 c0                	xor    %eax,%eax
}
80106221:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106224:	5b                   	pop    %ebx
80106225:	5e                   	pop    %esi
80106226:	5f                   	pop    %edi
80106227:	5d                   	pop    %ebp
80106228:	c3                   	ret    
80106229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106230 <sys_swapread>:

int sys_swapread(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
8010623a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010623d:	68 00 10 00 00       	push   $0x1000
80106242:	50                   	push   %eax
80106243:	6a 00                	push   $0x0
80106245:	e8 e6 f2 ff ff       	call   80105530 <argptr>
8010624a:	83 c4 10             	add    $0x10,%esp
8010624d:	85 c0                	test   %eax,%eax
8010624f:	78 2f                	js     80106280 <sys_swapread+0x50>
80106251:	83 ec 08             	sub    $0x8,%esp
80106254:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106257:	50                   	push   %eax
80106258:	6a 01                	push   $0x1
8010625a:	e8 81 f2 ff ff       	call   801054e0 <argint>
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	85 c0                	test   %eax,%eax
80106264:	78 1a                	js     80106280 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80106266:	83 ec 08             	sub    $0x8,%esp
80106269:	ff 75 f4             	pushl  -0xc(%ebp)
8010626c:	ff 75 f0             	pushl  -0x10(%ebp)
8010626f:	e8 fc bd ff ff       	call   80102070 <swapread>
	return 0;
80106274:	83 c4 10             	add    $0x10,%esp
80106277:	31 c0                	xor    %eax,%eax
}
80106279:	c9                   	leave  
8010627a:	c3                   	ret    
8010627b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010627f:	90                   	nop
80106280:	c9                   	leave  
		return -1;
80106281:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106286:	c3                   	ret    
80106287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010628e:	66 90                	xchg   %ax,%ax

80106290 <sys_swapwrite>:

int sys_swapwrite(void)
{
80106290:	f3 0f 1e fb          	endbr32 
80106294:	55                   	push   %ebp
80106295:	89 e5                	mov    %esp,%ebp
80106297:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
8010629a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010629d:	68 00 10 00 00       	push   $0x1000
801062a2:	50                   	push   %eax
801062a3:	6a 00                	push   $0x0
801062a5:	e8 86 f2 ff ff       	call   80105530 <argptr>
801062aa:	83 c4 10             	add    $0x10,%esp
801062ad:	85 c0                	test   %eax,%eax
801062af:	78 2f                	js     801062e0 <sys_swapwrite+0x50>
801062b1:	83 ec 08             	sub    $0x8,%esp
801062b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062b7:	50                   	push   %eax
801062b8:	6a 01                	push   $0x1
801062ba:	e8 21 f2 ff ff       	call   801054e0 <argint>
801062bf:	83 c4 10             	add    $0x10,%esp
801062c2:	85 c0                	test   %eax,%eax
801062c4:	78 1a                	js     801062e0 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
801062c6:	83 ec 08             	sub    $0x8,%esp
801062c9:	ff 75 f4             	pushl  -0xc(%ebp)
801062cc:	ff 75 f0             	pushl  -0x10(%ebp)
801062cf:	e8 3c be ff ff       	call   80102110 <swapwrite>
	return 0;
801062d4:	83 c4 10             	add    $0x10,%esp
801062d7:	31 c0                	xor    %eax,%eax
}
801062d9:	c9                   	leave  
801062da:	c3                   	ret    
801062db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062df:	90                   	nop
801062e0:	c9                   	leave  
		return -1;
801062e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062e6:	c3                   	ret    
801062e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ee:	66 90                	xchg   %ax,%ax

801062f0 <sys_swapstat>:

int sys_swapstat(void)
{
801062f0:	f3 0f 1e fb          	endbr32 
801062f4:	55                   	push   %ebp
801062f5:	89 e5                	mov    %esp,%ebp
801062f7:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
801062f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
801062fb:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
801062fe:	6a 04                	push   $0x4
80106300:	50                   	push   %eax
80106301:	6a 00                	push   $0x0
80106303:	e8 28 f2 ff ff       	call   80105530 <argptr>
80106308:	83 c4 10             	add    $0x10,%esp
8010630b:	85 c0                	test   %eax,%eax
8010630d:	75 39                	jne    80106348 <sys_swapstat+0x58>
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
8010630f:	83 ec 04             	sub    $0x4,%esp
80106312:	89 c3                	mov    %eax,%ebx
80106314:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106317:	6a 04                	push   $0x4
80106319:	50                   	push   %eax
8010631a:	6a 01                	push   $0x1
8010631c:	e8 0f f2 ff ff       	call   80105530 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80106321:	83 c4 10             	add    $0x10,%esp
80106324:	85 c0                	test   %eax,%eax
80106326:	78 20                	js     80106348 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
80106328:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010632b:	8b 15 e0 29 11 80    	mov    0x801129e0,%edx
80106331:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
80106333:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106336:	8b 15 00 2a 11 80    	mov    0x80112a00,%edx
8010633c:	89 10                	mov    %edx,(%eax)
	return 0;
}
8010633e:	89 d8                	mov    %ebx,%eax
80106340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106343:	c9                   	leave  
80106344:	c3                   	ret    
80106345:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
80106348:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010634d:	eb ef                	jmp    8010633e <sys_swapstat+0x4e>
8010634f:	90                   	nop

80106350 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106350:	f3 0f 1e fb          	endbr32 
  return fork();
80106354:	e9 47 e3 ff ff       	jmp    801046a0 <fork>
80106359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106360 <sys_exit>:
}

int
sys_exit(void)
{
80106360:	f3 0f 1e fb          	endbr32 
80106364:	55                   	push   %ebp
80106365:	89 e5                	mov    %esp,%ebp
80106367:	83 ec 08             	sub    $0x8,%esp
  exit();
8010636a:	e8 b1 e5 ff ff       	call   80104920 <exit>
  return 0;  // not reached
}
8010636f:	31 c0                	xor    %eax,%eax
80106371:	c9                   	leave  
80106372:	c3                   	ret    
80106373:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010637a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106380 <sys_wait>:

int
sys_wait(void)
{
80106380:	f3 0f 1e fb          	endbr32 
  return wait();
80106384:	e9 e7 e7 ff ff       	jmp    80104b70 <wait>
80106389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106390 <sys_kill>:
}

int
sys_kill(void)
{
80106390:	f3 0f 1e fb          	endbr32 
80106394:	55                   	push   %ebp
80106395:	89 e5                	mov    %esp,%ebp
80106397:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010639a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010639d:	50                   	push   %eax
8010639e:	6a 00                	push   $0x0
801063a0:	e8 3b f1 ff ff       	call   801054e0 <argint>
801063a5:	83 c4 10             	add    $0x10,%esp
801063a8:	85 c0                	test   %eax,%eax
801063aa:	78 14                	js     801063c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801063ac:	83 ec 0c             	sub    $0xc,%esp
801063af:	ff 75 f4             	pushl  -0xc(%ebp)
801063b2:	e8 19 e9 ff ff       	call   80104cd0 <kill>
801063b7:	83 c4 10             	add    $0x10,%esp
}
801063ba:	c9                   	leave  
801063bb:	c3                   	ret    
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063c0:	c9                   	leave  
    return -1;
801063c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063c6:	c3                   	ret    
801063c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ce:	66 90                	xchg   %ax,%ax

801063d0 <sys_getpid>:

int
sys_getpid(void)
{
801063d0:	f3 0f 1e fb          	endbr32 
801063d4:	55                   	push   %ebp
801063d5:	89 e5                	mov    %esp,%ebp
801063d7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801063da:	e8 f1 e0 ff ff       	call   801044d0 <myproc>
801063df:	8b 40 10             	mov    0x10(%eax),%eax
}
801063e2:	c9                   	leave  
801063e3:	c3                   	ret    
801063e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063ef:	90                   	nop

801063f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801063f0:	f3 0f 1e fb          	endbr32 
801063f4:	55                   	push   %ebp
801063f5:	89 e5                	mov    %esp,%ebp
801063f7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801063f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801063fb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801063fe:	50                   	push   %eax
801063ff:	6a 00                	push   $0x0
80106401:	e8 da f0 ff ff       	call   801054e0 <argint>
80106406:	83 c4 10             	add    $0x10,%esp
80106409:	85 c0                	test   %eax,%eax
8010640b:	78 23                	js     80106430 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010640d:	e8 be e0 ff ff       	call   801044d0 <myproc>
  if(growproc(n) < 0)
80106412:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106415:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106417:	ff 75 f4             	pushl  -0xc(%ebp)
8010641a:	e8 01 e2 ff ff       	call   80104620 <growproc>
8010641f:	83 c4 10             	add    $0x10,%esp
80106422:	85 c0                	test   %eax,%eax
80106424:	78 0a                	js     80106430 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106426:	89 d8                	mov    %ebx,%eax
80106428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010642b:	c9                   	leave  
8010642c:	c3                   	ret    
8010642d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106430:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106435:	eb ef                	jmp    80106426 <sys_sbrk+0x36>
80106437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010643e:	66 90                	xchg   %ax,%ax

80106440 <sys_sleep>:

int
sys_sleep(void)
{
80106440:	f3 0f 1e fb          	endbr32 
80106444:	55                   	push   %ebp
80106445:	89 e5                	mov    %esp,%ebp
80106447:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106448:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010644b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010644e:	50                   	push   %eax
8010644f:	6a 00                	push   $0x0
80106451:	e8 8a f0 ff ff       	call   801054e0 <argint>
80106456:	83 c4 10             	add    $0x10,%esp
80106459:	85 c0                	test   %eax,%eax
8010645b:	0f 88 86 00 00 00    	js     801064e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106461:	83 ec 0c             	sub    $0xc,%esp
80106464:	68 40 cd 13 80       	push   $0x8013cd40
80106469:	e8 82 ec ff ff       	call   801050f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010646e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106471:	8b 1d 80 d5 13 80    	mov    0x8013d580,%ebx
  while(ticks - ticks0 < n){
80106477:	83 c4 10             	add    $0x10,%esp
8010647a:	85 d2                	test   %edx,%edx
8010647c:	75 23                	jne    801064a1 <sys_sleep+0x61>
8010647e:	eb 50                	jmp    801064d0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106480:	83 ec 08             	sub    $0x8,%esp
80106483:	68 40 cd 13 80       	push   $0x8013cd40
80106488:	68 80 d5 13 80       	push   $0x8013d580
8010648d:	e8 1e e6 ff ff       	call   80104ab0 <sleep>
  while(ticks - ticks0 < n){
80106492:	a1 80 d5 13 80       	mov    0x8013d580,%eax
80106497:	83 c4 10             	add    $0x10,%esp
8010649a:	29 d8                	sub    %ebx,%eax
8010649c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010649f:	73 2f                	jae    801064d0 <sys_sleep+0x90>
    if(myproc()->killed){
801064a1:	e8 2a e0 ff ff       	call   801044d0 <myproc>
801064a6:	8b 40 24             	mov    0x24(%eax),%eax
801064a9:	85 c0                	test   %eax,%eax
801064ab:	74 d3                	je     80106480 <sys_sleep+0x40>
      release(&tickslock);
801064ad:	83 ec 0c             	sub    $0xc,%esp
801064b0:	68 40 cd 13 80       	push   $0x8013cd40
801064b5:	e8 f6 ec ff ff       	call   801051b0 <release>
  }
  release(&tickslock);
  return 0;
}
801064ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801064bd:	83 c4 10             	add    $0x10,%esp
801064c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064c5:	c9                   	leave  
801064c6:	c3                   	ret    
801064c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801064d0:	83 ec 0c             	sub    $0xc,%esp
801064d3:	68 40 cd 13 80       	push   $0x8013cd40
801064d8:	e8 d3 ec ff ff       	call   801051b0 <release>
  return 0;
801064dd:	83 c4 10             	add    $0x10,%esp
801064e0:	31 c0                	xor    %eax,%eax
}
801064e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064e5:	c9                   	leave  
801064e6:	c3                   	ret    
    return -1;
801064e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ec:	eb f4                	jmp    801064e2 <sys_sleep+0xa2>
801064ee:	66 90                	xchg   %ax,%ax

801064f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801064f0:	f3 0f 1e fb          	endbr32 
801064f4:	55                   	push   %ebp
801064f5:	89 e5                	mov    %esp,%ebp
801064f7:	53                   	push   %ebx
801064f8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801064fb:	68 40 cd 13 80       	push   $0x8013cd40
80106500:	e8 eb eb ff ff       	call   801050f0 <acquire>
  xticks = ticks;
80106505:	8b 1d 80 d5 13 80    	mov    0x8013d580,%ebx
  release(&tickslock);
8010650b:	c7 04 24 40 cd 13 80 	movl   $0x8013cd40,(%esp)
80106512:	e8 99 ec ff ff       	call   801051b0 <release>
  return xticks;
}
80106517:	89 d8                	mov    %ebx,%eax
80106519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010651c:	c9                   	leave  
8010651d:	c3                   	ret    

8010651e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010651e:	1e                   	push   %ds
  pushl %es
8010651f:	06                   	push   %es
  pushl %fs
80106520:	0f a0                	push   %fs
  pushl %gs
80106522:	0f a8                	push   %gs
  pushal
80106524:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106525:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106529:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010652b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010652d:	54                   	push   %esp
  call trap
8010652e:	e8 ed 01 00 00       	call   80106720 <trap>
  addl $4, %esp
80106533:	83 c4 04             	add    $0x4,%esp

80106536 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106536:	61                   	popa   
  popl %gs
80106537:	0f a9                	pop    %gs
  popl %fs
80106539:	0f a1                	pop    %fs
  popl %es
8010653b:	07                   	pop    %es
  popl %ds
8010653c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010653d:	83 c4 08             	add    $0x8,%esp
  iret
80106540:	cf                   	iret   
80106541:	66 90                	xchg   %ax,%ax
80106543:	66 90                	xchg   %ax,%ax
80106545:	66 90                	xchg   %ax,%ax
80106547:	66 90                	xchg   %ax,%ax
80106549:	66 90                	xchg   %ax,%ax
8010654b:	66 90                	xchg   %ax,%ax
8010654d:	66 90                	xchg   %ax,%ax
8010654f:	90                   	nop

80106550 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106550:	f3 0f 1e fb          	endbr32 
80106554:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106555:	31 c0                	xor    %eax,%eax
{
80106557:	89 e5                	mov    %esp,%ebp
80106559:	83 ec 08             	sub    $0x8,%esp
8010655c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106560:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106567:	c7 04 c5 82 cd 13 80 	movl   $0x8e000008,-0x7fec327e(,%eax,8)
8010656e:	08 00 00 8e 
80106572:	66 89 14 c5 80 cd 13 	mov    %dx,-0x7fec3280(,%eax,8)
80106579:	80 
8010657a:	c1 ea 10             	shr    $0x10,%edx
8010657d:	66 89 14 c5 86 cd 13 	mov    %dx,-0x7fec327a(,%eax,8)
80106584:	80 
  for(i = 0; i < 256; i++)
80106585:	83 c0 01             	add    $0x1,%eax
80106588:	3d 00 01 00 00       	cmp    $0x100,%eax
8010658d:	75 d1                	jne    80106560 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010658f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106592:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106597:	c7 05 82 cf 13 80 08 	movl   $0xef000008,0x8013cf82
8010659e:	00 00 ef 
  initlock(&tickslock, "time");
801065a1:	68 25 8f 10 80       	push   $0x80108f25
801065a6:	68 40 cd 13 80       	push   $0x8013cd40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065ab:	66 a3 80 cf 13 80    	mov    %ax,0x8013cf80
801065b1:	c1 e8 10             	shr    $0x10,%eax
801065b4:	66 a3 86 cf 13 80    	mov    %ax,0x8013cf86
  initlock(&tickslock, "time");
801065ba:	e8 b1 e9 ff ff       	call   80104f70 <initlock>
}
801065bf:	83 c4 10             	add    $0x10,%esp
801065c2:	c9                   	leave  
801065c3:	c3                   	ret    
801065c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065cf:	90                   	nop

801065d0 <idtinit>:

void
idtinit(void)
{
801065d0:	f3 0f 1e fb          	endbr32 
801065d4:	55                   	push   %ebp
  pd[0] = size-1;
801065d5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801065da:	89 e5                	mov    %esp,%ebp
801065dc:	83 ec 10             	sub    $0x10,%esp
801065df:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065e3:	b8 80 cd 13 80       	mov    $0x8013cd80,%eax
801065e8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065ec:	c1 e8 10             	shr    $0x10,%eax
801065ef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801065f3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065f6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801065f9:	c9                   	leave  
801065fa:	c3                   	ret    
801065fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065ff:	90                   	nop

80106600 <swapin>:

int swapin(struct trapframe* tf, int flt_addr){ // -1: KILL, 0: success
80106600:	f3 0f 1e fb          	endbr32 
80106604:	55                   	push   %ebp
80106605:	89 e5                	mov    %esp,%ebp
80106607:	57                   	push   %edi
80106608:	56                   	push   %esi
80106609:	53                   	push   %ebx
8010660a:	83 ec 1c             	sub    $0x1c,%esp
  // rcr2 = user.vaddr
  struct proc *cp = myproc();
8010660d:	e8 be de ff ff       	call   801044d0 <myproc>
  cprintf("here0\n");
80106612:	83 ec 0c             	sub    $0xc,%esp
80106615:	68 2a 8f 10 80       	push   $0x80108f2a
  struct proc *cp = myproc();
8010661a:	89 c3                	mov    %eax,%ebx
  cprintf("here0\n");
8010661c:	e8 8f a0 ff ff       	call   801006b0 <cprintf>
  pde_t *pde = cp->pgdir;
80106621:	8b 43 04             	mov    0x4(%ebx),%eax
  pte_t *pte = walkpgdir(pde, (void *)flt_addr, 1);
80106624:	83 c4 0c             	add    $0xc,%esp
80106627:	6a 01                	push   $0x1
80106629:	ff 75 0c             	pushl  0xc(%ebp)
8010662c:	50                   	push   %eax
8010662d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106630:	e8 1b 10 00 00       	call   80107650 <walkpgdir>
  cprintf("swapin: walkpgdir pgdir=%p flt_addr=%p *pte=%p\n", cp->pgdir, flt_addr, *pte);
80106635:	ff 30                	pushl  (%eax)
  pte_t *pte = walkpgdir(pde, (void *)flt_addr, 1);
80106637:	89 c7                	mov    %eax,%edi
  cprintf("swapin: walkpgdir pgdir=%p flt_addr=%p *pte=%p\n", cp->pgdir, flt_addr, *pte);
80106639:	ff 75 0c             	pushl  0xc(%ebp)
8010663c:	ff 73 04             	pushl  0x4(%ebx)
8010663f:	68 74 8f 10 80       	push   $0x80108f74
80106644:	e8 67 a0 ff ff       	call   801006b0 <cprintf>
  cprintf("here1\n");
80106649:	83 c4 14             	add    $0x14,%esp
8010664c:	68 31 8f 10 80       	push   $0x80108f31
80106651:	e8 5a a0 ff ff       	call   801006b0 <cprintf>
  if((!(*pte & PTE_P) && (*pte != (pte_t)0))){
80106656:	8b 07                	mov    (%edi),%eax
80106658:	83 c4 10             	add    $0x10,%esp
8010665b:	a8 01                	test   $0x1,%al
8010665d:	0f 85 9d 00 00 00    	jne    80106700 <swapin+0x100>
80106663:	85 c0                	test   %eax,%eax
80106665:	0f 84 95 00 00 00    	je     80106700 <swapin+0x100>
    cprintf("swapin: swapin really required for *pte=%p\n",*pte);
8010666b:	83 ec 08             	sub    $0x8,%esp
8010666e:	50                   	push   %eax
8010666f:	68 a4 8f 10 80       	push   $0x80108fa4
80106674:	e8 37 a0 ff ff       	call   801006b0 <cprintf>
    print_bitmap(0, 11);
80106679:	5e                   	pop    %esi
8010667a:	58                   	pop    %eax
8010667b:	6a 0b                	push   $0xb
8010667d:	6a 00                	push   $0x0
8010667f:	e8 0c bf ff ff       	call   80102590 <print_bitmap>
    uint block_number = (uint)(*pte) >> 12; // PFN 구하기(==block index)
80106684:	8b 37                	mov    (%edi),%esi
    char *mem = kalloc(); // get 'empty allocated kernel virtual address'
80106686:	e8 c5 ca ff ff       	call   80103150 <kalloc>
    if(bitmap[block_number]){
8010668b:	83 c4 10             	add    $0x10,%esp
    uint block_number = (uint)(*pte) >> 12; // PFN 구하기(==block index)
8010668e:	c1 ee 0c             	shr    $0xc,%esi
    if(bitmap[block_number]){
80106691:	8b 14 b5 c0 46 11 80 	mov    -0x7feeb940(,%esi,4),%edx
80106698:	85 d2                	test   %edx,%edx
8010669a:	74 6b                	je     80106707 <swapin+0x107>
      // 락 걸 것
      // if(kmem.use_lock)
        // release(&kmem.lock);
      swapread(mem, block_number);
8010669c:	83 ec 08             	sub    $0x8,%esp
8010669f:	89 45 e0             	mov    %eax,-0x20(%ebp)
801066a2:	56                   	push   %esi
801066a3:	50                   	push   %eax
801066a4:	e8 c7 b9 ff ff       	call   80102070 <swapread>
      // if(kmem.use_lock)
        // acquire(&kmem.lock);
    }else{
      panic("swapin: UNAVAILABLE bitmap\n");
    }
    uint pte_flag = *pte & 0x00000FFF;
801066a9:	8b 0f                	mov    (%edi),%ecx
    pte_flag |= PTE_P;  // set FLAG[0]=1
    *pte = V2P(mem) | pte_flag; // set pte[31:12]=PhyAddr(flt_addr) => 맞나?
801066ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
    uint pte_flag = *pte & 0x00000FFF;
801066ae:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    *pte = V2P(mem) | pte_flag; // set pte[31:12]=PhyAddr(flt_addr) => 맞나?
801066b4:	05 00 00 00 80       	add    $0x80000000,%eax
801066b9:	09 c8                	or     %ecx,%eax
801066bb:	83 c8 01             	or     $0x1,%eax
801066be:	89 07                	mov    %eax,(%edi)
    lru_append(cp->pgdir, (char*)flt_addr); // lru_append 에 va 인 flt_addr 를 넣는다 => cp=>pgdir 맞나?
801066c0:	58                   	pop    %eax
801066c1:	5a                   	pop    %edx
801066c2:	ff 75 0c             	pushl  0xc(%ebp)
801066c5:	ff 73 04             	pushl  0x4(%ebx)
801066c8:	e8 b3 c2 ff ff       	call   80102980 <lru_append>
    change_bitmap(block_number, 0); // clear corresponding bit in the bitmap
801066cd:	59                   	pop    %ecx
801066ce:	5b                   	pop    %ebx
801066cf:	6a 00                	push   $0x0
801066d1:	56                   	push   %esi
801066d2:	e8 09 bf ff ff       	call   801025e0 <change_bitmap>
    lcr3(V2P(pde));
801066d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801066da:	81 c7 00 00 00 80    	add    $0x80000000,%edi
  asm volatile("movl %0,%%cr3" : : "r" (val));
801066e0:	0f 22 df             	mov    %edi,%cr3
  }
  else{
    // panic("swapin don't needed => Code ERROR\n"); //
    return -1;
  }
  cprintf("swapin ended successfully\n");
801066e3:	c7 04 24 38 8f 10 80 	movl   $0x80108f38,(%esp)
801066ea:	e8 c1 9f ff ff       	call   801006b0 <cprintf>
  return 0;
801066ef:	83 c4 10             	add    $0x10,%esp
801066f2:	31 c0                	xor    %eax,%eax
}
801066f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f7:	5b                   	pop    %ebx
801066f8:	5e                   	pop    %esi
801066f9:	5f                   	pop    %edi
801066fa:	5d                   	pop    %ebp
801066fb:	c3                   	ret    
801066fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106705:	eb ed                	jmp    801066f4 <swapin+0xf4>
      panic("swapin: UNAVAILABLE bitmap\n");
80106707:	83 ec 0c             	sub    $0xc,%esp
8010670a:	68 53 8f 10 80       	push   $0x80108f53
8010670f:	e8 7c 9c ff ff       	call   80100390 <panic>
80106714:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010671b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010671f:	90                   	nop

80106720 <trap>:

void
trap(struct trapframe *tf)
{
80106720:	f3 0f 1e fb          	endbr32 
80106724:	55                   	push   %ebp
80106725:	89 e5                	mov    %esp,%ebp
80106727:	57                   	push   %edi
80106728:	56                   	push   %esi
80106729:	53                   	push   %ebx
8010672a:	83 ec 1c             	sub    $0x1c,%esp
8010672d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106730:	8b 43 30             	mov    0x30(%ebx),%eax
80106733:	83 f8 40             	cmp    $0x40,%eax
80106736:	0f 84 cc 01 00 00    	je     80106908 <trap+0x1e8>
    if(myproc()->killed)
      exit();
    return;
  }
  // My Code
  if(tf->trapno == T_PGFLT){
8010673c:	83 f8 0e             	cmp    $0xe,%eax
8010673f:	74 17                	je     80106758 <trap+0x38>
      goto KILL;
    }
    return;
  }

  switch(tf->trapno){
80106741:	83 e8 20             	sub    $0x20,%eax
80106744:	83 f8 1f             	cmp    $0x1f,%eax
80106747:	77 3d                	ja     80106786 <trap+0x66>
80106749:	3e ff 24 85 90 90 10 	notrack jmp *-0x7fef6f70(,%eax,4)
80106750:	80 
80106751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106758:	0f 20 d6             	mov    %cr2,%esi
    cprintf("trap(): T_PGFLT pgdir=%p, rcr2=%p\n",myproc()->pgdir, flt_addr);
8010675b:	e8 70 dd ff ff       	call   801044d0 <myproc>
80106760:	83 ec 04             	sub    $0x4,%esp
80106763:	56                   	push   %esi
80106764:	ff 70 04             	pushl  0x4(%eax)
80106767:	68 d0 8f 10 80       	push   $0x80108fd0
8010676c:	e8 3f 9f ff ff       	call   801006b0 <cprintf>
    if (swapin(tf, flt_addr) == -1)
80106771:	59                   	pop    %ecx
80106772:	5f                   	pop    %edi
80106773:	56                   	push   %esi
80106774:	53                   	push   %ebx
80106775:	e8 86 fe ff ff       	call   80106600 <swapin>
8010677a:	83 c4 10             	add    $0x10,%esp
8010677d:	83 f8 ff             	cmp    $0xffffffff,%eax
80106780:	0f 85 d2 00 00 00    	jne    80106858 <trap+0x138>
    lapiceoi();
    break;

  KILL:
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106786:	e8 45 dd ff ff       	call   801044d0 <myproc>
8010678b:	8b 7b 38             	mov    0x38(%ebx),%edi
8010678e:	85 c0                	test   %eax,%eax
80106790:	0f 84 fe 01 00 00    	je     80106994 <trap+0x274>
80106796:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010679a:	0f 84 f4 01 00 00    	je     80106994 <trap+0x274>
801067a0:	0f 20 d1             	mov    %cr2,%ecx
801067a3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067a6:	e8 05 dd ff ff       	call   801044b0 <cpuid>
801067ab:	8b 73 30             	mov    0x30(%ebx),%esi
801067ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
801067b1:	8b 43 34             	mov    0x34(%ebx),%eax
801067b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801067b7:	e8 14 dd ff ff       	call   801044d0 <myproc>
801067bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801067bf:	e8 0c dd ff ff       	call   801044d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067c4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801067c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
801067ca:	51                   	push   %ecx
801067cb:	57                   	push   %edi
801067cc:	52                   	push   %edx
801067cd:	ff 75 e4             	pushl  -0x1c(%ebp)
801067d0:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801067d1:	8b 75 e0             	mov    -0x20(%ebp),%esi
801067d4:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067d7:	56                   	push   %esi
801067d8:	ff 70 10             	pushl  0x10(%eax)
801067db:	68 4c 90 10 80       	push   $0x8010904c
801067e0:	e8 cb 9e ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801067e5:	83 c4 20             	add    $0x20,%esp
801067e8:	e8 e3 dc ff ff       	call   801044d0 <myproc>
801067ed:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067f4:	e8 d7 dc ff ff       	call   801044d0 <myproc>
801067f9:	85 c0                	test   %eax,%eax
801067fb:	74 1d                	je     8010681a <trap+0xfa>
801067fd:	e8 ce dc ff ff       	call   801044d0 <myproc>
80106802:	8b 50 24             	mov    0x24(%eax),%edx
80106805:	85 d2                	test   %edx,%edx
80106807:	74 11                	je     8010681a <trap+0xfa>
80106809:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010680d:	83 e0 03             	and    $0x3,%eax
80106810:	66 83 f8 03          	cmp    $0x3,%ax
80106814:	0f 84 26 01 00 00    	je     80106940 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010681a:	e8 b1 dc ff ff       	call   801044d0 <myproc>
8010681f:	85 c0                	test   %eax,%eax
80106821:	74 0f                	je     80106832 <trap+0x112>
80106823:	e8 a8 dc ff ff       	call   801044d0 <myproc>
80106828:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010682c:	0f 84 be 00 00 00    	je     801068f0 <trap+0x1d0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
       yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106832:	e8 99 dc ff ff       	call   801044d0 <myproc>
80106837:	85 c0                	test   %eax,%eax
80106839:	74 1d                	je     80106858 <trap+0x138>
8010683b:	e8 90 dc ff ff       	call   801044d0 <myproc>
80106840:	8b 40 24             	mov    0x24(%eax),%eax
80106843:	85 c0                	test   %eax,%eax
80106845:	74 11                	je     80106858 <trap+0x138>
80106847:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010684b:	83 e0 03             	and    $0x3,%eax
8010684e:	66 83 f8 03          	cmp    $0x3,%ax
80106852:	0f 84 d9 00 00 00    	je     80106931 <trap+0x211>
    exit();
}
80106858:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010685b:	5b                   	pop    %ebx
8010685c:	5e                   	pop    %esi
8010685d:	5f                   	pop    %edi
8010685e:	5d                   	pop    %ebp
8010685f:	c3                   	ret    
    if(cpuid() == 0){
80106860:	e8 4b dc ff ff       	call   801044b0 <cpuid>
80106865:	85 c0                	test   %eax,%eax
80106867:	0f 84 f3 00 00 00    	je     80106960 <trap+0x240>
    lapiceoi();
8010686d:	e8 6e cb ff ff       	call   801033e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106872:	e8 59 dc ff ff       	call   801044d0 <myproc>
80106877:	85 c0                	test   %eax,%eax
80106879:	75 82                	jne    801067fd <trap+0xdd>
8010687b:	eb 9d                	jmp    8010681a <trap+0xfa>
    kbdintr();
8010687d:	e8 1e ca ff ff       	call   801032a0 <kbdintr>
    lapiceoi();
80106882:	e8 59 cb ff ff       	call   801033e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106887:	e8 44 dc ff ff       	call   801044d0 <myproc>
8010688c:	85 c0                	test   %eax,%eax
8010688e:	0f 85 69 ff ff ff    	jne    801067fd <trap+0xdd>
80106894:	eb 84                	jmp    8010681a <trap+0xfa>
    uartintr();
80106896:	e8 95 02 00 00       	call   80106b30 <uartintr>
    lapiceoi();
8010689b:	e8 40 cb ff ff       	call   801033e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801068a0:	e8 2b dc ff ff       	call   801044d0 <myproc>
801068a5:	85 c0                	test   %eax,%eax
801068a7:	0f 85 50 ff ff ff    	jne    801067fd <trap+0xdd>
801068ad:	e9 68 ff ff ff       	jmp    8010681a <trap+0xfa>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068b2:	8b 7b 38             	mov    0x38(%ebx),%edi
801068b5:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801068b9:	e8 f2 db ff ff       	call   801044b0 <cpuid>
801068be:	57                   	push   %edi
801068bf:	56                   	push   %esi
801068c0:	50                   	push   %eax
801068c1:	68 f4 8f 10 80       	push   $0x80108ff4
801068c6:	e8 e5 9d ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801068cb:	e8 10 cb ff ff       	call   801033e0 <lapiceoi>
    break;
801068d0:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801068d3:	e8 f8 db ff ff       	call   801044d0 <myproc>
801068d8:	85 c0                	test   %eax,%eax
801068da:	0f 85 1d ff ff ff    	jne    801067fd <trap+0xdd>
801068e0:	e9 35 ff ff ff       	jmp    8010681a <trap+0xfa>
    ideintr();
801068e5:	e8 16 ba ff ff       	call   80102300 <ideintr>
801068ea:	eb 81                	jmp    8010686d <trap+0x14d>
801068ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801068f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801068f4:	0f 85 38 ff ff ff    	jne    80106832 <trap+0x112>
       yield();
801068fa:	e8 61 e1 ff ff       	call   80104a60 <yield>
801068ff:	e9 2e ff ff ff       	jmp    80106832 <trap+0x112>
80106904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106908:	e8 c3 db ff ff       	call   801044d0 <myproc>
8010690d:	8b 40 24             	mov    0x24(%eax),%eax
80106910:	85 c0                	test   %eax,%eax
80106912:	75 3c                	jne    80106950 <trap+0x230>
    myproc()->tf = tf;
80106914:	e8 b7 db ff ff       	call   801044d0 <myproc>
80106919:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010691c:	e8 af ec ff ff       	call   801055d0 <syscall>
    if(myproc()->killed)
80106921:	e8 aa db ff ff       	call   801044d0 <myproc>
80106926:	8b 40 24             	mov    0x24(%eax),%eax
80106929:	85 c0                	test   %eax,%eax
8010692b:	0f 84 27 ff ff ff    	je     80106858 <trap+0x138>
}
80106931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106934:	5b                   	pop    %ebx
80106935:	5e                   	pop    %esi
80106936:	5f                   	pop    %edi
80106937:	5d                   	pop    %ebp
      exit();
80106938:	e9 e3 df ff ff       	jmp    80104920 <exit>
8010693d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106940:	e8 db df ff ff       	call   80104920 <exit>
80106945:	e9 d0 fe ff ff       	jmp    8010681a <trap+0xfa>
8010694a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106950:	e8 cb df ff ff       	call   80104920 <exit>
80106955:	eb bd                	jmp    80106914 <trap+0x1f4>
80106957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010695e:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
80106960:	83 ec 0c             	sub    $0xc,%esp
80106963:	68 40 cd 13 80       	push   $0x8013cd40
80106968:	e8 83 e7 ff ff       	call   801050f0 <acquire>
      wakeup(&ticks);
8010696d:	c7 04 24 80 d5 13 80 	movl   $0x8013d580,(%esp)
      ticks++;
80106974:	83 05 80 d5 13 80 01 	addl   $0x1,0x8013d580
      wakeup(&ticks);
8010697b:	e8 f0 e2 ff ff       	call   80104c70 <wakeup>
      release(&tickslock);
80106980:	c7 04 24 40 cd 13 80 	movl   $0x8013cd40,(%esp)
80106987:	e8 24 e8 ff ff       	call   801051b0 <release>
8010698c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010698f:	e9 d9 fe ff ff       	jmp    8010686d <trap+0x14d>
80106994:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106997:	e8 14 db ff ff       	call   801044b0 <cpuid>
8010699c:	83 ec 0c             	sub    $0xc,%esp
8010699f:	56                   	push   %esi
801069a0:	57                   	push   %edi
801069a1:	50                   	push   %eax
801069a2:	ff 73 30             	pushl  0x30(%ebx)
801069a5:	68 18 90 10 80       	push   $0x80109018
801069aa:	e8 01 9d ff ff       	call   801006b0 <cprintf>
      panic("trap");
801069af:	83 c4 14             	add    $0x14,%esp
801069b2:	68 6f 8f 10 80       	push   $0x80108f6f
801069b7:	e8 d4 99 ff ff       	call   80100390 <panic>
801069bc:	66 90                	xchg   %ax,%ax
801069be:	66 90                	xchg   %ax,%ax

801069c0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801069c0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801069c4:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
801069c9:	85 c0                	test   %eax,%eax
801069cb:	74 1b                	je     801069e8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069cd:	ba fd 03 00 00       	mov    $0x3fd,%edx
801069d2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801069d3:	a8 01                	test   $0x1,%al
801069d5:	74 11                	je     801069e8 <uartgetc+0x28>
801069d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069dc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801069dd:	0f b6 c0             	movzbl %al,%eax
801069e0:	c3                   	ret    
801069e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801069e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069ed:	c3                   	ret    
801069ee:	66 90                	xchg   %ax,%ax

801069f0 <uartputc.part.0>:
uartputc(int c)
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	89 c7                	mov    %eax,%edi
801069f6:	56                   	push   %esi
801069f7:	be fd 03 00 00       	mov    $0x3fd,%esi
801069fc:	53                   	push   %ebx
801069fd:	bb 80 00 00 00       	mov    $0x80,%ebx
80106a02:	83 ec 0c             	sub    $0xc,%esp
80106a05:	eb 1b                	jmp    80106a22 <uartputc.part.0+0x32>
80106a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a0e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106a10:	83 ec 0c             	sub    $0xc,%esp
80106a13:	6a 0a                	push   $0xa
80106a15:	e8 e6 c9 ff ff       	call   80103400 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a1a:	83 c4 10             	add    $0x10,%esp
80106a1d:	83 eb 01             	sub    $0x1,%ebx
80106a20:	74 07                	je     80106a29 <uartputc.part.0+0x39>
80106a22:	89 f2                	mov    %esi,%edx
80106a24:	ec                   	in     (%dx),%al
80106a25:	a8 20                	test   $0x20,%al
80106a27:	74 e7                	je     80106a10 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a29:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a2e:	89 f8                	mov    %edi,%eax
80106a30:	ee                   	out    %al,(%dx)
}
80106a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a34:	5b                   	pop    %ebx
80106a35:	5e                   	pop    %esi
80106a36:	5f                   	pop    %edi
80106a37:	5d                   	pop    %ebp
80106a38:	c3                   	ret    
80106a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a40 <uartinit>:
{
80106a40:	f3 0f 1e fb          	endbr32 
80106a44:	55                   	push   %ebp
80106a45:	31 c9                	xor    %ecx,%ecx
80106a47:	89 c8                	mov    %ecx,%eax
80106a49:	89 e5                	mov    %esp,%ebp
80106a4b:	57                   	push   %edi
80106a4c:	56                   	push   %esi
80106a4d:	53                   	push   %ebx
80106a4e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106a53:	89 da                	mov    %ebx,%edx
80106a55:	83 ec 0c             	sub    $0xc,%esp
80106a58:	ee                   	out    %al,(%dx)
80106a59:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106a5e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106a63:	89 fa                	mov    %edi,%edx
80106a65:	ee                   	out    %al,(%dx)
80106a66:	b8 0c 00 00 00       	mov    $0xc,%eax
80106a6b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a70:	ee                   	out    %al,(%dx)
80106a71:	be f9 03 00 00       	mov    $0x3f9,%esi
80106a76:	89 c8                	mov    %ecx,%eax
80106a78:	89 f2                	mov    %esi,%edx
80106a7a:	ee                   	out    %al,(%dx)
80106a7b:	b8 03 00 00 00       	mov    $0x3,%eax
80106a80:	89 fa                	mov    %edi,%edx
80106a82:	ee                   	out    %al,(%dx)
80106a83:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106a88:	89 c8                	mov    %ecx,%eax
80106a8a:	ee                   	out    %al,(%dx)
80106a8b:	b8 01 00 00 00       	mov    $0x1,%eax
80106a90:	89 f2                	mov    %esi,%edx
80106a92:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a93:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a98:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106a99:	3c ff                	cmp    $0xff,%al
80106a9b:	74 52                	je     80106aef <uartinit+0xaf>
  uart = 1;
80106a9d:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
80106aa4:	00 00 00 
80106aa7:	89 da                	mov    %ebx,%edx
80106aa9:	ec                   	in     (%dx),%al
80106aaa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106aaf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106ab0:	83 ec 08             	sub    $0x8,%esp
80106ab3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106ab8:	bb 10 91 10 80       	mov    $0x80109110,%ebx
  ioapicenable(IRQ_COM1, 0);
80106abd:	6a 00                	push   $0x0
80106abf:	6a 04                	push   $0x4
80106ac1:	e8 8a ba ff ff       	call   80102550 <ioapicenable>
80106ac6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106ac9:	b8 78 00 00 00       	mov    $0x78,%eax
80106ace:	eb 04                	jmp    80106ad4 <uartinit+0x94>
80106ad0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106ad4:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
80106ada:	85 d2                	test   %edx,%edx
80106adc:	74 08                	je     80106ae6 <uartinit+0xa6>
    uartputc(*p);
80106ade:	0f be c0             	movsbl %al,%eax
80106ae1:	e8 0a ff ff ff       	call   801069f0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106ae6:	89 f0                	mov    %esi,%eax
80106ae8:	83 c3 01             	add    $0x1,%ebx
80106aeb:	84 c0                	test   %al,%al
80106aed:	75 e1                	jne    80106ad0 <uartinit+0x90>
}
80106aef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106af2:	5b                   	pop    %ebx
80106af3:	5e                   	pop    %esi
80106af4:	5f                   	pop    %edi
80106af5:	5d                   	pop    %ebp
80106af6:	c3                   	ret    
80106af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106afe:	66 90                	xchg   %ax,%ax

80106b00 <uartputc>:
{
80106b00:	f3 0f 1e fb          	endbr32 
80106b04:	55                   	push   %ebp
  if(!uart)
80106b05:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
80106b0b:	89 e5                	mov    %esp,%ebp
80106b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106b10:	85 d2                	test   %edx,%edx
80106b12:	74 0c                	je     80106b20 <uartputc+0x20>
}
80106b14:	5d                   	pop    %ebp
80106b15:	e9 d6 fe ff ff       	jmp    801069f0 <uartputc.part.0>
80106b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b20:	5d                   	pop    %ebp
80106b21:	c3                   	ret    
80106b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b30 <uartintr>:

void
uartintr(void)
{
80106b30:	f3 0f 1e fb          	endbr32 
80106b34:	55                   	push   %ebp
80106b35:	89 e5                	mov    %esp,%ebp
80106b37:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106b3a:	68 c0 69 10 80       	push   $0x801069c0
80106b3f:	e8 1c 9d ff ff       	call   80100860 <consoleintr>
}
80106b44:	83 c4 10             	add    $0x10,%esp
80106b47:	c9                   	leave  
80106b48:	c3                   	ret    

80106b49 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $0
80106b4b:	6a 00                	push   $0x0
  jmp alltraps
80106b4d:	e9 cc f9 ff ff       	jmp    8010651e <alltraps>

80106b52 <vector1>:
.globl vector1
vector1:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $1
80106b54:	6a 01                	push   $0x1
  jmp alltraps
80106b56:	e9 c3 f9 ff ff       	jmp    8010651e <alltraps>

80106b5b <vector2>:
.globl vector2
vector2:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $2
80106b5d:	6a 02                	push   $0x2
  jmp alltraps
80106b5f:	e9 ba f9 ff ff       	jmp    8010651e <alltraps>

80106b64 <vector3>:
.globl vector3
vector3:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $3
80106b66:	6a 03                	push   $0x3
  jmp alltraps
80106b68:	e9 b1 f9 ff ff       	jmp    8010651e <alltraps>

80106b6d <vector4>:
.globl vector4
vector4:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $4
80106b6f:	6a 04                	push   $0x4
  jmp alltraps
80106b71:	e9 a8 f9 ff ff       	jmp    8010651e <alltraps>

80106b76 <vector5>:
.globl vector5
vector5:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $5
80106b78:	6a 05                	push   $0x5
  jmp alltraps
80106b7a:	e9 9f f9 ff ff       	jmp    8010651e <alltraps>

80106b7f <vector6>:
.globl vector6
vector6:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $6
80106b81:	6a 06                	push   $0x6
  jmp alltraps
80106b83:	e9 96 f9 ff ff       	jmp    8010651e <alltraps>

80106b88 <vector7>:
.globl vector7
vector7:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $7
80106b8a:	6a 07                	push   $0x7
  jmp alltraps
80106b8c:	e9 8d f9 ff ff       	jmp    8010651e <alltraps>

80106b91 <vector8>:
.globl vector8
vector8:
  pushl $8
80106b91:	6a 08                	push   $0x8
  jmp alltraps
80106b93:	e9 86 f9 ff ff       	jmp    8010651e <alltraps>

80106b98 <vector9>:
.globl vector9
vector9:
  pushl $0
80106b98:	6a 00                	push   $0x0
  pushl $9
80106b9a:	6a 09                	push   $0x9
  jmp alltraps
80106b9c:	e9 7d f9 ff ff       	jmp    8010651e <alltraps>

80106ba1 <vector10>:
.globl vector10
vector10:
  pushl $10
80106ba1:	6a 0a                	push   $0xa
  jmp alltraps
80106ba3:	e9 76 f9 ff ff       	jmp    8010651e <alltraps>

80106ba8 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ba8:	6a 0b                	push   $0xb
  jmp alltraps
80106baa:	e9 6f f9 ff ff       	jmp    8010651e <alltraps>

80106baf <vector12>:
.globl vector12
vector12:
  pushl $12
80106baf:	6a 0c                	push   $0xc
  jmp alltraps
80106bb1:	e9 68 f9 ff ff       	jmp    8010651e <alltraps>

80106bb6 <vector13>:
.globl vector13
vector13:
  pushl $13
80106bb6:	6a 0d                	push   $0xd
  jmp alltraps
80106bb8:	e9 61 f9 ff ff       	jmp    8010651e <alltraps>

80106bbd <vector14>:
.globl vector14
vector14:
  pushl $14
80106bbd:	6a 0e                	push   $0xe
  jmp alltraps
80106bbf:	e9 5a f9 ff ff       	jmp    8010651e <alltraps>

80106bc4 <vector15>:
.globl vector15
vector15:
  pushl $0
80106bc4:	6a 00                	push   $0x0
  pushl $15
80106bc6:	6a 0f                	push   $0xf
  jmp alltraps
80106bc8:	e9 51 f9 ff ff       	jmp    8010651e <alltraps>

80106bcd <vector16>:
.globl vector16
vector16:
  pushl $0
80106bcd:	6a 00                	push   $0x0
  pushl $16
80106bcf:	6a 10                	push   $0x10
  jmp alltraps
80106bd1:	e9 48 f9 ff ff       	jmp    8010651e <alltraps>

80106bd6 <vector17>:
.globl vector17
vector17:
  pushl $17
80106bd6:	6a 11                	push   $0x11
  jmp alltraps
80106bd8:	e9 41 f9 ff ff       	jmp    8010651e <alltraps>

80106bdd <vector18>:
.globl vector18
vector18:
  pushl $0
80106bdd:	6a 00                	push   $0x0
  pushl $18
80106bdf:	6a 12                	push   $0x12
  jmp alltraps
80106be1:	e9 38 f9 ff ff       	jmp    8010651e <alltraps>

80106be6 <vector19>:
.globl vector19
vector19:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $19
80106be8:	6a 13                	push   $0x13
  jmp alltraps
80106bea:	e9 2f f9 ff ff       	jmp    8010651e <alltraps>

80106bef <vector20>:
.globl vector20
vector20:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $20
80106bf1:	6a 14                	push   $0x14
  jmp alltraps
80106bf3:	e9 26 f9 ff ff       	jmp    8010651e <alltraps>

80106bf8 <vector21>:
.globl vector21
vector21:
  pushl $0
80106bf8:	6a 00                	push   $0x0
  pushl $21
80106bfa:	6a 15                	push   $0x15
  jmp alltraps
80106bfc:	e9 1d f9 ff ff       	jmp    8010651e <alltraps>

80106c01 <vector22>:
.globl vector22
vector22:
  pushl $0
80106c01:	6a 00                	push   $0x0
  pushl $22
80106c03:	6a 16                	push   $0x16
  jmp alltraps
80106c05:	e9 14 f9 ff ff       	jmp    8010651e <alltraps>

80106c0a <vector23>:
.globl vector23
vector23:
  pushl $0
80106c0a:	6a 00                	push   $0x0
  pushl $23
80106c0c:	6a 17                	push   $0x17
  jmp alltraps
80106c0e:	e9 0b f9 ff ff       	jmp    8010651e <alltraps>

80106c13 <vector24>:
.globl vector24
vector24:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $24
80106c15:	6a 18                	push   $0x18
  jmp alltraps
80106c17:	e9 02 f9 ff ff       	jmp    8010651e <alltraps>

80106c1c <vector25>:
.globl vector25
vector25:
  pushl $0
80106c1c:	6a 00                	push   $0x0
  pushl $25
80106c1e:	6a 19                	push   $0x19
  jmp alltraps
80106c20:	e9 f9 f8 ff ff       	jmp    8010651e <alltraps>

80106c25 <vector26>:
.globl vector26
vector26:
  pushl $0
80106c25:	6a 00                	push   $0x0
  pushl $26
80106c27:	6a 1a                	push   $0x1a
  jmp alltraps
80106c29:	e9 f0 f8 ff ff       	jmp    8010651e <alltraps>

80106c2e <vector27>:
.globl vector27
vector27:
  pushl $0
80106c2e:	6a 00                	push   $0x0
  pushl $27
80106c30:	6a 1b                	push   $0x1b
  jmp alltraps
80106c32:	e9 e7 f8 ff ff       	jmp    8010651e <alltraps>

80106c37 <vector28>:
.globl vector28
vector28:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $28
80106c39:	6a 1c                	push   $0x1c
  jmp alltraps
80106c3b:	e9 de f8 ff ff       	jmp    8010651e <alltraps>

80106c40 <vector29>:
.globl vector29
vector29:
  pushl $0
80106c40:	6a 00                	push   $0x0
  pushl $29
80106c42:	6a 1d                	push   $0x1d
  jmp alltraps
80106c44:	e9 d5 f8 ff ff       	jmp    8010651e <alltraps>

80106c49 <vector30>:
.globl vector30
vector30:
  pushl $0
80106c49:	6a 00                	push   $0x0
  pushl $30
80106c4b:	6a 1e                	push   $0x1e
  jmp alltraps
80106c4d:	e9 cc f8 ff ff       	jmp    8010651e <alltraps>

80106c52 <vector31>:
.globl vector31
vector31:
  pushl $0
80106c52:	6a 00                	push   $0x0
  pushl $31
80106c54:	6a 1f                	push   $0x1f
  jmp alltraps
80106c56:	e9 c3 f8 ff ff       	jmp    8010651e <alltraps>

80106c5b <vector32>:
.globl vector32
vector32:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $32
80106c5d:	6a 20                	push   $0x20
  jmp alltraps
80106c5f:	e9 ba f8 ff ff       	jmp    8010651e <alltraps>

80106c64 <vector33>:
.globl vector33
vector33:
  pushl $0
80106c64:	6a 00                	push   $0x0
  pushl $33
80106c66:	6a 21                	push   $0x21
  jmp alltraps
80106c68:	e9 b1 f8 ff ff       	jmp    8010651e <alltraps>

80106c6d <vector34>:
.globl vector34
vector34:
  pushl $0
80106c6d:	6a 00                	push   $0x0
  pushl $34
80106c6f:	6a 22                	push   $0x22
  jmp alltraps
80106c71:	e9 a8 f8 ff ff       	jmp    8010651e <alltraps>

80106c76 <vector35>:
.globl vector35
vector35:
  pushl $0
80106c76:	6a 00                	push   $0x0
  pushl $35
80106c78:	6a 23                	push   $0x23
  jmp alltraps
80106c7a:	e9 9f f8 ff ff       	jmp    8010651e <alltraps>

80106c7f <vector36>:
.globl vector36
vector36:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $36
80106c81:	6a 24                	push   $0x24
  jmp alltraps
80106c83:	e9 96 f8 ff ff       	jmp    8010651e <alltraps>

80106c88 <vector37>:
.globl vector37
vector37:
  pushl $0
80106c88:	6a 00                	push   $0x0
  pushl $37
80106c8a:	6a 25                	push   $0x25
  jmp alltraps
80106c8c:	e9 8d f8 ff ff       	jmp    8010651e <alltraps>

80106c91 <vector38>:
.globl vector38
vector38:
  pushl $0
80106c91:	6a 00                	push   $0x0
  pushl $38
80106c93:	6a 26                	push   $0x26
  jmp alltraps
80106c95:	e9 84 f8 ff ff       	jmp    8010651e <alltraps>

80106c9a <vector39>:
.globl vector39
vector39:
  pushl $0
80106c9a:	6a 00                	push   $0x0
  pushl $39
80106c9c:	6a 27                	push   $0x27
  jmp alltraps
80106c9e:	e9 7b f8 ff ff       	jmp    8010651e <alltraps>

80106ca3 <vector40>:
.globl vector40
vector40:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $40
80106ca5:	6a 28                	push   $0x28
  jmp alltraps
80106ca7:	e9 72 f8 ff ff       	jmp    8010651e <alltraps>

80106cac <vector41>:
.globl vector41
vector41:
  pushl $0
80106cac:	6a 00                	push   $0x0
  pushl $41
80106cae:	6a 29                	push   $0x29
  jmp alltraps
80106cb0:	e9 69 f8 ff ff       	jmp    8010651e <alltraps>

80106cb5 <vector42>:
.globl vector42
vector42:
  pushl $0
80106cb5:	6a 00                	push   $0x0
  pushl $42
80106cb7:	6a 2a                	push   $0x2a
  jmp alltraps
80106cb9:	e9 60 f8 ff ff       	jmp    8010651e <alltraps>

80106cbe <vector43>:
.globl vector43
vector43:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $43
80106cc0:	6a 2b                	push   $0x2b
  jmp alltraps
80106cc2:	e9 57 f8 ff ff       	jmp    8010651e <alltraps>

80106cc7 <vector44>:
.globl vector44
vector44:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $44
80106cc9:	6a 2c                	push   $0x2c
  jmp alltraps
80106ccb:	e9 4e f8 ff ff       	jmp    8010651e <alltraps>

80106cd0 <vector45>:
.globl vector45
vector45:
  pushl $0
80106cd0:	6a 00                	push   $0x0
  pushl $45
80106cd2:	6a 2d                	push   $0x2d
  jmp alltraps
80106cd4:	e9 45 f8 ff ff       	jmp    8010651e <alltraps>

80106cd9 <vector46>:
.globl vector46
vector46:
  pushl $0
80106cd9:	6a 00                	push   $0x0
  pushl $46
80106cdb:	6a 2e                	push   $0x2e
  jmp alltraps
80106cdd:	e9 3c f8 ff ff       	jmp    8010651e <alltraps>

80106ce2 <vector47>:
.globl vector47
vector47:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $47
80106ce4:	6a 2f                	push   $0x2f
  jmp alltraps
80106ce6:	e9 33 f8 ff ff       	jmp    8010651e <alltraps>

80106ceb <vector48>:
.globl vector48
vector48:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $48
80106ced:	6a 30                	push   $0x30
  jmp alltraps
80106cef:	e9 2a f8 ff ff       	jmp    8010651e <alltraps>

80106cf4 <vector49>:
.globl vector49
vector49:
  pushl $0
80106cf4:	6a 00                	push   $0x0
  pushl $49
80106cf6:	6a 31                	push   $0x31
  jmp alltraps
80106cf8:	e9 21 f8 ff ff       	jmp    8010651e <alltraps>

80106cfd <vector50>:
.globl vector50
vector50:
  pushl $0
80106cfd:	6a 00                	push   $0x0
  pushl $50
80106cff:	6a 32                	push   $0x32
  jmp alltraps
80106d01:	e9 18 f8 ff ff       	jmp    8010651e <alltraps>

80106d06 <vector51>:
.globl vector51
vector51:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $51
80106d08:	6a 33                	push   $0x33
  jmp alltraps
80106d0a:	e9 0f f8 ff ff       	jmp    8010651e <alltraps>

80106d0f <vector52>:
.globl vector52
vector52:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $52
80106d11:	6a 34                	push   $0x34
  jmp alltraps
80106d13:	e9 06 f8 ff ff       	jmp    8010651e <alltraps>

80106d18 <vector53>:
.globl vector53
vector53:
  pushl $0
80106d18:	6a 00                	push   $0x0
  pushl $53
80106d1a:	6a 35                	push   $0x35
  jmp alltraps
80106d1c:	e9 fd f7 ff ff       	jmp    8010651e <alltraps>

80106d21 <vector54>:
.globl vector54
vector54:
  pushl $0
80106d21:	6a 00                	push   $0x0
  pushl $54
80106d23:	6a 36                	push   $0x36
  jmp alltraps
80106d25:	e9 f4 f7 ff ff       	jmp    8010651e <alltraps>

80106d2a <vector55>:
.globl vector55
vector55:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $55
80106d2c:	6a 37                	push   $0x37
  jmp alltraps
80106d2e:	e9 eb f7 ff ff       	jmp    8010651e <alltraps>

80106d33 <vector56>:
.globl vector56
vector56:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $56
80106d35:	6a 38                	push   $0x38
  jmp alltraps
80106d37:	e9 e2 f7 ff ff       	jmp    8010651e <alltraps>

80106d3c <vector57>:
.globl vector57
vector57:
  pushl $0
80106d3c:	6a 00                	push   $0x0
  pushl $57
80106d3e:	6a 39                	push   $0x39
  jmp alltraps
80106d40:	e9 d9 f7 ff ff       	jmp    8010651e <alltraps>

80106d45 <vector58>:
.globl vector58
vector58:
  pushl $0
80106d45:	6a 00                	push   $0x0
  pushl $58
80106d47:	6a 3a                	push   $0x3a
  jmp alltraps
80106d49:	e9 d0 f7 ff ff       	jmp    8010651e <alltraps>

80106d4e <vector59>:
.globl vector59
vector59:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $59
80106d50:	6a 3b                	push   $0x3b
  jmp alltraps
80106d52:	e9 c7 f7 ff ff       	jmp    8010651e <alltraps>

80106d57 <vector60>:
.globl vector60
vector60:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $60
80106d59:	6a 3c                	push   $0x3c
  jmp alltraps
80106d5b:	e9 be f7 ff ff       	jmp    8010651e <alltraps>

80106d60 <vector61>:
.globl vector61
vector61:
  pushl $0
80106d60:	6a 00                	push   $0x0
  pushl $61
80106d62:	6a 3d                	push   $0x3d
  jmp alltraps
80106d64:	e9 b5 f7 ff ff       	jmp    8010651e <alltraps>

80106d69 <vector62>:
.globl vector62
vector62:
  pushl $0
80106d69:	6a 00                	push   $0x0
  pushl $62
80106d6b:	6a 3e                	push   $0x3e
  jmp alltraps
80106d6d:	e9 ac f7 ff ff       	jmp    8010651e <alltraps>

80106d72 <vector63>:
.globl vector63
vector63:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $63
80106d74:	6a 3f                	push   $0x3f
  jmp alltraps
80106d76:	e9 a3 f7 ff ff       	jmp    8010651e <alltraps>

80106d7b <vector64>:
.globl vector64
vector64:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $64
80106d7d:	6a 40                	push   $0x40
  jmp alltraps
80106d7f:	e9 9a f7 ff ff       	jmp    8010651e <alltraps>

80106d84 <vector65>:
.globl vector65
vector65:
  pushl $0
80106d84:	6a 00                	push   $0x0
  pushl $65
80106d86:	6a 41                	push   $0x41
  jmp alltraps
80106d88:	e9 91 f7 ff ff       	jmp    8010651e <alltraps>

80106d8d <vector66>:
.globl vector66
vector66:
  pushl $0
80106d8d:	6a 00                	push   $0x0
  pushl $66
80106d8f:	6a 42                	push   $0x42
  jmp alltraps
80106d91:	e9 88 f7 ff ff       	jmp    8010651e <alltraps>

80106d96 <vector67>:
.globl vector67
vector67:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $67
80106d98:	6a 43                	push   $0x43
  jmp alltraps
80106d9a:	e9 7f f7 ff ff       	jmp    8010651e <alltraps>

80106d9f <vector68>:
.globl vector68
vector68:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $68
80106da1:	6a 44                	push   $0x44
  jmp alltraps
80106da3:	e9 76 f7 ff ff       	jmp    8010651e <alltraps>

80106da8 <vector69>:
.globl vector69
vector69:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $69
80106daa:	6a 45                	push   $0x45
  jmp alltraps
80106dac:	e9 6d f7 ff ff       	jmp    8010651e <alltraps>

80106db1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106db1:	6a 00                	push   $0x0
  pushl $70
80106db3:	6a 46                	push   $0x46
  jmp alltraps
80106db5:	e9 64 f7 ff ff       	jmp    8010651e <alltraps>

80106dba <vector71>:
.globl vector71
vector71:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $71
80106dbc:	6a 47                	push   $0x47
  jmp alltraps
80106dbe:	e9 5b f7 ff ff       	jmp    8010651e <alltraps>

80106dc3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $72
80106dc5:	6a 48                	push   $0x48
  jmp alltraps
80106dc7:	e9 52 f7 ff ff       	jmp    8010651e <alltraps>

80106dcc <vector73>:
.globl vector73
vector73:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $73
80106dce:	6a 49                	push   $0x49
  jmp alltraps
80106dd0:	e9 49 f7 ff ff       	jmp    8010651e <alltraps>

80106dd5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $74
80106dd7:	6a 4a                	push   $0x4a
  jmp alltraps
80106dd9:	e9 40 f7 ff ff       	jmp    8010651e <alltraps>

80106dde <vector75>:
.globl vector75
vector75:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $75
80106de0:	6a 4b                	push   $0x4b
  jmp alltraps
80106de2:	e9 37 f7 ff ff       	jmp    8010651e <alltraps>

80106de7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $76
80106de9:	6a 4c                	push   $0x4c
  jmp alltraps
80106deb:	e9 2e f7 ff ff       	jmp    8010651e <alltraps>

80106df0 <vector77>:
.globl vector77
vector77:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $77
80106df2:	6a 4d                	push   $0x4d
  jmp alltraps
80106df4:	e9 25 f7 ff ff       	jmp    8010651e <alltraps>

80106df9 <vector78>:
.globl vector78
vector78:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $78
80106dfb:	6a 4e                	push   $0x4e
  jmp alltraps
80106dfd:	e9 1c f7 ff ff       	jmp    8010651e <alltraps>

80106e02 <vector79>:
.globl vector79
vector79:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $79
80106e04:	6a 4f                	push   $0x4f
  jmp alltraps
80106e06:	e9 13 f7 ff ff       	jmp    8010651e <alltraps>

80106e0b <vector80>:
.globl vector80
vector80:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $80
80106e0d:	6a 50                	push   $0x50
  jmp alltraps
80106e0f:	e9 0a f7 ff ff       	jmp    8010651e <alltraps>

80106e14 <vector81>:
.globl vector81
vector81:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $81
80106e16:	6a 51                	push   $0x51
  jmp alltraps
80106e18:	e9 01 f7 ff ff       	jmp    8010651e <alltraps>

80106e1d <vector82>:
.globl vector82
vector82:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $82
80106e1f:	6a 52                	push   $0x52
  jmp alltraps
80106e21:	e9 f8 f6 ff ff       	jmp    8010651e <alltraps>

80106e26 <vector83>:
.globl vector83
vector83:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $83
80106e28:	6a 53                	push   $0x53
  jmp alltraps
80106e2a:	e9 ef f6 ff ff       	jmp    8010651e <alltraps>

80106e2f <vector84>:
.globl vector84
vector84:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $84
80106e31:	6a 54                	push   $0x54
  jmp alltraps
80106e33:	e9 e6 f6 ff ff       	jmp    8010651e <alltraps>

80106e38 <vector85>:
.globl vector85
vector85:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $85
80106e3a:	6a 55                	push   $0x55
  jmp alltraps
80106e3c:	e9 dd f6 ff ff       	jmp    8010651e <alltraps>

80106e41 <vector86>:
.globl vector86
vector86:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $86
80106e43:	6a 56                	push   $0x56
  jmp alltraps
80106e45:	e9 d4 f6 ff ff       	jmp    8010651e <alltraps>

80106e4a <vector87>:
.globl vector87
vector87:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $87
80106e4c:	6a 57                	push   $0x57
  jmp alltraps
80106e4e:	e9 cb f6 ff ff       	jmp    8010651e <alltraps>

80106e53 <vector88>:
.globl vector88
vector88:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $88
80106e55:	6a 58                	push   $0x58
  jmp alltraps
80106e57:	e9 c2 f6 ff ff       	jmp    8010651e <alltraps>

80106e5c <vector89>:
.globl vector89
vector89:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $89
80106e5e:	6a 59                	push   $0x59
  jmp alltraps
80106e60:	e9 b9 f6 ff ff       	jmp    8010651e <alltraps>

80106e65 <vector90>:
.globl vector90
vector90:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $90
80106e67:	6a 5a                	push   $0x5a
  jmp alltraps
80106e69:	e9 b0 f6 ff ff       	jmp    8010651e <alltraps>

80106e6e <vector91>:
.globl vector91
vector91:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $91
80106e70:	6a 5b                	push   $0x5b
  jmp alltraps
80106e72:	e9 a7 f6 ff ff       	jmp    8010651e <alltraps>

80106e77 <vector92>:
.globl vector92
vector92:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $92
80106e79:	6a 5c                	push   $0x5c
  jmp alltraps
80106e7b:	e9 9e f6 ff ff       	jmp    8010651e <alltraps>

80106e80 <vector93>:
.globl vector93
vector93:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $93
80106e82:	6a 5d                	push   $0x5d
  jmp alltraps
80106e84:	e9 95 f6 ff ff       	jmp    8010651e <alltraps>

80106e89 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $94
80106e8b:	6a 5e                	push   $0x5e
  jmp alltraps
80106e8d:	e9 8c f6 ff ff       	jmp    8010651e <alltraps>

80106e92 <vector95>:
.globl vector95
vector95:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $95
80106e94:	6a 5f                	push   $0x5f
  jmp alltraps
80106e96:	e9 83 f6 ff ff       	jmp    8010651e <alltraps>

80106e9b <vector96>:
.globl vector96
vector96:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $96
80106e9d:	6a 60                	push   $0x60
  jmp alltraps
80106e9f:	e9 7a f6 ff ff       	jmp    8010651e <alltraps>

80106ea4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $97
80106ea6:	6a 61                	push   $0x61
  jmp alltraps
80106ea8:	e9 71 f6 ff ff       	jmp    8010651e <alltraps>

80106ead <vector98>:
.globl vector98
vector98:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $98
80106eaf:	6a 62                	push   $0x62
  jmp alltraps
80106eb1:	e9 68 f6 ff ff       	jmp    8010651e <alltraps>

80106eb6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $99
80106eb8:	6a 63                	push   $0x63
  jmp alltraps
80106eba:	e9 5f f6 ff ff       	jmp    8010651e <alltraps>

80106ebf <vector100>:
.globl vector100
vector100:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $100
80106ec1:	6a 64                	push   $0x64
  jmp alltraps
80106ec3:	e9 56 f6 ff ff       	jmp    8010651e <alltraps>

80106ec8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $101
80106eca:	6a 65                	push   $0x65
  jmp alltraps
80106ecc:	e9 4d f6 ff ff       	jmp    8010651e <alltraps>

80106ed1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $102
80106ed3:	6a 66                	push   $0x66
  jmp alltraps
80106ed5:	e9 44 f6 ff ff       	jmp    8010651e <alltraps>

80106eda <vector103>:
.globl vector103
vector103:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $103
80106edc:	6a 67                	push   $0x67
  jmp alltraps
80106ede:	e9 3b f6 ff ff       	jmp    8010651e <alltraps>

80106ee3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $104
80106ee5:	6a 68                	push   $0x68
  jmp alltraps
80106ee7:	e9 32 f6 ff ff       	jmp    8010651e <alltraps>

80106eec <vector105>:
.globl vector105
vector105:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $105
80106eee:	6a 69                	push   $0x69
  jmp alltraps
80106ef0:	e9 29 f6 ff ff       	jmp    8010651e <alltraps>

80106ef5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $106
80106ef7:	6a 6a                	push   $0x6a
  jmp alltraps
80106ef9:	e9 20 f6 ff ff       	jmp    8010651e <alltraps>

80106efe <vector107>:
.globl vector107
vector107:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $107
80106f00:	6a 6b                	push   $0x6b
  jmp alltraps
80106f02:	e9 17 f6 ff ff       	jmp    8010651e <alltraps>

80106f07 <vector108>:
.globl vector108
vector108:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $108
80106f09:	6a 6c                	push   $0x6c
  jmp alltraps
80106f0b:	e9 0e f6 ff ff       	jmp    8010651e <alltraps>

80106f10 <vector109>:
.globl vector109
vector109:
  pushl $0
80106f10:	6a 00                	push   $0x0
  pushl $109
80106f12:	6a 6d                	push   $0x6d
  jmp alltraps
80106f14:	e9 05 f6 ff ff       	jmp    8010651e <alltraps>

80106f19 <vector110>:
.globl vector110
vector110:
  pushl $0
80106f19:	6a 00                	push   $0x0
  pushl $110
80106f1b:	6a 6e                	push   $0x6e
  jmp alltraps
80106f1d:	e9 fc f5 ff ff       	jmp    8010651e <alltraps>

80106f22 <vector111>:
.globl vector111
vector111:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $111
80106f24:	6a 6f                	push   $0x6f
  jmp alltraps
80106f26:	e9 f3 f5 ff ff       	jmp    8010651e <alltraps>

80106f2b <vector112>:
.globl vector112
vector112:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $112
80106f2d:	6a 70                	push   $0x70
  jmp alltraps
80106f2f:	e9 ea f5 ff ff       	jmp    8010651e <alltraps>

80106f34 <vector113>:
.globl vector113
vector113:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $113
80106f36:	6a 71                	push   $0x71
  jmp alltraps
80106f38:	e9 e1 f5 ff ff       	jmp    8010651e <alltraps>

80106f3d <vector114>:
.globl vector114
vector114:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $114
80106f3f:	6a 72                	push   $0x72
  jmp alltraps
80106f41:	e9 d8 f5 ff ff       	jmp    8010651e <alltraps>

80106f46 <vector115>:
.globl vector115
vector115:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $115
80106f48:	6a 73                	push   $0x73
  jmp alltraps
80106f4a:	e9 cf f5 ff ff       	jmp    8010651e <alltraps>

80106f4f <vector116>:
.globl vector116
vector116:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $116
80106f51:	6a 74                	push   $0x74
  jmp alltraps
80106f53:	e9 c6 f5 ff ff       	jmp    8010651e <alltraps>

80106f58 <vector117>:
.globl vector117
vector117:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $117
80106f5a:	6a 75                	push   $0x75
  jmp alltraps
80106f5c:	e9 bd f5 ff ff       	jmp    8010651e <alltraps>

80106f61 <vector118>:
.globl vector118
vector118:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $118
80106f63:	6a 76                	push   $0x76
  jmp alltraps
80106f65:	e9 b4 f5 ff ff       	jmp    8010651e <alltraps>

80106f6a <vector119>:
.globl vector119
vector119:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $119
80106f6c:	6a 77                	push   $0x77
  jmp alltraps
80106f6e:	e9 ab f5 ff ff       	jmp    8010651e <alltraps>

80106f73 <vector120>:
.globl vector120
vector120:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $120
80106f75:	6a 78                	push   $0x78
  jmp alltraps
80106f77:	e9 a2 f5 ff ff       	jmp    8010651e <alltraps>

80106f7c <vector121>:
.globl vector121
vector121:
  pushl $0
80106f7c:	6a 00                	push   $0x0
  pushl $121
80106f7e:	6a 79                	push   $0x79
  jmp alltraps
80106f80:	e9 99 f5 ff ff       	jmp    8010651e <alltraps>

80106f85 <vector122>:
.globl vector122
vector122:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $122
80106f87:	6a 7a                	push   $0x7a
  jmp alltraps
80106f89:	e9 90 f5 ff ff       	jmp    8010651e <alltraps>

80106f8e <vector123>:
.globl vector123
vector123:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $123
80106f90:	6a 7b                	push   $0x7b
  jmp alltraps
80106f92:	e9 87 f5 ff ff       	jmp    8010651e <alltraps>

80106f97 <vector124>:
.globl vector124
vector124:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $124
80106f99:	6a 7c                	push   $0x7c
  jmp alltraps
80106f9b:	e9 7e f5 ff ff       	jmp    8010651e <alltraps>

80106fa0 <vector125>:
.globl vector125
vector125:
  pushl $0
80106fa0:	6a 00                	push   $0x0
  pushl $125
80106fa2:	6a 7d                	push   $0x7d
  jmp alltraps
80106fa4:	e9 75 f5 ff ff       	jmp    8010651e <alltraps>

80106fa9 <vector126>:
.globl vector126
vector126:
  pushl $0
80106fa9:	6a 00                	push   $0x0
  pushl $126
80106fab:	6a 7e                	push   $0x7e
  jmp alltraps
80106fad:	e9 6c f5 ff ff       	jmp    8010651e <alltraps>

80106fb2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $127
80106fb4:	6a 7f                	push   $0x7f
  jmp alltraps
80106fb6:	e9 63 f5 ff ff       	jmp    8010651e <alltraps>

80106fbb <vector128>:
.globl vector128
vector128:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $128
80106fbd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106fc2:	e9 57 f5 ff ff       	jmp    8010651e <alltraps>

80106fc7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $129
80106fc9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106fce:	e9 4b f5 ff ff       	jmp    8010651e <alltraps>

80106fd3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $130
80106fd5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106fda:	e9 3f f5 ff ff       	jmp    8010651e <alltraps>

80106fdf <vector131>:
.globl vector131
vector131:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $131
80106fe1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106fe6:	e9 33 f5 ff ff       	jmp    8010651e <alltraps>

80106feb <vector132>:
.globl vector132
vector132:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $132
80106fed:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ff2:	e9 27 f5 ff ff       	jmp    8010651e <alltraps>

80106ff7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $133
80106ff9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106ffe:	e9 1b f5 ff ff       	jmp    8010651e <alltraps>

80107003 <vector134>:
.globl vector134
vector134:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $134
80107005:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010700a:	e9 0f f5 ff ff       	jmp    8010651e <alltraps>

8010700f <vector135>:
.globl vector135
vector135:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $135
80107011:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107016:	e9 03 f5 ff ff       	jmp    8010651e <alltraps>

8010701b <vector136>:
.globl vector136
vector136:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $136
8010701d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107022:	e9 f7 f4 ff ff       	jmp    8010651e <alltraps>

80107027 <vector137>:
.globl vector137
vector137:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $137
80107029:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010702e:	e9 eb f4 ff ff       	jmp    8010651e <alltraps>

80107033 <vector138>:
.globl vector138
vector138:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $138
80107035:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010703a:	e9 df f4 ff ff       	jmp    8010651e <alltraps>

8010703f <vector139>:
.globl vector139
vector139:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $139
80107041:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107046:	e9 d3 f4 ff ff       	jmp    8010651e <alltraps>

8010704b <vector140>:
.globl vector140
vector140:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $140
8010704d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107052:	e9 c7 f4 ff ff       	jmp    8010651e <alltraps>

80107057 <vector141>:
.globl vector141
vector141:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $141
80107059:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010705e:	e9 bb f4 ff ff       	jmp    8010651e <alltraps>

80107063 <vector142>:
.globl vector142
vector142:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $142
80107065:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010706a:	e9 af f4 ff ff       	jmp    8010651e <alltraps>

8010706f <vector143>:
.globl vector143
vector143:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $143
80107071:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107076:	e9 a3 f4 ff ff       	jmp    8010651e <alltraps>

8010707b <vector144>:
.globl vector144
vector144:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $144
8010707d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107082:	e9 97 f4 ff ff       	jmp    8010651e <alltraps>

80107087 <vector145>:
.globl vector145
vector145:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $145
80107089:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010708e:	e9 8b f4 ff ff       	jmp    8010651e <alltraps>

80107093 <vector146>:
.globl vector146
vector146:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $146
80107095:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010709a:	e9 7f f4 ff ff       	jmp    8010651e <alltraps>

8010709f <vector147>:
.globl vector147
vector147:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $147
801070a1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801070a6:	e9 73 f4 ff ff       	jmp    8010651e <alltraps>

801070ab <vector148>:
.globl vector148
vector148:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $148
801070ad:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801070b2:	e9 67 f4 ff ff       	jmp    8010651e <alltraps>

801070b7 <vector149>:
.globl vector149
vector149:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $149
801070b9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801070be:	e9 5b f4 ff ff       	jmp    8010651e <alltraps>

801070c3 <vector150>:
.globl vector150
vector150:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $150
801070c5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801070ca:	e9 4f f4 ff ff       	jmp    8010651e <alltraps>

801070cf <vector151>:
.globl vector151
vector151:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $151
801070d1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801070d6:	e9 43 f4 ff ff       	jmp    8010651e <alltraps>

801070db <vector152>:
.globl vector152
vector152:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $152
801070dd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801070e2:	e9 37 f4 ff ff       	jmp    8010651e <alltraps>

801070e7 <vector153>:
.globl vector153
vector153:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $153
801070e9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801070ee:	e9 2b f4 ff ff       	jmp    8010651e <alltraps>

801070f3 <vector154>:
.globl vector154
vector154:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $154
801070f5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801070fa:	e9 1f f4 ff ff       	jmp    8010651e <alltraps>

801070ff <vector155>:
.globl vector155
vector155:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $155
80107101:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107106:	e9 13 f4 ff ff       	jmp    8010651e <alltraps>

8010710b <vector156>:
.globl vector156
vector156:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $156
8010710d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107112:	e9 07 f4 ff ff       	jmp    8010651e <alltraps>

80107117 <vector157>:
.globl vector157
vector157:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $157
80107119:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010711e:	e9 fb f3 ff ff       	jmp    8010651e <alltraps>

80107123 <vector158>:
.globl vector158
vector158:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $158
80107125:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010712a:	e9 ef f3 ff ff       	jmp    8010651e <alltraps>

8010712f <vector159>:
.globl vector159
vector159:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $159
80107131:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107136:	e9 e3 f3 ff ff       	jmp    8010651e <alltraps>

8010713b <vector160>:
.globl vector160
vector160:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $160
8010713d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107142:	e9 d7 f3 ff ff       	jmp    8010651e <alltraps>

80107147 <vector161>:
.globl vector161
vector161:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $161
80107149:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010714e:	e9 cb f3 ff ff       	jmp    8010651e <alltraps>

80107153 <vector162>:
.globl vector162
vector162:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $162
80107155:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010715a:	e9 bf f3 ff ff       	jmp    8010651e <alltraps>

8010715f <vector163>:
.globl vector163
vector163:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $163
80107161:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107166:	e9 b3 f3 ff ff       	jmp    8010651e <alltraps>

8010716b <vector164>:
.globl vector164
vector164:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $164
8010716d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107172:	e9 a7 f3 ff ff       	jmp    8010651e <alltraps>

80107177 <vector165>:
.globl vector165
vector165:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $165
80107179:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010717e:	e9 9b f3 ff ff       	jmp    8010651e <alltraps>

80107183 <vector166>:
.globl vector166
vector166:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $166
80107185:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010718a:	e9 8f f3 ff ff       	jmp    8010651e <alltraps>

8010718f <vector167>:
.globl vector167
vector167:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $167
80107191:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107196:	e9 83 f3 ff ff       	jmp    8010651e <alltraps>

8010719b <vector168>:
.globl vector168
vector168:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $168
8010719d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801071a2:	e9 77 f3 ff ff       	jmp    8010651e <alltraps>

801071a7 <vector169>:
.globl vector169
vector169:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $169
801071a9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801071ae:	e9 6b f3 ff ff       	jmp    8010651e <alltraps>

801071b3 <vector170>:
.globl vector170
vector170:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $170
801071b5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801071ba:	e9 5f f3 ff ff       	jmp    8010651e <alltraps>

801071bf <vector171>:
.globl vector171
vector171:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $171
801071c1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801071c6:	e9 53 f3 ff ff       	jmp    8010651e <alltraps>

801071cb <vector172>:
.globl vector172
vector172:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $172
801071cd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801071d2:	e9 47 f3 ff ff       	jmp    8010651e <alltraps>

801071d7 <vector173>:
.globl vector173
vector173:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $173
801071d9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801071de:	e9 3b f3 ff ff       	jmp    8010651e <alltraps>

801071e3 <vector174>:
.globl vector174
vector174:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $174
801071e5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801071ea:	e9 2f f3 ff ff       	jmp    8010651e <alltraps>

801071ef <vector175>:
.globl vector175
vector175:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $175
801071f1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801071f6:	e9 23 f3 ff ff       	jmp    8010651e <alltraps>

801071fb <vector176>:
.globl vector176
vector176:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $176
801071fd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107202:	e9 17 f3 ff ff       	jmp    8010651e <alltraps>

80107207 <vector177>:
.globl vector177
vector177:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $177
80107209:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010720e:	e9 0b f3 ff ff       	jmp    8010651e <alltraps>

80107213 <vector178>:
.globl vector178
vector178:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $178
80107215:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010721a:	e9 ff f2 ff ff       	jmp    8010651e <alltraps>

8010721f <vector179>:
.globl vector179
vector179:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $179
80107221:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107226:	e9 f3 f2 ff ff       	jmp    8010651e <alltraps>

8010722b <vector180>:
.globl vector180
vector180:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $180
8010722d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107232:	e9 e7 f2 ff ff       	jmp    8010651e <alltraps>

80107237 <vector181>:
.globl vector181
vector181:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $181
80107239:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010723e:	e9 db f2 ff ff       	jmp    8010651e <alltraps>

80107243 <vector182>:
.globl vector182
vector182:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $182
80107245:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010724a:	e9 cf f2 ff ff       	jmp    8010651e <alltraps>

8010724f <vector183>:
.globl vector183
vector183:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $183
80107251:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107256:	e9 c3 f2 ff ff       	jmp    8010651e <alltraps>

8010725b <vector184>:
.globl vector184
vector184:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $184
8010725d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107262:	e9 b7 f2 ff ff       	jmp    8010651e <alltraps>

80107267 <vector185>:
.globl vector185
vector185:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $185
80107269:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010726e:	e9 ab f2 ff ff       	jmp    8010651e <alltraps>

80107273 <vector186>:
.globl vector186
vector186:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $186
80107275:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010727a:	e9 9f f2 ff ff       	jmp    8010651e <alltraps>

8010727f <vector187>:
.globl vector187
vector187:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $187
80107281:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107286:	e9 93 f2 ff ff       	jmp    8010651e <alltraps>

8010728b <vector188>:
.globl vector188
vector188:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $188
8010728d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107292:	e9 87 f2 ff ff       	jmp    8010651e <alltraps>

80107297 <vector189>:
.globl vector189
vector189:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $189
80107299:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010729e:	e9 7b f2 ff ff       	jmp    8010651e <alltraps>

801072a3 <vector190>:
.globl vector190
vector190:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $190
801072a5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801072aa:	e9 6f f2 ff ff       	jmp    8010651e <alltraps>

801072af <vector191>:
.globl vector191
vector191:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $191
801072b1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801072b6:	e9 63 f2 ff ff       	jmp    8010651e <alltraps>

801072bb <vector192>:
.globl vector192
vector192:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $192
801072bd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801072c2:	e9 57 f2 ff ff       	jmp    8010651e <alltraps>

801072c7 <vector193>:
.globl vector193
vector193:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $193
801072c9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801072ce:	e9 4b f2 ff ff       	jmp    8010651e <alltraps>

801072d3 <vector194>:
.globl vector194
vector194:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $194
801072d5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801072da:	e9 3f f2 ff ff       	jmp    8010651e <alltraps>

801072df <vector195>:
.globl vector195
vector195:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $195
801072e1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801072e6:	e9 33 f2 ff ff       	jmp    8010651e <alltraps>

801072eb <vector196>:
.globl vector196
vector196:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $196
801072ed:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801072f2:	e9 27 f2 ff ff       	jmp    8010651e <alltraps>

801072f7 <vector197>:
.globl vector197
vector197:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $197
801072f9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801072fe:	e9 1b f2 ff ff       	jmp    8010651e <alltraps>

80107303 <vector198>:
.globl vector198
vector198:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $198
80107305:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010730a:	e9 0f f2 ff ff       	jmp    8010651e <alltraps>

8010730f <vector199>:
.globl vector199
vector199:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $199
80107311:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107316:	e9 03 f2 ff ff       	jmp    8010651e <alltraps>

8010731b <vector200>:
.globl vector200
vector200:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $200
8010731d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107322:	e9 f7 f1 ff ff       	jmp    8010651e <alltraps>

80107327 <vector201>:
.globl vector201
vector201:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $201
80107329:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010732e:	e9 eb f1 ff ff       	jmp    8010651e <alltraps>

80107333 <vector202>:
.globl vector202
vector202:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $202
80107335:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010733a:	e9 df f1 ff ff       	jmp    8010651e <alltraps>

8010733f <vector203>:
.globl vector203
vector203:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $203
80107341:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107346:	e9 d3 f1 ff ff       	jmp    8010651e <alltraps>

8010734b <vector204>:
.globl vector204
vector204:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $204
8010734d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107352:	e9 c7 f1 ff ff       	jmp    8010651e <alltraps>

80107357 <vector205>:
.globl vector205
vector205:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $205
80107359:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010735e:	e9 bb f1 ff ff       	jmp    8010651e <alltraps>

80107363 <vector206>:
.globl vector206
vector206:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $206
80107365:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010736a:	e9 af f1 ff ff       	jmp    8010651e <alltraps>

8010736f <vector207>:
.globl vector207
vector207:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $207
80107371:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107376:	e9 a3 f1 ff ff       	jmp    8010651e <alltraps>

8010737b <vector208>:
.globl vector208
vector208:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $208
8010737d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107382:	e9 97 f1 ff ff       	jmp    8010651e <alltraps>

80107387 <vector209>:
.globl vector209
vector209:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $209
80107389:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010738e:	e9 8b f1 ff ff       	jmp    8010651e <alltraps>

80107393 <vector210>:
.globl vector210
vector210:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $210
80107395:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010739a:	e9 7f f1 ff ff       	jmp    8010651e <alltraps>

8010739f <vector211>:
.globl vector211
vector211:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $211
801073a1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801073a6:	e9 73 f1 ff ff       	jmp    8010651e <alltraps>

801073ab <vector212>:
.globl vector212
vector212:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $212
801073ad:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801073b2:	e9 67 f1 ff ff       	jmp    8010651e <alltraps>

801073b7 <vector213>:
.globl vector213
vector213:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $213
801073b9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801073be:	e9 5b f1 ff ff       	jmp    8010651e <alltraps>

801073c3 <vector214>:
.globl vector214
vector214:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $214
801073c5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801073ca:	e9 4f f1 ff ff       	jmp    8010651e <alltraps>

801073cf <vector215>:
.globl vector215
vector215:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $215
801073d1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801073d6:	e9 43 f1 ff ff       	jmp    8010651e <alltraps>

801073db <vector216>:
.globl vector216
vector216:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $216
801073dd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801073e2:	e9 37 f1 ff ff       	jmp    8010651e <alltraps>

801073e7 <vector217>:
.globl vector217
vector217:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $217
801073e9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801073ee:	e9 2b f1 ff ff       	jmp    8010651e <alltraps>

801073f3 <vector218>:
.globl vector218
vector218:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $218
801073f5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801073fa:	e9 1f f1 ff ff       	jmp    8010651e <alltraps>

801073ff <vector219>:
.globl vector219
vector219:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $219
80107401:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107406:	e9 13 f1 ff ff       	jmp    8010651e <alltraps>

8010740b <vector220>:
.globl vector220
vector220:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $220
8010740d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107412:	e9 07 f1 ff ff       	jmp    8010651e <alltraps>

80107417 <vector221>:
.globl vector221
vector221:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $221
80107419:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010741e:	e9 fb f0 ff ff       	jmp    8010651e <alltraps>

80107423 <vector222>:
.globl vector222
vector222:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $222
80107425:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010742a:	e9 ef f0 ff ff       	jmp    8010651e <alltraps>

8010742f <vector223>:
.globl vector223
vector223:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $223
80107431:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107436:	e9 e3 f0 ff ff       	jmp    8010651e <alltraps>

8010743b <vector224>:
.globl vector224
vector224:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $224
8010743d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107442:	e9 d7 f0 ff ff       	jmp    8010651e <alltraps>

80107447 <vector225>:
.globl vector225
vector225:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $225
80107449:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010744e:	e9 cb f0 ff ff       	jmp    8010651e <alltraps>

80107453 <vector226>:
.globl vector226
vector226:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $226
80107455:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010745a:	e9 bf f0 ff ff       	jmp    8010651e <alltraps>

8010745f <vector227>:
.globl vector227
vector227:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $227
80107461:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107466:	e9 b3 f0 ff ff       	jmp    8010651e <alltraps>

8010746b <vector228>:
.globl vector228
vector228:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $228
8010746d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107472:	e9 a7 f0 ff ff       	jmp    8010651e <alltraps>

80107477 <vector229>:
.globl vector229
vector229:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $229
80107479:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010747e:	e9 9b f0 ff ff       	jmp    8010651e <alltraps>

80107483 <vector230>:
.globl vector230
vector230:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $230
80107485:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010748a:	e9 8f f0 ff ff       	jmp    8010651e <alltraps>

8010748f <vector231>:
.globl vector231
vector231:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $231
80107491:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107496:	e9 83 f0 ff ff       	jmp    8010651e <alltraps>

8010749b <vector232>:
.globl vector232
vector232:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $232
8010749d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801074a2:	e9 77 f0 ff ff       	jmp    8010651e <alltraps>

801074a7 <vector233>:
.globl vector233
vector233:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $233
801074a9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801074ae:	e9 6b f0 ff ff       	jmp    8010651e <alltraps>

801074b3 <vector234>:
.globl vector234
vector234:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $234
801074b5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801074ba:	e9 5f f0 ff ff       	jmp    8010651e <alltraps>

801074bf <vector235>:
.globl vector235
vector235:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $235
801074c1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801074c6:	e9 53 f0 ff ff       	jmp    8010651e <alltraps>

801074cb <vector236>:
.globl vector236
vector236:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $236
801074cd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801074d2:	e9 47 f0 ff ff       	jmp    8010651e <alltraps>

801074d7 <vector237>:
.globl vector237
vector237:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $237
801074d9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801074de:	e9 3b f0 ff ff       	jmp    8010651e <alltraps>

801074e3 <vector238>:
.globl vector238
vector238:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $238
801074e5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801074ea:	e9 2f f0 ff ff       	jmp    8010651e <alltraps>

801074ef <vector239>:
.globl vector239
vector239:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $239
801074f1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801074f6:	e9 23 f0 ff ff       	jmp    8010651e <alltraps>

801074fb <vector240>:
.globl vector240
vector240:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $240
801074fd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107502:	e9 17 f0 ff ff       	jmp    8010651e <alltraps>

80107507 <vector241>:
.globl vector241
vector241:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $241
80107509:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010750e:	e9 0b f0 ff ff       	jmp    8010651e <alltraps>

80107513 <vector242>:
.globl vector242
vector242:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $242
80107515:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010751a:	e9 ff ef ff ff       	jmp    8010651e <alltraps>

8010751f <vector243>:
.globl vector243
vector243:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $243
80107521:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107526:	e9 f3 ef ff ff       	jmp    8010651e <alltraps>

8010752b <vector244>:
.globl vector244
vector244:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $244
8010752d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107532:	e9 e7 ef ff ff       	jmp    8010651e <alltraps>

80107537 <vector245>:
.globl vector245
vector245:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $245
80107539:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010753e:	e9 db ef ff ff       	jmp    8010651e <alltraps>

80107543 <vector246>:
.globl vector246
vector246:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $246
80107545:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010754a:	e9 cf ef ff ff       	jmp    8010651e <alltraps>

8010754f <vector247>:
.globl vector247
vector247:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $247
80107551:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107556:	e9 c3 ef ff ff       	jmp    8010651e <alltraps>

8010755b <vector248>:
.globl vector248
vector248:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $248
8010755d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107562:	e9 b7 ef ff ff       	jmp    8010651e <alltraps>

80107567 <vector249>:
.globl vector249
vector249:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $249
80107569:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010756e:	e9 ab ef ff ff       	jmp    8010651e <alltraps>

80107573 <vector250>:
.globl vector250
vector250:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $250
80107575:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010757a:	e9 9f ef ff ff       	jmp    8010651e <alltraps>

8010757f <vector251>:
.globl vector251
vector251:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $251
80107581:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107586:	e9 93 ef ff ff       	jmp    8010651e <alltraps>

8010758b <vector252>:
.globl vector252
vector252:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $252
8010758d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107592:	e9 87 ef ff ff       	jmp    8010651e <alltraps>

80107597 <vector253>:
.globl vector253
vector253:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $253
80107599:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010759e:	e9 7b ef ff ff       	jmp    8010651e <alltraps>

801075a3 <vector254>:
.globl vector254
vector254:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $254
801075a5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801075aa:	e9 6f ef ff ff       	jmp    8010651e <alltraps>

801075af <vector255>:
.globl vector255
vector255:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $255
801075b1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801075b6:	e9 63 ef ff ff       	jmp    8010651e <alltraps>
801075bb:	66 90                	xchg   %ax,%ax
801075bd:	66 90                	xchg   %ax,%ax
801075bf:	90                   	nop

801075c0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801075c0:	f3 0f 1e fb          	endbr32 
801075c4:	55                   	push   %ebp
801075c5:	89 e5                	mov    %esp,%ebp
801075c7:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801075ca:	e8 e1 ce ff ff       	call   801044b0 <cpuid>
  pd[0] = size-1;
801075cf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801075d4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801075da:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801075de:	c7 80 d8 a8 13 80 ff 	movl   $0xffff,-0x7fec5728(%eax)
801075e5:	ff 00 00 
801075e8:	c7 80 dc a8 13 80 00 	movl   $0xcf9a00,-0x7fec5724(%eax)
801075ef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801075f2:	c7 80 e0 a8 13 80 ff 	movl   $0xffff,-0x7fec5720(%eax)
801075f9:	ff 00 00 
801075fc:	c7 80 e4 a8 13 80 00 	movl   $0xcf9200,-0x7fec571c(%eax)
80107603:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107606:	c7 80 e8 a8 13 80 ff 	movl   $0xffff,-0x7fec5718(%eax)
8010760d:	ff 00 00 
80107610:	c7 80 ec a8 13 80 00 	movl   $0xcffa00,-0x7fec5714(%eax)
80107617:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010761a:	c7 80 f0 a8 13 80 ff 	movl   $0xffff,-0x7fec5710(%eax)
80107621:	ff 00 00 
80107624:	c7 80 f4 a8 13 80 00 	movl   $0xcff200,-0x7fec570c(%eax)
8010762b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010762e:	05 d0 a8 13 80       	add    $0x8013a8d0,%eax
  pd[1] = (uint)p;
80107633:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107637:	c1 e8 10             	shr    $0x10,%eax
8010763a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010763e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107641:	0f 01 10             	lgdtl  (%eax)
}
80107644:	c9                   	leave  
80107645:	c3                   	ret    
80107646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010764d:	8d 76 00             	lea    0x0(%esi),%esi

80107650 <walkpgdir>:
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
int walkpgdircnt = 0;
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107650:	f3 0f 1e fb          	endbr32 
80107654:	55                   	push   %ebp
80107655:	89 e5                	mov    %esp,%ebp
80107657:	57                   	push   %edi
80107658:	56                   	push   %esi
80107659:	53                   	push   %ebx
8010765a:	83 ec 0c             	sub    $0xc,%esp
8010765d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  walkpgdircnt++;

  pde = &pgdir[PDX(va)];
80107660:	8b 55 08             	mov    0x8(%ebp),%edx
  walkpgdircnt++;
80107663:	83 05 c0 c5 10 80 01 	addl   $0x1,0x8010c5c0
  pde = &pgdir[PDX(va)];
8010766a:	89 fe                	mov    %edi,%esi
8010766c:	c1 ee 16             	shr    $0x16,%esi
8010766f:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80107672:	8b 1e                	mov    (%esi),%ebx
80107674:	f6 c3 01             	test   $0x1,%bl
80107677:	74 27                	je     801076a0 <walkpgdir+0x50>
    // if(walkpgdircnt>150000) cprintf("walkpgdir: if\n");
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80107679:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010767f:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    // cprintf("walkpgdir: if\n");
  }
  return &pgtab[PTX(va)];
80107685:	89 f8                	mov    %edi,%eax
}
80107687:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010768a:	c1 e8 0a             	shr    $0xa,%eax
8010768d:	25 fc 0f 00 00       	and    $0xffc,%eax
80107692:	01 d8                	add    %ebx,%eax
}
80107694:	5b                   	pop    %ebx
80107695:	5e                   	pop    %esi
80107696:	5f                   	pop    %edi
80107697:	5d                   	pop    %ebp
80107698:	c3                   	ret    
80107699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801076a0:	8b 45 10             	mov    0x10(%ebp),%eax
801076a3:	85 c0                	test   %eax,%eax
801076a5:	74 31                	je     801076d8 <walkpgdir+0x88>
801076a7:	e8 a4 ba ff ff       	call   80103150 <kalloc>
801076ac:	89 c3                	mov    %eax,%ebx
801076ae:	85 c0                	test   %eax,%eax
801076b0:	74 26                	je     801076d8 <walkpgdir+0x88>
    memset(pgtab, 0, PGSIZE);
801076b2:	83 ec 04             	sub    $0x4,%esp
801076b5:	68 00 10 00 00       	push   $0x1000
801076ba:	6a 00                	push   $0x0
801076bc:	50                   	push   %eax
801076bd:	e8 3e db ff ff       	call   80105200 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801076c2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076c8:	83 c4 10             	add    $0x10,%esp
801076cb:	83 c8 07             	or     $0x7,%eax
801076ce:	89 06                	mov    %eax,(%esi)
801076d0:	eb b3                	jmp    80107685 <walkpgdir+0x35>
801076d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
801076d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801076db:	31 c0                	xor    %eax,%eax
}
801076dd:	5b                   	pop    %ebx
801076de:	5e                   	pop    %esi
801076df:	5f                   	pop    %edi
801076e0:	5d                   	pop    %ebp
801076e1:	c3                   	ret    
801076e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	57                   	push   %edi
801076f4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801076f6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801076fa:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801076fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107700:	89 d6                	mov    %edx,%esi
{
80107702:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107703:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107709:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010770c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010770f:	8b 45 08             	mov    0x8(%ebp),%eax
80107712:	29 f0                	sub    %esi,%eax
80107714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107717:	eb 1f                	jmp    80107738 <mappages+0x48>
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107720:	f6 00 01             	testb  $0x1,(%eax)
80107723:	75 45                	jne    8010776a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107725:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107728:	83 cb 01             	or     $0x1,%ebx
8010772b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010772d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107730:	74 2e                	je     80107760 <mappages+0x70>
      break;
    a += PGSIZE;
80107732:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107738:	83 ec 04             	sub    $0x4,%esp
8010773b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010773e:	6a 01                	push   $0x1
80107740:	56                   	push   %esi
80107741:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107744:	57                   	push   %edi
80107745:	e8 06 ff ff ff       	call   80107650 <walkpgdir>
8010774a:	83 c4 10             	add    $0x10,%esp
8010774d:	85 c0                	test   %eax,%eax
8010774f:	75 cf                	jne    80107720 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107751:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107759:	5b                   	pop    %ebx
8010775a:	5e                   	pop    %esi
8010775b:	5f                   	pop    %edi
8010775c:	5d                   	pop    %ebp
8010775d:	c3                   	ret    
8010775e:	66 90                	xchg   %ax,%ax
80107760:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107763:	31 c0                	xor    %eax,%eax
}
80107765:	5b                   	pop    %ebx
80107766:	5e                   	pop    %esi
80107767:	5f                   	pop    %edi
80107768:	5d                   	pop    %ebp
80107769:	c3                   	ret    
      panic("remap");
8010776a:	83 ec 0c             	sub    $0xc,%esp
8010776d:	68 18 91 10 80       	push   $0x80109118
80107772:	e8 19 8c ff ff       	call   80100390 <panic>
80107777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010777e:	66 90                	xchg   %ax,%ax

80107780 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) // exit할때 이게 호출되는데, 해당 exit하는 프로세스가 kalloc한 모든 메모리를 kfree해주는 코드
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	57                   	push   %edi
80107784:	56                   	push   %esi
80107785:	89 c6                	mov    %eax,%esi
80107787:	53                   	push   %ebx
80107788:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010778a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107790:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) // exit할때 이게 호출되는데, 해당 exit하는 프로세스가 kalloc한 모든 메모리를 kfree해주는 코드
80107796:	83 ec 1c             	sub    $0x1c,%esp
80107799:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010779c:	39 da                	cmp    %ebx,%edx
8010779e:	73 5c                	jae    801077fc <deallocuvm.part.0+0x7c>
801077a0:	89 d7                	mov    %edx,%edi
801077a2:	eb 0e                	jmp    801077b2 <deallocuvm.part.0+0x32>
801077a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077a8:	81 c7 00 10 00 00    	add    $0x1000,%edi
801077ae:	39 fb                	cmp    %edi,%ebx
801077b0:	76 4a                	jbe    801077fc <deallocuvm.part.0+0x7c>
    pte = walkpgdir(pgdir, (char*)a, 0);
801077b2:	83 ec 04             	sub    $0x4,%esp
801077b5:	6a 00                	push   $0x0
801077b7:	57                   	push   %edi
801077b8:	56                   	push   %esi
801077b9:	e8 92 fe ff ff       	call   80107650 <walkpgdir>
    if(!pte)
801077be:	83 c4 10             	add    $0x10,%esp
801077c1:	85 c0                	test   %eax,%eax
801077c3:	74 4b                	je     80107810 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801077c5:	8b 08                	mov    (%eax),%ecx
801077c7:	f6 c1 01             	test   $0x1,%cl
801077ca:	74 dc                	je     801077a8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801077cc:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801077d2:	74 4c                	je     80107820 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801077d4:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801077d7:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
801077dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801077e0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801077e6:	51                   	push   %ecx
801077e7:	e8 d4 b3 ff ff       	call   80102bc0 <kfree>
      *pte = 0;
801077ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077ef:	83 c4 10             	add    $0x10,%esp
801077f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801077f8:	39 fb                	cmp    %edi,%ebx
801077fa:	77 b6                	ja     801077b2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
801077fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107802:	5b                   	pop    %ebx
80107803:	5e                   	pop    %esi
80107804:	5f                   	pop    %edi
80107805:	5d                   	pop    %ebp
80107806:	c3                   	ret    
80107807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780e:	66 90                	xchg   %ax,%ax
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107810:	89 fa                	mov    %edi,%edx
80107812:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107818:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010781e:	eb 8e                	jmp    801077ae <deallocuvm.part.0+0x2e>
        panic("kfree");
80107820:	83 ec 0c             	sub    $0xc,%esp
80107823:	68 e5 83 10 80       	push   $0x801083e5
80107828:	e8 63 8b ff ff       	call   80100390 <panic>
8010782d:	8d 76 00             	lea    0x0(%esi),%esi

80107830 <switchkvm>:
{
80107830:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107834:	a1 84 d5 13 80       	mov    0x8013d584,%eax
80107839:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010783e:	0f 22 d8             	mov    %eax,%cr3
}
80107841:	c3                   	ret    
80107842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107850 <switchuvm>:
{
80107850:	f3 0f 1e fb          	endbr32 
80107854:	55                   	push   %ebp
80107855:	89 e5                	mov    %esp,%ebp
80107857:	57                   	push   %edi
80107858:	56                   	push   %esi
80107859:	53                   	push   %ebx
8010785a:	83 ec 1c             	sub    $0x1c,%esp
8010785d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107860:	85 f6                	test   %esi,%esi
80107862:	0f 84 cb 00 00 00    	je     80107933 <switchuvm+0xe3>
  if(p->kstack == 0)
80107868:	8b 46 08             	mov    0x8(%esi),%eax
8010786b:	85 c0                	test   %eax,%eax
8010786d:	0f 84 da 00 00 00    	je     8010794d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107873:	8b 46 04             	mov    0x4(%esi),%eax
80107876:	85 c0                	test   %eax,%eax
80107878:	0f 84 c2 00 00 00    	je     80107940 <switchuvm+0xf0>
  pushcli();
8010787e:	e8 6d d7 ff ff       	call   80104ff0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107883:	e8 b8 cb ff ff       	call   80104440 <mycpu>
80107888:	89 c3                	mov    %eax,%ebx
8010788a:	e8 b1 cb ff ff       	call   80104440 <mycpu>
8010788f:	89 c7                	mov    %eax,%edi
80107891:	e8 aa cb ff ff       	call   80104440 <mycpu>
80107896:	83 c7 08             	add    $0x8,%edi
80107899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010789c:	e8 9f cb ff ff       	call   80104440 <mycpu>
801078a1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801078a4:	ba 67 00 00 00       	mov    $0x67,%edx
801078a9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801078b0:	83 c0 08             	add    $0x8,%eax
801078b3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078ba:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078bf:	83 c1 08             	add    $0x8,%ecx
801078c2:	c1 e8 18             	shr    $0x18,%eax
801078c5:	c1 e9 10             	shr    $0x10,%ecx
801078c8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801078ce:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801078d4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801078d9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801078e0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801078e5:	e8 56 cb ff ff       	call   80104440 <mycpu>
801078ea:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801078f1:	e8 4a cb ff ff       	call   80104440 <mycpu>
801078f6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801078fa:	8b 5e 08             	mov    0x8(%esi),%ebx
801078fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107903:	e8 38 cb ff ff       	call   80104440 <mycpu>
80107908:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010790b:	e8 30 cb ff ff       	call   80104440 <mycpu>
80107910:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107914:	b8 28 00 00 00       	mov    $0x28,%eax
80107919:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010791c:	8b 46 04             	mov    0x4(%esi),%eax
8010791f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107924:	0f 22 d8             	mov    %eax,%cr3
}
80107927:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010792a:	5b                   	pop    %ebx
8010792b:	5e                   	pop    %esi
8010792c:	5f                   	pop    %edi
8010792d:	5d                   	pop    %ebp
  popcli();
8010792e:	e9 0d d7 ff ff       	jmp    80105040 <popcli>
    panic("switchuvm: no process");
80107933:	83 ec 0c             	sub    $0xc,%esp
80107936:	68 1e 91 10 80       	push   $0x8010911e
8010793b:	e8 50 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107940:	83 ec 0c             	sub    $0xc,%esp
80107943:	68 49 91 10 80       	push   $0x80109149
80107948:	e8 43 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010794d:	83 ec 0c             	sub    $0xc,%esp
80107950:	68 34 91 10 80       	push   $0x80109134
80107955:	e8 36 8a ff ff       	call   80100390 <panic>
8010795a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107960 <inituvm>:
{
80107960:	f3 0f 1e fb          	endbr32 
80107964:	55                   	push   %ebp
80107965:	89 e5                	mov    %esp,%ebp
80107967:	57                   	push   %edi
80107968:	56                   	push   %esi
80107969:	53                   	push   %ebx
8010796a:	83 ec 1c             	sub    $0x1c,%esp
8010796d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107970:	8b 7d 08             	mov    0x8(%ebp),%edi
80107973:	8b 75 10             	mov    0x10(%ebp),%esi
80107976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  cprintf("inituvm: started %p %p %p\n", pgdir, init, sz);
80107979:	56                   	push   %esi
8010797a:	50                   	push   %eax
8010797b:	57                   	push   %edi
8010797c:	68 5d 91 10 80       	push   $0x8010915d
80107981:	e8 2a 8d ff ff       	call   801006b0 <cprintf>
  if(sz >= PGSIZE)
80107986:	83 c4 10             	add    $0x10,%esp
80107989:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010798f:	0f 87 84 00 00 00    	ja     80107a19 <inituvm+0xb9>
  mem = kalloc();
80107995:	e8 b6 b7 ff ff       	call   80103150 <kalloc>
  memset(mem, 0, PGSIZE);
8010799a:	83 ec 04             	sub    $0x4,%esp
8010799d:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801079a2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801079a4:	6a 00                	push   $0x0
801079a6:	50                   	push   %eax
801079a7:	e8 54 d8 ff ff       	call   80105200 <memset>
  cprintf("inituvm: mappages %p %p %p\n", pgdir, init, sz);
801079ac:	56                   	push   %esi
801079ad:	ff 75 e4             	pushl  -0x1c(%ebp)
801079b0:	57                   	push   %edi
801079b1:	68 92 91 10 80       	push   $0x80109192
801079b6:	e8 f5 8c ff ff       	call   801006b0 <cprintf>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801079bb:	83 c4 18             	add    $0x18,%esp
801079be:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079c4:	31 d2                	xor    %edx,%edx
801079c6:	6a 06                	push   $0x6
801079c8:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079cd:	50                   	push   %eax
801079ce:	89 f8                	mov    %edi,%eax
801079d0:	e8 1b fd ff ff       	call   801076f0 <mappages>
  memmove(mem, init, sz);
801079d5:	83 c4 0c             	add    $0xc,%esp
801079d8:	56                   	push   %esi
801079d9:	ff 75 e4             	pushl  -0x1c(%ebp)
801079dc:	53                   	push   %ebx
801079dd:	e8 be d8 ff ff       	call   801052a0 <memmove>
  init_lru();
801079e2:	e8 99 ad ff ff       	call   80102780 <init_lru>
  cprintf("inituvm: lru_append pgdir=%p vaddr=%p sz=%p mem=%p\n", pgdir, 0, sz, mem);
801079e7:	89 1c 24             	mov    %ebx,(%esp)
801079ea:	56                   	push   %esi
801079eb:	6a 00                	push   $0x0
801079ed:	57                   	push   %edi
801079ee:	68 8c 92 10 80       	push   $0x8010928c
801079f3:	e8 b8 8c ff ff       	call   801006b0 <cprintf>
  lru_append(pgdir, 0); // 맞나?
801079f8:	83 c4 18             	add    $0x18,%esp
801079fb:	6a 00                	push   $0x0
801079fd:	57                   	push   %edi
801079fe:	e8 7d af ff ff       	call   80102980 <lru_append>
  cprintf("inituvm ended successfully\n");
80107a03:	c7 45 08 ae 91 10 80 	movl   $0x801091ae,0x8(%ebp)
80107a0a:	83 c4 10             	add    $0x10,%esp
}
80107a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a10:	5b                   	pop    %ebx
80107a11:	5e                   	pop    %esi
80107a12:	5f                   	pop    %edi
80107a13:	5d                   	pop    %ebp
  cprintf("inituvm ended successfully\n");
80107a14:	e9 97 8c ff ff       	jmp    801006b0 <cprintf>
    panic("inituvm: more than a page");
80107a19:	83 ec 0c             	sub    $0xc,%esp
80107a1c:	68 78 91 10 80       	push   $0x80109178
80107a21:	e8 6a 89 ff ff       	call   80100390 <panic>
80107a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a2d:	8d 76 00             	lea    0x0(%esi),%esi

80107a30 <loaduvm>:
{
80107a30:	f3 0f 1e fb          	endbr32 
80107a34:	55                   	push   %ebp
80107a35:	89 e5                	mov    %esp,%ebp
80107a37:	57                   	push   %edi
80107a38:	56                   	push   %esi
80107a39:	53                   	push   %ebx
80107a3a:	83 ec 1c             	sub    $0x1c,%esp
80107a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a40:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107a43:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107a48:	0f 85 99 00 00 00    	jne    80107ae7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80107a4e:	01 f0                	add    %esi,%eax
80107a50:	89 f3                	mov    %esi,%ebx
80107a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a55:	8b 45 14             	mov    0x14(%ebp),%eax
80107a58:	01 f0                	add    %esi,%eax
80107a5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107a5d:	85 f6                	test   %esi,%esi
80107a5f:	75 15                	jne    80107a76 <loaduvm+0x46>
80107a61:	eb 6d                	jmp    80107ad0 <loaduvm+0xa0>
80107a63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a67:	90                   	nop
80107a68:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107a6e:	89 f0                	mov    %esi,%eax
80107a70:	29 d8                	sub    %ebx,%eax
80107a72:	39 c6                	cmp    %eax,%esi
80107a74:	76 5a                	jbe    80107ad0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a79:	83 ec 04             	sub    $0x4,%esp
80107a7c:	6a 00                	push   $0x0
80107a7e:	29 d8                	sub    %ebx,%eax
80107a80:	50                   	push   %eax
80107a81:	ff 75 08             	pushl  0x8(%ebp)
80107a84:	e8 c7 fb ff ff       	call   80107650 <walkpgdir>
80107a89:	83 c4 10             	add    $0x10,%esp
80107a8c:	85 c0                	test   %eax,%eax
80107a8e:	74 4a                	je     80107ada <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107a90:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a92:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107a95:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107a9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107a9f:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107aa5:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107aa8:	29 d9                	sub    %ebx,%ecx
80107aaa:	05 00 00 00 80       	add    $0x80000000,%eax
80107aaf:	57                   	push   %edi
80107ab0:	51                   	push   %ecx
80107ab1:	50                   	push   %eax
80107ab2:	ff 75 10             	pushl  0x10(%ebp)
80107ab5:	e8 a6 9f ff ff       	call   80101a60 <readi>
80107aba:	83 c4 10             	add    $0x10,%esp
80107abd:	39 f8                	cmp    %edi,%eax
80107abf:	74 a7                	je     80107a68 <loaduvm+0x38>
}
80107ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ac4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ac9:	5b                   	pop    %ebx
80107aca:	5e                   	pop    %esi
80107acb:	5f                   	pop    %edi
80107acc:	5d                   	pop    %ebp
80107acd:	c3                   	ret    
80107ace:	66 90                	xchg   %ax,%ax
80107ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ad3:	31 c0                	xor    %eax,%eax
}
80107ad5:	5b                   	pop    %ebx
80107ad6:	5e                   	pop    %esi
80107ad7:	5f                   	pop    %edi
80107ad8:	5d                   	pop    %ebp
80107ad9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107ada:	83 ec 0c             	sub    $0xc,%esp
80107add:	68 ca 91 10 80       	push   $0x801091ca
80107ae2:	e8 a9 88 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107ae7:	83 ec 0c             	sub    $0xc,%esp
80107aea:	68 c0 92 10 80       	push   $0x801092c0
80107aef:	e8 9c 88 ff ff       	call   80100390 <panic>
80107af4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107aff:	90                   	nop

80107b00 <allocuvm>:
{
80107b00:	f3 0f 1e fb          	endbr32 
80107b04:	55                   	push   %ebp
80107b05:	89 e5                	mov    %esp,%ebp
80107b07:	57                   	push   %edi
80107b08:	56                   	push   %esi
80107b09:	53                   	push   %ebx
80107b0a:	83 ec 28             	sub    $0x28,%esp
80107b0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  cprintf("allocuvm called\n");
80107b10:	68 e8 91 10 80       	push   $0x801091e8
80107b15:	e8 96 8b ff ff       	call   801006b0 <cprintf>
  if(newsz >= KERNBASE)
80107b1a:	8b 45 10             	mov    0x10(%ebp),%eax
80107b1d:	83 c4 10             	add    $0x10,%esp
80107b20:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107b23:	85 c0                	test   %eax,%eax
80107b25:	0f 88 05 01 00 00    	js     80107c30 <allocuvm+0x130>
  if(newsz < oldsz)
80107b2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107b31:	0f 82 e9 00 00 00    	jb     80107c20 <allocuvm+0x120>
  a = PGROUNDUP(oldsz);
80107b37:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107b3d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE, cnt++){
80107b43:	39 75 10             	cmp    %esi,0x10(%ebp)
80107b46:	0f 86 d7 00 00 00    	jbe    80107c23 <allocuvm+0x123>
80107b4c:	8b 45 10             	mov    0x10(%ebp),%eax
  int cnt = 0;
80107b4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107b56:	83 e8 01             	sub    $0x1,%eax
80107b59:	29 f0                	sub    %esi,%eax
80107b5b:	c1 e8 0c             	shr    $0xc,%eax
80107b5e:	83 c0 01             	add    $0x1,%eax
80107b61:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b64:	eb 72                	jmp    80107bd8 <allocuvm+0xd8>
80107b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b6d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107b70:	83 ec 04             	sub    $0x4,%esp
80107b73:	68 00 10 00 00       	push   $0x1000
80107b78:	6a 00                	push   $0x0
80107b7a:	50                   	push   %eax
80107b7b:	e8 80 d6 ff ff       	call   80105200 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107b80:	58                   	pop    %eax
80107b81:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b87:	5a                   	pop    %edx
80107b88:	6a 06                	push   $0x6
80107b8a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b8f:	89 f2                	mov    %esi,%edx
80107b91:	50                   	push   %eax
80107b92:	89 f8                	mov    %edi,%eax
80107b94:	e8 57 fb ff ff       	call   801076f0 <mappages>
80107b99:	83 c4 10             	add    $0x10,%esp
80107b9c:	85 c0                	test   %eax,%eax
80107b9e:	0f 88 a4 00 00 00    	js     80107c48 <allocuvm+0x148>
    cprintf("allocuvm %d: lru_append calling pgdir=%p, a=%p, mem=%p\n", cnt, pgdir, a, mem);
80107ba4:	83 ec 0c             	sub    $0xc,%esp
80107ba7:	53                   	push   %ebx
80107ba8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80107bab:	56                   	push   %esi
80107bac:	57                   	push   %edi
80107bad:	53                   	push   %ebx
80107bae:	68 e4 92 10 80       	push   $0x801092e4
80107bb3:	e8 f8 8a ff ff       	call   801006b0 <cprintf>
    lru_append(pgdir, (void *)a); // My code
80107bb8:	83 c4 18             	add    $0x18,%esp
80107bbb:	56                   	push   %esi
  for (; a < newsz; a += PGSIZE, cnt++){
80107bbc:	81 c6 00 10 00 00    	add    $0x1000,%esi
    lru_append(pgdir, (void *)a); // My code
80107bc2:	57                   	push   %edi
80107bc3:	e8 b8 ad ff ff       	call   80102980 <lru_append>
  for (; a < newsz; a += PGSIZE, cnt++){
80107bc8:	89 d8                	mov    %ebx,%eax
80107bca:	83 c4 10             	add    $0x10,%esp
80107bcd:	83 c0 01             	add    $0x1,%eax
80107bd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107bd3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80107bd6:	74 4b                	je     80107c23 <allocuvm+0x123>
    mem = kalloc();
80107bd8:	e8 73 b5 ff ff       	call   80103150 <kalloc>
80107bdd:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107bdf:	85 c0                	test   %eax,%eax
80107be1:	75 8d                	jne    80107b70 <allocuvm+0x70>
      cprintf("allocuvm out of memory\n");
80107be3:	83 ec 0c             	sub    $0xc,%esp
80107be6:	68 f9 91 10 80       	push   $0x801091f9
80107beb:	e8 c0 8a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bf3:	83 c4 10             	add    $0x10,%esp
80107bf6:	39 45 10             	cmp    %eax,0x10(%ebp)
80107bf9:	74 35                	je     80107c30 <allocuvm+0x130>
80107bfb:	8b 55 10             	mov    0x10(%ebp),%edx
80107bfe:	89 c1                	mov    %eax,%ecx
80107c00:	89 f8                	mov    %edi,%eax
80107c02:	e8 79 fb ff ff       	call   80107780 <deallocuvm.part.0>
      return 0;
80107c07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80107c0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c14:	5b                   	pop    %ebx
80107c15:	5e                   	pop    %esi
80107c16:	5f                   	pop    %edi
80107c17:	5d                   	pop    %ebp
80107c18:	c3                   	ret    
80107c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107c20:	89 45 dc             	mov    %eax,-0x24(%ebp)
}
80107c23:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107c26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c29:	5b                   	pop    %ebx
80107c2a:	5e                   	pop    %esi
80107c2b:	5f                   	pop    %edi
80107c2c:	5d                   	pop    %ebp
80107c2d:	c3                   	ret    
80107c2e:	66 90                	xchg   %ax,%ax
    return 0;
80107c30:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80107c37:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c3d:	5b                   	pop    %ebx
80107c3e:	5e                   	pop    %esi
80107c3f:	5f                   	pop    %edi
80107c40:	5d                   	pop    %ebp
80107c41:	c3                   	ret    
80107c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107c48:	83 ec 0c             	sub    $0xc,%esp
80107c4b:	68 11 92 10 80       	push   $0x80109211
80107c50:	e8 5b 8a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c58:	83 c4 10             	add    $0x10,%esp
80107c5b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c5e:	74 0c                	je     80107c6c <allocuvm+0x16c>
80107c60:	8b 55 10             	mov    0x10(%ebp),%edx
80107c63:	89 c1                	mov    %eax,%ecx
80107c65:	89 f8                	mov    %edi,%eax
80107c67:	e8 14 fb ff ff       	call   80107780 <deallocuvm.part.0>
      kfree(mem);
80107c6c:	83 ec 0c             	sub    $0xc,%esp
80107c6f:	53                   	push   %ebx
80107c70:	e8 4b af ff ff       	call   80102bc0 <kfree>
      return 0;
80107c75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80107c7c:	83 c4 10             	add    $0x10,%esp
}
80107c7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c85:	5b                   	pop    %ebx
80107c86:	5e                   	pop    %esi
80107c87:	5f                   	pop    %edi
80107c88:	5d                   	pop    %ebp
80107c89:	c3                   	ret    
80107c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c90 <deallocuvm>:
{
80107c90:	f3 0f 1e fb          	endbr32 
80107c94:	55                   	push   %ebp
80107c95:	89 e5                	mov    %esp,%ebp
80107c97:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107ca0:	39 d1                	cmp    %edx,%ecx
80107ca2:	73 0c                	jae    80107cb0 <deallocuvm+0x20>
}
80107ca4:	5d                   	pop    %ebp
80107ca5:	e9 d6 fa ff ff       	jmp    80107780 <deallocuvm.part.0>
80107caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107cb0:	89 d0                	mov    %edx,%eax
80107cb2:	5d                   	pop    %ebp
80107cb3:	c3                   	ret    
80107cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cbf:	90                   	nop

80107cc0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107cc0:	f3 0f 1e fb          	endbr32 
80107cc4:	55                   	push   %ebp
80107cc5:	89 e5                	mov    %esp,%ebp
80107cc7:	57                   	push   %edi
80107cc8:	56                   	push   %esi
80107cc9:	53                   	push   %ebx
80107cca:	83 ec 0c             	sub    $0xc,%esp
80107ccd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107cd0:	85 f6                	test   %esi,%esi
80107cd2:	74 55                	je     80107d29 <freevm+0x69>
  if(newsz >= oldsz)
80107cd4:	31 c9                	xor    %ecx,%ecx
80107cd6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107cdb:	89 f0                	mov    %esi,%eax
80107cdd:	89 f3                	mov    %esi,%ebx
80107cdf:	e8 9c fa ff ff       	call   80107780 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107ce4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107cea:	eb 0b                	jmp    80107cf7 <freevm+0x37>
80107cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cf0:	83 c3 04             	add    $0x4,%ebx
80107cf3:	39 df                	cmp    %ebx,%edi
80107cf5:	74 23                	je     80107d1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107cf7:	8b 03                	mov    (%ebx),%eax
80107cf9:	a8 01                	test   $0x1,%al
80107cfb:	74 f3                	je     80107cf0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107d02:	83 ec 0c             	sub    $0xc,%esp
80107d05:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d08:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107d0d:	50                   	push   %eax
80107d0e:	e8 ad ae ff ff       	call   80102bc0 <kfree>
80107d13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d16:	39 df                	cmp    %ebx,%edi
80107d18:	75 dd                	jne    80107cf7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d20:	5b                   	pop    %ebx
80107d21:	5e                   	pop    %esi
80107d22:	5f                   	pop    %edi
80107d23:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107d24:	e9 97 ae ff ff       	jmp    80102bc0 <kfree>
    panic("freevm: no pgdir");
80107d29:	83 ec 0c             	sub    $0xc,%esp
80107d2c:	68 2d 92 10 80       	push   $0x8010922d
80107d31:	e8 5a 86 ff ff       	call   80100390 <panic>
80107d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d3d:	8d 76 00             	lea    0x0(%esi),%esi

80107d40 <setupkvm>:
{
80107d40:	f3 0f 1e fb          	endbr32 
80107d44:	55                   	push   %ebp
80107d45:	89 e5                	mov    %esp,%ebp
80107d47:	56                   	push   %esi
80107d48:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107d49:	e8 02 b4 ff ff       	call   80103150 <kalloc>
80107d4e:	89 c6                	mov    %eax,%esi
80107d50:	85 c0                	test   %eax,%eax
80107d52:	74 42                	je     80107d96 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107d54:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d57:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107d5c:	68 00 10 00 00       	push   $0x1000
80107d61:	6a 00                	push   $0x0
80107d63:	50                   	push   %eax
80107d64:	e8 97 d4 ff ff       	call   80105200 <memset>
80107d69:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d6c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d6f:	83 ec 08             	sub    $0x8,%esp
80107d72:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d75:	ff 73 0c             	pushl  0xc(%ebx)
80107d78:	8b 13                	mov    (%ebx),%edx
80107d7a:	50                   	push   %eax
80107d7b:	29 c1                	sub    %eax,%ecx
80107d7d:	89 f0                	mov    %esi,%eax
80107d7f:	e8 6c f9 ff ff       	call   801076f0 <mappages>
80107d84:	83 c4 10             	add    $0x10,%esp
80107d87:	85 c0                	test   %eax,%eax
80107d89:	78 15                	js     80107da0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d8b:	83 c3 10             	add    $0x10,%ebx
80107d8e:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107d94:	75 d6                	jne    80107d6c <setupkvm+0x2c>
}
80107d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d99:	89 f0                	mov    %esi,%eax
80107d9b:	5b                   	pop    %ebx
80107d9c:	5e                   	pop    %esi
80107d9d:	5d                   	pop    %ebp
80107d9e:	c3                   	ret    
80107d9f:	90                   	nop
      freevm(pgdir);
80107da0:	83 ec 0c             	sub    $0xc,%esp
80107da3:	56                   	push   %esi
      return 0;
80107da4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107da6:	e8 15 ff ff ff       	call   80107cc0 <freevm>
      return 0;
80107dab:	83 c4 10             	add    $0x10,%esp
}
80107dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107db1:	89 f0                	mov    %esi,%eax
80107db3:	5b                   	pop    %ebx
80107db4:	5e                   	pop    %esi
80107db5:	5d                   	pop    %ebp
80107db6:	c3                   	ret    
80107db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dbe:	66 90                	xchg   %ax,%ax

80107dc0 <kvmalloc>:
{
80107dc0:	f3 0f 1e fb          	endbr32 
80107dc4:	55                   	push   %ebp
80107dc5:	89 e5                	mov    %esp,%ebp
80107dc7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107dca:	e8 71 ff ff ff       	call   80107d40 <setupkvm>
80107dcf:	a3 84 d5 13 80       	mov    %eax,0x8013d584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dd4:	05 00 00 00 80       	add    $0x80000000,%eax
80107dd9:	0f 22 d8             	mov    %eax,%cr3
}
80107ddc:	c9                   	leave  
80107ddd:	c3                   	ret    
80107dde:	66 90                	xchg   %ax,%ax

80107de0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107de0:	f3 0f 1e fb          	endbr32 
80107de4:	55                   	push   %ebp
80107de5:	89 e5                	mov    %esp,%ebp
80107de7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107dea:	6a 00                	push   $0x0
80107dec:	ff 75 0c             	pushl  0xc(%ebp)
80107def:	ff 75 08             	pushl  0x8(%ebp)
80107df2:	e8 59 f8 ff ff       	call   80107650 <walkpgdir>
  if(pte == 0)
80107df7:	83 c4 10             	add    $0x10,%esp
80107dfa:	85 c0                	test   %eax,%eax
80107dfc:	74 05                	je     80107e03 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107dfe:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107e01:	c9                   	leave  
80107e02:	c3                   	ret    
    panic("clearpteu");
80107e03:	83 ec 0c             	sub    $0xc,%esp
80107e06:	68 3e 92 10 80       	push   $0x8010923e
80107e0b:	e8 80 85 ff ff       	call   80100390 <panic>

80107e10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107e10:	f3 0f 1e fb          	endbr32 
80107e14:	55                   	push   %ebp
80107e15:	89 e5                	mov    %esp,%ebp
80107e17:	57                   	push   %edi
80107e18:	56                   	push   %esi
80107e19:	53                   	push   %ebx
80107e1a:	83 ec 28             	sub    $0x28,%esp
  cprintf("copyuvm called\n");
80107e1d:	68 48 92 10 80       	push   $0x80109248
80107e22:	e8 89 88 ff ff       	call   801006b0 <cprintf>
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107e27:	e8 14 ff ff ff       	call   80107d40 <setupkvm>
80107e2c:	83 c4 10             	add    $0x10,%esp
80107e2f:	89 c7                	mov    %eax,%edi
80107e31:	85 c0                	test   %eax,%eax
80107e33:	0f 84 c2 00 00 00    	je     80107efb <copyuvm+0xeb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107e39:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e3c:	85 c0                	test   %eax,%eax
80107e3e:	0f 84 b7 00 00 00    	je     80107efb <copyuvm+0xeb>
80107e44:	31 db                	xor    %ebx,%ebx
80107e46:	eb 68                	jmp    80107eb0 <copyuvm+0xa0>
80107e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e4f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e53:	83 ec 04             	sub    $0x4,%esp
80107e56:	68 00 10 00 00       	push   $0x1000
80107e5b:	05 00 00 00 80       	add    $0x80000000,%eax
80107e60:	50                   	push   %eax
80107e61:	56                   	push   %esi
80107e62:	e8 39 d4 ff ff       	call   801052a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107e67:	59                   	pop    %ecx
80107e68:	58                   	pop    %eax
80107e69:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107e6f:	ff 75 e0             	pushl  -0x20(%ebp)
80107e72:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e77:	89 da                	mov    %ebx,%edx
80107e79:	50                   	push   %eax
80107e7a:	89 f8                	mov    %edi,%eax
80107e7c:	e8 6f f8 ff ff       	call   801076f0 <mappages>
80107e81:	83 c4 10             	add    $0x10,%esp
80107e84:	85 c0                	test   %eax,%eax
80107e86:	0f 88 7c 00 00 00    	js     80107f08 <copyuvm+0xf8>
      kfree(mem);
      goto bad;
    }
    cprintf("copyuvm: lru_append calling, pgdir=%p, i=%p, mem=%p\n", d, i, mem);
80107e8c:	56                   	push   %esi
80107e8d:	53                   	push   %ebx
80107e8e:	57                   	push   %edi
80107e8f:	68 1c 93 10 80       	push   $0x8010931c
80107e94:	e8 17 88 ff ff       	call   801006b0 <cprintf>
    lru_append(d, (void *)i); // My code
80107e99:	58                   	pop    %eax
80107e9a:	5a                   	pop    %edx
80107e9b:	53                   	push   %ebx
80107e9c:	57                   	push   %edi
  for(i = 0; i < sz; i += PGSIZE){
80107e9d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    lru_append(d, (void *)i); // My code
80107ea3:	e8 d8 aa ff ff       	call   80102980 <lru_append>
  for(i = 0; i < sz; i += PGSIZE){
80107ea8:	83 c4 10             	add    $0x10,%esp
80107eab:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107eae:	76 4b                	jbe    80107efb <copyuvm+0xeb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107eb0:	83 ec 04             	sub    $0x4,%esp
80107eb3:	6a 00                	push   $0x0
80107eb5:	53                   	push   %ebx
80107eb6:	ff 75 08             	pushl  0x8(%ebp)
80107eb9:	e8 92 f7 ff ff       	call   80107650 <walkpgdir>
80107ebe:	83 c4 10             	add    $0x10,%esp
80107ec1:	85 c0                	test   %eax,%eax
80107ec3:	74 5e                	je     80107f23 <copyuvm+0x113>
    if(!(*pte & PTE_P))
80107ec5:	8b 00                	mov    (%eax),%eax
80107ec7:	a8 01                	test   $0x1,%al
80107ec9:	74 4b                	je     80107f16 <copyuvm+0x106>
    pa = PTE_ADDR(*pte);
80107ecb:	89 c2                	mov    %eax,%edx
    flags = PTE_FLAGS(*pte);
80107ecd:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107ed2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    flags = PTE_FLAGS(*pte);
80107ed8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pa = PTE_ADDR(*pte);
80107edb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107ede:	e8 6d b2 ff ff       	call   80103150 <kalloc>
80107ee3:	89 c6                	mov    %eax,%esi
80107ee5:	85 c0                	test   %eax,%eax
80107ee7:	0f 85 63 ff ff ff    	jne    80107e50 <copyuvm+0x40>
  }
  return d;

bad:
  freevm(d);
80107eed:	83 ec 0c             	sub    $0xc,%esp
80107ef0:	57                   	push   %edi
  return 0;
80107ef1:	31 ff                	xor    %edi,%edi
  freevm(d);
80107ef3:	e8 c8 fd ff ff       	call   80107cc0 <freevm>
  return 0;
80107ef8:	83 c4 10             	add    $0x10,%esp
}
80107efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107efe:	89 f8                	mov    %edi,%eax
80107f00:	5b                   	pop    %ebx
80107f01:	5e                   	pop    %esi
80107f02:	5f                   	pop    %edi
80107f03:	5d                   	pop    %ebp
80107f04:	c3                   	ret    
80107f05:	8d 76 00             	lea    0x0(%esi),%esi
      kfree(mem);
80107f08:	83 ec 0c             	sub    $0xc,%esp
80107f0b:	56                   	push   %esi
80107f0c:	e8 af ac ff ff       	call   80102bc0 <kfree>
      goto bad;
80107f11:	83 c4 10             	add    $0x10,%esp
80107f14:	eb d7                	jmp    80107eed <copyuvm+0xdd>
      panic("copyuvm: page not present");
80107f16:	83 ec 0c             	sub    $0xc,%esp
80107f19:	68 72 92 10 80       	push   $0x80109272
80107f1e:	e8 6d 84 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107f23:	83 ec 0c             	sub    $0xc,%esp
80107f26:	68 58 92 10 80       	push   $0x80109258
80107f2b:	e8 60 84 ff ff       	call   80100390 <panic>

80107f30 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f30:	f3 0f 1e fb          	endbr32 
80107f34:	55                   	push   %ebp
80107f35:	89 e5                	mov    %esp,%ebp
80107f37:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f3a:	6a 00                	push   $0x0
80107f3c:	ff 75 0c             	pushl  0xc(%ebp)
80107f3f:	ff 75 08             	pushl  0x8(%ebp)
80107f42:	e8 09 f7 ff ff       	call   80107650 <walkpgdir>
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
80107f47:	83 c4 10             	add    $0x10,%esp
  if((*pte & PTE_P) == 0)
80107f4a:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107f4c:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107f4d:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107f54:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f57:	05 00 00 00 80       	add    $0x80000000,%eax
80107f5c:	83 fa 05             	cmp    $0x5,%edx
80107f5f:	ba 00 00 00 00       	mov    $0x0,%edx
80107f64:	0f 45 c2             	cmovne %edx,%eax
}
80107f67:	c3                   	ret    
80107f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f6f:	90                   	nop

80107f70 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f70:	f3 0f 1e fb          	endbr32 
80107f74:	55                   	push   %ebp
80107f75:	89 e5                	mov    %esp,%ebp
80107f77:	57                   	push   %edi
80107f78:	56                   	push   %esi
80107f79:	53                   	push   %ebx
80107f7a:	83 ec 0c             	sub    $0xc,%esp
80107f7d:	8b 75 14             	mov    0x14(%ebp),%esi
80107f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107f83:	85 f6                	test   %esi,%esi
80107f85:	75 3c                	jne    80107fc3 <copyout+0x53>
80107f87:	eb 67                	jmp    80107ff0 <copyout+0x80>
80107f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107f90:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f93:	89 fb                	mov    %edi,%ebx
80107f95:	29 d3                	sub    %edx,%ebx
80107f97:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107f9d:	39 f3                	cmp    %esi,%ebx
80107f9f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107fa2:	29 fa                	sub    %edi,%edx
80107fa4:	83 ec 04             	sub    $0x4,%esp
80107fa7:	01 c2                	add    %eax,%edx
80107fa9:	53                   	push   %ebx
80107faa:	ff 75 10             	pushl  0x10(%ebp)
80107fad:	52                   	push   %edx
80107fae:	e8 ed d2 ff ff       	call   801052a0 <memmove>
    len -= n;
    buf += n;
80107fb3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107fb6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107fbc:	83 c4 10             	add    $0x10,%esp
80107fbf:	29 de                	sub    %ebx,%esi
80107fc1:	74 2d                	je     80107ff0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107fc3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107fc5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107fc8:	89 55 0c             	mov    %edx,0xc(%ebp)
80107fcb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107fd1:	57                   	push   %edi
80107fd2:	ff 75 08             	pushl  0x8(%ebp)
80107fd5:	e8 56 ff ff ff       	call   80107f30 <uva2ka>
    if(pa0 == 0)
80107fda:	83 c4 10             	add    $0x10,%esp
80107fdd:	85 c0                	test   %eax,%eax
80107fdf:	75 af                	jne    80107f90 <copyout+0x20>
  }
  return 0;
}
80107fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107fe4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107fe9:	5b                   	pop    %ebx
80107fea:	5e                   	pop    %esi
80107feb:	5f                   	pop    %edi
80107fec:	5d                   	pop    %ebp
80107fed:	c3                   	ret    
80107fee:	66 90                	xchg   %ax,%ax
80107ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ff3:	31 c0                	xor    %eax,%eax
}
80107ff5:	5b                   	pop    %ebx
80107ff6:	5e                   	pop    %esi
80107ff7:	5f                   	pop    %edi
80107ff8:	5d                   	pop    %ebp
80107ff9:	c3                   	ret    
