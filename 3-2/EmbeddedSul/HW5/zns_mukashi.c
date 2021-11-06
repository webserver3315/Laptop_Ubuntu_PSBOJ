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
#define FOR(i,n) for(int i=0;i<(n);++i)

/************ constants ************/
int NBANK, NBLK, NPAGE;
int DEG_ZONE, MAX_OPEN_ZONE;
int NUM_FCG; // MAX_ZONE/NUM_FCG = 유저존 per FCG (==12)
/********** do not touch ***********/

/* 
FCG 별로 0,1,2순으로 카운팅하는 Zone은 특별히 Real Zone 이라고 부른다!!!!
FCG 별로 0,2,4순으로 카운팅되는 Zone이 그냥 Zone이다!
*/

#define Q_SIZE 50
int** FBG_Queue;//int FBG_Queue[FCG_NUM][FBG갯수==블록개수]
int Queue_cnt;
int Queue_Head; // 이걸 pop한다.
int Queue_Tail; // 여기에 push한다.
int Queue_isEmpty(){
	if(Queue_cnt==0) return 1;
	return 0;
}
int Queue_isFull(){
	if(Queue_cnt==Q_SIZE) return 1;
	return 0;
}
int Queue_Push(int data){ // 실패시 -1 리턴
	if(Queue_isFull())	return -1; // Full
	FBG_Queue[Queue_Tail] = data;
	Queue_Tail = (Queue_Tail+1>=Q_SIZE) ? 0 : Queue_Tail+1;
	Queue_cnt++;
	return 1;
}
int Queue_Pop(){ // 실패시 -1 리턴에 유의
	if(Queue_isEmpty()) return -1; // Empty
	int ret = FBG_Queue[Queue_Head];
	Queue_Head = (Queue_Head+1>=Q_SIZE)?0:Queue_Head+1;
	Queue_cnt--;
	return ret;
}
int Queue_Peek(){
	if(Queue_isEmpty()) return -1; // Empty
	return FBG_Queue[Queue_Head];
}

int Open_Zone_cnt;
int* Z2FBG; //int Z2FBG[MAX_ZONE]
int* Z2LogFBG; //int Z2FBG[MAX_ZONE]
// ZD 구조체 배열은 [] 안에 FBG가 아니라 Zone이 들어감에 유의. 즉 배열 3개 전부 Zone에 대한 것이다.
struct zone_desc* ZD;//struct zone_desc ZD[MAX_ZONE] => 오로지 UserZone만: Flash 전체 24개
int* Z2Buf; // int Z2Buf[MAX_Zone]
int* Buf2Z; // int Buf2OZ[MAX_OPEN_ZONE]
int** buffer; //int buffer[MAX_OPEN_ZONE][8==NSECT]

//Zone마다 Zone Descriptor 가짐
//? izc로 open된 zone과 tl로 open된 zone은 state가 따로있나? ㅇㅇ. TL_OPEN이 됨.

//각 Open된 Zone마다 1개 Page 크기의 Buffer를 RAM에 보유
// 하나의 FCG 내에서 FBG의 수는 블록의 수와 동일.

static inline int zone_to_fbg(int zone){ return zone%NUM_FCG; }
static inline int zone_to_real_zone(int zone){ return zone/NUM_FCG; }

void print_constant(){
	printf("=================PRINT CONSTANT==================\n");
	printf("NBANK = %d\n",NBANK);
	printf("NBLK = %d\n",NBLK);
	printf("NPAGE = %d\n",NPAGE);
	printf("NSECT = %d\n",NSECT);
	printf("SECT_SIZE = %d\n",SECT_SIZE);
	
	printf("DEG_ZONE = %d\n",DEG_ZONE);
	printf("MAX_OPEN_ZONE = %d\n",MAX_OPEN_ZONE);
	printf("MAX_ZONE = %d\n",MAX_ZONE);
	printf("ZONE_SIZE = %d\n",ZONE_SIZE);
	printf("MAX_LBA = %d\n",MAX_LBA);
}

int get_valid_buffer_idx(){ // 가용한 최초의 i th buffer 리턴, 실패시 -1
	FOR(i, MAX_OPEN_ZONE){
		if(Buf2Z[i]==-1) return i;
	}
	return -1; // 호출될 때 애초에 open_zone_cnt로 관리하니까 이럴 일 없음.
}

void zns_init(int nbank, int nblk, int npage, int dzone, int max_open_zone)
{
	// constants
	NBANK = nbank; 	// 4
	NBLK = nblk;	// 16
	NPAGE = npage;	// 8
	DEG_ZONE = dzone;	// 2
	MAX_OPEN_ZONE = max_open_zone; // 4
	NUM_FCG = NBANK / DEG_ZONE; // 2
	nand_init(nbank, nblk, npage);

	Z2FBG = (int*)malloc(sizeof(int)*MAX_ZONE);
	Z2LogFBG = (int*)malloc(sizeof(int)*MAX_ZONE);
	ZD = (struct zone_desc*)malloc(sizeof(struct zone_desc)*MAX_ZONE);
	
	Buf2Z = (int*)malloc(sizeof(int)*MAX_OPEN_ZONE);
	buffer = (int**)malloc(sizeof(int*)*MAX_OPEN_ZONE);
	FOR(i,MAX_OPEN_ZONE) {
		buffer[i] = (int*)malloc(sizeof(int)*NSECT);
		Buf2Z[i] = -1;
	}

	FOR(i, MAX_ZONE){
		Z2FBG[i]=-1; Z2LogFBG[i]=-1; Z2Buf[i]=-1;
		ZD[i].slba=-1; // slba가 -1이라는건, 아직 해당 Zone이 FBG를 할당받지 못했다는 것이다.
		ZD[i].state=ZONE_EMPTY;
		ZD[i].wp=-1;
		Queue_Push(i); // 0번, 1번, 2번, ... 순으로 FBG 넣기.
	}
	print_constant();
}

int open_zone(int zone){
	if(Open_Zone_cnt>=MAX_OPEN_ZONE || Queue_isEmpty()) return -1;
	Z2FBG[zone]=Queue_Pop();
	ZD[zone].state = ZONE_OPEN;
	ZD[zone].slba = Z2FBG[zone]*ZONE_SIZE;//*=64
	ZD[zone].wp = ZD[zone].slba;
	// buffer할당받아야함.
	int buf_idx = get_valid_buffer_idx(); if(buf_idx==-1) return -1; // 애초에 여기 걸릴 일 없긴함
	Buf2Z[buf_idx]=zone;
	Z2Buf[zone]=buf_idx;
	Open_Zone_cnt++;
}

int write_to_buffer(int lba, int nsect, u32 *data){// lba부터 page끝까지 nsect만큼 버퍼에 저장한다.
	if(lba/NSECT != (lba+nsect)/NSECT) return -1; // 8보다 큰 write는 버퍼크기를 넘어섬
	int start_offset = lba%NSECT; int end_offset = start_offset+nsect-1;
	for(int i=start_offset;i<=end_offset;i++){
		buffer[Z2Buf[lba_to_zone(lba)]][i] = data[i-start_offset];
	}
	data+=nsect; // 이거 수정안될텐데.
	//wp는 page 단위로만 커질 수 있나?
}

// start_lba부터 buffer에 쓰거나 direct로 flash에 쓰거나 하는걸 판단한다.
void parse_data(int start_lba, int nsect, u32 *data){ // zone의 끝에 가는거랑 page의 끝에 가는거랑 다름!
	if(start_lba/ZONE_SIZE != (start_lba+nsect)/ZONE_SIZE) return; // 추후 구현
	FOR(delta, nsect){
		int lba = start_lba+delta;
		buffer[Z2Buf[lba_to_zone(lba)]][lba%NSECT] = data[0];
		data++;
	}
}

int zns_write(int start_lba, int nsect, u32 *data) { // lba부터 조낸 길게 쓸때 알아서 파싱하고 Full되면 꺼뜨리고 다음 Zone 받고 해야함.
	//buffering에 주의
	int zone = lba_to_zone(start_lba);
	if(ZD[zone].state==ZONE_FULL) return -1;
	else if(ZD[zone].state==ZONE_EMPTY){ // FBG를 할당받을 수 있다.
		if(open_zone(zone)==-1) return -1;

	}

	if(ZD[zone].state==ZONE_OPEN && ZD[zone].wp == start_lba){
		// 파싱하고, FULL 여부 체크해가며 Zone 끝까지 써나간다.

	}else if(ZD[zone].state==ZONE_TLOPEN){

	}else return -1;
}

void zns_read(int start_lba, int nsect, u32 *data)
{// buffering 된 zone이라면 buffer를 우선으로 읽고, tl open된 zone이라면 wp기준 반반 읽어야한다.

}

int zns_reset(int lba){ // fbg 반납하므로 매핑 절단. 그리고 Q에 넣어야함.

}

void zns_get_desc(int lba, int nzone, struct zone_desc *descs)
{
}

int zns_izc(int src_zone, int dest_zone, int copy_len, int *copy_list){

}

int zns_tl_open(int zone, u8 *valid_arr)
{
}
