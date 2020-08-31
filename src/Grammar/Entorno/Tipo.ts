import { Simbolo } from './Simbolo'

export class Tipo{
    public nombre_tipo : string;
    public atributos_tipo : Simbolo[];

    constructor(nombre_tipo : string, atributos_tipo : Simbolo[]){
        this.nombre_tipo = nombre_tipo;
        this.atributos_tipo = atributos_tipo;
    }
}