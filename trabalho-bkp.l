%{
#include "trabalho.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
[ \t\n]     ;
"print"		{return print;}
"exit"		{return exit_command;}
"ENTRADA"   {return ENTRADA;}
"FIM"       {return FIM;}
"FACA"      {return FACA;}
"VEZES"     {return VEZES;}
"SE"        {return SE;}
"ENTAO"     {return ENTAO;}
"SENAO"     {return SENAO;}
"FIMSE"     {return FIMSE;}
\n          {return FIMDELINHA;}
"="         {return IGUAL;}

"INC\("[a-z]"\)"    { yylval = yytext[4]; return  INC; } /* id is in position 4 of string */
"ZERA\("[a-z]"\)"   { yylval = yytext[5]; return ZERA; } /* id is in position 5 of string */
[a-zA-Z]            { yylval.id = yytext[0]; return ID; }
.                   { showError(); return (OUTRO) }

%%
int yywrap (void) {return 1;}

void showError(){
    printf("\nEntrada fora da sintaxe: %s\nSomente sao aceitos numeros.\n", yytext);
}
