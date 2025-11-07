#include<stdio.h>
#include<stdlib.h>
#include<math.h>

// define the total number of kernels to be used
#define NUM_BLOCKS 10

__global__ void kernel(int *ret){
 int id=blockIdx.x;
 ret[id]=1;
}

int main(void)
{
 int n;
 int ret[NUM_BLOCKS];
 int *dev_ret;

 // memory allocation on GPU
 cudaMalloc((void**)&dev_ret,NUM_BLOCKS*sizeof(int));

 // call the kernel() funtion
 // run in parallel on NUM_BLOCKS blocks with 1 thread each
 kernel<<<NUM_BLOCKS,1>>>(dev_ret);

 // copy array from GPU to RAM
 cudaMemcpy(ret,dev_ret,NUM_BLOCKS*sizeof(int),cudaMemcpyDeviceToHost);

 // print "Hello World!"
 for(n=0;n<NUM_BLOCKS;n++){
  if(ret[n]==1) printf("Hello World from kernel #%d\n",n);
 }

 return(0);
}
