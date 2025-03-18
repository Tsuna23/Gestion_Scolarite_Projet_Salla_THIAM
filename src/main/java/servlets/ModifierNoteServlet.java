package servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.NoteDAO;
import model.Note;

@WebServlet("/ModifierNoteServlet")
public class ModifierNoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Récupération des paramètres
            int noteId = Integer.parseInt(request.getParameter("noteId"));
            int etudiantId = Integer.parseInt(request.getParameter("etudiantId"));
            int matiereId = Integer.parseInt(request.getParameter("matiereId"));
            String typeEvaluation = request.getParameter("typeEvaluation");
            double valeur = Double.parseDouble(request.getParameter("valeur"));
            String dateEvaluationStr = request.getParameter("dateEvaluation");
            int semestre = Integer.parseInt(request.getParameter("semestre"));
            String commentaire = request.getParameter("commentaire");

            // Convertir la date
            Date dateEvaluation = null;
            try {
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                dateEvaluation = format.parse(dateEvaluationStr);
            } catch (ParseException e) {
                e.printStackTrace();
                dateEvaluation = new Date(); // Date actuelle en cas d'erreur
            }

            // Création/Mise à jour de la note
            Note note = new Note();
            note.setId(noteId);
            note.setEtudiantId(etudiantId);
            note.setMatiereId(matiereId);
            note.setTypeEvaluation(typeEvaluation);
            note.setValeur(valeur);
            note.setDateEvaluation(dateEvaluation);
            note.setSemestre(semestre);
            note.setCommentaire(commentaire);

            // Mise à jour de la note dans la base de données
            NoteDAO noteDAO = new NoteDAO();
            boolean success = noteDAO.updateNote(note);

            // Redirection
            String redirectURL = "note-etudiant.jsp?etudiantId=" + etudiantId;
            if (success) {
                // Stocker un message dans la session pour afficher un message de succès
                request.getSession().setAttribute("message", "La note a été modifiée avec succès");
                request.getSession().setAttribute("messageType", "success");
            } else {
                // Stocker un message dans la session pour afficher un message d'erreur
                request.getSession().setAttribute("message", "Erreur lors de la modification de la note");
                request.getSession().setAttribute("messageType", "error");
            }

            response.sendRedirect(redirectURL);

        } catch (Exception e) {
            e.printStackTrace();
            // Stocker un message d'erreur dans la session
            request.getSession().setAttribute("message", "Une erreur s'est produite: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("note-etudiant.jsp");
        }
    }
}