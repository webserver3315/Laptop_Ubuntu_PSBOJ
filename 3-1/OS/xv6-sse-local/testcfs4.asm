
_testcfs4:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
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
  15:	68 4d 08 00 00       	push   $0x84d
  1a:	6a 01                	push   $0x1
  1c:	e8 af 04 00 00       	call   4d0 <printf>
      test_p1_2();
  21:	e8 1a 00 00 00       	call   40 <test_p1_2>
      printf(1, "=== TEST   END ===\n");
  26:	58                   	pop    %eax
  27:	5a                   	pop    %edx
  28:	68 61 08 00 00       	push   $0x861
  2d:	6a 01                	push   $0x1
  2f:	e8 9c 04 00 00       	call   4d0 <printf>

      exit();
  34:	e8 0a 03 00 00       	call   343 <exit>
  39:	66 90                	xchg   %ax,%ax
  3b:	66 90                	xchg   %ax,%ax
  3d:	66 90                	xchg   %ax,%ax
  3f:	90                   	nop

00000040 <test_p1_2>:
{
  40:	f3 0f 1e fb          	endbr32 
  44:	55                   	push   %ebp
  45:	89 e5                	mov    %esp,%ebp
  47:	53                   	push   %ebx
  48:	83 ec 04             	sub    $0x4,%esp
   int pid = getpid();
  4b:	e8 73 03 00 00       	call   3c3 <getpid>
   printf(1, "1st pid: %d\n", pid);   
  50:	83 ec 04             	sub    $0x4,%esp
  53:	50                   	push   %eax
  54:	68 38 08 00 00       	push   $0x838
  59:	6a 01                	push   $0x1
  5b:	e8 70 04 00 00       	call   4d0 <printf>
   pid = fork();
  60:	e8 d6 02 00 00       	call   33b <fork>
   if(pid == 0){   //child
  65:	83 c4 10             	add    $0x10,%esp
  68:	85 c0                	test   %eax,%eax
  6a:	74 3f                	je     ab <test_p1_2+0x6b>
printf(1,"parent\n");
  6c:	83 ec 08             	sub    $0x8,%esp
  6f:	68 45 08 00 00       	push   $0x845
  74:	6a 01                	push   $0x1
  76:	e8 55 04 00 00       	call   4d0 <printf>
      ps();
  7b:	e8 8b 03 00 00       	call   40b <ps>
      sleep(500);
  80:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  87:	e8 47 03 00 00       	call   3d3 <sleep>
printf(1,"parent\n");
  8c:	58                   	pop    %eax
  8d:	5a                   	pop    %edx
  8e:	68 45 08 00 00       	push   $0x845
  93:	6a 01                	push   $0x1
  95:	e8 36 04 00 00       	call   4d0 <printf>
      ps();
  9a:	e8 6c 03 00 00       	call   40b <ps>
}
  9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      wait();
  a2:	83 c4 10             	add    $0x10,%esp
}
  a5:	c9                   	leave  
      wait();
  a6:	e9 a0 02 00 00       	jmp    34b <wait>
  ab:	bb 05 00 00 00       	mov    $0x5,%ebx
         for ( z = 0; z < 3000000.0; z += 0.1 )
  b0:	d9 ee                	fldz   
  b2:	dd 05 78 08 00 00    	fldl   0x878
  b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bf:	90                   	nop
  c0:	dc c1                	fadd   %st,%st(1)
  c2:	d9 05 80 08 00 00    	flds   0x880
  c8:	df f2                	fcomip %st(2),%st
  ca:	77 f4                	ja     c0 <test_p1_2+0x80>
  cc:	dd d8                	fstp   %st(0)
  ce:	dd d8                	fstp   %st(0)
         ps();
  d0:	e8 36 03 00 00       	call   40b <ps>
      for(i = 0; i < 5; i++){
  d5:	83 eb 01             	sub    $0x1,%ebx
  d8:	75 d6                	jne    b0 <test_p1_2+0x70>
      exit();
  da:	e8 64 02 00 00       	call   343 <exit>
  df:	90                   	nop

000000e0 <strcpy>:
  e0:	f3 0f 1e fb          	endbr32 
  e4:	55                   	push   %ebp
  e5:	31 c0                	xor    %eax,%eax
  e7:	89 e5                	mov    %esp,%ebp
  e9:	53                   	push   %ebx
  ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  f7:	83 c0 01             	add    $0x1,%eax
  fa:	84 d2                	test   %dl,%dl
  fc:	75 f2                	jne    f0 <strcpy+0x10>
  fe:	89 c8                	mov    %ecx,%eax
 100:	5b                   	pop    %ebx
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    
 103:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000110 <strcmp>:
 110:	f3 0f 1e fb          	endbr32 
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	53                   	push   %ebx
 118:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11b:	8b 55 0c             	mov    0xc(%ebp),%edx
 11e:	0f b6 01             	movzbl (%ecx),%eax
 121:	0f b6 1a             	movzbl (%edx),%ebx
 124:	84 c0                	test   %al,%al
 126:	75 19                	jne    141 <strcmp+0x31>
 128:	eb 26                	jmp    150 <strcmp+0x40>
 12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 130:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
 134:	83 c1 01             	add    $0x1,%ecx
 137:	83 c2 01             	add    $0x1,%edx
 13a:	0f b6 1a             	movzbl (%edx),%ebx
 13d:	84 c0                	test   %al,%al
 13f:	74 0f                	je     150 <strcmp+0x40>
 141:	38 d8                	cmp    %bl,%al
 143:	74 eb                	je     130 <strcmp+0x20>
 145:	29 d8                	sub    %ebx,%eax
 147:	5b                   	pop    %ebx
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 150:	31 c0                	xor    %eax,%eax
 152:	29 d8                	sub    %ebx,%eax
 154:	5b                   	pop    %ebx
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15e:	66 90                	xchg   %ax,%ax

00000160 <strlen>:
 160:	f3 0f 1e fb          	endbr32 
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	8b 55 08             	mov    0x8(%ebp),%edx
 16a:	80 3a 00             	cmpb   $0x0,(%edx)
 16d:	74 21                	je     190 <strlen+0x30>
 16f:	31 c0                	xor    %eax,%eax
 171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 178:	83 c0 01             	add    $0x1,%eax
 17b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 17f:	89 c1                	mov    %eax,%ecx
 181:	75 f5                	jne    178 <strlen+0x18>
 183:	89 c8                	mov    %ecx,%eax
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18e:	66 90                	xchg   %ax,%ax
 190:	31 c9                	xor    %ecx,%ecx
 192:	5d                   	pop    %ebp
 193:	89 c8                	mov    %ecx,%eax
 195:	c3                   	ret    
 196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <memset>:
 1a0:	f3 0f 1e fb          	endbr32 
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	57                   	push   %edi
 1a8:	8b 55 08             	mov    0x8(%ebp),%edx
 1ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b1:	89 d7                	mov    %edx,%edi
 1b3:	fc                   	cld    
 1b4:	f3 aa                	rep stos %al,%es:(%edi)
 1b6:	89 d0                	mov    %edx,%eax
 1b8:	5f                   	pop    %edi
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    
 1bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1bf:	90                   	nop

000001c0 <strchr>:
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 1ce:	0f b6 10             	movzbl (%eax),%edx
 1d1:	84 d2                	test   %dl,%dl
 1d3:	75 16                	jne    1eb <strchr+0x2b>
 1d5:	eb 21                	jmp    1f8 <strchr+0x38>
 1d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1de:	66 90                	xchg   %ax,%ax
 1e0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1e4:	83 c0 01             	add    $0x1,%eax
 1e7:	84 d2                	test   %dl,%dl
 1e9:	74 0d                	je     1f8 <strchr+0x38>
 1eb:	38 d1                	cmp    %dl,%cl
 1ed:	75 f1                	jne    1e0 <strchr+0x20>
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
 1f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1f8:	31 c0                	xor    %eax,%eax
 1fa:	5d                   	pop    %ebp
 1fb:	c3                   	ret    
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000200 <gets>:
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	57                   	push   %edi
 208:	56                   	push   %esi
 209:	31 f6                	xor    %esi,%esi
 20b:	53                   	push   %ebx
 20c:	89 f3                	mov    %esi,%ebx
 20e:	83 ec 1c             	sub    $0x1c,%esp
 211:	8b 7d 08             	mov    0x8(%ebp),%edi
 214:	eb 33                	jmp    249 <gets+0x49>
 216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21d:	8d 76 00             	lea    0x0(%esi),%esi
 220:	83 ec 04             	sub    $0x4,%esp
 223:	8d 45 e7             	lea    -0x19(%ebp),%eax
 226:	6a 01                	push   $0x1
 228:	50                   	push   %eax
 229:	6a 00                	push   $0x0
 22b:	e8 2b 01 00 00       	call   35b <read>
 230:	83 c4 10             	add    $0x10,%esp
 233:	85 c0                	test   %eax,%eax
 235:	7e 1c                	jle    253 <gets+0x53>
 237:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 23b:	83 c7 01             	add    $0x1,%edi
 23e:	88 47 ff             	mov    %al,-0x1(%edi)
 241:	3c 0a                	cmp    $0xa,%al
 243:	74 23                	je     268 <gets+0x68>
 245:	3c 0d                	cmp    $0xd,%al
 247:	74 1f                	je     268 <gets+0x68>
 249:	83 c3 01             	add    $0x1,%ebx
 24c:	89 fe                	mov    %edi,%esi
 24e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 251:	7c cd                	jl     220 <gets+0x20>
 253:	89 f3                	mov    %esi,%ebx
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	c6 03 00             	movb   $0x0,(%ebx)
 25b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 25e:	5b                   	pop    %ebx
 25f:	5e                   	pop    %esi
 260:	5f                   	pop    %edi
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 267:	90                   	nop
 268:	8b 75 08             	mov    0x8(%ebp),%esi
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	01 de                	add    %ebx,%esi
 270:	89 f3                	mov    %esi,%ebx
 272:	c6 03 00             	movb   $0x0,(%ebx)
 275:	8d 65 f4             	lea    -0xc(%ebp),%esp
 278:	5b                   	pop    %ebx
 279:	5e                   	pop    %esi
 27a:	5f                   	pop    %edi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi

00000280 <stat>:
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	56                   	push   %esi
 288:	53                   	push   %ebx
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	6a 00                	push   $0x0
 28e:	ff 75 08             	pushl  0x8(%ebp)
 291:	e8 ed 00 00 00       	call   383 <open>
 296:	83 c4 10             	add    $0x10,%esp
 299:	85 c0                	test   %eax,%eax
 29b:	78 2b                	js     2c8 <stat+0x48>
 29d:	83 ec 08             	sub    $0x8,%esp
 2a0:	ff 75 0c             	pushl  0xc(%ebp)
 2a3:	89 c3                	mov    %eax,%ebx
 2a5:	50                   	push   %eax
 2a6:	e8 f0 00 00 00       	call   39b <fstat>
 2ab:	89 1c 24             	mov    %ebx,(%esp)
 2ae:	89 c6                	mov    %eax,%esi
 2b0:	e8 b6 00 00 00       	call   36b <close>
 2b5:	83 c4 10             	add    $0x10,%esp
 2b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2bb:	89 f0                	mov    %esi,%eax
 2bd:	5b                   	pop    %ebx
 2be:	5e                   	pop    %esi
 2bf:	5d                   	pop    %ebp
 2c0:	c3                   	ret    
 2c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2cd:	eb e9                	jmp    2b8 <stat+0x38>
 2cf:	90                   	nop

000002d0 <atoi>:
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	53                   	push   %ebx
 2d8:	8b 55 08             	mov    0x8(%ebp),%edx
 2db:	0f be 02             	movsbl (%edx),%eax
 2de:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2e1:	80 f9 09             	cmp    $0x9,%cl
 2e4:	b9 00 00 00 00       	mov    $0x0,%ecx
 2e9:	77 1a                	ja     305 <atoi+0x35>
 2eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop
 2f0:	83 c2 01             	add    $0x1,%edx
 2f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
 2fa:	0f be 02             	movsbl (%edx),%eax
 2fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 300:	80 fb 09             	cmp    $0x9,%bl
 303:	76 eb                	jbe    2f0 <atoi+0x20>
 305:	89 c8                	mov    %ecx,%eax
 307:	5b                   	pop    %ebx
 308:	5d                   	pop    %ebp
 309:	c3                   	ret    
 30a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000310 <memmove>:
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	57                   	push   %edi
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	8b 55 08             	mov    0x8(%ebp),%edx
 31e:	56                   	push   %esi
 31f:	8b 75 0c             	mov    0xc(%ebp),%esi
 322:	85 c0                	test   %eax,%eax
 324:	7e 0f                	jle    335 <memmove+0x25>
 326:	01 d0                	add    %edx,%eax
 328:	89 d7                	mov    %edx,%edi
 32a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 330:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 331:	39 f8                	cmp    %edi,%eax
 333:	75 fb                	jne    330 <memmove+0x20>
 335:	5e                   	pop    %esi
 336:	89 d0                	mov    %edx,%eax
 338:	5f                   	pop    %edi
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret    

0000033b <fork>:
 33b:	b8 01 00 00 00       	mov    $0x1,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <exit>:
 343:	b8 02 00 00 00       	mov    $0x2,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <wait>:
 34b:	b8 03 00 00 00       	mov    $0x3,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <pipe>:
 353:	b8 04 00 00 00       	mov    $0x4,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <read>:
 35b:	b8 05 00 00 00       	mov    $0x5,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <write>:
 363:	b8 10 00 00 00       	mov    $0x10,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <close>:
 36b:	b8 15 00 00 00       	mov    $0x15,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <kill>:
 373:	b8 06 00 00 00       	mov    $0x6,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <exec>:
 37b:	b8 07 00 00 00       	mov    $0x7,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <open>:
 383:	b8 0f 00 00 00       	mov    $0xf,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <mknod>:
 38b:	b8 11 00 00 00       	mov    $0x11,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <unlink>:
 393:	b8 12 00 00 00       	mov    $0x12,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <fstat>:
 39b:	b8 08 00 00 00       	mov    $0x8,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <link>:
 3a3:	b8 13 00 00 00       	mov    $0x13,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <mkdir>:
 3ab:	b8 14 00 00 00       	mov    $0x14,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <chdir>:
 3b3:	b8 09 00 00 00       	mov    $0x9,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <dup>:
 3bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <getpid>:
 3c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <sbrk>:
 3cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <sleep>:
 3d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <uptime>:
 3db:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <swapread>:
 3e3:	b8 16 00 00 00       	mov    $0x16,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <swapwrite>:
 3eb:	b8 17 00 00 00       	mov    $0x17,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <setnice>:
 3f3:	b8 18 00 00 00       	mov    $0x18,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <getnice>:
 3fb:	b8 19 00 00 00       	mov    $0x19,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <yield>:
 403:	b8 1a 00 00 00       	mov    $0x1a,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <ps>:
 40b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    
 413:	66 90                	xchg   %ax,%ax
 415:	66 90                	xchg   %ax,%ax
 417:	66 90                	xchg   %ax,%ax
 419:	66 90                	xchg   %ax,%ax
 41b:	66 90                	xchg   %ax,%ax
 41d:	66 90                	xchg   %ax,%ax
 41f:	90                   	nop

00000420 <printint>:
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 3c             	sub    $0x3c,%esp
 429:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 42c:	89 d1                	mov    %edx,%ecx
 42e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 431:	85 d2                	test   %edx,%edx
 433:	0f 89 7f 00 00 00    	jns    4b8 <printint+0x98>
 439:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 43d:	74 79                	je     4b8 <printint+0x98>
 43f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
 446:	f7 d9                	neg    %ecx
 448:	31 db                	xor    %ebx,%ebx
 44a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	89 c8                	mov    %ecx,%eax
 452:	31 d2                	xor    %edx,%edx
 454:	89 cf                	mov    %ecx,%edi
 456:	f7 75 c4             	divl   -0x3c(%ebp)
 459:	0f b6 92 8c 08 00 00 	movzbl 0x88c(%edx),%edx
 460:	89 45 c0             	mov    %eax,-0x40(%ebp)
 463:	89 d8                	mov    %ebx,%eax
 465:	8d 5b 01             	lea    0x1(%ebx),%ebx
 468:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 46b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
 46e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 471:	76 dd                	jbe    450 <printint+0x30>
 473:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 476:	85 c9                	test   %ecx,%ecx
 478:	74 0c                	je     486 <printint+0x66>
 47a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 47f:	89 d8                	mov    %ebx,%eax
 481:	ba 2d 00 00 00       	mov    $0x2d,%edx
 486:	8b 7d b8             	mov    -0x48(%ebp),%edi
 489:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 48d:	eb 07                	jmp    496 <printint+0x76>
 48f:	90                   	nop
 490:	0f b6 13             	movzbl (%ebx),%edx
 493:	83 eb 01             	sub    $0x1,%ebx
 496:	83 ec 04             	sub    $0x4,%esp
 499:	88 55 d7             	mov    %dl,-0x29(%ebp)
 49c:	6a 01                	push   $0x1
 49e:	56                   	push   %esi
 49f:	57                   	push   %edi
 4a0:	e8 be fe ff ff       	call   363 <write>
 4a5:	83 c4 10             	add    $0x10,%esp
 4a8:	39 de                	cmp    %ebx,%esi
 4aa:	75 e4                	jne    490 <printint+0x70>
 4ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4af:	5b                   	pop    %ebx
 4b0:	5e                   	pop    %esi
 4b1:	5f                   	pop    %edi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4bf:	eb 87                	jmp    448 <printint+0x28>
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop

000004d0 <printf>:
 4d0:	f3 0f 1e fb          	endbr32 
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	57                   	push   %edi
 4d8:	56                   	push   %esi
 4d9:	53                   	push   %ebx
 4da:	83 ec 2c             	sub    $0x2c,%esp
 4dd:	8b 75 0c             	mov    0xc(%ebp),%esi
 4e0:	0f b6 1e             	movzbl (%esi),%ebx
 4e3:	84 db                	test   %bl,%bl
 4e5:	0f 84 b4 00 00 00    	je     59f <printf+0xcf>
 4eb:	8d 45 10             	lea    0x10(%ebp),%eax
 4ee:	83 c6 01             	add    $0x1,%esi
 4f1:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4f4:	31 d2                	xor    %edx,%edx
 4f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4f9:	eb 33                	jmp    52e <printf+0x5e>
 4fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4ff:	90                   	nop
 500:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 503:	ba 25 00 00 00       	mov    $0x25,%edx
 508:	83 f8 25             	cmp    $0x25,%eax
 50b:	74 17                	je     524 <printf+0x54>
 50d:	83 ec 04             	sub    $0x4,%esp
 510:	88 5d e7             	mov    %bl,-0x19(%ebp)
 513:	6a 01                	push   $0x1
 515:	57                   	push   %edi
 516:	ff 75 08             	pushl  0x8(%ebp)
 519:	e8 45 fe ff ff       	call   363 <write>
 51e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 521:	83 c4 10             	add    $0x10,%esp
 524:	0f b6 1e             	movzbl (%esi),%ebx
 527:	83 c6 01             	add    $0x1,%esi
 52a:	84 db                	test   %bl,%bl
 52c:	74 71                	je     59f <printf+0xcf>
 52e:	0f be cb             	movsbl %bl,%ecx
 531:	0f b6 c3             	movzbl %bl,%eax
 534:	85 d2                	test   %edx,%edx
 536:	74 c8                	je     500 <printf+0x30>
 538:	83 fa 25             	cmp    $0x25,%edx
 53b:	75 e7                	jne    524 <printf+0x54>
 53d:	83 f8 64             	cmp    $0x64,%eax
 540:	0f 84 9a 00 00 00    	je     5e0 <printf+0x110>
 546:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 54c:	83 f9 70             	cmp    $0x70,%ecx
 54f:	74 5f                	je     5b0 <printf+0xe0>
 551:	83 f8 73             	cmp    $0x73,%eax
 554:	0f 84 d6 00 00 00    	je     630 <printf+0x160>
 55a:	83 f8 63             	cmp    $0x63,%eax
 55d:	0f 84 8d 00 00 00    	je     5f0 <printf+0x120>
 563:	83 f8 25             	cmp    $0x25,%eax
 566:	0f 84 b4 00 00 00    	je     620 <printf+0x150>
 56c:	83 ec 04             	sub    $0x4,%esp
 56f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 573:	6a 01                	push   $0x1
 575:	57                   	push   %edi
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 e5 fd ff ff       	call   363 <write>
 57e:	88 5d e7             	mov    %bl,-0x19(%ebp)
 581:	83 c4 0c             	add    $0xc,%esp
 584:	6a 01                	push   $0x1
 586:	83 c6 01             	add    $0x1,%esi
 589:	57                   	push   %edi
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 d1 fd ff ff       	call   363 <write>
 592:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 596:	83 c4 10             	add    $0x10,%esp
 599:	31 d2                	xor    %edx,%edx
 59b:	84 db                	test   %bl,%bl
 59d:	75 8f                	jne    52e <printf+0x5e>
 59f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a2:	5b                   	pop    %ebx
 5a3:	5e                   	pop    %esi
 5a4:	5f                   	pop    %edi
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    
 5a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ae:	66 90                	xchg   %ax,%ax
 5b0:	83 ec 0c             	sub    $0xc,%esp
 5b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5b8:	6a 00                	push   $0x0
 5ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	8b 13                	mov    (%ebx),%edx
 5c2:	e8 59 fe ff ff       	call   420 <printint>
 5c7:	89 d8                	mov    %ebx,%eax
 5c9:	83 c4 10             	add    $0x10,%esp
 5cc:	31 d2                	xor    %edx,%edx
 5ce:	83 c0 04             	add    $0x4,%eax
 5d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5d4:	e9 4b ff ff ff       	jmp    524 <printf+0x54>
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5e8:	6a 01                	push   $0x1
 5ea:	eb ce                	jmp    5ba <printf+0xea>
 5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5f3:	83 ec 04             	sub    $0x4,%esp
 5f6:	8b 03                	mov    (%ebx),%eax
 5f8:	6a 01                	push   $0x1
 5fa:	83 c3 04             	add    $0x4,%ebx
 5fd:	57                   	push   %edi
 5fe:	ff 75 08             	pushl  0x8(%ebp)
 601:	88 45 e7             	mov    %al,-0x19(%ebp)
 604:	e8 5a fd ff ff       	call   363 <write>
 609:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 60c:	83 c4 10             	add    $0x10,%esp
 60f:	31 d2                	xor    %edx,%edx
 611:	e9 0e ff ff ff       	jmp    524 <printf+0x54>
 616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
 620:	88 5d e7             	mov    %bl,-0x19(%ebp)
 623:	83 ec 04             	sub    $0x4,%esp
 626:	e9 59 ff ff ff       	jmp    584 <printf+0xb4>
 62b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
 630:	8b 45 d0             	mov    -0x30(%ebp),%eax
 633:	8b 18                	mov    (%eax),%ebx
 635:	83 c0 04             	add    $0x4,%eax
 638:	89 45 d0             	mov    %eax,-0x30(%ebp)
 63b:	85 db                	test   %ebx,%ebx
 63d:	74 17                	je     656 <printf+0x186>
 63f:	0f b6 03             	movzbl (%ebx),%eax
 642:	31 d2                	xor    %edx,%edx
 644:	84 c0                	test   %al,%al
 646:	0f 84 d8 fe ff ff    	je     524 <printf+0x54>
 64c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 64f:	89 de                	mov    %ebx,%esi
 651:	8b 5d 08             	mov    0x8(%ebp),%ebx
 654:	eb 1a                	jmp    670 <printf+0x1a0>
 656:	bb 84 08 00 00       	mov    $0x884,%ebx
 65b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 65e:	b8 28 00 00 00       	mov    $0x28,%eax
 663:	89 de                	mov    %ebx,%esi
 665:	8b 5d 08             	mov    0x8(%ebp),%ebx
 668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop
 670:	83 ec 04             	sub    $0x4,%esp
 673:	83 c6 01             	add    $0x1,%esi
 676:	88 45 e7             	mov    %al,-0x19(%ebp)
 679:	6a 01                	push   $0x1
 67b:	57                   	push   %edi
 67c:	53                   	push   %ebx
 67d:	e8 e1 fc ff ff       	call   363 <write>
 682:	0f b6 06             	movzbl (%esi),%eax
 685:	83 c4 10             	add    $0x10,%esp
 688:	84 c0                	test   %al,%al
 68a:	75 e4                	jne    670 <printf+0x1a0>
 68c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 68f:	31 d2                	xor    %edx,%edx
 691:	e9 8e fe ff ff       	jmp    524 <printf+0x54>
 696:	66 90                	xchg   %ax,%ax
 698:	66 90                	xchg   %ax,%ax
 69a:	66 90                	xchg   %ax,%ax
 69c:	66 90                	xchg   %ax,%ax
 69e:	66 90                	xchg   %ax,%ax

000006a0 <free>:
 6a0:	f3 0f 1e fb          	endbr32 
 6a4:	55                   	push   %ebp
 6a5:	a1 5c 0b 00 00       	mov    0xb5c,%eax
 6aa:	89 e5                	mov    %esp,%ebp
 6ac:	57                   	push   %edi
 6ad:	56                   	push   %esi
 6ae:	53                   	push   %ebx
 6af:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 6b7:	39 c8                	cmp    %ecx,%eax
 6b9:	73 15                	jae    6d0 <free+0x30>
 6bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop
 6c0:	39 d1                	cmp    %edx,%ecx
 6c2:	72 14                	jb     6d8 <free+0x38>
 6c4:	39 d0                	cmp    %edx,%eax
 6c6:	73 10                	jae    6d8 <free+0x38>
 6c8:	89 d0                	mov    %edx,%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	39 c8                	cmp    %ecx,%eax
 6ce:	72 f0                	jb     6c0 <free+0x20>
 6d0:	39 d0                	cmp    %edx,%eax
 6d2:	72 f4                	jb     6c8 <free+0x28>
 6d4:	39 d1                	cmp    %edx,%ecx
 6d6:	73 f0                	jae    6c8 <free+0x28>
 6d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6de:	39 fa                	cmp    %edi,%edx
 6e0:	74 1e                	je     700 <free+0x60>
 6e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6e5:	8b 50 04             	mov    0x4(%eax),%edx
 6e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6eb:	39 f1                	cmp    %esi,%ecx
 6ed:	74 28                	je     717 <free+0x77>
 6ef:	89 08                	mov    %ecx,(%eax)
 6f1:	5b                   	pop    %ebx
 6f2:	a3 5c 0b 00 00       	mov    %eax,0xb5c
 6f7:	5e                   	pop    %esi
 6f8:	5f                   	pop    %edi
 6f9:	5d                   	pop    %ebp
 6fa:	c3                   	ret    
 6fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ff:	90                   	nop
 700:	03 72 04             	add    0x4(%edx),%esi
 703:	89 73 fc             	mov    %esi,-0x4(%ebx)
 706:	8b 10                	mov    (%eax),%edx
 708:	8b 12                	mov    (%edx),%edx
 70a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 713:	39 f1                	cmp    %esi,%ecx
 715:	75 d8                	jne    6ef <free+0x4f>
 717:	03 53 fc             	add    -0x4(%ebx),%edx
 71a:	a3 5c 0b 00 00       	mov    %eax,0xb5c
 71f:	89 50 04             	mov    %edx,0x4(%eax)
 722:	8b 53 f8             	mov    -0x8(%ebx),%edx
 725:	89 10                	mov    %edx,(%eax)
 727:	5b                   	pop    %ebx
 728:	5e                   	pop    %esi
 729:	5f                   	pop    %edi
 72a:	5d                   	pop    %ebp
 72b:	c3                   	ret    
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <malloc>:
 730:	f3 0f 1e fb          	endbr32 
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	57                   	push   %edi
 738:	56                   	push   %esi
 739:	53                   	push   %ebx
 73a:	83 ec 1c             	sub    $0x1c,%esp
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
 740:	8b 3d 5c 0b 00 00    	mov    0xb5c,%edi
 746:	8d 70 07             	lea    0x7(%eax),%esi
 749:	c1 ee 03             	shr    $0x3,%esi
 74c:	83 c6 01             	add    $0x1,%esi
 74f:	85 ff                	test   %edi,%edi
 751:	0f 84 a9 00 00 00    	je     800 <malloc+0xd0>
 757:	8b 07                	mov    (%edi),%eax
 759:	8b 48 04             	mov    0x4(%eax),%ecx
 75c:	39 f1                	cmp    %esi,%ecx
 75e:	73 6d                	jae    7cd <malloc+0x9d>
 760:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 766:	bb 00 10 00 00       	mov    $0x1000,%ebx
 76b:	0f 43 de             	cmovae %esi,%ebx
 76e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 775:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 778:	eb 17                	jmp    791 <malloc+0x61>
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 780:	8b 10                	mov    (%eax),%edx
 782:	8b 4a 04             	mov    0x4(%edx),%ecx
 785:	39 f1                	cmp    %esi,%ecx
 787:	73 4f                	jae    7d8 <malloc+0xa8>
 789:	8b 3d 5c 0b 00 00    	mov    0xb5c,%edi
 78f:	89 d0                	mov    %edx,%eax
 791:	39 c7                	cmp    %eax,%edi
 793:	75 eb                	jne    780 <malloc+0x50>
 795:	83 ec 0c             	sub    $0xc,%esp
 798:	ff 75 e4             	pushl  -0x1c(%ebp)
 79b:	e8 2b fc ff ff       	call   3cb <sbrk>
 7a0:	83 c4 10             	add    $0x10,%esp
 7a3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7a6:	74 1b                	je     7c3 <malloc+0x93>
 7a8:	89 58 04             	mov    %ebx,0x4(%eax)
 7ab:	83 ec 0c             	sub    $0xc,%esp
 7ae:	83 c0 08             	add    $0x8,%eax
 7b1:	50                   	push   %eax
 7b2:	e8 e9 fe ff ff       	call   6a0 <free>
 7b7:	a1 5c 0b 00 00       	mov    0xb5c,%eax
 7bc:	83 c4 10             	add    $0x10,%esp
 7bf:	85 c0                	test   %eax,%eax
 7c1:	75 bd                	jne    780 <malloc+0x50>
 7c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7c6:	31 c0                	xor    %eax,%eax
 7c8:	5b                   	pop    %ebx
 7c9:	5e                   	pop    %esi
 7ca:	5f                   	pop    %edi
 7cb:	5d                   	pop    %ebp
 7cc:	c3                   	ret    
 7cd:	89 c2                	mov    %eax,%edx
 7cf:	89 f8                	mov    %edi,%eax
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7d8:	39 ce                	cmp    %ecx,%esi
 7da:	74 54                	je     830 <malloc+0x100>
 7dc:	29 f1                	sub    %esi,%ecx
 7de:	89 4a 04             	mov    %ecx,0x4(%edx)
 7e1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
 7e4:	89 72 04             	mov    %esi,0x4(%edx)
 7e7:	a3 5c 0b 00 00       	mov    %eax,0xb5c
 7ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7ef:	8d 42 08             	lea    0x8(%edx),%eax
 7f2:	5b                   	pop    %ebx
 7f3:	5e                   	pop    %esi
 7f4:	5f                   	pop    %edi
 7f5:	5d                   	pop    %ebp
 7f6:	c3                   	ret    
 7f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7fe:	66 90                	xchg   %ax,%ax
 800:	c7 05 5c 0b 00 00 60 	movl   $0xb60,0xb5c
 807:	0b 00 00 
 80a:	bf 60 0b 00 00       	mov    $0xb60,%edi
 80f:	c7 05 60 0b 00 00 60 	movl   $0xb60,0xb60
 816:	0b 00 00 
 819:	89 f8                	mov    %edi,%eax
 81b:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 822:	00 00 00 
 825:	e9 36 ff ff ff       	jmp    760 <malloc+0x30>
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 830:	8b 0a                	mov    (%edx),%ecx
 832:	89 08                	mov    %ecx,(%eax)
 834:	eb b1                	jmp    7e7 <malloc+0xb7>
