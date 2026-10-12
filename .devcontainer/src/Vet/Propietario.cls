/// Propietario de una o varias mascotas. Hereda de Persona.
Class Vet.Propietario Extends Vet.Persona
{

/// Objeto embebido (serial): sus datos se guardan dentro del propietario.
Property Domicilio As Vet.Domicilio;

/// RELACION uno a muchos: un propietario tiene muchas mascotas.
/// La base de datos mantiene ambos lados sincronizados.
Relationship Mascotas As Vet.Mascota [ Cardinality = many, Inverse = Propietario ];

Method Rol() As %String
{
    return "Propietario"
}

/// Recorre la coleccion de mascotas navegando entre objetos (sin JOIN).
Method ListarMascotas()
{
    write ..Nombre, " tiene ", ..Mascotas.Count(), " mascota(s):", !
    set clave = ""
    for {
        set mascota = ..Mascotas.GetNext(.clave)
        quit:clave=""
        write "  - ", mascota.Describir(), !
    }
}

}
