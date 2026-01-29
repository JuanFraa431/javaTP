# 🎨 Sistema de Avatares - Guía de Implementación

## ✅ Cambios Realizados

### 1. **Modificación del Sistema de Avatares**
Se cambió de un sistema de **upload de imágenes** a un **catálogo de avatares predefinidos**.

### 2. **Archivos Modificados**

#### Backend:
- **UploadAvatarServlet.java** - Ahora maneja la selección de avatares del catálogo
- **AvatarServlet.java** - Sirve las imágenes usando rutas relativas de webapp
- **Usuario.java** - Actualizado el comentario del campo avatar
- **UsuarioDAO.java** - Sin cambios (ya funcionaba correctamente)

#### Frontend:
- **perfil.jsp** - Nuevo selector visual de avatares estilo Netflix

#### Base de Datos:
- **migrate_avatars_to_catalog.sql** - Script para migrar avatares existentes

### 3. **Avatares Predefinidos**
Se crearon 8 avatares SVG de placeholder en `/webapp/avatars/`:
- `avatar1.png.svg` - Detective azul
- `avatar2.png.svg` - Detective rojo  
- `avatar3.png.svg` - Detective verde
- `avatar4.png.svg` - Detective morado
- `avatar5.png.svg` - Detective naranja
- `avatar6.png.svg` - Detective turquesa
- `avatar7.png.svg` - Detective gris
- `avatar8.png.svg` - Detective naranja oscuro

---

## 🚀 Instrucciones de Uso

### Paso 1: Ejecutar Script SQL
Ejecuta el script de migración para actualizar los avatares existentes:

```sql
-- En tu cliente MySQL:
USE misterio_mansion;
source sql/migrate_avatars_to_catalog.sql;
```

O copia y ejecuta el contenido del archivo manualmente.

### Paso 2: Reemplazar Avatares SVG por PNG/JPG Reales

Los archivos `.svg` son **placeholders temporales**. Debes reemplazarlos con imágenes reales:

1. Crea o descarga 8 imágenes de avatares (PNG o JPG)
2. Nómbralas: `avatar1.png`, `avatar2.png`, ..., `avatar8.png`
3. Reemplaza los archivos en: `src/main/webapp/avatars/`
4. **Elimina** los archivos `.svg` temporales

**Recomendaciones para las imágenes:**
- Tamaño: 200x200 px o 400x400 px
- Formato: PNG con fondo transparente (preferido) o JPG
- Estilo: Consistente entre todos los avatares
- Temática: Detectives, investigadores, personajes de misterio

### Paso 3: Agregar Más Avatares (Opcional)

Si quieres agregar más avatares:

1. Agrega las imágenes a `/webapp/avatars/` con nombres secuenciales (`avatar9.png`, etc.)
2. Actualiza `UploadAvatarServlet.java` línea 19-22:

```java
private static final List<String> AVAILABLE_AVATARS = Arrays.asList(
    "avatar1.png", "avatar2.png", "avatar3.png", "avatar4.png",
    "avatar5.png", "avatar6.png", "avatar7.png", "avatar8.png",
    "avatar9.png", "avatar10.png"  // Agrega aquí
);
```

3. Actualiza `perfil.jsp` línea ~120:

```java
String[] avatars = {"avatar1.png", "avatar2.png", ..., "avatar10.png"};
```

### Paso 4: Compilar y Probar

1. Limpia y recompila el proyecto en Eclipse
2. Reinicia el servidor Tomcat
3. Accede a tu perfil y verifica el selector de avatares
4. Prueba seleccionar diferentes avatares

---

## 🔧 Cómo Funciona Ahora

### Flujo del Sistema:

1. **Usuario accede a su perfil** → Ve una cuadrícula con los 8 avatares disponibles
2. **Selecciona un avatar** → Se marca visualmente con borde y checkmark
3. **Hace clic en "Guardar Avatar"** → Se envía solo el nombre del archivo (`avatar3.png`)
4. **Base de datos** → Guarda solo el nombre: `avatar = "avatar3.png"`
5. **Visualización** → AvatarServlet carga el archivo desde `webapp/avatars/` usando la ruta del contexto

### Ventajas del Nuevo Sistema:

✅ **Portabilidad** - Funciona en cualquier servidor/computadora  
✅ **Sin rutas hardcodeadas** - Usa rutas relativas del contexto web  
✅ **Fácil clonación** - Los avatares están en el repositorio  
✅ **Sin uploads** - Elimina problemas de permisos de escritura  
✅ **Experiencia tipo Netflix** - Selector visual intuitivo  

---

## 📁 Estructura de Archivos

```
src/main/webapp/avatars/
├── README.md
├── avatar1.png (reemplazar SVG temporal)
├── avatar2.png (reemplazar SVG temporal)
├── avatar3.png (reemplazar SVG temporal)
├── avatar4.png (reemplazar SVG temporal)
├── avatar5.png (reemplazar SVG temporal)
├── avatar6.png (reemplazar SVG temporal)
├── avatar7.png (reemplazar SVG temporal)
└── avatar8.png (reemplazar SVG temporal)
```

---

## 🐛 Solución de Problemas

### Problema: "Avatar no se muestra"
**Solución:** Verifica que el archivo exista en `webapp/avatars/` y tenga el nombre correcto.

### Problema: "Error 404 al cargar avatar"
**Solución:** Asegúrate de que la carpeta `avatars` esté dentro de `webapp/` y sea accesible.

### Problema: "Avatares antiguos no migran"
**Solución:** Ejecuta el script SQL `migrate_avatars_to_catalog.sql`.

### Problema: "No puedo ver los avatares en el selector"
**Solución:** Verifica que los archivos SVG temporales tengan extensión `.png.svg` o reemplázalos directamente con PNGs reales.

---

## 💡 Próximos Pasos

1. ✅ Ejecutar script SQL de migración
2. ✅ Reemplazar archivos SVG con imágenes PNG/JPG reales
3. ✅ Compilar y probar
4. ⚠️ (Opcional) Agregar más avatares al catálogo
5. ⚠️ (Opcional) Mejorar diseño del selector en CSS

---

**¡Listo!** Tu sistema de avatares ahora es completamente portable y funcional en cualquier entorno.
