package ui;

import java.util.Scanner;
import java.util.LinkedList;

import entities.Historia;
import logic.HistoriaController;

public class MenuHistoria {
    public static void mostrar() {
        @SuppressWarnings("resource")
        Scanner sc = new Scanner(System.in);
        HistoriaController controller = new HistoriaController();
        int opcion;

        do {
            System.out.println("\n----- MENÚ HISTORIA -----");
            System.out.println("1. Listar historias");
            System.out.println("2. Agregar historia");
            System.out.println("3. Modificar historia");
            System.out.println("4. Eliminar historia");
            System.out.println("5. Buscar historia por ID");
            System.out.println("6. Buscar historia por Titulo");
            System.out.println("0. Volver al menú principal");
            System.out.print("Ingrese una opción: ");
            opcion = sc.nextInt();
            sc.nextLine(); // limpiar buffer

            switch (opcion) {
                case 1: // Listar
                    LinkedList<Historia> historias = controller.getAllHistorias();
                    if (historias.isEmpty()) {
                        System.out.println("No hay historias registradas.");
                    } else {
                        for (Historia h : historias) {
                            System.out.println("ID: " + h.getId_historia() + ", Título: " + h.getTitulo() + ", Descripción: " + h.getDescripcion());
                        }
                    }
                    break;

                case 2: // Agregar
                    Historia nueva = new Historia();
                    System.out.print("Título: ");
                    nueva.setTitulo(sc.nextLine());
                    System.out.print("Descripción: ");
                    nueva.setDescripcion(sc.nextLine());
                    controller.agregarHistoria(nueva);
                    System.out.println("Historia agregada con ID: " + nueva.getId_historia());
                    break;
            
                case 3: // Modificar 
                    System.out.print("ID de la historia a modificar: ");
                    int idMod = sc.nextInt();
                    sc.nextLine();


                    Historia mod = new Historia();
                    for (Historia h : controller.getAllHistorias()) {
                        if (h.getId_historia() == idMod) {
                            mod = h;
                            break;
                        }
                    }

                   /* if (mod == null) {
                        System.out.println("Historia no encontrada.");
                        break;
                    }*/

                    System.out.println("Modificar historia (dejar vacío y presionar Enter para no modificar):");

                    System.out.print("Titulo Actual: " + mod.getTitulo() + " -> Nuevo titulo: ");
                    String nuevoTitulo = sc.nextLine();
                    if (!nuevoTitulo.isBlank()) {
                        mod.setTitulo(nuevoTitulo);
                    }

                    System.out.print("Descripcion actual: " + mod.getDescripcion() + " -> Nueva descripcion: ");
                    String nuevaDesc = sc.nextLine();
                    if (!nuevaDesc.isBlank()) {
                        mod.setDescripcion(nuevaDesc);
                    }


                    controller.actualizarHistoria(mod);
                    System.out.println("Historia actualizada.");
                    break;


                case 4: // Eliminar
                    System.out.print("ID de la historia a eliminar: ");
                    int id = sc.nextInt();
                    sc.nextLine();
                    controller.eliminarHistoriaPorId(id);
                    System.out.println("Historia eliminada.");
                    break;
                    
                case 5: // Buscar historia por id
                    System.out.print("Ingrese el ID de la historia: ");
                    int idBuscado = sc.nextInt();
                    sc.nextLine();
                    Historia buscadoPorId = controller.buscarPorId(idBuscado);
                    if (buscadoPorId != null) {
                        System.out.println("Historia encontrada: ID: " + buscadoPorId.getId_historia() + ", Titulo: " + buscadoPorId.getTitulo() + ", Descripcion: " + buscadoPorId.getDescripcion());
                    } else {
                        System.out.println("No se encontro ninguna historia con ese ID.");
                    }
                    break;
                    
                case 6: // Buscar historias por título parcial
                    System.out.print("Ingrese parte del título de la historia a buscar: ");
                    String tituloParcial = sc.nextLine();
                    LinkedList<Historia> historiasCoincidentes = controller.buscarHistoriasPorTitulo(tituloParcial);

                    if (historiasCoincidentes.isEmpty()) {
                        System.out.println("No se encontraron historias con ese título.");
                    } else {
                        System.out.println("Historias encontradas:");
                        for (Historia h : historiasCoincidentes) {
                            System.out.println("ID: " + h.getId_historia() +
                                               ", Título: " + h.getTitulo() +
                                               ", Descripción: " + h.getDescripcion());
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
