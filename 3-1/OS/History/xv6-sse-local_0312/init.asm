
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 02                	push   $0x2
  18:	68 58 08 00 00       	push   $0x858
  1d:	e8 a1 03 00 00       	call   3c3 <open>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	0f 88 cb 00 00 00    	js     f8 <main+0xf8>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  2d:	83 ec 0c             	sub    $0xc,%esp
  30:	6a 00                	push   $0x0
  32:	e8 c4 03 00 00       	call   3fb <dup>
  dup(0);  // stderr
  37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3e:	e8 b8 03 00 00       	call   3fb <dup>
  43:	83 c4 10             	add    $0x10,%esp
  46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4d:	8d 76 00             	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  50:	83 ec 08             	sub    $0x8,%esp
  53:	68 60 08 00 00       	push   $0x860
  58:	6a 01                	push   $0x1
  5a:	e8 91 04 00 00       	call   4f0 <printf>
    printf(1, "Student ID: 2017313213\n");
  5f:	58                   	pop    %eax
  60:	5a                   	pop    %edx
  61:	68 73 08 00 00       	push   $0x873
  66:	6a 01                	push   $0x1
  68:	e8 83 04 00 00       	call   4f0 <printf>
    printf(1, "Name: Kyeongtae Park\n");
  6d:	59                   	pop    %ecx
  6e:	5b                   	pop    %ebx
  6f:	68 8b 08 00 00       	push   $0x88b
  74:	6a 01                	push   $0x1
  76:	e8 75 04 00 00       	call   4f0 <printf>
    printf(1, "========Any Message==========\n");
  7b:	58                   	pop    %eax
  7c:	5a                   	pop    %edx
  7d:	68 d8 08 00 00       	push   $0x8d8
  82:	6a 01                	push   $0x1
  84:	e8 67 04 00 00       	call   4f0 <printf>
    pid = fork();
  89:	e8 ed 02 00 00       	call   37b <fork>
    if(pid < 0){
  8e:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  91:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  93:	85 c0                	test   %eax,%eax
  95:	78 2a                	js     c1 <main+0xc1>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  97:	74 3b                	je     d4 <main+0xd4>
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  a0:	e8 e6 02 00 00       	call   38b <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	78 a7                	js     50 <main+0x50>
  a9:	39 c3                	cmp    %eax,%ebx
  ab:	74 a3                	je     50 <main+0x50>
      printf(1, "zombie!\n");
  ad:	83 ec 08             	sub    $0x8,%esp
  b0:	68 cd 08 00 00       	push   $0x8cd
  b5:	6a 01                	push   $0x1
  b7:	e8 34 04 00 00       	call   4f0 <printf>
  bc:	83 c4 10             	add    $0x10,%esp
  bf:	eb df                	jmp    a0 <main+0xa0>
      printf(1, "init: fork failed\n");
  c1:	53                   	push   %ebx
  c2:	53                   	push   %ebx
  c3:	68 a1 08 00 00       	push   $0x8a1
  c8:	6a 01                	push   $0x1
  ca:	e8 21 04 00 00       	call   4f0 <printf>
      exit();
  cf:	e8 af 02 00 00       	call   383 <exit>
      exec("sh", argv);
  d4:	50                   	push   %eax
  d5:	50                   	push   %eax
  d6:	68 ac 0b 00 00       	push   $0xbac
  db:	68 b4 08 00 00       	push   $0x8b4
  e0:	e8 d6 02 00 00       	call   3bb <exec>
      printf(1, "init: exec sh failed\n");
  e5:	5a                   	pop    %edx
  e6:	59                   	pop    %ecx
  e7:	68 b7 08 00 00       	push   $0x8b7
  ec:	6a 01                	push   $0x1
  ee:	e8 fd 03 00 00       	call   4f0 <printf>
      exit();
  f3:	e8 8b 02 00 00       	call   383 <exit>
    mknod("console", 1, 1);
  f8:	51                   	push   %ecx
  f9:	6a 01                	push   $0x1
  fb:	6a 01                	push   $0x1
  fd:	68 58 08 00 00       	push   $0x858
 102:	e8 c4 02 00 00       	call   3cb <mknod>
    open("console", O_RDWR);
 107:	5b                   	pop    %ebx
 108:	58                   	pop    %eax
 109:	6a 02                	push   $0x2
 10b:	68 58 08 00 00       	push   $0x858
 110:	e8 ae 02 00 00       	call   3c3 <open>
 115:	83 c4 10             	add    $0x10,%esp
 118:	e9 10 ff ff ff       	jmp    2d <main+0x2d>
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 125:	31 c0                	xor    %eax,%eax
{
 127:	89 e5                	mov    %esp,%ebp
 129:	53                   	push   %ebx
 12a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 12d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 130:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 134:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 137:	83 c0 01             	add    $0x1,%eax
 13a:	84 d2                	test   %dl,%dl
 13c:	75 f2                	jne    130 <strcpy+0x10>
    ;
  return os;
}
 13e:	89 c8                	mov    %ecx,%eax
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	f3 0f 1e fb          	endbr32 
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	53                   	push   %ebx
 158:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 15e:	0f b6 01             	movzbl (%ecx),%eax
 161:	0f b6 1a             	movzbl (%edx),%ebx
 164:	84 c0                	test   %al,%al
 166:	75 19                	jne    181 <strcmp+0x31>
 168:	eb 26                	jmp    190 <strcmp+0x40>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 170:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 174:	83 c1 01             	add    $0x1,%ecx
 177:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 17a:	0f b6 1a             	movzbl (%edx),%ebx
 17d:	84 c0                	test   %al,%al
 17f:	74 0f                	je     190 <strcmp+0x40>
 181:	38 d8                	cmp    %bl,%al
 183:	74 eb                	je     170 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 185:	29 d8                	sub    %ebx,%eax
}
 187:	5b                   	pop    %ebx
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 190:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 192:	29 d8                	sub    %ebx,%eax
}
 194:	5b                   	pop    %ebx
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19e:	66 90                	xchg   %ax,%ax

000001a0 <strlen>:

uint
strlen(const char *s)
{
 1a0:	f3 0f 1e fb          	endbr32 
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1aa:	80 3a 00             	cmpb   $0x0,(%edx)
 1ad:	74 21                	je     1d0 <strlen+0x30>
 1af:	31 c0                	xor    %eax,%eax
 1b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b8:	83 c0 01             	add    $0x1,%eax
 1bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1bf:	89 c1                	mov    %eax,%ecx
 1c1:	75 f5                	jne    1b8 <strlen+0x18>
    ;
  return n;
}
 1c3:	89 c8                	mov    %ecx,%eax
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ce:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 1d0:	31 c9                	xor    %ecx,%ecx
}
 1d2:	5d                   	pop    %ebp
 1d3:	89 c8                	mov    %ecx,%eax
 1d5:	c3                   	ret    
 1d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1dd:	8d 76 00             	lea    0x0(%esi),%esi

000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	f3 0f 1e fb          	endbr32 
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	57                   	push   %edi
 1e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f1:	89 d7                	mov    %edx,%edi
 1f3:	fc                   	cld    
 1f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f6:	89 d0                	mov    %edx,%eax
 1f8:	5f                   	pop    %edi
 1f9:	5d                   	pop    %ebp
 1fa:	c3                   	ret    
 1fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop

00000200 <strchr>:

char*
strchr(const char *s, char c)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 20e:	0f b6 10             	movzbl (%eax),%edx
 211:	84 d2                	test   %dl,%dl
 213:	75 16                	jne    22b <strchr+0x2b>
 215:	eb 21                	jmp    238 <strchr+0x38>
 217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21e:	66 90                	xchg   %ax,%ax
 220:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 224:	83 c0 01             	add    $0x1,%eax
 227:	84 d2                	test   %dl,%dl
 229:	74 0d                	je     238 <strchr+0x38>
    if(*s == c)
 22b:	38 d1                	cmp    %dl,%cl
 22d:	75 f1                	jne    220 <strchr+0x20>
      return (char*)s;
  return 0;
}
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    
 231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 238:	31 c0                	xor    %eax,%eax
}
 23a:	5d                   	pop    %ebp
 23b:	c3                   	ret    
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	57                   	push   %edi
 248:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 249:	31 f6                	xor    %esi,%esi
{
 24b:	53                   	push   %ebx
 24c:	89 f3                	mov    %esi,%ebx
 24e:	83 ec 1c             	sub    $0x1c,%esp
 251:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 254:	eb 33                	jmp    289 <gets+0x49>
 256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 260:	83 ec 04             	sub    $0x4,%esp
 263:	8d 45 e7             	lea    -0x19(%ebp),%eax
 266:	6a 01                	push   $0x1
 268:	50                   	push   %eax
 269:	6a 00                	push   $0x0
 26b:	e8 2b 01 00 00       	call   39b <read>
    if(cc < 1)
 270:	83 c4 10             	add    $0x10,%esp
 273:	85 c0                	test   %eax,%eax
 275:	7e 1c                	jle    293 <gets+0x53>
      break;
    buf[i++] = c;
 277:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 27b:	83 c7 01             	add    $0x1,%edi
 27e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 281:	3c 0a                	cmp    $0xa,%al
 283:	74 23                	je     2a8 <gets+0x68>
 285:	3c 0d                	cmp    $0xd,%al
 287:	74 1f                	je     2a8 <gets+0x68>
  for(i=0; i+1 < max; ){
 289:	83 c3 01             	add    $0x1,%ebx
 28c:	89 fe                	mov    %edi,%esi
 28e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 291:	7c cd                	jl     260 <gets+0x20>
 293:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 295:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 298:	c6 03 00             	movb   $0x0,(%ebx)
}
 29b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 29e:	5b                   	pop    %ebx
 29f:	5e                   	pop    %esi
 2a0:	5f                   	pop    %edi
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    
 2a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a7:	90                   	nop
 2a8:	8b 75 08             	mov    0x8(%ebp),%esi
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	01 de                	add    %ebx,%esi
 2b0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2b2:	c6 03 00             	movb   $0x0,(%ebx)
}
 2b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2b8:	5b                   	pop    %ebx
 2b9:	5e                   	pop    %esi
 2ba:	5f                   	pop    %edi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	8d 76 00             	lea    0x0(%esi),%esi

000002c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c0:	f3 0f 1e fb          	endbr32 
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	56                   	push   %esi
 2c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	6a 00                	push   $0x0
 2ce:	ff 75 08             	pushl  0x8(%ebp)
 2d1:	e8 ed 00 00 00       	call   3c3 <open>
  if(fd < 0)
 2d6:	83 c4 10             	add    $0x10,%esp
 2d9:	85 c0                	test   %eax,%eax
 2db:	78 2b                	js     308 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2dd:	83 ec 08             	sub    $0x8,%esp
 2e0:	ff 75 0c             	pushl  0xc(%ebp)
 2e3:	89 c3                	mov    %eax,%ebx
 2e5:	50                   	push   %eax
 2e6:	e8 f0 00 00 00       	call   3db <fstat>
  close(fd);
 2eb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ee:	89 c6                	mov    %eax,%esi
  close(fd);
 2f0:	e8 b6 00 00 00       	call   3ab <close>
  return r;
 2f5:	83 c4 10             	add    $0x10,%esp
}
 2f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2fb:	89 f0                	mov    %esi,%eax
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 308:	be ff ff ff ff       	mov    $0xffffffff,%esi
 30d:	eb e9                	jmp    2f8 <stat+0x38>
 30f:	90                   	nop

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	53                   	push   %ebx
 318:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31b:	0f be 02             	movsbl (%edx),%eax
 31e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 321:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 324:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 329:	77 1a                	ja     345 <atoi+0x35>
 32b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 32f:	90                   	nop
    n = n*10 + *s++ - '0';
 330:	83 c2 01             	add    $0x1,%edx
 333:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 336:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 33a:	0f be 02             	movsbl (%edx),%eax
 33d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 340:	80 fb 09             	cmp    $0x9,%bl
 343:	76 eb                	jbe    330 <atoi+0x20>
  return n;
}
 345:	89 c8                	mov    %ecx,%eax
 347:	5b                   	pop    %ebx
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	8b 45 10             	mov    0x10(%ebp),%eax
 35b:	8b 55 08             	mov    0x8(%ebp),%edx
 35e:	56                   	push   %esi
 35f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 362:	85 c0                	test   %eax,%eax
 364:	7e 0f                	jle    375 <memmove+0x25>
 366:	01 d0                	add    %edx,%eax
  dst = vdst;
 368:	89 d7                	mov    %edx,%edi
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 370:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 371:	39 f8                	cmp    %edi,%eax
 373:	75 fb                	jne    370 <memmove+0x20>
  return vdst;
}
 375:	5e                   	pop    %esi
 376:	89 d0                	mov    %edx,%eax
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    

0000037b <fork>:
 37b:	b8 01 00 00 00       	mov    $0x1,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <exit>:
 383:	b8 02 00 00 00       	mov    $0x2,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <wait>:
 38b:	b8 03 00 00 00       	mov    $0x3,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <pipe>:
 393:	b8 04 00 00 00       	mov    $0x4,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <read>:
 39b:	b8 05 00 00 00       	mov    $0x5,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <write>:
 3a3:	b8 10 00 00 00       	mov    $0x10,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <close>:
 3ab:	b8 15 00 00 00       	mov    $0x15,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <kill>:
 3b3:	b8 06 00 00 00       	mov    $0x6,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <exec>:
 3bb:	b8 07 00 00 00       	mov    $0x7,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <open>:
 3c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mknod>:
 3cb:	b8 11 00 00 00       	mov    $0x11,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <unlink>:
 3d3:	b8 12 00 00 00       	mov    $0x12,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <fstat>:
 3db:	b8 08 00 00 00       	mov    $0x8,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <link>:
 3e3:	b8 13 00 00 00       	mov    $0x13,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mkdir>:
 3eb:	b8 14 00 00 00       	mov    $0x14,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <chdir>:
 3f3:	b8 09 00 00 00       	mov    $0x9,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <dup>:
 3fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <getpid>:
 403:	b8 0b 00 00 00       	mov    $0xb,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <sbrk>:
 40b:	b8 0c 00 00 00       	mov    $0xc,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <sleep>:
 413:	b8 0d 00 00 00       	mov    $0xd,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <uptime>:
 41b:	b8 0e 00 00 00       	mov    $0xe,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <swapread>:
 423:	b8 16 00 00 00       	mov    $0x16,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <swapwrite>:
 42b:	b8 17 00 00 00       	mov    $0x17,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    
 433:	66 90                	xchg   %ax,%ax
 435:	66 90                	xchg   %ax,%ax
 437:	66 90                	xchg   %ax,%ax
 439:	66 90                	xchg   %ax,%ax
 43b:	66 90                	xchg   %ax,%ax
 43d:	66 90                	xchg   %ax,%ax
 43f:	90                   	nop

00000440 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 3c             	sub    $0x3c,%esp
 449:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 44c:	89 d1                	mov    %edx,%ecx
{
 44e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 451:	85 d2                	test   %edx,%edx
 453:	0f 89 7f 00 00 00    	jns    4d8 <printint+0x98>
 459:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 45d:	74 79                	je     4d8 <printint+0x98>
    neg = 1;
 45f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 466:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 468:	31 db                	xor    %ebx,%ebx
 46a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 470:	89 c8                	mov    %ecx,%eax
 472:	31 d2                	xor    %edx,%edx
 474:	89 cf                	mov    %ecx,%edi
 476:	f7 75 c4             	divl   -0x3c(%ebp)
 479:	0f b6 92 00 09 00 00 	movzbl 0x900(%edx),%edx
 480:	89 45 c0             	mov    %eax,-0x40(%ebp)
 483:	89 d8                	mov    %ebx,%eax
 485:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 488:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 48b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 48e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 491:	76 dd                	jbe    470 <printint+0x30>
  if(neg)
 493:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 496:	85 c9                	test   %ecx,%ecx
 498:	74 0c                	je     4a6 <printint+0x66>
    buf[i++] = '-';
 49a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 49f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4ad:	eb 07                	jmp    4b6 <printint+0x76>
 4af:	90                   	nop
 4b0:	0f b6 13             	movzbl (%ebx),%edx
 4b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4b6:	83 ec 04             	sub    $0x4,%esp
 4b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4bc:	6a 01                	push   $0x1
 4be:	56                   	push   %esi
 4bf:	57                   	push   %edi
 4c0:	e8 de fe ff ff       	call   3a3 <write>
  while(--i >= 0)
 4c5:	83 c4 10             	add    $0x10,%esp
 4c8:	39 de                	cmp    %ebx,%esi
 4ca:	75 e4                	jne    4b0 <printint+0x70>
    putc(fd, buf[i]);
}
 4cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cf:	5b                   	pop    %ebx
 4d0:	5e                   	pop    %esi
 4d1:	5f                   	pop    %edi
 4d2:	5d                   	pop    %ebp
 4d3:	c3                   	ret    
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4df:	eb 87                	jmp    468 <printint+0x28>
 4e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop

000004f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4f0:	f3 0f 1e fb          	endbr32 
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	57                   	push   %edi
 4f8:	56                   	push   %esi
 4f9:	53                   	push   %ebx
 4fa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4fd:	8b 75 0c             	mov    0xc(%ebp),%esi
 500:	0f b6 1e             	movzbl (%esi),%ebx
 503:	84 db                	test   %bl,%bl
 505:	0f 84 b4 00 00 00    	je     5bf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 50b:	8d 45 10             	lea    0x10(%ebp),%eax
 50e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 511:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 514:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 516:	89 45 d0             	mov    %eax,-0x30(%ebp)
 519:	eb 33                	jmp    54e <printf+0x5e>
 51b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 51f:	90                   	nop
 520:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 523:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 528:	83 f8 25             	cmp    $0x25,%eax
 52b:	74 17                	je     544 <printf+0x54>
  write(fd, &c, 1);
 52d:	83 ec 04             	sub    $0x4,%esp
 530:	88 5d e7             	mov    %bl,-0x19(%ebp)
 533:	6a 01                	push   $0x1
 535:	57                   	push   %edi
 536:	ff 75 08             	pushl  0x8(%ebp)
 539:	e8 65 fe ff ff       	call   3a3 <write>
 53e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 541:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 544:	0f b6 1e             	movzbl (%esi),%ebx
 547:	83 c6 01             	add    $0x1,%esi
 54a:	84 db                	test   %bl,%bl
 54c:	74 71                	je     5bf <printf+0xcf>
    c = fmt[i] & 0xff;
 54e:	0f be cb             	movsbl %bl,%ecx
 551:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 554:	85 d2                	test   %edx,%edx
 556:	74 c8                	je     520 <printf+0x30>
      }
    } else if(state == '%'){
 558:	83 fa 25             	cmp    $0x25,%edx
 55b:	75 e7                	jne    544 <printf+0x54>
      if(c == 'd'){
 55d:	83 f8 64             	cmp    $0x64,%eax
 560:	0f 84 9a 00 00 00    	je     600 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 566:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 56c:	83 f9 70             	cmp    $0x70,%ecx
 56f:	74 5f                	je     5d0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 571:	83 f8 73             	cmp    $0x73,%eax
 574:	0f 84 d6 00 00 00    	je     650 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57a:	83 f8 63             	cmp    $0x63,%eax
 57d:	0f 84 8d 00 00 00    	je     610 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 583:	83 f8 25             	cmp    $0x25,%eax
 586:	0f 84 b4 00 00 00    	je     640 <printf+0x150>
  write(fd, &c, 1);
 58c:	83 ec 04             	sub    $0x4,%esp
 58f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 593:	6a 01                	push   $0x1
 595:	57                   	push   %edi
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 05 fe ff ff       	call   3a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 59e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5a1:	83 c4 0c             	add    $0xc,%esp
 5a4:	6a 01                	push   $0x1
 5a6:	83 c6 01             	add    $0x1,%esi
 5a9:	57                   	push   %edi
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 f1 fd ff ff       	call   3a3 <write>
  for(i = 0; fmt[i]; i++){
 5b2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 5b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5b9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5bb:	84 db                	test   %bl,%bl
 5bd:	75 8f                	jne    54e <printf+0x5e>
    }
  }
}
 5bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c2:	5b                   	pop    %ebx
 5c3:	5e                   	pop    %esi
 5c4:	5f                   	pop    %edi
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    
 5c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 5d0:	83 ec 0c             	sub    $0xc,%esp
 5d3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5d8:	6a 00                	push   $0x0
 5da:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	8b 13                	mov    (%ebx),%edx
 5e2:	e8 59 fe ff ff       	call   440 <printint>
        ap++;
 5e7:	89 d8                	mov    %ebx,%eax
 5e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ec:	31 d2                	xor    %edx,%edx
        ap++;
 5ee:	83 c0 04             	add    $0x4,%eax
 5f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5f4:	e9 4b ff ff ff       	jmp    544 <printf+0x54>
 5f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
 608:	6a 01                	push   $0x1
 60a:	eb ce                	jmp    5da <printf+0xea>
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 610:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 613:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 616:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 618:	6a 01                	push   $0x1
        ap++;
 61a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 61d:	57                   	push   %edi
 61e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 621:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 624:	e8 7a fd ff ff       	call   3a3 <write>
        ap++;
 629:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 62c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62f:	31 d2                	xor    %edx,%edx
 631:	e9 0e ff ff ff       	jmp    544 <printf+0x54>
 636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 640:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 643:	83 ec 04             	sub    $0x4,%esp
 646:	e9 59 ff ff ff       	jmp    5a4 <printf+0xb4>
 64b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop
        s = (char*)*ap;
 650:	8b 45 d0             	mov    -0x30(%ebp),%eax
 653:	8b 18                	mov    (%eax),%ebx
        ap++;
 655:	83 c0 04             	add    $0x4,%eax
 658:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 65b:	85 db                	test   %ebx,%ebx
 65d:	74 17                	je     676 <printf+0x186>
        while(*s != 0){
 65f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 662:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 664:	84 c0                	test   %al,%al
 666:	0f 84 d8 fe ff ff    	je     544 <printf+0x54>
 66c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 66f:	89 de                	mov    %ebx,%esi
 671:	8b 5d 08             	mov    0x8(%ebp),%ebx
 674:	eb 1a                	jmp    690 <printf+0x1a0>
          s = "(null)";
 676:	bb f7 08 00 00       	mov    $0x8f7,%ebx
        while(*s != 0){
 67b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 67e:	b8 28 00 00 00       	mov    $0x28,%eax
 683:	89 de                	mov    %ebx,%esi
 685:	8b 5d 08             	mov    0x8(%ebp),%ebx
 688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop
  write(fd, &c, 1);
 690:	83 ec 04             	sub    $0x4,%esp
          s++;
 693:	83 c6 01             	add    $0x1,%esi
 696:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 699:	6a 01                	push   $0x1
 69b:	57                   	push   %edi
 69c:	53                   	push   %ebx
 69d:	e8 01 fd ff ff       	call   3a3 <write>
        while(*s != 0){
 6a2:	0f b6 06             	movzbl (%esi),%eax
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	84 c0                	test   %al,%al
 6aa:	75 e4                	jne    690 <printf+0x1a0>
 6ac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 6af:	31 d2                	xor    %edx,%edx
 6b1:	e9 8e fe ff ff       	jmp    544 <printf+0x54>
 6b6:	66 90                	xchg   %ax,%ax
 6b8:	66 90                	xchg   %ax,%ax
 6ba:	66 90                	xchg   %ax,%ax
 6bc:	66 90                	xchg   %ax,%ax
 6be:	66 90                	xchg   %ax,%ax

000006c0 <free>:
 6c0:	f3 0f 1e fb          	endbr32 
 6c4:	55                   	push   %ebp
 6c5:	a1 b4 0b 00 00       	mov    0xbb4,%eax
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	57                   	push   %edi
 6cd:	56                   	push   %esi
 6ce:	53                   	push   %ebx
 6cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 6d7:	39 c8                	cmp    %ecx,%eax
 6d9:	73 15                	jae    6f0 <free+0x30>
 6db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop
 6e0:	39 d1                	cmp    %edx,%ecx
 6e2:	72 14                	jb     6f8 <free+0x38>
 6e4:	39 d0                	cmp    %edx,%eax
 6e6:	73 10                	jae    6f8 <free+0x38>
 6e8:	89 d0                	mov    %edx,%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	39 c8                	cmp    %ecx,%eax
 6ee:	72 f0                	jb     6e0 <free+0x20>
 6f0:	39 d0                	cmp    %edx,%eax
 6f2:	72 f4                	jb     6e8 <free+0x28>
 6f4:	39 d1                	cmp    %edx,%ecx
 6f6:	73 f0                	jae    6e8 <free+0x28>
 6f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fe:	39 fa                	cmp    %edi,%edx
 700:	74 1e                	je     720 <free+0x60>
 702:	89 53 f8             	mov    %edx,-0x8(%ebx)
 705:	8b 50 04             	mov    0x4(%eax),%edx
 708:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 70b:	39 f1                	cmp    %esi,%ecx
 70d:	74 28                	je     737 <free+0x77>
 70f:	89 08                	mov    %ecx,(%eax)
 711:	5b                   	pop    %ebx
 712:	a3 b4 0b 00 00       	mov    %eax,0xbb4
 717:	5e                   	pop    %esi
 718:	5f                   	pop    %edi
 719:	5d                   	pop    %ebp
 71a:	c3                   	ret    
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
 720:	03 72 04             	add    0x4(%edx),%esi
 723:	89 73 fc             	mov    %esi,-0x4(%ebx)
 726:	8b 10                	mov    (%eax),%edx
 728:	8b 12                	mov    (%edx),%edx
 72a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 72d:	8b 50 04             	mov    0x4(%eax),%edx
 730:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 733:	39 f1                	cmp    %esi,%ecx
 735:	75 d8                	jne    70f <free+0x4f>
 737:	03 53 fc             	add    -0x4(%ebx),%edx
 73a:	a3 b4 0b 00 00       	mov    %eax,0xbb4
 73f:	89 50 04             	mov    %edx,0x4(%eax)
 742:	8b 53 f8             	mov    -0x8(%ebx),%edx
 745:	89 10                	mov    %edx,(%eax)
 747:	5b                   	pop    %ebx
 748:	5e                   	pop    %esi
 749:	5f                   	pop    %edi
 74a:	5d                   	pop    %ebp
 74b:	c3                   	ret    
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000750 <malloc>:
 750:	f3 0f 1e fb          	endbr32 
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	57                   	push   %edi
 758:	56                   	push   %esi
 759:	53                   	push   %ebx
 75a:	83 ec 1c             	sub    $0x1c,%esp
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	8b 3d b4 0b 00 00    	mov    0xbb4,%edi
 766:	8d 70 07             	lea    0x7(%eax),%esi
 769:	c1 ee 03             	shr    $0x3,%esi
 76c:	83 c6 01             	add    $0x1,%esi
 76f:	85 ff                	test   %edi,%edi
 771:	0f 84 a9 00 00 00    	je     820 <malloc+0xd0>
 777:	8b 07                	mov    (%edi),%eax
 779:	8b 48 04             	mov    0x4(%eax),%ecx
 77c:	39 f1                	cmp    %esi,%ecx
 77e:	73 6d                	jae    7ed <malloc+0x9d>
 780:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 786:	bb 00 10 00 00       	mov    $0x1000,%ebx
 78b:	0f 43 de             	cmovae %esi,%ebx
 78e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 795:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 798:	eb 17                	jmp    7b1 <malloc+0x61>
 79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7a0:	8b 10                	mov    (%eax),%edx
 7a2:	8b 4a 04             	mov    0x4(%edx),%ecx
 7a5:	39 f1                	cmp    %esi,%ecx
 7a7:	73 4f                	jae    7f8 <malloc+0xa8>
 7a9:	8b 3d b4 0b 00 00    	mov    0xbb4,%edi
 7af:	89 d0                	mov    %edx,%eax
 7b1:	39 c7                	cmp    %eax,%edi
 7b3:	75 eb                	jne    7a0 <malloc+0x50>
 7b5:	83 ec 0c             	sub    $0xc,%esp
 7b8:	ff 75 e4             	pushl  -0x1c(%ebp)
 7bb:	e8 4b fc ff ff       	call   40b <sbrk>
 7c0:	83 c4 10             	add    $0x10,%esp
 7c3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7c6:	74 1b                	je     7e3 <malloc+0x93>
 7c8:	89 58 04             	mov    %ebx,0x4(%eax)
 7cb:	83 ec 0c             	sub    $0xc,%esp
 7ce:	83 c0 08             	add    $0x8,%eax
 7d1:	50                   	push   %eax
 7d2:	e8 e9 fe ff ff       	call   6c0 <free>
 7d7:	a1 b4 0b 00 00       	mov    0xbb4,%eax
 7dc:	83 c4 10             	add    $0x10,%esp
 7df:	85 c0                	test   %eax,%eax
 7e1:	75 bd                	jne    7a0 <malloc+0x50>
 7e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7e6:	31 c0                	xor    %eax,%eax
 7e8:	5b                   	pop    %ebx
 7e9:	5e                   	pop    %esi
 7ea:	5f                   	pop    %edi
 7eb:	5d                   	pop    %ebp
 7ec:	c3                   	ret    
 7ed:	89 c2                	mov    %eax,%edx
 7ef:	89 f8                	mov    %edi,%eax
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7f8:	39 ce                	cmp    %ecx,%esi
 7fa:	74 54                	je     850 <malloc+0x100>
 7fc:	29 f1                	sub    %esi,%ecx
 7fe:	89 4a 04             	mov    %ecx,0x4(%edx)
 801:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
 804:	89 72 04             	mov    %esi,0x4(%edx)
 807:	a3 b4 0b 00 00       	mov    %eax,0xbb4
 80c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 80f:	8d 42 08             	lea    0x8(%edx),%eax
 812:	5b                   	pop    %ebx
 813:	5e                   	pop    %esi
 814:	5f                   	pop    %edi
 815:	5d                   	pop    %ebp
 816:	c3                   	ret    
 817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 81e:	66 90                	xchg   %ax,%ax
 820:	c7 05 b4 0b 00 00 b8 	movl   $0xbb8,0xbb4
 827:	0b 00 00 
 82a:	bf b8 0b 00 00       	mov    $0xbb8,%edi
 82f:	c7 05 b8 0b 00 00 b8 	movl   $0xbb8,0xbb8
 836:	0b 00 00 
 839:	89 f8                	mov    %edi,%eax
 83b:	c7 05 bc 0b 00 00 00 	movl   $0x0,0xbbc
 842:	00 00 00 
 845:	e9 36 ff ff ff       	jmp    780 <malloc+0x30>
 84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 850:	8b 0a                	mov    (%edx),%ecx
 852:	89 08                	mov    %ecx,(%eax)
 854:	eb b1                	jmp    807 <malloc+0xb7>
