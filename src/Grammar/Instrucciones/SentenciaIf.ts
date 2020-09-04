import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";

export class SentenciaIf extends Instruccion{
    constructor(private condicion : Expresion, private cuerpo : Instruccion, private SentenciaElse : Instruccion | null,  linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }

}