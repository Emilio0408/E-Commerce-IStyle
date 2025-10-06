package it.IStyle.model.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import it.IStyle.model.bean.Address;

public class AddressModel 
{
    private static DataSource ds;
    private static final String TABLE_NAME = "indirizzo";

    static
    {
        try
        {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            ds = (DataSource) envCtx.lookup("jdbc/istyledb");
        }
        catch(NamingException e)
        {
            System.out.println("Error: " + e.getMessage());
        }
    }



    public synchronized long doSave(Address address) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String Query = "INSERT INTO " + AddressModel.TABLE_NAME + " (CAP,Via,Nazione,NumeroCivico,Tipologia,Citta)" + " VALUES(?,?,?,?,?,?)";
        long IDIndirizzo = 0;

        try
        {
            connection = AddressModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(Query, Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setString(1, address.getCAP());
            preparedStatement.setString(2, address.getVia());
            preparedStatement.setString(3, address.getNazione());
            preparedStatement.setString(4, address.getNumeroCivico());
            preparedStatement.setString(5, address.getTipologia());
            preparedStatement.setString(6, address.getCitta());
            preparedStatement.executeUpdate();   
            ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
            if(generatedKeys.next())
            {
                IDIndirizzo = generatedKeys.getLong(1);
            }
            
        }
        finally
        {
            try
            {
                if(preparedStatement != null)
                    preparedStatement.close();
            }
            finally
            {
                if(connection != null)
                    connection.close();
            }
        }

        return IDIndirizzo;
    }


    public synchronized boolean doDelete(int IDIndirizzo) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String Query = "DELETE FROM " + AddressModel.TABLE_NAME + " WHERE IDIndirizzo = ?";
        int AffectedRows = 0;

        try
        {
            connection = AddressModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(Query);
            preparedStatement.setInt(1, IDIndirizzo);
            AffectedRows = preparedStatement.executeUpdate();
        }
        finally
        {
            try
            {
                if(preparedStatement != null)
                    preparedStatement.close();
            }
            finally
            {
                if(connection != null)
                    connection.close();
            }
        }

        return (AffectedRows != 0);
    }
}
