<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.IStyle.model.bean.User" %>
<%
    String name = (String) session.getAttribute("Name");
    String surname = (String) session.getAttribute("Surname");
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Admin - iStyle</title>
  <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    .admin-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    
    .dashboard-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 30px;
      border-radius: 12px;
      margin-bottom: 30px;
      text-align: center;
    }
    
    .dashboard-header h1 {
      margin: 0 0 10px 0;
      font-size: 2.5em;
    }
    
    .dashboard-header p {
      margin: 0;
      opacity: 0.9;
      font-size: 1.1em;
    }
    
    .admin-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 20px;
      margin-bottom: 30px;
    }
    
    .admin-card {
      background: white;
      border-radius: 12px;
      padding: 25px;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      border: 1px solid #e1e5e9;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .admin-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 15px rgba(0,0,0,0.15);
    }
    
    .card-header {
      display: flex;
      align-items: center;
      margin-bottom: 15px;
    }
    
    .card-icon {
      font-size: 2em;
      margin-right: 15px;
      width: 60px;
      height: 60px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
    }
    
    .icon-products { background: #4CAF50; }
    .icon-orders { background: #2196F3; }
    .icon-users { background: #FF9800; }
    .icon-analytics { background: #9C27B0; }
    
    .card-title {
      font-size: 1.4em;
      font-weight: bold;
      color: #333;
      margin: 0;
    }
    
    .card-description {
      color: #666;
      margin-bottom: 20px;
      line-height: 1.6;
    }
    
    .card-actions {
      display: flex;
      gap: 10px;
    }
    
    .btn {
      padding: 10px 20px;
      border: none;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.3s ease;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 5px;
    }
    
    .btn-primary {
      background: #007bff;
      color: white;
    }
    
    .btn-primary:hover {
      background: #0056b3;
    }
    
    .btn-secondary {
      background: #6c757d;
      color: white;
    }
    
    .btn-secondary:hover {
      background: #545b62;
    }
    
    .quick-stats {
      background: white;
      border-radius: 12px;
      padding: 25px;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      border: 1px solid #e1e5e9;
      margin-bottom: 30px;
    }
    
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
    }
    
    .stat-item {
      text-align: center;
      padding: 20px;
      background: #f8f9fa;
      border-radius: 8px;
    }
    
    .stat-number {
      font-size: 2.5em;
      font-weight: bold;
      color: #007bff;
      margin-bottom: 5px;
    }
    
    .stat-label {
      color: #666;
      font-size: 0.9em;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    
    .recent-activity {
      background: white;
      border-radius: 12px;
      padding: 25px;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      border: 1px solid #e1e5e9;
    }
    
    .activity-header {
      display: flex;
      justify-content: between;
      align-items: center;
      margin-bottom: 20px;
      border-bottom: 2px solid #f8f9fa;
      padding-bottom: 15px;
    }
    
    .activity-item {
      display: flex;
      align-items: center;
      padding: 12px 0;
      border-bottom: 1px solid #f8f9fa;
    }
    
    .activity-item:last-child {
      border-bottom: none;
    }
    
    .activity-icon {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 15px;
      font-size: 1.2em;
      color: white;
    }
    
    .activity-new { background: #28a745; }
    .activity-update { background: #ffc107; color: #333 !important; }
    .activity-delete { background: #dc3545; }
  </style>
</head>
<body>


  <div class="admin-container">
    
    <!-- Header Dashboard -->
    <div class="dashboard-header">
      <h1><i class="fas fa-tachometer-alt"></i> Dashboard Amministratore</h1>
      <p>Benvenuto <%= name %> <%= surname %>, gestisci il tuo e-commerce da qui</p>
    </div>

    <!-- Statistiche Rapide -->
    <div class="quick-stats">
      <h2><i class="fas fa-chart-bar"></i> Statistiche Rapide</h2>
      <div id="statsContainer" class="stats-grid">
        <!-- Statistiche caricate via AJAX -->
        <div class="stat-item">
          <div class="stat-number" id="totalProducts">-</div>
          <div class="stat-label">Prodotti Totali</div>
        </div>
        <div class="stat-item">
          <div class="stat-number" id="totalOrders">-</div>
          <div class="stat-label">Ordini Totali</div>
        </div>
        <div class="stat-item">
          <div class="stat-number" id="totalRevenue">-</div>
          <div class="stat-label">Ricavi Totali</div>
        </div>
        <div class="stat-item">
          <div class="stat-number" id="pendingOrders">-</div>
          <div class="stat-label">Ordini in Attesa</div>
        </div>
      </div>
    </div>

    <!-- Cards Principali -->
    <div class="admin-cards">
      
      <!-- Gestione Prodotti -->
      <div class="admin-card">
        <div class="card-header">
          <div class="card-icon icon-products">
            <i class="fas fa-box-open"></i>
          </div>
          <h3 class="card-title">Gestione Prodotti</h3>
        </div>
        <p class="card-description">
          Aggiungi nuovi prodotti, modifica quelli esistenti, gestisci le varianti colore/modello e monitora lo stock disponibile.
        </p>
        <div class="card-actions">
          <a href="<%=request.getContextPath()%>/admin?section=products" class="btn btn-primary">
            <i class="fas fa-cogs"></i> Gestisci Prodotti
          </a>
        </div>
      </div>

      <!-- Gestione Ordini -->
      <div class="admin-card">
        <div class="card-header">
          <div class="card-icon icon-orders">
            <i class="fas fa-shopping-bag"></i>
          </div>
          <h3 class="card-title">Gestione Ordini</h3>
        </div>
        <p class="card-description">
          Visualizza tutti gli ordini, filtra per utente o stato, aggiorna lo stato degli ordini e monitora le spedizioni.
        </p>
        <div class="card-actions">
          <a href="<%=request.getContextPath()%>/admin?section=orders" class="btn btn-primary">
            <i class="fas fa-list-alt"></i> Gestisci Ordini
          </a>
        </div>
      </div>

      <!-- Analitiche -->
      <div class="admin-card">
        <div class="card-header">
          <div class="card-icon icon-analytics">
            <i class="fas fa-chart-pie"></i>
          </div>
          <h3 class="card-title">Analitiche</h3>
        </div>
        <p class="card-description">
          Visualizza statistiche dettagliate su vendite, prodotti più venduti, performance e trend degli acquisti.
        </p>
        <div class="card-actions">
          <a href="#" class="btn btn-secondary" onclick="alert('Funzionalità in arrivo!')">
            <i class="fas fa-chart-line"></i> Visualizza Report
          </a>
        </div>
      </div>

      <!-- Utenti -->
      <div class="admin-card">
        <div class="card-header">
          <div class="card-icon icon-users">
            <i class="fas fa-users"></i>
          </div>
          <h3 class="card-title">Gestione Utenti</h3>
        </div>
        <p class="card-description">
          Visualizza gli utenti registrati, gestisci i privilegi admin e monitora l'attività degli utenti sulla piattaforma.
        </p>
        <div class="card-actions">
          <a href="#" class="btn btn-secondary" onclick="alert('Funzionalità in arrivo!')">
            <i class="fas fa-user-cog"></i> Gestisci Utenti
          </a>
        </div>
      </div>
      
    </div>

    <!-- Attività Recenti -->
    <div class="recent-activity">
      <div class="activity-header">
        <h3><i class="fas fa-history"></i> Attività Recenti</h3>
        <small class="text-muted">Ultime modifiche al sistema</small>
      </div>
      <div id="recentActivity">
        <!-- Attività caricate via AJAX o statiche -->
        <div class="activity-item">
          <div class="activity-icon activity-new">
            <i class="fas fa-plus"></i>
          </div>
          <div>
            <strong>Sistema Amministratore Attivato</strong><br>
            <small class="text-muted">Le funzionalità admin sono ora disponibili</small>
          </div>
        </div>
      </div>
    </div>

  </div>

  <!-- Script JavaScript -->
  <script>
    const contextPath = '<%= request.getContextPath() %>';

    document.addEventListener('DOMContentLoaded', function() {
      loadDashboardStats();
    });

    /**
     * Carica le statistiche per la dashboard
     */
    async function loadDashboardStats() {
      try {
        // Carica statistiche ordini
        const ordersResponse = await fetch(`${contextPath}/admin/orders?action=stats`, {
          headers: {
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
          }
        });
        
        if (ordersResponse.ok) {
          const ordersData = await ordersResponse.json();
          if (ordersData.success) {
            const stats = ordersData.stats;
            document.getElementById('totalOrders').textContent = stats.totalOrders || 0;
            document.getElementById('totalRevenue').textContent = formatPrice(stats.totalRevenue || 0);
            document.getElementById('pendingOrders').textContent = stats.pendingOrders || 0;
          }
        }

        // Carica statistiche prodotti
        const productsResponse = await fetch(`${contextPath}/admin/products?action=list`, {
          headers: {
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
          }
        });
        
        if (productsResponse.ok) {
          const productsData = await productsResponse.json();
          if (productsData.success) {
            document.getElementById('totalProducts').textContent = productsData.products.length || 0;
          }
        }
        
      } catch (error) {
        console.error('Errore nel caricamento delle statistiche:', error);
      }
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
  </script>

</body>
</html>