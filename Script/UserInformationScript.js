document.addEventListener("DOMContentLoaded", function() {
    // Inizializza lo stato del form
    let currentField = '';
    
    // Apri modale per modifica campo
    window.openEditForm = function(field) {
        currentField = field;
        const modal = document.getElementById('editModal');
        const modalTitle = document.getElementById('modal-title');
        const fieldLabel = document.getElementById('field-label');
        const editField = document.getElementById('edit-field');
        const confirmLabel = document.getElementById('confirm-label');
        const confirmField = document.getElementById('confirm-field');
        const passwordRequirements = document.getElementById('password-requirements');
        
        // Imposta titolo e label in base al campo
        let title = '';
        let label = '';
        let currentValue = '';
        let isPassword = false;
        
        switch(field) {
            case 'nome':
                title = 'Modifica Nome';
                label = 'Nuovo nome:';
                currentValue = document.getElementById('nome-value').textContent;
                break;
            case 'cognome':
                title = 'Modifica Cognome';
                label = 'Nuovo cognome:';
                currentValue = document.getElementById('cognome-value').textContent;
                break;
            case 'email':
                title = 'Modifica Email';
                label = 'Nuova email:';
                currentValue = document.getElementById('email-value').textContent;
                editField.type = 'email';
                break;
            case 'password':
                title = 'Modifica Password';
                label = 'Nuova password:';
                editField.type = 'password';
                passwordRequirements.style.display = 'block';
                confirmLabel.style.display = 'block';
                confirmField.style.display = 'block';
                isPassword = true;
                break;
            default:
                return; // Non permettere la modifica diretta degli indirizzi
        }
        
        modalTitle.textContent = title;
        fieldLabel.textContent = label;
        editField.value = currentValue;
        editField.focus();
        
        if (!isPassword) {
            passwordRequirements.style.display = 'none';
            confirmLabel.style.display = 'none';
            confirmField.style.display = 'none';
        }
        
        modal.style.display = 'flex';
    };
    
    // Chiudi modale
    window.closeEditForm = function() {
        document.getElementById('editModal').style.display = 'none';
        resetForm();
    };
    

    

    
    // Resetta il form
    function resetForm() {
        document.getElementById('edit-field').value = '';
        document.getElementById('confirm-field').value = '';
        document.getElementById('edit-field').type = 'text';
        document.getElementById('password-requirements').style.display = 'none';
        document.getElementById('confirm-label').style.display = 'none';
        document.getElementById('confirm-field').style.display = 'none';
        currentField = '';
    }
    
    // Apri modale per aggiungere indirizzo
    window.openAddAddressModal = function() {
        document.getElementById('addAddressModal').style.display = 'flex';
        document.getElementById('address-via').focus();
    };
    
    // Chiudi modale per aggiungere indirizzo
    window.closeAddAddressModal = function() {
        document.getElementById('addAddressModal').style.display = 'none';
        document.getElementById('addAddressForm').reset();
    };
    
    
    // Apri modale eliminazione account
    window.openDeleteAccountModal = function() {
        document.getElementById('deleteAccountModal').style.display = 'flex';
    };
    
    // Chiudi modale eliminazione account
    window.closeDeleteAccountModal = function() {
        document.getElementById('deleteAccountModal').style.display = 'none';
        document.getElementById('delete-password').value = '';
    };
    

    /*Listener associato al subit del form che avvolge il modale di modifica. Sostanzialmente nel momento in cui si apre un modale per la modifica e si clicca 
    il tasto salva che scatena il submit del form, si associa l'esecuzione della funzione handleFieldUpdate che imposta i parametri per la richiesta AJAX 
    che effettuerà la modifica effettiva */
    document.getElementById('editForm').addEventListener('submit', function(e) {
        e.preventDefault();
        handleFieldUpdate(currentField);
    });


    //Associazione del listener che farà partire la richiesta ajax al momento del submit del form degli indirizzi
    document.getElementById('addAddressForm').addEventListener('submit', saveNewAddress);
    
    // Aggiungi event listener per i pulsanti di eliminazione degli indirizzi esistenti
    document.querySelectorAll('.delete-address-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const addressSection = this.closest('.address-section');
            deleteAddress(addressSection);
        });
    });
    
});


/*Funzione di impostazione dei parametri e richiamo della richiesta AJAX*/
function handleFieldUpdate(field) 
{

    const editField = document.getElementById('edit-field');
    const confirmField = document.getElementById('confirm-field');
    const value = editField.value.trim();
    
    let action, data = {};
    
    switch(field) 
    {
        case 'nome':
            action = 'UpdateName';
            data.newName = value;
            break;
        case 'cognome':
            action = 'UpdateSurname';
            data.newSurname = value;
            break;
        case 'email':
            action = 'UpdateEmail';
            data.newEmail = value;
            break;
        case 'password':
            if (!validatePassword(value)) {
                alert('La password non soddisfa i requisiti di sicurezza');
                return;
            }
            if (value !== confirmField.value.trim()) {
                alert('Le password non coincidono');
                return;
            }
            action = 'UpdatePassword';
            data.newPassword = value;
            break;
        default:
            return;
    }
    
    data.action = action;
    
    // Invia la richiesta AJAX
    sendUpdateRequest(data, field);
}

function sendUpdateRequest(data, field) {
    fetch(`${document.body.dataset.contextPath}/user/information`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams(data)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Errore nella risposta del server');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            // Aggiorna l'interfaccia utente
            updateUIAfterSuccess(field, data);
            closeEditForm();
            showAlert('Operazione di modifica avvenuta con successo!', 'success');
        } else {
            showAlert('Errore durante l\'aggiornamento','error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('Si è verificato un errore durante l\'aggiornamento','error');
    });
}

function updateUIAfterSuccess(field, data) {
    switch(field) {
        case 'nome':
            document.getElementById('nome-value').textContent = data.newName || document.getElementById('edit-field').value;
            break;
        case 'cognome':
            document.getElementById('cognome-value').textContent = data.newSurname || document.getElementById('edit-field').value;
            break;
        case 'email':
            document.getElementById('email-value').textContent = data.newEmail || document.getElementById('edit-field').value;
            break;
        case 'password':
            // Non c'è bisogno di aggiornare nulla per la password
            break;
    }
}





/*Funzioni per aggiunta dell'indirizzo - RICHIESTA AJAX*/
function saveNewAddress(event) 
{
    event.preventDefault();
    
    // Recupera i valori dal form
    const tipologia = document.getElementById('address-type').value;
    const via = document.getElementById('address-via').value.trim();
    const nCivico = document.getElementById('address-n-civico').value.trim();
    const citta = document.getElementById('address-citta').value.trim();
    const cap = document.getElementById('address-cap').value.trim();
    const nazione = document.getElementById('address-nazione').value.trim();
    
    // Verifica che tutti i campi siano compilati
    if (!tipologia || !via || !nCivico || !citta || !cap || !nazione) {
        showAlert('error', 'Per favore, compila tutti i campi');
        return;
    }
    
    // Prepara i dati da inviare
    const formData = new URLSearchParams();
    formData.append('action', 'AddAddress');
    formData.append('Tipologia', tipologia);
    formData.append('Via', via);
    formData.append('NCivico', nCivico);
    formData.append('Citta', citta);
    formData.append('CAP', cap);
    formData.append('Nazione', nazione);
    
    // Recupera il context path dalla pagina
    const contextPath = document.body.getAttribute('data-context-path');
    
    // Effettua la richiesta AJAX
    fetch(`${contextPath}/user/information`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Errore nella risposta del server');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showAlert('Indirizzo aggiunto con successo!', 'success');
            closeAddAddressModal();

            
            // Aggiungi il nuovo indirizzo dinamicamente
            addNewAddressToUI({
                IDIndirizzo: data.data, 
                tipologia: tipologia,
                via: via,
                numeroCivico: nCivico,
                citta: citta,
                CAP: cap,
                nazione: nazione
            });
            
            // Resetta il form
            document.getElementById('addAddressForm').reset();
        } else {
            showAlert(data.message || 'Errore durante l\'aggiunta dell\'indirizzo', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert(data.message || 'Errore durante l\'aggiunta dell\'indirizzo', 'error');
    });
}

// Funzione per aggiungere il nuovo indirizzo all'interfaccia
function addNewAddressToUI(addressData) 
{
    const addressesContainer = document.querySelector('.addresses-container');
    
    // Rimuovi il messaggio "Nessun indirizzo" se presente
    const noAddressMessage = addressesContainer.querySelector('p');
    if (noAddressMessage && noAddressMessage.textContent.includes('Non ci sono indirizzi salvati')) {
        addressesContainer.removeChild(noAddressMessage);
    }
    
    // Crea il nuovo elemento indirizzo
    const addressSection = document.createElement('div');
    addressSection.className = 'address-section';
    addressSection.setAttribute('data-id-address', addressData.IDIndirizzo);
    
    addressSection.innerHTML = `
        <div class="address-header">
            <h3><i class="fas fa-home"></i> Indirizzo ${addressData.tipologia}</h3>
            <button class="delete-address-btn">
                <i class="fas fa-trash"></i>
            </button>
        </div>
        <div class="address-info">
            <p><span class="info-label">Via:</span> <span>${addressData.via}, ${addressData.numeroCivico}</span></p>
            <p><span class="info-label">Città:</span> <span>${addressData.citta}</span></p>
            <p><span class="info-label">CAP:</span> <span>${addressData.CAP}</span></p>
            <p><span class="info-label">Nazione:</span> <span>${addressData.nazione}</span></p>
        </div>
    `;
    
    // Aggiungi l'evento per l'eliminazione
    const deleteBtn = addressSection.querySelector('.delete-address-btn');
    deleteBtn.addEventListener('click', function() {
        const addressSection = this.closest('.address-section');
        deleteAddress(addressSection);
    });
    
    // Aggiungi il nuovo indirizzo al container
    addressesContainer.appendChild(addressSection);
}



// FUNZIONI PER ELIMINAZIONE DI UN INDIRIZZO - RICHIESTA AJAX
function deleteAddress(addressElement) 
{
    if (!confirm('Sei sicuro di voler eliminare questo indirizzo?')) 
    {
        return;
    }

    console.log(addressElement)
    const contextPath = document.body.getAttribute('data-context-path');
    const formData = new URLSearchParams();
    const addressId = addressElement.getAttribute('data-id-address');
    formData.append('action', 'RemoveAddress');
    formData.append('IDAddress', addressId);

    fetch(`${contextPath}/user/information`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Errore nella risposta del server');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showAlert('Indirizzo rimosso con successo','success');
            // Rimuovi l'elemento dalla UI
            addressElement.remove();
            
            // Se non ci sono più indirizzi, mostra il messaggio
            const addressesContainer = document.querySelector('.addresses-container');
            if (addressesContainer.querySelectorAll('.address-section').length === 0) {
                addressesContainer.innerHTML = '<p style="text-align:center">Non ci sono indirizzi salvati, clicca il pulsante "aggiungi indirizzo" per inserirne uno nuovo</p>';
            }
        } else {
            showAlert('Errore durante la rimozione dell\'indirizzo','error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('Errore durante la rimozione dell\'indirizzo','error');
    });
}



    // Validazione password
function validatePassword(password) 
{
        const minLength = 8;
        const hasUpperCase = /[A-Z]/.test(password);
        const hasNumber = /[0-9]/.test(password);
        const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
        
        return password.length >= minLength && hasUpperCase && hasNumber && hasSpecialChar;
}