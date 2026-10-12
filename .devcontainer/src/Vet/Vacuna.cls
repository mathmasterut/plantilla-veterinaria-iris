/// Objeto SERIAL: cada vacuna se guarda dentro de la lista Vacunas de la mascota.
Class Vet.Vacuna Extends %SerialObject
{

Property Nombre As %String(MAXLEN = 60) [ Required ];

Property Fecha As %Date [ Required ];

Property Lote As %String(MAXLEN = 20);

Method Texto() As %String
{
    return ..Nombre _ " aplicada el " _ $zdate(..Fecha, 3) _ " (lote " _ ..Lote _ ")"
}

}
