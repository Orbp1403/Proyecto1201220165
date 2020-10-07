
import { TYPED_NULL_EXPR } from '@angular/compiler/src/output/output_ast';
import { Entorno } from "../Entorno/Entorno";
import { Elemento_tabla, tabla_simbolos } from '../Entorno/Tabla_simbolos';
import { Instruccion } from "../Instruccion";
import { Type } from '../Retorno';

export class GraficarTs extends Instruccion{
    constructor(linea : number, columna : number){
        super(linea, columna);
    }

    public ejecutar(entorno: Entorno) {
        let ent : Entorno | null = entorno;
        console.log("entro a graficarts");
        console.log('entorno', ent);
        let tabla : Elemento_tabla = new Elemento_tabla("Llamada a graficar_ts", "", "", this.linea, this.columna);
        tabla_simbolos.push(tabla);
        while(ent != null){
          let variables = ent.getVariables();
          let funciones = ent.getFunciones();
          console.log(variables);
          console.log(funciones);
          for(var [llave_variable, valor_variable] of variables){
              let elemento = {
                ambito : "",
                nombre : "",
                tipo : "",
                fila : 0,
                columna : 0
              };
              elemento.nombre = llave_variable;
              if(ent.anterior == null){
                  elemento.ambito = "global";
              }else{
                  elemento.ambito = "local"
              }
              if(valor_variable.tipo == Type.NUMERO){
                  elemento.tipo = "number"
              }else if(valor_variable.tipo == Type.CADENA){
                  elemento.tipo = "string";
              }else if(valor_variable.tipo == Type.BOOLEANO){
                  elemento.tipo = "boolean";
              }else if(valor_variable.tipo == Type.NULL){
                  elemento.tipo = "null";
              }else if(valor_variable.tipo == Type.UNDEFINED){
                  elemento.tipo = "undefined";
              }else{
                  elemento.tipo = (valor_variable.tipo);
              }
              elemento.fila = (valor_variable.linea);
              elemento.columna = (valor_variable.columna);
              tabla_simbolos.push(new Elemento_tabla(elemento.nombre, elemento.ambito, elemento.tipo, elemento.fila, elemento.columna));
          }
          console.log('paso');
          for(var [llave_funcion, valor_funcion] of funciones){
            let elemento = {
              ambito : "",
              nombre : "",
              tipo : "",
              fila : 0,
              columna : 0
            };
            elemento.nombre = llave_funcion;
            if(ent.anterior == null){
                elemento.ambito = "global";
            }else{
                elemento.ambito = "local"
            }
            if(valor_funcion.getTipo() == Type.NUMERO){
                elemento.tipo = "number"
            }else if(valor_funcion.getTipo() == Type.CADENA){
                elemento.tipo = "string";
            }else if(valor_funcion.getTipo() == Type.BOOLEANO){
                elemento.tipo = "boolean";
            }else if(valor_funcion.getTipo() == Type.VOID){
                elemento.tipo = "void";
            }
            elemento.fila = (valor_funcion.linea);
            elemento.columna = (valor_funcion.columna);
            tabla_simbolos.push(new Elemento_tabla(elemento.nombre, elemento.ambito, elemento.tipo, elemento.fila, elemento.columna));
          }
          ent = ent.anterior;
      }
    }
}