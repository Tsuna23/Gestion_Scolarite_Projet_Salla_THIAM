<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillEdge</title>
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- En-tête -->
    <header>
        <div class="container header-container">
            <div class="logo">
                <a href="#"><span class="logo-edu">Skill</span><span class="logo-lerns">Edge</span></a>
            </div>
            <nav class="main-nav">
                <ul>
                    <li><a href="index.jsp" class="active">Accueil</a></li>
                    <li><a href="#features-section">Fonctionnalités</a></li>
                     <li><a href="#courses">Formations</a></li>
                      <li><a href="#categories">Services</a></li>
                    <li><a href="#prof">Équipe pédagogique</a></li>
                    <li><a href="#contact">Contact</a></li>
                </ul>
            </nav>
            <div class="nav-icons">
                <a href="Inscription.jsp" class="btn btn-primary">Inscription en ligne</a>
            </div>
        </div>
    </header>

    <!-- Bannière principale -->
    <section class="hero-section">
        <div class="container hero-container">
            <div class="hero-content">
                <p class="subtitle">Gestion simplifiée de votre parcours scolaire</p>
                <h1>Bienvenue à <span class="highlight">Skill</span>Edge</h1>
                <p class="hero-text">La solution complète pour la gestion de votre scolarité</p>
                <a href="login.jsp" class="btn btn-primary">Votre Espace</a>
            </div>
            <div class="hero-image">
                <img src="assets/images/student4.png" alt="photo">
            </div>
        </div>
        <div class="shape circle-orange"></div>
        <div class="shape circle-purple"></div>
        <div class="shape circle-blue"></div>
    </section>

    <!-- Section Fonctionnalités -->
    <section class="features-section" id="features-section">
        <div class="container">
            <h2>Une gestion scolaire efficace où que vous soyez</h2>
            <div class="features-grid">
                <div class="feature-item">
                    <div class="feature-icon red">
                        <i class="fas fa-laptop"></i>
                    </div>
                    <h3>Suivi des notes</h3>
                </div>
                <div class="feature-item">
                    <div class="feature-icon purple">
                        <i class="fas fa-globe"></i>
                    </div>
                    <h3>Accès à distance</h3>
                </div>
                <div class="feature-item">
                    <div class="feature-icon orange">
                        <i class="fas fa-certificate"></i>
                    </div>
                    <h3>Gestion des diplômes</h3>
                </div>
                <div class="feature-item">
                    <div class="feature-icon blue">
                        <i class="fas fa-bullhorn"></i>
                    </div>
                    <h3>Communication directe</h3>
                </div>
            </div>
          
        </div>
    </section>

    <!-- Section Cours Populaires -->
    <section class="popular-courses-section" id="courses">
        <div class="container">
            <h2>Nos Formations</h2>
            <div class="courses-grid">
                <div class="course-card">
                    <div class="course-image">
                        <img src="assets/images/management.jpg" alt="Business Strategy">
                        <span class="course-badge">management</span>
                    </div>
                    <div class="course-content">
                        <h3>Management</h3>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                            <span>(4.5)</span>
                        </div>
                        <div class="course-meta">
                            <span><i class="fas fa-user"></i> 124</span>
                            <span><i class="fas fa-clock"></i> 15h</span>
                        </div>
                    </div>
                </div>
                <div class="course-card">
                    <div class="course-image">
                        <img src="assets/images/uiux.jpg" alt="Design Thinking">
                        <span class="course-badge">Design</span>
                    </div>
                    <div class="course-content">
                        <h3>UX/UI Design Principles</h3>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <span>(5.0)</span>
                        </div>
                        <div class="course-meta">
                            <span><i class="fas fa-user"></i> 89</span>
                            <span><i class="fas fa-clock"></i> 12h</span>
                        </div>
                    </div>
                </div>
                <div class="course-card">
                    <div class="course-image">
                        <img src="assets/images/marketingd.jpg" alt="Digital Marketing">
                        <span class="course-badge">Marketing</span>
                    </div>
                    <div class="course-content">
                        <h3>Digital Marketing Strategy</h3>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                            <span>(4.0)</span>
                        </div>
                        <div class="course-meta">
                            <span><i class="fas fa-user"></i> 156</span>
                            <span><i class="fas fa-clock"></i> 10h</span>
                        </div>
                    </div>
                </div>
                <div class="course-card">
                    <div class="course-image">
                        <img src="assets/images/fullstack.jpg" alt="Web Development">
                        <span class="course-badge">Development</span>
                    </div>
                    <div class="course-content">
                        <h3>Full Stack Web Development</h3>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                            <span>(4.7)</span>
                        </div>
                        <div class="course-meta">
                            <span><i class="fas fa-user"></i> 210</span>
                            <span><i class="fas fa-clock"></i> 24h</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Section Banner-->
    <section class="purple-banner">
        <div class="container">
            <div class="banner-content">
                <div class="banner-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <p>Plus de <strong>16</strong> établissements font confiance à notre système</p>
            </div>
            <div class="banner-icons">
                <div class="banner-icon-item">
                    <i class="fas fa-users"></i>
                    <p>Gestion des classes</p>
                </div>
                <div class="banner-icon-item">
                    <i class="fas fa-certificate"></i>
                    <p>Suivi des diplômes</p>
                </div>
                <div class="banner-icon-item">
                    <i class="fas fa-calendar"></i>
                    <p>Planification scolaire</p>
                </div>
                <div class="banner-icon-item">
                    <i class="fas fa-headset"></i>
                    <p>Support 24/7</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Section Catégories -->
    <section class="categories-section" id="categories"> 
        <div class="container">
            <h2>Nos principaux services de gestion</h2>
            <div class="categories-grid">
                <div class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h3>Suivi des résultats</h3>
                </div>
                <div class="category-item">
                    <div class="category-icon">
                       <i class="fas fa-list-check"></i>
                    </div>
                    <h3>Emplois du temps</h3>
                </div>
                <div class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-user"></i>
                    </div>
                    <h3>Gestion des absences</h3>
                </div>
                <div class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-bullhorn"></i>
                    </div>
                    <h3>Communication</h3>
                </div>
                <div class="category-item">
                    <div class="category-icon">
                      <i class="fas fa-user-graduate"></i>
                    </div>
                    <h3>Suivi pédagogique</h3>
                </div>
                <div class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <h3>Bibliothèque numérique</h3>
                </div>
            </div>
        </div>
    </section>
    <!-- Section Enseignants -->
    <section class="teachers-section" id="prof">
        <div class="container">
            <h2>Notre équipe administratif</h2>
            <div class="teachers-grid">
                <div class="teacher-card">
                
                    <img src="assets/images/khadija.jpg" alt="khadija">
                    <h3>Khadijatou LY</h3>
                </div>
                <div class="teacher-card">
                    <img src="assets/images/omar.jpg" alt="omar">
                    <h3>Omar NDIAYE</h3>
                </div>
                <div class="teacher-card">
                    <img src="assets/images/mamadou.jpg" alt="mamadou">
                    <h3>Mamadou SY</h3>
                </div>
                
                <div class="teacher-card">
                    <img src="assets/images/mage.jpg" alt="mage">
                    <h3>Mage Ndiaye</h3>
                </div>
            </div>
        </div>
    </section>

    <!-- Section Certificat -->
    <section class="certificate-section">
        <div class="container">
            <div class="certificate-content">
                <h2>Gestion des diplômes</h2>
                <a href="#" class="btn btn-primary">En savoir plus</a>
            </div>
            <div class="certificate-image">
                <img src="assets/images/diplome.png" alt="dilopme">
            </div>
        </div>
    </section>

    <!-- Section Témoignages -->
    <section class="testimonials-section">
        <div class="container">
            <h2>Avis des utilisateurs</h2>
            <div class="testimonials-grid">
                <div class="testimonial-card">
                    <div class="rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <p class="testimonial-text">Le système de gestion a transformé notre établissement. Le suivi des étudiants et la communication avec les parents sont désormais simplifiés.</p>
                    <div class="testimonial-author">
                        <img src="assets/images/amina.jpg" alt="amina">
                        <div>
                            <h3>Amina NIASSE</h3>
                            <p>Directrice de l'établissement</p>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <div class="rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <p class="testimonial-text">En tant qu'enseignant, j'apprécie de pouvoir gérer mes notes et les absences facilement. Les parents sont mieux informés sur le parcours de leurs enfants.</p>
                    <div class="testimonial-author">
                        <img src="assets/images/smg.jpg" alt="mbaye">
                        <div>
                            <h3>Mbaye GUEYE</h3>
                            <p>Professeur de mathématiques</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Section Expérience -->
    <section class="experience-section">
        <div class="container">
            <div class="experience-image">
                <img src="assets/images/etudiant.png" alt="Étudiante avec des livres">
            </div>
            <div class="experience-content">
                <h2>Plus de 36 ans d'expérience éducative</h2>
                <p>Notre système de gestion scolaire s'appuie sur plus de 36 ans d'expertise dans le domaine de l'éducation et de la technologie.</p>
                <div class="experience-buttons">
                    <a href="#courses" class="btn btn-primary">Nos formations</a>
                    <a href="#contact" class="btn btn-outline">Contactez-nous</a>
                </div>
                <div class="experience-experts">
                    <div class="expert">
                        <img src="assets/images/mage.jpg" alt="Expert 1">
                    </div>
                    <div class="expert">
                        <img src="assets/images/omar.jpg" alt="Expert 2">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Section Événements -->
    <section class="events-section">
        <div class="container">
            <h2>Calendrier scolaire</h2>
            <div class="countdown-grid">
                <div class="countdown-item">
                    <div class="countdown-number">180</div>
                    <div class="countdown-label">Jours</div>
                </div>
                <div class="countdown-item">
                    <div class="countdown-number">18</div>
                    <div class="countdown-label">Heures</div>
                </div>
                <div class="countdown-item">
                    <div class="countdown-number">56</div>
                    <div class="countdown-label">Minutes</div>
                </div>
                <div class="countdown-item">
                    <div class="countdown-number">09</div>
                    <div class="countdown-label">Secondes</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Section Blog -->
    <section class="blog-section">
        <div class="container">
            <h2>Actualités</h2>
            <div class="blog-grid">
                <div class="blog-card">
                    <img src="assets/images/ecole.jpg" alt="Article de blog 1">
                    <div class="blog-content">
                        <h3>La vie au campus SkillEdge</h3>
                        <p>Découvrez les installations et les services offerts sur notre campus.</p>
                        <a href="#" class="blog-link">Lire plus <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="blog-card">
                    <img src="assets/images/cours.jpg" alt="Article de blog 2">
                    <div class="blog-content">
                        <h3>Optimiser la gestion des examens</h3>
                        <p>Nos conseils pour une organisation efficace des périodes d'évaluation dans votre établissement.</p>
                        <a href="#" class="blog-link">Lire plus <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="blog-card">
                    <img src="assets/images/tech.jpg" alt="Article de blog 3">
                    <div class="blog-content">
                        <h3>L'avenir de la gestion scolaire numérique</h3>
                        <p>Découvrez les innovations technologiques qui transforment l'administration des établissements.</p>
                        <a href="#" class="blog-link">Lire plus <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Section Inscription -->
    <section class="signup-section" id="contact">
        <div class="container">
            <div class="signup-content">
                <h2>Contact</h2>
                <form class="signup-form">
                    <input type="text" placeholder="Votre nom">
                    <input type="email" placeholder="Votre email">
                    <input type="tel" placeholder="Votre téléphone">
                     <input type="message" placeholder="Votre message">
                    <button type="submit" class="btn btn-primary">Soumettre</button>
                </form>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container footer-container">
            <div class="footer-about">
                <div class="logo">
                    <a href="#"><span class="logo-edu">Skill</span><span class="logo-lerns">Edge</span></a>
                </div>
                <p>Plateforme de gestion de scolarité complète pour les établissements d'enseignement.</p>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="footer-links">
                <div class="footer-column">
                    <h3>Liens</h3>
                    <ul>
                        <li><a href="#features-section">Fonctionnalités</a></li>
                        <li><a href="#courses">Formations</a></li>
                        <li><a href="#categories">Services</a></li>
                        <li><a href="#prof">Équipe</a></li>
                        <li><a href="#contact">Contact</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h3>Contact</h3>
                    <ul>
                        <li><i class="fas fa-map-marker-alt"></i> 123 Colobane Dakar, Sénégal</li>
                        <li><i class="fas fa-phone"></i> +221 33 833 33 33</li>
                        <li><i class="fas fa-envelope"></i> skilledge@etu.sn</li>
                    </ul>
                    <div class="newsletter">
                        <input type="email" placeholder="Votre email">
                        <button><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>
            </div>
        </div>
        <div class="copyright">
            <div class="container">
                <p>&copy; 2025 SkillEdge. Tous droits réservés.</p>
            </div>
        </div>
    </footer>
</body>
</html>