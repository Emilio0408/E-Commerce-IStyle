
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean" %>


<%
    LinkedList<ProductBean> bestProducts = (LinkedList<ProductBean>) request.getAttribute("bestProducts");
    LinkedList<ProductBean> otherProducts = (LinkedList<ProductBean>) request.getAttribute("otherProducts");
%>




<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Home - IStyle</title>
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/HomeStyle.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

</head>
<body class="animated-gradient" data-context-path = "<%=request.getContextPath()%>">



<%@ include file="View/includes/Header.jsp" %>

<%@ include file="View/GameWidget.jsp" %>

<!-- Background animato -->
<div id="tsparticles"></div>

<!-- Carosello 3D -->
<div class="carousel-container">
    <div id="drag-container">
        <div id="spin-container">
            <img src = "<%=request.getContextPath() + "/images/carosello/CoverAnime.png"%>">
            <img src = "<%=request.getContextPath() + "/images/carosello/CoverFast&Furious.png"%>">
            <img src = "<%=request.getContextPath() + "/images/carosello/CoverHarryPotter1.png"%>">
            <img src = "<%=request.getContextPath() + "/images/carosello/CoverHarryPotter2.png"%>">
            <img src = "<%=request.getContextPath() + "/images/carosello/CoverNaruto.png"%>">
        </div>
        <div id="ground"></div>
    </div>
</div>

<section class="categories-section">
    <h2 class="section-title">Le Nostre Categorie</h2>
    <div class="categories-grid">
        <div class="category-card">
            <div class="category-icon">
                <i class="fas fa-charging-station"></i>
            </div>
            <h3 class="category-title">Caricatori</h3>
            <p class="category-description">Caricatori wireless, USB-C, Lightning e MagSafe per tutti i tuoi dispositivi. Ricarica veloce e sicura garantita.</p>
            <button class="category-btn" onclick="location.href='<%=request.getContextPath() + "/View/Caricatori-Information.jsp" %>'">Scopri di più</button>
        </div>
        
        <div class="category-card">
            <div class="category-icon">
                <i class="fas fa-mobile-alt"></i>
            </div>
            <h3 class="category-title">Cover</h3>
            <p class="category-description">Cover personalizzate per iPhone. Proteggi il tuo smartphone con stile unico.</p>
            <button class="category-btn"onclick="location.href='<%=request.getContextPath() + "/View/Cover-Information.jsp" %>'">Scopri di più</button>
        </div>
        
        <div class="category-card">
            <div class="category-icon">
                <i class="fas fa-magnet"></i>
            </div>
            <h3 class="category-title">MagSafe</h3>
            <p class="category-description">Accessori MagSafe compatibili: caricatori, supporti auto, wallet e molto altro. Tecnologia magnetica avanzata.</p>
            <button class="category-btn" onclick="location.href='<%=request.getContextPath() + "/View/MagSafe-Information.jsp" %>'">Scopri di più</button>
        </div>
    </div>
</section>

<section class="bestseller-section">
    <h2 class="section-title">I Nostri Bestseller</h2>
    <div class="bestseller-grid">


    <%

        if(bestProducts != null && bestProducts.size() > 0)
        {
            for(ProductBean p : bestProducts)
            {

    %>

        <div class="bestseller-card">
            <div class="bestseller-badge">Bestseller</div>
            <img src="<%=request.getContextPath() +  "/images/prodotti/" + p.getImagesPaths().get(0) %>" alt="<%=p.getName()%>" class="bestseller-image">
            <h3 class="bestseller-title"> <%=p.getName()%> </h3>
            <p class="bestseller-price"> <%=p.getPrice()%> </p>
            <button class="bestseller-btn" onclick="location.href='<%= request.getContextPath() + "/product/" + p.getName() %>'">Visualizza</button>
        </div>

    <%
            }
        }
    %>


    </div>
</section>


<section class="product-section">
    <h2 class="section-title">Le nostre cover</h2>
    <div class="cover-gallery">
        <div class="cover-container">
            <div class="cover-image-container" id="cover-bg" style="background-color: #FF9E3F">
                <a href="DettaglioProdotto.jsp?product=Naruto">
                    <img id="current-cover" src="<%= request.getContextPath() + "/images/prodotti/Cover Dragon Ball Logo Goku Base Form-Blue.png" %>" alt="Cover Anime Naruto" class="cover-image">
                </a>
            </div>
            
            <div class="category-buttons">
                <button class="category-btn active" onclick="changeCover('<%= request.getContextPath() + "/images/prodotti/Cover Dragon Ball Logo Goku Base Form-Blue.png" %>', 'Cover Anime Naruto', '#FF9E3F', this, 'Naruto')">Anime</button>
                <button class="category-btn" onclick="changeCover('<%= request.getContextPath() + "/images/prodotti/Cover Game Of Thrones Logo-White.png" %>', 'Cover Film Fast & Furious', '#2D3748', this, 'FastAndFurious')">Film</button>
                <button class="category-btn" onclick="changeCover('<%= request.getContextPath() + "/images/prodotti/Cover Inter Biscione-Black.png" %>', 'Cover Calcio Inter', '#03358a', this, 'Inter')">Calcio</button>
            </div>
        </div>
    </div>
</section>

<section class="other-products">
    <h2 class="section-title">Altri prodotti</h2>
    <div class="other-products-gallery">

    <%
        if(otherProducts != null && otherProducts.size() > 0)
        {
            for(ProductBean p : otherProducts)
            {

    %>
        <a href="<%=request.getContextPath() + "/product/" + p.getName()%>" class="product-card">
            <img src="<%=request.getContextPath() + "/images/prodotti/" + p.getImagesPaths().get(0)%>" alt="Cover NASA">
            <p class = "product-title"><%= p.getName() %></p>
            <p class = "product-price"><%= p.getPrice() %></p>
            <button class="bestseller-btn" onclick="location.href='<%= request.getContextPath() + "/product/" + p.getName() %>'">Visualizza</button>
        </a>

    <%
            }
        }
    %>

    </div>
</section>




<%@ include file="View/includes/Footer.jsp" %>


<script src="https://cdn.jsdelivr.net/npm/tsparticles@2"></script>
<script src="<%=request.getContextPath() + "/Script/includes/AjaxRequests.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/Home-Script.js"%>"></script>

</body>
</html>
