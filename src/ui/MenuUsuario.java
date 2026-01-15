package ui;

import java.util.Scanner;
import java.util.LinkedList;

import entities.Usuario;
import logic.UsuarioController;

public class MenuUsuario {
    public static void mostrar() {
    	@SuppressWarnings("resource")
    	Scanner sc = new Scanner(System.in);
        UsuarioController controller = new UsuarioController();
        int opcion;

        do {
            System.out.println("\n----- MENÚ USUARIO -----");
            System.out.println("1. Listar usuarios");
            System.out.println("2. Agregar usuario");
            System.out.println("3. Modificar usuario");
            System.out.println("4. Eliminar usuario");
            System.out.println("5. Buscar usuario por ID");
            System.out.println("6. Buscar usuario por Email");
            System.out.println("0. Volver al menú principal");
            System.out.print("Ingrese una opción: ");
            opcion = sc.nextInt();
            sc.nextLine(); // limpiar buffer

            switch (opcion) {
                case 1: // Listar usuarios
                    LinkedList<Usuario> usuarios = controller.getAllUsuarios();
                    if (usuarios.isEmpty()) {
                        System.out.println("No hay usuarios registrados.");
                    } else {
                        for (Usuario u : usuarios) {
                            System.out.println("ID: " + u.getId_usuario() + ", Nombre: " + u.getNombre_usuario() + ", Email: " + u.getEmail());
                        }
                    }
                    break;

                case 2: // Agregar usuario
                    Usuario nuevo = new Usuario();
                    System.out.print("Nombre: ");
                    nuevo.setNombre_usuario(sc.nextLine());
                    System.out.print("Email: ");
                    nuevo.setEmail(sc.nextLine());
                    System.out.print("Contraseña: ");
                    nuevo.setPassword(sc.nextLine());
                    controller.agregarUsuario(nuevo);
                    System.out.println("Usuario agregado con ID: " + nuevo.getId_usuario());
                    break;

                case 3: // Modificar usuario
                    System.out.print("ID del usuario a modificar: ");
                    int idMod = sc.nextInt();
                    sc.nextLine();

                    // Buscar el usuario existente
                    Usuario modUsuario = null;
                    for (Usuario u : controller.getAllUsuarios()) {
                        if (u.getId_usuario() == idMod) {
                            modUsuario = u;
                            break;
                        }
                    }

                    if (modUsuario == null) {
                        System.out.println("Usuario no encontrado.");
                        break;
                    }

                    System.out.println("Modificar usuario (dejar vacío y presionar Enter para no modificar):");

                    System.out.print("Nombre actual: " + modUsuario.getNombre_usuario() + " -> Nuevo nombre: ");
                    String nuevoNombre = sc.nextLine();
                    if (!nuevoNombre.isBlank()) {
                        modUsuario.setNombre_usuario(nuevoNombre);
                    }

                    System.out.print("Email actual: " + modUsuario.getEmail() + " -> Nuevo email: ");
                    String nuevoEmail = sc.nextLine();
                    if (!nuevoEmail.isBlank()) {
                        modUsuario.setEmail(nuevoEmail);
                    }

                    System.out.print("Nueva contraseña (dejar vacío si no se desea cambiar): ");
                    String nuevaPassword = sc.nextLine();
                    if (!nuevaPassword.isBlank()) {
                        modUsuario.setPassword(nuevaPassword);
                    } else {
                        modUsuario.setPassword(""); // opcional: podés dejar la anterior si la estás ocultando
                    }

                    controller.actualizarUsuario(modUsuario);
                    System.out.println("Usuario actualizado.");
                    break;

                case 4: // Eliminar usuario
                    System.out.print("ID del usuario a eliminar: ");
                    int id = sc.nextInt();
                    sc.nextLine();
                    controller.eliminarUsuarioPorId(id);
                    System.out.println("Usuario eliminado.");
                    break;
                    
                case 5: // Buscar usuario por ID
                    System.out.print("Ingrese el ID del usuario: ");
                    int idBuscado = sc.nextInt();
                    sc.nextLine();
                    Usuario buscadoPorId = controller.buscarPorId(idBuscado);
                    if (buscadoPorId != null) {
                        System.out.println("Usuario encontrado: ID: " + buscadoPorId.getId_usuario() + ", Nombre: " + buscadoPorId.getNombre_usuario() + ", Email: " + buscadoPorId.getEmail());
                    } else {
                        System.out.println("No se encontró un usuario con ese ID.");
                    }
                    break;

                case 6: // Buscar usuario por Email
                    System.out.print("Ingrese el email del usuario a buscar: ");
                    String email = sc.nextLine();
                    Usuario buscadoPorEmail = controller.buscarUsuarioPorEmail(email);
                    if (buscadoPorEmail != null) {
                        System.out.println("Usuario encontrado: ID: " + buscadoPorEmail.getId_usuario() +
                                ", Nombre: " + buscadoPorEmail.getNombre_usuario() +
                                ", Email: " + buscadoPorEmail.getEmail());
                    } else {
                        System.out.println("No se encontró un usuario con ese email.");
                    }
                    break;

                case 0:
                    System.out.println("Volviendo al menú principal...");
                    break;

                default:
                    System.out.println("Opción no válida.");
            }

        } while (opcion != 0);
    }
}
