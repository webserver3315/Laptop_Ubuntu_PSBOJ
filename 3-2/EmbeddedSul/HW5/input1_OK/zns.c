/*
 * Lab #5 : ZNS+ Simulator
 *  - Embedded Systems Design, ICE3028 (Fall, 2021)
 *
 * Oct. 21, 2021.
 *
 * TA: Youngjae Lee, Jeeyoon Jung
 * Prof: Dongkun Shin
 * Embedded Software Laboratory
 * Sungkyunkwan University
 * http://nyx.skku.ac.kr
 */
#include "zns.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define FOR(i,n) for(int i=0;i<(n);++i)
/************ constants ************/
int NBANK, NBLK, NPAGE;
int DEG_ZONE, MAX_OPEN_ZONE;
int NUM_FCG; // MAX_ZONE/NUM_FCG = 유저존 per FCG (==12)
/********** do not touch ***********/

// 모두 0으로 초기화해야함에 유의
int** FBG_Queue;// int FBG_Queue[NUM_FCG][FBG갯수==블록개수]
int* Queue_cnt;// int Queue_cnt[NUM_FCG]
int* Queue_Head;//int Queue_Head[NUM_FCG]
int* Queue_Tail;// int Queue_Tail[NUM_FCG]
int Queue_isEmpty(int fcg){ // 실패시 0
    if(Queue_cnt[fcg]==0) return 1;
    return 0;
}
int Queue_isFull(int fcg){ // 실패시 0
    if(Queue_cnt[fcg]==NBLK) return 1;
    return 0;   
}
int Queue_Push(int fcg, int data){ // 실패시 -1
    if(Queue_isFull(fcg)) return -1;
    FBG_Queue[fcg][Queue_Tail[fcg]] = data;
    Queue_Tail[fcg] = (Queue_Tail[fcg]+1 == NBLK) ? 0 : Queue_Tail[fcg] + 1;
    Queue_cnt[fcg]++;
    return 1;
}
int Queue_Pop(int fcg){ // 실패시 -1
    if(Queue_isEmpty(fcg)) return -1;
    int ret = FBG_Queue[fcg][Queue_Head[fcg]];
    Queue_Head[fcg] = (Queue_Head[fcg]+1 == NBLK) ? 0 : Queue_Head[fcg] + 1;
    Queue_cnt[fcg]--;
    return ret;
}
int Queue_Peek(int fcg){
    if(Queue_isEmpty(fcg)) return -1;
    return FBG_Queue[fcg][Queue_Head[fcg]];
}
void Queue_init(){
    FBG_Queue   =   (int**)malloc(sizeof(int*)*NUM_FCG);
    Queue_cnt   =   (int*)malloc(sizeof(int)*NUM_FCG);
    Queue_Head  =   (int*)malloc(sizeof(int)*NUM_FCG);
    Queue_Tail  =   (int*)malloc(sizeof(int)*NUM_FCG);
    FOR(fcg, NUM_FCG){
        FBG_Queue[fcg]  =   (int*)malloc(sizeof(int)*NBLK);
        Queue_cnt[fcg]=0; Queue_Head[fcg]=0; Queue_Tail[fcg]=0;
    }
    FOR(fcg, NUM_FCG)
        FOR(fbg, NBLK)
            Queue_Push(fcg,fbg);
}

int Open_Zone_Cnt;
int* Z2FBG;//int Z2FBG[MAX_ZONE];
int* Z2LogFBG;//int Z2LogFBG[MAX_ZONE];
struct zone_desc* ZD;//struct zone_desc ZD[MAX_ZONE];
int** buffer;// int buffer[MAX_ZONE][NSECT==8] // 매핑 2번하기 귀찮아서 무지성 할당함

//무지성 TL용valid맵 구현
int** zone_valid_map; // int** zone_valid_map[MAX_ZONE][ZONE_SIZE==64]

// 하나의 FCG 내에서 FBG의 수는 블록의 수와 동일.
void Global_init(){
    Z2FBG       =   (int*)malloc(sizeof(int)*MAX_ZONE);
    Z2LogFBG    =   (int*)malloc(sizeof(int)*MAX_ZONE);
    ZD          =   (struct zone_desc*)malloc(sizeof(struct zone_desc)*MAX_ZONE);
    buffer      =   (int**)malloc(sizeof(int*)*MAX_ZONE);
    zone_valid_map = (int**)malloc(sizeof(int*)*MAX_ZONE);
    
    FOR(mz, MAX_ZONE){
        buffer[mz]     =   (int*)malloc(sizeof(int)*NSECT);
        FOR(i,NSECT)    buffer[mz][i]=0;
        zone_valid_map[mz] = (int*)malloc(sizeof(int)*ZONE_SIZE);
        FOR(sct,ZONE_SIZE) zone_valid_map[mz][sct]=0;
        Z2FBG[mz]       =   -1;
        Z2LogFBG[mz]    =   -1;
        ZD[mz].slba     =   mz*ZONE_SIZE;
        ZD[mz].state    =   ZONE_EMPTY;
        ZD[mz].wp       =   mz*ZONE_SIZE;
    }
}

static inline int zone_to_fcg(int zone){ return zone%NUM_FCG; } // input1의 5번 zone은 1번 FCG
static inline int zone_to_fbg(int zone){ return Z2FBG[zone]; } // zone으로 딱 나오는 fcg와 다르게, fbg는 동적임.
static inline int lba_to_bank(int fcg, int lba){ return fcg*DEG_ZONE+(lba/NSECT)%DEG_ZONE; }
static inline int lba_to_page(int lba){ return (lba/(DEG_ZONE*NSECT))%NPAGE; }
//fbg는 0,1,2,3.. 처럼 어떤 fcg더라도 0부터 1간격으로 커짐!

void buffer_flush(int zone){
    assert(ZD[zone].wp%NSECT==0);
    int start_lba = ZD[zone].wp-NSECT;
    int bank = lba_to_bank(zone_to_fcg(zone),start_lba);
    int fbg = zone_to_fbg(zone); int page = lba_to_page(start_lba);
    nand_write(bank,fbg,page,buffer[zone],&start_lba);
    FOR(i,NSECT) buffer[zone][i]=0;
    if(ZD[zone].wp-ZD[zone].slba==ZONE_SIZE){//GOTO FULL
        ZD[zone].state=ZONE_FULL; Open_Zone_Cnt--;
    }
}


void zns_init(int nbank, int nblk, int npage, int dzone, int max_open_zone)
{
	// constants
	NBANK = nbank;
	NBLK = nblk;
	NPAGE = npage;
	DEG_ZONE = dzone;
	MAX_OPEN_ZONE = max_open_zone;
	NUM_FCG = NBANK / DEG_ZONE;
	// nand
	nand_init(nbank, nblk, npage);
    Queue_init();
    Global_init();

    assert(NSECT==PAGE_DATA_SIZE/sizeof(int));
}

int zns_write(int start_lba, int nsect, u32 *data)
{
    int zone = lba_to_zone(start_lba); 
    int fbg = zone_to_fbg(zone); int fcg = zone_to_fcg(zone);

    if(ZD[zone].state==ZONE_EMPTY){
        if(start_lba!=ZD[zone].slba || Open_Zone_Cnt>=MAX_OPEN_ZONE) return -1;
        // 새 FBG 할당받기
        int fbg = Queue_Pop(fcg); Open_Zone_Cnt++; assert(fbg!=-1);
        Z2FBG[zone]=fbg; ZD[zone].state=ZONE_OPEN; ZD[zone].wp=ZD[zone].slba;
        return zns_write(start_lba, nsect, data);//goto OPEN
    }else if(ZD[zone].state==ZONE_OPEN){
        if(start_lba!=ZD[zone].wp) return -1;
        for(int lba_offset=0; lba_offset<nsect; lba_offset++){
            int lba = start_lba+lba_offset;
            buffer[zone][lba%NSECT] = data[lba_offset]; ZD[zone].wp++;
            if(ZD[zone].wp%NSECT==0) buffer_flush(zone);
        }
    }else if(ZD[zone].state==ZONE_FULL){
        return -1;
    }else if(ZD[zone].state==ZONE_TLOPEN){ // TL Zone 다 쓰면, Src Zone ERASE 자동으로 해야함.
        if(start_lba!=ZD[zone].wp) return -1;
        for(int lba_offset=0; lba_offset<nsect; lba_offset++){ // copy-off할 섹터는 포함되면 안된다.
            int lba = start_lba+lba_offset;
            if(zone_valid_map[zone][lba%ZONE_SIZE]==1) return -1;
        }
        for(int lba_offset=0; lba_offset<nsect; lba_offset++){
            int lba = start_lba+lba_offset;
            buffer[zone][lba%NSECT] = data[lba_offset]; ZD[zone].wp++;
            if(ZD[zone].wp%NSECT==0) buffer_flush(zone);
        }
        // wp가 위치한 칸이 copy-off 섹터인지의 여부 확인, 맞다면 즉시 최대한 copy-off해주고 종료하기.
        int tmp_data[NSECT]; int tmp_spare;
        while(zone_valid_map[zone][ZD[zone].wp%ZONE_SIZE]!=-1){
            int bank = lba_to_bank(fcg,ZD[zone].wp); int page = lba_to_page(ZD[zone].wp);
            nand_read(bank,fbg,page,tmp_data,&tmp_spare);
            buffer[zone][ZD[zone].wp%NSECT]=tmp_data[ZD[zone].wp%NSECT]; ZD[zone].wp++;
            if(ZD[zone].wp%NSECT==0) buffer_flush(zone);
        }
    }else return -1;
    return 0;
}

void zns_read(int start_lba, int nsect, u32 *data)
{
    int zone = lba_to_zone(start_lba);
    int fcg = zone_to_fcg(zone);
    int fbg = zone_to_fbg(zone);
    int cpy_cnt = 0;
    int tmp_data[NSECT]; // must NSECT == PAGE_DATA_SIZE/sizeof(int)
    int tmp_spare;
    if(ZD[zone].state==ZONE_EMPTY){
        FOR(idx,nsect) { data[idx]=0xFFFFFFFF; cpy_cnt++;}
        assert(cpy_cnt==nsect);
        return;
    }else if(ZD[zone].state==ZONE_OPEN){
        // not written sector면 0xFF 쓰기. 이것은 wp와 start_lba 비교로 판별가능
        // 마지막 한 페이지는 buffer에서 읽어야 함을 주의
        for(int lba_offset = 0; lba_offset < nsect;){
            int lba = start_lba + lba_offset;         
            if(lba<ZD[zone].wp){ // Written
                // printf("HERE3\n");
                if(lba+NSECT-1<ZD[zone].wp){ // Page 한입 크게 베어먹기 ㄱㄴ?
                    // printf("HERE4\n");
                    // (x>>y) == (x/(2^y))
                    int bank = lba_to_bank(fcg,lba);
                    int page = lba_to_page(lba);
                    nand_read(bank,fbg,page,tmp_data,&tmp_spare);
                    FOR(i,NSECT) data[i]=tmp_data[i];
                    data+=NSECT; cpy_cnt+=NSECT; lba_offset+=NSECT; continue;
                }else{ // 한 입 크게 베어먹기 ㅂㄱㄴ? => 버퍼 찔끔찔끔
                    // printf("HERE5\n");
                    for(int i=lba%NSECT;i<(ZD[zone].wp)%NSECT;i++){
                        if(cpy_cnt==nsect) return;
                        data[0]=buffer[zone][i];
                        data++; cpy_cnt++; lba_offset++; continue;
                    }
                }
            }else{ // Unwritten
                // printf("HERE6\n");
                while(cpy_cnt<nsect){
                    data[0]=0xFFFFFFFF; cpy_cnt++; data++; lba_offset++;
                } continue;
            }
        }
        assert(cpy_cnt==nsect);
    }else if(ZD[zone].state==ZONE_FULL){ 
        // fbg 알고리즘 다시 짜야함.
        for(int lba_offset=0;lba_offset<nsect;){
            int lba = start_lba+lba_offset;
            int bank = lba_to_bank(fcg,lba); int page = lba_to_page(lba);
            nand_read(bank,fbg,page,tmp_data,&tmp_spare); assert(tmp_spare==lba);
            FOR(i,NSECT){
                if(cpy_cnt==nsect) return;
                data[i]=tmp_data[i];
                cpy_cnt++;
            }
            lba_offset+=NSECT; data+=NSECT;
        }
        assert(cpy_cnt==nsect);
        // for(int bank = fcg*DEG_ZONE; bank < (fcg+1)*DEG_ZONE; bank++){
        //     for(int page=0;page<NPAGE;page++){
        //         nand_read(bank, fbg, page, tmp_data, tmp_spare);
        //         int local_cpy_cnt=0;
        //         FOR(i, NSECT){
        //             data[i]=tmp_data[i]; cpy_cnt++; local_cpy_cnt++;
        //             if(cpy_cnt==nsect) return;
        //         }
        //         data+=local_cpy_cnt;
        //     }
        // }// 무지성으로 64비트 전부 쓰는 문제가 있다.
        // assert(cpy_cnt==nsect);
    }else if(ZD[zone].state==ZONE_TLOPEN){ 
        assert(Z2FBG[zone]!=-1);
        int fbg = zone_to_fbg(zone); int logfbg = Z2LogFBG[zone];
        for(int lba_offset=0; lba_offset<nsect; lba_offset++){
            int lba = start_lba+lba_offset;
            int bank = lba_to_bank(fcg,lba); int page = lba_to_page(lba);
            if(lba<ZD[zone].wp){ // DST zone 에서 읽기
                if((lba/NSECT)*NSECT+NSECT-1 < ZD[zone].wp){ // FLASH에서 읽기
                    nand_read(bank,fbg,page,tmp_data,&tmp_spare);
                    data[0] = tmp_data[lba%NSECT]; data++;
                }else{ // Buffer에서 읽기
                    data[0] = buffer[zone][lba%NSECT]; data++;
                }
            }else{ // Src Zone에서 읽기
                if(zone_valid_map[zone][lba%ZONE_SIZE]==1){ // 베낄 권리가 있는 섹터
                    nand_read(bank,logfbg,page,tmp_data,&tmp_spare);
                    data[0] = tmp_data[lba%NSECT]; data++;
                }else{ // 베낄 권리가 없는 섹터
                    data[0] = 0xFFFFFFFF;
                }
            }
        }
        assert(cpy_cnt==nsect);
    }else return;
}

int zns_reset(int lba)// FULL2EMPTY
{
    int zone = lba_to_zone(lba);
    if(ZD[zone].state!=ZONE_FULL) return -1;
    ZD[zone].wp=ZD[zone].slba;
    ZD[zone].state=ZONE_EMPTY;
    int fcg = zone_to_fcg(zone);
    //fbg 매핑도 해제, Queue에 반납
    Queue_Push(fcg,Z2FBG[zone]);
    for(int bank = fcg*DEG_ZONE; bank<(fcg+1)*DEG_ZONE; bank++){
        nand_erase(bank,Z2FBG[zone]); // 이미 Empty라도 알아서 거부할테니 뭐 딱히 문제는 없겠지...?
    }
    Z2FBG[zone] = -1;
    if(Z2LogFBG[zone]!=-1){
        Queue_Push(fcg,Z2LogFBG[zone]);
        for(int bank = fcg*DEG_ZONE; bank<(fcg+1)*DEG_ZONE; bank++){
            nand_erase(bank,Z2LogFBG[zone]);
        }
        Z2LogFBG[zone]=-1;
    }
    FOR(i,ZONE_SIZE) zone_valid_map[zone][i]=0;
    //다른 뭔가를 더 해야하나..?
    return 0;
}

void zns_get_desc(int lba, int nzone, struct zone_desc *descs)
{
    int start_zone = lba_to_zone(lba);
    FOR(zone_offset, nzone){
        int zone = start_zone+zone_offset;
        descs[zone_offset].slba=ZD[zone].slba;
        descs[zone_offset].state=ZD[zone].state;
        descs[zone_offset].wp=ZD[zone].wp;
    }
}

int zns_izc(int src_zone, int dest_zone, int copy_len, int *copy_list)
{
    if(Open_Zone_Cnt==MAX_OPEN_ZONE || ZD[src_zone].state!=ZONE_FULL || ZD[dest_zone].state!=ZONE_EMPTY || src_zone==dest_zone) return -1;
    // dest_zone open하기
    int fcg = zone_to_fcg(src_zone); int fbg = zone_to_fbg(src_zone);
    int dest_fcg  = zone_to_fcg(dest_zone); 
    int dest_fbg = Queue_Pop(dest_fcg); Open_Zone_Cnt++; assert(dest_fbg!=-1);
    Z2FBG[dest_zone]=dest_fbg; Z2LogFBG[dest_zone]=-1;
    ZD[dest_zone].state=ZONE_OPEN; ZD[dest_zone].wp = ZD[dest_zone].slba;

    int tmp_data[NSECT]; int tmp_spare;
    for(int cpy_cnt=0;cpy_cnt<copy_len;){//루프당 한 섹터씩 복사해옴
        int buffer_offset = cpy_cnt%NSECT;
        int lba = src_zone*ZONE_SIZE+copy_list[cpy_cnt];
        int bank = lba_to_bank(fcg,lba); int page = lba_to_page(lba);
        nand_read(bank,fbg,page,tmp_data,&tmp_spare);
        buffer[dest_zone][ZD[dest_zone].wp%NSECT]=tmp_data[copy_list[cpy_cnt]%NSECT]; ZD[dest_zone].wp++;
        cpy_cnt++; buffer_offset++;
        if(ZD[dest_zone].wp%NSECT==0){ // buffer flush
            assert(cpy_cnt%NSECT==0);
            buffer_flush(dest_zone);
        }
    }
    zns_reset(src_zone*ZONE_SIZE); return 0;
}

int zns_tl_open(int zone, u8 *valid_arr)//성공시 return 뭐임?
{
    if(Open_Zone_Cnt==MAX_OPEN_ZONE || ZD[zone].state!=ZONE_FULL) return -1;
    int fcg = zone_to_fcg(zone);
    int src_fbg = zone_to_fbg(zone);
    int log_fbg = Queue_Pop(fcg); Open_Zone_Cnt++; assert(log_fbg!=-1);
    // 주의: 마지막 invalid sector에 write되었을 때 마저 쓰고 open_zone_cnt--시키기.
    Z2LogFBG[zone]=log_fbg;
    ZD[zone].state=ZONE_TLOPEN; ZD[zone].wp=ZD[zone].slba;
    FOR(i,ZONE_SIZE) zone_valid_map[zone][i]=valid_arr[i];
    //first cpy
    int tmp_data[NSECT]; int tmp_spare; 
    FOR(i,ZONE_SIZE){
        if(zone_valid_map[zone][i]==0) return 1; // 성공시 리턴 뭐임?
        int lba = zone*ZONE_SIZE + i;
        int bank = lba_to_bank(fcg,lba); int page = lba_to_page(lba);
        nand_read(bank,src_fbg,page,tmp_data,&tmp_spare); assert(tmp_spare==lba);
        buffer[zone][ZD[zone].wp%NSECT]=tmp_data[i%NSECT]; ZD[zone].wp++;
        if(ZD[zone].wp%NSECT==0) {
            buffer_flush(zone);
            if(ZD[zone].state==ZONE_FULL){ // TL Zone 다 쓰면, SRC ZONE FBG AUTOERASE
                Queue_Push(fcg,Z2LogFBG[zone]); Open_Zone_Cnt--;
                for(int bank=fcg*DEG_ZONE; bank<(fcg+1)*DEG_ZONE; bank++){
                    nand_erase(bank,Z2LogFBG[zone]);
                }
                Z2LogFBG[zone]=-1;
                FOR(i,ZONE_SIZE) zone_valid_map[zone][i]=0;
            }
        }
    }
    return 0;
}
