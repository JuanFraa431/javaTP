package logic;

import data.ClasificacionDAO;
import data.LogroDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns={"/jugador/home"})
public class JugadorHomeServlet extends HttpServlet {
    private final ClasificacionDAO clasificacionDAO = new ClasificacionDAO();
    private final LogroDAO logroDAO = new LogroDAO();
    
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId != null) {
            try {
                // Calcular estadísticas del usuario
                int puntosTotales = clasificacionDAO.calcularPuntosTotales(userId);
                String ligaActual = clasificacionDAO.calcularLiga(userId);
                
                // Datos para la próxima liga
                String proximaLiga = obtenerProximaLiga(ligaActual);
                int puntosProximaLiga = obtenerPuntosProximaLiga(ligaActual);
                int puntosFaltantes = puntosProximaLiga - puntosTotales;
                int porcentajeProgreso = calcularPorcentaje(puntosTotales, ligaActual, puntosProximaLiga);
                
                // Logros desbloqueados
                int logrosDesbloqueados = logroDAO.contarLogrosDesbloqueados(userId);
                int totalLogros = logroDAO.contarTotalLogros();
                
                // Enviar atributos
                req.setAttribute("puntosTotales", puntosTotales);
                req.setAttribute("ligaActual", ligaActual);
                req.setAttribute("proximaLiga", proximaLiga);
                req.setAttribute("puntosProximaLiga", puntosProximaLiga);
                req.setAttribute("puntosFaltantes", puntosFaltantes);
                req.setAttribute("porcentajeProgreso", porcentajeProgreso);
                req.setAttribute("logrosDesbloqueados", logrosDesbloqueados);
                req.setAttribute("totalLogros", totalLogros);
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        req.getRequestDispatcher("/WEB-INF/views/jugador/home.jsp").forward(req, resp);
    }
    
    private String obtenerProximaLiga(String ligaActual) {
        switch (ligaActual) {
            case "bronce": return "plata";
            case "plata": return "oro";
            case "oro": return "platino";
            case "platino": return "diamante";
            default: return "diamante";
        }
    }
    
    private int obtenerPuntosProximaLiga(String ligaActual) {
        switch (ligaActual) {
            case "bronce": return 101;
            case "plata": return 301;
            case "oro": return 601;
            case "platino": return 1001;
            default: return 9999;
        }
    }
    
    private int calcularPorcentaje(int puntos, String liga, int puntosProxima) {
        int puntosBase = 0;
        switch (liga) {
            case "bronce": puntosBase = 0; break;
            case "plata": puntosBase = 101; break;
            case "oro": puntosBase = 301; break;
            case "platino": puntosBase = 601; break;
            case "diamante": return 100;
        }
        
        int rangoLiga = puntosProxima - puntosBase;
        int progresoLiga = puntos - puntosBase;
        return Math.min(100, (progresoLiga * 100) / rangoLiga);
    }
}
