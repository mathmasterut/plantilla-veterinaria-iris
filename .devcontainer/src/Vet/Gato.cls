/// Subclase de Mascota con propiedades propias.
Class Vet.Gato Extends Vet.Mascota
{

Property Raza As %String(MAXLEN = 60);

/// 1 = vive dentro de casa, 0 = sale al exterior.
Property Interior As %Boolean [ InitialExpression = 1 ];

Method Especie() As %String
{
    return "Gato"
}

/// SOBRESCRIBE el costo: los gatos de exterior requieren revision extra.
Method CostoConsulta() As %Numeric
{
    return $select(..Interior: 300, 1: 380)
}

Method Describir() As %String
{
    return ##super() _ " | raza: " _ ..Raza _ " | " _ $select(..Interior: "interior", 1: "exterior")
}

}
