/* Dimitry Demyanov Prishtchepa - Grupo 3.3 - P_Final */

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define YYERROR_VERBOSE 1
#define YYDEBUG 1

extern int yylex();
extern int yylineno;

void yyerror (char const *);

bool royal_flush(int color, int number);        /* Escalera Real */
bool straight_flush(int color, int straight);   /* Escalera Palo */
bool four_of_a_kind(int pair1, int pair2);      /* Poker */
bool full_house(int pair1, int pair2);          /* Full */
bool flush (int color);                         /* Palo */
bool straight_hand(int straight);               /* Escalera */
bool three_of_a_kind(int pair1, int pair2);     /* Trio */
bool two_pair(int pair1, int pair2);            /* Pareja Doble */
bool one_pair(int pair1, int pair2);            /* Pareja */

int player = 0;                                 /* Numero Jugador a analizar*/
int max_player = 0;                             /* Jugador con la mayor Mano */

char* cards[20];                                /* Array de Cartas Totales */

int s = 0, c = 0, d = 0, h = 0;                 /* Numero de Cartas de cada Palo en Mano */

int pair1 = 0, pair2 = 0;						/* Numero de cartas que hacen pareja */
int straight = 0;								/* Numero de cartas que hacen escalera */

int n = 0;                                      /* Numero de Cartas en Mano */

int number = 0;                                 /* Suma de los valores de Carta de una mano */

int aux_1 = 0, aux_2 = 0;                       /* Variables auxiliares para calculos */
int max = 0;
int prev_number = 0;

int max_hand = 0, current_hand = 0;             /* Mano mas alta / Mano a analizar */
char* victory_hand = "";						/* Mano ganadora */

int i = 0;

%}

%union {
    int     valInt;
    char    *string;
}

%token <string> INIT
%token <string> END
%token <string> NUMBER

%token DIAMONDS
%token CLUBS
%token SPADES
%token HEARTS

%type <string> hand
%type <string> card
%type <string> suit

%start S


%%


S:INIT hand END {

    player++;

    /* Se puntua la mano del jugador actual comparando con las reglas (de mayor a menor importancia) */

    if (royal_flush(s, number) | royal_flush(c, number) | royal_flush(d, number) | royal_flush(h, number)) {
        printf("ROYAL FLUSH Detected\n");
		current_hand = 10;

    } else if (straight_flush(s, straight) | straight_flush(c, straight) | straight_flush(d, straight) | straight_flush(h, straight)) {
        printf("STRAIGHT FLUSH Detected\n");
		current_hand = 9;

    } else if (four_of_a_kind(pair1, pair2)) {
        printf("FOUR OF A KIND Detected\n");
		current_hand = 8;

    } else if (full_house(pair1, pair2)) {
        printf("FULL HOUSE Detected\n");
		current_hand = 7;

    } else if (flush(s) | flush(c) | flush(d) | flush(h)) {
        printf("FLUSH Detected\n");
		current_hand = 6;

    } else if (straight_hand(straight)) {
        printf("STRAIGHT Detected\n");
		current_hand = 5;

    } else if (three_of_a_kind(pair1, pair2)) {
        printf("THREE OF A KIND Detected\n");
		current_hand = 4;

    } else if (two_pair(pair1, pair2)) {
        printf("TWO PAIR Detected\n");
		current_hand = 3;

    } else if (one_pair(pair1, pair2)) {
        printf("ONE PAIR Detected\n");
		current_hand = 2;

    } else {    /* Carta mas alta */
		printf("BEST CARD: %d\n", max);
        current_hand = 1;

    }

    if (current_hand > max_hand) {
        max_player = player;
		max_hand = current_hand;

		switch (max_hand) {
			case 10:
				victory_hand = "ROYAL FLUSH";
				break;
			case 9:
				victory_hand = "STRAIGHT FLUSH";
				break;
			case 8:
				victory_hand = "FOUR OF A KIND";
				break;
			case 7:
				victory_hand = "FULL HOUSE";
				break;
			case 6:
				victory_hand = "FLUSH";
				break;
			case 5:
				victory_hand = "STRAIGHT";
				break;
			case 4:
				victory_hand = "THREE OF A KIND";
				break;
			case 3:
				victory_hand = "TWO PAIR";
				break;
			case 2:
				victory_hand = "ONE PAIR";
				break;
			case 1:
				victory_hand = "BEST CARD";
				break;
		}
    }

    /* Al acabar con toda la mano, se resetean los valores para analizar la siguiente */
    number = 0;
    s = 0, c = 0, d = 0, h = 0;  

    return 0;

};

hand:hand card{}
| card{};

card:NUMBER suit {
	
    /* Cuando llega a 5, se asume que se leyeron todas las cartas de la mano y se resetean los valores*/
    if (n == 5) {           
        n = 0;
		straight = 0;
        pair1 = 0;
        pair2 = 0;
		prev_number = 0;
		aux_1 = 0;
		aux_2 = 0;
		max = 0;
	}

    number += atoi($1);

	/* Imprimimos las cartas de cada mano por pantalla */
	printf("%s%s\n",$1,$2);


	cards[i] = strcat($1,$2);
	i++;

	if (aux_1 == 0) {
		aux_1 = atoi($1);
	}

    /* Detector de Parejas */
	if (atoi($1) == aux_1) {
		pair1++;
	} else if (aux_2 == atoi($1)) {
		pair2++;
	} else if (aux_2 == 0) {
		aux_2 = atoi($1);
        pair2++;
	}

    /* Detector de Escaleras */
	if (prev_number == 0) {
		prev_number = atoi($1);
	} 
	if (atoi($1) == prev_number - 1 | atoi($1) == prev_number + 1 ) {
		straight++;     
	}
	prev_number = atoi($1);

    /* Detector de la Carta (numero) mas alto */
	if (max == 0){
		max = atoi($1);
	} else if (atoi($1) > max) {
		max = atoi($1);
	}
    
	/* Avanzamos a la siguiente carta */
    n++;                

};

suit:SPADES {
    s++;
	$$ = " of Spades";
}

| CLUBS {
    c++;
	$$ = " of Clubs";
}

| DIAMONDS {
    d++;
	$$ = " of Diamonds";
}

| HEARTS {
    h++;
	$$ = " of Hearts";
};


%%


/* ERROR */
void yyerror (char const *message) { 
    fprintf (stderr, "%s\n", message);
}


/* REGLAS DE MANO */
bool royal_flush(int color, int number) {
	if (color == 5 && number == 60) {
		return true;
	} else {
		return false;
	}
}

bool straight_flush(int color, int straight) {
	if (color == 5 && straight == 4){
		return true;
	} else {
		return false;
	}
}

bool four_of_a_kind(int pair1, int pair2){
	if (pair1 == 4 || pair2 == 4){
		return true;
	} else {
		return false;
	}
}

bool full_house(int pair1, int pair2) {
	if (pair1 == 3 && pair2 == 2){
		return true;
	} else if (pair1 == 2 && pair2 == 3) {
		return true;
	} else {
		return false;
	}
}

bool flush (int color) {
	if (color == 5) {
		return true;
	} else {
		return false;
	}
}

bool straight_hand(int straight) {
	if (straight == 4) {
		return true;
	} else {
		return false;
	}
}

bool three_of_a_kind(int pair1, int pair2) {
	if (pair1 == 3 || pair2 == 3) {
		return true;
	} else {
		return false;
	}
}

bool two_pair(int pair1, int pair2) {
	if (pair1 == 2 && pair2 == 2) {
		return true;
	} else {
		return false;
	}
}

bool one_pair(int pair1, int pair2) {
	if (pair1 == 2 || pair2 == 2) {
		return true;
	} else {
		return false;
	}
}


/* MAIN */
int main(int argc, char *argv[]) {

    /* YYPARSE TANTAS VECES COMO JUGADORES HAYAN */ 
    for (int i = 0; i < 4; i++) {
		printf("\nPlayer %d:", i + 1);
        yyparse();

		if (n != 5) {
			printf("\nERROR - La mano del jugador %d tiene mas de 5 cartas \n\n", i + 1);
			exit(0);
		}
    }

	

    printf("\nBEST HAND: %s\n", victory_hand);
	printf("ROUND WINNER: Player %d \n\n", max_player);

    return 0;
}
