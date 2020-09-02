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
"if"                                    return 'IF'
"else"                                  return 'ELSE'
"switch"                                return 'SWITCH'
"case"                                  return 'CASE'
"while"                                 return 'WHILE'
"do"                                    return 'DO'
"for"                                   return 'FOR'
"in"                                    return 'IN'
"of"                                    return 'OF'
"break"                                 return 'BREAK'
"continue"                              return 'CONTINUE'
"return"                                return 'RETURN'
"function"                              return 'FUNCTION'
"console"                               return 'CONSOLE'
"log"                                   return 'LOG'
"graficar_ts"                           return 'GRAFICAR_TS'


":"                                     return 'DP'
";"                                     return 'PYC'
"&&"                                    return 'AND'
"||"                                    return 'OR'
"!"                                     return 'NOT'
"%"                                     return '%'
"**"                                    return '**'
"<="                                    return '<='
">="                                    return '>='
'=='                                    return '=='
'!='                                    return '!='
'<'                                     return '<'
'>'                                     return '>'
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
    const { VariablesTipo, ValoresTipo } = require('../Expresiones/VariablesTipo');
    const { Asignacion } = require('../Instrucciones/Asignacion');
    const { DeclaracionVarType } = require('../Instrucciones/DeclaracionVarType');
    const { AsignacionVarType } = require('../Instrucciones/AsignacionVarType');
    const { Llamada } = require('../Instrucciones/Llamada');
    const { Relacional, OperacionesLogicas } = require('../Expresiones/Relacional');
    const { Imprimir } = require('../Instrucciones/Imprimir');
%}

/* Asociación de operadores y precedencia */
%left 'OR'
%left 'AND'
%left '==' '!='
%left '>=' '<=' '<' '>'
%left NOT
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
    | Declaracion_type PYC
    {
        $$ = $1;
    }
    | Llamada PYC
    {
        $$ = $1;
    }
    | Asignacion
    {
        $$ = $1;
    };

Asignacion
    : IDENTIFICADOR Listaatributos '=' Expresion PYC
    | IDENTIFICADOR '=' '{' Lvalorestype '}' PYC
    {
        $$ = new AsignacionVarType($1, $4, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '=' Expresion PYC
    {
        $$ = new Asignacion($1, $3, @1.first_line, @1.first_column);
    };

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
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}'
    {
        $$ = new DeclaracionVarType($2, $7, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column);
    }
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR
    {
        $$ = new Declaracion($2, $6, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column);
    }
    | LET IDENTIFICADOR DP IDENTIFICADOR
    {
        $$ = new Declaracion($2, null, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column);
    }
    | CONST IDENTIFICADOR DP Tipo '=' Expresion
    {
        $$ = new Declaracion($2, $6, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column);
    }
    | CONST IDENTIFICADOR '=' Expresion
    {
        $$ = new Declaracion($2, $4, null, TiposSimbolo.CONST, @1.first_line, @1.first_column);
    }
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}'
    {
        $$ = new DeclaracionVarType($1, $7, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column);
    }
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR
    {
        $$ = new Declaracion($2, $6, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column);
    };

Lvalorestype
    : Lvalorestype IDENTIFICADOR DP Expresion ',' 
    {
        $1.push(new ValoresTipo($2, $4, @1.first_line, @1.first_column));
        $$ = $1;
    }
    | Lvalorestype IDENTIFICADOR DP Expresion
    {
        $1.push(new ValoresTipo($2, $4, @1.first_line, @1.first_column));
        $$ = $1;
    } 
    | IDENTIFICADOR DP Expresion ','
    {
        $$ = [new ValoresTipo($1, $3, @1.first_line, @1.first_column)];
    }
    | IDENTIFICADOR DP Expresion
    {
        $$ = [new ValoresTipo($1, $3, @1.first_line, @1.first_column)];
    };

Expresion
    : 'NOT' Expresion
    {
        $$ = new Relacional($2, null, OperacionesLogicas.NEGADO, @1.first_line, @1.first_column);
    }
    | Expresion 'AND' Expresion
    {
        $$ = new Relacional($1, $3, OperacionesLogicas.AND, @1.first_line, @1.first_column);
    }
    | Expresion 'OR' Expresion
    {
        $$ = new Relacional($1, $3, OperacionesLogicas.OR, @1.first_line, @1.first_column);
    }
    | Expresion '==' Expresion
    {
        $$ = new Relacional($1, $3, OperacionesLogicas.IGUAL, @1.first_line, @1.first_column);
    }
    | Expresion '!=' Expresion
    {
        $$ = new Relacional($1, $3, OperacionesLogicas.NOIGUAL, @1.first_line, @1.first_column);
    }
    | Expresion '<' Expresion
    {
        $$ = new Relacional($1, $3, OperacionesLogicas.MENOR, @1.first_line, @1.first_column);
    }
    | Expresion '>' Expresion
    {
        $$ = new Relacional($1, $3, OperacionesLogicas.MAYOR, @1.first_line, @1.first_column);
    }
    | Expresion '<=' Expresion
    {
        $$ = new Relacional($1, $3, OperacionesLogicas.MENORIGUAL, @1.first_line, @1.first_column);
    }
    | Expresion '>=' Expresion
    {
        $$ = new Relacional($1, $3, OperacionesLogicas.MAYORIGUAL, @1.first_line, @1.first_column);
    }
    |'-' Expresion %prec NEGATIVO
    {
        $$ = new Aritmeticas($2, null, OpcionesAritmeticas.NEGATIVO, @1.first_line, @1.first_column);
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
    | '(' Expresion ')'
    {
        $$ = $2;
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
    {
        let a = $1
        a.concat("." + $2);
        $$ = new Variable($1, @1.first_line, @1.first_column);
    }
    | Llamada
    {
        $$ = $1;
    }
    | NULL
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 3)
    };

Listaatributos
    : Listaatributos '.' IDENTIFICADOR 
    {
        let aux = $1;
        aux.concat("." + $3);
        $$ = aux;
    }
    | '.' IDENTIFICADOR
    {
        let p = ".";
        p.concat($2);
        $$ = p;
    };

Llamada
    : IDENTIFICADOR '(' ')'
    {
        $$ = new Llamada($1, [], @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '(' Listaparam ')'
    {
        $$ = new Llamada($1, $3, @1.first_line, @1.first_column);
    }
    | 'CONSOLE' '.' 'LOG' '(' ')'
    {
        $$ = new Imprimir([], @1.first_line, @1.first_column);
    }
    | 'CONSOLE' '.' 'LOG' '(' Listaparam ')'
    {
        $$ = new Imprimir($5, @1.first_line, @1.first_column);
    };

Listaparam
    : Listaparam ',' Expresion 
    {
        $1.push($3)
        $$ = $1;
    }
    | Expresion{
        $$ = [$1];
    };

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