
//RICHIESTA AJAX PER OTTENERE I DATI PER IL CARRELLO MODALE

function fetchProductModalData(productId, color) {
    return new Promise((resolve, reject) => {
        const contextPath = document.body.dataset.contextPath;
        const url = `${contextPath}/product?action=selectProductData&IDProdotto=${productId}&Color=${encodeURIComponent(color)}`;
        
        fetch(url, {
            method: 'GET',
            headers: {
                'Accept': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                resolve(data.data); // Risolve con i dati del prodotto
            } else {
                reject(new Error(data.message || 'Errore nel recupero dei dati del prodotto'));
            }
        })
        .catch(error => {
            console.error('Errore nella richiesta:', error);
            showAlert('Si è verificato un errore nel recupero dei dati del prodotto', 'error');
            reject(error);
        });
    });
}


/*RICHIESTA AJAX PER AGGIUNTA DEL PRODOTTO AL CARRELLO*/
function addToCart() 
{
    const modal = document.getElementById('modaleCarrello');
    const productId = modal.dataset.productId;
    const color = modal.dataset.selectedColor;
    const model = document.getElementById('model-select').value;
    
    if (!model) {
        showAlert('Seleziona un modello prima di confermare', 'warning');
        return;
    }

    const confirmBtn = document.querySelector('.confirm-btn');
    // Mostra lo stato di caricamento
    confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Aggiungendo...';
    confirmBtn.disabled = true;

    const contextPath = document.body.dataset.contextPath;
    const url = `${contextPath}/cart?action=add&id=${encodeURIComponent(productId)}&color=${encodeURIComponent(color)}&model=${encodeURIComponent(model)}`;

    fetch(url, {
        method: 'GET',
        headers: {
            'Accept': 'application/json'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showAlert('Prodotto aggiunto al carrello', 'success');
            chiudiModale();
            const cartCount = document.querySelectorAll(".cart-count")
            cartCount.forEach(count => count.textContent = data.data.quantityOfProductInCart);
        } else {
            throw new Error(data.message || 'Errore durante l\'aggiunta al carrello');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert(error.message || 'Si è verificato un errore', 'error');
    })
    .finally(() => {
        confirmBtn.innerHTML = 'Conferma';
        confirmBtn.disabled = false;
    });
}



// Richiesta AJAX per aggiungere il prodotto alla lista dei preferiti
async function addToWishlist(btn) {
    const contextPath = document.querySelector('body').dataset.contextPath;
    const productId = btn.dataset.productId;
    const cuore = btn.querySelector('.cuore-icon');



    try {
        const response = await fetch(`${contextPath}/user/wishlist?action=add`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `IDProduct=${productId}`
        });

        const result = await response.json();

        if (result.success) {
            cuore.src = `${contextPath}/images/icons/red-heart.png`;
            showAlert("Prodotto aggiunto ai preferiti!", "success");
        } else {
            showAlert(result.error || "Errore durante l'aggiunta", "error");
        }
    } catch (error) {
        showAlert("Errore di connessione", "error");
        console.error("Errore AJAX:", error);
    }
}

//Richiesta AJAX per rimuovere il prodotto alla lista dei preferiti
async function removeFromWishlist(btn) {
    const contextPath = document.querySelector('body').dataset.contextPath;
    const productId = btn.dataset.productId;
    const cuore = btn.querySelector('.cuore-icon');

    try {
        const response = await fetch(`${contextPath}/user/wishlist?action=remove`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `IDProduct=${productId}`
        });

        const result = await response.json();

        if (result.success) {
            cuore.src = `${contextPath}/images/icons/heart-icon.png`;
            showAlert("Prodotto rimosso dai preferiti!", "success");
        } else {
            showAlert(result.message || "Errore durante la rimozione", "error");
        }
    } catch (error) {
        showAlert("Errore di connessione", "error");
        console.error("Errore AJAX:", error);
    }
}

//Richiesta AJAX per ottenere l'immagine associata al selettore del colore
function addColorHoverListeners() {
    document.querySelectorAll('.card-prodotto .selettori-colore .colore-option').forEach(option => {
        option.addEventListener('click', function() {
            const productCard = this.closest('.card-prodotto');
            const productId = productCard.dataset.productId;
            const color = this.getAttribute('data-color') || this.getAttribute('value');
            const productImg = productCard.querySelector('.img-prodotto');
            productImg.style.opacity = '0.5';


            productCard.querySelectorAll('.selettori-colore .colore-option').forEach(opt => {
                opt.classList.remove('active');
            });
            
            // Aggiungi la classe al colore selezionato
            this.classList.add('active');


            fetch(`${document.body.dataset.contextPath}/product?action=selectProductData&IDProdotto=${productId}&Color=${encodeURIComponent(color)}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data.image) {
                        productImg.src = `${document.body.dataset.contextPath}/images/prodotti/${data.data.image}`;
                    }
                })
                .finally(() => productImg.style.opacity = 1)
                .catch(error => console.error('Errore:', error));
        });
    });
}


//Richiesta AJAX per la ricerca adattiva

function fetchSearchResults(query) 
{
    const searchResults = document.getElementById('searchResults');
    const contextPath = document.body.dataset.contextPath;
    
    // Mostra un messaggio di caricamento
    searchResults.innerHTML = '<div class="no-results">Ricerca in corso...</div>';
    searchResults.style.display = 'block';
    
    // Effettua la richiesta AJAX al endpoint di ricerca
    fetch(`${contextPath}/product?action=Search&name=${encodeURIComponent(query)}`, {
        method: 'GET',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        // Controlla se la risposta è ok (status 200-299)
        if (!response.ok) {
            throw new Error(`Errore HTTP! Stato: ${response.status}`);
        }
        return response.json();
    })
    .then(products => {


        // Se non ci sono risultati
        if (products.data === undefined) {
            searchResults.innerHTML = '<div class="no-results">Nessun risultato trovato</div>';
            return;
        }

        
        // Genera l'HTML per i risultati
        const resultsHTML = products.data.map(product => `
            <a href="${contextPath}/product/${encodeURIComponent(product.name)}">
                <span class="product-name">${product.name}</span>
                ${product.category ? `<span class="product-category">${product.category}</span>` : ''}
            </a>
        `).join('');
        
        searchResults.innerHTML = resultsHTML;
    })
    .catch(error => {
        console.error('Errore durante la ricerca:', error);
        searchResults.innerHTML = '<div class="no-results">Errore durante la ricerca. Riprova.</div>';
    });
}


function setupSearchInput() {
    const searchInput = document.getElementById('searchInput');
    const searchResults = document.getElementById('searchResults');
    let searchTimeout;
    
    searchInput.addEventListener('input', function() {
        // Cancella il timeout precedente
        clearTimeout(searchTimeout);
        
        const query = this.value.trim();
        
        // Se la query è troppo corta, nascondi i risultati
        if (query.length < 1) {
            searchResults.style.display = 'none';
            return;
        }
        
        // Imposta un nuovo timeout con debounce di 300ms
        searchTimeout = setTimeout(() => {
            fetchSearchResults(query);
        }, 300);
    });
    

       searchInput.addEventListener('focus', function() {
        if (searchResults.innerHTML.trim() !== '' && searchInput.value.length > 0) {
            searchResults.style.display = 'block';
        }
    });

}

/**
 * Inizializza la ricerca adattiva quando la pagina è pronta
 */
document.addEventListener('DOMContentLoaded', function() {
    setupSearchInput();
    
});

document.addEventListener('click', function(event) {
    const searchBox = document.querySelector('.search-box');
    const searchResults = document.getElementById('searchResults');
    
    // Verifica se il click è avvenuto al di fuori della search-box e dei risultati
    if (!event.target.closest('.search-box') && !event.target.closest('#searchResults')) {
        searchResults.style.display = 'none';
    }
});

