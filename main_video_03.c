#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<omp.h>

// total number of samples/points created
const int NUM_SAMPLES=100e6;

// total number of cores in use
const int NUM_CORES=4;

int main(void)
{
 register int n;
 int sum[NUM_CORES];
 double x;
 double y;
 double res;

 // 0. some initialization
 srand(0);
 for(n=0;n<NUM_CORES;n++) sum[n]=0;

 // 1. initialize OpenMP
 omp_set_num_threads(NUM_CORES);

 // 2. create samples in parallel
 #pragma omp parallel
 {
  unsigned int rnd_state=1; // some random seed
  sum[omp_get_thread_num()]=0;

  #pragma omp for
  for(n=0;n<NUM_SAMPLES/NUM_CORES;n++){
   x=rand_r(&rnd_state)/((double)(RAND_MAX));
   y=rand_r(&rnd_state)/((double)(RAND_MAX));
   sum[omp_get_thread_num()]+=((x*x+y*y)<1.)? 1 : 0;
  }

 }

 // 3. compute the final estimation for Pi
 res=0.;
 for(n=0;n<NUM_CORES;n++) res+=sum[n];
 res*=4./((double)(NUM_SAMPLES/NUM_CORES));

 // 4. show approximated result on screen
 printf("pi = 3.141592654 # approx = %01.08f\n",res);

 return(0);
}
