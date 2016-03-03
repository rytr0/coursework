%{
#include <stdio.h>
#include "calc.tab.h"
%}

%%
" "            ;

[0-9]+         {
                 calclval = atoi(calctext);
		 return(NUMBER);
               }

[()]           return(calctext[0]);

[^0123456789]  return(calctext[0]);
%%
