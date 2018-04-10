
%{

typedef struct
{
 char thestr[25];
 int ival;
 int ttype;
}tstruct ;

#define YYSTYPE  tstruct

#include "w.tab.h"
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;
%}

%option yylineno


DIGIT  [0-9]
UC     [A-Z]
LC     [a-z]
L      [A-Za-z]

%%

START    { return tstart;}
FINISH   { return tfinish;}
BEGIN    { return tbegin;}
END      { return tend;}
vari     { return tint;}
vars	 { return tstr;}
printi 	 { return tprintint}
printsh	 { return tprintsrthoriz}
printv	 { return tprintstrvert}
EQ       { return teq;}


\"([^"]*)\"  { return tstrlit;}
{L}+     { strcpy( yylval.thestr, yytext); return tid; }
{DIGIT}+ { return tnum; }
{DIGIT}+"."{DIGIT}{DIGIT} {return tfnum;}


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

