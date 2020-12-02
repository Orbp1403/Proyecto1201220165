import {
  Component,
  OnInit,
  ɵSWITCH_CHANGE_DETECTOR_REF_FACTORY__POST_R3__,
  EventEmitter, ElementRef
} from '@angular/core';
import { CompileSummaryKind } from '@angular/compiler';
import * as go from 'gojs';
import { Nodo } from 'src/Grammar/Arbol/Nodo';
import { textoaimprimir, ValoresRetorno } from 'src/Grammar/Arbol/ValoresRetorno';
import *  as grammar from 'src/Grammar/Grammar/Grammar.js';
import { Entorno, entornos } from 'src/Grammar/Entorno/Entorno';
import { DeclaracionVarType } from 'src/Grammar/Instrucciones/DeclaracionVarType';
import { DeclaracionTipos } from 'src/Grammar/Instrucciones/DeclaracionTipos';
import { Declaracion } from 'src/Grammar/Instrucciones/Declaracion';
import { Funcion } from 'src/Grammar/Instrucciones/Funcion';
import { SentenciaIf } from 'src/Grammar/Instrucciones/SentenciaIf';
import { Instruccion } from 'src/Grammar/Instruccion';
import { Imprimir } from 'src/Grammar/Instrucciones/Imprimir';
import { lerrores } from 'src/Grammar/Error';
import { Elemento_tabla, tabla_simbolos } from 'src/Grammar/Entorno/Tabla_simbolos';
import { Type } from 'src/Grammar/Retorno';
import { ViewChild } from '@angular/core'
import { Asignacion } from 'src/Grammar/Instrucciones/Asignacion';
import { Declaracion_Arreglo } from 'src/Grammar/Instrucciones/Declaracion_Arreglo';
//declare const jquery-linedEtextarea.js

const $ = go.GraphObject.make;

@Component({
  selector: 'app-cuerpo',
  templateUrl: './cuerpo.component.html',
  styleUrls: ['./cuerpo.component.css'],
})

export class CuerpoComponent implements OnInit {
  @ViewChild('tabla1') tabla1 : ElementRef
  name = 'Angular 6';
  OptionsCode: any = {
    theme: 'lucario',
    mode: 'application/typescript',
    lineNumbers: true,
    lineWrapping: true,
    foldGutter: true,
    gutters: [
      'CodeMirror-linenumbers',
      'CodeMirror-foldgutter',
      'CodeMirror-lint-markers',
    ],
    autoCloseBrackets: true,
    matchBrackets: true,
    lint: true,
    autofocus: true,
  };

  OptionsOutput: any = {
    theme: 'lucario',
    mode: 'application/typescript',
    lineNumbers: true,
    lineWrapping: true,
    foldGutter: true,
    gutters: [
      'CodeMirror-linenumbers',
      'CodeMirror-foldgutter',
      'CodeMirror-lint-markers',
    ],
    autoCloseBrackets: true,
    matchBrackets: true,
    lint: true,
    editable: false,
    readOnly: true,
  }

  OptionsTerminal : any = {
    theme : 'lucario',
    mode : 'text',
    lineNumbers : false,
    lineWrapping : true,
    editable : false,
    readOnly : true
  }

  code;
  output;
  terminal;
  public diagrama : go.Diagram = null;
  hayarbol : boolean = false;
  mostrararbol : boolean = false;
  arbol : any = null;
  relaciones : any = null;
  raiz : Nodo;
  clave : number;
  clavepadre : number;
  hayerrores : boolean = false;
  mostrarerrores : boolean = false;
  mostrartabla : boolean = false;
  errores : any;
  tablasimbolos : any;

  constructor() {}

  ngOnInit(): void {
    document.getElementById('contenedor').style.display = 'none';
  }

  async traducir(){

  }
  
  async ejecutar(){
    document.getElementById('contenedor').style.display = 'none';
    this.hayerrores = false;
    this.hayarbol = false;
    const parser = require('../../../Grammar/Grammar/Grammar')
    this.terminal = "";
    lerrores.splice(0, lerrores.length);
    entornos.splice(0, entornos.length);
    tabla_simbolos.splice(0, tabla_simbolos.length);
    this.mostrarerrores = false;
    const ast = parser.parse(this.code);
    const entorno = new Entorno(null);
    this.mostrartabla = false;
    if(lerrores.length != 0)
    {
      this.hayerrores = true;
      let contador = 1;
      for(let i = 0; i < lerrores.length; i++)
      {
        lerrores[i].setNumero(contador);
        contador++;
      } 
      this.errores = lerrores;
    }
    if(this.hayerrores == false)
    {
      this.hayarbol = true;
      if(this.diagrama != null)
      {
        this.diagrama.div = null;
      }
      this.mostrararbol = false;
      this.raiz = ast.nodo;
      this.sacar_types(ast.instrucciones, entorno);
      this.sacar_funciones(ast.instrucciones, entorno);
      this.sacar_variables(ast.instrucciones, entorno);
      if(lerrores.length != 0)
      {
        this.hayarbol = false;
        this.hayerrores = true;
        let contador = 1;
        for(let i = 0; i < lerrores.length; i++)
        {
          lerrores[i].setNumero(contador);
          contador++;
        }
        this.errores = lerrores;
      }
      else
      {
        textoaimprimir.splice(0, textoaimprimir.length);
        for(let i = 0; i < ast.instrucciones.length; i++)
        {
          let instruccion = ast.instrucciones[i];
          try
          {
            if(instruccion instanceof DeclaracionTipos || instruccion instanceof Declaracion || instruccion instanceof Funcion || instruccion instanceof Declaracion_Arreglo || instruccion instanceof Asignacion)
            {
              continue;
            }
            const cont = instruccion.ejecutar(entorno);
          }
          catch(error)
          {
            lerrores.push(error);
          }
          
        }
        if(lerrores.length == 0)
        {
          let textoaimprimir1 = "";
          for(let i = 0;  i < textoaimprimir.length; i++)
          {
            textoaimprimir1 += textoaimprimir[i];
          }
          this.terminal = textoaimprimir1;
          console.log(entorno);
          this.graficar_tabla(entorno);
          this.mostrartabla = true;
          for(let auxtabla of tabla_simbolos){
            console.log(auxtabla.nombre);
          }
          console.log(this.tabla1);
          this.tablasimbolos = tabla_simbolos;
        }
        else 
        {
          console.log(lerrores);
          this.hayarbol = false;
          this.hayerrores = true;
          let contador = 1;
          for(let i = 0; i < lerrores.length; i++)
          {
            lerrores[i].setNumero(contador);
            contador++;
          }
          this.errores = lerrores;
        }
      }
    }
  }

  async graficar_tabla(entorno : Entorno){
    let ent : Entorno | null = entorno;
    let tabla : Elemento_tabla = new Elemento_tabla("Ultima tabla de simbolos", "", "", 0, 0);
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
          console.log('tabla_simbolos', tabla_simbolos);
          ent = ent.anterior;
      }
  }

  async sacar_types(instrucciones : any, entorno : Entorno)
  {
    for(let i = 0; i < instrucciones.length; i++)
    {
      let instruccion = instrucciones[i];
      try
      {
        if(instruccion instanceof DeclaracionTipos)
        {
          instruccion.ejecutar(entorno);
        }
      }
      catch(error)
      {
        lerrores.push(error);
      }
    }
  }

  async sacar_variables(instrucciones : any, entorno : Entorno)
  {
    for(let i = 0; i < instrucciones.length; i++)
    {
      let instruccion = instrucciones[i];
      try
      {
        if(instruccion instanceof Declaracion || instruccion instanceof Asignacion || instruccion instanceof Declaracion_Arreglo)
        {
          instruccion.ejecutar(entorno);
        }
      }
      catch(error)
      {
        lerrores.push(error);
      }
    }
  }

  async sacar_funciones(instrucciones : any, entorno : Entorno) {
    for(let i = 0; i < instrucciones.length; i++)
    {
      let instruccion = instrucciones[i];
      try
      {
        if(instruccion instanceof Funcion)
        {
          instruccion.ejecutar(entorno);
        }
      }catch(error)
      {
        lerrores.push(error);
      }
    }
  }

  async dibujar(){
    document.getElementById('contenedor').style.display = 'block';
    this.volverarbol(this.raiz);
    this.mostrararbol = true;
    this.diagrama = $(go.Diagram, "arboldiv",
                    {
                      layout : $(go.TreeLayout,
                        {angle : 90})
                    });
    this.diagrama.nodeTemplate = 
    $(go.Node, "Auto",
      $(go.Shape, "RoundedRectangle",
        new go.Binding("fill", "color")),
      $(go.TextBlock,
        { margin: 5 },
        new go.Binding("text", "name"))
    );
    this.diagrama.model = new go.GraphLinksModel(
      this.arbol,
      this.relaciones);
  }

  async mostrar_errores(){
    this.mostrarerrores = true;
  }

  async ejecutarsalida(){
    
  }

  async volverarbol(raiz : Nodo)
  {
    this.arbol = new Array();
    this.relaciones = new Array();
    this.clave = 1;
    this.graficarnodos(raiz);
    this.clave = 1;
    this.relacionarnodos(raiz, this.clave);
  }

  async graficarnodos(raiz : Nodo)
  {
    if(raiz != null)
    {
      //let retorno = new ValoresRetorno(clave.toString(), raiz.getValor());
      this.arbol.push({key : "\"" + this.clave + "\"", name : raiz.getValor(), color : "lightblue"});
      if(raiz.getHijos() == null)
      {
        return;
      }
      for(var i = 0; i < raiz.getHijos().length; i++)
      {
        let hijo : Nodo = raiz.getHijos()[i];
        this.clave += 1
        this.graficarnodos(hijo);
      }
      return;
    }
  }

  async relacionarnodos(raiz : Nodo, clavepadre : number)
  {
    if(raiz != null)
    {
      if(raiz.getHijos() == null)
      {
        return;
      }
      for(var i = 0; i < raiz.getHijos().length; i++)
      {
        let hijo : Nodo = raiz.getHijos()[i];
        this.clave += 1;
        this.relaciones.push({from : "\"" + clavepadre + "\"", to: "\"" + this.clave + "\""})
        this.relacionarnodos(hijo, this.clave);
      }
    }
  }
}