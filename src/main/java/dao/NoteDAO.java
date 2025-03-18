package dao;

import model.Note;
import JDBC.Jdbc;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoteDAO {
    private Connection connection;

    public NoteDAO() {
        try {
            this.connection = Jdbc.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Récupérer les notes d'un étudiant pour une matière
    public List<Note> getNotesByEtudiantAndMatiere(int etudiantId, int matiereId) {
        List<Note> notes = new ArrayList<>();
        String sql = "SELECT * FROM notes WHERE etudiant_id = ? AND matiere_id = ? ORDER BY date_evaluation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, etudiantId);
            stmt.setInt(2, matiereId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Note note = new Note(
                    rs.getInt("id"),
                    rs.getInt("etudiant_id"),
                    rs.getInt("matiere_id"),
                    rs.getDouble("valeur"),
                    rs.getString("type_evaluation"),
                    rs.getInt("semestre"),
                    rs.getDate("date_evaluation"),
                    rs.getString("commentaire")
                );
                notes.add(note);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notes;
    }

    // Récupérer toutes les notes d'un étudiant
    public List<Note> getAllNotesByEtudiant(int etudiantId) {
        List<Note> notes = new ArrayList<>();
        String sql = "SELECT * FROM notes WHERE etudiant_id = ? ORDER BY matiere_id, date_evaluation DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, etudiantId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Note note = new Note(
                    rs.getInt("id"),
                    rs.getInt("etudiant_id"),
                    rs.getInt("matiere_id"),
                    rs.getDouble("valeur"),
                    rs.getString("type_evaluation"),
                    rs.getInt("semestre"),
                    rs.getDate("date_evaluation"),
                    rs.getString("commentaire")
                );
                notes.add(note);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notes;
    }

    // Ajouter une note
    public boolean ajouterNote(Note note) {
        String sql = "INSERT INTO notes (etudiant_id, matiere_id, valeur, type_evaluation, semestre, date_evaluation, commentaire) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, note.getEtudiantId());
            stmt.setInt(2, note.getMatiereId());
            stmt.setDouble(3, note.getValeur());
            stmt.setString(4, note.getTypeEvaluation());
            stmt.setInt(5, note.getSemestre());
            stmt.setDate(6, new java.sql.Date(note.getDateEvaluation().getTime()));
            stmt.setString(7, note.getCommentaire());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Mettre à jour une note
    public boolean updateNote(Note note) {
        String sql = "UPDATE notes SET valeur = ?, type_evaluation = ?, semestre = ?, date_evaluation = ?, commentaire = ? " +
                    "WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDouble(1, note.getValeur());
            stmt.setString(2, note.getTypeEvaluation());
            stmt.setInt(3, note.getSemestre());
            stmt.setDate(4, new java.sql.Date(note.getDateEvaluation().getTime()));
            stmt.setString(5, note.getCommentaire());
            stmt.setInt(6, note.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Supprimer une note
    public boolean supprimerNote(int id) {
        String sql = "DELETE FROM notes WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}