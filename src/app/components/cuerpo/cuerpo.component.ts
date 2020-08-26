import {
  Component,
  OnInit,
  ɵSWITCH_CHANGE_DETECTOR_REF_FACTORY__POST_R3__,
  EventEmitter,
} from '@angular/core';
import { CompileSummaryKind } from '@angular/compiler';
//declare const jquery-linedtextarea.js

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

  constructor() {}

  ngOnInit(): void {


  }

  async traducir(){

  }
  
  async ejecutar(){
    console.log(this.code);
  }

  async ejecutarsalida(){
    
  }
}
