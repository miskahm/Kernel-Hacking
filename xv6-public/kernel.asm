
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
80100028:	bc f0 54 11 80       	mov    $0x801154f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 32 10 80       	mov    $0x80103220,%eax
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

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 a0 75 10 80       	push   $0x801075a0
80100055:	68 20 a5 10 80       	push   $0x8010a520
8010005a:	e8 11 46 00 00       	call   80104670 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006e:	ec 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100078:	ec 10 80 
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
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 75 10 80       	push   $0x801075a7
80100097:	50                   	push   %eax
80100098:	e8 93 44 00 00       	call   80104530 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
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
801000dd:	8b 75 08             	mov    0x8(%ebp),%esi
801000e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e3:	68 20 a5 10 80       	push   $0x8010a520
801000e8:	e8 83 47 00 00       	call   80104870 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 99 46 00 00       	call   80104800 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 43 00 00       	call   80104570 <acquiresleep>
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
8010018c:	e8 cf 22 00 00       	call   80102460 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 75 10 80       	push   $0x801075ae
801001a6:	e8 e5 01 00 00       	call   80100390 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

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
801001c2:	e8 49 44 00 00       	call   80104610 <holdingsleep>
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
801001d8:	e9 83 22 00 00       	jmp    80102460 <iderw>
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
80100203:	e8 08 44 00 00       	call   80104610 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 b8 43 00 00       	call   801045d0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021f:	e8 4c 46 00 00       	call   80104870 <acquire>
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
80100246:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 8b 45 00 00       	jmp    80104800 <release>
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
8010029d:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002a3:	ff 75 08             	pushl  0x8(%ebp)
  target = n;
801002a6:	89 df                	mov    %ebx,%edi
  iunlock(ip);
801002a8:	e8 03 17 00 00       	call   801019b0 <iunlock>
  acquire(&cons.lock);
801002ad:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002b4:	e8 b7 45 00 00       	call   80104870 <acquire>
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
801002bc:	85 db                	test   %ebx,%ebx
801002be:	0f 8e 98 00 00 00    	jle    8010035c <consoleread+0xcc>
    while(input.r == input.w){
801002c4:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002c9:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002cf:	74 29                	je     801002fa <consoleread+0x6a>
801002d1:	eb 5d                	jmp    80100330 <consoleread+0xa0>
801002d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801002d7:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 ef 10 80       	push   $0x8010ef20
801002e0:	68 00 ef 10 80       	push   $0x8010ef00
801002e5:	e8 66 3f 00 00       	call   80104250 <sleep>
    while(input.r == input.w){
801002ea:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 71 38 00 00       	call   80103b70 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 ef 10 80       	push   $0x8010ef20
8010030e:	e8 ed 44 00 00       	call   80104800 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 b4 15 00 00       	call   801018d0 <ilock>
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
80100333:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 37                	je     80100381 <consoleread+0xf1>
    *dst++ = c;
8010034a:	83 c6 01             	add    $0x1,%esi
    --n;
8010034d:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100350:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
80100353:	83 f9 0a             	cmp    $0xa,%ecx
80100356:	0f 85 60 ff ff ff    	jne    801002bc <consoleread+0x2c>
  release(&cons.lock);
8010035c:	83 ec 0c             	sub    $0xc,%esp
8010035f:	68 20 ef 10 80       	push   $0x8010ef20
80100364:	e8 97 44 00 00       	call   80104800 <release>
  ilock(ip);
80100369:	58                   	pop    %eax
8010036a:	ff 75 08             	pushl  0x8(%ebp)
8010036d:	e8 5e 15 00 00       	call   801018d0 <ilock>
  return target - n;
80100372:	89 f8                	mov    %edi,%eax
80100374:	83 c4 10             	add    $0x10,%esp
}
80100377:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037a:	29 d8                	sub    %ebx,%eax
}
8010037c:	5b                   	pop    %ebx
8010037d:	5e                   	pop    %esi
8010037e:	5f                   	pop    %edi
8010037f:	5d                   	pop    %ebp
80100380:	c3                   	ret    
      if(n < target){
80100381:	39 fb                	cmp    %edi,%ebx
80100383:	73 d7                	jae    8010035c <consoleread+0xcc>
        input.r--;
80100385:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
8010038a:	eb d0                	jmp    8010035c <consoleread+0xcc>
8010038c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
8010039d:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ce 26 00 00       	call   80102a80 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 75 10 80       	push   $0x801075cd
801003bb:	e8 d0 02 00 00       	call   80100690 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 c7 02 00 00       	call   80100690 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 3b 7f 10 80 	movl   $0x80107f3b,(%esp)
801003d0:	e8 bb 02 00 00       	call   80100690 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 af 42 00 00       	call   80104690 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
801003e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003e8:	83 ec 08             	sub    $0x8,%esp
801003eb:	ff 33                	pushl  (%ebx)
  for(i=0; i<10; i++)
801003ed:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003f0:	68 e1 75 10 80       	push   $0x801075e1
801003f5:	e8 96 02 00 00       	call   80100690 <cprintf>
  for(i=0; i<10; i++)
801003fa:	83 c4 10             	add    $0x10,%esp
801003fd:	39 f3                	cmp    %esi,%ebx
801003ff:	75 e7                	jne    801003e8 <panic+0x58>
  panicked = 1; // freeze other CPU
80100401:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
80100408:	00 00 00 
  for(;;)
8010040b:	eb fe                	jmp    8010040b <panic+0x7b>
8010040d:	8d 76 00             	lea    0x0(%esi),%esi

80100410 <cgaputc>:
{
80100410:	55                   	push   %ebp
80100411:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 e5                	mov    %esp,%ebp
8010041a:	57                   	push   %edi
8010041b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100420:	56                   	push   %esi
80100421:	89 fa                	mov    %edi,%edx
80100423:	53                   	push   %ebx
80100424:	83 ec 1c             	sub    $0x1c,%esp
80100427:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100428:	be d5 03 00 00       	mov    $0x3d5,%esi
8010042d:	89 f2                	mov    %esi,%edx
8010042f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100430:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100433:	89 fa                	mov    %edi,%edx
80100435:	c1 e0 08             	shl    $0x8,%eax
80100438:	89 c3                	mov    %eax,%ebx
8010043a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100440:	89 f2                	mov    %esi,%edx
80100442:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100443:	0f b6 c0             	movzbl %al,%eax
80100446:	09 d8                	or     %ebx,%eax
  if(c == '\n')
80100448:	83 f9 0a             	cmp    $0xa,%ecx
8010044b:	0f 84 97 00 00 00    	je     801004e8 <cgaputc+0xd8>
  else if(c == BACKSPACE){
80100451:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
80100457:	74 77                	je     801004d0 <cgaputc+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100459:	0f b6 c9             	movzbl %cl,%ecx
8010045c:	8d 58 01             	lea    0x1(%eax),%ebx
8010045f:	80 cd 07             	or     $0x7,%ch
80100462:	66 89 8c 00 00 80 0b 	mov    %cx,-0x7ff48000(%eax,%eax,1)
80100469:	80 
  if(pos < 0 || pos > 25*80)
8010046a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100470:	0f 8f cc 00 00 00    	jg     80100542 <cgaputc+0x132>
  if((pos/80) >= 24){  // Scroll up.
80100476:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010047c:	0f 8f 7e 00 00 00    	jg     80100500 <cgaputc+0xf0>
  outb(CRTPORT+1, pos>>8);
80100482:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
80100485:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
80100487:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
8010048e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100491:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100496:	b8 0e 00 00 00       	mov    $0xe,%eax
8010049b:	89 da                	mov    %ebx,%edx
8010049d:	ee                   	out    %al,(%dx)
8010049e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a3:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004a7:	89 ca                	mov    %ecx,%edx
801004a9:	ee                   	out    %al,(%dx)
801004aa:	b8 0f 00 00 00       	mov    $0xf,%eax
801004af:	89 da                	mov    %ebx,%edx
801004b1:	ee                   	out    %al,(%dx)
801004b2:	89 f8                	mov    %edi,%eax
801004b4:	89 ca                	mov    %ecx,%edx
801004b6:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b7:	b8 20 07 00 00       	mov    $0x720,%eax
801004bc:	66 89 06             	mov    %ax,(%esi)
}
801004bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c2:	5b                   	pop    %ebx
801004c3:	5e                   	pop    %esi
801004c4:	5f                   	pop    %edi
801004c5:	5d                   	pop    %ebp
801004c6:	c3                   	ret    
801004c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004ce:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 93                	jne    8010046a <cgaputc+0x5a>
801004d7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb ad                	jmp    80100491 <cgaputc+0x81>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 58 50             	lea    0x50(%eax),%ebx
801004fb:	e9 6a ff ff ff       	jmp    8010046a <cgaputc+0x5a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100500:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100503:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100506:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010050d:	68 60 0e 00 00       	push   $0xe60
80100512:	68 a0 80 0b 80       	push   $0x800b80a0
80100517:	68 00 80 0b 80       	push   $0x800b8000
8010051c:	e8 bf 44 00 00       	call   801049e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100521:	b8 80 07 00 00       	mov    $0x780,%eax
80100526:	83 c4 0c             	add    $0xc,%esp
80100529:	29 f8                	sub    %edi,%eax
8010052b:	01 c0                	add    %eax,%eax
8010052d:	50                   	push   %eax
8010052e:	6a 00                	push   $0x0
80100530:	56                   	push   %esi
80100531:	e8 0a 44 00 00       	call   80104940 <memset>
  outb(CRTPORT+1, pos);
80100536:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010053a:	83 c4 10             	add    $0x10,%esp
8010053d:	e9 4f ff ff ff       	jmp    80100491 <cgaputc+0x81>
    panic("pos under/overflow");
80100542:	83 ec 0c             	sub    $0xc,%esp
80100545:	68 e5 75 10 80       	push   $0x801075e5
8010054a:	e8 41 fe ff ff       	call   80100390 <panic>
8010054f:	90                   	nop

80100550 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100550:	f3 0f 1e fb          	endbr32 
80100554:	55                   	push   %ebp
80100555:	89 e5                	mov    %esp,%ebp
80100557:	57                   	push   %edi
80100558:	56                   	push   %esi
80100559:	53                   	push   %ebx
8010055a:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
8010055d:	ff 75 08             	pushl  0x8(%ebp)
{
80100560:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
80100563:	e8 48 14 00 00       	call   801019b0 <iunlock>
  acquire(&cons.lock);
80100568:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010056f:	e8 fc 42 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++)
80100574:	83 c4 10             	add    $0x10,%esp
80100577:	85 f6                	test   %esi,%esi
80100579:	7e 36                	jle    801005b1 <consolewrite+0x61>
8010057b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010057e:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
80100581:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100587:	85 d2                	test   %edx,%edx
80100589:	74 05                	je     80100590 <consolewrite+0x40>
  asm volatile("cli");
8010058b:	fa                   	cli    
    for(;;)
8010058c:	eb fe                	jmp    8010058c <consolewrite+0x3c>
8010058e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100590:	0f b6 03             	movzbl (%ebx),%eax
    uartputc(c);
80100593:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < n; i++)
80100596:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100599:	50                   	push   %eax
8010059a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010059d:	e8 0e 5b 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
801005a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801005a5:	e8 66 fe ff ff       	call   80100410 <cgaputc>
  for(i = 0; i < n; i++)
801005aa:	83 c4 10             	add    $0x10,%esp
801005ad:	39 df                	cmp    %ebx,%edi
801005af:	75 d0                	jne    80100581 <consolewrite+0x31>
  release(&cons.lock);
801005b1:	83 ec 0c             	sub    $0xc,%esp
801005b4:	68 20 ef 10 80       	push   $0x8010ef20
801005b9:	e8 42 42 00 00       	call   80104800 <release>
  ilock(ip);
801005be:	58                   	pop    %eax
801005bf:	ff 75 08             	pushl  0x8(%ebp)
801005c2:	e8 09 13 00 00       	call   801018d0 <ilock>

  return n;
}
801005c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005ca:	89 f0                	mov    %esi,%eax
801005cc:	5b                   	pop    %ebx
801005cd:	5e                   	pop    %esi
801005ce:	5f                   	pop    %edi
801005cf:	5d                   	pop    %ebp
801005d0:	c3                   	ret    
801005d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005df:	90                   	nop

801005e0 <printint>:
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	57                   	push   %edi
801005e4:	56                   	push   %esi
801005e5:	53                   	push   %ebx
801005e6:	83 ec 2c             	sub    $0x2c,%esp
801005e9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801005ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801005ef:	85 c9                	test   %ecx,%ecx
801005f1:	74 04                	je     801005f7 <printint+0x17>
801005f3:	85 c0                	test   %eax,%eax
801005f5:	78 7e                	js     80100675 <printint+0x95>
    x = xx;
801005f7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801005fe:	89 c1                	mov    %eax,%ecx
  i = 0;
80100600:	31 db                	xor    %ebx,%ebx
80100602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100608:	89 c8                	mov    %ecx,%eax
8010060a:	31 d2                	xor    %edx,%edx
8010060c:	89 de                	mov    %ebx,%esi
8010060e:	89 cf                	mov    %ecx,%edi
80100610:	f7 75 d4             	divl   -0x2c(%ebp)
80100613:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100616:	0f b6 92 10 76 10 80 	movzbl -0x7fef89f0(%edx),%edx
  }while((x /= base) != 0);
8010061d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010061f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100623:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100626:	73 e0                	jae    80100608 <printint+0x28>
  if(sign)
80100628:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010062b:	85 c9                	test   %ecx,%ecx
8010062d:	74 0c                	je     8010063b <printint+0x5b>
    buf[i++] = '-';
8010062f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100634:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100636:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010063b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010063f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100644:	85 c0                	test   %eax,%eax
80100646:	74 08                	je     80100650 <printint+0x70>
80100648:	fa                   	cli    
    for(;;)
80100649:	eb fe                	jmp    80100649 <printint+0x69>
8010064b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010064f:	90                   	nop
    consputc(buf[i]);
80100650:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100653:	83 ec 0c             	sub    $0xc,%esp
80100656:	56                   	push   %esi
80100657:	e8 54 5a 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
8010065c:	89 f0                	mov    %esi,%eax
8010065e:	e8 ad fd ff ff       	call   80100410 <cgaputc>
  while(--i >= 0)
80100663:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100666:	83 c4 10             	add    $0x10,%esp
80100669:	39 c3                	cmp    %eax,%ebx
8010066b:	74 0e                	je     8010067b <printint+0x9b>
    consputc(buf[i]);
8010066d:	0f b6 13             	movzbl (%ebx),%edx
80100670:	83 eb 01             	sub    $0x1,%ebx
80100673:	eb ca                	jmp    8010063f <printint+0x5f>
    x = -xx;
80100675:	f7 d8                	neg    %eax
80100677:	89 c1                	mov    %eax,%ecx
80100679:	eb 85                	jmp    80100600 <printint+0x20>
}
8010067b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010067e:	5b                   	pop    %ebx
8010067f:	5e                   	pop    %esi
80100680:	5f                   	pop    %edi
80100681:	5d                   	pop    %ebp
80100682:	c3                   	ret    
80100683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010068a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100690 <cprintf>:
{
80100690:	f3 0f 1e fb          	endbr32 
80100694:	55                   	push   %ebp
80100695:	89 e5                	mov    %esp,%ebp
80100697:	57                   	push   %edi
80100698:	56                   	push   %esi
80100699:	53                   	push   %ebx
8010069a:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010069d:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006a5:	85 c0                	test   %eax,%eax
801006a7:	0f 85 33 01 00 00    	jne    801007e0 <cprintf+0x150>
  if (fmt == 0)
801006ad:	8b 75 08             	mov    0x8(%ebp),%esi
801006b0:	85 f6                	test   %esi,%esi
801006b2:	0f 84 3b 02 00 00    	je     801008f3 <cprintf+0x263>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006b8:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006bb:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006be:	31 db                	xor    %ebx,%ebx
801006c0:	85 c0                	test   %eax,%eax
801006c2:	74 56                	je     8010071a <cprintf+0x8a>
    if(c != '%'){
801006c4:	83 f8 25             	cmp    $0x25,%eax
801006c7:	0f 85 d3 00 00 00    	jne    801007a0 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801006cd:	83 c3 01             	add    $0x1,%ebx
801006d0:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006d4:	85 d2                	test   %edx,%edx
801006d6:	74 42                	je     8010071a <cprintf+0x8a>
    switch(c){
801006d8:	83 fa 70             	cmp    $0x70,%edx
801006db:	0f 84 90 00 00 00    	je     80100771 <cprintf+0xe1>
801006e1:	7f 4d                	jg     80100730 <cprintf+0xa0>
801006e3:	83 fa 25             	cmp    $0x25,%edx
801006e6:	0f 84 44 01 00 00    	je     80100830 <cprintf+0x1a0>
801006ec:	83 fa 64             	cmp    $0x64,%edx
801006ef:	0f 85 00 01 00 00    	jne    801007f5 <cprintf+0x165>
      printint(*argp++, 10, 1);
801006f5:	8d 47 04             	lea    0x4(%edi),%eax
801006f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801006fd:	ba 0a 00 00 00       	mov    $0xa,%edx
80100702:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100705:	8b 07                	mov    (%edi),%eax
80100707:	e8 d4 fe ff ff       	call   801005e0 <printint>
8010070c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070f:	83 c3 01             	add    $0x1,%ebx
80100712:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100716:	85 c0                	test   %eax,%eax
80100718:	75 aa                	jne    801006c4 <cprintf+0x34>
  if(locking)
8010071a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010071d:	85 c0                	test   %eax,%eax
8010071f:	0f 85 b1 01 00 00    	jne    801008d6 <cprintf+0x246>
}
80100725:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100728:	5b                   	pop    %ebx
80100729:	5e                   	pop    %esi
8010072a:	5f                   	pop    %edi
8010072b:	5d                   	pop    %ebp
8010072c:	c3                   	ret    
8010072d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	75 33                	jne    80100768 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100735:	8d 47 04             	lea    0x4(%edi),%eax
80100738:	8b 3f                	mov    (%edi),%edi
8010073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010073d:	85 ff                	test   %edi,%edi
8010073f:	0f 85 33 01 00 00    	jne    80100878 <cprintf+0x1e8>
        s = "(null)";
80100745:	bf f8 75 10 80       	mov    $0x801075f8,%edi
      for(; *s; s++)
8010074a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010074d:	b8 28 00 00 00       	mov    $0x28,%eax
80100752:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100754:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010075a:	85 d2                	test   %edx,%edx
8010075c:	0f 84 27 01 00 00    	je     80100889 <cprintf+0x1f9>
80100762:	fa                   	cli    
    for(;;)
80100763:	eb fe                	jmp    80100763 <cprintf+0xd3>
80100765:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100768:	83 fa 78             	cmp    $0x78,%edx
8010076b:	0f 85 84 00 00 00    	jne    801007f5 <cprintf+0x165>
      printint(*argp++, 16, 0);
80100771:	8d 47 04             	lea    0x4(%edi),%eax
80100774:	31 c9                	xor    %ecx,%ecx
80100776:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010077e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100781:	8b 07                	mov    (%edi),%eax
80100783:	e8 58 fe ff ff       	call   801005e0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100788:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010078c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010078f:	85 c0                	test   %eax,%eax
80100791:	0f 85 2d ff ff ff    	jne    801006c4 <cprintf+0x34>
80100797:	eb 81                	jmp    8010071a <cprintf+0x8a>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007a0:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007a6:	85 c9                	test   %ecx,%ecx
801007a8:	74 06                	je     801007b0 <cprintf+0x120>
801007aa:	fa                   	cli    
    for(;;)
801007ab:	eb fe                	jmp    801007ab <cprintf+0x11b>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801007b0:	83 ec 0c             	sub    $0xc,%esp
801007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801007b9:	50                   	push   %eax
801007ba:	e8 f1 58 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
801007bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007c2:	e8 49 fc ff ff       	call   80100410 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007c7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801007cb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ce:	85 c0                	test   %eax,%eax
801007d0:	0f 85 ee fe ff ff    	jne    801006c4 <cprintf+0x34>
801007d6:	e9 3f ff ff ff       	jmp    8010071a <cprintf+0x8a>
801007db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 83 40 00 00       	call   80104870 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 b8 fe ff ff       	jmp    801006ad <cprintf+0x1d>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 71                	jne    80100870 <cprintf+0x1e0>
    uartputc(c);
801007ff:	83 ec 0c             	sub    $0xc,%esp
80100802:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100805:	6a 25                	push   $0x25
80100807:	e8 a4 58 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
8010080c:	b8 25 00 00 00       	mov    $0x25,%eax
80100811:	e8 fa fb ff ff       	call   80100410 <cgaputc>
  if(panicked){
80100816:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010081c:	83 c4 10             	add    $0x10,%esp
8010081f:	85 d2                	test   %edx,%edx
80100821:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100824:	0f 84 8e 00 00 00    	je     801008b8 <cprintf+0x228>
8010082a:	fa                   	cli    
    for(;;)
8010082b:	eb fe                	jmp    8010082b <cprintf+0x19b>
8010082d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100830:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100835:	85 c0                	test   %eax,%eax
80100837:	74 07                	je     80100840 <cprintf+0x1b0>
80100839:	fa                   	cli    
    for(;;)
8010083a:	eb fe                	jmp    8010083a <cprintf+0x1aa>
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
80100840:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100843:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100846:	6a 25                	push   $0x25
80100848:	e8 63 58 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
8010084d:	b8 25 00 00 00       	mov    $0x25,%eax
80100852:	e8 b9 fb ff ff       	call   80100410 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100857:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
8010085b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010085e:	85 c0                	test   %eax,%eax
80100860:	0f 85 5e fe ff ff    	jne    801006c4 <cprintf+0x34>
80100866:	e9 af fe ff ff       	jmp    8010071a <cprintf+0x8a>
8010086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010086f:	90                   	nop
80100870:	fa                   	cli    
    for(;;)
80100871:	eb fe                	jmp    80100871 <cprintf+0x1e1>
80100873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100877:	90                   	nop
      for(; *s; s++)
80100878:	0f b6 07             	movzbl (%edi),%eax
8010087b:	84 c0                	test   %al,%al
8010087d:	74 6c                	je     801008eb <cprintf+0x25b>
8010087f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100882:	89 fb                	mov    %edi,%ebx
80100884:	e9 cb fe ff ff       	jmp    80100754 <cprintf+0xc4>
    uartputc(c);
80100889:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010088c:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
8010088f:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100892:	57                   	push   %edi
80100893:	e8 18 58 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
80100898:	89 f8                	mov    %edi,%eax
8010089a:	e8 71 fb ff ff       	call   80100410 <cgaputc>
      for(; *s; s++)
8010089f:	0f b6 03             	movzbl (%ebx),%eax
801008a2:	83 c4 10             	add    $0x10,%esp
801008a5:	84 c0                	test   %al,%al
801008a7:	0f 85 a7 fe ff ff    	jne    80100754 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
801008ad:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801008b0:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008b3:	e9 57 fe ff ff       	jmp    8010070f <cprintf+0x7f>
    uartputc(c);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008be:	52                   	push   %edx
801008bf:	e8 ec 57 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
801008c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008c7:	89 d0                	mov    %edx,%eax
801008c9:	e8 42 fb ff ff       	call   80100410 <cgaputc>
}
801008ce:	83 c4 10             	add    $0x10,%esp
801008d1:	e9 39 fe ff ff       	jmp    8010070f <cprintf+0x7f>
    release(&cons.lock);
801008d6:	83 ec 0c             	sub    $0xc,%esp
801008d9:	68 20 ef 10 80       	push   $0x8010ef20
801008de:	e8 1d 3f 00 00       	call   80104800 <release>
801008e3:	83 c4 10             	add    $0x10,%esp
}
801008e6:	e9 3a fe ff ff       	jmp    80100725 <cprintf+0x95>
      if((s = (char*)*argp++) == 0)
801008eb:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008ee:	e9 1c fe ff ff       	jmp    8010070f <cprintf+0x7f>
    panic("null fmt");
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	68 ff 75 10 80       	push   $0x801075ff
801008fb:	e8 90 fa ff ff       	call   80100390 <panic>

80100900 <consoleintr>:
{
80100900:	f3 0f 1e fb          	endbr32 
80100904:	55                   	push   %ebp
80100905:	89 e5                	mov    %esp,%ebp
80100907:	57                   	push   %edi
80100908:	56                   	push   %esi
80100909:	53                   	push   %ebx
  int c, doprocdump = 0;
8010090a:	31 db                	xor    %ebx,%ebx
{
8010090c:	83 ec 28             	sub    $0x28,%esp
8010090f:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
80100912:	68 20 ef 10 80       	push   $0x8010ef20
80100917:	e8 54 3f 00 00       	call   80104870 <acquire>
  while((c = getc()) >= 0){
8010091c:	83 c4 10             	add    $0x10,%esp
8010091f:	eb 1e                	jmp    8010093f <consoleintr+0x3f>
80100921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100928:	83 f8 08             	cmp    $0x8,%eax
8010092b:	0f 84 0f 01 00 00    	je     80100a40 <consoleintr+0x140>
80100931:	83 f8 10             	cmp    $0x10,%eax
80100934:	0f 85 92 01 00 00    	jne    80100acc <consoleintr+0x1cc>
8010093a:	bb 01 00 00 00       	mov    $0x1,%ebx
  while((c = getc()) >= 0){
8010093f:	ff d6                	call   *%esi
80100941:	85 c0                	test   %eax,%eax
80100943:	0f 88 67 01 00 00    	js     80100ab0 <consoleintr+0x1b0>
    switch(c){
80100949:	83 f8 15             	cmp    $0x15,%eax
8010094c:	0f 84 b6 00 00 00    	je     80100a08 <consoleintr+0x108>
80100952:	7e d4                	jle    80100928 <consoleintr+0x28>
80100954:	83 f8 7f             	cmp    $0x7f,%eax
80100957:	0f 84 e3 00 00 00    	je     80100a40 <consoleintr+0x140>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010095d:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
80100963:	89 d1                	mov    %edx,%ecx
80100965:	2b 0d 00 ef 10 80    	sub    0x8010ef00,%ecx
8010096b:	83 f9 7f             	cmp    $0x7f,%ecx
8010096e:	77 cf                	ja     8010093f <consoleintr+0x3f>
        input.buf[input.e++ % INPUT_BUF] = c;
80100970:	89 d1                	mov    %edx,%ecx
80100972:	83 c2 01             	add    $0x1,%edx
  if(panicked){
80100975:	8b 3d 58 ef 10 80    	mov    0x8010ef58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
8010097b:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100981:	83 e1 7f             	and    $0x7f,%ecx
        c = (c == '\r') ? '\n' : c;
80100984:	83 f8 0d             	cmp    $0xd,%eax
80100987:	0f 84 93 01 00 00    	je     80100b20 <consoleintr+0x220>
        input.buf[input.e++ % INPUT_BUF] = c;
8010098d:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
  if(panicked){
80100993:	85 ff                	test   %edi,%edi
80100995:	0f 85 90 01 00 00    	jne    80100b2b <consoleintr+0x22b>
  if(c == BACKSPACE){
8010099b:	3d 00 01 00 00       	cmp    $0x100,%eax
801009a0:	0f 85 ab 01 00 00    	jne    80100b51 <consoleintr+0x251>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801009a6:	83 ec 0c             	sub    $0xc,%esp
801009a9:	6a 08                	push   $0x8
801009ab:	e8 00 57 00 00       	call   801060b0 <uartputc>
801009b0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801009b7:	e8 f4 56 00 00       	call   801060b0 <uartputc>
801009bc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801009c3:	e8 e8 56 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
801009c8:	b8 00 01 00 00       	mov    $0x100,%eax
801009cd:	e8 3e fa ff ff       	call   80100410 <cgaputc>
801009d2:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009d5:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009da:	83 e8 80             	sub    $0xffffff80,%eax
801009dd:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009e3:	0f 85 56 ff ff ff    	jne    8010093f <consoleintr+0x3f>
          wakeup(&input.r);
801009e9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801009ec:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
801009f1:	68 00 ef 10 80       	push   $0x8010ef00
801009f6:	e8 15 39 00 00       	call   80104310 <wakeup>
801009fb:	83 c4 10             	add    $0x10,%esp
801009fe:	e9 3c ff ff ff       	jmp    8010093f <consoleintr+0x3f>
80100a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a07:	90                   	nop
      while(input.e != input.w &&
80100a08:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a0d:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a13:	0f 84 26 ff ff ff    	je     8010093f <consoleintr+0x3f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a19:	83 e8 01             	sub    $0x1,%eax
80100a1c:	89 c2                	mov    %eax,%edx
80100a1e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a21:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100a28:	0f 84 11 ff ff ff    	je     8010093f <consoleintr+0x3f>
  if(panicked){
80100a2e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100a34:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a39:	85 d2                	test   %edx,%edx
80100a3b:	74 2b                	je     80100a68 <consoleintr+0x168>
80100a3d:	fa                   	cli    
    for(;;)
80100a3e:	eb fe                	jmp    80100a3e <consoleintr+0x13e>
      if(input.e != input.w){
80100a40:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a45:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a4b:	0f 84 ee fe ff ff    	je     8010093f <consoleintr+0x3f>
        input.e--;
80100a51:	83 e8 01             	sub    $0x1,%eax
80100a54:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a59:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100a5e:	85 c0                	test   %eax,%eax
80100a60:	74 7e                	je     80100ae0 <consoleintr+0x1e0>
80100a62:	fa                   	cli    
    for(;;)
80100a63:	eb fe                	jmp    80100a63 <consoleintr+0x163>
80100a65:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100a68:	83 ec 0c             	sub    $0xc,%esp
80100a6b:	6a 08                	push   $0x8
80100a6d:	e8 3e 56 00 00       	call   801060b0 <uartputc>
80100a72:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a79:	e8 32 56 00 00       	call   801060b0 <uartputc>
80100a7e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a85:	e8 26 56 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
80100a8a:	b8 00 01 00 00       	mov    $0x100,%eax
80100a8f:	e8 7c f9 ff ff       	call   80100410 <cgaputc>
      while(input.e != input.w &&
80100a94:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a99:	83 c4 10             	add    $0x10,%esp
80100a9c:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100aa2:	0f 85 71 ff ff ff    	jne    80100a19 <consoleintr+0x119>
80100aa8:	e9 92 fe ff ff       	jmp    8010093f <consoleintr+0x3f>
80100aad:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100ab0:	83 ec 0c             	sub    $0xc,%esp
80100ab3:	68 20 ef 10 80       	push   $0x8010ef20
80100ab8:	e8 43 3d 00 00       	call   80104800 <release>
  if(doprocdump) {
80100abd:	83 c4 10             	add    $0x10,%esp
80100ac0:	85 db                	test   %ebx,%ebx
80100ac2:	75 50                	jne    80100b14 <consoleintr+0x214>
}
80100ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ac7:	5b                   	pop    %ebx
80100ac8:	5e                   	pop    %esi
80100ac9:	5f                   	pop    %edi
80100aca:	5d                   	pop    %ebp
80100acb:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100acc:	85 c0                	test   %eax,%eax
80100ace:	0f 84 6b fe ff ff    	je     8010093f <consoleintr+0x3f>
80100ad4:	e9 84 fe ff ff       	jmp    8010095d <consoleintr+0x5d>
80100ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ae0:	83 ec 0c             	sub    $0xc,%esp
80100ae3:	6a 08                	push   $0x8
80100ae5:	e8 c6 55 00 00       	call   801060b0 <uartputc>
80100aea:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100af1:	e8 ba 55 00 00       	call   801060b0 <uartputc>
80100af6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100afd:	e8 ae 55 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
80100b02:	b8 00 01 00 00       	mov    $0x100,%eax
80100b07:	e8 04 f9 ff ff       	call   80100410 <cgaputc>
}
80100b0c:	83 c4 10             	add    $0x10,%esp
80100b0f:	e9 2b fe ff ff       	jmp    8010093f <consoleintr+0x3f>
}
80100b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b17:	5b                   	pop    %ebx
80100b18:	5e                   	pop    %esi
80100b19:	5f                   	pop    %edi
80100b1a:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b1b:	e9 e0 38 00 00       	jmp    80104400 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b20:	c6 81 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ecx)
  if(panicked){
80100b27:	85 ff                	test   %edi,%edi
80100b29:	74 05                	je     80100b30 <consoleintr+0x230>
80100b2b:	fa                   	cli    
    for(;;)
80100b2c:	eb fe                	jmp    80100b2c <consoleintr+0x22c>
80100b2e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100b30:	83 ec 0c             	sub    $0xc,%esp
80100b33:	6a 0a                	push   $0xa
80100b35:	e8 76 55 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
80100b3a:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b3f:	e8 cc f8 ff ff       	call   80100410 <cgaputc>
          input.w = input.e;
80100b44:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b49:	83 c4 10             	add    $0x10,%esp
80100b4c:	e9 98 fe ff ff       	jmp    801009e9 <consoleintr+0xe9>
    uartputc(c);
80100b51:	83 ec 0c             	sub    $0xc,%esp
80100b54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b57:	50                   	push   %eax
80100b58:	e8 53 55 00 00       	call   801060b0 <uartputc>
  cgaputc(c);
80100b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b60:	e8 ab f8 ff ff       	call   80100410 <cgaputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	83 f8 0a             	cmp    $0xa,%eax
80100b6e:	74 09                	je     80100b79 <consoleintr+0x279>
80100b70:	83 f8 04             	cmp    $0x4,%eax
80100b73:	0f 85 5c fe ff ff    	jne    801009d5 <consoleintr+0xd5>
          input.w = input.e;
80100b79:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b7e:	e9 66 fe ff ff       	jmp    801009e9 <consoleintr+0xe9>
80100b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b90 <consoleinit>:

void
consoleinit(void)
{
80100b90:	f3 0f 1e fb          	endbr32 
80100b94:	55                   	push   %ebp
80100b95:	89 e5                	mov    %esp,%ebp
80100b97:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b9a:	68 08 76 10 80       	push   $0x80107608
80100b9f:	68 20 ef 10 80       	push   $0x8010ef20
80100ba4:	e8 c7 3a 00 00       	call   80104670 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ba9:	58                   	pop    %eax
80100baa:	5a                   	pop    %edx
80100bab:	6a 00                	push   $0x0
80100bad:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100baf:	c7 05 0c f9 10 80 50 	movl   $0x80100550,0x8010f90c
80100bb6:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100bb9:	c7 05 08 f9 10 80 90 	movl   $0x80100290,0x8010f908
80100bc0:	02 10 80 
  cons.locking = 1;
80100bc3:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100bca:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100bcd:	e8 3e 1a 00 00       	call   80102610 <ioapicenable>
}
80100bd2:	83 c4 10             	add    $0x10,%esp
80100bd5:	c9                   	leave  
80100bd6:	c3                   	ret    
80100bd7:	66 90                	xchg   %ax,%ax
80100bd9:	66 90                	xchg   %ax,%ax
80100bdb:	66 90                	xchg   %ax,%ax
80100bdd:	66 90                	xchg   %ax,%ax
80100bdf:	90                   	nop

80100be0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100be0:	f3 0f 1e fb          	endbr32 
80100be4:	55                   	push   %ebp
80100be5:	89 e5                	mov    %esp,%ebp
80100be7:	57                   	push   %edi
80100be8:	56                   	push   %esi
80100be9:	53                   	push   %ebx
80100bea:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bf0:	e8 7b 2f 00 00       	call   80103b70 <myproc>
80100bf5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100bfb:	e8 10 23 00 00       	call   80102f10 <begin_op>

  if((ip = namei(path)) == 0){
80100c00:	83 ec 0c             	sub    $0xc,%esp
80100c03:	ff 75 08             	pushl  0x8(%ebp)
80100c06:	e8 05 16 00 00       	call   80102210 <namei>
80100c0b:	83 c4 10             	add    $0x10,%esp
80100c0e:	85 c0                	test   %eax,%eax
80100c10:	0f 84 fe 02 00 00    	je     80100f14 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c16:	83 ec 0c             	sub    $0xc,%esp
80100c19:	89 c3                	mov    %eax,%ebx
80100c1b:	50                   	push   %eax
80100c1c:	e8 af 0c 00 00       	call   801018d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c21:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c27:	6a 34                	push   $0x34
80100c29:	6a 00                	push   $0x0
80100c2b:	50                   	push   %eax
80100c2c:	53                   	push   %ebx
80100c2d:	e8 be 0f 00 00       	call   80101bf0 <readi>
80100c32:	83 c4 20             	add    $0x20,%esp
80100c35:	83 f8 34             	cmp    $0x34,%eax
80100c38:	74 26                	je     80100c60 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c3a:	83 ec 0c             	sub    $0xc,%esp
80100c3d:	53                   	push   %ebx
80100c3e:	e8 1d 0f 00 00       	call   80101b60 <iunlockput>
    end_op();
80100c43:	e8 38 23 00 00       	call   80102f80 <end_op>
80100c48:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c53:	5b                   	pop    %ebx
80100c54:	5e                   	pop    %esi
80100c55:	5f                   	pop    %edi
80100c56:	5d                   	pop    %ebp
80100c57:	c3                   	ret    
80100c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c5f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100c60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c67:	45 4c 46 
80100c6a:	75 ce                	jne    80100c3a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100c6c:	e8 df 65 00 00       	call   80107250 <setupkvm>
80100c71:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c77:	85 c0                	test   %eax,%eax
80100c79:	74 bf                	je     80100c3a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c7b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c82:	00 
80100c83:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c89:	0f 84 a4 02 00 00    	je     80100f33 <exec+0x353>
  sz = 0;
80100c8f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c96:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c99:	31 ff                	xor    %edi,%edi
80100c9b:	e9 86 00 00 00       	jmp    80100d26 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100ca0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ca7:	75 6c                	jne    80100d15 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100ca9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100caf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100cb5:	0f 82 87 00 00 00    	jb     80100d42 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cbb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cc1:	72 7f                	jb     80100d42 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cc3:	83 ec 04             	sub    $0x4,%esp
80100cc6:	50                   	push   %eax
80100cc7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ccd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cd3:	e8 98 63 00 00       	call   80107070 <allocuvm>
80100cd8:	83 c4 10             	add    $0x10,%esp
80100cdb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ce1:	85 c0                	test   %eax,%eax
80100ce3:	74 5d                	je     80100d42 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100ce5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ceb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100cf0:	75 50                	jne    80100d42 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cf2:	83 ec 0c             	sub    $0xc,%esp
80100cf5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100cfb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100d01:	53                   	push   %ebx
80100d02:	50                   	push   %eax
80100d03:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d09:	e8 72 62 00 00       	call   80106f80 <loaduvm>
80100d0e:	83 c4 20             	add    $0x20,%esp
80100d11:	85 c0                	test   %eax,%eax
80100d13:	78 2d                	js     80100d42 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d15:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d1c:	83 c7 01             	add    $0x1,%edi
80100d1f:	83 c6 20             	add    $0x20,%esi
80100d22:	39 f8                	cmp    %edi,%eax
80100d24:	7e 3a                	jle    80100d60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d26:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d2c:	6a 20                	push   $0x20
80100d2e:	56                   	push   %esi
80100d2f:	50                   	push   %eax
80100d30:	53                   	push   %ebx
80100d31:	e8 ba 0e 00 00       	call   80101bf0 <readi>
80100d36:	83 c4 10             	add    $0x10,%esp
80100d39:	83 f8 20             	cmp    $0x20,%eax
80100d3c:	0f 84 5e ff ff ff    	je     80100ca0 <exec+0xc0>
    freevm(pgdir);
80100d42:	83 ec 0c             	sub    $0xc,%esp
80100d45:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d4b:	e8 80 64 00 00       	call   801071d0 <freevm>
  if(ip){
80100d50:	83 c4 10             	add    $0x10,%esp
80100d53:	e9 e2 fe ff ff       	jmp    80100c3a <exec+0x5a>
80100d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d5f:	90                   	nop
  sz = PGROUNDUP(sz);
80100d60:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d66:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d6c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d72:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d78:	83 ec 0c             	sub    $0xc,%esp
80100d7b:	53                   	push   %ebx
80100d7c:	e8 df 0d 00 00       	call   80101b60 <iunlockput>
  end_op();
80100d81:	e8 fa 21 00 00       	call   80102f80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d86:	83 c4 0c             	add    $0xc,%esp
80100d89:	56                   	push   %esi
80100d8a:	57                   	push   %edi
80100d8b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d91:	57                   	push   %edi
80100d92:	e8 d9 62 00 00       	call   80107070 <allocuvm>
80100d97:	83 c4 10             	add    $0x10,%esp
80100d9a:	89 c6                	mov    %eax,%esi
80100d9c:	85 c0                	test   %eax,%eax
80100d9e:	0f 84 94 00 00 00    	je     80100e38 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100da4:	83 ec 08             	sub    $0x8,%esp
80100da7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100dad:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100daf:	50                   	push   %eax
80100db0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100db1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100db3:	e8 38 65 00 00       	call   801072f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100db8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dbb:	83 c4 10             	add    $0x10,%esp
80100dbe:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100dc4:	8b 00                	mov    (%eax),%eax
80100dc6:	85 c0                	test   %eax,%eax
80100dc8:	0f 84 8b 00 00 00    	je     80100e59 <exec+0x279>
80100dce:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100dd4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100dda:	eb 23                	jmp    80100dff <exec+0x21f>
80100ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100de0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100de3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100dea:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ded:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100df3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100df6:	85 c0                	test   %eax,%eax
80100df8:	74 59                	je     80100e53 <exec+0x273>
    if(argc >= MAXARG)
80100dfa:	83 ff 20             	cmp    $0x20,%edi
80100dfd:	74 39                	je     80100e38 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dff:	83 ec 0c             	sub    $0xc,%esp
80100e02:	50                   	push   %eax
80100e03:	e8 38 3d 00 00       	call   80104b40 <strlen>
80100e08:	f7 d0                	not    %eax
80100e0a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e0c:	58                   	pop    %eax
80100e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e10:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e13:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e16:	e8 25 3d 00 00       	call   80104b40 <strlen>
80100e1b:	83 c0 01             	add    $0x1,%eax
80100e1e:	50                   	push   %eax
80100e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e22:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e25:	53                   	push   %ebx
80100e26:	56                   	push   %esi
80100e27:	e8 94 66 00 00       	call   801074c0 <copyout>
80100e2c:	83 c4 20             	add    $0x20,%esp
80100e2f:	85 c0                	test   %eax,%eax
80100e31:	79 ad                	jns    80100de0 <exec+0x200>
80100e33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e37:	90                   	nop
    freevm(pgdir);
80100e38:	83 ec 0c             	sub    $0xc,%esp
80100e3b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e41:	e8 8a 63 00 00       	call   801071d0 <freevm>
80100e46:	83 c4 10             	add    $0x10,%esp
  return -1;
80100e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e4e:	e9 fd fd ff ff       	jmp    80100c50 <exec+0x70>
80100e53:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e59:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e60:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e62:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e69:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e6d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e6f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100e72:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100e78:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e7a:	50                   	push   %eax
80100e7b:	52                   	push   %edx
80100e7c:	53                   	push   %ebx
80100e7d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100e83:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e8a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e8d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e93:	e8 28 66 00 00       	call   801074c0 <copyout>
80100e98:	83 c4 10             	add    $0x10,%esp
80100e9b:	85 c0                	test   %eax,%eax
80100e9d:	78 99                	js     80100e38 <exec+0x258>
  for(last=s=path; *s; s++)
80100e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea2:	8b 55 08             	mov    0x8(%ebp),%edx
80100ea5:	0f b6 00             	movzbl (%eax),%eax
80100ea8:	84 c0                	test   %al,%al
80100eaa:	74 13                	je     80100ebf <exec+0x2df>
80100eac:	89 d1                	mov    %edx,%ecx
80100eae:	66 90                	xchg   %ax,%ax
      last = s+1;
80100eb0:	83 c1 01             	add    $0x1,%ecx
80100eb3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100eb5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100eb8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100ebb:	84 c0                	test   %al,%al
80100ebd:	75 f1                	jne    80100eb0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ebf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100ec5:	83 ec 04             	sub    $0x4,%esp
80100ec8:	6a 10                	push   $0x10
80100eca:	89 f8                	mov    %edi,%eax
80100ecc:	52                   	push   %edx
80100ecd:	83 c0 6c             	add    $0x6c,%eax
80100ed0:	50                   	push   %eax
80100ed1:	e8 2a 3c 00 00       	call   80104b00 <safestrcpy>
  curproc->pgdir = pgdir;
80100ed6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100edc:	89 f8                	mov    %edi,%eax
80100ede:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100ee1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100ee3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ee6:	89 c1                	mov    %eax,%ecx
80100ee8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100eee:	8b 40 18             	mov    0x18(%eax),%eax
80100ef1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ef4:	8b 41 18             	mov    0x18(%ecx),%eax
80100ef7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100efa:	89 0c 24             	mov    %ecx,(%esp)
80100efd:	e8 ee 5e 00 00       	call   80106df0 <switchuvm>
  freevm(oldpgdir);
80100f02:	89 3c 24             	mov    %edi,(%esp)
80100f05:	e8 c6 62 00 00       	call   801071d0 <freevm>
  return 0;
80100f0a:	83 c4 10             	add    $0x10,%esp
80100f0d:	31 c0                	xor    %eax,%eax
80100f0f:	e9 3c fd ff ff       	jmp    80100c50 <exec+0x70>
    end_op();
80100f14:	e8 67 20 00 00       	call   80102f80 <end_op>
    cprintf("exec: fail\n");
80100f19:	83 ec 0c             	sub    $0xc,%esp
80100f1c:	68 21 76 10 80       	push   $0x80107621
80100f21:	e8 6a f7 ff ff       	call   80100690 <cprintf>
    return -1;
80100f26:	83 c4 10             	add    $0x10,%esp
80100f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f2e:	e9 1d fd ff ff       	jmp    80100c50 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f33:	31 ff                	xor    %edi,%edi
80100f35:	be 00 20 00 00       	mov    $0x2000,%esi
80100f3a:	e9 39 fe ff ff       	jmp    80100d78 <exec+0x198>
80100f3f:	90                   	nop

80100f40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f40:	f3 0f 1e fb          	endbr32 
80100f44:	55                   	push   %ebp
80100f45:	89 e5                	mov    %esp,%ebp
80100f47:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f4a:	68 2d 76 10 80       	push   $0x8010762d
80100f4f:	68 60 ef 10 80       	push   $0x8010ef60
80100f54:	e8 17 37 00 00       	call   80104670 <initlock>
}
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	c9                   	leave  
80100f5d:	c3                   	ret    
80100f5e:	66 90                	xchg   %ax,%ax

80100f60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f60:	f3 0f 1e fb          	endbr32 
80100f64:	55                   	push   %ebp
80100f65:	89 e5                	mov    %esp,%ebp
80100f67:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f68:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100f6d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f70:	68 60 ef 10 80       	push   $0x8010ef60
80100f75:	e8 f6 38 00 00       	call   80104870 <acquire>
80100f7a:	83 c4 10             	add    $0x10,%esp
80100f7d:	eb 0c                	jmp    80100f8b <filealloc+0x2b>
80100f7f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f80:	83 c3 18             	add    $0x18,%ebx
80100f83:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100f89:	74 25                	je     80100fb0 <filealloc+0x50>
    if(f->ref == 0){
80100f8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f8e:	85 c0                	test   %eax,%eax
80100f90:	75 ee                	jne    80100f80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f9c:	68 60 ef 10 80       	push   $0x8010ef60
80100fa1:	e8 5a 38 00 00       	call   80104800 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100fa6:	89 d8                	mov    %ebx,%eax
      return f;
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fae:	c9                   	leave  
80100faf:	c3                   	ret    
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fb3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fb5:	68 60 ef 10 80       	push   $0x8010ef60
80100fba:	e8 41 38 00 00       	call   80104800 <release>
}
80100fbf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fc1:	83 c4 10             	add    $0x10,%esp
}
80100fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc7:	c9                   	leave  
80100fc8:	c3                   	ret    
80100fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fd0:	f3 0f 1e fb          	endbr32 
80100fd4:	55                   	push   %ebp
80100fd5:	89 e5                	mov    %esp,%ebp
80100fd7:	53                   	push   %ebx
80100fd8:	83 ec 10             	sub    $0x10,%esp
80100fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fde:	68 60 ef 10 80       	push   $0x8010ef60
80100fe3:	e8 88 38 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100fe8:	8b 43 04             	mov    0x4(%ebx),%eax
80100feb:	83 c4 10             	add    $0x10,%esp
80100fee:	85 c0                	test   %eax,%eax
80100ff0:	7e 1a                	jle    8010100c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ff2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ff5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ff8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ffb:	68 60 ef 10 80       	push   $0x8010ef60
80101000:	e8 fb 37 00 00       	call   80104800 <release>
  return f;
}
80101005:	89 d8                	mov    %ebx,%eax
80101007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010100a:	c9                   	leave  
8010100b:	c3                   	ret    
    panic("filedup");
8010100c:	83 ec 0c             	sub    $0xc,%esp
8010100f:	68 34 76 10 80       	push   $0x80107634
80101014:	e8 77 f3 ff ff       	call   80100390 <panic>
80101019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101020 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101020:	f3 0f 1e fb          	endbr32 
80101024:	55                   	push   %ebp
80101025:	89 e5                	mov    %esp,%ebp
80101027:	57                   	push   %edi
80101028:	56                   	push   %esi
80101029:	53                   	push   %ebx
8010102a:	83 ec 28             	sub    $0x28,%esp
8010102d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101030:	68 60 ef 10 80       	push   $0x8010ef60
80101035:	e8 36 38 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
8010103a:	8b 53 04             	mov    0x4(%ebx),%edx
8010103d:	83 c4 10             	add    $0x10,%esp
80101040:	85 d2                	test   %edx,%edx
80101042:	0f 8e a1 00 00 00    	jle    801010e9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101048:	83 ea 01             	sub    $0x1,%edx
8010104b:	89 53 04             	mov    %edx,0x4(%ebx)
8010104e:	75 40                	jne    80101090 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101050:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101054:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101057:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101059:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010105f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101062:	88 45 e7             	mov    %al,-0x19(%ebp)
80101065:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101068:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
8010106d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101070:	e8 8b 37 00 00       	call   80104800 <release>

  if(ff.type == FD_PIPE)
80101075:	83 c4 10             	add    $0x10,%esp
80101078:	83 ff 01             	cmp    $0x1,%edi
8010107b:	74 53                	je     801010d0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010107d:	83 ff 02             	cmp    $0x2,%edi
80101080:	74 26                	je     801010a8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101082:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101085:	5b                   	pop    %ebx
80101086:	5e                   	pop    %esi
80101087:	5f                   	pop    %edi
80101088:	5d                   	pop    %ebp
80101089:	c3                   	ret    
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101090:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80101097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010109a:	5b                   	pop    %ebx
8010109b:	5e                   	pop    %esi
8010109c:	5f                   	pop    %edi
8010109d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010109e:	e9 5d 37 00 00       	jmp    80104800 <release>
801010a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010a7:	90                   	nop
    begin_op();
801010a8:	e8 63 1e 00 00       	call   80102f10 <begin_op>
    iput(ff.ip);
801010ad:	83 ec 0c             	sub    $0xc,%esp
801010b0:	ff 75 e0             	pushl  -0x20(%ebp)
801010b3:	e8 48 09 00 00       	call   80101a00 <iput>
    end_op();
801010b8:	83 c4 10             	add    $0x10,%esp
}
801010bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010be:	5b                   	pop    %ebx
801010bf:	5e                   	pop    %esi
801010c0:	5f                   	pop    %edi
801010c1:	5d                   	pop    %ebp
    end_op();
801010c2:	e9 b9 1e 00 00       	jmp    80102f80 <end_op>
801010c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ce:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010d0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010d4:	83 ec 08             	sub    $0x8,%esp
801010d7:	53                   	push   %ebx
801010d8:	56                   	push   %esi
801010d9:	e8 32 26 00 00       	call   80103710 <pipeclose>
801010de:	83 c4 10             	add    $0x10,%esp
}
801010e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e4:	5b                   	pop    %ebx
801010e5:	5e                   	pop    %esi
801010e6:	5f                   	pop    %edi
801010e7:	5d                   	pop    %ebp
801010e8:	c3                   	ret    
    panic("fileclose");
801010e9:	83 ec 0c             	sub    $0xc,%esp
801010ec:	68 3c 76 10 80       	push   $0x8010763c
801010f1:	e8 9a f2 ff ff       	call   80100390 <panic>
801010f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010fd:	8d 76 00             	lea    0x0(%esi),%esi

80101100 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101100:	f3 0f 1e fb          	endbr32 
80101104:	55                   	push   %ebp
80101105:	89 e5                	mov    %esp,%ebp
80101107:	53                   	push   %ebx
80101108:	83 ec 04             	sub    $0x4,%esp
8010110b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010110e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101111:	75 2d                	jne    80101140 <filestat+0x40>
    ilock(f->ip);
80101113:	83 ec 0c             	sub    $0xc,%esp
80101116:	ff 73 10             	pushl  0x10(%ebx)
80101119:	e8 b2 07 00 00       	call   801018d0 <ilock>
    stati(f->ip, st);
8010111e:	58                   	pop    %eax
8010111f:	5a                   	pop    %edx
80101120:	ff 75 0c             	pushl  0xc(%ebp)
80101123:	ff 73 10             	pushl  0x10(%ebx)
80101126:	e8 95 0a 00 00       	call   80101bc0 <stati>
    iunlock(f->ip);
8010112b:	59                   	pop    %ecx
8010112c:	ff 73 10             	pushl  0x10(%ebx)
8010112f:	e8 7c 08 00 00       	call   801019b0 <iunlock>
    return 0;
  }
  return -1;
}
80101134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101137:	83 c4 10             	add    $0x10,%esp
8010113a:	31 c0                	xor    %eax,%eax
}
8010113c:	c9                   	leave  
8010113d:	c3                   	ret    
8010113e:	66 90                	xchg   %ax,%ax
80101140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101143:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101148:	c9                   	leave  
80101149:	c3                   	ret    
8010114a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101150 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101150:	f3 0f 1e fb          	endbr32 
80101154:	55                   	push   %ebp
80101155:	89 e5                	mov    %esp,%ebp
80101157:	57                   	push   %edi
80101158:	56                   	push   %esi
80101159:	53                   	push   %ebx
8010115a:	83 ec 0c             	sub    $0xc,%esp
8010115d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101160:	8b 75 0c             	mov    0xc(%ebp),%esi
80101163:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101166:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010116a:	74 64                	je     801011d0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010116c:	8b 03                	mov    (%ebx),%eax
8010116e:	83 f8 01             	cmp    $0x1,%eax
80101171:	74 45                	je     801011b8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101173:	83 f8 02             	cmp    $0x2,%eax
80101176:	75 5f                	jne    801011d7 <fileread+0x87>
    ilock(f->ip);
80101178:	83 ec 0c             	sub    $0xc,%esp
8010117b:	ff 73 10             	pushl  0x10(%ebx)
8010117e:	e8 4d 07 00 00       	call   801018d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101183:	57                   	push   %edi
80101184:	ff 73 14             	pushl  0x14(%ebx)
80101187:	56                   	push   %esi
80101188:	ff 73 10             	pushl  0x10(%ebx)
8010118b:	e8 60 0a 00 00       	call   80101bf0 <readi>
80101190:	83 c4 20             	add    $0x20,%esp
80101193:	89 c6                	mov    %eax,%esi
80101195:	85 c0                	test   %eax,%eax
80101197:	7e 03                	jle    8010119c <fileread+0x4c>
      f->off += r;
80101199:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010119c:	83 ec 0c             	sub    $0xc,%esp
8010119f:	ff 73 10             	pushl  0x10(%ebx)
801011a2:	e8 09 08 00 00       	call   801019b0 <iunlock>
    return r;
801011a7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801011aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ad:	89 f0                	mov    %esi,%eax
801011af:	5b                   	pop    %ebx
801011b0:	5e                   	pop    %esi
801011b1:	5f                   	pop    %edi
801011b2:	5d                   	pop    %ebp
801011b3:	c3                   	ret    
801011b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801011b8:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c1:	5b                   	pop    %ebx
801011c2:	5e                   	pop    %esi
801011c3:	5f                   	pop    %edi
801011c4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011c5:	e9 e6 26 00 00       	jmp    801038b0 <piperead>
801011ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011d5:	eb d3                	jmp    801011aa <fileread+0x5a>
  panic("fileread");
801011d7:	83 ec 0c             	sub    $0xc,%esp
801011da:	68 46 76 10 80       	push   $0x80107646
801011df:	e8 ac f1 ff ff       	call   80100390 <panic>
801011e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011ef:	90                   	nop

801011f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011f0:	f3 0f 1e fb          	endbr32 
801011f4:	55                   	push   %ebp
801011f5:	89 e5                	mov    %esp,%ebp
801011f7:	57                   	push   %edi
801011f8:	56                   	push   %esi
801011f9:	53                   	push   %ebx
801011fa:	83 ec 1c             	sub    $0x1c,%esp
801011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101200:	8b 75 08             	mov    0x8(%ebp),%esi
80101203:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101206:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101209:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010120d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101210:	0f 84 c1 00 00 00    	je     801012d7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101216:	8b 06                	mov    (%esi),%eax
80101218:	83 f8 01             	cmp    $0x1,%eax
8010121b:	0f 84 c3 00 00 00    	je     801012e4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101221:	83 f8 02             	cmp    $0x2,%eax
80101224:	0f 85 cc 00 00 00    	jne    801012f6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010122a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010122d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010122f:	85 c0                	test   %eax,%eax
80101231:	7f 34                	jg     80101267 <filewrite+0x77>
80101233:	e9 98 00 00 00       	jmp    801012d0 <filewrite+0xe0>
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101240:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101243:	83 ec 0c             	sub    $0xc,%esp
80101246:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101249:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010124c:	e8 5f 07 00 00       	call   801019b0 <iunlock>
      end_op();
80101251:	e8 2a 1d 00 00       	call   80102f80 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101256:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101259:	83 c4 10             	add    $0x10,%esp
8010125c:	39 c3                	cmp    %eax,%ebx
8010125e:	75 60                	jne    801012c0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101260:	01 df                	add    %ebx,%edi
    while(i < n){
80101262:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101265:	7e 69                	jle    801012d0 <filewrite+0xe0>
      int n1 = n - i;
80101267:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010126a:	b8 00 06 00 00       	mov    $0x600,%eax
8010126f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101271:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101277:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010127a:	e8 91 1c 00 00       	call   80102f10 <begin_op>
      ilock(f->ip);
8010127f:	83 ec 0c             	sub    $0xc,%esp
80101282:	ff 76 10             	pushl  0x10(%esi)
80101285:	e8 46 06 00 00       	call   801018d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010128a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010128d:	53                   	push   %ebx
8010128e:	ff 76 14             	pushl  0x14(%esi)
80101291:	01 f8                	add    %edi,%eax
80101293:	50                   	push   %eax
80101294:	ff 76 10             	pushl  0x10(%esi)
80101297:	e8 54 0a 00 00       	call   80101cf0 <writei>
8010129c:	83 c4 20             	add    $0x20,%esp
8010129f:	85 c0                	test   %eax,%eax
801012a1:	7f 9d                	jg     80101240 <filewrite+0x50>
      iunlock(f->ip);
801012a3:	83 ec 0c             	sub    $0xc,%esp
801012a6:	ff 76 10             	pushl  0x10(%esi)
801012a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801012ac:	e8 ff 06 00 00       	call   801019b0 <iunlock>
      end_op();
801012b1:	e8 ca 1c 00 00       	call   80102f80 <end_op>
      if(r < 0)
801012b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012b9:	83 c4 10             	add    $0x10,%esp
801012bc:	85 c0                	test   %eax,%eax
801012be:	75 17                	jne    801012d7 <filewrite+0xe7>
        panic("short filewrite");
801012c0:	83 ec 0c             	sub    $0xc,%esp
801012c3:	68 4f 76 10 80       	push   $0x8010764f
801012c8:	e8 c3 f0 ff ff       	call   80100390 <panic>
801012cd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801012d0:	89 f8                	mov    %edi,%eax
801012d2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801012d5:	74 05                	je     801012dc <filewrite+0xec>
801012d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012df:	5b                   	pop    %ebx
801012e0:	5e                   	pop    %esi
801012e1:	5f                   	pop    %edi
801012e2:	5d                   	pop    %ebp
801012e3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801012e4:	8b 46 0c             	mov    0xc(%esi),%eax
801012e7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	5b                   	pop    %ebx
801012ee:	5e                   	pop    %esi
801012ef:	5f                   	pop    %edi
801012f0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012f1:	e9 ba 24 00 00       	jmp    801037b0 <pipewrite>
  panic("filewrite");
801012f6:	83 ec 0c             	sub    $0xc,%esp
801012f9:	68 55 76 10 80       	push   $0x80107655
801012fe:	e8 8d f0 ff ff       	call   80100390 <panic>
80101303:	66 90                	xchg   %ax,%ax
80101305:	66 90                	xchg   %ax,%ax
80101307:	66 90                	xchg   %ax,%ax
80101309:	66 90                	xchg   %ax,%ax
8010130b:	66 90                	xchg   %ax,%ax
8010130d:	66 90                	xchg   %ax,%ax
8010130f:	90                   	nop

80101310 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101310:	55                   	push   %ebp
80101311:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101313:	89 d0                	mov    %edx,%eax
80101315:	c1 e8 0c             	shr    $0xc,%eax
80101318:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
8010131e:	89 e5                	mov    %esp,%ebp
80101320:	56                   	push   %esi
80101321:	53                   	push   %ebx
80101322:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101324:	83 ec 08             	sub    $0x8,%esp
80101327:	50                   	push   %eax
80101328:	51                   	push   %ecx
80101329:	e8 a2 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010132e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101330:	c1 fb 03             	sar    $0x3,%ebx
80101333:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101336:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101338:	83 e1 07             	and    $0x7,%ecx
8010133b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101340:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101346:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101348:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010134d:	85 c1                	test   %eax,%ecx
8010134f:	74 23                	je     80101374 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101351:	f7 d0                	not    %eax
  log_write(bp);
80101353:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101356:	21 c8                	and    %ecx,%eax
80101358:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010135c:	56                   	push   %esi
8010135d:	e8 8e 1d 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101362:	89 34 24             	mov    %esi,(%esp)
80101365:	e8 86 ee ff ff       	call   801001f0 <brelse>
}
8010136a:	83 c4 10             	add    $0x10,%esp
8010136d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101370:	5b                   	pop    %ebx
80101371:	5e                   	pop    %esi
80101372:	5d                   	pop    %ebp
80101373:	c3                   	ret    
    panic("freeing free block");
80101374:	83 ec 0c             	sub    $0xc,%esp
80101377:	68 5f 76 10 80       	push   $0x8010765f
8010137c:	e8 0f f0 ff ff       	call   80100390 <panic>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138f:	90                   	nop

80101390 <balloc>:
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101399:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010139f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013a2:	85 c9                	test   %ecx,%ecx
801013a4:	0f 84 87 00 00 00    	je     80101431 <balloc+0xa1>
801013aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801013b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801013b4:	83 ec 08             	sub    $0x8,%esp
801013b7:	89 f0                	mov    %esi,%eax
801013b9:	c1 f8 0c             	sar    $0xc,%eax
801013bc:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801013c2:	50                   	push   %eax
801013c3:	ff 75 d8             	pushl  -0x28(%ebp)
801013c6:	e8 05 ed ff ff       	call   801000d0 <bread>
801013cb:	83 c4 10             	add    $0x10,%esp
801013ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013d1:	a1 b4 15 11 80       	mov    0x801115b4,%eax
801013d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013d9:	31 c0                	xor    %eax,%eax
801013db:	eb 2f                	jmp    8010140c <balloc+0x7c>
801013dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013e0:	89 c1                	mov    %eax,%ecx
801013e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013ea:	83 e1 07             	and    $0x7,%ecx
801013ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013ef:	89 c1                	mov    %eax,%ecx
801013f1:	c1 f9 03             	sar    $0x3,%ecx
801013f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013f9:	89 fa                	mov    %edi,%edx
801013fb:	85 df                	test   %ebx,%edi
801013fd:	74 41                	je     80101440 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013ff:	83 c0 01             	add    $0x1,%eax
80101402:	83 c6 01             	add    $0x1,%esi
80101405:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010140a:	74 05                	je     80101411 <balloc+0x81>
8010140c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010140f:	77 cf                	ja     801013e0 <balloc+0x50>
    brelse(bp);
80101411:	83 ec 0c             	sub    $0xc,%esp
80101414:	ff 75 e4             	pushl  -0x1c(%ebp)
80101417:	e8 d4 ed ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010141c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101423:	83 c4 10             	add    $0x10,%esp
80101426:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101429:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010142f:	77 80                	ja     801013b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101431:	83 ec 0c             	sub    $0xc,%esp
80101434:	68 72 76 10 80       	push   $0x80107672
80101439:	e8 52 ef ff ff       	call   80100390 <panic>
8010143e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101443:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101446:	09 da                	or     %ebx,%edx
80101448:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010144c:	57                   	push   %edi
8010144d:	e8 9e 1c 00 00       	call   801030f0 <log_write>
        brelse(bp);
80101452:	89 3c 24             	mov    %edi,(%esp)
80101455:	e8 96 ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010145a:	58                   	pop    %eax
8010145b:	5a                   	pop    %edx
8010145c:	56                   	push   %esi
8010145d:	ff 75 d8             	pushl  -0x28(%ebp)
80101460:	e8 6b ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101465:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101468:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010146a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010146d:	68 00 02 00 00       	push   $0x200
80101472:	6a 00                	push   $0x0
80101474:	50                   	push   %eax
80101475:	e8 c6 34 00 00       	call   80104940 <memset>
  log_write(bp);
8010147a:	89 1c 24             	mov    %ebx,(%esp)
8010147d:	e8 6e 1c 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101482:	89 1c 24             	mov    %ebx,(%esp)
80101485:	e8 66 ed ff ff       	call   801001f0 <brelse>
}
8010148a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010148d:	89 f0                	mov    %esi,%eax
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5f                   	pop    %edi
80101492:	5d                   	pop    %ebp
80101493:	c3                   	ret    
80101494:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop

801014a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	89 c7                	mov    %eax,%edi
801014a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801014a7:	31 f6                	xor    %esi,%esi
{
801014a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014aa:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801014af:	83 ec 28             	sub    $0x28,%esp
801014b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801014b5:	68 60 f9 10 80       	push   $0x8010f960
801014ba:	e8 b1 33 00 00       	call   80104870 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801014c2:	83 c4 10             	add    $0x10,%esp
801014c5:	eb 1b                	jmp    801014e2 <iget+0x42>
801014c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014d0:	39 3b                	cmp    %edi,(%ebx)
801014d2:	74 6c                	je     80101540 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014da:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014e0:	73 26                	jae    80101508 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014e2:	8b 43 08             	mov    0x8(%ebx),%eax
801014e5:	85 c0                	test   %eax,%eax
801014e7:	7f e7                	jg     801014d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014e9:	85 f6                	test   %esi,%esi
801014eb:	75 e7                	jne    801014d4 <iget+0x34>
801014ed:	89 d9                	mov    %ebx,%ecx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014ef:	81 c3 90 00 00 00    	add    $0x90,%ebx
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014f5:	85 c0                	test   %eax,%eax
801014f7:	75 6e                	jne    80101567 <iget+0xc7>
801014f9:	89 ce                	mov    %ecx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014fb:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101501:	72 df                	jb     801014e2 <iget+0x42>
80101503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101507:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101508:	85 f6                	test   %esi,%esi
8010150a:	74 73                	je     8010157f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010150c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010150f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101511:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101514:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010151b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101522:	68 60 f9 10 80       	push   $0x8010f960
80101527:	e8 d4 32 00 00       	call   80104800 <release>

  return ip;
8010152c:	83 c4 10             	add    $0x10,%esp
}
8010152f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101532:	89 f0                	mov    %esi,%eax
80101534:	5b                   	pop    %ebx
80101535:	5e                   	pop    %esi
80101536:	5f                   	pop    %edi
80101537:	5d                   	pop    %ebp
80101538:	c3                   	ret    
80101539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101540:	39 53 04             	cmp    %edx,0x4(%ebx)
80101543:	75 8f                	jne    801014d4 <iget+0x34>
      release(&icache.lock);
80101545:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101548:	83 c0 01             	add    $0x1,%eax
      return ip;
8010154b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010154d:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101552:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101555:	e8 a6 32 00 00       	call   80104800 <release>
      return ip;
8010155a:	83 c4 10             	add    $0x10,%esp
}
8010155d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101560:	89 f0                	mov    %esi,%eax
80101562:	5b                   	pop    %ebx
80101563:	5e                   	pop    %esi
80101564:	5f                   	pop    %edi
80101565:	5d                   	pop    %ebp
80101566:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101567:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010156d:	73 10                	jae    8010157f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010156f:	8b 43 08             	mov    0x8(%ebx),%eax
80101572:	85 c0                	test   %eax,%eax
80101574:	0f 8f 56 ff ff ff    	jg     801014d0 <iget+0x30>
8010157a:	e9 6e ff ff ff       	jmp    801014ed <iget+0x4d>
    panic("iget: no inodes");
8010157f:	83 ec 0c             	sub    $0xc,%esp
80101582:	68 88 76 10 80       	push   $0x80107688
80101587:	e8 04 ee ff ff       	call   80100390 <panic>
8010158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101590 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	89 c6                	mov    %eax,%esi
80101597:	53                   	push   %ebx
80101598:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010159b:	83 fa 0b             	cmp    $0xb,%edx
8010159e:	0f 86 8c 00 00 00    	jbe    80101630 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801015a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801015a7:	83 fb 7f             	cmp    $0x7f,%ebx
801015aa:	0f 87 a2 00 00 00    	ja     80101652 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801015b0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
      ip->addrs[bn] = addr = balloc(ip->dev);
801015b6:	8b 16                	mov    (%esi),%edx
    if((addr = ip->addrs[NDIRECT]) == 0)
801015b8:	85 c0                	test   %eax,%eax
801015ba:	74 5c                	je     80101618 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801015bc:	83 ec 08             	sub    $0x8,%esp
801015bf:	50                   	push   %eax
801015c0:	52                   	push   %edx
801015c1:	e8 0a eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801015c6:	83 c4 10             	add    $0x10,%esp
801015c9:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801015cd:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801015cf:	8b 3b                	mov    (%ebx),%edi
801015d1:	85 ff                	test   %edi,%edi
801015d3:	74 1b                	je     801015f0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801015d5:	83 ec 0c             	sub    $0xc,%esp
801015d8:	52                   	push   %edx
801015d9:	e8 12 ec ff ff       	call   801001f0 <brelse>
801015de:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015e4:	89 f8                	mov    %edi,%eax
801015e6:	5b                   	pop    %ebx
801015e7:	5e                   	pop    %esi
801015e8:	5f                   	pop    %edi
801015e9:	5d                   	pop    %ebp
801015ea:	c3                   	ret    
801015eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015ef:	90                   	nop
801015f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015f3:	8b 06                	mov    (%esi),%eax
801015f5:	e8 96 fd ff ff       	call   80101390 <balloc>
      log_write(bp);
801015fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015fd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101600:	89 03                	mov    %eax,(%ebx)
80101602:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101604:	52                   	push   %edx
80101605:	e8 e6 1a 00 00       	call   801030f0 <log_write>
8010160a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010160d:	83 c4 10             	add    $0x10,%esp
80101610:	eb c3                	jmp    801015d5 <bmap+0x45>
80101612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101618:	89 d0                	mov    %edx,%eax
8010161a:	e8 71 fd ff ff       	call   80101390 <balloc>
    bp = bread(ip->dev, addr);
8010161f:	8b 16                	mov    (%esi),%edx
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101621:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101627:	eb 93                	jmp    801015bc <bmap+0x2c>
80101629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101630:	8d 5a 14             	lea    0x14(%edx),%ebx
80101633:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101637:	85 ff                	test   %edi,%edi
80101639:	75 a6                	jne    801015e1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010163b:	8b 00                	mov    (%eax),%eax
8010163d:	e8 4e fd ff ff       	call   80101390 <balloc>
80101642:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101646:	89 c7                	mov    %eax,%edi
}
80101648:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010164b:	5b                   	pop    %ebx
8010164c:	89 f8                	mov    %edi,%eax
8010164e:	5e                   	pop    %esi
8010164f:	5f                   	pop    %edi
80101650:	5d                   	pop    %ebp
80101651:	c3                   	ret    
  panic("bmap: out of range");
80101652:	83 ec 0c             	sub    $0xc,%esp
80101655:	68 98 76 10 80       	push   $0x80107698
8010165a:	e8 31 ed ff ff       	call   80100390 <panic>
8010165f:	90                   	nop

80101660 <readsb>:
{
80101660:	f3 0f 1e fb          	endbr32 
80101664:	55                   	push   %ebp
80101665:	89 e5                	mov    %esp,%ebp
80101667:	56                   	push   %esi
80101668:	53                   	push   %ebx
80101669:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010166c:	83 ec 08             	sub    $0x8,%esp
8010166f:	6a 01                	push   $0x1
80101671:	ff 75 08             	pushl  0x8(%ebp)
80101674:	e8 57 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101679:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010167c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010167e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101681:	6a 1c                	push   $0x1c
80101683:	50                   	push   %eax
80101684:	56                   	push   %esi
80101685:	e8 56 33 00 00       	call   801049e0 <memmove>
  brelse(bp);
8010168a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101693:	5b                   	pop    %ebx
80101694:	5e                   	pop    %esi
80101695:	5d                   	pop    %ebp
  brelse(bp);
80101696:	e9 55 eb ff ff       	jmp    801001f0 <brelse>
8010169b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010169f:	90                   	nop

801016a0 <iinit>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	53                   	push   %ebx
801016a8:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801016ad:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801016b0:	68 ab 76 10 80       	push   $0x801076ab
801016b5:	68 60 f9 10 80       	push   $0x8010f960
801016ba:	e8 b1 2f 00 00       	call   80104670 <initlock>
  for(i = 0; i < NINODE; i++) {
801016bf:	83 c4 10             	add    $0x10,%esp
801016c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801016c8:	83 ec 08             	sub    $0x8,%esp
801016cb:	68 b2 76 10 80       	push   $0x801076b2
801016d0:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801016d1:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801016d7:	e8 54 2e 00 00       	call   80104530 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016dc:	83 c4 10             	add    $0x10,%esp
801016df:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801016e5:	75 e1                	jne    801016c8 <iinit+0x28>
  bp = bread(dev, 1);
801016e7:	83 ec 08             	sub    $0x8,%esp
801016ea:	6a 01                	push   $0x1
801016ec:	ff 75 08             	pushl  0x8(%ebp)
801016ef:	e8 dc e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016f4:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016f7:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016f9:	8d 40 5c             	lea    0x5c(%eax),%eax
801016fc:	6a 1c                	push   $0x1c
801016fe:	50                   	push   %eax
801016ff:	68 b4 15 11 80       	push   $0x801115b4
80101704:	e8 d7 32 00 00       	call   801049e0 <memmove>
  brelse(bp);
80101709:	89 1c 24             	mov    %ebx,(%esp)
8010170c:	e8 df ea ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101711:	ff 35 cc 15 11 80    	pushl  0x801115cc
80101717:	ff 35 c8 15 11 80    	pushl  0x801115c8
8010171d:	ff 35 c4 15 11 80    	pushl  0x801115c4
80101723:	ff 35 c0 15 11 80    	pushl  0x801115c0
80101729:	ff 35 bc 15 11 80    	pushl  0x801115bc
8010172f:	ff 35 b8 15 11 80    	pushl  0x801115b8
80101735:	ff 35 b4 15 11 80    	pushl  0x801115b4
8010173b:	68 18 77 10 80       	push   $0x80107718
80101740:	e8 4b ef ff ff       	call   80100690 <cprintf>
}
80101745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101748:	83 c4 30             	add    $0x30,%esp
8010174b:	c9                   	leave  
8010174c:	c3                   	ret    
8010174d:	8d 76 00             	lea    0x0(%esi),%esi

80101750 <ialloc>:
{
80101750:	f3 0f 1e fb          	endbr32 
80101754:	55                   	push   %ebp
80101755:	89 e5                	mov    %esp,%ebp
80101757:	57                   	push   %edi
80101758:	56                   	push   %esi
80101759:	53                   	push   %ebx
8010175a:	83 ec 1c             	sub    $0x1c,%esp
8010175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101760:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101767:	8b 75 08             	mov    0x8(%ebp),%esi
8010176a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010176d:	0f 86 8d 00 00 00    	jbe    80101800 <ialloc+0xb0>
80101773:	bf 01 00 00 00       	mov    $0x1,%edi
80101778:	eb 1d                	jmp    80101797 <ialloc+0x47>
8010177a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101780:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101783:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101786:	53                   	push   %ebx
80101787:	e8 64 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010178c:	83 c4 10             	add    $0x10,%esp
8010178f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101795:	73 69                	jae    80101800 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101797:	89 f8                	mov    %edi,%eax
80101799:	83 ec 08             	sub    $0x8,%esp
8010179c:	c1 e8 03             	shr    $0x3,%eax
8010179f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017a5:	50                   	push   %eax
801017a6:	56                   	push   %esi
801017a7:	e8 24 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801017ac:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801017af:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801017b1:	89 f8                	mov    %edi,%eax
801017b3:	83 e0 07             	and    $0x7,%eax
801017b6:	c1 e0 06             	shl    $0x6,%eax
801017b9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017c1:	75 bd                	jne    80101780 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017c3:	83 ec 04             	sub    $0x4,%esp
801017c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017c9:	6a 40                	push   $0x40
801017cb:	6a 00                	push   $0x0
801017cd:	51                   	push   %ecx
801017ce:	e8 6d 31 00 00       	call   80104940 <memset>
      dip->type = type;
801017d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017dd:	89 1c 24             	mov    %ebx,(%esp)
801017e0:	e8 0b 19 00 00       	call   801030f0 <log_write>
      brelse(bp);
801017e5:	89 1c 24             	mov    %ebx,(%esp)
801017e8:	e8 03 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017ed:	83 c4 10             	add    $0x10,%esp
}
801017f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017f3:	89 fa                	mov    %edi,%edx
}
801017f5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017f6:	89 f0                	mov    %esi,%eax
}
801017f8:	5e                   	pop    %esi
801017f9:	5f                   	pop    %edi
801017fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801017fb:	e9 a0 fc ff ff       	jmp    801014a0 <iget>
  panic("ialloc: no inodes");
80101800:	83 ec 0c             	sub    $0xc,%esp
80101803:	68 b8 76 10 80       	push   $0x801076b8
80101808:	e8 83 eb ff ff       	call   80100390 <panic>
8010180d:	8d 76 00             	lea    0x0(%esi),%esi

80101810 <iupdate>:
{
80101810:	f3 0f 1e fb          	endbr32 
80101814:	55                   	push   %ebp
80101815:	89 e5                	mov    %esp,%ebp
80101817:	56                   	push   %esi
80101818:	53                   	push   %ebx
80101819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010181c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101822:	83 ec 08             	sub    $0x8,%esp
80101825:	c1 e8 03             	shr    $0x3,%eax
80101828:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010182e:	50                   	push   %eax
8010182f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101832:	e8 99 e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101837:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010183e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101840:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101843:	83 e0 07             	and    $0x7,%eax
80101846:	c1 e0 06             	shl    $0x6,%eax
80101849:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010184d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101850:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101854:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101857:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010185b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010185f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101863:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101867:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010186b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010186e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101871:	6a 34                	push   $0x34
80101873:	53                   	push   %ebx
80101874:	50                   	push   %eax
80101875:	e8 66 31 00 00       	call   801049e0 <memmove>
  log_write(bp);
8010187a:	89 34 24             	mov    %esi,(%esp)
8010187d:	e8 6e 18 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101882:	89 75 08             	mov    %esi,0x8(%ebp)
80101885:	83 c4 10             	add    $0x10,%esp
}
80101888:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188b:	5b                   	pop    %ebx
8010188c:	5e                   	pop    %esi
8010188d:	5d                   	pop    %ebp
  brelse(bp);
8010188e:	e9 5d e9 ff ff       	jmp    801001f0 <brelse>
80101893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801018a0 <idup>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	53                   	push   %ebx
801018a8:	83 ec 10             	sub    $0x10,%esp
801018ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801018ae:	68 60 f9 10 80       	push   $0x8010f960
801018b3:	e8 b8 2f 00 00       	call   80104870 <acquire>
  ip->ref++;
801018b8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018bc:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018c3:	e8 38 2f 00 00       	call   80104800 <release>
}
801018c8:	89 d8                	mov    %ebx,%eax
801018ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018cd:	c9                   	leave  
801018ce:	c3                   	ret    
801018cf:	90                   	nop

801018d0 <ilock>:
{
801018d0:	f3 0f 1e fb          	endbr32 
801018d4:	55                   	push   %ebp
801018d5:	89 e5                	mov    %esp,%ebp
801018d7:	56                   	push   %esi
801018d8:	53                   	push   %ebx
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018dc:	85 db                	test   %ebx,%ebx
801018de:	0f 84 b3 00 00 00    	je     80101997 <ilock+0xc7>
801018e4:	8b 53 08             	mov    0x8(%ebx),%edx
801018e7:	85 d2                	test   %edx,%edx
801018e9:	0f 8e a8 00 00 00    	jle    80101997 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018ef:	83 ec 0c             	sub    $0xc,%esp
801018f2:	8d 43 0c             	lea    0xc(%ebx),%eax
801018f5:	50                   	push   %eax
801018f6:	e8 75 2c 00 00       	call   80104570 <acquiresleep>
  if(ip->valid == 0){
801018fb:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018fe:	83 c4 10             	add    $0x10,%esp
80101901:	85 c0                	test   %eax,%eax
80101903:	74 0b                	je     80101910 <ilock+0x40>
}
80101905:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101908:	5b                   	pop    %ebx
80101909:	5e                   	pop    %esi
8010190a:	5d                   	pop    %ebp
8010190b:	c3                   	ret    
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101910:	8b 43 04             	mov    0x4(%ebx),%eax
80101913:	83 ec 08             	sub    $0x8,%esp
80101916:	c1 e8 03             	shr    $0x3,%eax
80101919:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010191f:	50                   	push   %eax
80101920:	ff 33                	pushl  (%ebx)
80101922:	e8 a9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101927:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010192a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010192c:	8b 43 04             	mov    0x4(%ebx),%eax
8010192f:	83 e0 07             	and    $0x7,%eax
80101932:	c1 e0 06             	shl    $0x6,%eax
80101935:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101939:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010193c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010193f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101943:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101947:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010194b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010194f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101953:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101957:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010195b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010195e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101961:	6a 34                	push   $0x34
80101963:	50                   	push   %eax
80101964:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101967:	50                   	push   %eax
80101968:	e8 73 30 00 00       	call   801049e0 <memmove>
    brelse(bp);
8010196d:	89 34 24             	mov    %esi,(%esp)
80101970:	e8 7b e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101975:	83 c4 10             	add    $0x10,%esp
80101978:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010197d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101984:	0f 85 7b ff ff ff    	jne    80101905 <ilock+0x35>
      panic("ilock: no type");
8010198a:	83 ec 0c             	sub    $0xc,%esp
8010198d:	68 d0 76 10 80       	push   $0x801076d0
80101992:	e8 f9 e9 ff ff       	call   80100390 <panic>
    panic("ilock");
80101997:	83 ec 0c             	sub    $0xc,%esp
8010199a:	68 ca 76 10 80       	push   $0x801076ca
8010199f:	e8 ec e9 ff ff       	call   80100390 <panic>
801019a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop

801019b0 <iunlock>:
{
801019b0:	f3 0f 1e fb          	endbr32 
801019b4:	55                   	push   %ebp
801019b5:	89 e5                	mov    %esp,%ebp
801019b7:	56                   	push   %esi
801019b8:	53                   	push   %ebx
801019b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019bc:	85 db                	test   %ebx,%ebx
801019be:	74 28                	je     801019e8 <iunlock+0x38>
801019c0:	83 ec 0c             	sub    $0xc,%esp
801019c3:	8d 73 0c             	lea    0xc(%ebx),%esi
801019c6:	56                   	push   %esi
801019c7:	e8 44 2c 00 00       	call   80104610 <holdingsleep>
801019cc:	83 c4 10             	add    $0x10,%esp
801019cf:	85 c0                	test   %eax,%eax
801019d1:	74 15                	je     801019e8 <iunlock+0x38>
801019d3:	8b 43 08             	mov    0x8(%ebx),%eax
801019d6:	85 c0                	test   %eax,%eax
801019d8:	7e 0e                	jle    801019e8 <iunlock+0x38>
  releasesleep(&ip->lock);
801019da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019e0:	5b                   	pop    %ebx
801019e1:	5e                   	pop    %esi
801019e2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019e3:	e9 e8 2b 00 00       	jmp    801045d0 <releasesleep>
    panic("iunlock");
801019e8:	83 ec 0c             	sub    $0xc,%esp
801019eb:	68 df 76 10 80       	push   $0x801076df
801019f0:	e8 9b e9 ff ff       	call   80100390 <panic>
801019f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a00 <iput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	57                   	push   %edi
80101a08:	56                   	push   %esi
80101a09:	53                   	push   %ebx
80101a0a:	83 ec 28             	sub    $0x28,%esp
80101a0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a10:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a13:	57                   	push   %edi
80101a14:	e8 57 2b 00 00       	call   80104570 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a19:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a1c:	83 c4 10             	add    $0x10,%esp
80101a1f:	85 d2                	test   %edx,%edx
80101a21:	74 07                	je     80101a2a <iput+0x2a>
80101a23:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a28:	74 36                	je     80101a60 <iput+0x60>
  releasesleep(&ip->lock);
80101a2a:	83 ec 0c             	sub    $0xc,%esp
80101a2d:	57                   	push   %edi
80101a2e:	e8 9d 2b 00 00       	call   801045d0 <releasesleep>
  acquire(&icache.lock);
80101a33:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a3a:	e8 31 2e 00 00       	call   80104870 <acquire>
  ip->ref--;
80101a3f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a43:	83 c4 10             	add    $0x10,%esp
80101a46:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a50:	5b                   	pop    %ebx
80101a51:	5e                   	pop    %esi
80101a52:	5f                   	pop    %edi
80101a53:	5d                   	pop    %ebp
  release(&icache.lock);
80101a54:	e9 a7 2d 00 00       	jmp    80104800 <release>
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 60 f9 10 80       	push   $0x8010f960
80101a68:	e8 03 2e 00 00       	call   80104870 <acquire>
    int r = ip->ref;
80101a6d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a70:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a77:	e8 84 2d 00 00       	call   80104800 <release>
    if(r == 1){
80101a7c:	83 c4 10             	add    $0x10,%esp
80101a7f:	83 fe 01             	cmp    $0x1,%esi
80101a82:	75 a6                	jne    80101a2a <iput+0x2a>
80101a84:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a8a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a8d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a90:	89 cf                	mov    %ecx,%edi
80101a92:	eb 0b                	jmp    80101a9f <iput+0x9f>
80101a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a98:	83 c6 04             	add    $0x4,%esi
80101a9b:	39 fe                	cmp    %edi,%esi
80101a9d:	74 19                	je     80101ab8 <iput+0xb8>
    if(ip->addrs[i]){
80101a9f:	8b 16                	mov    (%esi),%edx
80101aa1:	85 d2                	test   %edx,%edx
80101aa3:	74 f3                	je     80101a98 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101aa5:	8b 03                	mov    (%ebx),%eax
80101aa7:	e8 64 f8 ff ff       	call   80101310 <bfree>
      ip->addrs[i] = 0;
80101aac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101ab2:	eb e4                	jmp    80101a98 <iput+0x98>
80101ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101ab8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101abe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ac1:	85 c0                	test   %eax,%eax
80101ac3:	75 2d                	jne    80101af2 <iput+0xf2>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101ac5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ac8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101acf:	53                   	push   %ebx
80101ad0:	e8 3b fd ff ff       	call   80101810 <iupdate>
      ip->type = 0;
80101ad5:	31 c0                	xor    %eax,%eax
80101ad7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101adb:	89 1c 24             	mov    %ebx,(%esp)
80101ade:	e8 2d fd ff ff       	call   80101810 <iupdate>
      ip->valid = 0;
80101ae3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101aea:	83 c4 10             	add    $0x10,%esp
80101aed:	e9 38 ff ff ff       	jmp    80101a2a <iput+0x2a>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101af2:	83 ec 08             	sub    $0x8,%esp
80101af5:	50                   	push   %eax
80101af6:	ff 33                	pushl  (%ebx)
80101af8:	e8 d3 e5 ff ff       	call   801000d0 <bread>
80101afd:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b00:	83 c4 10             	add    $0x10,%esp
80101b03:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101b0c:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b0f:	89 cf                	mov    %ecx,%edi
80101b11:	eb 0c                	jmp    80101b1f <iput+0x11f>
80101b13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b17:	90                   	nop
80101b18:	83 c6 04             	add    $0x4,%esi
80101b1b:	39 f7                	cmp    %esi,%edi
80101b1d:	74 0f                	je     80101b2e <iput+0x12e>
      if(a[j])
80101b1f:	8b 16                	mov    (%esi),%edx
80101b21:	85 d2                	test   %edx,%edx
80101b23:	74 f3                	je     80101b18 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b25:	8b 03                	mov    (%ebx),%eax
80101b27:	e8 e4 f7 ff ff       	call   80101310 <bfree>
80101b2c:	eb ea                	jmp    80101b18 <iput+0x118>
    brelse(bp);
80101b2e:	83 ec 0c             	sub    $0xc,%esp
80101b31:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b34:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b37:	e8 b4 e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b3c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b42:	8b 03                	mov    (%ebx),%eax
80101b44:	e8 c7 f7 ff ff       	call   80101310 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b49:	83 c4 10             	add    $0x10,%esp
80101b4c:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b53:	00 00 00 
80101b56:	e9 6a ff ff ff       	jmp    80101ac5 <iput+0xc5>
80101b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <iunlockput>:
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	56                   	push   %esi
80101b68:	53                   	push   %ebx
80101b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b6c:	85 db                	test   %ebx,%ebx
80101b6e:	74 34                	je     80101ba4 <iunlockput+0x44>
80101b70:	83 ec 0c             	sub    $0xc,%esp
80101b73:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b76:	56                   	push   %esi
80101b77:	e8 94 2a 00 00       	call   80104610 <holdingsleep>
80101b7c:	83 c4 10             	add    $0x10,%esp
80101b7f:	85 c0                	test   %eax,%eax
80101b81:	74 21                	je     80101ba4 <iunlockput+0x44>
80101b83:	8b 43 08             	mov    0x8(%ebx),%eax
80101b86:	85 c0                	test   %eax,%eax
80101b88:	7e 1a                	jle    80101ba4 <iunlockput+0x44>
  releasesleep(&ip->lock);
80101b8a:	83 ec 0c             	sub    $0xc,%esp
80101b8d:	56                   	push   %esi
80101b8e:	e8 3d 2a 00 00       	call   801045d0 <releasesleep>
  iput(ip);
80101b93:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b96:	83 c4 10             	add    $0x10,%esp
}
80101b99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b9c:	5b                   	pop    %ebx
80101b9d:	5e                   	pop    %esi
80101b9e:	5d                   	pop    %ebp
  iput(ip);
80101b9f:	e9 5c fe ff ff       	jmp    80101a00 <iput>
    panic("iunlock");
80101ba4:	83 ec 0c             	sub    $0xc,%esp
80101ba7:	68 df 76 10 80       	push   $0x801076df
80101bac:	e8 df e7 ff ff       	call   80100390 <panic>
80101bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bbf:	90                   	nop

80101bc0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101bc0:	f3 0f 1e fb          	endbr32 
80101bc4:	55                   	push   %ebp
80101bc5:	89 e5                	mov    %esp,%ebp
80101bc7:	8b 55 08             	mov    0x8(%ebp),%edx
80101bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101bcd:	8b 0a                	mov    (%edx),%ecx
80101bcf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101bd2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101bd5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101bd8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101bdc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bdf:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101be3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101be7:	8b 52 58             	mov    0x58(%edx),%edx
80101bea:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bed:	5d                   	pop    %ebp
80101bee:	c3                   	ret    
80101bef:	90                   	nop

80101bf0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bf0:	f3 0f 1e fb          	endbr32 
80101bf4:	55                   	push   %ebp
80101bf5:	89 e5                	mov    %esp,%ebp
80101bf7:	57                   	push   %edi
80101bf8:	56                   	push   %esi
80101bf9:	53                   	push   %ebx
80101bfa:	83 ec 1c             	sub    $0x1c,%esp
80101bfd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c00:	8b 45 08             	mov    0x8(%ebp),%eax
80101c03:	8b 75 10             	mov    0x10(%ebp),%esi
80101c06:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c09:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c0c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c11:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c14:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c17:	0f 84 a3 00 00 00    	je     80101cc0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c20:	8b 40 58             	mov    0x58(%eax),%eax
80101c23:	39 c6                	cmp    %eax,%esi
80101c25:	0f 87 b6 00 00 00    	ja     80101ce1 <readi+0xf1>
80101c2b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c2e:	31 c9                	xor    %ecx,%ecx
80101c30:	89 da                	mov    %ebx,%edx
80101c32:	01 f2                	add    %esi,%edx
80101c34:	0f 92 c1             	setb   %cl
80101c37:	89 cf                	mov    %ecx,%edi
80101c39:	0f 82 a2 00 00 00    	jb     80101ce1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c3f:	89 c1                	mov    %eax,%ecx
80101c41:	29 f1                	sub    %esi,%ecx
80101c43:	39 d0                	cmp    %edx,%eax
80101c45:	0f 43 cb             	cmovae %ebx,%ecx
80101c48:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c4b:	85 c9                	test   %ecx,%ecx
80101c4d:	74 63                	je     80101cb2 <readi+0xc2>
80101c4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c53:	89 f2                	mov    %esi,%edx
80101c55:	c1 ea 09             	shr    $0x9,%edx
80101c58:	89 d8                	mov    %ebx,%eax
80101c5a:	e8 31 f9 ff ff       	call   80101590 <bmap>
80101c5f:	83 ec 08             	sub    $0x8,%esp
80101c62:	50                   	push   %eax
80101c63:	ff 33                	pushl  (%ebx)
80101c65:	e8 66 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c6d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c72:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c75:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	89 f0                	mov    %esi,%eax
80101c79:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c7e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c80:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c83:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c85:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c89:	39 d9                	cmp    %ebx,%ecx
80101c8b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c8f:	01 df                	add    %ebx,%edi
80101c91:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c93:	50                   	push   %eax
80101c94:	ff 75 e0             	pushl  -0x20(%ebp)
80101c97:	e8 44 2d 00 00       	call   801049e0 <memmove>
    brelse(bp);
80101c9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c9f:	89 14 24             	mov    %edx,(%esp)
80101ca2:	e8 49 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ca7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101caa:	83 c4 10             	add    $0x10,%esp
80101cad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101cb0:	77 9e                	ja     80101c50 <readi+0x60>
  }
  return n;
80101cb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cb8:	5b                   	pop    %ebx
80101cb9:	5e                   	pop    %esi
80101cba:	5f                   	pop    %edi
80101cbb:	5d                   	pop    %ebp
80101cbc:	c3                   	ret    
80101cbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101cc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cc4:	66 83 f8 09          	cmp    $0x9,%ax
80101cc8:	77 17                	ja     80101ce1 <readi+0xf1>
80101cca:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101cd1:	85 c0                	test   %eax,%eax
80101cd3:	74 0c                	je     80101ce1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101cd5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cdb:	5b                   	pop    %ebx
80101cdc:	5e                   	pop    %esi
80101cdd:	5f                   	pop    %edi
80101cde:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101cdf:	ff e0                	jmp    *%eax
      return -1;
80101ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ce6:	eb cd                	jmp    80101cb5 <readi+0xc5>
80101ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cef:	90                   	nop

80101cf0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cf0:	f3 0f 1e fb          	endbr32 
80101cf4:	55                   	push   %ebp
80101cf5:	89 e5                	mov    %esp,%ebp
80101cf7:	57                   	push   %edi
80101cf8:	56                   	push   %esi
80101cf9:	53                   	push   %ebx
80101cfa:	83 ec 1c             	sub    $0x1c,%esp
80101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101d00:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d03:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d06:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d0b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d11:	8b 75 10             	mov    0x10(%ebp),%esi
80101d14:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d17:	0f 84 bb 00 00 00    	je     80101dd8 <writei+0xe8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d20:	3b 70 58             	cmp    0x58(%eax),%esi
80101d23:	0f 87 eb 00 00 00    	ja     80101e14 <writei+0x124>
80101d29:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d2c:	31 d2                	xor    %edx,%edx
80101d2e:	89 f8                	mov    %edi,%eax
80101d30:	01 f0                	add    %esi,%eax
80101d32:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d35:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d3a:	0f 87 d4 00 00 00    	ja     80101e14 <writei+0x124>
80101d40:	85 d2                	test   %edx,%edx
80101d42:	0f 85 cc 00 00 00    	jne    80101e14 <writei+0x124>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d4f:	85 ff                	test   %edi,%edi
80101d51:	74 76                	je     80101dc9 <writei+0xd9>
80101d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d57:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d58:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d5b:	89 f2                	mov    %esi,%edx
80101d5d:	c1 ea 09             	shr    $0x9,%edx
80101d60:	89 f8                	mov    %edi,%eax
80101d62:	e8 29 f8 ff ff       	call   80101590 <bmap>
80101d67:	83 ec 08             	sub    $0x8,%esp
80101d6a:	50                   	push   %eax
80101d6b:	ff 37                	pushl  (%edi)
80101d6d:	e8 5e e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d72:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d77:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d7a:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d7d:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d7f:	89 f0                	mov    %esi,%eax
80101d81:	83 c4 0c             	add    $0xc,%esp
80101d84:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d89:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d8b:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d8f:	39 d9                	cmp    %ebx,%ecx
80101d91:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d94:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d95:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d97:	ff 75 dc             	pushl  -0x24(%ebp)
80101d9a:	50                   	push   %eax
80101d9b:	e8 40 2c 00 00       	call   801049e0 <memmove>
    log_write(bp);
80101da0:	89 3c 24             	mov    %edi,(%esp)
80101da3:	e8 48 13 00 00       	call   801030f0 <log_write>
    brelse(bp);
80101da8:	89 3c 24             	mov    %edi,(%esp)
80101dab:	e8 40 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101db0:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101db3:	83 c4 10             	add    $0x10,%esp
80101db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101db9:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101dbc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101dbf:	77 97                	ja     80101d58 <writei+0x68>
  }

  if(n > 0 && off > ip->size){
80101dc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dc4:	3b 70 58             	cmp    0x58(%eax),%esi
80101dc7:	77 37                	ja     80101e00 <writei+0x110>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101dc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dcf:	5b                   	pop    %ebx
80101dd0:	5e                   	pop    %esi
80101dd1:	5f                   	pop    %edi
80101dd2:	5d                   	pop    %ebp
80101dd3:	c3                   	ret    
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101dd8:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ddc:	66 83 f8 09          	cmp    $0x9,%ax
80101de0:	77 32                	ja     80101e14 <writei+0x124>
80101de2:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101de9:	85 c0                	test   %eax,%eax
80101deb:	74 27                	je     80101e14 <writei+0x124>
    return devsw[ip->major].write(ip, src, n);
80101ded:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df3:	5b                   	pop    %ebx
80101df4:	5e                   	pop    %esi
80101df5:	5f                   	pop    %edi
80101df6:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101df7:	ff e0                	jmp    *%eax
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e00:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e03:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e06:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e09:	50                   	push   %eax
80101e0a:	e8 01 fa ff ff       	call   80101810 <iupdate>
80101e0f:	83 c4 10             	add    $0x10,%esp
80101e12:	eb b5                	jmp    80101dc9 <writei+0xd9>
      return -1;
80101e14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e19:	eb b1                	jmp    80101dcc <writei+0xdc>
80101e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e1f:	90                   	nop

80101e20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e20:	f3 0f 1e fb          	endbr32 
80101e24:	55                   	push   %ebp
80101e25:	89 e5                	mov    %esp,%ebp
80101e27:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e2a:	6a 0e                	push   $0xe
80101e2c:	ff 75 0c             	pushl  0xc(%ebp)
80101e2f:	ff 75 08             	pushl  0x8(%ebp)
80101e32:	e8 19 2c 00 00       	call   80104a50 <strncmp>
}
80101e37:	c9                   	leave  
80101e38:	c3                   	ret    
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e40:	f3 0f 1e fb          	endbr32 
80101e44:	55                   	push   %ebp
80101e45:	89 e5                	mov    %esp,%ebp
80101e47:	57                   	push   %edi
80101e48:	56                   	push   %esi
80101e49:	53                   	push   %ebx
80101e4a:	83 ec 1c             	sub    $0x1c,%esp
80101e4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e50:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e55:	0f 85 89 00 00 00    	jne    80101ee4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5b:	8b 53 58             	mov    0x58(%ebx),%edx
80101e5e:	31 ff                	xor    %edi,%edi
80101e60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e63:	85 d2                	test   %edx,%edx
80101e65:	74 42                	je     80101ea9 <dirlookup+0x69>
80101e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e6e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e70:	6a 10                	push   $0x10
80101e72:	57                   	push   %edi
80101e73:	56                   	push   %esi
80101e74:	53                   	push   %ebx
80101e75:	e8 76 fd ff ff       	call   80101bf0 <readi>
80101e7a:	83 c4 10             	add    $0x10,%esp
80101e7d:	83 f8 10             	cmp    $0x10,%eax
80101e80:	75 55                	jne    80101ed7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101e82:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e87:	74 18                	je     80101ea1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101e89:	83 ec 04             	sub    $0x4,%esp
80101e8c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e8f:	6a 0e                	push   $0xe
80101e91:	50                   	push   %eax
80101e92:	ff 75 0c             	pushl  0xc(%ebp)
80101e95:	e8 b6 2b 00 00       	call   80104a50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e9a:	83 c4 10             	add    $0x10,%esp
80101e9d:	85 c0                	test   %eax,%eax
80101e9f:	74 17                	je     80101eb8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ea1:	83 c7 10             	add    $0x10,%edi
80101ea4:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ea7:	72 c7                	jb     80101e70 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101eac:	31 c0                	xor    %eax,%eax
}
80101eae:	5b                   	pop    %ebx
80101eaf:	5e                   	pop    %esi
80101eb0:	5f                   	pop    %edi
80101eb1:	5d                   	pop    %ebp
80101eb2:	c3                   	ret    
80101eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101eb7:	90                   	nop
      if(poff)
80101eb8:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebb:	85 c0                	test   %eax,%eax
80101ebd:	74 05                	je     80101ec4 <dirlookup+0x84>
        *poff = off;
80101ebf:	8b 45 10             	mov    0x10(%ebp),%eax
80101ec2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ec4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ec8:	8b 03                	mov    (%ebx),%eax
80101eca:	e8 d1 f5 ff ff       	call   801014a0 <iget>
}
80101ecf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed2:	5b                   	pop    %ebx
80101ed3:	5e                   	pop    %esi
80101ed4:	5f                   	pop    %edi
80101ed5:	5d                   	pop    %ebp
80101ed6:	c3                   	ret    
      panic("dirlookup read");
80101ed7:	83 ec 0c             	sub    $0xc,%esp
80101eda:	68 f9 76 10 80       	push   $0x801076f9
80101edf:	e8 ac e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101ee4:	83 ec 0c             	sub    $0xc,%esp
80101ee7:	68 e7 76 10 80       	push   $0x801076e7
80101eec:	e8 9f e4 ff ff       	call   80100390 <panic>
80101ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eff:	90                   	nop

80101f00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	89 c3                	mov    %eax,%ebx
80101f08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101f14:	0f 84 64 01 00 00    	je     8010207e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f1a:	e8 51 1c 00 00       	call   80103b70 <myproc>
  acquire(&icache.lock);
80101f1f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f22:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f25:	68 60 f9 10 80       	push   $0x8010f960
80101f2a:	e8 41 29 00 00       	call   80104870 <acquire>
  ip->ref++;
80101f2f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f33:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101f3a:	e8 c1 28 00 00       	call   80104800 <release>
80101f3f:	83 c4 10             	add    $0x10,%esp
80101f42:	eb 07                	jmp    80101f4b <namex+0x4b>
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f4b:	0f b6 03             	movzbl (%ebx),%eax
80101f4e:	3c 2f                	cmp    $0x2f,%al
80101f50:	74 f6                	je     80101f48 <namex+0x48>
  if(*path == 0)
80101f52:	84 c0                	test   %al,%al
80101f54:	0f 84 06 01 00 00    	je     80102060 <namex+0x160>
  while(*path != '/' && *path != 0)
80101f5a:	0f b6 03             	movzbl (%ebx),%eax
80101f5d:	84 c0                	test   %al,%al
80101f5f:	0f 84 10 01 00 00    	je     80102075 <namex+0x175>
80101f65:	89 df                	mov    %ebx,%edi
80101f67:	3c 2f                	cmp    $0x2f,%al
80101f69:	0f 84 06 01 00 00    	je     80102075 <namex+0x175>
80101f6f:	90                   	nop
80101f70:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f74:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f77:	3c 2f                	cmp    $0x2f,%al
80101f79:	74 04                	je     80101f7f <namex+0x7f>
80101f7b:	84 c0                	test   %al,%al
80101f7d:	75 f1                	jne    80101f70 <namex+0x70>
  len = path - s;
80101f7f:	89 f8                	mov    %edi,%eax
80101f81:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f83:	83 f8 0d             	cmp    $0xd,%eax
80101f86:	0f 8e ac 00 00 00    	jle    80102038 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f8c:	83 ec 04             	sub    $0x4,%esp
80101f8f:	6a 0e                	push   $0xe
80101f91:	53                   	push   %ebx
    path++;
80101f92:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f94:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f97:	e8 44 2a 00 00       	call   801049e0 <memmove>
80101f9c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f9f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101fa2:	75 0c                	jne    80101fb0 <namex+0xb0>
80101fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101fa8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fab:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fae:	74 f8                	je     80101fa8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101fb0:	83 ec 0c             	sub    $0xc,%esp
80101fb3:	56                   	push   %esi
80101fb4:	e8 17 f9 ff ff       	call   801018d0 <ilock>
    if(ip->type != T_DIR){
80101fb9:	83 c4 10             	add    $0x10,%esp
80101fbc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fc1:	0f 85 cd 00 00 00    	jne    80102094 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101fc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fca:	85 c0                	test   %eax,%eax
80101fcc:	74 09                	je     80101fd7 <namex+0xd7>
80101fce:	80 3b 00             	cmpb   $0x0,(%ebx)
80101fd1:	0f 84 22 01 00 00    	je     801020f9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101fd7:	83 ec 04             	sub    $0x4,%esp
80101fda:	6a 00                	push   $0x0
80101fdc:	ff 75 e4             	pushl  -0x1c(%ebp)
80101fdf:	56                   	push   %esi
80101fe0:	e8 5b fe ff ff       	call   80101e40 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fe5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	89 c7                	mov    %eax,%edi
80101fed:	85 c0                	test   %eax,%eax
80101fef:	0f 84 e1 00 00 00    	je     801020d6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ffb:	52                   	push   %edx
80101ffc:	e8 0f 26 00 00       	call   80104610 <holdingsleep>
80102001:	83 c4 10             	add    $0x10,%esp
80102004:	85 c0                	test   %eax,%eax
80102006:	0f 84 30 01 00 00    	je     8010213c <namex+0x23c>
8010200c:	8b 56 08             	mov    0x8(%esi),%edx
8010200f:	85 d2                	test   %edx,%edx
80102011:	0f 8e 25 01 00 00    	jle    8010213c <namex+0x23c>
  releasesleep(&ip->lock);
80102017:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010201a:	83 ec 0c             	sub    $0xc,%esp
8010201d:	52                   	push   %edx
8010201e:	e8 ad 25 00 00       	call   801045d0 <releasesleep>
  iput(ip);
80102023:	89 34 24             	mov    %esi,(%esp)
80102026:	89 fe                	mov    %edi,%esi
80102028:	e8 d3 f9 ff ff       	call   80101a00 <iput>
8010202d:	83 c4 10             	add    $0x10,%esp
80102030:	e9 16 ff ff ff       	jmp    80101f4b <namex+0x4b>
80102035:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102038:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010203b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010203e:	83 ec 04             	sub    $0x4,%esp
80102041:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102044:	50                   	push   %eax
80102045:	53                   	push   %ebx
    name[len] = 0;
80102046:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102048:	ff 75 e4             	pushl  -0x1c(%ebp)
8010204b:	e8 90 29 00 00       	call   801049e0 <memmove>
    name[len] = 0;
80102050:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102053:	83 c4 10             	add    $0x10,%esp
80102056:	c6 02 00             	movb   $0x0,(%edx)
80102059:	e9 41 ff ff ff       	jmp    80101f9f <namex+0x9f>
8010205e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102060:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102063:	85 c0                	test   %eax,%eax
80102065:	0f 85 be 00 00 00    	jne    80102129 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010206b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010206e:	89 f0                	mov    %esi,%eax
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102075:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102078:	89 df                	mov    %ebx,%edi
8010207a:	31 c0                	xor    %eax,%eax
8010207c:	eb c0                	jmp    8010203e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010207e:	ba 01 00 00 00       	mov    $0x1,%edx
80102083:	b8 01 00 00 00       	mov    $0x1,%eax
80102088:	e8 13 f4 ff ff       	call   801014a0 <iget>
8010208d:	89 c6                	mov    %eax,%esi
8010208f:	e9 b7 fe ff ff       	jmp    80101f4b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102094:	83 ec 0c             	sub    $0xc,%esp
80102097:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010209a:	53                   	push   %ebx
8010209b:	e8 70 25 00 00       	call   80104610 <holdingsleep>
801020a0:	83 c4 10             	add    $0x10,%esp
801020a3:	85 c0                	test   %eax,%eax
801020a5:	0f 84 91 00 00 00    	je     8010213c <namex+0x23c>
801020ab:	8b 46 08             	mov    0x8(%esi),%eax
801020ae:	85 c0                	test   %eax,%eax
801020b0:	0f 8e 86 00 00 00    	jle    8010213c <namex+0x23c>
  releasesleep(&ip->lock);
801020b6:	83 ec 0c             	sub    $0xc,%esp
801020b9:	53                   	push   %ebx
801020ba:	e8 11 25 00 00       	call   801045d0 <releasesleep>
  iput(ip);
801020bf:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020c2:	31 f6                	xor    %esi,%esi
  iput(ip);
801020c4:	e8 37 f9 ff ff       	call   80101a00 <iput>
      return 0;
801020c9:	83 c4 10             	add    $0x10,%esp
}
801020cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020cf:	89 f0                	mov    %esi,%eax
801020d1:	5b                   	pop    %ebx
801020d2:	5e                   	pop    %esi
801020d3:	5f                   	pop    %edi
801020d4:	5d                   	pop    %ebp
801020d5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020d6:	83 ec 0c             	sub    $0xc,%esp
801020d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801020dc:	52                   	push   %edx
801020dd:	e8 2e 25 00 00       	call   80104610 <holdingsleep>
801020e2:	83 c4 10             	add    $0x10,%esp
801020e5:	85 c0                	test   %eax,%eax
801020e7:	74 53                	je     8010213c <namex+0x23c>
801020e9:	8b 4e 08             	mov    0x8(%esi),%ecx
801020ec:	85 c9                	test   %ecx,%ecx
801020ee:	7e 4c                	jle    8010213c <namex+0x23c>
  releasesleep(&ip->lock);
801020f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801020f3:	83 ec 0c             	sub    $0xc,%esp
801020f6:	52                   	push   %edx
801020f7:	eb c1                	jmp    801020ba <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020f9:	83 ec 0c             	sub    $0xc,%esp
801020fc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801020ff:	53                   	push   %ebx
80102100:	e8 0b 25 00 00       	call   80104610 <holdingsleep>
80102105:	83 c4 10             	add    $0x10,%esp
80102108:	85 c0                	test   %eax,%eax
8010210a:	74 30                	je     8010213c <namex+0x23c>
8010210c:	8b 7e 08             	mov    0x8(%esi),%edi
8010210f:	85 ff                	test   %edi,%edi
80102111:	7e 29                	jle    8010213c <namex+0x23c>
  releasesleep(&ip->lock);
80102113:	83 ec 0c             	sub    $0xc,%esp
80102116:	53                   	push   %ebx
80102117:	e8 b4 24 00 00       	call   801045d0 <releasesleep>
}
8010211c:	83 c4 10             	add    $0x10,%esp
}
8010211f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102122:	89 f0                	mov    %esi,%eax
80102124:	5b                   	pop    %ebx
80102125:	5e                   	pop    %esi
80102126:	5f                   	pop    %edi
80102127:	5d                   	pop    %ebp
80102128:	c3                   	ret    
    iput(ip);
80102129:	83 ec 0c             	sub    $0xc,%esp
8010212c:	56                   	push   %esi
    return 0;
8010212d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010212f:	e8 cc f8 ff ff       	call   80101a00 <iput>
    return 0;
80102134:	83 c4 10             	add    $0x10,%esp
80102137:	e9 2f ff ff ff       	jmp    8010206b <namex+0x16b>
    panic("iunlock");
8010213c:	83 ec 0c             	sub    $0xc,%esp
8010213f:	68 df 76 10 80       	push   $0x801076df
80102144:	e8 47 e2 ff ff       	call   80100390 <panic>
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <dirlink>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	57                   	push   %edi
80102158:	56                   	push   %esi
80102159:	53                   	push   %ebx
8010215a:	83 ec 20             	sub    $0x20,%esp
8010215d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102160:	6a 00                	push   $0x0
80102162:	ff 75 0c             	pushl  0xc(%ebp)
80102165:	53                   	push   %ebx
80102166:	e8 d5 fc ff ff       	call   80101e40 <dirlookup>
8010216b:	83 c4 10             	add    $0x10,%esp
8010216e:	85 c0                	test   %eax,%eax
80102170:	75 6b                	jne    801021dd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102172:	8b 7b 58             	mov    0x58(%ebx),%edi
80102175:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102178:	85 ff                	test   %edi,%edi
8010217a:	74 2d                	je     801021a9 <dirlink+0x59>
8010217c:	31 ff                	xor    %edi,%edi
8010217e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102181:	eb 0d                	jmp    80102190 <dirlink+0x40>
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	83 c7 10             	add    $0x10,%edi
8010218b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010218e:	73 19                	jae    801021a9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102190:	6a 10                	push   $0x10
80102192:	57                   	push   %edi
80102193:	56                   	push   %esi
80102194:	53                   	push   %ebx
80102195:	e8 56 fa ff ff       	call   80101bf0 <readi>
8010219a:	83 c4 10             	add    $0x10,%esp
8010219d:	83 f8 10             	cmp    $0x10,%eax
801021a0:	75 4e                	jne    801021f0 <dirlink+0xa0>
    if(de.inum == 0)
801021a2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021a7:	75 df                	jne    80102188 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
801021a9:	83 ec 04             	sub    $0x4,%esp
801021ac:	8d 45 da             	lea    -0x26(%ebp),%eax
801021af:	6a 0e                	push   $0xe
801021b1:	ff 75 0c             	pushl  0xc(%ebp)
801021b4:	50                   	push   %eax
801021b5:	e8 e6 28 00 00       	call   80104aa0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021ba:	6a 10                	push   $0x10
  de.inum = inum;
801021bc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021bf:	57                   	push   %edi
801021c0:	56                   	push   %esi
801021c1:	53                   	push   %ebx
  de.inum = inum;
801021c2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021c6:	e8 25 fb ff ff       	call   80101cf0 <writei>
801021cb:	83 c4 20             	add    $0x20,%esp
801021ce:	83 f8 10             	cmp    $0x10,%eax
801021d1:	75 2a                	jne    801021fd <dirlink+0xad>
  return 0;
801021d3:	31 c0                	xor    %eax,%eax
}
801021d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021d8:	5b                   	pop    %ebx
801021d9:	5e                   	pop    %esi
801021da:	5f                   	pop    %edi
801021db:	5d                   	pop    %ebp
801021dc:	c3                   	ret    
    iput(ip);
801021dd:	83 ec 0c             	sub    $0xc,%esp
801021e0:	50                   	push   %eax
801021e1:	e8 1a f8 ff ff       	call   80101a00 <iput>
    return -1;
801021e6:	83 c4 10             	add    $0x10,%esp
801021e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021ee:	eb e5                	jmp    801021d5 <dirlink+0x85>
      panic("dirlink read");
801021f0:	83 ec 0c             	sub    $0xc,%esp
801021f3:	68 08 77 10 80       	push   $0x80107708
801021f8:	e8 93 e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
801021fd:	83 ec 0c             	sub    $0xc,%esp
80102200:	68 22 7d 10 80       	push   $0x80107d22
80102205:	e8 86 e1 ff ff       	call   80100390 <panic>
8010220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102210 <namei>:

struct inode*
namei(char *path)
{
80102210:	f3 0f 1e fb          	endbr32 
80102214:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102215:	31 d2                	xor    %edx,%edx
{
80102217:	89 e5                	mov    %esp,%ebp
80102219:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010221c:	8b 45 08             	mov    0x8(%ebp),%eax
8010221f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102222:	e8 d9 fc ff ff       	call   80101f00 <namex>
}
80102227:	c9                   	leave  
80102228:	c3                   	ret    
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102230:	f3 0f 1e fb          	endbr32 
80102234:	55                   	push   %ebp
  return namex(path, 1, name);
80102235:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010223a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010223c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010223f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102242:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102243:	e9 b8 fc ff ff       	jmp    80101f00 <namex>
80102248:	66 90                	xchg   %ax,%ax
8010224a:	66 90                	xchg   %ax,%ax
8010224c:	66 90                	xchg   %ax,%ax
8010224e:	66 90                	xchg   %ax,%ax

80102250 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102259:	85 c0                	test   %eax,%eax
8010225b:	0f 84 b4 00 00 00    	je     80102315 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102261:	8b 70 08             	mov    0x8(%eax),%esi
80102264:	89 c3                	mov    %eax,%ebx
80102266:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010226c:	0f 87 96 00 00 00    	ja     80102308 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	89 ca                	mov    %ecx,%edx
80102282:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102283:	83 e0 c0             	and    $0xffffffc0,%eax
80102286:	3c 40                	cmp    $0x40,%al
80102288:	75 f6                	jne    80102280 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010228a:	31 ff                	xor    %edi,%edi
8010228c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102291:	89 f8                	mov    %edi,%eax
80102293:	ee                   	out    %al,(%dx)
80102294:	b8 01 00 00 00       	mov    $0x1,%eax
80102299:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010229e:	ee                   	out    %al,(%dx)
8010229f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022a4:	89 f0                	mov    %esi,%eax
801022a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801022a7:	89 f0                	mov    %esi,%eax
801022a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022ae:	c1 f8 08             	sar    $0x8,%eax
801022b1:	ee                   	out    %al,(%dx)
801022b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022b7:	89 f8                	mov    %edi,%eax
801022b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022ba:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801022be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022c3:	c1 e0 04             	shl    $0x4,%eax
801022c6:	83 e0 10             	and    $0x10,%eax
801022c9:	83 c8 e0             	or     $0xffffffe0,%eax
801022cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801022cd:	f6 03 04             	testb  $0x4,(%ebx)
801022d0:	75 16                	jne    801022e8 <idestart+0x98>
801022d2:	b8 20 00 00 00       	mov    $0x20,%eax
801022d7:	89 ca                	mov    %ecx,%edx
801022d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801022da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022dd:	5b                   	pop    %ebx
801022de:	5e                   	pop    %esi
801022df:	5f                   	pop    %edi
801022e0:	5d                   	pop    %ebp
801022e1:	c3                   	ret    
801022e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022e8:	b8 30 00 00 00       	mov    $0x30,%eax
801022ed:	89 ca                	mov    %ecx,%edx
801022ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022f5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801022f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fd:	fc                   	cld    
801022fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102303:	5b                   	pop    %ebx
80102304:	5e                   	pop    %esi
80102305:	5f                   	pop    %edi
80102306:	5d                   	pop    %ebp
80102307:	c3                   	ret    
    panic("incorrect blockno");
80102308:	83 ec 0c             	sub    $0xc,%esp
8010230b:	68 74 77 10 80       	push   $0x80107774
80102310:	e8 7b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102315:	83 ec 0c             	sub    $0xc,%esp
80102318:	68 6b 77 10 80       	push   $0x8010776b
8010231d:	e8 6e e0 ff ff       	call   80100390 <panic>
80102322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102330 <ideinit>:
{
80102330:	f3 0f 1e fb          	endbr32 
80102334:	55                   	push   %ebp
80102335:	89 e5                	mov    %esp,%ebp
80102337:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010233a:	68 86 77 10 80       	push   $0x80107786
8010233f:	68 00 16 11 80       	push   $0x80111600
80102344:	e8 27 23 00 00       	call   80104670 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102349:	58                   	pop    %eax
8010234a:	a1 84 17 11 80       	mov    0x80111784,%eax
8010234f:	5a                   	pop    %edx
80102350:	83 e8 01             	sub    $0x1,%eax
80102353:	50                   	push   %eax
80102354:	6a 0e                	push   $0xe
80102356:	e8 b5 02 00 00       	call   80102610 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010235b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010235e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102367:	90                   	nop
80102368:	ec                   	in     (%dx),%al
80102369:	83 e0 c0             	and    $0xffffffc0,%eax
8010236c:	3c 40                	cmp    $0x40,%al
8010236e:	75 f8                	jne    80102368 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102370:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102375:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010237a:	ee                   	out    %al,(%dx)
8010237b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102380:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102385:	eb 0e                	jmp    80102395 <ideinit+0x65>
80102387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102390:	83 e9 01             	sub    $0x1,%ecx
80102393:	74 0f                	je     801023a4 <ideinit+0x74>
80102395:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102396:	84 c0                	test   %al,%al
80102398:	74 f6                	je     80102390 <ideinit+0x60>
      havedisk1 = 1;
8010239a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
801023a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023ae:	ee                   	out    %al,(%dx)
}
801023af:	c9                   	leave  
801023b0:	c3                   	ret    
801023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023bf:	90                   	nop

801023c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801023c0:	f3 0f 1e fb          	endbr32 
801023c4:	55                   	push   %ebp
801023c5:	89 e5                	mov    %esp,%ebp
801023c7:	57                   	push   %edi
801023c8:	56                   	push   %esi
801023c9:	53                   	push   %ebx
801023ca:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023cd:	68 00 16 11 80       	push   $0x80111600
801023d2:	e8 99 24 00 00       	call   80104870 <acquire>

  if((b = idequeue) == 0){
801023d7:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	85 db                	test   %ebx,%ebx
801023e2:	74 5f                	je     80102443 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801023e4:	8b 43 58             	mov    0x58(%ebx),%eax
801023e7:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801023ec:	8b 33                	mov    (%ebx),%esi
801023ee:	f7 c6 04 00 00 00    	test   $0x4,%esi
801023f4:	75 2b                	jne    80102421 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023f6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop
80102400:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102401:	89 c1                	mov    %eax,%ecx
80102403:	83 e1 c0             	and    $0xffffffc0,%ecx
80102406:	80 f9 40             	cmp    $0x40,%cl
80102409:	75 f5                	jne    80102400 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010240b:	a8 21                	test   $0x21,%al
8010240d:	75 12                	jne    80102421 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010240f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102412:	b9 80 00 00 00       	mov    $0x80,%ecx
80102417:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010241c:	fc                   	cld    
8010241d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010241f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102421:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102424:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102427:	83 ce 02             	or     $0x2,%esi
8010242a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010242c:	53                   	push   %ebx
8010242d:	e8 de 1e 00 00       	call   80104310 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102432:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102437:	83 c4 10             	add    $0x10,%esp
8010243a:	85 c0                	test   %eax,%eax
8010243c:	74 05                	je     80102443 <ideintr+0x83>
    idestart(idequeue);
8010243e:	e8 0d fe ff ff       	call   80102250 <idestart>
    release(&idelock);
80102443:	83 ec 0c             	sub    $0xc,%esp
80102446:	68 00 16 11 80       	push   $0x80111600
8010244b:	e8 b0 23 00 00       	call   80104800 <release>

  release(&idelock);
}
80102450:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102453:	5b                   	pop    %ebx
80102454:	5e                   	pop    %esi
80102455:	5f                   	pop    %edi
80102456:	5d                   	pop    %ebp
80102457:	c3                   	ret    
80102458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245f:	90                   	nop

80102460 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102460:	f3 0f 1e fb          	endbr32 
80102464:	55                   	push   %ebp
80102465:	89 e5                	mov    %esp,%ebp
80102467:	53                   	push   %ebx
80102468:	83 ec 10             	sub    $0x10,%esp
8010246b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010246e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102471:	50                   	push   %eax
80102472:	e8 99 21 00 00       	call   80104610 <holdingsleep>
80102477:	83 c4 10             	add    $0x10,%esp
8010247a:	85 c0                	test   %eax,%eax
8010247c:	0f 84 cf 00 00 00    	je     80102551 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102482:	8b 03                	mov    (%ebx),%eax
80102484:	83 e0 06             	and    $0x6,%eax
80102487:	83 f8 02             	cmp    $0x2,%eax
8010248a:	0f 84 b4 00 00 00    	je     80102544 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102490:	8b 53 04             	mov    0x4(%ebx),%edx
80102493:	85 d2                	test   %edx,%edx
80102495:	74 0d                	je     801024a4 <iderw+0x44>
80102497:	a1 e0 15 11 80       	mov    0x801115e0,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	0f 84 93 00 00 00    	je     80102537 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024a4:	83 ec 0c             	sub    $0xc,%esp
801024a7:	68 00 16 11 80       	push   $0x80111600
801024ac:	e8 bf 23 00 00       	call   80104870 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024b1:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
801024b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	85 c0                	test   %eax,%eax
801024c2:	74 6c                	je     80102530 <iderw+0xd0>
801024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c8:	89 c2                	mov    %eax,%edx
801024ca:	8b 40 58             	mov    0x58(%eax),%eax
801024cd:	85 c0                	test   %eax,%eax
801024cf:	75 f7                	jne    801024c8 <iderw+0x68>
801024d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801024d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801024d6:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801024dc:	74 42                	je     80102520 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024de:	8b 03                	mov    (%ebx),%eax
801024e0:	83 e0 06             	and    $0x6,%eax
801024e3:	83 f8 02             	cmp    $0x2,%eax
801024e6:	74 23                	je     8010250b <iderw+0xab>
801024e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ef:	90                   	nop
    sleep(b, &idelock);
801024f0:	83 ec 08             	sub    $0x8,%esp
801024f3:	68 00 16 11 80       	push   $0x80111600
801024f8:	53                   	push   %ebx
801024f9:	e8 52 1d 00 00       	call   80104250 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024fe:	8b 03                	mov    (%ebx),%eax
80102500:	83 c4 10             	add    $0x10,%esp
80102503:	83 e0 06             	and    $0x6,%eax
80102506:	83 f8 02             	cmp    $0x2,%eax
80102509:	75 e5                	jne    801024f0 <iderw+0x90>
  }


  release(&idelock);
8010250b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102515:	c9                   	leave  
  release(&idelock);
80102516:	e9 e5 22 00 00       	jmp    80104800 <release>
8010251b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010251f:	90                   	nop
    idestart(b);
80102520:	89 d8                	mov    %ebx,%eax
80102522:	e8 29 fd ff ff       	call   80102250 <idestart>
80102527:	eb b5                	jmp    801024de <iderw+0x7e>
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102530:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102535:	eb 9d                	jmp    801024d4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102537:	83 ec 0c             	sub    $0xc,%esp
8010253a:	68 b5 77 10 80       	push   $0x801077b5
8010253f:	e8 4c de ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102544:	83 ec 0c             	sub    $0xc,%esp
80102547:	68 a0 77 10 80       	push   $0x801077a0
8010254c:	e8 3f de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102551:	83 ec 0c             	sub    $0xc,%esp
80102554:	68 8a 77 10 80       	push   $0x8010778a
80102559:	e8 32 de ff ff       	call   80100390 <panic>
8010255e:	66 90                	xchg   %ax,%ax

80102560 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102565:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010256c:	00 c0 fe 
{
8010256f:	89 e5                	mov    %esp,%ebp
80102571:	56                   	push   %esi
80102572:	53                   	push   %ebx
  ioapic->reg = reg;
80102573:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010257a:	00 00 00 
  return ioapic->data;
8010257d:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80102583:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102586:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010258c:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102592:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102599:	c1 ee 10             	shr    $0x10,%esi
8010259c:	89 f0                	mov    %esi,%eax
8010259e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801025a1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801025a4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801025a7:	39 c2                	cmp    %eax,%edx
801025a9:	74 16                	je     801025c1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025ab:	83 ec 0c             	sub    $0xc,%esp
801025ae:	68 d4 77 10 80       	push   $0x801077d4
801025b3:	e8 d8 e0 ff ff       	call   80100690 <cprintf>
  ioapic->reg = reg;
801025b8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801025be:	83 c4 10             	add    $0x10,%esp
801025c1:	83 c6 21             	add    $0x21,%esi
{
801025c4:	ba 10 00 00 00       	mov    $0x10,%edx
801025c9:	b8 20 00 00 00       	mov    $0x20,%eax
801025ce:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801025d0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025d2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801025d4:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
801025da:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025dd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801025e3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801025e6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801025e9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801025ec:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801025ee:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801025f4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801025fb:	39 f0                	cmp    %esi,%eax
801025fd:	75 d1                	jne    801025d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801025ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102602:	5b                   	pop    %ebx
80102603:	5e                   	pop    %esi
80102604:	5d                   	pop    %ebp
80102605:	c3                   	ret    
80102606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260d:	8d 76 00             	lea    0x0(%esi),%esi

80102610 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102610:	f3 0f 1e fb          	endbr32 
80102614:	55                   	push   %ebp
  ioapic->reg = reg;
80102615:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
8010261b:	89 e5                	mov    %esp,%ebp
8010261d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102620:	8d 50 20             	lea    0x20(%eax),%edx
80102623:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102627:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102629:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010262f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102632:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102635:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102638:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010263a:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010263f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102642:	89 50 10             	mov    %edx,0x10(%eax)
}
80102645:	5d                   	pop    %ebp
80102646:	c3                   	ret    
80102647:	66 90                	xchg   %ax,%ax
80102649:	66 90                	xchg   %ax,%ax
8010264b:	66 90                	xchg   %ax,%ax
8010264d:	66 90                	xchg   %ax,%ax
8010264f:	90                   	nop

80102650 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102650:	f3 0f 1e fb          	endbr32 
80102654:	55                   	push   %ebp
80102655:	89 e5                	mov    %esp,%ebp
80102657:	53                   	push   %ebx
80102658:	83 ec 04             	sub    $0x4,%esp
8010265b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010265e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102664:	75 7a                	jne    801026e0 <kfree+0x90>
80102666:	81 fb f0 54 11 80    	cmp    $0x801154f0,%ebx
8010266c:	72 72                	jb     801026e0 <kfree+0x90>
8010266e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102674:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102679:	77 65                	ja     801026e0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010267b:	83 ec 04             	sub    $0x4,%esp
8010267e:	68 00 10 00 00       	push   $0x1000
80102683:	6a 01                	push   $0x1
80102685:	53                   	push   %ebx
80102686:	e8 b5 22 00 00       	call   80104940 <memset>

  if(kmem.use_lock)
8010268b:	8b 15 74 16 11 80    	mov    0x80111674,%edx
80102691:	83 c4 10             	add    $0x10,%esp
80102694:	85 d2                	test   %edx,%edx
80102696:	75 20                	jne    801026b8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102698:	a1 78 16 11 80       	mov    0x80111678,%eax
8010269d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010269f:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
801026a4:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
801026aa:	85 c0                	test   %eax,%eax
801026ac:	75 22                	jne    801026d0 <kfree+0x80>
    release(&kmem.lock);
}
801026ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b1:	c9                   	leave  
801026b2:	c3                   	ret    
801026b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026b7:	90                   	nop
    acquire(&kmem.lock);
801026b8:	83 ec 0c             	sub    $0xc,%esp
801026bb:	68 40 16 11 80       	push   $0x80111640
801026c0:	e8 ab 21 00 00       	call   80104870 <acquire>
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	eb ce                	jmp    80102698 <kfree+0x48>
801026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801026d0:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
801026d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026da:	c9                   	leave  
    release(&kmem.lock);
801026db:	e9 20 21 00 00       	jmp    80104800 <release>
    panic("kfree");
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	68 06 78 10 80       	push   $0x80107806
801026e8:	e8 a3 dc ff ff       	call   80100390 <panic>
801026ed:	8d 76 00             	lea    0x0(%esi),%esi

801026f0 <freerange>:
{
801026f0:	f3 0f 1e fb          	endbr32 
801026f4:	55                   	push   %ebp
801026f5:	89 e5                	mov    %esp,%ebp
801026f7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026f8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026fb:	8b 75 0c             	mov    0xc(%ebp),%esi
801026fe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026ff:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102705:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010270b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102711:	39 de                	cmp    %ebx,%esi
80102713:	72 1f                	jb     80102734 <freerange+0x44>
80102715:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102718:	83 ec 0c             	sub    $0xc,%esp
8010271b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102721:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102727:	50                   	push   %eax
80102728:	e8 23 ff ff ff       	call   80102650 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	39 f3                	cmp    %esi,%ebx
80102732:	76 e4                	jbe    80102718 <freerange+0x28>
}
80102734:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102737:	5b                   	pop    %ebx
80102738:	5e                   	pop    %esi
80102739:	5d                   	pop    %ebp
8010273a:	c3                   	ret    
8010273b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010273f:	90                   	nop

80102740 <kinit2>:
{
80102740:	f3 0f 1e fb          	endbr32 
80102744:	55                   	push   %ebp
80102745:	89 e5                	mov    %esp,%ebp
80102747:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102748:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010274b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010274e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010274f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102755:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010275b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102761:	39 de                	cmp    %ebx,%esi
80102763:	72 1f                	jb     80102784 <kinit2+0x44>
80102765:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102768:	83 ec 0c             	sub    $0xc,%esp
8010276b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102777:	50                   	push   %eax
80102778:	e8 d3 fe ff ff       	call   80102650 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	39 de                	cmp    %ebx,%esi
80102782:	73 e4                	jae    80102768 <kinit2+0x28>
  kmem.use_lock = 1;
80102784:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010278b:	00 00 00 
}
8010278e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102791:	5b                   	pop    %ebx
80102792:	5e                   	pop    %esi
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <kinit1>:
{
801027a0:	f3 0f 1e fb          	endbr32 
801027a4:	55                   	push   %ebp
801027a5:	89 e5                	mov    %esp,%ebp
801027a7:	56                   	push   %esi
801027a8:	53                   	push   %ebx
801027a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801027ac:	83 ec 08             	sub    $0x8,%esp
801027af:	68 0c 78 10 80       	push   $0x8010780c
801027b4:	68 40 16 11 80       	push   $0x80111640
801027b9:	e8 b2 1e 00 00       	call   80104670 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801027be:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027c4:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
801027cb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801027ce:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027d4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027e0:	39 de                	cmp    %ebx,%esi
801027e2:	72 20                	jb     80102804 <kinit1+0x64>
801027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027e8:	83 ec 0c             	sub    $0xc,%esp
801027eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027f7:	50                   	push   %eax
801027f8:	e8 53 fe ff ff       	call   80102650 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027fd:	83 c4 10             	add    $0x10,%esp
80102800:	39 de                	cmp    %ebx,%esi
80102802:	73 e4                	jae    801027e8 <kinit1+0x48>
}
80102804:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102807:	5b                   	pop    %ebx
80102808:	5e                   	pop    %esi
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
8010280b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010280f:	90                   	nop

80102810 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102810:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102814:	a1 74 16 11 80       	mov    0x80111674,%eax
80102819:	85 c0                	test   %eax,%eax
8010281b:	75 1b                	jne    80102838 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010281d:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
80102822:	85 c0                	test   %eax,%eax
80102824:	74 0a                	je     80102830 <kalloc+0x20>
    kmem.freelist = r->next;
80102826:	8b 10                	mov    (%eax),%edx
80102828:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
8010282e:	c3                   	ret    
8010282f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102830:	c3                   	ret    
80102831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102838:	55                   	push   %ebp
80102839:	89 e5                	mov    %esp,%ebp
8010283b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010283e:	68 40 16 11 80       	push   $0x80111640
80102843:	e8 28 20 00 00       	call   80104870 <acquire>
  r = kmem.freelist;
80102848:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
8010284d:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
80102853:	83 c4 10             	add    $0x10,%esp
80102856:	85 c0                	test   %eax,%eax
80102858:	74 08                	je     80102862 <kalloc+0x52>
    kmem.freelist = r->next;
8010285a:	8b 08                	mov    (%eax),%ecx
8010285c:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
80102862:	85 d2                	test   %edx,%edx
80102864:	74 16                	je     8010287c <kalloc+0x6c>
    release(&kmem.lock);
80102866:	83 ec 0c             	sub    $0xc,%esp
80102869:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010286c:	68 40 16 11 80       	push   $0x80111640
80102871:	e8 8a 1f 00 00       	call   80104800 <release>
  return (char*)r;
80102876:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102879:	83 c4 10             	add    $0x10,%esp
}
8010287c:	c9                   	leave  
8010287d:	c3                   	ret    
8010287e:	66 90                	xchg   %ax,%ax

80102880 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102880:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102884:	ba 64 00 00 00       	mov    $0x64,%edx
80102889:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010288a:	a8 01                	test   $0x1,%al
8010288c:	0f 84 c6 00 00 00    	je     80102958 <kbdgetc+0xd8>
{
80102892:	55                   	push   %ebp
80102893:	ba 60 00 00 00       	mov    $0x60,%edx
80102898:	89 e5                	mov    %esp,%ebp
8010289a:	53                   	push   %ebx
8010289b:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
8010289c:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
801028a2:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028a5:	3c e0                	cmp    $0xe0,%al
801028a7:	74 57                	je     80102900 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028a9:	89 da                	mov    %ebx,%edx
801028ab:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028ae:	84 c0                	test   %al,%al
801028b0:	78 5e                	js     80102910 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028b2:	85 d2                	test   %edx,%edx
801028b4:	74 09                	je     801028bf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028b6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028b9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028bc:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801028bf:	0f b6 91 40 79 10 80 	movzbl -0x7fef86c0(%ecx),%edx
  shift ^= togglecode[data];
801028c6:	0f b6 81 40 78 10 80 	movzbl -0x7fef87c0(%ecx),%eax
  shift |= shiftcode[data];
801028cd:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028cf:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028d1:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028d3:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801028d9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028dc:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028df:	8b 04 85 20 78 10 80 	mov    -0x7fef87e0(,%eax,4),%eax
801028e6:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801028ea:	74 0b                	je     801028f7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801028ec:	8d 50 9f             	lea    -0x61(%eax),%edx
801028ef:	83 fa 19             	cmp    $0x19,%edx
801028f2:	77 4c                	ja     80102940 <kbdgetc+0xc0>
      c += 'A' - 'a';
801028f4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028fa:	c9                   	leave  
801028fb:	c3                   	ret    
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102900:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102903:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102905:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010290b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010290e:	c9                   	leave  
8010290f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102910:	83 e0 7f             	and    $0x7f,%eax
80102913:	85 d2                	test   %edx,%edx
80102915:	0f 44 c8             	cmove  %eax,%ecx
    return 0;
80102918:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010291a:	0f b6 91 40 79 10 80 	movzbl -0x7fef86c0(%ecx),%edx
80102921:	83 ca 40             	or     $0x40,%edx
80102924:	0f b6 d2             	movzbl %dl,%edx
80102927:	f7 d2                	not    %edx
80102929:	21 da                	and    %ebx,%edx
}
8010292b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010292e:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
}
80102934:	c9                   	leave  
80102935:	c3                   	ret    
80102936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293d:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102940:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102943:	8d 50 20             	lea    0x20(%eax),%edx
}
80102946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102949:	c9                   	leave  
      c += 'a' - 'A';
8010294a:	83 f9 1a             	cmp    $0x1a,%ecx
8010294d:	0f 42 c2             	cmovb  %edx,%eax
}
80102950:	c3                   	ret    
80102951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010295d:	c3                   	ret    
8010295e:	66 90                	xchg   %ax,%ax

80102960 <kbdintr>:

void
kbdintr(void)
{
80102960:	f3 0f 1e fb          	endbr32 
80102964:	55                   	push   %ebp
80102965:	89 e5                	mov    %esp,%ebp
80102967:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010296a:	68 80 28 10 80       	push   $0x80102880
8010296f:	e8 8c df ff ff       	call   80100900 <consoleintr>
}
80102974:	83 c4 10             	add    $0x10,%esp
80102977:	c9                   	leave  
80102978:	c3                   	ret    
80102979:	66 90                	xchg   %ax,%ax
8010297b:	66 90                	xchg   %ax,%ax
8010297d:	66 90                	xchg   %ax,%ax
8010297f:	90                   	nop

80102980 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102980:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102984:	a1 80 16 11 80       	mov    0x80111680,%eax
80102989:	85 c0                	test   %eax,%eax
8010298b:	0f 84 c7 00 00 00    	je     80102a58 <lapicinit+0xd8>
  lapic[index] = value;
80102991:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102998:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029a5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ab:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029b2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029bf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029c2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029cc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029cf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029d9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029dc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029df:	8b 50 30             	mov    0x30(%eax),%edx
801029e2:	c1 ea 10             	shr    $0x10,%edx
801029e5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801029eb:	75 73                	jne    80102a60 <lapicinit+0xe0>
  lapic[index] = value;
801029ed:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fa:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a01:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a07:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a0e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a14:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a1b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a21:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a28:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a2e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a35:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a38:	8b 50 20             	mov    0x20(%eax),%edx
80102a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a3f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a46:	80 e6 10             	and    $0x10,%dh
80102a49:	75 f5                	jne    80102a40 <lapicinit+0xc0>
  lapic[index] = value;
80102a4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a58:	c3                   	ret    
80102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a6d:	e9 7b ff ff ff       	jmp    801029ed <lapicinit+0x6d>
80102a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a80 <lapicid>:

int
lapicid(void)
{
80102a80:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102a84:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a89:	85 c0                	test   %eax,%eax
80102a8b:	74 0b                	je     80102a98 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102a8d:	8b 40 20             	mov    0x20(%eax),%eax
80102a90:	c1 e8 18             	shr    $0x18,%eax
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102a98:	31 c0                	xor    %eax,%eax
}
80102a9a:	c3                   	ret    
80102a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102aa0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102aa4:	a1 80 16 11 80       	mov    0x80111680,%eax
80102aa9:	85 c0                	test   %eax,%eax
80102aab:	74 0d                	je     80102aba <lapiceoi+0x1a>
  lapic[index] = value;
80102aad:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ab4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102aba:	c3                   	ret    
80102abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102abf:	90                   	nop

80102ac0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ac0:	f3 0f 1e fb          	endbr32 
}
80102ac4:	c3                   	ret    
80102ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ad0:	f3 0f 1e fb          	endbr32 
80102ad4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ada:	ba 70 00 00 00       	mov    $0x70,%edx
80102adf:	89 e5                	mov    %esp,%ebp
80102ae1:	53                   	push   %ebx
80102ae2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ae8:	ee                   	out    %al,(%dx)
80102ae9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aee:	ba 71 00 00 00       	mov    $0x71,%edx
80102af3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102af4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102af6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102af9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102aff:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b01:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b04:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b06:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b09:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b0c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b12:	a1 80 16 11 80       	mov    0x80111680,%eax
80102b17:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b1d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b20:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b27:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b2a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b2d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b34:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b37:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b3a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b40:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b43:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b4c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b52:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b55:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5b:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b61:	c9                   	leave  
80102b62:	c3                   	ret    
80102b63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b70:	f3 0f 1e fb          	endbr32 
80102b74:	55                   	push   %ebp
80102b75:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b7a:	ba 70 00 00 00       	mov    $0x70,%edx
80102b7f:	89 e5                	mov    %esp,%ebp
80102b81:	57                   	push   %edi
80102b82:	56                   	push   %esi
80102b83:	53                   	push   %ebx
80102b84:	83 ec 4c             	sub    $0x4c,%esp
80102b87:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b88:	ba 71 00 00 00       	mov    $0x71,%edx
80102b8d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b8e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b91:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b96:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ba0:	31 c0                	xor    %eax,%eax
80102ba2:	89 da                	mov    %ebx,%edx
80102ba4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102baa:	89 ca                	mov    %ecx,%edx
80102bac:	ec                   	in     (%dx),%al
80102bad:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb0:	89 da                	mov    %ebx,%edx
80102bb2:	b8 02 00 00 00       	mov    $0x2,%eax
80102bb7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb8:	89 ca                	mov    %ecx,%edx
80102bba:	ec                   	in     (%dx),%al
80102bbb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bbe:	89 da                	mov    %ebx,%edx
80102bc0:	b8 04 00 00 00       	mov    $0x4,%eax
80102bc5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc6:	89 ca                	mov    %ecx,%edx
80102bc8:	ec                   	in     (%dx),%al
80102bc9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcc:	89 da                	mov    %ebx,%edx
80102bce:	b8 07 00 00 00       	mov    $0x7,%eax
80102bd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd4:	89 ca                	mov    %ecx,%edx
80102bd6:	ec                   	in     (%dx),%al
80102bd7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bda:	89 da                	mov    %ebx,%edx
80102bdc:	b8 08 00 00 00       	mov    $0x8,%eax
80102be1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be2:	89 ca                	mov    %ecx,%edx
80102be4:	ec                   	in     (%dx),%al
80102be5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be7:	89 da                	mov    %ebx,%edx
80102be9:	b8 09 00 00 00       	mov    $0x9,%eax
80102bee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bef:	89 ca                	mov    %ecx,%edx
80102bf1:	ec                   	in     (%dx),%al
80102bf2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf4:	89 da                	mov    %ebx,%edx
80102bf6:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bfb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfc:	89 ca                	mov    %ecx,%edx
80102bfe:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102bff:	84 c0                	test   %al,%al
80102c01:	78 9d                	js     80102ba0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102c03:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c07:	89 fa                	mov    %edi,%edx
80102c09:	0f b6 fa             	movzbl %dl,%edi
80102c0c:	89 f2                	mov    %esi,%edx
80102c0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c11:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c15:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c18:	89 da                	mov    %ebx,%edx
80102c1a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c1d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c20:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c24:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c27:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c2a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c2e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c31:	31 c0                	xor    %eax,%eax
80102c33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c34:	89 ca                	mov    %ecx,%edx
80102c36:	ec                   	in     (%dx),%al
80102c37:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c3a:	89 da                	mov    %ebx,%edx
80102c3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c3f:	b8 02 00 00 00       	mov    $0x2,%eax
80102c44:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c45:	89 ca                	mov    %ecx,%edx
80102c47:	ec                   	in     (%dx),%al
80102c48:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4b:	89 da                	mov    %ebx,%edx
80102c4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c50:	b8 04 00 00 00       	mov    $0x4,%eax
80102c55:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c56:	89 ca                	mov    %ecx,%edx
80102c58:	ec                   	in     (%dx),%al
80102c59:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5c:	89 da                	mov    %ebx,%edx
80102c5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c61:	b8 07 00 00 00       	mov    $0x7,%eax
80102c66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c67:	89 ca                	mov    %ecx,%edx
80102c69:	ec                   	in     (%dx),%al
80102c6a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c6d:	89 da                	mov    %ebx,%edx
80102c6f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c72:	b8 08 00 00 00       	mov    $0x8,%eax
80102c77:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c78:	89 ca                	mov    %ecx,%edx
80102c7a:	ec                   	in     (%dx),%al
80102c7b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7e:	89 da                	mov    %ebx,%edx
80102c80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c83:	b8 09 00 00 00       	mov    $0x9,%eax
80102c88:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c89:	89 ca                	mov    %ecx,%edx
80102c8b:	ec                   	in     (%dx),%al
80102c8c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c8f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c95:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c98:	6a 18                	push   $0x18
80102c9a:	50                   	push   %eax
80102c9b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c9e:	50                   	push   %eax
80102c9f:	e8 ec 1c 00 00       	call   80104990 <memcmp>
80102ca4:	83 c4 10             	add    $0x10,%esp
80102ca7:	85 c0                	test   %eax,%eax
80102ca9:	0f 85 f1 fe ff ff    	jne    80102ba0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102caf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102cb3:	75 78                	jne    80102d2d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cb5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cb8:	89 c2                	mov    %eax,%edx
80102cba:	83 e0 0f             	and    $0xf,%eax
80102cbd:	c1 ea 04             	shr    $0x4,%edx
80102cc0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cc3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cc6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cc9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ccc:	89 c2                	mov    %eax,%edx
80102cce:	83 e0 0f             	and    $0xf,%eax
80102cd1:	c1 ea 04             	shr    $0x4,%edx
80102cd4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cda:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cdd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce0:	89 c2                	mov    %eax,%edx
80102ce2:	83 e0 0f             	and    $0xf,%eax
80102ce5:	c1 ea 04             	shr    $0x4,%edx
80102ce8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ceb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cee:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cf1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cf4:	89 c2                	mov    %eax,%edx
80102cf6:	83 e0 0f             	and    $0xf,%eax
80102cf9:	c1 ea 04             	shr    $0x4,%edx
80102cfc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d02:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d05:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d08:	89 c2                	mov    %eax,%edx
80102d0a:	83 e0 0f             	and    $0xf,%eax
80102d0d:	c1 ea 04             	shr    $0x4,%edx
80102d10:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d13:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d16:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d19:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d1c:	89 c2                	mov    %eax,%edx
80102d1e:	83 e0 0f             	and    $0xf,%eax
80102d21:	c1 ea 04             	shr    $0x4,%edx
80102d24:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d27:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d2d:	8b 75 08             	mov    0x8(%ebp),%esi
80102d30:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d33:	89 06                	mov    %eax,(%esi)
80102d35:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d38:	89 46 04             	mov    %eax,0x4(%esi)
80102d3b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d3e:	89 46 08             	mov    %eax,0x8(%esi)
80102d41:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d44:	89 46 0c             	mov    %eax,0xc(%esi)
80102d47:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d4a:	89 46 10             	mov    %eax,0x10(%esi)
80102d4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d50:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d53:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5d:	5b                   	pop    %ebx
80102d5e:	5e                   	pop    %esi
80102d5f:	5f                   	pop    %edi
80102d60:	5d                   	pop    %ebp
80102d61:	c3                   	ret    
80102d62:	66 90                	xchg   %ax,%ax
80102d64:	66 90                	xchg   %ax,%ax
80102d66:	66 90                	xchg   %ax,%ax
80102d68:	66 90                	xchg   %ax,%ax
80102d6a:	66 90                	xchg   %ax,%ax
80102d6c:	66 90                	xchg   %ax,%ax
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d70:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102d76:	85 c9                	test   %ecx,%ecx
80102d78:	0f 8e 8a 00 00 00    	jle    80102e08 <install_trans+0x98>
{
80102d7e:	55                   	push   %ebp
80102d7f:	89 e5                	mov    %esp,%ebp
80102d81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d82:	31 ff                	xor    %edi,%edi
{
80102d84:	56                   	push   %esi
80102d85:	53                   	push   %ebx
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d90:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102d95:	83 ec 08             	sub    $0x8,%esp
80102d98:	01 f8                	add    %edi,%eax
80102d9a:	83 c0 01             	add    $0x1,%eax
80102d9d:	50                   	push   %eax
80102d9e:	ff 35 e4 16 11 80    	pushl  0x801116e4
80102da4:	e8 27 d3 ff ff       	call   801000d0 <bread>
80102da9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dab:	58                   	pop    %eax
80102dac:	5a                   	pop    %edx
80102dad:	ff 34 bd ec 16 11 80 	pushl  -0x7feee914(,%edi,4)
80102db4:	ff 35 e4 16 11 80    	pushl  0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbd:	e8 0e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dc5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dca:	68 00 02 00 00       	push   $0x200
80102dcf:	50                   	push   %eax
80102dd0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102dd3:	50                   	push   %eax
80102dd4:	e8 07 1c 00 00       	call   801049e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dd9:	89 1c 24             	mov    %ebx,(%esp)
80102ddc:	e8 cf d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102de1:	89 34 24             	mov    %esi,(%esp)
80102de4:	e8 07 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102de9:	89 1c 24             	mov    %ebx,(%esp)
80102dec:	e8 ff d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102dfa:	7f 94                	jg     80102d90 <install_trans+0x20>
  }
}
80102dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dff:	5b                   	pop    %ebx
80102e00:	5e                   	pop    %esi
80102e01:	5f                   	pop    %edi
80102e02:	5d                   	pop    %ebp
80102e03:	c3                   	ret    
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e08:	c3                   	ret    
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e17:	ff 35 d4 16 11 80    	pushl  0x801116d4
80102e1d:	ff 35 e4 16 11 80    	pushl  0x801116e4
80102e23:	e8 a8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e28:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e2e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e31:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e33:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e36:	85 c9                	test   %ecx,%ecx
80102e38:	7e 18                	jle    80102e52 <write_head+0x42>
80102e3a:	31 c0                	xor    %eax,%eax
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e40:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
80102e47:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102e4b:	83 c0 01             	add    $0x1,%eax
80102e4e:	39 c1                	cmp    %eax,%ecx
80102e50:	75 ee                	jne    80102e40 <write_head+0x30>
  }
  bwrite(buf);
80102e52:	83 ec 0c             	sub    $0xc,%esp
80102e55:	53                   	push   %ebx
80102e56:	e8 55 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e5b:	89 1c 24             	mov    %ebx,(%esp)
80102e5e:	e8 8d d3 ff ff       	call   801001f0 <brelse>
}
80102e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e66:	83 c4 10             	add    $0x10,%esp
80102e69:	c9                   	leave  
80102e6a:	c3                   	ret    
80102e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop

80102e70 <initlog>:
{
80102e70:	f3 0f 1e fb          	endbr32 
80102e74:	55                   	push   %ebp
80102e75:	89 e5                	mov    %esp,%ebp
80102e77:	53                   	push   %ebx
80102e78:	83 ec 2c             	sub    $0x2c,%esp
80102e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e7e:	68 40 7a 10 80       	push   $0x80107a40
80102e83:	68 a0 16 11 80       	push   $0x801116a0
80102e88:	e8 e3 17 00 00       	call   80104670 <initlock>
  readsb(dev, &sb);
80102e8d:	58                   	pop    %eax
80102e8e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e91:	5a                   	pop    %edx
80102e92:	50                   	push   %eax
80102e93:	53                   	push   %ebx
80102e94:	e8 c7 e7 ff ff       	call   80101660 <readsb>
  log.start = sb.logstart;
80102e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e9c:	59                   	pop    %ecx
  log.dev = dev;
80102e9d:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102ea3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ea6:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102eab:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102eb1:	5a                   	pop    %edx
80102eb2:	50                   	push   %eax
80102eb3:	53                   	push   %ebx
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102eb9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ebc:	8b 58 5c             	mov    0x5c(%eax),%ebx
  struct buf *buf = bread(log.dev, log.start);
80102ebf:	89 c1                	mov    %eax,%ecx
  log.lh.n = lh->n;
80102ec1:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102ec7:	85 db                	test   %ebx,%ebx
80102ec9:	7e 17                	jle    80102ee2 <initlog+0x72>
80102ecb:	31 c0                	xor    %eax,%eax
80102ecd:	8d 76 00             	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ed0:	8b 54 81 60          	mov    0x60(%ecx,%eax,4),%edx
80102ed4:	89 14 85 ec 16 11 80 	mov    %edx,-0x7feee914(,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102edb:	83 c0 01             	add    $0x1,%eax
80102ede:	39 c3                	cmp    %eax,%ebx
80102ee0:	75 ee                	jne    80102ed0 <initlog+0x60>
  brelse(buf);
80102ee2:	83 ec 0c             	sub    $0xc,%esp
80102ee5:	51                   	push   %ecx
80102ee6:	e8 05 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eeb:	e8 80 fe ff ff       	call   80102d70 <install_trans>
  log.lh.n = 0;
80102ef0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102ef7:	00 00 00 
  write_head(); // clear the log
80102efa:	e8 11 ff ff ff       	call   80102e10 <write_head>
}
80102eff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f02:	83 c4 10             	add    $0x10,%esp
80102f05:	c9                   	leave  
80102f06:	c3                   	ret    
80102f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f1a:	68 a0 16 11 80       	push   $0x801116a0
80102f1f:	e8 4c 19 00 00       	call   80104870 <acquire>
80102f24:	83 c4 10             	add    $0x10,%esp
80102f27:	eb 1c                	jmp    80102f45 <begin_op+0x35>
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f30:	83 ec 08             	sub    $0x8,%esp
80102f33:	68 a0 16 11 80       	push   $0x801116a0
80102f38:	68 a0 16 11 80       	push   $0x801116a0
80102f3d:	e8 0e 13 00 00       	call   80104250 <sleep>
80102f42:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f45:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102f4a:	85 c0                	test   %eax,%eax
80102f4c:	75 e2                	jne    80102f30 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f4e:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f53:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f59:	83 c0 01             	add    $0x1,%eax
80102f5c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f5f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f62:	83 fa 1e             	cmp    $0x1e,%edx
80102f65:	7f c9                	jg     80102f30 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f67:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f6a:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102f6f:	68 a0 16 11 80       	push   $0x801116a0
80102f74:	e8 87 18 00 00       	call   80104800 <release>
      break;
    }
  }
}
80102f79:	83 c4 10             	add    $0x10,%esp
80102f7c:	c9                   	leave  
80102f7d:	c3                   	ret    
80102f7e:	66 90                	xchg   %ax,%ax

80102f80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f80:	f3 0f 1e fb          	endbr32 
80102f84:	55                   	push   %ebp
80102f85:	89 e5                	mov    %esp,%ebp
80102f87:	57                   	push   %edi
80102f88:	56                   	push   %esi
80102f89:	53                   	push   %ebx
80102f8a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f8d:	68 a0 16 11 80       	push   $0x801116a0
80102f92:	e8 d9 18 00 00       	call   80104870 <acquire>
  log.outstanding -= 1;
80102f97:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102f9c:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102fa2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fa5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fa8:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102fae:	85 f6                	test   %esi,%esi
80102fb0:	0f 85 1e 01 00 00    	jne    801030d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fb6:	85 db                	test   %ebx,%ebx
80102fb8:	0f 85 f2 00 00 00    	jne    801030b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fbe:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102fc5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fc8:	83 ec 0c             	sub    $0xc,%esp
80102fcb:	68 a0 16 11 80       	push   $0x801116a0
80102fd0:	e8 2b 18 00 00       	call   80104800 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fd5:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102fdb:	83 c4 10             	add    $0x10,%esp
80102fde:	85 c9                	test   %ecx,%ecx
80102fe0:	7f 3e                	jg     80103020 <end_op+0xa0>
    acquire(&log.lock);
80102fe2:	83 ec 0c             	sub    $0xc,%esp
80102fe5:	68 a0 16 11 80       	push   $0x801116a0
80102fea:	e8 81 18 00 00       	call   80104870 <acquire>
    wakeup(&log);
80102fef:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102ff6:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102ffd:	00 00 00 
    wakeup(&log);
80103000:	e8 0b 13 00 00       	call   80104310 <wakeup>
    release(&log.lock);
80103005:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
8010300c:	e8 ef 17 00 00       	call   80104800 <release>
80103011:	83 c4 10             	add    $0x10,%esp
}
80103014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103017:	5b                   	pop    %ebx
80103018:	5e                   	pop    %esi
80103019:	5f                   	pop    %edi
8010301a:	5d                   	pop    %ebp
8010301b:	c3                   	ret    
8010301c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103020:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80103025:	83 ec 08             	sub    $0x8,%esp
80103028:	01 d8                	add    %ebx,%eax
8010302a:	83 c0 01             	add    $0x1,%eax
8010302d:	50                   	push   %eax
8010302e:	ff 35 e4 16 11 80    	pushl  0x801116e4
80103034:	e8 97 d0 ff ff       	call   801000d0 <bread>
80103039:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303b:	58                   	pop    %eax
8010303c:	5a                   	pop    %edx
8010303d:	ff 34 9d ec 16 11 80 	pushl  -0x7feee914(,%ebx,4)
80103044:	ff 35 e4 16 11 80    	pushl  0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010304a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010304d:	e8 7e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103052:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103055:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103057:	8d 40 5c             	lea    0x5c(%eax),%eax
8010305a:	68 00 02 00 00       	push   $0x200
8010305f:	50                   	push   %eax
80103060:	8d 46 5c             	lea    0x5c(%esi),%eax
80103063:	50                   	push   %eax
80103064:	e8 77 19 00 00       	call   801049e0 <memmove>
    bwrite(to);  // write the log
80103069:	89 34 24             	mov    %esi,(%esp)
8010306c:	e8 3f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103071:	89 3c 24             	mov    %edi,(%esp)
80103074:	e8 77 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103079:	89 34 24             	mov    %esi,(%esp)
8010307c:	e8 6f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103081:	83 c4 10             	add    $0x10,%esp
80103084:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
8010308a:	7c 94                	jl     80103020 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010308c:	e8 7f fd ff ff       	call   80102e10 <write_head>
    install_trans(); // Now install writes to home locations
80103091:	e8 da fc ff ff       	call   80102d70 <install_trans>
    log.lh.n = 0;
80103096:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010309d:	00 00 00 
    write_head();    // Erase the transaction from the log
801030a0:	e8 6b fd ff ff       	call   80102e10 <write_head>
801030a5:	e9 38 ff ff ff       	jmp    80102fe2 <end_op+0x62>
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030b0:	83 ec 0c             	sub    $0xc,%esp
801030b3:	68 a0 16 11 80       	push   $0x801116a0
801030b8:	e8 53 12 00 00       	call   80104310 <wakeup>
  release(&log.lock);
801030bd:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801030c4:	e8 37 17 00 00       	call   80104800 <release>
801030c9:	83 c4 10             	add    $0x10,%esp
}
801030cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cf:	5b                   	pop    %ebx
801030d0:	5e                   	pop    %esi
801030d1:	5f                   	pop    %edi
801030d2:	5d                   	pop    %ebp
801030d3:	c3                   	ret    
    panic("log.committing");
801030d4:	83 ec 0c             	sub    $0xc,%esp
801030d7:	68 44 7a 10 80       	push   $0x80107a44
801030dc:	e8 af d2 ff ff       	call   80100390 <panic>
801030e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ef:	90                   	nop

801030f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030f0:	f3 0f 1e fb          	endbr32 
801030f4:	55                   	push   %ebp
801030f5:	89 e5                	mov    %esp,%ebp
801030f7:	53                   	push   %ebx
801030f8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030fb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80103101:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103104:	83 fa 1d             	cmp    $0x1d,%edx
80103107:	0f 8f 91 00 00 00    	jg     8010319e <log_write+0xae>
8010310d:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80103112:	83 e8 01             	sub    $0x1,%eax
80103115:	39 c2                	cmp    %eax,%edx
80103117:	0f 8d 81 00 00 00    	jge    8010319e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010311d:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80103122:	85 c0                	test   %eax,%eax
80103124:	0f 8e 81 00 00 00    	jle    801031ab <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010312a:	83 ec 0c             	sub    $0xc,%esp
8010312d:	68 a0 16 11 80       	push   $0x801116a0
80103132:	e8 39 17 00 00       	call   80104870 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103137:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
8010313d:	83 c4 10             	add    $0x10,%esp
80103140:	85 d2                	test   %edx,%edx
80103142:	7e 4e                	jle    80103192 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103144:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103147:	31 c0                	xor    %eax,%eax
80103149:	eb 0c                	jmp    80103157 <log_write+0x67>
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop
80103150:	83 c0 01             	add    $0x1,%eax
80103153:	39 c2                	cmp    %eax,%edx
80103155:	74 29                	je     80103180 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103157:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010315e:	75 f0                	jne    80103150 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103160:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103167:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010316a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010316d:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103174:	c9                   	leave  
  release(&log.lock);
80103175:	e9 86 16 00 00       	jmp    80104800 <release>
8010317a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103180:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80103187:	83 c2 01             	add    $0x1,%edx
8010318a:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103190:	eb d5                	jmp    80103167 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103192:	8b 43 08             	mov    0x8(%ebx),%eax
80103195:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
8010319a:	75 cb                	jne    80103167 <log_write+0x77>
8010319c:	eb e9                	jmp    80103187 <log_write+0x97>
    panic("too big a transaction");
8010319e:	83 ec 0c             	sub    $0xc,%esp
801031a1:	68 53 7a 10 80       	push   $0x80107a53
801031a6:	e8 e5 d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031ab:	83 ec 0c             	sub    $0xc,%esp
801031ae:	68 69 7a 10 80       	push   $0x80107a69
801031b3:	e8 d8 d1 ff ff       	call   80100390 <panic>
801031b8:	66 90                	xchg   %ax,%ax
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031c7:	e8 84 09 00 00       	call   80103b50 <cpuid>
801031cc:	89 c3                	mov    %eax,%ebx
801031ce:	e8 7d 09 00 00       	call   80103b50 <cpuid>
801031d3:	83 ec 04             	sub    $0x4,%esp
801031d6:	53                   	push   %ebx
801031d7:	50                   	push   %eax
801031d8:	68 84 7a 10 80       	push   $0x80107a84
801031dd:	e8 ae d4 ff ff       	call   80100690 <cprintf>
  idtinit();       // load idt register
801031e2:	e8 d9 2a 00 00       	call   80105cc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031e7:	e8 f4 08 00 00       	call   80103ae0 <mycpu>
801031ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031ee:	b8 01 00 00 00       	mov    $0x1,%eax
801031f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031fa:	e8 41 0c 00 00       	call   80103e40 <scheduler>
801031ff:	90                   	nop

80103200 <mpenter>:
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010320a:	e8 c1 3b 00 00       	call   80106dd0 <switchkvm>
  seginit();
8010320f:	e8 2c 3b 00 00       	call   80106d40 <seginit>
  lapicinit();
80103214:	e8 67 f7 ff ff       	call   80102980 <lapicinit>
  mpmain();
80103219:	e8 a2 ff ff ff       	call   801031c0 <mpmain>
8010321e:	66 90                	xchg   %ax,%ax

80103220 <main>:
{
80103220:	f3 0f 1e fb          	endbr32 
80103224:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103228:	83 e4 f0             	and    $0xfffffff0,%esp
8010322b:	ff 71 fc             	pushl  -0x4(%ecx)
8010322e:	55                   	push   %ebp
8010322f:	89 e5                	mov    %esp,%ebp
80103231:	53                   	push   %ebx
80103232:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103233:	83 ec 08             	sub    $0x8,%esp
80103236:	68 00 00 40 80       	push   $0x80400000
8010323b:	68 f0 54 11 80       	push   $0x801154f0
80103240:	e8 5b f5 ff ff       	call   801027a0 <kinit1>
  kvmalloc();      // kernel page table
80103245:	e8 86 40 00 00       	call   801072d0 <kvmalloc>
  mpinit();        // detect other processors
8010324a:	e8 81 01 00 00       	call   801033d0 <mpinit>
  lapicinit();     // interrupt controller
8010324f:	e8 2c f7 ff ff       	call   80102980 <lapicinit>
  seginit();       // segment descriptors
80103254:	e8 e7 3a 00 00       	call   80106d40 <seginit>
  picinit();       // disable pic
80103259:	e8 82 03 00 00       	call   801035e0 <picinit>
  ioapicinit();    // another interrupt controller
8010325e:	e8 fd f2 ff ff       	call   80102560 <ioapicinit>
  consoleinit();   // console hardware
80103263:	e8 28 d9 ff ff       	call   80100b90 <consoleinit>
  uartinit();      // serial port
80103268:	e8 43 2d 00 00       	call   80105fb0 <uartinit>
  pinit();         // process table
8010326d:	e8 4e 08 00 00       	call   80103ac0 <pinit>
  tvinit();        // trap vectors
80103272:	e8 c9 29 00 00       	call   80105c40 <tvinit>
  binit();         // buffer cache
80103277:	e8 c4 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010327c:	e8 bf dc ff ff       	call   80100f40 <fileinit>
  ideinit();       // disk 
80103281:	e8 aa f0 ff ff       	call   80102330 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103286:	83 c4 0c             	add    $0xc,%esp
80103289:	68 8a 00 00 00       	push   $0x8a
8010328e:	68 8c a4 10 80       	push   $0x8010a48c
80103293:	68 00 70 00 80       	push   $0x80007000
80103298:	e8 43 17 00 00       	call   801049e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010329d:	83 c4 10             	add    $0x10,%esp
801032a0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801032a7:	00 00 00 
801032aa:	05 a0 17 11 80       	add    $0x801117a0,%eax
801032af:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801032b4:	76 7a                	jbe    80103330 <main+0x110>
801032b6:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801032bb:	eb 1c                	jmp    801032d9 <main+0xb9>
801032bd:	8d 76 00             	lea    0x0(%esi),%esi
801032c0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801032c7:	00 00 00 
801032ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032d0:	05 a0 17 11 80       	add    $0x801117a0,%eax
801032d5:	39 c3                	cmp    %eax,%ebx
801032d7:	73 57                	jae    80103330 <main+0x110>
    if(c == mycpu())  // We've started already.
801032d9:	e8 02 08 00 00       	call   80103ae0 <mycpu>
801032de:	39 c3                	cmp    %eax,%ebx
801032e0:	74 de                	je     801032c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032e2:	e8 29 f5 ff ff       	call   80102810 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103200,0x80006ff8
801032f1:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032f4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801032fb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032fe:	05 00 10 00 00       	add    $0x1000,%eax
80103303:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103308:	0f b6 03             	movzbl (%ebx),%eax
8010330b:	68 00 70 00 00       	push   $0x7000
80103310:	50                   	push   %eax
80103311:	e8 ba f7 ff ff       	call   80102ad0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103316:	83 c4 10             	add    $0x10,%esp
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103320:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103326:	85 c0                	test   %eax,%eax
80103328:	74 f6                	je     80103320 <main+0x100>
8010332a:	eb 94                	jmp    801032c0 <main+0xa0>
8010332c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103330:	83 ec 08             	sub    $0x8,%esp
80103333:	68 00 00 00 8e       	push   $0x8e000000
80103338:	68 00 00 40 80       	push   $0x80400000
8010333d:	e8 fe f3 ff ff       	call   80102740 <kinit2>
  userinit();      // first user process
80103342:	e8 59 08 00 00       	call   80103ba0 <userinit>
  mpmain();        // finish this processor's setup
80103347:	e8 74 fe ff ff       	call   801031c0 <mpmain>
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103355:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010335b:	53                   	push   %ebx
  e = addr+len;
8010335c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010335f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103362:	39 de                	cmp    %ebx,%esi
80103364:	72 10                	jb     80103376 <mpsearch1+0x26>
80103366:	eb 50                	jmp    801033b8 <mpsearch1+0x68>
80103368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop
80103370:	89 fe                	mov    %edi,%esi
80103372:	39 fb                	cmp    %edi,%ebx
80103374:	76 42                	jbe    801033b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103376:	83 ec 04             	sub    $0x4,%esp
80103379:	8d 7e 10             	lea    0x10(%esi),%edi
8010337c:	6a 04                	push   $0x4
8010337e:	68 98 7a 10 80       	push   $0x80107a98
80103383:	56                   	push   %esi
80103384:	e8 07 16 00 00       	call   80104990 <memcmp>
80103389:	83 c4 10             	add    $0x10,%esp
8010338c:	89 c2                	mov    %eax,%edx
8010338e:	85 c0                	test   %eax,%eax
80103390:	75 de                	jne    80103370 <mpsearch1+0x20>
80103392:	89 f0                	mov    %esi,%eax
80103394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103398:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
8010339b:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010339e:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033a0:	39 f8                	cmp    %edi,%eax
801033a2:	75 f4                	jne    80103398 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033a4:	84 d2                	test   %dl,%dl
801033a6:	75 c8                	jne    80103370 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ab:	89 f0                	mov    %esi,%eax
801033ad:	5b                   	pop    %ebx
801033ae:	5e                   	pop    %esi
801033af:	5f                   	pop    %edi
801033b0:	5d                   	pop    %ebp
801033b1:	c3                   	ret    
801033b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033bb:	31 f6                	xor    %esi,%esi
}
801033bd:	5b                   	pop    %ebx
801033be:	89 f0                	mov    %esi,%eax
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret    
801033c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033cf:	90                   	nop

801033d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
801033d7:	57                   	push   %edi
801033d8:	56                   	push   %esi
801033d9:	53                   	push   %ebx
801033da:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033dd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033e4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033eb:	c1 e0 08             	shl    $0x8,%eax
801033ee:	09 d0                	or     %edx,%eax
801033f0:	c1 e0 04             	shl    $0x4,%eax
801033f3:	75 1b                	jne    80103410 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033f5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033fc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103403:	c1 e0 08             	shl    $0x8,%eax
80103406:	09 d0                	or     %edx,%eax
80103408:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010340b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103410:	ba 00 04 00 00       	mov    $0x400,%edx
80103415:	e8 36 ff ff ff       	call   80103350 <mpsearch1>
8010341a:	89 c3                	mov    %eax,%ebx
8010341c:	85 c0                	test   %eax,%eax
8010341e:	0f 84 4c 01 00 00    	je     80103570 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103424:	8b 73 04             	mov    0x4(%ebx),%esi
80103427:	85 f6                	test   %esi,%esi
80103429:	0f 84 31 01 00 00    	je     80103560 <mpinit+0x190>
  if(memcmp(conf, "PCMP", 4) != 0)
8010342f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103432:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103438:	6a 04                	push   $0x4
8010343a:	68 9d 7a 10 80       	push   $0x80107a9d
8010343f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103443:	e8 48 15 00 00       	call   80104990 <memcmp>
80103448:	83 c4 10             	add    $0x10,%esp
8010344b:	85 c0                	test   %eax,%eax
8010344d:	0f 85 0d 01 00 00    	jne    80103560 <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
80103453:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010345a:	3c 01                	cmp    $0x1,%al
8010345c:	74 08                	je     80103466 <mpinit+0x96>
8010345e:	3c 04                	cmp    $0x4,%al
80103460:	0f 85 fa 00 00 00    	jne    80103560 <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
80103466:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
8010346d:	66 85 d2             	test   %dx,%dx
80103470:	74 26                	je     80103498 <mpinit+0xc8>
80103472:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103475:	89 f0                	mov    %esi,%eax
  sum = 0;
80103477:	31 d2                	xor    %edx,%edx
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103480:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103487:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010348a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010348c:	39 f8                	cmp    %edi,%eax
8010348e:	75 f0                	jne    80103480 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103490:	84 d2                	test   %dl,%dl
80103492:	0f 85 c8 00 00 00    	jne    80103560 <mpinit+0x190>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103498:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
8010349e:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a3:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034aa:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034b0:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034b5:	03 55 e4             	add    -0x1c(%ebp),%edx
801034b8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034bf:	90                   	nop
801034c0:	39 d0                	cmp    %edx,%eax
801034c2:	73 15                	jae    801034d9 <mpinit+0x109>
    switch(*p){
801034c4:	0f b6 08             	movzbl (%eax),%ecx
801034c7:	80 f9 02             	cmp    $0x2,%cl
801034ca:	74 54                	je     80103520 <mpinit+0x150>
801034cc:	77 42                	ja     80103510 <mpinit+0x140>
801034ce:	84 c9                	test   %cl,%cl
801034d0:	74 5e                	je     80103530 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034d2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034d5:	39 d0                	cmp    %edx,%eax
801034d7:	72 eb                	jb     801034c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034d9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034dc:	85 f6                	test   %esi,%esi
801034de:	0f 84 e1 00 00 00    	je     801035c5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034e4:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034e8:	74 15                	je     801034ff <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034ea:	b8 70 00 00 00       	mov    $0x70,%eax
801034ef:	ba 22 00 00 00       	mov    $0x22,%edx
801034f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034f5:	ba 23 00 00 00       	mov    $0x23,%edx
801034fa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034fb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034fe:	ee                   	out    %al,(%dx)
  }
}
801034ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103502:	5b                   	pop    %ebx
80103503:	5e                   	pop    %esi
80103504:	5f                   	pop    %edi
80103505:	5d                   	pop    %ebp
80103506:	c3                   	ret    
80103507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103510:	83 e9 03             	sub    $0x3,%ecx
80103513:	80 f9 01             	cmp    $0x1,%cl
80103516:	76 ba                	jbe    801034d2 <mpinit+0x102>
80103518:	31 f6                	xor    %esi,%esi
8010351a:	eb a4                	jmp    801034c0 <mpinit+0xf0>
8010351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103520:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103524:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103527:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010352d:	eb 91                	jmp    801034c0 <mpinit+0xf0>
8010352f:	90                   	nop
      if(ncpu < NCPU) {
80103530:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103536:	83 f9 07             	cmp    $0x7,%ecx
80103539:	7f 19                	jg     80103554 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010353b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103541:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103545:	83 c1 01             	add    $0x1,%ecx
80103548:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010354e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103554:	83 c0 14             	add    $0x14,%eax
      continue;
80103557:	e9 64 ff ff ff       	jmp    801034c0 <mpinit+0xf0>
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	68 a2 7a 10 80       	push   $0x80107aa2
80103568:	e8 23 ce ff ff       	call   80100390 <panic>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103570:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103575:	eb 13                	jmp    8010358a <mpinit+0x1ba>
80103577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010357e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103580:	89 f3                	mov    %esi,%ebx
80103582:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103588:	74 d6                	je     80103560 <mpinit+0x190>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010358a:	83 ec 04             	sub    $0x4,%esp
8010358d:	8d 73 10             	lea    0x10(%ebx),%esi
80103590:	6a 04                	push   $0x4
80103592:	68 98 7a 10 80       	push   $0x80107a98
80103597:	53                   	push   %ebx
80103598:	e8 f3 13 00 00       	call   80104990 <memcmp>
8010359d:	83 c4 10             	add    $0x10,%esp
801035a0:	89 c2                	mov    %eax,%edx
801035a2:	85 c0                	test   %eax,%eax
801035a4:	75 da                	jne    80103580 <mpinit+0x1b0>
801035a6:	89 d8                	mov    %ebx,%eax
801035a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035af:	90                   	nop
    sum += addr[i];
801035b0:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801035b3:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801035b6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035b8:	39 f0                	cmp    %esi,%eax
801035ba:	75 f4                	jne    801035b0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035bc:	84 d2                	test   %dl,%dl
801035be:	75 c0                	jne    80103580 <mpinit+0x1b0>
801035c0:	e9 5f fe ff ff       	jmp    80103424 <mpinit+0x54>
    panic("Didn't find a suitable machine");
801035c5:	83 ec 0c             	sub    $0xc,%esp
801035c8:	68 bc 7a 10 80       	push   $0x80107abc
801035cd:	e8 be cd ff ff       	call   80100390 <panic>
801035d2:	66 90                	xchg   %ax,%ax
801035d4:	66 90                	xchg   %ax,%ax
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035e0:	f3 0f 1e fb          	endbr32 
801035e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035e9:	ba 21 00 00 00       	mov    $0x21,%edx
801035ee:	ee                   	out    %al,(%dx)
801035ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801035f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035f5:	c3                   	ret    
801035f6:	66 90                	xchg   %ax,%ax
801035f8:	66 90                	xchg   %ax,%ax
801035fa:	66 90                	xchg   %ax,%ax
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103600:	f3 0f 1e fb          	endbr32 
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	57                   	push   %edi
80103608:	56                   	push   %esi
80103609:	53                   	push   %ebx
8010360a:	83 ec 0c             	sub    $0xc,%esp
8010360d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103610:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103613:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103619:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010361f:	e8 3c d9 ff ff       	call   80100f60 <filealloc>
80103624:	89 03                	mov    %eax,(%ebx)
80103626:	85 c0                	test   %eax,%eax
80103628:	0f 84 ac 00 00 00    	je     801036da <pipealloc+0xda>
8010362e:	e8 2d d9 ff ff       	call   80100f60 <filealloc>
80103633:	89 06                	mov    %eax,(%esi)
80103635:	85 c0                	test   %eax,%eax
80103637:	0f 84 8b 00 00 00    	je     801036c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010363d:	e8 ce f1 ff ff       	call   80102810 <kalloc>
80103642:	89 c7                	mov    %eax,%edi
80103644:	85 c0                	test   %eax,%eax
80103646:	0f 84 b4 00 00 00    	je     80103700 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010364c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103653:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103656:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103659:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103660:	00 00 00 
  p->nwrite = 0;
80103663:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010366a:	00 00 00 
  p->nread = 0;
8010366d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103674:	00 00 00 
  initlock(&p->lock, "pipe");
80103677:	68 db 7a 10 80       	push   $0x80107adb
8010367c:	50                   	push   %eax
8010367d:	e8 ee 0f 00 00       	call   80104670 <initlock>
  (*f0)->type = FD_PIPE;
80103682:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103684:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103687:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010368d:	8b 03                	mov    (%ebx),%eax
8010368f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103693:	8b 03                	mov    (%ebx),%eax
80103695:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103699:	8b 03                	mov    (%ebx),%eax
8010369b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010369e:	8b 06                	mov    (%esi),%eax
801036a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036a6:	8b 06                	mov    (%esi),%eax
801036a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036ac:	8b 06                	mov    (%esi),%eax
801036ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036b2:	8b 06                	mov    (%esi),%eax
801036b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036ba:	31 c0                	xor    %eax,%eax
}
801036bc:	5b                   	pop    %ebx
801036bd:	5e                   	pop    %esi
801036be:	5f                   	pop    %edi
801036bf:	5d                   	pop    %ebp
801036c0:	c3                   	ret    
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801036c8:	8b 03                	mov    (%ebx),%eax
801036ca:	85 c0                	test   %eax,%eax
801036cc:	74 1e                	je     801036ec <pipealloc+0xec>
    fileclose(*f0);
801036ce:	83 ec 0c             	sub    $0xc,%esp
801036d1:	50                   	push   %eax
801036d2:	e8 49 d9 ff ff       	call   80101020 <fileclose>
801036d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036da:	8b 06                	mov    (%esi),%eax
801036dc:	85 c0                	test   %eax,%eax
801036de:	74 0c                	je     801036ec <pipealloc+0xec>
    fileclose(*f1);
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	50                   	push   %eax
801036e4:	e8 37 d9 ff ff       	call   80101020 <fileclose>
801036e9:	83 c4 10             	add    $0x10,%esp
}
801036ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036f4:	5b                   	pop    %ebx
801036f5:	5e                   	pop    %esi
801036f6:	5f                   	pop    %edi
801036f7:	5d                   	pop    %ebp
801036f8:	c3                   	ret    
801036f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103700:	8b 03                	mov    (%ebx),%eax
80103702:	85 c0                	test   %eax,%eax
80103704:	75 c8                	jne    801036ce <pipealloc+0xce>
80103706:	eb d2                	jmp    801036da <pipealloc+0xda>
80103708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010370f:	90                   	nop

80103710 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103710:	f3 0f 1e fb          	endbr32 
80103714:	55                   	push   %ebp
80103715:	89 e5                	mov    %esp,%ebp
80103717:	56                   	push   %esi
80103718:	53                   	push   %ebx
80103719:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010371c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010371f:	83 ec 0c             	sub    $0xc,%esp
80103722:	53                   	push   %ebx
80103723:	e8 48 11 00 00       	call   80104870 <acquire>
  if(writable){
80103728:	83 c4 10             	add    $0x10,%esp
8010372b:	85 f6                	test   %esi,%esi
8010372d:	74 61                	je     80103790 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010372f:	83 ec 0c             	sub    $0xc,%esp
80103732:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103738:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010373f:	00 00 00 
    wakeup(&p->nread);
80103742:	50                   	push   %eax
80103743:	e8 c8 0b 00 00       	call   80104310 <wakeup>
80103748:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010374b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103751:	85 d2                	test   %edx,%edx
80103753:	75 0a                	jne    8010375f <pipeclose+0x4f>
80103755:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010375b:	85 c0                	test   %eax,%eax
8010375d:	74 11                	je     80103770 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010375f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103762:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103765:	5b                   	pop    %ebx
80103766:	5e                   	pop    %esi
80103767:	5d                   	pop    %ebp
    release(&p->lock);
80103768:	e9 93 10 00 00       	jmp    80104800 <release>
8010376d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	53                   	push   %ebx
80103774:	e8 87 10 00 00       	call   80104800 <release>
    kfree((char*)p);
80103779:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010377c:	83 c4 10             	add    $0x10,%esp
}
8010377f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103782:	5b                   	pop    %ebx
80103783:	5e                   	pop    %esi
80103784:	5d                   	pop    %ebp
    kfree((char*)p);
80103785:	e9 c6 ee ff ff       	jmp    80102650 <kfree>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103799:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037a0:	00 00 00 
    wakeup(&p->nwrite);
801037a3:	50                   	push   %eax
801037a4:	e8 67 0b 00 00       	call   80104310 <wakeup>
801037a9:	83 c4 10             	add    $0x10,%esp
801037ac:	eb 9d                	jmp    8010374b <pipeclose+0x3b>
801037ae:	66 90                	xchg   %ax,%ax

801037b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037b0:	f3 0f 1e fb          	endbr32 
801037b4:	55                   	push   %ebp
801037b5:	89 e5                	mov    %esp,%ebp
801037b7:	57                   	push   %edi
801037b8:	56                   	push   %esi
801037b9:	53                   	push   %ebx
801037ba:	83 ec 28             	sub    $0x28,%esp
801037bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037c0:	53                   	push   %ebx
801037c1:	e8 aa 10 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++){
801037c6:	8b 45 10             	mov    0x10(%ebp),%eax
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	85 c0                	test   %eax,%eax
801037ce:	0f 8e bc 00 00 00    	jle    80103890 <pipewrite+0xe0>
801037d4:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037e6:	03 45 10             	add    0x10(%ebp),%eax
801037e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f8:	89 ca                	mov    %ecx,%edx
801037fa:	05 00 02 00 00       	add    $0x200,%eax
801037ff:	39 c1                	cmp    %eax,%ecx
80103801:	74 3b                	je     8010383e <pipewrite+0x8e>
80103803:	eb 63                	jmp    80103868 <pipewrite+0xb8>
80103805:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103808:	e8 63 03 00 00       	call   80103b70 <myproc>
8010380d:	8b 48 24             	mov    0x24(%eax),%ecx
80103810:	85 c9                	test   %ecx,%ecx
80103812:	75 34                	jne    80103848 <pipewrite+0x98>
      wakeup(&p->nread);
80103814:	83 ec 0c             	sub    $0xc,%esp
80103817:	57                   	push   %edi
80103818:	e8 f3 0a 00 00       	call   80104310 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010381d:	58                   	pop    %eax
8010381e:	5a                   	pop    %edx
8010381f:	53                   	push   %ebx
80103820:	56                   	push   %esi
80103821:	e8 2a 0a 00 00       	call   80104250 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103826:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010382c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103832:	83 c4 10             	add    $0x10,%esp
80103835:	05 00 02 00 00       	add    $0x200,%eax
8010383a:	39 c2                	cmp    %eax,%edx
8010383c:	75 2a                	jne    80103868 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010383e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103844:	85 c0                	test   %eax,%eax
80103846:	75 c0                	jne    80103808 <pipewrite+0x58>
        release(&p->lock);
80103848:	83 ec 0c             	sub    $0xc,%esp
8010384b:	53                   	push   %ebx
8010384c:	e8 af 0f 00 00       	call   80104800 <release>
        return -1;
80103851:	83 c4 10             	add    $0x10,%esp
80103854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010385c:	5b                   	pop    %ebx
8010385d:	5e                   	pop    %esi
8010385e:	5f                   	pop    %edi
8010385f:	5d                   	pop    %ebp
80103860:	c3                   	ret    
80103861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103868:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010386b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010386e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103874:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010387a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010387d:	83 c6 01             	add    $0x1,%esi
80103880:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103883:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103887:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010388a:	0f 85 5c ff ff ff    	jne    801037ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103899:	50                   	push   %eax
8010389a:	e8 71 0a 00 00       	call   80104310 <wakeup>
  release(&p->lock);
8010389f:	89 1c 24             	mov    %ebx,(%esp)
801038a2:	e8 59 0f 00 00       	call   80104800 <release>
  return n;
801038a7:	8b 45 10             	mov    0x10(%ebp),%eax
801038aa:	83 c4 10             	add    $0x10,%esp
801038ad:	eb aa                	jmp    80103859 <pipewrite+0xa9>
801038af:	90                   	nop

801038b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038b0:	f3 0f 1e fb          	endbr32 
801038b4:	55                   	push   %ebp
801038b5:	89 e5                	mov    %esp,%ebp
801038b7:	57                   	push   %edi
801038b8:	56                   	push   %esi
801038b9:	53                   	push   %ebx
801038ba:	83 ec 18             	sub    $0x18,%esp
801038bd:	8b 75 08             	mov    0x8(%ebp),%esi
801038c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038c3:	56                   	push   %esi
801038c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038ca:	e8 a1 0f 00 00       	call   80104870 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038de:	74 33                	je     80103913 <piperead+0x63>
801038e0:	eb 3b                	jmp    8010391d <piperead+0x6d>
801038e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801038e8:	e8 83 02 00 00       	call   80103b70 <myproc>
801038ed:	8b 48 24             	mov    0x24(%eax),%ecx
801038f0:	85 c9                	test   %ecx,%ecx
801038f2:	0f 85 88 00 00 00    	jne    80103980 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038f8:	83 ec 08             	sub    $0x8,%esp
801038fb:	56                   	push   %esi
801038fc:	53                   	push   %ebx
801038fd:	e8 4e 09 00 00       	call   80104250 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103902:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103911:	75 0a                	jne    8010391d <piperead+0x6d>
80103913:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103919:	85 c0                	test   %eax,%eax
8010391b:	75 cb                	jne    801038e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010391d:	8b 55 10             	mov    0x10(%ebp),%edx
80103920:	31 db                	xor    %ebx,%ebx
80103922:	85 d2                	test   %edx,%edx
80103924:	7f 28                	jg     8010394e <piperead+0x9e>
80103926:	eb 34                	jmp    8010395c <piperead+0xac>
80103928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103930:	8d 48 01             	lea    0x1(%eax),%ecx
80103933:	25 ff 01 00 00       	and    $0x1ff,%eax
80103938:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010393e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103943:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103946:	83 c3 01             	add    $0x1,%ebx
80103949:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010394c:	74 0e                	je     8010395c <piperead+0xac>
    if(p->nread == p->nwrite)
8010394e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103954:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010395a:	75 d4                	jne    80103930 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010395c:	83 ec 0c             	sub    $0xc,%esp
8010395f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103965:	50                   	push   %eax
80103966:	e8 a5 09 00 00       	call   80104310 <wakeup>
  release(&p->lock);
8010396b:	89 34 24             	mov    %esi,(%esp)
8010396e:	e8 8d 0e 00 00       	call   80104800 <release>
  return i;
80103973:	83 c4 10             	add    $0x10,%esp
}
80103976:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103979:	89 d8                	mov    %ebx,%eax
8010397b:	5b                   	pop    %ebx
8010397c:	5e                   	pop    %esi
8010397d:	5f                   	pop    %edi
8010397e:	5d                   	pop    %ebp
8010397f:	c3                   	ret    
      release(&p->lock);
80103980:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103983:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103988:	56                   	push   %esi
80103989:	e8 72 0e 00 00       	call   80104800 <release>
      return -1;
8010398e:	83 c4 10             	add    $0x10,%esp
}
80103991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103994:	89 d8                	mov    %ebx,%eax
80103996:	5b                   	pop    %ebx
80103997:	5e                   	pop    %esi
80103998:	5f                   	pop    %edi
80103999:	5d                   	pop    %ebp
8010399a:	c3                   	ret    
8010399b:	66 90                	xchg   %ax,%ax
8010399d:	66 90                	xchg   %ax,%ax
8010399f:	90                   	nop

801039a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a4:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
{
801039a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ac:	68 40 1d 11 80       	push   $0x80111d40
801039b1:	e8 ba 0e 00 00       	call   80104870 <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	eb 10                	jmp    801039cb <allocproc+0x2b>
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c0:	83 c3 7c             	add    $0x7c,%ebx
801039c3:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
801039c9:	74 75                	je     80103a40 <allocproc+0xa0>
    if(p->state == UNUSED)
801039cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801039ce:	85 c0                	test   %eax,%eax
801039d0:	75 ee                	jne    801039c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039d2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801039d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039da:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039e1:	89 43 10             	mov    %eax,0x10(%ebx)
801039e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039e7:	68 40 1d 11 80       	push   $0x80111d40
  p->pid = nextpid++;
801039ec:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801039f2:	e8 09 0e 00 00       	call   80104800 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039f7:	e8 14 ee ff ff       	call   80102810 <kalloc>
801039fc:	83 c4 10             	add    $0x10,%esp
801039ff:	89 43 08             	mov    %eax,0x8(%ebx)
80103a02:	85 c0                	test   %eax,%eax
80103a04:	74 53                	je     80103a59 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a06:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a0c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a0f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a14:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a17:	c7 40 14 2f 5c 10 80 	movl   $0x80105c2f,0x14(%eax)
  p->context = (struct context*)sp;
80103a1e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a21:	6a 14                	push   $0x14
80103a23:	6a 00                	push   $0x0
80103a25:	50                   	push   %eax
80103a26:	e8 15 0f 00 00       	call   80104940 <memset>
  p->context->eip = (uint)forkret;
80103a2b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a2e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a31:	c7 40 10 70 3a 10 80 	movl   $0x80103a70,0x10(%eax)
}
80103a38:	89 d8                	mov    %ebx,%eax
80103a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3d:	c9                   	leave  
80103a3e:	c3                   	ret    
80103a3f:	90                   	nop
  release(&ptable.lock);
80103a40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a43:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a45:	68 40 1d 11 80       	push   $0x80111d40
80103a4a:	e8 b1 0d 00 00       	call   80104800 <release>
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

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a7a:	68 40 1d 11 80       	push   $0x80111d40
80103a7f:	e8 7c 0d 00 00       	call   80104800 <release>

  if (first) {
80103a84:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	85 c0                	test   %eax,%eax
80103a8e:	75 08                	jne    80103a98 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a90:	c9                   	leave  
80103a91:	c3                   	ret    
80103a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103a98:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a9f:	00 00 00 
    iinit(ROOTDEV);
80103aa2:	83 ec 0c             	sub    $0xc,%esp
80103aa5:	6a 01                	push   $0x1
80103aa7:	e8 f4 db ff ff       	call   801016a0 <iinit>
    initlog(ROOTDEV);
80103aac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103ab3:	e8 b8 f3 ff ff       	call   80102e70 <initlog>
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
80103aca:	68 e0 7a 10 80       	push   $0x80107ae0
80103acf:	68 40 1d 11 80       	push   $0x80111d40
80103ad4:	e8 97 0b 00 00       	call   80104670 <initlock>
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
80103af0:	e8 8b ef ff ff       	call   80102a80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103af5:	8b 35 84 17 11 80    	mov    0x80111784,%esi
  apicid = lapicid();
80103afb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103afd:	85 f6                	test   %esi,%esi
80103aff:	7e 2c                	jle    80103b2d <mycpu+0x4d>
80103b01:	31 c0                	xor    %eax,%eax
80103b03:	eb 0a                	jmp    80103b0f <mycpu+0x2f>
80103b05:	8d 76 00             	lea    0x0(%esi),%esi
80103b08:	83 c0 01             	add    $0x1,%eax
80103b0b:	39 f0                	cmp    %esi,%eax
80103b0d:	74 1e                	je     80103b2d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103b0f:	69 d0 b0 00 00 00    	imul   $0xb0,%eax,%edx
80103b15:	0f b6 8a a0 17 11 80 	movzbl -0x7feee860(%edx),%ecx
80103b1c:	39 d9                	cmp    %ebx,%ecx
80103b1e:	75 e8                	jne    80103b08 <mycpu+0x28>
}
80103b20:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b23:	8d 82 a0 17 11 80    	lea    -0x7feee860(%edx),%eax
}
80103b29:	5b                   	pop    %ebx
80103b2a:	5e                   	pop    %esi
80103b2b:	5d                   	pop    %ebp
80103b2c:	c3                   	ret    
  panic("unknown apicid\n");
80103b2d:	83 ec 0c             	sub    $0xc,%esp
80103b30:	68 e7 7a 10 80       	push   $0x80107ae7
80103b35:	e8 56 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b3a:	83 ec 0c             	sub    $0xc,%esp
80103b3d:	68 f8 7b 10 80       	push   $0x80107bf8
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
80103b60:	2d a0 17 11 80       	sub    $0x801117a0,%eax
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
80103b7b:	e8 80 0b 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103b80:	e8 5b ff ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103b85:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b8b:	e8 c0 0b 00 00       	call   80104750 <popcli>
}
80103b90:	89 d8                	mov    %ebx,%eax
80103b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b95:	c9                   	leave  
80103b96:	c3                   	ret    
80103b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9e:	66 90                	xchg   %ax,%ax

80103ba0 <userinit>:
{
80103ba0:	f3 0f 1e fb          	endbr32 
80103ba4:	55                   	push   %ebp
80103ba5:	89 e5                	mov    %esp,%ebp
80103ba7:	53                   	push   %ebx
80103ba8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bab:	e8 f0 fd ff ff       	call   801039a0 <allocproc>
80103bb0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bb2:	a3 74 3c 11 80       	mov    %eax,0x80113c74
  if((p->pgdir = setupkvm()) == 0)
80103bb7:	e8 94 36 00 00       	call   80107250 <setupkvm>
80103bbc:	89 43 04             	mov    %eax,0x4(%ebx)
80103bbf:	85 c0                	test   %eax,%eax
80103bc1:	0f 84 bd 00 00 00    	je     80103c84 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bc7:	83 ec 04             	sub    $0x4,%esp
80103bca:	68 2c 00 00 00       	push   $0x2c
80103bcf:	68 60 a4 10 80       	push   $0x8010a460
80103bd4:	50                   	push   %eax
80103bd5:	e8 26 33 00 00       	call   80106f00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bda:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bdd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103be3:	6a 4c                	push   $0x4c
80103be5:	6a 00                	push   $0x0
80103be7:	ff 73 18             	pushl  0x18(%ebx)
80103bea:	e8 51 0d 00 00       	call   80104940 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bef:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bf7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bfa:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bff:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c03:	8b 43 18             	mov    0x18(%ebx),%eax
80103c06:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c0a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c0d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c11:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c15:	8b 43 18             	mov    0x18(%ebx),%eax
80103c18:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c1c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c20:	8b 43 18             	mov    0x18(%ebx),%eax
80103c23:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c2a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c2d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c34:	8b 43 18             	mov    0x18(%ebx),%eax
80103c37:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c3e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c41:	6a 10                	push   $0x10
80103c43:	68 10 7b 10 80       	push   $0x80107b10
80103c48:	50                   	push   %eax
80103c49:	e8 b2 0e 00 00       	call   80104b00 <safestrcpy>
  p->cwd = namei("/");
80103c4e:	c7 04 24 19 7b 10 80 	movl   $0x80107b19,(%esp)
80103c55:	e8 b6 e5 ff ff       	call   80102210 <namei>
80103c5a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c5d:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103c64:	e8 07 0c 00 00       	call   80104870 <acquire>
  p->state = RUNNABLE;
80103c69:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c70:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103c77:	e8 84 0b 00 00       	call   80104800 <release>
}
80103c7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c7f:	83 c4 10             	add    $0x10,%esp
80103c82:	c9                   	leave  
80103c83:	c3                   	ret    
    panic("userinit: out of memory?");
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	68 f7 7a 10 80       	push   $0x80107af7
80103c8c:	e8 ff c6 ff ff       	call   80100390 <panic>
80103c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9f:	90                   	nop

80103ca0 <growproc>:
{
80103ca0:	f3 0f 1e fb          	endbr32 
80103ca4:	55                   	push   %ebp
80103ca5:	89 e5                	mov    %esp,%ebp
80103ca7:	56                   	push   %esi
80103ca8:	53                   	push   %ebx
80103ca9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cac:	e8 4f 0a 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103cb1:	e8 2a fe ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103cb6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cbc:	e8 8f 0a 00 00       	call   80104750 <popcli>
  sz = curproc->sz;
80103cc1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103cc3:	85 f6                	test   %esi,%esi
80103cc5:	7f 19                	jg     80103ce0 <growproc+0x40>
  } else if(n < 0){
80103cc7:	75 37                	jne    80103d00 <growproc+0x60>
  switchuvm(curproc);
80103cc9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ccc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cce:	53                   	push   %ebx
80103ccf:	e8 1c 31 00 00       	call   80106df0 <switchuvm>
  return 0;
80103cd4:	83 c4 10             	add    $0x10,%esp
80103cd7:	31 c0                	xor    %eax,%eax
}
80103cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cdc:	5b                   	pop    %ebx
80103cdd:	5e                   	pop    %esi
80103cde:	5d                   	pop    %ebp
80103cdf:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce0:	83 ec 04             	sub    $0x4,%esp
80103ce3:	01 c6                	add    %eax,%esi
80103ce5:	56                   	push   %esi
80103ce6:	50                   	push   %eax
80103ce7:	ff 73 04             	pushl  0x4(%ebx)
80103cea:	e8 81 33 00 00       	call   80107070 <allocuvm>
80103cef:	83 c4 10             	add    $0x10,%esp
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	75 d3                	jne    80103cc9 <growproc+0x29>
      return -1;
80103cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cfb:	eb dc                	jmp    80103cd9 <growproc+0x39>
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	83 ec 04             	sub    $0x4,%esp
80103d03:	01 c6                	add    %eax,%esi
80103d05:	56                   	push   %esi
80103d06:	50                   	push   %eax
80103d07:	ff 73 04             	pushl  0x4(%ebx)
80103d0a:	e8 91 34 00 00       	call   801071a0 <deallocuvm>
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	85 c0                	test   %eax,%eax
80103d14:	75 b3                	jne    80103cc9 <growproc+0x29>
80103d16:	eb de                	jmp    80103cf6 <growproc+0x56>
80103d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1f:	90                   	nop

80103d20 <fork>:
{
80103d20:	f3 0f 1e fb          	endbr32 
80103d24:	55                   	push   %ebp
80103d25:	89 e5                	mov    %esp,%ebp
80103d27:	57                   	push   %edi
80103d28:	56                   	push   %esi
80103d29:	53                   	push   %ebx
80103d2a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d2d:	e8 ce 09 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103d32:	e8 a9 fd ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103d37:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d3d:	e8 0e 0a 00 00       	call   80104750 <popcli>
  if((np = allocproc()) == 0){
80103d42:	e8 59 fc ff ff       	call   801039a0 <allocproc>
80103d47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d4a:	85 c0                	test   %eax,%eax
80103d4c:	0f 84 bb 00 00 00    	je     80103e0d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d52:	83 ec 08             	sub    $0x8,%esp
80103d55:	ff 33                	pushl  (%ebx)
80103d57:	89 c7                	mov    %eax,%edi
80103d59:	ff 73 04             	pushl  0x4(%ebx)
80103d5c:	e8 df 35 00 00       	call   80107340 <copyuvm>
80103d61:	83 c4 10             	add    $0x10,%esp
80103d64:	89 47 04             	mov    %eax,0x4(%edi)
80103d67:	85 c0                	test   %eax,%eax
80103d69:	0f 84 a5 00 00 00    	je     80103e14 <fork+0xf4>
  np->sz = curproc->sz;
80103d6f:	8b 03                	mov    (%ebx),%eax
80103d71:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d74:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d76:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d79:	89 c8                	mov    %ecx,%eax
80103d7b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d7e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d83:	8b 73 18             	mov    0x18(%ebx),%esi
80103d86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d88:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d8a:	8b 40 18             	mov    0x18(%eax),%eax
80103d8d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103d98:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d9c:	85 c0                	test   %eax,%eax
80103d9e:	74 13                	je     80103db3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	50                   	push   %eax
80103da4:	e8 27 d2 ff ff       	call   80100fd0 <filedup>
80103da9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dac:	83 c4 10             	add    $0x10,%esp
80103daf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103db3:	83 c6 01             	add    $0x1,%esi
80103db6:	83 fe 10             	cmp    $0x10,%esi
80103db9:	75 dd                	jne    80103d98 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103dbb:	83 ec 0c             	sub    $0xc,%esp
80103dbe:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dc1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103dc4:	e8 d7 da ff ff       	call   801018a0 <idup>
80103dc9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dcc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103dcf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dd2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dd5:	6a 10                	push   $0x10
80103dd7:	53                   	push   %ebx
80103dd8:	50                   	push   %eax
80103dd9:	e8 22 0d 00 00       	call   80104b00 <safestrcpy>
  pid = np->pid;
80103dde:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103de1:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103de8:	e8 83 0a 00 00       	call   80104870 <acquire>
  np->state = RUNNABLE;
80103ded:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103df4:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103dfb:	e8 00 0a 00 00       	call   80104800 <release>
  return pid;
80103e00:	83 c4 10             	add    $0x10,%esp
}
80103e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e06:	89 d8                	mov    %ebx,%eax
80103e08:	5b                   	pop    %ebx
80103e09:	5e                   	pop    %esi
80103e0a:	5f                   	pop    %edi
80103e0b:	5d                   	pop    %ebp
80103e0c:	c3                   	ret    
    return -1;
80103e0d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e12:	eb ef                	jmp    80103e03 <fork+0xe3>
    kfree(np->kstack);
80103e14:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	ff 73 08             	pushl  0x8(%ebx)
80103e1d:	e8 2e e8 ff ff       	call   80102650 <kfree>
    np->kstack = 0;
80103e22:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e29:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e2c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e38:	eb c9                	jmp    80103e03 <fork+0xe3>
80103e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e40 <scheduler>:
{
80103e40:	f3 0f 1e fb          	endbr32 
80103e44:	55                   	push   %ebp
80103e45:	89 e5                	mov    %esp,%ebp
80103e47:	57                   	push   %edi
80103e48:	56                   	push   %esi
80103e49:	53                   	push   %ebx
80103e4a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e4d:	e8 8e fc ff ff       	call   80103ae0 <mycpu>
  c->proc = 0;
80103e52:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e59:	00 00 00 
  struct cpu *c = mycpu();
80103e5c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e5e:	8d 78 04             	lea    0x4(%eax),%edi
80103e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103e68:	fb                   	sti    
    acquire(&ptable.lock);
80103e69:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6c:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
    acquire(&ptable.lock);
80103e71:	68 40 1d 11 80       	push   $0x80111d40
80103e76:	e8 f5 09 00 00       	call   80104870 <acquire>
80103e7b:	83 c4 10             	add    $0x10,%esp
80103e7e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103e80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e84:	75 33                	jne    80103eb9 <scheduler+0x79>
      switchuvm(p);
80103e86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e8f:	53                   	push   %ebx
80103e90:	e8 5b 2f 00 00       	call   80106df0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e95:	58                   	pop    %eax
80103e96:	5a                   	pop    %edx
80103e97:	ff 73 1c             	pushl  0x1c(%ebx)
80103e9a:	57                   	push   %edi
      p->state = RUNNING;
80103e9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ea2:	e8 bc 0c 00 00       	call   80104b63 <swtch>
      switchkvm();
80103ea7:	e8 24 2f 00 00       	call   80106dd0 <switchkvm>
      c->proc = 0;
80103eac:	83 c4 10             	add    $0x10,%esp
80103eaf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103eb6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb9:	83 c3 7c             	add    $0x7c,%ebx
80103ebc:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
80103ec2:	75 bc                	jne    80103e80 <scheduler+0x40>
    release(&ptable.lock);
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 40 1d 11 80       	push   $0x80111d40
80103ecc:	e8 2f 09 00 00       	call   80104800 <release>
    sti();
80103ed1:	83 c4 10             	add    $0x10,%esp
80103ed4:	eb 92                	jmp    80103e68 <scheduler+0x28>
80103ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edd:	8d 76 00             	lea    0x0(%esi),%esi

80103ee0 <sched>:
{
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	56                   	push   %esi
80103ee8:	53                   	push   %ebx
  pushcli();
80103ee9:	e8 12 08 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103eee:	e8 ed fb ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103ef3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef9:	e8 52 08 00 00       	call   80104750 <popcli>
  if(!holding(&ptable.lock))
80103efe:	83 ec 0c             	sub    $0xc,%esp
80103f01:	68 40 1d 11 80       	push   $0x80111d40
80103f06:	e8 a5 08 00 00       	call   801047b0 <holding>
80103f0b:	83 c4 10             	add    $0x10,%esp
80103f0e:	85 c0                	test   %eax,%eax
80103f10:	74 4f                	je     80103f61 <sched+0x81>
  if(mycpu()->ncli != 1)
80103f12:	e8 c9 fb ff ff       	call   80103ae0 <mycpu>
80103f17:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f1e:	75 68                	jne    80103f88 <sched+0xa8>
  if(p->state == RUNNING)
80103f20:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f24:	74 55                	je     80103f7b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f26:	9c                   	pushf  
80103f27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f28:	f6 c4 02             	test   $0x2,%ah
80103f2b:	75 41                	jne    80103f6e <sched+0x8e>
  intena = mycpu()->intena;
80103f2d:	e8 ae fb ff ff       	call   80103ae0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f32:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f35:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f3b:	e8 a0 fb ff ff       	call   80103ae0 <mycpu>
80103f40:	83 ec 08             	sub    $0x8,%esp
80103f43:	ff 70 04             	pushl  0x4(%eax)
80103f46:	53                   	push   %ebx
80103f47:	e8 17 0c 00 00       	call   80104b63 <swtch>
  mycpu()->intena = intena;
80103f4c:	e8 8f fb ff ff       	call   80103ae0 <mycpu>
}
80103f51:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f54:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f5d:	5b                   	pop    %ebx
80103f5e:	5e                   	pop    %esi
80103f5f:	5d                   	pop    %ebp
80103f60:	c3                   	ret    
    panic("sched ptable.lock");
80103f61:	83 ec 0c             	sub    $0xc,%esp
80103f64:	68 1b 7b 10 80       	push   $0x80107b1b
80103f69:	e8 22 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f6e:	83 ec 0c             	sub    $0xc,%esp
80103f71:	68 47 7b 10 80       	push   $0x80107b47
80103f76:	e8 15 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f7b:	83 ec 0c             	sub    $0xc,%esp
80103f7e:	68 39 7b 10 80       	push   $0x80107b39
80103f83:	e8 08 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f88:	83 ec 0c             	sub    $0xc,%esp
80103f8b:	68 2d 7b 10 80       	push   $0x80107b2d
80103f90:	e8 fb c3 ff ff       	call   80100390 <panic>
80103f95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103fa0 <exit>:
{
80103fa0:	f3 0f 1e fb          	endbr32 
80103fa4:	55                   	push   %ebp
80103fa5:	89 e5                	mov    %esp,%ebp
80103fa7:	57                   	push   %edi
80103fa8:	56                   	push   %esi
80103fa9:	53                   	push   %ebx
80103faa:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fad:	e8 be fb ff ff       	call   80103b70 <myproc>
  if(curproc == initproc)
80103fb2:	39 05 74 3c 11 80    	cmp    %eax,0x80113c74
80103fb8:	0f 84 f9 00 00 00    	je     801040b7 <exit+0x117>
80103fbe:	89 c3                	mov    %eax,%ebx
80103fc0:	8d 70 28             	lea    0x28(%eax),%esi
80103fc3:	8d 78 68             	lea    0x68(%eax),%edi
80103fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fd0:	8b 06                	mov    (%esi),%eax
80103fd2:	85 c0                	test   %eax,%eax
80103fd4:	74 12                	je     80103fe8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	50                   	push   %eax
80103fda:	e8 41 d0 ff ff       	call   80101020 <fileclose>
      curproc->ofile[fd] = 0;
80103fdf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fe5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fe8:	83 c6 04             	add    $0x4,%esi
80103feb:	39 f7                	cmp    %esi,%edi
80103fed:	75 e1                	jne    80103fd0 <exit+0x30>
  begin_op();
80103fef:	e8 1c ef ff ff       	call   80102f10 <begin_op>
  iput(curproc->cwd);
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	ff 73 68             	pushl  0x68(%ebx)
80103ffa:	e8 01 da ff ff       	call   80101a00 <iput>
  end_op();
80103fff:	e8 7c ef ff ff       	call   80102f80 <end_op>
  curproc->cwd = 0;
80104004:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010400b:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80104012:	e8 59 08 00 00       	call   80104870 <acquire>
  wakeup1(curproc->parent);
80104017:	8b 53 14             	mov    0x14(%ebx),%edx
8010401a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010401d:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80104022:	eb 0e                	jmp    80104032 <exit+0x92>
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104028:	83 c0 7c             	add    $0x7c,%eax
8010402b:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
80104030:	74 1c                	je     8010404e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104032:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104036:	75 f0                	jne    80104028 <exit+0x88>
80104038:	3b 50 20             	cmp    0x20(%eax),%edx
8010403b:	75 eb                	jne    80104028 <exit+0x88>
      p->state = RUNNABLE;
8010403d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104044:	83 c0 7c             	add    $0x7c,%eax
80104047:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
8010404c:	75 e4                	jne    80104032 <exit+0x92>
      p->parent = initproc;
8010404e:	8b 0d 74 3c 11 80    	mov    0x80113c74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104054:	ba 74 1d 11 80       	mov    $0x80111d74,%edx
80104059:	eb 10                	jmp    8010406b <exit+0xcb>
8010405b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010405f:	90                   	nop
80104060:	83 c2 7c             	add    $0x7c,%edx
80104063:	81 fa 74 3c 11 80    	cmp    $0x80113c74,%edx
80104069:	74 33                	je     8010409e <exit+0xfe>
    if(p->parent == curproc){
8010406b:	39 5a 14             	cmp    %ebx,0x14(%edx)
8010406e:	75 f0                	jne    80104060 <exit+0xc0>
      if(p->state == ZOMBIE)
80104070:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104074:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104077:	75 e7                	jne    80104060 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104079:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
8010407e:	eb 0a                	jmp    8010408a <exit+0xea>
80104080:	83 c0 7c             	add    $0x7c,%eax
80104083:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
80104088:	74 d6                	je     80104060 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010408a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010408e:	75 f0                	jne    80104080 <exit+0xe0>
80104090:	3b 48 20             	cmp    0x20(%eax),%ecx
80104093:	75 eb                	jne    80104080 <exit+0xe0>
      p->state = RUNNABLE;
80104095:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010409c:	eb e2                	jmp    80104080 <exit+0xe0>
  curproc->state = ZOMBIE;
8010409e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801040a5:	e8 36 fe ff ff       	call   80103ee0 <sched>
  panic("zombie exit");
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 68 7b 10 80       	push   $0x80107b68
801040b2:	e8 d9 c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040b7:	83 ec 0c             	sub    $0xc,%esp
801040ba:	68 5b 7b 10 80       	push   $0x80107b5b
801040bf:	e8 cc c2 ff ff       	call   80100390 <panic>
801040c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop

801040d0 <wait>:
{
801040d0:	f3 0f 1e fb          	endbr32 
801040d4:	55                   	push   %ebp
801040d5:	89 e5                	mov    %esp,%ebp
801040d7:	56                   	push   %esi
801040d8:	53                   	push   %ebx
  pushcli();
801040d9:	e8 22 06 00 00       	call   80104700 <pushcli>
  c = mycpu();
801040de:	e8 fd f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801040e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040e9:	e8 62 06 00 00       	call   80104750 <popcli>
  acquire(&ptable.lock);
801040ee:	83 ec 0c             	sub    $0xc,%esp
801040f1:	68 40 1d 11 80       	push   $0x80111d40
801040f6:	e8 75 07 00 00       	call   80104870 <acquire>
801040fb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040fe:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104100:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
80104105:	eb 14                	jmp    8010411b <wait+0x4b>
80104107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010410e:	66 90                	xchg   %ax,%ax
80104110:	83 c3 7c             	add    $0x7c,%ebx
80104113:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
80104119:	74 1b                	je     80104136 <wait+0x66>
      if(p->parent != curproc)
8010411b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010411e:	75 f0                	jne    80104110 <wait+0x40>
      if(p->state == ZOMBIE){
80104120:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104124:	74 5a                	je     80104180 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104126:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104129:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412e:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
80104134:	75 e5                	jne    8010411b <wait+0x4b>
    if(!havekids || curproc->killed){
80104136:	85 c0                	test   %eax,%eax
80104138:	0f 84 98 00 00 00    	je     801041d6 <wait+0x106>
8010413e:	8b 46 24             	mov    0x24(%esi),%eax
80104141:	85 c0                	test   %eax,%eax
80104143:	0f 85 8d 00 00 00    	jne    801041d6 <wait+0x106>
  pushcli();
80104149:	e8 b2 05 00 00       	call   80104700 <pushcli>
  c = mycpu();
8010414e:	e8 8d f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80104153:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104159:	e8 f2 05 00 00       	call   80104750 <popcli>
  if(p == 0)
8010415e:	85 db                	test   %ebx,%ebx
80104160:	0f 84 87 00 00 00    	je     801041ed <wait+0x11d>
  p->chan = chan;
80104166:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104169:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104170:	e8 6b fd ff ff       	call   80103ee0 <sched>
  p->chan = 0;
80104175:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010417c:	eb 80                	jmp    801040fe <wait+0x2e>
8010417e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104180:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104183:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104186:	ff 73 08             	pushl  0x8(%ebx)
80104189:	e8 c2 e4 ff ff       	call   80102650 <kfree>
        p->kstack = 0;
8010418e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104195:	5a                   	pop    %edx
80104196:	ff 73 04             	pushl  0x4(%ebx)
80104199:	e8 32 30 00 00       	call   801071d0 <freevm>
        p->pid = 0;
8010419e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041a5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041ac:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041b0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041be:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801041c5:	e8 36 06 00 00       	call   80104800 <release>
        return pid;
801041ca:	83 c4 10             	add    $0x10,%esp
}
801041cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d0:	89 f0                	mov    %esi,%eax
801041d2:	5b                   	pop    %ebx
801041d3:	5e                   	pop    %esi
801041d4:	5d                   	pop    %ebp
801041d5:	c3                   	ret    
      release(&ptable.lock);
801041d6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041de:	68 40 1d 11 80       	push   $0x80111d40
801041e3:	e8 18 06 00 00       	call   80104800 <release>
      return -1;
801041e8:	83 c4 10             	add    $0x10,%esp
801041eb:	eb e0                	jmp    801041cd <wait+0xfd>
    panic("sleep");
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	68 74 7b 10 80       	push   $0x80107b74
801041f5:	e8 96 c1 ff ff       	call   80100390 <panic>
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104200 <yield>:
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	53                   	push   %ebx
80104208:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010420b:	68 40 1d 11 80       	push   $0x80111d40
80104210:	e8 5b 06 00 00       	call   80104870 <acquire>
  pushcli();
80104215:	e8 e6 04 00 00       	call   80104700 <pushcli>
  c = mycpu();
8010421a:	e8 c1 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
8010421f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104225:	e8 26 05 00 00       	call   80104750 <popcli>
  myproc()->state = RUNNABLE;
8010422a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104231:	e8 aa fc ff ff       	call   80103ee0 <sched>
  release(&ptable.lock);
80104236:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
8010423d:	e8 be 05 00 00       	call   80104800 <release>
}
80104242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104245:	83 c4 10             	add    $0x10,%esp
80104248:	c9                   	leave  
80104249:	c3                   	ret    
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <sleep>:
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	57                   	push   %edi
80104258:	56                   	push   %esi
80104259:	53                   	push   %ebx
8010425a:	83 ec 0c             	sub    $0xc,%esp
8010425d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104260:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104263:	e8 98 04 00 00       	call   80104700 <pushcli>
  c = mycpu();
80104268:	e8 73 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
8010426d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104273:	e8 d8 04 00 00       	call   80104750 <popcli>
  if(p == 0)
80104278:	85 db                	test   %ebx,%ebx
8010427a:	0f 84 83 00 00 00    	je     80104303 <sleep+0xb3>
  if(lk == 0)
80104280:	85 f6                	test   %esi,%esi
80104282:	74 72                	je     801042f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104284:	81 fe 40 1d 11 80    	cmp    $0x80111d40,%esi
8010428a:	74 4c                	je     801042d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010428c:	83 ec 0c             	sub    $0xc,%esp
8010428f:	68 40 1d 11 80       	push   $0x80111d40
80104294:	e8 d7 05 00 00       	call   80104870 <acquire>
    release(lk);
80104299:	89 34 24             	mov    %esi,(%esp)
8010429c:	e8 5f 05 00 00       	call   80104800 <release>
  p->chan = chan;
801042a1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042a4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042ab:	e8 30 fc ff ff       	call   80103ee0 <sched>
  p->chan = 0;
801042b0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042b7:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801042be:	e8 3d 05 00 00       	call   80104800 <release>
    acquire(lk);
801042c3:	89 75 08             	mov    %esi,0x8(%ebp)
801042c6:	83 c4 10             	add    $0x10,%esp
}
801042c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042cc:	5b                   	pop    %ebx
801042cd:	5e                   	pop    %esi
801042ce:	5f                   	pop    %edi
801042cf:	5d                   	pop    %ebp
    acquire(lk);
801042d0:	e9 9b 05 00 00       	jmp    80104870 <acquire>
801042d5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801042d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042e2:	e8 f9 fb ff ff       	call   80103ee0 <sched>
  p->chan = 0;
801042e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f1:	5b                   	pop    %ebx
801042f2:	5e                   	pop    %esi
801042f3:	5f                   	pop    %edi
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret    
    panic("sleep without lk");
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	68 7a 7b 10 80       	push   $0x80107b7a
801042fe:	e8 8d c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	68 74 7b 10 80       	push   $0x80107b74
8010430b:	e8 80 c0 ff ff       	call   80100390 <panic>

80104310 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	53                   	push   %ebx
80104318:	83 ec 10             	sub    $0x10,%esp
8010431b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010431e:	68 40 1d 11 80       	push   $0x80111d40
80104323:	e8 48 05 00 00       	call   80104870 <acquire>
80104328:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010432b:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80104330:	eb 10                	jmp    80104342 <wakeup+0x32>
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104338:	83 c0 7c             	add    $0x7c,%eax
8010433b:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
80104340:	74 1c                	je     8010435e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104342:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104346:	75 f0                	jne    80104338 <wakeup+0x28>
80104348:	3b 58 20             	cmp    0x20(%eax),%ebx
8010434b:	75 eb                	jne    80104338 <wakeup+0x28>
      p->state = RUNNABLE;
8010434d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104354:	83 c0 7c             	add    $0x7c,%eax
80104357:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
8010435c:	75 e4                	jne    80104342 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010435e:	c7 45 08 40 1d 11 80 	movl   $0x80111d40,0x8(%ebp)
}
80104365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104368:	c9                   	leave  
  release(&ptable.lock);
80104369:	e9 92 04 00 00       	jmp    80104800 <release>
8010436e:	66 90                	xchg   %ax,%ax

80104370 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	53                   	push   %ebx
80104378:	83 ec 10             	sub    $0x10,%esp
8010437b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010437e:	68 40 1d 11 80       	push   $0x80111d40
80104383:	e8 e8 04 00 00       	call   80104870 <acquire>
80104388:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010438b:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80104390:	eb 10                	jmp    801043a2 <kill+0x32>
80104392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104398:	83 c0 7c             	add    $0x7c,%eax
8010439b:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
801043a0:	74 36                	je     801043d8 <kill+0x68>
    if(p->pid == pid){
801043a2:	39 58 10             	cmp    %ebx,0x10(%eax)
801043a5:	75 f1                	jne    80104398 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043a7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043ab:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043b2:	75 07                	jne    801043bb <kill+0x4b>
        p->state = RUNNABLE;
801043b4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	68 40 1d 11 80       	push   $0x80111d40
801043c3:	e8 38 04 00 00       	call   80104800 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043cb:	83 c4 10             	add    $0x10,%esp
801043ce:	31 c0                	xor    %eax,%eax
}
801043d0:	c9                   	leave  
801043d1:	c3                   	ret    
801043d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 40 1d 11 80       	push   $0x80111d40
801043e0:	e8 1b 04 00 00       	call   80104800 <release>
}
801043e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043e8:	83 c4 10             	add    $0x10,%esp
801043eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043f0:	c9                   	leave  
801043f1:	c3                   	ret    
801043f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104400 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	57                   	push   %edi
80104408:	56                   	push   %esi
80104409:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010440c:	53                   	push   %ebx
8010440d:	bb e0 1d 11 80       	mov    $0x80111de0,%ebx
80104412:	83 ec 3c             	sub    $0x3c,%esp
80104415:	eb 28                	jmp    8010443f <procdump+0x3f>
80104417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 3b 7f 10 80       	push   $0x80107f3b
80104428:	e8 63 c2 ff ff       	call   80100690 <cprintf>
8010442d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104430:	83 c3 7c             	add    $0x7c,%ebx
80104433:	81 fb e0 3c 11 80    	cmp    $0x80113ce0,%ebx
80104439:	0f 84 81 00 00 00    	je     801044c0 <procdump+0xc0>
    if(p->state == UNUSED)
8010443f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104442:	85 c0                	test   %eax,%eax
80104444:	74 ea                	je     80104430 <procdump+0x30>
      state = "???";
80104446:	ba 8b 7b 10 80       	mov    $0x80107b8b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010444b:	83 f8 05             	cmp    $0x5,%eax
8010444e:	77 11                	ja     80104461 <procdump+0x61>
80104450:	8b 14 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%edx
      state = "???";
80104457:	b8 8b 7b 10 80       	mov    $0x80107b8b,%eax
8010445c:	85 d2                	test   %edx,%edx
8010445e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104461:	53                   	push   %ebx
80104462:	52                   	push   %edx
80104463:	ff 73 a4             	pushl  -0x5c(%ebx)
80104466:	68 8f 7b 10 80       	push   $0x80107b8f
8010446b:	e8 20 c2 ff ff       	call   80100690 <cprintf>
    if(p->state == SLEEPING){
80104470:	83 c4 10             	add    $0x10,%esp
80104473:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104477:	75 a7                	jne    80104420 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104479:	83 ec 08             	sub    $0x8,%esp
8010447c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010447f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104482:	50                   	push   %eax
80104483:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104486:	8b 40 0c             	mov    0xc(%eax),%eax
80104489:	83 c0 08             	add    $0x8,%eax
8010448c:	50                   	push   %eax
8010448d:	e8 fe 01 00 00       	call   80104690 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104492:	83 c4 10             	add    $0x10,%esp
80104495:	8d 76 00             	lea    0x0(%esi),%esi
80104498:	8b 17                	mov    (%edi),%edx
8010449a:	85 d2                	test   %edx,%edx
8010449c:	74 82                	je     80104420 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010449e:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044a1:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044a4:	52                   	push   %edx
801044a5:	68 e1 75 10 80       	push   $0x801075e1
801044aa:	e8 e1 c1 ff ff       	call   80100690 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044af:	83 c4 10             	add    $0x10,%esp
801044b2:	39 fe                	cmp    %edi,%esi
801044b4:	75 e2                	jne    80104498 <procdump+0x98>
801044b6:	e9 65 ff ff ff       	jmp    80104420 <procdump+0x20>
801044bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044bf:	90                   	nop
  }
}
801044c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044c3:	5b                   	pop    %ebx
801044c4:	5e                   	pop    %esi
801044c5:	5f                   	pop    %edi
801044c6:	5d                   	pop    %ebp
801044c7:	c3                   	ret    
801044c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044cf:	90                   	nop

801044d0 <count>:

int
count(int i)
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	83 ec 08             	sub    $0x8,%esp
  if (i > 0)
801044da:	8b 45 08             	mov    0x8(%ebp),%eax
801044dd:	85 c0                	test   %eax,%eax
801044df:	7f 1f                	jg     80104500 <count+0x30>
    countSystemcalls = 0;
    cprintf("Counter reset to zero\n");
    return 22;
  }
  //current count
  cprintf("Systemcall called %d times\n", countSystemcalls);
801044e1:	83 ec 08             	sub    $0x8,%esp
801044e4:	ff 35 20 1d 11 80    	pushl  0x80111d20
801044ea:	68 af 7b 10 80       	push   $0x80107baf
801044ef:	e8 9c c1 ff ff       	call   80100690 <cprintf>
  return 22;
801044f4:	83 c4 10             	add    $0x10,%esp
}
801044f7:	b8 16 00 00 00       	mov    $0x16,%eax
801044fc:	c9                   	leave  
801044fd:	c3                   	ret    
801044fe:	66 90                	xchg   %ax,%ax
    countSystemcalls = 0;
80104500:	c7 05 20 1d 11 80 00 	movl   $0x0,0x80111d20
80104507:	00 00 00 
    cprintf("Counter reset to zero\n");
8010450a:	83 ec 0c             	sub    $0xc,%esp
8010450d:	68 98 7b 10 80       	push   $0x80107b98
80104512:	e8 79 c1 ff ff       	call   80100690 <cprintf>
    return 22;
80104517:	83 c4 10             	add    $0x10,%esp
}
8010451a:	b8 16 00 00 00       	mov    $0x16,%eax
8010451f:	c9                   	leave  
80104520:	c3                   	ret    
80104521:	66 90                	xchg   %ax,%ax
80104523:	66 90                	xchg   %ax,%ax
80104525:	66 90                	xchg   %ax,%ax
80104527:	66 90                	xchg   %ax,%ax
80104529:	66 90                	xchg   %ax,%ax
8010452b:	66 90                	xchg   %ax,%ax
8010452d:	66 90                	xchg   %ax,%ax
8010452f:	90                   	nop

80104530 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	53                   	push   %ebx
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010453e:	68 38 7c 10 80       	push   $0x80107c38
80104543:	8d 43 04             	lea    0x4(%ebx),%eax
80104546:	50                   	push   %eax
80104547:	e8 24 01 00 00       	call   80104670 <initlock>
  lk->name = name;
8010454c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010454f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104555:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104558:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010455f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104565:	c9                   	leave  
80104566:	c3                   	ret    
80104567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456e:	66 90                	xchg   %ax,%ax

80104570 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104570:	f3 0f 1e fb          	endbr32 
80104574:	55                   	push   %ebp
80104575:	89 e5                	mov    %esp,%ebp
80104577:	56                   	push   %esi
80104578:	53                   	push   %ebx
80104579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010457c:	8d 73 04             	lea    0x4(%ebx),%esi
8010457f:	83 ec 0c             	sub    $0xc,%esp
80104582:	56                   	push   %esi
80104583:	e8 e8 02 00 00       	call   80104870 <acquire>
  while (lk->locked) {
80104588:	8b 13                	mov    (%ebx),%edx
8010458a:	83 c4 10             	add    $0x10,%esp
8010458d:	85 d2                	test   %edx,%edx
8010458f:	74 1a                	je     801045ab <acquiresleep+0x3b>
80104591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104598:	83 ec 08             	sub    $0x8,%esp
8010459b:	56                   	push   %esi
8010459c:	53                   	push   %ebx
8010459d:	e8 ae fc ff ff       	call   80104250 <sleep>
  while (lk->locked) {
801045a2:	8b 03                	mov    (%ebx),%eax
801045a4:	83 c4 10             	add    $0x10,%esp
801045a7:	85 c0                	test   %eax,%eax
801045a9:	75 ed                	jne    80104598 <acquiresleep+0x28>
  }
  lk->locked = 1;
801045ab:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045b1:	e8 ba f5 ff ff       	call   80103b70 <myproc>
801045b6:	8b 40 10             	mov    0x10(%eax),%eax
801045b9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045bc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c2:	5b                   	pop    %ebx
801045c3:	5e                   	pop    %esi
801045c4:	5d                   	pop    %ebp
  release(&lk->lk);
801045c5:	e9 36 02 00 00       	jmp    80104800 <release>
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	56                   	push   %esi
801045d8:	53                   	push   %ebx
801045d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045dc:	8d 73 04             	lea    0x4(%ebx),%esi
801045df:	83 ec 0c             	sub    $0xc,%esp
801045e2:	56                   	push   %esi
801045e3:	e8 88 02 00 00       	call   80104870 <acquire>
  lk->locked = 0;
801045e8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045ee:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045f5:	89 1c 24             	mov    %ebx,(%esp)
801045f8:	e8 13 fd ff ff       	call   80104310 <wakeup>
  release(&lk->lk);
801045fd:	89 75 08             	mov    %esi,0x8(%ebp)
80104600:	83 c4 10             	add    $0x10,%esp
}
80104603:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104606:	5b                   	pop    %ebx
80104607:	5e                   	pop    %esi
80104608:	5d                   	pop    %ebp
  release(&lk->lk);
80104609:	e9 f2 01 00 00       	jmp    80104800 <release>
8010460e:	66 90                	xchg   %ax,%ax

80104610 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	57                   	push   %edi
80104618:	31 ff                	xor    %edi,%edi
8010461a:	56                   	push   %esi
8010461b:	53                   	push   %ebx
8010461c:	83 ec 18             	sub    $0x18,%esp
8010461f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104622:	8d 73 04             	lea    0x4(%ebx),%esi
80104625:	56                   	push   %esi
80104626:	e8 45 02 00 00       	call   80104870 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010462b:	8b 03                	mov    (%ebx),%eax
8010462d:	83 c4 10             	add    $0x10,%esp
80104630:	85 c0                	test   %eax,%eax
80104632:	75 1c                	jne    80104650 <holdingsleep+0x40>
  release(&lk->lk);
80104634:	83 ec 0c             	sub    $0xc,%esp
80104637:	56                   	push   %esi
80104638:	e8 c3 01 00 00       	call   80104800 <release>
  return r;
}
8010463d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104640:	89 f8                	mov    %edi,%eax
80104642:	5b                   	pop    %ebx
80104643:	5e                   	pop    %esi
80104644:	5f                   	pop    %edi
80104645:	5d                   	pop    %ebp
80104646:	c3                   	ret    
80104647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104650:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104653:	e8 18 f5 ff ff       	call   80103b70 <myproc>
80104658:	39 58 10             	cmp    %ebx,0x10(%eax)
8010465b:	0f 94 c0             	sete   %al
8010465e:	0f b6 c0             	movzbl %al,%eax
80104661:	89 c7                	mov    %eax,%edi
80104663:	eb cf                	jmp    80104634 <holdingsleep+0x24>
80104665:	66 90                	xchg   %ax,%ax
80104667:	66 90                	xchg   %ax,%ax
80104669:	66 90                	xchg   %ax,%ax
8010466b:	66 90                	xchg   %ax,%ax
8010466d:	66 90                	xchg   %ax,%ax
8010466f:	90                   	nop

80104670 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010467a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010467d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104683:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104686:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010468d:	5d                   	pop    %ebp
8010468e:	c3                   	ret    
8010468f:	90                   	nop

80104690 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104695:	31 d2                	xor    %edx,%edx
{
80104697:	89 e5                	mov    %esp,%ebp
80104699:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010469a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010469d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046a0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046a8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046ae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046b4:	77 1a                	ja     801046d0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046b6:	8b 58 04             	mov    0x4(%eax),%ebx
801046b9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046bc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046c1:	83 fa 0a             	cmp    $0xa,%edx
801046c4:	75 e2                	jne    801046a8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c9:	c9                   	leave  
801046ca:	c3                   	ret    
801046cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046cf:	90                   	nop
  for(; i < 10; i++)
801046d0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046d3:	8d 51 28             	lea    0x28(%ecx),%edx
801046d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801046e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046e6:	83 c0 04             	add    $0x4,%eax
801046e9:	39 d0                	cmp    %edx,%eax
801046eb:	75 f3                	jne    801046e0 <getcallerpcs+0x50>
}
801046ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104700:	f3 0f 1e fb          	endbr32 
80104704:	55                   	push   %ebp
80104705:	89 e5                	mov    %esp,%ebp
80104707:	53                   	push   %ebx
80104708:	83 ec 04             	sub    $0x4,%esp
8010470b:	9c                   	pushf  
8010470c:	5b                   	pop    %ebx
  asm volatile("cli");
8010470d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010470e:	e8 cd f3 ff ff       	call   80103ae0 <mycpu>
80104713:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104719:	85 c0                	test   %eax,%eax
8010471b:	74 13                	je     80104730 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010471d:	e8 be f3 ff ff       	call   80103ae0 <mycpu>
80104722:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104729:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010472c:	c9                   	leave  
8010472d:	c3                   	ret    
8010472e:	66 90                	xchg   %ax,%ax
    mycpu()->intena = eflags & FL_IF;
80104730:	e8 ab f3 ff ff       	call   80103ae0 <mycpu>
80104735:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010473b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104741:	eb da                	jmp    8010471d <pushcli+0x1d>
80104743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <popcli>:

void
popcli(void)
{
80104750:	f3 0f 1e fb          	endbr32 
80104754:	55                   	push   %ebp
80104755:	89 e5                	mov    %esp,%ebp
80104757:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010475a:	9c                   	pushf  
8010475b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010475c:	f6 c4 02             	test   $0x2,%ah
8010475f:	75 31                	jne    80104792 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104761:	e8 7a f3 ff ff       	call   80103ae0 <mycpu>
80104766:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010476d:	78 30                	js     8010479f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010476f:	e8 6c f3 ff ff       	call   80103ae0 <mycpu>
80104774:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010477a:	85 d2                	test   %edx,%edx
8010477c:	74 02                	je     80104780 <popcli+0x30>
    sti();
}
8010477e:	c9                   	leave  
8010477f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104780:	e8 5b f3 ff ff       	call   80103ae0 <mycpu>
80104785:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010478b:	85 c0                	test   %eax,%eax
8010478d:	74 ef                	je     8010477e <popcli+0x2e>
  asm volatile("sti");
8010478f:	fb                   	sti    
}
80104790:	c9                   	leave  
80104791:	c3                   	ret    
    panic("popcli - interruptible");
80104792:	83 ec 0c             	sub    $0xc,%esp
80104795:	68 43 7c 10 80       	push   $0x80107c43
8010479a:	e8 f1 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010479f:	83 ec 0c             	sub    $0xc,%esp
801047a2:	68 5a 7c 10 80       	push   $0x80107c5a
801047a7:	e8 e4 bb ff ff       	call   80100390 <panic>
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <holding>:
{
801047b0:	f3 0f 1e fb          	endbr32 
801047b4:	55                   	push   %ebp
801047b5:	89 e5                	mov    %esp,%ebp
801047b7:	56                   	push   %esi
801047b8:	53                   	push   %ebx
801047b9:	8b 75 08             	mov    0x8(%ebp),%esi
801047bc:	31 db                	xor    %ebx,%ebx
  pushcli();
801047be:	e8 3d ff ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047c3:	8b 06                	mov    (%esi),%eax
801047c5:	85 c0                	test   %eax,%eax
801047c7:	75 0f                	jne    801047d8 <holding+0x28>
  popcli();
801047c9:	e8 82 ff ff ff       	call   80104750 <popcli>
}
801047ce:	89 d8                	mov    %ebx,%eax
801047d0:	5b                   	pop    %ebx
801047d1:	5e                   	pop    %esi
801047d2:	5d                   	pop    %ebp
801047d3:	c3                   	ret    
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801047d8:	8b 5e 08             	mov    0x8(%esi),%ebx
801047db:	e8 00 f3 ff ff       	call   80103ae0 <mycpu>
801047e0:	39 c3                	cmp    %eax,%ebx
801047e2:	0f 94 c3             	sete   %bl
  popcli();
801047e5:	e8 66 ff ff ff       	call   80104750 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801047ea:	0f b6 db             	movzbl %bl,%ebx
}
801047ed:	89 d8                	mov    %ebx,%eax
801047ef:	5b                   	pop    %ebx
801047f0:	5e                   	pop    %esi
801047f1:	5d                   	pop    %ebp
801047f2:	c3                   	ret    
801047f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <release>:
{
80104800:	f3 0f 1e fb          	endbr32 
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	56                   	push   %esi
80104808:	53                   	push   %ebx
80104809:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010480c:	e8 ef fe ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104811:	8b 03                	mov    (%ebx),%eax
80104813:	85 c0                	test   %eax,%eax
80104815:	75 19                	jne    80104830 <release+0x30>
  popcli();
80104817:	e8 34 ff ff ff       	call   80104750 <popcli>
    panic("release");
8010481c:	83 ec 0c             	sub    $0xc,%esp
8010481f:	68 61 7c 10 80       	push   $0x80107c61
80104824:	e8 67 bb ff ff       	call   80100390 <panic>
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104830:	8b 73 08             	mov    0x8(%ebx),%esi
80104833:	e8 a8 f2 ff ff       	call   80103ae0 <mycpu>
80104838:	39 c6                	cmp    %eax,%esi
8010483a:	75 db                	jne    80104817 <release+0x17>
  popcli();
8010483c:	e8 0f ff ff ff       	call   80104750 <popcli>
  lk->pcs[0] = 0;
80104841:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104848:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010484f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104854:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010485a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010485d:	5b                   	pop    %ebx
8010485e:	5e                   	pop    %esi
8010485f:	5d                   	pop    %ebp
  popcli();
80104860:	e9 eb fe ff ff       	jmp    80104750 <popcli>
80104865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <acquire>:
{
80104870:	f3 0f 1e fb          	endbr32 
80104874:	55                   	push   %ebp
80104875:	89 e5                	mov    %esp,%ebp
80104877:	53                   	push   %ebx
80104878:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010487b:	e8 80 fe ff ff       	call   80104700 <pushcli>
  if(holding(lk))
80104880:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104883:	e8 78 fe ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104888:	8b 03                	mov    (%ebx),%eax
8010488a:	85 c0                	test   %eax,%eax
8010488c:	0f 85 86 00 00 00    	jne    80104918 <acquire+0xa8>
  popcli();
80104892:	e8 b9 fe ff ff       	call   80104750 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104897:	b9 01 00 00 00       	mov    $0x1,%ecx
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801048a0:	8b 55 08             	mov    0x8(%ebp),%edx
801048a3:	89 c8                	mov    %ecx,%eax
801048a5:	f0 87 02             	lock xchg %eax,(%edx)
801048a8:	85 c0                	test   %eax,%eax
801048aa:	75 f4                	jne    801048a0 <acquire+0x30>
  __sync_synchronize();
801048ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048b4:	e8 27 f2 ff ff       	call   80103ae0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801048bc:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801048be:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801048c1:	31 c0                	xor    %eax,%eax
801048c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048c8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048d4:	77 1a                	ja     801048f0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801048d6:	8b 5a 04             	mov    0x4(%edx),%ebx
801048d9:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048dd:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048e0:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048e2:	83 f8 0a             	cmp    $0xa,%eax
801048e5:	75 e1                	jne    801048c8 <acquire+0x58>
}
801048e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048ea:	c9                   	leave  
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801048f0:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801048f4:	8d 51 34             	lea    0x34(%ecx),%edx
801048f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104906:	83 c0 04             	add    $0x4,%eax
80104909:	39 c2                	cmp    %eax,%edx
8010490b:	75 f3                	jne    80104900 <acquire+0x90>
}
8010490d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104910:	c9                   	leave  
80104911:	c3                   	ret    
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104918:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010491b:	e8 c0 f1 ff ff       	call   80103ae0 <mycpu>
80104920:	39 c3                	cmp    %eax,%ebx
80104922:	0f 85 6a ff ff ff    	jne    80104892 <acquire+0x22>
  popcli();
80104928:	e8 23 fe ff ff       	call   80104750 <popcli>
    panic("acquire");
8010492d:	83 ec 0c             	sub    $0xc,%esp
80104930:	68 69 7c 10 80       	push   $0x80107c69
80104935:	e8 56 ba ff ff       	call   80100390 <panic>
8010493a:	66 90                	xchg   %ax,%ax
8010493c:	66 90                	xchg   %ax,%ax
8010493e:	66 90                	xchg   %ax,%ax

80104940 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	57                   	push   %edi
80104948:	8b 55 08             	mov    0x8(%ebp),%edx
8010494b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010494e:	53                   	push   %ebx
8010494f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104952:	89 d7                	mov    %edx,%edi
80104954:	09 cf                	or     %ecx,%edi
80104956:	83 e7 03             	and    $0x3,%edi
80104959:	75 25                	jne    80104980 <memset+0x40>
    c &= 0xFF;
8010495b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010495e:	c1 e0 18             	shl    $0x18,%eax
80104961:	89 fb                	mov    %edi,%ebx
80104963:	c1 e9 02             	shr    $0x2,%ecx
80104966:	c1 e3 10             	shl    $0x10,%ebx
80104969:	09 d8                	or     %ebx,%eax
8010496b:	09 f8                	or     %edi,%eax
8010496d:	c1 e7 08             	shl    $0x8,%edi
80104970:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104972:	89 d7                	mov    %edx,%edi
80104974:	fc                   	cld    
80104975:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104977:	5b                   	pop    %ebx
80104978:	89 d0                	mov    %edx,%eax
8010497a:	5f                   	pop    %edi
8010497b:	5d                   	pop    %ebp
8010497c:	c3                   	ret    
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104980:	89 d7                	mov    %edx,%edi
80104982:	fc                   	cld    
80104983:	f3 aa                	rep stos %al,%es:(%edi)
80104985:	5b                   	pop    %ebx
80104986:	89 d0                	mov    %edx,%eax
80104988:	5f                   	pop    %edi
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    
8010498b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010498f:	90                   	nop

80104990 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104990:	f3 0f 1e fb          	endbr32 
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	56                   	push   %esi
80104998:	8b 75 10             	mov    0x10(%ebp),%esi
8010499b:	8b 55 08             	mov    0x8(%ebp),%edx
8010499e:	53                   	push   %ebx
8010499f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049a2:	85 f6                	test   %esi,%esi
801049a4:	74 2a                	je     801049d0 <memcmp+0x40>
801049a6:	01 c6                	add    %eax,%esi
801049a8:	eb 10                	jmp    801049ba <memcmp+0x2a>
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049b0:	83 c0 01             	add    $0x1,%eax
801049b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049b6:	39 f0                	cmp    %esi,%eax
801049b8:	74 16                	je     801049d0 <memcmp+0x40>
    if(*s1 != *s2)
801049ba:	0f b6 0a             	movzbl (%edx),%ecx
801049bd:	0f b6 18             	movzbl (%eax),%ebx
801049c0:	38 d9                	cmp    %bl,%cl
801049c2:	74 ec                	je     801049b0 <memcmp+0x20>
      return *s1 - *s2;
801049c4:	0f b6 c1             	movzbl %cl,%eax
801049c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049c9:	5b                   	pop    %ebx
801049ca:	5e                   	pop    %esi
801049cb:	5d                   	pop    %ebp
801049cc:	c3                   	ret    
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
801049d0:	5b                   	pop    %ebx
  return 0;
801049d1:	31 c0                	xor    %eax,%eax
}
801049d3:	5e                   	pop    %esi
801049d4:	5d                   	pop    %ebp
801049d5:	c3                   	ret    
801049d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049dd:	8d 76 00             	lea    0x0(%esi),%esi

801049e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	57                   	push   %edi
801049e8:	8b 55 08             	mov    0x8(%ebp),%edx
801049eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ee:	56                   	push   %esi
801049ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049f2:	39 d6                	cmp    %edx,%esi
801049f4:	73 2a                	jae    80104a20 <memmove+0x40>
801049f6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801049f9:	39 fa                	cmp    %edi,%edx
801049fb:	73 23                	jae    80104a20 <memmove+0x40>
801049fd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a00:	85 c9                	test   %ecx,%ecx
80104a02:	74 10                	je     80104a14 <memmove+0x34>
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104a08:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a0c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a0f:	83 e8 01             	sub    $0x1,%eax
80104a12:	73 f4                	jae    80104a08 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a14:	5e                   	pop    %esi
80104a15:	89 d0                	mov    %edx,%eax
80104a17:	5f                   	pop    %edi
80104a18:	5d                   	pop    %ebp
80104a19:	c3                   	ret    
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a20:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a23:	89 d7                	mov    %edx,%edi
80104a25:	85 c9                	test   %ecx,%ecx
80104a27:	74 eb                	je     80104a14 <memmove+0x34>
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a30:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a31:	39 f0                	cmp    %esi,%eax
80104a33:	75 fb                	jne    80104a30 <memmove+0x50>
}
80104a35:	5e                   	pop    %esi
80104a36:	89 d0                	mov    %edx,%eax
80104a38:	5f                   	pop    %edi
80104a39:	5d                   	pop    %ebp
80104a3a:	c3                   	ret    
80104a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a3f:	90                   	nop

80104a40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a40:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104a44:	eb 9a                	jmp    801049e0 <memmove>
80104a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi

80104a50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	56                   	push   %esi
80104a58:	8b 75 10             	mov    0x10(%ebp),%esi
80104a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a5e:	53                   	push   %ebx
80104a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104a62:	85 f6                	test   %esi,%esi
80104a64:	74 32                	je     80104a98 <strncmp+0x48>
80104a66:	01 c6                	add    %eax,%esi
80104a68:	eb 14                	jmp    80104a7e <strncmp+0x2e>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a70:	38 da                	cmp    %bl,%dl
80104a72:	75 14                	jne    80104a88 <strncmp+0x38>
    n--, p++, q++;
80104a74:	83 c0 01             	add    $0x1,%eax
80104a77:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a7a:	39 f0                	cmp    %esi,%eax
80104a7c:	74 1a                	je     80104a98 <strncmp+0x48>
80104a7e:	0f b6 11             	movzbl (%ecx),%edx
80104a81:	0f b6 18             	movzbl (%eax),%ebx
80104a84:	84 d2                	test   %dl,%dl
80104a86:	75 e8                	jne    80104a70 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a88:	0f b6 c2             	movzbl %dl,%eax
80104a8b:	29 d8                	sub    %ebx,%eax
}
80104a8d:	5b                   	pop    %ebx
80104a8e:	5e                   	pop    %esi
80104a8f:	5d                   	pop    %ebp
80104a90:	c3                   	ret    
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a98:	5b                   	pop    %ebx
    return 0;
80104a99:	31 c0                	xor    %eax,%eax
}
80104a9b:	5e                   	pop    %esi
80104a9c:	5d                   	pop    %ebp
80104a9d:	c3                   	ret    
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	57                   	push   %edi
80104aa8:	56                   	push   %esi
80104aa9:	8b 75 08             	mov    0x8(%ebp),%esi
80104aac:	53                   	push   %ebx
80104aad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ab0:	89 f2                	mov    %esi,%edx
80104ab2:	eb 1b                	jmp    80104acf <strncpy+0x2f>
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ab8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104abc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104abf:	83 c2 01             	add    $0x1,%edx
80104ac2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104ac6:	89 f9                	mov    %edi,%ecx
80104ac8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104acb:	84 c9                	test   %cl,%cl
80104acd:	74 09                	je     80104ad8 <strncpy+0x38>
80104acf:	89 c3                	mov    %eax,%ebx
80104ad1:	83 e8 01             	sub    $0x1,%eax
80104ad4:	85 db                	test   %ebx,%ebx
80104ad6:	7f e0                	jg     80104ab8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ad8:	89 d1                	mov    %edx,%ecx
80104ada:	85 c0                	test   %eax,%eax
80104adc:	7e 15                	jle    80104af3 <strncpy+0x53>
80104ade:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104ae0:	83 c1 01             	add    $0x1,%ecx
80104ae3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104ae7:	89 c8                	mov    %ecx,%eax
80104ae9:	f7 d0                	not    %eax
80104aeb:	01 d0                	add    %edx,%eax
80104aed:	01 d8                	add    %ebx,%eax
80104aef:	85 c0                	test   %eax,%eax
80104af1:	7f ed                	jg     80104ae0 <strncpy+0x40>
  return os;
}
80104af3:	5b                   	pop    %ebx
80104af4:	89 f0                	mov    %esi,%eax
80104af6:	5e                   	pop    %esi
80104af7:	5f                   	pop    %edi
80104af8:	5d                   	pop    %ebp
80104af9:	c3                   	ret    
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	56                   	push   %esi
80104b08:	8b 55 10             	mov    0x10(%ebp),%edx
80104b0b:	8b 75 08             	mov    0x8(%ebp),%esi
80104b0e:	53                   	push   %ebx
80104b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b12:	85 d2                	test   %edx,%edx
80104b14:	7e 21                	jle    80104b37 <safestrcpy+0x37>
80104b16:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b1a:	89 f2                	mov    %esi,%edx
80104b1c:	eb 12                	jmp    80104b30 <safestrcpy+0x30>
80104b1e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b20:	0f b6 08             	movzbl (%eax),%ecx
80104b23:	83 c0 01             	add    $0x1,%eax
80104b26:	83 c2 01             	add    $0x1,%edx
80104b29:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b2c:	84 c9                	test   %cl,%cl
80104b2e:	74 04                	je     80104b34 <safestrcpy+0x34>
80104b30:	39 d8                	cmp    %ebx,%eax
80104b32:	75 ec                	jne    80104b20 <safestrcpy+0x20>
    ;
  *s = 0;
80104b34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b37:	89 f0                	mov    %esi,%eax
80104b39:	5b                   	pop    %ebx
80104b3a:	5e                   	pop    %esi
80104b3b:	5d                   	pop    %ebp
80104b3c:	c3                   	ret    
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi

80104b40 <strlen>:

int
strlen(const char *s)
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b45:	31 c0                	xor    %eax,%eax
{
80104b47:	89 e5                	mov    %esp,%ebp
80104b49:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b4c:	80 3a 00             	cmpb   $0x0,(%edx)
80104b4f:	74 10                	je     80104b61 <strlen+0x21>
80104b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b58:	83 c0 01             	add    $0x1,%eax
80104b5b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b5f:	75 f7                	jne    80104b58 <strlen+0x18>
    ;
  return n;
}
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    

80104b63 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b63:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b67:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b6b:	55                   	push   %ebp
  pushl %ebx
80104b6c:	53                   	push   %ebx
  pushl %esi
80104b6d:	56                   	push   %esi
  pushl %edi
80104b6e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b6f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b71:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b73:	5f                   	pop    %edi
  popl %esi
80104b74:	5e                   	pop    %esi
  popl %ebx
80104b75:	5b                   	pop    %ebx
  popl %ebp
80104b76:	5d                   	pop    %ebp
  ret
80104b77:	c3                   	ret    
80104b78:	66 90                	xchg   %ax,%ax
80104b7a:	66 90                	xchg   %ax,%ax
80104b7c:	66 90                	xchg   %ax,%ax
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	53                   	push   %ebx
80104b88:	83 ec 04             	sub    $0x4,%esp
80104b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b8e:	e8 dd ef ff ff       	call   80103b70 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b93:	8b 00                	mov    (%eax),%eax
80104b95:	39 d8                	cmp    %ebx,%eax
80104b97:	76 17                	jbe    80104bb0 <fetchint+0x30>
80104b99:	8d 53 04             	lea    0x4(%ebx),%edx
80104b9c:	39 d0                	cmp    %edx,%eax
80104b9e:	72 10                	jb     80104bb0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba3:	8b 13                	mov    (%ebx),%edx
80104ba5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ba7:	31 c0                	xor    %eax,%eax
}
80104ba9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bac:	c9                   	leave  
80104bad:	c3                   	ret    
80104bae:	66 90                	xchg   %ax,%ax
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb5:	eb f2                	jmp    80104ba9 <fetchint+0x29>
80104bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	53                   	push   %ebx
80104bc8:	83 ec 04             	sub    $0x4,%esp
80104bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bce:	e8 9d ef ff ff       	call   80103b70 <myproc>

  if(addr >= curproc->sz)
80104bd3:	39 18                	cmp    %ebx,(%eax)
80104bd5:	76 31                	jbe    80104c08 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bda:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bdc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bde:	39 d3                	cmp    %edx,%ebx
80104be0:	73 26                	jae    80104c08 <fetchstr+0x48>
80104be2:	89 d8                	mov    %ebx,%eax
80104be4:	eb 11                	jmp    80104bf7 <fetchstr+0x37>
80104be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
80104bf0:	83 c0 01             	add    $0x1,%eax
80104bf3:	39 c2                	cmp    %eax,%edx
80104bf5:	76 11                	jbe    80104c08 <fetchstr+0x48>
    if(*s == 0)
80104bf7:	80 38 00             	cmpb   $0x0,(%eax)
80104bfa:	75 f4                	jne    80104bf0 <fetchstr+0x30>
      return s - *pp;
80104bfc:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104bfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c01:	c9                   	leave  
80104c02:	c3                   	ret    
80104c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c07:	90                   	nop
80104c08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c10:	c9                   	leave  
80104c11:	c3                   	ret    
80104c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c20:	f3 0f 1e fb          	endbr32 
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	56                   	push   %esi
80104c28:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c29:	e8 42 ef ff ff       	call   80103b70 <myproc>
80104c2e:	8b 55 08             	mov    0x8(%ebp),%edx
80104c31:	8b 40 18             	mov    0x18(%eax),%eax
80104c34:	8b 40 44             	mov    0x44(%eax),%eax
80104c37:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c3a:	e8 31 ef ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c42:	8b 00                	mov    (%eax),%eax
80104c44:	39 c6                	cmp    %eax,%esi
80104c46:	73 18                	jae    80104c60 <argint+0x40>
80104c48:	8d 53 08             	lea    0x8(%ebx),%edx
80104c4b:	39 d0                	cmp    %edx,%eax
80104c4d:	72 11                	jb     80104c60 <argint+0x40>
  *ip = *(int*)(addr);
80104c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c52:	8b 53 04             	mov    0x4(%ebx),%edx
80104c55:	89 10                	mov    %edx,(%eax)
  return 0;
80104c57:	31 c0                	xor    %eax,%eax
}
80104c59:	5b                   	pop    %ebx
80104c5a:	5e                   	pop    %esi
80104c5b:	5d                   	pop    %ebp
80104c5c:	c3                   	ret    
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c65:	eb f2                	jmp    80104c59 <argint+0x39>
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	57                   	push   %edi
80104c78:	56                   	push   %esi
80104c79:	53                   	push   %ebx
80104c7a:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c7d:	e8 ee ee ff ff       	call   80103b70 <myproc>
80104c82:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c84:	e8 e7 ee ff ff       	call   80103b70 <myproc>
80104c89:	8b 55 08             	mov    0x8(%ebp),%edx
80104c8c:	8b 40 18             	mov    0x18(%eax),%eax
80104c8f:	8b 40 44             	mov    0x44(%eax),%eax
80104c92:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c95:	e8 d6 ee ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c9a:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c9d:	8b 00                	mov    (%eax),%eax
80104c9f:	39 c7                	cmp    %eax,%edi
80104ca1:	73 35                	jae    80104cd8 <argptr+0x68>
80104ca3:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ca6:	39 c8                	cmp    %ecx,%eax
80104ca8:	72 2e                	jb     80104cd8 <argptr+0x68>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104caa:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104cad:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cb0:	85 d2                	test   %edx,%edx
80104cb2:	78 24                	js     80104cd8 <argptr+0x68>
80104cb4:	8b 16                	mov    (%esi),%edx
80104cb6:	39 c2                	cmp    %eax,%edx
80104cb8:	76 1e                	jbe    80104cd8 <argptr+0x68>
80104cba:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104cbd:	01 c3                	add    %eax,%ebx
80104cbf:	39 da                	cmp    %ebx,%edx
80104cc1:	72 15                	jb     80104cd8 <argptr+0x68>
    return -1;
  *pp = (char*)i;
80104cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cc6:	89 02                	mov    %eax,(%edx)
  return 0;
80104cc8:	31 c0                	xor    %eax,%eax
}
80104cca:	83 c4 0c             	add    $0xc,%esp
80104ccd:	5b                   	pop    %ebx
80104cce:	5e                   	pop    %esi
80104ccf:	5f                   	pop    %edi
80104cd0:	5d                   	pop    %ebp
80104cd1:	c3                   	ret    
80104cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cdd:	eb eb                	jmp    80104cca <argptr+0x5a>
80104cdf:	90                   	nop

80104ce0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	56                   	push   %esi
80104ce8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce9:	e8 82 ee ff ff       	call   80103b70 <myproc>
80104cee:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf1:	8b 40 18             	mov    0x18(%eax),%eax
80104cf4:	8b 40 44             	mov    0x44(%eax),%eax
80104cf7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cfa:	e8 71 ee ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d02:	8b 00                	mov    (%eax),%eax
80104d04:	39 c6                	cmp    %eax,%esi
80104d06:	73 40                	jae    80104d48 <argstr+0x68>
80104d08:	8d 53 08             	lea    0x8(%ebx),%edx
80104d0b:	39 d0                	cmp    %edx,%eax
80104d0d:	72 39                	jb     80104d48 <argstr+0x68>
  *ip = *(int*)(addr);
80104d0f:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d12:	e8 59 ee ff ff       	call   80103b70 <myproc>
  if(addr >= curproc->sz)
80104d17:	3b 18                	cmp    (%eax),%ebx
80104d19:	73 2d                	jae    80104d48 <argstr+0x68>
  *pp = (char*)addr;
80104d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d1e:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d20:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d22:	39 d3                	cmp    %edx,%ebx
80104d24:	73 22                	jae    80104d48 <argstr+0x68>
80104d26:	89 d8                	mov    %ebx,%eax
80104d28:	eb 0d                	jmp    80104d37 <argstr+0x57>
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d30:	83 c0 01             	add    $0x1,%eax
80104d33:	39 c2                	cmp    %eax,%edx
80104d35:	76 11                	jbe    80104d48 <argstr+0x68>
    if(*s == 0)
80104d37:	80 38 00             	cmpb   $0x0,(%eax)
80104d3a:	75 f4                	jne    80104d30 <argstr+0x50>
      return s - *pp;
80104d3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d3e:	5b                   	pop    %ebx
80104d3f:	5e                   	pop    %esi
80104d40:	5d                   	pop    %ebp
80104d41:	c3                   	ret    
80104d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d48:	5b                   	pop    %ebx
    return -1;
80104d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d4e:	5e                   	pop    %esi
80104d4f:	5d                   	pop    %ebp
80104d50:	c3                   	ret    
80104d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop

80104d60 <syscall>:
[SYS_count]   sys_count,
};

void
syscall(void)
{
80104d60:	f3 0f 1e fb          	endbr32 
80104d64:	55                   	push   %ebp
80104d65:	89 e5                	mov    %esp,%ebp
80104d67:	53                   	push   %ebx
80104d68:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d6b:	e8 00 ee ff ff       	call   80103b70 <myproc>
80104d70:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d72:	8b 40 18             	mov    0x18(%eax),%eax
80104d75:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d78:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d7b:	83 fa 15             	cmp    $0x15,%edx
80104d7e:	77 30                	ja     80104db0 <syscall+0x50>
80104d80:	8b 14 85 a0 7c 10 80 	mov    -0x7fef8360(,%eax,4),%edx
80104d87:	85 d2                	test   %edx,%edx
80104d89:	74 25                	je     80104db0 <syscall+0x50>

  //+1 to counter if systemcall is read
  if (num==SYS_read){
80104d8b:	83 f8 05             	cmp    $0x5,%eax
80104d8e:	75 07                	jne    80104d97 <syscall+0x37>
    countSystemcalls++;
80104d90:	83 05 20 1d 11 80 01 	addl   $0x1,0x80111d20
  }
    curproc->tf->eax = syscalls[num]();
80104d97:	ff d2                	call   *%edx
80104d99:	89 c2                	mov    %eax,%edx
80104d9b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104da4:	c9                   	leave  
80104da5:	c3                   	ret    
80104da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104db0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104db1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104db4:	50                   	push   %eax
80104db5:	ff 73 10             	pushl  0x10(%ebx)
80104db8:	68 71 7c 10 80       	push   $0x80107c71
80104dbd:	e8 ce b8 ff ff       	call   80100690 <cprintf>
    curproc->tf->eax = -1;
80104dc2:	8b 43 18             	mov    0x18(%ebx),%eax
80104dc5:	83 c4 10             	add    $0x10,%esp
80104dc8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104dcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dd2:	c9                   	leave  
80104dd3:	c3                   	ret    
80104dd4:	66 90                	xchg   %ax,%ax
80104dd6:	66 90                	xchg   %ax,%ax
80104dd8:	66 90                	xchg   %ax,%ax
80104dda:	66 90                	xchg   %ax,%ax
80104ddc:	66 90                	xchg   %ax,%ax
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104de5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104de8:	53                   	push   %ebx
80104de9:	83 ec 34             	sub    $0x34,%esp
80104dec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104def:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104df2:	57                   	push   %edi
80104df3:	50                   	push   %eax
{
80104df4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104df7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104dfa:	e8 31 d4 ff ff       	call   80102230 <nameiparent>
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	85 c0                	test   %eax,%eax
80104e04:	0f 84 46 01 00 00    	je     80104f50 <create+0x170>
    return 0;
  ilock(dp);
80104e0a:	83 ec 0c             	sub    $0xc,%esp
80104e0d:	89 c3                	mov    %eax,%ebx
80104e0f:	50                   	push   %eax
80104e10:	e8 bb ca ff ff       	call   801018d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e15:	83 c4 0c             	add    $0xc,%esp
80104e18:	6a 00                	push   $0x0
80104e1a:	57                   	push   %edi
80104e1b:	53                   	push   %ebx
80104e1c:	e8 1f d0 ff ff       	call   80101e40 <dirlookup>
80104e21:	83 c4 10             	add    $0x10,%esp
80104e24:	89 c6                	mov    %eax,%esi
80104e26:	85 c0                	test   %eax,%eax
80104e28:	74 56                	je     80104e80 <create+0xa0>
    iunlockput(dp);
80104e2a:	83 ec 0c             	sub    $0xc,%esp
80104e2d:	53                   	push   %ebx
80104e2e:	e8 2d cd ff ff       	call   80101b60 <iunlockput>
    ilock(ip);
80104e33:	89 34 24             	mov    %esi,(%esp)
80104e36:	e8 95 ca ff ff       	call   801018d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e3b:	83 c4 10             	add    $0x10,%esp
80104e3e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e43:	75 1b                	jne    80104e60 <create+0x80>
80104e45:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e4a:	75 14                	jne    80104e60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e4f:	89 f0                	mov    %esi,%eax
80104e51:	5b                   	pop    %ebx
80104e52:	5e                   	pop    %esi
80104e53:	5f                   	pop    %edi
80104e54:	5d                   	pop    %ebp
80104e55:	c3                   	ret    
80104e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e60:	83 ec 0c             	sub    $0xc,%esp
80104e63:	56                   	push   %esi
    return 0;
80104e64:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e66:	e8 f5 cc ff ff       	call   80101b60 <iunlockput>
    return 0;
80104e6b:	83 c4 10             	add    $0x10,%esp
}
80104e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e71:	89 f0                	mov    %esi,%eax
80104e73:	5b                   	pop    %ebx
80104e74:	5e                   	pop    %esi
80104e75:	5f                   	pop    %edi
80104e76:	5d                   	pop    %ebp
80104e77:	c3                   	ret    
80104e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e84:	83 ec 08             	sub    $0x8,%esp
80104e87:	50                   	push   %eax
80104e88:	ff 33                	pushl  (%ebx)
80104e8a:	e8 c1 c8 ff ff       	call   80101750 <ialloc>
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	89 c6                	mov    %eax,%esi
80104e94:	85 c0                	test   %eax,%eax
80104e96:	0f 84 cd 00 00 00    	je     80104f69 <create+0x189>
  ilock(ip);
80104e9c:	83 ec 0c             	sub    $0xc,%esp
80104e9f:	50                   	push   %eax
80104ea0:	e8 2b ca ff ff       	call   801018d0 <ilock>
  ip->major = major;
80104ea5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ea9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ead:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104eb1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104eb5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104ebe:	89 34 24             	mov    %esi,(%esp)
80104ec1:	e8 4a c9 ff ff       	call   80101810 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ec6:	83 c4 10             	add    $0x10,%esp
80104ec9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104ece:	74 30                	je     80104f00 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ed0:	83 ec 04             	sub    $0x4,%esp
80104ed3:	ff 76 04             	pushl  0x4(%esi)
80104ed6:	57                   	push   %edi
80104ed7:	53                   	push   %ebx
80104ed8:	e8 73 d2 ff ff       	call   80102150 <dirlink>
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	78 78                	js     80104f5c <create+0x17c>
  iunlockput(dp);
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	53                   	push   %ebx
80104ee8:	e8 73 cc ff ff       	call   80101b60 <iunlockput>
  return ip;
80104eed:	83 c4 10             	add    $0x10,%esp
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef3:	89 f0                	mov    %esi,%eax
80104ef5:	5b                   	pop    %ebx
80104ef6:	5e                   	pop    %esi
80104ef7:	5f                   	pop    %edi
80104ef8:	5d                   	pop    %ebp
80104ef9:	c3                   	ret    
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f08:	53                   	push   %ebx
80104f09:	e8 02 c9 ff ff       	call   80101810 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f0e:	83 c4 0c             	add    $0xc,%esp
80104f11:	ff 76 04             	pushl  0x4(%esi)
80104f14:	68 18 7d 10 80       	push   $0x80107d18
80104f19:	56                   	push   %esi
80104f1a:	e8 31 d2 ff ff       	call   80102150 <dirlink>
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	85 c0                	test   %eax,%eax
80104f24:	78 18                	js     80104f3e <create+0x15e>
80104f26:	83 ec 04             	sub    $0x4,%esp
80104f29:	ff 73 04             	pushl  0x4(%ebx)
80104f2c:	68 17 7d 10 80       	push   $0x80107d17
80104f31:	56                   	push   %esi
80104f32:	e8 19 d2 ff ff       	call   80102150 <dirlink>
80104f37:	83 c4 10             	add    $0x10,%esp
80104f3a:	85 c0                	test   %eax,%eax
80104f3c:	79 92                	jns    80104ed0 <create+0xf0>
      panic("create dots");
80104f3e:	83 ec 0c             	sub    $0xc,%esp
80104f41:	68 0b 7d 10 80       	push   $0x80107d0b
80104f46:	e8 45 b4 ff ff       	call   80100390 <panic>
80104f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f4f:	90                   	nop
}
80104f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f53:	31 f6                	xor    %esi,%esi
}
80104f55:	5b                   	pop    %ebx
80104f56:	89 f0                	mov    %esi,%eax
80104f58:	5e                   	pop    %esi
80104f59:	5f                   	pop    %edi
80104f5a:	5d                   	pop    %ebp
80104f5b:	c3                   	ret    
    panic("create: dirlink");
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	68 1a 7d 10 80       	push   $0x80107d1a
80104f64:	e8 27 b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104f69:	83 ec 0c             	sub    $0xc,%esp
80104f6c:	68 fc 7c 10 80       	push   $0x80107cfc
80104f71:	e8 1a b4 ff ff       	call   80100390 <panic>
80104f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi

80104f80 <sys_dup>:
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	56                   	push   %esi
80104f88:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f89:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f8c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f8f:	50                   	push   %eax
80104f90:	6a 00                	push   $0x0
80104f92:	e8 89 fc ff ff       	call   80104c20 <argint>
80104f97:	83 c4 10             	add    $0x10,%esp
80104f9a:	85 c0                	test   %eax,%eax
80104f9c:	78 32                	js     80104fd0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fa2:	77 2c                	ja     80104fd0 <sys_dup+0x50>
80104fa4:	e8 c7 eb ff ff       	call   80103b70 <myproc>
80104fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fac:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fb0:	85 f6                	test   %esi,%esi
80104fb2:	74 1c                	je     80104fd0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104fb4:	e8 b7 eb ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104fb9:	31 db                	xor    %ebx,%ebx
80104fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fbf:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104fc0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fc4:	85 d2                	test   %edx,%edx
80104fc6:	74 18                	je     80104fe0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104fc8:	83 c3 01             	add    $0x1,%ebx
80104fcb:	83 fb 10             	cmp    $0x10,%ebx
80104fce:	75 f0                	jne    80104fc0 <sys_dup+0x40>
}
80104fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fd8:	89 d8                	mov    %ebx,%eax
80104fda:	5b                   	pop    %ebx
80104fdb:	5e                   	pop    %esi
80104fdc:	5d                   	pop    %ebp
80104fdd:	c3                   	ret    
80104fde:	66 90                	xchg   %ax,%ax
  filedup(f);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104fe3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fe7:	56                   	push   %esi
80104fe8:	e8 e3 bf ff ff       	call   80100fd0 <filedup>
  return fd;
80104fed:	83 c4 10             	add    $0x10,%esp
}
80104ff0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff3:	89 d8                	mov    %ebx,%eax
80104ff5:	5b                   	pop    %ebx
80104ff6:	5e                   	pop    %esi
80104ff7:	5d                   	pop    %ebp
80104ff8:	c3                   	ret    
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105000 <sys_read>:
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	56                   	push   %esi
80105008:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105009:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
8010500c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010500f:	53                   	push   %ebx
80105010:	6a 00                	push   $0x0
80105012:	e8 09 fc ff ff       	call   80104c20 <argint>
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	85 c0                	test   %eax,%eax
8010501c:	78 62                	js     80105080 <sys_read+0x80>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010501e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105022:	77 5c                	ja     80105080 <sys_read+0x80>
80105024:	e8 47 eb ff ff       	call   80103b70 <myproc>
80105029:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010502c:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105030:	85 f6                	test   %esi,%esi
80105032:	74 4c                	je     80105080 <sys_read+0x80>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105034:	83 ec 08             	sub    $0x8,%esp
80105037:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010503a:	50                   	push   %eax
8010503b:	6a 02                	push   $0x2
8010503d:	e8 de fb ff ff       	call   80104c20 <argint>
80105042:	83 c4 10             	add    $0x10,%esp
80105045:	85 c0                	test   %eax,%eax
80105047:	78 37                	js     80105080 <sys_read+0x80>
80105049:	83 ec 04             	sub    $0x4,%esp
8010504c:	ff 75 f0             	pushl  -0x10(%ebp)
8010504f:	53                   	push   %ebx
80105050:	6a 01                	push   $0x1
80105052:	e8 19 fc ff ff       	call   80104c70 <argptr>
80105057:	83 c4 10             	add    $0x10,%esp
8010505a:	85 c0                	test   %eax,%eax
8010505c:	78 22                	js     80105080 <sys_read+0x80>
  return fileread(f, p, n);
8010505e:	83 ec 04             	sub    $0x4,%esp
80105061:	ff 75 f0             	pushl  -0x10(%ebp)
80105064:	ff 75 f4             	pushl  -0xc(%ebp)
80105067:	56                   	push   %esi
80105068:	e8 e3 c0 ff ff       	call   80101150 <fileread>
8010506d:	83 c4 10             	add    $0x10,%esp
}
80105070:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105073:	5b                   	pop    %ebx
80105074:	5e                   	pop    %esi
80105075:	5d                   	pop    %ebp
80105076:	c3                   	ret    
80105077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507e:	66 90                	xchg   %ax,%ax
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105085:	eb e9                	jmp    80105070 <sys_read+0x70>
80105087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508e:	66 90                	xchg   %ax,%ax

80105090 <sys_write>:
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	56                   	push   %esi
80105098:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105099:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
8010509c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010509f:	53                   	push   %ebx
801050a0:	6a 00                	push   $0x0
801050a2:	e8 79 fb ff ff       	call   80104c20 <argint>
801050a7:	83 c4 10             	add    $0x10,%esp
801050aa:	85 c0                	test   %eax,%eax
801050ac:	78 62                	js     80105110 <sys_write+0x80>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050b2:	77 5c                	ja     80105110 <sys_write+0x80>
801050b4:	e8 b7 ea ff ff       	call   80103b70 <myproc>
801050b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050bc:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050c0:	85 f6                	test   %esi,%esi
801050c2:	74 4c                	je     80105110 <sys_write+0x80>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c4:	83 ec 08             	sub    $0x8,%esp
801050c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050ca:	50                   	push   %eax
801050cb:	6a 02                	push   $0x2
801050cd:	e8 4e fb ff ff       	call   80104c20 <argint>
801050d2:	83 c4 10             	add    $0x10,%esp
801050d5:	85 c0                	test   %eax,%eax
801050d7:	78 37                	js     80105110 <sys_write+0x80>
801050d9:	83 ec 04             	sub    $0x4,%esp
801050dc:	ff 75 f0             	pushl  -0x10(%ebp)
801050df:	53                   	push   %ebx
801050e0:	6a 01                	push   $0x1
801050e2:	e8 89 fb ff ff       	call   80104c70 <argptr>
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	85 c0                	test   %eax,%eax
801050ec:	78 22                	js     80105110 <sys_write+0x80>
  return filewrite(f, p, n);
801050ee:	83 ec 04             	sub    $0x4,%esp
801050f1:	ff 75 f0             	pushl  -0x10(%ebp)
801050f4:	ff 75 f4             	pushl  -0xc(%ebp)
801050f7:	56                   	push   %esi
801050f8:	e8 f3 c0 ff ff       	call   801011f0 <filewrite>
801050fd:	83 c4 10             	add    $0x10,%esp
}
80105100:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105103:	5b                   	pop    %ebx
80105104:	5e                   	pop    %esi
80105105:	5d                   	pop    %ebp
80105106:	c3                   	ret    
80105107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510e:	66 90                	xchg   %ax,%ax
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb e9                	jmp    80105100 <sys_write+0x70>
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <sys_close>:
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	56                   	push   %esi
80105128:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105129:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010512c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010512f:	50                   	push   %eax
80105130:	6a 00                	push   $0x0
80105132:	e8 e9 fa ff ff       	call   80104c20 <argint>
80105137:	83 c4 10             	add    $0x10,%esp
8010513a:	85 c0                	test   %eax,%eax
8010513c:	78 42                	js     80105180 <sys_close+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010513e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105142:	77 3c                	ja     80105180 <sys_close+0x60>
80105144:	e8 27 ea ff ff       	call   80103b70 <myproc>
80105149:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010514c:	8d 5a 08             	lea    0x8(%edx),%ebx
8010514f:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105153:	85 f6                	test   %esi,%esi
80105155:	74 29                	je     80105180 <sys_close+0x60>
  myproc()->ofile[fd] = 0;
80105157:	e8 14 ea ff ff       	call   80103b70 <myproc>
  fileclose(f);
8010515c:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010515f:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105166:	00 
  fileclose(f);
80105167:	56                   	push   %esi
80105168:	e8 b3 be ff ff       	call   80101020 <fileclose>
  return 0;
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	31 c0                	xor    %eax,%eax
}
80105172:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105175:	5b                   	pop    %ebx
80105176:	5e                   	pop    %esi
80105177:	5d                   	pop    %ebp
80105178:	c3                   	ret    
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105185:	eb eb                	jmp    80105172 <sys_close+0x52>
80105187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518e:	66 90                	xchg   %ax,%ax

80105190 <sys_fstat>:
{
80105190:	f3 0f 1e fb          	endbr32 
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	56                   	push   %esi
80105198:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105199:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
8010519c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010519f:	53                   	push   %ebx
801051a0:	6a 00                	push   $0x0
801051a2:	e8 79 fa ff ff       	call   80104c20 <argint>
801051a7:	83 c4 10             	add    $0x10,%esp
801051aa:	85 c0                	test   %eax,%eax
801051ac:	78 42                	js     801051f0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051b2:	77 3c                	ja     801051f0 <sys_fstat+0x60>
801051b4:	e8 b7 e9 ff ff       	call   80103b70 <myproc>
801051b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051bc:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801051c0:	85 f6                	test   %esi,%esi
801051c2:	74 2c                	je     801051f0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051c4:	83 ec 04             	sub    $0x4,%esp
801051c7:	6a 14                	push   $0x14
801051c9:	53                   	push   %ebx
801051ca:	6a 01                	push   $0x1
801051cc:	e8 9f fa ff ff       	call   80104c70 <argptr>
801051d1:	83 c4 10             	add    $0x10,%esp
801051d4:	85 c0                	test   %eax,%eax
801051d6:	78 18                	js     801051f0 <sys_fstat+0x60>
  return filestat(f, st);
801051d8:	83 ec 08             	sub    $0x8,%esp
801051db:	ff 75 f4             	pushl  -0xc(%ebp)
801051de:	56                   	push   %esi
801051df:	e8 1c bf ff ff       	call   80101100 <filestat>
801051e4:	83 c4 10             	add    $0x10,%esp
}
801051e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ea:	5b                   	pop    %ebx
801051eb:	5e                   	pop    %esi
801051ec:	5d                   	pop    %ebp
801051ed:	c3                   	ret    
801051ee:	66 90                	xchg   %ax,%ax
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f5:	eb f0                	jmp    801051e7 <sys_fstat+0x57>
801051f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fe:	66 90                	xchg   %ax,%ax

80105200 <sys_link>:
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	57                   	push   %edi
80105208:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105209:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010520c:	53                   	push   %ebx
8010520d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105210:	50                   	push   %eax
80105211:	6a 00                	push   $0x0
80105213:	e8 c8 fa ff ff       	call   80104ce0 <argstr>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	0f 88 ff 00 00 00    	js     80105322 <sys_link+0x122>
80105223:	83 ec 08             	sub    $0x8,%esp
80105226:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105229:	50                   	push   %eax
8010522a:	6a 01                	push   $0x1
8010522c:	e8 af fa ff ff       	call   80104ce0 <argstr>
80105231:	83 c4 10             	add    $0x10,%esp
80105234:	85 c0                	test   %eax,%eax
80105236:	0f 88 e6 00 00 00    	js     80105322 <sys_link+0x122>
  begin_op();
8010523c:	e8 cf dc ff ff       	call   80102f10 <begin_op>
  if((ip = namei(old)) == 0){
80105241:	83 ec 0c             	sub    $0xc,%esp
80105244:	ff 75 d4             	pushl  -0x2c(%ebp)
80105247:	e8 c4 cf ff ff       	call   80102210 <namei>
8010524c:	83 c4 10             	add    $0x10,%esp
8010524f:	89 c3                	mov    %eax,%ebx
80105251:	85 c0                	test   %eax,%eax
80105253:	0f 84 e8 00 00 00    	je     80105341 <sys_link+0x141>
  ilock(ip);
80105259:	83 ec 0c             	sub    $0xc,%esp
8010525c:	50                   	push   %eax
8010525d:	e8 6e c6 ff ff       	call   801018d0 <ilock>
  if(ip->type == T_DIR){
80105262:	83 c4 10             	add    $0x10,%esp
80105265:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010526a:	0f 84 b9 00 00 00    	je     80105329 <sys_link+0x129>
  iupdate(ip);
80105270:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105273:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105278:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010527b:	53                   	push   %ebx
8010527c:	e8 8f c5 ff ff       	call   80101810 <iupdate>
  iunlock(ip);
80105281:	89 1c 24             	mov    %ebx,(%esp)
80105284:	e8 27 c7 ff ff       	call   801019b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105289:	58                   	pop    %eax
8010528a:	5a                   	pop    %edx
8010528b:	57                   	push   %edi
8010528c:	ff 75 d0             	pushl  -0x30(%ebp)
8010528f:	e8 9c cf ff ff       	call   80102230 <nameiparent>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	89 c6                	mov    %eax,%esi
80105299:	85 c0                	test   %eax,%eax
8010529b:	74 5f                	je     801052fc <sys_link+0xfc>
  ilock(dp);
8010529d:	83 ec 0c             	sub    $0xc,%esp
801052a0:	50                   	push   %eax
801052a1:	e8 2a c6 ff ff       	call   801018d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052a6:	8b 03                	mov    (%ebx),%eax
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	39 06                	cmp    %eax,(%esi)
801052ad:	75 41                	jne    801052f0 <sys_link+0xf0>
801052af:	83 ec 04             	sub    $0x4,%esp
801052b2:	ff 73 04             	pushl  0x4(%ebx)
801052b5:	57                   	push   %edi
801052b6:	56                   	push   %esi
801052b7:	e8 94 ce ff ff       	call   80102150 <dirlink>
801052bc:	83 c4 10             	add    $0x10,%esp
801052bf:	85 c0                	test   %eax,%eax
801052c1:	78 2d                	js     801052f0 <sys_link+0xf0>
  iunlockput(dp);
801052c3:	83 ec 0c             	sub    $0xc,%esp
801052c6:	56                   	push   %esi
801052c7:	e8 94 c8 ff ff       	call   80101b60 <iunlockput>
  iput(ip);
801052cc:	89 1c 24             	mov    %ebx,(%esp)
801052cf:	e8 2c c7 ff ff       	call   80101a00 <iput>
  end_op();
801052d4:	e8 a7 dc ff ff       	call   80102f80 <end_op>
  return 0;
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	31 c0                	xor    %eax,%eax
}
801052de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052e1:	5b                   	pop    %ebx
801052e2:	5e                   	pop    %esi
801052e3:	5f                   	pop    %edi
801052e4:	5d                   	pop    %ebp
801052e5:	c3                   	ret    
801052e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	56                   	push   %esi
801052f4:	e8 67 c8 ff ff       	call   80101b60 <iunlockput>
    goto bad;
801052f9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	53                   	push   %ebx
80105300:	e8 cb c5 ff ff       	call   801018d0 <ilock>
  ip->nlink--;
80105305:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010530a:	89 1c 24             	mov    %ebx,(%esp)
8010530d:	e8 fe c4 ff ff       	call   80101810 <iupdate>
  iunlockput(ip);
80105312:	89 1c 24             	mov    %ebx,(%esp)
80105315:	e8 46 c8 ff ff       	call   80101b60 <iunlockput>
  end_op();
8010531a:	e8 61 dc ff ff       	call   80102f80 <end_op>
  return -1;
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105327:	eb b5                	jmp    801052de <sys_link+0xde>
    iunlockput(ip);
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	53                   	push   %ebx
8010532d:	e8 2e c8 ff ff       	call   80101b60 <iunlockput>
    end_op();
80105332:	e8 49 dc ff ff       	call   80102f80 <end_op>
    return -1;
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533f:	eb 9d                	jmp    801052de <sys_link+0xde>
    end_op();
80105341:	e8 3a dc ff ff       	call   80102f80 <end_op>
    return -1;
80105346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010534b:	eb 91                	jmp    801052de <sys_link+0xde>
8010534d:	8d 76 00             	lea    0x0(%esi),%esi

80105350 <sys_unlink>:
{
80105350:	f3 0f 1e fb          	endbr32 
80105354:	55                   	push   %ebp
80105355:	89 e5                	mov    %esp,%ebp
80105357:	57                   	push   %edi
80105358:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105359:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010535c:	53                   	push   %ebx
8010535d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105360:	50                   	push   %eax
80105361:	6a 00                	push   $0x0
80105363:	e8 78 f9 ff ff       	call   80104ce0 <argstr>
80105368:	83 c4 10             	add    $0x10,%esp
8010536b:	85 c0                	test   %eax,%eax
8010536d:	0f 88 86 01 00 00    	js     801054f9 <sys_unlink+0x1a9>
  begin_op();
80105373:	e8 98 db ff ff       	call   80102f10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105378:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010537b:	83 ec 08             	sub    $0x8,%esp
8010537e:	53                   	push   %ebx
8010537f:	ff 75 c0             	pushl  -0x40(%ebp)
80105382:	e8 a9 ce ff ff       	call   80102230 <nameiparent>
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010538d:	85 c0                	test   %eax,%eax
8010538f:	0f 84 6e 01 00 00    	je     80105503 <sys_unlink+0x1b3>
  ilock(dp);
80105395:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105398:	83 ec 0c             	sub    $0xc,%esp
8010539b:	57                   	push   %edi
8010539c:	e8 2f c5 ff ff       	call   801018d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053a1:	58                   	pop    %eax
801053a2:	5a                   	pop    %edx
801053a3:	68 18 7d 10 80       	push   $0x80107d18
801053a8:	53                   	push   %ebx
801053a9:	e8 72 ca ff ff       	call   80101e20 <namecmp>
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	85 c0                	test   %eax,%eax
801053b3:	0f 84 07 01 00 00    	je     801054c0 <sys_unlink+0x170>
801053b9:	83 ec 08             	sub    $0x8,%esp
801053bc:	68 17 7d 10 80       	push   $0x80107d17
801053c1:	53                   	push   %ebx
801053c2:	e8 59 ca ff ff       	call   80101e20 <namecmp>
801053c7:	83 c4 10             	add    $0x10,%esp
801053ca:	85 c0                	test   %eax,%eax
801053cc:	0f 84 ee 00 00 00    	je     801054c0 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053d2:	83 ec 04             	sub    $0x4,%esp
801053d5:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053d8:	50                   	push   %eax
801053d9:	53                   	push   %ebx
801053da:	57                   	push   %edi
801053db:	e8 60 ca ff ff       	call   80101e40 <dirlookup>
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	89 c3                	mov    %eax,%ebx
801053e5:	85 c0                	test   %eax,%eax
801053e7:	0f 84 d3 00 00 00    	je     801054c0 <sys_unlink+0x170>
  ilock(ip);
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	50                   	push   %eax
801053f1:	e8 da c4 ff ff       	call   801018d0 <ilock>
  if(ip->nlink < 1)
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053fe:	0f 8e 28 01 00 00    	jle    8010552c <sys_unlink+0x1dc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105404:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105409:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010540c:	74 6a                	je     80105478 <sys_unlink+0x128>
  memset(&de, 0, sizeof(de));
8010540e:	83 ec 04             	sub    $0x4,%esp
80105411:	6a 10                	push   $0x10
80105413:	6a 00                	push   $0x0
80105415:	57                   	push   %edi
80105416:	e8 25 f5 ff ff       	call   80104940 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010541b:	6a 10                	push   $0x10
8010541d:	ff 75 c4             	pushl  -0x3c(%ebp)
80105420:	57                   	push   %edi
80105421:	ff 75 b4             	pushl  -0x4c(%ebp)
80105424:	e8 c7 c8 ff ff       	call   80101cf0 <writei>
80105429:	83 c4 20             	add    $0x20,%esp
8010542c:	83 f8 10             	cmp    $0x10,%eax
8010542f:	0f 85 ea 00 00 00    	jne    8010551f <sys_unlink+0x1cf>
  if(ip->type == T_DIR){
80105435:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010543a:	0f 84 a0 00 00 00    	je     801054e0 <sys_unlink+0x190>
  iunlockput(dp);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	ff 75 b4             	pushl  -0x4c(%ebp)
80105446:	e8 15 c7 ff ff       	call   80101b60 <iunlockput>
  ip->nlink--;
8010544b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105450:	89 1c 24             	mov    %ebx,(%esp)
80105453:	e8 b8 c3 ff ff       	call   80101810 <iupdate>
  iunlockput(ip);
80105458:	89 1c 24             	mov    %ebx,(%esp)
8010545b:	e8 00 c7 ff ff       	call   80101b60 <iunlockput>
  end_op();
80105460:	e8 1b db ff ff       	call   80102f80 <end_op>
  return 0;
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	31 c0                	xor    %eax,%eax
}
8010546a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010546d:	5b                   	pop    %ebx
8010546e:	5e                   	pop    %esi
8010546f:	5f                   	pop    %edi
80105470:	5d                   	pop    %ebp
80105471:	c3                   	ret    
80105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105478:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010547c:	76 90                	jbe    8010540e <sys_unlink+0xbe>
8010547e:	be 20 00 00 00       	mov    $0x20,%esi
80105483:	eb 0f                	jmp    80105494 <sys_unlink+0x144>
80105485:	8d 76 00             	lea    0x0(%esi),%esi
80105488:	83 c6 10             	add    $0x10,%esi
8010548b:	3b 73 58             	cmp    0x58(%ebx),%esi
8010548e:	0f 83 7a ff ff ff    	jae    8010540e <sys_unlink+0xbe>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105494:	6a 10                	push   $0x10
80105496:	56                   	push   %esi
80105497:	57                   	push   %edi
80105498:	53                   	push   %ebx
80105499:	e8 52 c7 ff ff       	call   80101bf0 <readi>
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	83 f8 10             	cmp    $0x10,%eax
801054a4:	75 6c                	jne    80105512 <sys_unlink+0x1c2>
    if(de.inum != 0)
801054a6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054ab:	74 db                	je     80105488 <sys_unlink+0x138>
    iunlockput(ip);
801054ad:	83 ec 0c             	sub    $0xc,%esp
801054b0:	53                   	push   %ebx
801054b1:	e8 aa c6 ff ff       	call   80101b60 <iunlockput>
    goto bad;
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	ff 75 b4             	pushl  -0x4c(%ebp)
801054c6:	e8 95 c6 ff ff       	call   80101b60 <iunlockput>
  end_op();
801054cb:	e8 b0 da ff ff       	call   80102f80 <end_op>
  return -1;
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d8:	eb 90                	jmp    8010546a <sys_unlink+0x11a>
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801054e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801054e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801054e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801054eb:	50                   	push   %eax
801054ec:	e8 1f c3 ff ff       	call   80101810 <iupdate>
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	e9 47 ff ff ff       	jmp    80105440 <sys_unlink+0xf0>
    return -1;
801054f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fe:	e9 67 ff ff ff       	jmp    8010546a <sys_unlink+0x11a>
    end_op();
80105503:	e8 78 da ff ff       	call   80102f80 <end_op>
    return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550d:	e9 58 ff ff ff       	jmp    8010546a <sys_unlink+0x11a>
      panic("isdirempty: readi");
80105512:	83 ec 0c             	sub    $0xc,%esp
80105515:	68 3c 7d 10 80       	push   $0x80107d3c
8010551a:	e8 71 ae ff ff       	call   80100390 <panic>
    panic("unlink: writei");
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	68 4e 7d 10 80       	push   $0x80107d4e
80105527:	e8 64 ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	68 2a 7d 10 80       	push   $0x80107d2a
80105534:	e8 57 ae ff ff       	call   80100390 <panic>
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_open>:

int
sys_open(void)
{
80105540:	f3 0f 1e fb          	endbr32 
80105544:	55                   	push   %ebp
80105545:	89 e5                	mov    %esp,%ebp
80105547:	57                   	push   %edi
80105548:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105549:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010554c:	53                   	push   %ebx
8010554d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105550:	50                   	push   %eax
80105551:	6a 00                	push   $0x0
80105553:	e8 88 f7 ff ff       	call   80104ce0 <argstr>
80105558:	83 c4 10             	add    $0x10,%esp
8010555b:	85 c0                	test   %eax,%eax
8010555d:	0f 88 8a 00 00 00    	js     801055ed <sys_open+0xad>
80105563:	83 ec 08             	sub    $0x8,%esp
80105566:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105569:	50                   	push   %eax
8010556a:	6a 01                	push   $0x1
8010556c:	e8 af f6 ff ff       	call   80104c20 <argint>
80105571:	83 c4 10             	add    $0x10,%esp
80105574:	85 c0                	test   %eax,%eax
80105576:	78 75                	js     801055ed <sys_open+0xad>
    return -1;

  begin_op();
80105578:	e8 93 d9 ff ff       	call   80102f10 <begin_op>

  if(omode & O_CREATE){
8010557d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105581:	75 75                	jne    801055f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105583:	83 ec 0c             	sub    $0xc,%esp
80105586:	ff 75 e0             	pushl  -0x20(%ebp)
80105589:	e8 82 cc ff ff       	call   80102210 <namei>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	89 c6                	mov    %eax,%esi
80105593:	85 c0                	test   %eax,%eax
80105595:	74 7e                	je     80105615 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105597:	83 ec 0c             	sub    $0xc,%esp
8010559a:	50                   	push   %eax
8010559b:	e8 30 c3 ff ff       	call   801018d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a0:	83 c4 10             	add    $0x10,%esp
801055a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055a8:	0f 84 c2 00 00 00    	je     80105670 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055ae:	e8 ad b9 ff ff       	call   80100f60 <filealloc>
801055b3:	89 c7                	mov    %eax,%edi
801055b5:	85 c0                	test   %eax,%eax
801055b7:	74 23                	je     801055dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801055b9:	e8 b2 e5 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801055c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055c4:	85 d2                	test   %edx,%edx
801055c6:	74 60                	je     80105628 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801055c8:	83 c3 01             	add    $0x1,%ebx
801055cb:	83 fb 10             	cmp    $0x10,%ebx
801055ce:	75 f0                	jne    801055c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	57                   	push   %edi
801055d4:	e8 47 ba ff ff       	call   80101020 <fileclose>
801055d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	56                   	push   %esi
801055e0:	e8 7b c5 ff ff       	call   80101b60 <iunlockput>
    end_op();
801055e5:	e8 96 d9 ff ff       	call   80102f80 <end_op>
    return -1;
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055f2:	eb 6d                	jmp    80105661 <sys_open+0x121>
801055f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055f8:	83 ec 0c             	sub    $0xc,%esp
801055fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055fe:	31 c9                	xor    %ecx,%ecx
80105600:	ba 02 00 00 00       	mov    $0x2,%edx
80105605:	6a 00                	push   $0x0
80105607:	e8 d4 f7 ff ff       	call   80104de0 <create>
    if(ip == 0){
8010560c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010560f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105611:	85 c0                	test   %eax,%eax
80105613:	75 99                	jne    801055ae <sys_open+0x6e>
      end_op();
80105615:	e8 66 d9 ff ff       	call   80102f80 <end_op>
      return -1;
8010561a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010561f:	eb 40                	jmp    80105661 <sys_open+0x121>
80105621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105628:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010562b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010562f:	56                   	push   %esi
80105630:	e8 7b c3 ff ff       	call   801019b0 <iunlock>
  end_op();
80105635:	e8 46 d9 ff ff       	call   80102f80 <end_op>

  f->type = FD_INODE;
8010563a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105643:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105646:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105649:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010564b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105652:	f7 d0                	not    %eax
80105654:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105657:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010565a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010565d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105661:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105664:	89 d8                	mov    %ebx,%eax
80105666:	5b                   	pop    %ebx
80105667:	5e                   	pop    %esi
80105668:	5f                   	pop    %edi
80105669:	5d                   	pop    %ebp
8010566a:	c3                   	ret    
8010566b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105670:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105673:	85 c9                	test   %ecx,%ecx
80105675:	0f 84 33 ff ff ff    	je     801055ae <sys_open+0x6e>
8010567b:	e9 5c ff ff ff       	jmp    801055dc <sys_open+0x9c>

80105680 <sys_mkdir>:

int
sys_mkdir(void)
{
80105680:	f3 0f 1e fb          	endbr32 
80105684:	55                   	push   %ebp
80105685:	89 e5                	mov    %esp,%ebp
80105687:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010568a:	e8 81 d8 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010568f:	83 ec 08             	sub    $0x8,%esp
80105692:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105695:	50                   	push   %eax
80105696:	6a 00                	push   $0x0
80105698:	e8 43 f6 ff ff       	call   80104ce0 <argstr>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	85 c0                	test   %eax,%eax
801056a2:	78 34                	js     801056d8 <sys_mkdir+0x58>
801056a4:	83 ec 0c             	sub    $0xc,%esp
801056a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056aa:	31 c9                	xor    %ecx,%ecx
801056ac:	ba 01 00 00 00       	mov    $0x1,%edx
801056b1:	6a 00                	push   $0x0
801056b3:	e8 28 f7 ff ff       	call   80104de0 <create>
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	85 c0                	test   %eax,%eax
801056bd:	74 19                	je     801056d8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056bf:	83 ec 0c             	sub    $0xc,%esp
801056c2:	50                   	push   %eax
801056c3:	e8 98 c4 ff ff       	call   80101b60 <iunlockput>
  end_op();
801056c8:	e8 b3 d8 ff ff       	call   80102f80 <end_op>
  return 0;
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	31 c0                	xor    %eax,%eax
}
801056d2:	c9                   	leave  
801056d3:	c3                   	ret    
801056d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801056d8:	e8 a3 d8 ff ff       	call   80102f80 <end_op>
    return -1;
801056dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056e2:	c9                   	leave  
801056e3:	c3                   	ret    
801056e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop

801056f0 <sys_mknod>:

int
sys_mknod(void)
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
801056f5:	89 e5                	mov    %esp,%ebp
801056f7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056fa:	e8 11 d8 ff ff       	call   80102f10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056ff:	83 ec 08             	sub    $0x8,%esp
80105702:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105705:	50                   	push   %eax
80105706:	6a 00                	push   $0x0
80105708:	e8 d3 f5 ff ff       	call   80104ce0 <argstr>
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	85 c0                	test   %eax,%eax
80105712:	78 64                	js     80105778 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105714:	83 ec 08             	sub    $0x8,%esp
80105717:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010571a:	50                   	push   %eax
8010571b:	6a 01                	push   $0x1
8010571d:	e8 fe f4 ff ff       	call   80104c20 <argint>
  if((argstr(0, &path)) < 0 ||
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	85 c0                	test   %eax,%eax
80105727:	78 4f                	js     80105778 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105729:	83 ec 08             	sub    $0x8,%esp
8010572c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010572f:	50                   	push   %eax
80105730:	6a 02                	push   $0x2
80105732:	e8 e9 f4 ff ff       	call   80104c20 <argint>
     argint(1, &major) < 0 ||
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	85 c0                	test   %eax,%eax
8010573c:	78 3a                	js     80105778 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010573e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105742:	83 ec 0c             	sub    $0xc,%esp
80105745:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105749:	ba 03 00 00 00       	mov    $0x3,%edx
8010574e:	50                   	push   %eax
8010574f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105752:	e8 89 f6 ff ff       	call   80104de0 <create>
     argint(2, &minor) < 0 ||
80105757:	83 c4 10             	add    $0x10,%esp
8010575a:	85 c0                	test   %eax,%eax
8010575c:	74 1a                	je     80105778 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010575e:	83 ec 0c             	sub    $0xc,%esp
80105761:	50                   	push   %eax
80105762:	e8 f9 c3 ff ff       	call   80101b60 <iunlockput>
  end_op();
80105767:	e8 14 d8 ff ff       	call   80102f80 <end_op>
  return 0;
8010576c:	83 c4 10             	add    $0x10,%esp
8010576f:	31 c0                	xor    %eax,%eax
}
80105771:	c9                   	leave  
80105772:	c3                   	ret    
80105773:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105777:	90                   	nop
    end_op();
80105778:	e8 03 d8 ff ff       	call   80102f80 <end_op>
    return -1;
8010577d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105782:	c9                   	leave  
80105783:	c3                   	ret    
80105784:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop

80105790 <sys_chdir>:

int
sys_chdir(void)
{
80105790:	f3 0f 1e fb          	endbr32 
80105794:	55                   	push   %ebp
80105795:	89 e5                	mov    %esp,%ebp
80105797:	56                   	push   %esi
80105798:	53                   	push   %ebx
80105799:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010579c:	e8 cf e3 ff ff       	call   80103b70 <myproc>
801057a1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057a3:	e8 68 d7 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057a8:	83 ec 08             	sub    $0x8,%esp
801057ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ae:	50                   	push   %eax
801057af:	6a 00                	push   $0x0
801057b1:	e8 2a f5 ff ff       	call   80104ce0 <argstr>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 73                	js     80105830 <sys_chdir+0xa0>
801057bd:	83 ec 0c             	sub    $0xc,%esp
801057c0:	ff 75 f4             	pushl  -0xc(%ebp)
801057c3:	e8 48 ca ff ff       	call   80102210 <namei>
801057c8:	83 c4 10             	add    $0x10,%esp
801057cb:	89 c3                	mov    %eax,%ebx
801057cd:	85 c0                	test   %eax,%eax
801057cf:	74 5f                	je     80105830 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057d1:	83 ec 0c             	sub    $0xc,%esp
801057d4:	50                   	push   %eax
801057d5:	e8 f6 c0 ff ff       	call   801018d0 <ilock>
  if(ip->type != T_DIR){
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057e2:	75 2c                	jne    80105810 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	53                   	push   %ebx
801057e8:	e8 c3 c1 ff ff       	call   801019b0 <iunlock>
  iput(curproc->cwd);
801057ed:	58                   	pop    %eax
801057ee:	ff 76 68             	pushl  0x68(%esi)
801057f1:	e8 0a c2 ff ff       	call   80101a00 <iput>
  end_op();
801057f6:	e8 85 d7 ff ff       	call   80102f80 <end_op>
  curproc->cwd = ip;
801057fb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057fe:	83 c4 10             	add    $0x10,%esp
80105801:	31 c0                	xor    %eax,%eax
}
80105803:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105806:	5b                   	pop    %ebx
80105807:	5e                   	pop    %esi
80105808:	5d                   	pop    %ebp
80105809:	c3                   	ret    
8010580a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	53                   	push   %ebx
80105814:	e8 47 c3 ff ff       	call   80101b60 <iunlockput>
    end_op();
80105819:	e8 62 d7 ff ff       	call   80102f80 <end_op>
    return -1;
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105826:	eb db                	jmp    80105803 <sys_chdir+0x73>
80105828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582f:	90                   	nop
    end_op();
80105830:	e8 4b d7 ff ff       	call   80102f80 <end_op>
    return -1;
80105835:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583a:	eb c7                	jmp    80105803 <sys_chdir+0x73>
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_exec>:

int
sys_exec(void)
{
80105840:	f3 0f 1e fb          	endbr32 
80105844:	55                   	push   %ebp
80105845:	89 e5                	mov    %esp,%ebp
80105847:	57                   	push   %edi
80105848:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105849:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010584f:	53                   	push   %ebx
80105850:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105856:	50                   	push   %eax
80105857:	6a 00                	push   $0x0
80105859:	e8 82 f4 ff ff       	call   80104ce0 <argstr>
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	85 c0                	test   %eax,%eax
80105863:	0f 88 83 00 00 00    	js     801058ec <sys_exec+0xac>
80105869:	83 ec 08             	sub    $0x8,%esp
8010586c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105872:	50                   	push   %eax
80105873:	6a 01                	push   $0x1
80105875:	e8 a6 f3 ff ff       	call   80104c20 <argint>
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	85 c0                	test   %eax,%eax
8010587f:	78 6b                	js     801058ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105881:	83 ec 04             	sub    $0x4,%esp
80105884:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
8010588a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010588c:	68 80 00 00 00       	push   $0x80
80105891:	6a 00                	push   $0x0
80105893:	56                   	push   %esi
80105894:	e8 a7 f0 ff ff       	call   80104940 <memset>
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058a0:	83 ec 08             	sub    $0x8,%esp
801058a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801058a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801058b0:	50                   	push   %eax
801058b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058b7:	01 f8                	add    %edi,%eax
801058b9:	50                   	push   %eax
801058ba:	e8 c1 f2 ff ff       	call   80104b80 <fetchint>
801058bf:	83 c4 10             	add    $0x10,%esp
801058c2:	85 c0                	test   %eax,%eax
801058c4:	78 26                	js     801058ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801058c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058cc:	85 c0                	test   %eax,%eax
801058ce:	74 30                	je     80105900 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058d0:	83 ec 08             	sub    $0x8,%esp
801058d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801058d6:	52                   	push   %edx
801058d7:	50                   	push   %eax
801058d8:	e8 e3 f2 ff ff       	call   80104bc0 <fetchstr>
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	85 c0                	test   %eax,%eax
801058e2:	78 08                	js     801058ec <sys_exec+0xac>
  for(i=0;; i++){
801058e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801058e7:	83 fb 20             	cmp    $0x20,%ebx
801058ea:	75 b4                	jne    801058a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801058ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f4:	5b                   	pop    %ebx
801058f5:	5e                   	pop    %esi
801058f6:	5f                   	pop    %edi
801058f7:	5d                   	pop    %ebp
801058f8:	c3                   	ret    
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105900:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105907:	00 00 00 00 
  return exec(path, argv);
8010590b:	83 ec 08             	sub    $0x8,%esp
8010590e:	56                   	push   %esi
8010590f:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105915:	e8 c6 b2 ff ff       	call   80100be0 <exec>
8010591a:	83 c4 10             	add    $0x10,%esp
}
8010591d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105920:	5b                   	pop    %ebx
80105921:	5e                   	pop    %esi
80105922:	5f                   	pop    %edi
80105923:	5d                   	pop    %ebp
80105924:	c3                   	ret    
80105925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_pipe>:

int
sys_pipe(void)
{
80105930:	f3 0f 1e fb          	endbr32 
80105934:	55                   	push   %ebp
80105935:	89 e5                	mov    %esp,%ebp
80105937:	57                   	push   %edi
80105938:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105939:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010593c:	53                   	push   %ebx
8010593d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105940:	6a 08                	push   $0x8
80105942:	50                   	push   %eax
80105943:	6a 00                	push   $0x0
80105945:	e8 26 f3 ff ff       	call   80104c70 <argptr>
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	85 c0                	test   %eax,%eax
8010594f:	78 4e                	js     8010599f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105951:	83 ec 08             	sub    $0x8,%esp
80105954:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105957:	50                   	push   %eax
80105958:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010595b:	50                   	push   %eax
8010595c:	e8 9f dc ff ff       	call   80103600 <pipealloc>
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	85 c0                	test   %eax,%eax
80105966:	78 37                	js     8010599f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105968:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010596b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010596d:	e8 fe e1 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105978:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010597c:	85 f6                	test   %esi,%esi
8010597e:	74 30                	je     801059b0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105980:	83 c3 01             	add    $0x1,%ebx
80105983:	83 fb 10             	cmp    $0x10,%ebx
80105986:	75 f0                	jne    80105978 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	ff 75 e0             	pushl  -0x20(%ebp)
8010598e:	e8 8d b6 ff ff       	call   80101020 <fileclose>
    fileclose(wf);
80105993:	58                   	pop    %eax
80105994:	ff 75 e4             	pushl  -0x1c(%ebp)
80105997:	e8 84 b6 ff ff       	call   80101020 <fileclose>
    return -1;
8010599c:	83 c4 10             	add    $0x10,%esp
8010599f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a4:	eb 5b                	jmp    80105a01 <sys_pipe+0xd1>
801059a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801059b0:	8d 73 08             	lea    0x8(%ebx),%esi
801059b3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801059ba:	e8 b1 e1 ff ff       	call   80103b70 <myproc>
801059bf:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
801059c1:	31 c0                	xor    %eax,%eax
801059c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059c7:	90                   	nop
    if(curproc->ofile[fd] == 0){
801059c8:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
801059cc:	85 c9                	test   %ecx,%ecx
801059ce:	74 20                	je     801059f0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801059d0:	83 c0 01             	add    $0x1,%eax
801059d3:	83 f8 10             	cmp    $0x10,%eax
801059d6:	75 f0                	jne    801059c8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801059d8:	e8 93 e1 ff ff       	call   80103b70 <myproc>
801059dd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059e4:	00 
801059e5:	eb a1                	jmp    80105988 <sys_pipe+0x58>
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801059f0:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
801059f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801059f7:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801059f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801059fc:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
801059ff:	31 c0                	xor    %eax,%eax
}
80105a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a04:	5b                   	pop    %ebx
80105a05:	5e                   	pop    %esi
80105a06:	5f                   	pop    %edi
80105a07:	5d                   	pop    %ebp
80105a08:	c3                   	ret    
80105a09:	66 90                	xchg   %ax,%ax
80105a0b:	66 90                	xchg   %ax,%ax
80105a0d:	66 90                	xchg   %ax,%ax
80105a0f:	90                   	nop

80105a10 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105a10:	f3 0f 1e fb          	endbr32 
  return fork();
80105a14:	e9 07 e3 ff ff       	jmp    80103d20 <fork>
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_exit>:
}

int
sys_exit(void)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a2a:	e8 71 e5 ff ff       	call   80103fa0 <exit>
  return 0;  // not reached
}
80105a2f:	31 c0                	xor    %eax,%eax
80105a31:	c9                   	leave  
80105a32:	c3                   	ret    
80105a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a40 <sys_wait>:

int
sys_wait(void)
{
80105a40:	f3 0f 1e fb          	endbr32 
  return wait();
80105a44:	e9 87 e6 ff ff       	jmp    801040d0 <wait>
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_kill>:
}

int
sys_kill(void)
{
80105a50:	f3 0f 1e fb          	endbr32 
80105a54:	55                   	push   %ebp
80105a55:	89 e5                	mov    %esp,%ebp
80105a57:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a5d:	50                   	push   %eax
80105a5e:	6a 00                	push   $0x0
80105a60:	e8 bb f1 ff ff       	call   80104c20 <argint>
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	85 c0                	test   %eax,%eax
80105a6a:	78 14                	js     80105a80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	ff 75 f4             	pushl  -0xc(%ebp)
80105a72:	e8 f9 e8 ff ff       	call   80104370 <kill>
80105a77:	83 c4 10             	add    $0x10,%esp
}
80105a7a:	c9                   	leave  
80105a7b:	c3                   	ret    
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a80:	c9                   	leave  
    return -1;
80105a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a86:	c3                   	ret    
80105a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_getpid>:

int
sys_getpid(void)
{
80105a90:	f3 0f 1e fb          	endbr32 
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a9a:	e8 d1 e0 ff ff       	call   80103b70 <myproc>
80105a9f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105aa2:	c9                   	leave  
80105aa3:	c3                   	ret    
80105aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop

80105ab0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ab0:	f3 0f 1e fb          	endbr32 
80105ab4:	55                   	push   %ebp
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ab8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105abb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105abe:	50                   	push   %eax
80105abf:	6a 00                	push   $0x0
80105ac1:	e8 5a f1 ff ff       	call   80104c20 <argint>
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	78 23                	js     80105af0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105acd:	e8 9e e0 ff ff       	call   80103b70 <myproc>
  if(growproc(n) < 0)
80105ad2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ad5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ad7:	ff 75 f4             	pushl  -0xc(%ebp)
80105ada:	e8 c1 e1 ff ff       	call   80103ca0 <growproc>
80105adf:	83 c4 10             	add    $0x10,%esp
80105ae2:	85 c0                	test   %eax,%eax
80105ae4:	78 0a                	js     80105af0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ae6:	89 d8                	mov    %ebx,%eax
80105ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aeb:	c9                   	leave  
80105aec:	c3                   	ret    
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105af0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105af5:	eb ef                	jmp    80105ae6 <sys_sbrk+0x36>
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax

80105b00 <sys_sleep>:

int
sys_sleep(void)
{
80105b00:	f3 0f 1e fb          	endbr32 
80105b04:	55                   	push   %ebp
80105b05:	89 e5                	mov    %esp,%ebp
80105b07:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b08:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b0b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b0e:	50                   	push   %eax
80105b0f:	6a 00                	push   $0x0
80105b11:	e8 0a f1 ff ff       	call   80104c20 <argint>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	0f 88 86 00 00 00    	js     80105ba7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b21:	83 ec 0c             	sub    $0xc,%esp
80105b24:	68 a0 3c 11 80       	push   $0x80113ca0
80105b29:	e8 42 ed ff ff       	call   80104870 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b31:	8b 1d 80 3c 11 80    	mov    0x80113c80,%ebx
  while(ticks - ticks0 < n){
80105b37:	83 c4 10             	add    $0x10,%esp
80105b3a:	85 d2                	test   %edx,%edx
80105b3c:	75 23                	jne    80105b61 <sys_sleep+0x61>
80105b3e:	eb 50                	jmp    80105b90 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b40:	83 ec 08             	sub    $0x8,%esp
80105b43:	68 a0 3c 11 80       	push   $0x80113ca0
80105b48:	68 80 3c 11 80       	push   $0x80113c80
80105b4d:	e8 fe e6 ff ff       	call   80104250 <sleep>
  while(ticks - ticks0 < n){
80105b52:	a1 80 3c 11 80       	mov    0x80113c80,%eax
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	29 d8                	sub    %ebx,%eax
80105b5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b5f:	73 2f                	jae    80105b90 <sys_sleep+0x90>
    if(myproc()->killed){
80105b61:	e8 0a e0 ff ff       	call   80103b70 <myproc>
80105b66:	8b 40 24             	mov    0x24(%eax),%eax
80105b69:	85 c0                	test   %eax,%eax
80105b6b:	74 d3                	je     80105b40 <sys_sleep+0x40>
      release(&tickslock);
80105b6d:	83 ec 0c             	sub    $0xc,%esp
80105b70:	68 a0 3c 11 80       	push   $0x80113ca0
80105b75:	e8 86 ec ff ff       	call   80104800 <release>
  }
  release(&tickslock);
  return 0;
}
80105b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    
80105b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	68 a0 3c 11 80       	push   $0x80113ca0
80105b98:	e8 63 ec ff ff       	call   80104800 <release>
  return 0;
80105b9d:	83 c4 10             	add    $0x10,%esp
80105ba0:	31 c0                	xor    %eax,%eax
}
80105ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ba5:	c9                   	leave  
80105ba6:	c3                   	ret    
    return -1;
80105ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bac:	eb f4                	jmp    80105ba2 <sys_sleep+0xa2>
80105bae:	66 90                	xchg   %ax,%ax

80105bb0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105bb0:	f3 0f 1e fb          	endbr32 
80105bb4:	55                   	push   %ebp
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	53                   	push   %ebx
80105bb8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105bbb:	68 a0 3c 11 80       	push   $0x80113ca0
80105bc0:	e8 ab ec ff ff       	call   80104870 <acquire>
  xticks = ticks;
80105bc5:	8b 1d 80 3c 11 80    	mov    0x80113c80,%ebx
  release(&tickslock);
80105bcb:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80105bd2:	e8 29 ec ff ff       	call   80104800 <release>
  return xticks;
}
80105bd7:	89 d8                	mov    %ebx,%eax
80105bd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bdc:	c9                   	leave  
80105bdd:	c3                   	ret    
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <sys_count>:

int
sys_count(void)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	83 ec 20             	sub    $0x20,%esp
  //Checks arguments
  int i;
  if(argint(0, &i) < 0)
80105bea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bed:	50                   	push   %eax
80105bee:	6a 00                	push   $0x0
80105bf0:	e8 2b f0 ff ff       	call   80104c20 <argint>
80105bf5:	83 c4 10             	add    $0x10,%esp
80105bf8:	85 c0                	test   %eax,%eax
80105bfa:	78 14                	js     80105c10 <sys_count+0x30>
    return -1;

  return count(i);
80105bfc:	83 ec 0c             	sub    $0xc,%esp
80105bff:	ff 75 f4             	pushl  -0xc(%ebp)
80105c02:	e8 c9 e8 ff ff       	call   801044d0 <count>
80105c07:	83 c4 10             	add    $0x10,%esp
}
80105c0a:	c9                   	leave  
80105c0b:	c3                   	ret    
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c10:	c9                   	leave  
    return -1;
80105c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c16:	c3                   	ret    

80105c17 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c17:	1e                   	push   %ds
  pushl %es
80105c18:	06                   	push   %es
  pushl %fs
80105c19:	0f a0                	push   %fs
  pushl %gs
80105c1b:	0f a8                	push   %gs
  pushal
80105c1d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c1e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c22:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c24:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c26:	54                   	push   %esp
  call trap
80105c27:	e8 c4 00 00 00       	call   80105cf0 <trap>
  addl $4, %esp
80105c2c:	83 c4 04             	add    $0x4,%esp

80105c2f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c2f:	61                   	popa   
  popl %gs
80105c30:	0f a9                	pop    %gs
  popl %fs
80105c32:	0f a1                	pop    %fs
  popl %es
80105c34:	07                   	pop    %es
  popl %ds
80105c35:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c36:	83 c4 08             	add    $0x8,%esp
  iret
80105c39:	cf                   	iret   
80105c3a:	66 90                	xchg   %ax,%ax
80105c3c:	66 90                	xchg   %ax,%ax
80105c3e:	66 90                	xchg   %ax,%ax

80105c40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c45:	31 c0                	xor    %eax,%eax
{
80105c47:	89 e5                	mov    %esp,%ebp
80105c49:	83 ec 08             	sub    $0x8,%esp
80105c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c50:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c57:	c7 04 c5 e2 3c 11 80 	movl   $0x8e000008,-0x7feec31e(,%eax,8)
80105c5e:	08 00 00 8e 
80105c62:	66 89 14 c5 e0 3c 11 	mov    %dx,-0x7feec320(,%eax,8)
80105c69:	80 
80105c6a:	c1 ea 10             	shr    $0x10,%edx
80105c6d:	66 89 14 c5 e6 3c 11 	mov    %dx,-0x7feec31a(,%eax,8)
80105c74:	80 
  for(i = 0; i < 256; i++)
80105c75:	83 c0 01             	add    $0x1,%eax
80105c78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c7d:	75 d1                	jne    80105c50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c82:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105c87:	c7 05 e2 3e 11 80 08 	movl   $0xef000008,0x80113ee2
80105c8e:	00 00 ef 
  initlock(&tickslock, "time");
80105c91:	68 5d 7d 10 80       	push   $0x80107d5d
80105c96:	68 a0 3c 11 80       	push   $0x80113ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c9b:	66 a3 e0 3e 11 80    	mov    %ax,0x80113ee0
80105ca1:	c1 e8 10             	shr    $0x10,%eax
80105ca4:	66 a3 e6 3e 11 80    	mov    %ax,0x80113ee6
  initlock(&tickslock, "time");
80105caa:	e8 c1 e9 ff ff       	call   80104670 <initlock>
}
80105caf:	83 c4 10             	add    $0x10,%esp
80105cb2:	c9                   	leave  
80105cb3:	c3                   	ret    
80105cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop

80105cc0 <idtinit>:

void
idtinit(void)
{
80105cc0:	f3 0f 1e fb          	endbr32 
80105cc4:	55                   	push   %ebp
  pd[0] = size-1;
80105cc5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cca:	89 e5                	mov    %esp,%ebp
80105ccc:	83 ec 10             	sub    $0x10,%esp
80105ccf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cd3:	b8 e0 3c 11 80       	mov    $0x80113ce0,%eax
80105cd8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cdc:	c1 e8 10             	shr    $0x10,%eax
80105cdf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ce3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ce6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ce9:	c9                   	leave  
80105cea:	c3                   	ret    
80105ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop

80105cf0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	57                   	push   %edi
80105cf8:	56                   	push   %esi
80105cf9:	53                   	push   %ebx
80105cfa:	83 ec 1c             	sub    $0x1c,%esp
80105cfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d00:	8b 43 30             	mov    0x30(%ebx),%eax
80105d03:	83 f8 40             	cmp    $0x40,%eax
80105d06:	0f 84 64 01 00 00    	je     80105e70 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d0c:	83 e8 20             	sub    $0x20,%eax
80105d0f:	83 f8 1f             	cmp    $0x1f,%eax
80105d12:	0f 87 88 00 00 00    	ja     80105da0 <trap+0xb0>
80105d18:	3e ff 24 85 04 7e 10 	notrack jmp *-0x7fef81fc(,%eax,4)
80105d1f:	80 
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105d20:	e8 9b c6 ff ff       	call   801023c0 <ideintr>
    lapiceoi();
80105d25:	e8 76 cd ff ff       	call   80102aa0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d2a:	e8 41 de ff ff       	call   80103b70 <myproc>
80105d2f:	85 c0                	test   %eax,%eax
80105d31:	74 1d                	je     80105d50 <trap+0x60>
80105d33:	e8 38 de ff ff       	call   80103b70 <myproc>
80105d38:	8b 50 24             	mov    0x24(%eax),%edx
80105d3b:	85 d2                	test   %edx,%edx
80105d3d:	74 11                	je     80105d50 <trap+0x60>
80105d3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d43:	83 e0 03             	and    $0x3,%eax
80105d46:	66 83 f8 03          	cmp    $0x3,%ax
80105d4a:	0f 84 e8 01 00 00    	je     80105f38 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d50:	e8 1b de ff ff       	call   80103b70 <myproc>
80105d55:	85 c0                	test   %eax,%eax
80105d57:	74 0f                	je     80105d68 <trap+0x78>
80105d59:	e8 12 de ff ff       	call   80103b70 <myproc>
80105d5e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d62:	0f 84 b8 00 00 00    	je     80105e20 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d68:	e8 03 de ff ff       	call   80103b70 <myproc>
80105d6d:	85 c0                	test   %eax,%eax
80105d6f:	74 1d                	je     80105d8e <trap+0x9e>
80105d71:	e8 fa dd ff ff       	call   80103b70 <myproc>
80105d76:	8b 40 24             	mov    0x24(%eax),%eax
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	74 11                	je     80105d8e <trap+0x9e>
80105d7d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d81:	83 e0 03             	and    $0x3,%eax
80105d84:	66 83 f8 03          	cmp    $0x3,%ax
80105d88:	0f 84 0f 01 00 00    	je     80105e9d <trap+0x1ad>
    exit();
}
80105d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d91:	5b                   	pop    %ebx
80105d92:	5e                   	pop    %esi
80105d93:	5f                   	pop    %edi
80105d94:	5d                   	pop    %ebp
80105d95:	c3                   	ret    
80105d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105da0:	e8 cb dd ff ff       	call   80103b70 <myproc>
80105da5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105da8:	85 c0                	test   %eax,%eax
80105daa:	0f 84 a2 01 00 00    	je     80105f52 <trap+0x262>
80105db0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105db4:	0f 84 98 01 00 00    	je     80105f52 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105dba:	0f 20 d1             	mov    %cr2,%ecx
80105dbd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dc0:	e8 8b dd ff ff       	call   80103b50 <cpuid>
80105dc5:	8b 73 30             	mov    0x30(%ebx),%esi
80105dc8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dcb:	8b 43 34             	mov    0x34(%ebx),%eax
80105dce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105dd1:	e8 9a dd ff ff       	call   80103b70 <myproc>
80105dd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105dd9:	e8 92 dd ff ff       	call   80103b70 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105de4:	51                   	push   %ecx
80105de5:	57                   	push   %edi
80105de6:	52                   	push   %edx
80105de7:	ff 75 e4             	pushl  -0x1c(%ebp)
80105dea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105deb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105dee:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105df1:	56                   	push   %esi
80105df2:	ff 70 10             	pushl  0x10(%eax)
80105df5:	68 c0 7d 10 80       	push   $0x80107dc0
80105dfa:	e8 91 a8 ff ff       	call   80100690 <cprintf>
    myproc()->killed = 1;
80105dff:	83 c4 20             	add    $0x20,%esp
80105e02:	e8 69 dd ff ff       	call   80103b70 <myproc>
80105e07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e0e:	e8 5d dd ff ff       	call   80103b70 <myproc>
80105e13:	85 c0                	test   %eax,%eax
80105e15:	0f 85 18 ff ff ff    	jne    80105d33 <trap+0x43>
80105e1b:	e9 30 ff ff ff       	jmp    80105d50 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105e20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e24:	0f 85 3e ff ff ff    	jne    80105d68 <trap+0x78>
    yield();
80105e2a:	e8 d1 e3 ff ff       	call   80104200 <yield>
80105e2f:	e9 34 ff ff ff       	jmp    80105d68 <trap+0x78>
80105e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e38:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e3b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e3f:	e8 0c dd ff ff       	call   80103b50 <cpuid>
80105e44:	57                   	push   %edi
80105e45:	56                   	push   %esi
80105e46:	50                   	push   %eax
80105e47:	68 68 7d 10 80       	push   $0x80107d68
80105e4c:	e8 3f a8 ff ff       	call   80100690 <cprintf>
    lapiceoi();
80105e51:	e8 4a cc ff ff       	call   80102aa0 <lapiceoi>
    break;
80105e56:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e59:	e8 12 dd ff ff       	call   80103b70 <myproc>
80105e5e:	85 c0                	test   %eax,%eax
80105e60:	0f 85 cd fe ff ff    	jne    80105d33 <trap+0x43>
80105e66:	e9 e5 fe ff ff       	jmp    80105d50 <trap+0x60>
80105e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop
    if(myproc()->killed)
80105e70:	e8 fb dc ff ff       	call   80103b70 <myproc>
80105e75:	8b 70 24             	mov    0x24(%eax),%esi
80105e78:	85 f6                	test   %esi,%esi
80105e7a:	0f 85 c8 00 00 00    	jne    80105f48 <trap+0x258>
    myproc()->tf = tf;
80105e80:	e8 eb dc ff ff       	call   80103b70 <myproc>
80105e85:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e88:	e8 d3 ee ff ff       	call   80104d60 <syscall>
    if(myproc()->killed)
80105e8d:	e8 de dc ff ff       	call   80103b70 <myproc>
80105e92:	8b 48 24             	mov    0x24(%eax),%ecx
80105e95:	85 c9                	test   %ecx,%ecx
80105e97:	0f 84 f1 fe ff ff    	je     80105d8e <trap+0x9e>
}
80105e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea0:	5b                   	pop    %ebx
80105ea1:	5e                   	pop    %esi
80105ea2:	5f                   	pop    %edi
80105ea3:	5d                   	pop    %ebp
      exit();
80105ea4:	e9 f7 e0 ff ff       	jmp    80103fa0 <exit>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105eb0:	e8 5b 02 00 00       	call   80106110 <uartintr>
    lapiceoi();
80105eb5:	e8 e6 cb ff ff       	call   80102aa0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eba:	e8 b1 dc ff ff       	call   80103b70 <myproc>
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	0f 85 6c fe ff ff    	jne    80105d33 <trap+0x43>
80105ec7:	e9 84 fe ff ff       	jmp    80105d50 <trap+0x60>
80105ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ed0:	e8 8b ca ff ff       	call   80102960 <kbdintr>
    lapiceoi();
80105ed5:	e8 c6 cb ff ff       	call   80102aa0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eda:	e8 91 dc ff ff       	call   80103b70 <myproc>
80105edf:	85 c0                	test   %eax,%eax
80105ee1:	0f 85 4c fe ff ff    	jne    80105d33 <trap+0x43>
80105ee7:	e9 64 fe ff ff       	jmp    80105d50 <trap+0x60>
80105eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ef0:	e8 5b dc ff ff       	call   80103b50 <cpuid>
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	0f 85 28 fe ff ff    	jne    80105d25 <trap+0x35>
      acquire(&tickslock);
80105efd:	83 ec 0c             	sub    $0xc,%esp
80105f00:	68 a0 3c 11 80       	push   $0x80113ca0
80105f05:	e8 66 e9 ff ff       	call   80104870 <acquire>
      wakeup(&ticks);
80105f0a:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
      ticks++;
80105f11:	83 05 80 3c 11 80 01 	addl   $0x1,0x80113c80
      wakeup(&ticks);
80105f18:	e8 f3 e3 ff ff       	call   80104310 <wakeup>
      release(&tickslock);
80105f1d:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80105f24:	e8 d7 e8 ff ff       	call   80104800 <release>
80105f29:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f2c:	e9 f4 fd ff ff       	jmp    80105d25 <trap+0x35>
80105f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f38:	e8 63 e0 ff ff       	call   80103fa0 <exit>
80105f3d:	e9 0e fe ff ff       	jmp    80105d50 <trap+0x60>
80105f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f48:	e8 53 e0 ff ff       	call   80103fa0 <exit>
80105f4d:	e9 2e ff ff ff       	jmp    80105e80 <trap+0x190>
80105f52:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f55:	e8 f6 db ff ff       	call   80103b50 <cpuid>
80105f5a:	83 ec 0c             	sub    $0xc,%esp
80105f5d:	56                   	push   %esi
80105f5e:	57                   	push   %edi
80105f5f:	50                   	push   %eax
80105f60:	ff 73 30             	pushl  0x30(%ebx)
80105f63:	68 8c 7d 10 80       	push   $0x80107d8c
80105f68:	e8 23 a7 ff ff       	call   80100690 <cprintf>
      panic("trap");
80105f6d:	83 c4 14             	add    $0x14,%esp
80105f70:	68 62 7d 10 80       	push   $0x80107d62
80105f75:	e8 16 a4 ff ff       	call   80100390 <panic>
80105f7a:	66 90                	xchg   %ax,%ax
80105f7c:	66 90                	xchg   %ax,%ax
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105f84:	a1 e0 44 11 80       	mov    0x801144e0,%eax
80105f89:	85 c0                	test   %eax,%eax
80105f8b:	74 1b                	je     80105fa8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f8d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f92:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f93:	a8 01                	test   $0x1,%al
80105f95:	74 11                	je     80105fa8 <uartgetc+0x28>
80105f97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f9d:	0f b6 c0             	movzbl %al,%eax
80105fa0:	c3                   	ret    
80105fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fad:	c3                   	ret    
80105fae:	66 90                	xchg   %ax,%ax

80105fb0 <uartinit>:
{
80105fb0:	f3 0f 1e fb          	endbr32 
80105fb4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fb5:	31 c9                	xor    %ecx,%ecx
80105fb7:	89 c8                	mov    %ecx,%eax
80105fb9:	89 e5                	mov    %esp,%ebp
80105fbb:	57                   	push   %edi
80105fbc:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105fc1:	56                   	push   %esi
80105fc2:	89 fa                	mov    %edi,%edx
80105fc4:	53                   	push   %ebx
80105fc5:	83 ec 1c             	sub    $0x1c,%esp
80105fc8:	ee                   	out    %al,(%dx)
80105fc9:	be fb 03 00 00       	mov    $0x3fb,%esi
80105fce:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105fd3:	89 f2                	mov    %esi,%edx
80105fd5:	ee                   	out    %al,(%dx)
80105fd6:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fdb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fe0:	ee                   	out    %al,(%dx)
80105fe1:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105fe6:	89 c8                	mov    %ecx,%eax
80105fe8:	89 da                	mov    %ebx,%edx
80105fea:	ee                   	out    %al,(%dx)
80105feb:	b8 03 00 00 00       	mov    $0x3,%eax
80105ff0:	89 f2                	mov    %esi,%edx
80105ff2:	ee                   	out    %al,(%dx)
80105ff3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ff8:	89 c8                	mov    %ecx,%eax
80105ffa:	ee                   	out    %al,(%dx)
80105ffb:	b8 01 00 00 00       	mov    $0x1,%eax
80106000:	89 da                	mov    %ebx,%edx
80106002:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106003:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106008:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106009:	3c ff                	cmp    $0xff,%al
8010600b:	0f 84 8f 00 00 00    	je     801060a0 <uartinit+0xf0>
  uart = 1;
80106011:	c7 05 e0 44 11 80 01 	movl   $0x1,0x801144e0
80106018:	00 00 00 
8010601b:	89 fa                	mov    %edi,%edx
8010601d:	ec                   	in     (%dx),%al
8010601e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106023:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106024:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106027:	bf 84 7e 10 80       	mov    $0x80107e84,%edi
8010602c:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106031:	6a 00                	push   $0x0
80106033:	6a 04                	push   $0x4
80106035:	e8 d6 c5 ff ff       	call   80102610 <ioapicenable>
8010603a:	c6 45 e7 76          	movb   $0x76,-0x19(%ebp)
8010603e:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106041:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
80106045:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106048:	a1 e0 44 11 80       	mov    0x801144e0,%eax
8010604d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106052:	85 c0                	test   %eax,%eax
80106054:	75 1c                	jne    80106072 <uartinit+0xc2>
80106056:	eb 2b                	jmp    80106083 <uartinit+0xd3>
80106058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop
    microdelay(10);
80106060:	83 ec 0c             	sub    $0xc,%esp
80106063:	6a 0a                	push   $0xa
80106065:	e8 56 ca ff ff       	call   80102ac0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010606a:	83 c4 10             	add    $0x10,%esp
8010606d:	83 eb 01             	sub    $0x1,%ebx
80106070:	74 07                	je     80106079 <uartinit+0xc9>
80106072:	89 f2                	mov    %esi,%edx
80106074:	ec                   	in     (%dx),%al
80106075:	a8 20                	test   $0x20,%al
80106077:	74 e7                	je     80106060 <uartinit+0xb0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106079:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
8010607d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106082:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106083:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106087:	83 c7 01             	add    $0x1,%edi
8010608a:	84 c0                	test   %al,%al
8010608c:	74 12                	je     801060a0 <uartinit+0xf0>
8010608e:	88 45 e6             	mov    %al,-0x1a(%ebp)
80106091:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106095:	88 45 e7             	mov    %al,-0x19(%ebp)
80106098:	eb ae                	jmp    80106048 <uartinit+0x98>
8010609a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
801060a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a3:	5b                   	pop    %ebx
801060a4:	5e                   	pop    %esi
801060a5:	5f                   	pop    %edi
801060a6:	5d                   	pop    %ebp
801060a7:	c3                   	ret    
801060a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060af:	90                   	nop

801060b0 <uartputc>:
{
801060b0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801060b4:	a1 e0 44 11 80       	mov    0x801144e0,%eax
801060b9:	85 c0                	test   %eax,%eax
801060bb:	74 43                	je     80106100 <uartputc+0x50>
{
801060bd:	55                   	push   %ebp
801060be:	89 e5                	mov    %esp,%ebp
801060c0:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060c1:	be fd 03 00 00       	mov    $0x3fd,%esi
801060c6:	53                   	push   %ebx
801060c7:	bb 80 00 00 00       	mov    $0x80,%ebx
801060cc:	eb 14                	jmp    801060e2 <uartputc+0x32>
801060ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	6a 0a                	push   $0xa
801060d5:	e8 e6 c9 ff ff       	call   80102ac0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060da:	83 c4 10             	add    $0x10,%esp
801060dd:	83 eb 01             	sub    $0x1,%ebx
801060e0:	74 07                	je     801060e9 <uartputc+0x39>
801060e2:	89 f2                	mov    %esi,%edx
801060e4:	ec                   	in     (%dx),%al
801060e5:	a8 20                	test   $0x20,%al
801060e7:	74 e7                	je     801060d0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060e9:	8b 45 08             	mov    0x8(%ebp),%eax
801060ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060f1:	ee                   	out    %al,(%dx)
}
801060f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060f5:	5b                   	pop    %ebx
801060f6:	5e                   	pop    %esi
801060f7:	5d                   	pop    %ebp
801060f8:	c3                   	ret    
801060f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106100:	c3                   	ret    
80106101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610f:	90                   	nop

80106110 <uartintr>:

void
uartintr(void)
{
80106110:	f3 0f 1e fb          	endbr32 
80106114:	55                   	push   %ebp
80106115:	89 e5                	mov    %esp,%ebp
80106117:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010611a:	68 80 5f 10 80       	push   $0x80105f80
8010611f:	e8 dc a7 ff ff       	call   80100900 <consoleintr>
}
80106124:	83 c4 10             	add    $0x10,%esp
80106127:	c9                   	leave  
80106128:	c3                   	ret    

80106129 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106129:	6a 00                	push   $0x0
  pushl $0
8010612b:	6a 00                	push   $0x0
  jmp alltraps
8010612d:	e9 e5 fa ff ff       	jmp    80105c17 <alltraps>

80106132 <vector1>:
.globl vector1
vector1:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $1
80106134:	6a 01                	push   $0x1
  jmp alltraps
80106136:	e9 dc fa ff ff       	jmp    80105c17 <alltraps>

8010613b <vector2>:
.globl vector2
vector2:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $2
8010613d:	6a 02                	push   $0x2
  jmp alltraps
8010613f:	e9 d3 fa ff ff       	jmp    80105c17 <alltraps>

80106144 <vector3>:
.globl vector3
vector3:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $3
80106146:	6a 03                	push   $0x3
  jmp alltraps
80106148:	e9 ca fa ff ff       	jmp    80105c17 <alltraps>

8010614d <vector4>:
.globl vector4
vector4:
  pushl $0
8010614d:	6a 00                	push   $0x0
  pushl $4
8010614f:	6a 04                	push   $0x4
  jmp alltraps
80106151:	e9 c1 fa ff ff       	jmp    80105c17 <alltraps>

80106156 <vector5>:
.globl vector5
vector5:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $5
80106158:	6a 05                	push   $0x5
  jmp alltraps
8010615a:	e9 b8 fa ff ff       	jmp    80105c17 <alltraps>

8010615f <vector6>:
.globl vector6
vector6:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $6
80106161:	6a 06                	push   $0x6
  jmp alltraps
80106163:	e9 af fa ff ff       	jmp    80105c17 <alltraps>

80106168 <vector7>:
.globl vector7
vector7:
  pushl $0
80106168:	6a 00                	push   $0x0
  pushl $7
8010616a:	6a 07                	push   $0x7
  jmp alltraps
8010616c:	e9 a6 fa ff ff       	jmp    80105c17 <alltraps>

80106171 <vector8>:
.globl vector8
vector8:
  pushl $8
80106171:	6a 08                	push   $0x8
  jmp alltraps
80106173:	e9 9f fa ff ff       	jmp    80105c17 <alltraps>

80106178 <vector9>:
.globl vector9
vector9:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $9
8010617a:	6a 09                	push   $0x9
  jmp alltraps
8010617c:	e9 96 fa ff ff       	jmp    80105c17 <alltraps>

80106181 <vector10>:
.globl vector10
vector10:
  pushl $10
80106181:	6a 0a                	push   $0xa
  jmp alltraps
80106183:	e9 8f fa ff ff       	jmp    80105c17 <alltraps>

80106188 <vector11>:
.globl vector11
vector11:
  pushl $11
80106188:	6a 0b                	push   $0xb
  jmp alltraps
8010618a:	e9 88 fa ff ff       	jmp    80105c17 <alltraps>

8010618f <vector12>:
.globl vector12
vector12:
  pushl $12
8010618f:	6a 0c                	push   $0xc
  jmp alltraps
80106191:	e9 81 fa ff ff       	jmp    80105c17 <alltraps>

80106196 <vector13>:
.globl vector13
vector13:
  pushl $13
80106196:	6a 0d                	push   $0xd
  jmp alltraps
80106198:	e9 7a fa ff ff       	jmp    80105c17 <alltraps>

8010619d <vector14>:
.globl vector14
vector14:
  pushl $14
8010619d:	6a 0e                	push   $0xe
  jmp alltraps
8010619f:	e9 73 fa ff ff       	jmp    80105c17 <alltraps>

801061a4 <vector15>:
.globl vector15
vector15:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $15
801061a6:	6a 0f                	push   $0xf
  jmp alltraps
801061a8:	e9 6a fa ff ff       	jmp    80105c17 <alltraps>

801061ad <vector16>:
.globl vector16
vector16:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $16
801061af:	6a 10                	push   $0x10
  jmp alltraps
801061b1:	e9 61 fa ff ff       	jmp    80105c17 <alltraps>

801061b6 <vector17>:
.globl vector17
vector17:
  pushl $17
801061b6:	6a 11                	push   $0x11
  jmp alltraps
801061b8:	e9 5a fa ff ff       	jmp    80105c17 <alltraps>

801061bd <vector18>:
.globl vector18
vector18:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $18
801061bf:	6a 12                	push   $0x12
  jmp alltraps
801061c1:	e9 51 fa ff ff       	jmp    80105c17 <alltraps>

801061c6 <vector19>:
.globl vector19
vector19:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $19
801061c8:	6a 13                	push   $0x13
  jmp alltraps
801061ca:	e9 48 fa ff ff       	jmp    80105c17 <alltraps>

801061cf <vector20>:
.globl vector20
vector20:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $20
801061d1:	6a 14                	push   $0x14
  jmp alltraps
801061d3:	e9 3f fa ff ff       	jmp    80105c17 <alltraps>

801061d8 <vector21>:
.globl vector21
vector21:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $21
801061da:	6a 15                	push   $0x15
  jmp alltraps
801061dc:	e9 36 fa ff ff       	jmp    80105c17 <alltraps>

801061e1 <vector22>:
.globl vector22
vector22:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $22
801061e3:	6a 16                	push   $0x16
  jmp alltraps
801061e5:	e9 2d fa ff ff       	jmp    80105c17 <alltraps>

801061ea <vector23>:
.globl vector23
vector23:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $23
801061ec:	6a 17                	push   $0x17
  jmp alltraps
801061ee:	e9 24 fa ff ff       	jmp    80105c17 <alltraps>

801061f3 <vector24>:
.globl vector24
vector24:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $24
801061f5:	6a 18                	push   $0x18
  jmp alltraps
801061f7:	e9 1b fa ff ff       	jmp    80105c17 <alltraps>

801061fc <vector25>:
.globl vector25
vector25:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $25
801061fe:	6a 19                	push   $0x19
  jmp alltraps
80106200:	e9 12 fa ff ff       	jmp    80105c17 <alltraps>

80106205 <vector26>:
.globl vector26
vector26:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $26
80106207:	6a 1a                	push   $0x1a
  jmp alltraps
80106209:	e9 09 fa ff ff       	jmp    80105c17 <alltraps>

8010620e <vector27>:
.globl vector27
vector27:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $27
80106210:	6a 1b                	push   $0x1b
  jmp alltraps
80106212:	e9 00 fa ff ff       	jmp    80105c17 <alltraps>

80106217 <vector28>:
.globl vector28
vector28:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $28
80106219:	6a 1c                	push   $0x1c
  jmp alltraps
8010621b:	e9 f7 f9 ff ff       	jmp    80105c17 <alltraps>

80106220 <vector29>:
.globl vector29
vector29:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $29
80106222:	6a 1d                	push   $0x1d
  jmp alltraps
80106224:	e9 ee f9 ff ff       	jmp    80105c17 <alltraps>

80106229 <vector30>:
.globl vector30
vector30:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $30
8010622b:	6a 1e                	push   $0x1e
  jmp alltraps
8010622d:	e9 e5 f9 ff ff       	jmp    80105c17 <alltraps>

80106232 <vector31>:
.globl vector31
vector31:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $31
80106234:	6a 1f                	push   $0x1f
  jmp alltraps
80106236:	e9 dc f9 ff ff       	jmp    80105c17 <alltraps>

8010623b <vector32>:
.globl vector32
vector32:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $32
8010623d:	6a 20                	push   $0x20
  jmp alltraps
8010623f:	e9 d3 f9 ff ff       	jmp    80105c17 <alltraps>

80106244 <vector33>:
.globl vector33
vector33:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $33
80106246:	6a 21                	push   $0x21
  jmp alltraps
80106248:	e9 ca f9 ff ff       	jmp    80105c17 <alltraps>

8010624d <vector34>:
.globl vector34
vector34:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $34
8010624f:	6a 22                	push   $0x22
  jmp alltraps
80106251:	e9 c1 f9 ff ff       	jmp    80105c17 <alltraps>

80106256 <vector35>:
.globl vector35
vector35:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $35
80106258:	6a 23                	push   $0x23
  jmp alltraps
8010625a:	e9 b8 f9 ff ff       	jmp    80105c17 <alltraps>

8010625f <vector36>:
.globl vector36
vector36:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $36
80106261:	6a 24                	push   $0x24
  jmp alltraps
80106263:	e9 af f9 ff ff       	jmp    80105c17 <alltraps>

80106268 <vector37>:
.globl vector37
vector37:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $37
8010626a:	6a 25                	push   $0x25
  jmp alltraps
8010626c:	e9 a6 f9 ff ff       	jmp    80105c17 <alltraps>

80106271 <vector38>:
.globl vector38
vector38:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $38
80106273:	6a 26                	push   $0x26
  jmp alltraps
80106275:	e9 9d f9 ff ff       	jmp    80105c17 <alltraps>

8010627a <vector39>:
.globl vector39
vector39:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $39
8010627c:	6a 27                	push   $0x27
  jmp alltraps
8010627e:	e9 94 f9 ff ff       	jmp    80105c17 <alltraps>

80106283 <vector40>:
.globl vector40
vector40:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $40
80106285:	6a 28                	push   $0x28
  jmp alltraps
80106287:	e9 8b f9 ff ff       	jmp    80105c17 <alltraps>

8010628c <vector41>:
.globl vector41
vector41:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $41
8010628e:	6a 29                	push   $0x29
  jmp alltraps
80106290:	e9 82 f9 ff ff       	jmp    80105c17 <alltraps>

80106295 <vector42>:
.globl vector42
vector42:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $42
80106297:	6a 2a                	push   $0x2a
  jmp alltraps
80106299:	e9 79 f9 ff ff       	jmp    80105c17 <alltraps>

8010629e <vector43>:
.globl vector43
vector43:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $43
801062a0:	6a 2b                	push   $0x2b
  jmp alltraps
801062a2:	e9 70 f9 ff ff       	jmp    80105c17 <alltraps>

801062a7 <vector44>:
.globl vector44
vector44:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $44
801062a9:	6a 2c                	push   $0x2c
  jmp alltraps
801062ab:	e9 67 f9 ff ff       	jmp    80105c17 <alltraps>

801062b0 <vector45>:
.globl vector45
vector45:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $45
801062b2:	6a 2d                	push   $0x2d
  jmp alltraps
801062b4:	e9 5e f9 ff ff       	jmp    80105c17 <alltraps>

801062b9 <vector46>:
.globl vector46
vector46:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $46
801062bb:	6a 2e                	push   $0x2e
  jmp alltraps
801062bd:	e9 55 f9 ff ff       	jmp    80105c17 <alltraps>

801062c2 <vector47>:
.globl vector47
vector47:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $47
801062c4:	6a 2f                	push   $0x2f
  jmp alltraps
801062c6:	e9 4c f9 ff ff       	jmp    80105c17 <alltraps>

801062cb <vector48>:
.globl vector48
vector48:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $48
801062cd:	6a 30                	push   $0x30
  jmp alltraps
801062cf:	e9 43 f9 ff ff       	jmp    80105c17 <alltraps>

801062d4 <vector49>:
.globl vector49
vector49:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $49
801062d6:	6a 31                	push   $0x31
  jmp alltraps
801062d8:	e9 3a f9 ff ff       	jmp    80105c17 <alltraps>

801062dd <vector50>:
.globl vector50
vector50:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $50
801062df:	6a 32                	push   $0x32
  jmp alltraps
801062e1:	e9 31 f9 ff ff       	jmp    80105c17 <alltraps>

801062e6 <vector51>:
.globl vector51
vector51:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $51
801062e8:	6a 33                	push   $0x33
  jmp alltraps
801062ea:	e9 28 f9 ff ff       	jmp    80105c17 <alltraps>

801062ef <vector52>:
.globl vector52
vector52:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $52
801062f1:	6a 34                	push   $0x34
  jmp alltraps
801062f3:	e9 1f f9 ff ff       	jmp    80105c17 <alltraps>

801062f8 <vector53>:
.globl vector53
vector53:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $53
801062fa:	6a 35                	push   $0x35
  jmp alltraps
801062fc:	e9 16 f9 ff ff       	jmp    80105c17 <alltraps>

80106301 <vector54>:
.globl vector54
vector54:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $54
80106303:	6a 36                	push   $0x36
  jmp alltraps
80106305:	e9 0d f9 ff ff       	jmp    80105c17 <alltraps>

8010630a <vector55>:
.globl vector55
vector55:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $55
8010630c:	6a 37                	push   $0x37
  jmp alltraps
8010630e:	e9 04 f9 ff ff       	jmp    80105c17 <alltraps>

80106313 <vector56>:
.globl vector56
vector56:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $56
80106315:	6a 38                	push   $0x38
  jmp alltraps
80106317:	e9 fb f8 ff ff       	jmp    80105c17 <alltraps>

8010631c <vector57>:
.globl vector57
vector57:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $57
8010631e:	6a 39                	push   $0x39
  jmp alltraps
80106320:	e9 f2 f8 ff ff       	jmp    80105c17 <alltraps>

80106325 <vector58>:
.globl vector58
vector58:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $58
80106327:	6a 3a                	push   $0x3a
  jmp alltraps
80106329:	e9 e9 f8 ff ff       	jmp    80105c17 <alltraps>

8010632e <vector59>:
.globl vector59
vector59:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $59
80106330:	6a 3b                	push   $0x3b
  jmp alltraps
80106332:	e9 e0 f8 ff ff       	jmp    80105c17 <alltraps>

80106337 <vector60>:
.globl vector60
vector60:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $60
80106339:	6a 3c                	push   $0x3c
  jmp alltraps
8010633b:	e9 d7 f8 ff ff       	jmp    80105c17 <alltraps>

80106340 <vector61>:
.globl vector61
vector61:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $61
80106342:	6a 3d                	push   $0x3d
  jmp alltraps
80106344:	e9 ce f8 ff ff       	jmp    80105c17 <alltraps>

80106349 <vector62>:
.globl vector62
vector62:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $62
8010634b:	6a 3e                	push   $0x3e
  jmp alltraps
8010634d:	e9 c5 f8 ff ff       	jmp    80105c17 <alltraps>

80106352 <vector63>:
.globl vector63
vector63:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $63
80106354:	6a 3f                	push   $0x3f
  jmp alltraps
80106356:	e9 bc f8 ff ff       	jmp    80105c17 <alltraps>

8010635b <vector64>:
.globl vector64
vector64:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $64
8010635d:	6a 40                	push   $0x40
  jmp alltraps
8010635f:	e9 b3 f8 ff ff       	jmp    80105c17 <alltraps>

80106364 <vector65>:
.globl vector65
vector65:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $65
80106366:	6a 41                	push   $0x41
  jmp alltraps
80106368:	e9 aa f8 ff ff       	jmp    80105c17 <alltraps>

8010636d <vector66>:
.globl vector66
vector66:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $66
8010636f:	6a 42                	push   $0x42
  jmp alltraps
80106371:	e9 a1 f8 ff ff       	jmp    80105c17 <alltraps>

80106376 <vector67>:
.globl vector67
vector67:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $67
80106378:	6a 43                	push   $0x43
  jmp alltraps
8010637a:	e9 98 f8 ff ff       	jmp    80105c17 <alltraps>

8010637f <vector68>:
.globl vector68
vector68:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $68
80106381:	6a 44                	push   $0x44
  jmp alltraps
80106383:	e9 8f f8 ff ff       	jmp    80105c17 <alltraps>

80106388 <vector69>:
.globl vector69
vector69:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $69
8010638a:	6a 45                	push   $0x45
  jmp alltraps
8010638c:	e9 86 f8 ff ff       	jmp    80105c17 <alltraps>

80106391 <vector70>:
.globl vector70
vector70:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $70
80106393:	6a 46                	push   $0x46
  jmp alltraps
80106395:	e9 7d f8 ff ff       	jmp    80105c17 <alltraps>

8010639a <vector71>:
.globl vector71
vector71:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $71
8010639c:	6a 47                	push   $0x47
  jmp alltraps
8010639e:	e9 74 f8 ff ff       	jmp    80105c17 <alltraps>

801063a3 <vector72>:
.globl vector72
vector72:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $72
801063a5:	6a 48                	push   $0x48
  jmp alltraps
801063a7:	e9 6b f8 ff ff       	jmp    80105c17 <alltraps>

801063ac <vector73>:
.globl vector73
vector73:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $73
801063ae:	6a 49                	push   $0x49
  jmp alltraps
801063b0:	e9 62 f8 ff ff       	jmp    80105c17 <alltraps>

801063b5 <vector74>:
.globl vector74
vector74:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $74
801063b7:	6a 4a                	push   $0x4a
  jmp alltraps
801063b9:	e9 59 f8 ff ff       	jmp    80105c17 <alltraps>

801063be <vector75>:
.globl vector75
vector75:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $75
801063c0:	6a 4b                	push   $0x4b
  jmp alltraps
801063c2:	e9 50 f8 ff ff       	jmp    80105c17 <alltraps>

801063c7 <vector76>:
.globl vector76
vector76:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $76
801063c9:	6a 4c                	push   $0x4c
  jmp alltraps
801063cb:	e9 47 f8 ff ff       	jmp    80105c17 <alltraps>

801063d0 <vector77>:
.globl vector77
vector77:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $77
801063d2:	6a 4d                	push   $0x4d
  jmp alltraps
801063d4:	e9 3e f8 ff ff       	jmp    80105c17 <alltraps>

801063d9 <vector78>:
.globl vector78
vector78:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $78
801063db:	6a 4e                	push   $0x4e
  jmp alltraps
801063dd:	e9 35 f8 ff ff       	jmp    80105c17 <alltraps>

801063e2 <vector79>:
.globl vector79
vector79:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $79
801063e4:	6a 4f                	push   $0x4f
  jmp alltraps
801063e6:	e9 2c f8 ff ff       	jmp    80105c17 <alltraps>

801063eb <vector80>:
.globl vector80
vector80:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $80
801063ed:	6a 50                	push   $0x50
  jmp alltraps
801063ef:	e9 23 f8 ff ff       	jmp    80105c17 <alltraps>

801063f4 <vector81>:
.globl vector81
vector81:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $81
801063f6:	6a 51                	push   $0x51
  jmp alltraps
801063f8:	e9 1a f8 ff ff       	jmp    80105c17 <alltraps>

801063fd <vector82>:
.globl vector82
vector82:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $82
801063ff:	6a 52                	push   $0x52
  jmp alltraps
80106401:	e9 11 f8 ff ff       	jmp    80105c17 <alltraps>

80106406 <vector83>:
.globl vector83
vector83:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $83
80106408:	6a 53                	push   $0x53
  jmp alltraps
8010640a:	e9 08 f8 ff ff       	jmp    80105c17 <alltraps>

8010640f <vector84>:
.globl vector84
vector84:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $84
80106411:	6a 54                	push   $0x54
  jmp alltraps
80106413:	e9 ff f7 ff ff       	jmp    80105c17 <alltraps>

80106418 <vector85>:
.globl vector85
vector85:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $85
8010641a:	6a 55                	push   $0x55
  jmp alltraps
8010641c:	e9 f6 f7 ff ff       	jmp    80105c17 <alltraps>

80106421 <vector86>:
.globl vector86
vector86:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $86
80106423:	6a 56                	push   $0x56
  jmp alltraps
80106425:	e9 ed f7 ff ff       	jmp    80105c17 <alltraps>

8010642a <vector87>:
.globl vector87
vector87:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $87
8010642c:	6a 57                	push   $0x57
  jmp alltraps
8010642e:	e9 e4 f7 ff ff       	jmp    80105c17 <alltraps>

80106433 <vector88>:
.globl vector88
vector88:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $88
80106435:	6a 58                	push   $0x58
  jmp alltraps
80106437:	e9 db f7 ff ff       	jmp    80105c17 <alltraps>

8010643c <vector89>:
.globl vector89
vector89:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $89
8010643e:	6a 59                	push   $0x59
  jmp alltraps
80106440:	e9 d2 f7 ff ff       	jmp    80105c17 <alltraps>

80106445 <vector90>:
.globl vector90
vector90:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $90
80106447:	6a 5a                	push   $0x5a
  jmp alltraps
80106449:	e9 c9 f7 ff ff       	jmp    80105c17 <alltraps>

8010644e <vector91>:
.globl vector91
vector91:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $91
80106450:	6a 5b                	push   $0x5b
  jmp alltraps
80106452:	e9 c0 f7 ff ff       	jmp    80105c17 <alltraps>

80106457 <vector92>:
.globl vector92
vector92:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $92
80106459:	6a 5c                	push   $0x5c
  jmp alltraps
8010645b:	e9 b7 f7 ff ff       	jmp    80105c17 <alltraps>

80106460 <vector93>:
.globl vector93
vector93:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $93
80106462:	6a 5d                	push   $0x5d
  jmp alltraps
80106464:	e9 ae f7 ff ff       	jmp    80105c17 <alltraps>

80106469 <vector94>:
.globl vector94
vector94:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $94
8010646b:	6a 5e                	push   $0x5e
  jmp alltraps
8010646d:	e9 a5 f7 ff ff       	jmp    80105c17 <alltraps>

80106472 <vector95>:
.globl vector95
vector95:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $95
80106474:	6a 5f                	push   $0x5f
  jmp alltraps
80106476:	e9 9c f7 ff ff       	jmp    80105c17 <alltraps>

8010647b <vector96>:
.globl vector96
vector96:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $96
8010647d:	6a 60                	push   $0x60
  jmp alltraps
8010647f:	e9 93 f7 ff ff       	jmp    80105c17 <alltraps>

80106484 <vector97>:
.globl vector97
vector97:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $97
80106486:	6a 61                	push   $0x61
  jmp alltraps
80106488:	e9 8a f7 ff ff       	jmp    80105c17 <alltraps>

8010648d <vector98>:
.globl vector98
vector98:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $98
8010648f:	6a 62                	push   $0x62
  jmp alltraps
80106491:	e9 81 f7 ff ff       	jmp    80105c17 <alltraps>

80106496 <vector99>:
.globl vector99
vector99:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $99
80106498:	6a 63                	push   $0x63
  jmp alltraps
8010649a:	e9 78 f7 ff ff       	jmp    80105c17 <alltraps>

8010649f <vector100>:
.globl vector100
vector100:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $100
801064a1:	6a 64                	push   $0x64
  jmp alltraps
801064a3:	e9 6f f7 ff ff       	jmp    80105c17 <alltraps>

801064a8 <vector101>:
.globl vector101
vector101:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $101
801064aa:	6a 65                	push   $0x65
  jmp alltraps
801064ac:	e9 66 f7 ff ff       	jmp    80105c17 <alltraps>

801064b1 <vector102>:
.globl vector102
vector102:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $102
801064b3:	6a 66                	push   $0x66
  jmp alltraps
801064b5:	e9 5d f7 ff ff       	jmp    80105c17 <alltraps>

801064ba <vector103>:
.globl vector103
vector103:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $103
801064bc:	6a 67                	push   $0x67
  jmp alltraps
801064be:	e9 54 f7 ff ff       	jmp    80105c17 <alltraps>

801064c3 <vector104>:
.globl vector104
vector104:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $104
801064c5:	6a 68                	push   $0x68
  jmp alltraps
801064c7:	e9 4b f7 ff ff       	jmp    80105c17 <alltraps>

801064cc <vector105>:
.globl vector105
vector105:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $105
801064ce:	6a 69                	push   $0x69
  jmp alltraps
801064d0:	e9 42 f7 ff ff       	jmp    80105c17 <alltraps>

801064d5 <vector106>:
.globl vector106
vector106:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $106
801064d7:	6a 6a                	push   $0x6a
  jmp alltraps
801064d9:	e9 39 f7 ff ff       	jmp    80105c17 <alltraps>

801064de <vector107>:
.globl vector107
vector107:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $107
801064e0:	6a 6b                	push   $0x6b
  jmp alltraps
801064e2:	e9 30 f7 ff ff       	jmp    80105c17 <alltraps>

801064e7 <vector108>:
.globl vector108
vector108:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $108
801064e9:	6a 6c                	push   $0x6c
  jmp alltraps
801064eb:	e9 27 f7 ff ff       	jmp    80105c17 <alltraps>

801064f0 <vector109>:
.globl vector109
vector109:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $109
801064f2:	6a 6d                	push   $0x6d
  jmp alltraps
801064f4:	e9 1e f7 ff ff       	jmp    80105c17 <alltraps>

801064f9 <vector110>:
.globl vector110
vector110:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $110
801064fb:	6a 6e                	push   $0x6e
  jmp alltraps
801064fd:	e9 15 f7 ff ff       	jmp    80105c17 <alltraps>

80106502 <vector111>:
.globl vector111
vector111:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $111
80106504:	6a 6f                	push   $0x6f
  jmp alltraps
80106506:	e9 0c f7 ff ff       	jmp    80105c17 <alltraps>

8010650b <vector112>:
.globl vector112
vector112:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $112
8010650d:	6a 70                	push   $0x70
  jmp alltraps
8010650f:	e9 03 f7 ff ff       	jmp    80105c17 <alltraps>

80106514 <vector113>:
.globl vector113
vector113:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $113
80106516:	6a 71                	push   $0x71
  jmp alltraps
80106518:	e9 fa f6 ff ff       	jmp    80105c17 <alltraps>

8010651d <vector114>:
.globl vector114
vector114:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $114
8010651f:	6a 72                	push   $0x72
  jmp alltraps
80106521:	e9 f1 f6 ff ff       	jmp    80105c17 <alltraps>

80106526 <vector115>:
.globl vector115
vector115:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $115
80106528:	6a 73                	push   $0x73
  jmp alltraps
8010652a:	e9 e8 f6 ff ff       	jmp    80105c17 <alltraps>

8010652f <vector116>:
.globl vector116
vector116:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $116
80106531:	6a 74                	push   $0x74
  jmp alltraps
80106533:	e9 df f6 ff ff       	jmp    80105c17 <alltraps>

80106538 <vector117>:
.globl vector117
vector117:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $117
8010653a:	6a 75                	push   $0x75
  jmp alltraps
8010653c:	e9 d6 f6 ff ff       	jmp    80105c17 <alltraps>

80106541 <vector118>:
.globl vector118
vector118:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $118
80106543:	6a 76                	push   $0x76
  jmp alltraps
80106545:	e9 cd f6 ff ff       	jmp    80105c17 <alltraps>

8010654a <vector119>:
.globl vector119
vector119:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $119
8010654c:	6a 77                	push   $0x77
  jmp alltraps
8010654e:	e9 c4 f6 ff ff       	jmp    80105c17 <alltraps>

80106553 <vector120>:
.globl vector120
vector120:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $120
80106555:	6a 78                	push   $0x78
  jmp alltraps
80106557:	e9 bb f6 ff ff       	jmp    80105c17 <alltraps>

8010655c <vector121>:
.globl vector121
vector121:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $121
8010655e:	6a 79                	push   $0x79
  jmp alltraps
80106560:	e9 b2 f6 ff ff       	jmp    80105c17 <alltraps>

80106565 <vector122>:
.globl vector122
vector122:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $122
80106567:	6a 7a                	push   $0x7a
  jmp alltraps
80106569:	e9 a9 f6 ff ff       	jmp    80105c17 <alltraps>

8010656e <vector123>:
.globl vector123
vector123:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $123
80106570:	6a 7b                	push   $0x7b
  jmp alltraps
80106572:	e9 a0 f6 ff ff       	jmp    80105c17 <alltraps>

80106577 <vector124>:
.globl vector124
vector124:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $124
80106579:	6a 7c                	push   $0x7c
  jmp alltraps
8010657b:	e9 97 f6 ff ff       	jmp    80105c17 <alltraps>

80106580 <vector125>:
.globl vector125
vector125:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $125
80106582:	6a 7d                	push   $0x7d
  jmp alltraps
80106584:	e9 8e f6 ff ff       	jmp    80105c17 <alltraps>

80106589 <vector126>:
.globl vector126
vector126:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $126
8010658b:	6a 7e                	push   $0x7e
  jmp alltraps
8010658d:	e9 85 f6 ff ff       	jmp    80105c17 <alltraps>

80106592 <vector127>:
.globl vector127
vector127:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $127
80106594:	6a 7f                	push   $0x7f
  jmp alltraps
80106596:	e9 7c f6 ff ff       	jmp    80105c17 <alltraps>

8010659b <vector128>:
.globl vector128
vector128:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $128
8010659d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065a2:	e9 70 f6 ff ff       	jmp    80105c17 <alltraps>

801065a7 <vector129>:
.globl vector129
vector129:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $129
801065a9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065ae:	e9 64 f6 ff ff       	jmp    80105c17 <alltraps>

801065b3 <vector130>:
.globl vector130
vector130:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $130
801065b5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065ba:	e9 58 f6 ff ff       	jmp    80105c17 <alltraps>

801065bf <vector131>:
.globl vector131
vector131:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $131
801065c1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065c6:	e9 4c f6 ff ff       	jmp    80105c17 <alltraps>

801065cb <vector132>:
.globl vector132
vector132:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $132
801065cd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065d2:	e9 40 f6 ff ff       	jmp    80105c17 <alltraps>

801065d7 <vector133>:
.globl vector133
vector133:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $133
801065d9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065de:	e9 34 f6 ff ff       	jmp    80105c17 <alltraps>

801065e3 <vector134>:
.globl vector134
vector134:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $134
801065e5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065ea:	e9 28 f6 ff ff       	jmp    80105c17 <alltraps>

801065ef <vector135>:
.globl vector135
vector135:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $135
801065f1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065f6:	e9 1c f6 ff ff       	jmp    80105c17 <alltraps>

801065fb <vector136>:
.globl vector136
vector136:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $136
801065fd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106602:	e9 10 f6 ff ff       	jmp    80105c17 <alltraps>

80106607 <vector137>:
.globl vector137
vector137:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $137
80106609:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010660e:	e9 04 f6 ff ff       	jmp    80105c17 <alltraps>

80106613 <vector138>:
.globl vector138
vector138:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $138
80106615:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010661a:	e9 f8 f5 ff ff       	jmp    80105c17 <alltraps>

8010661f <vector139>:
.globl vector139
vector139:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $139
80106621:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106626:	e9 ec f5 ff ff       	jmp    80105c17 <alltraps>

8010662b <vector140>:
.globl vector140
vector140:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $140
8010662d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106632:	e9 e0 f5 ff ff       	jmp    80105c17 <alltraps>

80106637 <vector141>:
.globl vector141
vector141:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $141
80106639:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010663e:	e9 d4 f5 ff ff       	jmp    80105c17 <alltraps>

80106643 <vector142>:
.globl vector142
vector142:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $142
80106645:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010664a:	e9 c8 f5 ff ff       	jmp    80105c17 <alltraps>

8010664f <vector143>:
.globl vector143
vector143:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $143
80106651:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106656:	e9 bc f5 ff ff       	jmp    80105c17 <alltraps>

8010665b <vector144>:
.globl vector144
vector144:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $144
8010665d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106662:	e9 b0 f5 ff ff       	jmp    80105c17 <alltraps>

80106667 <vector145>:
.globl vector145
vector145:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $145
80106669:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010666e:	e9 a4 f5 ff ff       	jmp    80105c17 <alltraps>

80106673 <vector146>:
.globl vector146
vector146:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $146
80106675:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010667a:	e9 98 f5 ff ff       	jmp    80105c17 <alltraps>

8010667f <vector147>:
.globl vector147
vector147:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $147
80106681:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106686:	e9 8c f5 ff ff       	jmp    80105c17 <alltraps>

8010668b <vector148>:
.globl vector148
vector148:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $148
8010668d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106692:	e9 80 f5 ff ff       	jmp    80105c17 <alltraps>

80106697 <vector149>:
.globl vector149
vector149:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $149
80106699:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010669e:	e9 74 f5 ff ff       	jmp    80105c17 <alltraps>

801066a3 <vector150>:
.globl vector150
vector150:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $150
801066a5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066aa:	e9 68 f5 ff ff       	jmp    80105c17 <alltraps>

801066af <vector151>:
.globl vector151
vector151:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $151
801066b1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066b6:	e9 5c f5 ff ff       	jmp    80105c17 <alltraps>

801066bb <vector152>:
.globl vector152
vector152:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $152
801066bd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066c2:	e9 50 f5 ff ff       	jmp    80105c17 <alltraps>

801066c7 <vector153>:
.globl vector153
vector153:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $153
801066c9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ce:	e9 44 f5 ff ff       	jmp    80105c17 <alltraps>

801066d3 <vector154>:
.globl vector154
vector154:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $154
801066d5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066da:	e9 38 f5 ff ff       	jmp    80105c17 <alltraps>

801066df <vector155>:
.globl vector155
vector155:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $155
801066e1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066e6:	e9 2c f5 ff ff       	jmp    80105c17 <alltraps>

801066eb <vector156>:
.globl vector156
vector156:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $156
801066ed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066f2:	e9 20 f5 ff ff       	jmp    80105c17 <alltraps>

801066f7 <vector157>:
.globl vector157
vector157:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $157
801066f9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066fe:	e9 14 f5 ff ff       	jmp    80105c17 <alltraps>

80106703 <vector158>:
.globl vector158
vector158:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $158
80106705:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010670a:	e9 08 f5 ff ff       	jmp    80105c17 <alltraps>

8010670f <vector159>:
.globl vector159
vector159:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $159
80106711:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106716:	e9 fc f4 ff ff       	jmp    80105c17 <alltraps>

8010671b <vector160>:
.globl vector160
vector160:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $160
8010671d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106722:	e9 f0 f4 ff ff       	jmp    80105c17 <alltraps>

80106727 <vector161>:
.globl vector161
vector161:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $161
80106729:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010672e:	e9 e4 f4 ff ff       	jmp    80105c17 <alltraps>

80106733 <vector162>:
.globl vector162
vector162:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $162
80106735:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010673a:	e9 d8 f4 ff ff       	jmp    80105c17 <alltraps>

8010673f <vector163>:
.globl vector163
vector163:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $163
80106741:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106746:	e9 cc f4 ff ff       	jmp    80105c17 <alltraps>

8010674b <vector164>:
.globl vector164
vector164:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $164
8010674d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106752:	e9 c0 f4 ff ff       	jmp    80105c17 <alltraps>

80106757 <vector165>:
.globl vector165
vector165:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $165
80106759:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010675e:	e9 b4 f4 ff ff       	jmp    80105c17 <alltraps>

80106763 <vector166>:
.globl vector166
vector166:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $166
80106765:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010676a:	e9 a8 f4 ff ff       	jmp    80105c17 <alltraps>

8010676f <vector167>:
.globl vector167
vector167:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $167
80106771:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106776:	e9 9c f4 ff ff       	jmp    80105c17 <alltraps>

8010677b <vector168>:
.globl vector168
vector168:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $168
8010677d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106782:	e9 90 f4 ff ff       	jmp    80105c17 <alltraps>

80106787 <vector169>:
.globl vector169
vector169:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $169
80106789:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010678e:	e9 84 f4 ff ff       	jmp    80105c17 <alltraps>

80106793 <vector170>:
.globl vector170
vector170:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $170
80106795:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010679a:	e9 78 f4 ff ff       	jmp    80105c17 <alltraps>

8010679f <vector171>:
.globl vector171
vector171:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $171
801067a1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067a6:	e9 6c f4 ff ff       	jmp    80105c17 <alltraps>

801067ab <vector172>:
.globl vector172
vector172:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $172
801067ad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067b2:	e9 60 f4 ff ff       	jmp    80105c17 <alltraps>

801067b7 <vector173>:
.globl vector173
vector173:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $173
801067b9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067be:	e9 54 f4 ff ff       	jmp    80105c17 <alltraps>

801067c3 <vector174>:
.globl vector174
vector174:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $174
801067c5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067ca:	e9 48 f4 ff ff       	jmp    80105c17 <alltraps>

801067cf <vector175>:
.globl vector175
vector175:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $175
801067d1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067d6:	e9 3c f4 ff ff       	jmp    80105c17 <alltraps>

801067db <vector176>:
.globl vector176
vector176:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $176
801067dd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067e2:	e9 30 f4 ff ff       	jmp    80105c17 <alltraps>

801067e7 <vector177>:
.globl vector177
vector177:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $177
801067e9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067ee:	e9 24 f4 ff ff       	jmp    80105c17 <alltraps>

801067f3 <vector178>:
.globl vector178
vector178:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $178
801067f5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067fa:	e9 18 f4 ff ff       	jmp    80105c17 <alltraps>

801067ff <vector179>:
.globl vector179
vector179:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $179
80106801:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106806:	e9 0c f4 ff ff       	jmp    80105c17 <alltraps>

8010680b <vector180>:
.globl vector180
vector180:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $180
8010680d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106812:	e9 00 f4 ff ff       	jmp    80105c17 <alltraps>

80106817 <vector181>:
.globl vector181
vector181:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $181
80106819:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010681e:	e9 f4 f3 ff ff       	jmp    80105c17 <alltraps>

80106823 <vector182>:
.globl vector182
vector182:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $182
80106825:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010682a:	e9 e8 f3 ff ff       	jmp    80105c17 <alltraps>

8010682f <vector183>:
.globl vector183
vector183:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $183
80106831:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106836:	e9 dc f3 ff ff       	jmp    80105c17 <alltraps>

8010683b <vector184>:
.globl vector184
vector184:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $184
8010683d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106842:	e9 d0 f3 ff ff       	jmp    80105c17 <alltraps>

80106847 <vector185>:
.globl vector185
vector185:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $185
80106849:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010684e:	e9 c4 f3 ff ff       	jmp    80105c17 <alltraps>

80106853 <vector186>:
.globl vector186
vector186:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $186
80106855:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010685a:	e9 b8 f3 ff ff       	jmp    80105c17 <alltraps>

8010685f <vector187>:
.globl vector187
vector187:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $187
80106861:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106866:	e9 ac f3 ff ff       	jmp    80105c17 <alltraps>

8010686b <vector188>:
.globl vector188
vector188:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $188
8010686d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106872:	e9 a0 f3 ff ff       	jmp    80105c17 <alltraps>

80106877 <vector189>:
.globl vector189
vector189:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $189
80106879:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010687e:	e9 94 f3 ff ff       	jmp    80105c17 <alltraps>

80106883 <vector190>:
.globl vector190
vector190:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $190
80106885:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010688a:	e9 88 f3 ff ff       	jmp    80105c17 <alltraps>

8010688f <vector191>:
.globl vector191
vector191:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $191
80106891:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106896:	e9 7c f3 ff ff       	jmp    80105c17 <alltraps>

8010689b <vector192>:
.globl vector192
vector192:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $192
8010689d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068a2:	e9 70 f3 ff ff       	jmp    80105c17 <alltraps>

801068a7 <vector193>:
.globl vector193
vector193:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $193
801068a9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068ae:	e9 64 f3 ff ff       	jmp    80105c17 <alltraps>

801068b3 <vector194>:
.globl vector194
vector194:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $194
801068b5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068ba:	e9 58 f3 ff ff       	jmp    80105c17 <alltraps>

801068bf <vector195>:
.globl vector195
vector195:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $195
801068c1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068c6:	e9 4c f3 ff ff       	jmp    80105c17 <alltraps>

801068cb <vector196>:
.globl vector196
vector196:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $196
801068cd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068d2:	e9 40 f3 ff ff       	jmp    80105c17 <alltraps>

801068d7 <vector197>:
.globl vector197
vector197:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $197
801068d9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068de:	e9 34 f3 ff ff       	jmp    80105c17 <alltraps>

801068e3 <vector198>:
.globl vector198
vector198:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $198
801068e5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068ea:	e9 28 f3 ff ff       	jmp    80105c17 <alltraps>

801068ef <vector199>:
.globl vector199
vector199:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $199
801068f1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068f6:	e9 1c f3 ff ff       	jmp    80105c17 <alltraps>

801068fb <vector200>:
.globl vector200
vector200:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $200
801068fd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106902:	e9 10 f3 ff ff       	jmp    80105c17 <alltraps>

80106907 <vector201>:
.globl vector201
vector201:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $201
80106909:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010690e:	e9 04 f3 ff ff       	jmp    80105c17 <alltraps>

80106913 <vector202>:
.globl vector202
vector202:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $202
80106915:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010691a:	e9 f8 f2 ff ff       	jmp    80105c17 <alltraps>

8010691f <vector203>:
.globl vector203
vector203:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $203
80106921:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106926:	e9 ec f2 ff ff       	jmp    80105c17 <alltraps>

8010692b <vector204>:
.globl vector204
vector204:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $204
8010692d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106932:	e9 e0 f2 ff ff       	jmp    80105c17 <alltraps>

80106937 <vector205>:
.globl vector205
vector205:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $205
80106939:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010693e:	e9 d4 f2 ff ff       	jmp    80105c17 <alltraps>

80106943 <vector206>:
.globl vector206
vector206:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $206
80106945:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010694a:	e9 c8 f2 ff ff       	jmp    80105c17 <alltraps>

8010694f <vector207>:
.globl vector207
vector207:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $207
80106951:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106956:	e9 bc f2 ff ff       	jmp    80105c17 <alltraps>

8010695b <vector208>:
.globl vector208
vector208:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $208
8010695d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106962:	e9 b0 f2 ff ff       	jmp    80105c17 <alltraps>

80106967 <vector209>:
.globl vector209
vector209:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $209
80106969:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010696e:	e9 a4 f2 ff ff       	jmp    80105c17 <alltraps>

80106973 <vector210>:
.globl vector210
vector210:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $210
80106975:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010697a:	e9 98 f2 ff ff       	jmp    80105c17 <alltraps>

8010697f <vector211>:
.globl vector211
vector211:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $211
80106981:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106986:	e9 8c f2 ff ff       	jmp    80105c17 <alltraps>

8010698b <vector212>:
.globl vector212
vector212:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $212
8010698d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106992:	e9 80 f2 ff ff       	jmp    80105c17 <alltraps>

80106997 <vector213>:
.globl vector213
vector213:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $213
80106999:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010699e:	e9 74 f2 ff ff       	jmp    80105c17 <alltraps>

801069a3 <vector214>:
.globl vector214
vector214:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $214
801069a5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069aa:	e9 68 f2 ff ff       	jmp    80105c17 <alltraps>

801069af <vector215>:
.globl vector215
vector215:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $215
801069b1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069b6:	e9 5c f2 ff ff       	jmp    80105c17 <alltraps>

801069bb <vector216>:
.globl vector216
vector216:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $216
801069bd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069c2:	e9 50 f2 ff ff       	jmp    80105c17 <alltraps>

801069c7 <vector217>:
.globl vector217
vector217:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $217
801069c9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ce:	e9 44 f2 ff ff       	jmp    80105c17 <alltraps>

801069d3 <vector218>:
.globl vector218
vector218:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $218
801069d5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069da:	e9 38 f2 ff ff       	jmp    80105c17 <alltraps>

801069df <vector219>:
.globl vector219
vector219:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $219
801069e1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069e6:	e9 2c f2 ff ff       	jmp    80105c17 <alltraps>

801069eb <vector220>:
.globl vector220
vector220:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $220
801069ed:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069f2:	e9 20 f2 ff ff       	jmp    80105c17 <alltraps>

801069f7 <vector221>:
.globl vector221
vector221:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $221
801069f9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069fe:	e9 14 f2 ff ff       	jmp    80105c17 <alltraps>

80106a03 <vector222>:
.globl vector222
vector222:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $222
80106a05:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a0a:	e9 08 f2 ff ff       	jmp    80105c17 <alltraps>

80106a0f <vector223>:
.globl vector223
vector223:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $223
80106a11:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a16:	e9 fc f1 ff ff       	jmp    80105c17 <alltraps>

80106a1b <vector224>:
.globl vector224
vector224:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $224
80106a1d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a22:	e9 f0 f1 ff ff       	jmp    80105c17 <alltraps>

80106a27 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $225
80106a29:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a2e:	e9 e4 f1 ff ff       	jmp    80105c17 <alltraps>

80106a33 <vector226>:
.globl vector226
vector226:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $226
80106a35:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a3a:	e9 d8 f1 ff ff       	jmp    80105c17 <alltraps>

80106a3f <vector227>:
.globl vector227
vector227:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $227
80106a41:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a46:	e9 cc f1 ff ff       	jmp    80105c17 <alltraps>

80106a4b <vector228>:
.globl vector228
vector228:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $228
80106a4d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a52:	e9 c0 f1 ff ff       	jmp    80105c17 <alltraps>

80106a57 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $229
80106a59:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a5e:	e9 b4 f1 ff ff       	jmp    80105c17 <alltraps>

80106a63 <vector230>:
.globl vector230
vector230:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $230
80106a65:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a6a:	e9 a8 f1 ff ff       	jmp    80105c17 <alltraps>

80106a6f <vector231>:
.globl vector231
vector231:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $231
80106a71:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a76:	e9 9c f1 ff ff       	jmp    80105c17 <alltraps>

80106a7b <vector232>:
.globl vector232
vector232:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $232
80106a7d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a82:	e9 90 f1 ff ff       	jmp    80105c17 <alltraps>

80106a87 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $233
80106a89:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a8e:	e9 84 f1 ff ff       	jmp    80105c17 <alltraps>

80106a93 <vector234>:
.globl vector234
vector234:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $234
80106a95:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a9a:	e9 78 f1 ff ff       	jmp    80105c17 <alltraps>

80106a9f <vector235>:
.globl vector235
vector235:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $235
80106aa1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106aa6:	e9 6c f1 ff ff       	jmp    80105c17 <alltraps>

80106aab <vector236>:
.globl vector236
vector236:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $236
80106aad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ab2:	e9 60 f1 ff ff       	jmp    80105c17 <alltraps>

80106ab7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $237
80106ab9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106abe:	e9 54 f1 ff ff       	jmp    80105c17 <alltraps>

80106ac3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $238
80106ac5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106aca:	e9 48 f1 ff ff       	jmp    80105c17 <alltraps>

80106acf <vector239>:
.globl vector239
vector239:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $239
80106ad1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ad6:	e9 3c f1 ff ff       	jmp    80105c17 <alltraps>

80106adb <vector240>:
.globl vector240
vector240:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $240
80106add:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ae2:	e9 30 f1 ff ff       	jmp    80105c17 <alltraps>

80106ae7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $241
80106ae9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106aee:	e9 24 f1 ff ff       	jmp    80105c17 <alltraps>

80106af3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $242
80106af5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106afa:	e9 18 f1 ff ff       	jmp    80105c17 <alltraps>

80106aff <vector243>:
.globl vector243
vector243:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $243
80106b01:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b06:	e9 0c f1 ff ff       	jmp    80105c17 <alltraps>

80106b0b <vector244>:
.globl vector244
vector244:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $244
80106b0d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b12:	e9 00 f1 ff ff       	jmp    80105c17 <alltraps>

80106b17 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $245
80106b19:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b1e:	e9 f4 f0 ff ff       	jmp    80105c17 <alltraps>

80106b23 <vector246>:
.globl vector246
vector246:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $246
80106b25:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b2a:	e9 e8 f0 ff ff       	jmp    80105c17 <alltraps>

80106b2f <vector247>:
.globl vector247
vector247:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $247
80106b31:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b36:	e9 dc f0 ff ff       	jmp    80105c17 <alltraps>

80106b3b <vector248>:
.globl vector248
vector248:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $248
80106b3d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b42:	e9 d0 f0 ff ff       	jmp    80105c17 <alltraps>

80106b47 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $249
80106b49:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b4e:	e9 c4 f0 ff ff       	jmp    80105c17 <alltraps>

80106b53 <vector250>:
.globl vector250
vector250:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $250
80106b55:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b5a:	e9 b8 f0 ff ff       	jmp    80105c17 <alltraps>

80106b5f <vector251>:
.globl vector251
vector251:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $251
80106b61:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b66:	e9 ac f0 ff ff       	jmp    80105c17 <alltraps>

80106b6b <vector252>:
.globl vector252
vector252:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $252
80106b6d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b72:	e9 a0 f0 ff ff       	jmp    80105c17 <alltraps>

80106b77 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $253
80106b79:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b7e:	e9 94 f0 ff ff       	jmp    80105c17 <alltraps>

80106b83 <vector254>:
.globl vector254
vector254:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $254
80106b85:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b8a:	e9 88 f0 ff ff       	jmp    80105c17 <alltraps>

80106b8f <vector255>:
.globl vector255
vector255:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $255
80106b91:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b96:	e9 7c f0 ff ff       	jmp    80105c17 <alltraps>
80106b9b:	66 90                	xchg   %ax,%ax
80106b9d:	66 90                	xchg   %ax,%ax
80106b9f:	90                   	nop

80106ba0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ba6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106bac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bb2:	83 ec 1c             	sub    $0x1c,%esp
80106bb5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bb8:	39 d3                	cmp    %edx,%ebx
80106bba:	73 45                	jae    80106c01 <deallocuvm.part.0+0x61>
80106bbc:	89 c7                	mov    %eax,%edi
80106bbe:	eb 0a                	jmp    80106bca <deallocuvm.part.0+0x2a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106bc0:	8d 59 01             	lea    0x1(%ecx),%ebx
80106bc3:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106bc6:	39 da                	cmp    %ebx,%edx
80106bc8:	76 37                	jbe    80106c01 <deallocuvm.part.0+0x61>
  pde = &pgdir[PDX(va)];
80106bca:	89 d9                	mov    %ebx,%ecx
80106bcc:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106bcf:	8b 04 8f             	mov    (%edi,%ecx,4),%eax
80106bd2:	a8 01                	test   $0x1,%al
80106bd4:	74 ea                	je     80106bc0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106bd6:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106bdd:	c1 ee 0a             	shr    $0xa,%esi
80106be0:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106be6:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
    if(!pte)
80106bed:	85 f6                	test   %esi,%esi
80106bef:	74 cf                	je     80106bc0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106bf1:	8b 06                	mov    (%esi),%eax
80106bf3:	a8 01                	test   $0x1,%al
80106bf5:	75 19                	jne    80106c10 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106bf7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bfd:	39 da                	cmp    %ebx,%edx
80106bff:	77 c9                	ja     80106bca <deallocuvm.part.0+0x2a>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c07:	5b                   	pop    %ebx
80106c08:	5e                   	pop    %esi
80106c09:	5f                   	pop    %edi
80106c0a:	5d                   	pop    %ebp
80106c0b:	c3                   	ret    
80106c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106c10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c15:	74 25                	je     80106c3c <deallocuvm.part.0+0x9c>
      kfree(v);
80106c17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c1a:	05 00 00 00 80       	add    $0x80000000,%eax
80106c1f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106c28:	50                   	push   %eax
80106c29:	e8 22 ba ff ff       	call   80102650 <kfree>
      *pte = 0;
80106c2e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106c34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c37:	83 c4 10             	add    $0x10,%esp
80106c3a:	eb 8a                	jmp    80106bc6 <deallocuvm.part.0+0x26>
        panic("kfree");
80106c3c:	83 ec 0c             	sub    $0xc,%esp
80106c3f:	68 06 78 10 80       	push   $0x80107806
80106c44:	e8 47 97 ff ff       	call   80100390 <panic>
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c50 <mappages>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106c56:	89 d3                	mov    %edx,%ebx
80106c58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c5e:	83 ec 1c             	sub    $0x1c,%esp
80106c61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c70:	8b 45 08             	mov    0x8(%ebp),%eax
80106c73:	29 d8                	sub    %ebx,%eax
80106c75:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c78:	eb 3d                	jmp    80106cb7 <mappages+0x67>
80106c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c80:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c87:	c1 ea 0a             	shr    $0xa,%edx
80106c8a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c90:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c97:	85 d2                	test   %edx,%edx
80106c99:	74 75                	je     80106d10 <mappages+0xc0>
    if(*pte & PTE_P)
80106c9b:	f6 02 01             	testb  $0x1,(%edx)
80106c9e:	0f 85 86 00 00 00    	jne    80106d2a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ca4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ca7:	83 ce 01             	or     $0x1,%esi
80106caa:	89 32                	mov    %esi,(%edx)
    if(a == last)
80106cac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106caf:	74 6f                	je     80106d20 <mappages+0xd0>
    a += PGSIZE;
80106cb1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106cba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cbd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106cc0:	89 d8                	mov    %ebx,%eax
80106cc2:	c1 e8 16             	shr    $0x16,%eax
80106cc5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106cc8:	8b 07                	mov    (%edi),%eax
80106cca:	a8 01                	test   $0x1,%al
80106ccc:	75 b2                	jne    80106c80 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106cce:	e8 3d bb ff ff       	call   80102810 <kalloc>
80106cd3:	85 c0                	test   %eax,%eax
80106cd5:	74 39                	je     80106d10 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106cd7:	83 ec 04             	sub    $0x4,%esp
80106cda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106cdd:	68 00 10 00 00       	push   $0x1000
80106ce2:	6a 00                	push   $0x0
80106ce4:	50                   	push   %eax
80106ce5:	e8 56 dc ff ff       	call   80104940 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106ced:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cf0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106cf6:	83 c8 07             	or     $0x7,%eax
80106cf9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106cfb:	89 d8                	mov    %ebx,%eax
80106cfd:	c1 e8 0a             	shr    $0xa,%eax
80106d00:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d05:	01 c2                	add    %eax,%edx
80106d07:	eb 92                	jmp    80106c9b <mappages+0x4b>
80106d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d18:	5b                   	pop    %ebx
80106d19:	5e                   	pop    %esi
80106d1a:	5f                   	pop    %edi
80106d1b:	5d                   	pop    %ebp
80106d1c:	c3                   	ret    
80106d1d:	8d 76 00             	lea    0x0(%esi),%esi
80106d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d23:	31 c0                	xor    %eax,%eax
}
80106d25:	5b                   	pop    %ebx
80106d26:	5e                   	pop    %esi
80106d27:	5f                   	pop    %edi
80106d28:	5d                   	pop    %ebp
80106d29:	c3                   	ret    
      panic("remap");
80106d2a:	83 ec 0c             	sub    $0xc,%esp
80106d2d:	68 8c 7e 10 80       	push   $0x80107e8c
80106d32:	e8 59 96 ff ff       	call   80100390 <panic>
80106d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3e:	66 90                	xchg   %ax,%ax

80106d40 <seginit>:
{
80106d40:	f3 0f 1e fb          	endbr32 
80106d44:	55                   	push   %ebp
80106d45:	89 e5                	mov    %esp,%ebp
80106d47:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d4a:	e8 01 ce ff ff       	call   80103b50 <cpuid>
  pd[0] = size-1;
80106d4f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d54:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d5a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d5e:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106d65:	ff 00 00 
80106d68:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106d6f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d72:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106d79:	ff 00 00 
80106d7c:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106d83:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d86:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106d8d:	ff 00 00 
80106d90:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106d97:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d9a:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106da1:	ff 00 00 
80106da4:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106dab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dae:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106db3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106db7:	c1 e8 10             	shr    $0x10,%eax
80106dba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dbe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dc1:	0f 01 10             	lgdtl  (%eax)
}
80106dc4:	c9                   	leave  
80106dc5:	c3                   	ret    
80106dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dcd:	8d 76 00             	lea    0x0(%esi),%esi

80106dd0 <switchkvm>:
{
80106dd0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd4:	a1 e4 44 11 80       	mov    0x801144e4,%eax
80106dd9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dde:	0f 22 d8             	mov    %eax,%cr3
}
80106de1:	c3                   	ret    
80106de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106df0 <switchuvm>:
{
80106df0:	f3 0f 1e fb          	endbr32 
80106df4:	55                   	push   %ebp
80106df5:	89 e5                	mov    %esp,%ebp
80106df7:	57                   	push   %edi
80106df8:	56                   	push   %esi
80106df9:	53                   	push   %ebx
80106dfa:	83 ec 1c             	sub    $0x1c,%esp
80106dfd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106e00:	85 f6                	test   %esi,%esi
80106e02:	0f 84 cb 00 00 00    	je     80106ed3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106e08:	8b 46 08             	mov    0x8(%esi),%eax
80106e0b:	85 c0                	test   %eax,%eax
80106e0d:	0f 84 da 00 00 00    	je     80106eed <switchuvm+0xfd>
  if(p->pgdir == 0)
80106e13:	8b 46 04             	mov    0x4(%esi),%eax
80106e16:	85 c0                	test   %eax,%eax
80106e18:	0f 84 c2 00 00 00    	je     80106ee0 <switchuvm+0xf0>
  pushcli();
80106e1e:	e8 dd d8 ff ff       	call   80104700 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e23:	e8 b8 cc ff ff       	call   80103ae0 <mycpu>
80106e28:	89 c3                	mov    %eax,%ebx
80106e2a:	e8 b1 cc ff ff       	call   80103ae0 <mycpu>
80106e2f:	89 c7                	mov    %eax,%edi
80106e31:	e8 aa cc ff ff       	call   80103ae0 <mycpu>
80106e36:	83 c7 08             	add    $0x8,%edi
80106e39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e3c:	e8 9f cc ff ff       	call   80103ae0 <mycpu>
80106e41:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e44:	ba 67 00 00 00       	mov    $0x67,%edx
80106e49:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106e50:	83 c0 08             	add    $0x8,%eax
80106e53:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e5a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e5f:	83 c1 08             	add    $0x8,%ecx
80106e62:	c1 e8 18             	shr    $0x18,%eax
80106e65:	c1 e9 10             	shr    $0x10,%ecx
80106e68:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106e6e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106e74:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e79:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e80:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106e85:	e8 56 cc ff ff       	call   80103ae0 <mycpu>
80106e8a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e91:	e8 4a cc ff ff       	call   80103ae0 <mycpu>
80106e96:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e9a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106e9d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ea3:	e8 38 cc ff ff       	call   80103ae0 <mycpu>
80106ea8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106eab:	e8 30 cc ff ff       	call   80103ae0 <mycpu>
80106eb0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106eb4:	b8 28 00 00 00       	mov    $0x28,%eax
80106eb9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ebc:	8b 46 04             	mov    0x4(%esi),%eax
80106ebf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ec4:	0f 22 d8             	mov    %eax,%cr3
}
80106ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eca:	5b                   	pop    %ebx
80106ecb:	5e                   	pop    %esi
80106ecc:	5f                   	pop    %edi
80106ecd:	5d                   	pop    %ebp
  popcli();
80106ece:	e9 7d d8 ff ff       	jmp    80104750 <popcli>
    panic("switchuvm: no process");
80106ed3:	83 ec 0c             	sub    $0xc,%esp
80106ed6:	68 92 7e 10 80       	push   $0x80107e92
80106edb:	e8 b0 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106ee0:	83 ec 0c             	sub    $0xc,%esp
80106ee3:	68 bd 7e 10 80       	push   $0x80107ebd
80106ee8:	e8 a3 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106eed:	83 ec 0c             	sub    $0xc,%esp
80106ef0:	68 a8 7e 10 80       	push   $0x80107ea8
80106ef5:	e8 96 94 ff ff       	call   80100390 <panic>
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f00 <inituvm>:
{
80106f00:	f3 0f 1e fb          	endbr32 
80106f04:	55                   	push   %ebp
80106f05:	89 e5                	mov    %esp,%ebp
80106f07:	57                   	push   %edi
80106f08:	56                   	push   %esi
80106f09:	53                   	push   %ebx
80106f0a:	83 ec 1c             	sub    $0x1c,%esp
80106f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f10:	8b 75 10             	mov    0x10(%ebp),%esi
80106f13:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f19:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f1f:	77 4b                	ja     80106f6c <inituvm+0x6c>
  mem = kalloc();
80106f21:	e8 ea b8 ff ff       	call   80102810 <kalloc>
  memset(mem, 0, PGSIZE);
80106f26:	83 ec 04             	sub    $0x4,%esp
80106f29:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106f2e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f30:	6a 00                	push   $0x0
80106f32:	50                   	push   %eax
80106f33:	e8 08 da ff ff       	call   80104940 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f38:	58                   	pop    %eax
80106f39:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f3f:	5a                   	pop    %edx
80106f40:	6a 06                	push   $0x6
80106f42:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f47:	31 d2                	xor    %edx,%edx
80106f49:	50                   	push   %eax
80106f4a:	89 f8                	mov    %edi,%eax
80106f4c:	e8 ff fc ff ff       	call   80106c50 <mappages>
  memmove(mem, init, sz);
80106f51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f54:	89 75 10             	mov    %esi,0x10(%ebp)
80106f57:	83 c4 10             	add    $0x10,%esp
80106f5a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106f5d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f63:	5b                   	pop    %ebx
80106f64:	5e                   	pop    %esi
80106f65:	5f                   	pop    %edi
80106f66:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f67:	e9 74 da ff ff       	jmp    801049e0 <memmove>
    panic("inituvm: more than a page");
80106f6c:	83 ec 0c             	sub    $0xc,%esp
80106f6f:	68 d1 7e 10 80       	push   $0x80107ed1
80106f74:	e8 17 94 ff ff       	call   80100390 <panic>
80106f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f80 <loaduvm>:
{
80106f80:	f3 0f 1e fb          	endbr32 
80106f84:	55                   	push   %ebp
80106f85:	89 e5                	mov    %esp,%ebp
80106f87:	57                   	push   %edi
80106f88:	56                   	push   %esi
80106f89:	53                   	push   %ebx
80106f8a:	83 ec 1c             	sub    $0x1c,%esp
80106f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f90:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106f93:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106f98:	0f 85 b7 00 00 00    	jne    80107055 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106f9e:	01 f0                	add    %esi,%eax
80106fa0:	89 f3                	mov    %esi,%ebx
80106fa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fa5:	8b 45 14             	mov    0x14(%ebp),%eax
80106fa8:	01 f0                	add    %esi,%eax
80106faa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106fad:	85 f6                	test   %esi,%esi
80106faf:	0f 84 83 00 00 00    	je     80107038 <loaduvm+0xb8>
80106fb5:	8d 76 00             	lea    0x0(%esi),%esi
  pde = &pgdir[PDX(va)];
80106fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106fbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106fbe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106fc0:	89 c2                	mov    %eax,%edx
80106fc2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106fc5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106fc8:	f6 c2 01             	test   $0x1,%dl
80106fcb:	75 13                	jne    80106fe0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106fcd:	83 ec 0c             	sub    $0xc,%esp
80106fd0:	68 eb 7e 10 80       	push   $0x80107eeb
80106fd5:	e8 b6 93 ff ff       	call   80100390 <panic>
80106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fe0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fe3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106fe9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106fee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ff5:	85 c0                	test   %eax,%eax
80106ff7:	74 d4                	je     80106fcd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106ff9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ffb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ffe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107003:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107008:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010700e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107011:	29 d9                	sub    %ebx,%ecx
80107013:	05 00 00 00 80       	add    $0x80000000,%eax
80107018:	57                   	push   %edi
80107019:	51                   	push   %ecx
8010701a:	50                   	push   %eax
8010701b:	ff 75 10             	pushl  0x10(%ebp)
8010701e:	e8 cd ab ff ff       	call   80101bf0 <readi>
80107023:	83 c4 10             	add    $0x10,%esp
80107026:	39 f8                	cmp    %edi,%eax
80107028:	75 1e                	jne    80107048 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010702a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107030:	89 f0                	mov    %esi,%eax
80107032:	29 d8                	sub    %ebx,%eax
80107034:	39 c6                	cmp    %eax,%esi
80107036:	77 80                	ja     80106fb8 <loaduvm+0x38>
}
80107038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010703b:	31 c0                	xor    %eax,%eax
}
8010703d:	5b                   	pop    %ebx
8010703e:	5e                   	pop    %esi
8010703f:	5f                   	pop    %edi
80107040:	5d                   	pop    %ebp
80107041:	c3                   	ret    
80107042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107048:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010704b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107050:	5b                   	pop    %ebx
80107051:	5e                   	pop    %esi
80107052:	5f                   	pop    %edi
80107053:	5d                   	pop    %ebp
80107054:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107055:	83 ec 0c             	sub    $0xc,%esp
80107058:	68 8c 7f 10 80       	push   $0x80107f8c
8010705d:	e8 2e 93 ff ff       	call   80100390 <panic>
80107062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107070 <allocuvm>:
{
80107070:	f3 0f 1e fb          	endbr32 
80107074:	55                   	push   %ebp
80107075:	89 e5                	mov    %esp,%ebp
80107077:	57                   	push   %edi
80107078:	56                   	push   %esi
80107079:	53                   	push   %ebx
8010707a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010707d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107080:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107083:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107086:	85 c0                	test   %eax,%eax
80107088:	0f 88 b2 00 00 00    	js     80107140 <allocuvm+0xd0>
  if(newsz < oldsz)
8010708e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107091:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107094:	0f 82 96 00 00 00    	jb     80107130 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010709a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801070a0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801070a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801070a9:	77 40                	ja     801070eb <allocuvm+0x7b>
801070ab:	e9 83 00 00 00       	jmp    80107133 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801070b0:	83 ec 04             	sub    $0x4,%esp
801070b3:	68 00 10 00 00       	push   $0x1000
801070b8:	6a 00                	push   $0x0
801070ba:	50                   	push   %eax
801070bb:	e8 80 d8 ff ff       	call   80104940 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070c0:	58                   	pop    %eax
801070c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070c7:	5a                   	pop    %edx
801070c8:	6a 06                	push   $0x6
801070ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070cf:	89 f2                	mov    %esi,%edx
801070d1:	50                   	push   %eax
801070d2:	89 f8                	mov    %edi,%eax
801070d4:	e8 77 fb ff ff       	call   80106c50 <mappages>
801070d9:	83 c4 10             	add    $0x10,%esp
801070dc:	85 c0                	test   %eax,%eax
801070de:	78 78                	js     80107158 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801070e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801070e9:	76 48                	jbe    80107133 <allocuvm+0xc3>
    mem = kalloc();
801070eb:	e8 20 b7 ff ff       	call   80102810 <kalloc>
801070f0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801070f2:	85 c0                	test   %eax,%eax
801070f4:	75 ba                	jne    801070b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070f6:	83 ec 0c             	sub    $0xc,%esp
801070f9:	68 09 7f 10 80       	push   $0x80107f09
801070fe:	e8 8d 95 ff ff       	call   80100690 <cprintf>
  if(newsz >= oldsz)
80107103:	8b 45 0c             	mov    0xc(%ebp),%eax
80107106:	83 c4 10             	add    $0x10,%esp
80107109:	39 45 10             	cmp    %eax,0x10(%ebp)
8010710c:	74 32                	je     80107140 <allocuvm+0xd0>
8010710e:	8b 55 10             	mov    0x10(%ebp),%edx
80107111:	89 c1                	mov    %eax,%ecx
80107113:	89 f8                	mov    %edi,%eax
80107115:	e8 86 fa ff ff       	call   80106ba0 <deallocuvm.part.0>
      return 0;
8010711a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107127:	5b                   	pop    %ebx
80107128:	5e                   	pop    %esi
80107129:	5f                   	pop    %edi
8010712a:	5d                   	pop    %ebp
8010712b:	c3                   	ret    
8010712c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107130:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107139:	5b                   	pop    %ebx
8010713a:	5e                   	pop    %esi
8010713b:	5f                   	pop    %edi
8010713c:	5d                   	pop    %ebp
8010713d:	c3                   	ret    
8010713e:	66 90                	xchg   %ax,%ax
    return 0;
80107140:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010714a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010714d:	5b                   	pop    %ebx
8010714e:	5e                   	pop    %esi
8010714f:	5f                   	pop    %edi
80107150:	5d                   	pop    %ebp
80107151:	c3                   	ret    
80107152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107158:	83 ec 0c             	sub    $0xc,%esp
8010715b:	68 21 7f 10 80       	push   $0x80107f21
80107160:	e8 2b 95 ff ff       	call   80100690 <cprintf>
  if(newsz >= oldsz)
80107165:	8b 45 0c             	mov    0xc(%ebp),%eax
80107168:	83 c4 10             	add    $0x10,%esp
8010716b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010716e:	74 0c                	je     8010717c <allocuvm+0x10c>
80107170:	8b 55 10             	mov    0x10(%ebp),%edx
80107173:	89 c1                	mov    %eax,%ecx
80107175:	89 f8                	mov    %edi,%eax
80107177:	e8 24 fa ff ff       	call   80106ba0 <deallocuvm.part.0>
      kfree(mem);
8010717c:	83 ec 0c             	sub    $0xc,%esp
8010717f:	53                   	push   %ebx
80107180:	e8 cb b4 ff ff       	call   80102650 <kfree>
      return 0;
80107185:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010718c:	83 c4 10             	add    $0x10,%esp
}
8010718f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107192:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
8010719a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071a0 <deallocuvm>:
{
801071a0:	f3 0f 1e fb          	endbr32 
801071a4:	55                   	push   %ebp
801071a5:	89 e5                	mov    %esp,%ebp
801071a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801071aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801071b0:	39 d1                	cmp    %edx,%ecx
801071b2:	73 0c                	jae    801071c0 <deallocuvm+0x20>
}
801071b4:	5d                   	pop    %ebp
801071b5:	e9 e6 f9 ff ff       	jmp    80106ba0 <deallocuvm.part.0>
801071ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071c0:	89 d0                	mov    %edx,%eax
801071c2:	5d                   	pop    %ebp
801071c3:	c3                   	ret    
801071c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071cf:	90                   	nop

801071d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071d0:	f3 0f 1e fb          	endbr32 
801071d4:	55                   	push   %ebp
801071d5:	89 e5                	mov    %esp,%ebp
801071d7:	57                   	push   %edi
801071d8:	56                   	push   %esi
801071d9:	53                   	push   %ebx
801071da:	83 ec 0c             	sub    $0xc,%esp
801071dd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071e0:	85 f6                	test   %esi,%esi
801071e2:	74 55                	je     80107239 <freevm+0x69>
  if(newsz >= oldsz)
801071e4:	31 c9                	xor    %ecx,%ecx
801071e6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071eb:	89 f0                	mov    %esi,%eax
801071ed:	89 f3                	mov    %esi,%ebx
801071ef:	e8 ac f9 ff ff       	call   80106ba0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071f4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071fa:	eb 0b                	jmp    80107207 <freevm+0x37>
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107200:	83 c3 04             	add    $0x4,%ebx
80107203:	39 df                	cmp    %ebx,%edi
80107205:	74 23                	je     8010722a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107207:	8b 03                	mov    (%ebx),%eax
80107209:	a8 01                	test   $0x1,%al
8010720b:	74 f3                	je     80107200 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010720d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107212:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107215:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107218:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010721d:	50                   	push   %eax
8010721e:	e8 2d b4 ff ff       	call   80102650 <kfree>
80107223:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107226:	39 df                	cmp    %ebx,%edi
80107228:	75 dd                	jne    80107207 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010722a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010722d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107230:	5b                   	pop    %ebx
80107231:	5e                   	pop    %esi
80107232:	5f                   	pop    %edi
80107233:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107234:	e9 17 b4 ff ff       	jmp    80102650 <kfree>
    panic("freevm: no pgdir");
80107239:	83 ec 0c             	sub    $0xc,%esp
8010723c:	68 3d 7f 10 80       	push   $0x80107f3d
80107241:	e8 4a 91 ff ff       	call   80100390 <panic>
80107246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724d:	8d 76 00             	lea    0x0(%esi),%esi

80107250 <setupkvm>:
{
80107250:	f3 0f 1e fb          	endbr32 
80107254:	55                   	push   %ebp
80107255:	89 e5                	mov    %esp,%ebp
80107257:	56                   	push   %esi
80107258:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107259:	e8 b2 b5 ff ff       	call   80102810 <kalloc>
8010725e:	89 c6                	mov    %eax,%esi
80107260:	85 c0                	test   %eax,%eax
80107262:	74 42                	je     801072a6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107264:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107267:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
8010726c:	68 00 10 00 00       	push   $0x1000
80107271:	6a 00                	push   $0x0
80107273:	50                   	push   %eax
80107274:	e8 c7 d6 ff ff       	call   80104940 <memset>
80107279:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010727c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010727f:	83 ec 08             	sub    $0x8,%esp
80107282:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107285:	ff 73 0c             	pushl  0xc(%ebx)
80107288:	8b 13                	mov    (%ebx),%edx
8010728a:	50                   	push   %eax
8010728b:	29 c1                	sub    %eax,%ecx
8010728d:	89 f0                	mov    %esi,%eax
8010728f:	e8 bc f9 ff ff       	call   80106c50 <mappages>
80107294:	83 c4 10             	add    $0x10,%esp
80107297:	85 c0                	test   %eax,%eax
80107299:	78 15                	js     801072b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010729b:	83 c3 10             	add    $0x10,%ebx
8010729e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801072a4:	75 d6                	jne    8010727c <setupkvm+0x2c>
}
801072a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072a9:	89 f0                	mov    %esi,%eax
801072ab:	5b                   	pop    %ebx
801072ac:	5e                   	pop    %esi
801072ad:	5d                   	pop    %ebp
801072ae:	c3                   	ret    
801072af:	90                   	nop
      freevm(pgdir);
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	56                   	push   %esi
      return 0;
801072b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801072b6:	e8 15 ff ff ff       	call   801071d0 <freevm>
      return 0;
801072bb:	83 c4 10             	add    $0x10,%esp
}
801072be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072c1:	89 f0                	mov    %esi,%eax
801072c3:	5b                   	pop    %ebx
801072c4:	5e                   	pop    %esi
801072c5:	5d                   	pop    %ebp
801072c6:	c3                   	ret    
801072c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ce:	66 90                	xchg   %ax,%ax

801072d0 <kvmalloc>:
{
801072d0:	f3 0f 1e fb          	endbr32 
801072d4:	55                   	push   %ebp
801072d5:	89 e5                	mov    %esp,%ebp
801072d7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072da:	e8 71 ff ff ff       	call   80107250 <setupkvm>
801072df:	a3 e4 44 11 80       	mov    %eax,0x801144e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072e4:	05 00 00 00 80       	add    $0x80000000,%eax
801072e9:	0f 22 d8             	mov    %eax,%cr3
}
801072ec:	c9                   	leave  
801072ed:	c3                   	ret    
801072ee:	66 90                	xchg   %ax,%ax

801072f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072f0:	f3 0f 1e fb          	endbr32 
801072f4:	55                   	push   %ebp
801072f5:	89 e5                	mov    %esp,%ebp
801072f7:	83 ec 08             	sub    $0x8,%esp
801072fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072fd:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107300:	89 c1                	mov    %eax,%ecx
80107302:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107305:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107308:	f6 c2 01             	test   $0x1,%dl
8010730b:	75 13                	jne    80107320 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010730d:	83 ec 0c             	sub    $0xc,%esp
80107310:	68 4e 7f 10 80       	push   $0x80107f4e
80107315:	e8 76 90 ff ff       	call   80100390 <panic>
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107320:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107323:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107329:	25 fc 0f 00 00       	and    $0xffc,%eax
8010732e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107335:	85 c0                	test   %eax,%eax
80107337:	74 d4                	je     8010730d <clearpteu+0x1d>
  *pte &= ~PTE_U;
80107339:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010733c:	c9                   	leave  
8010733d:	c3                   	ret    
8010733e:	66 90                	xchg   %ax,%ax

80107340 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107340:	f3 0f 1e fb          	endbr32 
80107344:	55                   	push   %ebp
80107345:	89 e5                	mov    %esp,%ebp
80107347:	57                   	push   %edi
80107348:	56                   	push   %esi
80107349:	53                   	push   %ebx
8010734a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010734d:	e8 fe fe ff ff       	call   80107250 <setupkvm>
80107352:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107355:	85 c0                	test   %eax,%eax
80107357:	0f 84 b9 00 00 00    	je     80107416 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010735d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107360:	85 c9                	test   %ecx,%ecx
80107362:	0f 84 ae 00 00 00    	je     80107416 <copyuvm+0xd6>
80107368:	31 f6                	xor    %esi,%esi
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107373:	89 f0                	mov    %esi,%eax
80107375:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107378:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010737b:	a8 01                	test   $0x1,%al
8010737d:	75 11                	jne    80107390 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010737f:	83 ec 0c             	sub    $0xc,%esp
80107382:	68 58 7f 10 80       	push   $0x80107f58
80107387:	e8 04 90 ff ff       	call   80100390 <panic>
8010738c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107390:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107397:	c1 ea 0a             	shr    $0xa,%edx
8010739a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801073a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801073a7:	85 c0                	test   %eax,%eax
801073a9:	74 d4                	je     8010737f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801073ab:	8b 00                	mov    (%eax),%eax
801073ad:	a8 01                	test   $0x1,%al
801073af:	0f 84 9f 00 00 00    	je     80107454 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801073b5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801073b7:	25 ff 0f 00 00       	and    $0xfff,%eax
801073bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801073bf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801073c5:	e8 46 b4 ff ff       	call   80102810 <kalloc>
801073ca:	89 c3                	mov    %eax,%ebx
801073cc:	85 c0                	test   %eax,%eax
801073ce:	74 64                	je     80107434 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801073d0:	83 ec 04             	sub    $0x4,%esp
801073d3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801073d9:	68 00 10 00 00       	push   $0x1000
801073de:	57                   	push   %edi
801073df:	50                   	push   %eax
801073e0:	e8 fb d5 ff ff       	call   801049e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801073e5:	58                   	pop    %eax
801073e6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073ec:	5a                   	pop    %edx
801073ed:	ff 75 e4             	pushl  -0x1c(%ebp)
801073f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073f5:	89 f2                	mov    %esi,%edx
801073f7:	50                   	push   %eax
801073f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073fb:	e8 50 f8 ff ff       	call   80106c50 <mappages>
80107400:	83 c4 10             	add    $0x10,%esp
80107403:	85 c0                	test   %eax,%eax
80107405:	78 21                	js     80107428 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107407:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010740d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107410:	0f 87 5a ff ff ff    	ja     80107370 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107416:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107419:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010741c:	5b                   	pop    %ebx
8010741d:	5e                   	pop    %esi
8010741e:	5f                   	pop    %edi
8010741f:	5d                   	pop    %ebp
80107420:	c3                   	ret    
80107421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107428:	83 ec 0c             	sub    $0xc,%esp
8010742b:	53                   	push   %ebx
8010742c:	e8 1f b2 ff ff       	call   80102650 <kfree>
      goto bad;
80107431:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107434:	83 ec 0c             	sub    $0xc,%esp
80107437:	ff 75 e0             	pushl  -0x20(%ebp)
8010743a:	e8 91 fd ff ff       	call   801071d0 <freevm>
  return 0;
8010743f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107446:	83 c4 10             	add    $0x10,%esp
}
80107449:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010744c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010744f:	5b                   	pop    %ebx
80107450:	5e                   	pop    %esi
80107451:	5f                   	pop    %edi
80107452:	5d                   	pop    %ebp
80107453:	c3                   	ret    
      panic("copyuvm: page not present");
80107454:	83 ec 0c             	sub    $0xc,%esp
80107457:	68 72 7f 10 80       	push   $0x80107f72
8010745c:	e8 2f 8f ff ff       	call   80100390 <panic>
80107461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop

80107470 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107470:	f3 0f 1e fb          	endbr32 
80107474:	55                   	push   %ebp
80107475:	89 e5                	mov    %esp,%ebp
80107477:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
8010747a:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010747d:	89 c1                	mov    %eax,%ecx
8010747f:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107482:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107485:	f6 c2 01             	test   $0x1,%dl
80107488:	0f 84 fc 00 00 00    	je     8010758a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010748e:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107491:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107497:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107498:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
8010749d:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801074a4:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801074ab:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074ae:	05 00 00 00 80       	add    $0x80000000,%eax
801074b3:	83 fa 05             	cmp    $0x5,%edx
801074b6:	ba 00 00 00 00       	mov    $0x0,%edx
801074bb:	0f 45 c2             	cmovne %edx,%eax
}
801074be:	c3                   	ret    
801074bf:	90                   	nop

801074c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801074c0:	f3 0f 1e fb          	endbr32 
801074c4:	55                   	push   %ebp
801074c5:	89 e5                	mov    %esp,%ebp
801074c7:	57                   	push   %edi
801074c8:	56                   	push   %esi
801074c9:	53                   	push   %ebx
801074ca:	83 ec 0c             	sub    $0xc,%esp
801074cd:	8b 75 14             	mov    0x14(%ebp),%esi
801074d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801074d3:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801074d6:	85 f6                	test   %esi,%esi
801074d8:	75 4d                	jne    80107527 <copyout+0x67>
801074da:	e9 a1 00 00 00       	jmp    80107580 <copyout+0xc0>
801074df:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801074e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801074e6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801074ec:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801074f2:	74 75                	je     80107569 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801074f4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074f6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801074f9:	29 c3                	sub    %eax,%ebx
801074fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107501:	39 f3                	cmp    %esi,%ebx
80107503:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107506:	29 f8                	sub    %edi,%eax
80107508:	83 ec 04             	sub    $0x4,%esp
8010750b:	01 c8                	add    %ecx,%eax
8010750d:	53                   	push   %ebx
8010750e:	52                   	push   %edx
8010750f:	50                   	push   %eax
80107510:	e8 cb d4 ff ff       	call   801049e0 <memmove>
    len -= n;
    buf += n;
80107515:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107518:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010751e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107521:	01 da                	add    %ebx,%edx
  while(len > 0){
80107523:	29 de                	sub    %ebx,%esi
80107525:	74 59                	je     80107580 <copyout+0xc0>
  if(*pde & PTE_P){
80107527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010752a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010752c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010752e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107531:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107537:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010753a:	f6 c1 01             	test   $0x1,%cl
8010753d:	0f 84 4e 00 00 00    	je     80107591 <copyout.cold>
  return &pgtab[PTX(va)];
80107543:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107545:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010754b:	c1 eb 0c             	shr    $0xc,%ebx
8010754e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107554:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010755b:	89 d9                	mov    %ebx,%ecx
8010755d:	83 e1 05             	and    $0x5,%ecx
80107560:	83 f9 05             	cmp    $0x5,%ecx
80107563:	0f 84 77 ff ff ff    	je     801074e0 <copyout+0x20>
  }
  return 0;
}
80107569:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010756c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107571:	5b                   	pop    %ebx
80107572:	5e                   	pop    %esi
80107573:	5f                   	pop    %edi
80107574:	5d                   	pop    %ebp
80107575:	c3                   	ret    
80107576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010757d:	8d 76 00             	lea    0x0(%esi),%esi
80107580:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107583:	31 c0                	xor    %eax,%eax
}
80107585:	5b                   	pop    %ebx
80107586:	5e                   	pop    %esi
80107587:	5f                   	pop    %edi
80107588:	5d                   	pop    %ebp
80107589:	c3                   	ret    

8010758a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010758a:	a1 00 00 00 00       	mov    0x0,%eax
8010758f:	0f 0b                	ud2    

80107591 <copyout.cold>:
80107591:	a1 00 00 00 00       	mov    0x0,%eax
80107596:	0f 0b                	ud2    
