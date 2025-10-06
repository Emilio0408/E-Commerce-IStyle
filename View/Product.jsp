<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean, it.IStyle.model.bean.Feedback, it.IStyle.utils.Utils, java.util.Map , java.util.HashMap, java.util.HashSet" %>


<%  
    LinkedList<ProductBean> products = (LinkedList<ProductBean>)request.getAttribute("products");
    HashSet<String> allAvaibleColors = (HashSet<String>) request.getAttribute("allAvaibleColors");
%>


<!DOCTYPE html>
<html>
<head>
    <title>Catalogo Prodotti</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/ProductPageStyle.css"%>">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/includes/Alert.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/includes/ModalCart.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/14.6.0/nouislider.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body data-context-path="<%= request.getContextPath() %>">


<%@ include file="includes/Alert.jsp" %>
<%@ include file="includes/Header.jsp" %>


<div id="tsparticles"></div>



<div class="catalogo-container">
    <aside class="sidebar">
            
        <div class="filtri-actions">
            <button type="submit" class="btn-apply-filters">
                <span>APPLICA FILTRI</span>
            </button>
        </div>

            <ul class="filtri-lista">

                <li>
                    <button class="filtro-btn">
                        <img src="<%=request.getContextPath() + "/images/icons/categories-icon.png" %>" alt="Categorie">
                        <span>CATEGORIE</span>
                    </button>
                    <div class="menu-filtri" id="categorie-menu">
                        <label><input type="checkbox">Anime</label>
                        <label><input type="checkbox">Calcio</label>
                        <label><input type="checkbox">Film</label>
                        <label><input type="checkbox">Serie TV</label>
                        <label><input type="checkbox">Accessori</label>
                        <label><input type="checkbox">Generale</label>
                    </div>
                </li>

                <li>
                    <button class="filtro-btn" >
                        <img src="<%=request.getContextPath() + "/images/icons/euro-icon.png" %>" alt="Prezzo">
                        <span>PREZZO</span>
                    </button>
                    <div class="menu-filtri" id="prezzo-menu">
                        <div class="price-slider-container">
                            <div class="price-input">
                                <div class="field">
                                    <span>Min</span>
                                    <input type="number" class="input-min" value="0" min="0" max="100">
                                </div>
                                <div class="field">
                                    <span>Max</span>
                                    <input type="number" class="input-max" value="90" min="0" max="100">
                                </div>
                            </div>
                            <div class="slider">
                                <div class="progress"></div>
                            </div>
                            <div class="range-input">
                                <input type="range" class="range-min" min="0" max="100" value="10" step="1">
                                <input type="range" class="range-max" min="0" max="100" value="90" step="1">
                            </div>
                        </div>
                    </div>
                </li>

                <li>
                    <button class="filtro-btn">
                        <img src="<%=request.getContextPath() + "/images/icons/filter-icon.png" %>" alt="Tutti i filtri">
                        <span>ALTRI FILTRI</span>
                    </button>
                    <div class="menu-filtri" id="filtri-menu">
                        <h3 class ="filter-type">Colori</h3>

                        <div class="selettori-colore-filters">

                        <%
                            if(allAvaibleColors != null && allAvaibleColors.size() > 0)
                            {
                                for(String color : allAvaibleColors)
                                {

                        %>

                                    <label><input type="checkbox"> <%=color%> </label>

                        <%
                                }
                            }
                            else
                            {
                        %>
                                    <p> Nessun colore disponibile </p>
                            
                        <%
                            }
                        %>
                        </div>
                        

                            <%-- <span class="colore-option" style="background-color: #2f3130;" onclick ="selectColor()" value ="nero" ></span>
                            <span class="colore-option" style="background-color: #3a4594;" onclick ="selectColor()" value = "blu" ></span>
                            <span class="colore-option" style="background-color: #d6111b;" onclick ="selectColor()" value = "rosso" ></span>   --%>



                        <h3 class ="filter-type">Modelli</h3>

                        <h4 class = "choise">iPhone 16</h4>
                        <label><input type="checkbox"> iPhone 16</label>
                        <label><input type="checkbox"> iPhone 16 PRO</label>
                        <label><input type="checkbox"> iPhone 16 PRO MAX</label>

                        <h4 class ="choise">iPhone 15</h4>
                        <label><input type="checkbox"> iPhone 15</label>
                        <label><input type="checkbox"> iPhone 15 PRO</label>
                        <label><input type="checkbox"> iPhone 15 PRO MAX</label>

                        <h4 class ="choise">iPhone 14</h4>
                        <label><input type="checkbox"> iPhone 14</label>
                        <label><input type="checkbox"> iPhone 14 PRO</label>
                        <label><input type="checkbox"> iPhone 14 PRO MAX</label>

                        <h4 class ="choise">iPhone 13</h4>
                        <label><input type="checkbox"> iPhone 13</label>
                        <label><input type="checkbox"> iPhone 13 PRO</label>
                        <label><input type="checkbox"> iPhone 13 PRO MAX</label>
                        <label><input type="checkbox"> iPhone 13 mini</label>

                        <h4 class ="choise">iPhone 12</h4>
                        <label><input type="checkbox"> iPhone 12</label>
                        <label><input type="checkbox"> iPhone 12 PRO</label>
                        <label><input type="checkbox"> iPhone 12 PRO MAX</label>
                        <label><input type="checkbox"> iPhone 12 mini</label>
                    </div>
                </li>
            </ul>

    </aside>

    <main class="griglia-prodotti">

        <%

            for(ProductBean p : products)
            {


        %>


            <div class="card-prodotto" data-product-id="<%= p.getID() %>"> 

                <%

                    if(p.isInWishList())
                    {

                %>
                        <button class="cuore-btn" data-product-id="<%= p.getID() %>">
                            <img src="<%=request.getContextPath() + "/images/icons/red-heart.png"%>" alt="Preferiti" class="cuore-icon">
                        </button>
                <%
                    }
                    else
                    {
                %>
                        <button class="cuore-btn" data-product-id="<%= p.getID() %>">
                            <img src="<%=request.getContextPath() + "/images/icons/heart-icon.png"%>" alt="Preferiti" class="cuore-icon">
                        </button>
                <%
                    }
                %>
                        
                    


                    <a href="<%=request.getContextPath() + "/product/" + p.getName() %>">
                        <img src="<%=request.getContextPath() + "/images/prodotti/" + p.getImagesPaths().get(0) %>" alt="<%=p.getName()%>" class="img-prodotto">
                    </a>
                    
                    <a href= "<%=request.getContextPath() + "/product/" + p.getName() %>" class="nome-prodotto"><%=p.getName()%></a>

                    <div class="prezzo">
                        €<%=String.format("%.2f", p.getPrice())%><span class="prezzo-scontato">€<%=  String.format("%.2f", p.getPrice() + 5) %></span>
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
                        <span class="<%=classe%>" style="background-color: <%=colorCode%>;" value ="<%= color %>" ></span>

                <%
                    }
                %>
                    </div>

                    <button class="btn-carrello" data-product-id="<%= p.getID() %>">
                        <img src="<%=request.getContextPath() + "/images/icons/cart-icon.png"%>" alt="Aggiungi al carrello" class="carrello-icon"> Aggiungi
                    </button>

            </div>


        <%  
            }
        %>
    </main>
</div>

<%@ include file="includes/Footer.jsp" %>

<!-- carrello modale -->
<%@ include file="includes/ModalCart.jsp" %>


<script src="<%=request.getContextPath() + "/Script/includes/Alert.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/ProductPageScript.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/includes/ModalCart.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/includes/AjaxRequests.js"%>"></script>

</body>
</html>