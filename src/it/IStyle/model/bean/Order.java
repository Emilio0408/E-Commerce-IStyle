package it.IStyle.model.bean;


import java.sql.Date;
import java.util.LinkedList;



public class Order
{
    private int IDOrdine;
    private Date DataErogazione;
    private Date DataConsegna;
    private String metodoDiSpedizione;
    private double ImportoTotale;
    private Date DataEmissione;
    private String tipoPagamento;
    private String stato;
    private String IndirizzoDiSpedizione;
    private String paymentIntentID;
    private LinkedList<ProductBean> productsInOrder;
    private String Username;
    


    public int getIDOrdine()
    {
        return this.IDOrdine;
    }

    public Date getDataErogazione()
    {
        return this.DataErogazione;
    }

    public Date getDataConsegna()
    {
        return this.DataConsegna;
    }

    public String getMetodoDiSpedizione()
    {
        return this.metodoDiSpedizione;
    }


    public double getImportoTotale()
    {   
        return this.ImportoTotale;
    } 
    

    public Date getDataEmissione()
    {
        return this.DataEmissione;
    }

    public String getTipoPagamento()
    {
        return this.tipoPagamento;
    }

    public String getStato()
    {
        return this.stato;
    }

    public String getIndirizzoDiSpedizione()
    {
        return this.IndirizzoDiSpedizione;
    }

    public LinkedList<ProductBean> getProductsInOrder()
    {
        return this.productsInOrder;
    }

    public String getPaymentIntentID()
    {
        return this.paymentIntentID;
    }
    
    public String getUsername()
    {
        return this.Username;
    }



    public void setIDOrdine(int ID)
    {
        this.IDOrdine = ID;
    }

    public void setDataErogazione(Date date)
    {
        this.DataErogazione = date;
    }

    public void setDataConsegna(Date date)
    {
        this.DataConsegna = date;
    }

    public void setMetodoDiSpedizione(String metodo)
    {
        this.metodoDiSpedizione = metodo;
    }

    public void setImportoTotale(double importo)
    {
        this.ImportoTotale = importo;
    }

    public void setDataEmissione(Date date)
    {
        this.DataEmissione = date;
    }

    public void setTipoPagamento(String tipoPagamento)
    {
        this.tipoPagamento = tipoPagamento;
    }

    public void setStato(String stato)
    {
        this.stato = stato;
    }

    public void setIndirizzoDiSpedizione(String indirizzoDiSpedizione)
    {
        this.IndirizzoDiSpedizione = indirizzoDiSpedizione;
    }

    public void setPaymentIntentID(String paymentIntentID)
    {
        this.paymentIntentID = paymentIntentID;
    }

    public void setProductsInOrder(LinkedList<ProductBean> products)
    {
        this.productsInOrder = products;
    }

    public void setUsername(String username)
    {
        this.Username = username;
    }


}
