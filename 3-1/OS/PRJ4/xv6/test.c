#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

#define SIZE (int)10

int main(){
    int read_time = 0,write_time = 0;
    char *arr1 = (char *)malloc(sizeof(char)*30000000);

    printf(1, "arr1 allocation FINISHED\n");

    char *arr2 = (char *)malloc(sizeof(char)*30000000);
    printf(1, "arr2 allocation FINISHED\n");
    arr1[1] = 0;
    arr2[2] = 0;

    // char *ararr[SIZE];
    // for (int i = 0; i < SIZE;i++){
    //     ararr[i] = (char *)malloc(sizeof(char) * 30000000);
    // }
    // for (int i = 0; i < SIZE;i++){
    //     ararr[i][0] = 1;
    // }

    // for (int i = 0; i < 50000; i++) {
    //     arr1[i] = '0' + (i % 10);
    // }

    // for (int i = 0; i < 50000; i++) {
    //     arr2[i] = 'a' + (i % 10);
    // }

    printf(1,"arr1[0] : %c, arr1[10000]: %c, arr1[20000] : %c, arr1[30000] : %c, arr1[40000] : %c\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
    //00000
    printf(1,"arr1[5] : %c, arr1[10005]: %c, arr1[20005] : %c, arr1[30005] : %c, arr1[40005] : %c\n",arr1[5],arr1[10005],arr1[20005],arr1[30005],arr1[40005]);
    //55555
    printf(1,"arr1[9] : %c, arr1[10009]: %c, arr1[20009] : %c, arr1[30009] : %c, arr1[40009] : %c\n",arr1[9],arr1[10009],arr1[20009],arr1[30009],arr1[40009]);
    //99999
    printf(1,"arr2[0] : %c, arr2[10000]: %c, arr2[20000] : %c, arr2[30000] : %c, arr2[40000] : %c\n",arr2[0],arr2[10000],arr2[20000],arr2[30000],arr2[40000]);
    //aaaaa
    printf(1,"arr2[3] : %c, arr2[10003]: %c, arr2[20003] : %c, arr2[30003] : %c, arr2[40003] : %c\n",arr2[3],arr2[10003],arr2[20003],arr2[30003],arr2[40003]);
    //ddddd
    printf(1,"arr2[6] : %c, arr2[10006]: %c, arr2[20006] : %c, arr2[30006] : %c, arr2[40006] : %c\n",arr2[6],arr2[10006],arr2[20006],arr2[30006],arr2[40006]);
    //ggggg
    printf(1,"arr2[9] : %c, arr2[10009]: %c, arr2[20009] : %c, arr2[30009] : %c, arr2[40009] : %c\n",arr2[9],arr2[10009],arr2[20009],arr2[30009],arr2[40009]);
    //jjjjj
    printf(1,"arr1[0] : %c, arr1[10000]: %c, arr1[20000] : %c, arr1[30000] : %c, arr1[40000] : %c\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
    //00000
    printf(1,"arr2[0] : %c, arr2[10000]: %c, arr2[20000] : %c, arr2[30000] : %c, arr2[40000] : %c\n",arr2[0],arr2[10000],arr2[20000],arr2[30000],arr2[40000]);
    //aaaaa

    // printf(1,"arr3[0] : %c, arr3[10000]: %c, arr3[20000] : %c, arr3[30000] : %c, arr3[40000] : %c\n",arr3[0],arr3[10000],arr3[20000],arr3[30000],arr3[40000]);
    // //00000
    // printf(1,"arr3[5] : %c, arr3[10005]: %c, arr3[20005] : %c, arr3[30005] : %c, arr3[40005] : %c\n",arr3[5],arr3[10005],arr3[20005],arr3[30005],arr3[40005]);
    // //55555
    // printf(1,"arr3[9] : %c, arr3[10009]: %c, arr3[20009] : %c, arr3[30009] : %c, arr3[40009] : %c\n",arr3[9],arr3[10009],arr3[20009],arr3[30009],arr3[40009]);
    // //99999
    // printf(1,"arr4[0] : %c, arr4[10000]: %c, arr4[20000] : %c, arr4[30000] : %c, arr4[40000] : %c\n",arr4[0],arr4[10000],arr4[20000],arr4[30000],arr4[40000]);
    // //aaaaa
    // printf(1,"arr4[3] : %c, arr4[10003]: %c, arr4[20003] : %c, arr4[30003] : %c, arr4[40003] : %c\n",arr4[3],arr4[10003],arr4[20003],arr4[30003],arr4[40003]);
    // //ddddd
    // printf(1,"arr4[6] : %c, arr4[10006]: %c, arr4[20006] : %c, arr4[30006] : %c, arr4[40006] : %c\n",arr4[6],arr4[10006],arr4[20006],arr4[30006],arr4[40006]);
    // //ggggg
    // printf(1,"arr4[9] : %c, arr4[10009]: %c, arr4[20009] : %c, arr4[30009] : %c, arr4[40009] : %c\n",arr4[9],arr4[10009],arr4[20009],arr4[30009],arr4[40009]);
    // //jjjjj
    // printf(1,"arr3[0] : %c, arr3[10000]: %c, arr3[20000] : %c, arr3[30000] : %c, arr3[40000] : %c\n",arr3[0],arr3[10000],arr3[20000],arr3[30000],arr3[40000]);
    // //00000
    // printf(1,"arr4[0] : %c, arr4[10000]: %c, arr4[20000] : %c, arr4[30000] : %c, arr4[40000] : %c\n",arr4[0],arr4[10000],arr4[20000],arr4[30000],arr4[40000]);
    // //aaaaa


    swapstat(&read_time,&write_time);
    printf(1,"read : %d, write : %d\n", read_time, write_time);
    
    exit();
}