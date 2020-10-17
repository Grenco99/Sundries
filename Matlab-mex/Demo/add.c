#include "mex.h"
double add(double x, double y){
    return x+y;
}

//a = add(b,c)
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    double *a;
    double b, c;
    plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL); //数组，内容为指针，指向mxArray
    a = mxGetPr(plhs[0]);   //prhs指向b,c
    b = *(mxGetPr(prhs[0]));
    c = *(mxGetPr(prhs[1]));
    *a = add(b,c);
}

//mex -setup C
//mex add.c