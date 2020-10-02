import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";
import { Retorno, Type } from '../Retorno';

export class Imprimir extends Instruccion{
    constructor(private valor : Expresion[], linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        let retorno : Retorno;
        console.log(this.valor);
        retorno = {
            value : "",
            type : Type.CADENA
        }
        for(let i = 0; i < this.valor.length; i++)
        {
            console.log("valor", this.valor[i].ejecutar(entorno));
            let valor = this.valor[i].ejecutar(entorno);
            console.log(valor);
            if(typeof(valor.type) == "string")
            {
                retorno.value += "{ ";
                for(let i = 0; i < valor.value.length; i++)
                {
                    retorno.value += valor.value[i].nombre + " : " + valor.value[i].valor.value;
                    if(i != valor.value.length - 1)
                    {
                        retorno.value += ", ";
                    }
                }
                retorno.value += "}";
            }
            else
            {
                retorno.value += valor.value.toString();
            }
            retorno.value += '\n';
            console.log(retorno);
        }
        return retorno.value;
    }

}