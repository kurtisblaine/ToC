%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct
{
 char thestr[1000];
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
%token tprintsh
%token tprintsv
%token tassign
%token tstrlit
%token tid
%token tnum

%locations






%%

Begin: SL {
          printf("//~~~~~~~~~~~~~~~~~~~START~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~");
          printf("\n#include <stdio.h>\n");
          printf("#include <string.h>\n\n");
          printf("#define MAX 100\n");
          printf("int main(){\n\n");
          printf("%s", $1.thestr);
          printf("\nreturn 0;\n");
          printf("}\n");
          printf("//~~~~~~~~~~~~~~~~~~~END~PROGRAM~~~~~~~~~~~~~~~~~~~~~~~\n");
          }
    ;

SL :  SL S   {
              sprintf( $$.thestr, "%s%s", $1.thestr, $2.thestr);
              }
  | S       { 
              sprintf( $$.thestr, "%s", $1.thestr); 
            }  
  ;

S : D { sprintf( $$.thestr, "%s", $1.thestr);}
  | P { sprintf( $$.thestr, "%s", $1.thestr);}
;

D : type tid  {
                   if(intab ($2.thestr)){
                         printf("%s is a Double-declared Variable at line %d\n", $2.thestr, yyloc.first_line);
                         exitNow();
                        }
                   else{
                         addtab($2.thestr);
                         addtype($2.thestr, $1.ttype);
                         if (gettype($2.thestr) == 20){
                             sprintf($$.thestr, "%s%s[MAX];\n", $1.thestr, $2.thestr);
                         }
                         else{
                              sprintf($$.thestr, "%s%s;\n", $1.thestr, $2.thestr);
                         }
                  }
        }
  | A { strcpy($$.thestr, $1.thestr); }
  ;



A : tid tassign expr
          {
                if ( !intab($1.thestr) ){
                     printf("UNDECLARED:: %s \n", $1.thestr);
                     exitNow();
                }

                else{
                  if (gettype($1.thestr) > 0 )
                  {
                    if ((gettype($1.thestr) == 10 && $3.ttype == 10) || (gettype($1.thestr) == 20 && $3.ttype == 20)){
                        if((gettype($1.thestr) == 10 && $3.ttype == 10))
                        sprintf( $$.thestr, "%s = %s;\n", $1.thestr, $3.thestr);
                        else 
                        sprintf( $$.thestr, "strncpy(%s , %s , sizeof(%s));\n", $1.thestr, $3.thestr, $1.thestr);
                    } 
  
                    else {
                     printf("Incompatible ASSIGN types %d to %d (line %d)\n",$3.ttype, $1.ttype, yyloc.first_line);
                     exitNow();
                    }
                  }
                  }
            }
    |
    
  ;

type: tint {$$.ttype = 10; strcpy($$.thestr, "int ");} 
    | tstr {$$.ttype = 20; strcpy($$.thestr, "char "); } ;

P : tprinti expr   
              {
              if($2.ttype == 10){
                if ( intab($2.thestr) ){
                   sprintf($$.thestr, "printf(\"%%d\\n\", %s);\n", $2.thestr);
                  }
                else{
                   printf("UNDECLARED:: %s (line %d) \n", $2.thestr, yyloc.first_line);
                   exitNow(); }
                }
              else{ printf("INVALID TYPE:: %s (line %d) \n", $2.thestr, yyloc.first_line);
              exitNow(); 
              }
              }

  | tprintsh expr {
              if($2.ttype == 20 ){
                sprintf($$.thestr,"//printing\n");
                if ( intab($2.thestr) )
                   sprintf($$.thestr,"printf(\"%%s\\n\", %s);\n", $2.thestr);
                else {
                   printf("UNDECLARED:: %s,(line %d) \n", $2.thestr, yyloc.first_line);
                   exitNow();
                   }
              }
              else{ 
              printf("INVALID TYPE:: %s (line %d) \n", $2.thestr, yyloc.first_line);
              exitNow(); }
    }

  |  tprintsv expr{
              if($2.ttype == 20 ) {
                sprintf($$.thestr, "//printing\n");
                  if ( intab($2.thestr) ){
                    sprintf($$.thestr,"for(int i = 0; i < strlen( %s ); i++) printf(\"%%c\\n\", %s[i]); \n", $2.thestr, $2.thestr);
                  }

                  else{
                     printf("INVALID VAR:: %s (line %d) \n", $2.thestr, yyloc.first_line);
                     exitNow();
                  }
               }
               else{ 
                  printf("INVALID TYPE:: %s (line %d) \n", $2.thestr, yyloc.first_line);
                  exitNow();
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
                          sprintf($$.thestr, "%s + %s", $1.thestr, $3.thestr);
                }
               else $$.ttype = -1;
             }
| expr '-' term {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                          sprintf($$.thestr, "%s - %s", $1.thestr, $3.thestr);
                }
                else $$.ttype = -1;
             }
  |  term      { $$.ttype = $1.ttype; }
  ;

term : term '*' factor
             {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                          sprintf($$.thestr, "%s * %s", $1.thestr, $3.thestr);
                }
               else $$.ttype = -1;
             }

 | term '/' factor {
               if ($1.ttype == 10 && $3.ttype == 10){
                          $$.ttype = 10;
                          sprintf($$.thestr, "%s / %s", $1.thestr, $3.thestr);
                }
               else $$.ttype = -1;
             }
  | factor       {$$.ttype = $1.ttype;}
;


factor : tnum     { 
                   strcpy($$.thestr, $1.thestr);
                   $$.ttype = 10;
                  }
  |tstrlit       { $$.ttype = 20;
                    strcpy($$.thestr, $1.thestr);
                  }
  |'(' expr ')' {  $$.ttype = $2.ttype;
                   sprintf($$.thestr, "( %s )", $2.thestr);
                  }
  |tid
              {
                if ( intab($1.thestr) ){
                   strcpy($$.thestr, $1.thestr);
                   $$.ttype = gettype($1.thestr);
                }
                else{
                     yyerror("Type ERROR:");
                     exitNow();
                    }
                }
  ;

%%

int main()
{ yyparse (); }
