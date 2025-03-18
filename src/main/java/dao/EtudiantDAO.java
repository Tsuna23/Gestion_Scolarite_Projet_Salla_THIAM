package dao;

import model.Etudiant;
import JDBC.Jdbc;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EtudiantDAO {

    // ✅ Ajouter un étudiant (sans email institutionnel)
    public boolean ajouterEtudiant(Etudiant etudiant) {
        String sql = "INSERT INTO etudiants (nom, prenom, email_personnel, mot_de_passe, filiere, niveau) VALUES (?, ?, ?, ?, ?, ?)";

        // Vérification des champs obligatoires
        if (etudiant.getNom() == null || etudiant.getPrenom() == null || etudiant.getEmailPersonnel() == null) {
            System.out.println("⚠️ Erreur : Les champs obligatoires ne peuvent pas être nuls");
            return false;
        }

        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, etudiant.getNom());
            stmt.setString(2, etudiant.getPrenom());
            stmt.setString(3, etudiant.getEmailPersonnel());
            stmt.setString(4, etudiant.getMotDePasse()); // Pas de hashage ici
            stmt.setString(5, etudiant.getFiliere());
            stmt.setString(6, etudiant.getNiveau());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("❌ Erreur SQL lors de l'ajout d'un étudiant : " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("❌ Erreur lors de l'ajout d'un étudiant : " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Ajouter l'email institutionnel après inscription
    public boolean ajouterEmailInstitutionnel(String emailPersonnel, String emailEcole) {
        String sql = "UPDATE etudiants SET email_ecole = ? WHERE email_personnel = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, emailEcole);
            stmt.setString(2, emailPersonnel);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Vérifier les identifiants de connexion (sans hashage)
    public boolean verifierConnexion(String emailEcole, String motDePasse) {
        String sql = "SELECT * FROM etudiants WHERE email_ecole = ? AND mot_de_passe = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, emailEcole);
            stmt.setString(2, motDePasse);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Récupérer un étudiant par email institutionnel
    public Etudiant getEtudiantByEmail(String emailEcole) {
        String sql = "SELECT id, nom, prenom, email_personnel, email_ecole, mot_de_passe, filiere, niveau FROM etudiants WHERE email_ecole = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, emailEcole);
            System.out.println("🔍 Exécution de la requête SQL : " + stmt);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("✅ Étudiant trouvé en base : " + emailEcole);
                    System.out.println("📩 Email institutionnel récupéré : " + rs.getString("email_ecole"));
                    System.out.println("🎓 Filière récupérée : " + rs.getString("filiere"));
                    System.out.println("📘 Niveau récupéré : " + rs.getString("niveau"));

                    return new Etudiant(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getString("prenom"),
                        rs.getString("email_personnel"),
                        rs.getString("email_ecole"),
                        rs.getString("mot_de_passe"),
                        rs.getString("filiere") != null ? rs.getString("filiere") : "Non renseigné",
                        rs.getString("niveau") != null ? rs.getString("niveau") : "Non renseigné"
                    );
                } else {
                    System.out.println("⚠️ Aucun étudiant trouvé avec cet email !");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Etudiant> getAllEtudiants() {
        List<Etudiant> etudiants = new ArrayList<>();
        String sql = "SELECT * FROM etudiants ORDER BY nom, prenom";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Etudiant etudiant = new Etudiant(
                    rs.getInt("id"),
                    rs.getString("nom"),
                    rs.getString("prenom"),
                    rs.getString("email_personnel"),
                    rs.getString("email_ecole"),
                    rs.getString("mot_de_passe"),
                    rs.getString("filiere"),
                    rs.getString("niveau")
                );
                etudiants.add(etudiant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return etudiants;
    }
    
    public boolean supprimerEtudiant(int id) {
        String sql = "DELETE FROM etudiants WHERE id = ?";
        
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
    
    public Etudiant getEtudiantById(int id) {
        String sql = "SELECT * FROM etudiants WHERE id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Etudiant(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getString("prenom"),
                        rs.getString("email_personnel"),
                        rs.getString("email_ecole"),
                        rs.getString("mot_de_passe"),
                        rs.getString("filiere"),
                        rs.getString("niveau")
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
    
    public boolean updateEtudiant(Etudiant etudiant) {
        String sql = "UPDATE etudiants SET nom = ?, prenom = ?, email_personnel = ?, " +
                    "email_ecole = ?, mot_de_passe = ?, filiere = ?, niveau = ? WHERE id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, etudiant.getNom());
            stmt.setString(2, etudiant.getPrenom());
            stmt.setString(3, etudiant.getEmailPersonnel());
            stmt.setString(4, etudiant.getEmailEcole());
            stmt.setString(5, etudiant.getMotDePasse());
            stmt.setString(6, etudiant.getFiliere());
            stmt.setString(7, etudiant.getNiveau());
            stmt.setInt(8, etudiant.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Etudiant> getEtudiantsByMatiereId(int matiereId) {
        List<Etudiant> etudiants = new ArrayList<>();
        String sql = "SELECT e.* FROM etudiants e " +
                     "JOIN inscriptions i ON e.id = i.etudiant_id " +
                     "WHERE i.matiere_id = ? " +
                     "ORDER BY e.nom, e.prenom";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, matiereId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Etudiant etudiant = new Etudiant(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getString("prenom"),
                        rs.getString("email_personnel"),
                        rs.getString("email_ecole"),
                        rs.getString("mot_de_passe"),
                        rs.getString("filiere"),
                        rs.getString("niveau")
                    );
                    etudiants.add(etudiant);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return etudiants;
    }
}