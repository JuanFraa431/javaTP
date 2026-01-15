package ui;

import java.util.Scanner;
import java.util.LinkedList;

import entities.Pista;
import logic.PistaController;

public class MenuPista {
    public static void mostrar() {
        @SuppressWarnings("resource")
        Scanner sc = new Scanner(System.in);
        PistaController controller = new PistaController();
        int opcion;

        do {
            System.out.println("\n----- MENÚ PISTA -----");
            System.out.println("1. Listar pistas");
            System.out.println("2. Agregar pista");
            System.out.println("3. Modificar pista");
            System.out.println("4. Eliminar pista");
            System.out.println("5. Buscar pista por ID");
            System.out.println("6. Buscar pistas por contenido");
            System.out.println("0. Volver al menú principal");
            System.out.print("Ingrese una opción: ");
            opcion = sc.nextInt();
            sc.nextLine(); // limpiar buffer

            switch (opcion) {
                case 1: // Listar pistas
                    LinkedList<Pista> pistas = controller.getAllPistas();
                    if (pistas.isEmpty()) {
                        System.out.println("No hay pistas registradas.");
                    } else {
                        for (Pista p : pistas) {
                            System.out.println("ID: " + p.getId_pista()
                                + ", Contenido: " + p.getContenido()
                                + ", Personaje: " + p.getNombre_personaje()
                                + ", Ubicación: " + p.getNombre_ubicacion());
                        }
                    }
                    break;

                case 2: // Agregar pista
                    Pista nueva = new Pista();
                    System.out.print("Contenido: ");
                    nueva.setContenido(sc.nextLine());
                    System.out.print("ID del personaje: ");
                    nueva.setId_personaje(sc.nextInt());
                    sc.nextLine();
                    System.out.print("ID de la ubicación: ");
                    nueva.setId_ubicacion(sc.nextInt());
                    sc.nextLine();

                    controller.agregarPista(nueva);
                    System.out.println("Pista agregada con ID: " + nueva.getId_pista());
                    break;

                case 3: // Modificar pista
                    System.out.print("ID de la pista a modificar: ");
                    int idMod = sc.nextInt();
                    sc.nextLine();

                    Pista mod = controller.buscarPistaPorId(idMod);
                    if (mod == null) {
                        System.out.println("Pista no encontrada.");
                        break;
                    }

                    System.out.println("Modificar pista (dejar vacío para no modificar):");

                    System.out.print("Contenido actual: " + mod.getContenido() + " -> Nuevo contenido: ");
                    String nuevoContenido = sc.nextLine();
                    if (!nuevoContenido.isBlank()) {
                        mod.setContenido(nuevoContenido);
                    }

                    System.out.print("ID actual del personaje (" + mod.getId_personaje() + "): ");
                    String idPers = sc.nextLine();
                    if (!idPers.isBlank()) {
                        mod.setId_personaje(Integer.parseInt(idPers));
                    }

                    System.out.print("ID actual de la ubicación (" + mod.getId_ubicacion() + "): ");
                    String idUbi = sc.nextLine();
                    if (!idUbi.isBlank()) {
                        mod.setId_ubicacion(Integer.parseInt(idUbi));
                    }

                    controller.actualizarPista(mod);
                    System.out.println("Pista actualizada.");
                    break;

                case 4: // Eliminar pista
                    System.out.print("ID de la pista a eliminar: ");
                    int id = sc.nextInt();
                    sc.nextLine();
                    controller.eliminarPistaPorId(id);
                    System.out.println("Pista eliminada.");
                    break;

                case 5: // Buscar pista por ID
                    System.out.print("Ingrese el ID de la pista: ");
                    int idBuscado = sc.nextInt();
                    sc.nextLine();
                    Pista buscada = controller.buscarPistaPorId(idBuscado);
                    if (buscada != null) {
                        System.out.println("Pista encontrada: ID: " + buscada.getId_pista()
                            + ", Contenido: " + buscada.getContenido()
                            + ", Personaje: " + buscada.getNombre_personaje()
                            + ", Ubicación: " + buscada.getNombre_ubicacion());
                    } else {
                        System.out.println("No se encontró una pista con ese ID.");
                    }
                    break;

                case 6: // Buscar pistas por contenido
                    System.out.print("Ingrese parte del contenido a buscar: ");
                    String contenido = sc.nextLine();
                    LinkedList<Pista> coincidencias = controller.buscarPistasPorContenido(contenido);
                    if (coincidencias.isEmpty()) {
                        System.out.println("No se encontraron pistas que coincidan.");
                    } else {
                        for (Pista p : coincidencias) {
                            System.out.println("ID: " + p.getId_pista()
                                + ", Contenido: " + p.getContenido()
                                + ", Personaje: " + p.getNombre_personaje()
                                + ", Ubicación: " + p.getNombre_ubicacion());
                        }
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
