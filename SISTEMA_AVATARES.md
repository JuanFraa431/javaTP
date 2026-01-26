# Sistema de Imágenes de Perfil (Avatar) - Implementación Completa

## 📋 Resumen

Se ha implementado un sistema completo de manejo de avatares de usuario que cumple con el **requerimiento extra de "Manejo de archivos"** para la aprobación directa del TP.

---

## ✅ Componentes Implementados

### 1. **Base de Datos**
📄 **Archivo:** `sql/add_avatar_field.sql`
- Agrega columna `avatar VARCHAR(255)` a tabla `usuario`
- Almacena la ruta relativa del archivo (ej: `avatars/user_123.jpg`)

**Ejecutar:**
```sql
SOURCE sql/add_avatar_field.sql;
```

---

### 2. **Custom Exception** ✨
📄 **Archivo:** `logic/InvalidImageException.java`
- Exception personalizada para errores de imágenes
- Valida tipo de archivo, tamaño y formato
- Cumple con **requerimiento extra de Custom Exceptions**

**Casos de uso:**
- Archivo no es imagen válida
- Tamaño excede límite (5MB)
- Formato no soportado
- Error al procesar/guardar

---

### 3. **Entidad Usuario Actualizada**
📄 **Archivo:** `entities/Usuario.java`
- Nuevo campo: `private String avatar`
- Getters y setters correspondientes

---

### 4. **UsuarioDAO Actualizado**
📄 **Archivo:** `data/UsuarioDAO.java`

**Cambios:**
- `mapRow()`: Mapea campo avatar desde ResultSet
- `getAll()`, `search()`, `findById()`, `findByEmail()`: Incluyen avatar en SELECT
- **Nuevo método:** `updateAvatar(int id, String avatarPath)`

---

### 5. **Servlet para Subir Avatar** 🆕
📄 **Archivo:** `logic/jugador/UploadAvatarServlet.java`
- **URL:** `/jugador/upload-avatar`
- **Método:** POST con `multipart/form-data`

**Características:**
- ✅ Validación de tipo (JPG, PNG, GIF, WebP)
- ✅ Validación de tamaño máximo (5MB)
- ✅ Nombres únicos por usuario (`user_{id}.extension`)
- ✅ Elimina avatar anterior al subir nuevo
- ✅ Actualiza BD y sesión automáticamente
- ✅ Manejo de errores con custom exception

**Validaciones:**
```java
- Content-Type: image/jpeg, image/png, image/gif, image/webp
- Tamaño máximo: 5MB
- Extensiones permitidas: jpg, jpeg, png, gif, webp
```

---

### 6. **Servlet para Servir Imágenes** 🆕
📄 **Archivo:** `logic/jugador/AvatarServlet.java`
- **URL:** `/avatar?userId={id}`
- **Método:** GET

**Características:**
- Sirve archivos desde carpeta `/avatars/`
- Content-Type dinámico según extensión
- Avatar por defecto (SVG) si no existe personalizado
- Optimizado para performance

---

### 7. **Vista de Perfil Actualizada** 🎨
📄 **Archivo:** `views/jugador/perfil.jsp`

**Nuevas características:**
- Sección dedicada para avatar
- Preview en tiempo real antes de subir
- Validación client-side (tamaño y tipo)
- Botones de confirmación/cancelación
- Diseño responsive y glassmorphic
- Información de formatos permitidos

**UI/UX:**
```
┌─────────────────────────────┐
│      Avatar Circular        │
│      (150x150px)           │
│                             │
│  [📷 Cambiar Avatar]        │
│                             │
│  ℹ️ JPG, PNG, GIF (5MB)     │
└─────────────────────────────┘
```

**JavaScript incluido:**
- Preview de imagen antes de subir
- Validación de tamaño (5MB)
- Validación de tipo (image/*)
- Función cancelar preview

---

### 8. **Clasificaciones con Avatares** 🏆
📄 **Archivo:** `views/jugador/clasificaciones.jsp`

**Cambios:**
- Nueva columna en tabla con avatar (40x40px circulares)
- Avatares con borde y sombra sutil
- Responsive (oculta en móviles si es necesario)

**Ejemplo visual:**
```
POS | 👤 | JUGADOR      | LIGA | PUNTOS
  1 | 📸 | Detective123 | 🥇   | 850
  2 | 📸 | Sherlock99   | 🥇   | 720
```

---

### 9. **Home con Avatar** 🏠
📄 **Archivo:** `views/jugador/home.jsp`

**Cambios:**
- Widget de liga muestra avatar del usuario (60x60px)
- Avatar junto al badge de liga
- Diseño mejorado con flexbox
- Importa entidad Usuario en JSP

**Ejemplo visual:**
```
┌──────────────────────────────────┐
│  [👤 Avatar] [🏆 ORO]            │
│  ⭐ 450 puntos  🏅 8/10 logros   │
└──────────────────────────────────┘
```

---

## 🗂️ Estructura de Archivos

```
webapp/
  avatars/              ← Carpeta creada automáticamente
    user_1.jpg
    user_2.png
    user_3.webp
    ...
```

**Nomenclatura:** `user_{userId}.{extension}`
- Garantiza unicidad
- Fácil de buscar/eliminar
- No conflictos entre usuarios

---

## 📝 Flujo de Uso

### **1. Usuario accede a Perfil**
```
/jugador/perfil → Muestra avatar actual (o default)
```

### **2. Usuario selecciona imagen**
```
input[type="file"] → JavaScript muestra preview
                   → Validaciones client-side
```

### **3. Usuario confirma subida**
```
POST /jugador/upload-avatar
  → UploadAvatarServlet valida servidor
  → Guarda en /avatars/user_{id}.ext
  → Actualiza BD con ruta
  → Actualiza sesión
  → Redirect a /jugador/perfil con mensaje
```

### **4. Avatares se muestran en**
- ✅ Perfil del usuario
- ✅ Widget de liga en Home
- ✅ Tabla de clasificaciones
- ✅ (Futuro) Rankings, foros, chats, etc.

---

## 🎨 Características Visuales

### **Estilos Aplicados:**
- Avatares circulares (border-radius: 50%)
- Bordes con transparencia elegante
- Box-shadow para profundidad
- object-fit: cover (sin deformación)
- Responsive en todos los tamaños

### **Tamaños por Contexto:**
- Perfil (vista principal): 150x150px
- Home (widget liga): 60x60px
- Clasificaciones (tabla): 40x40px

---

## ✨ Validaciones Implementadas

### **Client-Side (JavaScript):**
```javascript
- Tamaño máximo: 5MB
- Tipo: image/*
- Preview instantáneo
- Cancelar antes de subir
```

### **Server-Side (Java):**
```java
- Content-Type verificado
- Extensión verificada
- Tamaño máximo 5MB
- Custom Exception si falla
```

---

## 🔒 Seguridad

1. **Validación doble** (cliente y servidor)
2. **Tipos MIME verificados**
3. **Extensiones limitadas** a imágenes
4. **Tamaño máximo** controlado
5. **Nombres de archivo controlados** (evita inyección)
6. **Carpeta separada** del código fuente

---

## 🚀 Próximos Pasos Opcionales

### **Mejoras Sugeridas:**
- [ ] Recorte de imagen (crop) antes de subir
- [ ] Compresión automática de imágenes grandes
- [ ] Múltiples tamaños (thumbnails)
- [ ] Galería de avatares predeterminados
- [ ] Moderación de imágenes (content filter)

### **Integración Adicional:**
- [ ] Mostrar en comentarios/foros
- [ ] Mostrar en chat del juego
- [ ] Achievements con avatar
- [ ] Exportar avatar en reportes PDF

---

## 📦 Requerimientos Técnicos Cumplidos

### ✅ **Manejo de Archivos** (REQUERIMIENTO EXTRA)
- Subida de archivos desde formulario
- Almacenamiento en servidor
- Visualización dinámica
- Validación completa

### ✅ **Custom Exceptions** (BONUS)
- `InvalidImageException` implementada
- Manejo de errores específicos
- Mensajes claros al usuario

### ✅ **Niveles de Acceso**
- Solo usuarios logueados pueden subir
- Avatar visible públicamente en rankings

### ✅ **Manejo de Errores**
- Try-catch en servlets
- Mensajes flash informativos
- Logging de errores

---

## 📚 Documentación Técnica

### **Clase UploadAvatarServlet**
```java
@WebServlet("/jugador/upload-avatar")
@MultipartConfig(maxFileSize = 10MB)

Métodos principales:
- doPost(): Procesa subida
- getFileName(): Extrae nombre de Part
- getFileExtension(): Obtiene extensión
- deleteOldAvatar(): Limpia archivos anteriores
```

### **Clase AvatarServlet**
```java
@WebServlet("/avatar")

Métodos principales:
- doGet(): Sirve imagen o default
- serveDefaultAvatar(): SVG por defecto
- getContentType(): Mapea extensión a MIME
```

---

## 🎯 Resultado Final

El sistema permite a los usuarios:
1. ✅ Subir su foto de perfil
2. ✅ Ver preview antes de confirmar
3. ✅ Recibir validaciones claras
4. ✅ Ver su avatar en toda la aplicación
5. ✅ Compararse visualmente con otros jugadores

**Estado:** ✅ **COMPLETO Y FUNCIONAL**

---

## 🏁 Checklist de Implementación

- [x] Script SQL para campo avatar
- [x] Custom Exception InvalidImageException
- [x] Actualizar entidad Usuario
- [x] Actualizar UsuarioDAO
- [x] Servlet para subir avatar
- [x] Servlet para servir imágenes
- [x] Actualizar perfil.jsp
- [x] Actualizar clasificaciones.jsp
- [x] Actualizar home.jsp
- [x] Validaciones client-side
- [x] Validaciones server-side
- [x] Manejo de errores
- [x] Documentación completa

**🎉 ¡Sistema de avatares completamente implementado!**
