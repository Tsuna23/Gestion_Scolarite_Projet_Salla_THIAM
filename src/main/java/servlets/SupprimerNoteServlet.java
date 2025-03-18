package servlets;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.NoteDAO;

@WebServlet("/SupprimerNoteServlet")
public class SupprimerNoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Récupération des paramètres
            int noteId = Integer.parseInt(request.getParameter("noteId"));
            int etudiantId = Integer.parseInt(request.getParameter("etudiantId"));

            // Suppression de la note
            NoteDAO noteDAO = new NoteDAO();
            boolean success = noteDAO.supprimerNote(noteId);

            // Redirection
            String redirectURL = "note-etudiant.jsp?etudiantId=" + etudiantId;
            if (success) {
                // Stocker un message dans la session pour afficher un message de succès
                request.getSession().setAttribute("message", "La note a été supprimée avec succès");
                request.getSession().setAttribute("messageType", "success");
            } else {
                // Stocker un message dans la session pour afficher un message d'erreur
                request.getSession().setAttribute("message", "Erreur lors de la suppression de la note");
                request.getSession().setAttribute("messageType", "error");
            }

            response.sendRedirect(redirectURL);

        } catch (NumberFormatException e) {
            // Gestion de l'erreur de format de nombre
            request.getSession().setAttribute("message", "Paramètres invalides: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("note-etudiant.jsp");
        } catch (Exception e) {
            // Gestion des autres exceptions
            e.printStackTrace();
            request.getSession().setAttribute("message", "Une erreur s'est produite: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("note-etudiant.jsp");
        }
    }
}