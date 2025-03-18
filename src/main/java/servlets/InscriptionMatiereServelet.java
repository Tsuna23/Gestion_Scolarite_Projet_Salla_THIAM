package servlets;

import dao.InscriptionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/InscriptionMatiereServlet")
public class InscriptionMatiereServelet extends HttpServlet {
    private InscriptionDAO inscriptionDAO = new InscriptionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int etudiantId = Integer.parseInt(request.getParameter("etudiant_id"));
        int matiereId = Integer.parseInt(request.getParameter("matiere_id"));

        boolean success = false;

        if ("inscription".equals(action)) {
            // Vérifier si l'étudiant n'est pas déjà inscrit
            if (!inscriptionDAO.estInscrit(etudiantId, matiereId)) {
                success = inscriptionDAO.inscrireEtudiant(etudiantId, matiereId);
            }
        } 
        // La fonctionnalité de désinscription est désactivée
        // else if ("desinscription".equals(action)) {
        //     success = inscriptionDAO.desinscrireEtudiant(etudiantId, matiereId);
        // }

        if (success) {
            response.sendRedirect("etudiant-inscription.jsp?success=true");
        } else {
            response.sendRedirect("etudiant-inscription.jsp?error=true");
        }
    }
}