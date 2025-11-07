#include<stdio.h>
#include<stdlib.h>
#include<math.h>

// total number of samples/points created
#define NUM_SAMPLES 100000

// total number of parallel blocks to use
#define NUM_BLOCKS 10

__global__ void kernel(int num_samples,int *sum){
 int n;
 int res;
 int rnd;
 int id=blockIdx.x;
 double x;
 double y;

 // seed for the pseudo-random number generator (linear congruential)
 rnd=38467+id;

 res=0;

 for(n=0;n<num_samples;n++){
  rnd=fmod(1027.*rnd,1048576.);
  x=rnd/1048576.; // rnd() in [0, 1]
  rnd=fmod(1027.*rnd,1048576.);
  y=rnd/1048576.; // rnd() in [0, 1]
  res+=((x*x+y*y)<1.)? 1 : 0;
 }

 sum[id]=res;
}

int main(void)
{
 int n;
 int *dev_sum;
 int sum[NUM_BLOCKS];
 double res;

 // memory allocation on GPU
 cudaMalloc((void**)&dev_sum,NUM_BLOCKS*sizeof(int));

 // compute the number Pi in parallel
 kernel<<<NUM_BLOCKS,1>>>(NUM_SAMPLES,dev_sum);

 // copy array from GPU to RAM
 cudaMemcpy(sum,dev_sum,NUM_BLOCKS*sizeof(int),cudaMemcpyDeviceToHost);

 // compute approximation for Pi
 res=0.;
 for(n=0;n<NUM_BLOCKS;n++) res+=sum[n];
 res*=4./((double)(NUM_SAMPLES*NUM_BLOCKS));

 // 4. show approximated result on screen
 printf("pi = 3.141592654 # approx = %01.08f\n",res);

 return(0);
}
