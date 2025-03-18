package dao;

import model.Absence;
import JDBC.Jdbc;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class AbsenceDAO {
    
    // Récupérer toutes les absences
    public List<Absence> getAllAbsences() {
        List<Absence> absences = new ArrayList<>();
        String sql = "SELECT * FROM absences ORDER BY date_absence DESC";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Absence absence = new Absence();
                absence.setId(rs.getInt("id"));
                absence.setEtudiantId(rs.getInt("etudiant_id"));
                absence.setMatiereId(rs.getInt("matiere_id"));
                absence.setDate(new Date(rs.getDate("date_absence").getTime()));
                absence.setJustifiee(rs.getBoolean("justifiee"));
                absence.setMotif(rs.getString("motif"));
                absence.setCommentaire(rs.getString("commentaire"));
                
                if (rs.getTimestamp("date_enregistrement") != null) {
                    absence.setDateEnregistrement(new Date(rs.getTimestamp("date_enregistrement").getTime()));
                }
                
                absences.add(absence);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return absences;
    }
    
    // Récupérer une absence par son ID
    public Absence getAbsenceById(int id) {
        String sql = "SELECT * FROM absences WHERE id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Absence absence = new Absence();
                    absence.setId(rs.getInt("id"));
                    absence.setEtudiantId(rs.getInt("etudiant_id"));
                    absence.setMatiereId(rs.getInt("matiere_id"));
                    absence.setDate(new Date(rs.getDate("date_absence").getTime()));
                    absence.setJustifiee(rs.getBoolean("justifiee"));
                    absence.setMotif(rs.getString("motif"));
                    absence.setCommentaire(rs.getString("commentaire"));
                    
                    if (rs.getTimestamp("date_enregistrement") != null) {
                        absence.setDateEnregistrement(new Date(rs.getTimestamp("date_enregistrement").getTime()));
                    }
                    
                    return absence;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Ajouter une absence
    public boolean ajouterAbsence(Absence absence) {
        String sql = "INSERT INTO absences (etudiant_id, matiere_id, date_absence, justifiee, motif, commentaire) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, absence.getEtudiantId());
            stmt.setInt(2, absence.getMatiereId());
            stmt.setDate(3, new java.sql.Date(absence.getDate().getTime()));
            stmt.setBoolean(4, absence.isJustifiee());
            stmt.setString(5, absence.getMotif());
            stmt.setString(6, absence.getCommentaire());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        absence.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Mettre à jour une absence
    public boolean modifierAbsence(Absence absence) {
        String sql = "UPDATE absences SET etudiant_id = ?, matiere_id = ?, date_absence = ?, justifiee = ?, motif = ?, commentaire = ? WHERE id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, absence.getEtudiantId());
            stmt.setInt(2, absence.getMatiereId());
            stmt.setDate(3, new java.sql.Date(absence.getDate().getTime()));
            stmt.setBoolean(4, absence.isJustifiee());
            stmt.setString(5, absence.getMotif());
            stmt.setString(6, absence.getCommentaire());
            stmt.setInt(7, absence.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Supprimer une absence
    public boolean supprimerAbsence(int id) {
        String sql = "DELETE FROM absences WHERE id = ?";
        
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
    
    // Récupérer les absences d'un étudiant spécifique
    public List<Absence> getAbsencesByEtudiantId(int etudiantId) {
        List<Absence> absences = new ArrayList<>();
        String sql = "SELECT * FROM absences WHERE etudiant_id = ? ORDER BY date_absence DESC";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, etudiantId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Absence absence = new Absence();
                    absence.setId(rs.getInt("id"));
                    absence.setEtudiantId(rs.getInt("etudiant_id"));
                    absence.setMatiereId(rs.getInt("matiere_id"));
                    absence.setDate(new Date(rs.getDate("date_absence").getTime()));
                    absence.setJustifiee(rs.getBoolean("justifiee"));
                    absence.setMotif(rs.getString("motif"));
                    absence.setCommentaire(rs.getString("commentaire"));
                    
                    if (rs.getTimestamp("date_enregistrement") != null) {
                        absence.setDateEnregistrement(new Date(rs.getTimestamp("date_enregistrement").getTime()));
                    }
                    
                    absences.add(absence);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return absences;
    }
    
    // Récupérer les absences d'une matière spécifique
    public List<Absence> getAbsencesByMatiereId(int matiereId) {
        List<Absence> absences = new ArrayList<>();
        String sql = "SELECT * FROM absences WHERE matiere_id = ? ORDER BY date_absence DESC";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, matiereId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Absence absence = new Absence();
                    absence.setId(rs.getInt("id"));
                    absence.setEtudiantId(rs.getInt("etudiant_id"));
                    absence.setMatiereId(rs.getInt("matiere_id"));
                    absence.setDate(new Date(rs.getDate("date_absence").getTime()));
                    absence.setJustifiee(rs.getBoolean("justifiee"));
                    absence.setMotif(rs.getString("motif"));
                    absence.setCommentaire(rs.getString("commentaire"));
                    
                    if (rs.getTimestamp("date_enregistrement") != null) {
                        absence.setDateEnregistrement(new Date(rs.getTimestamp("date_enregistrement").getTime()));
                    }
                    
                    absences.add(absence);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return absences;
    }
    
    // Compte le nombre d'absences non justifiées d'un étudiant
    public int getNombreAbsencesNonJustifiees(int etudiantId) {
        String sql = "SELECT COUNT(*) FROM absences WHERE etudiant_id = ? AND justifiee = FALSE";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, etudiantId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Compte le nombre total d'absences d'un étudiant
    public int getNombreTotalAbsences(int etudiantId) {
        String sql = "SELECT COUNT(*) FROM absences WHERE etudiant_id = ?";
        
        try (Connection connection = Jdbc.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, etudiantId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}