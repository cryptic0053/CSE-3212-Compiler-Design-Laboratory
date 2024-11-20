%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}

%%

max\(\"([^\"]+)\"<\"([^\"]+)\"\)\? {
    char *str1_start = yytext + 5;
    char *str2_start = strchr(str1_start, '<');
    
    if (!str2_start) return;
    
    *(strchr(str1_start, '"')) = '\0';
    str2_start += 2;
    *(strchr(str2_start, '"')) = '\0';
    
    
        if (strcmp(str1_start, str2_start) < 0) {
            printf("\"%s\" is smaller\n", str1_start);
        } else if (strcmp(str1_start, str2_start) > 0) {
            printf("\"%s\" is greater\n", str1_start);
        } else {
            printf("Both strings are equal\n");
        }
}

%%

int main() {
    printf("Enter the expression (max("abcd"<"defg")? :\n"));
    yylex();
    return 0;
}

int yywrap(void) {
    return 1;
}
