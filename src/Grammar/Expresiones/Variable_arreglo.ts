import { Entorno } from '../Entorno/Entorno';
import { lerrores, _Error } from '../Error';
import { Expresion } from '../Expresion';
import { Retorno } from '../Retorno';

export class Variable_arreglo extends Expresion{
    constructor(private nombre : string, private indice : Expresion, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno): Retorno {
        let indice : any;
        let variable : any = entorno.getVariable(this.nombre);
        if(variable != null){
            if(variable.isarray){
                try{
                    console.log("variable", variable);
                    indice = this.indice.ejecutar(entorno);
                    console.log("indice", indice);
                }catch(error){
                    lerrores.push(error);
                    return;
                }
                if(indice.value < variable.size){
                    console.log(variable.valor[indice.value])
                    return variable.valor[indice.value];
                }else{
                    throw new _Error(this.linea, this.columna, "Semantico", "El indice se sale del arreglo.");
                }
            }else{
                throw new _Error(this.linea, this.columna, "Semantico", "La variable " + this.nombre + " no es un arreglo.");
            }
        }else{
            throw new _Error(this.linea, this.columna, "Semantico", "La variable " + this.nombre + " no se encuentra declarada")
        }
    }
}