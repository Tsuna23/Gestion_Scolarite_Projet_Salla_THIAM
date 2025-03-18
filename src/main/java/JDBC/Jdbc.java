package JDBC;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Jdbc{

	private static final String URL = "jdbc:mysql://localhost:3306/scolarite";
    private static final String USER = "root"; 
    private static final String PASSWORD = ""; 

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
    	Class.forName("com.mysql.cj.jdbc.Driver");// Charge le driver
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            System.out.println("✅ Connexion réussie !");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
