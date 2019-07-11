%{
        #include <stdlib.h>
        #include <stdio.h>
        #include <string.h>
  	FILE * arquivo;
        int yylex();
        char * destino;
        void yyerror(const char *s){
                fprintf(stderr, "%s\n", s);
        };
        char outList[50] = "";
        int labelCounter = 0;
        int labelHeap[25];
        int labelHeapIndx = 0;
        int auxCounter = 0;
        int auxHeap[25];
        int auxHeapIndx = 0;
%}
%union
 {
   char *letra;
   int  numero;
};
%type <letra> inicio linhas linha expressao varlist cmds cmd casoSenao;
%token<letra> ENTRADA SAIDA FACA VEZES ENQUANTO SE ENTAO SENAO INC ZERA FIMFACA FIMSENAO FIMENQUANTO FIMSE FIM FIMENTAO;
%token<numero> FIMDELINHA IGUAL AP FP PROGRAM;
%token<letra> id;
%start inicio
%%
inicio          : PROGRAM linhas {printf ("Fim");}
                ;
linhas          : linha {$$ = $1;}
                | linha linhas {char * destino = malloc(strlen($1) + strlen($2) + 1); strcpy(destino, $1); strcat(destino, ";\n"); strcat(destino, $2); $$=destino;}
                ;
linha           : expressao FIMDELINHA {$$ = $1;}
                ;
expressao       : ENTRADA varlist {arquivo = fopen("Saida.txt","w"); fprintf (arquivo,"\ninput (%s)\n", $2);}
                | SAIDA varlist {destino = (char *)malloc(12+(strlen($2))*sizeof(char)); strcpy(destino,"\noutput("); strcat(destino,$2); strcat(destino,");\n");}
                | cmds {;}
                | FIM {	fputs(destino,arquivo); fprintf (arquivo,"\nEOF\n");fclose(arquivo); exit(1);}
                ;
varlist         : id varlist {char * destino = malloc(strlen($1) + strlen($2) + 1); strcpy(destino, $1); strcat(destino, ","); strcat(destino, $2); $$=destino;}
                | id {$$ = $1;}
                ;
cmds            : cmd cmds {char * destino = malloc(strlen($1) + strlen($2) + 1); strcpy(destino, $1); strcat(destino, ";\n"); strcat(destino, $2); $$=destino;}
                | cmd {$$=$1;}
                ;
cmd             : FACA id VEZES                 { auxCounter++; fprintf(arquivo, "aux%d = %s", auxCounter, $2); auxHeap[auxHeapIndx] = auxCounter; auxHeapIndx++; labelCounter++; fprintf(arquivo,"\nL%d:\n", labelCounter); labelHeap[labelHeapIndx] = labelCounter + 1; labelHeapIndx++; labelHeap[labelHeapIndx] = labelCounter; labelCounter++; fprintf (arquivo,"if aux%d == 0 goto L%d\n", auxCounter, labelCounter);}
                                                FIMDELINHA cmds FIMFACA
                                                { auxHeapIndx--; fprintf(arquivo, "aux%d = aux%d - 1\n", auxHeap[auxHeapIndx], auxHeap[auxHeapIndx]), fprintf(arquivo,"goto L%d\n", labelHeap[labelHeapIndx]); labelHeapIndx--; fprintf(arquivo,"L%d:\n", labelCounter); labelHeapIndx--; $$ = $1; }
                | ENQUANTO id FACA              { labelCounter++; fprintf(arquivo,"\nL%d:\n", labelCounter); labelHeap[labelHeapIndx] = labelCounter + 1; labelHeapIndx++; labelHeap[labelHeapIndx] = labelCounter; labelCounter++; fprintf (arquivo,"if %s == 0 goto L%d\n", $2, labelCounter);}
                                                FIMDELINHA cmds FIMENQUANTO
                                                { fprintf(arquivo,"goto L%d\n", labelHeap[labelHeapIndx]); labelHeapIndx--; fprintf(arquivo,"\nL%d:\n", labelCounter); labelHeapIndx--; $$ = $1; }
                
                
                
                
                | SE id ENTAO                   { labelCounter++; labelHeap[labelHeapIndx] = labelCounter; labelHeapIndx++; fprintf (arquivo,"if %s == 0 goto L%d\n", $2, labelCounter);}
                                                FIMDELINHA cmds FIMSE                                               
                
                
                
                
                
                | id IGUAL id FIMDELINHA        { fprintf (arquivo,"%s = %s\n",$1,$3);}
                | INC AP id FP FIMDELINHA       { fprintf (arquivo,"%s = %s + 1\n", $3, $3); $$=$3;}
                | ZERA AP id FP FIMDELINHA      { fprintf (arquivo,"%s = 0\n",$3);}
                ;
casoSenao       : SENAO { labelCounter++; fprintf(arquivo,"goto L%d\n", labelCounter); fprintf(arquivo,"\nL%d:\n",labelHeap[labelHeapIndx-1]); labelHeap[labelHeapIndx - 1] = labelCounter; } FIMDELINHA cmds FIMSENAO { fprintf(arquivo,"\nL%d\n", labelHeap[labelHeapIndx-1]); labelHeapIndx--; $$ = $1; }
                |       { ; fprintf(arquivo,"\nL%d:\n", labelHeap[labelHeapIndx - 1]); labelHeapIndx--; } linha {$$ = $2;}
                ;
%%
int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}