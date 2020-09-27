    import { Instruccion } from "../Instruccion";
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion';
import { TiposSimbolo } from '../Entorno/Simbolo';
import { Type } from '../Retorno';
import { Asignacion } from './Asignacion'
import { _Error } from '../Error';

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
        if(this.valor != null && this.tipovar != null)
        {   
            const valor = this.valor.ejecutar(entorno);
            if(valor.type == this.tipovar)
            {
                entorno.guardarVariable(this.nombre, valor.type, valor.value, this.tiposim, this.linea, this.columna);
            }
            else 
            {
                throw new _Error(this.linea, this.columna, "Semantico", "El tipo declarado no es el mismo que el tipo del valor")
            }
        }
        else if(this.valor != null && this.tipovar == null)
        {
            const valor = this.valor.ejecutar(entorno);
            entorno.guardarVariable(this.nombre, valor.type, valor.value, this.tiposim, this.linea, this.columna);
        }
        else if(this.valor == null && this.tipovar != null)
        {
            entorno.guardarVariable(this.nombre, this.tipovar, null, this.tiposim, this.linea, this.columna);
        }
        else
        {
            entorno.guardarVariable(this.nombre, Type.UNDEFINED, null, this.tiposim, this.linea, this.columna);
        }
    }
}