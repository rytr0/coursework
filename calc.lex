%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
" "           ;
[0123456789]+ {
                yylval = atoi(yytext);
		return(NUMBER);
              }
[()]          {
                return(yytext[0]);
              }
[^0123456789]   return(yytext[0]);
%%
