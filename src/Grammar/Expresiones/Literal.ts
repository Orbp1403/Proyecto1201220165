import { Entorno } from '../Entorno/Entorno';
import { Expresion } from "../Expresion"
import { Retorno, Type } from "../Retorno"

export class Literal extends Expresion{
    constructor(private valor : any, linea : number, columna : number, private type : number){
        super(linea, columna);
    }

    public ejecutar(entorno : Entorno) : Retorno{
        console.log("valor",this.valor, this.type);
        if(this.type == 0){
            return {value : Number(this.valor), type : Type.NUMERO}
        }else if(this.type == 1){
            return {value : this.valor, type : Type.CADENA}
        }else if(this.type == 2){
            if(this.valor == "true")
            {
                return {value : true, type : Type.BOOLEANO}
            }
            else
            {
                return {value : false, type : Type.BOOLEANO}
            }
        }else if(this.type == 3){
            return {value : this.valor, type : Type.NULL}
        }else if(this.type == 4){
            return {value : this.valor, type : Type.ARREGLO}
        }else if(this.type == 5){
            return {value : this.valor, type : Type.UNDEFINED}
        }
    }
}