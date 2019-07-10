%{
#include "trabalho-v3.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
[ \t\n]     ;
"PRINT"		{return PRINT;}
"exit"		{return exit_command;}

"ENTRADA"   {return ENTRADA;}
"FIM"       {return FIM;}
"SAIDA"     {return SAIDA;}
"FACA"      {return FACA;}
"VEZES"     {return VEZES;}
"ENQUANTO"  {return ENQUANTO;}
"SE"        {return SE;}
"ENTAO"     {return ENTAO;}
"SENAO"     {return SENAO;}
"FIMSE"     {return FIMSE;}
"("         {return AP;}
")"         {return FP;}
"="         {return EQUAL;}
"INC"       {return INC;}
"ZERA"      {return ZERA;}
\n          {return FIMDELINHA;}

[a-zA-Z]            { yylval.letra = yytext[0]; return id; }
[;]               	{return yytext[0];}
.                   {ECHO; yyerror ("character inesperado.");}

%%
int yywrap (void) {return 1;}