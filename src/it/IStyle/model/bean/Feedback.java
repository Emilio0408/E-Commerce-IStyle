package it.IStyle.model.bean;

import java.sql.Date;
import java.text.SimpleDateFormat;

public class Feedback 
{
    int IDFeedback;
    String text;
    int vote;
    int IDProdotto;
    String username;
    Date ReviewDate;


    //Getter
    public int getIDFeedback()
    {
        return this.IDFeedback;
    }

    public String getText()
    {
        return this.text;
    }

    public int getVote()
    {
        return this.vote;
    }

    public int getIDProdotto()
    {
        return this.IDProdotto;
    }

    public String getUsername()
    {
        return this.username;
    }

    public Date getReviewDate()
    {
        return this.ReviewDate;
    }


    public String getFormattedDate()
    {
        if(this.ReviewDate == null) 
            return null;

        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yy");
        String formattedDate = formatter.format(this.ReviewDate);

        return formattedDate;
        
    }



    //Setter


    public void setIDFeedback(int IDFeedback)
    {
        this.IDFeedback = IDFeedback;
    }

    public void setText(String text)
    {
        this.text = text;
    }

    public void setVote(int vote)
    {
        this.vote = vote;
    }

    public void setIDProdotto(int IDProdotto)
    {
        this.IDProdotto = IDProdotto;
    }

    public void setUsername(String username)
    {
        this.username = username;
    }

    public void setReviewDate(Date date)
    {
        this.ReviewDate = date;
    }
}
