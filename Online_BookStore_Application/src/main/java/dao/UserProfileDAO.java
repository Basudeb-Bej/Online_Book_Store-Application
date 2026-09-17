package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserProfileDAO {

    private void ensureTable(Connection con) throws SQLException {
        String sql = "CREATE TABLE IF NOT EXISTS user_profiles ("
                + "user_id INT PRIMARY KEY,"
                + "image VARCHAR(255),"
                + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"
                + ")";

        try (Statement stmt = con.createStatement()) {
            stmt.executeUpdate(sql);
        }
    }

    public String getImageByUserId(int userId) {
        if (userId <= 0) {
            return null;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return null;
            }

            ensureTable(con);

            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COALESCE(image,'') AS image FROM user_profiles WHERE user_id=?")) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String image = rs.getString("image");
                        return image != null && !image.trim().isEmpty() ? image.trim() : null;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean saveOrUpdateImage(int userId, String image) {
        if (userId <= 0) {
            return false;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return false;
            }

            ensureTable(con);

            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO user_profiles(user_id, image) VALUES(?, ?) "
                            + "ON DUPLICATE KEY UPDATE image=VALUES(image), updated_at=CURRENT_TIMESTAMP")) {
                ps.setInt(1, userId);
                ps.setString(2, image != null ? image.trim() : "");
                return ps.executeUpdate() >= 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
