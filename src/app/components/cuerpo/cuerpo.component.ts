import {
  Component,
  OnInit,
  ɵSWITCH_CHANGE_DETECTOR_REF_FACTORY__POST_R3__,
  EventEmitter,
} from '@angular/core';
import { CompileSummaryKind } from '@angular/compiler';
import * as go from 'gojs';
import { Nodo } from 'src/Grammar/Arbol/Nodo';
import { ValoresRetorno } from 'src/Grammar/Arbol/ValoresRetorno';
import *  as grammar from 'src/Grammar/Grammar/Grammar.js';
import { Entorno } from 'src/Grammar/Entorno/Entorno';
import { DeclaracionVarType } from 'src/Grammar/Instrucciones/DeclaracionVarType';
import { DeclaracionTipos } from 'src/Grammar/Instrucciones/DeclaracionTipos';
import { Declaracion } from 'src/Grammar/Instrucciones/Declaracion';
//declare const jquery-linedEtextarea.js

const $ = go.GraphObject.make;

@Component({
  selector: 'app-cuerpo',
  templateUrl: './cuerpo.component.html',
  styleUrls: ['./cuerpo.component.css'],
})

export class CuerpoComponent implements OnInit {
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

  code;
  output;
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
  errores : any;

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
    grammar.inicioerrores();
    const ast = parser.parse(this.code);
    this.errores = grammar.geterrores();
    const entorno = new Entorno(null, this.errores);
    if(this.errores.length != 0)
    {
      this.hayerrores = true;
      let contador = 1;
      for(let i = 0; i < this.errores.length; i++)
      {
        this.errores[i].setNumero(contador);
        contador++;
      } 
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
      console.log(ast.instrucciones)
      this.sacar_types(ast.instrucciones, entorno);
      this.sacar_variables(ast.instrucciones, entorno);
      console.log(entorno);
      console.log(this.errores)
      if(this.errores.length != 0)
      {
        this.hayarbol = false;
        this.hayerrores = true;
        let contador = 1;
        for(let i = 0; i < this.errores.length; i++)
        {
          this.errores[i].setNumero(contador);
          contador++;
        }
      }
    }
  }

  async sacar_types(instrucciones : any, entorno : Entorno)
  {
    for(let i = 0; i < instrucciones.length; i++)
    {
      console.log('entro')
      let instruccion = instrucciones[i];
      console.log(instruccion)
      try
      {
        if(instruccion instanceof DeclaracionTipos)
        {
          console.log("entro")
          instruccion.ejecutar(entorno);
        }
      }
      catch(error)
      {
        console.log(error);
        this.errores.push(error);
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
        if(instruccion instanceof Declaracion)
        {
          console.log(instruccion);
          instruccion.ejecutar(entorno);
        }
      }
      catch(error)
      {
        this.errores.push(error);
      }
    }
  }

  async dibujar(){
    document.getElementById('contenedor').style.display = 'block';
    this.volverarbol(this.raiz);
    console.log(this.arbol);
    console.log(this.relaciones)
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
    console.log(this.arbol)
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
      console.log("raiz");
      console.log(raiz);
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
