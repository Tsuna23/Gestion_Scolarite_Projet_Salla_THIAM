<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Administrateur, model.Etudiant, dao.EtudiantDAO, service.MoyenneService, java.util.List, java.util.Date, java.text.SimpleDateFormat" %>
<%
// Vérification de la session
Administrateur admin = (Administrateur) session.getAttribute("admin");

if (admin == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Récupérer la liste des étudiants
EtudiantDAO etudiantDAO = new EtudiantDAO();
List<Etudiant> etudiants = etudiantDAO.getAllEtudiants();

// Service de calcul des moyennes
MoyenneService moyenneService = MoyenneService.getInstance();

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
    <title>Bulletins</title>
    
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/admin.css">
    <link rel="stylesheet" href="assets/css/bulletins.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-graduation-cap me-2"></i> SkillEdge
        </div>
        
        <div class="pt-3">
            <span class="sidebar-heading">Navigation</span>
            <a href="adminDashboard.jsp">
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
            <a href="bulletins.jsp" class="active">
                <i class="fas fa-file-alt me-2"></i>
                <span>Bulletins</span>
            </a>
            <a href="absences.jsp">
                <i class="fas fa-calendar-times me-2"></i>
                <span>Absences</span>
            </a>
            <div class="mt-2">
                <a href="index.jsp" class="btn btn-sm btn-outline-danger w-100">
                    <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
                </a>
            </div>
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
                        <li class="breadcrumb-item"><a href="adminDashboard.jsp">Tableau de bord</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Gestion des bulletins</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Content container -->
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">Gestion des bulletins</h2>
            </div>
            
            <!-- Affichage des messages de notification -->
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-<%= messageType.equals("success") ? "success" : "danger" %> alert-dismissible fade show" role="alert">
                    <i class="fas fa-<%= messageType.equals("success") ? "check-circle" : "exclamation-circle" %> me-2"></i>
                    <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <!-- Filtres -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text bg-light">
                                    <i class="fas fa-search"></i>
                                </span>
                                <input type="text" id="searchInput" class="form-control" placeholder="Rechercher un étudiant...">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select id="filterNiveau" class="form-select">
                                <option value="">Tous les niveaux</option>
                                <option value="Licence 1">Licence 1</option>
                                <option value="Licence 2">Licence 2</option>
                                <option value="Licence 3">Licence 3</option>
                                <option value="Master 1">Master 1</option>
                                <option value="Master 2">Master 2</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <select id="filterFiliere" class="form-select">
                                <option value="">Toutes les filières</option>
                                <option value="Informatique">Informatique</option>
                                <option value="Réseaux">Réseaux</option>
                                <option value="Télécom"></option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Tableau des étudiants -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle" id="studentsTable">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nom</th>
                                    <th>Prénom</th>
                                    <th>Email</th>
                                    <th>Filière</th>
                                    <th>Niveau</th>
                                    <th>Semestre</th>
                                    <th>Moyenne</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (etudiants != null && !etudiants.isEmpty()) { %>
                                    <% for (Etudiant etudiant : etudiants) { %>
                                        <tr>
                                            <td><%= etudiant.getId() %></td>
                                            <td><%= etudiant.getNom() %></td>
                                            <td><%= etudiant.getPrenom() %></td>
                                            <td><%= etudiant.getEmailEcole() %></td>
                                            <td><%= etudiant.getFiliere() %></td>
                                            <td><%= etudiant.getNiveau() %></td>
                                            <td>Semestre 1</td>
                                            <td>
                                                <% 
                                                    // Utiliser MoyenneService pour calculer la moyenne
                                                    double moyenne = moyenneService.calculerMoyenneGenerale(etudiant.getId(), 1);
                                                    String badgeClass = moyenne >= 10 ? "success" : "danger";
                                                %>
                                                <span class="badge bg-<%= badgeClass %> rounded-pill"><%= String.format("%.2f", moyenne) %></span>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-center">
                                                    <a href="GenererBulletinServlet?etudiantId=<%= etudiant.getId() %>&semestre=1" class="btn btn-sm btn-primary" title="Générer bulletin">
                                                        <i class="fas fa-file-word"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="9" class="text-center py-4 text-muted">Aucun étudiant trouvé</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Filtrer les étudiants
        function filterStudents() {
            const searchText = document.getElementById('searchInput').value.toUpperCase();
            const filterNiveau = document.getElementById('filterNiveau').value;
            const filterFiliere = document.getElementById('filterFiliere').value;
            
            const table = document.getElementById('studentsTable');
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) { 
                const cells = rows[i].getElementsByTagName('td');
                
                if (cells.length > 0) {
                    const nomText = cells[1].textContent || cells[1].innerText;
                    const prenomText = cells[2].textContent || cells[2].innerText;
                    const emailText = cells[3].textContent || cells[3].innerText;
                    const filiereText = cells[4].textContent || cells[4].innerText;
                    const niveauText = cells[5].textContent || cells[5].innerText;
                    
                    const matchesSearch = nomText.toUpperCase().includes(searchText) || 
                                         prenomText.toUpperCase().includes(searchText) || 
                                         emailText.toUpperCase().includes(searchText);
                    
                    const matchesNiveau = filterNiveau === "" || niveauText === filterNiveau;
                    const matchesFiliere = filterFiliere === "" || filiereText === filterFiliere;
                    
                    if (matchesSearch && matchesNiveau && matchesFiliere) {
                        rows[i].style.display = "";
                    } else {
                        rows[i].style.display = "none";
                    }
                }
            }
        }
        
        
        document.getElementById('searchInput').addEventListener('keyup', filterStudents);
        document.getElementById('filterNiveau').addEventListener('change', filterStudents);
        document.getElementById('filterFiliere').addEventListener('change', filterStudents);
    </script>
</body>
</html>