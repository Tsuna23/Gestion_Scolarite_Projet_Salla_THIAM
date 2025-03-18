package model;

import java.io.Serializable;

public class Enseignant implements Serializable {
    private int id;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse;
    private String specialite;
    private String matiere; // Nouveau champ pour stocker le nom de la matière
    
    // Constructeur vide
    public Enseignant() {}
    
    // Constructeur pour l'ajout (sans ID)
    public Enseignant(String nom, String prenom, String email, String motDePasse, String specialite) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.specialite = specialite;
    }
    
    // Constructeur complet
    public Enseignant(int id, String nom, String prenom, String email, String motDePasse, String specialite) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.specialite = specialite;
    }
    
    // Constructeur avec matière
    public Enseignant(int id, String nom, String prenom, String email, String motDePasse, String specialite, String matiere) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.specialite = specialite;
        this.matiere = matiere;
    }
    
    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }
    
    public String getSpecialite() { return specialite; }
    public void setSpecialite(String specialite) { this.specialite = specialite; }
    
    public String getMatiere() { return matiere; }
    public void setMatiere(String matiere) { this.matiere = matiere; }
}