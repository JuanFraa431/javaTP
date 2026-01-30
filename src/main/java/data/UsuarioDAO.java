package data;

import entities.Usuario;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/** DAO para tabla usuario(id, nombre, email, password, rol, fecha_registro, activo) */
public class UsuarioDAO {

    /* ===================== Utilidades de password ===================== */

    private static boolean isHex64(String s) {
        return s != null && s.length() == 64 && s.matches("(?i)[0-9a-f]{64}");
    }

    private static String sha256Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] out = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(out.length * 2);
            for (byte b : out) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("No se pudo calcular SHA-256", e);
        }
    }

    /** Compat (no recomendado): si en DB quedó texto plano, también lo valida. */
    private static boolean matchesPassword(String stored, String inputPlain) {
        if (stored == null) return false;
        if (isHex64(stored)) return stored.equalsIgnoreCase(sha256Hex(inputPlain));
        return stored.equals(inputPlain);
    }

    /* ===================== Mapeo ===================== */

    private Usuario mapRow(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setNombre(rs.getString("nombre"));
        u.setEmail(rs.getString("email"));
        u.setRol(rs.getString("rol"));
        // NUEVO: mapear estado
        try { u.setActivo(rs.getBoolean("activo")); } catch (SQLException ignore) {}
        // NUEVO: mapear avatar
        try { u.setAvatar(rs.getString("avatar")); } catch (SQLException ignore) {}
        // NUEVO: mapear liga y puntos
        try { u.setLigaActual(rs.getString("liga_actual")); } catch (SQLException ignore) {}
        try { u.setPuntosTotales(rs.getInt("puntos_totales")); } catch (SQLException ignore) {}
        return u;
    }

    /* ===================== Consultas ===================== */

    public List<Usuario> getAll(boolean soloActivos) throws SQLException {
        String sql = "SELECT id, nombre, email, rol, activo, avatar, liga_actual, puntos_totales FROM usuario"
                   + (soloActivos ? " WHERE activo=1" : "")
                   + " ORDER BY id";
        List<Usuario> out = new ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(mapRow(rs));
        }
        return out;
    }

    /** NUEVO: buscador por nombre/email. includeInactivos=true para ver todo. */
    public List<Usuario> search(String q, boolean includeInactivos) throws SQLException {
        if (q == null) q = "";
        String like = "%" + q.trim() + "%";
        String sql = "SELECT id, nombre, email, rol, activo, avatar, liga_actual, puntos_totales FROM usuario " +
                     "WHERE (nombre LIKE ? OR email LIKE ?) " +
                     (includeInactivos ? "" : "AND activo=1 ") +
                     "ORDER BY id";
        List<Usuario> out = new ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(mapRow(rs));
            }
        }
        return out;
    }

    public Usuario findById(int id) throws SQLException {
        String sql = "SELECT id, nombre, email, rol, activo, avatar, liga_actual, puntos_totales FROM usuario WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public Usuario findByEmail(String email) throws SQLException {
        String sql = "SELECT id, nombre, email, rol, activo, avatar, liga_actual, puntos_totales FROM usuario WHERE email=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /* ===================== Autenticación ===================== */

    public boolean validarLogin(String email, String passwordPlain) throws SQLException {
        String sql = "SELECT password, activo FROM usuario WHERE email=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    System.out.println("DEBUG validarLogin: No se encontró usuario con email=" + email);
                    return false;
                }
                String stored = rs.getString("password");
                boolean activo = rs.getBoolean("activo");
                
                System.out.println("DEBUG validarLogin: email=" + email);
                System.out.println("DEBUG validarLogin: activo=" + activo);
                System.out.println("DEBUG validarLogin: password almacenada (primeros 10 chars)=" + 
                                 (stored != null && stored.length() >= 10 ? stored.substring(0, 10) + "..." : "null"));
                System.out.println("DEBUG validarLogin: password ingresada=" + passwordPlain);
                System.out.println("DEBUG validarLogin: password ingresada hasheada (primeros 10 chars)=" + 
                                 sha256Hex(passwordPlain).substring(0, 10) + "...");
                
                boolean matches = activo && matchesPassword(stored, passwordPlain);
                System.out.println("DEBUG validarLogin: resultado=" + matches);
                
                return matches;
            }
        }
    }

    /* ===================== Altas / Modificaciones ===================== */

    /** Crea usuario (password guardada como SHA-256 HEX). Retorna ID generado. */
    public int create(String nombre, String email, String rol, String passwordPlain) throws SQLException {
        String sql = "INSERT INTO usuario (nombre, email, password, rol, fecha_registro, activo) " +
                     "VALUES (?, ?, ?, ?, NOW(), 1)";
        String hash = sha256Hex(passwordPlain);
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, hash);
            ps.setString(4, rol);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return 0;
    }

    /** Actualiza perfil (no toca contraseña). */
    public boolean updatePerfil(int id, String nombre, String email, String rol, boolean activo) throws SQLException {
        String sql = "UPDATE usuario SET nombre=?, email=?, rol=?, activo=? WHERE id=?";
        Connection con = null;
        try {
            con = DbConn.getInstancia().getConn();
            con.setAutoCommit(true);
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, nombre);
                ps.setString(2, email);
                ps.setString(3, rol);
                ps.setBoolean(4, activo);
                ps.setInt(5, id);
                return ps.executeUpdate() > 0;
            }
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }

    /** Cambia la contraseña (re-hash). */
    public boolean updatePassword(int id, String newPasswordPlain) throws SQLException {
        String sql = "UPDATE usuario SET password=? WHERE id=?";
        String hash = sha256Hex(newPasswordPlain);
        Connection con = null;
        try {
            con = DbConn.getInstancia().getConn();
            // Asegurar que autocommit esté habilitado
            con.setAutoCommit(true);
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, hash);
                ps.setInt(2, id);
                int rowsAffected = ps.executeUpdate();
                
                // DEBUG: Verificar que se actualizó
                System.out.println("DEBUG updatePassword: userId=" + id + ", rowsAffected=" + rowsAffected);
                System.out.println("DEBUG updatePassword: nueva contraseña hash=" + hash.substring(0, 10) + "...");
                
                return rowsAffected > 0;
            }
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }

    /** Baja lógica (activo = 0). */
    public boolean softDelete(int id) throws SQLException {
        String sql = "UPDATE usuario SET activo=0 WHERE id=?";
        Connection con = null;
        try {
            con = DbConn.getInstancia().getConn();
            con.setAutoCommit(true);
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }

    /** Reactivar usuario (activo = 1). */
    public boolean reactivar(int id) throws SQLException {
        String sql = "UPDATE usuario SET activo=1 WHERE id=?";
        Connection con = null;
        try {
            con = DbConn.getInstancia().getConn();
            con.setAutoCommit(true);
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }

    /** Delete físico (si realmente querés borrar). */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM usuario WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
    
    /** Actualiza SOLO nombre y email del propio usuario (jugador o admin). */
    public boolean updatePerfilJugador(int id, String nombre, String email) throws SQLException {
        String sql = "UPDATE usuario SET nombre=?, email=? WHERE id=?";
        Connection con = null;
        try {
            con = DbConn.getInstancia().getConn();
            con.setAutoCommit(true);
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, nombre);
                ps.setString(2, email);
                ps.setInt(3, id);
                return ps.executeUpdate() > 0;
            }
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }
    
    public void setEnPartida(int usuarioId, boolean enPartida) throws SQLException {
        String sql = "UPDATE usuario SET en_partida=? WHERE id=?";
        Connection con = null;
        try {
            con = DbConn.getInstancia().getConn();
            con.setAutoCommit(true);
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setBoolean(1, enPartida);
                ps.setInt(2, usuarioId);
                ps.executeUpdate();
            }
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }

      public boolean isEnPartida(int usuarioId) throws SQLException {
        String sql = "SELECT en_partida FROM usuario WHERE id=?";
        try (Connection c = DbConn.getInstancia().getConn();
             PreparedStatement ps = c.prepareStatement(sql)) {
          ps.setInt(1, usuarioId);
          try (ResultSet rs = ps.executeQuery()) {
            return rs.next() && rs.getBoolean(1);
          }
        }
      }
      
    /** Actualiza solo el avatar de un usuario. */
    public boolean updateAvatar(int id, String avatarPath) throws SQLException {
        String sql = "UPDATE usuario SET avatar=? WHERE id=?";
        Connection con = null;
        try {
            con = DbConn.getInstancia().getConn();
            con.setAutoCommit(true);
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, avatarPath);
                ps.setInt(2, id);
                return ps.executeUpdate() > 0;
            }
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }
    
    /** 
     * Actualiza la liga y puntos totales de un usuario. 
     * Este método se debe llamar cada vez que:
     * 1. Se completa una partida exitosamente
     * 2. Se desbloquea un logro
     * Para mantener la progresión persistente entre reinicios del servidor.
     */
    public boolean actualizarLigaYPuntos(int usuarioId, String ligaActual, int puntosTotales) throws SQLException {
        String sql = "UPDATE usuario SET liga_actual=?, puntos_totales=? WHERE id=?";
        Connection con = null;
        try {
            con = DbConn.getInstancia().getConn();
            con.setAutoCommit(true);
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, ligaActual);
                ps.setInt(2, puntosTotales);
                ps.setInt(3, usuarioId);
                
                int rowsAffected = ps.executeUpdate();
                System.out.println("DEBUG actualizarLigaYPuntos: userId=" + usuarioId + 
                                 ", liga=" + ligaActual + ", puntos=" + puntosTotales + 
                                 ", rowsAffected=" + rowsAffected);
                return rowsAffected > 0;
            }
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { /* ignore */ }
            }
        }
    }
    
    /* ===================== Métodos de estadísticas ===================== */
    
    public int contarTodos() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM usuario";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    public int contarActivos() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM usuario WHERE activo = 1";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    public Map<String, Object> obtenerEstadisticasUsuarios() throws SQLException {
        Map<String, Object> stats = new java.util.HashMap<>();
        
        // Totales
        stats.put("total", contarTodos());
        stats.put("activos", contarActivos());
        stats.put("inactivos", contarTodos() - contarActivos());
        
        // Usuarios por rol
        String sqlRoles = "SELECT rol, COUNT(*) as cantidad FROM usuario GROUP BY rol";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sqlRoles)) {
            java.util.List<Map<String, Object>> roles = new java.util.ArrayList<>();
            while (rs.next()) {
                Map<String, Object> rol = new java.util.HashMap<>();
                rol.put("rol", rs.getString("rol"));
                rol.put("cantidad", rs.getInt("cantidad"));
                roles.add(rol);
            }
            stats.put("roles", roles);
        }
        
        // Usuarios con más partidas
        String sqlPartidas = "SELECT u.nombre, u.apellido, COUNT(p.id) as partidas " +
                             "FROM usuario u LEFT JOIN partida p ON u.id = p.usuario_id " +
                             "GROUP BY u.id ORDER BY partidas DESC LIMIT 10";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sqlPartidas)) {
            java.util.List<Map<String, Object>> topJugadores = new java.util.ArrayList<>();
            while (rs.next()) {
                Map<String, Object> jugador = new java.util.HashMap<>();
                jugador.put("nombre", rs.getString("nombre") + " " + rs.getString("apellido"));
                jugador.put("partidas", rs.getInt("partidas"));
                topJugadores.add(jugador);
            }
            stats.put("topJugadores", topJugadores);
        }
        
        return stats;
    }
}
