<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Administrateur, model.Etudiant, dao.EtudiantDAO" %>
<%
    Administrateur admin = (Administrateur) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Vérifier si nous sommes en mode édition ou ajout
    String mode = "ajout";
    String etudiantId = request.getParameter("id");
    
    // Déclaration de la variable pour stocker l'étudiant à modifier
    Etudiant etudiantToEdit = null;
    
    if (etudiantId != null && !etudiantId.isEmpty()) {
        mode = "edition";
        // Récupérer les données de l'étudiant pour pré-remplir le formulaire
        EtudiantDAO etudiantDAO = new EtudiantDAO();
        etudiantToEdit = etudiantDAO.getEtudiantById(Integer.parseInt(etudiantId));
        
        // Si l'étudiant n'existe pas, rediriger vers la liste
        if (etudiantToEdit == null) {
            response.sendRedirect("etudiants.jsp?error=notfound");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= mode.equals("ajout") ? "Ajouter un étudiant" : "Modifier un étudiant" %></title>

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
            <i class="fas fa-graduation-cap me-2"></i> GestScol
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
            <a href="emplois.jsp">
                <i class="fas fa-calendar-alt me-2"></i>
                <span>Emplois du temps</span>
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
                <a href="LogoutServlet" class="btn btn-sm btn-outline-danger w-100">
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
                        <li class="breadcrumb-item"><a href="etudiants.jsp">Gestion des étudiants</a></li>
                        <li class="breadcrumb-item active" aria-current="page"><%= mode.equals("ajout") ? "Ajouter un étudiant" : "Modifier un étudiant" %></li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Form content -->
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-user-graduate me-2"></i>
                                <%= mode.equals("ajout") ? "Ajouter un nouvel étudiant" : "Modifier les informations de l'étudiant" %>
                            </h5>
                        </div>
                        <div class="card-body">
                            <form action="EtudiantServlet" method="post" id="studentForm">
                                <% if (mode.equals("edition")) { %>
                                <input type="hidden" name="id" value="<%= etudiantId %>">
                                <input type="hidden" name="action" value="update">
                                <% } else { %>
                                <input type="hidden" name="action" value="add">
                                <% } %>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="nom" class="form-label">Nom <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="nom" name="nom" 
                                               value="<%= mode.equals("edition") ? etudiantToEdit.getNom() : "" %>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="prenom" class="form-label">Prénom <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="prenom" name="prenom" 
                                               value="<%= mode.equals("edition") ? etudiantToEdit.getPrenom() : "" %>" required>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="email_personnel" class="form-label">Email personnel <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="email_personnel" name="email_personnel" 
                                               value="<%= mode.equals("edition") ? etudiantToEdit.getEmailPersonnel() : "" %>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="mot_de_passe" class="form-label">Mot de passe <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="mot_de_passe" name="mot_de_passe" 
                                               <%= mode.equals("ajout") ? "required" : "" %>>
                                        <% if (mode.equals("edition")) { %>
                                        <div class="form-text">Laissez vide pour conserver le mot de passe actuel.</div>
                                        <% } %>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="filiere" class="form-label">Filière <span class="text-danger">*</span></label>
                                        <select class="form-select" id="filiere" name="filiere" required>
                                            <option value="" disabled>Sélectionner une filière</option>
                                            <option value="Informatique" <%= mode.equals("edition") && "Informatique".equals(etudiantToEdit.getFiliere()) ? "selected" : "" %>>Informatique</option>
                                            <option value="Réseaux" <%= mode.equals("edition") && "Réseaux".equals(etudiantToEdit.getFiliere()) ? "selected" : "" %>>Réseaux</option>
                                            <option value="Télécommunications" <%= mode.equals("edition") && "Télécommunications".equals(etudiantToEdit.getFiliere()) ? "selected" : "" %>>Télécommunications</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="niveau" class="form-label">Niveau <span class="text-danger">*</span></label>
                                        <select class="form-select" id="niveau" name="niveau" required>
                                            <option value="" disabled>Sélectionner un niveau</option>
                                            <option value="Licence 1" <%= mode.equals("edition") && "Licence 1".equals(etudiantToEdit.getNiveau()) ? "selected" : "" %>>Licence 1</option>
                                            <option value="Licence 2" <%= mode.equals("edition") && "Licence 2".equals(etudiantToEdit.getNiveau()) ? "selected" : "" %>>Licence 2</option>
                                            <option value="Licence 3" <%= mode.equals("edition") && "Licence 3".equals(etudiantToEdit.getNiveau()) ? "selected" : "" %>>Licence 3</option>
                                            <option value="Master 1" <%= mode.equals("edition") && "Master 1".equals(etudiantToEdit.getNiveau()) ? "selected" : "" %>>Master 1</option>
                                            <option value="Master 2" <%= mode.equals("edition") && "Master 2".equals(etudiantToEdit.getNiveau()) ? "selected" : "" %>>Master 2</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="d-flex justify-content-between mt-4">
                                    <a href="etudiants.jsp" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Retour
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i><%= mode.equals("ajout") ? "Ajouter l'étudiant" : "Mettre à jour" %>
                                    </button>
                                </div>
                            </form>
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