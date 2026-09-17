package dao;

import model.Book;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SaleDAO {

    private void ensureSalesTable(Connection con) throws SQLException {
        if (con == null) {
            return;
        }

        String sql = "CREATE TABLE IF NOT EXISTS sales ("
                + "id INT PRIMARY KEY AUTO_INCREMENT, "
                + "book_id INT NOT NULL, "
                + "book_title VARCHAR(255) NOT NULL, "
                + "buyer_name VARCHAR(200), "
                + "buyer_email VARCHAR(200), "
                + "quantity INT NOT NULL, "
                + "unit_price DECIMAL(10,2) NOT NULL, "
                + "total_amount DECIMAL(10,2) NOT NULL, "
                + "purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                + ")";

        try (Statement statement = con.createStatement()) {
            statement.executeUpdate(sql);
        }
    }

    public boolean recordSale(Book book, int quantity, String buyerName, String buyerEmail) {
        if (book == null || quantity <= 0) {
            return false;
        }

        String sql = "INSERT INTO sales (book_id, book_title, buyer_name, buyer_email, quantity, unit_price, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return false;
            }

            ensureSalesTable(con);

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, book.getId());
                ps.setString(2, book.getTitle());
                ps.setString(3, buyerName != null ? buyerName.trim() : "");
                ps.setString(4, buyerEmail != null ? buyerEmail.trim() : "");
                ps.setInt(5, quantity);
                ps.setBigDecimal(6, BigDecimal.valueOf(book.getPrice()));
                ps.setBigDecimal(7, BigDecimal.valueOf(book.getPrice()).multiply(BigDecimal.valueOf(quantity)));

                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean recordSales(List<Book> books, String buyerName, String buyerEmail) {
        if (books == null || books.isEmpty()) {
            return false;
        }

        String sql = "INSERT INTO sales (book_id, book_title, buyer_name, buyer_email, quantity, unit_price, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return false;
            }

            ensureSalesTable(con);
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                for (Book book : books) {
                    if (book == null || book.getQuantity() <= 0) {
                        continue;
                    }

                    int quantity = book.getQuantity();
                    ps.setInt(1, book.getId());
                    ps.setString(2, book.getTitle());
                    ps.setString(3, buyerName != null ? buyerName.trim() : "");
                    ps.setString(4, buyerEmail != null ? buyerEmail.trim() : "");
                    ps.setInt(5, quantity);
                    ps.setBigDecimal(6, BigDecimal.valueOf(book.getPrice()));
                    ps.setBigDecimal(7, BigDecimal.valueOf(book.getPrice()).multiply(BigDecimal.valueOf(quantity)));
                    ps.addBatch();
                }

                int[] results = ps.executeBatch();
                con.commit();

                return results.length > 0;
            } catch (Exception e) {
                try {
                    con.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
                throw e;
            } finally {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException ignored) {
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Book> getPurchasedBooksByBuyerEmail(String buyerEmail) {
        List<Book> purchasedBooks = new ArrayList<>();

        if (buyerEmail == null || buyerEmail.trim().isEmpty()) {
            return purchasedBooks;
        }

        String sql = "SELECT s.book_id, s.book_title, s.quantity, s.unit_price, s.purchased_at, "
                + "COALESCE(b.author,'') AS author, "
                + "COALESCE(b.category,'') AS category, "
                + "COALESCE(b.description,'') AS description, "
                + "COALESCE(b.image,'') AS image "
                + "FROM sales s "
                + "LEFT JOIN books b ON b.id = s.book_id "
                + "WHERE s.buyer_email = ? "
                + "ORDER BY s.purchased_at DESC, s.id DESC";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return purchasedBooks;
            }

            ensureSalesTable(con);

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, buyerEmail.trim());

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Book book = new Book();
                        book.setId(rs.getInt("book_id"));
                        book.setTitle(rs.getString("book_title"));
                        book.setAuthor(rs.getString("author"));
                        book.setCategory(rs.getString("category"));
                        book.setDescription(rs.getString("description"));
                        book.setImage(rs.getString("image"));
                        book.setPrice(rs.getBigDecimal("unit_price").doubleValue());
                        book.setQuantity(rs.getInt("quantity"));
                        book.setPurchasedAt(rs.getString("purchased_at"));
                        purchasedBooks.add(book);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return purchasedBooks;
    }
}
