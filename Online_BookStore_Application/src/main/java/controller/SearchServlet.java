package controller;

import dao.BookDAO;
import model.Book;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SearchServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

	protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String keyword =
                request.getParameter("keyword");

        if (keyword == null) {
            keyword = "";
        }

        keyword = keyword.trim();

        BookDAO dao = new BookDAO();

        List<Book> books =
                dao.searchBooks(keyword);

        request.setAttribute("bookList", books);
        request.setAttribute("keyword", keyword);

        RequestDispatcher rd =
                request.getRequestDispatcher(
                        "/jsp/UserDashboard/books.jsp");

        rd.forward(request, response);
    }
}