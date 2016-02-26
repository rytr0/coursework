
%{
#include <stdio.h>
%}

%start main

%token NUMBER

%left '+' '-'
%left '*' '/'

%%

main: 
      |
      main calc '\n'
      |
      main error '\n'
      {
	yyerror();
      }
      ;

calc: expr
      {
	printf("%d\n", $1);
      }
      ;

expr: '(' expr ')'
      {
        $$ = $2;
      }
      |
      expr '*' expr
      {
        $$ = $1 * $3;
      }
      |
      expr '/' expr
      {
	if ($3 != 0)
	{
	  $$ = $1 / $3;
	}
	else
	{
	  yyerror();
	}
      }
      |
      expr '+' expr
      {
	$$ = $1 + $3;
      }
      |
      expr '-' expr
      {
	$$ = $1 - $3;
      }
      |
      NUMBER
      {
	$$ = $1;
      }
      ;
%%

main()
{
  return (yyparse());
}

yyerror()
{
  printf("Error!\n");
}

yywrap()
{
  return(1);
}
