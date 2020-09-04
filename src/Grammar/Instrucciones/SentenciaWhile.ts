import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";

export class SentenciaWhile extends Instruccion{
    constructor(private condicion : Expresion, private cuerpo : Instruccion, linea : number, columna : number){
        super(linea, columna);
    }
    
    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
}