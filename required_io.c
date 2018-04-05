//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~target language~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <stdio.h>
#include <string.h>

#define MAX 100   //Maybe a greater/lesser value defined here    

int main(){
	
	int x;
	int y;
	char g[MAX]; //instead of the user initializing the string here they have the
		         //option to initalize it else where. An arbitrary MAX size is 
		         //defined here. (Let me know what everyone thinks about this)

	y = 11;
	x = 3 * y;
	printf("%d\n", x); 
	
	strncpy(g ,"hello world", sizeof(g));
	                      //this line would be omitted of course if 
					      //the user decides to initallize the
					      //string in the header
	printf("%s\n", g);    

	for(int i = 0; i < strlen(g); i++){  //prints the character array
		printf("%c\n", g[i]);            //vertically
	}

}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~target language~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~input format~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Input format:

	   vari x
	   vari y
	   vars g
	
	   y = 11
	   x = 3 * y
	   printi x

	   g = "hello world"
	   printsh g
	   printsv g

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~input format~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
