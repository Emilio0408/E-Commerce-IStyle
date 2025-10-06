package it.IStyle.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import it.IStyle.model.bean.Feedback;
import it.IStyle.model.bean.ProductBean;
import it.IStyle.model.bean.Variation;

public class ProductModel 
{
	private static DataSource ds;

	static {
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");

			ds = (DataSource) envCtx.lookup("jdbc/istyledb");

		} catch (NamingException e) {
			System.out.println("Error:" + e.getMessage());
		}
	}

	private static final String TABLE_NAME = "prodotto";


	//Update dei prodotti

	public synchronized void doSave(ProductBean product) throws SQLException 
	{

		Connection connection = null;
		PreparedStatement preparedStatement = null;

		String insertSQL = "INSERT INTO " + ProductModel.TABLE_NAME
				+ " (Costo, Nome, Categoria, Descrizione,personalizzabile) VALUES (?,?,?,?,?)";

		try 
		{
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(insertSQL);
			preparedStatement.setBigDecimal(1, product.getPriceAsBigDecimal() );
			preparedStatement.setString(2, product.getName());
			preparedStatement.setString(3, product.getCategory());
			preparedStatement.setString(4, product.getDescription());
			preparedStatement.setBoolean(5,product.getCustomizable());


			preparedStatement.executeUpdate();

			connection.commit();
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
	}



	public synchronized boolean doDelete(int code) throws SQLException 
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;

		int result = 0;

		String deleteSQL = "DELETE FROM " + ProductModel.TABLE_NAME + " WHERE IDProdotto = ?";

		try 
		{
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(deleteSQL);
			preparedStatement.setInt(1, code);

			result = preparedStatement.executeUpdate();
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
		return (result != 0);
	}


	public synchronized boolean doUpdateProductQuantity(ProductBean product, int newQuantity) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "UPDATE disponibilità SET QuantitàDisponibile = ? WHERE IDProdotto = ? AND colore = ? AND modello = ?";
		int affectedRows = 0;

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, newQuantity);
			preparedStatement.setInt(2, product.getID());
			preparedStatement.setString(3, product.getColor());
			preparedStatement.setString(4, product.getModel());
			affectedRows = preparedStatement.executeUpdate();
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

		return (affectedRows != 0);
	}



	//Recupero dei prodotti
	public synchronized LinkedList<ProductBean> doRetrieveAll(String order) throws SQLException 
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		LinkedList<ProductBean> products = new LinkedList<ProductBean>();
		LinkedList<ProductBean> tmpProducts = new LinkedList<ProductBean>();
		HashMap< Integer, HashMap<String,String> > colorOfProducts = new HashMap<>();
		HashMap< Integer, HashSet<String> > modelOfProducts = new HashMap<>();


		String selectSQL = "SELECT * FROM " + ProductModel.TABLE_NAME + " P JOIN disponibilità D ON P.IDProdotto = D.IDProdotto WHERE QuantitàDisponibile > 0";

		if (order != null && !order.equals("")) 
		{
			selectSQL += " ORDER BY " + order;
		}

		try 
		{
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(selectSQL);
			ResultSet rs = preparedStatement.executeQuery();

			while (rs.next()) 
			{
				ProductBean bean = new ProductBean();
				bean.setID(rs.getInt("IDProdotto"));
				bean.setName(rs.getString("Nome"));
				bean.setDescription(rs.getString("Descrizione"));
				bean.setPrice(rs.getBigDecimal("Costo"));
				bean.setCategory(rs.getString("Categoria"));
				bean.setCustomizable(rs.getBoolean("personalizzabile"));

				colorOfProducts.computeIfAbsent(bean.getID(), k -> new HashMap<String,String>()).put(rs.getString("colore"), rs.getString("codiceColore"));
				modelOfProducts.computeIfAbsent(bean.getID(), k -> new HashSet<>()).add(rs.getString("modello"));

				tmpProducts.add(bean);
			}


			products = populateProductsVariants(tmpProducts, colorOfProducts, modelOfProducts);

			if(products.size() > 0)
			{
				for(ProductBean p : products)
					p.setImagesPaths(doRetrieveImagePathsOfProducts(p.getID()));
			}

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
		return products;
	}



	public synchronized ProductBean doRetrieveByKey(int code) throws SQLException 
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ProductBean bean = null;

		String selectSQL = "SELECT * FROM " + ProductModel.TABLE_NAME + " WHERE IDProdotto = ?";

		try 
		{
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(selectSQL);
			preparedStatement.setInt(1, code);

			ResultSet rs = preparedStatement.executeQuery();
			if(rs.next()) 
			{	
				bean = new ProductBean();
				bean.setID(rs.getInt("IDProdotto"));
				bean.setName(rs.getString("Nome"));
				bean.setDescription(rs.getString("Descrizione"));
				bean.setPrice( rs.getBigDecimal("Costo") );
				bean.setCategory(rs.getString("Categoria"));
				bean.setCustomizable(rs.getBoolean("personalizzabile"));
				bean.setImagesPaths(doRetrieveImagePathsOfProducts(code));
			}
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


		return bean;
	}


	public synchronized LinkedList<ProductBean> doRetrieveByNamePrefix(String name) throws SQLException //METODO UTILE PER LA RICERCA ADATTIVA
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		LinkedList<ProductBean> products = new LinkedList<ProductBean>();

		String query = "SELECT * FROM " + ProductModel.TABLE_NAME + " WHERE Nome LIKE ? LIMIT 5" ;

		try
		{	
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, "%" + name + "%");
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
				product.setCustomizable(rs.getBoolean("personalizzabile"));


				products.add(product);
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

	public synchronized ProductBean doRetrieveByName(String name) throws SQLException 
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT * FROM " + ProductModel.TABLE_NAME + " P JOIN disponibilità D ON P.IDProdotto = D.IDProdotto WHERE QuantitàDisponibile > 0 AND Nome = ?";
		LinkedList<ProductBean> productVariants = new LinkedList<>();
		HashMap< Integer, HashMap<String,String> > colorOfProducts = new HashMap<>();
		HashMap< Integer, HashSet<String> > modelOfProducts = new HashMap<>();
		ProductBean product = null;


		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, name);
			ResultSet rs = preparedStatement.executeQuery();

			while(rs.next())
			{	
				product = new ProductBean();
				product.setID(rs.getInt("IDProdotto"));
				product.setCategory(rs.getString("Categoria"));
				product.setName(rs.getString("Nome"));
				product.setPrice(rs.getBigDecimal("Costo"));
				product.setDescription(rs.getString("Descrizione"));
				product.setCustomizable(rs.getBoolean("personalizzabile"));
				colorOfProducts.computeIfAbsent(product.getID(), k -> new HashMap<String,String>()).put(rs.getString("colore"), rs.getString("codiceColore"));
				modelOfProducts.computeIfAbsent(product.getID(), k -> new HashSet<>()).add(rs.getString("modello"));

				productVariants.add(product);
			}

			if(productVariants.size() > 0)
			{
				product = populateProductsVariants(productVariants, colorOfProducts, modelOfProducts).get(0);
				product.setImagesPaths(doRetrieveImagePathsOfProducts(product.getID()));
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

		return product;
	}


	public synchronized LinkedList<String> doRetrieveImagePathsOfProducts(int ID) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		LinkedList<String> paths = new LinkedList<String>();

		String SelectImageQuery = "SELECT * FROM " + ProductModel.TABLE_NAME + " P LEFT JOIN IMMAGINI I ON P.IDProdotto = I.IDProdotto" + " WHERE P.IDProdotto = ?";

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(SelectImageQuery);
			preparedStatement.setInt(1, ID);
			ResultSet rs = preparedStatement.executeQuery();

			while(rs.next())
			{	
				String path = rs.getString("Path");
				if(path != null)
					paths.add(path);
			}
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


		return paths;
	}


	//Prodotti più acquistati

	public synchronized LinkedList<ProductBean> doRetrieveBestProducts(int n_products) throws SQLException
	{
		 Connection connection = null;
		 PreparedStatement preparedStatement = null;
		 LinkedList<ProductBean> bestProducts = new LinkedList<ProductBean>();



		String query = "SELECT p.IDProdotto, p.Nome, p.Categoria, p.Costo, p.Descrizione,p.personalizzabile, COUNT(c.IDProdotto) AS NumeroVendite\n" + //
						"FROM contiene c\n" + //
						"JOIN prodotto p ON c.IDProdotto = p.IDProdotto\n" + //
						"GROUP BY c.IDProdotto\n" + //
						"ORDER BY NumeroVendite DESC\n" + //
						"LIMIT " + n_products + ";";
		
		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
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
				product.setCustomizable(rs.getBoolean("personalizzabile"));
				bestProducts.add(product);
			}

			if(bestProducts.size() > 0)
			{
				for(ProductBean p : bestProducts)
					p.setImagesPaths(doRetrieveImagePathsOfProducts(p.getID()));
			}
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


		return bestProducts;
	}


	//Filtri sui prodotti

	public synchronized LinkedList<ProductBean> doRetrieveByFilter(String[] category, int prezzo_min , int prezzo_max, String[] color, String[] model, boolean customizable) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT * " +
						" FROM Prodotto P JOIN disponibilità D ON P.IDProdotto = D.IDProdotto " +
						" WHERE 1 = 1 ";

		
		LinkedList<ProductBean> tmpProducts = new LinkedList<ProductBean>();
		LinkedList<ProductBean> products = new LinkedList<ProductBean>();
		LinkedList<String> parameters = new LinkedList<String>();



		if(category != null && category.length != 0)
		{
			query += " AND Categoria IN(" + "?,".repeat(category.length);
			query = query.substring(0, query.length() - 1) + ")";
			for(String s : category)
				parameters.add(s);
		}
		
	    if(prezzo_min != 0 || prezzo_max != 100)
			query += " AND Costo >= " + prezzo_min + " AND Costo <= " + prezzo_max;
		


		if(color != null && color.length != 0)
		{
			query += " AND colore IN(" + "?,".repeat(color.length);
			query = query.substring(0, query.length() - 1) + ")";
			for(String s : color)
				parameters.add(s);
		}


		if(model != null && model.length != 0)
		{
			query += " AND modello IN(" + "?,".repeat(model.length);
			query = query.substring(0, query.length() - 1) + ")";
			for(String s : model)
				parameters.add(s);
		}

		if(customizable == true)
		{
			query += " AND personalizzabile = true";
		}



		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);


			for(int i = 0 ; i < parameters.size() ; i++)
				preparedStatement.setString( i + 1 , parameters.get(i));
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
				product.setCustomizable(rs.getBoolean("personalizzabile"));
				

				tmpProducts.add(product);
			}

			int actualID = 0;
			for(ProductBean p : tmpProducts)
			{	
				int IDProduct = p.getID();
				if(actualID != IDProduct)
				{	
					HashMap<String,String> colors = new HashMap<>(doRetrieveColorsOfProduct(IDProduct));
					HashSet<String> models = new HashSet<>(doRetrieveModelsOfProduct(IDProduct));
					p.setAvaibleColors(colors);
					p.setAvaibleModels(models);
					products.add(p);
					actualID = IDProduct;
				}
			}


			if(products.size() > 0)
			{
				for(ProductBean p : products)
					p.setImagesPaths(doRetrieveImagePathsOfProducts(p.getID()));
			}
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




		return products;

	}  


	//Nuovi prodotti

	public synchronized LinkedList<ProductBean> doRetrieveLastAddedProducts(int n_products) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT * FROM " + ProductModel.TABLE_NAME + " ORDER BY IDProdotto DESC LIMIT ?";
		LinkedList<ProductBean> products = null;
		

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, n_products);
			ResultSet rs = preparedStatement.executeQuery();
			products = new LinkedList<ProductBean>();
			ProductBean product;

			while(rs.next())
			{
				product = new ProductBean();
				product.setID(rs.getInt("IDProdotto"));
				product.setCategory(rs.getString("Categoria"));
				product.setName(rs.getString("Nome"));
				product.setPrice(rs.getBigDecimal("Costo"));
				product.setDescription(rs.getString("Descrizione"));
				product.setCustomizable(rs.getBoolean("personalizzabile"));
				products.add(product);
			}

			for(ProductBean p : products)
			{
				p.setAvaibleColors(doRetrieveColorsOfProduct(p.getID()));
				p.setAvaibleModels(new HashSet<String>(doRetrieveModelsOfProduct(p.getID())));
			}

			if(products.size() > 0)
			{
				for(ProductBean p : products)
					p.setImagesPaths(doRetrieveImagePathsOfProducts(p.getID()));
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


	//Feedback dei prodotti

	public synchronized LinkedList<Feedback> doRetrieveProductFeedback(int productID) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT * FROM feedback WHERE IDProdotto = ?";
		LinkedList<Feedback> feedbacks = new LinkedList<Feedback>();

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, productID);
			ResultSet rs = preparedStatement.executeQuery();
			Feedback feedback = null;

			while(rs.next())
			{
				feedback = new Feedback();
				feedback.setIDFeedback(rs.getInt("IDRecensione"));
				feedback.setText(rs.getString("Testo"));
				feedback.setVote(rs.getInt("Voto"));
				feedback.setIDProdotto(rs.getInt("IDProdotto"));
				feedback.setUsername(rs.getString("Username"));
				feedback.setReviewDate(rs.getDate("dataRecensione"));
				feedbacks.add(feedback);
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

		return feedbacks;
	}




	public synchronized boolean addFeedbackToProduct(Feedback feedback) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "INSERT INTO feedback (Testo,Voto,IDProdotto,Username,dataRecensione) VALUES(?,?,?,?,?)";
		int affectedRows = 0;

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, feedback.getText());
			preparedStatement.setInt(2,  feedback.getVote());
			preparedStatement.setInt(3, feedback.getIDProdotto());
			preparedStatement.setString(4, feedback.getUsername());
			preparedStatement.setDate(5, feedback.getReviewDate());
			affectedRows = preparedStatement.executeUpdate();
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

		return (affectedRows != 0);
	}



	public synchronized boolean checkIfUserAlreadyReviewed(int IDProdotto, String username) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT * FROM feedback WHERE Username = ? AND IDProdotto = ?";
		boolean check = false;

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, username);
			preparedStatement.setInt(2, IDProdotto);
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

	//Gestione colori e modelli

	public synchronized HashMap<String,String> doRetrieveColorsOfProduct(int IDProdotto) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT DISTINCT D.colore , D.codiceColore " +  
					   "FROM prodotto P JOIN Disponibilità D ON P.IDProdotto = D.IDProdotto " + 
					   "WHERE D.IDProdotto = ?";

		HashMap<String,String> Colors = new HashMap<String,String>();

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1,IDProdotto);
			ResultSet rs =  preparedStatement.executeQuery();

			while(rs.next())
			{
				String colore = rs.getString("colore");
				String codiceColore = rs.getString("codiceColore");
				Colors.put(colore,codiceColore);
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

		return Colors;
	}


	public synchronized LinkedList<String> doRetrieveModelsOfProduct(int IDProdotto) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT DISTINCT D.modello " +  
					   "FROM prodotto P JOIN Disponibilità D ON P.IDProdotto = D.IDProdotto " + 
					   "WHERE D.IDProdotto = ?";

		LinkedList<String> Models = new LinkedList<String>();

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1,IDProdotto);
			ResultSet rs =  preparedStatement.executeQuery();

			while(rs.next())
			{
				String model = rs.getString("modello");
				Models.add(model);
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

		return Models;
	}


	public synchronized LinkedList<Variation> doRetrieveVariationsOfProduct(int IDProdotto) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT * FROM disponibilità WHERE IDProdotto = ?";
		LinkedList<Variation> variations = new LinkedList<Variation>();

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1,IDProdotto);
			ResultSet rs =  preparedStatement.executeQuery();
			Variation variation = null;

			while(rs.next())
			{
				variation = new Variation();
				variation.setColor(rs.getString("colore"));
				variation.setModel(rs.getString("modello"));
				variation.setQuantity(rs.getInt("QuantitàDisponibile"));
				variations.add(variation);

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

		return variations;
	}



	public synchronized HashSet<String> doRetrieveAllAvaibleColor() throws SQLException
	{	
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT colore FROM disponibilità WHERE QuantitàDisponibile > 0";
		HashSet<String> colors = new HashSet<String>();

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			ResultSet rs = preparedStatement.executeQuery();

			while(rs.next())
			{
				colors.add(rs.getString("colore"));
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

		return colors;
	}


	public synchronized int doRetrieveAvaibleQuantity(ProductBean product) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT QuantitàDisponibile FROM disponibilità WHERE IDProdotto = ? AND colore = ? AND modello = ?";
		int newQuantity = 0;

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, product.getID());
			preparedStatement.setString(2, product.getColor());
			preparedStatement.setString(3, product.getModel());
			ResultSet rs = preparedStatement.executeQuery();

			if(rs.next())
				newQuantity = rs.getInt("QuantitàDisponibile");
		}
		finally
		{
			try
			{

			}
			finally
			{

			}
		}


		return newQuantity;
	}




	//Utilities
	private LinkedList<ProductBean> populateProductsVariants(LinkedList<ProductBean> products, HashMap<Integer, HashMap<String,String> > colors,  HashMap<Integer, HashSet<String> > models)
	{
		LinkedList<ProductBean> finalProductsList = new LinkedList<ProductBean>();

		int actualID = 0;

		for(ProductBean p : products)
		{		
			int IDProduct = p.getID();
			if(actualID != IDProduct)
			{	
				p.setAvaibleColors(colors.get(IDProduct));
				p.setAvaibleModels(models.get(IDProduct));
				finalProductsList.add(p);
				actualID = IDProduct;
			}
		}
		
		return finalProductsList;
	}

	// ===========================================
	// METODI AGGIUNTIVI PER FUNZIONALITÀ ADMIN
	// ===========================================

	/**
	 * Inserisce un nuovo prodotto e ritorna l'ID auto-generato
	 * Necessario per collegare varianti e immagini al prodotto creato
	 */
	public synchronized int doSaveWithReturnId(ProductBean product) throws SQLException 
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet generatedKeys = null;
		int generatedId = -1;

		String insertSQL = "INSERT INTO " + ProductModel.TABLE_NAME + 
			" (Costo, Nome, Categoria, Descrizione, personalizzabile) VALUES (?,?,?,?,?)";

		try 
		{
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(insertSQL, PreparedStatement.RETURN_GENERATED_KEYS);
			
			preparedStatement.setBigDecimal(1, product.getPriceAsBigDecimal());
			preparedStatement.setString(2, product.getName());
			preparedStatement.setString(3, product.getCategory());
			preparedStatement.setString(4, product.getDescription());
			preparedStatement.setBoolean(5, product.getCustomizable());

			int affectedRows = preparedStatement.executeUpdate();
			
			if (affectedRows == 0) {
				throw new SQLException("Inserimento prodotto fallito, nessuna riga modificata.");
			}

			generatedKeys = preparedStatement.getGeneratedKeys();
			if (generatedKeys.next()) {
				generatedId = generatedKeys.getInt(1);
			} else {
				throw new SQLException("Inserimento prodotto fallito, nessun ID generato.");
			}

			connection.commit();
		} 
		finally 
		{
			try 
			{
				if (generatedKeys != null)
					generatedKeys.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} 
			finally 
			{
				if (connection != null)
					connection.close();
			}
		}
		
		return generatedId;
	}

	/**
	 * Inserisce una variante (colore + modello + quantità) per un prodotto
	 * Utilizzato durante la creazione di nuovi prodotti con varianti
	 */
	public synchronized boolean doSaveVariation(int productId, String color, String colorCode, String model, int quantity) throws SQLException 
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		int result = 0;

		String insertSQL = "INSERT INTO disponibilità (IDProdotto, colore, codiceColore, modello, QuantitàDisponibile) VALUES (?,?,?,?,?)";

		try 
		{
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(insertSQL);
			
			preparedStatement.setInt(1, productId);
			preparedStatement.setString(2, color);
			preparedStatement.setString(3, colorCode != null ? colorCode : "#000000");
			preparedStatement.setString(4, model);
			preparedStatement.setInt(5, quantity);

			result = preparedStatement.executeUpdate();
			connection.commit();
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
		
		return (result != 0);
	}

	/**
	 * Inserisce il percorso di un'immagine per un prodotto
	 * Utilizzato durante la creazione/modifica di prodotti con immagini
	 */
	public synchronized boolean doSaveImage(int productId, String imagePath) throws SQLException 
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		int result = 0;

		String insertSQL = "INSERT INTO immagini (IDProdotto, Path) VALUES (?,?)";

		try 
		{
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(insertSQL);
			
			preparedStatement.setInt(1, productId);
			preparedStatement.setString(2, imagePath);

			result = preparedStatement.executeUpdate();
			connection.commit();
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
		
		return (result != 0);
	}

	/**
	 * Aggiorna i dati base di un prodotto esistente
	 * Utilizzato per modificare nome, prezzo, categoria, descrizione, personalizzabile
	 */
	public synchronized boolean doUpdate(ProductBean product) throws SQLException 
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		int result = 0;

		String updateSQL = "UPDATE " + ProductModel.TABLE_NAME + 
			" SET Costo=?, Nome=?, Categoria=?, Descrizione=?, personalizzabile=? WHERE IDProdotto=?";

		try 
		{
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(updateSQL);
			
			preparedStatement.setBigDecimal(1, product.getPriceAsBigDecimal());
			preparedStatement.setString(2, product.getName());
			preparedStatement.setString(3, product.getCategory());
			preparedStatement.setString(4, product.getDescription());
			preparedStatement.setBoolean(5, product.getCustomizable());
			preparedStatement.setInt(6, product.getID());

			result = preparedStatement.executeUpdate();
			connection.commit();
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
		
		return (result != 0);
	}

	/**
	 * Versione overloaded di doUpdateProductQuantity per usare parametri individuali
	 * Utilizzata dalla servlet admin per aggiornare lo stock delle varianti
	 */
	public synchronized boolean doUpdateProductQuantity(int productId, String color, String model, int quantity) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "UPDATE disponibilità SET QuantitàDisponibile = ? WHERE IDProdotto = ? AND colore = ? AND modello = ?";
		int affectedRows = 0;

		try
		{
			connection = ProductModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, quantity);
			preparedStatement.setInt(2, productId);
			preparedStatement.setString(3, color);
			preparedStatement.setString(4, model);
			affectedRows = preparedStatement.executeUpdate();
			connection.commit();
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

		return (affectedRows != 0);
	}

}