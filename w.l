
%{

typedef struct
{
 char thestr[25];
 int ival;
 int ttype;
}tstruct ;

#define YYSTYPE tstruct

#include "w.tab.h"

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;

%}

%option yylineno


DIGIT  [0-9]
UC     [A-Z]
LC     [a-z]
L      [A-Za-z]

%%

vari     { return tint;}
vars	 { return tstr;}
printi 	 { return tprinti;}
printsh	 { return tprintstrhoriz;}
printsv	 { return tprintstrvert;}
"="       { return tassign;}



\"([^"]*)\"  { return tstrlit;}
{L}+     { strcpy( yylval.thestr, yytext); return tid; }
{DIGIT}+ { return tnum; }


@@.*\n   {} /* comments  */   


[ \t]     /* ignore whitespace */

\n       {}

<<EOF>>   yyterminate();  /* signal end of dialogue */

.         return yytext[0];

%%


void yyerror(char *s)  /* Called by yyparse on error */
{
  printf ("\terror: %s\n", s);
  printf ("ERROR: %s at line %d\n", s, yylineno);
}

