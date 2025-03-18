package servlets;

import dao.EtudiantDAO;
import model.Etudiant;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EtudiantServlet")
public class EtudiantServlet extends HttpServlet {
    private EtudiantDAO etudiantDAO = new EtudiantDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Ajouter un étudiant
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String emailPersonnel = request.getParameter("email_personnel");
            String motDePasse = request.getParameter("mot_de_passe");
            String filiere = request.getParameter("filiere");
            String niveau = request.getParameter("niveau");

            Etudiant etudiant = new Etudiant(nom, prenom, emailPersonnel, motDePasse, filiere, niveau);

            if (etudiantDAO.ajouterEtudiant(etudiant)) {
                // Générer un email institutionnel
                String emailEcole = prenom.toLowerCase() + "." + nom.toLowerCase() + "@etu.sn";
                etudiantDAO.ajouterEmailInstitutionnel(emailPersonnel, emailEcole);
                
                response.sendRedirect("etudiants.jsp?success=add");
            } else {
                response.sendRedirect("etudiant-form.jsp?error=1");
            }
        } 
        else if ("update".equals(action)) {
            // Mettre à jour un étudiant
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                String emailPersonnel = request.getParameter("email_personnel");
                String motDePasse = request.getParameter("mot_de_passe");
                String filiere = request.getParameter("filiere");
                String niveau = request.getParameter("niveau");
                
                // Récupérer l'étudiant actuel pour conserver l'email_ecole et le mot de passe si nécessaire
                Etudiant existingEtudiant = etudiantDAO.getEtudiantById(id);
                
                if (existingEtudiant != null) {
                    // Si le mot de passe est vide, conserver l'ancien
                    if (motDePasse == null || motDePasse.trim().isEmpty()) {
                        motDePasse = existingEtudiant.getMotDePasse();
                    }
                    
                    Etudiant etudiant = new Etudiant(id, nom, prenom, emailPersonnel, 
                                              existingEtudiant.getEmailEcole(), 
                                              motDePasse, filiere, niveau);
                    
                    boolean success = etudiantDAO.updateEtudiant(etudiant);
                    
                    if (success) {
                        response.sendRedirect("etudiants.jsp?success=update");
                    } else {
                        response.sendRedirect("etudiant-form.jsp?id=" + id + "&error=1");
                    }
                } else {
                    response.sendRedirect("etudiants.jsp?error=1");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("etudiants.jsp?error=1");
            }
        }
        else if ("delete".equals(action)) {
            // Supprimer un étudiant
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = etudiantDAO.supprimerEtudiant(id);
                
                if (success) {
                    response.sendRedirect("etudiants.jsp?success=delete");
                } else {
                    response.sendRedirect("etudiants.jsp?error=1");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("etudiants.jsp?error=1");
            }
        }
    }
}