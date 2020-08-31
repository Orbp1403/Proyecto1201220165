import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno'
import { Expresion } from '../Expresion'
import { TiposSimbolo } from '../Entorno/Simbolo'
import { Variable } from '../Expresiones/Variable'

export class DeclaracionTipos extends Instruccion{
    private nombre : string;
    private valores : Variable[];

    constructor(nombre : string, valores : Variable[], linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valores = valores;
    }
    
    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.")
    }
}