%{   
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "g.tab.h"
%}

%option noyywrap

INCLUDE "hashcover"[ ]+"LT"[ ]+[A-Za-z0-9]+".header"[ ]+"RT"
TYPE "faka"|"purno"|"khondokhondo"|"onekgulookkhor"
VARIABLE [A-Z]
INTEGER [0-9]+
FLOAT [0-9]*"."[0-9]+
SINGLECOMENT "!!"[^\n]*
MULTICOMENT "%&"[^"%&"]*"&%"
DELIM	[ \t]
WHITESP	{DELIM}+


%%

{INCLUDE}		{ return INCD; }
"main"			{ return MAIN; }
{SINGLECOMENT}	{ return SCOM; }
{MULTICOMENT}	{ return MCOM; }	
IC              { return IF;   }
OW				{ return ELSE; }
"LP"			{ return LP; }
"RP"			{ return RP; }
"LB"			{ return LB; }	
"RB"			{ return RB; }
"sm"			{ return SM; }
"cm"			{ return CM; }
"faka"			{ return VOID; }
"purno"			{ return INT; }
"khondokhondo"	{ return DOUBLE; }
"onekgulookkhor" { return STRING; }
"->"			{ return ASSIGN; }
"++"			{ return PLUS; }
"--"			{ return MINUS; }
"**"			{ return MULT; }
"//"			{ return DIV; }
"GTR"			{ return GTRTHN; }
"LST"			{ return LSTTHN; }
"MOD"			{ return MOD; }
"POW"           { return POW; }
"SIN"			{ return SIN; }
"COS"			{ return COS; }
"TAN"			{ return TAN; }
"LOG"			{ return LOG; }
"FACT"          { return FACT; }
"FOR"			{ return FR; }
"WHILE"         { return WH; }

{INTEGER}		{ 	sscanf(yytext, "%d", &yylval); 
					return INTEGER; 
				}

{FLOAT}			{ 
					sscanf(yytext, "%lf", &yylval);
					return FLOAT; 
				}

{VARIABLE}		{ 
					yylval = *yytext - 'A';
					return VAR; 
				}

{WHITESP}		{}
"\n"			{ return NEWLINE; }

%%

int main()
{
	yyin = freopen("input.txt", "r",stdin);
	yyparse();
	yyout = freopen("output.txt", "w",stdout);
	return 0;
}
