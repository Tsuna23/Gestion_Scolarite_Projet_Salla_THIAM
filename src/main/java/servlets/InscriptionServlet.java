package servlets;
import dao.EtudiantDAO;
import model.Etudiant;
import sendEmail.EmailUtil;

import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/InscriptionServlet")
public class InscriptionServlet extends HttpServlet {
    private EtudiantDAO etudiantDAO = new EtudiantDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String emailPersonnel = request.getParameter("email_personnel");
        String motDePasse = request.getParameter("mot_de_passe");
        String filiere = request.getParameter("filiere");
        String niveau = request.getParameter("niveau");

        Etudiant etudiant = new Etudiant(nom, prenom, emailPersonnel, motDePasse, filiere, niveau);

        if (etudiantDAO.ajouterEtudiant(etudiant)) {
            // Générer un email institutionnel
        	// Générer l'email institutionnel sous la forme prenom.nom@etu.sn
        	String emailEcole = prenom.toLowerCase() + "." + nom.toLowerCase() + "@etu.sn";

            etudiantDAO.ajouterEmailInstitutionnel(emailPersonnel, emailEcole);

            // Envoyer l'email avec les identifiants
            EmailUtil.sendEmail(emailPersonnel, "Vos identifiants SkillEdge",
                    "Bonjour " + prenom + ",\n\nVotre email  : " + emailEcole +
                    "\nVotre mot de passe : " + motDePasse + "\n\nUtilisez ces informations pour vous connecter.");

            response.sendRedirect("confirmation.jsp");
        } else {
            response.sendRedirect("inscription.jsp?error=1");
        }
    }
}
