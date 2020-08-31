import { Expresion } from '../Expresion'
import { Type, Retorno } from '../Retorno';
import { Entorno } from '../Entorno/Entorno';

export class VariablesTipo extends Expresion{
    constructor(private nombre : string, private tipo : Type | string, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        throw new Error("Method not implemented.");
    }
}