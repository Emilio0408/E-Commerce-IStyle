package it.IStyle.model.dao;

import java.sql.*;
import java.util.LinkedList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.*;
import it.IStyle.model.bean.ProductBean;

public class WishListModel
{
    private static DataSource ds;

	static 
    {
		try 
        {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");

			ds = (DataSource) envCtx.lookup("jdbc/istyledb");

		}
        catch (NamingException e) 
        {
			System.out.println("Error:" + e.getMessage());
		}
	}


     /*
     *  METODI DA REALIZZARE
     *  doDelete(Rimuovere una lista dei preferiti dal DB)
     *  doSave(Creare una lista dei preferiti nel DB )
     *  doRemoveProductInWishList(Rimuovere un prodotto associato alla lista dei preferiti dell'utente)
     *  doAddProductInWishList(Aggiungere un prodotto associato alla lista dei preferiti dell'utente)
     *  doRetrieveProductsInWishList(Metodo per ottenere i prodotti presenti nella lista dei preferiti di un dato utente)
     * 
     * 
     *  Nello UserModel ricordare di rimuovere le istruzioni che creano la lista dei preferiti nel doSave, in quanto abbiamo deciso di separare
     *  logicamente le due cose. Al momento della registrazione di un nuovo utente verrà creata una nuova lista deipreferiti, grazie al metodo doSave
     *  che andiamo ad implementare qeui, che sarà poi associata al nuovo utente. Questo funziona perché un utente può registrarsi solo interagendo col sito 
     *  quindi gestendo bene la logica back-end non si avranno problemi di incosistenza di dati.
     * 
     */


    /* 
      Inserisce una nuova lista dei preferiti e , se va a buon fine , restituisce l'ID della nuova lista (in quanto tale ID è AutoIncrement nel db, quindi conviene
      farlo restituire per utilizzarlo) altrimenti restituisce 0;
    */
    public synchronized int doSave() throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String InsertQuery = "INSERT INTO preferiti VALUES()";
        int ID = 0;


        try
        {   
            connection = WishListModel.ds.getConnection();

            //Esecuzione dell'insert
            preparedStatement = connection.prepareStatement(InsertQuery, Statement.RETURN_GENERATED_KEYS);
            int AffectedRows = preparedStatement.executeUpdate();
            
            if(AffectedRows != 0)
            {
                ResultSet rs = preparedStatement.getGeneratedKeys();
                if(rs.next())
                    ID = rs.getInt(1);
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


        return ID;

    }


     public synchronized boolean doDelete(int IDList) throws SQLException
     {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "DELETE FROM preferiti WHERE IDListaPreferiti = ?";
        int result = 0;

        try
        {
            connection = WishListModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, IDList);
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

        
        return (result != 0);
     }

     public synchronized boolean doAddProductInWishList(int IDList, int IDProdotto) throws SQLException
     {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "INSERT INTO appartiene (IDProdotto,IDListaPreferiti) VALUES(?,?)";
        int AffectedRows = 0;

        try
        {
            connection = WishListModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1,IDProdotto);
            preparedStatement.setInt(2,IDList);
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

     public synchronized boolean doRemoveProductInWishList(int IDList, int IDProduct) throws SQLException
     {  
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "DELETE FROM appartiene WHERE IDProdotto = ? AND IDListaPreferiti = ? ";
        int AffectedRows = 0;


        try
        {
            connection = WishListModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, IDProduct);
            preparedStatement.setInt(2,IDList);
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

    public synchronized int doDeleteAllProductsFromWishList(int IDList) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "DELETE FROM appartiene WHERE IDListaPreferiti = ?";
        int AffectedRows = 0;


        try
        {
            connection = WishListModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, IDList);
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

        return AffectedRows;
    }


    public synchronized LinkedList<ProductBean> doRetrieveProductsInWishList(int IDList) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "SELECT p.IDProdotto, p.Costo, p.Nome,  p.Categoria, p.Descrizione\n" + //
                       "FROM prodotto p JOIN appartiene a ON p.IDProdotto = a.IDProdotto\n" + //
                       "WHERE a.IDListaPreferiti = ?;";
        LinkedList<ProductBean> products = new LinkedList<ProductBean>();
        ProductModel modelProducts = new ProductModel();


        
        try
        {
            connection = WishListModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, IDList);
            ResultSet rs = preparedStatement.executeQuery();
            ProductBean product = null;

            while(rs.next())
            {
                product = new ProductBean();
                product.setID(rs.getInt("IDProdotto"));
				product.setCategory(rs.getString("Categoria"));
				product.setName(rs.getString("Nome"));
				product.setPrice(rs.getBigDecimal("Costo"));
				product.setDescription(rs.getString("Descrizione"));

				products.add(product);
            }

            if(products.size() > 0)
            {
                for(ProductBean p : products)
                    p.setImagesPaths(modelProducts.doRetrieveImagePathsOfProducts(p.getID()));
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


        return products;
    }


    public synchronized boolean CheckIfProductIsInWishList(int IDWishList, int IDProduct) throws SQLException
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String query = "SELECT * FROM appartiene WHERE IDProdotto = ? AND IDListaPreferiti = ?";
        boolean check = false;

        try
        {
            connection = WishListModel.ds.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, IDProduct);
            preparedStatement.setInt(2, IDWishList);
            ResultSet rs = preparedStatement.executeQuery();

            if(rs.next())
                check = true;
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

        return check;

    }





}
