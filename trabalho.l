%option yywrap
      #include <stdio.h>
      #include <string.h>
      #include "sequenciacomandos.tab.h"
%%
[\t\n]
do          {return DO;}
while       {return WHILE;}

fim         return(FIM);
program     return(ENTRADA);

[0-9]+ { yylval = atoi(yytext); return NUM; }
.        { showError(); return (OUTRO) }

\n       {return FIMDELINHA;}   
"="      {return IGUAL;}
"+"      {return MAIS;}
"*"      {return MULT;}
"("      {return AP;}
")"      {return FP;}
"{"      {return AC;}
"}"      {return FC;}
";"      {return PV;}

void showError(){
    printf("\nEntrada fora da sintaxe: %s\nSomente sao aceitos numeros.\n", yytext);
}