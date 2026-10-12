/// Superclase de todas las personas de la clinica.
/// Propietario y Veterinario HEREDAN de esta clase: comparten sus
/// propiedades y metodos, y se guardan en la misma "extension" (extent).
Class Vet.Persona Extends %Persistent
{

Property Nombre As %String(MAXLEN = 100) [ Required ];

Property Telefono As %String(MAXLEN = 20);

Property Email As %String(MAXLEN = 100);

/// Metodo que las subclases SOBRESCRIBEN (polimorfismo).
Method Rol() As %String
{
    return "Persona"
}

Method Presentarse() As %String
{
    return ..Rol() _ ": " _ ..Nombre
}

}
