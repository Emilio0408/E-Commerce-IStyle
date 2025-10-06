package it.IStyle.model.bean;

import java.util.LinkedList;

public class WishList 
{
    private int IDList;
    private LinkedList<ProductBean> products;


    public WishList()
    {}


    //Getter
    public int getIDList()
    {
        return this.IDList;
    }
   
    public LinkedList<ProductBean> getProductsInFavoriteList() 
    {
        return this.products;
    }

    public int getNumberOfProducts()
    {
        return this.products.size();
    }


    //Setter

    public void setIDList(int ID) 
    {
        this.IDList = ID;
    }

    public void setProductsInWishList(LinkedList<ProductBean> lp)
    {
        this.products = lp;
    }

    
}
