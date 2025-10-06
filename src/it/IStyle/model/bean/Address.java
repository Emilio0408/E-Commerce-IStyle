package it.IStyle.model.bean;

public class Address 
{
    private int IDIndirizzo;
    private String CAP;
    private String Via;
    private String Nazione;
    private String NumeroCivico;
    private String Tipologia;
    private String citta;


    //Metodi getter
    public int getIDIndirizzo()
    {
        return IDIndirizzo;
    }

    public String getCAP()
    {
        return this.CAP;
    }

    public String getVia()
    {
        return this.Via;
    }

    public String getNazione()
    {
        return this.Nazione;
    }

    public String getNumeroCivico()
    {
        return this.NumeroCivico;
    }

    public String getTipologia()
    {
        return this.Tipologia;
    }

    public String getCitta()
    {
        return this.citta;
    }

    public String getFullAddress()
    {
        return this.Via + " " + this.NumeroCivico + ", " + this.citta;
    }

    //Metodi setter
    public void setIDIndirizzo(int ID)
    {
        this.IDIndirizzo = ID;
    }

    public void setCAP(String CAP)
    {
        this.CAP = CAP;
    }

    public void setVia(String Via)
    {
        this.Via = Via;
    }

    public void setNazione(String nazione)
    {
        this.Nazione = nazione;
    }

    public void setNumeroCivico(String NumeroCivico)
    {
        this.NumeroCivico = NumeroCivico;
    }

    public void setTipologia(String Tipologia)
    {
        this.Tipologia = Tipologia;
    }

    public void setCitta(String citta)
    {
        this.citta = citta;
    }
}
