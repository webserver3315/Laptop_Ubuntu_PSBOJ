/* 
exercise2.c
**    EDIT THIS FILE.
*/

int fact_stop(int input); // always returns 1;

int fact(int input)
{
    int (* func_next)(int);
    if(input==1)
    func_next=fact_stop;
    else
    func_next=fact;
    
    return input * func_next(input - 1);
}

int sample_fct(int a){
    if(a==1)
    return 1;

    return a*sample_fct(a-1);
}