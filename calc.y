%{
#include <stdio.h>
%}

%start main

%token NUMBER

%file-prefix "calc"
%name-prefix "calc"

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

main(int argc, char *argv[])
{
  extern FILE *calcin;
  calcin = fopen("aux.txt", "w");
  if (argc > 1)
  {
    int i;
    for (i = 1; i < argc; i++)
      {
	fprintf(calcin, "%s", argv[i]);
      }
    fprintf(calcin, "\n");
    fclose(calcin);
    calcin = fopen("aux.txt", "r");
  }
  else
    calcin = stdin;

  calcparse();

  fclose(calcin);
}

calcerror()
{
  printf("Error!\n");
}

calcwrap()
{
  return(1);
}
