import { Expresion } from '../Expresion';
import { Entorno } from '../Entorno/Entorno';
import { Retorno, Type } from '../Retorno';
import { ValoresRetorno } from '../Arbol/ValoresRetorno';

export class Variable extends Expresion{
    constructor(private nombre : string, private atributos : Array<string> | null, private tipo : Type, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        //TODO sacar el valor de la variable para ejecutar
        let resultado : Retorno = null;
        let valorvariable = entorno.getVariable(this.nombre)
        resultado = {value : valorvariable.valor, type : valorvariable.tipo}
        return resultado;
    }
    
}