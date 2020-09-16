import { Entorno } from "../Entorno/Entorno";
import { Instruccion } from "../Instruccion";

export class GraficarTs extends Instruccion{
    constructor(linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
}