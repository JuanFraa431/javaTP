package logic;

import entities.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int MAX_INTENTOS = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // si ya está logueado, mandá según rol; si no, al login
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("rol") != null) {
            redirectByRole(resp, req.getContextPath(), String.valueOf(s.getAttribute("rol")));
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // control simple de intentos por sesión
        HttpSession pre = request.getSession(true);
        Integer intentos = (Integer) pre.getAttribute("login_intentos");
        if (intentos == null) intentos = 0;
        if (intentos >= MAX_INTENTOS) {
            setErrorAndBack(request, response, "Demasiados intentos fallidos. Probá más tarde.");
            return;
        }

        // tu form usa "usuario"; también soportamos "username" o "email"
        String ident = firstNonBlank(
                request.getParameter("usuario"),
                request.getParameter("username"),
                request.getParameter("email")
        );
        String password = trimOrNull(request.getParameter("password"));

        if (ident == null || password == null) {
            setErrorAndBack(request, response, "Completá usuario/email y contraseña.");
            return;
        }

        // en tu base el login es por email; si llega un "usuario" que no tiene @, igual lo intentamos
        String email = ident.trim().toLowerCase();

        CtrlUsuario ctrl = new CtrlUsuario();
        try {
            Usuario u = ctrl.validate(email, password); // retorna null si inválido o inactivo
            if (u == null) {
                pre.setAttribute("login_intentos", intentos + 1);
                setErrorAndBack(request, response, "Credenciales inválidas o usuario inactivo.");
                return;
            }

            // session fixation protection
            pre.invalidate();
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(30 * 60); // 30 min
            session.setAttribute("usuario", u); // Objeto completo
            session.setAttribute("userId", u.getId());
            session.setAttribute("nombre", u.getNombre());
            session.setAttribute("email", u.getEmail());
            session.setAttribute("rol", u.getRol());

            // cookie para recordar el último email
            Cookie c = new Cookie("last_user", u.getEmail());
            c.setHttpOnly(true);
            c.setSecure(request.isSecure());
            c.setMaxAge(7 * 24 * 60 * 60);
            c.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            response.addCookie(c);

            // redirección por rol
            redirectByRole(response, request.getContextPath(), u.getRol());

        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndBack(request, response, "Ocurrió un problema al iniciar sesión.");
        }
    }

    /* ================= Helpers ================= */

    private void setErrorAndBack(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        // Si estás usando index.jsp como login, forward a index.jsp:
        // req.getRequestDispatcher("/index.jsp").forward(req, resp);
        // Si usás la JSP protegida:
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private void redirectByRole(HttpServletResponse resp, String ctx, String rol) throws IOException {
        if (rol == null) { resp.sendRedirect(ctx + "/"); return; }
        switch (rol.toUpperCase()) {
            case "ADMIN"   -> resp.sendRedirect(ctx + "/admin/dashboard");
            case "JUGADOR" -> resp.sendRedirect(ctx + "/jugador/home");
            default        -> resp.sendRedirect(ctx + "/");
        }
    }

    private static String trimOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private static String firstNonBlank(String... vals) {
        if (vals == null) return null;
        for (String v : vals) {
            String t = trimOrNull(v);
            if (t != null) return t;
        }
        return null;
    }
}
