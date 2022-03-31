// https://karfn84.tistory.com/entry/network%EB%A6%AC%EB%88%85%EC%8A%A4-pcap%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-packet-captuer-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%A8?category=229601
//////////////////////////////////////////////////////////////////////////
// Product Date : 2009/09/18                                            //
// Author : (Last) Lee                                                  //
//          (First) Hyunbin                                             //
// comment : This Program is expression to Packet architecture~         //
//           by used to pcap library.                                   //
// 인지값 - void                                                        //
// 반환값 - void                                                        //
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
// Preprocessor area
#include <stdio.h>
#include <pcap/pcap.h>
#include <net/ethernet.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#include <string.h>

// Pointer direct expression
#define INPUT
#define OUTPUT

//////////////////////////////////////////////////////////////////////////
// Packet structure 
typedef struct _Packet
{
	const u_char * NProtocol;	// Next Protocol
	void (*Layer2)(INPUT void*);
	void (*Layer3)(INPUT void*);
	void (*Layer4)(INPUT void*);
}Packet;

//////////////////////////////////////////////////////////////////////////
// Function Prototype area
void Layer2_Ether(INPUT void * vP);
void Layer3_IP(INPUT void * vP);
void Layer3_ARP(INPUT void * vP);
void Layer3_REVARP(INPUT void * vP);
void Layer3_PUP(INPUT void * vP);
void Layer4_TCP(INPUT void * vP);
void Layer4_UDP(INPUT void * vP);
void PrintHexaNAscii(const unsigned char *buffer, int size);

//////////////////////////////////////////////////////////////////////////
// Product Date : 2009/09/18                                            //
// Author : (Last) Lee                                                  //
//          (First) Hyunbin                                             //
// comment : This function is main Function.                            //
// 인지값 - void                                                        //
// 반환값 - void                                                        //
//////////////////////////////////////////////////////////////////////////
int main()
{
   	char errbuf[PCAP_ERRBUF_SIZE];
	// 함수 원형 : char* pcap_lookupdev
	// 함수 설명 : 네트웍 디바이스에 대한 포인터를 되돌려준다.
	char * spNetDevName = pcap_lookupdev(errbuf);
	pcap_t* pDes;
	int iDataLink;
	int iCnt, jCnt;
	const u_char* ucData;
	struct pcap_pkthdr stPInfo;
	Packet stData;	// Packet Information

	// stData구조체를 0으로 초기화
	memset(&stData, 0, sizeof(stData));
	
	// 이름을 받아오지 못했다면
	if(0 == spNetDevName)		// error
	{
		printf("errbuf				: [%s]\n", errbuf);
		return 100;
	}
	// 이름을 받아왔다면
	else
	{
    		printf("Network Device Name ; [%s]\n", spNetDevName);
	}
	
	// 함수 원형 :  pcap_t* pcap_open_live(char * device, int snaplen, int promisc, int to_ms, char *ebuf)
	// 함수 설명 : 패킷 캡쳐 디스크립터를 얻어오는 함수
	pDes = pcap_open_live(spNetDevName, ETH_FRAME_LEN, 1, 0 , errbuf);

	if(0 == pDes) // 
	{
		printf("Error : [%s]\n", errbuf);
		return 101;
	}
	else
	{
		// 함수 원형 : int pcap_datalink(pcap_t *p)
		// 함수 설명 : link layer 타입을 되돌려준다(DLT_EN10MB 과 같은) 
		iDataLink = pcap_datalink(pDes);
	}

	// 입력받은 데이터 링크를 출력
	if(DLT_EN10MB == iDataLink)
	{
		printf("2Layter Type : [Ethernet 10Mb]\n");
		stData.Layer2 = Layer2_Ether;	// Regist Layer 2
	}
	// 데이터 링크가 없다면
	else 
	{
		printf("2Layter Type : Not Ethernet Type...\n");
		return 0;
	}

	// 함수 원형 :  u_char *pcap_next(pcap_t *p, struct pcap_pkthdr *h)
	// 함수 설명 : 	다음 패킷에 대한 포인터를 리턴한다.
	do{
		ucData = pcap_next(pDes, &stPInfo);
		printf("Cap length : [%d]\n", stPInfo.caplen);
		printf("Length : [%d]\n", stPInfo.len);
		if(1500 > stPInfo.caplen) 
			continue;
		// 패킷의 길이가 400 이상일 시에만 출력
		PrintHexaNAscii(ucData, stPInfo.caplen);
		stData.NProtocol = ucData;
		stData.Layer2(&stData);
	}while(stPInfo.caplen<1500);

	// Layer3에 대한 정보를 출력
	if(0 != stData.Layer3)
	{
		stData.Layer3(&stData);
	}

	
	printf("\n");

	// Descripter를 닫는다.
	pcap_close(pDes);

	return 0;
}

//////////////////////////////////////////////////////////////////////////
// Product Date : 2009/09/18                                            //
// Author : (Last) Lee                                                  //
//          (First) Hyunbin                                             //
// comment : This function is expression to IP Protocol in Layer3.      //
//           Layer3인 IP의 정보를 출력시는 함수.                           //
// 인지값 - INPUT(포인터의 방향을 표시)                                    //
//		    void * vP (현재 패킷을 카리키는 포인터)                        //
// 반환값 - void                                                         //
//////////////////////////////////////////////////////////////////////////
void Layer3_IP(INPUT void * vP)
// vP : Packet struct Start Address
{
	 struct ip* ihP
	  = (struct ip*)(((Packet *)vP)->NProtocol);

	((Packet*)vP)->NProtocol =(const u_char *)(ihP+1); // Next Protocol Address
		
	printf("======================================================\n");
	printf("============== Layer 3 : IP Information ==============\n");
	printf("======================================================\n");
	printf("==       Source          ->       Destination       ==\n");

	// 정수를 문자열 형석으로 바꿔주는 함수 inet_ntoa를 써서 문자열로 출력
	printf("==  %15s"
			, inet_ntoa(ihP->ip_src)
		);
	printf("      ->    %15s      ==\n"
			, inet_ntoa(ihP->ip_dst)
		);

	printf("======================================================\n");
	printf("== Version : IPv%1d                                   ==\n",
			ihP->ip_v);
	printf("== Header Langth : %1d                                ==\n",
			ihP->ip_hl);
	printf("== Type of service : %-2X                             ==\n",
			ihP->ip_tos);
	printf("== Total Length : %-6d                            ==\n",
			ntohs(ihP->ip_len));
	printf("== Identification : %-6d                          ==\n",
			ntohs(ihP->ip_id));
	printf("== Fragment offset filed : %-4X                     ==\n",
			ntohs(ihP->ip_off));
	printf("== Time to live : %-3d                             ==\n",
			ntohs(ihP->ip_ttl));
	printf("== Protocol : %-2d                                    ==\n",
			ihP->ip_p);
	printf("== Checksum : %-8d                              ==\n",
			ntohs(ihP->ip_sum));
	printf("======================================================\n");
	
	return;
}
void Layer3_ARP(INPUT void * vP)
// vP : Packet struct Start Address
{
	return;
}
void Layer3_REVARP(INPUT void * vP)
// vP : Packet struct Start Address
{
	return;
}
void Layer3_PUP(INPUT void * vP)
// vP : Packet struct Start Address
{
	return;
}

//////////////////////////////////////////////////////////////////////////
// Product Date : 2009/09/18                                            //
// Author : (Last) Lee                                                  //
//          (First) Hyunbin                                             //
// comment : This function is expression to Ethernet Protocol in Layer2.//
//           Layer2인 Ethernet의 정보를 출력시는 함수                   //
// 인지값 - INPUT(포인터의 방향을 표시)                                 //
//		    void * vP (현재 패킷을 카리키는 포인터)                     //
// 반환값 - void                                                        //
//////////////////////////////////////////////////////////////////////////
void Layer2_Ether(INPUT void * vP)
{
	struct ether_header* ehP
	 = (struct ether_header*)(((Packet*)vP)->NProtocol);

	((Packet*)vP)->NProtocol =(const u_char *)(ehP+1); // Next Protocol Address

	printf("\n"
		"======================================================\n");
	printf("=========== Layer 2 :  Ethernet Information ==========\n");
	printf("======================================================\n");
	printf("==       Source          ->       Destination       ==\n");
	printf("==   %02X:%02X:%02X:%02X:%02X:%02X   "
		"->    %02X:%02X:%02X:%02X:%02X:%02X    ==\n",
		ehP->ether_shost[0],
		ehP->ether_shost[1],
		ehP->ether_shost[2],
		ehP->ether_shost[3],
		ehP->ether_shost[4],
		ehP->ether_shost[5],

		ehP->ether_dhost[0],
		ehP->ether_dhost[1],
		ehP->ether_dhost[2],
		ehP->ether_dhost[3],
		ehP->ether_dhost[4],
		ehP->ether_dhost[5]
		);

	switch(ntohs(ehP->ether_type))
	{
		case ETHERTYPE_IP:
			((Packet*)vP)->Layer3 = Layer3_IP;
			break;
		case ETHERTYPE_ARP:
			((Packet*)vP)->Layer3 = Layer3_ARP;
			break;
		case ETHERTYPE_REVARP:
			((Packet*)vP)->Layer3 = Layer3_REVARP;
			break;
		case ETHERTYPE_PUP:
			((Packet*)vP)->Layer3 = Layer3_PUP;
			break;
		default:
			break;
	}
	printf("======================================================\n");
	
	return;
}

//////////////////////////////////////////////////////////////////////////
// Product Date : 2009/09/18                                            //
// Author : (Last) Lee                                                  //
//          (First) Hyunbin                                             //
// comment : This function is printed hexa and ascii code               //
//           입력되는 버퍼의 내용을 hexa(16진수)와                      //
//           아스키 코드(ascii code)로 출력 시키는 함수                 //
// 인지값 - INPUT : 포인터의 방향을 표시, 즉 입력이란 의미              //
//		    const : 입력된 버퍼의 값은 함수 실행 도중에 변경되지 않음   //
//          u_char *buffer : unsigned char pointer 형 변수 buffer       //
// 반환값 - void                                                        //
//////////////////////////////////////////////////////////////////////////
void PrintHexaNAscii(INPUT const unsigned char *buffer, int size)
{
	int loop_temp	= 0;
	int counter		= 0;

	printf("=======================================================================\n");
	printf("Address 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D");
	printf(" 0E 0F 123456789ABCDEF\n");
	printf("=======================================================================\n");

	counter = 0;

	if(1200 < size)
		size = 1200;

	while(counter < size)
	{
		printf("0x%04X	",counter);
		loop_temp = 0;
		while(loop_temp < 16)
		{
			printf("%02X ", *buffer);
			++buffer;
			++loop_temp;
		}
		buffer = buffer -16;
		loop_temp = 0;
		while(loop_temp < 16)
		{
			if(31 > *buffer || 127 <= *buffer)
			{
				putchar('.');
			}
			else
			{
				putchar(*buffer);
			
			}
			++buffer;
			++loop_temp;
		}
		counter = counter + loop_temp;
		putchar('\n');
	}
	return;
}
 
