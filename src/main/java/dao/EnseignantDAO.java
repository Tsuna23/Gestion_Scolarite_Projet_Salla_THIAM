package dao;

import model.Enseignant;
import model.Matiere;
import JDBC.Jdbc;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnseignantDAO {
    private Connection connection;

    public EnseignantDAO() {
        try {
            this.connection = Jdbc.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
 
 // Récupérer tous les enseignants avec leurs matières JOINTURE HAHA
    public List<Enseignant> getAllEnseignants() {
        List<Enseignant> enseignants = new ArrayList<>();
        String sql = "SELECT e.id, e.nom, e.prenom, e.email, e.mot_de_passe, e.specialite, m.nom as matiere_nom " +
                     "FROM enseignants e " +
                     "LEFT JOIN enseignants_matieres em ON e.id = em.enseignant_id " +
                     "LEFT JOIN matieres m ON em.matiere_id = m.id " +
                     "ORDER BY e.nom, e.prenom";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Enseignant enseignant = new Enseignant(
                    rs.getInt("id"),
                    rs.getString("nom"),
                    rs.getString("prenom"),
                    rs.getString("email"),
                    rs.getString("mot_de_passe"),
                    rs.getString("specialite"),
                    rs.getString("matiere_nom")
                );
                enseignants.add(enseignant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return enseignants;
    }
    
    // Récupérer un enseignant par son ID
    public Enseignant getEnseignantById(int id) {
        String sql = "SELECT * FROM enseignants WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return new Enseignant(
                    rs.getInt("id"),
                    rs.getString("nom"),
                    rs.getString("prenom"),
                    rs.getString("email"),
                    rs.getString("mot_de_passe"),
                    rs.getString("specialite")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Ajouter un enseignant et retourner son ID généré
    public int ajouterEnseignant(Enseignant enseignant) {
        String sql = "INSERT INTO enseignants (nom, prenom, email, mot_de_passe, specialite) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, enseignant.getNom());
            stmt.setString(2, enseignant.getPrenom());
            stmt.setString(3, enseignant.getEmail());
            stmt.setString(4, enseignant.getMotDePasse());
            stmt.setString(5, enseignant.getSpecialite());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Échec
    }
    
    // Mettre à jour un enseignant
    public boolean updateEnseignant(Enseignant enseignant) {
        String sql = "UPDATE enseignants SET nom = ?, prenom = ?, email = ?, mot_de_passe = ?, specialite = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, enseignant.getNom());
            stmt.setString(2, enseignant.getPrenom());
            stmt.setString(3, enseignant.getEmail());
            stmt.setString(4, enseignant.getMotDePasse());
            stmt.setString(5, enseignant.getSpecialite());
            stmt.setInt(6, enseignant.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Supprimer un enseignant
    public boolean supprimerEnseignant(int id) {
        // D'abord supprimer les associations avec les matières
        String sqlAssociations = "DELETE FROM enseignants_matieres WHERE enseignant_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sqlAssociations)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        // Ensuite supprimer l'enseignant
        String sql = "DELETE FROM enseignants WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Associer un enseignant à une matière
    public boolean associerMatiere(int enseignantId, int matiereId) {
        String sql = "INSERT INTO enseignants_matieres (enseignant_id, matiere_id) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, enseignantId);
            stmt.setInt(2, matiereId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
 // Dans EnseignantDAO
    public boolean supprimerAssociationsMatiere(int enseignantId) {
        String sql = "DELETE FROM enseignants_matieres WHERE enseignant_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, enseignantId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
 // Ajouter cette méthode à votre classe EnseignantDAO
    public int getMatiereIdByEnseignantId(int enseignantId) {
        String sql = "SELECT matiere_id FROM enseignants_matieres WHERE enseignant_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, enseignantId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("matiere_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Retourne -1 si aucune matière n'est associée
    }
 // Méthode pour récupérer un enseignant par son email
    public Enseignant getEnseignantByEmail(String email, String motDePasse) {
        String sql = "SELECT * FROM enseignants WHERE email = ? AND mot_de_passe = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, motDePasse);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return new Enseignant(
                    rs.getInt("id"),
                    rs.getString("nom"),
                    rs.getString("prenom"),
                    rs.getString("email"),
                    rs.getString("mot_de_passe"),
                    rs.getString("specialite")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Méthode pour vérifier la connexion
    public boolean verifierConnexion(String email, String motDePasse) {
        String sql = "SELECT COUNT(*) FROM enseignants WHERE email = ? AND mot_de_passe = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, motDePasse);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
 // Méthode pour récupérer les cours (matières) enseignés par un enseignant
    public List<Matiere> getCoursEnseignant(int enseignantId) {
        List<Matiere> cours = new ArrayList<>();
        String sql = "SELECT m.* FROM matieres m " +
                     "INNER JOIN enseignants_matieres em ON m.id = em.matiere_id " +
                     "WHERE em.enseignant_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, enseignantId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Matiere matiere = new Matiere();
                matiere.setId(rs.getInt("id"));
                matiere.setNom(rs.getString("nom"));
                
                // Récupérer le coefficient qui existe dans votre table
                matiere.setCoefficient(rs.getDouble("coefficient"));
                
                // Récupérer la description qui existe dans votre table
                matiere.setDescription(rs.getString("description"));
                
                cours.add(matiere);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return cours;
    }
}