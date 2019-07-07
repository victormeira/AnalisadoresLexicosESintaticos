%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
  
    int yylex();
    void yyerror(const char *s){
        fprintf(stderr, "%s\n", s);
    };
 
%}

%int numero;

%token<numero> NUM;
%token<numero> OUTRO;

%type <numero> program varlist cmds cmd;

%start program
%%

program : ENTRADA varlist SAIDA varlist cmds FIM FIMDELINHA {printf("Codigo Objeto :\n %s\n", $2);exit(1);};

varlist : id {$$=$1;};
            |  id varlist {char *result=malloc(strlen($2) + strlen($1) + 1);strcpy(result, $2);
               strcat(result,";");strcat(result,$1);$$=result;};

cmds : cmd {$$=$1};
            |    cmd cmds FIMDELINHA {$$=$1;};

cmd : 


program −→ ENTRADA varlist SAIDA varlist cmds FIM
varlist −→ id varlist | id
cmds −→ cmd cmds | cmd
cmd −→ FACA id VEZES cmds FIM
cmd −→ ENQUANTO id FACA cmds FIM
cmd −→ SE id ENTAO cmds SENAO cmds | SE id ENTAO cmds
cmd −→ id = id | INC(id) | ZERA(id)

/*
\n       return(FIMDELINHA);    
"="      return(IGUAL);
"+"      return(MAIS);
"*"      return(MULT);
"("      return(AP);
")"      return(FP);*/