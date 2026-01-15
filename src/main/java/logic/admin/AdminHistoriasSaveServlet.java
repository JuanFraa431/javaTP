package logic.admin;

import data.HistoriaDAO;
import entities.Historia;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/historias/save")
public class AdminHistoriasSaveServlet extends HttpServlet {
    private final HistoriaDAO dao = new HistoriaDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/jugador/home");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        Historia h = new Historia();
        String idStr = req.getParameter("id");

        h.setTitulo(trim(req.getParameter("titulo")));
        h.setDescripcion(trim(req.getParameter("descripcion")));
        h.setContexto(trim(req.getParameter("contexto")));
        h.setActiva(req.getParameter("activa") != null);
        try { h.setDificultad(Integer.parseInt(req.getParameter("dificultad"))); } catch(Exception e){ h.setDificultad(1); }
        try { h.setTiempoEstimado(Integer.parseInt(req.getParameter("tiempo_estimado"))); } catch(Exception e){ h.setTiempoEstimado(0); }

        if (h.getTitulo() == null || h.getTitulo().isBlank()
                || h.getDescripcion() == null || h.getDescripcion().isBlank()){
            s.setAttribute("flash_error", "Título y descripción son obligatorios.");
            resp.sendRedirect(req.getContextPath() + "/admin/historias/form" + (idStr!=null?("?id="+idStr):""));
            return;
        }

        try {
            if (idStr == null || idStr.isBlank()) {
                int id = dao.create(h);
                s.setAttribute("flash_ok", "Historia creada (ID " + id + ").");
            } else {
                h.setId(Integer.parseInt(idStr));
                dao.update(h);
                s.setAttribute("flash_ok", "Historia actualizada.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            s.setAttribute("flash_error", "No se pudo guardar la historia.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/historias");
    }

    private String trim(String v){ return v==null? null : v.trim(); }
}
