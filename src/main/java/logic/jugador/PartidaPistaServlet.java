package logic.jugador;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

//@WebServlet("/jugador/partida/pista")
public class PartidaPistaServlet extends HttpServlet {
    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Muy básico: guardamos en sesión una lista de “pistas”
        HttpSession s = req.getSession(true);
        List<String> pistas = (List<String>) s.getAttribute("pistas");
        if (pistas == null) {
            pistas = new ArrayList<>();
            s.setAttribute("pistas", pistas);
        }

        // Leemos JSON simple {key:'codigo_pc', valor:'7391'}
        String body = req.getReader().lines().reduce("", (a,b)->a+b);
        // súper simple, sin parser: buscamos "valor"
        String valor = "OK";
        int i = body.indexOf("\"valor\"");
        if (i >= 0) {
            int c = body.indexOf(':', i);
            int q1 = body.indexOf('"', c+1);
            int q2 = body.indexOf('"', q1+1);
            if (q1>0 && q2>q1) valor = body.substring(q1+1, q2);
        }
        pistas.add("codigo_pc=" + valor);

        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()){
            out.print("{\"status\":\"ok\"}");
        }
    }
}
