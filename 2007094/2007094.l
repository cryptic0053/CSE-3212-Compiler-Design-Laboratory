%{
#include <stdio.h>

int keyword_count = 0;
int operator_count = 0;
int identifier_count = 0;
int number_count = 0;
int whitespace_count = 0;
int symbol_count = 0;
%}

IDENTIFIER    [a-zA-Z_][a-zA-Z0-9_]*
STRING        \"[^\"]*\"
INTEGER       [0-9]+
FLOAT         [0-9]+\.[0-9]+
OPERATOR      [+\-*/=<>!&|]
DELIMITER     [,;\(\)\[\]\{\}]
WHITESPACE    [ \t\n]+
SLC           "//".*
MLC           "/\*".*?"\*/"

%%

"goal"             { keyword_count++; printf("PRINT (goal) -> %s\n", yytext); }
"shot"             { keyword_count++; printf("SCANF (shot) -> %s\n", yytext); }
"kickoff"          { keyword_count++; printf("MAIN_FUNCTION (kickoff) -> %s\n", yytext); }
"dribble"          { keyword_count++; printf("FOR_LOOP (dribble) -> %s\n", yytext); }
"run"              { keyword_count++; printf("WHILE_LOOP (run) -> %s\n", yytext); }
"var"              { keyword_count++; printf("IF_CONDITION (var) -> %s\n", yytext); }
"penalty"          { keyword_count++; printf("ELSE_IF_CONDITION (penalty) -> %s\n", yytext); }
"no_penalty"       { keyword_count++; printf("ELSE_CONDITION (no_penalty) -> %s\n", yytext); }
"red_card"         { keyword_count++; printf("BREAK (red_card) -> %s\n", yytext); }
"yellow_card"      { keyword_count++; printf("CONTINUE (yellow_card) -> %s\n", yytext); }
"final_whistle"    { keyword_count++; printf("RETURN (final_whistle) -> %s\n", yytext); }
"team"             { keyword_count++; printf("CLASS (team) -> %s\n", yytext); }
"stadium"          { keyword_count++; printf("INCLUDE (stadium) -> %s\n", yytext); }
"coach"            { keyword_count++; printf("FUNCTION (coach) -> %s\n", yytext); }
"injury_time"      { keyword_count++; printf("TRY (injury_time) -> %s\n", yytext); }
"replay"           { keyword_count++; printf("CATCH (replay) -> %s\n", yytext); }
"trophy"           { keyword_count++; printf("SUCCESS (trophy) -> %s\n", yytext); }
"scoreboard"       { keyword_count++; printf("ARRAY (scoreboard) -> %s\n", yytext); }

{IDENTIFIER}       { identifier_count++; printf("IDENTIFIER -> %s\n", yytext); }
{INTEGER}          { number_count++; printf("INTEGER -> %s\n", yytext); }
{FLOAT}            { number_count++; printf("FLOAT -> %s\n", yytext); }
{STRING}           { printf("STRING -> %s\n", yytext); }
{OPERATOR}         { operator_count++; printf("OPERATOR -> %s\n", yytext); }
{DELIMITER}        { symbol_count++; printf("DELIMITER -> %s\n", yytext); }
{SLC}              { printf("SINGLE_LINE_COMMENT -> %s\n", yytext); }
{MLC}              { printf("MULTI_LINE_COMMENT -> %s\n", yytext); }
{WHITESPACE}       { whitespace_count++; /* Ignore whitespace */ }
.                  { printf("UNKNOWN TOKEN -> %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    FILE *inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        perror("Error opening file");
        return 1;
    }

    yyin = inputFile; // Assign input file to Lex
    yylex();          // Start lexical analysis

    // Print the counts at the end of the analysis
    printf("\nKeyword count: %d\n", keyword_count);
    printf("Operator count: %d\n", operator_count);
    printf("Identifier count: %d\n", identifier_count);
    printf("Number count: %d\n", number_count);
    printf("Whitespace count: %d\n", whitespace_count);
    printf("Symbol count: %d\n", symbol_count);

    fclose(inputFile);
    return 0;
}
