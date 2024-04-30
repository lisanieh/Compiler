/* Definition section */
%{
    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #define printToken(token, value) (value ? printf("%-8s \t %s\n", token, (char*)value) : printf("%s\n", token))

    FILE* fout;
%}

/* Define regular expression label */
letter [a-zA-Z_]
digit [0-9]
Integer_number {digit}{digit}*
Float_number {digit}+"."{digit}+
Identifier [a-zA-Z][0-9a-zA-Z_]*
string \"[^\n"]*\"
character \'[^\n']+\'

/* Rules section */
%x multi_comment
%%

"//".*      { printToken("COMMENT", yytext); }
"cout"      { printToken("COUT", NULL);  }
"auto"      { printToken("AUTO_T", NULL); }
"void"      { printToken("VOID_T",NULL); }
"char"      { printToken("CHAR_T",NULL); }
"int"       { printToken("INT_T", NULL);  }
"long"      { printToken("LONG_T",NULL); }
"float"     { printToken("FLOAT_T",NULL); }
"double"    { printToken("DOUBLE_T",NULL); }
"bool"      { printToken("BOOL_T",NULL); }
"string"    { printToken("STR_T",NULL); }
"if"        { printToken("IF",NULL); }
"else"      { printToken("ELSE",NULL); }
"for"       { printToken("FOR",NULL); }
"while"     { printToken("WHILE",NULL); }
"return"    { printToken("RETURN",NULL); }
"break"     { printToken("BREAK",NULL); }
"true"      { printToken("BOOL_LIT",yytext); }
"false"     { printToken("BOOL_LIT",yytext); }
">>"        { printToken("SHR",NULL); }
"<<"        { printToken("SHL",NULL); }
"&"         { printToken("BAN",NULL); }
"|"         { printToken("BOR",NULL); }
"~"         { printToken("BNT",NULL); }
"^"         { printToken("BXO",NULL); }
"+"         { printToken("ADD",NULL); }
"-"         { printToken("SUB",NULL); }
"*"         { printToken("MUL",NULL); }
"/"         { printToken("DIV",NULL); }
"%"         { printToken("MOD",NULL); }
"!"         { printToken("NOT",NULL); }
">"         { printToken("GTR",NULL); }
"<"         { printToken("LES",NULL); }
">="        { printToken("GEQ",NULL); }
"<="        { printToken("LEQ",NULL); }
"=="        { printToken("EQL",NULL); }
"!="        { printToken("NEQ",NULL); }
"&&"        { printToken("LAN",NULL); }
"||"        { printToken("LOR",NULL); }
"="         { printToken("VAL_ASSIGN",NULL); }
"+="        { printToken("ADD_ASSIGN",NULL); }
"-="        { printToken("SUB_ASSIGN",NULL); }
"*="        { printToken("MUL_ASSIGN",NULL); }
"/="        { printToken("DIV_ASSIGN",NULL); }
"%="        { printToken("REM_ASSIGN",NULL); }
">>="       { printToken("SHR_ASSIGN",NULL); }
"<<="       { printToken("SHL_ASSIGN",NULL); }
"&="        { printToken("BAN_ASSIGN",NULL); }
"|="        { printToken("BOR_ASSIGN",NULL); }
"++"        { printToken("INC_ASSIGN",NULL); }
"--"        { printToken("DEC_ASSIGN",NULL); }
"("        { printToken("\'(\'",NULL); }
")"        { printToken("\')\'",NULL); }
"["        { printToken("\'[\'",NULL); }
"]"        { printToken("\']\'",NULL); }
"{"        { printToken("\'{\'",NULL); }
"}"        { printToken("\'}\'",NULL); }
":"        { printToken("\':\'",NULL); }
";"        { printToken("\';\'",NULL); }
","        { printToken("\',\'",NULL); }
"\n"        { yylineno++; }
" "         { ; }
{Integer_number}     { printToken("INT_LIT",yytext); }
{Float_number}       { printToken("FLOAT_LIT",yytext); }
{Identifier}         { printToken("IDENT",yytext); }
{string}             { printToken("STRING_LIT",yytext); }
{character}          { printToken("CHAR_LIT",yytext); }
"/*"                 { 
                       yymore();
                       BEGIN(multi_comment); 
                     }
<multi_comment>"*/"  { BEGIN(INITIAL);
                       printToken("MULTI_COMMENT",yytext);
                     }
<multi_comment>"\n"  { 
                      yylineno++;
                      yymore();
                     }
<multi_comment>[^*\n]* { 
			yymore();
		        }                     
<multi_comment>"*"+[^*/\n]* {
			      yymore();
			    }
<<EOF>>     { static int once = 0; if (once++) {yyterminate();} }

%%
/*  C Code section */
int yywrap(void) {
    return 1;
}

int main(int argc, char* argv[]) {
    char *inputFileName = NULL;
    if (argc == 2) {
        yyin = fopen(inputFileName = argv[1], "r");
    } else {
        yyin = stdin;
    }
    if (!yyin) {
        printf("file `%s` doesn't exists or cannot be opened\n", inputFileName);
        exit(1);
    }

    yylex();
    printf("\nTotal line: %d\n", yylineno);

    fclose(yyin);
    return 0;
}
