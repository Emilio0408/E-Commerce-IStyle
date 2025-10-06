<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, it.IStyle.model.bean.Order, it.IStyle.model.bean.ProductBean" %>


<!DOCTYPE html>


<%
    Order order = (Order) request.getAttribute("addedOrder");
    LinkedList<ProductBean> ProductsInOrder = null;
    if(order != null)
    {
        ProductsInOrder = order.getProductsInOrder();
    }
%>


<html>
<head>
    <title>Conferma Ordine - IStyle</title>
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/ConfirmOrderPageStyle.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>


    <div class="confirmation-container">
        <!-- Header con steps -->
        <header class="confirmation-header">
            <div class="confirmation-header-content">
                <h1 class="confirmation-title">Ordine confermato!</h1>
                
                <div class="confirmation-steps">
                    <div class="step completed">
                        <div class="step-number">1</div>
                        <span class="step-label">Dati personali</span>
                    </div>
                    <div class="step completed">
                        <div class="step-number">2</div>
                        <span class="step-label">Pagamento</span>
                    </div>
                    <div class="step active">
                        <div class="step-number">3</div>
                        <span class="step-label">Conferma</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main content -->
        <main class="confirmation-main">
            <!-- Colonna sinistra - Riepilogo ordine -->
            <div class="confirmation-column">
                <div class="confirmation-card">
                    <div class="confirmation-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h2>Grazie per il tuo ordine!</h2>
                    <p class="confirmation-text">Abbiamo ricevuto il tuo ordine e lo stiamo elaborando. Riceverai una email di conferma a breve.</p>
                    

                    <%
                        if(order != null)
                        {
                    %>
                            <div class="order-info-grid">
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-calendar-alt"></i> Data ordine
                                    </div>
                                    <div class="info-value"><%=order.getDataErogazione()%></div>
                                </div>
                                
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-truck"></i> Data consegna prevista
                                    </div>
                                    <div class="info-value"><%=order.getDataConsegna()%></div>
                                </div>
                                
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-shipping-fast"></i> Metodo di spedizione
                                    </div>
                                    <div class="info-value"><%=order.getMetodoDiSpedizione()%></div>
                                </div>
                                
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-map-marker-alt"></i> Indirizzo di spedizione
                                    </div>
                                    <div class="info-value">
                                        <%=order.getIndirizzoDiSpedizione()%>
                                    </div>
                                </div>
                                
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-credit-card"></i> Metodo di pagamento
                                    </div>
                                    <div class="info-value"><%=order.getTipoPagamento()%></div>
                                </div>
                                
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-receipt"></i> Importo totale
                                    </div>
                                    <div class="info-value total-price">€ <span id="order-total"><%=order.getImportoTotale()%></span></div>
                                </div>
                            </div>
                            
                            <button class="btn btn-primary" id="downloadInvoice" onclick="window.location.href='<%= request.getContextPath() + "/pdf/fatture/fattura_" + order.getIDOrdine() + ".pdf" %>'">
                                <i class="fas fa-file-pdf"></i> Scarica fattura
                            </button>

                            <a href="<%=request.getContextPath() + "/product"%>" class="btn btn-secondary">
                                <i class="fas fa-shopping-bag"></i> Continua lo shopping
                            </a>
                        </div>
            </div>
            <%
                        }
            %>


            <!-- Colonna destra - Riepilogo prodotti -->
            <div class="checkout-column-phone">
                <div class="iphone-frame">
                    <!-- Notch -->
                    <div class="notch">
                        <div class="speaker"></div>
                        <div class="camera"></div>
                    </div>
                    
                    <!-- Screen Content -->
                    <div class="screen-content">
                        
                        <!-- Order Summary Section -->
                        <section class="order-summary">
                            <h2 class="summary-title">
                                <i class="fas fa-shopping-bag"></i> Il tuo ordine
                            </h2>
                            
                            <div class="products-list">

                                <%
                                    if(ProductsInOrder != null)
                                    {   

                                        for(ProductBean p : ProductsInOrder)
                                        {   
                                            LinkedList<String> imagesPathsOfProduct = p.getImagesPaths();
                                            String finalPath = "";
                                            for(String path : imagesPathsOfProduct)
                                            {
                                                if(path.contains(p.getColor()))
                                                    finalPath = path;
                                            }

                                            

                                %>
                                                <!-- Prodotto 1 -->
                                                <div class="product-item">
                                                    <img src="<%=request.getContextPath() + "/images/prodotti/" + finalPath%>" alt="<%=p.getName()%>" class="product-image">
                                                    <div class="product-details">
                                                        <div class="product-name"><%=p.getName()%></div>
                                                        <div class="product-price">€ <span class="item-price"><%=p.getPrice()%></span></div>
                                                        <div class="product-quantity">Quantità: <span class="item-quantity"><%=p.getQuantityInCart()%></span></div>
                                                    </div>
                                                </div>

                                <%
                                        }
                                    }
                                %>
                            </div>

                            <%  
                                double shippingPrice = 0.0;
                                if(order.getMetodoDiSpedizione().equals("standard"))
                                {
                                    shippingPrice = 5.99;
                                }
                                else if(order.getMetodoDiSpedizione().equals("express"))
                                {
                                    shippingPrice = 9.99;
                                }

                            %>

                            <div class="summary-totals">
                                <div class="total-row">
                                    <span class="total-label">Subtotale</span>
                                    <span class="total-value" id="subtotal">€ <%=order.getImportoTotale()%></span>
                                </div>
                                
                                <div class="total-row">
                                    <span class="total-label">Spedizione</span>
                                    <span class="total-value" id="shipping">€ <%=shippingPrice%></span>
                                </div>
                                
                                
                                <div class="total-row grand-total">
                                    <span class="total-label">Totale</span>
                                    <span class="total-value" id="total">€ <%=String.format("%.2f", order.getImportoTotale() + shippingPrice)%></span>
                                </div>
                            </div>
                        </section>
                    </div>
                    
                    <!-- Home Indicator -->
                    <div class="home-indicator"></div>
                </div>
            </div>
        </main>
    </div>

    <script src="Script/ConfermaOrdineScript.js"></script>
    <%@ include file="includes/Footer.jsp" %>
</body>
</html>