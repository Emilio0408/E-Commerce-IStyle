<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean"%>


<%  

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies


    
    LinkedList<ProductBean> ProductsInWishList = (LinkedList<ProductBean>)request.getAttribute("productsInWishList");
%>




<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>WishList - IStyle</title>
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/WishListStyle.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Alert.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="animated-gradient" data-context-path ="<%=request.getContextPath()%>">

<%@ include file="includes/Alert.jsp" %>
<%@ include file="includes/Header.jsp" %>

<!-- Background animato -->
<div id="tsparticles"></div>

<div class="wishlist-container">
    
    
    <div class="wishlist-header">
        <h1 class="wishlist-title">La tua WishList</h1>
        <span class="wishlist-count">Articoli: <%=ProductsInWishList.size()%></span>
    </div>


    <%

        if(ProductsInWishList != null && ProductsInWishList.size() > 0)
        {
    %>

        <div class="wishlist-items">
            <!-- Esempio di item nella wishlist -->

            <% 
                for(ProductBean p : ProductsInWishList)
                {   

            %>

            <a href="<%= request.getContextPath() + "/product/" + p.getName()%>" class = "product-link">
                <div class="wishlist-item">
                    <img src="<%=request.getContextPath() + "/images/prodotti/" + p.getImagesPaths().get(0)%>" alt="<%=p.getName()%>" class="wishlist-item-image">
                    <div class="wishlist-item-details">
                        <h3 class="wishlist-item-title"><%=p.getName()%></h3>
                        <p class="wishlist-item-category">Categoria: <%=p.getCategory()%></p>
                        <p class="wishlist-item-price">€<%=p.getPrice()%></p>
                        <div class="wishlist-item-actions">
                            <button class="remove-item-btn" data-product-id = "<%=p.getID()%>">
                                <i class="fas fa-trash-alt"></i> Rimuovi
                            </button>
                        </div>
                    </div>
                </div>
            </a>
            
            <% 
                }
            %>

        </div>

    <%
        }
        else
        {
    %>



    <!-- Messaggio wishlist vuota -->
        <div class="empty-wishlist" id="empty-wishlist">
            <div class="empty-wishlist-icon">
                <i class="fas fa-heart-broken"></i>
            </div>
            <h3 class="empty-wishlist-message">La tua WishList è vuota</h3>
            <a href="<%=request.getContextPath() + "/product"%>" class="continue-shopping">Continua lo shopping</a>
        </div>

    <%
        }
    %>
</div>







<%@ include file="includes/Footer.jsp" %>



<script src="https://cdn.jsdelivr.net/npm/tsparticles@2"></script>
<script src="<%=request.getContextPath() + "/Script/includes/Alert.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/WishListPageScript.js"%>"></script>


</body>
</html>