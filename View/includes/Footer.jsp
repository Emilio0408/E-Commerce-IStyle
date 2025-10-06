<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() +  "/StyleSheet/FooterStyle.css"%>">

<footer>
    <div class="footer-container">
        <div class="footer-top">
            <div class="footer-logo">
                <a href="Home.jsp" class="logo-link">
                    <i class="fas fa-mobile-alt logo-icon"></i>
                    <span class="logo-text">iStyle</span>
                </a>
                <p class="footer-description">Il tuo negozio di fiducia per accessori smartphone</p>
                <div class="footer-address">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>Università degli Studi di Salerno</span>
                </div>
            </div>

            <div class="footer-newsletter">
                <h3>Rimani aggiornato</h3>
                <form class="newsletter-form">
                    <input type="email" placeholder="La tua email" required>
                    <button type="submit">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </form>
            </div>
        </div>

        <div class="footer-middle">
            <div class="footer-column">
                <h3>Informazioni</h3>
                <ul>
                    <li><a href="chi-siamo.jsp"><i class="fas fa-chevron-right"></i> Chi siamo</a></li>
                    <li><a href="contatti.jsp"><i class="fas fa-chevron-right"></i> Contatti</a></li>
                    <li><a href="lavora-con-noi.jsp"><i class="fas fa-chevron-right"></i> Lavora con noi</a></li>
                    <li><a href="spedizioni.jsp"><i class="fas fa-chevron-right"></i> Spedizioni</a></li>
                </ul>
            </div>

            <div class="footer-column">
                <h3>Account</h3>
                <ul>
                    <li><a href="area-utente.jsp"><i class="fas fa-chevron-right"></i> Il mio account</a></li>
                    <li><a href="ordini.jsp"><i class="fas fa-chevron-right"></i> I miei ordini</a></li>
                    <li><a href="wishlist.jsp"><i class="fas fa-chevron-right"></i> Wishlist</a></li>
                    <li><a href="resoconto.jsp"><i class="fas fa-chevron-right"></i> Resoconto</a></li>
                </ul>
            </div>

            <div class="footer-column">
                <h3>Assistenza</h3>
                <ul>
                    <li><a href="faq.jsp"><i class="fas fa-chevron-right"></i> FAQ</a></li>
                    <li><a href="supporto.jsp"><i class="fas fa-chevron-right"></i> Supporto</a></li>
                    <li><a href="guida.jsp"><i class="fas fa-chevron-right"></i> Guida all'acquisto</a></li>
                    <li><a href="resoconto.jsp"><i class="fas fa-chevron-right"></i> Resi e rimborsi</a></li>
                </ul>
            </div>

            <div class="footer-column">
                <h3>Contatti</h3>
                <ul class="contact-info">
                    <li><i class="fas fa-phone"></i> +39 123 456 7890</li>
                    <li><i class="fas fa-envelope"></i> info@istyle.com</li>
                    <li><i class="fas fa-clock"></i> Lun-Ven: 9:00-18:00</li>
                </ul>
                <div class="social-links">
                    <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <div class="payment-methods">
                <i class="fab fa-cc-visa"></i>
                <i class="fab fa-cc-mastercard"></i>
                <i class="fab fa-cc-amex"></i>
                <i class="fab fa-cc-paypal"></i>
                <i class="fab fa-cc-apple-pay"></i>
            </div>
            <div class="copyright">
                <p>&copy; <%= java.time.Year.now() %> iStyle. Tutti i diritti riservati.</p>
                <div class="legal-links">
                    <a href="privacy.jsp">Privacy Policy</a>
                    <a href="termini.jsp">Termini e condizioni</a>
                    <a href="cookie.jsp">Cookie Policy</a>
                </div>
            </div>
        </div>
    </div>
</footer>