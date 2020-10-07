import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion';
import { _Error } from '../Error';

export class SentenciaReturn extends Instruccion{
    constructor(private valor_retorno : Expresion | null, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        if(entorno.verificar_entorno_return()){
            let valor_retorno;
            if(this.valor_retorno != null)
            {
                valor_retorno = this.valor_retorno.ejecutar(entorno);
            }else
            {
                valor_retorno = null;
            }
              
            let retorno = {
                tipo : 'retorno',
                valor : valor_retorno,
                linea : this.linea,
                columna : this.columna
            }
            return retorno;
        }else{
            throw new _Error(this.linea, this.columna, "Semantico", "Un return solo puede venir dentro de una funcion");
        }
    }
}