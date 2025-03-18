package model;

import java.io.Serializable;
import java.util.Date;

public class Note implements Serializable {
    private int id;
    private int etudiantId;
    private int matiereId;
    private double valeur;
    private String typeEvaluation;
    private int semestre;
    private Date dateEvaluation;
    private String commentaire;
    
    // Constructeur vide
    public Note() {}
    
    // Constructeur pour l'ajout (sans ID)
    public Note(int etudiantId, int matiereId, double valeur, String typeEvaluation, 
                int semestre, Date dateEvaluation, String commentaire) {
        this.etudiantId = etudiantId;
        this.matiereId = matiereId;
        this.valeur = valeur;
        this.typeEvaluation = typeEvaluation;
        this.semestre = semestre;
        this.dateEvaluation = dateEvaluation;
        this.commentaire = commentaire;
    }
    
    // Constructeur complet
    public Note(int id, int etudiantId, int matiereId, double valeur, String typeEvaluation, 
                int semestre, Date dateEvaluation, String commentaire) {
        this.id = id;
        this.etudiantId = etudiantId;
        this.matiereId = matiereId;
        this.valeur = valeur;
        this.typeEvaluation = typeEvaluation;
        this.semestre = semestre;
        this.dateEvaluation = dateEvaluation;
        this.commentaire = commentaire;
    }
    
    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getEtudiantId() { return etudiantId; }
    public void setEtudiantId(int etudiantId) { this.etudiantId = etudiantId; }
    
    public int getMatiereId() { return matiereId; }
    public void setMatiereId(int matiereId) { this.matiereId = matiereId; }
    
    public double getValeur() { return valeur; }
    public void setValeur(double valeur) { this.valeur = valeur; }
    
    public String getTypeEvaluation() { return typeEvaluation; }
    public void setTypeEvaluation(String typeEvaluation) { this.typeEvaluation = typeEvaluation; }
    
    public int getSemestre() { return semestre; }
    public void setSemestre(int semestre) { this.semestre = semestre; }
    
    public Date getDateEvaluation() { return dateEvaluation; }
    public void setDateEvaluation(Date dateEvaluation) { this.dateEvaluation = dateEvaluation; }
    
    public String getCommentaire() { return commentaire; }
    public void setCommentaire(String commentaire) { this.commentaire = commentaire; }
}