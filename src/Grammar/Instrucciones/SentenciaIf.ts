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
        console.log("ejecutar if");
        const condicion = this.condicion.ejecutar(entorno);
        if(condicion.type == Type.BOOLEANO)
        {
            if(condicion.value == true)
            {
                return this.cuerpo.ejecutar(entorno);
            }
            else
            {
                return this.SentenciaElse.ejecutar(entorno);
            }
        }
        else
        {
            throw new _Error(this.condicion.linea, this.condicion.columna, "Semantico", "La sentencia if debe de tener una condicion que sea booleana")
        }
    }

}