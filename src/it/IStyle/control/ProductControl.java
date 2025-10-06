package it.IStyle.control;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import it.IStyle.model.bean.Feedback;
import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.bean.Variation;
import it.IStyle.model.dao.ProductModel;
import it.IStyle.model.dao.WishListModel;
import it.IStyle.utils.Utils;




public class ProductControl extends HttpServlet
{
    private static ProductModel ProductModel;
    private static WishListModel wishListModel;

    static
    {
        ProductModel = new ProductModel();
        wishListModel = new WishListModel();
    }

    public ProductControl(){}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {   

        String action = request.getParameter("action"); 
        HttpSession session = request.getSession(false);

        try
        {
            if(action == null)
            {   
                String pathInfo = request.getPathInfo();

                if(pathInfo != null && pathInfo.length() > 1)
                {   
                    if(pathInfo.substring(1).equals("news"))
                    {
                        handleGetNewsPageRequest(request, response,session);
                    }
                    else if(pathInfo.substring(1).equals("customizable"))
                    {
                        handleGetCustomizableProductsPageRequest(request, response,session);
                    }
                    else if(pathInfo.substring(1).equals("accessories"))
                    {
                        handleGetAccessoriesPageRequest(request,response,session);
                    }
                    else
                    {
                        handleGetProductDetailsPageRequest(request, response,session);
                    }
                }
                else //Vuol dire che la richiesta è stata fatta direttamente all'url IStyle/product, pertanto visualizziamo tutti i prodotti
                {
                    handleGetProductPageRequest(request, response, session);
                }

                return;
            }

            
            if(action.equals("Filter"))
            {
                handleFilterApplicationAction(request, response,session);
            }
            else if(action.equals("Search"))
            {
                handleAdptiveSearchAction(request, response);
            }
            else if(action.equals("AddFeedback"))
            {
                handleAddFeedbackAction(request, response, session);
            }
            else if(action.equals("selectProductData"))
            {
                handleSelectProductDataAction(request,response,session);
            }
        }
        catch(SQLException e)
        {
            System.out.println("Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        doGet(request, response);
    }



    //HANDLE GET REQUEST FUNCTIONS

    private void handleGetProductPageRequest(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws SQLException, IOException,ServletException
    {   


        RequestDispatcher dispatcher = null;
        LinkedList<ProductBean> products = (LinkedList<ProductBean>) ProductModel.doRetrieveAll(null);
        HashSet<String> colors = ProductModel.doRetrieveAllAvaibleColor();


        if(session != null && session.getAttribute("Username") != null) //Se l'utente è autenticato prendiamo anche tutti i prodotti in wishlist.
            checkProductsInWishList(products, session);

        request.removeAttribute("products");
        request.setAttribute("products",products);
        request.setAttribute("allAvaibleColors", colors);
        dispatcher = this.getServletContext().getRequestDispatcher("/View/Product.jsp");
        dispatcher.forward(request, response);
    }

    private void handleGetNewsPageRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException,ServletException
    {
        LinkedList<ProductBean> lastAddedProducts = ProductModel.doRetrieveLastAddedProducts(5);
        RequestDispatcher dispatcher = null;

        if(session != null && session.getAttribute("Username") != null)
            checkProductsInWishList(lastAddedProducts, session);


        if(lastAddedProducts != null && lastAddedProducts.size() > 0)
            request.setAttribute("lastAddedProducts", lastAddedProducts);
        

        dispatcher = this.getServletContext().getRequestDispatcher("/View/NewProducts.jsp");
        dispatcher.forward(request, response);

    }


    private void handleGetCustomizableProductsPageRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException, ServletException
    {
        LinkedList<ProductBean> customizableProducts = ProductModel.doRetrieveByFilter(null, 0, 100, null, null, true);
        RequestDispatcher dispatcher = null;

        if(session != null && session.getAttribute("Username") != null )
            checkProductsInWishList(customizableProducts, session);

        request.setAttribute("customizableProducts", customizableProducts);


        dispatcher = this.getServletContext().getRequestDispatcher("/View/CustomizableProducts.jsp");
        dispatcher.forward(request, response);
    }

    private void handleGetProductDetailsPageRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException,IOException,ServletException
    {   
        RequestDispatcher dispatcher = null;
        String productName = request.getPathInfo().substring(1);
        ProductBean product = ProductControl.ProductModel.doRetrieveByName(productName);

        if(product != null)
        {   

            if(session != null && session.getAttribute("Username") != null ) //Verifichiamo se il prodotto si trova in wishList, cosi la view agisce di conseguenza. Questo ovviamente solo se l'utente è autenticato, altrimenti nulla.
            {   
                Integer WishListID = Utils.tryParseInt(request.getParameter("IDWishList"), 0);
                if(wishListModel.CheckIfProductIsInWishList(WishListID, product.getID()))
                    product.setIsInWishList(true);
            }   

            //recuperiamo i feedback relativi al prodotto
            LinkedList<Feedback> feedbacks = ProductModel.doRetrieveProductFeedback(product.getID());

            //Recuperiamo una lista dei tre prodotti più venduti:
            LinkedList<ProductBean> otherProducts = ProductModel.doRetrieveAll(null);
            Utils.getCasualProducts(otherProducts, 3);


            request.setAttribute("product", product);
            request.setAttribute("Feedbacks", feedbacks);
            request.setAttribute("otherProducts", otherProducts);
            dispatcher = this.getServletContext().getRequestDispatcher("/View/ProductDetails.jsp");
            dispatcher.forward(request, response);
        }
        else 
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // genera 404
    }

    private void handleGetAccessoriesPageRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException, ServletException
    {   
        String[] category = new String[1];
        category[0] = "Accessori";
        LinkedList<ProductBean> accessories = ProductModel.doRetrieveByFilter(category, 0, 100, null, null, false);
        RequestDispatcher dispatcher = null;

        if(session != null && session.getAttribute("Username") != null )
            checkProductsInWishList(accessories, session);

        request.setAttribute("accessories", accessories);
        dispatcher = this.getServletContext().getRequestDispatcher("/View/Accessories.jsp");
        dispatcher.forward(request, response);
    }


    //HANDLE ACTION FUNCTIONS


    private void handleFilterApplicationAction(HttpServletRequest request , HttpServletResponse response, HttpSession session) throws SQLException,IOException,ServletException
    {
        String[] category = request.getParameterValues("category");
        String[] models = request.getParameterValues("model");
        String[] color = request.getParameterValues("color");
        Integer p_min = Utils.tryParseInt(request.getParameter("p_min"), 0);                            
        Integer p_max = Utils.tryParseInt(request.getParameter("p_max"), 100);
        boolean customizable = Boolean.parseBoolean(request.getParameter("Customizable"));


        LinkedList<ProductBean> productsFiltered = ProductModel.doRetrieveByFilter(category,p_min,p_max,color,models, customizable);

        if(session != null && session.getAttribute("Username") != null) //Se l'utente è autenticato, verifichiamo quali sono i prodotti in wishlist , in modo da visualizzare la grafica correttamente
            checkProductsInWishList(productsFiltered, session);

        if( productsFiltered != null && productsFiltered.size() > 0) //Se ci sono prodotti, li restituiamo
        {
            Utils.sendJsonResponse(response, true, productsFiltered);
        }
        else
            Utils.sendJsonResponse(response, "{\"message\":\"no_products\"}");

    }

    private void handleAdptiveSearchAction(HttpServletRequest request, HttpServletResponse response) throws SQLException,IOException,ServletException
    {
        String name = request.getParameter("name");
        if(name != null && name.length() > 0)
        {   
            LinkedList<ProductBean> productsFiltered = ProductModel.doRetrieveByNamePrefix(name);

            if(productsFiltered.size() > 0 && productsFiltered != null)
                Utils.sendJsonResponse(response, true, productsFiltered);
            else
                Utils.sendJsonResponse(response, false, null);
        }
        else 
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }


    private void handleAddFeedbackAction(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        if(session.getAttribute("Username") != null)
        {
            if(Utils.checkParameters(request, "text", "vote","IDProdotto"))
            {
                String username = (String) session.getAttribute("Username");
                String text = request.getParameter("text");
                Integer vote = Utils.tryParseInt(request.getParameter("vote"),0);
                Integer IDProdotto = Utils.tryParseInt(request.getParameter("IDProdotto"), 0);
            
                if(ProductModel.checkIfUserAlreadyReviewed(IDProdotto, username))
                {
                    Utils.sendJsonResponse(response, false, null, "Hai già lasciato una recensione per questo prodotto!");
                }
                else
                {
                    if(IDProdotto != 0 && vote != 0)
                    {
                        Feedback feedback = new Feedback();
                        Date reviewDate = new Date(System.currentTimeMillis());
                        feedback.setIDProdotto(IDProdotto);
                        feedback.setText(text);
                        feedback.setVote(vote);
                        feedback.setUsername(username);
                        feedback.setReviewDate(reviewDate);
                        if(ProductModel.addFeedbackToProduct(feedback))
                        {
                            Utils.sendJsonResponse(response, true, feedback);
                        }
                        else
                        {
                            Utils.sendJsonResponse(response, false, null, "Errore nell'aggiunta del feedback");
                        }
                    }
                    else
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }
            }
            else 
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);

        }
        else
        {
            Utils.sendJsonResponse(response, false, null, "Autenticati per lasciare una recensione!");
        }
    }

    private void handleSelectProductDataAction(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        if(Utils.checkParameters(request, "IDProdotto", "Color"))
        {
            Integer IDProdotto = Utils.tryParseInt(request.getParameter("IDProdotto"), 0);
            String color = request.getParameter("Color");

            if(IDProdotto != 0)
            {   
                //Recuperiamo i modelli associati al colore
                LinkedList<Variation> variations = ProductModel.doRetrieveVariationsOfProduct(IDProdotto);
                LinkedList<String> AvaibleModels = new LinkedList<String>();

                for(Variation v : variations)
                {           
                    if(v.getColor().equals(color))
                    {   
                        AvaibleModels.add(v.getModel());
                    }
                }

                //Recuperiamo l'immagine associata al colore:
                LinkedList<String> images = ProductModel.doRetrieveImagePathsOfProducts(IDProdotto);
                String imgPath = null;

                for(String img : images)
                {
                    if(img.toLowerCase().contains(color.toLowerCase()))
                    {
                        imgPath = img;
                        break;
                    }
                }

                //Recuperiamo anche i dati del prodotto su cui è stata effettuata la richiesta di selezione del colore (utile per carrello modale)
                ProductBean product = ProductModel.doRetrieveByKey(IDProdotto);

                HashMap<String,Object> jsonResponseData = new HashMap<>();
                jsonResponseData.put("models", AvaibleModels);
                jsonResponseData.put("image", imgPath);
                jsonResponseData.put("product", product);




                Utils.sendJsonResponse(response, true, jsonResponseData);
            }
            else 
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);

        }
        else
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }





    //utilities function
    private void checkProductsInWishList(LinkedList<ProductBean> products, HttpSession session) throws SQLException
    {           
            if(products == null || products.size() == 0)    
                 return;

            Integer IDWishList = (Integer) session.getAttribute("IDWishList");
            for(ProductBean p : products)
            {
                if(wishListModel.CheckIfProductIsInWishList(IDWishList, p.getID()))
                    p.setIsInWishList(true);
                else 
                    p.setIsInWishList(false);
            }
    }

}
