
test.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <mul12>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	89 7d fc             	mov    %edi,-0x4(%rbp)
   7:	8b 55 fc             	mov    -0x4(%rbp),%edx
   a:	89 d0                	mov    %edx,%eax
   c:	01 c0                	add    %eax,%eax
   e:	01 d0                	add    %edx,%eax
  10:	c1 e0 02             	shl    $0x2,%eax
  13:	5d                   	pop    %rbp
  14:	c3                   	retq   

0000000000000015 <udiv8>:
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1f:	c1 e8 03             	shr    $0x3,%eax
  22:	5d                   	pop    %rbp
  23:	c3                   	retq   

0000000000000024 <idiv8>:
  24:	55                   	push   %rbp
  25:	48 89 e5             	mov    %rsp,%rbp
  28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  2e:	8d 50 07             	lea    0x7(%rax),%edx
  31:	85 c0                	test   %eax,%eax
  33:	0f 48 c2             	cmovs  %edx,%eax
  36:	c1 f8 03             	sar    $0x3,%eax
  39:	5d                   	pop    %rbp
  3a:	c3                   	retq   

000000000000003b <main>:
  3b:	55                   	push   %rbp
  3c:	48 89 e5             	mov    %rsp,%rbp
  3f:	b8 00 00 00 00       	mov    $0x0,%eax
  44:	5d                   	pop    %rbp
  45:	c3                   	retq   
