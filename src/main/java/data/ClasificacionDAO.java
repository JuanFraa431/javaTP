package data;

import java.sql.*;
import java.util.*;

public class ClasificacionDAO {
    
    /**
     * Calcula la liga del usuario según sus puntos totales
     */
    public String calcularLiga(int usuarioId) throws SQLException {
        int puntosTotales = calcularPuntosTotales(usuarioId);
        return getLigaPorPuntos(puntosTotales);
    }
    
    /**
     * Determina la liga según los puntos
     */
    public static String getLigaPorPuntos(int puntos) {
        if (puntos >= 1000) return "diamante";
        if (puntos >= 601) return "platino";
        if (puntos >= 301) return "oro";
        if (puntos >= 101) return "plata";
        return "bronce";
    }
    
    /**
     * Calcula puntos totales del usuario (partidas + logros)
     */
    public int calcularPuntosTotales(int usuarioId) throws SQLException {
        String sql = "SELECT " +
                     "(SELECT COALESCE(SUM(puntuacion), 0) FROM partida WHERE usuario_id = ? AND estado = 'ganada') + " +
                     "(SELECT COALESCE(SUM(l.puntos), 0) FROM usuario_logro ul INNER JOIN logro l ON ul.logro_id = l.id WHERE ul.usuario_id = ?) " +
                     "as total";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
    
    /**
     * Obtiene el ranking global (top usuarios por puntos)
     */
    public List<Map<String, Object>> getRankingGlobal(int limite) throws SQLException {
        List<Map<String, Object>> ranking = new ArrayList<>();
        
        String sql = "SELECT u.id, u.nombre, u.email, " +
                     "(SELECT COALESCE(SUM(p.puntuacion), 0) FROM partida p WHERE p.usuario_id = u.id AND p.estado = 'ganada') + " +
                     "(SELECT COALESCE(SUM(l.puntos), 0) FROM usuario_logro ul INNER JOIN logro l ON ul.logro_id = l.id WHERE ul.usuario_id = u.id) as puntos_totales, " +
                     "(SELECT COUNT(*) FROM partida WHERE usuario_id = u.id AND estado = 'ganada') as casos_resueltos, " +
                     "(SELECT COUNT(*) FROM usuario_logro WHERE usuario_id = u.id) as logros " +
                     "FROM usuario u " +
                     "WHERE u.activo = 1 AND u.rol = 'JUGADOR' " +
                     "ORDER BY puntos_totales DESC, casos_resueltos DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                int posicion = 1;
                while (rs.next()) {
                    Map<String, Object> jugador = new HashMap<>();
                    jugador.put("posicion", posicion++);
                    jugador.put("id", rs.getInt("id"));
                    jugador.put("nombre", rs.getString("nombre"));
                    jugador.put("puntos", rs.getInt("puntos_totales"));
                    jugador.put("casosResueltos", rs.getInt("casos_resueltos"));
                    jugador.put("logros", rs.getInt("logros"));
                    jugador.put("liga", getLigaPorPuntos(rs.getInt("puntos_totales")));
                    ranking.add(jugador);
                }
            }
        }
        return ranking;
    }
    
    /**
     * Obtiene el ranking filtrado por liga específica
     */
    public List<Map<String, Object>> getRankingPorLiga(String liga, int limite) throws SQLException {
        List<Map<String, Object>> todosLosJugadores = getRankingGlobal(1000); // Obtener todos
        List<Map<String, Object>> rankingLiga = new ArrayList<>();
        
        int posicion = 1;
        for (Map<String, Object> jugador : todosLosJugadores) {
            if (jugador.get("liga").equals(liga)) {
                jugador.put("posicion", posicion++);
                rankingLiga.add(jugador);
                if (rankingLiga.size() >= limite) break;
            }
        }
        
        return rankingLiga;
    }
    
    /**
     * Obtiene la posición del usuario en el ranking global
     */
    public int getPosicionUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT COUNT(*) + 1 as posicion FROM usuario u " +
                     "WHERE u.activo = 1 AND u.rol = 'JUGADOR' AND " +
                     "((SELECT COALESCE(SUM(p.puntuacion), 0) FROM partida p WHERE p.usuario_id = u.id AND p.estado = 'ganada') + " +
                     " (SELECT COALESCE(SUM(l.puntos), 0) FROM usuario_logro ul INNER JOIN logro l ON ul.logro_id = l.id WHERE ul.usuario_id = u.id)) > " +
                     "((SELECT COALESCE(SUM(p.puntuacion), 0) FROM partida p WHERE p.usuario_id = ? AND p.estado = 'ganada') + " +
                     " (SELECT COALESCE(SUM(l.puntos), 0) FROM usuario_logro ul INNER JOIN logro l ON ul.logro_id = l.id WHERE ul.usuario_id = ?))";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("posicion");
                }
            }
        }
        return 0;
    }
    
    /**
     * Obtiene estadísticas de distribución de jugadores por liga
     */
    public Map<String, Integer> getDistribucionLigas() throws SQLException {
        List<Map<String, Object>> todosLosJugadores = getRankingGlobal(10000);
        Map<String, Integer> distribucion = new HashMap<>();
        
        distribucion.put("bronce", 0);
        distribucion.put("plata", 0);
        distribucion.put("oro", 0);
        distribucion.put("platino", 0);
        distribucion.put("diamante", 0);
        
        for (Map<String, Object> jugador : todosLosJugadores) {
            String liga = (String) jugador.get("liga");
            distribucion.put(liga, distribucion.get(liga) + 1);
        }
        
        return distribucion;
    }
}
