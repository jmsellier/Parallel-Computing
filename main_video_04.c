#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<omp.h>

// number of cells in the range (a, b)
int NX=1e8;

// total number of cores in use
const int NUM_CORES=4;

// range of integration
double A=0.;
double B=1.;

// function to integrate
double F(double x){
 return(x*x-0.5*x+1.);
}

int main(void)
{
 int n;
 double x;
 double res;
 double dx=(B-A)/((double)(NX));

 // 1. initialize OpenMP
 omp_set_num_threads(NUM_CORES);

 // 2. perform the integral in parallel
 res=0.;

 // parallelization using OpenMP reduction clause
 #pragma omp parallel for num_threads(NUM_CORES) reduction(+:res)
 for(n=0;n<NX;n++) res+=F(A+(n+0.5)*dx);

 // 3. compute the final solution
 res*=dx;
 printf("1.08333 # %g\n",res);

 return(0);
}
