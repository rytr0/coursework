%{
#include <complex.h>
#include "typedef.h"
#include "calc.tab.h"
%}

%option prefix="calc"

%%
" "            ;

[i]            {
                 calclval.value.type = COMPLEX;
                 calclval.value.cval = I;
                 return NUMBER;
               }

[0-9]+\.[0-9]+ {
                 calclval.value.type = DOUBLE;
                 calclval.value.dval = atof(calctext);
                 return NUMBER;
               }

[0-9]+         {
                 calclval.value.type = INTEGER;
                 calclval.value.ival = atoi(calctext);
		 return NUMBER;
               }

[^0-9]  return(calctext[0]);
%%
