import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { _Error } from '../Error';

export class Break extends Instruccion{
    constructor(linea : number, columna : number){
        super(linea, columna)
    }

    public ejecutar(entorno: Entorno) {
        if(entorno.verificar_entorno_break()){
            let valorretorno = {
                tipo : 'break',
                valor : null,
                linea : this.linea,
                columna : this.columna
            };
            return valorretorno;
        }else{
            throw new _Error(this.linea, this.columna, "Semantico", "Un break puede venir unicamente dentro de un ciclo o la sentencia switch");
        }
    }
}