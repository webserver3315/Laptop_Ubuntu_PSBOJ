#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(){
    int read_time = 0,write_time = 0;
    char *arr1 = (char *)malloc(sizeof(char)*50000);
    char *arr2 = (char *)malloc(sizeof(char)*50000);

    for (int i = 0; i < 50000; i++) {
        arr1[i] = '0' + (i % 10);
    }

    for (int i = 0; i < 50000; i++) {
        arr2[i] = 'a' + (i % 10);
    }

    printf(1,"arr1[0] : %c, arr1[10000]: %c, arr1[20000] : %c, arr1[30000] : %c, arr1[40000] : %c\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
    // printf(1,"arr1[0] : %d, arr1[10000]: %d, arr1[20000] : %d, arr1[30000] : %d, arr1[40000] : %d\n",arr1[0],arr1[10000],arr1[20000],arr1[30000],arr1[40000]);
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
    swapstat(&read_time,&write_time);
    printf(1,"read : %d, write : %d\n", read_time, write_time);
    return 0;
}