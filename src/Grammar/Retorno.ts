export enum Type{
    NUMERO = 0,
    CADENA = 1,
    BOOLEANO = 2,
    NULL = 3,
    ARREGLO = 4,
    UNDEFINED = 5,
    VOID = 6,
    IDENTIFICADOR = 7
}

export type Retorno = {
    value : any,
    type : Type
}