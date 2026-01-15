package logic.admin;

import data.DbConn;
import data.HistoriaDAO;
import entities.Historia;
import entities.Personaje;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet("/admin/personajes/form")
public class AdminPersonajeFormServlet extends HttpServlet {

    private final HistoriaDAO historiaDAO = new HistoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isBlank()) {
            try {
                int id = Integer.parseInt(idStr);
                Personaje p = getPersonajeById(id);
                if (p != null) {
                    req.setAttribute("personaje", p);
                } else {
                    req.setAttribute("error", "Personaje no encontrado");
                }
            } catch (NumberFormatException | SQLException e) {
                req.setAttribute("error", "Error al cargar personaje: " + e.getMessage());
            }
        }

        // Cargar historias para el select (todas, activas e inactivas)
        try {
            List<Historia> historias = historiaDAO.getAll(null);
            req.setAttribute("historias", historias);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/personajes/form.jsp")
           .forward(req, resp);
    }

    private Personaje getPersonajeById(int id) throws SQLException {
        String sql = "SELECT * FROM personaje WHERE id = ?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Personaje p = new Personaje();
                    p.setId(rs.getInt("id"));
                    p.setNombre(rs.getString("nombre"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setCoartada(rs.getString("coartada"));
                    p.setMotivo(rs.getString("motivo"));
                    p.setSospechoso(rs.getInt("sospechoso"));
                    p.setCulpable(rs.getInt("culpable"));
                    p.setHistoriaId(rs.getInt("historia_id"));
                    return p;
                }
            }
        }
        return null;
    }
}
