import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { OpcionesAritmeticas } from '../Expresiones/Opcionesaritmeticas'
import { Expresion } from '../Expresion'
import { _Error } from '../Error';
import { Retorno, Type } from '../Retorno';
import { OperacionesLogicas } from '../Expresiones/Relacional';

export class Incremento extends Instruccion{
    constructor(private nombre : string,private opcion : OpcionesAritmeticas, private valor : Expresion, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        const valor_variable = entorno.getVariable(this.nombre);
        if(valor_variable != null)
        {
            console.log("valor_variable", valor_variable);
            if(valor_variable.tipo == Type.NUMERO)
            {
                let valor = this.valor.ejecutar(entorno);
                if(valor.type == Type.NUMERO)
                {
                    let retorno : Retorno = {
                        value : 0,
                        type : Type.NUMERO
                    };
                    if(this.opcion == OpcionesAritmeticas.MAS)
                    {
                        retorno.value = (Number)(valor_variable.valor.toString()) + (Number)(valor.value.toString());
                    }
                    else if(this.opcion == OpcionesAritmeticas.MENOS)
                    {
                        retorno.value = (Number)(valor_variable.valor.toString()) - (Number)(valor.value.toString());
                    }
                    else if(this.opcion == OpcionesAritmeticas.DIV)
                    {
                        if((Number)(valor.value.toString()) != 0)
                        {
                            retorno.value = (Number)(valor_variable.valor.toString()) / (Number)(valor.value.toString());
                        }
                        else
                        {
                            throw new _Error(this.linea, this.columna, "Semantico", "Division por 0");
                        }
                    }
                    else if(this.opcion == OpcionesAritmeticas.MODULO)
                    {
                        if((Number)(valor.value.toString()) != 0)
                        {
                            retorno.value = (Number)(valor_variable.valor.toString()) % (Number)(valor.value.toString());
                        }
                        else
                        {
                            throw new _Error(this.linea, this.columna, "Semantico", "Division por 0");
                        }
                    }
                    else if(this.opcion == OpcionesAritmeticas.POR)
                    {
                        retorno.value = (Number)(valor_variable.valor.toString()) * (Number)(valor.value.toString());
                    }
                    else if(this.opcion == OpcionesAritmeticas.POTENCIA)
                    {
                        retorno.value = (Number)(valor_variable.valor.toString()) ** (Number)(valor.value.toString());
                    }
                    entorno.setValor_Variable(this.nombre, retorno);
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "El valor del aumento no es numerico");
                }
            }
            else
            {
                throw new _Error(this.linea, this.columna, "Semantico", "La variable a la que se le quiere dar aumento no es numerica");
            }
        }
        else
        {
            throw new _Error(this.linea, this.columna, "Semantico", "La variable a la que se le quiere dar un aumento no existe.");
        }
    }
}