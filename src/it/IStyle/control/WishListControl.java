package it.IStyle.control;


import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import it.IStyle.model.dao.WishListModel;
import it.IStyle.utils.Utils;
import it.IStyle.model.bean.ProductBean;


public class WishListControl extends HttpServlet
{
    private static WishListModel model;

    static
    {
        model = new WishListModel();
    }

    public WishListControl(){}


    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {       
        RequestDispatcher dispatcher = null;
        HttpSession session = request.getSession(false);
        Integer IDWishList = (Integer) session.getAttribute("IDWishList");
        try
        {
            LinkedList<ProductBean> productsInWishList = model.doRetrieveProductsInWishList(IDWishList);
            if(productsInWishList != null)
                request.setAttribute("productsInWishList", productsInWishList);

            dispatcher = this.getServletContext().getRequestDispatcher("/View/WishList.jsp");
            dispatcher.forward(request, response);
        }
        catch(SQLException e)
        {
            System.out.println("Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

    }
    
    
    @Override
    public void doPost(HttpServletRequest request , HttpServletResponse response) throws ServletException, IOException
    {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        
        if(action == null) //Richiesta POST alla servlet eseguita male
        {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter"); //Genera errore 400
            return;
        }

        try
        {   
            if(action.equals("add"))
            {
                handleAddProductToWishList(request, response, session);
            }
            else if(action.equals("remove"))
            {
                handleRemoveProductFromWishList(request, response, session);
            }
            else if(action.equals("clear"))
            {
                handleClearWishListOperation(request, response, session);
            }
        }
        catch(SQLException e)
        {
            System.out.println("Error: " + e.getMessage());
        }

    }

    private void handleAddProductToWishList(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        Integer IDProduct = Integer.parseInt(request.getParameter("IDProduct"));
        Integer WishListID = (Integer) session.getAttribute("IDWishList");


        if(IDProduct != null && WishListID != null)
        {
            if(model.doAddProductInWishList(WishListID, IDProduct)) //Se l'operazione di inserimento va a buon fine
                Utils.sendJsonResponse(response,true,null,null); //Diciamo all'utente che l'operazione è andata a buon fine.
            else
                Utils.sendJsonResponse(response,false,null,null);
        }
    }

    private void handleRemoveProductFromWishList(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        Integer IDProduct = Integer.parseInt(request.getParameter("IDProduct"));
        Integer WishListID = (Integer) session.getAttribute("IDWishList");



        if(IDProduct != null && WishListID != null)
        {
            if(model.doRemoveProductInWishList(WishListID, IDProduct)) //Se l'operazione di rimozione va a buon fine
            {   

                Utils.sendJsonResponse(response,true,model.doRetrieveProductsInWishList(WishListID).size());
            }
            else
                Utils.sendJsonResponse(response,false,null,null);
        }
        else
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
    
    
    private void handleClearWishListOperation(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        Integer WishListID = (Integer) session.getAttribute("IDWishList");

        if(WishListID != null)
        {
            if( model.doDeleteAllProductsFromWishList(WishListID) > 0 )
                Utils.sendJsonResponse(response,true,null,null);
            else 
                Utils.sendJsonResponse(response,false,null,null);
        }
    }


        


}
