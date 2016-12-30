%{
	#include <malloc.h>
	#include <stdlib.h>
	#include <stdio.h>
	#include <math.h>
	#include <string.h>
	int yylex(void);
	int sym[26];
%}

%token INCD MAIN SCOM MCOM IF ELSE RETURN ASSIGN PLUS FACT MINUS MULT DIV GTRTHN LSTTHN MOD POW SIN COS TAN LOG VAR INTEGER FLOAT NEWLINE VOID INT DOUBLE STRING SM CM LP RP LB RB FR WH

%nonassoc IFX
%nonassoc ELSE
%left LSTTHN GTRTHN
%left PLUS MINUS
%left DIV MULT
%right MOD POW FACT

%%

program:
	   | program line
       ;
line: NEWLINE
    | import NEWLINE
	  | type MAIN LP RP LB start RB { printf("END OF MAIN\n"); }
    
	;

import: INCD { printf("VALID HEADER IMPORT\n"); }
	  | SCOM { printf("\n"); }
	  | MCOM { printf("\n"); }
	  ;

start:
     | start stmts
	 ;

stmts: NEWLINE
	| var_seq
	| stmt
  | SCOM { printf("\n"); }
  | MCOM { printf("\n"); }
	;

var_seq: type var SM { printf("VALID VARIABLE DECLARATION\n"); }
       ;

type: VOID
	| INT
	| DOUBLE
	| STRING
	;

var: var CM VAR
   | VAR
   ;
stmt: SM
	| exp SM {
				if($1)
				printf("VALUE IS: %d\n",$1);
	         }

    | VAR ASSIGN  exp SM {  
                            sym[$1] = $3;
							printf("VALUE OF THE VARIABLE %c: is %d\n",$1+'A',$3);
						 }

	| IF LP exp RP LB NEWLINE exp SM NEWLINE RB NEWLINE ELSE LB NEWLINE exp SM NEWLINE RB {
																								if($3)
																								{
																									printf("FROM IF: %d\n",$7);
																								}
																								else
																								{
																									printf("FROM ELSE: %d\n",$15);
																								}
	                                                                                      }

	| IF LP exp RP LB NEWLINE IF LP exp RP LB NEWLINE exp SM NEWLINE RB NEWLINE ELSE LB NEWLINE exp SM NEWLINE RB NEWLINE RB NEWLINE ELSE LB NEWLINE exp SM NEWLINE RB
	{
			if($3)
      {
        if($9)
        {
          printf("FROM IF IF: %d\n",$13);
        }
        else
        {
           printf("FROM IF ELSE: %d\n",$21);
        }
      }
      else
      {
         printf("FROM ELSE: %d\n",$31);
      }
	}

  | WH LP exp RP LB NEWLINE exp SM NEWLINE RB 
    {
        printf("FROM WHILE LOOP %d\n",$7);
    }

   | FR LP exp SM exp SM exp RP LB NEWLINE exp SM NEWLINE RB 
    {
        printf("FROM FOR LOOP %d\n",$11);
    }                                                                                              
   ;

exp: INTEGER { $$ = $1; }
   
   | VAR { $$ = sym[$1]; }

   | exp PLUS exp { $$ = $1 + $3; }
   
   | exp MINUS exp { $$ = $1 - $3; }
   
   | exp MULT exp { $$ = $1 * $3; }
   
   | exp DIV exp { 
   					if($3)
   					{
   						$$ = $1 / $3;
   					}

   					else
   					{
   						printf("ERROR: DIVISION BY ZERO\n");
   					} 
   				 }
   	| exp LSTTHN exp {
   				$$ = $1 < $3;
   			  }

   	| exp GTRTHN exp {
   						$$ = $1 > $3;
   			  		 }

    | exp MOD exp {
    				$$ = $1 % $3;
                  }

    | exp POW exp {
    				$$ = pow($1, $3);
                  }

    | SIN LP exp RP {
    				  $$ = 0;
    				  printf("SIN %d%c is: %lf\n",$3,248,sin(($3*3.1416)/180));
                    }

    | COS LP exp RP {
                      $$ = 0;
    				  printf("COS %d%c is: %lf\n",$3,248,cos(($3*3.1416)/180));
                    }

    | TAN LP exp RP {
                     $$ = 0;
    				  printf("TAN %d%c is: %lf\n",$3,248,tan(($3*3.1416)/180));
                    }

    | LOG LP exp RP {
                     $$ = 0;
    				  printf("LOG %d is: %lf\n",$3,log($3));
                    }                                  

    | LP exp RP {
    				$$ = $2;
          		}
    | FACT exp {
                  int i,fac=1;
                  for( i=1;i<=$2;i++)
                  {
                    fac = fac * i;
                  }
                  printf("%d! IS: %d\n",$1,fac);
               }          
   ;

%%


yyerror(char *s)
{
	printf("%s\n",s);
}