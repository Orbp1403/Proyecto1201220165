import { Entorno } from '../Entorno/Entorno';
import { TiposSimbolo } from '../Entorno/Simbolo';
import { lerrores, _Error } from '../Error';
import { Expresion } from '../Expresion';
import { Instruccion } from '../Instruccion';
import { Retorno, Type } from '../Retorno';

export class Declaracion_Arreglo extends Instruccion{
    constructor(private nombre : string, private size : number | null, private tipo : Type | null, private valor : Expresion[] | null, private tiposim : TiposSimbolo, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        let valor : Array<any> = new Array();
        if(this.valor != null){
            for(let i = 0; i < this.valor.length; i++){
                try{
                    let auxval = this.valor[i].ejecutar(entorno);
                    valor.push(auxval);
                }catch(error){
                    lerrores.push(error);
                    return;
                }
            }
            if(!this.verificartipos(valor)){
                throw new _Error(this.linea, this.columna, "Semantico", "Los tipos del arreglo no coinciden");
            }
        }
        if(this.size == null){
            this.size = valor.length;
        }else{
            if(!this.verificarsize(valor)){
                throw new _Error(this.linea, this.columna, "Semantico", "El tamaño del arreglo no coincide");
            }
        }
        try{
            entorno.guardarArray(this.nombre, this.tipo, valor, this.tiposim, this.linea, this.columna, this.size);
        }catch(error){
            lerrores.push(error);
        }
    }

    private verificarsize(valores : Array<any>) : boolean{
        return this.size == valores.length;
    }

    private verificartipos(valores : Array<any>) : boolean{
        let tipo : Type;
        if(this.tipo != null){
            tipo = this.tipo;
        }else{
            tipo = valores[0].type;
        }
        for(let i = 0; i < valores.length; i++){
            if(valores[i].type != tipo){
                return false;
            }
        }
        return true;
    }
}