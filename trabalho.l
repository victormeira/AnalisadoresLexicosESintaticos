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

"INC\("[a-z]"\)"        {yylval = yytext[4]; return  INC;} /* id is in position 4 of string */
"ZERA\("[a-z]"\)"       {yylval = yytext[5]; return ZERA;} /* id is in position 5 of string */
[a-z]    { yylval = yytext[0]; return VAR; }
.        { showError(); return (OUTRO) }

void showError(){
    printf("\nEntrada fora da sintaxe: %s\nSomente sao aceitos numeros.\n", yytext);
}
