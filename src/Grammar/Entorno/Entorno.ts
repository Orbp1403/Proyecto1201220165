import { Simbolo, TiposSimbolo } from "./Simbolo"
import { Tipo } from "./Tipo"
import { Funcion } from "../Instrucciones/Funcion";
import { Type } from "../Retorno"
import { ValoresTipo, VariablesTipo } from '../Expresiones/VariablesTipo';
import { _Error } from '../Error';
import { Expresion } from '../Expresion';
import { DeclaracionVarType } from '../Instrucciones/DeclaracionVarType';
import { ENOBUFS } from 'constants';

export class Entorno{
    private variables : Map<string, Simbolo>
    private funciones : Map<string, Funcion>
    private tipos : Map<string, Tipo> 
    private errores : any
    private nombre_entorno : string | null;

    constructor(public anterior : Entorno | null){
        this.variables = new Map();
        this.funciones = new Map();
        this.tipos = new Map();
    }

    public set_nombre(nombre : string | null)
    {
        this.nombre_entorno = nombre;
    }

    public get_nombre(){
        return this.nombre_entorno
    }

    public verificar_entorno_return(){
        let entorno : Entorno | null = this;
        while(entorno != null)
        {
            if(entorno.get_nombre() == "funcion"){
                return true;
            }
            entorno = entorno.anterior;
        }        
        return false;
    }

    public verificar_entorno_break(){
        let entorno : Entorno | null = this;
        while(entorno != null){
            if(entorno.get_nombre() == 'while' || entorno.get_nombre() == 'for' || entorno.get_nombre() == 'switch'){
                return true;
            }
            entorno = entorno.anterior;
        }
        return false;
    }

    public verificar_entorno_continue(){
        let entorno : Entorno | null = this;
        while(entorno != null){
            if(entorno.get_nombre() == 'while' || entorno.get_nombre() == 'for'){
                return true;
            }
            entorno = entorno.anterior;
        }
        return false;   
    }

    //sirve para declarar variables y guardarlas en la tabla de simbolos
    public guardarVariable(nombre : string, tipo : any, valor : any, tiposim : TiposSimbolo, linea : number, columna : number){
        let entorno : Entorno | null = this;
        if(entorno != null){
            if(!entorno.variables.has(nombre)){
                entorno.variables.set(nombre, new Simbolo(valor, nombre, tipo, tiposim, linea, columna));
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
            if(entorno.variables.has(nombre))
            {
                return entorno.variables.get(nombre);
            }
            entorno = entorno.anterior;
        }
        return null;
    }

    //asignar valor varibable
    public setValor_Variable(nombre : string, valor : any)
    {
        let entorno : Entorno | null = this
        while(entorno != null)
        {
            if(entorno.variables.has(nombre))
            {
                const auxvar = entorno.variables.get(nombre);
                if(auxvar.tipo == Type.UNDEFINED)
                {
                    auxvar.tipo = valor.type
                }
                auxvar.valor = valor;
                entorno.variables.set(nombre, new Simbolo(valor.value, auxvar.nombre, auxvar.tipo, auxvar.variable, auxvar.linea, auxvar.columna));
            }
            entorno = entorno.anterior;
        }
    }

    public getEntornoglobal(){
        let entorno : Entorno | null = this;
        while(entorno?.anterior != null){
            entorno = entorno.anterior;
        }
        return entorno;
    }

    public getVariables(){
        return this.variables;
    }

    public getFunciones(){
        return this.funciones;
    }

    public getTypes(){
        return this.tipos;
    }

    public getTipo(nombre : string)
    {
        let entorno : Entorno | null = this;
        while(entorno != null)
        {
            if(entorno.tipos.has(nombre))
            {
                return entorno.tipos.get(nombre);
            }
            entorno = entorno.anterior;
        }
        return null;
    }

    //guardar las funciones 
    public guardarFuncion(nombre : string, funcion : Funcion)
    {
        let entorno : Entorno | null = this;
        if(entorno != null)
        {
            if(!entorno.funciones.has(nombre))
            {
                entorno.funciones.set(nombre, funcion);
                return;
            }
            else
            {
                throw new _Error(funcion.getLinea(), funcion.getColumna(), "Semantico", "Ya existe una funcion con el nombre: " + nombre);
            }
        }
    }

    //guarda los types declarados en los archivos
    public guardarType(nombre : string, valores : VariablesTipo[], linea : number, columna : number)
    {
        let entorno : Entorno = this;
        if(!entorno.tipos.has(nombre))
        {
            entorno.tipos.set(nombre, new Tipo(nombre, valores));
        }
        else
        {
            throw new _Error(linea, columna, "Semantico", "Ya existe un type con el nombre: " + nombre);
        }
    }
    // obtener las funciones para su ejecucion en las llamadas

    public getFuncion(nombre : string) : Funcion
    {
        let entorno : Entorno | null = this;
        while(entorno != null)
        {
            if(entorno.funciones.has(nombre))
            {
                return entorno.funciones.get(nombre);
            }
            entorno = entorno.anterior;
        }
        return null;
    }

    public existeVariable(nombre : string) : boolean
    {
        let entorno : Entorno | null = this;
        while(entorno != null)
        {
            if(entorno.variables.has(nombre))
            {
                return true;
            }
            entorno = entorno.anterior;
        }
        return false;
    }
}

export let entornos : Array<string> = new Array();