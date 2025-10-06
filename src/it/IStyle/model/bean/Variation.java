package it.IStyle.model.bean;

public class Variation 
{
    private String color;
    private String model;
    private int Quantity;


    //Metodi getter
    public String getColor()
    {
        return this.color;
    }

    public String getModel()
    {
        return this.model;
    }

    public int getQuantity()
    {
        return this.Quantity;
    }



    //Metodi setter
    public void setColor(String color)
    {
        this.color = color;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public void setQuantity(int Quantity)
    {
        this.Quantity = Quantity;
    }


}
