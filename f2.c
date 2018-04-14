//~~~~~~~~~~~~~~~~~~~START~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~
#include <stdio.h>
#include <string.h>

#define MAX 100
int main(){

int integer1;
int integer;
char string[MAX];
strncpy(string , "REALLY COOL STRING" , sizeof(string));
integer1 = 52 - 2 * 1 / 5;
integer = 1 + integer1;
printf("%d\n", integer);
for(int i = 0; i < strlen( string ); i++) printf("%c\n", string[i]); 

return 0;
}
//~~~~~~~~~~~~~~~~~~~END~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~
