document.addEventListener('DOMContentLoaded', addColorHoverListeners);
document.addEventListener('DOMContentLoaded', setupCartButtonListeners);
document.addEventListener('DOMContentLoaded', setupCartModalListeners);
document.addEventListener('DOMContentLoaded', addWishlistEventListeners);



function setupCartButtonListeners() {
    document.querySelectorAll('.btn-carrello').forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.dataset.productId;
            const productCard = this.closest('.card-prodotto');
            const selectedColor = productCard.querySelector('.colore-option.active');
            
            if (!selectedColor) {
                showAlert('Seleziona un colore prima di aggiungere al carrello', 'warning');
                return;
            }
            
            const color = selectedColor.getAttribute('value') || selectedColor.getAttribute('data-color');
            
            // Mostra loader durante la richiesta
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Caricamento...';
            
            fetchProductModalData(productId, color)
                .then(productData => {
                    // Qui gestirai l'apertura del modale con i dati
                    mostraModaleCarrello(productData,null,color);
                })
                .finally(() => {
                    // Ripristina il bottone
                    this.innerHTML = `
                        <img src="${document.body.dataset.contextPath}/images/icons/cart-icon.png" 
                             alt="Aggiungi al carrello" class="carrello-icon"> Aggiungi
                    `;
                });
        });
    });
}

function setupCartModalListeners() {
    document.querySelector('.confirm-btn').addEventListener('click', addToCart);
}


function addWishlistEventListeners() 
{
    document.querySelectorAll('.cuore-btn').forEach(button => {
        button.addEventListener('click', function() {
            const FavoritesButton = button.querySelector('.cuore-icon');
            const src = FavoritesButton.getAttribute('src');

            if(src.includes('heart-icon.png')) //Caso in cui si effettua una richiesta di aggiunta del prodotto ai preferiti
            {
                addToWishlist(button)
            }
            else if(src.includes('red-heart.png')) //Caso in cui si effettua una richiesta di rimozione del prodotto dai preferiti
            {
                removeFromWishlist(button)
            }
        });
    });
}


// Forza il reload della pagina se viene aperta dalla cronologia (navigazione "indietro"). Questo serve per far si che il contenuto dinamico venga rigenerato anche quando si torna con la freccia indietro del browser (che in genere ricarica la pagina cachata)
window.addEventListener("pageshow", function (event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            window.location.reload();
        }
});

