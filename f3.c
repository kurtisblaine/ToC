//~~~~~~~~~~~~~~~~~~~START~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~
#include <stdio.h>
#include <string.h>

#define MAX 100
int main(){

int x;
int num;
int num2;
char string[MAX];
char string2[MAX];
num2 = 5;
x = 2 * ( 11 - 1 );
num = x + num2;
printf("%d\n", num);
strncpy(string , "This string is to be printed horizontally" , sizeof(string));
strncpy(string2 , "This string is to be printed vertically" , sizeof(string2));
printf("%s\n", string);

for(int i = 0; i < strlen( string2 ); i++) printf("%c\n", string2[i]); 

return 0;
}
//~~~~~~~~~~~~~~~~~~~END~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~
