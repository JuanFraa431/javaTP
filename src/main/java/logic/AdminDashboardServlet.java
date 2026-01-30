package logic;

import data.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns={"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        try {
            Map<String, Object> stats = new HashMap<>();
            
            // Estadísticas de Usuarios
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            int totalUsuarios = usuarioDAO.contarTodos();
            int usuariosActivos = usuarioDAO.contarActivos();
            stats.put("totalUsuarios", totalUsuarios);
            stats.put("usuariosActivos", usuariosActivos);
            stats.put("usuariosInactivos", totalUsuarios - usuariosActivos);
            
            // Estadísticas de Historias
            HistoriaDAO historiaDAO = new HistoriaDAO();
            int totalHistorias = historiaDAO.contarTodas();
            int historiasActivas = historiaDAO.contarActivas();
            stats.put("totalHistorias", totalHistorias);
            stats.put("historiasActivas", historiasActivas);
            stats.put("historiasInactivas", totalHistorias - historiasActivas);
            
            // Estadísticas de Partidas
            PartidaDAO partidaDAO = new PartidaDAO();
            int totalPartidas = partidaDAO.contarTodas();
            int partidasEnCurso = partidaDAO.contarEnCurso();
            int partidasCompletadas = partidaDAO.contarCompletadas();
            stats.put("totalPartidas", totalPartidas);
            stats.put("partidasEnCurso", partidasEnCurso);
            stats.put("partidasCompletadas", partidasCompletadas);
            
            // Estadísticas de Logros
            LogroDAO logroDAO = new LogroDAO();
            int totalLogros = logroDAO.contarTotalLogros();
            stats.put("totalLogros", totalLogros);
            
            // Estadísticas de Contenido
            UbicacionDAO ubicacionDAO = new UbicacionDAO();
            DocumentoDAO documentoDAO = new DocumentoDAO();
            int totalUbicaciones = ubicacionDAO.contarTodas();
            int totalDocumentos = documentoDAO.contarTodos();
            stats.put("totalUbicaciones", totalUbicaciones);
            stats.put("totalDocumentos", totalDocumentos);
            
            req.setAttribute("stats", stats);
            
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error al cargar estadísticas");
        }
        
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
