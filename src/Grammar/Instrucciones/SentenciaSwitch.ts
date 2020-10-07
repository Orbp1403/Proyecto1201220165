import { Instruccion } from "../Instruccion";
import { Entorno } from "../Entorno/Entorno";
import { Expresion } from "../Expresion";
import { runInThisContext } from 'vm';
import { lerrores, _Error } from '../Error';
import { Caso } from './Caso';
import { CasoDef } from './CasoDef';

export class SentenciaSwitch extends Instruccion{
    constructor(private condicion : Expresion, private cuerpo : Instruccion[] | null, linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        if(this.cuerpo != null){
            let nuevoentorno : Entorno = new Entorno(entorno);
            nuevoentorno.set_nombre('switch');
            let condicioncumplida = false;
            let casedef : any = null;
            let indicedef = 0;
            let indicecasocorrecto = 0;
            try{
                const condicion = this.condicion.ejecutar(nuevoentorno);
                let casos : Array<any> = new Array();
                for(let i = 0; i < this.cuerpo.length; i++){
                    if(this.cuerpo[i] instanceof CasoDef){
                        casedef = this.cuerpo[i].ejecutar(nuevoentorno);
                        indicedef = i;
                        casos.push(casedef);
                    }else{
                        const casoejecutado = this.cuerpo[i].ejecutar(nuevoentorno);
                        if(casoejecutado.condicion.type == condicion.type){
                            casos.push(casoejecutado.valor);
                            if(casoejecutado.condicion.value == condicion.value){
                                indicecasocorrecto = i;
                                condicioncumplida = true;
                            }
                        }else{
                            throw new _Error(casoejecutado.linea_condicion, casoejecutado.columna_condicion, "Semantico", "El tipo no coincide en las condiciones")
                        }
                    }
                }

                let haybreak = false;
                if(condicioncumplida){
                    for(let i = indicecasocorrecto; i < casos.length;i++){
                        let auxcaso = casos[i];
                        for(let j = 0; j < auxcaso.length; j++){
                            const ejecucion = auxcaso[j].ejecutar(nuevoentorno);
                            if(ejecucion != null || ejecucion != undefined){
                                if(ejecucion.tipo == 'break'){
                                    haybreak = true;
                                    break;
                                }else if(ejecucion.tipo == 'retorno'){
                                    return ejecucion;
                                }
                            }
                        }
                        if(haybreak){
                            break;
                        }
                    }
                }else{
                    if(casedef != null){
                        for(let i = indicedef; i < casos.length; i++){
                            let auxcaso = casos[i];
                            for(let j = 0; j < auxcaso.length; j++){
                                const ejecucion = auxcaso[j].ejecutar(nuevoentorno);
                                if(ejecucion != null || ejecucion != undefined){
                                    if(ejecucion.tipo == 'break'){
                                        haybreak = true
                                        break;
                                    }else if(ejecucion.tipo == 'retorno'){
                                        return ejecucion;
                                    }
                                }
                            }
                            if(haybreak){
                                break;
                            }
                        }
                    }
                }
            }catch(error){
                lerrores.push(error);
            }
        }
    }

}