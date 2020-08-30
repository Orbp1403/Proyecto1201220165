import { Retorno } from "./Retorno";
import { Entorno } from "./Entorno/Entorno";

export abstract class Expresion {
    public linea : number;
    public columna : number;

    constructor(linea : number, columna : number) {
        this.linea = linea;
        this.columna = columna;    
    }

    public abstract ejecutar(entorno : Entorno) : Retorno;
}