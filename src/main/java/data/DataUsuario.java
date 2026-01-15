package data;

import entities.Usuario;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class DataUsuario {

    /* ================== Helpers de seguridad ================== */

    private static byte[] randomSalt16() {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    /** Hash = SHA-256( password UTF-8 + salt ) */
    private static byte[] hashPassword(String plain, byte[] salt) {
        if (plain == null || salt == null) return null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(plain.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            md.update(salt);
            return md.digest();
        } catch (Exception e) {
            throw new RuntimeException("No se pudo calcular SHA-256", e);
        }
    }

    /** Comparación constante para evitar timing attacks */
    private static boolean slowEquals(byte[] a, byte[] b) {
        if (a == null || b == null) return false;
        if (a.length != b.length) return false;
        int r = 0;
        for (int i = 0; i < a.length; i++) r |= a[i] ^ b[i];
        return r == 0;
    }

    /* ================== Mapeo ================== */

    private Usuario mapRow(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setNombre(rs.getString("nombre"));
        u.setEmail(rs.getString("email"));
        // por seguridad, estos dos SOLO cuando realmente los necesites:
        byte[] salt = safeGetBytes(rs, "salt");
        byte[] hash = safeGetBytes(rs, "password_hash");
        u.setSalt(salt);
        u.setPasswordHash(hash);
        u.setRol(rs.getString("rol"));
        return u;
    }

    private Usuario mapRowSinSecretos(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setNombre(rs.getString("nombre"));
        u.setEmail(rs.getString("email"));
        u.setRol(rs.getString("rol"));
        return u;
    }

    private byte[] safeGetBytes(ResultSet rs, String col) throws SQLException {
        byte[] b = rs.getBytes(col);
        return (rs.wasNull() ? null : b);
    }

    /* ================== Listados / lecturas ================== */

    /** Lista de usuarios SIN exponer salt/hash */
    public LinkedList<Usuario> getAll() {
        final String sql = "SELECT id, username, nombre, email, rol FROM usuario ORDER BY id";
        LinkedList<Usuario> out = new LinkedList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(mapRowSinSecretos(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbConn.getInstancia().releaseConn();
        }
        return out;
    }

    /** Obtiene usuario por ID (sin exponer salt/hash) */
    public Usuario getById(int id) {
        final String sql = "SELECT id, username, nombre, email, rol FROM usuario WHERE id = ?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowSinSecretos(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbConn.getInstancia().releaseConn();
        }
        return null;
    }

    /** Obtiene usuario por email (con o sin secretos, elegí la que necesites) */
    public Usuario getByEmail(String email) {
        final String sql = "SELECT id, username, nombre, email, rol FROM usuario WHERE email = ?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowSinSecretos(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbConn.getInstancia().releaseConn();
        }
        return null;
    }

    /** Versión interna: trae también salt y hash (para validar login) */
    private Usuario getCredencialesByEmail(String email) throws SQLException {
        final String sql = "SELECT id, username, nombre, email, salt, password_hash, rol " +
                           "FROM usuario WHERE email = ?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } finally {
            DbConn.getInstancia().releaseConn();
        }
        return null;
    }

    /* ================== Autenticación ================== */

    /** Valida login por email + password en claro. Devuelve true si coincide el hash. */
    public boolean validarLogin(String email, String passwordPlain) {
        if (email == null || passwordPlain == null) return false;
        try {
            Usuario u = getCredencialesByEmail(email);
            if (u == null || u.getSalt() == null || u.getPasswordHash() == null) return false;
            byte[] calc = hashPassword(passwordPlain, u.getSalt());
            return slowEquals(calc, u.getPasswordHash());
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ================== Altas / cambios ================== */

    /** Alta: genera salt + hash y devuelve el ID asignado */
    public int add(Usuario u, String passwordPlain) {
        final String sql = "INSERT INTO usuario (username, nombre, email, salt, password_hash, rol) " +
                           "VALUES (?, ?, ?, ?, ?, ?)";
        byte[] salt = randomSalt16();
        byte[] hash = hashPassword(passwordPlain, salt);

        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getEmail());
            ps.setBytes(4, salt);
            ps.setBytes(5, hash);
            ps.setString(6, u.getRol());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    u.setId(id);
                    u.setSalt(salt);
                    u.setPasswordHash(hash);
                    return id;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbConn.getInstancia().releaseConn();
        }
        return 0;
    }

    /** Actualiza perfil público (no toca credenciales) */
    public boolean updatePerfil(Usuario u) {
        final String sql = "UPDATE usuario SET username=?, nombre=?, email=?, rol=? WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getRol());
            ps.setInt(5, u.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DbConn.getInstancia().releaseConn();
        }
    }

    /** Cambia contraseña: regenera salt + hash */
    public boolean updatePassword(int id, String newPasswordPlain) {
        final String sql = "UPDATE usuario SET salt=?, password_hash=? WHERE id=?";
        byte[] salt = randomSalt16();
        byte[] hash = hashPassword(newPasswordPlain, salt);

        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBytes(1, salt);
            ps.setBytes(2, hash);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DbConn.getInstancia().releaseConn();
        }
    }

    /** Baja física (si querés soft-delete, agregá columna `activo` y cambiamos) */
    public boolean deleteById(int id) {
        final String sql = "DELETE FROM usuario WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DbConn.getInstancia().releaseConn();
        }
    }

    /* ================== Utilidades opcionales ================== */

    /** Búsqueda simple por texto (nombre/email/username) */
    public List<Usuario> search(String q) {
        final String like = "%" + (q == null ? "" : q.trim()) + "%";
        final String sql = "SELECT id, username, nombre, email, rol FROM usuario " +
                           "WHERE nombre LIKE ? OR email LIKE ? OR username LIKE ? ORDER BY nombre";
        List<Usuario> out = new ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(mapRowSinSecretos(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbConn.getInstancia().releaseConn();
        }
        return out;
    }
}
