%{
#include <stdio.h>

int yywrap(void) {
    return 1;
}
%}

%%
hello   { printf("Hi there! You typed hello.\n"); }
.|\n    { /* Ignore other characters */ }
%%

int main() {
    yylex();
    return 0;
}
