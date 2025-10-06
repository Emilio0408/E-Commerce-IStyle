package it.IStyle.filters;

import java.io.IOException;
import java.util.Map;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// RoutingFilter.java
public class RedirectFilter implements Filter {
    
private static final Map<String, String> JSP_TO_SERVLET_MAPPING = Map.ofEntries(
    Map.entry("/index.jsp", "/home"),
    Map.entry("/View/NewProducts.jsp", "/product/news"),
    Map.entry("/View/Authentication.jsp", "/authentication"),
    Map.entry("/View/Product.jsp", "/product"),
    Map.entry("/View/ProductDetails.jsp", "/product"),
    Map.entry("/View/CustomizableProducts.jsp", "/product/customizable"),
    Map.entry("/View/Orders.jsp", "/user/orders"),
    Map.entry("/View/Cart.jsp", "/cart"),
    Map.entry("/View/Checkout.jsp", "/checkout"),
    Map.entry("/View/OrderSummary.jsp", "/checkout/confirm"),
    Map.entry("/View/UserInformation.jsp", "/user/information"),
    Map.entry("/View/UserPage.jsp", "/user"),
    Map.entry("/View/WishList.jsp", "/user/wishlist"),
    Map.entry("/View/Accessories.jsp", "/product/accessories")
);

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        String jspPath = request.getServletPath();

        if (JSP_TO_SERVLET_MAPPING.containsKey(jspPath)) {
            String targetServlet = JSP_TO_SERVLET_MAPPING.get(jspPath);
            ((HttpServletResponse) res).sendRedirect(request.getContextPath() + targetServlet);
            return;
        }
        
        chain.doFilter(req, res); // Se non è una JSP protetta, continua
    }
}
