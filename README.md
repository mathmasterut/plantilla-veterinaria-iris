# Clínica veterinaria · Base de datos orientada a objetos

Práctica de bases de datos **NoSQL orientadas a objetos** con **InterSystems IRIS Community Edition** ejecutándose en **GitHub Codespaces**.

## Cómo abrirlo

1. En este repositorio: **Code → Codespaces → Create codespace on main**.
2. Espera a que termine de construirse (la primera vez tarda varios minutos).
3. En la terminal de VS Code: `iris session IRIS -U USER`
4. Compila las clases: `do $system.OBJ.LoadDir("/home/irisowner/dev/src", "ck", , 1)`

Todos los comandos de la práctica están en [`COMANDOS.md`](COMANDOS.md).

## Modelo de clases (paquete `Vet`)

```
Persona (persistente)                Mascota (persistente)
 ├── Propietario ── Mascotas ◄─────► Propietario
 │     └── Domicilio (serial)          ├── Vacunas: lista de Vacuna (serial)
 └── Veterinario                       ├── Perro
                                       └── Gato
Consulta (persistente) ── Mascota (referencia), Veterinario (referencia)
Datos ── utilerías: Cargar(), Limpiar(), Reporte()
```

## Accesos

| Qué | Dato |
|---|---|
| Terminal de IRIS | `iris session IRIS -U USER` |
| Portal de administración | puerto **52773** → `/csp/sys/UtilHome.csp` |
| Usuario / contraseña | `_SYSTEM` / `SYS` (solo para desarrollo) |

> Detén el codespace al terminar (**Codespaces → Stop**) para no consumir tus horas gratuitas.
> Al detenerlo y volverlo a abrir, normalmente se conservan tus objetos y cambios; **se pierden si eliges "Rebuild container" o borras el codespace**. Si faltan, vuelve a compilar y ejecuta `do ##class(Vet.Datos).Cargar()`.
