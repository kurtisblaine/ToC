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
%token tint
%token tstr
%token tprintint
%token tprintstrhoriz
%token tprintstrvert
%token tassign
%token tstrlit
%token tid
%token tnum

%locations

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

Dtail : ',' tid Dtail    { if(intab ($2.thestr)){
                                printf("%s is a Double-declared Variable at line %d\n", $1.thestr, yyloc.first_line);
                          }
                          else{
                               addtab($2.thestr);
                               addtype($2.thestr, $3.ttype);
                               $$.ttype = $3.ttype;
                         }
                         }
      |  type tid ';'    {
                           $$.ttype = $2.ttype;
                         }
      ;

type: tint {$$.ttype = 10;} | tstr {$$.ttype = 20;} ;




SL :  SL S   {printf("//statements\n");}
  | S        
  ;

S : tprintstrhoriz tstrlit ';'   {printf("//print string\n"); }
  | tprintstrhoriz tid ';'
              {
                printf("print id\n");
                if ( intab($2.thestr) )
                   printf("%s is declared line %d that\n", $2.thestr, @2.first_line);
                else
                   printf("UNDECLARED:: %s,(line %d) \n", $2.thestr, yyloc.first_line);
              }
  |  tprintstrvert tid ';'
              {
                printf("print id\n");
                if ( intab($2.thestr) )
                   printf("%s is declared line %d that\n", $2.thestr, @2.first_line);
                else
                   printf("UNDECLARED:: %s,(line %d) \n", $2.thestr, yyloc.first_line);
              }
  |  tid tassign expr ';'
              {
                printf("assign\n");
                if ( intab($1.thestr) )
                 printf("%s is declared\n", $1.thestr);
                else
                   printf("UNDECLARED:: %s \n", $1.thestr);

                $1.ttype = gettype($1.thestr);
                if ($1.ttype > 0 )
                {
                  if ($1.ttype == 20 && $3.ttype == 10) ;
                  else if ($1.ttype == 10 && $3.ttype == 10) ;
                  else if ($1.ttype == 30 && $3.ttype == 30) ;
                  else if ($1.ttype == 20 && $3.ttype == 20) ;
                  else printf("Incompatible ASSIGN types %d to %d (line %d)\n",$3.ttype, $1.ttype, yyloc.first_line);
                }
              }

  | error ';' {printf("ERROR in statement(line %d)\n", yyloc.first_line);}
  ;





expr : expr '+' term
             {
                if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                }
               else if ($1.ttype == 20 && $3.ttype == 20) {
                           $$.ttype = 20;
                }
               else if ($1.ttype == 20 && $3.ttype == 10){
                          $$.ttype = 20;
                }
               else if ($1.ttype == 10 && $3.ttype == 20){
                          $$.ttype = 20;
                }
               else $$.ttype = -1;
             }
| expr '-' term {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                        }
                else if ($1.ttype == 20 && $3.ttype == 20){
                          $$.ttype = 20;
                }
               else if ($1.ttype == 20 && $3.ttype == 10){
                          $$.ttype = 20;
                }
               else if ($1.ttype == 10 && $3.ttype == 20){
                          $$.ttype = 20;
                }
                else $$.ttype = -1;
             }
  |  term      { $$.ttype = $1.ttype; }
  ;

term : term '*' factor
             {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                }
               else if ($1.ttype == 20 && $3.ttype == 20){
                          $$.ttype = 20;
                }
                else if ($1.ttype == 20 && $3.ttype == 10){
                          $$.ttype = 20;
                }
               else if ($1.ttype == 10 && $3.ttype == 20){
                          $$.ttype = 20;
                }
               else $$.ttype = -1;
             }

 | term '/' factor {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 20;
                }
               else if ($1.ttype == 20 && $3.ttype == 20){
                          $$.ttype = 20;
                }
                else if ($1.ttype == 20 && $3.ttype == 10){
                          $$.ttype = 20;
                }
               else if ($1.ttype == 10 && $3.ttype == 20){
                          $$.ttype = 20;
                }

               else $$.ttype = -1;
             }
  | factor       {$$.ttype = $1.ttype;}

factor : tid
              {
                if ( intab($1.thestr) )
                   printf("%s is declared\n", $1.thestr);
                else
                   printf("UNDECLARED:: %s \n", $1.thestr);
                $$.ttype = gettype($1.thestr);
                if ($$.ttype > 0 )
                      ;
                else
                        yyerror("Type ERROR:::");
              }


  | tstr         {$$.ttype = 20;}
  | tnum         {$$.ttype = 10;}
  | '(' expr ')' {$$.ttype = $2.ttype;}
  ;

%%

int main()
{
  yyparse ();
}



