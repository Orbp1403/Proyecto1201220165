import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";

export class Cuerposentencia extends Instruccion{
    constructor(private cuerpo : Array<Instruccion>, linea : number , columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        if(this.cuerpo != null)
        {
            return this.cuerpo
        }
    }
    
}