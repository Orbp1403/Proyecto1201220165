import { Expresion } from '../Expresion';
import { Entorno } from '../Entorno/Entorno';
import { Retorno, Type } from '../Retorno';
import { ValoresRetorno } from '../Arbol/ValoresRetorno';
import { _Error } from '../Error';

export class Variable extends Expresion{
    constructor(private nombre : string, private atributos : Array<string> | null, private tipo : Type, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        let resultado : Retorno = null;
        if(entorno.existeVariable(this.nombre) == false)
        {
            throw new _Error(this.linea, this.columna, "Semantico", "La variable: '" + this.nombre + "' no se encuentra declarada.");
        }
        let valorvariable = entorno.getVariable(this.nombre)
        if(this.atributos == null)
        {
            resultado = {value : valorvariable.valor, type : valorvariable.tipo}
        }
        else
        {
            //TODO sacar el valor de los atributos
        }
        return resultado;
    }
    
}