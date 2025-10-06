package it.IStyle.control;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import it.IStyle.model.bean.Address;
import it.IStyle.model.bean.User;
import it.IStyle.model.dao.AddressModel;
import it.IStyle.model.dao.UserModel;
import it.IStyle.utils.Utils;




public class UserPageControl extends HttpServlet
{   
    private static UserModel model;
    private static AddressModel addressModel;

    static
    {
        model = new UserModel();
        addressModel = new AddressModel();
    }

    
    @Override
    public void doGet(HttpServletRequest request , HttpServletResponse response) throws ServletException, IOException
    {   

        //gestiamo il caso in cui viene richiesto il logout
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        if(action != null && action.equals("logout"))
        {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }


        //Gestiamo i casi di richieste GET delle pagine.
        String pathInfo = request.getServletPath();
        if(pathInfo != null)
            pathInfo = pathInfo.substring(1);
        RequestDispatcher dispatcher = null;



        if(pathInfo != null && pathInfo.contains("information")) //Caso in cui viene richiesta la pagina relativa alle informazioni dell'utente.
        {   
            User user = null;
            try
            {
                user = model.doRetrieveByKey(((String)session.getAttribute("Username")));
            }
            catch(SQLException e)
            {
                e.printStackTrace();
            }
            request.setAttribute("UserInformation", user);
            dispatcher = this.getServletContext().getRequestDispatcher("/View/UserInformation.jsp");
            dispatcher.forward(request, response);
        }
        else 
        {  
            dispatcher = this.getServletContext().getRequestDispatcher("/View/UserPage.jsp");
            dispatcher.forward(request, response);
        }
    }


    @Override 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if(action == null)
        {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter"); //Genera errore 400
            return;
        }

        try
        {
            if(action.equals("UpdateName"))
            {       
                handleUpdateName(request, response, session);
            }
            else if(action.equals("UpdateSurname"))
            {
                handleUpdateSurname(request, response, session);
            }
            else if(action.equals("UpdatePassword"))
            {
                handleUpdatePassword(request, response, session);
            }
            else if(action.equals("UpdateEmail"))
            {
                handleUpdateEmail(request, response, session);
            }
            else if(action.equals("AddAddress"))
            {
                handleAddingAddress(request, response, session);
            }
            else if(action.equals("RemoveAddress"))
            {   
                handleAddressRemoval(request, response, session);
            }
            else
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid value for action parameter");
            
        }
        catch(SQLException e)
        {
            System.out.println("Error: " + e.getMessage());
        }

    }



    private void handleUpdateName(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        String newName = request.getParameter("newName");
        String Username = (String) session.getAttribute("Username");

        if(newName != null)
        {
            if(model.DoUpdateName(newName, Username))
                Utils.sendJsonResponse(response,true,null,null); //Diciamo all'utente che l'operazione è andata a buon fine.
            else //Operazione andata male
                Utils.sendJsonResponse(response, false, null,null); //Rispondiamo all'utente dicendogli che l'operazione non è andata a buon fine
        }
        else 
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameter"); //Genera errore 400
    }

    private void handleUpdateSurname(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        String newSurname = request.getParameter("newSurname");
        String Username = (String) session.getAttribute("Username");

        if(newSurname != null)
        {
            if(model.DoUpdateSurname(newSurname,Username))
                Utils.sendJsonResponse(response,true,null,null);
            else 
                Utils.sendJsonResponse(response,false, null,null);
        }
        else 
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameter"); //Genera errore 400     
    }

    private void handleUpdatePassword(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        String newPassword = request.getParameter("newPassword");
        String Username = (String) session.getAttribute("Username");


        if(newPassword != null)
        {
            newPassword = Utils.hashPassword(newPassword);
            if(model.DoUpdatePassword(newPassword, Username))
                Utils.sendJsonResponse(response, true,null,null);
            else 
                Utils.sendJsonResponse(response, false,null,null);
        }
        else
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameter"); //Genera errore 400 
    }

    private void handleUpdateEmail(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        String newEmail = request.getParameter("newEmail");
        String Username = (String) session.getAttribute("Username");

        if(newEmail != null)
        {
            if(model.DoUpdateEmail(newEmail, Username))
                Utils.sendJsonResponse(response, true,null,null);
            else
                Utils.sendJsonResponse(response, false, null,null);
        }
        else 
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameter"); //Genera errore 400s        
    }
    
    private void handleAddingAddress(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {   

        String Username = (String) session.getAttribute("Username");

        if(Utils.checkParameters(request, "CAP", "Via", "Nazione", "NCivico", "Tipologia","Citta"))
        {
            String CAP = request.getParameter("CAP");
            String Via = request.getParameter("Via");
            String Nazione = request.getParameter("Nazione");
            String NumeroCivico = request.getParameter("NCivico");
            String Tipologia = request.getParameter("Tipologia");
            String citta = request.getParameter("Citta");
            int IDAddedAddress = 0;

            Address address = new Address();
            address.setCAP(CAP);
            address.setVia(Via);
            address.setNazione(Nazione);
            address.setNumeroCivico(NumeroCivico);
            address.setTipologia(Tipologia);
            address.setCitta(citta);

            IDAddedAddress = (int) addressModel.doSave(address);


            if(IDAddedAddress != 0)
            {
                if(model.doAddAddress(Username,IDAddedAddress))
                {
                    Utils.sendJsonResponse(response, true,((Integer)IDAddedAddress));
                }
                else
                    Utils.sendJsonResponse(response, false,null,null);
            }
            else
                Utils.sendJsonResponse(response, false,null,null);
        }
        else
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameter");
    }


    private void handleAddressRemoval(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {   
        String Username = (String) session.getAttribute("Username");
        Integer IDIndirizzo = Utils.tryParseInt(request.getParameter("IDAddress"), 0);

        if(model.doRemoveAddress(Username , IDIndirizzo))
        { 
            if(addressModel.doDelete(IDIndirizzo))
                Utils.sendJsonResponse(response, true,null,null);
            else
                Utils.sendJsonResponse(response, false, null,null);
        }
        else
            Utils.sendJsonResponse(response, false,null,null);

    }






}
