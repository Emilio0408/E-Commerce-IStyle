/**
 * AdminRequests.js
 * Libreria JavaScript per gestire le chiamate AJAX delle funzionalità amministrative
 */

// ===========================================
// UTILITÀ GENERALI
// ===========================================

/**
 * Mostra un messaggio di successo
 */
function showSuccessMessage(message) {
    const successDiv = document.getElementById('successMessage');
    if (successDiv) {
        successDiv.textContent = message;
        successDiv.style.display = 'block';
        
        // Nascondi il messaggio dopo 5 secondi
        setTimeout(() => {
            successDiv.style.display = 'none';
        }, 5000);
    }
}

/**
 * Mostra un messaggio di errore
 */
function showErrorMessage(message) {
    const errorDiv = document.getElementById('errorMessage');
    if (errorDiv) {
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        
        // Nascondi il messaggio dopo 8 secondi
        setTimeout(() => {
            errorDiv.style.display = 'none';
        }, 8000);
    }
}

/**
 * Mostra/nascondi il loading indicator
 */
function toggleLoading(show = true) {
    const loadingDiv = document.getElementById('loading');
    if (loadingDiv) {
        loadingDiv.style.display = show ? 'block' : 'none';
    }
}

/**
 * Formatta una data per la visualizzazione
 */
function formatDate(dateString) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleDateString('it-IT') + ' ' + date.toLocaleTimeString('it-IT');
}

/**
 * Formatta un prezzo per la visualizzazione
 */
function formatPrice(price) {
    return new Intl.NumberFormat('it-IT', {
        style: 'currency',
        currency: 'EUR'
    }).format(price);
}

// ===========================================
// GESTIONE PRODOTTI
// ===========================================

/**
 * Carica tutti i prodotti e aggiorna la tabella
 */
async function loadProducts() {
    toggleLoading(true);
    
    try {
        const response = await fetch(`${contextPath}/admin/products?action=list`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const data = await response.json();
        
        if (data.success) {
            displayProductsTable(data.products);
        } else {
            showErrorMessage(data.error || 'Errore nel caricamento dei prodotti');
        }
        
    } catch (error) {
        console.error('Errore:', error);
        showErrorMessage('Errore di connessione durante il caricamento dei prodotti');
    } finally {
        toggleLoading(false);
    }
}

/**
 * Visualizza i prodotti nella tabella
 */
function displayProductsTable(products) {
    const tbody = document.getElementById('productsTableBody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    products.forEach(product => {
        const row = createProductRow(product);
        tbody.appendChild(row);
    });
    
    // Aggiorna i listener per i checkbox
    updateProductCheckboxListeners();
}

/**
 * Crea una riga della tabella prodotti
 */
function createProductRow(product) {
    const tr = document.createElement('tr');


    console.log(product)
    
    // Calcola stock totale
    const totalStock = product.varianti.reduce((sum, variant) => sum + variant.quantita, 0);
    
    // Prima immagine o placeholder
    const firstImage = product.immagini.length > 0 ? 
        `<img src="${contextPath}/images/prodotti/${product.immagini[0]}" alt="${product.nome}" style="width: 50px; height: 50px; object-fit: cover;">` :
        '<i class="fas fa-image" style="font-size: 30px; color: #ccc;"></i>';
    
    tr.innerHTML = `
        <td><input type="checkbox" class="product-checkbox" data-id="${product.id}"></td>
        <td>${firstImage}</td>
        <td>${escapeHtml(product.nome)}</td>
        <td>${escapeHtml(product.categoria)}</td>
        <td>${formatPrice(product.prezzo)}</td>
        <td>
            <span class="variant-count">${product.varianti.length} varianti</span>
            <button class="btn-small btn-info" onclick="showProductVariants(${product.id})">
                <i class="fas fa-eye"></i>
            </button>
        </td>
        <td><span class="stock-total">${totalStock}</span></td>
        <td>
            <span class="customizable-badge ${product.personalizzabile ? 'customizable-yes' : 'customizable-no'}">
                ${product.personalizzabile ? 'Sì' : 'No'}
            </span>
        </td>
        <td>
            <button class="btn-small btn-warning" onclick="editProduct(${product.id})">
                <i class="fas fa-edit"></i>
            </button>
            <button class="btn-small btn-danger" onclick="deleteProduct(${product.id})">
                <i class="fas fa-trash"></i>
            </button>
        </td>
    `;
    
    return tr;
}

/**
 * Gestisce il submit del form prodotto (creazione/modifica)
 */
async function handleProductSubmit(event) {
    event.preventDefault();
    
    const form = document.getElementById('productForm');
    const formData = new FormData(form);
    
    // Aggiungi action per creazione o aggiornamento
    const productId = document.getElementById('productId').value;
    formData.append('action', productId ? 'update' : 'create');
    
    // Aggiungi varianti al form data
    addVariantsToFormData(formData);
    
    toggleLoading(true);
    
    try {
        const response = await fetch(`${contextPath}/admin/products`, {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: formData
        });
        
        const data = await response.json();
        
        if (data.success) {
            showSuccessMessage(data.message);
            document.getElementById('productModal').style.display = 'none';
            loadProducts(); // Ricarica la tabella
        } else {
            showErrorMessage(data.error || 'Errore durante il salvataggio del prodotto');
        }
        
    } catch (error) {
        console.error('Errore:', error);
        showErrorMessage('Errore di connessione durante il salvataggio');
    } finally {
        toggleLoading(false);
    }
}

/**
 * Aggiunge le varianti al FormData
 */
function addVariantsToFormData(formData) {
    const variationItems = document.querySelectorAll('.variation-item');
    
    variationItems.forEach((item, index) => {
        const colore = item.querySelector('.variation-color').value;
        const codiceColore = item.querySelector('.variation-color-code').value;
        const modello = item.querySelector('.variation-model').value;
        const quantita = item.querySelector('.variation-quantity').value;
        
        if (colore && modello) {
            formData.append('colore[]', colore);
            formData.append('codiceColore[]', codiceColore || '#000000');
            formData.append('modello[]', modello);
            formData.append('quantita[]', quantita || '0');
        }
    });
}

/**
 * Aggiunge una nuova riga per variante prodotto
 */
function addVariationRow() {
    const container = document.getElementById('variationsContainer');
    const variationDiv = document.createElement('div');
    variationDiv.className = 'variation-item';
    
    variationDiv.innerHTML = `
        <div class="color-input">
            <input type="text" class="variation-color" placeholder="Nome colore" required>
            <input type="color" class="variation-color-code" title="Codice colore">
        </div>
        <input type="text" class="variation-model" placeholder="Modello" required>
        <input type="number" class="variation-quantity" placeholder="Quantità" min="0" value="0">
        <button type="button" class="btn-remove-variation" onclick="removeVariationRow(this)">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    container.appendChild(variationDiv);
}

/**
 * Rimuove una riga variante
 */
function removeVariationRow(button) {
    const variationItem = button.closest('.variation-item');
    if (variationItem) {
        variationItem.remove();
    }
}

/**
 * Reset del form prodotto
 */
function resetProductForm() {
    document.getElementById('productForm').reset();
    document.getElementById('productId').value = '';
    
    // Reset varianti
    const container = document.getElementById('variationsContainer');
    container.innerHTML = '';
    addVariationRow(); // Aggiungi una variante di default
    
    // Reset preview immagini
    const imagePreview = document.getElementById('imagePreview');
    if (imagePreview) {
        imagePreview.innerHTML = '';
    }
}

/**
 * Gestisce l'anteprima delle immagini selezionate
 */
function handleImagePreview(event) {
    const files = event.target.files;
    const preview = document.getElementById('imagePreview');
    
    preview.innerHTML = '';
    
    Array.from(files).forEach(file => {
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.style.width = '100px';
                img.style.height = '100px';
                img.style.objectFit = 'cover';
                img.style.margin = '5px';
                img.style.border = '1px solid #ddd';
                preview.appendChild(img);
            };
            reader.readAsDataURL(file);
        }
    });
}

/**
 * Aggiorna i listener per i checkbox dei prodotti
 */
function updateProductCheckboxListeners() {
    const checkboxes = document.querySelectorAll('.product-checkbox');
    checkboxes.forEach(cb => {
        cb.addEventListener('change', updateSelectedProducts);
    });
}

/**
 * Aggiorna la lista dei prodotti selezionati
 */
function updateSelectedProducts() {
    const checkboxes = document.querySelectorAll('.product-checkbox:checked');
    const deleteBtn = document.getElementById('deleteSelectedBtn');
    
    selectedProductIds = Array.from(checkboxes).map(cb => cb.dataset.id);
    
    if (deleteBtn) {
        deleteBtn.style.display = selectedProductIds.length > 0 ? 'inline-block' : 'none';
    }
}

/**
 * Elimina i prodotti selezionati
 */
async function deleteSelectedProducts() {
    if (selectedProductIds.length === 0) {
        showErrorMessage('Nessun prodotto selezionato');
        return;
    }
    
    if (!confirm(`Sei sicuro di voler eliminare ${selectedProductIds.length} prodotti selezionati?`)) {
        return;
    }
    
    toggleLoading(true);
    
    try {
        const promises = selectedProductIds.map(id => 
            fetch(`${contextPath}/admin/products?action=delete&id=${id}`, {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
        );
        
        const responses = await Promise.all(promises);
        const results = await Promise.all(responses.map(r => r.json()));
        
        const successful = results.filter(r => r.success).length;
        const failed = results.length - successful;
        
        if (successful > 0) {
            showSuccessMessage(`${successful} prodotti eliminati con successo`);
        }
        
        if (failed > 0) {
            showErrorMessage(`${failed} prodotti non sono stati eliminati`);
        }
        
        // Reset selezione
        document.getElementById('selectAll').checked = false;
        selectedProductIds = [];
        
        loadProducts();
        
    } catch (error) {
        console.error('Errore:', error);
        showErrorMessage('Errore durante l\'eliminazione dei prodotti');
    } finally {
        toggleLoading(false);
    }
}

/**
 * Modifica un prodotto esistente
 */
async function editProduct(productId) {
    try {
        const response = await fetch(`${contextPath}/admin/products?action=get&id=${productId}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const data = await response.json();
        
        if (data.success) {
            populateProductForm(data.product);
            document.getElementById('modalTitle').textContent = 'Modifica Prodotto';
            document.getElementById('productModal').style.display = 'block';
        } else {
            showErrorMessage(data.error || 'Errore nel caricamento del prodotto');
        }
        
    } catch (error) {
        console.error('Errore:', error);
        showErrorMessage('Errore di connessione');
    }
}

/**
 * Popola il form con i dati del prodotto da modificare
 */
function populateProductForm(product) {
    document.getElementById('productId').value = product.id;
    document.getElementById('productName').value = product.nome;
    document.getElementById('productCategory').value = product.categoria;
    document.getElementById('productPrice').value = product.prezzo;
    document.getElementById('productDescription').value = product.descrizione;
    document.getElementById('productCustomizable').checked = product.personalizzabile;
}

/**
 * Elimina un singolo prodotto
 */
async function deleteProduct(productId) {
    if (!confirm('Sei sicuro di voler eliminare questo prodotto?')) {
        return;
    }
    
    toggleLoading(true);
    
    try {
        const response = await fetch(`${contextPath}/admin/products`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `action=delete&id=${productId}`
        });
        
        const data = await response.json();
        
        if (data.success) {
            showSuccessMessage(data.message);
            loadProducts();
        } else {
            showErrorMessage(data.error || 'Errore durante l\'eliminazione del prodotto');
        }
        
    } catch (error) {
        console.error('Errore:', error);
        showErrorMessage('Errore di connessione durante l\'eliminazione');
    } finally {
        toggleLoading(false);
    }
}

// ===========================================
// GESTIONE ORDINI
// ===========================================

/**
 * Carica tutti gli ordini con filtri
 */
async function loadOrders() {
    toggleLoading(true);
    
    const params = new URLSearchParams({
        action: 'list',
        user: currentFilters.user,
        status: currentFilters.status,
        sort: currentFilters.sort,
        limit: currentFilters.limit.toString(),
        offset: currentFilters.offset.toString()
    });
    
    try {
        const response = await fetch(`${contextPath}/admin/orders?${params}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const data = await response.json();
        
        if (data.success) {
            displayOrdersTable(data.orders);
            updatePagination(data.total, data.limit, data.offset);
        } else {
            showErrorMessage(data.error || 'Errore nel caricamento degli ordini');
        }
        
    } catch (error) {
        console.error('Errore:', error);
        showErrorMessage('Errore di connessione durante il caricamento degli ordini');
    } finally {
        toggleLoading(false);
    }
}

/**
 * Visualizza gli ordini nella tabella
 */
function displayOrdersTable(orders) {
    const tbody = document.getElementById('ordersTableBody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    orders.forEach(order => {
        const row = createOrderRow(order);
        tbody.appendChild(row);
    });
}

/**
 * Crea una riga della tabella ordini
 */
function createOrderRow(order) {
    const tr = document.createElement('tr');
    
    const statusClass = `status-${order.stato.toLowerCase().replace(' ', '-')}`;
    
    tr.innerHTML = `
        <td>#${order.id}</td>
        <td>${escapeHtml(order.username)}</td>
        <td>${escapeHtml(order.nomeCompleto || 'N/A')}</td>
        <td>${escapeHtml(order.email || 'N/A')}</td>
        <td>${formatDate(order.dataEmissione)}</td>
        <td>${formatPrice(order.importoTotale)}</td>
        <td>
            <span class="status-badge ${statusClass}">
                ${escapeHtml(order.stato)}
            </span>
        </td>
        <td>
            <button class="btn-small btn-info" onclick="showOrderDetails(${order.id})">
                <i class="fas fa-eye"></i>
            </button>
            <button class="btn-small btn-warning" onclick="showStatusModal(${order.id}, '${order.stato}')">
                <i class="fas fa-edit"></i>
            </button>
        </td>
    `;
    
    return tr;
}

/**
 * Carica la lista degli utenti per il filtro
 */
async function loadUsers() {
    try {
        const response = await fetch(`${contextPath}/admin/orders?action=users`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const data = await response.json();
        
        if (data.success) {
            populateUsersFilter(data.users);
        }
        
    } catch (error) {
        console.error('Errore nel caricamento utenti:', error);
    }
}

/**
 * Popola il filtro utenti
 */
function populateUsersFilter(users) {
    const select = document.getElementById('userFilter');
    if (!select) return;
    
    // Mantieni l'opzione "Tutti gli utenti"
    const allOption = select.querySelector('option[value=""]');
    select.innerHTML = '';
    select.appendChild(allOption);
    
    users.forEach(user => {
        const option = document.createElement('option');
        option.value = user.username;
        option.textContent = `${user.username} (${user.nomeCompleto})`;
        select.appendChild(option);
    });
}

/**
 * Carica le statistiche degli ordini
 */
async function loadOrderStats() {
    try {
        const response = await fetch(`${contextPath}/admin/orders?action=stats`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const data = await response.json();
        
        if (data.success) {
            displayOrderStats(data.stats);
        }
        
    } catch (error) {
        console.error('Errore nel caricamento delle statistiche:', error);
    }
}

/**
 * Visualizza le statistiche degli ordini
 */
function displayOrderStats(stats) {
    const container = document.getElementById('statsContainer');
    if (!container) return;
    
    container.innerHTML = `
        <div class="stat-card">
            <div class="stat-number">${stats.totalOrders || 0}</div>
            <div class="stat-label">Ordini Totali</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${formatPrice(stats.totalRevenue || 0)}</div>
            <div class="stat-label">Ricavi Totali</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${stats.pendingOrders || 0}</div>
            <div class="stat-label">In Elaborazione</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${stats.completedOrders || 0}</div>
            <div class="stat-label">Completati</div>
        </div>
    `;
}

/**
 * Mostra i dettagli di un ordine
 */
async function showOrderDetails(orderId) {
    try {
        const response = await fetch(`${contextPath}/admin/orders?action=details&id=${orderId}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const data = await response.json();
        
        if (data.success) {
            displayOrderDetails(data.order);
        } else {
            showErrorMessage(data.error || 'Errore nel caricamento dei dettagli ordine');
        }
        
    } catch (error) {
        console.error('Errore:', error);
        showErrorMessage('Errore di connessione');
    }
}

/**
 * Visualizza i dettagli dell'ordine nel modal
 */
function displayOrderDetails(order) {
    const modal = document.getElementById('orderDetailsModal');
    const content = document.getElementById('orderDetailsContent');
    const title = document.getElementById('orderModalTitle');
    
    title.textContent = `Dettagli Ordine #${order.id}`;
    
    let productsHtml = '';
    if (order.prodotti && order.prodotti.length > 0) {
        productsHtml = order.prodotti.map(product => `
            <div class="order-product-item">
                <div>
                    <strong>${escapeHtml(product.nome)}</strong><br>
                    <small>Colore: ${escapeHtml(product.colore)} | Modello: ${escapeHtml(product.modello)}</small>
                </div>
                <div>
                    ${product.quantita}x ${formatPrice(product.prezzo)}
                </div>
                <div>
                    <strong>${formatPrice(product.subtotale)}</strong>
                </div>
            </div>
        `).join('');
    }
    
    content.innerHTML = `
        <div class="order-info">
            <div class="form-row">
                <div><strong>Username:</strong> ${escapeHtml(order.username)}</div>
                <div><strong>Stato:</strong> ${escapeHtml(order.stato)}</div>
            </div>
            <div class="form-row">
                <div><strong>Data Emissione:</strong> ${formatDate(order.dataEmissione)}</div>
                <div><strong>Importo Totale:</strong> ${formatPrice(order.importoTotale)}</div>
            </div>
            <div class="form-row">
                <div><strong>Metodo Spedizione:</strong> ${escapeHtml(order.metodoDiSpedizione)}</div>
                <div><strong>Tipo Pagamento:</strong> ${escapeHtml(order.tipoPagamento)}</div>
            </div>
            <div><strong>Indirizzo Spedizione:</strong></div>
            <div>${escapeHtml(order.indirizzoSpedizione)}</div>
        </div>
        
        <h4>Prodotti Ordinati</h4>
        <div class="order-products">
            ${productsHtml}
        </div>
    `;
    
    modal.style.display = 'block';
}

/**
 * Mostra il modal per modificare lo stato dell'ordine
 */
function showStatusModal(orderId, currentStatus) {
    document.getElementById('statusOrderId').value = orderId;
    document.getElementById('newOrderStatus').value = currentStatus;
    document.getElementById('statusModal').style.display = 'block';
}

/**
 * Gestisce l'aggiornamento dello stato ordine
 */
async function handleStatusUpdate(event) {
    event.preventDefault();
    
    const orderId = document.getElementById('statusOrderId').value;
    const newStatus = document.getElementById('newOrderStatus').value;
    
    if (!newStatus) {
        showErrorMessage('Seleziona un nuovo stato');
        return;
    }
    
    toggleLoading(true);
    
    try {
        const response = await fetch(`${contextPath}/admin/orders`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `action=updateStatus&id=${orderId}&status=${encodeURIComponent(newStatus)}`
        });
        
        const data = await response.json();
        
        if (data.success) {
            showSuccessMessage(data.message);
            document.getElementById('statusModal').style.display = 'none';
            loadOrders(); // Ricarica la tabella
        } else {
            showErrorMessage(data.error || 'Errore durante l\'aggiornamento dello stato');
        }
        
    } catch (error) {
        console.error('Errore:', error);
        showErrorMessage('Errore di connessione');
    } finally {
        toggleLoading(false);
    }
}

/**
 * Aggiorna i controlli di paginazione
 */
function updatePagination(total, limit, offset) {
    totalPages = Math.ceil(total / limit);
    currentPage = Math.floor(offset / limit) + 1;
    
    const prevBtn = document.getElementById('prevPageBtn');
    const nextBtn = document.getElementById('nextPageBtn');
    const pageInfo = document.getElementById('pageInfo');
    
    if (prevBtn) prevBtn.disabled = currentPage <= 1;
    if (nextBtn) nextBtn.disabled = currentPage >= totalPages;
    if (pageInfo) pageInfo.textContent = `Pagina ${currentPage} di ${totalPages}`;
}

// ===========================================
// UTILITÀ HTML
// ===========================================

/**
 * Escape HTML per prevenire XSS
 */
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}