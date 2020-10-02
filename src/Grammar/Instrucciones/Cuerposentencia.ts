import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Retorno, Type } from '../Retorno';
import { lerrores } from '../Error';

export class Cuerposentencia extends Instruccion{
    constructor(private cuerpo : Array<Instruccion>, linea : number , columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        let retorno : Retorno = {
            value : "",
            type : Type.CADENA
        };
        let nuevoentorno : Entorno = new Entorno(entorno);
        for(const instr of this.cuerpo)
        {
            try
            {
                const elementoejecutado = instr.ejecutar(nuevoentorno);
                if(elementoejecutado != null || elementoejecutado != undefined)
                {
                    retorno.value += elementoejecutado.value;
                }
            }
            catch(error)
            {
                lerrores.push(error);
            }
        }
        return retorno
    }
    
}