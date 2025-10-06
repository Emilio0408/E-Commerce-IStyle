document.addEventListener('DOMContentLoaded', function() {

    // Elementi UI
    const loginTab = document.getElementById('login-tab');
    const registerTab = document.getElementById('register-tab');
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    
    // Gestione tab
    function switchTab(showLogin) {
        if(showLogin) {
            loginTab.classList.add('active');
            registerTab.classList.remove('active');
            loginForm.classList.remove('hidden');
            registerForm.classList.add('hidden');
        } else {
            registerTab.classList.add('active');
            loginTab.classList.remove('active');
            registerForm.classList.remove('hidden');
            loginForm.classList.add('hidden');
        }
    }
    
    loginTab.addEventListener('click', () => switchTab(true));
    registerTab.addEventListener('click', () => switchTab(false));
    
    // Toggle password
    document.querySelectorAll('.toggle-password').forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.parentElement.querySelector('input');
            const icon = this.querySelector('i');
            const isVisible = input.type === 'text';
            
            input.type = isVisible ? 'password' : 'text';
            icon.classList.toggle('fa-eye-slash', !isVisible);
            icon.classList.toggle('fa-eye', isVisible);
            this.setAttribute('aria-label', isVisible ? 'Mostra password' : 'Nascondi password');
        });
    });
    
    // Password strength
    const newPassword = document.getElementById('new-password');
    if(newPassword) {
        newPassword.addEventListener('input', function() {
            const strengthContainer = this.closest('.form-group').querySelector('.password-strength');
            if(!strengthContainer) return;
            
            const password = this.value;
            let strength = 0;
            
            // Lunghezza
            if(password.length >= 8) strength++;
            // Caratteri speciali
            if(/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;
            // Maiuscole e numeri
            if(/[A-Z]/.test(password) && /\d/.test(password)) strength++;
            
            // Aggiornamento UI
            strengthContainer.className = 'password-strength';
            const bars = strengthContainer.querySelectorAll('.strength-bar');
            const strengthText = strengthContainer.querySelector('.strength-text');
            
            if(password.length === 0) {
                if(strengthText) strengthText.textContent = '';
                bars.forEach(bar => bar.style.backgroundColor = '');
                return;
            }
            
            strengthContainer.classList.add(
                strength <= 1 ? 'password-weak' : 
                strength === 2 ? 'password-medium' : 'password-strong'
            );
            
            if(strengthText) {
                strengthText.textContent = 
                    strength <= 1 ? 'Debole' : 
                    strength === 2 ? 'Media' : 'Forte';
            }
        });
    }
    
    // Conferma password
    const confirmPwd = document.getElementById('confirm-password');
    if(confirmPwd) {
        confirmPwd.addEventListener('input', function() {
            const pwd = document.getElementById('new-password').value;
            if(this.value && this.value !== pwd) {
                this.setCustomValidity("Le password non coincidono");
            } else {
                this.setCustomValidity("");
            }
        });
    }
    
    // Form validation
    document.querySelectorAll('.auth-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            if(!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });
});



/*RICHIESTA AJAX PER IL LOGIN*/
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('login-form');
    
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Recupera i valori dal form
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        
        // Effettua la richiesta AJAX
        fetch(`${document.body.dataset.contextPath}/authentication`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=login&email=${encodeURIComponent(email)}&Password=${encodeURIComponent(password)}`
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Errore nella risposta del server');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Mostra alert di successo
                showAlert('Login effettuato con successo!','success');
                
                // Reindirizza dopo un breve ritardo per far vedere l'alert
                setTimeout(() => {
                    window.location.href = data.redirectURL || `${document.body.dataset.contextPath}/authentication`;
                }, 200);
            } else {
                // Mostra errore specifico
                let errorMessage = "Errore durante il login";


                if (data.error === "wrong password") {
                    errorMessage = "Password errata";
                } else if (data.error === "email does not exists") {
                    errorMessage = "Email non registrata";
                }
                showAlert(errorMessage, 'error');
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            showAlert('Si è verificato un errore durante il login', 'error');
        });
    });
});


/*RICHIESTA AJAX PER LA REGISTRAZIONE*/
document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.getElementById('register-form');
    const strengthContainer = document.querySelector('.password-strength');

    
    registerForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Recupera i valori dal form
        const formData = {
            action: 'register',
            Name: document.getElementById('name').value,
            Surname: document.getElementById('surname').value,
            Username: document.getElementById('username').value,
            Password: document.getElementById('new-password').value,
            email: document.getElementById('new-email').value,
            NewsLetterSubscription: document.getElementById('newsletter').checked
        };
        
        // Effettua la richiesta AJAX
        fetch(`${document.body.dataset.contextPath}/authentication`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: Object.keys(formData).map(key => 
                `${encodeURIComponent(key)}=${encodeURIComponent(formData[key])}`
            ).join('&')
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Errore nella risposta del server');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Mostra alert di successo
                showAlert('Registrazione completata con successo! Adesso puoi effettuare il login','success');
            } else {
                // Mostra errore specifico
                let errorMessage = "Errore durante la registrazione";
                if (data.message === "username already exists") {
                    errorMessage = "Username già esistente";
                } else if (data.message === "email already exists") {
                    errorMessage = "Email già registrata";
                } else if (data.message === "server error") {
                    errorMessage = "Errore del server, riprova più tardi";
                }
                showAlert(errorMessage, 'error');
            }

            document.getElementById('register-form').reset();
            strengthContainer.className = 'password-strenght';
            strengthContainer.textContent = "";
        })
        .catch(error => {
            console.error('Errore:', error);
            showAlert('Si è verificato un errore durante la registrazione','error' );
        });
    });
});
