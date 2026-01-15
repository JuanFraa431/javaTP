package ui;

import java.util.Scanner;
import java.util.LinkedList;

import logic.*;
import entities.*;

public class MenuJugar {
    public static void mostrar() {
        @SuppressWarnings("resource")

        Scanner sc = new Scanner(System.in);
        Login login = new Login();
        ParticipacionController participacionController = new ParticipacionController();
        HistoriaController historiaController = new HistoriaController();
        PersonajeController personajeController = new PersonajeController();

        System.out.println("=== LOGIN ===");
        System.out.print("Email: ");
        String email = sc.nextLine();
        System.out.print("Password: ");
        String pass = sc.nextLine();

        Usuario usuario = new Usuario();
        usuario.setEmail(email);
        usuario.setPassword(pass);

        Usuario usuarioLogueado = login.validate(usuario);
        if (usuarioLogueado == null) {
            System.out.println("Credenciales incorrectas.");
            return;
        }
        System.out.println("¡Bienvenido " + usuarioLogueado.getNombre_usuario() + "!");

        System.out.println("\nHistorias disponibles:");
        LinkedList<Historia> historias = historiaController.getAllHistorias();
        for (Historia h : historias) {
            System.out.println(h.getId_historia() + ": " + h.getTitulo());
        }

        System.out.print("Seleccione el ID de la historia: ");
        int idHistoria = sc.nextInt();
        sc.nextLine(); // limpiar buffer
        if (participacionController.yaTieneParticipacion(usuarioLogueado.getId_usuario(), idHistoria)) {
            System.out.println("⚠️ Ya participaste en esta historia. No podés volver a jugarla.");
            return;
        }

        Personaje personajeAsignado = personajeController.asignarPersonajeAutomatico(idHistoria);
        if (personajeAsignado == null) {
            System.out.println("Lo siento, no hay personajes disponibles para asignar en esta historia.");
            return;
        }

        Participacion p = new Participacion();
        p.setId_usuario(usuarioLogueado.getId_usuario());
        p.setId_historia(idHistoria);
        p.setId_personaje(personajeAsignado.getId_personaje());

        participacionController.asignar(p);

        Historia h = historiaController.buscarPorId(idHistoria);
        System.out.println("🎭 ¡Personaje asignado automáticamente!");
        System.out.println("Sos: " + personajeAsignado.getNombre() + " en la historia: \"" + h.getTitulo() + "\"");
    }
}
