%{ 
// C header code if needed 
%}

%%

[0-9]+        { printf("NUMBER: %s\n", yytext); }
[a-zA-Z]{2,}  { printf("WORD: %s\n", yytext); }
[a-zA-z]      { printf("LETTER: %s\n", yytext); }   
\/\/.*        { printf("Single line comment: %s\n", yytext); }
\n            { /* Handle newline */ }
.             { /* Catch-all */ }

%%
int yywrap() { return 1; } // To handle EOF
