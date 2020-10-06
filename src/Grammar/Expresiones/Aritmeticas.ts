import { Expresion } from "../Expresion";
import { Retorno, Type } from "../Retorno";
import { OpcionesAritmeticas } from "./Opcionesaritmeticas";
import { Entorno } from "../Entorno/Entorno";
import { type } from 'os';
import { _Error } from '../Error';
import { TYPED_NULL_EXPR } from '@angular/compiler/src/output/output_ast';

export class Aritmeticas extends Expresion{

    constructor(private izquierdo : Expresion, private derecho : Expresion, private tipo : OpcionesAritmeticas, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno : Entorno): Retorno {
        let resultado : Retorno;
        if(this.izquierdo != null && this.derecho != null){
            const izquierdo = this.izquierdo.ejecutar(entorno);
            const derecho = this.derecho.ejecutar(entorno);
            console.log("izquierdo", izquierdo);
            console.log("derecho", derecho);
            if(this.tipo == OpcionesAritmeticas.MAS)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) + Number(derecho.value.toString())), type : Type.NUMERO}  
                }
                else if((izquierdo.type == Type.NULL && derecho.type == Type.NUMERO) || (izquierdo.type == Type.NUMERO && derecho.type == Type.NULL))
                {
                    if(izquierdo.type == Type.NULL)
                    {
                        resultado = {value : (Number(derecho.value.toString())), type : Type.NUMERO}
                    }
                    else
                    {
                        resultado = {value : (Number(izquierdo.value.toString())), type : Type.NUMERO}
                    }
                }
                else if((izquierdo.type == Type.BOOLEANO && derecho.type == Type.NUMERO) || (izquierdo.type == Type.NUMERO && derecho.type == Type.BOOLEANO))
                {
                    if(izquierdo.type == Type.BOOLEANO)
                    {
                        let auxizquierdo;
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }

                        resultado = {value : auxizquierdo + Number(derecho.value.toString()), type : Type.NUMERO}
                    }
                    else
                    {
                        let auxderecho;
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1;
                        }
                        else
                        {
                            auxderecho = 0;
                        }
                        resultado = {value : Number(derecho.value.toString()) + auxderecho, type : Type.NUMERO}
                    }
                }
                else if(izquierdo.type == Type.CADENA && derecho.type == Type.CADENA)
                {
                    resultado = {value : (izquierdo.value.toString() + derecho.value.toString()), type : Type.CADENA}
                }
                else if((izquierdo.type == Type.NUMERO && derecho.type == Type.CADENA) || (izquierdo.type == Type.CADENA && derecho.type == Type.NUMERO))
                {
                    resultado = {value : (izquierdo.value.toString() + derecho.value.toString()), type : Type.CADENA}
                }
                else if((izquierdo.type == Type.BOOLEANO && derecho.type == Type.CADENA) || (izquierdo.type == Type.CADENA && derecho.type == Type.BOOLEANO))
                {
                    resultado = {value : (izquierdo.value.toString() + derecho.value.toString()), type : Type.CADENA}
                }
                else if((izquierdo.type == Type.NULL && derecho.type == Type.CADENA) || (izquierdo.type == Type.CADENA && derecho.type == Type.NULL))
                {
                    resultado = {value : (izquierdo.value.toString() + derecho.value.toString()), type : Type.CADENA}
                }
                else if((izquierdo.type == Type.UNDEFINED && derecho.type == Type.CADENA) || (izquierdo.type == Type.CADENA && derecho.type == Type.UNDEFINED))
                {
                    if(izquierdo.type == Type.UNDEFINED)
                    {
                        let auxizquierdo = "undefined";
                        resultado = {value : (auxizquierdo + derecho.value.toString()), type : Type.CADENA}
                    }
                    else
                    {
                        let auxderecho = "undefined";
                        resultado = {value : (izquierdo.value.toString() + auxderecho), type : Type.CADENA}
                    }
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    let auxderecho;
                    let auxizquierdo;
                    if(izquierdo.value.toString() == "true")
                    {
                        auxizquierdo = 1;
                    }
                    else
                    {
                        auxizquierdo = 0;
                    }
                    if(derecho.value.toString() == "true")
                    {
                        auxderecho = 1;
                    }
                    else
                    {
                        auxderecho = 0;
                    }
                    resultado = {value : (auxizquierdo + auxderecho), type : Type.NUMERO}
                }
                else if((izquierdo.type == Type.BOOLEANO && derecho.type == Type.NULL) || (izquierdo.type == Type.NULL && derecho.type == Type.BOOLEANO))
                {
                    if(izquierdo.type == Type.BOOLEANO)
                    {
                        let auxizquierdo;
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }
                        resultado = {value : (auxizquierdo.toString()), type : Type.NUMERO}
                    }
                    else
                    {
                        let auxderecho;
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1;
                        }
                        else
                        {
                            auxderecho = 0;
                        }
                        resultado = {value : auxderecho.toString(), type : Type.NUMERO}
                    }
                }
                else if(izquierdo.type == Type.NULL && derecho.type == Type.NULL)
                {
                    resultado = {value : 0, type : Type.NUMERO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se pueden sumar los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo == OpcionesAritmeticas.MENOS)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) - Number(derecho.value.toString())), type : Type.NUMERO}
                }
                else if((izquierdo.type == Type.NUMERO && derecho.type == Type.BOOLEANO) || (izquierdo.type == Type.BOOLEANO && derecho.type == Type.NUMERO))
                {
                    if(izquierdo.type == Type.NUMERO)
                    {
                        let auxderecho;
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1;
                        }
                        else
                        {
                            auxderecho = 0;
                        }
                        resultado = {value : (Number(izquierdo.value.toString()) - auxderecho), type : Type.NUMERO}
                    }
                    else
                    {
                        let auxizquierdo;
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }
                        resultado = {value : (auxizquierdo - Number(derecho.value.toString)), type : Type.NUMERO}
                    }
                }
                else if((izquierdo.type == Type.NUMERO && derecho.type == Type.NULL) || (izquierdo.type == Type.NULL && derecho.type == Type.NUMERO))
                {
                    if(izquierdo.type == Type.NUMERO)
                    {
                        resultado = {value : (Number(izquierdo.value.toString())), type : Type.NUMERO}
                    }
                    else
                    {
                        resultado = {value : 0 - (Number(izquierdo.value.toString())), type : Type.NUMERO}
                    }
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    let auxizquierdo;
                    let auxderecho;
                    if(izquierdo.value.toString() == "true")
                    {
                        auxizquierdo = 1;
                    }
                    else
                    {
                        auxizquierdo = 0;
                    }
                    if(derecho.value.toString() == "true")
                    {
                        auxderecho = 1;
                    }
                    else
                    {
                        auxderecho = 0;
                    }
                    resultado = {value : auxizquierdo - auxderecho, type : Type.NUMERO}
                }
                else if((izquierdo.type == Type.BOOLEANO && derecho.type == Type.NULL) || (derecho.type == Type.NULL && izquierdo.type == Type.BOOLEANO))
                {
                    if(izquierdo.type == Type.BOOLEANO)
                    {
                        let auxizquierdo;
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }
                        resultado = {value : auxizquierdo - 0, type : Type.NUMERO}
                    }
                    else
                    {
                        let auxderecho;
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1
                        }
                        else
                        {
                            auxderecho = 0;
                        }
                        resultado = {value : -auxderecho, type : Type.NUMERO}
                    }
                }
                else if(izquierdo.type == Type.NULL && derecho.type == Type.NULL)
                {
                    resultado = {value : 0, type : Type.NUMERO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se pueden restar los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type]);
                }
            }
            else if(this.tipo == OpcionesAritmeticas.POR)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) * Number(derecho.value.toString())), type : Type.NUMERO}
                }
                else if((izquierdo.type == Type.NUMERO && derecho.type == Type.BOOLEANO) || (izquierdo.type == Type.BOOLEANO && derecho.type ==Type.NUMERO))
                {
                    if(izquierdo.type == Type.NUMERO)
                    {
                        let auxderecho ;
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1;
                        }
                        else
                        {
                            auxderecho = 0;
                        }
                        resultado = {value : Number(izquierdo.value.toString()) * auxderecho, type : Type.NUMERO}
                    }
                    else
                    {
                        let auxizquierdo;
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }
                        resultado = {value : auxizquierdo * Number(derecho.value.toString()), type : Type.NUMERO}
                    }
                }
                else if((izquierdo.type == Type.NUMERO && derecho.type == Type.NULL) || (izquierdo.type == Type.NULL && derecho.type == Type.NUMERO))
                {
                    resultado = {value : 0, type : Type.NUMERO}
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    let auxizquierdo;
                    let auxderecho;
                    if(izquierdo.value.toString() == "true")
                    {
                        auxizquierdo = 1;
                    }
                    else
                    {
                        auxizquierdo = 0;
                    }
                    if(derecho.value.toString() == "true")
                    {
                        auxderecho = 1;
                    }
                    else
                    {
                        auxderecho = 0;
                    }
                    resultado = {value : auxizquierdo * auxderecho, type : Type.NUMERO}
                }
                else if((izquierdo.type == Type.BOOLEANO && derecho.type == Type.NULL) || (izquierdo.type == Type.NULL && derecho.type == Type.BOOLEANO))
                {
                    resultado = {value : 0, type : Type.NUMERO}
                }
                else if(izquierdo.type == Type.NULL && derecho.type == Type.NULL)
                {
                    resultado = {value : 0, type : Type.NUMERO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se pueden multiplicar los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type])
                }
            }else if(this.tipo == OpcionesAritmeticas.DIV)
            {
                console.log(derecho.value.toString())
                if(derecho.value.toString() == "0" || derecho.value.toString() == "false" || derecho.type == Type.NULL)
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "Division por 0")
                }
                else
                {
                    if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                    {
                        resultado = {value : (Number(izquierdo.value.toString()) / Number(derecho.value.toString())), type : Type.NUMERO}
                    }
                    else if((izquierdo.type == Type.NUMERO && derecho.type == Type.BOOLEANO) || (izquierdo.type == Type.BOOLEANO && derecho.type ==Type.NUMERO))
                    {
                        if(izquierdo.type == Type.NUMERO)
                        {
                            let auxderecho ;
                            if(derecho.value.toString() == "true")
                            {
                                auxderecho = 1;
                            }
                            resultado = {value : Number(izquierdo.value.toString()) / auxderecho, type : Type.NUMERO}
                        }
                        else
                        {
                            let auxizquierdo;
                            if(izquierdo.value.toString() == "true")
                            {
                                auxizquierdo = 1;
                            }
                            else
                            {
                                auxizquierdo = 0;
                            }
                            resultado = {value : auxizquierdo * Number(derecho.value.toString()), type : Type.NUMERO}
                        }
                    }
                    else if((izquierdo.type == Type.NULL && derecho.type == Type.NUMERO))
                    {
                        resultado = {value : 0, type : Type.NUMERO}
                    }
                    else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                    {
                        let auxizquierdo;
                        let auxderecho;
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1;
                        }
                        resultado = {value : auxizquierdo / auxderecho, type : Type.NUMERO}
                    }
                    else if((izquierdo.type == Type.NULL && derecho.type == Type.BOOLEANO))
                    {
                        resultado = {value : 0, type : Type.NUMERO}
                    }
                    else
                    {
                        throw new _Error(this.linea, this.columna, "Semantico", "No se pueden dividir los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type])
                    }
                }
            }
            else if(this.tipo == OpcionesAritmeticas.MODULO)
            {
                console.log(derecho.value.toString())
                if(derecho.value.toString() == "0" || derecho.value.toString() == "false" || derecho.type == Type.NULL)
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "Division por 0")
                }
                else
                {
                    if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                    {
                        resultado = {value : (Number(izquierdo.value.toString()) % Number(derecho.value.toString())), type : Type.NUMERO}
                    }
                    else if((izquierdo.type == Type.NUMERO && derecho.type == Type.BOOLEANO) || (izquierdo.type == Type.BOOLEANO && derecho.type ==Type.NUMERO))
                    {
                        if(izquierdo.type == Type.NUMERO)
                        {
                            let auxderecho ;
                            if(derecho.value.toString() == "true")
                            {
                                auxderecho = 1;
                            }
                            resultado = {value : Number(izquierdo.value.toString()) % auxderecho, type : Type.NUMERO}
                        }
                        else
                        {
                            let auxizquierdo;
                            if(izquierdo.value.toString() == "true")
                            {
                                auxizquierdo = 1;
                            }
                            else
                            {
                                auxizquierdo = 0;
                            }
                            resultado = {value : auxizquierdo % Number(derecho.value.toString()), type : Type.NUMERO}
                        }
                    }
                    else if((izquierdo.type == Type.NULL && derecho.type == Type.NUMERO))
                    {
                        resultado = {value : 0, type : Type.NUMERO}
                    }
                    else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                    {
                        let auxizquierdo;
                        let auxderecho;
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1;
                        }
                        resultado = {value : auxizquierdo % auxderecho, type : Type.NUMERO}
                    }
                    else if((izquierdo.type == Type.NULL && derecho.type == Type.BOOLEANO))
                    {
                        resultado = {value : 0, type : Type.NUMERO}
                    }
                    else
                    {
                        throw new _Error(this.linea, this.columna, "Semantico", "No se pueden dividir los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type])
                    }
                }
            }
            else if(this.tipo == OpcionesAritmeticas.POTENCIA)
            {
                if(izquierdo.type == Type.NUMERO && derecho.type == Type.NUMERO)
                {
                    resultado = {value : (Number(izquierdo.value.toString()) ** Number(derecho.value.toString())), type : Type.NUMERO}
                }
                else if((izquierdo.type == Type.NUMERO && derecho.type == Type.BOOLEANO) || (izquierdo.type == Type.BOOLEANO && derecho.type ==Type.NUMERO))
                {
                    if(izquierdo.type == Type.NUMERO)
                    {
                        let auxderecho ;
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1;
                        }
                        else
                        {
                            auxderecho = 0;
                        }
                        resultado = {value : Number(izquierdo.value.toString()) ** auxderecho, type : Type.NUMERO}
                    }
                    else
                    {
                        let auxizquierdo;
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }
                        resultado = {value : auxizquierdo ** Number(derecho.value.toString()), type : Type.NUMERO}
                    }
                }
                else if((izquierdo.type == Type.NUMERO && derecho.type == Type.NULL) || (izquierdo.type == Type.NULL && derecho.type == Type.NUMERO))
                {
                    resultado = {value : 0, type : Type.NUMERO}
                }
                else if(izquierdo.type == Type.BOOLEANO && derecho.type == Type.BOOLEANO)
                {
                    let auxizquierdo;
                    let auxderecho;
                    if(izquierdo.value.toString() == "true")
                    {
                        auxizquierdo = 1;
                    }
                    else
                    {
                        auxizquierdo = 0;
                    }
                    if(derecho.value.toString() == "true")
                    {
                        auxderecho = 1;
                    }
                    else
                    {
                        auxderecho = 0;
                    }
                    resultado = {value : auxizquierdo ** auxderecho, type : Type.NUMERO}
                }
                else if((izquierdo.type == Type.BOOLEANO && derecho.type == Type.NULL) || (izquierdo.type == Type.NULL && derecho.type == Type.BOOLEANO))
                {
                    let auxizquierdo;
                    let auxderecho;
                    if(izquierdo.type == Type.BOOLEANO)
                    {
                        if(izquierdo.value.toString() == "true")
                        {
                            auxizquierdo = 1;
                        }
                        else
                        {
                            auxizquierdo = 0;
                        }
                        auxderecho = 0
                    }
                    else
                    {
                        auxizquierdo = 0;
                        if(derecho.value.toString() == "true")
                        {
                            auxderecho = 1;
                        }
                        else
                        {
                            auxderecho = 0;
                        }
                    }
                    resultado = {value : auxizquierdo ** auxderecho, type : Type.NUMERO}
                }
                else if(izquierdo.type == Type.NULL && derecho.type == Type.NULL)
                {
                    resultado = {value : 1, type : Type.NUMERO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "No se puede realizar la potencia con los tipos: " + Type[izquierdo.type] + " y " + Type[derecho.type])
                }
            }
        }else{
            console.log(this.tipo);
            const izquierdo = this.izquierdo.ejecutar(entorno);
            if(this.tipo == OpcionesAritmeticas.NEGATIVO){
                if(izquierdo.type == Type.NUMERO)
                {
                    resultado = {value : - Number(izquierdo.value.toString()), type : Type.NUMERO}
                }
                else if(izquierdo.type == Type.BOOLEANO)
                {
                    if(izquierdo.value.toString() == "true")
                    {
                        resultado = {value : -1, type : Type.NUMERO}
                    }
                    else
                    {
                        resultado = {value : 0, type : Type.NUMERO}
                    }
                }
                else if(izquierdo.type == Type.NULL)
                {
                    resultado = {value : 0, type : Type.NUMERO}
                }
                else
                {
                    throw new _Error(this.linea, this.columna, "Semantico", "El operador unario '-', no puede usarse con el tipo: " + Type[izquierdo.type])
                }
            }
        }
        return resultado;
    }

}