package data;

import entities.Documento;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentoDAO {

    /* ===================== Helpers de metadatos ===================== */

    /** ¿El ResultSet actual tiene la columna (case-insensitive)? */
    private boolean hasColumn(ResultSet rs, String name) {
        try {
            ResultSetMetaData md = rs.getMetaData();
            for (int i = 1; i <= md.getColumnCount(); i++) {
                if (name.equalsIgnoreCase(md.getColumnName(i))) return true;
            }
        } catch (SQLException ignored) {}
        return false;
    }

    /* ===================== Mapeo seguro ===================== */

    private Documento map(ResultSet rs) throws SQLException {
        Documento doc = new Documento();
        if (hasColumn(rs, "id"))                doc.setId(rs.getInt("id"));
        if (hasColumn(rs, "historia_id"))       doc.setHistoriaId(rs.getInt("historia_id"));
        if (hasColumn(rs, "clave"))             doc.setClave(rs.getString("clave"));
        if (hasColumn(rs, "nombre"))            doc.setNombre(rs.getString("nombre"));
        if (hasColumn(rs, "icono"))             doc.setIcono(rs.getString("icono"));
        if (hasColumn(rs, "contenido"))         doc.setContenido(rs.getString("contenido"));
        if (hasColumn(rs, "codigo_correcto"))   doc.setCodigoCorrecto(rs.getString("codigo_correcto"));
        if (hasColumn(rs, "pista_nombre"))      doc.setPistaNombre(rs.getString("pista_nombre"));
        return doc;
    }

    /* ===================== Métodos principales ===================== */

    /**
     * Obtiene todos los documentos de una historia específica
     */
    public List<Documento> findByHistoriaId(int historiaId) throws SQLException {
        String sql = "SELECT id, historia_id, clave, nombre, icono, contenido, " +
                     "codigo_correcto, pista_nombre FROM documento WHERE historia_id = ? ORDER BY id";
        
        List<Documento> docs = new ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, historiaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    docs.add(map(rs));
                }
            }
        }
        return docs;
    }

    /**
     * Obtiene un documento específico por su clave y historia
     */
    public Documento findByClave(int historiaId, String clave) throws SQLException {
        String sql = "SELECT id, historia_id, clave, nombre, icono, contenido, " +
                     "codigo_correcto, pista_nombre FROM documento WHERE historia_id = ? AND clave = ?";
        
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, historiaId);
            ps.setString(2, clave);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    /**
     * Obtiene el documento que contiene el código correcto para una historia
     */
    public Documento findDocumentoConCodigo(int historiaId) throws SQLException {
        String sql = "SELECT id, historia_id, clave, nombre, icono, contenido, " +
                     "codigo_correcto, pista_nombre FROM documento " +
                     "WHERE historia_id = ? AND codigo_correcto IS NOT NULL LIMIT 1";
        
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, historiaId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    /**
     * Valida si un código es correcto para una historia
     */
    public Documento validarCodigo(int historiaId, String codigo) throws SQLException {
        String sql = "SELECT id, historia_id, clave, nombre, icono, contenido, " +
                     "codigo_correcto, pista_nombre FROM documento " +
                     "WHERE historia_id = ? AND codigo_correcto = ?";
        
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, historiaId);
            ps.setString(2, codigo);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    /**
     * Inserta un nuevo documento
     */
    public boolean insert(Documento doc) throws SQLException {
        String sql = "INSERT INTO documento (historia_id, clave, nombre, icono, contenido, " +
                     "codigo_correcto, pista_nombre) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, doc.getHistoriaId());
            ps.setString(2, doc.getClave());
            ps.setString(3, doc.getNombre());
            ps.setString(4, doc.getIcono());
            ps.setString(5, doc.getContenido());
            ps.setString(6, doc.getCodigoCorrecto());
            ps.setString(7, doc.getPistaNombre());
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        doc.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Actualiza un documento existente
     */
    public boolean update(Documento doc) throws SQLException {
        String sql = "UPDATE documento SET clave = ?, nombre = ?, icono = ?, contenido = ?, " +
                     "codigo_correcto = ?, pista_nombre = ? WHERE id = ?";
        
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, doc.getClave());
            ps.setString(2, doc.getNombre());
            ps.setString(3, doc.getIcono());
            ps.setString(4, doc.getContenido());
            ps.setString(5, doc.getCodigoCorrecto());
            ps.setString(6, doc.getPistaNombre());
            ps.setInt(7, doc.getId());
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Elimina un documento
     */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM documento WHERE id = ?";
        
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
