import { Expresion } from "../Expresion";
import { Retorno, Type } from "../Retorno";
import { OpcionesAritmeticas } from "./Opcionesaritmeticas";
import { Entorno } from "../Entorno/Entorno";

export class Aritmeticas extends Expresion{

    constructor(private izquierdo : Expresion, private derecho : Expresion, private tipo : OpcionesAritmeticas, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno : Entorno): Retorno {
        const izquierdo = this.izquierdo.ejecutar(entorno);
        const derecho = this.derecho.ejecutar(entorno);
        let resultado : Retorno;
        if(this.izquierdo != null && this.derecho != null){
            if(this.tipo == OpcionesAritmeticas.MAS){
                //TODO verificacion de tipos
                resultado = {value : (izquierdo.value.toString() + derecho.value.toString()), type : Type.NUMERO}
            }else if(this.tipo == OpcionesAritmeticas.MENOS){
                //TODO verificacion de tipos
                resultado = {value : (izquierdo.value.toString() + derecho.value.toString()), type : Type.NUMERO}
            }else if(this.tipo == OpcionesAritmeticas.POR){
                //TODO verificacion de tipos
                resultado = {value : (izquierdo.value.toString() + derecho.value.toString()), type : Type.NUMERO}
            }else{
                if(derecho.value == 0){
                    //TODO error division por 0
                }
                resultado = {value : (izquierdo.value.toString() / derecho.value.toString()), type : Type.NUMERO}
            }
        }else{
            
        }
        return resultado;
    }

}