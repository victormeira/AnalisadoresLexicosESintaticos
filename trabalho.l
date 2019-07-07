%option yywrap
      #include <stdio.h>
      #include <string.h>
      #include "sequenciacomandos.tab.h"
%%

fim         return(FIM);
program     return(ENTRADA);

numeros     ([0-9])+      

{numeros}   { yylval.numero = atoi(yytext); return NUM; }
.           { showError(); return (OUTRO) }

\n       return(FIMDELINHA);    
"="      return(IGUAL);
"+"      return(MAIS);
"*"      return(MULT);
"("      return(AP);
")"      return(FP);

void showError(){
    printf("\nEntrada fora da sintaxe: %s\nSomente sao aceitos numeros.\n", yytext);
}