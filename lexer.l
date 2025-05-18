%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>

%}

%%

"int"               { return INT; }
"float"             { return FLOAT; }
"char"              { return CHAR; }
"if"                { return IF; }
"else"              { return ELSE; }
"while"             { return WHILE; }
"return"            { return RETURN; }

"=="                { return EQ; }
"!="                { return NEQ; }
"<="                { return LE; }
">="                { return GE; }

[a-zA-Z_][a-zA-Z0-9_]*   { yylval.sval = strdup(yytext); return ID; }
[0-9]+\.[0-9]+           { yylval.fval = atof(yytext); return FLOAT_CONST; }
[0-9]+                   { yylval.ival = atoi(yytext); return INT_CONST; }

"="                 { return '='; }
"+"                 { return '+'; }
"-"                 { return '-'; }
"*"                 { return '*'; }
"/"                 { return '/'; }

"("                 { return '('; }
")"                 { return ')'; }
"{"                 { return '{'; }
"}"                 { return '}'; }
";"                 { return ';'; }
\n { yylineno++; }

[ \t\r]+            ;                       // Skip whitespace
.                   { return yytext[0]; }   // Catch all other characters

%%

int yywrap() { return 1; }
