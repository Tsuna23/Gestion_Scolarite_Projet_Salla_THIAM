<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Administrateur" %>
<%@ page import="model.Absence" %>
<%@ page import="model.Etudiant" %>
<%@ page import="model.Matiere" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.AbsenceDAO" %>
<%@ page import="dao.EtudiantDAO" %>
<%@ page import="dao.MatiereDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Administrateur admin = (Administrateur) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Récupérer la liste des absences
    AbsenceDAO absenceDAO = new AbsenceDAO();
    List<Absence> absences = absenceDAO.getAllAbsences();
    
    // Récupérer la liste des étudiants pour le formulaire d'ajout
    EtudiantDAO etudiantDAO = new EtudiantDAO();
    List<Etudiant> etudiants = etudiantDAO.getAllEtudiants();
    
    // Récupérer la liste des matières pour le formulaire d'ajout
    MatiereDAO matiereDAO = new MatiereDAO();
    List<Matiere> matieres = matiereDAO.getAllMatieres();
    
    // Format pour afficher les dates
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Absences </title>
    <link rel="stylesheet" href="assets/css/admin.css">
    
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
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
            <a href="bulletins.jsp">
                <i class="fas fa-file-alt me-2"></i>
                <span>Bulletins</span>
            </a>
            <a href="absences.jsp" class="active">
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
                        <li class="breadcrumb-item active" aria-current="page">Absences</li>
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

        <!-- Content -->
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestion des Absences</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#ajouterAbsenceModal">
                    <i class="fas fa-plus me-2"></i>Nouvelle Absence
                </button>
            </div>
            
            <!-- Suppression des alertes de succès ou d'erreur -->
            
            <!-- Liste des absences -->
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h5 class="card-title mb-0">Liste des absences</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="absencesTable" class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Étudiant</th>
                                    <th>Date</th>
                                    <th>Matière</th>
                                    <th>Justifiée</th>
                                    <th>Motif</th>
                                    <th>Commentaire</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (absences != null && !absences.isEmpty()) { 
                                    for (Absence absence : absences) { 
                                        Etudiant etudiant = etudiantDAO.getEtudiantById(absence.getEtudiantId());
                                        Matiere matiere = matiereDAO.getMatiereById(absence.getMatiereId());
                                        String nomComplet = (etudiant != null) ? etudiant.getPrenom() + " " + etudiant.getNom() : "Étudiant inconnu";
                                        String nomMatiere = (matiere != null) ? matiere.getNom() : "Matière inconnue";
                                %>
                                <tr>
                                    <td><%= absence.getId() %></td>
                                    <td><%= nomComplet %></td>
                                    <td><%= sdf.format(absence.getDate()) %></td>
                                    <td><%= nomMatiere %></td>
                                    <td>
                                        <% if (absence.isJustifiee()) { %>
                                            <span class="badge bg-success">Oui</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Non</span>
                                        <% } %>
                                    </td>
                                    <td><%= absence.getMotif() != null ? absence.getMotif() : "" %></td>
                                    <td><%= absence.getCommentaire() != null ? absence.getCommentaire() : "" %></td>
                                    <td>
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-sm btn-outline-primary" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#modifierAbsenceModal"
                                                    data-id="<%= absence.getId() %>"
                                                    data-etudiant="<%= absence.getEtudiantId() %>"
                                                    data-matiere="<%= absence.getMatiereId() %>"
                                                    data-date="<%= absence.getDate().getTime() %>"
                                                    data-justifiee="<%= absence.isJustifiee() %>"
                                                    data-motif="<%= absence.getMotif() != null ? absence.getMotif() : "" %>"
                                                    data-commentaire="<%= absence.getCommentaire() != null ? absence.getCommentaire() : "" %>">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#supprimerAbsenceModal"
                                                    data-id="<%= absence.getId() %>">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="8" class="text-center">Aucune absence enregistrée</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Ajouter Absence -->
    <div class="modal fade" id="ajouterAbsenceModal" tabindex="-1" aria-labelledby="ajouterAbsenceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ajouterAbsenceModalLabel">Ajouter une absence</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="AbsenceServlet" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label for="etudiantId" class="form-label">Étudiant</label>
                            <select class="form-select" id="etudiantId" name="etudiantId" required>
                                <option value="">Sélectionner un étudiant</option>
                                <% if (etudiants != null && !etudiants.isEmpty()) {
                                    for (Etudiant etudiant : etudiants) { %>
                                <option value="<%= etudiant.getId() %>"><%= etudiant.getPrenom() %> <%= etudiant.getNom() %></option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="date" class="form-label">Date</label>
                            <input type="date" class="form-control" id="date" name="date" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="matiereId" class="form-label">Matière</label>
                            <select class="form-select" id="matiereId" name="matiereId" required>
                                <option value="">Sélectionner une matière</option>
                                <% if (matieres != null && !matieres.isEmpty()) {
                                    for (Matiere matiere : matieres) { %>
                                <option value="<%= matiere.getId() %>"><%= matiere.getNom() %></option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="justifiee" name="justifiee">
                            <label class="form-check-label" for="justifiee">Absence justifiée</label>
                        </div>
                        
                        <div class="mb-3">
                            <label for="motif" class="form-label">Motif</label>
                            <input type="text" class="form-control" id="motif" name="motif">
                        </div>
                        
                        <div class="mb-3">
                            <label for="commentaire" class="form-label">Commentaire</label>
                            <textarea class="form-control" id="commentaire" name="commentaire" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Modal Modifier Absence -->
    <div class="modal fade" id="modifierAbsenceModal" tabindex="-1" aria-labelledby="modifierAbsenceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modifierAbsenceModalLabel">Modifier une absence</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="AbsenceServlet" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="edit-id">
                        
                        <div class="mb-3">
                            <label for="edit-etudiantId" class="form-label">Étudiant</label>
                            <select class="form-select" id="edit-etudiantId" name="etudiantId" required>
                                <option value="">Sélectionner un étudiant</option>
                                <% if (etudiants != null && !etudiants.isEmpty()) {
                                    for (Etudiant etudiant : etudiants) { %>
                                <option value="<%= etudiant.getId() %>"><%= etudiant.getPrenom() %> <%= etudiant.getNom() %></option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit-date" class="form-label">Date</label>
                            <input type="date" class="form-control" id="edit-date" name="date" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit-matiereId" class="form-label">Matière</label>
                            <select class="form-select" id="edit-matiereId" name="matiereId" required>
                                <option value="">Sélectionner une matière</option>
                                <% if (matieres != null && !matieres.isEmpty()) {
                                    for (Matiere matiere : matieres) { %>
                                <option value="<%= matiere.getId() %>"><%= matiere.getNom() %></option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="edit-justifiee" name="justifiee">
                            <label class="form-check-label" for="edit-justifiee">Absence justifiée</label>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit-motif" class="form-label">Motif</label>
                            <input type="text" class="form-control" id="edit-motif" name="motif">
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit-commentaire" class="form-label">Commentaire</label>
                            <textarea class="form-control" id="edit-commentaire" name="commentaire" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Modal Supprimer Absence -->
    <div class="modal fade" id="supprimerAbsenceModal" tabindex="-1" aria-labelledby="supprimerAbsenceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="supprimerAbsenceModalLabel">Confirmer la suppression</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir supprimer cette absence ?</p>
                    <p class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i>Cette action est irréversible.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <form action="AbsenceServlet" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="delete-id">
                        <button type="submit" class="btn btn-danger">Supprimer</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
           
            $.fn.dataTable.ext.errMode = 'none';
            
            
            $('#absencesTable').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.4/i18n/fr-FR.json'
                },
                order: [[0, 'desc']],
                dom: 't<"bottom"lip>' 
            });
            
            // Gestion du modal de modification
            $('#modifierAbsenceModal').on('show.bs.modal', function (event) {
                var button = $(event.relatedTarget);
                var id = button.data('id');
                var etudiantId = button.data('etudiant');
                var matiereId = button.data('matiere');
                var date = new Date(button.data('date')).toISOString().split('T')[0];
                var justifiee = button.data('justifiee');
                var motif = button.data('motif');
                var commentaire = button.data('commentaire');
                
                var modal = $(this);
                modal.find('#edit-id').val(id);
                modal.find('#edit-etudiantId').val(etudiantId);
                modal.find('#edit-matiereId').val(matiereId);
                modal.find('#edit-date').val(date);
                modal.find('#edit-justifiee').prop('checked', justifiee);
                modal.find('#edit-motif').val(motif);
                modal.find('#edit-commentaire').val(commentaire);
            });
            
            // Gestion du modal de suppression
            $('#supprimerAbsenceModal').on('show.bs.modal', function (event) {
                var button = $(event.relatedTarget);
                var id = button.data('id');
                var modal = $(this);
                modal.find('#delete-id').val(id);
            });
        });
    </script>
</body>
</html>