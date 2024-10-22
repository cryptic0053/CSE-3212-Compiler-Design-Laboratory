

%%

if|else|int|float|double|long|char|string|for|while|do|main|define|default|inline|goto|include|namespace|new|true|false|this|xor|and|or|static|switch|return|try|catch|throw|void|using|unsigned|typedef|break|const|continue|default|sizeof|union	{printf("Found");}
.* 
\n 
%%

int yywrap()
{
	return 1;
}

int main()
{
	printf("C program key words recognization\n");
	yylex();
	return 0;
}