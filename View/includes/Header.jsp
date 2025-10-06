<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import=" it.IStyle.model.bean.Cart, it.IStyle.model.bean.User" %>
<%-- Per attivare la versione dinamica, rimuovere i commenti dalla riga seguente --%>
<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/HeaderStyle.css"%>">

<%-- VERSIONE STATICA INIZIO --%> 
<%
    // Simulazione utente loggato (modificare per test)
    boolean autenticato = false;
    
    // Simulazione elementi nel carrello (modificare per test)
    Cart cart = (Cart) session.getAttribute("cart");
    int carrelloCount = 0;

    if(cart != null)
    {
        carrelloCount = cart.getQuantityOfProducts();
    }

    String Username = (String) session.getAttribute("Username");
    if(Username != null)
        autenticato = true; 


%>

<header>
    <div class="header-top-mobile">
        <button class="hamburger-menu" onclick="toggleMobileMenu()">
            <i class="fas fa-bars"></i>
        </button>
        <div class="logo-mobile">
            <a href="<%=request.getContextPath() + "/home" %>">
                <img src="<%=request.getContextPath() + "/images/icons/logoNuovo.png" %>" alt="Logo">
            </a>
        </div>
        <div class="cart-mobile">
            <a href="<%=request.getContextPath() + "/cart" %>" >
                <i class="fas fa-shopping-cart"></i>
                <span class="cart-count"><%= carrelloCount %></span>
            </a>
        </div>
    </div>

    <div class="header-main">
        <div class="search-box">
            <form action="ricerca.jsp" method="get" id="searchForm">
                <input type="text" name="query" id="searchInput" placeholder="Cerca tra i prodotti..." autocomplete="off">
                <button type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </form>
            <div class="search-results" id="searchResults"></div>
        </div>

        <div class="logo">
            <a href="<%=request.getContextPath() + "/home" %>">
                <img src="<%=request.getContextPath() + "/images/icons/logoNuovo.png" %>" alt="Logo">
            </a>
        </div>

        <div class="top-bar">

            <% 
                if (autenticato) 
                { 

            %>


            <a href = "<%=request.getContextPath() + "/user/wishlist"%>" class = "icon-link">
                <i class="fa-regular fa-heart icon"></i>
                <span class = "icon-label">wishlist</span>
            </a>

            <div class="dropdown" id="userDropdown">

                    <div class="icon-link dropdown-toggle" onclick="toggleDropdownMenu()">
                        <i class="fas fa-user-alt icon"></i>
                        <span class="icon-label">Account</span>
                    </div>

                    <div class="dropdown-menu" id="dropdownMenu">
                        <a href="<%=request.getContextPath() + "/user" %>"><i class="fas fa-user-circle"></i> Area Utente</a>
                        <a href="<%=request.getContextPath() + "/user/orders"%>"><i class="fas fa-box-open"></i> I miei ordini</a>
                        <a href="<%=request.getContextPath() + "/user?action=logout"%>"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
            </div>

            <% 
                } 
                else 
                { 
            %>
                <a href="<%=request.getContextPath() + "/authentication"%>" class="icon-link">
                    <i class="fas fa-user-alt icon"></i>
                    <span class="icon-label">Autenticati</span>
                    </a>
            <% } %>

            <a href="<%=request.getContextPath() + "/cart"%>" class="icon-link">
                <i class="fas fa-shopping-cart icon"></i>
                <span class="icon-label">Carrello</span>
                <span class="cart-count"><%= carrelloCount %></span>
            </a>

        </div>
    </div>

    <nav id="mainNav">
        <a href="<%=request.getContextPath() + "/product/news"%>">Novità</a>
        <a href="<%=request.getContextPath() + "/product/customizable"%>">CreaLaTuaCover</a>
        <a href="<%=request.getContextPath() + "/product"%>">Cover</a>
        <a href="<%=request.getContextPath() + "/product/accessories"%>">Accessori</a>
    </nav>

    <div class="mobile-menu" id="mobileMenu">
        <a href="<%=request.getContextPath() + "/product/news"%>">Novità</a>
        <a href="<%=request.getContextPath() + "/product/customizable"%>">CreaLaTuaCover</a>
        <a href="<%=request.getContextPath() + "/product"%>">Cover</a>
        <a href="<%=request.getContextPath() + "/product/accessories"%>">Accessori</a>
        <div class="mobile-menu-account">
            <% if (autenticato) { %>
                <a href="<%=request.getContextPath() + "/user" %>"><i class="fas fa-user-circle"></i> Area Utente</a>
                <a href="<%=request.getContextPath() + "/user/orders" %>"><i class="fas fa-box-open"></i> I miei ordini</a>
                <a href="<%=request.getContextPath() + "/user/wishlist" %>"><i class="fa-regular fa-heart icon"></i> WishList</a>
                <a href="<%=request.getContextPath() + "/user/action?logout" %>"><i class="fas fa-sign-out-alt"></i> Logout</a>
            <% } else { %>
                <a href="<%=request.getContextPath() + "/authentication"%>"><i class="fas fa-sign-in-alt"></i> Autenticati</a>
            <% } %>

        </div>
    </div>
</header>

<script>
function toggleDropdownMenu() {
    const menu = document.getElementById("dropdownMenu");
    if(menu) {
        menu.style.display = (menu.style.display === "block") ? "none" : "block";
    }
}

function toggleMobileMenu() {
    const menu = document.getElementById("mobileMenu");
    if(menu) {
        menu.style.display = (menu.style.display === "flex") ? "none" : "flex";
    }
}

// Chiudi i menu quando si clicca fuori
document.addEventListener("click", function(event) {
    const dropdown = document.getElementById("userDropdown");
    const menu = document.getElementById("dropdownMenu");
    const hamburger = document.querySelector(".hamburger-menu");
    const mobileMenu = document.getElementById("mobileMenu");

    if (menu && !dropdown.contains(event.target)) {
        menu.style.display = "none";
    }
    
    if (mobileMenu && !hamburger.contains(event.target) && !mobileMenu.contains(event.target)) {
        mobileMenu.style.display = "none";
    }
});

</script>