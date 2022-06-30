/* Dimitry Demyanov Prishtchepa - Grupo 3.3 - P_Final */

%{

#include <stdlib.h>
#include "poker_analyzer.tab.h"

%}

%option noyywrap noinput nounput yylineno

/* Nombre de jugador */
name            [a-zA-Z][a-zA-Z0-9]*

/* Etiquetas de un jugador */
player          "<"{name}">"
playerEnd       "<""/"{name}">"

/* Palo de la carta */
diamonds        ["D"]
clubs           ["C"]
spades          ["S"]
hearts          ["H"]


/* Numero de la carta */
number          [0-9]*
jack            ["J"]
queen           ["Q"]
king            ["K"]
ace             ["A"]


%%


{player}        {
                    yytext[strlen(yytext) - 1] = 0;
                    yytext++;
                    yylval.string = strdup(yytext);
                    return INIT;
                }

{playerEnd}     {
                    yytext[strlen(yytext) - 1] = 0;
                    yytext++;
                    yylval.string = strdup(yytext);
                    return END;
                }

{diamonds}      {
                    return DIAMONDS; 
                }

{clubs}         {
                    return CLUBS;
                }

{spades}        {
                    return SPADES;
                }

{hearts}        {
                    return HEARTS;
                }

{number}        {
                    yylval.string = strdup(yytext);
                    return NUMBER;
                }

{jack}          {
                    yylval.string = strdup("11");
                    return NUMBER;
                }

{queen}         {
                    yylval.string = strdup("12");
                    return NUMBER;
                }

{king}          {
                    yylval.string = strdup("13");
                    return NUMBER;
                }

{ace}           {
                    yylval.string = strdup("14");
                    return NUMBER;
                }


%%
