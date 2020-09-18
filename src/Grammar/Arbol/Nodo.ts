export class Nodo
{
    constructor(private token : string | null, private terminal : string | null, private padre : Nodo | null, private hijos : Array<Nodo> | null)
    {

    }

    addPadre(padre : Nodo)
    {
        this.padre = padre;
    }

    addHijos(hijos : Array<Nodo>)
    {
        this.hijos = hijos;
    }
}