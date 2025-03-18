<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Administrateur, model.Enseignant, dao.EnseignantDAO, model.Matiere, dao.MatiereDAO, java.util.List" %>
<%
    Administrateur admin = (Administrateur) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Récupérer toutes les matières disponibles
    MatiereDAO matiereDAO = new MatiereDAO();
    List<Matiere> matieres = matiereDAO.getAllMatieres();

    // Vérifier si nous sommes en mode édition ou ajout
    String mode = "ajout";
    String enseignantId = request.getParameter("id");
    
    // Déclaration de la variable pour stocker l'enseignant à modifier
    Enseignant enseignantToEdit = null;
    
    if (enseignantId != null && !enseignantId.isEmpty()) {
        mode = "edition";
        // Récupérer les données de l'enseignant pour pré-remplir le formulaire
        EnseignantDAO enseignantDAO = new EnseignantDAO();
        enseignantToEdit = enseignantDAO.getEnseignantById(Integer.parseInt(enseignantId));
        
        // Si l'enseignant n'existe pas, rediriger vers la liste
        if (enseignantToEdit == null) {
            response.sendRedirect("enseignants.jsp?error=notfound");
            return;
        }
        
        // Nous supprimons cette partie car la méthode n'existe pas encore
        // matiereAssocieeId = enseignantDAO.getMatiereIdByEnseignantId(Integer.parseInt(enseignantId));
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= mode.equals("ajout") ? "Ajouter un enseignant" : "Modifier un enseignant" %></title>

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
            <a href="etudiants.jsp">
                <i class="fas fa-user-graduate me-2"></i>
                <span>Étudiants</span>
            </a>
            <a href="enseignants.jsp" class="active">
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
                        <li class="breadcrumb-item"><a href="enseignants.jsp">Gestion des enseignants</a></li>
                        <li class="breadcrumb-item active" aria-current="page"><%= mode.equals("ajout") ? "Ajouter un enseignant" : "Modifier un enseignant" %></li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Form content -->
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-chalkboard-teacher me-2"></i>
                                <%= mode.equals("ajout") ? "Ajouter un nouvel enseignant" : "Modifier les informations de l'enseignant" %>
                            </h5>
                        </div>
                        <div class="card-body">
                            <form action="EnseignantServlet" method="post" id="teacherForm">
                                <% if (mode.equals("edition")) { %>
                                <input type="hidden" name="id" value="<%= enseignantId %>">
                                <input type="hidden" name="action" value="update">
                                <% } else { %>
                                <input type="hidden" name="action" value="add">
                                <% } %>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="nom" class="form-label">Nom <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="nom" name="nom" 
                                               value="<%= mode.equals("edition") ? enseignantToEdit.getNom() : "" %>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="prenom" class="form-label">Prénom <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="prenom" name="prenom" 
                                               value="<%= mode.equals("edition") ? enseignantToEdit.getPrenom() : "" %>" required>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="<%= mode.equals("edition") ? enseignantToEdit.getEmail() : "" %>" required>
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
                                        <label for="specialite" class="form-label">Spécialité <span class="text-danger">*</span></label>
                                        <select class="form-select" id="specialite" name="specialite" required>
                                            <option value="" disabled <%= mode.equals("ajout") ? "selected" : "" %>>Sélectionner une spécialité</option>
                                            <option value="Informatique" <%= mode.equals("edition") && "Informatique".equals(enseignantToEdit.getSpecialite()) ? "selected" : "" %>>Informatique</option>
                                            <option value="Réseaux" <%= mode.equals("edition") && "Réseaux".equals(enseignantToEdit.getSpecialite()) ? "selected" : "" %>>Réseaux</option>
                                            <option value="Télécommunications" <%= mode.equals("edition") && "Télécommunications".equals(enseignantToEdit.getSpecialite()) ? "selected" : "" %>>Télécommunications</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="matiere" class="form-label">Matière enseignée <span class="text-danger">*</span></label>
                                        <select class="form-select" id="matiere" name="matiere_id" required>
                                            <option value="" disabled <%= mode.equals("ajout") ? "selected" : "" %>>Sélectionner une matière</option>
                                            <% for (Matiere matiere : matieres) { %>
                                                <option value="<%= matiere.getId() %>">
                                                    <%= matiere.getNom() %>
                                                </option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="d-flex justify-content-between mt-4">
                                    <a href="enseignants.jsp" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Retour
                                    </a>
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-save me-2"></i><%= mode.equals("ajout") ? "Ajouter l'enseignant" : "Mettre à jour" %>
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