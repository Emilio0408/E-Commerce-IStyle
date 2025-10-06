<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>




<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>iStyle - Autenticazione</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/AuthStyle.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Alert.css"%>">
</head>
<body data-context-path="<%=request.getContextPath()%>">

    <%@ include file="includes/Alert.jsp" %>


    <div class="iphone-container">
        
        <div class="iphone-frame">
            <!-- Notch -->
            <div class="notch">
                <div class="speaker"></div>
                <div class="camera"></div>
            </div>
            
            <!-- Screen Content -->
            <div class="screen-content">
                
                <!-- Tabs -->
                <div class="auth-tabs">
                    <button class="tab-btn active" id="login-tab">Accedi</button>
                    <button class="tab-btn" id="register-tab">Registrati</button>
                </div>
                
                <!-- Login Form -->
                <form action="authenticate.jsp" method="post" class="auth-form" id="login-form">
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="email" id="email" name="email" placeholder="Email" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Password" required>
                            <button type="button" class="toggle-password" aria-label="Mostra password">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
    
                    
                    <button type="submit" class="btn-continue">Accedi</button>
                    
                    <div class="footer-links">
                        <a href="password-recovery.jsp" class="forgot-password">Password dimenticata?</a>
                    </div>
                </form>
                
                <!-- Register Form -->
                <form action="register.jsp" method="post" class="auth-form hidden" id="register-form">
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="name" name="name" placeholder="Nome" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="surname" name="surname" placeholder="Cognome" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-at"></i>
                            <input type="text" id="username" name="username" placeholder="Username" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="new-email" name="email" placeholder="Email" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="new-password" name="password" placeholder="Password" required>
                            <button type="button" class="toggle-password" aria-label="Mostra password">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength">
                            <div class="strength-bar"></div>
                            <div class="strength-bar"></div>
                            <div class="strength-bar"></div>
                            <span class="strength-text"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="confirm-password" placeholder="Conferma password" required>
                        </div>
                    </div>

                    <div class="newsletter-container">
                        <input type="checkbox" id="newsletter" name="newsletter" value="false" class="newsletter-checkbox">
                        <label for="newsletter" class="newsletter-label">Iscriviti alla nostra newsletter</label>
                    </div>
                    
                    <button type="submit" class="btn-continue">Registrati</button>
                    
                    <div class="terms">
                        <p>Registrandoti accetti i <a href="terms.jsp">Termini di servizio</a> e la <a href="privacy.jsp">Privacy Policy</a></p>
                    </div>
                </form>
            </div>
            
            <!-- Home Indicator -->
            <div class="home-indicator"></div>
        </div>
    </div>

<script src="<%=request.getContextPath() + "/Script/includes/Alert.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/AuthScript.js"%>"></script>
</body>
</html>