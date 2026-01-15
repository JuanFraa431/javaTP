package logic;

import data.UsuarioDAO;
import entities.Usuario;

import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

public class CtrlUsuario {

    private final UsuarioDAO dao;

    public CtrlUsuario() {
        this.dao = new UsuarioDAO();
    }

    public Usuario getUserById(int id) throws SQLException {
        return dao.findById(id);
    }

    public Usuario getUserByEmail(String email) throws SQLException {
        return dao.findByEmail(email);
    }

    public Usuario validate(String email, String passwordPlain) throws SQLException {
        boolean ok = dao.validarLogin(email, passwordPlain);
        if (!ok) return null;
        return dao.findByEmail(email);
    }

    public Usuario validate(Usuario u, String passwordPlain) throws SQLException {
        if (u == null || u.getEmail() == null) return null;
        return validate(u.getEmail(), passwordPlain);
    }

    /** Lista de usuarios activos (por compatibilidad: LinkedList). */
    public LinkedList<Usuario> getAll() throws SQLException {
        return getAll(true);
    }

    /** Lista usuarios; si soloActivos=true filtra activo=1. */
    public LinkedList<Usuario> getAll(boolean soloActivos) throws SQLException {
        List<Usuario> list = dao.getAll(soloActivos);
        return new LinkedList<>(list);
    }

    /* ==========================
       Altas / modificaciones
       ========================== */

    public int addUsuario(String nombre, String email, String rol, String passwordPlain) throws SQLException {
        return dao.create(nombre, email, rol, passwordPlain);
    }

    public boolean modificarUsuario(int id, String nombre, String email, String rol, boolean activo) throws SQLException {
        return dao.updatePerfil(id, nombre, email, rol, activo);
    }

    public boolean cambiarPassword(int id, String nuevaPassword) throws SQLException {
        return dao.updatePassword(id, nuevaPassword);
    }

    /** Baja lógica (activo=0). */
    public boolean eliminarUsuario(int id) throws SQLException {
        return dao.softDelete(id);
    }

    /** Reactiva un usuario desactivado (activo=1). */
    public boolean reactivarUsuario(int id) throws SQLException {
        return dao.reactivar(id);
    }
}
