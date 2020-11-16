import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";
import { Type } from '../Retorno';
import { _Error } from '../Error';

export class SentenciaIf extends Instruccion{
    constructor(private condicion : Expresion, private cuerpo : Instruccion | null, private SentenciaElse : Instruccion | null,  linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        const condicion = this.condicion.ejecutar(entorno);
        if(condicion.type == Type.BOOLEANO)
        {
            if(condicion.value == true)
            {
                if(this.cuerpo != null){
                    let a = this.cuerpo.ejecutar(entorno);
                    return a
                }
            }
            else
            {
                if(this.SentenciaElse != null){
                    let a = this.SentenciaElse.ejecutar(entorno);
                    return a
                }
            }
        }
        else
        {
            throw new _Error(this.condicion.linea, this.condicion.columna, "Semantico", "La sentencia if debe de tener una condicion que sea booleana")
        }
    }

}