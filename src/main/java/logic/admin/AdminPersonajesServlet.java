package logic.admin;

import data.DbConn;
import entities.Personaje;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/personajes")
public class AdminPersonajesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/jugador/home");
            return;
        }

        String q = req.getParameter("q");
        List<Personaje> personajes = new ArrayList<>();
        
        try {
            String sql;
            if (q != null && !q.trim().isEmpty()) {
                sql = "SELECT p.*, h.titulo as historia_titulo FROM personaje p " +
                      "LEFT JOIN historia h ON p.historia_id = h.id " +
                      "WHERE p.nombre LIKE ? OR p.descripcion LIKE ? " +
                      "ORDER BY p.historia_id, p.id";
                try (Connection con = DbConn.getInstancia().getConn();
                     PreparedStatement ps = con.prepareStatement(sql)) {
                    String search = "%" + q.trim() + "%";
                    ps.setString(1, search);
                    ps.setString(2, search);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            personajes.add(mapPersonaje(rs));
                        }
                    }
                }
                req.setAttribute("q", q.trim());
            } else {
                sql = "SELECT p.*, h.titulo as historia_titulo FROM personaje p " +
                      "LEFT JOIN historia h ON p.historia_id = h.id " +
                      "ORDER BY p.historia_id, p.id";
                try (Connection con = DbConn.getInstancia().getConn();
                     Statement st = con.createStatement();
                     ResultSet rs = st.executeQuery(sql)) {
                    while (rs.next()) {
                        personajes.add(mapPersonaje(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error al cargar personajes.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        req.setAttribute("personajes", personajes);
        req.getRequestDispatcher("/WEB-INF/views/admin/personajes/list.jsp").forward(req, resp);
    }

    private Personaje mapPersonaje(ResultSet rs) throws SQLException {
        Personaje p = new Personaje();
        p.setId(rs.getInt("id"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setCoartada(rs.getString("coartada"));
        p.setMotivo(rs.getString("motivo"));
        p.setSospechoso(rs.getInt("sospechoso"));
        p.setCulpable(rs.getInt("culpable"));
        p.setHistoriaId(rs.getInt("historia_id"));
        try {
            p.setHistoriaTitulo(rs.getString("historia_titulo"));
        } catch (SQLException e) {
            // columna puede no existir en algunos casos
        }
        return p;
    }
}
