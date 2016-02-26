calculator: lex.yy.c y.tab.h y.tab.c
	gcc y.tab.c lex.yy.c -o calculator

lex.yy.c: calc.lex
	lex calc.lex

y.tab.c: calc.yacc
	yacc calc.yacc

y.tab.h: calc.yacc
	yacc -d calc.yacc
