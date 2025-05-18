%{
#include <stdio.h>
#include <string.h>   
#include <stdbool.h>

bool is_declaring = false;
bool expecting_semicolon = false;
int line_number = 1;
int paren_count = 0, brace_count = 0;
int yywrap(void) { return 1; }
%}

%%

[a-zA-Z_][a-zA-Z0-9_]* {
    if (strcmp(yytext, "int") == 0 ||
        strcmp(yytext, "float") == 0 ||
        strcmp(yytext, "char") == 0 ||
        strcmp(yytext, "double") == 0 ||
        strcmp(yytext, "long") == 0 ||
        strcmp(yytext, "short") == 0 ||
        strcmp(yytext, "void") == 0)
    {
        printf("Keyword: %s\n", yytext);
        is_declaring = true;
        expecting_semicolon = true;  
    }
    else if (strcmp(yytext, "return") == 0 ||
             strcmp(yytext, "if") == 0 ||
             strcmp(yytext, "else") == 0 ||
             strcmp(yytext, "while") == 0 ||
             strcmp(yytext, "for") == 0 ||
             strcmp(yytext, "break") == 0 ||
             strcmp(yytext, "continue") == 0)
    {
        printf("Keyword: %s\n", yytext);
        if (is_declaring) {
            printf("Error (line %d): Cannot use reserved keyword '%s' as a variable name!\n", line_number, yytext);
            is_declaring = false;
        }
        expecting_semicolon = true; 
    }
    else {
        if (is_declaring) {
            printf("Declared Identifier: %s\n", yytext);
            is_declaring = false;
        } else {
            printf("Identifier: %s\n", yytext);
        }
    }
}

[0-9]+\.[0-9]+             { printf("Float Constant: %s\n", yytext); }
[0-9]+                     { printf("Integer Constant: %s\n", yytext); }
'\''.(\\[ntbr0\'\"\\])?'\''  { printf("Character Constant: %s\n", yytext); }
\"([^\"\\]|\\.)*\"         { printf("String Literal: %s\n", yytext); }

"#".*                      { printf("Preprocessor Directive: %s\n", yytext); }

"=="                       { printf("Relational Operator: Equal To (==)\n"); }
"!="                       { printf("Relational Operator: Not Equal (!=)\n"); }
"<="                       { printf("Relational Operator: Less Than or Equal (<=)\n"); }
">="                       { printf("Relational Operator: Greater Than or Equal (>=)\n"); }
"<"                        { printf("Relational Operator: Less Than (<)\n"); }
">"                        { printf("Relational Operator: Greater Than (>)\n"); }

"&&"                       { printf("Logical Operator: Logical AND (&&)\n"); }
"||"                       { printf("Logical Operator: Logical OR (||)\n"); }
"!"                        { printf("Logical Operator: Logical NOT (!)\n"); }

"&"                        { printf("Bitwise Operator: AND (&)\n"); }
"|"                        { printf("Bitwise Operator: OR (|)\n"); }
"^"                        { printf("Bitwise Operator: XOR (^)\n"); }
"~"                        { printf("Bitwise Operator: NOT (~)\n"); }

"=" {printf("Assignment Operator: Equal (=)\n");}

"+="                       { printf("Assignment Operator: Add and Assign (+=)\n"); }
"-="                       { printf("Assignment Operator: Subtract and Assign (-=)\n"); }
"*="                       { printf("Assignment Operator: Multiply and Assign (*=)\n"); }
"/="                       { printf("Assignment Operator: Divide and Assign (/=)\n"); }
"%="                       { printf("Assignment Operator: Modulus and Assign (%=)\n"); }

"+"                        { printf("Arithmetic Operator: Addition (+)\n"); }
"-"                        { printf("Arithmetic Operator: Subtraction (-)\n"); }
"*"                        { printf("Arithmetic Operator: Multiplication (*)\n"); }
"/"                        { printf("Arithmetic Operator: Division (/)\n"); }
"%"                        { printf("Arithmetic Operator: Modulus (%)\n"); }

"("  { paren_count++; printf("Delimiter: Left Parenthesis '('\n"); }
")"  { paren_count--; printf("Delimiter: Right Parenthesis ')'\n"); }
"{"  { brace_count++; printf("Delimiter: Left Brace '{'\n"); }
"}"  { brace_count--; printf("Delimiter: Right Brace '}'\n"); }
"["                        { printf("Delimiter: Left Bracket '['\n"); }
"]"                        { printf("Delimiter: Right Bracket ']'\n"); }
";" {
    printf("Delimiter: Semicolon (;)\n");
    expecting_semicolon = false;
}
","                        { printf("Delimiter: Comma (,)\n"); }
"."                        { printf("Delimiter: Dot (.)\n"); }
"->"                       { printf("Delimiter: Arrow Operator (->)\n"); }
"::"                       { printf("Delimiter: Scope Resolution (::)\n"); }

"//".*                     { /* Single-line comment – ignored */ }


[\n] {
    line_number++;
    if (expecting_semicolon) {
        printf("Error (line %d): Missing semicolon!\n", line_number - 1);
        expecting_semicolon = false;
    }
}

[ \t\r]+                   { /* Skip whitespace */ }

.                          { printf("Unknown or Invalid Token: %s\n", yytext); }

%%

int main() {
    printf("Starting tokenization...\n");
    yylex();
if (paren_count != 0)
    printf("Error: Unmatched parentheses detected!\n");
if (brace_count != 0)
    printf("Error: Unmatched curly braces detected!\n");
    printf("Tokenization complete.\n");
    return 0;
}
