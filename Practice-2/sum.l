%{
#include "sum.tab.h" // Include the token definitions from Bison
%}
%%
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
\+          { return '+'; }
[ \t\n]+    { /* Skip whitespace */ }
.           { return yytext[0]; } // Catch-all for unknown characters
%%
