%{
void yyerror (char *s);
int yylex();
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
int registers[52];
int registerVal(char register);
void updateRegisterVal(char register, int val);
%}

%union {int num; char id;}

%token exit_command print ENTRADA FIM SAIDA FACA VEZES ENQUANTO SE ENTAO SENAO FIMSE AP FP EQUAL INC ZERA FIMDELINHA
%token <id> identifier 

%type <id> program varlist cmds cmd

%start program

%%

program : ENTRADA varlist SAIDA varlist cmds FIM FIMDELINHA {exit(EXIT_SUCCESS);}
            | ENTRADA varlist               {;}
            | ENTRADA exit_command		    {exit(EXIT_SUCCESS);}
		    | ENTRADA print cmds		    {printf("Imprimindo: %d\n", $3);}
		    | program ENTRADA varlist	    {;}
		    | program ENTRADA print cmds	{printf("Imprimindo: %d\n", $4);}
		    | program ENTRADA exit_command	{exit(EXIT_SUCCESS);}
            ;

varlist : identifier                {$$ = registerVal($1);}
            |  identifier varlist   {$$ = registerVal($1);}
            ;

cmds : cmd            {$$=$1;}
        | cmd cmds    {$$=$1;}
        ;

cmd : 	  identifier
		| identifier EQUAL identifier   { updateRegisterVal($1, registerVal($3)); }       	/* send register value in $3 to register $1 */
        | INC AP identifier FP     		{ updateRegisterVal($3, ((registerVal($3)) + 1)); }	/* send register value in $3 to register $1 added 1 */
        | ZERA AP identifier FP    		{ updateRegisterVal($3, 0); }                  		/* send 0 to register $3  */

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