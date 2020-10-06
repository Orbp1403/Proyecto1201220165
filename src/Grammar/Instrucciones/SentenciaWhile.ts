import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";
import { Retorno, Type } from '../Retorno';
import { lerrores, _Error } from '../Error';

export class SentenciaWhile extends Instruccion{
    constructor(private condicion : Expresion, private cuerpo : Instruccion, linea : number, columna : number){
        super(linea, columna);
    }
    
    public ejecutar(entorno: Entorno) {
        let nuevoentorno = new Entorno(entorno);
        nuevoentorno.set_nombre("while")
        let condicion = this.condicion.ejecutar(nuevoentorno);
        if(condicion.type == Type.BOOLEANO)
        {
            let retorno : Retorno = {
                value : "",
                type : Type.CADENA
            };
            while(condicion.value == true)
            {
                try{
                    const elemento = this.cuerpo.ejecutar(nuevoentorno);
                    console.log("elemento",elemento)
                    if(elemento != null || elemento != undefined)
                    {
                        if(elemento.tipo == 'break'){
                            break;
                        }else if(elemento.tipo == 'continue'){
                            continue;
                        }
                    }
                    condicion = this.condicion.ejecutar(nuevoentorno);
                    if(condicion.type != Type.BOOLEANO)
                    {
                        throw new _Error(this.condicion.linea, this.condicion.columna, "Semantico", "La condicion de la sentencia while no es booleana");
                    }
                }catch(error){
                    lerrores.push(error);
                }
                
            }
            return retorno;
        }
        else
        {
            throw new _Error(this.condicion.linea, this.condicion.columna, "Semantico", "La condicion de la sentencia while no es booleana");
        }
    }
}