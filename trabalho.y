%{
void yyerror (char *s);
int yylex();
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int registers[52];
int registerVal(char register);
void updateRegisterVal(char register, int val);

%}
%union {int num; char id;}         /* Yacc definitions */
%start line
%token print
%token exit_command
%token <id> identifier
%type <id> assignment

%start program
%%

/* program −→ ENTRADA varlist SAIDA varlist cmds FIM */
program : ENTRADA varlist SAIDA varlist cmds FIM FIMDELINHA {printf("Codigo Objeto :\n %s\n", $$);exit(EXIT_SUCCESS);}
            | assignment ';'            {;}
            | exit_command ';'		    {exit(EXIT_SUCCESS);}
		    | print cmds ';'			{printf("Imprimindo: %d\n", $2);}
		    | program assignment ';'	{;}
		    | program print cmds ';'	{printf("Imprimindo: %d\n", $3);}
		    | program exit_command ';'	{exit(EXIT_SUCCESS);}
;
/* varlist −→ id varlist | id */
varlist : id                {$$ = registerVal($1);};
            |  id varlist   {$$ = registerVal($1);};

/* cmds −→ cmd cmds | cmd */
cmds : cmd                      {$$=$1};
        | cmd cmds FIMDELINHA   {$$=$1;};

/* cmd −→ FACA id VEZES cmds FIM
aux1 = a
	L6:
		if aux1 == 0 goto L7
			a = a + 1
			b = b + 1
			c = 0
			aux1 = aux1 - 1
			goto L6
	L7:
*/
//cmd : FACA id VEZES cmds FIM 
/* cmd −→ ENQUANTO id FACA cmds FIM
cmd −→ SE id ENTAO cmds SENAO cmds FIMSE | SE id ENTAO cmds FIMSE
cmd −→ id = id | INC(id) | ZERA(id) */
cmd : identifier '=' identifier  { updateRegisterVal($1,registerVal($3); }  /* send register value in $1 to register $$ */
        | INC(id)   {updateRegisterVal($1, registerVal($1) + 1);}           /* send register value in $1 to register $1 added 1 */
        | ZERA(id)  {updateRegisterVal($1, 0);}                             /* send 0 to register $1  */

/*
program −→ ENTRADA varlist SAIDA varlist cmds FIM
varlist −→ id varlist | id
cmds −→ cmd cmds | cmd
cmd −→ FACA id VEZES cmds FIM
cmd −→ ENQUANTO id FACA cmds FIM
cmd −→ SE id ENTAO cmds SENAO cmds FIMSE | SE id ENTAO cmds FIMSE
cmd −→ id = id | INC(id) | ZERA(id) */



%%
/* calculates the index given the id symbol */
/*De 0 a 25, tokens de 'A' até 'Z' e de 26 a 51, tokens de 'a' até 'z' */
int computeRegisterIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
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

int main (void) {
	/* init registers table */
	int i;
	for(i=0; i<52; i++) {
		registers[i] = 0;
	}
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 