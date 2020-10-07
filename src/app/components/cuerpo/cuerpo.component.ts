import {
  Component,
  OnInit,
  ɵSWITCH_CHANGE_DETECTOR_REF_FACTORY__POST_R3__,
  EventEmitter,
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
    this.terminal = "";
    lerrores.splice(0, lerrores.length);
    entornos.splice(0, entornos.length);
    this.mostrarerrores = false;
    const ast = parser.parse(this.code);
    const entorno = new Entorno(null);
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
            if(instruccion instanceof DeclaracionTipos || instruccion instanceof Declaracion || instruccion instanceof Funcion)
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
        }
        else 
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
      }
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
        if(instruccion instanceof Declaracion)
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