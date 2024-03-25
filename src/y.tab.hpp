/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_HPP_INCLUDED
# define YY_YY_Y_TAB_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ADD = 258,
    SUB = 259,
    MUL = 260,
    DIV = 261,
    SEMICOLON = 262,
    ASSIGN = 263,
    COLON = 264,
    DOT = 265,
    COMMA = 266,
    LPAREN = 267,
    RPAREN = 268,
    LBRACKET = 269,
    RBRACKET = 270,
    LBRACE = 271,
    RBRACE = 272,
    AND = 273,
    OR = 274,
    NOT = 275,
    LT = 276,
    LE = 277,
    GT = 278,
    GE = 279,
    EQ = 280,
    NE = 281,
    DARROW = 282,
    LET = 283,
    WHILE = 284,
    STRUCT = 285,
    FN = 286,
    RET = 287,
    CONTINUE = 288,
    BREAK = 289,
    IF = 290,
    ELSE = 291,
    INT = 292,
    NUM = 293,
    TOKENID = 294
  };
#endif
/* Tokens.  */
#define ADD 258
#define SUB 259
#define MUL 260
#define DIV 261
#define SEMICOLON 262
#define ASSIGN 263
#define COLON 264
#define DOT 265
#define COMMA 266
#define LPAREN 267
#define RPAREN 268
#define LBRACKET 269
#define RBRACKET 270
#define LBRACE 271
#define RBRACE 272
#define AND 273
#define OR 274
#define NOT 275
#define LT 276
#define LE 277
#define GT 278
#define GE 279
#define EQ 280
#define NE 281
#define DARROW 282
#define LET 283
#define WHILE 284
#define STRUCT 285
#define FN 286
#define RET 287
#define CONTINUE 288
#define BREAK 289
#define IF 290
#define ELSE 291
#define INT 292
#define NUM 293
#define TOKENID 294

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 19 "parser.yacc"

  A_pos pos;  // position
  A_tokenId tokenId; // Id
  A_tokenNum tokenNum; // number
  A_type type;  // type, include NativeType & StructType
  A_nativeType nativeType;
  A_fnCall fnCall;  // function call
  A_callStmt callStmt; // call statement
  A_indexExpr indexExpr;  // NumIndexExpr & IdIndexExpr
  A_arrayExpr arrayExpr;  // array Expr
  A_memberExpr memberExpr;  // member Expr
  A_program program;  // program
  A_programElementList programElementList;  // 程序组成清单
  A_programElement programElement;  // 程序组成
  A_arithExpr arithExpr;  // 算术表达式
  A_boolExpr boolExpr; // 逻辑表达式
  A_boolUnit boolUnit;
  A_exprUnit exprUnit;  // 表达式
  A_structDef structDef;  // struct结构
  A_varDeclStmt varDeclStmt;  // 变量声明
  A_varDecl varDecl;  // declaration
  A_varDeclList varDeclList; // variable declaration list
  A_varDef varDef;  // definition
  A_fnDeclStmt fnDeclStmt;  // 函数声明
  A_fnDecl fnDecl; // 函数声明
  A_paramDecl paramDecl; // 参数声明
  A_fnDef fnDef;  // 函数定义
  A_codeBlockStmtList codeBlockStmtList; // code block statement list
  A_codeBlockStmt codeBlockStmt; // code block statement
  A_assignStmt assignStmt; // assign statement
  A_leftVal leftVal; // left value
  A_rightVal rightVal; // right value
  A_rightValList rightValList;  // right Value List

  A_ifStmt ifStmt;
  A_whileStmt whileStmt;
  A_returnStmt returnStmt;

#line 174 "y.tab.hpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_HPP_INCLUDED  */
