import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";

export class CasoDef extends Instruccion{
    constructor(private cuerpo : Instruccion | null, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented. CASODEF");
    }
}