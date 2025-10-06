<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean, it.IStyle.model.bean.Cart, it.IStyle.model.bean.Address" %>


<%
    //Recupere dati di sessione
    String email = (String) session.getAttribute("email");
    String name = (String) session.getAttribute("Name");
    String surname = (String) session.getAttribute("Surname");
    Cart cart = (Cart) session.getAttribute("cart");
    LinkedList<Address> userAddresses = (LinkedList<Address>) request.getAttribute("userAddresses");
    

%>



<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Il Tuo Negozio</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/CheckoutStyle.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Alert.css"%>">
</head>
<body data-context-path="<%=request.getContextPath()%>">

    <%@ include file="includes/Alert.jsp" %>

    <div class="checkout-container">
        <!-- Header del checkout con steps -->
        <header class="checkout-header">
            <div class="checkout-header-content">
                <h1 class="checkout-title">Completa il tuo ordine</h1>
                
                <div class="checkout-steps">
                    <div class="step active">
                        <div class="step-number">1</div>
                        <span class="step-label">Dati personali</span>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <span class="step-label">Pagamento</span>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <span class="step-label">Conferma</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main content -->
        <main class="checkout-main">
            <!-- Colonna sinistra - Form -->
            <div class="checkout-column">
                <button class="btn-back">
                    <i class="fas fa-arrow-left"></i> Torna al carrello
                </button>

                <!-- Sezione dati personali -->
                <section class="checkout-form-section">
                    <h2 class="form-section-title">
                        <i class="fas fa-user"></i> Dati personali
                    </h2>
                    
                    <form id="checkout-form">
                        <div class="form-group">
                            <label for="name" class="form-label">Nome completo</label>
                            <input type="text" id="name" class="form-control" value ="<%=name + " " + surname%>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" id="email" class="form-control" value ="<%=email%>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone" class="form-label">Telefono</label>
                            <input type="tel" id="phone" class="form-control" required>
                        </div>
                    </form>
                </section>

                <!-- Sezione indirizzo di spedizione -->
                <section class="checkout-form-section">
                    <h2 class="form-section-title">
                        <i class="fas fa-truck"></i> Indirizzo di spedizione
                    </h2>
                    
                    <div class="form-group">
                        <div class="address-switch-container">
                            <div class="address-switch">
                                <input type="checkbox" id="address-toggle" class="address-toggle">
                                <label for="address-toggle" class="address-switch-slider">
                                    <span class="address-switch-option address-switch-right">Nuovo indirizzo</span>
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <div id="saved-addresses" class="address-selection">
                        <select id="saved-address-select" class="form-control">
                        <%
                            if(userAddresses != null && userAddresses.size() > 0)
                            {   
                        %>  
                                <option value="">Seleziona un indirizzo salvato</option>

                        <%
                                for(Address address: userAddresses)
                                {
                        %>
                                    <option value="<%=address.getFullAddress()%>"><%=address.getFullAddress()%></option>
                        <%
                                }
                            }
                            else
                            {
                        %>
                                <option value="">Non ci sono indirizzi salvati</option>

                        <%
                            }
                        %>
                        </select>
                    </div>
                    
                    <div id="new-address-form" class="address-form" style="display: none;">
                        <div class="form-group">
                            <label for="address" class="form-label">Indirizzo</label>
                            <input type="text" id="address" class="form-control" required>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="city" class="form-label">Città</label>
                                <input type="text" id="city" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="zip" class="form-label">CAP</label>
                                <input type="text" id="zip" class="form-control" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="country" class="form-label">Paese</label>
                            <select id="country" class="form-control" required>
                                <option value="">Seleziona...</option>
                                <option value="IT">Italia</option>
                                <option value="FR">Francia</option>
                                <option value="DE">Germania</option>
                                <option value="ES">Spagna</option>
                            </select>
                        </div>
                    </div>
                </section>

                <!-- Sezione metodo di spedizione -->
                <section class="checkout-form-section">
                    <h2 class="form-section-title">
                        <i class="fas fa-shipping-fast"></i> Metodo di spedizione
                    </h2>
                    
                    <div class="shipping-methods">
                        <label class="radio-option shipping-method">
                            <input type="radio" name="shippingMethod" value="standard" checked data-price="5.99">
                            <div class="shipping-method-content">
                                <span class="shipping-method-name">Spedizione Standard</span>
                                <span class="shipping-method-details">Consegna in 3-5 giorni lavorativi</span>
                                <span class="shipping-method-price">€ 5.99</span>
                            </div>
                        </label>
                        
                        <label class="radio-option shipping-method">
                            <input type="radio" name="shippingMethod" value="express" data-price="9.99">
                            <div class="shipping-method-content">
                                <span class="shipping-method-name">Spedizione Express</span>
                                <span class="shipping-method-details">Consegna in 1-2 giorni lavorativi</span>
                                <span class="shipping-method-price">€ 9.99</span>
                            </div>
                        </label>
                    </div>
                </section>

                <button type="submit" class="btn btn-primary">
                    Procedi al pagamento
                </button>
            </div>

            <!-- Colonna destra - Riepilogo ordine dentro iPhone -->
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
                                if(cart != null && cart.getProducts().size() > 0)
                                {
                                    LinkedList<ProductBean> productsInCart = cart.getProducts();
                                    for(ProductBean product : productsInCart)
                                    {   
                                        LinkedList<String> ImagesPaths = product.getImagesPaths();
                                        String imagePath = "";
                                        for(String path : ImagesPaths)
                                        {
                                            if(path.contains(product.getColor()))
                                                imagePath = path;
                                        }
                            %>

                                <!-- Prodotto 1 -->
                                        <div class="product-item">
                                            <img src="<%=request.getContextPath() + "/images/prodotti/" + imagePath %>" alt="Prodotto" class="product-image">
                                            <div class="product-details">
                                                <div class="product-name"><%=product.getName()%></div>
                                                <div class="product-price">€ <%=product.getPrice()%></div>
                                                <div class="product-quantity">Quantità: <%=product.getQuantityInCart()%></div>
                                            </div>
                                        </div>
                            <%
                                    }
                                }
                            %>
                                
                            
                            <div class="summary-totals">
                                <div class="total-row">
                                    <span class="total-label">Subtotale</span>
                                    <span class="total-value" id="subtotal">€ <%=cart.getTotal()%></span>
                                </div>
                                
                                <div class="total-row">
                                    <span class="total-label">Spedizione</span>
                                    <span class="total-value" id="shipping-cost"></span>
                                </div>
                                
                                
                                <div class="total-row grand-total">
                                    <span class="total-label">Totale</span>
                                    <span class="total-value" id="grand-total">€ <%=cart.getTotal()%></span>
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
    
    <script src="<%=request.getContextPath() + "/Script/includes/Alert.js"%>"></script>
    <script src="<%=request.getContextPath() + "/Script/CheckoutScript.js"%>"></script>
</body>
</html>