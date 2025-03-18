package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.EtudiantDAO;
import dao.AdministrateurDAO;
import dao.EnseignantDAO; // Ajout de l'import pour EnseignantDAO
import model.Etudiant;
import model.Administrateur;
import model.Enseignant; // Ajout de l'import pour Enseignant

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EtudiantDAO etudiantDAO;
    private AdministrateurDAO administrateurDAO;
    private EnseignantDAO enseignantDAO; // Ajout de EnseignantDAO

    public void init() {
        etudiantDAO = new EtudiantDAO();
        administrateurDAO = new AdministrateurDAO();
        enseignantDAO = new EnseignantDAO(); // Initialisation de EnseignantDAO
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String email = request.getParameter("email_ecole");
            String motDePasse = request.getParameter("mot_de_passe");

            System.out.println("🔍 Tentative de connexion avec : " + email);

            // 🔹 Vérification si c'est un administrateur
            Administrateur admin = administrateurDAO.getAdministrateurByEmail(email, motDePasse);
            if (admin != null) {
                System.out.println("✅ Connexion réussie en tant qu'administrateur !");
                HttpSession session = request.getSession();
                session.setAttribute("admin", admin);
                response.sendRedirect("adminDashboard.jsp");
                return;
            }

            // 🔹 Vérification si c'est un enseignant
            Enseignant enseignant = enseignantDAO.getEnseignantByEmail(email, motDePasse);
            if (enseignant != null) {
                System.out.println("✅ Connexion réussie en tant qu'enseignant !");
                HttpSession session = request.getSession();
                session.setAttribute("enseignant", enseignant);
                response.sendRedirect("enseignantDashboard.jsp");
                return;
            }

            // 🔹 Vérification si c'est un étudiant
            if (etudiantDAO.verifierConnexion(email, motDePasse)) {
                System.out.println("✅ Connexion validée pour un étudiant...");
                Etudiant etudiant = etudiantDAO.getEtudiantByEmail(email);

                if (etudiant != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("etudiant", etudiant);
                    response.sendRedirect("etudiantDashboard.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=notfound");
                }
            } else {
                System.out.println("❌ Identifiants incorrects !");
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (Exception e) {
            System.out.println("❌ Erreur inattendue !");
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=unknown");
        }
    }
}