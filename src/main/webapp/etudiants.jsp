<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Administrateur, model.Etudiant, dao.EtudiantDAO, java.util.List, java.util.ArrayList" %>
<%
    Administrateur admin = (Administrateur) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Récupérer tous les étudiants
    EtudiantDAO etudiantDAO = new EtudiantDAO();
    List<Etudiant> etudiants = etudiantDAO.getAllEtudiants();
    
    // Si getAllEtudiants() n'est pas encore implémenté, vous pouvez initialiser une liste vide
    // pour éviter les erreurs de compilation
    if (etudiants == null) {
        etudiants = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Étudiants</title>
    
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/admin.css">
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
            <a href="etudiants.jsp" class="active">
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
            <div class="d-flex justify-content-between align-items-center">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="adminDashboard.jsp">Tableau de bord</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Gestion des étudiants</li>
                    </ol>
                </nav>
                <div class="d-flex align-items-center">
                    <div class="dropdown me-3">
                        <button class="btn btn-link text-dark position-relative" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-bell"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                0
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
        </div>

        <!-- Students content -->
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestion des étudiants</h2>
                <a href="etudiant-form.jsp" class="btn btn-primary">
                    <i class="fas fa-user-plus me-2"></i>Ajouter un étudiant
                </a>
            </div>
            
            <!-- Search and filters -->
            <div class="card mb-4">
                <div class="card-body">
                    <form class="row g-3">
                        <div class="col-md-4">
                            <label for="searchName" class="form-label">Recherche par nom</label>
                            <input type="text" class="form-control" id="searchName" placeholder="Nom ou prénom...">
                        </div>
                        <div class="col-md-3">
                            <label for="filterFiliere" class="form-label">Filière</label>
                            <select class="form-select" id="filterFiliere">
                                <option value="" selected>Toutes les filières</option>
                                <option value="Informatique">Informatique</option>
                                <option value="Réseaux">Réseaux</option>
                                <option value="Télécommunications">Télécommunications</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="filterNiveau" class="form-label">Niveau</label>
                            <select class="form-select" id="filterNiveau">
                                <option value="" selected>Tous les niveaux</option>
                                <option value="Licence 1">Licence 1</option>
                                <option value="Licence 2">Licence 2</option>
                                <option value="Licence 3">Licence 3</option>
                                <option value="Master 1">Master 1</option>
                                <option value="Master 2">Master 2</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-2"></i>Rechercher
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Students table -->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Nom</th>
                                    <th scope="col">Prénom</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Filière</th>
                                    <th scope="col">Niveau</th>
                                    <th scope="col">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (etudiants == null || etudiants.isEmpty()) { %>
                                    <tr>
                                        <td colspan="7" class="text-center py-4">Aucun étudiant enregistré</td>
                                    </tr>
                                <% } else { %>
                                    <% for (Etudiant etudiant : etudiants) { %>
                                        <tr>
                                            <td><%= etudiant.getId() %></td>
                                            <td><%= etudiant.getNom() %></td>
                                            <td><%= etudiant.getPrenom() %></td>
                                            <td><%= etudiant.getEmailEcole() != null ? etudiant.getEmailEcole() : etudiant.getEmailPersonnel() %></td>
                                            <td><%= etudiant.getFiliere() %></td>
                                            <td><%= etudiant.getNiveau() %></td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <a href="etudiant-form.jsp?id=<%= etudiant.getId() %>" class="btn btn-sm btn-primary">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger" 
                                                            onclick="confirmerSuppression(<%= etudiant.getId() %>, '<%= etudiant.getNom() %> <%= etudiant.getPrenom() %>')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de confirmation de suppression -->
    <div class="modal fade" id="suppressionModal" tabindex="-1" aria-labelledby="suppressionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="suppressionModalLabel">Confirmer la suppression</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir supprimer l'étudiant <span id="nomEtudiant"></span> ?</p>
                    <p class="text-danger">Cette action est irréversible.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <form action="EtudiantServlet" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="idEtudiantToDelete">
                        <button type="submit" class="btn btn-danger">Supprimer</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script pour la suppression -->
    <script>
        function confirmerSuppression(id, nom) {
            document.getElementById('idEtudiantToDelete').value = id;
            document.getElementById('nomEtudiant').textContent = nom;
            var myModal = new bootstrap.Modal(document.getElementById('suppressionModal'));
            myModal.show();
        }
    </script>
</body>
</html>