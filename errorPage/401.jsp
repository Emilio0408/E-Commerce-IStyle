<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/errorPageStyles/Style401.css"%>">
    <title>401 - Unauthorized</title>
</head>
<body>
    <div class="header">
        <img src="<%=request.getContextPath() + "/images/icons/logoNuovo.png"%>" alt="Logo" class="logo">
    </div>
    
    <div class="error-container">
        <div class="error-content">
            <div class="error-code">401</div>
            <h1 class="error-title">Richiesta non autorizzata</h1>
            <p class="error-description">
              La tua richiesta è stata bloccata dalla nostra cover di sicurezza!<br>
              Autenticati per sbloccarla.
            </p>
            <div class="action-buttons">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">
                     Torna alla Home
                </a>
                <a href="<%= request.getContextPath() %>/product" class="btn btn-secondary">
                     Vedi Prodotti
                </a>
            </div>
            
        </div>

        <div class="image-container">
                <img src="<%=request.getContextPath() + "/images/errorPageMedia/Case401.png"%>" alt="Errore 401" class="error-image">
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

        // Aggiungi le animazioni CSS
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