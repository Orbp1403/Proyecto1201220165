import { Instruccion } from "../Instruccion";
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion';
import { TiposSimbolo } from '../Entorno/Simbolo'

export class Declaracion extends Instruccion{
    private nombre : string;
    private valor : Expresion;
    private tiposim : TiposSimbolo

    constructor(nombre : string, valor : Expresion, tiposim : TiposSimbolo, linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valor = valor;
        this.tiposim = tiposim;
    }

    public ejecutar(entorno: Entorno) {
        const valor = this.valor.ejecutar(entorno);
        entorno.guardarVariable(this.nombre, valor.type, valor.value, this.tiposim);
    }
}