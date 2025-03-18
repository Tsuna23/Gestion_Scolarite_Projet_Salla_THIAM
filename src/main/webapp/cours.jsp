<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Enseignant, model.Matiere, dao.EnseignantDAO, java.util.List, java.util.Date, java.text.SimpleDateFormat" %>
<%
// Vérification de la session
Enseignant enseignant = (Enseignant) session.getAttribute("enseignant");

if (enseignant == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Récupérer les cours de l'enseignant
EnseignantDAO enseignantDAO = new EnseignantDAO();
List<Matiere> cours = enseignantDAO.getCoursEnseignant(enseignant.getId());

// Format de la date
SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
String dateActuelle = sdf.format(new Date());

// Vérifier s'il y a un message à afficher
String message = (String) session.getAttribute("message");
String messageType = (String) session.getAttribute("messageType");
// Supprimer le message de la session après l'avoir récupéré
session.removeAttribute("message");
session.removeAttribute("messageType");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Cours</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/enseignant.css">
    <link rel="stylesheet" href="assets/css/cours.css">
    
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
            <a href="enseignantDashboard.jsp">
                <i class="fas fa-tachometer-alt"></i>
                Tableau de bord
            </a>
            <a href="mes-cours.jsp" class="active">
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
                <div class="welcome-text">Mes Cours</div>
                <div class="user-email">Gérez vos cours et matières</div>
            </div>
            <div class="date"><%= dateActuelle %></div>
        </div>
        
        <!-- Affichage des messages de notification -->
        <% if (message != null && !message.isEmpty()) { %>
            <div class="notification notification-<%= messageType %>">
                <i class="fas fa-<%= messageType.equals("success") ? "check-circle" : "exclamation-circle" %>"></i>
                <%= message %>
            </div>
        <% } %>
        
        <% if (cours != null && !cours.isEmpty()) { %>
            <div class="cours-grid">
                <% for (Matiere matiere : cours) { %>
                    <div class="cours-card">
                        <h3><%= matiere.getNom() %></h3>
                        <div class="cours-detail-item">
                            <i class="fas fa-calculator"></i>
                            Coefficient: <%= matiere.getCoefficient() %>
                        </div>
                        
                        <div class="cours-description">
                            <%= matiere.getDescription() %>
                        </div>
                        
                        <div class="cours-actions">
                            <a href="note-etudiant.jsp?matiereId=<%= matiere.getId() %>" class="cours-action-btn">
                                <i class="fas fa-users"></i> Voir les étudiants
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-book"></i>
                <h3>Aucun cours assigné</h3>
                <p>Vous n'avez actuellement aucun cours assigné. Veuillez contacter l'administration pour plus d'informations.</p>
            </div>
        <% } %>
    </div>
</body>
</html>