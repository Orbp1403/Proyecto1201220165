import { Instruccion } from '../Instruccion';
import { Entorno } from '../Entorno/Entorno';
import { Type } from '../Retorno';
import { VariablesTipo } from '../Expresiones/VariablesTipo';

export class Funcion extends Instruccion{
    constructor(private nombre : string, private cuerpo : Instruccion, private parametros : Array<VariablesTipo>, private tipo : Type, linea : number, columna : number){
        super(linea, columna);
    }

    public getLinea(){
        return this.linea;
    }

    public getColumna()
    {
        return this.columna;
    }

    public getParametros(){
        return this.parametros;
    }

    public getCuerpo(){
        return this.cuerpo;
    }

    public getTipo(){
        return this.tipo;
    }

    public getNombre(){
        return this.nombre;
    }

    public ejecutar(entorno: Entorno) {
        entorno.guardarFuncion(this.nombre, this);
    }
}