/* C declarations */

%{
	#include<stdio.h>
%}

/* Bison declarations */

%token EVEN ODD

/* Simple grammar rules */

%%

input:  EVEN	{ printf("\nEVEN NUMBER is %d\n", $1); return 0; }

	|ODD	{ printf("\nODD NUMBER\n"); return 0; }
	; 