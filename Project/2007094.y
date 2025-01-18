%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char* s);
extern int yylex();
extern FILE* yyin;
extern int line_number;

// Symbol table structure
struct Symbol {
    char* name;
    char* type;
    union {
        int ival;
        float fval;
        char* sval;
    } value;
};

struct Symbol symbols[100];
int symbol_count = 0;

void add_symbol(char* name, char* type);
struct Symbol* get_symbol(char* name);
void update_symbol_int(char* name, int value);
void update_symbol_float(char* name, float value);
void update_symbol_string(char* name, char* value);
%}

%union {
    int number;
    float floating;
    char* string;
    int type;
}

/* Tokens from your lexer */
%token <string> IDENTIFIER STRING_LITERAL
%token <number> INTEGER
%token <floating> FLOAT_VAL

/* Football themed tokens */
%token PRINT SCANF MAIN FOR WHILE IF ELIF ELSE
%token BREAK CONTINUE RETURN CLASS INCLUDE
%token FUNCTION TRY CATCH SUCCESS ARRAY
%token INT FLOAT CHAR STRING STRUCT ENUM
%token ASSIGN AND OR NOT VOID SWITCH CASE DO
%token LE GE EQ NE    /* <= >= == != */

/* Define types for non-terminals */
%type <type> type
%type <string> expression
%type <number> condition
%type <number> comparison_op
%type <string> statement
%type <string> statement_list
%type <string> declaration
%type <string> assignment
%type <string> print_statement
%type <string> if_statement
%type <string> while_statement
%type <string> for_statement
%type <string> for_init
%type <string> return_statement
%type <string> scanf_statement

/* Operator precedence and associativity */
%left OR
%left AND
%nonassoc '<' '>' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%right '='
%right NOT
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%nonassoc ELIF

%%

program
    : MAIN '{' { printf("Program started\n"); } statement_list '}' { printf("Program ended\n"); }
    ;

statement_list
    : statement { 
        $$ = $1; 
    }
    | statement_list statement { 
        if ($2 && strlen($2) > 0) {
            $$ = strdup($2);  // Make a copy of the current statement
            free($1);         // Free the previous statement
        } else {
            $$ = $1;         // Keep the previous statement
        }
    }
    ;

statement
    : declaration ';' { $$ = $1; }
    | assignment ';' { $$ = $1; }
    | print_statement ';' { $$ = $1; }
    | scanf_statement ';' { $$ = $1; }
    | if_statement { $$ = $1; }
    | while_statement { $$ = $1; }
    | for_statement { $$ = $1; }
    | return_statement ';' { 
        $$ = $1;
        printf("Return statement executed\n"); 
    }
    | BREAK ';' { 
        $$ = strdup("break");
        printf("Break statement encountered\n"); 
    }
    | CONTINUE ';' { 
        $$ = strdup("continue");
        printf("Continue statement encountered\n"); 
    }
    ;

declaration
    : type IDENTIFIER {
        char* type_str;
        switch ($1) {
            case INT: type_str = "int"; break;
            case FLOAT: type_str = "float"; break;
            case CHAR: type_str = "char"; break;
            case STRING: type_str = "string"; break;
            default: type_str = "unknown";
        }
        add_symbol($2, type_str);
        printf("Declared %s variable: %s\n", type_str, $2);
        $$ = $2;
    }
    ;

type
    : INT { $$ = INT; }
    | FLOAT { $$ = FLOAT; }
    | CHAR { $$ = CHAR; }
    | STRING { $$ = STRING; }
    | VOID { $$ = VOID; }
    ;

assignment
    : IDENTIFIER '=' expression {
        struct Symbol* sym = get_symbol($1);
        if (sym) {
            if (strcmp(sym->type, "int") == 0) {
                int val = atoi($3);
                update_symbol_int($1, val);
                printf("Assigned value %d to %s\n", val, $1);
            }
            else if (strcmp(sym->type, "float") == 0) {
                float val = atof($3);
                update_symbol_float($1, val);
                printf("Assigned value %.2f to %s\n", val, $1);
            }
            else if (strcmp(sym->type, "string") == 0) {
                if ($3[0] == '"') {  // Remove quotes for string literals
                    char* str = strdup($3 + 1);
                    str[strlen(str) - 1] = '\0';
                    update_symbol_string($1, str);
                    free(str);
                } else {
                    update_symbol_string($1, $3);
                }
                printf("Assigned value to %s\n", $1);
            }
            $$ = $1;
        } else {
            printf("Error: Undefined variable %s\n", $1);
            $$ = NULL;
        }
    }
    ;

expression
    : INTEGER { 
        char buf[32]; 
        sprintf(buf, "%d", $1); 
        $$ = strdup(buf); 
    }
    | FLOAT_VAL { 
        char buf[32]; 
        sprintf(buf, "%.2f", $1); 
        $$ = strdup(buf); 
    }
    | IDENTIFIER { $$ = $1; }
    | STRING_LITERAL { $$ = $1; }
    | expression '+' expression { 
        struct Symbol* sym1 = get_symbol($1);
        struct Symbol* sym2 = get_symbol($3);
        double val1, val2;
        
        // Get first value
        if (sym1) {
            if (strcmp(sym1->type, "int") == 0)
                val1 = sym1->value.ival;
            else if (strcmp(sym1->type, "float") == 0)
                val1 = sym1->value.fval;
        } else {
            val1 = atof($1);
        }
        
        // Get second value
        if (sym2) {
            if (strcmp(sym2->type, "int") == 0)
                val2 = sym2->value.ival;
            else if (strcmp(sym2->type, "float") == 0)
                val2 = sym2->value.fval;
        } else {
            val2 = atof($3);
        }
        
        char buf[256];
        sprintf(buf, "%.2f", val1 + val2);
        $$ = strdup(buf);
    }
    | expression '-' expression { 
        // Similar to addition but with subtraction
        struct Symbol* sym1 = get_symbol($1);
        struct Symbol* sym2 = get_symbol($3);
        double val1, val2;
        
        if (sym1) {
            if (strcmp(sym1->type, "int") == 0)
                val1 = sym1->value.ival;
            else if (strcmp(sym1->type, "float") == 0)
                val1 = sym1->value.fval;
        } else {
            val1 = atof($1);
        }
        
        if (sym2) {
            if (strcmp(sym2->type, "int") == 0)
                val2 = sym2->value.ival;
            else if (strcmp(sym2->type, "float") == 0)
                val2 = sym2->value.fval;
        } else {
            val2 = atof($3);
        }
        
        char buf[256];
        sprintf(buf, "%.2f", val1 - val2);
        $$ = strdup(buf);
    }
    | '(' expression ')' { $$ = $2; }
    ;

print_statement
    : PRINT '(' expression ')' {
        struct Symbol* sym = get_symbol($3);
        if (sym) {
            if (strcmp(sym->type, "int") == 0) {
                printf("%d", sym->value.ival);
            }
            else if (strcmp(sym->type, "float") == 0) {
                printf("%.2f", sym->value.fval);
            }
            else if (strcmp(sym->type, "string") == 0) {
                printf("%s", sym->value.sval);
            }
        } else if ($3[0] == '"') {
            // Remove quotes and handle escape sequences
            char* str = strdup($3 + 1);
            str[strlen(str) - 1] = '\0';
            
            // Process escape sequences
            char* src = str;
            char* dst = str;
            while (*src) {
                if (*src == '\\' && *(src + 1) == 'n') {
                    *dst++ = '\n';
                    src += 2;
                } else {
                    *dst++ = *src++;
                }
            }
            *dst = '\0';
            
            printf("%s", str);
            free(str);
        } else {
            printf("%s", $3);
        }
        $$ = "";  // Return empty string to prevent cascading
    }
    ;

if_statement
    : IF '(' condition ')' '{' statement_list '}' %prec LOWER_THAN_ELSE {
        if ($3) {
            printf("%s", $6);
        }
        $$ = "";
    }
    | IF '(' condition ')' '{' statement_list '}' ELSE '{' statement_list '}' {
        if ($3) {
            printf("%s", $6);
        } else {
            printf("%s", $10);
        }
        $$ = "";
    }
    ;

while_statement
    : WHILE '(' condition ')' '{' statement_list '}' { $$ = $6; }
    ;

for_statement
    : FOR '(' for_init ';' condition ';' assignment ')' '{' statement_list '}' { $$ = $10; }
    ;

for_init
    : declaration '=' expression { $$ = $1; }
    | assignment { $$ = $1; }
    ;

condition
    : expression comparison_op expression {
        struct Symbol* sym1 = get_symbol($1);
        struct Symbol* sym2 = get_symbol($3);
        double val1 = 0, val2 = 0;
        
        // Get first value
        if (sym1) {
            if (strcmp(sym1->type, "int") == 0)
                val1 = sym1->value.ival;
            else if (strcmp(sym1->type, "float") == 0)
                val1 = sym1->value.fval;
        } else {
            val1 = atof($1);
        }
        
        // Get second value
        if (sym2) {
            if (strcmp(sym2->type, "int") == 0)
                val2 = sym2->value.ival;
            else if (strcmp(sym2->type, "float") == 0)
                val2 = sym2->value.fval;
        } else {
            val2 = atof($3);
        }
        
        switch($2) {
            case 1: $$ = (val1 < val2); break;
            case 2: $$ = (val1 > val2); break;
            case 3: $$ = (val1 == val2); break;
            case 4: $$ = (val1 != val2); break;
            case 5: $$ = (val1 <= val2); break;
            case 6: $$ = (val1 >= val2); break;
            default: $$ = 0;
        }
    }
    | expression {
        struct Symbol* sym = get_symbol($1);
        if (sym) {
            if (strcmp(sym->type, "int") == 0)
                $$ = (sym->value.ival != 0);
            else if (strcmp(sym->type, "float") == 0)
                $$ = (sym->value.fval != 0);
        } else {
            $$ = (atof($1) != 0);
        }
    }
    | '(' condition ')' { $$ = $2; }
    ;

comparison_op
    : '<' { $$ = 1; }
    | '>' { $$ = 2; }
    | EQ { $$ = 3; }
    | NE { $$ = 4; }
    | LE { $$ = 5; }
    | GE { $$ = 6; }
    ;

return_statement
    : RETURN expression { $$ = $2; }
    ;

scanf_statement
    : SCANF '(' IDENTIFIER ')' {
        struct Symbol* sym = get_symbol($3);
        if (sym) {
            char input[256];
            if (strcmp(sym->type, "string") == 0) {
                scanf(" %[^\n]s", input);  // Read entire line for strings
            } else {
                scanf("%s", input);
            }
            
            if (strcmp(sym->type, "int") == 0) {
                int val = atoi(input);
                update_symbol_int($3, val);
            }
            else if (strcmp(sym->type, "float") == 0) {
                float val = atof(input);
                update_symbol_float($3, val);
            }
            else if (strcmp(sym->type, "string") == 0) {
                update_symbol_string($3, input);
            }
            $$ = $3;
        } else {
            printf("Error: Undefined variable %s\n", $3);
            $$ = NULL;
        }
    }
    ;

%%

// Symbol table functions
void add_symbol(char* name, char* type) {
    symbols[symbol_count].name = strdup(name);
    symbols[symbol_count].type = strdup(type);
    symbol_count++;
}

struct Symbol* get_symbol(char* name) {
    for(int i = 0; i < symbol_count; i++) {
        if(strcmp(symbols[i].name, name) == 0) {
            return &symbols[i];
        }
    }
    return NULL;
}

void update_symbol_int(char* name, int value) {
    struct Symbol* sym = get_symbol(name);
    if(sym && strcmp(sym->type, "int") == 0) {
        sym->value.ival = value;
    }
}

void update_symbol_float(char* name, float value) {
    struct Symbol* sym = get_symbol(name);
    if(sym && strcmp(sym->type, "float") == 0) {
        sym->value.fval = value;
    }
}

void update_symbol_string(char* name, char* value) {
    struct Symbol* sym = get_symbol(name);
    if(sym && strcmp(sym->type, "string") == 0) {
        sym->value.sval = strdup(value);
    }
}

void yyerror(const char* s) {
    fprintf(stderr, "Error at line %d: %s\n", line_number, s);
}

int main(int argc, char** argv) {
    if (argc != 2) {
        printf("Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    FILE* input = fopen(argv[1], "r");
    if (!input) {
        printf("Cannot open input file %s\n", argv[1]);
        return 1;
    }

    yyin = input;
    int result = yyparse();
    
    if (result == 0) {
        printf("\nSymbol Table:\n");
        for(int i = 0; i < symbol_count; i++) {
            printf("%s: %s\n", symbols[i].name, symbols[i].type);
        }
    }

    fclose(input);
    return result;
}