
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp
8010002d:	b8 50 31 10 80       	mov    $0x80103150,%eax
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

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 60 76 10 80       	push   $0x80107660
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 61 47 00 00       	call   801047c0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 76 10 80       	push   $0x80107667
80100097:	50                   	push   %eax
80100098:	e8 e3 45 00 00       	call   80104680 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
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
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 53 48 00 00       	call   80104940 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 99 48 00 00       	call   80104a00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 45 00 00       	call   801046c0 <acquiresleep>
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
801001a3:	68 6e 76 10 80       	push   $0x8010766e
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
801001c2:	e8 99 45 00 00       	call   80104760 <holdingsleep>
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
801001e0:	68 7f 76 10 80       	push   $0x8010767f
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
80100203:	e8 58 45 00 00       	call   80104760 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 08 45 00 00       	call   80104720 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 1c 47 00 00       	call   80104940 <acquire>
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
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 8b 47 00 00       	jmp    80104a00 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 76 10 80       	push   $0x80107686
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
801002b1:	e8 8a 46 00 00       	call   80104940 <acquire>
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
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 96 3d 00 00       	call   80104080 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 a1 37 00 00       	call   80103aa0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 ed 46 00 00       	call   80104a00 <release>
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
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
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
80100365:	e8 96 46 00 00       	call   80104a00 <release>
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
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
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
801003ad:	e8 fe 25 00 00       	call   801029b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 76 10 80       	push   $0x8010768d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 cf 80 10 80 	movl   $0x801080cf,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ff 43 00 00       	call   801047e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 76 10 80       	push   $0x801076a1
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
8010042a:	e8 21 5e 00 00       	call   80106250 <uartputc>
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
80100515:	e8 36 5d 00 00       	call   80106250 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 2a 5d 00 00       	call   80106250 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 1e 5d 00 00       	call   80106250 <uartputc>
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
80100561:	e8 8a 45 00 00       	call   80104af0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 d5 44 00 00       	call   80104a50 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 a5 76 10 80       	push   $0x801076a5
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
801005c9:	0f b6 92 d0 76 10 80 	movzbl -0x7fef8930(%edx),%edx
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
8010065f:	e8 dc 42 00 00       	call   80104940 <acquire>
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
80100697:	e8 64 43 00 00       	call   80104a00 <release>
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
8010077d:	bb b8 76 10 80       	mov    $0x801076b8,%ebx
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
801007bd:	e8 7e 41 00 00       	call   80104940 <acquire>
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
80100828:	e8 d3 41 00 00       	call   80104a00 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 bf 76 10 80       	push   $0x801076bf
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
80100877:	e8 c4 40 00 00       	call   80104940 <acquire>
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
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
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
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
801009cf:	e8 2c 40 00 00       	call   80104a00 <release>
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
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
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
801009ff:	e9 3c 39 00 00       	jmp    80104340 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 1b 38 00 00       	call   80104240 <wakeup>
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
80100a3a:	68 c8 76 10 80       	push   $0x801076c8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 77 3d 00 00       	call   801047c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
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
80100a90:	e8 0b 30 00 00       	call   80103aa0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 23 00 00       	call   80102e40 <begin_op>

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
80100ae3:	e8 c8 23 00 00       	call   80102eb0 <end_op>
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
80100b0c:	e8 af 68 00 00       	call   801073c0 <setupkvm>
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
80100b73:	e8 68 66 00 00       	call   801071e0 <allocuvm>
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
80100ba9:	e8 62 65 00 00       	call   80107110 <loaduvm>
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
80100beb:	e8 50 67 00 00       	call   80107340 <freevm>
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
80100c21:	e8 8a 22 00 00       	call   80102eb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 a9 65 00 00       	call   801071e0 <allocuvm>
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
80100c53:	e8 08 68 00 00       	call   80107460 <clearpteu>
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
80100ca3:	e8 a8 3f 00 00       	call   80104c50 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 95 3f 00 00       	call   80104c50 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 f4 68 00 00       	call   801075c0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 5a 66 00 00       	call   80107340 <freevm>
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
80100d33:	e8 88 68 00 00       	call   801075c0 <copyout>
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
80100d71:	e8 9a 3e 00 00       	call   80104c10 <safestrcpy>
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
80100d9d:	e8 de 61 00 00       	call   80106f80 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 96 65 00 00       	call   80107340 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 f7 20 00 00       	call   80102eb0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 e1 76 10 80       	push   $0x801076e1
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
80100dea:	68 ed 76 10 80       	push   $0x801076ed
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 c7 39 00 00       	call   801047c0 <initlock>
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
80100e08:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 0f 11 80       	push   $0x80110fc0
80100e15:	e8 26 3b 00 00       	call   80104940 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
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
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 ba 3b 00 00       	call   80104a00 <release>
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
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 a1 3b 00 00       	call   80104a00 <release>
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
80100e7e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e83:	e8 b8 3a 00 00       	call   80104940 <acquire>
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
80100e9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea0:	e8 5b 3b 00 00       	call   80104a00 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 f4 76 10 80       	push   $0x801076f4
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
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed5:	e8 66 3a 00 00       	call   80104940 <acquire>
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
80100f08:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 eb 3a 00 00       	call   80104a00 <release>

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
80100f30:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 bd 3a 00 00       	jmp    80104a00 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 f3 1e 00 00       	call   80102e40 <begin_op>
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
80100f62:	e9 49 1f 00 00       	jmp    80102eb0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 92 26 00 00       	call   80103610 <pipeclose>
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
80100f8c:	68 fc 76 10 80       	push   $0x801076fc
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
80101065:	e9 46 27 00 00       	jmp    801037b0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 06 77 10 80       	push   $0x80107706
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
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
801010f1:	e8 ba 1d 00 00       	call   80102eb0 <end_op>

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
8010111a:	e8 21 1d 00 00       	call   80102e40 <begin_op>
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
80101151:	e8 5a 1d 00 00       	call   80102eb0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 0f 77 10 80       	push   $0x8010770f
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
80101191:	e9 1a 25 00 00       	jmp    801036b0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 15 77 10 80       	push   $0x80107715
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
801011b9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
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
801011dc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 c0 19 11 80       	mov    0x801119c0,%eax
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
80101249:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 1f 77 10 80       	push   $0x8010771f
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
8010126d:	e8 ae 1d 00 00       	call   80103020 <log_write>
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
80101295:	e8 b6 37 00 00       	call   80104a50 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 7e 1d 00 00       	call   80103020 <log_write>
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
801012ca:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 19 11 80       	push   $0x801119e0
801012da:	e8 61 36 00 00       	call   80104940 <acquire>
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
801012fa:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
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
8010131b:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
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
80101342:	68 e0 19 11 80       	push   $0x801119e0
80101347:	e8 b4 36 00 00       	call   80104a00 <release>

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
8010136d:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101372:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101375:	e8 86 36 00 00       	call   80104a00 <release>
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
80101387:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010138d:	73 10                	jae    8010139f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101392:	85 c9                	test   %ecx,%ecx
80101394:	0f 8f 56 ff ff ff    	jg     801012f0 <iget+0x30>
8010139a:	e9 6e ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 35 77 10 80       	push   $0x80107735
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
80101425:	e8 f6 1b 00 00       	call   80103020 <log_write>
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
8010146b:	68 45 77 10 80       	push   $0x80107745
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
801014a5:	e8 46 36 00 00       	call   80104af0 <memmove>
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
801014cc:	68 c0 19 11 80       	push   $0x801119c0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 d8 19 11 80    	add    0x801119d8,%eax
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
8010151a:	e8 01 1b 00 00       	call   80103020 <log_write>
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
80101534:	68 58 77 10 80       	push   $0x80107758
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 6b 77 10 80       	push   $0x8010776b
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 61 32 00 00       	call   801047c0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 72 77 10 80       	push   $0x80107772
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 04 31 00 00       	call   80104680 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 19 11 80       	push   $0x801119c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 19 11 80    	pushl  0x801119d8
8010159d:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015a3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015a9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015af:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015b5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015bb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015c1:	68 f4 77 10 80       	push   $0x801077f4
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
801015f0:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
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
8010161f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
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
8010165e:	e8 ed 33 00 00       	call   80104a50 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 ab 19 00 00       	call   80103020 <log_write>
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
80101693:	68 78 77 10 80       	push   $0x80107778
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
801016b8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
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
80101705:	e8 e6 33 00 00       	call   80104af0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 0e 19 00 00       	call   80103020 <log_write>
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
8010173e:	68 e0 19 11 80       	push   $0x801119e0
80101743:	e8 f8 31 00 00       	call   80104940 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 a8 32 00 00       	call   80104a00 <release>
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
80101786:	e8 35 2f 00 00       	call   801046c0 <acquiresleep>
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
801017a9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
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
801017f8:	e8 f3 32 00 00       	call   80104af0 <memmove>
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
8010181d:	68 90 77 10 80       	push   $0x80107790
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 8a 77 10 80       	push   $0x8010778a
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
80101857:	e8 04 2f 00 00       	call   80104760 <holdingsleep>
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
80101873:	e9 a8 2e 00 00       	jmp    80104720 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 9f 77 10 80       	push   $0x8010779f
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
801018a4:	e8 17 2e 00 00       	call   801046c0 <acquiresleep>
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
801018be:	e8 5d 2e 00 00       	call   80104720 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 71 30 00 00       	call   80104940 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 17 31 00 00       	jmp    80104a00 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 43 30 00 00       	call   80104940 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 f4 30 00 00       	call   80104a00 <release>
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
//PAGEBREAK!
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
80101b07:	e8 e4 2f 00 00       	call   80104af0 <memmove>
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
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
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
// PAGEBREAK!
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
80101c03:	e8 e8 2e 00 00       	call   80104af0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 10 14 00 00       	call   80103020 <log_write>
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
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
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
//PAGEBREAK!
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
80101ca2:	e8 b9 2e 00 00       	call   80104b60 <strncmp>
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
80101d05:	e8 56 2e 00 00       	call   80104b60 <strncmp>
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
80101d4a:	68 b9 77 10 80       	push   $0x801077b9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 a7 77 10 80       	push   $0x801077a7
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
80101d8a:	e8 11 1d 00 00       	call   80103aa0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 9f 2b 00 00       	call   80104940 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 4f 2c 00 00       	call   80104a00 <release>
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
80101e17:	e8 d4 2c 00 00       	call   80104af0 <memmove>
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
80101ea3:	e8 48 2c 00 00       	call   80104af0 <memmove>
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
80101fd5:	e8 d6 2b 00 00       	call   80104bb0 <strncpy>
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
80102013:	68 c8 77 10 80       	push   $0x801077c8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 b6 7e 10 80       	push   $0x80107eb6
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

#define SWAPBASE	500
#define SWAPMAX		(100000 - SWAPBASE)

void swapread(char* ptr, int blkno)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
80102075:	89 e5                	mov    %esp,%ebp
80102077:	57                   	push   %edi
80102078:	56                   	push   %esi
80102079:	53                   	push   %ebx
8010207a:	83 ec 1c             	sub    $0x1c,%esp
8010207d:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX )
80102080:	3d ab 84 01 00       	cmp    $0x184ab,%eax
80102085:	77 59                	ja     801020e0 <swapread+0x70>
80102087:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
8010208d:	05 fc 01 00 00       	add    $0x1fc,%eax
80102092:	8b 75 08             	mov    0x8(%ebp),%esi
80102095:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209f:	90                   	nop
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		bp = bread(0, blkno + SWAPBASE + i);
801020a0:	83 ec 08             	sub    $0x8,%esp
801020a3:	57                   	push   %edi
801020a4:	83 c7 01             	add    $0x1,%edi
801020a7:	6a 00                	push   $0x0
801020a9:	e8 22 e0 ff ff       	call   801000d0 <bread>
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
801020ae:	83 c4 0c             	add    $0xc,%esp
		bp = bread(0, blkno + SWAPBASE + i);
801020b1:	89 c3                	mov    %eax,%ebx
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
801020b3:	8d 40 5c             	lea    0x5c(%eax),%eax
801020b6:	68 00 02 00 00       	push   $0x200
801020bb:	50                   	push   %eax
801020bc:	56                   	push   %esi
801020bd:	81 c6 00 02 00 00    	add    $0x200,%esi
801020c3:	e8 28 2a 00 00       	call   80104af0 <memmove>
		brelse(bp);
801020c8:	89 1c 24             	mov    %ebx,(%esp)
801020cb:	e8 20 e1 ff ff       	call   801001f0 <brelse>
	for ( i=0; i < 8; ++i ) {
801020d0:	83 c4 10             	add    $0x10,%esp
801020d3:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801020d6:	75 c8                	jne    801020a0 <swapread+0x30>
	}
}
801020d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020db:	5b                   	pop    %ebx
801020dc:	5e                   	pop    %esi
801020dd:	5f                   	pop    %edi
801020de:	5d                   	pop    %ebp
801020df:	c3                   	ret    
		panic("swapread: blkno exceed range");
801020e0:	83 ec 0c             	sub    $0xc,%esp
801020e3:	68 d5 77 10 80       	push   $0x801077d5
801020e8:	e8 a3 e2 ff ff       	call   80100390 <panic>
801020ed:	8d 76 00             	lea    0x0(%esi),%esi

801020f0 <swapwrite>:

void swapwrite(char* ptr, int blkno)
{
801020f0:	f3 0f 1e fb          	endbr32 
801020f4:	55                   	push   %ebp
801020f5:	89 e5                	mov    %esp,%ebp
801020f7:	57                   	push   %edi
801020f8:	56                   	push   %esi
801020f9:	53                   	push   %ebx
801020fa:	83 ec 1c             	sub    $0x1c,%esp
801020fd:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX )
80102100:	3d ab 84 01 00       	cmp    $0x184ab,%eax
80102105:	77 61                	ja     80102168 <swapwrite+0x78>
80102107:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
8010210d:	05 fc 01 00 00       	add    $0x1fc,%eax
80102112:	8b 75 08             	mov    0x8(%ebp),%esi
80102115:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211f:	90                   	nop
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		bp = bread(0, blkno + SWAPBASE + i);
80102120:	83 ec 08             	sub    $0x8,%esp
80102123:	57                   	push   %edi
80102124:	83 c7 01             	add    $0x1,%edi
80102127:	6a 00                	push   $0x0
80102129:	e8 a2 df ff ff       	call   801000d0 <bread>
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
8010212e:	83 c4 0c             	add    $0xc,%esp
		bp = bread(0, blkno + SWAPBASE + i);
80102131:	89 c3                	mov    %eax,%ebx
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
80102133:	8d 40 5c             	lea    0x5c(%eax),%eax
80102136:	68 00 02 00 00       	push   $0x200
8010213b:	56                   	push   %esi
8010213c:	81 c6 00 02 00 00    	add    $0x200,%esi
80102142:	50                   	push   %eax
80102143:	e8 a8 29 00 00       	call   80104af0 <memmove>
		bwrite(bp);
80102148:	89 1c 24             	mov    %ebx,(%esp)
8010214b:	e8 60 e0 ff ff       	call   801001b0 <bwrite>
		brelse(bp);
80102150:	89 1c 24             	mov    %ebx,(%esp)
80102153:	e8 98 e0 ff ff       	call   801001f0 <brelse>
	for ( i=0; i < 8; ++i ) {
80102158:	83 c4 10             	add    $0x10,%esp
8010215b:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
8010215e:	75 c0                	jne    80102120 <swapwrite+0x30>
	}
}
80102160:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102163:	5b                   	pop    %ebx
80102164:	5e                   	pop    %esi
80102165:	5f                   	pop    %edi
80102166:	5d                   	pop    %ebp
80102167:	c3                   	ret    
		panic("swapread: blkno exceed range");
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	68 d5 77 10 80       	push   $0x801077d5
80102170:	e8 1b e2 ff ff       	call   80100390 <panic>
80102175:	66 90                	xchg   %ax,%ax
80102177:	66 90                	xchg   %ax,%ax
80102179:	66 90                	xchg   %ax,%ax
8010217b:	66 90                	xchg   %ax,%ax
8010217d:	66 90                	xchg   %ax,%ax
8010217f:	90                   	nop

80102180 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	57                   	push   %edi
80102184:	56                   	push   %esi
80102185:	53                   	push   %ebx
80102186:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102189:	85 c0                	test   %eax,%eax
8010218b:	0f 84 b4 00 00 00    	je     80102245 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102191:	8b 70 08             	mov    0x8(%eax),%esi
80102194:	89 c3                	mov    %eax,%ebx
80102196:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010219c:	0f 87 96 00 00 00    	ja     80102238 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
801021b0:	89 ca                	mov    %ecx,%edx
801021b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021b3:	83 e0 c0             	and    $0xffffffc0,%eax
801021b6:	3c 40                	cmp    $0x40,%al
801021b8:	75 f6                	jne    801021b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021ba:	31 ff                	xor    %edi,%edi
801021bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021c1:	89 f8                	mov    %edi,%eax
801021c3:	ee                   	out    %al,(%dx)
801021c4:	b8 01 00 00 00       	mov    $0x1,%eax
801021c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021ce:	ee                   	out    %al,(%dx)
801021cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021d4:	89 f0                	mov    %esi,%eax
801021d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021d7:	89 f0                	mov    %esi,%eax
801021d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021de:	c1 f8 08             	sar    $0x8,%eax
801021e1:	ee                   	out    %al,(%dx)
801021e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021e7:	89 f8                	mov    %edi,%eax
801021e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021f3:	c1 e0 04             	shl    $0x4,%eax
801021f6:	83 e0 10             	and    $0x10,%eax
801021f9:	83 c8 e0             	or     $0xffffffe0,%eax
801021fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021fd:	f6 03 04             	testb  $0x4,(%ebx)
80102200:	75 16                	jne    80102218 <idestart+0x98>
80102202:	b8 20 00 00 00       	mov    $0x20,%eax
80102207:	89 ca                	mov    %ecx,%edx
80102209:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010220a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010220d:	5b                   	pop    %ebx
8010220e:	5e                   	pop    %esi
8010220f:	5f                   	pop    %edi
80102210:	5d                   	pop    %ebp
80102211:	c3                   	ret    
80102212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102218:	b8 30 00 00 00       	mov    $0x30,%eax
8010221d:	89 ca                	mov    %ecx,%edx
8010221f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102220:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102225:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102228:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010222d:	fc                   	cld    
8010222e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102230:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102233:	5b                   	pop    %ebx
80102234:	5e                   	pop    %esi
80102235:	5f                   	pop    %edi
80102236:	5d                   	pop    %ebp
80102237:	c3                   	ret    
    panic("incorrect blockno");
80102238:	83 ec 0c             	sub    $0xc,%esp
8010223b:	68 50 78 10 80       	push   $0x80107850
80102240:	e8 4b e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102245:	83 ec 0c             	sub    $0xc,%esp
80102248:	68 47 78 10 80       	push   $0x80107847
8010224d:	e8 3e e1 ff ff       	call   80100390 <panic>
80102252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideinit>:
{
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010226a:	68 62 78 10 80       	push   $0x80107862
8010226f:	68 80 b5 10 80       	push   $0x8010b580
80102274:	e8 47 25 00 00       	call   801047c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102279:	58                   	pop    %eax
8010227a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
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
801022ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
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
801022fd:	68 80 b5 10 80       	push   $0x8010b580
80102302:	e8 39 26 00 00       	call   80104940 <acquire>

  if((b = idequeue) == 0){
80102307:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 db                	test   %ebx,%ebx
80102312:	74 5f                	je     80102373 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102314:	8b 43 58             	mov    0x58(%ebx),%eax
80102317:	a3 64 b5 10 80       	mov    %eax,0x8010b564

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
8010235d:	e8 de 1e 00 00       	call   80104240 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102362:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102367:	83 c4 10             	add    $0x10,%esp
8010236a:	85 c0                	test   %eax,%eax
8010236c:	74 05                	je     80102373 <ideintr+0x83>
    idestart(idequeue);
8010236e:	e8 0d fe ff ff       	call   80102180 <idestart>
    release(&idelock);
80102373:	83 ec 0c             	sub    $0xc,%esp
80102376:	68 80 b5 10 80       	push   $0x8010b580
8010237b:	e8 80 26 00 00       	call   80104a00 <release>

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
801023a2:	e8 b9 23 00 00       	call   80104760 <holdingsleep>
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
801023c7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801023cc:	85 c0                	test   %eax,%eax
801023ce:	0f 84 93 00 00 00    	je     80102467 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 80 b5 10 80       	push   $0x8010b580
801023dc:	e8 5f 25 00 00       	call   80104940 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
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
80102406:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
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
80102423:	68 80 b5 10 80       	push   $0x8010b580
80102428:	53                   	push   %ebx
80102429:	e8 52 1c 00 00       	call   80104080 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 c4 10             	add    $0x10,%esp
80102433:	83 e0 06             	and    $0x6,%eax
80102436:	83 f8 02             	cmp    $0x2,%eax
80102439:	75 e5                	jne    80102420 <iderw+0x90>
  }


  release(&idelock);
8010243b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102445:	c9                   	leave  
  release(&idelock);
80102446:	e9 b5 25 00 00       	jmp    80104a00 <release>
8010244b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010244f:	90                   	nop
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 29 fd ff ff       	call   80102180 <idestart>
80102457:	eb b5                	jmp    8010240e <iderw+0x7e>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102465:	eb 9d                	jmp    80102404 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	68 91 78 10 80       	push   $0x80107891
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 7c 78 10 80       	push   $0x8010787c
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 66 78 10 80       	push   $0x80107866
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
80102495:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010249c:	00 c0 fe 
{
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	56                   	push   %esi
801024a2:	53                   	push   %ebx
  ioapic->reg = reg;
801024a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024aa:	00 00 00 
  return ioapic->data;
801024ad:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801024b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024bc:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024c2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
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
801024de:	68 b0 78 10 80       	push   $0x801078b0
801024e3:	e8 c8 e1 ff ff       	call   801006b0 <cprintf>
801024e8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102504:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
8010251e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102545:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102559:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102562:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102565:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102568:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010256a:	a1 34 36 11 80       	mov    0x80113634,%eax
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

80102580 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102580:	f3 0f 1e fb          	endbr32 
80102584:	55                   	push   %ebp
80102585:	89 e5                	mov    %esp,%ebp
80102587:	53                   	push   %ebx
80102588:	83 ec 04             	sub    $0x4,%esp
8010258b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010258e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102594:	75 7a                	jne    80102610 <kfree+0x90>
80102596:	81 fb a8 69 11 80    	cmp    $0x801169a8,%ebx
8010259c:	72 72                	jb     80102610 <kfree+0x90>
8010259e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025a9:	77 65                	ja     80102610 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025ab:	83 ec 04             	sub    $0x4,%esp
801025ae:	68 00 10 00 00       	push   $0x1000
801025b3:	6a 01                	push   $0x1
801025b5:	53                   	push   %ebx
801025b6:	e8 95 24 00 00       	call   80104a50 <memset>

  if(kmem.use_lock)
801025bb:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801025c1:	83 c4 10             	add    $0x10,%esp
801025c4:	85 d2                	test   %edx,%edx
801025c6:	75 20                	jne    801025e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025c8:	a1 78 36 11 80       	mov    0x80113678,%eax
801025cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025cf:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801025d4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801025da:	85 c0                	test   %eax,%eax
801025dc:	75 22                	jne    80102600 <kfree+0x80>
    release(&kmem.lock);
}
801025de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025e1:	c9                   	leave  
801025e2:	c3                   	ret    
801025e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025e7:	90                   	nop
    acquire(&kmem.lock);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	68 40 36 11 80       	push   $0x80113640
801025f0:	e8 4b 23 00 00       	call   80104940 <acquire>
801025f5:	83 c4 10             	add    $0x10,%esp
801025f8:	eb ce                	jmp    801025c8 <kfree+0x48>
801025fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102600:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010260a:	c9                   	leave  
    release(&kmem.lock);
8010260b:	e9 f0 23 00 00       	jmp    80104a00 <release>
    panic("kfree");
80102610:	83 ec 0c             	sub    $0xc,%esp
80102613:	68 e2 78 10 80       	push   $0x801078e2
80102618:	e8 73 dd ff ff       	call   80100390 <panic>
8010261d:	8d 76 00             	lea    0x0(%esi),%esi

80102620 <freerange>:
{
80102620:	f3 0f 1e fb          	endbr32 
80102624:	55                   	push   %ebp
80102625:	89 e5                	mov    %esp,%ebp
80102627:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102628:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010262b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010262e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010262f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102635:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102641:	39 de                	cmp    %ebx,%esi
80102643:	72 1f                	jb     80102664 <freerange+0x44>
80102645:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102651:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102657:	50                   	push   %eax
80102658:	e8 23 ff ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	39 f3                	cmp    %esi,%ebx
80102662:	76 e4                	jbe    80102648 <freerange+0x28>
}
80102664:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102667:	5b                   	pop    %ebx
80102668:	5e                   	pop    %esi
80102669:	5d                   	pop    %ebp
8010266a:	c3                   	ret    
8010266b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010266f:	90                   	nop

80102670 <kinit1>:
{
80102670:	f3 0f 1e fb          	endbr32 
80102674:	55                   	push   %ebp
80102675:	89 e5                	mov    %esp,%ebp
80102677:	56                   	push   %esi
80102678:	53                   	push   %ebx
80102679:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010267c:	83 ec 08             	sub    $0x8,%esp
8010267f:	68 e8 78 10 80       	push   $0x801078e8
80102684:	68 40 36 11 80       	push   $0x80113640
80102689:	e8 32 21 00 00       	call   801047c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102694:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010269b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010269e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026b0:	39 de                	cmp    %ebx,%esi
801026b2:	72 20                	jb     801026d4 <kinit1+0x64>
801026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026b8:	83 ec 0c             	sub    $0xc,%esp
801026bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026c7:	50                   	push   %eax
801026c8:	e8 b3 fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026cd:	83 c4 10             	add    $0x10,%esp
801026d0:	39 de                	cmp    %ebx,%esi
801026d2:	73 e4                	jae    801026b8 <kinit1+0x48>
}
801026d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d7:	5b                   	pop    %ebx
801026d8:	5e                   	pop    %esi
801026d9:	5d                   	pop    %ebp
801026da:	c3                   	ret    
801026db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026df:	90                   	nop

801026e0 <kinit2>:
{
801026e0:	f3 0f 1e fb          	endbr32 
801026e4:	55                   	push   %ebp
801026e5:	89 e5                	mov    %esp,%ebp
801026e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102701:	39 de                	cmp    %ebx,%esi
80102703:	72 1f                	jb     80102724 <kinit2+0x44>
80102705:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102711:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102717:	50                   	push   %eax
80102718:	e8 63 fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	39 de                	cmp    %ebx,%esi
80102722:	73 e4                	jae    80102708 <kinit2+0x28>
  kmem.use_lock = 1;
80102724:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010272b:	00 00 00 
}
8010272e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102731:	5b                   	pop    %ebx
80102732:	5e                   	pop    %esi
80102733:	5d                   	pop    %ebp
80102734:	c3                   	ret    
80102735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102740 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102740:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102744:	a1 74 36 11 80       	mov    0x80113674,%eax
80102749:	85 c0                	test   %eax,%eax
8010274b:	75 1b                	jne    80102768 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010274d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102752:	85 c0                	test   %eax,%eax
80102754:	74 0a                	je     80102760 <kalloc+0x20>
    kmem.freelist = r->next;
80102756:	8b 10                	mov    (%eax),%edx
80102758:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010275e:	c3                   	ret    
8010275f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102760:	c3                   	ret    
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102768:	55                   	push   %ebp
80102769:	89 e5                	mov    %esp,%ebp
8010276b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010276e:	68 40 36 11 80       	push   $0x80113640
80102773:	e8 c8 21 00 00       	call   80104940 <acquire>
  r = kmem.freelist;
80102778:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010277d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102783:	83 c4 10             	add    $0x10,%esp
80102786:	85 c0                	test   %eax,%eax
80102788:	74 08                	je     80102792 <kalloc+0x52>
    kmem.freelist = r->next;
8010278a:	8b 08                	mov    (%eax),%ecx
8010278c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102792:	85 d2                	test   %edx,%edx
80102794:	74 16                	je     801027ac <kalloc+0x6c>
    release(&kmem.lock);
80102796:	83 ec 0c             	sub    $0xc,%esp
80102799:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010279c:	68 40 36 11 80       	push   $0x80113640
801027a1:	e8 5a 22 00 00       	call   80104a00 <release>
  return (char*)r;
801027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027a9:	83 c4 10             	add    $0x10,%esp
}
801027ac:	c9                   	leave  
801027ad:	c3                   	ret    
801027ae:	66 90                	xchg   %ax,%ax

801027b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027b4:	ba 64 00 00 00       	mov    $0x64,%edx
801027b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027ba:	a8 01                	test   $0x1,%al
801027bc:	0f 84 be 00 00 00    	je     80102880 <kbdgetc+0xd0>
{
801027c2:	55                   	push   %ebp
801027c3:	ba 60 00 00 00       	mov    $0x60,%edx
801027c8:	89 e5                	mov    %esp,%ebp
801027ca:	53                   	push   %ebx
801027cb:	ec                   	in     (%dx),%al
  return data;
801027cc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801027d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801027d5:	3c e0                	cmp    $0xe0,%al
801027d7:	74 57                	je     80102830 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801027d9:	89 d9                	mov    %ebx,%ecx
801027db:	83 e1 40             	and    $0x40,%ecx
801027de:	84 c0                	test   %al,%al
801027e0:	78 5e                	js     80102840 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027e2:	85 c9                	test   %ecx,%ecx
801027e4:	74 09                	je     801027ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801027ef:	0f b6 8a 20 7a 10 80 	movzbl -0x7fef85e0(%edx),%ecx
  shift ^= togglecode[data];
801027f6:	0f b6 82 20 79 10 80 	movzbl -0x7fef86e0(%edx),%eax
  shift |= shiftcode[data];
801027fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801027ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102801:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102803:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102809:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010280c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010280f:	8b 04 85 00 79 10 80 	mov    -0x7fef8700(,%eax,4),%eax
80102816:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010281a:	74 0b                	je     80102827 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010281c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010281f:	83 fa 19             	cmp    $0x19,%edx
80102822:	77 44                	ja     80102868 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102824:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102827:	5b                   	pop    %ebx
80102828:	5d                   	pop    %ebp
80102829:	c3                   	ret    
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102830:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102833:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102835:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010283b:	5b                   	pop    %ebx
8010283c:	5d                   	pop    %ebp
8010283d:	c3                   	ret    
8010283e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102840:	83 e0 7f             	and    $0x7f,%eax
80102843:	85 c9                	test   %ecx,%ecx
80102845:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102848:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010284a:	0f b6 8a 20 7a 10 80 	movzbl -0x7fef85e0(%edx),%ecx
80102851:	83 c9 40             	or     $0x40,%ecx
80102854:	0f b6 c9             	movzbl %cl,%ecx
80102857:	f7 d1                	not    %ecx
80102859:	21 d9                	and    %ebx,%ecx
}
8010285b:	5b                   	pop    %ebx
8010285c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010285d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102863:	c3                   	ret    
80102864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102868:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010286b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010286e:	5b                   	pop    %ebx
8010286f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102870:	83 f9 1a             	cmp    $0x1a,%ecx
80102873:	0f 42 c2             	cmovb  %edx,%eax
}
80102876:	c3                   	ret    
80102877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287e:	66 90                	xchg   %ax,%ax
    return -1;
80102880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102885:	c3                   	ret    
80102886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288d:	8d 76 00             	lea    0x0(%esi),%esi

80102890 <kbdintr>:

void
kbdintr(void)
{
80102890:	f3 0f 1e fb          	endbr32 
80102894:	55                   	push   %ebp
80102895:	89 e5                	mov    %esp,%ebp
80102897:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010289a:	68 b0 27 10 80       	push   $0x801027b0
8010289f:	e8 bc df ff ff       	call   80100860 <consoleintr>
}
801028a4:	83 c4 10             	add    $0x10,%esp
801028a7:	c9                   	leave  
801028a8:	c3                   	ret    
801028a9:	66 90                	xchg   %ax,%ax
801028ab:	66 90                	xchg   %ax,%ax
801028ad:	66 90                	xchg   %ax,%ax
801028af:	90                   	nop

801028b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801028b4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	0f 84 c7 00 00 00    	je     80102988 <lapicinit+0xd8>
  lapic[index] = value;
801028c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102902:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102909:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010290c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010290f:	8b 50 30             	mov    0x30(%eax),%edx
80102912:	c1 ea 10             	shr    $0x10,%edx
80102915:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010291b:	75 73                	jne    80102990 <lapicinit+0xe0>
  lapic[index] = value;
8010291d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102924:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102927:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102931:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102934:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102937:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010293e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102941:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102944:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010294b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102951:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102958:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010295e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102965:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102968:	8b 50 20             	mov    0x20(%eax),%edx
8010296b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010296f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102970:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102976:	80 e6 10             	and    $0x10,%dh
80102979:	75 f5                	jne    80102970 <lapicinit+0xc0>
  lapic[index] = value;
8010297b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102982:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102985:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102988:	c3                   	ret    
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102990:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102997:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010299d:	e9 7b ff ff ff       	jmp    8010291d <lapicinit+0x6d>
801029a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029b0 <lapicid>:

int
lapicid(void)
{
801029b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801029b4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801029b9:	85 c0                	test   %eax,%eax
801029bb:	74 0b                	je     801029c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801029bd:	8b 40 20             	mov    0x20(%eax),%eax
801029c0:	c1 e8 18             	shr    $0x18,%eax
801029c3:	c3                   	ret    
801029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801029c8:	31 c0                	xor    %eax,%eax
}
801029ca:	c3                   	ret    
801029cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029cf:	90                   	nop

801029d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801029d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801029d4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801029d9:	85 c0                	test   %eax,%eax
801029db:	74 0d                	je     801029ea <lapiceoi+0x1a>
  lapic[index] = value;
801029dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029ea:	c3                   	ret    
801029eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop

801029f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801029f0:	f3 0f 1e fb          	endbr32 
}
801029f4:	c3                   	ret    
801029f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a00:	f3 0f 1e fb          	endbr32 
80102a04:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a05:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a0a:	ba 70 00 00 00       	mov    $0x70,%edx
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	53                   	push   %ebx
80102a12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a18:	ee                   	out    %al,(%dx)
80102a19:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1e:	ba 71 00 00 00       	mov    $0x71,%edx
80102a23:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a24:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a26:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a29:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a2f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a31:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a34:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a36:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a39:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a3c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a42:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102a47:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a4d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a50:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a57:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a5d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a64:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a67:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a6a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a70:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a73:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a79:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a7c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a82:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a85:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102a8b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102a8c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102a8f:	5d                   	pop    %ebp
80102a90:	c3                   	ret    
80102a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102aa0:	f3 0f 1e fb          	endbr32 
80102aa4:	55                   	push   %ebp
80102aa5:	b8 0b 00 00 00       	mov    $0xb,%eax
80102aaa:	ba 70 00 00 00       	mov    $0x70,%edx
80102aaf:	89 e5                	mov    %esp,%ebp
80102ab1:	57                   	push   %edi
80102ab2:	56                   	push   %esi
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 4c             	sub    $0x4c,%esp
80102ab7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab8:	ba 71 00 00 00       	mov    $0x71,%edx
80102abd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102abe:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac1:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ac6:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ad0:	31 c0                	xor    %eax,%eax
80102ad2:	89 da                	mov    %ebx,%edx
80102ad4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ada:	89 ca                	mov    %ecx,%edx
80102adc:	ec                   	in     (%dx),%al
80102add:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae0:	89 da                	mov    %ebx,%edx
80102ae2:	b8 02 00 00 00       	mov    $0x2,%eax
80102ae7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae8:	89 ca                	mov    %ecx,%edx
80102aea:	ec                   	in     (%dx),%al
80102aeb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aee:	89 da                	mov    %ebx,%edx
80102af0:	b8 04 00 00 00       	mov    $0x4,%eax
80102af5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af6:	89 ca                	mov    %ecx,%edx
80102af8:	ec                   	in     (%dx),%al
80102af9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afc:	89 da                	mov    %ebx,%edx
80102afe:	b8 07 00 00 00       	mov    $0x7,%eax
80102b03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b04:	89 ca                	mov    %ecx,%edx
80102b06:	ec                   	in     (%dx),%al
80102b07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0a:	89 da                	mov    %ebx,%edx
80102b0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102b11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b12:	89 ca                	mov    %ecx,%edx
80102b14:	ec                   	in     (%dx),%al
80102b15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b17:	89 da                	mov    %ebx,%edx
80102b19:	b8 09 00 00 00       	mov    $0x9,%eax
80102b1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1f:	89 ca                	mov    %ecx,%edx
80102b21:	ec                   	in     (%dx),%al
80102b22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b24:	89 da                	mov    %ebx,%edx
80102b26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2c:	89 ca                	mov    %ecx,%edx
80102b2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b2f:	84 c0                	test   %al,%al
80102b31:	78 9d                	js     80102ad0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102b33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b37:	89 fa                	mov    %edi,%edx
80102b39:	0f b6 fa             	movzbl %dl,%edi
80102b3c:	89 f2                	mov    %esi,%edx
80102b3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b48:	89 da                	mov    %ebx,%edx
80102b4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b61:	31 c0                	xor    %eax,%eax
80102b63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b64:	89 ca                	mov    %ecx,%edx
80102b66:	ec                   	in     (%dx),%al
80102b67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6a:	89 da                	mov    %ebx,%edx
80102b6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102b74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b75:	89 ca                	mov    %ecx,%edx
80102b77:	ec                   	in     (%dx),%al
80102b78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b7b:	89 da                	mov    %ebx,%edx
80102b7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b80:	b8 04 00 00 00       	mov    $0x4,%eax
80102b85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b86:	89 ca                	mov    %ecx,%edx
80102b88:	ec                   	in     (%dx),%al
80102b89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8c:	89 da                	mov    %ebx,%edx
80102b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b91:	b8 07 00 00 00       	mov    $0x7,%eax
80102b96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b97:	89 ca                	mov    %ecx,%edx
80102b99:	ec                   	in     (%dx),%al
80102b9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9d:	89 da                	mov    %ebx,%edx
80102b9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ba2:	b8 08 00 00 00       	mov    $0x8,%eax
80102ba7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba8:	89 ca                	mov    %ecx,%edx
80102baa:	ec                   	in     (%dx),%al
80102bab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bae:	89 da                	mov    %ebx,%edx
80102bb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102bb3:	b8 09 00 00 00       	mov    $0x9,%eax
80102bb8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb9:	89 ca                	mov    %ecx,%edx
80102bbb:	ec                   	in     (%dx),%al
80102bbc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bbf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bc5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102bc8:	6a 18                	push   $0x18
80102bca:	50                   	push   %eax
80102bcb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bce:	50                   	push   %eax
80102bcf:	e8 cc 1e 00 00       	call   80104aa0 <memcmp>
80102bd4:	83 c4 10             	add    $0x10,%esp
80102bd7:	85 c0                	test   %eax,%eax
80102bd9:	0f 85 f1 fe ff ff    	jne    80102ad0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102bdf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102be3:	75 78                	jne    80102c5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102be5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102be8:	89 c2                	mov    %eax,%edx
80102bea:	83 e0 0f             	and    $0xf,%eax
80102bed:	c1 ea 04             	shr    $0x4,%edx
80102bf0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bf9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bfc:	89 c2                	mov    %eax,%edx
80102bfe:	83 e0 0f             	and    $0xf,%eax
80102c01:	c1 ea 04             	shr    $0x4,%edx
80102c04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c10:	89 c2                	mov    %eax,%edx
80102c12:	83 e0 0f             	and    $0xf,%eax
80102c15:	c1 ea 04             	shr    $0x4,%edx
80102c18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c24:	89 c2                	mov    %eax,%edx
80102c26:	83 e0 0f             	and    $0xf,%eax
80102c29:	c1 ea 04             	shr    $0x4,%edx
80102c2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c38:	89 c2                	mov    %eax,%edx
80102c3a:	83 e0 0f             	and    $0xf,%eax
80102c3d:	c1 ea 04             	shr    $0x4,%edx
80102c40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c4c:	89 c2                	mov    %eax,%edx
80102c4e:	83 e0 0f             	and    $0xf,%eax
80102c51:	c1 ea 04             	shr    $0x4,%edx
80102c54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102c60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c63:	89 06                	mov    %eax,(%esi)
80102c65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c68:	89 46 04             	mov    %eax,0x4(%esi)
80102c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c6e:	89 46 08             	mov    %eax,0x8(%esi)
80102c71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c74:	89 46 0c             	mov    %eax,0xc(%esi)
80102c77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c7a:	89 46 10             	mov    %eax,0x10(%esi)
80102c7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c8d:	5b                   	pop    %ebx
80102c8e:	5e                   	pop    %esi
80102c8f:	5f                   	pop    %edi
80102c90:	5d                   	pop    %ebp
80102c91:	c3                   	ret    
80102c92:	66 90                	xchg   %ax,%ax
80102c94:	66 90                	xchg   %ax,%ax
80102c96:	66 90                	xchg   %ax,%ax
80102c98:	66 90                	xchg   %ax,%ax
80102c9a:	66 90                	xchg   %ax,%ax
80102c9c:	66 90                	xchg   %ax,%ax
80102c9e:	66 90                	xchg   %ax,%ax

80102ca0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ca0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102ca6:	85 c9                	test   %ecx,%ecx
80102ca8:	0f 8e 8a 00 00 00    	jle    80102d38 <install_trans+0x98>
{
80102cae:	55                   	push   %ebp
80102caf:	89 e5                	mov    %esp,%ebp
80102cb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb2:	31 ff                	xor    %edi,%edi
{
80102cb4:	56                   	push   %esi
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 0c             	sub    $0xc,%esp
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cc0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102cc5:	83 ec 08             	sub    $0x8,%esp
80102cc8:	01 f8                	add    %edi,%eax
80102cca:	83 c0 01             	add    $0x1,%eax
80102ccd:	50                   	push   %eax
80102cce:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
80102cd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cdb:	58                   	pop    %eax
80102cdc:	5a                   	pop    %edx
80102cdd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102ce4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ced:	e8 de d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cfa:	68 00 02 00 00       	push   $0x200
80102cff:	50                   	push   %eax
80102d00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d03:	50                   	push   %eax
80102d04:	e8 e7 1d 00 00       	call   80104af0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d09:	89 1c 24             	mov    %ebx,(%esp)
80102d0c:	e8 9f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d11:	89 34 24             	mov    %esi,(%esp)
80102d14:	e8 d7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d19:	89 1c 24             	mov    %ebx,(%esp)
80102d1c:	e8 cf d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d21:	83 c4 10             	add    $0x10,%esp
80102d24:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102d2a:	7f 94                	jg     80102cc0 <install_trans+0x20>
  }
}
80102d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2f:	5b                   	pop    %ebx
80102d30:	5e                   	pop    %esi
80102d31:	5f                   	pop    %edi
80102d32:	5d                   	pop    %ebp
80102d33:	c3                   	ret    
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d38:	c3                   	ret    
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d47:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102d4d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102d53:	e8 78 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d5d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102d62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d65:	85 c0                	test   %eax,%eax
80102d67:	7e 19                	jle    80102d82 <write_head+0x42>
80102d69:	31 d2                	xor    %edx,%edx
80102d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d70:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102d77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d7b:	83 c2 01             	add    $0x1,%edx
80102d7e:	39 d0                	cmp    %edx,%eax
80102d80:	75 ee                	jne    80102d70 <write_head+0x30>
  }
  bwrite(buf);
80102d82:	83 ec 0c             	sub    $0xc,%esp
80102d85:	53                   	push   %ebx
80102d86:	e8 25 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d8b:	89 1c 24             	mov    %ebx,(%esp)
80102d8e:	e8 5d d4 ff ff       	call   801001f0 <brelse>
}
80102d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d96:	83 c4 10             	add    $0x10,%esp
80102d99:	c9                   	leave  
80102d9a:	c3                   	ret    
80102d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d9f:	90                   	nop

80102da0 <initlog>:
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	53                   	push   %ebx
80102da8:	83 ec 2c             	sub    $0x2c,%esp
80102dab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dae:	68 20 7b 10 80       	push   $0x80107b20
80102db3:	68 80 36 11 80       	push   $0x80113680
80102db8:	e8 03 1a 00 00       	call   801047c0 <initlock>
  readsb(dev, &sb);
80102dbd:	58                   	pop    %eax
80102dbe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dc1:	5a                   	pop    %edx
80102dc2:	50                   	push   %eax
80102dc3:	53                   	push   %ebx
80102dc4:	e8 b7 e6 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80102dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102dcc:	59                   	pop    %ecx
  log.dev = dev;
80102dcd:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102dd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102dd6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102ddb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102de1:	5a                   	pop    %edx
80102de2:	50                   	push   %eax
80102de3:	53                   	push   %ebx
80102de4:	e8 e7 d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102dec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102def:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102df5:	85 c9                	test   %ecx,%ecx
80102df7:	7e 19                	jle    80102e12 <initlog+0x72>
80102df9:	31 d2                	xor    %edx,%edx
80102dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102e00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102e04:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e0b:	83 c2 01             	add    $0x1,%edx
80102e0e:	39 d1                	cmp    %edx,%ecx
80102e10:	75 ee                	jne    80102e00 <initlog+0x60>
  brelse(buf);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	50                   	push   %eax
80102e16:	e8 d5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e1b:	e8 80 fe ff ff       	call   80102ca0 <install_trans>
  log.lh.n = 0;
80102e20:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102e27:	00 00 00 
  write_head(); // clear the log
80102e2a:	e8 11 ff ff ff       	call   80102d40 <write_head>
}
80102e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e32:	83 c4 10             	add    $0x10,%esp
80102e35:	c9                   	leave  
80102e36:	c3                   	ret    
80102e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3e:	66 90                	xchg   %ax,%ax

80102e40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e40:	f3 0f 1e fb          	endbr32 
80102e44:	55                   	push   %ebp
80102e45:	89 e5                	mov    %esp,%ebp
80102e47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e4a:	68 80 36 11 80       	push   $0x80113680
80102e4f:	e8 ec 1a 00 00       	call   80104940 <acquire>
80102e54:	83 c4 10             	add    $0x10,%esp
80102e57:	eb 1c                	jmp    80102e75 <begin_op+0x35>
80102e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e60:	83 ec 08             	sub    $0x8,%esp
80102e63:	68 80 36 11 80       	push   $0x80113680
80102e68:	68 80 36 11 80       	push   $0x80113680
80102e6d:	e8 0e 12 00 00       	call   80104080 <sleep>
80102e72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e75:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102e7a:	85 c0                	test   %eax,%eax
80102e7c:	75 e2                	jne    80102e60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e7e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102e83:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102e89:	83 c0 01             	add    $0x1,%eax
80102e8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e92:	83 fa 1e             	cmp    $0x1e,%edx
80102e95:	7f c9                	jg     80102e60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e9a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102e9f:	68 80 36 11 80       	push   $0x80113680
80102ea4:	e8 57 1b 00 00       	call   80104a00 <release>
      break;
    }
  }
}
80102ea9:	83 c4 10             	add    $0x10,%esp
80102eac:	c9                   	leave  
80102ead:	c3                   	ret    
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102eb0:	f3 0f 1e fb          	endbr32 
80102eb4:	55                   	push   %ebp
80102eb5:	89 e5                	mov    %esp,%ebp
80102eb7:	57                   	push   %edi
80102eb8:	56                   	push   %esi
80102eb9:	53                   	push   %ebx
80102eba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ebd:	68 80 36 11 80       	push   $0x80113680
80102ec2:	e8 79 1a 00 00       	call   80104940 <acquire>
  log.outstanding -= 1;
80102ec7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102ecc:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102ed2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ed5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ed8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102ede:	85 f6                	test   %esi,%esi
80102ee0:	0f 85 1e 01 00 00    	jne    80103004 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ee6:	85 db                	test   %ebx,%ebx
80102ee8:	0f 85 f2 00 00 00    	jne    80102fe0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eee:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102ef5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ef8:	83 ec 0c             	sub    $0xc,%esp
80102efb:	68 80 36 11 80       	push   $0x80113680
80102f00:	e8 fb 1a 00 00       	call   80104a00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f05:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102f0b:	83 c4 10             	add    $0x10,%esp
80102f0e:	85 c9                	test   %ecx,%ecx
80102f10:	7f 3e                	jg     80102f50 <end_op+0xa0>
    acquire(&log.lock);
80102f12:	83 ec 0c             	sub    $0xc,%esp
80102f15:	68 80 36 11 80       	push   $0x80113680
80102f1a:	e8 21 1a 00 00       	call   80104940 <acquire>
    wakeup(&log);
80102f1f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102f26:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102f2d:	00 00 00 
    wakeup(&log);
80102f30:	e8 0b 13 00 00       	call   80104240 <wakeup>
    release(&log.lock);
80102f35:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102f3c:	e8 bf 1a 00 00       	call   80104a00 <release>
80102f41:	83 c4 10             	add    $0x10,%esp
}
80102f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f47:	5b                   	pop    %ebx
80102f48:	5e                   	pop    %esi
80102f49:	5f                   	pop    %edi
80102f4a:	5d                   	pop    %ebp
80102f4b:	c3                   	ret    
80102f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f50:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102f55:	83 ec 08             	sub    $0x8,%esp
80102f58:	01 d8                	add    %ebx,%eax
80102f5a:	83 c0 01             	add    $0x1,%eax
80102f5d:	50                   	push   %eax
80102f5e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102f64:	e8 67 d1 ff ff       	call   801000d0 <bread>
80102f69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f6b:	58                   	pop    %eax
80102f6c:	5a                   	pop    %edx
80102f6d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102f74:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f7d:	e8 4e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f8a:	68 00 02 00 00       	push   $0x200
80102f8f:	50                   	push   %eax
80102f90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f93:	50                   	push   %eax
80102f94:	e8 57 1b 00 00       	call   80104af0 <memmove>
    bwrite(to);  // write the log
80102f99:	89 34 24             	mov    %esi,(%esp)
80102f9c:	e8 0f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102fa1:	89 3c 24             	mov    %edi,(%esp)
80102fa4:	e8 47 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102fa9:	89 34 24             	mov    %esi,(%esp)
80102fac:	e8 3f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fb1:	83 c4 10             	add    $0x10,%esp
80102fb4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102fba:	7c 94                	jl     80102f50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fbc:	e8 7f fd ff ff       	call   80102d40 <write_head>
    install_trans(); // Now install writes to home locations
80102fc1:	e8 da fc ff ff       	call   80102ca0 <install_trans>
    log.lh.n = 0;
80102fc6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102fcd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fd0:	e8 6b fd ff ff       	call   80102d40 <write_head>
80102fd5:	e9 38 ff ff ff       	jmp    80102f12 <end_op+0x62>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fe0:	83 ec 0c             	sub    $0xc,%esp
80102fe3:	68 80 36 11 80       	push   $0x80113680
80102fe8:	e8 53 12 00 00       	call   80104240 <wakeup>
  release(&log.lock);
80102fed:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ff4:	e8 07 1a 00 00       	call   80104a00 <release>
80102ff9:	83 c4 10             	add    $0x10,%esp
}
80102ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fff:	5b                   	pop    %ebx
80103000:	5e                   	pop    %esi
80103001:	5f                   	pop    %edi
80103002:	5d                   	pop    %ebp
80103003:	c3                   	ret    
    panic("log.committing");
80103004:	83 ec 0c             	sub    $0xc,%esp
80103007:	68 24 7b 10 80       	push   $0x80107b24
8010300c:	e8 7f d3 ff ff       	call   80100390 <panic>
80103011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301f:	90                   	nop

80103020 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	53                   	push   %ebx
80103028:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010302b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80103031:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103034:	83 fa 1d             	cmp    $0x1d,%edx
80103037:	0f 8f 91 00 00 00    	jg     801030ce <log_write+0xae>
8010303d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80103042:	83 e8 01             	sub    $0x1,%eax
80103045:	39 c2                	cmp    %eax,%edx
80103047:	0f 8d 81 00 00 00    	jge    801030ce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010304d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80103052:	85 c0                	test   %eax,%eax
80103054:	0f 8e 81 00 00 00    	jle    801030db <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010305a:	83 ec 0c             	sub    $0xc,%esp
8010305d:	68 80 36 11 80       	push   $0x80113680
80103062:	e8 d9 18 00 00       	call   80104940 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103067:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
8010306d:	83 c4 10             	add    $0x10,%esp
80103070:	85 d2                	test   %edx,%edx
80103072:	7e 4e                	jle    801030c2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103074:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103077:	31 c0                	xor    %eax,%eax
80103079:	eb 0c                	jmp    80103087 <log_write+0x67>
8010307b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010307f:	90                   	nop
80103080:	83 c0 01             	add    $0x1,%eax
80103083:	39 c2                	cmp    %eax,%edx
80103085:	74 29                	je     801030b0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103087:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
8010308e:	75 f0                	jne    80103080 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103090:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103097:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010309a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010309d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
801030a4:	c9                   	leave  
  release(&log.lock);
801030a5:	e9 56 19 00 00       	jmp    80104a00 <release>
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
801030b7:	83 c2 01             	add    $0x1,%edx
801030ba:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
801030c0:	eb d5                	jmp    80103097 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801030c2:	8b 43 08             	mov    0x8(%ebx),%eax
801030c5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
801030ca:	75 cb                	jne    80103097 <log_write+0x77>
801030cc:	eb e9                	jmp    801030b7 <log_write+0x97>
    panic("too big a transaction");
801030ce:	83 ec 0c             	sub    $0xc,%esp
801030d1:	68 33 7b 10 80       	push   $0x80107b33
801030d6:	e8 b5 d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801030db:	83 ec 0c             	sub    $0xc,%esp
801030de:	68 49 7b 10 80       	push   $0x80107b49
801030e3:	e8 a8 d2 ff ff       	call   80100390 <panic>
801030e8:	66 90                	xchg   %ax,%ax
801030ea:	66 90                	xchg   %ax,%ax
801030ec:	66 90                	xchg   %ax,%ax
801030ee:	66 90                	xchg   %ax,%ax

801030f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	53                   	push   %ebx
801030f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030f7:	e8 84 09 00 00       	call   80103a80 <cpuid>
801030fc:	89 c3                	mov    %eax,%ebx
801030fe:	e8 7d 09 00 00       	call   80103a80 <cpuid>
80103103:	83 ec 04             	sub    $0x4,%esp
80103106:	53                   	push   %ebx
80103107:	50                   	push   %eax
80103108:	68 64 7b 10 80       	push   $0x80107b64
8010310d:	e8 9e d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103112:	e8 79 2d 00 00       	call   80105e90 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103117:	e8 f4 08 00 00       	call   80103a10 <mycpu>
8010311c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010311e:	b8 01 00 00 00       	mov    $0x1,%eax
80103123:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010312a:	e8 51 0c 00 00       	call   80103d80 <scheduler>
8010312f:	90                   	nop

80103130 <mpenter>:
{
80103130:	f3 0f 1e fb          	endbr32 
80103134:	55                   	push   %ebp
80103135:	89 e5                	mov    %esp,%ebp
80103137:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010313a:	e8 21 3e 00 00       	call   80106f60 <switchkvm>
  seginit();
8010313f:	e8 8c 3d 00 00       	call   80106ed0 <seginit>
  lapicinit();
80103144:	e8 67 f7 ff ff       	call   801028b0 <lapicinit>
  mpmain();
80103149:	e8 a2 ff ff ff       	call   801030f0 <mpmain>
8010314e:	66 90                	xchg   %ax,%ax

80103150 <main>:
{
80103150:	f3 0f 1e fb          	endbr32 
80103154:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103158:	83 e4 f0             	and    $0xfffffff0,%esp
8010315b:	ff 71 fc             	pushl  -0x4(%ecx)
8010315e:	55                   	push   %ebp
8010315f:	89 e5                	mov    %esp,%ebp
80103161:	53                   	push   %ebx
80103162:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103163:	83 ec 08             	sub    $0x8,%esp
80103166:	68 00 00 40 80       	push   $0x80400000
8010316b:	68 a8 69 11 80       	push   $0x801169a8
80103170:	e8 fb f4 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
80103175:	e8 c6 42 00 00       	call   80107440 <kvmalloc>
  mpinit();        // detect other processors
8010317a:	e8 81 01 00 00       	call   80103300 <mpinit>
  lapicinit();     // interrupt controller
8010317f:	e8 2c f7 ff ff       	call   801028b0 <lapicinit>
  seginit();       // segment descriptors
80103184:	e8 47 3d 00 00       	call   80106ed0 <seginit>
  picinit();       // disable pic
80103189:	e8 52 03 00 00       	call   801034e0 <picinit>
  ioapicinit();    // another interrupt controller
8010318e:	e8 fd f2 ff ff       	call   80102490 <ioapicinit>
  consoleinit();   // console hardware
80103193:	e8 98 d8 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103198:	e8 f3 2f 00 00       	call   80106190 <uartinit>
  pinit();         // process table
8010319d:	e8 4e 08 00 00       	call   801039f0 <pinit>
  tvinit();        // trap vectors
801031a2:	e8 69 2c 00 00       	call   80105e10 <tvinit>
  binit();         // buffer cache
801031a7:	e8 94 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031ac:	e8 2f dc ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801031b1:	e8 aa f0 ff ff       	call   80102260 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031b6:	83 c4 0c             	add    $0xc,%esp
801031b9:	68 8a 00 00 00       	push   $0x8a
801031be:	68 8c b4 10 80       	push   $0x8010b48c
801031c3:	68 00 70 00 80       	push   $0x80007000
801031c8:	e8 23 19 00 00       	call   80104af0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031cd:	83 c4 10             	add    $0x10,%esp
801031d0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801031d7:	00 00 00 
801031da:	05 80 37 11 80       	add    $0x80113780,%eax
801031df:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801031e4:	76 7a                	jbe    80103260 <main+0x110>
801031e6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801031eb:	eb 1c                	jmp    80103209 <main+0xb9>
801031ed:	8d 76 00             	lea    0x0(%esi),%esi
801031f0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801031f7:	00 00 00 
801031fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103200:	05 80 37 11 80       	add    $0x80113780,%eax
80103205:	39 c3                	cmp    %eax,%ebx
80103207:	73 57                	jae    80103260 <main+0x110>
    if(c == mycpu())  // We've started already.
80103209:	e8 02 08 00 00       	call   80103a10 <mycpu>
8010320e:	39 c3                	cmp    %eax,%ebx
80103210:	74 de                	je     801031f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103212:	e8 29 f5 ff ff       	call   80102740 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103217:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010321a:	c7 05 f8 6f 00 80 30 	movl   $0x80103130,0x80006ff8
80103221:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103224:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010322b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010322e:	05 00 10 00 00       	add    $0x1000,%eax
80103233:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103238:	0f b6 03             	movzbl (%ebx),%eax
8010323b:	68 00 70 00 00       	push   $0x7000
80103240:	50                   	push   %eax
80103241:	e8 ba f7 ff ff       	call   80102a00 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103246:	83 c4 10             	add    $0x10,%esp
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103250:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103256:	85 c0                	test   %eax,%eax
80103258:	74 f6                	je     80103250 <main+0x100>
8010325a:	eb 94                	jmp    801031f0 <main+0xa0>
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103260:	83 ec 08             	sub    $0x8,%esp
80103263:	68 00 00 00 8e       	push   $0x8e000000
80103268:	68 00 00 40 80       	push   $0x80400000
8010326d:	e8 6e f4 ff ff       	call   801026e0 <kinit2>
  userinit();      // first user process
80103272:	e8 59 08 00 00       	call   80103ad0 <userinit>
  mpmain();        // finish this processor's setup
80103277:	e8 74 fe ff ff       	call   801030f0 <mpmain>
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103285:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010328b:	53                   	push   %ebx
  e = addr+len;
8010328c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010328f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103292:	39 de                	cmp    %ebx,%esi
80103294:	72 10                	jb     801032a6 <mpsearch1+0x26>
80103296:	eb 50                	jmp    801032e8 <mpsearch1+0x68>
80103298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010329f:	90                   	nop
801032a0:	89 fe                	mov    %edi,%esi
801032a2:	39 fb                	cmp    %edi,%ebx
801032a4:	76 42                	jbe    801032e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032a6:	83 ec 04             	sub    $0x4,%esp
801032a9:	8d 7e 10             	lea    0x10(%esi),%edi
801032ac:	6a 04                	push   $0x4
801032ae:	68 78 7b 10 80       	push   $0x80107b78
801032b3:	56                   	push   %esi
801032b4:	e8 e7 17 00 00       	call   80104aa0 <memcmp>
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	85 c0                	test   %eax,%eax
801032be:	75 e0                	jne    801032a0 <mpsearch1+0x20>
801032c0:	89 f2                	mov    %esi,%edx
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 0a             	movzbl (%edx),%ecx
801032cb:	83 c2 01             	add    $0x1,%edx
801032ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032d0:	39 fa                	cmp    %edi,%edx
801032d2:	75 f4                	jne    801032c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032d4:	84 c0                	test   %al,%al
801032d6:	75 c8                	jne    801032a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032db:	89 f0                	mov    %esi,%eax
801032dd:	5b                   	pop    %ebx
801032de:	5e                   	pop    %esi
801032df:	5f                   	pop    %edi
801032e0:	5d                   	pop    %ebp
801032e1:	c3                   	ret    
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032eb:	31 f6                	xor    %esi,%esi
}
801032ed:	5b                   	pop    %ebx
801032ee:	89 f0                	mov    %esi,%eax
801032f0:	5e                   	pop    %esi
801032f1:	5f                   	pop    %edi
801032f2:	5d                   	pop    %ebp
801032f3:	c3                   	ret    
801032f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ff:	90                   	nop

80103300 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103300:	f3 0f 1e fb          	endbr32 
80103304:	55                   	push   %ebp
80103305:	89 e5                	mov    %esp,%ebp
80103307:	57                   	push   %edi
80103308:	56                   	push   %esi
80103309:	53                   	push   %ebx
8010330a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010330d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103314:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010331b:	c1 e0 08             	shl    $0x8,%eax
8010331e:	09 d0                	or     %edx,%eax
80103320:	c1 e0 04             	shl    $0x4,%eax
80103323:	75 1b                	jne    80103340 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103325:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010332c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103333:	c1 e0 08             	shl    $0x8,%eax
80103336:	09 d0                	or     %edx,%eax
80103338:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010333b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103340:	ba 00 04 00 00       	mov    $0x400,%edx
80103345:	e8 36 ff ff ff       	call   80103280 <mpsearch1>
8010334a:	89 c6                	mov    %eax,%esi
8010334c:	85 c0                	test   %eax,%eax
8010334e:	0f 84 4c 01 00 00    	je     801034a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103354:	8b 5e 04             	mov    0x4(%esi),%ebx
80103357:	85 db                	test   %ebx,%ebx
80103359:	0f 84 61 01 00 00    	je     801034c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010335f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103362:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103368:	6a 04                	push   $0x4
8010336a:	68 7d 7b 10 80       	push   $0x80107b7d
8010336f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103370:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103373:	e8 28 17 00 00       	call   80104aa0 <memcmp>
80103378:	83 c4 10             	add    $0x10,%esp
8010337b:	85 c0                	test   %eax,%eax
8010337d:	0f 85 3d 01 00 00    	jne    801034c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103383:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010338a:	3c 01                	cmp    $0x1,%al
8010338c:	74 08                	je     80103396 <mpinit+0x96>
8010338e:	3c 04                	cmp    $0x4,%al
80103390:	0f 85 2a 01 00 00    	jne    801034c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103396:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010339d:	66 85 d2             	test   %dx,%dx
801033a0:	74 26                	je     801033c8 <mpinit+0xc8>
801033a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801033a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801033a7:	31 d2                	xor    %edx,%edx
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801033b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801033b7:	83 c0 01             	add    $0x1,%eax
801033ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033bc:	39 f8                	cmp    %edi,%eax
801033be:	75 f0                	jne    801033b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801033c0:	84 d2                	test   %dl,%dl
801033c2:	0f 85 f8 00 00 00    	jne    801034c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801033ce:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801033d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801033e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801033e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801033eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033ef:	90                   	nop
801033f0:	39 c2                	cmp    %eax,%edx
801033f2:	76 15                	jbe    80103409 <mpinit+0x109>
    switch(*p){
801033f4:	0f b6 08             	movzbl (%eax),%ecx
801033f7:	80 f9 02             	cmp    $0x2,%cl
801033fa:	74 5c                	je     80103458 <mpinit+0x158>
801033fc:	77 42                	ja     80103440 <mpinit+0x140>
801033fe:	84 c9                	test   %cl,%cl
80103400:	74 6e                	je     80103470 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103402:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103405:	39 c2                	cmp    %eax,%edx
80103407:	77 eb                	ja     801033f4 <mpinit+0xf4>
80103409:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010340c:	85 db                	test   %ebx,%ebx
8010340e:	0f 84 b9 00 00 00    	je     801034cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103414:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103418:	74 15                	je     8010342f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010341a:	b8 70 00 00 00       	mov    $0x70,%eax
8010341f:	ba 22 00 00 00       	mov    $0x22,%edx
80103424:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103425:	ba 23 00 00 00       	mov    $0x23,%edx
8010342a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010342b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010342e:	ee                   	out    %al,(%dx)
  }
}
8010342f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103432:	5b                   	pop    %ebx
80103433:	5e                   	pop    %esi
80103434:	5f                   	pop    %edi
80103435:	5d                   	pop    %ebp
80103436:	c3                   	ret    
80103437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010343e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103440:	83 e9 03             	sub    $0x3,%ecx
80103443:	80 f9 01             	cmp    $0x1,%cl
80103446:	76 ba                	jbe    80103402 <mpinit+0x102>
80103448:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010344f:	eb 9f                	jmp    801033f0 <mpinit+0xf0>
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103458:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010345c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010345f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103465:	eb 89                	jmp    801033f0 <mpinit+0xf0>
80103467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010346e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103470:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103494:	83 c0 14             	add    $0x14,%eax
      continue;
80103497:	e9 54 ff ff ff       	jmp    801033f0 <mpinit+0xf0>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801034a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801034a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801034aa:	e8 d1 fd ff ff       	call   80103280 <mpsearch1>
801034af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034b1:	85 c0                	test   %eax,%eax
801034b3:	0f 85 9b fe ff ff    	jne    80103354 <mpinit+0x54>
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	68 82 7b 10 80       	push   $0x80107b82
801034c8:	e8 c3 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801034cd:	83 ec 0c             	sub    $0xc,%esp
801034d0:	68 9c 7b 10 80       	push   $0x80107b9c
801034d5:	e8 b6 ce ff ff       	call   80100390 <panic>
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <picinit>:
801034e0:	f3 0f 1e fb          	endbr32 
801034e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034e9:	ba 21 00 00 00       	mov    $0x21,%edx
801034ee:	ee                   	out    %al,(%dx)
801034ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801034f4:	ee                   	out    %al,(%dx)
801034f5:	c3                   	ret    
801034f6:	66 90                	xchg   %ax,%ax
801034f8:	66 90                	xchg   %ax,%ax
801034fa:	66 90                	xchg   %ax,%ax
801034fc:	66 90                	xchg   %ax,%ax
801034fe:	66 90                	xchg   %ax,%ax

80103500 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	57                   	push   %edi
80103508:	56                   	push   %esi
80103509:	53                   	push   %ebx
8010350a:	83 ec 0c             	sub    $0xc,%esp
8010350d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103510:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103513:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103519:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010351f:	e8 dc d8 ff ff       	call   80100e00 <filealloc>
80103524:	89 03                	mov    %eax,(%ebx)
80103526:	85 c0                	test   %eax,%eax
80103528:	0f 84 ac 00 00 00    	je     801035da <pipealloc+0xda>
8010352e:	e8 cd d8 ff ff       	call   80100e00 <filealloc>
80103533:	89 06                	mov    %eax,(%esi)
80103535:	85 c0                	test   %eax,%eax
80103537:	0f 84 8b 00 00 00    	je     801035c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010353d:	e8 fe f1 ff ff       	call   80102740 <kalloc>
80103542:	89 c7                	mov    %eax,%edi
80103544:	85 c0                	test   %eax,%eax
80103546:	0f 84 b4 00 00 00    	je     80103600 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010354c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103553:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103556:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103559:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103560:	00 00 00 
  p->nwrite = 0;
80103563:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010356a:	00 00 00 
  p->nread = 0;
8010356d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103574:	00 00 00 
  initlock(&p->lock, "pipe");
80103577:	68 bb 7b 10 80       	push   $0x80107bbb
8010357c:	50                   	push   %eax
8010357d:	e8 3e 12 00 00       	call   801047c0 <initlock>
  (*f0)->type = FD_PIPE;
80103582:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103584:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103587:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010358d:	8b 03                	mov    (%ebx),%eax
8010358f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103593:	8b 03                	mov    (%ebx),%eax
80103595:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103599:	8b 03                	mov    (%ebx),%eax
8010359b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010359e:	8b 06                	mov    (%esi),%eax
801035a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035a6:	8b 06                	mov    (%esi),%eax
801035a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035ac:	8b 06                	mov    (%esi),%eax
801035ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035b2:	8b 06                	mov    (%esi),%eax
801035b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035ba:	31 c0                	xor    %eax,%eax
}
801035bc:	5b                   	pop    %ebx
801035bd:	5e                   	pop    %esi
801035be:	5f                   	pop    %edi
801035bf:	5d                   	pop    %ebp
801035c0:	c3                   	ret    
801035c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801035c8:	8b 03                	mov    (%ebx),%eax
801035ca:	85 c0                	test   %eax,%eax
801035cc:	74 1e                	je     801035ec <pipealloc+0xec>
    fileclose(*f0);
801035ce:	83 ec 0c             	sub    $0xc,%esp
801035d1:	50                   	push   %eax
801035d2:	e8 e9 d8 ff ff       	call   80100ec0 <fileclose>
801035d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035da:	8b 06                	mov    (%esi),%eax
801035dc:	85 c0                	test   %eax,%eax
801035de:	74 0c                	je     801035ec <pipealloc+0xec>
    fileclose(*f1);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	50                   	push   %eax
801035e4:	e8 d7 d8 ff ff       	call   80100ec0 <fileclose>
801035e9:	83 c4 10             	add    $0x10,%esp
}
801035ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801035ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801035f4:	5b                   	pop    %ebx
801035f5:	5e                   	pop    %esi
801035f6:	5f                   	pop    %edi
801035f7:	5d                   	pop    %ebp
801035f8:	c3                   	ret    
801035f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103600:	8b 03                	mov    (%ebx),%eax
80103602:	85 c0                	test   %eax,%eax
80103604:	75 c8                	jne    801035ce <pipealloc+0xce>
80103606:	eb d2                	jmp    801035da <pipealloc+0xda>
80103608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010360f:	90                   	nop

80103610 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103610:	f3 0f 1e fb          	endbr32 
80103614:	55                   	push   %ebp
80103615:	89 e5                	mov    %esp,%ebp
80103617:	56                   	push   %esi
80103618:	53                   	push   %ebx
80103619:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010361c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010361f:	83 ec 0c             	sub    $0xc,%esp
80103622:	53                   	push   %ebx
80103623:	e8 18 13 00 00       	call   80104940 <acquire>
  if(writable){
80103628:	83 c4 10             	add    $0x10,%esp
8010362b:	85 f6                	test   %esi,%esi
8010362d:	74 41                	je     80103670 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010362f:	83 ec 0c             	sub    $0xc,%esp
80103632:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103638:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010363f:	00 00 00 
    wakeup(&p->nread);
80103642:	50                   	push   %eax
80103643:	e8 f8 0b 00 00       	call   80104240 <wakeup>
80103648:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010364b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103651:	85 d2                	test   %edx,%edx
80103653:	75 0a                	jne    8010365f <pipeclose+0x4f>
80103655:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010365b:	85 c0                	test   %eax,%eax
8010365d:	74 31                	je     80103690 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010365f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103662:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103665:	5b                   	pop    %ebx
80103666:	5e                   	pop    %esi
80103667:	5d                   	pop    %ebp
    release(&p->lock);
80103668:	e9 93 13 00 00       	jmp    80104a00 <release>
8010366d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103679:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103680:	00 00 00 
    wakeup(&p->nwrite);
80103683:	50                   	push   %eax
80103684:	e8 b7 0b 00 00       	call   80104240 <wakeup>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	eb bd                	jmp    8010364b <pipeclose+0x3b>
8010368e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	53                   	push   %ebx
80103694:	e8 67 13 00 00       	call   80104a00 <release>
    kfree((char*)p);
80103699:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010369c:	83 c4 10             	add    $0x10,%esp
}
8010369f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036a2:	5b                   	pop    %ebx
801036a3:	5e                   	pop    %esi
801036a4:	5d                   	pop    %ebp
    kfree((char*)p);
801036a5:	e9 d6 ee ff ff       	jmp    80102580 <kfree>
801036aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 28             	sub    $0x28,%esp
801036bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036c0:	53                   	push   %ebx
801036c1:	e8 7a 12 00 00       	call   80104940 <acquire>
  for(i = 0; i < n; i++){
801036c6:	8b 45 10             	mov    0x10(%ebp),%eax
801036c9:	83 c4 10             	add    $0x10,%esp
801036cc:	85 c0                	test   %eax,%eax
801036ce:	0f 8e bc 00 00 00    	jle    80103790 <pipewrite+0xe0>
801036d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801036d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801036e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036e6:	03 45 10             	add    0x10(%ebp),%eax
801036e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036f8:	89 ca                	mov    %ecx,%edx
801036fa:	05 00 02 00 00       	add    $0x200,%eax
801036ff:	39 c1                	cmp    %eax,%ecx
80103701:	74 3b                	je     8010373e <pipewrite+0x8e>
80103703:	eb 63                	jmp    80103768 <pipewrite+0xb8>
80103705:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103708:	e8 93 03 00 00       	call   80103aa0 <myproc>
8010370d:	8b 48 24             	mov    0x24(%eax),%ecx
80103710:	85 c9                	test   %ecx,%ecx
80103712:	75 34                	jne    80103748 <pipewrite+0x98>
      wakeup(&p->nread);
80103714:	83 ec 0c             	sub    $0xc,%esp
80103717:	57                   	push   %edi
80103718:	e8 23 0b 00 00       	call   80104240 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371d:	58                   	pop    %eax
8010371e:	5a                   	pop    %edx
8010371f:	53                   	push   %ebx
80103720:	56                   	push   %esi
80103721:	e8 5a 09 00 00       	call   80104080 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103726:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010372c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103732:	83 c4 10             	add    $0x10,%esp
80103735:	05 00 02 00 00       	add    $0x200,%eax
8010373a:	39 c2                	cmp    %eax,%edx
8010373c:	75 2a                	jne    80103768 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010373e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103744:	85 c0                	test   %eax,%eax
80103746:	75 c0                	jne    80103708 <pipewrite+0x58>
        release(&p->lock);
80103748:	83 ec 0c             	sub    $0xc,%esp
8010374b:	53                   	push   %ebx
8010374c:	e8 af 12 00 00       	call   80104a00 <release>
        return -1;
80103751:	83 c4 10             	add    $0x10,%esp
80103754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010375c:	5b                   	pop    %ebx
8010375d:	5e                   	pop    %esi
8010375e:	5f                   	pop    %edi
8010375f:	5d                   	pop    %ebp
80103760:	c3                   	ret    
80103761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103768:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010376b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010376e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103774:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010377a:	0f b6 06             	movzbl (%esi),%eax
8010377d:	83 c6 01             	add    $0x1,%esi
80103780:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103783:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103787:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010378a:	0f 85 5c ff ff ff    	jne    801036ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103799:	50                   	push   %eax
8010379a:	e8 a1 0a 00 00       	call   80104240 <wakeup>
  release(&p->lock);
8010379f:	89 1c 24             	mov    %ebx,(%esp)
801037a2:	e8 59 12 00 00       	call   80104a00 <release>
  return n;
801037a7:	8b 45 10             	mov    0x10(%ebp),%eax
801037aa:	83 c4 10             	add    $0x10,%esp
801037ad:	eb aa                	jmp    80103759 <pipewrite+0xa9>
801037af:	90                   	nop

801037b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037b0:	f3 0f 1e fb          	endbr32 
801037b4:	55                   	push   %ebp
801037b5:	89 e5                	mov    %esp,%ebp
801037b7:	57                   	push   %edi
801037b8:	56                   	push   %esi
801037b9:	53                   	push   %ebx
801037ba:	83 ec 18             	sub    $0x18,%esp
801037bd:	8b 75 08             	mov    0x8(%ebp),%esi
801037c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037c3:	56                   	push   %esi
801037c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037ca:	e8 71 11 00 00       	call   80104940 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801037de:	74 33                	je     80103813 <piperead+0x63>
801037e0:	eb 3b                	jmp    8010381d <piperead+0x6d>
801037e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801037e8:	e8 b3 02 00 00       	call   80103aa0 <myproc>
801037ed:	8b 48 24             	mov    0x24(%eax),%ecx
801037f0:	85 c9                	test   %ecx,%ecx
801037f2:	0f 85 88 00 00 00    	jne    80103880 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037f8:	83 ec 08             	sub    $0x8,%esp
801037fb:	56                   	push   %esi
801037fc:	53                   	push   %ebx
801037fd:	e8 7e 08 00 00       	call   80104080 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103802:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103808:	83 c4 10             	add    $0x10,%esp
8010380b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103811:	75 0a                	jne    8010381d <piperead+0x6d>
80103813:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103819:	85 c0                	test   %eax,%eax
8010381b:	75 cb                	jne    801037e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010381d:	8b 55 10             	mov    0x10(%ebp),%edx
80103820:	31 db                	xor    %ebx,%ebx
80103822:	85 d2                	test   %edx,%edx
80103824:	7f 28                	jg     8010384e <piperead+0x9e>
80103826:	eb 34                	jmp    8010385c <piperead+0xac>
80103828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103830:	8d 48 01             	lea    0x1(%eax),%ecx
80103833:	25 ff 01 00 00       	and    $0x1ff,%eax
80103838:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010383e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103843:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103846:	83 c3 01             	add    $0x1,%ebx
80103849:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010384c:	74 0e                	je     8010385c <piperead+0xac>
    if(p->nread == p->nwrite)
8010384e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103854:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010385a:	75 d4                	jne    80103830 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010385c:	83 ec 0c             	sub    $0xc,%esp
8010385f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103865:	50                   	push   %eax
80103866:	e8 d5 09 00 00       	call   80104240 <wakeup>
  release(&p->lock);
8010386b:	89 34 24             	mov    %esi,(%esp)
8010386e:	e8 8d 11 00 00       	call   80104a00 <release>
  return i;
80103873:	83 c4 10             	add    $0x10,%esp
}
80103876:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103879:	89 d8                	mov    %ebx,%eax
8010387b:	5b                   	pop    %ebx
8010387c:	5e                   	pop    %esi
8010387d:	5f                   	pop    %edi
8010387e:	5d                   	pop    %ebp
8010387f:	c3                   	ret    
      release(&p->lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103883:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103888:	56                   	push   %esi
80103889:	e8 72 11 00 00       	call   80104a00 <release>
      return -1;
8010388e:	83 c4 10             	add    $0x10,%esp
}
80103891:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103894:	89 d8                	mov    %ebx,%eax
80103896:	5b                   	pop    %ebx
80103897:	5e                   	pop    %esi
80103898:	5f                   	pop    %edi
80103899:	5d                   	pop    %ebp
8010389a:	c3                   	ret    
8010389b:	66 90                	xchg   %ax,%ax
8010389d:	66 90                	xchg   %ax,%ax
8010389f:	90                   	nop

801038a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038a4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801038a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038ac:	68 20 3d 11 80       	push   $0x80113d20
801038b1:	e8 8a 10 00 00       	call   80104940 <acquire>
801038b6:	83 c4 10             	add    $0x10,%esp
801038b9:	eb 17                	jmp    801038d2 <allocproc+0x32>
801038bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801038c6:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
801038cc:	0f 84 9e 00 00 00    	je     80103970 <allocproc+0xd0>
    if(p->state == UNUSED)
801038d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801038d5:	85 c0                	test   %eax,%eax
801038d7:	75 e7                	jne    801038c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038d9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->priority=5;
  p->starttime=ticks;
  p->runtime=0;
  p->endtime=0;

  release(&ptable.lock);
801038de:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority=5;
801038e8:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)
  p->pid = nextpid++;
801038ef:	8d 50 01             	lea    0x1(%eax),%edx
801038f2:	89 43 10             	mov    %eax,0x10(%ebx)
  p->starttime=ticks;
801038f5:	a1 a0 69 11 80       	mov    0x801169a0,%eax
  p->runtime=0;
801038fa:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103901:	00 00 00 
  p->starttime=ticks;
80103904:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  p->endtime=0;
8010390a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103911:	00 00 00 
  release(&ptable.lock);
80103914:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103919:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010391f:	e8 dc 10 00 00       	call   80104a00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103924:	e8 17 ee ff ff       	call   80102740 <kalloc>
80103929:	83 c4 10             	add    $0x10,%esp
8010392c:	89 43 08             	mov    %eax,0x8(%ebx)
8010392f:	85 c0                	test   %eax,%eax
80103931:	74 56                	je     80103989 <allocproc+0xe9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103933:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103939:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010393c:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103941:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103944:	c7 40 14 fb 5d 10 80 	movl   $0x80105dfb,0x14(%eax)
  p->context = (struct context*)sp;
8010394b:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010394e:	6a 14                	push   $0x14
80103950:	6a 00                	push   $0x0
80103952:	50                   	push   %eax
80103953:	e8 f8 10 00 00       	call   80104a50 <memset>
  p->context->eip = (uint)forkret;
80103958:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010395b:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010395e:	c7 40 10 a0 39 10 80 	movl   $0x801039a0,0x10(%eax)
}
80103965:	89 d8                	mov    %ebx,%eax
80103967:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010396a:	c9                   	leave  
8010396b:	c3                   	ret    
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103970:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103973:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103975:	68 20 3d 11 80       	push   $0x80113d20
8010397a:	e8 81 10 00 00       	call   80104a00 <release>
}
8010397f:	89 d8                	mov    %ebx,%eax
  return 0;
80103981:	83 c4 10             	add    $0x10,%esp
}
80103984:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103987:	c9                   	leave  
80103988:	c3                   	ret    
    p->state = UNUSED;
80103989:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103990:	31 db                	xor    %ebx,%ebx
}
80103992:	89 d8                	mov    %ebx,%eax
80103994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103997:	c9                   	leave  
80103998:	c3                   	ret    
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039a0:	f3 0f 1e fb          	endbr32 
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039aa:	68 20 3d 11 80       	push   $0x80113d20
801039af:	e8 4c 10 00 00       	call   80104a00 <release>

  if (first) {
801039b4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801039b9:	83 c4 10             	add    $0x10,%esp
801039bc:	85 c0                	test   %eax,%eax
801039be:	75 08                	jne    801039c8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039c0:	c9                   	leave  
801039c1:	c3                   	ret    
801039c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801039c8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801039cf:	00 00 00 
    iinit(ROOTDEV);
801039d2:	83 ec 0c             	sub    $0xc,%esp
801039d5:	6a 01                	push   $0x1
801039d7:	e8 64 db ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801039dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039e3:	e8 b8 f3 ff ff       	call   80102da0 <initlog>
}
801039e8:	83 c4 10             	add    $0x10,%esp
801039eb:	c9                   	leave  
801039ec:	c3                   	ret    
801039ed:	8d 76 00             	lea    0x0(%esi),%esi

801039f0 <pinit>:
{
801039f0:	f3 0f 1e fb          	endbr32 
801039f4:	55                   	push   %ebp
801039f5:	89 e5                	mov    %esp,%ebp
801039f7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039fa:	68 c0 7b 10 80       	push   $0x80107bc0
801039ff:	68 20 3d 11 80       	push   $0x80113d20
80103a04:	e8 b7 0d 00 00       	call   801047c0 <initlock>
}
80103a09:	83 c4 10             	add    $0x10,%esp
80103a0c:	c9                   	leave  
80103a0d:	c3                   	ret    
80103a0e:	66 90                	xchg   %ax,%ax

80103a10 <mycpu>:
{
80103a10:	f3 0f 1e fb          	endbr32 
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	56                   	push   %esi
80103a18:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a19:	9c                   	pushf  
80103a1a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a1b:	f6 c4 02             	test   $0x2,%ah
80103a1e:	75 4a                	jne    80103a6a <mycpu+0x5a>
  apicid = lapicid();
80103a20:	e8 8b ef ff ff       	call   801029b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a25:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
80103a2b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103a2d:	85 f6                	test   %esi,%esi
80103a2f:	7e 2c                	jle    80103a5d <mycpu+0x4d>
80103a31:	31 d2                	xor    %edx,%edx
80103a33:	eb 0a                	jmp    80103a3f <mycpu+0x2f>
80103a35:	8d 76 00             	lea    0x0(%esi),%esi
80103a38:	83 c2 01             	add    $0x1,%edx
80103a3b:	39 f2                	cmp    %esi,%edx
80103a3d:	74 1e                	je     80103a5d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103a3f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a45:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
80103a4c:	39 d8                	cmp    %ebx,%eax
80103a4e:	75 e8                	jne    80103a38 <mycpu+0x28>
}
80103a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a53:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
80103a59:	5b                   	pop    %ebx
80103a5a:	5e                   	pop    %esi
80103a5b:	5d                   	pop    %ebp
80103a5c:	c3                   	ret    
  panic("unknown apicid\n");
80103a5d:	83 ec 0c             	sub    $0xc,%esp
80103a60:	68 c7 7b 10 80       	push   $0x80107bc7
80103a65:	e8 26 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	68 e8 7c 10 80       	push   $0x80107ce8
80103a72:	e8 19 c9 ff ff       	call   80100390 <panic>
80103a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7e:	66 90                	xchg   %ax,%ax

80103a80 <cpuid>:
cpuid() {
80103a80:	f3 0f 1e fb          	endbr32 
80103a84:	55                   	push   %ebp
80103a85:	89 e5                	mov    %esp,%ebp
80103a87:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a8a:	e8 81 ff ff ff       	call   80103a10 <mycpu>
}
80103a8f:	c9                   	leave  
  return mycpu()-cpus;
80103a90:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103a95:	c1 f8 04             	sar    $0x4,%eax
80103a98:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a9e:	c3                   	ret    
80103a9f:	90                   	nop

80103aa0 <myproc>:
myproc(void) {
80103aa0:	f3 0f 1e fb          	endbr32 
80103aa4:	55                   	push   %ebp
80103aa5:	89 e5                	mov    %esp,%ebp
80103aa7:	53                   	push   %ebx
80103aa8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103aab:	e8 90 0d 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103ab0:	e8 5b ff ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80103ab5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103abb:	e8 d0 0d 00 00       	call   80104890 <popcli>
}
80103ac0:	83 c4 04             	add    $0x4,%esp
80103ac3:	89 d8                	mov    %ebx,%eax
80103ac5:	5b                   	pop    %ebx
80103ac6:	5d                   	pop    %ebp
80103ac7:	c3                   	ret    
80103ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103acf:	90                   	nop

80103ad0 <userinit>:
{
80103ad0:	f3 0f 1e fb          	endbr32 
80103ad4:	55                   	push   %ebp
80103ad5:	89 e5                	mov    %esp,%ebp
80103ad7:	53                   	push   %ebx
80103ad8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103adb:	e8 c0 fd ff ff       	call   801038a0 <allocproc>
80103ae0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103ae2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103ae7:	e8 d4 38 00 00       	call   801073c0 <setupkvm>
80103aec:	89 43 04             	mov    %eax,0x4(%ebx)
80103aef:	85 c0                	test   %eax,%eax
80103af1:	0f 84 d6 00 00 00    	je     80103bcd <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80103af7:	83 ec 04             	sub    $0x4,%esp
80103afa:	68 2c 00 00 00       	push   $0x2c
80103aff:	68 60 b4 10 80       	push   $0x8010b460
80103b04:	68 f0 7b 10 80       	push   $0x80107bf0
80103b09:	e8 a2 cb ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b0e:	83 c4 0c             	add    $0xc,%esp
80103b11:	68 2c 00 00 00       	push   $0x2c
80103b16:	68 60 b4 10 80       	push   $0x8010b460
80103b1b:	ff 73 04             	pushl  0x4(%ebx)
80103b1e:	e8 6d 35 00 00       	call   80107090 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b23:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b26:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b2c:	6a 4c                	push   $0x4c
80103b2e:	6a 00                	push   $0x0
80103b30:	ff 73 18             	pushl  0x18(%ebx)
80103b33:	e8 18 0f 00 00       	call   80104a50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b38:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b40:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b43:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b48:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b4f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b53:	8b 43 18             	mov    0x18(%ebx),%eax
80103b56:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b5a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b5e:	8b 43 18             	mov    0x18(%ebx),%eax
80103b61:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b65:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b69:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b73:	8b 43 18             	mov    0x18(%ebx),%eax
80103b76:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b7d:	8b 43 18             	mov    0x18(%ebx),%eax
80103b80:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b87:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b8a:	6a 10                	push   $0x10
80103b8c:	68 f7 7b 10 80       	push   $0x80107bf7
80103b91:	50                   	push   %eax
80103b92:	e8 79 10 00 00       	call   80104c10 <safestrcpy>
  p->cwd = namei("/");
80103b97:	c7 04 24 00 7c 10 80 	movl   $0x80107c00,(%esp)
80103b9e:	e8 8d e4 ff ff       	call   80102030 <namei>
80103ba3:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ba6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bad:	e8 8e 0d 00 00       	call   80104940 <acquire>
  p->state = RUNNABLE;
80103bb2:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bb9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bc0:	e8 3b 0e 00 00       	call   80104a00 <release>
}
80103bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc8:	83 c4 10             	add    $0x10,%esp
80103bcb:	c9                   	leave  
80103bcc:	c3                   	ret    
    panic("userinit: out of memory?");
80103bcd:	83 ec 0c             	sub    $0xc,%esp
80103bd0:	68 d7 7b 10 80       	push   $0x80107bd7
80103bd5:	e8 b6 c7 ff ff       	call   80100390 <panic>
80103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103be0 <growproc>:
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	56                   	push   %esi
80103be8:	53                   	push   %ebx
80103be9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bec:	e8 4f 0c 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103bf1:	e8 1a fe ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80103bf6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bfc:	e8 8f 0c 00 00       	call   80104890 <popcli>
  sz = curproc->sz;
80103c01:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c03:	85 f6                	test   %esi,%esi
80103c05:	7f 19                	jg     80103c20 <growproc+0x40>
  } else if(n < 0){
80103c07:	75 37                	jne    80103c40 <growproc+0x60>
  switchuvm(curproc);
80103c09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c0e:	53                   	push   %ebx
80103c0f:	e8 6c 33 00 00       	call   80106f80 <switchuvm>
  return 0;
80103c14:	83 c4 10             	add    $0x10,%esp
80103c17:	31 c0                	xor    %eax,%eax
}
80103c19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c1c:	5b                   	pop    %ebx
80103c1d:	5e                   	pop    %esi
80103c1e:	5d                   	pop    %ebp
80103c1f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c20:	83 ec 04             	sub    $0x4,%esp
80103c23:	01 c6                	add    %eax,%esi
80103c25:	56                   	push   %esi
80103c26:	50                   	push   %eax
80103c27:	ff 73 04             	pushl  0x4(%ebx)
80103c2a:	e8 b1 35 00 00       	call   801071e0 <allocuvm>
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 d3                	jne    80103c09 <growproc+0x29>
      return -1;
80103c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c3b:	eb dc                	jmp    80103c19 <growproc+0x39>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	pushl  0x4(%ebx)
80103c4a:	e8 c1 36 00 00       	call   80107310 <deallocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 b3                	jne    80103c09 <growproc+0x29>
80103c56:	eb de                	jmp    80103c36 <growproc+0x56>
80103c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <fork>:
{
80103c60:	f3 0f 1e fb          	endbr32 
80103c64:	55                   	push   %ebp
80103c65:	89 e5                	mov    %esp,%ebp
80103c67:	57                   	push   %edi
80103c68:	56                   	push   %esi
80103c69:	53                   	push   %ebx
80103c6a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c6d:	e8 ce 0b 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103c72:	e8 99 fd ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80103c77:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c7d:	e8 0e 0c 00 00       	call   80104890 <popcli>
  if((np = allocproc()) == 0){
80103c82:	e8 19 fc ff ff       	call   801038a0 <allocproc>
80103c87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c8a:	85 c0                	test   %eax,%eax
80103c8c:	0f 84 c1 00 00 00    	je     80103d53 <fork+0xf3>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c92:	83 ec 08             	sub    $0x8,%esp
80103c95:	ff 33                	pushl  (%ebx)
80103c97:	89 c7                	mov    %eax,%edi
80103c99:	ff 73 04             	pushl  0x4(%ebx)
80103c9c:	e8 ef 37 00 00       	call   80107490 <copyuvm>
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	89 47 04             	mov    %eax,0x4(%edi)
80103ca7:	85 c0                	test   %eax,%eax
80103ca9:	0f 84 ab 00 00 00    	je     80103d5a <fork+0xfa>
  np->sz = curproc->sz;
80103caf:	8b 03                	mov    (%ebx),%eax
80103cb1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cb4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103cb6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103cb9:	89 c8                	mov    %ecx,%eax
80103cbb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103cbe:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cc3:	8b 73 18             	mov    0x18(%ebx),%esi
80103cc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cc8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cca:	8b 40 18             	mov    0x18(%eax),%eax
80103ccd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103cd8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	74 13                	je     80103cf3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	50                   	push   %eax
80103ce4:	e8 87 d1 ff ff       	call   80100e70 <filedup>
80103ce9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cec:	83 c4 10             	add    $0x10,%esp
80103cef:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cf3:	83 c6 01             	add    $0x1,%esi
80103cf6:	83 fe 10             	cmp    $0x10,%esi
80103cf9:	75 dd                	jne    80103cd8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103cfb:	83 ec 0c             	sub    $0xc,%esp
80103cfe:	ff 73 68             	pushl  0x68(%ebx)
80103d01:	e8 2a da ff ff       	call   80101730 <idup>
80103d06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d09:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d0c:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d0f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d12:	6a 10                	push   $0x10
80103d14:	50                   	push   %eax
80103d15:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d18:	50                   	push   %eax
80103d19:	e8 f2 0e 00 00       	call   80104c10 <safestrcpy>
  pid = np->pid;
80103d1e:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103d21:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d28:	e8 13 0c 00 00       	call   80104940 <acquire>
  np->state = RUNNABLE;
80103d2d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->priority = curproc->priority;
80103d34:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103d37:	89 47 7c             	mov    %eax,0x7c(%edi)
  release(&ptable.lock);
80103d3a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d41:	e8 ba 0c 00 00       	call   80104a00 <release>
  return pid;
80103d46:	83 c4 10             	add    $0x10,%esp
}
80103d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d4c:	89 f0                	mov    %esi,%eax
80103d4e:	5b                   	pop    %ebx
80103d4f:	5e                   	pop    %esi
80103d50:	5f                   	pop    %edi
80103d51:	5d                   	pop    %ebp
80103d52:	c3                   	ret    
    return -1;
80103d53:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103d58:	eb ef                	jmp    80103d49 <fork+0xe9>
    kfree(np->kstack);
80103d5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d5d:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103d60:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103d65:	ff 73 08             	pushl  0x8(%ebx)
80103d68:	e8 13 e8 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80103d6d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d74:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d77:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d7e:	eb c9                	jmp    80103d49 <fork+0xe9>

80103d80 <scheduler>:
{
80103d80:	f3 0f 1e fb          	endbr32 
80103d84:	55                   	push   %ebp
80103d85:	89 e5                	mov    %esp,%ebp
80103d87:	57                   	push   %edi
80103d88:	56                   	push   %esi
80103d89:	53                   	push   %ebx
80103d8a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d8d:	e8 7e fc ff ff       	call   80103a10 <mycpu>
  c->proc = 0;
80103d92:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d99:	00 00 00 
  struct cpu *c = mycpu();
80103d9c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d9e:	8d 78 04             	lea    0x4(%eax),%edi
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103da8:	fb                   	sti    
    acquire(&ptable.lock);
80103da9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dac:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80103db1:	68 20 3d 11 80       	push   $0x80113d20
80103db6:	e8 85 0b 00 00       	call   80104940 <acquire>
80103dbb:	83 c4 10             	add    $0x10,%esp
80103dbe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103dc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103dc4:	75 33                	jne    80103df9 <scheduler+0x79>
      switchuvm(p);
80103dc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103dc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103dcf:	53                   	push   %ebx
80103dd0:	e8 ab 31 00 00       	call   80106f80 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103dd5:	58                   	pop    %eax
80103dd6:	5a                   	pop    %edx
80103dd7:	ff 73 1c             	pushl  0x1c(%ebx)
80103dda:	57                   	push   %edi
      p->state = RUNNING;
80103ddb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103de2:	e8 8c 0e 00 00       	call   80104c73 <swtch>
      switchkvm();
80103de7:	e8 74 31 00 00       	call   80106f60 <switchkvm>
      c->proc = 0;
80103dec:	83 c4 10             	add    $0x10,%esp
80103def:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103df6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df9:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103dff:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
80103e05:	75 b9                	jne    80103dc0 <scheduler+0x40>
    release(&ptable.lock);
80103e07:	83 ec 0c             	sub    $0xc,%esp
80103e0a:	68 20 3d 11 80       	push   $0x80113d20
80103e0f:	e8 ec 0b 00 00       	call   80104a00 <release>
    sti();
80103e14:	83 c4 10             	add    $0x10,%esp
80103e17:	eb 8f                	jmp    80103da8 <scheduler+0x28>
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e20 <sched>:
{
80103e20:	f3 0f 1e fb          	endbr32 
80103e24:	55                   	push   %ebp
80103e25:	89 e5                	mov    %esp,%ebp
80103e27:	56                   	push   %esi
80103e28:	53                   	push   %ebx
  pushcli();
80103e29:	e8 12 0a 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103e2e:	e8 dd fb ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80103e33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e39:	e8 52 0a 00 00       	call   80104890 <popcli>
  if(!holding(&ptable.lock))
80103e3e:	83 ec 0c             	sub    $0xc,%esp
80103e41:	68 20 3d 11 80       	push   $0x80113d20
80103e46:	e8 a5 0a 00 00       	call   801048f0 <holding>
80103e4b:	83 c4 10             	add    $0x10,%esp
80103e4e:	85 c0                	test   %eax,%eax
80103e50:	74 4f                	je     80103ea1 <sched+0x81>
  if(mycpu()->ncli != 1)
80103e52:	e8 b9 fb ff ff       	call   80103a10 <mycpu>
80103e57:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e5e:	75 68                	jne    80103ec8 <sched+0xa8>
  if(p->state == RUNNING)
80103e60:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e64:	74 55                	je     80103ebb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e66:	9c                   	pushf  
80103e67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e68:	f6 c4 02             	test   $0x2,%ah
80103e6b:	75 41                	jne    80103eae <sched+0x8e>
  intena = mycpu()->intena;
80103e6d:	e8 9e fb ff ff       	call   80103a10 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e72:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e75:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e7b:	e8 90 fb ff ff       	call   80103a10 <mycpu>
80103e80:	83 ec 08             	sub    $0x8,%esp
80103e83:	ff 70 04             	pushl  0x4(%eax)
80103e86:	53                   	push   %ebx
80103e87:	e8 e7 0d 00 00       	call   80104c73 <swtch>
  mycpu()->intena = intena;
80103e8c:	e8 7f fb ff ff       	call   80103a10 <mycpu>
}
80103e91:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e94:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e9d:	5b                   	pop    %ebx
80103e9e:	5e                   	pop    %esi
80103e9f:	5d                   	pop    %ebp
80103ea0:	c3                   	ret    
    panic("sched ptable.lock");
80103ea1:	83 ec 0c             	sub    $0xc,%esp
80103ea4:	68 02 7c 10 80       	push   $0x80107c02
80103ea9:	e8 e2 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103eae:	83 ec 0c             	sub    $0xc,%esp
80103eb1:	68 2e 7c 10 80       	push   $0x80107c2e
80103eb6:	e8 d5 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ebb:	83 ec 0c             	sub    $0xc,%esp
80103ebe:	68 20 7c 10 80       	push   $0x80107c20
80103ec3:	e8 c8 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ec8:	83 ec 0c             	sub    $0xc,%esp
80103ecb:	68 14 7c 10 80       	push   $0x80107c14
80103ed0:	e8 bb c4 ff ff       	call   80100390 <panic>
80103ed5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ee0 <exit>:
{
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	57                   	push   %edi
80103ee8:	56                   	push   %esi
80103ee9:	53                   	push   %ebx
80103eea:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103eed:	e8 4e 09 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103ef2:	e8 19 fb ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80103ef7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103efd:	e8 8e 09 00 00       	call   80104890 <popcli>
  if(curproc == initproc)
80103f02:	8d 73 28             	lea    0x28(%ebx),%esi
80103f05:	8d 7b 68             	lea    0x68(%ebx),%edi
80103f08:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80103f0e:	0f 84 0d 01 00 00    	je     80104021 <exit+0x141>
80103f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103f18:	8b 06                	mov    (%esi),%eax
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 12                	je     80103f30 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103f1e:	83 ec 0c             	sub    $0xc,%esp
80103f21:	50                   	push   %eax
80103f22:	e8 99 cf ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103f27:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f2d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f30:	83 c6 04             	add    $0x4,%esi
80103f33:	39 f7                	cmp    %esi,%edi
80103f35:	75 e1                	jne    80103f18 <exit+0x38>
  begin_op();
80103f37:	e8 04 ef ff ff       	call   80102e40 <begin_op>
  iput(curproc->cwd);
80103f3c:	83 ec 0c             	sub    $0xc,%esp
80103f3f:	ff 73 68             	pushl  0x68(%ebx)
80103f42:	e8 49 d9 ff ff       	call   80101890 <iput>
  end_op();
80103f47:	e8 64 ef ff ff       	call   80102eb0 <end_op>
  curproc->endtime=ticks;
80103f4c:	a1 a0 69 11 80       	mov    0x801169a0,%eax
  curproc->cwd = 0;
80103f51:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  curproc->endtime=ticks;
80103f58:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  acquire(&ptable.lock);
80103f5e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f65:	e8 d6 09 00 00       	call   80104940 <acquire>
  wakeup1(curproc->parent);
80103f6a:	8b 53 14             	mov    0x14(%ebx),%edx
80103f6d:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f70:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f75:	eb 15                	jmp    80103f8c <exit+0xac>
80103f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7e:	66 90                	xchg   %ax,%ax
80103f80:	05 90 00 00 00       	add    $0x90,%eax
80103f85:	3d 54 61 11 80       	cmp    $0x80116154,%eax
80103f8a:	74 1e                	je     80103faa <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
80103f8c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f90:	75 ee                	jne    80103f80 <exit+0xa0>
80103f92:	3b 50 20             	cmp    0x20(%eax),%edx
80103f95:	75 e9                	jne    80103f80 <exit+0xa0>
      p->state = RUNNABLE;
80103f97:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f9e:	05 90 00 00 00       	add    $0x90,%eax
80103fa3:	3d 54 61 11 80       	cmp    $0x80116154,%eax
80103fa8:	75 e2                	jne    80103f8c <exit+0xac>
      p->parent = initproc;
80103faa:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb0:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103fb5:	eb 17                	jmp    80103fce <exit+0xee>
80103fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbe:	66 90                	xchg   %ax,%ax
80103fc0:	81 c2 90 00 00 00    	add    $0x90,%edx
80103fc6:	81 fa 54 61 11 80    	cmp    $0x80116154,%edx
80103fcc:	74 3a                	je     80104008 <exit+0x128>
    if(p->parent == curproc){
80103fce:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103fd1:	75 ed                	jne    80103fc0 <exit+0xe0>
      if(p->state == ZOMBIE)
80103fd3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fd7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fda:	75 e4                	jne    80103fc0 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fdc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103fe1:	eb 11                	jmp    80103ff4 <exit+0x114>
80103fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe7:	90                   	nop
80103fe8:	05 90 00 00 00       	add    $0x90,%eax
80103fed:	3d 54 61 11 80       	cmp    $0x80116154,%eax
80103ff2:	74 cc                	je     80103fc0 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80103ff4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ff8:	75 ee                	jne    80103fe8 <exit+0x108>
80103ffa:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ffd:	75 e9                	jne    80103fe8 <exit+0x108>
      p->state = RUNNABLE;
80103fff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104006:	eb e0                	jmp    80103fe8 <exit+0x108>
  curproc->state = ZOMBIE;
80104008:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010400f:	e8 0c fe ff ff       	call   80103e20 <sched>
  panic("zombie exit");
80104014:	83 ec 0c             	sub    $0xc,%esp
80104017:	68 4f 7c 10 80       	push   $0x80107c4f
8010401c:	e8 6f c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104021:	83 ec 0c             	sub    $0xc,%esp
80104024:	68 42 7c 10 80       	push   $0x80107c42
80104029:	e8 62 c3 ff ff       	call   80100390 <panic>
8010402e:	66 90                	xchg   %ax,%ax

80104030 <yield>:
{
80104030:	f3 0f 1e fb          	endbr32 
80104034:	55                   	push   %ebp
80104035:	89 e5                	mov    %esp,%ebp
80104037:	53                   	push   %ebx
80104038:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010403b:	68 20 3d 11 80       	push   $0x80113d20
80104040:	e8 fb 08 00 00       	call   80104940 <acquire>
  pushcli();
80104045:	e8 f6 07 00 00       	call   80104840 <pushcli>
  c = mycpu();
8010404a:	e8 c1 f9 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
8010404f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104055:	e8 36 08 00 00       	call   80104890 <popcli>
  myproc()->state = RUNNABLE;
8010405a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104061:	e8 ba fd ff ff       	call   80103e20 <sched>
  release(&ptable.lock);
80104066:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010406d:	e8 8e 09 00 00       	call   80104a00 <release>
}
80104072:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104075:	83 c4 10             	add    $0x10,%esp
80104078:	c9                   	leave  
80104079:	c3                   	ret    
8010407a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104080 <sleep>:
{
80104080:	f3 0f 1e fb          	endbr32 
80104084:	55                   	push   %ebp
80104085:	89 e5                	mov    %esp,%ebp
80104087:	57                   	push   %edi
80104088:	56                   	push   %esi
80104089:	53                   	push   %ebx
8010408a:	83 ec 0c             	sub    $0xc,%esp
8010408d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104090:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104093:	e8 a8 07 00 00       	call   80104840 <pushcli>
  c = mycpu();
80104098:	e8 73 f9 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
8010409d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a3:	e8 e8 07 00 00       	call   80104890 <popcli>
  if(p == 0)
801040a8:	85 db                	test   %ebx,%ebx
801040aa:	0f 84 83 00 00 00    	je     80104133 <sleep+0xb3>
  if(lk == 0)
801040b0:	85 f6                	test   %esi,%esi
801040b2:	74 72                	je     80104126 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040b4:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801040ba:	74 4c                	je     80104108 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040bc:	83 ec 0c             	sub    $0xc,%esp
801040bf:	68 20 3d 11 80       	push   $0x80113d20
801040c4:	e8 77 08 00 00       	call   80104940 <acquire>
    release(lk);
801040c9:	89 34 24             	mov    %esi,(%esp)
801040cc:	e8 2f 09 00 00       	call   80104a00 <release>
  p->chan = chan;
801040d1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040d4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040db:	e8 40 fd ff ff       	call   80103e20 <sched>
  p->chan = 0;
801040e0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040e7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040ee:	e8 0d 09 00 00       	call   80104a00 <release>
    acquire(lk);
801040f3:	89 75 08             	mov    %esi,0x8(%ebp)
801040f6:	83 c4 10             	add    $0x10,%esp
}
801040f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040fc:	5b                   	pop    %ebx
801040fd:	5e                   	pop    %esi
801040fe:	5f                   	pop    %edi
801040ff:	5d                   	pop    %ebp
    acquire(lk);
80104100:	e9 3b 08 00 00       	jmp    80104940 <acquire>
80104105:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104108:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010410b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104112:	e8 09 fd ff ff       	call   80103e20 <sched>
  p->chan = 0;
80104117:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010411e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104121:	5b                   	pop    %ebx
80104122:	5e                   	pop    %esi
80104123:	5f                   	pop    %edi
80104124:	5d                   	pop    %ebp
80104125:	c3                   	ret    
    panic("sleep without lk");
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	68 61 7c 10 80       	push   $0x80107c61
8010412e:	e8 5d c2 ff ff       	call   80100390 <panic>
    panic("sleep");
80104133:	83 ec 0c             	sub    $0xc,%esp
80104136:	68 5b 7c 10 80       	push   $0x80107c5b
8010413b:	e8 50 c2 ff ff       	call   80100390 <panic>

80104140 <wait>:
{
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	56                   	push   %esi
80104148:	53                   	push   %ebx
  pushcli();
80104149:	e8 f2 06 00 00       	call   80104840 <pushcli>
  c = mycpu();
8010414e:	e8 bd f8 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80104153:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104159:	e8 32 07 00 00       	call   80104890 <popcli>
  acquire(&ptable.lock);
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	68 20 3d 11 80       	push   $0x80113d20
80104166:	e8 d5 07 00 00       	call   80104940 <acquire>
8010416b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010416e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104170:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104175:	eb 17                	jmp    8010418e <wait+0x4e>
80104177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417e:	66 90                	xchg   %ax,%ax
80104180:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104186:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
8010418c:	74 1e                	je     801041ac <wait+0x6c>
      if(p->parent != curproc)
8010418e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104191:	75 ed                	jne    80104180 <wait+0x40>
      if(p->state == ZOMBIE){
80104193:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104197:	74 37                	je     801041d0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104199:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
8010419f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a4:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
801041aa:	75 e2                	jne    8010418e <wait+0x4e>
    if(!havekids || curproc->killed){
801041ac:	85 c0                	test   %eax,%eax
801041ae:	74 76                	je     80104226 <wait+0xe6>
801041b0:	8b 46 24             	mov    0x24(%esi),%eax
801041b3:	85 c0                	test   %eax,%eax
801041b5:	75 6f                	jne    80104226 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801041b7:	83 ec 08             	sub    $0x8,%esp
801041ba:	68 20 3d 11 80       	push   $0x80113d20
801041bf:	56                   	push   %esi
801041c0:	e8 bb fe ff ff       	call   80104080 <sleep>
    havekids = 0;
801041c5:	83 c4 10             	add    $0x10,%esp
801041c8:	eb a4                	jmp    8010416e <wait+0x2e>
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801041d0:	83 ec 0c             	sub    $0xc,%esp
801041d3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801041d6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041d9:	e8 a2 e3 ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
801041de:	5a                   	pop    %edx
801041df:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801041e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041e9:	e8 52 31 00 00       	call   80107340 <freevm>
        release(&ptable.lock);
801041ee:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801041f5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041fc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104203:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104207:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010420e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104215:	e8 e6 07 00 00       	call   80104a00 <release>
        return pid;
8010421a:	83 c4 10             	add    $0x10,%esp
}
8010421d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104220:	89 f0                	mov    %esi,%eax
80104222:	5b                   	pop    %ebx
80104223:	5e                   	pop    %esi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret    
      release(&ptable.lock);
80104226:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104229:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010422e:	68 20 3d 11 80       	push   $0x80113d20
80104233:	e8 c8 07 00 00       	call   80104a00 <release>
      return -1;
80104238:	83 c4 10             	add    $0x10,%esp
8010423b:	eb e0                	jmp    8010421d <wait+0xdd>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi

80104240 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104240:	f3 0f 1e fb          	endbr32 
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
80104247:	53                   	push   %ebx
80104248:	83 ec 10             	sub    $0x10,%esp
8010424b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010424e:	68 20 3d 11 80       	push   $0x80113d20
80104253:	e8 e8 06 00 00       	call   80104940 <acquire>
80104258:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010425b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104260:	eb 12                	jmp    80104274 <wakeup+0x34>
80104262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104268:	05 90 00 00 00       	add    $0x90,%eax
8010426d:	3d 54 61 11 80       	cmp    $0x80116154,%eax
80104272:	74 1e                	je     80104292 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104274:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104278:	75 ee                	jne    80104268 <wakeup+0x28>
8010427a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010427d:	75 e9                	jne    80104268 <wakeup+0x28>
      p->state = RUNNABLE;
8010427f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104286:	05 90 00 00 00       	add    $0x90,%eax
8010428b:	3d 54 61 11 80       	cmp    $0x80116154,%eax
80104290:	75 e2                	jne    80104274 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104292:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104299:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010429c:	c9                   	leave  
  release(&ptable.lock);
8010429d:	e9 5e 07 00 00       	jmp    80104a00 <release>
801042a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	53                   	push   %ebx
801042b8:	83 ec 10             	sub    $0x10,%esp
801042bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042be:	68 20 3d 11 80       	push   $0x80113d20
801042c3:	e8 78 06 00 00       	call   80104940 <acquire>
801042c8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042cb:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801042d0:	eb 12                	jmp    801042e4 <kill+0x34>
801042d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042d8:	05 90 00 00 00       	add    $0x90,%eax
801042dd:	3d 54 61 11 80       	cmp    $0x80116154,%eax
801042e2:	74 34                	je     80104318 <kill+0x68>
    if(p->pid == pid){
801042e4:	39 58 10             	cmp    %ebx,0x10(%eax)
801042e7:	75 ef                	jne    801042d8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042e9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042ed:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042f4:	75 07                	jne    801042fd <kill+0x4d>
        p->state = RUNNABLE;
801042f6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042fd:	83 ec 0c             	sub    $0xc,%esp
80104300:	68 20 3d 11 80       	push   $0x80113d20
80104305:	e8 f6 06 00 00       	call   80104a00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010430a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010430d:	83 c4 10             	add    $0x10,%esp
80104310:	31 c0                	xor    %eax,%eax
}
80104312:	c9                   	leave  
80104313:	c3                   	ret    
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	68 20 3d 11 80       	push   $0x80113d20
80104320:	e8 db 06 00 00       	call   80104a00 <release>
}
80104325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104330:	c9                   	leave  
80104331:	c3                   	ret    
80104332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104340 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104340:	f3 0f 1e fb          	endbr32 
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	57                   	push   %edi
80104348:	56                   	push   %esi
80104349:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010434c:	53                   	push   %ebx
8010434d:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80104352:	83 ec 3c             	sub    $0x3c,%esp
80104355:	eb 2b                	jmp    80104382 <procdump+0x42>
80104357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104360:	83 ec 0c             	sub    $0xc,%esp
80104363:	68 cf 80 10 80       	push   $0x801080cf
80104368:	e8 43 c3 ff ff       	call   801006b0 <cprintf>
8010436d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104370:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104376:	81 fb c0 61 11 80    	cmp    $0x801161c0,%ebx
8010437c:	0f 84 8e 00 00 00    	je     80104410 <procdump+0xd0>
    if(p->state == UNUSED)
80104382:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104385:	85 c0                	test   %eax,%eax
80104387:	74 e7                	je     80104370 <procdump+0x30>
      state = "???";
80104389:	ba 72 7c 10 80       	mov    $0x80107c72,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010438e:	83 f8 05             	cmp    $0x5,%eax
80104391:	77 11                	ja     801043a4 <procdump+0x64>
80104393:	8b 14 85 a8 7d 10 80 	mov    -0x7fef8258(,%eax,4),%edx
      state = "???";
8010439a:	b8 72 7c 10 80       	mov    $0x80107c72,%eax
8010439f:	85 d2                	test   %edx,%edx
801043a1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801043a4:	53                   	push   %ebx
801043a5:	52                   	push   %edx
801043a6:	ff 73 a4             	pushl  -0x5c(%ebx)
801043a9:	68 76 7c 10 80       	push   $0x80107c76
801043ae:	e8 fd c2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801043b3:	83 c4 10             	add    $0x10,%esp
801043b6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801043ba:	75 a4                	jne    80104360 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043bc:	83 ec 08             	sub    $0x8,%esp
801043bf:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043c2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043c5:	50                   	push   %eax
801043c6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043c9:	8b 40 0c             	mov    0xc(%eax),%eax
801043cc:	83 c0 08             	add    $0x8,%eax
801043cf:	50                   	push   %eax
801043d0:	e8 0b 04 00 00       	call   801047e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043d5:	83 c4 10             	add    $0x10,%esp
801043d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043df:	90                   	nop
801043e0:	8b 17                	mov    (%edi),%edx
801043e2:	85 d2                	test   %edx,%edx
801043e4:	0f 84 76 ff ff ff    	je     80104360 <procdump+0x20>
        cprintf(" %p", pc[i]);
801043ea:	83 ec 08             	sub    $0x8,%esp
801043ed:	83 c7 04             	add    $0x4,%edi
801043f0:	52                   	push   %edx
801043f1:	68 a1 76 10 80       	push   $0x801076a1
801043f6:	e8 b5 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043fb:	83 c4 10             	add    $0x10,%esp
801043fe:	39 fe                	cmp    %edi,%esi
80104400:	75 de                	jne    801043e0 <procdump+0xa0>
80104402:	e9 59 ff ff ff       	jmp    80104360 <procdump+0x20>
80104407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440e:	66 90                	xchg   %ax,%ax
  }
}
80104410:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104413:	5b                   	pop    %ebx
80104414:	5e                   	pop    %esi
80104415:	5f                   	pop    %edi
80104416:	5d                   	pop    %ebp
80104417:	c3                   	ret    
80104418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441f:	90                   	nop

80104420 <setnice>:

// My code
int setnice(int pid, int nice){
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	53                   	push   %ebx
80104428:	83 ec 04             	sub    $0x4,%esp
8010442b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc* p;
	int success=0;
	if(pid<0||pid>10) return -1;
8010442e:	83 fb 0a             	cmp    $0xa,%ebx
80104431:	77 67                	ja     8010449a <setnice+0x7a>
	acquire(&ptable.lock);
80104433:	83 ec 0c             	sub    $0xc,%esp
80104436:	68 20 3d 11 80       	push   $0x80113d20
8010443b:	e8 00 05 00 00       	call   80104940 <acquire>
80104440:	83 c4 10             	add    $0x10,%esp
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
80104443:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104448:	eb 12                	jmp    8010445c <setnice+0x3c>
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104450:	05 90 00 00 00       	add    $0x90,%eax
80104455:	3d 54 61 11 80       	cmp    $0x80116154,%eax
8010445a:	74 24                	je     80104480 <setnice+0x60>
		if(p->pid==pid){
8010445c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010445f:	75 ef                	jne    80104450 <setnice+0x30>
			p->priority=nice;
80104461:	8b 55 0c             	mov    0xc(%ebp),%edx
			success=1;
			break;
		}
	}
	release(&ptable.lock);
80104464:	83 ec 0c             	sub    $0xc,%esp
			p->priority=nice;
80104467:	89 50 7c             	mov    %edx,0x7c(%eax)
	release(&ptable.lock);
8010446a:	68 20 3d 11 80       	push   $0x80113d20
8010446f:	e8 8c 05 00 00       	call   80104a00 <release>
80104474:	83 c4 10             	add    $0x10,%esp
//	cprintf("SETNICE returned %d\n",success);
	if(success) return 0;
80104477:	31 c0                	xor    %eax,%eax
	else return -1;
}
80104479:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010447c:	c9                   	leave  
8010447d:	c3                   	ret    
8010447e:	66 90                	xchg   %ax,%ax
	release(&ptable.lock);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	68 20 3d 11 80       	push   $0x80113d20
80104488:	e8 73 05 00 00       	call   80104a00 <release>
}
8010448d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	else return -1;
80104490:	83 c4 10             	add    $0x10,%esp
80104493:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104498:	c9                   	leave  
80104499:	c3                   	ret    
	if(pid<0||pid>10) return -1;
8010449a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010449f:	eb d8                	jmp    80104479 <setnice+0x59>
801044a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044af:	90                   	nop

801044b0 <getnice>:

int getnice(int pid){
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	57                   	push   %edi
	struct proc* p;
	int ret=0;
	int success=0;
801044b8:	31 ff                	xor    %edi,%edi
int getnice(int pid){
801044ba:	56                   	push   %esi
	int ret=0;
801044bb:	31 f6                	xor    %esi,%esi
int getnice(int pid){
801044bd:	53                   	push   %ebx
801044be:	83 ec 18             	sub    $0x18,%esp
801044c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
801044c4:	68 20 3d 11 80       	push   $0x80113d20
801044c9:	e8 72 04 00 00       	call   80104940 <acquire>
801044ce:	83 c4 10             	add    $0x10,%esp
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
801044d1:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801044d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044dd:	8d 76 00             	lea    0x0(%esi),%esi
		if(p->pid==pid){
801044e0:	39 58 10             	cmp    %ebx,0x10(%eax)
801044e3:	75 08                	jne    801044ed <getnice+0x3d>
			ret=p->priority;
801044e5:	8b 70 7c             	mov    0x7c(%eax),%esi
			success=1;
801044e8:	bf 01 00 00 00       	mov    $0x1,%edi
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
801044ed:	05 90 00 00 00       	add    $0x90,%eax
801044f2:	3d 54 61 11 80       	cmp    $0x80116154,%eax
801044f7:	75 e7                	jne    801044e0 <getnice+0x30>
		}
	}
	release(&ptable.lock);
801044f9:	83 ec 0c             	sub    $0xc,%esp
801044fc:	68 20 3d 11 80       	push   $0x80113d20
80104501:	e8 fa 04 00 00       	call   80104a00 <release>
//	cprintf("GETNICE returned %d with success %d\n",ret,success);
	if(success) return ret;
80104506:	83 c4 10             	add    $0x10,%esp
	else return -1;
80104509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010450e:	85 ff                	test   %edi,%edi
80104510:	0f 44 f0             	cmove  %eax,%esi
}
80104513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104516:	5b                   	pop    %ebx
80104517:	89 f0                	mov    %esi,%eax
80104519:	5e                   	pop    %esi
8010451a:	5f                   	pop    %edi
8010451b:	5d                   	pop    %ebp
8010451c:	c3                   	ret    
8010451d:	8d 76 00             	lea    0x0(%esi),%esi

80104520 <ps>:

void ps(){
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
80104527:	53                   	push   %ebx
80104528:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
8010452b:	fb                   	sti    
	struct proc* p;
	sti();
	acquire(&ptable.lock);
8010452c:	68 20 3d 11 80       	push   $0x80113d20
	p=ptable.proc;
80104531:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
	acquire(&ptable.lock);
80104536:	e8 05 04 00 00       	call   80104940 <acquire>
	cprintf("name \t pid \t state \t\t priority \t runtime \t tick: %d \n",ticks);
8010453b:	58                   	pop    %eax
8010453c:	5a                   	pop    %edx
8010453d:	ff 35 a0 69 11 80    	pushl  0x801169a0
80104543:	68 10 7d 10 80       	push   $0x80107d10
80104548:	e8 63 c1 ff ff       	call   801006b0 <cprintf>
8010454d:	83 c4 10             	add    $0x10,%esp
80104550:	eb 34                	jmp    80104586 <ps+0x66>
80104552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for(;p<&ptable.proc[NPROC];p++){
		if(p->state==SLEEPING){
			cprintf("%s \t %d \t SLEEPING \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
		}
		else if(p->state==RUNNING){
80104558:	83 f8 04             	cmp    $0x4,%eax
8010455b:	74 7b                	je     801045d8 <ps+0xb8>
			cprintf("%s \t %d \t RUNNING \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
		}
		else if(p->state==RUNNABLE){
8010455d:	83 f8 03             	cmp    $0x3,%eax
80104560:	0f 84 9a 00 00 00    	je     80104600 <ps+0xe0>
			cprintf("%s \t %d \t RUNNABLE \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
		}
//		else if(p->state==UNUSED){
//			cprintf("%s \t %d \t UNUSED \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
//		}
		else if(p->state==EMBRYO){
80104566:	83 f8 01             	cmp    $0x1,%eax
80104569:	0f 84 b9 00 00 00    	je     80104628 <ps+0x108>
			cprintf("%s \t %d \t EMBRYO \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
		}
		else if(p->state==ZOMBIE){
8010456f:	83 f8 05             	cmp    $0x5,%eax
80104572:	0f 84 d8 00 00 00    	je     80104650 <ps+0x130>
	for(;p<&ptable.proc[NPROC];p++){
80104578:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010457e:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
80104584:	74 36                	je     801045bc <ps+0x9c>
		if(p->state==SLEEPING){
80104586:	8b 43 0c             	mov    0xc(%ebx),%eax
80104589:	83 f8 02             	cmp    $0x2,%eax
8010458c:	75 ca                	jne    80104558 <ps+0x38>
			cprintf("%s \t %d \t SLEEPING \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
8010458e:	83 ec 0c             	sub    $0xc,%esp
80104591:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104594:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
	for(;p<&ptable.proc[NPROC];p++){
8010459a:	81 c3 90 00 00 00    	add    $0x90,%ebx
			cprintf("%s \t %d \t SLEEPING \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
801045a0:	ff 73 ec             	pushl  -0x14(%ebx)
801045a3:	ff 73 80             	pushl  -0x80(%ebx)
801045a6:	50                   	push   %eax
801045a7:	68 48 7d 10 80       	push   $0x80107d48
801045ac:	e8 ff c0 ff ff       	call   801006b0 <cprintf>
801045b1:	83 c4 20             	add    $0x20,%esp
	for(;p<&ptable.proc[NPROC];p++){
801045b4:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
801045ba:	75 ca                	jne    80104586 <ps+0x66>
			cprintf("%s \t %d \t ZOMBIE \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
		}
	}
//	cprintf("ps command ENDED\n");
	release(&ptable.lock);
801045bc:	83 ec 0c             	sub    $0xc,%esp
801045bf:	68 20 3d 11 80       	push   $0x80113d20
801045c4:	e8 37 04 00 00       	call   80104a00 <release>
	return;
}
801045c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	return;
801045cc:	83 c4 10             	add    $0x10,%esp
}
801045cf:	c9                   	leave  
801045d0:	c3                   	ret    
801045d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			cprintf("%s \t %d \t RUNNING \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	8d 43 6c             	lea    0x6c(%ebx),%eax
801045de:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
801045e4:	ff 73 7c             	pushl  0x7c(%ebx)
801045e7:	ff 73 10             	pushl  0x10(%ebx)
801045ea:	50                   	push   %eax
801045eb:	68 68 7d 10 80       	push   $0x80107d68
801045f0:	e8 bb c0 ff ff       	call   801006b0 <cprintf>
801045f5:	83 c4 20             	add    $0x20,%esp
801045f8:	e9 7b ff ff ff       	jmp    80104578 <ps+0x58>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
			cprintf("%s \t %d \t RUNNABLE \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
80104600:	83 ec 0c             	sub    $0xc,%esp
80104603:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104606:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
8010460c:	ff 73 7c             	pushl  0x7c(%ebx)
8010460f:	ff 73 10             	pushl  0x10(%ebx)
80104612:	50                   	push   %eax
80104613:	68 88 7d 10 80       	push   $0x80107d88
80104618:	e8 93 c0 ff ff       	call   801006b0 <cprintf>
8010461d:	83 c4 20             	add    $0x20,%esp
80104620:	e9 53 ff ff ff       	jmp    80104578 <ps+0x58>
80104625:	8d 76 00             	lea    0x0(%esi),%esi
			cprintf("%s \t %d \t EMBRYO \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010462e:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80104634:	ff 73 7c             	pushl  0x7c(%ebx)
80104637:	ff 73 10             	pushl  0x10(%ebx)
8010463a:	50                   	push   %eax
8010463b:	68 7f 7c 10 80       	push   $0x80107c7f
80104640:	e8 6b c0 ff ff       	call   801006b0 <cprintf>
80104645:	83 c4 20             	add    $0x20,%esp
80104648:	e9 2b ff ff ff       	jmp    80104578 <ps+0x58>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
			cprintf("%s \t %d \t ZOMBIE \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
80104650:	83 ec 0c             	sub    $0xc,%esp
80104653:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104656:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
8010465c:	ff 73 7c             	pushl  0x7c(%ebx)
8010465f:	ff 73 10             	pushl  0x10(%ebx)
80104662:	50                   	push   %eax
80104663:	68 9d 7c 10 80       	push   $0x80107c9d
80104668:	e8 43 c0 ff ff       	call   801006b0 <cprintf>
8010466d:	83 c4 20             	add    $0x20,%esp
80104670:	e9 03 ff ff ff       	jmp    80104578 <ps+0x58>
80104675:	66 90                	xchg   %ax,%ax
80104677:	66 90                	xchg   %ax,%ax
80104679:	66 90                	xchg   %ax,%ax
8010467b:	66 90                	xchg   %ax,%ax
8010467d:	66 90                	xchg   %ax,%ax
8010467f:	90                   	nop

80104680 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	53                   	push   %ebx
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010468e:	68 c0 7d 10 80       	push   $0x80107dc0
80104693:	8d 43 04             	lea    0x4(%ebx),%eax
80104696:	50                   	push   %eax
80104697:	e8 24 01 00 00       	call   801047c0 <initlock>
  lk->name = name;
8010469c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010469f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801046a5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801046a8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801046af:	89 43 38             	mov    %eax,0x38(%ebx)
}
801046b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b5:	c9                   	leave  
801046b6:	c3                   	ret    
801046b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046be:	66 90                	xchg   %ax,%ax

801046c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	56                   	push   %esi
801046c8:	53                   	push   %ebx
801046c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046cc:	8d 73 04             	lea    0x4(%ebx),%esi
801046cf:	83 ec 0c             	sub    $0xc,%esp
801046d2:	56                   	push   %esi
801046d3:	e8 68 02 00 00       	call   80104940 <acquire>
  while (lk->locked) {
801046d8:	8b 13                	mov    (%ebx),%edx
801046da:	83 c4 10             	add    $0x10,%esp
801046dd:	85 d2                	test   %edx,%edx
801046df:	74 1a                	je     801046fb <acquiresleep+0x3b>
801046e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801046e8:	83 ec 08             	sub    $0x8,%esp
801046eb:	56                   	push   %esi
801046ec:	53                   	push   %ebx
801046ed:	e8 8e f9 ff ff       	call   80104080 <sleep>
  while (lk->locked) {
801046f2:	8b 03                	mov    (%ebx),%eax
801046f4:	83 c4 10             	add    $0x10,%esp
801046f7:	85 c0                	test   %eax,%eax
801046f9:	75 ed                	jne    801046e8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801046fb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104701:	e8 9a f3 ff ff       	call   80103aa0 <myproc>
80104706:	8b 40 10             	mov    0x10(%eax),%eax
80104709:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010470c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010470f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104712:	5b                   	pop    %ebx
80104713:	5e                   	pop    %esi
80104714:	5d                   	pop    %ebp
  release(&lk->lk);
80104715:	e9 e6 02 00 00       	jmp    80104a00 <release>
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104720 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104720:	f3 0f 1e fb          	endbr32 
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
80104727:	56                   	push   %esi
80104728:	53                   	push   %ebx
80104729:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010472c:	8d 73 04             	lea    0x4(%ebx),%esi
8010472f:	83 ec 0c             	sub    $0xc,%esp
80104732:	56                   	push   %esi
80104733:	e8 08 02 00 00       	call   80104940 <acquire>
  lk->locked = 0;
80104738:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010473e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104745:	89 1c 24             	mov    %ebx,(%esp)
80104748:	e8 f3 fa ff ff       	call   80104240 <wakeup>
  release(&lk->lk);
8010474d:	89 75 08             	mov    %esi,0x8(%ebp)
80104750:	83 c4 10             	add    $0x10,%esp
}
80104753:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104756:	5b                   	pop    %ebx
80104757:	5e                   	pop    %esi
80104758:	5d                   	pop    %ebp
  release(&lk->lk);
80104759:	e9 a2 02 00 00       	jmp    80104a00 <release>
8010475e:	66 90                	xchg   %ax,%ax

80104760 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	57                   	push   %edi
80104768:	31 ff                	xor    %edi,%edi
8010476a:	56                   	push   %esi
8010476b:	53                   	push   %ebx
8010476c:	83 ec 18             	sub    $0x18,%esp
8010476f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104772:	8d 73 04             	lea    0x4(%ebx),%esi
80104775:	56                   	push   %esi
80104776:	e8 c5 01 00 00       	call   80104940 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010477b:	8b 03                	mov    (%ebx),%eax
8010477d:	83 c4 10             	add    $0x10,%esp
80104780:	85 c0                	test   %eax,%eax
80104782:	75 1c                	jne    801047a0 <holdingsleep+0x40>
  release(&lk->lk);
80104784:	83 ec 0c             	sub    $0xc,%esp
80104787:	56                   	push   %esi
80104788:	e8 73 02 00 00       	call   80104a00 <release>
  return r;
}
8010478d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104790:	89 f8                	mov    %edi,%eax
80104792:	5b                   	pop    %ebx
80104793:	5e                   	pop    %esi
80104794:	5f                   	pop    %edi
80104795:	5d                   	pop    %ebp
80104796:	c3                   	ret    
80104797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801047a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047a3:	e8 f8 f2 ff ff       	call   80103aa0 <myproc>
801047a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801047ab:	0f 94 c0             	sete   %al
801047ae:	0f b6 c0             	movzbl %al,%eax
801047b1:	89 c7                	mov    %eax,%edi
801047b3:	eb cf                	jmp    80104784 <holdingsleep+0x24>
801047b5:	66 90                	xchg   %ax,%ax
801047b7:	66 90                	xchg   %ax,%ax
801047b9:	66 90                	xchg   %ax,%ax
801047bb:	66 90                	xchg   %ax,%ax
801047bd:	66 90                	xchg   %ax,%ax
801047bf:	90                   	nop

801047c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801047d3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801047d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801047dd:	5d                   	pop    %ebp
801047de:	c3                   	ret    
801047df:	90                   	nop

801047e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047e5:	31 d2                	xor    %edx,%edx
{
801047e7:	89 e5                	mov    %esp,%ebp
801047e9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801047ea:	8b 45 08             	mov    0x8(%ebp),%eax
{
801047ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801047f0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801047f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047f8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104804:	77 1a                	ja     80104820 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104806:	8b 58 04             	mov    0x4(%eax),%ebx
80104809:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010480c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010480f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104811:	83 fa 0a             	cmp    $0xa,%edx
80104814:	75 e2                	jne    801047f8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104816:	5b                   	pop    %ebx
80104817:	5d                   	pop    %ebp
80104818:	c3                   	ret    
80104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104820:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104823:	8d 51 28             	lea    0x28(%ecx),%edx
80104826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104836:	83 c0 04             	add    $0x4,%eax
80104839:	39 d0                	cmp    %edx,%eax
8010483b:	75 f3                	jne    80104830 <getcallerpcs+0x50>
}
8010483d:	5b                   	pop    %ebx
8010483e:	5d                   	pop    %ebp
8010483f:	c3                   	ret    

80104840 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	53                   	push   %ebx
80104848:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010484b:	9c                   	pushf  
8010484c:	5b                   	pop    %ebx
  asm volatile("cli");
8010484d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010484e:	e8 bd f1 ff ff       	call   80103a10 <mycpu>
80104853:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104859:	85 c0                	test   %eax,%eax
8010485b:	74 13                	je     80104870 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010485d:	e8 ae f1 ff ff       	call   80103a10 <mycpu>
80104862:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104869:	83 c4 04             	add    $0x4,%esp
8010486c:	5b                   	pop    %ebx
8010486d:	5d                   	pop    %ebp
8010486e:	c3                   	ret    
8010486f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104870:	e8 9b f1 ff ff       	call   80103a10 <mycpu>
80104875:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010487b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104881:	eb da                	jmp    8010485d <pushcli+0x1d>
80104883:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <popcli>:

void
popcli(void)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010489a:	9c                   	pushf  
8010489b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010489c:	f6 c4 02             	test   $0x2,%ah
8010489f:	75 31                	jne    801048d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048a1:	e8 6a f1 ff ff       	call   80103a10 <mycpu>
801048a6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801048ad:	78 30                	js     801048df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048af:	e8 5c f1 ff ff       	call   80103a10 <mycpu>
801048b4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048ba:	85 d2                	test   %edx,%edx
801048bc:	74 02                	je     801048c0 <popcli+0x30>
    sti();
}
801048be:	c9                   	leave  
801048bf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048c0:	e8 4b f1 ff ff       	call   80103a10 <mycpu>
801048c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048cb:	85 c0                	test   %eax,%eax
801048cd:	74 ef                	je     801048be <popcli+0x2e>
  asm volatile("sti");
801048cf:	fb                   	sti    
}
801048d0:	c9                   	leave  
801048d1:	c3                   	ret    
    panic("popcli - interruptible");
801048d2:	83 ec 0c             	sub    $0xc,%esp
801048d5:	68 cb 7d 10 80       	push   $0x80107dcb
801048da:	e8 b1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
801048df:	83 ec 0c             	sub    $0xc,%esp
801048e2:	68 e2 7d 10 80       	push   $0x80107de2
801048e7:	e8 a4 ba ff ff       	call   80100390 <panic>
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <holding>:
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	56                   	push   %esi
801048f8:	53                   	push   %ebx
801048f9:	8b 75 08             	mov    0x8(%ebp),%esi
801048fc:	31 db                	xor    %ebx,%ebx
  pushcli();
801048fe:	e8 3d ff ff ff       	call   80104840 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104903:	8b 06                	mov    (%esi),%eax
80104905:	85 c0                	test   %eax,%eax
80104907:	75 0f                	jne    80104918 <holding+0x28>
  popcli();
80104909:	e8 82 ff ff ff       	call   80104890 <popcli>
}
8010490e:	89 d8                	mov    %ebx,%eax
80104910:	5b                   	pop    %ebx
80104911:	5e                   	pop    %esi
80104912:	5d                   	pop    %ebp
80104913:	c3                   	ret    
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104918:	8b 5e 08             	mov    0x8(%esi),%ebx
8010491b:	e8 f0 f0 ff ff       	call   80103a10 <mycpu>
80104920:	39 c3                	cmp    %eax,%ebx
80104922:	0f 94 c3             	sete   %bl
  popcli();
80104925:	e8 66 ff ff ff       	call   80104890 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010492a:	0f b6 db             	movzbl %bl,%ebx
}
8010492d:	89 d8                	mov    %ebx,%eax
8010492f:	5b                   	pop    %ebx
80104930:	5e                   	pop    %esi
80104931:	5d                   	pop    %ebp
80104932:	c3                   	ret    
80104933:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104940 <acquire>:
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	56                   	push   %esi
80104948:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104949:	e8 f2 fe ff ff       	call   80104840 <pushcli>
  if(holding(lk))
8010494e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104951:	83 ec 0c             	sub    $0xc,%esp
80104954:	53                   	push   %ebx
80104955:	e8 96 ff ff ff       	call   801048f0 <holding>
8010495a:	83 c4 10             	add    $0x10,%esp
8010495d:	85 c0                	test   %eax,%eax
8010495f:	0f 85 7f 00 00 00    	jne    801049e4 <acquire+0xa4>
80104965:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104967:	ba 01 00 00 00       	mov    $0x1,%edx
8010496c:	eb 05                	jmp    80104973 <acquire+0x33>
8010496e:	66 90                	xchg   %ax,%ax
80104970:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104973:	89 d0                	mov    %edx,%eax
80104975:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104978:	85 c0                	test   %eax,%eax
8010497a:	75 f4                	jne    80104970 <acquire+0x30>
  __sync_synchronize();
8010497c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104981:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104984:	e8 87 f0 ff ff       	call   80103a10 <mycpu>
80104989:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010498c:	89 e8                	mov    %ebp,%eax
8010498e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104990:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104996:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010499c:	77 22                	ja     801049c0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010499e:	8b 50 04             	mov    0x4(%eax),%edx
801049a1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801049a5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801049a8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049aa:	83 fe 0a             	cmp    $0xa,%esi
801049ad:	75 e1                	jne    80104990 <acquire+0x50>
}
801049af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b2:	5b                   	pop    %ebx
801049b3:	5e                   	pop    %esi
801049b4:	5d                   	pop    %ebp
801049b5:	c3                   	ret    
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801049c0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801049c4:	83 c3 34             	add    $0x34,%ebx
801049c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801049d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049d6:	83 c0 04             	add    $0x4,%eax
801049d9:	39 d8                	cmp    %ebx,%eax
801049db:	75 f3                	jne    801049d0 <acquire+0x90>
}
801049dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049e0:	5b                   	pop    %ebx
801049e1:	5e                   	pop    %esi
801049e2:	5d                   	pop    %ebp
801049e3:	c3                   	ret    
    panic("acquire");
801049e4:	83 ec 0c             	sub    $0xc,%esp
801049e7:	68 e9 7d 10 80       	push   $0x80107de9
801049ec:	e8 9f b9 ff ff       	call   80100390 <panic>
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ff:	90                   	nop

80104a00 <release>:
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	53                   	push   %ebx
80104a08:	83 ec 10             	sub    $0x10,%esp
80104a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a0e:	53                   	push   %ebx
80104a0f:	e8 dc fe ff ff       	call   801048f0 <holding>
80104a14:	83 c4 10             	add    $0x10,%esp
80104a17:	85 c0                	test   %eax,%eax
80104a19:	74 22                	je     80104a3d <release+0x3d>
  lk->pcs[0] = 0;
80104a1b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a22:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a29:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a2e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a37:	c9                   	leave  
  popcli();
80104a38:	e9 53 fe ff ff       	jmp    80104890 <popcli>
    panic("release");
80104a3d:	83 ec 0c             	sub    $0xc,%esp
80104a40:	68 f1 7d 10 80       	push   $0x80107df1
80104a45:	e8 46 b9 ff ff       	call   80100390 <panic>
80104a4a:	66 90                	xchg   %ax,%ax
80104a4c:	66 90                	xchg   %ax,%ax
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <memset>:
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	57                   	push   %edi
80104a58:	8b 55 08             	mov    0x8(%ebp),%edx
80104a5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a5e:	53                   	push   %ebx
80104a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a62:	89 d7                	mov    %edx,%edi
80104a64:	09 cf                	or     %ecx,%edi
80104a66:	83 e7 03             	and    $0x3,%edi
80104a69:	75 25                	jne    80104a90 <memset+0x40>
80104a6b:	0f b6 f8             	movzbl %al,%edi
80104a6e:	c1 e0 18             	shl    $0x18,%eax
80104a71:	89 fb                	mov    %edi,%ebx
80104a73:	c1 e9 02             	shr    $0x2,%ecx
80104a76:	c1 e3 10             	shl    $0x10,%ebx
80104a79:	09 d8                	or     %ebx,%eax
80104a7b:	09 f8                	or     %edi,%eax
80104a7d:	c1 e7 08             	shl    $0x8,%edi
80104a80:	09 f8                	or     %edi,%eax
80104a82:	89 d7                	mov    %edx,%edi
80104a84:	fc                   	cld    
80104a85:	f3 ab                	rep stos %eax,%es:(%edi)
80104a87:	5b                   	pop    %ebx
80104a88:	89 d0                	mov    %edx,%eax
80104a8a:	5f                   	pop    %edi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret    
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
80104a90:	89 d7                	mov    %edx,%edi
80104a92:	fc                   	cld    
80104a93:	f3 aa                	rep stos %al,%es:(%edi)
80104a95:	5b                   	pop    %ebx
80104a96:	89 d0                	mov    %edx,%eax
80104a98:	5f                   	pop    %edi
80104a99:	5d                   	pop    %ebp
80104a9a:	c3                   	ret    
80104a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop

80104aa0 <memcmp>:
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	56                   	push   %esi
80104aa8:	8b 75 10             	mov    0x10(%ebp),%esi
80104aab:	8b 55 08             	mov    0x8(%ebp),%edx
80104aae:	53                   	push   %ebx
80104aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ab2:	85 f6                	test   %esi,%esi
80104ab4:	74 2a                	je     80104ae0 <memcmp+0x40>
80104ab6:	01 c6                	add    %eax,%esi
80104ab8:	eb 10                	jmp    80104aca <memcmp+0x2a>
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac0:	83 c0 01             	add    $0x1,%eax
80104ac3:	83 c2 01             	add    $0x1,%edx
80104ac6:	39 f0                	cmp    %esi,%eax
80104ac8:	74 16                	je     80104ae0 <memcmp+0x40>
80104aca:	0f b6 0a             	movzbl (%edx),%ecx
80104acd:	0f b6 18             	movzbl (%eax),%ebx
80104ad0:	38 d9                	cmp    %bl,%cl
80104ad2:	74 ec                	je     80104ac0 <memcmp+0x20>
80104ad4:	0f b6 c1             	movzbl %cl,%eax
80104ad7:	29 d8                	sub    %ebx,%eax
80104ad9:	5b                   	pop    %ebx
80104ada:	5e                   	pop    %esi
80104adb:	5d                   	pop    %ebp
80104adc:	c3                   	ret    
80104add:	8d 76 00             	lea    0x0(%esi),%esi
80104ae0:	5b                   	pop    %ebx
80104ae1:	31 c0                	xor    %eax,%eax
80104ae3:	5e                   	pop    %esi
80104ae4:	5d                   	pop    %ebp
80104ae5:	c3                   	ret    
80104ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aed:	8d 76 00             	lea    0x0(%esi),%esi

80104af0 <memmove>:
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	57                   	push   %edi
80104af8:	8b 55 08             	mov    0x8(%ebp),%edx
80104afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104afe:	56                   	push   %esi
80104aff:	8b 75 0c             	mov    0xc(%ebp),%esi
80104b02:	39 d6                	cmp    %edx,%esi
80104b04:	73 2a                	jae    80104b30 <memmove+0x40>
80104b06:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104b09:	39 fa                	cmp    %edi,%edx
80104b0b:	73 23                	jae    80104b30 <memmove+0x40>
80104b0d:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104b10:	85 c9                	test   %ecx,%ecx
80104b12:	74 13                	je     80104b27 <memmove+0x37>
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b18:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104b1c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104b1f:	83 e8 01             	sub    $0x1,%eax
80104b22:	83 f8 ff             	cmp    $0xffffffff,%eax
80104b25:	75 f1                	jne    80104b18 <memmove+0x28>
80104b27:	5e                   	pop    %esi
80104b28:	89 d0                	mov    %edx,%eax
80104b2a:	5f                   	pop    %edi
80104b2b:	5d                   	pop    %ebp
80104b2c:	c3                   	ret    
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi
80104b30:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104b33:	89 d7                	mov    %edx,%edi
80104b35:	85 c9                	test   %ecx,%ecx
80104b37:	74 ee                	je     80104b27 <memmove+0x37>
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b40:	a4                   	movsb  %ds:(%esi),%es:(%edi)
80104b41:	39 f0                	cmp    %esi,%eax
80104b43:	75 fb                	jne    80104b40 <memmove+0x50>
80104b45:	5e                   	pop    %esi
80104b46:	89 d0                	mov    %edx,%eax
80104b48:	5f                   	pop    %edi
80104b49:	5d                   	pop    %ebp
80104b4a:	c3                   	ret    
80104b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b4f:	90                   	nop

80104b50 <memcpy>:
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	eb 9a                	jmp    80104af0 <memmove>
80104b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi

80104b60 <strncmp>:
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	56                   	push   %esi
80104b68:	8b 75 10             	mov    0x10(%ebp),%esi
80104b6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b6e:	53                   	push   %ebx
80104b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b72:	85 f6                	test   %esi,%esi
80104b74:	74 32                	je     80104ba8 <strncmp+0x48>
80104b76:	01 c6                	add    %eax,%esi
80104b78:	eb 14                	jmp    80104b8e <strncmp+0x2e>
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b80:	38 da                	cmp    %bl,%dl
80104b82:	75 14                	jne    80104b98 <strncmp+0x38>
80104b84:	83 c0 01             	add    $0x1,%eax
80104b87:	83 c1 01             	add    $0x1,%ecx
80104b8a:	39 f0                	cmp    %esi,%eax
80104b8c:	74 1a                	je     80104ba8 <strncmp+0x48>
80104b8e:	0f b6 11             	movzbl (%ecx),%edx
80104b91:	0f b6 18             	movzbl (%eax),%ebx
80104b94:	84 d2                	test   %dl,%dl
80104b96:	75 e8                	jne    80104b80 <strncmp+0x20>
80104b98:	0f b6 c2             	movzbl %dl,%eax
80104b9b:	29 d8                	sub    %ebx,%eax
80104b9d:	5b                   	pop    %ebx
80104b9e:	5e                   	pop    %esi
80104b9f:	5d                   	pop    %ebp
80104ba0:	c3                   	ret    
80104ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba8:	5b                   	pop    %ebx
80104ba9:	31 c0                	xor    %eax,%eax
80104bab:	5e                   	pop    %esi
80104bac:	5d                   	pop    %ebp
80104bad:	c3                   	ret    
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <strncpy>:
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	57                   	push   %edi
80104bb8:	56                   	push   %esi
80104bb9:	8b 75 08             	mov    0x8(%ebp),%esi
80104bbc:	53                   	push   %ebx
80104bbd:	8b 45 10             	mov    0x10(%ebp),%eax
80104bc0:	89 f2                	mov    %esi,%edx
80104bc2:	eb 1b                	jmp    80104bdf <strncpy+0x2f>
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104bcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104bcf:	83 c2 01             	add    $0x1,%edx
80104bd2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104bd6:	89 f9                	mov    %edi,%ecx
80104bd8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bdb:	84 c9                	test   %cl,%cl
80104bdd:	74 09                	je     80104be8 <strncpy+0x38>
80104bdf:	89 c3                	mov    %eax,%ebx
80104be1:	83 e8 01             	sub    $0x1,%eax
80104be4:	85 db                	test   %ebx,%ebx
80104be6:	7f e0                	jg     80104bc8 <strncpy+0x18>
80104be8:	89 d1                	mov    %edx,%ecx
80104bea:	85 c0                	test   %eax,%eax
80104bec:	7e 15                	jle    80104c03 <strncpy+0x53>
80104bee:	66 90                	xchg   %ax,%ax
80104bf0:	83 c1 01             	add    $0x1,%ecx
80104bf3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
80104bf7:	89 c8                	mov    %ecx,%eax
80104bf9:	f7 d0                	not    %eax
80104bfb:	01 d0                	add    %edx,%eax
80104bfd:	01 d8                	add    %ebx,%eax
80104bff:	85 c0                	test   %eax,%eax
80104c01:	7f ed                	jg     80104bf0 <strncpy+0x40>
80104c03:	5b                   	pop    %ebx
80104c04:	89 f0                	mov    %esi,%eax
80104c06:	5e                   	pop    %esi
80104c07:	5f                   	pop    %edi
80104c08:	5d                   	pop    %ebp
80104c09:	c3                   	ret    
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c10 <safestrcpy>:
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
80104c17:	56                   	push   %esi
80104c18:	8b 55 10             	mov    0x10(%ebp),%edx
80104c1b:	8b 75 08             	mov    0x8(%ebp),%esi
80104c1e:	53                   	push   %ebx
80104c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c22:	85 d2                	test   %edx,%edx
80104c24:	7e 21                	jle    80104c47 <safestrcpy+0x37>
80104c26:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104c2a:	89 f2                	mov    %esi,%edx
80104c2c:	eb 12                	jmp    80104c40 <safestrcpy+0x30>
80104c2e:	66 90                	xchg   %ax,%ax
80104c30:	0f b6 08             	movzbl (%eax),%ecx
80104c33:	83 c0 01             	add    $0x1,%eax
80104c36:	83 c2 01             	add    $0x1,%edx
80104c39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c3c:	84 c9                	test   %cl,%cl
80104c3e:	74 04                	je     80104c44 <safestrcpy+0x34>
80104c40:	39 d8                	cmp    %ebx,%eax
80104c42:	75 ec                	jne    80104c30 <safestrcpy+0x20>
80104c44:	c6 02 00             	movb   $0x0,(%edx)
80104c47:	89 f0                	mov    %esi,%eax
80104c49:	5b                   	pop    %ebx
80104c4a:	5e                   	pop    %esi
80104c4b:	5d                   	pop    %ebp
80104c4c:	c3                   	ret    
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi

80104c50 <strlen>:
80104c50:	f3 0f 1e fb          	endbr32 
80104c54:	55                   	push   %ebp
80104c55:	31 c0                	xor    %eax,%eax
80104c57:	89 e5                	mov    %esp,%ebp
80104c59:	8b 55 08             	mov    0x8(%ebp),%edx
80104c5c:	80 3a 00             	cmpb   $0x0,(%edx)
80104c5f:	74 10                	je     80104c71 <strlen+0x21>
80104c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c68:	83 c0 01             	add    $0x1,%eax
80104c6b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c6f:	75 f7                	jne    80104c68 <strlen+0x18>
80104c71:	5d                   	pop    %ebp
80104c72:	c3                   	ret    

80104c73 <swtch>:
80104c73:	8b 44 24 04          	mov    0x4(%esp),%eax
80104c77:	8b 54 24 08          	mov    0x8(%esp),%edx
80104c7b:	55                   	push   %ebp
80104c7c:	53                   	push   %ebx
80104c7d:	56                   	push   %esi
80104c7e:	57                   	push   %edi
80104c7f:	89 20                	mov    %esp,(%eax)
80104c81:	89 d4                	mov    %edx,%esp
80104c83:	5f                   	pop    %edi
80104c84:	5e                   	pop    %esi
80104c85:	5b                   	pop    %ebx
80104c86:	5d                   	pop    %ebp
80104c87:	c3                   	ret    
80104c88:	66 90                	xchg   %ax,%ax
80104c8a:	66 90                	xchg   %ax,%ax
80104c8c:	66 90                	xchg   %ax,%ax
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	53                   	push   %ebx
80104c98:	83 ec 04             	sub    $0x4,%esp
80104c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c9e:	e8 fd ed ff ff       	call   80103aa0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ca3:	8b 00                	mov    (%eax),%eax
80104ca5:	39 d8                	cmp    %ebx,%eax
80104ca7:	76 17                	jbe    80104cc0 <fetchint+0x30>
80104ca9:	8d 53 04             	lea    0x4(%ebx),%edx
80104cac:	39 d0                	cmp    %edx,%eax
80104cae:	72 10                	jb     80104cc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cb3:	8b 13                	mov    (%ebx),%edx
80104cb5:	89 10                	mov    %edx,(%eax)
  return 0;
80104cb7:	31 c0                	xor    %eax,%eax
}
80104cb9:	83 c4 04             	add    $0x4,%esp
80104cbc:	5b                   	pop    %ebx
80104cbd:	5d                   	pop    %ebp
80104cbe:	c3                   	ret    
80104cbf:	90                   	nop
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc5:	eb f2                	jmp    80104cb9 <fetchint+0x29>
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	53                   	push   %ebx
80104cd8:	83 ec 04             	sub    $0x4,%esp
80104cdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104cde:	e8 bd ed ff ff       	call   80103aa0 <myproc>

  if(addr >= curproc->sz)
80104ce3:	39 18                	cmp    %ebx,(%eax)
80104ce5:	76 31                	jbe    80104d18 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104cec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cee:	39 d3                	cmp    %edx,%ebx
80104cf0:	73 26                	jae    80104d18 <fetchstr+0x48>
80104cf2:	89 d8                	mov    %ebx,%eax
80104cf4:	eb 11                	jmp    80104d07 <fetchstr+0x37>
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
80104d00:	83 c0 01             	add    $0x1,%eax
80104d03:	39 c2                	cmp    %eax,%edx
80104d05:	76 11                	jbe    80104d18 <fetchstr+0x48>
    if(*s == 0)
80104d07:	80 38 00             	cmpb   $0x0,(%eax)
80104d0a:	75 f4                	jne    80104d00 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104d0c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104d0f:	29 d8                	sub    %ebx,%eax
}
80104d11:	5b                   	pop    %ebx
80104d12:	5d                   	pop    %ebp
80104d13:	c3                   	ret    
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d18:	83 c4 04             	add    $0x4,%esp
    return -1;
80104d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d20:	5b                   	pop    %ebx
80104d21:	5d                   	pop    %ebp
80104d22:	c3                   	ret    
80104d23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	56                   	push   %esi
80104d38:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d39:	e8 62 ed ff ff       	call   80103aa0 <myproc>
80104d3e:	8b 55 08             	mov    0x8(%ebp),%edx
80104d41:	8b 40 18             	mov    0x18(%eax),%eax
80104d44:	8b 40 44             	mov    0x44(%eax),%eax
80104d47:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d4a:	e8 51 ed ff ff       	call   80103aa0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d4f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d52:	8b 00                	mov    (%eax),%eax
80104d54:	39 c6                	cmp    %eax,%esi
80104d56:	73 18                	jae    80104d70 <argint+0x40>
80104d58:	8d 53 08             	lea    0x8(%ebx),%edx
80104d5b:	39 d0                	cmp    %edx,%eax
80104d5d:	72 11                	jb     80104d70 <argint+0x40>
  *ip = *(int*)(addr);
80104d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d62:	8b 53 04             	mov    0x4(%ebx),%edx
80104d65:	89 10                	mov    %edx,(%eax)
  return 0;
80104d67:	31 c0                	xor    %eax,%eax
}
80104d69:	5b                   	pop    %ebx
80104d6a:	5e                   	pop    %esi
80104d6b:	5d                   	pop    %ebp
80104d6c:	c3                   	ret    
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d75:	eb f2                	jmp    80104d69 <argint+0x39>
80104d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d80:	f3 0f 1e fb          	endbr32 
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	56                   	push   %esi
80104d88:	53                   	push   %ebx
80104d89:	83 ec 10             	sub    $0x10,%esp
80104d8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d8f:	e8 0c ed ff ff       	call   80103aa0 <myproc>
 
  if(argint(n, &i) < 0)
80104d94:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104d97:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104d99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d9c:	50                   	push   %eax
80104d9d:	ff 75 08             	pushl  0x8(%ebp)
80104da0:	e8 8b ff ff ff       	call   80104d30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104da5:	83 c4 10             	add    $0x10,%esp
80104da8:	85 c0                	test   %eax,%eax
80104daa:	78 24                	js     80104dd0 <argptr+0x50>
80104dac:	85 db                	test   %ebx,%ebx
80104dae:	78 20                	js     80104dd0 <argptr+0x50>
80104db0:	8b 16                	mov    (%esi),%edx
80104db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db5:	39 c2                	cmp    %eax,%edx
80104db7:	76 17                	jbe    80104dd0 <argptr+0x50>
80104db9:	01 c3                	add    %eax,%ebx
80104dbb:	39 da                	cmp    %ebx,%edx
80104dbd:	72 11                	jb     80104dd0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dc2:	89 02                	mov    %eax,(%edx)
  return 0;
80104dc4:	31 c0                	xor    %eax,%eax
}
80104dc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dc9:	5b                   	pop    %ebx
80104dca:	5e                   	pop    %esi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd5:	eb ef                	jmp    80104dc6 <argptr+0x46>
80104dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104dea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ded:	50                   	push   %eax
80104dee:	ff 75 08             	pushl  0x8(%ebp)
80104df1:	e8 3a ff ff ff       	call   80104d30 <argint>
80104df6:	83 c4 10             	add    $0x10,%esp
80104df9:	85 c0                	test   %eax,%eax
80104dfb:	78 13                	js     80104e10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104dfd:	83 ec 08             	sub    $0x8,%esp
80104e00:	ff 75 0c             	pushl  0xc(%ebp)
80104e03:	ff 75 f4             	pushl  -0xc(%ebp)
80104e06:	e8 c5 fe ff ff       	call   80104cd0 <fetchstr>
80104e0b:	83 c4 10             	add    $0x10,%esp
}
80104e0e:	c9                   	leave  
80104e0f:	c3                   	ret    
80104e10:	c9                   	leave  
    return -1;
80104e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e16:	c3                   	ret    
80104e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <syscall>:
[SYS_ps] sys_ps,
};

void
syscall(void)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	53                   	push   %ebx
80104e28:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e2b:	e8 70 ec ff ff       	call   80103aa0 <myproc>
80104e30:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e32:	8b 40 18             	mov    0x18(%eax),%eax
80104e35:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e38:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e3b:	83 fa 1a             	cmp    $0x1a,%edx
80104e3e:	77 20                	ja     80104e60 <syscall+0x40>
80104e40:	8b 14 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%edx
80104e47:	85 d2                	test   %edx,%edx
80104e49:	74 15                	je     80104e60 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104e4b:	ff d2                	call   *%edx
80104e4d:	89 c2                	mov    %eax,%edx
80104e4f:	8b 43 18             	mov    0x18(%ebx),%eax
80104e52:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e58:	c9                   	leave  
80104e59:	c3                   	ret    
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e60:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e61:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e64:	50                   	push   %eax
80104e65:	ff 73 10             	pushl  0x10(%ebx)
80104e68:	68 f9 7d 10 80       	push   $0x80107df9
80104e6d:	e8 3e b8 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104e72:	8b 43 18             	mov    0x18(%ebx),%eax
80104e75:	83 c4 10             	add    $0x10,%esp
80104e78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e82:	c9                   	leave  
80104e83:	c3                   	ret    
80104e84:	66 90                	xchg   %ax,%ax
80104e86:	66 90                	xchg   %ax,%ax
80104e88:	66 90                	xchg   %ax,%ax
80104e8a:	66 90                	xchg   %ax,%ax
80104e8c:	66 90                	xchg   %ax,%ax
80104e8e:	66 90                	xchg   %ax,%ax

80104e90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	57                   	push   %edi
80104e94:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e98:	53                   	push   %ebx
80104e99:	83 ec 44             	sub    $0x44,%esp
80104e9c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104e9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ea2:	57                   	push   %edi
80104ea3:	50                   	push   %eax
{
80104ea4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104ea7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104eaa:	e8 a1 d1 ff ff       	call   80102050 <nameiparent>
80104eaf:	83 c4 10             	add    $0x10,%esp
80104eb2:	85 c0                	test   %eax,%eax
80104eb4:	0f 84 46 01 00 00    	je     80105000 <create+0x170>
    return 0;
  ilock(dp);
80104eba:	83 ec 0c             	sub    $0xc,%esp
80104ebd:	89 c3                	mov    %eax,%ebx
80104ebf:	50                   	push   %eax
80104ec0:	e8 9b c8 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104ec5:	83 c4 0c             	add    $0xc,%esp
80104ec8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104ecb:	50                   	push   %eax
80104ecc:	57                   	push   %edi
80104ecd:	53                   	push   %ebx
80104ece:	e8 dd cd ff ff       	call   80101cb0 <dirlookup>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	89 c6                	mov    %eax,%esi
80104ed8:	85 c0                	test   %eax,%eax
80104eda:	74 54                	je     80104f30 <create+0xa0>
    iunlockput(dp);
80104edc:	83 ec 0c             	sub    $0xc,%esp
80104edf:	53                   	push   %ebx
80104ee0:	e8 1b cb ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104ee5:	89 34 24             	mov    %esi,(%esp)
80104ee8:	e8 73 c8 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ef5:	75 19                	jne    80104f10 <create+0x80>
80104ef7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104efc:	75 12                	jne    80104f10 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f01:	89 f0                	mov    %esi,%eax
80104f03:	5b                   	pop    %ebx
80104f04:	5e                   	pop    %esi
80104f05:	5f                   	pop    %edi
80104f06:	5d                   	pop    %ebp
80104f07:	c3                   	ret    
80104f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0f:	90                   	nop
    iunlockput(ip);
80104f10:	83 ec 0c             	sub    $0xc,%esp
80104f13:	56                   	push   %esi
    return 0;
80104f14:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104f16:	e8 e5 ca ff ff       	call   80101a00 <iunlockput>
    return 0;
80104f1b:	83 c4 10             	add    $0x10,%esp
}
80104f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f21:	89 f0                	mov    %esi,%eax
80104f23:	5b                   	pop    %ebx
80104f24:	5e                   	pop    %esi
80104f25:	5f                   	pop    %edi
80104f26:	5d                   	pop    %ebp
80104f27:	c3                   	ret    
80104f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104f30:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104f34:	83 ec 08             	sub    $0x8,%esp
80104f37:	50                   	push   %eax
80104f38:	ff 33                	pushl  (%ebx)
80104f3a:	e8 a1 c6 ff ff       	call   801015e0 <ialloc>
80104f3f:	83 c4 10             	add    $0x10,%esp
80104f42:	89 c6                	mov    %eax,%esi
80104f44:	85 c0                	test   %eax,%eax
80104f46:	0f 84 cd 00 00 00    	je     80105019 <create+0x189>
  ilock(ip);
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	50                   	push   %eax
80104f50:	e8 0b c8 ff ff       	call   80101760 <ilock>
  ip->major = major;
80104f55:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104f59:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f5d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104f61:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f65:	b8 01 00 00 00       	mov    $0x1,%eax
80104f6a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f6e:	89 34 24             	mov    %esi,(%esp)
80104f71:	e8 2a c7 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f7e:	74 30                	je     80104fb0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f80:	83 ec 04             	sub    $0x4,%esp
80104f83:	ff 76 04             	pushl  0x4(%esi)
80104f86:	57                   	push   %edi
80104f87:	53                   	push   %ebx
80104f88:	e8 e3 cf ff ff       	call   80101f70 <dirlink>
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	78 78                	js     8010500c <create+0x17c>
  iunlockput(dp);
80104f94:	83 ec 0c             	sub    $0xc,%esp
80104f97:	53                   	push   %ebx
80104f98:	e8 63 ca ff ff       	call   80101a00 <iunlockput>
  return ip;
80104f9d:	83 c4 10             	add    $0x10,%esp
}
80104fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fa3:	89 f0                	mov    %esi,%eax
80104fa5:	5b                   	pop    %ebx
80104fa6:	5e                   	pop    %esi
80104fa7:	5f                   	pop    %edi
80104fa8:	5d                   	pop    %ebp
80104fa9:	c3                   	ret    
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104fb3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fb8:	53                   	push   %ebx
80104fb9:	e8 e2 c6 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fbe:	83 c4 0c             	add    $0xc,%esp
80104fc1:	ff 76 04             	pushl  0x4(%esi)
80104fc4:	68 ac 7e 10 80       	push   $0x80107eac
80104fc9:	56                   	push   %esi
80104fca:	e8 a1 cf ff ff       	call   80101f70 <dirlink>
80104fcf:	83 c4 10             	add    $0x10,%esp
80104fd2:	85 c0                	test   %eax,%eax
80104fd4:	78 18                	js     80104fee <create+0x15e>
80104fd6:	83 ec 04             	sub    $0x4,%esp
80104fd9:	ff 73 04             	pushl  0x4(%ebx)
80104fdc:	68 ab 7e 10 80       	push   $0x80107eab
80104fe1:	56                   	push   %esi
80104fe2:	e8 89 cf ff ff       	call   80101f70 <dirlink>
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	85 c0                	test   %eax,%eax
80104fec:	79 92                	jns    80104f80 <create+0xf0>
      panic("create dots");
80104fee:	83 ec 0c             	sub    $0xc,%esp
80104ff1:	68 9f 7e 10 80       	push   $0x80107e9f
80104ff6:	e8 95 b3 ff ff       	call   80100390 <panic>
80104ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fff:	90                   	nop
}
80105000:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105003:	31 f6                	xor    %esi,%esi
}
80105005:	5b                   	pop    %ebx
80105006:	89 f0                	mov    %esi,%eax
80105008:	5e                   	pop    %esi
80105009:	5f                   	pop    %edi
8010500a:	5d                   	pop    %ebp
8010500b:	c3                   	ret    
    panic("create: dirlink");
8010500c:	83 ec 0c             	sub    $0xc,%esp
8010500f:	68 ae 7e 10 80       	push   $0x80107eae
80105014:	e8 77 b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105019:	83 ec 0c             	sub    $0xc,%esp
8010501c:	68 90 7e 10 80       	push   $0x80107e90
80105021:	e8 6a b3 ff ff       	call   80100390 <panic>
80105026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502d:	8d 76 00             	lea    0x0(%esi),%esi

80105030 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	89 d6                	mov    %edx,%esi
80105036:	53                   	push   %ebx
80105037:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105039:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010503c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503f:	50                   	push   %eax
80105040:	6a 00                	push   $0x0
80105042:	e8 e9 fc ff ff       	call   80104d30 <argint>
80105047:	83 c4 10             	add    $0x10,%esp
8010504a:	85 c0                	test   %eax,%eax
8010504c:	78 2a                	js     80105078 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105052:	77 24                	ja     80105078 <argfd.constprop.0+0x48>
80105054:	e8 47 ea ff ff       	call   80103aa0 <myproc>
80105059:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010505c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105060:	85 c0                	test   %eax,%eax
80105062:	74 14                	je     80105078 <argfd.constprop.0+0x48>
  if(pfd)
80105064:	85 db                	test   %ebx,%ebx
80105066:	74 02                	je     8010506a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105068:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010506a:	89 06                	mov    %eax,(%esi)
  return 0;
8010506c:	31 c0                	xor    %eax,%eax
}
8010506e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105071:	5b                   	pop    %ebx
80105072:	5e                   	pop    %esi
80105073:	5d                   	pop    %ebp
80105074:	c3                   	ret    
80105075:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507d:	eb ef                	jmp    8010506e <argfd.constprop.0+0x3e>
8010507f:	90                   	nop

80105080 <sys_dup>:
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105085:	31 c0                	xor    %eax,%eax
{
80105087:	89 e5                	mov    %esp,%ebp
80105089:	56                   	push   %esi
8010508a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010508b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010508e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105091:	e8 9a ff ff ff       	call   80105030 <argfd.constprop.0>
80105096:	85 c0                	test   %eax,%eax
80105098:	78 1e                	js     801050b8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010509a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010509d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010509f:	e8 fc e9 ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801050a8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050ac:	85 d2                	test   %edx,%edx
801050ae:	74 20                	je     801050d0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801050b0:	83 c3 01             	add    $0x1,%ebx
801050b3:	83 fb 10             	cmp    $0x10,%ebx
801050b6:	75 f0                	jne    801050a8 <sys_dup+0x28>
}
801050b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801050bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801050c0:	89 d8                	mov    %ebx,%eax
801050c2:	5b                   	pop    %ebx
801050c3:	5e                   	pop    %esi
801050c4:	5d                   	pop    %ebp
801050c5:	c3                   	ret    
801050c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801050d0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801050d4:	83 ec 0c             	sub    $0xc,%esp
801050d7:	ff 75 f4             	pushl  -0xc(%ebp)
801050da:	e8 91 bd ff ff       	call   80100e70 <filedup>
  return fd;
801050df:	83 c4 10             	add    $0x10,%esp
}
801050e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e5:	89 d8                	mov    %ebx,%eax
801050e7:	5b                   	pop    %ebx
801050e8:	5e                   	pop    %esi
801050e9:	5d                   	pop    %ebp
801050ea:	c3                   	ret    
801050eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ef:	90                   	nop

801050f0 <sys_read>:
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050f5:	31 c0                	xor    %eax,%eax
{
801050f7:	89 e5                	mov    %esp,%ebp
801050f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050fc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050ff:	e8 2c ff ff ff       	call   80105030 <argfd.constprop.0>
80105104:	85 c0                	test   %eax,%eax
80105106:	78 48                	js     80105150 <sys_read+0x60>
80105108:	83 ec 08             	sub    $0x8,%esp
8010510b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010510e:	50                   	push   %eax
8010510f:	6a 02                	push   $0x2
80105111:	e8 1a fc ff ff       	call   80104d30 <argint>
80105116:	83 c4 10             	add    $0x10,%esp
80105119:	85 c0                	test   %eax,%eax
8010511b:	78 33                	js     80105150 <sys_read+0x60>
8010511d:	83 ec 04             	sub    $0x4,%esp
80105120:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105123:	ff 75 f0             	pushl  -0x10(%ebp)
80105126:	50                   	push   %eax
80105127:	6a 01                	push   $0x1
80105129:	e8 52 fc ff ff       	call   80104d80 <argptr>
8010512e:	83 c4 10             	add    $0x10,%esp
80105131:	85 c0                	test   %eax,%eax
80105133:	78 1b                	js     80105150 <sys_read+0x60>
  return fileread(f, p, n);
80105135:	83 ec 04             	sub    $0x4,%esp
80105138:	ff 75 f0             	pushl  -0x10(%ebp)
8010513b:	ff 75 f4             	pushl  -0xc(%ebp)
8010513e:	ff 75 ec             	pushl  -0x14(%ebp)
80105141:	e8 aa be ff ff       	call   80100ff0 <fileread>
80105146:	83 c4 10             	add    $0x10,%esp
}
80105149:	c9                   	leave  
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop
80105150:	c9                   	leave  
    return -1;
80105151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105156:	c3                   	ret    
80105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515e:	66 90                	xchg   %ax,%ax

80105160 <sys_write>:
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105165:	31 c0                	xor    %eax,%eax
{
80105167:	89 e5                	mov    %esp,%ebp
80105169:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010516c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010516f:	e8 bc fe ff ff       	call   80105030 <argfd.constprop.0>
80105174:	85 c0                	test   %eax,%eax
80105176:	78 48                	js     801051c0 <sys_write+0x60>
80105178:	83 ec 08             	sub    $0x8,%esp
8010517b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010517e:	50                   	push   %eax
8010517f:	6a 02                	push   $0x2
80105181:	e8 aa fb ff ff       	call   80104d30 <argint>
80105186:	83 c4 10             	add    $0x10,%esp
80105189:	85 c0                	test   %eax,%eax
8010518b:	78 33                	js     801051c0 <sys_write+0x60>
8010518d:	83 ec 04             	sub    $0x4,%esp
80105190:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105193:	ff 75 f0             	pushl  -0x10(%ebp)
80105196:	50                   	push   %eax
80105197:	6a 01                	push   $0x1
80105199:	e8 e2 fb ff ff       	call   80104d80 <argptr>
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	85 c0                	test   %eax,%eax
801051a3:	78 1b                	js     801051c0 <sys_write+0x60>
  return filewrite(f, p, n);
801051a5:	83 ec 04             	sub    $0x4,%esp
801051a8:	ff 75 f0             	pushl  -0x10(%ebp)
801051ab:	ff 75 f4             	pushl  -0xc(%ebp)
801051ae:	ff 75 ec             	pushl  -0x14(%ebp)
801051b1:	e8 da be ff ff       	call   80101090 <filewrite>
801051b6:	83 c4 10             	add    $0x10,%esp
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

801051d0 <sys_close>:
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801051da:	8d 55 f4             	lea    -0xc(%ebp),%edx
801051dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e0:	e8 4b fe ff ff       	call   80105030 <argfd.constprop.0>
801051e5:	85 c0                	test   %eax,%eax
801051e7:	78 27                	js     80105210 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801051e9:	e8 b2 e8 ff ff       	call   80103aa0 <myproc>
801051ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801051f1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051f4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051fb:	00 
  fileclose(f);
801051fc:	ff 75 f4             	pushl  -0xc(%ebp)
801051ff:	e8 bc bc ff ff       	call   80100ec0 <fileclose>
  return 0;
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	31 c0                	xor    %eax,%eax
}
80105209:	c9                   	leave  
8010520a:	c3                   	ret    
8010520b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010520f:	90                   	nop
80105210:	c9                   	leave  
    return -1;
80105211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105216:	c3                   	ret    
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax

80105220 <sys_fstat>:
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105225:	31 c0                	xor    %eax,%eax
{
80105227:	89 e5                	mov    %esp,%ebp
80105229:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010522c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010522f:	e8 fc fd ff ff       	call   80105030 <argfd.constprop.0>
80105234:	85 c0                	test   %eax,%eax
80105236:	78 30                	js     80105268 <sys_fstat+0x48>
80105238:	83 ec 04             	sub    $0x4,%esp
8010523b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010523e:	6a 14                	push   $0x14
80105240:	50                   	push   %eax
80105241:	6a 01                	push   $0x1
80105243:	e8 38 fb ff ff       	call   80104d80 <argptr>
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	85 c0                	test   %eax,%eax
8010524d:	78 19                	js     80105268 <sys_fstat+0x48>
  return filestat(f, st);
8010524f:	83 ec 08             	sub    $0x8,%esp
80105252:	ff 75 f4             	pushl  -0xc(%ebp)
80105255:	ff 75 f0             	pushl  -0x10(%ebp)
80105258:	e8 43 bd ff ff       	call   80100fa0 <filestat>
8010525d:	83 c4 10             	add    $0x10,%esp
}
80105260:	c9                   	leave  
80105261:	c3                   	ret    
80105262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105268:	c9                   	leave  
    return -1;
80105269:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010526e:	c3                   	ret    
8010526f:	90                   	nop

80105270 <sys_link>:
{
80105270:	f3 0f 1e fb          	endbr32 
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
80105277:	57                   	push   %edi
80105278:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105279:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010527c:	53                   	push   %ebx
8010527d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105280:	50                   	push   %eax
80105281:	6a 00                	push   $0x0
80105283:	e8 58 fb ff ff       	call   80104de0 <argstr>
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	85 c0                	test   %eax,%eax
8010528d:	0f 88 ff 00 00 00    	js     80105392 <sys_link+0x122>
80105293:	83 ec 08             	sub    $0x8,%esp
80105296:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105299:	50                   	push   %eax
8010529a:	6a 01                	push   $0x1
8010529c:	e8 3f fb ff ff       	call   80104de0 <argstr>
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	85 c0                	test   %eax,%eax
801052a6:	0f 88 e6 00 00 00    	js     80105392 <sys_link+0x122>
  begin_op();
801052ac:	e8 8f db ff ff       	call   80102e40 <begin_op>
  if((ip = namei(old)) == 0){
801052b1:	83 ec 0c             	sub    $0xc,%esp
801052b4:	ff 75 d4             	pushl  -0x2c(%ebp)
801052b7:	e8 74 cd ff ff       	call   80102030 <namei>
801052bc:	83 c4 10             	add    $0x10,%esp
801052bf:	89 c3                	mov    %eax,%ebx
801052c1:	85 c0                	test   %eax,%eax
801052c3:	0f 84 e8 00 00 00    	je     801053b1 <sys_link+0x141>
  ilock(ip);
801052c9:	83 ec 0c             	sub    $0xc,%esp
801052cc:	50                   	push   %eax
801052cd:	e8 8e c4 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052da:	0f 84 b9 00 00 00    	je     80105399 <sys_link+0x129>
  iupdate(ip);
801052e0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801052e8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052eb:	53                   	push   %ebx
801052ec:	e8 af c3 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801052f1:	89 1c 24             	mov    %ebx,(%esp)
801052f4:	e8 47 c5 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052f9:	58                   	pop    %eax
801052fa:	5a                   	pop    %edx
801052fb:	57                   	push   %edi
801052fc:	ff 75 d0             	pushl  -0x30(%ebp)
801052ff:	e8 4c cd ff ff       	call   80102050 <nameiparent>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	89 c6                	mov    %eax,%esi
80105309:	85 c0                	test   %eax,%eax
8010530b:	74 5f                	je     8010536c <sys_link+0xfc>
  ilock(dp);
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	50                   	push   %eax
80105311:	e8 4a c4 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105316:	8b 03                	mov    (%ebx),%eax
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	39 06                	cmp    %eax,(%esi)
8010531d:	75 41                	jne    80105360 <sys_link+0xf0>
8010531f:	83 ec 04             	sub    $0x4,%esp
80105322:	ff 73 04             	pushl  0x4(%ebx)
80105325:	57                   	push   %edi
80105326:	56                   	push   %esi
80105327:	e8 44 cc ff ff       	call   80101f70 <dirlink>
8010532c:	83 c4 10             	add    $0x10,%esp
8010532f:	85 c0                	test   %eax,%eax
80105331:	78 2d                	js     80105360 <sys_link+0xf0>
  iunlockput(dp);
80105333:	83 ec 0c             	sub    $0xc,%esp
80105336:	56                   	push   %esi
80105337:	e8 c4 c6 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010533c:	89 1c 24             	mov    %ebx,(%esp)
8010533f:	e8 4c c5 ff ff       	call   80101890 <iput>
  end_op();
80105344:	e8 67 db ff ff       	call   80102eb0 <end_op>
  return 0;
80105349:	83 c4 10             	add    $0x10,%esp
8010534c:	31 c0                	xor    %eax,%eax
}
8010534e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105351:	5b                   	pop    %ebx
80105352:	5e                   	pop    %esi
80105353:	5f                   	pop    %edi
80105354:	5d                   	pop    %ebp
80105355:	c3                   	ret    
80105356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	56                   	push   %esi
80105364:	e8 97 c6 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105369:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	53                   	push   %ebx
80105370:	e8 eb c3 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105375:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010537a:	89 1c 24             	mov    %ebx,(%esp)
8010537d:	e8 1e c3 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105382:	89 1c 24             	mov    %ebx,(%esp)
80105385:	e8 76 c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010538a:	e8 21 db ff ff       	call   80102eb0 <end_op>
  return -1;
8010538f:	83 c4 10             	add    $0x10,%esp
80105392:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105397:	eb b5                	jmp    8010534e <sys_link+0xde>
    iunlockput(ip);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	53                   	push   %ebx
8010539d:	e8 5e c6 ff ff       	call   80101a00 <iunlockput>
    end_op();
801053a2:	e8 09 db ff ff       	call   80102eb0 <end_op>
    return -1;
801053a7:	83 c4 10             	add    $0x10,%esp
801053aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053af:	eb 9d                	jmp    8010534e <sys_link+0xde>
    end_op();
801053b1:	e8 fa da ff ff       	call   80102eb0 <end_op>
    return -1;
801053b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bb:	eb 91                	jmp    8010534e <sys_link+0xde>
801053bd:	8d 76 00             	lea    0x0(%esi),%esi

801053c0 <sys_unlink>:
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	57                   	push   %edi
801053c8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801053c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053cc:	53                   	push   %ebx
801053cd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801053d0:	50                   	push   %eax
801053d1:	6a 00                	push   $0x0
801053d3:	e8 08 fa ff ff       	call   80104de0 <argstr>
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	85 c0                	test   %eax,%eax
801053dd:	0f 88 7d 01 00 00    	js     80105560 <sys_unlink+0x1a0>
  begin_op();
801053e3:	e8 58 da ff ff       	call   80102e40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053e8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801053eb:	83 ec 08             	sub    $0x8,%esp
801053ee:	53                   	push   %ebx
801053ef:	ff 75 c0             	pushl  -0x40(%ebp)
801053f2:	e8 59 cc ff ff       	call   80102050 <nameiparent>
801053f7:	83 c4 10             	add    $0x10,%esp
801053fa:	89 c6                	mov    %eax,%esi
801053fc:	85 c0                	test   %eax,%eax
801053fe:	0f 84 66 01 00 00    	je     8010556a <sys_unlink+0x1aa>
  ilock(dp);
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	50                   	push   %eax
80105408:	e8 53 c3 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010540d:	58                   	pop    %eax
8010540e:	5a                   	pop    %edx
8010540f:	68 ac 7e 10 80       	push   $0x80107eac
80105414:	53                   	push   %ebx
80105415:	e8 76 c8 ff ff       	call   80101c90 <namecmp>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	0f 84 03 01 00 00    	je     80105528 <sys_unlink+0x168>
80105425:	83 ec 08             	sub    $0x8,%esp
80105428:	68 ab 7e 10 80       	push   $0x80107eab
8010542d:	53                   	push   %ebx
8010542e:	e8 5d c8 ff ff       	call   80101c90 <namecmp>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	0f 84 ea 00 00 00    	je     80105528 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010543e:	83 ec 04             	sub    $0x4,%esp
80105441:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105444:	50                   	push   %eax
80105445:	53                   	push   %ebx
80105446:	56                   	push   %esi
80105447:	e8 64 c8 ff ff       	call   80101cb0 <dirlookup>
8010544c:	83 c4 10             	add    $0x10,%esp
8010544f:	89 c3                	mov    %eax,%ebx
80105451:	85 c0                	test   %eax,%eax
80105453:	0f 84 cf 00 00 00    	je     80105528 <sys_unlink+0x168>
  ilock(ip);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	50                   	push   %eax
8010545d:	e8 fe c2 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010546a:	0f 8e 23 01 00 00    	jle    80105593 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105470:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105475:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105478:	74 66                	je     801054e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010547a:	83 ec 04             	sub    $0x4,%esp
8010547d:	6a 10                	push   $0x10
8010547f:	6a 00                	push   $0x0
80105481:	57                   	push   %edi
80105482:	e8 c9 f5 ff ff       	call   80104a50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105487:	6a 10                	push   $0x10
80105489:	ff 75 c4             	pushl  -0x3c(%ebp)
8010548c:	57                   	push   %edi
8010548d:	56                   	push   %esi
8010548e:	e8 cd c6 ff ff       	call   80101b60 <writei>
80105493:	83 c4 20             	add    $0x20,%esp
80105496:	83 f8 10             	cmp    $0x10,%eax
80105499:	0f 85 e7 00 00 00    	jne    80105586 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010549f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a4:	0f 84 96 00 00 00    	je     80105540 <sys_unlink+0x180>
  iunlockput(dp);
801054aa:	83 ec 0c             	sub    $0xc,%esp
801054ad:	56                   	push   %esi
801054ae:	e8 4d c5 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
801054b3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054b8:	89 1c 24             	mov    %ebx,(%esp)
801054bb:	e8 e0 c1 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801054c0:	89 1c 24             	mov    %ebx,(%esp)
801054c3:	e8 38 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
801054c8:	e8 e3 d9 ff ff       	call   80102eb0 <end_op>
  return 0;
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	31 c0                	xor    %eax,%eax
}
801054d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054d5:	5b                   	pop    %ebx
801054d6:	5e                   	pop    %esi
801054d7:	5f                   	pop    %edi
801054d8:	5d                   	pop    %ebp
801054d9:	c3                   	ret    
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054e4:	76 94                	jbe    8010547a <sys_unlink+0xba>
801054e6:	ba 20 00 00 00       	mov    $0x20,%edx
801054eb:	eb 0b                	jmp    801054f8 <sys_unlink+0x138>
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
801054f0:	83 c2 10             	add    $0x10,%edx
801054f3:	39 53 58             	cmp    %edx,0x58(%ebx)
801054f6:	76 82                	jbe    8010547a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f8:	6a 10                	push   $0x10
801054fa:	52                   	push   %edx
801054fb:	57                   	push   %edi
801054fc:	53                   	push   %ebx
801054fd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105500:	e8 5b c5 ff ff       	call   80101a60 <readi>
80105505:	83 c4 10             	add    $0x10,%esp
80105508:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010550b:	83 f8 10             	cmp    $0x10,%eax
8010550e:	75 69                	jne    80105579 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105510:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105515:	74 d9                	je     801054f0 <sys_unlink+0x130>
    iunlockput(ip);
80105517:	83 ec 0c             	sub    $0xc,%esp
8010551a:	53                   	push   %ebx
8010551b:	e8 e0 c4 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105520:	83 c4 10             	add    $0x10,%esp
80105523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105527:	90                   	nop
  iunlockput(dp);
80105528:	83 ec 0c             	sub    $0xc,%esp
8010552b:	56                   	push   %esi
8010552c:	e8 cf c4 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105531:	e8 7a d9 ff ff       	call   80102eb0 <end_op>
  return -1;
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553e:	eb 92                	jmp    801054d2 <sys_unlink+0x112>
    iupdate(dp);
80105540:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105543:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105548:	56                   	push   %esi
80105549:	e8 52 c1 ff ff       	call   801016a0 <iupdate>
8010554e:	83 c4 10             	add    $0x10,%esp
80105551:	e9 54 ff ff ff       	jmp    801054aa <sys_unlink+0xea>
80105556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105565:	e9 68 ff ff ff       	jmp    801054d2 <sys_unlink+0x112>
    end_op();
8010556a:	e8 41 d9 ff ff       	call   80102eb0 <end_op>
    return -1;
8010556f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105574:	e9 59 ff ff ff       	jmp    801054d2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105579:	83 ec 0c             	sub    $0xc,%esp
8010557c:	68 d0 7e 10 80       	push   $0x80107ed0
80105581:	e8 0a ae ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105586:	83 ec 0c             	sub    $0xc,%esp
80105589:	68 e2 7e 10 80       	push   $0x80107ee2
8010558e:	e8 fd ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105593:	83 ec 0c             	sub    $0xc,%esp
80105596:	68 be 7e 10 80       	push   $0x80107ebe
8010559b:	e8 f0 ad ff ff       	call   80100390 <panic>

801055a0 <sys_open>:

int
sys_open(void)
{
801055a0:	f3 0f 1e fb          	endbr32 
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	57                   	push   %edi
801055a8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055ac:	53                   	push   %ebx
801055ad:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055b0:	50                   	push   %eax
801055b1:	6a 00                	push   $0x0
801055b3:	e8 28 f8 ff ff       	call   80104de0 <argstr>
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	85 c0                	test   %eax,%eax
801055bd:	0f 88 8a 00 00 00    	js     8010564d <sys_open+0xad>
801055c3:	83 ec 08             	sub    $0x8,%esp
801055c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055c9:	50                   	push   %eax
801055ca:	6a 01                	push   $0x1
801055cc:	e8 5f f7 ff ff       	call   80104d30 <argint>
801055d1:	83 c4 10             	add    $0x10,%esp
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 75                	js     8010564d <sys_open+0xad>
    return -1;

  begin_op();
801055d8:	e8 63 d8 ff ff       	call   80102e40 <begin_op>

  if(omode & O_CREATE){
801055dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055e1:	75 75                	jne    80105658 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055e3:	83 ec 0c             	sub    $0xc,%esp
801055e6:	ff 75 e0             	pushl  -0x20(%ebp)
801055e9:	e8 42 ca ff ff       	call   80102030 <namei>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	89 c6                	mov    %eax,%esi
801055f3:	85 c0                	test   %eax,%eax
801055f5:	74 7e                	je     80105675 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801055f7:	83 ec 0c             	sub    $0xc,%esp
801055fa:	50                   	push   %eax
801055fb:	e8 60 c1 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105600:	83 c4 10             	add    $0x10,%esp
80105603:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105608:	0f 84 c2 00 00 00    	je     801056d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010560e:	e8 ed b7 ff ff       	call   80100e00 <filealloc>
80105613:	89 c7                	mov    %eax,%edi
80105615:	85 c0                	test   %eax,%eax
80105617:	74 23                	je     8010563c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105619:	e8 82 e4 ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010561e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105620:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105624:	85 d2                	test   %edx,%edx
80105626:	74 60                	je     80105688 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105628:	83 c3 01             	add    $0x1,%ebx
8010562b:	83 fb 10             	cmp    $0x10,%ebx
8010562e:	75 f0                	jne    80105620 <sys_open+0x80>
    if(f)
      fileclose(f);
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	57                   	push   %edi
80105634:	e8 87 b8 ff ff       	call   80100ec0 <fileclose>
80105639:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010563c:	83 ec 0c             	sub    $0xc,%esp
8010563f:	56                   	push   %esi
80105640:	e8 bb c3 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105645:	e8 66 d8 ff ff       	call   80102eb0 <end_op>
    return -1;
8010564a:	83 c4 10             	add    $0x10,%esp
8010564d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105652:	eb 6d                	jmp    801056c1 <sys_open+0x121>
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010565e:	31 c9                	xor    %ecx,%ecx
80105660:	ba 02 00 00 00       	mov    $0x2,%edx
80105665:	6a 00                	push   $0x0
80105667:	e8 24 f8 ff ff       	call   80104e90 <create>
    if(ip == 0){
8010566c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010566f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105671:	85 c0                	test   %eax,%eax
80105673:	75 99                	jne    8010560e <sys_open+0x6e>
      end_op();
80105675:	e8 36 d8 ff ff       	call   80102eb0 <end_op>
      return -1;
8010567a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010567f:	eb 40                	jmp    801056c1 <sys_open+0x121>
80105681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105688:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010568b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010568f:	56                   	push   %esi
80105690:	e8 ab c1 ff ff       	call   80101840 <iunlock>
  end_op();
80105695:	e8 16 d8 ff ff       	call   80102eb0 <end_op>

  f->type = FD_INODE;
8010569a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801056a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801056ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056b2:	f7 d0                	not    %eax
801056b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c4:	89 d8                	mov    %ebx,%eax
801056c6:	5b                   	pop    %ebx
801056c7:	5e                   	pop    %esi
801056c8:	5f                   	pop    %edi
801056c9:	5d                   	pop    %ebp
801056ca:	c3                   	ret    
801056cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801056d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056d3:	85 c9                	test   %ecx,%ecx
801056d5:	0f 84 33 ff ff ff    	je     8010560e <sys_open+0x6e>
801056db:	e9 5c ff ff ff       	jmp    8010563c <sys_open+0x9c>

801056e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056e0:	f3 0f 1e fb          	endbr32 
801056e4:	55                   	push   %ebp
801056e5:	89 e5                	mov    %esp,%ebp
801056e7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056ea:	e8 51 d7 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056ef:	83 ec 08             	sub    $0x8,%esp
801056f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f5:	50                   	push   %eax
801056f6:	6a 00                	push   $0x0
801056f8:	e8 e3 f6 ff ff       	call   80104de0 <argstr>
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	85 c0                	test   %eax,%eax
80105702:	78 34                	js     80105738 <sys_mkdir+0x58>
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570a:	31 c9                	xor    %ecx,%ecx
8010570c:	ba 01 00 00 00       	mov    $0x1,%edx
80105711:	6a 00                	push   $0x0
80105713:	e8 78 f7 ff ff       	call   80104e90 <create>
80105718:	83 c4 10             	add    $0x10,%esp
8010571b:	85 c0                	test   %eax,%eax
8010571d:	74 19                	je     80105738 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010571f:	83 ec 0c             	sub    $0xc,%esp
80105722:	50                   	push   %eax
80105723:	e8 d8 c2 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105728:	e8 83 d7 ff ff       	call   80102eb0 <end_op>
  return 0;
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	31 c0                	xor    %eax,%eax
}
80105732:	c9                   	leave  
80105733:	c3                   	ret    
80105734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105738:	e8 73 d7 ff ff       	call   80102eb0 <end_op>
    return -1;
8010573d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105742:	c9                   	leave  
80105743:	c3                   	ret    
80105744:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010574f:	90                   	nop

80105750 <sys_mknod>:

int
sys_mknod(void)
{
80105750:	f3 0f 1e fb          	endbr32 
80105754:	55                   	push   %ebp
80105755:	89 e5                	mov    %esp,%ebp
80105757:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010575a:	e8 e1 d6 ff ff       	call   80102e40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010575f:	83 ec 08             	sub    $0x8,%esp
80105762:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105765:	50                   	push   %eax
80105766:	6a 00                	push   $0x0
80105768:	e8 73 f6 ff ff       	call   80104de0 <argstr>
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	85 c0                	test   %eax,%eax
80105772:	78 64                	js     801057d8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105774:	83 ec 08             	sub    $0x8,%esp
80105777:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010577a:	50                   	push   %eax
8010577b:	6a 01                	push   $0x1
8010577d:	e8 ae f5 ff ff       	call   80104d30 <argint>
  if((argstr(0, &path)) < 0 ||
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	85 c0                	test   %eax,%eax
80105787:	78 4f                	js     801057d8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105789:	83 ec 08             	sub    $0x8,%esp
8010578c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010578f:	50                   	push   %eax
80105790:	6a 02                	push   $0x2
80105792:	e8 99 f5 ff ff       	call   80104d30 <argint>
     argint(1, &major) < 0 ||
80105797:	83 c4 10             	add    $0x10,%esp
8010579a:	85 c0                	test   %eax,%eax
8010579c:	78 3a                	js     801057d8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010579e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801057a2:	83 ec 0c             	sub    $0xc,%esp
801057a5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801057a9:	ba 03 00 00 00       	mov    $0x3,%edx
801057ae:	50                   	push   %eax
801057af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057b2:	e8 d9 f6 ff ff       	call   80104e90 <create>
     argint(2, &minor) < 0 ||
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	85 c0                	test   %eax,%eax
801057bc:	74 1a                	je     801057d8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057be:	83 ec 0c             	sub    $0xc,%esp
801057c1:	50                   	push   %eax
801057c2:	e8 39 c2 ff ff       	call   80101a00 <iunlockput>
  end_op();
801057c7:	e8 e4 d6 ff ff       	call   80102eb0 <end_op>
  return 0;
801057cc:	83 c4 10             	add    $0x10,%esp
801057cf:	31 c0                	xor    %eax,%eax
}
801057d1:	c9                   	leave  
801057d2:	c3                   	ret    
801057d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057d7:	90                   	nop
    end_op();
801057d8:	e8 d3 d6 ff ff       	call   80102eb0 <end_op>
    return -1;
801057dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e2:	c9                   	leave  
801057e3:	c3                   	ret    
801057e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057ef:	90                   	nop

801057f0 <sys_chdir>:

int
sys_chdir(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	56                   	push   %esi
801057f8:	53                   	push   %ebx
801057f9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057fc:	e8 9f e2 ff ff       	call   80103aa0 <myproc>
80105801:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105803:	e8 38 d6 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105808:	83 ec 08             	sub    $0x8,%esp
8010580b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010580e:	50                   	push   %eax
8010580f:	6a 00                	push   $0x0
80105811:	e8 ca f5 ff ff       	call   80104de0 <argstr>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	78 73                	js     80105890 <sys_chdir+0xa0>
8010581d:	83 ec 0c             	sub    $0xc,%esp
80105820:	ff 75 f4             	pushl  -0xc(%ebp)
80105823:	e8 08 c8 ff ff       	call   80102030 <namei>
80105828:	83 c4 10             	add    $0x10,%esp
8010582b:	89 c3                	mov    %eax,%ebx
8010582d:	85 c0                	test   %eax,%eax
8010582f:	74 5f                	je     80105890 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105831:	83 ec 0c             	sub    $0xc,%esp
80105834:	50                   	push   %eax
80105835:	e8 26 bf ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010583a:	83 c4 10             	add    $0x10,%esp
8010583d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105842:	75 2c                	jne    80105870 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	53                   	push   %ebx
80105848:	e8 f3 bf ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
8010584d:	58                   	pop    %eax
8010584e:	ff 76 68             	pushl  0x68(%esi)
80105851:	e8 3a c0 ff ff       	call   80101890 <iput>
  end_op();
80105856:	e8 55 d6 ff ff       	call   80102eb0 <end_op>
  curproc->cwd = ip;
8010585b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	31 c0                	xor    %eax,%eax
}
80105863:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105866:	5b                   	pop    %ebx
80105867:	5e                   	pop    %esi
80105868:	5d                   	pop    %ebp
80105869:	c3                   	ret    
8010586a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	53                   	push   %ebx
80105874:	e8 87 c1 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105879:	e8 32 d6 ff ff       	call   80102eb0 <end_op>
    return -1;
8010587e:	83 c4 10             	add    $0x10,%esp
80105881:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105886:	eb db                	jmp    80105863 <sys_chdir+0x73>
80105888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588f:	90                   	nop
    end_op();
80105890:	e8 1b d6 ff ff       	call   80102eb0 <end_op>
    return -1;
80105895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589a:	eb c7                	jmp    80105863 <sys_chdir+0x73>
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_exec>:

int
sys_exec(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	57                   	push   %edi
801058a8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058a9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058af:	53                   	push   %ebx
801058b0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058b6:	50                   	push   %eax
801058b7:	6a 00                	push   $0x0
801058b9:	e8 22 f5 ff ff       	call   80104de0 <argstr>
801058be:	83 c4 10             	add    $0x10,%esp
801058c1:	85 c0                	test   %eax,%eax
801058c3:	0f 88 8b 00 00 00    	js     80105954 <sys_exec+0xb4>
801058c9:	83 ec 08             	sub    $0x8,%esp
801058cc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058d2:	50                   	push   %eax
801058d3:	6a 01                	push   $0x1
801058d5:	e8 56 f4 ff ff       	call   80104d30 <argint>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	85 c0                	test   %eax,%eax
801058df:	78 73                	js     80105954 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058e1:	83 ec 04             	sub    $0x4,%esp
801058e4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801058ea:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801058ec:	68 80 00 00 00       	push   $0x80
801058f1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801058f7:	6a 00                	push   $0x0
801058f9:	50                   	push   %eax
801058fa:	e8 51 f1 ff ff       	call   80104a50 <memset>
801058ff:	83 c4 10             	add    $0x10,%esp
80105902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105908:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010590e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105915:	83 ec 08             	sub    $0x8,%esp
80105918:	57                   	push   %edi
80105919:	01 f0                	add    %esi,%eax
8010591b:	50                   	push   %eax
8010591c:	e8 6f f3 ff ff       	call   80104c90 <fetchint>
80105921:	83 c4 10             	add    $0x10,%esp
80105924:	85 c0                	test   %eax,%eax
80105926:	78 2c                	js     80105954 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105928:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010592e:	85 c0                	test   %eax,%eax
80105930:	74 36                	je     80105968 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105932:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105938:	83 ec 08             	sub    $0x8,%esp
8010593b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010593e:	52                   	push   %edx
8010593f:	50                   	push   %eax
80105940:	e8 8b f3 ff ff       	call   80104cd0 <fetchstr>
80105945:	83 c4 10             	add    $0x10,%esp
80105948:	85 c0                	test   %eax,%eax
8010594a:	78 08                	js     80105954 <sys_exec+0xb4>
  for(i=0;; i++){
8010594c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010594f:	83 fb 20             	cmp    $0x20,%ebx
80105952:	75 b4                	jne    80105908 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105954:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010595c:	5b                   	pop    %ebx
8010595d:	5e                   	pop    %esi
8010595e:	5f                   	pop    %edi
8010595f:	5d                   	pop    %ebp
80105960:	c3                   	ret    
80105961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105968:	83 ec 08             	sub    $0x8,%esp
8010596b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105971:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105978:	00 00 00 00 
  return exec(path, argv);
8010597c:	50                   	push   %eax
8010597d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105983:	e8 f8 b0 ff ff       	call   80100a80 <exec>
80105988:	83 c4 10             	add    $0x10,%esp
}
8010598b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010598e:	5b                   	pop    %ebx
8010598f:	5e                   	pop    %esi
80105990:	5f                   	pop    %edi
80105991:	5d                   	pop    %ebp
80105992:	c3                   	ret    
80105993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059a0 <sys_pipe>:

int
sys_pipe(void)
{
801059a0:	f3 0f 1e fb          	endbr32 
801059a4:	55                   	push   %ebp
801059a5:	89 e5                	mov    %esp,%ebp
801059a7:	57                   	push   %edi
801059a8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059a9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059ac:	53                   	push   %ebx
801059ad:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059b0:	6a 08                	push   $0x8
801059b2:	50                   	push   %eax
801059b3:	6a 00                	push   $0x0
801059b5:	e8 c6 f3 ff ff       	call   80104d80 <argptr>
801059ba:	83 c4 10             	add    $0x10,%esp
801059bd:	85 c0                	test   %eax,%eax
801059bf:	78 4e                	js     80105a0f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059c1:	83 ec 08             	sub    $0x8,%esp
801059c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059c7:	50                   	push   %eax
801059c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059cb:	50                   	push   %eax
801059cc:	e8 2f db ff ff       	call   80103500 <pipealloc>
801059d1:	83 c4 10             	add    $0x10,%esp
801059d4:	85 c0                	test   %eax,%eax
801059d6:	78 37                	js     80105a0f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059db:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801059dd:	e8 be e0 ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801059e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059ec:	85 f6                	test   %esi,%esi
801059ee:	74 30                	je     80105a20 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801059f0:	83 c3 01             	add    $0x1,%ebx
801059f3:	83 fb 10             	cmp    $0x10,%ebx
801059f6:	75 f0                	jne    801059e8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	ff 75 e0             	pushl  -0x20(%ebp)
801059fe:	e8 bd b4 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105a03:	58                   	pop    %eax
80105a04:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a07:	e8 b4 b4 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105a0c:	83 c4 10             	add    $0x10,%esp
80105a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a14:	eb 5b                	jmp    80105a71 <sys_pipe+0xd1>
80105a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105a20:	8d 73 08             	lea    0x8(%ebx),%esi
80105a23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a2a:	e8 71 e0 ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a2f:	31 d2                	xor    %edx,%edx
80105a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105a38:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105a3c:	85 c9                	test   %ecx,%ecx
80105a3e:	74 20                	je     80105a60 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105a40:	83 c2 01             	add    $0x1,%edx
80105a43:	83 fa 10             	cmp    $0x10,%edx
80105a46:	75 f0                	jne    80105a38 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105a48:	e8 53 e0 ff ff       	call   80103aa0 <myproc>
80105a4d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a54:	00 
80105a55:	eb a1                	jmp    801059f8 <sys_pipe+0x58>
80105a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105a60:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a67:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a6c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a6f:	31 c0                	xor    %eax,%eax
}
80105a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a74:	5b                   	pop    %ebx
80105a75:	5e                   	pop    %esi
80105a76:	5f                   	pop    %edi
80105a77:	5d                   	pop    %ebp
80105a78:	c3                   	ret    
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_swapread>:

int sys_swapread(void)
{
80105a80:	f3 0f 1e fb          	endbr32 
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
80105a87:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105a8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a8d:	68 00 10 00 00       	push   $0x1000
80105a92:	50                   	push   %eax
80105a93:	6a 00                	push   $0x0
80105a95:	e8 e6 f2 ff ff       	call   80104d80 <argptr>
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	78 2f                	js     80105ad0 <sys_swapread+0x50>
80105aa1:	83 ec 08             	sub    $0x8,%esp
80105aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aa7:	50                   	push   %eax
80105aa8:	6a 01                	push   $0x1
80105aaa:	e8 81 f2 ff ff       	call   80104d30 <argint>
80105aaf:	83 c4 10             	add    $0x10,%esp
80105ab2:	85 c0                	test   %eax,%eax
80105ab4:	78 1a                	js     80105ad0 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105ab6:	83 ec 08             	sub    $0x8,%esp
80105ab9:	ff 75 f4             	pushl  -0xc(%ebp)
80105abc:	ff 75 f0             	pushl  -0x10(%ebp)
80105abf:	e8 ac c5 ff ff       	call   80102070 <swapread>
	return 0;
80105ac4:	83 c4 10             	add    $0x10,%esp
80105ac7:	31 c0                	xor    %eax,%eax
}
80105ac9:	c9                   	leave  
80105aca:	c3                   	ret    
80105acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105acf:	90                   	nop
80105ad0:	c9                   	leave  
		return -1;
80105ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad6:	c3                   	ret    
80105ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105ae0:	f3 0f 1e fb          	endbr32 
80105ae4:	55                   	push   %ebp
80105ae5:	89 e5                	mov    %esp,%ebp
80105ae7:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105aea:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aed:	68 00 10 00 00       	push   $0x1000
80105af2:	50                   	push   %eax
80105af3:	6a 00                	push   $0x0
80105af5:	e8 86 f2 ff ff       	call   80104d80 <argptr>
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	85 c0                	test   %eax,%eax
80105aff:	78 2f                	js     80105b30 <sys_swapwrite+0x50>
80105b01:	83 ec 08             	sub    $0x8,%esp
80105b04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b07:	50                   	push   %eax
80105b08:	6a 01                	push   $0x1
80105b0a:	e8 21 f2 ff ff       	call   80104d30 <argint>
80105b0f:	83 c4 10             	add    $0x10,%esp
80105b12:	85 c0                	test   %eax,%eax
80105b14:	78 1a                	js     80105b30 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105b16:	83 ec 08             	sub    $0x8,%esp
80105b19:	ff 75 f4             	pushl  -0xc(%ebp)
80105b1c:	ff 75 f0             	pushl  -0x10(%ebp)
80105b1f:	e8 cc c5 ff ff       	call   801020f0 <swapwrite>
	return 0;
80105b24:	83 c4 10             	add    $0x10,%esp
80105b27:	31 c0                	xor    %eax,%eax
}
80105b29:	c9                   	leave  
80105b2a:	c3                   	ret    
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop
80105b30:	c9                   	leave  
		return -1;
80105b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b36:	c3                   	ret    
80105b37:	66 90                	xchg   %ax,%ax
80105b39:	66 90                	xchg   %ax,%ax
80105b3b:	66 90                	xchg   %ax,%ax
80105b3d:	66 90                	xchg   %ax,%ax
80105b3f:	90                   	nop

80105b40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105b40:	f3 0f 1e fb          	endbr32 
  return fork();
80105b44:	e9 17 e1 ff ff       	jmp    80103c60 <fork>
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b50 <sys_exit>:
}

int
sys_exit(void)
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
80105b55:	89 e5                	mov    %esp,%ebp
80105b57:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b5a:	e8 81 e3 ff ff       	call   80103ee0 <exit>
  return 0;  // not reached
}
80105b5f:	31 c0                	xor    %eax,%eax
80105b61:	c9                   	leave  
80105b62:	c3                   	ret    
80105b63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b70 <sys_wait>:

int
sys_wait(void)
{
80105b70:	f3 0f 1e fb          	endbr32 
  return wait();
80105b74:	e9 c7 e5 ff ff       	jmp    80104140 <wait>
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b80 <sys_kill>:
}

int
sys_kill(void)
{
80105b80:	f3 0f 1e fb          	endbr32 
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
80105b87:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b8d:	50                   	push   %eax
80105b8e:	6a 00                	push   $0x0
80105b90:	e8 9b f1 ff ff       	call   80104d30 <argint>
80105b95:	83 c4 10             	add    $0x10,%esp
80105b98:	85 c0                	test   %eax,%eax
80105b9a:	78 14                	js     80105bb0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b9c:	83 ec 0c             	sub    $0xc,%esp
80105b9f:	ff 75 f4             	pushl  -0xc(%ebp)
80105ba2:	e8 09 e7 ff ff       	call   801042b0 <kill>
80105ba7:	83 c4 10             	add    $0x10,%esp
}
80105baa:	c9                   	leave  
80105bab:	c3                   	ret    
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bb0:	c9                   	leave  
    return -1;
80105bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bb6:	c3                   	ret    
80105bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <sys_getpid>:

int
sys_getpid(void)
{
80105bc0:	f3 0f 1e fb          	endbr32 
80105bc4:	55                   	push   %ebp
80105bc5:	89 e5                	mov    %esp,%ebp
80105bc7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105bca:	e8 d1 de ff ff       	call   80103aa0 <myproc>
80105bcf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105bd2:	c9                   	leave  
80105bd3:	c3                   	ret    
80105bd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop

80105be0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105be8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105beb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bee:	50                   	push   %eax
80105bef:	6a 00                	push   $0x0
80105bf1:	e8 3a f1 ff ff       	call   80104d30 <argint>
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	78 23                	js     80105c20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105bfd:	e8 9e de ff ff       	call   80103aa0 <myproc>
  if(growproc(n) < 0)
80105c02:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c05:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c07:	ff 75 f4             	pushl  -0xc(%ebp)
80105c0a:	e8 d1 df ff ff       	call   80103be0 <growproc>
80105c0f:	83 c4 10             	add    $0x10,%esp
80105c12:	85 c0                	test   %eax,%eax
80105c14:	78 0a                	js     80105c20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c16:	89 d8                	mov    %ebx,%eax
80105c18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c1b:	c9                   	leave  
80105c1c:	c3                   	ret    
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c25:	eb ef                	jmp    80105c16 <sys_sbrk+0x36>
80105c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <sys_sleep>:

int
sys_sleep(void)
{
80105c30:	f3 0f 1e fb          	endbr32 
80105c34:	55                   	push   %ebp
80105c35:	89 e5                	mov    %esp,%ebp
80105c37:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c38:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c3b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c3e:	50                   	push   %eax
80105c3f:	6a 00                	push   $0x0
80105c41:	e8 ea f0 ff ff       	call   80104d30 <argint>
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	0f 88 86 00 00 00    	js     80105cd7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c51:	83 ec 0c             	sub    $0xc,%esp
80105c54:	68 60 61 11 80       	push   $0x80116160
80105c59:	e8 e2 ec ff ff       	call   80104940 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c61:	8b 1d a0 69 11 80    	mov    0x801169a0,%ebx
  while(ticks - ticks0 < n){
80105c67:	83 c4 10             	add    $0x10,%esp
80105c6a:	85 d2                	test   %edx,%edx
80105c6c:	75 23                	jne    80105c91 <sys_sleep+0x61>
80105c6e:	eb 50                	jmp    80105cc0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c70:	83 ec 08             	sub    $0x8,%esp
80105c73:	68 60 61 11 80       	push   $0x80116160
80105c78:	68 a0 69 11 80       	push   $0x801169a0
80105c7d:	e8 fe e3 ff ff       	call   80104080 <sleep>
  while(ticks - ticks0 < n){
80105c82:	a1 a0 69 11 80       	mov    0x801169a0,%eax
80105c87:	83 c4 10             	add    $0x10,%esp
80105c8a:	29 d8                	sub    %ebx,%eax
80105c8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c8f:	73 2f                	jae    80105cc0 <sys_sleep+0x90>
    if(myproc()->killed){
80105c91:	e8 0a de ff ff       	call   80103aa0 <myproc>
80105c96:	8b 40 24             	mov    0x24(%eax),%eax
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	74 d3                	je     80105c70 <sys_sleep+0x40>
      release(&tickslock);
80105c9d:	83 ec 0c             	sub    $0xc,%esp
80105ca0:	68 60 61 11 80       	push   $0x80116160
80105ca5:	e8 56 ed ff ff       	call   80104a00 <release>
  }
  release(&tickslock);
  return 0;
}
80105caa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105cad:	83 c4 10             	add    $0x10,%esp
80105cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb5:	c9                   	leave  
80105cb6:	c3                   	ret    
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	68 60 61 11 80       	push   $0x80116160
80105cc8:	e8 33 ed ff ff       	call   80104a00 <release>
  return 0;
80105ccd:	83 c4 10             	add    $0x10,%esp
80105cd0:	31 c0                	xor    %eax,%eax
}
80105cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cd5:	c9                   	leave  
80105cd6:	c3                   	ret    
    return -1;
80105cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdc:	eb f4                	jmp    80105cd2 <sys_sleep+0xa2>
80105cde:	66 90                	xchg   %ax,%ax

80105ce0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ce0:	f3 0f 1e fb          	endbr32 
80105ce4:	55                   	push   %ebp
80105ce5:	89 e5                	mov    %esp,%ebp
80105ce7:	53                   	push   %ebx
80105ce8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ceb:	68 60 61 11 80       	push   $0x80116160
80105cf0:	e8 4b ec ff ff       	call   80104940 <acquire>
  xticks = ticks;
80105cf5:	8b 1d a0 69 11 80    	mov    0x801169a0,%ebx
  release(&tickslock);
80105cfb:	c7 04 24 60 61 11 80 	movl   $0x80116160,(%esp)
80105d02:	e8 f9 ec ff ff       	call   80104a00 <release>
  return xticks;
}
80105d07:	89 d8                	mov    %ebx,%eax
80105d09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d0c:	c9                   	leave  
80105d0d:	c3                   	ret    
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <sys_setnice>:

// My Code
int sys_setnice(void){
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	83 ec 20             	sub    $0x20,%esp
	int pid, nice;
	if(argint(0,&pid)<0)
80105d1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d1d:	50                   	push   %eax
80105d1e:	6a 00                	push   $0x0
80105d20:	e8 0b f0 ff ff       	call   80104d30 <argint>
80105d25:	83 c4 10             	add    $0x10,%esp
80105d28:	85 c0                	test   %eax,%eax
80105d2a:	78 34                	js     80105d60 <sys_setnice+0x50>
		return -1;
	if(argint(1,&nice)<0)
80105d2c:	83 ec 08             	sub    $0x8,%esp
80105d2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d32:	50                   	push   %eax
80105d33:	6a 01                	push   $0x1
80105d35:	e8 f6 ef ff ff       	call   80104d30 <argint>
80105d3a:	83 c4 10             	add    $0x10,%esp
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	78 1f                	js     80105d60 <sys_setnice+0x50>
		return -1;
	if(nice<0||nice>10)
80105d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d44:	83 f8 0a             	cmp    $0xa,%eax
80105d47:	77 17                	ja     80105d60 <sys_setnice+0x50>
		return -1;
	int ret = setnice(pid,nice);
80105d49:	83 ec 08             	sub    $0x8,%esp
80105d4c:	50                   	push   %eax
80105d4d:	ff 75 f0             	pushl  -0x10(%ebp)
80105d50:	e8 cb e6 ff ff       	call   80104420 <setnice>
	return ret;
80105d55:	83 c4 10             	add    $0x10,%esp
}
80105d58:	c9                   	leave  
80105d59:	c3                   	ret    
80105d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d60:	c9                   	leave  
		return -1;
80105d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d66:	c3                   	ret    
80105d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <sys_getnice>:

int sys_getnice(void){
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	83 ec 20             	sub    $0x20,%esp
	int pid;	
	if(argint(0,&pid)<0)
80105d7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d7d:	50                   	push   %eax
80105d7e:	6a 00                	push   $0x0
80105d80:	e8 ab ef ff ff       	call   80104d30 <argint>
80105d85:	83 c4 10             	add    $0x10,%esp
80105d88:	85 c0                	test   %eax,%eax
80105d8a:	78 14                	js     80105da0 <sys_getnice+0x30>
		return -1;
	int ret = getnice(pid);
80105d8c:	83 ec 0c             	sub    $0xc,%esp
80105d8f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d92:	e8 19 e7 ff ff       	call   801044b0 <getnice>
	return ret;
80105d97:	83 c4 10             	add    $0x10,%esp
}
80105d9a:	c9                   	leave  
80105d9b:	c3                   	ret    
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105da0:	c9                   	leave  
		return -1;
80105da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da6:	c3                   	ret    
80105da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dae:	66 90                	xchg   %ax,%ax

80105db0 <sys_yield>:

int sys_yield(void){
80105db0:	f3 0f 1e fb          	endbr32 
80105db4:	55                   	push   %ebp
80105db5:	89 e5                	mov    %esp,%ebp
80105db7:	83 ec 08             	sub    $0x8,%esp
	yield();
80105dba:	e8 71 e2 ff ff       	call   80104030 <yield>
	return 0;
}
80105dbf:	31 c0                	xor    %eax,%eax
80105dc1:	c9                   	leave  
80105dc2:	c3                   	ret    
80105dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105dd0 <sys_ps>:

int sys_ps(void){
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	83 ec 08             	sub    $0x8,%esp
	ps();
80105dda:	e8 41 e7 ff ff       	call   80104520 <ps>
	return 0;
}
80105ddf:	31 c0                	xor    %eax,%eax
80105de1:	c9                   	leave  
80105de2:	c3                   	ret    

80105de3 <alltraps>:
80105de3:	1e                   	push   %ds
80105de4:	06                   	push   %es
80105de5:	0f a0                	push   %fs
80105de7:	0f a8                	push   %gs
80105de9:	60                   	pusha  
80105dea:	66 b8 10 00          	mov    $0x10,%ax
80105dee:	8e d8                	mov    %eax,%ds
80105df0:	8e c0                	mov    %eax,%es
80105df2:	54                   	push   %esp
80105df3:	e8 c8 00 00 00       	call   80105ec0 <trap>
80105df8:	83 c4 04             	add    $0x4,%esp

80105dfb <trapret>:
80105dfb:	61                   	popa   
80105dfc:	0f a9                	pop    %gs
80105dfe:	0f a1                	pop    %fs
80105e00:	07                   	pop    %es
80105e01:	1f                   	pop    %ds
80105e02:	83 c4 08             	add    $0x8,%esp
80105e05:	cf                   	iret   
80105e06:	66 90                	xchg   %ax,%ax
80105e08:	66 90                	xchg   %ax,%ax
80105e0a:	66 90                	xchg   %ax,%ax
80105e0c:	66 90                	xchg   %ax,%ax
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e15:	31 c0                	xor    %eax,%eax
{
80105e17:	89 e5                	mov    %esp,%ebp
80105e19:	83 ec 08             	sub    $0x8,%esp
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e20:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e27:	c7 04 c5 a2 61 11 80 	movl   $0x8e000008,-0x7fee9e5e(,%eax,8)
80105e2e:	08 00 00 8e 
80105e32:	66 89 14 c5 a0 61 11 	mov    %dx,-0x7fee9e60(,%eax,8)
80105e39:	80 
80105e3a:	c1 ea 10             	shr    $0x10,%edx
80105e3d:	66 89 14 c5 a6 61 11 	mov    %dx,-0x7fee9e5a(,%eax,8)
80105e44:	80 
  for(i = 0; i < 256; i++)
80105e45:	83 c0 01             	add    $0x1,%eax
80105e48:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e4d:	75 d1                	jne    80105e20 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105e4f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e52:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e57:	c7 05 a2 63 11 80 08 	movl   $0xef000008,0x801163a2
80105e5e:	00 00 ef 
  initlock(&tickslock, "time");
80105e61:	68 f1 7e 10 80       	push   $0x80107ef1
80105e66:	68 60 61 11 80       	push   $0x80116160
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e6b:	66 a3 a0 63 11 80    	mov    %ax,0x801163a0
80105e71:	c1 e8 10             	shr    $0x10,%eax
80105e74:	66 a3 a6 63 11 80    	mov    %ax,0x801163a6
  initlock(&tickslock, "time");
80105e7a:	e8 41 e9 ff ff       	call   801047c0 <initlock>
}
80105e7f:	83 c4 10             	add    $0x10,%esp
80105e82:	c9                   	leave  
80105e83:	c3                   	ret    
80105e84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e8f:	90                   	nop

80105e90 <idtinit>:

void
idtinit(void)
{
80105e90:	f3 0f 1e fb          	endbr32 
80105e94:	55                   	push   %ebp
  pd[0] = size-1;
80105e95:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e9a:	89 e5                	mov    %esp,%ebp
80105e9c:	83 ec 10             	sub    $0x10,%esp
80105e9f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ea3:	b8 a0 61 11 80       	mov    $0x801161a0,%eax
80105ea8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105eac:	c1 e8 10             	shr    $0x10,%eax
80105eaf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105eb3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105eb6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105eb9:	c9                   	leave  
80105eba:	c3                   	ret    
80105ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop

80105ec0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	57                   	push   %edi
80105ec8:	56                   	push   %esi
80105ec9:	53                   	push   %ebx
80105eca:	83 ec 1c             	sub    $0x1c,%esp
80105ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ed0:	8b 43 30             	mov    0x30(%ebx),%eax
80105ed3:	83 f8 40             	cmp    $0x40,%eax
80105ed6:	0f 84 ac 01 00 00    	je     80106088 <trap+0x1c8>
    return;
  }

  // My Code
  // cprintf("default: %d\n",tf->trapno);
  switch(tf->trapno){
80105edc:	83 e8 20             	sub    $0x20,%eax
80105edf:	83 f8 1f             	cmp    $0x1f,%eax
80105ee2:	77 08                	ja     80105eec <trap+0x2c>
80105ee4:	3e ff 24 85 98 7f 10 	notrack jmp *-0x7fef8068(,%eax,4)
80105eeb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105eec:	e8 af db ff ff       	call   80103aa0 <myproc>
80105ef1:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ef4:	85 c0                	test   %eax,%eax
80105ef6:	0f 84 ec 01 00 00    	je     801060e8 <trap+0x228>
80105efc:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f00:	0f 84 e2 01 00 00    	je     801060e8 <trap+0x228>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f06:	0f 20 d1             	mov    %cr2,%ecx
80105f09:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f0c:	e8 6f db ff ff       	call   80103a80 <cpuid>
80105f11:	8b 73 30             	mov    0x30(%ebx),%esi
80105f14:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f17:	8b 43 34             	mov    0x34(%ebx),%eax
80105f1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f1d:	e8 7e db ff ff       	call   80103aa0 <myproc>
80105f22:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f25:	e8 76 db ff ff       	call   80103aa0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f2a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f30:	51                   	push   %ecx
80105f31:	57                   	push   %edi
80105f32:	52                   	push   %edx
80105f33:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f36:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f37:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105f3a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f3d:	56                   	push   %esi
80105f3e:	ff 70 10             	pushl  0x10(%eax)
80105f41:	68 54 7f 10 80       	push   $0x80107f54
80105f46:	e8 65 a7 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f4b:	83 c4 20             	add    $0x20,%esp
80105f4e:	e8 4d db ff ff       	call   80103aa0 <myproc>
80105f53:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f5a:	e8 41 db ff ff       	call   80103aa0 <myproc>
80105f5f:	85 c0                	test   %eax,%eax
80105f61:	74 1d                	je     80105f80 <trap+0xc0>
80105f63:	e8 38 db ff ff       	call   80103aa0 <myproc>
80105f68:	8b 50 24             	mov    0x24(%eax),%edx
80105f6b:	85 d2                	test   %edx,%edx
80105f6d:	74 11                	je     80105f80 <trap+0xc0>
80105f6f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f73:	83 e0 03             	and    $0x3,%eax
80105f76:	66 83 f8 03          	cmp    $0x3,%ax
80105f7a:	0f 84 40 01 00 00    	je     801060c0 <trap+0x200>
 /* if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
*/
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f80:	e8 1b db ff ff       	call   80103aa0 <myproc>
80105f85:	85 c0                	test   %eax,%eax
80105f87:	74 1d                	je     80105fa6 <trap+0xe6>
80105f89:	e8 12 db ff ff       	call   80103aa0 <myproc>
80105f8e:	8b 40 24             	mov    0x24(%eax),%eax
80105f91:	85 c0                	test   %eax,%eax
80105f93:	74 11                	je     80105fa6 <trap+0xe6>
80105f95:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f99:	83 e0 03             	and    $0x3,%eax
80105f9c:	66 83 f8 03          	cmp    $0x3,%ax
80105fa0:	0f 84 0b 01 00 00    	je     801060b1 <trap+0x1f1>
    exit();
}
80105fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa9:	5b                   	pop    %ebx
80105faa:	5e                   	pop    %esi
80105fab:	5f                   	pop    %edi
80105fac:	5d                   	pop    %ebp
80105fad:	c3                   	ret    
    ideintr();
80105fae:	e8 3d c3 ff ff       	call   801022f0 <ideintr>
    lapiceoi();
80105fb3:	e8 18 ca ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fb8:	e8 e3 da ff ff       	call   80103aa0 <myproc>
80105fbd:	85 c0                	test   %eax,%eax
80105fbf:	75 a2                	jne    80105f63 <trap+0xa3>
80105fc1:	eb bd                	jmp    80105f80 <trap+0xc0>
    if(cpuid() == 0){
80105fc3:	e8 b8 da ff ff       	call   80103a80 <cpuid>
80105fc8:	85 c0                	test   %eax,%eax
80105fca:	75 e7                	jne    80105fb3 <trap+0xf3>
      acquire(&tickslock);
80105fcc:	83 ec 0c             	sub    $0xc,%esp
80105fcf:	68 60 61 11 80       	push   $0x80116160
80105fd4:	e8 67 e9 ff ff       	call   80104940 <acquire>
      ticks++;
80105fd9:	83 05 a0 69 11 80 01 	addl   $0x1,0x801169a0
     if(myproc()!=0 && myproc()->state == RUNNING)
80105fe0:	e8 bb da ff ff       	call   80103aa0 <myproc>
80105fe5:	83 c4 10             	add    $0x10,%esp
80105fe8:	85 c0                	test   %eax,%eax
80105fea:	74 0f                	je     80105ffb <trap+0x13b>
80105fec:	e8 af da ff ff       	call   80103aa0 <myproc>
80105ff1:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ff5:	0f 84 dc 00 00 00    	je     801060d7 <trap+0x217>
      wakeup(&ticks);
80105ffb:	83 ec 0c             	sub    $0xc,%esp
80105ffe:	68 a0 69 11 80       	push   $0x801169a0
80106003:	e8 38 e2 ff ff       	call   80104240 <wakeup>
      release(&tickslock);
80106008:	c7 04 24 60 61 11 80 	movl   $0x80116160,(%esp)
8010600f:	e8 ec e9 ff ff       	call   80104a00 <release>
80106014:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106017:	eb 9a                	jmp    80105fb3 <trap+0xf3>
    kbdintr();
80106019:	e8 72 c8 ff ff       	call   80102890 <kbdintr>
    lapiceoi();
8010601e:	e8 ad c9 ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106023:	e8 78 da ff ff       	call   80103aa0 <myproc>
80106028:	85 c0                	test   %eax,%eax
8010602a:	0f 85 33 ff ff ff    	jne    80105f63 <trap+0xa3>
80106030:	e9 4b ff ff ff       	jmp    80105f80 <trap+0xc0>
    uartintr();
80106035:	e8 46 02 00 00       	call   80106280 <uartintr>
    lapiceoi();
8010603a:	e8 91 c9 ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010603f:	e8 5c da ff ff       	call   80103aa0 <myproc>
80106044:	85 c0                	test   %eax,%eax
80106046:	0f 85 17 ff ff ff    	jne    80105f63 <trap+0xa3>
8010604c:	e9 2f ff ff ff       	jmp    80105f80 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106051:	8b 7b 38             	mov    0x38(%ebx),%edi
80106054:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106058:	e8 23 da ff ff       	call   80103a80 <cpuid>
8010605d:	57                   	push   %edi
8010605e:	56                   	push   %esi
8010605f:	50                   	push   %eax
80106060:	68 fc 7e 10 80       	push   $0x80107efc
80106065:	e8 46 a6 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
8010606a:	e8 61 c9 ff ff       	call   801029d0 <lapiceoi>
    break;
8010606f:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106072:	e8 29 da ff ff       	call   80103aa0 <myproc>
80106077:	85 c0                	test   %eax,%eax
80106079:	0f 85 e4 fe ff ff    	jne    80105f63 <trap+0xa3>
8010607f:	e9 fc fe ff ff       	jmp    80105f80 <trap+0xc0>
80106084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106088:	e8 13 da ff ff       	call   80103aa0 <myproc>
8010608d:	8b 70 24             	mov    0x24(%eax),%esi
80106090:	85 f6                	test   %esi,%esi
80106092:	75 3c                	jne    801060d0 <trap+0x210>
    myproc()->tf = tf;
80106094:	e8 07 da ff ff       	call   80103aa0 <myproc>
80106099:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010609c:	e8 7f ed ff ff       	call   80104e20 <syscall>
    if(myproc()->killed)
801060a1:	e8 fa d9 ff ff       	call   80103aa0 <myproc>
801060a6:	8b 48 24             	mov    0x24(%eax),%ecx
801060a9:	85 c9                	test   %ecx,%ecx
801060ab:	0f 84 f5 fe ff ff    	je     80105fa6 <trap+0xe6>
}
801060b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b4:	5b                   	pop    %ebx
801060b5:	5e                   	pop    %esi
801060b6:	5f                   	pop    %edi
801060b7:	5d                   	pop    %ebp
      exit();
801060b8:	e9 23 de ff ff       	jmp    80103ee0 <exit>
801060bd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801060c0:	e8 1b de ff ff       	call   80103ee0 <exit>
801060c5:	e9 b6 fe ff ff       	jmp    80105f80 <trap+0xc0>
801060ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801060d0:	e8 0b de ff ff       	call   80103ee0 <exit>
801060d5:	eb bd                	jmp    80106094 <trap+0x1d4>
	     myproc()->runtime++;
801060d7:	e8 c4 d9 ff ff       	call   80103aa0 <myproc>
801060dc:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
801060e3:	e9 13 ff ff ff       	jmp    80105ffb <trap+0x13b>
801060e8:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060eb:	e8 90 d9 ff ff       	call   80103a80 <cpuid>
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	56                   	push   %esi
801060f4:	57                   	push   %edi
801060f5:	50                   	push   %eax
801060f6:	ff 73 30             	pushl  0x30(%ebx)
801060f9:	68 20 7f 10 80       	push   $0x80107f20
801060fe:	e8 ad a5 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106103:	83 c4 14             	add    $0x14,%esp
80106106:	68 f6 7e 10 80       	push   $0x80107ef6
8010610b:	e8 80 a2 ff ff       	call   80100390 <panic>

80106110 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106110:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106114:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106119:	85 c0                	test   %eax,%eax
8010611b:	74 1b                	je     80106138 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010611d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106122:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106123:	a8 01                	test   $0x1,%al
80106125:	74 11                	je     80106138 <uartgetc+0x28>
80106127:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010612c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010612d:	0f b6 c0             	movzbl %al,%eax
80106130:	c3                   	ret    
80106131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010613d:	c3                   	ret    
8010613e:	66 90                	xchg   %ax,%ax

80106140 <uartputc.part.0>:
uartputc(int c)
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	57                   	push   %edi
80106144:	89 c7                	mov    %eax,%edi
80106146:	56                   	push   %esi
80106147:	be fd 03 00 00       	mov    $0x3fd,%esi
8010614c:	53                   	push   %ebx
8010614d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106152:	83 ec 0c             	sub    $0xc,%esp
80106155:	eb 1b                	jmp    80106172 <uartputc.part.0+0x32>
80106157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010615e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	6a 0a                	push   $0xa
80106165:	e8 86 c8 ff ff       	call   801029f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010616a:	83 c4 10             	add    $0x10,%esp
8010616d:	83 eb 01             	sub    $0x1,%ebx
80106170:	74 07                	je     80106179 <uartputc.part.0+0x39>
80106172:	89 f2                	mov    %esi,%edx
80106174:	ec                   	in     (%dx),%al
80106175:	a8 20                	test   $0x20,%al
80106177:	74 e7                	je     80106160 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106179:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010617e:	89 f8                	mov    %edi,%eax
80106180:	ee                   	out    %al,(%dx)
}
80106181:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106184:	5b                   	pop    %ebx
80106185:	5e                   	pop    %esi
80106186:	5f                   	pop    %edi
80106187:	5d                   	pop    %ebp
80106188:	c3                   	ret    
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106190 <uartinit>:
{
80106190:	f3 0f 1e fb          	endbr32 
80106194:	55                   	push   %ebp
80106195:	31 c9                	xor    %ecx,%ecx
80106197:	89 c8                	mov    %ecx,%eax
80106199:	89 e5                	mov    %esp,%ebp
8010619b:	57                   	push   %edi
8010619c:	56                   	push   %esi
8010619d:	53                   	push   %ebx
8010619e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801061a3:	89 da                	mov    %ebx,%edx
801061a5:	83 ec 0c             	sub    $0xc,%esp
801061a8:	ee                   	out    %al,(%dx)
801061a9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801061ae:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801061b3:	89 fa                	mov    %edi,%edx
801061b5:	ee                   	out    %al,(%dx)
801061b6:	b8 0c 00 00 00       	mov    $0xc,%eax
801061bb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061c0:	ee                   	out    %al,(%dx)
801061c1:	be f9 03 00 00       	mov    $0x3f9,%esi
801061c6:	89 c8                	mov    %ecx,%eax
801061c8:	89 f2                	mov    %esi,%edx
801061ca:	ee                   	out    %al,(%dx)
801061cb:	b8 03 00 00 00       	mov    $0x3,%eax
801061d0:	89 fa                	mov    %edi,%edx
801061d2:	ee                   	out    %al,(%dx)
801061d3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801061d8:	89 c8                	mov    %ecx,%eax
801061da:	ee                   	out    %al,(%dx)
801061db:	b8 01 00 00 00       	mov    $0x1,%eax
801061e0:	89 f2                	mov    %esi,%edx
801061e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061e3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061e8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801061e9:	3c ff                	cmp    $0xff,%al
801061eb:	74 52                	je     8010623f <uartinit+0xaf>
  uart = 1;
801061ed:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801061f4:	00 00 00 
801061f7:	89 da                	mov    %ebx,%edx
801061f9:	ec                   	in     (%dx),%al
801061fa:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061ff:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106200:	83 ec 08             	sub    $0x8,%esp
80106203:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106208:	bb 18 80 10 80       	mov    $0x80108018,%ebx
  ioapicenable(IRQ_COM1, 0);
8010620d:	6a 00                	push   $0x0
8010620f:	6a 04                	push   $0x4
80106211:	e8 2a c3 ff ff       	call   80102540 <ioapicenable>
80106216:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106219:	b8 78 00 00 00       	mov    $0x78,%eax
8010621e:	eb 04                	jmp    80106224 <uartinit+0x94>
80106220:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106224:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010622a:	85 d2                	test   %edx,%edx
8010622c:	74 08                	je     80106236 <uartinit+0xa6>
    uartputc(*p);
8010622e:	0f be c0             	movsbl %al,%eax
80106231:	e8 0a ff ff ff       	call   80106140 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106236:	89 f0                	mov    %esi,%eax
80106238:	83 c3 01             	add    $0x1,%ebx
8010623b:	84 c0                	test   %al,%al
8010623d:	75 e1                	jne    80106220 <uartinit+0x90>
}
8010623f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106242:	5b                   	pop    %ebx
80106243:	5e                   	pop    %esi
80106244:	5f                   	pop    %edi
80106245:	5d                   	pop    %ebp
80106246:	c3                   	ret    
80106247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624e:	66 90                	xchg   %ax,%ax

80106250 <uartputc>:
{
80106250:	f3 0f 1e fb          	endbr32 
80106254:	55                   	push   %ebp
  if(!uart)
80106255:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010625b:	89 e5                	mov    %esp,%ebp
8010625d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106260:	85 d2                	test   %edx,%edx
80106262:	74 0c                	je     80106270 <uartputc+0x20>
}
80106264:	5d                   	pop    %ebp
80106265:	e9 d6 fe ff ff       	jmp    80106140 <uartputc.part.0>
8010626a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106270:	5d                   	pop    %ebp
80106271:	c3                   	ret    
80106272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106280 <uartintr>:

void
uartintr(void)
{
80106280:	f3 0f 1e fb          	endbr32 
80106284:	55                   	push   %ebp
80106285:	89 e5                	mov    %esp,%ebp
80106287:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010628a:	68 10 61 10 80       	push   $0x80106110
8010628f:	e8 cc a5 ff ff       	call   80100860 <consoleintr>
}
80106294:	83 c4 10             	add    $0x10,%esp
80106297:	c9                   	leave  
80106298:	c3                   	ret    

80106299 <vector0>:
80106299:	6a 00                	push   $0x0
8010629b:	6a 00                	push   $0x0
8010629d:	e9 41 fb ff ff       	jmp    80105de3 <alltraps>

801062a2 <vector1>:
801062a2:	6a 00                	push   $0x0
801062a4:	6a 01                	push   $0x1
801062a6:	e9 38 fb ff ff       	jmp    80105de3 <alltraps>

801062ab <vector2>:
801062ab:	6a 00                	push   $0x0
801062ad:	6a 02                	push   $0x2
801062af:	e9 2f fb ff ff       	jmp    80105de3 <alltraps>

801062b4 <vector3>:
801062b4:	6a 00                	push   $0x0
801062b6:	6a 03                	push   $0x3
801062b8:	e9 26 fb ff ff       	jmp    80105de3 <alltraps>

801062bd <vector4>:
801062bd:	6a 00                	push   $0x0
801062bf:	6a 04                	push   $0x4
801062c1:	e9 1d fb ff ff       	jmp    80105de3 <alltraps>

801062c6 <vector5>:
801062c6:	6a 00                	push   $0x0
801062c8:	6a 05                	push   $0x5
801062ca:	e9 14 fb ff ff       	jmp    80105de3 <alltraps>

801062cf <vector6>:
801062cf:	6a 00                	push   $0x0
801062d1:	6a 06                	push   $0x6
801062d3:	e9 0b fb ff ff       	jmp    80105de3 <alltraps>

801062d8 <vector7>:
801062d8:	6a 00                	push   $0x0
801062da:	6a 07                	push   $0x7
801062dc:	e9 02 fb ff ff       	jmp    80105de3 <alltraps>

801062e1 <vector8>:
801062e1:	6a 08                	push   $0x8
801062e3:	e9 fb fa ff ff       	jmp    80105de3 <alltraps>

801062e8 <vector9>:
801062e8:	6a 00                	push   $0x0
801062ea:	6a 09                	push   $0x9
801062ec:	e9 f2 fa ff ff       	jmp    80105de3 <alltraps>

801062f1 <vector10>:
801062f1:	6a 0a                	push   $0xa
801062f3:	e9 eb fa ff ff       	jmp    80105de3 <alltraps>

801062f8 <vector11>:
801062f8:	6a 0b                	push   $0xb
801062fa:	e9 e4 fa ff ff       	jmp    80105de3 <alltraps>

801062ff <vector12>:
801062ff:	6a 0c                	push   $0xc
80106301:	e9 dd fa ff ff       	jmp    80105de3 <alltraps>

80106306 <vector13>:
80106306:	6a 0d                	push   $0xd
80106308:	e9 d6 fa ff ff       	jmp    80105de3 <alltraps>

8010630d <vector14>:
8010630d:	6a 0e                	push   $0xe
8010630f:	e9 cf fa ff ff       	jmp    80105de3 <alltraps>

80106314 <vector15>:
80106314:	6a 00                	push   $0x0
80106316:	6a 0f                	push   $0xf
80106318:	e9 c6 fa ff ff       	jmp    80105de3 <alltraps>

8010631d <vector16>:
8010631d:	6a 00                	push   $0x0
8010631f:	6a 10                	push   $0x10
80106321:	e9 bd fa ff ff       	jmp    80105de3 <alltraps>

80106326 <vector17>:
80106326:	6a 11                	push   $0x11
80106328:	e9 b6 fa ff ff       	jmp    80105de3 <alltraps>

8010632d <vector18>:
8010632d:	6a 00                	push   $0x0
8010632f:	6a 12                	push   $0x12
80106331:	e9 ad fa ff ff       	jmp    80105de3 <alltraps>

80106336 <vector19>:
80106336:	6a 00                	push   $0x0
80106338:	6a 13                	push   $0x13
8010633a:	e9 a4 fa ff ff       	jmp    80105de3 <alltraps>

8010633f <vector20>:
8010633f:	6a 00                	push   $0x0
80106341:	6a 14                	push   $0x14
80106343:	e9 9b fa ff ff       	jmp    80105de3 <alltraps>

80106348 <vector21>:
80106348:	6a 00                	push   $0x0
8010634a:	6a 15                	push   $0x15
8010634c:	e9 92 fa ff ff       	jmp    80105de3 <alltraps>

80106351 <vector22>:
80106351:	6a 00                	push   $0x0
80106353:	6a 16                	push   $0x16
80106355:	e9 89 fa ff ff       	jmp    80105de3 <alltraps>

8010635a <vector23>:
8010635a:	6a 00                	push   $0x0
8010635c:	6a 17                	push   $0x17
8010635e:	e9 80 fa ff ff       	jmp    80105de3 <alltraps>

80106363 <vector24>:
80106363:	6a 00                	push   $0x0
80106365:	6a 18                	push   $0x18
80106367:	e9 77 fa ff ff       	jmp    80105de3 <alltraps>

8010636c <vector25>:
8010636c:	6a 00                	push   $0x0
8010636e:	6a 19                	push   $0x19
80106370:	e9 6e fa ff ff       	jmp    80105de3 <alltraps>

80106375 <vector26>:
80106375:	6a 00                	push   $0x0
80106377:	6a 1a                	push   $0x1a
80106379:	e9 65 fa ff ff       	jmp    80105de3 <alltraps>

8010637e <vector27>:
8010637e:	6a 00                	push   $0x0
80106380:	6a 1b                	push   $0x1b
80106382:	e9 5c fa ff ff       	jmp    80105de3 <alltraps>

80106387 <vector28>:
80106387:	6a 00                	push   $0x0
80106389:	6a 1c                	push   $0x1c
8010638b:	e9 53 fa ff ff       	jmp    80105de3 <alltraps>

80106390 <vector29>:
80106390:	6a 00                	push   $0x0
80106392:	6a 1d                	push   $0x1d
80106394:	e9 4a fa ff ff       	jmp    80105de3 <alltraps>

80106399 <vector30>:
80106399:	6a 00                	push   $0x0
8010639b:	6a 1e                	push   $0x1e
8010639d:	e9 41 fa ff ff       	jmp    80105de3 <alltraps>

801063a2 <vector31>:
801063a2:	6a 00                	push   $0x0
801063a4:	6a 1f                	push   $0x1f
801063a6:	e9 38 fa ff ff       	jmp    80105de3 <alltraps>

801063ab <vector32>:
801063ab:	6a 00                	push   $0x0
801063ad:	6a 20                	push   $0x20
801063af:	e9 2f fa ff ff       	jmp    80105de3 <alltraps>

801063b4 <vector33>:
801063b4:	6a 00                	push   $0x0
801063b6:	6a 21                	push   $0x21
801063b8:	e9 26 fa ff ff       	jmp    80105de3 <alltraps>

801063bd <vector34>:
801063bd:	6a 00                	push   $0x0
801063bf:	6a 22                	push   $0x22
801063c1:	e9 1d fa ff ff       	jmp    80105de3 <alltraps>

801063c6 <vector35>:
801063c6:	6a 00                	push   $0x0
801063c8:	6a 23                	push   $0x23
801063ca:	e9 14 fa ff ff       	jmp    80105de3 <alltraps>

801063cf <vector36>:
801063cf:	6a 00                	push   $0x0
801063d1:	6a 24                	push   $0x24
801063d3:	e9 0b fa ff ff       	jmp    80105de3 <alltraps>

801063d8 <vector37>:
801063d8:	6a 00                	push   $0x0
801063da:	6a 25                	push   $0x25
801063dc:	e9 02 fa ff ff       	jmp    80105de3 <alltraps>

801063e1 <vector38>:
801063e1:	6a 00                	push   $0x0
801063e3:	6a 26                	push   $0x26
801063e5:	e9 f9 f9 ff ff       	jmp    80105de3 <alltraps>

801063ea <vector39>:
801063ea:	6a 00                	push   $0x0
801063ec:	6a 27                	push   $0x27
801063ee:	e9 f0 f9 ff ff       	jmp    80105de3 <alltraps>

801063f3 <vector40>:
801063f3:	6a 00                	push   $0x0
801063f5:	6a 28                	push   $0x28
801063f7:	e9 e7 f9 ff ff       	jmp    80105de3 <alltraps>

801063fc <vector41>:
801063fc:	6a 00                	push   $0x0
801063fe:	6a 29                	push   $0x29
80106400:	e9 de f9 ff ff       	jmp    80105de3 <alltraps>

80106405 <vector42>:
80106405:	6a 00                	push   $0x0
80106407:	6a 2a                	push   $0x2a
80106409:	e9 d5 f9 ff ff       	jmp    80105de3 <alltraps>

8010640e <vector43>:
8010640e:	6a 00                	push   $0x0
80106410:	6a 2b                	push   $0x2b
80106412:	e9 cc f9 ff ff       	jmp    80105de3 <alltraps>

80106417 <vector44>:
80106417:	6a 00                	push   $0x0
80106419:	6a 2c                	push   $0x2c
8010641b:	e9 c3 f9 ff ff       	jmp    80105de3 <alltraps>

80106420 <vector45>:
80106420:	6a 00                	push   $0x0
80106422:	6a 2d                	push   $0x2d
80106424:	e9 ba f9 ff ff       	jmp    80105de3 <alltraps>

80106429 <vector46>:
80106429:	6a 00                	push   $0x0
8010642b:	6a 2e                	push   $0x2e
8010642d:	e9 b1 f9 ff ff       	jmp    80105de3 <alltraps>

80106432 <vector47>:
80106432:	6a 00                	push   $0x0
80106434:	6a 2f                	push   $0x2f
80106436:	e9 a8 f9 ff ff       	jmp    80105de3 <alltraps>

8010643b <vector48>:
8010643b:	6a 00                	push   $0x0
8010643d:	6a 30                	push   $0x30
8010643f:	e9 9f f9 ff ff       	jmp    80105de3 <alltraps>

80106444 <vector49>:
80106444:	6a 00                	push   $0x0
80106446:	6a 31                	push   $0x31
80106448:	e9 96 f9 ff ff       	jmp    80105de3 <alltraps>

8010644d <vector50>:
8010644d:	6a 00                	push   $0x0
8010644f:	6a 32                	push   $0x32
80106451:	e9 8d f9 ff ff       	jmp    80105de3 <alltraps>

80106456 <vector51>:
80106456:	6a 00                	push   $0x0
80106458:	6a 33                	push   $0x33
8010645a:	e9 84 f9 ff ff       	jmp    80105de3 <alltraps>

8010645f <vector52>:
8010645f:	6a 00                	push   $0x0
80106461:	6a 34                	push   $0x34
80106463:	e9 7b f9 ff ff       	jmp    80105de3 <alltraps>

80106468 <vector53>:
80106468:	6a 00                	push   $0x0
8010646a:	6a 35                	push   $0x35
8010646c:	e9 72 f9 ff ff       	jmp    80105de3 <alltraps>

80106471 <vector54>:
80106471:	6a 00                	push   $0x0
80106473:	6a 36                	push   $0x36
80106475:	e9 69 f9 ff ff       	jmp    80105de3 <alltraps>

8010647a <vector55>:
8010647a:	6a 00                	push   $0x0
8010647c:	6a 37                	push   $0x37
8010647e:	e9 60 f9 ff ff       	jmp    80105de3 <alltraps>

80106483 <vector56>:
80106483:	6a 00                	push   $0x0
80106485:	6a 38                	push   $0x38
80106487:	e9 57 f9 ff ff       	jmp    80105de3 <alltraps>

8010648c <vector57>:
8010648c:	6a 00                	push   $0x0
8010648e:	6a 39                	push   $0x39
80106490:	e9 4e f9 ff ff       	jmp    80105de3 <alltraps>

80106495 <vector58>:
80106495:	6a 00                	push   $0x0
80106497:	6a 3a                	push   $0x3a
80106499:	e9 45 f9 ff ff       	jmp    80105de3 <alltraps>

8010649e <vector59>:
8010649e:	6a 00                	push   $0x0
801064a0:	6a 3b                	push   $0x3b
801064a2:	e9 3c f9 ff ff       	jmp    80105de3 <alltraps>

801064a7 <vector60>:
801064a7:	6a 00                	push   $0x0
801064a9:	6a 3c                	push   $0x3c
801064ab:	e9 33 f9 ff ff       	jmp    80105de3 <alltraps>

801064b0 <vector61>:
801064b0:	6a 00                	push   $0x0
801064b2:	6a 3d                	push   $0x3d
801064b4:	e9 2a f9 ff ff       	jmp    80105de3 <alltraps>

801064b9 <vector62>:
801064b9:	6a 00                	push   $0x0
801064bb:	6a 3e                	push   $0x3e
801064bd:	e9 21 f9 ff ff       	jmp    80105de3 <alltraps>

801064c2 <vector63>:
801064c2:	6a 00                	push   $0x0
801064c4:	6a 3f                	push   $0x3f
801064c6:	e9 18 f9 ff ff       	jmp    80105de3 <alltraps>

801064cb <vector64>:
801064cb:	6a 00                	push   $0x0
801064cd:	6a 40                	push   $0x40
801064cf:	e9 0f f9 ff ff       	jmp    80105de3 <alltraps>

801064d4 <vector65>:
801064d4:	6a 00                	push   $0x0
801064d6:	6a 41                	push   $0x41
801064d8:	e9 06 f9 ff ff       	jmp    80105de3 <alltraps>

801064dd <vector66>:
801064dd:	6a 00                	push   $0x0
801064df:	6a 42                	push   $0x42
801064e1:	e9 fd f8 ff ff       	jmp    80105de3 <alltraps>

801064e6 <vector67>:
801064e6:	6a 00                	push   $0x0
801064e8:	6a 43                	push   $0x43
801064ea:	e9 f4 f8 ff ff       	jmp    80105de3 <alltraps>

801064ef <vector68>:
801064ef:	6a 00                	push   $0x0
801064f1:	6a 44                	push   $0x44
801064f3:	e9 eb f8 ff ff       	jmp    80105de3 <alltraps>

801064f8 <vector69>:
801064f8:	6a 00                	push   $0x0
801064fa:	6a 45                	push   $0x45
801064fc:	e9 e2 f8 ff ff       	jmp    80105de3 <alltraps>

80106501 <vector70>:
80106501:	6a 00                	push   $0x0
80106503:	6a 46                	push   $0x46
80106505:	e9 d9 f8 ff ff       	jmp    80105de3 <alltraps>

8010650a <vector71>:
8010650a:	6a 00                	push   $0x0
8010650c:	6a 47                	push   $0x47
8010650e:	e9 d0 f8 ff ff       	jmp    80105de3 <alltraps>

80106513 <vector72>:
80106513:	6a 00                	push   $0x0
80106515:	6a 48                	push   $0x48
80106517:	e9 c7 f8 ff ff       	jmp    80105de3 <alltraps>

8010651c <vector73>:
8010651c:	6a 00                	push   $0x0
8010651e:	6a 49                	push   $0x49
80106520:	e9 be f8 ff ff       	jmp    80105de3 <alltraps>

80106525 <vector74>:
80106525:	6a 00                	push   $0x0
80106527:	6a 4a                	push   $0x4a
80106529:	e9 b5 f8 ff ff       	jmp    80105de3 <alltraps>

8010652e <vector75>:
8010652e:	6a 00                	push   $0x0
80106530:	6a 4b                	push   $0x4b
80106532:	e9 ac f8 ff ff       	jmp    80105de3 <alltraps>

80106537 <vector76>:
80106537:	6a 00                	push   $0x0
80106539:	6a 4c                	push   $0x4c
8010653b:	e9 a3 f8 ff ff       	jmp    80105de3 <alltraps>

80106540 <vector77>:
80106540:	6a 00                	push   $0x0
80106542:	6a 4d                	push   $0x4d
80106544:	e9 9a f8 ff ff       	jmp    80105de3 <alltraps>

80106549 <vector78>:
80106549:	6a 00                	push   $0x0
8010654b:	6a 4e                	push   $0x4e
8010654d:	e9 91 f8 ff ff       	jmp    80105de3 <alltraps>

80106552 <vector79>:
80106552:	6a 00                	push   $0x0
80106554:	6a 4f                	push   $0x4f
80106556:	e9 88 f8 ff ff       	jmp    80105de3 <alltraps>

8010655b <vector80>:
8010655b:	6a 00                	push   $0x0
8010655d:	6a 50                	push   $0x50
8010655f:	e9 7f f8 ff ff       	jmp    80105de3 <alltraps>

80106564 <vector81>:
80106564:	6a 00                	push   $0x0
80106566:	6a 51                	push   $0x51
80106568:	e9 76 f8 ff ff       	jmp    80105de3 <alltraps>

8010656d <vector82>:
8010656d:	6a 00                	push   $0x0
8010656f:	6a 52                	push   $0x52
80106571:	e9 6d f8 ff ff       	jmp    80105de3 <alltraps>

80106576 <vector83>:
80106576:	6a 00                	push   $0x0
80106578:	6a 53                	push   $0x53
8010657a:	e9 64 f8 ff ff       	jmp    80105de3 <alltraps>

8010657f <vector84>:
8010657f:	6a 00                	push   $0x0
80106581:	6a 54                	push   $0x54
80106583:	e9 5b f8 ff ff       	jmp    80105de3 <alltraps>

80106588 <vector85>:
80106588:	6a 00                	push   $0x0
8010658a:	6a 55                	push   $0x55
8010658c:	e9 52 f8 ff ff       	jmp    80105de3 <alltraps>

80106591 <vector86>:
80106591:	6a 00                	push   $0x0
80106593:	6a 56                	push   $0x56
80106595:	e9 49 f8 ff ff       	jmp    80105de3 <alltraps>

8010659a <vector87>:
8010659a:	6a 00                	push   $0x0
8010659c:	6a 57                	push   $0x57
8010659e:	e9 40 f8 ff ff       	jmp    80105de3 <alltraps>

801065a3 <vector88>:
801065a3:	6a 00                	push   $0x0
801065a5:	6a 58                	push   $0x58
801065a7:	e9 37 f8 ff ff       	jmp    80105de3 <alltraps>

801065ac <vector89>:
801065ac:	6a 00                	push   $0x0
801065ae:	6a 59                	push   $0x59
801065b0:	e9 2e f8 ff ff       	jmp    80105de3 <alltraps>

801065b5 <vector90>:
801065b5:	6a 00                	push   $0x0
801065b7:	6a 5a                	push   $0x5a
801065b9:	e9 25 f8 ff ff       	jmp    80105de3 <alltraps>

801065be <vector91>:
801065be:	6a 00                	push   $0x0
801065c0:	6a 5b                	push   $0x5b
801065c2:	e9 1c f8 ff ff       	jmp    80105de3 <alltraps>

801065c7 <vector92>:
801065c7:	6a 00                	push   $0x0
801065c9:	6a 5c                	push   $0x5c
801065cb:	e9 13 f8 ff ff       	jmp    80105de3 <alltraps>

801065d0 <vector93>:
801065d0:	6a 00                	push   $0x0
801065d2:	6a 5d                	push   $0x5d
801065d4:	e9 0a f8 ff ff       	jmp    80105de3 <alltraps>

801065d9 <vector94>:
801065d9:	6a 00                	push   $0x0
801065db:	6a 5e                	push   $0x5e
801065dd:	e9 01 f8 ff ff       	jmp    80105de3 <alltraps>

801065e2 <vector95>:
801065e2:	6a 00                	push   $0x0
801065e4:	6a 5f                	push   $0x5f
801065e6:	e9 f8 f7 ff ff       	jmp    80105de3 <alltraps>

801065eb <vector96>:
801065eb:	6a 00                	push   $0x0
801065ed:	6a 60                	push   $0x60
801065ef:	e9 ef f7 ff ff       	jmp    80105de3 <alltraps>

801065f4 <vector97>:
801065f4:	6a 00                	push   $0x0
801065f6:	6a 61                	push   $0x61
801065f8:	e9 e6 f7 ff ff       	jmp    80105de3 <alltraps>

801065fd <vector98>:
801065fd:	6a 00                	push   $0x0
801065ff:	6a 62                	push   $0x62
80106601:	e9 dd f7 ff ff       	jmp    80105de3 <alltraps>

80106606 <vector99>:
80106606:	6a 00                	push   $0x0
80106608:	6a 63                	push   $0x63
8010660a:	e9 d4 f7 ff ff       	jmp    80105de3 <alltraps>

8010660f <vector100>:
8010660f:	6a 00                	push   $0x0
80106611:	6a 64                	push   $0x64
80106613:	e9 cb f7 ff ff       	jmp    80105de3 <alltraps>

80106618 <vector101>:
80106618:	6a 00                	push   $0x0
8010661a:	6a 65                	push   $0x65
8010661c:	e9 c2 f7 ff ff       	jmp    80105de3 <alltraps>

80106621 <vector102>:
80106621:	6a 00                	push   $0x0
80106623:	6a 66                	push   $0x66
80106625:	e9 b9 f7 ff ff       	jmp    80105de3 <alltraps>

8010662a <vector103>:
8010662a:	6a 00                	push   $0x0
8010662c:	6a 67                	push   $0x67
8010662e:	e9 b0 f7 ff ff       	jmp    80105de3 <alltraps>

80106633 <vector104>:
80106633:	6a 00                	push   $0x0
80106635:	6a 68                	push   $0x68
80106637:	e9 a7 f7 ff ff       	jmp    80105de3 <alltraps>

8010663c <vector105>:
8010663c:	6a 00                	push   $0x0
8010663e:	6a 69                	push   $0x69
80106640:	e9 9e f7 ff ff       	jmp    80105de3 <alltraps>

80106645 <vector106>:
80106645:	6a 00                	push   $0x0
80106647:	6a 6a                	push   $0x6a
80106649:	e9 95 f7 ff ff       	jmp    80105de3 <alltraps>

8010664e <vector107>:
8010664e:	6a 00                	push   $0x0
80106650:	6a 6b                	push   $0x6b
80106652:	e9 8c f7 ff ff       	jmp    80105de3 <alltraps>

80106657 <vector108>:
80106657:	6a 00                	push   $0x0
80106659:	6a 6c                	push   $0x6c
8010665b:	e9 83 f7 ff ff       	jmp    80105de3 <alltraps>

80106660 <vector109>:
80106660:	6a 00                	push   $0x0
80106662:	6a 6d                	push   $0x6d
80106664:	e9 7a f7 ff ff       	jmp    80105de3 <alltraps>

80106669 <vector110>:
80106669:	6a 00                	push   $0x0
8010666b:	6a 6e                	push   $0x6e
8010666d:	e9 71 f7 ff ff       	jmp    80105de3 <alltraps>

80106672 <vector111>:
80106672:	6a 00                	push   $0x0
80106674:	6a 6f                	push   $0x6f
80106676:	e9 68 f7 ff ff       	jmp    80105de3 <alltraps>

8010667b <vector112>:
8010667b:	6a 00                	push   $0x0
8010667d:	6a 70                	push   $0x70
8010667f:	e9 5f f7 ff ff       	jmp    80105de3 <alltraps>

80106684 <vector113>:
80106684:	6a 00                	push   $0x0
80106686:	6a 71                	push   $0x71
80106688:	e9 56 f7 ff ff       	jmp    80105de3 <alltraps>

8010668d <vector114>:
8010668d:	6a 00                	push   $0x0
8010668f:	6a 72                	push   $0x72
80106691:	e9 4d f7 ff ff       	jmp    80105de3 <alltraps>

80106696 <vector115>:
80106696:	6a 00                	push   $0x0
80106698:	6a 73                	push   $0x73
8010669a:	e9 44 f7 ff ff       	jmp    80105de3 <alltraps>

8010669f <vector116>:
8010669f:	6a 00                	push   $0x0
801066a1:	6a 74                	push   $0x74
801066a3:	e9 3b f7 ff ff       	jmp    80105de3 <alltraps>

801066a8 <vector117>:
801066a8:	6a 00                	push   $0x0
801066aa:	6a 75                	push   $0x75
801066ac:	e9 32 f7 ff ff       	jmp    80105de3 <alltraps>

801066b1 <vector118>:
801066b1:	6a 00                	push   $0x0
801066b3:	6a 76                	push   $0x76
801066b5:	e9 29 f7 ff ff       	jmp    80105de3 <alltraps>

801066ba <vector119>:
801066ba:	6a 00                	push   $0x0
801066bc:	6a 77                	push   $0x77
801066be:	e9 20 f7 ff ff       	jmp    80105de3 <alltraps>

801066c3 <vector120>:
801066c3:	6a 00                	push   $0x0
801066c5:	6a 78                	push   $0x78
801066c7:	e9 17 f7 ff ff       	jmp    80105de3 <alltraps>

801066cc <vector121>:
801066cc:	6a 00                	push   $0x0
801066ce:	6a 79                	push   $0x79
801066d0:	e9 0e f7 ff ff       	jmp    80105de3 <alltraps>

801066d5 <vector122>:
801066d5:	6a 00                	push   $0x0
801066d7:	6a 7a                	push   $0x7a
801066d9:	e9 05 f7 ff ff       	jmp    80105de3 <alltraps>

801066de <vector123>:
801066de:	6a 00                	push   $0x0
801066e0:	6a 7b                	push   $0x7b
801066e2:	e9 fc f6 ff ff       	jmp    80105de3 <alltraps>

801066e7 <vector124>:
801066e7:	6a 00                	push   $0x0
801066e9:	6a 7c                	push   $0x7c
801066eb:	e9 f3 f6 ff ff       	jmp    80105de3 <alltraps>

801066f0 <vector125>:
801066f0:	6a 00                	push   $0x0
801066f2:	6a 7d                	push   $0x7d
801066f4:	e9 ea f6 ff ff       	jmp    80105de3 <alltraps>

801066f9 <vector126>:
801066f9:	6a 00                	push   $0x0
801066fb:	6a 7e                	push   $0x7e
801066fd:	e9 e1 f6 ff ff       	jmp    80105de3 <alltraps>

80106702 <vector127>:
80106702:	6a 00                	push   $0x0
80106704:	6a 7f                	push   $0x7f
80106706:	e9 d8 f6 ff ff       	jmp    80105de3 <alltraps>

8010670b <vector128>:
8010670b:	6a 00                	push   $0x0
8010670d:	68 80 00 00 00       	push   $0x80
80106712:	e9 cc f6 ff ff       	jmp    80105de3 <alltraps>

80106717 <vector129>:
80106717:	6a 00                	push   $0x0
80106719:	68 81 00 00 00       	push   $0x81
8010671e:	e9 c0 f6 ff ff       	jmp    80105de3 <alltraps>

80106723 <vector130>:
80106723:	6a 00                	push   $0x0
80106725:	68 82 00 00 00       	push   $0x82
8010672a:	e9 b4 f6 ff ff       	jmp    80105de3 <alltraps>

8010672f <vector131>:
8010672f:	6a 00                	push   $0x0
80106731:	68 83 00 00 00       	push   $0x83
80106736:	e9 a8 f6 ff ff       	jmp    80105de3 <alltraps>

8010673b <vector132>:
8010673b:	6a 00                	push   $0x0
8010673d:	68 84 00 00 00       	push   $0x84
80106742:	e9 9c f6 ff ff       	jmp    80105de3 <alltraps>

80106747 <vector133>:
80106747:	6a 00                	push   $0x0
80106749:	68 85 00 00 00       	push   $0x85
8010674e:	e9 90 f6 ff ff       	jmp    80105de3 <alltraps>

80106753 <vector134>:
80106753:	6a 00                	push   $0x0
80106755:	68 86 00 00 00       	push   $0x86
8010675a:	e9 84 f6 ff ff       	jmp    80105de3 <alltraps>

8010675f <vector135>:
8010675f:	6a 00                	push   $0x0
80106761:	68 87 00 00 00       	push   $0x87
80106766:	e9 78 f6 ff ff       	jmp    80105de3 <alltraps>

8010676b <vector136>:
8010676b:	6a 00                	push   $0x0
8010676d:	68 88 00 00 00       	push   $0x88
80106772:	e9 6c f6 ff ff       	jmp    80105de3 <alltraps>

80106777 <vector137>:
80106777:	6a 00                	push   $0x0
80106779:	68 89 00 00 00       	push   $0x89
8010677e:	e9 60 f6 ff ff       	jmp    80105de3 <alltraps>

80106783 <vector138>:
80106783:	6a 00                	push   $0x0
80106785:	68 8a 00 00 00       	push   $0x8a
8010678a:	e9 54 f6 ff ff       	jmp    80105de3 <alltraps>

8010678f <vector139>:
8010678f:	6a 00                	push   $0x0
80106791:	68 8b 00 00 00       	push   $0x8b
80106796:	e9 48 f6 ff ff       	jmp    80105de3 <alltraps>

8010679b <vector140>:
8010679b:	6a 00                	push   $0x0
8010679d:	68 8c 00 00 00       	push   $0x8c
801067a2:	e9 3c f6 ff ff       	jmp    80105de3 <alltraps>

801067a7 <vector141>:
801067a7:	6a 00                	push   $0x0
801067a9:	68 8d 00 00 00       	push   $0x8d
801067ae:	e9 30 f6 ff ff       	jmp    80105de3 <alltraps>

801067b3 <vector142>:
801067b3:	6a 00                	push   $0x0
801067b5:	68 8e 00 00 00       	push   $0x8e
801067ba:	e9 24 f6 ff ff       	jmp    80105de3 <alltraps>

801067bf <vector143>:
801067bf:	6a 00                	push   $0x0
801067c1:	68 8f 00 00 00       	push   $0x8f
801067c6:	e9 18 f6 ff ff       	jmp    80105de3 <alltraps>

801067cb <vector144>:
801067cb:	6a 00                	push   $0x0
801067cd:	68 90 00 00 00       	push   $0x90
801067d2:	e9 0c f6 ff ff       	jmp    80105de3 <alltraps>

801067d7 <vector145>:
801067d7:	6a 00                	push   $0x0
801067d9:	68 91 00 00 00       	push   $0x91
801067de:	e9 00 f6 ff ff       	jmp    80105de3 <alltraps>

801067e3 <vector146>:
801067e3:	6a 00                	push   $0x0
801067e5:	68 92 00 00 00       	push   $0x92
801067ea:	e9 f4 f5 ff ff       	jmp    80105de3 <alltraps>

801067ef <vector147>:
801067ef:	6a 00                	push   $0x0
801067f1:	68 93 00 00 00       	push   $0x93
801067f6:	e9 e8 f5 ff ff       	jmp    80105de3 <alltraps>

801067fb <vector148>:
801067fb:	6a 00                	push   $0x0
801067fd:	68 94 00 00 00       	push   $0x94
80106802:	e9 dc f5 ff ff       	jmp    80105de3 <alltraps>

80106807 <vector149>:
80106807:	6a 00                	push   $0x0
80106809:	68 95 00 00 00       	push   $0x95
8010680e:	e9 d0 f5 ff ff       	jmp    80105de3 <alltraps>

80106813 <vector150>:
80106813:	6a 00                	push   $0x0
80106815:	68 96 00 00 00       	push   $0x96
8010681a:	e9 c4 f5 ff ff       	jmp    80105de3 <alltraps>

8010681f <vector151>:
8010681f:	6a 00                	push   $0x0
80106821:	68 97 00 00 00       	push   $0x97
80106826:	e9 b8 f5 ff ff       	jmp    80105de3 <alltraps>

8010682b <vector152>:
8010682b:	6a 00                	push   $0x0
8010682d:	68 98 00 00 00       	push   $0x98
80106832:	e9 ac f5 ff ff       	jmp    80105de3 <alltraps>

80106837 <vector153>:
80106837:	6a 00                	push   $0x0
80106839:	68 99 00 00 00       	push   $0x99
8010683e:	e9 a0 f5 ff ff       	jmp    80105de3 <alltraps>

80106843 <vector154>:
80106843:	6a 00                	push   $0x0
80106845:	68 9a 00 00 00       	push   $0x9a
8010684a:	e9 94 f5 ff ff       	jmp    80105de3 <alltraps>

8010684f <vector155>:
8010684f:	6a 00                	push   $0x0
80106851:	68 9b 00 00 00       	push   $0x9b
80106856:	e9 88 f5 ff ff       	jmp    80105de3 <alltraps>

8010685b <vector156>:
8010685b:	6a 00                	push   $0x0
8010685d:	68 9c 00 00 00       	push   $0x9c
80106862:	e9 7c f5 ff ff       	jmp    80105de3 <alltraps>

80106867 <vector157>:
80106867:	6a 00                	push   $0x0
80106869:	68 9d 00 00 00       	push   $0x9d
8010686e:	e9 70 f5 ff ff       	jmp    80105de3 <alltraps>

80106873 <vector158>:
80106873:	6a 00                	push   $0x0
80106875:	68 9e 00 00 00       	push   $0x9e
8010687a:	e9 64 f5 ff ff       	jmp    80105de3 <alltraps>

8010687f <vector159>:
8010687f:	6a 00                	push   $0x0
80106881:	68 9f 00 00 00       	push   $0x9f
80106886:	e9 58 f5 ff ff       	jmp    80105de3 <alltraps>

8010688b <vector160>:
8010688b:	6a 00                	push   $0x0
8010688d:	68 a0 00 00 00       	push   $0xa0
80106892:	e9 4c f5 ff ff       	jmp    80105de3 <alltraps>

80106897 <vector161>:
80106897:	6a 00                	push   $0x0
80106899:	68 a1 00 00 00       	push   $0xa1
8010689e:	e9 40 f5 ff ff       	jmp    80105de3 <alltraps>

801068a3 <vector162>:
801068a3:	6a 00                	push   $0x0
801068a5:	68 a2 00 00 00       	push   $0xa2
801068aa:	e9 34 f5 ff ff       	jmp    80105de3 <alltraps>

801068af <vector163>:
801068af:	6a 00                	push   $0x0
801068b1:	68 a3 00 00 00       	push   $0xa3
801068b6:	e9 28 f5 ff ff       	jmp    80105de3 <alltraps>

801068bb <vector164>:
801068bb:	6a 00                	push   $0x0
801068bd:	68 a4 00 00 00       	push   $0xa4
801068c2:	e9 1c f5 ff ff       	jmp    80105de3 <alltraps>

801068c7 <vector165>:
801068c7:	6a 00                	push   $0x0
801068c9:	68 a5 00 00 00       	push   $0xa5
801068ce:	e9 10 f5 ff ff       	jmp    80105de3 <alltraps>

801068d3 <vector166>:
801068d3:	6a 00                	push   $0x0
801068d5:	68 a6 00 00 00       	push   $0xa6
801068da:	e9 04 f5 ff ff       	jmp    80105de3 <alltraps>

801068df <vector167>:
801068df:	6a 00                	push   $0x0
801068e1:	68 a7 00 00 00       	push   $0xa7
801068e6:	e9 f8 f4 ff ff       	jmp    80105de3 <alltraps>

801068eb <vector168>:
801068eb:	6a 00                	push   $0x0
801068ed:	68 a8 00 00 00       	push   $0xa8
801068f2:	e9 ec f4 ff ff       	jmp    80105de3 <alltraps>

801068f7 <vector169>:
801068f7:	6a 00                	push   $0x0
801068f9:	68 a9 00 00 00       	push   $0xa9
801068fe:	e9 e0 f4 ff ff       	jmp    80105de3 <alltraps>

80106903 <vector170>:
80106903:	6a 00                	push   $0x0
80106905:	68 aa 00 00 00       	push   $0xaa
8010690a:	e9 d4 f4 ff ff       	jmp    80105de3 <alltraps>

8010690f <vector171>:
8010690f:	6a 00                	push   $0x0
80106911:	68 ab 00 00 00       	push   $0xab
80106916:	e9 c8 f4 ff ff       	jmp    80105de3 <alltraps>

8010691b <vector172>:
8010691b:	6a 00                	push   $0x0
8010691d:	68 ac 00 00 00       	push   $0xac
80106922:	e9 bc f4 ff ff       	jmp    80105de3 <alltraps>

80106927 <vector173>:
80106927:	6a 00                	push   $0x0
80106929:	68 ad 00 00 00       	push   $0xad
8010692e:	e9 b0 f4 ff ff       	jmp    80105de3 <alltraps>

80106933 <vector174>:
80106933:	6a 00                	push   $0x0
80106935:	68 ae 00 00 00       	push   $0xae
8010693a:	e9 a4 f4 ff ff       	jmp    80105de3 <alltraps>

8010693f <vector175>:
8010693f:	6a 00                	push   $0x0
80106941:	68 af 00 00 00       	push   $0xaf
80106946:	e9 98 f4 ff ff       	jmp    80105de3 <alltraps>

8010694b <vector176>:
8010694b:	6a 00                	push   $0x0
8010694d:	68 b0 00 00 00       	push   $0xb0
80106952:	e9 8c f4 ff ff       	jmp    80105de3 <alltraps>

80106957 <vector177>:
80106957:	6a 00                	push   $0x0
80106959:	68 b1 00 00 00       	push   $0xb1
8010695e:	e9 80 f4 ff ff       	jmp    80105de3 <alltraps>

80106963 <vector178>:
80106963:	6a 00                	push   $0x0
80106965:	68 b2 00 00 00       	push   $0xb2
8010696a:	e9 74 f4 ff ff       	jmp    80105de3 <alltraps>

8010696f <vector179>:
8010696f:	6a 00                	push   $0x0
80106971:	68 b3 00 00 00       	push   $0xb3
80106976:	e9 68 f4 ff ff       	jmp    80105de3 <alltraps>

8010697b <vector180>:
8010697b:	6a 00                	push   $0x0
8010697d:	68 b4 00 00 00       	push   $0xb4
80106982:	e9 5c f4 ff ff       	jmp    80105de3 <alltraps>

80106987 <vector181>:
80106987:	6a 00                	push   $0x0
80106989:	68 b5 00 00 00       	push   $0xb5
8010698e:	e9 50 f4 ff ff       	jmp    80105de3 <alltraps>

80106993 <vector182>:
80106993:	6a 00                	push   $0x0
80106995:	68 b6 00 00 00       	push   $0xb6
8010699a:	e9 44 f4 ff ff       	jmp    80105de3 <alltraps>

8010699f <vector183>:
8010699f:	6a 00                	push   $0x0
801069a1:	68 b7 00 00 00       	push   $0xb7
801069a6:	e9 38 f4 ff ff       	jmp    80105de3 <alltraps>

801069ab <vector184>:
801069ab:	6a 00                	push   $0x0
801069ad:	68 b8 00 00 00       	push   $0xb8
801069b2:	e9 2c f4 ff ff       	jmp    80105de3 <alltraps>

801069b7 <vector185>:
801069b7:	6a 00                	push   $0x0
801069b9:	68 b9 00 00 00       	push   $0xb9
801069be:	e9 20 f4 ff ff       	jmp    80105de3 <alltraps>

801069c3 <vector186>:
801069c3:	6a 00                	push   $0x0
801069c5:	68 ba 00 00 00       	push   $0xba
801069ca:	e9 14 f4 ff ff       	jmp    80105de3 <alltraps>

801069cf <vector187>:
801069cf:	6a 00                	push   $0x0
801069d1:	68 bb 00 00 00       	push   $0xbb
801069d6:	e9 08 f4 ff ff       	jmp    80105de3 <alltraps>

801069db <vector188>:
801069db:	6a 00                	push   $0x0
801069dd:	68 bc 00 00 00       	push   $0xbc
801069e2:	e9 fc f3 ff ff       	jmp    80105de3 <alltraps>

801069e7 <vector189>:
801069e7:	6a 00                	push   $0x0
801069e9:	68 bd 00 00 00       	push   $0xbd
801069ee:	e9 f0 f3 ff ff       	jmp    80105de3 <alltraps>

801069f3 <vector190>:
801069f3:	6a 00                	push   $0x0
801069f5:	68 be 00 00 00       	push   $0xbe
801069fa:	e9 e4 f3 ff ff       	jmp    80105de3 <alltraps>

801069ff <vector191>:
801069ff:	6a 00                	push   $0x0
80106a01:	68 bf 00 00 00       	push   $0xbf
80106a06:	e9 d8 f3 ff ff       	jmp    80105de3 <alltraps>

80106a0b <vector192>:
80106a0b:	6a 00                	push   $0x0
80106a0d:	68 c0 00 00 00       	push   $0xc0
80106a12:	e9 cc f3 ff ff       	jmp    80105de3 <alltraps>

80106a17 <vector193>:
80106a17:	6a 00                	push   $0x0
80106a19:	68 c1 00 00 00       	push   $0xc1
80106a1e:	e9 c0 f3 ff ff       	jmp    80105de3 <alltraps>

80106a23 <vector194>:
80106a23:	6a 00                	push   $0x0
80106a25:	68 c2 00 00 00       	push   $0xc2
80106a2a:	e9 b4 f3 ff ff       	jmp    80105de3 <alltraps>

80106a2f <vector195>:
80106a2f:	6a 00                	push   $0x0
80106a31:	68 c3 00 00 00       	push   $0xc3
80106a36:	e9 a8 f3 ff ff       	jmp    80105de3 <alltraps>

80106a3b <vector196>:
80106a3b:	6a 00                	push   $0x0
80106a3d:	68 c4 00 00 00       	push   $0xc4
80106a42:	e9 9c f3 ff ff       	jmp    80105de3 <alltraps>

80106a47 <vector197>:
80106a47:	6a 00                	push   $0x0
80106a49:	68 c5 00 00 00       	push   $0xc5
80106a4e:	e9 90 f3 ff ff       	jmp    80105de3 <alltraps>

80106a53 <vector198>:
80106a53:	6a 00                	push   $0x0
80106a55:	68 c6 00 00 00       	push   $0xc6
80106a5a:	e9 84 f3 ff ff       	jmp    80105de3 <alltraps>

80106a5f <vector199>:
80106a5f:	6a 00                	push   $0x0
80106a61:	68 c7 00 00 00       	push   $0xc7
80106a66:	e9 78 f3 ff ff       	jmp    80105de3 <alltraps>

80106a6b <vector200>:
80106a6b:	6a 00                	push   $0x0
80106a6d:	68 c8 00 00 00       	push   $0xc8
80106a72:	e9 6c f3 ff ff       	jmp    80105de3 <alltraps>

80106a77 <vector201>:
80106a77:	6a 00                	push   $0x0
80106a79:	68 c9 00 00 00       	push   $0xc9
80106a7e:	e9 60 f3 ff ff       	jmp    80105de3 <alltraps>

80106a83 <vector202>:
80106a83:	6a 00                	push   $0x0
80106a85:	68 ca 00 00 00       	push   $0xca
80106a8a:	e9 54 f3 ff ff       	jmp    80105de3 <alltraps>

80106a8f <vector203>:
80106a8f:	6a 00                	push   $0x0
80106a91:	68 cb 00 00 00       	push   $0xcb
80106a96:	e9 48 f3 ff ff       	jmp    80105de3 <alltraps>

80106a9b <vector204>:
80106a9b:	6a 00                	push   $0x0
80106a9d:	68 cc 00 00 00       	push   $0xcc
80106aa2:	e9 3c f3 ff ff       	jmp    80105de3 <alltraps>

80106aa7 <vector205>:
80106aa7:	6a 00                	push   $0x0
80106aa9:	68 cd 00 00 00       	push   $0xcd
80106aae:	e9 30 f3 ff ff       	jmp    80105de3 <alltraps>

80106ab3 <vector206>:
80106ab3:	6a 00                	push   $0x0
80106ab5:	68 ce 00 00 00       	push   $0xce
80106aba:	e9 24 f3 ff ff       	jmp    80105de3 <alltraps>

80106abf <vector207>:
80106abf:	6a 00                	push   $0x0
80106ac1:	68 cf 00 00 00       	push   $0xcf
80106ac6:	e9 18 f3 ff ff       	jmp    80105de3 <alltraps>

80106acb <vector208>:
80106acb:	6a 00                	push   $0x0
80106acd:	68 d0 00 00 00       	push   $0xd0
80106ad2:	e9 0c f3 ff ff       	jmp    80105de3 <alltraps>

80106ad7 <vector209>:
80106ad7:	6a 00                	push   $0x0
80106ad9:	68 d1 00 00 00       	push   $0xd1
80106ade:	e9 00 f3 ff ff       	jmp    80105de3 <alltraps>

80106ae3 <vector210>:
80106ae3:	6a 00                	push   $0x0
80106ae5:	68 d2 00 00 00       	push   $0xd2
80106aea:	e9 f4 f2 ff ff       	jmp    80105de3 <alltraps>

80106aef <vector211>:
80106aef:	6a 00                	push   $0x0
80106af1:	68 d3 00 00 00       	push   $0xd3
80106af6:	e9 e8 f2 ff ff       	jmp    80105de3 <alltraps>

80106afb <vector212>:
80106afb:	6a 00                	push   $0x0
80106afd:	68 d4 00 00 00       	push   $0xd4
80106b02:	e9 dc f2 ff ff       	jmp    80105de3 <alltraps>

80106b07 <vector213>:
80106b07:	6a 00                	push   $0x0
80106b09:	68 d5 00 00 00       	push   $0xd5
80106b0e:	e9 d0 f2 ff ff       	jmp    80105de3 <alltraps>

80106b13 <vector214>:
80106b13:	6a 00                	push   $0x0
80106b15:	68 d6 00 00 00       	push   $0xd6
80106b1a:	e9 c4 f2 ff ff       	jmp    80105de3 <alltraps>

80106b1f <vector215>:
80106b1f:	6a 00                	push   $0x0
80106b21:	68 d7 00 00 00       	push   $0xd7
80106b26:	e9 b8 f2 ff ff       	jmp    80105de3 <alltraps>

80106b2b <vector216>:
80106b2b:	6a 00                	push   $0x0
80106b2d:	68 d8 00 00 00       	push   $0xd8
80106b32:	e9 ac f2 ff ff       	jmp    80105de3 <alltraps>

80106b37 <vector217>:
80106b37:	6a 00                	push   $0x0
80106b39:	68 d9 00 00 00       	push   $0xd9
80106b3e:	e9 a0 f2 ff ff       	jmp    80105de3 <alltraps>

80106b43 <vector218>:
80106b43:	6a 00                	push   $0x0
80106b45:	68 da 00 00 00       	push   $0xda
80106b4a:	e9 94 f2 ff ff       	jmp    80105de3 <alltraps>

80106b4f <vector219>:
80106b4f:	6a 00                	push   $0x0
80106b51:	68 db 00 00 00       	push   $0xdb
80106b56:	e9 88 f2 ff ff       	jmp    80105de3 <alltraps>

80106b5b <vector220>:
80106b5b:	6a 00                	push   $0x0
80106b5d:	68 dc 00 00 00       	push   $0xdc
80106b62:	e9 7c f2 ff ff       	jmp    80105de3 <alltraps>

80106b67 <vector221>:
80106b67:	6a 00                	push   $0x0
80106b69:	68 dd 00 00 00       	push   $0xdd
80106b6e:	e9 70 f2 ff ff       	jmp    80105de3 <alltraps>

80106b73 <vector222>:
80106b73:	6a 00                	push   $0x0
80106b75:	68 de 00 00 00       	push   $0xde
80106b7a:	e9 64 f2 ff ff       	jmp    80105de3 <alltraps>

80106b7f <vector223>:
80106b7f:	6a 00                	push   $0x0
80106b81:	68 df 00 00 00       	push   $0xdf
80106b86:	e9 58 f2 ff ff       	jmp    80105de3 <alltraps>

80106b8b <vector224>:
80106b8b:	6a 00                	push   $0x0
80106b8d:	68 e0 00 00 00       	push   $0xe0
80106b92:	e9 4c f2 ff ff       	jmp    80105de3 <alltraps>

80106b97 <vector225>:
80106b97:	6a 00                	push   $0x0
80106b99:	68 e1 00 00 00       	push   $0xe1
80106b9e:	e9 40 f2 ff ff       	jmp    80105de3 <alltraps>

80106ba3 <vector226>:
80106ba3:	6a 00                	push   $0x0
80106ba5:	68 e2 00 00 00       	push   $0xe2
80106baa:	e9 34 f2 ff ff       	jmp    80105de3 <alltraps>

80106baf <vector227>:
80106baf:	6a 00                	push   $0x0
80106bb1:	68 e3 00 00 00       	push   $0xe3
80106bb6:	e9 28 f2 ff ff       	jmp    80105de3 <alltraps>

80106bbb <vector228>:
80106bbb:	6a 00                	push   $0x0
80106bbd:	68 e4 00 00 00       	push   $0xe4
80106bc2:	e9 1c f2 ff ff       	jmp    80105de3 <alltraps>

80106bc7 <vector229>:
80106bc7:	6a 00                	push   $0x0
80106bc9:	68 e5 00 00 00       	push   $0xe5
80106bce:	e9 10 f2 ff ff       	jmp    80105de3 <alltraps>

80106bd3 <vector230>:
80106bd3:	6a 00                	push   $0x0
80106bd5:	68 e6 00 00 00       	push   $0xe6
80106bda:	e9 04 f2 ff ff       	jmp    80105de3 <alltraps>

80106bdf <vector231>:
80106bdf:	6a 00                	push   $0x0
80106be1:	68 e7 00 00 00       	push   $0xe7
80106be6:	e9 f8 f1 ff ff       	jmp    80105de3 <alltraps>

80106beb <vector232>:
80106beb:	6a 00                	push   $0x0
80106bed:	68 e8 00 00 00       	push   $0xe8
80106bf2:	e9 ec f1 ff ff       	jmp    80105de3 <alltraps>

80106bf7 <vector233>:
80106bf7:	6a 00                	push   $0x0
80106bf9:	68 e9 00 00 00       	push   $0xe9
80106bfe:	e9 e0 f1 ff ff       	jmp    80105de3 <alltraps>

80106c03 <vector234>:
80106c03:	6a 00                	push   $0x0
80106c05:	68 ea 00 00 00       	push   $0xea
80106c0a:	e9 d4 f1 ff ff       	jmp    80105de3 <alltraps>

80106c0f <vector235>:
80106c0f:	6a 00                	push   $0x0
80106c11:	68 eb 00 00 00       	push   $0xeb
80106c16:	e9 c8 f1 ff ff       	jmp    80105de3 <alltraps>

80106c1b <vector236>:
80106c1b:	6a 00                	push   $0x0
80106c1d:	68 ec 00 00 00       	push   $0xec
80106c22:	e9 bc f1 ff ff       	jmp    80105de3 <alltraps>

80106c27 <vector237>:
80106c27:	6a 00                	push   $0x0
80106c29:	68 ed 00 00 00       	push   $0xed
80106c2e:	e9 b0 f1 ff ff       	jmp    80105de3 <alltraps>

80106c33 <vector238>:
80106c33:	6a 00                	push   $0x0
80106c35:	68 ee 00 00 00       	push   $0xee
80106c3a:	e9 a4 f1 ff ff       	jmp    80105de3 <alltraps>

80106c3f <vector239>:
80106c3f:	6a 00                	push   $0x0
80106c41:	68 ef 00 00 00       	push   $0xef
80106c46:	e9 98 f1 ff ff       	jmp    80105de3 <alltraps>

80106c4b <vector240>:
80106c4b:	6a 00                	push   $0x0
80106c4d:	68 f0 00 00 00       	push   $0xf0
80106c52:	e9 8c f1 ff ff       	jmp    80105de3 <alltraps>

80106c57 <vector241>:
80106c57:	6a 00                	push   $0x0
80106c59:	68 f1 00 00 00       	push   $0xf1
80106c5e:	e9 80 f1 ff ff       	jmp    80105de3 <alltraps>

80106c63 <vector242>:
80106c63:	6a 00                	push   $0x0
80106c65:	68 f2 00 00 00       	push   $0xf2
80106c6a:	e9 74 f1 ff ff       	jmp    80105de3 <alltraps>

80106c6f <vector243>:
80106c6f:	6a 00                	push   $0x0
80106c71:	68 f3 00 00 00       	push   $0xf3
80106c76:	e9 68 f1 ff ff       	jmp    80105de3 <alltraps>

80106c7b <vector244>:
80106c7b:	6a 00                	push   $0x0
80106c7d:	68 f4 00 00 00       	push   $0xf4
80106c82:	e9 5c f1 ff ff       	jmp    80105de3 <alltraps>

80106c87 <vector245>:
80106c87:	6a 00                	push   $0x0
80106c89:	68 f5 00 00 00       	push   $0xf5
80106c8e:	e9 50 f1 ff ff       	jmp    80105de3 <alltraps>

80106c93 <vector246>:
80106c93:	6a 00                	push   $0x0
80106c95:	68 f6 00 00 00       	push   $0xf6
80106c9a:	e9 44 f1 ff ff       	jmp    80105de3 <alltraps>

80106c9f <vector247>:
80106c9f:	6a 00                	push   $0x0
80106ca1:	68 f7 00 00 00       	push   $0xf7
80106ca6:	e9 38 f1 ff ff       	jmp    80105de3 <alltraps>

80106cab <vector248>:
80106cab:	6a 00                	push   $0x0
80106cad:	68 f8 00 00 00       	push   $0xf8
80106cb2:	e9 2c f1 ff ff       	jmp    80105de3 <alltraps>

80106cb7 <vector249>:
80106cb7:	6a 00                	push   $0x0
80106cb9:	68 f9 00 00 00       	push   $0xf9
80106cbe:	e9 20 f1 ff ff       	jmp    80105de3 <alltraps>

80106cc3 <vector250>:
80106cc3:	6a 00                	push   $0x0
80106cc5:	68 fa 00 00 00       	push   $0xfa
80106cca:	e9 14 f1 ff ff       	jmp    80105de3 <alltraps>

80106ccf <vector251>:
80106ccf:	6a 00                	push   $0x0
80106cd1:	68 fb 00 00 00       	push   $0xfb
80106cd6:	e9 08 f1 ff ff       	jmp    80105de3 <alltraps>

80106cdb <vector252>:
80106cdb:	6a 00                	push   $0x0
80106cdd:	68 fc 00 00 00       	push   $0xfc
80106ce2:	e9 fc f0 ff ff       	jmp    80105de3 <alltraps>

80106ce7 <vector253>:
80106ce7:	6a 00                	push   $0x0
80106ce9:	68 fd 00 00 00       	push   $0xfd
80106cee:	e9 f0 f0 ff ff       	jmp    80105de3 <alltraps>

80106cf3 <vector254>:
80106cf3:	6a 00                	push   $0x0
80106cf5:	68 fe 00 00 00       	push   $0xfe
80106cfa:	e9 e4 f0 ff ff       	jmp    80105de3 <alltraps>

80106cff <vector255>:
80106cff:	6a 00                	push   $0x0
80106d01:	68 ff 00 00 00       	push   $0xff
80106d06:	e9 d8 f0 ff ff       	jmp    80105de3 <alltraps>
80106d0b:	66 90                	xchg   %ax,%ax
80106d0d:	66 90                	xchg   %ax,%ax
80106d0f:	90                   	nop

80106d10 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106d17:	c1 ea 16             	shr    $0x16,%edx
{
80106d1a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106d1b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106d1e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106d21:	8b 1f                	mov    (%edi),%ebx
80106d23:	f6 c3 01             	test   $0x1,%bl
80106d26:	74 28                	je     80106d50 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d28:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106d2e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d34:	89 f0                	mov    %esi,%eax
}
80106d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106d39:	c1 e8 0a             	shr    $0xa,%eax
80106d3c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d41:	01 d8                	add    %ebx,%eax
}
80106d43:	5b                   	pop    %ebx
80106d44:	5e                   	pop    %esi
80106d45:	5f                   	pop    %edi
80106d46:	5d                   	pop    %ebp
80106d47:	c3                   	ret    
80106d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d4f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d50:	85 c9                	test   %ecx,%ecx
80106d52:	74 2c                	je     80106d80 <walkpgdir+0x70>
80106d54:	e8 e7 b9 ff ff       	call   80102740 <kalloc>
80106d59:	89 c3                	mov    %eax,%ebx
80106d5b:	85 c0                	test   %eax,%eax
80106d5d:	74 21                	je     80106d80 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106d5f:	83 ec 04             	sub    $0x4,%esp
80106d62:	68 00 10 00 00       	push   $0x1000
80106d67:	6a 00                	push   $0x0
80106d69:	50                   	push   %eax
80106d6a:	e8 e1 dc ff ff       	call   80104a50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d6f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d75:	83 c4 10             	add    $0x10,%esp
80106d78:	83 c8 07             	or     $0x7,%eax
80106d7b:	89 07                	mov    %eax,(%edi)
80106d7d:	eb b5                	jmp    80106d34 <walkpgdir+0x24>
80106d7f:	90                   	nop
}
80106d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106d83:	31 c0                	xor    %eax,%eax
}
80106d85:	5b                   	pop    %ebx
80106d86:	5e                   	pop    %esi
80106d87:	5f                   	pop    %edi
80106d88:	5d                   	pop    %ebp
80106d89:	c3                   	ret    
80106d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d90 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d96:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106d9a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106da0:	89 d6                	mov    %edx,%esi
{
80106da2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106da3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106da9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106dac:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106daf:	8b 45 08             	mov    0x8(%ebp),%eax
80106db2:	29 f0                	sub    %esi,%eax
80106db4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106db7:	eb 1f                	jmp    80106dd8 <mappages+0x48>
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106dc0:	f6 00 01             	testb  $0x1,(%eax)
80106dc3:	75 45                	jne    80106e0a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106dc5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106dc8:	83 cb 01             	or     $0x1,%ebx
80106dcb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106dcd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106dd0:	74 2e                	je     80106e00 <mappages+0x70>
      break;
    a += PGSIZE;
80106dd2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ddb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106de0:	89 f2                	mov    %esi,%edx
80106de2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106de5:	89 f8                	mov    %edi,%eax
80106de7:	e8 24 ff ff ff       	call   80106d10 <walkpgdir>
80106dec:	85 c0                	test   %eax,%eax
80106dee:	75 d0                	jne    80106dc0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106df3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106df8:	5b                   	pop    %ebx
80106df9:	5e                   	pop    %esi
80106dfa:	5f                   	pop    %edi
80106dfb:	5d                   	pop    %ebp
80106dfc:	c3                   	ret    
80106dfd:	8d 76 00             	lea    0x0(%esi),%esi
80106e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e03:	31 c0                	xor    %eax,%eax
}
80106e05:	5b                   	pop    %ebx
80106e06:	5e                   	pop    %esi
80106e07:	5f                   	pop    %edi
80106e08:	5d                   	pop    %ebp
80106e09:	c3                   	ret    
      panic("remap");
80106e0a:	83 ec 0c             	sub    $0xc,%esp
80106e0d:	68 20 80 10 80       	push   $0x80108020
80106e12:	e8 79 95 ff ff       	call   80100390 <panic>
80106e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1e:	66 90                	xchg   %ax,%ax

80106e20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	89 c6                	mov    %eax,%esi
80106e27:	53                   	push   %ebx
80106e28:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e2a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106e30:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e36:	83 ec 1c             	sub    $0x1c,%esp
80106e39:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e3c:	39 da                	cmp    %ebx,%edx
80106e3e:	73 5b                	jae    80106e9b <deallocuvm.part.0+0x7b>
80106e40:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106e43:	89 d7                	mov    %edx,%edi
80106e45:	eb 14                	jmp    80106e5b <deallocuvm.part.0+0x3b>
80106e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4e:	66 90                	xchg   %ax,%ax
80106e50:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e56:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106e59:	76 40                	jbe    80106e9b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e5b:	31 c9                	xor    %ecx,%ecx
80106e5d:	89 fa                	mov    %edi,%edx
80106e5f:	89 f0                	mov    %esi,%eax
80106e61:	e8 aa fe ff ff       	call   80106d10 <walkpgdir>
80106e66:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106e68:	85 c0                	test   %eax,%eax
80106e6a:	74 44                	je     80106eb0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e6c:	8b 00                	mov    (%eax),%eax
80106e6e:	a8 01                	test   $0x1,%al
80106e70:	74 de                	je     80106e50 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e77:	74 47                	je     80106ec0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e79:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106e7c:	05 00 00 00 80       	add    $0x80000000,%eax
80106e81:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106e87:	50                   	push   %eax
80106e88:	e8 f3 b6 ff ff       	call   80102580 <kfree>
      *pte = 0;
80106e8d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106e93:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106e96:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106e99:	77 c0                	ja     80106e5b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea1:	5b                   	pop    %ebx
80106ea2:	5e                   	pop    %esi
80106ea3:	5f                   	pop    %edi
80106ea4:	5d                   	pop    %ebp
80106ea5:	c3                   	ret    
80106ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ead:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106eb0:	89 fa                	mov    %edi,%edx
80106eb2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106eb8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106ebe:	eb 96                	jmp    80106e56 <deallocuvm.part.0+0x36>
        panic("kfree");
80106ec0:	83 ec 0c             	sub    $0xc,%esp
80106ec3:	68 e2 78 10 80       	push   $0x801078e2
80106ec8:	e8 c3 94 ff ff       	call   80100390 <panic>
80106ecd:	8d 76 00             	lea    0x0(%esi),%esi

80106ed0 <seginit>:
{
80106ed0:	f3 0f 1e fb          	endbr32 
80106ed4:	55                   	push   %ebp
80106ed5:	89 e5                	mov    %esp,%ebp
80106ed7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106eda:	e8 a1 cb ff ff       	call   80103a80 <cpuid>
  pd[0] = size-1;
80106edf:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ee4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106eea:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eee:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106ef5:	ff 00 00 
80106ef8:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106eff:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f02:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106f09:	ff 00 00 
80106f0c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106f13:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f16:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106f1d:	ff 00 00 
80106f20:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106f27:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f2a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106f31:	ff 00 00 
80106f34:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106f3b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f3e:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106f43:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f47:	c1 e8 10             	shr    $0x10,%eax
80106f4a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f4e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f51:	0f 01 10             	lgdtl  (%eax)
}
80106f54:	c9                   	leave  
80106f55:	c3                   	ret    
80106f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f5d:	8d 76 00             	lea    0x0(%esi),%esi

80106f60 <switchkvm>:
{
80106f60:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f64:	a1 a4 69 11 80       	mov    0x801169a4,%eax
80106f69:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f6e:	0f 22 d8             	mov    %eax,%cr3
}
80106f71:	c3                   	ret    
80106f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f80 <switchuvm>:
{
80106f80:	f3 0f 1e fb          	endbr32 
80106f84:	55                   	push   %ebp
80106f85:	89 e5                	mov    %esp,%ebp
80106f87:	57                   	push   %edi
80106f88:	56                   	push   %esi
80106f89:	53                   	push   %ebx
80106f8a:	83 ec 1c             	sub    $0x1c,%esp
80106f8d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f90:	85 f6                	test   %esi,%esi
80106f92:	0f 84 cb 00 00 00    	je     80107063 <switchuvm+0xe3>
  if(p->kstack == 0)
80106f98:	8b 46 08             	mov    0x8(%esi),%eax
80106f9b:	85 c0                	test   %eax,%eax
80106f9d:	0f 84 da 00 00 00    	je     8010707d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106fa3:	8b 46 04             	mov    0x4(%esi),%eax
80106fa6:	85 c0                	test   %eax,%eax
80106fa8:	0f 84 c2 00 00 00    	je     80107070 <switchuvm+0xf0>
  pushcli();
80106fae:	e8 8d d8 ff ff       	call   80104840 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fb3:	e8 58 ca ff ff       	call   80103a10 <mycpu>
80106fb8:	89 c3                	mov    %eax,%ebx
80106fba:	e8 51 ca ff ff       	call   80103a10 <mycpu>
80106fbf:	89 c7                	mov    %eax,%edi
80106fc1:	e8 4a ca ff ff       	call   80103a10 <mycpu>
80106fc6:	83 c7 08             	add    $0x8,%edi
80106fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fcc:	e8 3f ca ff ff       	call   80103a10 <mycpu>
80106fd1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fd4:	ba 67 00 00 00       	mov    $0x67,%edx
80106fd9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106fe0:	83 c0 08             	add    $0x8,%eax
80106fe3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fea:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fef:	83 c1 08             	add    $0x8,%ecx
80106ff2:	c1 e8 18             	shr    $0x18,%eax
80106ff5:	c1 e9 10             	shr    $0x10,%ecx
80106ff8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106ffe:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107004:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107009:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107010:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107015:	e8 f6 c9 ff ff       	call   80103a10 <mycpu>
8010701a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107021:	e8 ea c9 ff ff       	call   80103a10 <mycpu>
80107026:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010702a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010702d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107033:	e8 d8 c9 ff ff       	call   80103a10 <mycpu>
80107038:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010703b:	e8 d0 c9 ff ff       	call   80103a10 <mycpu>
80107040:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107044:	b8 28 00 00 00       	mov    $0x28,%eax
80107049:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010704c:	8b 46 04             	mov    0x4(%esi),%eax
8010704f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107054:	0f 22 d8             	mov    %eax,%cr3
}
80107057:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010705a:	5b                   	pop    %ebx
8010705b:	5e                   	pop    %esi
8010705c:	5f                   	pop    %edi
8010705d:	5d                   	pop    %ebp
  popcli();
8010705e:	e9 2d d8 ff ff       	jmp    80104890 <popcli>
    panic("switchuvm: no process");
80107063:	83 ec 0c             	sub    $0xc,%esp
80107066:	68 26 80 10 80       	push   $0x80108026
8010706b:	e8 20 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107070:	83 ec 0c             	sub    $0xc,%esp
80107073:	68 51 80 10 80       	push   $0x80108051
80107078:	e8 13 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010707d:	83 ec 0c             	sub    $0xc,%esp
80107080:	68 3c 80 10 80       	push   $0x8010803c
80107085:	e8 06 93 ff ff       	call   80100390 <panic>
8010708a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107090 <inituvm>:
{
80107090:	f3 0f 1e fb          	endbr32 
80107094:	55                   	push   %ebp
80107095:	89 e5                	mov    %esp,%ebp
80107097:	57                   	push   %edi
80107098:	56                   	push   %esi
80107099:	53                   	push   %ebx
8010709a:	83 ec 1c             	sub    $0x1c,%esp
8010709d:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a0:	8b 75 10             	mov    0x10(%ebp),%esi
801070a3:	8b 7d 08             	mov    0x8(%ebp),%edi
801070a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801070a9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070af:	77 4b                	ja     801070fc <inituvm+0x6c>
  mem = kalloc();
801070b1:	e8 8a b6 ff ff       	call   80102740 <kalloc>
  memset(mem, 0, PGSIZE);
801070b6:	83 ec 04             	sub    $0x4,%esp
801070b9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801070be:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070c0:	6a 00                	push   $0x0
801070c2:	50                   	push   %eax
801070c3:	e8 88 d9 ff ff       	call   80104a50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070c8:	58                   	pop    %eax
801070c9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070cf:	5a                   	pop    %edx
801070d0:	6a 06                	push   $0x6
801070d2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070d7:	31 d2                	xor    %edx,%edx
801070d9:	50                   	push   %eax
801070da:	89 f8                	mov    %edi,%eax
801070dc:	e8 af fc ff ff       	call   80106d90 <mappages>
  memmove(mem, init, sz);
801070e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070e4:	89 75 10             	mov    %esi,0x10(%ebp)
801070e7:	83 c4 10             	add    $0x10,%esp
801070ea:	89 5d 08             	mov    %ebx,0x8(%ebp)
801070ed:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801070f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f3:	5b                   	pop    %ebx
801070f4:	5e                   	pop    %esi
801070f5:	5f                   	pop    %edi
801070f6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070f7:	e9 f4 d9 ff ff       	jmp    80104af0 <memmove>
    panic("inituvm: more than a page");
801070fc:	83 ec 0c             	sub    $0xc,%esp
801070ff:	68 65 80 10 80       	push   $0x80108065
80107104:	e8 87 92 ff ff       	call   80100390 <panic>
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107110 <loaduvm>:
{
80107110:	f3 0f 1e fb          	endbr32 
80107114:	55                   	push   %ebp
80107115:	89 e5                	mov    %esp,%ebp
80107117:	57                   	push   %edi
80107118:	56                   	push   %esi
80107119:	53                   	push   %ebx
8010711a:	83 ec 1c             	sub    $0x1c,%esp
8010711d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107120:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107123:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107128:	0f 85 99 00 00 00    	jne    801071c7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010712e:	01 f0                	add    %esi,%eax
80107130:	89 f3                	mov    %esi,%ebx
80107132:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107135:	8b 45 14             	mov    0x14(%ebp),%eax
80107138:	01 f0                	add    %esi,%eax
8010713a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010713d:	85 f6                	test   %esi,%esi
8010713f:	75 15                	jne    80107156 <loaduvm+0x46>
80107141:	eb 6d                	jmp    801071b0 <loaduvm+0xa0>
80107143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107147:	90                   	nop
80107148:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010714e:	89 f0                	mov    %esi,%eax
80107150:	29 d8                	sub    %ebx,%eax
80107152:	39 c6                	cmp    %eax,%esi
80107154:	76 5a                	jbe    801071b0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107156:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107159:	8b 45 08             	mov    0x8(%ebp),%eax
8010715c:	31 c9                	xor    %ecx,%ecx
8010715e:	29 da                	sub    %ebx,%edx
80107160:	e8 ab fb ff ff       	call   80106d10 <walkpgdir>
80107165:	85 c0                	test   %eax,%eax
80107167:	74 51                	je     801071ba <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107169:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010716b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010716e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107173:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107178:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010717e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107181:	29 d9                	sub    %ebx,%ecx
80107183:	05 00 00 00 80       	add    $0x80000000,%eax
80107188:	57                   	push   %edi
80107189:	51                   	push   %ecx
8010718a:	50                   	push   %eax
8010718b:	ff 75 10             	pushl  0x10(%ebp)
8010718e:	e8 cd a8 ff ff       	call   80101a60 <readi>
80107193:	83 c4 10             	add    $0x10,%esp
80107196:	39 f8                	cmp    %edi,%eax
80107198:	74 ae                	je     80107148 <loaduvm+0x38>
}
8010719a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010719d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071a2:	5b                   	pop    %ebx
801071a3:	5e                   	pop    %esi
801071a4:	5f                   	pop    %edi
801071a5:	5d                   	pop    %ebp
801071a6:	c3                   	ret    
801071a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ae:	66 90                	xchg   %ax,%ax
801071b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071b3:	31 c0                	xor    %eax,%eax
}
801071b5:	5b                   	pop    %ebx
801071b6:	5e                   	pop    %esi
801071b7:	5f                   	pop    %edi
801071b8:	5d                   	pop    %ebp
801071b9:	c3                   	ret    
      panic("loaduvm: address should exist");
801071ba:	83 ec 0c             	sub    $0xc,%esp
801071bd:	68 7f 80 10 80       	push   $0x8010807f
801071c2:	e8 c9 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801071c7:	83 ec 0c             	sub    $0xc,%esp
801071ca:	68 20 81 10 80       	push   $0x80108120
801071cf:	e8 bc 91 ff ff       	call   80100390 <panic>
801071d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071df:	90                   	nop

801071e0 <allocuvm>:
{
801071e0:	f3 0f 1e fb          	endbr32 
801071e4:	55                   	push   %ebp
801071e5:	89 e5                	mov    %esp,%ebp
801071e7:	57                   	push   %edi
801071e8:	56                   	push   %esi
801071e9:	53                   	push   %ebx
801071ea:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071ed:	8b 45 10             	mov    0x10(%ebp),%eax
{
801071f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071f6:	85 c0                	test   %eax,%eax
801071f8:	0f 88 b2 00 00 00    	js     801072b0 <allocuvm+0xd0>
  if(newsz < oldsz)
801071fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107201:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107204:	0f 82 96 00 00 00    	jb     801072a0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010720a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107210:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107216:	39 75 10             	cmp    %esi,0x10(%ebp)
80107219:	77 40                	ja     8010725b <allocuvm+0x7b>
8010721b:	e9 83 00 00 00       	jmp    801072a3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107220:	83 ec 04             	sub    $0x4,%esp
80107223:	68 00 10 00 00       	push   $0x1000
80107228:	6a 00                	push   $0x0
8010722a:	50                   	push   %eax
8010722b:	e8 20 d8 ff ff       	call   80104a50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107230:	58                   	pop    %eax
80107231:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107237:	5a                   	pop    %edx
80107238:	6a 06                	push   $0x6
8010723a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010723f:	89 f2                	mov    %esi,%edx
80107241:	50                   	push   %eax
80107242:	89 f8                	mov    %edi,%eax
80107244:	e8 47 fb ff ff       	call   80106d90 <mappages>
80107249:	83 c4 10             	add    $0x10,%esp
8010724c:	85 c0                	test   %eax,%eax
8010724e:	78 78                	js     801072c8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107250:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107256:	39 75 10             	cmp    %esi,0x10(%ebp)
80107259:	76 48                	jbe    801072a3 <allocuvm+0xc3>
    mem = kalloc();
8010725b:	e8 e0 b4 ff ff       	call   80102740 <kalloc>
80107260:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107262:	85 c0                	test   %eax,%eax
80107264:	75 ba                	jne    80107220 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107266:	83 ec 0c             	sub    $0xc,%esp
80107269:	68 9d 80 10 80       	push   $0x8010809d
8010726e:	e8 3d 94 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107273:	8b 45 0c             	mov    0xc(%ebp),%eax
80107276:	83 c4 10             	add    $0x10,%esp
80107279:	39 45 10             	cmp    %eax,0x10(%ebp)
8010727c:	74 32                	je     801072b0 <allocuvm+0xd0>
8010727e:	8b 55 10             	mov    0x10(%ebp),%edx
80107281:	89 c1                	mov    %eax,%ecx
80107283:	89 f8                	mov    %edi,%eax
80107285:	e8 96 fb ff ff       	call   80106e20 <deallocuvm.part.0>
      return 0;
8010728a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107291:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107294:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107297:	5b                   	pop    %ebx
80107298:	5e                   	pop    %esi
80107299:	5f                   	pop    %edi
8010729a:	5d                   	pop    %ebp
8010729b:	c3                   	ret    
8010729c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801072a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801072a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a9:	5b                   	pop    %ebx
801072aa:	5e                   	pop    %esi
801072ab:	5f                   	pop    %edi
801072ac:	5d                   	pop    %ebp
801072ad:	c3                   	ret    
801072ae:	66 90                	xchg   %ax,%ax
    return 0;
801072b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072bd:	5b                   	pop    %ebx
801072be:	5e                   	pop    %esi
801072bf:	5f                   	pop    %edi
801072c0:	5d                   	pop    %ebp
801072c1:	c3                   	ret    
801072c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072c8:	83 ec 0c             	sub    $0xc,%esp
801072cb:	68 b5 80 10 80       	push   $0x801080b5
801072d0:	e8 db 93 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801072d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072d8:	83 c4 10             	add    $0x10,%esp
801072db:	39 45 10             	cmp    %eax,0x10(%ebp)
801072de:	74 0c                	je     801072ec <allocuvm+0x10c>
801072e0:	8b 55 10             	mov    0x10(%ebp),%edx
801072e3:	89 c1                	mov    %eax,%ecx
801072e5:	89 f8                	mov    %edi,%eax
801072e7:	e8 34 fb ff ff       	call   80106e20 <deallocuvm.part.0>
      kfree(mem);
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	53                   	push   %ebx
801072f0:	e8 8b b2 ff ff       	call   80102580 <kfree>
      return 0;
801072f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072fc:	83 c4 10             	add    $0x10,%esp
}
801072ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107302:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107305:	5b                   	pop    %ebx
80107306:	5e                   	pop    %esi
80107307:	5f                   	pop    %edi
80107308:	5d                   	pop    %ebp
80107309:	c3                   	ret    
8010730a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107310 <deallocuvm>:
{
80107310:	f3 0f 1e fb          	endbr32 
80107314:	55                   	push   %ebp
80107315:	89 e5                	mov    %esp,%ebp
80107317:	8b 55 0c             	mov    0xc(%ebp),%edx
8010731a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010731d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107320:	39 d1                	cmp    %edx,%ecx
80107322:	73 0c                	jae    80107330 <deallocuvm+0x20>
}
80107324:	5d                   	pop    %ebp
80107325:	e9 f6 fa ff ff       	jmp    80106e20 <deallocuvm.part.0>
8010732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107330:	89 d0                	mov    %edx,%eax
80107332:	5d                   	pop    %ebp
80107333:	c3                   	ret    
80107334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010733f:	90                   	nop

80107340 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107340:	f3 0f 1e fb          	endbr32 
80107344:	55                   	push   %ebp
80107345:	89 e5                	mov    %esp,%ebp
80107347:	57                   	push   %edi
80107348:	56                   	push   %esi
80107349:	53                   	push   %ebx
8010734a:	83 ec 0c             	sub    $0xc,%esp
8010734d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107350:	85 f6                	test   %esi,%esi
80107352:	74 55                	je     801073a9 <freevm+0x69>
  if(newsz >= oldsz)
80107354:	31 c9                	xor    %ecx,%ecx
80107356:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010735b:	89 f0                	mov    %esi,%eax
8010735d:	89 f3                	mov    %esi,%ebx
8010735f:	e8 bc fa ff ff       	call   80106e20 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107364:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010736a:	eb 0b                	jmp    80107377 <freevm+0x37>
8010736c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107370:	83 c3 04             	add    $0x4,%ebx
80107373:	39 df                	cmp    %ebx,%edi
80107375:	74 23                	je     8010739a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107377:	8b 03                	mov    (%ebx),%eax
80107379:	a8 01                	test   $0x1,%al
8010737b:	74 f3                	je     80107370 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010737d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107382:	83 ec 0c             	sub    $0xc,%esp
80107385:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107388:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010738d:	50                   	push   %eax
8010738e:	e8 ed b1 ff ff       	call   80102580 <kfree>
80107393:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107396:	39 df                	cmp    %ebx,%edi
80107398:	75 dd                	jne    80107377 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010739a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010739d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a0:	5b                   	pop    %ebx
801073a1:	5e                   	pop    %esi
801073a2:	5f                   	pop    %edi
801073a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073a4:	e9 d7 b1 ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
801073a9:	83 ec 0c             	sub    $0xc,%esp
801073ac:	68 d1 80 10 80       	push   $0x801080d1
801073b1:	e8 da 8f ff ff       	call   80100390 <panic>
801073b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073bd:	8d 76 00             	lea    0x0(%esi),%esi

801073c0 <setupkvm>:
{
801073c0:	f3 0f 1e fb          	endbr32 
801073c4:	55                   	push   %ebp
801073c5:	89 e5                	mov    %esp,%ebp
801073c7:	56                   	push   %esi
801073c8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073c9:	e8 72 b3 ff ff       	call   80102740 <kalloc>
801073ce:	89 c6                	mov    %eax,%esi
801073d0:	85 c0                	test   %eax,%eax
801073d2:	74 42                	je     80107416 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801073d4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073d7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073dc:	68 00 10 00 00       	push   $0x1000
801073e1:	6a 00                	push   $0x0
801073e3:	50                   	push   %eax
801073e4:	e8 67 d6 ff ff       	call   80104a50 <memset>
801073e9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073ec:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073ef:	83 ec 08             	sub    $0x8,%esp
801073f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073f5:	ff 73 0c             	pushl  0xc(%ebx)
801073f8:	8b 13                	mov    (%ebx),%edx
801073fa:	50                   	push   %eax
801073fb:	29 c1                	sub    %eax,%ecx
801073fd:	89 f0                	mov    %esi,%eax
801073ff:	e8 8c f9 ff ff       	call   80106d90 <mappages>
80107404:	83 c4 10             	add    $0x10,%esp
80107407:	85 c0                	test   %eax,%eax
80107409:	78 15                	js     80107420 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010740b:	83 c3 10             	add    $0x10,%ebx
8010740e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107414:	75 d6                	jne    801073ec <setupkvm+0x2c>
}
80107416:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107419:	89 f0                	mov    %esi,%eax
8010741b:	5b                   	pop    %ebx
8010741c:	5e                   	pop    %esi
8010741d:	5d                   	pop    %ebp
8010741e:	c3                   	ret    
8010741f:	90                   	nop
      freevm(pgdir);
80107420:	83 ec 0c             	sub    $0xc,%esp
80107423:	56                   	push   %esi
      return 0;
80107424:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107426:	e8 15 ff ff ff       	call   80107340 <freevm>
      return 0;
8010742b:	83 c4 10             	add    $0x10,%esp
}
8010742e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107431:	89 f0                	mov    %esi,%eax
80107433:	5b                   	pop    %ebx
80107434:	5e                   	pop    %esi
80107435:	5d                   	pop    %ebp
80107436:	c3                   	ret    
80107437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743e:	66 90                	xchg   %ax,%ax

80107440 <kvmalloc>:
{
80107440:	f3 0f 1e fb          	endbr32 
80107444:	55                   	push   %ebp
80107445:	89 e5                	mov    %esp,%ebp
80107447:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010744a:	e8 71 ff ff ff       	call   801073c0 <setupkvm>
8010744f:	a3 a4 69 11 80       	mov    %eax,0x801169a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107454:	05 00 00 00 80       	add    $0x80000000,%eax
80107459:	0f 22 d8             	mov    %eax,%cr3
}
8010745c:	c9                   	leave  
8010745d:	c3                   	ret    
8010745e:	66 90                	xchg   %ax,%ax

80107460 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107460:	f3 0f 1e fb          	endbr32 
80107464:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107465:	31 c9                	xor    %ecx,%ecx
{
80107467:	89 e5                	mov    %esp,%ebp
80107469:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010746c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010746f:	8b 45 08             	mov    0x8(%ebp),%eax
80107472:	e8 99 f8 ff ff       	call   80106d10 <walkpgdir>
  if(pte == 0)
80107477:	85 c0                	test   %eax,%eax
80107479:	74 05                	je     80107480 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010747b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010747e:	c9                   	leave  
8010747f:	c3                   	ret    
    panic("clearpteu");
80107480:	83 ec 0c             	sub    $0xc,%esp
80107483:	68 e2 80 10 80       	push   $0x801080e2
80107488:	e8 03 8f ff ff       	call   80100390 <panic>
8010748d:	8d 76 00             	lea    0x0(%esi),%esi

80107490 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107490:	f3 0f 1e fb          	endbr32 
80107494:	55                   	push   %ebp
80107495:	89 e5                	mov    %esp,%ebp
80107497:	57                   	push   %edi
80107498:	56                   	push   %esi
80107499:	53                   	push   %ebx
8010749a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010749d:	e8 1e ff ff ff       	call   801073c0 <setupkvm>
801074a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074a5:	85 c0                	test   %eax,%eax
801074a7:	0f 84 9b 00 00 00    	je     80107548 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074b0:	85 c9                	test   %ecx,%ecx
801074b2:	0f 84 90 00 00 00    	je     80107548 <copyuvm+0xb8>
801074b8:	31 f6                	xor    %esi,%esi
801074ba:	eb 46                	jmp    80107502 <copyuvm+0x72>
801074bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074c0:	83 ec 04             	sub    $0x4,%esp
801074c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801074c9:	68 00 10 00 00       	push   $0x1000
801074ce:	57                   	push   %edi
801074cf:	50                   	push   %eax
801074d0:	e8 1b d6 ff ff       	call   80104af0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074d5:	58                   	pop    %eax
801074d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074dc:	5a                   	pop    %edx
801074dd:	ff 75 e4             	pushl  -0x1c(%ebp)
801074e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074e5:	89 f2                	mov    %esi,%edx
801074e7:	50                   	push   %eax
801074e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074eb:	e8 a0 f8 ff ff       	call   80106d90 <mappages>
801074f0:	83 c4 10             	add    $0x10,%esp
801074f3:	85 c0                	test   %eax,%eax
801074f5:	78 61                	js     80107558 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801074f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107500:	76 46                	jbe    80107548 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107502:	8b 45 08             	mov    0x8(%ebp),%eax
80107505:	31 c9                	xor    %ecx,%ecx
80107507:	89 f2                	mov    %esi,%edx
80107509:	e8 02 f8 ff ff       	call   80106d10 <walkpgdir>
8010750e:	85 c0                	test   %eax,%eax
80107510:	74 61                	je     80107573 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107512:	8b 00                	mov    (%eax),%eax
80107514:	a8 01                	test   $0x1,%al
80107516:	74 4e                	je     80107566 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107518:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010751a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010751f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107522:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107528:	e8 13 b2 ff ff       	call   80102740 <kalloc>
8010752d:	89 c3                	mov    %eax,%ebx
8010752f:	85 c0                	test   %eax,%eax
80107531:	75 8d                	jne    801074c0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107533:	83 ec 0c             	sub    $0xc,%esp
80107536:	ff 75 e0             	pushl  -0x20(%ebp)
80107539:	e8 02 fe ff ff       	call   80107340 <freevm>
  return 0;
8010753e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107545:	83 c4 10             	add    $0x10,%esp
}
80107548:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010754b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010754e:	5b                   	pop    %ebx
8010754f:	5e                   	pop    %esi
80107550:	5f                   	pop    %edi
80107551:	5d                   	pop    %ebp
80107552:	c3                   	ret    
80107553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107557:	90                   	nop
      kfree(mem);
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	53                   	push   %ebx
8010755c:	e8 1f b0 ff ff       	call   80102580 <kfree>
      goto bad;
80107561:	83 c4 10             	add    $0x10,%esp
80107564:	eb cd                	jmp    80107533 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107566:	83 ec 0c             	sub    $0xc,%esp
80107569:	68 06 81 10 80       	push   $0x80108106
8010756e:	e8 1d 8e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107573:	83 ec 0c             	sub    $0xc,%esp
80107576:	68 ec 80 10 80       	push   $0x801080ec
8010757b:	e8 10 8e ff ff       	call   80100390 <panic>

80107580 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107580:	f3 0f 1e fb          	endbr32 
80107584:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107585:	31 c9                	xor    %ecx,%ecx
{
80107587:	89 e5                	mov    %esp,%ebp
80107589:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010758c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010758f:	8b 45 08             	mov    0x8(%ebp),%eax
80107592:	e8 79 f7 ff ff       	call   80106d10 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107597:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107599:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010759a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010759c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801075a1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075a4:	05 00 00 00 80       	add    $0x80000000,%eax
801075a9:	83 fa 05             	cmp    $0x5,%edx
801075ac:	ba 00 00 00 00       	mov    $0x0,%edx
801075b1:	0f 45 c2             	cmovne %edx,%eax
}
801075b4:	c3                   	ret    
801075b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801075c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075c0:	f3 0f 1e fb          	endbr32 
801075c4:	55                   	push   %ebp
801075c5:	89 e5                	mov    %esp,%ebp
801075c7:	57                   	push   %edi
801075c8:	56                   	push   %esi
801075c9:	53                   	push   %ebx
801075ca:	83 ec 0c             	sub    $0xc,%esp
801075cd:	8b 75 14             	mov    0x14(%ebp),%esi
801075d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075d3:	85 f6                	test   %esi,%esi
801075d5:	75 3c                	jne    80107613 <copyout+0x53>
801075d7:	eb 67                	jmp    80107640 <copyout+0x80>
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801075e0:	8b 55 0c             	mov    0xc(%ebp),%edx
801075e3:	89 fb                	mov    %edi,%ebx
801075e5:	29 d3                	sub    %edx,%ebx
801075e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801075ed:	39 f3                	cmp    %esi,%ebx
801075ef:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075f2:	29 fa                	sub    %edi,%edx
801075f4:	83 ec 04             	sub    $0x4,%esp
801075f7:	01 c2                	add    %eax,%edx
801075f9:	53                   	push   %ebx
801075fa:	ff 75 10             	pushl  0x10(%ebp)
801075fd:	52                   	push   %edx
801075fe:	e8 ed d4 ff ff       	call   80104af0 <memmove>
    len -= n;
    buf += n;
80107603:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107606:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010760c:	83 c4 10             	add    $0x10,%esp
8010760f:	29 de                	sub    %ebx,%esi
80107611:	74 2d                	je     80107640 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107613:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107615:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107618:	89 55 0c             	mov    %edx,0xc(%ebp)
8010761b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107621:	57                   	push   %edi
80107622:	ff 75 08             	pushl  0x8(%ebp)
80107625:	e8 56 ff ff ff       	call   80107580 <uva2ka>
    if(pa0 == 0)
8010762a:	83 c4 10             	add    $0x10,%esp
8010762d:	85 c0                	test   %eax,%eax
8010762f:	75 af                	jne    801075e0 <copyout+0x20>
  }
  return 0;
}
80107631:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107639:	5b                   	pop    %ebx
8010763a:	5e                   	pop    %esi
8010763b:	5f                   	pop    %edi
8010763c:	5d                   	pop    %ebp
8010763d:	c3                   	ret    
8010763e:	66 90                	xchg   %ax,%ax
80107640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107643:	31 c0                	xor    %eax,%eax
}
80107645:	5b                   	pop    %ebx
80107646:	5e                   	pop    %esi
80107647:	5f                   	pop    %edi
80107648:	5d                   	pop    %ebp
80107649:	c3                   	ret    
