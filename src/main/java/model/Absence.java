package model;

import java.util.Date;

public class Absence {
    private int id;
    private int etudiantId;
    private int matiereId;
    private Date date;
    private boolean justifiee;
    private String motif;
    private String commentaire;
    private Date dateEnregistrement;
    
    // Constructeur par défaut
    public Absence() {
    }
    
    // Constructeur avec paramètres
    public Absence(int id, int etudiantId, int matiereId, Date date, boolean justifiee, String motif, String commentaire) {
        this.id = id;
        this.etudiantId = etudiantId;
        this.matiereId = matiereId;
        this.date = date;
        this.justifiee = justifiee;
        this.motif = motif;
        this.commentaire = commentaire;
    }
    
    // Getters et Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getEtudiantId() {
        return etudiantId;
    }
    
    public void setEtudiantId(int etudiantId) {
        this.etudiantId = etudiantId;
    }
    
    public int getMatiereId() {
        return matiereId;
    }
    
    public void setMatiereId(int matiereId) {
        this.matiereId = matiereId;
    }
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
    
    public boolean isJustifiee() {
        return justifiee;
    }
    
    public void setJustifiee(boolean justifiee) {
        this.justifiee = justifiee;
    }
    
    public String getMotif() {
        return motif;
    }
    
    public void setMotif(String motif) {
        this.motif = motif;
    }
    
    public String getCommentaire() {
        return commentaire;
    }
    
    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }
    
    public Date getDateEnregistrement() {
        return dateEnregistrement;
    }
    
    public void setDateEnregistrement(Date dateEnregistrement) {
        this.dateEnregistrement = dateEnregistrement;
    }
    
    @Override
    public String toString() {
        return "Absence [id=" + id + ", etudiantId=" + etudiantId + ", matiereId=" + matiereId + ", date=" + date
                + ", justifiee=" + justifiee + ", motif=" + motif + ", commentaire=" + commentaire + "]";
    }
}