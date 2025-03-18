package servlets;

import dao.EnseignantDAO;
import model.Enseignant;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EnseignantServlet")
public class EnseignantServlet extends HttpServlet {
    private EnseignantDAO enseignantDAO = new EnseignantDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Ajouter un enseignant
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String motDePasse = request.getParameter("mot_de_passe");
            String specialite = request.getParameter("specialite");
            int matiereId = Integer.parseInt(request.getParameter("matiere_id"));

            Enseignant enseignant = new Enseignant(nom, prenom, email, motDePasse, specialite);

            int enseignantId = enseignantDAO.ajouterEnseignant(enseignant);
            if (enseignantId > 0) {
                // Associer l'enseignant à la matière
                boolean associationSuccess = enseignantDAO.associerMatiere(enseignantId, matiereId);
                
                if (associationSuccess) {
                    response.sendRedirect("enseignants.jsp?success=add");
                } else {
                    // Si l'association échoue, on pourrait supprimer l'enseignant créé
                    enseignantDAO.supprimerEnseignant(enseignantId);
                    response.sendRedirect("enseignant-form.jsp?error=1");
                }
            } else {
                response.sendRedirect("enseignant-form.jsp?error=1");
            }
        } 
     // Dans la partie "update" du EnseignantServlet
        else if ("update".equals(action)) {
            // Mettre à jour un enseignant
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                String email = request.getParameter("email");
                String motDePasse = request.getParameter("mot_de_passe");
                String specialite = request.getParameter("specialite");
                int matiereId = Integer.parseInt(request.getParameter("matiere_id"));
                
                // Récupérer l'enseignant actuel pour conserver le mot de passe si nécessaire
                Enseignant existingEnseignant = enseignantDAO.getEnseignantById(id);
                
                if (existingEnseignant != null) {
                    // Si le mot de passe est vide, conserver l'ancien
                    if (motDePasse == null || motDePasse.trim().isEmpty()) {
                        motDePasse = existingEnseignant.getMotDePasse();
                    }
                    
                    Enseignant enseignant = new Enseignant(id, nom, prenom, email, motDePasse, specialite);
                    
                    boolean success = enseignantDAO.updateEnseignant(enseignant);
                    
                    if (success) {
                        // Mettre à jour l'association avec la matière
                        // D'abord supprimer les associations existantes
                        enseignantDAO.supprimerAssociationsMatiere(id);
                        // Puis ajouter la nouvelle association
                        enseignantDAO.associerMatiere(id, matiereId);
                        
                        response.sendRedirect("enseignants.jsp?success=update");
                    } else {
                        response.sendRedirect("enseignant-form.jsp?id=" + id + "&error=1");
                    }
                } else {
                    response.sendRedirect("enseignants.jsp?error=1");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("enseignants.jsp?error=1");
            }
        }
        else if ("delete".equals(action)) {
            // Supprimer un enseignant
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = enseignantDAO.supprimerEnseignant(id);
                
                if (success) {
                    response.sendRedirect("enseignants.jsp?success=delete");
                } else {
                    response.sendRedirect("enseignants.jsp?error=1");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("enseignants.jsp?error=1");
            }
        }
    }
}