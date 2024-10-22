%%
.*	{printf("character\n");}
%%

int yywrap()
{
}
main()
{
yylex();
printf("Hello World");
}
