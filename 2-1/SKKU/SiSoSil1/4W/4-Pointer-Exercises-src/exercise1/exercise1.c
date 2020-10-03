/* 
파일명: exercise1.c
**    EDIT THIS FILE.
*/


// If is_swap_ptr == 1, then swap pointers that are pointing values.
// Otherwise, swap actual values inside.

void swap(int** var_pp, int offset_a, int offset_b, int is_swap_ptr)
{
    // swap pointers
    if (is_swap_ptr)
    {
    int* tmppt = var_pp[offset_a];
    var_pp[offset_a]=var_pp[offset_b];
    var_pp[offset_b]=tmppt;
    }

    // swap values
    else
    {
    int tmpA=*var_pp[offset_a];
    int tmpB=*var_pp[offset_b];
    // int tmp = tmpA;
    // tmpA=tmpB;
    // tmpB=tmp;
    *var_pp[offset_a]=tmpB;
    *var_pp[offset_b]=tmpA;
    }
}
