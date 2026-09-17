package controller;

import dao.BookDAO;
import model.Book;
import util.FileUploadUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;

@WebServlet("/EditBookServlet")
@MultipartConfig
public class EditBookServlet extends HttpServlet {

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

    private Book buildBookFromRequest(HttpServletRequest request) {
        Book book = new Book();

        String idParam = request.getParameter("id");
        String priceParam = request.getParameter("price");
        String quantityParam = request.getParameter("quantity");
        String existingImage = request.getParameter("existingImage");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                book.setId(Integer.parseInt(idParam.trim()));
            } catch (NumberFormatException ignored) {
                book.setId(0);
            }
        }

        book.setTitle(request.getParameter("title") != null ? request.getParameter("title").trim() : "");
        book.setAuthor(request.getParameter("author") != null ? request.getParameter("author").trim() : "");
        book.setCategory(request.getParameter("category") != null ? request.getParameter("category").trim() : "");
        book.setDescription(request.getParameter("description") != null ? request.getParameter("description").trim() : "");

        String imageName = existingImage != null ? existingImage.trim() : "";

        try {
            Part imagePart = request.getPart("imageFile");
            String uploaded = FileUploadUtil.saveImage(request.getServletContext(), imagePart);
            if (uploaded != null) {
                imageName = uploaded;
            }
        } catch (Exception ignored) {
            // keep existing image if upload is missing or invalid
        }

        book.setImage(imageName);

        if (priceParam != null && !priceParam.trim().isEmpty()) {
            try {
                book.setPrice(Double.parseDouble(priceParam.trim()));
            } catch (NumberFormatException ignored) {
                book.setPrice(0.0);
            }
        }

        int quantity = 1;
        if (quantityParam != null && !quantityParam.trim().isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityParam.trim());
            } catch (NumberFormatException ignored) {
                quantity = 1;
            }
        }

        book.setQuantity(Math.max(0, quantity));

        return book;
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
        Book book = dao.getBookById(id);

        if (book == null) {
            request.getSession().setAttribute("error", "Book not found.");
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
            return;
        }

        request.setAttribute("book", book);

        RequestDispatcher rd = request.getRequestDispatcher("/jsp/AdminDashboard/edit-book.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        Book book = buildBookFromRequest(request);

        if (book.getId() <= 0 || book.getTitle().trim().isEmpty() ||
                book.getAuthor().trim().isEmpty()) {
            request.setAttribute("error", "Book ID, title, and author are required.");
            request.setAttribute("book", book);
            RequestDispatcher rd = request.getRequestDispatcher("/jsp/AdminDashboard/edit-book.jsp");
            rd.forward(request, response);
            return;
        }

        BookDAO dao = new BookDAO();
        boolean status = dao.updateBook(book);

        if (status) {
            request.getSession().setAttribute("success", "Book updated successfully.");
        } else {
            request.getSession().setAttribute("error", "Unable to update book right now.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminServlet");
    }
}