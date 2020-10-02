import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';

export class Break extends Instruccion{
    constructor(linea : number, columna : number){
        super(linea, columna)
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented. BREAK");
    }
}