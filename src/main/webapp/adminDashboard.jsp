<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Administrateur" %>
<%
    Administrateur admin = (Administrateur) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <title>Dashboard Administrateur</title>
    <link rel="stylesheet" href="assets/css/admin.css?v=2">
    
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-graduation-cap me-2"></i> SkillEdge
        </div>
        
        <div class="pt-3">
            <span class="sidebar-heading">Navigation</span>
            <a href="adminDashboard.jsp" class="active">
                <i class="fas fa-tachometer-alt me-2"></i>
                <span>Tableau de bord</span>
            </a>
            <a href="etudiants.jsp">
                <i class="fas fa-user-graduate me-2"></i>
                <span>Étudiants</span>
            </a>
            <a href="enseignants.jsp">
                <i class="fas fa-chalkboard-teacher me-2"></i>
                <span>Enseignants</span>
            </a>
            
            <span class="sidebar-heading mt-3">Académique</span>
            <a href="bulletins.jsp">
                <i class="fas fa-file-alt me-2"></i>
                <span>Bulletins</span>
            </a>
            <a href="absences.jsp">
                <i class="fas fa-calendar-times me-2"></i>
                <span>Absences</span>
            </a>
        </div>
        
        <div class="sidebar-user mt-auto">
            <div class="d-flex align-items-center">
                <div class="flex-shrink-0">
                    <i class="fas fa-user-circle fa-2x text-light"></i>
                </div>
                <div class="flex-grow-1 ms-3">
                    <span class="fw-semibold text-light"><%= admin.getPrenom() %> <%= admin.getNom() %></span>
                    <p class="text-muted mb-0 small">Administrateur</p>
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
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item active" aria-current="page">Tableau de bord</li>
                </ol>
            </nav>
            <div class="d-flex align-items-center">
                <div class="dropdown">
                    <button class="btn btn-link text-dark position-relative" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-bell"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            7
                        </span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><div class="dropdown-header">Notifications</div></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><div class="dropdown-item text-center">Aucune notification</div></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Dashboard content -->
        <div class="container-fluid">
            <h2 class="mb-4">Tableau de bord</h2>
            
            <!-- Stats cards -->
            <div class="row-stats">
                <!-- Étudiants card -->
                <div class="stat-card blue">
                    <h3 class="stat-title">Étudiants</h3>
                    <div class="stat-value"></div>
                    <a href="etudiants.jsp" class="stat-link">Voir tous les étudiants <i class="fas fa-arrow-right"></i></a>
                    <div class="stat-icon">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                </div>
                
                <!-- Enseignants card -->
                <div class="stat-card green">
                    <h3 class="stat-title">Enseignants</h3>
                    <div class="stat-value"></div>
                    <a href="enseignants.jsp" class="stat-link">Voir tous les enseignants <i class="fas fa-arrow-right"></i></a>
                    <div class="stat-icon">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                </div> 
                <!-- Absences card -->
                <div class="stat-card red">
                    <h3 class="stat-title">Absences</h3>
                    <div class="stat-value"></div>
                    <a href="absences.jsp" class="stat-link">Voir toutes les absences <i class="fas fa-arrow-right"></i></a>
                    <div class="stat-icon">
                        <i class="fas fa-calendar-times"></i>
                    </div>
                </div>
            </div>
            
            <!-- Actions and Activities -->
            <div class="row mt-4">
                <!-- Actions rapides -->
                <div class="col-md-6 mb-4">
                    <div class="action-section">
                        <div class="action-header blue">
                            Actions rapides
                        </div>
                        <div class="action-body">
                            <div class="action-list">
                                <a href="etudiant-form.jsp" class="btn-action blue">
                                    <i class="fas fa-user-plus"></i> Ajouter un étudiant
                                </a>
                                <a href="enseignant-form.jsp" class="btn-action green">
                                    <i class="fas fa-user-plus"></i> Ajouter un enseignant
                                </a>
                                <a href="bulletins.jsp" class="btn-action orange">
                                    <i class="fas fa-file-alt"></i> Générer un bulletin
                                </a>
                                <a href="absences.jsp" class="btn-action red">
                                    <i class="fas fa-calendar-plus"></i> Enregistrer une absence
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Dernières activités -->
                <div class="col-md-6 mb-4">
                    <div class="action-section">
                        <div class="action-header cyan">
                            Dernières activités
                        </div>
                        <div class="action-body p-0">
                            <div class="activity-item">
                                <div class="activity-content">
                                    <div class="activity-icon">
                                        <i class="fas fa-user-graduate"></i>
                                    </div>
                                    <span>Aucune activité récente</span>
                                </div>
                                <div class="activity-time">Maintenant</div>
                            </div>
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