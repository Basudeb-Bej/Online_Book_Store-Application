package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import model.User;

public class UserDAO {

    Connection con =
            DBConnection.getConnection();

    public boolean registerUser(User user) {

        boolean status = false;

        try {

            String sql =
            "INSERT INTO users(name,email,password) VALUES(?,?,?)";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, user.getName());

            ps.setString(2, user.getEmail());

            ps.setString(3, user.getPassword());

            int rows = ps.executeUpdate();

            if(rows > 0) {

                status = true;
            }

        } catch(Exception e) {

            e.printStackTrace();
        }

        return status;
    }
}