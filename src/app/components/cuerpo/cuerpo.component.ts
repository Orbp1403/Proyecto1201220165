import { Component, OnInit, ɵSWITCH_CHANGE_DETECTOR_REF_FACTORY__POST_R3__ } from '@angular/core';

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
    pos.textContent = "Posicion: Columna: 0, Fila: 0";
  }
}
