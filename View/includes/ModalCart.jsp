<div id="overlay" class="overlay" style="display:none;"></div>

<div id="modaleCarrello" class="cart-modal" role="dialog" aria-modal="true" tabindex="-1" style="display:none;">
    <div class="modal-header">
        <div class="modal-title">
            <svg class="icon" viewBox="0 0 24 24">
                <path fill-rule="evenodd" clip-rule="evenodd" d="..."></path>
            </svg>
            <span>Aggiungi al carrello</span>
        </div>
        <button class="close-btn" onclick="chiudiModale()" aria-label="Chiudi">
            <svg class="icon" viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" fill-rule="evenodd" clip-rule="evenodd" 
                    d="M12 10.586l4.95-4.95 1.414 1.414-4.95 4.95 4.95 4.95-1.414 1.414-4.95-4.95-4.95 4.95-1.414-1.414 4.95-4.95-4.95-4.95L7.05 5.636l4.95 4.95z">
                </path>
            </svg>
        </button>
    </div>

    <div class="modal-body">
        <div class="added-product">
            <img id="modal-img" src="" alt="Cover" class="product-image">
            <div class="product-info">
                <div id="modal-name" class="product-name"></div>
                <div class="product-description">Cover per iPhone</div>
                <div class="product-description" id="modal-color"></div>
                <div id="modal-price" class="product-price"></div>
            </div>
        </div>

    
    <div class="model-selection">
            <label for="model-select" class="model-label">Seleziona modello:</label>
            <select id="model-select" class="model-select">
                <!-- Le opzioni verranno aggiunte dinamicamente via JavaScript -->
            </select>
        </div>
    </div>


    <div class="modal-footer">
        <button class="continue-btn" onclick="chiudiModale()">Continua gli acquisti</button>
        <button class="confirm-btn">Conferma</button>
    </div>
</div>