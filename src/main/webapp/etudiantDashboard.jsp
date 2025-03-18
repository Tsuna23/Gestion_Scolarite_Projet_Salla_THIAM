<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Etudiant, dao.EtudiantDAO, java.util.Date, java.text.SimpleDateFormat" %>
<%
// Logique de vérification robuste de la session
Etudiant etudiant = (Etudiant) session.getAttribute("etudiant");

if (etudiant == null || etudiant.getNom() == null || etudiant.getPrenom() == null || etudiant.getEmailEcole() == null) {
    // Tentative de récupération depuis la base de données
    EtudiantDAO etudiantDAO = new EtudiantDAO();
    
    String emailEcole = (etudiant != null) ? etudiant.getEmailEcole() : null;
    
    if (emailEcole != null) {
        etudiant = etudiantDAO.getEtudiantByEmail(emailEcole);
        session.setAttribute("etudiant", etudiant);
    } 
    
    // Si la récupération échoue, redirection vers la page de connexion
    if (etudiant == null) {
        response.sendRedirect("login.jsp");
        return;
    }
}

// Format de la date
SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
String dateActuelle = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace</title>
    
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
            <a href="etudiantDashboard.jsp" class="active">
                <i class="fas fa-tachometer-alt me-2"></i>
                <span>Tableau de bord</span>
            </a>
            <a href="etudiant-inscription.jsp">
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
                <h4 class="mb-0">Bienvenue, <%= etudiant.getPrenom() %></h4>
                <div>
                    <span class="badge bg-primary"><%= etudiant.getEmailEcole() %></span>
                    <span class="ms-2 text-muted"><%= dateActuelle %></span>
                </div>
            </div>
        </div>
        
        <!-- Content -->
        <div class="container-fluid mt-4">
            <!-- Stats cards -->
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card bg-primary text-white h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-uppercase mb-0">Cours inscrits</h6>
                                   
                                    <p class="small mb-0">Semestre en cours</p>
                                </div>
                                <div>
                                    <i class="fas fa-book-open fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent border-0">
                            <a href="etudiant-inscription.jsp" class="text-white">Voir les détails <i class="fas fa-arrow-right ms-1"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 mb-4">
                    <div class="card bg-success text-white h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-uppercase mb-0">Moyenne générale</h6>
                                   
                                    <p class="small mb-0">Semestre en cours</p>
                                </div>
                                <div>
                                    <i class="fas fa-chart-line fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent border-0">
                            <a href="etudiant-note.jsp" class="text-white">Voir les détails <i class="fas fa-arrow-right ms-1"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Main content row -->
            <div class="row">
                <!-- Événements à venir -->
                <div class="col-lg-8 mb-4">
                    <div class="card h-100">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Événements à venir</h5>
                        </div>
                        <div class="card-body">
                            <ul class="calendar-events">
                                <li class="d-flex align-items-center">
                                    <span class="event-date">27 Mars</span>
                                    <span class="event-time me-2">14:00</span>
                                    <span>Remise de projet - Algorithmique</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <!-- Profile Summary -->
                <div class="col-lg-4 mb-4">
                    <div class="card h-100">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Mon profil</h5>
                        </div>
                        <div class="card-body profile-card">
                            <div class="profile-avatar">
                                <%= etudiant.getPrenom().charAt(0) %><%= etudiant.getNom().charAt(0) %>
                            </div>
                            <div class="profile-info">
                                <h4><%= etudiant.getPrenom() %> <%= etudiant.getNom() %></h4>
                                <p><%= etudiant.getFiliere() %> - <%= etudiant.getNiveau() %></p>
                                <p><i class="fas fa-envelope me-2"></i><%= etudiant.getEmailEcole() %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Notifications & Announcements -->
            <div class="row">
                <div class="col-12 mb-4">
                    <div class="card">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Annonces récentes</h5>
                            <span class="badge bg-primary">3 nouvelles</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="notification-item">
                                <div class="notification-icon bg-primary">
                                    <i class="fas fa-bullhorn"></i>
                                </div>
                                <div class="notification-content flex-grow-1">
                                    <div class="d-flex justify-content-between">
                                        <h5>Inscription aux rattrapages</h5>
                                        <span class="notification-time">Il y a 2 heures</span>
                                    </div>
                                    <p>Les inscriptions aux examens de rattrapage sont ouvertes. Veuillez vous inscrire avant le 30 Mars.</p>
                                </div>
                            </div>
                            
                            <div class="notification-item">
                                <div class="notification-icon bg-success">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <div class="notification-content flex-grow-1">
                                    <div class="d-flex justify-content-between">
                                        <h5>Changement de salle - Cours de Java</h5>
                                        <span class="notification-time">Il y a 1 jour</span>
                                    </div>
                                    <p>Le cours de Java du Mercredi 22 Mars se déroulera en salle A305 au lieu de B203.</p>
                                </div>
                            </div>
                            
                            <div class="notification-item">
                                <div class="notification-icon bg-warning">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </div>
                                <div class="notification-content flex-grow-1">
                                    <div class="d-flex justify-content-between">
                                        <h5>Rappel - Rendu de projet</h5>
                                        <span class="notification-time">Il y a 3 jours</span>
                                    </div>
                                    <p>N'oubliez pas de rendre votre projet d'Algorithmique avant le 27 Mars à 14h00.</p>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer bg-white text-center">
                            <a href="#" class="btn btn-link">Voir toutes les annonces</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>