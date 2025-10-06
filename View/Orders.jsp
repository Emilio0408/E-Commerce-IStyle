<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean, it.IStyle.model.bean.Cart, it.IStyle.model.bean.Order" %>


<%
    LinkedList<Order> Orders = (LinkedList<Order>) request.getAttribute("ordersOfUser");
%>




<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Storico Ordini - IStyle</title>
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/OrdersStyle.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div id="tsparticles"></div>

<%@ include file="includes/Header.jsp" %>



    <div class="orders-container">

    <%
        if(Orders != null && Orders.size() > 0)
        {
    %>
            <h1 class="section__headline">Storico Ordini</h1>
            <p class="orders-subtitle">Visualizza lo stato dei tuoi ordini e i dettagli di spedizione</p>

            <div class="orders-tabs">
                <button class="tab-btn active" onclick="filterOrders('all')">Tutti gli ordini</button>
            </div>

    <%
        }
    %>

    <div class="orders-list">
        <!-- Ordine 1 - Consegnato -->

        <%  
            for(Order order : Orders)
            {   
                String statoOrdine = order.getStato();
                String cssClass = "";
                if(statoOrdine.equals("Completato"))
                    cssClass = "completed";
                else 
                    cssClass = "processing";

                LinkedList<ProductBean> productsInOrder = order.getProductsInOrder();
                    
        %>

                <div class="order-card">
                    <div class="order-header">
                        <div class="order-info">
                            <span class="order-number">Ordine #<%=order.getIDOrdine()%></span>
                            <span class="order-date">Data ordine: <%=order.getDataErogazione()%></span>
                            <span class="order-status <%=cssClass%>"><%=order.getStato()%></span>
                        </div>
                        <div class="order-summary">
                            <span class="order-total">Totale:€ <%=String.format("%.2f", order.getImportoTotale())%></span>
                            <button class="order-details-btn" onclick="toggleOrderDetails('order-<%=order.getIDOrdine()%>')">
                                <i class="fas fa-chevron-down"></i> Dettagli
                            </button>
                        </div>
                    </div>

                    <div class="order-details" id="order-<%=order.getIDOrdine()%>">
                        <div class="details-grid">
                            <div class="details-section">
                                <h3><i class="fas fa-truck"></i> Spedizione</h3>
                                <div class="info-row">
                                    <span class="info-label">Data spedizione:</span>
                                    <span class="info-value"><%=order.getDataErogazione()%></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Data consegna:</span>
                                    <span class="info-value"><%=order.getDataConsegna()%></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Metodo Spedizione: </span>
                                    <span class="info-value"> <%=order.getMetodoDiSpedizione()%> </span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Indirizzo:</span>
                                    <span class="info-value"><%=order.getIndirizzoDiSpedizione()%></span>
                                </div>
                            </div>

                            <div class="details-section">
                                <h3><i class="fas fa-credit-card"></i> Pagamento</h3>
                                <div class="info-row">
                                    <span class="info-label">Metodo:</span>
                                    <span class="info-value"><%=order.getTipoPagamento()%></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Data pagamento:</span>
                                    <span class="info-value"><%=order.getDataErogazione()%></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Importo:</span>
                                    <span class="info-value">€<%=order.getImportoTotale()%></span>
                                </div>
                            </div>
                        </div>

                        <div class="products-section">
                            <h3><i class="fas fa-box-open"></i> Prodotti</h3>
                            <div class="product-list">
                            
                            <%
                                for(ProductBean p : productsInOrder)
                                {   
                                    LinkedList<String> ImagesPathsOfProduct = p.getImagesPaths();
                                    String finalPath = "";
                                    for(String path: ImagesPathsOfProduct)
                                    {
                                        if(path.contains(p.getColor()))
                                            finalPath = path;
                                    }
                            %>


                                <div class="product-item">
                                    <img src="<%= request.getContextPath() + "/images/prodotti/" + finalPath %>" alt="<%=p.getName()%>" class="product-image">
                                    <div class="product-info">
                                        <span class="product-name"><%=p.getName()%></span>
                                        <span class="product-price">€<%=p.getPrice()%></span>
                                        <span class="product-quantity">Quantità: <%=p.getQuantityInCart()%></span>
                                    </div>
                                </div>
                            <%
                                }
                            %>


                            </div>
                        </div>
                    </div>
                </div>

        <%
            }
            if(Orders == null || Orders.size() == 0)
            {
        %>

                <div class="orders-list">
                    <div class="no-orders-message">
                        <div class="no-orders-content">
                            <i class="fas fa-shopping-bag"></i>
                            <h3>Nessun ordine effettuato</h3>
                            <p>Sembra che tu non abbia ancora effettuato ordini.</p>
                            <a href="<%=request.getContextPath() + "/product"%>" class="shop-now-btn">dai un'occhiata ai nostri prodotti!</a>
                        </div>
                    </div>
                </div>

        <%

            }
        %>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/tsparticles@2"></script>
<script src="<%=request.getContextPath() + "/Script/OrdersScript.js"%>"></script>

<%@ include file="includes/Footer.jsp" %>
</body>
</html>