<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Enseignant, model.Etudiant, model.Note, dao.EtudiantDAO, dao.NoteDAO, dao.MatiereDAO, model.Matiere, java.util.List, java.util.Date, java.text.SimpleDateFormat" %>
<%
// Vérification de la session
Enseignant enseignant = (Enseignant) session.getAttribute("enseignant");

if (enseignant == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Récupérer la matière enseignée par l'enseignant
MatiereDAO matiereDAO = new MatiereDAO();
int matiereId = matiereDAO.getMatiereIdByEnseignantId(enseignant.getId());
Matiere matiere = matiereDAO.getMatiereById(matiereId);

// Récupérer la liste des étudiants inscrits à cette matière
EtudiantDAO etudiantDAO = new EtudiantDAO();
List<Etudiant> etudiantsInscrits = null;
if (matiere != null) {
    etudiantsInscrits = etudiantDAO.getEtudiantsByMatiereId(matiereId);
}

// Récupérer l'étudiant si l'ID est fourni
int etudiantId = 0;
Etudiant etudiant = null;
List<Note> notes = null;

if (request.getParameter("etudiantId") != null) {
    etudiantId = Integer.parseInt(request.getParameter("etudiantId"));
    etudiant = etudiantDAO.getEtudiantById(etudiantId);
    
    // Récupérer les notes de l'étudiant pour cette matière
    if (etudiant != null && matiere != null) {
        NoteDAO noteDAO = new NoteDAO();
        notes = noteDAO.getNotesByEtudiantAndMatiere(etudiantId, matiereId);
    }
}

// Pour afficher les dates
SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");

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
    <title>Gestion des notes | GestScol</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/enseignant.css">
    <link rel="stylesheet" href="assets/css/note.css">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Style pour les messages de notification */
        .notification {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            animation: fadeOut 5s forwards;
        }
        
        .notification-success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .notification-error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        /* Styles pour les modals */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            overflow: auto;
        }
        
        .modal-content {
            background-color: #fff;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            position: relative;
            animation: modalOpen 0.3s ease;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        
        .modal-header h3 {
            margin: 0;
            color: #333;
        }
        
        .close-modal {
            font-size: 24px;
            cursor: pointer;
            color: #aaa;
            transition: color 0.3s;
        }
        
        .close-modal:hover {
            color: #333;
        }
        
        .modal-footer {
            margin-top: 20px;
            text-align: right;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }
        
        @keyframes fadeOut {
            0% { opacity: 1; }
            80% { opacity: 1; }
            100% { opacity: 0; }
        }
        
        @keyframes modalOpen {
            from { 
                opacity: 0; 
                transform: translateY(-20px);
            }
            to { 
                opacity: 1; 
                transform: translateY(0);
            }
        }
    </style>
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
            <a href="cours.jsp">
                <i class="fas fa-book"></i>
                Mes Cours
            </a>
            <a href="note-etudiant.jsp" class="active">
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
                <div class="welcome-text">Gestion des notes</div>
                <div class="user-email"><%= matiere != null ? matiere.getNom() : "Aucune matière assignée" %></div>
            </div>
            <div class="matiere-info">
                <% if (etudiant != null) { %>
                    <span class="badge"><%= etudiant.getPrenom() %> <%= etudiant.getNom() %></span>
                <% } %>
            </div>
        </div>

        <!-- Affichage des messages de notification -->
        <% if (message != null && !message.isEmpty()) { %>
            <div class="notification notification-<%= messageType %>">
                <i class="fas fa-<%= messageType.equals("success") ? "check-circle" : "exclamation-circle" %>"></i>
                <%= message %>
            </div>
        <% } %>

        <% if (matiere == null) { %>
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                Vous n'avez pas encore de matière assignée. Contactez l'administration.
            </div>
        <% } else if (etudiant == null) { %>
            <div class="card">
                <div class="card-header">
                    <h3>Liste des étudiants</h3>
                    <div class="search-container">
                        <input type="text" id="searchInput" placeholder="Rechercher un étudiant..." onkeyup="searchStudents()">
                        <i class="fas fa-search"></i>
                    </div>
                </div>
                <div class="card-body">
                    <% if (etudiantsInscrits == null || etudiantsInscrits.isEmpty()) { %>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>
                            Aucun étudiant n'est inscrit à votre cours pour le moment.
                        </div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table" id="studentsTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nom</th>
                                        <th>Prénom</th>
                                        <th>Email</th>
                                        <th>Filière</th>
                                        <th>Niveau</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Etudiant etu : etudiantsInscrits) { %>
                                        <tr>
                                            <td><%= etu.getId() %></td>
                                            <td><%= etu.getNom() %></td>
                                            <td><%= etu.getPrenom() %></td>
                                            <td><%= etu.getEmailEcole() %></td>
                                            <td><%= etu.getFiliere() %></td>
                                            <td><%= etu.getNiveau() %></td>
                                            <td>
                                                <a href="note-etudiant.jsp?etudiantId=<%= etu.getId() %>" class="btn-action btn-view">
                                                    <i class="fas fa-chart-line"></i> Noter
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } else { %>
            <!-- Affichage des notes existantes -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3>Notes de <%= etudiant.getPrenom() %> <%= etudiant.getNom() %> - <%= matiere.getNom() %></h3>
                    <a href="note-etudiant.jsp" class="btn-action btn-back">
                        <i class="fas fa-arrow-left"></i> Retour à la liste
                    </a>
                </div>
                <div class="card-body">
                    <% if (notes == null || notes.isEmpty()) { %>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>
                            Aucune note enregistrée pour cet étudiant dans cette matière.
                        </div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Type d'évaluation</th>
                                        <th>Note</th>
                                        <th>Date</th>
                                        <th>Semestre</th>
                                        <th>Commentaire</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Note note : notes) { %>
                                        <tr>
                                            <td><%= note.getTypeEvaluation() %></td>
                                            <td class="<%= note.getValeur() >= 10 ? "text-success" : "text-danger" %>">
                                                <strong><%= note.getValeur() %>/20</strong>
                                            </td>
                                            <td><%= dateFormat.format(note.getDateEvaluation()) %></td>
                                            <td>Semestre <%= note.getSemestre() %></td>
                                            <td><%= note.getCommentaire() != null ? note.getCommentaire() : "-" %></td>
                                            <td>
                                                <button class="btn-action btn-edit" onclick="showEditModal(<%= note.getId() %>)">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn-action btn-delete" onclick="showDeleteModal(<%= note.getId() %>)">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Bouton pour ajouter une nouvelle note -->
            <div class="card">
                <div class="card-header">
                    <h3>Ajouter une note</h3>
                </div>
                <div class="card-body">
                    <p>Cliquez sur le bouton ci-dessous pour ajouter une nouvelle note pour cet étudiant.</p>
                    <button onclick="showAddModal()" class="btn-primary">
                        <i class="fas fa-plus-circle"></i> Ajouter une note
                    </button>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Modal pour ajouter une note -->
    <div id="addNoteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Ajouter une note</h3>
                <span class="close-modal" onclick="closeModal('addNoteModal')">&times;</span>
            </div>
            <form id="addNoteForm" action="AjouterNoteServlet" method="post">
                <input type="hidden" name="etudiantId" value="<%= etudiantId %>">
                <input type="hidden" name="matiereId" value="<%= matiereId %>">
                
                <div class="form-group">
                    <label for="addTypeEvaluation">Type d'évaluation</label>
                    <select id="addTypeEvaluation" name="typeEvaluation" class="form-control" required>
                        <option value="">-- Sélectionnez --</option>
                        <option value="Examen">Examen</option>
                        <option value="Contrôle continu">Contrôle continu</option>
                        <option value="Projet">Projet</option>
                        <option value="TP">TP</option>
                        <option value="TD">TD</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="addValeur">Note (sur 20)</label>
                    <input type="number" id="addValeur" name="valeur" class="form-control" min="0" max="20" step="0.5" required>
                </div>
                
                <div class="form-group">
                    <label for="addDateEvaluation">Date d'évaluation</label>
                    <input type="date" id="addDateEvaluation" name="dateEvaluation" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="addSemestre">Semestre</label>
                    <select id="addSemestre" name="semestre" class="form-control" required>
                        <option value="1">Semestre 1</option>
                        <option value="2">Semestre 2</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="addCommentaire">Commentaire (optionnel)</label>
                    <textarea id="addCommentaire" name="commentaire" class="form-control" rows="3"></textarea>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-action btn-back" onclick="closeModal('addNoteModal')">Annuler</button>
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-plus-circle"></i> Ajouter
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal pour modifier une note -->
    <div id="editNoteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Modifier la note</h3>
                <span class="close-modal" onclick="closeModal('editNoteModal')">&times;</span>
            </div>
            <form id="editNoteForm" action="ModifierNoteServlet" method="post">
                <input type="hidden" id="editNoteId" name="noteId" value="">
                <input type="hidden" name="etudiantId" value="<%= etudiantId %>">
                <input type="hidden" name="matiereId" value="<%= matiereId %>">
                
                <div class="form-group">
                    <label for="editTypeEvaluation">Type d'évaluation</label>
                    <select id="editTypeEvaluation" name="typeEvaluation" class="form-control" required>
                        <option value="">-- Sélectionnez --</option>
                        <option value="Examen">Examen</option>
                        <option value="Contrôle continu">Contrôle continu</option>
                        <option value="Projet">Projet</option>
                        <option value="TP">TP</option>
                        <option value="TD">TD</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="editValeur">Note (sur 20)</label>
                    <input type="number" id="editValeur" name="valeur" class="form-control" min="0" max="20" step="0.5" required>
                </div>
                
                <div class="form-group">
                    <label for="editDateEvaluation">Date d'évaluation</label>
                    <input type="date" id="editDateEvaluation" name="dateEvaluation" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="editSemestre">Semestre</label>
                    <select id="editSemestre" name="semestre" class="form-control" required>
                        <option value="1">Semestre 1</option>
                        <option value="2">Semestre 2</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="editCommentaire">Commentaire (optionnel)</label>
                    <textarea id="editCommentaire" name="commentaire" class="form-control" rows="3"></textarea>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-action btn-back" onclick="closeModal('editNoteModal')">Annuler</button>
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal de confirmation de suppression -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Confirmation de suppression</h3>
                <span class="close-modal" onclick="closeModal('deleteModal')">&times;</span>
            </div>
            <p>Êtes-vous sûr de vouloir supprimer cette note ? Cette action est irréversible.</p>
            <div class="modal-footer">
                <button class="btn-action btn-back" onclick="closeModal('deleteModal')">Annuler</button>
                <button class="btn-action btn-delete" id="confirmDeleteBtn">Supprimer</button>
            </div>
        </div>
    </div>

    <script>
    // Rechercher étudiants par nom et prénom
    function searchStudents() {
        var input, filter, table, tr, td, i, txtValue;
        input = document.getElementById("searchInput");
        filter = input.value.toUpperCase();
        table = document.getElementById("studentsTable");
        tr = table.getElementsByTagName("tr");
        
        for (i = 0; i < tr.length; i++) {
            if (i === 0) continue;
            
            var nameCell = tr[i].getElementsByTagName("td")[1];
            var firstnameCell = tr[i].getElementsByTagName("td")[2];
            var emailCell = tr[i].getElementsByTagName("td")[3];
            
            if (nameCell && firstnameCell && emailCell) {
                var nameValue = nameCell.textContent || nameCell.innerText;
                var firstnameValue = firstnameCell.textContent || firstnameCell.innerText;
                var emailValue = emailCell.textContent || emailCell.innerText;
                
                if (nameValue.toUpperCase().indexOf(filter) > -1 || 
                    firstnameValue.toUpperCase().indexOf(filter) > -1 ||
                    emailValue.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }
    
    // Afficher le modal d'ajout de note
    function showAddModal() {
        document.getElementById("addNoteModal").style.display = "block";
        // Définir la date d'aujourd'hui par défaut
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); // Janvier est 0!
        var yyyy = today.getFullYear();
        
        today = yyyy + '-' + mm + '-' + dd;
        document.getElementById("addDateEvaluation").value = today;
    }
    
    // Afficher le modal de modification de note avec les données de la note
    function showEditModal(noteId) {
        // Récupérer les données de la note
        var notes = <%= notes != null ? "[" + notes.stream().map(note -> 
            "{id:" + note.getId() + 
            ", typeEvaluation:'" + note.getTypeEvaluation() + 
            "', valeur:" + note.getValeur() + 
            ", dateEvaluation:'" + inputDateFormat.format(note.getDateEvaluation()) + 
            "', semestre:" + note.getSemestre() + 
            ", commentaire:" + (note.getCommentaire() != null ? "'" + note.getCommentaire().replace("'", "\\'") + "'" : "null") + 
            "}"
        ).collect(java.util.stream.Collectors.joining(",")) + "]" : "[]" %>;
        
        var noteToEdit = notes.find(note => note.id === noteId);
        if (noteToEdit) {
            // Remplir les champs du formulaire
            document.getElementById("editNoteId").value = noteToEdit.id;
            document.getElementById("editTypeEvaluation").value = noteToEdit.typeEvaluation;
            document.getElementById("editValeur").value = noteToEdit.valeur;
            document.getElementById("editDateEvaluation").value = noteToEdit.dateEvaluation;
            document.getElementById("editSemestre").value = noteToEdit.semestre;
            document.getElementById("editCommentaire").value = noteToEdit.commentaire || "";
            
            // Afficher le modal
            document.getElementById("editNoteModal").style.display = "block";
        }
    }
    
    // Afficher le modal de confirmation de suppression
    function showDeleteModal(noteId) {
        var modal = document.getElementById("deleteModal");
        var confirmDeleteBtn = document.getElementById("confirmDeleteBtn");
        
        modal.style.display = "block";
        confirmDeleteBtn.onclick = function() {
            window.location.href = "SupprimerNoteServlet?noteId=" + noteId + "&etudiantId=<%= etudiantId %>";
        };
    }
    
    // Fermer un modal spécifique
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = "none";
    }
    
    // Fermer les modals si l'utilisateur clique en dehors
    window.onclick = function(event) {
        var modals = document.getElementsByClassName("modal");
        for (var i = 0; i < modals.length; i++) {
            if (event.target == modals[i]) {
                modals[i].style.display = "none";
            }
        }
    };
    </script>
</body>
</html>