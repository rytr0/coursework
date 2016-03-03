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
	calcerror();
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
	  calcerror();
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
  return (calcparse());
}

calcerror()
{
  printf("Error!\n");
}

calcwrap()
{
  return(1);
}
