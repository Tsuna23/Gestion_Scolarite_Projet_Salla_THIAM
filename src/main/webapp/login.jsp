<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion </title>
    
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/login.css">
</head>
<body>
    <div class="container">
        <div class="logo">
            <i class="fas fa-graduation-cap" style="font-size: 3rem; color: #ff6b4a;"></i>
        </div>
        
        <h2>Connexion à SkillEdge</h2>
        
        <%-- Affichage d'un message d'erreur si la connexion échoue --%>
        <% if (request.getParameter("error") != null) { %>
            <p class="error">
                <i class="fas fa-exclamation-circle"></i>
                Identifiants incorrects. Veuillez réessayer.
            </p>
        <% } %>
        
        <form action="LoginServlet" method="post">
            <label for="email">Email institutionnel</label>
            <input type="email" id="email" name="email_ecole" placeholder="exemple@etu.sn" required>
            
            <label for="password">Mot de passe</label>
            <input type="password" id="password" name="mot_de_passe" placeholder="••••••••" required>
            
            <button type="submit">
                <i class="fas fa-sign-in-alt me-2"></i>
                Se connecter
            </button>
        </form>
        
        <p>Pas encore inscrit ? <a href="Inscription.jsp">Créer un compte</a></p>
    </div>
</body>
</html>