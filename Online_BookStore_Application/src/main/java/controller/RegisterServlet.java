package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/RegisterServlet")

public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String name =
                request.getParameter("name");

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        if(!email.contains("@")) {

            request.setAttribute(
                    "error",
                    "Invalid Email");

            RequestDispatcher rd =
                    request.getRequestDispatcher(
                            "/jsp/error.jsp");

            rd.forward(request, response);

        } else if(password.length() < 6) {

            request.setAttribute(
                    "error",
                    "Password must contain at least 6 characters");

            RequestDispatcher rd =
                    request.getRequestDispatcher(
                            "/jsp/error.jsp");

            rd.forward(request, response);

        } else {
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            UserDAO dao = new UserDAO();
            boolean status = dao.registerUser(user);

            if(status) {
                response.sendRedirect("jsp/login.jsp");
            } else {
                response.getWriter().println("Registration Failed");
            }
        }
    }
}