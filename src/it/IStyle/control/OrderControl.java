package it.IStyle.control;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import it.IStyle.model.bean.Order;
import it.IStyle.model.dao.OrderModel;
import it.IStyle.utils.Utils;
import java.util.LinkedList;



public class OrderControl extends HttpServlet
{   

    private static OrderModel orderModel;

    static
    {
        orderModel = new OrderModel();
    }


    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {       

        HttpSession session = request.getSession(false);
        String pathInfo = request.getPathInfo();

        try 
        {   if(pathInfo != null && pathInfo.contains(".pdf"))
                handleGetInvoiceRequest(request,response,session, pathInfo);
            else
                handleGetOrdersPageRequest(request, response, session);
        }
        catch(SQLException e)
        {
            System.out.println("Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        doGet(request, response);
    }



    private void handleGetOrdersPageRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException, ServletException
    {
        String username = (String) session.getAttribute("Username");
        LinkedList<Order> orders = orderModel.doRetrieveUserOrders(username);
        request.setAttribute("ordersOfUser", orders);
        RequestDispatcher dispatcher = this.getServletContext().getRequestDispatcher("/View/Orders.jsp");
        dispatcher.forward(request, response);
    }


    private void handleGetInvoiceRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session, String pathInfo) throws SQLException, IOException, ServletException
    {   
        int start = pathInfo.indexOf('_') + 1;
        int end  = pathInfo.lastIndexOf('.');
        int IDOrder = Utils.tryParseInt(pathInfo.substring(start,end),0);
        String fileName = pathInfo.substring(1);
        String username = (String) session.getAttribute("Username");

        if(orderModel.hasUserPlacedOrder(username, IDOrder)) //Possiamo procedere a restituire la fattura in download
        {   
            String filePath = getServletContext().getRealPath("/pdf/fatture/" + fileName);
            File file = new File(filePath);

            if(!(file.exists())) //Se il file non esiste
            {
                response.sendError(HttpServletResponse.SC_NOT_FOUND); //inviamo un error 404
                return;
            }

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLengthLong(file.length());  

            FileInputStream in = new FileInputStream(file);
            OutputStream out = response.getOutputStream();

            byte[] buffer =  new byte[4096];
            int bytesRead;

            while((bytesRead = in.read(buffer)) != -1)
            {
                out.write(buffer,0,bytesRead);
            }

            in.close();

        }
        else 
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
    }






}
