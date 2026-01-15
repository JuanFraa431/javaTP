package logic.jugador;

import data.PartidaDAO;
import data.ProgresoPistaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * POST /jugador/partida/pista
 * JSON esperado: { "key": "codigo_pc", "valor": "7391" }
 */
@WebServlet("/jugador/partida/pista")
public class GuardarPistaServlet extends HttpServlet {

    private final PartidaDAO pdao = new PartidaDAO();
    private final ProgresoPistaDAO progresoPistaDAO = new ProgresoPistaDAO();
    private static final String CODE_OK = "7391";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("========================================");
        System.out.println("[GuardarPistaServlet] POST recibido");
        System.out.println("========================================");

        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            System.out.println("[GuardarPistaServlet] ERROR: Sin sesión o sin userId");
            resp.setStatus(401);
            return;
        }

        // Leer cuerpo como texto
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        String body = sb.toString();
        System.out.println("[GuardarPistaServlet] Body recibido: " + body);

        // Extraer key y valor con regex muy simple
        String key = extract(body, "\"key\"\\s*:\\s*\"([^\"]+)\"");
        String valor = extract(body, "\"valor\"\\s*:\\s*\"([^\"]+)\"");

        Integer partidaId = (Integer) s.getAttribute("partidaId");
        Integer historiaId = (Integer) s.getAttribute("historiaId");
        
        System.out.println("[GuardarPistaServlet] partidaId de sesión: " + partidaId);
        System.out.println("[GuardarPistaServlet] historiaId de sesión: " + historiaId);
        System.out.println("[GuardarPistaServlet] key extraída: " + key);
        System.out.println("[GuardarPistaServlet] valor extraído: " + valor);
        
        if (partidaId == null || historiaId == null) {
            System.out.println("[GuardarPistaServlet] ERROR: partidaId o historiaId es null");
            resp.setStatus(400);
            return;
        }

        boolean win = false;
        try {
            System.out.println("[GuardarPistaServlet] Comparando key: '" + key + "' con 'codigo_pc'");
            if ("codigo_pc".equalsIgnoreCase(key)) {
                System.out.println("[GuardarPistaServlet] ✓ Key coincide con 'codigo_pc'");
                System.out.println("[GuardarPistaServlet] Comparando valor: '" + valor + "' (sin espacios: '" + (valor != null ? valor.replaceAll("\\s+", "") : "null") + "') con '" + CODE_OK + "'");
                if (valor != null && valor.replaceAll("\\s+", "").equals(CODE_OK)) {
                    System.out.println("[GuardarPistaServlet] ✓✓✓ CÓDIGO CORRECTO ✓✓✓");
                    
                    // Buscar el ID de la pista "Código de la computadora"
                    Integer pistaId = progresoPistaDAO.findPistaIdByNombre(historiaId, "Código de la computadora");
                    
                    System.out.println("[DEBUG] Historia ID: " + historiaId);
                    System.out.println("[DEBUG] Pista ID encontrado: " + pistaId);
                    
                    // Si la pista existe, registrarla PRIMERO
                    if (pistaId != null) {
                        System.out.println("[GuardarPistaServlet] Llamando a pdao.guardarPista(" + partidaId + ", " + pistaId + ")");
                        boolean guardada = pdao.guardarPista(partidaId, pistaId);
                        System.out.println("[DEBUG] Pista guardada: " + guardada);
                    } else {
                        System.out.println("[ERROR] No se encontró la pista 'Código de la computadora' para historia_id=" + historiaId);
                    }
                    
                    System.out.println("[GuardarPistaServlet] Actualizando solución propuesta...");
                    // Actualizar solución propuesta
                    pdao.actualizarSolucionPropuesta(partidaId, "Código descifrado: " + CODE_OK);
                    
                    System.out.println("[GuardarPistaServlet] Marcando como ganada...");
                    // Marcar como ganada (esto NO debe resetear pistas_encontradas)
                    pdao.marcarGanada(partidaId, 100);
                    
                    win = true;
                    System.out.println("[GuardarPistaServlet] ✓ Proceso completado, win=true");
                } else {
                    System.out.println("[GuardarPistaServlet] ✗ Código incorrecto o valor null");
                }
            } else {
                System.out.println("[GuardarPistaServlet] ✗ Key NO coincide con 'codigo_pc'");
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] SQLException en GuardarPistaServlet:");
            e.printStackTrace();
            resp.setStatus(500);
            return;
        }

        // Respuesta JSON manual
        String json = "{\"ok\":true, \"win\":" + win + "}";
        System.out.println("[GuardarPistaServlet] Enviando respuesta: " + json);
        System.out.println("========================================");
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(json);
    }

    /** Helper simple para extraer un grupo de regex */
    private String extract(String text, String regex) {
        Matcher m = Pattern.compile(regex).matcher(text);
        return m.find() ? m.group(1) : null;
    }
}
