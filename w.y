%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct
{
 char thestr[750];
 int ttype;
}tstruct ;

#define YYSTYPE tstruct

int yylex();
void yyerror( char *s );

#include "symtab.c"






%}

%token tint
%token tstr
%token tprinti
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
          printf("#define MAX 100\n");
          printf("int main(){\n");
          printf("return 0;\n");
          printf("}\n");
         }
;

prog: DL SL
 ;


DL :  DL D   { printf( "%s%s", $1.thestr, $2.thestr);}
  | D        { printf( "%s", $1.thestr);             }
  ;

D : type tid  {
                   if(intab ($2.thestr)){
                         printf("%s is a Double-declared Variable at line %d\n", $1.thestr, yyloc.first_line);
                         exitNow();
                        }
                   else{
                         addtab($2.thestr);
                         addtype($2.thestr, $1.ttype);

                         printf( "%s %s;\n", $1.thestr, $2.thestr);
                        }
                  }

  |  tid tassign expr
          {
                printf("//assign\n");
                if ( !intab($1.thestr) ){
                     printf("UNDECLARED:: %s \n", $1.thestr);
                     exitNow();
                }

                else{
                  $1.ttype = gettype($1.thestr);
                  if ($1.ttype > 0 )
                  {
                    if (($1.ttype == 10 && $3.ttype == 10) || ($1.ttype == 20 && $3.ttype == 20)){
                        printf( "%s = %s;\n", $1.thestr, $3.thestr);
                    } 
  
                    else {
                     printf("Incompatible ASSIGN types %d to %d (line %d)\n",$3.ttype, $1.ttype, yyloc.first_line);
                     exitNow();
                    }
                  }
                  }
            }
  ;

type: tint {$$.ttype = 10; strcpy($$.thestr, "int ");} | tstr {$$.ttype = 20; strcpy($$.thestr, "char ");} ;


SL :  SL S   {
              printf("//statements\n"); 
              printf( "%s%s", $1.thestr, $2.thestr);
              }
  | S       { 
              printf( "%s", $1.thestr);
            }  
  ;

S : tprintstrhoriz tstrlit   
              {
                printf("//printing");
                if ( intab($2.thestr) )
                   printf("printf(\"%%s\", %s);\n", $2.thestr);
                else
                   printf("UNDECLARED:: %s,(line %d) \n", $2.thestr, yyloc.first_line);
                   exitNow();
              }

  | tprintstrhoriz tid
              {
                printf("//printing\n");
                if ( intab($2.thestr) )
                   printf("printf(\"%%s\", %s);\n", $2.thestr);
                else
                   printf("UNDECLARED:: %s,(line %d) \n", $2.thestr, yyloc.first_line);
                   exitNow();
              }

  |  tprintstrvert tid
              {
                printf("//printing\n");

                if ( intab($2.thestr) )
                  printf("for(int i = 0; i < strlen( %s ); i++){ printf(\"%%c\\n\", %s[i]);}\n", $2.thestr, $2.thestr);

                else
                   printf("UNDECLARED:: %s,(line %d) \n", $2.thestr, yyloc.first_line);
                   exitNow();
              }
  | tid tassign expr
          {
                printf("//assign\n");
                if ( !intab($1.thestr) ){
                     printf("UNDECLARED:: %s \n", $1.thestr);
                     exitNow();
                }

                else{
                  $1.ttype = gettype($1.thestr);
                  if ($1.ttype > 0 )
                  {
                    if (($1.ttype == 10 && $3.ttype == 10) || ($1.ttype == 20 && $3.ttype == 20)){
                        printf( "%s = %s;\n", $1.thestr, $3.thestr);
                    } 
  
                    else {
                     printf("Incompatible ASSIGN types %d to %d (line %d)\n",$3.ttype, $1.ttype, yyloc.first_line);
                     exitNow();
                    }
                  }
                  }
            }
  | error ';' {
                printf("ERROR in statement(line %d)\n", yyloc.first_line);
                exitNow();
              }
  ;





expr : expr '+' term
             {
                if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                          printf( "%s + %s\n", $1.thestr, $3.thestr);
                }
               else $$.ttype = -1;
             }
| expr '-' term {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                          printf( "%s - %s\n", $1.thestr, $3.thestr);
                }
                else $$.ttype = -1;
             }
  |  term      { $$.ttype = $1.ttype; }
  ;

term : term '*' factor
             {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                          printf( "%s * %s\n", $1.thestr, $3.thestr);
                }
               else $$.ttype = -1;
             }

 | term '/' factor {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                          printf( "%s / %s\n", $1.thestr, $3.thestr);
                }
               else $$.ttype = -1;
             }
  | factor       {$$.ttype = $1.ttype;}

factor : tid
              {
                if ( intab($1.thestr) ){
                   strcpy($$.thestr, $1.thestr);
                   $$.ttype = gettype($1.thestr);
                }
                else{
                   $$.ttype = gettype($1.thestr);
                   if ($$.ttype > 0 ) ; 
                   else{
                     yyerror("Type ERROR:");
                     exitNow();
                    }
                }
              }

  | tstr         { $$.ttype = 20;
                   strcpy($$.thestr, $1.thestr);
                  }
  | tnum         { $$.ttype = 10;
                   strcpy($$.thestr, $1.thestr);
                  }
  | tstrlit       { $$.ttype = 20;
                    strcpy($$.thestr, $1.thestr);
                  }
  | '(' expr ')' { $$.ttype = $2.ttype;
                   printf( "( %s )\n", $2.thestr);
                  }
  ;

%%

int main()
{ yyparse (); }
