import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Asignacion } from "./Asignacion";
import { Type } from "../Retorno";
import { TiposSimbolo } from "../Entorno/Simbolo";
import { ValoresTipo } from "../Expresiones/VariablesTipo";

export class DeclaracionVarType extends Instruccion{
    private nombre : string;
    private valores : ValoresTipo[];
    private tipo : string;
    private tiposim : TiposSimbolo;

    constructor(nombre : string, valores : ValoresTipo[], tipo : string, tiposim : TiposSimbolo, linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valores = valores;
        this.tipo = tipo;
        this.tiposim = tiposim;
    }

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
    
}