import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { OpcionesAritmeticas } from '../Expresiones/Opcionesaritmeticas'
import { Expresion } from '../Expresion'

export class Incremento extends Instruccion{
    constructor(private nombre : string,private opcion : OpcionesAritmeticas, private valor : Expresion, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
}