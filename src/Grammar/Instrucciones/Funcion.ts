import { Instruccion } from '../Instruccion';
import { Entorno } from '../Entorno/Entorno';
import { Type } from '../Retorno';

export class Funcion extends Instruccion{
    constructor(private nombre : string, private cuerpo : Instruccion, private parametros : Array<string>, private tipo : Type, linea : number, columna : number){
        super(linea, columna);
    }
    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
}