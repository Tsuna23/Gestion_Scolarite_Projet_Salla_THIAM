<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Etudiant, model.Matiere, model.Note, dao.NoteDAO, dao.InscriptionDAO, java.util.List, java.util.Map, java.util.HashMap" %>
<%
    Etudiant etudiant = (Etudiant) session.getAttribute("etudiant");
    
    if (etudiant == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Récupérer les matières auxquelles l'étudiant est inscrit
    InscriptionDAO inscriptionDAO = new InscriptionDAO();
    List<Matiere> matieresInscrites = inscriptionDAO.getMatieresInscrites(etudiant.getId());
    
    // Récupérer les notes de l'étudiant
    NoteDAO noteDAO = new NoteDAO();
    Map<Integer, List<Note>> notesByMatiere = new HashMap<>();
    
    for (Matiere matiere : matieresInscrites) {
        List<Note> notesMatiere = noteDAO.getNotesByEtudiantAndMatiere(etudiant.getId(), matiere.getId());
        notesByMatiere.put(matiere.getId(), notesMatiere);
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes notes </title>
    
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/etudiant.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-graduation-cap me-2"></i> <span>SkillEdge</span>
        </div>
        
        <div class="pt-3">
            <span class="sidebar-heading">Navigation</span>
            <a href="etudiantDashboard.jsp">
                <i class="fas fa-tachometer-alt me-2"></i>
                <span>Tableau de bord</span>
            </a>
            <a href="etudiant-inscription.jsp">
                <i class="fas fa-book me-2"></i>
                <span>Inscriptions</span>
            </a>
            <a href="etudiant-notes.jsp" class="active">
                <i class="fas fa-chart-line me-2"></i>
                <span>Mes notes</span>
            </a>
        </div>
        
        <div class="sidebar-user mt-auto">
            <div class="d-flex align-items-center">
                <div class="flex-shrink-0">
                    <i class="fas fa-user-circle fa-2x text-light"></i>
                </div>
                <div class="flex-grow-1 ms-3">
                    <span class="fw-semibold text-light"><%= etudiant.getPrenom() %> <%= etudiant.getNom() %></span>
                    <p class="text-muted mb-0 small"><%= etudiant.getFiliere() %> - <%= etudiant.getNiveau() %></p>
                </div>
            </div>
           <div class="mt-2">
                <a href="index.jsp" class="btn btn-sm btn-outline-danger w-100">
                    <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
                </a>
            </div>
        </div>
    </div>
    
    <!-- Main content -->
    <div class="content-wrapper">
        <!-- Top navbar -->
        <div class="top-navbar">
            <div class="d-flex justify-content-between align-items-center">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="etudiantDashboard.jsp">Tableau de bord</a></li>
                        <li class="breadcrumb-item active">Mes notes</li>
                    </ol>
                </nav>
                <div>
                    <span class="badge bg-primary"><%= etudiant.getEmailEcole() %></span>
                </div>
            </div>
        </div>
        
        <!-- Content -->
        <div class="container-fluid mt-4">
            <h2 class="mb-4">Mes notes</h2>
            
            <% if (matieresInscrites.isEmpty()) { %>
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Vous n'êtes inscrit à aucun cours pour le moment. <a href="etudiant-inscription.jsp">Inscrivez-vous à des cours</a> pour voir vos notes.
            </div>
            <% } else { %>
                <% for (Matiere matiere : matieresInscrites) { 
                    List<Note> notesMatiere = notesByMatiere.get(matiere.getId());
                    double moyenne = 0;
                    boolean hasNotes = false;
                    
                    if (notesMatiere != null && !notesMatiere.isEmpty()) {
                        double totalPoints = 0;
                        for (Note note : notesMatiere) {
                            totalPoints += note.getValeur();
                        }
                        moyenne = totalPoints / notesMatiere.size();
                        hasNotes = true;
                    }
                %>
                <div class="card mb-4">
                    <div class="card-header <%= hasNotes ? (moyenne >= 10 ? "bg-success" : "bg-danger") : "bg-secondary" %> text-white">
                        <h5 class="mb-0"><%= matiere.getNom() %> (coefficient: <%= matiere.getCoefficient() %>)</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Type d'évaluation</th>
                                        <th>Note</th>
                                        <th>Date</th>
                                        <th>Semestre</th>
                                        <th>Commentaire</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (!hasNotes) { %>
                                    <tr>
                                        <td colspan="5" class="text-center">Aucune note disponible pour cette matière.</td>
                                    </tr>
                                    <% } else { 
                                        for (Note note : notesMatiere) { %>
                                    <tr>
                                        <td><%= note.getTypeEvaluation() %></td>
                                        <td class="<%= note.getValeur() >= 10 ? "text-success fw-bold" : "text-danger fw-bold" %>">
                                            <%= note.getValeur() %>/20
                                        </td>
                                        <td><%= note.getDateEvaluation() %></td>
                                        <td>Semestre <%= note.getSemestre() %></td>
                                        <td><%= note.getCommentaire() != null ? note.getCommentaire() : "-" %></td>
                                    </tr>
                                    <% } 
                                    } %>
                                </tbody>
                                <% if (hasNotes) { %>
                                <tfoot>
                                    <tr class="table-secondary fw-bold">
                                        <td>Moyenne</td>
                                        <td colspan="4" class="<%= moyenne >= 10 ? "text-success" : "text-danger" %>">
                                            <%= String.format("%.2f", moyenne) %>/20
                                        </td>
                                    </tr>
                                </tfoot>
                                <% } %>
                            </table>
                        </div>
                    </div>
                </div>
                <% } %>
            <% } %>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>