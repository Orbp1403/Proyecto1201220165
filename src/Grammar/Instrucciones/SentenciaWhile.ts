import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";
import { Retorno, Type } from '../Retorno';
import { _Error } from '../Error';

export class SentenciaWhile extends Instruccion{
    constructor(private condicion : Expresion, private cuerpo : Instruccion, linea : number, columna : number){
        super(linea, columna);
    }
    
    public ejecutar(entorno: Entorno) {
        let condicion = this.condicion.ejecutar(entorno);
        if(condicion.type == Type.BOOLEANO)
        {
            let retorno : Retorno = {
                value : "",
                type : Type.CADENA
            };
            while(condicion.value == true)
            {
                const elemento = this.cuerpo.ejecutar(entorno);
                if(elemento != null || elemento != undefined)
                {
                    retorno.value += elemento.value;
                }
                condicion = this.condicion.ejecutar(entorno);
                if(condicion.type != Type.BOOLEANO)
                {
                    throw new _Error(this.condicion.linea, this.condicion.columna, "Semantico", "La condicion de la sentencia while no es booleana");
                }
            }
            return retorno;
        }
        else
        {
            throw new _Error(this.condicion.linea, this.condicion.columna, "Semantico", "La condicion de la sentencia while no es booleana");
        }
    }
}