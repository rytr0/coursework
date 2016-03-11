calc: lex.calc.c calc.tab.h calc.tab.c
	$(CC) calc.tab.c lex.calc.c -o calc

lex.calc.c: calc.l
	$(LEX) calc.l

calc.tab.c: calc.y
	$(YACC) calc.y

calc.tab.h: calc.y
	$(YACC) calc.y
