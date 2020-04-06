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
    unsigned long long ull;
    struct{
        unsigned frac : 16;
        unsigned leading1 : 1;
        unsigned dummy : 14;
        unsigned sign : 1;
        // unsigned dummy : 8;
    }raw;
}myll;

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
    myfloat mf; mf.f=input;
    mysfp ret;
    unsigned sign=mf.raw.sign; unsigned exp=mf.raw.exp; unsigned frac=mf.raw.frac;

    ret.raw.sign=sign;
    if(exp==255){//exp가 all 1 이면
        if(frac==0){//무한
            ret.raw.exp=127; ret.raw.frac=0;
        }
        else{//NaN
            ret.raw.exp=127; ret.raw.frac=1;
        }
    }
    else if(exp==0){//denormal이면
        ret.raw.exp=0;
        frac>>=7;
        ret.raw.frac=frac;
    }
    else if(exp>=190){//오버플로우
        ret.raw.exp=0b1111111; ret.raw.frac=0;
    }
    else if(exp<64){
        ret.raw.exp=0; ret.raw.frac=0;
    }
    else{
        exp-=64;
        frac>>=7;
        ret.raw.sign=sign; ret.raw.exp=exp; ret.raw.frac=frac;
    }
    return ret.s;
}

/*
sfp를 float로 바꾸는 함수.
에러의 여지는 없다. float가 sfp의 범위를 전부 커버하기 때문.
*/
float sfp2float(sfp input){
    mysfp ms; ms.s=input;
    myfloat ret;
    unsigned sign=ms.raw.sign; unsigned exp=ms.raw.exp; unsigned frac=ms.raw.frac;

    ret.raw.sign=sign;
    if(exp==0){
        ret.raw.exp=exp;
        frac<<=7;
        ret.raw.frac=frac;
    }
    else{
        exp+=64;
        frac<<=7;
        ret.raw.exp=exp; ret.raw.frac=frac;
    }
    return ret.f;
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
    mysfp ms1, ms2, ret;
    if(in1>in2){
        ms1.s=in1; ms2.s=in2;
    }
    else{
        ms1.s=in2; ms2.s=in1;
    }
    ret.raw.exp=ms1.raw.exp+ms2.raw.exp-63;
    unsigned signif1=ms1.raw.frac|(1<<16); unsigned signif2=ms2.raw.frac|(1<<16);
    unsigned long long signif=(unsigned long long)signif1*signif2;
    //GSB 따져야한다.
    unsigned G, R, S;
    G=(1<<16)&signif; R=(1<<15)&signif; S=((1<<15)-1)&signif;
    //R이 1이고 S가 0이라면 R2E에 따라 고민필요. G 참조해서 올릴지 말지 결정
    //R이 1이고 S가 1이면 무조건 올림
    //R이 0이라면 걍 버림.
    if(R==0){
        signif>>=16;
    }
    else{
        if(S==0){//고민필요
            signif>>=16;
            if(G!=0){
                signif++;
            }
        }
        else{
            signif>>=16;
            signif++;
        }
    }
    if(signif>=(1<<17)){
        //이 때의 right shift도 round to even 적용
        if(signif&1){
            if(signif&2){
                signif++;
            }
        }
        signif>>=1;
        ret.raw.exp++;
    }
    while(signif<(1<<16)){
        signif<<=1;
        ret.raw.exp--;
    }

    if(ret.raw.exp<=0 || ret.raw.exp>=(1<<7)-1){//<=0의 경우는 추가고려가 일단은 필요
        //exponent Overflow
        ret.raw.exp=(1<<7)-1;
        ret.raw.frac=0;
        return ret.s;
    }
    signif&=(0xFFFF);//leading 1 제거
    ret.raw.frac=signif;
    return ret.s;
}

/*
두 sfp형을 더한다.
두 개의 sfp 타입이 input을 주어지며, 결과 또한 sfp
fraction part를 계산하는데, unsigned long long이나 double 같은 64비트 자료형을 이용해도 된다.
계산 뒤, 정규화는 round toward even 을 통해서 구현한다.
sfp를 초과하는 결과에 대해서는, 결과를 양 도는 음의 무한으로 구현한다. 부호는 중요하다.
sfp를 float나 double로 바꾸는 것은 역시 금지되어있다.
*/
sfp sfp_mul(sfp in1, sfp in2){//만약 이게 denormal간의 연산이면 어케할지 따로 구현해야한다.
    mysfp ms1, ms2, ret;
    unsigned signif1, signif2;
    if(in1>in2){
        ms1.s=in1; ms2.s=in2;
    }
    else{
        ms1.s=in2; ms2.s=in1;
    }
    ret.raw.sign=ms1.raw.sign^ms2.raw.sign;
    ret.raw.exp=ms1.raw.exp+ms2.raw.exp-63;
    if(ms1.raw.exp) signif1=ms1.raw.frac|(1<<16);//denormal이면 leading 1 없으므로 따로 처리
    else signif1=ms1.raw.frac;
    if(ms2.raw.exp) signif2=ms2.raw.frac|(1<<16);
    else signif2=ms2.raw.frac;
    unsigned long long signif=(unsigned long long)signif1*signif2;
    //GSB 따져야한다.
    unsigned G, R, S;
    G=(1<<16)&signif; R=(1<<15)&signif; S=((1<<15)-1)&signif;
    //R이 1이고 S가 0이라면 R2E에 따라 고민필요. G 참조해서 올릴지 말지 결정
    //R이 1이고 S가 1이면 무조건 올림
    //R이 0이라면 걍 버림.
    if(R==0){
        signif>>=16;
    }
    else{
        if(S==0){//고민필요
            signif>>=16;
            if(G!=0){
                signif++;
            }
        }
        else{
            signif>>=16;
            signif++;
        }
    }
    if(signif>=(1<<17)){
        //이 때의 right shift도 round to even 적용
        if(signif&1){
            if(signif&2){
                signif++;
            }
        }
        signif>>=1;
        ret.raw.exp++;
    }
    while(signif<(1<<16)){
        signif<<=1;
        ret.raw.exp--;
    }

    if(ret.raw.exp<=0 || ret.raw.exp>=(1<<7)-1){//<=0의 경우는 추가고려가 일단은 필요
        //exponent Overflow
        ret.raw.exp=(1<<7)-1;
        ret.raw.frac=0;
        return ret.s;
    }
    signif&=(0xFFFF);//leading 1 제거
    ret.raw.frac=signif;
    return ret.s;
}


int main(){
    char type[2];
	int input_i[2];
	union _union{
		unsigned int ui;
		float f;
	} input_f[2];
	sfp input_sfp[2];
	sfp add_sfp;
	sfp mul_sfp;

	scanf("%c ", &type[0]);
	if (type[0] == 'i') {
		scanf("%d ", &input_i[0]);
	} else if (type[0] == 'f') {
		scanf("%f ", &input_f[0].f);
	} else{
		printf("Invalid type - 1\n");
		return 0;
	}

	scanf("%c ", &type[1]);
	if (type[1] == 'i')
		scanf("%d", &input_i[1]);
	else if (type[1] == 'f')
		scanf("%f", &input_f[1].f);
	else{
		printf("Invalid type - 2\n");
		return 0;
	}

	printf("[ Test 1: Type Conversion ]\n");

	if(type[0] == 'i') 
		input_sfp[0] = int2sfp(input_i[0]);
	else 
		input_sfp[0] = float2sfp(input_f[0].f);

	if(type[1] == 'i') 
		input_sfp[1] = int2sfp(input_i[1]);
	else 
		input_sfp[1] = float2sfp(input_f[1].f);

	if(type[0] == 'i') 
		printf("    INT   "U32_TO_BIN_P" is converted into SFP   "U24_TO_BIN_P"\n",
			 U32_TO_BIN(input_i[0]), U24_TO_BIN(input_sfp[0]));
	else 
		printf("    FLOAT "U32_TO_BIN_P" is converted into SFP   "U24_TO_BIN_P"\n",
			 U32_TO_BIN(input_f[0].ui), U24_TO_BIN(input_sfp[0]));

	if(type[1] == 'i') 
		printf("    INT   "U32_TO_BIN_P" is converted into SFP   "U24_TO_BIN_P"\n",
		 	U32_TO_BIN(input_i[1]), U24_TO_BIN(input_sfp[1]));
	else 
		printf("    FLOAT "U32_TO_BIN_P" is converted into SFP   "U24_TO_BIN_P"\n",
			 U32_TO_BIN(input_f[1].ui), U24_TO_BIN(input_sfp[1]));

	if(type[0] == 'i') 
		input_i[0] = sfp2int(input_sfp[0]);
	else 
		input_f[0].f = sfp2float(input_sfp[0]);

	if(type[1] == 'i') 
		input_i[1] = sfp2int(input_sfp[1]);
	else 
		input_f[1].f = sfp2float(input_sfp[1]);

	if(type[0] == 'i') 
		printf("    SFP   "U24_TO_BIN_P" is converted into INT   "U32_TO_BIN_P"\n", 
			U24_TO_BIN(input_sfp[0]), U32_TO_BIN(input_i[0]));
	else 
		printf("    SFP   "U24_TO_BIN_P" is converted into FLOAT "U32_TO_BIN_P"\n", 
			U24_TO_BIN(input_sfp[0]), U32_TO_BIN(input_f[0].ui));

	if(type[1] == 'i') 
		printf("    SFP   "U24_TO_BIN_P" is converted into INT   "U32_TO_BIN_P"\n", 
			U24_TO_BIN(input_sfp[1]), U32_TO_BIN(input_i[1]));
	else 
		printf("    SFP   "U24_TO_BIN_P" is converted into FLOAT "U32_TO_BIN_P"\n",
			 U24_TO_BIN(input_sfp[1]), U32_TO_BIN(input_f[1].ui));

	printf("\n[ Test 2: Addition ]\n");

	add_sfp = sfp_add(input_sfp[0], input_sfp[1]);
	printf("    "U24_TO_BIN_P" + "U24_TO_BIN_P" = "U24_TO_BIN_P"\n",
		 U24_TO_BIN(input_sfp[0]), U24_TO_BIN(input_sfp[1]), U24_TO_BIN(add_sfp));

	printf("\n[ Test 3: Multiplication ]\n");

	mul_sfp = sfp_mul(input_sfp[0], input_sfp[1]);
	printf("    "U24_TO_BIN_P" * "U24_TO_BIN_P" = "U24_TO_BIN_P"\n",
		U24_TO_BIN(input_sfp[0]), U24_TO_BIN(input_sfp[1]), U24_TO_BIN(mul_sfp));

	return 0;
}