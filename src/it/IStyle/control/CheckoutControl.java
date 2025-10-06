package it.IStyle.control;

import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;
import it.IStyle.model.bean.Address;
import it.IStyle.model.bean.Cart;
import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.dao.UserModel;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedList;

public class CheckoutControl extends HttpServlet {

    private static UserModel userModel;

    static {
        userModel = new UserModel();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        Cart cart = (Cart) session.getAttribute("cart");
        RequestDispatcher dispatcher = null;

        // Gestiamo il caso in cui si prova ad accedere alla pagina di checkout senza
        // avere prodotti nel carrello
        if (cart == null || cart.getProducts().size() == 0) {
            session.setAttribute("flashAlert",
                    "Per procedere al checkout devi prima inserire almeno un prodotto nel carrello");
            response.sendRedirect(request.getContextPath() + "/product");
            return;
        }

        try {
            // Recuperiamo gli indirizzi dell'utente in modo da poterli poi visualizzare.

            String username = (String) session.getAttribute("Username");
            LinkedList<Address> addresses = userModel.doRetrieveUserAddresses(username);
            request.setAttribute("userAddresses", addresses);

            dispatcher = this.getServletContext().getRequestDispatcher("/View/Checkout.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Chiave segreta di STRIPE
        Stripe.apiKey = "";

        HttpSession session = request.getSession(false);
        session.setAttribute("shippingMethod", request.getParameter("shippingMethod"));
        session.setAttribute("shippingAddress", request.getParameter("shippingAddress"));

        Cart cart = (Cart) session.getAttribute("cart");

        LinkedList<ProductBean> productsInCart = (LinkedList<ProductBean>) cart.getProducts();
        LinkedList<SessionCreateParams.LineItem> lineItems = new LinkedList<SessionCreateParams.LineItem>();

        for (ProductBean p : productsInCart) {
            SessionCreateParams.LineItem lineItem = SessionCreateParams.LineItem.builder()
                    .setQuantity((long) p.getQuantityInCart())
                    .setPriceData(
                            SessionCreateParams.LineItem.PriceData.builder()
                                    .setCurrency("eur")
                                    .setUnitAmount((long) (p.getPrice() * 100))
                                    .setProductData(
                                            SessionCreateParams.LineItem.PriceData.ProductData.builder()
                                                    .setName(p.getName())
                                                    .build())
                                    .build())
                    .build();

            lineItems.add(lineItem);
        }

        SessionCreateParams params = SessionCreateParams.builder()
                .setMode(SessionCreateParams.Mode.PAYMENT)
                .setSuccessUrl("http://localhost:8080/IStyle/checkout/confirm?session_id={CHECKOUT_SESSION_ID}") // Se
                                                                                                                 // il
                                                                                                                 // pagamento
                                                                                                                 // va a
                                                                                                                 // buon
                                                                                                                 // fine
                                                                                                                 // reindirizziamo
                                                                                                                 // verso
                                                                                                                 // la
                                                                                                                 // Servlet
                                                                                                                 // che
                                                                                                                 // si
                                                                                                                 // occupa
                                                                                                                 // di
                                                                                                                 // gestire
                                                                                                                 // le
                                                                                                                 // operazioni
                                                                                                                 // post
                                                                                                                 // pagamento
                .setCancelUrl("http://localhost:8080/IStyle/checkout")
                .addAllLineItem(lineItems)
                .build();

        try {
            Session PaymentSession = Session.create(params);
            response.sendRedirect(PaymentSession.getUrl());
        } catch (StripeException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

}
