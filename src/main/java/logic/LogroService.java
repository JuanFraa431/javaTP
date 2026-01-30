package logic;

import data.ClasificacionDAO;
import data.LogroDAO;
import data.PartidaDAO;
import data.ProgresoPistaDAO;
import data.ProgresoUbicacionDAO;
import data.UsuarioDAO;
import entities.Partida;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Servicio para verificar y otorgar logros automáticamente
 */
public class LogroService {
    private final LogroDAO logroDAO = new LogroDAO();
    private final PartidaDAO partidaDAO = new PartidaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final ClasificacionDAO clasificacionDAO = new ClasificacionDAO();
    private final ProgresoPistaDAO progresoPistaDAO = new ProgresoPistaDAO();
    private final ProgresoUbicacionDAO progresoUbicacionDAO = new ProgresoUbicacionDAO();
    
    /**
     * Verifica y otorga todos los logros aplicables después de que una partida termine
     */
    public void verificarLogrosPartidaFinalizada(int usuarioId, int partidaId) throws SQLException {
        Partida partida = partidaDAO.findById(partidaId);
        if (partida == null) return;
        
        // Solo verificar logros si la partida fue ganada
        if (!"GANADA".equals(partida.getEstado())) return;
        
        // Verificar cada logro
        verificarPrimerCaso(usuarioId);
        verificarDetectiveNovato(usuarioId);
        verificarDetectiveExperto(usuarioId);
        verificarPerfeccionista(usuarioId, partida);
        verificarColeccionista(usuarioId);
        verificarExplorador(usuarioId);
        verificarVelocista(usuarioId, partida);
        verificarMadrugador(partida);
        verificarNocturno(partida);
        verificarPersistente(usuarioId);
        
        // CRÍTICO: Después de verificar los logros, actualizar la liga y puntos del usuario
        // Esto asegura que la progresión persista entre reinicios del servidor
        actualizarLigaUsuario(usuarioId);
    }
    
    /**
     * Calcula y persiste la liga actual del usuario basada en sus puntos totales.
     * Este método se llama automáticamente después de:
     * 1. Finalizar una partida ganada
     * 2. Desbloquear logros
     */
    private void actualizarLigaUsuario(int usuarioId) throws SQLException {
        // Calcular puntos totales desde las partidas y logros
        int puntosTotales = clasificacionDAO.calcularPuntosTotales(usuarioId);
        
        // Determinar la liga según los puntos
        String ligaActual = clasificacionDAO.getLigaPorPuntos(puntosTotales);
        
        // Persistir en la base de datos
        usuarioDAO.actualizarLigaYPuntos(usuarioId, ligaActual, puntosTotales);
    }
    
    /**
     * Logro: primer_caso - Completar tu primera partida
     */
    private void verificarPrimerCaso(int usuarioId) throws SQLException {
        List<Partida> ganadas = partidaDAO.findByUsuarioAndEstado(usuarioId, "GANADA");
        if (ganadas.size() == 1) {
            logroDAO.desbloquearLogro(usuarioId, "primer_caso");
        }
    }
    
    /**
     * Logro: detective_novato - Ganar 3 partidas
     */
    private void verificarDetectiveNovato(int usuarioId) throws SQLException {
        List<Partida> ganadas = partidaDAO.findByUsuarioAndEstado(usuarioId, "GANADA");
        if (ganadas.size() >= 3) {
            logroDAO.desbloquearLogro(usuarioId, "detective_novato");
        }
    }
    
    /**
     * Logro: detective_experto - Ganar 10 partidas
     */
    private void verificarDetectiveExperto(int usuarioId) throws SQLException {
        List<Partida> ganadas = partidaDAO.findByUsuarioAndEstado(usuarioId, "GANADA");
        if (ganadas.size() >= 10) {
            logroDAO.desbloquearLogro(usuarioId, "detective_experto");
        }
    }
    
    /**
     * Logro: perfeccionista - Ganar una partida con puntuación perfecta (>95%)
     */
    private void verificarPerfeccionista(int usuarioId, Partida partida) throws SQLException {
        if (partida.getPuntuacion() >= 95) {
            logroDAO.desbloquearLogro(usuarioId, "perfeccionista");
        }
    }
    
    /**
     * Logro: coleccionista - Encontrar todas las pistas en 5 casos diferentes
     */
    private void verificarColeccionista(int usuarioId) throws SQLException {
        List<Partida> ganadas = partidaDAO.findByUsuarioAndEstado(usuarioId, "GANADA");
        
        int casosConTodasLasPistas = 0;
        Set<Integer> historiasVerificadas = new HashSet<>();
        
        for (Partida partida : ganadas) {
            int historiaId = partida.getHistoriaId();
            
            // Evitar contar la misma historia múltiples veces
            if (historiasVerificadas.contains(historiaId)) continue;
            
            // Contar pistas totales en la historia
            int totalPistas = partidaDAO.contarPistasPorHistoria(historiaId);
            
            // Contar pistas encontradas en esta partida
            int pistasEncontradas = progresoPistaDAO.contarPistasPorPartida(partida.getId());
            
            // Si encontró todas las pistas de esta historia
            if (totalPistas > 0 && pistasEncontradas >= totalPistas) {
                casosConTodasLasPistas++;
                historiasVerificadas.add(historiaId);
                
                // Si completó 5 historias diferentes con todas las pistas
                if (casosConTodasLasPistas >= 5) {
                    logroDAO.desbloquearLogro(usuarioId, "coleccionista");
                    return;
                }
            }
        }
    }
    
    /**
     * Logro: velocista - Completar una partida en menos de 10 minutos
     */
    private void verificarVelocista(int usuarioId, Partida partida) throws SQLException {
        Timestamp inicio = partida.getFechaInicio();
        Timestamp fin = partida.getFechaFin();
        
        if (inicio != null && fin != null) {
            long duracionMinutos = (fin.getTime() - inicio.getTime()) / (1000 * 60);
            if (duracionMinutos < 10) {
                logroDAO.desbloquearLogro(usuarioId, "velocista");
            }
        }
    }
    
    /**
     * Logro: madrugador - Iniciar una partida entre 5am-7am
     */
    private void verificarMadrugador(Partida partida) throws SQLException {
        if (partida.getFechaInicio() == null) return;
        
        LocalDateTime fechaInicio = partida.getFechaInicio().toLocalDateTime();
        LocalTime hora = fechaInicio.toLocalTime();
        
        if (hora.getHour() >= 5 && hora.getHour() < 7) {
            logroDAO.desbloquearLogro(partida.getUsuarioId(), "madrugador");
        }
    }
    
    /**
     * Logro: nocturno - Resolver un caso entre 12am-3am
     */
    private void verificarNocturno(Partida partida) throws SQLException {
        if (partida.getFechaFin() == null) return;
        
        LocalDateTime fechaFin = partida.getFechaFin().toLocalDateTime();
        LocalTime hora = fechaFin.toLocalTime();
        
        // Entre 00:00 (12am) y 03:00 (3am)
        if (hora.getHour() >= 0 && hora.getHour() < 3) {
            logroDAO.desbloquearLogro(partida.getUsuarioId(), "nocturno");
        }
    }
    
    /**
     * Logro: explorador - Visitar todas las ubicaciones en 3 historias
     */
    private void verificarExplorador(int usuarioId) throws SQLException {
        List<Partida> ganadas = partidaDAO.findByUsuarioAndEstado(usuarioId, "GANADA");
        
        int historiasConTodasUbicaciones = 0;
        Set<Integer> historiasVerificadas = new HashSet<>();
        
        for (Partida partida : ganadas) {
            int historiaId = partida.getHistoriaId();
            
            // Evitar contar la misma historia múltiples veces
            if (historiasVerificadas.contains(historiaId)) continue;
            
            // Contar ubicaciones totales en la historia
            int totalUbicaciones = partidaDAO.contarUbicacionesPorHistoria(historiaId);
            
            // Contar ubicaciones visitadas en esta partida
            int ubicacionesVisitadas = progresoUbicacionDAO.contarUbicacionesPorPartida(partida.getId());
            
            // Si visitó todas las ubicaciones de esta historia
            if (totalUbicaciones > 0 && ubicacionesVisitadas >= totalUbicaciones) {
                historiasConTodasUbicaciones++;
                historiasVerificadas.add(historiaId);
                
                // Si completó 3 historias diferentes con todas las ubicaciones
                if (historiasConTodasUbicaciones >= 3) {
                    logroDAO.desbloquearLogro(usuarioId, "explorador");
                    return;
                }
            }
        }
    }
    
    /**
     * Logro: persistente - Jugar 5 días consecutivos
     */
    private void verificarPersistente(int usuarioId) throws SQLException {
        List<Partida> partidas = partidaDAO.findByUsuarioOrderByFecha(usuarioId);
        
        if (partidas.size() < 5) return;
        
        int diasConsecutivos = 1;
        LocalDateTime ultimaFecha = null;
        
        for (Partida p : partidas) {
            if (p.getFechaInicio() == null) continue;
            
            LocalDateTime fechaPartida = p.getFechaInicio().toLocalDateTime();
            
            if (ultimaFecha != null) {
                long diasDiferencia = java.time.temporal.ChronoUnit.DAYS.between(
                    ultimaFecha.toLocalDate(), 
                    fechaPartida.toLocalDate()
                );
                
                if (diasDiferencia == 1) {
                    diasConsecutivos++;
                    if (diasConsecutivos >= 5) {
                        logroDAO.desbloquearLogro(usuarioId, "persistente");
                        return;
                    }
                } else if (diasDiferencia > 1) {
                    diasConsecutivos = 1;
                }
            }
            
            ultimaFecha = fechaPartida;
        }
    }
}
