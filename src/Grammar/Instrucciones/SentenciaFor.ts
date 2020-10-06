import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion';
import { Incremento } from './Incremento';
import { _Error } from '../Error';
import { Retorno, Type } from '../Retorno';
import { TiposSimbolo } from '../Entorno/Simbolo';

export class SentenciaFor extends Instruccion{
    constructor(private declaracion : number, private variablecontrol : string, private valor_inicio : Expresion, private condicion : Expresion, private expresion_aumento : Incremento, private cuerpo : Instruccion, linea : number, columna : number){
        super(linea, columna);
    }    

    public ejecutar(entorno: Entorno) {
        if(this.declaracion == 0)
        {
            const variable = entorno.getVariable(this.variablecontrol);
            if(variable != null)
            {
                const valor_inicio = this.valor_inicio.ejecutar(entorno)
                entorno.setValor_Variable(this.variablecontrol, valor_inicio);
                let condicion = this.condicion.ejecutar(entorno);
                let retorno : Retorno = {
                    value : "",
                    type : Type.CADENA
                }
                if(condicion.type == Type.BOOLEANO)
                {
                    while(condicion.value == true)
                    {
                        const instruccion = this.cuerpo.ejecutar(entorno);
                        if(instruccion != null || instruccion != undefined)
                        {
                            retorno.value += instruccion.value;
                        }
                        const aumento = this.expresion_aumento.ejecutar(entorno);
                        condicion = this.condicion.ejecutar(entorno);
                        if(condicion.type != Type.BOOLEANO)
                        {
                            throw new _Error(this.linea, this.columna, "Semantico", "La condicion no es booleana");        
                        }
                    }
                    return retorno;
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "La condicion no es booleana");
                }
            }
            else
            {
                throw new _Error(this.linea, this.columna, "Semantico", "La variable " + this.variablecontrol + " no se encuentra declarada.");
            }
        }
        else
        {
            let nuevoentorno : Entorno = new Entorno(entorno);
            let valor_inicio = this.valor_inicio.ejecutar(nuevoentorno);
            nuevoentorno.guardarVariable(this.variablecontrol, valor_inicio.type, valor_inicio.value, TiposSimbolo.VAR, this.linea, this.columna);
            console.log("nuevoentorno", nuevoentorno);
            console.log("condicion", this.condicion);
            nuevoentorno.set_nombre("for");
            let condicion = this.condicion.ejecutar(nuevoentorno);
            let retorno : Retorno = {
                value : "",
                type : Type.CADENA
            }
            if(condicion.type == Type.BOOLEANO)
            {
                while(condicion.value == true)
                {
                    const instruccion = this.cuerpo.ejecutar(nuevoentorno);
                    if(instruccion != null || instruccion != undefined)
                    {
                        if(instruccion.tipo == 'break'){
                            break;
                        }else if(instruccion.tipo == 'continue'){
                            const aumento = this.expresion_aumento.ejecutar(nuevoentorno);
                            condicion = this.condicion.ejecutar(nuevoentorno);
                            if(condicion.type != Type.BOOLEANO)
                            {
                                throw new _Error(this.linea, this.columna, "Semantico", "La condicion no es booleana");        
                            }
                            continue;
                        }else if(instruccion.tipo == 'retorno'){
                            return instruccion;
                        }
                    }
                    const aumento = this.expresion_aumento.ejecutar(nuevoentorno);
                    condicion = this.condicion.ejecutar(nuevoentorno);
                    if(condicion.type != Type.BOOLEANO)
                    {
                        throw new _Error(this.linea, this.columna, "Semantico", "La condicion no es booleana");        
                    }
                }
                return retorno;
            }
            else
            {
                throw new _Error(this.linea, this.columna, "Semantico", "La condicion no es booleana");
            }
        }
    }
    
}