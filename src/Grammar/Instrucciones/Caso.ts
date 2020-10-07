import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";
import { lerrores } from '../Error';

export class Caso extends Instruccion{
    constructor(private condicion : Expresion, private cuerpo : Instruccion[] | null, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        try{
            if(this.cuerpo != null){
                const condicion = this.condicion.ejecutar(entorno);
                return {
                    condicion : condicion,
                    valor : this.cuerpo,
                    linea_condicion : this.condicion.linea,
                    columna_condicion : this.condicion.columna
                }
                
            }
        }catch(error){
            lerrores.push(error);
        }
    }

}