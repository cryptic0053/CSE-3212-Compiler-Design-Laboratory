%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
%}

%token NUMBER WORD COMMENT LETTER

%%
input:
    input line
    | /* empty */
    ;

line:
    WORD { printf("Found a word\n"); }
    | NUMBER { printf("Found a number\n"); }
    | COMMENT { printf("Found a comment\n"); }
    | LETTER {printf("Found a letter\n"); }
    ;

%%
void yyerror(const char *s) { fprintf(stderr, "%s\n", s); }
int main() { return yyparse(); }
