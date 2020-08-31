import { Instruccion } from "../Instruccion"
import { clearScreenDown } from "readline"
import { Entorno } from "../Entorno/Entorno"
import { Expresion } from "../Expresion"

export class Asignacion extends Instruccion{
    private nombre : string
    private valor : Expresion

    constructor(nombre : string, valor : Expresion, linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valor = valor;
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.")
    }

}