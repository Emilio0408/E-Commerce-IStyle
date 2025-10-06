<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.IStyle.model.bean.User" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Ordini - Admin iStyle</title>
  <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/admin-ordiniStyle.css"%>">
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
    .filters-container {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 8px;
      margin-bottom: 20px;
      display: flex;
      gap: 15px;
      align-items: center;
      flex-wrap: wrap;
    }
    .filter-group {
      display: flex;
      flex-direction: column;
      gap: 5px;
    }
    .filter-group label {
      font-size: 12px;
      font-weight: bold;
      color: #666;
    }
    .filter-input, .filter-select {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }
    .status-badge {
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: bold;
      text-transform: uppercase;
    }
    .status-elaborazione { background: #fff3cd; color: #856404; }
    .status-spedito { background: #d4edda; color: #155724; }
    .status-ricevuto { background: #d1ecf1; color: #0c5460; }
    .status-annullato { background: #f8d7da; color: #721c24; }
    .order-details {
      background: #f8f9fa;
      padding: 15px;
      margin-top: 10px;
      border-radius: 4px;
      display: none;
    }
    .order-products {
      margin-top: 10px;
    }
    .order-product-item {
      display: flex;
      justify-content: between;
      align-items: center;
      padding: 8px 0;
      border-bottom: 1px solid #eee;
    }
    .btn-small {
      padding: 4px 8px;
      font-size: 12px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .btn-info { background: #17a2b8; color: white; }
    .btn-warning { background: #ffc107; color: #212529; }
    .btn-success { background: #28a745; color: white; }
    .pagination-container {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 10px;
      margin-top: 20px;
    }
    .pagination-btn {
      padding: 8px 12px;
      border: 1px solid #ddd;
      background: white;
      cursor: pointer;
      border-radius: 4px;
    }
    .pagination-btn:hover { background: #f8f9fa; }
    .pagination-btn:disabled { 
      background: #e9ecef;
      color: #6c757d;
      cursor: not-allowed;
    }
    .stats-container {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      margin-bottom: 20px;
    }
    .stat-card {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      text-align: center;
    }
    .stat-number {
      font-size: 24px;
      font-weight: bold;
      color: #007bff;
    }
    .stat-label {
      font-size: 14px;
      color: #666;
      margin-top: 5px;
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

    <!-- Statistiche -->
    <div id="statsContainer" class="stats-container">
      <!-- Statistiche caricate via AJAX -->
    </div>

    <!-- Sezione Ordini -->
    <div id="ordersSection" class="orders-section">
      <div class="header">
        <h1><i class="fas fa-shopping-bag"></i> Gestione Ordini</h1>
      </div>

      <!-- Filtri -->
      <div class="filters-container">
        <div class="filter-group">
          <label for="userFilter">Filtra per Utente</label>
          <select id="userFilter" class="filter-select">
            <option value="">Tutti gli utenti</option>
            <!-- Caricato dinamicamente -->
          </select>
        </div>
        
        <div class="filter-group">
          <label for="statusFilter">Stato Ordine</label>
          <select id="statusFilter" class="filter-select">
            <option value="">Tutti gli stati</option>
            <option value="Elaborazione">In Elaborazione</option>
            <option value="Spedito">Spedito</option>
            <option value="Ricevuto">Ricevuto</option>
            <option value="Annullato">Annullato</option>
          </select>
        </div>

        <div class="filter-group">
          <label for="sortOrder">Ordinamento</label>
          <select id="sortOrder" class="filter-select">
            <option value="desc">Più recente prima</option>
            <option value="asc">Meno recente prima</option>
          </select>
        </div>

        <div class="filter-group">
          <label for="limitFilter">Ordini per pagina</label>
          <select id="limitFilter" class="filter-select">
            <option value="20">20</option>
            <option value="50" selected>50</option>
            <option value="100">100</option>
          </select>
        </div>

        <div class="filter-group" style="margin-top: auto;">
          <button id="resetFiltersBtn" class="btn btn-secondary" type="button">
            <i class="fas fa-refresh"></i> Reset Filtri
          </button>
        </div>
      </div>

      <!-- Tabella ordini -->
      <div class="table-container">
        <table class="orders-table" id="ordersTable">
          <thead>
            <tr>
              <th>ID Ordine</th>
              <th>Username</th>
              <th>Nome Completo</th>
              <th>Email</th>
              <th>Data Emissione</th>
              <th>Importo Totale</th>
              <th>Stato</th>
              <th>Azioni</th>
            </tr>
          </thead>
          <tbody id="ordersTableBody">
            <!-- Caricamento dinamico via AJAX -->
          </tbody>
        </table>
      </div>

      <!-- Paginazione -->
      <div id="paginationContainer" class="pagination-container">
        <button id="prevPageBtn" class="pagination-btn" disabled>
          <i class="fas fa-chevron-left"></i> Precedente
        </button>
        <span id="pageInfo">Pagina 1 di 1</span>
        <button id="nextPageBtn" class="pagination-btn" disabled>
          Successiva <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>
  </div>

  <!-- Modal dettagli ordine -->
  <div id="orderDetailsModal" class="modal">
    <div class="modal-content">
      <span class="close-modal">&times;</span>
      <h2>
        <i class="fas fa-receipt"></i>
        <span id="orderModalTitle">Dettagli Ordine</span>
      </h2>
      
      <div id="orderDetailsContent">
        <!-- Contenuto caricato dinamicamente -->
      </div>
    </div>
  </div>

  <!-- Modal modifica stato -->
  <div id="statusModal" class="modal">
    <div class="modal-content">
      <span class="close-modal">&times;</span>
      <h3>Modifica Stato Ordine</h3>
      
      <form id="statusForm">
        <input type="hidden" id="statusOrderId">
        
        <div class="form-group">
          <label for="newOrderStatus">Nuovo Stato</label>
          <select id="newOrderStatus" class="filter-select" required>
            <option value="">Seleziona stato</option>
            <option value="Elaborazione">In Elaborazione</option>
            <option value="Spedito">Spedito</option>
            <option value="Ricevuto">Ricevuto</option>
            <option value="Annullato">Annullato</option>
          </select>
        </div>
        
        <div class="form-actions">
          <button type="button" class="cancel-btn">Annulla</button>
          <button type="submit" class="submit-btn">
            <i class="fas fa-save"></i> Aggiorna Stato
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Script e librerie -->
  <script>
    // Variabili globali
    const contextPath = '<%= request.getContextPath() %>';
    let currentPage = 1;
    let totalPages = 1;
    let currentFilters = {
      user: '',
      status: '',
      sort: 'desc',
      limit: 50,
      offset: 0
    };
  </script>
  
  <script src="<%= request.getContextPath() + "/Script/AdminRequests.js" %>"></script>
  
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Carica i dati iniziali
      loadOrderStats();
      loadUsers();
      loadOrders();
      
      // Setup event listeners
      setupEventListeners();
    });
    
    function setupEventListeners() {
      // Filtri
      document.getElementById('userFilter').addEventListener('change', () => {
        currentFilters.user = document.getElementById('userFilter').value;
        currentPage = 1;
        currentFilters.offset = 0;
        loadOrders();
      });
      
      document.getElementById('statusFilter').addEventListener('change', () => {
        currentFilters.status = document.getElementById('statusFilter').value;
        currentPage = 1;
        currentFilters.offset = 0;
        loadOrders();
      });
      
      document.getElementById('sortOrder').addEventListener('change', () => {
        currentFilters.sort = document.getElementById('sortOrder').value;
        currentPage = 1;
        currentFilters.offset = 0;
        loadOrders();
      });
      
      document.getElementById('limitFilter').addEventListener('change', () => {
        currentFilters.limit = parseInt(document.getElementById('limitFilter').value);
        currentPage = 1;
        currentFilters.offset = 0;
        loadOrders();
      });
      
      // Reset filtri
      document.getElementById('resetFiltersBtn').addEventListener('click', () => {
        document.getElementById('userFilter').value = '';
        document.getElementById('statusFilter').value = '';
        document.getElementById('sortOrder').value = 'desc';
        document.getElementById('limitFilter').value = '50';
        
        currentFilters = {
          user: '',
          status: '',
          sort: 'desc',
          limit: 50,
          offset: 0
        };
        
        currentPage = 1;
        loadOrders();
      });
      
      // Paginazione
      document.getElementById('prevPageBtn').addEventListener('click', () => {
        if (currentPage > 1) {
          currentPage--;
          currentFilters.offset = (currentPage - 1) * currentFilters.limit;
          loadOrders();
        }
      });
      
      document.getElementById('nextPageBtn').addEventListener('click', () => {
        if (currentPage < totalPages) {
          currentPage++;
          currentFilters.offset = (currentPage - 1) * currentFilters.limit;
          loadOrders();
        }
      });
      
      // Modals
      const detailsModal = document.getElementById('orderDetailsModal');
      const statusModal = document.getElementById('statusModal');
      
      detailsModal.querySelector('.close-modal').addEventListener('click', () => {
        detailsModal.style.display = 'none';
      });
      
      statusModal.querySelector('.close-modal').addEventListener('click', () => {
        statusModal.style.display = 'none';
      });
      
      statusModal.querySelector('.cancel-btn').addEventListener('click', () => {
        statusModal.style.display = 'none';
      });
      
      // Form stato
      document.getElementById('statusForm').addEventListener('submit', handleStatusUpdate);
    }
  </script>
</body>
</html>