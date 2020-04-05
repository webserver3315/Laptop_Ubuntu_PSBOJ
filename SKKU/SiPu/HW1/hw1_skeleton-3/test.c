#include <stdio.h>

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
    float f;
    struct{
        unsigned frac : 23;
        unsigned exp : 8;
        unsigned sign : 1;
    }raw;
}myfloat;

int fraclength(int n, int x){//x is n's fraclength -> 1:true, 0:false, for int to sfp
    int lbound=1; lbound<<=x;//이상
    int rbound=1; rbound<<=(x+1);//미만
    if(lbound<=n && n<rbound) return 1;
    else return 0;
}

int getfraclength(int n){
    for(int i=1;i<32;i++){
        if(fraclength(n, i)) return i;
    }
    return -1;
}

unsigned getfracbit(int n, int s){
    unsigned u = n;
    u<<=(16-s);//frac은 16비트이므로 이렇게 밀면 된다.
    return u;
}

/*
32비트 int를 sfp로 바꾸는 함수.
sfp의 범위를 초과한다면 양 또는 음의 무한을 반환. 무한의 부호는 중요하다.
round toward zero 가 요구된다.
0의 경우, 양의 0.0으로 변환하라
*/
sfp int2sfp(int input){
    unsigned bias=63;
    unsigned sign=0; unsigned exp=0; unsigned frac=0;
    mysfp ret;
    // if(범위초과)
    //     return NaN;
    (input<0)?(sign=1):(sign=0);
    if(sign){

    }
    else{//0 또는 양의 정수라면, 우선 frac를 얻고 exp를 얻은 뒤 합성하면 끝.
        int shiftnum=getfraclength(input);//leading 1 제외한 frac 자릿수
        //exp는 2^(shiftnum+bias), frac는 input을 좌로 32-s비트, 우로 32-s비트 한 것.
        // exp=1; exp<<=(shiftnum); exp+=63;
        exp=shiftnum+63;
        frac=getfracbit(input,shiftnum);
        printf("exp bit is= %d\n",exp);
        printf("getfracbit return val = %d\n",frac);
        mysfp ret;
        // ret.raw.dummy=0; ret.raw.sign=sign; ret.raw.exp=exp; ret.raw.frac=frac;
        ret.raw.sign=sign; ret.raw.exp=exp; ret.raw.frac=frac;
        return ret.s;
        //오버플로우는 따로 처리할 것
    }
}

int main(){
    int n;
    scanf("%d",&n);
    printf("fraclength = %d",getfraclength(n));
    printf("    INT   "U32_TO_BIN_P" is converted into SFP   "U24_TO_BIN_P"\n",
		 	U32_TO_BIN(n), U24_TO_BIN(int2sfp(n)));
    return 0;
}