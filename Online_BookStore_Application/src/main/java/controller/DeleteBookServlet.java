package controller;

import dao.BookDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/DeleteBookServlet")
public class DeleteBookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null ||
                !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return false;
        }

        return true;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");
        int id;

        try {
            id = Integer.parseInt(idParam);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Invalid book id.");
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
            return;
        }

        BookDAO dao = new BookDAO();
        boolean status = dao.deleteBook(id);

        if (status) {
            request.getSession().setAttribute("success", "Book deleted successfully.");
        } else {
            request.getSession().setAttribute("error", "Unable to delete book right now.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminServlet");
    }
}