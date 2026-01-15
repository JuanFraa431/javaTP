# 📋 CRUD de Entidades - Panel Admin

## Resumen Ejecutivo

Se crearon 4 CRUDs completos para administrar las entidades principales del juego, siguiendo el mismo patrón arquitectónico del CRUD de Usuarios existente.

---

## 🎭 CRUD de Personajes

### Archivos creados:
- **Entity**: `entities/Personaje.java`
- **Servlets**: 
  - `logic/admin/AdminPersonajesServlet.java` (listado y búsqueda)
  - `logic/admin/AdminPersonajeFormServlet.java` (formulario)
  - `logic/admin/AdminPersonajeSaveServlet.java` (guardar/eliminar)
- **Views**:
  - `webapp/WEB-INF/views/admin/personajes/list.jsp`
  - `webapp/WEB-INF/views/admin/personajes/form.jsp`

### Funcionalidades:
✅ Crear nuevos personajes con nombre, descripción, coartada, motivo  
✅ Asignar personajes a historias específicas  
✅ Marcar como sospechoso o culpable (checkboxes)  
✅ Editar personajes existentes  
✅ Eliminar personajes con confirmación  
✅ Búsqueda por nombre o descripción  
✅ JOIN con tabla `historia` para mostrar título en listado  

### Campos de la entidad:
```java
- id (int)
- nombre (String)
- descripcion (String)
- coartada (String)
- motivo (String)
- sospechoso (int) // 0 o 1
- culpable (int) // 0 o 1
- historia_id (int)
- historiaTitulo (String) // Campo adicional del JOIN
```

### URL de acceso:
- Listado: `/admin/personajes`
- Formulario: `/admin/personajes/form?id=X` (editar) o sin parámetro (nuevo)
- Guardar: POST `/admin/personajes/save`
- Eliminar: POST `/admin/personajes/delete`

---

## 💡 CRUD de Pistas

### Archivos creados:
- **Entity**: `entities/Pista.java` (actualizada con nuevos campos)
- **Servlets**:
  - `logic/admin/AdminPistasServlet.java`
  - `logic/admin/AdminPistaFormServlet.java`
  - `logic/admin/AdminPistaSaveServlet.java`
- **Views**:
  - `webapp/WEB-INF/views/admin/pistas/list.jsp`
  - `webapp/WEB-INF/views/admin/pistas/form.jsp`

### Funcionalidades:
✅ Crear pistas con nombre, descripción y contenido  
✅ Asignar pistas a historia, ubicación y personaje (3 FK)  
✅ Marcar pista como crucial (checkbox)  
✅ Definir importancia (baja/media/alta)  
✅ Editar y eliminar pistas  
✅ Búsqueda por nombre o descripción  
✅ Triple JOIN con `historia`, `ubicacion` y `personaje`  
✅ Dropdowns dinámicos para las 3 relaciones  

### Campos de la entidad:
```java
- id (int)
- nombre (String)
- descripcion (String)
- contenido (String)
- crucial (int) // 0 o 1
- importancia (String) // baja, media, alta
- ubicacion_id (int) - FK nullable
- personaje_id (int) - FK nullable
- historia_id (int) - FK obligatoria
- historiaTitulo (String) // JOIN
- ubicacionNombre (String) // JOIN
- personajeNombre (String) // JOIN
```

### URL de acceso:
- Listado: `/admin/pistas`
- Formulario: `/admin/pistas/form?id=X`
- Guardar: POST `/admin/pistas/save`
- Eliminar: POST `/admin/pistas/delete`

### Características especiales:
- **Tabla más compleja**: Muestra 8 columnas incluyendo las 3 relaciones
- **Badges visuales**: Importancia con emojis (🔴 Alta, 🟠 Media, 🟢 Baja)
- **FK opcionales**: Ubicación y personaje pueden ser NULL

---

## 📍 CRUD de Ubicaciones

### Archivos creados:
- **Entity**: `entities/Ubicacion.java`
- **Servlets**:
  - `logic/admin/AdminUbicacionesServlet.java`
  - `logic/admin/AdminUbicacionFormServlet.java`
  - `logic/admin/AdminUbicacionSaveServlet.java`
- **Views**:
  - `webapp/WEB-INF/views/admin/ubicaciones/list.jsp`
  - `webapp/WEB-INF/views/admin/ubicaciones/form.jsp`

### Funcionalidades:
✅ Crear ubicaciones con nombre, descripción e imagen  
✅ Asignar ubicaciones a historias  
✅ Marcar si es accesible (checkbox)  
✅ Especificar ruta de imagen  
✅ Editar y eliminar ubicaciones  
✅ Búsqueda por nombre o descripción  
✅ JOIN con tabla `historia`  

### Campos de la entidad:
```java
- id (int)
- nombre (String)
- descripcion (String)
- accesible (int) // 0 o 1
- imagen (String) // ruta opcional
- historia_id (int)
- historiaTitulo (String) // JOIN
```

### URL de acceso:
- Listado: `/admin/ubicaciones`
- Formulario: `/admin/ubicaciones/form?id=X`
- Guardar: POST `/admin/ubicaciones/save`
- Eliminar: POST `/admin/ubicaciones/delete`

### Características especiales:
- **Campo imagen**: Input de texto para ruta relativa (ej: `/images/biblioteca.jpg`)
- **Indicador visual**: 🖼️ si tiene imagen, `-` si no tiene

---

## 🎮 CRUD de Partidas (Solo Lectura)

### Archivos creados:
- **Entity**: `entities/Partida.java` (actualizada)
- **Servlet**:
  - `logic/admin/AdminPartidasServlet.java` (SOLO listado)
- **View**:
  - `webapp/WEB-INF/views/admin/partidas/list.jsp`

### Funcionalidades:
✅ Ver todas las partidas jugadas  
✅ Búsqueda por usuario, estado o solución propuesta  
✅ JOIN con `usuario` y `historia`  
✅ Mostrar 10 columnas de información  
⛔ **NO permite** crear partidas manualmente  
⛔ **NO permite** editar partidas  
⛔ **NO permite** eliminar partidas  

### Campos mostrados:
```java
- id
- usuario_id → usuarioUsername (JOIN)
- historia_id → historiaTitulo (JOIN)
- estado (EN_PROGRESO, FINALIZADA, ABANDONADA)
- fecha_inicio (Timestamp)
- fecha_fin (Timestamp)
- pistas_encontradas
- ubicaciones_exploradas
- puntuacion
- solucion_propuesta
- caso_resuelto (int 0 o 1)
- intentos_restantes
```

### URL de acceso:
- Listado: `/admin/partidas` (único endpoint disponible)

### Características especiales:
- **Solo lectura**: Nota visible explicando que no se pueden crear/editar partidas
- **Badges de estado**: 🔵 En progreso, ✅ Finalizada, ❌ Abandonada
- **Formato de fechas**: dd/MM/yyyy HH:mm
- **Truncado de solución**: Muestra hasta 40 caracteres de la solución propuesta

---

## 🎨 Diseño Consistente

Todos los CRUDs siguen el **mismo patrón de diseño**:

### Estilos aplicados:
- **Listado**: `admin-usuarios-list.css`
- **Formularios**: `admin-usuarios-form.css`
- **Iconos**: Font Awesome 6.5.0
- **Fuentes**: Nunito (400, 700, 800)

### Características comunes:
✅ Mensajes flash (success/error) con sesión  
✅ Barra de búsqueda con ícono  
✅ Botón "Volver al Dashboard"  
✅ Botones de acción con iconos  
✅ Confirmación JavaScript antes de eliminar  
✅ Indicador de campos requeridos (*)  
✅ Validación HTML5 en formularios  
✅ Tooltips en botones de acción  
✅ Diseño responsive  

### Seguridad:
- Verificación de rol ADMIN en todos los servlets
- Redirección a `/login` si no está autenticado
- PreparedStatement para prevenir SQL injection
- Sesión obligatoria para todos los endpoints

---

## 🗂️ Actualización del Dashboard

Se actualizó `dashboard.jsp` con enlaces a las 4 nuevas secciones:

```jsp
<a class="card" href="${pageContext.request.contextPath}/admin/personajes">
  <div class="icon"><i class="fa-solid fa-user-secret"></i></div>
  <h3>Personajes</h3>
  ...
</a>

<a class="card" href="${pageContext.request.contextPath}/admin/pistas">
  <div class="icon"><i class="fa-solid fa-magnifying-glass"></i></div>
  <h3>Pistas</h3>
  ...
</a>

<a class="card" href="${pageContext.request.contextPath}/admin/ubicaciones">
  <div class="icon"><i class="fa-solid fa-location-dot"></i></div>
  <h3>Ubicaciones</h3>
  ...
</a>

<a class="card" href="${pageContext.request.contextPath}/admin/partidas">
  <div class="icon"><i class="fa-solid fa-chess-knight"></i></div>
  <h3>Partidas</h3>
  ...
</a>
```

---

## 📊 Resumen de Archivos

| Entidad | Servlets | JSP | Entity |
|---------|----------|-----|--------|
| **Personajes** | 3 | 2 | ✅ |
| **Pistas** | 3 | 2 | ✅ |
| **Ubicaciones** | 3 | 2 | ✅ |
| **Partidas** | 1 | 1 | ✅ |
| **TOTAL** | **10 servlets** | **7 JSP** | **4 entities** |

---

## ✅ Estado Final

### Completado:
✅ 4 entidades con getters/setters  
✅ 10 servlets funcionales  
✅ 7 vistas JSP con estilos consistentes  
✅ Dashboard actualizado con enlaces  
✅ Búsqueda en todos los listados  
✅ JOINs para mostrar información relacionada  
✅ Validación y seguridad  
✅ Mensajes flash de confirmación  

### Pendiente:
⚠️ **Compilación del proyecto** en Eclipse  
⚠️ **Despliegue en Tomcat 10** para probar  
⚠️ **Agregar datos de prueba** a las tablas si es necesario  

---

## 🚀 Próximos Pasos

1. **Compilar el proyecto** en Eclipse para resolver los warnings de `jakarta.servlet`
2. **Limpiar y reconstruir** el proyecto (Clean → Build)
3. **Desplegar en Tomcat 10.1.36**
4. **Probar cada CRUD**:
   - Crear registros
   - Editar existentes
   - Buscar
   - Eliminar (excepto en Partidas)
5. **Verificar relaciones**:
   - Que los dropdowns carguen correctamente
   - Que los JOINs muestren los nombres relacionados
   - Que las FK opcionales permitan NULL

---

## 📝 Notas Técnicas

- **Base de datos**: MySQL 8
- **Servidor**: Tomcat 10.1.36
- **API Servlet**: Jakarta EE 10 (`jakarta.servlet.*`)
- **Patrón de diseño**: MVC + DAO
- **Conexión DB**: `DbConn.getInstancia().getConn()` (singleton)
- **Encoding**: UTF-8 en todas las JSP
- **Soft delete**: No implementado (eliminación física en todas las tablas)

---

**Documento generado**: $(date)  
**CRUDs implementados**: Personajes, Pistas, Ubicaciones, Partidas  
**Arquitectura**: Consistente con el CRUD de Usuarios existente
