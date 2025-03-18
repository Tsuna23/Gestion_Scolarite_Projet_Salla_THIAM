<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Étudiant </title>
    
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/inscription.css">
</head>
<body>
    <div class="container">
        <div class="logo">
            <i class="fas fa-graduation-cap"></i>
        </div>
        
        <h2>Inscription Étudiant</h2>
        
        <%-- Affichage d'un message d'erreur si la connexion échoue --%>
        <% if (request.getParameter("error") != null) { %>
            <div class="error">
                <i class="fas fa-exclamation-circle"></i>
                Une erreur est survenue. Veuillez réessayer.
            </div>
        <% } %>
        
        <form action="InscriptionServlet" method="post">
            <div class="form-group">
                <label for="nom">Nom</label>
                <input type="text" id="nom" name="nom" placeholder="Votre nom" required>
            </div>
            
            <div class="form-group">
                <label for="prenom">Prénom</label>
                <input type="text" id="prenom" name="prenom" placeholder="Votre prénom" required>
            </div>
            
            <div class="form-group">
                <label for="email_personnel">Email Personnel</label>
                <input type="email" id="email_personnel" name="email_personnel" placeholder="exemple@email.com" required>
            </div>
            
            <div class="form-group">
                <label for="mot_de_passe">Mot de passe</label>
                <input type="password" id="mot_de_passe" name="mot_de_passe" placeholder="Choisissez un mot de passe sécurisé" required>
            </div>
            
            <div class="form-group">
                <label for="filiere">Filière</label>
                <select id="filiere" name="filiere" required>
                    <option value="" disabled selected>Sélectionnez votre filière</option>
                    <option value="Informatique">Informatique</option>
                    <option value="Réseaux">Réseaux</option>
                    <option value="Télécommunications">Télécommunications</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="niveau">Niveau</label>
                <select id="niveau" name="niveau" required>
                    <option value="" disabled selected>Sélectionnez votre niveau</option>
                    <option value="1">Licence 1</option>
                    <option value="2">Licence 2</option>
                    <option value="3">Licence 3</option>
                    <option value="4">Master 1</option>
                    <option value="5">Master 2</option>
                </select>
            </div>
            
            <button type="submit">
                <i class="fas fa-user-plus"></i>
                S'inscrire
            </button>
        </form>
        
        <p>Déjà inscrit ? <a href="login.jsp">Se connecter</a></p>
    </div>
</body>
</html>