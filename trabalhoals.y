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

        char currentOp = 'c';
%}
%union
 {
   char *letra;
   int  numero;
};
%type <letra> inicio linhas linha expressao varlist cmds cmd check;
%token<letra> ENTRADA SAIDA FACA VEZES ENQUANTO SE ENTAO SENAO INC ZERA FIMFACA FIMSENAO FIMENQUANTO FIMSE FIM;
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
                | SAIDA varlist {destino = (char *)malloc(12+(strlen($2))*sizeof(char)); strcpy(destino,"\ndestino("); strcat(destino,$2); strcat(destino,");\n");}
                | cmds {;}
                | FIM {	fputs(destino,arquivo); fprintf (arquivo,"\nFim\n");fclose(arquivo); exit(1);}
                ;
varlist         : id varlist {char * destino = malloc(strlen($1) + strlen($2) + 1); strcpy(destino, $1); strcat(destino, ","); strcat(destino, $2); $$=destino;}
                | id {$$ = $1;}
                ;
cmds            : cmd cmds {char * destino = malloc(strlen($1) + strlen($2) + 1); strcpy(destino, $1); strcat(destino, ";\n"); strcat(destino, $2); $$=destino;}
                | cmd {$$=$1;}
                ;
cmd             : FACA id VEZES                 { fprintf (arquivo,"Repita o comando %s vezes {\n", $2);}
                                                FIMDELINHA cmds FIMFACA
                                                { fprintf(arquivo,"}\n");fprintf (arquivo,"\nfim do faca;\n"); $$ = $1; }
                | ENQUANTO id FACA              { fprintf (arquivo,"\nenquanto %s > 0 faca {\n", $2);}
                                                FIMDELINHA cmds FIMENQUANTO
                                                { fprintf(arquivo,"}\n");fprintf (arquivo,"\nfim do enquanto;\n"); $$ = $1; }
                | SE id ENTAO                   { labelCounter++; fprintf (arquivo,"\nif %s == 0 goto L%d\n", $2, labelCounter);}
                                                FIMDELINHA cmds FIMSE FIMDELINHA
                                                check
                | id IGUAL id FIMDELINHA        { fprintf (arquivo,"%s = %s\n",$1,$3);}
                | INC AP id FP FIMDELINHA       { fprintf (arquivo,"%s = %s + 1\n", $3, $3); $$=$3;}
                | ZERA AP id FP FIMDELINHA      { fprintf (arquivo,"%s = 0\n",$3);}
                ;
check           : SENAO { fprintf(arquivo,"}\n"); fprintf(arquivo,"\nfim do entao;\n"); fprintf(arquivo,"senao {\n"); } FIMDELINHA cmds FIMSENAO { fprintf(arquivo,"}\n"); fprintf (arquivo,"\nfim do senao;\n"); $$ = $1; }
                |       { fprintf(arquivo,"}\n"); fprintf(arquivo,"\nfim do se;\n"); } linha {$$ = $2;}
                ;
%%
int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}
