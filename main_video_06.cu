#include<stdio.h>
#include<stdlib.h>
#include<math.h>

// define the total number of kernels to be used
#define NUM_BLOCKS 10

__global__ void kernel(int *a,int *b,int *c){
 int id=blockIdx.x;
 c[id]=a[id]+b[id];
}

int main(void)
{
 int n;
 int *dev_a;
 int *dev_b;
 int *dev_c;
 int a[NUM_BLOCKS];
 int b[NUM_BLOCKS];
 int c[NUM_BLOCKS];

 // memory allocation on GPU
 cudaMalloc((void**)&dev_a,NUM_BLOCKS*sizeof(int));
 cudaMalloc((void**)&dev_b,NUM_BLOCKS*sizeof(int));
 cudaMalloc((void**)&dev_c,NUM_BLOCKS*sizeof(int));

 // populate arrays a[] and b[]
 for(n=0;n<NUM_BLOCKS;n++){
  a[n]=-n;
  b[n]=n+1;
 }

 // copy a[] and b[] from RAM to GPU
 cudaMemcpy(dev_a,a,NUM_BLOCKS*sizeof(int),cudaMemcpyHostToDevice);
 cudaMemcpy(dev_b,b,NUM_BLOCKS*sizeof(int),cudaMemcpyHostToDevice);

 // call the kernel() funtion
 // run in parallel on NUM_BLOCKS blocks with 1 thread each
 kernel<<<NUM_BLOCKS,1>>>(dev_a,dev_b,dev_c);

 // copy array c[] from GPU to RAM
 cudaMemcpy(c,dev_c,NUM_BLOCKS*sizeof(int),cudaMemcpyDeviceToHost);

 // show solution on screen
 for(n=0;n<NUM_BLOCKS;n++) printf("#1 %d + %d = %d\n",a[n],b[n],c[n]);

 return(0);
}
