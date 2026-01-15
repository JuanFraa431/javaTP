package data;

import entities.Usuario;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
        return u;
    }

    /* ===================== Consultas ===================== */

    public List<Usuario> getAll(boolean soloActivos) throws SQLException {
        String sql = "SELECT id, nombre, email, rol, activo FROM usuario"
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
        String sql = "SELECT id, nombre, email, rol, activo FROM usuario " +
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
        String sql = "SELECT id, nombre, email, rol, activo FROM usuario WHERE id=?";
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
        String sql = "SELECT id, nombre, email, rol, activo FROM usuario WHERE email=?";
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
                if (!rs.next()) return false;
                String stored = rs.getString("password");
                boolean activo = rs.getBoolean("activo");
                return activo && matchesPassword(stored, passwordPlain);
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
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, rol);
            ps.setBoolean(4, activo);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Cambia la contraseña (re-hash). */
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

    /** Baja lógica (activo = 0). */
    public boolean softDelete(int id) throws SQLException {
        String sql = "UPDATE usuario SET activo=0 WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Reactivar usuario (activo = 1). */
    public boolean reactivar(int id) throws SQLException {
        String sql = "UPDATE usuario SET activo=1 WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
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
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        }
    }
    
    public void setEnPartida(int usuarioId, boolean enPartida) throws SQLException {
        String sql = "UPDATE usuario SET en_partida=? WHERE id=?";
        try (Connection c = DbConn.getInstancia().getConn();
             PreparedStatement ps = c.prepareStatement(sql)) {
          ps.setBoolean(1, enPartida);
          ps.setInt(2, usuarioId);
          ps.executeUpdate();
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
}
