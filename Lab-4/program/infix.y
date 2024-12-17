/* C Declarations */

%{
    #define YYSTYPE double /* yyparse() stack type */
    #include <stdlib.h>
    #include <stdio.h>
    #include <math.h>

    void yyerror(const char *s); /* Error handler function declaration */
    int yylex(void);             /* Lexical analyzer function declaration */
%}

/* BISON Declarations */

%token NEWLINE NUMBER

/* Grammar follows */

%%
input: 
    /* empty */
    | input line
    ;

line: 
    NEWLINE
    | exp NEWLINE { printf("\t%f\n", $1); }
    ;

exp: 
    NUMBER { $$ = $1; }
    | exp '+' exp { $$ = $1 + $3; }
    | exp '-' exp { $$ = $1 - $3; }
    | fact      
    ;

fact: 
    NUMBER { $$ = $1; printf("This is number fact: %f\n", $1); }
    ;

%%


void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}


int main(void) {
    printf("Enter expressions followed by newline:\n");
    yyparse();
    return 0;
}
