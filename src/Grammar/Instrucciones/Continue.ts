import { Entorno } from '../Entorno/Entorno';
import { _Error } from '../Error';
import { Instruccion } from '../Instruccion';

export class Continue extends Instruccion{
    constructor(linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        if(entorno.verificar_entorno_continue()){
            let valorretorno = {
                tipo : 'continue',
                valor : null
            }
            return valorretorno;
        }else{
            throw new _Error(this.linea, this.columna, "Semantico", "Un continue puede venir unicamente dentro de un ciclo");
        }
    }   
}