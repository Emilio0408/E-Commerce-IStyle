/*
 * Viene richiamata dall'Admin page e contiene tutta la logica per gestirla (visualizzazione del catalogo, inserimento di un prodotto e visualizzazione dei dettagli di un prodotto)
 * 
 */

package it.IStyle.control;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.dao.ProductModel;

public class MGPageControl extends HttpServlet {

    private static final long serialVersionUID = 1L;

    static ProductModel model;

    static {
        model = new ProductModel();
    }

    public MGPageControl() {}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action != null) {

                if (action.equalsIgnoreCase("read")) {

                    int id = Integer.parseInt(request.getParameter("id"));

                    request.removeAttribute("product");

                    request.setAttribute("product", model.doRetrieveByKey(id));

                    request.removeAttribute("scrollToDetails");

                    request.setAttribute("scrollToDetails", true);
                } 
                else if (action.equalsIgnoreCase("delete")) {

                    int id = Integer.parseInt(request.getParameter("id"));

                    model.doDelete(id);

                } 
                else if (action.equalsIgnoreCase("insert")) {

                    String name = request.getParameter("name");

                    String description = request.getParameter("description");

                    BigDecimal price = new BigDecimal(request.getParameter("price"));
                    String category = request.getParameter("category");

                    ProductBean bean = new ProductBean();

                    bean.setName(name);

                    bean.setDescription(description);

                    bean.setPrice(price);


                    bean.setCategory(category);

                    model.doSave(bean);
                }
            }
        } catch (SQLException e) {

            System.out.println("Error:" + e.getMessage());

        }

        String sort = request.getParameter("sort");

        try {

            request.removeAttribute("products");

            request.setAttribute("products", model.doRetrieveAll(sort));

        } catch (SQLException e) {

            System.out.println("Error:" + e.getMessage());

        }

        RequestDispatcher dispatcher = this.getServletContext().getRequestDispatcher("/WEB-INF/View/AdminPage.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        this.doGet(request, response);

    }
}
