<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import=" it.IStyle.model.bean.Cart, it.IStyle.model.bean.ProductBean, it.IStyle.model.bean.User, java.util.LinkedList,java.util.HashMap,java.util.Map" %>

<%
    LinkedList<ProductBean> customizableProducts = (LinkedList<ProductBean>) request.getAttribute("customizableProducts");
%>





<!DOCTYPE html>
<html>
<head>
    <title>Cover Personalizzabili</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/CustomizableProductsStyle.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body data-context-path = "<%=request.getContextPath()%>">

<%@ include file="includes/Header.jsp" %>




<div class="personalizzabili-container">  


  <h1 class="section-title">Cover Personalizzabili</h1>
   
    <main class="griglia-prodotti">   

    <%
        if(customizableProducts != null && customizableProducts.size() > 0)
        {

            for(ProductBean p: customizableProducts)
            {
    %>


        
        <div class="card-prodotto" data-product-id ="<%=p.getID()%>">            
                <div class="badge-personalizzabile">PERSONALIZZABILE</div>
                
                <a href="<%=request.getContextPath() + "/product/" + p.getName()%>">
                    <img src="<%=request.getContextPath() + "/images/prodotti/" + p.getImagesPaths().get(0)%>" alt="<%=p.getName()%>" class="img-prodotto">
                </a>
                
                <a href="<%=request.getContextPath() + "/product/" + p.getName()%>" class="nome-prodotto"><%=p.getName()%></a>

                <div class="prezzo">
                    €<%=p.getPrice()%>
                </div>


                <div class="selettori-colore">

                <%  
                    HashMap<String,String> colorsOfProduct = p.getAvaibleColors();
                    String imagePath = p.getImagesPaths().get(0);
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

                    <span class="<%=classe%>" style="background-color:<%=colorCode%>"  value ="<%=color%>" ></span>
                
                
                <%
                    }
                %>
                
                </div>




                <a href="" class="btn-personalizza">
                    <i class="fas fa-paint-brush"></i> Personalizza
                </a>
        </div>

    <%
            }
        }
    %>

    </main>

    <%
        if(customizableProducts == null || customizableProducts.size() == 0)
        {

    %>
            <div class="no-products-container">
                <div class="no-products-content">
                    <div class="no-products-icon">
                        <i class="fas fa-paint-brush"></i>
                    </div>
                    <h2 class="no-products-title">Nessun prodotto personalizzabile disponibile</h2>
                    <p class="no-products-message">Al momento non abbiamo cover personalizzabili nel nostro catalogo.</p>
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


<script src="<%=request.getContextPath() + "/Script/includes/AjaxRequests.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/CustomizableProductsPageScript.js"%>"></script>




</body>
</html>
