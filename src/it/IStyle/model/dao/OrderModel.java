package it.IStyle.model.dao;

import java.sql.Statement;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.util.LinkedList;
import it.IStyle.model.bean.Order;
import it.IStyle.model.bean.ProductBean;

public class OrderModel 
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

	private static final String TABLE_NAME = "ordine";


	private synchronized boolean associateOrderToUser(String username, int IDOrdine) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "INSERT INTO effettua (Username,IDOrdine) VALUES(?,?)";
		int AffectedRows = 0;

		try
		{
			connection = OrderModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, username);
			preparedStatement.setInt(2, IDOrdine);
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

	private synchronized boolean associateProductsToOrder(int IDOrdine, LinkedList<ProductBean> products) throws SQLException
	{
		//Si deve comporre una query aggiungendo X stringhe di VALUES per la insert per qunti sono i prodotti. L'ID ordine è uguale in tutti i casi, cambia solo l'id del prodotto.
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "INSERT INTO contiene (IDProdotto, IDOrdine, Quantita,colore,modello) VALUES ";
		int AffectedRows = 0;


		for(int i = 0 ; i < products.size() ; i++)
			query += "(?,?,?,?,?), ";
		
		query = query.substring(0, query.length() - 2); //Per rimuovere la virgola

		try
		{
			connection = OrderModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);

			int paramIndex = 1;
			for(ProductBean p : products)
			{
				preparedStatement.setInt( paramIndex++ , p.getID());
				preparedStatement.setInt( paramIndex++ , IDOrdine);
				preparedStatement.setInt( paramIndex++ , p.getQuantityInCart());
				preparedStatement.setString( paramIndex++ , p.getColor());
				preparedStatement.setString( paramIndex++ , p.getModel());
			}

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

	private synchronized LinkedList<ProductBean> doRetrieveProductsInOrder(int IDOrdine) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT p.IDProdotto, p.Costo, p.Nome, p.Categoria,p.Descrizione,p.personalizzabile, c.colore, c.modello, c.Quantita" +
					   " FROM prodotto p JOIN contiene c ON p.IDProdotto = c.IDProdotto" +
					   " WHERE c.IDOrdine = ?";
		
		LinkedList<ProductBean> productsInOrder = new LinkedList<ProductBean>();
		ProductModel modelProduct = new ProductModel();

		try
		{
			connection = OrderModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, IDOrdine);
			ResultSet rs = preparedStatement.executeQuery();
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
				product.setColor(rs.getString("colore"));
				product.setModel(rs.getString("modello"));
				product.setQuantityInCart(rs.getInt("Quantita"));
				productsInOrder.add(product);
			}

			for(ProductBean p: productsInOrder)
			{
				p.setImagesPaths(modelProduct.doRetrieveImagePathsOfProducts(p.getID()));
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

		return productsInOrder;
	}




	public synchronized int doSave(Order order, String username) throws SQLException //Salva l'ordine nel DB completamente (associando i valori anche nelle tabelle al di fuori di quella dell'ordine) e restituisce l'ID dell'ordine appena inserito, 0 se fallisce nell'inserimento
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "INSERT INTO " + OrderModel.TABLE_NAME + " (DataErogazione,DataConsegna,MetodoDiSpedizione,ImportoTotale,DataEmissione,TipoPagamento,Stato,IndirizzoSpedizione,paymentIntent) VALUES(?,?,?,?,?,?,?,?,?)";
		int IDOrdine = 0;
		try
		{	
			connection = OrderModel.ds.getConnection();

			//Inserimento dell'ordine
			preparedStatement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
			preparedStatement.setDate(1, order.getDataErogazione());
			preparedStatement.setDate(2, order.getDataConsegna());
			preparedStatement.setString(3, order.getMetodoDiSpedizione());
			preparedStatement.setBigDecimal(4, BigDecimal.valueOf(order.getImportoTotale()));
			preparedStatement.setDate(5, order.getDataEmissione());
			preparedStatement.setString(6, order.getTipoPagamento());
			preparedStatement.setString(7, order.getStato()); 
			preparedStatement.setString(8, order.getIndirizzoDiSpedizione());
			preparedStatement.setString(9, order.getPaymentIntentID());

			//Stati possibili dell'ordine : Elaborazione , Spedito , Ricevuto

			if(preparedStatement.executeUpdate() > 0)  //Se l'inserimento dell'ordine va a buon fine 
			{
				//Associamo l'ordine all'utente
				ResultSet rs = preparedStatement.getGeneratedKeys(); //Restituisce i dati generati dal DB con l'operazione di UPDATE (quelli inseriti nella tabella in questo caso)
				if(rs.next())
				{
					IDOrdine = rs.getInt(1);
					if(associateOrderToUser(username,IDOrdine)) //Se riusciamo ad associare l'ordine allo user
					{
						//Procediamo con associare i prodotti all'ordine.
						associateProductsToOrder(IDOrdine, order.getProductsInOrder());
					}
				}
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

		return IDOrdine;
	}

	public synchronized boolean doDelete(int IDOrdine) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "DELETE FROM " + OrderModel.TABLE_NAME + " WHERE IDOrdine = ?";
		int AffectedRows = 0;

		try
		{
			connection = OrderModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, IDOrdine);
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



	public synchronized LinkedList<Order> doRetrieveUserOrders(String Username) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT O.IDOrdine, O.DataErogazione, O.DataConsegna, O.MetodoDiSpedizione,O.ImportoTotale,O.DataEmissione, O.TipoPagamento, O.Stato, O.IndirizzoSpedizione,O.paymentIntent" +
						" FROM ordine O JOIN effettua E ON O.IDOrdine = E.IDOrdine" + 
						" WHERE Username = ? " +
						" ORDER BY O.IDOrdine DESC";

		LinkedList<Order> orders = new LinkedList<Order>();

		try
		{
			connection = OrderModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, Username);
			ResultSet rs = preparedStatement.executeQuery();
			Order order;

			while(rs.next())
			{	
				order = new Order();
				order.setIDOrdine(rs.getInt("IDOrdine"));
				order.setDataErogazione(rs.getDate("DataErogazione"));;
				order.setDataConsegna(rs.getDate("DataConsegna"));
				order.setMetodoDiSpedizione(rs.getString("MetodoDiSpedizione"));
				order.setImportoTotale(rs.getDouble("ImportoTotale"));
				order.setDataEmissione(rs.getDate("DataEmissione"));
				order.setTipoPagamento((rs.getString("TipoPagamento")));
				order.setStato(rs.getString("Stato"));
				order.setIndirizzoDiSpedizione(rs.getString("IndirizzoSpedizione"));
				order.setProductsInOrder(doRetrieveProductsInOrder(order.getIDOrdine()));
				order.setPaymentIntentID(rs.getString("paymentIntent"));
				orders.add(order);
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
			
		
		
		return orders;
	}


    public synchronized boolean hasUserPlacedOrder(String username, int IDOrdine) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT * FROM effettua WHERE Username = ? AND IDOrdine = ?";
		boolean check = false;

		try
		{
			connection = OrderModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, username);
			preparedStatement.setInt(2, IDOrdine);
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


	public synchronized Order doRetrieveByPaymentIntent(String paymentIntentID) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String query = "SELECT * FROM " +  OrderModel.TABLE_NAME + " WHERE paymentIntent = ?";
		Order order = null;
		
		try
		{
			connection = OrderModel.ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, paymentIntentID);
			ResultSet rs = preparedStatement.executeQuery();

			if(rs.next())
			{
				order = new Order();
				order.setIDOrdine(rs.getInt("IDOrdine"));
				order.setDataErogazione(rs.getDate("DataErogazione"));;
				order.setDataConsegna(rs.getDate("DataConsegna"));
				order.setMetodoDiSpedizione(rs.getString("MetodoDiSpedizione"));
				order.setImportoTotale(rs.getInt("ImportoTotale"));
				order.setDataEmissione(rs.getDate("DataEmissione"));
				order.setTipoPagamento((rs.getString("TipoPagamento")));
				order.setStato(rs.getString("Stato"));
				order.setIndirizzoDiSpedizione(rs.getString("IndirizzoSpedizione"));
				order.setProductsInOrder(doRetrieveProductsInOrder(order.getIDOrdine()));
				order.setPaymentIntentID(rs.getString("paymentIntent"));
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


		return order;
	}


	public synchronized Order doRetrieveByKey(int IDOrdine) throws SQLException
	{
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		Order order = null;

		String query = "SELECT * FROM ordine WHERE IDOrdine = ?";

		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, IDOrdine);
			
			ResultSet rs = preparedStatement.executeQuery();
			
			if (rs.next()) {
				order = new Order();
				order.setIDOrdine(rs.getInt("IDOrdine"));
				order.setDataErogazione(rs.getDate("DataErogazione"));
				order.setDataConsegna(rs.getDate("DataConsegna"));
				order.setMetodoDiSpedizione(rs.getString("MetodoDiSpedizione"));
				order.setImportoTotale(rs.getBigDecimal("ImportoTotale").doubleValue());
				order.setDataEmissione(rs.getDate("DataEmissione"));
				order.setTipoPagamento(rs.getString("TipoPagamento"));
				order.setStato(rs.getString("Stato"));
				order.setIndirizzoDiSpedizione(rs.getString("IndirizzoSpedizione"));
				order.setPaymentIntentID(rs.getString("paymentIntent"));
			}
		} finally {
			try {
				if (preparedStatement != null) preparedStatement.close();
			} finally {
				if (connection != null) connection.close();
			}
		}



		return order;
	}

	// ===========================================
	// METODI AGGIUNTIVI PER FUNZIONALITÀ ADMIN
	// ===========================================

	/**
	 * Recupera ordini filtrati per username con paginazione e ordinamento
	 */
	public synchronized LinkedList<Order> doRetrieveByUsername(String username, String sort, int limit, int offset) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		LinkedList<Order> orders = new LinkedList<Order>();

		String query = "SELECT O.*, U.Nome, U.Cognome, U.email, E.Username FROM " + TABLE_NAME + " O " +
			"JOIN effettua E ON O.IDOrdine = E.IDOrdine " +
			"JOIN utente U ON E.Username = U.Username " +
			"WHERE E.Username = ? " +
			"ORDER BY O.DataEmissione " + (sort.equals("asc") ? "ASC" : "DESC") + 
			" LIMIT ? OFFSET ?";

		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, username);
			preparedStatement.setInt(2, limit);
			preparedStatement.setInt(3, offset);
			
			ResultSet rs = preparedStatement.executeQuery();
			
			while (rs.next()) {
				Order order = new Order();
				order.setIDOrdine(rs.getInt("IDOrdine"));
				order.setDataErogazione(rs.getDate("DataErogazione"));
				order.setDataConsegna(rs.getDate("DataConsegna"));
				order.setMetodoDiSpedizione(rs.getString("MetodoDiSpedizione"));
				order.setImportoTotale(rs.getBigDecimal("ImportoTotale").doubleValue());
				order.setDataEmissione(rs.getDate("DataEmissione"));
				order.setTipoPagamento(rs.getString("TipoPagamento"));
				order.setStato(rs.getString("Stato"));
				order.setIndirizzoDiSpedizione(rs.getString("IndirizzoSpedizione"));
				order.setPaymentIntentID(rs.getString("paymentIntent"));
				order.setUsername(rs.getString("Username"));
				orders.add(order);
			}
		} finally {
			try {
				if (preparedStatement != null) preparedStatement.close();
			} finally {
				if (connection != null) connection.close();
			}
		}
		
		return orders;
	}

	/**
	 * Recupera tutti gli ordini con dettagli completi, paginazione e ordinamento
	 */
	public synchronized LinkedList<Order> doRetrieveAllWithDetails(String sort, int limit, int offset) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		LinkedList<Order> orders = new LinkedList<Order>();

		String query = "SELECT O.*, E.Username, U.Nome, U.Cognome, U.email FROM " + TABLE_NAME + " O " +
			"JOIN effettua E ON O.IDOrdine = E.IDOrdine " +
			"JOIN utente U ON E.Username = U.Username " +
			"ORDER BY O.DataEmissione " + (sort.equals("asc") ? "ASC" : "DESC") + 
			" LIMIT ? OFFSET ?";

		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, limit);
			preparedStatement.setInt(2, offset);
			
			ResultSet rs = preparedStatement.executeQuery();
			
			while (rs.next()) {
				Order order = new Order();
				order.setIDOrdine(rs.getInt("IDOrdine"));
				order.setDataErogazione(rs.getDate("DataErogazione"));
				order.setDataConsegna(rs.getDate("DataConsegna"));
				order.setMetodoDiSpedizione(rs.getString("MetodoDiSpedizione"));
				order.setImportoTotale(rs.getBigDecimal("ImportoTotale").doubleValue());
				order.setDataEmissione(rs.getDate("DataEmissione"));
				order.setTipoPagamento(rs.getString("TipoPagamento"));
				order.setStato(rs.getString("Stato"));
				order.setIndirizzoDiSpedizione(rs.getString("IndirizzoSpedizione"));
				order.setPaymentIntentID(rs.getString("paymentIntent"));
				order.setUsername(rs.getString("Username"));
				
				orders.add(order);
			}
		} finally {
			try {
				if (preparedStatement != null) preparedStatement.close();
			} finally {
				if (connection != null) connection.close();
			}
		}
		
		return orders;
	}

	/**
	 * Recupera lista degli username che hanno effettuato ordini (per filtro)
	 */
	public synchronized LinkedList<String> doRetrieveDistinctUsernames() throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		LinkedList<String> usernames = new LinkedList<String>();

		String query = "SELECT DISTINCT E.Username FROM effettua E ORDER BY E.Username";

		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			ResultSet rs = preparedStatement.executeQuery();
			
			while (rs.next()) {
				usernames.add(rs.getString("Username"));
			}
		} finally {
			try {
				if (preparedStatement != null) preparedStatement.close();
			} finally {
				if (connection != null) connection.close();
			}
		}
		
		return usernames;
	}

	/**
	 * Recupera statistiche generali degli ordini per dashboard admin
	 */
	public synchronized com.google.gson.JsonObject doRetrieveOrderStats() throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		com.google.gson.JsonObject stats = new com.google.gson.JsonObject();

		try {
			connection = ds.getConnection();
			
			// Totale ordini
			preparedStatement = connection.prepareStatement("SELECT COUNT(*) as total FROM " + TABLE_NAME);
			ResultSet rs = preparedStatement.executeQuery();
			if (rs.next()) {
				stats.addProperty("totalOrders", rs.getInt("total"));
			}
			preparedStatement.close();
			
			// Ricavi totali
			preparedStatement = connection.prepareStatement("SELECT SUM(ImportoTotale) as revenue FROM " + TABLE_NAME);
			rs = preparedStatement.executeQuery();
			if (rs.next()) {
				stats.addProperty("totalRevenue", rs.getBigDecimal("revenue"));
			}
			preparedStatement.close();
			
			// Ordini in elaborazione
			preparedStatement = connection.prepareStatement("SELECT COUNT(*) as pending FROM " + TABLE_NAME + " WHERE Stato = 'Elaborazione'");
			rs = preparedStatement.executeQuery();
			if (rs.next()) {
				stats.addProperty("pendingOrders", rs.getInt("pending"));
			}
			preparedStatement.close();
			
			// Ordini completati
			preparedStatement = connection.prepareStatement("SELECT COUNT(*) as completed FROM " + TABLE_NAME + " WHERE Stato = 'Ricevuto'");
			rs = preparedStatement.executeQuery();
			if (rs.next()) {
				stats.addProperty("completedOrders", rs.getInt("completed"));
			}
			
		} finally {
			try {
				if (preparedStatement != null) preparedStatement.close();
			} finally {
				if (connection != null) connection.close();
			}
		}
		
		return stats;
	}

	/**
	 * Versione pubblica di doRetrieveProductsInOrder per uso admin
	 */
	public synchronized LinkedList<ProductBean> doRetrieveOrderProducts(int orderId) throws SQLException {
		return doRetrieveProductsInOrder(orderId);
	}

	/**
	 * Conta il numero totale di ordini (per paginazione)
	 */
	public synchronized int countOrders(String userFilter, String statusFilter) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		int count = 0;

		String query = "SELECT COUNT(*) as total FROM " + TABLE_NAME + " O";
		boolean hasUserFilter = userFilter != null && !userFilter.trim().isEmpty();
		boolean hasStatusFilter = statusFilter != null && !statusFilter.trim().isEmpty();
		
		if (hasUserFilter) {
			query += " JOIN effettua E ON O.IDOrdine = E.IDOrdine";
		}
		
		if (hasUserFilter || hasStatusFilter) {
			query += " WHERE ";
			if (hasUserFilter) {
				query += "E.Username = ?";
				if (hasStatusFilter) query += " AND ";
			}
			if (hasStatusFilter) {
				query += "O.Stato = ?";
			}
		}

		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(query);
			
			int paramIndex = 1;
			if (hasUserFilter) {
				preparedStatement.setString(paramIndex++, userFilter.trim());
			}
			if (hasStatusFilter) {
				preparedStatement.setString(paramIndex, statusFilter.trim());
			}
			
			ResultSet rs = preparedStatement.executeQuery();
			if (rs.next()) {
				count = rs.getInt("total");
			}
		} finally {
			try {
				if (preparedStatement != null) preparedStatement.close();
			} finally {
				if (connection != null) connection.close();
			}
		}
		
		return count;
	}

	/**
	 * Aggiorna lo stato di un ordine
	 */
	public synchronized boolean doUpdate(Order order) throws SQLException {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		int result = 0;

		String updateSQL = "UPDATE " + TABLE_NAME + " SET Stato = ? WHERE IDOrdine = ?";

		try {
			connection = ds.getConnection();
			preparedStatement = connection.prepareStatement(updateSQL);
			preparedStatement.setString(1, order.getStato());
			preparedStatement.setInt(2, order.getIDOrdine());

			result = preparedStatement.executeUpdate();
			connection.commit();
		} finally {
			try {
				if (preparedStatement != null) preparedStatement.close();
			} finally {
				if (connection != null) connection.close();
			}
		}
		
		return (result != 0);
	}




}
