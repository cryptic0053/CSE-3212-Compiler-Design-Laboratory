%{
#include <stdio.h>
#include <string.h>
#include "2007094.tab.h"
int line_number = 1;
%}

IDENTIFIER    [a-zA-Z_][a-zA-Z0-9_]*
STRING        \"[^\"]*\"
INTEGER       [0-9]+
FLOAT         [0-9]+\.[0-9]+
OPERATOR      [+\-*/=<>!&|]
DELIMITER     [,;\(\)\[\]\{\}:]
WHITESPACE    [ \t]+
NEWLINE       \n
SLC           "//".*
MLC           "/\*".*?"\*/"

%%

"goal"             { return PRINT; }
"shot"             { return SCANF; }
"kickoff"          { return MAIN; }
"dribble"          { return FOR; }
"run"              { return WHILE; }
"var"              { return IF; }
"penalty"          { return ELIF; }
"no_penalty"       { return ELSE; }
"red_card"         { return BREAK; }
"yellow_card"      { return CONTINUE; }
"final_whistle"    { return RETURN; }
"team"             { return CLASS; }
"stadium"          { return INCLUDE; }
"coach"            { return FUNCTION; }
"injury_time"      { return TRY; }
"replay"           { return CATCH; }
"trophy"           { return SUCCESS; }
"scoreboard"       { return ARRAY; }
"striker"          { return INT; }      
"keeper"           { return FLOAT; }    
"defender"         { return CHAR; }     
"midfielder"       { return STRING; }   
"squad"            { return STRUCT; }   
"league"           { return ENUM; }     
"pass"             { return ASSIGN; }   
"tackle"           { return AND; }      
"assist"           { return OR; }       
"offside"          { return NOT; }      
"formation"        { return VOID; }     
"substitute"       { return SWITCH; }   
"bench"            { return CASE; }     
"training"         { return DO; }       

"=="              { return EQ; }
"!="              { return NE; }
"<="              { return LE; }
">="              { return GE; }
"&&"              { return AND; }
"||"              { return OR; }
"!"               { return NOT; }

{IDENTIFIER}       { yylval.string = strdup(yytext); return IDENTIFIER; }
{INTEGER}          { yylval.number = atoi(yytext); return INTEGER; }
{FLOAT}            { yylval.floating = atof(yytext); return FLOAT_VAL; }
{STRING}           { yylval.string = strdup(yytext); return STRING_LITERAL; }
{OPERATOR}         { return yytext[0]; }
{DELIMITER}        { return yytext[0]; }
{WHITESPACE}       { /* ignore whitespace */ }
{NEWLINE}          { line_number++; }
{SLC}              { /* Ignore single line comments */ }
{MLC}              { /* Ignore multi line comments */ }
.                  { printf("Error: Unknown token '%s' at line %d\n", yytext, line_number); }

%%

int yywrap() {
    return 1;
}