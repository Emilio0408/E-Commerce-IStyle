package it.IStyle.model.bean;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;



public class Cart 
{
    private LinkedList<ProductBean> ProductsList;
    private BigDecimal totale;


    public Cart()
    {
        this.ProductsList = new LinkedList<ProductBean>();
        this.totale = BigDecimal.ZERO;
    }

    public void addCart(ProductBean product)
    {
        this.ProductsList.add(product);
    }

    public void deleteProduct(ProductBean product)
    {   
        this.ProductsList.remove(product);
    }

    public ProductBean getProduct(int ID,String Colore, String modello)
    {   
        ProductBean product = null;
        for(ProductBean p : this.ProductsList)
        {
            if(p.getID() == ID && p.getColor().equals(Colore) && p.getModel().equals(modello))
                product = p;
        }

        return product;
    }

    public boolean contains(int ID, String colore, String modello)
    {
        boolean result = false;
        for(ProductBean p : this.ProductsList)
        {
            if(p.getID() == ID)
            {   
                if(p.getColor().equals(colore))
                {
                    if(p.getModel().equals(modello))
                    {
                        result = true;
                        break;
                    }
                }
            }
        }

        return result;
    }

    public double getTotal()
    {
        this.totale = BigDecimal.ZERO;
        for(ProductBean p : this.ProductsList)
        {
            BigDecimal price = p.getPriceAsBigDecimal();
            int quantityInCart = p.getQuantityInCart();
            totale = totale.add(price.multiply(BigDecimal.valueOf(quantityInCart)));
        }
        
        return totale.setScale(2, RoundingMode.HALF_UP).doubleValue();
    }

    public int getQuantityOfProducts() 
    {
        int quantityOfProducts = 0;

        for(ProductBean p : this.ProductsList)
        {
            quantityOfProducts += p.getQuantityInCart();
        }

        return quantityOfProducts;
    }

    public LinkedList<ProductBean> getProducts()
    {
        return this.ProductsList;

    }
}
