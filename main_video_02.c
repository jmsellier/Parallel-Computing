#include<stdio.h>
#include<stdlib.h>
#include<omp.h>

int main(void)
{
 // > export OMP_NUM_THREADS=4
 omp_set_num_threads(4);

 // this will run in parallel
 #pragma omp parallel
 {
  printf("hello world - thread #%d\n",omp_get_thread_num());
 }

 return(0);
}
