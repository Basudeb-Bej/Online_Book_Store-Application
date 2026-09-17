package controller;

import dao.BookDAO;
import dao.SaleDAO;
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

public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @SuppressWarnings("unchecked")
    private List<Book> getCartBooks(HttpSession session, boolean migrateLegacy) {
        List<Book> cartBooks = (List<Book>) session.getAttribute("cartBooks");

        if (cartBooks == null) {
            cartBooks = new ArrayList<>();

            if (migrateLegacy) {
                Object legacyCart = session.getAttribute("cart");
                if (legacyCart instanceof List<?>) {
                    BookDAO bookDAO = new BookDAO();
                    List<Book> allBooks = bookDAO.getAllBooks();

                    for (Object item : (List<?>) legacyCart) {
                        Book book = resolveBook(allBooks, item != null ? item.toString() : null);
                        if (book != null) {
                            book.setQuantity(1);
                            cartBooks.add(book);
                        }
                    }
                }
            }

            session.setAttribute("cartBooks", cartBooks);
        }

        return cartBooks;
    }

    private int getCartQuantity(List<Book> cartBooks) {
        int total = 0;

        if (cartBooks != null) {
            for (Book book : cartBooks) {
                if (book != null) {
                    total += Math.max(0, book.getQuantity());
                }
            }
        }

        return total;
    }

    private Book copyForCart(Book source) {
        if (source == null) {
            return null;
        }

        Book copy = new Book();
        copy.setId(source.getId());
        copy.setTitle(source.getTitle());
        copy.setAuthor(source.getAuthor());
        copy.setPrice(source.getPrice());
        copy.setCategory(source.getCategory());
        copy.setDescription(source.getDescription());
        copy.setImage(source.getImage());
        copy.setImageUrl(source.getImageUrl());
        copy.setQuantity(1);
        return copy;
    }

    private Book copyForPurchased(Book source, int quantity) {
        if (source == null) {
            return null;
        }

        Book copy = new Book();
        copy.setId(source.getId());
        copy.setTitle(source.getTitle());
        copy.setAuthor(source.getAuthor());
        copy.setPrice(source.getPrice());
        copy.setCategory(source.getCategory());
        copy.setDescription(source.getDescription());
        copy.setImage(source.getImage());
        copy.setImageUrl(source.getImageUrl());
        copy.setQuantity(Math.max(1, quantity));
        return copy;
    }

    private Book findCartBookById(List<Book> cartBooks, int bookId) {
        if (cartBooks == null) {
            return null;
        }

        for (Book book : cartBooks) {
            if (book != null && book.getId() == bookId) {
                return book;
            }
        }

        return null;
    }

    private Book resolveBook(List<Book> books, String token) {
        if (books == null || token == null || token.trim().isEmpty()) {
            return null;
        }

        String value = token.trim();

        try {
            int id = Integer.parseInt(value);
            for (Book book : books) {
                if (book != null && book.getId() == id) {
                    return book;
                }
            }
        } catch (NumberFormatException ignored) {
            // fall through to title matching
        }

        for (Book book : books) {
            if (book != null && book.getTitle() != null && book.getTitle().equalsIgnoreCase(value)) {
                return book;
            }
        }

        return null;
    }

    private void syncLegacyCart(HttpSession session, List<Book> cartBooks) {
        List<String> legacyTitles = new ArrayList<>();

        if (cartBooks != null) {
            for (Book book : cartBooks) {
                if (book != null && book.getTitle() != null) {
                    int quantity = Math.max(1, book.getQuantity());
                    book.setQuantity(quantity);

                    for (int i = 0; i < quantity; i++) {
                        legacyTitles.add(book.getTitle());
                    }
                }
            }
        }

        session.setAttribute("cart", legacyTitles);
        session.setAttribute("cartBooks", cartBooks != null ? cartBooks : new ArrayList<Book>());
        session.setAttribute("cartCount", getCartQuantity(cartBooks));
    }

    @SuppressWarnings("unchecked")
    private List<Book> getPurchasedBooks(HttpSession session, SaleDAO saleDAO) {
        List<Book> purchasedBooks = new ArrayList<>();

        if (session != null && saleDAO != null) {
            String buyerEmail = resolveBuyerEmail(session);
            if (buyerEmail != null && !buyerEmail.trim().isEmpty()) {
                List<Book> dbPurchasedBooks = saleDAO.getPurchasedBooksByBuyerEmail(buyerEmail);
                if (dbPurchasedBooks != null) {
                    for (Book book : dbPurchasedBooks) {
                        if (book != null) {
                            mergePurchasedBook(purchasedBooks, book, Math.max(1, book.getQuantity()));
                        }
                    }
                }
            }
        } else if (session != null) {
            Object existingPurchased = session.getAttribute("myBooks");
            if (existingPurchased instanceof List<?>) {
                for (Object item : (List<?>) existingPurchased) {
                    if (item instanceof Book) {
                        purchasedBooks.add((Book) item);
                    }
                }
            }
        }

        if (purchasedBooks == null) {
            purchasedBooks = new ArrayList<>();
        }

        purchasedBooks = aggregatePurchasedBooks(purchasedBooks);

        if (session != null) {
            session.setAttribute("myBooks", purchasedBooks);
        }

        return purchasedBooks;
    }

    private int getPurchasedQuantity(List<Book> purchasedBooks) {
        return getCartQuantity(purchasedBooks);
    }

    private Book findPurchasedBookById(List<Book> purchasedBooks, int bookId) {
        return findCartBookById(purchasedBooks, bookId);
    }

    private List<Book> aggregatePurchasedBooks(List<Book> purchasedBooks) {
        List<Book> aggregatedBooks = new ArrayList<>();

        if (purchasedBooks != null) {
            for (Book book : purchasedBooks) {
                if (book != null) {
                    mergePurchasedBook(aggregatedBooks, book, Math.max(1, book.getQuantity()));
                }
            }
        }

        return aggregatedBooks;
    }

    private void mergePurchasedBook(List<Book> purchasedBooks, Book source, int quantity) {
        if (purchasedBooks == null || source == null || quantity <= 0) {
            return;
        }

        Book purchasedBook = findPurchasedBookById(purchasedBooks, source.getId());
        if (purchasedBook == null) {
            purchasedBooks.add(copyForPurchased(source, quantity));
        } else {
            purchasedBook.setQuantity(purchasedBook.getQuantity() + quantity);
        }
    }

    private void syncPurchasedBooks(HttpSession session, List<Book> purchasedBooks) {
        session.setAttribute("myBooks", purchasedBooks != null ? purchasedBooks : new ArrayList<Book>());
        session.setAttribute("myBookCount", getPurchasedQuantity(purchasedBooks));
    }

    private void addPurchasedBook(HttpSession session, Book source, int quantity) {
        if (session == null || source == null || quantity <= 0) {
            return;
        }

        List<Book> purchasedBooks = getPurchasedBooks(session, null);
        mergePurchasedBook(purchasedBooks, source, quantity);
        syncPurchasedBooks(session, purchasedBooks);
    }

    private String resolveBuyerName(HttpSession session) {
        if (session == null) {
            return "";
        }

        Object user = session.getAttribute("user");
        return user != null ? user.toString() : "";
    }

    private String resolveBuyerEmail(HttpSession session) {
        if (session == null) {
            return "";
        }

        Object email = session.getAttribute("email");
        return email != null ? email.toString() : "";
    }

    private Book findCartBookByIndex(List<Book> cartBooks, int index) {
        if (cartBooks == null || index < 0 || index >= cartBooks.size()) {
            return null;
        }

        return cartBooks.get(index);
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private boolean hasPaymentDetails(HttpServletRequest request) {
        return request.getParameter("paymentName") != null && !request.getParameter("paymentName").trim().isEmpty()
                && request.getParameter("paymentNumber") != null && !request.getParameter("paymentNumber").trim().isEmpty()
                && request.getParameter("paymentExpiry") != null && !request.getParameter("paymentExpiry").trim().isEmpty()
                && request.getParameter("paymentCvv") != null && !request.getParameter("paymentCvv").trim().isEmpty();
    }

    private boolean restockBooks(BookDAO bookDAO, List<Book> books) {
        boolean restored = true;

        if (books != null) {
            for (Book book : books) {
                if (book != null) {
                    restored = bookDAO.increaseQuantity(book.getId(), Math.max(1, book.getQuantity())) && restored;
                }
            }
        }

        return restored;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String bookIdParam = request.getParameter("bookId");
        String bookParam = request.getParameter("book");
        String action = request.getParameter("action");
        String removeIndexParam = request.getParameter("removeIndex");

        BookDAO bookDAO = new BookDAO();
        SaleDAO saleDAO = new SaleDAO();
        List<Book> allBooks = bookDAO.getAllBooks();

        if (action == null || action.trim().isEmpty() || "addToCart".equalsIgnoreCase(action.trim())) {
            Book selectedBook = resolveBook(allBooks, bookIdParam);

            if (selectedBook == null) {
                selectedBook = resolveBook(allBooks, bookParam);
            }

            if (selectedBook == null) {
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            List<Book> cartBooks = getCartBooks(session, true);
            Book cartBook = findCartBookById(cartBooks, selectedBook.getId());
            int requestedQuantity = cartBook == null ? 1 : cartBook.getQuantity() + 1;

            if (selectedBook.getQuantity() <= 0 || selectedBook.getQuantity() < requestedQuantity) {
                session.setAttribute("error", "This book is out of stock.");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            if (cartBook == null) {
                cartBooks.add(copyForCart(selectedBook));
            } else {
                cartBook.setQuantity(cartBook.getQuantity() + 1);
            }

            syncLegacyCart(session, cartBooks);
            session.setAttribute("success", "Book added to cart.");
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        if ("buyNow".equalsIgnoreCase(action.trim())) {
            Book selectedBook = resolveBook(allBooks, bookIdParam);

            if (selectedBook == null) {
                selectedBook = resolveBook(allBooks, bookParam);
            }

            if (selectedBook == null) {
                session.setAttribute("error", "Selected book was not found.");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            if (!hasPaymentDetails(request)) {
                session.setAttribute("error", "Please enter the dummy payment details to continue.");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            if (selectedBook.getQuantity() <= 0) {
                session.setAttribute("error", "This book is out of stock.");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            if (!bookDAO.decreaseQuantity(selectedBook.getId(), 1)) {
                session.setAttribute("error", "This book is out of stock.");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            boolean recorded = saleDAO.recordSale(selectedBook, 1, resolveBuyerName(session), resolveBuyerEmail(session));
            if (!recorded) {
                bookDAO.increaseQuantity(selectedBook.getId(), 1);
                session.setAttribute("error", "Unable to complete your purchase right now.");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            addPurchasedBook(session, selectedBook, 1);
            session.setAttribute("success", selectedBook.getTitle() + " purchased successfully.");
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        if ("buyCartItem".equalsIgnoreCase(action.trim())) {
            List<Book> cartBooks = getCartBooks(session, true);
            Book cartBook = null;

            if (removeIndexParam != null && !removeIndexParam.trim().isEmpty()) {
                Integer removeIndex = parseInteger(removeIndexParam);
                if (removeIndex != null) {
                    cartBook = findCartBookByIndex(cartBooks, removeIndex);
                }
            }

            if (cartBook == null) {
                Integer bookId = parseInteger(bookIdParam);
                cartBook = findCartBookById(cartBooks, bookId != null ? bookId : -1);
            }

            if (cartBook == null) {
                session.setAttribute("error", "Cart item not found.");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            if (!hasPaymentDetails(request)) {
                session.setAttribute("error", "Please enter the dummy payment details to continue.");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            Book freshBook = bookDAO.getBookById(cartBook.getId());
            int purchaseQuantity = Math.max(1, cartBook.getQuantity());

            if (freshBook == null || freshBook.getQuantity() < purchaseQuantity) {
                session.setAttribute("error", "This book is no longer available in the required quantity.");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            if (!bookDAO.decreaseQuantity(freshBook.getId(), purchaseQuantity)) {
                session.setAttribute("error", "Unable to complete this purchase right now.");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            boolean recorded = saleDAO.recordSale(freshBook, purchaseQuantity, resolveBuyerName(session), resolveBuyerEmail(session));
            if (!recorded) {
                bookDAO.increaseQuantity(freshBook.getId(), purchaseQuantity);
                session.setAttribute("error", "Unable to complete this purchase right now.");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            cartBooks.remove(cartBook);
            syncLegacyCart(session, cartBooks);
            addPurchasedBook(session, freshBook, purchaseQuantity);
            session.setAttribute("success", cartBook.getTitle() + " purchased successfully.");
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        if ("checkout".equalsIgnoreCase(action.trim())) {
            List<Book> cartBooks = getCartBooks(session, true);

            if (cartBooks.isEmpty()) {
                session.setAttribute("error", "Your cart is empty.");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            if (!hasPaymentDetails(request)) {
                session.setAttribute("error", "Please enter the dummy payment details to continue.");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            List<Book> processedBooks = new ArrayList<>();

            for (Book cartBook : cartBooks) {
                if (cartBook == null) {
                    continue;
                }

                Book freshBook = bookDAO.getBookById(cartBook.getId());
                int purchaseQuantity = Math.max(1, cartBook.getQuantity());

                if (freshBook == null || freshBook.getQuantity() < purchaseQuantity || !bookDAO.decreaseQuantity(freshBook.getId(), purchaseQuantity)) {
                    restockBooks(bookDAO, processedBooks);
                    session.setAttribute("error", "One or more books are no longer available in the requested quantity.");
                    response.sendRedirect(request.getContextPath() + "/CartServlet");
                    return;
                }

                Book rollbackBook = new Book();
                rollbackBook.setId(freshBook.getId());
                rollbackBook.setQuantity(purchaseQuantity);
                processedBooks.add(rollbackBook);
            }

            boolean recorded = saleDAO.recordSales(cartBooks, resolveBuyerName(session), resolveBuyerEmail(session));
            if (!recorded) {
                restockBooks(bookDAO, processedBooks);
                session.setAttribute("error", "Unable to complete checkout right now.");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            List<Book> purchasedBooks = getPurchasedBooks(session, saleDAO);
            for (Book cartBook : cartBooks) {
                if (cartBook != null) {
                    mergePurchasedBook(purchasedBooks, cartBook, Math.max(1, cartBook.getQuantity()));
                }
            }
            syncPurchasedBooks(session, purchasedBooks);

            cartBooks.clear();
            syncLegacyCart(session, cartBooks);
            session.setAttribute("success", "Your cart has been purchased successfully.");
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/CartServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        BookDAO bookDAO = new BookDAO();
        List<Book> cartBooks = getCartBooks(session, true);
        List<Book> purchasedBooks = getPurchasedBooks(session, new SaleDAO());
        syncLegacyCart(session, cartBooks);
        syncPurchasedBooks(session, purchasedBooks);

        String clear = request.getParameter("clear");
        String removeIndex = request.getParameter("removeIndex");

        if (clear != null && !clear.trim().isEmpty()) {
            cartBooks.clear();
            syncLegacyCart(session, cartBooks);
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        if (removeIndex != null && !removeIndex.trim().isEmpty()) {
            try {
                int index = Integer.parseInt(removeIndex.trim());
                if (index >= 0 && index < cartBooks.size()) {
                    cartBooks.remove(index);
                    syncLegacyCart(session, cartBooks);
                }
            } catch (NumberFormatException ignored) {
            }

            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        request.setAttribute("cartBooks", cartBooks);
        request.setAttribute("myBooks", purchasedBooks);
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/UserDashboard/cart.jsp");
        rd.forward(request, response);
    }
}