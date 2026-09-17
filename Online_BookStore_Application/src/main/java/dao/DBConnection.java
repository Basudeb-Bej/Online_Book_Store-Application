//java/DAO/DBConnection.java
package dao;

import java.sql.*;

public class DBConnection {
	public static Connection getConnection() {
		Connection con = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			String url = System.getProperty("bookstore.db.url",
					System.getenv().getOrDefault("BOOKSTORE_DB_URL", "jdbc:mysql://localhost:3306/bookstore"));

			String user = System.getProperty("bookstore.db.user",
					System.getenv().getOrDefault("BOOKSTORE_DB_USER", "root"));

			String password = System.getProperty("bookstore.db.password", System.getenv().get("BOOKSTORE_DB_PASSWORD"));

			con = DriverManager.getConnection(url, user, password);

			if (con != null) {
				System.out.println("Database Connected Successfully");
			}

		} catch (Exception e) {
			System.out.println("Database NOT connected: " + e.getMessage());
			e.printStackTrace();
		}
		return con;
	}
}



