package dao;

import model.Matiere;
import JDBC.Jdbc;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InscriptionDAO {
    private Connection connection;

    public InscriptionDAO() {
        try {
            this.connection = Jdbc.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Inscrire un étudiant à une matière
    public boolean inscrireEtudiant(int etudiantId, int matiereId) {
        String sql = "INSERT INTO inscriptions (etudiant_id, matiere_id) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, etudiantId);
            stmt.setInt(2, matiereId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Désinscrire un étudiant d'une matière
    public boolean desinscrireEtudiant(int etudiantId, int matiereId) {
        String sql = "DELETE FROM inscriptions WHERE etudiant_id = ? AND matiere_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, etudiantId);
            stmt.setInt(2, matiereId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Récupérer les matières auxquelles un étudiant est inscrit
    public List<Matiere> getMatieresInscrites(int etudiantId) {
        List<Matiere> matieres = new ArrayList<>();
        String sql = "SELECT m.* FROM matieres m " +
                     "JOIN inscriptions i ON m.id = i.matiere_id " +
                     "WHERE i.etudiant_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, etudiantId);
            ResultSet rs = stmt.executeQuery();
            
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
        }
        
        return matieres;
    }

    // Récupérer les étudiants inscrits à une matière
    public List<Integer> getEtudiantsInscrits(int matiereId) {
        List<Integer> etudiantIds = new ArrayList<>();
        String sql = "SELECT etudiant_id FROM inscriptions WHERE matiere_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, matiereId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                etudiantIds.add(rs.getInt("etudiant_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return etudiantIds;
    }

    // Vérifier si un étudiant est inscrit à une matière
    public boolean estInscrit(int etudiantId, int matiereId) {
        String sql = "SELECT COUNT(*) FROM inscriptions WHERE etudiant_id = ? AND matiere_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, etudiantId);
            stmt.setInt(2, matiereId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Compter le nombre d'inscriptions à une matière
    public int compterInscriptions(int matiereId) {
        String sql = "SELECT COUNT(*) FROM inscriptions WHERE matiere_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, matiereId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Supprimer toutes les inscriptions d'un étudiant
    public boolean supprimerInscriptionsEtudiant(int etudiantId) {
        String sql = "DELETE FROM inscriptions WHERE etudiant_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, etudiantId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Supprimer toutes les inscriptions à une matière
    public boolean supprimerInscriptionsMatiere(int matiereId) {
        String sql = "DELETE FROM inscriptions WHERE matiere_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, matiereId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}