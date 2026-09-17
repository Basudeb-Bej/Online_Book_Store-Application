package controller;

import dao.AdminProfileDAO;
import dao.AdminStatsDAO;
import dao.BookDAO;
import model.Book;
import model.AdminProfile;
import util.FileUploadUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;

import java.io.IOException;
import java.io.UncheckedIOException;
import jakarta.servlet.http.Part;

@WebServlet("/AdminServlet")
@MultipartConfig

public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private Integer resolveUserId(HttpSession session) {

        if (session == null) {
            return null;
        }

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj instanceof Integer) {
            return (Integer) userIdObj;
        }

        if (userIdObj instanceof String) {
            try {
                return Integer.parseInt(((String) userIdObj).trim());
            } catch (NumberFormatException ignored) {
            }
        }

        return null;
    }

    private void loadDashboardData(HttpServletRequest request) {

        loadDashboardData(request, null);
    }

    private void loadDashboardData(HttpServletRequest request, String keyword) {

        BookDAO bookDAO = new BookDAO();
        AdminStatsDAO statsDAO = new AdminStatsDAO();
        AdminProfileDAO profileDAO = new AdminProfileDAO();
        HttpSession session = request.getSession(false);

        if (keyword == null || keyword.trim().isEmpty()) {
            request.setAttribute("bookList", bookDAO.getAllBooks());
            request.setAttribute("searchKeyword", "");
        } else {
            request.setAttribute("bookList", bookDAO.searchBooks(keyword));
            request.setAttribute("searchKeyword", keyword.trim());
        }

        request.setAttribute("totalUsers", statsDAO.getTotalUsers());
        request.setAttribute("totalBooks", statsDAO.getTotalBooks());
        request.setAttribute("totalSales", statsDAO.getTotalSales());
        request.setAttribute("totalRevenue", statsDAO.getTotalRevenue());

        Integer userId = resolveUserId(session);
        AdminProfile profile = userId != null ? profileDAO.getProfileByUserId(userId) : null;
        request.setAttribute("adminProfile", profile);
    }

    // LOAD ADMIN PAGE + BOOK LIST

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // SESSION SECURITY: redirect to login if no valid admin session
        if (session == null || session.getAttribute("role") == null ||
                !"admin".equals(session.getAttribute("role"))) {

            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String keyword = request.getParameter("keyword");
        loadDashboardData(request, keyword);

        RequestDispatcher rd =
                request.getRequestDispatcher(
                        "/jsp/AdminDashboard/admin.jsp");

        rd.forward(request, response);
    }

    // ADD NEW BOOK

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        // ensure request encoding supports UTF-8 form data
        request.setCharacterEncoding("UTF-8");

        // SESSION SECURITY: only admin can add books
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String priceParam = request.getParameter("price");
        String quantityParam = request.getParameter("quantity");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        Part imagePart = request.getPart("imageFile");

        // basic validation
        if (title == null || title.trim().isEmpty() ||
                author == null || author.trim().isEmpty() ||
                priceParam == null || priceParam.trim().isEmpty()) {

            request.setAttribute("error", "Title, Author, and Price are required.");

            // reload dashboard data for the admin page
            loadDashboardData(request);

            RequestDispatcher rd = request.getRequestDispatcher("/jsp/AdminDashboard/admin.jsp");
            rd.forward(request, response);
            return;
        }

        double price = 0.0;
        if (priceParam != null && !priceParam.trim().isEmpty()) {
            try {
                price = Double.parseDouble(priceParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Price must be a valid number.");

                loadDashboardData(request);

                RequestDispatcher rd = request.getRequestDispatcher("/jsp/AdminDashboard/admin.jsp");
                rd.forward(request, response);
                return;
            }
        }

        int quantity = 1;
        if (quantityParam != null && !quantityParam.trim().isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityParam.trim());
            } catch (Exception e) {
                quantity = 1;
            }
        }

        quantity = Math.max(0, quantity);

        Book book = new Book();
        book.setTitle(title.trim());
        book.setAuthor(author.trim());
        book.setPrice(price);
        book.setQuantity(quantity);
        book.setCategory(category != null ? category.trim() : "");
        book.setDescription(description != null ? description.trim() : "");

        try {
            String storedImage = FileUploadUtil.saveImage(getServletContext(), imagePart);
            book.setImage(storedImage != null ? storedImage : "");
        } catch (IOException e) {
            request.setAttribute("error", "Unable to upload book image.");
            loadDashboardData(request);
            RequestDispatcher rd = request.getRequestDispatcher("/jsp/AdminDashboard/admin.jsp");
            rd.forward(request, response);
            return;
        }

        BookDAO dao = new BookDAO();
        boolean status = dao.addBook(book);

        if (status) {
            request.getSession().setAttribute("success", "Book added successfully.");
        } else {
            request.getSession().setAttribute("error", "Unable to add book right now.");
        }

        // redirect back to the admin page (use context path)
        response.sendRedirect(request.getContextPath() + "/AdminServlet");
    }
}