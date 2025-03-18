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

@WebServlet("/AjouterNoteServlet")
public class AjouterNoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
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
            
            // Création de la note
            Note note = new Note();
            note.setEtudiantId(etudiantId);
            note.setMatiereId(matiereId);
            note.setTypeEvaluation(typeEvaluation);
            note.setValeur(valeur);
            note.setDateEvaluation(dateEvaluation);
            note.setSemestre(semestre);
            note.setCommentaire(commentaire);
            
            // Sauvegarde de la note
            NoteDAO noteDAO = new NoteDAO();
            boolean success = noteDAO.ajouterNote(note);
            
            // Redirection
            String redirectURL = "note-etudiant.jsp?etudiantId=" + etudiantId;
            if (success) {
                redirectURL += "&success=true";
            } else {
                redirectURL += "&error=true";
            }
            
            response.sendRedirect(redirectURL);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("note-etudiant.jsp?error=true");
        }
    }
}