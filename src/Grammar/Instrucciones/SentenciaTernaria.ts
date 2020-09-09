import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion'
import { Retorno } from '../Retorno';

export class SentenciaTernaria extends Instruccion{
    public constructor (private condicion : Expresion, private sentenciaverdadera : Expresion | Instruccion, private sentenciafalsa : Expresion | Instruccion, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        throw new Error("Method not implemented.");
    }
}