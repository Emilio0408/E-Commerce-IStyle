<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/errorPageStyles/Style404.css"%>">
    <title>404 - Page not found</title>
</head>
<body> 
    <!-- Header con Logo -->
    <div class="header">
        <img src="<%=request.getContextPath() + "/images/icons/logoNuovo.png"%>" alt="Logo" class="logo">
    </div>
    <!-- Sezione Errore (Sinistra) -->
    <div class="error-container">
        <div class="error-content">
            <div class="error-code">404</div>
            <h1 class="error-title">Pagina non trovata</h1>
            <p class="error-description">
                Pagina smarrita? Nessun panico! <br>
                Mentre la cerchiamo, proteggi il tuo dispositivo con le nostre cover.
            </p>
            <div class="action-buttons">
                <!-- Path home-->
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">
                     Torna alla Home
                </a>
                <!-- Path prodotti -->
                <a href="<%= request.getContextPath() %>/product" class="btn btn-secondary">
                     Vedi Prodotti
                </a>
            </div>
        </div>

        <!-- Sezione Video (Destra) -->
        <div class="gif-container">
             <div class="gif-placeholder">
                <video class="video-player" 
                       src="<%=request.getContextPath() + "/images/errorPageMedia/error404.mp4"%>"
                       autoplay 
                       muted
                       playsinline
                       oncanplay="this.nextElementSibling.style.display='none';"
                       onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                       loop
                >
                    Il tuo browser non supporta il tag video.
                </video>
                <div class="video-fallback">
                    <p>Caricamento video...</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Animazione al caricamento della pagina
        document.addEventListener('DOMContentLoaded', function() {
            const errorCode = document.querySelector('.error-code');
            const errorTitle = document.querySelector('.error-title');
            const errorDescription = document.querySelector('.error-description');
            const buttons = document.querySelectorAll('.btn');
            const video = document.querySelector('.video-player');

            // Gestione video
            if (video) {
                video.muted = true;
                playbackRate="0.75"
                
                video.play().catch(function(error) {
                    console.log('Autoplay bloccato:', error);
                    // Mostra il fallback se l'autoplay è bloccato
                    video.style.display = 'none';
                    video.nextElementSibling.style.display = 'flex';
                });

        
                video.addEventListener('error', function() {
                    video.style.display = 'none';
                    video.nextElementSibling.style.display = 'flex';
                });
            }

            // Animazioni per gli elementi
            setTimeout(() => {
                errorCode.style.animation = 'fadeInUp 0.6s ease-out';
            }, 100);

            setTimeout(() => {
                errorTitle.style.animation = 'fadeInUp 0.6s ease-out';
            }, 300);

            setTimeout(() => {
                errorDescription.style.animation = 'fadeInUp 0.6s ease-out';
            }, 500);

            setTimeout(() => {
                buttons.forEach((btn, index) => {
                    setTimeout(() => {
                        btn.style.animation = 'fadeInUp 0.6s ease-out';
                    }, index * 100);
                });
            }, 700);
        });

        // Animazioni CSS
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>