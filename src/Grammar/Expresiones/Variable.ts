import { Expresion } from '../Expresion';
import { Entorno } from '../Entorno/Entorno';
import { Retorno } from '../Retorno';

export class Variable extends Expresion{
    constructor(private nombre : string, private atributos : Array<string> | null, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        //TODO sacar el valor de la variable para ejecutar
        throw new Error("hola");
    }
    
}