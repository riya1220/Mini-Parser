%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int line_number = 1;
int yywrap(void) { return 1; }
%}

%%

[a-zA-Z_][a-zA-Z0-9_]*     {
    if (strcmp(yytext, "int") == 0 ||
        strcmp(yytext, "float") == 0 ||
        strcmp(yytext, "char") == 0 ||
        strcmp(yytext, "if") == 0 ||
        strcmp(yytext, "else") == 0 ||
        strcmp(yytext, "while") == 0 ||
        strcmp(yytext, "for") == 0 ||
        strcmp(yytext, "return") == 0 ||
        strcmp(yytext, "void") == 0 ||
        strcmp(yytext, "main") == 0) // Added "main" here
    {
        printf("Keyword: %s\n", yytext);
    }
    else {
        printf("Identifier: %s\n", yytext);
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

"="                        { printf("Assignment Operator: Equal (=)\n"); }
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

"("                        { printf("Delimiter: Left Parenthesis '('\n"); }
")"                        { printf("Delimiter: Right Parenthesis ')'\n"); }
"["                        { printf("Delimiter: Left Bracket '['\n"); }
"]"                        { printf("Delimiter: Right Bracket ']'\n"); }
"{"                        { printf("Delimiter: Left Brace '{'\n"); }
"}"                        { printf("Delimiter: Right Brace '}'\n"); }
";"                        { printf("Delimiter: Semicolon (;)\n"); }
","                        { printf("Delimiter: Comma (,)\n"); }
"."                        { printf("Delimiter: Dot (.)\n"); }
"->"                       { printf("Delimiter: Arrow Operator (->)\n"); }
"::"                       { printf("Delimiter: Scope Resolution (::)\n"); }

"//".*                     { /* Single-line comment – ignored */ }

[\n]                       { line_number++; }
[ \t\r]+                   { /* Skip whitespace */ }

.                          { printf("Unknown or Invalid Token: %s\n", yytext); }

%%

int main() {
    char buffer[1024];

    printf("Starting tokenization...\n");

    // Read input
    if (fgets(buffer, sizeof(buffer), stdin)) {
        // Remove newline character if present
        buffer[strcspn(buffer, "\n")] = '\0';

        // Print user input
        printf("%s\n", buffer);
        printf("------------------------\n");

        // Tell flex to scan only this string
        YY_BUFFER_STATE bp = yy_scan_string(buffer);
        yylex();  // Tokenize
        yy_delete_buffer(bp);  // Free memory
    }

    printf("Tokenization complete.\n");
    return 0;
}