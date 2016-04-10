%{
#include <complex.h>
#include <stdio.h>
#include "typedef.h"

type_value high_type(type_value t1, type_value t2)
{
  if (t1 == COMPLEX || t2 == COMPLEX)
    return COMPLEX;
  else
    if (t1 == DOUBLE || t2 == DOUBLE)
      return DOUBLE;
    else
      return INTEGER;
}

void cast_to_target_type(type_value target, struct_value *val)
{
  switch(target)
  {
  case COMPLEX:
    switch(val->type)
    {
    case COMPLEX:
      break;
    case DOUBLE:
      val->cval = val->dval + I;
      break;
    case INTEGER:
      val->cval = val->ival + I;
      break;
    }
    break;
  case DOUBLE:
    switch(val->type)
    {
    case DOUBLE:
      break;
    case INTEGER:
      val->dval = val->ival;
      break;
    }
    break;
  case INTEGER:
    break;
  }
}
%}

%file-prefix "calc"
%name-prefix "calc"

%defines

%union
{
  struct_value value;
};

%left '+' '-'
%left '*' '/'

%start main

%token <value> NUMBER

%type <value> expr

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
	switch($1.type)
	{
	case COMPLEX:
	  printf("%f + %fi\n", creal($1.cval), cimag($1.cval));
	  break;
	case DOUBLE:
	  printf("%f\n", $1.dval);
	  break;
	case INTEGER:
	  printf("%d\n", $1.ival);
	  break;
	}
      }
      ;

expr: '(' expr ')'
      {
	switch($2.type)
	{
	case COMPLEX:
	  $$.type = COMPLEX;
	  $$.cval = $2.cval;
	case INTEGER:
	  $$.type = INTEGER;
	  $$.ival = $2.ival;
	  break;
	case DOUBLE:
	  $$.type = DOUBLE;
	  $$.dval = $2.dval;
	  break;
	}
      }
      |
      expr '+' expr
      {
	$$.type = high_type($1.type, $3.type);
	cast_to_target_type($$.type, &$1);
	cast_to_target_type($$.type, &$3);
	
	switch($$.type)
	{
	case COMPLEX:
	  $$.cval = $1.cval + $3.cval;
	  break;
	case DOUBLE:
	  $$.dval = $1.dval + $3.dval;
	  break;
	case INTEGER:
	  $$.ival = $1.ival + $3.ival;
	  break;
	}
      }
      |
      expr '-' expr
      {
	$$.type = high_type($1.type, $3.type);
	cast_to_target_type($$.type, &$1);
	cast_to_target_type($$.type, &$3);

	switch($$.type)
	{
	case COMPLEX:
	  $$.cval = $1.cval - $3.cval;
	  break;
	case DOUBLE:
	  $$.dval = $1.dval - $3.dval;
	  break;
	case INTEGER:
	  $$.ival = $1.ival - $3.ival;
	  break;
	}
      }
      |
      expr '*' expr
      {
	$$.type = high_type($1.type, $3.type);
	cast_to_target_type($$.type, &$1);
	cast_to_target_type($$.type, &$3);

	switch($$.type)
	{
	case COMPLEX:
	  $$.cval = $1.cval * $3.cval;
	  break;
	case DOUBLE:
	  $$.dval = $1.dval * $3.dval;
	  break;
	case INTEGER:
	  $$.ival = $1.ival * $3.ival;
	  break;
	}
      }
      |
      expr '/' expr
      {
	$$.type = high_type($1.type, $3.type);
	cast_to_target_type($$.type, &$1);
	cast_to_target_type($$.type, &$3);
	switch($$.type)
	{
	case COMPLEX:
	  $$.cval = $1.cval / $3.cval;
	  break;
	case DOUBLE:
	  $$.dval = $1.dval / $3.dval;
	  break;
	case INTEGER:
	  $$.ival = $1.ival / $3.ival;
	  break;
	}
      }
      |
      NUMBER
      {
	switch($1.type)
	{
	case COMPLEX:
	  $$.type = COMPLEX;
	  $$.cval = $1.cval;
	case DOUBLE:
	  $$.type = DOUBLE;
	  $$.dval = $1.dval;
	  break;
	case INTEGER:
	  $$.type = INTEGER;
	  $$.ival = $1.ival;
	  break;
	}
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
