import { Expresion } from "../Expresion";
import { Entorno } from "../Entorno/Entorno";
import { Retorno, Type } from "../Retorno";
import { _Error } from '../Error';
import { IfStmt } from '@angular/compiler';

export enum OperacionesLogicas{
    MENOR,
    MAYOR,
    MENORIGUAL,
    MAYORIGUAL,
    IGUAL,
    NOIGUAL,
    NEGADO,
    AND,
    OR
}

export class Relacional extends Expresion{
    
    constructor(private izquierdo : Expresion, private derecho : Expresion, private tipo : OperacionesLogicas, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        let resultado : Retorno;
        if(this.derecho != null)
        {
            const izquierdo = this.izquierdo.ejecutar(entorno);
            const derecho = this.derecho.ejecutar(entorno);
            if(this.tipo == OperacionesLogicas.AND)
            {
                if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    let auxizquierdo;
                    let auxderecho;
                    if(izquierdo.value.toString() == "true")
                    {
                        auxizquierdo = true;
                    }
                    else
                    {
                        auxizquierdo = false;
                    }

                    if(derecho.value.toString() == "true")
                    {
                        auxderecho = true;
                    }
                    else
                    {
                        auxderecho = false;
                    }
                    resultado = {value : (auxizquierdo && auxderecho), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar un and con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo == OperacionesLogicas.OR)
            {
                if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    let auxizquierdo;
                    let auxderecho;
                    if(izquierdo.value.toString() == "true")
                    {
                        auxizquierdo = true;
                    }
                    else
                    {
                        auxizquierdo = false;
                    }

                    if(derecho.value.toString() == "true")
                    {
                        auxderecho = true;
                    }
                    else
                    {
                        auxderecho = false;
                    }
                    resultado = {value : (auxizquierdo || auxderecho), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar un or con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo == OperacionesLogicas.MAYOR)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) > Number(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.CADENA && derecho.type ==Type.CADENA)
                {
                    resultado = {value : (izquierdo.value.toString() > derecho.value.toString()), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    resultado = {value : (Boolean(izquierdo.value.toString()) > Boolean(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo == OperacionesLogicas.MAYORIGUAL)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) >= Number(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.CADENA && derecho.type ==Type.CADENA)
                {
                    resultado = {value : (izquierdo.value.toString() >= derecho.value.toString()), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    resultado = {value : (Boolean(izquierdo.value.toString()) >= Boolean(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo == OperacionesLogicas.MENOR)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) < Number(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.CADENA && derecho.type ==Type.CADENA)
                {
                    resultado = {value : (izquierdo.value.toString() < derecho.value.toString()), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    resultado = {value : (Boolean(izquierdo.value.toString()) < Boolean(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo == OperacionesLogicas.MENORIGUAL)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) <= Number(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.CADENA && derecho.type ==Type.CADENA)
                {
                    resultado = {value : (izquierdo.value.toString() <= derecho.value.toString()), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    resultado = {value : (Boolean(izquierdo.value.toString()) <= Boolean(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo == OperacionesLogicas.IGUAL)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) == Number(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.CADENA && derecho.type ==Type.CADENA)
                {
                    resultado = {value : (izquierdo.value.toString() == derecho.value.toString()), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    resultado = {value : (Boolean(izquierdo.value.toString()) == Boolean(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo = OperacionesLogicas.NOIGUAL)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) != Number(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.CADENA && derecho.type ==Type.CADENA)
                {
                    resultado = {value : (izquierdo.value.toString() != derecho.value.toString()), type : Type.BOOLEANO}
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    resultado = {value : (Boolean(izquierdo.value.toString()) != Boolean(derecho.value.toString())), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
        }
        else
        {
            let izquierdo = this.izquierdo.ejecutar(entorno);
            if(this.tipo == OperacionesLogicas.NEGADO)
            {
                if(izquierdo.type == Type.BOOLEANO)
                {
                    let auxizquierdo;
                    if(izquierdo.value.toString() == "true")
                    {
                        auxizquierdo = true;
                    }
                    else
                    {
                        auxizquierdo = false;
                    }
                    resultado = {value : (!auxizquierdo), type : Type.BOOLEANO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede operar un not con el tipo: " + Type[izquierdo.type]);
                }
            }
        }
        return resultado;
    }
}