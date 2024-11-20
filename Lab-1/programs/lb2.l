%%
[/][/].*	   {printf("single comment\n");}
[/][*](.|\n)*?[*][/]\n    {printf("multiline comment\n");}
%%

int yywrap()
{
return 1;
}

int main()
{
printf("single and multiline comment recognition\n");
       yylex();
       return 0;
}