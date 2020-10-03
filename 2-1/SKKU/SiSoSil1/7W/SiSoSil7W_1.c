#include <stdio.h>
#include <string.h>


// int main(){
//     FILE* ifp=fopen("mytext.txt","r");
//     FILE* ofp=fopen("output.txt","w");
//     while(!feof(ifp)){
//         char buf[1000];
//         char* like="like";
//         char* want="need";
//         fscanf(ifp," %s[^\n]",buf);
//         if(strcmp(buf, like)==0){
//             printf("love\n");
//             fprintf(ofp, "love");
//         }
//         else if(strcmp(buf,want)==0){
//             printf("need\n");
//             fprintf(ofp, "need");
//         }
//         else{
//             printf("%s\n",buf);
//             fprintf(ofp, "%s ", buf);
//         }
//     }

//     return 0;
// }

int main(){
    FILE* ifp=fopen("mytext.txt","r");
    FILE* ofp=fopen("output.txt","w");
    while(!feof(ifp)){
        char buf[1000];
        char c='1';
        char* like="like";
        char* want="want";

        fscanf(ifp, "%[^ ]", buf);
        // fscanf(ifp, "%s", buf);
        if(strcmp(buf, like)==0){
            buf[0]='l'; buf[1]='o'; buf[2]='v'; buf[3]='e';
            // printf("%s",buf);
            fprintf(ofp, "%s",buf);
        }
        else if(strcmp(buf,want)==0){
            buf[0]='n'; buf[1]='e'; buf[2]='e'; buf[3]='d';
            // printf("%s",buf);
            fprintf(ofp, "%s",buf);
        }
        else{
            // printf("%s",buf);
            fprintf(ofp, "%s",buf);
        }

        if(!feof(ifp)){
            fscanf(ifp,"%c",&c);
            // printf("진입, c는 %d\n",c);
            fprintf(ofp, "%c",c);
        }
    }
    fclose(ifp);
    return 0;
}