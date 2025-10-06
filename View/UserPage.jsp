<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String name = (String) session.getAttribute("Name");

%>



<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Area Personale - IStyle</title>
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/UserPageStyle.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="animated-gradient">
<%@ include file="includes/Header.jsp" %>

<!-- Background animato -->
<div id="tsparticles"></div>

<div class="account-container">
    <h1 class="section__headline">Benvenuto <%=name%>!</h1>
    <p class="account-welcome">Benvenuto nella tua area personale: qui gestisci i tuoi dati, preferenze e attività.</p>

    <div class="grid">
        <div class="card soft-orange">
            <h2><i class="fas fa-box-open"></i> Ordini</h2>
            <p>Controlla gli acquisti recenti e lo stato dei tuoi pacchi.</p>
            <a href="<%=request.getContextPath() + "/user/orders"%>" class="btn">Vai agli ordini</a>
        </div>
        <div class="card soft-sky">
            <h2><i class="fas fa-heart"></i> Preferiti</h2>
            <p>Rivedi i tuoi articoli preferiti.</p>
            <a href="<%=request.getContextPath() + "/user/wishlist"%>" class="btn">Vai ai preferiti</a>
        </div>
        <div class="card soft-lavender" style="grid-column: span 2;">
            <h2><i class="fas fa-user-cog"></i> I tuoi dati</h2>
            <p>Modifica nome, email, password o elimina l'account.</p>
            <a href="<%=request.getContextPath() + "/user/information"%>" class="btn">Gestisci profilo</a>
        </div>

    </div>

    <!-- FAQ Section -->
    <h1 class="section__headline">Domande Frequenti</h1>

    <h2 class="c-faqs__headline">Fatturazione</h2>
    <ul class="c-faqs">
        <li class="c-faq">
            <span class="c-faq__title">Come visualizzo le mie fatture?</span>
            <div class="c-faq__answer">Puoi scaricarle dalla sezione "Ordini" una volta che l'ordine è stato spedito.</div>
        </li>
        <li class="c-faq">
            <span class="c-faq__title">Posso modificare i dati di fatturazione?</span>
            <div class="c-faq__answer">Sì, ma solo prima che l'ordine venga processato e spedito.</div>
        </li>
    </ul>

    <h2 class="c-faqs__headline">Metodi di pagamento</h2>
    <ul class="c-faqs">
        <li class="c-faq">
            <span class="c-faq__title">Quali metodi di pagamento accettate?</span>
            <div class="c-faq__answer">Carte di credito, PayPal, bonifico bancario e pagamento alla consegna.</div>
        </li>
        <li class="c-faq">
            <span class="c-faq__title">Posso salvare un metodo di pagamento?</span>
            <div class="c-faq__answer">Sì, nella sezione "I tuoi dati" puoi gestire le tue carte salvate.</div>
        </li>
    </ul>
</div>



<%@ include file="includes/Footer.jsp" %>


<script src="https://cdn.jsdelivr.net/npm/tsparticles@2"></script>
<script>
    // Inizializzazione tsParticles
    tsParticles.load("tsparticles", {
        fpsLimit: 60,
        particles: {
            number: { value: 80, density: { enable: true, area: 800 } },
            color: { value: "#E75919" },
            shape: { type: "circle" },
            opacity: { value: 0.6, random: true },
            size: { value: { min: 2, max: 5 }, random: true },
            move: {
                enable: true,
                speed: 1.5,
                direction: "none",
                outModes: { default: "bounce" }
            },
            links: {
                enable: true,
                distance: 120,
                color: "#ffffff",
                opacity: 0.2,
                width: 1
            }
        },
        interactivity: {
            detectsOn: "canvas",
            events: {
                onHover: { enable: true, mode: "grab" },
                onClick: { enable: true, mode: "push" },
                resize: true
            },
            modes: {
                grab: { distance: 140, links: { opacity: 0.5 } },
                push: { quantity: 4 }
            }
        },
        detectRetina: true
    });

    // Toggle FAQ answers
    document.querySelectorAll('.c-faq__title').forEach(function(title) {
        title.addEventListener('click', function() {
            const parent = this.parentElement;
            parent.classList.toggle('c-faq--active');
        });
    });
</script>

</body>
</html>