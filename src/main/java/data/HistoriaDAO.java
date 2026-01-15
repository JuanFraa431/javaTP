package data;

import entities.Historia;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistoriaDAO {

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

    /** ¿La tabla física tiene la columna? (para armar INSERT/UPDATE dinámicos) */
    private boolean tableHasColumn(Connection con, String table, String column) {
        ResultSet rs = null;
        try {
            DatabaseMetaData md = con.getMetaData();
            // probar tal cual
            rs = md.getColumns(null, null, table, column);
            if (rs.next()) return true;
            rs.close();
            // probar en mayúsculas
            rs = md.getColumns(null, null, table.toUpperCase(), column.toUpperCase());
            if (rs.next()) return true;
            // probar en minúsculas
            rs.close();
            rs = md.getColumns(null, null, table.toLowerCase(), column.toLowerCase());
            return rs.next();
        } catch (SQLException ignored) {
            return false;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        }
    }

    /* ===================== Mapeo seguro ===================== */

    private Historia map(ResultSet rs) throws SQLException {
        Historia h = new Historia();
        if (hasColumn(rs, "id"))               h.setId(rs.getInt("id"));
        if (hasColumn(rs, "titulo"))           h.setTitulo(rs.getString("titulo"));
        if (hasColumn(rs, "descripcion"))      h.setDescripcion(rs.getString("descripcion"));
        if (hasColumn(rs, "contexto"))         h.setContexto(rs.getString("contexto")); // puede no existir
        if (hasColumn(rs, "activa"))           h.setActiva(rs.getBoolean("activa"));
        if (hasColumn(rs, "dificultad"))       h.setDificultad(rs.getInt("dificultad"));
        if (hasColumn(rs, "tiempo_estimado"))  h.setTiempoEstimado(rs.getInt("tiempo_estimado"));
        if (hasColumn(rs, "fecha_creacion"))   h.setFechaCreacion(rs.getTimestamp("fecha_creacion"));

        return h;
    }

    /* ===================== Consultas ===================== */

    /**
     * Lista historias. Si soloActivas es:
     * - true  => solo activas
     * - false => solo inactivas
     * - null  => todas
     */
    public List<Historia> getAll(Boolean soloActivas) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM historia ");
        if (soloActivas != null) {
            sql.append("WHERE activa=").append(soloActivas ? "1" : "0").append(' ');
        }
        sql.append("ORDER BY id DESC");

        List<Historia> out = new ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql.toString());
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        }
        return out;
    }

    public Historia findById(int id) throws SQLException {
        String sql = "SELECT * FROM historia WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    /** Solo activas (para jugador) */
    public List<Historia> getActivas() throws SQLException {
        String sql = "SELECT * FROM historia WHERE activa=1 ORDER BY id";
        List<Historia> out = new ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        }
        return out;
    }

    /** Solo inactivas (por si lo necesitás en admin) */
    public List<Historia> getInactivas() throws SQLException {
        String sql = "SELECT * FROM historia WHERE activa=0 ORDER BY id";
        List<Historia> out = new ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        }
        return out;
    }

    /** Listado breve para jugador (id, titulo, descripcion, activa) */
    public List<Historia> listAllForJugador() throws SQLException {
        String sql = "SELECT id, titulo, descripcion, activa FROM historia ORDER BY id";
        List<Historia> out = new ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Historia h = new Historia();
                h.setId(rs.getInt("id"));
                h.setTitulo(rs.getString("titulo"));
                h.setDescripcion(rs.getString("descripcion"));
                h.setActiva(rs.getBoolean("activa"));
                out.add(h);
            }
        }
        return out;
    }

    public boolean esActiva(int historiaId) throws SQLException {
        String sql = "SELECT activa FROM historia WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, historiaId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getBoolean("activa");
            }
        }
    }

    /* ===================== Altas/Modificaciones ===================== */

    /** INSERT dinámico: incluye columnas solo si existen en la tabla */
    public int create(Historia h) throws SQLException {
        try (Connection con = DbConn.getInstancia().getConn()) {
            boolean hasContexto = tableHasColumn(con, "historia", "contexto");
            boolean hasImagen   = tableHasColumn(con, "historia", "imagen");
            boolean hasFechaCre = tableHasColumn(con, "historia", "fecha_creacion");
            boolean hasDif      = tableHasColumn(con, "historia", "dificultad");
            boolean hasTiempo   = tableHasColumn(con, "historia", "tiempo_estimado");

            StringBuilder cols = new StringBuilder("titulo, descripcion, activa");
            StringBuilder vals = new StringBuilder("?,?,?");
            if (hasContexto) { cols.append(", contexto");         vals.append(",?"); }
            if (hasDif)      { cols.append(", dificultad");       vals.append(",?"); }
            if (hasTiempo)   { cols.append(", tiempo_estimado");  vals.append(",?"); }
            if (hasImagen)   { cols.append(", imagen");           vals.append(",?"); }
            if (hasFechaCre) { cols.append(", fecha_creacion");   vals.append(",NOW()"); } // default ahora

            String sql = "INSERT INTO historia (" + cols + ") VALUES (" + vals + ")";

            try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                int i = 1;
                ps.setString(i++, h.getTitulo());
                ps.setString(i++, h.getDescripcion());
                ps.setBoolean(i++, h.isActiva());
                if (hasContexto) ps.setString(i++, h.getContexto());
                if (hasDif)      ps.setInt(i++,    h.getDificultad());
                if (hasTiempo)   ps.setInt(i++,    h.getTiempoEstimado());
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        }
        return 0;
    }

    /** UPDATE dinámico: setea solo las columnas que existan */
    public boolean update(Historia h) throws SQLException {
        try (Connection con = DbConn.getInstancia().getConn()) {
            boolean hasContexto = tableHasColumn(con, "historia", "contexto");
            boolean hasImagen   = tableHasColumn(con, "historia", "imagen");
            boolean hasDif      = tableHasColumn(con, "historia", "dificultad");
            boolean hasTiempo   = tableHasColumn(con, "historia", "tiempo_estimado");

            StringBuilder sb = new StringBuilder("UPDATE historia SET titulo=?, descripcion=?, activa=?");
            if (hasContexto) sb.append(", contexto=?");
            if (hasDif)      sb.append(", dificultad=?");
            if (hasTiempo)   sb.append(", tiempo_estimado=?");
            sb.append(" WHERE id=?");

            try (PreparedStatement ps = con.prepareStatement(sb.toString())) {
                int i = 1;
                ps.setString(i++, h.getTitulo());
                ps.setString(i++, h.getDescripcion());
                ps.setBoolean(i++, h.isActiva());
                if (hasContexto) ps.setString(i++, h.getContexto());
                if (hasDif)      ps.setInt(i++,    h.getDificultad());
                if (hasTiempo)   ps.setInt(i++,    h.getTiempoEstimado());
                ps.setInt(i, h.getId());
                return ps.executeUpdate() > 0;
            }
        }
    }

    /** Baja lógica: activa = 0 */
    public boolean softDelete(int id) throws SQLException {
        String sql = "UPDATE historia SET activa=0 WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Reactivar: activa = 1 */
    public boolean reactivar(int id) throws SQLException {
        String sql = "UPDATE historia SET activa=1 WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Borrado físico (si lo necesitás) */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM historia WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
