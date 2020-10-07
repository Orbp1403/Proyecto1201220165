import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { lerrores } from '../Error';

export class CasoDef extends Instruccion{
    constructor(private cuerpo : Instruccion[] | null, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        try{
            if(this.cuerpo != null){
                return this.cuerpo;
            }
        }catch(error){
            lerrores.push(error);
        }
    }
}