package it.IStyle.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import it.IStyle.utils.Utils;

public class AuthFilter implements Filter
{   

    /*
     * Questo filtro protegge tutte le pagine accessibili ai soli utenti loggati al sito
     * A tali pagine possono essere effettuate richieste tramite URL (o alla servlet o direttamente alla jsp) oppure possono essere effettuate richieste AJAX
     * Nel caso di richieste avvenute tramite URL è necessario utilizzare un redirect (codice di risposta: 302)
     * Nel caso di richiesta avvenute tramite AJAX è necessario inviare una risposta con errore 401 unauthorized
     * Quindi il filtro dovrà distinguere questi due tipi di richiesta.
     * 
     * 
     */

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException 
    {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); //Mettendo false , se la sessione non è già esistente non viene creata

        if(session != null && session.getAttribute("Username") != null)
            chain.doFilter(req, res); //Se l'utente è autenticato allora lo facciamo passare al prossimo filtro o alla servlet/pagina da raggiungere
        else
        {       

            //Se l'utente non è autenticato

            String requestedWith = req.getHeader("X-Requested-With");

            if(requestedWith != null) //SI tratta di una richiesta ajax
            {
                res.setStatus(HttpServletResponse.SC_UNAUTHORIZED); //Error 401
                Utils.sendJsonResponse(res, false, null, "Autenticati per aggiungere i prodotti alla wishlist");
            }
            else //Non si tratta di una richiesta ajax
            {
                res.sendRedirect(req.getContextPath() + "/authentication"); 
            }

        }
     
    }

    
}
