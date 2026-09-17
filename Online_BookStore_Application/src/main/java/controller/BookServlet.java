package controller;

import dao.BookDAO;
import model.Book;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

public class BookServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
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

        BookDAO dao = new BookDAO();

        List<Book> books = dao.getAllBooks();

        int cartCount = 0;
        Object cartCountAttr = session.getAttribute("cartCount");
        if (cartCountAttr instanceof Integer) {
            cartCount = (Integer) cartCountAttr;
        } else {
            @SuppressWarnings("unchecked")
            List<Book> cartBooks = (List<Book>) session.getAttribute("cartBooks");
            if (cartBooks != null) {
                for (Book book : cartBooks) {
                    if (book != null) {
                        cartCount += Math.max(0, book.getQuantity());
                    }
                }
            }
        }

        int myBookCount = 0;
        Object myBookCountAttr = session.getAttribute("myBookCount");
        if (myBookCountAttr instanceof Integer) {
            myBookCount = (Integer) myBookCountAttr;
        } else {
            @SuppressWarnings("unchecked")
            List<Book> myBooks = (List<Book>) session.getAttribute("myBooks");
            if (myBooks != null) {
                for (Book book : myBooks) {
                    if (book != null) {
                        myBookCount += Math.max(0, book.getQuantity());
                    }
                }
            }
        }

        request.setAttribute("bookList", books);
        request.setAttribute("cartCount", cartCount);
        request.setAttribute("myBookCount", myBookCount);

        RequestDispatcher rd =
                request.getRequestDispatcher("/jsp/UserDashboard/books.jsp");

        rd.forward(request, response);
    }
}