<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.IStyle.model.bean.User" %>
<%
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Prodotti - Admin iStyle</title>
  <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/AdminProductStyles.css"%>">
  <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    .loading {
      display: none;
      text-align: center;
      padding: 20px;
    }
    .error-message {
      background-color: #f8d7da;
      color: #721c24;
      padding: 10px;
      border-radius: 4px;
      margin-bottom: 20px;
      display: none;
    }
    .success-message {
      background-color: #d4edda;
      color: #155724;
      padding: 10px;
      border-radius: 4px;
      margin-bottom: 20px;
      display: none;
    }
    .variations-container {
      border: 1px solid #ddd;
      padding: 15px;
      margin-bottom: 15px;
      border-radius: 4px;
    }
    .variation-item {
      display: flex;
      gap: 10px;
      align-items: center;
      margin-bottom: 10px;
    }
    .variation-item input {
      flex: 1;
    }
    .btn-remove-variation {
      background: #dc3545;
      color: white;
      border: none;
      padding: 5px 10px;
      border-radius: 4px;
      cursor: pointer;
    }
    .btn-add-variation {
      background: #28a745;
      color: white;
      border: none;
      padding: 5px 10px;
      border-radius: 4px;
      cursor: pointer;
    }
    .color-input {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .color-preview {
      width: 30px;
      height: 30px;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
  </style>
</head>
<body>


  <div class="admin-container">
    <!-- Messaggi di feedback -->
    <div id="successMessage" class="success-message"></div>
    <div id="errorMessage" class="error-message"></div>
    
    <!-- Loading indicator -->
    <div id="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Caricamento...
    </div>

    <!-- Sezione Prodotti -->
    <div id="productsSection" class="products-section">
      <div class="header">
        <h1><i class="fas fa-box-open"></i> Gestione Prodotti</h1>
        <div class="actions">
          <button class="delete-selected-btn" id="deleteSelectedBtn" style="display:none;">
            <i class="fas fa-trash"></i> Elimina Selezionati
          </button>
          <button class="add-product-btn" id="addProductBtn">
            <i class="fas fa-plus"></i> Aggiungi Prodotto
          </button>
        </div>
      </div>

      <div class="table-container">
        <table class="products-table" id="productsTable">
          <thead>
            <tr>
              <th><input type="checkbox" id="selectAll"></th>
              <th>Immagine</th>
              <th>Nome Prodotto</th>
              <th>Categoria</th>
              <th>Prezzo</th>
              <th>Varianti</th>
              <th>Stock Totale</th>
              <th>Personalizzabile</th>
              <th>Azioni</th>
            </tr>
          </thead>
          <tbody id="productsTableBody">
            <!-- Caricamento dinamico via AJAX -->
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Modal per aggiunta/modifica prodotto -->
  <div id="productModal" class="modal">
    <div class="modal-content">
      <span class="close-modal">&times;</span>
      <h2>
        <i class="fas fa-plus-circle"></i> 
        <span id="modalTitle">Aggiungi Nuovo Prodotto</span>
      </h2>
      
      <form id="productForm" enctype="multipart/form-data">
        <input type="hidden" id="productId" name="productId">
        
        <!-- Informazioni di base -->
        <div class="form-row">
          <div class="form-group">
            <label for="productName">Nome Prodotto*</label>
            <input type="text" id="productName" name="nome" required>
          </div>
          <div class="form-group">
            <label for="productCategory">Categoria*</label>
            <select id="productCategory" name="categoria" required>
              <option value="">Seleziona Categoria</option>
              <option value="Cover">Cover</option>
              <option value="Powerbank">Powerbank</option>
              <option value="MagSafe">MagSafe</option>
              <option value="Accessori">Accessori</option>
            </select>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group">
            <label for="productPrice">Prezzo (€)*</label>
            <input type="number" id="productPrice" name="prezzo" step="0.01" min="0" required>
          </div>
          <div class="form-group">
            <label>
              <input type="checkbox" id="productCustomizable" name="personalizzabile">
              Prodotto personalizzabile
            </label>
          </div>
        </div>

        <div class="form-group">
          <label for="productDescription">Descrizione</label>
          <textarea id="productDescription" name="descrizione" rows="3"></textarea>
        </div>

        <!-- Sezione Varianti -->
        <div class="variations-container">
          <h3>Varianti Prodotto (Colore + Modello)</h3>
          <div id="variationsContainer">
            <!-- Varianti caricate dinamicamente -->
          </div>
          <button type="button" id="addVariationBtn" class="btn-add-variation">
            <i class="fas fa-plus"></i> Aggiungi Variante
          </button>
        </div>

        <!-- Upload Immagini -->
        <div class="form-group">
          <label for="productImages">Immagini Prodotto</label>
          <div class="file-upload">
            <input type="file" id="productImages" name="immagini" multiple accept="image/*">
            <label for="productImages" class="upload-btn">
              <i class="fas fa-cloud-upload-alt"></i> Scegli file
            </label>
            <div id="imagePreview" class="image-preview"></div>
          </div>
        </div>
        
        <div class="form-actions">
          <button type="button" class="cancel-btn">Annulla</button>
          <button type="submit" class="submit-btn">
            <i class="fas fa-save"></i> Salva Prodotto
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Modal di conferma eliminazione -->
  <div id="confirmDeleteModal" class="modal">
    <div class="modal-content">
      <h3>Conferma Eliminazione</h3>
      <p>Sei sicuro di voler eliminare questo prodotto?</p>
      <div class="form-actions">
        <button type="button" class="cancel-btn" id="cancelDeleteBtn">Annulla</button>
        <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Elimina</button>
      </div>
    </div>
  </div>

  <!-- Script e librerie -->
  <script>
    // Variabili globali
    const contextPath = '<%= request.getContextPath() %>';
    let currentEditingProduct = null;
    let selectedProductIds = [];
  </script>
  
  <script src="<%= request.getContextPath() + "/Script/AdminRequests.js" %>"></script>
  
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Carica i prodotti all'avvio
      loadProducts();
      
      // Event listeners
      setupEventListeners();
    });
    
    function setupEventListeners() {
      // Modal controls
      const modal = document.getElementById('productModal');
      const closeBtn = modal.querySelector('.close-modal');
      const cancelBtn = modal.querySelector('.cancel-btn');
      
      closeBtn.addEventListener('click', () => modal.style.display = 'none');
      cancelBtn.addEventListener('click', () => modal.style.display = 'none');
      
      // Form submission
      document.getElementById('productForm').addEventListener('submit', handleProductSubmit);
      
      // Add product button
      document.getElementById('addProductBtn').addEventListener('click', () => {
        resetProductForm();
        document.getElementById('modalTitle').textContent = 'Aggiungi Nuovo Prodotto';
        modal.style.display = 'block';
      });
      
      // Add variation button
      document.getElementById('addVariationBtn').addEventListener('click', addVariationRow);
      
      // Select all checkbox
      document.getElementById('selectAll').addEventListener('change', function() {
        const checkboxes = document.querySelectorAll('.product-checkbox');
        checkboxes.forEach(cb => cb.checked = this.checked);
        updateSelectedProducts();
      });
      
      // Delete selected button
      document.getElementById('deleteSelectedBtn').addEventListener('click', deleteSelectedProducts);
      
      // Image preview
      document.getElementById('productImages').addEventListener('change', handleImagePreview);
    }
    
    // Carica la prima variante di default
    window.addEventListener('load', function() {
      if (document.getElementById('variationsContainer').children.length === 0) {
        addVariationRow();
      }
    });
  </script>
</body>
</html>