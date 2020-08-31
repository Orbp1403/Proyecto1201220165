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
    const { Variable } = require('../Expresiones/Variable');
    const { DeclaracionTipos } = require('../Instrucciones/DeclaracionTipos');
    const { VariablesTipo } = require('../Expresiones/VariablesTipo');
%}

/* Asociación de operadores y precedencia */
%left '+' '-'
%left '*' '/'
%left NEGATIVO

%start ini

%% /* Definición de la gramática */

ini
	: Instrucciones EOF
    {
        return $1;
    };

Instrucciones
    : Instrucciones Instruccion
    {
        $1.push($2);
        $$ = $1
    }
    | Instruccion
    {
        $$ = [$1];
    };

Instruccion
    : Declaracion PYC
    {
        $$ = $1;
    }
    | Declaracion_type
    {
        $$ = $1;
    }
    | Llamada
    | Asignacion;

Asignacion
    : IDENTIFICADOR Listaatributos '=' Expresion PYC
    | IDENTIFICADOR '=' Expresion PYC;

Declaracion_type
    : TYPE IDENTIFICADOR '=' '{' Latributostype '}'
    {
        $$ = new DeclaracionTipos($2, $5, @1.first_line, @1.first_column)
    };

Latributostype
    : Latributostype IDENTIFICADOR DP TipoatributosType ','
    {
        $1.push(new VariablesTipo($2, $4, @1.first_line, @1.first_column))
        $$ = $1;
    }
    | Latributostype IDENTIFICADOR DP TipoatributosType PYC
    {
        $1.push(new VariablesTipo($2, $4, @1.first_line, @1.first_column))
        $$ = $1;
    }
    | Latributostype IDENTIFICADOR DP TipoatributosType
    {
        $1.push(new VariablesTipo($2, $4, @1.first_line, @1.first_column));
        $$ = $1;
    }
    | IDENTIFICADOR DP TipoatributosType ','
    {
        $$ = [new VariablesTipo($1, $3, @1.first_line, @1.first_column)];
    }
    | IDENTIFICADOR DP TipoatributosType PYC
    {
        $$ = [new VariablesTipo($1, $3, @1.first_line, @1.first_column)];
    }
    | IDENTIFICADOR DP TipoatributosType
    {
        $$ = [new VariablesTipo($1, $3, @1.first_line, @1.first_column)];
    };

TipoatributosType
    : Tipo
    {
        $$ = $1;
    }
    | IDENTIFICADOR
    {
        $$ = $1
    };


Declaracion
    : LET IDENTIFICADOR DP Tipo '=' Expresion
    {
        $$ = new Declaracion($2, $6, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column);
    }
    | LET IDENTIFICADOR '=' Expresion
    {
        $$ = new Declaracion($2, $4, null, TiposSimbolo.VAR, @1.first_line, @1.first_column);
    }
    | LET IDENTIFICADOR DP Tipo
    {
        $$ = new Declaracion($2, null, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column);
    }
    | LET IDENTIFICADOR
    {
        $$ = new Declaracion($2, null, null, TiposSimbolo.VAR, @1.first_line, @1.first_column);
    }
    | LET IDENTIFICADOR DP Tipo Lcorchetes '=' LArray
    | LET IDENTIFICADOR DP '=' LArray
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}'
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR
    | CONST IDENTIFICADOR DP Tipo '=' Expresion
    {
        $$ = new Declaracion($2, $6, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column);
    }
    | CONST IDENTIFICADOR '=' Expresion
    {
        $$ = new Declaracion($2, $4, null, TiposSimbolo.CONST, @1.first_line, @1.first_column);
    }
    | CONST IDENTIFICADOR DP Tipo Lcorchetes '=' LArray
    | CONST IDENTIFICADOR '=' LArray
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}'
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR;

Lcorchetes 
    : Lcorchetes '[' ']'        
    | '[' ']';

Lvalorestype
    : Lvalorestype IDENTIFICADOR DP Expresion ',' 
    | Lvalorestype IDENTIFICADOR DP Expresion 
    | IDENTIFICADOR DP Expresion ','
    | IDENTIFICADOR DP Expresion;

Array
    : '[' Lvalores ']'
    | '[' ']';

Lvalores
    : Lvalores ',' Expresion
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
    {
        $$ = new Variable($1, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR Listaatributos
    | Llamada
    | NULL
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 3)
    };

Listaatributos
    : Listaatributos '.' IDENTIFICADOR 
    | '.' IDENTIFICADOR;

Llamada
    : IDENTIFICADOR '(' ')'
    | IDENTIFICADOR '(' Listaparam ')';

Listaparam
    : Listaparam ',' Expresion 
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