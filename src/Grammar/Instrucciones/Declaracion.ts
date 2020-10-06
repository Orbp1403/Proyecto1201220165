    import { Instruccion } from "../Instruccion";
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion';
import { TiposSimbolo } from '../Entorno/Simbolo';
import { Type } from '../Retorno';
import { Asignacion } from './Asignacion'
import { _Error } from '../Error';
import { ValoresTipo } from '../Expresiones/VariablesTipo';
import { Llamada } from './Llamada';

export class Declaracion extends Instruccion{
    private nombre : string;
    private valor : any;
    private tiposim : TiposSimbolo
    private tipovar : any;

    constructor(nombre : string, valor : any, tipovar : any, tiposim : TiposSimbolo, linea : number, columna : number){
        super(linea, columna);
        this.nombre = nombre;
        this.valor = valor;
        this.tiposim = tiposim;
        this.tipovar = tipovar;
    }

    public ejecutar(entorno: Entorno) {
        console.log(this.valor);
        if(this.valor != null && this.tipovar != null)
        {   
            if(this.valor instanceof Expresion)
            {
                console.log("entro aqui")
                const valor = this.valor.ejecutar(entorno);
                if(valor.type == this.tipovar)
                {
                    entorno.guardarVariable(this.nombre, valor.type, valor.value, this.tiposim, this.linea, this.columna);
                }
                else 
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "El tipo declarado no es el mismo que el tipo del valor")
                }
            }
            else
            {
                if(this.valor instanceof Llamada)
                {
                    const valor = this.valor.ejecutar(entorno);
                    console.log("Es llamada");
                    if(this.tipovar == valor.type){
                        entorno.guardarVariable(this.nombre, valor.type, valor.value, this.tiposim, this.linea, this.columna);
                    }else{
                        throw new _Error(this.linea, this.columna, "Semantico", "El tipo de la variable no coincide con el valor de retorno.");
                    }
                    // TODO ejecutar funciones para las llamadas
                }
                else
                {
                    let tipo = entorno.getTipo(this.tipovar);
                    if(tipo == null)
                    {
                        throw new _Error(this.linea, this.columna, "Semantico", "El tipo de la variable no existe en los types declarados");
                    }
                    if(tipo.atributos_tipo.length == this.valor.length)
                    {
                        let existentodos = new Array();
                        for(let i = 0; i < tipo.atributos_tipo.length; i++)
                        {
                            existentodos.push(false);
                        }
                        // * verifica si todos los atributos del type estan 
                        for(let i = 0; i < tipo.atributos_tipo.length; i++)
                        {
                            let atributo = tipo.atributos_tipo[i];
                            for(let j = 0; j < this.valor.length; j++)
                            {
                                if(atributo.getNombre() == this.valor[j].nombre)
                                {
                                    existentodos[i] = true;
                                    break;
                                }
                            }
                        }
                        for(let i = 0; i < existentodos.length; i++)
                        {
                            if(existentodos[i] == false)
                            {
                                throw new _Error(this.linea, this.columna, "Semantico", "No se encuentran todos los atributos del type " + this.tipovar);
                            }
                        }
                        // * termina la verificacion
                        // * inicia la verificacion de los tipos de valores
                        for(let i = 0; i < tipo.atributos_tipo.length; i++)
                        {
                            let atributo = tipo.atributos_tipo[i];
                            for(let j = 0; j < this.valor.length; j++)
                            {
                                if(atributo.getNombre() == this.valor[i].nombre)
                                {
                                    let auxvalor = this.valor[i].valor.ejecutar(entorno);
                                    console.log(typeof(atributo.getTipo()))
                                    if(atributo.getTipo() != auxvalor.type || (auxvalor.type == Type.NULL && typeof(atributo.getTipo() == "string")))
                                    {
                                        throw new  _Error(this.linea, this.columna, "Semantico", "El tipo del atributo: " + atributo.getNombre() + " no coincide con el declarado.")
                                    }
                                }
                            }
                        }
                        // * termina la verficacion de los tipos de los valores
                        let auxvalor = new Array()
                        for(let i = 0; i < this.valor.length; i++)
                        {
                            let auxvalor1 =
                            {
                                valor : this.valor[i].valor.ejecutar(entorno),
                                nombre : this.valor[i].nombre
                            }
                            auxvalor.push(auxvalor1);
                        }
                        //* guarda la variable declarada de tipo type
                        entorno.guardarVariable(this.nombre, this.tipovar, auxvalor, this.tiposim, this.linea, this.columna);
                    }
                    else
                    {
                        throw new _Error(this.linea, this.columna, "Semantico", "El numero de atributos no coinciden con el type");
                    }
                }
            }
        }
        else if(this.valor != null && this.tipovar == null)
        {
            if(this.valor instanceof Expresion)
            {
                const valor = this.valor.ejecutar(entorno);
                console.log(this.valor);
                entorno.guardarVariable(this.nombre, valor.type, valor.value, this.tiposim, this.linea, this.columna);
            }
            else if(this.valor instanceof Llamada)
            {
                const valor = this.valor.ejecutar(entorno);
                entorno.guardarVariable(this.nombre, valor.type, valor.value, this.tiposim, this.linea, this.columna);
                // TODO ejecutar funciones para las llamadas
            }
        }
        else if(this.valor == null && this.tipovar != null)
        {
            entorno.guardarVariable(this.nombre, this.tipovar, null, this.tiposim, this.linea, this.columna);
        }
        else
        {
            entorno.guardarVariable(this.nombre, Type.UNDEFINED, null, this.tiposim, this.linea, this.columna);
        }
    }
}