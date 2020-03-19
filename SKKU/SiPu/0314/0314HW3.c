#include <stdio.h>
#include <time.h>

int a[4096][4096];
int b[4096][4096];

int main(){
    double time_start, time_finish, time_duration;
    
    time_start=clock();
    for(int i=0;i<4096;i++){
        for(int j=0;j<4096;j++){
            a[i][j]=b[i][j];
        }
    }
    time_finish=clock();
    time_duration=((double)(time_finish-time_start));
    printf("1st test case: %f\n",time_duration);

    time_start=clock();
    for(int j=0;j<4096;j++){
        for(int i=0;i<4096;i++){
            a[i][j]=b[i][j];
        }
    }
    time_finish=clock();
    time_duration=((double)(time_finish-time_start));
    printf("2nd test case: %f\n",time_duration);

    return 0;
}