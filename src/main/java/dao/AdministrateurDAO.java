package dao;

import model.Administrateur;
import JDBC.Jdbc;
import java.sql.*;

public class AdministrateurDAO {
    
    // Méthode pour récupérer un administrateur par son email et mot de passe
    public Administrateur getAdministrateurByEmail(String email, String motDePasse) {
        String sql = "SELECT * FROM administrateurs WHERE email = ? AND mot_de_passe = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, motDePasse);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Administrateur(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getString("prenom"),
                        rs.getString("email"),
                        rs.getString("mot_de_passe")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Ajoutez ici d'autres méthodes selon vos besoins
}