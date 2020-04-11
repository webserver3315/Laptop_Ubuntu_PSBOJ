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
32비트 int를 sfp로 바꾸는 함수.X
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

    if(exp==0){//denormalized면 무조건 정수때릴때 1 미만이므로 0이다.
        ret=(myint)0;
        return ret.i;
    }
    else if(exp==0b0111111){//전부 1이면
        if(frac==0){
            if(sign) return TMax;
            else return TMin;
        }
        else{
            return TMin;
        }
    }
    else if(exp<0b0111111){//denorm 아닌데 소수일 경우도 0이다.
        ret=(myint)0;
        return ret.i;
    }
    else{
        exp-=63;//exp는 무조건 0 아니면 양수임이 보장
        if(32<=exp){
            ret=(myint)TMax;
            return ret.i;
        }
        if(exp<=16) frac>>=16-exp;
        else frac>>=16;
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
    if(exp==255){//exp가 all 1 이면 문답무용 무한이나 비숫자
        if(frac==0){//무한
            ret.raw.exp=127; ret.raw.frac=0;
        }
        else{//NaN
            ret.raw.exp=127; ret.raw.frac=1;
        }
        return ret.s;
    }
    if(exp==0&&frac==0){
        ret.raw.exp=exp; ret.raw.frac=frac;
        return ret.s;
    }

    if(exp>=190){//오버플로우
        ret.raw.exp=0b1111111; ret.raw.frac=0;
    }
    else if(exp==64){//normal float -> denormal sfp이면
        ret.raw.exp=0;
        frac>>=8;
        frac|=(1<<15);//denormal이므로 frac에 leading 1 포함시켜야됨
        ret.raw.frac=frac;
    }
    else if(exp<64){//언더플로우는 0을 리턴시킨다.
        ret.raw.exp=0; ret.raw.frac=0;
    }
    else{
        exp-=64;
        frac>>=7;
        ret.raw.exp=exp; ret.raw.frac=frac;
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
    ret.raw.sign=ms.raw.sign; ret.raw.exp=ms.raw.exp; ret.raw.frac=ms.raw.frac;
    if(ms.raw.exp==0){//denormal -> normal로 가는 예외적 경우와 denormal -> denormal 인 경우를 구분해야한다
        //denormal sfp-> denormal float 이 되는 경우는 존재하지 않는다.
        if(ms.raw.frac==0){
            return ret.f;//진또 0
        }
        ret.raw.exp=64;
        unsigned signif=ret.raw.frac;
        signif<<=8;
        while(0==(signif&(1<<23))){
            signif<<=1;
            ret.raw.exp--;
            // printf("[Tracking] SFP is "U24_TO_BIN_P", FLOAT is "U32_TO_BIN_P"\n", U24_TO_BIN(ms.s), U32_TO_BIN(ret.u));
        }
        ret.raw.frac=signif;
    }
    else{
        ret.raw.exp+=64;
        ret.raw.frac<<=7;
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
sfp sfp_add(sfp in1, sfp in2){//NaN 다루는 것도 구현할 필요가 있을 것 같다. 0이랑 연산도 곱과 같이 디버깅해야함
    mysfp ms1, ms2, ret;
    ms1.s=in1; ms2.s=in2;
    //Special Value 예외처리(exp==all1)
    if(ms1.raw.exp==0b1111111){//ms1 이 특수값이면
        if(ms1.raw.frac==0){
            if(ms1.raw.sign){//ms1이 음의 무한이면
                if(ms2.raw.sign==0&&ms2.raw.exp==0b1111111&&ms2.raw.frac==0){//음 양 무한 더하면 NaN
                    ret.raw.sign=0; ret.raw.exp=0b1111111; ret.raw.frac=1; return ret.s;
                }
                else{//그 외엔 무조건 음의 무한
                    ret.raw.sign=ms1.raw.sign; ret.raw.exp=0b1111111; ret.raw.frac=0; return ret.s;
                }
            }
            else{//ms1이 양의 무한이면
                if(ms2.raw.sign==1&&ms2.raw.exp==0b1111111&&ms2.raw.frac==0){//양 음 무한 더하면 NaN
                    ret.raw.sign=0; ret.raw.exp=0b1111111; ret.raw.frac=1; return ret.s;
                }
                else{//그 외엔 무조건 양의 무한
                    ret.raw.sign=ms1.raw.sign; ret.raw.exp=0b1111111; ret.raw.frac=0; return ret.s;
                }
            }
        }
        else{//ms1이 NaN이면
            return ms1.s;//걍 NaN반환
        }
    }
    if(ms2.raw.exp==0b1111111){//ms1이 특수값이 아니면서 ms2가 특수값이면
        if(ms2.raw.frac==0){//ms1이 특수값이 아니므로 무조건 ms2 부호따른 무한값
            ret.raw.sign=ms2.raw.sign; ret.raw.exp=0b1111111; ret.raw.frac=0; return ret.s;
        }
        else return ms2.s;//NaN이면 걍 NaN 반환
    }

    //대소비교
    mysfp tmp1, tmp2;
    tmp1.s=in1; tmp2.s=in2;
    if(tmp1.raw.sign) tmp1.raw.sign=0; else tmp1.raw.sign=1;//비교편의상 양수일 경우 sign=1이도록 변경
    if(tmp2.raw.sign) tmp2.raw.sign=0; else tmp2.raw.sign=1;
    if(tmp1.u>tmp2.u){
        ms1.s=in1; ms2.s=in2;
    }
    else{
        ms1.s=in2; ms2.s=in1;
    }

    unsigned shiftnum=ms1.raw.exp-ms2.raw.exp;//16-shiftnum이 음수가 될 수도 있는지 확인
    printf("shiftnum = %u\n",shiftnum);
    //RtE를 통한 >>=shiftnum 구현
    unsigned long long signif, signif1, signif2;
    if(ms1.raw.exp) signif1=ms1.raw.frac|0x10000; else signif1=ms1.raw.frac;
    if(ms2.raw.exp){
        if(shiftnum<16) signif2=ms2.raw.frac|(1<<16-shiftnum);
        else signif2=ms2.raw.frac|1<<16;
    }
    else signif2=ms2.raw.frac;
    printf("ms2_Before : "U24_TO_BIN_P"\n", U24_TO_BIN(ms2.u));
    printf("ms1.raw.frac : %d\n", ms1.raw.frac);
    printf("ms2.raw.frac : %d\n", ms2.raw.frac);
    printf("signif1 : %llu\n", signif1);
    printf("signif2 : %llu\n", signif2);
    if(shiftnum==0){
        //아무것도 안함
    }
    else if(shiftnum==1){
        unsigned G, R, S;
        G=signif2&0b10; R=signif2&1; S=0;
        if(R&&G){
            signif2>>=1; signif2++;
        }
        else signif2>>=1;
        ms2.raw.frac=signif2;
    }
    else if(shiftnum<18){
        unsigned G, R, S;
        G=(1<<shiftnum)&signif2; R=(1<<(shiftnum-1))&signif2; S=(1<<(shiftnum-1)-1)&signif2;
        printf("G, R, S : %u %u %u\n",G,R,S);
        if(R==0){//무조건 버림
            signif2>>=shiftnum;
            ms2.raw.frac=signif2;
        }
        else if(S!=0){//R==1인데 S까지 0 아니면 무조건 올림
            signif2>>=shiftnum;
            signif2++;
            ms2.raw.frac=signif2;
        }
        else if(G){//R==0, S==1인데 G가 1이면 올려야지
            signif2>>=shiftnum;
            signif2++;
            ms2.raw.frac=signif2;
        }
        else{//R==0, S==1인데 G가 0이면 현황유지. 그냥 버림.
            signif2>>=shiftnum;
            ms2.raw.frac=signif2;
        }
    }
    else{//18 길이 이상 우시프트면 걍 싹다 버리면 된다. R이 0이기 때문에 RtE적용해도 변화없음.
        ms2.raw.frac>>=16;
    }
    printf("ms2_AFTER : "U24_TO_BIN_P"\n", U24_TO_BIN(ms2.u));

    //부호조정
    if(ms1.raw.sign==ms2.raw.sign){
        ret.raw.sign=ms1.raw.sign;
        ret.raw.exp=ms1.raw.exp;
        signif=signif1+signif2;
    }
    else{
        if(ms1.raw.sign){//음수결과
            ret.raw.sign=1;
            ret.raw.exp=ms1.raw.exp;
            signif=signif2-signif1;
        }
        else{//양수결과
            ret.raw.sign=0;
            ret.raw.exp=ms1.raw.exp;
            signif=signif1-signif2;
        }
    }
    printf("SFP_AFTER : "U24_TO_BIN_P"\n", U24_TO_BIN(ret.u));

    //Normalize Result 구현
    if(signif<(1<<16)){//당연히 이 상황이면 exp도 0이라는거겠지?
        while(signif<(1<<16)&&ret.raw.exp!=0){
            signif<<=1;
            ret.raw.exp--;
        }
        if(signif>=(1<<16)){
            if(ret.raw.exp) signif&=0xFFFF;//leading 1 삭제
        }
        ret.raw.frac=signif;
        return ret.s;
    }
    else if(signif>=(1<<17)){//signif가 과도하므로 exp로 환전해야 함
        unsigned G, R, S;
        G=signif&0b10; R=signif&0b1; S=0;
        if(R&&G){
            signif>>=1; signif++;
        }
        else signif>>=1;
        ret.raw.exp++;
        return ret.s;
    }
    else{
        ret.raw.frac=signif;
        return ret.s;
    }
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
    //대소비교
    mysfp tmp1, tmp2;
    tmp1.s=in1; tmp2.s=in2;
    if(tmp1.raw.sign) tmp1.raw.sign=0; else tmp1.raw.sign=1;//비교편의상 양수일 경우 sign=1이도록 변경
    if(tmp2.raw.sign) tmp2.raw.sign=0; else tmp2.raw.sign=1;
    if(tmp1.u>tmp2.u){
        ms1.s=in1; ms2.s=in2;
    }
    else{
        ms1.s=in2; ms2.s=in1;
    }

    ret.raw.sign=ms1.raw.sign^ms2.raw.sign;
    if((ms1.raw.exp==(1<<7)-1&&ms1.raw.frac!=0)||(ms2.raw.exp==(1<<7)-1&&ms2.raw.frac!=0)){//둘 중 하나라도 NaN이면 닥치고 NaN 리턴
        ret.raw.exp=(1<<7)-1; ret.raw.frac=1;
        return ret.s;
    }

    if((ms1.raw.exp==0&&ms1.raw.frac==0)||(ms2.raw.exp==0&&ms2.raw.frac==0)){//둘 중 하나가 숫자 0이면
        ret.raw.exp=0; ret.raw.frac=0;
        return ret.s;
    }

    if(ms1.raw.exp+ms2.raw.exp<63){//underflow -> 0리턴(무한아니다!!!)
        ret.raw.exp=0; ret.raw.frac=0;
        return ret.s;
    }
    else ret.raw.exp=ms1.raw.exp+ms2.raw.exp-63;

    if(ms1.raw.exp) signif1=ms1.raw.frac|(1<<16); else signif1=ms1.raw.frac;
    if(ms2.raw.exp) signif2=ms2.raw.frac|(1<<16); else signif2=ms2.raw.frac;
    unsigned long long signif=(unsigned long long)signif1*signif2;
    
    if(signif==0){
        if(ret.raw.exp<=0 || ret.raw.exp>=(1<<7)-1){//<=0의 경우는 추가고려가 일단은 필요
            //exponent Overflow
            ret.raw.exp=(1<<7)-1;
        }
        ret.raw.frac=0;
        return ret.s;
    }

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

    mysfp mys1, mys2, res;
    mys1.u=0; mys2.u=0; res.u=0;
    // scanf("%u",&mys1.u);
    // scanf("%u",&mys2.u);
    // mys1.raw.sign=0; mys1.raw.exp=0b0000001; mys1.raw.frac=1;
    // mys2.raw.sign=1; mys2.raw.exp=0b0000001; mys2.raw.frac=0;
    mys1.raw.sign=0; mys1.raw.exp=0b1010001; mys1.raw.frac=0;
    mys2.raw.sign=0; mys2.raw.exp=0b1000000; mys2.raw.frac=0x8000;
    res.s=sfp_add(mys1.s, mys2.s);
    printf("mys1 : "U24_TO_BIN_P"\n", U24_TO_BIN(mys1.s));
    printf("mys2 : "U24_TO_BIN_P"\n", U24_TO_BIN(mys2.s));
    printf("mys1 + mys2 = "U24_TO_BIN_P"\n", U24_TO_BIN(res.s));

	return 0;
}