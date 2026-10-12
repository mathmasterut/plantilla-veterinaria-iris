/// Una consulta veterinaria. Guarda REFERENCIAS a otros objetos
/// (la mascota y el veterinario), no copias de sus datos.
Class Vet.Consulta Extends %Persistent
{

Property Fecha As %TimeStamp [ InitialExpression = {$zdatetime($horolog, 3)}, Required ];

/// Referencia simple a un objeto persistente.
Property Mascota As Vet.Mascota [ Required ];

Property Veterinario As Vet.Veterinario [ Required ];

Property Motivo As %String(MAXLEN = 200) [ Required ];

Property Diagnostico As %String(MAXLEN = 500);

Property Costo As %Numeric(MINVAL = 0, SCALE = 2);

Index MascotaIndex On Mascota;

/// Crea y guarda una consulta. El costo lo calcula la propia mascota:
/// se llama a CostoConsulta() sin saber si es Perro o Gato (polimorfismo).
ClassMethod Registrar(idMascota As %String, idVeterinario As %String, motivo As %String, Output consulta As Vet.Consulta) As %Status
{
    set consulta = ""
    set mascota = ##class(Vet.Mascota).%OpenId(idMascota, , .sc)
    return:'$isobject(mascota) sc
    set veterinario = ##class(Vet.Veterinario).%OpenId(idVeterinario, , .sc)
    return:'$isobject(veterinario) sc

    set consulta = ..%New()
    set consulta.Mascota = mascota
    set consulta.Veterinario = veterinario
    set consulta.Motivo = motivo
    set consulta.Costo = mascota.CostoConsulta()
    return consulta.%Save()
}

/// Navegacion entre objetos con punto: consulta -> mascota -> propietario.
Method Resumen() As %String
{
    set propietario = $select($isobject(..Mascota.Propietario): ..Mascota.Propietario.Nombre, 1: "(sin propietario)")
    return ..Fecha _ " | " _ ..Mascota.Nombre _ " (" _ ..Mascota.Especie() _ ") de " _ propietario _ " | atendio: " _ ..Veterinario.Nombre _ " | motivo: " _ ..Motivo _ " | $" _ ..Costo
}

}
