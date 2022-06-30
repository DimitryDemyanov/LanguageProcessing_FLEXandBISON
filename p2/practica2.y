/* Dimitry Demyanov Prishtchepa - Grupo 3.3 - P2 */

%{

#include <stdio.h>
#include <string.h>

extern int yylex();
extern int yylineno;

void yyerror (char const *);

%}


%token <string> 	INICIO
%token <string> 	FIN
%token <string> 	XML
%token <string> 	CONTENT
%token <string> 	LAST
%token <err> 		ERROR

%type <valInt> 		S1
%type <string>  	lista  

%union{
	char 	*string;
	int 	valInt;
	char 	*err;
}


%start S


%%


S:S1{if($1 != 0) {
		printf("La gramática es CORRECTA\n\n");
	};
};

S1:XML INICIO lista FIN {
	if(strcmp($2, $4) != 0) {
		printf("ERROR: El primer tag raiz no coincide con el ultimo cierre de tag\n\n");
		return 0;
	} else {
		$$=1;
	}
}

| ERROR {
	printf("ERROR - linea %d: %s\n\n", yylineno, $1);
	return 0;
}	

| XML ERROR {
	printf("ERROR - linea %d: %s\n\n", yylineno, $2);
	return 0;
}

| XML INICIO ERROR {
	printf("ERROR - linea %d: %s\n\n", yylineno, $3);
	return 0;
}	

| XML INICIO lista ERROR {
	printf("ERROR - linea %d: %s\n\n", yylineno, $4);
	return 0;
}

| XML INICIO INICIO lista FIN {
	printf("ERROR - linea %d: Un tag no puede repetirse\n\n", yylineno);
	return 0;
}

| XML INICIO lista FIN FIN {
	printf("ERROR - linea %d: Un tag no puede repetirse\n\n", yylineno);
	return 0;
}

| XML INICIO lista FIN LAST {
	printf("ERROR - linea %d: No puede haber texto tras el cierre del ultimo tag\n\n", yylineno);
	return 0;
};

lista:tag lista {} | tag{};

tag:INICIO FIN {
	if(!strcmp($1, $2) != 0) {
		printf("ERROR: Un tag tiene inicio y cierre diferente\n\n");
		return 0;
	};
}

| INICIO lista FIN {
	if(!strcmp($1, $3) != 0) {
		printf("ERROR: Un tag tiene inicio y cierre diferente\n\n");
		return 0;
	};
}

| INICIO CONTENT FIN {
	if(strcmp($1, $3) !=0 ) {
		printf("ERROR: Un tag tiene inicio y cierre diferente\n\n");
		return 0;
	};
}

| INICIO ERROR {
	printf("ERROR - linea %d: %s\n\n", yylineno, $2);
	return 0;
}

| INICIO lista ERROR {
	printf("ERROR - linea %d: %s\n\n", yylineno, $3);
	return 0;
}

| INICIO CONTENT ERROR {
	printf("ERROR - linea %d: %s\n\n", yylineno, $3);
	return 0;
};


%%


int main(int argc, char *argv[]) {

	extern FILE *yyin;

	switch (argc) {
		case 1:	yyin = stdin;
			yyparse();
			break;

		case 2: yyin = fopen(argv[1], "r");
			if (yyin == NULL) {
				printf("ERROR - No se ha podido abrir el fichero deseado.\n");
			} else {
				yyparse();
				fclose(yyin);
			}
			break;

		default: printf("ERROR - Demasiados argumentos.\nSintaxis correcta: %s [fichero_entrada]\n\n", argv[0]);
	}

	return 0;
}

void yyerror (char const *message) { 

	fprintf (stderr, "%s\n", message);

}
