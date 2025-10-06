package it.IStyle.model.bean;

import java.util.LinkedList;

public class User 
{
    private String Username;
    private String Name;
    private String Surname;
    private String Password;
    private String email;
    private boolean NewsLetterSubscription;
    private boolean isAdmin;
    private int WishListID;
    private LinkedList<Address> addresses;

    public User()
    {
        this.addresses = new LinkedList<Address>();
    }


    //Metodi getter
    public String getUsername()
    {
        return this.Username;
    }

    public String getName()
    {
        return this.Name;
    }


    public String getSurname()
    {
        return this.Surname;
    }

    public String getPassword()
    {
        return this.Password;
    }

    public boolean getNewsLetterSubscription()
    {
        return this.NewsLetterSubscription;
    }

    public boolean getIfIsAdmin()
    {
        return this.isAdmin;
    }

    public String getEmail()
    {
        return this.email;
    }

    public int getWishListID()
    {
        return this.WishListID;
    }


    public LinkedList<Address> getAddresses()
    {
        return this.addresses;
    }



    //Metodi setter

    public void setUsername(String username)
    {
        this.Username = username;
    }

    public void setName(String name)
    {
        this.Name = name;
    }


    public void setSurname(String surname)
    {
        this.Surname = surname;
    }


    public void setPassword(String password)
    {
        this.Password = password;
    }

    public void setNewsLetterSubscription(boolean value)
    {
        this.NewsLetterSubscription = value;
    }

    public void setIfIsAdmin(boolean value)
    {
        this.isAdmin = value;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public void setWishListID(int ID)
    {
        this.WishListID = ID;
    }

    public void setAddresses(LinkedList<Address> addresses)
    {
        this.addresses = addresses;
    }




}
