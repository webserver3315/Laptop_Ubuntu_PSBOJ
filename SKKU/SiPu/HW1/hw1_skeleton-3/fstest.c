#include <stdio.h>
#define TMin (int)-2147483648
#define TMax (int)2147483647
/* TO BIN */
#define BYTE_TO_BIN(byte) \
(byte & 0x0080 ? '1' : '0'), (byte & 0x0040 ? '1' : '0'), \
(byte & 0x0020 ? '1' : '0'), (byte & 0x0010 ? '1' : '0'), \
(byte & 0x0008 ? '1' : '0'), (byte & 0x0004 ? '1' : '0'), \
(byte & 0x0002 ? '1' : '0'), (byte & 0x0001 ? '1' : '0')

#define U16_TO_BIN(var) BYTE_TO_BIN(var>>8), BYTE_TO_BIN(var)
#define U24_TO_BIN(var) BYTE_TO_BIN(var>>16),U16_TO_BIN(var)
#define U32_TO_BIN(var) U16_TO_BIN(var>>16), U16_TO_BIN(var)

/* PRINT P */
#define BYTE_TO_BIN_P "%c%c%c%c%c%c%c%c"
#define U16_TO_BIN_P  BYTE_TO_BIN_P"_"BYTE_TO_BIN_P
#define U24_TO_BIN_P  BYTE_TO_BIN_P"_"U16_TO_BIN_P
#define U32_TO_BIN_P  U16_TO_BIN_P"_"U16_TO_BIN_P

typedef unsigned int sfp;

typedef union{
    unsigned u;
    sfp s;
    struct{
        unsigned frac : 16;
        unsigned exp : 7;
        unsigned sign : 1;
        // unsigned dummy : 8;
    }raw;
}mysfp;

typedef union{
    int i;
    struct{
        unsigned num : 31;
        unsigned sign : 1;
    }raw;
}myint;

typedef union {//float 원큐에 파싱하는 용도
    unsigned u;
    float f;
    struct{
        unsigned frac : 23;
        unsigned exp : 8;
        unsigned sign : 1;
    }raw;
}myfloat;


/*
float를 sfp로 바꾸는 함수.
예외의 경우 처리는 int2sfp를 따른다.
*/
sfp float2sfp(float input){
}

/*
sfp를 float로 바꾸는 함수.
에러의 여지는 없다. float가 sfp의 범위를 전부 커버하기 때문.
*/
float sfp2float(sfp input){
}

int main(){
    int n;
    scanf("%d",&n);
    sfp s=int2sfp(n);
    int n2=sfp2int(s);

    printf("    INT   "U32_TO_BIN_P" is converted into SFP   "U24_TO_BIN_P"\n",
		 	U32_TO_BIN(n), U24_TO_BIN(int2sfp(n)));
    printf("    SFP   "U24_TO_BIN_P" is converted into INT   "U32_TO_BIN_P"\n", 
			U24_TO_BIN(s), U32_TO_BIN(sfp2int(s)));
    return 0;
}