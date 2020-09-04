import { Simbolo, TiposSimbolo } from "./Simbolo"
import { Tipo } from "./Tipo"
import { Funcion } from "../Instrucciones/Funcion";
import { Type } from "../Retorno"

export class Entorno{
    private variables : Map<string, Simbolo>
    private funciones : Map<string, Funcion>
    private tipos : Map<string, Tipo> 

    constructor(public anterior : Entorno | null){
        this.variables = new Map();
        this.funciones = new Map();
    }

    //sirve para declarar variables y guardarlas en la tabla de simbolos
    public guardarVariable(nombre : string, tipo : Type, valor : any, tiposim : TiposSimbolo){
        let entorno : Entorno | null = this;
        if(entorno != null){
            if(!entorno.variables.has(nombre)){
                entorno.variables.set(nombre, new Simbolo(valor, nombre, tipo, tiposim));
                return;
            }else{
                //TODO aqui iria el error de las variables repetidas
            }
        }
    }

    //TODO guardar funciones y modificar los valores de las variables guardadas en los entornos
}