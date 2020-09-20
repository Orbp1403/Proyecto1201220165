import { Component, OnInit } from '@angular/core';
import { graphviz } from 'd3-graphviz';

@Component({
  selector: 'app-arbol',
  templateUrl: './arbol.component.html',
  styleUrls: ['./arbol.component.css']
})
export class ArbolComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

  dibujar(arbol : string){
    graphviz('div').renderDot('digraph {a -> b}');
  }

}
