# 🔐 SOLUCIÓN: Contraseñas No Persisten

## ❌ Problema Identificado

**Síntoma**: Cada vez que cambias la contraseña de un usuario (usando "olvidé mi contraseña"), al reiniciar el servidor o intentar entrar más tarde, la contraseña nueva no funciona y hay que resetearla de nuevo.

**Causa Probable**: MySQL puede tener `autocommit=0` (deshabilitado) o las conexiones no están haciendo commit explícito de las transacciones UPDATE.

## ✅ Soluciones Implementadas

### 1. **Forzar AutoCommit en Todos los UPDATE**

Modificado **UsuarioDAO.java** para que TODOS los métodos que hacen UPDATE establezcan explícitamente `con.setAutoCommit(true)`:

#### Métodos actualizados:
- ✅ `updatePassword()` - Cambiar contraseña
- ✅ `updatePerfil()` - Actualizar perfil completo
- ✅ `updatePerfilJugador()` - Actualizar nombre/email
- ✅ `softDelete()` - Desactivar usuario
- ✅ `reactivar()` - Reactivar usuario
- ✅ `setEnPartida()` - Marcar usuario en partida
- ✅ `updateAvatar()` - Actualizar avatar
- ✅ `actualizarLigaYPuntos()` - Actualizar liga y puntos

**Código típico ANTES** ❌:
```java
public boolean updatePassword(int id, String newPasswordPlain) throws SQLException {
    String sql = "UPDATE usuario SET password=? WHERE id=?";
    String hash = sha256Hex(newPasswordPlain);
    try (Connection con = DbConn.getInstancia().getConn();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, hash);
        ps.setInt(2, id);
        return ps.executeUpdate() > 0;
    }
}
```

**Código AHORA** ✅:
```java
public boolean updatePassword(int id, String newPasswordPlain) throws SQLException {
    String sql = "UPDATE usuario SET password=? WHERE id=?";
    String hash = sha256Hex(newPasswordPlain);
    Connection con = null;
    try {
        con = DbConn.getInstancia().getConn();
        con.setAutoCommit(true); // ← ESTO ES LO CRÍTICO
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hash);
            ps.setInt(2, id);
            int rowsAffected = ps.executeUpdate();
            
            System.out.println("DEBUG updatePassword: userId=" + id + 
                             ", rowsAffected=" + rowsAffected);
            
            return rowsAffected > 0;
        }
    } finally {
        if (con != null) {
            try { con.close(); } catch (SQLException e) { /* ignore */ }
        }
    }
}
```

### 2. **Logs de Debug Agregados**

Para diagnosticar problemas futuros, agregué logging extensivo:

#### En UsuarioDAO.updatePassword():
```java
System.out.println("DEBUG updatePassword: userId=" + id + ", rowsAffected=" + rowsAffected);
System.out.println("DEBUG updatePassword: nueva contraseña hash=" + hash.substring(0, 10) + "...");
```

#### En UsuarioDAO.validarLogin():
```java
System.out.println("DEBUG validarLogin: email=" + email);
System.out.println("DEBUG validarLogin: activo=" + activo);
System.out.println("DEBUG validarLogin: password almacenada (primeros 10 chars)=" + 
                 (stored != null && stored.length() >= 10 ? stored.substring(0, 10) + "..." : "null"));
System.out.println("DEBUG validarLogin: password ingresada=" + passwordPlain);
System.out.println("DEBUG validarLogin: password ingresada hasheada (primeros 10 chars)=" + 
                 sha256Hex(passwordPlain).substring(0, 10) + "...");
System.out.println("DEBUG validarLogin: resultado=" + matches);
```

#### En ForgotPasswordServlet:
```java
System.out.println("DEBUG ForgotPassword: Generando contraseña temporal para usuario ID=" + usuario.getId());
System.out.println("DEBUG ForgotPassword: Contraseña temporal generada: " + tempPassword);
System.out.println("DEBUG ForgotPassword: updatePassword returned: " + updated);
```

### 3. **Script de Verificación SQL**

Creado [sql/verificar_passwords.sql](sql/verificar_passwords.sql) para diagnosticar problemas en la base de datos:

```sql
-- Ver autocommit
SELECT @@autocommit; -- Debe ser 1

-- Ver formato de contraseñas
SELECT id, nombre, email, 
       CASE 
           WHEN LENGTH(password) = 64 AND password REGEXP '^[0-9a-fA-F]+$' 
           THEN 'SHA-256 (correcto)'
           ELSE 'TEXTO PLANO (problema!)'
       END as password_format
FROM usuario;

-- Ver transacciones pendientes
SELECT * FROM information_schema.innodb_trx;

-- Forzar commit
COMMIT;
SET autocommit = 1;
```

## 🔍 Diagnóstico

### Paso 1: Verificar autocommit en MySQL
```bash
mysql -u root -p
```
```sql
USE misterio_mansion;
SELECT @@autocommit;
```

Si devuelve `0`, ejecutar:
```sql
SET GLOBAL autocommit = 1;
```

### Paso 2: Ejecutar script de verificación
```bash
mysql -u root -p misterio_mansion < sql/verificar_passwords.sql
```

### Paso 3: Revisar logs del servidor
Después de recompilar y reiniciar, cuando intentes cambiar una contraseña verás en la consola:

```
DEBUG ForgotPassword: Generando contraseña temporal para usuario ID=15
DEBUG ForgotPassword: Contraseña temporal generada: Abc12XyZ
DEBUG updatePassword: userId=15, rowsAffected=1
DEBUG updatePassword: nueva contraseña hash=e3b0c44298...
DEBUG ForgotPassword: updatePassword returned: true
```

Cuando intentes hacer login:
```
DEBUG validarLogin: email=usuario@mail.com
DEBUG validarLogin: activo=true
DEBUG validarLogin: password almacenada (primeros 10 chars)=e3b0c44298...
DEBUG validarLogin: password ingresada=Abc12XyZ
DEBUG validarLogin: password ingresada hasheada (primeros 10 chars)=e3b0c44298...
DEBUG validarLogin: resultado=true
```

## 🚀 Aplicar la Solución

### 1. Recompilar el proyecto
```
Project → Clean → Clean all projects
```

### 2. Reiniciar el servidor
```
Stop server → Start server
```

### 3. Probar el flujo completo
1. Ir a "Olvidé mi contraseña"
2. Ingresar el email del usuario
3. Anotar la contraseña temporal que aparece
4. Cerrar sesión (si estabas logueado)
5. Intentar login con la contraseña temporal
6. **Verificar que funcione**
7. Cambiar la contraseña desde el perfil
8. **Cerrar sesión**
9. **Reiniciar el servidor**
10. **Intentar login con la nueva contraseña**
11. ✅ Debería funcionar

### 4. Revisar los logs en la consola
Buscar las líneas que empiezan con:
- `DEBUG updatePassword:`
- `DEBUG validarLogin:`
- `DEBUG ForgotPassword:`

## 🐛 Solución de Problemas

### Problema: Contraseña sigue sin persistir

**Verificación 1: Revisar transacciones bloqueadas**
```sql
SELECT * FROM information_schema.innodb_trx;
SELECT * FROM information_schema.innodb_locks;
```

Si hay transacciones bloqueadas:
```sql
KILL [ID_TRANSACCION];
```

**Verificación 2: Confirmar que el UPDATE se ejecutó**
Revisar los logs del servidor. Deberías ver:
```
DEBUG updatePassword: userId=X, rowsAffected=1
```

Si `rowsAffected=0`, significa que el UPDATE no afectó ninguna fila (usuario no existe o ID incorrecto).

**Verificación 3: Verificar contraseña en DB**
```sql
SELECT id, nombre, email, 
       LEFT(password, 20) as pwd_inicio,
       LENGTH(password) as pwd_length
FROM usuario 
WHERE id = [TU_USER_ID];
```

Deberías ver:
- `pwd_length` = 64 (SHA-256 en hexadecimal)
- `pwd_inicio` = primeros 20 caracteres del hash

**Verificación 4: Comparar hashes**

Después de cambiar contraseña a "test123", en la consola deberías ver:
```
DEBUG updatePassword: nueva contraseña hash=ecd71870d1...
```

En MySQL:
```sql
SELECT SHA2('test123', 256);
-- Debería devolver el mismo hash
```

Si los hashes NO coinciden, hay un problema con el algoritmo de hashing.

### Problema: Usuario con ID específico siempre falla

**Causa probable**: Ese usuario tiene la contraseña en formato incorrecto (texto plano o hash diferente).

**Solución**:
```sql
-- Verificar formato
SELECT id, nombre, email, LENGTH(password), password
FROM usuario 
WHERE id = [TU_USER_ID];

-- Si no es SHA-256 (64 caracteres), resetear manualmente:
UPDATE usuario 
SET password = SHA2('1234', 256) 
WHERE id = [TU_USER_ID];
```

Ahora inicia sesión con contraseña "1234".

### Problema: Funciona en desarrollo pero no en producción

**Causa**: Configuración diferente de MySQL entre ambientes.

**Solución**:
```sql
-- En producción, verificar:
SELECT @@autocommit;
SELECT @@tx_isolation;

-- Configurar igual que desarrollo:
SET GLOBAL autocommit = 1;
SET GLOBAL tx_isolation = 'READ-COMMITTED';
```

## 📊 Verificación Final

Después de aplicar todos los cambios:

### Test 1: Cambio de contraseña temporal
1. ✅ Solicitar contraseña temporal
2. ✅ Recibir contraseña temporal en pantalla
3. ✅ Login con contraseña temporal funciona
4. ✅ Reiniciar servidor
5. ✅ Login con contraseña temporal SIGUE funcionando

### Test 2: Cambio desde perfil
1. ✅ Cambiar contraseña desde perfil de usuario
2. ✅ Logout
3. ✅ Login con nueva contraseña funciona
4. ✅ Reiniciar servidor
5. ✅ Login con nueva contraseña SIGUE funcionando

### Test 3: Verificar en DB
```sql
-- Antes del cambio
SELECT id, LEFT(password, 20) as pwd_antes FROM usuario WHERE id = X;

-- (Cambiar contraseña desde la app)

-- Después del cambio
SELECT id, LEFT(password, 20) as pwd_despues FROM usuario WHERE id = X;

-- pwd_antes ≠ pwd_despues ✅
```

## 📝 Notas Importantes

- ✅ Todos los UPDATE ahora hacen commit explícito
- ✅ Logs agregados para diagnosticar problemas futuros
- ✅ Script SQL para verificar estado de la base de datos
- ⚠️ Los logs de DEBUG muestran contraseñas (solo para desarrollo)
- ⚠️ En producción, remover los `System.out.println` de contraseñas
- ⚠️ Asegurar que MySQL tenga `autocommit=1` siempre

## 🔒 Seguridad

**IMPORTANTE**: Los logs actuales muestran contraseñas en texto plano para debugging. En producción:

1. Comentar/eliminar estos logs:
```java
System.out.println("DEBUG ForgotPassword: Contraseña temporal generada: " + tempPassword);
System.out.println("DEBUG validarLogin: password ingresada=" + passwordPlain);
```

2. O reemplazar por:
```java
System.out.println("DEBUG: Contraseña actualizada para usuario ID=" + id);
System.out.println("DEBUG: Validando login para email=" + email);
```
