package it.IStyle.control;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class AdminControl extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        
        // Ottieni il parametro di sezione (section)
        String section = request.getParameter("section");
        
        if (section == null || section.isEmpty()) {
            section = "dashboard"; // Default alla dashboard
        }
        
        String targetPage = null;
        
        // Routing verso le diverse sezioni admin
        switch (section.toLowerCase()) {
            case "dashboard":
                targetPage = "/View/admin-dashboard.jsp";
                break;
                
            case "products":
            case "prodotti":
                targetPage = "/View/admin-prodotti.jsp";
                break;
                
            case "orders":
            case "ordini":
                targetPage = "/View/admin-ordini.jsp";
                break;
                
            default:
                // Sezione non riconosciuta, reindirizza alla dashboard
                response.sendRedirect(request.getContextPath() + "/admin?section=dashboard");
                return;
        }
        
        // Aggiungi attributi utili per le pagine JSP
        request.setAttribute("currentSection", section);
        request.setAttribute("contextPath", request.getContextPath());
        
        // Forward alla pagina corrispondente
        RequestDispatcher dispatcher = request.getRequestDispatcher(targetPage);
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Per ora, redirige tutte le POST alle GET
        doGet(request, response);
    }
}