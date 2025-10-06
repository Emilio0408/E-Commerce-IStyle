/*
 * Viene richiamata dalla pagina index.jsp  quando viene premuto il bottone per l'aggiunta
 * di un prodotto.
 * 
 * 
 */


package it.IStyle.control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import it.IStyle.model.bean.Cart;
import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.dao.ProductModel;
import it.IStyle.utils.Utils;

public class CartControl extends HttpServlet
{
    private static ProductModel model;

    static
    {
        model = new ProductModel();
    }

    public CartControl(){}



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,IOException
    {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        Cart cart = (Cart) session.getAttribute("cart");
        RequestDispatcher dispatcher = null;

        if(cart == null)
        {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        // else
        // {
        //     LinkedList<ProductBean> productsInCart = cart.getProducts();
        //     for(ProductBean p : productsInCart)
        //     {
        //         System.out.println(p.getName() + "\n" + p.getModel() + "\n" + p.getColor() + "\n" + p.getQuantityInCart());
        //     }

        //     System.out.println("------------------------------------------------------------");
            
        // }


        try
        {   
            
            if(action == null)
            {
                dispatcher = this.getServletContext().getRequestDispatcher("/View/Cart.jsp");
                dispatcher.forward(request, response);
                return;
            }

            if(action.equals("add"))
            {       
                if(Utils.checkParameters(request, "id","color","model"))
                {
                    Integer idProduct = Integer.parseInt(request.getParameter("id"));
                    String colore = (String) request.getParameter("color");
                    String modello = (String) request.getParameter("model");

                    ProductBean product = null;
                    
                    if(cart.contains(idProduct,colore,modello))
                    {   
                        product = cart.getProduct(idProduct,colore,modello);
                        product.setQuantityInCart(product.getQuantityInCart() + 1);
                    }
                    else 
                    {
                        product = model.doRetrieveByKey(idProduct);
                        if(product != null)
                        {
                            product.setQuantityInCart(1);
                            product.setColor(colore);
                            product.setModel(modello);
                            cart.addCart(product);
                        }
                        else
                            response.sendError(HttpServletResponse.SC_NOT_FOUND); // genera 404
                    }
                    /*Nella risposta invio i dati relativi al prodotto aggiunto che serviranno per visualizzare la sidebar ogni qualvolta viene aggiunto un prodotto
                    * i dati relativi alla quantità di prodotti nel carrello sono dati di sessione , quindi saranno direttamente disponibili senza bisogno di restituirli
                    */
                    Map<String,Object> responseData = new HashMap<>();
                    responseData.put("cartTotal", cart.getTotal());
                    responseData.put("quantityOfProductInCart", cart.getQuantityOfProducts());
                    Utils.sendJsonResponse(response, true, responseData);
                }
                else
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
            else if(action.equals("remove"))
            {   
                boolean delete = false;

                if(Utils.checkParameters(request, "id", "color","model"))
                {
                    Integer idProduct = Integer.parseInt(request.getParameter("id"));
                    String color = request.getParameter("color");
                    String model = request.getParameter("model");
                    boolean totalRemove = Boolean.parseBoolean(request.getParameter("totalRemove"));

                    ProductBean product = cart.getProduct(idProduct,color,model);
                    product.setQuantityInCart(product.getQuantityInCart() - 1);


                    if(product.getQuantityInCart() == 0 || totalRemove)
                    {
                        cart.deleteProduct(product);
                        delete = true;
                    }
                    
                    
                    Map<String,Object> responseData = new HashMap<>();
                    responseData.put("cartTotal", cart.getTotal());
                    responseData.put("quantityOfProductInCart", cart.getQuantityOfProducts());
                    responseData.put("delete", delete);
                    Utils.sendJsonResponse(response, true,responseData);
                }
                else
                {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }

            }
        }
        catch(SQLException e)
        {
            System.out.println("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,IOException
    {
        doGet(request, response);
    }


    
}

