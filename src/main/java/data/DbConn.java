package data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConn {

    private static DbConn instancia;

    // Driver MySQL 8
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    // === LOCAL ===
    private static final String HOST = "127.0.0.1";
    private static final String PORT = "3306";
    private static final String DB   = "misterio_mansion";
    private static final String USER = "root";  
    private static final String PASS = "gusblajua";  

    // Parámetros recomendados para local (sin SSL)
    private static final String PARAMS =
            "serverTimezone=UTC" +
            "&useSSL=false" +
            "&allowPublicKeyRetrieval=true" +
            "&characterEncoding=UTF-8" +
            "&zeroDateTimeBehavior=CONVERT_TO_NULL";

    private DbConn() {
        try { Class.forName(DRIVER); }
        catch (ClassNotFoundException e) {
            throw new RuntimeException("No se encontró el driver MySQL: " + DRIVER, e);
        }
    }

    public static DbConn getInstancia() {
        if (instancia == null) instancia = new DbConn();
        return instancia;
    }

    /** Devuelve SIEMPRE una conexión nueva. El llamador debe cerrarla (try-with-resources). */
    public Connection getConn() throws SQLException {
        String url = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB + "?" + PARAMS;
        return DriverManager.getConnection(url, USER, PASS);
    }

    /** Ya no necesitamos un pool acá; cerramos en cada DAO con try-with-resources. */
    public void releaseConn() { /* no-op */ }
}
