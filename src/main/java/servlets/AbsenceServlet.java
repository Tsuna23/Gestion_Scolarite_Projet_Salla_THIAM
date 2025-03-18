package servlets;

import dao.AbsenceDAO;
import model.Absence;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AbsenceServlet")
public class AbsenceServlet extends HttpServlet {
    private AbsenceDAO absenceDAO = new AbsenceDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Ajouter une absence
            try {
                int etudiantId = Integer.parseInt(request.getParameter("etudiantId"));
                int matiereId = Integer.parseInt(request.getParameter("matiereId"));
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date date = sdf.parse(request.getParameter("date"));
                
                boolean justifiee = request.getParameter("justifiee") != null;
                String motif = request.getParameter("motif");
                String commentaire = request.getParameter("commentaire");
                
                Absence absence = new Absence();
                absence.setEtudiantId(etudiantId);
                absence.setMatiereId(matiereId);
                absence.setDate(date);
                absence.setJustifiee(justifiee);
                absence.setMotif(motif);
                absence.setCommentaire(commentaire);
                
                boolean success = absenceDAO.ajouterAbsence(absence);
                
                if (success) {
                    response.sendRedirect("absences.jsp?success=add&message=Absence ajoutée avec succès");
                } else {
                    response.sendRedirect("absences.jsp?error=1&message=Erreur lors de l'ajout de l'absence");
                }
            } catch (ParseException e) {
                e.printStackTrace();
                response.sendRedirect("absences.jsp?error=1&message=Format de date invalide");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("absences.jsp?error=1&message=Une erreur s'est produite: " + e.getMessage());
            }
        }
        else if ("update".equals(action)) {
            // Mettre à jour une absence
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                int etudiantId = Integer.parseInt(request.getParameter("etudiantId"));
                int matiereId = Integer.parseInt(request.getParameter("matiereId"));
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date date = sdf.parse(request.getParameter("date"));
                
                boolean justifiee = request.getParameter("justifiee") != null;
                String motif = request.getParameter("motif");
                String commentaire = request.getParameter("commentaire");
                
                Absence absence = new Absence();
                absence.setId(id);
                absence.setEtudiantId(etudiantId);
                absence.setMatiereId(matiereId);
                absence.setDate(date);
                absence.setJustifiee(justifiee);
                absence.setMotif(motif);
                absence.setCommentaire(commentaire);
                
                boolean success = absenceDAO.modifierAbsence(absence);
                
                if (success) {
                    response.sendRedirect("absences.jsp?success=update&message=Absence modifiée avec succès");
                } else {
                    response.sendRedirect("absences.jsp?error=1&message=Erreur lors de la modification de l'absence");
                }
            } catch (ParseException e) {
                e.printStackTrace();
                response.sendRedirect("absences.jsp?error=1&message=Format de date invalide");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("absences.jsp?error=1&message=Une erreur s'est produite: " + e.getMessage());
            }
        }
        else if ("delete".equals(action)) {
            // Supprimer une absence
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = absenceDAO.supprimerAbsence(id);
                
                if (success) {
                    response.sendRedirect("absences.jsp?success=delete&message=Absence supprimée avec succès");
                } else {
                    response.sendRedirect("absences.jsp?error=1&message=Erreur lors de la suppression de l'absence");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("absences.jsp?error=1&message=Une erreur s'est produite: " + e.getMessage());
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirige vers la page d'absences en cas d'accès direct au servlet
        response.sendRedirect("absences.jsp");
    }
}