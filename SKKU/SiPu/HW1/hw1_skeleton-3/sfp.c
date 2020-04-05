#include "sfp.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define TMin (int)-2147483648
#define TMax (int)2147483647

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

int fraclength2(int n, int x){//x is n's fraclength -> 1:true, 0:false, for int to sfp
    int lbound=0;
    if(x>0) lbound<<=x;//이상
    int rbound=1; rbound<<=(x+1);//미만
    if(lbound<=n && n<rbound) return 1;
    else return 0;
}

int fraclength(unsigned n, unsigned x){//x is n's fraclength -> 1:true, 0:false, for int to sfp
    unsigned lbound=0; lbound<<=x;//이상
    unsigned rbound=1; rbound<<=(x+1);//미만
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
    int shiftnum;
    mysfp ret;
    // if(범위초과)
    //     return NaN;
    sign=input<0;
    if(input==0){
        ret.raw.sign=0; ret.raw.exp=0; ret.raw.frac=0;
        return ret.s;
    }
    //if(input이 오버플로우일 때)
    if(sign) input=(~input)+1;//음수면 input에 -1 곱해주기

    if(input==1) shiftnum=0;//1이면 특수처리
    else shiftnum=getfraclength(input);

    exp=shiftnum+63;
    frac=getfracbit(input,shiftnum);
    ret.raw.sign=sign; ret.raw.exp=exp; ret.raw.frac=frac;
    //오버플로우는 따로 처리할 것

    return ret.s;
}

/*
sfp를 32비트 int로 바꾸는 함수.
양의 무한과 음의 무한은 각각 TMax, TMin 으로 변환된다.
TMax와 TMin은 int형의 최대 및 최소값이다.
양 또는 음의 NaN값이라면 무조건 TMin으로 변환하라
round toward zero를 사용하라.
*/
int sfp2int(sfp input){
    unsigned bias=63;
    unsigned sign=0; unsigned exp=0; unsigned frac=0;
    mysfp ms=(mysfp)input;
    myint ret;

    sign=ms.raw.sign; exp=ms.raw.exp; frac=ms.raw.frac;
    ret.raw.sign=sign;

    if(exp==0){//denorm이면 무조건 정수때릴때 0이다.
        ret=(myint)0;
        return ret.i;
    }
    else if(exp<0b0111111){//denorm 아닌데 소수일 경우
        ret=(myint)0;
        return ret.i;
    }
    else if(exp==127){//특수케이스 - exp가 전부 1
        if(frac==0 && sign==0){//양의 무한
            ret=(myint)TMax;
        }
        else if(frac==0 && sign!=0){//음의 무한
            ret=(myint)TMin;
        }
        else{//frac!=0 -> NaN은 부호불문 TMin으로 바꾸라고 되어있다.
            ret=(myint)TMin;
        }
        return ret.i;
    }
    else{
        exp-=63;
        frac>>=16-exp;
        unsigned leading1=1<<exp;
        frac+=leading1;
        if(sign){
            frac=(~frac)+1;
        }
        ret.raw.num=frac;
    }
    return ret.i;
}

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

/*
두 sfp형을 더한다.
두 개의 sfp 타입이 input으로 주어지며, 결과 또한 sfp
add 연산 이전에, 더 작은 sfp 변수를 right shift 해야한다.
만일 이 과정에서 몇몇 비트가 fraction의 범위를 초과한다면, round toward even을 사용하라.
함수 내부에서 sfp를 float나 double로 바꾸는 것은 금지되어있다.
round to even을 최종적으로 한 번 더 사용하라.
*/
sfp sfp_add(sfp in1, sfp in2){
}

/*
두 sfp형을 더한다.
두 개의 sfp 타입이 input을 주어지며, 결과 또한 sfp
fraction part를 계산하는데, unsigned long long이나 double 같은 64비트 자료형을 이용해도 된다.
계산 뒤, 정규화는 round toward even 을 통해서 구현한다.
sfp를 초과하는 결과에 대해서는, 결과를 양 도는 음의 무한으로 구현한다. 부호는 중요하다.
sfp를 float나 double로 바꾸는 것은 역시 금지되어있다.
*/
sfp sfp_mul(sfp in1, sfp in2){
}
