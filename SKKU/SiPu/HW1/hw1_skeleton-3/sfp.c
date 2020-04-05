#include "sfp.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef union{
    int i;
    struct{
        unsigned num;
        unsigned sign;
    }raw;
}myint;

typedef union {//float 원큐에 파싱하는 용도
    float f;
    struct{
        unsigned frac;
        unsigned exp;
        unsigned sign;
    }raw;
}myfloat;

/*
32비트 int를 sfp로 바꾸는 함수.
sfp의 범위를 초과한다면 양 또는 음의 무한을 반환. 무한의 부호는 중요하다.
round toward zero 가 요구된다.
0의 경우, 양의 0.0으로 변환하라
*/
sfp int2sfp(int input){
    unsigned bias=63;
    unsigned sign=0; unsigned exp=0; unsigned frac=0;
    unsigned ret=0;
    // if(범위초과)
    //     return NaN;
    (input<0)?(sign=1):(sign=0);
    if(sign){

    }
    else{//0 또는 양의 정수라면
        myint parsed = (myint)input;
        frac=parsed.raw.num;
    }
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
    if(exp==0||exp==127){//exp가 전부 0이거나 전부 1(7bit)인 경우는 따로 처리해야한다.

    }
    else{

    }
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
