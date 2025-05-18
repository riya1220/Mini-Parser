%{
    #include <stdio.h>
    #include <string.h>
    
    char keywords[100][20]; 
    int k_idx = 0;
    
    char identifiers[100][20]; 
    int i_idx = 0;
    
    char assign_ops[100][5]; 
    int a_idx = 0;
    
    char int_consts[100][20]; 
    int ic_idx = 0;
    
    char float_consts[100][20]; 
    int fc_idx = 0;
    
    char delimiters[100][5]; 
    int d_idx = 0;
    
    int line_number = 1;
    int yywrap(void) { return 1; }
    %}
    
    %%
    
    "int"|"float"|"char"|"if"|"else"|"while"|"for"|"return"|"void"|"main" {
        strcpy(keywords[k_idx++], yytext);
    }
 
    [a-zA-Z_][a-zA-Z0-9_]* {
        // Check if it's not already classified as a keyword
        int found = 0;
        for (int i = 0; i < k_idx; i++) {
            if (strcmp(yytext, keywords[i]) == 0) {
                found = 1;
                break;
            }
        }
        if (!found) {
            strcpy(identifiers[i_idx++], yytext);
        }
    }
    
    [0-9]+\.[0-9]+ {
        strcpy(float_consts[fc_idx++], yytext);
    }
   
    [0-9]+ {
        strcpy(int_consts[ic_idx++], yytext);
    }
    
    "=" {
        strcpy(assign_ops[a_idx++], yytext);
    }
    
    "{"|"}"|"(" | ")"|";" {
        strcpy(delimiters[d_idx++], yytext);
    }
    
    [ \t\r]+         { /* Skip whitespace */ }
    "//".*           { /* Skip single-line comments */ }
    [\n]             { line_number++; }
    
    .                { /* Ignore unrecognized characters */ }
    
    %%
    
    int main() {
        char buffer[1024];
    
        printf("Starting tokenization...\n");
    
        // Read input from stdin
        while (fgets(buffer, sizeof(buffer), stdin)) {
            buffer[strcspn(buffer, "\n")] = '\0';  // Remove trailing newline
            printf("%s\n", buffer);               // Echo input
            printf("------------------------\n");
    
            YY_BUFFER_STATE bp = yy_scan_string(buffer);
            yylex();
            yy_delete_buffer(bp);
    
            // Grouped output
            if (k_idx) {
                printf("\nKeywords:\n");
                for (int i = 0; i < k_idx; i++) printf("- %s\n", keywords[i]);
            }
            if (i_idx) {
                printf("\nDeclared Identifiers:\n");
                for (int i = 0; i < i_idx; i++) printf("- %s\n", identifiers[i]);
            }
            if (a_idx) {
                printf("\nAssignment Operators:\n");
                for (int i = 0; i < a_idx; i++) printf("- %s\n", assign_ops[i]);
            }
            if (ic_idx) {
                printf("\nInteger Constants:\n");
                for (int i = 0; i < ic_idx; i++) printf("- %s\n", int_consts[i]);
            }
            if (fc_idx) {
                printf("\nFloat Constants:\n");
                for (int i = 0; i < fc_idx; i++) printf("- %s\n", float_consts[i]);
            }
            if (d_idx) {
                printf("\nDelimiters:\n");
                for (int i = 0; i < d_idx; i++) printf("- %s\n", delimiters[i]);
            }
        }
    
        printf("\nTokenization complete.\n");
        return 0;
    }
    
    