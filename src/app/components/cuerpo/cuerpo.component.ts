import { Component, OnInit, ɵSWITCH_CHANGE_DETECTOR_REF_FACTORY__POST_R3__ } from '@angular/core';
import * as $ from 'jquery';

@Component({
  selector: 'app-cuerpo',
  templateUrl: './cuerpo.component.html',
  styleUrls: ['./cuerpo.component.css']
})
export class CuerpoComponent implements OnInit {

  constructor() {
  }

  ngOnInit(): void {
    var pos = document.getElementById("labelpos");
    pos.textContent = "Columna: 0, Fila: 0";
    $(document).ready(function () {
      $("#txtcod").bind("keydown keypress", function (e) {
          var cursorPosition = $("#txtcod").prop("selectionStart");
          console.log(cursorPosition);
      }).trigger('propertychange');;
    });
  }

  onchange(value : string){
    var ultimatecla = value[value.length - 1];
    console.log(ultimatecla);
    if(ultimatecla != undefined){
      //para separar el label
      var pos = document.getElementById("labelpos");
      var contenidopos = pos.textContent;
      var auxcontenidopos = contenidopos.split(',');
      var columna = +auxcontenidopos[0].split(': ')[1];
      var fila = +auxcontenidopos[1].split(': ')[1];
      //termina de separa el label
      //separa el contenido
      var contenido = value.split('\n');
      console.log(contenido);
      //termina de separar el contenido
      if(ultimatecla == '\n'){
        console.log("es enter");
        fila = contenido.length
        console.log(contenido[contenido.length - 1]);
        var auxcol = contenido[contenido.length - 1]
        columna = auxcol.length;
      }else{
        console.log("no es enter");
        fila = contenido.length
        var auxcol = contenido[contenido.length - 1]
        columna = auxcol.length;
        console.log(columna);
      }
      console.log(fila);
      console.log(columna);
      pos.textContent = "Columna: " + columna + ", Fila: " + fila;
    }
  }
}
