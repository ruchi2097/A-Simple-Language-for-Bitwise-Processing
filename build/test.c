#include <stdio.h>

#define BADINPUT 1
#define OKAY 0
int read_array(FILE* fin, int *array, int *size) {
  int ret = OKAY;
  for(int i=0; i<*size; i++)
  {
      if(1!=fscanf(fin, "%d", &array[i])) {
           *size = i;
           ret = BADINPUT; // error
           break;
      } 
  }
  return ret; //success
}


