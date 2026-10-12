/// Veterinario de la clinica. Hereda de Persona.
Class Vet.Veterinario Extends Vet.Persona
{

Property Cedula As %String(MAXLEN = 20) [ Required ];

Property Especialidad As %String(VALUELIST = ",General,Cirugia,Dermatologia,Exoticos") [ InitialExpression = "General", Required ];

/// No puede haber dos veterinarios con la misma cedula.
Index CedulaIndex On Cedula [ Unique ];

Method Rol() As %String
{
    return "Veterinario (" _ ..Especialidad _ ")"
}

}
