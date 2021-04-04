
_testcfs1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
		ps();
		wait();
	}
}
int main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 0c             	sub    $0xc,%esp
		printf(1, "=== TEST START ===\n");
  15:	68 e7 08 00 00       	push   $0x8e7
  1a:	6a 01                	push   $0x1
  1c:	e8 2f 05 00 00       	call   550 <printf>
		testcfs();
  21:	e8 1a 00 00 00       	call   40 <testcfs>
		printf(1, "=== TEST   END ===\n");
  26:	58                   	pop    %eax
  27:	5a                   	pop    %edx
  28:	68 fb 08 00 00       	push   $0x8fb
  2d:	6a 01                	push   $0x1
  2f:	e8 1c 05 00 00       	call   550 <printf>
		exit();
  34:	e8 8a 03 00 00       	call   3c3 <exit>
  39:	66 90                	xchg   %ax,%ax
  3b:	66 90                	xchg   %ax,%ax
  3d:	66 90                	xchg   %ax,%ax
  3f:	90                   	nop

00000040 <testcfs>:
{
  40:	f3 0f 1e fb          	endbr32 
  44:	55                   	push   %ebp
  45:	89 e5                	mov    %esp,%ebp
  47:	56                   	push   %esi
  48:	53                   	push   %ebx
  49:	83 ec 10             	sub    $0x10,%esp
	int parent = getpid();
  4c:	e8 f2 03 00 00       	call   443 <getpid>
	volatile double x = 0, z;
  51:	d9 ee                	fldz   
	int parent = getpid();
  53:	89 c6                	mov    %eax,%esi
	volatile double x = 0, z;
  55:	dd 5d e8             	fstpl  -0x18(%ebp)
	if((child = fork()) == 0) { // child
  58:	e8 5e 03 00 00       	call   3bb <fork>
  5d:	85 c0                	test   %eax,%eax
  5f:	0f 84 85 00 00 00    	je     ea <testcfs+0xaa>
		setnice(child, 0);	  //parent
  65:	83 ec 08             	sub    $0x8,%esp
  68:	89 c3                	mov    %eax,%ebx
  6a:	6a 00                	push   $0x0
  6c:	50                   	push   %eax
  6d:	e8 01 04 00 00       	call   473 <setnice>
		printf(3, "Parent %d creating child %d\n",getpid(), child);
  72:	e8 cc 03 00 00       	call   443 <getpid>
  77:	53                   	push   %ebx
  78:	50                   	push   %eax
  79:	68 ca 08 00 00       	push   $0x8ca
  7e:	6a 03                	push   $0x3
  80:	e8 cb 04 00 00       	call   550 <printf>
				x =  x + 3.14 * 89.64;
  85:	dd 05 18 09 00 00    	fldl   0x918
		printf(3, "Parent %d creating child %d\n",getpid(), child);
  8b:	83 c4 20             	add    $0x20,%esp
  8e:	b8 2c 01 00 00       	mov    $0x12c,%eax
  93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  97:	90                   	nop
			for ( z = 0; z < 3000.0; z += 0.1 )
  98:	d9 ee                	fldz   
  9a:	dd 5d f0             	fstpl  -0x10(%ebp)
  9d:	dd 45 f0             	fldl   -0x10(%ebp)
  a0:	d9 05 10 09 00 00    	flds   0x910
  a6:	df f1                	fcomip %st(1),%st
  a8:	dd d8                	fstp   %st(0)
  aa:	76 27                	jbe    d3 <testcfs+0x93>
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				x =  x + 3.14 * 89.64;
  b0:	dd 45 e8             	fldl   -0x18(%ebp)
  b3:	d8 c1                	fadd   %st(1),%st
  b5:	dd 5d e8             	fstpl  -0x18(%ebp)
			for ( z = 0; z < 3000.0; z += 0.1 )
  b8:	dd 45 f0             	fldl   -0x10(%ebp)
  bb:	dc 05 20 09 00 00    	faddl  0x920
  c1:	dd 5d f0             	fstpl  -0x10(%ebp)
  c4:	dd 45 f0             	fldl   -0x10(%ebp)
  c7:	d9 05 10 09 00 00    	flds   0x910
  cd:	df f1                	fcomip %st(1),%st
  cf:	dd d8                	fstp   %st(0)
  d1:	77 dd                	ja     b0 <testcfs+0x70>
		for(i = 0; i < 300; i++){
  d3:	83 e8 01             	sub    $0x1,%eax
  d6:	75 c0                	jne    98 <testcfs+0x58>
  d8:	dd d8                	fstp   %st(0)
		ps();
  da:	e8 ac 03 00 00       	call   48b <ps>
}
  df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  e2:	5b                   	pop    %ebx
  e3:	5e                   	pop    %esi
  e4:	5d                   	pop    %ebp
		wait();
  e5:	e9 e1 02 00 00       	jmp    3cb <wait>
		setnice(parent, 5);	
  ea:	50                   	push   %eax
  eb:	50                   	push   %eax
  ec:	6a 05                	push   $0x5
  ee:	56                   	push   %esi
  ef:	e8 7f 03 00 00       	call   473 <setnice>
		printf(2, "Child %d created\n",getpid());
  f4:	e8 4a 03 00 00       	call   443 <getpid>
  f9:	83 c4 0c             	add    $0xc,%esp
  fc:	50                   	push   %eax
  fd:	68 b8 08 00 00       	push   $0x8b8
 102:	6a 02                	push   $0x2
 104:	e8 47 04 00 00       	call   550 <printf>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	b8 2c 01 00 00       	mov    $0x12c,%eax
			for ( z = 0; z < 3000.0; z += 0.1 )
 111:	d9 ee                	fldz   
 113:	dd 5d f0             	fstpl  -0x10(%ebp)
 116:	dd 45 f0             	fldl   -0x10(%ebp)
 119:	d9 05 10 09 00 00    	flds   0x910
 11f:	df f1                	fcomip %st(1),%st
 121:	dd d8                	fstp   %st(0)
 123:	76 27                	jbe    14c <testcfs+0x10c>
				x =  x + 3.14 * 89.64;
 125:	dd 45 e8             	fldl   -0x18(%ebp)
 128:	dc 05 18 09 00 00    	faddl  0x918
 12e:	dd 5d e8             	fstpl  -0x18(%ebp)
			for ( z = 0; z < 3000.0; z += 0.1 )
 131:	dd 45 f0             	fldl   -0x10(%ebp)
 134:	dc 05 20 09 00 00    	faddl  0x920
 13a:	dd 5d f0             	fstpl  -0x10(%ebp)
 13d:	dd 45 f0             	fldl   -0x10(%ebp)
 140:	d9 05 10 09 00 00    	flds   0x910
 146:	df f1                	fcomip %st(1),%st
 148:	dd d8                	fstp   %st(0)
 14a:	77 d9                	ja     125 <testcfs+0xe5>
		for(i = 0; i < 300; i++){
 14c:	83 e8 01             	sub    $0x1,%eax
 14f:	75 c0                	jne    111 <testcfs+0xd1>
		ps();
 151:	e8 35 03 00 00       	call   48b <ps>
		exit();
 156:	e8 68 02 00 00       	call   3c3 <exit>
 15b:	66 90                	xchg   %ax,%ax
 15d:	66 90                	xchg   %ax,%ax
 15f:	90                   	nop

00000160 <strcpy>:
 160:	f3 0f 1e fb          	endbr32 
 164:	55                   	push   %ebp
 165:	31 c0                	xor    %eax,%eax
 167:	89 e5                	mov    %esp,%ebp
 169:	53                   	push   %ebx
 16a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 16d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 170:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 174:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 177:	83 c0 01             	add    $0x1,%eax
 17a:	84 d2                	test   %dl,%dl
 17c:	75 f2                	jne    170 <strcpy+0x10>
 17e:	89 c8                	mov    %ecx,%eax
 180:	5b                   	pop    %ebx
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
 183:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000190 <strcmp>:
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	53                   	push   %ebx
 198:	8b 4d 08             	mov    0x8(%ebp),%ecx
 19b:	8b 55 0c             	mov    0xc(%ebp),%edx
 19e:	0f b6 01             	movzbl (%ecx),%eax
 1a1:	0f b6 1a             	movzbl (%edx),%ebx
 1a4:	84 c0                	test   %al,%al
 1a6:	75 19                	jne    1c1 <strcmp+0x31>
 1a8:	eb 26                	jmp    1d0 <strcmp+0x40>
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
 1b4:	83 c1 01             	add    $0x1,%ecx
 1b7:	83 c2 01             	add    $0x1,%edx
 1ba:	0f b6 1a             	movzbl (%edx),%ebx
 1bd:	84 c0                	test   %al,%al
 1bf:	74 0f                	je     1d0 <strcmp+0x40>
 1c1:	38 d8                	cmp    %bl,%al
 1c3:	74 eb                	je     1b0 <strcmp+0x20>
 1c5:	29 d8                	sub    %ebx,%eax
 1c7:	5b                   	pop    %ebx
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1d0:	31 c0                	xor    %eax,%eax
 1d2:	29 d8                	sub    %ebx,%eax
 1d4:	5b                   	pop    %ebx
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1de:	66 90                	xchg   %ax,%ax

000001e0 <strlen>:
 1e0:	f3 0f 1e fb          	endbr32 
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	8b 55 08             	mov    0x8(%ebp),%edx
 1ea:	80 3a 00             	cmpb   $0x0,(%edx)
 1ed:	74 21                	je     210 <strlen+0x30>
 1ef:	31 c0                	xor    %eax,%eax
 1f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1f8:	83 c0 01             	add    $0x1,%eax
 1fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1ff:	89 c1                	mov    %eax,%ecx
 201:	75 f5                	jne    1f8 <strlen+0x18>
 203:	89 c8                	mov    %ecx,%eax
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax
 210:	31 c9                	xor    %ecx,%ecx
 212:	5d                   	pop    %ebp
 213:	89 c8                	mov    %ecx,%eax
 215:	c3                   	ret    
 216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21d:	8d 76 00             	lea    0x0(%esi),%esi

00000220 <memset>:
 220:	f3 0f 1e fb          	endbr32 
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	57                   	push   %edi
 228:	8b 55 08             	mov    0x8(%ebp),%edx
 22b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	89 d7                	mov    %edx,%edi
 233:	fc                   	cld    
 234:	f3 aa                	rep stos %al,%es:(%edi)
 236:	89 d0                	mov    %edx,%eax
 238:	5f                   	pop    %edi
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    
 23b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop

00000240 <strchr>:
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 24e:	0f b6 10             	movzbl (%eax),%edx
 251:	84 d2                	test   %dl,%dl
 253:	75 16                	jne    26b <strchr+0x2b>
 255:	eb 21                	jmp    278 <strchr+0x38>
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax
 260:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 264:	83 c0 01             	add    $0x1,%eax
 267:	84 d2                	test   %dl,%dl
 269:	74 0d                	je     278 <strchr+0x38>
 26b:	38 d1                	cmp    %dl,%cl
 26d:	75 f1                	jne    260 <strchr+0x20>
 26f:	5d                   	pop    %ebp
 270:	c3                   	ret    
 271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 278:	31 c0                	xor    %eax,%eax
 27a:	5d                   	pop    %ebp
 27b:	c3                   	ret    
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <gets>:
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	57                   	push   %edi
 288:	56                   	push   %esi
 289:	31 f6                	xor    %esi,%esi
 28b:	53                   	push   %ebx
 28c:	89 f3                	mov    %esi,%ebx
 28e:	83 ec 1c             	sub    $0x1c,%esp
 291:	8b 7d 08             	mov    0x8(%ebp),%edi
 294:	eb 33                	jmp    2c9 <gets+0x49>
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi
 2a0:	83 ec 04             	sub    $0x4,%esp
 2a3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2a6:	6a 01                	push   $0x1
 2a8:	50                   	push   %eax
 2a9:	6a 00                	push   $0x0
 2ab:	e8 2b 01 00 00       	call   3db <read>
 2b0:	83 c4 10             	add    $0x10,%esp
 2b3:	85 c0                	test   %eax,%eax
 2b5:	7e 1c                	jle    2d3 <gets+0x53>
 2b7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2bb:	83 c7 01             	add    $0x1,%edi
 2be:	88 47 ff             	mov    %al,-0x1(%edi)
 2c1:	3c 0a                	cmp    $0xa,%al
 2c3:	74 23                	je     2e8 <gets+0x68>
 2c5:	3c 0d                	cmp    $0xd,%al
 2c7:	74 1f                	je     2e8 <gets+0x68>
 2c9:	83 c3 01             	add    $0x1,%ebx
 2cc:	89 fe                	mov    %edi,%esi
 2ce:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2d1:	7c cd                	jl     2a0 <gets+0x20>
 2d3:	89 f3                	mov    %esi,%ebx
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	c6 03 00             	movb   $0x0,(%ebx)
 2db:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2de:	5b                   	pop    %ebx
 2df:	5e                   	pop    %esi
 2e0:	5f                   	pop    %edi
 2e1:	5d                   	pop    %ebp
 2e2:	c3                   	ret    
 2e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e7:	90                   	nop
 2e8:	8b 75 08             	mov    0x8(%ebp),%esi
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	01 de                	add    %ebx,%esi
 2f0:	89 f3                	mov    %esi,%ebx
 2f2:	c6 03 00             	movb   $0x0,(%ebx)
 2f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2f8:	5b                   	pop    %ebx
 2f9:	5e                   	pop    %esi
 2fa:	5f                   	pop    %edi
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    
 2fd:	8d 76 00             	lea    0x0(%esi),%esi

00000300 <stat>:
 300:	f3 0f 1e fb          	endbr32 
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	56                   	push   %esi
 308:	53                   	push   %ebx
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	6a 00                	push   $0x0
 30e:	ff 75 08             	pushl  0x8(%ebp)
 311:	e8 ed 00 00 00       	call   403 <open>
 316:	83 c4 10             	add    $0x10,%esp
 319:	85 c0                	test   %eax,%eax
 31b:	78 2b                	js     348 <stat+0x48>
 31d:	83 ec 08             	sub    $0x8,%esp
 320:	ff 75 0c             	pushl  0xc(%ebp)
 323:	89 c3                	mov    %eax,%ebx
 325:	50                   	push   %eax
 326:	e8 f0 00 00 00       	call   41b <fstat>
 32b:	89 1c 24             	mov    %ebx,(%esp)
 32e:	89 c6                	mov    %eax,%esi
 330:	e8 b6 00 00 00       	call   3eb <close>
 335:	83 c4 10             	add    $0x10,%esp
 338:	8d 65 f8             	lea    -0x8(%ebp),%esp
 33b:	89 f0                	mov    %esi,%eax
 33d:	5b                   	pop    %ebx
 33e:	5e                   	pop    %esi
 33f:	5d                   	pop    %ebp
 340:	c3                   	ret    
 341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 348:	be ff ff ff ff       	mov    $0xffffffff,%esi
 34d:	eb e9                	jmp    338 <stat+0x38>
 34f:	90                   	nop

00000350 <atoi>:
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	53                   	push   %ebx
 358:	8b 55 08             	mov    0x8(%ebp),%edx
 35b:	0f be 02             	movsbl (%edx),%eax
 35e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 361:	80 f9 09             	cmp    $0x9,%cl
 364:	b9 00 00 00 00       	mov    $0x0,%ecx
 369:	77 1a                	ja     385 <atoi+0x35>
 36b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 36f:	90                   	nop
 370:	83 c2 01             	add    $0x1,%edx
 373:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 376:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 37a:	0f be 02             	movsbl (%edx),%eax
 37d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 380:	80 fb 09             	cmp    $0x9,%bl
 383:	76 eb                	jbe    370 <atoi+0x20>
 385:	89 c8                	mov    %ecx,%eax
 387:	5b                   	pop    %ebx
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <memmove>:
 390:	f3 0f 1e fb          	endbr32 
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	57                   	push   %edi
 398:	8b 45 10             	mov    0x10(%ebp),%eax
 39b:	8b 55 08             	mov    0x8(%ebp),%edx
 39e:	56                   	push   %esi
 39f:	8b 75 0c             	mov    0xc(%ebp),%esi
 3a2:	85 c0                	test   %eax,%eax
 3a4:	7e 0f                	jle    3b5 <memmove+0x25>
 3a6:	01 d0                	add    %edx,%eax
 3a8:	89 d7                	mov    %edx,%edi
 3aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 3b1:	39 f8                	cmp    %edi,%eax
 3b3:	75 fb                	jne    3b0 <memmove+0x20>
 3b5:	5e                   	pop    %esi
 3b6:	89 d0                	mov    %edx,%eax
 3b8:	5f                   	pop    %edi
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret    

000003bb <fork>:
 3bb:	b8 01 00 00 00       	mov    $0x1,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <exit>:
 3c3:	b8 02 00 00 00       	mov    $0x2,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <wait>:
 3cb:	b8 03 00 00 00       	mov    $0x3,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <pipe>:
 3d3:	b8 04 00 00 00       	mov    $0x4,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <read>:
 3db:	b8 05 00 00 00       	mov    $0x5,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <write>:
 3e3:	b8 10 00 00 00       	mov    $0x10,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <close>:
 3eb:	b8 15 00 00 00       	mov    $0x15,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <kill>:
 3f3:	b8 06 00 00 00       	mov    $0x6,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <exec>:
 3fb:	b8 07 00 00 00       	mov    $0x7,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <open>:
 403:	b8 0f 00 00 00       	mov    $0xf,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mknod>:
 40b:	b8 11 00 00 00       	mov    $0x11,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <unlink>:
 413:	b8 12 00 00 00       	mov    $0x12,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <fstat>:
 41b:	b8 08 00 00 00       	mov    $0x8,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <link>:
 423:	b8 13 00 00 00       	mov    $0x13,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <mkdir>:
 42b:	b8 14 00 00 00       	mov    $0x14,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <chdir>:
 433:	b8 09 00 00 00       	mov    $0x9,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <dup>:
 43b:	b8 0a 00 00 00       	mov    $0xa,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <getpid>:
 443:	b8 0b 00 00 00       	mov    $0xb,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <sbrk>:
 44b:	b8 0c 00 00 00       	mov    $0xc,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <sleep>:
 453:	b8 0d 00 00 00       	mov    $0xd,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <uptime>:
 45b:	b8 0e 00 00 00       	mov    $0xe,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <swapread>:
 463:	b8 16 00 00 00       	mov    $0x16,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <swapwrite>:
 46b:	b8 17 00 00 00       	mov    $0x17,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <setnice>:
 473:	b8 18 00 00 00       	mov    $0x18,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <getnice>:
 47b:	b8 19 00 00 00       	mov    $0x19,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <yield>:
 483:	b8 1a 00 00 00       	mov    $0x1a,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <ps>:
 48b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    
 493:	66 90                	xchg   %ax,%ax
 495:	66 90                	xchg   %ax,%ax
 497:	66 90                	xchg   %ax,%ax
 499:	66 90                	xchg   %ax,%ax
 49b:	66 90                	xchg   %ax,%ax
 49d:	66 90                	xchg   %ax,%ax
 49f:	90                   	nop

000004a0 <printint>:
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 3c             	sub    $0x3c,%esp
 4a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 4ac:	89 d1                	mov    %edx,%ecx
 4ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
 4b1:	85 d2                	test   %edx,%edx
 4b3:	0f 89 7f 00 00 00    	jns    538 <printint+0x98>
 4b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4bd:	74 79                	je     538 <printint+0x98>
 4bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 4c6:	f7 d9                	neg    %ecx
 4c8:	31 db                	xor    %ebx,%ebx
 4ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
 4d0:	89 c8                	mov    %ecx,%eax
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	89 cf                	mov    %ecx,%edi
 4d6:	f7 75 c4             	divl   -0x3c(%ebp)
 4d9:	0f b6 92 30 09 00 00 	movzbl 0x930(%edx),%edx
 4e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4e3:	89 d8                	mov    %ebx,%eax
 4e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
 4e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 4eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 4ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4f1:	76 dd                	jbe    4d0 <printint+0x30>
 4f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4f6:	85 c9                	test   %ecx,%ecx
 4f8:	74 0c                	je     506 <printint+0x66>
 4fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4ff:	89 d8                	mov    %ebx,%eax
 501:	ba 2d 00 00 00       	mov    $0x2d,%edx
 506:	8b 7d b8             	mov    -0x48(%ebp),%edi
 509:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 50d:	eb 07                	jmp    516 <printint+0x76>
 50f:	90                   	nop
 510:	0f b6 13             	movzbl (%ebx),%edx
 513:	83 eb 01             	sub    $0x1,%ebx
 516:	83 ec 04             	sub    $0x4,%esp
 519:	88 55 d7             	mov    %dl,-0x29(%ebp)
 51c:	6a 01                	push   $0x1
 51e:	56                   	push   %esi
 51f:	57                   	push   %edi
 520:	e8 be fe ff ff       	call   3e3 <write>
 525:	83 c4 10             	add    $0x10,%esp
 528:	39 de                	cmp    %ebx,%esi
 52a:	75 e4                	jne    510 <printint+0x70>
 52c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52f:	5b                   	pop    %ebx
 530:	5e                   	pop    %esi
 531:	5f                   	pop    %edi
 532:	5d                   	pop    %ebp
 533:	c3                   	ret    
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 538:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 53f:	eb 87                	jmp    4c8 <printint+0x28>
 541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54f:	90                   	nop

00000550 <printf>:
 550:	f3 0f 1e fb          	endbr32 
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	57                   	push   %edi
 558:	56                   	push   %esi
 559:	53                   	push   %ebx
 55a:	83 ec 2c             	sub    $0x2c,%esp
 55d:	8b 75 0c             	mov    0xc(%ebp),%esi
 560:	0f b6 1e             	movzbl (%esi),%ebx
 563:	84 db                	test   %bl,%bl
 565:	0f 84 b4 00 00 00    	je     61f <printf+0xcf>
 56b:	8d 45 10             	lea    0x10(%ebp),%eax
 56e:	83 c6 01             	add    $0x1,%esi
 571:	8d 7d e7             	lea    -0x19(%ebp),%edi
 574:	31 d2                	xor    %edx,%edx
 576:	89 45 d0             	mov    %eax,-0x30(%ebp)
 579:	eb 33                	jmp    5ae <printf+0x5e>
 57b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop
 580:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 583:	ba 25 00 00 00       	mov    $0x25,%edx
 588:	83 f8 25             	cmp    $0x25,%eax
 58b:	74 17                	je     5a4 <printf+0x54>
 58d:	83 ec 04             	sub    $0x4,%esp
 590:	88 5d e7             	mov    %bl,-0x19(%ebp)
 593:	6a 01                	push   $0x1
 595:	57                   	push   %edi
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 45 fe ff ff       	call   3e3 <write>
 59e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5a1:	83 c4 10             	add    $0x10,%esp
 5a4:	0f b6 1e             	movzbl (%esi),%ebx
 5a7:	83 c6 01             	add    $0x1,%esi
 5aa:	84 db                	test   %bl,%bl
 5ac:	74 71                	je     61f <printf+0xcf>
 5ae:	0f be cb             	movsbl %bl,%ecx
 5b1:	0f b6 c3             	movzbl %bl,%eax
 5b4:	85 d2                	test   %edx,%edx
 5b6:	74 c8                	je     580 <printf+0x30>
 5b8:	83 fa 25             	cmp    $0x25,%edx
 5bb:	75 e7                	jne    5a4 <printf+0x54>
 5bd:	83 f8 64             	cmp    $0x64,%eax
 5c0:	0f 84 9a 00 00 00    	je     660 <printf+0x110>
 5c6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5cc:	83 f9 70             	cmp    $0x70,%ecx
 5cf:	74 5f                	je     630 <printf+0xe0>
 5d1:	83 f8 73             	cmp    $0x73,%eax
 5d4:	0f 84 d6 00 00 00    	je     6b0 <printf+0x160>
 5da:	83 f8 63             	cmp    $0x63,%eax
 5dd:	0f 84 8d 00 00 00    	je     670 <printf+0x120>
 5e3:	83 f8 25             	cmp    $0x25,%eax
 5e6:	0f 84 b4 00 00 00    	je     6a0 <printf+0x150>
 5ec:	83 ec 04             	sub    $0x4,%esp
 5ef:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5f3:	6a 01                	push   $0x1
 5f5:	57                   	push   %edi
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 e5 fd ff ff       	call   3e3 <write>
 5fe:	88 5d e7             	mov    %bl,-0x19(%ebp)
 601:	83 c4 0c             	add    $0xc,%esp
 604:	6a 01                	push   $0x1
 606:	83 c6 01             	add    $0x1,%esi
 609:	57                   	push   %edi
 60a:	ff 75 08             	pushl  0x8(%ebp)
 60d:	e8 d1 fd ff ff       	call   3e3 <write>
 612:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 616:	83 c4 10             	add    $0x10,%esp
 619:	31 d2                	xor    %edx,%edx
 61b:	84 db                	test   %bl,%bl
 61d:	75 8f                	jne    5ae <printf+0x5e>
 61f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 622:	5b                   	pop    %ebx
 623:	5e                   	pop    %esi
 624:	5f                   	pop    %edi
 625:	5d                   	pop    %ebp
 626:	c3                   	ret    
 627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62e:	66 90                	xchg   %ax,%ax
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	b9 10 00 00 00       	mov    $0x10,%ecx
 638:	6a 00                	push   $0x0
 63a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	8b 13                	mov    (%ebx),%edx
 642:	e8 59 fe ff ff       	call   4a0 <printint>
 647:	89 d8                	mov    %ebx,%eax
 649:	83 c4 10             	add    $0x10,%esp
 64c:	31 d2                	xor    %edx,%edx
 64e:	83 c0 04             	add    $0x4,%eax
 651:	89 45 d0             	mov    %eax,-0x30(%ebp)
 654:	e9 4b ff ff ff       	jmp    5a4 <printf+0x54>
 659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 660:	83 ec 0c             	sub    $0xc,%esp
 663:	b9 0a 00 00 00       	mov    $0xa,%ecx
 668:	6a 01                	push   $0x1
 66a:	eb ce                	jmp    63a <printf+0xea>
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 670:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 673:	83 ec 04             	sub    $0x4,%esp
 676:	8b 03                	mov    (%ebx),%eax
 678:	6a 01                	push   $0x1
 67a:	83 c3 04             	add    $0x4,%ebx
 67d:	57                   	push   %edi
 67e:	ff 75 08             	pushl  0x8(%ebp)
 681:	88 45 e7             	mov    %al,-0x19(%ebp)
 684:	e8 5a fd ff ff       	call   3e3 <write>
 689:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 68c:	83 c4 10             	add    $0x10,%esp
 68f:	31 d2                	xor    %edx,%edx
 691:	e9 0e ff ff ff       	jmp    5a4 <printf+0x54>
 696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69d:	8d 76 00             	lea    0x0(%esi),%esi
 6a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6a3:	83 ec 04             	sub    $0x4,%esp
 6a6:	e9 59 ff ff ff       	jmp    604 <printf+0xb4>
 6ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6af:	90                   	nop
 6b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6b3:	8b 18                	mov    (%eax),%ebx
 6b5:	83 c0 04             	add    $0x4,%eax
 6b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6bb:	85 db                	test   %ebx,%ebx
 6bd:	74 17                	je     6d6 <printf+0x186>
 6bf:	0f b6 03             	movzbl (%ebx),%eax
 6c2:	31 d2                	xor    %edx,%edx
 6c4:	84 c0                	test   %al,%al
 6c6:	0f 84 d8 fe ff ff    	je     5a4 <printf+0x54>
 6cc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6cf:	89 de                	mov    %ebx,%esi
 6d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6d4:	eb 1a                	jmp    6f0 <printf+0x1a0>
 6d6:	bb 28 09 00 00       	mov    $0x928,%ebx
 6db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6de:	b8 28 00 00 00       	mov    $0x28,%eax
 6e3:	89 de                	mov    %ebx,%esi
 6e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ef:	90                   	nop
 6f0:	83 ec 04             	sub    $0x4,%esp
 6f3:	83 c6 01             	add    $0x1,%esi
 6f6:	88 45 e7             	mov    %al,-0x19(%ebp)
 6f9:	6a 01                	push   $0x1
 6fb:	57                   	push   %edi
 6fc:	53                   	push   %ebx
 6fd:	e8 e1 fc ff ff       	call   3e3 <write>
 702:	0f b6 06             	movzbl (%esi),%eax
 705:	83 c4 10             	add    $0x10,%esp
 708:	84 c0                	test   %al,%al
 70a:	75 e4                	jne    6f0 <printf+0x1a0>
 70c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 70f:	31 d2                	xor    %edx,%edx
 711:	e9 8e fe ff ff       	jmp    5a4 <printf+0x54>
 716:	66 90                	xchg   %ax,%ax
 718:	66 90                	xchg   %ax,%ax
 71a:	66 90                	xchg   %ax,%ax
 71c:	66 90                	xchg   %ax,%ax
 71e:	66 90                	xchg   %ax,%ax

00000720 <free>:
 720:	f3 0f 1e fb          	endbr32 
 724:	55                   	push   %ebp
 725:	a1 04 0c 00 00       	mov    0xc04,%eax
 72a:	89 e5                	mov    %esp,%ebp
 72c:	57                   	push   %edi
 72d:	56                   	push   %esi
 72e:	53                   	push   %ebx
 72f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 732:	8b 10                	mov    (%eax),%edx
 734:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 737:	39 c8                	cmp    %ecx,%eax
 739:	73 15                	jae    750 <free+0x30>
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
 740:	39 d1                	cmp    %edx,%ecx
 742:	72 14                	jb     758 <free+0x38>
 744:	39 d0                	cmp    %edx,%eax
 746:	73 10                	jae    758 <free+0x38>
 748:	89 d0                	mov    %edx,%eax
 74a:	8b 10                	mov    (%eax),%edx
 74c:	39 c8                	cmp    %ecx,%eax
 74e:	72 f0                	jb     740 <free+0x20>
 750:	39 d0                	cmp    %edx,%eax
 752:	72 f4                	jb     748 <free+0x28>
 754:	39 d1                	cmp    %edx,%ecx
 756:	73 f0                	jae    748 <free+0x28>
 758:	8b 73 fc             	mov    -0x4(%ebx),%esi
 75b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75e:	39 fa                	cmp    %edi,%edx
 760:	74 1e                	je     780 <free+0x60>
 762:	89 53 f8             	mov    %edx,-0x8(%ebx)
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 76b:	39 f1                	cmp    %esi,%ecx
 76d:	74 28                	je     797 <free+0x77>
 76f:	89 08                	mov    %ecx,(%eax)
 771:	5b                   	pop    %ebx
 772:	a3 04 0c 00 00       	mov    %eax,0xc04
 777:	5e                   	pop    %esi
 778:	5f                   	pop    %edi
 779:	5d                   	pop    %ebp
 77a:	c3                   	ret    
 77b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop
 780:	03 72 04             	add    0x4(%edx),%esi
 783:	89 73 fc             	mov    %esi,-0x4(%ebx)
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 12                	mov    (%edx),%edx
 78a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 793:	39 f1                	cmp    %esi,%ecx
 795:	75 d8                	jne    76f <free+0x4f>
 797:	03 53 fc             	add    -0x4(%ebx),%edx
 79a:	a3 04 0c 00 00       	mov    %eax,0xc04
 79f:	89 50 04             	mov    %edx,0x4(%eax)
 7a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7a5:	89 10                	mov    %edx,(%eax)
 7a7:	5b                   	pop    %ebx
 7a8:	5e                   	pop    %esi
 7a9:	5f                   	pop    %edi
 7aa:	5d                   	pop    %ebp
 7ab:	c3                   	ret    
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007b0 <malloc>:
 7b0:	f3 0f 1e fb          	endbr32 
 7b4:	55                   	push   %ebp
 7b5:	89 e5                	mov    %esp,%ebp
 7b7:	57                   	push   %edi
 7b8:	56                   	push   %esi
 7b9:	53                   	push   %ebx
 7ba:	83 ec 1c             	sub    $0x1c,%esp
 7bd:	8b 45 08             	mov    0x8(%ebp),%eax
 7c0:	8b 3d 04 0c 00 00    	mov    0xc04,%edi
 7c6:	8d 70 07             	lea    0x7(%eax),%esi
 7c9:	c1 ee 03             	shr    $0x3,%esi
 7cc:	83 c6 01             	add    $0x1,%esi
 7cf:	85 ff                	test   %edi,%edi
 7d1:	0f 84 a9 00 00 00    	je     880 <malloc+0xd0>
 7d7:	8b 07                	mov    (%edi),%eax
 7d9:	8b 48 04             	mov    0x4(%eax),%ecx
 7dc:	39 f1                	cmp    %esi,%ecx
 7de:	73 6d                	jae    84d <malloc+0x9d>
 7e0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7e6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7eb:	0f 43 de             	cmovae %esi,%ebx
 7ee:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 7f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 7f8:	eb 17                	jmp    811 <malloc+0x61>
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 800:	8b 10                	mov    (%eax),%edx
 802:	8b 4a 04             	mov    0x4(%edx),%ecx
 805:	39 f1                	cmp    %esi,%ecx
 807:	73 4f                	jae    858 <malloc+0xa8>
 809:	8b 3d 04 0c 00 00    	mov    0xc04,%edi
 80f:	89 d0                	mov    %edx,%eax
 811:	39 c7                	cmp    %eax,%edi
 813:	75 eb                	jne    800 <malloc+0x50>
 815:	83 ec 0c             	sub    $0xc,%esp
 818:	ff 75 e4             	pushl  -0x1c(%ebp)
 81b:	e8 2b fc ff ff       	call   44b <sbrk>
 820:	83 c4 10             	add    $0x10,%esp
 823:	83 f8 ff             	cmp    $0xffffffff,%eax
 826:	74 1b                	je     843 <malloc+0x93>
 828:	89 58 04             	mov    %ebx,0x4(%eax)
 82b:	83 ec 0c             	sub    $0xc,%esp
 82e:	83 c0 08             	add    $0x8,%eax
 831:	50                   	push   %eax
 832:	e8 e9 fe ff ff       	call   720 <free>
 837:	a1 04 0c 00 00       	mov    0xc04,%eax
 83c:	83 c4 10             	add    $0x10,%esp
 83f:	85 c0                	test   %eax,%eax
 841:	75 bd                	jne    800 <malloc+0x50>
 843:	8d 65 f4             	lea    -0xc(%ebp),%esp
 846:	31 c0                	xor    %eax,%eax
 848:	5b                   	pop    %ebx
 849:	5e                   	pop    %esi
 84a:	5f                   	pop    %edi
 84b:	5d                   	pop    %ebp
 84c:	c3                   	ret    
 84d:	89 c2                	mov    %eax,%edx
 84f:	89 f8                	mov    %edi,%eax
 851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 858:	39 ce                	cmp    %ecx,%esi
 85a:	74 54                	je     8b0 <malloc+0x100>
 85c:	29 f1                	sub    %esi,%ecx
 85e:	89 4a 04             	mov    %ecx,0x4(%edx)
 861:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
 864:	89 72 04             	mov    %esi,0x4(%edx)
 867:	a3 04 0c 00 00       	mov    %eax,0xc04
 86c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 86f:	8d 42 08             	lea    0x8(%edx),%eax
 872:	5b                   	pop    %ebx
 873:	5e                   	pop    %esi
 874:	5f                   	pop    %edi
 875:	5d                   	pop    %ebp
 876:	c3                   	ret    
 877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 87e:	66 90                	xchg   %ax,%ax
 880:	c7 05 04 0c 00 00 08 	movl   $0xc08,0xc04
 887:	0c 00 00 
 88a:	bf 08 0c 00 00       	mov    $0xc08,%edi
 88f:	c7 05 08 0c 00 00 08 	movl   $0xc08,0xc08
 896:	0c 00 00 
 899:	89 f8                	mov    %edi,%eax
 89b:	c7 05 0c 0c 00 00 00 	movl   $0x0,0xc0c
 8a2:	00 00 00 
 8a5:	e9 36 ff ff ff       	jmp    7e0 <malloc+0x30>
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8b0:	8b 0a                	mov    (%edx),%ecx
 8b2:	89 08                	mov    %ecx,(%eax)
 8b4:	eb b1                	jmp    867 <malloc+0xb7>
