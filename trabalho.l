%option yywrap
      #include <stdio.h>
      #include <string.h>
      #include "sequenciacomandos.tab.h"
%%
[\t\n]
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
//INC       {return INC;}
//ZERA      {return ZERA;}
[0-9]+ { yylval = atoi(yytext); return NUM; }
.        { showError(); return (OUTRO) }

void showError(){
    printf("\nEntrada fora da sintaxe: %s\nSomente sao aceitos numeros.\n", yytext);
}
