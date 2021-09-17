
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
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 24             	sub    $0x24,%esp
    int read_time = 0,write_time = 0;
  18:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    // char *arr1 = (char *)malloc(sizeof(char)*30000000);
    char *arr1 = (char *)malloc(sizeof(char)*3000000); // 처음 300만
  1f:	68 c0 c6 2d 00       	push   $0x2dc6c0
    int read_time = 0,write_time = 0;
  24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    char *arr1 = (char *)malloc(sizeof(char)*3000000); // 처음 300만
  2b:	e8 d0 08 00 00       	call   900 <malloc>
  30:	89 c6                	mov    %eax,%esi
    // 150만 이후에 참조하는 인자가 있으면 지워줘야함


    printf(1, "arr1 allocation FINISHED\n");
  32:	58                   	pop    %eax
  33:	5a                   	pop    %edx
  34:	68 08 0a 00 00       	push   $0xa08
  39:	6a 01                	push   $0x1
  3b:	e8 60 06 00 00       	call   6a0 <printf>

    // char *arr2 = (char *)malloc(sizeof(char)*30000000);
    char *arr2 = (char *)malloc(sizeof(char)*3000000);
  40:	c7 04 24 c0 c6 2d 00 	movl   $0x2dc6c0,(%esp)
  47:	e8 b4 08 00 00       	call   900 <malloc>
    printf(1, "arr2 allocation FINISHED\n");
  4c:	59                   	pop    %ecx
  4d:	5f                   	pop    %edi
  4e:	68 22 0a 00 00       	push   $0xa22
  53:	6a 01                	push   $0x1
    char *arr2 = (char *)malloc(sizeof(char)*3000000);
  55:	89 c3                	mov    %eax,%ebx
    // for (int i = 0; i < SIZE;i++){
    //     ararr[i][0] = 1;
    // }

    for (int i = 0; i < 50000; i++) {
        arr1[i] = '0' + (i % 10);
  57:	bf cd cc cc cc       	mov    $0xcccccccd,%edi
    printf(1, "arr2 allocation FINISHED\n");
  5c:	e8 3f 06 00 00       	call   6a0 <printf>
    arr1[1] = 0;
  61:	c6 46 01 00          	movb   $0x0,0x1(%esi)
    arr2[2] = 0;
  65:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < 50000; i++) {
  68:	31 c9                	xor    %ecx,%ecx
    arr2[2] = 0;
  6a:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
    for (int i = 0; i < 50000; i++) {
  6e:	66 90                	xchg   %ax,%ax
        arr1[i] = '0' + (i % 10);
  70:	89 c8                	mov    %ecx,%eax
  72:	f7 e7                	mul    %edi
  74:	c1 ea 03             	shr    $0x3,%edx
  77:	8d 04 92             	lea    (%edx,%edx,4),%eax
  7a:	89 ca                	mov    %ecx,%edx
  7c:	01 c0                	add    %eax,%eax
  7e:	29 c2                	sub    %eax,%edx
  80:	89 d0                	mov    %edx,%eax
  82:	83 c0 30             	add    $0x30,%eax
  85:	88 04 0e             	mov    %al,(%esi,%ecx,1)
    for (int i = 0; i < 50000; i++) {
  88:	83 c1 01             	add    $0x1,%ecx
  8b:	81 f9 50 c3 00 00    	cmp    $0xc350,%ecx
  91:	75 dd                	jne    70 <main+0x70>
    }

    for (int i = 0; i < 50000; i++) {
  93:	31 c9                	xor    %ecx,%ecx
        arr2[i] = 'a' + (i % 10);
  95:	bf cd cc cc cc       	mov    $0xcccccccd,%edi
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a0:	89 c8                	mov    %ecx,%eax
  a2:	f7 e7                	mul    %edi
  a4:	c1 ea 03             	shr    $0x3,%edx
  a7:	8d 04 92             	lea    (%edx,%edx,4),%eax
  aa:	89 ca                	mov    %ecx,%edx
  ac:	01 c0                	add    %eax,%eax
  ae:	29 c2                	sub    %eax,%edx
  b0:	89 d0                	mov    %edx,%eax
  b2:	83 c0 61             	add    $0x61,%eax
  b5:	88 04 0b             	mov    %al,(%ebx,%ecx,1)
    for (int i = 0; i < 50000; i++) {
  b8:	83 c1 01             	add    $0x1,%ecx
  bb:	81 f9 50 c3 00 00    	cmp    $0xc350,%ecx
  c1:	75 dd                	jne    a0 <main+0xa0>
    }

    printf(1,"arr1[0] : %c, arr1[10000]: %c, arr1[20000] : %c, arr1[30000] : %c, arr1[40000] : %c\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
  c3:	0f be 86 40 9c 00 00 	movsbl 0x9c40(%esi),%eax
  ca:	83 ec 04             	sub    $0x4,%esp
  cd:	50                   	push   %eax
  ce:	0f be 86 30 75 00 00 	movsbl 0x7530(%esi),%eax
  d5:	50                   	push   %eax
  d6:	0f be 86 20 4e 00 00 	movsbl 0x4e20(%esi),%eax
  dd:	50                   	push   %eax
  de:	0f be 86 10 27 00 00 	movsbl 0x2710(%esi),%eax
  e5:	50                   	push   %eax
  e6:	0f be 06             	movsbl (%esi),%eax
  e9:	50                   	push   %eax
  ea:	68 54 0a 00 00       	push   $0xa54
  ef:	6a 01                	push   $0x1
  f1:	e8 aa 05 00 00       	call   6a0 <printf>
    //00000
    printf(1,"arr1[5] : %c, arr1[10005]: %c, arr1[20005] : %c, arr1[30005] : %c, arr1[40005] : %c\n",arr1[5],arr1[10005],arr1[20005],arr1[30005],arr1[40005]);
  f6:	0f be 86 45 9c 00 00 	movsbl 0x9c45(%esi),%eax
  fd:	83 c4 1c             	add    $0x1c,%esp
 100:	50                   	push   %eax
 101:	0f be 86 35 75 00 00 	movsbl 0x7535(%esi),%eax
 108:	50                   	push   %eax
 109:	0f be 86 25 4e 00 00 	movsbl 0x4e25(%esi),%eax
 110:	50                   	push   %eax
 111:	0f be 86 15 27 00 00 	movsbl 0x2715(%esi),%eax
 118:	50                   	push   %eax
 119:	0f be 46 05          	movsbl 0x5(%esi),%eax
 11d:	50                   	push   %eax
 11e:	68 ac 0a 00 00       	push   $0xaac
 123:	6a 01                	push   $0x1
 125:	e8 76 05 00 00       	call   6a0 <printf>
    //55555
    printf(1,"arr1[9] : %c, arr1[10009]: %c, arr1[20009] : %c, arr1[30009] : %c, arr1[40009] : %c\n",arr1[9],arr1[10009],arr1[20009],arr1[30009],arr1[40009]);
 12a:	0f be 86 49 9c 00 00 	movsbl 0x9c49(%esi),%eax
 131:	83 c4 1c             	add    $0x1c,%esp
 134:	50                   	push   %eax
 135:	0f be 86 39 75 00 00 	movsbl 0x7539(%esi),%eax
 13c:	50                   	push   %eax
 13d:	0f be 86 29 4e 00 00 	movsbl 0x4e29(%esi),%eax
 144:	50                   	push   %eax
 145:	0f be 86 19 27 00 00 	movsbl 0x2719(%esi),%eax
 14c:	50                   	push   %eax
 14d:	0f be 46 09          	movsbl 0x9(%esi),%eax
 151:	50                   	push   %eax
 152:	68 04 0b 00 00       	push   $0xb04
 157:	6a 01                	push   $0x1
 159:	e8 42 05 00 00       	call   6a0 <printf>
    //99999
    printf(1,"arr2[0] : %c, arr2[10000]: %c, arr2[20000] : %c, arr2[30000] : %c, arr2[40000] : %c\n",arr2[0],arr2[10000],arr2[20000],arr2[30000],arr2[40000]);
 15e:	0f be 83 40 9c 00 00 	movsbl 0x9c40(%ebx),%eax
 165:	83 c4 1c             	add    $0x1c,%esp
 168:	50                   	push   %eax
 169:	0f be 83 30 75 00 00 	movsbl 0x7530(%ebx),%eax
 170:	50                   	push   %eax
 171:	0f be 83 20 4e 00 00 	movsbl 0x4e20(%ebx),%eax
 178:	50                   	push   %eax
 179:	0f be 83 10 27 00 00 	movsbl 0x2710(%ebx),%eax
 180:	50                   	push   %eax
 181:	0f be 03             	movsbl (%ebx),%eax
 184:	50                   	push   %eax
 185:	68 5c 0b 00 00       	push   $0xb5c
 18a:	6a 01                	push   $0x1
 18c:	e8 0f 05 00 00       	call   6a0 <printf>
    //aaaaa
    printf(1,"arr2[3] : %c, arr2[10003]: %c, arr2[20003] : %c, arr2[30003] : %c, arr2[40003] : %c\n",arr2[3],arr2[10003],arr2[20003],arr2[30003],arr2[40003]);
 191:	0f be 83 43 9c 00 00 	movsbl 0x9c43(%ebx),%eax
 198:	83 c4 1c             	add    $0x1c,%esp
 19b:	50                   	push   %eax
 19c:	0f be 83 33 75 00 00 	movsbl 0x7533(%ebx),%eax
 1a3:	50                   	push   %eax
 1a4:	0f be 83 23 4e 00 00 	movsbl 0x4e23(%ebx),%eax
 1ab:	50                   	push   %eax
 1ac:	0f be 83 13 27 00 00 	movsbl 0x2713(%ebx),%eax
 1b3:	50                   	push   %eax
 1b4:	0f be 43 03          	movsbl 0x3(%ebx),%eax
 1b8:	50                   	push   %eax
 1b9:	68 b4 0b 00 00       	push   $0xbb4
 1be:	6a 01                	push   $0x1
 1c0:	e8 db 04 00 00       	call   6a0 <printf>
    //ddddd
    printf(1,"arr2[6] : %c, arr2[10006]: %c, arr2[20006] : %c, arr2[30006] : %c, arr2[40006] : %c\n",arr2[6],arr2[10006],arr2[20006],arr2[30006],arr2[40006]);
 1c5:	0f be 83 46 9c 00 00 	movsbl 0x9c46(%ebx),%eax
 1cc:	83 c4 1c             	add    $0x1c,%esp
 1cf:	50                   	push   %eax
 1d0:	0f be 83 36 75 00 00 	movsbl 0x7536(%ebx),%eax
 1d7:	50                   	push   %eax
 1d8:	0f be 83 26 4e 00 00 	movsbl 0x4e26(%ebx),%eax
 1df:	50                   	push   %eax
 1e0:	0f be 83 16 27 00 00 	movsbl 0x2716(%ebx),%eax
 1e7:	50                   	push   %eax
 1e8:	0f be 43 06          	movsbl 0x6(%ebx),%eax
 1ec:	50                   	push   %eax
 1ed:	68 0c 0c 00 00       	push   $0xc0c
 1f2:	6a 01                	push   $0x1
 1f4:	e8 a7 04 00 00       	call   6a0 <printf>
    //ggggg
    printf(1,"arr2[9] : %c, arr2[10009]: %c, arr2[20009] : %c, arr2[30009] : %c, arr2[40009] : %c\n",arr2[9],arr2[10009],arr2[20009],arr2[30009],arr2[40009]);
 1f9:	0f be 83 49 9c 00 00 	movsbl 0x9c49(%ebx),%eax
 200:	83 c4 1c             	add    $0x1c,%esp
 203:	50                   	push   %eax
 204:	0f be 83 39 75 00 00 	movsbl 0x7539(%ebx),%eax
 20b:	50                   	push   %eax
 20c:	0f be 83 29 4e 00 00 	movsbl 0x4e29(%ebx),%eax
 213:	50                   	push   %eax
 214:	0f be 83 19 27 00 00 	movsbl 0x2719(%ebx),%eax
 21b:	50                   	push   %eax
 21c:	0f be 43 09          	movsbl 0x9(%ebx),%eax
 220:	50                   	push   %eax
 221:	68 64 0c 00 00       	push   $0xc64
 226:	6a 01                	push   $0x1
 228:	e8 73 04 00 00       	call   6a0 <printf>
    //jjjjj
    printf(1,"arr1[0] : %c, arr1[10000]: %c, arr1[20000] : %c, arr1[30000] : %c, arr1[40000] : %c\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
 22d:	0f be 86 40 9c 00 00 	movsbl 0x9c40(%esi),%eax
 234:	83 c4 1c             	add    $0x1c,%esp
 237:	50                   	push   %eax
 238:	0f be 86 30 75 00 00 	movsbl 0x7530(%esi),%eax
 23f:	50                   	push   %eax
 240:	0f be 86 20 4e 00 00 	movsbl 0x4e20(%esi),%eax
 247:	50                   	push   %eax
 248:	0f be 86 10 27 00 00 	movsbl 0x2710(%esi),%eax
 24f:	50                   	push   %eax
 250:	0f be 06             	movsbl (%esi),%eax
 253:	50                   	push   %eax
 254:	68 54 0a 00 00       	push   $0xa54
 259:	6a 01                	push   $0x1
 25b:	e8 40 04 00 00       	call   6a0 <printf>
    //00000
    printf(1,"arr2[0] : %c, arr2[10000]: %c, arr2[20000] : %c, arr2[30000] : %c, arr2[40000] : %c\n",arr2[0],arr2[10000],arr2[20000],arr2[30000],arr2[40000]);
 260:	0f be 83 40 9c 00 00 	movsbl 0x9c40(%ebx),%eax
 267:	83 c4 1c             	add    $0x1c,%esp
 26a:	50                   	push   %eax
 26b:	0f be 83 30 75 00 00 	movsbl 0x7530(%ebx),%eax
 272:	50                   	push   %eax
 273:	0f be 83 20 4e 00 00 	movsbl 0x4e20(%ebx),%eax
 27a:	50                   	push   %eax
 27b:	0f be 83 10 27 00 00 	movsbl 0x2710(%ebx),%eax
 282:	50                   	push   %eax
 283:	0f be 03             	movsbl (%ebx),%eax
 286:	50                   	push   %eax
 287:	68 5c 0b 00 00       	push   $0xb5c
 28c:	6a 01                	push   $0x1
 28e:	e8 0d 04 00 00       	call   6a0 <printf>
    // //00000
    // printf(1,"arr4[0] : %c, arr4[10000]: %c, arr4[20000] : %c, arr4[30000] : %c, arr4[40000] : %c\n",arr4[0],arr4[10000],arr4[20000],arr4[30000],arr4[40000]);
    // //aaaaa


    swapstat(&read_time,&write_time);
 293:	83 c4 18             	add    $0x18,%esp
 296:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 299:	50                   	push   %eax
 29a:	8d 45 e0             	lea    -0x20(%ebp),%eax
 29d:	50                   	push   %eax
 29e:	e8 40 03 00 00       	call   5e3 <swapstat>
    printf(1,"read : %d, write : %d\n", read_time, write_time);
 2a3:	ff 75 e4             	pushl  -0x1c(%ebp)
 2a6:	ff 75 e0             	pushl  -0x20(%ebp)
 2a9:	68 3c 0a 00 00       	push   $0xa3c
 2ae:	6a 01                	push   $0x1
 2b0:	e8 eb 03 00 00       	call   6a0 <printf>

    free(arr1);
 2b5:	83 c4 14             	add    $0x14,%esp
 2b8:	56                   	push   %esi
 2b9:	e8 b2 05 00 00       	call   870 <free>
    free(arr2);
 2be:	89 1c 24             	mov    %ebx,(%esp)
 2c1:	e8 aa 05 00 00       	call   870 <free>

    exit();
 2c6:	e8 68 02 00 00       	call   533 <exit>
 2cb:	66 90                	xchg   %ax,%ax
 2cd:	66 90                	xchg   %ax,%ax
 2cf:	90                   	nop

000002d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d5:	31 c0                	xor    %eax,%eax
{
 2d7:	89 e5                	mov    %esp,%ebp
 2d9:	53                   	push   %ebx
 2da:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 2e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2e7:	83 c0 01             	add    $0x1,%eax
 2ea:	84 d2                	test   %dl,%dl
 2ec:	75 f2                	jne    2e0 <strcpy+0x10>
    ;
  return os;
}
 2ee:	89 c8                	mov    %ecx,%eax
 2f0:	5b                   	pop    %ebx
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    
 2f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000300 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 300:	f3 0f 1e fb          	endbr32 
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	53                   	push   %ebx
 308:	8b 4d 08             	mov    0x8(%ebp),%ecx
 30b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 30e:	0f b6 01             	movzbl (%ecx),%eax
 311:	0f b6 1a             	movzbl (%edx),%ebx
 314:	84 c0                	test   %al,%al
 316:	75 19                	jne    331 <strcmp+0x31>
 318:	eb 26                	jmp    340 <strcmp+0x40>
 31a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 320:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 324:	83 c1 01             	add    $0x1,%ecx
 327:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 32a:	0f b6 1a             	movzbl (%edx),%ebx
 32d:	84 c0                	test   %al,%al
 32f:	74 0f                	je     340 <strcmp+0x40>
 331:	38 d8                	cmp    %bl,%al
 333:	74 eb                	je     320 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 335:	29 d8                	sub    %ebx,%eax
}
 337:	5b                   	pop    %ebx
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    
 33a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 340:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 342:	29 d8                	sub    %ebx,%eax
}
 344:	5b                   	pop    %ebx
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
 347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34e:	66 90                	xchg   %ax,%ax

00000350 <strlen>:

uint
strlen(const char *s)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 35a:	80 3a 00             	cmpb   $0x0,(%edx)
 35d:	74 21                	je     380 <strlen+0x30>
 35f:	31 c0                	xor    %eax,%eax
 361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 368:	83 c0 01             	add    $0x1,%eax
 36b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 36f:	89 c1                	mov    %eax,%ecx
 371:	75 f5                	jne    368 <strlen+0x18>
    ;
  return n;
}
 373:	89 c8                	mov    %ecx,%eax
 375:	5d                   	pop    %ebp
 376:	c3                   	ret    
 377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 380:	31 c9                	xor    %ecx,%ecx
}
 382:	5d                   	pop    %ebp
 383:	89 c8                	mov    %ecx,%eax
 385:	c3                   	ret    
 386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38d:	8d 76 00             	lea    0x0(%esi),%esi

00000390 <memset>:

void*
memset(void *dst, int c, uint n)
{
 390:	f3 0f 1e fb          	endbr32 
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	57                   	push   %edi
 398:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 39b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	89 d7                	mov    %edx,%edi
 3a3:	fc                   	cld    
 3a4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3a6:	89 d0                	mov    %edx,%eax
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret    
 3ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3af:	90                   	nop

000003b0 <strchr>:

char*
strchr(const char *s, char c)
{
 3b0:	f3 0f 1e fb          	endbr32 
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3be:	0f b6 10             	movzbl (%eax),%edx
 3c1:	84 d2                	test   %dl,%dl
 3c3:	75 16                	jne    3db <strchr+0x2b>
 3c5:	eb 21                	jmp    3e8 <strchr+0x38>
 3c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ce:	66 90                	xchg   %ax,%ax
 3d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3d4:	83 c0 01             	add    $0x1,%eax
 3d7:	84 d2                	test   %dl,%dl
 3d9:	74 0d                	je     3e8 <strchr+0x38>
    if(*s == c)
 3db:	38 d1                	cmp    %dl,%cl
 3dd:	75 f1                	jne    3d0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 3df:	5d                   	pop    %ebp
 3e0:	c3                   	ret    
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3e8:	31 c0                	xor    %eax,%eax
}
 3ea:	5d                   	pop    %ebp
 3eb:	c3                   	ret    
 3ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003f0 <gets>:

char*
gets(char *buf, int max)
{
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	57                   	push   %edi
 3f8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f9:	31 f6                	xor    %esi,%esi
{
 3fb:	53                   	push   %ebx
 3fc:	89 f3                	mov    %esi,%ebx
 3fe:	83 ec 1c             	sub    $0x1c,%esp
 401:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 404:	eb 33                	jmp    439 <gets+0x49>
 406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 410:	83 ec 04             	sub    $0x4,%esp
 413:	8d 45 e7             	lea    -0x19(%ebp),%eax
 416:	6a 01                	push   $0x1
 418:	50                   	push   %eax
 419:	6a 00                	push   $0x0
 41b:	e8 2b 01 00 00       	call   54b <read>
    if(cc < 1)
 420:	83 c4 10             	add    $0x10,%esp
 423:	85 c0                	test   %eax,%eax
 425:	7e 1c                	jle    443 <gets+0x53>
      break;
    buf[i++] = c;
 427:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 42b:	83 c7 01             	add    $0x1,%edi
 42e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 431:	3c 0a                	cmp    $0xa,%al
 433:	74 23                	je     458 <gets+0x68>
 435:	3c 0d                	cmp    $0xd,%al
 437:	74 1f                	je     458 <gets+0x68>
  for(i=0; i+1 < max; ){
 439:	83 c3 01             	add    $0x1,%ebx
 43c:	89 fe                	mov    %edi,%esi
 43e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 441:	7c cd                	jl     410 <gets+0x20>
 443:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 445:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 448:	c6 03 00             	movb   $0x0,(%ebx)
}
 44b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44e:	5b                   	pop    %ebx
 44f:	5e                   	pop    %esi
 450:	5f                   	pop    %edi
 451:	5d                   	pop    %ebp
 452:	c3                   	ret    
 453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 457:	90                   	nop
 458:	8b 75 08             	mov    0x8(%ebp),%esi
 45b:	8b 45 08             	mov    0x8(%ebp),%eax
 45e:	01 de                	add    %ebx,%esi
 460:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 462:	c6 03 00             	movb   $0x0,(%ebx)
}
 465:	8d 65 f4             	lea    -0xc(%ebp),%esp
 468:	5b                   	pop    %ebx
 469:	5e                   	pop    %esi
 46a:	5f                   	pop    %edi
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    
 46d:	8d 76 00             	lea    0x0(%esi),%esi

00000470 <stat>:

int
stat(const char *n, struct stat *st)
{
 470:	f3 0f 1e fb          	endbr32 
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	56                   	push   %esi
 478:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 479:	83 ec 08             	sub    $0x8,%esp
 47c:	6a 00                	push   $0x0
 47e:	ff 75 08             	pushl  0x8(%ebp)
 481:	e8 ed 00 00 00       	call   573 <open>
  if(fd < 0)
 486:	83 c4 10             	add    $0x10,%esp
 489:	85 c0                	test   %eax,%eax
 48b:	78 2b                	js     4b8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 48d:	83 ec 08             	sub    $0x8,%esp
 490:	ff 75 0c             	pushl  0xc(%ebp)
 493:	89 c3                	mov    %eax,%ebx
 495:	50                   	push   %eax
 496:	e8 f0 00 00 00       	call   58b <fstat>
  close(fd);
 49b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 49e:	89 c6                	mov    %eax,%esi
  close(fd);
 4a0:	e8 b6 00 00 00       	call   55b <close>
  return r;
 4a5:	83 c4 10             	add    $0x10,%esp
}
 4a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4ab:	89 f0                	mov    %esi,%eax
 4ad:	5b                   	pop    %ebx
 4ae:	5e                   	pop    %esi
 4af:	5d                   	pop    %ebp
 4b0:	c3                   	ret    
 4b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 4b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4bd:	eb e9                	jmp    4a8 <stat+0x38>
 4bf:	90                   	nop

000004c0 <atoi>:

int
atoi(const char *s)
{
 4c0:	f3 0f 1e fb          	endbr32 
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	53                   	push   %ebx
 4c8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4cb:	0f be 02             	movsbl (%edx),%eax
 4ce:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4d1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4d9:	77 1a                	ja     4f5 <atoi+0x35>
 4db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop
    n = n*10 + *s++ - '0';
 4e0:	83 c2 01             	add    $0x1,%edx
 4e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4ea:	0f be 02             	movsbl (%edx),%eax
 4ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4f0:	80 fb 09             	cmp    $0x9,%bl
 4f3:	76 eb                	jbe    4e0 <atoi+0x20>
  return n;
}
 4f5:	89 c8                	mov    %ecx,%eax
 4f7:	5b                   	pop    %ebx
 4f8:	5d                   	pop    %ebp
 4f9:	c3                   	ret    
 4fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000500 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 500:	f3 0f 1e fb          	endbr32 
 504:	55                   	push   %ebp
 505:	89 e5                	mov    %esp,%ebp
 507:	57                   	push   %edi
 508:	8b 45 10             	mov    0x10(%ebp),%eax
 50b:	8b 55 08             	mov    0x8(%ebp),%edx
 50e:	56                   	push   %esi
 50f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 512:	85 c0                	test   %eax,%eax
 514:	7e 0f                	jle    525 <memmove+0x25>
 516:	01 d0                	add    %edx,%eax
  dst = vdst;
 518:	89 d7                	mov    %edx,%edi
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 520:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 521:	39 f8                	cmp    %edi,%eax
 523:	75 fb                	jne    520 <memmove+0x20>
  return vdst;
}
 525:	5e                   	pop    %esi
 526:	89 d0                	mov    %edx,%eax
 528:	5f                   	pop    %edi
 529:	5d                   	pop    %ebp
 52a:	c3                   	ret    

0000052b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 52b:	b8 01 00 00 00       	mov    $0x1,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <exit>:
SYSCALL(exit)
 533:	b8 02 00 00 00       	mov    $0x2,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <wait>:
SYSCALL(wait)
 53b:	b8 03 00 00 00       	mov    $0x3,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <pipe>:
SYSCALL(pipe)
 543:	b8 04 00 00 00       	mov    $0x4,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <read>:
SYSCALL(read)
 54b:	b8 05 00 00 00       	mov    $0x5,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <write>:
SYSCALL(write)
 553:	b8 10 00 00 00       	mov    $0x10,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <close>:
SYSCALL(close)
 55b:	b8 15 00 00 00       	mov    $0x15,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <kill>:
SYSCALL(kill)
 563:	b8 06 00 00 00       	mov    $0x6,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <exec>:
SYSCALL(exec)
 56b:	b8 07 00 00 00       	mov    $0x7,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <open>:
SYSCALL(open)
 573:	b8 0f 00 00 00       	mov    $0xf,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <mknod>:
SYSCALL(mknod)
 57b:	b8 11 00 00 00       	mov    $0x11,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <unlink>:
SYSCALL(unlink)
 583:	b8 12 00 00 00       	mov    $0x12,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <fstat>:
SYSCALL(fstat)
 58b:	b8 08 00 00 00       	mov    $0x8,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <link>:
SYSCALL(link)
 593:	b8 13 00 00 00       	mov    $0x13,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <mkdir>:
SYSCALL(mkdir)
 59b:	b8 14 00 00 00       	mov    $0x14,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <chdir>:
SYSCALL(chdir)
 5a3:	b8 09 00 00 00       	mov    $0x9,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <dup>:
SYSCALL(dup)
 5ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <getpid>:
SYSCALL(getpid)
 5b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <sbrk>:
SYSCALL(sbrk)
 5bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <sleep>:
SYSCALL(sleep)
 5c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <uptime>:
SYSCALL(uptime)
 5cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <swapread>:
SYSCALL(swapread)
 5d3:	b8 16 00 00 00       	mov    $0x16,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <swapwrite>:
SYSCALL(swapwrite)
 5db:	b8 17 00 00 00       	mov    $0x17,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <swapstat>:
SYSCALL(swapstat)
 5e3:	b8 18 00 00 00       	mov    $0x18,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    
 5eb:	66 90                	xchg   %ax,%ax
 5ed:	66 90                	xchg   %ax,%ax
 5ef:	90                   	nop

000005f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
 5f5:	53                   	push   %ebx
 5f6:	83 ec 3c             	sub    $0x3c,%esp
 5f9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5fc:	89 d1                	mov    %edx,%ecx
{
 5fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 601:	85 d2                	test   %edx,%edx
 603:	0f 89 7f 00 00 00    	jns    688 <printint+0x98>
 609:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 60d:	74 79                	je     688 <printint+0x98>
    neg = 1;
 60f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 616:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 618:	31 db                	xor    %ebx,%ebx
 61a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 620:	89 c8                	mov    %ecx,%eax
 622:	31 d2                	xor    %edx,%edx
 624:	89 cf                	mov    %ecx,%edi
 626:	f7 75 c4             	divl   -0x3c(%ebp)
 629:	0f b6 92 c0 0c 00 00 	movzbl 0xcc0(%edx),%edx
 630:	89 45 c0             	mov    %eax,-0x40(%ebp)
 633:	89 d8                	mov    %ebx,%eax
 635:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 638:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 63b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 63e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 641:	76 dd                	jbe    620 <printint+0x30>
  if(neg)
 643:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 646:	85 c9                	test   %ecx,%ecx
 648:	74 0c                	je     656 <printint+0x66>
    buf[i++] = '-';
 64a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 64f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 651:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 656:	8b 7d b8             	mov    -0x48(%ebp),%edi
 659:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 65d:	eb 07                	jmp    666 <printint+0x76>
 65f:	90                   	nop
 660:	0f b6 13             	movzbl (%ebx),%edx
 663:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 666:	83 ec 04             	sub    $0x4,%esp
 669:	88 55 d7             	mov    %dl,-0x29(%ebp)
 66c:	6a 01                	push   $0x1
 66e:	56                   	push   %esi
 66f:	57                   	push   %edi
 670:	e8 de fe ff ff       	call   553 <write>
  while(--i >= 0)
 675:	83 c4 10             	add    $0x10,%esp
 678:	39 de                	cmp    %ebx,%esi
 67a:	75 e4                	jne    660 <printint+0x70>
    putc(fd, buf[i]);
}
 67c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 67f:	5b                   	pop    %ebx
 680:	5e                   	pop    %esi
 681:	5f                   	pop    %edi
 682:	5d                   	pop    %ebp
 683:	c3                   	ret    
 684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 688:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 68f:	eb 87                	jmp    618 <printint+0x28>
 691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69f:	90                   	nop

000006a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6a0:	f3 0f 1e fb          	endbr32 
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	57                   	push   %edi
 6a8:	56                   	push   %esi
 6a9:	53                   	push   %ebx
 6aa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ad:	8b 75 0c             	mov    0xc(%ebp),%esi
 6b0:	0f b6 1e             	movzbl (%esi),%ebx
 6b3:	84 db                	test   %bl,%bl
 6b5:	0f 84 b4 00 00 00    	je     76f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 6bb:	8d 45 10             	lea    0x10(%ebp),%eax
 6be:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6c1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6c4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 6c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6c9:	eb 33                	jmp    6fe <printf+0x5e>
 6cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6cf:	90                   	nop
 6d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6d3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6d8:	83 f8 25             	cmp    $0x25,%eax
 6db:	74 17                	je     6f4 <printf+0x54>
  write(fd, &c, 1);
 6dd:	83 ec 04             	sub    $0x4,%esp
 6e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6e3:	6a 01                	push   $0x1
 6e5:	57                   	push   %edi
 6e6:	ff 75 08             	pushl  0x8(%ebp)
 6e9:	e8 65 fe ff ff       	call   553 <write>
 6ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6f1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6f4:	0f b6 1e             	movzbl (%esi),%ebx
 6f7:	83 c6 01             	add    $0x1,%esi
 6fa:	84 db                	test   %bl,%bl
 6fc:	74 71                	je     76f <printf+0xcf>
    c = fmt[i] & 0xff;
 6fe:	0f be cb             	movsbl %bl,%ecx
 701:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 704:	85 d2                	test   %edx,%edx
 706:	74 c8                	je     6d0 <printf+0x30>
      }
    } else if(state == '%'){
 708:	83 fa 25             	cmp    $0x25,%edx
 70b:	75 e7                	jne    6f4 <printf+0x54>
      if(c == 'd'){
 70d:	83 f8 64             	cmp    $0x64,%eax
 710:	0f 84 9a 00 00 00    	je     7b0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 716:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 71c:	83 f9 70             	cmp    $0x70,%ecx
 71f:	74 5f                	je     780 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 721:	83 f8 73             	cmp    $0x73,%eax
 724:	0f 84 d6 00 00 00    	je     800 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 72a:	83 f8 63             	cmp    $0x63,%eax
 72d:	0f 84 8d 00 00 00    	je     7c0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 733:	83 f8 25             	cmp    $0x25,%eax
 736:	0f 84 b4 00 00 00    	je     7f0 <printf+0x150>
  write(fd, &c, 1);
 73c:	83 ec 04             	sub    $0x4,%esp
 73f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 743:	6a 01                	push   $0x1
 745:	57                   	push   %edi
 746:	ff 75 08             	pushl  0x8(%ebp)
 749:	e8 05 fe ff ff       	call   553 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 74e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 751:	83 c4 0c             	add    $0xc,%esp
 754:	6a 01                	push   $0x1
 756:	83 c6 01             	add    $0x1,%esi
 759:	57                   	push   %edi
 75a:	ff 75 08             	pushl  0x8(%ebp)
 75d:	e8 f1 fd ff ff       	call   553 <write>
  for(i = 0; fmt[i]; i++){
 762:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 766:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 769:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 76b:	84 db                	test   %bl,%bl
 76d:	75 8f                	jne    6fe <printf+0x5e>
    }
  }
}
 76f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 772:	5b                   	pop    %ebx
 773:	5e                   	pop    %esi
 774:	5f                   	pop    %edi
 775:	5d                   	pop    %ebp
 776:	c3                   	ret    
 777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 10 00 00 00       	mov    $0x10,%ecx
 788:	6a 00                	push   $0x0
 78a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	8b 13                	mov    (%ebx),%edx
 792:	e8 59 fe ff ff       	call   5f0 <printint>
        ap++;
 797:	89 d8                	mov    %ebx,%eax
 799:	83 c4 10             	add    $0x10,%esp
      state = 0;
 79c:	31 d2                	xor    %edx,%edx
        ap++;
 79e:	83 c0 04             	add    $0x4,%eax
 7a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7a4:	e9 4b ff ff ff       	jmp    6f4 <printf+0x54>
 7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7b8:	6a 01                	push   $0x1
 7ba:	eb ce                	jmp    78a <printf+0xea>
 7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 7c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7c6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 7c8:	6a 01                	push   $0x1
        ap++;
 7ca:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 7cd:	57                   	push   %edi
 7ce:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 7d1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7d4:	e8 7a fd ff ff       	call   553 <write>
        ap++;
 7d9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7df:	31 d2                	xor    %edx,%edx
 7e1:	e9 0e ff ff ff       	jmp    6f4 <printf+0x54>
 7e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ed:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 7f0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7f3:	83 ec 04             	sub    $0x4,%esp
 7f6:	e9 59 ff ff ff       	jmp    754 <printf+0xb4>
 7fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ff:	90                   	nop
        s = (char*)*ap;
 800:	8b 45 d0             	mov    -0x30(%ebp),%eax
 803:	8b 18                	mov    (%eax),%ebx
        ap++;
 805:	83 c0 04             	add    $0x4,%eax
 808:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 80b:	85 db                	test   %ebx,%ebx
 80d:	74 17                	je     826 <printf+0x186>
        while(*s != 0){
 80f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 812:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 814:	84 c0                	test   %al,%al
 816:	0f 84 d8 fe ff ff    	je     6f4 <printf+0x54>
 81c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 81f:	89 de                	mov    %ebx,%esi
 821:	8b 5d 08             	mov    0x8(%ebp),%ebx
 824:	eb 1a                	jmp    840 <printf+0x1a0>
          s = "(null)";
 826:	bb b9 0c 00 00       	mov    $0xcb9,%ebx
        while(*s != 0){
 82b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 82e:	b8 28 00 00 00       	mov    $0x28,%eax
 833:	89 de                	mov    %ebx,%esi
 835:	8b 5d 08             	mov    0x8(%ebp),%ebx
 838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 83f:	90                   	nop
  write(fd, &c, 1);
 840:	83 ec 04             	sub    $0x4,%esp
          s++;
 843:	83 c6 01             	add    $0x1,%esi
 846:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 849:	6a 01                	push   $0x1
 84b:	57                   	push   %edi
 84c:	53                   	push   %ebx
 84d:	e8 01 fd ff ff       	call   553 <write>
        while(*s != 0){
 852:	0f b6 06             	movzbl (%esi),%eax
 855:	83 c4 10             	add    $0x10,%esp
 858:	84 c0                	test   %al,%al
 85a:	75 e4                	jne    840 <printf+0x1a0>
 85c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 85f:	31 d2                	xor    %edx,%edx
 861:	e9 8e fe ff ff       	jmp    6f4 <printf+0x54>
 866:	66 90                	xchg   %ax,%ax
 868:	66 90                	xchg   %ax,%ax
 86a:	66 90                	xchg   %ax,%ax
 86c:	66 90                	xchg   %ax,%ax
 86e:	66 90                	xchg   %ax,%ax

00000870 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 870:	f3 0f 1e fb          	endbr32 
 874:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 875:	a1 74 0f 00 00       	mov    0xf74,%eax
{
 87a:	89 e5                	mov    %esp,%ebp
 87c:	57                   	push   %edi
 87d:	56                   	push   %esi
 87e:	53                   	push   %ebx
 87f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 882:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 884:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 887:	39 c8                	cmp    %ecx,%eax
 889:	73 15                	jae    8a0 <free+0x30>
 88b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 88f:	90                   	nop
 890:	39 d1                	cmp    %edx,%ecx
 892:	72 14                	jb     8a8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	39 d0                	cmp    %edx,%eax
 896:	73 10                	jae    8a8 <free+0x38>
{
 898:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89a:	8b 10                	mov    (%eax),%edx
 89c:	39 c8                	cmp    %ecx,%eax
 89e:	72 f0                	jb     890 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	39 d0                	cmp    %edx,%eax
 8a2:	72 f4                	jb     898 <free+0x28>
 8a4:	39 d1                	cmp    %edx,%ecx
 8a6:	73 f0                	jae    898 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ae:	39 fa                	cmp    %edi,%edx
 8b0:	74 1e                	je     8d0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8b5:	8b 50 04             	mov    0x4(%eax),%edx
 8b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8bb:	39 f1                	cmp    %esi,%ecx
 8bd:	74 28                	je     8e7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 8c1:	5b                   	pop    %ebx
  freep = p;
 8c2:	a3 74 0f 00 00       	mov    %eax,0xf74
}
 8c7:	5e                   	pop    %esi
 8c8:	5f                   	pop    %edi
 8c9:	5d                   	pop    %ebp
 8ca:	c3                   	ret    
 8cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8cf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 8d0:	03 72 04             	add    0x4(%edx),%esi
 8d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d6:	8b 10                	mov    (%eax),%edx
 8d8:	8b 12                	mov    (%edx),%edx
 8da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8dd:	8b 50 04             	mov    0x4(%eax),%edx
 8e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8e3:	39 f1                	cmp    %esi,%ecx
 8e5:	75 d8                	jne    8bf <free+0x4f>
    p->s.size += bp->s.size;
 8e7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 8ea:	a3 74 0f 00 00       	mov    %eax,0xf74
    p->s.size += bp->s.size;
 8ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8f2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8f5:	89 10                	mov    %edx,(%eax)
}
 8f7:	5b                   	pop    %ebx
 8f8:	5e                   	pop    %esi
 8f9:	5f                   	pop    %edi
 8fa:	5d                   	pop    %ebp
 8fb:	c3                   	ret    
 8fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000900 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 900:	f3 0f 1e fb          	endbr32 
 904:	55                   	push   %ebp
 905:	89 e5                	mov    %esp,%ebp
 907:	57                   	push   %edi
 908:	56                   	push   %esi
 909:	53                   	push   %ebx
 90a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 910:	8b 3d 74 0f 00 00    	mov    0xf74,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 916:	8d 70 07             	lea    0x7(%eax),%esi
 919:	c1 ee 03             	shr    $0x3,%esi
 91c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 91f:	85 ff                	test   %edi,%edi
 921:	0f 84 a9 00 00 00    	je     9d0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 927:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 929:	8b 48 04             	mov    0x4(%eax),%ecx
 92c:	39 f1                	cmp    %esi,%ecx
 92e:	73 6d                	jae    99d <malloc+0x9d>
 930:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 936:	bb 00 10 00 00       	mov    $0x1000,%ebx
 93b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 93e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 945:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 948:	eb 17                	jmp    961 <malloc+0x61>
 94a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 952:	8b 4a 04             	mov    0x4(%edx),%ecx
 955:	39 f1                	cmp    %esi,%ecx
 957:	73 4f                	jae    9a8 <malloc+0xa8>
 959:	8b 3d 74 0f 00 00    	mov    0xf74,%edi
 95f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 961:	39 c7                	cmp    %eax,%edi
 963:	75 eb                	jne    950 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 965:	83 ec 0c             	sub    $0xc,%esp
 968:	ff 75 e4             	pushl  -0x1c(%ebp)
 96b:	e8 4b fc ff ff       	call   5bb <sbrk>
  if(p == (char*)-1)
 970:	83 c4 10             	add    $0x10,%esp
 973:	83 f8 ff             	cmp    $0xffffffff,%eax
 976:	74 1b                	je     993 <malloc+0x93>
  hp->s.size = nu;
 978:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 97b:	83 ec 0c             	sub    $0xc,%esp
 97e:	83 c0 08             	add    $0x8,%eax
 981:	50                   	push   %eax
 982:	e8 e9 fe ff ff       	call   870 <free>
  return freep;
 987:	a1 74 0f 00 00       	mov    0xf74,%eax
      if((p = morecore(nunits)) == 0)
 98c:	83 c4 10             	add    $0x10,%esp
 98f:	85 c0                	test   %eax,%eax
 991:	75 bd                	jne    950 <malloc+0x50>
        return 0;
  }
}
 993:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 996:	31 c0                	xor    %eax,%eax
}
 998:	5b                   	pop    %ebx
 999:	5e                   	pop    %esi
 99a:	5f                   	pop    %edi
 99b:	5d                   	pop    %ebp
 99c:	c3                   	ret    
    if(p->s.size >= nunits){
 99d:	89 c2                	mov    %eax,%edx
 99f:	89 f8                	mov    %edi,%eax
 9a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 9a8:	39 ce                	cmp    %ecx,%esi
 9aa:	74 54                	je     a00 <malloc+0x100>
        p->s.size -= nunits;
 9ac:	29 f1                	sub    %esi,%ecx
 9ae:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 9b1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 9b4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 9b7:	a3 74 0f 00 00       	mov    %eax,0xf74
}
 9bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9bf:	8d 42 08             	lea    0x8(%edx),%eax
}
 9c2:	5b                   	pop    %ebx
 9c3:	5e                   	pop    %esi
 9c4:	5f                   	pop    %edi
 9c5:	5d                   	pop    %ebp
 9c6:	c3                   	ret    
 9c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ce:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 9d0:	c7 05 74 0f 00 00 78 	movl   $0xf78,0xf74
 9d7:	0f 00 00 
    base.s.size = 0;
 9da:	bf 78 0f 00 00       	mov    $0xf78,%edi
    base.s.ptr = freep = prevp = &base;
 9df:	c7 05 78 0f 00 00 78 	movl   $0xf78,0xf78
 9e6:	0f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 9eb:	c7 05 7c 0f 00 00 00 	movl   $0x0,0xf7c
 9f2:	00 00 00 
    if(p->s.size >= nunits){
 9f5:	e9 36 ff ff ff       	jmp    930 <malloc+0x30>
 9fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a00:	8b 0a                	mov    (%edx),%ecx
 a02:	89 08                	mov    %ecx,(%eax)
 a04:	eb b1                	jmp    9b7 <malloc+0xb7>
