import { Instruccion } from "../Instruccion";
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion';
import { TiposSimbolo } from '../Entorno/Simbolo';
import { Type } from '../Retorno';

export class Declaracion extends Instruccion{
    private nombre : string;
    private valor : Expresion;
    private tiposim : TiposSimbolo
    private tipovar : Type;

    constructor(nombre : string, valor : Expresion | null, tipovar : Type | null, tiposim : TiposSimbolo, linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valor = valor;
        this.tiposim = tiposim;
        this.tipovar = tipovar;
    }

    public ejecutar(entorno: Entorno) {
        const valor = this.valor.ejecutar(entorno);
        entorno.guardarVariable(this.nombre, valor.type, valor.value, this.tiposim);
    }
}