package it.IStyle.control;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.LinkedList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionRetrieveParams;
import it.IStyle.model.bean.Cart;
import it.IStyle.model.bean.Order;
import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.dao.OrderModel;
import it.IStyle.model.dao.ProductModel;
import it.IStyle.utils.FatturaGenerator;
import it.IStyle.utils.StripeUtils;

public class ConfirmOrderControl extends HttpServlet {

    private static OrderModel orderModel;
    private static ProductModel productModel;
    private Session paymentSession;
    private String paymentSessionID;
    private String paymentIntentID;

    static {
        orderModel = new OrderModel();
        productModel = new ProductModel();
    }

    /*
     * Questa servlet deve essere eseguita solo con redirect da stripe con
     * SuccessURL.
     * Implementiamo quindi un controllo per capire se l'utente sta provando ad
     * accedere a questa servlet non dopo un pagamento, ma con una richiesta casuale
     * alla servlet o una
     * nuova richiesta allo stesso URL che non può essere validata (in quanto
     * l'ordine è già stato inserito nel DB).
     * 
     * 
     */

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        // Chiave segreta di STRIPE
        Stripe.apiKey = "";

        try {
            this.paymentSessionID = request.getParameter("session_id");

            if (paymentSessionID != null) {
                SessionRetrieveParams retrieveParams = SessionRetrieveParams.builder()
                        .addExpand("payment_intent")
                        .build();

                // Recuperiamo la sessione stripe per il pagamento
                this.paymentSession = Session.retrieve(paymentSessionID, retrieveParams, null);
                // Recuperiamo le informazioni relative al pagamento
                this.paymentIntentID = paymentSession.getPaymentIntent();

                if (orderModel.doRetrieveByPaymentIntent(paymentIntentID) != null) {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                    return;
                }
            } else // Richiesta non valida
            {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            // Una volta superati i controlli, salviamo l'ordine e generiamo la fattura.
            // Recuperiamo anche l'ordine appena inserito in modo da poter inviare i dati
            // alla summary
            Order addedOrder = saveOrder(request, response, session, paymentSession);

            if (addedOrder != null) {
                // Settiamo l'attributo di richiesta coi dati dell'ordine e inviamoli alla
                // OrderSummary.jsp che la visualizzerà
                request.setAttribute("addedOrder", addedOrder);
                RequestDispatcher dispatcher = this.getServletContext().getRequestDispatcher("/View/OrderSummary.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (StripeException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            // Vuol dire che il salvataggio dell'ordine ha generato una qualche eccezione,
            // quindi andiamo ad effettuare il rimborso
            try {
                StripeUtils.refundPayment(this.paymentIntentID);
            } catch (StripeException e2) {
                e2.printStackTrace();
            }

            e.printStackTrace();
        }

    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doGet(request, response);
    }

    private Order saveOrder(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            Session paymentSession) throws SQLException, IOException, StripeException {
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        LinkedList<ProductBean> purchasedProduct = cart.getProducts();
        PaymentIntent pi = paymentSession.getPaymentIntentObject();

        // Recuperiamo i dati dell'ordine
        Date dataErogazione = new Date(System.currentTimeMillis());
        String metodoDiSpedizione = (String) session.getAttribute("shippingMethod");
        Date dataConsegna = Date.valueOf(getDeliveryDate(metodoDiSpedizione));
        String IndirizzoSpedizione = (String) session.getAttribute("shippingAddress");
        double ImportoTotale = cart.getTotal();
        String tipoPagamento = pi.getPaymentMethodTypes().get(0);

        // Settiamo i dati dell'ordine per salvarlo nel DB e generare la fattura
        Order order = new Order();
        order.setDataErogazione(dataErogazione);
        order.setDataConsegna(dataConsegna);
        order.setMetodoDiSpedizione(metodoDiSpedizione);
        order.setIndirizzoDiSpedizione(IndirizzoSpedizione);
        order.setImportoTotale(ImportoTotale);
        order.setTipoPagamento(tipoPagamento);
        order.setProductsInOrder(purchasedProduct);
        order.setDataEmissione(dataErogazione);
        order.setStato("In preparazione");
        order.setPaymentIntentID(this.paymentIntentID);

        // Recuperiamo i dati dell'utente per salvare l'ordine e generare la fattura
        String username = (String) session.getAttribute("Username");
        String Name = (String) session.getAttribute("Name");
        String Surname = (String) session.getAttribute("Surname");
        String email = (String) session.getAttribute("email");

        int IDOrder = 0;

        if ((IDOrder = orderModel.doSave(order, username)) != 0) // Nel caso in cui l'ordine sia salvato correttamente
        {
            // Decrementiamo la quantità disponibile dei vari prodotti acquistati
            for (ProductBean p : purchasedProduct) {
                int newQuantity = productModel.doRetrieveAvaibleQuantity(p) - p.getQuantityInCart();
                productModel.doUpdateProductQuantity(p, newQuantity);
            }

            session.removeAttribute("cart"); // Rimuoviamo i prodotti dal carrello
            session.removeAttribute("shippingMethod"); // Rimuoviamo attributo relativo al metodo di spedizione
            session.removeAttribute("shippingAddress"); // Rimuoviamo attributo relativo all'indirizzo di spedizione
            order.setIDOrdine(IDOrder);
            FatturaGenerator.generaFattura(order, Name, Surname, email, getServletContext().getRealPath("/")); // Generiamo
                                                                                                               // la
                                                                                                               // fattura
        } else {
            String paymentIntentId = paymentSession.getPaymentIntent();
            StripeUtils.refundPayment(paymentIntentId);
        }

        return order;
    }

    private LocalDate getDeliveryDate(String metodoDiSpedizione) {
        LocalDate ld = null;

        if (metodoDiSpedizione.equals("standard")) {
            ld = LocalDate.now().plusDays(5);
        } else if (metodoDiSpedizione.equals("express")) {
            ld = LocalDate.now().plusDays(2);
        }

        if (ld.getDayOfWeek() == DayOfWeek.SATURDAY)
            ld = ld.plusDays(2);
        else if (ld.getDayOfWeek() == DayOfWeek.SUNDAY)
            ld = ld.plusDays(1);

        return ld;
    }

}
