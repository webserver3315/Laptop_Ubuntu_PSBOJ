
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
80100028:	bc 00 c6 10 80       	mov    $0x8010c600,%esp
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
80100048:	bb 34 c6 10 80       	mov    $0x8010c634,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 60 7a 10 80       	push   $0x80107a60
80100055:	68 00 c6 10 80       	push   $0x8010c600
8010005a:	e8 c1 4a 00 00       	call   80104b20 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 fc 0c 11 80       	mov    $0x80110cfc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 4c 0d 11 80 fc 	movl   $0x80110cfc,0x80110d4c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 50 0d 11 80 fc 	movl   $0x80110cfc,0x80110d50
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
8010008b:	c7 43 50 fc 0c 11 80 	movl   $0x80110cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 7a 10 80       	push   $0x80107a67
80100097:	50                   	push   %eax
80100098:	e8 43 49 00 00       	call   801049e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 0d 11 80       	mov    0x80110d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 50 0d 11 80    	mov    %ebx,0x80110d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb a0 0a 11 80    	cmp    $0x80110aa0,%ebx
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
801000e3:	68 00 c6 10 80       	push   $0x8010c600
801000e8:	e8 b3 4b 00 00       	call   80104ca0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 50 0d 11 80    	mov    0x80110d50,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
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
80100120:	8b 1d 4c 0d 11 80    	mov    0x80110d4c,%ebx
80100126:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
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
8010015d:	68 00 c6 10 80       	push   $0x8010c600
80100162:	e8 f9 4b 00 00       	call   80104d60 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 48 00 00       	call   80104a20 <acquiresleep>
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
801001a3:	68 6e 7a 10 80       	push   $0x80107a6e
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
801001c2:	e8 f9 48 00 00       	call   80104ac0 <holdingsleep>
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
801001e0:	68 7f 7a 10 80       	push   $0x80107a7f
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
80100203:	e8 b8 48 00 00       	call   80104ac0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 68 48 00 00       	call   80104a80 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010021f:	e8 7c 4a 00 00       	call   80104ca0 <acquire>
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
80100246:	a1 50 0d 11 80       	mov    0x80110d50,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 fc 0c 11 80 	movl   $0x80110cfc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 50 0d 11 80       	mov    0x80110d50,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 50 0d 11 80    	mov    %ebx,0x80110d50
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 00 c6 10 80 	movl   $0x8010c600,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 eb 4a 00 00       	jmp    80104d60 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 7a 10 80       	push   $0x80107a86
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
801002aa:	c7 04 24 60 b5 10 80 	movl   $0x8010b560,(%esp)
801002b1:	e8 ea 49 00 00       	call   80104ca0 <acquire>
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
801002c6:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801002cb:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 60 b5 10 80       	push   $0x8010b560
801002e0:	68 e0 0f 11 80       	push   $0x80110fe0
801002e5:	e8 06 3f 00 00       	call   801041f0 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 71 38 00 00       	call   80103b70 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 60 b5 10 80       	push   $0x8010b560
8010030e:	e8 4d 4a 00 00       	call   80104d60 <release>
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
80100333:	89 15 e0 0f 11 80    	mov    %edx,0x80110fe0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 60 0f 11 80 	movsbl -0x7feef0a0(%edx),%ecx
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
80100360:	68 60 b5 10 80       	push   $0x8010b560
80100365:	e8 f6 49 00 00       	call   80104d60 <release>
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
80100386:	a3 e0 0f 11 80       	mov    %eax,0x80110fe0
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
8010039d:	c7 05 94 b5 10 80 00 	movl   $0x0,0x8010b594
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 25 00 00       	call   801029b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 7a 10 80       	push   $0x80107a8d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 bb 80 10 80 	movl   $0x801080bb,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 5f 47 00 00       	call   80104b40 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 7a 10 80       	push   $0x80107aa1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 98 b5 10 80 01 	movl   $0x1,0x8010b598
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
8010042a:	e8 31 62 00 00       	call   80106660 <uartputc>
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
80100515:	e8 46 61 00 00       	call   80106660 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 3a 61 00 00       	call   80106660 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 2e 61 00 00       	call   80106660 <uartputc>
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
80100561:	e8 ea 48 00 00       	call   80104e50 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 35 48 00 00       	call   80104db0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 a5 7a 10 80       	push   $0x80107aa5
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
801005c9:	0f b6 92 d0 7a 10 80 	movzbl -0x7fef8530(%edx),%edx
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
80100603:	8b 15 98 b5 10 80    	mov    0x8010b598,%edx
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
80100658:	c7 04 24 60 b5 10 80 	movl   $0x8010b560,(%esp)
8010065f:	e8 3c 46 00 00       	call   80104ca0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 98 b5 10 80    	mov    0x8010b598,%edx
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
80100692:	68 60 b5 10 80       	push   $0x8010b560
80100697:	e8 c4 46 00 00       	call   80104d60 <release>
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
801006bd:	a1 94 b5 10 80       	mov    0x8010b594,%eax
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
801006ec:	8b 0d 98 b5 10 80    	mov    0x8010b598,%ecx
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
8010077d:	bb b8 7a 10 80       	mov    $0x80107ab8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 98 b5 10 80    	mov    0x8010b598,%edx
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
801007b8:	68 60 b5 10 80       	push   $0x8010b560
801007bd:	e8 de 44 00 00       	call   80104ca0 <acquire>
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
801007e0:	8b 3d 98 b5 10 80    	mov    0x8010b598,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 98 b5 10 80    	mov    0x8010b598,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 98 b5 10 80    	mov    0x8010b598,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 60 b5 10 80       	push   $0x8010b560
80100828:	e8 33 45 00 00       	call   80104d60 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 bf 7a 10 80       	push   $0x80107abf
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
80100872:	68 60 b5 10 80       	push   $0x8010b560
80100877:	e8 24 44 00 00       	call   80104ca0 <acquire>
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
801008b4:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 e0 0f 11 80    	sub    0x80110fe0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 98 b5 10 80    	mov    0x8010b598,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d e8 0f 11 80    	mov    %ecx,0x80110fe8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 60 0f 11 80    	mov    %bl,-0x7feef0a0(%eax)
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
80100908:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 e8 0f 11 80    	cmp    %eax,0x80110fe8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100925:	39 05 e4 0f 11 80    	cmp    %eax,0x80110fe4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 60 0f 11 80 0a 	cmpb   $0xa,-0x7feef0a0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 98 b5 10 80    	mov    0x8010b598,%edx
        input.e--;
8010094c:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
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
8010096a:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
8010096f:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100985:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
  if(panicked){
80100999:	a1 98 b5 10 80       	mov    0x8010b598,%eax
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
801009ca:	68 60 b5 10 80       	push   $0x8010b560
801009cf:	e8 8c 43 00 00       	call   80104d60 <release>
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
801009e3:	c6 80 60 0f 11 80 0a 	movb   $0xa,-0x7feef0a0(%eax)
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
801009ff:	e9 7c 3a 00 00       	jmp    80104480 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 e4 0f 11 80       	mov    %eax,0x80110fe4
          wakeup(&input.r);
80100a1b:	68 e0 0f 11 80       	push   $0x80110fe0
80100a20:	e8 8b 39 00 00       	call   801043b0 <wakeup>
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
80100a3a:	68 c8 7a 10 80       	push   $0x80107ac8
80100a3f:	68 60 b5 10 80       	push   $0x8010b560
80100a44:	e8 d7 40 00 00       	call   80104b20 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 ac 19 11 80 40 	movl   $0x80100640,0x801119ac
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 a8 19 11 80 90 	movl   $0x80100290,0x801119a8
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 94 b5 10 80 01 	movl   $0x1,0x8010b594
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
80100a90:	e8 db 30 00 00       	call   80103b70 <myproc>
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
80100b0c:	e8 bf 6c 00 00       	call   801077d0 <setupkvm>
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
80100b73:	e8 78 6a 00 00       	call   801075f0 <allocuvm>
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
80100ba9:	e8 72 69 00 00       	call   80107520 <loaduvm>
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
80100beb:	e8 60 6b 00 00       	call   80107750 <freevm>
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
80100c32:	e8 b9 69 00 00       	call   801075f0 <allocuvm>
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
80100c53:	e8 18 6c 00 00       	call   80107870 <clearpteu>
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
80100ca3:	e8 08 43 00 00       	call   80104fb0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 f5 42 00 00       	call   80104fb0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 04 6d 00 00       	call   801079d0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 6a 6a 00 00       	call   80107750 <freevm>
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
80100d33:	e8 98 6c 00 00       	call   801079d0 <copyout>
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
80100d71:	e8 fa 41 00 00       	call   80104f70 <safestrcpy>
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
80100d9d:	e8 ee 65 00 00       	call   80107390 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 a6 69 00 00       	call   80107750 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 f7 20 00 00       	call   80102eb0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 e1 7a 10 80       	push   $0x80107ae1
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
80100dea:	68 ed 7a 10 80       	push   $0x80107aed
80100def:	68 00 10 11 80       	push   $0x80111000
80100df4:	e8 27 3d 00 00       	call   80104b20 <initlock>
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
80100e08:	bb 34 10 11 80       	mov    $0x80111034,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 00 10 11 80       	push   $0x80111000
80100e15:	e8 86 3e 00 00       	call   80104ca0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 94 19 11 80    	cmp    $0x80111994,%ebx
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
80100e3c:	68 00 10 11 80       	push   $0x80111000
80100e41:	e8 1a 3f 00 00       	call   80104d60 <release>
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
80100e55:	68 00 10 11 80       	push   $0x80111000
80100e5a:	e8 01 3f 00 00       	call   80104d60 <release>
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
80100e7e:	68 00 10 11 80       	push   $0x80111000
80100e83:	e8 18 3e 00 00       	call   80104ca0 <acquire>
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
80100e9b:	68 00 10 11 80       	push   $0x80111000
80100ea0:	e8 bb 3e 00 00       	call   80104d60 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 f4 7a 10 80       	push   $0x80107af4
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
80100ed0:	68 00 10 11 80       	push   $0x80111000
80100ed5:	e8 c6 3d 00 00       	call   80104ca0 <acquire>
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
80100f08:	68 00 10 11 80       	push   $0x80111000
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 4b 3e 00 00       	call   80104d60 <release>

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
80100f30:	c7 45 08 00 10 11 80 	movl   $0x80111000,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 1d 3e 00 00       	jmp    80104d60 <release>
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
80100f8c:	68 fc 7a 10 80       	push   $0x80107afc
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
8010107a:	68 06 7b 10 80       	push   $0x80107b06
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
80101163:	68 0f 7b 10 80       	push   $0x80107b0f
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
80101199:	68 15 7b 10 80       	push   $0x80107b15
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
801011b9:	8b 0d 00 1a 11 80    	mov    0x80111a00,%ecx
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
801011dc:	03 05 18 1a 11 80    	add    0x80111a18,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 00 1a 11 80       	mov    0x80111a00,%eax
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
80101249:	39 05 00 1a 11 80    	cmp    %eax,0x80111a00
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 1f 7b 10 80       	push   $0x80107b1f
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
80101295:	e8 16 3b 00 00       	call   80104db0 <memset>
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
801012ca:	bb 54 1a 11 80       	mov    $0x80111a54,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 20 1a 11 80       	push   $0x80111a20
801012da:	e8 c1 39 00 00       	call   80104ca0 <acquire>
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
80101347:	e8 14 3a 00 00       	call   80104d60 <release>

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
80101375:	e8 e6 39 00 00       	call   80104d60 <release>
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
801013a2:	68 35 7b 10 80       	push   $0x80107b35
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
8010146b:	68 45 7b 10 80       	push   $0x80107b45
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
801014a5:	e8 a6 39 00 00       	call   80104e50 <memmove>
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
801014cc:	68 00 1a 11 80       	push   $0x80111a00
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 18 1a 11 80    	add    0x80111a18,%eax
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
80101534:	68 58 7b 10 80       	push   $0x80107b58
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
80101550:	68 6b 7b 10 80       	push   $0x80107b6b
80101555:	68 20 1a 11 80       	push   $0x80111a20
8010155a:	e8 c1 35 00 00       	call   80104b20 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 72 7b 10 80       	push   $0x80107b72
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 64 34 00 00       	call   801049e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 80 36 11 80    	cmp    $0x80113680,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 00 1a 11 80       	push   $0x80111a00
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 18 1a 11 80    	pushl  0x80111a18
8010159d:	ff 35 14 1a 11 80    	pushl  0x80111a14
801015a3:	ff 35 10 1a 11 80    	pushl  0x80111a10
801015a9:	ff 35 0c 1a 11 80    	pushl  0x80111a0c
801015af:	ff 35 08 1a 11 80    	pushl  0x80111a08
801015b5:	ff 35 04 1a 11 80    	pushl  0x80111a04
801015bb:	ff 35 00 1a 11 80    	pushl  0x80111a00
801015c1:	68 f4 7b 10 80       	push   $0x80107bf4
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
801015f0:	83 3d 08 1a 11 80 01 	cmpl   $0x1,0x80111a08
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
8010161f:	3b 3d 08 1a 11 80    	cmp    0x80111a08,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 14 1a 11 80    	add    0x80111a14,%eax
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
8010165e:	e8 4d 37 00 00       	call   80104db0 <memset>
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
80101693:	68 78 7b 10 80       	push   $0x80107b78
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
801016b8:	03 05 14 1a 11 80    	add    0x80111a14,%eax
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
80101705:	e8 46 37 00 00       	call   80104e50 <memmove>
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
8010173e:	68 20 1a 11 80       	push   $0x80111a20
80101743:	e8 58 35 00 00       	call   80104ca0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
80101753:	e8 08 36 00 00       	call   80104d60 <release>
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
80101786:	e8 95 32 00 00       	call   80104a20 <acquiresleep>
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
801017a9:	03 05 14 1a 11 80    	add    0x80111a14,%eax
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
801017f8:	e8 53 36 00 00       	call   80104e50 <memmove>
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
8010181d:	68 90 7b 10 80       	push   $0x80107b90
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 8a 7b 10 80       	push   $0x80107b8a
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
80101857:	e8 64 32 00 00       	call   80104ac0 <holdingsleep>
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
80101873:	e9 08 32 00 00       	jmp    80104a80 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 9f 7b 10 80       	push   $0x80107b9f
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
801018a4:	e8 77 31 00 00       	call   80104a20 <acquiresleep>
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
801018be:	e8 bd 31 00 00       	call   80104a80 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
801018ca:	e8 d1 33 00 00       	call   80104ca0 <acquire>
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
801018e4:	e9 77 34 00 00       	jmp    80104d60 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 20 1a 11 80       	push   $0x80111a20
801018f8:	e8 a3 33 00 00       	call   80104ca0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
80101907:	e8 54 34 00 00       	call   80104d60 <release>
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
80101b07:	e8 44 33 00 00       	call   80104e50 <memmove>
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
80101b3a:	8b 04 c5 a0 19 11 80 	mov    -0x7feee660(,%eax,8),%eax
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
80101c03:	e8 48 32 00 00       	call   80104e50 <memmove>
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
80101c4a:	8b 04 c5 a4 19 11 80 	mov    -0x7feee65c(,%eax,8),%eax
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
80101ca2:	e8 19 32 00 00       	call   80104ec0 <strncmp>
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
80101d05:	e8 b6 31 00 00       	call   80104ec0 <strncmp>
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
80101d4a:	68 b9 7b 10 80       	push   $0x80107bb9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 a7 7b 10 80       	push   $0x80107ba7
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
80101d8a:	e8 e1 1d 00 00       	call   80103b70 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 20 1a 11 80       	push   $0x80111a20
80101d9c:	e8 ff 2e 00 00       	call   80104ca0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
80101dac:	e8 af 2f 00 00       	call   80104d60 <release>
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
80101e17:	e8 34 30 00 00       	call   80104e50 <memmove>
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
80101ea3:	e8 a8 2f 00 00       	call   80104e50 <memmove>
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
80101fd5:	e8 36 2f 00 00       	call   80104f10 <strncpy>
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
80102013:	68 c8 7b 10 80       	push   $0x80107bc8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 36 82 10 80       	push   $0x80108236
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
801020c3:	e8 88 2d 00 00       	call   80104e50 <memmove>
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
801020e3:	68 d5 7b 10 80       	push   $0x80107bd5
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
80102143:	e8 08 2d 00 00       	call   80104e50 <memmove>
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
8010216b:	68 d5 7b 10 80       	push   $0x80107bd5
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
8010223b:	68 50 7c 10 80       	push   $0x80107c50
80102240:	e8 4b e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102245:	83 ec 0c             	sub    $0xc,%esp
80102248:	68 47 7c 10 80       	push   $0x80107c47
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
8010226a:	68 62 7c 10 80       	push   $0x80107c62
8010226f:	68 c0 b5 10 80       	push   $0x8010b5c0
80102274:	e8 a7 28 00 00       	call   80104b20 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102279:	58                   	pop    %eax
8010227a:	a1 40 3d 11 80       	mov    0x80113d40,%eax
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
801022ca:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
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
801022fd:	68 c0 b5 10 80       	push   $0x8010b5c0
80102302:	e8 99 29 00 00       	call   80104ca0 <acquire>

  if((b = idequeue) == 0){
80102307:	8b 1d a4 b5 10 80    	mov    0x8010b5a4,%ebx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 db                	test   %ebx,%ebx
80102312:	74 5f                	je     80102373 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102314:	8b 43 58             	mov    0x58(%ebx),%eax
80102317:	a3 a4 b5 10 80       	mov    %eax,0x8010b5a4

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
8010235d:	e8 4e 20 00 00       	call   801043b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102362:	a1 a4 b5 10 80       	mov    0x8010b5a4,%eax
80102367:	83 c4 10             	add    $0x10,%esp
8010236a:	85 c0                	test   %eax,%eax
8010236c:	74 05                	je     80102373 <ideintr+0x83>
    idestart(idequeue);
8010236e:	e8 0d fe ff ff       	call   80102180 <idestart>
    release(&idelock);
80102373:	83 ec 0c             	sub    $0xc,%esp
80102376:	68 c0 b5 10 80       	push   $0x8010b5c0
8010237b:	e8 e0 29 00 00       	call   80104d60 <release>

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
801023a2:	e8 19 27 00 00       	call   80104ac0 <holdingsleep>
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
801023c7:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
801023cc:	85 c0                	test   %eax,%eax
801023ce:	0f 84 93 00 00 00    	je     80102467 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 c0 b5 10 80       	push   $0x8010b5c0
801023dc:	e8 bf 28 00 00       	call   80104ca0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e1:	a1 a4 b5 10 80       	mov    0x8010b5a4,%eax
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
80102406:	39 1d a4 b5 10 80    	cmp    %ebx,0x8010b5a4
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
80102423:	68 c0 b5 10 80       	push   $0x8010b5c0
80102428:	53                   	push   %ebx
80102429:	e8 c2 1d 00 00       	call   801041f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 c4 10             	add    $0x10,%esp
80102433:	83 e0 06             	and    $0x6,%eax
80102436:	83 f8 02             	cmp    $0x2,%eax
80102439:	75 e5                	jne    80102420 <iderw+0x90>
  }


  release(&idelock);
8010243b:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80102442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102445:	c9                   	leave  
  release(&idelock);
80102446:	e9 15 29 00 00       	jmp    80104d60 <release>
8010244b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010244f:	90                   	nop
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 29 fd ff ff       	call   80102180 <idestart>
80102457:	eb b5                	jmp    8010240e <iderw+0x7e>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba a4 b5 10 80       	mov    $0x8010b5a4,%edx
80102465:	eb 9d                	jmp    80102404 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	68 91 7c 10 80       	push   $0x80107c91
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 7c 7c 10 80       	push   $0x80107c7c
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 66 7c 10 80       	push   $0x80107c66
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
80102495:	c7 05 74 36 11 80 00 	movl   $0xfec00000,0x80113674
8010249c:	00 c0 fe 
{
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	56                   	push   %esi
801024a2:	53                   	push   %ebx
  ioapic->reg = reg;
801024a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024aa:	00 00 00 
  return ioapic->data;
801024ad:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024bc:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024c2:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
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
801024de:	68 b0 7c 10 80       	push   $0x80107cb0
801024e3:	e8 c8 e1 ff ff       	call   801006b0 <cprintf>
801024e8:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
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
80102504:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
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
8010251e:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
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
80102545:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
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
80102559:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102562:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102565:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102568:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010256a:	a1 74 36 11 80       	mov    0x80113674,%eax
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
80102596:	81 fb e8 6a 11 80    	cmp    $0x80116ae8,%ebx
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
801025b6:	e8 f5 27 00 00       	call   80104db0 <memset>

  if(kmem.use_lock)
801025bb:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
801025c1:	83 c4 10             	add    $0x10,%esp
801025c4:	85 d2                	test   %edx,%edx
801025c6:	75 20                	jne    801025e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025c8:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801025cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025cf:	a1 b4 36 11 80       	mov    0x801136b4,%eax
  kmem.freelist = r;
801025d4:	89 1d b8 36 11 80    	mov    %ebx,0x801136b8
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
801025eb:	68 80 36 11 80       	push   $0x80113680
801025f0:	e8 ab 26 00 00       	call   80104ca0 <acquire>
801025f5:	83 c4 10             	add    $0x10,%esp
801025f8:	eb ce                	jmp    801025c8 <kfree+0x48>
801025fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102600:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010260a:	c9                   	leave  
    release(&kmem.lock);
8010260b:	e9 50 27 00 00       	jmp    80104d60 <release>
    panic("kfree");
80102610:	83 ec 0c             	sub    $0xc,%esp
80102613:	68 e2 7c 10 80       	push   $0x80107ce2
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
8010267f:	68 e8 7c 10 80       	push   $0x80107ce8
80102684:	68 80 36 11 80       	push   $0x80113680
80102689:	e8 92 24 00 00       	call   80104b20 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102694:	c7 05 b4 36 11 80 00 	movl   $0x0,0x801136b4
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
80102724:	c7 05 b4 36 11 80 01 	movl   $0x1,0x801136b4
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
80102744:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102749:	85 c0                	test   %eax,%eax
8010274b:	75 1b                	jne    80102768 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010274d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
  if(r)
80102752:	85 c0                	test   %eax,%eax
80102754:	74 0a                	je     80102760 <kalloc+0x20>
    kmem.freelist = r->next;
80102756:	8b 10                	mov    (%eax),%edx
80102758:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
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
8010276e:	68 80 36 11 80       	push   $0x80113680
80102773:	e8 28 25 00 00       	call   80104ca0 <acquire>
  r = kmem.freelist;
80102778:	a1 b8 36 11 80       	mov    0x801136b8,%eax
  if(r)
8010277d:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
80102783:	83 c4 10             	add    $0x10,%esp
80102786:	85 c0                	test   %eax,%eax
80102788:	74 08                	je     80102792 <kalloc+0x52>
    kmem.freelist = r->next;
8010278a:	8b 08                	mov    (%eax),%ecx
8010278c:	89 0d b8 36 11 80    	mov    %ecx,0x801136b8
  if(kmem.use_lock)
80102792:	85 d2                	test   %edx,%edx
80102794:	74 16                	je     801027ac <kalloc+0x6c>
    release(&kmem.lock);
80102796:	83 ec 0c             	sub    $0xc,%esp
80102799:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010279c:	68 80 36 11 80       	push   $0x80113680
801027a1:	e8 ba 25 00 00       	call   80104d60 <release>
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
801027cc:	8b 1d f4 b5 10 80    	mov    0x8010b5f4,%ebx
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
801027ef:	0f b6 8a 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%ecx
  shift ^= togglecode[data];
801027f6:	0f b6 82 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%eax
  shift |= shiftcode[data];
801027fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801027ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102801:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102803:	89 0d f4 b5 10 80    	mov    %ecx,0x8010b5f4
  c = charcode[shift & (CTL | SHIFT)][data];
80102809:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010280c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010280f:	8b 04 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%eax
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
80102835:	89 1d f4 b5 10 80    	mov    %ebx,0x8010b5f4
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
8010284a:	0f b6 8a 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%ecx
80102851:	83 c9 40             	or     $0x40,%ecx
80102854:	0f b6 c9             	movzbl %cl,%ecx
80102857:	f7 d1                	not    %ecx
80102859:	21 d9                	and    %ebx,%ecx
}
8010285b:	5b                   	pop    %ebx
8010285c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010285d:	89 0d f4 b5 10 80    	mov    %ecx,0x8010b5f4
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
801028b4:	a1 bc 36 11 80       	mov    0x801136bc,%eax
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
801029b4:	a1 bc 36 11 80       	mov    0x801136bc,%eax
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
801029d4:	a1 bc 36 11 80       	mov    0x801136bc,%eax
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
80102a42:	a1 bc 36 11 80       	mov    0x801136bc,%eax
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
80102bcf:	e8 2c 22 00 00       	call   80104e00 <memcmp>
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
80102ca0:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
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
80102cc0:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102cc5:	83 ec 08             	sub    $0x8,%esp
80102cc8:	01 f8                	add    %edi,%eax
80102cca:	83 c0 01             	add    $0x1,%eax
80102ccd:	50                   	push   %eax
80102cce:	ff 35 04 37 11 80    	pushl  0x80113704
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
80102cd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cdb:	58                   	pop    %eax
80102cdc:	5a                   	pop    %edx
80102cdd:	ff 34 bd 0c 37 11 80 	pushl  -0x7feec8f4(,%edi,4)
80102ce4:	ff 35 04 37 11 80    	pushl  0x80113704
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
80102d04:	e8 47 21 00 00       	call   80104e50 <memmove>
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
80102d24:	39 3d 08 37 11 80    	cmp    %edi,0x80113708
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
80102d47:	ff 35 f4 36 11 80    	pushl  0x801136f4
80102d4d:	ff 35 04 37 11 80    	pushl  0x80113704
80102d53:	e8 78 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d5d:	a1 08 37 11 80       	mov    0x80113708,%eax
80102d62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d65:	85 c0                	test   %eax,%eax
80102d67:	7e 19                	jle    80102d82 <write_head+0x42>
80102d69:	31 d2                	xor    %edx,%edx
80102d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d70:	8b 0c 95 0c 37 11 80 	mov    -0x7feec8f4(,%edx,4),%ecx
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
80102dae:	68 20 7f 10 80       	push   $0x80107f20
80102db3:	68 c0 36 11 80       	push   $0x801136c0
80102db8:	e8 63 1d 00 00       	call   80104b20 <initlock>
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
80102dcd:	89 1d 04 37 11 80    	mov    %ebx,0x80113704
  log.size = sb.nlog;
80102dd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102dd6:	a3 f4 36 11 80       	mov    %eax,0x801136f4
  log.size = sb.nlog;
80102ddb:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  struct buf *buf = bread(log.dev, log.start);
80102de1:	5a                   	pop    %edx
80102de2:	50                   	push   %eax
80102de3:	53                   	push   %ebx
80102de4:	e8 e7 d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102dec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102def:	89 0d 08 37 11 80    	mov    %ecx,0x80113708
  for (i = 0; i < log.lh.n; i++) {
80102df5:	85 c9                	test   %ecx,%ecx
80102df7:	7e 19                	jle    80102e12 <initlog+0x72>
80102df9:	31 d2                	xor    %edx,%edx
80102dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102e00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102e04:	89 1c 95 0c 37 11 80 	mov    %ebx,-0x7feec8f4(,%edx,4)
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
80102e20:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
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
80102e4a:	68 c0 36 11 80       	push   $0x801136c0
80102e4f:	e8 4c 1e 00 00       	call   80104ca0 <acquire>
80102e54:	83 c4 10             	add    $0x10,%esp
80102e57:	eb 1c                	jmp    80102e75 <begin_op+0x35>
80102e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e60:	83 ec 08             	sub    $0x8,%esp
80102e63:	68 c0 36 11 80       	push   $0x801136c0
80102e68:	68 c0 36 11 80       	push   $0x801136c0
80102e6d:	e8 7e 13 00 00       	call   801041f0 <sleep>
80102e72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e75:	a1 00 37 11 80       	mov    0x80113700,%eax
80102e7a:	85 c0                	test   %eax,%eax
80102e7c:	75 e2                	jne    80102e60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e7e:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e83:	8b 15 08 37 11 80    	mov    0x80113708,%edx
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
80102e9a:	a3 fc 36 11 80       	mov    %eax,0x801136fc
      release(&log.lock);
80102e9f:	68 c0 36 11 80       	push   $0x801136c0
80102ea4:	e8 b7 1e 00 00       	call   80104d60 <release>
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
80102ebd:	68 c0 36 11 80       	push   $0x801136c0
80102ec2:	e8 d9 1d 00 00       	call   80104ca0 <acquire>
  log.outstanding -= 1;
80102ec7:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  if(log.committing)
80102ecc:	8b 35 00 37 11 80    	mov    0x80113700,%esi
80102ed2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ed5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ed8:	89 1d fc 36 11 80    	mov    %ebx,0x801136fc
  if(log.committing)
80102ede:	85 f6                	test   %esi,%esi
80102ee0:	0f 85 1e 01 00 00    	jne    80103004 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ee6:	85 db                	test   %ebx,%ebx
80102ee8:	0f 85 f2 00 00 00    	jne    80102fe0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eee:	c7 05 00 37 11 80 01 	movl   $0x1,0x80113700
80102ef5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ef8:	83 ec 0c             	sub    $0xc,%esp
80102efb:	68 c0 36 11 80       	push   $0x801136c0
80102f00:	e8 5b 1e 00 00       	call   80104d60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f05:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102f0b:	83 c4 10             	add    $0x10,%esp
80102f0e:	85 c9                	test   %ecx,%ecx
80102f10:	7f 3e                	jg     80102f50 <end_op+0xa0>
    acquire(&log.lock);
80102f12:	83 ec 0c             	sub    $0xc,%esp
80102f15:	68 c0 36 11 80       	push   $0x801136c0
80102f1a:	e8 81 1d 00 00       	call   80104ca0 <acquire>
    wakeup(&log);
80102f1f:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
    log.committing = 0;
80102f26:	c7 05 00 37 11 80 00 	movl   $0x0,0x80113700
80102f2d:	00 00 00 
    wakeup(&log);
80102f30:	e8 7b 14 00 00       	call   801043b0 <wakeup>
    release(&log.lock);
80102f35:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102f3c:	e8 1f 1e 00 00       	call   80104d60 <release>
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
80102f50:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102f55:	83 ec 08             	sub    $0x8,%esp
80102f58:	01 d8                	add    %ebx,%eax
80102f5a:	83 c0 01             	add    $0x1,%eax
80102f5d:	50                   	push   %eax
80102f5e:	ff 35 04 37 11 80    	pushl  0x80113704
80102f64:	e8 67 d1 ff ff       	call   801000d0 <bread>
80102f69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f6b:	58                   	pop    %eax
80102f6c:	5a                   	pop    %edx
80102f6d:	ff 34 9d 0c 37 11 80 	pushl  -0x7feec8f4(,%ebx,4)
80102f74:	ff 35 04 37 11 80    	pushl  0x80113704
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
80102f94:	e8 b7 1e 00 00       	call   80104e50 <memmove>
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
80102fb4:	3b 1d 08 37 11 80    	cmp    0x80113708,%ebx
80102fba:	7c 94                	jl     80102f50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fbc:	e8 7f fd ff ff       	call   80102d40 <write_head>
    install_trans(); // Now install writes to home locations
80102fc1:	e8 da fc ff ff       	call   80102ca0 <install_trans>
    log.lh.n = 0;
80102fc6:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102fcd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fd0:	e8 6b fd ff ff       	call   80102d40 <write_head>
80102fd5:	e9 38 ff ff ff       	jmp    80102f12 <end_op+0x62>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fe0:	83 ec 0c             	sub    $0xc,%esp
80102fe3:	68 c0 36 11 80       	push   $0x801136c0
80102fe8:	e8 c3 13 00 00       	call   801043b0 <wakeup>
  release(&log.lock);
80102fed:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102ff4:	e8 67 1d 00 00       	call   80104d60 <release>
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
80103007:	68 24 7f 10 80       	push   $0x80107f24
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
8010302b:	8b 15 08 37 11 80    	mov    0x80113708,%edx
{
80103031:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103034:	83 fa 1d             	cmp    $0x1d,%edx
80103037:	0f 8f 91 00 00 00    	jg     801030ce <log_write+0xae>
8010303d:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80103042:	83 e8 01             	sub    $0x1,%eax
80103045:	39 c2                	cmp    %eax,%edx
80103047:	0f 8d 81 00 00 00    	jge    801030ce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010304d:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103052:	85 c0                	test   %eax,%eax
80103054:	0f 8e 81 00 00 00    	jle    801030db <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010305a:	83 ec 0c             	sub    $0xc,%esp
8010305d:	68 c0 36 11 80       	push   $0x801136c0
80103062:	e8 39 1c 00 00       	call   80104ca0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103067:	8b 15 08 37 11 80    	mov    0x80113708,%edx
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
80103087:	39 0c 85 0c 37 11 80 	cmp    %ecx,-0x7feec8f4(,%eax,4)
8010308e:	75 f0                	jne    80103080 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103090:	89 0c 85 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103097:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010309a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010309d:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
801030a4:	c9                   	leave  
  release(&log.lock);
801030a5:	e9 b6 1c 00 00       	jmp    80104d60 <release>
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
    log.lh.n++;
801030b7:	83 c2 01             	add    $0x1,%edx
801030ba:	89 15 08 37 11 80    	mov    %edx,0x80113708
801030c0:	eb d5                	jmp    80103097 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801030c2:	8b 43 08             	mov    0x8(%ebx),%eax
801030c5:	a3 0c 37 11 80       	mov    %eax,0x8011370c
  if (i == log.lh.n)
801030ca:	75 cb                	jne    80103097 <log_write+0x77>
801030cc:	eb e9                	jmp    801030b7 <log_write+0x97>
    panic("too big a transaction");
801030ce:	83 ec 0c             	sub    $0xc,%esp
801030d1:	68 33 7f 10 80       	push   $0x80107f33
801030d6:	e8 b5 d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801030db:	83 ec 0c             	sub    $0xc,%esp
801030de:	68 49 7f 10 80       	push   $0x80107f49
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
801030f7:	e8 54 0a 00 00       	call   80103b50 <cpuid>
801030fc:	89 c3                	mov    %eax,%ebx
801030fe:	e8 4d 0a 00 00       	call   80103b50 <cpuid>
80103103:	83 ec 04             	sub    $0x4,%esp
80103106:	53                   	push   %ebx
80103107:	50                   	push   %eax
80103108:	68 64 7f 10 80       	push   $0x80107f64
8010310d:	e8 9e d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103112:	e8 d9 30 00 00       	call   801061f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103117:	e8 c4 09 00 00       	call   80103ae0 <mycpu>
8010311c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010311e:	b8 01 00 00 00       	mov    $0x1,%eax
80103123:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010312a:	e8 81 0d 00 00       	call   80103eb0 <scheduler>
8010312f:	90                   	nop

80103130 <mpenter>:
{
80103130:	f3 0f 1e fb          	endbr32 
80103134:	55                   	push   %ebp
80103135:	89 e5                	mov    %esp,%ebp
80103137:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010313a:	e8 31 42 00 00       	call   80107370 <switchkvm>
  seginit();
8010313f:	e8 9c 41 00 00       	call   801072e0 <seginit>
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
8010316b:	68 e8 6a 11 80       	push   $0x80116ae8
80103170:	e8 fb f4 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
80103175:	e8 d6 46 00 00       	call   80107850 <kvmalloc>
  mpinit();        // detect other processors
8010317a:	e8 81 01 00 00       	call   80103300 <mpinit>
  lapicinit();     // interrupt controller
8010317f:	e8 2c f7 ff ff       	call   801028b0 <lapicinit>
  seginit();       // segment descriptors
80103184:	e8 57 41 00 00       	call   801072e0 <seginit>
  picinit();       // disable pic
80103189:	e8 52 03 00 00       	call   801034e0 <picinit>
  ioapicinit();    // another interrupt controller
8010318e:	e8 fd f2 ff ff       	call   80102490 <ioapicinit>
  consoleinit();   // console hardware
80103193:	e8 98 d8 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103198:	e8 03 34 00 00       	call   801065a0 <uartinit>
  pinit();         // process table
8010319d:	e8 1e 09 00 00       	call   80103ac0 <pinit>
  tvinit();        // trap vectors
801031a2:	e8 c9 2f 00 00       	call   80106170 <tvinit>
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
801031be:	68 cc b4 10 80       	push   $0x8010b4cc
801031c3:	68 00 70 00 80       	push   $0x80007000
801031c8:	e8 83 1c 00 00       	call   80104e50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031cd:	83 c4 10             	add    $0x10,%esp
801031d0:	69 05 40 3d 11 80 b0 	imul   $0xb0,0x80113d40,%eax
801031d7:	00 00 00 
801031da:	05 c0 37 11 80       	add    $0x801137c0,%eax
801031df:	3d c0 37 11 80       	cmp    $0x801137c0,%eax
801031e4:	76 7a                	jbe    80103260 <main+0x110>
801031e6:	bb c0 37 11 80       	mov    $0x801137c0,%ebx
801031eb:	eb 1c                	jmp    80103209 <main+0xb9>
801031ed:	8d 76 00             	lea    0x0(%esi),%esi
801031f0:	69 05 40 3d 11 80 b0 	imul   $0xb0,0x80113d40,%eax
801031f7:	00 00 00 
801031fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103200:	05 c0 37 11 80       	add    $0x801137c0,%eax
80103205:	39 c3                	cmp    %eax,%ebx
80103207:	73 57                	jae    80103260 <main+0x110>
    if(c == mycpu())  // We've started already.
80103209:	e8 d2 08 00 00       	call   80103ae0 <mycpu>
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
80103272:	e8 29 09 00 00       	call   80103ba0 <userinit>
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
801032ae:	68 78 7f 10 80       	push   $0x80107f78
801032b3:	56                   	push   %esi
801032b4:	e8 47 1b 00 00       	call   80104e00 <memcmp>
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
8010336a:	68 7d 7f 10 80       	push   $0x80107f7d
8010336f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103370:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103373:	e8 88 1a 00 00       	call   80104e00 <memcmp>
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
801033ce:	a3 bc 36 11 80       	mov    %eax,0x801136bc
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
8010345f:	88 0d a0 37 11 80    	mov    %cl,0x801137a0
      continue;
80103465:	eb 89                	jmp    801033f0 <mpinit+0xf0>
80103467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010346e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103470:	8b 0d 40 3d 11 80    	mov    0x80113d40,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d 40 3d 11 80    	mov    %ecx,0x80113d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9f c0 37 11 80    	mov    %bl,-0x7feec840(%edi)
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
801034c3:	68 82 7f 10 80       	push   $0x80107f82
801034c8:	e8 c3 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801034cd:	83 ec 0c             	sub    $0xc,%esp
801034d0:	68 9c 7f 10 80       	push   $0x80107f9c
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
80103577:	68 bb 7f 10 80       	push   $0x80107fbb
8010357c:	50                   	push   %eax
8010357d:	e8 9e 15 00 00       	call   80104b20 <initlock>
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
80103623:	e8 78 16 00 00       	call   80104ca0 <acquire>
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
80103643:	e8 68 0d 00 00       	call   801043b0 <wakeup>
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
80103668:	e9 f3 16 00 00       	jmp    80104d60 <release>
8010366d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103679:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103680:	00 00 00 
    wakeup(&p->nwrite);
80103683:	50                   	push   %eax
80103684:	e8 27 0d 00 00       	call   801043b0 <wakeup>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	eb bd                	jmp    8010364b <pipeclose+0x3b>
8010368e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	53                   	push   %ebx
80103694:	e8 c7 16 00 00       	call   80104d60 <release>
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
801036c1:	e8 da 15 00 00       	call   80104ca0 <acquire>
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
80103708:	e8 63 04 00 00       	call   80103b70 <myproc>
8010370d:	8b 48 24             	mov    0x24(%eax),%ecx
80103710:	85 c9                	test   %ecx,%ecx
80103712:	75 34                	jne    80103748 <pipewrite+0x98>
      wakeup(&p->nread);
80103714:	83 ec 0c             	sub    $0xc,%esp
80103717:	57                   	push   %edi
80103718:	e8 93 0c 00 00       	call   801043b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371d:	58                   	pop    %eax
8010371e:	5a                   	pop    %edx
8010371f:	53                   	push   %ebx
80103720:	56                   	push   %esi
80103721:	e8 ca 0a 00 00       	call   801041f0 <sleep>
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
8010374c:	e8 0f 16 00 00       	call   80104d60 <release>
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
8010379a:	e8 11 0c 00 00       	call   801043b0 <wakeup>
  release(&p->lock);
8010379f:	89 1c 24             	mov    %ebx,(%esp)
801037a2:	e8 b9 15 00 00       	call   80104d60 <release>
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
801037ca:	e8 d1 14 00 00       	call   80104ca0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801037de:	74 33                	je     80103813 <piperead+0x63>
801037e0:	eb 3b                	jmp    8010381d <piperead+0x6d>
801037e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801037e8:	e8 83 03 00 00       	call   80103b70 <myproc>
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
801037fd:	e8 ee 09 00 00       	call   801041f0 <sleep>
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
80103866:	e8 45 0b 00 00       	call   801043b0 <wakeup>
  release(&p->lock);
8010386b:	89 34 24             	mov    %esi,(%esp)
8010386e:	e8 ed 14 00 00       	call   80104d60 <release>
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
80103889:	e8 d2 14 00 00       	call   80104d60 <release>
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

801038a0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801038a0:	55                   	push   %ebp
  struct proc *p, *p1;
  // My Code
  int min_vruntime = 0;
801038a1:	31 c9                	xor    %ecx,%ecx
{
801038a3:	89 e5                	mov    %esp,%ebp
801038a5:	57                   	push   %edi
801038a6:	56                   	push   %esi
801038a7:	53                   	push   %ebx
801038a8:	83 ec 04             	sub    $0x4,%esp
801038ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038ae:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
801038b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038b7:	90                   	nop
	  if(p->state == RUNNING || p-> state == RUNNABLE){
801038b8:	8b 70 0c             	mov    0xc(%eax),%esi
801038bb:	8d 56 fd             	lea    -0x3(%esi),%edx
801038be:	83 fa 01             	cmp    $0x1,%edx
801038c1:	77 0b                	ja     801038ce <wakeup1+0x2e>
		  if(min_vruntime>p->vruntime){
801038c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801038c9:	39 d1                	cmp    %edx,%ecx
801038cb:	0f 4f ca             	cmovg  %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038ce:	05 94 00 00 00       	add    $0x94,%eax
801038d3:	3d 94 62 11 80       	cmp    $0x80116294,%eax
801038d8:	75 de                	jne    801038b8 <wakeup1+0x18>
			  min_vruntime=p->vruntime;
		  }
	  }
  }
  int notempty=0;
801038da:	31 f6                	xor    %esi,%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038dc:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
801038e1:	eb 13                	jmp    801038f6 <wakeup1+0x56>
801038e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038e7:	90                   	nop
801038e8:	81 c3 94 00 00 00    	add    $0x94,%ebx
801038ee:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
801038f4:	74 6a                	je     80103960 <wakeup1+0xc0>
    if(p->state == SLEEPING && p->chan == chan){
801038f6:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801038fa:	75 ec                	jne    801038e8 <wakeup1+0x48>
801038fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ff:	39 43 20             	cmp    %eax,0x20(%ebx)
80103902:	75 e4                	jne    801038e8 <wakeup1+0x48>
      p->state = RUNNABLE;
80103904:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      //cprintf("Process %s woken up\n",p->name);
      for(p1 = ptable.proc; p1<&ptable.proc[NPROC];p1++){	// Update min_vruntime
8010390b:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
	      if(p1->state == RUNNING || p1->state == RUNNABLE){
80103910:	8b 50 0c             	mov    0xc(%eax),%edx
80103913:	83 ea 03             	sub    $0x3,%edx
80103916:	83 fa 01             	cmp    $0x1,%edx
80103919:	77 10                	ja     8010392b <wakeup1+0x8b>
		      notempty=1;
		      if(min_vruntime>p1->vruntime){
8010391b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
		      notempty=1;
80103921:	be 01 00 00 00       	mov    $0x1,%esi
80103926:	39 d1                	cmp    %edx,%ecx
80103928:	0f 4f ca             	cmovg  %edx,%ecx
      for(p1 = ptable.proc; p1<&ptable.proc[NPROC];p1++){	// Update min_vruntime
8010392b:	05 94 00 00 00       	add    $0x94,%eax
80103930:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103935:	75 d9                	jne    80103910 <wakeup1+0x70>
			      min_vruntime=p1->vruntime;
		      }
	      }
      }
      if(notempty){
80103937:	85 f6                	test   %esi,%esi
80103939:	74 2d                	je     80103968 <wakeup1+0xc8>
      		int one_tick_vruntime = (1000*1024)/nice2weight(p->priority);
8010393b:	8b 7b 7c             	mov    0x7c(%ebx),%edi
8010393e:	b8 00 a0 0f 00       	mov    $0xfa000,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103943:	81 c3 94 00 00 00    	add    $0x94,%ebx
      		int one_tick_vruntime = (1000*1024)/nice2weight(p->priority);
80103949:	99                   	cltd   
8010394a:	f7 3c bd 34 b0 10 80 	idivl  -0x7fef4fcc(,%edi,4)
     		p->vruntime=min_vruntime-one_tick_vruntime;
80103951:	89 ca                	mov    %ecx,%edx
80103953:	29 c2                	sub    %eax,%edx
80103955:	89 53 f0             	mov    %edx,-0x10(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103958:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
8010395e:	75 96                	jne    801038f6 <wakeup1+0x56>
		p->vruntime=0;
      }
    }
  }
  // My Code End
}
80103960:	83 c4 04             	add    $0x4,%esp
80103963:	5b                   	pop    %ebx
80103964:	5e                   	pop    %esi
80103965:	5f                   	pop    %edi
80103966:	5d                   	pop    %ebp
80103967:	c3                   	ret    
		p->vruntime=0;
80103968:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010396f:	00 00 00 
80103972:	e9 71 ff ff ff       	jmp    801038e8 <wakeup1+0x48>
80103977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397e:	66 90                	xchg   %ax,%ax

80103980 <allocproc>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103984:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
{
80103989:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010398c:	68 60 3d 11 80       	push   $0x80113d60
80103991:	e8 0a 13 00 00       	call   80104ca0 <acquire>
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	eb 17                	jmp    801039b2 <allocproc+0x32>
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801039a6:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
801039ac:	0f 84 8e 00 00 00    	je     80103a40 <allocproc+0xc0>
    if(p->state == UNUSED)
801039b2:	8b 43 0c             	mov    0xc(%ebx),%eax
801039b5:	85 c0                	test   %eax,%eax
801039b7:	75 e7                	jne    801039a0 <allocproc+0x20>
  p->pid = nextpid++;
801039b9:	a1 4c b0 10 80       	mov    0x8010b04c,%eax
  release(&ptable.lock);
801039be:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039c1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority=0;	// Process's Default Priority is 0 
801039c8:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
801039cf:	89 43 10             	mov    %eax,0x10(%ebx)
801039d2:	8d 50 01             	lea    0x1(%eax),%edx
  p->runtime=0;
801039d5:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801039dc:	00 00 00 
  release(&ptable.lock);
801039df:	68 60 3d 11 80       	push   $0x80113d60
  p->pid = nextpid++;
801039e4:	89 15 4c b0 10 80    	mov    %edx,0x8010b04c
  release(&ptable.lock);
801039ea:	e8 71 13 00 00       	call   80104d60 <release>
  if((p->kstack = kalloc()) == 0){
801039ef:	e8 4c ed ff ff       	call   80102740 <kalloc>
801039f4:	83 c4 10             	add    $0x10,%esp
801039f7:	89 43 08             	mov    %eax,0x8(%ebx)
801039fa:	85 c0                	test   %eax,%eax
801039fc:	74 5b                	je     80103a59 <allocproc+0xd9>
  sp -= sizeof *p->tf;
801039fe:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
80103a04:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a07:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a0c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a0f:	c7 40 14 5b 61 10 80 	movl   $0x8010615b,0x14(%eax)
  p->context = (struct context*)sp;
80103a16:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a19:	6a 14                	push   $0x14
80103a1b:	6a 00                	push   $0x0
80103a1d:	50                   	push   %eax
80103a1e:	e8 8d 13 00 00       	call   80104db0 <memset>
  p->context->eip = (uint)forkret;
80103a23:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
80103a26:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a29:	c7 40 10 70 3a 10 80 	movl   $0x80103a70,0x10(%eax)
}
80103a30:	89 d8                	mov    %ebx,%eax
80103a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a35:	c9                   	leave  
80103a36:	c3                   	ret    
80103a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103a40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a43:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a45:	68 60 3d 11 80       	push   $0x80113d60
80103a4a:	e8 11 13 00 00       	call   80104d60 <release>
}
80103a4f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a51:	83 c4 10             	add    $0x10,%esp
}
80103a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a57:	c9                   	leave  
80103a58:	c3                   	ret    
    p->state = UNUSED;
80103a59:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a60:	31 db                	xor    %ebx,%ebx
}
80103a62:	89 d8                	mov    %ebx,%eax
80103a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a67:	c9                   	leave  
80103a68:	c3                   	ret    
80103a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a70 <forkret>:
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103a7a:	68 60 3d 11 80       	push   $0x80113d60
80103a7f:	e8 dc 12 00 00       	call   80104d60 <release>
  if (first) {
80103a84:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	85 c0                	test   %eax,%eax
80103a8e:	75 08                	jne    80103a98 <forkret+0x28>
}
80103a90:	c9                   	leave  
80103a91:	c3                   	ret    
80103a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103a98:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a9f:	00 00 00 
    iinit(ROOTDEV);
80103aa2:	83 ec 0c             	sub    $0xc,%esp
80103aa5:	6a 01                	push   $0x1
80103aa7:	e8 94 da ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103aac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103ab3:	e8 e8 f2 ff ff       	call   80102da0 <initlog>
}
80103ab8:	83 c4 10             	add    $0x10,%esp
80103abb:	c9                   	leave  
80103abc:	c3                   	ret    
80103abd:	8d 76 00             	lea    0x0(%esi),%esi

80103ac0 <pinit>:
{
80103ac0:	f3 0f 1e fb          	endbr32 
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103aca:	68 c0 7f 10 80       	push   $0x80107fc0
80103acf:	68 60 3d 11 80       	push   $0x80113d60
80103ad4:	e8 47 10 00 00       	call   80104b20 <initlock>
}
80103ad9:	83 c4 10             	add    $0x10,%esp
80103adc:	c9                   	leave  
80103add:	c3                   	ret    
80103ade:	66 90                	xchg   %ax,%ax

80103ae0 <mycpu>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	56                   	push   %esi
80103ae8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ae9:	9c                   	pushf  
80103aea:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103aeb:	f6 c4 02             	test   $0x2,%ah
80103aee:	75 4a                	jne    80103b3a <mycpu+0x5a>
  apicid = lapicid();
80103af0:	e8 bb ee ff ff       	call   801029b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103af5:	8b 35 40 3d 11 80    	mov    0x80113d40,%esi
  apicid = lapicid();
80103afb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103afd:	85 f6                	test   %esi,%esi
80103aff:	7e 2c                	jle    80103b2d <mycpu+0x4d>
80103b01:	31 d2                	xor    %edx,%edx
80103b03:	eb 0a                	jmp    80103b0f <mycpu+0x2f>
80103b05:	8d 76 00             	lea    0x0(%esi),%esi
80103b08:	83 c2 01             	add    $0x1,%edx
80103b0b:	39 f2                	cmp    %esi,%edx
80103b0d:	74 1e                	je     80103b2d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103b0f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b15:	0f b6 81 c0 37 11 80 	movzbl -0x7feec840(%ecx),%eax
80103b1c:	39 d8                	cmp    %ebx,%eax
80103b1e:	75 e8                	jne    80103b08 <mycpu+0x28>
}
80103b20:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b23:	8d 81 c0 37 11 80    	lea    -0x7feec840(%ecx),%eax
}
80103b29:	5b                   	pop    %ebx
80103b2a:	5e                   	pop    %esi
80103b2b:	5d                   	pop    %ebp
80103b2c:	c3                   	ret    
  panic("unknown apicid\n");
80103b2d:	83 ec 0c             	sub    $0xc,%esp
80103b30:	68 c7 7f 10 80       	push   $0x80107fc7
80103b35:	e8 56 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b3a:	83 ec 0c             	sub    $0xc,%esp
80103b3d:	68 08 81 10 80       	push   $0x80108108
80103b42:	e8 49 c8 ff ff       	call   80100390 <panic>
80103b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4e:	66 90                	xchg   %ax,%ax

80103b50 <cpuid>:
cpuid() {
80103b50:	f3 0f 1e fb          	endbr32 
80103b54:	55                   	push   %ebp
80103b55:	89 e5                	mov    %esp,%ebp
80103b57:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b5a:	e8 81 ff ff ff       	call   80103ae0 <mycpu>
}
80103b5f:	c9                   	leave  
  return mycpu()-cpus;
80103b60:	2d c0 37 11 80       	sub    $0x801137c0,%eax
80103b65:	c1 f8 04             	sar    $0x4,%eax
80103b68:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b6e:	c3                   	ret    
80103b6f:	90                   	nop

80103b70 <myproc>:
myproc(void) {
80103b70:	f3 0f 1e fb          	endbr32 
80103b74:	55                   	push   %ebp
80103b75:	89 e5                	mov    %esp,%ebp
80103b77:	53                   	push   %ebx
80103b78:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b7b:	e8 20 10 00 00       	call   80104ba0 <pushcli>
  c = mycpu();
80103b80:	e8 5b ff ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103b85:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b8b:	e8 60 10 00 00       	call   80104bf0 <popcli>
}
80103b90:	83 c4 04             	add    $0x4,%esp
80103b93:	89 d8                	mov    %ebx,%eax
80103b95:	5b                   	pop    %ebx
80103b96:	5d                   	pop    %ebp
80103b97:	c3                   	ret    
80103b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop

80103ba0 <userinit>:
{
80103ba0:	f3 0f 1e fb          	endbr32 
80103ba4:	55                   	push   %ebp
80103ba5:	89 e5                	mov    %esp,%ebp
80103ba7:	53                   	push   %ebx
80103ba8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bab:	e8 d0 fd ff ff       	call   80103980 <allocproc>
80103bb0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bb2:	a3 f8 b5 10 80       	mov    %eax,0x8010b5f8
  if((p->pgdir = setupkvm()) == 0)
80103bb7:	e8 14 3c 00 00       	call   801077d0 <setupkvm>
80103bbc:	89 43 04             	mov    %eax,0x4(%ebx)
80103bbf:	85 c0                	test   %eax,%eax
80103bc1:	0f 84 d6 00 00 00    	je     80103c9d <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80103bc7:	83 ec 04             	sub    $0x4,%esp
80103bca:	68 2c 00 00 00       	push   $0x2c
80103bcf:	68 a0 b4 10 80       	push   $0x8010b4a0
80103bd4:	68 f0 7f 10 80       	push   $0x80107ff0
80103bd9:	e8 d2 ca ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bde:	83 c4 0c             	add    $0xc,%esp
80103be1:	68 2c 00 00 00       	push   $0x2c
80103be6:	68 a0 b4 10 80       	push   $0x8010b4a0
80103beb:	ff 73 04             	pushl  0x4(%ebx)
80103bee:	e8 ad 38 00 00       	call   801074a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bf3:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bf6:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bfc:	6a 4c                	push   $0x4c
80103bfe:	6a 00                	push   $0x0
80103c00:	ff 73 18             	pushl  0x18(%ebx)
80103c03:	e8 a8 11 00 00       	call   80104db0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c08:	8b 43 18             	mov    0x18(%ebx),%eax
80103c0b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c10:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c13:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c18:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c1f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c23:	8b 43 18             	mov    0x18(%ebx),%eax
80103c26:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c2a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c2e:	8b 43 18             	mov    0x18(%ebx),%eax
80103c31:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c35:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c39:	8b 43 18             	mov    0x18(%ebx),%eax
80103c3c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c43:	8b 43 18             	mov    0x18(%ebx),%eax
80103c46:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c4d:	8b 43 18             	mov    0x18(%ebx),%eax
80103c50:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c57:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c5a:	6a 10                	push   $0x10
80103c5c:	68 f7 7f 10 80       	push   $0x80107ff7
80103c61:	50                   	push   %eax
80103c62:	e8 09 13 00 00       	call   80104f70 <safestrcpy>
  p->cwd = namei("/");
80103c67:	c7 04 24 00 80 10 80 	movl   $0x80108000,(%esp)
80103c6e:	e8 bd e3 ff ff       	call   80102030 <namei>
80103c73:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c76:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103c7d:	e8 1e 10 00 00       	call   80104ca0 <acquire>
  p->state = RUNNABLE;
80103c82:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c89:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103c90:	e8 cb 10 00 00       	call   80104d60 <release>
}
80103c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c98:	83 c4 10             	add    $0x10,%esp
80103c9b:	c9                   	leave  
80103c9c:	c3                   	ret    
    panic("userinit: out of memory?");
80103c9d:	83 ec 0c             	sub    $0xc,%esp
80103ca0:	68 d7 7f 10 80       	push   $0x80107fd7
80103ca5:	e8 e6 c6 ff ff       	call   80100390 <panic>
80103caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cb0 <growproc>:
{
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	56                   	push   %esi
80103cb8:	53                   	push   %ebx
80103cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cbc:	e8 df 0e 00 00       	call   80104ba0 <pushcli>
  c = mycpu();
80103cc1:	e8 1a fe ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103cc6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ccc:	e8 1f 0f 00 00       	call   80104bf0 <popcli>
  sz = curproc->sz;
80103cd1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103cd3:	85 f6                	test   %esi,%esi
80103cd5:	7f 19                	jg     80103cf0 <growproc+0x40>
  } else if(n < 0){
80103cd7:	75 37                	jne    80103d10 <growproc+0x60>
  switchuvm(curproc);
80103cd9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cdc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cde:	53                   	push   %ebx
80103cdf:	e8 ac 36 00 00       	call   80107390 <switchuvm>
  return 0;
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	31 c0                	xor    %eax,%eax
}
80103ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cec:	5b                   	pop    %ebx
80103ced:	5e                   	pop    %esi
80103cee:	5d                   	pop    %ebp
80103cef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cf0:	83 ec 04             	sub    $0x4,%esp
80103cf3:	01 c6                	add    %eax,%esi
80103cf5:	56                   	push   %esi
80103cf6:	50                   	push   %eax
80103cf7:	ff 73 04             	pushl  0x4(%ebx)
80103cfa:	e8 f1 38 00 00       	call   801075f0 <allocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	85 c0                	test   %eax,%eax
80103d04:	75 d3                	jne    80103cd9 <growproc+0x29>
      return -1;
80103d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d0b:	eb dc                	jmp    80103ce9 <growproc+0x39>
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d10:	83 ec 04             	sub    $0x4,%esp
80103d13:	01 c6                	add    %eax,%esi
80103d15:	56                   	push   %esi
80103d16:	50                   	push   %eax
80103d17:	ff 73 04             	pushl  0x4(%ebx)
80103d1a:	e8 01 3a 00 00       	call   80107720 <deallocuvm>
80103d1f:	83 c4 10             	add    $0x10,%esp
80103d22:	85 c0                	test   %eax,%eax
80103d24:	75 b3                	jne    80103cd9 <growproc+0x29>
80103d26:	eb de                	jmp    80103d06 <growproc+0x56>
80103d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2f:	90                   	nop

80103d30 <fork>:
{
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	57                   	push   %edi
80103d38:	56                   	push   %esi
80103d39:	53                   	push   %ebx
80103d3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d3d:	e8 5e 0e 00 00       	call   80104ba0 <pushcli>
  c = mycpu();
80103d42:	e8 99 fd ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103d47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d4d:	e8 9e 0e 00 00       	call   80104bf0 <popcli>
  if((np = allocproc()) == 0){
80103d52:	e8 29 fc ff ff       	call   80103980 <allocproc>
80103d57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d5a:	85 c0                	test   %eax,%eax
80103d5c:	0f 84 cd 00 00 00    	je     80103e2f <fork+0xff>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d62:	83 ec 08             	sub    $0x8,%esp
80103d65:	ff 33                	pushl  (%ebx)
80103d67:	89 c7                	mov    %eax,%edi
80103d69:	ff 73 04             	pushl  0x4(%ebx)
80103d6c:	e8 2f 3b 00 00       	call   801078a0 <copyuvm>
80103d71:	83 c4 10             	add    $0x10,%esp
80103d74:	89 47 04             	mov    %eax,0x4(%edi)
80103d77:	85 c0                	test   %eax,%eax
80103d79:	0f 84 b7 00 00 00    	je     80103e36 <fork+0x106>
  np->sz = curproc->sz;
80103d7f:	8b 03                	mov    (%ebx),%eax
80103d81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d89:	89 c8                	mov    %ecx,%eax
80103d8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d93:	8b 73 18             	mov    0x18(%ebx),%esi
80103d96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d9a:	8b 40 18             	mov    0x18(%eax),%eax
80103d9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103da8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103dac:	85 c0                	test   %eax,%eax
80103dae:	74 13                	je     80103dc3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103db0:	83 ec 0c             	sub    $0xc,%esp
80103db3:	50                   	push   %eax
80103db4:	e8 b7 d0 ff ff       	call   80100e70 <filedup>
80103db9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dbc:	83 c4 10             	add    $0x10,%esp
80103dbf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dc3:	83 c6 01             	add    $0x1,%esi
80103dc6:	83 fe 10             	cmp    $0x10,%esi
80103dc9:	75 dd                	jne    80103da8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103dcb:	83 ec 0c             	sub    $0xc,%esp
80103dce:	ff 73 68             	pushl  0x68(%ebx)
80103dd1:	e8 5a d9 ff ff       	call   80101730 <idup>
80103dd6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dd9:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ddc:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ddf:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103de2:	6a 10                	push   $0x10
80103de4:	50                   	push   %eax
80103de5:	8d 47 6c             	lea    0x6c(%edi),%eax
80103de8:	50                   	push   %eax
80103de9:	e8 82 11 00 00       	call   80104f70 <safestrcpy>
  pid = np->pid;
80103dee:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103df1:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103df8:	e8 a3 0e 00 00       	call   80104ca0 <acquire>
  np->state = RUNNABLE;
80103dfd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->priority = curproc->priority; 	// Child Inherits Parent's nice
80103e04:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103e07:	89 47 7c             	mov    %eax,0x7c(%edi)
  np->vruntime = curproc->vruntime;	// Child Inherits Parent's vruntime
80103e0a:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103e10:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
  release(&ptable.lock);
80103e16:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103e1d:	e8 3e 0f 00 00       	call   80104d60 <release>
  return pid;
80103e22:	83 c4 10             	add    $0x10,%esp
}
80103e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e28:	89 f0                	mov    %esi,%eax
80103e2a:	5b                   	pop    %ebx
80103e2b:	5e                   	pop    %esi
80103e2c:	5f                   	pop    %edi
80103e2d:	5d                   	pop    %ebp
80103e2e:	c3                   	ret    
    return -1;
80103e2f:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103e34:	eb ef                	jmp    80103e25 <fork+0xf5>
    kfree(np->kstack);
80103e36:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e39:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103e3c:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103e41:	ff 73 08             	pushl  0x8(%ebx)
80103e44:	e8 37 e7 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80103e49:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e50:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e53:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e5a:	eb c9                	jmp    80103e25 <fork+0xf5>
80103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e60 <nice2weight>:
int nice2weight(int nice){
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
	return nice2weight_arr[idx];
80103e67:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103e6a:	5d                   	pop    %ebp
	return nice2weight_arr[idx];
80103e6b:	8b 04 85 34 b0 10 80 	mov    -0x7fef4fcc(,%eax,4),%eax
}
80103e72:	c3                   	ret    
80103e73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e80 <total_weight_of_runnable_process>:
int total_weight_of_runnable_process(){
80103e80:	f3 0f 1e fb          	endbr32 
	uint ret=0;	
80103e84:	31 d2                	xor    %edx,%edx
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
80103e86:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80103e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e8f:	90                   	nop
	if(p1->state!=RUNNABLE)				// Select RUNNABLE Only
80103e90:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e94:	75 0a                	jne    80103ea0 <total_weight_of_runnable_process+0x20>
	return nice2weight_arr[idx];
80103e96:	8b 48 7c             	mov    0x7c(%eax),%ecx
		ret+=nice2weight(p1->priority);
80103e99:	03 14 8d 34 b0 10 80 	add    -0x7fef4fcc(,%ecx,4),%edx
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
80103ea0:	05 94 00 00 00       	add    $0x94,%eax
80103ea5:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103eaa:	75 e4                	jne    80103e90 <total_weight_of_runnable_process+0x10>
}
80103eac:	89 d0                	mov    %edx,%eax
80103eae:	c3                   	ret    
80103eaf:	90                   	nop

80103eb0 <scheduler>:
{
80103eb0:	f3 0f 1e fb          	endbr32 
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	57                   	push   %edi
80103eb8:	56                   	push   %esi
80103eb9:	53                   	push   %ebx
80103eba:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103ebd:	e8 1e fc ff ff       	call   80103ae0 <mycpu>
  c->proc = 0;
80103ec2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ec9:	00 00 00 
  struct cpu *c = mycpu();
80103ecc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ece:	8d 40 04             	lea    0x4(%eax),%eax
80103ed1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ed4:	eb 28                	jmp    80103efe <scheduler+0x4e>
80103ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edd:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee0:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103ee6:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
80103eec:	72 26                	jb     80103f14 <scheduler+0x64>
    release(&ptable.lock);
80103eee:	83 ec 0c             	sub    $0xc,%esp
80103ef1:	68 60 3d 11 80       	push   $0x80113d60
80103ef6:	e8 65 0e 00 00       	call   80104d60 <release>
  for(;;){
80103efb:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103efe:	fb                   	sti    
    acquire(&ptable.lock);
80103eff:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f02:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
    acquire(&ptable.lock);
80103f07:	68 60 3d 11 80       	push   $0x80113d60
80103f0c:	e8 8f 0d 00 00       	call   80104ca0 <acquire>
80103f11:	83 c4 10             	add    $0x10,%esp
      if(p->state != RUNNABLE)
80103f14:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f18:	75 c6                	jne    80103ee0 <scheduler+0x30>
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
80103f1a:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80103f1f:	90                   	nop
	if(p1->state!=RUNNABLE)				// Select RUNNABLE Only
80103f20:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103f24:	75 0f                	jne    80103f35 <scheduler+0x85>
	if(highP->vruntime > p1->vruntime) // Lower vruntime, Highter Real-Priority
80103f26:	8b b8 84 00 00 00    	mov    0x84(%eax),%edi
80103f2c:	39 bb 84 00 00 00    	cmp    %edi,0x84(%ebx)
80103f32:	0f 4f d8             	cmovg  %eax,%ebx
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
80103f35:	05 94 00 00 00       	add    $0x94,%eax
80103f3a:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103f3f:	75 df                	jne    80103f20 <scheduler+0x70>
      p->runtime_interval=0;
80103f41:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103f48:	00 00 00 
	return nice2weight_arr[idx];
80103f4b:	8b 43 7c             	mov    0x7c(%ebx),%eax
	uint ret=0;	
80103f4e:	31 c9                	xor    %ecx,%ecx
	return nice2weight_arr[idx];
80103f50:	8b 3c 85 34 b0 10 80 	mov    -0x7fef4fcc(,%eax,4),%edi
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
80103f57:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
      p->weight=nice2weight(p->priority);
80103f5c:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
80103f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if(p1->state!=RUNNABLE)				// Select RUNNABLE Only
80103f68:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103f6c:	75 0a                	jne    80103f78 <scheduler+0xc8>
	return nice2weight_arr[idx];
80103f6e:	8b 50 7c             	mov    0x7c(%eax),%edx
		ret+=nice2weight(p1->priority);
80103f71:	03 0c 95 34 b0 10 80 	add    -0x7fef4fcc(,%edx,4),%ecx
      for(p1=ptable.proc; p1< &ptable.proc[NPROC];p1++){ // Traverse All P-Table
80103f78:	05 94 00 00 00       	add    $0x94,%eax
80103f7d:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103f82:	75 e4                	jne    80103f68 <scheduler+0xb8>
      uint weight_by_10 = 10*(p->weight);
80103f84:	8d 04 bf             	lea    (%edi,%edi,4),%eax
      switchuvm(p);
80103f87:	83 ec 0c             	sub    $0xc,%esp
      int time_slice = (10*weight_by_10 + total_weight - 1) / (total_weight); // Ceil(10*W/sum(W))
80103f8a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80103f91:	8d 04 42             	lea    (%edx,%eax,2),%eax
80103f94:	31 d2                	xor    %edx,%edx
80103f96:	8d 44 41 ff          	lea    -0x1(%ecx,%eax,2),%eax
80103f9a:	f7 f1                	div    %ecx
      p->timeslice=time_slice; // Get Time Slice
80103f9c:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
      c->proc = p;
80103fa2:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103fa8:	53                   	push   %ebx
80103fa9:	e8 e2 33 00 00       	call   80107390 <switchuvm>
      p->state = RUNNING;
80103fae:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103fb5:	58                   	pop    %eax
80103fb6:	5a                   	pop    %edx
80103fb7:	ff 73 1c             	pushl  0x1c(%ebx)
80103fba:	ff 75 e4             	pushl  -0x1c(%ebp)
80103fbd:	e8 11 10 00 00       	call   80104fd3 <swtch>
      switchkvm();
80103fc2:	e8 a9 33 00 00       	call   80107370 <switchkvm>
      c->proc = 0;
80103fc7:	83 c4 10             	add    $0x10,%esp
80103fca:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fd1:	00 00 00 
80103fd4:	e9 07 ff ff ff       	jmp    80103ee0 <scheduler+0x30>
80103fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fe0 <sched>:
{// Invoking Dispatcher
80103fe0:	f3 0f 1e fb          	endbr32 
80103fe4:	55                   	push   %ebp
80103fe5:	89 e5                	mov    %esp,%ebp
80103fe7:	56                   	push   %esi
80103fe8:	53                   	push   %ebx
  pushcli();
80103fe9:	e8 b2 0b 00 00       	call   80104ba0 <pushcli>
  c = mycpu();
80103fee:	e8 ed fa ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103ff3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff9:	e8 f2 0b 00 00       	call   80104bf0 <popcli>
  if(!holding(&ptable.lock))
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	68 60 3d 11 80       	push   $0x80113d60
80104006:	e8 45 0c 00 00       	call   80104c50 <holding>
8010400b:	83 c4 10             	add    $0x10,%esp
8010400e:	85 c0                	test   %eax,%eax
80104010:	74 4f                	je     80104061 <sched+0x81>
  if(mycpu()->ncli != 1)
80104012:	e8 c9 fa ff ff       	call   80103ae0 <mycpu>
80104017:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010401e:	75 68                	jne    80104088 <sched+0xa8>
  if(p->state == RUNNING)
80104020:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104024:	74 55                	je     8010407b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104026:	9c                   	pushf  
80104027:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104028:	f6 c4 02             	test   $0x2,%ah
8010402b:	75 41                	jne    8010406e <sched+0x8e>
  intena = mycpu()->intena;
8010402d:	e8 ae fa ff ff       	call   80103ae0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104032:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104035:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010403b:	e8 a0 fa ff ff       	call   80103ae0 <mycpu>
80104040:	83 ec 08             	sub    $0x8,%esp
80104043:	ff 70 04             	pushl  0x4(%eax)
80104046:	53                   	push   %ebx
80104047:	e8 87 0f 00 00       	call   80104fd3 <swtch>
  mycpu()->intena = intena;
8010404c:	e8 8f fa ff ff       	call   80103ae0 <mycpu>
}
80104051:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104054:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010405a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010405d:	5b                   	pop    %ebx
8010405e:	5e                   	pop    %esi
8010405f:	5d                   	pop    %ebp
80104060:	c3                   	ret    
    panic("sched ptable.lock");
80104061:	83 ec 0c             	sub    $0xc,%esp
80104064:	68 02 80 10 80       	push   $0x80108002
80104069:	e8 22 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010406e:	83 ec 0c             	sub    $0xc,%esp
80104071:	68 2e 80 10 80       	push   $0x8010802e
80104076:	e8 15 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
8010407b:	83 ec 0c             	sub    $0xc,%esp
8010407e:	68 20 80 10 80       	push   $0x80108020
80104083:	e8 08 c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 14 80 10 80       	push   $0x80108014
80104090:	e8 fb c2 ff ff       	call   80100390 <panic>
80104095:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040a0 <exit>:
{
801040a0:	f3 0f 1e fb          	endbr32 
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	57                   	push   %edi
801040a8:	56                   	push   %esi
801040a9:	53                   	push   %ebx
801040aa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801040ad:	e8 ee 0a 00 00       	call   80104ba0 <pushcli>
  c = mycpu();
801040b2:	e8 29 fa ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801040b7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040bd:	e8 2e 0b 00 00       	call   80104bf0 <popcli>
  if(curproc == initproc)
801040c2:	8d 5e 28             	lea    0x28(%esi),%ebx
801040c5:	8d 7e 68             	lea    0x68(%esi),%edi
801040c8:	39 35 f8 b5 10 80    	cmp    %esi,0x8010b5f8
801040ce:	0f 84 b5 00 00 00    	je     80104189 <exit+0xe9>
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801040d8:	8b 03                	mov    (%ebx),%eax
801040da:	85 c0                	test   %eax,%eax
801040dc:	74 12                	je     801040f0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801040de:	83 ec 0c             	sub    $0xc,%esp
801040e1:	50                   	push   %eax
801040e2:	e8 d9 cd ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
801040e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040ed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040f0:	83 c3 04             	add    $0x4,%ebx
801040f3:	39 fb                	cmp    %edi,%ebx
801040f5:	75 e1                	jne    801040d8 <exit+0x38>
  begin_op();
801040f7:	e8 44 ed ff ff       	call   80102e40 <begin_op>
  iput(curproc->cwd);
801040fc:	83 ec 0c             	sub    $0xc,%esp
801040ff:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104102:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
  iput(curproc->cwd);
80104107:	e8 84 d7 ff ff       	call   80101890 <iput>
  end_op();
8010410c:	e8 9f ed ff ff       	call   80102eb0 <end_op>
  curproc->cwd = 0;
80104111:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104118:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
8010411f:	e8 7c 0b 00 00       	call   80104ca0 <acquire>
  wakeup1(curproc->parent);
80104124:	8b 46 14             	mov    0x14(%esi),%eax
80104127:	e8 74 f7 ff ff       	call   801038a0 <wakeup1>
8010412c:	83 c4 10             	add    $0x10,%esp
8010412f:	eb 15                	jmp    80104146 <exit+0xa6>
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104138:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010413e:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
80104144:	74 2a                	je     80104170 <exit+0xd0>
    if(p->parent == curproc){
80104146:	39 73 14             	cmp    %esi,0x14(%ebx)
80104149:	75 ed                	jne    80104138 <exit+0x98>
      p->parent = initproc;
8010414b:	a1 f8 b5 10 80       	mov    0x8010b5f8,%eax
      if(p->state == ZOMBIE)
80104150:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
80104154:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80104157:	75 df                	jne    80104138 <exit+0x98>
        wakeup1(initproc);
80104159:	e8 42 f7 ff ff       	call   801038a0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415e:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104164:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
8010416a:	75 da                	jne    80104146 <exit+0xa6>
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80104170:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104177:	e8 64 fe ff ff       	call   80103fe0 <sched>
  panic("zombie exit");
8010417c:	83 ec 0c             	sub    $0xc,%esp
8010417f:	68 4f 80 10 80       	push   $0x8010804f
80104184:	e8 07 c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104189:	83 ec 0c             	sub    $0xc,%esp
8010418c:	68 42 80 10 80       	push   $0x80108042
80104191:	e8 fa c1 ff ff       	call   80100390 <panic>
80104196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419d:	8d 76 00             	lea    0x0(%esi),%esi

801041a0 <yield>:
{
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	53                   	push   %ebx
801041a8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041ab:	68 60 3d 11 80       	push   $0x80113d60
801041b0:	e8 eb 0a 00 00       	call   80104ca0 <acquire>
  pushcli();
801041b5:	e8 e6 09 00 00       	call   80104ba0 <pushcli>
  c = mycpu();
801041ba:	e8 21 f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801041bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041c5:	e8 26 0a 00 00       	call   80104bf0 <popcli>
  myproc()->state = RUNNABLE;
801041ca:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041d1:	e8 0a fe ff ff       	call   80103fe0 <sched>
  release(&ptable.lock);
801041d6:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801041dd:	e8 7e 0b 00 00       	call   80104d60 <release>
}
801041e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	c9                   	leave  
801041e9:	c3                   	ret    
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <sleep>:
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	57                   	push   %edi
801041f8:	56                   	push   %esi
801041f9:	53                   	push   %ebx
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	8b 7d 08             	mov    0x8(%ebp),%edi
80104200:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104203:	e8 98 09 00 00       	call   80104ba0 <pushcli>
  c = mycpu();
80104208:	e8 d3 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
8010420d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104213:	e8 d8 09 00 00       	call   80104bf0 <popcli>
  if(p == 0)
80104218:	85 db                	test   %ebx,%ebx
8010421a:	0f 84 83 00 00 00    	je     801042a3 <sleep+0xb3>
  if(lk == 0)
80104220:	85 f6                	test   %esi,%esi
80104222:	74 72                	je     80104296 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104224:	81 fe 60 3d 11 80    	cmp    $0x80113d60,%esi
8010422a:	74 4c                	je     80104278 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010422c:	83 ec 0c             	sub    $0xc,%esp
8010422f:	68 60 3d 11 80       	push   $0x80113d60
80104234:	e8 67 0a 00 00       	call   80104ca0 <acquire>
    release(lk);
80104239:	89 34 24             	mov    %esi,(%esp)
8010423c:	e8 1f 0b 00 00       	call   80104d60 <release>
  p->chan = chan;
80104241:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104244:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010424b:	e8 90 fd ff ff       	call   80103fe0 <sched>
  p->chan = 0;
80104250:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104257:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
8010425e:	e8 fd 0a 00 00       	call   80104d60 <release>
    acquire(lk);
80104263:	89 75 08             	mov    %esi,0x8(%ebp)
80104266:	83 c4 10             	add    $0x10,%esp
}
80104269:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010426c:	5b                   	pop    %ebx
8010426d:	5e                   	pop    %esi
8010426e:	5f                   	pop    %edi
8010426f:	5d                   	pop    %ebp
    acquire(lk);
80104270:	e9 2b 0a 00 00       	jmp    80104ca0 <acquire>
80104275:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104278:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010427b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104282:	e8 59 fd ff ff       	call   80103fe0 <sched>
  p->chan = 0;
80104287:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010428e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104291:	5b                   	pop    %ebx
80104292:	5e                   	pop    %esi
80104293:	5f                   	pop    %edi
80104294:	5d                   	pop    %ebp
80104295:	c3                   	ret    
    panic("sleep without lk");
80104296:	83 ec 0c             	sub    $0xc,%esp
80104299:	68 61 80 10 80       	push   $0x80108061
8010429e:	e8 ed c0 ff ff       	call   80100390 <panic>
    panic("sleep");
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	68 5b 80 10 80       	push   $0x8010805b
801042ab:	e8 e0 c0 ff ff       	call   80100390 <panic>

801042b0 <wait>:
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	56                   	push   %esi
801042b8:	53                   	push   %ebx
  pushcli();
801042b9:	e8 e2 08 00 00       	call   80104ba0 <pushcli>
  c = mycpu();
801042be:	e8 1d f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801042c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042c9:	e8 22 09 00 00       	call   80104bf0 <popcli>
  acquire(&ptable.lock);
801042ce:	83 ec 0c             	sub    $0xc,%esp
801042d1:	68 60 3d 11 80       	push   $0x80113d60
801042d6:	e8 c5 09 00 00       	call   80104ca0 <acquire>
801042db:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042de:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e0:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
801042e5:	eb 17                	jmp    801042fe <wait+0x4e>
801042e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ee:	66 90                	xchg   %ax,%ax
801042f0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801042f6:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
801042fc:	74 1e                	je     8010431c <wait+0x6c>
      if(p->parent != curproc)
801042fe:	39 73 14             	cmp    %esi,0x14(%ebx)
80104301:	75 ed                	jne    801042f0 <wait+0x40>
      if(p->state == ZOMBIE){
80104303:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104307:	74 37                	je     80104340 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104309:	81 c3 94 00 00 00    	add    $0x94,%ebx
      havekids = 1;
8010430f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104314:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
8010431a:	75 e2                	jne    801042fe <wait+0x4e>
    if(!havekids || curproc->killed){
8010431c:	85 c0                	test   %eax,%eax
8010431e:	74 76                	je     80104396 <wait+0xe6>
80104320:	8b 46 24             	mov    0x24(%esi),%eax
80104323:	85 c0                	test   %eax,%eax
80104325:	75 6f                	jne    80104396 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104327:	83 ec 08             	sub    $0x8,%esp
8010432a:	68 60 3d 11 80       	push   $0x80113d60
8010432f:	56                   	push   %esi
80104330:	e8 bb fe ff ff       	call   801041f0 <sleep>
    havekids = 0;
80104335:	83 c4 10             	add    $0x10,%esp
80104338:	eb a4                	jmp    801042de <wait+0x2e>
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104340:	83 ec 0c             	sub    $0xc,%esp
80104343:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104346:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104349:	e8 32 e2 ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
8010434e:	5a                   	pop    %edx
8010434f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104352:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104359:	e8 f2 33 00 00       	call   80107750 <freevm>
        release(&ptable.lock);
8010435e:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
        p->pid = 0;
80104365:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010436c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104373:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104377:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010437e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104385:	e8 d6 09 00 00       	call   80104d60 <release>
        return pid;
8010438a:	83 c4 10             	add    $0x10,%esp
}
8010438d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104390:	89 f0                	mov    %esi,%eax
80104392:	5b                   	pop    %ebx
80104393:	5e                   	pop    %esi
80104394:	5d                   	pop    %ebp
80104395:	c3                   	ret    
      release(&ptable.lock);
80104396:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104399:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010439e:	68 60 3d 11 80       	push   $0x80113d60
801043a3:	e8 b8 09 00 00       	call   80104d60 <release>
      return -1;
801043a8:	83 c4 10             	add    $0x10,%esp
801043ab:	eb e0                	jmp    8010438d <wait+0xdd>
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043b0:	f3 0f 1e fb          	endbr32 
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	53                   	push   %ebx
801043b8:	83 ec 10             	sub    $0x10,%esp
801043bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043be:	68 60 3d 11 80       	push   $0x80113d60
801043c3:	e8 d8 08 00 00       	call   80104ca0 <acquire>
  wakeup1(chan);
801043c8:	89 d8                	mov    %ebx,%eax
801043ca:	e8 d1 f4 ff ff       	call   801038a0 <wakeup1>
  release(&ptable.lock);
801043cf:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
801043d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
801043d9:	83 c4 10             	add    $0x10,%esp
}
801043dc:	c9                   	leave  
  release(&ptable.lock);
801043dd:	e9 7e 09 00 00       	jmp    80104d60 <release>
801043e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043f0:	f3 0f 1e fb          	endbr32 
801043f4:	55                   	push   %ebp
801043f5:	89 e5                	mov    %esp,%ebp
801043f7:	53                   	push   %ebx
801043f8:	83 ec 10             	sub    $0x10,%esp
801043fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043fe:	68 60 3d 11 80       	push   $0x80113d60
80104403:	e8 98 08 00 00       	call   80104ca0 <acquire>
80104408:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010440b:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80104410:	eb 12                	jmp    80104424 <kill+0x34>
80104412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104418:	05 94 00 00 00       	add    $0x94,%eax
8010441d:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80104422:	74 34                	je     80104458 <kill+0x68>
    if(p->pid == pid){
80104424:	39 58 10             	cmp    %ebx,0x10(%eax)
80104427:	75 ef                	jne    80104418 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104429:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010442d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104434:	75 07                	jne    8010443d <kill+0x4d>
        p->state = RUNNABLE;
80104436:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010443d:	83 ec 0c             	sub    $0xc,%esp
80104440:	68 60 3d 11 80       	push   $0x80113d60
80104445:	e8 16 09 00 00       	call   80104d60 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010444a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010444d:	83 c4 10             	add    $0x10,%esp
80104450:	31 c0                	xor    %eax,%eax
}
80104452:	c9                   	leave  
80104453:	c3                   	ret    
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	68 60 3d 11 80       	push   $0x80113d60
80104460:	e8 fb 08 00 00       	call   80104d60 <release>
}
80104465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104468:	83 c4 10             	add    $0x10,%esp
8010446b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104470:	c9                   	leave  
80104471:	c3                   	ret    
80104472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	57                   	push   %edi
80104488:	56                   	push   %esi
80104489:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010448c:	53                   	push   %ebx
8010448d:	bb 00 3e 11 80       	mov    $0x80113e00,%ebx
80104492:	83 ec 3c             	sub    $0x3c,%esp
80104495:	eb 2b                	jmp    801044c2 <procdump+0x42>
80104497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044a0:	83 ec 0c             	sub    $0xc,%esp
801044a3:	68 bb 80 10 80       	push   $0x801080bb
801044a8:	e8 03 c2 ff ff       	call   801006b0 <cprintf>
801044ad:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801044b6:	81 fb 00 63 11 80    	cmp    $0x80116300,%ebx
801044bc:	0f 84 8e 00 00 00    	je     80104550 <procdump+0xd0>
    if(p->state == UNUSED)
801044c2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044c5:	85 c0                	test   %eax,%eax
801044c7:	74 e7                	je     801044b0 <procdump+0x30>
      state = "???";
801044c9:	ba 72 80 10 80       	mov    $0x80108072,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044ce:	83 f8 05             	cmp    $0x5,%eax
801044d1:	77 11                	ja     801044e4 <procdump+0x64>
801044d3:	8b 14 85 30 81 10 80 	mov    -0x7fef7ed0(,%eax,4),%edx
      state = "???";
801044da:	b8 72 80 10 80       	mov    $0x80108072,%eax
801044df:	85 d2                	test   %edx,%edx
801044e1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044e4:	53                   	push   %ebx
801044e5:	52                   	push   %edx
801044e6:	ff 73 a4             	pushl  -0x5c(%ebx)
801044e9:	68 76 80 10 80       	push   $0x80108076
801044ee:	e8 bd c1 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801044f3:	83 c4 10             	add    $0x10,%esp
801044f6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044fa:	75 a4                	jne    801044a0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044fc:	83 ec 08             	sub    $0x8,%esp
801044ff:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104502:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104505:	50                   	push   %eax
80104506:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104509:	8b 40 0c             	mov    0xc(%eax),%eax
8010450c:	83 c0 08             	add    $0x8,%eax
8010450f:	50                   	push   %eax
80104510:	e8 2b 06 00 00       	call   80104b40 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104515:	83 c4 10             	add    $0x10,%esp
80104518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451f:	90                   	nop
80104520:	8b 17                	mov    (%edi),%edx
80104522:	85 d2                	test   %edx,%edx
80104524:	0f 84 76 ff ff ff    	je     801044a0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010452a:	83 ec 08             	sub    $0x8,%esp
8010452d:	83 c7 04             	add    $0x4,%edi
80104530:	52                   	push   %edx
80104531:	68 a1 7a 10 80       	push   $0x80107aa1
80104536:	e8 75 c1 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010453b:	83 c4 10             	add    $0x10,%esp
8010453e:	39 fe                	cmp    %edi,%esi
80104540:	75 de                	jne    80104520 <procdump+0xa0>
80104542:	e9 59 ff ff ff       	jmp    801044a0 <procdump+0x20>
80104547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454e:	66 90                	xchg   %ax,%ax
  }
}
80104550:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104553:	5b                   	pop    %ebx
80104554:	5e                   	pop    %esi
80104555:	5f                   	pop    %edi
80104556:	5d                   	pop    %ebp
80104557:	c3                   	ret    
80104558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop

80104560 <setnice>:

// My code
int setnice(int pid, int nice){ // Set Process Priority, Args: PID, Nice, Return val: fail->-1 success->0
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	56                   	push   %esi
80104568:	8b 75 0c             	mov    0xc(%ebp),%esi
8010456b:	53                   	push   %ebx
8010456c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc* p;
	int success=0;
	if(nice<-5 || nice>5) return -1;
8010456f:	8d 46 05             	lea    0x5(%esi),%eax
80104572:	83 f8 0a             	cmp    $0xa,%eax
80104575:	77 65                	ja     801045dc <setnice+0x7c>
	acquire(&ptable.lock);
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	68 60 3d 11 80       	push   $0x80113d60
8010457f:	e8 1c 07 00 00       	call   80104ca0 <acquire>
80104584:	83 c4 10             	add    $0x10,%esp
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
80104587:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
8010458c:	eb 0e                	jmp    8010459c <setnice+0x3c>
8010458e:	66 90                	xchg   %ax,%ax
80104590:	05 94 00 00 00       	add    $0x94,%eax
80104595:	3d 94 62 11 80       	cmp    $0x80116294,%eax
8010459a:	74 24                	je     801045c0 <setnice+0x60>
		if(p->pid==pid){
8010459c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010459f:	75 ef                	jne    80104590 <setnice+0x30>
			p->priority=nice;
			success=1;
			break;
		}
	}
	release(&ptable.lock);
801045a1:	83 ec 0c             	sub    $0xc,%esp
			p->priority=nice;
801045a4:	89 70 7c             	mov    %esi,0x7c(%eax)
	release(&ptable.lock);
801045a7:	68 60 3d 11 80       	push   $0x80113d60
801045ac:	e8 af 07 00 00       	call   80104d60 <release>
801045b1:	83 c4 10             	add    $0x10,%esp
//	cprintf("SETNICE returned %d\n",success);
	if(success) return 0;
801045b4:	31 c0                	xor    %eax,%eax
	else return -1;
}
801045b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b9:	5b                   	pop    %ebx
801045ba:	5e                   	pop    %esi
801045bb:	5d                   	pop    %ebp
801045bc:	c3                   	ret    
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
	release(&ptable.lock);
801045c0:	83 ec 0c             	sub    $0xc,%esp
801045c3:	68 60 3d 11 80       	push   $0x80113d60
801045c8:	e8 93 07 00 00       	call   80104d60 <release>
	else return -1;
801045cd:	83 c4 10             	add    $0x10,%esp
}
801045d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
	else return -1;
801045d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045d8:	5b                   	pop    %ebx
801045d9:	5e                   	pop    %esi
801045da:	5d                   	pop    %ebp
801045db:	c3                   	ret    
	if(nice<-5 || nice>5) return -1;
801045dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045e1:	eb d3                	jmp    801045b6 <setnice+0x56>
801045e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <getnice>:

int getnice(int pid){ // Return Process Priority, Args: PID, Return value: Can't find PID -> -1, else nice
801045f0:	f3 0f 1e fb          	endbr32 
801045f4:	55                   	push   %ebp
801045f5:	89 e5                	mov    %esp,%ebp
801045f7:	57                   	push   %edi
	struct proc* p;
	int ret=0;
	int success=0;
801045f8:	31 ff                	xor    %edi,%edi
int getnice(int pid){ // Return Process Priority, Args: PID, Return value: Can't find PID -> -1, else nice
801045fa:	56                   	push   %esi
	int ret=0;
801045fb:	31 f6                	xor    %esi,%esi
int getnice(int pid){ // Return Process Priority, Args: PID, Return value: Can't find PID -> -1, else nice
801045fd:	53                   	push   %ebx
801045fe:	83 ec 18             	sub    $0x18,%esp
80104601:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
80104604:	68 60 3d 11 80       	push   $0x80113d60
80104609:	e8 92 06 00 00       	call   80104ca0 <acquire>
8010460e:	83 c4 10             	add    $0x10,%esp
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
80104611:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80104616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
		if(p->pid==pid){
80104620:	39 58 10             	cmp    %ebx,0x10(%eax)
80104623:	75 08                	jne    8010462d <getnice+0x3d>
			ret=p->priority;
80104625:	8b 70 7c             	mov    0x7c(%eax),%esi
			success=1;
80104628:	bf 01 00 00 00       	mov    $0x1,%edi
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
8010462d:	05 94 00 00 00       	add    $0x94,%eax
80104632:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80104637:	75 e7                	jne    80104620 <getnice+0x30>
		}
	}
	release(&ptable.lock);
80104639:	83 ec 0c             	sub    $0xc,%esp
8010463c:	68 60 3d 11 80       	push   $0x80113d60
80104641:	e8 1a 07 00 00       	call   80104d60 <release>
//	cprintf("GETNICE returned %d with success %d\n",ret,success);
	if(success) return ret;
80104646:	83 c4 10             	add    $0x10,%esp
	else return -1;
80104649:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010464e:	85 ff                	test   %edi,%edi
80104650:	0f 44 f0             	cmove  %eax,%esi
}
80104653:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104656:	5b                   	pop    %ebx
80104657:	89 f0                	mov    %esi,%eax
80104659:	5e                   	pop    %esi
8010465a:	5f                   	pop    %edi
8010465b:	5d                   	pop    %ebp
8010465c:	c3                   	ret    
8010465d:	8d 76 00             	lea    0x0(%esi),%esi

80104660 <str_align_print>:

void str_align_print(char* str){ // print %10s
80104660:	f3 0f 1e fb          	endbr32 
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	56                   	push   %esi
80104668:	8b 45 08             	mov    0x8(%ebp),%eax
8010466b:	53                   	push   %ebx
	const int width = 15;
	int length=0;
	while(str[length]!=0){
8010466c:	80 38 00             	cmpb   $0x0,(%eax)
8010466f:	74 4f                	je     801046c0 <str_align_print+0x60>
	int length=0;
80104671:	31 f6                	xor    %esi,%esi
80104673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104677:	90                   	nop
		length++;
80104678:	83 c6 01             	add    $0x1,%esi
	while(str[length]!=0){
8010467b:	80 3c 30 00          	cmpb   $0x0,(%eax,%esi,1)
8010467f:	75 f7                	jne    80104678 <str_align_print+0x18>
	}
	int diff = width - length;
	cprintf("%s",str);
80104681:	83 ec 08             	sub    $0x8,%esp
	while(diff--){
80104684:	bb 0e 00 00 00       	mov    $0xe,%ebx
	cprintf("%s",str);
80104689:	50                   	push   %eax
	while(diff--){
8010468a:	29 f3                	sub    %esi,%ebx
	cprintf("%s",str);
8010468c:	68 7c 80 10 80       	push   $0x8010807c
80104691:	e8 1a c0 ff ff       	call   801006b0 <cprintf>
	while(diff--){
80104696:	83 c4 10             	add    $0x10,%esp
80104699:	83 fe 0f             	cmp    $0xf,%esi
8010469c:	74 1a                	je     801046b8 <str_align_print+0x58>
8010469e:	66 90                	xchg   %ax,%ax
		cprintf(" ");
801046a0:	83 ec 0c             	sub    $0xc,%esp
	while(diff--){
801046a3:	83 eb 01             	sub    $0x1,%ebx
		cprintf(" ");
801046a6:	68 ff 80 10 80       	push   $0x801080ff
801046ab:	e8 00 c0 ff ff       	call   801006b0 <cprintf>
	while(diff--){
801046b0:	83 c4 10             	add    $0x10,%esp
801046b3:	83 fb ff             	cmp    $0xffffffff,%ebx
801046b6:	75 e8                	jne    801046a0 <str_align_print+0x40>
	}
}
801046b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046bb:	5b                   	pop    %ebx
801046bc:	5e                   	pop    %esi
801046bd:	5d                   	pop    %ebp
801046be:	c3                   	ret    
801046bf:	90                   	nop
	cprintf("%s",str);
801046c0:	83 ec 08             	sub    $0x8,%esp
	while(diff--){
801046c3:	bb 0e 00 00 00       	mov    $0xe,%ebx
	cprintf("%s",str);
801046c8:	50                   	push   %eax
801046c9:	68 7c 80 10 80       	push   $0x8010807c
801046ce:	e8 dd bf ff ff       	call   801006b0 <cprintf>
801046d3:	83 c4 10             	add    $0x10,%esp
801046d6:	eb c8                	jmp    801046a0 <str_align_print+0x40>
801046d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <int_align_print>:

void int_align_print(int num){ // print %10d
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	57                   	push   %edi
801046e8:	56                   	push   %esi
801046e9:	53                   	push   %ebx
801046ea:	83 ec 0c             	sub    $0xc,%esp
801046ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	const int width = 15;
	int maxdigit=0;
	int tmp = num;
	while(tmp!=0){
801046f0:	85 ff                	test   %edi,%edi
801046f2:	74 5c                	je     80104750 <int_align_print+0x70>
801046f4:	89 f9                	mov    %edi,%ecx
	int maxdigit=0;
801046f6:	31 db                	xor    %ebx,%ebx
		tmp/=10;
801046f8:	be 67 66 66 66       	mov    $0x66666667,%esi
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
80104700:	89 c8                	mov    %ecx,%eax
80104702:	c1 f9 1f             	sar    $0x1f,%ecx
		maxdigit++;
80104705:	83 c3 01             	add    $0x1,%ebx
		tmp/=10;
80104708:	f7 ee                	imul   %esi
8010470a:	c1 fa 02             	sar    $0x2,%edx
	while(tmp!=0){
8010470d:	29 ca                	sub    %ecx,%edx
8010470f:	89 d1                	mov    %edx,%ecx
80104711:	75 ed                	jne    80104700 <int_align_print+0x20>
	}
	if(num==0)
		maxdigit=1;
	int diff = width - maxdigit;
	cprintf("%d",num);
80104713:	83 ec 08             	sub    $0x8,%esp
	while(diff--){
80104716:	be 0e 00 00 00       	mov    $0xe,%esi
	cprintf("%d",num);
8010471b:	57                   	push   %edi
	while(diff--){
8010471c:	29 de                	sub    %ebx,%esi
	cprintf("%d",num);
8010471e:	68 7f 80 10 80       	push   $0x8010807f
80104723:	e8 88 bf ff ff       	call   801006b0 <cprintf>
	while(diff--){
80104728:	83 c4 10             	add    $0x10,%esp
8010472b:	83 fb 0f             	cmp    $0xf,%ebx
8010472e:	74 18                	je     80104748 <int_align_print+0x68>
		cprintf(" ");
80104730:	83 ec 0c             	sub    $0xc,%esp
	while(diff--){
80104733:	83 ee 01             	sub    $0x1,%esi
		cprintf(" ");
80104736:	68 ff 80 10 80       	push   $0x801080ff
8010473b:	e8 70 bf ff ff       	call   801006b0 <cprintf>
	while(diff--){
80104740:	83 c4 10             	add    $0x10,%esp
80104743:	83 fe ff             	cmp    $0xffffffff,%esi
80104746:	75 e8                	jne    80104730 <int_align_print+0x50>
	}
}
80104748:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474b:	5b                   	pop    %ebx
8010474c:	5e                   	pop    %esi
8010474d:	5f                   	pop    %edi
8010474e:	5d                   	pop    %ebp
8010474f:	c3                   	ret    
	cprintf("%d",num);
80104750:	83 ec 08             	sub    $0x8,%esp
	while(diff--){
80104753:	be 0d 00 00 00       	mov    $0xd,%esi
	cprintf("%d",num);
80104758:	6a 00                	push   $0x0
8010475a:	68 7f 80 10 80       	push   $0x8010807f
8010475f:	e8 4c bf ff ff       	call   801006b0 <cprintf>
80104764:	83 c4 10             	add    $0x10,%esp
80104767:	eb c7                	jmp    80104730 <int_align_print+0x50>
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104770 <align_print>:

void align_print(struct proc* p, char* status){
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	56                   	push   %esi
80104778:	53                   	push   %ebx
80104779:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010477c:	8b 75 0c             	mov    0xc(%ebp),%esi
	str_align_print(p->name);
8010477f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104782:	83 ec 0c             	sub    $0xc,%esp
80104785:	50                   	push   %eax
80104786:	e8 d5 fe ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
8010478b:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
80104792:	e8 19 bf ff ff       	call   801006b0 <cprintf>
	int_align_print(p->pid);
80104797:	58                   	pop    %eax
80104798:	ff 73 10             	pushl  0x10(%ebx)
8010479b:	e8 40 ff ff ff       	call   801046e0 <int_align_print>
	cprintf(" ");
801047a0:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
801047a7:	e8 04 bf ff ff       	call   801006b0 <cprintf>
	str_align_print(status);
801047ac:	89 34 24             	mov    %esi,(%esp)
801047af:	e8 ac fe ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
801047b4:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
801047bb:	e8 f0 be ff ff       	call   801006b0 <cprintf>
	int_align_print(p->priority);
801047c0:	5a                   	pop    %edx
801047c1:	ff 73 7c             	pushl  0x7c(%ebx)
801047c4:	e8 17 ff ff ff       	call   801046e0 <int_align_print>
	cprintf(" ");
801047c9:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
801047d0:	e8 db be ff ff       	call   801006b0 <cprintf>
	return nice2weight_arr[idx];
801047d5:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
	int_align_print(p->runtime / nice2weight(p->priority));
801047d8:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801047de:	31 d2                	xor    %edx,%edx
801047e0:	f7 34 8d 34 b0 10 80 	divl   -0x7fef4fcc(,%ecx,4)
801047e7:	89 04 24             	mov    %eax,(%esp)
801047ea:	e8 f1 fe ff ff       	call   801046e0 <int_align_print>
	cprintf(" ");
801047ef:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
801047f6:	e8 b5 be ff ff       	call   801006b0 <cprintf>
	int_align_print(p->runtime);
801047fb:	59                   	pop    %ecx
801047fc:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80104802:	e8 d9 fe ff ff       	call   801046e0 <int_align_print>
	cprintf(" ");
80104807:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
8010480e:	e8 9d be ff ff       	call   801006b0 <cprintf>
	int_align_print(p->vruntime);
80104813:	5e                   	pop    %esi
80104814:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
8010481a:	e8 c1 fe ff ff       	call   801046e0 <int_align_print>
	cprintf("\n");
8010481f:	c7 45 08 bb 80 10 80 	movl   $0x801080bb,0x8(%ebp)
80104826:	83 c4 10             	add    $0x10,%esp
}
80104829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010482c:	5b                   	pop    %ebx
8010482d:	5e                   	pop    %esi
8010482e:	5d                   	pop    %ebp
	cprintf("\n");
8010482f:	e9 7c be ff ff       	jmp    801006b0 <cprintf>
80104834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop

80104840 <align_print_init>:
void align_print_init(){
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	83 ec 14             	sub    $0x14,%esp
	str_align_print("name");
8010484a:	68 82 80 10 80       	push   $0x80108082
8010484f:	e8 0c fe ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
80104854:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
8010485b:	e8 50 be ff ff       	call   801006b0 <cprintf>
	str_align_print("pid");
80104860:	c7 04 24 87 80 10 80 	movl   $0x80108087,(%esp)
80104867:	e8 f4 fd ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
8010486c:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
80104873:	e8 38 be ff ff       	call   801006b0 <cprintf>
	str_align_print("state");
80104878:	c7 04 24 8b 80 10 80 	movl   $0x8010808b,(%esp)
8010487f:	e8 dc fd ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
80104884:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
8010488b:	e8 20 be ff ff       	call   801006b0 <cprintf>
	str_align_print("priority");
80104890:	c7 04 24 91 80 10 80 	movl   $0x80108091,(%esp)
80104897:	e8 c4 fd ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
8010489c:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
801048a3:	e8 08 be ff ff       	call   801006b0 <cprintf>
	str_align_print("runtime/weight");
801048a8:	c7 04 24 9a 80 10 80 	movl   $0x8010809a,(%esp)
801048af:	e8 ac fd ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
801048b4:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
801048bb:	e8 f0 bd ff ff       	call   801006b0 <cprintf>
	str_align_print("runtime");
801048c0:	c7 04 24 aa 80 10 80 	movl   $0x801080aa,(%esp)
801048c7:	e8 94 fd ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
801048cc:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
801048d3:	e8 d8 bd ff ff       	call   801006b0 <cprintf>
	str_align_print("vruntime");
801048d8:	c7 04 24 a9 80 10 80 	movl   $0x801080a9,(%esp)
801048df:	e8 7c fd ff ff       	call   80104660 <str_align_print>
	cprintf(" ");
801048e4:	c7 04 24 ff 80 10 80 	movl   $0x801080ff,(%esp)
801048eb:	e8 c0 bd ff ff       	call   801006b0 <cprintf>
	cprintf("tick: %d \n", ticks);
801048f0:	58                   	pop    %eax
801048f1:	5a                   	pop    %edx
801048f2:	ff 35 e0 6a 11 80    	pushl  0x80116ae0
801048f8:	68 b2 80 10 80       	push   $0x801080b2
801048fd:	e8 ae bd ff ff       	call   801006b0 <cprintf>
}
80104902:	83 c4 10             	add    $0x10,%esp
80104905:	c9                   	leave  
80104906:	c3                   	ret    
80104907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490e:	66 90                	xchg   %ax,%ax

80104910 <ps>:

void ps(){
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	53                   	push   %ebx
80104918:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
8010491b:	fb                   	sti    
	struct proc* p;
	sti();
	acquire(&ptable.lock);
8010491c:	68 60 3d 11 80       	push   $0x80113d60
	p=ptable.proc;
80104921:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
	acquire(&ptable.lock);
80104926:	e8 75 03 00 00       	call   80104ca0 <acquire>
/*	cprintf("name \t\t pid \t\t state \t\t priority \t\t runtime/weight \t\t \
			runtime \t\t vruntime \t\t tick: %d \n",ticks * 1000);
*/
	align_print_init();
8010492b:	e8 10 ff ff ff       	call   80104840 <align_print_init>
80104930:	83 c4 10             	add    $0x10,%esp
80104933:	eb 24                	jmp    80104959 <ps+0x49>
80104935:	8d 76 00             	lea    0x0(%esi),%esi
	for(;p<&ptable.proc[NPROC];p++){
		if(p->state==SLEEPING){
			align_print(p,"SLEEPING");
		}
		else if(p->state==RUNNING){
80104938:	83 f8 04             	cmp    $0x4,%eax
8010493b:	74 5b                	je     80104998 <ps+0x88>
			align_print(p,"RUNNING");
		}
		else if(p->state==RUNNABLE){
8010493d:	83 f8 03             	cmp    $0x3,%eax
80104940:	74 6e                	je     801049b0 <ps+0xa0>
//			cprintf("%s \t %d \t UNUSED \t %d \t\t %d\n ", p->name, p->pid, p->priority, p->runtime);
//		}
//		else if(p->state==EMBRYO){
//			align_print(p,"EMBRYO");
//		}
		else if(p->state==ZOMBIE){
80104942:	83 f8 05             	cmp    $0x5,%eax
80104945:	0f 84 7d 00 00 00    	je     801049c8 <ps+0xb8>
	for(;p<&ptable.proc[NPROC];p++){
8010494b:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104951:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
80104957:	74 27                	je     80104980 <ps+0x70>
		if(p->state==SLEEPING){
80104959:	8b 43 0c             	mov    0xc(%ebx),%eax
8010495c:	83 f8 02             	cmp    $0x2,%eax
8010495f:	75 d7                	jne    80104938 <ps+0x28>
			align_print(p,"SLEEPING");
80104961:	83 ec 08             	sub    $0x8,%esp
80104964:	68 bd 80 10 80       	push   $0x801080bd
80104969:	53                   	push   %ebx
	for(;p<&ptable.proc[NPROC];p++){
8010496a:	81 c3 94 00 00 00    	add    $0x94,%ebx
			align_print(p,"SLEEPING");
80104970:	e8 fb fd ff ff       	call   80104770 <align_print>
80104975:	83 c4 10             	add    $0x10,%esp
	for(;p<&ptable.proc[NPROC];p++){
80104978:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
8010497e:	75 d9                	jne    80104959 <ps+0x49>
			align_print(p,"ZOMBIE");
		}
	}
//	cprintf("ps command ENDED\n");
	release(&ptable.lock);
80104980:	83 ec 0c             	sub    $0xc,%esp
80104983:	68 60 3d 11 80       	push   $0x80113d60
80104988:	e8 d3 03 00 00       	call   80104d60 <release>
	return;
}
8010498d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	return;
80104990:	83 c4 10             	add    $0x10,%esp
}
80104993:	c9                   	leave  
80104994:	c3                   	ret    
80104995:	8d 76 00             	lea    0x0(%esi),%esi
			align_print(p,"RUNNING");
80104998:	83 ec 08             	sub    $0x8,%esp
8010499b:	68 c6 80 10 80       	push   $0x801080c6
801049a0:	53                   	push   %ebx
801049a1:	e8 ca fd ff ff       	call   80104770 <align_print>
801049a6:	83 c4 10             	add    $0x10,%esp
801049a9:	eb a0                	jmp    8010494b <ps+0x3b>
801049ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049af:	90                   	nop
			align_print(p,"RUNNABLE");
801049b0:	83 ec 08             	sub    $0x8,%esp
801049b3:	68 ce 80 10 80       	push   $0x801080ce
801049b8:	53                   	push   %ebx
801049b9:	e8 b2 fd ff ff       	call   80104770 <align_print>
801049be:	83 c4 10             	add    $0x10,%esp
801049c1:	eb 88                	jmp    8010494b <ps+0x3b>
801049c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049c7:	90                   	nop
			align_print(p,"ZOMBIE");
801049c8:	83 ec 08             	sub    $0x8,%esp
801049cb:	68 d7 80 10 80       	push   $0x801080d7
801049d0:	53                   	push   %ebx
801049d1:	e8 9a fd ff ff       	call   80104770 <align_print>
801049d6:	83 c4 10             	add    $0x10,%esp
801049d9:	e9 6d ff ff ff       	jmp    8010494b <ps+0x3b>
801049de:	66 90                	xchg   %ax,%ax

801049e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	53                   	push   %ebx
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801049ee:	68 48 81 10 80       	push   $0x80108148
801049f3:	8d 43 04             	lea    0x4(%ebx),%eax
801049f6:	50                   	push   %eax
801049f7:	e8 24 01 00 00       	call   80104b20 <initlock>
  lk->name = name;
801049fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a05:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a08:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a0f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a15:	c9                   	leave  
80104a16:	c3                   	ret    
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	56                   	push   %esi
80104a28:	53                   	push   %ebx
80104a29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a2c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a2f:	83 ec 0c             	sub    $0xc,%esp
80104a32:	56                   	push   %esi
80104a33:	e8 68 02 00 00       	call   80104ca0 <acquire>
  while (lk->locked) {
80104a38:	8b 13                	mov    (%ebx),%edx
80104a3a:	83 c4 10             	add    $0x10,%esp
80104a3d:	85 d2                	test   %edx,%edx
80104a3f:	74 1a                	je     80104a5b <acquiresleep+0x3b>
80104a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104a48:	83 ec 08             	sub    $0x8,%esp
80104a4b:	56                   	push   %esi
80104a4c:	53                   	push   %ebx
80104a4d:	e8 9e f7 ff ff       	call   801041f0 <sleep>
  while (lk->locked) {
80104a52:	8b 03                	mov    (%ebx),%eax
80104a54:	83 c4 10             	add    $0x10,%esp
80104a57:	85 c0                	test   %eax,%eax
80104a59:	75 ed                	jne    80104a48 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104a5b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a61:	e8 0a f1 ff ff       	call   80103b70 <myproc>
80104a66:	8b 40 10             	mov    0x10(%eax),%eax
80104a69:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a6c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a72:	5b                   	pop    %ebx
80104a73:	5e                   	pop    %esi
80104a74:	5d                   	pop    %ebp
  release(&lk->lk);
80104a75:	e9 e6 02 00 00       	jmp    80104d60 <release>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a80:	f3 0f 1e fb          	endbr32 
80104a84:	55                   	push   %ebp
80104a85:	89 e5                	mov    %esp,%ebp
80104a87:	56                   	push   %esi
80104a88:	53                   	push   %ebx
80104a89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a8c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a8f:	83 ec 0c             	sub    $0xc,%esp
80104a92:	56                   	push   %esi
80104a93:	e8 08 02 00 00       	call   80104ca0 <acquire>
  lk->locked = 0;
80104a98:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a9e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104aa5:	89 1c 24             	mov    %ebx,(%esp)
80104aa8:	e8 03 f9 ff ff       	call   801043b0 <wakeup>
  release(&lk->lk);
80104aad:	89 75 08             	mov    %esi,0x8(%ebp)
80104ab0:	83 c4 10             	add    $0x10,%esp
}
80104ab3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab6:	5b                   	pop    %ebx
80104ab7:	5e                   	pop    %esi
80104ab8:	5d                   	pop    %ebp
  release(&lk->lk);
80104ab9:	e9 a2 02 00 00       	jmp    80104d60 <release>
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	57                   	push   %edi
80104ac8:	31 ff                	xor    %edi,%edi
80104aca:	56                   	push   %esi
80104acb:	53                   	push   %ebx
80104acc:	83 ec 18             	sub    $0x18,%esp
80104acf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ad2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ad5:	56                   	push   %esi
80104ad6:	e8 c5 01 00 00       	call   80104ca0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104adb:	8b 03                	mov    (%ebx),%eax
80104add:	83 c4 10             	add    $0x10,%esp
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	75 1c                	jne    80104b00 <holdingsleep+0x40>
  release(&lk->lk);
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	56                   	push   %esi
80104ae8:	e8 73 02 00 00       	call   80104d60 <release>
  return r;
}
80104aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104af0:	89 f8                	mov    %edi,%eax
80104af2:	5b                   	pop    %ebx
80104af3:	5e                   	pop    %esi
80104af4:	5f                   	pop    %edi
80104af5:	5d                   	pop    %ebp
80104af6:	c3                   	ret    
80104af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afe:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104b00:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b03:	e8 68 f0 ff ff       	call   80103b70 <myproc>
80104b08:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b0b:	0f 94 c0             	sete   %al
80104b0e:	0f b6 c0             	movzbl %al,%eax
80104b11:	89 c7                	mov    %eax,%edi
80104b13:	eb cf                	jmp    80104ae4 <holdingsleep+0x24>
80104b15:	66 90                	xchg   %ax,%ax
80104b17:	66 90                	xchg   %ax,%ax
80104b19:	66 90                	xchg   %ax,%ax
80104b1b:	66 90                	xchg   %ax,%ax
80104b1d:	66 90                	xchg   %ax,%ax
80104b1f:	90                   	nop

80104b20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b33:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b3d:	5d                   	pop    %ebp
80104b3e:	c3                   	ret    
80104b3f:	90                   	nop

80104b40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b45:	31 d2                	xor    %edx,%edx
{
80104b47:	89 e5                	mov    %esp,%ebp
80104b49:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104b4a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104b4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b50:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104b53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b57:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b58:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b5e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b64:	77 1a                	ja     80104b80 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b66:	8b 58 04             	mov    0x4(%eax),%ebx
80104b69:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b6c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b6f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b71:	83 fa 0a             	cmp    $0xa,%edx
80104b74:	75 e2                	jne    80104b58 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b76:	5b                   	pop    %ebx
80104b77:	5d                   	pop    %ebp
80104b78:	c3                   	ret    
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104b80:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b83:	8d 51 28             	lea    0x28(%ecx),%edx
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b96:	83 c0 04             	add    $0x4,%eax
80104b99:	39 d0                	cmp    %edx,%eax
80104b9b:	75 f3                	jne    80104b90 <getcallerpcs+0x50>
}
80104b9d:	5b                   	pop    %ebx
80104b9e:	5d                   	pop    %ebp
80104b9f:	c3                   	ret    

80104ba0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ba0:	f3 0f 1e fb          	endbr32 
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	53                   	push   %ebx
80104ba8:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bab:	9c                   	pushf  
80104bac:	5b                   	pop    %ebx
  asm volatile("cli");
80104bad:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104bae:	e8 2d ef ff ff       	call   80103ae0 <mycpu>
80104bb3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bb9:	85 c0                	test   %eax,%eax
80104bbb:	74 13                	je     80104bd0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104bbd:	e8 1e ef ff ff       	call   80103ae0 <mycpu>
80104bc2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104bc9:	83 c4 04             	add    $0x4,%esp
80104bcc:	5b                   	pop    %ebx
80104bcd:	5d                   	pop    %ebp
80104bce:	c3                   	ret    
80104bcf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104bd0:	e8 0b ef ff ff       	call   80103ae0 <mycpu>
80104bd5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104bdb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104be1:	eb da                	jmp    80104bbd <pushcli+0x1d>
80104be3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bf0 <popcli>:

void
popcli(void)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bfa:	9c                   	pushf  
80104bfb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bfc:	f6 c4 02             	test   $0x2,%ah
80104bff:	75 31                	jne    80104c32 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c01:	e8 da ee ff ff       	call   80103ae0 <mycpu>
80104c06:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c0d:	78 30                	js     80104c3f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c0f:	e8 cc ee ff ff       	call   80103ae0 <mycpu>
80104c14:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c1a:	85 d2                	test   %edx,%edx
80104c1c:	74 02                	je     80104c20 <popcli+0x30>
    sti();
}
80104c1e:	c9                   	leave  
80104c1f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c20:	e8 bb ee ff ff       	call   80103ae0 <mycpu>
80104c25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c2b:	85 c0                	test   %eax,%eax
80104c2d:	74 ef                	je     80104c1e <popcli+0x2e>
  asm volatile("sti");
80104c2f:	fb                   	sti    
}
80104c30:	c9                   	leave  
80104c31:	c3                   	ret    
    panic("popcli - interruptible");
80104c32:	83 ec 0c             	sub    $0xc,%esp
80104c35:	68 53 81 10 80       	push   $0x80108153
80104c3a:	e8 51 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c3f:	83 ec 0c             	sub    $0xc,%esp
80104c42:	68 6a 81 10 80       	push   $0x8010816a
80104c47:	e8 44 b7 ff ff       	call   80100390 <panic>
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c50 <holding>:
{
80104c50:	f3 0f 1e fb          	endbr32 
80104c54:	55                   	push   %ebp
80104c55:	89 e5                	mov    %esp,%ebp
80104c57:	56                   	push   %esi
80104c58:	53                   	push   %ebx
80104c59:	8b 75 08             	mov    0x8(%ebp),%esi
80104c5c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104c5e:	e8 3d ff ff ff       	call   80104ba0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c63:	8b 06                	mov    (%esi),%eax
80104c65:	85 c0                	test   %eax,%eax
80104c67:	75 0f                	jne    80104c78 <holding+0x28>
  popcli();
80104c69:	e8 82 ff ff ff       	call   80104bf0 <popcli>
}
80104c6e:	89 d8                	mov    %ebx,%eax
80104c70:	5b                   	pop    %ebx
80104c71:	5e                   	pop    %esi
80104c72:	5d                   	pop    %ebp
80104c73:	c3                   	ret    
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c78:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c7b:	e8 60 ee ff ff       	call   80103ae0 <mycpu>
80104c80:	39 c3                	cmp    %eax,%ebx
80104c82:	0f 94 c3             	sete   %bl
  popcli();
80104c85:	e8 66 ff ff ff       	call   80104bf0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104c8a:	0f b6 db             	movzbl %bl,%ebx
}
80104c8d:	89 d8                	mov    %ebx,%eax
80104c8f:	5b                   	pop    %ebx
80104c90:	5e                   	pop    %esi
80104c91:	5d                   	pop    %ebp
80104c92:	c3                   	ret    
80104c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ca0 <acquire>:
{
80104ca0:	f3 0f 1e fb          	endbr32 
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	56                   	push   %esi
80104ca8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ca9:	e8 f2 fe ff ff       	call   80104ba0 <pushcli>
  if(holding(lk))
80104cae:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cb1:	83 ec 0c             	sub    $0xc,%esp
80104cb4:	53                   	push   %ebx
80104cb5:	e8 96 ff ff ff       	call   80104c50 <holding>
80104cba:	83 c4 10             	add    $0x10,%esp
80104cbd:	85 c0                	test   %eax,%eax
80104cbf:	0f 85 7f 00 00 00    	jne    80104d44 <acquire+0xa4>
80104cc5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104cc7:	ba 01 00 00 00       	mov    $0x1,%edx
80104ccc:	eb 05                	jmp    80104cd3 <acquire+0x33>
80104cce:	66 90                	xchg   %ax,%ax
80104cd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cd3:	89 d0                	mov    %edx,%eax
80104cd5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104cd8:	85 c0                	test   %eax,%eax
80104cda:	75 f4                	jne    80104cd0 <acquire+0x30>
  __sync_synchronize();
80104cdc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ce1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ce4:	e8 f7 ed ff ff       	call   80103ae0 <mycpu>
80104ce9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104cec:	89 e8                	mov    %ebp,%eax
80104cee:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cf0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104cf6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104cfc:	77 22                	ja     80104d20 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104cfe:	8b 50 04             	mov    0x4(%eax),%edx
80104d01:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104d05:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104d08:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d0a:	83 fe 0a             	cmp    $0xa,%esi
80104d0d:	75 e1                	jne    80104cf0 <acquire+0x50>
}
80104d0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d12:	5b                   	pop    %ebx
80104d13:	5e                   	pop    %esi
80104d14:	5d                   	pop    %ebp
80104d15:	c3                   	ret    
80104d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104d20:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104d24:	83 c3 34             	add    $0x34,%ebx
80104d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d36:	83 c0 04             	add    $0x4,%eax
80104d39:	39 d8                	cmp    %ebx,%eax
80104d3b:	75 f3                	jne    80104d30 <acquire+0x90>
}
80104d3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d40:	5b                   	pop    %ebx
80104d41:	5e                   	pop    %esi
80104d42:	5d                   	pop    %ebp
80104d43:	c3                   	ret    
    panic("acquire");
80104d44:	83 ec 0c             	sub    $0xc,%esp
80104d47:	68 71 81 10 80       	push   $0x80108171
80104d4c:	e8 3f b6 ff ff       	call   80100390 <panic>
80104d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop

80104d60 <release>:
{
80104d60:	f3 0f 1e fb          	endbr32 
80104d64:	55                   	push   %ebp
80104d65:	89 e5                	mov    %esp,%ebp
80104d67:	53                   	push   %ebx
80104d68:	83 ec 10             	sub    $0x10,%esp
80104d6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d6e:	53                   	push   %ebx
80104d6f:	e8 dc fe ff ff       	call   80104c50 <holding>
80104d74:	83 c4 10             	add    $0x10,%esp
80104d77:	85 c0                	test   %eax,%eax
80104d79:	74 22                	je     80104d9d <release+0x3d>
  lk->pcs[0] = 0;
80104d7b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d82:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d89:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d8e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d97:	c9                   	leave  
  popcli();
80104d98:	e9 53 fe ff ff       	jmp    80104bf0 <popcli>
    panic("release");
80104d9d:	83 ec 0c             	sub    $0xc,%esp
80104da0:	68 79 81 10 80       	push   $0x80108179
80104da5:	e8 e6 b5 ff ff       	call   80100390 <panic>
80104daa:	66 90                	xchg   %ax,%ax
80104dac:	66 90                	xchg   %ax,%ax
80104dae:	66 90                	xchg   %ax,%ax

80104db0 <memset>:
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	57                   	push   %edi
80104db8:	8b 55 08             	mov    0x8(%ebp),%edx
80104dbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dbe:	53                   	push   %ebx
80104dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dc2:	89 d7                	mov    %edx,%edi
80104dc4:	09 cf                	or     %ecx,%edi
80104dc6:	83 e7 03             	and    $0x3,%edi
80104dc9:	75 25                	jne    80104df0 <memset+0x40>
80104dcb:	0f b6 f8             	movzbl %al,%edi
80104dce:	c1 e0 18             	shl    $0x18,%eax
80104dd1:	89 fb                	mov    %edi,%ebx
80104dd3:	c1 e9 02             	shr    $0x2,%ecx
80104dd6:	c1 e3 10             	shl    $0x10,%ebx
80104dd9:	09 d8                	or     %ebx,%eax
80104ddb:	09 f8                	or     %edi,%eax
80104ddd:	c1 e7 08             	shl    $0x8,%edi
80104de0:	09 f8                	or     %edi,%eax
80104de2:	89 d7                	mov    %edx,%edi
80104de4:	fc                   	cld    
80104de5:	f3 ab                	rep stos %eax,%es:(%edi)
80104de7:	5b                   	pop    %ebx
80104de8:	89 d0                	mov    %edx,%eax
80104dea:	5f                   	pop    %edi
80104deb:	5d                   	pop    %ebp
80104dec:	c3                   	ret    
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
80104df0:	89 d7                	mov    %edx,%edi
80104df2:	fc                   	cld    
80104df3:	f3 aa                	rep stos %al,%es:(%edi)
80104df5:	5b                   	pop    %ebx
80104df6:	89 d0                	mov    %edx,%eax
80104df8:	5f                   	pop    %edi
80104df9:	5d                   	pop    %ebp
80104dfa:	c3                   	ret    
80104dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop

80104e00 <memcmp>:
80104e00:	f3 0f 1e fb          	endbr32 
80104e04:	55                   	push   %ebp
80104e05:	89 e5                	mov    %esp,%ebp
80104e07:	56                   	push   %esi
80104e08:	8b 75 10             	mov    0x10(%ebp),%esi
80104e0b:	8b 55 08             	mov    0x8(%ebp),%edx
80104e0e:	53                   	push   %ebx
80104e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e12:	85 f6                	test   %esi,%esi
80104e14:	74 2a                	je     80104e40 <memcmp+0x40>
80104e16:	01 c6                	add    %eax,%esi
80104e18:	eb 10                	jmp    80104e2a <memcmp+0x2a>
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e20:	83 c0 01             	add    $0x1,%eax
80104e23:	83 c2 01             	add    $0x1,%edx
80104e26:	39 f0                	cmp    %esi,%eax
80104e28:	74 16                	je     80104e40 <memcmp+0x40>
80104e2a:	0f b6 0a             	movzbl (%edx),%ecx
80104e2d:	0f b6 18             	movzbl (%eax),%ebx
80104e30:	38 d9                	cmp    %bl,%cl
80104e32:	74 ec                	je     80104e20 <memcmp+0x20>
80104e34:	0f b6 c1             	movzbl %cl,%eax
80104e37:	29 d8                	sub    %ebx,%eax
80104e39:	5b                   	pop    %ebx
80104e3a:	5e                   	pop    %esi
80104e3b:	5d                   	pop    %ebp
80104e3c:	c3                   	ret    
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
80104e40:	5b                   	pop    %ebx
80104e41:	31 c0                	xor    %eax,%eax
80104e43:	5e                   	pop    %esi
80104e44:	5d                   	pop    %ebp
80104e45:	c3                   	ret    
80104e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi

80104e50 <memmove>:
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	57                   	push   %edi
80104e58:	8b 55 08             	mov    0x8(%ebp),%edx
80104e5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e5e:	56                   	push   %esi
80104e5f:	8b 75 0c             	mov    0xc(%ebp),%esi
80104e62:	39 d6                	cmp    %edx,%esi
80104e64:	73 2a                	jae    80104e90 <memmove+0x40>
80104e66:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104e69:	39 fa                	cmp    %edi,%edx
80104e6b:	73 23                	jae    80104e90 <memmove+0x40>
80104e6d:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104e70:	85 c9                	test   %ecx,%ecx
80104e72:	74 13                	je     80104e87 <memmove+0x37>
80104e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e78:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104e7c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104e7f:	83 e8 01             	sub    $0x1,%eax
80104e82:	83 f8 ff             	cmp    $0xffffffff,%eax
80104e85:	75 f1                	jne    80104e78 <memmove+0x28>
80104e87:	5e                   	pop    %esi
80104e88:	89 d0                	mov    %edx,%eax
80104e8a:	5f                   	pop    %edi
80104e8b:	5d                   	pop    %ebp
80104e8c:	c3                   	ret    
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi
80104e90:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104e93:	89 d7                	mov    %edx,%edi
80104e95:	85 c9                	test   %ecx,%ecx
80104e97:	74 ee                	je     80104e87 <memmove+0x37>
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
80104ea1:	39 f0                	cmp    %esi,%eax
80104ea3:	75 fb                	jne    80104ea0 <memmove+0x50>
80104ea5:	5e                   	pop    %esi
80104ea6:	89 d0                	mov    %edx,%eax
80104ea8:	5f                   	pop    %edi
80104ea9:	5d                   	pop    %ebp
80104eaa:	c3                   	ret    
80104eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eaf:	90                   	nop

80104eb0 <memcpy>:
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	eb 9a                	jmp    80104e50 <memmove>
80104eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi

80104ec0 <strncmp>:
80104ec0:	f3 0f 1e fb          	endbr32 
80104ec4:	55                   	push   %ebp
80104ec5:	89 e5                	mov    %esp,%ebp
80104ec7:	56                   	push   %esi
80104ec8:	8b 75 10             	mov    0x10(%ebp),%esi
80104ecb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ece:	53                   	push   %ebx
80104ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ed2:	85 f6                	test   %esi,%esi
80104ed4:	74 32                	je     80104f08 <strncmp+0x48>
80104ed6:	01 c6                	add    %eax,%esi
80104ed8:	eb 14                	jmp    80104eee <strncmp+0x2e>
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ee0:	38 da                	cmp    %bl,%dl
80104ee2:	75 14                	jne    80104ef8 <strncmp+0x38>
80104ee4:	83 c0 01             	add    $0x1,%eax
80104ee7:	83 c1 01             	add    $0x1,%ecx
80104eea:	39 f0                	cmp    %esi,%eax
80104eec:	74 1a                	je     80104f08 <strncmp+0x48>
80104eee:	0f b6 11             	movzbl (%ecx),%edx
80104ef1:	0f b6 18             	movzbl (%eax),%ebx
80104ef4:	84 d2                	test   %dl,%dl
80104ef6:	75 e8                	jne    80104ee0 <strncmp+0x20>
80104ef8:	0f b6 c2             	movzbl %dl,%eax
80104efb:	29 d8                	sub    %ebx,%eax
80104efd:	5b                   	pop    %ebx
80104efe:	5e                   	pop    %esi
80104eff:	5d                   	pop    %ebp
80104f00:	c3                   	ret    
80104f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f08:	5b                   	pop    %ebx
80104f09:	31 c0                	xor    %eax,%eax
80104f0b:	5e                   	pop    %esi
80104f0c:	5d                   	pop    %ebp
80104f0d:	c3                   	ret    
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <strncpy>:
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	57                   	push   %edi
80104f18:	56                   	push   %esi
80104f19:	8b 75 08             	mov    0x8(%ebp),%esi
80104f1c:	53                   	push   %ebx
80104f1d:	8b 45 10             	mov    0x10(%ebp),%eax
80104f20:	89 f2                	mov    %esi,%edx
80104f22:	eb 1b                	jmp    80104f3f <strncpy+0x2f>
80104f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f28:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f2f:	83 c2 01             	add    $0x1,%edx
80104f32:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104f36:	89 f9                	mov    %edi,%ecx
80104f38:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f3b:	84 c9                	test   %cl,%cl
80104f3d:	74 09                	je     80104f48 <strncpy+0x38>
80104f3f:	89 c3                	mov    %eax,%ebx
80104f41:	83 e8 01             	sub    $0x1,%eax
80104f44:	85 db                	test   %ebx,%ebx
80104f46:	7f e0                	jg     80104f28 <strncpy+0x18>
80104f48:	89 d1                	mov    %edx,%ecx
80104f4a:	85 c0                	test   %eax,%eax
80104f4c:	7e 15                	jle    80104f63 <strncpy+0x53>
80104f4e:	66 90                	xchg   %ax,%ax
80104f50:	83 c1 01             	add    $0x1,%ecx
80104f53:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
80104f57:	89 c8                	mov    %ecx,%eax
80104f59:	f7 d0                	not    %eax
80104f5b:	01 d0                	add    %edx,%eax
80104f5d:	01 d8                	add    %ebx,%eax
80104f5f:	85 c0                	test   %eax,%eax
80104f61:	7f ed                	jg     80104f50 <strncpy+0x40>
80104f63:	5b                   	pop    %ebx
80104f64:	89 f0                	mov    %esi,%eax
80104f66:	5e                   	pop    %esi
80104f67:	5f                   	pop    %edi
80104f68:	5d                   	pop    %ebp
80104f69:	c3                   	ret    
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f70 <safestrcpy>:
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	56                   	push   %esi
80104f78:	8b 55 10             	mov    0x10(%ebp),%edx
80104f7b:	8b 75 08             	mov    0x8(%ebp),%esi
80104f7e:	53                   	push   %ebx
80104f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f82:	85 d2                	test   %edx,%edx
80104f84:	7e 21                	jle    80104fa7 <safestrcpy+0x37>
80104f86:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104f8a:	89 f2                	mov    %esi,%edx
80104f8c:	eb 12                	jmp    80104fa0 <safestrcpy+0x30>
80104f8e:	66 90                	xchg   %ax,%ax
80104f90:	0f b6 08             	movzbl (%eax),%ecx
80104f93:	83 c0 01             	add    $0x1,%eax
80104f96:	83 c2 01             	add    $0x1,%edx
80104f99:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f9c:	84 c9                	test   %cl,%cl
80104f9e:	74 04                	je     80104fa4 <safestrcpy+0x34>
80104fa0:	39 d8                	cmp    %ebx,%eax
80104fa2:	75 ec                	jne    80104f90 <safestrcpy+0x20>
80104fa4:	c6 02 00             	movb   $0x0,(%edx)
80104fa7:	89 f0                	mov    %esi,%eax
80104fa9:	5b                   	pop    %ebx
80104faa:	5e                   	pop    %esi
80104fab:	5d                   	pop    %ebp
80104fac:	c3                   	ret    
80104fad:	8d 76 00             	lea    0x0(%esi),%esi

80104fb0 <strlen>:
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	31 c0                	xor    %eax,%eax
80104fb7:	89 e5                	mov    %esp,%ebp
80104fb9:	8b 55 08             	mov    0x8(%ebp),%edx
80104fbc:	80 3a 00             	cmpb   $0x0,(%edx)
80104fbf:	74 10                	je     80104fd1 <strlen+0x21>
80104fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc8:	83 c0 01             	add    $0x1,%eax
80104fcb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104fcf:	75 f7                	jne    80104fc8 <strlen+0x18>
80104fd1:	5d                   	pop    %ebp
80104fd2:	c3                   	ret    

80104fd3 <swtch>:
80104fd3:	8b 44 24 04          	mov    0x4(%esp),%eax
80104fd7:	8b 54 24 08          	mov    0x8(%esp),%edx
80104fdb:	55                   	push   %ebp
80104fdc:	53                   	push   %ebx
80104fdd:	56                   	push   %esi
80104fde:	57                   	push   %edi
80104fdf:	89 20                	mov    %esp,(%eax)
80104fe1:	89 d4                	mov    %edx,%esp
80104fe3:	5f                   	pop    %edi
80104fe4:	5e                   	pop    %esi
80104fe5:	5b                   	pop    %ebx
80104fe6:	5d                   	pop    %ebp
80104fe7:	c3                   	ret    
80104fe8:	66 90                	xchg   %ax,%ax
80104fea:	66 90                	xchg   %ax,%ax
80104fec:	66 90                	xchg   %ax,%ax
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	53                   	push   %ebx
80104ff8:	83 ec 04             	sub    $0x4,%esp
80104ffb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104ffe:	e8 6d eb ff ff       	call   80103b70 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105003:	8b 00                	mov    (%eax),%eax
80105005:	39 d8                	cmp    %ebx,%eax
80105007:	76 17                	jbe    80105020 <fetchint+0x30>
80105009:	8d 53 04             	lea    0x4(%ebx),%edx
8010500c:	39 d0                	cmp    %edx,%eax
8010500e:	72 10                	jb     80105020 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105010:	8b 45 0c             	mov    0xc(%ebp),%eax
80105013:	8b 13                	mov    (%ebx),%edx
80105015:	89 10                	mov    %edx,(%eax)
  return 0;
80105017:	31 c0                	xor    %eax,%eax
}
80105019:	83 c4 04             	add    $0x4,%esp
8010501c:	5b                   	pop    %ebx
8010501d:	5d                   	pop    %ebp
8010501e:	c3                   	ret    
8010501f:	90                   	nop
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105025:	eb f2                	jmp    80105019 <fetchint+0x29>
80105027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502e:	66 90                	xchg   %ax,%ax

80105030 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
80105037:	53                   	push   %ebx
80105038:	83 ec 04             	sub    $0x4,%esp
8010503b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010503e:	e8 2d eb ff ff       	call   80103b70 <myproc>

  if(addr >= curproc->sz)
80105043:	39 18                	cmp    %ebx,(%eax)
80105045:	76 31                	jbe    80105078 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105047:	8b 55 0c             	mov    0xc(%ebp),%edx
8010504a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010504c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010504e:	39 d3                	cmp    %edx,%ebx
80105050:	73 26                	jae    80105078 <fetchstr+0x48>
80105052:	89 d8                	mov    %ebx,%eax
80105054:	eb 11                	jmp    80105067 <fetchstr+0x37>
80105056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
80105060:	83 c0 01             	add    $0x1,%eax
80105063:	39 c2                	cmp    %eax,%edx
80105065:	76 11                	jbe    80105078 <fetchstr+0x48>
    if(*s == 0)
80105067:	80 38 00             	cmpb   $0x0,(%eax)
8010506a:	75 f4                	jne    80105060 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010506c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010506f:	29 d8                	sub    %ebx,%eax
}
80105071:	5b                   	pop    %ebx
80105072:	5d                   	pop    %ebp
80105073:	c3                   	ret    
80105074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105078:	83 c4 04             	add    $0x4,%esp
    return -1;
8010507b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105080:	5b                   	pop    %ebx
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret    
80105083:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105090 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	56                   	push   %esi
80105098:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105099:	e8 d2 ea ff ff       	call   80103b70 <myproc>
8010509e:	8b 55 08             	mov    0x8(%ebp),%edx
801050a1:	8b 40 18             	mov    0x18(%eax),%eax
801050a4:	8b 40 44             	mov    0x44(%eax),%eax
801050a7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050aa:	e8 c1 ea ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050af:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050b2:	8b 00                	mov    (%eax),%eax
801050b4:	39 c6                	cmp    %eax,%esi
801050b6:	73 18                	jae    801050d0 <argint+0x40>
801050b8:	8d 53 08             	lea    0x8(%ebx),%edx
801050bb:	39 d0                	cmp    %edx,%eax
801050bd:	72 11                	jb     801050d0 <argint+0x40>
  *ip = *(int*)(addr);
801050bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801050c2:	8b 53 04             	mov    0x4(%ebx),%edx
801050c5:	89 10                	mov    %edx,(%eax)
  return 0;
801050c7:	31 c0                	xor    %eax,%eax
}
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050d5:	eb f2                	jmp    801050c9 <argint+0x39>
801050d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050de:	66 90                	xchg   %ax,%ax

801050e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	56                   	push   %esi
801050e8:	53                   	push   %ebx
801050e9:	83 ec 10             	sub    $0x10,%esp
801050ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801050ef:	e8 7c ea ff ff       	call   80103b70 <myproc>
 
  if(argint(n, &i) < 0)
801050f4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801050f7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801050f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050fc:	50                   	push   %eax
801050fd:	ff 75 08             	pushl  0x8(%ebp)
80105100:	e8 8b ff ff ff       	call   80105090 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105105:	83 c4 10             	add    $0x10,%esp
80105108:	85 c0                	test   %eax,%eax
8010510a:	78 24                	js     80105130 <argptr+0x50>
8010510c:	85 db                	test   %ebx,%ebx
8010510e:	78 20                	js     80105130 <argptr+0x50>
80105110:	8b 16                	mov    (%esi),%edx
80105112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105115:	39 c2                	cmp    %eax,%edx
80105117:	76 17                	jbe    80105130 <argptr+0x50>
80105119:	01 c3                	add    %eax,%ebx
8010511b:	39 da                	cmp    %ebx,%edx
8010511d:	72 11                	jb     80105130 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010511f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105122:	89 02                	mov    %eax,(%edx)
  return 0;
80105124:	31 c0                	xor    %eax,%eax
}
80105126:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105129:	5b                   	pop    %ebx
8010512a:	5e                   	pop    %esi
8010512b:	5d                   	pop    %ebp
8010512c:	c3                   	ret    
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	eb ef                	jmp    80105126 <argptr+0x46>
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010514a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010514d:	50                   	push   %eax
8010514e:	ff 75 08             	pushl  0x8(%ebp)
80105151:	e8 3a ff ff ff       	call   80105090 <argint>
80105156:	83 c4 10             	add    $0x10,%esp
80105159:	85 c0                	test   %eax,%eax
8010515b:	78 13                	js     80105170 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010515d:	83 ec 08             	sub    $0x8,%esp
80105160:	ff 75 0c             	pushl  0xc(%ebp)
80105163:	ff 75 f4             	pushl  -0xc(%ebp)
80105166:	e8 c5 fe ff ff       	call   80105030 <fetchstr>
8010516b:	83 c4 10             	add    $0x10,%esp
}
8010516e:	c9                   	leave  
8010516f:	c3                   	ret    
80105170:	c9                   	leave  
    return -1;
80105171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105176:	c3                   	ret    
80105177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517e:	66 90                	xchg   %ax,%ax

80105180 <syscall>:
[SYS_ps] sys_ps,
};

void
syscall(void)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	53                   	push   %ebx
80105188:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010518b:	e8 e0 e9 ff ff       	call   80103b70 <myproc>
80105190:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105192:	8b 40 18             	mov    0x18(%eax),%eax
80105195:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105198:	8d 50 ff             	lea    -0x1(%eax),%edx
8010519b:	83 fa 1a             	cmp    $0x1a,%edx
8010519e:	77 20                	ja     801051c0 <syscall+0x40>
801051a0:	8b 14 85 a0 81 10 80 	mov    -0x7fef7e60(,%eax,4),%edx
801051a7:	85 d2                	test   %edx,%edx
801051a9:	74 15                	je     801051c0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801051ab:	ff d2                	call   *%edx
801051ad:	89 c2                	mov    %eax,%edx
801051af:	8b 43 18             	mov    0x18(%ebx),%eax
801051b2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801051b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051b8:	c9                   	leave  
801051b9:	c3                   	ret    
801051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801051c0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801051c1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801051c4:	50                   	push   %eax
801051c5:	ff 73 10             	pushl  0x10(%ebx)
801051c8:	68 81 81 10 80       	push   $0x80108181
801051cd:	e8 de b4 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801051d2:	8b 43 18             	mov    0x18(%ebx),%eax
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801051df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051e2:	c9                   	leave  
801051e3:	c3                   	ret    
801051e4:	66 90                	xchg   %ax,%ax
801051e6:	66 90                	xchg   %ax,%ax
801051e8:	66 90                	xchg   %ax,%ax
801051ea:	66 90                	xchg   %ax,%ax
801051ec:	66 90                	xchg   %ax,%ax
801051ee:	66 90                	xchg   %ax,%ax

801051f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051f5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801051f8:	53                   	push   %ebx
801051f9:	83 ec 44             	sub    $0x44,%esp
801051fc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801051ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105202:	57                   	push   %edi
80105203:	50                   	push   %eax
{
80105204:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105207:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010520a:	e8 41 ce ff ff       	call   80102050 <nameiparent>
8010520f:	83 c4 10             	add    $0x10,%esp
80105212:	85 c0                	test   %eax,%eax
80105214:	0f 84 46 01 00 00    	je     80105360 <create+0x170>
    return 0;
  ilock(dp);
8010521a:	83 ec 0c             	sub    $0xc,%esp
8010521d:	89 c3                	mov    %eax,%ebx
8010521f:	50                   	push   %eax
80105220:	e8 3b c5 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105225:	83 c4 0c             	add    $0xc,%esp
80105228:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010522b:	50                   	push   %eax
8010522c:	57                   	push   %edi
8010522d:	53                   	push   %ebx
8010522e:	e8 7d ca ff ff       	call   80101cb0 <dirlookup>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	89 c6                	mov    %eax,%esi
80105238:	85 c0                	test   %eax,%eax
8010523a:	74 54                	je     80105290 <create+0xa0>
    iunlockput(dp);
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	53                   	push   %ebx
80105240:	e8 bb c7 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105245:	89 34 24             	mov    %esi,(%esp)
80105248:	e8 13 c5 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010524d:	83 c4 10             	add    $0x10,%esp
80105250:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105255:	75 19                	jne    80105270 <create+0x80>
80105257:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010525c:	75 12                	jne    80105270 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010525e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105261:	89 f0                	mov    %esi,%eax
80105263:	5b                   	pop    %ebx
80105264:	5e                   	pop    %esi
80105265:	5f                   	pop    %edi
80105266:	5d                   	pop    %ebp
80105267:	c3                   	ret    
80105268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526f:	90                   	nop
    iunlockput(ip);
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	56                   	push   %esi
    return 0;
80105274:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105276:	e8 85 c7 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010527b:	83 c4 10             	add    $0x10,%esp
}
8010527e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105281:	89 f0                	mov    %esi,%eax
80105283:	5b                   	pop    %ebx
80105284:	5e                   	pop    %esi
80105285:	5f                   	pop    %edi
80105286:	5d                   	pop    %ebp
80105287:	c3                   	ret    
80105288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105290:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105294:	83 ec 08             	sub    $0x8,%esp
80105297:	50                   	push   %eax
80105298:	ff 33                	pushl  (%ebx)
8010529a:	e8 41 c3 ff ff       	call   801015e0 <ialloc>
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	89 c6                	mov    %eax,%esi
801052a4:	85 c0                	test   %eax,%eax
801052a6:	0f 84 cd 00 00 00    	je     80105379 <create+0x189>
  ilock(ip);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	50                   	push   %eax
801052b0:	e8 ab c4 ff ff       	call   80101760 <ilock>
  ip->major = major;
801052b5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801052b9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801052bd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801052c1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801052c5:	b8 01 00 00 00       	mov    $0x1,%eax
801052ca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801052ce:	89 34 24             	mov    %esi,(%esp)
801052d1:	e8 ca c3 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801052d6:	83 c4 10             	add    $0x10,%esp
801052d9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801052de:	74 30                	je     80105310 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801052e0:	83 ec 04             	sub    $0x4,%esp
801052e3:	ff 76 04             	pushl  0x4(%esi)
801052e6:	57                   	push   %edi
801052e7:	53                   	push   %ebx
801052e8:	e8 83 cc ff ff       	call   80101f70 <dirlink>
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 78                	js     8010536c <create+0x17c>
  iunlockput(dp);
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	53                   	push   %ebx
801052f8:	e8 03 c7 ff ff       	call   80101a00 <iunlockput>
  return ip;
801052fd:	83 c4 10             	add    $0x10,%esp
}
80105300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105303:	89 f0                	mov    %esi,%eax
80105305:	5b                   	pop    %ebx
80105306:	5e                   	pop    %esi
80105307:	5f                   	pop    %edi
80105308:	5d                   	pop    %ebp
80105309:	c3                   	ret    
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105310:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105313:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105318:	53                   	push   %ebx
80105319:	e8 82 c3 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010531e:	83 c4 0c             	add    $0xc,%esp
80105321:	ff 76 04             	pushl  0x4(%esi)
80105324:	68 2c 82 10 80       	push   $0x8010822c
80105329:	56                   	push   %esi
8010532a:	e8 41 cc ff ff       	call   80101f70 <dirlink>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	78 18                	js     8010534e <create+0x15e>
80105336:	83 ec 04             	sub    $0x4,%esp
80105339:	ff 73 04             	pushl  0x4(%ebx)
8010533c:	68 2b 82 10 80       	push   $0x8010822b
80105341:	56                   	push   %esi
80105342:	e8 29 cc ff ff       	call   80101f70 <dirlink>
80105347:	83 c4 10             	add    $0x10,%esp
8010534a:	85 c0                	test   %eax,%eax
8010534c:	79 92                	jns    801052e0 <create+0xf0>
      panic("create dots");
8010534e:	83 ec 0c             	sub    $0xc,%esp
80105351:	68 1f 82 10 80       	push   $0x8010821f
80105356:	e8 35 b0 ff ff       	call   80100390 <panic>
8010535b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010535f:	90                   	nop
}
80105360:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105363:	31 f6                	xor    %esi,%esi
}
80105365:	5b                   	pop    %ebx
80105366:	89 f0                	mov    %esi,%eax
80105368:	5e                   	pop    %esi
80105369:	5f                   	pop    %edi
8010536a:	5d                   	pop    %ebp
8010536b:	c3                   	ret    
    panic("create: dirlink");
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	68 2e 82 10 80       	push   $0x8010822e
80105374:	e8 17 b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	68 10 82 10 80       	push   $0x80108210
80105381:	e8 0a b0 ff ff       	call   80100390 <panic>
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi

80105390 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	89 d6                	mov    %edx,%esi
80105396:	53                   	push   %ebx
80105397:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105399:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010539c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010539f:	50                   	push   %eax
801053a0:	6a 00                	push   $0x0
801053a2:	e8 e9 fc ff ff       	call   80105090 <argint>
801053a7:	83 c4 10             	add    $0x10,%esp
801053aa:	85 c0                	test   %eax,%eax
801053ac:	78 2a                	js     801053d8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053b2:	77 24                	ja     801053d8 <argfd.constprop.0+0x48>
801053b4:	e8 b7 e7 ff ff       	call   80103b70 <myproc>
801053b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801053c0:	85 c0                	test   %eax,%eax
801053c2:	74 14                	je     801053d8 <argfd.constprop.0+0x48>
  if(pfd)
801053c4:	85 db                	test   %ebx,%ebx
801053c6:	74 02                	je     801053ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801053c8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801053ca:	89 06                	mov    %eax,(%esi)
  return 0;
801053cc:	31 c0                	xor    %eax,%eax
}
801053ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053d1:	5b                   	pop    %ebx
801053d2:	5e                   	pop    %esi
801053d3:	5d                   	pop    %ebp
801053d4:	c3                   	ret    
801053d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053dd:	eb ef                	jmp    801053ce <argfd.constprop.0+0x3e>
801053df:	90                   	nop

801053e0 <sys_dup>:
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801053e5:	31 c0                	xor    %eax,%eax
{
801053e7:	89 e5                	mov    %esp,%ebp
801053e9:	56                   	push   %esi
801053ea:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801053eb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801053ee:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801053f1:	e8 9a ff ff ff       	call   80105390 <argfd.constprop.0>
801053f6:	85 c0                	test   %eax,%eax
801053f8:	78 1e                	js     80105418 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801053fa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053fd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801053ff:	e8 6c e7 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105408:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010540c:	85 d2                	test   %edx,%edx
8010540e:	74 20                	je     80105430 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105410:	83 c3 01             	add    $0x1,%ebx
80105413:	83 fb 10             	cmp    $0x10,%ebx
80105416:	75 f0                	jne    80105408 <sys_dup+0x28>
}
80105418:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010541b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105420:	89 d8                	mov    %ebx,%eax
80105422:	5b                   	pop    %ebx
80105423:	5e                   	pop    %esi
80105424:	5d                   	pop    %ebp
80105425:	c3                   	ret    
80105426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105430:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105434:	83 ec 0c             	sub    $0xc,%esp
80105437:	ff 75 f4             	pushl  -0xc(%ebp)
8010543a:	e8 31 ba ff ff       	call   80100e70 <filedup>
  return fd;
8010543f:	83 c4 10             	add    $0x10,%esp
}
80105442:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105445:	89 d8                	mov    %ebx,%eax
80105447:	5b                   	pop    %ebx
80105448:	5e                   	pop    %esi
80105449:	5d                   	pop    %ebp
8010544a:	c3                   	ret    
8010544b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010544f:	90                   	nop

80105450 <sys_read>:
{
80105450:	f3 0f 1e fb          	endbr32 
80105454:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105455:	31 c0                	xor    %eax,%eax
{
80105457:	89 e5                	mov    %esp,%ebp
80105459:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010545c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010545f:	e8 2c ff ff ff       	call   80105390 <argfd.constprop.0>
80105464:	85 c0                	test   %eax,%eax
80105466:	78 48                	js     801054b0 <sys_read+0x60>
80105468:	83 ec 08             	sub    $0x8,%esp
8010546b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010546e:	50                   	push   %eax
8010546f:	6a 02                	push   $0x2
80105471:	e8 1a fc ff ff       	call   80105090 <argint>
80105476:	83 c4 10             	add    $0x10,%esp
80105479:	85 c0                	test   %eax,%eax
8010547b:	78 33                	js     801054b0 <sys_read+0x60>
8010547d:	83 ec 04             	sub    $0x4,%esp
80105480:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105483:	ff 75 f0             	pushl  -0x10(%ebp)
80105486:	50                   	push   %eax
80105487:	6a 01                	push   $0x1
80105489:	e8 52 fc ff ff       	call   801050e0 <argptr>
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	85 c0                	test   %eax,%eax
80105493:	78 1b                	js     801054b0 <sys_read+0x60>
  return fileread(f, p, n);
80105495:	83 ec 04             	sub    $0x4,%esp
80105498:	ff 75 f0             	pushl  -0x10(%ebp)
8010549b:	ff 75 f4             	pushl  -0xc(%ebp)
8010549e:	ff 75 ec             	pushl  -0x14(%ebp)
801054a1:	e8 4a bb ff ff       	call   80100ff0 <fileread>
801054a6:	83 c4 10             	add    $0x10,%esp
}
801054a9:	c9                   	leave  
801054aa:	c3                   	ret    
801054ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop
801054b0:	c9                   	leave  
    return -1;
801054b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b6:	c3                   	ret    
801054b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054be:	66 90                	xchg   %ax,%ax

801054c0 <sys_write>:
{
801054c0:	f3 0f 1e fb          	endbr32 
801054c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054c5:	31 c0                	xor    %eax,%eax
{
801054c7:	89 e5                	mov    %esp,%ebp
801054c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054cc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054cf:	e8 bc fe ff ff       	call   80105390 <argfd.constprop.0>
801054d4:	85 c0                	test   %eax,%eax
801054d6:	78 48                	js     80105520 <sys_write+0x60>
801054d8:	83 ec 08             	sub    $0x8,%esp
801054db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054de:	50                   	push   %eax
801054df:	6a 02                	push   $0x2
801054e1:	e8 aa fb ff ff       	call   80105090 <argint>
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	85 c0                	test   %eax,%eax
801054eb:	78 33                	js     80105520 <sys_write+0x60>
801054ed:	83 ec 04             	sub    $0x4,%esp
801054f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f3:	ff 75 f0             	pushl  -0x10(%ebp)
801054f6:	50                   	push   %eax
801054f7:	6a 01                	push   $0x1
801054f9:	e8 e2 fb ff ff       	call   801050e0 <argptr>
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	85 c0                	test   %eax,%eax
80105503:	78 1b                	js     80105520 <sys_write+0x60>
  return filewrite(f, p, n);
80105505:	83 ec 04             	sub    $0x4,%esp
80105508:	ff 75 f0             	pushl  -0x10(%ebp)
8010550b:	ff 75 f4             	pushl  -0xc(%ebp)
8010550e:	ff 75 ec             	pushl  -0x14(%ebp)
80105511:	e8 7a bb ff ff       	call   80101090 <filewrite>
80105516:	83 c4 10             	add    $0x10,%esp
}
80105519:	c9                   	leave  
8010551a:	c3                   	ret    
8010551b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop
80105520:	c9                   	leave  
    return -1;
80105521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105526:	c3                   	ret    
80105527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552e:	66 90                	xchg   %ax,%ax

80105530 <sys_close>:
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010553a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010553d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105540:	e8 4b fe ff ff       	call   80105390 <argfd.constprop.0>
80105545:	85 c0                	test   %eax,%eax
80105547:	78 27                	js     80105570 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105549:	e8 22 e6 ff ff       	call   80103b70 <myproc>
8010554e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105551:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105554:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010555b:	00 
  fileclose(f);
8010555c:	ff 75 f4             	pushl  -0xc(%ebp)
8010555f:	e8 5c b9 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	31 c0                	xor    %eax,%eax
}
80105569:	c9                   	leave  
8010556a:	c3                   	ret    
8010556b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop
80105570:	c9                   	leave  
    return -1;
80105571:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105576:	c3                   	ret    
80105577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557e:	66 90                	xchg   %ax,%ax

80105580 <sys_fstat>:
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105585:	31 c0                	xor    %eax,%eax
{
80105587:	89 e5                	mov    %esp,%ebp
80105589:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010558c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010558f:	e8 fc fd ff ff       	call   80105390 <argfd.constprop.0>
80105594:	85 c0                	test   %eax,%eax
80105596:	78 30                	js     801055c8 <sys_fstat+0x48>
80105598:	83 ec 04             	sub    $0x4,%esp
8010559b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010559e:	6a 14                	push   $0x14
801055a0:	50                   	push   %eax
801055a1:	6a 01                	push   $0x1
801055a3:	e8 38 fb ff ff       	call   801050e0 <argptr>
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	85 c0                	test   %eax,%eax
801055ad:	78 19                	js     801055c8 <sys_fstat+0x48>
  return filestat(f, st);
801055af:	83 ec 08             	sub    $0x8,%esp
801055b2:	ff 75 f4             	pushl  -0xc(%ebp)
801055b5:	ff 75 f0             	pushl  -0x10(%ebp)
801055b8:	e8 e3 b9 ff ff       	call   80100fa0 <filestat>
801055bd:	83 c4 10             	add    $0x10,%esp
}
801055c0:	c9                   	leave  
801055c1:	c3                   	ret    
801055c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055c8:	c9                   	leave  
    return -1;
801055c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ce:	c3                   	ret    
801055cf:	90                   	nop

801055d0 <sys_link>:
{
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
801055d5:	89 e5                	mov    %esp,%ebp
801055d7:	57                   	push   %edi
801055d8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801055dc:	53                   	push   %ebx
801055dd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055e0:	50                   	push   %eax
801055e1:	6a 00                	push   $0x0
801055e3:	e8 58 fb ff ff       	call   80105140 <argstr>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	85 c0                	test   %eax,%eax
801055ed:	0f 88 ff 00 00 00    	js     801056f2 <sys_link+0x122>
801055f3:	83 ec 08             	sub    $0x8,%esp
801055f6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055f9:	50                   	push   %eax
801055fa:	6a 01                	push   $0x1
801055fc:	e8 3f fb ff ff       	call   80105140 <argstr>
80105601:	83 c4 10             	add    $0x10,%esp
80105604:	85 c0                	test   %eax,%eax
80105606:	0f 88 e6 00 00 00    	js     801056f2 <sys_link+0x122>
  begin_op();
8010560c:	e8 2f d8 ff ff       	call   80102e40 <begin_op>
  if((ip = namei(old)) == 0){
80105611:	83 ec 0c             	sub    $0xc,%esp
80105614:	ff 75 d4             	pushl  -0x2c(%ebp)
80105617:	e8 14 ca ff ff       	call   80102030 <namei>
8010561c:	83 c4 10             	add    $0x10,%esp
8010561f:	89 c3                	mov    %eax,%ebx
80105621:	85 c0                	test   %eax,%eax
80105623:	0f 84 e8 00 00 00    	je     80105711 <sys_link+0x141>
  ilock(ip);
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	50                   	push   %eax
8010562d:	e8 2e c1 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010563a:	0f 84 b9 00 00 00    	je     801056f9 <sys_link+0x129>
  iupdate(ip);
80105640:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105643:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105648:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010564b:	53                   	push   %ebx
8010564c:	e8 4f c0 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105651:	89 1c 24             	mov    %ebx,(%esp)
80105654:	e8 e7 c1 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105659:	58                   	pop    %eax
8010565a:	5a                   	pop    %edx
8010565b:	57                   	push   %edi
8010565c:	ff 75 d0             	pushl  -0x30(%ebp)
8010565f:	e8 ec c9 ff ff       	call   80102050 <nameiparent>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	89 c6                	mov    %eax,%esi
80105669:	85 c0                	test   %eax,%eax
8010566b:	74 5f                	je     801056cc <sys_link+0xfc>
  ilock(dp);
8010566d:	83 ec 0c             	sub    $0xc,%esp
80105670:	50                   	push   %eax
80105671:	e8 ea c0 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105676:	8b 03                	mov    (%ebx),%eax
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	39 06                	cmp    %eax,(%esi)
8010567d:	75 41                	jne    801056c0 <sys_link+0xf0>
8010567f:	83 ec 04             	sub    $0x4,%esp
80105682:	ff 73 04             	pushl  0x4(%ebx)
80105685:	57                   	push   %edi
80105686:	56                   	push   %esi
80105687:	e8 e4 c8 ff ff       	call   80101f70 <dirlink>
8010568c:	83 c4 10             	add    $0x10,%esp
8010568f:	85 c0                	test   %eax,%eax
80105691:	78 2d                	js     801056c0 <sys_link+0xf0>
  iunlockput(dp);
80105693:	83 ec 0c             	sub    $0xc,%esp
80105696:	56                   	push   %esi
80105697:	e8 64 c3 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010569c:	89 1c 24             	mov    %ebx,(%esp)
8010569f:	e8 ec c1 ff ff       	call   80101890 <iput>
  end_op();
801056a4:	e8 07 d8 ff ff       	call   80102eb0 <end_op>
  return 0;
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	31 c0                	xor    %eax,%eax
}
801056ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b1:	5b                   	pop    %ebx
801056b2:	5e                   	pop    %esi
801056b3:	5f                   	pop    %edi
801056b4:	5d                   	pop    %ebp
801056b5:	c3                   	ret    
801056b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	56                   	push   %esi
801056c4:	e8 37 c3 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801056c9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056cc:	83 ec 0c             	sub    $0xc,%esp
801056cf:	53                   	push   %ebx
801056d0:	e8 8b c0 ff ff       	call   80101760 <ilock>
  ip->nlink--;
801056d5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056da:	89 1c 24             	mov    %ebx,(%esp)
801056dd:	e8 be bf ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801056e2:	89 1c 24             	mov    %ebx,(%esp)
801056e5:	e8 16 c3 ff ff       	call   80101a00 <iunlockput>
  end_op();
801056ea:	e8 c1 d7 ff ff       	call   80102eb0 <end_op>
  return -1;
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f7:	eb b5                	jmp    801056ae <sys_link+0xde>
    iunlockput(ip);
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	53                   	push   %ebx
801056fd:	e8 fe c2 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105702:	e8 a9 d7 ff ff       	call   80102eb0 <end_op>
    return -1;
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570f:	eb 9d                	jmp    801056ae <sys_link+0xde>
    end_op();
80105711:	e8 9a d7 ff ff       	call   80102eb0 <end_op>
    return -1;
80105716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571b:	eb 91                	jmp    801056ae <sys_link+0xde>
8010571d:	8d 76 00             	lea    0x0(%esi),%esi

80105720 <sys_unlink>:
{
80105720:	f3 0f 1e fb          	endbr32 
80105724:	55                   	push   %ebp
80105725:	89 e5                	mov    %esp,%ebp
80105727:	57                   	push   %edi
80105728:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105729:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010572c:	53                   	push   %ebx
8010572d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105730:	50                   	push   %eax
80105731:	6a 00                	push   $0x0
80105733:	e8 08 fa ff ff       	call   80105140 <argstr>
80105738:	83 c4 10             	add    $0x10,%esp
8010573b:	85 c0                	test   %eax,%eax
8010573d:	0f 88 7d 01 00 00    	js     801058c0 <sys_unlink+0x1a0>
  begin_op();
80105743:	e8 f8 d6 ff ff       	call   80102e40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105748:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010574b:	83 ec 08             	sub    $0x8,%esp
8010574e:	53                   	push   %ebx
8010574f:	ff 75 c0             	pushl  -0x40(%ebp)
80105752:	e8 f9 c8 ff ff       	call   80102050 <nameiparent>
80105757:	83 c4 10             	add    $0x10,%esp
8010575a:	89 c6                	mov    %eax,%esi
8010575c:	85 c0                	test   %eax,%eax
8010575e:	0f 84 66 01 00 00    	je     801058ca <sys_unlink+0x1aa>
  ilock(dp);
80105764:	83 ec 0c             	sub    $0xc,%esp
80105767:	50                   	push   %eax
80105768:	e8 f3 bf ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010576d:	58                   	pop    %eax
8010576e:	5a                   	pop    %edx
8010576f:	68 2c 82 10 80       	push   $0x8010822c
80105774:	53                   	push   %ebx
80105775:	e8 16 c5 ff ff       	call   80101c90 <namecmp>
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	85 c0                	test   %eax,%eax
8010577f:	0f 84 03 01 00 00    	je     80105888 <sys_unlink+0x168>
80105785:	83 ec 08             	sub    $0x8,%esp
80105788:	68 2b 82 10 80       	push   $0x8010822b
8010578d:	53                   	push   %ebx
8010578e:	e8 fd c4 ff ff       	call   80101c90 <namecmp>
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	0f 84 ea 00 00 00    	je     80105888 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010579e:	83 ec 04             	sub    $0x4,%esp
801057a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801057a4:	50                   	push   %eax
801057a5:	53                   	push   %ebx
801057a6:	56                   	push   %esi
801057a7:	e8 04 c5 ff ff       	call   80101cb0 <dirlookup>
801057ac:	83 c4 10             	add    $0x10,%esp
801057af:	89 c3                	mov    %eax,%ebx
801057b1:	85 c0                	test   %eax,%eax
801057b3:	0f 84 cf 00 00 00    	je     80105888 <sys_unlink+0x168>
  ilock(ip);
801057b9:	83 ec 0c             	sub    $0xc,%esp
801057bc:	50                   	push   %eax
801057bd:	e8 9e bf ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057ca:	0f 8e 23 01 00 00    	jle    801058f3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801057d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057d8:	74 66                	je     80105840 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801057da:	83 ec 04             	sub    $0x4,%esp
801057dd:	6a 10                	push   $0x10
801057df:	6a 00                	push   $0x0
801057e1:	57                   	push   %edi
801057e2:	e8 c9 f5 ff ff       	call   80104db0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057e7:	6a 10                	push   $0x10
801057e9:	ff 75 c4             	pushl  -0x3c(%ebp)
801057ec:	57                   	push   %edi
801057ed:	56                   	push   %esi
801057ee:	e8 6d c3 ff ff       	call   80101b60 <writei>
801057f3:	83 c4 20             	add    $0x20,%esp
801057f6:	83 f8 10             	cmp    $0x10,%eax
801057f9:	0f 85 e7 00 00 00    	jne    801058e6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801057ff:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105804:	0f 84 96 00 00 00    	je     801058a0 <sys_unlink+0x180>
  iunlockput(dp);
8010580a:	83 ec 0c             	sub    $0xc,%esp
8010580d:	56                   	push   %esi
8010580e:	e8 ed c1 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105813:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105818:	89 1c 24             	mov    %ebx,(%esp)
8010581b:	e8 80 be ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105820:	89 1c 24             	mov    %ebx,(%esp)
80105823:	e8 d8 c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105828:	e8 83 d6 ff ff       	call   80102eb0 <end_op>
  return 0;
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	31 c0                	xor    %eax,%eax
}
80105832:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105835:	5b                   	pop    %ebx
80105836:	5e                   	pop    %esi
80105837:	5f                   	pop    %edi
80105838:	5d                   	pop    %ebp
80105839:	c3                   	ret    
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105840:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105844:	76 94                	jbe    801057da <sys_unlink+0xba>
80105846:	ba 20 00 00 00       	mov    $0x20,%edx
8010584b:	eb 0b                	jmp    80105858 <sys_unlink+0x138>
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
80105850:	83 c2 10             	add    $0x10,%edx
80105853:	39 53 58             	cmp    %edx,0x58(%ebx)
80105856:	76 82                	jbe    801057da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105858:	6a 10                	push   $0x10
8010585a:	52                   	push   %edx
8010585b:	57                   	push   %edi
8010585c:	53                   	push   %ebx
8010585d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105860:	e8 fb c1 ff ff       	call   80101a60 <readi>
80105865:	83 c4 10             	add    $0x10,%esp
80105868:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010586b:	83 f8 10             	cmp    $0x10,%eax
8010586e:	75 69                	jne    801058d9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105870:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105875:	74 d9                	je     80105850 <sys_unlink+0x130>
    iunlockput(ip);
80105877:	83 ec 0c             	sub    $0xc,%esp
8010587a:	53                   	push   %ebx
8010587b:	e8 80 c1 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105880:	83 c4 10             	add    $0x10,%esp
80105883:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105887:	90                   	nop
  iunlockput(dp);
80105888:	83 ec 0c             	sub    $0xc,%esp
8010588b:	56                   	push   %esi
8010588c:	e8 6f c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105891:	e8 1a d6 ff ff       	call   80102eb0 <end_op>
  return -1;
80105896:	83 c4 10             	add    $0x10,%esp
80105899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589e:	eb 92                	jmp    80105832 <sys_unlink+0x112>
    iupdate(dp);
801058a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801058a3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801058a8:	56                   	push   %esi
801058a9:	e8 f2 bd ff ff       	call   801016a0 <iupdate>
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	e9 54 ff ff ff       	jmp    8010580a <sys_unlink+0xea>
801058b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c5:	e9 68 ff ff ff       	jmp    80105832 <sys_unlink+0x112>
    end_op();
801058ca:	e8 e1 d5 ff ff       	call   80102eb0 <end_op>
    return -1;
801058cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d4:	e9 59 ff ff ff       	jmp    80105832 <sys_unlink+0x112>
      panic("isdirempty: readi");
801058d9:	83 ec 0c             	sub    $0xc,%esp
801058dc:	68 50 82 10 80       	push   $0x80108250
801058e1:	e8 aa aa ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801058e6:	83 ec 0c             	sub    $0xc,%esp
801058e9:	68 62 82 10 80       	push   $0x80108262
801058ee:	e8 9d aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801058f3:	83 ec 0c             	sub    $0xc,%esp
801058f6:	68 3e 82 10 80       	push   $0x8010823e
801058fb:	e8 90 aa ff ff       	call   80100390 <panic>

80105900 <sys_open>:

int
sys_open(void)
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
80105905:	89 e5                	mov    %esp,%ebp
80105907:	57                   	push   %edi
80105908:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105909:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010590c:	53                   	push   %ebx
8010590d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105910:	50                   	push   %eax
80105911:	6a 00                	push   $0x0
80105913:	e8 28 f8 ff ff       	call   80105140 <argstr>
80105918:	83 c4 10             	add    $0x10,%esp
8010591b:	85 c0                	test   %eax,%eax
8010591d:	0f 88 8a 00 00 00    	js     801059ad <sys_open+0xad>
80105923:	83 ec 08             	sub    $0x8,%esp
80105926:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105929:	50                   	push   %eax
8010592a:	6a 01                	push   $0x1
8010592c:	e8 5f f7 ff ff       	call   80105090 <argint>
80105931:	83 c4 10             	add    $0x10,%esp
80105934:	85 c0                	test   %eax,%eax
80105936:	78 75                	js     801059ad <sys_open+0xad>
    return -1;

  begin_op();
80105938:	e8 03 d5 ff ff       	call   80102e40 <begin_op>

  if(omode & O_CREATE){
8010593d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105941:	75 75                	jne    801059b8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105943:	83 ec 0c             	sub    $0xc,%esp
80105946:	ff 75 e0             	pushl  -0x20(%ebp)
80105949:	e8 e2 c6 ff ff       	call   80102030 <namei>
8010594e:	83 c4 10             	add    $0x10,%esp
80105951:	89 c6                	mov    %eax,%esi
80105953:	85 c0                	test   %eax,%eax
80105955:	74 7e                	je     801059d5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105957:	83 ec 0c             	sub    $0xc,%esp
8010595a:	50                   	push   %eax
8010595b:	e8 00 be ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105960:	83 c4 10             	add    $0x10,%esp
80105963:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105968:	0f 84 c2 00 00 00    	je     80105a30 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010596e:	e8 8d b4 ff ff       	call   80100e00 <filealloc>
80105973:	89 c7                	mov    %eax,%edi
80105975:	85 c0                	test   %eax,%eax
80105977:	74 23                	je     8010599c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105979:	e8 f2 e1 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010597e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105980:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105984:	85 d2                	test   %edx,%edx
80105986:	74 60                	je     801059e8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105988:	83 c3 01             	add    $0x1,%ebx
8010598b:	83 fb 10             	cmp    $0x10,%ebx
8010598e:	75 f0                	jne    80105980 <sys_open+0x80>
    if(f)
      fileclose(f);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	57                   	push   %edi
80105994:	e8 27 b5 ff ff       	call   80100ec0 <fileclose>
80105999:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010599c:	83 ec 0c             	sub    $0xc,%esp
8010599f:	56                   	push   %esi
801059a0:	e8 5b c0 ff ff       	call   80101a00 <iunlockput>
    end_op();
801059a5:	e8 06 d5 ff ff       	call   80102eb0 <end_op>
    return -1;
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059b2:	eb 6d                	jmp    80105a21 <sys_open+0x121>
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059be:	31 c9                	xor    %ecx,%ecx
801059c0:	ba 02 00 00 00       	mov    $0x2,%edx
801059c5:	6a 00                	push   $0x0
801059c7:	e8 24 f8 ff ff       	call   801051f0 <create>
    if(ip == 0){
801059cc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801059cf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801059d1:	85 c0                	test   %eax,%eax
801059d3:	75 99                	jne    8010596e <sys_open+0x6e>
      end_op();
801059d5:	e8 d6 d4 ff ff       	call   80102eb0 <end_op>
      return -1;
801059da:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059df:	eb 40                	jmp    80105a21 <sys_open+0x121>
801059e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801059e8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059eb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801059ef:	56                   	push   %esi
801059f0:	e8 4b be ff ff       	call   80101840 <iunlock>
  end_op();
801059f5:	e8 b6 d4 ff ff       	call   80102eb0 <end_op>

  f->type = FD_INODE;
801059fa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a03:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a06:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105a09:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105a0b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a12:	f7 d0                	not    %eax
80105a14:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a17:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105a1a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a1d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a24:	89 d8                	mov    %ebx,%eax
80105a26:	5b                   	pop    %ebx
80105a27:	5e                   	pop    %esi
80105a28:	5f                   	pop    %edi
80105a29:	5d                   	pop    %ebp
80105a2a:	c3                   	ret    
80105a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a2f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a30:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a33:	85 c9                	test   %ecx,%ecx
80105a35:	0f 84 33 ff ff ff    	je     8010596e <sys_open+0x6e>
80105a3b:	e9 5c ff ff ff       	jmp    8010599c <sys_open+0x9c>

80105a40 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a4a:	e8 f1 d3 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a4f:	83 ec 08             	sub    $0x8,%esp
80105a52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a55:	50                   	push   %eax
80105a56:	6a 00                	push   $0x0
80105a58:	e8 e3 f6 ff ff       	call   80105140 <argstr>
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	85 c0                	test   %eax,%eax
80105a62:	78 34                	js     80105a98 <sys_mkdir+0x58>
80105a64:	83 ec 0c             	sub    $0xc,%esp
80105a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a6a:	31 c9                	xor    %ecx,%ecx
80105a6c:	ba 01 00 00 00       	mov    $0x1,%edx
80105a71:	6a 00                	push   $0x0
80105a73:	e8 78 f7 ff ff       	call   801051f0 <create>
80105a78:	83 c4 10             	add    $0x10,%esp
80105a7b:	85 c0                	test   %eax,%eax
80105a7d:	74 19                	je     80105a98 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a7f:	83 ec 0c             	sub    $0xc,%esp
80105a82:	50                   	push   %eax
80105a83:	e8 78 bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105a88:	e8 23 d4 ff ff       	call   80102eb0 <end_op>
  return 0;
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	31 c0                	xor    %eax,%eax
}
80105a92:	c9                   	leave  
80105a93:	c3                   	ret    
80105a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a98:	e8 13 d4 ff ff       	call   80102eb0 <end_op>
    return -1;
80105a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa2:	c9                   	leave  
80105aa3:	c3                   	ret    
80105aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop

80105ab0 <sys_mknod>:

int
sys_mknod(void)
{
80105ab0:	f3 0f 1e fb          	endbr32 
80105ab4:	55                   	push   %ebp
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105aba:	e8 81 d3 ff ff       	call   80102e40 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105abf:	83 ec 08             	sub    $0x8,%esp
80105ac2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ac5:	50                   	push   %eax
80105ac6:	6a 00                	push   $0x0
80105ac8:	e8 73 f6 ff ff       	call   80105140 <argstr>
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	85 c0                	test   %eax,%eax
80105ad2:	78 64                	js     80105b38 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105ad4:	83 ec 08             	sub    $0x8,%esp
80105ad7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ada:	50                   	push   %eax
80105adb:	6a 01                	push   $0x1
80105add:	e8 ae f5 ff ff       	call   80105090 <argint>
  if((argstr(0, &path)) < 0 ||
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	78 4f                	js     80105b38 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105ae9:	83 ec 08             	sub    $0x8,%esp
80105aec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aef:	50                   	push   %eax
80105af0:	6a 02                	push   $0x2
80105af2:	e8 99 f5 ff ff       	call   80105090 <argint>
     argint(1, &major) < 0 ||
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	85 c0                	test   %eax,%eax
80105afc:	78 3a                	js     80105b38 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105afe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105b02:	83 ec 0c             	sub    $0xc,%esp
80105b05:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b09:	ba 03 00 00 00       	mov    $0x3,%edx
80105b0e:	50                   	push   %eax
80105b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b12:	e8 d9 f6 ff ff       	call   801051f0 <create>
     argint(2, &minor) < 0 ||
80105b17:	83 c4 10             	add    $0x10,%esp
80105b1a:	85 c0                	test   %eax,%eax
80105b1c:	74 1a                	je     80105b38 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b1e:	83 ec 0c             	sub    $0xc,%esp
80105b21:	50                   	push   %eax
80105b22:	e8 d9 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105b27:	e8 84 d3 ff ff       	call   80102eb0 <end_op>
  return 0;
80105b2c:	83 c4 10             	add    $0x10,%esp
80105b2f:	31 c0                	xor    %eax,%eax
}
80105b31:	c9                   	leave  
80105b32:	c3                   	ret    
80105b33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b37:	90                   	nop
    end_op();
80105b38:	e8 73 d3 ff ff       	call   80102eb0 <end_op>
    return -1;
80105b3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b42:	c9                   	leave  
80105b43:	c3                   	ret    
80105b44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b4f:	90                   	nop

80105b50 <sys_chdir>:

int
sys_chdir(void)
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
80105b55:	89 e5                	mov    %esp,%ebp
80105b57:	56                   	push   %esi
80105b58:	53                   	push   %ebx
80105b59:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b5c:	e8 0f e0 ff ff       	call   80103b70 <myproc>
80105b61:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b63:	e8 d8 d2 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b68:	83 ec 08             	sub    $0x8,%esp
80105b6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b6e:	50                   	push   %eax
80105b6f:	6a 00                	push   $0x0
80105b71:	e8 ca f5 ff ff       	call   80105140 <argstr>
80105b76:	83 c4 10             	add    $0x10,%esp
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	78 73                	js     80105bf0 <sys_chdir+0xa0>
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	ff 75 f4             	pushl  -0xc(%ebp)
80105b83:	e8 a8 c4 ff ff       	call   80102030 <namei>
80105b88:	83 c4 10             	add    $0x10,%esp
80105b8b:	89 c3                	mov    %eax,%ebx
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	74 5f                	je     80105bf0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b91:	83 ec 0c             	sub    $0xc,%esp
80105b94:	50                   	push   %eax
80105b95:	e8 c6 bb ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105b9a:	83 c4 10             	add    $0x10,%esp
80105b9d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ba2:	75 2c                	jne    80105bd0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ba4:	83 ec 0c             	sub    $0xc,%esp
80105ba7:	53                   	push   %ebx
80105ba8:	e8 93 bc ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105bad:	58                   	pop    %eax
80105bae:	ff 76 68             	pushl  0x68(%esi)
80105bb1:	e8 da bc ff ff       	call   80101890 <iput>
  end_op();
80105bb6:	e8 f5 d2 ff ff       	call   80102eb0 <end_op>
  curproc->cwd = ip;
80105bbb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	31 c0                	xor    %eax,%eax
}
80105bc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bc6:	5b                   	pop    %ebx
80105bc7:	5e                   	pop    %esi
80105bc8:	5d                   	pop    %ebp
80105bc9:	c3                   	ret    
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105bd0:	83 ec 0c             	sub    $0xc,%esp
80105bd3:	53                   	push   %ebx
80105bd4:	e8 27 be ff ff       	call   80101a00 <iunlockput>
    end_op();
80105bd9:	e8 d2 d2 ff ff       	call   80102eb0 <end_op>
    return -1;
80105bde:	83 c4 10             	add    $0x10,%esp
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be6:	eb db                	jmp    80105bc3 <sys_chdir+0x73>
80105be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop
    end_op();
80105bf0:	e8 bb d2 ff ff       	call   80102eb0 <end_op>
    return -1;
80105bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bfa:	eb c7                	jmp    80105bc3 <sys_chdir+0x73>
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_exec>:

int
sys_exec(void)
{
80105c00:	f3 0f 1e fb          	endbr32 
80105c04:	55                   	push   %ebp
80105c05:	89 e5                	mov    %esp,%ebp
80105c07:	57                   	push   %edi
80105c08:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c09:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105c0f:	53                   	push   %ebx
80105c10:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c16:	50                   	push   %eax
80105c17:	6a 00                	push   $0x0
80105c19:	e8 22 f5 ff ff       	call   80105140 <argstr>
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	85 c0                	test   %eax,%eax
80105c23:	0f 88 8b 00 00 00    	js     80105cb4 <sys_exec+0xb4>
80105c29:	83 ec 08             	sub    $0x8,%esp
80105c2c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c32:	50                   	push   %eax
80105c33:	6a 01                	push   $0x1
80105c35:	e8 56 f4 ff ff       	call   80105090 <argint>
80105c3a:	83 c4 10             	add    $0x10,%esp
80105c3d:	85 c0                	test   %eax,%eax
80105c3f:	78 73                	js     80105cb4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c41:	83 ec 04             	sub    $0x4,%esp
80105c44:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105c4a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105c4c:	68 80 00 00 00       	push   $0x80
80105c51:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105c57:	6a 00                	push   $0x0
80105c59:	50                   	push   %eax
80105c5a:	e8 51 f1 ff ff       	call   80104db0 <memset>
80105c5f:	83 c4 10             	add    $0x10,%esp
80105c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c68:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c6e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c75:	83 ec 08             	sub    $0x8,%esp
80105c78:	57                   	push   %edi
80105c79:	01 f0                	add    %esi,%eax
80105c7b:	50                   	push   %eax
80105c7c:	e8 6f f3 ff ff       	call   80104ff0 <fetchint>
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	85 c0                	test   %eax,%eax
80105c86:	78 2c                	js     80105cb4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105c88:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c8e:	85 c0                	test   %eax,%eax
80105c90:	74 36                	je     80105cc8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c92:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105c98:	83 ec 08             	sub    $0x8,%esp
80105c9b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105c9e:	52                   	push   %edx
80105c9f:	50                   	push   %eax
80105ca0:	e8 8b f3 ff ff       	call   80105030 <fetchstr>
80105ca5:	83 c4 10             	add    $0x10,%esp
80105ca8:	85 c0                	test   %eax,%eax
80105caa:	78 08                	js     80105cb4 <sys_exec+0xb4>
  for(i=0;; i++){
80105cac:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105caf:	83 fb 20             	cmp    $0x20,%ebx
80105cb2:	75 b4                	jne    80105c68 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105cb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105cb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cbc:	5b                   	pop    %ebx
80105cbd:	5e                   	pop    %esi
80105cbe:	5f                   	pop    %edi
80105cbf:	5d                   	pop    %ebp
80105cc0:	c3                   	ret    
80105cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105cc8:	83 ec 08             	sub    $0x8,%esp
80105ccb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105cd1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105cd8:	00 00 00 00 
  return exec(path, argv);
80105cdc:	50                   	push   %eax
80105cdd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105ce3:	e8 98 ad ff ff       	call   80100a80 <exec>
80105ce8:	83 c4 10             	add    $0x10,%esp
}
80105ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cee:	5b                   	pop    %ebx
80105cef:	5e                   	pop    %esi
80105cf0:	5f                   	pop    %edi
80105cf1:	5d                   	pop    %ebp
80105cf2:	c3                   	ret    
80105cf3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d00 <sys_pipe>:

int
sys_pipe(void)
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	57                   	push   %edi
80105d08:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d09:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105d0c:	53                   	push   %ebx
80105d0d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d10:	6a 08                	push   $0x8
80105d12:	50                   	push   %eax
80105d13:	6a 00                	push   $0x0
80105d15:	e8 c6 f3 ff ff       	call   801050e0 <argptr>
80105d1a:	83 c4 10             	add    $0x10,%esp
80105d1d:	85 c0                	test   %eax,%eax
80105d1f:	78 4e                	js     80105d6f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d21:	83 ec 08             	sub    $0x8,%esp
80105d24:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d27:	50                   	push   %eax
80105d28:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d2b:	50                   	push   %eax
80105d2c:	e8 cf d7 ff ff       	call   80103500 <pipealloc>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	85 c0                	test   %eax,%eax
80105d36:	78 37                	js     80105d6f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d38:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105d3b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d3d:	e8 2e de ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105d48:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105d4c:	85 f6                	test   %esi,%esi
80105d4e:	74 30                	je     80105d80 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105d50:	83 c3 01             	add    $0x1,%ebx
80105d53:	83 fb 10             	cmp    $0x10,%ebx
80105d56:	75 f0                	jne    80105d48 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105d58:	83 ec 0c             	sub    $0xc,%esp
80105d5b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d5e:	e8 5d b1 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105d63:	58                   	pop    %eax
80105d64:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d67:	e8 54 b1 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105d6c:	83 c4 10             	add    $0x10,%esp
80105d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d74:	eb 5b                	jmp    80105dd1 <sys_pipe+0xd1>
80105d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d7d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105d80:	8d 73 08             	lea    0x8(%ebx),%esi
80105d83:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d8a:	e8 e1 dd ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d8f:	31 d2                	xor    %edx,%edx
80105d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d98:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d9c:	85 c9                	test   %ecx,%ecx
80105d9e:	74 20                	je     80105dc0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105da0:	83 c2 01             	add    $0x1,%edx
80105da3:	83 fa 10             	cmp    $0x10,%edx
80105da6:	75 f0                	jne    80105d98 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105da8:	e8 c3 dd ff ff       	call   80103b70 <myproc>
80105dad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105db4:	00 
80105db5:	eb a1                	jmp    80105d58 <sys_pipe+0x58>
80105db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105dc0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105dc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105dc7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105dcc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105dcf:	31 c0                	xor    %eax,%eax
}
80105dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dd4:	5b                   	pop    %ebx
80105dd5:	5e                   	pop    %esi
80105dd6:	5f                   	pop    %edi
80105dd7:	5d                   	pop    %ebp
80105dd8:	c3                   	ret    
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105de0 <sys_swapread>:

int sys_swapread(void)
{
80105de0:	f3 0f 1e fb          	endbr32 
80105de4:	55                   	push   %ebp
80105de5:	89 e5                	mov    %esp,%ebp
80105de7:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105dea:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ded:	68 00 10 00 00       	push   $0x1000
80105df2:	50                   	push   %eax
80105df3:	6a 00                	push   $0x0
80105df5:	e8 e6 f2 ff ff       	call   801050e0 <argptr>
80105dfa:	83 c4 10             	add    $0x10,%esp
80105dfd:	85 c0                	test   %eax,%eax
80105dff:	78 2f                	js     80105e30 <sys_swapread+0x50>
80105e01:	83 ec 08             	sub    $0x8,%esp
80105e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e07:	50                   	push   %eax
80105e08:	6a 01                	push   $0x1
80105e0a:	e8 81 f2 ff ff       	call   80105090 <argint>
80105e0f:	83 c4 10             	add    $0x10,%esp
80105e12:	85 c0                	test   %eax,%eax
80105e14:	78 1a                	js     80105e30 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105e16:	83 ec 08             	sub    $0x8,%esp
80105e19:	ff 75 f4             	pushl  -0xc(%ebp)
80105e1c:	ff 75 f0             	pushl  -0x10(%ebp)
80105e1f:	e8 4c c2 ff ff       	call   80102070 <swapread>
	return 0;
80105e24:	83 c4 10             	add    $0x10,%esp
80105e27:	31 c0                	xor    %eax,%eax
}
80105e29:	c9                   	leave  
80105e2a:	c3                   	ret    
80105e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop
80105e30:	c9                   	leave  
		return -1;
80105e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e36:	c3                   	ret    
80105e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3e:	66 90                	xchg   %ax,%ax

80105e40 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105e40:	f3 0f 1e fb          	endbr32 
80105e44:	55                   	push   %ebp
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105e4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e4d:	68 00 10 00 00       	push   $0x1000
80105e52:	50                   	push   %eax
80105e53:	6a 00                	push   $0x0
80105e55:	e8 86 f2 ff ff       	call   801050e0 <argptr>
80105e5a:	83 c4 10             	add    $0x10,%esp
80105e5d:	85 c0                	test   %eax,%eax
80105e5f:	78 2f                	js     80105e90 <sys_swapwrite+0x50>
80105e61:	83 ec 08             	sub    $0x8,%esp
80105e64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e67:	50                   	push   %eax
80105e68:	6a 01                	push   $0x1
80105e6a:	e8 21 f2 ff ff       	call   80105090 <argint>
80105e6f:	83 c4 10             	add    $0x10,%esp
80105e72:	85 c0                	test   %eax,%eax
80105e74:	78 1a                	js     80105e90 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105e76:	83 ec 08             	sub    $0x8,%esp
80105e79:	ff 75 f4             	pushl  -0xc(%ebp)
80105e7c:	ff 75 f0             	pushl  -0x10(%ebp)
80105e7f:	e8 6c c2 ff ff       	call   801020f0 <swapwrite>
	return 0;
80105e84:	83 c4 10             	add    $0x10,%esp
80105e87:	31 c0                	xor    %eax,%eax
}
80105e89:	c9                   	leave  
80105e8a:	c3                   	ret    
80105e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e8f:	90                   	nop
80105e90:	c9                   	leave  
		return -1;
80105e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e96:	c3                   	ret    
80105e97:	66 90                	xchg   %ax,%ax
80105e99:	66 90                	xchg   %ax,%ax
80105e9b:	66 90                	xchg   %ax,%ax
80105e9d:	66 90                	xchg   %ax,%ax
80105e9f:	90                   	nop

80105ea0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ea0:	f3 0f 1e fb          	endbr32 
  return fork();
80105ea4:	e9 87 de ff ff       	jmp    80103d30 <fork>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_exit>:
}

int
sys_exit(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105eba:	e8 e1 e1 ff ff       	call   801040a0 <exit>
  return 0;  // not reached
}
80105ebf:	31 c0                	xor    %eax,%eax
80105ec1:	c9                   	leave  
80105ec2:	c3                   	ret    
80105ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ed0 <sys_wait>:

int
sys_wait(void)
{
80105ed0:	f3 0f 1e fb          	endbr32 
  return wait();
80105ed4:	e9 d7 e3 ff ff       	jmp    801042b0 <wait>
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_kill>:
}

int
sys_kill(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
80105ee4:	55                   	push   %ebp
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105eea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eed:	50                   	push   %eax
80105eee:	6a 00                	push   $0x0
80105ef0:	e8 9b f1 ff ff       	call   80105090 <argint>
80105ef5:	83 c4 10             	add    $0x10,%esp
80105ef8:	85 c0                	test   %eax,%eax
80105efa:	78 14                	js     80105f10 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105efc:	83 ec 0c             	sub    $0xc,%esp
80105eff:	ff 75 f4             	pushl  -0xc(%ebp)
80105f02:	e8 e9 e4 ff ff       	call   801043f0 <kill>
80105f07:	83 c4 10             	add    $0x10,%esp
}
80105f0a:	c9                   	leave  
80105f0b:	c3                   	ret    
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f10:	c9                   	leave  
    return -1;
80105f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f16:	c3                   	ret    
80105f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f1e:	66 90                	xchg   %ax,%ax

80105f20 <sys_getpid>:

int
sys_getpid(void)
{
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f2a:	e8 41 dc ff ff       	call   80103b70 <myproc>
80105f2f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f32:	c9                   	leave  
80105f33:	c3                   	ret    
80105f34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f3f:	90                   	nop

80105f40 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f40:	f3 0f 1e fb          	endbr32 
80105f44:	55                   	push   %ebp
80105f45:	89 e5                	mov    %esp,%ebp
80105f47:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f48:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f4b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f4e:	50                   	push   %eax
80105f4f:	6a 00                	push   $0x0
80105f51:	e8 3a f1 ff ff       	call   80105090 <argint>
80105f56:	83 c4 10             	add    $0x10,%esp
80105f59:	85 c0                	test   %eax,%eax
80105f5b:	78 23                	js     80105f80 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f5d:	e8 0e dc ff ff       	call   80103b70 <myproc>
  if(growproc(n) < 0)
80105f62:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f65:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f67:	ff 75 f4             	pushl  -0xc(%ebp)
80105f6a:	e8 41 dd ff ff       	call   80103cb0 <growproc>
80105f6f:	83 c4 10             	add    $0x10,%esp
80105f72:	85 c0                	test   %eax,%eax
80105f74:	78 0a                	js     80105f80 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f76:	89 d8                	mov    %ebx,%eax
80105f78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f7b:	c9                   	leave  
80105f7c:	c3                   	ret    
80105f7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f85:	eb ef                	jmp    80105f76 <sys_sbrk+0x36>
80105f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <sys_sleep>:

int
sys_sleep(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f98:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f9b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f9e:	50                   	push   %eax
80105f9f:	6a 00                	push   $0x0
80105fa1:	e8 ea f0 ff ff       	call   80105090 <argint>
80105fa6:	83 c4 10             	add    $0x10,%esp
80105fa9:	85 c0                	test   %eax,%eax
80105fab:	0f 88 86 00 00 00    	js     80106037 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105fb1:	83 ec 0c             	sub    $0xc,%esp
80105fb4:	68 a0 62 11 80       	push   $0x801162a0
80105fb9:	e8 e2 ec ff ff       	call   80104ca0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105fc1:	8b 1d e0 6a 11 80    	mov    0x80116ae0,%ebx
  while(ticks - ticks0 < n){
80105fc7:	83 c4 10             	add    $0x10,%esp
80105fca:	85 d2                	test   %edx,%edx
80105fcc:	75 23                	jne    80105ff1 <sys_sleep+0x61>
80105fce:	eb 50                	jmp    80106020 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105fd0:	83 ec 08             	sub    $0x8,%esp
80105fd3:	68 a0 62 11 80       	push   $0x801162a0
80105fd8:	68 e0 6a 11 80       	push   $0x80116ae0
80105fdd:	e8 0e e2 ff ff       	call   801041f0 <sleep>
  while(ticks - ticks0 < n){
80105fe2:	a1 e0 6a 11 80       	mov    0x80116ae0,%eax
80105fe7:	83 c4 10             	add    $0x10,%esp
80105fea:	29 d8                	sub    %ebx,%eax
80105fec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fef:	73 2f                	jae    80106020 <sys_sleep+0x90>
    if(myproc()->killed){
80105ff1:	e8 7a db ff ff       	call   80103b70 <myproc>
80105ff6:	8b 40 24             	mov    0x24(%eax),%eax
80105ff9:	85 c0                	test   %eax,%eax
80105ffb:	74 d3                	je     80105fd0 <sys_sleep+0x40>
      release(&tickslock);
80105ffd:	83 ec 0c             	sub    $0xc,%esp
80106000:	68 a0 62 11 80       	push   $0x801162a0
80106005:	e8 56 ed ff ff       	call   80104d60 <release>
  }
  release(&tickslock);
  return 0;
}
8010600a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010600d:	83 c4 10             	add    $0x10,%esp
80106010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106015:	c9                   	leave  
80106016:	c3                   	ret    
80106017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	68 a0 62 11 80       	push   $0x801162a0
80106028:	e8 33 ed ff ff       	call   80104d60 <release>
  return 0;
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	31 c0                	xor    %eax,%eax
}
80106032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106035:	c9                   	leave  
80106036:	c3                   	ret    
    return -1;
80106037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603c:	eb f4                	jmp    80106032 <sys_sleep+0xa2>
8010603e:	66 90                	xchg   %ax,%ax

80106040 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	53                   	push   %ebx
80106048:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010604b:	68 a0 62 11 80       	push   $0x801162a0
80106050:	e8 4b ec ff ff       	call   80104ca0 <acquire>
  xticks = ticks;
80106055:	8b 1d e0 6a 11 80    	mov    0x80116ae0,%ebx
  release(&tickslock);
8010605b:	c7 04 24 a0 62 11 80 	movl   $0x801162a0,(%esp)
80106062:	e8 f9 ec ff ff       	call   80104d60 <release>
  return xticks;
}
80106067:	89 d8                	mov    %ebx,%eax
80106069:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010606c:	c9                   	leave  
8010606d:	c3                   	ret    
8010606e:	66 90                	xchg   %ax,%ax

80106070 <sys_setnice>:

// My Code
int sys_setnice(void){
80106070:	f3 0f 1e fb          	endbr32 
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	83 ec 20             	sub    $0x20,%esp
	int pid, nice;
	if(argint(0,&pid)<0)
8010607a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010607d:	50                   	push   %eax
8010607e:	6a 00                	push   $0x0
80106080:	e8 0b f0 ff ff       	call   80105090 <argint>
80106085:	83 c4 10             	add    $0x10,%esp
80106088:	85 c0                	test   %eax,%eax
8010608a:	78 34                	js     801060c0 <sys_setnice+0x50>
		return -1;
	if(argint(1,&nice)<0)
8010608c:	83 ec 08             	sub    $0x8,%esp
8010608f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106092:	50                   	push   %eax
80106093:	6a 01                	push   $0x1
80106095:	e8 f6 ef ff ff       	call   80105090 <argint>
8010609a:	83 c4 10             	add    $0x10,%esp
8010609d:	85 c0                	test   %eax,%eax
8010609f:	78 1f                	js     801060c0 <sys_setnice+0x50>
		return -1;
	if(nice<0||nice>10)
801060a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a4:	83 f8 0a             	cmp    $0xa,%eax
801060a7:	77 17                	ja     801060c0 <sys_setnice+0x50>
		return -1;
	int ret = setnice(pid,nice);
801060a9:	83 ec 08             	sub    $0x8,%esp
801060ac:	50                   	push   %eax
801060ad:	ff 75 f0             	pushl  -0x10(%ebp)
801060b0:	e8 ab e4 ff ff       	call   80104560 <setnice>
	return ret;
801060b5:	83 c4 10             	add    $0x10,%esp
}
801060b8:	c9                   	leave  
801060b9:	c3                   	ret    
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801060c0:	c9                   	leave  
		return -1;
801060c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c6:	c3                   	ret    
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <sys_getnice>:

int sys_getnice(void){
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	83 ec 20             	sub    $0x20,%esp
	int pid;	
	if(argint(0,&pid)<0)
801060da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060dd:	50                   	push   %eax
801060de:	6a 00                	push   $0x0
801060e0:	e8 ab ef ff ff       	call   80105090 <argint>
801060e5:	83 c4 10             	add    $0x10,%esp
801060e8:	85 c0                	test   %eax,%eax
801060ea:	78 14                	js     80106100 <sys_getnice+0x30>
		return -1;
	int ret = getnice(pid);
801060ec:	83 ec 0c             	sub    $0xc,%esp
801060ef:	ff 75 f4             	pushl  -0xc(%ebp)
801060f2:	e8 f9 e4 ff ff       	call   801045f0 <getnice>
	return ret;
801060f7:	83 c4 10             	add    $0x10,%esp
}
801060fa:	c9                   	leave  
801060fb:	c3                   	ret    
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106100:	c9                   	leave  
		return -1;
80106101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106106:	c3                   	ret    
80106107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610e:	66 90                	xchg   %ax,%ax

80106110 <sys_yield>:

int sys_yield(void){
80106110:	f3 0f 1e fb          	endbr32 
80106114:	55                   	push   %ebp
80106115:	89 e5                	mov    %esp,%ebp
80106117:	83 ec 08             	sub    $0x8,%esp
	yield();
8010611a:	e8 81 e0 ff ff       	call   801041a0 <yield>
	return 0;
}
8010611f:	31 c0                	xor    %eax,%eax
80106121:	c9                   	leave  
80106122:	c3                   	ret    
80106123:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106130 <sys_ps>:

int sys_ps(void){
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	83 ec 08             	sub    $0x8,%esp
	ps();
8010613a:	e8 d1 e7 ff ff       	call   80104910 <ps>
	return 0;
}
8010613f:	31 c0                	xor    %eax,%eax
80106141:	c9                   	leave  
80106142:	c3                   	ret    

80106143 <alltraps>:
80106143:	1e                   	push   %ds
80106144:	06                   	push   %es
80106145:	0f a0                	push   %fs
80106147:	0f a8                	push   %gs
80106149:	60                   	pusha  
8010614a:	66 b8 10 00          	mov    $0x10,%ax
8010614e:	8e d8                	mov    %eax,%ds
80106150:	8e c0                	mov    %eax,%es
80106152:	54                   	push   %esp
80106153:	e8 c8 00 00 00       	call   80106220 <trap>
80106158:	83 c4 04             	add    $0x4,%esp

8010615b <trapret>:
8010615b:	61                   	popa   
8010615c:	0f a9                	pop    %gs
8010615e:	0f a1                	pop    %fs
80106160:	07                   	pop    %es
80106161:	1f                   	pop    %ds
80106162:	83 c4 08             	add    $0x8,%esp
80106165:	cf                   	iret   
80106166:	66 90                	xchg   %ax,%ax
80106168:	66 90                	xchg   %ax,%ax
8010616a:	66 90                	xchg   %ax,%ax
8010616c:	66 90                	xchg   %ax,%ax
8010616e:	66 90                	xchg   %ax,%ax

80106170 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106175:	31 c0                	xor    %eax,%eax
{
80106177:	89 e5                	mov    %esp,%ebp
80106179:	83 ec 08             	sub    $0x8,%esp
8010617c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106180:	8b 14 85 50 b0 10 80 	mov    -0x7fef4fb0(,%eax,4),%edx
80106187:	c7 04 c5 e2 62 11 80 	movl   $0x8e000008,-0x7fee9d1e(,%eax,8)
8010618e:	08 00 00 8e 
80106192:	66 89 14 c5 e0 62 11 	mov    %dx,-0x7fee9d20(,%eax,8)
80106199:	80 
8010619a:	c1 ea 10             	shr    $0x10,%edx
8010619d:	66 89 14 c5 e6 62 11 	mov    %dx,-0x7fee9d1a(,%eax,8)
801061a4:	80 
  for(i = 0; i < 256; i++)
801061a5:	83 c0 01             	add    $0x1,%eax
801061a8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061ad:	75 d1                	jne    80106180 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801061af:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061b2:	a1 50 b1 10 80       	mov    0x8010b150,%eax
801061b7:	c7 05 e2 64 11 80 08 	movl   $0xef000008,0x801164e2
801061be:	00 00 ef 
  initlock(&tickslock, "time");
801061c1:	68 ad 80 10 80       	push   $0x801080ad
801061c6:	68 a0 62 11 80       	push   $0x801162a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061cb:	66 a3 e0 64 11 80    	mov    %ax,0x801164e0
801061d1:	c1 e8 10             	shr    $0x10,%eax
801061d4:	66 a3 e6 64 11 80    	mov    %ax,0x801164e6
  initlock(&tickslock, "time");
801061da:	e8 41 e9 ff ff       	call   80104b20 <initlock>
}
801061df:	83 c4 10             	add    $0x10,%esp
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    
801061e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061ef:	90                   	nop

801061f0 <idtinit>:

void
idtinit(void)
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
  pd[0] = size-1;
801061f5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061fa:	89 e5                	mov    %esp,%ebp
801061fc:	83 ec 10             	sub    $0x10,%esp
801061ff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106203:	b8 e0 62 11 80       	mov    $0x801162e0,%eax
80106208:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010620c:	c1 e8 10             	shr    $0x10,%eax
8010620f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106213:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106216:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106219:	c9                   	leave  
8010621a:	c3                   	ret    
8010621b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010621f:	90                   	nop

80106220 <trap>:


//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106220:	f3 0f 1e fb          	endbr32 
80106224:	55                   	push   %ebp
80106225:	89 e5                	mov    %esp,%ebp
80106227:	57                   	push   %edi
80106228:	56                   	push   %esi
80106229:	53                   	push   %ebx
8010622a:	83 ec 1c             	sub    $0x1c,%esp
8010622d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106230:	8b 43 30             	mov    0x30(%ebx),%eax
80106233:	83 f8 40             	cmp    $0x40,%eax
80106236:	0f 84 04 02 00 00    	je     80106440 <trap+0x220>
    return;
  }

  // My Code
  // cprintf("default: %d\n",tf->trapno);
  switch(tf->trapno){ 
8010623c:	83 e8 20             	sub    $0x20,%eax
8010623f:	83 f8 1f             	cmp    $0x1f,%eax
80106242:	77 08                	ja     8010624c <trap+0x2c>
80106244:	3e ff 24 85 14 83 10 	notrack jmp *-0x7fef7cec(,%eax,4)
8010624b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010624c:	e8 1f d9 ff ff       	call   80103b70 <myproc>
80106251:	8b 7b 38             	mov    0x38(%ebx),%edi
80106254:	85 c0                	test   %eax,%eax
80106256:	0f 84 93 02 00 00    	je     801064ef <trap+0x2cf>
8010625c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106260:	0f 84 89 02 00 00    	je     801064ef <trap+0x2cf>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106266:	0f 20 d1             	mov    %cr2,%ecx
80106269:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010626c:	e8 df d8 ff ff       	call   80103b50 <cpuid>
80106271:	8b 73 30             	mov    0x30(%ebx),%esi
80106274:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106277:	8b 43 34             	mov    0x34(%ebx),%eax
8010627a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010627d:	e8 ee d8 ff ff       	call   80103b70 <myproc>
80106282:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106285:	e8 e6 d8 ff ff       	call   80103b70 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010628a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010628d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106290:	51                   	push   %ecx
80106291:	57                   	push   %edi
80106292:	52                   	push   %edx
80106293:	ff 75 e4             	pushl  -0x1c(%ebp)
80106296:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106297:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010629a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010629d:	56                   	push   %esi
8010629e:	ff 70 10             	pushl  0x10(%eax)
801062a1:	68 d0 82 10 80       	push   $0x801082d0
801062a6:	e8 05 a4 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801062ab:	83 c4 20             	add    $0x20,%esp
801062ae:	e8 bd d8 ff ff       	call   80103b70 <myproc>
801062b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062ba:	e8 b1 d8 ff ff       	call   80103b70 <myproc>
801062bf:	85 c0                	test   %eax,%eax
801062c1:	74 1d                	je     801062e0 <trap+0xc0>
801062c3:	e8 a8 d8 ff ff       	call   80103b70 <myproc>
801062c8:	8b 50 24             	mov    0x24(%eax),%edx
801062cb:	85 d2                	test   %edx,%edx
801062cd:	74 11                	je     801062e0 <trap+0xc0>
801062cf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062d3:	83 e0 03             	and    $0x3,%eax
801062d6:	66 83 f8 03          	cmp    $0x3,%ax
801062da:	0f 84 98 01 00 00    	je     80106478 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  // My Code: PRJ1, Commented. PRJ2, Not Commented.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801062e0:	e8 8b d8 ff ff       	call   80103b70 <myproc>
801062e5:	85 c0                	test   %eax,%eax
801062e7:	74 0f                	je     801062f8 <trap+0xd8>
801062e9:	e8 82 d8 ff ff       	call   80103b70 <myproc>
801062ee:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062f2:	0f 84 08 01 00 00    	je     80106400 <trap+0x1e0>
	  }
  }
  // My Code End

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062f8:	e8 73 d8 ff ff       	call   80103b70 <myproc>
801062fd:	85 c0                	test   %eax,%eax
801062ff:	74 1d                	je     8010631e <trap+0xfe>
80106301:	e8 6a d8 ff ff       	call   80103b70 <myproc>
80106306:	8b 40 24             	mov    0x24(%eax),%eax
80106309:	85 c0                	test   %eax,%eax
8010630b:	74 11                	je     8010631e <trap+0xfe>
8010630d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106311:	83 e0 03             	and    $0x3,%eax
80106314:	66 83 f8 03          	cmp    $0x3,%ax
80106318:	0f 84 4b 01 00 00    	je     80106469 <trap+0x249>
    exit();
}
8010631e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106321:	5b                   	pop    %ebx
80106322:	5e                   	pop    %esi
80106323:	5f                   	pop    %edi
80106324:	5d                   	pop    %ebp
80106325:	c3                   	ret    
    ideintr();
80106326:	e8 c5 bf ff ff       	call   801022f0 <ideintr>
    lapiceoi();
8010632b:	e8 a0 c6 ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106330:	e8 3b d8 ff ff       	call   80103b70 <myproc>
80106335:	85 c0                	test   %eax,%eax
80106337:	75 8a                	jne    801062c3 <trap+0xa3>
80106339:	eb a5                	jmp    801062e0 <trap+0xc0>
    if(cpuid() == 0){
8010633b:	e8 10 d8 ff ff       	call   80103b50 <cpuid>
80106340:	85 c0                	test   %eax,%eax
80106342:	75 e7                	jne    8010632b <trap+0x10b>
     	acquire(&tickslock);
80106344:	83 ec 0c             	sub    $0xc,%esp
80106347:	68 a0 62 11 80       	push   $0x801162a0
8010634c:	e8 4f e9 ff ff       	call   80104ca0 <acquire>
    	ticks+=1000;		// tick unit is mili-tick
80106351:	81 05 e0 6a 11 80 e8 	addl   $0x3e8,0x80116ae0
80106358:	03 00 00 
     	if(myproc()!=0 && myproc()->state == RUNNING){
8010635b:	e8 10 d8 ff ff       	call   80103b70 <myproc>
80106360:	83 c4 10             	add    $0x10,%esp
80106363:	85 c0                	test   %eax,%eax
80106365:	74 0f                	je     80106376 <trap+0x156>
80106367:	e8 04 d8 ff ff       	call   80103b70 <myproc>
8010636c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106370:	0f 84 19 01 00 00    	je     8010648f <trap+0x26f>
      	wakeup(&ticks);
80106376:	83 ec 0c             	sub    $0xc,%esp
80106379:	68 e0 6a 11 80       	push   $0x80116ae0
8010637e:	e8 2d e0 ff ff       	call   801043b0 <wakeup>
      	release(&tickslock);
80106383:	c7 04 24 a0 62 11 80 	movl   $0x801162a0,(%esp)
8010638a:	e8 d1 e9 ff ff       	call   80104d60 <release>
8010638f:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106392:	eb 97                	jmp    8010632b <trap+0x10b>
    kbdintr();
80106394:	e8 f7 c4 ff ff       	call   80102890 <kbdintr>
    lapiceoi();
80106399:	e8 32 c6 ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010639e:	e8 cd d7 ff ff       	call   80103b70 <myproc>
801063a3:	85 c0                	test   %eax,%eax
801063a5:	0f 85 18 ff ff ff    	jne    801062c3 <trap+0xa3>
801063ab:	e9 30 ff ff ff       	jmp    801062e0 <trap+0xc0>
    uartintr();
801063b0:	e8 db 02 00 00       	call   80106690 <uartintr>
    lapiceoi();
801063b5:	e8 16 c6 ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ba:	e8 b1 d7 ff ff       	call   80103b70 <myproc>
801063bf:	85 c0                	test   %eax,%eax
801063c1:	0f 85 fc fe ff ff    	jne    801062c3 <trap+0xa3>
801063c7:	e9 14 ff ff ff       	jmp    801062e0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063cc:	8b 7b 38             	mov    0x38(%ebx),%edi
801063cf:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801063d3:	e8 78 d7 ff ff       	call   80103b50 <cpuid>
801063d8:	57                   	push   %edi
801063d9:	56                   	push   %esi
801063da:	50                   	push   %eax
801063db:	68 78 82 10 80       	push   $0x80108278
801063e0:	e8 cb a2 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801063e5:	e8 e6 c5 ff ff       	call   801029d0 <lapiceoi>
    break;
801063ea:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ed:	e8 7e d7 ff ff       	call   80103b70 <myproc>
801063f2:	85 c0                	test   %eax,%eax
801063f4:	0f 85 c9 fe ff ff    	jne    801062c3 <trap+0xa3>
801063fa:	e9 e1 fe ff ff       	jmp    801062e0 <trap+0xc0>
801063ff:	90                   	nop
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106400:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106404:	0f 85 ee fe ff ff    	jne    801062f8 <trap+0xd8>
	  if(myproc()->runtime_interval >= myproc()->timeslice){
8010640a:	e8 61 d7 ff ff       	call   80103b70 <myproc>
8010640f:	8b b0 8c 00 00 00    	mov    0x8c(%eax),%esi
80106415:	e8 56 d7 ff ff       	call   80103b70 <myproc>
8010641a:	3b b0 90 00 00 00    	cmp    0x90(%eax),%esi
80106420:	0f 82 d2 fe ff ff    	jb     801062f8 <trap+0xd8>
		  myproc()->runtime_interval=0;
80106426:	e8 45 d7 ff ff       	call   80103b70 <myproc>
8010642b:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80106432:	00 00 00 
		  yield();
80106435:	e8 66 dd ff ff       	call   801041a0 <yield>
8010643a:	e9 b9 fe ff ff       	jmp    801062f8 <trap+0xd8>
8010643f:	90                   	nop
    if(myproc()->killed)
80106440:	e8 2b d7 ff ff       	call   80103b70 <myproc>
80106445:	8b 70 24             	mov    0x24(%eax),%esi
80106448:	85 f6                	test   %esi,%esi
8010644a:	75 3c                	jne    80106488 <trap+0x268>
    myproc()->tf = tf;
8010644c:	e8 1f d7 ff ff       	call   80103b70 <myproc>
80106451:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106454:	e8 27 ed ff ff       	call   80105180 <syscall>
    if(myproc()->killed)
80106459:	e8 12 d7 ff ff       	call   80103b70 <myproc>
8010645e:	8b 58 24             	mov    0x24(%eax),%ebx
80106461:	85 db                	test   %ebx,%ebx
80106463:	0f 84 b5 fe ff ff    	je     8010631e <trap+0xfe>
}
80106469:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010646c:	5b                   	pop    %ebx
8010646d:	5e                   	pop    %esi
8010646e:	5f                   	pop    %edi
8010646f:	5d                   	pop    %ebp
      exit();
80106470:	e9 2b dc ff ff       	jmp    801040a0 <exit>
80106475:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106478:	e8 23 dc ff ff       	call   801040a0 <exit>
8010647d:	e9 5e fe ff ff       	jmp    801062e0 <trap+0xc0>
80106482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106488:	e8 13 dc ff ff       	call   801040a0 <exit>
8010648d:	eb bd                	jmp    8010644c <trap+0x22c>
	     myproc()->runtime+=1000;
8010648f:	e8 dc d6 ff ff       	call   80103b70 <myproc>
80106494:	81 80 88 00 00 00 e8 	addl   $0x3e8,0x88(%eax)
8010649b:	03 00 00 
	     myproc()->runtime_interval+=1000;
8010649e:	e8 cd d6 ff ff       	call   80103b70 <myproc>
801064a3:	81 80 8c 00 00 00 e8 	addl   $0x3e8,0x8c(%eax)
801064aa:	03 00 00 
	     myproc()->vruntime += (1000*1024+nice2weight(myproc()->priority)-1)/nice2weight(myproc()->priority);
801064ad:	e8 be d6 ff ff       	call   80103b70 <myproc>
801064b2:	83 ec 0c             	sub    $0xc,%esp
801064b5:	ff 70 7c             	pushl  0x7c(%eax)
801064b8:	e8 a3 d9 ff ff       	call   80103e60 <nice2weight>
801064bd:	89 c6                	mov    %eax,%esi
801064bf:	e8 ac d6 ff ff       	call   80103b70 <myproc>
801064c4:	59                   	pop    %ecx
801064c5:	81 c6 ff 9f 0f 00    	add    $0xf9fff,%esi
801064cb:	ff 70 7c             	pushl  0x7c(%eax)
801064ce:	e8 8d d9 ff ff       	call   80103e60 <nice2weight>
801064d3:	89 c1                	mov    %eax,%ecx
801064d5:	89 f0                	mov    %esi,%eax
801064d7:	99                   	cltd   
801064d8:	f7 f9                	idiv   %ecx
801064da:	89 c6                	mov    %eax,%esi
801064dc:	e8 8f d6 ff ff       	call   80103b70 <myproc>
801064e1:	83 c4 10             	add    $0x10,%esp
801064e4:	01 b0 84 00 00 00    	add    %esi,0x84(%eax)
801064ea:	e9 87 fe ff ff       	jmp    80106376 <trap+0x156>
801064ef:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064f2:	e8 59 d6 ff ff       	call   80103b50 <cpuid>
801064f7:	83 ec 0c             	sub    $0xc,%esp
801064fa:	56                   	push   %esi
801064fb:	57                   	push   %edi
801064fc:	50                   	push   %eax
801064fd:	ff 73 30             	pushl  0x30(%ebx)
80106500:	68 9c 82 10 80       	push   $0x8010829c
80106505:	e8 a6 a1 ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010650a:	83 c4 14             	add    $0x14,%esp
8010650d:	68 71 82 10 80       	push   $0x80108271
80106512:	e8 79 9e ff ff       	call   80100390 <panic>
80106517:	66 90                	xchg   %ax,%ax
80106519:	66 90                	xchg   %ax,%ax
8010651b:	66 90                	xchg   %ax,%ax
8010651d:	66 90                	xchg   %ax,%ax
8010651f:	90                   	nop

80106520 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106520:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106524:	a1 fc b5 10 80       	mov    0x8010b5fc,%eax
80106529:	85 c0                	test   %eax,%eax
8010652b:	74 1b                	je     80106548 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010652d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106532:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106533:	a8 01                	test   $0x1,%al
80106535:	74 11                	je     80106548 <uartgetc+0x28>
80106537:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010653c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010653d:	0f b6 c0             	movzbl %al,%eax
80106540:	c3                   	ret    
80106541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010654d:	c3                   	ret    
8010654e:	66 90                	xchg   %ax,%ax

80106550 <uartputc.part.0>:
uartputc(int c)
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	57                   	push   %edi
80106554:	89 c7                	mov    %eax,%edi
80106556:	56                   	push   %esi
80106557:	be fd 03 00 00       	mov    $0x3fd,%esi
8010655c:	53                   	push   %ebx
8010655d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106562:	83 ec 0c             	sub    $0xc,%esp
80106565:	eb 1b                	jmp    80106582 <uartputc.part.0+0x32>
80106567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010656e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106570:	83 ec 0c             	sub    $0xc,%esp
80106573:	6a 0a                	push   $0xa
80106575:	e8 76 c4 ff ff       	call   801029f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010657a:	83 c4 10             	add    $0x10,%esp
8010657d:	83 eb 01             	sub    $0x1,%ebx
80106580:	74 07                	je     80106589 <uartputc.part.0+0x39>
80106582:	89 f2                	mov    %esi,%edx
80106584:	ec                   	in     (%dx),%al
80106585:	a8 20                	test   $0x20,%al
80106587:	74 e7                	je     80106570 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106589:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010658e:	89 f8                	mov    %edi,%eax
80106590:	ee                   	out    %al,(%dx)
}
80106591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106594:	5b                   	pop    %ebx
80106595:	5e                   	pop    %esi
80106596:	5f                   	pop    %edi
80106597:	5d                   	pop    %ebp
80106598:	c3                   	ret    
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065a0 <uartinit>:
{
801065a0:	f3 0f 1e fb          	endbr32 
801065a4:	55                   	push   %ebp
801065a5:	31 c9                	xor    %ecx,%ecx
801065a7:	89 c8                	mov    %ecx,%eax
801065a9:	89 e5                	mov    %esp,%ebp
801065ab:	57                   	push   %edi
801065ac:	56                   	push   %esi
801065ad:	53                   	push   %ebx
801065ae:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801065b3:	89 da                	mov    %ebx,%edx
801065b5:	83 ec 0c             	sub    $0xc,%esp
801065b8:	ee                   	out    %al,(%dx)
801065b9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801065be:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801065c3:	89 fa                	mov    %edi,%edx
801065c5:	ee                   	out    %al,(%dx)
801065c6:	b8 0c 00 00 00       	mov    $0xc,%eax
801065cb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065d0:	ee                   	out    %al,(%dx)
801065d1:	be f9 03 00 00       	mov    $0x3f9,%esi
801065d6:	89 c8                	mov    %ecx,%eax
801065d8:	89 f2                	mov    %esi,%edx
801065da:	ee                   	out    %al,(%dx)
801065db:	b8 03 00 00 00       	mov    $0x3,%eax
801065e0:	89 fa                	mov    %edi,%edx
801065e2:	ee                   	out    %al,(%dx)
801065e3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801065e8:	89 c8                	mov    %ecx,%eax
801065ea:	ee                   	out    %al,(%dx)
801065eb:	b8 01 00 00 00       	mov    $0x1,%eax
801065f0:	89 f2                	mov    %esi,%edx
801065f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065f3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065f8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801065f9:	3c ff                	cmp    $0xff,%al
801065fb:	74 52                	je     8010664f <uartinit+0xaf>
  uart = 1;
801065fd:	c7 05 fc b5 10 80 01 	movl   $0x1,0x8010b5fc
80106604:	00 00 00 
80106607:	89 da                	mov    %ebx,%edx
80106609:	ec                   	in     (%dx),%al
8010660a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010660f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106610:	83 ec 08             	sub    $0x8,%esp
80106613:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106618:	bb 94 83 10 80       	mov    $0x80108394,%ebx
  ioapicenable(IRQ_COM1, 0);
8010661d:	6a 00                	push   $0x0
8010661f:	6a 04                	push   $0x4
80106621:	e8 1a bf ff ff       	call   80102540 <ioapicenable>
80106626:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106629:	b8 78 00 00 00       	mov    $0x78,%eax
8010662e:	eb 04                	jmp    80106634 <uartinit+0x94>
80106630:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106634:	8b 15 fc b5 10 80    	mov    0x8010b5fc,%edx
8010663a:	85 d2                	test   %edx,%edx
8010663c:	74 08                	je     80106646 <uartinit+0xa6>
    uartputc(*p);
8010663e:	0f be c0             	movsbl %al,%eax
80106641:	e8 0a ff ff ff       	call   80106550 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106646:	89 f0                	mov    %esi,%eax
80106648:	83 c3 01             	add    $0x1,%ebx
8010664b:	84 c0                	test   %al,%al
8010664d:	75 e1                	jne    80106630 <uartinit+0x90>
}
8010664f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106652:	5b                   	pop    %ebx
80106653:	5e                   	pop    %esi
80106654:	5f                   	pop    %edi
80106655:	5d                   	pop    %ebp
80106656:	c3                   	ret    
80106657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010665e:	66 90                	xchg   %ax,%ax

80106660 <uartputc>:
{
80106660:	f3 0f 1e fb          	endbr32 
80106664:	55                   	push   %ebp
  if(!uart)
80106665:	8b 15 fc b5 10 80    	mov    0x8010b5fc,%edx
{
8010666b:	89 e5                	mov    %esp,%ebp
8010666d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106670:	85 d2                	test   %edx,%edx
80106672:	74 0c                	je     80106680 <uartputc+0x20>
}
80106674:	5d                   	pop    %ebp
80106675:	e9 d6 fe ff ff       	jmp    80106550 <uartputc.part.0>
8010667a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106680:	5d                   	pop    %ebp
80106681:	c3                   	ret    
80106682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106690 <uartintr>:

void
uartintr(void)
{
80106690:	f3 0f 1e fb          	endbr32 
80106694:	55                   	push   %ebp
80106695:	89 e5                	mov    %esp,%ebp
80106697:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010669a:	68 20 65 10 80       	push   $0x80106520
8010669f:	e8 bc a1 ff ff       	call   80100860 <consoleintr>
}
801066a4:	83 c4 10             	add    $0x10,%esp
801066a7:	c9                   	leave  
801066a8:	c3                   	ret    

801066a9 <vector0>:
801066a9:	6a 00                	push   $0x0
801066ab:	6a 00                	push   $0x0
801066ad:	e9 91 fa ff ff       	jmp    80106143 <alltraps>

801066b2 <vector1>:
801066b2:	6a 00                	push   $0x0
801066b4:	6a 01                	push   $0x1
801066b6:	e9 88 fa ff ff       	jmp    80106143 <alltraps>

801066bb <vector2>:
801066bb:	6a 00                	push   $0x0
801066bd:	6a 02                	push   $0x2
801066bf:	e9 7f fa ff ff       	jmp    80106143 <alltraps>

801066c4 <vector3>:
801066c4:	6a 00                	push   $0x0
801066c6:	6a 03                	push   $0x3
801066c8:	e9 76 fa ff ff       	jmp    80106143 <alltraps>

801066cd <vector4>:
801066cd:	6a 00                	push   $0x0
801066cf:	6a 04                	push   $0x4
801066d1:	e9 6d fa ff ff       	jmp    80106143 <alltraps>

801066d6 <vector5>:
801066d6:	6a 00                	push   $0x0
801066d8:	6a 05                	push   $0x5
801066da:	e9 64 fa ff ff       	jmp    80106143 <alltraps>

801066df <vector6>:
801066df:	6a 00                	push   $0x0
801066e1:	6a 06                	push   $0x6
801066e3:	e9 5b fa ff ff       	jmp    80106143 <alltraps>

801066e8 <vector7>:
801066e8:	6a 00                	push   $0x0
801066ea:	6a 07                	push   $0x7
801066ec:	e9 52 fa ff ff       	jmp    80106143 <alltraps>

801066f1 <vector8>:
801066f1:	6a 08                	push   $0x8
801066f3:	e9 4b fa ff ff       	jmp    80106143 <alltraps>

801066f8 <vector9>:
801066f8:	6a 00                	push   $0x0
801066fa:	6a 09                	push   $0x9
801066fc:	e9 42 fa ff ff       	jmp    80106143 <alltraps>

80106701 <vector10>:
80106701:	6a 0a                	push   $0xa
80106703:	e9 3b fa ff ff       	jmp    80106143 <alltraps>

80106708 <vector11>:
80106708:	6a 0b                	push   $0xb
8010670a:	e9 34 fa ff ff       	jmp    80106143 <alltraps>

8010670f <vector12>:
8010670f:	6a 0c                	push   $0xc
80106711:	e9 2d fa ff ff       	jmp    80106143 <alltraps>

80106716 <vector13>:
80106716:	6a 0d                	push   $0xd
80106718:	e9 26 fa ff ff       	jmp    80106143 <alltraps>

8010671d <vector14>:
8010671d:	6a 0e                	push   $0xe
8010671f:	e9 1f fa ff ff       	jmp    80106143 <alltraps>

80106724 <vector15>:
80106724:	6a 00                	push   $0x0
80106726:	6a 0f                	push   $0xf
80106728:	e9 16 fa ff ff       	jmp    80106143 <alltraps>

8010672d <vector16>:
8010672d:	6a 00                	push   $0x0
8010672f:	6a 10                	push   $0x10
80106731:	e9 0d fa ff ff       	jmp    80106143 <alltraps>

80106736 <vector17>:
80106736:	6a 11                	push   $0x11
80106738:	e9 06 fa ff ff       	jmp    80106143 <alltraps>

8010673d <vector18>:
8010673d:	6a 00                	push   $0x0
8010673f:	6a 12                	push   $0x12
80106741:	e9 fd f9 ff ff       	jmp    80106143 <alltraps>

80106746 <vector19>:
80106746:	6a 00                	push   $0x0
80106748:	6a 13                	push   $0x13
8010674a:	e9 f4 f9 ff ff       	jmp    80106143 <alltraps>

8010674f <vector20>:
8010674f:	6a 00                	push   $0x0
80106751:	6a 14                	push   $0x14
80106753:	e9 eb f9 ff ff       	jmp    80106143 <alltraps>

80106758 <vector21>:
80106758:	6a 00                	push   $0x0
8010675a:	6a 15                	push   $0x15
8010675c:	e9 e2 f9 ff ff       	jmp    80106143 <alltraps>

80106761 <vector22>:
80106761:	6a 00                	push   $0x0
80106763:	6a 16                	push   $0x16
80106765:	e9 d9 f9 ff ff       	jmp    80106143 <alltraps>

8010676a <vector23>:
8010676a:	6a 00                	push   $0x0
8010676c:	6a 17                	push   $0x17
8010676e:	e9 d0 f9 ff ff       	jmp    80106143 <alltraps>

80106773 <vector24>:
80106773:	6a 00                	push   $0x0
80106775:	6a 18                	push   $0x18
80106777:	e9 c7 f9 ff ff       	jmp    80106143 <alltraps>

8010677c <vector25>:
8010677c:	6a 00                	push   $0x0
8010677e:	6a 19                	push   $0x19
80106780:	e9 be f9 ff ff       	jmp    80106143 <alltraps>

80106785 <vector26>:
80106785:	6a 00                	push   $0x0
80106787:	6a 1a                	push   $0x1a
80106789:	e9 b5 f9 ff ff       	jmp    80106143 <alltraps>

8010678e <vector27>:
8010678e:	6a 00                	push   $0x0
80106790:	6a 1b                	push   $0x1b
80106792:	e9 ac f9 ff ff       	jmp    80106143 <alltraps>

80106797 <vector28>:
80106797:	6a 00                	push   $0x0
80106799:	6a 1c                	push   $0x1c
8010679b:	e9 a3 f9 ff ff       	jmp    80106143 <alltraps>

801067a0 <vector29>:
801067a0:	6a 00                	push   $0x0
801067a2:	6a 1d                	push   $0x1d
801067a4:	e9 9a f9 ff ff       	jmp    80106143 <alltraps>

801067a9 <vector30>:
801067a9:	6a 00                	push   $0x0
801067ab:	6a 1e                	push   $0x1e
801067ad:	e9 91 f9 ff ff       	jmp    80106143 <alltraps>

801067b2 <vector31>:
801067b2:	6a 00                	push   $0x0
801067b4:	6a 1f                	push   $0x1f
801067b6:	e9 88 f9 ff ff       	jmp    80106143 <alltraps>

801067bb <vector32>:
801067bb:	6a 00                	push   $0x0
801067bd:	6a 20                	push   $0x20
801067bf:	e9 7f f9 ff ff       	jmp    80106143 <alltraps>

801067c4 <vector33>:
801067c4:	6a 00                	push   $0x0
801067c6:	6a 21                	push   $0x21
801067c8:	e9 76 f9 ff ff       	jmp    80106143 <alltraps>

801067cd <vector34>:
801067cd:	6a 00                	push   $0x0
801067cf:	6a 22                	push   $0x22
801067d1:	e9 6d f9 ff ff       	jmp    80106143 <alltraps>

801067d6 <vector35>:
801067d6:	6a 00                	push   $0x0
801067d8:	6a 23                	push   $0x23
801067da:	e9 64 f9 ff ff       	jmp    80106143 <alltraps>

801067df <vector36>:
801067df:	6a 00                	push   $0x0
801067e1:	6a 24                	push   $0x24
801067e3:	e9 5b f9 ff ff       	jmp    80106143 <alltraps>

801067e8 <vector37>:
801067e8:	6a 00                	push   $0x0
801067ea:	6a 25                	push   $0x25
801067ec:	e9 52 f9 ff ff       	jmp    80106143 <alltraps>

801067f1 <vector38>:
801067f1:	6a 00                	push   $0x0
801067f3:	6a 26                	push   $0x26
801067f5:	e9 49 f9 ff ff       	jmp    80106143 <alltraps>

801067fa <vector39>:
801067fa:	6a 00                	push   $0x0
801067fc:	6a 27                	push   $0x27
801067fe:	e9 40 f9 ff ff       	jmp    80106143 <alltraps>

80106803 <vector40>:
80106803:	6a 00                	push   $0x0
80106805:	6a 28                	push   $0x28
80106807:	e9 37 f9 ff ff       	jmp    80106143 <alltraps>

8010680c <vector41>:
8010680c:	6a 00                	push   $0x0
8010680e:	6a 29                	push   $0x29
80106810:	e9 2e f9 ff ff       	jmp    80106143 <alltraps>

80106815 <vector42>:
80106815:	6a 00                	push   $0x0
80106817:	6a 2a                	push   $0x2a
80106819:	e9 25 f9 ff ff       	jmp    80106143 <alltraps>

8010681e <vector43>:
8010681e:	6a 00                	push   $0x0
80106820:	6a 2b                	push   $0x2b
80106822:	e9 1c f9 ff ff       	jmp    80106143 <alltraps>

80106827 <vector44>:
80106827:	6a 00                	push   $0x0
80106829:	6a 2c                	push   $0x2c
8010682b:	e9 13 f9 ff ff       	jmp    80106143 <alltraps>

80106830 <vector45>:
80106830:	6a 00                	push   $0x0
80106832:	6a 2d                	push   $0x2d
80106834:	e9 0a f9 ff ff       	jmp    80106143 <alltraps>

80106839 <vector46>:
80106839:	6a 00                	push   $0x0
8010683b:	6a 2e                	push   $0x2e
8010683d:	e9 01 f9 ff ff       	jmp    80106143 <alltraps>

80106842 <vector47>:
80106842:	6a 00                	push   $0x0
80106844:	6a 2f                	push   $0x2f
80106846:	e9 f8 f8 ff ff       	jmp    80106143 <alltraps>

8010684b <vector48>:
8010684b:	6a 00                	push   $0x0
8010684d:	6a 30                	push   $0x30
8010684f:	e9 ef f8 ff ff       	jmp    80106143 <alltraps>

80106854 <vector49>:
80106854:	6a 00                	push   $0x0
80106856:	6a 31                	push   $0x31
80106858:	e9 e6 f8 ff ff       	jmp    80106143 <alltraps>

8010685d <vector50>:
8010685d:	6a 00                	push   $0x0
8010685f:	6a 32                	push   $0x32
80106861:	e9 dd f8 ff ff       	jmp    80106143 <alltraps>

80106866 <vector51>:
80106866:	6a 00                	push   $0x0
80106868:	6a 33                	push   $0x33
8010686a:	e9 d4 f8 ff ff       	jmp    80106143 <alltraps>

8010686f <vector52>:
8010686f:	6a 00                	push   $0x0
80106871:	6a 34                	push   $0x34
80106873:	e9 cb f8 ff ff       	jmp    80106143 <alltraps>

80106878 <vector53>:
80106878:	6a 00                	push   $0x0
8010687a:	6a 35                	push   $0x35
8010687c:	e9 c2 f8 ff ff       	jmp    80106143 <alltraps>

80106881 <vector54>:
80106881:	6a 00                	push   $0x0
80106883:	6a 36                	push   $0x36
80106885:	e9 b9 f8 ff ff       	jmp    80106143 <alltraps>

8010688a <vector55>:
8010688a:	6a 00                	push   $0x0
8010688c:	6a 37                	push   $0x37
8010688e:	e9 b0 f8 ff ff       	jmp    80106143 <alltraps>

80106893 <vector56>:
80106893:	6a 00                	push   $0x0
80106895:	6a 38                	push   $0x38
80106897:	e9 a7 f8 ff ff       	jmp    80106143 <alltraps>

8010689c <vector57>:
8010689c:	6a 00                	push   $0x0
8010689e:	6a 39                	push   $0x39
801068a0:	e9 9e f8 ff ff       	jmp    80106143 <alltraps>

801068a5 <vector58>:
801068a5:	6a 00                	push   $0x0
801068a7:	6a 3a                	push   $0x3a
801068a9:	e9 95 f8 ff ff       	jmp    80106143 <alltraps>

801068ae <vector59>:
801068ae:	6a 00                	push   $0x0
801068b0:	6a 3b                	push   $0x3b
801068b2:	e9 8c f8 ff ff       	jmp    80106143 <alltraps>

801068b7 <vector60>:
801068b7:	6a 00                	push   $0x0
801068b9:	6a 3c                	push   $0x3c
801068bb:	e9 83 f8 ff ff       	jmp    80106143 <alltraps>

801068c0 <vector61>:
801068c0:	6a 00                	push   $0x0
801068c2:	6a 3d                	push   $0x3d
801068c4:	e9 7a f8 ff ff       	jmp    80106143 <alltraps>

801068c9 <vector62>:
801068c9:	6a 00                	push   $0x0
801068cb:	6a 3e                	push   $0x3e
801068cd:	e9 71 f8 ff ff       	jmp    80106143 <alltraps>

801068d2 <vector63>:
801068d2:	6a 00                	push   $0x0
801068d4:	6a 3f                	push   $0x3f
801068d6:	e9 68 f8 ff ff       	jmp    80106143 <alltraps>

801068db <vector64>:
801068db:	6a 00                	push   $0x0
801068dd:	6a 40                	push   $0x40
801068df:	e9 5f f8 ff ff       	jmp    80106143 <alltraps>

801068e4 <vector65>:
801068e4:	6a 00                	push   $0x0
801068e6:	6a 41                	push   $0x41
801068e8:	e9 56 f8 ff ff       	jmp    80106143 <alltraps>

801068ed <vector66>:
801068ed:	6a 00                	push   $0x0
801068ef:	6a 42                	push   $0x42
801068f1:	e9 4d f8 ff ff       	jmp    80106143 <alltraps>

801068f6 <vector67>:
801068f6:	6a 00                	push   $0x0
801068f8:	6a 43                	push   $0x43
801068fa:	e9 44 f8 ff ff       	jmp    80106143 <alltraps>

801068ff <vector68>:
801068ff:	6a 00                	push   $0x0
80106901:	6a 44                	push   $0x44
80106903:	e9 3b f8 ff ff       	jmp    80106143 <alltraps>

80106908 <vector69>:
80106908:	6a 00                	push   $0x0
8010690a:	6a 45                	push   $0x45
8010690c:	e9 32 f8 ff ff       	jmp    80106143 <alltraps>

80106911 <vector70>:
80106911:	6a 00                	push   $0x0
80106913:	6a 46                	push   $0x46
80106915:	e9 29 f8 ff ff       	jmp    80106143 <alltraps>

8010691a <vector71>:
8010691a:	6a 00                	push   $0x0
8010691c:	6a 47                	push   $0x47
8010691e:	e9 20 f8 ff ff       	jmp    80106143 <alltraps>

80106923 <vector72>:
80106923:	6a 00                	push   $0x0
80106925:	6a 48                	push   $0x48
80106927:	e9 17 f8 ff ff       	jmp    80106143 <alltraps>

8010692c <vector73>:
8010692c:	6a 00                	push   $0x0
8010692e:	6a 49                	push   $0x49
80106930:	e9 0e f8 ff ff       	jmp    80106143 <alltraps>

80106935 <vector74>:
80106935:	6a 00                	push   $0x0
80106937:	6a 4a                	push   $0x4a
80106939:	e9 05 f8 ff ff       	jmp    80106143 <alltraps>

8010693e <vector75>:
8010693e:	6a 00                	push   $0x0
80106940:	6a 4b                	push   $0x4b
80106942:	e9 fc f7 ff ff       	jmp    80106143 <alltraps>

80106947 <vector76>:
80106947:	6a 00                	push   $0x0
80106949:	6a 4c                	push   $0x4c
8010694b:	e9 f3 f7 ff ff       	jmp    80106143 <alltraps>

80106950 <vector77>:
80106950:	6a 00                	push   $0x0
80106952:	6a 4d                	push   $0x4d
80106954:	e9 ea f7 ff ff       	jmp    80106143 <alltraps>

80106959 <vector78>:
80106959:	6a 00                	push   $0x0
8010695b:	6a 4e                	push   $0x4e
8010695d:	e9 e1 f7 ff ff       	jmp    80106143 <alltraps>

80106962 <vector79>:
80106962:	6a 00                	push   $0x0
80106964:	6a 4f                	push   $0x4f
80106966:	e9 d8 f7 ff ff       	jmp    80106143 <alltraps>

8010696b <vector80>:
8010696b:	6a 00                	push   $0x0
8010696d:	6a 50                	push   $0x50
8010696f:	e9 cf f7 ff ff       	jmp    80106143 <alltraps>

80106974 <vector81>:
80106974:	6a 00                	push   $0x0
80106976:	6a 51                	push   $0x51
80106978:	e9 c6 f7 ff ff       	jmp    80106143 <alltraps>

8010697d <vector82>:
8010697d:	6a 00                	push   $0x0
8010697f:	6a 52                	push   $0x52
80106981:	e9 bd f7 ff ff       	jmp    80106143 <alltraps>

80106986 <vector83>:
80106986:	6a 00                	push   $0x0
80106988:	6a 53                	push   $0x53
8010698a:	e9 b4 f7 ff ff       	jmp    80106143 <alltraps>

8010698f <vector84>:
8010698f:	6a 00                	push   $0x0
80106991:	6a 54                	push   $0x54
80106993:	e9 ab f7 ff ff       	jmp    80106143 <alltraps>

80106998 <vector85>:
80106998:	6a 00                	push   $0x0
8010699a:	6a 55                	push   $0x55
8010699c:	e9 a2 f7 ff ff       	jmp    80106143 <alltraps>

801069a1 <vector86>:
801069a1:	6a 00                	push   $0x0
801069a3:	6a 56                	push   $0x56
801069a5:	e9 99 f7 ff ff       	jmp    80106143 <alltraps>

801069aa <vector87>:
801069aa:	6a 00                	push   $0x0
801069ac:	6a 57                	push   $0x57
801069ae:	e9 90 f7 ff ff       	jmp    80106143 <alltraps>

801069b3 <vector88>:
801069b3:	6a 00                	push   $0x0
801069b5:	6a 58                	push   $0x58
801069b7:	e9 87 f7 ff ff       	jmp    80106143 <alltraps>

801069bc <vector89>:
801069bc:	6a 00                	push   $0x0
801069be:	6a 59                	push   $0x59
801069c0:	e9 7e f7 ff ff       	jmp    80106143 <alltraps>

801069c5 <vector90>:
801069c5:	6a 00                	push   $0x0
801069c7:	6a 5a                	push   $0x5a
801069c9:	e9 75 f7 ff ff       	jmp    80106143 <alltraps>

801069ce <vector91>:
801069ce:	6a 00                	push   $0x0
801069d0:	6a 5b                	push   $0x5b
801069d2:	e9 6c f7 ff ff       	jmp    80106143 <alltraps>

801069d7 <vector92>:
801069d7:	6a 00                	push   $0x0
801069d9:	6a 5c                	push   $0x5c
801069db:	e9 63 f7 ff ff       	jmp    80106143 <alltraps>

801069e0 <vector93>:
801069e0:	6a 00                	push   $0x0
801069e2:	6a 5d                	push   $0x5d
801069e4:	e9 5a f7 ff ff       	jmp    80106143 <alltraps>

801069e9 <vector94>:
801069e9:	6a 00                	push   $0x0
801069eb:	6a 5e                	push   $0x5e
801069ed:	e9 51 f7 ff ff       	jmp    80106143 <alltraps>

801069f2 <vector95>:
801069f2:	6a 00                	push   $0x0
801069f4:	6a 5f                	push   $0x5f
801069f6:	e9 48 f7 ff ff       	jmp    80106143 <alltraps>

801069fb <vector96>:
801069fb:	6a 00                	push   $0x0
801069fd:	6a 60                	push   $0x60
801069ff:	e9 3f f7 ff ff       	jmp    80106143 <alltraps>

80106a04 <vector97>:
80106a04:	6a 00                	push   $0x0
80106a06:	6a 61                	push   $0x61
80106a08:	e9 36 f7 ff ff       	jmp    80106143 <alltraps>

80106a0d <vector98>:
80106a0d:	6a 00                	push   $0x0
80106a0f:	6a 62                	push   $0x62
80106a11:	e9 2d f7 ff ff       	jmp    80106143 <alltraps>

80106a16 <vector99>:
80106a16:	6a 00                	push   $0x0
80106a18:	6a 63                	push   $0x63
80106a1a:	e9 24 f7 ff ff       	jmp    80106143 <alltraps>

80106a1f <vector100>:
80106a1f:	6a 00                	push   $0x0
80106a21:	6a 64                	push   $0x64
80106a23:	e9 1b f7 ff ff       	jmp    80106143 <alltraps>

80106a28 <vector101>:
80106a28:	6a 00                	push   $0x0
80106a2a:	6a 65                	push   $0x65
80106a2c:	e9 12 f7 ff ff       	jmp    80106143 <alltraps>

80106a31 <vector102>:
80106a31:	6a 00                	push   $0x0
80106a33:	6a 66                	push   $0x66
80106a35:	e9 09 f7 ff ff       	jmp    80106143 <alltraps>

80106a3a <vector103>:
80106a3a:	6a 00                	push   $0x0
80106a3c:	6a 67                	push   $0x67
80106a3e:	e9 00 f7 ff ff       	jmp    80106143 <alltraps>

80106a43 <vector104>:
80106a43:	6a 00                	push   $0x0
80106a45:	6a 68                	push   $0x68
80106a47:	e9 f7 f6 ff ff       	jmp    80106143 <alltraps>

80106a4c <vector105>:
80106a4c:	6a 00                	push   $0x0
80106a4e:	6a 69                	push   $0x69
80106a50:	e9 ee f6 ff ff       	jmp    80106143 <alltraps>

80106a55 <vector106>:
80106a55:	6a 00                	push   $0x0
80106a57:	6a 6a                	push   $0x6a
80106a59:	e9 e5 f6 ff ff       	jmp    80106143 <alltraps>

80106a5e <vector107>:
80106a5e:	6a 00                	push   $0x0
80106a60:	6a 6b                	push   $0x6b
80106a62:	e9 dc f6 ff ff       	jmp    80106143 <alltraps>

80106a67 <vector108>:
80106a67:	6a 00                	push   $0x0
80106a69:	6a 6c                	push   $0x6c
80106a6b:	e9 d3 f6 ff ff       	jmp    80106143 <alltraps>

80106a70 <vector109>:
80106a70:	6a 00                	push   $0x0
80106a72:	6a 6d                	push   $0x6d
80106a74:	e9 ca f6 ff ff       	jmp    80106143 <alltraps>

80106a79 <vector110>:
80106a79:	6a 00                	push   $0x0
80106a7b:	6a 6e                	push   $0x6e
80106a7d:	e9 c1 f6 ff ff       	jmp    80106143 <alltraps>

80106a82 <vector111>:
80106a82:	6a 00                	push   $0x0
80106a84:	6a 6f                	push   $0x6f
80106a86:	e9 b8 f6 ff ff       	jmp    80106143 <alltraps>

80106a8b <vector112>:
80106a8b:	6a 00                	push   $0x0
80106a8d:	6a 70                	push   $0x70
80106a8f:	e9 af f6 ff ff       	jmp    80106143 <alltraps>

80106a94 <vector113>:
80106a94:	6a 00                	push   $0x0
80106a96:	6a 71                	push   $0x71
80106a98:	e9 a6 f6 ff ff       	jmp    80106143 <alltraps>

80106a9d <vector114>:
80106a9d:	6a 00                	push   $0x0
80106a9f:	6a 72                	push   $0x72
80106aa1:	e9 9d f6 ff ff       	jmp    80106143 <alltraps>

80106aa6 <vector115>:
80106aa6:	6a 00                	push   $0x0
80106aa8:	6a 73                	push   $0x73
80106aaa:	e9 94 f6 ff ff       	jmp    80106143 <alltraps>

80106aaf <vector116>:
80106aaf:	6a 00                	push   $0x0
80106ab1:	6a 74                	push   $0x74
80106ab3:	e9 8b f6 ff ff       	jmp    80106143 <alltraps>

80106ab8 <vector117>:
80106ab8:	6a 00                	push   $0x0
80106aba:	6a 75                	push   $0x75
80106abc:	e9 82 f6 ff ff       	jmp    80106143 <alltraps>

80106ac1 <vector118>:
80106ac1:	6a 00                	push   $0x0
80106ac3:	6a 76                	push   $0x76
80106ac5:	e9 79 f6 ff ff       	jmp    80106143 <alltraps>

80106aca <vector119>:
80106aca:	6a 00                	push   $0x0
80106acc:	6a 77                	push   $0x77
80106ace:	e9 70 f6 ff ff       	jmp    80106143 <alltraps>

80106ad3 <vector120>:
80106ad3:	6a 00                	push   $0x0
80106ad5:	6a 78                	push   $0x78
80106ad7:	e9 67 f6 ff ff       	jmp    80106143 <alltraps>

80106adc <vector121>:
80106adc:	6a 00                	push   $0x0
80106ade:	6a 79                	push   $0x79
80106ae0:	e9 5e f6 ff ff       	jmp    80106143 <alltraps>

80106ae5 <vector122>:
80106ae5:	6a 00                	push   $0x0
80106ae7:	6a 7a                	push   $0x7a
80106ae9:	e9 55 f6 ff ff       	jmp    80106143 <alltraps>

80106aee <vector123>:
80106aee:	6a 00                	push   $0x0
80106af0:	6a 7b                	push   $0x7b
80106af2:	e9 4c f6 ff ff       	jmp    80106143 <alltraps>

80106af7 <vector124>:
80106af7:	6a 00                	push   $0x0
80106af9:	6a 7c                	push   $0x7c
80106afb:	e9 43 f6 ff ff       	jmp    80106143 <alltraps>

80106b00 <vector125>:
80106b00:	6a 00                	push   $0x0
80106b02:	6a 7d                	push   $0x7d
80106b04:	e9 3a f6 ff ff       	jmp    80106143 <alltraps>

80106b09 <vector126>:
80106b09:	6a 00                	push   $0x0
80106b0b:	6a 7e                	push   $0x7e
80106b0d:	e9 31 f6 ff ff       	jmp    80106143 <alltraps>

80106b12 <vector127>:
80106b12:	6a 00                	push   $0x0
80106b14:	6a 7f                	push   $0x7f
80106b16:	e9 28 f6 ff ff       	jmp    80106143 <alltraps>

80106b1b <vector128>:
80106b1b:	6a 00                	push   $0x0
80106b1d:	68 80 00 00 00       	push   $0x80
80106b22:	e9 1c f6 ff ff       	jmp    80106143 <alltraps>

80106b27 <vector129>:
80106b27:	6a 00                	push   $0x0
80106b29:	68 81 00 00 00       	push   $0x81
80106b2e:	e9 10 f6 ff ff       	jmp    80106143 <alltraps>

80106b33 <vector130>:
80106b33:	6a 00                	push   $0x0
80106b35:	68 82 00 00 00       	push   $0x82
80106b3a:	e9 04 f6 ff ff       	jmp    80106143 <alltraps>

80106b3f <vector131>:
80106b3f:	6a 00                	push   $0x0
80106b41:	68 83 00 00 00       	push   $0x83
80106b46:	e9 f8 f5 ff ff       	jmp    80106143 <alltraps>

80106b4b <vector132>:
80106b4b:	6a 00                	push   $0x0
80106b4d:	68 84 00 00 00       	push   $0x84
80106b52:	e9 ec f5 ff ff       	jmp    80106143 <alltraps>

80106b57 <vector133>:
80106b57:	6a 00                	push   $0x0
80106b59:	68 85 00 00 00       	push   $0x85
80106b5e:	e9 e0 f5 ff ff       	jmp    80106143 <alltraps>

80106b63 <vector134>:
80106b63:	6a 00                	push   $0x0
80106b65:	68 86 00 00 00       	push   $0x86
80106b6a:	e9 d4 f5 ff ff       	jmp    80106143 <alltraps>

80106b6f <vector135>:
80106b6f:	6a 00                	push   $0x0
80106b71:	68 87 00 00 00       	push   $0x87
80106b76:	e9 c8 f5 ff ff       	jmp    80106143 <alltraps>

80106b7b <vector136>:
80106b7b:	6a 00                	push   $0x0
80106b7d:	68 88 00 00 00       	push   $0x88
80106b82:	e9 bc f5 ff ff       	jmp    80106143 <alltraps>

80106b87 <vector137>:
80106b87:	6a 00                	push   $0x0
80106b89:	68 89 00 00 00       	push   $0x89
80106b8e:	e9 b0 f5 ff ff       	jmp    80106143 <alltraps>

80106b93 <vector138>:
80106b93:	6a 00                	push   $0x0
80106b95:	68 8a 00 00 00       	push   $0x8a
80106b9a:	e9 a4 f5 ff ff       	jmp    80106143 <alltraps>

80106b9f <vector139>:
80106b9f:	6a 00                	push   $0x0
80106ba1:	68 8b 00 00 00       	push   $0x8b
80106ba6:	e9 98 f5 ff ff       	jmp    80106143 <alltraps>

80106bab <vector140>:
80106bab:	6a 00                	push   $0x0
80106bad:	68 8c 00 00 00       	push   $0x8c
80106bb2:	e9 8c f5 ff ff       	jmp    80106143 <alltraps>

80106bb7 <vector141>:
80106bb7:	6a 00                	push   $0x0
80106bb9:	68 8d 00 00 00       	push   $0x8d
80106bbe:	e9 80 f5 ff ff       	jmp    80106143 <alltraps>

80106bc3 <vector142>:
80106bc3:	6a 00                	push   $0x0
80106bc5:	68 8e 00 00 00       	push   $0x8e
80106bca:	e9 74 f5 ff ff       	jmp    80106143 <alltraps>

80106bcf <vector143>:
80106bcf:	6a 00                	push   $0x0
80106bd1:	68 8f 00 00 00       	push   $0x8f
80106bd6:	e9 68 f5 ff ff       	jmp    80106143 <alltraps>

80106bdb <vector144>:
80106bdb:	6a 00                	push   $0x0
80106bdd:	68 90 00 00 00       	push   $0x90
80106be2:	e9 5c f5 ff ff       	jmp    80106143 <alltraps>

80106be7 <vector145>:
80106be7:	6a 00                	push   $0x0
80106be9:	68 91 00 00 00       	push   $0x91
80106bee:	e9 50 f5 ff ff       	jmp    80106143 <alltraps>

80106bf3 <vector146>:
80106bf3:	6a 00                	push   $0x0
80106bf5:	68 92 00 00 00       	push   $0x92
80106bfa:	e9 44 f5 ff ff       	jmp    80106143 <alltraps>

80106bff <vector147>:
80106bff:	6a 00                	push   $0x0
80106c01:	68 93 00 00 00       	push   $0x93
80106c06:	e9 38 f5 ff ff       	jmp    80106143 <alltraps>

80106c0b <vector148>:
80106c0b:	6a 00                	push   $0x0
80106c0d:	68 94 00 00 00       	push   $0x94
80106c12:	e9 2c f5 ff ff       	jmp    80106143 <alltraps>

80106c17 <vector149>:
80106c17:	6a 00                	push   $0x0
80106c19:	68 95 00 00 00       	push   $0x95
80106c1e:	e9 20 f5 ff ff       	jmp    80106143 <alltraps>

80106c23 <vector150>:
80106c23:	6a 00                	push   $0x0
80106c25:	68 96 00 00 00       	push   $0x96
80106c2a:	e9 14 f5 ff ff       	jmp    80106143 <alltraps>

80106c2f <vector151>:
80106c2f:	6a 00                	push   $0x0
80106c31:	68 97 00 00 00       	push   $0x97
80106c36:	e9 08 f5 ff ff       	jmp    80106143 <alltraps>

80106c3b <vector152>:
80106c3b:	6a 00                	push   $0x0
80106c3d:	68 98 00 00 00       	push   $0x98
80106c42:	e9 fc f4 ff ff       	jmp    80106143 <alltraps>

80106c47 <vector153>:
80106c47:	6a 00                	push   $0x0
80106c49:	68 99 00 00 00       	push   $0x99
80106c4e:	e9 f0 f4 ff ff       	jmp    80106143 <alltraps>

80106c53 <vector154>:
80106c53:	6a 00                	push   $0x0
80106c55:	68 9a 00 00 00       	push   $0x9a
80106c5a:	e9 e4 f4 ff ff       	jmp    80106143 <alltraps>

80106c5f <vector155>:
80106c5f:	6a 00                	push   $0x0
80106c61:	68 9b 00 00 00       	push   $0x9b
80106c66:	e9 d8 f4 ff ff       	jmp    80106143 <alltraps>

80106c6b <vector156>:
80106c6b:	6a 00                	push   $0x0
80106c6d:	68 9c 00 00 00       	push   $0x9c
80106c72:	e9 cc f4 ff ff       	jmp    80106143 <alltraps>

80106c77 <vector157>:
80106c77:	6a 00                	push   $0x0
80106c79:	68 9d 00 00 00       	push   $0x9d
80106c7e:	e9 c0 f4 ff ff       	jmp    80106143 <alltraps>

80106c83 <vector158>:
80106c83:	6a 00                	push   $0x0
80106c85:	68 9e 00 00 00       	push   $0x9e
80106c8a:	e9 b4 f4 ff ff       	jmp    80106143 <alltraps>

80106c8f <vector159>:
80106c8f:	6a 00                	push   $0x0
80106c91:	68 9f 00 00 00       	push   $0x9f
80106c96:	e9 a8 f4 ff ff       	jmp    80106143 <alltraps>

80106c9b <vector160>:
80106c9b:	6a 00                	push   $0x0
80106c9d:	68 a0 00 00 00       	push   $0xa0
80106ca2:	e9 9c f4 ff ff       	jmp    80106143 <alltraps>

80106ca7 <vector161>:
80106ca7:	6a 00                	push   $0x0
80106ca9:	68 a1 00 00 00       	push   $0xa1
80106cae:	e9 90 f4 ff ff       	jmp    80106143 <alltraps>

80106cb3 <vector162>:
80106cb3:	6a 00                	push   $0x0
80106cb5:	68 a2 00 00 00       	push   $0xa2
80106cba:	e9 84 f4 ff ff       	jmp    80106143 <alltraps>

80106cbf <vector163>:
80106cbf:	6a 00                	push   $0x0
80106cc1:	68 a3 00 00 00       	push   $0xa3
80106cc6:	e9 78 f4 ff ff       	jmp    80106143 <alltraps>

80106ccb <vector164>:
80106ccb:	6a 00                	push   $0x0
80106ccd:	68 a4 00 00 00       	push   $0xa4
80106cd2:	e9 6c f4 ff ff       	jmp    80106143 <alltraps>

80106cd7 <vector165>:
80106cd7:	6a 00                	push   $0x0
80106cd9:	68 a5 00 00 00       	push   $0xa5
80106cde:	e9 60 f4 ff ff       	jmp    80106143 <alltraps>

80106ce3 <vector166>:
80106ce3:	6a 00                	push   $0x0
80106ce5:	68 a6 00 00 00       	push   $0xa6
80106cea:	e9 54 f4 ff ff       	jmp    80106143 <alltraps>

80106cef <vector167>:
80106cef:	6a 00                	push   $0x0
80106cf1:	68 a7 00 00 00       	push   $0xa7
80106cf6:	e9 48 f4 ff ff       	jmp    80106143 <alltraps>

80106cfb <vector168>:
80106cfb:	6a 00                	push   $0x0
80106cfd:	68 a8 00 00 00       	push   $0xa8
80106d02:	e9 3c f4 ff ff       	jmp    80106143 <alltraps>

80106d07 <vector169>:
80106d07:	6a 00                	push   $0x0
80106d09:	68 a9 00 00 00       	push   $0xa9
80106d0e:	e9 30 f4 ff ff       	jmp    80106143 <alltraps>

80106d13 <vector170>:
80106d13:	6a 00                	push   $0x0
80106d15:	68 aa 00 00 00       	push   $0xaa
80106d1a:	e9 24 f4 ff ff       	jmp    80106143 <alltraps>

80106d1f <vector171>:
80106d1f:	6a 00                	push   $0x0
80106d21:	68 ab 00 00 00       	push   $0xab
80106d26:	e9 18 f4 ff ff       	jmp    80106143 <alltraps>

80106d2b <vector172>:
80106d2b:	6a 00                	push   $0x0
80106d2d:	68 ac 00 00 00       	push   $0xac
80106d32:	e9 0c f4 ff ff       	jmp    80106143 <alltraps>

80106d37 <vector173>:
80106d37:	6a 00                	push   $0x0
80106d39:	68 ad 00 00 00       	push   $0xad
80106d3e:	e9 00 f4 ff ff       	jmp    80106143 <alltraps>

80106d43 <vector174>:
80106d43:	6a 00                	push   $0x0
80106d45:	68 ae 00 00 00       	push   $0xae
80106d4a:	e9 f4 f3 ff ff       	jmp    80106143 <alltraps>

80106d4f <vector175>:
80106d4f:	6a 00                	push   $0x0
80106d51:	68 af 00 00 00       	push   $0xaf
80106d56:	e9 e8 f3 ff ff       	jmp    80106143 <alltraps>

80106d5b <vector176>:
80106d5b:	6a 00                	push   $0x0
80106d5d:	68 b0 00 00 00       	push   $0xb0
80106d62:	e9 dc f3 ff ff       	jmp    80106143 <alltraps>

80106d67 <vector177>:
80106d67:	6a 00                	push   $0x0
80106d69:	68 b1 00 00 00       	push   $0xb1
80106d6e:	e9 d0 f3 ff ff       	jmp    80106143 <alltraps>

80106d73 <vector178>:
80106d73:	6a 00                	push   $0x0
80106d75:	68 b2 00 00 00       	push   $0xb2
80106d7a:	e9 c4 f3 ff ff       	jmp    80106143 <alltraps>

80106d7f <vector179>:
80106d7f:	6a 00                	push   $0x0
80106d81:	68 b3 00 00 00       	push   $0xb3
80106d86:	e9 b8 f3 ff ff       	jmp    80106143 <alltraps>

80106d8b <vector180>:
80106d8b:	6a 00                	push   $0x0
80106d8d:	68 b4 00 00 00       	push   $0xb4
80106d92:	e9 ac f3 ff ff       	jmp    80106143 <alltraps>

80106d97 <vector181>:
80106d97:	6a 00                	push   $0x0
80106d99:	68 b5 00 00 00       	push   $0xb5
80106d9e:	e9 a0 f3 ff ff       	jmp    80106143 <alltraps>

80106da3 <vector182>:
80106da3:	6a 00                	push   $0x0
80106da5:	68 b6 00 00 00       	push   $0xb6
80106daa:	e9 94 f3 ff ff       	jmp    80106143 <alltraps>

80106daf <vector183>:
80106daf:	6a 00                	push   $0x0
80106db1:	68 b7 00 00 00       	push   $0xb7
80106db6:	e9 88 f3 ff ff       	jmp    80106143 <alltraps>

80106dbb <vector184>:
80106dbb:	6a 00                	push   $0x0
80106dbd:	68 b8 00 00 00       	push   $0xb8
80106dc2:	e9 7c f3 ff ff       	jmp    80106143 <alltraps>

80106dc7 <vector185>:
80106dc7:	6a 00                	push   $0x0
80106dc9:	68 b9 00 00 00       	push   $0xb9
80106dce:	e9 70 f3 ff ff       	jmp    80106143 <alltraps>

80106dd3 <vector186>:
80106dd3:	6a 00                	push   $0x0
80106dd5:	68 ba 00 00 00       	push   $0xba
80106dda:	e9 64 f3 ff ff       	jmp    80106143 <alltraps>

80106ddf <vector187>:
80106ddf:	6a 00                	push   $0x0
80106de1:	68 bb 00 00 00       	push   $0xbb
80106de6:	e9 58 f3 ff ff       	jmp    80106143 <alltraps>

80106deb <vector188>:
80106deb:	6a 00                	push   $0x0
80106ded:	68 bc 00 00 00       	push   $0xbc
80106df2:	e9 4c f3 ff ff       	jmp    80106143 <alltraps>

80106df7 <vector189>:
80106df7:	6a 00                	push   $0x0
80106df9:	68 bd 00 00 00       	push   $0xbd
80106dfe:	e9 40 f3 ff ff       	jmp    80106143 <alltraps>

80106e03 <vector190>:
80106e03:	6a 00                	push   $0x0
80106e05:	68 be 00 00 00       	push   $0xbe
80106e0a:	e9 34 f3 ff ff       	jmp    80106143 <alltraps>

80106e0f <vector191>:
80106e0f:	6a 00                	push   $0x0
80106e11:	68 bf 00 00 00       	push   $0xbf
80106e16:	e9 28 f3 ff ff       	jmp    80106143 <alltraps>

80106e1b <vector192>:
80106e1b:	6a 00                	push   $0x0
80106e1d:	68 c0 00 00 00       	push   $0xc0
80106e22:	e9 1c f3 ff ff       	jmp    80106143 <alltraps>

80106e27 <vector193>:
80106e27:	6a 00                	push   $0x0
80106e29:	68 c1 00 00 00       	push   $0xc1
80106e2e:	e9 10 f3 ff ff       	jmp    80106143 <alltraps>

80106e33 <vector194>:
80106e33:	6a 00                	push   $0x0
80106e35:	68 c2 00 00 00       	push   $0xc2
80106e3a:	e9 04 f3 ff ff       	jmp    80106143 <alltraps>

80106e3f <vector195>:
80106e3f:	6a 00                	push   $0x0
80106e41:	68 c3 00 00 00       	push   $0xc3
80106e46:	e9 f8 f2 ff ff       	jmp    80106143 <alltraps>

80106e4b <vector196>:
80106e4b:	6a 00                	push   $0x0
80106e4d:	68 c4 00 00 00       	push   $0xc4
80106e52:	e9 ec f2 ff ff       	jmp    80106143 <alltraps>

80106e57 <vector197>:
80106e57:	6a 00                	push   $0x0
80106e59:	68 c5 00 00 00       	push   $0xc5
80106e5e:	e9 e0 f2 ff ff       	jmp    80106143 <alltraps>

80106e63 <vector198>:
80106e63:	6a 00                	push   $0x0
80106e65:	68 c6 00 00 00       	push   $0xc6
80106e6a:	e9 d4 f2 ff ff       	jmp    80106143 <alltraps>

80106e6f <vector199>:
80106e6f:	6a 00                	push   $0x0
80106e71:	68 c7 00 00 00       	push   $0xc7
80106e76:	e9 c8 f2 ff ff       	jmp    80106143 <alltraps>

80106e7b <vector200>:
80106e7b:	6a 00                	push   $0x0
80106e7d:	68 c8 00 00 00       	push   $0xc8
80106e82:	e9 bc f2 ff ff       	jmp    80106143 <alltraps>

80106e87 <vector201>:
80106e87:	6a 00                	push   $0x0
80106e89:	68 c9 00 00 00       	push   $0xc9
80106e8e:	e9 b0 f2 ff ff       	jmp    80106143 <alltraps>

80106e93 <vector202>:
80106e93:	6a 00                	push   $0x0
80106e95:	68 ca 00 00 00       	push   $0xca
80106e9a:	e9 a4 f2 ff ff       	jmp    80106143 <alltraps>

80106e9f <vector203>:
80106e9f:	6a 00                	push   $0x0
80106ea1:	68 cb 00 00 00       	push   $0xcb
80106ea6:	e9 98 f2 ff ff       	jmp    80106143 <alltraps>

80106eab <vector204>:
80106eab:	6a 00                	push   $0x0
80106ead:	68 cc 00 00 00       	push   $0xcc
80106eb2:	e9 8c f2 ff ff       	jmp    80106143 <alltraps>

80106eb7 <vector205>:
80106eb7:	6a 00                	push   $0x0
80106eb9:	68 cd 00 00 00       	push   $0xcd
80106ebe:	e9 80 f2 ff ff       	jmp    80106143 <alltraps>

80106ec3 <vector206>:
80106ec3:	6a 00                	push   $0x0
80106ec5:	68 ce 00 00 00       	push   $0xce
80106eca:	e9 74 f2 ff ff       	jmp    80106143 <alltraps>

80106ecf <vector207>:
80106ecf:	6a 00                	push   $0x0
80106ed1:	68 cf 00 00 00       	push   $0xcf
80106ed6:	e9 68 f2 ff ff       	jmp    80106143 <alltraps>

80106edb <vector208>:
80106edb:	6a 00                	push   $0x0
80106edd:	68 d0 00 00 00       	push   $0xd0
80106ee2:	e9 5c f2 ff ff       	jmp    80106143 <alltraps>

80106ee7 <vector209>:
80106ee7:	6a 00                	push   $0x0
80106ee9:	68 d1 00 00 00       	push   $0xd1
80106eee:	e9 50 f2 ff ff       	jmp    80106143 <alltraps>

80106ef3 <vector210>:
80106ef3:	6a 00                	push   $0x0
80106ef5:	68 d2 00 00 00       	push   $0xd2
80106efa:	e9 44 f2 ff ff       	jmp    80106143 <alltraps>

80106eff <vector211>:
80106eff:	6a 00                	push   $0x0
80106f01:	68 d3 00 00 00       	push   $0xd3
80106f06:	e9 38 f2 ff ff       	jmp    80106143 <alltraps>

80106f0b <vector212>:
80106f0b:	6a 00                	push   $0x0
80106f0d:	68 d4 00 00 00       	push   $0xd4
80106f12:	e9 2c f2 ff ff       	jmp    80106143 <alltraps>

80106f17 <vector213>:
80106f17:	6a 00                	push   $0x0
80106f19:	68 d5 00 00 00       	push   $0xd5
80106f1e:	e9 20 f2 ff ff       	jmp    80106143 <alltraps>

80106f23 <vector214>:
80106f23:	6a 00                	push   $0x0
80106f25:	68 d6 00 00 00       	push   $0xd6
80106f2a:	e9 14 f2 ff ff       	jmp    80106143 <alltraps>

80106f2f <vector215>:
80106f2f:	6a 00                	push   $0x0
80106f31:	68 d7 00 00 00       	push   $0xd7
80106f36:	e9 08 f2 ff ff       	jmp    80106143 <alltraps>

80106f3b <vector216>:
80106f3b:	6a 00                	push   $0x0
80106f3d:	68 d8 00 00 00       	push   $0xd8
80106f42:	e9 fc f1 ff ff       	jmp    80106143 <alltraps>

80106f47 <vector217>:
80106f47:	6a 00                	push   $0x0
80106f49:	68 d9 00 00 00       	push   $0xd9
80106f4e:	e9 f0 f1 ff ff       	jmp    80106143 <alltraps>

80106f53 <vector218>:
80106f53:	6a 00                	push   $0x0
80106f55:	68 da 00 00 00       	push   $0xda
80106f5a:	e9 e4 f1 ff ff       	jmp    80106143 <alltraps>

80106f5f <vector219>:
80106f5f:	6a 00                	push   $0x0
80106f61:	68 db 00 00 00       	push   $0xdb
80106f66:	e9 d8 f1 ff ff       	jmp    80106143 <alltraps>

80106f6b <vector220>:
80106f6b:	6a 00                	push   $0x0
80106f6d:	68 dc 00 00 00       	push   $0xdc
80106f72:	e9 cc f1 ff ff       	jmp    80106143 <alltraps>

80106f77 <vector221>:
80106f77:	6a 00                	push   $0x0
80106f79:	68 dd 00 00 00       	push   $0xdd
80106f7e:	e9 c0 f1 ff ff       	jmp    80106143 <alltraps>

80106f83 <vector222>:
80106f83:	6a 00                	push   $0x0
80106f85:	68 de 00 00 00       	push   $0xde
80106f8a:	e9 b4 f1 ff ff       	jmp    80106143 <alltraps>

80106f8f <vector223>:
80106f8f:	6a 00                	push   $0x0
80106f91:	68 df 00 00 00       	push   $0xdf
80106f96:	e9 a8 f1 ff ff       	jmp    80106143 <alltraps>

80106f9b <vector224>:
80106f9b:	6a 00                	push   $0x0
80106f9d:	68 e0 00 00 00       	push   $0xe0
80106fa2:	e9 9c f1 ff ff       	jmp    80106143 <alltraps>

80106fa7 <vector225>:
80106fa7:	6a 00                	push   $0x0
80106fa9:	68 e1 00 00 00       	push   $0xe1
80106fae:	e9 90 f1 ff ff       	jmp    80106143 <alltraps>

80106fb3 <vector226>:
80106fb3:	6a 00                	push   $0x0
80106fb5:	68 e2 00 00 00       	push   $0xe2
80106fba:	e9 84 f1 ff ff       	jmp    80106143 <alltraps>

80106fbf <vector227>:
80106fbf:	6a 00                	push   $0x0
80106fc1:	68 e3 00 00 00       	push   $0xe3
80106fc6:	e9 78 f1 ff ff       	jmp    80106143 <alltraps>

80106fcb <vector228>:
80106fcb:	6a 00                	push   $0x0
80106fcd:	68 e4 00 00 00       	push   $0xe4
80106fd2:	e9 6c f1 ff ff       	jmp    80106143 <alltraps>

80106fd7 <vector229>:
80106fd7:	6a 00                	push   $0x0
80106fd9:	68 e5 00 00 00       	push   $0xe5
80106fde:	e9 60 f1 ff ff       	jmp    80106143 <alltraps>

80106fe3 <vector230>:
80106fe3:	6a 00                	push   $0x0
80106fe5:	68 e6 00 00 00       	push   $0xe6
80106fea:	e9 54 f1 ff ff       	jmp    80106143 <alltraps>

80106fef <vector231>:
80106fef:	6a 00                	push   $0x0
80106ff1:	68 e7 00 00 00       	push   $0xe7
80106ff6:	e9 48 f1 ff ff       	jmp    80106143 <alltraps>

80106ffb <vector232>:
80106ffb:	6a 00                	push   $0x0
80106ffd:	68 e8 00 00 00       	push   $0xe8
80107002:	e9 3c f1 ff ff       	jmp    80106143 <alltraps>

80107007 <vector233>:
80107007:	6a 00                	push   $0x0
80107009:	68 e9 00 00 00       	push   $0xe9
8010700e:	e9 30 f1 ff ff       	jmp    80106143 <alltraps>

80107013 <vector234>:
80107013:	6a 00                	push   $0x0
80107015:	68 ea 00 00 00       	push   $0xea
8010701a:	e9 24 f1 ff ff       	jmp    80106143 <alltraps>

8010701f <vector235>:
8010701f:	6a 00                	push   $0x0
80107021:	68 eb 00 00 00       	push   $0xeb
80107026:	e9 18 f1 ff ff       	jmp    80106143 <alltraps>

8010702b <vector236>:
8010702b:	6a 00                	push   $0x0
8010702d:	68 ec 00 00 00       	push   $0xec
80107032:	e9 0c f1 ff ff       	jmp    80106143 <alltraps>

80107037 <vector237>:
80107037:	6a 00                	push   $0x0
80107039:	68 ed 00 00 00       	push   $0xed
8010703e:	e9 00 f1 ff ff       	jmp    80106143 <alltraps>

80107043 <vector238>:
80107043:	6a 00                	push   $0x0
80107045:	68 ee 00 00 00       	push   $0xee
8010704a:	e9 f4 f0 ff ff       	jmp    80106143 <alltraps>

8010704f <vector239>:
8010704f:	6a 00                	push   $0x0
80107051:	68 ef 00 00 00       	push   $0xef
80107056:	e9 e8 f0 ff ff       	jmp    80106143 <alltraps>

8010705b <vector240>:
8010705b:	6a 00                	push   $0x0
8010705d:	68 f0 00 00 00       	push   $0xf0
80107062:	e9 dc f0 ff ff       	jmp    80106143 <alltraps>

80107067 <vector241>:
80107067:	6a 00                	push   $0x0
80107069:	68 f1 00 00 00       	push   $0xf1
8010706e:	e9 d0 f0 ff ff       	jmp    80106143 <alltraps>

80107073 <vector242>:
80107073:	6a 00                	push   $0x0
80107075:	68 f2 00 00 00       	push   $0xf2
8010707a:	e9 c4 f0 ff ff       	jmp    80106143 <alltraps>

8010707f <vector243>:
8010707f:	6a 00                	push   $0x0
80107081:	68 f3 00 00 00       	push   $0xf3
80107086:	e9 b8 f0 ff ff       	jmp    80106143 <alltraps>

8010708b <vector244>:
8010708b:	6a 00                	push   $0x0
8010708d:	68 f4 00 00 00       	push   $0xf4
80107092:	e9 ac f0 ff ff       	jmp    80106143 <alltraps>

80107097 <vector245>:
80107097:	6a 00                	push   $0x0
80107099:	68 f5 00 00 00       	push   $0xf5
8010709e:	e9 a0 f0 ff ff       	jmp    80106143 <alltraps>

801070a3 <vector246>:
801070a3:	6a 00                	push   $0x0
801070a5:	68 f6 00 00 00       	push   $0xf6
801070aa:	e9 94 f0 ff ff       	jmp    80106143 <alltraps>

801070af <vector247>:
801070af:	6a 00                	push   $0x0
801070b1:	68 f7 00 00 00       	push   $0xf7
801070b6:	e9 88 f0 ff ff       	jmp    80106143 <alltraps>

801070bb <vector248>:
801070bb:	6a 00                	push   $0x0
801070bd:	68 f8 00 00 00       	push   $0xf8
801070c2:	e9 7c f0 ff ff       	jmp    80106143 <alltraps>

801070c7 <vector249>:
801070c7:	6a 00                	push   $0x0
801070c9:	68 f9 00 00 00       	push   $0xf9
801070ce:	e9 70 f0 ff ff       	jmp    80106143 <alltraps>

801070d3 <vector250>:
801070d3:	6a 00                	push   $0x0
801070d5:	68 fa 00 00 00       	push   $0xfa
801070da:	e9 64 f0 ff ff       	jmp    80106143 <alltraps>

801070df <vector251>:
801070df:	6a 00                	push   $0x0
801070e1:	68 fb 00 00 00       	push   $0xfb
801070e6:	e9 58 f0 ff ff       	jmp    80106143 <alltraps>

801070eb <vector252>:
801070eb:	6a 00                	push   $0x0
801070ed:	68 fc 00 00 00       	push   $0xfc
801070f2:	e9 4c f0 ff ff       	jmp    80106143 <alltraps>

801070f7 <vector253>:
801070f7:	6a 00                	push   $0x0
801070f9:	68 fd 00 00 00       	push   $0xfd
801070fe:	e9 40 f0 ff ff       	jmp    80106143 <alltraps>

80107103 <vector254>:
80107103:	6a 00                	push   $0x0
80107105:	68 fe 00 00 00       	push   $0xfe
8010710a:	e9 34 f0 ff ff       	jmp    80106143 <alltraps>

8010710f <vector255>:
8010710f:	6a 00                	push   $0x0
80107111:	68 ff 00 00 00       	push   $0xff
80107116:	e9 28 f0 ff ff       	jmp    80106143 <alltraps>
8010711b:	66 90                	xchg   %ax,%ax
8010711d:	66 90                	xchg   %ax,%ax
8010711f:	90                   	nop

80107120 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107127:	c1 ea 16             	shr    $0x16,%edx
{
8010712a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010712b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010712e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107131:	8b 1f                	mov    (%edi),%ebx
80107133:	f6 c3 01             	test   $0x1,%bl
80107136:	74 28                	je     80107160 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107138:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010713e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107144:	89 f0                	mov    %esi,%eax
}
80107146:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107149:	c1 e8 0a             	shr    $0xa,%eax
8010714c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107151:	01 d8                	add    %ebx,%eax
}
80107153:	5b                   	pop    %ebx
80107154:	5e                   	pop    %esi
80107155:	5f                   	pop    %edi
80107156:	5d                   	pop    %ebp
80107157:	c3                   	ret    
80107158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107160:	85 c9                	test   %ecx,%ecx
80107162:	74 2c                	je     80107190 <walkpgdir+0x70>
80107164:	e8 d7 b5 ff ff       	call   80102740 <kalloc>
80107169:	89 c3                	mov    %eax,%ebx
8010716b:	85 c0                	test   %eax,%eax
8010716d:	74 21                	je     80107190 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010716f:	83 ec 04             	sub    $0x4,%esp
80107172:	68 00 10 00 00       	push   $0x1000
80107177:	6a 00                	push   $0x0
80107179:	50                   	push   %eax
8010717a:	e8 31 dc ff ff       	call   80104db0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010717f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107185:	83 c4 10             	add    $0x10,%esp
80107188:	83 c8 07             	or     $0x7,%eax
8010718b:	89 07                	mov    %eax,(%edi)
8010718d:	eb b5                	jmp    80107144 <walkpgdir+0x24>
8010718f:	90                   	nop
}
80107190:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107193:	31 c0                	xor    %eax,%eax
}
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
8010719a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071a6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801071aa:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801071b0:	89 d6                	mov    %edx,%esi
{
801071b2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801071b3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801071b9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071bf:	8b 45 08             	mov    0x8(%ebp),%eax
801071c2:	29 f0                	sub    %esi,%eax
801071c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071c7:	eb 1f                	jmp    801071e8 <mappages+0x48>
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801071d0:	f6 00 01             	testb  $0x1,(%eax)
801071d3:	75 45                	jne    8010721a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801071d5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801071d8:	83 cb 01             	or     $0x1,%ebx
801071db:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801071dd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801071e0:	74 2e                	je     80107210 <mappages+0x70>
      break;
    a += PGSIZE;
801071e2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801071e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071eb:	b9 01 00 00 00       	mov    $0x1,%ecx
801071f0:	89 f2                	mov    %esi,%edx
801071f2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801071f5:	89 f8                	mov    %edi,%eax
801071f7:	e8 24 ff ff ff       	call   80107120 <walkpgdir>
801071fc:	85 c0                	test   %eax,%eax
801071fe:	75 d0                	jne    801071d0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107200:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107208:	5b                   	pop    %ebx
80107209:	5e                   	pop    %esi
8010720a:	5f                   	pop    %edi
8010720b:	5d                   	pop    %ebp
8010720c:	c3                   	ret    
8010720d:	8d 76 00             	lea    0x0(%esi),%esi
80107210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107213:	31 c0                	xor    %eax,%eax
}
80107215:	5b                   	pop    %ebx
80107216:	5e                   	pop    %esi
80107217:	5f                   	pop    %edi
80107218:	5d                   	pop    %ebp
80107219:	c3                   	ret    
      panic("remap");
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	68 9c 83 10 80       	push   $0x8010839c
80107222:	e8 69 91 ff ff       	call   80100390 <panic>
80107227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722e:	66 90                	xchg   %ax,%ax

80107230 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	89 c6                	mov    %eax,%esi
80107237:	53                   	push   %ebx
80107238:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010723a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107240:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107246:	83 ec 1c             	sub    $0x1c,%esp
80107249:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010724c:	39 da                	cmp    %ebx,%edx
8010724e:	73 5b                	jae    801072ab <deallocuvm.part.0+0x7b>
80107250:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107253:	89 d7                	mov    %edx,%edi
80107255:	eb 14                	jmp    8010726b <deallocuvm.part.0+0x3b>
80107257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725e:	66 90                	xchg   %ax,%ax
80107260:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107266:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107269:	76 40                	jbe    801072ab <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010726b:	31 c9                	xor    %ecx,%ecx
8010726d:	89 fa                	mov    %edi,%edx
8010726f:	89 f0                	mov    %esi,%eax
80107271:	e8 aa fe ff ff       	call   80107120 <walkpgdir>
80107276:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107278:	85 c0                	test   %eax,%eax
8010727a:	74 44                	je     801072c0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010727c:	8b 00                	mov    (%eax),%eax
8010727e:	a8 01                	test   $0x1,%al
80107280:	74 de                	je     80107260 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107287:	74 47                	je     801072d0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107289:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010728c:	05 00 00 00 80       	add    $0x80000000,%eax
80107291:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107297:	50                   	push   %eax
80107298:	e8 e3 b2 ff ff       	call   80102580 <kfree>
      *pte = 0;
8010729d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801072a3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801072a6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801072a9:	77 c0                	ja     8010726b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801072ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b1:	5b                   	pop    %ebx
801072b2:	5e                   	pop    %esi
801072b3:	5f                   	pop    %edi
801072b4:	5d                   	pop    %ebp
801072b5:	c3                   	ret    
801072b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801072c0:	89 fa                	mov    %edi,%edx
801072c2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801072c8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801072ce:	eb 96                	jmp    80107266 <deallocuvm.part.0+0x36>
        panic("kfree");
801072d0:	83 ec 0c             	sub    $0xc,%esp
801072d3:	68 e2 7c 10 80       	push   $0x80107ce2
801072d8:	e8 b3 90 ff ff       	call   80100390 <panic>
801072dd:	8d 76 00             	lea    0x0(%esi),%esi

801072e0 <seginit>:
{
801072e0:	f3 0f 1e fb          	endbr32 
801072e4:	55                   	push   %ebp
801072e5:	89 e5                	mov    %esp,%ebp
801072e7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801072ea:	e8 61 c8 ff ff       	call   80103b50 <cpuid>
  pd[0] = size-1;
801072ef:	ba 2f 00 00 00       	mov    $0x2f,%edx
801072f4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801072fa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801072fe:	c7 80 38 38 11 80 ff 	movl   $0xffff,-0x7feec7c8(%eax)
80107305:	ff 00 00 
80107308:	c7 80 3c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7c4(%eax)
8010730f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107312:	c7 80 40 38 11 80 ff 	movl   $0xffff,-0x7feec7c0(%eax)
80107319:	ff 00 00 
8010731c:	c7 80 44 38 11 80 00 	movl   $0xcf9200,-0x7feec7bc(%eax)
80107323:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107326:	c7 80 48 38 11 80 ff 	movl   $0xffff,-0x7feec7b8(%eax)
8010732d:	ff 00 00 
80107330:	c7 80 4c 38 11 80 00 	movl   $0xcffa00,-0x7feec7b4(%eax)
80107337:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010733a:	c7 80 50 38 11 80 ff 	movl   $0xffff,-0x7feec7b0(%eax)
80107341:	ff 00 00 
80107344:	c7 80 54 38 11 80 00 	movl   $0xcff200,-0x7feec7ac(%eax)
8010734b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010734e:	05 30 38 11 80       	add    $0x80113830,%eax
  pd[1] = (uint)p;
80107353:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107357:	c1 e8 10             	shr    $0x10,%eax
8010735a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010735e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107361:	0f 01 10             	lgdtl  (%eax)
}
80107364:	c9                   	leave  
80107365:	c3                   	ret    
80107366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736d:	8d 76 00             	lea    0x0(%esi),%esi

80107370 <switchkvm>:
{
80107370:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107374:	a1 e4 6a 11 80       	mov    0x80116ae4,%eax
80107379:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010737e:	0f 22 d8             	mov    %eax,%cr3
}
80107381:	c3                   	ret    
80107382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107390 <switchuvm>:
{
80107390:	f3 0f 1e fb          	endbr32 
80107394:	55                   	push   %ebp
80107395:	89 e5                	mov    %esp,%ebp
80107397:	57                   	push   %edi
80107398:	56                   	push   %esi
80107399:	53                   	push   %ebx
8010739a:	83 ec 1c             	sub    $0x1c,%esp
8010739d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801073a0:	85 f6                	test   %esi,%esi
801073a2:	0f 84 cb 00 00 00    	je     80107473 <switchuvm+0xe3>
  if(p->kstack == 0)
801073a8:	8b 46 08             	mov    0x8(%esi),%eax
801073ab:	85 c0                	test   %eax,%eax
801073ad:	0f 84 da 00 00 00    	je     8010748d <switchuvm+0xfd>
  if(p->pgdir == 0)
801073b3:	8b 46 04             	mov    0x4(%esi),%eax
801073b6:	85 c0                	test   %eax,%eax
801073b8:	0f 84 c2 00 00 00    	je     80107480 <switchuvm+0xf0>
  pushcli();
801073be:	e8 dd d7 ff ff       	call   80104ba0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073c3:	e8 18 c7 ff ff       	call   80103ae0 <mycpu>
801073c8:	89 c3                	mov    %eax,%ebx
801073ca:	e8 11 c7 ff ff       	call   80103ae0 <mycpu>
801073cf:	89 c7                	mov    %eax,%edi
801073d1:	e8 0a c7 ff ff       	call   80103ae0 <mycpu>
801073d6:	83 c7 08             	add    $0x8,%edi
801073d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073dc:	e8 ff c6 ff ff       	call   80103ae0 <mycpu>
801073e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073e4:	ba 67 00 00 00       	mov    $0x67,%edx
801073e9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801073f0:	83 c0 08             	add    $0x8,%eax
801073f3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073fa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073ff:	83 c1 08             	add    $0x8,%ecx
80107402:	c1 e8 18             	shr    $0x18,%eax
80107405:	c1 e9 10             	shr    $0x10,%ecx
80107408:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010740e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107414:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107419:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107420:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107425:	e8 b6 c6 ff ff       	call   80103ae0 <mycpu>
8010742a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107431:	e8 aa c6 ff ff       	call   80103ae0 <mycpu>
80107436:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010743a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010743d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107443:	e8 98 c6 ff ff       	call   80103ae0 <mycpu>
80107448:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010744b:	e8 90 c6 ff ff       	call   80103ae0 <mycpu>
80107450:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107454:	b8 28 00 00 00       	mov    $0x28,%eax
80107459:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010745c:	8b 46 04             	mov    0x4(%esi),%eax
8010745f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107464:	0f 22 d8             	mov    %eax,%cr3
}
80107467:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010746a:	5b                   	pop    %ebx
8010746b:	5e                   	pop    %esi
8010746c:	5f                   	pop    %edi
8010746d:	5d                   	pop    %ebp
  popcli();
8010746e:	e9 7d d7 ff ff       	jmp    80104bf0 <popcli>
    panic("switchuvm: no process");
80107473:	83 ec 0c             	sub    $0xc,%esp
80107476:	68 a2 83 10 80       	push   $0x801083a2
8010747b:	e8 10 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107480:	83 ec 0c             	sub    $0xc,%esp
80107483:	68 cd 83 10 80       	push   $0x801083cd
80107488:	e8 03 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010748d:	83 ec 0c             	sub    $0xc,%esp
80107490:	68 b8 83 10 80       	push   $0x801083b8
80107495:	e8 f6 8e ff ff       	call   80100390 <panic>
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074a0 <inituvm>:
{
801074a0:	f3 0f 1e fb          	endbr32 
801074a4:	55                   	push   %ebp
801074a5:	89 e5                	mov    %esp,%ebp
801074a7:	57                   	push   %edi
801074a8:	56                   	push   %esi
801074a9:	53                   	push   %ebx
801074aa:	83 ec 1c             	sub    $0x1c,%esp
801074ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801074b0:	8b 75 10             	mov    0x10(%ebp),%esi
801074b3:	8b 7d 08             	mov    0x8(%ebp),%edi
801074b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801074b9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801074bf:	77 4b                	ja     8010750c <inituvm+0x6c>
  mem = kalloc();
801074c1:	e8 7a b2 ff ff       	call   80102740 <kalloc>
  memset(mem, 0, PGSIZE);
801074c6:	83 ec 04             	sub    $0x4,%esp
801074c9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801074ce:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801074d0:	6a 00                	push   $0x0
801074d2:	50                   	push   %eax
801074d3:	e8 d8 d8 ff ff       	call   80104db0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801074d8:	58                   	pop    %eax
801074d9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074df:	5a                   	pop    %edx
801074e0:	6a 06                	push   $0x6
801074e2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074e7:	31 d2                	xor    %edx,%edx
801074e9:	50                   	push   %eax
801074ea:	89 f8                	mov    %edi,%eax
801074ec:	e8 af fc ff ff       	call   801071a0 <mappages>
  memmove(mem, init, sz);
801074f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074f4:	89 75 10             	mov    %esi,0x10(%ebp)
801074f7:	83 c4 10             	add    $0x10,%esp
801074fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801074fd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107503:	5b                   	pop    %ebx
80107504:	5e                   	pop    %esi
80107505:	5f                   	pop    %edi
80107506:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107507:	e9 44 d9 ff ff       	jmp    80104e50 <memmove>
    panic("inituvm: more than a page");
8010750c:	83 ec 0c             	sub    $0xc,%esp
8010750f:	68 e1 83 10 80       	push   $0x801083e1
80107514:	e8 77 8e ff ff       	call   80100390 <panic>
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107520 <loaduvm>:
{
80107520:	f3 0f 1e fb          	endbr32 
80107524:	55                   	push   %ebp
80107525:	89 e5                	mov    %esp,%ebp
80107527:	57                   	push   %edi
80107528:	56                   	push   %esi
80107529:	53                   	push   %ebx
8010752a:	83 ec 1c             	sub    $0x1c,%esp
8010752d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107530:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107533:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107538:	0f 85 99 00 00 00    	jne    801075d7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010753e:	01 f0                	add    %esi,%eax
80107540:	89 f3                	mov    %esi,%ebx
80107542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107545:	8b 45 14             	mov    0x14(%ebp),%eax
80107548:	01 f0                	add    %esi,%eax
8010754a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010754d:	85 f6                	test   %esi,%esi
8010754f:	75 15                	jne    80107566 <loaduvm+0x46>
80107551:	eb 6d                	jmp    801075c0 <loaduvm+0xa0>
80107553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107557:	90                   	nop
80107558:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010755e:	89 f0                	mov    %esi,%eax
80107560:	29 d8                	sub    %ebx,%eax
80107562:	39 c6                	cmp    %eax,%esi
80107564:	76 5a                	jbe    801075c0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107566:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107569:	8b 45 08             	mov    0x8(%ebp),%eax
8010756c:	31 c9                	xor    %ecx,%ecx
8010756e:	29 da                	sub    %ebx,%edx
80107570:	e8 ab fb ff ff       	call   80107120 <walkpgdir>
80107575:	85 c0                	test   %eax,%eax
80107577:	74 51                	je     801075ca <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107579:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010757b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010757e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107583:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107588:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010758e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107591:	29 d9                	sub    %ebx,%ecx
80107593:	05 00 00 00 80       	add    $0x80000000,%eax
80107598:	57                   	push   %edi
80107599:	51                   	push   %ecx
8010759a:	50                   	push   %eax
8010759b:	ff 75 10             	pushl  0x10(%ebp)
8010759e:	e8 bd a4 ff ff       	call   80101a60 <readi>
801075a3:	83 c4 10             	add    $0x10,%esp
801075a6:	39 f8                	cmp    %edi,%eax
801075a8:	74 ae                	je     80107558 <loaduvm+0x38>
}
801075aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075b2:	5b                   	pop    %ebx
801075b3:	5e                   	pop    %esi
801075b4:	5f                   	pop    %edi
801075b5:	5d                   	pop    %ebp
801075b6:	c3                   	ret    
801075b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075be:	66 90                	xchg   %ax,%ax
801075c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075c3:	31 c0                	xor    %eax,%eax
}
801075c5:	5b                   	pop    %ebx
801075c6:	5e                   	pop    %esi
801075c7:	5f                   	pop    %edi
801075c8:	5d                   	pop    %ebp
801075c9:	c3                   	ret    
      panic("loaduvm: address should exist");
801075ca:	83 ec 0c             	sub    $0xc,%esp
801075cd:	68 fb 83 10 80       	push   $0x801083fb
801075d2:	e8 b9 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801075d7:	83 ec 0c             	sub    $0xc,%esp
801075da:	68 9c 84 10 80       	push   $0x8010849c
801075df:	e8 ac 8d ff ff       	call   80100390 <panic>
801075e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075ef:	90                   	nop

801075f0 <allocuvm>:
{
801075f0:	f3 0f 1e fb          	endbr32 
801075f4:	55                   	push   %ebp
801075f5:	89 e5                	mov    %esp,%ebp
801075f7:	57                   	push   %edi
801075f8:	56                   	push   %esi
801075f9:	53                   	push   %ebx
801075fa:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801075fd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107600:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107603:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107606:	85 c0                	test   %eax,%eax
80107608:	0f 88 b2 00 00 00    	js     801076c0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010760e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107611:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107614:	0f 82 96 00 00 00    	jb     801076b0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010761a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107620:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107626:	39 75 10             	cmp    %esi,0x10(%ebp)
80107629:	77 40                	ja     8010766b <allocuvm+0x7b>
8010762b:	e9 83 00 00 00       	jmp    801076b3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107630:	83 ec 04             	sub    $0x4,%esp
80107633:	68 00 10 00 00       	push   $0x1000
80107638:	6a 00                	push   $0x0
8010763a:	50                   	push   %eax
8010763b:	e8 70 d7 ff ff       	call   80104db0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107640:	58                   	pop    %eax
80107641:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107647:	5a                   	pop    %edx
80107648:	6a 06                	push   $0x6
8010764a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010764f:	89 f2                	mov    %esi,%edx
80107651:	50                   	push   %eax
80107652:	89 f8                	mov    %edi,%eax
80107654:	e8 47 fb ff ff       	call   801071a0 <mappages>
80107659:	83 c4 10             	add    $0x10,%esp
8010765c:	85 c0                	test   %eax,%eax
8010765e:	78 78                	js     801076d8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107660:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107666:	39 75 10             	cmp    %esi,0x10(%ebp)
80107669:	76 48                	jbe    801076b3 <allocuvm+0xc3>
    mem = kalloc();
8010766b:	e8 d0 b0 ff ff       	call   80102740 <kalloc>
80107670:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107672:	85 c0                	test   %eax,%eax
80107674:	75 ba                	jne    80107630 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107676:	83 ec 0c             	sub    $0xc,%esp
80107679:	68 19 84 10 80       	push   $0x80108419
8010767e:	e8 2d 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107683:	8b 45 0c             	mov    0xc(%ebp),%eax
80107686:	83 c4 10             	add    $0x10,%esp
80107689:	39 45 10             	cmp    %eax,0x10(%ebp)
8010768c:	74 32                	je     801076c0 <allocuvm+0xd0>
8010768e:	8b 55 10             	mov    0x10(%ebp),%edx
80107691:	89 c1                	mov    %eax,%ecx
80107693:	89 f8                	mov    %edi,%eax
80107695:	e8 96 fb ff ff       	call   80107230 <deallocuvm.part.0>
      return 0;
8010769a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801076a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a7:	5b                   	pop    %ebx
801076a8:	5e                   	pop    %esi
801076a9:	5f                   	pop    %edi
801076aa:	5d                   	pop    %ebp
801076ab:	c3                   	ret    
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801076b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801076b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076b9:	5b                   	pop    %ebx
801076ba:	5e                   	pop    %esi
801076bb:	5f                   	pop    %edi
801076bc:	5d                   	pop    %ebp
801076bd:	c3                   	ret    
801076be:	66 90                	xchg   %ax,%ax
    return 0;
801076c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801076c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076cd:	5b                   	pop    %ebx
801076ce:	5e                   	pop    %esi
801076cf:	5f                   	pop    %edi
801076d0:	5d                   	pop    %ebp
801076d1:	c3                   	ret    
801076d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801076d8:	83 ec 0c             	sub    $0xc,%esp
801076db:	68 31 84 10 80       	push   $0x80108431
801076e0:	e8 cb 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801076e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801076e8:	83 c4 10             	add    $0x10,%esp
801076eb:	39 45 10             	cmp    %eax,0x10(%ebp)
801076ee:	74 0c                	je     801076fc <allocuvm+0x10c>
801076f0:	8b 55 10             	mov    0x10(%ebp),%edx
801076f3:	89 c1                	mov    %eax,%ecx
801076f5:	89 f8                	mov    %edi,%eax
801076f7:	e8 34 fb ff ff       	call   80107230 <deallocuvm.part.0>
      kfree(mem);
801076fc:	83 ec 0c             	sub    $0xc,%esp
801076ff:	53                   	push   %ebx
80107700:	e8 7b ae ff ff       	call   80102580 <kfree>
      return 0;
80107705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010770c:	83 c4 10             	add    $0x10,%esp
}
8010770f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107712:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107715:	5b                   	pop    %ebx
80107716:	5e                   	pop    %esi
80107717:	5f                   	pop    %edi
80107718:	5d                   	pop    %ebp
80107719:	c3                   	ret    
8010771a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107720 <deallocuvm>:
{
80107720:	f3 0f 1e fb          	endbr32 
80107724:	55                   	push   %ebp
80107725:	89 e5                	mov    %esp,%ebp
80107727:	8b 55 0c             	mov    0xc(%ebp),%edx
8010772a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010772d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107730:	39 d1                	cmp    %edx,%ecx
80107732:	73 0c                	jae    80107740 <deallocuvm+0x20>
}
80107734:	5d                   	pop    %ebp
80107735:	e9 f6 fa ff ff       	jmp    80107230 <deallocuvm.part.0>
8010773a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107740:	89 d0                	mov    %edx,%eax
80107742:	5d                   	pop    %ebp
80107743:	c3                   	ret    
80107744:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010774f:	90                   	nop

80107750 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107750:	f3 0f 1e fb          	endbr32 
80107754:	55                   	push   %ebp
80107755:	89 e5                	mov    %esp,%ebp
80107757:	57                   	push   %edi
80107758:	56                   	push   %esi
80107759:	53                   	push   %ebx
8010775a:	83 ec 0c             	sub    $0xc,%esp
8010775d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107760:	85 f6                	test   %esi,%esi
80107762:	74 55                	je     801077b9 <freevm+0x69>
  if(newsz >= oldsz)
80107764:	31 c9                	xor    %ecx,%ecx
80107766:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010776b:	89 f0                	mov    %esi,%eax
8010776d:	89 f3                	mov    %esi,%ebx
8010776f:	e8 bc fa ff ff       	call   80107230 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107774:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010777a:	eb 0b                	jmp    80107787 <freevm+0x37>
8010777c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107780:	83 c3 04             	add    $0x4,%ebx
80107783:	39 df                	cmp    %ebx,%edi
80107785:	74 23                	je     801077aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107787:	8b 03                	mov    (%ebx),%eax
80107789:	a8 01                	test   $0x1,%al
8010778b:	74 f3                	je     80107780 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010778d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107792:	83 ec 0c             	sub    $0xc,%esp
80107795:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107798:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010779d:	50                   	push   %eax
8010779e:	e8 dd ad ff ff       	call   80102580 <kfree>
801077a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077a6:	39 df                	cmp    %ebx,%edi
801077a8:	75 dd                	jne    80107787 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801077aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801077ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077b0:	5b                   	pop    %ebx
801077b1:	5e                   	pop    %esi
801077b2:	5f                   	pop    %edi
801077b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801077b4:	e9 c7 ad ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
801077b9:	83 ec 0c             	sub    $0xc,%esp
801077bc:	68 4d 84 10 80       	push   $0x8010844d
801077c1:	e8 ca 8b ff ff       	call   80100390 <panic>
801077c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077cd:	8d 76 00             	lea    0x0(%esi),%esi

801077d0 <setupkvm>:
{
801077d0:	f3 0f 1e fb          	endbr32 
801077d4:	55                   	push   %ebp
801077d5:	89 e5                	mov    %esp,%ebp
801077d7:	56                   	push   %esi
801077d8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801077d9:	e8 62 af ff ff       	call   80102740 <kalloc>
801077de:	89 c6                	mov    %eax,%esi
801077e0:	85 c0                	test   %eax,%eax
801077e2:	74 42                	je     80107826 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801077e4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077e7:	bb 60 b4 10 80       	mov    $0x8010b460,%ebx
  memset(pgdir, 0, PGSIZE);
801077ec:	68 00 10 00 00       	push   $0x1000
801077f1:	6a 00                	push   $0x0
801077f3:	50                   	push   %eax
801077f4:	e8 b7 d5 ff ff       	call   80104db0 <memset>
801077f9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077fc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077ff:	83 ec 08             	sub    $0x8,%esp
80107802:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107805:	ff 73 0c             	pushl  0xc(%ebx)
80107808:	8b 13                	mov    (%ebx),%edx
8010780a:	50                   	push   %eax
8010780b:	29 c1                	sub    %eax,%ecx
8010780d:	89 f0                	mov    %esi,%eax
8010780f:	e8 8c f9 ff ff       	call   801071a0 <mappages>
80107814:	83 c4 10             	add    $0x10,%esp
80107817:	85 c0                	test   %eax,%eax
80107819:	78 15                	js     80107830 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010781b:	83 c3 10             	add    $0x10,%ebx
8010781e:	81 fb a0 b4 10 80    	cmp    $0x8010b4a0,%ebx
80107824:	75 d6                	jne    801077fc <setupkvm+0x2c>
}
80107826:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107829:	89 f0                	mov    %esi,%eax
8010782b:	5b                   	pop    %ebx
8010782c:	5e                   	pop    %esi
8010782d:	5d                   	pop    %ebp
8010782e:	c3                   	ret    
8010782f:	90                   	nop
      freevm(pgdir);
80107830:	83 ec 0c             	sub    $0xc,%esp
80107833:	56                   	push   %esi
      return 0;
80107834:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107836:	e8 15 ff ff ff       	call   80107750 <freevm>
      return 0;
8010783b:	83 c4 10             	add    $0x10,%esp
}
8010783e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107841:	89 f0                	mov    %esi,%eax
80107843:	5b                   	pop    %ebx
80107844:	5e                   	pop    %esi
80107845:	5d                   	pop    %ebp
80107846:	c3                   	ret    
80107847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010784e:	66 90                	xchg   %ax,%ax

80107850 <kvmalloc>:
{
80107850:	f3 0f 1e fb          	endbr32 
80107854:	55                   	push   %ebp
80107855:	89 e5                	mov    %esp,%ebp
80107857:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010785a:	e8 71 ff ff ff       	call   801077d0 <setupkvm>
8010785f:	a3 e4 6a 11 80       	mov    %eax,0x80116ae4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107864:	05 00 00 00 80       	add    $0x80000000,%eax
80107869:	0f 22 d8             	mov    %eax,%cr3
}
8010786c:	c9                   	leave  
8010786d:	c3                   	ret    
8010786e:	66 90                	xchg   %ax,%ax

80107870 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107870:	f3 0f 1e fb          	endbr32 
80107874:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107875:	31 c9                	xor    %ecx,%ecx
{
80107877:	89 e5                	mov    %esp,%ebp
80107879:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010787c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010787f:	8b 45 08             	mov    0x8(%ebp),%eax
80107882:	e8 99 f8 ff ff       	call   80107120 <walkpgdir>
  if(pte == 0)
80107887:	85 c0                	test   %eax,%eax
80107889:	74 05                	je     80107890 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010788b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010788e:	c9                   	leave  
8010788f:	c3                   	ret    
    panic("clearpteu");
80107890:	83 ec 0c             	sub    $0xc,%esp
80107893:	68 5e 84 10 80       	push   $0x8010845e
80107898:	e8 f3 8a ff ff       	call   80100390 <panic>
8010789d:	8d 76 00             	lea    0x0(%esi),%esi

801078a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801078a0:	f3 0f 1e fb          	endbr32 
801078a4:	55                   	push   %ebp
801078a5:	89 e5                	mov    %esp,%ebp
801078a7:	57                   	push   %edi
801078a8:	56                   	push   %esi
801078a9:	53                   	push   %ebx
801078aa:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801078ad:	e8 1e ff ff ff       	call   801077d0 <setupkvm>
801078b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078b5:	85 c0                	test   %eax,%eax
801078b7:	0f 84 9b 00 00 00    	je     80107958 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078c0:	85 c9                	test   %ecx,%ecx
801078c2:	0f 84 90 00 00 00    	je     80107958 <copyuvm+0xb8>
801078c8:	31 f6                	xor    %esi,%esi
801078ca:	eb 46                	jmp    80107912 <copyuvm+0x72>
801078cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801078d0:	83 ec 04             	sub    $0x4,%esp
801078d3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801078d9:	68 00 10 00 00       	push   $0x1000
801078de:	57                   	push   %edi
801078df:	50                   	push   %eax
801078e0:	e8 6b d5 ff ff       	call   80104e50 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801078e5:	58                   	pop    %eax
801078e6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078ec:	5a                   	pop    %edx
801078ed:	ff 75 e4             	pushl  -0x1c(%ebp)
801078f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078f5:	89 f2                	mov    %esi,%edx
801078f7:	50                   	push   %eax
801078f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078fb:	e8 a0 f8 ff ff       	call   801071a0 <mappages>
80107900:	83 c4 10             	add    $0x10,%esp
80107903:	85 c0                	test   %eax,%eax
80107905:	78 61                	js     80107968 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107907:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010790d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107910:	76 46                	jbe    80107958 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107912:	8b 45 08             	mov    0x8(%ebp),%eax
80107915:	31 c9                	xor    %ecx,%ecx
80107917:	89 f2                	mov    %esi,%edx
80107919:	e8 02 f8 ff ff       	call   80107120 <walkpgdir>
8010791e:	85 c0                	test   %eax,%eax
80107920:	74 61                	je     80107983 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107922:	8b 00                	mov    (%eax),%eax
80107924:	a8 01                	test   $0x1,%al
80107926:	74 4e                	je     80107976 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107928:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010792a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010792f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107932:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107938:	e8 03 ae ff ff       	call   80102740 <kalloc>
8010793d:	89 c3                	mov    %eax,%ebx
8010793f:	85 c0                	test   %eax,%eax
80107941:	75 8d                	jne    801078d0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107943:	83 ec 0c             	sub    $0xc,%esp
80107946:	ff 75 e0             	pushl  -0x20(%ebp)
80107949:	e8 02 fe ff ff       	call   80107750 <freevm>
  return 0;
8010794e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107955:	83 c4 10             	add    $0x10,%esp
}
80107958:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010795b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795e:	5b                   	pop    %ebx
8010795f:	5e                   	pop    %esi
80107960:	5f                   	pop    %edi
80107961:	5d                   	pop    %ebp
80107962:	c3                   	ret    
80107963:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107967:	90                   	nop
      kfree(mem);
80107968:	83 ec 0c             	sub    $0xc,%esp
8010796b:	53                   	push   %ebx
8010796c:	e8 0f ac ff ff       	call   80102580 <kfree>
      goto bad;
80107971:	83 c4 10             	add    $0x10,%esp
80107974:	eb cd                	jmp    80107943 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107976:	83 ec 0c             	sub    $0xc,%esp
80107979:	68 82 84 10 80       	push   $0x80108482
8010797e:	e8 0d 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107983:	83 ec 0c             	sub    $0xc,%esp
80107986:	68 68 84 10 80       	push   $0x80108468
8010798b:	e8 00 8a ff ff       	call   80100390 <panic>

80107990 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107990:	f3 0f 1e fb          	endbr32 
80107994:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107995:	31 c9                	xor    %ecx,%ecx
{
80107997:	89 e5                	mov    %esp,%ebp
80107999:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010799c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010799f:	8b 45 08             	mov    0x8(%ebp),%eax
801079a2:	e8 79 f7 ff ff       	call   80107120 <walkpgdir>
  if((*pte & PTE_P) == 0)
801079a7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079a9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801079aa:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079b1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079b4:	05 00 00 00 80       	add    $0x80000000,%eax
801079b9:	83 fa 05             	cmp    $0x5,%edx
801079bc:	ba 00 00 00 00       	mov    $0x0,%edx
801079c1:	0f 45 c2             	cmovne %edx,%eax
}
801079c4:	c3                   	ret    
801079c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801079d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801079d0:	f3 0f 1e fb          	endbr32 
801079d4:	55                   	push   %ebp
801079d5:	89 e5                	mov    %esp,%ebp
801079d7:	57                   	push   %edi
801079d8:	56                   	push   %esi
801079d9:	53                   	push   %ebx
801079da:	83 ec 0c             	sub    $0xc,%esp
801079dd:	8b 75 14             	mov    0x14(%ebp),%esi
801079e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801079e3:	85 f6                	test   %esi,%esi
801079e5:	75 3c                	jne    80107a23 <copyout+0x53>
801079e7:	eb 67                	jmp    80107a50 <copyout+0x80>
801079e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801079f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801079f3:	89 fb                	mov    %edi,%ebx
801079f5:	29 d3                	sub    %edx,%ebx
801079f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801079fd:	39 f3                	cmp    %esi,%ebx
801079ff:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a02:	29 fa                	sub    %edi,%edx
80107a04:	83 ec 04             	sub    $0x4,%esp
80107a07:	01 c2                	add    %eax,%edx
80107a09:	53                   	push   %ebx
80107a0a:	ff 75 10             	pushl  0x10(%ebp)
80107a0d:	52                   	push   %edx
80107a0e:	e8 3d d4 ff ff       	call   80104e50 <memmove>
    len -= n;
    buf += n;
80107a13:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107a16:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107a1c:	83 c4 10             	add    $0x10,%esp
80107a1f:	29 de                	sub    %ebx,%esi
80107a21:	74 2d                	je     80107a50 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107a23:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a25:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107a28:	89 55 0c             	mov    %edx,0xc(%ebp)
80107a2b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a31:	57                   	push   %edi
80107a32:	ff 75 08             	pushl  0x8(%ebp)
80107a35:	e8 56 ff ff ff       	call   80107990 <uva2ka>
    if(pa0 == 0)
80107a3a:	83 c4 10             	add    $0x10,%esp
80107a3d:	85 c0                	test   %eax,%eax
80107a3f:	75 af                	jne    801079f0 <copyout+0x20>
  }
  return 0;
}
80107a41:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a49:	5b                   	pop    %ebx
80107a4a:	5e                   	pop    %esi
80107a4b:	5f                   	pop    %edi
80107a4c:	5d                   	pop    %ebp
80107a4d:	c3                   	ret    
80107a4e:	66 90                	xchg   %ax,%ax
80107a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a53:	31 c0                	xor    %eax,%eax
}
80107a55:	5b                   	pop    %ebx
80107a56:	5e                   	pop    %esi
80107a57:	5f                   	pop    %edi
80107a58:	5d                   	pop    %ebp
80107a59:	c3                   	ret    
