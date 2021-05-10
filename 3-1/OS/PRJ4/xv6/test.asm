
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "param.h"
#include "fcntl.h"

#define SIZE (int)10

int main(){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 28             	sub    $0x28,%esp
    int read_time = 0,write_time = 0;
  17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    char *arr1 = (char *)malloc(sizeof(char)*30000000);
  1e:	68 80 c3 c9 01       	push   $0x1c9c380
    int read_time = 0,write_time = 0;
  23:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    char *arr1 = (char *)malloc(sizeof(char)*30000000);
  2a:	e8 61 08 00 00       	call   890 <malloc>
  2f:	89 c6                	mov    %eax,%esi

    printf(1, "arr1 allocation FINISHED\n");
  31:	58                   	pop    %eax
  32:	5a                   	pop    %edx
  33:	68 98 09 00 00       	push   $0x998
  38:	6a 01                	push   $0x1
  3a:	e8 f1 05 00 00       	call   630 <printf>

    char *arr2 = (char *)malloc(sizeof(char)*30000000);
  3f:	c7 04 24 80 c3 c9 01 	movl   $0x1c9c380,(%esp)
  46:	e8 45 08 00 00       	call   890 <malloc>
    printf(1, "arr2 allocation FINISHED\n");
  4b:	59                   	pop    %ecx
    char *arr2 = (char *)malloc(sizeof(char)*30000000);
  4c:	89 c3                	mov    %eax,%ebx
    printf(1, "arr2 allocation FINISHED\n");
  4e:	58                   	pop    %eax
  4f:	68 b2 09 00 00       	push   $0x9b2
  54:	6a 01                	push   $0x1
  56:	e8 d5 05 00 00       	call   630 <printf>
    arr1[1] = 0;
  5b:	c6 46 01 00          	movb   $0x0,0x1(%esi)

    // for (int i = 0; i < 50000; i++) {
    //     arr2[i] = 'a' + (i % 10);
    // }

    printf(1,"arr1[0] : %c, arr1[10000]: %c, arr1[20000] : %c, arr1[30000] : %c, arr1[40000] : %c\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
  5f:	83 c4 0c             	add    $0xc,%esp
    arr2[2] = 0;
  62:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
    printf(1,"arr1[0] : %c, arr1[10000]: %c, arr1[20000] : %c, arr1[30000] : %c, arr1[40000] : %c\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
  66:	0f be 86 40 9c 00 00 	movsbl 0x9c40(%esi),%eax
  6d:	50                   	push   %eax
  6e:	0f be 86 30 75 00 00 	movsbl 0x7530(%esi),%eax
  75:	50                   	push   %eax
  76:	0f be 86 20 4e 00 00 	movsbl 0x4e20(%esi),%eax
  7d:	50                   	push   %eax
  7e:	0f be 86 10 27 00 00 	movsbl 0x2710(%esi),%eax
  85:	50                   	push   %eax
  86:	0f be 06             	movsbl (%esi),%eax
  89:	50                   	push   %eax
  8a:	68 e4 09 00 00       	push   $0x9e4
  8f:	6a 01                	push   $0x1
  91:	e8 9a 05 00 00       	call   630 <printf>
    //00000
    printf(1,"arr1[5] : %c, arr1[10005]: %c, arr1[20005] : %c, arr1[30005] : %c, arr1[40005] : %c\n",arr1[5],arr1[10005],arr1[20005],arr1[30005],arr1[40005]);
  96:	0f be 86 45 9c 00 00 	movsbl 0x9c45(%esi),%eax
  9d:	83 c4 1c             	add    $0x1c,%esp
  a0:	50                   	push   %eax
  a1:	0f be 86 35 75 00 00 	movsbl 0x7535(%esi),%eax
  a8:	50                   	push   %eax
  a9:	0f be 86 25 4e 00 00 	movsbl 0x4e25(%esi),%eax
  b0:	50                   	push   %eax
  b1:	0f be 86 15 27 00 00 	movsbl 0x2715(%esi),%eax
  b8:	50                   	push   %eax
  b9:	0f be 46 05          	movsbl 0x5(%esi),%eax
  bd:	50                   	push   %eax
  be:	68 3c 0a 00 00       	push   $0xa3c
  c3:	6a 01                	push   $0x1
  c5:	e8 66 05 00 00       	call   630 <printf>
    //55555
    printf(1,"arr1[9] : %c, arr1[10009]: %c, arr1[20009] : %c, arr1[30009] : %c, arr1[40009] : %c\n",arr1[9],arr1[10009],arr1[20009],arr1[30009],arr1[40009]);
  ca:	0f be 86 49 9c 00 00 	movsbl 0x9c49(%esi),%eax
  d1:	83 c4 1c             	add    $0x1c,%esp
  d4:	50                   	push   %eax
  d5:	0f be 86 39 75 00 00 	movsbl 0x7539(%esi),%eax
  dc:	50                   	push   %eax
  dd:	0f be 86 29 4e 00 00 	movsbl 0x4e29(%esi),%eax
  e4:	50                   	push   %eax
  e5:	0f be 86 19 27 00 00 	movsbl 0x2719(%esi),%eax
  ec:	50                   	push   %eax
  ed:	0f be 46 09          	movsbl 0x9(%esi),%eax
  f1:	50                   	push   %eax
  f2:	68 94 0a 00 00       	push   $0xa94
  f7:	6a 01                	push   $0x1
  f9:	e8 32 05 00 00       	call   630 <printf>
    //99999
    printf(1,"arr2[0] : %c, arr2[10000]: %c, arr2[20000] : %c, arr2[30000] : %c, arr2[40000] : %c\n",arr2[0],arr2[10000],arr2[20000],arr2[30000],arr2[40000]);
  fe:	0f be 83 40 9c 00 00 	movsbl 0x9c40(%ebx),%eax
 105:	83 c4 1c             	add    $0x1c,%esp
 108:	50                   	push   %eax
 109:	0f be 83 30 75 00 00 	movsbl 0x7530(%ebx),%eax
 110:	50                   	push   %eax
 111:	0f be 83 20 4e 00 00 	movsbl 0x4e20(%ebx),%eax
 118:	50                   	push   %eax
 119:	0f be 83 10 27 00 00 	movsbl 0x2710(%ebx),%eax
 120:	50                   	push   %eax
 121:	0f be 03             	movsbl (%ebx),%eax
 124:	50                   	push   %eax
 125:	68 ec 0a 00 00       	push   $0xaec
 12a:	6a 01                	push   $0x1
 12c:	e8 ff 04 00 00       	call   630 <printf>
    //aaaaa
    printf(1,"arr2[3] : %c, arr2[10003]: %c, arr2[20003] : %c, arr2[30003] : %c, arr2[40003] : %c\n",arr2[3],arr2[10003],arr2[20003],arr2[30003],arr2[40003]);
 131:	0f be 83 43 9c 00 00 	movsbl 0x9c43(%ebx),%eax
 138:	83 c4 1c             	add    $0x1c,%esp
 13b:	50                   	push   %eax
 13c:	0f be 83 33 75 00 00 	movsbl 0x7533(%ebx),%eax
 143:	50                   	push   %eax
 144:	0f be 83 23 4e 00 00 	movsbl 0x4e23(%ebx),%eax
 14b:	50                   	push   %eax
 14c:	0f be 83 13 27 00 00 	movsbl 0x2713(%ebx),%eax
 153:	50                   	push   %eax
 154:	0f be 43 03          	movsbl 0x3(%ebx),%eax
 158:	50                   	push   %eax
 159:	68 44 0b 00 00       	push   $0xb44
 15e:	6a 01                	push   $0x1
 160:	e8 cb 04 00 00       	call   630 <printf>
    //ddddd
    printf(1,"arr2[6] : %c, arr2[10006]: %c, arr2[20006] : %c, arr2[30006] : %c, arr2[40006] : %c\n",arr2[6],arr2[10006],arr2[20006],arr2[30006],arr2[40006]);
 165:	0f be 83 46 9c 00 00 	movsbl 0x9c46(%ebx),%eax
 16c:	83 c4 1c             	add    $0x1c,%esp
 16f:	50                   	push   %eax
 170:	0f be 83 36 75 00 00 	movsbl 0x7536(%ebx),%eax
 177:	50                   	push   %eax
 178:	0f be 83 26 4e 00 00 	movsbl 0x4e26(%ebx),%eax
 17f:	50                   	push   %eax
 180:	0f be 83 16 27 00 00 	movsbl 0x2716(%ebx),%eax
 187:	50                   	push   %eax
 188:	0f be 43 06          	movsbl 0x6(%ebx),%eax
 18c:	50                   	push   %eax
 18d:	68 9c 0b 00 00       	push   $0xb9c
 192:	6a 01                	push   $0x1
 194:	e8 97 04 00 00       	call   630 <printf>
    //ggggg
    printf(1,"arr2[9] : %c, arr2[10009]: %c, arr2[20009] : %c, arr2[30009] : %c, arr2[40009] : %c\n",arr2[9],arr2[10009],arr2[20009],arr2[30009],arr2[40009]);
 199:	0f be 83 49 9c 00 00 	movsbl 0x9c49(%ebx),%eax
 1a0:	83 c4 1c             	add    $0x1c,%esp
 1a3:	50                   	push   %eax
 1a4:	0f be 83 39 75 00 00 	movsbl 0x7539(%ebx),%eax
 1ab:	50                   	push   %eax
 1ac:	0f be 83 29 4e 00 00 	movsbl 0x4e29(%ebx),%eax
 1b3:	50                   	push   %eax
 1b4:	0f be 83 19 27 00 00 	movsbl 0x2719(%ebx),%eax
 1bb:	50                   	push   %eax
 1bc:	0f be 43 09          	movsbl 0x9(%ebx),%eax
 1c0:	50                   	push   %eax
 1c1:	68 f4 0b 00 00       	push   $0xbf4
 1c6:	6a 01                	push   $0x1
 1c8:	e8 63 04 00 00       	call   630 <printf>
    //jjjjj
    printf(1,"arr1[0] : %c, arr1[10000]: %c, arr1[20000] : %c, arr1[30000] : %c, arr1[40000] : %c\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
 1cd:	0f be 86 40 9c 00 00 	movsbl 0x9c40(%esi),%eax
 1d4:	83 c4 1c             	add    $0x1c,%esp
 1d7:	50                   	push   %eax
 1d8:	0f be 86 30 75 00 00 	movsbl 0x7530(%esi),%eax
 1df:	50                   	push   %eax
 1e0:	0f be 86 20 4e 00 00 	movsbl 0x4e20(%esi),%eax
 1e7:	50                   	push   %eax
 1e8:	0f be 86 10 27 00 00 	movsbl 0x2710(%esi),%eax
 1ef:	50                   	push   %eax
 1f0:	0f be 06             	movsbl (%esi),%eax
 1f3:	50                   	push   %eax
 1f4:	68 e4 09 00 00       	push   $0x9e4
 1f9:	6a 01                	push   $0x1
 1fb:	e8 30 04 00 00       	call   630 <printf>
    //00000
    printf(1,"arr2[0] : %c, arr2[10000]: %c, arr2[20000] : %c, arr2[30000] : %c, arr2[40000] : %c\n",arr2[0],arr2[10000],arr2[20000],arr2[30000],arr2[40000]);
 200:	0f be 83 40 9c 00 00 	movsbl 0x9c40(%ebx),%eax
 207:	83 c4 1c             	add    $0x1c,%esp
 20a:	50                   	push   %eax
 20b:	0f be 83 30 75 00 00 	movsbl 0x7530(%ebx),%eax
 212:	50                   	push   %eax
 213:	0f be 83 20 4e 00 00 	movsbl 0x4e20(%ebx),%eax
 21a:	50                   	push   %eax
 21b:	0f be 83 10 27 00 00 	movsbl 0x2710(%ebx),%eax
 222:	50                   	push   %eax
 223:	0f be 03             	movsbl (%ebx),%eax
 226:	50                   	push   %eax
 227:	68 ec 0a 00 00       	push   $0xaec
 22c:	6a 01                	push   $0x1
 22e:	e8 fd 03 00 00       	call   630 <printf>
    // //00000
    // printf(1,"arr4[0] : %c, arr4[10000]: %c, arr4[20000] : %c, arr4[30000] : %c, arr4[40000] : %c\n",arr4[0],arr4[10000],arr4[20000],arr4[30000],arr4[40000]);
    // //aaaaa


    swapstat(&read_time,&write_time);
 233:	83 c4 18             	add    $0x18,%esp
 236:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 239:	50                   	push   %eax
 23a:	8d 45 e0             	lea    -0x20(%ebp),%eax
 23d:	50                   	push   %eax
 23e:	e8 30 03 00 00       	call   573 <swapstat>
    printf(1,"read : %d, write : %d\n", read_time, write_time);
 243:	ff 75 e4             	pushl  -0x1c(%ebp)
 246:	ff 75 e0             	pushl  -0x20(%ebp)
 249:	68 cc 09 00 00       	push   $0x9cc
 24e:	6a 01                	push   $0x1
 250:	e8 db 03 00 00       	call   630 <printf>
    
    exit();
 255:	83 c4 20             	add    $0x20,%esp
 258:	e8 66 02 00 00       	call   4c3 <exit>
 25d:	66 90                	xchg   %ax,%ax
 25f:	90                   	nop

00000260 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 260:	f3 0f 1e fb          	endbr32 
 264:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 265:	31 c0                	xor    %eax,%eax
{
 267:	89 e5                	mov    %esp,%ebp
 269:	53                   	push   %ebx
 26a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 26d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 270:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 274:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 277:	83 c0 01             	add    $0x1,%eax
 27a:	84 d2                	test   %dl,%dl
 27c:	75 f2                	jne    270 <strcpy+0x10>
    ;
  return os;
}
 27e:	89 c8                	mov    %ecx,%eax
 280:	5b                   	pop    %ebx
 281:	5d                   	pop    %ebp
 282:	c3                   	ret    
 283:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000290 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 290:	f3 0f 1e fb          	endbr32 
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	53                   	push   %ebx
 298:	8b 4d 08             	mov    0x8(%ebp),%ecx
 29b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 29e:	0f b6 01             	movzbl (%ecx),%eax
 2a1:	0f b6 1a             	movzbl (%edx),%ebx
 2a4:	84 c0                	test   %al,%al
 2a6:	75 19                	jne    2c1 <strcmp+0x31>
 2a8:	eb 26                	jmp    2d0 <strcmp+0x40>
 2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2b0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 2b4:	83 c1 01             	add    $0x1,%ecx
 2b7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2ba:	0f b6 1a             	movzbl (%edx),%ebx
 2bd:	84 c0                	test   %al,%al
 2bf:	74 0f                	je     2d0 <strcmp+0x40>
 2c1:	38 d8                	cmp    %bl,%al
 2c3:	74 eb                	je     2b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2c5:	29 d8                	sub    %ebx,%eax
}
 2c7:	5b                   	pop    %ebx
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2d2:	29 d8                	sub    %ebx,%eax
}
 2d4:	5b                   	pop    %ebx
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
 2d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2de:	66 90                	xchg   %ax,%ax

000002e0 <strlen>:

uint
strlen(const char *s)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2ea:	80 3a 00             	cmpb   $0x0,(%edx)
 2ed:	74 21                	je     310 <strlen+0x30>
 2ef:	31 c0                	xor    %eax,%eax
 2f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2f8:	83 c0 01             	add    $0x1,%eax
 2fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2ff:	89 c1                	mov    %eax,%ecx
 301:	75 f5                	jne    2f8 <strlen+0x18>
    ;
  return n;
}
 303:	89 c8                	mov    %ecx,%eax
 305:	5d                   	pop    %ebp
 306:	c3                   	ret    
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 310:	31 c9                	xor    %ecx,%ecx
}
 312:	5d                   	pop    %ebp
 313:	89 c8                	mov    %ecx,%eax
 315:	c3                   	ret    
 316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31d:	8d 76 00             	lea    0x0(%esi),%esi

00000320 <memset>:

void*
memset(void *dst, int c, uint n)
{
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	57                   	push   %edi
 328:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 32b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32e:	8b 45 0c             	mov    0xc(%ebp),%eax
 331:	89 d7                	mov    %edx,%edi
 333:	fc                   	cld    
 334:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 336:	89 d0                	mov    %edx,%eax
 338:	5f                   	pop    %edi
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret    
 33b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 33f:	90                   	nop

00000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 34e:	0f b6 10             	movzbl (%eax),%edx
 351:	84 d2                	test   %dl,%dl
 353:	75 16                	jne    36b <strchr+0x2b>
 355:	eb 21                	jmp    378 <strchr+0x38>
 357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35e:	66 90                	xchg   %ax,%ax
 360:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 364:	83 c0 01             	add    $0x1,%eax
 367:	84 d2                	test   %dl,%dl
 369:	74 0d                	je     378 <strchr+0x38>
    if(*s == c)
 36b:	38 d1                	cmp    %dl,%cl
 36d:	75 f1                	jne    360 <strchr+0x20>
      return (char*)s;
  return 0;
}
 36f:	5d                   	pop    %ebp
 370:	c3                   	ret    
 371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 378:	31 c0                	xor    %eax,%eax
}
 37a:	5d                   	pop    %ebp
 37b:	c3                   	ret    
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000380 <gets>:

char*
gets(char *buf, int max)
{
 380:	f3 0f 1e fb          	endbr32 
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	57                   	push   %edi
 388:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 389:	31 f6                	xor    %esi,%esi
{
 38b:	53                   	push   %ebx
 38c:	89 f3                	mov    %esi,%ebx
 38e:	83 ec 1c             	sub    $0x1c,%esp
 391:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 394:	eb 33                	jmp    3c9 <gets+0x49>
 396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3a0:	83 ec 04             	sub    $0x4,%esp
 3a3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3a6:	6a 01                	push   $0x1
 3a8:	50                   	push   %eax
 3a9:	6a 00                	push   $0x0
 3ab:	e8 2b 01 00 00       	call   4db <read>
    if(cc < 1)
 3b0:	83 c4 10             	add    $0x10,%esp
 3b3:	85 c0                	test   %eax,%eax
 3b5:	7e 1c                	jle    3d3 <gets+0x53>
      break;
    buf[i++] = c;
 3b7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3bb:	83 c7 01             	add    $0x1,%edi
 3be:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3c1:	3c 0a                	cmp    $0xa,%al
 3c3:	74 23                	je     3e8 <gets+0x68>
 3c5:	3c 0d                	cmp    $0xd,%al
 3c7:	74 1f                	je     3e8 <gets+0x68>
  for(i=0; i+1 < max; ){
 3c9:	83 c3 01             	add    $0x1,%ebx
 3cc:	89 fe                	mov    %edi,%esi
 3ce:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3d1:	7c cd                	jl     3a0 <gets+0x20>
 3d3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3d8:	c6 03 00             	movb   $0x0,(%ebx)
}
 3db:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3de:	5b                   	pop    %ebx
 3df:	5e                   	pop    %esi
 3e0:	5f                   	pop    %edi
 3e1:	5d                   	pop    %ebp
 3e2:	c3                   	ret    
 3e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3e7:	90                   	nop
 3e8:	8b 75 08             	mov    0x8(%ebp),%esi
 3eb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ee:	01 de                	add    %ebx,%esi
 3f0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3f2:	c6 03 00             	movb   $0x0,(%ebx)
}
 3f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f8:	5b                   	pop    %ebx
 3f9:	5e                   	pop    %esi
 3fa:	5f                   	pop    %edi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	56                   	push   %esi
 408:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 409:	83 ec 08             	sub    $0x8,%esp
 40c:	6a 00                	push   $0x0
 40e:	ff 75 08             	pushl  0x8(%ebp)
 411:	e8 ed 00 00 00       	call   503 <open>
  if(fd < 0)
 416:	83 c4 10             	add    $0x10,%esp
 419:	85 c0                	test   %eax,%eax
 41b:	78 2b                	js     448 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 41d:	83 ec 08             	sub    $0x8,%esp
 420:	ff 75 0c             	pushl  0xc(%ebp)
 423:	89 c3                	mov    %eax,%ebx
 425:	50                   	push   %eax
 426:	e8 f0 00 00 00       	call   51b <fstat>
  close(fd);
 42b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 42e:	89 c6                	mov    %eax,%esi
  close(fd);
 430:	e8 b6 00 00 00       	call   4eb <close>
  return r;
 435:	83 c4 10             	add    $0x10,%esp
}
 438:	8d 65 f8             	lea    -0x8(%ebp),%esp
 43b:	89 f0                	mov    %esi,%eax
 43d:	5b                   	pop    %ebx
 43e:	5e                   	pop    %esi
 43f:	5d                   	pop    %ebp
 440:	c3                   	ret    
 441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 448:	be ff ff ff ff       	mov    $0xffffffff,%esi
 44d:	eb e9                	jmp    438 <stat+0x38>
 44f:	90                   	nop

00000450 <atoi>:

int
atoi(const char *s)
{
 450:	f3 0f 1e fb          	endbr32 
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	53                   	push   %ebx
 458:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 45b:	0f be 02             	movsbl (%edx),%eax
 45e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 461:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 464:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 469:	77 1a                	ja     485 <atoi+0x35>
 46b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 46f:	90                   	nop
    n = n*10 + *s++ - '0';
 470:	83 c2 01             	add    $0x1,%edx
 473:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 476:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 47a:	0f be 02             	movsbl (%edx),%eax
 47d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x20>
  return n;
}
 485:	89 c8                	mov    %ecx,%eax
 487:	5b                   	pop    %ebx
 488:	5d                   	pop    %ebp
 489:	c3                   	ret    
 48a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	f3 0f 1e fb          	endbr32 
 494:	55                   	push   %ebp
 495:	89 e5                	mov    %esp,%ebp
 497:	57                   	push   %edi
 498:	8b 45 10             	mov    0x10(%ebp),%eax
 49b:	8b 55 08             	mov    0x8(%ebp),%edx
 49e:	56                   	push   %esi
 49f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4a2:	85 c0                	test   %eax,%eax
 4a4:	7e 0f                	jle    4b5 <memmove+0x25>
 4a6:	01 d0                	add    %edx,%eax
  dst = vdst;
 4a8:	89 d7                	mov    %edx,%edi
 4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4b1:	39 f8                	cmp    %edi,%eax
 4b3:	75 fb                	jne    4b0 <memmove+0x20>
  return vdst;
}
 4b5:	5e                   	pop    %esi
 4b6:	89 d0                	mov    %edx,%eax
 4b8:	5f                   	pop    %edi
 4b9:	5d                   	pop    %ebp
 4ba:	c3                   	ret    

000004bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4bb:	b8 01 00 00 00       	mov    $0x1,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <exit>:
SYSCALL(exit)
 4c3:	b8 02 00 00 00       	mov    $0x2,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <wait>:
SYSCALL(wait)
 4cb:	b8 03 00 00 00       	mov    $0x3,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <pipe>:
SYSCALL(pipe)
 4d3:	b8 04 00 00 00       	mov    $0x4,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <read>:
SYSCALL(read)
 4db:	b8 05 00 00 00       	mov    $0x5,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <write>:
SYSCALL(write)
 4e3:	b8 10 00 00 00       	mov    $0x10,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <close>:
SYSCALL(close)
 4eb:	b8 15 00 00 00       	mov    $0x15,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <kill>:
SYSCALL(kill)
 4f3:	b8 06 00 00 00       	mov    $0x6,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <exec>:
SYSCALL(exec)
 4fb:	b8 07 00 00 00       	mov    $0x7,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <open>:
SYSCALL(open)
 503:	b8 0f 00 00 00       	mov    $0xf,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <mknod>:
SYSCALL(mknod)
 50b:	b8 11 00 00 00       	mov    $0x11,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <unlink>:
SYSCALL(unlink)
 513:	b8 12 00 00 00       	mov    $0x12,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <fstat>:
SYSCALL(fstat)
 51b:	b8 08 00 00 00       	mov    $0x8,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <link>:
SYSCALL(link)
 523:	b8 13 00 00 00       	mov    $0x13,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <mkdir>:
SYSCALL(mkdir)
 52b:	b8 14 00 00 00       	mov    $0x14,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <chdir>:
SYSCALL(chdir)
 533:	b8 09 00 00 00       	mov    $0x9,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <dup>:
SYSCALL(dup)
 53b:	b8 0a 00 00 00       	mov    $0xa,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <getpid>:
SYSCALL(getpid)
 543:	b8 0b 00 00 00       	mov    $0xb,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <sbrk>:
SYSCALL(sbrk)
 54b:	b8 0c 00 00 00       	mov    $0xc,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <sleep>:
SYSCALL(sleep)
 553:	b8 0d 00 00 00       	mov    $0xd,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <uptime>:
SYSCALL(uptime)
 55b:	b8 0e 00 00 00       	mov    $0xe,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <swapread>:
SYSCALL(swapread)
 563:	b8 16 00 00 00       	mov    $0x16,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <swapwrite>:
SYSCALL(swapwrite)
 56b:	b8 17 00 00 00       	mov    $0x17,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <swapstat>:
SYSCALL(swapstat)
 573:	b8 18 00 00 00       	mov    $0x18,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    
 57b:	66 90                	xchg   %ax,%ax
 57d:	66 90                	xchg   %ax,%ax
 57f:	90                   	nop

00000580 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	83 ec 3c             	sub    $0x3c,%esp
 589:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 58c:	89 d1                	mov    %edx,%ecx
{
 58e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 591:	85 d2                	test   %edx,%edx
 593:	0f 89 7f 00 00 00    	jns    618 <printint+0x98>
 599:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 59d:	74 79                	je     618 <printint+0x98>
    neg = 1;
 59f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 5a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 5a8:	31 db                	xor    %ebx,%ebx
 5aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5b0:	89 c8                	mov    %ecx,%eax
 5b2:	31 d2                	xor    %edx,%edx
 5b4:	89 cf                	mov    %ecx,%edi
 5b6:	f7 75 c4             	divl   -0x3c(%ebp)
 5b9:	0f b6 92 50 0c 00 00 	movzbl 0xc50(%edx),%edx
 5c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 5c3:	89 d8                	mov    %ebx,%eax
 5c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 5c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 5cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 5ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5d1:	76 dd                	jbe    5b0 <printint+0x30>
  if(neg)
 5d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5d6:	85 c9                	test   %ecx,%ecx
 5d8:	74 0c                	je     5e6 <printint+0x66>
    buf[i++] = '-';
 5da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 5df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5ed:	eb 07                	jmp    5f6 <printint+0x76>
 5ef:	90                   	nop
 5f0:	0f b6 13             	movzbl (%ebx),%edx
 5f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5f6:	83 ec 04             	sub    $0x4,%esp
 5f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5fc:	6a 01                	push   $0x1
 5fe:	56                   	push   %esi
 5ff:	57                   	push   %edi
 600:	e8 de fe ff ff       	call   4e3 <write>
  while(--i >= 0)
 605:	83 c4 10             	add    $0x10,%esp
 608:	39 de                	cmp    %ebx,%esi
 60a:	75 e4                	jne    5f0 <printint+0x70>
    putc(fd, buf[i]);
}
 60c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 60f:	5b                   	pop    %ebx
 610:	5e                   	pop    %esi
 611:	5f                   	pop    %edi
 612:	5d                   	pop    %ebp
 613:	c3                   	ret    
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 618:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 61f:	eb 87                	jmp    5a8 <printint+0x28>
 621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop

00000630 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 630:	f3 0f 1e fb          	endbr32 
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	57                   	push   %edi
 638:	56                   	push   %esi
 639:	53                   	push   %ebx
 63a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 63d:	8b 75 0c             	mov    0xc(%ebp),%esi
 640:	0f b6 1e             	movzbl (%esi),%ebx
 643:	84 db                	test   %bl,%bl
 645:	0f 84 b4 00 00 00    	je     6ff <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 64b:	8d 45 10             	lea    0x10(%ebp),%eax
 64e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 651:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 654:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 656:	89 45 d0             	mov    %eax,-0x30(%ebp)
 659:	eb 33                	jmp    68e <printf+0x5e>
 65b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 65f:	90                   	nop
 660:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 663:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 668:	83 f8 25             	cmp    $0x25,%eax
 66b:	74 17                	je     684 <printf+0x54>
  write(fd, &c, 1);
 66d:	83 ec 04             	sub    $0x4,%esp
 670:	88 5d e7             	mov    %bl,-0x19(%ebp)
 673:	6a 01                	push   $0x1
 675:	57                   	push   %edi
 676:	ff 75 08             	pushl  0x8(%ebp)
 679:	e8 65 fe ff ff       	call   4e3 <write>
 67e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 681:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 684:	0f b6 1e             	movzbl (%esi),%ebx
 687:	83 c6 01             	add    $0x1,%esi
 68a:	84 db                	test   %bl,%bl
 68c:	74 71                	je     6ff <printf+0xcf>
    c = fmt[i] & 0xff;
 68e:	0f be cb             	movsbl %bl,%ecx
 691:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 694:	85 d2                	test   %edx,%edx
 696:	74 c8                	je     660 <printf+0x30>
      }
    } else if(state == '%'){
 698:	83 fa 25             	cmp    $0x25,%edx
 69b:	75 e7                	jne    684 <printf+0x54>
      if(c == 'd'){
 69d:	83 f8 64             	cmp    $0x64,%eax
 6a0:	0f 84 9a 00 00 00    	je     740 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6a6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6ac:	83 f9 70             	cmp    $0x70,%ecx
 6af:	74 5f                	je     710 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6b1:	83 f8 73             	cmp    $0x73,%eax
 6b4:	0f 84 d6 00 00 00    	je     790 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ba:	83 f8 63             	cmp    $0x63,%eax
 6bd:	0f 84 8d 00 00 00    	je     750 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6c3:	83 f8 25             	cmp    $0x25,%eax
 6c6:	0f 84 b4 00 00 00    	je     780 <printf+0x150>
  write(fd, &c, 1);
 6cc:	83 ec 04             	sub    $0x4,%esp
 6cf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6d3:	6a 01                	push   $0x1
 6d5:	57                   	push   %edi
 6d6:	ff 75 08             	pushl  0x8(%ebp)
 6d9:	e8 05 fe ff ff       	call   4e3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6de:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6e1:	83 c4 0c             	add    $0xc,%esp
 6e4:	6a 01                	push   $0x1
 6e6:	83 c6 01             	add    $0x1,%esi
 6e9:	57                   	push   %edi
 6ea:	ff 75 08             	pushl  0x8(%ebp)
 6ed:	e8 f1 fd ff ff       	call   4e3 <write>
  for(i = 0; fmt[i]; i++){
 6f2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6f6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6fb:	84 db                	test   %bl,%bl
 6fd:	75 8f                	jne    68e <printf+0x5e>
    }
  }
}
 6ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 702:	5b                   	pop    %ebx
 703:	5e                   	pop    %esi
 704:	5f                   	pop    %edi
 705:	5d                   	pop    %ebp
 706:	c3                   	ret    
 707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	b9 10 00 00 00       	mov    $0x10,%ecx
 718:	6a 00                	push   $0x0
 71a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 71d:	8b 45 08             	mov    0x8(%ebp),%eax
 720:	8b 13                	mov    (%ebx),%edx
 722:	e8 59 fe ff ff       	call   580 <printint>
        ap++;
 727:	89 d8                	mov    %ebx,%eax
 729:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72c:	31 d2                	xor    %edx,%edx
        ap++;
 72e:	83 c0 04             	add    $0x4,%eax
 731:	89 45 d0             	mov    %eax,-0x30(%ebp)
 734:	e9 4b ff ff ff       	jmp    684 <printf+0x54>
 739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 740:	83 ec 0c             	sub    $0xc,%esp
 743:	b9 0a 00 00 00       	mov    $0xa,%ecx
 748:	6a 01                	push   $0x1
 74a:	eb ce                	jmp    71a <printf+0xea>
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 750:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 753:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 756:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 758:	6a 01                	push   $0x1
        ap++;
 75a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 75d:	57                   	push   %edi
 75e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 761:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 764:	e8 7a fd ff ff       	call   4e3 <write>
        ap++;
 769:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 76c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 76f:	31 d2                	xor    %edx,%edx
 771:	e9 0e ff ff ff       	jmp    684 <printf+0x54>
 776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 780:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 783:	83 ec 04             	sub    $0x4,%esp
 786:	e9 59 ff ff ff       	jmp    6e4 <printf+0xb4>
 78b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 78f:	90                   	nop
        s = (char*)*ap;
 790:	8b 45 d0             	mov    -0x30(%ebp),%eax
 793:	8b 18                	mov    (%eax),%ebx
        ap++;
 795:	83 c0 04             	add    $0x4,%eax
 798:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 79b:	85 db                	test   %ebx,%ebx
 79d:	74 17                	je     7b6 <printf+0x186>
        while(*s != 0){
 79f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 7a2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 7a4:	84 c0                	test   %al,%al
 7a6:	0f 84 d8 fe ff ff    	je     684 <printf+0x54>
 7ac:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7af:	89 de                	mov    %ebx,%esi
 7b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7b4:	eb 1a                	jmp    7d0 <printf+0x1a0>
          s = "(null)";
 7b6:	bb 49 0c 00 00       	mov    $0xc49,%ebx
        while(*s != 0){
 7bb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7be:	b8 28 00 00 00       	mov    $0x28,%eax
 7c3:	89 de                	mov    %ebx,%esi
 7c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7cf:	90                   	nop
  write(fd, &c, 1);
 7d0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7d3:	83 c6 01             	add    $0x1,%esi
 7d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7d9:	6a 01                	push   $0x1
 7db:	57                   	push   %edi
 7dc:	53                   	push   %ebx
 7dd:	e8 01 fd ff ff       	call   4e3 <write>
        while(*s != 0){
 7e2:	0f b6 06             	movzbl (%esi),%eax
 7e5:	83 c4 10             	add    $0x10,%esp
 7e8:	84 c0                	test   %al,%al
 7ea:	75 e4                	jne    7d0 <printf+0x1a0>
 7ec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7ef:	31 d2                	xor    %edx,%edx
 7f1:	e9 8e fe ff ff       	jmp    684 <printf+0x54>
 7f6:	66 90                	xchg   %ax,%ax
 7f8:	66 90                	xchg   %ax,%ax
 7fa:	66 90                	xchg   %ax,%ax
 7fc:	66 90                	xchg   %ax,%ax
 7fe:	66 90                	xchg   %ax,%ax

00000800 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 800:	f3 0f 1e fb          	endbr32 
 804:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 805:	a1 00 0f 00 00       	mov    0xf00,%eax
{
 80a:	89 e5                	mov    %esp,%ebp
 80c:	57                   	push   %edi
 80d:	56                   	push   %esi
 80e:	53                   	push   %ebx
 80f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 812:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 814:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 817:	39 c8                	cmp    %ecx,%eax
 819:	73 15                	jae    830 <free+0x30>
 81b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 81f:	90                   	nop
 820:	39 d1                	cmp    %edx,%ecx
 822:	72 14                	jb     838 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 824:	39 d0                	cmp    %edx,%eax
 826:	73 10                	jae    838 <free+0x38>
{
 828:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	8b 10                	mov    (%eax),%edx
 82c:	39 c8                	cmp    %ecx,%eax
 82e:	72 f0                	jb     820 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	39 d0                	cmp    %edx,%eax
 832:	72 f4                	jb     828 <free+0x28>
 834:	39 d1                	cmp    %edx,%ecx
 836:	73 f0                	jae    828 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 838:	8b 73 fc             	mov    -0x4(%ebx),%esi
 83b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83e:	39 fa                	cmp    %edi,%edx
 840:	74 1e                	je     860 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 842:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 845:	8b 50 04             	mov    0x4(%eax),%edx
 848:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 84b:	39 f1                	cmp    %esi,%ecx
 84d:	74 28                	je     877 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 84f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 851:	5b                   	pop    %ebx
  freep = p;
 852:	a3 00 0f 00 00       	mov    %eax,0xf00
}
 857:	5e                   	pop    %esi
 858:	5f                   	pop    %edi
 859:	5d                   	pop    %ebp
 85a:	c3                   	ret    
 85b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 85f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 860:	03 72 04             	add    0x4(%edx),%esi
 863:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	8b 10                	mov    (%eax),%edx
 868:	8b 12                	mov    (%edx),%edx
 86a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 86d:	8b 50 04             	mov    0x4(%eax),%edx
 870:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 873:	39 f1                	cmp    %esi,%ecx
 875:	75 d8                	jne    84f <free+0x4f>
    p->s.size += bp->s.size;
 877:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 87a:	a3 00 0f 00 00       	mov    %eax,0xf00
    p->s.size += bp->s.size;
 87f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 882:	8b 53 f8             	mov    -0x8(%ebx),%edx
 885:	89 10                	mov    %edx,(%eax)
}
 887:	5b                   	pop    %ebx
 888:	5e                   	pop    %esi
 889:	5f                   	pop    %edi
 88a:	5d                   	pop    %ebp
 88b:	c3                   	ret    
 88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000890 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 890:	f3 0f 1e fb          	endbr32 
 894:	55                   	push   %ebp
 895:	89 e5                	mov    %esp,%ebp
 897:	57                   	push   %edi
 898:	56                   	push   %esi
 899:	53                   	push   %ebx
 89a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8a0:	8b 3d 00 0f 00 00    	mov    0xf00,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a6:	8d 70 07             	lea    0x7(%eax),%esi
 8a9:	c1 ee 03             	shr    $0x3,%esi
 8ac:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8af:	85 ff                	test   %edi,%edi
 8b1:	0f 84 a9 00 00 00    	je     960 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 8b9:	8b 48 04             	mov    0x4(%eax),%ecx
 8bc:	39 f1                	cmp    %esi,%ecx
 8be:	73 6d                	jae    92d <malloc+0x9d>
 8c0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 8c6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8cb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8ce:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 8d5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 8d8:	eb 17                	jmp    8f1 <malloc+0x61>
 8da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 8e2:	8b 4a 04             	mov    0x4(%edx),%ecx
 8e5:	39 f1                	cmp    %esi,%ecx
 8e7:	73 4f                	jae    938 <malloc+0xa8>
 8e9:	8b 3d 00 0f 00 00    	mov    0xf00,%edi
 8ef:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f1:	39 c7                	cmp    %eax,%edi
 8f3:	75 eb                	jne    8e0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8f5:	83 ec 0c             	sub    $0xc,%esp
 8f8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8fb:	e8 4b fc ff ff       	call   54b <sbrk>
  if(p == (char*)-1)
 900:	83 c4 10             	add    $0x10,%esp
 903:	83 f8 ff             	cmp    $0xffffffff,%eax
 906:	74 1b                	je     923 <malloc+0x93>
  hp->s.size = nu;
 908:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 90b:	83 ec 0c             	sub    $0xc,%esp
 90e:	83 c0 08             	add    $0x8,%eax
 911:	50                   	push   %eax
 912:	e8 e9 fe ff ff       	call   800 <free>
  return freep;
 917:	a1 00 0f 00 00       	mov    0xf00,%eax
      if((p = morecore(nunits)) == 0)
 91c:	83 c4 10             	add    $0x10,%esp
 91f:	85 c0                	test   %eax,%eax
 921:	75 bd                	jne    8e0 <malloc+0x50>
        return 0;
  }
}
 923:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 926:	31 c0                	xor    %eax,%eax
}
 928:	5b                   	pop    %ebx
 929:	5e                   	pop    %esi
 92a:	5f                   	pop    %edi
 92b:	5d                   	pop    %ebp
 92c:	c3                   	ret    
    if(p->s.size >= nunits){
 92d:	89 c2                	mov    %eax,%edx
 92f:	89 f8                	mov    %edi,%eax
 931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 938:	39 ce                	cmp    %ecx,%esi
 93a:	74 54                	je     990 <malloc+0x100>
        p->s.size -= nunits;
 93c:	29 f1                	sub    %esi,%ecx
 93e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 941:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 944:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 947:	a3 00 0f 00 00       	mov    %eax,0xf00
}
 94c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 94f:	8d 42 08             	lea    0x8(%edx),%eax
}
 952:	5b                   	pop    %ebx
 953:	5e                   	pop    %esi
 954:	5f                   	pop    %edi
 955:	5d                   	pop    %ebp
 956:	c3                   	ret    
 957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 95e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 960:	c7 05 00 0f 00 00 04 	movl   $0xf04,0xf00
 967:	0f 00 00 
    base.s.size = 0;
 96a:	bf 04 0f 00 00       	mov    $0xf04,%edi
    base.s.ptr = freep = prevp = &base;
 96f:	c7 05 04 0f 00 00 04 	movl   $0xf04,0xf04
 976:	0f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 979:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 97b:	c7 05 08 0f 00 00 00 	movl   $0x0,0xf08
 982:	00 00 00 
    if(p->s.size >= nunits){
 985:	e9 36 ff ff ff       	jmp    8c0 <malloc+0x30>
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 990:	8b 0a                	mov    (%edx),%ecx
 992:	89 08                	mov    %ecx,(%eax)
 994:	eb b1                	jmp    947 <malloc+0xb7>
