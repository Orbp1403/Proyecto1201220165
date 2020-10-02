import { Instruccion } from "../Instruccion"
import { clearScreenDown } from "readline"
import { Entorno } from "../Entorno/Entorno"
import { Expresion } from "../Expresion"
import { _Error } from '../Error'
import { Type } from '../Retorno'

export class Asignacion extends Instruccion{
    private nombre : string
    private valor : Expresion
    private atributos : Array<string> | null;

    constructor(nombre : string, atributos : Array<string> | null, valor : Expresion, linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valor = valor;
        this.atributos = atributos;
    }

    public ejecutar(entorno: Entorno) {
        if(this.atributos == null)
        {
            const valor_actual = entorno.getVariable(this.nombre);
            if(valor_actual != null)
            {
                const valor =  this.valor.ejecutar(entorno);
                console.log("valor_actual", valor_actual);
                if(valor_actual.tipo == Type.UNDEFINED || valor_actual.tipo == valor.type)
                {
                    console.log("valor", valor);
                    entorno.setValor_Variable(this.nombre, valor);
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "El tipo de la variable no coincide con el de la asignacion.")
                }
            }
            else
            {
                throw new _Error(this.linea, this.columna, "Semantico", "No existe la variable.");
            }
        }
        else
        {
            //TODO asignar variables a atributos de objetos
        }
    }

}