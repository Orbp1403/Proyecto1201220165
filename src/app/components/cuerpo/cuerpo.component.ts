import { Component, OnInit, ɵSWITCH_CHANGE_DETECTOR_REF_FACTORY__POST_R3__, EventEmitter } from '@angular/core';
import * as $ from 'jquery';
import { CompileSummaryKind } from '@angular/compiler';

@Component({
  selector: 'app-cuerpo',
  templateUrl: './cuerpo.component.html',
  styleUrls: ['./cuerpo.component.css']
})
export class CuerpoComponent implements OnInit {

  constructor() {
  }

  ngOnInit(): void {
    $(document).ready(function () {
      $("#text-area").bind("keydown keypress", function () {
        var cursorPosition = $("#text-area").prop("selectionStart");
        console.log(cursorPosition);
      }).trigger('propertychange');;
    
      // Target all classed with ".lined"
      $(".lined").linedtextarea(
        {selectedLine: 1}
      );
    
      // Target a single one
      $("#text-area").linedtextarea();
    
    });
    
    
    //TODO posicion del cursor
  }
}