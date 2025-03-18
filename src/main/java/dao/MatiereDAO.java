package dao;

import model.Matiere;
import JDBC.Jdbc;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MatiereDAO {
    
    // Récupérer toutes les matières
    public List<Matiere> getAllMatieres() {
        List<Matiere> matieres = new ArrayList<>();
        String sql = "SELECT * FROM matieres ORDER BY nom";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Matiere matiere = new Matiere(
                    rs.getInt("id"),
                    rs.getString("nom"),
                    rs.getDouble("coefficient"),
                    rs.getString("description")
                );
                matieres.add(matiere);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return matieres;
    }
    
    // Récupérer une matière par son ID
    public Matiere getMatiereById(int id) {
        String sql = "SELECT * FROM matieres WHERE id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Matiere(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getDouble("coefficient"),
                        rs.getString("description")
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
    
    // Ajouter une matière
    public boolean ajouterMatiere(Matiere matiere) {
        String sql = "INSERT INTO matieres (nom, coefficient, description) VALUES (?, ?, ?)";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, matiere.getNom());
            stmt.setDouble(2, matiere.getCoefficient());
            stmt.setString(3, matiere.getDescription());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Mettre à jour une matière
    public boolean updateMatiere(Matiere matiere) {
        String sql = "UPDATE matieres SET nom = ?, coefficient = ?, description = ? WHERE id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, matiere.getNom());
            stmt.setDouble(2, matiere.getCoefficient());
            stmt.setString(3, matiere.getDescription());
            stmt.setInt(4, matiere.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Supprimer une matière
    public boolean supprimerMatiere(int id) {
        String sql = "DELETE FROM matieres WHERE id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Récupérer la matière associée à un enseignant
    public int getMatiereIdByEnseignantId(int enseignantId) {
        String sql = "SELECT matiere_id FROM enseignants_matieres WHERE enseignant_id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, enseignantId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("matiere_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return -1; // Pas de matière associée
    }
}