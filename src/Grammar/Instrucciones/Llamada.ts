import { Instruccion } from '../Instruccion';
import { Expresion } from '../Expresion'
import { Entorno } from '../Entorno/Entorno';
import { _Error } from '../Error';
import { ANALYZE_FOR_ENTRY_COMPONENTS } from '@angular/core';
import { TiposSimbolo } from '../Entorno/Simbolo';

export class Llamada extends Instruccion{
    
    constructor(private nombre : string, private parametros : Array<Expresion>, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        if(entorno.getFuncion(this.nombre) != null)
        {
            let funcion = entorno.getFuncion(this.nombre);
            let todosbien = true
            let indiceparametro = 0;
            if(funcion.getParametros().length == this.parametros.length)
            {
                for(let i = 0; i < funcion.getParametros().length; i++)
                {
                    let auxparametro = this.parametros[i].ejecutar(entorno);
                    if(funcion.getParametros()[i].getTipo() != auxparametro.type)
                    {
                        todosbien = false;
                        indiceparametro = i;
                        break;
                    }
                }
                if(todosbien == true)
                {
                    let nuevoentorno : Entorno = new Entorno(entorno);
                    for(let i = 0; i < funcion.getParametros().length; i++)
                    {
                        nuevoentorno.guardarVariable(funcion.getParametros()[i].getNombre(), funcion.getParametros()[i].getTipo(), this.parametros[i].ejecutar(nuevoentorno).value, TiposSimbolo.VAR, this.linea, this.columna);
                    }
                    console.log("nuevoentorno", nuevoentorno);
                    console.log("cuerpo", funcion.getCuerpo());
                    let instruccion = funcion.getCuerpo().ejecutar(nuevoentorno);

                    if(instruccion != null || instruccion != undefined)
                    {
                        return instruccion;
                    }
                }
                else
                {
                    throw new _Error(this.parametros[indiceparametro].linea, this.parametros[indiceparametro].columna, "Semantico", "No coinciden los tipos en el parametro: " + funcion.getParametros()[indiceparametro].getNombre());
                }
            }
            else
            {
                throw new _Error(this.linea, this.columna, "Semantico", "La funcion: " + this.nombre + " no esta declarada con el mismo numero de parametros.");
            }
        }
        else
        {
            throw new _Error(this.linea, this.columna, "Semantico", "La funcion: " + this.nombre + " no se encuentra declarada.");
        }
    }
}