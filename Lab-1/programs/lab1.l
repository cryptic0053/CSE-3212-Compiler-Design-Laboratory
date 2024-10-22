

%%

[A-Z]+[a-z]+[0-9]+	{printf("Found\n");}

%%

int yywrap()
{
	return 1;
}

int main()
{
	printf("ID recognization\n");
	yylex();
	return 0;
}