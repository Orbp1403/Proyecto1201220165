import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { OpcionesAritmeticas } from '../Expresiones/Opcionesaritmeticas'
import { Expresion } from '../Expresion'

export class Incremento extends Instruccion{
    constructor(nombre : string, opcion : OpcionesAritmeticas, valor : Expresion, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
}