import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion'
import { Retorno, Type } from '../Retorno';
import { _Error } from '../Error';

export class SentenciaTernaria extends Instruccion{
    public constructor (private condicion : Expresion, private sentenciaverdadera : Expresion | Instruccion, private sentenciafalsa : Expresion | Instruccion, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        const condicion = this.condicion.ejecutar(entorno);
        if(condicion.type == Type.BOOLEANO){
            if(condicion.value == true){
                return this.sentenciaverdadera.ejecutar(entorno);
            }else{
                return this.sentenciafalsa.ejecutar(entorno);
            }
        }
        else{
            throw new _Error(this.linea, this.columna, "Semantico", "La condicion no es booleana");
        }
    }
}