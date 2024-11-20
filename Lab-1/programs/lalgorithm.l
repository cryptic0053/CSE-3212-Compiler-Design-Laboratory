%{
#include <stdio.h>
#include <string.h>
#include <math.h>
%}

STR ["][a-zA-Z]+["]

%%

[0-9]+[+][0-9]+ {
    int a, b;
    sscanf(yytext, "%d+%d", &a, &b);
    printf("Addition: %d\n", a + b);
}

[0-9]+[-][0-9]+ {
    int a, b;
    sscanf(yytext, "%d-%d", &a, &b);
    printf("Subtraction: %d\n", a - b);
}

[0-9]+[/][0-9]+ {
    int a, b;
    sscanf(yytext, "%d/%d", &a, &b);
    if(b == 0) {
        printf("Division by zero is not possible\n");
        return 0;
    }
    printf("Division: %f\n", (float)a / b);
}

[0-9]+[*][0-9]+ {
    int a, b;
    sscanf(yytext, "%d*%d", &a, &b);
    printf("Multiplication: %d\n", a * b);
}

[0-9]+[*][*][0-9]+ {
    int a, b;
    sscanf(yytext, "%d**%d", &a, &b);
    printf("Power: %.0f\n", pow(a, b));
}

{STR}[+]{STR} {
    char str1[100], str2[100];
    sscanf(yytext, "\"%[a-zA-Z]\"+\"%[a-zA-Z]\"", str1, str2);
    printf("Concatenation: %s%s\n", str1, str2);
}

. { printf("Invalid input: %s\n", yytext); }
%%


int yywrap(void) {
    return 1;
}

int main()
{
    printf("Enter Expression  \n\n") ;
	yylex();
    return 0;
}