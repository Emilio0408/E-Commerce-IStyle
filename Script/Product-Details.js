
tsParticles.load("tsparticles", {
    particles: {
        number: { value: 80 },
        color: { value: "#E75919" },
        shape: { type: "circle" },
        size: { value: { min: 2, max: 5 } },
        move: { enable: true, speed: 1.5 }
    }
});


// Gestione stelle di valutazione
const stars = document.querySelectorAll('.star-rating label');
stars.forEach(star => {
    star.addEventListener('click', function() {
        const ratingInput = this.previousElementSibling;
        ratingInput.checked = true;
        const ratingValue = parseInt(ratingInput.value);
        resetStars();
        highlightStars(ratingValue);
    });
});

function resetStars() {
    document.querySelectorAll('.star-rating label').forEach(star => {
        star.style.color = '#ddd';
    });
}

function highlightStars(count) {
    const stars = document.querySelectorAll('.star-rating label');
    for (let i = 0; i < count; i++) {
        stars[stars.length - 1 - i].style.color = '#FFD700';
    }
}



/*CARICAMENTO DEI MODELLI IN BASE AL COLORE SELEZIONATO ALL'INIZIO*/
document.addEventListener('DOMContentLoaded', function(){
    const color = document.querySelector('.colore-option.active').getAttribute('value');
    const contextPath = document.body.dataset.contextPath;
    const productID = document.body.dataset.productId;
    const modelSelect = document.getElementById('modelSelect');


    const url = `${contextPath}/product?action=selectProductData&IDProdotto=${productID}&Color=${encodeURIComponent(color)}`;

    fetch(url)
    .then(response =>{
        if (!response.ok) 
        {
        throw new Error('Errore di rete o del server.');
        }
        return response.json();
    })
    .then(result => {
        if(result.success && result.data)
        {
            modelSelect.innerHTML = '';
            if (result.data.models.length > 0) 
            {
                result.data.models.forEach(model => 
                {
                    const optionElement = document.createElement('option');
                    optionElement.value = model;
                    optionElement.textContent = model;
                    modelSelect.appendChild(optionElement);
                });
            }
            else
            {
                const optionElement = document.createElement('option');
                optionElement.disabled = true;
                optionElement.textContent = 'Nessun modello disponibile';
                modelSelect.appendChild(optionElement);                
            }
        }
        else
        {
            console.error('La servlet ha restituito un errore:', result.message);
            modelSelect.innerHTML = '<option disabled>Errore nel caricamento</option>';
        }
    })
    .catch(error =>{
        console.error('Errore nella richiesta AJAX:', error);
        modelSelect.innerHTML = '<option disabled>Errore di connessione</option>';
    })
})


/*RIchiesta AJAX per selezione del colore*/
document.addEventListener('DOMContentLoaded', function() 
{

    // --- 1. Leggi i dati dinamici dal tag <body> ---
    const body = document.querySelector('body');
    const productID = body.dataset.productId;
    const contextPath = body.dataset.contextPath;
    const mainImage = document.querySelector('.image-wrapper .immagine-principale')

    // --- 2. Logica per la selezione del colore ---
    const colorOptions = document.querySelectorAll('.colore-option');
    const modelSelect = document.getElementById('modelSelect');

    if (colorOptions.length > 0 && modelSelect) {
        colorOptions.forEach(option => {
            option.addEventListener('click', function() {
                const selectedColor = this.dataset.color;

                // Evidenzia il colore selezionato
                colorOptions.forEach(el => el.classList.remove('active'));
                this.classList.add('active');

                // Costruisci l'URL usando i dati letti dal body
                const url = `${contextPath}/product?action=selectProductData&IDProdotto=${productID}&Color=${encodeURIComponent(selectedColor)}`;

                // Esegui la richiesta AJAX
                fetch(url)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Errore di rete o del server.');
                        }
                        return response.json();
                    })
                    .then(result => {

                        if (result.success && result.data) {
                            // Svuota e popola il menu dei modelli
                            modelSelect.innerHTML = '';
                            if (result.data.models.length > 0) {
                                result.data.models.forEach(model => {
                                    const optionElement = document.createElement('option');
                                    optionElement.value = model;
                                    optionElement.textContent = model;
                                    modelSelect.appendChild(optionElement);
                                    mainImage.src =  `${contextPath}/images/prodotti/${result.data.image}`;
                                });
                            } else {
                                const optionElement = document.createElement('option');
                                optionElement.disabled = true;
                                optionElement.textContent = 'Nessun modello disponibile';
                                modelSelect.appendChild(optionElement);
                            }
                        } else {
                            console.error('La servlet ha restituito un errore:', result.message);
                            modelSelect.innerHTML = '<option disabled>Errore nel caricamento</option>';
                        }
                    })
                    .catch(error => {
                        console.error('Errore nella richiesta AJAX:', error);
                        modelSelect.innerHTML = '<option disabled>Errore di connessione</option>';
                    });
            });
        });
    }
})





/* RICHIESTA AJAX PER L'AGGIUNTA DI UNA RECENSIONE */


document.getElementById('reviewForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // Recupera i dati dal form
    const rating = document.querySelector('input[name="rating"]:checked')?.value;
    const text = document.getElementById('reviewText').value;
    const productId = document.body.getAttribute('data-product-id');
    
    if (!rating) 
    {
        alert('Seleziona una valutazione');
        return;
    }
    
    // Crea l'oggetto FormData per la richiesta
    const params = new URLSearchParams({
        text: text,
        vote: rating,
        IDProdotto: productId
    })

    // Effettua la richiesta AJAX
    fetch('/IStyle/product?action=AddFeedback&' + params.toString(), {
        method: 'GET',
    })
    .then(response => {
        if (!response.ok) {
            return response.json().then(err => { throw err; });
        }
        return response.json();
    })
    .then(data => {
        if (data.success) 
        {
            // Aggiungi la nuova recensione alla lista
            addReviewToPage(data.data);
            
            // Resetta il form
            document.getElementById('reviewForm').reset();
            document.querySelectorAll('input[name="rating"]').forEach(radio => 
            {
                radio.checked = false;
            });
       
            showAlert('Recensione inviata con successo!','success');
        } 
        else 
        {
            showAlert(data.error, 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert(error.message || 'Si è verificato un errore');
    });
});

function addReviewToPage(feedback) {
    const reviewsList = document.getElementById('reviewsList');
    
    // Crea il nuovo elemento recensione
    const reviewItem = document.createElement('div');
    reviewItem.className = 'review-item';
    
    // Crea le stelle in base al voto
    let starsHtml = '';
    let vote = Math.floor(feedback.vote);
    let count = 5;


    for (let i = 0; i < vote; i++) 
    {
        starsHtml += '<i class="fas fa-star"></i>';
        count--;
    }

    for(let i = 0 ; i < count ; i++)
    {
        starsHtml += '<i class="fas fa-star" style= "color: #ddd"></i>';
    }
    // Costruisci l'HTML della recensione
    reviewItem.innerHTML = `
        <div class="review-header">
            <div class="reviewer">${feedback.username}</div>
            <div class="review-date">${feedback.ReviewDate}</div>
        </div>

        <div class="review-rating">
                ${starsHtml}
        </div>

        <p class="review-text">${feedback.text}</p> 
    `;
    
    // Aggiungi la recensione in cima alla lista
    reviewsList.insertBefore(reviewItem, reviewsList.firstChild);
}


//Listener per aggiunta del prodotto ai preferiti
document.addEventListener('DOMContentLoaded', function(){

    const btn = document.querySelector(".cuore-btn");

    btn.addEventListener('click', function(){

        const FavoritesIcon = btn.querySelector('.cuore-icon');
        const src = FavoritesIcon.getAttribute('src');

        if(src.includes('heart-icon.png')) //Caso in cui si effettua una richiesta di aggiunta del prodotto ai preferiti
        {
            addToWishlist(btn)
        }
        else if(src.includes('red-heart.png')) //Caso in cui si effettua una richiesta di rimozione del prodotto dai preferiti
        {
            removeFromWishlist(btn)
        }
    })

})


//Listener per visualizzazione del carrello modale
function setupCartButtonListeners() {
    document.querySelectorAll('.btn-carrello').forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.dataset.productId;
            const selectedColor = document.querySelector('.colore-option.active');
            const modelSelect = document.getElementById('modelSelect');
            
            if (!selectedColor) {
                showAlert('Seleziona un colore prima di aggiungere al carrello', 'warning');
                return;
            }
            
            const color = selectedColor.getAttribute('value') || selectedColor.getAttribute('data-color');
            
            fetchProductModalData(productId, color)
                .then(productData => {
                    // Qui gestirai l'apertura del modale con i dati
                    mostraModaleCarrello(productData,modelSelect.value, color);
                })
        });
    });
}


document.addEventListener('DOMContentLoaded', setupCartButtonListeners);


//Listener per aggiunta del prodotto al carrello nel pulsante di conferma del carrelo modale

function setupCartModalListeners() {
    document.querySelector('.confirm-btn').addEventListener('click', addToCart);
}

document.addEventListener('DOMContentLoaded', setupCartModalListeners)



//Listener per selettore dell'immagine in base al colore
document.addEventListener('DOMContentLoaded', addColorHoverListeners)


// Forza il reload della pagina se viene aperta dalla cronologia (navigazione "indietro"). Questo serve per far si che il contenuto dinamico venga rigenerato anche quando si torna con la freccia indietro del browser (che in genere ricarica la pagina cachata)
window.addEventListener("pageshow", function (event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            window.location.reload();
        }
    });





















