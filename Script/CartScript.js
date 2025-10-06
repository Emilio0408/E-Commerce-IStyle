
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

/*RICHIESTA AJAX PER INCREMENTARE LA QUANTITA' DI UN PRODOTTO NEL CARRELLO*/
document.addEventListener('DOMContentLoaded', function() {
    // Seleziona tutti i pulsanti di aggiunta quantità
    const addQuantityButtons = document.querySelectorAll('.quantity-btn.addQuantity');
    
    addQuantityButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();            
            // Trova l'elemento genitore del prodotto (cart-item)
            const cartItem = this.closest('.cart-item');
            
            // Recupera i dati del prodotto dai dataset
            const productDetails = cartItem.querySelector('.cart-item-details');
            const productId = productDetails.dataset.id;
            const color = productDetails.dataset.color;
            const model = productDetails.dataset.model;
            
            // Effettua la richiesta AJAX con GET
            fetch(`${document.body.dataset.contextPath}/cart?action=add&id=${productId}&color=${encodeURIComponent(color)}&model=${encodeURIComponent(model)}`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Errore nella risposta del server');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Aggiorna il totale del carrello
                    document.getElementById('total').textContent = data.data.cartTotal;
                    
                    // Aggiorna il contatore del carrello nell'header
                    document.querySelectorAll('.cart-count').forEach(element => {
                        element.textContent = data.data.quantityOfProductInCart;
                    });
                    
                    // Aggiorna la quantità nel campo input (aumenta di 1)
                    const quantityInput = cartItem.querySelector('.quantity-input');
                    quantityInput.value = parseInt(quantityInput.value) + 1;
                    
                    // Mostra un feedback visivo all'utente
                    showAlert('Prodotto aggiunto al carrello', 'success');
                } else {
                    showAlert('error', data.message || 'Errore durante l\'aggiunta del prodotto');
                }
            })
            .catch(error => {
                console.error('Errore:', error);
                showAlert('error', 'Si è verificato un errore durante l\'operazione');
            });
        });
    });
});





/*RICHIESTA AJAX PER DECREMENTARE LA QUANTITA' DI UN PRODOTTO NEL CARRELLO*/
document.addEventListener('DOMContentLoaded', function() {
    // Seleziona tutti i pulsanti di aggiunta quantità
    const addQuantityButtons = document.querySelectorAll('.quantity-btn.decreaseQuantity');
    
    addQuantityButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Trova l'elemento genitore del prodotto (cart-item)
            const cartItem = this.closest('.cart-item');
            
            // Recupera i dati del prodotto dai dataset
            const productDetails = cartItem.querySelector('.cart-item-details');
            const productId = productDetails.dataset.id;
            const color = productDetails.dataset.color;
            const model = productDetails.dataset.model;
            
            // Effettua la richiesta AJAX con GET
            fetch(`${document.body.dataset.contextPath}/cart?action=remove&id=${productId}&color=${encodeURIComponent(color)}&model=${encodeURIComponent(model)}`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Errore nella risposta del server');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Aggiorna il totale del carrello

                    console.log(data);

                    if(data.data.delete)
                    {
                        cartItem.remove();
                    }
                    else
                    {
                        const quantityInput = cartItem.querySelector('.quantity-input');
                        quantityInput.value = parseInt(quantityInput.value) - 1;
                    }

                    document.getElementById('total').textContent = data.data.cartTotal;
                    
                    // Aggiorna il contatore del carrello nell'header
                    document.querySelectorAll('.cart-count').forEach(element => {
                        element.textContent = data.data.quantityOfProductInCart;
                    });

                    if(data.data.quantityOfProductInCart == 0)
                    {
                        const cartSummary = document.querySelector(".cart-summary");
                        cartSummary.remove();
                        const emptyCartHtml =
                        `
                            <div class="empty-cart" id="empty-cart">
                                <div class="empty-cart-icon">
                                <i class="fas fa-shopping-cart"></i>
                                </div>
                                <h3 class="empty-cart-message">Il tuo carrello è vuoto</h3>
                                <a href="Prodotti.jsp" class="continue-shopping checkout-btn">Continua lo shopping</a>
                            </div>
                        `;
                        
                        document.querySelector('.cart-container').insertAdjacentHTML('beforeend', emptyCartHtml);

                    }
                    
                    // Mostra un feedback visivo all'utente
                    showAlert('Prodotto rimosso dal carrello', 'success');
                } else {
                    showAlert('error', data.message || 'Errore durante l\'aggiunta del prodotto');
                }
            })
            .catch(error => {
                console.error('Errore:', error);
                showAlert('error', 'Si è verificato un errore durante l\'operazione');
            });
        });
    });
});



/*RICHIESTA AJAX PER ELIMINARE UN PRODOTTO DAL CARRELLO*/
document.addEventListener('DOMContentLoaded', function() {
    // Seleziona tutti i pulsanti di aggiunta quantità
    const addQuantityButtons = document.querySelectorAll('.remove-item');
    
    addQuantityButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Trova l'elemento genitore del prodotto (cart-item)
            const cartItem = this.closest('.cart-item');
            
            // Recupera i dati del prodotto dai dataset
            const productDetails = cartItem.querySelector('.cart-item-details');
            const productId = productDetails.dataset.id;
            const color = productDetails.dataset.color;
            const model = productDetails.dataset.model;
            
            // Effettua la richiesta AJAX con GET
            fetch(`${document.body.dataset.contextPath}/cart?action=remove&id=${productId}&color=${encodeURIComponent(color)}&model=${encodeURIComponent(model)}&totalRemove=true`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Errore nella risposta del server');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Aggiorna il totale del carrello

                    console.log(data);

                    if(data.data.delete)
                    {
                        cartItem.remove();
                    }
                    else
                    {
                        const quantityInput = cartItem.querySelector('.quantity-input');
                        quantityInput.value = parseInt(quantityInput.value) - 1;
                    }

                    document.getElementById('total').textContent = data.data.cartTotal;
                    
                    // Aggiorna il contatore del carrello nell'header
                    document.querySelectorAll('.cart-count').forEach(element => {
                        element.textContent = data.data.quantityOfProductInCart;
                    });

                    if(data.data.quantityOfProductInCart == 0)
                    {
                        const cartSummary = document.querySelector(".cart-summary");
                        cartSummary.remove();
                        const emptyCartHtml =
                        `
                            <div class="empty-cart" id="empty-cart">
                                <div class="empty-cart-icon">
                                <i class="fas fa-shopping-cart"></i>
                                </div>
                                <h3 class="empty-cart-message">Il tuo carrello è vuoto</h3>
                                <a href="/IStyle/product" class="continue-shopping checkout-btn">Continua lo shopping</a>
                            </div>
                        `;
                        
                        document.querySelector('.cart-container').insertAdjacentHTML('beforeend', emptyCartHtml);

                    }
                    
                    // Mostra un feedback visivo all'utente
                    showAlert('Prodotto rimosso dal carrello', 'success');
                } else {
                    showAlert('error', data.message || 'Errore durante l\'aggiunta del prodotto');
                }
            })
            .catch(error => {
                console.error('Errore:', error);
                showAlert('error', 'Si è verificato un errore durante l\'operazione');
            });
        });
    });
});