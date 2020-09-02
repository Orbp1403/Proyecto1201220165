import { Expresion } from "../Expresion";
import { Entorno } from "../Entorno/Entorno";
import { Retorno } from "../Retorno";

export enum OperacionesLogicas{
    MENOR,
    MAYOR,
    MENORIGUAL,
    MAYORIGUAL,
    IGUAL,
    NOIGUAL,
    NEGADO,
    AND,
    OR
}

export class Relacional extends Expresion{
    
    constructor(private izquierdo, private derecho, private tipo : OperacionesLogicas, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        throw new Error("Method not implemented.");
    }
}