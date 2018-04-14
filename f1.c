//~~~~~~~~~~~~~~~~~~~START~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~
#include <stdio.h>
#include <string.h>

#define MAX 100
int main(){

int x;
int y;
int z;
char g[MAX];
char h[MAX];
y = 211;
x = 2 + 4 * 2;
z = y / 11;
printf("%d\n", x);
printf("%d\n", y);
printf("%d\n", z);
strncpy(h , "Declaring string down here" , sizeof(h));
strncpy(g , "writing text vertically and horizontally" , sizeof(g));
printf("%s\n", g);

for(int i = 0; i < strlen( g ); i++) printf("%c\n", g[i]); 

printf("%s\n", h);

for(int i = 0; i < strlen( h ); i++) printf("%c\n", h[i]); 

return 0;
}
//~~~~~~~~~~~~~~~~~~~END~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~
