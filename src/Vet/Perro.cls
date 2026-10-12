/// Subclase de Mascota con propiedades propias.
Class Vet.Perro Extends Vet.Mascota
{

Property Raza As %String(MAXLEN = 60);

Property Talla As %String(VALUELIST = ",Chico,Mediano,Grande") [ InitialExpression = "Mediano", Required ];

Method Especie() As %String
{
    return "Perro"
}

/// SOBRESCRIBE el costo: depende de la talla.
Method CostoConsulta() As %Numeric
{
    if (..Talla = "Grande") {
        return 450
    }
    if (..Talla = "Chico") {
        return 300
    }
    return 350
}

/// Reutiliza la descripcion de la superclase (##super) y le agrega datos propios.
Method Describir() As %String
{
    return ##super() _ " | raza: " _ ..Raza _ " | talla: " _ ..Talla
}

}
