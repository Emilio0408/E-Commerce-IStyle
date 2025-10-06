<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean, it.IStyle.model.bean.Feedback, it.IStyle.utils.Utils, java.util.Map , java.util.HashMap, java.util.HashSet" %>



<!DOCTYPE html>

<%
    LinkedList<ProductBean> accessesories = (LinkedList<ProductBean>)request.getAttribute("accessories"); 
%>


<html>
<head>
    <title>Accessori per iPhone</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/AccessoriesStyle.css"%>">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/includes/ModalCart.css"%>">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/includes/Alert.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body data-context-path = "<%=request.getContextPath()%>">

<%@ include file="includes/Alert.jsp" %>
<%@ include file="includes/Header.jsp" %>



<div class="accessori-container">  
  <h1 class="section-title">Accessori per iPhone</h1>
  
  <main class="griglia-accessori">


    <%
        if(accessesories != null && accessesories.size() > 0)
        { 
            for(ProductBean accessory : accessesories)
            {
    %>    

                <div class="card-prodotto" data-product-id="<%=accessory.getID()%>">

                <%
                    if(accessory.isInWishList())
                    {

                %>
                    <button class="cuore-btn" data-product-id="<%=accessory.getID()%>">
                      <img src="<%=request.getContextPath() + "/images/icons/red-heart.png"%>" alt="Preferiti" class="cuore-icon">
                    </button>
                <%
                    }
                    else
                    {
                %>
                        <button class="cuore-btn" data-product-id="<%=accessory.getID()%>" >
                          <img src="<%=request.getContextPath() + "/images/icons/heart-icon.png"%>" alt="Preferiti" class="cuore-icon">
                        </button>
                <%
                    }
                %>
                        
                  <a href="<%=request.getContextPath() + "/product/" + accessory.getName()%>">
                    <img src="<%=request.getContextPath() + "/images/prodotti/" + accessory.getImagesPaths().get(0)%>" alt="Powerbank magsafe" class="img-prodotto">
                  </a>

                  <a href="<%=request.getContextPath() + "/product/" + accessory.getName()%>" class="nome-accessorio"><%=accessory.getName()%></a>
                  <div class="categoria-accessorio">Powerbank</div>

                  <div class="prezzo">
                    €<%=accessory.getPrice()%>
                  </div>

                <div class="selettori-colore">

                <%
                    HashMap<String,String> colorsOfProduct = accessory.getAvaibleColors();
                    String imagePath = accessory.getImagesPaths().get(0);
                    int startIndex = imagePath.indexOf('-') + 1;
                    int endIndex = imagePath.lastIndexOf('.');
                    String colorOfProductInImage = imagePath.substring(startIndex,endIndex);


                    for(Map.Entry<String,String> entry: colorsOfProduct.entrySet())
                    {       
                        String color = entry.getKey();
                        String colorCode = entry.getValue();
                        String classe = "colore-option";

                        if(colorOfProductInImage.equals(color))
                            classe = "colore-option active";

                %>


                        <span class="<%=classe%>" style="background-color: <%=colorCode%>;" value ="<%= color %>" ></span>

                <%
                    }
                %>

                </div>



                  <button class="btn-carrello" data-product-id="<%=accessory.getID()%>">
                    <img src="<%=request.getContextPath() + "/images/icons/cart-icon.png"%>" alt="Aggiungi al carrello" class="carrello-icon"> Aggiungi
                  </button>
                </div> 
      <%
            }
          }
      %>


  </main>

  <%
      if(accessesories == null || accessesories.size() == 0)
      {
  %>
          <div class="no-products-container">
              <div class="no-products-content">
                  <div class="no-products-icon">
                      <i class="fas fa-box-open"></i>
                  </div>
                              
                  <h2 class="no-products-title">Nessun accessorio disponibile</h2>
                  <p class="no-products-message">Al momento non abbiamo accessori disponibili nel nostro catalogo.</p>
                  <a href="<%=request.getContextPath()%>/home" class="no-products-button">
                      <i class="fas fa-arrow-left"></i> Torna alla home
                  </a>
              </div>
          </div>

  <%
      }
  %>
  
</div>


<%@ include file="includes/Footer.jsp" %>
<%@ include file="includes/ModalCart.jsp" %>


<script src="<%=request.getContextPath() + "/Script/includes/Alert.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/includes/AjaxRequests.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/includes/ModalCart.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/AccessoriesScript.js"%>"></script>



</body>
</html>