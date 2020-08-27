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
"="                                     return 'IGUAL'

["_" | a-z | A-Z]["_" | a-z | A-Z]*     return 'IDENTIFICADOR';
<<EOF>>                                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

/* Asociación de operadores y precedencia */

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
    : LET IDENTIFICADOR DP Tipo IGUAL Expresion PYC
    | LET IDENTIFICADOR IGUAL Expresion PYC
    | LET IDENTIFICADOR DP Tipo PYC
    | LET IDENTIFICADOR PYC
    | CONST IDENTIFICADOR DP Tipo IGUAL Expresion PYC
    | CONST IDENTIFICADOR IGUAL Expresion PYC;

Expresion
    : ENTERO
    | DECIMAL
    | CADENA
    | IDENTIFICADOR;

Tipo
    : STRING
    | NUMBER
    | BOOLEAN
    | VOID;