/* Dimitry Demyanov Prishtchepa - Grupo 3.3 - P1 */

%{
unsigned countChar = 0, countWord = 0, countFrase = 0; 
unsigned countMayus = 0, countMinus = 0, countNum = 0;
unsigned frase = 1; /* 1 = T 0 = F */
%}

minuscula	[a-z]+
mayuscula	[A-Z]+
numero		[0-9]+
palabra	[^ .\t\n]

fin	[ \t\r\n]
final_frase	"."

%%

{minuscula}		{	if(frase == 1) {
						frase = 0;
						countFrase++;		
					}
					countWord++;
					countMinus++;
					countChar += yyleng;	
				}

{mayuscula}		{	if(frase == 1) {
						frase = 0;
						countFrase++;	
					}
					countWord++;
					countMayus++;
					countChar += yyleng;
				}
				
{numero} 		{	if(frase == 1) {
						frase = 0;
						countFrase++;	
					}
					countWord++;
					countNum++;
					countChar += yyleng;

				}				
		
{palabra}+ 		{	if(frase == 1) {
						frase = 0;
						countFrase++;	
					}
					countWord++;
					countChar += yyleng;
				}

{fin}			{}
								
{final_frase}+ 	{	frase = 1;
					countChar += yyleng;
			   	}

%%

int main() {
	yylex();
	
	printf("\nResultado:\n");
	printf("Caracteres: %d, Palabras: %d, Frases: %d\n", countChar, countWord, countFrase);
	printf("Palabras en mayuscula: %d, Palabras en minuscula: %d, Palabras numericas: %d\n\n", countMayus, countMinus, countNum);
	
}
