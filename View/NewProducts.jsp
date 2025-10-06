<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean, java.util.HashMap, java.util.Map "%>


<%

    LinkedList<ProductBean> lastAddedProducts = (LinkedList<ProductBean>) request.getAttribute("lastAddedProducts");
%>




<!DOCTYPE html>
<html>
<head>
    <title>Novità</title>


    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/NewProductsPageStyle.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/includes/ModalCart.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/includes/Alert.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body data-context-path = "<%=request.getContextPath()%>">


<%@ include file="includes/Header.jsp" %>


<div class="novita-container">  
  <h1 class="section-title">Le nostre novità</h1>
    <main class="griglia-prodotti">     


        <%  
            if(lastAddedProducts != null && lastAddedProducts.size() > 0)
            {
                for(ProductBean product : lastAddedProducts)
                {
        %>


            <div class="card-prodotto"  data-product-id="<%= product.getID() %>">  

                <%
                    if(product.isInWishList())
                    {
                %>
                        <button class="cuore-btn" data-product-id="<%= product.getID() %>">
                            <img src="<%=request.getContextPath() + "/images/icons/red-heart.png"%>" alt="Preferiti" class="cuore-icon">
                        </button>

                <%
                    }
                    else
                    {
                %>

                        <button class="cuore-btn" data-product-id="<%= product.getID() %>">
                            <img src="<%=request.getContextPath() + "/images/icons/heart-icon.png"%>" alt="Preferiti" class="cuore-icon">
                        </button>

                <%
                    }
                %>
                
                <div class="badge-novita">NUOVO</div>
                
                <a href="<%=request.getContextPath() + "/product/" + product.getName()%>">
                    <img src="<%=request.getContextPath() + "/images/prodotti/" + product.getImagesPaths().get(0)%>" alt="<%=product.getName()%>" class="img-prodotto">
                </a>
                
                <a href="<%=request.getContextPath() + "/product/" + product.getName()%>" class="nome-prodotto"><%=product.getName()%></a>

                <div class="prezzo">
                    €<%=product.getPrice()%>
                </div>

                <div class="selettori-colore">

                    <%
                        HashMap<String,String> colorsOfProduct = product.getAvaibleColors();
                        String imagePath = product.getImagesPaths().get(0);
                        int startIndex = imagePath.indexOf('-') + 1;
                        int endIndex = imagePath.lastIndexOf('.');
                        String colorOfProductInImage = imagePath.substring(startIndex,endIndex);

                        for(Map.Entry<String,String> entry: colorsOfProduct.entrySet())
                        {       
                            String color = entry.getKey();
                            String colorCode = entry.getValue();
                            String classe = "colore-option";

                            if(colorOfProductInImage.equals(color))
                            {
                                classe = "colore-option active";
                            }

                    %>

                            <span class="<%=classe%>" style="background-color:<%=colorCode%>;" value ="<%=color%>" ></span>

                    <%
                        }
                    %>

                </div>


                <button class="btn-carrello" data-product-id="<%= product.getID() %>">
                    <img src="<%=request.getContextPath() + "/images/icons/cart-icon.png"%>" alt="Aggiungi al carrello" class="carrello-icon"> Aggiungi
                </button>
            </div>

        <%
                }
            }

        %>
    </main>

    <%
            if(lastAddedProducts == null || lastAddedProducts.size() == 0)
            {
    %>


                <div class="empty-message" id="empty-message">
                    <div class="empty-product-icon">
                        <i class="fas fa-box-open"></i> 
                    </div>
                    <h3 class="empty-product-message">Attualmente non ci sono prodotti disponibili in questa sezione</h3>
                    <a href="<%=request.getContextPath() + "/home"%>" class="back-home">Torna alla home</a>
                </div>

    <%
            }
    %>


    
</div>



<%@ include file="includes/Footer.jsp" %>
<%@ include file="includes/ModalCart.jsp" %>
<%@ include file="includes/Alert.jsp" %>


<script src="<%=request.getContextPath() + "/Script/includes/Alert.js" %>"></script>
<script src="<%=request.getContextPath() + "/Script/includes/AjaxRequests.js" %>"></script>
<script src="<%=request.getContextPath() + "/Script/includes/ModalCart.js" %>"></script>
<script src="<%=request.getContextPath() + "/Script/NewProductPageScript.js" %>"></script>


</body>
</html>