import { Expresion } from '../Expresion'
import { Type, Retorno } from '../Retorno';
import { Entorno } from '../Entorno/Entorno';

export class VariablesTipo extends Expresion{
    constructor(private nombre : string, private tipo : Type | string, linea : number, columna : number){
        super(linea, columna);
    }

    public getNombre(){
        return this.nombre;
    }

    public getTipo(){
        return this.tipo;
    }

    public ejecutar(entorno: Entorno): Retorno {
        throw new Error("Method not implemented.1");
    }
}

export class ValoresTipo extends Expresion{
    constructor (private nombre : string, private valor : any, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        let retorno : Retorno;
        for(let i = 0; i < this.valor.length; i++)
        {

        }
        return retorno;
    }

    
}