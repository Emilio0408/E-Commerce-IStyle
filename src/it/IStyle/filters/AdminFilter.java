package it.IStyle.filters;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Filtro per proteggere le risorse accessibili solo agli amministratori.
 * Verifica che l'utente sia autenticato e abbia il ruolo di admin.
 */
public class AdminFilter implements Filter {
    
    private Gson gson;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        gson = new Gson();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Verifica se l'utente è autenticato
        boolean isAuthenticated = session != null && session.getAttribute("Username") != null;
        
        // Verifica se l'utente è admin
        boolean isAdmin = false;
        if (isAuthenticated) {
            Boolean role = (Boolean) session.getAttribute("role");
            isAdmin = role != null && role.booleanValue();
        }

        System.out.println(isAdmin + " " + isAuthenticated);
        
        if (!isAuthenticated || !isAdmin) {
            // Determina se è una richiesta AJAX
            boolean isAjax = "XMLHttpRequest".equals(httpRequest.getHeader("X-Requested-With"));
            
            if (isAjax) {
                // Per richieste AJAX, restituisce errore 403 con JSON
                httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                httpResponse.setContentType("application/json");
                httpResponse.setCharacterEncoding("UTF-8");
                
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("error", isAuthenticated ? "Accesso negato. Privilegi amministrativi richiesti." : "Sessione scaduta. Effettua il login.");
                errorResponse.addProperty("requiresAuth", !isAuthenticated);
                errorResponse.addProperty("requiresAdmin", isAuthenticated && !isAdmin);
                
                PrintWriter out = httpResponse.getWriter();
                out.print(gson.toJson(errorResponse));
                out.flush();
            } else {
                // Per richieste normali, reindirizza
                if (!isAuthenticated) {
                    // Se non autenticato, reindirizza al login
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/authentication");
                } else {
                    // Se autenticato ma non admin, reindirizza alla home con messaggio di errore
                    session.setAttribute("errorMessage", "Accesso negato. Privilegi amministrativi richiesti.");
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
                }
            }
            return;
        }
        
        // L'utente è admin, continua con la richiesta
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup se necessario
    }
}