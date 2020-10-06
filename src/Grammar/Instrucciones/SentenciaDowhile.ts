import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";
import { Retorno, Type } from '../Retorno';
import { _Error } from '../Error';

export class SentenciaDowhile extends Instruccion{
    constructor(private condicion : Expresion, private cuerpo : Instruccion, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        let condicion = this.condicion.ejecutar(entorno);

        if(condicion.type != Type.BOOLEANO)
        {
            throw new _Error(this.condicion.linea, this.condicion.columna, "Semantico", "La condicion de la sentencia while no es booleana");
        }
        else
        {
            let retorno : Retorno = {
                value : "",
                type : Type.CADENA
            };
            let nuevoentorno = new Entorno(entorno);
            nuevoentorno.set_nombre("while");
            do{
                const elemento = this.cuerpo.ejecutar(nuevoentorno);
                if(elemento != null || elemento != undefined){
                    if(elemento.tipo == 'break'){
                        break;
                    }else if(elemento.tipo == 'continue'){
                        continue;
                    }else if(elemento.tipo == 'retorno'){
                        return elemento;
                    }
                }
                condicion = this.condicion.ejecutar(nuevoentorno);
                if(condicion.type != Type.BOOLEANO)
                {
                    throw new _Error(this.condicion.linea, this.condicion.columna, "Semantico", "La condicion de la sentencia while no es booleana")
                }
            }while(condicion.value == true);
            return retorno;
        }
    }
}