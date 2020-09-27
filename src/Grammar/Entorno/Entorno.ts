import { Simbolo, TiposSimbolo } from "./Simbolo"
import { Tipo } from "./Tipo"
import { Funcion } from "../Instrucciones/Funcion";
import { Type } from "../Retorno"
import { ValoresTipo, VariablesTipo } from '../Expresiones/VariablesTipo';
import { _Error } from '../Error';
import { Expresion } from '../Expresion';

export class Entorno{
    private variables : Map<string, Simbolo>
    private funciones : Map<string, Funcion>
    private tipos : Map<string, Tipo> 
    private errores : any

    constructor(public anterior : Entorno | null, errores : any){
        this.variables = new Map();
        this.funciones = new Map();
        this.tipos = new Map();
        this.errores = errores;
    }

    //sirve para declarar variables y guardarlas en la tabla de simbolos
    public guardarVariable(nombre : string, tipo : Type, valor : any, tiposim : TiposSimbolo, linea : number, columna : number){
        let entorno : Entorno | null = this;
        if(entorno != null){
            if(!entorno.variables.has(nombre)){
                entorno.variables.set(nombre, new Simbolo(valor, nombre, tipo, tiposim));
                return;
            }else{
                throw new _Error(linea, columna, "Semantico", "Ya existe una variable con el nombre: " + nombre)
            }
        }
    }

    //obtener las variables
    public getVariable(nombre : string)
    {
        let entorno : Entorno | null = this;
        while(entorno != null)
        {
            console.log("varibale", entorno.variables)
            if(entorno.variables.has(nombre))
            {
                return entorno.variables.get(nombre);
            }
            entorno = entorno.anterior;
        }
        return null;
    }

    //guarda los types declarados en los archivos
    public guardarType(nombre : string, valores : VariablesTipo[], linea : number, columna : number)
    {
        let entorno : Entorno = this;
        console.log(entorno);
        if(!entorno.tipos.has(nombre))
        {
            entorno.tipos.set(nombre, new Tipo(nombre, valores));
        }
        else
        {
            throw new _Error(linea, columna, "Semantico", "Ya existe un type con el nombre: " + nombre);
        }
    }
    //TODO guardar funciones y modificar los valores de las variables guardadas en los entornos
}