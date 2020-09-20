export class Nodo
{
    private hijos : Array<Nodo>;
    constructor(private token : string | null, private terminal : string | null, private padre : Nodo | null)
    {
        this.hijos = new Array<Nodo>();
    }

    getValor()
    {
        if(this.token == null)
        {
            return this.terminal;
        }
        else
        {
            return this.token;
        }
    }

    getHijos()
    {
        return this.hijos;
    }

    addPadre(padre : Nodo)
    {
        this.padre = padre;
    }

    addHijos(hijos : Array<Nodo>)
    {
        this.hijos = hijos;
    }

    agregarHijos(hijos : Nodo)
    {
        this.hijos.push(hijos);
    }
}