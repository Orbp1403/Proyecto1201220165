import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";
import { Retorno, Type } from '../Retorno';
import { textoaimprimir } from '../Arbol/ValoresRetorno';
import { lerrores } from '../Error';

export class Imprimir extends Instruccion{
    constructor(private valor : Expresion[], linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        let retorno : Retorno;
        retorno = {
            value : "",
            type : Type.CADENA
        }
        for(let i = 0; i < this.valor.length; i++)
        {
            try{
                let valor = this.valor[i].ejecutar(entorno);
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
                if(i != this.valor.length - 1){
                    retorno.value += ', ';
                }
            }catch(error)
            {
                lerrores.push(error);
            }
            
        }
        retorno.value += '\n';
        textoaimprimir.push(retorno.value);
        //return retorno;
    }

}