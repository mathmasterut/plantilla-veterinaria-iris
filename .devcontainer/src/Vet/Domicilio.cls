/// Objeto SERIAL (embebido): no tiene identidad propia ni se guarda solo.
/// Vive DENTRO del objeto Propietario que lo contiene.
Class Vet.Domicilio Extends %SerialObject
{

Property Calle As %String(MAXLEN = 100);

Property Colonia As %String(MAXLEN = 60);

Property Ciudad As %String(MAXLEN = 60);

Property CodigoPostal As %String(MAXLEN = 5, PATTERN = "5N");

Method Texto() As %String
{
    return ..Calle _ ", " _ ..Colonia _ ", " _ ..Ciudad _ " CP " _ ..CodigoPostal
}

}
