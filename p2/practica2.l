/* Dimitry Demyanov Prishtchepa - Grupo 3.3 - P2 */

%{

#include <stdlib.h>
#include "practica2.tab.h"

%}

/* Opcion para mantener el numero de linea de lectura del input (para evitar un EOF) */
%option yylineno


/* TAGS */
/* Contenido de un tag */
contenidoTAG 		[^\n\t "<"">"][^"<"">"]*

/* Palabra valida como nombre de tag */
nombreTAG 			[A-Za-z\_][A-Za-z0-9\-\_\.]*
inicioTAG 			"<"{nombreTAG}">"
finTAG 				"<""/"{nombreTAG}">"


/* ELEMENTOS EXTERNOS */
/* Comentarios de XML*/
comentarioXML 		"<""!""-""-"[^\t\n]+"-""-"">"

/* Cabecera de XML */
cabeceraXML 		"<""?"["x""m""l"][A-Za-z0-9\-\_\.\"\= ]*"?"">"

/* Inicio de tag y ultimo tag */
beforeTAG 			[\n\t "<"">"]
lastTAG 			[^ \n\t]


/* ERRORES */
/* Palabra con espacio como nombre de tag */
nombreEspacio 		[A-Za-z\_ ][ A-Za-z0-9\-\_\.]*
inicioTagEspacio 	"<"{nombreEspacio}">"
finTagEspacio 		"<""/"{nombreEspacio}">"

/* Palabra que empieza por un numero como nombre de tag */
nombreNumero 		[0-9][A-Za-z0-9\-\_\.]*
inicioTagNumero 	"<"{nombreNumero}">"
finTagNumero 		"<""/"{nombreNumero}">"

/* Palabra que empieza por xml o XML como nombre de tag*/
nombreConXML  		["x""m""l"][A-Za-z0-9\-\_\.]*
inicioTagXML 		"<"{nombreConXML}">"
finTagXML 			"<""/"{nombreConXML}">"

/* Palabra con signo no permitido como nombre de tag */
nombreSigno 		[^\_A-Za-z0-9][A-Za-z0-9\-\_\.]*
inicioTagSigno 		"<"{nombreSigno}">"
finTagSigno 		"<""/"{nombreSigno}">"


/* Se utilizan dos procesos para poder asi analizar los tags de forma recursiva */
%start SUBPROCESS


%%


<INITIAL>[\n\t ]+ 			{}

<INITIAL>{comentarioXML}	{}

<INITIAL>{lastTAG} 			{return LAST;}

<INITIAL>{cabeceraXML} 		{return XML;} 

<INITIAL>{inicioTAG} 		{
								yytext[strlen(yytext) - 1] = 0;
								yytext++;
								yylval.string = strdup(yytext);
								BEGIN(SUBPROCESS);
								return INICIO;
							}

<INITIAL>{inicioTagXML} 	{
								yylval.err = strdup("Un tag no puede comenzar por \"xml\"");
								return ERROR;
							}

<INITIAL>{finTagXML} 		{
								yylval.err = strdup("Un tag no pueden comenzar por \"xml\"");
								return ERROR;
							}

<INITIAL>{finTAG} 			{
								yytext[strlen(yytext) - 1] = 0;
								yytext++; yytext++;
								yylval.string = strdup(yytext);
								return FIN;
							}

<INITIAL>{inicioTagEspacio} {
								yylval.err = strdup("Un tag no puede incluir espacios en blanco");
								return ERROR;
							}

<INITIAL>{finTagEspacio} 	{
								yylval.err = strdup("Un tag no puede incluir espacios en blanco");
								return ERROR;
							}

							
<INITIAL>{inicioTagNumero} 	{
								yylval.err = strdup("Un tag no puede comenzar con un numero");
								return ERROR;
							}

<INITIAL>{finTagNumero} 	{
								yylval.err = strdup("Un tag no puede comenzar con un numero");
								return ERROR;
							}


<INITIAL>{inicioTagSigno} 	{
								yylval.err = strdup("Un tag no puede comenzar por signos de puntuacion, a excepcion de \"_\"");
								return ERROR;
							}

<INITIAL>{finTagSigno} 		{
								yylval.err = strdup("Un tag no puede comenzar por signos de puntuacion, a excepcion de \"_\"");
								return ERROR;
							}



<SUBPROCESS>{contenidoTAG} 	{
								yylval.string = strdup(yytext);
								BEGIN(INITIAL);
								return CONTENT;
							}

<SUBPROCESS>{finTagXML} 	{
								yylval.err = strdup("Un tag no puede comenzar por \"xml\"");
								return ERROR;
							}


<SUBPROCESS>{finTagNumero} 	{
								yylval.err = strdup("Un tag no puede comenzar con un numero");
								return ERROR;
							}

<SUBPROCESS>{finTagSigno} 	{
								yylval.err = strdup("Un tag no puede comenzar por signos de puntuacion, a excepcion de \"_\"");
								return ERROR;
							}

<SUBPROCESS>{finTAG} 		{
								yytext[strlen(yytext) - 1] = 0;
								yytext++; yytext++;
								yylval.string = strdup(yytext);
								BEGIN(INITIAL);
								return FIN;
							}

<SUBPROCESS>{beforeTAG} 	{
								BEGIN(INITIAL);
							}
