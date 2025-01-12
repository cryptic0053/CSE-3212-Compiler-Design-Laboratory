%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;  // Declare yyin for Flex input stream
extern int yylex(); // Declare yylex function


void yyerror(const char *s); // Error handler declaration
%}

%union {
    int num; // Add `num` for integer tokens
}

%token <num> NUMBER
%type <num> expr

%%

input:
    expr '\n' { printf("Sum: %d\n", $1); }
    ;

expr:
    NUMBER '+' NUMBER { $$ = $1 + $3; } // Handle addition
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    FILE *file = fopen("input.cpp", "r");
    if (!file) {
        fprintf(stderr, "Error: Could not open input file\n");
        return 1;
    }
    yyin = file; // Set yyin to read from input.cpp
    yyparse();   // Start parsing
    fclose(file); // Close the file after parsing
    return 0;
}

