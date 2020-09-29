import { Type } from "../Retorno"

export enum TiposSimbolo{
    CONST = 0,
    VAR = 1
}

export class Simbolo{
    public valor : any;
    public nombre : string;
    public tipo : any;
    public variable : TiposSimbolo;

    constructor(valor : any, nombre : string, tipo : any, tiposim : TiposSimbolo){
        this.valor = valor;
        this.nombre = nombre;
        this.tipo = tipo;
        this.variable = tiposim;
    }
}