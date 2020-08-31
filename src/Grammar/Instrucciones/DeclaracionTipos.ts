import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno'
import { VariablesTipo } from '../Expresiones/VariablesTipo'

export class DeclaracionTipos extends Instruccion{
    private nombre : string;
    private valores : VariablesTipo[];

    constructor(nombre : string, valores : VariablesTipo[], linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valores = valores;
    }
    
    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.")
    }
}