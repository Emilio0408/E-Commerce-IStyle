

//SETUP
document.addEventListener('DOMContentLoaded', function() {
    setupEventListeners();

});

function setupEventListeners()
{
    setupCartButtonListeners();
    setupCartModalListeners();
    setupFilters();
    addWishlistEventListeners();
    addColorHoverListeners();
}


//FUNZIONI PER IL SETUP
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


function setupFilters()
{
    document.querySelector('.btn-apply-filters').addEventListener('click', function() {
        applyFilters();
    });
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





//GESTIONE SIDEBAR FILTRI
document.addEventListener("DOMContentLoaded", function () 
{
    // Toggle menu filtri
    document.querySelectorAll(".filtro-btn").forEach(btn => {
        btn.addEventListener("click", function () {
            document.querySelectorAll(".menu-filtri").forEach(menu => {
                if (menu !== btn.nextElementSibling) menu.style.display = "none";
            });
            const menu = btn.nextElementSibling;
            menu.style.display = menu.style.display === "block" ? "none" : "block";
        });
    });

    document.addEventListener("click", e => {
        if (!e.target.closest(".sidebar"))
            document.querySelectorAll(".menu-filtri").forEach(menu => menu.style.display = "none");
    });

    // Price Slider Logic
    const rangeInput = document.querySelectorAll(".range-input input"),
        priceInput = document.querySelectorAll(".price-input input"),
        progress = document.querySelector(".slider .progress");
    let priceGap = 10; // Minimum price difference

    // Set initial progress style
    progress.style.left = (rangeInput[0].value / rangeInput[0].max) * 100 + "%";
    progress.style.right = 100 - (rangeInput[1].value / rangeInput[1].max) * 100 + "%";
    progress.style.background = "#1E89E3";

    priceInput.forEach(input => {
        input.addEventListener("input", e => {
            let minVal = parseInt(priceInput[0].value),
                maxVal = parseInt(priceInput[1].value);
            
            if ((maxVal - minVal >= priceGap) && maxVal <= 100 && minVal >= 0) {
                if (e.target.className === "input-min") {
                    rangeInput[0].value = minVal;
                    progress.style.left = (minVal / rangeInput[0].max) * 100 + "%";
                } else {
                    rangeInput[1].value = maxVal;
                    progress.style.right = 100 - (maxVal / rangeInput[1].max) * 100 + "%";
                }
            }
        });
    });

    rangeInput.forEach(input => {
        input.addEventListener("input", e => {
            let minVal = parseInt(rangeInput[0].value),
                maxVal = parseInt(rangeInput[1].value);

            if (maxVal - minVal < priceGap) {
                if (e.target.className === "range-min") {
                    rangeInput[0].value = maxVal - priceGap;
                } else {
                    rangeInput[1].value = minVal + priceGap;
                }
            } else {
                priceInput[0].value = minVal;
                priceInput[1].value = maxVal;
                progress.style.left = (minVal / rangeInput[0].max) * 100 + "%";
                progress.style.right = 100 - (maxVal / rangeInput[1].max) * 100 + "%";
            }
        });
    });
});




//Selezione del colore sulla sidebar
function selectColor() {
    const colorOptions = document.querySelectorAll(".colore-option");
    
    colorOptions.forEach(option => {
        option.addEventListener('click', function() {
            // Aggiunge o rimuove 'active' SOLO sull'elemento cliccato
            this.classList.toggle('active');
        });
    });
}




/*RICHIESTA AJAX PER OTTENERE I PRODOTTI FILTRATI*/
function applyFilters() {
    // Raccoglie tutti i parametri di filtro
    const params = new URLSearchParams();
    
    // 1. Categorie (dalla sezione CATEGORIE)
    const categoryCheckboxes = document.querySelectorAll('#categorie-menu input[type="checkbox"]:checked');
    categoryCheckboxes.forEach(checkbox => {
        params.append('category', checkbox.parentElement.textContent.trim());
    });
    
    // 2. Range di prezzo (dalla sezione PREZZO)
    const pMin = document.querySelector('.input-min').value;
    const pMax = document.querySelector('.input-max').value;
    if (pMin) params.append('p_min', pMin);
    if (pMax) params.append('p_max', pMax);
    
    // 3. Colori (dalla sezione TUTTI I FILTRI)
    const selectedColorCheckboxes = document.querySelectorAll('#filtri-menu .selettori-colore-filters input[type="checkbox"]:checked');
    const selectedColors = Array.from(selectedColorCheckboxes).map(checkbox => {
        // Prende il testo della label e lo converte in minuscolo per uniformità
        return checkbox.parentElement.textContent.trim().toLowerCase();
    });
    selectedColors.forEach(color => {
        params.append('color', color);
    });
    
    // 4. Modelli (dalla sezione TUTTI I FILTRI)
    const modelCheckboxes = document.querySelectorAll('#filtri-menu input[type="checkbox"]:checked:not(.selettori-colore-filters input)');
    modelCheckboxes.forEach(checkbox => {
        params.append('model', checkbox.parentElement.textContent.trim());
    });
    
    // Costruisce l'URL completo per la richiesta GET
    const contextPath = document.body.getAttribute('data-context-path');
    const url = `${contextPath}/product?action=Filter&${params.toString()}`;
    

    // Effettua la richiesta AJAX
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
        console.log(data.data);
        if (data.success && data.data) {
            updateProductGrid(data.data); // Aggiorna la griglia dei prodotti
        } else if (data.data === undefined) {
            showAlert('Nessun prodotto trovato con i filtri selezionati', 'info');
            // Potresti anche svuotare la griglia in questo caso
            document.querySelector('.griglia-prodotti').innerHTML = '<p>Nessun prodotto trovato con i filtri selezionati</p>';
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('Si è verificato un errore durante il filtraggio', 'error');
    });
}

function updateProductGrid(products) 
{
    const productGrid = document.querySelector('.griglia-prodotti');
    productGrid.innerHTML = ''; // Svuota la griglia corrente
    

    if (products.length === 0) {
        productGrid.innerHTML = '<p>Nessun prodotto trovato con i filtri selezionati</p>';
        return;
    }


    
    // Ricostruisce la griglia con i nuovi prodotti
    products.forEach(product => {
        const productCard = document.createElement('div');
        productCard.className = 'card-prodotto';
        productCard.dataset.productId = product.id;

        let colorSelectorsHTML = '';



        if (product.avaibleColors && Object.keys(product.avaibleColors).length > 0) {


            colorSelectorsHTML = '<div class="selettori-colore">';
            
            Object.entries(product.avaibleColors).forEach(([colorName,hexCode]) => {
                // Assumendo che color sia un oggetto con codice e nome es: {hex: "#2f3130", name: "nero"}

                if(product.ImagesPaths[0].includes(colorName))
                {
                    colorSelectorsHTML += `
                        <span class="colore-option active" 
                            style="background-color: ${hexCode};" 
                            data-color="${colorName}"></span>`;
                }
                else
                {
                    colorSelectorsHTML += `
                        <span class="colore-option" 
                            style="background-color: ${hexCode};" 
                            data-color="${colorName}"></span>`;
                }


            });
            
            colorSelectorsHTML += '</div>';
        }

        
        
        // Qui costruisci la card del prodotto come nel tuo JSP
        // Esempio semplificato:
        productCard.innerHTML = `
            <button class="cuore-btn" data-product-id="${product.id}">
                <img src="${product.isInWishList ? 
                    document.body.getAttribute('data-context-path') + '/images/icons/red-heart.png' : 
                    document.body.getAttribute('data-context-path') + '/images/icons/heart-icon.png'}" 
                    alt="Preferiti" class="cuore-icon">
            </button>
            <a href="${document.body.getAttribute('data-context-path')}/product/${product.name}">
                <img src="${document.body.getAttribute('data-context-path')}/images/prodotti/${product.ImagesPaths[0]}" 
                    alt="${product.name}" class="img-prodotto">
            </a>
            <a href="${document.body.getAttribute('data-context-path')}/product/${product.name}" 
                class="nome-prodotto">${product.name}</a>
            <div class="prezzo">
                €${product.price.toFixed(2)}<span class="prezzo-scontato">€${(product.price + 5).toFixed(2)}</span>
            </div>
            ${colorSelectorsHTML}
            <button class="btn-carrello" data-product-id="${product.id}">
                <img src="${document.body.getAttribute('data-context-path')}/images/icons/cart-icon.png" 
                    alt="Aggiungi al carrello" class="carrello-icon"> Aggiungi
            </button>`;
        
        productGrid.appendChild(productCard);
    });
    
    // Aggiungi gli event listener ai nuovi elementi se necessario
    setupCartButtonListeners();
    addWishlistEventListeners();
    addColorHoverListeners()
}


// Forza il reload della pagina se viene aperta dalla cronologia (navigazione "indietro"). Questo serve per far si che il contenuto dinamico venga rigenerato anche quando si torna con la freccia indietro del browser (che in genere ricarica la pagina cachata)
window.addEventListener("pageshow", function (event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            window.location.reload();
        }
    });









