<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Etudiant, model.Matiere, dao.MatiereDAO, dao.InscriptionDAO, java.util.List, java.util.ArrayList" %>
<%
    Etudiant etudiant = (Etudiant) session.getAttribute("etudiant");
    
    if (etudiant == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Récupérer les matières disponibles
    MatiereDAO matiereDAO = new MatiereDAO();
    List<Matiere> toutesMatieresDisponibles = matiereDAO.getAllMatieres();
    
    // Récupérer les matières auxquelles l'étudiant est déjà inscrit
    InscriptionDAO inscriptionDAO = new InscriptionDAO();
    List<Matiere> matieresInscrites = inscriptionDAO.getMatieresInscrites(etudiant.getId());
    
    // Filtrer pour avoir les matières auxquelles l'étudiant n'est pas encore inscrit
    List<Matiere> matieresDisponibles = new ArrayList<>();
    for (Matiere matiere : toutesMatieresDisponibles) {
        boolean estDejaInscrit = false;
        for (Matiere matiereInscrite : matieresInscrites) {
            if (matiere.getId() == matiereInscrite.getId()) {
                estDejaInscrit = true;
                break;
            }
        }
        if (!estDejaInscrit) {
            matieresDisponibles.add(matiere);
        }
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscriptions aux cours</title>
    
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
            <a href="etudiant-inscription.jsp" class="active">
                <i class="fas fa-book me-2"></i>
                <span>Inscriptions</span>
            </a>
            <a href="etudiant-note.jsp">
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
                        <li class="breadcrumb-item active">Inscriptions aux cours</li>
                    </ol>
                </nav>
                <div>
                    <span class="badge bg-primary"><%= etudiant.getEmailEcole() %></span>
                </div>
            </div>
        </div>
        
        <!-- Content -->
        <div class="container-fluid mt-4">
            <h2 class="mb-4">Mes inscriptions aux cours</h2>
            
            <!-- Afficher messages de succès/erreur si présents -->
            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                Inscription réussie!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                Une erreur s'est produite. Veuillez réessayer.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
            
            <!-- Matières déjà inscrites -->
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Cours auxquels vous êtes inscrit</h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        Une fois inscrit à un cours, vous ne pouvez pas vous désinscrire. Contactez l'administration pour toute demande spéciale.
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Nom de la matière</th>
                                    <th>Coefficient</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (matieresInscrites.isEmpty()) { %>
                                <tr>
                                    <td colspan="3" class="text-center">Vous n'êtes inscrit à aucun cours pour le moment.</td>
                                </tr>
                                <% } else { 
                                    for (Matiere matiere : matieresInscrites) { %>
                                <tr>
                                    <td><%= matiere.getNom() %></td>
                                    <td><%= matiere.getCoefficient() %></td>
                                    <td><%= matiere.getDescription() != null ? matiere.getDescription() : "-" %></td>
                                </tr>
                                <% } 
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Matières disponibles pour inscription -->
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Cours disponibles pour inscription</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Nom de la matière</th>
                                    <th>Coefficient</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (matieresDisponibles.isEmpty()) { %>
                                <tr>
                                    <td colspan="4" class="text-center">Aucun cours disponible pour inscription.</td>
                                </tr>
                                <% } else { 
                                    for (Matiere matiere : matieresDisponibles) { %>
                                <tr>
                                    <td><%= matiere.getNom() %></td>
                                    <td><%= matiere.getCoefficient() %></td>
                                    <td><%= matiere.getDescription() != null ? matiere.getDescription() : "-" %></td>
                                    <td>
                                        <form action="InscriptionMatiereServlet" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="inscription">
                                            <input type="hidden" name="etudiant_id" value="<%= etudiant.getId() %>">
                                            <input type="hidden" name="matiere_id" value="<%= matiere.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-success">
                                                <i class="fas fa-plus me-1"></i> S'inscrire
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } 
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>