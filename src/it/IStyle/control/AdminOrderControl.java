package it.IStyle.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import it.IStyle.model.bean.Order;
import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.bean.User;
import it.IStyle.model.dao.OrderModel;
import it.IStyle.model.dao.UserModel;

/**
 * Servlet per la gestione amministrativa degli ordini.
 * Gestisce visualizzazione, filtri e aggiornamento stato ordini.
 */
public class AdminOrderControl extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderModel orderModel;
    private UserModel userModel;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        orderModel = new OrderModel();
        userModel = new UserModel();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listOrders(request, response);
                    break;
                case "details":
                    getOrderDetails(request, response);
                    break;
                case "users":
                    getUsersList(request, response);
                    break;
                case "stats":
                    getOrderStats(request, response);
                    break;
                default:
                    sendErrorResponse(response, "Azione non valida", HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendErrorResponse(response, "Errore del database: " + e.getMessage(), 
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            sendErrorResponse(response, "Azione non specificata", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            switch (action) {
                case "updateStatus":
                    updateOrderStatus(request, response);
                    break;
                case "addNote":
                    addOrderNote(request, response);
                    break;
                default:
                    sendErrorResponse(response, "Azione non valida", HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendErrorResponse(response, "Errore del database: " + e.getMessage(), 
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * Lista tutti gli ordini con filtri opzionali
     */
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        // Parametri di filtro
        String userFilter = request.getParameter("user");
        String statusFilter = request.getParameter("status");
        String sortOrder = request.getParameter("sort"); // "desc" per più recente, "asc" per meno recente
        String limitStr = request.getParameter("limit");
        String offsetStr = request.getParameter("offset");
        
        // Imposta ordinamento predefinito: più recente prima
        if (sortOrder == null) {
            sortOrder = "desc";
        }
        
        // Paginazione
        int limit = 50; // Default
        int offset = 0;
        
        try {
            if (limitStr != null && !limitStr.isEmpty()) {
                limit = Integer.parseInt(limitStr);
            }
            if (offsetStr != null && !offsetStr.isEmpty()) {
                offset = Integer.parseInt(offsetStr);
            }
        } catch (NumberFormatException e) {
            // Usa valori di default
        }
        
        // Recupera gli ordini filtrati
        Collection<Order> orders = null;
        
        if (userFilter != null && !userFilter.trim().isEmpty()) {
            // Filtra per utente
            orders = orderModel.doRetrieveByUsername(userFilter.trim(), sortOrder, limit, offset);
        } else if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            // Filtra per stato
            //orders = orderModel.doRetrieveByStatus(statusFilter.trim(), sortOrder, limit, offset);
        } else {
            // Tutti gli ordini
            orders = orderModel.doRetrieveAllWithDetails(sortOrder, limit, offset);
        }
        
        JsonArray ordersArray = new JsonArray();
        
        for (Order order : orders) {
            JsonObject orderJson = new JsonObject();
            orderJson.addProperty("id", order.getIDOrdine());
            orderJson.addProperty("username", order.getUsername());
            orderJson.addProperty("dataEmissione", order.getDataEmissione().toString());
            orderJson.addProperty("dataErogazione", order.getDataErogazione() != null ? order.getDataErogazione().toString() : null);
            orderJson.addProperty("dataConsegna", order.getDataConsegna() != null ? order.getDataConsegna().toString() : null);
            orderJson.addProperty("importoTotale", order.getImportoTotale());
            orderJson.addProperty("stato", order.getStato());
            orderJson.addProperty("metodoDiSpedizione", order.getMetodoDiSpedizione());
            orderJson.addProperty("tipoPagamento", order.getTipoPagamento());
            orderJson.addProperty("indirizzoSpedizione", order.getIndirizzoDiSpedizione());
            orderJson.addProperty("paymentIntent", order.getPaymentIntentID());
            
            // Aggiungi informazioni utente
            try {
                User user = userModel.doRetrieveByKey(order.getUsername());
                if (user != null) {
                    orderJson.addProperty("nomeCompleto", user.getName() + " " + user.getSurname());
                    orderJson.addProperty("email", user.getEmail());
                }
            } catch (SQLException e) {
                // Log l'errore ma continua
                e.printStackTrace();
            }
            
            ordersArray.add(orderJson);
        }
        
        // Conta totale ordini per la paginazione
        int totalOrders = orderModel.countOrders(userFilter, statusFilter);
        
        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("success", true);
        responseJson.add("orders", ordersArray);
        responseJson.addProperty("total", totalOrders);
        responseJson.addProperty("limit", limit);
        responseJson.addProperty("offset", offset);
        responseJson.addProperty("hasMore", (offset + limit) < totalOrders);
        
        sendJsonResponse(response, responseJson);
    }
    
    /**
     * Ottiene dettagli completi di un ordine inclusi i prodotti
     */
    private void getOrderDetails(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            sendErrorResponse(response, "ID ordine non specificato", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Order order = orderModel.doRetrieveByKey(id);
            
            if (order == null) {
                sendErrorResponse(response, "Ordine non trovato", HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            JsonObject orderJson = new JsonObject();
            orderJson.addProperty("id", order.getIDOrdine());
            orderJson.addProperty("username", order.getUsername());
            orderJson.addProperty("dataEmissione", order.getDataEmissione().toString());
            orderJson.addProperty("dataErogazione", order.getDataErogazione() != null ? order.getDataErogazione().toString() : null);
            orderJson.addProperty("dataConsegna", order.getDataConsegna() != null ? order.getDataConsegna().toString() : null);
            orderJson.addProperty("importoTotale", order.getImportoTotale());
            orderJson.addProperty("stato", order.getStato());
            orderJson.addProperty("metodoDiSpedizione", order.getMetodoDiSpedizione());
            orderJson.addProperty("tipoPagamento", order.getTipoPagamento());
            orderJson.addProperty("indirizzoSpedizione", order.getIndirizzoDiSpedizione());
            orderJson.addProperty("paymentIntent", order.getPaymentIntentID());
            
            // Aggiungi prodotti dell'ordine
            Collection<ProductBean> orderProducts = orderModel.doRetrieveOrderProducts(id);
            JsonArray productsArray = new JsonArray();
            
            for (ProductBean product : orderProducts) {
                JsonObject productJson = new JsonObject();
                productJson.addProperty("id", product.getID());
                productJson.addProperty("nome", product.getName());
                productJson.addProperty("prezzo", product.getPrice());
                productJson.addProperty("quantita", product.getQuantityInCart());
                productJson.addProperty("colore", product.getColor());
                productJson.addProperty("modello", product.getModel());
                
                // Calcola subtotale
                double subtotale = product.getPrice() * product.getQuantityInCart();
                productJson.addProperty("subtotale", subtotale);
                
                productsArray.add(productJson);
            }
            orderJson.add("prodotti", productsArray);
            
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.add("order", orderJson);
            
            sendJsonResponse(response, responseJson);
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "ID ordine non valido", HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Ottiene lista degli utenti per il filtro
     */
    private void getUsersList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        // Ottieni solo utenti che hanno effettuato ordini
        Collection<String> usernames = orderModel.doRetrieveDistinctUsernames();
        
        JsonArray usersArray = new JsonArray();
        for (String username : usernames) {
            try {
                User user = userModel.doRetrieveByKey(username);
                if (user != null) {
                    JsonObject userJson = new JsonObject();
                    userJson.addProperty("username", username);
                    userJson.addProperty("nomeCompleto", user.getName() + " " + user.getSurname());
                    userJson.addProperty("email", user.getEmail());
                    usersArray.add(userJson);
                }
            } catch (SQLException e) {
                // Log l'errore ma continua
                e.printStackTrace();
            }
        }
        
        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("success", true);
        responseJson.add("users", usersArray);
        
        sendJsonResponse(response, responseJson);
    }
    
    /**
     * Ottiene statistiche sugli ordini
     */
    private void getOrderStats(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        JsonObject stats = orderModel.doRetrieveOrderStats();
        
        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("success", true);
        responseJson.add("stats", stats);
        
        sendJsonResponse(response, responseJson);
    }
    
    /**
     * Aggiorna lo stato di un ordine
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("status");
        
        if (idStr == null || idStr.isEmpty() || newStatus == null || newStatus.isEmpty()) {
            sendErrorResponse(response, "Parametri mancanti", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        // Valida lo stato
        if (!isValidOrderStatus(newStatus)) {
            sendErrorResponse(response, "Stato ordine non valido", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Order order = orderModel.doRetrieveByKey(id);
            
            if (order == null) {
                sendErrorResponse(response, "Ordine non trovato", HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Aggiorna lo stato
            order.setStato(newStatus);
            orderModel.doUpdate(order);
            
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.addProperty("message", "Stato ordine aggiornato con successo");
            responseJson.addProperty("newStatus", newStatus);
            
            sendJsonResponse(response, responseJson);
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "ID ordine non valido", HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Aggiunge una nota all'ordine (implementazione futura)
     */
    private void addOrderNote(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        // Implementazione futura - attualmente restituisce successo
        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("success", true);
        responseJson.addProperty("message", "Funzionalità note non ancora implementata");
        
        sendJsonResponse(response, responseJson);
    }
    
    /**
     * Valida se lo stato dell'ordine è valido
     */
    private boolean isValidOrderStatus(String status) {
        return "Elaborazione".equals(status) || 
               "Spedito".equals(status) || 
               "Ricevuto".equals(status) ||
               "Annullato".equals(status);
    }
    
    /**
     * Invia una risposta JSON di successo
     */
    private void sendJsonResponse(HttpServletResponse response, JsonObject json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(json));
        out.flush();
    }
    
    /**
     * Invia una risposta JSON di errore
     */
    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode) 
            throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject errorJson = new JsonObject();
        errorJson.addProperty("success", false);
        errorJson.addProperty("error", message);
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(errorJson));
        out.flush();
    }
}