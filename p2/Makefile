FUENTE = practica2
PRUEBA1 = practica2_ejemplo1.xml
PRUEBA2 = practica2_ejemplo2.xml
PRUEBA3 = practica2_ejemplo3.xml
PRUEBA4 = practica2_ejemplo4.xml
PRUEBA5 = practica2_ejemplo5.xml
PRUEBA6 = practica2_ejemplo6.xml
PRUEBA7 = practica2_ejemplo7.xml


all: compile clear run1 run2 run3 run4 run5 run6 run7

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -yd -v
	gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -lfl -ly

run1:
	./$(FUENTE) < $(PRUEBA1)

run2:
	./$(FUENTE) < $(PRUEBA2)

run3:
	./$(FUENTE) < $(PRUEBA3)

run4:
	./$(FUENTE) < $(PRUEBA4)

run5:
	./$(FUENTE) < $(PRUEBA5)

run6:
	./$(FUENTE) < $(PRUEBA6)

run7:
	./$(FUENTE) < $(PRUEBA7)

clear:
	clear

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h

