import { Instruccion } from "../Instruccion"
import { Entorno } from "./Entorno";

export class Funcion extends Instruccion{
    public ejecutar(entorno: Entorno) {
        throw new Error("Method not implemented.");
    }

}