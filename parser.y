%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);
extern int yylineno;  // provided by lexer to track line number
%}

%define parse.error verbose
%locations

%union {
    int ival;
    float fval;
    char *sval;
}

/* Token type definitions */
%token <sval> ID
%token <ival> INT_CONST
%token <fval> FLOAT_CONST

%token INT FLOAT CHAR IF ELSE WHILE RETURN
%token EQ NEQ LE GE

%left '+' '-'
%left '*' '/'
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%type <ival> expr

%%

program:
    statements
;

statements:
    statements statement
    | statement
;

statement:
    declaration
    | assignment
    | if_statement
;

declaration:

    INT ID ';' {
        printf("Declaration: int %s\n", $2);
        free($2);
    }
;

assignment:
    ID '=' expr ';' {
        printf("Assignment: %s = (value)\n", $1);
        free($1);
    }
;

if_statement:
    IF '(' expr ')' statement %prec LOWER_THAN_ELSE
    | IF '(' expr ')' statement ELSE statement {
        printf("If-Else block\n");
    }
;

expr:
    expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | INT_CONST
    | FLOAT_CONST
    | ID
    | '(' expr ')'
;


%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, s);
}
