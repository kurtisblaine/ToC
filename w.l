
%{

typedef struct
{
 char thestr[100];
 int ttype;
}tstruct ;

#define YYSTYPE tstruct

#include "w.tab.h"

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;

%}

%option yylineno


DIGIT  [0-9]
L      [A-Za-z]

%%

vari     { return tint;}
vars	 { return tstr;}
printi 	 { return tprinti;}
printsh	 { return tprintsh;}
printsv	 { return tprintsv;}
"="      { return tassign;}



\"([^"]*)\"          { strcpy( yylval.thestr, yytext); return tstrlit;}
{L}+{DIGIT}*         { strcpy( yylval.thestr, yytext); return tid; }
{DIGIT}+             { strcpy( yylval.thestr, yytext); return tnum; }


@@.*\n   {} /* comments  */   


[ \t]     /* ignore whitespace */

\n       {}

<<EOF>>   yyterminate();  /* signal end of dialogue */

.         return yytext[0];

%%


void yyerror(char *s)  /* Called by yyparse on error */
{
  printf ("ERROR: %s at line %d\n", s, yylineno);
}

