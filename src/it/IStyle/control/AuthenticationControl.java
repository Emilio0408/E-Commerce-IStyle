/*
 * Viene richiamata dalla pagina "index.jsp" quando viene fatta una richiesta di login o di registrazione dal form presente nella pagina.
 * 
 * 
 */
package it.IStyle.control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import it.IStyle.model.bean.User;
import it.IStyle.model.dao.UserModel;
import it.IStyle.model.dao.WishListModel;
import it.IStyle.utils.Utils;

/*
 * RICORDARE CHE I REDIRECT VANNO GESTITI LATO AJAX, QUINDI QUA SI INVIA UNA RISPOSTA CON L'URL IN CUI REINDIRIZZARE L'UTENTE NEL CASO IN CUI
 * SI LOGGA CORRETTAMENTE 
 */


public class AuthenticationControl extends HttpServlet
{       

    private static UserModel UserModel;
    private static WishListModel WishListModel;

    static
    {
        UserModel = new UserModel();
        WishListModel = new WishListModel();
    }

    public AuthenticationControl(){}



    private void handleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        String email = request.getParameter("email");
        String Password = request.getParameter("Password");
        String RedirectURL = (String) session.getAttribute("BackToURL");
        User user = null;

        user = UserModel.doRetrieveByEmail(email);

        if(user != null) //Se user != null l'utente è stato trovato.
        {   
                        //Username esistente
            if(Utils.checkPassword(Password, user.getPassword()))  //Verifichiamo se la password è corretta
            {
                //Username e password corretti: procediamo con l'autenticazione
                session.setAttribute("Username", user.getUsername());
                session.setAttribute("Name", user.getName());
                session.setAttribute("Surname", user.getSurname());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("IDWishList", user.getWishListID());
                session.setAttribute("role", user.getIfIsAdmin());
                if(RedirectURL != null)
                {
                    Utils.sendJsonResponse(response, true, RedirectURL, null);
                }
                else
                {
                    Utils.sendJsonResponse(response, true, request.getContextPath() + "/index.jsp", null);
                }
            }
            else
            {
                Utils.sendJsonResponse(response, false, null, "wrong password");
            }
        }
        else //utente non trovato, non esiste un utente con quell'email
        {
            Utils.sendJsonResponse(response, false, null, "email does not exists");
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws SQLException, IOException
    {
        //recupero dei dati
        String Username = request.getParameter("Username");
        String Name = request.getParameter("Name");
        String Surname = request.getParameter("Surname");
        String Password = Utils.hashPassword( (String)request.getParameter("Password"));
        Boolean NewsLetterSubscription = Boolean.parseBoolean(request.getParameter("NewsLetterSubscription"));
        String email = request.getParameter("email");

                    
        User user = new User();
        user.setUsername(Username);
        user.setName(Name);
        user.setSurname(Surname);
        user.setPassword(Password);
        user.setNewsLetterSubscription(NewsLetterSubscription);
        user.setEmail(email);   

        if(! ( UserModel.checkIfUsernameExists(Username)) ) //Verifichiamo se l'username inserito è già esistente
        {
            if( !( UserModel.checkIfEmailExists(email)) ) //Se l'email e l'username non esisteno già allora registriamo l'utente
            {
                //Creazione della wishlist associata all'utente appena registrato
                int IDNewList = AuthenticationControl.WishListModel.doSave();
                user.setWishListID(IDNewList);

                //Inseriamo l'utente nel DB ed inviamo la risposta
                if(UserModel.doSave(user))
                {   
                    Utils.sendJsonResponse(response, true, null, null);
                }
                else
                {
                    Utils.sendJsonResponse(response, false, null, "server error");
                }
            }  
            else 
            {   
                Utils.sendJsonResponse(response, false, null, "email already exists");
            }                    
        }
        else
        {
            Utils.sendJsonResponse(response, false, null, "username already exists");
        }
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {   
        RequestDispatcher dispatcher = null;
        HttpSession session = request.getSession();

        String referer = request.getHeader("Referer");

        if(referer != null)
            session.setAttribute("BackToURL", referer);
        
        if(session.getAttribute("Username") == null) //Se l'utente non è già autenticato allora possiamo indirizzarlo alla pagina di autenticazione
        {
            dispatcher = this.getServletContext().getRequestDispatcher("/View/Authentication.jsp");
            dispatcher.forward(request, response);
        }
        else
        {
            response.sendRedirect(referer);
        }

    }



    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        try
        {
            if(action != null)
            {
                if(action.equals("login"))
                {   
                    handleLogin(request, response, session);
                }
                else if(action.equals("register"))
                {   
                    handleRegister(request, response, session);
                }
            }
            else
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter"); //Error 400
        }
        catch(SQLException e)   
        {
            System.out.println("Error: " + e.getMessage());
            Utils.sendJsonResponse(response, false, null, "server error");
        }
    }
}
