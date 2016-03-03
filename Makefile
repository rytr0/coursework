calculator: lex.calc.c calc.tab.h calc.tab.c
	gcc calc.tab.c lex.calc.c -o calc

lex.calc.c: calc.lex
	lex -P calc calc.lex

calc.tab.c: calc.yacc
	yacc -p calc calc.yacc

calc.tab.h: calc.yacc
	yacc -d calc.yacc
