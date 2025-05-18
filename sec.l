%{
#include <stdio.h>
int yywrap(void) { return 1; }
int line_number = 1;
%}

ID          [a-zA-Z_][a-zA-Z0-9_]*
INT_CONST   [0-9]+
%%

{ID}               { printf("Identifier: %s\n", yytext); }
{INT_CONST}        { printf("Integer: %s\n", yytext); }

[\n]               { line_number++; }
[ \t\r]+           { /* skip spaces */ }

.                  { printf("Unknown Token: %s\n", yytext); }

%%

int main() {
    printf("Starting tokenization...\n");
    yylex();
    printf("Done.\n");
    return 0;
}
