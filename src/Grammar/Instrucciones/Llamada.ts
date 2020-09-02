import { Instruccion } from '../Instruccion';
import { Expresion } from '../Expresion'
import { Entorno } from '../Entorno/Entorno';

export class Llamada extends Instruccion{
    
    constructor(private nombre : string, private parametros : Array<Expresion>, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
}