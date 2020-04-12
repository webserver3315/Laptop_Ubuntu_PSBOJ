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

sfp int2sfp(int input){
    unsigned bias=63;
    unsigned sign=0; unsigned exp=0; unsigned frac=0;
    int shiftnum;
    mysfp ret;
    sign=input<0;
    if(input==0){
        ret.raw.sign=0; ret.raw.exp=0; ret.raw.frac=0;
        return ret.s;
    }
    if(sign) input=(~input)+1;//음수면 input에 -1 곱해주기

    if(input==1) shiftnum=0;//1이면 특수처리
    else shiftnum=getfraclength(input);

    exp=shiftnum+63;
    frac=getfracbit(input,shiftnum);
    ret.raw.sign=sign; ret.raw.exp=exp; ret.raw.frac=frac;
    return ret.s;
}

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
        if(31<=exp){//int에 절대 못담는 큰 수. 애초에 31비트인데 2^31 이상을 담을 수 있을 리 없다.
            if(ret.raw.sign) ret=(myint)TMin; else ret=(myint)TMax;
            return ret.i;
        }
        if(exp<=16) frac>>=16-exp; else frac>>=16;
        unsigned leading1=1<<exp;
        frac+=leading1;
        if(sign){
            frac=(~frac)+1;
        }
        ret.raw.num=frac;
    }
    return ret.i;
}

sfp float2sfp(float input){
    myfloat mf; mf.f=input;
    mysfp ret;
    unsigned sign=mf.raw.sign; unsigned exp=mf.raw.exp; unsigned frac=mf.raw.frac;

    ret.raw.sign=sign;
    if(exp==255){//exp가 all 1 이면 문답무용 무한이나 NaN
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
        }
        ret.raw.frac=signif;
    }
    else{
        ret.raw.exp+=64;
        ret.raw.frac<<=7;
    }
    return ret.f;
}

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
    tmp1.raw.sign=0; tmp2.raw.sign=0;
    if(tmp1.u>tmp2.u){
        ms1.s=in1; ms2.s=in2;
    }
    else{
        ms1.s=in2; ms2.s=in1;
    }//절대value만 ms1이 크지, 부호영향으로 ms1이 음이면 오히려 ms2보다 실제로는 더 작을 수도 있음!!!
    unsigned tmpexp1=ms1.raw.exp; unsigned tmpexp2=ms2.raw.exp;
    if(tmpexp1==0) tmpexp1++; if(tmpexp2==0) tmpexp2++;
    unsigned shiftnum=tmpexp1-tmpexp2;
    
    //RtE를 통한 >>=shiftnum 구현
    unsigned long long signif, signif1, signif2;
    if(ms1.raw.exp) signif1=ms1.raw.frac|0x10000; else signif1=ms1.raw.frac;
    if(ms2.raw.exp) signif2=ms2.raw.frac|0x10000; else signif2=ms2.raw.frac;
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
        signif2>>=16;
        ms2.raw.frac>>=signif2;
    }
    //부호처리
    if(ms1.raw.sign==ms2.raw.sign){
        ret.raw.sign=ms1.raw.sign;
        ret.raw.exp=ms1.raw.exp;
        signif=signif1+signif2;
    }
    else{
        ret.raw.sign=ms1.raw.sign;
        ret.raw.exp=ms1.raw.exp;
        signif=signif1-signif2;
    }
    //Renormalize Result 구현
    if(signif<(1<<16)){//M이 1 미만
        while(signif<(1<<16)&&ret.raw.exp>1){
            signif<<=1;
            ret.raw.exp--;
        }
        if(signif>=(1<<16)){//exp에서 땡겨와서 normal 신분은 건졌을 경우
            if(ret.raw.exp) signif&=0xFFFF;//leading 1 삭제
        }
        if(signif<(1<<16)) ret.raw.exp=0;//여기까지 왔는데 M이 1 미만이라는건 exp가 0이라고밖에 설명안된다.
        ret.raw.frac=signif;
        return ret.s;
    }
    else if(signif>=(1<<17)){//M이 2 이상
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
        if(ret.raw.exp==0){//denormalized인데 M이 1 이상 2 미만이 나왔다면
            signif&=0xFFFF;//leading 1 제거
            ret.raw.exp=1;
        }
        ret.raw.frac=signif;
        return ret.s;
    }
}

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
    if(((ms1.raw.exp==0b1111111&&(ms1.raw.frac!=0))||((ms2.raw.exp==0b1111111&&(ms2.raw.frac!=0))))){//둘 중 하나라도 NaN이면 닥치고 NaN 리턴
        ret.raw.exp=(1<<7)-1; ret.raw.frac=1;
        return ret.s;
    }
    if((ms1.raw.exp==0&&ms1.raw.frac==0)||(ms2.raw.exp==0&&ms2.raw.frac==0)){//둘 중 하나가 숫자 0이면
        if((ms1.raw.exp==0b1111111&&ms1.raw.frac==0)||(ms2.raw.exp==0b1111111&&ms2.raw.frac==0)){//무한과 0의 곱은 nan이다.
            ret.raw.exp=0b1111111; ret.raw.frac=1; return ret.s;
        }
        ret.raw.exp=0; ret.raw.frac=0;//그 외에는 0
        return ret.s;
    }
    if(((ms1.raw.exp==0b1111111)&&(ms1.raw.frac==0))||((ms1.raw.exp==0b1111111)&&(ms2.raw.frac==0))){
        ret.raw.exp=0b1111111; ret.raw.frac=0; return ret.s;
    }

    //exp계산
    if(ms1.raw.exp+ms2.raw.exp<63){//underflow -> 0리턴(무한리턴아니다!!!)
        ret.raw.exp=0; ret.raw.frac=0;
        return ret.s;
    }
    else ret.raw.exp=ms1.raw.exp+ms2.raw.exp-63;

    if(ms1.raw.exp) signif1=ms1.raw.frac|(1<<16); else signif1=ms1.raw.frac;
    if(ms2.raw.exp) signif2=ms2.raw.frac|(1<<16); else signif2=ms2.raw.frac;
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
        if((signif&1)&&(signif&2)) signif++;
        signif>>=1;
        ret.raw.exp++;
    }
    while(signif<(1<<16)&&ret.raw.exp>1){
        signif<<=1;
        ret.raw.exp--;
    }

    if(ret.raw.exp>=(1<<7)-1){
        //exponent Overflow
        ret.raw.exp=(1<<7)-1;
        ret.raw.frac=0;
        return ret.s;
    }
    signif&=(0xFFFF);//leading 1 제거
    ret.raw.frac=signif;
    return ret.s;    
}