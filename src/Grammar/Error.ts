export class _Error{
    private numero : number;

    constructor(private linea : number, private columna : number, private tipo : string, private mensaje : string){
    }

    public setNumero(numero : number){
        this.numero = numero;
    }
}

export let lerrores : Array<_Error> = new Array();