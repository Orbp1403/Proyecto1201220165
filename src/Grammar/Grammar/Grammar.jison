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
"type"                                  return 'TYPE'
"null"                                  return 'NULL'

":"                                     return 'DP'
";"                                     return 'PYC'
"="                                     return '='
"+"                                     return '+'
"-"                                     return '-'
"*"                                     return '*'
"/"                                     return '/'
"."                                     return '.'
"("                                     return '('
")"                                     return ')'
","                                     return ','
"{"                                     return '{'
"}"                                     return '}'
":"                                     return ':'

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
    : Declaracion
    | Declaracion_type
    | Llamada
    | Asignacion;

Asignacion
    : IDENTIFICADOR Listaatributos '=' Expresion PYC
    | IDENTIFICADOR '=' Expresion PYC;

Declaracion_type
    : TYPE IDENTIFICADOR '=' '{' Latributostype '}';

Latributostype
    : IDENTIFICADOR DP Tipo ',' Latributostype
    | IDENTIFICADOR DP Tipo PYC Latributostype
    | IDENTIFICADOR DP Tipo Latributostype
    | IDENTIFICADOR DP Tipo ','
    | IDENTIFICADOR DP Tipo PYC
    | IDENTIFICADOR DP Tipo;

Declaracion
    : LET IDENTIFICADOR DP Tipo '=' Expresion PYC
    | LET IDENTIFICADOR '=' Expresion PYC
    | LET IDENTIFICADOR DP Tipo PYC
    | LET IDENTIFICADOR PYC
    | LET IDENTIFICADOR DP Tipo '=' Array PYC
    | LET IDENTIFICADOR DP '=' Array PYC
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}' PYC
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR PYC
    | CONST IDENTIFICADOR DP Tipo '=' Expresion PYC
    | CONST IDENTIFICADOR '=' Expresion PYC
    | CONST IDENTIFICADOR DP Tipo '=' Array PYC
    | CONST IDENTIFICADOR '=' Array PYC
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}' PYC
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR PYC;

Lvalorestype
    : IDENTIFICADOR DP Expresion',' Lvalorestype
    | IDENTIFICADOR DP Expresion Lvalorestype
    | IDENTIFICADOR DP Expresion ','
    | IDENTIFICADOR DP Expresion;

Array
    : '[' Lvalores ']'
    | '[' ']';

Lvalores
    : Expresion ',' Lvalores
    | Expresion;


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
    | IDENTIFICADOR Listaatributos
    | Llamada
    | NULL;

Listaatributos
    : '.' IDENTIFICADOR Listaatributos
    | '.' IDENTIFICADOR;

Llamada
    : IDENTIFICADOR '(' ')'
    | IDENTIFICADOR '(' Listaparam ')';

Listaparam
    : Expresion ',' Listaparam
    | Expresion;

Tipo
    : STRING
    | NUMBER
    | BOOLEAN
    | VOID;