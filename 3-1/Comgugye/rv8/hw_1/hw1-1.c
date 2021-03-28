int fibonacci(int x) {

    if (x == 1) {
        return 1;
    }
    else if (x == 0) {
        return 0;
    }
    else {
        return (fibonacci(x - 1) + fibonacci(x - 2));
    }
}


int fibo(int a0){
    int s0 = a0;
    int t1 = 1;
    if(a0>t1){
        s0 = fibo(a0 - 1);
        return s0 * fibo(s0 - 1);
    }
    else
        return s0;
}
