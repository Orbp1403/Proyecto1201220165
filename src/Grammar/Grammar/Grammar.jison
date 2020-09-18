%{ let hermano = null; 
    let instruccion, nodo = null;%}
/* Definición Léxica */
%lex

%options case-sensitive
numero [0-9]+("."[0-9]+)?
cadena (\"[^\"]*\")|("`"[^"`"]*"`")|("'" [^"'"]* "'")

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
"default"                               return 'DEFAULT'

"++"                                    return '++'
"--"                                    return '--'
"+="                                    return '+='
"-="                                    return '-='
"*="                                    return '*='
"/="                                    return '/='
"%="                                    return '%='
'**='                                   return '**='
":"                                     return 'DP'
";"                                     return 'PYC'
"&&"                                    return 'AND'
"||"                                    return 'OR'
'=='                                    return '=='
'!='                                    return '!='
"!"                                     return 'NOT'
"%"                                     return '%'
"**"                                    return '**'
"<="                                    return '<='
">="                                    return '>='
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
"?"                                     return '?'
"["                                     return '['
"]"                                     return ']'

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
    const { SentenciaIf } = require('../Instrucciones/SentenciaIf');
    const { Cuerposentencia } = require('../Instrucciones/Cuerposentencia');
    const { Caso } = require('../Instrucciones/Caso');
    const { CasoDef } = require('../Instrucciones/CasoDef');
    const { SentenciaSwitch } = require('../Instrucciones/SentenciaSwitch');
    const { SentenciaWhile } = require('../Instrucciones/SentenciaWhile');
    const { SentenciaDowhile } = require('../Instrucciones/SentenciaDowhile');
    const { Incremento } = require('../Instrucciones/Incremento');
    const { SentenciaFor } = require('../Instrucciones/SentenciaFor');
    const { Funcion } = require('../Instrucciones/Funcion');
    const { SentenciaTernaria } = require('../Instrucciones/SentenciaTernaria');
    const { SentenciaReturn } = require('../Instrucciones/SentenciaReturn');
    const { Break } = require('../Instrucciones/Break');
    const { GraficarTs } = require('../Instrucciones/GraficarTs');
    const { Nodo } = require('../Arbol/Nodo');
%}

/* Asociación de operadores y precedencia */
%right '+=' '-=' '*=' '/=' '%=' '**='
%right '?' 'DP'
%left 'OR'
%left 'AND'
%left '==' '!='
%left '>=' '<=' '<' '>'
%left '-'
%left '+'
%left '%'
%left '/'
%left '*'
%left '**'
%left NEGATIVO
%left NOT
%nonassoc '--'
%nonassoc '++'

%start ini

%% /* Definición de la gramática */

ini
	: Instrucciones EOF
    {

        $$ = {
            instrucciones : $1,
            nodo : new Nodo(null, "INICIO", null, null)
        }
        $$.nodo.addHijos(new Nodo(null, "INSTRUCCIONES", $$.nodo, $1.nodo))
        return $$;
    };

Instrucciones
    : Instrucciones Instruccion
    {
        $1.instrucciones.push($2.instrucciones)
        $1.nodo.push($2.nodo)
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : $1.nodo
        }
    }
    | Instruccion
    {
        $$ = {
            instrucciones : [$1.instrucciones],
            nodo : [$1.nodo]
        };
    };

Instruccion
    : Declaracion PYC
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1,
            nodo : new Nodo(null, "DECLARACION", null, null)
        }
    }
    | Declaracion_type PYC
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1,
            nodo : new Nodo(null, "DECLARACION_TYPE", null, null)
        }
    }
    | Expresion PYC
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1,
            nodo : new Nodo(null, "EXPRESION", null, null)
        }
    }
    | Asignacion
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1,
            nodo : new Nodo(null, "ASIGNACION", null, null)
        }
    }
    | Sentencias_control
    {
        //$$ = $1
        $$ = {
            instrucciones : $1,
            nodo : new Nodo(null, "SENTENCIAS_CONTROL", null, null)
        }
    }
    | Funcion
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1,
            nodo : new Nodo(null, "FUNCION", null, null)
        }
    };

Sentencias_control
    : Sentenciaif
    {
        $$ = $1;
    }
    | Sentenciaswitch
    {
        $$ = $1;
    }
    | Sentenciawhile
    {
        $$ = $1;
    }
    | Sentenciadowhile
    {
        $$ = $1;
    }
    | Sentenciafor
    {
        $$ = $1;
    }
    | 'BREAK' PYC
    {
        $$ = new Break(@1.first_line, @1.first_column);
    }
    | 'RETURN' PYC
    {
        $$ = new Return(null, @1.first_line, @1.first_column);
    }
    | 'RETURN' Expresion PYC
    {
        $$ = new Return(Expresion, @1.first_line, @1.first_column);
    };

SentenciaTernaria
    : Expresion '?' Expresion DP Expresion
    {
        $$ = new SentenciaTernaria($1, $3, $4, @1.first_line, @1.first_column);
    };

Sentenciafor
    : 'FOR' '(' 'LET' IDENTIFICADOR '=' Expresion PYC Expresion PYC Aumento ')' InstruccionesSentencias
    {
        $$ = new SentenciaFor($4, $6, $8, $10, $12, @1.first_line, @1.first_column);
    }
    | 'FOR' '(' IDENTIFICADOR '=' Expresion PYC Expresion PYC Aumento ')' InstruccionesSentencias
    {
        $$ = new SentenciaFor($3, $5, $7, $9, $11, @1.first_line, @1.first_column);
    };

Aumento
    : IDENTIFICADOR '++'
    {
        $$ = new Incremento($1, OpcionesAritmeticas.MAS, new Literal(1, @1.first_line, @1.first_column, 0), @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '--'
    {
        $$ = new Incremento($1, OpcionesAritmeticas.MENOS, new Literal(1, @1.first_line, @1.first_column, 0), @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '+=' Expresion
    {
        $$ = new Incremento($1, OpcionesAritmeticas.MAS, $3, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '-=' Expresion
    {
        $$ = new Incremento($1, OpcionesAritmeticas.MENOS, $3, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '*=' Expresion
    {
        $$ = new Incremento($1, OpcionesAritmeticas.POR, $3, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '/=' Expresion{
        $$ = new Incremento($1, OpcionesAritmeticas.DIV, $3, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '%=' Expresion{
        $$ = new Incremento($1, OpcionesAritmeticas.MODULO, $3, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '**=' Expresion{
        $$ = new Incremento($1, OpcionesAritmeticas.POTENCIA, $3, @1.first_line, @1.first_column)
    };

Sentenciadowhile
    : 'DO' InstruccionesSentencias 'WHILE' '(' Expresion ')'
    {
        $$ = new SentenciaDowhile($5, $2, @1.first_line, @1.first_column);
    };

Sentenciawhile
    :'WHILE' '(' Expresion ')' InstruccionesSentencias
    {
        $$ = new SentenciaWhile($3, $5, @1.first_line, @1.first_column);
    };

Sentenciaswitch
    : 'SWITCH' '(' Expresion ')' '{' Casos '}'
    {
        $$ = new SentenciaSwitch($3, $6, @1.first_line, @1.first_column);
    }
    | 'SWITCH' '(' Expresion ')' '{' '}'
    {
        $$ = new SentenciaSwitch($3, null, @1.first_line, @1.first_column);
    };

Casos
    : Casos 'CASE' Expresion DP InstruccionSentencia
    {
        $1.push(new Caso($3, $5, @1.first_line, @1.first_column));
        $$ = $1;
    }
    | Casos 'CASE' Expresion DP
    {
        $1.push(new Caso($4, null, @1.first_line, @1.first_column));
        $$ = $1
    }
    | Casos 'DEFAULT' DP InstruccionSentencia
    {
        $1.push(new CasoDef($4, @1.first_line, @1.first_column));
        $$ = $1;
    }
    | Casos 'DEFAULT' DP
    {
        $1.push(new CasoDef(null, @1.first_line, @1.first_column));
        $$ = $1;
    }
    | 'CASE' Expresion DP InstruccionSentencia
    {
        $$ = [new Caso($2, $4, @1.first_line, @1.first_column)];
    }
    | 'CASE' Expresion DP
    {
        $$ = [new Caso($2, null, @1.first_line, @1.first_column)];
    }
    | 'DEFAULT' 
    {
        $$ = [new CasoDef(null, @1.first_line, @1.first_column)];
    };

Sentenciaif
    : 'IF' '(' Expresion ')' InstruccionesSentencias
    {
        $$ = new SentenciaIf($3, $5, null, @1.first_line, @1.first_column);
    }
    | 'IF' '(' Expresion ')' InstruccionesSentencias SentenciaElse
    {
        $$ = new SentenciaIf($3, $5, $6, @1.first_line, @1.first_column);
    };

SentenciaElse
    : 'ELSE' Sentenciaif
    {
        $$ = $2;
    }
    | 'ELSE' InstruccionesSentencias
    {
        $$ = $2;
    };

InstruccionesSentencias
    : '{' InstruccionSentencia '}'
    {
        $$ = new Cuerposentencia($2, @1.first_line, @1.first_column);
    }
    | '{' '}'
    {
        $$ = new Cuerposentencia(new Array(), @1.first_line, @1.first_column);
    };

InstruccionSentencia
    : InstruccionSentencia Declaracion PYC
    {
        $1.push($2);
        $$ = $1;
    }
    | InstruccionSentencia Asignacion
    {
        $1.push($2);
        $$ = $1;
    }
    | InstruccionSentencia Sentencias_control
    {
        $1.push($2)
        $$ = $1
    }
    | InstruccionSentencia Expresion PYC
    {
        $1.push($2)
        $$ = $1;
    }
    | Declaracion PYC
    {
        $$ = [$1]
    }
    | Expresion PYC
    {
        $$ = [$1];
    }
    | Asignacion
    {
        $$ = [$1]
    }
    | Sentencias_control
    {
        $$ = [$1]
    };

Asignacion
    : IDENTIFICADOR Listaatributos '=' Expresion PYC
    {
        $$ = new Asignacion($1, $2, $4, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR Listaatributos '=' '{' Lvalorestype '}' PYC
    {
        $$ = new AsignacionVarType($1, $2, $5, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '=' '{' Lvalorestype '}' PYC
    {
        $$ = new AsignacionVarType($1, null, $4, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '=' Expresion PYC
    {
        $$ = new Asignacion($1, null, $3, @1.first_line, @1.first_column);
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
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' Expresion
    {
        $$ = new DeclaracionVarType($2, $6, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column);
    }
    | LET IDENTIFICADOR DP IDENTIFICADOR
    {
        $$ = new DeclaracionVarType($2, null, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column);
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
        $$ = new DeclaracionVarType($2, $7, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column);
    }
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR
    {
        $$ = new DeclaracionVarType($2, $6, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column);
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
    | Expresion '%' Expresion
    {
        $$ = new Aritmeticas($1, $3, OpcionesAritmeticas.MODULO, @1.first_line, @1.first_column);
    }
    | Expresion '**' Expresion
    {
        $$ = new Aritmeticas($1, $3, OpcionesAritmeticas.POTENCIA, @1.first_line, @1.first_column);
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
        $$ = new Variable($1, null, 7, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR Listaatributos
    {
        let a = $1
        a.concat("." + $2);
        $$ = new Variable($1, $2, 7, @1.first_line, @1.first_column);
    }
    | Llamada
    {
        $$ = $1;
    }
    | NULL
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 3)
    }
    | Aumento
    {
        $$ = $1
    }
    | SentenciaTernaria
    {
        $$ = $1
    };

Listaatributos
    : Listaatributos '.' IDENTIFICADOR 
    {
        $1.push($3);
        $$ = $1;
    }
    | '.' IDENTIFICADOR
    {
        $$ = [$2];
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
    }
    | 'GRAFICAR_TS' '(' ')';

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

// * inicia la gramatica de las funciones:

Funcion 
    : FUNCTION IDENTIFICADOR '(' Funcion1
    {
        $$ = new Funcion($3, $4.instrucciones, $4.parametros, $4.tipo, @1.first_line, @1.first_column);
    };

Funcion1
    : Lparametrosfuncion ')' DP Tipofuncion InstruccionesFuncion
    {
        $$ = {
            parametros : $1,
            tipo : $4,
            instrucciones : $5
        }
    }
    | ')' DP Tipofuncion InstruccionesFuncion
    {
        $$ = {
            parametros : null,
            tipo : $3,
            instrucciones : $4
        }
    };

Tipofuncion
    : Tipo
    | IDENTIFICADOR;

InstruccionesFuncion
    : '{' InstruccionesFuncion1
    {
        $$ = $2;
    };

InstruccionesFuncion1
    : Linstrucciones '}'
    {
        $$ = $1;
    }
    | '}'
    {
        $$ = null;
    };

Linstrucciones 
    : Instruccionfuncion Linstrucciones1
    {
        $$ = $2;
    };

Linstrucciones1
    : Linstrucciones
    {
        hermano = eval('$$');
        hermano[hermano.length - 1].unshift(hermano[hermano.length - 2]);
        $$ = hermano[hermano.length - 1];
    }
    | 
    {
        hermano = eval('$$');
        $$ = [hermano[hermano.length - 1]];
    };

Instruccionfuncion
    : Expresionesfuncion Instruccionfuncion1 PYC
    {
        hermano = eval('$$');
        if(hermano[hermano.length - 2] == null){
            $$ = hermano[hermano.length-3];
        }else{
            $$ = hermano[hermano.length - 2];
        }
    }
    | Llamadas_funcion PYC
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length - 2];
    }
    | LET IDENTIFICADOR Auxdeclaracion
    {
        if($3.estype == false){
            if($3.valor == null && $3.tipo == null)
            {
                $$ = new Declaracion($2, null, null, TiposSimbolo.VAR, @1.first_line, @1.first_column);
            }
            else if($3.valor == null && $3.tipo != null)
            {
                $$ = new Declaracion($2, null, $3.tipo, TiposSimbolo.VAR, @1.first_line, @1.first_column);
            }
            else if($3.valor != null && $3.tipo != null)
            {
                $$ = new Declaracion($2, $3.valor, $3.tipo, TiposSimbolo.VAR, @1.first_line, @1.first_column);
            }
            else if($3.valor != null && $3.tipo == null)
            {
                $$ = new Declaracion($2, $3.valor, null, TiposSimbolo.VAR, @1.first_line, @1.first_column);
            }
        }
        else
        {
            if($3.valor == null && $3.tipo != null)
            {
                $$ = new DeclaracionVarType($2, null, $3.tipo, TiposSimbolo.VAR, @1.first_line, @1.first_column);
            }
            else if($3.valor != null && $3.tipo != null)
            {
                $$ = new DeclaracionVarType($2, $3.valor, $3.tipo, TiposSimbolo.VAR, @1.first_line, @1.first_column);
            }
        }
    }
    | CONST IDENTIFICADOR Auxdeclaracion4
    {
        if($3.estype == false)
        {
            if($3.valor != null && $3.tipo == null)
            {
                $$ = new Declaracion($2, $3.valor, null, TiposSimbolo.CONST, @1.first_line, @1.first_column);
            }
            else
            {
                $$ = new Declaracion($2, $3.valor, $3.tipo, TiposSimbolo.CONST, @1.first_line, @1.first_column);
            }
        }
        else
        {
            $$ = new DeclaracionVarType($2, $3.valor, $3.tipo, TiposSimbolo.CONST, @1.first_line, @1.first_column);
        }
    }
    | sentencia_if
    {
        $$ = $1;
    }
    | sentencia_switch
    {
        $$ = $1;
    }
    | sentencia_while
    {
        $$ = $1;
    }
    | sentencia_dowhile
    {
        $$ = $1;
    }
    | sentencia_for
    {
        $$ = $1;
    }
    | sentencia_break
    {
        $$ = $1;
    }
    | Sentencia_return
    {
        $$ = $1;
    };

Auxdeclaracion4
    : DP Auxdeclaracion5
    {
        $$ = $2;
    }
    | '=' Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : false,
            valor : hermano[hermano.length - 2],
            tipo : null
        }
    };

Auxdeclaracion5
    : Tipo '=' Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : false,
            valor : hermano[hermano.length - 2],
            tipo : hermano[hermano.length - 4]
        }
    }
    | IDENTIFICADOR '=' Auxdeclaracion6
    {
        hermano = eval('$$');
        $$ = $3
    };

Auxdeclaracion
    : DP Auxdeclaracion1
    {
        $$ = $2
    }
    | PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : false,
            valor : null,
            tipo : null
        };
    }
    | '=' Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : false,
            valor : hermano[hermano.length - 2],
            tipo : null
        }
    };

Auxdeclaracion1
    : Tipo Auxdeclaracion2
    {
        $$ = $2;
    }
    | IDENTIFICADOR Auxdeclaracion3
    {
        $$ = $2;
    };

Auxdeclaracion2
    : PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : false,
            valor : null,
            tipo : hermano[hermano.length - 2]
        }
    }
    | '=' Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : false,
            valor : hermano[hermano.length - 2],
            tipo : hermano[hermano.length - 4]
        };
    };

Auxdeclaracion3
    : PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : true,
            valor : null,
            tipo : hermano[hermano.length - 2]
        }
    }
    | '=' Auxdeclaracion6
    {
        $$ = $2;
    };
    
Auxdeclaracion6
    : '{' ValoresType '}' PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : true,
            valor : hermano[hermano.length - 3],
            tipo : hermano[hermano.length - 6]
        }
    }
    | Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : true,
            valor : hermano[hermano.length - 2],
            tipo : hermano[hermano.length - 4]
        }
    };

Sentencia_return
    : RETURN Sentencia_return1
    {
        $$ = new SentenciaReturn($2.valor, @1.first_line, @1.first_column);
    };

Sentencia_return1
    : Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            valor : hermano[hermano.length - 2]
        };
    }
    | PYC
    {
        $$ = {
            valor : null
        }
    };

sentencia_break
    : BREAK PYC
    {
        $$ = new Break(@1.first_line, @1.first_column);
    };

sentencia_for
    : FOR '(' sentencia_for1
    {
        $$ = new SentenciaFor($3.id, $3.valor_inicio, $3.condicion, $3.incremento, $3.instrucciones, @1.first_line, @1.first_column);
    };

sentencia_for1
    : LET IDENTIFICADOR '=' Expresionesfuncion PYC Expresionesfuncion PYC Expresionesfuncion ')' InstruccionesFuncion
    {
        $$ = {
            id : $2,
            valor_inicio : $4,
            condicion : $6,
            incremento : $8,
            instrucciones : $10
        }
    }
    | Expresionesfuncion '=' Expresionesfuncion PYC Expresionesfuncion PYC Expresionesfuncion ')' InstruccionesFuncion
    {
        $$ = {
            id : $1,
            valor_inicio : $3,
            condicion : $5,
            incremento : $7,
            instrucciones : $9
        }
    };

sentencia_dowhile
    : DO InstruccionesFuncion WHILE '(' Expresionesfuncion ')' PYC
    {
        $$ = new SentenciaDowhile($5, $2, @1.first_line, @1.first_column)
    };

sentencia_while
    : WHILE '(' Expresionesfuncion ')' InstruccionesFuncion
    {
        $$ = new SentenciaWhile($3, $5, @1.first_line, @1.first_column);
    };

sentencia_switch
    : SWITCH '(' Expresionesfuncion ')' '{' Lcasosswitch
    {
        $$ = new SentenciaSwitch($3, $6, @1.first_line, @1.first_column);
    };

Lcasosswitch 
    : Lcasos '}'
    {
        $$ = $1;
    }
    | '}'
    {
        $$ = null;
    };

Lcasos
    : CASE Expresionesfuncion DP Lcasos1
    {
        hermano = eval('$$');
        if(hermano[hermano.length - 1].casos == null)
        {
            $$ = [new Caso($2, hermano[hermano.length - 1].instrucciones, @1.first_line, @1.first_column)];
        }
        else
        {
            hermano[hermano.length - 1].casos.unshift(new Caso($2, hermano[hermano.length - 1].instrucciones, @1.first_line, @1.first_column))
            $$ = hermano[hermano.length - 1].casos;
        }
    }
    | DEFAULT DP Lcasos1
    {
        hermano = eval('$$');
        if(hermano[hermano.length - 1].casos == null)
        {
            $$ = [new CasoDef(hermano[hermano.length - 1].instrucciones, @1.first_line, @1.first_column)];
        }
        else
        {
            hermano[hermano.length - 1].casos.unshift(new CasoDef(hermano[hermano.length - 1].instrucciones, @1.first_line, @1.first_column));
            $$ = hermano[hermano.length - 1].casos;
        }
    };

Lcasos1
    : Linstrucciones Lcasos2
    {
        hermano = eval('$$')
        $$ = {
            instrucciones: hermano[hermano.length - 2],
            casos : hermano[hermano.length - 1]
        }
    }
    | Lcasos
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : null,
            casos : hermano[hermano.length - 1]
        }
    }
    | 
    {
        $$ = {
            instrucciones : null,
            casos : null
        }
    };

Lcasos2
    : Lcasos
    {
        $$ = $1;
    }
    | 
    {
        $$ = null
    };

sentencia_if
    : IF '(' Expresionesfuncion ')' InstruccionesFuncion sentencia_else
    {
        $$ = new SentenciaIf($3, $5, $6, @1.first_line, @1.first_column);
    };

sentencia_else
    : ELSE sentencia_else1
    {
        $$ = $2;
    }
    | 
    {
        $$ = null;
    };

sentencia_else1
    : sentencia_if
    {
        $$ = $1;
    }
    | InstruccionesFuncion
    {
        $$ = $1;
    };

Instruccionfuncion1
    : '=' instruccionfuncion12
    {
        $$ = $2;
    }
    | {
        $$ = null;
    };

instruccionfuncion12
    : Expresionesfuncion
    {
        hermano = eval('$$');
        $$ = new Asignacion(hermano[hermano.length - 3].nombre, hermano[hermano.length - 3].atributos, hermano[hermano.length - 1], hermano[hermano.length - 3].linea, hermano[hermano.length - 3].columna);
    }
    | '{' ValoresType '}'
    {
        hermano = eval('$$');
        $$ = new AsignacionVarType(hermano[hermano.length - 5].nombre, hermano[hermano.length - 5].atributos, hermano[hermano.length - 2], hermano[hermano.length - 5].linea, hermano[hermano.length - 5].columna);
    };

AuxInstruccionfuncion1
    : '(' Instruccionfuncion2
    | Atributos
    | ;

Expresionesfuncion
    : Auxexpresionesfuncion Auxexpresionesfuncion1
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Auxexpresionesfuncion1 
    : '?' Auxexpresionesfuncion DP Auxexpresionesfuncion
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Auxexpresionesfuncion
    : Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion2
    : '+=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = new Incremento(hermano[hermano.length - 4], OpcionesAritmeticas.MAS, hermano[hermano.length - 1], hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '-=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = new Incremento(hermano[hermano.length - 4], OpcionesAritmeticas.MENOS, hermano[hermano.length - 1], hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '*=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = new Incremento(hermano[hermano.length - 4], OpcionesAritmeticas.POR, hermano[hermano.length - 1], hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '/=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$')
        $$ = new Incremento(hermano[hermano.length - 4], Opcionesaritmeticas.DIV, hermano[hermano.length - 1], hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '%=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = new Incremento(hermano[hermano.length - 4], OpcionesAritmeticas.MODULO, hermano[hermano.length - 1], hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '**=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = new Incremento(hermano[hermano.length - 4], OpcionesAritmeticas.POTENCIA, hermano[hermano.length-1], hermano[hermano.length - 4].linea, hermano[hermano.left - 4].columna);
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion1
    : Expresionesfuncion3 Expresionesfuncion4
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion4
    : OR Expresionesfuncion3 Expresionesfuncion4
    {
        hermano = eval('$$');
        $$ = new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.OR, hermano[hermano.length - 4].linea, hermano[hermano.left-4].columna);
    }
    | AND Expresionesfuncion3 Expresionesfuncion4
    {
        hermano = eval('$$');
        $$ = new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.AND, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion3
    : Expresionesfuncion5 Expresionesfuncion6
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion6
    : '==' Expresionesfuncion5 Expresionesfuncion6
    {
        hermano = eval('$$');
        $$ = new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.IGUAL, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '!=' Expresionesfuncion5 Expresionesfuncion6
    {
        hermano = eval('$$');
        $$ = new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.NOIGUAL, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion5
    : Expresionesfuncion7 Expresionesfuncion8
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion8
    : '>=' Expresionesfuncion7 Expresionesfuncion8
    {
        hermano = eval('$$');
        $$ = new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.MAYORIGUAL, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna)
    }
    | '<=' Expresionesfuncion7 Expresionesfuncion8
    {
        hermano = eval('$$');
        $$ = new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.MENORIGUAL, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna)
    }
    | '<' Expresionesfuncion7 Expresionesfuncion8
    {
        hermano = eval('$$');
        $$ = new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.MENOR, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna)
    }
    | '>' Expresionesfuncion7 Expresionesfuncion8
    {
        hermano = eval('$$');
        $$ = new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.MAYOR, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna)
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion7
    : Expresionesfuncion9 Expresionesfuncion10
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion10
    : '-' Expresionesfuncion9 Expresionesfuncion10
    {
        hermano = eval('$$');
        $$ = new Aritmeticas(hermano[hermano.length - 4], hermano[hermano.length - 1], OpcionesAritmeticas.MENOS, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '+' Expresionesfuncion9 Expresionesfuncion10
    {
        hermano = eval('$$');
        $$ = new Aritmeticas(hermano[hermano.length - 4], hermano[hermano.length - 1], OpcionesAritmeticas.MAS, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion9
    : Expresionesfuncion11 Expresionesfuncion12
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion12
    : '%' Expresionesfuncion11 Expresionesfuncion12
    {
        hermano = eval('$$');
        $$ = new Aritmeticas(hermano[hermano.length - 4], hermano[hermano.length - 1], OpcionesAritmeticas.MODULO, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '/' Expresionesfuncion11 Expresionesfuncion12
    {
        hermano = eval('$$');
        $$ = new Aritmeticas(hermano[hermano.length - 4], hermano[hermano.length - 1], OpcionesAritmeticas.DIV, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | '*' Expresionesfuncion11 Expresionesfuncion12
    {
        hermano = eval('$$');
        $$ = new Aritmeticas(hermano[hermano.length - 4], hermano[hermano.length - 1], OpcionesAritmeticas.POR, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion11
    : Expresionesfuncion13 Expresionesfuncion14
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion14
    : '**' Expresionesfuncion13 Expresionesfuncion14
    {
        hermano = eval('$$');
        $$ = new Aritmeticas(hermano[hermano.length - 4], hermano[hermano.length - 1], OpcionesAritmeticas.POTENCIA, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna);
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion13
    : NOT Expresionesfuncion13
    {
        $$ = new Relacional($2, null, OperacionesLogicas.NEGADO, @1.first_line, @1.first_column);
    }
    | '-' Expresionesfuncion13
    {
        $$ = new Aritmeticas($2, null, OpcionesAritmeticas.NEGATIVO, @1.first_line, @1.first_column);
    }
    | Expresionesfuncion15
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion15
    : Expresionesfuncion16 Expresionesfuncion17
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion17
    : '++'
    {
        hermano = eval('$$');
        if(hermano[hermano.length-2].tipo == 7){
            $$ = new Incremento(hermano[hermano.length-2].nombre, OpcionesAritmeticas.MAS, new Literal(1, @1.first_line, @1.first_column, 0), hermano[hermano.length-2].linea, hermano[hermano.length-2].columna);
        }else{
            //TODO error
        }
    }
    | '--'
    {
        hermano = eval('$$');
        if(hermano[hermano.length-2].tipo == 7){
            $$ = new Incremento(hermano[hermano.length-2].nombre, OpcionesAritmeticas.MENOS, new Literal(1, @1.first_line, @1.first_column, 0), hermano[hermano.length-2].linea, hermano[hermano.length-2].columna);
        }else{
            //TODO error
        }
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion16
    : Expresionesfuncion18 Expresionesfuncion19
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion19
    : Atributos
    {
        hermano = eval('$$');
        if(hermano[hermano.length-2].tipo == 7){
            $$ = new Variable(hermano[hermano.length-2].nombre, hermano[hermano.length-1], 7, hermano[hermano.length-2].linea, hermano[hermano.length-2].columna);
        }else{
            //TODO error
        }
    }
    | '(' Instruccionfuncion2
    {
        hermano = eval('$$');
        if(hermano[hermano.length - 3].tipo == 7){
            $$ = new Llamada(hermano[hermano.length-3].nombre, hermano[hermano.length-1], hermano[hermano.length-3].linea, hermano[hermano.length-3].columna);
        }else{
            //TODO ERROR
        }
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion18
    : NUMERO
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 0);
    }
    | CADENA
    {
        if($1.includes('\"'))
        {
            $$ = new Literal($1.replace(/['"]+/g, ''), @1.first_line, @1.first_column, 1);
        }
        else if($1.includes("'"))
        {
            $$ = new Literal($1.replace(/["'"]+/g, ''), @1.first_line, @1.first_column);
        }
        else
        {
            $$ = new Literal($1, @1.first_line, @1.first_column);
        }
    }
    | IDENTIFICADOR
    {
        $$ = new Variable($1, null, 7, @1.first_line, @1.first_column);
    }
    | TRUE
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 2);
    }
    | FALSE
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 2);
    }
    | NULL
    {
        $$ = new Literal($1, @1.first_line, @1.first_column, 3);
    }
    | '(' Expresionesfuncion ')'
    {
        $$ = $2;
    };

Ternario
    : Expresionesfuncion '?' Ternario2;

Ternario2
    : Ternario3 DP Ternario3;

Ternario3
    : Llamadas_funcion
    | Expresionesfuncion;

Llamadas_funcion
    : CONSOLE '.' LOG '(' Instruccionfuncion2
    {
        hermano = eval('$$');
        $$ = new Imprimir(hermano[hermano.length-1], @1.first_line, @1.first_column);
    }
    | GRAFICAR_TS '(' ')'
    {
        $$ = new GraficarTs(@1.first_line, @1.first_column);
    };

Instruccionfuncion2
    : ')'
    {
        hermano = eval('$$');
        $$ = [];
    }
    | Parametrosllamada ')'
    {
        $$ = $1;
    };

Atributos
    : Atributo Atributos1
    {
        $$ = $2;
    };

Atributo
    : '.' IDENTIFICADOR
    {
        $$ = $2;
    };

Atributos1
    : Atributos
    {
        hermano = eval('$$');
        hermano[hermano.length-1].unshift(hermano[hermano.length - 2]);
        $$ = hermano[hermano.length-1];
    }
    | 
    {
        hermano = eval('$$');
        $$ = [hermano[hermano.length-1]];
    };

Parametrosllamada
    : Parametrollamada Parametrosllamada1
    {
        $$ = $2;
    };

Parametrollamada
    : Expresionesfuncion
    {
        $$ = $1;
    };

Parametrosllamada1
    : ',' Parametrosllamada
    {
        hermano = eval('$$');
        hermano[hermano.length-1].unshift(hermano[hermano.length - 3]);
        $$ = hermano[hermano.length-1];
    }
    | 
    {
        hermano = eval('$$');
        $$ = [hermano[hermano.length-1]];
    };

Instruccionfuncion3
    : '{' ValoresType '}'
    | Expresionesfuncion;

ValoresType
    : Valortype ValoresType1
    {
        $$ = $2;
    };

Valortype
    : IDENTIFICADOR DP Expresionesfuncion
    {
        $$ = new ValoresTipo($1, $3, @1.first_line, @1.first_column);
    };

ValoresType1
    : ',' ValoresType
    {
        hermano = eval('$$');
        hermano[hermano.length - 1].unshift(hermano[hermano.length -3]);
        $$ = hermano[hermano.length - 1];
    }
    | ValoresType
    {
        hermano = eval('$$');
        hermano[hermano.length - 1].unshift(hermano[hermano.length - 3]);
        $$ = hermano[hermano.length - 1];
    }
    | 
    {
        hermano = eval('$$');
        $$ = [hermano[hermano.length - 1]];
    };

Lparametrosfuncion
    : Parametro Auxparametros
    {
        $$ = $2
    };

Parametro
    : IDENTIFICADOR DP Tipo
    {
        $$ = new VariablesTipo($1, $3, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR DP IDENTIFICADOR
    {
        $$ = new VariablesTipo($1, $3, @1.first_line, @1.first_column);
    };

Auxparametros 
    : ',' Lparametrosfuncion
    {
        hermano = eval('$$');
        hermano[hermano.length - 1].unshift(hermano[hermano.length - 3]);
        $$ = hermano[hermano.length - 1];
    }
    | 
    {
        hermano = eval('$$');
        $$ = [hermano[hermano.length - 1]];
    };