package dao;

import model.AdminProfile;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class AdminProfileDAO {

    private void ensureTable(Connection con) throws SQLException {
        String sql = "CREATE TABLE IF NOT EXISTS admin_profiles ("
                + "user_id INT PRIMARY KEY,"
                + "phone VARCHAR(50),"
                + "address VARCHAR(255),"
                + "image VARCHAR(255),"
                + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"
                + ")";

        try (Statement stmt = con.createStatement()) {
            stmt.executeUpdate(sql);
        }
    }

    public AdminProfile getProfileByUserId(int userId) {
        if (userId <= 0) {
            return null;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return null;
            }

            ensureTable(con);

            String sql = "SELECT u.id, u.name, u.email, u.password, "
                    + "COALESCE(p.phone,'') AS phone, "
                    + "COALESCE(p.address,'') AS address, "
                    + "COALESCE(p.image,'') AS image "
                    + "FROM users u "
                    + "LEFT JOIN admin_profiles p ON u.id = p.user_id "
                    + "WHERE u.id = ? AND COALESCE(u.role,'') = 'admin'";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        AdminProfile profile = new AdminProfile();
                        profile.setUserId(rs.getInt("id"));
                        profile.setName(rs.getString("name"));
                        profile.setEmail(rs.getString("email"));
                        profile.setPassword(rs.getString("password"));
                        profile.setPhone(rs.getString("phone"));
                        profile.setAddress(rs.getString("address"));
                        profile.setImage(rs.getString("image"));
                        return profile;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean saveOrUpdateProfile(AdminProfile profile) {
        if (profile == null || profile.getUserId() <= 0) {
            return false;
        }

        Connection con = null;
        boolean previousAutoCommit = true;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                return false;
            }

            previousAutoCommit = con.getAutoCommit();
            con.setAutoCommit(false);
            ensureTable(con);

            try (PreparedStatement userStmt = con.prepareStatement(
                    "UPDATE users SET name=?, email=?, password=? WHERE id=? AND COALESCE(role,'')='admin'")) {
                userStmt.setString(1, profile.getName());
                userStmt.setString(2, profile.getEmail());
                userStmt.setString(3, profile.getPassword());
                userStmt.setInt(4, profile.getUserId());
                userStmt.executeUpdate();
            }

            try (PreparedStatement profileStmt = con.prepareStatement(
                    "INSERT INTO admin_profiles(user_id, phone, address, image) VALUES(?,?,?,?) "
                            + "ON DUPLICATE KEY UPDATE phone=VALUES(phone), address=VALUES(address), image=VALUES(image), updated_at=CURRENT_TIMESTAMP")) {
                profileStmt.setInt(1, profile.getUserId());
                profileStmt.setString(2, profile.getPhone());
                profileStmt.setString(3, profile.getAddress());
                profileStmt.setString(4, profile.getImage());
                profileStmt.executeUpdate();
            }

            con.commit();
            return true;
        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ignored) {
                }
            }
            e.printStackTrace();
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(previousAutoCommit);
                    con.close();
                } catch (SQLException ignored) {
                }
            }
        }

        return false;
    }
}
