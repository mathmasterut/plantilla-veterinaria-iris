# Comandos de la práctica

Copia y pega cada bloque en la terminal de IRIS (prompt `USER>`), una línea a la vez.
Para abrir la terminal de IRIS: en la terminal de VS Code escribe `iris session IRIS -U USER`.

---

## Paso 4 · Compilar las clases

```
do $system.OBJ.LoadDir("/home/irisowner/dev/src", "ck", , 1)
```

## Paso 6 · Crear tus primeros objetos

```
set ana = ##class(Vet.Propietario).%New()
set ana.Nombre = "Ana Lopez"
set ana.Telefono = "771 123 4567"
set ana.Domicilio.Calle = "Av. Juarez 120", ana.Domicilio.Ciudad = "Huejutla", ana.Domicilio.CodigoPostal = "43000"
write ana.%Save()
write ana.%Id()
write ana.Presentarse()
```

```
set perro = ##class(Vet.Perro).%New()
set perro.Nombre = "Firulais", perro.Raza = "Mestizo", perro.Talla = "Mediano", perro.PesoKg = 18.5
set perro.FechaNacimiento = $zdateh("2021-05-10", 3)
set perro.Propietario = ana
write perro.%Save()
write perro.%Id()
write perro.Describir()
write perro.CostoConsulta()
```

## Paso 7 · Abrir un objeto por su ID y navegar

```
kill perro, ana
set m = ##class(Vet.Mascota).%OpenId(1)
write m.%ClassName(1)
write m.Nombre, " pertenece a ", m.Propietario.Nombre
write m.Propietario.Domicilio.Ciudad
zwrite m.%Oid()
```

Modificar y volver a guardar:

```
set m.PesoKg = 19.2
write m.%Save()
```

## Paso 8 · Colecciones: vacunas y mascotas de un propietario

```
write m.AplicarVacuna("Rabia", $zdateh("2026-09-01", 3), "RB-3301")
do m.ListarVacunas()
```

```
set gato = ##class(Vet.Gato).%New()
set gato.Nombre = "Michi", gato.Raza = "Siames", gato.Interior = 1, gato.PesoKg = 4.2
set gato.Propietario = m.Propietario
write gato.%Save()
do m.Propietario.ListarMascotas()
```

## Paso 9 · Datos de ejemplo y polimorfismo

> `Cargar()` **borra** los objetos anteriores y crea un conjunto conocido de datos.

```
kill
do ##class(Vet.Datos).Cargar()
do ##class(Vet.Datos).Reporte()
```

Abrir personas de distinta clase con la superclase:

```
set p1 = ##class(Vet.Persona).%OpenId(1)
write p1.%ClassName(1), " -> ", p1.Presentarse()
set p3 = ##class(Vet.Persona).%OpenId(3)
write p3.%ClassName(1), " -> ", p3.Presentarse()
```

## Paso 10 · Registrar y modificar una consulta

```
set sc = ##class(Vet.Consulta).Registrar(5, 2, "Revision dental", .c)
write sc
write c.Resumen()
set c.Diagnostico = "Sarro leve, se recomienda limpieza"
write c.%Save()
```

## Paso 11 · Los mismos objetos con SQL

```
do $system.SQL.Shell()
```

Dentro del shell de SQL (prompt `[SQL]USER>>`), una consulta por línea:

```
SELECT ID, Nombre, PesoKg FROM Vet.Mascota
SELECT ID, Nombre, Raza, Talla FROM Vet.Perro
SELECT Nombre, Propietario->Nombre AS NombrePropietario FROM Vet.Mascota
SELECT Nombre, Domicilio_Calle, Domicilio_Ciudad FROM Vet.Propietario
SELECT Fecha, Mascota->Nombre AS NombreMascota, Mascota->Propietario->Nombre AS NombrePropietario, Veterinario->Nombre AS NombreVeterinario, Costo FROM Vet.Consulta
SELECT Propietario->Nombre AS NombrePropietario, COUNT(*) AS Total FROM Vet.Mascota GROUP BY Propietario->Nombre
```

## Paso 12 · Insertar con SQL y abrir como objeto

```
INSERT INTO Vet.Gato (Nombre, Raza, Interior, PesoKg, Propietario) VALUES ('Nieve', 'Angora', 1, 3.5, 3)
UPDATE Vet.Perro SET PesoKg = 33.1 WHERE Nombre = 'Rocky'
quit
```

De vuelta en `USER>`:

```
set n = ##class(Vet.Mascota).%OpenId(6)
write n.%ClassName(1), " -> ", n.Describir()
do n.Propietario.ListarMascotas()
```

## Paso 14 · Laboratorio de validación e integridad

Cada bloque debe mostrar un **ERROR**:

```
set g = ##class(Vet.Gato).%New()
do $system.Status.DisplayError(g.%Save())
```

```
set g.Nombre = "Garfield", g.PesoKg = -3
do $system.Status.DisplayError(g.%Save())
```

```
set p = ##class(Vet.Perro).%New()
set p.Nombre = "Coco", p.PesoKg = 10, p.Talla = "Gigante"
do $system.Status.DisplayError(p.%Save())
```

```
set v = ##class(Vet.Veterinario).%New()
set v.Nombre = "Dr. Copia", v.Cedula = "4521873"
do $system.Status.DisplayError(v.%Save())
```

```
do $system.Status.DisplayError(##class(Vet.Propietario).%DeleteId(3))
```

Y este sí debe funcionar (devuelve 1):

```
write ##class(Vet.Consulta).%DeleteId(4)
```

## Salir de la terminal de IRIS

```
halt
```
