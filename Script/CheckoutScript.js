document.addEventListener('DOMContentLoaded', function() {
    // Gestione slider indirizzi
    const addressToggle = document.getElementById('address-toggle');
    addressToggle.addEventListener('change', function() {
        if (this.checked) {
            document.getElementById('saved-addresses').style.display = 'none';
            document.getElementById('new-address-form').style.display = 'block';
        } else {
            document.getElementById('saved-addresses').style.display = 'block';
            document.getElementById('new-address-form').style.display = 'none';
        }
    });
    
    // Gestione spedizione
    const shippingMethods = document.querySelectorAll('input[name="shippingMethod"]');
    shippingMethods.forEach(method => {
        method.addEventListener('change', updateTotal);
    });
    
});

//Per sommare i prezzi della spedizione
document.addEventListener('DOMContentLoaded', function() {
    // Seleziona tutti i radio button dei metodi di spedizione
    const shippingMethods = document.querySelectorAll('input[name="shippingMethod"]');
    const shippingCostElement = document.getElementById('shipping-cost');
    const grandTotalElement = document.getElementById('grand-total');
    
    // Ottieni il subtotale dal carrello (rimuovi il simbolo € e converti in numero)
    const subtotalText = document.getElementById('subtotal').textContent;
    const subtotal = parseFloat(subtotalText.replace('€', '').trim());
    
    // Aggiungi listener a tutti i radio button
    shippingMethods.forEach(method => {
        method.addEventListener('change', function() {
            if(this.checked) {
                // Ottieni il prezzo di spedizione dall'attributo data-price
                const shippingPrice = parseFloat(this.dataset.price);
                
                // Aggiorna il costo di spedizione visualizzato
                shippingCostElement.textContent = `€ ${shippingPrice.toFixed(2)}`;
                
                // Calcola e aggiorna il totale
                const grandTotal = subtotal + shippingPrice;
                grandTotalElement.textContent = `€ ${grandTotal.toFixed(2)}`;
            }
        });
    });
    
    // Attiva l'evento change sul metodo selezionato di default (Standard)
    document.querySelector('input[name="shippingMethod"]:checked').dispatchEvent(new Event('change'));
});


/*Richiesta di pagamento*/
document.addEventListener('DOMContentLoaded', function() {
    const proceedBtn = document.querySelector('.btn-primary');
    
    proceedBtn.addEventListener('click', async function(e) {
        e.preventDefault();
        
        // 1. Recupera i dati
        const shippingMethod = document.querySelector('input[name="shippingMethod"]:checked').value;
        const addressToggle = document.getElementById('address-toggle').checked;
        const shippingAddress = addressToggle 
            ? `${document.getElementById('address').value}, ${document.getElementById('zip').value} ${document.getElementById('city').value}, ${document.getElementById('country').value}`
            : document.getElementById('saved-address-select').value;

        if (!shippingAddress) {
            showAlert('Seleziona un indirizzo di spedizione', 'error');
            return;
        }

        // 2. Crea un form dinamico
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = `${document.body.dataset.contextPath}/checkout`;
        form.style.display = 'none';
        
        // 3. Aggiungi i campi al form
        const methodInput = document.createElement('input');
        methodInput.type = 'hidden';
        methodInput.name = 'shippingMethod';
        methodInput.value = shippingMethod;
        form.appendChild(methodInput);
        
        const addressInput = document.createElement('input');
        addressInput.type = 'hidden';
        addressInput.name = 'shippingAddress';
        addressInput.value = shippingAddress;
        form.appendChild(addressInput);
        
        // 4. Aggiungi il form al documento e invialo
        document.body.appendChild(form);
        form.submit();
        
        // 5. Mostra loader
        proceedBtn.disabled = true;
        proceedBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Elaborazione...';
    });
});