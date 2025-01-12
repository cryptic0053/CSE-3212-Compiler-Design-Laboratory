
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     STRING_LITERAL = 259,
     INTEGER = 260,
     FLOAT_VAL = 261,
     PRINT = 262,
     SCANF = 263,
     MAIN = 264,
     FOR = 265,
     WHILE = 266,
     IF = 267,
     ELIF = 268,
     ELSE = 269,
     BREAK = 270,
     CONTINUE = 271,
     RETURN = 272,
     CLASS = 273,
     INCLUDE = 274,
     FUNCTION = 275,
     TRY = 276,
     CATCH = 277,
     SUCCESS = 278,
     ARRAY = 279,
     INT = 280,
     FLOAT = 281,
     CHAR = 282,
     STRING = 283,
     STRUCT = 284,
     ENUM = 285,
     ASSIGN = 286,
     AND = 287,
     OR = 288,
     NOT = 289,
     VOID = 290,
     SWITCH = 291,
     CASE = 292,
     DO = 293,
     LE = 294,
     GE = 295,
     EQ = 296,
     NE = 297,
     LOWER_THAN_ELSE = 298
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 32 "2007094.y"

    int number;
    float floating;
    char* string;
    int type;



/* Line 1676 of yacc.c  */
#line 104 "2007094.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


