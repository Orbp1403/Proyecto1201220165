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
    public isarray : boolean;
    public size : number;

    constructor(valor : any, nombre : string, tipo : any, tiposim : TiposSimbolo, public linea : number,public columna : number, isarray : boolean){
        this.valor = valor;
        this.nombre = nombre;
        this.tipo = tipo;
        this.variable = tiposim;
        this.isarray = isarray;
    }

    public setsize(size : number){
    this.size = size;
    }
}