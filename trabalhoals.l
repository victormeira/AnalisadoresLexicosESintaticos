%option yywrap
      #include <stdio.h>
      #include <string.h>
      #include "trabalhoals.tab.h"
%%
ENTRADA 	{printf("ENTRADA "); return ENTRADA;}
SAIDA       {printf("SAIDA "); return SAIDA;}
Program     {printf("Program "); return PROGRAM;}
FIM         {printf("FIM "); return FIM;}
FACA        {printf("FACA "); return FACA;}
VEZES       {printf("VEZES "); return VEZES;}
ENQUANTO    {printf("ENQUANTO "); return ENQUANTO;}
SE          {printf("SE "); return SE;}
ENTAO       {printf("ENTAO "); return ENTAO;}
SENAO       {printf("SENAO "); return SENAO;}
INC         {printf("INC "); return INC;}
ZERA        {printf("ZERA "); return ZERA;}
FIMFACA     {printf("FIMFACA "); return FIMFACA;}
FIMSENAO    {printf("FIMSENAO "); return FIMSENAO;}
FIMENQUANTO {printf("FIMENQUANTO "); return FIMENQUANTO;}
FIMSE       {printf("FIMSE "); return FIMSE;}
[0-9]+      {printf("%s ",yytext); yylval.numero=atoi(yytext);};
[a-zA-Z]+   {printf("%s ",yytext); yylval.letra=strdup(yytext); return id;};
\n          {printf("\n"); return FIMDELINHA;};
"="         {printf("IGUAL "); return IGUAL;};
"("         {printf("AP "); return AP;};
")"         {printf("FP "); return FP;};
.           ;