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
        $$ = {
            instrucciones : new Break(@1.first_line, @1.first_column),
            nodo : new Nodo("Break", null, null)
        }
    }
    | 'RETURN' PYC
    {
        $$ = {
            instrucciones : new Return(null, @1.first_line, @1.first_column),
            nodo : new Nodo("Return", null, null)
        }
    }
    | 'RETURN' Expresion PYC
    {
        $$ = {
            instrucciones : new Return($2.instrucciones, @1.first_line, @1.first_column),
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
        console.log("aumento")
        $$ = {
            instrucciones : new Incremento($1, OpcionesAritmeticas.MAS, new Literal(1, @1.first_line, @1.first_column, 0), @1.first_line, @1.first_column),
            nodo : new Nodo(null, "Incremento", null)
        }
        $$.nodo.agregarHijos(new Nodo($1, null, null));
        $$.nodo.agregarHijos(new Nodo('++', null, null));
        console.log($$)
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
            console.log("$2 no es null")
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
    };

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
        $$.nodo.agregarHijos(new Nodo($1, null, null));
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
        $$.nodo.agregarHijos(new Nodo($1, null, null));
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
    | Llamada
    {
        $$ = $1;
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
        console.log($1)
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
        console.log()
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
        /*if($4.parametros != null)
        {
            $$ = {
                instrucciones : new Funcion($2, $4.instrucciones_f.instrucciones, $4.parametros.instrucciones, $4.tipo, @1.first_line, @1.first_column),
                nodo : new Nodo(null, "Funcion", null)
            }
            $$.nodo.agregarHijos(new Nodo($2, null, null));
            $$.nodo.agregarHijos($4.parametros.nodo);
            $$.nodo.agregarHijos(new Nodo(Type[$4.tipo], null, null))
            if($4.instrucciones_f.nodo != null)
            {
                $$.nodo.agregarHijos($4.instrucciones_f.nodo)
            }
        }
        else
        {
            $$ = {
                instrucciones : new Funcion($2, $4.instrucciones_f.instrucciones, $4.parametros.instrucciones, $4.tipo, @1.first_line, @1.first_column),
                nodo : new Nodo(null, "Funcion", null)
            }
            $$.nodo.agregarHijos(new Nodo($2, null, null));
            $$.nodo.agregarHijos(new Nodo(Type[$4.tipo], null, null))
            if($4.instrucciones_f.nodo != null)
            {
                $$.nodo.agregarHijos($4.instrucciones_f.nodo)
            }
        }*/
        $$ = $4.parametros
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