
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp
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
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 c0 72 10 80       	push   $0x801072c0
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 a1 44 00 00       	call   80104500 <initlock>
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
80100092:	68 c7 72 10 80       	push   $0x801072c7
80100097:	50                   	push   %eax
80100098:	e8 23 43 00 00       	call   801043c0 <initsleeplock>
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
801000e8:	e8 93 45 00 00       	call   80104680 <acquire>
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
80100162:	e8 d9 45 00 00       	call   80104740 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 42 00 00       	call   80104400 <acquiresleep>
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
801001a3:	68 ce 72 10 80       	push   $0x801072ce
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
801001c2:	e8 d9 42 00 00       	call   801044a0 <holdingsleep>
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
801001e0:	68 df 72 10 80       	push   $0x801072df
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
80100203:	e8 98 42 00 00       	call   801044a0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 42 00 00       	call   80104460 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 5c 44 00 00       	call   80104680 <acquire>
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
80100270:	e9 cb 44 00 00       	jmp    80104740 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 72 10 80       	push   $0x801072e6
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
801002b1:	e8 ca 43 00 00       	call   80104680 <acquire>
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
801002e5:	e8 56 3d 00 00       	call   80104040 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 71 37 00 00       	call   80103a70 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 2d 44 00 00       	call   80104740 <release>
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
80100365:	e8 d6 43 00 00       	call   80104740 <release>
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
801003ad:	e8 fe 25 00 00       	call   801029b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 72 10 80       	push   $0x801072ed
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 5f 7c 10 80 	movl   $0x80107c5f,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 41 00 00       	call   80104520 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 73 10 80       	push   $0x80107301
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
8010042a:	e8 91 5a 00 00       	call   80105ec0 <uartputc>
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
80100515:	e8 a6 59 00 00       	call   80105ec0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 9a 59 00 00       	call   80105ec0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 8e 59 00 00       	call   80105ec0 <uartputc>
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
80100561:	e8 ca 42 00 00       	call   80104830 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 42 00 00       	call   80104790 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 73 10 80       	push   $0x80107305
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
801005c9:	0f b6 92 30 73 10 80 	movzbl -0x7fef8cd0(%edx),%edx
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
8010065f:	e8 1c 40 00 00       	call   80104680 <acquire>
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
80100697:	e8 a4 40 00 00       	call   80104740 <release>
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
8010077d:	bb 18 73 10 80       	mov    $0x80107318,%ebx
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
801007bd:	e8 be 3e 00 00       	call   80104680 <acquire>
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
80100828:	e8 13 3f 00 00       	call   80104740 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 73 10 80       	push   $0x8010731f
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
80100877:	e8 04 3e 00 00       	call   80104680 <acquire>
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
801009cf:	e8 6c 3d 00 00       	call   80104740 <release>
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
801009ff:	e9 ec 38 00 00       	jmp    801042f0 <procdump>
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
80100a20:	e8 db 37 00 00       	call   80104200 <wakeup>
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
80100a3a:	68 28 73 10 80       	push   $0x80107328
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 b7 3a 00 00       	call   80104500 <initlock>

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
80100a90:	e8 db 2f 00 00       	call   80103a70 <myproc>
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
80100b0c:	e8 1f 65 00 00       	call   80107030 <setupkvm>
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
80100b73:	e8 d8 62 00 00       	call   80106e50 <allocuvm>
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
80100ba9:	e8 d2 61 00 00       	call   80106d80 <loaduvm>
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
80100beb:	e8 c0 63 00 00       	call   80106fb0 <freevm>
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
80100c32:	e8 19 62 00 00       	call   80106e50 <allocuvm>
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
80100c53:	e8 78 64 00 00       	call   801070d0 <clearpteu>
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
80100ca3:	e8 e8 3c 00 00       	call   80104990 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 d5 3c 00 00       	call   80104990 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 65 00 00       	call   80107230 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ca 62 00 00       	call   80106fb0 <freevm>
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
80100d33:	e8 f8 64 00 00       	call   80107230 <copyout>
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
80100d71:	e8 da 3b 00 00       	call   80104950 <safestrcpy>
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
80100d9d:	e8 4e 5e 00 00       	call   80106bf0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 06 62 00 00       	call   80106fb0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 f7 20 00 00       	call   80102eb0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 41 73 10 80       	push   $0x80107341
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
80100dea:	68 4d 73 10 80       	push   $0x8010734d
80100def:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df4:	e8 07 37 00 00       	call   80104500 <initlock>
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
80100e15:	e8 66 38 00 00       	call   80104680 <acquire>
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
80100e41:	e8 fa 38 00 00       	call   80104740 <release>
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
80100e5a:	e8 e1 38 00 00       	call   80104740 <release>
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
80100e83:	e8 f8 37 00 00       	call   80104680 <acquire>
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
80100ea0:	e8 9b 38 00 00       	call   80104740 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 54 73 10 80       	push   $0x80107354
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
80100ed5:	e8 a6 37 00 00       	call   80104680 <acquire>
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
80100f10:	e8 2b 38 00 00       	call   80104740 <release>

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
80100f3e:	e9 fd 37 00 00       	jmp    80104740 <release>
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
80100f8c:	68 5c 73 10 80       	push   $0x8010735c
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
8010107a:	68 66 73 10 80       	push   $0x80107366
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
80101163:	68 6f 73 10 80       	push   $0x8010736f
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
80101199:	68 75 73 10 80       	push   $0x80107375
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
801011b9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
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
801011dc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
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
80101249:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 7f 73 10 80       	push   $0x8010737f
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
80101295:	e8 f6 34 00 00       	call   80104790 <memset>
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
801012ca:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 09 11 80       	push   $0x801109e0
801012da:	e8 a1 33 00 00       	call   80104680 <acquire>
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
801012fa:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
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
8010131b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
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
80101342:	68 e0 09 11 80       	push   $0x801109e0
80101347:	e8 f4 33 00 00       	call   80104740 <release>

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
8010136d:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101372:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101375:	e8 c6 33 00 00       	call   80104740 <release>
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
80101387:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010138d:	73 10                	jae    8010139f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101392:	85 c9                	test   %ecx,%ecx
80101394:	0f 8f 56 ff ff ff    	jg     801012f0 <iget+0x30>
8010139a:	e9 6e ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 95 73 10 80       	push   $0x80107395
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
8010146b:	68 a5 73 10 80       	push   $0x801073a5
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
801014a5:	e8 86 33 00 00       	call   80104830 <memmove>
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
801014cc:	68 c0 09 11 80       	push   $0x801109c0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 d8 09 11 80    	add    0x801109d8,%eax
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
80101534:	68 b8 73 10 80       	push   $0x801073b8
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 cb 73 10 80       	push   $0x801073cb
80101555:	68 e0 09 11 80       	push   $0x801109e0
8010155a:	e8 a1 2f 00 00       	call   80104500 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 d2 73 10 80       	push   $0x801073d2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 44 2e 00 00       	call   801043c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 09 11 80       	push   $0x801109c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010159d:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015a3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015a9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015af:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015b5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015bb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015c1:	68 54 74 10 80       	push   $0x80107454
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
801015f0:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
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
8010161f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
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
8010165e:	e8 2d 31 00 00       	call   80104790 <memset>
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
80101693:	68 d8 73 10 80       	push   $0x801073d8
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
801016b8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
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
80101705:	e8 26 31 00 00       	call   80104830 <memmove>
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
8010173e:	68 e0 09 11 80       	push   $0x801109e0
80101743:	e8 38 2f 00 00       	call   80104680 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101753:	e8 e8 2f 00 00       	call   80104740 <release>
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
80101786:	e8 75 2c 00 00       	call   80104400 <acquiresleep>
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
801017a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
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
801017f8:	e8 33 30 00 00       	call   80104830 <memmove>
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
8010181d:	68 f0 73 10 80       	push   $0x801073f0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ea 73 10 80       	push   $0x801073ea
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
80101857:	e8 44 2c 00 00       	call   801044a0 <holdingsleep>
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
80101873:	e9 e8 2b 00 00       	jmp    80104460 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 ff 73 10 80       	push   $0x801073ff
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
801018a4:	e8 57 2b 00 00       	call   80104400 <acquiresleep>
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
801018be:	e8 9d 2b 00 00       	call   80104460 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018ca:	e8 b1 2d 00 00       	call   80104680 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 57 2e 00 00       	jmp    80104740 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 09 11 80       	push   $0x801109e0
801018f8:	e8 83 2d 00 00       	call   80104680 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101907:	e8 34 2e 00 00       	call   80104740 <release>
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
80101b07:	e8 24 2d 00 00       	call   80104830 <memmove>
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
80101c03:	e8 28 2c 00 00       	call   80104830 <memmove>
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
80101ca2:	e8 f9 2b 00 00       	call   801048a0 <strncmp>
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
80101d05:	e8 96 2b 00 00       	call   801048a0 <strncmp>
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
80101d4a:	68 19 74 10 80       	push   $0x80107419
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 07 74 10 80       	push   $0x80107407
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
80101d8a:	e8 e1 1c 00 00       	call   80103a70 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 09 11 80       	push   $0x801109e0
80101d9c:	e8 df 28 00 00       	call   80104680 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dac:	e8 8f 29 00 00       	call   80104740 <release>
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
80101e17:	e8 14 2a 00 00       	call   80104830 <memmove>
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
80101ea3:	e8 88 29 00 00       	call   80104830 <memmove>
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
80101fd5:	e8 16 29 00 00       	call   801048f0 <strncpy>
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
80102013:	68 28 74 10 80       	push   $0x80107428
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 46 7a 10 80       	push   $0x80107a46
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
801020c3:	e8 68 27 00 00       	call   80104830 <memmove>
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
801020e3:	68 35 74 10 80       	push   $0x80107435
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
80102143:	e8 e8 26 00 00       	call   80104830 <memmove>
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
8010216b:	68 35 74 10 80       	push   $0x80107435
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
8010223b:	68 b0 74 10 80       	push   $0x801074b0
80102240:	e8 4b e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102245:	83 ec 0c             	sub    $0xc,%esp
80102248:	68 a7 74 10 80       	push   $0x801074a7
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
8010226a:	68 c2 74 10 80       	push   $0x801074c2
8010226f:	68 80 a5 10 80       	push   $0x8010a580
80102274:	e8 87 22 00 00       	call   80104500 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102279:	58                   	pop    %eax
8010227a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
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
80102302:	e8 79 23 00 00       	call   80104680 <acquire>

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
8010235d:	e8 9e 1e 00 00       	call   80104200 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102362:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102367:	83 c4 10             	add    $0x10,%esp
8010236a:	85 c0                	test   %eax,%eax
8010236c:	74 05                	je     80102373 <ideintr+0x83>
    idestart(idequeue);
8010236e:	e8 0d fe ff ff       	call   80102180 <idestart>
    release(&idelock);
80102373:	83 ec 0c             	sub    $0xc,%esp
80102376:	68 80 a5 10 80       	push   $0x8010a580
8010237b:	e8 c0 23 00 00       	call   80104740 <release>

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
801023a2:	e8 f9 20 00 00       	call   801044a0 <holdingsleep>
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
801023dc:	e8 9f 22 00 00       	call   80104680 <acquire>

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
80102429:	e8 12 1c 00 00       	call   80104040 <sleep>
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
80102446:	e9 f5 22 00 00       	jmp    80104740 <release>
8010244b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010244f:	90                   	nop
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 29 fd ff ff       	call   80102180 <idestart>
80102457:	eb b5                	jmp    8010240e <iderw+0x7e>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102465:	eb 9d                	jmp    80102404 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	68 f1 74 10 80       	push   $0x801074f1
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 dc 74 10 80       	push   $0x801074dc
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 c6 74 10 80       	push   $0x801074c6
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
80102495:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010249c:	00 c0 fe 
{
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	56                   	push   %esi
801024a2:	53                   	push   %ebx
  ioapic->reg = reg;
801024a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024aa:	00 00 00 
  return ioapic->data;
801024ad:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024bc:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024c2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
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
801024de:	68 10 75 10 80       	push   $0x80107510
801024e3:	e8 c8 e1 ff ff       	call   801006b0 <cprintf>
801024e8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102504:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
8010251e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102545:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102559:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102562:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102565:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102568:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010256a:	a1 34 26 11 80       	mov    0x80112634,%eax
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
80102596:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
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
801025b6:	e8 d5 21 00 00       	call   80104790 <memset>

  if(kmem.use_lock)
801025bb:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801025c1:	83 c4 10             	add    $0x10,%esp
801025c4:	85 d2                	test   %edx,%edx
801025c6:	75 20                	jne    801025e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025c8:	a1 78 26 11 80       	mov    0x80112678,%eax
801025cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025cf:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801025d4:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
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
801025eb:	68 40 26 11 80       	push   $0x80112640
801025f0:	e8 8b 20 00 00       	call   80104680 <acquire>
801025f5:	83 c4 10             	add    $0x10,%esp
801025f8:	eb ce                	jmp    801025c8 <kfree+0x48>
801025fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102600:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010260a:	c9                   	leave  
    release(&kmem.lock);
8010260b:	e9 30 21 00 00       	jmp    80104740 <release>
    panic("kfree");
80102610:	83 ec 0c             	sub    $0xc,%esp
80102613:	68 42 75 10 80       	push   $0x80107542
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
8010267f:	68 48 75 10 80       	push   $0x80107548
80102684:	68 40 26 11 80       	push   $0x80112640
80102689:	e8 72 1e 00 00       	call   80104500 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102694:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
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
80102724:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
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
80102744:	a1 74 26 11 80       	mov    0x80112674,%eax
80102749:	85 c0                	test   %eax,%eax
8010274b:	75 1b                	jne    80102768 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010274d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102752:	85 c0                	test   %eax,%eax
80102754:	74 0a                	je     80102760 <kalloc+0x20>
    kmem.freelist = r->next;
80102756:	8b 10                	mov    (%eax),%edx
80102758:	89 15 78 26 11 80    	mov    %edx,0x80112678
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
8010276e:	68 40 26 11 80       	push   $0x80112640
80102773:	e8 08 1f 00 00       	call   80104680 <acquire>
  r = kmem.freelist;
80102778:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010277d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102783:	83 c4 10             	add    $0x10,%esp
80102786:	85 c0                	test   %eax,%eax
80102788:	74 08                	je     80102792 <kalloc+0x52>
    kmem.freelist = r->next;
8010278a:	8b 08                	mov    (%eax),%ecx
8010278c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102792:	85 d2                	test   %edx,%edx
80102794:	74 16                	je     801027ac <kalloc+0x6c>
    release(&kmem.lock);
80102796:	83 ec 0c             	sub    $0xc,%esp
80102799:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010279c:	68 40 26 11 80       	push   $0x80112640
801027a1:	e8 9a 1f 00 00       	call   80104740 <release>
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
801027cc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
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
801027ef:	0f b6 8a 80 76 10 80 	movzbl -0x7fef8980(%edx),%ecx
  shift ^= togglecode[data];
801027f6:	0f b6 82 80 75 10 80 	movzbl -0x7fef8a80(%edx),%eax
  shift |= shiftcode[data];
801027fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801027ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102801:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102803:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102809:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010280c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010280f:	8b 04 85 60 75 10 80 	mov    -0x7fef8aa0(,%eax,4),%eax
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
80102835:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
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
8010284a:	0f b6 8a 80 76 10 80 	movzbl -0x7fef8980(%edx),%ecx
80102851:	83 c9 40             	or     $0x40,%ecx
80102854:	0f b6 c9             	movzbl %cl,%ecx
80102857:	f7 d1                	not    %ecx
80102859:	21 d9                	and    %ebx,%ecx
}
8010285b:	5b                   	pop    %ebx
8010285c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010285d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
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
801028b4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
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
801029b4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
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
801029d4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
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
80102a42:	a1 7c 26 11 80       	mov    0x8011267c,%eax
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
80102bcf:	e8 0c 1c 00 00       	call   801047e0 <memcmp>
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
80102ca0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
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
80102cc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102cc5:	83 ec 08             	sub    $0x8,%esp
80102cc8:	01 f8                	add    %edi,%eax
80102cca:	83 c0 01             	add    $0x1,%eax
80102ccd:	50                   	push   %eax
80102cce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
80102cd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cdb:	58                   	pop    %eax
80102cdc:	5a                   	pop    %edx
80102cdd:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102ce4:	ff 35 c4 26 11 80    	pushl  0x801126c4
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
80102d04:	e8 27 1b 00 00       	call   80104830 <memmove>
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
80102d24:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
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
80102d47:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102d4d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d53:	e8 78 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d5d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102d62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d65:	85 c0                	test   %eax,%eax
80102d67:	7e 19                	jle    80102d82 <write_head+0x42>
80102d69:	31 d2                	xor    %edx,%edx
80102d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d70:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
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
80102dae:	68 80 77 10 80       	push   $0x80107780
80102db3:	68 80 26 11 80       	push   $0x80112680
80102db8:	e8 43 17 00 00       	call   80104500 <initlock>
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
80102dcd:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102dd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102dd6:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102ddb:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102de1:	5a                   	pop    %edx
80102de2:	50                   	push   %eax
80102de3:	53                   	push   %ebx
80102de4:	e8 e7 d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102dec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102def:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102df5:	85 c9                	test   %ecx,%ecx
80102df7:	7e 19                	jle    80102e12 <initlog+0x72>
80102df9:	31 d2                	xor    %edx,%edx
80102dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102e00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102e04:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
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
80102e20:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
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
80102e4a:	68 80 26 11 80       	push   $0x80112680
80102e4f:	e8 2c 18 00 00       	call   80104680 <acquire>
80102e54:	83 c4 10             	add    $0x10,%esp
80102e57:	eb 1c                	jmp    80102e75 <begin_op+0x35>
80102e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e60:	83 ec 08             	sub    $0x8,%esp
80102e63:	68 80 26 11 80       	push   $0x80112680
80102e68:	68 80 26 11 80       	push   $0x80112680
80102e6d:	e8 ce 11 00 00       	call   80104040 <sleep>
80102e72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e75:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102e7a:	85 c0                	test   %eax,%eax
80102e7c:	75 e2                	jne    80102e60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e7e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e83:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
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
80102e9a:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102e9f:	68 80 26 11 80       	push   $0x80112680
80102ea4:	e8 97 18 00 00       	call   80104740 <release>
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
80102ebd:	68 80 26 11 80       	push   $0x80112680
80102ec2:	e8 b9 17 00 00       	call   80104680 <acquire>
  log.outstanding -= 1;
80102ec7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102ecc:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102ed2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ed5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ed8:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102ede:	85 f6                	test   %esi,%esi
80102ee0:	0f 85 1e 01 00 00    	jne    80103004 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ee6:	85 db                	test   %ebx,%ebx
80102ee8:	0f 85 f2 00 00 00    	jne    80102fe0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eee:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102ef5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ef8:	83 ec 0c             	sub    $0xc,%esp
80102efb:	68 80 26 11 80       	push   $0x80112680
80102f00:	e8 3b 18 00 00       	call   80104740 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f05:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102f0b:	83 c4 10             	add    $0x10,%esp
80102f0e:	85 c9                	test   %ecx,%ecx
80102f10:	7f 3e                	jg     80102f50 <end_op+0xa0>
    acquire(&log.lock);
80102f12:	83 ec 0c             	sub    $0xc,%esp
80102f15:	68 80 26 11 80       	push   $0x80112680
80102f1a:	e8 61 17 00 00       	call   80104680 <acquire>
    wakeup(&log);
80102f1f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102f26:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102f2d:	00 00 00 
    wakeup(&log);
80102f30:	e8 cb 12 00 00       	call   80104200 <wakeup>
    release(&log.lock);
80102f35:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102f3c:	e8 ff 17 00 00       	call   80104740 <release>
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
80102f50:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102f55:	83 ec 08             	sub    $0x8,%esp
80102f58:	01 d8                	add    %ebx,%eax
80102f5a:	83 c0 01             	add    $0x1,%eax
80102f5d:	50                   	push   %eax
80102f5e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102f64:	e8 67 d1 ff ff       	call   801000d0 <bread>
80102f69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f6b:	58                   	pop    %eax
80102f6c:	5a                   	pop    %edx
80102f6d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102f74:	ff 35 c4 26 11 80    	pushl  0x801126c4
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
80102f94:	e8 97 18 00 00       	call   80104830 <memmove>
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
80102fb4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102fba:	7c 94                	jl     80102f50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fbc:	e8 7f fd ff ff       	call   80102d40 <write_head>
    install_trans(); // Now install writes to home locations
80102fc1:	e8 da fc ff ff       	call   80102ca0 <install_trans>
    log.lh.n = 0;
80102fc6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102fcd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fd0:	e8 6b fd ff ff       	call   80102d40 <write_head>
80102fd5:	e9 38 ff ff ff       	jmp    80102f12 <end_op+0x62>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fe0:	83 ec 0c             	sub    $0xc,%esp
80102fe3:	68 80 26 11 80       	push   $0x80112680
80102fe8:	e8 13 12 00 00       	call   80104200 <wakeup>
  release(&log.lock);
80102fed:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ff4:	e8 47 17 00 00       	call   80104740 <release>
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
80103007:	68 84 77 10 80       	push   $0x80107784
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
8010302b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80103031:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103034:	83 fa 1d             	cmp    $0x1d,%edx
80103037:	0f 8f 91 00 00 00    	jg     801030ce <log_write+0xae>
8010303d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80103042:	83 e8 01             	sub    $0x1,%eax
80103045:	39 c2                	cmp    %eax,%edx
80103047:	0f 8d 81 00 00 00    	jge    801030ce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010304d:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80103052:	85 c0                	test   %eax,%eax
80103054:	0f 8e 81 00 00 00    	jle    801030db <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010305a:	83 ec 0c             	sub    $0xc,%esp
8010305d:	68 80 26 11 80       	push   $0x80112680
80103062:	e8 19 16 00 00       	call   80104680 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103067:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
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
80103087:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
8010308e:	75 f0                	jne    80103080 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103090:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103097:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010309a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010309d:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
801030a4:	c9                   	leave  
  release(&log.lock);
801030a5:	e9 96 16 00 00       	jmp    80104740 <release>
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
801030b7:	83 c2 01             	add    $0x1,%edx
801030ba:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
801030c0:	eb d5                	jmp    80103097 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801030c2:	8b 43 08             	mov    0x8(%ebx),%eax
801030c5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
801030ca:	75 cb                	jne    80103097 <log_write+0x77>
801030cc:	eb e9                	jmp    801030b7 <log_write+0x97>
    panic("too big a transaction");
801030ce:	83 ec 0c             	sub    $0xc,%esp
801030d1:	68 93 77 10 80       	push   $0x80107793
801030d6:	e8 b5 d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801030db:	83 ec 0c             	sub    $0xc,%esp
801030de:	68 a9 77 10 80       	push   $0x801077a9
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
801030f7:	e8 54 09 00 00       	call   80103a50 <cpuid>
801030fc:	89 c3                	mov    %eax,%ebx
801030fe:	e8 4d 09 00 00       	call   80103a50 <cpuid>
80103103:	83 ec 04             	sub    $0x4,%esp
80103106:	53                   	push   %ebx
80103107:	50                   	push   %eax
80103108:	68 c4 77 10 80       	push   $0x801077c4
8010310d:	e8 9e d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103112:	e8 e9 29 00 00       	call   80105b00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103117:	e8 c4 08 00 00       	call   801039e0 <mycpu>
8010311c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010311e:	b8 01 00 00 00       	mov    $0x1,%eax
80103123:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010312a:	e8 21 0c 00 00       	call   80103d50 <scheduler>
8010312f:	90                   	nop

80103130 <mpenter>:
{
80103130:	f3 0f 1e fb          	endbr32 
80103134:	55                   	push   %ebp
80103135:	89 e5                	mov    %esp,%ebp
80103137:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010313a:	e8 91 3a 00 00       	call   80106bd0 <switchkvm>
  seginit();
8010313f:	e8 fc 39 00 00       	call   80106b40 <seginit>
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
8010316b:	68 a8 54 11 80       	push   $0x801154a8
80103170:	e8 fb f4 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
80103175:	e8 36 3f 00 00       	call   801070b0 <kvmalloc>
  mpinit();        // detect other processors
8010317a:	e8 81 01 00 00       	call   80103300 <mpinit>
  lapicinit();     // interrupt controller
8010317f:	e8 2c f7 ff ff       	call   801028b0 <lapicinit>
  seginit();       // segment descriptors
80103184:	e8 b7 39 00 00       	call   80106b40 <seginit>
  picinit();       // disable pic
80103189:	e8 52 03 00 00       	call   801034e0 <picinit>
  ioapicinit();    // another interrupt controller
8010318e:	e8 fd f2 ff ff       	call   80102490 <ioapicinit>
  consoleinit();   // console hardware
80103193:	e8 98 d8 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103198:	e8 63 2c 00 00       	call   80105e00 <uartinit>
  pinit();         // process table
8010319d:	e8 1e 08 00 00       	call   801039c0 <pinit>
  tvinit();        // trap vectors
801031a2:	e8 d9 28 00 00       	call   80105a80 <tvinit>
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
801031be:	68 8c a4 10 80       	push   $0x8010a48c
801031c3:	68 00 70 00 80       	push   $0x80007000
801031c8:	e8 63 16 00 00       	call   80104830 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031cd:	83 c4 10             	add    $0x10,%esp
801031d0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801031d7:	00 00 00 
801031da:	05 80 27 11 80       	add    $0x80112780,%eax
801031df:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801031e4:	76 7a                	jbe    80103260 <main+0x110>
801031e6:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801031eb:	eb 1c                	jmp    80103209 <main+0xb9>
801031ed:	8d 76 00             	lea    0x0(%esi),%esi
801031f0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801031f7:	00 00 00 
801031fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103200:	05 80 27 11 80       	add    $0x80112780,%eax
80103205:	39 c3                	cmp    %eax,%ebx
80103207:	73 57                	jae    80103260 <main+0x110>
    if(c == mycpu())  // We've started already.
80103209:	e8 d2 07 00 00       	call   801039e0 <mycpu>
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
80103224:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010322b:	90 10 00 
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
80103272:	e8 29 08 00 00       	call   80103aa0 <userinit>
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
801032ae:	68 d8 77 10 80       	push   $0x801077d8
801032b3:	56                   	push   %esi
801032b4:	e8 27 15 00 00       	call   801047e0 <memcmp>
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
8010336a:	68 dd 77 10 80       	push   $0x801077dd
8010336f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103370:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103373:	e8 68 14 00 00       	call   801047e0 <memcmp>
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
801033ce:	a3 7c 26 11 80       	mov    %eax,0x8011267c
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
8010345f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103465:	eb 89                	jmp    801033f0 <mpinit+0xf0>
80103467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010346e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103470:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
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
801034c3:	68 e2 77 10 80       	push   $0x801077e2
801034c8:	e8 c3 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801034cd:	83 ec 0c             	sub    $0xc,%esp
801034d0:	68 fc 77 10 80       	push   $0x801077fc
801034d5:	e8 b6 ce ff ff       	call   80100390 <panic>
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801034e0:	f3 0f 1e fb          	endbr32 
801034e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034e9:	ba 21 00 00 00       	mov    $0x21,%edx
801034ee:	ee                   	out    %al,(%dx)
801034ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801034f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
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
80103577:	68 1b 78 10 80       	push   $0x8010781b
8010357c:	50                   	push   %eax
8010357d:	e8 7e 0f 00 00       	call   80104500 <initlock>
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
80103623:	e8 58 10 00 00       	call   80104680 <acquire>
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
80103643:	e8 b8 0b 00 00       	call   80104200 <wakeup>
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
80103668:	e9 d3 10 00 00       	jmp    80104740 <release>
8010366d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103679:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103680:	00 00 00 
    wakeup(&p->nwrite);
80103683:	50                   	push   %eax
80103684:	e8 77 0b 00 00       	call   80104200 <wakeup>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	eb bd                	jmp    8010364b <pipeclose+0x3b>
8010368e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	53                   	push   %ebx
80103694:	e8 a7 10 00 00       	call   80104740 <release>
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
801036c1:	e8 ba 0f 00 00       	call   80104680 <acquire>
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
80103708:	e8 63 03 00 00       	call   80103a70 <myproc>
8010370d:	8b 48 24             	mov    0x24(%eax),%ecx
80103710:	85 c9                	test   %ecx,%ecx
80103712:	75 34                	jne    80103748 <pipewrite+0x98>
      wakeup(&p->nread);
80103714:	83 ec 0c             	sub    $0xc,%esp
80103717:	57                   	push   %edi
80103718:	e8 e3 0a 00 00       	call   80104200 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371d:	58                   	pop    %eax
8010371e:	5a                   	pop    %edx
8010371f:	53                   	push   %ebx
80103720:	56                   	push   %esi
80103721:	e8 1a 09 00 00       	call   80104040 <sleep>
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
8010374c:	e8 ef 0f 00 00       	call   80104740 <release>
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
8010379a:	e8 61 0a 00 00       	call   80104200 <wakeup>
  release(&p->lock);
8010379f:	89 1c 24             	mov    %ebx,(%esp)
801037a2:	e8 99 0f 00 00       	call   80104740 <release>
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
801037ca:	e8 b1 0e 00 00       	call   80104680 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801037de:	74 33                	je     80103813 <piperead+0x63>
801037e0:	eb 3b                	jmp    8010381d <piperead+0x6d>
801037e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801037e8:	e8 83 02 00 00       	call   80103a70 <myproc>
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
801037fd:	e8 3e 08 00 00       	call   80104040 <sleep>
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
80103866:	e8 95 09 00 00       	call   80104200 <wakeup>
  release(&p->lock);
8010386b:	89 34 24             	mov    %esi,(%esp)
8010386e:	e8 cd 0e 00 00       	call   80104740 <release>
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
80103889:	e8 b2 0e 00 00       	call   80104740 <release>
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
801038a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801038a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038ac:	68 20 2d 11 80       	push   $0x80112d20
801038b1:	e8 ca 0d 00 00       	call   80104680 <acquire>
801038b6:	83 c4 10             	add    $0x10,%esp
801038b9:	eb 10                	jmp    801038cb <allocproc+0x2b>
801038bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c0:	83 c3 7c             	add    $0x7c,%ebx
801038c3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801038c9:	74 75                	je     80103940 <allocproc+0xa0>
    if(p->state == UNUSED)
801038cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801038ce:	85 c0                	test   %eax,%eax
801038d0:	75 ee                	jne    801038c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038d2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801038d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038da:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038e1:	89 43 10             	mov    %eax,0x10(%ebx)
801038e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801038e7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801038ec:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801038f2:	e8 49 0e 00 00       	call   80104740 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038f7:	e8 44 ee ff ff       	call   80102740 <kalloc>
801038fc:	83 c4 10             	add    $0x10,%esp
801038ff:	89 43 08             	mov    %eax,0x8(%ebx)
80103902:	85 c0                	test   %eax,%eax
80103904:	74 53                	je     80103959 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103906:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010390c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010390f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103914:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103917:	c7 40 14 66 5a 10 80 	movl   $0x80105a66,0x14(%eax)
  p->context = (struct context*)sp;
8010391e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103921:	6a 14                	push   $0x14
80103923:	6a 00                	push   $0x0
80103925:	50                   	push   %eax
80103926:	e8 65 0e 00 00       	call   80104790 <memset>
  p->context->eip = (uint)forkret;
8010392b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010392e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103931:	c7 40 10 70 39 10 80 	movl   $0x80103970,0x10(%eax)
}
80103938:	89 d8                	mov    %ebx,%eax
8010393a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010393d:	c9                   	leave  
8010393e:	c3                   	ret    
8010393f:	90                   	nop
  release(&ptable.lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103943:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103945:	68 20 2d 11 80       	push   $0x80112d20
8010394a:	e8 f1 0d 00 00       	call   80104740 <release>
}
8010394f:	89 d8                	mov    %ebx,%eax
  return 0;
80103951:	83 c4 10             	add    $0x10,%esp
}
80103954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103957:	c9                   	leave  
80103958:	c3                   	ret    
    p->state = UNUSED;
80103959:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103960:	31 db                	xor    %ebx,%ebx
}
80103962:	89 d8                	mov    %ebx,%eax
80103964:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103967:	c9                   	leave  
80103968:	c3                   	ret    
80103969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103970 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103970:	f3 0f 1e fb          	endbr32 
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010397a:	68 20 2d 11 80       	push   $0x80112d20
8010397f:	e8 bc 0d 00 00       	call   80104740 <release>

  if (first) {
80103984:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103989:	83 c4 10             	add    $0x10,%esp
8010398c:	85 c0                	test   %eax,%eax
8010398e:	75 08                	jne    80103998 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103990:	c9                   	leave  
80103991:	c3                   	ret    
80103992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103998:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010399f:	00 00 00 
    iinit(ROOTDEV);
801039a2:	83 ec 0c             	sub    $0xc,%esp
801039a5:	6a 01                	push   $0x1
801039a7:	e8 94 db ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801039ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039b3:	e8 e8 f3 ff ff       	call   80102da0 <initlog>
}
801039b8:	83 c4 10             	add    $0x10,%esp
801039bb:	c9                   	leave  
801039bc:	c3                   	ret    
801039bd:	8d 76 00             	lea    0x0(%esi),%esi

801039c0 <pinit>:
{
801039c0:	f3 0f 1e fb          	endbr32 
801039c4:	55                   	push   %ebp
801039c5:	89 e5                	mov    %esp,%ebp
801039c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039ca:	68 20 78 10 80       	push   $0x80107820
801039cf:	68 20 2d 11 80       	push   $0x80112d20
801039d4:	e8 27 0b 00 00       	call   80104500 <initlock>
}
801039d9:	83 c4 10             	add    $0x10,%esp
801039dc:	c9                   	leave  
801039dd:	c3                   	ret    
801039de:	66 90                	xchg   %ax,%ax

801039e0 <mycpu>:
{
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	56                   	push   %esi
801039e8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039e9:	9c                   	pushf  
801039ea:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039eb:	f6 c4 02             	test   $0x2,%ah
801039ee:	75 4a                	jne    80103a3a <mycpu+0x5a>
  apicid = lapicid();
801039f0:	e8 bb ef ff ff       	call   801029b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039f5:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
801039fb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801039fd:	85 f6                	test   %esi,%esi
801039ff:	7e 2c                	jle    80103a2d <mycpu+0x4d>
80103a01:	31 d2                	xor    %edx,%edx
80103a03:	eb 0a                	jmp    80103a0f <mycpu+0x2f>
80103a05:	8d 76 00             	lea    0x0(%esi),%esi
80103a08:	83 c2 01             	add    $0x1,%edx
80103a0b:	39 f2                	cmp    %esi,%edx
80103a0d:	74 1e                	je     80103a2d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103a0f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a15:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
80103a1c:	39 d8                	cmp    %ebx,%eax
80103a1e:	75 e8                	jne    80103a08 <mycpu+0x28>
}
80103a20:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a23:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103a29:	5b                   	pop    %ebx
80103a2a:	5e                   	pop    %esi
80103a2b:	5d                   	pop    %ebp
80103a2c:	c3                   	ret    
  panic("unknown apicid\n");
80103a2d:	83 ec 0c             	sub    $0xc,%esp
80103a30:	68 27 78 10 80       	push   $0x80107827
80103a35:	e8 56 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a3a:	83 ec 0c             	sub    $0xc,%esp
80103a3d:	68 0c 79 10 80       	push   $0x8010790c
80103a42:	e8 49 c9 ff ff       	call   80100390 <panic>
80103a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4e:	66 90                	xchg   %ax,%ax

80103a50 <cpuid>:
cpuid() {
80103a50:	f3 0f 1e fb          	endbr32 
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a5a:	e8 81 ff ff ff       	call   801039e0 <mycpu>
}
80103a5f:	c9                   	leave  
  return mycpu()-cpus;
80103a60:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103a65:	c1 f8 04             	sar    $0x4,%eax
80103a68:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a6e:	c3                   	ret    
80103a6f:	90                   	nop

80103a70 <myproc>:
myproc(void) {
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	53                   	push   %ebx
80103a78:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a7b:	e8 00 0b 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103a80:	e8 5b ff ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103a85:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a8b:	e8 40 0b 00 00       	call   801045d0 <popcli>
}
80103a90:	83 c4 04             	add    $0x4,%esp
80103a93:	89 d8                	mov    %ebx,%eax
80103a95:	5b                   	pop    %ebx
80103a96:	5d                   	pop    %ebp
80103a97:	c3                   	ret    
80103a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop

80103aa0 <userinit>:
{
80103aa0:	f3 0f 1e fb          	endbr32 
80103aa4:	55                   	push   %ebp
80103aa5:	89 e5                	mov    %esp,%ebp
80103aa7:	53                   	push   %ebx
80103aa8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103aab:	e8 f0 fd ff ff       	call   801038a0 <allocproc>
80103ab0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103ab2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103ab7:	e8 74 35 00 00       	call   80107030 <setupkvm>
80103abc:	89 43 04             	mov    %eax,0x4(%ebx)
80103abf:	85 c0                	test   %eax,%eax
80103ac1:	0f 84 d6 00 00 00    	je     80103b9d <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80103ac7:	83 ec 04             	sub    $0x4,%esp
80103aca:	68 2c 00 00 00       	push   $0x2c
80103acf:	68 60 a4 10 80       	push   $0x8010a460
80103ad4:	68 50 78 10 80       	push   $0x80107850
80103ad9:	e8 d2 cb ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ade:	83 c4 0c             	add    $0xc,%esp
80103ae1:	68 2c 00 00 00       	push   $0x2c
80103ae6:	68 60 a4 10 80       	push   $0x8010a460
80103aeb:	ff 73 04             	pushl  0x4(%ebx)
80103aee:	e8 0d 32 00 00       	call   80106d00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103af3:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103af6:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103afc:	6a 4c                	push   $0x4c
80103afe:	6a 00                	push   $0x0
80103b00:	ff 73 18             	pushl  0x18(%ebx)
80103b03:	e8 88 0c 00 00       	call   80104790 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b08:	8b 43 18             	mov    0x18(%ebx),%eax
80103b0b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b10:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b13:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b18:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b1f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b23:	8b 43 18             	mov    0x18(%ebx),%eax
80103b26:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b2a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b2e:	8b 43 18             	mov    0x18(%ebx),%eax
80103b31:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b35:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b39:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b43:	8b 43 18             	mov    0x18(%ebx),%eax
80103b46:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b4d:	8b 43 18             	mov    0x18(%ebx),%eax
80103b50:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b57:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b5a:	6a 10                	push   $0x10
80103b5c:	68 57 78 10 80       	push   $0x80107857
80103b61:	50                   	push   %eax
80103b62:	e8 e9 0d 00 00       	call   80104950 <safestrcpy>
  p->cwd = namei("/");
80103b67:	c7 04 24 60 78 10 80 	movl   $0x80107860,(%esp)
80103b6e:	e8 bd e4 ff ff       	call   80102030 <namei>
80103b73:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b76:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b7d:	e8 fe 0a 00 00       	call   80104680 <acquire>
  p->state = RUNNABLE;
80103b82:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b90:	e8 ab 0b 00 00       	call   80104740 <release>
}
80103b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b98:	83 c4 10             	add    $0x10,%esp
80103b9b:	c9                   	leave  
80103b9c:	c3                   	ret    
    panic("userinit: out of memory?");
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	68 37 78 10 80       	push   $0x80107837
80103ba5:	e8 e6 c7 ff ff       	call   80100390 <panic>
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bb0 <growproc>:
{
80103bb0:	f3 0f 1e fb          	endbr32 
80103bb4:	55                   	push   %ebp
80103bb5:	89 e5                	mov    %esp,%ebp
80103bb7:	56                   	push   %esi
80103bb8:	53                   	push   %ebx
80103bb9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bbc:	e8 bf 09 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103bc1:	e8 1a fe ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103bc6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bcc:	e8 ff 09 00 00       	call   801045d0 <popcli>
  sz = curproc->sz;
80103bd1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bd3:	85 f6                	test   %esi,%esi
80103bd5:	7f 19                	jg     80103bf0 <growproc+0x40>
  } else if(n < 0){
80103bd7:	75 37                	jne    80103c10 <growproc+0x60>
  switchuvm(curproc);
80103bd9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bdc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bde:	53                   	push   %ebx
80103bdf:	e8 0c 30 00 00       	call   80106bf0 <switchuvm>
  return 0;
80103be4:	83 c4 10             	add    $0x10,%esp
80103be7:	31 c0                	xor    %eax,%eax
}
80103be9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bec:	5b                   	pop    %ebx
80103bed:	5e                   	pop    %esi
80103bee:	5d                   	pop    %ebp
80103bef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bf0:	83 ec 04             	sub    $0x4,%esp
80103bf3:	01 c6                	add    %eax,%esi
80103bf5:	56                   	push   %esi
80103bf6:	50                   	push   %eax
80103bf7:	ff 73 04             	pushl  0x4(%ebx)
80103bfa:	e8 51 32 00 00       	call   80106e50 <allocuvm>
80103bff:	83 c4 10             	add    $0x10,%esp
80103c02:	85 c0                	test   %eax,%eax
80103c04:	75 d3                	jne    80103bd9 <growproc+0x29>
      return -1;
80103c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c0b:	eb dc                	jmp    80103be9 <growproc+0x39>
80103c0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	01 c6                	add    %eax,%esi
80103c15:	56                   	push   %esi
80103c16:	50                   	push   %eax
80103c17:	ff 73 04             	pushl  0x4(%ebx)
80103c1a:	e8 61 33 00 00       	call   80106f80 <deallocuvm>
80103c1f:	83 c4 10             	add    $0x10,%esp
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 b3                	jne    80103bd9 <growproc+0x29>
80103c26:	eb de                	jmp    80103c06 <growproc+0x56>
80103c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2f:	90                   	nop

80103c30 <fork>:
{
80103c30:	f3 0f 1e fb          	endbr32 
80103c34:	55                   	push   %ebp
80103c35:	89 e5                	mov    %esp,%ebp
80103c37:	57                   	push   %edi
80103c38:	56                   	push   %esi
80103c39:	53                   	push   %ebx
80103c3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c3d:	e8 3e 09 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103c42:	e8 99 fd ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103c47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c4d:	e8 7e 09 00 00       	call   801045d0 <popcli>
  if((np = allocproc()) == 0){
80103c52:	e8 49 fc ff ff       	call   801038a0 <allocproc>
80103c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c5a:	85 c0                	test   %eax,%eax
80103c5c:	0f 84 bb 00 00 00    	je     80103d1d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c62:	83 ec 08             	sub    $0x8,%esp
80103c65:	ff 33                	pushl  (%ebx)
80103c67:	89 c7                	mov    %eax,%edi
80103c69:	ff 73 04             	pushl  0x4(%ebx)
80103c6c:	e8 8f 34 00 00       	call   80107100 <copyuvm>
80103c71:	83 c4 10             	add    $0x10,%esp
80103c74:	89 47 04             	mov    %eax,0x4(%edi)
80103c77:	85 c0                	test   %eax,%eax
80103c79:	0f 84 a5 00 00 00    	je     80103d24 <fork+0xf4>
  np->sz = curproc->sz;
80103c7f:	8b 03                	mov    (%ebx),%eax
80103c81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c89:	89 c8                	mov    %ecx,%eax
80103c8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c93:	8b 73 18             	mov    0x18(%ebx),%esi
80103c96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c9a:	8b 40 18             	mov    0x18(%eax),%eax
80103c9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ca8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cac:	85 c0                	test   %eax,%eax
80103cae:	74 13                	je     80103cc3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	50                   	push   %eax
80103cb4:	e8 b7 d1 ff ff       	call   80100e70 <filedup>
80103cb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cc3:	83 c6 01             	add    $0x1,%esi
80103cc6:	83 fe 10             	cmp    $0x10,%esi
80103cc9:	75 dd                	jne    80103ca8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103ccb:	83 ec 0c             	sub    $0xc,%esp
80103cce:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cd1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cd4:	e8 57 da ff ff       	call   80101730 <idup>
80103cd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cdc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cdf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ce2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ce5:	6a 10                	push   $0x10
80103ce7:	53                   	push   %ebx
80103ce8:	50                   	push   %eax
80103ce9:	e8 62 0c 00 00       	call   80104950 <safestrcpy>
  pid = np->pid;
80103cee:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103cf1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf8:	e8 83 09 00 00       	call   80104680 <acquire>
  np->state = RUNNABLE;
80103cfd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d04:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d0b:	e8 30 0a 00 00       	call   80104740 <release>
  return pid;
80103d10:	83 c4 10             	add    $0x10,%esp
}
80103d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d16:	89 d8                	mov    %ebx,%eax
80103d18:	5b                   	pop    %ebx
80103d19:	5e                   	pop    %esi
80103d1a:	5f                   	pop    %edi
80103d1b:	5d                   	pop    %ebp
80103d1c:	c3                   	ret    
    return -1;
80103d1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d22:	eb ef                	jmp    80103d13 <fork+0xe3>
    kfree(np->kstack);
80103d24:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d27:	83 ec 0c             	sub    $0xc,%esp
80103d2a:	ff 73 08             	pushl  0x8(%ebx)
80103d2d:	e8 4e e8 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80103d32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d39:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d3c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d48:	eb c9                	jmp    80103d13 <fork+0xe3>
80103d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d50 <scheduler>:
{
80103d50:	f3 0f 1e fb          	endbr32 
80103d54:	55                   	push   %ebp
80103d55:	89 e5                	mov    %esp,%ebp
80103d57:	57                   	push   %edi
80103d58:	56                   	push   %esi
80103d59:	53                   	push   %ebx
80103d5a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d5d:	e8 7e fc ff ff       	call   801039e0 <mycpu>
  c->proc = 0;
80103d62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d69:	00 00 00 
  struct cpu *c = mycpu();
80103d6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d6e:	8d 78 04             	lea    0x4(%eax),%edi
80103d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103d78:	fb                   	sti    
    acquire(&ptable.lock);
80103d79:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d7c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103d81:	68 20 2d 11 80       	push   $0x80112d20
80103d86:	e8 f5 08 00 00       	call   80104680 <acquire>
80103d8b:	83 c4 10             	add    $0x10,%esp
80103d8e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d94:	75 33                	jne    80103dc9 <scheduler+0x79>
      switchuvm(p);
80103d96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d9f:	53                   	push   %ebx
80103da0:	e8 4b 2e 00 00       	call   80106bf0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103da5:	58                   	pop    %eax
80103da6:	5a                   	pop    %edx
80103da7:	ff 73 1c             	pushl  0x1c(%ebx)
80103daa:	57                   	push   %edi
      p->state = RUNNING;
80103dab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103db2:	e8 fc 0b 00 00       	call   801049b3 <swtch>
      switchkvm();
80103db7:	e8 14 2e 00 00       	call   80106bd0 <switchkvm>
      c->proc = 0;
80103dbc:	83 c4 10             	add    $0x10,%esp
80103dbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103dc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc9:	83 c3 7c             	add    $0x7c,%ebx
80103dcc:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103dd2:	75 bc                	jne    80103d90 <scheduler+0x40>
    release(&ptable.lock);
80103dd4:	83 ec 0c             	sub    $0xc,%esp
80103dd7:	68 20 2d 11 80       	push   $0x80112d20
80103ddc:	e8 5f 09 00 00       	call   80104740 <release>
    sti();
80103de1:	83 c4 10             	add    $0x10,%esp
80103de4:	eb 92                	jmp    80103d78 <scheduler+0x28>
80103de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ded:	8d 76 00             	lea    0x0(%esi),%esi

80103df0 <sched>:
{
80103df0:	f3 0f 1e fb          	endbr32 
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	56                   	push   %esi
80103df8:	53                   	push   %ebx
  pushcli();
80103df9:	e8 82 07 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103dfe:	e8 dd fb ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103e03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e09:	e8 c2 07 00 00       	call   801045d0 <popcli>
  if(!holding(&ptable.lock))
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	68 20 2d 11 80       	push   $0x80112d20
80103e16:	e8 15 08 00 00       	call   80104630 <holding>
80103e1b:	83 c4 10             	add    $0x10,%esp
80103e1e:	85 c0                	test   %eax,%eax
80103e20:	74 4f                	je     80103e71 <sched+0x81>
  if(mycpu()->ncli != 1)
80103e22:	e8 b9 fb ff ff       	call   801039e0 <mycpu>
80103e27:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e2e:	75 68                	jne    80103e98 <sched+0xa8>
  if(p->state == RUNNING)
80103e30:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e34:	74 55                	je     80103e8b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e36:	9c                   	pushf  
80103e37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e38:	f6 c4 02             	test   $0x2,%ah
80103e3b:	75 41                	jne    80103e7e <sched+0x8e>
  intena = mycpu()->intena;
80103e3d:	e8 9e fb ff ff       	call   801039e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e42:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e45:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e4b:	e8 90 fb ff ff       	call   801039e0 <mycpu>
80103e50:	83 ec 08             	sub    $0x8,%esp
80103e53:	ff 70 04             	pushl  0x4(%eax)
80103e56:	53                   	push   %ebx
80103e57:	e8 57 0b 00 00       	call   801049b3 <swtch>
  mycpu()->intena = intena;
80103e5c:	e8 7f fb ff ff       	call   801039e0 <mycpu>
}
80103e61:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e64:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e6d:	5b                   	pop    %ebx
80103e6e:	5e                   	pop    %esi
80103e6f:	5d                   	pop    %ebp
80103e70:	c3                   	ret    
    panic("sched ptable.lock");
80103e71:	83 ec 0c             	sub    $0xc,%esp
80103e74:	68 62 78 10 80       	push   $0x80107862
80103e79:	e8 12 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103e7e:	83 ec 0c             	sub    $0xc,%esp
80103e81:	68 8e 78 10 80       	push   $0x8010788e
80103e86:	e8 05 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e8b:	83 ec 0c             	sub    $0xc,%esp
80103e8e:	68 80 78 10 80       	push   $0x80107880
80103e93:	e8 f8 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103e98:	83 ec 0c             	sub    $0xc,%esp
80103e9b:	68 74 78 10 80       	push   $0x80107874
80103ea0:	e8 eb c4 ff ff       	call   80100390 <panic>
80103ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103eb0 <exit>:
{
80103eb0:	f3 0f 1e fb          	endbr32 
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	57                   	push   %edi
80103eb8:	56                   	push   %esi
80103eb9:	53                   	push   %ebx
80103eba:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ebd:	e8 be 06 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103ec2:	e8 19 fb ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103ec7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ecd:	e8 fe 06 00 00       	call   801045d0 <popcli>
  if(curproc == initproc)
80103ed2:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ed5:	8d 7e 68             	lea    0x68(%esi),%edi
80103ed8:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103ede:	0f 84 f3 00 00 00    	je     80103fd7 <exit+0x127>
80103ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103ee8:	8b 03                	mov    (%ebx),%eax
80103eea:	85 c0                	test   %eax,%eax
80103eec:	74 12                	je     80103f00 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103eee:	83 ec 0c             	sub    $0xc,%esp
80103ef1:	50                   	push   %eax
80103ef2:	e8 c9 cf ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103ef7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103efd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f00:	83 c3 04             	add    $0x4,%ebx
80103f03:	39 df                	cmp    %ebx,%edi
80103f05:	75 e1                	jne    80103ee8 <exit+0x38>
  begin_op();
80103f07:	e8 34 ef ff ff       	call   80102e40 <begin_op>
  iput(curproc->cwd);
80103f0c:	83 ec 0c             	sub    $0xc,%esp
80103f0f:	ff 76 68             	pushl  0x68(%esi)
80103f12:	e8 79 d9 ff ff       	call   80101890 <iput>
  end_op();
80103f17:	e8 94 ef ff ff       	call   80102eb0 <end_op>
  curproc->cwd = 0;
80103f1c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f2a:	e8 51 07 00 00       	call   80104680 <acquire>
  wakeup1(curproc->parent);
80103f2f:	8b 56 14             	mov    0x14(%esi),%edx
80103f32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f35:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f3a:	eb 0e                	jmp    80103f4a <exit+0x9a>
80103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f40:	83 c0 7c             	add    $0x7c,%eax
80103f43:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f48:	74 1c                	je     80103f66 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103f4a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f4e:	75 f0                	jne    80103f40 <exit+0x90>
80103f50:	3b 50 20             	cmp    0x20(%eax),%edx
80103f53:	75 eb                	jne    80103f40 <exit+0x90>
      p->state = RUNNABLE;
80103f55:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f5c:	83 c0 7c             	add    $0x7c,%eax
80103f5f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f64:	75 e4                	jne    80103f4a <exit+0x9a>
      p->parent = initproc;
80103f66:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103f71:	eb 10                	jmp    80103f83 <exit+0xd3>
80103f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f77:	90                   	nop
80103f78:	83 c2 7c             	add    $0x7c,%edx
80103f7b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103f81:	74 3b                	je     80103fbe <exit+0x10e>
    if(p->parent == curproc){
80103f83:	39 72 14             	cmp    %esi,0x14(%edx)
80103f86:	75 f0                	jne    80103f78 <exit+0xc8>
      if(p->state == ZOMBIE)
80103f88:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f8c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f8f:	75 e7                	jne    80103f78 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f91:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f96:	eb 12                	jmp    80103faa <exit+0xfa>
80103f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop
80103fa0:	83 c0 7c             	add    $0x7c,%eax
80103fa3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103fa8:	74 ce                	je     80103f78 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103faa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fae:	75 f0                	jne    80103fa0 <exit+0xf0>
80103fb0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fb3:	75 eb                	jne    80103fa0 <exit+0xf0>
      p->state = RUNNABLE;
80103fb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fbc:	eb e2                	jmp    80103fa0 <exit+0xf0>
  curproc->state = ZOMBIE;
80103fbe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103fc5:	e8 26 fe ff ff       	call   80103df0 <sched>
  panic("zombie exit");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 af 78 10 80       	push   $0x801078af
80103fd2:	e8 b9 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 a2 78 10 80       	push   $0x801078a2
80103fdf:	e8 ac c3 ff ff       	call   80100390 <panic>
80103fe4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fef:	90                   	nop

80103ff0 <yield>:
{
80103ff0:	f3 0f 1e fb          	endbr32 
80103ff4:	55                   	push   %ebp
80103ff5:	89 e5                	mov    %esp,%ebp
80103ff7:	53                   	push   %ebx
80103ff8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ffb:	68 20 2d 11 80       	push   $0x80112d20
80104000:	e8 7b 06 00 00       	call   80104680 <acquire>
  pushcli();
80104005:	e8 76 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
8010400a:	e8 d1 f9 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
8010400f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104015:	e8 b6 05 00 00       	call   801045d0 <popcli>
  myproc()->state = RUNNABLE;
8010401a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104021:	e8 ca fd ff ff       	call   80103df0 <sched>
  release(&ptable.lock);
80104026:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010402d:	e8 0e 07 00 00       	call   80104740 <release>
}
80104032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104035:	83 c4 10             	add    $0x10,%esp
80104038:	c9                   	leave  
80104039:	c3                   	ret    
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104040 <sleep>:
{
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	57                   	push   %edi
80104048:	56                   	push   %esi
80104049:	53                   	push   %ebx
8010404a:	83 ec 0c             	sub    $0xc,%esp
8010404d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104050:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104053:	e8 28 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104058:	e8 83 f9 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
8010405d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104063:	e8 68 05 00 00       	call   801045d0 <popcli>
  if(p == 0)
80104068:	85 db                	test   %ebx,%ebx
8010406a:	0f 84 83 00 00 00    	je     801040f3 <sleep+0xb3>
  if(lk == 0)
80104070:	85 f6                	test   %esi,%esi
80104072:	74 72                	je     801040e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104074:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010407a:	74 4c                	je     801040c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010407c:	83 ec 0c             	sub    $0xc,%esp
8010407f:	68 20 2d 11 80       	push   $0x80112d20
80104084:	e8 f7 05 00 00       	call   80104680 <acquire>
    release(lk);
80104089:	89 34 24             	mov    %esi,(%esp)
8010408c:	e8 af 06 00 00       	call   80104740 <release>
  p->chan = chan;
80104091:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104094:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010409b:	e8 50 fd ff ff       	call   80103df0 <sched>
  p->chan = 0;
801040a0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040a7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040ae:	e8 8d 06 00 00       	call   80104740 <release>
    acquire(lk);
801040b3:	89 75 08             	mov    %esi,0x8(%ebp)
801040b6:	83 c4 10             	add    $0x10,%esp
}
801040b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040bc:	5b                   	pop    %ebx
801040bd:	5e                   	pop    %esi
801040be:	5f                   	pop    %edi
801040bf:	5d                   	pop    %ebp
    acquire(lk);
801040c0:	e9 bb 05 00 00       	jmp    80104680 <acquire>
801040c5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801040c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040d2:	e8 19 fd ff ff       	call   80103df0 <sched>
  p->chan = 0;
801040d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5f                   	pop    %edi
801040e4:	5d                   	pop    %ebp
801040e5:	c3                   	ret    
    panic("sleep without lk");
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	68 c1 78 10 80       	push   $0x801078c1
801040ee:	e8 9d c2 ff ff       	call   80100390 <panic>
    panic("sleep");
801040f3:	83 ec 0c             	sub    $0xc,%esp
801040f6:	68 bb 78 10 80       	push   $0x801078bb
801040fb:	e8 90 c2 ff ff       	call   80100390 <panic>

80104100 <wait>:
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	56                   	push   %esi
80104108:	53                   	push   %ebx
  pushcli();
80104109:	e8 72 04 00 00       	call   80104580 <pushcli>
  c = mycpu();
8010410e:	e8 cd f8 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80104113:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104119:	e8 b2 04 00 00       	call   801045d0 <popcli>
  acquire(&ptable.lock);
8010411e:	83 ec 0c             	sub    $0xc,%esp
80104121:	68 20 2d 11 80       	push   $0x80112d20
80104126:	e8 55 05 00 00       	call   80104680 <acquire>
8010412b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010412e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104130:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104135:	eb 14                	jmp    8010414b <wait+0x4b>
80104137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413e:	66 90                	xchg   %ax,%ax
80104140:	83 c3 7c             	add    $0x7c,%ebx
80104143:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104149:	74 1b                	je     80104166 <wait+0x66>
      if(p->parent != curproc)
8010414b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010414e:	75 f0                	jne    80104140 <wait+0x40>
      if(p->state == ZOMBIE){
80104150:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104154:	74 32                	je     80104188 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104156:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104159:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415e:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104164:	75 e5                	jne    8010414b <wait+0x4b>
    if(!havekids || curproc->killed){
80104166:	85 c0                	test   %eax,%eax
80104168:	74 74                	je     801041de <wait+0xde>
8010416a:	8b 46 24             	mov    0x24(%esi),%eax
8010416d:	85 c0                	test   %eax,%eax
8010416f:	75 6d                	jne    801041de <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104171:	83 ec 08             	sub    $0x8,%esp
80104174:	68 20 2d 11 80       	push   $0x80112d20
80104179:	56                   	push   %esi
8010417a:	e8 c1 fe ff ff       	call   80104040 <sleep>
    havekids = 0;
8010417f:	83 c4 10             	add    $0x10,%esp
80104182:	eb aa                	jmp    8010412e <wait+0x2e>
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104188:	83 ec 0c             	sub    $0xc,%esp
8010418b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010418e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104191:	e8 ea e3 ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
80104196:	5a                   	pop    %edx
80104197:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010419a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041a1:	e8 0a 2e 00 00       	call   80106fb0 <freevm>
        release(&ptable.lock);
801041a6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
801041ad:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041b4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041bb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041bf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041c6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041cd:	e8 6e 05 00 00       	call   80104740 <release>
        return pid;
801041d2:	83 c4 10             	add    $0x10,%esp
}
801041d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d8:	89 f0                	mov    %esi,%eax
801041da:	5b                   	pop    %ebx
801041db:	5e                   	pop    %esi
801041dc:	5d                   	pop    %ebp
801041dd:	c3                   	ret    
      release(&ptable.lock);
801041de:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041e1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041e6:	68 20 2d 11 80       	push   $0x80112d20
801041eb:	e8 50 05 00 00       	call   80104740 <release>
      return -1;
801041f0:	83 c4 10             	add    $0x10,%esp
801041f3:	eb e0                	jmp    801041d5 <wait+0xd5>
801041f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	53                   	push   %ebx
80104208:	83 ec 10             	sub    $0x10,%esp
8010420b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010420e:	68 20 2d 11 80       	push   $0x80112d20
80104213:	e8 68 04 00 00       	call   80104680 <acquire>
80104218:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010421b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104220:	eb 10                	jmp    80104232 <wakeup+0x32>
80104222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104228:	83 c0 7c             	add    $0x7c,%eax
8010422b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104230:	74 1c                	je     8010424e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104232:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104236:	75 f0                	jne    80104228 <wakeup+0x28>
80104238:	3b 58 20             	cmp    0x20(%eax),%ebx
8010423b:	75 eb                	jne    80104228 <wakeup+0x28>
      p->state = RUNNABLE;
8010423d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104244:	83 c0 7c             	add    $0x7c,%eax
80104247:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
8010424c:	75 e4                	jne    80104232 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010424e:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104258:	c9                   	leave  
  release(&ptable.lock);
80104259:	e9 e2 04 00 00       	jmp    80104740 <release>
8010425e:	66 90                	xchg   %ax,%ax

80104260 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104260:	f3 0f 1e fb          	endbr32 
80104264:	55                   	push   %ebp
80104265:	89 e5                	mov    %esp,%ebp
80104267:	53                   	push   %ebx
80104268:	83 ec 10             	sub    $0x10,%esp
8010426b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010426e:	68 20 2d 11 80       	push   $0x80112d20
80104273:	e8 08 04 00 00       	call   80104680 <acquire>
80104278:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104280:	eb 10                	jmp    80104292 <kill+0x32>
80104282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104288:	83 c0 7c             	add    $0x7c,%eax
8010428b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104290:	74 36                	je     801042c8 <kill+0x68>
    if(p->pid == pid){
80104292:	39 58 10             	cmp    %ebx,0x10(%eax)
80104295:	75 f1                	jne    80104288 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104297:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010429b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042a2:	75 07                	jne    801042ab <kill+0x4b>
        p->state = RUNNABLE;
801042a4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042ab:	83 ec 0c             	sub    $0xc,%esp
801042ae:	68 20 2d 11 80       	push   $0x80112d20
801042b3:	e8 88 04 00 00       	call   80104740 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042bb:	83 c4 10             	add    $0x10,%esp
801042be:	31 c0                	xor    %eax,%eax
}
801042c0:	c9                   	leave  
801042c1:	c3                   	ret    
801042c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	68 20 2d 11 80       	push   $0x80112d20
801042d0:	e8 6b 04 00 00       	call   80104740 <release>
}
801042d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801042d8:	83 c4 10             	add    $0x10,%esp
801042db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042e0:	c9                   	leave  
801042e1:	c3                   	ret    
801042e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	57                   	push   %edi
801042f8:	56                   	push   %esi
801042f9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042fc:	53                   	push   %ebx
801042fd:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104302:	83 ec 3c             	sub    $0x3c,%esp
80104305:	eb 28                	jmp    8010432f <procdump+0x3f>
80104307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 5f 7c 10 80       	push   $0x80107c5f
80104318:	e8 93 c3 ff ff       	call   801006b0 <cprintf>
8010431d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104320:	83 c3 7c             	add    $0x7c,%ebx
80104323:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104329:	0f 84 81 00 00 00    	je     801043b0 <procdump+0xc0>
    if(p->state == UNUSED)
8010432f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104332:	85 c0                	test   %eax,%eax
80104334:	74 ea                	je     80104320 <procdump+0x30>
      state = "???";
80104336:	ba d2 78 10 80       	mov    $0x801078d2,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010433b:	83 f8 05             	cmp    $0x5,%eax
8010433e:	77 11                	ja     80104351 <procdump+0x61>
80104340:	8b 14 85 34 79 10 80 	mov    -0x7fef86cc(,%eax,4),%edx
      state = "???";
80104347:	b8 d2 78 10 80       	mov    $0x801078d2,%eax
8010434c:	85 d2                	test   %edx,%edx
8010434e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104351:	53                   	push   %ebx
80104352:	52                   	push   %edx
80104353:	ff 73 a4             	pushl  -0x5c(%ebx)
80104356:	68 d6 78 10 80       	push   $0x801078d6
8010435b:	e8 50 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104360:	83 c4 10             	add    $0x10,%esp
80104363:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104367:	75 a7                	jne    80104310 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104369:	83 ec 08             	sub    $0x8,%esp
8010436c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010436f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104372:	50                   	push   %eax
80104373:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104376:	8b 40 0c             	mov    0xc(%eax),%eax
80104379:	83 c0 08             	add    $0x8,%eax
8010437c:	50                   	push   %eax
8010437d:	e8 9e 01 00 00       	call   80104520 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104382:	83 c4 10             	add    $0x10,%esp
80104385:	8d 76 00             	lea    0x0(%esi),%esi
80104388:	8b 17                	mov    (%edi),%edx
8010438a:	85 d2                	test   %edx,%edx
8010438c:	74 82                	je     80104310 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010438e:	83 ec 08             	sub    $0x8,%esp
80104391:	83 c7 04             	add    $0x4,%edi
80104394:	52                   	push   %edx
80104395:	68 01 73 10 80       	push   $0x80107301
8010439a:	e8 11 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010439f:	83 c4 10             	add    $0x10,%esp
801043a2:	39 fe                	cmp    %edi,%esi
801043a4:	75 e2                	jne    80104388 <procdump+0x98>
801043a6:	e9 65 ff ff ff       	jmp    80104310 <procdump+0x20>
801043ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043af:	90                   	nop
  }
}
801043b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b3:	5b                   	pop    %ebx
801043b4:	5e                   	pop    %esi
801043b5:	5f                   	pop    %edi
801043b6:	5d                   	pop    %ebp
801043b7:	c3                   	ret    
801043b8:	66 90                	xchg   %ax,%ax
801043ba:	66 90                	xchg   %ax,%ax
801043bc:	66 90                	xchg   %ax,%ax
801043be:	66 90                	xchg   %ax,%ax

801043c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043c0:	f3 0f 1e fb          	endbr32 
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	53                   	push   %ebx
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ce:	68 4c 79 10 80       	push   $0x8010794c
801043d3:	8d 43 04             	lea    0x4(%ebx),%eax
801043d6:	50                   	push   %eax
801043d7:	e8 24 01 00 00       	call   80104500 <initlock>
  lk->name = name;
801043dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f5:	c9                   	leave  
801043f6:	c3                   	ret    
801043f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fe:	66 90                	xchg   %ax,%ax

80104400 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	56                   	push   %esi
80104408:	53                   	push   %ebx
80104409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010440c:	8d 73 04             	lea    0x4(%ebx),%esi
8010440f:	83 ec 0c             	sub    $0xc,%esp
80104412:	56                   	push   %esi
80104413:	e8 68 02 00 00       	call   80104680 <acquire>
  while (lk->locked) {
80104418:	8b 13                	mov    (%ebx),%edx
8010441a:	83 c4 10             	add    $0x10,%esp
8010441d:	85 d2                	test   %edx,%edx
8010441f:	74 1a                	je     8010443b <acquiresleep+0x3b>
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104428:	83 ec 08             	sub    $0x8,%esp
8010442b:	56                   	push   %esi
8010442c:	53                   	push   %ebx
8010442d:	e8 0e fc ff ff       	call   80104040 <sleep>
  while (lk->locked) {
80104432:	8b 03                	mov    (%ebx),%eax
80104434:	83 c4 10             	add    $0x10,%esp
80104437:	85 c0                	test   %eax,%eax
80104439:	75 ed                	jne    80104428 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010443b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104441:	e8 2a f6 ff ff       	call   80103a70 <myproc>
80104446:	8b 40 10             	mov    0x10(%eax),%eax
80104449:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010444c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010444f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104452:	5b                   	pop    %ebx
80104453:	5e                   	pop    %esi
80104454:	5d                   	pop    %ebp
  release(&lk->lk);
80104455:	e9 e6 02 00 00       	jmp    80104740 <release>
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104460 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104460:	f3 0f 1e fb          	endbr32 
80104464:	55                   	push   %ebp
80104465:	89 e5                	mov    %esp,%ebp
80104467:	56                   	push   %esi
80104468:	53                   	push   %ebx
80104469:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010446c:	8d 73 04             	lea    0x4(%ebx),%esi
8010446f:	83 ec 0c             	sub    $0xc,%esp
80104472:	56                   	push   %esi
80104473:	e8 08 02 00 00       	call   80104680 <acquire>
  lk->locked = 0;
80104478:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010447e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104485:	89 1c 24             	mov    %ebx,(%esp)
80104488:	e8 73 fd ff ff       	call   80104200 <wakeup>
  release(&lk->lk);
8010448d:	89 75 08             	mov    %esi,0x8(%ebp)
80104490:	83 c4 10             	add    $0x10,%esp
}
80104493:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104496:	5b                   	pop    %ebx
80104497:	5e                   	pop    %esi
80104498:	5d                   	pop    %ebp
  release(&lk->lk);
80104499:	e9 a2 02 00 00       	jmp    80104740 <release>
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044a0:	f3 0f 1e fb          	endbr32 
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	57                   	push   %edi
801044a8:	31 ff                	xor    %edi,%edi
801044aa:	56                   	push   %esi
801044ab:	53                   	push   %ebx
801044ac:	83 ec 18             	sub    $0x18,%esp
801044af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044b2:	8d 73 04             	lea    0x4(%ebx),%esi
801044b5:	56                   	push   %esi
801044b6:	e8 c5 01 00 00       	call   80104680 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044bb:	8b 03                	mov    (%ebx),%eax
801044bd:	83 c4 10             	add    $0x10,%esp
801044c0:	85 c0                	test   %eax,%eax
801044c2:	75 1c                	jne    801044e0 <holdingsleep+0x40>
  release(&lk->lk);
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	56                   	push   %esi
801044c8:	e8 73 02 00 00       	call   80104740 <release>
  return r;
}
801044cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044d0:	89 f8                	mov    %edi,%eax
801044d2:	5b                   	pop    %ebx
801044d3:	5e                   	pop    %esi
801044d4:	5f                   	pop    %edi
801044d5:	5d                   	pop    %ebp
801044d6:	c3                   	ret    
801044d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044de:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801044e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044e3:	e8 88 f5 ff ff       	call   80103a70 <myproc>
801044e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801044eb:	0f 94 c0             	sete   %al
801044ee:	0f b6 c0             	movzbl %al,%eax
801044f1:	89 c7                	mov    %eax,%edi
801044f3:	eb cf                	jmp    801044c4 <holdingsleep+0x24>
801044f5:	66 90                	xchg   %ax,%ax
801044f7:	66 90                	xchg   %ax,%ax
801044f9:	66 90                	xchg   %ax,%ax
801044fb:	66 90                	xchg   %ax,%ax
801044fd:	66 90                	xchg   %ax,%ax
801044ff:	90                   	nop

80104500 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104500:	f3 0f 1e fb          	endbr32 
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010450a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010450d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104513:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104516:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010451d:	5d                   	pop    %ebp
8010451e:	c3                   	ret    
8010451f:	90                   	nop

80104520 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104525:	31 d2                	xor    %edx,%edx
{
80104527:	89 e5                	mov    %esp,%ebp
80104529:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010452a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010452d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104530:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104537:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104538:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010453e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104544:	77 1a                	ja     80104560 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104546:	8b 58 04             	mov    0x4(%eax),%ebx
80104549:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010454c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010454f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104551:	83 fa 0a             	cmp    $0xa,%edx
80104554:	75 e2                	jne    80104538 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104556:	5b                   	pop    %ebx
80104557:	5d                   	pop    %ebp
80104558:	c3                   	ret    
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104560:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104563:	8d 51 28             	lea    0x28(%ecx),%edx
80104566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104576:	83 c0 04             	add    $0x4,%eax
80104579:	39 d0                	cmp    %edx,%eax
8010457b:	75 f3                	jne    80104570 <getcallerpcs+0x50>
}
8010457d:	5b                   	pop    %ebx
8010457e:	5d                   	pop    %ebp
8010457f:	c3                   	ret    

80104580 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	53                   	push   %ebx
80104588:	83 ec 04             	sub    $0x4,%esp
8010458b:	9c                   	pushf  
8010458c:	5b                   	pop    %ebx
  asm volatile("cli");
8010458d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010458e:	e8 4d f4 ff ff       	call   801039e0 <mycpu>
80104593:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104599:	85 c0                	test   %eax,%eax
8010459b:	74 13                	je     801045b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010459d:	e8 3e f4 ff ff       	call   801039e0 <mycpu>
801045a2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045a9:	83 c4 04             	add    $0x4,%esp
801045ac:	5b                   	pop    %ebx
801045ad:	5d                   	pop    %ebp
801045ae:	c3                   	ret    
801045af:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801045b0:	e8 2b f4 ff ff       	call   801039e0 <mycpu>
801045b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045c1:	eb da                	jmp    8010459d <pushcli+0x1d>
801045c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <popcli>:

void
popcli(void)
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045da:	9c                   	pushf  
801045db:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045dc:	f6 c4 02             	test   $0x2,%ah
801045df:	75 31                	jne    80104612 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045e1:	e8 fa f3 ff ff       	call   801039e0 <mycpu>
801045e6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045ed:	78 30                	js     8010461f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045ef:	e8 ec f3 ff ff       	call   801039e0 <mycpu>
801045f4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045fa:	85 d2                	test   %edx,%edx
801045fc:	74 02                	je     80104600 <popcli+0x30>
    sti();
}
801045fe:	c9                   	leave  
801045ff:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104600:	e8 db f3 ff ff       	call   801039e0 <mycpu>
80104605:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010460b:	85 c0                	test   %eax,%eax
8010460d:	74 ef                	je     801045fe <popcli+0x2e>
  asm volatile("sti");
8010460f:	fb                   	sti    
}
80104610:	c9                   	leave  
80104611:	c3                   	ret    
    panic("popcli - interruptible");
80104612:	83 ec 0c             	sub    $0xc,%esp
80104615:	68 57 79 10 80       	push   $0x80107957
8010461a:	e8 71 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010461f:	83 ec 0c             	sub    $0xc,%esp
80104622:	68 6e 79 10 80       	push   $0x8010796e
80104627:	e8 64 bd ff ff       	call   80100390 <panic>
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <holding>:
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	56                   	push   %esi
80104638:	53                   	push   %ebx
80104639:	8b 75 08             	mov    0x8(%ebp),%esi
8010463c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010463e:	e8 3d ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104643:	8b 06                	mov    (%esi),%eax
80104645:	85 c0                	test   %eax,%eax
80104647:	75 0f                	jne    80104658 <holding+0x28>
  popcli();
80104649:	e8 82 ff ff ff       	call   801045d0 <popcli>
}
8010464e:	89 d8                	mov    %ebx,%eax
80104650:	5b                   	pop    %ebx
80104651:	5e                   	pop    %esi
80104652:	5d                   	pop    %ebp
80104653:	c3                   	ret    
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104658:	8b 5e 08             	mov    0x8(%esi),%ebx
8010465b:	e8 80 f3 ff ff       	call   801039e0 <mycpu>
80104660:	39 c3                	cmp    %eax,%ebx
80104662:	0f 94 c3             	sete   %bl
  popcli();
80104665:	e8 66 ff ff ff       	call   801045d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010466a:	0f b6 db             	movzbl %bl,%ebx
}
8010466d:	89 d8                	mov    %ebx,%eax
8010466f:	5b                   	pop    %ebx
80104670:	5e                   	pop    %esi
80104671:	5d                   	pop    %ebp
80104672:	c3                   	ret    
80104673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <acquire>:
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	56                   	push   %esi
80104688:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104689:	e8 f2 fe ff ff       	call   80104580 <pushcli>
  if(holding(lk))
8010468e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104691:	83 ec 0c             	sub    $0xc,%esp
80104694:	53                   	push   %ebx
80104695:	e8 96 ff ff ff       	call   80104630 <holding>
8010469a:	83 c4 10             	add    $0x10,%esp
8010469d:	85 c0                	test   %eax,%eax
8010469f:	0f 85 7f 00 00 00    	jne    80104724 <acquire+0xa4>
801046a5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801046a7:	ba 01 00 00 00       	mov    $0x1,%edx
801046ac:	eb 05                	jmp    801046b3 <acquire+0x33>
801046ae:	66 90                	xchg   %ax,%ax
801046b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046b3:	89 d0                	mov    %edx,%eax
801046b5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801046b8:	85 c0                	test   %eax,%eax
801046ba:	75 f4                	jne    801046b0 <acquire+0x30>
  __sync_synchronize();
801046bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046c4:	e8 17 f3 ff ff       	call   801039e0 <mycpu>
801046c9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801046cc:	89 e8                	mov    %ebp,%eax
801046ce:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801046d6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801046dc:	77 22                	ja     80104700 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801046de:	8b 50 04             	mov    0x4(%eax),%edx
801046e1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801046e5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801046e8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046ea:	83 fe 0a             	cmp    $0xa,%esi
801046ed:	75 e1                	jne    801046d0 <acquire+0x50>
}
801046ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046f2:	5b                   	pop    %ebx
801046f3:	5e                   	pop    %esi
801046f4:	5d                   	pop    %ebp
801046f5:	c3                   	ret    
801046f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104700:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104704:	83 c3 34             	add    $0x34,%ebx
80104707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104716:	83 c0 04             	add    $0x4,%eax
80104719:	39 d8                	cmp    %ebx,%eax
8010471b:	75 f3                	jne    80104710 <acquire+0x90>
}
8010471d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104720:	5b                   	pop    %ebx
80104721:	5e                   	pop    %esi
80104722:	5d                   	pop    %ebp
80104723:	c3                   	ret    
    panic("acquire");
80104724:	83 ec 0c             	sub    $0xc,%esp
80104727:	68 75 79 10 80       	push   $0x80107975
8010472c:	e8 5f bc ff ff       	call   80100390 <panic>
80104731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop

80104740 <release>:
{
80104740:	f3 0f 1e fb          	endbr32 
80104744:	55                   	push   %ebp
80104745:	89 e5                	mov    %esp,%ebp
80104747:	53                   	push   %ebx
80104748:	83 ec 10             	sub    $0x10,%esp
8010474b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010474e:	53                   	push   %ebx
8010474f:	e8 dc fe ff ff       	call   80104630 <holding>
80104754:	83 c4 10             	add    $0x10,%esp
80104757:	85 c0                	test   %eax,%eax
80104759:	74 22                	je     8010477d <release+0x3d>
  lk->pcs[0] = 0;
8010475b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104762:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104769:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010476e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104777:	c9                   	leave  
  popcli();
80104778:	e9 53 fe ff ff       	jmp    801045d0 <popcli>
    panic("release");
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	68 7d 79 10 80       	push   $0x8010797d
80104785:	e8 06 bc ff ff       	call   80100390 <panic>
8010478a:	66 90                	xchg   %ax,%ax
8010478c:	66 90                	xchg   %ax,%ax
8010478e:	66 90                	xchg   %ax,%ax

80104790 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	57                   	push   %edi
80104798:	8b 55 08             	mov    0x8(%ebp),%edx
8010479b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010479e:	53                   	push   %ebx
8010479f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047a2:	89 d7                	mov    %edx,%edi
801047a4:	09 cf                	or     %ecx,%edi
801047a6:	83 e7 03             	and    $0x3,%edi
801047a9:	75 25                	jne    801047d0 <memset+0x40>
    c &= 0xFF;
801047ab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ae:	c1 e0 18             	shl    $0x18,%eax
801047b1:	89 fb                	mov    %edi,%ebx
801047b3:	c1 e9 02             	shr    $0x2,%ecx
801047b6:	c1 e3 10             	shl    $0x10,%ebx
801047b9:	09 d8                	or     %ebx,%eax
801047bb:	09 f8                	or     %edi,%eax
801047bd:	c1 e7 08             	shl    $0x8,%edi
801047c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047c2:	89 d7                	mov    %edx,%edi
801047c4:	fc                   	cld    
801047c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047c7:	5b                   	pop    %ebx
801047c8:	89 d0                	mov    %edx,%eax
801047ca:	5f                   	pop    %edi
801047cb:	5d                   	pop    %ebp
801047cc:	c3                   	ret    
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801047d0:	89 d7                	mov    %edx,%edi
801047d2:	fc                   	cld    
801047d3:	f3 aa                	rep stos %al,%es:(%edi)
801047d5:	5b                   	pop    %ebx
801047d6:	89 d0                	mov    %edx,%eax
801047d8:	5f                   	pop    %edi
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret    
801047db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047df:	90                   	nop

801047e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	56                   	push   %esi
801047e8:	8b 75 10             	mov    0x10(%ebp),%esi
801047eb:	8b 55 08             	mov    0x8(%ebp),%edx
801047ee:	53                   	push   %ebx
801047ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047f2:	85 f6                	test   %esi,%esi
801047f4:	74 2a                	je     80104820 <memcmp+0x40>
801047f6:	01 c6                	add    %eax,%esi
801047f8:	eb 10                	jmp    8010480a <memcmp+0x2a>
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104800:	83 c0 01             	add    $0x1,%eax
80104803:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104806:	39 f0                	cmp    %esi,%eax
80104808:	74 16                	je     80104820 <memcmp+0x40>
    if(*s1 != *s2)
8010480a:	0f b6 0a             	movzbl (%edx),%ecx
8010480d:	0f b6 18             	movzbl (%eax),%ebx
80104810:	38 d9                	cmp    %bl,%cl
80104812:	74 ec                	je     80104800 <memcmp+0x20>
      return *s1 - *s2;
80104814:	0f b6 c1             	movzbl %cl,%eax
80104817:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104819:	5b                   	pop    %ebx
8010481a:	5e                   	pop    %esi
8010481b:	5d                   	pop    %ebp
8010481c:	c3                   	ret    
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
80104820:	5b                   	pop    %ebx
  return 0;
80104821:	31 c0                	xor    %eax,%eax
}
80104823:	5e                   	pop    %esi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
80104826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	8b 55 08             	mov    0x8(%ebp),%edx
8010483b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010483e:	56                   	push   %esi
8010483f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104842:	39 d6                	cmp    %edx,%esi
80104844:	73 2a                	jae    80104870 <memmove+0x40>
80104846:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104849:	39 fa                	cmp    %edi,%edx
8010484b:	73 23                	jae    80104870 <memmove+0x40>
8010484d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104850:	85 c9                	test   %ecx,%ecx
80104852:	74 13                	je     80104867 <memmove+0x37>
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104858:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010485c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010485f:	83 e8 01             	sub    $0x1,%eax
80104862:	83 f8 ff             	cmp    $0xffffffff,%eax
80104865:	75 f1                	jne    80104858 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104867:	5e                   	pop    %esi
80104868:	89 d0                	mov    %edx,%eax
8010486a:	5f                   	pop    %edi
8010486b:	5d                   	pop    %ebp
8010486c:	c3                   	ret    
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104870:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104873:	89 d7                	mov    %edx,%edi
80104875:	85 c9                	test   %ecx,%ecx
80104877:	74 ee                	je     80104867 <memmove+0x37>
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104880:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104881:	39 f0                	cmp    %esi,%eax
80104883:	75 fb                	jne    80104880 <memmove+0x50>
}
80104885:	5e                   	pop    %esi
80104886:	89 d0                	mov    %edx,%eax
80104888:	5f                   	pop    %edi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104890:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104894:	eb 9a                	jmp    80104830 <memmove>
80104896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489d:	8d 76 00             	lea    0x0(%esi),%esi

801048a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	8b 75 10             	mov    0x10(%ebp),%esi
801048ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ae:	53                   	push   %ebx
801048af:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801048b2:	85 f6                	test   %esi,%esi
801048b4:	74 32                	je     801048e8 <strncmp+0x48>
801048b6:	01 c6                	add    %eax,%esi
801048b8:	eb 14                	jmp    801048ce <strncmp+0x2e>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c0:	38 da                	cmp    %bl,%dl
801048c2:	75 14                	jne    801048d8 <strncmp+0x38>
    n--, p++, q++;
801048c4:	83 c0 01             	add    $0x1,%eax
801048c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048ca:	39 f0                	cmp    %esi,%eax
801048cc:	74 1a                	je     801048e8 <strncmp+0x48>
801048ce:	0f b6 11             	movzbl (%ecx),%edx
801048d1:	0f b6 18             	movzbl (%eax),%ebx
801048d4:	84 d2                	test   %dl,%dl
801048d6:	75 e8                	jne    801048c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048d8:	0f b6 c2             	movzbl %dl,%eax
801048db:	29 d8                	sub    %ebx,%eax
}
801048dd:	5b                   	pop    %ebx
801048de:	5e                   	pop    %esi
801048df:	5d                   	pop    %ebp
801048e0:	c3                   	ret    
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e8:	5b                   	pop    %ebx
    return 0;
801048e9:	31 c0                	xor    %eax,%eax
}
801048eb:	5e                   	pop    %esi
801048ec:	5d                   	pop    %ebp
801048ed:	c3                   	ret    
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	57                   	push   %edi
801048f8:	56                   	push   %esi
801048f9:	8b 75 08             	mov    0x8(%ebp),%esi
801048fc:	53                   	push   %ebx
801048fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104900:	89 f2                	mov    %esi,%edx
80104902:	eb 1b                	jmp    8010491f <strncpy+0x2f>
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104908:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010490c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010490f:	83 c2 01             	add    $0x1,%edx
80104912:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104916:	89 f9                	mov    %edi,%ecx
80104918:	88 4a ff             	mov    %cl,-0x1(%edx)
8010491b:	84 c9                	test   %cl,%cl
8010491d:	74 09                	je     80104928 <strncpy+0x38>
8010491f:	89 c3                	mov    %eax,%ebx
80104921:	83 e8 01             	sub    $0x1,%eax
80104924:	85 db                	test   %ebx,%ebx
80104926:	7f e0                	jg     80104908 <strncpy+0x18>
    ;
  while(n-- > 0)
80104928:	89 d1                	mov    %edx,%ecx
8010492a:	85 c0                	test   %eax,%eax
8010492c:	7e 15                	jle    80104943 <strncpy+0x53>
8010492e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104930:	83 c1 01             	add    $0x1,%ecx
80104933:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104937:	89 c8                	mov    %ecx,%eax
80104939:	f7 d0                	not    %eax
8010493b:	01 d0                	add    %edx,%eax
8010493d:	01 d8                	add    %ebx,%eax
8010493f:	85 c0                	test   %eax,%eax
80104941:	7f ed                	jg     80104930 <strncpy+0x40>
  return os;
}
80104943:	5b                   	pop    %ebx
80104944:	89 f0                	mov    %esi,%eax
80104946:	5e                   	pop    %esi
80104947:	5f                   	pop    %edi
80104948:	5d                   	pop    %ebp
80104949:	c3                   	ret    
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	56                   	push   %esi
80104958:	8b 55 10             	mov    0x10(%ebp),%edx
8010495b:	8b 75 08             	mov    0x8(%ebp),%esi
8010495e:	53                   	push   %ebx
8010495f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104962:	85 d2                	test   %edx,%edx
80104964:	7e 21                	jle    80104987 <safestrcpy+0x37>
80104966:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010496a:	89 f2                	mov    %esi,%edx
8010496c:	eb 12                	jmp    80104980 <safestrcpy+0x30>
8010496e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104970:	0f b6 08             	movzbl (%eax),%ecx
80104973:	83 c0 01             	add    $0x1,%eax
80104976:	83 c2 01             	add    $0x1,%edx
80104979:	88 4a ff             	mov    %cl,-0x1(%edx)
8010497c:	84 c9                	test   %cl,%cl
8010497e:	74 04                	je     80104984 <safestrcpy+0x34>
80104980:	39 d8                	cmp    %ebx,%eax
80104982:	75 ec                	jne    80104970 <safestrcpy+0x20>
    ;
  *s = 0;
80104984:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104987:	89 f0                	mov    %esi,%eax
80104989:	5b                   	pop    %ebx
8010498a:	5e                   	pop    %esi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    
8010498d:	8d 76 00             	lea    0x0(%esi),%esi

80104990 <strlen>:

int
strlen(const char *s)
{
80104990:	f3 0f 1e fb          	endbr32 
80104994:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104995:	31 c0                	xor    %eax,%eax
{
80104997:	89 e5                	mov    %esp,%ebp
80104999:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010499c:	80 3a 00             	cmpb   $0x0,(%edx)
8010499f:	74 10                	je     801049b1 <strlen+0x21>
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a8:	83 c0 01             	add    $0x1,%eax
801049ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049af:	75 f7                	jne    801049a8 <strlen+0x18>
    ;
  return n;
}
801049b1:	5d                   	pop    %ebp
801049b2:	c3                   	ret    

801049b3 <swtch>:
801049b3:	8b 44 24 04          	mov    0x4(%esp),%eax
801049b7:	8b 54 24 08          	mov    0x8(%esp),%edx
801049bb:	55                   	push   %ebp
801049bc:	53                   	push   %ebx
801049bd:	56                   	push   %esi
801049be:	57                   	push   %edi
801049bf:	89 20                	mov    %esp,(%eax)
801049c1:	89 d4                	mov    %edx,%esp
801049c3:	5f                   	pop    %edi
801049c4:	5e                   	pop    %esi
801049c5:	5b                   	pop    %ebx
801049c6:	5d                   	pop    %ebp
801049c7:	c3                   	ret    
801049c8:	66 90                	xchg   %ax,%ax
801049ca:	66 90                	xchg   %ax,%ax
801049cc:	66 90                	xchg   %ax,%ax
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049d0:	f3 0f 1e fb          	endbr32 
801049d4:	55                   	push   %ebp
801049d5:	89 e5                	mov    %esp,%ebp
801049d7:	53                   	push   %ebx
801049d8:	83 ec 04             	sub    $0x4,%esp
801049db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049de:	e8 8d f0 ff ff       	call   80103a70 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049e3:	8b 00                	mov    (%eax),%eax
801049e5:	39 d8                	cmp    %ebx,%eax
801049e7:	76 17                	jbe    80104a00 <fetchint+0x30>
801049e9:	8d 53 04             	lea    0x4(%ebx),%edx
801049ec:	39 d0                	cmp    %edx,%eax
801049ee:	72 10                	jb     80104a00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801049f3:	8b 13                	mov    (%ebx),%edx
801049f5:	89 10                	mov    %edx,(%eax)
  return 0;
801049f7:	31 c0                	xor    %eax,%eax
}
801049f9:	83 c4 04             	add    $0x4,%esp
801049fc:	5b                   	pop    %ebx
801049fd:	5d                   	pop    %ebp
801049fe:	c3                   	ret    
801049ff:	90                   	nop
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a05:	eb f2                	jmp    801049f9 <fetchint+0x29>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	53                   	push   %ebx
80104a18:	83 ec 04             	sub    $0x4,%esp
80104a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a1e:	e8 4d f0 ff ff       	call   80103a70 <myproc>

  if(addr >= curproc->sz)
80104a23:	39 18                	cmp    %ebx,(%eax)
80104a25:	76 31                	jbe    80104a58 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104a27:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a2a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a2c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a2e:	39 d3                	cmp    %edx,%ebx
80104a30:	73 26                	jae    80104a58 <fetchstr+0x48>
80104a32:	89 d8                	mov    %ebx,%eax
80104a34:	eb 11                	jmp    80104a47 <fetchstr+0x37>
80104a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	83 c0 01             	add    $0x1,%eax
80104a43:	39 c2                	cmp    %eax,%edx
80104a45:	76 11                	jbe    80104a58 <fetchstr+0x48>
    if(*s == 0)
80104a47:	80 38 00             	cmpb   $0x0,(%eax)
80104a4a:	75 f4                	jne    80104a40 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104a4c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104a4f:	29 d8                	sub    %ebx,%eax
}
80104a51:	5b                   	pop    %ebx
80104a52:	5d                   	pop    %ebp
80104a53:	c3                   	ret    
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a58:	83 c4 04             	add    $0x4,%esp
    return -1;
80104a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a60:	5b                   	pop    %ebx
80104a61:	5d                   	pop    %ebp
80104a62:	c3                   	ret    
80104a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	56                   	push   %esi
80104a78:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a79:	e8 f2 ef ff ff       	call   80103a70 <myproc>
80104a7e:	8b 55 08             	mov    0x8(%ebp),%edx
80104a81:	8b 40 18             	mov    0x18(%eax),%eax
80104a84:	8b 40 44             	mov    0x44(%eax),%eax
80104a87:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a8a:	e8 e1 ef ff ff       	call   80103a70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a8f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a92:	8b 00                	mov    (%eax),%eax
80104a94:	39 c6                	cmp    %eax,%esi
80104a96:	73 18                	jae    80104ab0 <argint+0x40>
80104a98:	8d 53 08             	lea    0x8(%ebx),%edx
80104a9b:	39 d0                	cmp    %edx,%eax
80104a9d:	72 11                	jb     80104ab0 <argint+0x40>
  *ip = *(int*)(addr);
80104a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aa2:	8b 53 04             	mov    0x4(%ebx),%edx
80104aa5:	89 10                	mov    %edx,(%eax)
  return 0;
80104aa7:	31 c0                	xor    %eax,%eax
}
80104aa9:	5b                   	pop    %ebx
80104aaa:	5e                   	pop    %esi
80104aab:	5d                   	pop    %ebp
80104aac:	c3                   	ret    
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab5:	eb f2                	jmp    80104aa9 <argint+0x39>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	56                   	push   %esi
80104ac8:	53                   	push   %ebx
80104ac9:	83 ec 10             	sub    $0x10,%esp
80104acc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104acf:	e8 9c ef ff ff       	call   80103a70 <myproc>
 
  if(argint(n, &i) < 0)
80104ad4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104ad7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104ad9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104adc:	50                   	push   %eax
80104add:	ff 75 08             	pushl  0x8(%ebp)
80104ae0:	e8 8b ff ff ff       	call   80104a70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ae5:	83 c4 10             	add    $0x10,%esp
80104ae8:	85 c0                	test   %eax,%eax
80104aea:	78 24                	js     80104b10 <argptr+0x50>
80104aec:	85 db                	test   %ebx,%ebx
80104aee:	78 20                	js     80104b10 <argptr+0x50>
80104af0:	8b 16                	mov    (%esi),%edx
80104af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af5:	39 c2                	cmp    %eax,%edx
80104af7:	76 17                	jbe    80104b10 <argptr+0x50>
80104af9:	01 c3                	add    %eax,%ebx
80104afb:	39 da                	cmp    %ebx,%edx
80104afd:	72 11                	jb     80104b10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104aff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b02:	89 02                	mov    %eax,(%edx)
  return 0;
80104b04:	31 c0                	xor    %eax,%eax
}
80104b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b09:	5b                   	pop    %ebx
80104b0a:	5e                   	pop    %esi
80104b0b:	5d                   	pop    %ebp
80104b0c:	c3                   	ret    
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb ef                	jmp    80104b06 <argptr+0x46>
80104b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b2d:	50                   	push   %eax
80104b2e:	ff 75 08             	pushl  0x8(%ebp)
80104b31:	e8 3a ff ff ff       	call   80104a70 <argint>
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	85 c0                	test   %eax,%eax
80104b3b:	78 13                	js     80104b50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b3d:	83 ec 08             	sub    $0x8,%esp
80104b40:	ff 75 0c             	pushl  0xc(%ebp)
80104b43:	ff 75 f4             	pushl  -0xc(%ebp)
80104b46:	e8 c5 fe ff ff       	call   80104a10 <fetchstr>
80104b4b:	83 c4 10             	add    $0x10,%esp
}
80104b4e:	c9                   	leave  
80104b4f:	c3                   	ret    
80104b50:	c9                   	leave  
    return -1;
80104b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b56:	c3                   	ret    
80104b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <syscall>:
[SYS_swapwrite] sys_swapwrite,
};

void
syscall(void)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	53                   	push   %ebx
80104b68:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b6b:	e8 00 ef ff ff       	call   80103a70 <myproc>
80104b70:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b72:	8b 40 18             	mov    0x18(%eax),%eax
80104b75:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b78:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b7b:	83 fa 16             	cmp    $0x16,%edx
80104b7e:	77 20                	ja     80104ba0 <syscall+0x40>
80104b80:	8b 14 85 c0 79 10 80 	mov    -0x7fef8640(,%eax,4),%edx
80104b87:	85 d2                	test   %edx,%edx
80104b89:	74 15                	je     80104ba0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104b8b:	ff d2                	call   *%edx
80104b8d:	89 c2                	mov    %eax,%edx
80104b8f:	8b 43 18             	mov    0x18(%ebx),%eax
80104b92:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b98:	c9                   	leave  
80104b99:	c3                   	ret    
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ba0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ba1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ba4:	50                   	push   %eax
80104ba5:	ff 73 10             	pushl  0x10(%ebx)
80104ba8:	68 85 79 10 80       	push   $0x80107985
80104bad:	e8 fe ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104bb2:	8b 43 18             	mov    0x18(%ebx),%eax
80104bb5:	83 c4 10             	add    $0x10,%esp
80104bb8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc2:	c9                   	leave  
80104bc3:	c3                   	ret    
80104bc4:	66 90                	xchg   %ax,%ax
80104bc6:	66 90                	xchg   %ax,%ax
80104bc8:	66 90                	xchg   %ax,%ax
80104bca:	66 90                	xchg   %ax,%ax
80104bcc:	66 90                	xchg   %ax,%ax
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bd5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104bd8:	53                   	push   %ebx
80104bd9:	83 ec 44             	sub    $0x44,%esp
80104bdc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104bdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104be2:	57                   	push   %edi
80104be3:	50                   	push   %eax
{
80104be4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104be7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bea:	e8 61 d4 ff ff       	call   80102050 <nameiparent>
80104bef:	83 c4 10             	add    $0x10,%esp
80104bf2:	85 c0                	test   %eax,%eax
80104bf4:	0f 84 46 01 00 00    	je     80104d40 <create+0x170>
    return 0;
  ilock(dp);
80104bfa:	83 ec 0c             	sub    $0xc,%esp
80104bfd:	89 c3                	mov    %eax,%ebx
80104bff:	50                   	push   %eax
80104c00:	e8 5b cb ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104c05:	83 c4 0c             	add    $0xc,%esp
80104c08:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c0b:	50                   	push   %eax
80104c0c:	57                   	push   %edi
80104c0d:	53                   	push   %ebx
80104c0e:	e8 9d d0 ff ff       	call   80101cb0 <dirlookup>
80104c13:	83 c4 10             	add    $0x10,%esp
80104c16:	89 c6                	mov    %eax,%esi
80104c18:	85 c0                	test   %eax,%eax
80104c1a:	74 54                	je     80104c70 <create+0xa0>
    iunlockput(dp);
80104c1c:	83 ec 0c             	sub    $0xc,%esp
80104c1f:	53                   	push   %ebx
80104c20:	e8 db cd ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104c25:	89 34 24             	mov    %esi,(%esp)
80104c28:	e8 33 cb ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104c35:	75 19                	jne    80104c50 <create+0x80>
80104c37:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c3c:	75 12                	jne    80104c50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c41:	89 f0                	mov    %esi,%eax
80104c43:	5b                   	pop    %ebx
80104c44:	5e                   	pop    %esi
80104c45:	5f                   	pop    %edi
80104c46:	5d                   	pop    %ebp
80104c47:	c3                   	ret    
80104c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop
    iunlockput(ip);
80104c50:	83 ec 0c             	sub    $0xc,%esp
80104c53:	56                   	push   %esi
    return 0;
80104c54:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c56:	e8 a5 cd ff ff       	call   80101a00 <iunlockput>
    return 0;
80104c5b:	83 c4 10             	add    $0x10,%esp
}
80104c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c61:	89 f0                	mov    %esi,%eax
80104c63:	5b                   	pop    %ebx
80104c64:	5e                   	pop    %esi
80104c65:	5f                   	pop    %edi
80104c66:	5d                   	pop    %ebp
80104c67:	c3                   	ret    
80104c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104c70:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104c74:	83 ec 08             	sub    $0x8,%esp
80104c77:	50                   	push   %eax
80104c78:	ff 33                	pushl  (%ebx)
80104c7a:	e8 61 c9 ff ff       	call   801015e0 <ialloc>
80104c7f:	83 c4 10             	add    $0x10,%esp
80104c82:	89 c6                	mov    %eax,%esi
80104c84:	85 c0                	test   %eax,%eax
80104c86:	0f 84 cd 00 00 00    	je     80104d59 <create+0x189>
  ilock(ip);
80104c8c:	83 ec 0c             	sub    $0xc,%esp
80104c8f:	50                   	push   %eax
80104c90:	e8 cb ca ff ff       	call   80101760 <ilock>
  ip->major = major;
80104c95:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c9d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ca1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ca5:	b8 01 00 00 00       	mov    $0x1,%eax
80104caa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cae:	89 34 24             	mov    %esi,(%esp)
80104cb1:	e8 ea c9 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cb6:	83 c4 10             	add    $0x10,%esp
80104cb9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104cbe:	74 30                	je     80104cf0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104cc0:	83 ec 04             	sub    $0x4,%esp
80104cc3:	ff 76 04             	pushl  0x4(%esi)
80104cc6:	57                   	push   %edi
80104cc7:	53                   	push   %ebx
80104cc8:	e8 a3 d2 ff ff       	call   80101f70 <dirlink>
80104ccd:	83 c4 10             	add    $0x10,%esp
80104cd0:	85 c0                	test   %eax,%eax
80104cd2:	78 78                	js     80104d4c <create+0x17c>
  iunlockput(dp);
80104cd4:	83 ec 0c             	sub    $0xc,%esp
80104cd7:	53                   	push   %ebx
80104cd8:	e8 23 cd ff ff       	call   80101a00 <iunlockput>
  return ip;
80104cdd:	83 c4 10             	add    $0x10,%esp
}
80104ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ce3:	89 f0                	mov    %esi,%eax
80104ce5:	5b                   	pop    %ebx
80104ce6:	5e                   	pop    %esi
80104ce7:	5f                   	pop    %edi
80104ce8:	5d                   	pop    %ebp
80104ce9:	c3                   	ret    
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104cf0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104cf3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104cf8:	53                   	push   %ebx
80104cf9:	e8 a2 c9 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cfe:	83 c4 0c             	add    $0xc,%esp
80104d01:	ff 76 04             	pushl  0x4(%esi)
80104d04:	68 3c 7a 10 80       	push   $0x80107a3c
80104d09:	56                   	push   %esi
80104d0a:	e8 61 d2 ff ff       	call   80101f70 <dirlink>
80104d0f:	83 c4 10             	add    $0x10,%esp
80104d12:	85 c0                	test   %eax,%eax
80104d14:	78 18                	js     80104d2e <create+0x15e>
80104d16:	83 ec 04             	sub    $0x4,%esp
80104d19:	ff 73 04             	pushl  0x4(%ebx)
80104d1c:	68 3b 7a 10 80       	push   $0x80107a3b
80104d21:	56                   	push   %esi
80104d22:	e8 49 d2 ff ff       	call   80101f70 <dirlink>
80104d27:	83 c4 10             	add    $0x10,%esp
80104d2a:	85 c0                	test   %eax,%eax
80104d2c:	79 92                	jns    80104cc0 <create+0xf0>
      panic("create dots");
80104d2e:	83 ec 0c             	sub    $0xc,%esp
80104d31:	68 2f 7a 10 80       	push   $0x80107a2f
80104d36:	e8 55 b6 ff ff       	call   80100390 <panic>
80104d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop
}
80104d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d43:	31 f6                	xor    %esi,%esi
}
80104d45:	5b                   	pop    %ebx
80104d46:	89 f0                	mov    %esi,%eax
80104d48:	5e                   	pop    %esi
80104d49:	5f                   	pop    %edi
80104d4a:	5d                   	pop    %ebp
80104d4b:	c3                   	ret    
    panic("create: dirlink");
80104d4c:	83 ec 0c             	sub    $0xc,%esp
80104d4f:	68 3e 7a 10 80       	push   $0x80107a3e
80104d54:	e8 37 b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d59:	83 ec 0c             	sub    $0xc,%esp
80104d5c:	68 20 7a 10 80       	push   $0x80107a20
80104d61:	e8 2a b6 ff ff       	call   80100390 <panic>
80104d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

80104d70 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	89 d6                	mov    %edx,%esi
80104d76:	53                   	push   %ebx
80104d77:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d79:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d7f:	50                   	push   %eax
80104d80:	6a 00                	push   $0x0
80104d82:	e8 e9 fc ff ff       	call   80104a70 <argint>
80104d87:	83 c4 10             	add    $0x10,%esp
80104d8a:	85 c0                	test   %eax,%eax
80104d8c:	78 2a                	js     80104db8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d92:	77 24                	ja     80104db8 <argfd.constprop.0+0x48>
80104d94:	e8 d7 ec ff ff       	call   80103a70 <myproc>
80104d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d9c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104da0:	85 c0                	test   %eax,%eax
80104da2:	74 14                	je     80104db8 <argfd.constprop.0+0x48>
  if(pfd)
80104da4:	85 db                	test   %ebx,%ebx
80104da6:	74 02                	je     80104daa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104da8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104daa:	89 06                	mov    %eax,(%esi)
  return 0;
80104dac:	31 c0                	xor    %eax,%eax
}
80104dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db1:	5b                   	pop    %ebx
80104db2:	5e                   	pop    %esi
80104db3:	5d                   	pop    %ebp
80104db4:	c3                   	ret    
80104db5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dbd:	eb ef                	jmp    80104dae <argfd.constprop.0+0x3e>
80104dbf:	90                   	nop

80104dc0 <sys_dup>:
{
80104dc0:	f3 0f 1e fb          	endbr32 
80104dc4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104dc5:	31 c0                	xor    %eax,%eax
{
80104dc7:	89 e5                	mov    %esp,%ebp
80104dc9:	56                   	push   %esi
80104dca:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104dcb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dce:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104dd1:	e8 9a ff ff ff       	call   80104d70 <argfd.constprop.0>
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	78 1e                	js     80104df8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104dda:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ddd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104ddf:	e8 8c ec ff ff       	call   80103a70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104de8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104dec:	85 d2                	test   %edx,%edx
80104dee:	74 20                	je     80104e10 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104df0:	83 c3 01             	add    $0x1,%ebx
80104df3:	83 fb 10             	cmp    $0x10,%ebx
80104df6:	75 f0                	jne    80104de8 <sys_dup+0x28>
}
80104df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104dfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e00:	89 d8                	mov    %ebx,%eax
80104e02:	5b                   	pop    %ebx
80104e03:	5e                   	pop    %esi
80104e04:	5d                   	pop    %ebp
80104e05:	c3                   	ret    
80104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104e10:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	ff 75 f4             	pushl  -0xc(%ebp)
80104e1a:	e8 51 c0 ff ff       	call   80100e70 <filedup>
  return fd;
80104e1f:	83 c4 10             	add    $0x10,%esp
}
80104e22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e25:	89 d8                	mov    %ebx,%eax
80104e27:	5b                   	pop    %ebx
80104e28:	5e                   	pop    %esi
80104e29:	5d                   	pop    %ebp
80104e2a:	c3                   	ret    
80104e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop

80104e30 <sys_read>:
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e35:	31 c0                	xor    %eax,%eax
{
80104e37:	89 e5                	mov    %esp,%ebp
80104e39:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e3c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e3f:	e8 2c ff ff ff       	call   80104d70 <argfd.constprop.0>
80104e44:	85 c0                	test   %eax,%eax
80104e46:	78 48                	js     80104e90 <sys_read+0x60>
80104e48:	83 ec 08             	sub    $0x8,%esp
80104e4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e4e:	50                   	push   %eax
80104e4f:	6a 02                	push   $0x2
80104e51:	e8 1a fc ff ff       	call   80104a70 <argint>
80104e56:	83 c4 10             	add    $0x10,%esp
80104e59:	85 c0                	test   %eax,%eax
80104e5b:	78 33                	js     80104e90 <sys_read+0x60>
80104e5d:	83 ec 04             	sub    $0x4,%esp
80104e60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e63:	ff 75 f0             	pushl  -0x10(%ebp)
80104e66:	50                   	push   %eax
80104e67:	6a 01                	push   $0x1
80104e69:	e8 52 fc ff ff       	call   80104ac0 <argptr>
80104e6e:	83 c4 10             	add    $0x10,%esp
80104e71:	85 c0                	test   %eax,%eax
80104e73:	78 1b                	js     80104e90 <sys_read+0x60>
  return fileread(f, p, n);
80104e75:	83 ec 04             	sub    $0x4,%esp
80104e78:	ff 75 f0             	pushl  -0x10(%ebp)
80104e7b:	ff 75 f4             	pushl  -0xc(%ebp)
80104e7e:	ff 75 ec             	pushl  -0x14(%ebp)
80104e81:	e8 6a c1 ff ff       	call   80100ff0 <fileread>
80104e86:	83 c4 10             	add    $0x10,%esp
}
80104e89:	c9                   	leave  
80104e8a:	c3                   	ret    
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop
80104e90:	c9                   	leave  
    return -1;
80104e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e96:	c3                   	ret    
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <sys_write>:
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ea5:	31 c0                	xor    %eax,%eax
{
80104ea7:	89 e5                	mov    %esp,%ebp
80104ea9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eac:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104eaf:	e8 bc fe ff ff       	call   80104d70 <argfd.constprop.0>
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	78 48                	js     80104f00 <sys_write+0x60>
80104eb8:	83 ec 08             	sub    $0x8,%esp
80104ebb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ebe:	50                   	push   %eax
80104ebf:	6a 02                	push   $0x2
80104ec1:	e8 aa fb ff ff       	call   80104a70 <argint>
80104ec6:	83 c4 10             	add    $0x10,%esp
80104ec9:	85 c0                	test   %eax,%eax
80104ecb:	78 33                	js     80104f00 <sys_write+0x60>
80104ecd:	83 ec 04             	sub    $0x4,%esp
80104ed0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ed3:	ff 75 f0             	pushl  -0x10(%ebp)
80104ed6:	50                   	push   %eax
80104ed7:	6a 01                	push   $0x1
80104ed9:	e8 e2 fb ff ff       	call   80104ac0 <argptr>
80104ede:	83 c4 10             	add    $0x10,%esp
80104ee1:	85 c0                	test   %eax,%eax
80104ee3:	78 1b                	js     80104f00 <sys_write+0x60>
  return filewrite(f, p, n);
80104ee5:	83 ec 04             	sub    $0x4,%esp
80104ee8:	ff 75 f0             	pushl  -0x10(%ebp)
80104eeb:	ff 75 f4             	pushl  -0xc(%ebp)
80104eee:	ff 75 ec             	pushl  -0x14(%ebp)
80104ef1:	e8 9a c1 ff ff       	call   80101090 <filewrite>
80104ef6:	83 c4 10             	add    $0x10,%esp
}
80104ef9:	c9                   	leave  
80104efa:	c3                   	ret    
80104efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eff:	90                   	nop
80104f00:	c9                   	leave  
    return -1;
80104f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f06:	c3                   	ret    
80104f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <sys_close>:
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104f1a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f20:	e8 4b fe ff ff       	call   80104d70 <argfd.constprop.0>
80104f25:	85 c0                	test   %eax,%eax
80104f27:	78 27                	js     80104f50 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f29:	e8 42 eb ff ff       	call   80103a70 <myproc>
80104f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f31:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f34:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f3b:	00 
  fileclose(f);
80104f3c:	ff 75 f4             	pushl  -0xc(%ebp)
80104f3f:	e8 7c bf ff ff       	call   80100ec0 <fileclose>
  return 0;
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	31 c0                	xor    %eax,%eax
}
80104f49:	c9                   	leave  
80104f4a:	c3                   	ret    
80104f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f4f:	90                   	nop
80104f50:	c9                   	leave  
    return -1;
80104f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f56:	c3                   	ret    
80104f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <sys_fstat>:
{
80104f60:	f3 0f 1e fb          	endbr32 
80104f64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f65:	31 c0                	xor    %eax,%eax
{
80104f67:	89 e5                	mov    %esp,%ebp
80104f69:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f6c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f6f:	e8 fc fd ff ff       	call   80104d70 <argfd.constprop.0>
80104f74:	85 c0                	test   %eax,%eax
80104f76:	78 30                	js     80104fa8 <sys_fstat+0x48>
80104f78:	83 ec 04             	sub    $0x4,%esp
80104f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f7e:	6a 14                	push   $0x14
80104f80:	50                   	push   %eax
80104f81:	6a 01                	push   $0x1
80104f83:	e8 38 fb ff ff       	call   80104ac0 <argptr>
80104f88:	83 c4 10             	add    $0x10,%esp
80104f8b:	85 c0                	test   %eax,%eax
80104f8d:	78 19                	js     80104fa8 <sys_fstat+0x48>
  return filestat(f, st);
80104f8f:	83 ec 08             	sub    $0x8,%esp
80104f92:	ff 75 f4             	pushl  -0xc(%ebp)
80104f95:	ff 75 f0             	pushl  -0x10(%ebp)
80104f98:	e8 03 c0 ff ff       	call   80100fa0 <filestat>
80104f9d:	83 c4 10             	add    $0x10,%esp
}
80104fa0:	c9                   	leave  
80104fa1:	c3                   	ret    
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fa8:	c9                   	leave  
    return -1;
80104fa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fae:	c3                   	ret    
80104faf:	90                   	nop

80104fb0 <sys_link>:
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	57                   	push   %edi
80104fb8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fb9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fbc:	53                   	push   %ebx
80104fbd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fc0:	50                   	push   %eax
80104fc1:	6a 00                	push   $0x0
80104fc3:	e8 58 fb ff ff       	call   80104b20 <argstr>
80104fc8:	83 c4 10             	add    $0x10,%esp
80104fcb:	85 c0                	test   %eax,%eax
80104fcd:	0f 88 ff 00 00 00    	js     801050d2 <sys_link+0x122>
80104fd3:	83 ec 08             	sub    $0x8,%esp
80104fd6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fd9:	50                   	push   %eax
80104fda:	6a 01                	push   $0x1
80104fdc:	e8 3f fb ff ff       	call   80104b20 <argstr>
80104fe1:	83 c4 10             	add    $0x10,%esp
80104fe4:	85 c0                	test   %eax,%eax
80104fe6:	0f 88 e6 00 00 00    	js     801050d2 <sys_link+0x122>
  begin_op();
80104fec:	e8 4f de ff ff       	call   80102e40 <begin_op>
  if((ip = namei(old)) == 0){
80104ff1:	83 ec 0c             	sub    $0xc,%esp
80104ff4:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ff7:	e8 34 d0 ff ff       	call   80102030 <namei>
80104ffc:	83 c4 10             	add    $0x10,%esp
80104fff:	89 c3                	mov    %eax,%ebx
80105001:	85 c0                	test   %eax,%eax
80105003:	0f 84 e8 00 00 00    	je     801050f1 <sys_link+0x141>
  ilock(ip);
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	50                   	push   %eax
8010500d:	e8 4e c7 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105012:	83 c4 10             	add    $0x10,%esp
80105015:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010501a:	0f 84 b9 00 00 00    	je     801050d9 <sys_link+0x129>
  iupdate(ip);
80105020:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105023:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105028:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010502b:	53                   	push   %ebx
8010502c:	e8 6f c6 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105031:	89 1c 24             	mov    %ebx,(%esp)
80105034:	e8 07 c8 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105039:	58                   	pop    %eax
8010503a:	5a                   	pop    %edx
8010503b:	57                   	push   %edi
8010503c:	ff 75 d0             	pushl  -0x30(%ebp)
8010503f:	e8 0c d0 ff ff       	call   80102050 <nameiparent>
80105044:	83 c4 10             	add    $0x10,%esp
80105047:	89 c6                	mov    %eax,%esi
80105049:	85 c0                	test   %eax,%eax
8010504b:	74 5f                	je     801050ac <sys_link+0xfc>
  ilock(dp);
8010504d:	83 ec 0c             	sub    $0xc,%esp
80105050:	50                   	push   %eax
80105051:	e8 0a c7 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105056:	8b 03                	mov    (%ebx),%eax
80105058:	83 c4 10             	add    $0x10,%esp
8010505b:	39 06                	cmp    %eax,(%esi)
8010505d:	75 41                	jne    801050a0 <sys_link+0xf0>
8010505f:	83 ec 04             	sub    $0x4,%esp
80105062:	ff 73 04             	pushl  0x4(%ebx)
80105065:	57                   	push   %edi
80105066:	56                   	push   %esi
80105067:	e8 04 cf ff ff       	call   80101f70 <dirlink>
8010506c:	83 c4 10             	add    $0x10,%esp
8010506f:	85 c0                	test   %eax,%eax
80105071:	78 2d                	js     801050a0 <sys_link+0xf0>
  iunlockput(dp);
80105073:	83 ec 0c             	sub    $0xc,%esp
80105076:	56                   	push   %esi
80105077:	e8 84 c9 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010507c:	89 1c 24             	mov    %ebx,(%esp)
8010507f:	e8 0c c8 ff ff       	call   80101890 <iput>
  end_op();
80105084:	e8 27 de ff ff       	call   80102eb0 <end_op>
  return 0;
80105089:	83 c4 10             	add    $0x10,%esp
8010508c:	31 c0                	xor    %eax,%eax
}
8010508e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105091:	5b                   	pop    %ebx
80105092:	5e                   	pop    %esi
80105093:	5f                   	pop    %edi
80105094:	5d                   	pop    %ebp
80105095:	c3                   	ret    
80105096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	56                   	push   %esi
801050a4:	e8 57 c9 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801050a9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050ac:	83 ec 0c             	sub    $0xc,%esp
801050af:	53                   	push   %ebx
801050b0:	e8 ab c6 ff ff       	call   80101760 <ilock>
  ip->nlink--;
801050b5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050ba:	89 1c 24             	mov    %ebx,(%esp)
801050bd:	e8 de c5 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801050c2:	89 1c 24             	mov    %ebx,(%esp)
801050c5:	e8 36 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
801050ca:	e8 e1 dd ff ff       	call   80102eb0 <end_op>
  return -1;
801050cf:	83 c4 10             	add    $0x10,%esp
801050d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d7:	eb b5                	jmp    8010508e <sys_link+0xde>
    iunlockput(ip);
801050d9:	83 ec 0c             	sub    $0xc,%esp
801050dc:	53                   	push   %ebx
801050dd:	e8 1e c9 ff ff       	call   80101a00 <iunlockput>
    end_op();
801050e2:	e8 c9 dd ff ff       	call   80102eb0 <end_op>
    return -1;
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ef:	eb 9d                	jmp    8010508e <sys_link+0xde>
    end_op();
801050f1:	e8 ba dd ff ff       	call   80102eb0 <end_op>
    return -1;
801050f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fb:	eb 91                	jmp    8010508e <sys_link+0xde>
801050fd:	8d 76 00             	lea    0x0(%esi),%esi

80105100 <sys_unlink>:
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	57                   	push   %edi
80105108:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105109:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010510c:	53                   	push   %ebx
8010510d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105110:	50                   	push   %eax
80105111:	6a 00                	push   $0x0
80105113:	e8 08 fa ff ff       	call   80104b20 <argstr>
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	85 c0                	test   %eax,%eax
8010511d:	0f 88 7d 01 00 00    	js     801052a0 <sys_unlink+0x1a0>
  begin_op();
80105123:	e8 18 dd ff ff       	call   80102e40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105128:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010512b:	83 ec 08             	sub    $0x8,%esp
8010512e:	53                   	push   %ebx
8010512f:	ff 75 c0             	pushl  -0x40(%ebp)
80105132:	e8 19 cf ff ff       	call   80102050 <nameiparent>
80105137:	83 c4 10             	add    $0x10,%esp
8010513a:	89 c6                	mov    %eax,%esi
8010513c:	85 c0                	test   %eax,%eax
8010513e:	0f 84 66 01 00 00    	je     801052aa <sys_unlink+0x1aa>
  ilock(dp);
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	50                   	push   %eax
80105148:	e8 13 c6 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010514d:	58                   	pop    %eax
8010514e:	5a                   	pop    %edx
8010514f:	68 3c 7a 10 80       	push   $0x80107a3c
80105154:	53                   	push   %ebx
80105155:	e8 36 cb ff ff       	call   80101c90 <namecmp>
8010515a:	83 c4 10             	add    $0x10,%esp
8010515d:	85 c0                	test   %eax,%eax
8010515f:	0f 84 03 01 00 00    	je     80105268 <sys_unlink+0x168>
80105165:	83 ec 08             	sub    $0x8,%esp
80105168:	68 3b 7a 10 80       	push   $0x80107a3b
8010516d:	53                   	push   %ebx
8010516e:	e8 1d cb ff ff       	call   80101c90 <namecmp>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	0f 84 ea 00 00 00    	je     80105268 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010517e:	83 ec 04             	sub    $0x4,%esp
80105181:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105184:	50                   	push   %eax
80105185:	53                   	push   %ebx
80105186:	56                   	push   %esi
80105187:	e8 24 cb ff ff       	call   80101cb0 <dirlookup>
8010518c:	83 c4 10             	add    $0x10,%esp
8010518f:	89 c3                	mov    %eax,%ebx
80105191:	85 c0                	test   %eax,%eax
80105193:	0f 84 cf 00 00 00    	je     80105268 <sys_unlink+0x168>
  ilock(ip);
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	50                   	push   %eax
8010519d:	e8 be c5 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
801051a2:	83 c4 10             	add    $0x10,%esp
801051a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051aa:	0f 8e 23 01 00 00    	jle    801052d3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801051b8:	74 66                	je     80105220 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051ba:	83 ec 04             	sub    $0x4,%esp
801051bd:	6a 10                	push   $0x10
801051bf:	6a 00                	push   $0x0
801051c1:	57                   	push   %edi
801051c2:	e8 c9 f5 ff ff       	call   80104790 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051c7:	6a 10                	push   $0x10
801051c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801051cc:	57                   	push   %edi
801051cd:	56                   	push   %esi
801051ce:	e8 8d c9 ff ff       	call   80101b60 <writei>
801051d3:	83 c4 20             	add    $0x20,%esp
801051d6:	83 f8 10             	cmp    $0x10,%eax
801051d9:	0f 85 e7 00 00 00    	jne    801052c6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801051df:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051e4:	0f 84 96 00 00 00    	je     80105280 <sys_unlink+0x180>
  iunlockput(dp);
801051ea:	83 ec 0c             	sub    $0xc,%esp
801051ed:	56                   	push   %esi
801051ee:	e8 0d c8 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
801051f3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051f8:	89 1c 24             	mov    %ebx,(%esp)
801051fb:	e8 a0 c4 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105200:	89 1c 24             	mov    %ebx,(%esp)
80105203:	e8 f8 c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105208:	e8 a3 dc ff ff       	call   80102eb0 <end_op>
  return 0;
8010520d:	83 c4 10             	add    $0x10,%esp
80105210:	31 c0                	xor    %eax,%eax
}
80105212:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105215:	5b                   	pop    %ebx
80105216:	5e                   	pop    %esi
80105217:	5f                   	pop    %edi
80105218:	5d                   	pop    %ebp
80105219:	c3                   	ret    
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105220:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105224:	76 94                	jbe    801051ba <sys_unlink+0xba>
80105226:	ba 20 00 00 00       	mov    $0x20,%edx
8010522b:	eb 0b                	jmp    80105238 <sys_unlink+0x138>
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
80105230:	83 c2 10             	add    $0x10,%edx
80105233:	39 53 58             	cmp    %edx,0x58(%ebx)
80105236:	76 82                	jbe    801051ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105238:	6a 10                	push   $0x10
8010523a:	52                   	push   %edx
8010523b:	57                   	push   %edi
8010523c:	53                   	push   %ebx
8010523d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105240:	e8 1b c8 ff ff       	call   80101a60 <readi>
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010524b:	83 f8 10             	cmp    $0x10,%eax
8010524e:	75 69                	jne    801052b9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105250:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105255:	74 d9                	je     80105230 <sys_unlink+0x130>
    iunlockput(ip);
80105257:	83 ec 0c             	sub    $0xc,%esp
8010525a:	53                   	push   %ebx
8010525b:	e8 a0 c7 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105267:	90                   	nop
  iunlockput(dp);
80105268:	83 ec 0c             	sub    $0xc,%esp
8010526b:	56                   	push   %esi
8010526c:	e8 8f c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105271:	e8 3a dc ff ff       	call   80102eb0 <end_op>
  return -1;
80105276:	83 c4 10             	add    $0x10,%esp
80105279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527e:	eb 92                	jmp    80105212 <sys_unlink+0x112>
    iupdate(dp);
80105280:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105283:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105288:	56                   	push   %esi
80105289:	e8 12 c4 ff ff       	call   801016a0 <iupdate>
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	e9 54 ff ff ff       	jmp    801051ea <sys_unlink+0xea>
80105296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a5:	e9 68 ff ff ff       	jmp    80105212 <sys_unlink+0x112>
    end_op();
801052aa:	e8 01 dc ff ff       	call   80102eb0 <end_op>
    return -1;
801052af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b4:	e9 59 ff ff ff       	jmp    80105212 <sys_unlink+0x112>
      panic("isdirempty: readi");
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	68 60 7a 10 80       	push   $0x80107a60
801052c1:	e8 ca b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801052c6:	83 ec 0c             	sub    $0xc,%esp
801052c9:	68 72 7a 10 80       	push   $0x80107a72
801052ce:	e8 bd b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801052d3:	83 ec 0c             	sub    $0xc,%esp
801052d6:	68 4e 7a 10 80       	push   $0x80107a4e
801052db:	e8 b0 b0 ff ff       	call   80100390 <panic>

801052e0 <sys_open>:

int
sys_open(void)
{
801052e0:	f3 0f 1e fb          	endbr32 
801052e4:	55                   	push   %ebp
801052e5:	89 e5                	mov    %esp,%ebp
801052e7:	57                   	push   %edi
801052e8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052ec:	53                   	push   %ebx
801052ed:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052f0:	50                   	push   %eax
801052f1:	6a 00                	push   $0x0
801052f3:	e8 28 f8 ff ff       	call   80104b20 <argstr>
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	85 c0                	test   %eax,%eax
801052fd:	0f 88 8a 00 00 00    	js     8010538d <sys_open+0xad>
80105303:	83 ec 08             	sub    $0x8,%esp
80105306:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105309:	50                   	push   %eax
8010530a:	6a 01                	push   $0x1
8010530c:	e8 5f f7 ff ff       	call   80104a70 <argint>
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	85 c0                	test   %eax,%eax
80105316:	78 75                	js     8010538d <sys_open+0xad>
    return -1;

  begin_op();
80105318:	e8 23 db ff ff       	call   80102e40 <begin_op>

  if(omode & O_CREATE){
8010531d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105321:	75 75                	jne    80105398 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105323:	83 ec 0c             	sub    $0xc,%esp
80105326:	ff 75 e0             	pushl  -0x20(%ebp)
80105329:	e8 02 cd ff ff       	call   80102030 <namei>
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	89 c6                	mov    %eax,%esi
80105333:	85 c0                	test   %eax,%eax
80105335:	74 7e                	je     801053b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105337:	83 ec 0c             	sub    $0xc,%esp
8010533a:	50                   	push   %eax
8010533b:	e8 20 c4 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105340:	83 c4 10             	add    $0x10,%esp
80105343:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105348:	0f 84 c2 00 00 00    	je     80105410 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010534e:	e8 ad ba ff ff       	call   80100e00 <filealloc>
80105353:	89 c7                	mov    %eax,%edi
80105355:	85 c0                	test   %eax,%eax
80105357:	74 23                	je     8010537c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105359:	e8 12 e7 ff ff       	call   80103a70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010535e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105360:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105364:	85 d2                	test   %edx,%edx
80105366:	74 60                	je     801053c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105368:	83 c3 01             	add    $0x1,%ebx
8010536b:	83 fb 10             	cmp    $0x10,%ebx
8010536e:	75 f0                	jne    80105360 <sys_open+0x80>
    if(f)
      fileclose(f);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	57                   	push   %edi
80105374:	e8 47 bb ff ff       	call   80100ec0 <fileclose>
80105379:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	56                   	push   %esi
80105380:	e8 7b c6 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105385:	e8 26 db ff ff       	call   80102eb0 <end_op>
    return -1;
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105392:	eb 6d                	jmp    80105401 <sys_open+0x121>
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105398:	83 ec 0c             	sub    $0xc,%esp
8010539b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010539e:	31 c9                	xor    %ecx,%ecx
801053a0:	ba 02 00 00 00       	mov    $0x2,%edx
801053a5:	6a 00                	push   $0x0
801053a7:	e8 24 f8 ff ff       	call   80104bd0 <create>
    if(ip == 0){
801053ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801053af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053b1:	85 c0                	test   %eax,%eax
801053b3:	75 99                	jne    8010534e <sys_open+0x6e>
      end_op();
801053b5:	e8 f6 da ff ff       	call   80102eb0 <end_op>
      return -1;
801053ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053bf:	eb 40                	jmp    80105401 <sys_open+0x121>
801053c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801053c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053cf:	56                   	push   %esi
801053d0:	e8 6b c4 ff ff       	call   80101840 <iunlock>
  end_op();
801053d5:	e8 d6 da ff ff       	call   80102eb0 <end_op>

  f->type = FD_INODE;
801053da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801053e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801053e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801053eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053f2:	f7 d0                	not    %eax
801053f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801053fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105404:	89 d8                	mov    %ebx,%eax
80105406:	5b                   	pop    %ebx
80105407:	5e                   	pop    %esi
80105408:	5f                   	pop    %edi
80105409:	5d                   	pop    %ebp
8010540a:	c3                   	ret    
8010540b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010540f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105410:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105413:	85 c9                	test   %ecx,%ecx
80105415:	0f 84 33 ff ff ff    	je     8010534e <sys_open+0x6e>
8010541b:	e9 5c ff ff ff       	jmp    8010537c <sys_open+0x9c>

80105420 <sys_mkdir>:

int
sys_mkdir(void)
{
80105420:	f3 0f 1e fb          	endbr32 
80105424:	55                   	push   %ebp
80105425:	89 e5                	mov    %esp,%ebp
80105427:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010542a:	e8 11 da ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010542f:	83 ec 08             	sub    $0x8,%esp
80105432:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105435:	50                   	push   %eax
80105436:	6a 00                	push   $0x0
80105438:	e8 e3 f6 ff ff       	call   80104b20 <argstr>
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	85 c0                	test   %eax,%eax
80105442:	78 34                	js     80105478 <sys_mkdir+0x58>
80105444:	83 ec 0c             	sub    $0xc,%esp
80105447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010544a:	31 c9                	xor    %ecx,%ecx
8010544c:	ba 01 00 00 00       	mov    $0x1,%edx
80105451:	6a 00                	push   $0x0
80105453:	e8 78 f7 ff ff       	call   80104bd0 <create>
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	85 c0                	test   %eax,%eax
8010545d:	74 19                	je     80105478 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	50                   	push   %eax
80105463:	e8 98 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105468:	e8 43 da ff ff       	call   80102eb0 <end_op>
  return 0;
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	31 c0                	xor    %eax,%eax
}
80105472:	c9                   	leave  
80105473:	c3                   	ret    
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105478:	e8 33 da ff ff       	call   80102eb0 <end_op>
    return -1;
8010547d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105482:	c9                   	leave  
80105483:	c3                   	ret    
80105484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010548f:	90                   	nop

80105490 <sys_mknod>:

int
sys_mknod(void)
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010549a:	e8 a1 d9 ff ff       	call   80102e40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010549f:	83 ec 08             	sub    $0x8,%esp
801054a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054a5:	50                   	push   %eax
801054a6:	6a 00                	push   $0x0
801054a8:	e8 73 f6 ff ff       	call   80104b20 <argstr>
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 64                	js     80105518 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801054b4:	83 ec 08             	sub    $0x8,%esp
801054b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ba:	50                   	push   %eax
801054bb:	6a 01                	push   $0x1
801054bd:	e8 ae f5 ff ff       	call   80104a70 <argint>
  if((argstr(0, &path)) < 0 ||
801054c2:	83 c4 10             	add    $0x10,%esp
801054c5:	85 c0                	test   %eax,%eax
801054c7:	78 4f                	js     80105518 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801054c9:	83 ec 08             	sub    $0x8,%esp
801054cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054cf:	50                   	push   %eax
801054d0:	6a 02                	push   $0x2
801054d2:	e8 99 f5 ff ff       	call   80104a70 <argint>
     argint(1, &major) < 0 ||
801054d7:	83 c4 10             	add    $0x10,%esp
801054da:	85 c0                	test   %eax,%eax
801054dc:	78 3a                	js     80105518 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054de:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801054e2:	83 ec 0c             	sub    $0xc,%esp
801054e5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054e9:	ba 03 00 00 00       	mov    $0x3,%edx
801054ee:	50                   	push   %eax
801054ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054f2:	e8 d9 f6 ff ff       	call   80104bd0 <create>
     argint(2, &minor) < 0 ||
801054f7:	83 c4 10             	add    $0x10,%esp
801054fa:	85 c0                	test   %eax,%eax
801054fc:	74 1a                	je     80105518 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054fe:	83 ec 0c             	sub    $0xc,%esp
80105501:	50                   	push   %eax
80105502:	e8 f9 c4 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105507:	e8 a4 d9 ff ff       	call   80102eb0 <end_op>
  return 0;
8010550c:	83 c4 10             	add    $0x10,%esp
8010550f:	31 c0                	xor    %eax,%eax
}
80105511:	c9                   	leave  
80105512:	c3                   	ret    
80105513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105517:	90                   	nop
    end_op();
80105518:	e8 93 d9 ff ff       	call   80102eb0 <end_op>
    return -1;
8010551d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105522:	c9                   	leave  
80105523:	c3                   	ret    
80105524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010552f:	90                   	nop

80105530 <sys_chdir>:

int
sys_chdir(void)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	56                   	push   %esi
80105538:	53                   	push   %ebx
80105539:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010553c:	e8 2f e5 ff ff       	call   80103a70 <myproc>
80105541:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105543:	e8 f8 d8 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105548:	83 ec 08             	sub    $0x8,%esp
8010554b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010554e:	50                   	push   %eax
8010554f:	6a 00                	push   $0x0
80105551:	e8 ca f5 ff ff       	call   80104b20 <argstr>
80105556:	83 c4 10             	add    $0x10,%esp
80105559:	85 c0                	test   %eax,%eax
8010555b:	78 73                	js     801055d0 <sys_chdir+0xa0>
8010555d:	83 ec 0c             	sub    $0xc,%esp
80105560:	ff 75 f4             	pushl  -0xc(%ebp)
80105563:	e8 c8 ca ff ff       	call   80102030 <namei>
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	89 c3                	mov    %eax,%ebx
8010556d:	85 c0                	test   %eax,%eax
8010556f:	74 5f                	je     801055d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105571:	83 ec 0c             	sub    $0xc,%esp
80105574:	50                   	push   %eax
80105575:	e8 e6 c1 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010557a:	83 c4 10             	add    $0x10,%esp
8010557d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105582:	75 2c                	jne    801055b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105584:	83 ec 0c             	sub    $0xc,%esp
80105587:	53                   	push   %ebx
80105588:	e8 b3 c2 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
8010558d:	58                   	pop    %eax
8010558e:	ff 76 68             	pushl  0x68(%esi)
80105591:	e8 fa c2 ff ff       	call   80101890 <iput>
  end_op();
80105596:	e8 15 d9 ff ff       	call   80102eb0 <end_op>
  curproc->cwd = ip;
8010559b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	31 c0                	xor    %eax,%eax
}
801055a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055a6:	5b                   	pop    %ebx
801055a7:	5e                   	pop    %esi
801055a8:	5d                   	pop    %ebp
801055a9:	c3                   	ret    
801055aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801055b0:	83 ec 0c             	sub    $0xc,%esp
801055b3:	53                   	push   %ebx
801055b4:	e8 47 c4 ff ff       	call   80101a00 <iunlockput>
    end_op();
801055b9:	e8 f2 d8 ff ff       	call   80102eb0 <end_op>
    return -1;
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c6:	eb db                	jmp    801055a3 <sys_chdir+0x73>
801055c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cf:	90                   	nop
    end_op();
801055d0:	e8 db d8 ff ff       	call   80102eb0 <end_op>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055da:	eb c7                	jmp    801055a3 <sys_chdir+0x73>
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_exec>:

int
sys_exec(void)
{
801055e0:	f3 0f 1e fb          	endbr32 
801055e4:	55                   	push   %ebp
801055e5:	89 e5                	mov    %esp,%ebp
801055e7:	57                   	push   %edi
801055e8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055e9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055ef:	53                   	push   %ebx
801055f0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055f6:	50                   	push   %eax
801055f7:	6a 00                	push   $0x0
801055f9:	e8 22 f5 ff ff       	call   80104b20 <argstr>
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	0f 88 8b 00 00 00    	js     80105694 <sys_exec+0xb4>
80105609:	83 ec 08             	sub    $0x8,%esp
8010560c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105612:	50                   	push   %eax
80105613:	6a 01                	push   $0x1
80105615:	e8 56 f4 ff ff       	call   80104a70 <argint>
8010561a:	83 c4 10             	add    $0x10,%esp
8010561d:	85 c0                	test   %eax,%eax
8010561f:	78 73                	js     80105694 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105621:	83 ec 04             	sub    $0x4,%esp
80105624:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010562a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010562c:	68 80 00 00 00       	push   $0x80
80105631:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105637:	6a 00                	push   $0x0
80105639:	50                   	push   %eax
8010563a:	e8 51 f1 ff ff       	call   80104790 <memset>
8010563f:	83 c4 10             	add    $0x10,%esp
80105642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105648:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010564e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105655:	83 ec 08             	sub    $0x8,%esp
80105658:	57                   	push   %edi
80105659:	01 f0                	add    %esi,%eax
8010565b:	50                   	push   %eax
8010565c:	e8 6f f3 ff ff       	call   801049d0 <fetchint>
80105661:	83 c4 10             	add    $0x10,%esp
80105664:	85 c0                	test   %eax,%eax
80105666:	78 2c                	js     80105694 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105668:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010566e:	85 c0                	test   %eax,%eax
80105670:	74 36                	je     801056a8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105672:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105678:	83 ec 08             	sub    $0x8,%esp
8010567b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010567e:	52                   	push   %edx
8010567f:	50                   	push   %eax
80105680:	e8 8b f3 ff ff       	call   80104a10 <fetchstr>
80105685:	83 c4 10             	add    $0x10,%esp
80105688:	85 c0                	test   %eax,%eax
8010568a:	78 08                	js     80105694 <sys_exec+0xb4>
  for(i=0;; i++){
8010568c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010568f:	83 fb 20             	cmp    $0x20,%ebx
80105692:	75 b4                	jne    80105648 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105694:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569c:	5b                   	pop    %ebx
8010569d:	5e                   	pop    %esi
8010569e:	5f                   	pop    %edi
8010569f:	5d                   	pop    %ebp
801056a0:	c3                   	ret    
801056a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801056a8:	83 ec 08             	sub    $0x8,%esp
801056ab:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801056b1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056b8:	00 00 00 00 
  return exec(path, argv);
801056bc:	50                   	push   %eax
801056bd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801056c3:	e8 b8 b3 ff ff       	call   80100a80 <exec>
801056c8:	83 c4 10             	add    $0x10,%esp
}
801056cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ce:	5b                   	pop    %ebx
801056cf:	5e                   	pop    %esi
801056d0:	5f                   	pop    %edi
801056d1:	5d                   	pop    %ebp
801056d2:	c3                   	ret    
801056d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056e0 <sys_pipe>:

int
sys_pipe(void)
{
801056e0:	f3 0f 1e fb          	endbr32 
801056e4:	55                   	push   %ebp
801056e5:	89 e5                	mov    %esp,%ebp
801056e7:	57                   	push   %edi
801056e8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056e9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801056ec:	53                   	push   %ebx
801056ed:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056f0:	6a 08                	push   $0x8
801056f2:	50                   	push   %eax
801056f3:	6a 00                	push   $0x0
801056f5:	e8 c6 f3 ff ff       	call   80104ac0 <argptr>
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	85 c0                	test   %eax,%eax
801056ff:	78 4e                	js     8010574f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105701:	83 ec 08             	sub    $0x8,%esp
80105704:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105707:	50                   	push   %eax
80105708:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010570b:	50                   	push   %eax
8010570c:	e8 ef dd ff ff       	call   80103500 <pipealloc>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	85 c0                	test   %eax,%eax
80105716:	78 37                	js     8010574f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010571b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010571d:	e8 4e e3 ff ff       	call   80103a70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105728:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010572c:	85 f6                	test   %esi,%esi
8010572e:	74 30                	je     80105760 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105730:	83 c3 01             	add    $0x1,%ebx
80105733:	83 fb 10             	cmp    $0x10,%ebx
80105736:	75 f0                	jne    80105728 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105738:	83 ec 0c             	sub    $0xc,%esp
8010573b:	ff 75 e0             	pushl  -0x20(%ebp)
8010573e:	e8 7d b7 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105743:	58                   	pop    %eax
80105744:	ff 75 e4             	pushl  -0x1c(%ebp)
80105747:	e8 74 b7 ff ff       	call   80100ec0 <fileclose>
    return -1;
8010574c:	83 c4 10             	add    $0x10,%esp
8010574f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105754:	eb 5b                	jmp    801057b1 <sys_pipe+0xd1>
80105756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105760:	8d 73 08             	lea    0x8(%ebx),%esi
80105763:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105767:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010576a:	e8 01 e3 ff ff       	call   80103a70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010576f:	31 d2                	xor    %edx,%edx
80105771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105778:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010577c:	85 c9                	test   %ecx,%ecx
8010577e:	74 20                	je     801057a0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105780:	83 c2 01             	add    $0x1,%edx
80105783:	83 fa 10             	cmp    $0x10,%edx
80105786:	75 f0                	jne    80105778 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105788:	e8 e3 e2 ff ff       	call   80103a70 <myproc>
8010578d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105794:	00 
80105795:	eb a1                	jmp    80105738 <sys_pipe+0x58>
80105797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057af:	31 c0                	xor    %eax,%eax
}
801057b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_swapread>:

int sys_swapread(void)
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
801057ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057cd:	68 00 10 00 00       	push   $0x1000
801057d2:	50                   	push   %eax
801057d3:	6a 00                	push   $0x0
801057d5:	e8 e6 f2 ff ff       	call   80104ac0 <argptr>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	78 2f                	js     80105810 <sys_swapread+0x50>
801057e1:	83 ec 08             	sub    $0x8,%esp
801057e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e7:	50                   	push   %eax
801057e8:	6a 01                	push   $0x1
801057ea:	e8 81 f2 ff ff       	call   80104a70 <argint>
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	85 c0                	test   %eax,%eax
801057f4:	78 1a                	js     80105810 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
801057f6:	83 ec 08             	sub    $0x8,%esp
801057f9:	ff 75 f4             	pushl  -0xc(%ebp)
801057fc:	ff 75 f0             	pushl  -0x10(%ebp)
801057ff:	e8 6c c8 ff ff       	call   80102070 <swapread>
	return 0;
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	31 c0                	xor    %eax,%eax
}
80105809:	c9                   	leave  
8010580a:	c3                   	ret    
8010580b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010580f:	90                   	nop
80105810:	c9                   	leave  
		return -1;
80105811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105816:	c3                   	ret    
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax

80105820 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
8010582a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010582d:	68 00 10 00 00       	push   $0x1000
80105832:	50                   	push   %eax
80105833:	6a 00                	push   $0x0
80105835:	e8 86 f2 ff ff       	call   80104ac0 <argptr>
8010583a:	83 c4 10             	add    $0x10,%esp
8010583d:	85 c0                	test   %eax,%eax
8010583f:	78 2f                	js     80105870 <sys_swapwrite+0x50>
80105841:	83 ec 08             	sub    $0x8,%esp
80105844:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105847:	50                   	push   %eax
80105848:	6a 01                	push   $0x1
8010584a:	e8 21 f2 ff ff       	call   80104a70 <argint>
8010584f:	83 c4 10             	add    $0x10,%esp
80105852:	85 c0                	test   %eax,%eax
80105854:	78 1a                	js     80105870 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105856:	83 ec 08             	sub    $0x8,%esp
80105859:	ff 75 f4             	pushl  -0xc(%ebp)
8010585c:	ff 75 f0             	pushl  -0x10(%ebp)
8010585f:	e8 8c c8 ff ff       	call   801020f0 <swapwrite>
	return 0;
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	31 c0                	xor    %eax,%eax
}
80105869:	c9                   	leave  
8010586a:	c3                   	ret    
8010586b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010586f:	90                   	nop
80105870:	c9                   	leave  
		return -1;
80105871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105876:	c3                   	ret    
80105877:	66 90                	xchg   %ax,%ax
80105879:	66 90                	xchg   %ax,%ax
8010587b:	66 90                	xchg   %ax,%ax
8010587d:	66 90                	xchg   %ax,%ax
8010587f:	90                   	nop

80105880 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105880:	f3 0f 1e fb          	endbr32 
  return fork();
80105884:	e9 a7 e3 ff ff       	jmp    80103c30 <fork>
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_exit>:
}

int
sys_exit(void)
{
80105890:	f3 0f 1e fb          	endbr32 
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	83 ec 08             	sub    $0x8,%esp
  exit();
8010589a:	e8 11 e6 ff ff       	call   80103eb0 <exit>
  return 0;  // not reached
}
8010589f:	31 c0                	xor    %eax,%eax
801058a1:	c9                   	leave  
801058a2:	c3                   	ret    
801058a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058b0 <sys_wait>:

int
sys_wait(void)
{
801058b0:	f3 0f 1e fb          	endbr32 
  return wait();
801058b4:	e9 47 e8 ff ff       	jmp    80104100 <wait>
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_kill>:
}

int
sys_kill(void)
{
801058c0:	f3 0f 1e fb          	endbr32 
801058c4:	55                   	push   %ebp
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058cd:	50                   	push   %eax
801058ce:	6a 00                	push   $0x0
801058d0:	e8 9b f1 ff ff       	call   80104a70 <argint>
801058d5:	83 c4 10             	add    $0x10,%esp
801058d8:	85 c0                	test   %eax,%eax
801058da:	78 14                	js     801058f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058dc:	83 ec 0c             	sub    $0xc,%esp
801058df:	ff 75 f4             	pushl  -0xc(%ebp)
801058e2:	e8 79 e9 ff ff       	call   80104260 <kill>
801058e7:	83 c4 10             	add    $0x10,%esp
}
801058ea:	c9                   	leave  
801058eb:	c3                   	ret    
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058f0:	c9                   	leave  
    return -1;
801058f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f6:	c3                   	ret    
801058f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fe:	66 90                	xchg   %ax,%ax

80105900 <sys_getpid>:

int
sys_getpid(void)
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
80105905:	89 e5                	mov    %esp,%ebp
80105907:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010590a:	e8 61 e1 ff ff       	call   80103a70 <myproc>
8010590f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105912:	c9                   	leave  
80105913:	c3                   	ret    
80105914:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop

80105920 <sys_sbrk>:

int
sys_sbrk(void)
{
80105920:	f3 0f 1e fb          	endbr32 
80105924:	55                   	push   %ebp
80105925:	89 e5                	mov    %esp,%ebp
80105927:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105928:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010592b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010592e:	50                   	push   %eax
8010592f:	6a 00                	push   $0x0
80105931:	e8 3a f1 ff ff       	call   80104a70 <argint>
80105936:	83 c4 10             	add    $0x10,%esp
80105939:	85 c0                	test   %eax,%eax
8010593b:	78 23                	js     80105960 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010593d:	e8 2e e1 ff ff       	call   80103a70 <myproc>
  if(growproc(n) < 0)
80105942:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105945:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105947:	ff 75 f4             	pushl  -0xc(%ebp)
8010594a:	e8 61 e2 ff ff       	call   80103bb0 <growproc>
8010594f:	83 c4 10             	add    $0x10,%esp
80105952:	85 c0                	test   %eax,%eax
80105954:	78 0a                	js     80105960 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105956:	89 d8                	mov    %ebx,%eax
80105958:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010595b:	c9                   	leave  
8010595c:	c3                   	ret    
8010595d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105960:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105965:	eb ef                	jmp    80105956 <sys_sbrk+0x36>
80105967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596e:	66 90                	xchg   %ax,%ax

80105970 <sys_sleep>:

int
sys_sleep(void)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105978:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010597b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010597e:	50                   	push   %eax
8010597f:	6a 00                	push   $0x0
80105981:	e8 ea f0 ff ff       	call   80104a70 <argint>
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	85 c0                	test   %eax,%eax
8010598b:	0f 88 86 00 00 00    	js     80105a17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105991:	83 ec 0c             	sub    $0xc,%esp
80105994:	68 60 4c 11 80       	push   $0x80114c60
80105999:	e8 e2 ec ff ff       	call   80104680 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010599e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059a1:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
801059a7:	83 c4 10             	add    $0x10,%esp
801059aa:	85 d2                	test   %edx,%edx
801059ac:	75 23                	jne    801059d1 <sys_sleep+0x61>
801059ae:	eb 50                	jmp    80105a00 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	68 60 4c 11 80       	push   $0x80114c60
801059b8:	68 a0 54 11 80       	push   $0x801154a0
801059bd:	e8 7e e6 ff ff       	call   80104040 <sleep>
  while(ticks - ticks0 < n){
801059c2:	a1 a0 54 11 80       	mov    0x801154a0,%eax
801059c7:	83 c4 10             	add    $0x10,%esp
801059ca:	29 d8                	sub    %ebx,%eax
801059cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059cf:	73 2f                	jae    80105a00 <sys_sleep+0x90>
    if(myproc()->killed){
801059d1:	e8 9a e0 ff ff       	call   80103a70 <myproc>
801059d6:	8b 40 24             	mov    0x24(%eax),%eax
801059d9:	85 c0                	test   %eax,%eax
801059db:	74 d3                	je     801059b0 <sys_sleep+0x40>
      release(&tickslock);
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	68 60 4c 11 80       	push   $0x80114c60
801059e5:	e8 56 ed ff ff       	call   80104740 <release>
  }
  release(&tickslock);
  return 0;
}
801059ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	68 60 4c 11 80       	push   $0x80114c60
80105a08:	e8 33 ed ff ff       	call   80104740 <release>
  return 0;
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	31 c0                	xor    %eax,%eax
}
80105a12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    
    return -1;
80105a17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1c:	eb f4                	jmp    80105a12 <sys_sleep+0xa2>
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	53                   	push   %ebx
80105a28:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a2b:	68 60 4c 11 80       	push   $0x80114c60
80105a30:	e8 4b ec ff ff       	call   80104680 <acquire>
  xticks = ticks;
80105a35:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105a3b:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105a42:	e8 f9 ec ff ff       	call   80104740 <release>
  return xticks;
}
80105a47:	89 d8                	mov    %ebx,%eax
80105a49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a4c:	c9                   	leave  
80105a4d:	c3                   	ret    

80105a4e <alltraps>:
80105a4e:	1e                   	push   %ds
80105a4f:	06                   	push   %es
80105a50:	0f a0                	push   %fs
80105a52:	0f a8                	push   %gs
80105a54:	60                   	pusha  
80105a55:	66 b8 10 00          	mov    $0x10,%ax
80105a59:	8e d8                	mov    %eax,%ds
80105a5b:	8e c0                	mov    %eax,%es
80105a5d:	54                   	push   %esp
80105a5e:	e8 cd 00 00 00       	call   80105b30 <trap>
80105a63:	83 c4 04             	add    $0x4,%esp

80105a66 <trapret>:
80105a66:	61                   	popa   
80105a67:	0f a9                	pop    %gs
80105a69:	0f a1                	pop    %fs
80105a6b:	07                   	pop    %es
80105a6c:	1f                   	pop    %ds
80105a6d:	83 c4 08             	add    $0x8,%esp
80105a70:	cf                   	iret   
80105a71:	66 90                	xchg   %ax,%ax
80105a73:	66 90                	xchg   %ax,%ax
80105a75:	66 90                	xchg   %ax,%ax
80105a77:	66 90                	xchg   %ax,%ax
80105a79:	66 90                	xchg   %ax,%ax
80105a7b:	66 90                	xchg   %ax,%ax
80105a7d:	66 90                	xchg   %ax,%ax
80105a7f:	90                   	nop

80105a80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a80:	f3 0f 1e fb          	endbr32 
80105a84:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a85:	31 c0                	xor    %eax,%eax
{
80105a87:	89 e5                	mov    %esp,%ebp
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a90:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a97:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
80105a9e:	08 00 00 8e 
80105aa2:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105aa9:	80 
80105aaa:	c1 ea 10             	shr    $0x10,%edx
80105aad:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105ab4:	80 
  for(i = 0; i < 256; i++)
80105ab5:	83 c0 01             	add    $0x1,%eax
80105ab8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105abd:	75 d1                	jne    80105a90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105abf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ac2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105ac7:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
80105ace:	00 00 ef 
  initlock(&tickslock, "time");
80105ad1:	68 81 7a 10 80       	push   $0x80107a81
80105ad6:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105adb:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105ae1:	c1 e8 10             	shr    $0x10,%eax
80105ae4:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
80105aea:	e8 11 ea ff ff       	call   80104500 <initlock>
}
80105aef:	83 c4 10             	add    $0x10,%esp
80105af2:	c9                   	leave  
80105af3:	c3                   	ret    
80105af4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop

80105b00 <idtinit>:

void
idtinit(void)
{
80105b00:	f3 0f 1e fb          	endbr32 
80105b04:	55                   	push   %ebp
  pd[0] = size-1;
80105b05:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b0a:	89 e5                	mov    %esp,%ebp
80105b0c:	83 ec 10             	sub    $0x10,%esp
80105b0f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b13:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105b18:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b1c:	c1 e8 10             	shr    $0x10,%eax
80105b1f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b23:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b26:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b29:	c9                   	leave  
80105b2a:	c3                   	ret    
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop

80105b30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	57                   	push   %edi
80105b38:	56                   	push   %esi
80105b39:	53                   	push   %ebx
80105b3a:	83 ec 1c             	sub    $0x1c,%esp
80105b3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b40:	8b 43 30             	mov    0x30(%ebx),%eax
80105b43:	83 f8 40             	cmp    $0x40,%eax
80105b46:	0f 84 bc 01 00 00    	je     80105d08 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b4c:	83 e8 20             	sub    $0x20,%eax
80105b4f:	83 f8 1f             	cmp    $0x1f,%eax
80105b52:	77 08                	ja     80105b5c <trap+0x2c>
80105b54:	3e ff 24 85 28 7b 10 	notrack jmp *-0x7fef84d8(,%eax,4)
80105b5b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b5c:	e8 0f df ff ff       	call   80103a70 <myproc>
80105b61:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b64:	85 c0                	test   %eax,%eax
80105b66:	0f 84 eb 01 00 00    	je     80105d57 <trap+0x227>
80105b6c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b70:	0f 84 e1 01 00 00    	je     80105d57 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b76:	0f 20 d1             	mov    %cr2,%ecx
80105b79:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b7c:	e8 cf de ff ff       	call   80103a50 <cpuid>
80105b81:	8b 73 30             	mov    0x30(%ebx),%esi
80105b84:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b87:	8b 43 34             	mov    0x34(%ebx),%eax
80105b8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b8d:	e8 de de ff ff       	call   80103a70 <myproc>
80105b92:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b95:	e8 d6 de ff ff       	call   80103a70 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b9a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ba0:	51                   	push   %ecx
80105ba1:	57                   	push   %edi
80105ba2:	52                   	push   %edx
80105ba3:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ba6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ba7:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105baa:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bad:	56                   	push   %esi
80105bae:	ff 70 10             	pushl  0x10(%eax)
80105bb1:	68 e4 7a 10 80       	push   $0x80107ae4
80105bb6:	e8 f5 aa ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105bbb:	83 c4 20             	add    $0x20,%esp
80105bbe:	e8 ad de ff ff       	call   80103a70 <myproc>
80105bc3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bca:	e8 a1 de ff ff       	call   80103a70 <myproc>
80105bcf:	85 c0                	test   %eax,%eax
80105bd1:	74 1d                	je     80105bf0 <trap+0xc0>
80105bd3:	e8 98 de ff ff       	call   80103a70 <myproc>
80105bd8:	8b 50 24             	mov    0x24(%eax),%edx
80105bdb:	85 d2                	test   %edx,%edx
80105bdd:	74 11                	je     80105bf0 <trap+0xc0>
80105bdf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105be3:	83 e0 03             	and    $0x3,%eax
80105be6:	66 83 f8 03          	cmp    $0x3,%ax
80105bea:	0f 84 50 01 00 00    	je     80105d40 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105bf0:	e8 7b de ff ff       	call   80103a70 <myproc>
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	74 0f                	je     80105c08 <trap+0xd8>
80105bf9:	e8 72 de ff ff       	call   80103a70 <myproc>
80105bfe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c02:	0f 84 e8 00 00 00    	je     80105cf0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c08:	e8 63 de ff ff       	call   80103a70 <myproc>
80105c0d:	85 c0                	test   %eax,%eax
80105c0f:	74 1d                	je     80105c2e <trap+0xfe>
80105c11:	e8 5a de ff ff       	call   80103a70 <myproc>
80105c16:	8b 40 24             	mov    0x24(%eax),%eax
80105c19:	85 c0                	test   %eax,%eax
80105c1b:	74 11                	je     80105c2e <trap+0xfe>
80105c1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c21:	83 e0 03             	and    $0x3,%eax
80105c24:	66 83 f8 03          	cmp    $0x3,%ax
80105c28:	0f 84 03 01 00 00    	je     80105d31 <trap+0x201>
    exit();
}
80105c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c31:	5b                   	pop    %ebx
80105c32:	5e                   	pop    %esi
80105c33:	5f                   	pop    %edi
80105c34:	5d                   	pop    %ebp
80105c35:	c3                   	ret    
    ideintr();
80105c36:	e8 b5 c6 ff ff       	call   801022f0 <ideintr>
    lapiceoi();
80105c3b:	e8 90 cd ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c40:	e8 2b de ff ff       	call   80103a70 <myproc>
80105c45:	85 c0                	test   %eax,%eax
80105c47:	75 8a                	jne    80105bd3 <trap+0xa3>
80105c49:	eb a5                	jmp    80105bf0 <trap+0xc0>
    if(cpuid() == 0){
80105c4b:	e8 00 de ff ff       	call   80103a50 <cpuid>
80105c50:	85 c0                	test   %eax,%eax
80105c52:	75 e7                	jne    80105c3b <trap+0x10b>
      acquire(&tickslock);
80105c54:	83 ec 0c             	sub    $0xc,%esp
80105c57:	68 60 4c 11 80       	push   $0x80114c60
80105c5c:	e8 1f ea ff ff       	call   80104680 <acquire>
      wakeup(&ticks);
80105c61:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105c68:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105c6f:	e8 8c e5 ff ff       	call   80104200 <wakeup>
      release(&tickslock);
80105c74:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105c7b:	e8 c0 ea ff ff       	call   80104740 <release>
80105c80:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105c83:	eb b6                	jmp    80105c3b <trap+0x10b>
    kbdintr();
80105c85:	e8 06 cc ff ff       	call   80102890 <kbdintr>
    lapiceoi();
80105c8a:	e8 41 cd ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c8f:	e8 dc dd ff ff       	call   80103a70 <myproc>
80105c94:	85 c0                	test   %eax,%eax
80105c96:	0f 85 37 ff ff ff    	jne    80105bd3 <trap+0xa3>
80105c9c:	e9 4f ff ff ff       	jmp    80105bf0 <trap+0xc0>
    uartintr();
80105ca1:	e8 4a 02 00 00       	call   80105ef0 <uartintr>
    lapiceoi();
80105ca6:	e8 25 cd ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cab:	e8 c0 dd ff ff       	call   80103a70 <myproc>
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	0f 85 1b ff ff ff    	jne    80105bd3 <trap+0xa3>
80105cb8:	e9 33 ff ff ff       	jmp    80105bf0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cbd:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cc0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cc4:	e8 87 dd ff ff       	call   80103a50 <cpuid>
80105cc9:	57                   	push   %edi
80105cca:	56                   	push   %esi
80105ccb:	50                   	push   %eax
80105ccc:	68 8c 7a 10 80       	push   $0x80107a8c
80105cd1:	e8 da a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105cd6:	e8 f5 cc ff ff       	call   801029d0 <lapiceoi>
    break;
80105cdb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cde:	e8 8d dd ff ff       	call   80103a70 <myproc>
80105ce3:	85 c0                	test   %eax,%eax
80105ce5:	0f 85 e8 fe ff ff    	jne    80105bd3 <trap+0xa3>
80105ceb:	e9 00 ff ff ff       	jmp    80105bf0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105cf0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105cf4:	0f 85 0e ff ff ff    	jne    80105c08 <trap+0xd8>
    yield();
80105cfa:	e8 f1 e2 ff ff       	call   80103ff0 <yield>
80105cff:	e9 04 ff ff ff       	jmp    80105c08 <trap+0xd8>
80105d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d08:	e8 63 dd ff ff       	call   80103a70 <myproc>
80105d0d:	8b 70 24             	mov    0x24(%eax),%esi
80105d10:	85 f6                	test   %esi,%esi
80105d12:	75 3c                	jne    80105d50 <trap+0x220>
    myproc()->tf = tf;
80105d14:	e8 57 dd ff ff       	call   80103a70 <myproc>
80105d19:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d1c:	e8 3f ee ff ff       	call   80104b60 <syscall>
    if(myproc()->killed)
80105d21:	e8 4a dd ff ff       	call   80103a70 <myproc>
80105d26:	8b 48 24             	mov    0x24(%eax),%ecx
80105d29:	85 c9                	test   %ecx,%ecx
80105d2b:	0f 84 fd fe ff ff    	je     80105c2e <trap+0xfe>
}
80105d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d34:	5b                   	pop    %ebx
80105d35:	5e                   	pop    %esi
80105d36:	5f                   	pop    %edi
80105d37:	5d                   	pop    %ebp
      exit();
80105d38:	e9 73 e1 ff ff       	jmp    80103eb0 <exit>
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105d40:	e8 6b e1 ff ff       	call   80103eb0 <exit>
80105d45:	e9 a6 fe ff ff       	jmp    80105bf0 <trap+0xc0>
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d50:	e8 5b e1 ff ff       	call   80103eb0 <exit>
80105d55:	eb bd                	jmp    80105d14 <trap+0x1e4>
80105d57:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d5a:	e8 f1 dc ff ff       	call   80103a50 <cpuid>
80105d5f:	83 ec 0c             	sub    $0xc,%esp
80105d62:	56                   	push   %esi
80105d63:	57                   	push   %edi
80105d64:	50                   	push   %eax
80105d65:	ff 73 30             	pushl  0x30(%ebx)
80105d68:	68 b0 7a 10 80       	push   $0x80107ab0
80105d6d:	e8 3e a9 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105d72:	83 c4 14             	add    $0x14,%esp
80105d75:	68 86 7a 10 80       	push   $0x80107a86
80105d7a:	e8 11 a6 ff ff       	call   80100390 <panic>
80105d7f:	90                   	nop

80105d80 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105d84:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105d89:	85 c0                	test   %eax,%eax
80105d8b:	74 1b                	je     80105da8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d8d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d92:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d93:	a8 01                	test   $0x1,%al
80105d95:	74 11                	je     80105da8 <uartgetc+0x28>
80105d97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d9c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d9d:	0f b6 c0             	movzbl %al,%eax
80105da0:	c3                   	ret    
80105da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dad:	c3                   	ret    
80105dae:	66 90                	xchg   %ax,%ax

80105db0 <uartputc.part.0>:
uartputc(int c)
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	57                   	push   %edi
80105db4:	89 c7                	mov    %eax,%edi
80105db6:	56                   	push   %esi
80105db7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105dbc:	53                   	push   %ebx
80105dbd:	bb 80 00 00 00       	mov    $0x80,%ebx
80105dc2:	83 ec 0c             	sub    $0xc,%esp
80105dc5:	eb 1b                	jmp    80105de2 <uartputc.part.0+0x32>
80105dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dce:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	6a 0a                	push   $0xa
80105dd5:	e8 16 cc ff ff       	call   801029f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dda:	83 c4 10             	add    $0x10,%esp
80105ddd:	83 eb 01             	sub    $0x1,%ebx
80105de0:	74 07                	je     80105de9 <uartputc.part.0+0x39>
80105de2:	89 f2                	mov    %esi,%edx
80105de4:	ec                   	in     (%dx),%al
80105de5:	a8 20                	test   $0x20,%al
80105de7:	74 e7                	je     80105dd0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105de9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dee:	89 f8                	mov    %edi,%eax
80105df0:	ee                   	out    %al,(%dx)
}
80105df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df4:	5b                   	pop    %ebx
80105df5:	5e                   	pop    %esi
80105df6:	5f                   	pop    %edi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e00 <uartinit>:
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	31 c9                	xor    %ecx,%ecx
80105e07:	89 c8                	mov    %ecx,%eax
80105e09:	89 e5                	mov    %esp,%ebp
80105e0b:	57                   	push   %edi
80105e0c:	56                   	push   %esi
80105e0d:	53                   	push   %ebx
80105e0e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105e13:	89 da                	mov    %ebx,%edx
80105e15:	83 ec 0c             	sub    $0xc,%esp
80105e18:	ee                   	out    %al,(%dx)
80105e19:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105e1e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e23:	89 fa                	mov    %edi,%edx
80105e25:	ee                   	out    %al,(%dx)
80105e26:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e2b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e30:	ee                   	out    %al,(%dx)
80105e31:	be f9 03 00 00       	mov    $0x3f9,%esi
80105e36:	89 c8                	mov    %ecx,%eax
80105e38:	89 f2                	mov    %esi,%edx
80105e3a:	ee                   	out    %al,(%dx)
80105e3b:	b8 03 00 00 00       	mov    $0x3,%eax
80105e40:	89 fa                	mov    %edi,%edx
80105e42:	ee                   	out    %al,(%dx)
80105e43:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e48:	89 c8                	mov    %ecx,%eax
80105e4a:	ee                   	out    %al,(%dx)
80105e4b:	b8 01 00 00 00       	mov    $0x1,%eax
80105e50:	89 f2                	mov    %esi,%edx
80105e52:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e53:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e58:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e59:	3c ff                	cmp    $0xff,%al
80105e5b:	74 52                	je     80105eaf <uartinit+0xaf>
  uart = 1;
80105e5d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105e64:	00 00 00 
80105e67:	89 da                	mov    %ebx,%edx
80105e69:	ec                   	in     (%dx),%al
80105e6a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e70:	83 ec 08             	sub    $0x8,%esp
80105e73:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105e78:	bb a8 7b 10 80       	mov    $0x80107ba8,%ebx
  ioapicenable(IRQ_COM1, 0);
80105e7d:	6a 00                	push   $0x0
80105e7f:	6a 04                	push   $0x4
80105e81:	e8 ba c6 ff ff       	call   80102540 <ioapicenable>
80105e86:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105e89:	b8 78 00 00 00       	mov    $0x78,%eax
80105e8e:	eb 04                	jmp    80105e94 <uartinit+0x94>
80105e90:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105e94:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105e9a:	85 d2                	test   %edx,%edx
80105e9c:	74 08                	je     80105ea6 <uartinit+0xa6>
    uartputc(*p);
80105e9e:	0f be c0             	movsbl %al,%eax
80105ea1:	e8 0a ff ff ff       	call   80105db0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105ea6:	89 f0                	mov    %esi,%eax
80105ea8:	83 c3 01             	add    $0x1,%ebx
80105eab:	84 c0                	test   %al,%al
80105ead:	75 e1                	jne    80105e90 <uartinit+0x90>
}
80105eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105eb2:	5b                   	pop    %ebx
80105eb3:	5e                   	pop    %esi
80105eb4:	5f                   	pop    %edi
80105eb5:	5d                   	pop    %ebp
80105eb6:	c3                   	ret    
80105eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <uartputc>:
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
  if(!uart)
80105ec5:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105ecb:	89 e5                	mov    %esp,%ebp
80105ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ed0:	85 d2                	test   %edx,%edx
80105ed2:	74 0c                	je     80105ee0 <uartputc+0x20>
}
80105ed4:	5d                   	pop    %ebp
80105ed5:	e9 d6 fe ff ff       	jmp    80105db0 <uartputc.part.0>
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ee0:	5d                   	pop    %ebp
80105ee1:	c3                   	ret    
80105ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <uartintr>:

void
uartintr(void)
{
80105ef0:	f3 0f 1e fb          	endbr32 
80105ef4:	55                   	push   %ebp
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105efa:	68 80 5d 10 80       	push   $0x80105d80
80105eff:	e8 5c a9 ff ff       	call   80100860 <consoleintr>
}
80105f04:	83 c4 10             	add    $0x10,%esp
80105f07:	c9                   	leave  
80105f08:	c3                   	ret    

80105f09 <vector0>:
80105f09:	6a 00                	push   $0x0
80105f0b:	6a 00                	push   $0x0
80105f0d:	e9 3c fb ff ff       	jmp    80105a4e <alltraps>

80105f12 <vector1>:
80105f12:	6a 00                	push   $0x0
80105f14:	6a 01                	push   $0x1
80105f16:	e9 33 fb ff ff       	jmp    80105a4e <alltraps>

80105f1b <vector2>:
80105f1b:	6a 00                	push   $0x0
80105f1d:	6a 02                	push   $0x2
80105f1f:	e9 2a fb ff ff       	jmp    80105a4e <alltraps>

80105f24 <vector3>:
80105f24:	6a 00                	push   $0x0
80105f26:	6a 03                	push   $0x3
80105f28:	e9 21 fb ff ff       	jmp    80105a4e <alltraps>

80105f2d <vector4>:
80105f2d:	6a 00                	push   $0x0
80105f2f:	6a 04                	push   $0x4
80105f31:	e9 18 fb ff ff       	jmp    80105a4e <alltraps>

80105f36 <vector5>:
80105f36:	6a 00                	push   $0x0
80105f38:	6a 05                	push   $0x5
80105f3a:	e9 0f fb ff ff       	jmp    80105a4e <alltraps>

80105f3f <vector6>:
80105f3f:	6a 00                	push   $0x0
80105f41:	6a 06                	push   $0x6
80105f43:	e9 06 fb ff ff       	jmp    80105a4e <alltraps>

80105f48 <vector7>:
80105f48:	6a 00                	push   $0x0
80105f4a:	6a 07                	push   $0x7
80105f4c:	e9 fd fa ff ff       	jmp    80105a4e <alltraps>

80105f51 <vector8>:
80105f51:	6a 08                	push   $0x8
80105f53:	e9 f6 fa ff ff       	jmp    80105a4e <alltraps>

80105f58 <vector9>:
80105f58:	6a 00                	push   $0x0
80105f5a:	6a 09                	push   $0x9
80105f5c:	e9 ed fa ff ff       	jmp    80105a4e <alltraps>

80105f61 <vector10>:
80105f61:	6a 0a                	push   $0xa
80105f63:	e9 e6 fa ff ff       	jmp    80105a4e <alltraps>

80105f68 <vector11>:
80105f68:	6a 0b                	push   $0xb
80105f6a:	e9 df fa ff ff       	jmp    80105a4e <alltraps>

80105f6f <vector12>:
80105f6f:	6a 0c                	push   $0xc
80105f71:	e9 d8 fa ff ff       	jmp    80105a4e <alltraps>

80105f76 <vector13>:
80105f76:	6a 0d                	push   $0xd
80105f78:	e9 d1 fa ff ff       	jmp    80105a4e <alltraps>

80105f7d <vector14>:
80105f7d:	6a 0e                	push   $0xe
80105f7f:	e9 ca fa ff ff       	jmp    80105a4e <alltraps>

80105f84 <vector15>:
80105f84:	6a 00                	push   $0x0
80105f86:	6a 0f                	push   $0xf
80105f88:	e9 c1 fa ff ff       	jmp    80105a4e <alltraps>

80105f8d <vector16>:
80105f8d:	6a 00                	push   $0x0
80105f8f:	6a 10                	push   $0x10
80105f91:	e9 b8 fa ff ff       	jmp    80105a4e <alltraps>

80105f96 <vector17>:
80105f96:	6a 11                	push   $0x11
80105f98:	e9 b1 fa ff ff       	jmp    80105a4e <alltraps>

80105f9d <vector18>:
80105f9d:	6a 00                	push   $0x0
80105f9f:	6a 12                	push   $0x12
80105fa1:	e9 a8 fa ff ff       	jmp    80105a4e <alltraps>

80105fa6 <vector19>:
80105fa6:	6a 00                	push   $0x0
80105fa8:	6a 13                	push   $0x13
80105faa:	e9 9f fa ff ff       	jmp    80105a4e <alltraps>

80105faf <vector20>:
80105faf:	6a 00                	push   $0x0
80105fb1:	6a 14                	push   $0x14
80105fb3:	e9 96 fa ff ff       	jmp    80105a4e <alltraps>

80105fb8 <vector21>:
80105fb8:	6a 00                	push   $0x0
80105fba:	6a 15                	push   $0x15
80105fbc:	e9 8d fa ff ff       	jmp    80105a4e <alltraps>

80105fc1 <vector22>:
80105fc1:	6a 00                	push   $0x0
80105fc3:	6a 16                	push   $0x16
80105fc5:	e9 84 fa ff ff       	jmp    80105a4e <alltraps>

80105fca <vector23>:
80105fca:	6a 00                	push   $0x0
80105fcc:	6a 17                	push   $0x17
80105fce:	e9 7b fa ff ff       	jmp    80105a4e <alltraps>

80105fd3 <vector24>:
80105fd3:	6a 00                	push   $0x0
80105fd5:	6a 18                	push   $0x18
80105fd7:	e9 72 fa ff ff       	jmp    80105a4e <alltraps>

80105fdc <vector25>:
80105fdc:	6a 00                	push   $0x0
80105fde:	6a 19                	push   $0x19
80105fe0:	e9 69 fa ff ff       	jmp    80105a4e <alltraps>

80105fe5 <vector26>:
80105fe5:	6a 00                	push   $0x0
80105fe7:	6a 1a                	push   $0x1a
80105fe9:	e9 60 fa ff ff       	jmp    80105a4e <alltraps>

80105fee <vector27>:
80105fee:	6a 00                	push   $0x0
80105ff0:	6a 1b                	push   $0x1b
80105ff2:	e9 57 fa ff ff       	jmp    80105a4e <alltraps>

80105ff7 <vector28>:
80105ff7:	6a 00                	push   $0x0
80105ff9:	6a 1c                	push   $0x1c
80105ffb:	e9 4e fa ff ff       	jmp    80105a4e <alltraps>

80106000 <vector29>:
80106000:	6a 00                	push   $0x0
80106002:	6a 1d                	push   $0x1d
80106004:	e9 45 fa ff ff       	jmp    80105a4e <alltraps>

80106009 <vector30>:
80106009:	6a 00                	push   $0x0
8010600b:	6a 1e                	push   $0x1e
8010600d:	e9 3c fa ff ff       	jmp    80105a4e <alltraps>

80106012 <vector31>:
80106012:	6a 00                	push   $0x0
80106014:	6a 1f                	push   $0x1f
80106016:	e9 33 fa ff ff       	jmp    80105a4e <alltraps>

8010601b <vector32>:
8010601b:	6a 00                	push   $0x0
8010601d:	6a 20                	push   $0x20
8010601f:	e9 2a fa ff ff       	jmp    80105a4e <alltraps>

80106024 <vector33>:
80106024:	6a 00                	push   $0x0
80106026:	6a 21                	push   $0x21
80106028:	e9 21 fa ff ff       	jmp    80105a4e <alltraps>

8010602d <vector34>:
8010602d:	6a 00                	push   $0x0
8010602f:	6a 22                	push   $0x22
80106031:	e9 18 fa ff ff       	jmp    80105a4e <alltraps>

80106036 <vector35>:
80106036:	6a 00                	push   $0x0
80106038:	6a 23                	push   $0x23
8010603a:	e9 0f fa ff ff       	jmp    80105a4e <alltraps>

8010603f <vector36>:
8010603f:	6a 00                	push   $0x0
80106041:	6a 24                	push   $0x24
80106043:	e9 06 fa ff ff       	jmp    80105a4e <alltraps>

80106048 <vector37>:
80106048:	6a 00                	push   $0x0
8010604a:	6a 25                	push   $0x25
8010604c:	e9 fd f9 ff ff       	jmp    80105a4e <alltraps>

80106051 <vector38>:
80106051:	6a 00                	push   $0x0
80106053:	6a 26                	push   $0x26
80106055:	e9 f4 f9 ff ff       	jmp    80105a4e <alltraps>

8010605a <vector39>:
8010605a:	6a 00                	push   $0x0
8010605c:	6a 27                	push   $0x27
8010605e:	e9 eb f9 ff ff       	jmp    80105a4e <alltraps>

80106063 <vector40>:
80106063:	6a 00                	push   $0x0
80106065:	6a 28                	push   $0x28
80106067:	e9 e2 f9 ff ff       	jmp    80105a4e <alltraps>

8010606c <vector41>:
8010606c:	6a 00                	push   $0x0
8010606e:	6a 29                	push   $0x29
80106070:	e9 d9 f9 ff ff       	jmp    80105a4e <alltraps>

80106075 <vector42>:
80106075:	6a 00                	push   $0x0
80106077:	6a 2a                	push   $0x2a
80106079:	e9 d0 f9 ff ff       	jmp    80105a4e <alltraps>

8010607e <vector43>:
8010607e:	6a 00                	push   $0x0
80106080:	6a 2b                	push   $0x2b
80106082:	e9 c7 f9 ff ff       	jmp    80105a4e <alltraps>

80106087 <vector44>:
80106087:	6a 00                	push   $0x0
80106089:	6a 2c                	push   $0x2c
8010608b:	e9 be f9 ff ff       	jmp    80105a4e <alltraps>

80106090 <vector45>:
80106090:	6a 00                	push   $0x0
80106092:	6a 2d                	push   $0x2d
80106094:	e9 b5 f9 ff ff       	jmp    80105a4e <alltraps>

80106099 <vector46>:
80106099:	6a 00                	push   $0x0
8010609b:	6a 2e                	push   $0x2e
8010609d:	e9 ac f9 ff ff       	jmp    80105a4e <alltraps>

801060a2 <vector47>:
801060a2:	6a 00                	push   $0x0
801060a4:	6a 2f                	push   $0x2f
801060a6:	e9 a3 f9 ff ff       	jmp    80105a4e <alltraps>

801060ab <vector48>:
801060ab:	6a 00                	push   $0x0
801060ad:	6a 30                	push   $0x30
801060af:	e9 9a f9 ff ff       	jmp    80105a4e <alltraps>

801060b4 <vector49>:
801060b4:	6a 00                	push   $0x0
801060b6:	6a 31                	push   $0x31
801060b8:	e9 91 f9 ff ff       	jmp    80105a4e <alltraps>

801060bd <vector50>:
801060bd:	6a 00                	push   $0x0
801060bf:	6a 32                	push   $0x32
801060c1:	e9 88 f9 ff ff       	jmp    80105a4e <alltraps>

801060c6 <vector51>:
801060c6:	6a 00                	push   $0x0
801060c8:	6a 33                	push   $0x33
801060ca:	e9 7f f9 ff ff       	jmp    80105a4e <alltraps>

801060cf <vector52>:
801060cf:	6a 00                	push   $0x0
801060d1:	6a 34                	push   $0x34
801060d3:	e9 76 f9 ff ff       	jmp    80105a4e <alltraps>

801060d8 <vector53>:
801060d8:	6a 00                	push   $0x0
801060da:	6a 35                	push   $0x35
801060dc:	e9 6d f9 ff ff       	jmp    80105a4e <alltraps>

801060e1 <vector54>:
801060e1:	6a 00                	push   $0x0
801060e3:	6a 36                	push   $0x36
801060e5:	e9 64 f9 ff ff       	jmp    80105a4e <alltraps>

801060ea <vector55>:
801060ea:	6a 00                	push   $0x0
801060ec:	6a 37                	push   $0x37
801060ee:	e9 5b f9 ff ff       	jmp    80105a4e <alltraps>

801060f3 <vector56>:
801060f3:	6a 00                	push   $0x0
801060f5:	6a 38                	push   $0x38
801060f7:	e9 52 f9 ff ff       	jmp    80105a4e <alltraps>

801060fc <vector57>:
801060fc:	6a 00                	push   $0x0
801060fe:	6a 39                	push   $0x39
80106100:	e9 49 f9 ff ff       	jmp    80105a4e <alltraps>

80106105 <vector58>:
80106105:	6a 00                	push   $0x0
80106107:	6a 3a                	push   $0x3a
80106109:	e9 40 f9 ff ff       	jmp    80105a4e <alltraps>

8010610e <vector59>:
8010610e:	6a 00                	push   $0x0
80106110:	6a 3b                	push   $0x3b
80106112:	e9 37 f9 ff ff       	jmp    80105a4e <alltraps>

80106117 <vector60>:
80106117:	6a 00                	push   $0x0
80106119:	6a 3c                	push   $0x3c
8010611b:	e9 2e f9 ff ff       	jmp    80105a4e <alltraps>

80106120 <vector61>:
80106120:	6a 00                	push   $0x0
80106122:	6a 3d                	push   $0x3d
80106124:	e9 25 f9 ff ff       	jmp    80105a4e <alltraps>

80106129 <vector62>:
80106129:	6a 00                	push   $0x0
8010612b:	6a 3e                	push   $0x3e
8010612d:	e9 1c f9 ff ff       	jmp    80105a4e <alltraps>

80106132 <vector63>:
80106132:	6a 00                	push   $0x0
80106134:	6a 3f                	push   $0x3f
80106136:	e9 13 f9 ff ff       	jmp    80105a4e <alltraps>

8010613b <vector64>:
8010613b:	6a 00                	push   $0x0
8010613d:	6a 40                	push   $0x40
8010613f:	e9 0a f9 ff ff       	jmp    80105a4e <alltraps>

80106144 <vector65>:
80106144:	6a 00                	push   $0x0
80106146:	6a 41                	push   $0x41
80106148:	e9 01 f9 ff ff       	jmp    80105a4e <alltraps>

8010614d <vector66>:
8010614d:	6a 00                	push   $0x0
8010614f:	6a 42                	push   $0x42
80106151:	e9 f8 f8 ff ff       	jmp    80105a4e <alltraps>

80106156 <vector67>:
80106156:	6a 00                	push   $0x0
80106158:	6a 43                	push   $0x43
8010615a:	e9 ef f8 ff ff       	jmp    80105a4e <alltraps>

8010615f <vector68>:
8010615f:	6a 00                	push   $0x0
80106161:	6a 44                	push   $0x44
80106163:	e9 e6 f8 ff ff       	jmp    80105a4e <alltraps>

80106168 <vector69>:
80106168:	6a 00                	push   $0x0
8010616a:	6a 45                	push   $0x45
8010616c:	e9 dd f8 ff ff       	jmp    80105a4e <alltraps>

80106171 <vector70>:
80106171:	6a 00                	push   $0x0
80106173:	6a 46                	push   $0x46
80106175:	e9 d4 f8 ff ff       	jmp    80105a4e <alltraps>

8010617a <vector71>:
8010617a:	6a 00                	push   $0x0
8010617c:	6a 47                	push   $0x47
8010617e:	e9 cb f8 ff ff       	jmp    80105a4e <alltraps>

80106183 <vector72>:
80106183:	6a 00                	push   $0x0
80106185:	6a 48                	push   $0x48
80106187:	e9 c2 f8 ff ff       	jmp    80105a4e <alltraps>

8010618c <vector73>:
8010618c:	6a 00                	push   $0x0
8010618e:	6a 49                	push   $0x49
80106190:	e9 b9 f8 ff ff       	jmp    80105a4e <alltraps>

80106195 <vector74>:
80106195:	6a 00                	push   $0x0
80106197:	6a 4a                	push   $0x4a
80106199:	e9 b0 f8 ff ff       	jmp    80105a4e <alltraps>

8010619e <vector75>:
8010619e:	6a 00                	push   $0x0
801061a0:	6a 4b                	push   $0x4b
801061a2:	e9 a7 f8 ff ff       	jmp    80105a4e <alltraps>

801061a7 <vector76>:
801061a7:	6a 00                	push   $0x0
801061a9:	6a 4c                	push   $0x4c
801061ab:	e9 9e f8 ff ff       	jmp    80105a4e <alltraps>

801061b0 <vector77>:
801061b0:	6a 00                	push   $0x0
801061b2:	6a 4d                	push   $0x4d
801061b4:	e9 95 f8 ff ff       	jmp    80105a4e <alltraps>

801061b9 <vector78>:
801061b9:	6a 00                	push   $0x0
801061bb:	6a 4e                	push   $0x4e
801061bd:	e9 8c f8 ff ff       	jmp    80105a4e <alltraps>

801061c2 <vector79>:
801061c2:	6a 00                	push   $0x0
801061c4:	6a 4f                	push   $0x4f
801061c6:	e9 83 f8 ff ff       	jmp    80105a4e <alltraps>

801061cb <vector80>:
801061cb:	6a 00                	push   $0x0
801061cd:	6a 50                	push   $0x50
801061cf:	e9 7a f8 ff ff       	jmp    80105a4e <alltraps>

801061d4 <vector81>:
801061d4:	6a 00                	push   $0x0
801061d6:	6a 51                	push   $0x51
801061d8:	e9 71 f8 ff ff       	jmp    80105a4e <alltraps>

801061dd <vector82>:
801061dd:	6a 00                	push   $0x0
801061df:	6a 52                	push   $0x52
801061e1:	e9 68 f8 ff ff       	jmp    80105a4e <alltraps>

801061e6 <vector83>:
801061e6:	6a 00                	push   $0x0
801061e8:	6a 53                	push   $0x53
801061ea:	e9 5f f8 ff ff       	jmp    80105a4e <alltraps>

801061ef <vector84>:
801061ef:	6a 00                	push   $0x0
801061f1:	6a 54                	push   $0x54
801061f3:	e9 56 f8 ff ff       	jmp    80105a4e <alltraps>

801061f8 <vector85>:
801061f8:	6a 00                	push   $0x0
801061fa:	6a 55                	push   $0x55
801061fc:	e9 4d f8 ff ff       	jmp    80105a4e <alltraps>

80106201 <vector86>:
80106201:	6a 00                	push   $0x0
80106203:	6a 56                	push   $0x56
80106205:	e9 44 f8 ff ff       	jmp    80105a4e <alltraps>

8010620a <vector87>:
8010620a:	6a 00                	push   $0x0
8010620c:	6a 57                	push   $0x57
8010620e:	e9 3b f8 ff ff       	jmp    80105a4e <alltraps>

80106213 <vector88>:
80106213:	6a 00                	push   $0x0
80106215:	6a 58                	push   $0x58
80106217:	e9 32 f8 ff ff       	jmp    80105a4e <alltraps>

8010621c <vector89>:
8010621c:	6a 00                	push   $0x0
8010621e:	6a 59                	push   $0x59
80106220:	e9 29 f8 ff ff       	jmp    80105a4e <alltraps>

80106225 <vector90>:
80106225:	6a 00                	push   $0x0
80106227:	6a 5a                	push   $0x5a
80106229:	e9 20 f8 ff ff       	jmp    80105a4e <alltraps>

8010622e <vector91>:
8010622e:	6a 00                	push   $0x0
80106230:	6a 5b                	push   $0x5b
80106232:	e9 17 f8 ff ff       	jmp    80105a4e <alltraps>

80106237 <vector92>:
80106237:	6a 00                	push   $0x0
80106239:	6a 5c                	push   $0x5c
8010623b:	e9 0e f8 ff ff       	jmp    80105a4e <alltraps>

80106240 <vector93>:
80106240:	6a 00                	push   $0x0
80106242:	6a 5d                	push   $0x5d
80106244:	e9 05 f8 ff ff       	jmp    80105a4e <alltraps>

80106249 <vector94>:
80106249:	6a 00                	push   $0x0
8010624b:	6a 5e                	push   $0x5e
8010624d:	e9 fc f7 ff ff       	jmp    80105a4e <alltraps>

80106252 <vector95>:
80106252:	6a 00                	push   $0x0
80106254:	6a 5f                	push   $0x5f
80106256:	e9 f3 f7 ff ff       	jmp    80105a4e <alltraps>

8010625b <vector96>:
8010625b:	6a 00                	push   $0x0
8010625d:	6a 60                	push   $0x60
8010625f:	e9 ea f7 ff ff       	jmp    80105a4e <alltraps>

80106264 <vector97>:
80106264:	6a 00                	push   $0x0
80106266:	6a 61                	push   $0x61
80106268:	e9 e1 f7 ff ff       	jmp    80105a4e <alltraps>

8010626d <vector98>:
8010626d:	6a 00                	push   $0x0
8010626f:	6a 62                	push   $0x62
80106271:	e9 d8 f7 ff ff       	jmp    80105a4e <alltraps>

80106276 <vector99>:
80106276:	6a 00                	push   $0x0
80106278:	6a 63                	push   $0x63
8010627a:	e9 cf f7 ff ff       	jmp    80105a4e <alltraps>

8010627f <vector100>:
8010627f:	6a 00                	push   $0x0
80106281:	6a 64                	push   $0x64
80106283:	e9 c6 f7 ff ff       	jmp    80105a4e <alltraps>

80106288 <vector101>:
80106288:	6a 00                	push   $0x0
8010628a:	6a 65                	push   $0x65
8010628c:	e9 bd f7 ff ff       	jmp    80105a4e <alltraps>

80106291 <vector102>:
80106291:	6a 00                	push   $0x0
80106293:	6a 66                	push   $0x66
80106295:	e9 b4 f7 ff ff       	jmp    80105a4e <alltraps>

8010629a <vector103>:
8010629a:	6a 00                	push   $0x0
8010629c:	6a 67                	push   $0x67
8010629e:	e9 ab f7 ff ff       	jmp    80105a4e <alltraps>

801062a3 <vector104>:
801062a3:	6a 00                	push   $0x0
801062a5:	6a 68                	push   $0x68
801062a7:	e9 a2 f7 ff ff       	jmp    80105a4e <alltraps>

801062ac <vector105>:
801062ac:	6a 00                	push   $0x0
801062ae:	6a 69                	push   $0x69
801062b0:	e9 99 f7 ff ff       	jmp    80105a4e <alltraps>

801062b5 <vector106>:
801062b5:	6a 00                	push   $0x0
801062b7:	6a 6a                	push   $0x6a
801062b9:	e9 90 f7 ff ff       	jmp    80105a4e <alltraps>

801062be <vector107>:
801062be:	6a 00                	push   $0x0
801062c0:	6a 6b                	push   $0x6b
801062c2:	e9 87 f7 ff ff       	jmp    80105a4e <alltraps>

801062c7 <vector108>:
801062c7:	6a 00                	push   $0x0
801062c9:	6a 6c                	push   $0x6c
801062cb:	e9 7e f7 ff ff       	jmp    80105a4e <alltraps>

801062d0 <vector109>:
801062d0:	6a 00                	push   $0x0
801062d2:	6a 6d                	push   $0x6d
801062d4:	e9 75 f7 ff ff       	jmp    80105a4e <alltraps>

801062d9 <vector110>:
801062d9:	6a 00                	push   $0x0
801062db:	6a 6e                	push   $0x6e
801062dd:	e9 6c f7 ff ff       	jmp    80105a4e <alltraps>

801062e2 <vector111>:
801062e2:	6a 00                	push   $0x0
801062e4:	6a 6f                	push   $0x6f
801062e6:	e9 63 f7 ff ff       	jmp    80105a4e <alltraps>

801062eb <vector112>:
801062eb:	6a 00                	push   $0x0
801062ed:	6a 70                	push   $0x70
801062ef:	e9 5a f7 ff ff       	jmp    80105a4e <alltraps>

801062f4 <vector113>:
801062f4:	6a 00                	push   $0x0
801062f6:	6a 71                	push   $0x71
801062f8:	e9 51 f7 ff ff       	jmp    80105a4e <alltraps>

801062fd <vector114>:
801062fd:	6a 00                	push   $0x0
801062ff:	6a 72                	push   $0x72
80106301:	e9 48 f7 ff ff       	jmp    80105a4e <alltraps>

80106306 <vector115>:
80106306:	6a 00                	push   $0x0
80106308:	6a 73                	push   $0x73
8010630a:	e9 3f f7 ff ff       	jmp    80105a4e <alltraps>

8010630f <vector116>:
8010630f:	6a 00                	push   $0x0
80106311:	6a 74                	push   $0x74
80106313:	e9 36 f7 ff ff       	jmp    80105a4e <alltraps>

80106318 <vector117>:
80106318:	6a 00                	push   $0x0
8010631a:	6a 75                	push   $0x75
8010631c:	e9 2d f7 ff ff       	jmp    80105a4e <alltraps>

80106321 <vector118>:
80106321:	6a 00                	push   $0x0
80106323:	6a 76                	push   $0x76
80106325:	e9 24 f7 ff ff       	jmp    80105a4e <alltraps>

8010632a <vector119>:
8010632a:	6a 00                	push   $0x0
8010632c:	6a 77                	push   $0x77
8010632e:	e9 1b f7 ff ff       	jmp    80105a4e <alltraps>

80106333 <vector120>:
80106333:	6a 00                	push   $0x0
80106335:	6a 78                	push   $0x78
80106337:	e9 12 f7 ff ff       	jmp    80105a4e <alltraps>

8010633c <vector121>:
8010633c:	6a 00                	push   $0x0
8010633e:	6a 79                	push   $0x79
80106340:	e9 09 f7 ff ff       	jmp    80105a4e <alltraps>

80106345 <vector122>:
80106345:	6a 00                	push   $0x0
80106347:	6a 7a                	push   $0x7a
80106349:	e9 00 f7 ff ff       	jmp    80105a4e <alltraps>

8010634e <vector123>:
8010634e:	6a 00                	push   $0x0
80106350:	6a 7b                	push   $0x7b
80106352:	e9 f7 f6 ff ff       	jmp    80105a4e <alltraps>

80106357 <vector124>:
80106357:	6a 00                	push   $0x0
80106359:	6a 7c                	push   $0x7c
8010635b:	e9 ee f6 ff ff       	jmp    80105a4e <alltraps>

80106360 <vector125>:
80106360:	6a 00                	push   $0x0
80106362:	6a 7d                	push   $0x7d
80106364:	e9 e5 f6 ff ff       	jmp    80105a4e <alltraps>

80106369 <vector126>:
80106369:	6a 00                	push   $0x0
8010636b:	6a 7e                	push   $0x7e
8010636d:	e9 dc f6 ff ff       	jmp    80105a4e <alltraps>

80106372 <vector127>:
80106372:	6a 00                	push   $0x0
80106374:	6a 7f                	push   $0x7f
80106376:	e9 d3 f6 ff ff       	jmp    80105a4e <alltraps>

8010637b <vector128>:
8010637b:	6a 00                	push   $0x0
8010637d:	68 80 00 00 00       	push   $0x80
80106382:	e9 c7 f6 ff ff       	jmp    80105a4e <alltraps>

80106387 <vector129>:
80106387:	6a 00                	push   $0x0
80106389:	68 81 00 00 00       	push   $0x81
8010638e:	e9 bb f6 ff ff       	jmp    80105a4e <alltraps>

80106393 <vector130>:
80106393:	6a 00                	push   $0x0
80106395:	68 82 00 00 00       	push   $0x82
8010639a:	e9 af f6 ff ff       	jmp    80105a4e <alltraps>

8010639f <vector131>:
8010639f:	6a 00                	push   $0x0
801063a1:	68 83 00 00 00       	push   $0x83
801063a6:	e9 a3 f6 ff ff       	jmp    80105a4e <alltraps>

801063ab <vector132>:
801063ab:	6a 00                	push   $0x0
801063ad:	68 84 00 00 00       	push   $0x84
801063b2:	e9 97 f6 ff ff       	jmp    80105a4e <alltraps>

801063b7 <vector133>:
801063b7:	6a 00                	push   $0x0
801063b9:	68 85 00 00 00       	push   $0x85
801063be:	e9 8b f6 ff ff       	jmp    80105a4e <alltraps>

801063c3 <vector134>:
801063c3:	6a 00                	push   $0x0
801063c5:	68 86 00 00 00       	push   $0x86
801063ca:	e9 7f f6 ff ff       	jmp    80105a4e <alltraps>

801063cf <vector135>:
801063cf:	6a 00                	push   $0x0
801063d1:	68 87 00 00 00       	push   $0x87
801063d6:	e9 73 f6 ff ff       	jmp    80105a4e <alltraps>

801063db <vector136>:
801063db:	6a 00                	push   $0x0
801063dd:	68 88 00 00 00       	push   $0x88
801063e2:	e9 67 f6 ff ff       	jmp    80105a4e <alltraps>

801063e7 <vector137>:
801063e7:	6a 00                	push   $0x0
801063e9:	68 89 00 00 00       	push   $0x89
801063ee:	e9 5b f6 ff ff       	jmp    80105a4e <alltraps>

801063f3 <vector138>:
801063f3:	6a 00                	push   $0x0
801063f5:	68 8a 00 00 00       	push   $0x8a
801063fa:	e9 4f f6 ff ff       	jmp    80105a4e <alltraps>

801063ff <vector139>:
801063ff:	6a 00                	push   $0x0
80106401:	68 8b 00 00 00       	push   $0x8b
80106406:	e9 43 f6 ff ff       	jmp    80105a4e <alltraps>

8010640b <vector140>:
8010640b:	6a 00                	push   $0x0
8010640d:	68 8c 00 00 00       	push   $0x8c
80106412:	e9 37 f6 ff ff       	jmp    80105a4e <alltraps>

80106417 <vector141>:
80106417:	6a 00                	push   $0x0
80106419:	68 8d 00 00 00       	push   $0x8d
8010641e:	e9 2b f6 ff ff       	jmp    80105a4e <alltraps>

80106423 <vector142>:
80106423:	6a 00                	push   $0x0
80106425:	68 8e 00 00 00       	push   $0x8e
8010642a:	e9 1f f6 ff ff       	jmp    80105a4e <alltraps>

8010642f <vector143>:
8010642f:	6a 00                	push   $0x0
80106431:	68 8f 00 00 00       	push   $0x8f
80106436:	e9 13 f6 ff ff       	jmp    80105a4e <alltraps>

8010643b <vector144>:
8010643b:	6a 00                	push   $0x0
8010643d:	68 90 00 00 00       	push   $0x90
80106442:	e9 07 f6 ff ff       	jmp    80105a4e <alltraps>

80106447 <vector145>:
80106447:	6a 00                	push   $0x0
80106449:	68 91 00 00 00       	push   $0x91
8010644e:	e9 fb f5 ff ff       	jmp    80105a4e <alltraps>

80106453 <vector146>:
80106453:	6a 00                	push   $0x0
80106455:	68 92 00 00 00       	push   $0x92
8010645a:	e9 ef f5 ff ff       	jmp    80105a4e <alltraps>

8010645f <vector147>:
8010645f:	6a 00                	push   $0x0
80106461:	68 93 00 00 00       	push   $0x93
80106466:	e9 e3 f5 ff ff       	jmp    80105a4e <alltraps>

8010646b <vector148>:
8010646b:	6a 00                	push   $0x0
8010646d:	68 94 00 00 00       	push   $0x94
80106472:	e9 d7 f5 ff ff       	jmp    80105a4e <alltraps>

80106477 <vector149>:
80106477:	6a 00                	push   $0x0
80106479:	68 95 00 00 00       	push   $0x95
8010647e:	e9 cb f5 ff ff       	jmp    80105a4e <alltraps>

80106483 <vector150>:
80106483:	6a 00                	push   $0x0
80106485:	68 96 00 00 00       	push   $0x96
8010648a:	e9 bf f5 ff ff       	jmp    80105a4e <alltraps>

8010648f <vector151>:
8010648f:	6a 00                	push   $0x0
80106491:	68 97 00 00 00       	push   $0x97
80106496:	e9 b3 f5 ff ff       	jmp    80105a4e <alltraps>

8010649b <vector152>:
8010649b:	6a 00                	push   $0x0
8010649d:	68 98 00 00 00       	push   $0x98
801064a2:	e9 a7 f5 ff ff       	jmp    80105a4e <alltraps>

801064a7 <vector153>:
801064a7:	6a 00                	push   $0x0
801064a9:	68 99 00 00 00       	push   $0x99
801064ae:	e9 9b f5 ff ff       	jmp    80105a4e <alltraps>

801064b3 <vector154>:
801064b3:	6a 00                	push   $0x0
801064b5:	68 9a 00 00 00       	push   $0x9a
801064ba:	e9 8f f5 ff ff       	jmp    80105a4e <alltraps>

801064bf <vector155>:
801064bf:	6a 00                	push   $0x0
801064c1:	68 9b 00 00 00       	push   $0x9b
801064c6:	e9 83 f5 ff ff       	jmp    80105a4e <alltraps>

801064cb <vector156>:
801064cb:	6a 00                	push   $0x0
801064cd:	68 9c 00 00 00       	push   $0x9c
801064d2:	e9 77 f5 ff ff       	jmp    80105a4e <alltraps>

801064d7 <vector157>:
801064d7:	6a 00                	push   $0x0
801064d9:	68 9d 00 00 00       	push   $0x9d
801064de:	e9 6b f5 ff ff       	jmp    80105a4e <alltraps>

801064e3 <vector158>:
801064e3:	6a 00                	push   $0x0
801064e5:	68 9e 00 00 00       	push   $0x9e
801064ea:	e9 5f f5 ff ff       	jmp    80105a4e <alltraps>

801064ef <vector159>:
801064ef:	6a 00                	push   $0x0
801064f1:	68 9f 00 00 00       	push   $0x9f
801064f6:	e9 53 f5 ff ff       	jmp    80105a4e <alltraps>

801064fb <vector160>:
801064fb:	6a 00                	push   $0x0
801064fd:	68 a0 00 00 00       	push   $0xa0
80106502:	e9 47 f5 ff ff       	jmp    80105a4e <alltraps>

80106507 <vector161>:
80106507:	6a 00                	push   $0x0
80106509:	68 a1 00 00 00       	push   $0xa1
8010650e:	e9 3b f5 ff ff       	jmp    80105a4e <alltraps>

80106513 <vector162>:
80106513:	6a 00                	push   $0x0
80106515:	68 a2 00 00 00       	push   $0xa2
8010651a:	e9 2f f5 ff ff       	jmp    80105a4e <alltraps>

8010651f <vector163>:
8010651f:	6a 00                	push   $0x0
80106521:	68 a3 00 00 00       	push   $0xa3
80106526:	e9 23 f5 ff ff       	jmp    80105a4e <alltraps>

8010652b <vector164>:
8010652b:	6a 00                	push   $0x0
8010652d:	68 a4 00 00 00       	push   $0xa4
80106532:	e9 17 f5 ff ff       	jmp    80105a4e <alltraps>

80106537 <vector165>:
80106537:	6a 00                	push   $0x0
80106539:	68 a5 00 00 00       	push   $0xa5
8010653e:	e9 0b f5 ff ff       	jmp    80105a4e <alltraps>

80106543 <vector166>:
80106543:	6a 00                	push   $0x0
80106545:	68 a6 00 00 00       	push   $0xa6
8010654a:	e9 ff f4 ff ff       	jmp    80105a4e <alltraps>

8010654f <vector167>:
8010654f:	6a 00                	push   $0x0
80106551:	68 a7 00 00 00       	push   $0xa7
80106556:	e9 f3 f4 ff ff       	jmp    80105a4e <alltraps>

8010655b <vector168>:
8010655b:	6a 00                	push   $0x0
8010655d:	68 a8 00 00 00       	push   $0xa8
80106562:	e9 e7 f4 ff ff       	jmp    80105a4e <alltraps>

80106567 <vector169>:
80106567:	6a 00                	push   $0x0
80106569:	68 a9 00 00 00       	push   $0xa9
8010656e:	e9 db f4 ff ff       	jmp    80105a4e <alltraps>

80106573 <vector170>:
80106573:	6a 00                	push   $0x0
80106575:	68 aa 00 00 00       	push   $0xaa
8010657a:	e9 cf f4 ff ff       	jmp    80105a4e <alltraps>

8010657f <vector171>:
8010657f:	6a 00                	push   $0x0
80106581:	68 ab 00 00 00       	push   $0xab
80106586:	e9 c3 f4 ff ff       	jmp    80105a4e <alltraps>

8010658b <vector172>:
8010658b:	6a 00                	push   $0x0
8010658d:	68 ac 00 00 00       	push   $0xac
80106592:	e9 b7 f4 ff ff       	jmp    80105a4e <alltraps>

80106597 <vector173>:
80106597:	6a 00                	push   $0x0
80106599:	68 ad 00 00 00       	push   $0xad
8010659e:	e9 ab f4 ff ff       	jmp    80105a4e <alltraps>

801065a3 <vector174>:
801065a3:	6a 00                	push   $0x0
801065a5:	68 ae 00 00 00       	push   $0xae
801065aa:	e9 9f f4 ff ff       	jmp    80105a4e <alltraps>

801065af <vector175>:
801065af:	6a 00                	push   $0x0
801065b1:	68 af 00 00 00       	push   $0xaf
801065b6:	e9 93 f4 ff ff       	jmp    80105a4e <alltraps>

801065bb <vector176>:
801065bb:	6a 00                	push   $0x0
801065bd:	68 b0 00 00 00       	push   $0xb0
801065c2:	e9 87 f4 ff ff       	jmp    80105a4e <alltraps>

801065c7 <vector177>:
801065c7:	6a 00                	push   $0x0
801065c9:	68 b1 00 00 00       	push   $0xb1
801065ce:	e9 7b f4 ff ff       	jmp    80105a4e <alltraps>

801065d3 <vector178>:
801065d3:	6a 00                	push   $0x0
801065d5:	68 b2 00 00 00       	push   $0xb2
801065da:	e9 6f f4 ff ff       	jmp    80105a4e <alltraps>

801065df <vector179>:
801065df:	6a 00                	push   $0x0
801065e1:	68 b3 00 00 00       	push   $0xb3
801065e6:	e9 63 f4 ff ff       	jmp    80105a4e <alltraps>

801065eb <vector180>:
801065eb:	6a 00                	push   $0x0
801065ed:	68 b4 00 00 00       	push   $0xb4
801065f2:	e9 57 f4 ff ff       	jmp    80105a4e <alltraps>

801065f7 <vector181>:
801065f7:	6a 00                	push   $0x0
801065f9:	68 b5 00 00 00       	push   $0xb5
801065fe:	e9 4b f4 ff ff       	jmp    80105a4e <alltraps>

80106603 <vector182>:
80106603:	6a 00                	push   $0x0
80106605:	68 b6 00 00 00       	push   $0xb6
8010660a:	e9 3f f4 ff ff       	jmp    80105a4e <alltraps>

8010660f <vector183>:
8010660f:	6a 00                	push   $0x0
80106611:	68 b7 00 00 00       	push   $0xb7
80106616:	e9 33 f4 ff ff       	jmp    80105a4e <alltraps>

8010661b <vector184>:
8010661b:	6a 00                	push   $0x0
8010661d:	68 b8 00 00 00       	push   $0xb8
80106622:	e9 27 f4 ff ff       	jmp    80105a4e <alltraps>

80106627 <vector185>:
80106627:	6a 00                	push   $0x0
80106629:	68 b9 00 00 00       	push   $0xb9
8010662e:	e9 1b f4 ff ff       	jmp    80105a4e <alltraps>

80106633 <vector186>:
80106633:	6a 00                	push   $0x0
80106635:	68 ba 00 00 00       	push   $0xba
8010663a:	e9 0f f4 ff ff       	jmp    80105a4e <alltraps>

8010663f <vector187>:
8010663f:	6a 00                	push   $0x0
80106641:	68 bb 00 00 00       	push   $0xbb
80106646:	e9 03 f4 ff ff       	jmp    80105a4e <alltraps>

8010664b <vector188>:
8010664b:	6a 00                	push   $0x0
8010664d:	68 bc 00 00 00       	push   $0xbc
80106652:	e9 f7 f3 ff ff       	jmp    80105a4e <alltraps>

80106657 <vector189>:
80106657:	6a 00                	push   $0x0
80106659:	68 bd 00 00 00       	push   $0xbd
8010665e:	e9 eb f3 ff ff       	jmp    80105a4e <alltraps>

80106663 <vector190>:
80106663:	6a 00                	push   $0x0
80106665:	68 be 00 00 00       	push   $0xbe
8010666a:	e9 df f3 ff ff       	jmp    80105a4e <alltraps>

8010666f <vector191>:
8010666f:	6a 00                	push   $0x0
80106671:	68 bf 00 00 00       	push   $0xbf
80106676:	e9 d3 f3 ff ff       	jmp    80105a4e <alltraps>

8010667b <vector192>:
8010667b:	6a 00                	push   $0x0
8010667d:	68 c0 00 00 00       	push   $0xc0
80106682:	e9 c7 f3 ff ff       	jmp    80105a4e <alltraps>

80106687 <vector193>:
80106687:	6a 00                	push   $0x0
80106689:	68 c1 00 00 00       	push   $0xc1
8010668e:	e9 bb f3 ff ff       	jmp    80105a4e <alltraps>

80106693 <vector194>:
80106693:	6a 00                	push   $0x0
80106695:	68 c2 00 00 00       	push   $0xc2
8010669a:	e9 af f3 ff ff       	jmp    80105a4e <alltraps>

8010669f <vector195>:
8010669f:	6a 00                	push   $0x0
801066a1:	68 c3 00 00 00       	push   $0xc3
801066a6:	e9 a3 f3 ff ff       	jmp    80105a4e <alltraps>

801066ab <vector196>:
801066ab:	6a 00                	push   $0x0
801066ad:	68 c4 00 00 00       	push   $0xc4
801066b2:	e9 97 f3 ff ff       	jmp    80105a4e <alltraps>

801066b7 <vector197>:
801066b7:	6a 00                	push   $0x0
801066b9:	68 c5 00 00 00       	push   $0xc5
801066be:	e9 8b f3 ff ff       	jmp    80105a4e <alltraps>

801066c3 <vector198>:
801066c3:	6a 00                	push   $0x0
801066c5:	68 c6 00 00 00       	push   $0xc6
801066ca:	e9 7f f3 ff ff       	jmp    80105a4e <alltraps>

801066cf <vector199>:
801066cf:	6a 00                	push   $0x0
801066d1:	68 c7 00 00 00       	push   $0xc7
801066d6:	e9 73 f3 ff ff       	jmp    80105a4e <alltraps>

801066db <vector200>:
801066db:	6a 00                	push   $0x0
801066dd:	68 c8 00 00 00       	push   $0xc8
801066e2:	e9 67 f3 ff ff       	jmp    80105a4e <alltraps>

801066e7 <vector201>:
801066e7:	6a 00                	push   $0x0
801066e9:	68 c9 00 00 00       	push   $0xc9
801066ee:	e9 5b f3 ff ff       	jmp    80105a4e <alltraps>

801066f3 <vector202>:
801066f3:	6a 00                	push   $0x0
801066f5:	68 ca 00 00 00       	push   $0xca
801066fa:	e9 4f f3 ff ff       	jmp    80105a4e <alltraps>

801066ff <vector203>:
801066ff:	6a 00                	push   $0x0
80106701:	68 cb 00 00 00       	push   $0xcb
80106706:	e9 43 f3 ff ff       	jmp    80105a4e <alltraps>

8010670b <vector204>:
8010670b:	6a 00                	push   $0x0
8010670d:	68 cc 00 00 00       	push   $0xcc
80106712:	e9 37 f3 ff ff       	jmp    80105a4e <alltraps>

80106717 <vector205>:
80106717:	6a 00                	push   $0x0
80106719:	68 cd 00 00 00       	push   $0xcd
8010671e:	e9 2b f3 ff ff       	jmp    80105a4e <alltraps>

80106723 <vector206>:
80106723:	6a 00                	push   $0x0
80106725:	68 ce 00 00 00       	push   $0xce
8010672a:	e9 1f f3 ff ff       	jmp    80105a4e <alltraps>

8010672f <vector207>:
8010672f:	6a 00                	push   $0x0
80106731:	68 cf 00 00 00       	push   $0xcf
80106736:	e9 13 f3 ff ff       	jmp    80105a4e <alltraps>

8010673b <vector208>:
8010673b:	6a 00                	push   $0x0
8010673d:	68 d0 00 00 00       	push   $0xd0
80106742:	e9 07 f3 ff ff       	jmp    80105a4e <alltraps>

80106747 <vector209>:
80106747:	6a 00                	push   $0x0
80106749:	68 d1 00 00 00       	push   $0xd1
8010674e:	e9 fb f2 ff ff       	jmp    80105a4e <alltraps>

80106753 <vector210>:
80106753:	6a 00                	push   $0x0
80106755:	68 d2 00 00 00       	push   $0xd2
8010675a:	e9 ef f2 ff ff       	jmp    80105a4e <alltraps>

8010675f <vector211>:
8010675f:	6a 00                	push   $0x0
80106761:	68 d3 00 00 00       	push   $0xd3
80106766:	e9 e3 f2 ff ff       	jmp    80105a4e <alltraps>

8010676b <vector212>:
8010676b:	6a 00                	push   $0x0
8010676d:	68 d4 00 00 00       	push   $0xd4
80106772:	e9 d7 f2 ff ff       	jmp    80105a4e <alltraps>

80106777 <vector213>:
80106777:	6a 00                	push   $0x0
80106779:	68 d5 00 00 00       	push   $0xd5
8010677e:	e9 cb f2 ff ff       	jmp    80105a4e <alltraps>

80106783 <vector214>:
80106783:	6a 00                	push   $0x0
80106785:	68 d6 00 00 00       	push   $0xd6
8010678a:	e9 bf f2 ff ff       	jmp    80105a4e <alltraps>

8010678f <vector215>:
8010678f:	6a 00                	push   $0x0
80106791:	68 d7 00 00 00       	push   $0xd7
80106796:	e9 b3 f2 ff ff       	jmp    80105a4e <alltraps>

8010679b <vector216>:
8010679b:	6a 00                	push   $0x0
8010679d:	68 d8 00 00 00       	push   $0xd8
801067a2:	e9 a7 f2 ff ff       	jmp    80105a4e <alltraps>

801067a7 <vector217>:
801067a7:	6a 00                	push   $0x0
801067a9:	68 d9 00 00 00       	push   $0xd9
801067ae:	e9 9b f2 ff ff       	jmp    80105a4e <alltraps>

801067b3 <vector218>:
801067b3:	6a 00                	push   $0x0
801067b5:	68 da 00 00 00       	push   $0xda
801067ba:	e9 8f f2 ff ff       	jmp    80105a4e <alltraps>

801067bf <vector219>:
801067bf:	6a 00                	push   $0x0
801067c1:	68 db 00 00 00       	push   $0xdb
801067c6:	e9 83 f2 ff ff       	jmp    80105a4e <alltraps>

801067cb <vector220>:
801067cb:	6a 00                	push   $0x0
801067cd:	68 dc 00 00 00       	push   $0xdc
801067d2:	e9 77 f2 ff ff       	jmp    80105a4e <alltraps>

801067d7 <vector221>:
801067d7:	6a 00                	push   $0x0
801067d9:	68 dd 00 00 00       	push   $0xdd
801067de:	e9 6b f2 ff ff       	jmp    80105a4e <alltraps>

801067e3 <vector222>:
801067e3:	6a 00                	push   $0x0
801067e5:	68 de 00 00 00       	push   $0xde
801067ea:	e9 5f f2 ff ff       	jmp    80105a4e <alltraps>

801067ef <vector223>:
801067ef:	6a 00                	push   $0x0
801067f1:	68 df 00 00 00       	push   $0xdf
801067f6:	e9 53 f2 ff ff       	jmp    80105a4e <alltraps>

801067fb <vector224>:
801067fb:	6a 00                	push   $0x0
801067fd:	68 e0 00 00 00       	push   $0xe0
80106802:	e9 47 f2 ff ff       	jmp    80105a4e <alltraps>

80106807 <vector225>:
80106807:	6a 00                	push   $0x0
80106809:	68 e1 00 00 00       	push   $0xe1
8010680e:	e9 3b f2 ff ff       	jmp    80105a4e <alltraps>

80106813 <vector226>:
80106813:	6a 00                	push   $0x0
80106815:	68 e2 00 00 00       	push   $0xe2
8010681a:	e9 2f f2 ff ff       	jmp    80105a4e <alltraps>

8010681f <vector227>:
8010681f:	6a 00                	push   $0x0
80106821:	68 e3 00 00 00       	push   $0xe3
80106826:	e9 23 f2 ff ff       	jmp    80105a4e <alltraps>

8010682b <vector228>:
8010682b:	6a 00                	push   $0x0
8010682d:	68 e4 00 00 00       	push   $0xe4
80106832:	e9 17 f2 ff ff       	jmp    80105a4e <alltraps>

80106837 <vector229>:
80106837:	6a 00                	push   $0x0
80106839:	68 e5 00 00 00       	push   $0xe5
8010683e:	e9 0b f2 ff ff       	jmp    80105a4e <alltraps>

80106843 <vector230>:
80106843:	6a 00                	push   $0x0
80106845:	68 e6 00 00 00       	push   $0xe6
8010684a:	e9 ff f1 ff ff       	jmp    80105a4e <alltraps>

8010684f <vector231>:
8010684f:	6a 00                	push   $0x0
80106851:	68 e7 00 00 00       	push   $0xe7
80106856:	e9 f3 f1 ff ff       	jmp    80105a4e <alltraps>

8010685b <vector232>:
8010685b:	6a 00                	push   $0x0
8010685d:	68 e8 00 00 00       	push   $0xe8
80106862:	e9 e7 f1 ff ff       	jmp    80105a4e <alltraps>

80106867 <vector233>:
80106867:	6a 00                	push   $0x0
80106869:	68 e9 00 00 00       	push   $0xe9
8010686e:	e9 db f1 ff ff       	jmp    80105a4e <alltraps>

80106873 <vector234>:
80106873:	6a 00                	push   $0x0
80106875:	68 ea 00 00 00       	push   $0xea
8010687a:	e9 cf f1 ff ff       	jmp    80105a4e <alltraps>

8010687f <vector235>:
8010687f:	6a 00                	push   $0x0
80106881:	68 eb 00 00 00       	push   $0xeb
80106886:	e9 c3 f1 ff ff       	jmp    80105a4e <alltraps>

8010688b <vector236>:
8010688b:	6a 00                	push   $0x0
8010688d:	68 ec 00 00 00       	push   $0xec
80106892:	e9 b7 f1 ff ff       	jmp    80105a4e <alltraps>

80106897 <vector237>:
80106897:	6a 00                	push   $0x0
80106899:	68 ed 00 00 00       	push   $0xed
8010689e:	e9 ab f1 ff ff       	jmp    80105a4e <alltraps>

801068a3 <vector238>:
801068a3:	6a 00                	push   $0x0
801068a5:	68 ee 00 00 00       	push   $0xee
801068aa:	e9 9f f1 ff ff       	jmp    80105a4e <alltraps>

801068af <vector239>:
801068af:	6a 00                	push   $0x0
801068b1:	68 ef 00 00 00       	push   $0xef
801068b6:	e9 93 f1 ff ff       	jmp    80105a4e <alltraps>

801068bb <vector240>:
801068bb:	6a 00                	push   $0x0
801068bd:	68 f0 00 00 00       	push   $0xf0
801068c2:	e9 87 f1 ff ff       	jmp    80105a4e <alltraps>

801068c7 <vector241>:
801068c7:	6a 00                	push   $0x0
801068c9:	68 f1 00 00 00       	push   $0xf1
801068ce:	e9 7b f1 ff ff       	jmp    80105a4e <alltraps>

801068d3 <vector242>:
801068d3:	6a 00                	push   $0x0
801068d5:	68 f2 00 00 00       	push   $0xf2
801068da:	e9 6f f1 ff ff       	jmp    80105a4e <alltraps>

801068df <vector243>:
801068df:	6a 00                	push   $0x0
801068e1:	68 f3 00 00 00       	push   $0xf3
801068e6:	e9 63 f1 ff ff       	jmp    80105a4e <alltraps>

801068eb <vector244>:
801068eb:	6a 00                	push   $0x0
801068ed:	68 f4 00 00 00       	push   $0xf4
801068f2:	e9 57 f1 ff ff       	jmp    80105a4e <alltraps>

801068f7 <vector245>:
801068f7:	6a 00                	push   $0x0
801068f9:	68 f5 00 00 00       	push   $0xf5
801068fe:	e9 4b f1 ff ff       	jmp    80105a4e <alltraps>

80106903 <vector246>:
80106903:	6a 00                	push   $0x0
80106905:	68 f6 00 00 00       	push   $0xf6
8010690a:	e9 3f f1 ff ff       	jmp    80105a4e <alltraps>

8010690f <vector247>:
8010690f:	6a 00                	push   $0x0
80106911:	68 f7 00 00 00       	push   $0xf7
80106916:	e9 33 f1 ff ff       	jmp    80105a4e <alltraps>

8010691b <vector248>:
8010691b:	6a 00                	push   $0x0
8010691d:	68 f8 00 00 00       	push   $0xf8
80106922:	e9 27 f1 ff ff       	jmp    80105a4e <alltraps>

80106927 <vector249>:
80106927:	6a 00                	push   $0x0
80106929:	68 f9 00 00 00       	push   $0xf9
8010692e:	e9 1b f1 ff ff       	jmp    80105a4e <alltraps>

80106933 <vector250>:
80106933:	6a 00                	push   $0x0
80106935:	68 fa 00 00 00       	push   $0xfa
8010693a:	e9 0f f1 ff ff       	jmp    80105a4e <alltraps>

8010693f <vector251>:
8010693f:	6a 00                	push   $0x0
80106941:	68 fb 00 00 00       	push   $0xfb
80106946:	e9 03 f1 ff ff       	jmp    80105a4e <alltraps>

8010694b <vector252>:
8010694b:	6a 00                	push   $0x0
8010694d:	68 fc 00 00 00       	push   $0xfc
80106952:	e9 f7 f0 ff ff       	jmp    80105a4e <alltraps>

80106957 <vector253>:
80106957:	6a 00                	push   $0x0
80106959:	68 fd 00 00 00       	push   $0xfd
8010695e:	e9 eb f0 ff ff       	jmp    80105a4e <alltraps>

80106963 <vector254>:
80106963:	6a 00                	push   $0x0
80106965:	68 fe 00 00 00       	push   $0xfe
8010696a:	e9 df f0 ff ff       	jmp    80105a4e <alltraps>

8010696f <vector255>:
8010696f:	6a 00                	push   $0x0
80106971:	68 ff 00 00 00       	push   $0xff
80106976:	e9 d3 f0 ff ff       	jmp    80105a4e <alltraps>
8010697b:	66 90                	xchg   %ax,%ax
8010697d:	66 90                	xchg   %ax,%ax
8010697f:	90                   	nop

80106980 <walkpgdir>:
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	57                   	push   %edi
80106984:	56                   	push   %esi
80106985:	89 d6                	mov    %edx,%esi
80106987:	c1 ea 16             	shr    $0x16,%edx
8010698a:	53                   	push   %ebx
8010698b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010698e:	83 ec 0c             	sub    $0xc,%esp
80106991:	8b 1f                	mov    (%edi),%ebx
80106993:	f6 c3 01             	test   $0x1,%bl
80106996:	74 28                	je     801069c0 <walkpgdir+0x40>
80106998:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010699e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801069a4:	89 f0                	mov    %esi,%eax
801069a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069a9:	c1 e8 0a             	shr    $0xa,%eax
801069ac:	25 fc 0f 00 00       	and    $0xffc,%eax
801069b1:	01 d8                	add    %ebx,%eax
801069b3:	5b                   	pop    %ebx
801069b4:	5e                   	pop    %esi
801069b5:	5f                   	pop    %edi
801069b6:	5d                   	pop    %ebp
801069b7:	c3                   	ret    
801069b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069bf:	90                   	nop
801069c0:	85 c9                	test   %ecx,%ecx
801069c2:	74 2c                	je     801069f0 <walkpgdir+0x70>
801069c4:	e8 77 bd ff ff       	call   80102740 <kalloc>
801069c9:	89 c3                	mov    %eax,%ebx
801069cb:	85 c0                	test   %eax,%eax
801069cd:	74 21                	je     801069f0 <walkpgdir+0x70>
801069cf:	83 ec 04             	sub    $0x4,%esp
801069d2:	68 00 10 00 00       	push   $0x1000
801069d7:	6a 00                	push   $0x0
801069d9:	50                   	push   %eax
801069da:	e8 b1 dd ff ff       	call   80104790 <memset>
801069df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069e5:	83 c4 10             	add    $0x10,%esp
801069e8:	83 c8 07             	or     $0x7,%eax
801069eb:	89 07                	mov    %eax,(%edi)
801069ed:	eb b5                	jmp    801069a4 <walkpgdir+0x24>
801069ef:	90                   	nop
801069f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069f3:	31 c0                	xor    %eax,%eax
801069f5:	5b                   	pop    %ebx
801069f6:	5e                   	pop    %esi
801069f7:	5f                   	pop    %edi
801069f8:	5d                   	pop    %ebp
801069f9:	c3                   	ret    
801069fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a00 <mappages>:
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	57                   	push   %edi
80106a04:	89 c7                	mov    %eax,%edi
80106a06:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a0a:	56                   	push   %esi
80106a0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a10:	89 d6                	mov    %edx,%esi
80106a12:	53                   	push   %ebx
80106a13:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106a19:	83 ec 1c             	sub    $0x1c,%esp
80106a1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a22:	29 f0                	sub    %esi,%eax
80106a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a27:	eb 1f                	jmp    80106a48 <mappages+0x48>
80106a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a30:	f6 00 01             	testb  $0x1,(%eax)
80106a33:	75 45                	jne    80106a7a <mappages+0x7a>
80106a35:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106a38:	83 cb 01             	or     $0x1,%ebx
80106a3b:	89 18                	mov    %ebx,(%eax)
80106a3d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106a40:	74 2e                	je     80106a70 <mappages+0x70>
80106a42:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a4b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a50:	89 f2                	mov    %esi,%edx
80106a52:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106a55:	89 f8                	mov    %edi,%eax
80106a57:	e8 24 ff ff ff       	call   80106980 <walkpgdir>
80106a5c:	85 c0                	test   %eax,%eax
80106a5e:	75 d0                	jne    80106a30 <mappages+0x30>
80106a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a68:	5b                   	pop    %ebx
80106a69:	5e                   	pop    %esi
80106a6a:	5f                   	pop    %edi
80106a6b:	5d                   	pop    %ebp
80106a6c:	c3                   	ret    
80106a6d:	8d 76 00             	lea    0x0(%esi),%esi
80106a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a73:	31 c0                	xor    %eax,%eax
80106a75:	5b                   	pop    %ebx
80106a76:	5e                   	pop    %esi
80106a77:	5f                   	pop    %edi
80106a78:	5d                   	pop    %ebp
80106a79:	c3                   	ret    
80106a7a:	83 ec 0c             	sub    $0xc,%esp
80106a7d:	68 b0 7b 10 80       	push   $0x80107bb0
80106a82:	e8 09 99 ff ff       	call   80100390 <panic>
80106a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8e:	66 90                	xchg   %ax,%ax

80106a90 <deallocuvm.part.0>:
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	89 c6                	mov    %eax,%esi
80106a97:	53                   	push   %ebx
80106a98:	89 d3                	mov    %edx,%ebx
80106a9a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106aa0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106aac:	39 da                	cmp    %ebx,%edx
80106aae:	73 5b                	jae    80106b0b <deallocuvm.part.0+0x7b>
80106ab0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106ab3:	89 d7                	mov    %edx,%edi
80106ab5:	eb 14                	jmp    80106acb <deallocuvm.part.0+0x3b>
80106ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106abe:	66 90                	xchg   %ax,%ax
80106ac0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ac6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106ac9:	76 40                	jbe    80106b0b <deallocuvm.part.0+0x7b>
80106acb:	31 c9                	xor    %ecx,%ecx
80106acd:	89 fa                	mov    %edi,%edx
80106acf:	89 f0                	mov    %esi,%eax
80106ad1:	e8 aa fe ff ff       	call   80106980 <walkpgdir>
80106ad6:	89 c3                	mov    %eax,%ebx
80106ad8:	85 c0                	test   %eax,%eax
80106ada:	74 44                	je     80106b20 <deallocuvm.part.0+0x90>
80106adc:	8b 00                	mov    (%eax),%eax
80106ade:	a8 01                	test   $0x1,%al
80106ae0:	74 de                	je     80106ac0 <deallocuvm.part.0+0x30>
80106ae2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ae7:	74 47                	je     80106b30 <deallocuvm.part.0+0xa0>
80106ae9:	83 ec 0c             	sub    $0xc,%esp
80106aec:	05 00 00 00 80       	add    $0x80000000,%eax
80106af1:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106af7:	50                   	push   %eax
80106af8:	e8 83 ba ff ff       	call   80102580 <kfree>
80106afd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106b03:	83 c4 10             	add    $0x10,%esp
80106b06:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106b09:	77 c0                	ja     80106acb <deallocuvm.part.0+0x3b>
80106b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b11:	5b                   	pop    %ebx
80106b12:	5e                   	pop    %esi
80106b13:	5f                   	pop    %edi
80106b14:	5d                   	pop    %ebp
80106b15:	c3                   	ret    
80106b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1d:	8d 76 00             	lea    0x0(%esi),%esi
80106b20:	89 fa                	mov    %edi,%edx
80106b22:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106b28:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106b2e:	eb 96                	jmp    80106ac6 <deallocuvm.part.0+0x36>
80106b30:	83 ec 0c             	sub    $0xc,%esp
80106b33:	68 42 75 10 80       	push   $0x80107542
80106b38:	e8 53 98 ff ff       	call   80100390 <panic>
80106b3d:	8d 76 00             	lea    0x0(%esi),%esi

80106b40 <seginit>:
80106b40:	f3 0f 1e fb          	endbr32 
80106b44:	55                   	push   %ebp
80106b45:	89 e5                	mov    %esp,%ebp
80106b47:	83 ec 18             	sub    $0x18,%esp
80106b4a:	e8 01 cf ff ff       	call   80103a50 <cpuid>
80106b4f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b54:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b5a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106b5e:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106b65:	ff 00 00 
80106b68:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106b6f:	9a cf 00 
80106b72:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106b79:	ff 00 00 
80106b7c:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106b83:	92 cf 00 
80106b86:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106b8d:	ff 00 00 
80106b90:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106b97:	fa cf 00 
80106b9a:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106ba1:	ff 00 00 
80106ba4:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106bab:	f2 cf 00 
80106bae:	05 f0 27 11 80       	add    $0x801127f0,%eax
80106bb3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106bb7:	c1 e8 10             	shr    $0x10,%eax
80106bba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106bbe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bc1:	0f 01 10             	lgdtl  (%eax)
80106bc4:	c9                   	leave  
80106bc5:	c3                   	ret    
80106bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi

80106bd0 <switchkvm>:
80106bd0:	f3 0f 1e fb          	endbr32 
80106bd4:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106bd9:	05 00 00 00 80       	add    $0x80000000,%eax
80106bde:	0f 22 d8             	mov    %eax,%cr3
80106be1:	c3                   	ret    
80106be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <switchuvm>:
80106bf0:	f3 0f 1e fb          	endbr32 
80106bf4:	55                   	push   %ebp
80106bf5:	89 e5                	mov    %esp,%ebp
80106bf7:	57                   	push   %edi
80106bf8:	56                   	push   %esi
80106bf9:	53                   	push   %ebx
80106bfa:	83 ec 1c             	sub    $0x1c,%esp
80106bfd:	8b 75 08             	mov    0x8(%ebp),%esi
80106c00:	85 f6                	test   %esi,%esi
80106c02:	0f 84 cb 00 00 00    	je     80106cd3 <switchuvm+0xe3>
80106c08:	8b 46 08             	mov    0x8(%esi),%eax
80106c0b:	85 c0                	test   %eax,%eax
80106c0d:	0f 84 da 00 00 00    	je     80106ced <switchuvm+0xfd>
80106c13:	8b 46 04             	mov    0x4(%esi),%eax
80106c16:	85 c0                	test   %eax,%eax
80106c18:	0f 84 c2 00 00 00    	je     80106ce0 <switchuvm+0xf0>
80106c1e:	e8 5d d9 ff ff       	call   80104580 <pushcli>
80106c23:	e8 b8 cd ff ff       	call   801039e0 <mycpu>
80106c28:	89 c3                	mov    %eax,%ebx
80106c2a:	e8 b1 cd ff ff       	call   801039e0 <mycpu>
80106c2f:	89 c7                	mov    %eax,%edi
80106c31:	e8 aa cd ff ff       	call   801039e0 <mycpu>
80106c36:	83 c7 08             	add    $0x8,%edi
80106c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c3c:	e8 9f cd ff ff       	call   801039e0 <mycpu>
80106c41:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c44:	ba 67 00 00 00       	mov    $0x67,%edx
80106c49:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c50:	83 c0 08             	add    $0x8,%eax
80106c53:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106c5a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80106c5f:	83 c1 08             	add    $0x8,%ecx
80106c62:	c1 e8 18             	shr    $0x18,%eax
80106c65:	c1 e9 10             	shr    $0x10,%ecx
80106c68:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c6e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c74:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c79:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
80106c80:	bb 10 00 00 00       	mov    $0x10,%ebx
80106c85:	e8 56 cd ff ff       	call   801039e0 <mycpu>
80106c8a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
80106c91:	e8 4a cd ff ff       	call   801039e0 <mycpu>
80106c96:	66 89 58 10          	mov    %bx,0x10(%eax)
80106c9a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106c9d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ca3:	e8 38 cd ff ff       	call   801039e0 <mycpu>
80106ca8:	89 58 0c             	mov    %ebx,0xc(%eax)
80106cab:	e8 30 cd ff ff       	call   801039e0 <mycpu>
80106cb0:	66 89 78 6e          	mov    %di,0x6e(%eax)
80106cb4:	b8 28 00 00 00       	mov    $0x28,%eax
80106cb9:	0f 00 d8             	ltr    %ax
80106cbc:	8b 46 04             	mov    0x4(%esi),%eax
80106cbf:	05 00 00 00 80       	add    $0x80000000,%eax
80106cc4:	0f 22 d8             	mov    %eax,%cr3
80106cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cca:	5b                   	pop    %ebx
80106ccb:	5e                   	pop    %esi
80106ccc:	5f                   	pop    %edi
80106ccd:	5d                   	pop    %ebp
80106cce:	e9 fd d8 ff ff       	jmp    801045d0 <popcli>
80106cd3:	83 ec 0c             	sub    $0xc,%esp
80106cd6:	68 b6 7b 10 80       	push   $0x80107bb6
80106cdb:	e8 b0 96 ff ff       	call   80100390 <panic>
80106ce0:	83 ec 0c             	sub    $0xc,%esp
80106ce3:	68 e1 7b 10 80       	push   $0x80107be1
80106ce8:	e8 a3 96 ff ff       	call   80100390 <panic>
80106ced:	83 ec 0c             	sub    $0xc,%esp
80106cf0:	68 cc 7b 10 80       	push   $0x80107bcc
80106cf5:	e8 96 96 ff ff       	call   80100390 <panic>
80106cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d00 <inituvm>:
80106d00:	f3 0f 1e fb          	endbr32 
80106d04:	55                   	push   %ebp
80106d05:	89 e5                	mov    %esp,%ebp
80106d07:	57                   	push   %edi
80106d08:	56                   	push   %esi
80106d09:	53                   	push   %ebx
80106d0a:	83 ec 1c             	sub    $0x1c,%esp
80106d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d10:	8b 75 10             	mov    0x10(%ebp),%esi
80106d13:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d19:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d1f:	77 4b                	ja     80106d6c <inituvm+0x6c>
80106d21:	e8 1a ba ff ff       	call   80102740 <kalloc>
80106d26:	83 ec 04             	sub    $0x4,%esp
80106d29:	68 00 10 00 00       	push   $0x1000
80106d2e:	89 c3                	mov    %eax,%ebx
80106d30:	6a 00                	push   $0x0
80106d32:	50                   	push   %eax
80106d33:	e8 58 da ff ff       	call   80104790 <memset>
80106d38:	58                   	pop    %eax
80106d39:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d3f:	5a                   	pop    %edx
80106d40:	6a 06                	push   $0x6
80106d42:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d47:	31 d2                	xor    %edx,%edx
80106d49:	50                   	push   %eax
80106d4a:	89 f8                	mov    %edi,%eax
80106d4c:	e8 af fc ff ff       	call   80106a00 <mappages>
80106d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d54:	89 75 10             	mov    %esi,0x10(%ebp)
80106d57:	83 c4 10             	add    $0x10,%esp
80106d5a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106d5d:	89 45 0c             	mov    %eax,0xc(%ebp)
80106d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d63:	5b                   	pop    %ebx
80106d64:	5e                   	pop    %esi
80106d65:	5f                   	pop    %edi
80106d66:	5d                   	pop    %ebp
80106d67:	e9 c4 da ff ff       	jmp    80104830 <memmove>
80106d6c:	83 ec 0c             	sub    $0xc,%esp
80106d6f:	68 f5 7b 10 80       	push   $0x80107bf5
80106d74:	e8 17 96 ff ff       	call   80100390 <panic>
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d80 <loaduvm>:
80106d80:	f3 0f 1e fb          	endbr32 
80106d84:	55                   	push   %ebp
80106d85:	89 e5                	mov    %esp,%ebp
80106d87:	57                   	push   %edi
80106d88:	56                   	push   %esi
80106d89:	53                   	push   %ebx
80106d8a:	83 ec 1c             	sub    $0x1c,%esp
80106d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d90:	8b 75 18             	mov    0x18(%ebp),%esi
80106d93:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106d98:	0f 85 99 00 00 00    	jne    80106e37 <loaduvm+0xb7>
80106d9e:	01 f0                	add    %esi,%eax
80106da0:	89 f3                	mov    %esi,%ebx
80106da2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106da5:	8b 45 14             	mov    0x14(%ebp),%eax
80106da8:	01 f0                	add    %esi,%eax
80106daa:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106dad:	85 f6                	test   %esi,%esi
80106daf:	75 15                	jne    80106dc6 <loaduvm+0x46>
80106db1:	eb 6d                	jmp    80106e20 <loaduvm+0xa0>
80106db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106db7:	90                   	nop
80106db8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106dbe:	89 f0                	mov    %esi,%eax
80106dc0:	29 d8                	sub    %ebx,%eax
80106dc2:	39 c6                	cmp    %eax,%esi
80106dc4:	76 5a                	jbe    80106e20 <loaduvm+0xa0>
80106dc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80106dcc:	31 c9                	xor    %ecx,%ecx
80106dce:	29 da                	sub    %ebx,%edx
80106dd0:	e8 ab fb ff ff       	call   80106980 <walkpgdir>
80106dd5:	85 c0                	test   %eax,%eax
80106dd7:	74 51                	je     80106e2a <loaduvm+0xaa>
80106dd9:	8b 00                	mov    (%eax),%eax
80106ddb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106dde:	bf 00 10 00 00       	mov    $0x1000,%edi
80106de3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106de8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106dee:	0f 46 fb             	cmovbe %ebx,%edi
80106df1:	29 d9                	sub    %ebx,%ecx
80106df3:	05 00 00 00 80       	add    $0x80000000,%eax
80106df8:	57                   	push   %edi
80106df9:	51                   	push   %ecx
80106dfa:	50                   	push   %eax
80106dfb:	ff 75 10             	pushl  0x10(%ebp)
80106dfe:	e8 5d ac ff ff       	call   80101a60 <readi>
80106e03:	83 c4 10             	add    $0x10,%esp
80106e06:	39 f8                	cmp    %edi,%eax
80106e08:	74 ae                	je     80106db8 <loaduvm+0x38>
80106e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e12:	5b                   	pop    %ebx
80106e13:	5e                   	pop    %esi
80106e14:	5f                   	pop    %edi
80106e15:	5d                   	pop    %ebp
80106e16:	c3                   	ret    
80106e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1e:	66 90                	xchg   %ax,%ax
80106e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e23:	31 c0                	xor    %eax,%eax
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret    
80106e2a:	83 ec 0c             	sub    $0xc,%esp
80106e2d:	68 0f 7c 10 80       	push   $0x80107c0f
80106e32:	e8 59 95 ff ff       	call   80100390 <panic>
80106e37:	83 ec 0c             	sub    $0xc,%esp
80106e3a:	68 b0 7c 10 80       	push   $0x80107cb0
80106e3f:	e8 4c 95 ff ff       	call   80100390 <panic>
80106e44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e4f:	90                   	nop

80106e50 <allocuvm>:
80106e50:	f3 0f 1e fb          	endbr32 
80106e54:	55                   	push   %ebp
80106e55:	89 e5                	mov    %esp,%ebp
80106e57:	57                   	push   %edi
80106e58:	56                   	push   %esi
80106e59:	53                   	push   %ebx
80106e5a:	83 ec 1c             	sub    $0x1c,%esp
80106e5d:	8b 45 10             	mov    0x10(%ebp),%eax
80106e60:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e66:	85 c0                	test   %eax,%eax
80106e68:	0f 88 b2 00 00 00    	js     80106f20 <allocuvm+0xd0>
80106e6e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80106e71:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e74:	0f 82 96 00 00 00    	jb     80106f10 <allocuvm+0xc0>
80106e7a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106e80:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106e86:	39 75 10             	cmp    %esi,0x10(%ebp)
80106e89:	77 40                	ja     80106ecb <allocuvm+0x7b>
80106e8b:	e9 83 00 00 00       	jmp    80106f13 <allocuvm+0xc3>
80106e90:	83 ec 04             	sub    $0x4,%esp
80106e93:	68 00 10 00 00       	push   $0x1000
80106e98:	6a 00                	push   $0x0
80106e9a:	50                   	push   %eax
80106e9b:	e8 f0 d8 ff ff       	call   80104790 <memset>
80106ea0:	58                   	pop    %eax
80106ea1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ea7:	5a                   	pop    %edx
80106ea8:	6a 06                	push   $0x6
80106eaa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eaf:	89 f2                	mov    %esi,%edx
80106eb1:	50                   	push   %eax
80106eb2:	89 f8                	mov    %edi,%eax
80106eb4:	e8 47 fb ff ff       	call   80106a00 <mappages>
80106eb9:	83 c4 10             	add    $0x10,%esp
80106ebc:	85 c0                	test   %eax,%eax
80106ebe:	78 78                	js     80106f38 <allocuvm+0xe8>
80106ec0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ec6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ec9:	76 48                	jbe    80106f13 <allocuvm+0xc3>
80106ecb:	e8 70 b8 ff ff       	call   80102740 <kalloc>
80106ed0:	89 c3                	mov    %eax,%ebx
80106ed2:	85 c0                	test   %eax,%eax
80106ed4:	75 ba                	jne    80106e90 <allocuvm+0x40>
80106ed6:	83 ec 0c             	sub    $0xc,%esp
80106ed9:	68 2d 7c 10 80       	push   $0x80107c2d
80106ede:	e8 cd 97 ff ff       	call   801006b0 <cprintf>
80106ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ee6:	83 c4 10             	add    $0x10,%esp
80106ee9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106eec:	74 32                	je     80106f20 <allocuvm+0xd0>
80106eee:	8b 55 10             	mov    0x10(%ebp),%edx
80106ef1:	89 c1                	mov    %eax,%ecx
80106ef3:	89 f8                	mov    %edi,%eax
80106ef5:	e8 96 fb ff ff       	call   80106a90 <deallocuvm.part.0>
80106efa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f07:	5b                   	pop    %ebx
80106f08:	5e                   	pop    %esi
80106f09:	5f                   	pop    %edi
80106f0a:	5d                   	pop    %ebp
80106f0b:	c3                   	ret    
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f19:	5b                   	pop    %ebx
80106f1a:	5e                   	pop    %esi
80106f1b:	5f                   	pop    %edi
80106f1c:	5d                   	pop    %ebp
80106f1d:	c3                   	ret    
80106f1e:	66 90                	xchg   %ax,%ax
80106f20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f2d:	5b                   	pop    %ebx
80106f2e:	5e                   	pop    %esi
80106f2f:	5f                   	pop    %edi
80106f30:	5d                   	pop    %ebp
80106f31:	c3                   	ret    
80106f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f38:	83 ec 0c             	sub    $0xc,%esp
80106f3b:	68 45 7c 10 80       	push   $0x80107c45
80106f40:	e8 6b 97 ff ff       	call   801006b0 <cprintf>
80106f45:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f48:	83 c4 10             	add    $0x10,%esp
80106f4b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f4e:	74 0c                	je     80106f5c <allocuvm+0x10c>
80106f50:	8b 55 10             	mov    0x10(%ebp),%edx
80106f53:	89 c1                	mov    %eax,%ecx
80106f55:	89 f8                	mov    %edi,%eax
80106f57:	e8 34 fb ff ff       	call   80106a90 <deallocuvm.part.0>
80106f5c:	83 ec 0c             	sub    $0xc,%esp
80106f5f:	53                   	push   %ebx
80106f60:	e8 1b b6 ff ff       	call   80102580 <kfree>
80106f65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f6c:	83 c4 10             	add    $0x10,%esp
80106f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f80 <deallocuvm>:
80106f80:	f3 0f 1e fb          	endbr32 
80106f84:	55                   	push   %ebp
80106f85:	89 e5                	mov    %esp,%ebp
80106f87:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f8d:	8b 45 08             	mov    0x8(%ebp),%eax
80106f90:	39 d1                	cmp    %edx,%ecx
80106f92:	73 0c                	jae    80106fa0 <deallocuvm+0x20>
80106f94:	5d                   	pop    %ebp
80106f95:	e9 f6 fa ff ff       	jmp    80106a90 <deallocuvm.part.0>
80106f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fa0:	89 d0                	mov    %edx,%eax
80106fa2:	5d                   	pop    %ebp
80106fa3:	c3                   	ret    
80106fa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106faf:	90                   	nop

80106fb0 <freevm>:
80106fb0:	f3 0f 1e fb          	endbr32 
80106fb4:	55                   	push   %ebp
80106fb5:	89 e5                	mov    %esp,%ebp
80106fb7:	57                   	push   %edi
80106fb8:	56                   	push   %esi
80106fb9:	53                   	push   %ebx
80106fba:	83 ec 0c             	sub    $0xc,%esp
80106fbd:	8b 75 08             	mov    0x8(%ebp),%esi
80106fc0:	85 f6                	test   %esi,%esi
80106fc2:	74 55                	je     80107019 <freevm+0x69>
80106fc4:	31 c9                	xor    %ecx,%ecx
80106fc6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106fcb:	89 f0                	mov    %esi,%eax
80106fcd:	89 f3                	mov    %esi,%ebx
80106fcf:	e8 bc fa ff ff       	call   80106a90 <deallocuvm.part.0>
80106fd4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106fda:	eb 0b                	jmp    80106fe7 <freevm+0x37>
80106fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fe0:	83 c3 04             	add    $0x4,%ebx
80106fe3:	39 df                	cmp    %ebx,%edi
80106fe5:	74 23                	je     8010700a <freevm+0x5a>
80106fe7:	8b 03                	mov    (%ebx),%eax
80106fe9:	a8 01                	test   $0x1,%al
80106feb:	74 f3                	je     80106fe0 <freevm+0x30>
80106fed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ff2:	83 ec 0c             	sub    $0xc,%esp
80106ff5:	83 c3 04             	add    $0x4,%ebx
80106ff8:	05 00 00 00 80       	add    $0x80000000,%eax
80106ffd:	50                   	push   %eax
80106ffe:	e8 7d b5 ff ff       	call   80102580 <kfree>
80107003:	83 c4 10             	add    $0x10,%esp
80107006:	39 df                	cmp    %ebx,%edi
80107008:	75 dd                	jne    80106fe7 <freevm+0x37>
8010700a:	89 75 08             	mov    %esi,0x8(%ebp)
8010700d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107010:	5b                   	pop    %ebx
80107011:	5e                   	pop    %esi
80107012:	5f                   	pop    %edi
80107013:	5d                   	pop    %ebp
80107014:	e9 67 b5 ff ff       	jmp    80102580 <kfree>
80107019:	83 ec 0c             	sub    $0xc,%esp
8010701c:	68 61 7c 10 80       	push   $0x80107c61
80107021:	e8 6a 93 ff ff       	call   80100390 <panic>
80107026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702d:	8d 76 00             	lea    0x0(%esi),%esi

80107030 <setupkvm>:
80107030:	f3 0f 1e fb          	endbr32 
80107034:	55                   	push   %ebp
80107035:	89 e5                	mov    %esp,%ebp
80107037:	56                   	push   %esi
80107038:	53                   	push   %ebx
80107039:	e8 02 b7 ff ff       	call   80102740 <kalloc>
8010703e:	89 c6                	mov    %eax,%esi
80107040:	85 c0                	test   %eax,%eax
80107042:	74 42                	je     80107086 <setupkvm+0x56>
80107044:	83 ec 04             	sub    $0x4,%esp
80107047:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
8010704c:	68 00 10 00 00       	push   $0x1000
80107051:	6a 00                	push   $0x0
80107053:	50                   	push   %eax
80107054:	e8 37 d7 ff ff       	call   80104790 <memset>
80107059:	83 c4 10             	add    $0x10,%esp
8010705c:	8b 43 04             	mov    0x4(%ebx),%eax
8010705f:	83 ec 08             	sub    $0x8,%esp
80107062:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107065:	ff 73 0c             	pushl  0xc(%ebx)
80107068:	8b 13                	mov    (%ebx),%edx
8010706a:	50                   	push   %eax
8010706b:	29 c1                	sub    %eax,%ecx
8010706d:	89 f0                	mov    %esi,%eax
8010706f:	e8 8c f9 ff ff       	call   80106a00 <mappages>
80107074:	83 c4 10             	add    $0x10,%esp
80107077:	85 c0                	test   %eax,%eax
80107079:	78 15                	js     80107090 <setupkvm+0x60>
8010707b:	83 c3 10             	add    $0x10,%ebx
8010707e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107084:	75 d6                	jne    8010705c <setupkvm+0x2c>
80107086:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107089:	89 f0                	mov    %esi,%eax
8010708b:	5b                   	pop    %ebx
8010708c:	5e                   	pop    %esi
8010708d:	5d                   	pop    %ebp
8010708e:	c3                   	ret    
8010708f:	90                   	nop
80107090:	83 ec 0c             	sub    $0xc,%esp
80107093:	56                   	push   %esi
80107094:	31 f6                	xor    %esi,%esi
80107096:	e8 15 ff ff ff       	call   80106fb0 <freevm>
8010709b:	83 c4 10             	add    $0x10,%esp
8010709e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070a1:	89 f0                	mov    %esi,%eax
801070a3:	5b                   	pop    %ebx
801070a4:	5e                   	pop    %esi
801070a5:	5d                   	pop    %ebp
801070a6:	c3                   	ret    
801070a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ae:	66 90                	xchg   %ax,%ax

801070b0 <kvmalloc>:
801070b0:	f3 0f 1e fb          	endbr32 
801070b4:	55                   	push   %ebp
801070b5:	89 e5                	mov    %esp,%ebp
801070b7:	83 ec 08             	sub    $0x8,%esp
801070ba:	e8 71 ff ff ff       	call   80107030 <setupkvm>
801070bf:	a3 a4 54 11 80       	mov    %eax,0x801154a4
801070c4:	05 00 00 00 80       	add    $0x80000000,%eax
801070c9:	0f 22 d8             	mov    %eax,%cr3
801070cc:	c9                   	leave  
801070cd:	c3                   	ret    
801070ce:	66 90                	xchg   %ax,%ax

801070d0 <clearpteu>:
801070d0:	f3 0f 1e fb          	endbr32 
801070d4:	55                   	push   %ebp
801070d5:	31 c9                	xor    %ecx,%ecx
801070d7:	89 e5                	mov    %esp,%ebp
801070d9:	83 ec 08             	sub    $0x8,%esp
801070dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801070df:	8b 45 08             	mov    0x8(%ebp),%eax
801070e2:	e8 99 f8 ff ff       	call   80106980 <walkpgdir>
801070e7:	85 c0                	test   %eax,%eax
801070e9:	74 05                	je     801070f0 <clearpteu+0x20>
801070eb:	83 20 fb             	andl   $0xfffffffb,(%eax)
801070ee:	c9                   	leave  
801070ef:	c3                   	ret    
801070f0:	83 ec 0c             	sub    $0xc,%esp
801070f3:	68 72 7c 10 80       	push   $0x80107c72
801070f8:	e8 93 92 ff ff       	call   80100390 <panic>
801070fd:	8d 76 00             	lea    0x0(%esi),%esi

80107100 <copyuvm>:
80107100:	f3 0f 1e fb          	endbr32 
80107104:	55                   	push   %ebp
80107105:	89 e5                	mov    %esp,%ebp
80107107:	57                   	push   %edi
80107108:	56                   	push   %esi
80107109:	53                   	push   %ebx
8010710a:	83 ec 1c             	sub    $0x1c,%esp
8010710d:	e8 1e ff ff ff       	call   80107030 <setupkvm>
80107112:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107115:	85 c0                	test   %eax,%eax
80107117:	0f 84 9b 00 00 00    	je     801071b8 <copyuvm+0xb8>
8010711d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107120:	85 c9                	test   %ecx,%ecx
80107122:	0f 84 90 00 00 00    	je     801071b8 <copyuvm+0xb8>
80107128:	31 f6                	xor    %esi,%esi
8010712a:	eb 46                	jmp    80107172 <copyuvm+0x72>
8010712c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107130:	83 ec 04             	sub    $0x4,%esp
80107133:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107139:	68 00 10 00 00       	push   $0x1000
8010713e:	57                   	push   %edi
8010713f:	50                   	push   %eax
80107140:	e8 eb d6 ff ff       	call   80104830 <memmove>
80107145:	58                   	pop    %eax
80107146:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010714c:	5a                   	pop    %edx
8010714d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107150:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107155:	89 f2                	mov    %esi,%edx
80107157:	50                   	push   %eax
80107158:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010715b:	e8 a0 f8 ff ff       	call   80106a00 <mappages>
80107160:	83 c4 10             	add    $0x10,%esp
80107163:	85 c0                	test   %eax,%eax
80107165:	78 61                	js     801071c8 <copyuvm+0xc8>
80107167:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010716d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107170:	76 46                	jbe    801071b8 <copyuvm+0xb8>
80107172:	8b 45 08             	mov    0x8(%ebp),%eax
80107175:	31 c9                	xor    %ecx,%ecx
80107177:	89 f2                	mov    %esi,%edx
80107179:	e8 02 f8 ff ff       	call   80106980 <walkpgdir>
8010717e:	85 c0                	test   %eax,%eax
80107180:	74 61                	je     801071e3 <copyuvm+0xe3>
80107182:	8b 00                	mov    (%eax),%eax
80107184:	a8 01                	test   $0x1,%al
80107186:	74 4e                	je     801071d6 <copyuvm+0xd6>
80107188:	89 c7                	mov    %eax,%edi
8010718a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010718f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107192:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107198:	e8 a3 b5 ff ff       	call   80102740 <kalloc>
8010719d:	89 c3                	mov    %eax,%ebx
8010719f:	85 c0                	test   %eax,%eax
801071a1:	75 8d                	jne    80107130 <copyuvm+0x30>
801071a3:	83 ec 0c             	sub    $0xc,%esp
801071a6:	ff 75 e0             	pushl  -0x20(%ebp)
801071a9:	e8 02 fe ff ff       	call   80106fb0 <freevm>
801071ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801071b5:	83 c4 10             	add    $0x10,%esp
801071b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071be:	5b                   	pop    %ebx
801071bf:	5e                   	pop    %esi
801071c0:	5f                   	pop    %edi
801071c1:	5d                   	pop    %ebp
801071c2:	c3                   	ret    
801071c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071c7:	90                   	nop
801071c8:	83 ec 0c             	sub    $0xc,%esp
801071cb:	53                   	push   %ebx
801071cc:	e8 af b3 ff ff       	call   80102580 <kfree>
801071d1:	83 c4 10             	add    $0x10,%esp
801071d4:	eb cd                	jmp    801071a3 <copyuvm+0xa3>
801071d6:	83 ec 0c             	sub    $0xc,%esp
801071d9:	68 96 7c 10 80       	push   $0x80107c96
801071de:	e8 ad 91 ff ff       	call   80100390 <panic>
801071e3:	83 ec 0c             	sub    $0xc,%esp
801071e6:	68 7c 7c 10 80       	push   $0x80107c7c
801071eb:	e8 a0 91 ff ff       	call   80100390 <panic>

801071f0 <uva2ka>:
801071f0:	f3 0f 1e fb          	endbr32 
801071f4:	55                   	push   %ebp
801071f5:	31 c9                	xor    %ecx,%ecx
801071f7:	89 e5                	mov    %esp,%ebp
801071f9:	83 ec 08             	sub    $0x8,%esp
801071fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801071ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107202:	e8 79 f7 ff ff       	call   80106980 <walkpgdir>
80107207:	8b 00                	mov    (%eax),%eax
80107209:	c9                   	leave  
8010720a:	89 c2                	mov    %eax,%edx
8010720c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107211:	83 e2 05             	and    $0x5,%edx
80107214:	05 00 00 00 80       	add    $0x80000000,%eax
80107219:	83 fa 05             	cmp    $0x5,%edx
8010721c:	ba 00 00 00 00       	mov    $0x0,%edx
80107221:	0f 45 c2             	cmovne %edx,%eax
80107224:	c3                   	ret    
80107225:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107230 <copyout>:
80107230:	f3 0f 1e fb          	endbr32 
80107234:	55                   	push   %ebp
80107235:	89 e5                	mov    %esp,%ebp
80107237:	57                   	push   %edi
80107238:	56                   	push   %esi
80107239:	53                   	push   %ebx
8010723a:	83 ec 0c             	sub    $0xc,%esp
8010723d:	8b 75 14             	mov    0x14(%ebp),%esi
80107240:	8b 55 0c             	mov    0xc(%ebp),%edx
80107243:	85 f6                	test   %esi,%esi
80107245:	75 3c                	jne    80107283 <copyout+0x53>
80107247:	eb 67                	jmp    801072b0 <copyout+0x80>
80107249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107250:	8b 55 0c             	mov    0xc(%ebp),%edx
80107253:	89 fb                	mov    %edi,%ebx
80107255:	29 d3                	sub    %edx,%ebx
80107257:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010725d:	39 f3                	cmp    %esi,%ebx
8010725f:	0f 47 de             	cmova  %esi,%ebx
80107262:	29 fa                	sub    %edi,%edx
80107264:	83 ec 04             	sub    $0x4,%esp
80107267:	01 c2                	add    %eax,%edx
80107269:	53                   	push   %ebx
8010726a:	ff 75 10             	pushl  0x10(%ebp)
8010726d:	52                   	push   %edx
8010726e:	e8 bd d5 ff ff       	call   80104830 <memmove>
80107273:	01 5d 10             	add    %ebx,0x10(%ebp)
80107276:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
8010727c:	83 c4 10             	add    $0x10,%esp
8010727f:	29 de                	sub    %ebx,%esi
80107281:	74 2d                	je     801072b0 <copyout+0x80>
80107283:	89 d7                	mov    %edx,%edi
80107285:	83 ec 08             	sub    $0x8,%esp
80107288:	89 55 0c             	mov    %edx,0xc(%ebp)
8010728b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107291:	57                   	push   %edi
80107292:	ff 75 08             	pushl  0x8(%ebp)
80107295:	e8 56 ff ff ff       	call   801071f0 <uva2ka>
8010729a:	83 c4 10             	add    $0x10,%esp
8010729d:	85 c0                	test   %eax,%eax
8010729f:	75 af                	jne    80107250 <copyout+0x20>
801072a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072a9:	5b                   	pop    %ebx
801072aa:	5e                   	pop    %esi
801072ab:	5f                   	pop    %edi
801072ac:	5d                   	pop    %ebp
801072ad:	c3                   	ret    
801072ae:	66 90                	xchg   %ax,%ax
801072b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b3:	31 c0                	xor    %eax,%eax
801072b5:	5b                   	pop    %ebx
801072b6:	5e                   	pop    %esi
801072b7:	5f                   	pop    %edi
801072b8:	5d                   	pop    %ebp
801072b9:	c3                   	ret    
