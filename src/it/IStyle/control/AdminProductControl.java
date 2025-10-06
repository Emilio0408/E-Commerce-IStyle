package it.IStyle.control;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.bean.Variation;
import it.IStyle.model.dao.ProductModel;

/**
 * Servlet per la gestione amministrativa dei prodotti.
 * Gestisce operazioni CRUD sui prodotti con supporto AJAX.
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProductControl extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductModel productModel;
    private Gson gson;
    private static final String UPLOAD_DIR = "images/products";
    
    @Override
    public void init() throws ServletException {
        super.init();
        productModel = new ProductModel();
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
                    listProducts(request, response);
                    break;
                case "get":
                    getProduct(request, response);
                    break;
                case "variations":
                    getProductVariations(request, response);
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
                case "create":
                    createProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                case "updateStock":
                    updateProductStock(request, response);
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
     * Lista tutti i prodotti con dettagli completi
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        Collection<ProductBean> products = productModel.doRetrieveAll("nome");
        
        JsonArray productsArray = new JsonArray();
        
        for (ProductBean product : products) {
            JsonObject productJson = new JsonObject();
            productJson.addProperty("id", product.getID());
            productJson.addProperty("nome", product.getName());
            productJson.addProperty("prezzo", product.getPrice());
            productJson.addProperty("categoria", product.getCategory());
            productJson.addProperty("descrizione", product.getDescription());
            productJson.addProperty("personalizzabile", product.getCustomizable());
            
            // Aggiungi varianti
            Collection<Variation> variations = productModel.doRetrieveVariationsOfProduct(product.getID());
            JsonArray variationsArray = new JsonArray();
            
            for (Variation var : variations) {
                JsonObject varJson = new JsonObject();
                varJson.addProperty("colore", var.getColor());
                varJson.addProperty("modello", var.getModel());
                varJson.addProperty("quantita", var.getQuantity());
                variationsArray.add(varJson);
            }
            productJson.add("varianti", variationsArray);
            
            // Aggiungi immagini
            Collection<String> imagePaths = productModel.doRetrieveImagePathsOfProducts(product.getID());
            JsonArray imagesArray = new JsonArray();
            for (String path : imagePaths) {
                imagesArray.add(path);
            }
            productJson.add("immagini", imagesArray);
            
            productsArray.add(productJson);
        }
        
        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("success", true);
        responseJson.add("products", productsArray);
        
        sendJsonResponse(response, responseJson);
    }
    
    /**
     * Ottiene dettagli di un singolo prodotto
     */
    private void getProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            sendErrorResponse(response, "ID prodotto non specificato", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            ProductBean product = productModel.doRetrieveByKey(id);
            
            if (product == null) {
                sendErrorResponse(response, "Prodotto non trovato", HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            JsonObject productJson = new JsonObject();
            productJson.addProperty("id", product.getID());
            productJson.addProperty("nome", product.getName());
            productJson.addProperty("prezzo", product.getPrice());
            productJson.addProperty("categoria", product.getCategory());
            productJson.addProperty("descrizione", product.getDescription());
            productJson.addProperty("personalizzabile", product.getCustomizable());
            
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.add("product", productJson);
            
            sendJsonResponse(response, responseJson);
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "ID prodotto non valido", HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Crea un nuovo prodotto con varianti e immagini
     */
    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        // Estrai dati base del prodotto
        String nome = request.getParameter("nome");
        String prezzoStr = request.getParameter("prezzo");
        String categoria = request.getParameter("categoria");
        String descrizione = request.getParameter("descrizione");
        String personalizzabileStr = request.getParameter("personalizzabile");
        
        // Validazione campi obbligatori
        if (nome == null || nome.trim().isEmpty() ||
            prezzoStr == null || prezzoStr.trim().isEmpty() ||
            categoria == null || categoria.trim().isEmpty()) {
            sendErrorResponse(response, "Campi obbligatori mancanti", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            // Crea il bean prodotto
            ProductBean product = new ProductBean();
            product.setName(nome.trim());
            product.setPrice(new BigDecimal(prezzoStr));
            product.setCategory(categoria);
            product.setDescription(descrizione != null ? descrizione : "");
            product.setCustomizable("true".equalsIgnoreCase(personalizzabileStr));
            
            // Salva il prodotto e ottieni l'ID generato
            int productId = productModel.doSaveWithReturnId(product);
            
            // Gestisci le varianti
            String[] colori = request.getParameterValues("colore[]");
            String[] codiciColore = request.getParameterValues("codiceColore[]");
            String[] modelli = request.getParameterValues("modello[]");
            String[] quantita = request.getParameterValues("quantita[]");
            
            if (colori != null && modelli != null && colori.length == modelli.length) {
                for (int i = 0; i < colori.length; i++) {
                    int qty = 0;
                    if (quantita != null && i < quantita.length) {
                        try {
                            qty = Integer.parseInt(quantita[i]);
                        } catch (NumberFormatException e) {
                            qty = 0;
                        }
                    }
                    
                    productModel.doSaveVariation(productId, colori[i], 
                                               codiciColore != null && i < codiciColore.length ? codiciColore[i] : "#000000",
                                               modelli[i], qty);
                }
            }
            
            // Gestisci upload immagini
            Collection<Part> fileParts = request.getParts();
            List<String> imagePaths = new ArrayList<>();
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            for (Part part : fileParts) {
                if (part.getName().equals("immagini") && part.getSize() > 0) {
                    String fileName = extractFileName(part);
                    if (fileName != null && !fileName.isEmpty()) {
                        // Genera nome univoco per evitare conflitti
                        String extension = fileName.substring(fileName.lastIndexOf("."));
                        String uniqueName = "product_" + productId + "_" + UUID.randomUUID().toString() + extension;
                        
                        // Salva il file
                        Path filePath = Paths.get(uploadPath, uniqueName);
                        Files.copy(part.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                        
                        // Salva il percorso nel database
                        String dbPath = UPLOAD_DIR + "/" + uniqueName;
                        productModel.doSaveImage(productId, dbPath);
                        imagePaths.add(dbPath);
                    }
                }
            }
            
            // Risposta di successo
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.addProperty("message", "Prodotto creato con successo");
            responseJson.addProperty("productId", productId);
            
            JsonArray imagesArray = new JsonArray();
            for (String path : imagePaths) {
                imagesArray.add(path);
            }
            responseJson.add("imagePaths", imagesArray);
            
            sendJsonResponse(response, responseJson);
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Formato prezzo non valido", HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Errore durante la creazione del prodotto: " + e.getMessage(), 
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * Aggiorna un prodotto esistente
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String idStr = request.getParameter("id");
        String nome = request.getParameter("nome");
        String prezzoStr = request.getParameter("prezzo");
        String categoria = request.getParameter("categoria");
        String descrizione = request.getParameter("descrizione");
        String personalizzabileStr = request.getParameter("personalizzabile");
        
        if (idStr == null || idStr.isEmpty()) {
            sendErrorResponse(response, "ID prodotto non specificato", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            ProductBean product = productModel.doRetrieveByKey(id);
            
            if (product == null) {
                sendErrorResponse(response, "Prodotto non trovato", HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Aggiorna solo i campi forniti
            if (nome != null && !nome.trim().isEmpty()) {
                product.setName(nome.trim());
            }
            if (prezzoStr != null && !prezzoStr.trim().isEmpty()) {
                product.setPrice(new BigDecimal(prezzoStr));
            }
            if (categoria != null && !categoria.trim().isEmpty()) {
                product.setCategory(categoria);
            }
            if (descrizione != null) {
                product.setDescription(descrizione);
            }
            if (personalizzabileStr != null) {
                product.setCustomizable("true".equalsIgnoreCase(personalizzabileStr));
            }
            
            productModel.doUpdate(product);
            
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.addProperty("message", "Prodotto aggiornato con successo");
            
            sendJsonResponse(response, responseJson);
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Formato dati non valido", HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Elimina un prodotto
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            sendErrorResponse(response, "ID prodotto non specificato", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            boolean deleted = productModel.doDelete(id);
            
            if (!deleted) {
                sendErrorResponse(response, "Impossibile eliminare il prodotto", 
                                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }
            
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.addProperty("message", "Prodotto eliminato con successo");
            
            sendJsonResponse(response, responseJson);
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "ID prodotto non valido", HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Aggiorna lo stock di una variante prodotto
     */
    private void updateProductStock(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String idStr = request.getParameter("id");
        String colore = request.getParameter("colore");
        String modello = request.getParameter("modello");
        String quantitaStr = request.getParameter("quantita");
        
        if (idStr == null || colore == null || modello == null || quantitaStr == null) {
            sendErrorResponse(response, "Parametri mancanti", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            int quantita = Integer.parseInt(quantitaStr);
            
            productModel.doUpdateProductQuantity(id, colore, modello, quantita);
            
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.addProperty("message", "Stock aggiornato con successo");
            
            sendJsonResponse(response, responseJson);
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Formato dati non valido", HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Ottiene tutte le varianti di un prodotto
     */
    private void getProductVariations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            sendErrorResponse(response, "ID prodotto non specificato", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Collection<Variation> variations = productModel.doRetrieveVariationsOfProduct(id);
            
            JsonArray variationsArray = new JsonArray();
            for (Variation var : variations) {
                JsonObject varJson = new JsonObject();
                varJson.addProperty("colore", var.getColor());
                varJson.addProperty("modello", var.getModel());
                varJson.addProperty("quantita", var.getQuantity());
                variationsArray.add(varJson);
            }
            
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("success", true);
            responseJson.add("variations", variationsArray);
            
            sendJsonResponse(response, responseJson);
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "ID prodotto non valido", HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Estrae il nome del file da una Part
     */
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return null;
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