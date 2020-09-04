import { Instruccion } from '../Instruccion'
import { Entorno } from '../Entorno/Entorno';
import { Expresion } from '../Expresion';
import { Incremento } from './Incremento';

export class SentenciaFor extends Instruccion{
    constructor(private variablecontrol : string, private valor_inicio : Expresion, private condicion : Expresion, private expresion_aumento : Incremento, private cuerpo : Instruccion, linea : number, columna : number){
        super(linea, columna);
    }    

    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }
    
}