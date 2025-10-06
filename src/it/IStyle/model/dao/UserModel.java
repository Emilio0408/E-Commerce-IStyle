package it.IStyle.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.LinkedList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import it.IStyle.model.bean.User;
import it.IStyle.model.bean.Address;



public class UserModel 
{   
    private static DataSource ds;


    static{
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


    private static final String table = "utente";


    public synchronized boolean doSave(User user) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String querySQL = "INSERT INTO " + UserModel.table + " (Username,Nome,Cognome,Passw,IscrizioneNewsLetter,IDListaPreferiti,ruolo,email)" +
            "VALUES(?,?,?,?,?,?,?,?)";
        int AffectedRows = 0;
        

        try
        {
            connection = ds.getConnection();
            //Adesso eseguiamo l'inserimento
            preparedStatement = connection.prepareStatement(querySQL);
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getName());
            preparedStatement.setString(3, user.getSurname());
            preparedStatement.setString(4, user.getPassword());
            preparedStatement.setBoolean(5, user.getNewsLetterSubscription());
            preparedStatement.setInt(6, user.getWishListID());
            preparedStatement.setBoolean(7, user.getIfIsAdmin());
            preparedStatement.setString(8, user.getEmail());
            AffectedRows = preparedStatement.executeUpdate();
        }
        finally 
		{
			try 
			{
				if (preparedStatement != null)
					preparedStatement.close();
			} 
			finally 
			{
				if (connection != null)
					connection.close();
			}
		}

        return (AffectedRows != 0);
    }

    public synchronized User doRetrieveByKey(String username) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        User user = null;
        String querySQL = "SELECT * FROM " + UserModel.table + " WHERE Username = ?";

        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(querySQL);
            preparedStatement.setString(1, username);
            ResultSet rs = preparedStatement.executeQuery();
            if(rs.next())
            {   
                user = new User();
                user.setUsername(rs.getString("Username"));
                user.setName(rs.getString("Nome"));
                user.setSurname(rs.getString("Cognome"));
                user.setPassword(rs.getString("Passw"));
                user.setNewsLetterSubscription(rs.getBoolean("IscrizioneNewsLetter"));
                user.setIfIsAdmin(rs.getBoolean("ruolo"));
                user.setWishListID(rs.getInt("IDListaPreferiti"));
                user.setEmail(rs.getString("email"));
                user.setAddresses(doRetrieveUserAddresses(username));
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

        return user;

    }

    public synchronized User doRetrieveByEmail(String email) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        User user = null;
        String querySQL = "SELECT * FROM " + UserModel.table + " WHERE email = ?";

        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(querySQL);
            preparedStatement.setString(1, email);
            ResultSet rs = preparedStatement.executeQuery();
            if(rs.next())
            {   
                user = new User();
                user.setUsername(rs.getString("Username"));
                user.setName(rs.getString("Nome"));
                user.setSurname(rs.getString("Cognome"));
                user.setPassword(rs.getString("Passw"));
                user.setNewsLetterSubscription(rs.getBoolean("IscrizioneNewsLetter"));
                user.setIfIsAdmin(rs.getBoolean("ruolo"));
                user.setWishListID(rs.getInt("IDListaPreferiti"));
                user.setEmail(rs.getString("email"));
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

        return user;

    }

    public synchronized LinkedList<Address> doRetrieveUserAddresses(String username) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "SELECT I.IDIndirizzo, I.CAP, I.Via, I.Nazione, I.NumeroCivico, I.Tipologia, I.citta " +
                        "FROM salva S JOIN indirizzo I ON S.IDIndirizzo = I.IDIndirizzo " + 
                        "WHERE Username = ?";

        LinkedList<Address> addresses = new LinkedList<Address>();


        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            ResultSet rs = preparedStatement.executeQuery();
            Address address = null;
            while(rs.next())
            {   
                address = new Address();
                address.setIDIndirizzo(rs.getInt("IDIndirizzo"));
                address.setCAP(rs.getString("CAP"));
                address.setVia(rs.getString("Via"));
                address.setNazione(rs.getString("Nazione"));
                address.setNumeroCivico(rs.getString("NumeroCivico"));
                address.setTipologia(rs.getString("Tipologia"));
                address.setCitta(rs.getString("citta"));
                addresses.add(address);
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

        return addresses;
    }


    public synchronized boolean doDelete(String username) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String deleteSQL = "DELETE FROM" + UserModel.table + "WHERE Username = ?";
        int result = 0;

        
        try
        {
            connection = ds.getConnection();
            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setString(0, username);
            result = preparedStatement.executeUpdate();
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

        return  (result != 0);
    }


    public synchronized boolean DoUpdateName(String newName, String Username) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "UPDATE utente SET Nome = ? WHERE Username = ?";
        int AffectedRows = 0;


        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, newName);
            preparedStatement.setString(2, Username);
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

    public synchronized boolean DoUpdateSurname(String newSurname, String Username) throws SQLException
    {
            
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "UPDATE utente SET Cognome = ? WHERE Username = ?";
        int AffectedRows = 0;


        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, newSurname);
            preparedStatement.setString(2, Username);
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

    public synchronized boolean DoUpdatePassword(String newPassword, String Username) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "UPDATE utente SET Passw = ? WHERE Username = ?";
        int AffectedRows = 0;

        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, newPassword);
            preparedStatement.setString(2, Username);
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

    public synchronized boolean DoUpdateEmail(String newEmail, String Username) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "UPDATE utente SET email = ? WHERE Username = ?";
        int AffectedRows = 0;


        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, newEmail);
            preparedStatement.setString(2, Username);
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
    


    public synchronized Collection<User> doRetrieveAll(String sort) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        Collection<User> users = new LinkedList<User>();
        User user = new User();

        String selectSQL = "SELECT * FROM" + UserModel.table;

        if(sort != null)
            selectSQL += "GROUP BY" + sort;


        try
        {
            connection = ds.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            ResultSet rs = preparedStatement.executeQuery();
            
            while(rs.next())
            {
                user.setUsername(rs.getString("Username"));
                user.setName(rs.getString("Nome"));
                user.setSurname(rs.getString("Cognome"));
                user.setPassword(rs.getString("Passw"));
                user.setNewsLetterSubscription(rs.getBoolean("IscrizioneNewsLetter"));
                user.setIfIsAdmin(rs.getBoolean("ruolo"));
                user.setWishListID(rs.getInt("IDListaPreferiti"));
                user.setEmail(rs.getString("email"));

                users.add(user);
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
                    preparedStatement.close();
            }
        }

        return users;
    }


    public synchronized boolean doAddAddress(String username, int IDIndirizzo) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "INSERT INTO salva (Username,IDIndirizzo) VALUES(?,?)";
        int AffectedRows = 0;

        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            preparedStatement.setInt(2,IDIndirizzo);
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

    public synchronized boolean doRemoveAddress(String username, int IDIndirizzo) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "DELETE FROM salva WHERE IDIndirizzo = ? AND Username = ?";
        int AffectedRows = 0;

        try
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, IDIndirizzo);
            preparedStatement.setString(2,username);
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


    public synchronized boolean checkIfEmailExists(String email) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "SELECT * FROM utente WHERE email = ?";
        boolean exsist = false;

        try 
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            ResultSet rs = preparedStatement.executeQuery();

            if(rs.next())
                exsist = true;
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


        return exsist;
    }

    public synchronized boolean checkIfUsernameExists(String username) throws SQLException
    {   
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "SELECT * FROM utente WHERE Username = ?";
        boolean exsist = false;

        try 
        {
            connection = UserModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            ResultSet rs = preparedStatement.executeQuery();

            if(rs.next())
                exsist = true;
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


        return exsist;
    }
    
}
