<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean, it.IStyle.model.bean.Cart"%>



<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Carrello - IStyle</title>
    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/CartStyle.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/includes/Alert.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="animated-gradient"  data-context-path="<%= request.getContextPath() %>">

<%@ include file="includes/Header.jsp" %>

<!-- Background animato -->
<div id="tsparticles"></div>

<div class="cart-container">
    <h2 class="section-title">Il tuo carrello</h2>
    
    <div class="cart-items">
        <!-- Esempio di item nel carrello -->


        <%          
            LinkedList<ProductBean> productsInCart = null;
            if(cart != null)
            {
                productsInCart = cart.getProducts();
            }



            if(productsInCart != null && productsInCart.size() > 0)
            {
                for(ProductBean product: productsInCart)
                {

        %>
                <div class="cart-item">

                    <%
                        LinkedList<String> ImagesOfProduct = product.getImagesPaths();
                        String path = "";

                        for(String p : ImagesOfProduct)
                        {
                            if(p.contains(product.getColor()))
                                path = p;
                        }


                    %>

                    <img src="<%=request.getContextPath() + "/images/prodotti/" + path %>" alt="<%=product.getName()%>" class="cart-item-image">
                    <div class="cart-item-details" data-id ="<%=product.getID()%>" data-color = "<%=product.getColor()%>" data-model = "<%=product.getModel()%>">

                        <h3 class="cart-item-title"><%=product.getName()%></h3>
                        <p class="cart-item-category">Categoria: <%=product.getCategory()%> </p>
                        <p class="cart-item-category">Colore: <%=product.getColor()%></p>
                        <p class="cart-item-category">Modello: <%=product.getModel()%> </p>
                        <p class="cart-item-price">€<%=product.getPrice()%></p>

                        <div class="quantity-control">
                            <button class="quantity-btn decreaseQuantity"><i class="fas fa-minus"></i></button>
                            <input type="number" value="<%=product.getQuantityInCart()%>" min="1" class="quantity-input">
                            <button class="quantity-btn addQuantity"><i class="fas fa-plus"></i></button>
                        </div>

                        <button class="remove-item">
                            <i class="fas fa-trash-alt"></i> Rimuovi
                        </button>


                    </div>
                </div>
        
    <%
                }
    %>
            <div class="cart-summary">
                <!-- Riga sconto nascosta inizialmente -->
                <div class="summary-row" id="discount-row" style="display:none;">
                    <span>Sconto (<span id="applied-code"></span>)</span>
                    <span id="discount-amount">€0.00</span>
                </div>
                <div class="summary-row">
                    <span>Totale</span>
                    <span class="summary-total" id="total"><%=cart.getTotal()%></span>
                </div>
                
                <!-- Campo per codice sconto -->
                <div class="discount-code">
                    <input type="text" id="coupon-code" placeholder="Codice sconto">
                    <button id="apply-coupon" class="apply-btn">Applica</button>
                </div>
                
                <button onclick="location.href='<%= request.getContextPath() %>/checkout'"  class="checkout-btn">Procedi al checkout</button>
            </div>
        </div>


    <%      
            }
            else 
            {
    %>
    
                <!-- Messaggio carrello vuoto -->
                <div class="empty-cart" id="empty-cart">
                    <div class="empty-cart-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <h3 class="empty-cart-message">Il tuo carrello è vuoto</h3>
                    <a href="<%=request.getContextPath() + "/product"%>" class="continue-shopping checkout-btn">Continua lo shopping</a>
                </div>

    <%
            }
    %>

</div>



<%@ include file="includes/Footer.jsp" %>
<%@ include file="includes/Alert.jsp" %>



<script src="https://cdn.jsdelivr.net/npm/tsparticles@2"></script>
<script src="<%=request.getContextPath() + "/Script/includes/Alert.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/CartScript.js"%>"></script>

</body>
</html>