%{
#include <stdio.h>
#include "TeaplAst.h"

extern A_pos pos;
extern A_program root;

extern int yylex(void);
extern "C"{
extern void yyerror(char *s); 
extern int  yywrap();
}

%}

// TODO:
// your parser

%union {
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
}
// Define some basic tokens used in flex
%token <pos> ADD
%token <pos> SUB
%token <pos> MUL
%token <pos> DIV


%token <pos> SEMICOLON // ;
%token <pos> ASSIGN // assignment
%token <pos> COLON // :
%token <pos> DOT //.
%token <pos> COMMA // ,
%token <pos> LPAREN // (
%token <pos> RPAREN // )
%token <pos> LBRACKET // [
%token <pos> RBRACKET // ]
%token <pos> LBRACE // {
%token <pos> RBRACE // }


%token <pos> AND // &&
%token <pos> OR // ||
%token <pos> NOT // !
%token <pos> LT // less than
%token <pos> LE // less equal
%token <pos> GT // greater than
%token <pos> GE // greater equal
%token <pos> EQ // equal
%token <pos> NE // non-equal
%token <pos> DARROW // ->


%token <pos> LET  // let
%token <pos> WHILE // while
%token <pos> STRUCT // struct
%token <pos> FN // fn
%token <pos> RET // ret
%token <pos> CONTINUE // continue
%token <pos> BREAK // break
%token <pos> IF // if
%token <pos> ELSE // else

%token <pos> INT // int
%token <tokenNum> NUM
%token <tokenId> TOKENID

%left SEMICOLON
%left COMMA
%left WHILE
%left IF
%left ELSE
%left TOKENID
%left ASSIGN
%left OR
%left AND
%left LT LE GT GE EQ NE
%left ADD SUB
%left MUL DIV
%left UMINUS
%right NOT
%right LBRACKET
%left RBRACKET
%left DOT
%right LPAREN
%left RPAREN

%type <program> Program
%type <arithExpr> ArithExpr
%type <boolExpr> BoolExpr
%type <boolUnit> BoolUnit
%type <programElementList> ProgramElementList
%type <programElement> ProgramElement
%type <exprUnit> ExprUnit
%type <structDef> StructDef
%type <varDeclStmt> VarDeclStmt
%type <fnDeclStmt> FnDeclStmt
%type <fnDecl> FnDecl
%type <paramDecl> ParamDecl
%type <fnDef> FnDef
%type <codeBlockStmtList> CodeBlockStmtList
%type <codeBlockStmt> CodeBlockStmt
%type <varDecl> VarDecl
%type <varDef> VarDef
%type <type> Type
%type <assignStmt> AssignStmt
%type <leftVal> LeftVal
%type <rightVal> RightVal
%type <rightValList> RightValList
%type <varDeclList> VarDeclList
%type <ifStmt> IfStmt
%type <whileStmt> WhileStmt

%type <fnCall> FnCall
%type <callStmt> CallStmt
%type <returnStmt> ReturnStmt
%start Program

%%                   /* beginning of rules section */

Program: ProgramElementList 
{  
  root = A_Program($1);
  $$ = A_Program($1);
}
;

ProgramElementList: ProgramElement ProgramElementList
{
  $$ = A_ProgramElementList($1, $2);
}
|
{
  $$ = nullptr;
}
;

ProgramElement: VarDeclStmt
{
  $$ = A_ProgramVarDeclStmt($1->pos, $1);
}
| StructDef
{
  $$ = A_ProgramStructDef($1->pos, $1);
}
| FnDeclStmt
{
  $$ = A_ProgramFnDeclStmt($1->pos, $1);
}
| FnDef
{
  $$ = A_ProgramFnDef($1->pos, $1);
}
| SEMICOLON
{
  $$ = A_ProgramNullStmt($1);
}
;


// Variable Declarations BEGIN
VarDeclStmt: LET VarDecl SEMICOLON
{
  $$ = A_VarDeclStmt($2->pos, $2);
}
| LET VarDef SEMICOLON
{
  $$ = A_VarDefStmt($2->pos, $2);
}
;

VarDecl: TOKENID COLON Type
{
  $$ = A_VarDecl_Scalar($1->pos, A_VarDeclScalar($1->pos, $1->id, $3));
}
| TOKENID
{
  $$ = A_VarDecl_Scalar($1->pos, A_VarDeclScalar($1->pos, $1->id, NULL));
}
| TOKENID LBRACKET NUM RBRACKET COLON Type
{
  $$ = A_VarDecl_Array($1->pos, A_VarDeclArray($1->pos, $1->id, $3->num, $6));
}
| TOKENID LBRACKET NUM RBRACKET
{
  $$ = A_VarDecl_Array($1->pos, A_VarDeclArray($1->pos, $1->id, $3->num, NULL));
}
;

VarDef: TOKENID COLON Type ASSIGN RightVal
{
  $$ = A_VarDef_Scalar($1->pos, A_VarDefScalar($1->pos, $1->id, $3, $5));
}
| TOKENID ASSIGN RightVal
{
  $$ = A_VarDef_Scalar($1->pos, A_VarDefScalar($1->pos, $1->id, NULL, $3));
}
| TOKENID LBRACKET NUM RBRACKET COLON Type ASSIGN LBRACE RightValList RBRACE
{
  $$ = A_VarDef_Array($1->pos, A_VarDefArray($1->pos, $1->id, $3->num, $6, $9));
}
| TOKENID LBRACKET NUM RBRACKET ASSIGN LBRACE RightValList RBRACE
{
  $$ = A_VarDef_Array($1->pos, A_VarDefArray($1->pos, $1->id, $3->num, NULL, $7));
}
;

Type: INT
{
  $$ = A_NativeType($1,A_intTypeKind);
}
| TOKENID
{
  $$ = A_StructType($1->pos, $1->id);
}
;
// Variable Declarations END


// Structure Definition BEGIN
StructDef: STRUCT TOKENID LBRACE VarDeclList RBRACE
{
  $$ = A_StructDef($2->pos, $2->id, $4);
}
;

VarDeclList: VarDecl COMMA VarDeclList
{
  $$ = A_VarDeclList($1, $3);
}
| VarDecl
{
  $$ = A_VarDeclList($1, NULL);
}
|
{
  $$ = nullptr;
}
;
// Structure Definition END

// Assignment Statement BEGIN
AssignStmt: LeftVal ASSIGN RightVal SEMICOLON
{
  $$ = A_AssignStmt($1->pos, $1, $3);
}
;

LeftVal: TOKENID
{
  $$ = A_IdExprLVal($1->pos, $1->id);
}
| LeftVal LBRACKET TOKENID RBRACKET
{
  $$ = A_ArrExprLVal($1->pos, A_ArrayExpr($1->pos, $1, A_IdIndexExpr($3->pos, $3->id)));
}
| LeftVal LBRACKET NUM RBRACKET
{
  $$ = A_ArrExprLVal($1->pos, A_ArrayExpr($1->pos, $1, A_NumIndexExpr($3->pos, $3->num)));
}
| LeftVal DOT TOKENID
{
  $$ = A_MemberExprLVal($1->pos, A_MemberExpr($1->pos, $1, $3->id));
}
;

RightVal: ArithExpr
{
  $$ = A_ArithExprRVal($1->pos, $1);
}
| BoolExpr
{
  $$ = A_BoolExprRVal($1->pos, $1);
}
;

RightValList: RightVal COMMA RightValList
{
  $$ = A_RightValList($1, $3);
}
| RightVal
{
  $$ = A_RightValList($1, NULL);
}
| 
{
  $$ = nullptr;
}
;
// Assignment Statement END


// Arithmetic Expression BEGIN
ArithExpr: ArithExpr ADD ArithExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_add, $1, $3));
}
| ArithExpr SUB ArithExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_sub, $1, $3));
}
| ArithExpr MUL ArithExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_mul, $1, $3));
}
| ArithExpr DIV ArithExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_div, $1, $3));
}
| ExprUnit
{
  $$ = A_ExprUnit($1->pos, $1);
}
;

ExprUnit: NUM
{
  $$ = A_NumExprUnit($1->pos, $1->num);
}
| TOKENID
{
  $$ = A_IdExprUnit($1->pos, $1->id);
}
| LPAREN ArithExpr RPAREN
{
  $$ = A_ArithExprUnit($2->pos, $2);
}
| FnCall
{
  $$ = A_CallExprUnit($1->pos, $1);
}
| LeftVal LBRACKET TOKENID RBRACKET
{
  $$ = A_ArrayExprUnit($1->pos, A_ArrayExpr($1->pos, $1, A_IdIndexExpr($1->pos, $3->id)));
}
| LeftVal LBRACKET NUM RBRACKET
{
  $$ = A_ArrayExprUnit($1->pos, A_ArrayExpr($1->pos, $1, A_NumIndexExpr($1->pos, $3->num)));
}
| LeftVal DOT TOKENID
{
  $$ = A_MemberExprUnit($1->pos, A_MemberExpr($1->pos, $1, $3->id));
}
| SUB ExprUnit %prec UMINUS
{
  $$ = A_ArithUExprUnit($2->pos, A_ArithUExpr($2->pos, A_neg, $2));
}
;
// Arithmetic Expression END


// Condition Expression BEGIN
BoolExpr: BoolExpr AND BoolExpr
{
  $$ = A_BoolBiOp_Expr($1->pos, A_BoolBiOpExpr($1->pos, A_and, $1, $3));
}
| BoolExpr OR BoolExpr
{
  $$ = A_BoolBiOp_Expr($1->pos, A_BoolBiOpExpr($1->pos, A_or, $1, $3));
}
| BoolUnit
{
  $$ = A_BoolExpr($1->pos, $1);
}
;

BoolUnit: ExprUnit LT ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_lt, $1, $3));
}
| ExprUnit LE ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_le, $1, $3));
}
| ExprUnit GT ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_gt, $1, $3));
}
| ExprUnit GE ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_ge, $1, $3));
}
| ExprUnit EQ ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_eq, $1, $3));
}
| ExprUnit NE ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_ne, $1, $3));
}
| LPAREN BoolExpr RPAREN
{
  $$ = A_BoolExprUnit($2->pos, $2);
}
| NOT BoolUnit
{
  $$ = A_BoolUOpExprUnit($2->pos, A_BoolUOpExpr($2->pos, A_not, $2));
}
;
// Condition Expression END


// Function Declaration and Definition BENGIN
FnDeclStmt: FnDecl SEMICOLON
{
  $$ = A_FnDeclStmt($1->pos, $1);
}
;

FnDecl: FN TOKENID LPAREN ParamDecl RPAREN
{
  $$ = A_FnDecl($1, $2->id, $4, NULL);
}
| FN TOKENID LPAREN ParamDecl RPAREN DARROW Type
{
  $$ = A_FnDecl($1, $2->id, $4, $7);
}
;

ParamDecl: VarDeclList
{
  $$ = A_ParamDecl($1);
}
;

FnDef: FnDecl LBRACE CodeBlockStmtList RBRACE
{
  $$ = A_FnDef($1->pos, $1, $3);
}
;

CodeBlockStmtList: CodeBlockStmt CodeBlockStmtList
{
  $$ = A_CodeBlockStmtList($1, $2);
}
| CodeBlockStmt
{
  $$ = A_CodeBlockStmtList($1, NULL);
}
;

CodeBlockStmt: VarDeclStmt
{
  $$ = A_BlockVarDeclStmt($1->pos, $1);
}
| AssignStmt
{
  $$ = A_BlockAssignStmt($1->pos, $1);
}
| CallStmt
{
  $$ = A_BlockCallStmt($1->pos, $1);
}
| IfStmt
{
  $$ = A_BlockIfStmt($1->pos, $1);
}
| WhileStmt
{
  $$ = A_BlockWhileStmt($1->pos, $1);
}
| ReturnStmt
{
  $$ = A_BlockReturnStmt($1->pos, $1);
}
| CONTINUE SEMICOLON
{
  $$ = A_BlockContinueStmt($1);
}
| BREAK SEMICOLON
{
  $$ = A_BlockBreakStmt($1);
}
| SEMICOLON
{
  $$ = A_BlockNullStmt($1);
}
;
// Function Declaration and Definition END

// Basic Statements BEGIN
CallStmt: FnCall SEMICOLON
{
  $$ = A_CallStmt($1->pos, $1);
}
;

FnCall: TOKENID LPAREN RightValList RPAREN
{
  $$ = A_FnCall($1->pos, $1->id, $3);
}
;

IfStmt: IF LPAREN BoolExpr RPAREN LBRACE CodeBlockStmtList RBRACE
{
  $$ = A_IfStmt($1, $3, $6, NULL);
}
| IF LPAREN BoolExpr RPAREN LBRACE CodeBlockStmtList RBRACE ELSE LBRACE CodeBlockStmtList RBRACE
{
  $$ = A_IfStmt($1, $3, $6, $10);
}
;

WhileStmt: WHILE LPAREN BoolExpr RPAREN LBRACE CodeBlockStmtList RBRACE
{
  $$ = A_WhileStmt($3->pos, $3, $6);
}
;

ReturnStmt: RET RightVal SEMICOLON
{
  $$ = A_ReturnStmt($1, $2);
}
| RET SEMICOLON
{
  $$ = A_ReturnStmt($1, NULL);
}
;
// Basic Statements END

%%

extern "C"{
void yyerror(char * s)
{
  fprintf(stderr, "%s\n",s);
}
int yywrap()
{
  return(1);
}
}


