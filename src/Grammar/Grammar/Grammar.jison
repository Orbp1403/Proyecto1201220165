/* Definición Léxica */
%lex

%options case-sensitive
numero [0-9]+("."[0-9]+)?
cadena (\"[^\"]*\")|("`"[^"`"]*"`")

%%

/* Espacios en blanco */
[ \r\t]+                                {}
\n                                      {}
"//".*                                  {}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]     {} 

{numero}                                return 'NUMERO'
{cadena}                                return 'CADENA'

"let"                                   return 'LET'
"const"                                 return 'CONST'
"string"                                return 'STRING'
"number"                                return 'NUMBER'
"boolean"                               return 'BOOLEAN'
"void"                                  return 'VOID'
"type"                                  return 'TYPE'
"null"                                  return 'NULL'
"true"                                  return 'TRUE'
"false"                                 return 'FALSE'

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

%{
    const { Aritmeticas } = require('../Expresiones/Aritmeticas');
    const { OpcionesAritmeticas } = require('../Expresiones/Opcionesaritmeticas');
    const { Literal } = require('../Expresiones/Literal');
    const { TiposSimbolo, Simbolo } = require('../Entorno/Simbolo');
    const { Declaracion } = require('../Instrucciones/Declaracion');
    const { Type } = require('../Retorno'); 
%}

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
    : Declaracion PYC
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
    : LET IDENTIFICADOR DP Tipo '=' Expresion
    {
        console.log($2);
        console.log($4);
        console.log($6);
    }
    | LET IDENTIFICADOR '=' Expresion
    {
        console.log($2);
        console.log($4);
    }
    | LET IDENTIFICADOR DP Tipo
    {
        console.log($2);
        console.log($4);
    }
    | LET IDENTIFICADOR
    {
        console.log($2);
    }
    | LET IDENTIFICADOR DP Tipo Lcorchetes '=' LArray
    | LET IDENTIFICADOR DP '=' LArray
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}'
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR
    | CONST IDENTIFICADOR DP Tipo '=' Expresion
    {
        console.log($2);
        console.log($4);
        console.log($6);
    }
    | CONST IDENTIFICADOR '=' Expresion
    {
        console.log($2);
        console.log($4);
    }
    | CONST IDENTIFICADOR DP Tipo Lcorchetes '=' LArray
    | CONST IDENTIFICADOR '=' LArray
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}'
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR;

Lcorchetes 
    : '[' ']' Lcorchetes        
    | '[' ']';

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
    {
        let val1 = new Literal("-1", @1.first_line, @1.first_column, 0);
        $$ = new Aritmeticas(val1, $2, OpcionesAritmeticas.POR, @1.first_line, @1.first_column);
    }
    | Expresion '+' Expresion
    {
        $$ = new Aritmeticas($1, $3, OpcionesAritmeticas.MAS, @1.first_line, @1.first_column);
    }
    | Expresion '-' Expresion
    {
        $$ = new Aritmeticas($1, $3, OpcionesAritmeticas.MENOS, @1.first_line, @1.first_column);
    }
    | Expresion '*' Expresion
    {
        $$ = new Aritmeticas($1, $3, OpcionesAritmeticas.POR, @1.first_line, @1.first_column);
    }
    | Expresion '/' Expresion
    {
        $$ = new Aritmeticas($1, $3, OpcionesAritmeticas.DIV, @1.first_line, @1.first_column);
    }
    | NUMERO
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 0);
    }
    | CADENA
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 1);
    }
    | TRUE
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 2);
    }
    | FALSE
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 2);
    }
    | IDENTIFICADOR
    | IDENTIFICADOR Listaatributos
    | Llamada
    | NULL
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 3)
    };

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
    {
        $$ = Type.CADENA;
    }
    | NUMBER
    {
        $$ = Type.NUMERO;
    }
    | BOOLEAN
    {
        $$ = Type.BOOLEANO
    }
    | VOID
    {
        $$ = Type.VOID;
    };