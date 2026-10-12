/// Superclase de todas las mascotas. Perro y Gato HEREDAN de ella.
/// Al abrir una mascota por su ID, IRIS devuelve un objeto de la clase
/// real (Perro o Gato): eso es POLIMORFISMO.
Class Vet.Mascota Extends %Persistent
{

Property Nombre As %String(MAXLEN = 60) [ Required ];

Property FechaNacimiento As %Date;

Property PesoKg As %Numeric(MAXVAL = 200, MINVAL = 0.01, SCALE = 2) [ Required ];

/// COLECCION de objetos embebidos: las vacunas viven dentro de la mascota.
Property Vacunas As list Of Vet.Vacuna;

/// Lado "uno" de la relacion con Propietario.
Relationship Propietario As Vet.Propietario [ Cardinality = one, Inverse = Mascotas ];

Index PropietarioIndex On Propietario;

/// Las subclases sobrescriben este metodo.
Method Especie() As %String
{
    return "Mascota"
}

/// Costo base de una consulta. Cada subclase calcula el suyo.
Method CostoConsulta() As %Numeric
{
    return 300
}

/// Edad en anios cumplidos (vacio si no se conoce la fecha de nacimiento).
Method Edad() As %Integer
{
    return:(..FechaNacimiento = "") ""
    return ($zdate(+$horolog, 8) - $zdate(..FechaNacimiento, 8)) \ 10000
}

Method Describir() As %String
{
    set texto = ..Especie() _ " " _ ..Nombre _ " | " _ ..PesoKg _ " kg"
    set edad = ..Edad()
    if (edad '= "") {
        set texto = texto _ " | edad: " _ edad
    }
    if $isobject(..Propietario) {
        set texto = texto _ " | propietario: " _ ..Propietario.Nombre
    }
    return texto
}

/// Agrega una vacuna a la coleccion y guarda la mascota.
Method AplicarVacuna(nombre As %String, fecha As %Date, lote As %String = "") As %Status
{
    set vacuna = ##class(Vet.Vacuna).%New()
    set vacuna.Nombre = nombre
    set vacuna.Fecha = fecha
    set vacuna.Lote = lote
    do ..Vacunas.Insert(vacuna)
    return ..%Save()
}

Method ListarVacunas()
{
    write "Vacunas de ", ..Nombre, " (", ..Vacunas.Count(), "):", !
    for i = 1:1:..Vacunas.Count() {
        write "  ", i, ". ", ..Vacunas.GetAt(i).Texto(), !
    }
}

}
