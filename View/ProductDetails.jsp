<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean, it.IStyle.model.bean.Feedback, it.IStyle.utils.Utils, java.util.Map , java.util.HashMap, java.util.HashSet" %>


<%

    ProductBean product = (ProductBean) request.getAttribute("product");
    LinkedList<Feedback> Feedbacks = (LinkedList<Feedback>) request.getAttribute("Feedbacks");
    LinkedList<ProductBean> otherProducts = (LinkedList<ProductBean>) request.getAttribute("otherProducts");

    if(product == null)
        response.sendError(400);
%>


<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dettaglio Cover</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/ProductDetailsStyle.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() +  "/StyleSheet/includes/Alert.css"%>">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/StyleSheet/includes/ModalCart.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/tsparticles@2"></script>
</head>
<body  data-context-path="<%= request.getContextPath() %>" data-product-id="<%= product.getID() %>">

<%@ include file="includes/Alert.jsp" %>

<%@ include file="includes/Header.jsp" %>



<div class="dettaglio-prodotto-container">

    <!-- TOP -->
    <div class="prodotto-top">

        <!-- Immagini -->
        <div class="immagini-prodotto">
            <!-- Floating preview bar -->

        <%
            LinkedList<String> ProductImagesPaths = product.getImagesPaths(); 
        %>

            <div class="immagine-principale-container">

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

                <div class="image-wrapper" id="imageWrapper">
                    <img src="<%=request.getContextPath() + "/images/prodotti/" + ProductImagesPaths.get(0) %>" alt="<%=product.getName()%>" class="immagine-principale" id="productImage" data-full="<%=request.getContextPath() + "/images/prodotti/" + ProductImagesPaths.get(0) %>">
                </div>
            </div>
        </div>

        <!-- Dettagli -->
        <div class="dettagli-prodotto">
            <h2 class="titolo-prodotto">  <%= product.getName() %>  </h2>
            <p class="prezzo">€19,99</p>
            <p class="colore">Colore:</p>



            <div class="selettori-colore">

            <%
                HashMap<String,String> avaibleColors = product.getAvaibleColors();
                String imagePath = product.getImagesPaths().get(0);
                int startIndex = imagePath.indexOf('-') + 1;
                int endIndex = imagePath.lastIndexOf('.');
                String colorOfProductInImage = imagePath.substring(startIndex,endIndex);
                if( avaibleColors != null && avaibleColors.size() > 0 )
                {    
                    for(Map.Entry<String,String> entry: avaibleColors.entrySet())
                    {       
                        String color = entry.getKey();
                        String colorCode = entry.getValue();
                        String classe = "colore-option";

                        if(colorOfProductInImage.equals(color))
                            classe = "colore-option active";

            %> 
                    <span class="<%=classe%>"  data-color = "<%=color%>" value ="<%= color %>" style="background-color: <%=colorCode%>;"></span>

            <%

                    }
                }
                else
                {
            %>

                <span class = "colore-option non-disponibile" style ="background-color:white"></span> 
            <%
                }
            %>

            </div>

            <p class = "modello"> Modello: </p>
            <select class="select-modello" name="model" id="modelSelect">
            </select>



            <div class="azioni-prodotto">
                <button class="btn-carrello" data-product-id="<%= product.getID() %>">
                    <i class="fas fa-shopping-cart"></i> Aggiungi al carrello
                </button>
            </div>

            <div class="spedizione-info">
                <p><i class="fas fa-truck"></i> Spedizione express in soli 2 giorni</p>
                <p><i class="fas fa-store"></i> Ritiro in negozio disponibile</p>
            </div>
        </div>
    </div>

    <!-- Descrizione -->
    <section class="descrizione-sezione">
        <h3>Caratteristiche della cover</h3>
        <p> 
            <%=product.getDescription() %>
        </p>
    </section>

    <!-- Recensioni -->
    <section class="recensioni-sezione">
        <h3>Recensioni dei clienti</h3>
        
        <!-- Statistiche valutazioni -->
        <div class="rating-overview">



            <div class="rating-summary">
                <div class="average-rating">
                    <span class="rating-value"> <%= Utils.getFeedbacksAverage(Feedbacks)%></span>

                    <div class="stars">

                    <%
                        int count = 5;
                        int FeedbacksAverage = (int) Utils.getFeedbacksAverage(Feedbacks);
                        double OriginalFeedbacksAverage = Utils.getFeedbacksAverage(Feedbacks);
                        for(int i = 0 ; i < FeedbacksAverage ; i++)
                        {
                    %>
                            <i class="fas fa-star"></i>

                    <%
                            count--;
                        }

                        if( (OriginalFeedbacksAverage - Math.floor(OriginalFeedbacksAverage)) >= 0.5 )
                        {
                    %>
                            <i class="fas fa-star-half-alt"></i>

                    <%
                            count--;
                        }

                        for(int i = 0 ; i < count ; i++)
                        {

                    %>

                            <i class="fas fa-star" style= "color: #ddd"></i>
                
                    <%
                        }
                    %>
                    </div>
                    
                    <span class="total-reviews"><%=Feedbacks.size()%> recensioni</span>
                </div>

                <%
                    HashMap<Integer,Integer> votePercentages = (HashMap<Integer,Integer>) Utils.getVotePercentages(Feedbacks);
                %>


                <div class="rating-bars">


                    <div class="rating-bar">
                        <span>5 stelle</span>
                        <div class="bar-container">
                            <div class="bar" style="width: <%=votePercentages.get(5)%>%"></div>
                        </div>
                        <span><%=votePercentages.get(5)%>%</span>
                    </div>


                    <div class="rating-bar">
                        <span>4 stelle</span>
                        <div class="bar-container">
                            <div class="bar" style="width: <%=votePercentages.get(4)%>%"></div>
                        </div>
                        <span><%=votePercentages.get(4)%>%</span>
                    </div>


                    <div class="rating-bar">
                        <span>3 stelle</span>
                        <div class="bar-container">
                            <div class="bar" style="width: <%=votePercentages.get(3)%>%"></div>
                        </div>
                        <span><%=votePercentages.get(3)%>%</span>
                    </div>


                    <div class="rating-bar">
                        <span>2 stelle</span>
                        <div class="bar-container">
                            <div class="bar" style="width: <%=votePercentages.get(2)%>%"></div>
                        </div>
                        <span><%=votePercentages.get(2)%>%</span>
                    </div>

                    <div class="rating-bar">
                        <span>1 stella</span>
                        <div class="bar-container">
                            <div class="bar" style="width: <%=votePercentages.get(1)%>%"></div>
                        </div>
                        <span><%=votePercentages.get(1)%>%</span>
                    </div>


                </div>
            </div>
        </div>
        
        <!-- Form per aggiungere recensione -->
        <div class="add-review-form">
            <h4>Scrivi una recensione</h4>
            <form id="reviewForm">
                <div class="form-group">
                    <label>Valutazione</label>
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5">
                        <label for="star5" class="star"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star4" name="rating" value="4">
                        <label for="star4" class="star"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star3" name="rating" value="3">
                        <label for="star3" class="star"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star2" name="rating" value="2">
                        <label for="star2" class="star"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star1" name="rating" value="1">
                        <label for="star1" class="star"><i class="fas fa-star"></i></label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="reviewText">Recensione</label>
                    <textarea id="reviewText" name="review" rows="5" placeholder="Condividi la tua esperienza..." required></textarea>
                </div>

                <button type="submit" class="btn-submit-review">Invia recensione</button>
            </form>
        </div>
        
        <!-- Lista recensioni -->
        <div class="reviews-list" id="reviewsList">

        <% 
            if(Feedbacks != null && Feedbacks.size() > 0)
            {
                for(Feedback f : Feedbacks)
                {
        %>
                    <div class="review-item">
                        <div class="review-header">
                        <div class="reviewer"> <%=f.getUsername()%> </div>
                        <div class="review-date"> <%=f.getReviewDate()%></div>
                    </div>

                    <div class="review-rating">

        <%       
                

                    count = 5;
                    int FeedbackVote = (int) f.getVote();
                    double OriginalFeedbackVote = f.getVote();

                    for(int i = 0 ; i < FeedbackVote ; i++)
                    {
        %>
                        <i class="fas fa-star"></i>
                    
        <%          
                        count--;
                    }
                    for(int i = 0 ; i < count ; i++)
                    {
        %>
                        <i class="fas fa-star" style= "color: #ddd"></i>

        <%
                     }
        %>

                    </div>
                    <p class="review-text"><%= f.getText()%></p>
        <%  
                }
            }
            else
            {
        %>


        <div class="no-review">  
            <div class="no-review-content">
                <i class="fas fa-comment-slash" style="font-size: 2em; margin-bottom: 10px;"></i>
                <p>Non sono ancora presenti recensioni per questo prodotto</p>
            </div>
        </div>

        
        <% 
            }
        %>

    </section>

    <!-- Simili -->
    <section class="prodotti-simili-sezione">
        <h3>Potrebbero piacerti anche</h3>
    <div class="griglia-prodotti-simili">

    <%
        for(ProductBean p : otherProducts)
        {
            
    %>


    <a href = "<%= request.getContextPath() + "/product/" + p.getName()%>" class = "card-link">        
        <div class="card-prodotto" data-product-id="<%= p.getID() %>">
            <img class = "img-prodotto" src="<%=request.getContextPath() + "/images/prodotti/" + p.getImagesPaths().get(0) %>" alt="<%=p.getName()%>">
            <p><%= p.getName() %></p>
            <p><%= p.getPrice() %></p>
            <div class="selettori-colore">

        <%
            HashMap<String,String> colors = p.getAvaibleColors();
            imagePath = p.getImagesPaths().get(0);
            startIndex = imagePath.indexOf('-') + 1;
            endIndex = imagePath.lastIndexOf('.');
            colorOfProductInImage = imagePath.substring(startIndex,endIndex);


            for(Map.Entry<String,String> entry: colors.entrySet())
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
        </div>
    </a>

    <%      
        }
    %>

        
    </div>
    </section>
</div>



<%@ include file="includes/Footer.jsp" %>


<%@ include file="includes/ModalCart.jsp" %>



<script src = "<%=request.getContextPath() + "/Script/includes/Alert.js"%>"></script>
<script src = "<%=request.getContextPath() + "/Script/includes/AjaxRequests.js"%>"></script>
<script src = "<%=request.getContextPath() + "/Script/Product-Details.js"%>"></script>
<script src = "<%=request.getContextPath() + "/Script/includes/ModalCart.js"%>"></script>

</body>
</html>

</body>
</html>