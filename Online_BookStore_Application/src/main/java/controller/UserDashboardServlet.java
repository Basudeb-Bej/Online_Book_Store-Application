package controller;

import dao.BookDAO;
import model.Book;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class UserDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        if ("admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
            return;
        }

        BookDAO bookDAO = new BookDAO();
        List<Book> allBooks = bookDAO.getAllBooks();

        int featuredLimit = Math.min(6, allBooks.size());
        List<Book> featuredBooks = new ArrayList<>(allBooks.subList(0, featuredLimit));

        int cartCount = 0;
        @SuppressWarnings("unchecked")
        List<Book> cartBooks = (List<Book>) session.getAttribute("cartBooks");
        if (cartBooks != null) {
            for (Book book : cartBooks) {
                if (book != null) {
                    cartCount += Math.max(0, book.getQuantity());
                }
            }
        }

        if (cartCount == 0) {
            Object legacyCart = session.getAttribute("cart");
            if (legacyCart instanceof List<?>) {
                cartCount = ((List<?>) legacyCart).size();
            }
        }

        request.setAttribute("allBooks", allBooks);
        request.setAttribute("featuredBooks", featuredBooks);
        request.setAttribute("cartCount", cartCount);
        request.setAttribute("booksCount", allBooks.size());

        RequestDispatcher rd = request.getRequestDispatcher("/jsp/UserDashboard/user.jsp");
        rd.forward(request, response);
    }
}
