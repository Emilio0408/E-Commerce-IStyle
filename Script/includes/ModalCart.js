//carrello modale
document.addEventListener("DOMContentLoaded", () => {
    const overlay = document.getElementById('overlay');
    if (overlay) overlay.addEventListener('click', chiudiModale);
});


function mostraModaleCarrello(productData, modello,color) {
    // Popola i dati base del prodotto

    document.getElementById('modal-name').innerText = productData.product.name;
    document.getElementById('modal-price').innerText = `€${productData.product.price.toFixed(2)}`;
    document.getElementById('modal-img').src = `${document.body.dataset.contextPath}/images/prodotti/${productData.image || productData.product.ImagesPaths[0]}`;
    document.getElementById('modal-color').innerText = `Colore: ${color} `;

    
    // Popola il menu a tendina con i modelli disponibili
    const modelSelect = document.getElementById('model-select');
    modelSelect.innerHTML = ''; 
    
    
    // Svuota le opzioni esistenti
    document.getElementById('modaleCarrello').dataset.productId = productData.product.id; //Utile in caso di conferma di aggiunta del prodotto al carrello
    // Salva il colore selezionato
    document.getElementById('modaleCarrello').dataset.selectedColor = color; //Utile in caso di conferma di aggiunta del prodotto al carrello



    if(modello != null)
    {
        const option = document.createElement('option');
        option.value = modello;
        option.textContent = modello;
        modelSelect.appendChild(option);
        modelSelect.value = modello;
        modelSelect.disabled = true;
    }
    else
    {
        // Aggiungi le opzioni dei modelli
        productData.models.forEach(model => {
            const option = document.createElement('option');
            option.value = model;
            option.textContent = model;
            modelSelect.appendChild(option);
        });
        
        // Se c'è un solo modello, selezionalo automaticamente
        if (productData.models.length === 1) {
            modelSelect.value = productData.models[0];
        }
    }

    // Mostra il modale
    document.getElementById('overlay').style.display = 'block';
    document.getElementById('modaleCarrello').style.display = 'block';
    document.body.style.overflow = 'hidden';
}

function chiudiModale() {
    document.getElementById('overlay').style.display = 'none';
    document.getElementById('modaleCarrello').style.display = 'none';
    document.body.style.overflow = 'auto';
}

