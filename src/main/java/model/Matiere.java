package model;

import java.io.Serializable;

public class Matiere implements Serializable {
    private int id;
    private String nom;
    private double coefficient;
    private String description;
    
    // Constructeur vide
    public Matiere() {}
    
    // Constructeur pour l'ajout (sans ID)
    public Matiere(String nom, double coefficient, String description) {
        this.nom = nom;
        this.coefficient = coefficient;
        this.description = description;
    }
    
    // Constructeur complet
    public Matiere(int id, String nom, double coefficient, String description) {
        this.id = id;
        this.nom = nom;
        this.coefficient = coefficient;
        this.description = description;
    }
    
    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; } 
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public double getCoefficient() { return coefficient; }
    public void setCoefficient(double coefficient) { this.coefficient = coefficient; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    @Override
    public String toString() {
        return "Matiere{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", coefficient=" + coefficient +
                '}';
    }
}