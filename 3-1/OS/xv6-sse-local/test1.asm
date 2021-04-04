
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
		else  						//parent
			wait();
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
  15:	68 22 0b 00 00       	push   $0xb22
  1a:	6a 01                	push   $0x1
  1c:	e8 6f 06 00 00       	call   690 <printf>
		test_p1_1();
  21:	e8 1a 00 00 00       	call   40 <test_p1_1>
		printf(1, "=== TEST   END ===\n");
  26:	58                   	pop    %eax
  27:	5a                   	pop    %edx
  28:	68 36 0b 00 00       	push   $0xb36
  2d:	6a 01                	push   $0x1
  2f:	e8 5c 06 00 00       	call   690 <printf>

		exit();
  34:	e8 ca 04 00 00       	call   503 <exit>
  39:	66 90                	xchg   %ax,%ax
  3b:	66 90                	xchg   %ax,%ax
  3d:	66 90                	xchg   %ax,%ax
  3f:	90                   	nop

00000040 <test_p1_1>:
{
  40:	f3 0f 1e fb          	endbr32 
  44:	55                   	push   %ebp
  45:	89 e5                	mov    %esp,%ebp
  47:	53                   	push   %ebx
  48:	83 ec 0c             	sub    $0xc,%esp
	printf(1, "case 1. get nice value of init process: ");
  4b:	68 f8 09 00 00       	push   $0x9f8
  50:	6a 01                	push   $0x1
  52:	e8 39 06 00 00       	call   690 <printf>
		if (getnice(1) == 0) // Customed from == 5 to == 0
  57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5e:	e8 58 05 00 00       	call   5bb <getnice>
  63:	83 c4 10             	add    $0x10,%esp
  66:	85 c0                	test   %eax,%eax
  68:	0f 85 52 01 00 00    	jne    1c0 <test_p1_1+0x180>
			printf(1, "OK\n");
  6e:	83 ec 08             	sub    $0x8,%esp
  71:	68 17 0b 00 00       	push   $0xb17
  76:	6a 01                	push   $0x1
  78:	e8 13 06 00 00       	call   690 <printf>
  7d:	83 c4 10             	add    $0x10,%esp
		printf(1, "case 2. get nice value of non-existing process: ");
  80:	83 ec 08             	sub    $0x8,%esp
  83:	68 24 0a 00 00       	push   $0xa24
  88:	6a 01                	push   $0x1
  8a:	e8 01 06 00 00       	call   690 <printf>
		if (getnice(100) == -1) 
  8f:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  96:	e8 20 05 00 00       	call   5bb <getnice>
  9b:	83 c4 10             	add    $0x10,%esp
  9e:	83 f8 ff             	cmp    $0xffffffff,%eax
  a1:	0f 84 79 01 00 00    	je     220 <test_p1_1+0x1e0>
			printf(1, "WRONG\n");
  a7:	83 ec 08             	sub    $0x8,%esp
  aa:	68 1b 0b 00 00       	push   $0xb1b
  af:	6a 01                	push   $0x1
  b1:	e8 da 05 00 00       	call   690 <printf>
  b6:	83 c4 10             	add    $0x10,%esp
		printf(1, "case 3. set nice value of current process: ");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 58 0a 00 00       	push   $0xa58
  c1:	6a 01                	push   $0x1
  c3:	e8 c8 05 00 00       	call   690 <printf>
		pid = getpid();
  c8:	e8 b6 04 00 00       	call   583 <getpid>
  cd:	89 c3                	mov    %eax,%ebx
		setnice(pid, 3);
  cf:	58                   	pop    %eax
  d0:	5a                   	pop    %edx
  d1:	6a 03                	push   $0x3
  d3:	53                   	push   %ebx
  d4:	e8 da 04 00 00       	call   5b3 <setnice>
		if (getnice(pid) == 3) 
  d9:	89 1c 24             	mov    %ebx,(%esp)
  dc:	e8 da 04 00 00       	call   5bb <getnice>
  e1:	83 c4 10             	add    $0x10,%esp
  e4:	83 f8 03             	cmp    $0x3,%eax
  e7:	0f 84 73 01 00 00    	je     260 <test_p1_1+0x220>
			printf(1, "WRONG\n");
  ed:	83 ec 08             	sub    $0x8,%esp
  f0:	68 1b 0b 00 00       	push   $0xb1b
  f5:	6a 01                	push   $0x1
  f7:	e8 94 05 00 00       	call   690 <printf>
  fc:	83 c4 10             	add    $0x10,%esp
		printf(1, "case 4. set nice value of non-existing process: ");
  ff:	83 ec 08             	sub    $0x8,%esp
 102:	68 84 0a 00 00       	push   $0xa84
 107:	6a 01                	push   $0x1
 109:	e8 82 05 00 00       	call   690 <printf>
		if (setnice(100, 3) == -1) 
 10e:	59                   	pop    %ecx
 10f:	58                   	pop    %eax
 110:	6a 03                	push   $0x3
 112:	6a 64                	push   $0x64
 114:	e8 9a 04 00 00       	call   5b3 <setnice>
 119:	83 c4 10             	add    $0x10,%esp
 11c:	83 f8 ff             	cmp    $0xffffffff,%eax
 11f:	0f 84 1b 01 00 00    	je     240 <test_p1_1+0x200>
			printf(1, "WRONG\n");
 125:	83 ec 08             	sub    $0x8,%esp
 128:	68 1b 0b 00 00       	push   $0xb1b
 12d:	6a 01                	push   $0x1
 12f:	e8 5c 05 00 00       	call   690 <printf>
 134:	83 c4 10             	add    $0x10,%esp
		printf(1, "case 5. set wrong nice value of current process: ");
 137:	83 ec 08             	sub    $0x8,%esp
 13a:	68 b8 0a 00 00       	push   $0xab8
 13f:	6a 01                	push   $0x1
 141:	e8 4a 05 00 00       	call   690 <printf>
		if (setnice(pid, -1) == -1 && setnice(pid, 11) == -1) 
 146:	58                   	pop    %eax
 147:	5a                   	pop    %edx
 148:	6a ff                	push   $0xffffffff
 14a:	53                   	push   %ebx
 14b:	e8 63 04 00 00       	call   5b3 <setnice>
 150:	83 c4 10             	add    $0x10,%esp
 153:	83 f8 ff             	cmp    $0xffffffff,%eax
 156:	0f 84 94 00 00 00    	je     1f0 <test_p1_1+0x1b0>
			printf(1, "WRONG\n");
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	68 1b 0b 00 00       	push   $0xb1b
 164:	6a 01                	push   $0x1
 166:	e8 25 05 00 00       	call   690 <printf>
 16b:	83 c4 10             	add    $0x10,%esp
		printf(1, "case 6. get nice value of forked process: ");
 16e:	83 ec 08             	sub    $0x8,%esp
 171:	68 ec 0a 00 00       	push   $0xaec
 176:	6a 01                	push   $0x1
 178:	e8 13 05 00 00       	call   690 <printf>
		nice = getnice(pid);
 17d:	89 1c 24             	mov    %ebx,(%esp)
 180:	e8 36 04 00 00       	call   5bb <getnice>
 185:	89 c3                	mov    %eax,%ebx
		pid = fork();
 187:	e8 6f 03 00 00       	call   4fb <fork>
		if (pid == 0) {	//child
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	85 c0                	test   %eax,%eax
 191:	75 4d                	jne    1e0 <test_p1_1+0x1a0>
			if (getnice(getpid()) == nice) { 
 193:	e8 eb 03 00 00       	call   583 <getpid>
 198:	83 ec 0c             	sub    $0xc,%esp
 19b:	50                   	push   %eax
 19c:	e8 1a 04 00 00       	call   5bb <getnice>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	39 d8                	cmp    %ebx,%eax
 1a6:	0f 84 d4 00 00 00    	je     280 <test_p1_1+0x240>
				printf(1, "WRONG\n");
 1ac:	83 ec 08             	sub    $0x8,%esp
 1af:	68 1b 0b 00 00       	push   $0xb1b
 1b4:	6a 01                	push   $0x1
 1b6:	e8 d5 04 00 00       	call   690 <printf>
				exit();
 1bb:	e8 43 03 00 00       	call   503 <exit>
			printf(1, "WRONG\n");
 1c0:	83 ec 08             	sub    $0x8,%esp
 1c3:	68 1b 0b 00 00       	push   $0xb1b
 1c8:	6a 01                	push   $0x1
 1ca:	e8 c1 04 00 00       	call   690 <printf>
 1cf:	83 c4 10             	add    $0x10,%esp
 1d2:	e9 a9 fe ff ff       	jmp    80 <test_p1_1+0x40>
 1d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1de:	66 90                	xchg   %ax,%ax
}
 1e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e3:	c9                   	leave  
			wait();
 1e4:	e9 22 03 00 00       	jmp    50b <wait>
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (setnice(pid, -1) == -1 && setnice(pid, 11) == -1) 
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 0b                	push   $0xb
 1f5:	53                   	push   %ebx
 1f6:	e8 b8 03 00 00       	call   5b3 <setnice>
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	83 f8 ff             	cmp    $0xffffffff,%eax
 201:	0f 85 55 ff ff ff    	jne    15c <test_p1_1+0x11c>
			printf(1, "OK\n");
 207:	83 ec 08             	sub    $0x8,%esp
 20a:	68 17 0b 00 00       	push   $0xb17
 20f:	6a 01                	push   $0x1
 211:	e8 7a 04 00 00       	call   690 <printf>
 216:	83 c4 10             	add    $0x10,%esp
 219:	e9 50 ff ff ff       	jmp    16e <test_p1_1+0x12e>
 21e:	66 90                	xchg   %ax,%ax
			printf(1, "OK\n");
 220:	83 ec 08             	sub    $0x8,%esp
 223:	68 17 0b 00 00       	push   $0xb17
 228:	6a 01                	push   $0x1
 22a:	e8 61 04 00 00       	call   690 <printf>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	e9 82 fe ff ff       	jmp    b9 <test_p1_1+0x79>
 237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23e:	66 90                	xchg   %ax,%ax
			printf(1, "OK\n");
 240:	83 ec 08             	sub    $0x8,%esp
 243:	68 17 0b 00 00       	push   $0xb17
 248:	6a 01                	push   $0x1
 24a:	e8 41 04 00 00       	call   690 <printf>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	e9 e0 fe ff ff       	jmp    137 <test_p1_1+0xf7>
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax
			printf(1, "OK\n");
 260:	83 ec 08             	sub    $0x8,%esp
 263:	68 17 0b 00 00       	push   $0xb17
 268:	6a 01                	push   $0x1
 26a:	e8 21 04 00 00       	call   690 <printf>
 26f:	83 c4 10             	add    $0x10,%esp
 272:	e9 88 fe ff ff       	jmp    ff <test_p1_1+0xbf>
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax
				printf(1, "OK\n");
 280:	83 ec 08             	sub    $0x8,%esp
 283:	68 17 0b 00 00       	push   $0xb17
 288:	6a 01                	push   $0x1
 28a:	e8 01 04 00 00       	call   690 <printf>
				exit();
 28f:	e8 6f 02 00 00       	call   503 <exit>
 294:	66 90                	xchg   %ax,%ax
 296:	66 90                	xchg   %ax,%ax
 298:	66 90                	xchg   %ax,%ax
 29a:	66 90                	xchg   %ax,%ax
 29c:	66 90                	xchg   %ax,%ax
 29e:	66 90                	xchg   %ax,%ax

000002a0 <strcpy>:
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	31 c0                	xor    %eax,%eax
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	53                   	push   %ebx
 2aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2b7:	83 c0 01             	add    $0x1,%eax
 2ba:	84 d2                	test   %dl,%dl
 2bc:	75 f2                	jne    2b0 <strcpy+0x10>
 2be:	89 c8                	mov    %ecx,%eax
 2c0:	5b                   	pop    %ebx
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    
 2c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002d0 <strcmp>:
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	53                   	push   %ebx
 2d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2db:	8b 55 0c             	mov    0xc(%ebp),%edx
 2de:	0f b6 01             	movzbl (%ecx),%eax
 2e1:	0f b6 1a             	movzbl (%edx),%ebx
 2e4:	84 c0                	test   %al,%al
 2e6:	75 19                	jne    301 <strcmp+0x31>
 2e8:	eb 26                	jmp    310 <strcmp+0x40>
 2ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2f0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
 2f4:	83 c1 01             	add    $0x1,%ecx
 2f7:	83 c2 01             	add    $0x1,%edx
 2fa:	0f b6 1a             	movzbl (%edx),%ebx
 2fd:	84 c0                	test   %al,%al
 2ff:	74 0f                	je     310 <strcmp+0x40>
 301:	38 d8                	cmp    %bl,%al
 303:	74 eb                	je     2f0 <strcmp+0x20>
 305:	29 d8                	sub    %ebx,%eax
 307:	5b                   	pop    %ebx
 308:	5d                   	pop    %ebp
 309:	c3                   	ret    
 30a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 310:	31 c0                	xor    %eax,%eax
 312:	29 d8                	sub    %ebx,%eax
 314:	5b                   	pop    %ebx
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
 317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31e:	66 90                	xchg   %ax,%ax

00000320 <strlen>:
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	8b 55 08             	mov    0x8(%ebp),%edx
 32a:	80 3a 00             	cmpb   $0x0,(%edx)
 32d:	74 21                	je     350 <strlen+0x30>
 32f:	31 c0                	xor    %eax,%eax
 331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 338:	83 c0 01             	add    $0x1,%eax
 33b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 33f:	89 c1                	mov    %eax,%ecx
 341:	75 f5                	jne    338 <strlen+0x18>
 343:	89 c8                	mov    %ecx,%eax
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
 347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34e:	66 90                	xchg   %ax,%ax
 350:	31 c9                	xor    %ecx,%ecx
 352:	5d                   	pop    %ebp
 353:	89 c8                	mov    %ecx,%eax
 355:	c3                   	ret    
 356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35d:	8d 76 00             	lea    0x0(%esi),%esi

00000360 <memset>:
 360:	f3 0f 1e fb          	endbr32 
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	8b 55 08             	mov    0x8(%ebp),%edx
 36b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	89 d7                	mov    %edx,%edi
 373:	fc                   	cld    
 374:	f3 aa                	rep stos %al,%es:(%edi)
 376:	89 d0                	mov    %edx,%eax
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    
 37b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 37f:	90                   	nop

00000380 <strchr>:
 380:	f3 0f 1e fb          	endbr32 
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 38e:	0f b6 10             	movzbl (%eax),%edx
 391:	84 d2                	test   %dl,%dl
 393:	75 16                	jne    3ab <strchr+0x2b>
 395:	eb 21                	jmp    3b8 <strchr+0x38>
 397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39e:	66 90                	xchg   %ax,%ax
 3a0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3a4:	83 c0 01             	add    $0x1,%eax
 3a7:	84 d2                	test   %dl,%dl
 3a9:	74 0d                	je     3b8 <strchr+0x38>
 3ab:	38 d1                	cmp    %dl,%cl
 3ad:	75 f1                	jne    3a0 <strchr+0x20>
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret    
 3b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3b8:	31 c0                	xor    %eax,%eax
 3ba:	5d                   	pop    %ebp
 3bb:	c3                   	ret    
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <gets>:
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	57                   	push   %edi
 3c8:	56                   	push   %esi
 3c9:	31 f6                	xor    %esi,%esi
 3cb:	53                   	push   %ebx
 3cc:	89 f3                	mov    %esi,%ebx
 3ce:	83 ec 1c             	sub    $0x1c,%esp
 3d1:	8b 7d 08             	mov    0x8(%ebp),%edi
 3d4:	eb 33                	jmp    409 <gets+0x49>
 3d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	83 ec 04             	sub    $0x4,%esp
 3e3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3e6:	6a 01                	push   $0x1
 3e8:	50                   	push   %eax
 3e9:	6a 00                	push   $0x0
 3eb:	e8 2b 01 00 00       	call   51b <read>
 3f0:	83 c4 10             	add    $0x10,%esp
 3f3:	85 c0                	test   %eax,%eax
 3f5:	7e 1c                	jle    413 <gets+0x53>
 3f7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3fb:	83 c7 01             	add    $0x1,%edi
 3fe:	88 47 ff             	mov    %al,-0x1(%edi)
 401:	3c 0a                	cmp    $0xa,%al
 403:	74 23                	je     428 <gets+0x68>
 405:	3c 0d                	cmp    $0xd,%al
 407:	74 1f                	je     428 <gets+0x68>
 409:	83 c3 01             	add    $0x1,%ebx
 40c:	89 fe                	mov    %edi,%esi
 40e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 411:	7c cd                	jl     3e0 <gets+0x20>
 413:	89 f3                	mov    %esi,%ebx
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	c6 03 00             	movb   $0x0,(%ebx)
 41b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41e:	5b                   	pop    %ebx
 41f:	5e                   	pop    %esi
 420:	5f                   	pop    %edi
 421:	5d                   	pop    %ebp
 422:	c3                   	ret    
 423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 427:	90                   	nop
 428:	8b 75 08             	mov    0x8(%ebp),%esi
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	01 de                	add    %ebx,%esi
 430:	89 f3                	mov    %esi,%ebx
 432:	c6 03 00             	movb   $0x0,(%ebx)
 435:	8d 65 f4             	lea    -0xc(%ebp),%esp
 438:	5b                   	pop    %ebx
 439:	5e                   	pop    %esi
 43a:	5f                   	pop    %edi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi

00000440 <stat>:
 440:	f3 0f 1e fb          	endbr32 
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	56                   	push   %esi
 448:	53                   	push   %ebx
 449:	83 ec 08             	sub    $0x8,%esp
 44c:	6a 00                	push   $0x0
 44e:	ff 75 08             	pushl  0x8(%ebp)
 451:	e8 ed 00 00 00       	call   543 <open>
 456:	83 c4 10             	add    $0x10,%esp
 459:	85 c0                	test   %eax,%eax
 45b:	78 2b                	js     488 <stat+0x48>
 45d:	83 ec 08             	sub    $0x8,%esp
 460:	ff 75 0c             	pushl  0xc(%ebp)
 463:	89 c3                	mov    %eax,%ebx
 465:	50                   	push   %eax
 466:	e8 f0 00 00 00       	call   55b <fstat>
 46b:	89 1c 24             	mov    %ebx,(%esp)
 46e:	89 c6                	mov    %eax,%esi
 470:	e8 b6 00 00 00       	call   52b <close>
 475:	83 c4 10             	add    $0x10,%esp
 478:	8d 65 f8             	lea    -0x8(%ebp),%esp
 47b:	89 f0                	mov    %esi,%eax
 47d:	5b                   	pop    %ebx
 47e:	5e                   	pop    %esi
 47f:	5d                   	pop    %ebp
 480:	c3                   	ret    
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 488:	be ff ff ff ff       	mov    $0xffffffff,%esi
 48d:	eb e9                	jmp    478 <stat+0x38>
 48f:	90                   	nop

00000490 <atoi>:
 490:	f3 0f 1e fb          	endbr32 
 494:	55                   	push   %ebp
 495:	89 e5                	mov    %esp,%ebp
 497:	53                   	push   %ebx
 498:	8b 55 08             	mov    0x8(%ebp),%edx
 49b:	0f be 02             	movsbl (%edx),%eax
 49e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4a1:	80 f9 09             	cmp    $0x9,%cl
 4a4:	b9 00 00 00 00       	mov    $0x0,%ecx
 4a9:	77 1a                	ja     4c5 <atoi+0x35>
 4ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop
 4b0:	83 c2 01             	add    $0x1,%edx
 4b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 4ba:	0f be 02             	movsbl (%edx),%eax
 4bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4c0:	80 fb 09             	cmp    $0x9,%bl
 4c3:	76 eb                	jbe    4b0 <atoi+0x20>
 4c5:	89 c8                	mov    %ecx,%eax
 4c7:	5b                   	pop    %ebx
 4c8:	5d                   	pop    %ebp
 4c9:	c3                   	ret    
 4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004d0 <memmove>:
 4d0:	f3 0f 1e fb          	endbr32 
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	57                   	push   %edi
 4d8:	8b 45 10             	mov    0x10(%ebp),%eax
 4db:	8b 55 08             	mov    0x8(%ebp),%edx
 4de:	56                   	push   %esi
 4df:	8b 75 0c             	mov    0xc(%ebp),%esi
 4e2:	85 c0                	test   %eax,%eax
 4e4:	7e 0f                	jle    4f5 <memmove+0x25>
 4e6:	01 d0                	add    %edx,%eax
 4e8:	89 d7                	mov    %edx,%edi
 4ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 4f1:	39 f8                	cmp    %edi,%eax
 4f3:	75 fb                	jne    4f0 <memmove+0x20>
 4f5:	5e                   	pop    %esi
 4f6:	89 d0                	mov    %edx,%eax
 4f8:	5f                   	pop    %edi
 4f9:	5d                   	pop    %ebp
 4fa:	c3                   	ret    

000004fb <fork>:
 4fb:	b8 01 00 00 00       	mov    $0x1,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <exit>:
 503:	b8 02 00 00 00       	mov    $0x2,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <wait>:
 50b:	b8 03 00 00 00       	mov    $0x3,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <pipe>:
 513:	b8 04 00 00 00       	mov    $0x4,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <read>:
 51b:	b8 05 00 00 00       	mov    $0x5,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <write>:
 523:	b8 10 00 00 00       	mov    $0x10,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <close>:
 52b:	b8 15 00 00 00       	mov    $0x15,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <kill>:
 533:	b8 06 00 00 00       	mov    $0x6,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <exec>:
 53b:	b8 07 00 00 00       	mov    $0x7,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <open>:
 543:	b8 0f 00 00 00       	mov    $0xf,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <mknod>:
 54b:	b8 11 00 00 00       	mov    $0x11,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <unlink>:
 553:	b8 12 00 00 00       	mov    $0x12,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <fstat>:
 55b:	b8 08 00 00 00       	mov    $0x8,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <link>:
 563:	b8 13 00 00 00       	mov    $0x13,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <mkdir>:
 56b:	b8 14 00 00 00       	mov    $0x14,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <chdir>:
 573:	b8 09 00 00 00       	mov    $0x9,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <dup>:
 57b:	b8 0a 00 00 00       	mov    $0xa,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <getpid>:
 583:	b8 0b 00 00 00       	mov    $0xb,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <sbrk>:
 58b:	b8 0c 00 00 00       	mov    $0xc,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <sleep>:
 593:	b8 0d 00 00 00       	mov    $0xd,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <uptime>:
 59b:	b8 0e 00 00 00       	mov    $0xe,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <swapread>:
 5a3:	b8 16 00 00 00       	mov    $0x16,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <swapwrite>:
 5ab:	b8 17 00 00 00       	mov    $0x17,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <setnice>:
 5b3:	b8 18 00 00 00       	mov    $0x18,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <getnice>:
 5bb:	b8 19 00 00 00       	mov    $0x19,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <yield>:
 5c3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <ps>:
 5cb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    
 5d3:	66 90                	xchg   %ax,%ax
 5d5:	66 90                	xchg   %ax,%ax
 5d7:	66 90                	xchg   %ax,%ax
 5d9:	66 90                	xchg   %ax,%ax
 5db:	66 90                	xchg   %ax,%ax
 5dd:	66 90                	xchg   %ax,%ax
 5df:	90                   	nop

000005e0 <printint>:
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 3c             	sub    $0x3c,%esp
 5e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 5ec:	89 d1                	mov    %edx,%ecx
 5ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
 5f1:	85 d2                	test   %edx,%edx
 5f3:	0f 89 7f 00 00 00    	jns    678 <printint+0x98>
 5f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5fd:	74 79                	je     678 <printint+0x98>
 5ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 606:	f7 d9                	neg    %ecx
 608:	31 db                	xor    %ebx,%ebx
 60a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 60d:	8d 76 00             	lea    0x0(%esi),%esi
 610:	89 c8                	mov    %ecx,%eax
 612:	31 d2                	xor    %edx,%edx
 614:	89 cf                	mov    %ecx,%edi
 616:	f7 75 c4             	divl   -0x3c(%ebp)
 619:	0f b6 92 54 0b 00 00 	movzbl 0xb54(%edx),%edx
 620:	89 45 c0             	mov    %eax,-0x40(%ebp)
 623:	89 d8                	mov    %ebx,%eax
 625:	8d 5b 01             	lea    0x1(%ebx),%ebx
 628:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 62b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 62e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 631:	76 dd                	jbe    610 <printint+0x30>
 633:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 636:	85 c9                	test   %ecx,%ecx
 638:	74 0c                	je     646 <printint+0x66>
 63a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 63f:	89 d8                	mov    %ebx,%eax
 641:	ba 2d 00 00 00       	mov    $0x2d,%edx
 646:	8b 7d b8             	mov    -0x48(%ebp),%edi
 649:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 64d:	eb 07                	jmp    656 <printint+0x76>
 64f:	90                   	nop
 650:	0f b6 13             	movzbl (%ebx),%edx
 653:	83 eb 01             	sub    $0x1,%ebx
 656:	83 ec 04             	sub    $0x4,%esp
 659:	88 55 d7             	mov    %dl,-0x29(%ebp)
 65c:	6a 01                	push   $0x1
 65e:	56                   	push   %esi
 65f:	57                   	push   %edi
 660:	e8 be fe ff ff       	call   523 <write>
 665:	83 c4 10             	add    $0x10,%esp
 668:	39 de                	cmp    %ebx,%esi
 66a:	75 e4                	jne    650 <printint+0x70>
 66c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66f:	5b                   	pop    %ebx
 670:	5e                   	pop    %esi
 671:	5f                   	pop    %edi
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 678:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 67f:	eb 87                	jmp    608 <printint+0x28>
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop

00000690 <printf>:
 690:	f3 0f 1e fb          	endbr32 
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	57                   	push   %edi
 698:	56                   	push   %esi
 699:	53                   	push   %ebx
 69a:	83 ec 2c             	sub    $0x2c,%esp
 69d:	8b 75 0c             	mov    0xc(%ebp),%esi
 6a0:	0f b6 1e             	movzbl (%esi),%ebx
 6a3:	84 db                	test   %bl,%bl
 6a5:	0f 84 b4 00 00 00    	je     75f <printf+0xcf>
 6ab:	8d 45 10             	lea    0x10(%ebp),%eax
 6ae:	83 c6 01             	add    $0x1,%esi
 6b1:	8d 7d e7             	lea    -0x19(%ebp),%edi
 6b4:	31 d2                	xor    %edx,%edx
 6b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b9:	eb 33                	jmp    6ee <printf+0x5e>
 6bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop
 6c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6c3:	ba 25 00 00 00       	mov    $0x25,%edx
 6c8:	83 f8 25             	cmp    $0x25,%eax
 6cb:	74 17                	je     6e4 <printf+0x54>
 6cd:	83 ec 04             	sub    $0x4,%esp
 6d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6d3:	6a 01                	push   $0x1
 6d5:	57                   	push   %edi
 6d6:	ff 75 08             	pushl  0x8(%ebp)
 6d9:	e8 45 fe ff ff       	call   523 <write>
 6de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6e1:	83 c4 10             	add    $0x10,%esp
 6e4:	0f b6 1e             	movzbl (%esi),%ebx
 6e7:	83 c6 01             	add    $0x1,%esi
 6ea:	84 db                	test   %bl,%bl
 6ec:	74 71                	je     75f <printf+0xcf>
 6ee:	0f be cb             	movsbl %bl,%ecx
 6f1:	0f b6 c3             	movzbl %bl,%eax
 6f4:	85 d2                	test   %edx,%edx
 6f6:	74 c8                	je     6c0 <printf+0x30>
 6f8:	83 fa 25             	cmp    $0x25,%edx
 6fb:	75 e7                	jne    6e4 <printf+0x54>
 6fd:	83 f8 64             	cmp    $0x64,%eax
 700:	0f 84 9a 00 00 00    	je     7a0 <printf+0x110>
 706:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 70c:	83 f9 70             	cmp    $0x70,%ecx
 70f:	74 5f                	je     770 <printf+0xe0>
 711:	83 f8 73             	cmp    $0x73,%eax
 714:	0f 84 d6 00 00 00    	je     7f0 <printf+0x160>
 71a:	83 f8 63             	cmp    $0x63,%eax
 71d:	0f 84 8d 00 00 00    	je     7b0 <printf+0x120>
 723:	83 f8 25             	cmp    $0x25,%eax
 726:	0f 84 b4 00 00 00    	je     7e0 <printf+0x150>
 72c:	83 ec 04             	sub    $0x4,%esp
 72f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 733:	6a 01                	push   $0x1
 735:	57                   	push   %edi
 736:	ff 75 08             	pushl  0x8(%ebp)
 739:	e8 e5 fd ff ff       	call   523 <write>
 73e:	88 5d e7             	mov    %bl,-0x19(%ebp)
 741:	83 c4 0c             	add    $0xc,%esp
 744:	6a 01                	push   $0x1
 746:	83 c6 01             	add    $0x1,%esi
 749:	57                   	push   %edi
 74a:	ff 75 08             	pushl  0x8(%ebp)
 74d:	e8 d1 fd ff ff       	call   523 <write>
 752:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 756:	83 c4 10             	add    $0x10,%esp
 759:	31 d2                	xor    %edx,%edx
 75b:	84 db                	test   %bl,%bl
 75d:	75 8f                	jne    6ee <printf+0x5e>
 75f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 762:	5b                   	pop    %ebx
 763:	5e                   	pop    %esi
 764:	5f                   	pop    %edi
 765:	5d                   	pop    %ebp
 766:	c3                   	ret    
 767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76e:	66 90                	xchg   %ax,%ax
 770:	83 ec 0c             	sub    $0xc,%esp
 773:	b9 10 00 00 00       	mov    $0x10,%ecx
 778:	6a 00                	push   $0x0
 77a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	8b 13                	mov    (%ebx),%edx
 782:	e8 59 fe ff ff       	call   5e0 <printint>
 787:	89 d8                	mov    %ebx,%eax
 789:	83 c4 10             	add    $0x10,%esp
 78c:	31 d2                	xor    %edx,%edx
 78e:	83 c0 04             	add    $0x4,%eax
 791:	89 45 d0             	mov    %eax,-0x30(%ebp)
 794:	e9 4b ff ff ff       	jmp    6e4 <printf+0x54>
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7a8:	6a 01                	push   $0x1
 7aa:	eb ce                	jmp    77a <printf+0xea>
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7b3:	83 ec 04             	sub    $0x4,%esp
 7b6:	8b 03                	mov    (%ebx),%eax
 7b8:	6a 01                	push   $0x1
 7ba:	83 c3 04             	add    $0x4,%ebx
 7bd:	57                   	push   %edi
 7be:	ff 75 08             	pushl  0x8(%ebp)
 7c1:	88 45 e7             	mov    %al,-0x19(%ebp)
 7c4:	e8 5a fd ff ff       	call   523 <write>
 7c9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7cc:	83 c4 10             	add    $0x10,%esp
 7cf:	31 d2                	xor    %edx,%edx
 7d1:	e9 0e ff ff ff       	jmp    6e4 <printf+0x54>
 7d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
 7e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7e3:	83 ec 04             	sub    $0x4,%esp
 7e6:	e9 59 ff ff ff       	jmp    744 <printf+0xb4>
 7eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ef:	90                   	nop
 7f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7f3:	8b 18                	mov    (%eax),%ebx
 7f5:	83 c0 04             	add    $0x4,%eax
 7f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7fb:	85 db                	test   %ebx,%ebx
 7fd:	74 17                	je     816 <printf+0x186>
 7ff:	0f b6 03             	movzbl (%ebx),%eax
 802:	31 d2                	xor    %edx,%edx
 804:	84 c0                	test   %al,%al
 806:	0f 84 d8 fe ff ff    	je     6e4 <printf+0x54>
 80c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 80f:	89 de                	mov    %ebx,%esi
 811:	8b 5d 08             	mov    0x8(%ebp),%ebx
 814:	eb 1a                	jmp    830 <printf+0x1a0>
 816:	bb 4a 0b 00 00       	mov    $0xb4a,%ebx
 81b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 81e:	b8 28 00 00 00       	mov    $0x28,%eax
 823:	89 de                	mov    %ebx,%esi
 825:	8b 5d 08             	mov    0x8(%ebp),%ebx
 828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82f:	90                   	nop
 830:	83 ec 04             	sub    $0x4,%esp
 833:	83 c6 01             	add    $0x1,%esi
 836:	88 45 e7             	mov    %al,-0x19(%ebp)
 839:	6a 01                	push   $0x1
 83b:	57                   	push   %edi
 83c:	53                   	push   %ebx
 83d:	e8 e1 fc ff ff       	call   523 <write>
 842:	0f b6 06             	movzbl (%esi),%eax
 845:	83 c4 10             	add    $0x10,%esp
 848:	84 c0                	test   %al,%al
 84a:	75 e4                	jne    830 <printf+0x1a0>
 84c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 84f:	31 d2                	xor    %edx,%edx
 851:	e9 8e fe ff ff       	jmp    6e4 <printf+0x54>
 856:	66 90                	xchg   %ax,%ax
 858:	66 90                	xchg   %ax,%ax
 85a:	66 90                	xchg   %ax,%ax
 85c:	66 90                	xchg   %ax,%ax
 85e:	66 90                	xchg   %ax,%ax

00000860 <free>:
 860:	f3 0f 1e fb          	endbr32 
 864:	55                   	push   %ebp
 865:	a1 24 0e 00 00       	mov    0xe24,%eax
 86a:	89 e5                	mov    %esp,%ebp
 86c:	57                   	push   %edi
 86d:	56                   	push   %esi
 86e:	53                   	push   %ebx
 86f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 872:	8b 10                	mov    (%eax),%edx
 874:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 877:	39 c8                	cmp    %ecx,%eax
 879:	73 15                	jae    890 <free+0x30>
 87b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 87f:	90                   	nop
 880:	39 d1                	cmp    %edx,%ecx
 882:	72 14                	jb     898 <free+0x38>
 884:	39 d0                	cmp    %edx,%eax
 886:	73 10                	jae    898 <free+0x38>
 888:	89 d0                	mov    %edx,%eax
 88a:	8b 10                	mov    (%eax),%edx
 88c:	39 c8                	cmp    %ecx,%eax
 88e:	72 f0                	jb     880 <free+0x20>
 890:	39 d0                	cmp    %edx,%eax
 892:	72 f4                	jb     888 <free+0x28>
 894:	39 d1                	cmp    %edx,%ecx
 896:	73 f0                	jae    888 <free+0x28>
 898:	8b 73 fc             	mov    -0x4(%ebx),%esi
 89b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 89e:	39 fa                	cmp    %edi,%edx
 8a0:	74 1e                	je     8c0 <free+0x60>
 8a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
 8a5:	8b 50 04             	mov    0x4(%eax),%edx
 8a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8ab:	39 f1                	cmp    %esi,%ecx
 8ad:	74 28                	je     8d7 <free+0x77>
 8af:	89 08                	mov    %ecx,(%eax)
 8b1:	5b                   	pop    %ebx
 8b2:	a3 24 0e 00 00       	mov    %eax,0xe24
 8b7:	5e                   	pop    %esi
 8b8:	5f                   	pop    %edi
 8b9:	5d                   	pop    %ebp
 8ba:	c3                   	ret    
 8bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8bf:	90                   	nop
 8c0:	03 72 04             	add    0x4(%edx),%esi
 8c3:	89 73 fc             	mov    %esi,-0x4(%ebx)
 8c6:	8b 10                	mov    (%eax),%edx
 8c8:	8b 12                	mov    (%edx),%edx
 8ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
 8cd:	8b 50 04             	mov    0x4(%eax),%edx
 8d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8d3:	39 f1                	cmp    %esi,%ecx
 8d5:	75 d8                	jne    8af <free+0x4f>
 8d7:	03 53 fc             	add    -0x4(%ebx),%edx
 8da:	a3 24 0e 00 00       	mov    %eax,0xe24
 8df:	89 50 04             	mov    %edx,0x4(%eax)
 8e2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8e5:	89 10                	mov    %edx,(%eax)
 8e7:	5b                   	pop    %ebx
 8e8:	5e                   	pop    %esi
 8e9:	5f                   	pop    %edi
 8ea:	5d                   	pop    %ebp
 8eb:	c3                   	ret    
 8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008f0 <malloc>:
 8f0:	f3 0f 1e fb          	endbr32 
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	57                   	push   %edi
 8f8:	56                   	push   %esi
 8f9:	53                   	push   %ebx
 8fa:	83 ec 1c             	sub    $0x1c,%esp
 8fd:	8b 45 08             	mov    0x8(%ebp),%eax
 900:	8b 3d 24 0e 00 00    	mov    0xe24,%edi
 906:	8d 70 07             	lea    0x7(%eax),%esi
 909:	c1 ee 03             	shr    $0x3,%esi
 90c:	83 c6 01             	add    $0x1,%esi
 90f:	85 ff                	test   %edi,%edi
 911:	0f 84 a9 00 00 00    	je     9c0 <malloc+0xd0>
 917:	8b 07                	mov    (%edi),%eax
 919:	8b 48 04             	mov    0x4(%eax),%ecx
 91c:	39 f1                	cmp    %esi,%ecx
 91e:	73 6d                	jae    98d <malloc+0x9d>
 920:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 926:	bb 00 10 00 00       	mov    $0x1000,%ebx
 92b:	0f 43 de             	cmovae %esi,%ebx
 92e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 935:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 938:	eb 17                	jmp    951 <malloc+0x61>
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 940:	8b 10                	mov    (%eax),%edx
 942:	8b 4a 04             	mov    0x4(%edx),%ecx
 945:	39 f1                	cmp    %esi,%ecx
 947:	73 4f                	jae    998 <malloc+0xa8>
 949:	8b 3d 24 0e 00 00    	mov    0xe24,%edi
 94f:	89 d0                	mov    %edx,%eax
 951:	39 c7                	cmp    %eax,%edi
 953:	75 eb                	jne    940 <malloc+0x50>
 955:	83 ec 0c             	sub    $0xc,%esp
 958:	ff 75 e4             	pushl  -0x1c(%ebp)
 95b:	e8 2b fc ff ff       	call   58b <sbrk>
 960:	83 c4 10             	add    $0x10,%esp
 963:	83 f8 ff             	cmp    $0xffffffff,%eax
 966:	74 1b                	je     983 <malloc+0x93>
 968:	89 58 04             	mov    %ebx,0x4(%eax)
 96b:	83 ec 0c             	sub    $0xc,%esp
 96e:	83 c0 08             	add    $0x8,%eax
 971:	50                   	push   %eax
 972:	e8 e9 fe ff ff       	call   860 <free>
 977:	a1 24 0e 00 00       	mov    0xe24,%eax
 97c:	83 c4 10             	add    $0x10,%esp
 97f:	85 c0                	test   %eax,%eax
 981:	75 bd                	jne    940 <malloc+0x50>
 983:	8d 65 f4             	lea    -0xc(%ebp),%esp
 986:	31 c0                	xor    %eax,%eax
 988:	5b                   	pop    %ebx
 989:	5e                   	pop    %esi
 98a:	5f                   	pop    %edi
 98b:	5d                   	pop    %ebp
 98c:	c3                   	ret    
 98d:	89 c2                	mov    %eax,%edx
 98f:	89 f8                	mov    %edi,%eax
 991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 998:	39 ce                	cmp    %ecx,%esi
 99a:	74 54                	je     9f0 <malloc+0x100>
 99c:	29 f1                	sub    %esi,%ecx
 99e:	89 4a 04             	mov    %ecx,0x4(%edx)
 9a1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
 9a4:	89 72 04             	mov    %esi,0x4(%edx)
 9a7:	a3 24 0e 00 00       	mov    %eax,0xe24
 9ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9af:	8d 42 08             	lea    0x8(%edx),%eax
 9b2:	5b                   	pop    %ebx
 9b3:	5e                   	pop    %esi
 9b4:	5f                   	pop    %edi
 9b5:	5d                   	pop    %ebp
 9b6:	c3                   	ret    
 9b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9be:	66 90                	xchg   %ax,%ax
 9c0:	c7 05 24 0e 00 00 28 	movl   $0xe28,0xe24
 9c7:	0e 00 00 
 9ca:	bf 28 0e 00 00       	mov    $0xe28,%edi
 9cf:	c7 05 28 0e 00 00 28 	movl   $0xe28,0xe28
 9d6:	0e 00 00 
 9d9:	89 f8                	mov    %edi,%eax
 9db:	c7 05 2c 0e 00 00 00 	movl   $0x0,0xe2c
 9e2:	00 00 00 
 9e5:	e9 36 ff ff ff       	jmp    920 <malloc+0x30>
 9ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9f0:	8b 0a                	mov    (%edx),%ecx
 9f2:	89 08                	mov    %ecx,(%eax)
 9f4:	eb b1                	jmp    9a7 <malloc+0xb7>
