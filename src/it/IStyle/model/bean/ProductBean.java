package it.IStyle.model.bean;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;

public class ProductBean implements Serializable 
{

    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private BigDecimal price;
    private String description;
    private String category;
    private boolean customizable;

    private HashMap<String,String> avaibleColors;
    private HashSet<String> avaibleModels;


    //Parametri usati per checkout e aggiunta al carrello del prodotto
    private String color;
    private String model;
    private LinkedList<String> ImagesPaths;
    private int quantityInCart;

    //Parametri di utility
    private boolean isInWishList;


    public ProductBean()
    {
        this.quantityInCart = 0;
        this.isInWishList = false;
    }


    //metodi get

    public String getCategory() { return category; }
    public int getID() { return id; }
    public String getName() { return name; }
    public double getPrice() { return this.price.doubleValue(); }
    public BigDecimal getPriceAsBigDecimal() { return this.price; } //Per i calcoli senza errori
    public String getDescription() { return description; }
    public LinkedList<String> getImagesPaths() { return this.ImagesPaths; }
    public int getQuantityInCart() { return this.quantityInCart; }
    public boolean getCustomizable(){return this.customizable;}
    public boolean isInWishList(){return this.isInWishList;}
    public HashMap<String,String> getAvaibleColors() {return this.avaibleColors;}
    public HashSet<String> getAvaibleModels() {return this.avaibleModels;}
    public String getColor() {return this.color;}
    public String getModel() {return this.model;}

    //metodi set

    public void setID(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setPrice(BigDecimal price) { this.price = price.setScale(2,RoundingMode.HALF_UP); }
    public void setDescription(String description) { this.description = description; }
    public void setCategory (String category) { this.category = category; }
    public void setImagesPaths(LinkedList<String> paths) {this.ImagesPaths = paths;}
    public void setQuantityInCart(int q) {this.quantityInCart = q;}
    public void setCustomizable(boolean value){this.customizable = value;}
    public void setIsInWishList(boolean value){this.isInWishList = value;}
    public void setAvaibleColors(HashMap<String,String> colors){this.avaibleColors = colors;}
    public void setAvaibleModels(HashSet<String> models){this.avaibleModels = models;}
    public void setColor(String c){this.color = c;}
    public void setModel(String m){this.model = m;}

    @Override
    public String toString() 
    {
        return "\nCodice di questo prodotto è: " + this.id
                + " \nNome: " + this.name
                + " \nPrezzo: " + this.price
                + " \nDescrizione: " + this.description 
		        + " \nCategoria :" + this.category;
    }

    @Override
    public boolean equals(Object o) 
    {
        // 1. Controllo identità
        if (this == o) return true;
        
        // 2. Controllo null e tipo
        if (o == null || !(o instanceof ProductBean)) return false;
        
        // 3. Cast
        ProductBean p = (ProductBean) o;
        
        // 4. Confronto campi con null-safety
        return this.getID() == p.getID() 
            && Objects.equals(this.getColor(), p.getColor())
            && Objects.equals(this.getModel(), p.getModel());
    }

    @Override
    public int hashCode() 
    {
        return Objects.hash(getID(), getColor(), getModel());
    }
}

