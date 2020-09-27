import { Expresion } from '../Expresion';
import { ValoresTipo, VariablesTipo } from '../Expresiones/VariablesTipo';
import { Simbolo } from './Simbolo'

export class Tipo{
    public nombre_tipo : string;
    public atributos_tipo : VariablesTipo[];

    constructor(nombre_tipo : string, atributos_tipo : VariablesTipo[]){
        this.nombre_tipo = nombre_tipo;
        this.atributos_tipo = atributos_tipo;
    }
}