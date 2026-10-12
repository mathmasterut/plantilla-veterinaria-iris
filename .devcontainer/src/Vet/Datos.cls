/// Utilerias de la practica: carga de datos de ejemplo y reportes.
/// No es persistente: solo agrupa metodos de clase.
Class Vet.Datos
{

/// Borra todos los objetos de la practica (y reinicia los IDs).
ClassMethod Limpiar() As %Status
{
    do ##class(Vet.Consulta).%KillExtent()
    do ##class(Vet.Mascota).%KillExtent()
    do ##class(Vet.Persona).%KillExtent()
    write "Datos borrados.", !
    return $$$OK
}

/// Crea veterinarios, propietarios, mascotas, vacunas y consultas de ejemplo.
/// IDs resultantes:
///   Personas: 1 y 2 = veterinarios; 3 = Ana, 4 = Luis, 5 = Maria (propietarios)
///   Mascotas: 1 Firulais, 2 Rocky, 3 Michi, 4 Pelusa, 5 Toby
ClassMethod Cargar() As %Status
{
    set sc = $$$OK
    try {
        do ..Limpiar()

        // ---- Veterinarios (heredan de Persona) ----
        set v1 = ..NuevoVeterinario("Dra. Patricia Martinez", "4521873", "General")
        set v2 = ..NuevoVeterinario("Dr. Jorge Ramirez", "6187420", "Cirugia")

        // ---- Propietarios con domicilio embebido ----
        set ana = ..NuevoPropietario("Ana Lopez Hernandez", "771 123 4567", "Av. Juarez 120", "Centro", "Huejutla", "43000")
        set luis = ..NuevoPropietario("Luis Fernando Cruz", "771 987 6543", "Calle Hidalgo 45", "Tahuizan", "Huejutla", "43000")
        set maria = ..NuevoPropietario("Maria Torres Bautista", "789 555 0101", "Privada Morelos 8", "Aviacion", "Huejutla", "43000")

        // ---- Mascotas: objetos de distintas subclases ----
        set firulais = ..NuevoPerro("Firulais", "Mestizo", "Mediano", 18.5, "2021-05-10", ana)
        set rocky = ..NuevoPerro("Rocky", "Labrador", "Grande", 32, "2019-11-02", luis)
        set michi = ..NuevoGato("Michi", "Siames", 1, 4.2, "2022-03-15", ana)
        set pelusa = ..NuevoGato("Pelusa", "Persa", 0, 3.8, "2020-08-01", maria)
        set toby = ..NuevoPerro("Toby", "Chihuahua", "Chico", 2.9, "2023-01-20", maria)

        // ---- Vacunas (coleccion embebida dentro de cada mascota) ----
        $$$ThrowOnError(firulais.AplicarVacuna("Rabia", $zdateh("2025-06-12", 3), "RB-2291"))
        $$$ThrowOnError(firulais.AplicarVacuna("Parvovirus", $zdateh("2025-07-03", 3), "PV-0457"))
        $$$ThrowOnError(michi.AplicarVacuna("Triple felina", $zdateh("2025-09-20", 3), "TF-1180"))

        // ---- Consultas (el costo lo calcula cada mascota) ----
        $$$ThrowOnError(##class(Vet.Consulta).Registrar(firulais.%Id(), v1.%Id(), "Vacunacion anual"))
        $$$ThrowOnError(##class(Vet.Consulta).Registrar(rocky.%Id(), v2.%Id(), "Cojera en pata trasera"))
        $$$ThrowOnError(##class(Vet.Consulta).Registrar(michi.%Id(), v1.%Id(), "Revision general"))
        $$$ThrowOnError(##class(Vet.Consulta).Registrar(pelusa.%Id(), v1.%Id(), "Herida en oreja"))

        write "Datos de ejemplo cargados: 2 veterinarios, 3 propietarios, 5 mascotas, 4 consultas.", !
    } catch ex {
        set sc = ex.AsStatus()
        do $system.Status.DisplayError(sc)
    }
    return sc
}

ClassMethod NuevoVeterinario(nombre As %String, cedula As %String, especialidad As %String) As Vet.Veterinario
{
    set v = ##class(Vet.Veterinario).%New()
    set v.Nombre = nombre
    set v.Cedula = cedula
    set v.Especialidad = especialidad
    $$$ThrowOnError(v.%Save())
    return v
}

ClassMethod NuevoPropietario(nombre As %String, telefono As %String, calle As %String, colonia As %String, ciudad As %String, cp As %String) As Vet.Propietario
{
    set p = ##class(Vet.Propietario).%New()
    set p.Nombre = nombre
    set p.Telefono = telefono
    set p.Domicilio.Calle = calle
    set p.Domicilio.Colonia = colonia
    set p.Domicilio.Ciudad = ciudad
    set p.Domicilio.CodigoPostal = cp
    $$$ThrowOnError(p.%Save())
    return p
}

ClassMethod NuevoPerro(nombre As %String, raza As %String, talla As %String, peso As %Numeric, nacimiento As %String, propietario As Vet.Propietario) As Vet.Perro
{
    set m = ##class(Vet.Perro).%New()
    set m.Nombre = nombre
    set m.Raza = raza
    set m.Talla = talla
    set m.PesoKg = peso
    set m.FechaNacimiento = $zdateh(nacimiento, 3)
    set m.Propietario = propietario
    $$$ThrowOnError(m.%Save())
    return m
}

ClassMethod NuevoGato(nombre As %String, raza As %String, interior As %Boolean, peso As %Numeric, nacimiento As %String, propietario As Vet.Propietario) As Vet.Gato
{
    set m = ##class(Vet.Gato).%New()
    set m.Nombre = nombre
    set m.Raza = raza
    set m.Interior = interior
    set m.PesoKg = peso
    set m.FechaNacimiento = $zdateh(nacimiento, 3)
    set m.Propietario = propietario
    $$$ThrowOnError(m.%Save())
    return m
}

/// Recorre TODAS las mascotas abriendolas como Vet.Mascota.
/// Cada una responde con SU PROPIA version de Describir() y CostoConsulta().
ClassMethod Reporte()
{
    write !, "=== Mascotas de la clinica (polimorfismo) ===", !
    set resultado = ##class(%SQL.Statement).%ExecDirect(, "SELECT ID FROM Vet.Mascota ORDER BY ID")
    while resultado.%Next() {
        set mascota = ##class(Vet.Mascota).%OpenId(resultado.%Get("ID"))
        write mascota.%Id(), ". [", mascota.%ClassName(1), "] ", mascota.Describir(), !
        write "    costo de consulta: $", mascota.CostoConsulta(), !
    }
    write !, "=== Consultas ===", !
    set resultado = ##class(%SQL.Statement).%ExecDirect(, "SELECT ID FROM Vet.Consulta ORDER BY ID")
    while resultado.%Next() {
        set consulta = ##class(Vet.Consulta).%OpenId(resultado.%Get("ID"))
        write consulta.%Id(), ". ", consulta.Resumen(), !
    }
}

}
