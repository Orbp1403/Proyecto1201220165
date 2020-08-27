/**
 * Ejemplo mi primer proyecto con Jison utilizando Nodejs en Ubuntu
 */

/* Definición Léxica */
%lex

%options case-sensitive
numero [0-9]+
decimal {numero}"."{numero}
cadena (\"[^\"]*\")

%%

/* Espacios en blanco */
[ \r\t]+            {}
\n                  {}

{numero}                                return 'ENTERO'
{decimal}                               return 'DECIMAL'
{cadena}                                return 'CADENA'

"let"                                   return 'LET'
"const"                                 return 'CONST'
"string"                                return 'STRING'
"number"                                return 'NUMBER'
"boolean"                               return 'BOOLEAN'
"void"                                  return 'VOID'

":"                                     return 'DP'
";"                                     return 'PYC'
"="                                     return '='
"+"                                     return '+'
"-"                                     return '-'
"*"                                     return '*'
"/"                                     return '/'
"."                                     return '.'

["_" | a-z | A-Z]["_" | a-z | A-Z|0-9]* return 'IDENTIFICADOR';
<<EOF>>                                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

/* Asociación de operadores y precedencia */
%left '+' '-'
%left '*' '/'
%left NEGATIVO

%start ini

%% /* Definición de la gramática */

ini
	: Instrucciones EOF;

Instrucciones
    : Instrucciones Instruccion
    | Instruccion;

Instruccion
    : Declaracion;

Declaracion
    : LET IDENTIFICADOR DP Tipo '=' Expresion PYC
    | LET IDENTIFICADOR '=' Expresion PYC
    | LET IDENTIFICADOR DP Tipo PYC
    | LET IDENTIFICADOR PYC
    | CONST IDENTIFICADOR DP Tipo IGUAL Expresion PYC
    | CONST IDENTIFICADOR '=' Expresion PYC;

Expresion
    : '-' Expresion %prec NEGATIVO
    | Expresion '+' Expresion
    | Expresion '-' Expresion
    | Expresion '*' Expresion
    | Expresion '/' Expresion
    | ENTERO
    | DECIMAL
    | CADENA
    | IDENTIFICADOR
    | IDENTIFICADOR Listaatributos;

Listaatributos
    : '.' IDENTIFICADOR Listaatributos
    | '.' IDENTIFICADOR;

Tipo
    : STRING
    | NUMBER
    | BOOLEAN
    | VOID
    | IDENTIFICADOR;