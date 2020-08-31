import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { ValoresTipo } from "../Expresiones/VariablesTipo";

export class AsignacionVarType extends Instruccion{
    private nombre : string;
    private valor : ValoresTipo[];

    constructor(nombre : string, valor : ValoresTipo[], linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valor = valor;
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }

}