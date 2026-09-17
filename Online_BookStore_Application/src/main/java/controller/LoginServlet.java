package controller;

import dao.DBConnection;
import dao.UserProfileDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")

public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        try {

            Connection con =
                    DBConnection.getConnection();

            String sql =
            "SELECT * FROM users WHERE email=? AND password=?";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, email);

            ps.setString(2, password);

            ResultSet rs =
                    ps.executeQuery();

            if(rs.next()) {

                HttpSession session =
                        request.getSession();

                session.setAttribute(
                        "userId",
                        rs.getInt("id"));

                session.setAttribute(
                        "user",
                        rs.getString("name"));

                session.setAttribute(
                        "email",
                        rs.getString("email"));

                session.setAttribute(
                        "role",
                        rs.getString("role"));

                UserProfileDAO profileDAO = new UserProfileDAO();
                String profileImage = profileDAO.getImageByUserId(rs.getInt("id"));
                session.setAttribute("profileImage", profileImage != null ? profileImage : "");

                String role =
                        rs.getString("role");

                // ADMIN LOGIN
                if(role.equals("admin")) {

                    response.sendRedirect(
                            request.getContextPath() + "/AdminServlet");

                }

                // USER LOGIN
                else {

                    response.sendRedirect(
                            request.getContextPath() + "/dashboard");

                }

            } else {

                request.setAttribute(
                        "error",
                        "Invalid Email or Password");

                RequestDispatcher rd =
                        request.getRequestDispatcher(
                                "/jsp/login.jsp");

                rd.forward(request, response);
            }

        } catch(Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Database Error");

            RequestDispatcher rd =
                    request.getRequestDispatcher(
                            "/jsp/error.jsp");

            rd.forward(request, response);
        }
    }
}