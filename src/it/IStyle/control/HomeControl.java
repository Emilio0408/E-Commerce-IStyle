package it.IStyle.control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.dao.ProductModel;
import it.IStyle.utils.Utils;

public class HomeControl extends HttpServlet 
{
    
    private static ProductModel model;

    static
    {
        model = new ProductModel();
    }

    public HomeControl(){}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {

        RequestDispatcher dispatcher = null;

        try
        {   
            LinkedList<ProductBean> allProducts = (LinkedList<ProductBean>) model.doRetrieveAll(null);
            LinkedList<ProductBean> otherProducts = Utils.getCasualProducts(allProducts, 3);


            request.removeAttribute("bestProducts");
            request.setAttribute("bestProducts", model.doRetrieveBestProducts(5));
            request.removeAttribute("otherProducts");
            request.setAttribute("otherProducts", otherProducts);
            dispatcher = this.getServletContext().getRequestDispatcher("/index.jsp");
            dispatcher.forward(request, response);
        }
        catch(SQLException e)
        {
            System.out.println("Error: " + e.getMessage());
        }

    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        doGet(request, response);
    }




}
