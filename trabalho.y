%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>

    int yylex();
    void yyerror(const char *s){
        fprintf(stderr, "%s\n", s);
    };

    int registers[26];


%}

%int numero;

%token<numero> VAR;
%token<numero> OUTRO;

%type <numero> program varlist cmds cmd;

%start program
%%

/* program −→ ENTRADA varlist SAIDA varlist cmds FIM */
program : ENTRADA varlist SAIDA varlist cmds FIM FIMDELINHA {printf("Codigo Objeto :\n %s\n", $2);exit(1);};

/* varlist −→ id varlist | id */
varlist : id {$$=$1;};
            |  id varlist {char *result=malloc(strlen($2) + strlen($1) + 1);strcpy(result, $2);
               strcat(result,";");strcat(result,$1);$$=result;};

/* cmds −→ cmd cmds | cmd */
cmds : cmd {$$=$1};
            |    cmd cmds FIMDELINHA {$$=$1;};

/* cmd −→ FACA id VEZES cmds FIM
cmd −→ ENQUANTO id FACA cmds FIM
cmd −→ SE id ENTAO cmds SENAO cmds FIMSE | SE id ENTAO cmds FIMSE
cmd −→ id = id | INC(id) | ZERA(id) */
cmd : id = id {updateRegisterVal($$, registerVal($1));};              /* send register value in $1 to register $$ */
            | INC(id)   {updateRegisterVal($1, registerVal($1) + 1);} /* send register value in $1 to register $1 added 1 */
            | ZERA(id)  {updateRegisterVal($1, 0);}                   /* send 0 to register $1  */

/*
program −→ ENTRADA varlist SAIDA varlist cmds FIM
varlist −→ id varlist | id
cmds −→ cmd cmds | cmd
cmd −→ FACA id VEZES cmds FIM
cmd −→ ENQUANTO id FACA cmds FIM
cmd −→ SE id ENTAO cmds SENAO cmds FIMSE | SE id ENTAO cmds FIMSE
cmd −→ id = id | INC(id) | ZERA(id) */

/* calculates the index given the id symbol */
int computeRegisterIndex(char token)
{
	return  token - 'a';
}

/* returns the value of a given symbol */
int registerVal(char symbol)
{
	int indexArray = computeRegisterIndex(symbol);
	return registers[indexArray];
}

/* updates the value of a given symbol */
void updateRegisterVal(char symbol, int val)
{
	int indexArray = computeRegisterIndex(symbol);
	registers[indexArray] = val;
}
