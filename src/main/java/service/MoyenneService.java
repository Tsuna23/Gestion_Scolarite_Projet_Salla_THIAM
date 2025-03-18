package service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import model.Note;
import model.Matiere;
import dao.NoteDAO;
import dao.MatiereDAO;

/**
 * Service pour calculer les moyennes des étudiants
 */
public class MoyenneService {

    private static MoyenneService instance;
    
    private MoyenneService() {
        // Constructeur privé pour Singleton
    }
    
    public static MoyenneService getInstance() {
        if (instance == null) {
            instance = new MoyenneService();
        }
        return instance;
    }
    
    /**
     * Calcule la moyenne générale d'un étudiant pour un semestre donné
     */
    public double calculerMoyenneGenerale(int etudiantId, int semestre) {
        NoteDAO noteDAO = new NoteDAO();
        MatiereDAO matiereDAO = new MatiereDAO();
        
        // Récupérer toutes les notes de l'étudiant
        List<Note> notes = noteDAO.getAllNotesByEtudiant(etudiantId);
        
        // Filtrer les notes pour le semestre spécifié
        List<Note> semestreNotes = new java.util.ArrayList<>();
        for (Note note : notes) {
            if (note.getSemestre() == semestre) {
                semestreNotes.add(note);
            }
        }
        
        // Si pas de notes, renvoyer 0
        if (semestreNotes.isEmpty()) {
            return 0.0;
        }
        
        // Regrouper les notes par matière
        Map<Integer, List<Note>> notesByMatiere = new HashMap<>();
        for (Note note : semestreNotes) {
            int matiereId = note.getMatiereId();
            if (!notesByMatiere.containsKey(matiereId)) {
                notesByMatiere.put(matiereId, new java.util.ArrayList<>());
            }
            notesByMatiere.get(matiereId).add(note);
        }
        
        // Calcul de la moyenne pondérée
        double sommeNotes = 0;
        double sommeCoeffs = 0;
        
        for (Map.Entry<Integer, List<Note>> entry : notesByMatiere.entrySet()) {
            int matiereId = entry.getKey();
            List<Note> matiereNotes = entry.getValue();
            
            // Récupération de la matière
            Matiere matiere = matiereDAO.getMatiereById(matiereId);
            if (matiere == null) continue;
            
            // Calcul de la moyenne de la matière
            double sommeMatiereNotes = 0;
            for (Note note : matiereNotes) {
                sommeMatiereNotes += note.getValeur();
            }
            double moyenneMatiere = matiereNotes.isEmpty() ? 0 : sommeMatiereNotes / matiereNotes.size();
            
            // Ajout à la moyenne générale pondérée
            sommeNotes += moyenneMatiere * matiere.getCoefficient();
            sommeCoeffs += matiere.getCoefficient();
        }
        
        // Calcul de la moyenne générale
        double moyenneGenerale = sommeCoeffs > 0 ? sommeNotes / sommeCoeffs : 0;
        
        // Arrondir à 2 décimales
        return Math.round(moyenneGenerale * 100.0) / 100.0;
    }
}