%{ let hermano = null; 
    let instruccion, nodo = null;
    let errores = null;

    exports.inicioerrores = function(){
        errores = new Array();
    }

    exports.geterrores = function () { 
        return errores 
    };
%}
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

.                       { 
                            console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); 
                            errores.push(new _Error(yylloc.first_line, yylloc.first_column, "Lexico", "El simbolo: " + yytext + " no pertenece al lenguaje"))
                        }
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
    const { _Error } = require('../Error');
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
            nodo : new Nodo(null, "INICIO", null)
        }
        $$.nodo.agregarHijos($1.nodo);
        //$1.nodo.addPadre($$.nodo)
        return $$;
    };

Instrucciones
    : Instrucciones Instruccion
    {
        $1.instrucciones.push($2.instrucciones)
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "INST", null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($2.nodo);
    }
    | Instruccion
    {
        $$ = {
            instrucciones : [$1.instrucciones],
            nodo : new Nodo(null, "INST", null)
        };
        $$.nodo.agregarHijos($1.nodo);
    };

Instruccion
    : Declaracion PYC
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : $1.nodo
        }
    }
    | Declaracion_type PYC
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : $1.nodo
        }
    }
    | Expresion PYC
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : $1.nodo
        }
    }
    | Asignacion
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : $1.nodo
        }
    }
    | Sentencias_control
    {
        //$$ = $1
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : $1.nodo
        }
    }
    | Funcion
    {
        //$$ = $1;
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : $1.nodo
        }
    }
    | error PYC;

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
    | error InstruccionesSentencias
    | 'BREAK' PYC
    {
        $$ = {
            instrucciones : new Break(@1.first_line, @1.first_column),
            nodo : new Nodo("Break", null, null)
        }
    }
    | 'RETURN' PYC
    {
        $$ = {
            instrucciones : new SentenciaReturn(null, @1.first_line, @1.first_column),
            nodo : new Nodo("Return", null, null)
        }
    }
    | 'RETURN' Expresion PYC
    {
        $$ = {
            instrucciones : new SentenciaReturn($2.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("Return", null, null)
        }
        $$.nodo.agregarHijos($2.nodo)
    };

SentenciaTernaria
    : Expresion '?' Expresion DP Expresion
    {
        $$ = {
            instrucciones : new SentenciaTernaria($1.instrucciones, $3.instrucciones, $4.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Ternaria", null)
        }
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($1.nodo);
        $$.nodo.agregarHijos(instruccion);
        $$.nodo.agregarHijos($3.nodo);
        $$.nodo.agregarHijos($5.nodo);
    };

Sentenciafor
    : 'FOR' '(' 'LET' IDENTIFICADOR '=' Expresion PYC Expresion PYC Aumento ')' InstruccionesSentencias
    {
        $$ = {
            instrucciones : new SentenciaFor($4, $6.instrucciones, $8.instrucciones, $10.instrucciones, $12.instrucciones, @1.first_line, @1.first_column) ,
            nodo : new Nodo(null, "For", null)
        }
        instruccion = new Nodo("=", null, null)
        instruccion.agregarHijos(new Nodo($4, null, null));
        instruccion.agregarHijos($6.nodo)
        $$.nodo.agregarHijos(instruccion)
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($8.nodo)
        $$.nodo.agregarHijos(instruccion)
        $$.nodo.agregarHijos($10.nodo)
        if($12.nodo != null)
        {
            $$.nodo.agregarHijos($12.nodo)
        }
    }
    | 'FOR' '(' IDENTIFICADOR '=' Expresion PYC Expresion PYC Aumento ')' InstruccionesSentencias
    {
        $$ = {
            instrucciones : new SentenciaFor($3, $5.instruccion, $7.instruccion, $9.instruccion, $11.instruccion, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "For", null)
        }
        instruccion = new Nodo("=", null, null);
        instruccion.agregarHijos(new Nodo($3, null, null));
        instruccion.agregarHijos($5.nodo)
        $$.nodo.agregarHijos(instruccion);
        instruccion = new Nodo(null, "Condicion", null)
        instruccion.agregarHijos($7.nodo)
        $$.nodo.agregarHijos(instruccion);
        $$.nodo.agregarHijos($9.nodo)
        if($11.nodo != null)
        {
            $$.nodo.agregarHijos($11.nodo)
        }
    };

Aumento
    : IDENTIFICADOR '++'
    {
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.MAS, new Literal(1, @1.first_line, @1.first_column, 0), @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Incremento", null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos(new Nodo('++', null, null));
        
    }
    | IDENTIFICADOR '--'
    {
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.MENOS, new Literal(1, @1.first_line, @1.first_column, 0), @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Incremento", null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos(new Nodo('--', null, null));
    }
    | IDENTIFICADOR '+=' Expresion
    {
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.MAS, $3.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("+=", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo)
    }
    | IDENTIFICADOR '-=' Expresion
    {
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.MENOS, $3.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("-=", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo)
    }
    | IDENTIFICADOR '*=' Expresion
    {
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.POR, $3.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("*=", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo)
    }
    | IDENTIFICADOR '/=' Expresion{
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.DIV, $3.instrucciones, @1.first_line, @1.first_column), 
            nodo : new Nodo("/=", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null))
        $$.nodo.agregarHijos($3.nodo);
    }
    | IDENTIFICADOR '%=' Expresion{
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.MODULO, $3.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo('%=', null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo)
    }
    | IDENTIFICADOR '**=' Expresion{
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.POTENCIA, $3.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo('**=', null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null))
        $$.nodo.agregarHijos($3.nodo);
    };

Sentenciadowhile
    : 'DO' InstruccionesSentencias 'WHILE' '(' Expresion ')' PYC
    {
        $$ = {
            instrucciones : new SentenciaDowhile($5.instrucciones, $2.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Do_while", null)
        }
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($5.nodo)
        if($2.nodo != null)
        {
            $$.nodo.agregarHijos($2.nodo)
        }
        $$.nodo.agregarHijos(instruccion)
    };

Sentenciawhile
    :'WHILE' '(' Expresion ')' InstruccionesSentencias
    {
        $$ = {
            instrucciones : new SentenciaWhile($3.instrucciones, $5.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "While", null)
        }
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($3.nodo)
        $$.nodo.agregarHijos(instruccion)
        if($5.nodo != null)
        {
            $$.nodo.agregarHijos($5.nodo)
        }
    };

Sentenciaswitch
    : 'SWITCH' '(' Expresion ')' '{' Casos '}'
    {
        $$ = {
            instrucciones : new SentenciaSwitch($3.instrucciones, $6.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Switch", null) 
        }
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($3.nodo)
        $$.nodo.agregarHijos(instruccion);
        $$.nodo.agregarHijos($6.nodo);
    }
    | 'SWITCH' '(' Expresion ')' '{' '}'
    {
        $$ = {
            instrucciones : new SentenciaSwitch($3.instrucciones, null, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Switch", null)
        }
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($3.nodo)
        $$.nodo.agregarHijos(instruccion)
    };

Casos
    : Casos 'CASE' Expresion DP InstruccionSentencia
    {
        $1.instrucciones.push(new Caso($3.instrucciones, $5.instrucciones, @1.first_line, @1.first_column));
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Caso", null)
        };
        $$.nodo.agregarHijos($1.nodo)
        $$.nodo.agregarHijos($3.nodo)
        $$.nodo.agregarHijos($5.nodo)
    }
    | Casos 'CASE' Expresion DP
    {
        $1.instrucciones.push(new Caso($3.instrucciones, null, @1.first_line, @1.first_column));
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Caso", null)
        }
        $$.nodo.agregarHijos($1.nodo)
        $$.nodo.agregarHijos($3.nodo)
    }
    | Casos 'DEFAULT' DP InstruccionSentencia
    {
        $1.instrucciones.push(new CasoDef($4.instrucciones, @1.first_line, @1.first_column));
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Caso", null)
        };
        $$.nodo.agregarHijos($1.nodo)
        $$.nodo.agregarHijos(new Nodo(null, "Default", null))
        $$.nodo.agregarHijos($4.nodo)
    }
    | Casos 'DEFAULT' DP
    {
        $1.instrucciones.push(new CasoDef(null, @1.first_line, @1.first_column));
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Caso", null)
        };
        $$.nodo.agregarHijos($1.nodo)
        $$.nodo.agregarHijos(new Nodo("Default", null, null))
    }
    | 'CASE' Expresion DP InstruccionSentencia
    {
        $$ = {
            instrucciones : [new Caso($2, $4.instrucciones, @1.first_line, @1.first_column)],
            nodo : new Nodo(null, "Caso", null)
        }
        $$.nodo.agregarHijos($2.nodo);
        $$.nodo.agregarHijos($4.nodo)
    }
    | 'CASE' Expresion DP
    {
        $$ = {
            instrucciones : [new Caso($2, null, @1.first_line, @1.first_column)],
            nodo : new Nodo(null, "Caso", null)
        }
        $$.nodo.agregarHijos($2.nodo)
    }
    | 'DEFAULT' DP 
    {
        $$ = {
            instrucciones : [new CasoDef(null, @1.first_line, @1.first_column)],
            nodo : new Nodo(null, "Caso", null) 
        }
        $$.nodo.agregarHijos(new Nodo("Default", null, null));
    };

Sentenciaif
    : 'IF' '(' Expresion ')' InstruccionesSentencias
    {
        $$ = {
            instrucciones : new SentenciaIf($3.instrucciones, $5.instrucciones, null, @1.first_line, @1.first_column), 
            nodo : new Nodo(null, "IF", null)
        }
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($3.nodo);
        $$.nodo.agregarHijos(instruccion);
        if($5.nodo != null)
        {
            $$.nodo.agregarHijos($5.nodo);
        }
    }
    | 'IF' '(' Expresion ')' InstruccionesSentencias SentenciaElse
    {
        $$ = {
            instrucciones : new SentenciaIf($3.instrucciones, $5.instrucciones, $6.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "IF", null)
        }
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($3.nodo)
        $$.nodo.agregarHijos(instruccion)
        if($5.nodo != null)
        {
            $$.nodo.agregarHijos($5.nodo)
        }
        $$.nodo.agregarHijos($6.nodo)
    };

SentenciaElse
    : 'ELSE' Sentenciaif
    {
        $$ = {
            instrucciones : $2.instrucciones,
            nodo : new Nodo(null, "ELSE", null)
        }
        $$.nodo.agregarHijos($2.nodo);
    }
    | 'ELSE' InstruccionesSentencias
    {
        $$ = {
            instrucciones : $2.instrucciones,
            nodo : new Nodo(null, "ELSE", null)
        }
        if($2.nodo != null)
        {
            $$.nodo.agregarHijos($2.nodo);
        }
    };

InstruccionesSentencias
    : '{' InstruccionSentencia '}'
    {
        $$ = {
            instrucciones : new Cuerposentencia($2.instrucciones, @1.first_line, @1.first_column),
            nodo : $2.nodo
        }
    }
    | '{' '}'
    {
        $$ = {
            instrucciones : new Cuerposentencia(new Array(), @1.first_line, @1.first_column),
            nodo : null
        }
    };

InstruccionSentencia
    : InstruccionSentencia Declaracion PYC
    {
        $1.instrucciones.push($2.instrucciones);
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Inst", null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($2.nodo)
    }
    | InstruccionSentencia Asignacion
    {
        $1.instrucciones.push($2.instrucciones);
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Inst", null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($2.nodo)
    }
    | InstruccionSentencia Sentencias_control
    {
        $1.instrucciones.push($2.instrucciones)
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Inst", null)
        }
        $$.nodo.agregarHijos($1.nodo)
        $$.nodo.agregarHijos($2.nodo)
    }
    | InstruccionSentencia Expresion PYC
    {
        $1.instrucciones.push($2.instrucciones)
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Inst", null)
        };
        $$.nodo.agregarHijos($1.nodo)
        $$.nodo.agregarHijos($2.nodo)
    }
    | InstruccionSentencia error PYC
    | Declaracion PYC
    {
        $$ = {
            instrucciones : [$1.instrucciones],
            nodo : new Nodo(null, "Inst", null)
        }
        $$.nodo.agregarHijos($1.nodo)
    }
    | Expresion PYC
    {
        $$ = {
            instrucciones : [$1.instrucciones],
            nodo : new Nodo(null, "Inst", null)
        }
        $$.nodo.agregarHijos($1.nodo)
    }
    | Asignacion
    {
        $$ = {
            instrucciones : [$1.instrucciones],
            nodo : new Nodo(null, "Inst", null)
        }
        $$.nodo.agregarHijos($1.nodo)
    }
    | Sentencias_control
    {
        $$ = {
            instrucciones : [$1.instrucciones],
            nodo : new Nodo(null, "Inst", null)
        }
        $$.nodo.agregarHijos($1.nodo)
    }
    | error PYC;

Asignacion
    : IDENTIFICADOR Listaatributos '=' Expresion PYC
    {
        $$ = {
            instrucciones : new Asignacion($1, $2.instrucciones, $4.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("Asignacion", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($2.nodo)
        $$.nodo.agregarHijos($4.nodo)
    }
    | IDENTIFICADOR Listaatributos '=' '{' Lvalorestype '}' PYC
    {
        $$ = {
            instrucciones : new AsignacionVarType($1, $2.instrucciones, $5.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("Asignacion", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null))
        $$.nodo.agregarHijos($2.nodo)
        $4.nodo.agregarHijos($5.nodo)
    }
    | IDENTIFICADOR '=' '{' Lvalorestype '}' PYC
    {
        $$ = {
            instrucciones : new AsignacionVarType($1, null, $4.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("Asignacion", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($4.nodo)
    }
    | IDENTIFICADOR '=' Expresion PYC
    {
        $$ = {
            instrucciones : new Asignacion($1, null, $3, @1.first_line, @1.first_column),
            nodo : new Nodo("Asignacion")
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($4.nodo)
    };

Declaracion_type
    : TYPE IDENTIFICADOR '=' '{' Latributostype '}'
    {
        $$ = {
            instrucciones : new DeclaracionTipos($2, $5.instrucciones, @1.first_line, @1.first_column), 
            nodo : new Nodo(null, "DECLARACION_TYPE", null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo('=', null, null));
        $$.nodo.agregarHijos($5.nodo)
    };

Latributostype
    : Latributostype IDENTIFICADOR DP TipoatributosType ','
    {
        $1.instrucciones.push(new VariablesTipo($2, $4.instrucciones, @1.first_line, @1.first_column))
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Valor", null)
        };
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos(new Nodo($2, null, null))
        $$.nodo.agregarHijos($4.nodo)
    }
    | Latributostype IDENTIFICADOR DP TipoatributosType PYC
    {
        $1.instrucciones.push(new VariablesTipo($2, $4.instrucciones, @1.first_line, @1.first_column))
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Valor", null)
        }
        $$.nodo.agregarHijos($1.nodo)
        $$.nodo.agregarHijos(new Nodo($2, null, null))
        $$.nodo.agregarHijos($4.nodo)
    }
    | Latributostype IDENTIFICADOR DP TipoatributosType
    {
        $1.instrucciones.push(new VariablesTipo($2, $4.instrucciones, @1.first_line, @1.first_column));
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Valor", null)
        };
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos($4.nodo)
    }
    | IDENTIFICADOR DP TipoatributosType ','
    {
        $$ = {
            instrucciones : [new VariablesTipo($1, $3.instrucciones, @1.first_line, @1.first_column)],
            nodo : new Nodo(null, "Valor", null) 
        };
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo);
    }
    | IDENTIFICADOR DP TipoatributosType PYC
    {
        $$ = {
            instrucciones : [new VariablesTipo($1, $3.instrucciones, @1.first_line, @1.first_column)],
            nodo : new Nodo(null, "Valor", null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo);
    }
    | IDENTIFICADOR DP TipoatributosType
    {
        $$ = {
            instrucciones : [new VariablesTipo($1, $3.instrucciones, @1.first_line, @1.first_column)],
            nodo : new Nodo(null, "Valor", null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null))
        $$.nodo.agregarHijos($3.nodo)
    };

TipoatributosType
    : Tipo
    {
        $$ = {
            instrucciones : $1,
            nodo : new Nodo(Type[$1], null, null)
        }
    }
    | IDENTIFICADOR
    {
        $$ = {
            instrucciones : $1,
            nodo : new Nodo($1, null, null)
        }
    };


Declaracion
    : LET IDENTIFICADOR DP Tipo '=' Expresion
    {
        $$ = {
            instrucciones :  new Declaracion($2, $6.instrucciones, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column),
            nodo : new Nodo("DECLARACION", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo(Type[$4], null, null));
        $$.nodo.agregarHijos(new Nodo('=', null, null))
        $$.nodo.agregarHijos($6.nodo)
    }
    | LET IDENTIFICADOR '=' Expresion
    {
        $$ = {
            instrucciones : new Declaracion($2, $4.instrucciones, null, TiposSimbolo.VAR, @1.first_line, @1.first_column),
            nodo : new Nodo("DECLARACION", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo('=', null, null));
        $$.nodo.agregarHijos($4.nodo)
    }
    | LET IDENTIFICADOR DP Tipo
    {
        $$ = {
            instrucciones : new Declaracion($2, null, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column),
            nodo : new Nodo("Declaracion", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo(Type[$4], null, null));
    }
    | LET IDENTIFICADOR
    {
        $$ = {
            instrucciones : new Declaracion($2, null, null, TiposSimbolo.VAR, @1.first_line, @1.first_column),
            nodo : new Nodo("Declaracion", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
    }
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}'
    {
        $$ = {
            instrucciones : new DeclaracionVarType($2, $7.instrucciones, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Declaracion", null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo($4, null, null));
        $$.nodo.agregarHijos(new Nodo('=', null, null));
        $$.nodo.agregarHijos($7.nodo)
    }
    | LET IDENTIFICADOR DP IDENTIFICADOR '=' Expresion
    {
        $$ = {
            instrucciones : new DeclaracionVarType($2, $6.instrucciones, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Declaracion", null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo($4, null, null));
        $$.nodo.agregarHijos(new Nodo('=', null, null));
        $$.nodo.agregarHijos($6.nodo)
    }
    | LET IDENTIFICADOR DP IDENTIFICADOR
    {
        $$ = {
            instrucciones : new DeclaracionVarType($2, null, $4, TiposSimbolo.VAR, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Declaracion", null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo($3, null, null));
    }
    | CONST IDENTIFICADOR DP Tipo '=' Expresion
    {
        $$ = {
            instrucciones : new Declaracion($2, $6.instrucciones, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Declaracion", null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo(Type[$4], null, null))
        $$.nodo.agregarHijos(new Nodo('=', null, null));
        $$.nodo.agregarHijos($6.nodo);
    }
    | CONST IDENTIFICADOR '=' Expresion
    {
        $$ = {
            instrucciones : new Declaracion($2, $4.instrucciones, null, TiposSimbolo.CONST, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Declaracion", null)
        };
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo('=', null, null));
        $$.nodo.agregarHijos($4.nodo);
    }
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' '{' Lvalorestype '}'
    {
        $$ = {
            instrucciones : new DeclaracionVarType($2, $7.instrucciones, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Declaracion", null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null)) ;
        $$.nodo.agregarHijos(new Nodo($4, null, null));
        $$.nodo.agregarHijos(new Nodo('=', null, null));
        $$.nodo.agregarHijos($7.nodo);
    }
    | CONST IDENTIFICADOR DP IDENTIFICADOR '=' IDENTIFICADOR
    {
        $$ = {
            instrucciones : new DeclaracionVarType($2, $6, $4, TiposSimbolo.CONST, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Declaracion", null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos(new Nodo($4, null, null));
        $$.nodo.agregarHijos(new Nodo('=', null, null));
        $$.nodo.agregarHijos(new Nodo($6, null, null));
    };

Lvalorestype
    : Lvalorestype IDENTIFICADOR DP Expresion ',' 
    {
        $1.instrucciones.push(new ValoresTipo($2, $4.instrucciones, @1.first_line, @1.first_column));
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo("Valores", null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos(new Nodo($2, null, null))
        $$.nodo.agregarHijos($4.nodo)
    }
    | Lvalorestype IDENTIFICADOR DP Expresion
    {
        $1.instrucciones.push(new ValoresTipo($2, $4.instrucciones, @1.first_line, @1.first_column));
        $$ = { 
            instrucciones : $1.instrucciones,
            nodo : new Nodo("Valores", null, null)
        };
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos(new Nodo($2, null, null));
        $$.nodo.agregarHijos($4.nodo)
    } 
    | IDENTIFICADOR DP Expresion ','
    {
        $$ = {
            instrucciones : [new ValoresTipo($1, $3.instrucciones, @1.first_line, @1.first_column)],
            nodo : new Nodo("Valores", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo);
    }
    | IDENTIFICADOR DP Expresion
    {
        $$ = {
            instrucciones : [new ValoresTipo($1, $3.instrucciones, @1.first_line, @1.first_column)],
            nodo : new Nodo("Valores", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo);
    };

Expresion
    : 'NOT' Expresion
    {
        $$ = {
            instrucciones : new Relacional($2, null, OperacionesLogicas.NEGADO, @1.first_line, @1.first_column),
            nodo : new Nodo('!', null, null)
        }
        $$.nodo.agregarHijos($2.nodo);
    }
    | Expresion 'AND' Expresion
    {
        $$ = {
            instrucciones : new Relacional($1, $3, OperacionesLogicas.AND, @1.first_line, @1.first_column),
            nodo : new Nodo('&&', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion 'OR' Expresion
    {
        $$ = {
            instrucciones : new Relacional($1, $3, OperacionesLogicas.OR, @1.first_line, @1.first_column),
            nodo : new Nodo('||', null, null) 
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '==' Expresion
    {
        $$ = {
            instrucciones : new Relacional($1, $3, OperacionesLogicas.IGUAL, @1.first_line, @1.first_column),
            nodo : new Nodo ('==', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '!=' Expresion
    {
        $$ = {
            instrucciones : new Relacional($1, $3, OperacionesLogicas.NOIGUAL, @1.first_line, @1.first_column),
            nodo : new Nodo('!=', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '<' Expresion
    {
        $$ = {
            instrucciones : new Relacional($1, $3, OperacionesLogicas.MENOR, @1.first_line, @1.first_column),
            nodo : new Nodo('<', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '>' Expresion
    {
        $$ = {
            instrucciones : new Relacional($1, $3, OperacionesLogicas.MAYOR, @1.first_line, @1.first_column),
            nodo : new Nodo('>', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '<=' Expresion
    {
        $$ = {
            instrucciones : new Relacional($1, $3, OperacionesLogicas.MENORIGUAL, @1.first_line, @1.first_column),
            nodo : new Nodo('<=', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '>=' Expresion
    {
        $$ = {
            instrucciones : new Relacional($1, $3, OperacionesLogicas.MAYORIGUAL, @1.first_line, @1.first_column),
            nodo : new Nodo('>=', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    |'-' Expresion %prec NEGATIVO
    {
        $$ = {
            instrucciones : new Aritmeticas($2, null, OpcionesAritmeticas.NEGATIVO, @1.first_line, @1.first_column),
            nodo : new Nodo('-', null, null)
        }
        $$.nodo.agregarHijos($2.nodo);
    }
    | Expresion '+' Expresion
    {
        $$ = {
            instrucciones : new Aritmeticas($1, $3, OpcionesAritmeticas.MAS, @1.first_line, @1.first_column),
            nodo : new Nodo('+', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '-' Expresion
    {
        $$ = {
            instrucciones : new Aritmeticas($1, $3, OpcionesAritmeticas.MENOS, @1.first_line, @1.first_column),
            nodo : new Nodo('-', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo)
    }
    | Expresion '*' Expresion
    {
        $$ = {
            instrucciones : new Aritmeticas($1, $3, OpcionesAritmeticas.POR, @1.first_line, @1.first_column),
            nodo : new Nodo('*', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '/' Expresion
    {
        $$ = {
            instrucciones : new Aritmeticas($1, $3, OpcionesAritmeticas.DIV, @1.first_line, @1.first_column),
            nodo : new Nodo('/', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '%' Expresion
    {
        $$ = {
            instrucciones : new Aritmeticas($1, $3, OpcionesAritmeticas.MODULO, @1.first_line, @1.first_column),
            nodo : new Nodo('%', null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion '**' Expresion
    {
        $$ = {
            instrucciones : new Aritmeticas($1, $3, OpcionesAritmeticas.POTENCIA, @1.first_line, @1.first_column),
            nodo : new Nodo('**', null, null, null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | '(' Expresion ')'
    {
        $$ = $2;
    }
    | NUMERO
    {
        $$ = {
            instrucciones : new Literal($1, @1.first_line, @1.first_column, 0),
            nodo : new Nodo($1, null, null)
        }
    }
    | CADENA
    {
        if($1.includes('\"'))
        {
            $$ = {
                instrucciones : new Literal($1.replace(/['"]+/g, ''), @1.first_line, @1.first_column, 1),
                nodo : new Nodo($1.replace(/['"]+/g, ''), null, null)
            }
        }
        else if($1.includes("'"))
        {
            $$ = {
                instrucciones : new Literal($1.replace(/["'"]+/g, ''), @1.first_line, @1.first_column),
                nodo : new Nodo($1.replace(/["'"]+/g, ''), null, null)
            }
        }
        else
        {
            $$ = {
                instrucciones : new Literal($1, @1.first_line, @1.first_column),
                nodo : new Nodo($1, null, null)
            }
        }
    }
    | TRUE
    {
        $$ = {
            instrucciones : new Literal($1, @1.first_line, @1.first_column, 2),
            nodo : new Nodo($1, null, null)
        }
    }
    | FALSE
    {
        $$ = {
            instrucciones : new Literal($1, @1.first_line, @1.first_column, 2),
            nodo : new Nodo($1, null, null)
        }
    }
    | IDENTIFICADOR
    {
        $$ = {
            instrucciones : new Variable($1, null, 7, @1.first_line, @1.first_column),
            nodo : new Nodo($1, null, null)
        }
    }
    | IDENTIFICADOR Listaatributos
    {
        $$ = {
            instrucciones : new Variable($1, $2.instrucciones, 7, @1.first_line, @1.first_column),
            nodo : new Nodo(null, 'EXP', null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($2.nodo);
    }
    | IDENTIFICADOR '(' ')'
    {
        $$ = {
            instrucciones : new Llamada($1, [], @1.first_line, @1.first_column),
            nodo : new Nodo(null, 'Llamada', null)
        };
        $$.nodo.agregarHijos(new Nodo($1, null, null));
    }
    | IDENTIFICADOR '(' Listaparam ')'
    {
        $$ = {
            instrucciones : new Llamada($1, $3.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Llamada", null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo);
    }
    | NULL
    {
        $$ = {
            instrucciones : new Literal($1, @1.first_line, @1.first_column, 3),
            nodo : new Nodo($1, null, null)
        }
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
        $1.instrucciones.push($3);
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, 'ATRIB', null)
        }
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos(new Nodo($3, null, null))
        $$ = $1;
    }
    | '.' IDENTIFICADOR
    {
        $$ = {
            instrucciones : [$2],
            nodo : new Nodo(null, 'ATRIB', null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
    };

Llamada
    : IDENTIFICADOR '(' ')'
    {
        $$ = {
            instrucciones : new Llamada($1, [], @1.first_line, @1.first_column),
            nodo : new Nodo(null, 'Llamada', null)
        };
        $$.nodo.agregarHijos(new Nodo($1, null, null));
    }
    | IDENTIFICADOR '(' Listaparam ')'
    {
        $$ = {
            instrucciones : new Llamada($1, $3.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Llamada", null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo);
    }
    | 'CONSOLE' '.' 'LOG' '(' ')'
    {
        $$ = {
            instrucciones : new Imprimir([], @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Imprimir", null)
        }
    }
    | 'CONSOLE' '.' 'LOG' '(' Listaparam ')'
    {
        $$ = {
            instrucciones : new Imprimir($5.instrucciones, @1.first_line, @1.first_column) ,
            nodo : new Nodo(null, "Imprimir", null)

        }
        $$.nodo.agregarHijos($5.nodo);
    }
    | 'GRAFICAR_TS' '(' ')'
    {
        $$ = {
            instrucciones : new GraficarTs(@1.first_line, @1.first_column),
            nodo : new Nodo(null, "GraficarTs", null)
        }
    };

Listaparam
    : Listaparam ',' Expresion 
    {
        $1.instrucciones.push($3.instrucciones)
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Parametro", null)
        };
        $$.nodo.agregarHijos($1.nodo);
        $$.nodo.agregarHijos($3.nodo);
    }
    | Expresion{
        $$ = {
            instrucciones : [$1.instrucciones],
            nodo : new Nodo(null, "Parametro", null)
        }
        $$.nodo.agregarHijos($1.nodo);
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
        if($4.parametros != null)
        {
            $$ = {
                instrucciones : new Funcion($2, $4.instrucciones_f.instrucciones, $4.parametros.instrucciones, $4.tipo, @1.first_line, @1.first_column),
                nodo : new Nodo(null, "Funcion", null)
            }
            $$.nodo.agregarHijos(new Nodo($2, null, null));
            $$.nodo.agregarHijos($4.parametros.nodo);
            if(isNaN($4.tipo) == false)
            {
                $$.nodo.agregarHijos(new Nodo(Type[$4.tipo], null, null))
            }
            else
            {
                $$.nodo.agregarHijos(new Nodo($4.tipo, null, null))
            }
            if($4.instrucciones_f.nodo != null)
            {
                $$.nodo.agregarHijos($4.instrucciones_f.nodo)
            }
        }
        else
        {
            $$ = {
                instrucciones : new Funcion($2, $4.instrucciones_f.instrucciones, $4.parametros, $4.tipo, @1.first_line, @1.first_column),
                nodo : new Nodo(null, "Funcion", null)
            }
            $$.nodo.agregarHijos(new Nodo($2, null, null));
            $$.nodo.agregarHijos(new Nodo(Type[$4.tipo], null, null))
            if($4.instrucciones_f.nodo != null)
            {
                $$.nodo.agregarHijos($4.instrucciones_f.nodo)
            }
        }
    };

Funcion1
    : Lparametrosfuncion ')' DP Tipofuncion InstruccionesFuncion
    {
        $$ = {
            parametros : $1,
            tipo : $4,
            instrucciones_f : $5
        }
    }
    | ')' DP Tipofuncion InstruccionesFuncion
    {
        $$ = {
            parametros : null,
            tipo : $3,
            instrucciones_f : $4
        }
    };

Tipofuncion
    : Tipo
    {
        $$ = $1
    }
    | IDENTIFICADOR
    {
        $$ = $1
    };

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
        $$ = {
            instrucciones : null,
            nodo : null
        };
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
        hermano[hermano.length - 1].instrucciones.unshift(hermano[hermano.length - 2].instrucciones);
        $$ = {
            instrucciones : hermano[hermano.length - 1].instrucciones,
            nodo : new Nodo(null, "INST", null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 2].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
    }
    | 
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : [hermano[hermano.length - 1].instrucciones],
            nodo : new Nodo(null, "INST", null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    };

Instruccionfuncion
    : Expresionesfuncion Instruccionfuncion1 PYC
    {
        if($2.contenido.instrucciones != null)
        {
            if($2.estype == false)
            {
                $$ = {
                    instrucciones : new Asignacion($1.instrucciones.nombre, $1.instrucciones.atributos, $2.contenido.instrucciones, $1.instrucciones.linea, $1.instrucciones.columna),
                    nodo : new Nodo("Asignacion", null, null)
                }
                $$.nodo.agregarHijos($1.nodo);
                $$.nodo.agregarHijos($2.contenido.nodo)
            }
            else
            {
                $$ = {
                    instrucciones : new AsignacionVarType($1.instrucciones.nombre, $1.instrucciones.atributos, $2.contenido.instrucciones, $1.instrucciones.linea, $1.instrucciones.columna),
                    nodo : new Nodo("Asignacion", null, null)
                }
                $$.nodo.agregarHijos($1.nodo)
                $$.nodo.agregarHijos($2.contenido.nodo)
            }
        }
        else
        {
            $$ = $1;
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
                $$ = {
                    instrucciones : new Declaracion($2, null, null, TiposSimbolo.VAR, @1.first_line, @1.first_column),
                    nodo : new Nodo("Declaracion", null, null)
                }
                $$.nodo.agregarHijos(new Nodo($2, null, null))
            }
            else if($3.valor == null && $3.tipo != null)
            {
                $$ = {
                    instrucciones : new Declaracion($2, null, $3.tipo, TiposSimbolo.VAR, @1.first_line, @1.first_column),
                    nodo : new Nodo("Declaracion", null, null)
                }
                $$.nodo.agregarHijos(new Nodo($2, null, null));
                if(isNaN($3.tipo) == false)
                {
                    $$.nodo.agregarHijos(new Nodo(Type[$3.tipo], null, null))
                }
                else
                {
                    $$.nodo.agregarHijos(new Nodo($3, null, null))
                }
            }
            else if($3.valor != null && $3.tipo != null)
            {
                $$ = {
                    instrucciones : new Declaracion($2, $3.valor, $3.tipo, TiposSimbolo.VAR, @1.first_line, @1.first_column),
                    nodo : new Nodo("Declaracion", null, null)
                }
                $$.nodo.agregarHijos(new Nodo($2, null, null))
                if(isNaN($3.tipo) == false)
                {
                    $$.nodo.agregarHijos(new Nodo(Type[$3.tipo], null, null))
                }
                else
                {
                    $$.nodo.agregarHijos(new Nodo($3, null, null))
                }
                $$.nodo.agregarHijos(new Nodo('=', null, null))
                $$.nodo.agregarHijos($3.nodo)
            }
            else if($3.valor != null && $3.tipo == null)
            {
                $$ = {
                    instrucciones : new Declaracion($2, $3.valor, null, TiposSimbolo.VAR, @1.first_line, @1.first_column),
                    nodo : new Nodo("Declaracion", null, null)
                }
                $$.nodo.agregarHijos(new Nodo($2, null, null));
                $$.nodo.agregarHijos(new Nodo('=', null, null));
                $$.nodo.agregarHijos($3.nodo)
            }
        }
        else
        {
            if($3.valor == null && $3.tipo != null)
            {
                $$ = {
                    instrucciones : new DeclaracionVarType($2, null, $3.tipo, TiposSimbolo.VAR, @1.first_line, @1.first_column),
                    nodo : new Nodo(null, "Declaracion", null)
                }
                $$.nodo.agregarHijos(new Nodo($2, null, null))
                $$.nodo.agregarHijos(new Nodo($3.tipo, null, null))
            }
            else if($3.valor != null && $3.tipo != null)
            {
                $$ = {
                    instrucciones : new DeclaracionVarType($2, $3.valor, $3.tipo, TiposSimbolo.VAR, @1.first_line, @1.first_column),
                    nodo : new Nodo(null, "Declaracion", null)
                }
                $$.nodo.agregarHijos(new Nodo($2, null, null))
                $$.nodo.agregarHijos(new Nodo($3.tipo, null, null))
                $$.nodo.agregarHijos(new Nodo('=', null, null))
                $$.nodo.agregarHijos($3.nodo)
            }
        }
    }
    | CONST IDENTIFICADOR Auxdeclaracion4
    {
        if($3.estype == false)
        {
            if($3.valor != null && $3.tipo == null)
            {
                $$ = {
                    instrucciones : new Declaracion($2, $3.valor, null, TiposSimbolo.CONST, @1.first_line, @1.first_column),
                    nodo : new Nodo(null, "Declaracion", null)
                }
                $$.nodo.agregarHijos(new Nodo($2, null, null));
                $$.nodo.agregarHijos(new Nodo('=', null, null))
                $$.nodo.agregarHijos($3.nodo)
            }
            else
            {
                $$ = {
                    instrucciones : new Declaracion($2, $3.valor, $3.tipo, TiposSimbolo.CONST, @1.first_line, @1.first_column),
                    nodo : new Nodo(null, "Declaracion", null)
                }
                $$.nodo.agregarHijos(new Nodo($2, null, null));
                $$.nodo.agregarHijos(new Nodo(Type[$3.tipo], null, null))
                $$.nodo.agregarHijos(new Nodo('=', null, null));
                $$.nodo.agregarHijos($3.nodo)
            }
        }
        else
        {
            $$ = {
                instrucciones : new DeclaracionVarType($2, $3.valor, $3.tipo, TiposSimbolo.CONST, @1.first_line, @1.first_column),
                nodo : new Nodo(null, "Declaracion", null)
            }
            $$.nodo.agregarHijos(new Nodo($2, null, null))
            $$.nodo.agregarHijos(new Nodo($3.tipo, null, null))
            $$.nodo.agregarHijos(new Nodo('=', null, null))
            $$.nodo.agregarHijos($3.nodo)
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
    }
    | error PYC;

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
            valor : hermano[hermano.length - 2].instrucciones,
            tipo : null,
            nodo : hermano[hermano.length - 2].nodo
        }
    };

Auxdeclaracion5
    : Tipo '=' Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : false,
            valor : hermano[hermano.length - 2].instrucciones,
            tipo : hermano[hermano.length - 4],
            nodo : hermano[hermano.length - 2].nodo
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
            valor : hermano[hermano.length - 2].instrucciones,
            tipo : null,
            nodo : hermano[hermano.length - 2].nodo
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
            valor : hermano[hermano.length - 2].instrucciones,
            tipo : hermano[hermano.length - 4],
            nodo : hermano[hermano.length - 2].nodo
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
            valor : hermano[hermano.length - 3].instrucciones,
            tipo : hermano[hermano.length - 6],
            nodo : hermano[hermano.length - 3].nodo
        }
    }
    | Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            estype : true,
            valor : hermano[hermano.length - 2].instrucciones,
            tipo : hermano[hermano.length - 4],
            nodo : hermano[hermano.length - 2].nodo
        }
    };

Sentencia_return
    : RETURN Sentencia_return1
    {
        $$ = {
            instrucciones : new SentenciaReturn($2.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("Return", null, null)
        }
        if($2.nodo != null)
        {
            $$.nodo.agregarHijos($2.nodo)
        }
    };

Sentencia_return1
    : Expresionesfuncion PYC
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : hermano[hermano.length - 2].instrucciones,
            nodo : hermano[hermano.length - 2].nodo
        };
    }
    | PYC
    {
        $$ = {
            instrucciones : null,
            nodo : null
        }
    };

sentencia_break
    : BREAK PYC
    {
        $$ = {
            instrucciones : new Break(@1.first_line, @1.first_column),
            nodo : new Nodo("Break", null, null)
        }
    };

sentencia_for
    : FOR '(' sentencia_for1
    {
        $$ = {
            instrucciones : new SentenciaFor($3.id, $3.valor_inicio.instrucciones, $3.condicion.instrucciones, $3.incremento.instrucciones, $3.instrucciones.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "For", null)
        }
        instruccion = new Nodo("=", null, null)
        instruccion.agregarHijos(new Nodo($3.id, null, null))
        instruccion.agregarHijos($3.valor_inicio.nodo)
        $$.nodo.agregarHijos(instruccion);
        instruccion = new Nodo(null, "Condicion", null)
        instruccion.agregarHijos($3.condicion.nodo)
        $$.nodo.agregarHijos(instruccion)
        $$.nodo.agregarHijos($3.incremento.nodo)
        if($3.instrucciones.nodo != null)
        {
            $$.nodo.agregarHijos($3.instrucciones.nodo)
        }
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
        $$ = {
            instrucciones : new SentenciaDowhile($5, $2, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Do_while", null)
        }
        instruccion = new Nodo(null, "Condicion", null)
        instruccion.agregarHijos($5.nodo)
        if($2.nodo != null)
        {
            $$.nodo.agregarHijos($2.nodo)
        }
        $$.nodo.agregarHijos(instruccion)
    };

sentencia_while
    : WHILE '(' Expresionesfuncion ')' InstruccionesFuncion
    {
        $$ = {
            instrucciones : new SentenciaWhile($3.instrucciones, $5.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "While", null)
        }
        instruccion = new Nodo(null, "Condicion", null);
        instruccion.agregarHijos($3.nodo)
        $$.nodo.agregarHijos(instruccion)
        if($5.nodo != null){
            $$.nodo.agregarHijos($5.nodo)
        }
    };

sentencia_switch
    : SWITCH '(' Expresionesfuncion ')' '{' Lcasosswitch
    {
        $$ = {
            instrucciones : new SentenciaSwitch($3.instrucciones, $6.casos, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Switch", null)
        };
        instruccion = new Nodo(null, "Condicion", null)
        instruccion.agregarHijos($3.nodo)
        $$.nodo.agregarHijos(instruccion)
        if($6.casos != null)
        {
            $$.nodo.agregarHijos($6.nodo_casos)
        }
    };

Lcasosswitch 
    : Lcasos '}'
    {
        $$ = $1;
    }
    | '}'
    {
        $$ = {
            casos : null,
            nodo_casos : null
        };
    };

Lcasos
    : CASE Expresionesfuncion DP Lcasos1
    {
        hermano = eval('$$');
        if(hermano[hermano.length - 1].casos == null)
        {
            $$ = {
                casos : [new Caso($2.instrucciones, hermano[hermano.length - 1].instrucciones, @1.first_line, @1.first_column)],
                nodo_casos : new Nodo(null, "Caso", null)
            }
            $$.nodo_casos.agregarHijos($2.nodo)
            if(hermano[hermano.length - 1].instrucciones != null)
            {
                $$.nodo_casos.agregarHijos(hermano[hermano.length - 1].nodo)
            }
        }
        else
        {
            hermano[hermano.length - 1].casos.unshift(new Caso($2, hermano[hermano.length - 1].instrucciones, @1.first_line, @1.first_column))
            $$ = {
                casos : hermano[hermano.length - 1].casos,
                nodo_casos : new Nodo(null, "Caso", null)
            }
            $$.nodo_casos.agregarHijos($2.nodo);
            if(hermano[hermano.length - 1].nodo != null)
            {
                $$.nodo_casos.agregarHijos(hermano[hermano.length - 1].nodo)
            }            
            $$.nodo_casos.agregarHijos(hermano[hermano.length - 1].nodo_casos)
        }
    }
    | DEFAULT DP Lcasos1
    {
        hermano = eval('$$');
        if(hermano[hermano.length - 1].casos == null)
        {
            $$ = {
                casos : [new CasoDef(hermano[hermano.length - 1].instrucciones, @1.first_line, @1.first_column)],
                nodo_casos : new Nodo(null, "Caso", null)
            }
            $$.nodo_casos.agregarHijos(new Nodo("Default", null, null));
            if(hermano[hermano.length - 1].instrucciones != null)
            {
                $$.nodo_casos.agregarHijos(hermano[hermano.length - 1].nodo)
            }
        }
        else
        {
            hermano[hermano.length - 1].casos.unshift(new CasoDef(hermano[hermano.length - 1].instrucciones, @1.first_line, @1.first_column));
            $$ = {
                casos : hermano[hermano.length - 1].casos,
                nodo_casos : new Nodo(null, "Caso", null)
            }
            $$.nodo_casos.agregarHijos(new Nodo("Default", null, null))
            if(hermano[hermano.length - 1].nodo != null)
            {
                $$.nodo_casos.agregarHijos(hermano[hermano.length - 1].nodo)
            }
            $$.nodo_casos.agregarHijos(hermano[hermano.length - 1].nodo_casos)
        }
    };

Lcasos1
    : Linstrucciones Lcasos2
    {
        hermano = eval('$$')
        if(hermano[hermano.length - 1] == null)
        {
            $$ = {
                instrucciones : hermano[hermano.length - 2].instrucciones,
                casos : null,
                nodo : hermano[hermano.length - 2].nodo,
                nodo_casos : null
            }
        }
        else
        {
            $$ = {
                instrucciones : hermano[hermano.length - 2].instrucciones,
                casos : hermano[hermano.length - 1].casos,
                nodo : hermano[hermano.length - 2].nodo,
                nodo_casos : hermano[hermano.length - 1].nodo_casos
            }
        }
        
    }
    | Lcasos
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : null,
            casos : hermano[hermano.length - 1].casos,
            nodo : null,
            nodo_casos : hermano[hermano.length - 1].nodo_casos
        }
    }
    | 
    {
        $$ = {
            instrucciones : null,
            casos : null,
            nodo : null,
            nodo_casos : null
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
        $$ = {
            instrucciones : new SentenciaIf($3.instrucciones, $5.instrucciones, $6.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "IF", null)
        };
        instruccion = new Nodo(null, "Condicion", null)
        instruccion.agregarHijos($3.nodo);
        $$.nodo.agregarHijos(instruccion)
        if($5.nodo != null)
        {
            $$.nodo.agregarHijos($5.nodo)
        }

        if($6.nodo != null)
        {
            $$.nodo.agregarHijos($6.nodo)
        }
    };

sentencia_else
    : ELSE sentencia_else1
    {
        $$ = {
            instrucciones : $2.instrucciones,
            nodo : new Nodo(null, "ELSE", null)
        }
        $$.nodo.agregarHijos($2.nodo)
    }
    | 
    {
        $$ = {
            instrucciones : null,
            nodo : null
        }
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
        $$ = {
            contenido : {
                instrucciones : null
            }
            ,
            nodo : null
        };
    };

instruccionfuncion12
    : Expresionesfuncion
    {
        $$ = {
            contenido : $1,
            estype : false
        }
    }
    | '{' ValoresType '}'
    {
        $$ = {
            contenido : $2,
            estype : true
        }
    };

Expresionesfuncion
    : Auxexpresionesfuncion Auxexpresionesfuncion1
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Auxexpresionesfuncion1 
    : '?' Auxexpresionesfuncion DP Auxexpresionesfuncion
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new SentenciaTernaria(hermano[hermano.length - 5].instrucciones, hermano[hermano.length-3].instrucciones, hermano[hermano.length - 1].instrucciones, hermano[hermano.length - 5].instrucciones.linea, hermano[hermano.length - 5].instrucciones.columna),
            nodo : new Nodo(null, "Ternaria", null)
        }
        instruccion = new Nodo(null, "Condicion", null)
        instruccion.agregarHijos(hermano[hermano.length - 5].nodo)
        $$.nodo.agregarHijos(instruccion);
        $$.nodo.agregarHijos(hermano[hermano.length - 3].nodo) 
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
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
        $$ = {
            instrucciones : new Incremento(hermano[hermano.length - 4].instrucciones, OpcionesAritmeticas.MAS, hermano[hermano.length - 1].instrucciones, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo("+=", null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '-=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Incremento(hermano[hermano.length - 4].instrucciones, OpcionesAritmeticas.MAS, hermano[hermano.length - 1].instrucciones, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo("-=", null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '*=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Incremento(hermano[hermano.length - 4].instrucciones, OpcionesAritmeticas.MAS, hermano[hermano.length - 1].instrucciones, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo("*=", null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '/=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Incremento(hermano[hermano.length - 4].instrucciones, OpcionesAritmeticas.MAS, hermano[hermano.length - 1].instrucciones, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo("/=", null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '%=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Incremento(hermano[hermano.length - 4].instrucciones, OpcionesAritmeticas.MAS, hermano[hermano.length - 1].instrucciones, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo("%=", null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '**=' Expresionesfuncion1 Expresionesfuncion2
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Incremento(hermano[hermano.length - 4].instrucciones, OpcionesAritmeticas.MAS, hermano[hermano.length - 1].instrucciones, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo("**=", null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
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
        $$ = {
            instrucciones : new Relacional(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OperacionesLogicas.OR, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length-4].instrucciones.columna),
            nodo : new Nodo('||', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | AND Expresionesfuncion3 Expresionesfuncion4
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Relacional(hermano[hermano.length - 4], hermano[hermano.length - 1], OperacionesLogicas.AND, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna),
            nodo : new Nodo('&&', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
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
        $$ = {
            instrucciones : new Relacional(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OperacionesLogicas.IGUAL, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('==', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo);
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '!=' Expresionesfuncion5 Expresionesfuncion6
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Relacional(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OperacionesLogicas.NOIGUAL, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna), 
            nodo : new Nodo('!=', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo);
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
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
        $$ = {
            instrucciones : new Relacional(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OperacionesLogicas.MAYORIGUAL, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('>=', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '<=' Expresionesfuncion7 Expresionesfuncion8
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Relacional(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OperacionesLogicas.MENORIGUAL, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('<=', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '<' Expresionesfuncion7 Expresionesfuncion8
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Relacional(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OperacionesLogicas.MENOR, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('<', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '>' Expresionesfuncion7 Expresionesfuncion8
    {
        hermano = eval('$$');
        $$ ={
            instrucciones : new Relacional(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OperacionesLogicas.MAYOR, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('>', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo)
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
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
        $$ = {
            instrucciones : new Aritmeticas(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OpcionesAritmeticas.MENOS, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('-', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo);
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | '+' Expresionesfuncion9 Expresionesfuncion10
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Aritmeticas(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OpcionesAritmeticas.MAS, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('+', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo);
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
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
        $$ = {
            instrucciones : new Aritmeticas(hermano[hermano.length - 4], hermano[hermano.length - 1], OpcionesAritmeticas.MODULO, hermano[hermano.length - 4].linea, hermano[hermano.length - 4].columna),
            nodo : new Nodo('%', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo);
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
    }
    | '/' Expresionesfuncion11 Expresionesfuncion12
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Aritmeticas(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OpcionesAritmeticas.DIV, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna) ,
            nodo : new Nodo('/', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo);
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
    }
    | '*' Expresionesfuncion11 Expresionesfuncion12
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Aritmeticas(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OpcionesAritmeticas.POR, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('*', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo);
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
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
        $$ = {
            instrucciones : new Aritmeticas(hermano[hermano.length - 4].instrucciones, hermano[hermano.length - 1].instrucciones, OpcionesAritmeticas.POTENCIA, hermano[hermano.length - 4].instrucciones.linea, hermano[hermano.length - 4].instrucciones.columna),
            nodo : new Nodo('**', null, null)
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 4].nodo);
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
    }
    | 
    {
        hermano = eval('$$');
        $$ = hermano[hermano.length-1];
    };

Expresionesfuncion13
    : NOT Expresionesfuncion13
    {
        $$ = {
            instrucciones : new Relacional($2.instrucciones, null, OperacionesLogicas.NEGADO, @1.first_line, @1.first_column),
            nodo : new Nodo('!', null, null)
        }
        $$.nodo.agregarHijos($2.nodo);
    }
    | '-' Expresionesfuncion13
    {
        $$ = {
            instrucciones : new Aritmeticas($2.instrucciones, null, OpcionesAritmeticas.NEGATIVO, @1.first_line, @1.first_column),
            nodo : new Nodo('-', null, null)
        }
        $$.nodo.agregarHijos($2.nodo);
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
            $$ = {
                instrucciones : new Incremento(hermano[hermano.length-2].instrucciones.nombre, OpcionesAritmeticas.MAS, new Literal(1, @1.first_line, @1.first_column, 0), hermano[hermano.length-2].instrucciones.linea, hermano[hermano.length-2].instrucciones.columna), 
                nodo : new Nodo(null, "Incremento", null)
            }
            $$.nodo.agregarHijos(new Nodo(hermano[hermano.length-2].instrucciones.nombre, null, null));
            $$.nodo.agregarHijos(new Nodo('--', null, null))
        }else{
            //TODO error
        }
    }
    | '--'
    {
        hermano = eval('$$');
        if(hermano[hermano.length-2].tipo == 7){
            $$ = {
                instrucciones : new Incremento(hermano[hermano.length-2].instrucciones.nombre, OpcionesAritmeticas.MENOS, new Literal(1, @1.first_line, @1.first_column, 0), hermano[hermano.length-2].instrucciones.linea, hermano[hermano.length-2].instrucciones.columna),
                nodo : new Nodo(null, "Incremento", null)
            }
            $$.nodo.agregarHijos(new Nodo(hermano[hermano.length-2].instrucciones.nombre, null, null));
            $$.nodo.agregarHijos(new Nodo('--', null, null))
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
        $$ = {
            instrucciones : new Variable(hermano[hermano.length-2].instrucciones.nombre, hermano[hermano.length-1].instrucciones, 7, hermano[hermano.length-2].instrucciones.linea, hermano[hermano.length-2].instrucciones.columna),
            nodo : new Nodo(null, 'EXP', null)
        }
        $$.nodo.agregarHijos(new Nodo(hermano[hermano.length - 2].instrucciones.nombre, null, null))
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
        
    }
    | '(' Instruccionfuncion2
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Llamada(hermano[hermano.length-3].instrucciones.nombre, hermano[hermano.length-1].instrucciones, hermano[hermano.length-3].instrucciones.linea, hermano[hermano.length-3].instrucciones.columna),
            nodo : new Nodo(null, "Llamada", null)
        }
        $$.nodo.agregarHijos(new Nodo(hermano[hermano.length - 3].instrucciones.nombre, null, null));
        if(hermano[hermano.length - 1].nodo != null)
        {
            $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
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
        $$ = {
            instrucciones : new Literal($1, @1.first_line, @1.first_column, 0),
            nodo : new Nodo($1, null, null)
        }
    }
    | CADENA
    {
         if($1.includes('\"'))
        {
            $$ = {
                instrucciones : new Literal($1.replace(/['"]+/g, ''), @1.first_line, @1.first_column, 1),
                nodo : new Nodo($1.replace(/['"]+/g, ''), null, null)
            }
        }
        else if($1.includes("'"))
        {
            $$ = {
                instrucciones : new Literal($1.replace(/["'"]+/g, ''), @1.first_line, @1.first_column),
                nodo : new Nodo($1.replace(/["'"]+/g, ''), null, null)
            }
        }
        else
        {
            $$ = {
                instrucciones : new Literal($1, @1.first_line, @1.first_column),
                nodo : new Nodo($1, null, null)
            }
        }
    }
    | IDENTIFICADOR
    {
        $$ = {
            instrucciones : new Variable($1, null, 7, @1.first_line, @1.first_column),
            nodo : new Nodo($1, null, null)
        }
    }
    | TRUE
    {
        $$ = {
            instrucciones : new Literal($1, @1.first_line, @1.first_column, 2),
            nodo : new Nodo($1, null, null)
        }
    }
    | FALSE
    {
        $$ = {
            instrucciones : new Literal($1, @1.first_line, @1.first_column, 2),
            nodo : new Nodo($1, null, null)
        }
    }
    | NULL
    {
        $$ = {
            instrucciones : new Literal($1, @1.first_line, @1.first_column, 3),
            nodo : new Nodo($1, null, null)
        }
    }
    | '(' Expresionesfuncion ')'
    {
        $$ = $2;
    };


Llamadas_funcion
    : CONSOLE '.' LOG '(' Instruccionfuncion2
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : new Imprimir(hermano[hermano.length-1].instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Imprimir", null)
        }
        if(hermano[hermano.length - 1].nodo != null)
        {
            $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
        }
    }
    | GRAFICAR_TS '(' ')'
    {
        $$ = {
            instrucciones : new GraficarTs(@1.first_line, @1.first_column),
            nodo : new Nodo(NULL, "GraficarTs", null)
        }
    };

Instruccionfuncion2
    : ')'
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : [],
            nodo : null
        };
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
        $$ = {
            instrucciones : $2,
            nodo : new Nodo(null, "ATRIB", null)
        }
        $$.nodo.agregarHijos(new Nodo($2, null, null));
    };

Atributos1
    : Atributos
    {
        hermano = eval('$$');
        hermano[hermano.length-1].instrucciones.unshift(hermano[hermano.length - 2].instrucciones);
        $$ = {
            instrucciones : hermano[hermano.length-1].instrucciones,
            nodo : hermano[hermano.length - 2].nodo
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | 
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : [hermano[hermano.length-1].instrucciones],
            nodo : hermano[hermano.length - 1].nodo
        }
    };

Parametrosllamada
    : Parametrollamada Parametrosllamada1
    {
        $$ = $2;
    };

Parametrollamada
    : Expresionesfuncion
    {
        $$ = {
            instrucciones : $1.instrucciones,
            nodo : new Nodo(null, "Parametro", null)
        }
        $$.nodo.agregarHijos($1.nodo)
    };

Parametrosllamada1
    : ',' Parametrosllamada
    {
        hermano = eval('$$');
        hermano[hermano.length-1].instrucciones.unshift(hermano[hermano.length - 3].instrucciones);
        $$ = {
            instrucciones : hermano[hermano.length-1].instrucciones,
            nodo : hermano[hermano.length - 3].nodo
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
    }
    | 
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : [hermano[hermano.length-1].instrucciones],
            nodo : hermano[hermano.length - 1].nodo
        }
    };

ValoresType
    : Valortype ValoresType1
    {
        $$ = $2;
    };

Valortype
    : IDENTIFICADOR DP Expresionesfuncion
    {
        $$ = {
            instrucciones : new ValoresTipo($1, $3.instrucciones, @1.first_line, @1.first_column),
            nodo : new Nodo("Valores", null, null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos($3.nodo)
    };

ValoresType1
    : ',' ValoresType
    {
        hermano = eval('$$');
        hermano[hermano.length - 1].instrucciones.unshift(hermano[hermano.length -3].instrucciones);
        $$ = {
            instrucciones : hermano[hermano.length - 1].instrucciones,
            nodo : hermano[hermano.length-3].nodo
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
    }
    | ValoresType
    {
        hermano = eval('$$');
        hermano[hermano.length - 1].instrucciones.unshift(hermano[hermano.length - 2].instrucciones);
        $$ = {
            instrucciones : hermano[hermano.length - 1].instrucciones,
            nodo : hermano[hermano.length -2].nodo
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo)
    }
    | 
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : [hermano[hermano.length - 1].instrucciones],
            nodo : hermano[hermano.length - 1].nodo
        }
    };

Lparametrosfuncion
    : Parametro Auxparametros
    {
        $$ = $2
    };

Parametro
    : IDENTIFICADOR DP Tipo
    {
        $$ = {
            instrucciones : new VariablesTipo($1, $3, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Parametro", null) 
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos(new Nodo(Type[$3], null, null));
    }
    | IDENTIFICADOR DP IDENTIFICADOR
    {
        $$ = {
            instrucciones : new VariablesTipo($1, $3, @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Parametro", null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null))
        $$.nodo.agregarHijos(new Nodo($3, null, null))
    };

Auxparametros 
    : ',' Lparametrosfuncion
    {
        hermano = eval('$$');
        hermano[hermano.length - 1].instrucciones.unshift(hermano[hermano.length - 3].instrucciones);
        $$ = {
            instrucciones : hermano[hermano.length - 1].instrucciones,
            nodo : hermano[hermano.length - 3].nodo
        }
        $$.nodo.agregarHijos(hermano[hermano.length - 1].nodo);
    }
    | 
    {
        hermano = eval('$$');
        $$ = {
            instrucciones : [hermano[hermano.length - 1].instrucciones],
            nodo : hermano[hermano.length - 1].nodo
        }
    };

%%