%{ let hermano = null; %}
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
    | Expresion PYC
    {
        $$ = $1;
    }
    | Asignacion
    {
        $$ = $1;
    }
    | Sentencias_control
    {
        $$ = $1
    }
    | Funcion
    {
        $$ = $1;
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
        console.log($2);
        $$ = new Asignacion($1, $2, $4, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR '=' '{' Lvalorestype '}' PYC
    {
        $$ = new AsignacionVarType($1, $4, @1.first_line, @1.first_column);
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
        $$ = new Variable($1, null, @1.first_line, @1.first_column);
    }
    | IDENTIFICADOR Listaatributos
    {
        let a = $1
        a.concat("." + $2);
        $$ = new Variable($1, $2, @1.first_line, @1.first_column);
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
    : FUNCTION IDENTIFICADOR '(' Funcion1;

Funcion1
    : Lparametrosfuncion ')' DP Tipofuncion InstruccionesFuncion
    | ')' DP Tipofuncion InstruccionesFuncion;

Tipofuncion
    : Tipo
    | IDENTIFICADOR;

InstruccionesFuncion
    : '{' InstruccionesFuncion1;

InstruccionesFuncion1
    : Linstrucciones '}'
    | '}';

Linstrucciones 
    : Instruccionfuncion Linstrucciones1;

Linstrucciones1
    : Linstrucciones
    | ;

Instruccionfuncion
    : Expresionesfuncion Instruccionfuncion1 PYC
    | Llamadas_funcion PYC
    | LET IDENTIFICADOR Auxdeclaracion
    | CONST IDENTIFICADOR Auxdeclaracion4
    | sentencia_if
    | sentencia_switch
    | sentencia_while
    | sentencia_dowhile
    | sentencia_for
    | sentencia_break
    | Sentencia_return;

Auxdeclaracion4
    : DP Auxdeclaracion5
    | '=' Expresionesfuncion PYC;

Auxdeclaracion5
    : Tipo '=' Expresionesfuncion PYC
    | IDENTIFICADOR '=' '{' ValoresType '}' PYC;

Auxdeclaracion
    : DP Auxdeclaracion1
    | PYC
    | '=' Expresionesfuncion PYC;

Auxdeclaracion1
    : Tipo Auxdeclaracion2
    | IDENTIFICADOR Auxdeclaracion3;

Auxdeclaracion2
    : PYC
    | '=' Expresionesfuncion PYC;

Auxdeclaracion3
    : PYC
    | '=' Auxdeclaracion6;
    
Auxdeclaracion6
    : '{' ValoresType '}' PYC
    | Expresionesfuncion PYC;

Sentencia_return
    : RETURN Sentencia_return1;

Sentencia_return1
    : Expresionesfuncion PYC
    | PYC;

sentencia_break
    : BREAK PYC;

sentencia_for
    : FOR '(' sentencia_for1;

sentencia_for1
    : LET IDENTIFICADOR '=' Expresionesfuncion PYC Expresionesfuncion PYC Expresionesfuncion ')' InstruccionesFuncion
    | IDENTIFICADOR '=' Expresionesfuncion PYC Expresionesfuncion PYC Expresionesfuncion ')' InstruccionesFuncion;

sentencia_dowhile
    : DO InstruccionesFuncion WHILE '(' Expresionesfuncion ')' PYC;

sentencia_while
    : WHILE '(' Expresionesfuncion ')' InstruccionesFuncion;

sentencia_switch
    : SWITCH '(' Expresionesfuncion ')' '{' Lcasosswitch;

Lcasosswitch 
    : Lcasos '}'
    | '}';

Lcasos
    : CASE Expresionesfuncion DP Lcasos1
    | DEFAULT DP Lcasos1;

Lcasos1
    : Linstrucciones Lcasos2
    | Lcasos
    | ;

Lcasos2
    : Lcasos
    | ;

sentencia_if
    : IF '(' Expresionesfuncion ')' InstruccionesFuncion sentencia_else;

sentencia_else
    : ELSE sentencia_else1
    | ;

sentencia_else1
    : sentencia_if
    | InstruccionesFuncion;

Instruccionfuncion9
    : DP Instruccionfuncion10
    | '=' Expresionesfuncion PYC;

Instruccionfuncion10
    : Tipo '=' Expresionesfuncion PYC
    | IDENTIFICADOR '=' Instruccionfuncion11;

Instruccionfuncion11
    : '{' ValoresType '}' PYC
    | Expresionesfuncion PYC;

Instruccionfuncion4
    : DP Instruccionfuncion5
    | '=' Expresionesfuncion PYC
    | PYC;

Instruccionfuncion5
    : Tipo Instruccionfuncion6
    | IDENTIFICADOR Instruccionfuncion7;

Instruccionfuncion6
    : '=' Expresionesfuncion PYC
    | PYC;

Instruccionfuncion7
    : '=' Instruccionfuncion8
    | PYC;

Instruccionfuncion8
    : '{' ValoresType '}' PYC
    | Expresionesfuncion PYC;

Instruccionfuncion1
    : '=' instruccionfuncion12
    | ;

instruccionfuncion12
    : Expresionesfuncion
    | '{' ValoresType '}';

AuxInstruccionfuncion1
    : '(' Instruccionfuncion2
    | Atributos
    | ;

Atributos
    : Atributo Atributos1;

Atributo
    : '.' IDENTIFICADOR;

Atributos1
    : Atributos
    | ;

Expresionesfuncion
    : Auxexpresionesfuncion Auxexpresionesfuncion1;

Auxexpresionesfuncion1 
    : '?' Auxexpresionesfuncion DP Auxexpresionesfuncion;

Auxexpresionesfuncion
    : Expresionesfuncion1 Expresionesfuncion2;

Expresionesfuncion2
    : '+=' Expresionesfuncion1 Expresionesfuncion2
    | '-=' Expresionesfuncion1 Expresionesfuncion2
    | '*=' Expresionesfuncion1 Expresionesfuncion2
    | '/=' Expresionesfuncion1 Expresionesfuncion2
    | '%=' Expresionesfuncion1 Expresionesfuncion2
    | '**=' Expresionesfuncion1 Expresionesfuncion2
    | ;

Expresionesfuncion1
    : Expresionesfuncion3 Expresionesfuncion4;

Expresionesfuncion4
    : OR Expresionesfuncion3 Expresionesfuncion4
    | AND Expresionesfuncion3 Expresionesfuncion4
    | ;

Expresionesfuncion3
    : Expresionesfuncion5 Expresionesfuncion6;

Expresionesfuncion6
    : '==' Expresionesfuncion5 Expresionesfuncion6
    | '!=' Expresionesfuncion5 Expresionesfuncion6
    | ;

Expresionesfuncion5
    : Expresionesfuncion7 Expresionesfuncion8;

Expresionesfuncion8
    : '>=' Expresionesfuncion7 Expresionesfuncion8
    | '<=' Expresionesfuncion7 Expresionesfuncion8
    | '<' Expresionesfuncion7 Expresionesfuncion8
    | '>' Expresionesfuncion7 Expresionesfuncion8
    | ;

Expresionesfuncion7
    : Expresionesfuncion9 Expresionesfuncion10;

Expresionesfuncion10
    : '-' Expresionesfuncion9 Expresionesfuncion10
    | '+' Expresionesfuncion9 Expresionesfuncion10
    | ;

Expresionesfuncion9
    : Expresionesfuncion11 Expresionesfuncion12;

Expresionesfuncion12
    : '%' Expresionesfuncion11 Expresionesfuncion12
    | '/' Expresionesfuncion11 Expresionesfuncion12
    | '*' Expresionesfuncion11 Expresionesfuncion12
    | ;

Expresionesfuncion11
    : Expresionesfuncion13 Expresionesfuncion14;

Expresionesfuncion14
    : '**' Expresionesfuncion13 Expresionesfuncion14
    | ;

Expresionesfuncion13
    : NOT Expresionesfuncion13
    | '-' Expresionesfuncion13
    | Expresionesfuncion15;

Expresionesfuncion15
    : Expresionesfuncion16 Expresionesfuncion17;

Expresionesfuncion17
    : '++'
    | '--'
    | Atributos
    | '(' Instruccionfuncion2
    | ;

Expresionesfuncion16
    : NUMERO
    | CADENA
    | IDENTIFICADOR
    | TRUE
    | FALSE
    | NULL
    | '(' Expresionesfuncion ')';

Ternario
    : Expresionesfuncion '?' Ternario2;

Ternario2
    : Ternario3 DP Ternario3;

Ternario3
    : Llamadas_funcion
    | Expresionesfuncion;

Llamadas_funcion
    : CONSOLE '.' LOG '(' Instruccionfuncion2
    | GRAFICAR_TS '(' ')';

Instruccionfuncion2
    : ')'
    | Parametrosllamada ')';

Parametrosllamada
    : Parametrollamada Parametrosllamada1;

Parametrollamada
    : Expresionesfuncion;

Parametrosllamada1
    : ',' Parametrosllamada
    | ;

Instruccionfuncion3
    : '{' ValoresType '}'
    | Expresionesfuncion;

ValoresType
    : Valortype ValoresType1;

Valortype
    : IDENTIFICADOR DP Expresionesfuncion;

ValoresType1
    : ',' ValoresType
    | ValoresType
    | ;

Lparametrosfuncion
    : Parametro Auxparametros;

Parametro
    : IDENTIFICADOR DP Tipo
    | IDENTIFICADOR DP IDENTIFICADOR;

Auxparametros 
    : ',' Lparametrosfuncion
    | ;