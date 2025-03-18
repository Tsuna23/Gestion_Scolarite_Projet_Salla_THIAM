<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Enseignant, java.util.Date, java.text.SimpleDateFormat" %>
<%
// Vérification de la session
Enseignant enseignant = (Enseignant) session.getAttribute("enseignant");

if (enseignant == null) {
    response.sendRedirect("login.jsp");
    return;
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
    <title>Tableau de bord </title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/enseignant.css">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-logo">
            <span>SkillEdge</span>
        </div>
        
        <div class="sidebar-nav">
            <a href="#" class="active">
                <i class="fas fa-tachometer-alt"></i>
                Tableau de bord
            </a>
            <a href="cours.jsp">
                <i class="fas fa-book"></i>
                Mes Cours
            </a>
            <a href="note-etudiant.jsp">
                <i class="fas fa-users"></i>
                Etudiants
            </a>
        </div>
        
        <div class="sidebar-user">
            <div class="sidebar-user-avatar">
                <span class="profile-avatar">
                    <%= enseignant.getPrenom().charAt(0) %><%= enseignant.getNom().charAt(0) %>
                </span>
            </div>
            <div class="sidebar-user-info">
                <span><%= enseignant.getPrenom() %> <%= enseignant.getNom() %></span>
                <small><%= enseignant.getSpecialite() %></small>
            </div>
            <a href="index.jsp" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div class="top-bar">
            <div>
                <div class="welcome-text">Bienvenue, <%= enseignant.getPrenom() %></div>
                <div class="user-email"><%= enseignant.getEmail() %></div>
            </div>
            <div class="date"><%= dateActuelle %></div>
        </div>

        <div class="dashboard-cards">
            <div class="card card-blue">
                <div class="card-content">
                    <div>
                        <h3>Cours</h3>
                        <div style="font-size: 2rem; font-weight: 700;"></div>
                        <small>Semestre en cours</small>
                    </div>
                    <i class="fas fa-book-open"></i>
                </div>
            </div>

            <div class="card card-green">
                <div class="card-content">
                    <div>
                        <h3>Total Étudiants</h3>
                        <div style="font-size: 2rem; font-weight: 700;"></div>
                        <small>Dans mes classes</small>
                    </div>
                    <i class="fas fa-users"></i>
                </div>
            </div>
        </div>

        <div class="events-profile-section">
            <div class="events-container card">
                <h3>Événements à venir</h3>
                <ul class="events-list">
                    <li>
                        <strong>27 Mars</strong> - Remise de projet Algorithmique
                    </li>
                    <li>
                        <strong>02 Avril</strong> - Examen de Programmation
                    </li>
                </ul>
            </div>

            <div class="profile-card card">
                <div class="profile-avatar">
                    <%= enseignant.getPrenom().charAt(0) %><%= enseignant.getNom().charAt(0) %>
                </div>
                <h4><%= enseignant.getPrenom() %> <%= enseignant.getNom() %></h4>
                <p><%= enseignant.getSpecialite() %></p>
                <p><%= enseignant.getEmail() %></p>
            </div>
        </div>
    </div>
</body>
</html>