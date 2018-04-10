%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct
{
 char thestr[25];
 int ttype;
 int ival;
}tstruct ;

#define YYSTYPE tstruct

int yylex();
void yyerror( char *s );

#include "symtab.c"


%}

%token tstart
%token tfinish
%token tbegin
%token tend
%token tint
%token tstr
%token tprintint
%token tprintsrthoriz
%token tprintstrvert
%token teq
%token tstrlit
%token tid
%token tnum
%token tfnum

%define locations

%%

p : prog {printf("#include <stdio.h>\n");
          printf("#include <string.h>\n");
          };

prog : tstart  tfinish
 |  tstart DL SL tfinish  {printf("int main(){\n");}
 ;

DL :  DL D   {printf("//declarations\n");}
  | D        
  ;

D : tid Dtail    {
                   if(intab ($1.thestr))
                         printf("%s is a Double-declared Variable at line %d\n", $1.thestr, yyloc.first_line);
                   else{
                         addtab($1.thestr);
                         addtype($1.thestr, $2.ttype);
                        }
                  }
  ;

Dtail : tid Dtail ';'   { if(intab ($2.thestr)){
                                printf("%s is a Double-declared Variable at line %d\n", $1.thestr, yyloc.first_line);
                          }
                          else{
                               addtab($2.thestr);
                               addtype($2.thestr, $3.ttype);
                               $$.ttype = $3.ttype;
                         }
                         }
      |  ':' type ';'    {
                           $$.ttype = $2.ttype;
                         }
      ;

DL :  SL  END
 {
   printf("//------------- START\n\n");
   printf("%s", $2.str);
   printf("%s", $3.str);
   printf("\n");
   printf("//------------- FINISH\n");
       }
       ;

DL : DL D       { sprintf($$.str, "%s%s", $1.str, $2.str);      }
   | D          { sprintf($$.str, "%s", $1.str);                }
   ;

D: type ' ' ID  '\n'
	{ if( $3.ttype == 10 ) 
			printf(" int %s ;\n", $3.str);
 	  else if ( $3.ttype == 20 ) 
			printf(" char s[80] ;\n", $3.str);
	  else 
			printf("ERROR - illegal type for %s.\n", $3.type); }
 ;

type: VARI     { $$.ttype = 10; }
    | VARS     { $$.ttype = 20; } 
    ;




