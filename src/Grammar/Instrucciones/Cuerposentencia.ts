import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";

export class Cuerposentencia extends Instruccion{
    constructor(private cuerpo : Array<Instruccion>, linea : number , columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
    
}