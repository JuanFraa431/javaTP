package logic;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String ctx  = req.getContextPath();                 // ej: /MisterioEnLaMansion
        String uri  = req.getRequestURI();                  // ej: /MisterioEnLaMansion/admin/dashboard
        String path = uri.substring(ctx.length());          // ej: /admin/dashboard

        // Rutas públicas (liberadas)
        boolean isPublic =
                path.equals("/") ||
                path.equals("/index.jsp") ||
                path.equals("/login") ||
                path.equals("/signin") ||
                path.startsWith("/style/") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/img/") ||
                path.startsWith("/images/") ||
                path.startsWith("/fonts/") ||
                path.startsWith("/favicon");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Sesión y rol según lo que guarda tu Login/SigninServlet
        HttpSession s = req.getSession(false);
        String rol = (s == null) ? null : (String) s.getAttribute("rol");

        if (rol == null) {
            // No autenticado -> al login
            resp.sendRedirect(ctx + "/index.jsp");
            return;
        }

        // Autorización por prefijo de ruta
        if (path.startsWith("/admin")) {
            if (!"ADMIN".equalsIgnoreCase(rol)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "No autorizado");
                return;
            }
        } else if (path.startsWith("/jugador")) {
            if (!( "JUGADOR".equalsIgnoreCase(rol) || "ADMIN".equalsIgnoreCase(rol) )) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "No autorizado");
                return;
            }
        }
        // Si pasa, continúa
        chain.doFilter(request, response);
    }
}
