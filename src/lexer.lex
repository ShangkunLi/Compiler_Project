%{
#include <stdio.h>
#include <string.h>
#include "TeaplAst.h"
#include "y.tab.hpp"
extern int line, col;
int c;
int calc(char *s, int len);
%}


%s COMMENT INLINE_COMMENT

%%
<INITIAL>"/*" { BEGIN(COMMENT); }
<COMMENT>[^*\n]* {}
<COMMENT>"*"+[^"*/"\n]* {}
<COMMENT>[\n\r] { line++; col=0; }
<COMMENT>"*"+"/" {BEGIN(INITIAL); }


<INITIAL>"//" {BEGIN(INLINE_COMMENT); }
<INLINE_COMMENT>[^\n\r]* {}
<INLINE_COMMENT>[\n\r] {
    line++;
    col=0;
    BEGIN(INITIAL);
}


<INITIAL>"\n" { line+=1; col=0; }
<INITIAL>" " { col+=1; }
<INITIAL>"\t" { col+=4; }
<INITIAL>[1-9][0-9]* {
    yylval.tokenNum = A_TokenNum(A_Pos(line, col), calc(yytext, yyleng));
    col+=yyleng;
    return NUM;
}
<INITIAL>0 {
    yylval.tokenNum = A_TokenNum(A_Pos(line, col), 0);
    ++col;
    return NUM;
}
<INITIAL>"+" {yylval.pos = A_Pos(line, col); col+=1; return ADD; }
<INITIAL>"-" {yylval.pos = A_Pos(line, col); col+=1; return SUB; }
<INITIAL>"*" {yylval.pos = A_Pos(line, col); col+=1; return MUL; }
<INITIAL>"/" {yylval.pos = A_Pos(line, col); col+=1; return DIV; }


<INITIAL>";" {yylval.pos = A_Pos(line, col); col+=1; return SEMICOLON; }
<INITIAL>"=" {yylval.pos = A_Pos(line, col); col+=1; return ASSIGN; }
<INITIAL>":" {yylval.pos = A_Pos(line, col); col+=1; return COLON; }
<INITIAL>"." {yylval.pos = A_Pos(line, col); col+=1; return DOT; }
<INITIAL>"," {yylval.pos = A_Pos(line, col); col+=1; return COMMA; }
<INITIAL>"(" {yylval.pos = A_Pos(line, col); col+=1; return LPAREN; }
<INITIAL>")" {yylval.pos = A_Pos(line, col); col+=1; return RPAREN; }
<INITIAL>"[" {yylval.pos = A_Pos(line, col); col+=1; return LBRACKET; }
<INITIAL>"]" {yylval.pos = A_Pos(line, col); col+=1; return RBRACKET; }
<INITIAL>"{" {yylval.pos = A_Pos(line, col); col+=1; return LBRACE; }
<INITIAL>"}" {yylval.pos = A_Pos(line, col); col+=1; return RBRACE; }


<INITIAL>"||" {yylval.pos = A_Pos(line, col); col+=2; return OR; }
<INITIAL>"!" {yylval.pos = A_Pos(line, col); col+=1; return NOT; }
<INITIAL>"&&" {yylval.pos = A_Pos(line, col); col+=2; return AND; }
<INITIAL>"<" {yylval.pos = A_Pos(line, col); col+=1; return LT; }
<INITIAL>"<=" {yylval.pos = A_Pos(line, col); col+=2; return LE; }
<INITIAL>">" {yylval.pos = A_Pos(line, col); col+=1; return GT; }
<INITIAL>">=" {yylval.pos = A_Pos(line, col); col+=2; return GE; }
<INITIAL>"==" {yylval.pos = A_Pos(line, col); col+=2; return EQ; }
<INITIAL>"!=" {yylval.pos = A_Pos(line, col); col+=2; return NE; }
<INITIAL>"->" {yylval.pos = A_Pos(line, col); col+=2; return DARROW; }


<INITIAL>"let" {yylval.pos = A_Pos(line, col); col+=3; return LET; }
<INITIAL>"while" {yylval.pos = A_Pos(line, col); col+=5; return WHILE; }
<INITIAL>"struct" {yylval.pos = A_Pos(line, col); col+=6; return STRUCT; }
<INITIAL>"fn" {yylval.pos = A_Pos(line, col); col+=2; return FN; }
<INITIAL>"ret" {yylval.pos = A_Pos(line, col); col+=3; return RET; }
<INITIAL>"continue" {yylval.pos = A_Pos(line, col); col+=8; return CONTINUE; }
<INITIAL>"break" {yylval.pos = A_Pos(line, col); col+=5; return BREAK; }
<INITIAL>"if" {yylval.pos = A_Pos(line, col); col+=2; return IF; }
<INITIAL>"else" {yylval.pos = A_Pos(line, col); col+=4; return ELSE; }
<INITIAL>"int" {yylval.pos = A_Pos(line, col); col+=3; return INT; }
<INITIAL>[a-z_A-Z]+([a-z_A-Z0-9]*) 	{ 
    int len = strlen(yytext);
    char* new_text = (char*)malloc((len+1)*sizeof(char));
    strcpy(new_text, yytext);
    new_text[len]='\0';
    yylval.tokenId = A_TokenId(A_Pos(line, col), new_text); col+=strlen(yytext); return TOKENID; 
}

%%

// This function takes a string of digits and its length as input, and returns the integer value of the string.
int calc(char *s, int len) {
    int ret = 0;
    for(int i = 0; i < len; i++)
        ret = ret * 10 + (s[i] - '0');
    return ret;
}