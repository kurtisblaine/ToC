//~~~~~~~~~~~~~~~~~~~START~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~
#include <stdio.h>
#include <string.h>

#define MAX 100
int main(){

int x;
int y;
char g[MAX];
y = 11;
x = 3 * y;
printf("%d\n", x);
strncpy(g , "cool" , sizeof(g));
printf("%s\n", g);

for(int i = 0; i < strlen( g ); i++) printf("%c\n", g[i]); 

return 0;
}
//~~~~~~~~~~~~~~~~~~~END~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~
