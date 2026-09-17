package dao;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import model.Book;

public class BookDAO {

    private boolean hasColumn(Connection con, String tableName, String columnName) throws SQLException {
        DatabaseMetaData metaData = con.getMetaData();

        try (ResultSet rs = metaData.getColumns(con.getCatalog(), null, tableName, "%")) {
            while (rs.next()) {
                String existing = rs.getString("COLUMN_NAME");
                if (existing != null && existing.equalsIgnoreCase(columnName)) {
                    return true;
                }
            }
        }

        return false;
    }

    private String normalizeImageUrl(String image) {
        if (image == null || image.trim().isEmpty()) {
            return "";
        }

        String normalized = image.trim().replace("\\", "/");

        if (normalized.startsWith("http://") || normalized.startsWith("https://") || normalized.startsWith("data:")) {
            return normalized;
        }

        if (normalized.startsWith("/images/")) {
            return normalized;
        }

        if (normalized.startsWith("images/")) {
            return "/" + normalized;
        }

        int lastSlash = normalized.lastIndexOf('/');
        if (lastSlash >= 0) {
            normalized = normalized.substring(lastSlash + 1);
        }

        return normalized.isEmpty() ? "" : "/images/" + normalized;
    }

    public boolean decreaseQuantity(int bookId, int amount) {
        if (amount <= 0) {
            return false;
        }

        String sql = "UPDATE books SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null || !hasColumn(con, "books", "quantity")) {
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, amount);
                ps.setInt(2, bookId);
                ps.setInt(3, amount);

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    public boolean increaseQuantity(int bookId, int amount) {
        if (amount <= 0) {
            return false;
        }

        String sql = "UPDATE books SET quantity = quantity + ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null || !hasColumn(con, "books", "quantity")) {
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, amount);
                ps.setInt(2, bookId);

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    private Book mapBook(ResultSet rs, boolean hasImage, boolean hasQuantity) throws SQLException {
        Book b = new Book();

        b.setId(rs.getInt("id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setPrice(rs.getDouble("price"));
        b.setCategory(rs.getString("category"));
        b.setDescription(rs.getString("description"));

        if (hasQuantity) {
            int quantity = rs.getInt("quantity");
            b.setQuantity(rs.wasNull() ? 1 : quantity);
        } else {
            b.setQuantity(1);
        }

        if (hasImage) {
            String image = rs.getString("image");
            b.setImage(image);
            b.setImageUrl(normalizeImageUrl(image));
        } else {
            b.setImage("");
            b.setImageUrl("");
        }

        return b;
    }

    // GET ALL BOOKS

    public List<Book> getAllBooks() {

        List<Book> list =
                new ArrayList<Book>();

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return list;
            }

            boolean hasImage = hasColumn(con, "books", "image");
            boolean hasQuantity = hasColumn(con, "books", "quantity");

            String sql = "SELECT id,title,author,price,category,description"
                    + (hasQuantity ? ",quantity" : "")
                    + (hasImage ? ",image" : "")
                    + " FROM books ORDER BY id ASC";

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapBook(rs, hasImage, hasQuantity));
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    // SEARCH BOOKS

    public List<Book> searchBooks(String keyword) {

        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllBooks();
        }

        List<Book> list = new ArrayList<Book>();

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return list;
            }

            boolean hasImage = hasColumn(con, "books", "image");
            boolean hasQuantity = hasColumn(con, "books", "quantity");

            String sql = "SELECT id,title,author,price,category,description"
                    + (hasQuantity ? ",quantity" : "")
                    + (hasImage ? ",image" : "")
                    + " FROM books "
                    + "WHERE COALESCE(title,'') LIKE ? OR COALESCE(author,'') LIKE ? OR COALESCE(category,'') LIKE ? "
                    + "ORDER BY id ASC";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                String term = "%" + keyword.trim() + "%";
                ps.setString(1, term);
                ps.setString(2, term);
                ps.setString(3, term);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(mapBook(rs, hasImage, hasQuantity));
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    // ADD BOOK

    public boolean addBook(Book b) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return false;
            }

            boolean hasImage = hasColumn(con, "books", "image");
            boolean hasQuantity = hasColumn(con, "books", "quantity");

            StringBuilder sql = new StringBuilder("INSERT INTO books(title,author,price,category,description");
            if (hasQuantity) {
                sql.append(",quantity");
            }
            if (hasImage) {
                sql.append(",image");
            }
            sql.append(") VALUES(?,?,?,?,?");
            if (hasQuantity) {
                sql.append(",?");
            }
            if (hasImage) {
                sql.append(",?");
            }
            sql.append(")");

            try (PreparedStatement ps = con.prepareStatement(sql.toString())) {

                ps.setString(1, b.getTitle());
                ps.setString(2, b.getAuthor());
                ps.setDouble(3, b.getPrice());
                ps.setString(4, b.getCategory());
                ps.setString(5, b.getDescription());

                int index = 6;

                if (hasQuantity) {
                    ps.setInt(index++, b.getQuantity());
                }

                if (hasImage) {
                    ps.setString(index++, b.getImage());
                }

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    status = true;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return status;
    }

    // DELETE BOOK

    public boolean deleteBook(int id) {

        boolean status = false;

        String sql = "DELETE FROM books WHERE id=?";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    status = true;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return status;
    }

    // GET BOOK BY ID

    public Book getBookById(int id) {

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return null;
            }

            boolean hasImage = hasColumn(con, "books", "image");
            boolean hasQuantity = hasColumn(con, "books", "quantity");

            String sql = "SELECT id,title,author,price,category,description"
                    + (hasQuantity ? ",quantity" : "")
                    + (hasImage ? ",image" : "")
                    + " FROM books WHERE id=?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapBook(rs, hasImage, hasQuantity);
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    // UPDATE BOOK

    public boolean updateBook(Book b) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return false;
            }

            boolean hasImage = hasColumn(con, "books", "image");
            boolean hasQuantity = hasColumn(con, "books", "quantity");

            StringBuilder sql = new StringBuilder("UPDATE books SET title=?,author=?,price=?,category=?,description=?");
            if (hasQuantity) {
                sql.append(",quantity=?");
            }
            if (hasImage) {
                sql.append(",image=?");
            }
            sql.append(" WHERE id=?");

            try (PreparedStatement ps = con.prepareStatement(sql.toString())) {

                ps.setString(1, b.getTitle());
                ps.setString(2, b.getAuthor());
                ps.setDouble(3, b.getPrice());
                ps.setString(4, b.getCategory());
                ps.setString(5, b.getDescription());

                int index = 6;

                if (hasQuantity) {
                    ps.setInt(index++, b.getQuantity());
                }

                if (hasImage) {
                    ps.setString(index++, b.getImage());
                } else {
                    // no image column available
                }

                ps.setInt(index, b.getId());

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    status = true;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return status;
    }
}