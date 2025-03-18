package model;

import java.io.Serializable;

public class Etudiant implements Serializable { // Permet de stocker l'objet en session sans perte de données
    private int id;
    private String nom;
    private String prenom;
    private String emailPersonnel;
    private String emailEcole;  // Généré après inscription
    private String motDePasse;
    private String filiere;
    private String niveau;

    public Etudiant() {}

    // ✅ Constructeur pour l'inscription (sans emailEcole, généré après)
    public Etudiant(String nom, String prenom, String emailPersonnel, String motDePasse, String filiere, String niveau) {
        this.nom = nom;
        this.prenom = prenom;
        this.emailPersonnel = emailPersonnel;
        this.motDePasse = motDePasse;
        this.filiere = filiere;
        this.niveau = niveau;
    }

    // ✅ Constructeur pour la connexion
    public Etudiant(String emailEcole, String motDePasse) {
        this.emailEcole = emailEcole;
        this.motDePasse = motDePasse;
    }

    // ✅ Constructeur COMPLET utilisé par le DAO pour récupérer les données
    public Etudiant(int id, String nom, String prenom, String emailPersonnel, String emailEcole, String motDePasse, String filiere, String niveau) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.emailPersonnel = emailPersonnel;
        this.emailEcole = emailEcole;
        this.motDePasse = motDePasse;
        this.filiere = filiere != null ? filiere : "Non renseigné";
        this.niveau = niveau != null ? niveau : "Non renseigné";
    }

    

	public Etudiant(int int1, String string, String string2, String string3, String string4, String string5) {
		// TODO Auto-generated constructor stub
	}

	// ✅ Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmailPersonnel() { return emailPersonnel; }
    public void setEmailPersonnel(String emailPersonnel) { this.emailPersonnel = emailPersonnel; }

    public String getEmailEcole() { return emailEcole; }
    public void setEmailEcole(String emailEcole) { this.emailEcole = emailEcole; }

    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }

    public String getFiliere() { return filiere; }
    public void setFiliere(String filiere) { this.filiere = filiere; }

    public String getNiveau() { return niveau; }
    public void setNiveau(String niveau) { this.niveau = niveau; }

    @Override
    public String toString() {
        return "Etudiant{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", emailPersonnel='" + emailPersonnel + '\'' +
                ", emailEcole='" + emailEcole + '\'' +
                ", filiere='" + filiere + '\'' +
                ", niveau='" + niveau + '\'' +
                '}';
    }
}
