package controller;

import dao.AdminProfileDAO;
import model.AdminProfile;
import util.FileUploadUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;

@WebServlet("/AdminProfileServlet")
@MultipartConfig
public class AdminProfileServlet extends HttpServlet {

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

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return false;
        }
        return true;
    }

    private AdminProfile buildFallbackProfile(HttpSession session, Integer userId) {
        AdminProfile profile = new AdminProfile();
        profile.setUserId(userId != null ? userId : 0);
        profile.setName(session != null && session.getAttribute("user") != null
                ? String.valueOf(session.getAttribute("user")) : "");
        profile.setEmail(session != null && session.getAttribute("email") != null
                ? String.valueOf(session.getAttribute("email")) : "");
        profile.setPassword("");
        profile.setPhone("");
        profile.setAddress("");
        profile.setImage("");
        return profile;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        Integer userId = resolveUserId(session);

        AdminProfileDAO dao = new AdminProfileDAO();
        AdminProfile profile = userId != null ? dao.getProfileByUserId(userId) : null;
        if (profile == null) {
            profile = buildFallbackProfile(session, userId);
        }

        request.setAttribute("profile", profile);
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/AdminDashboard/admin-profile.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        Integer userId = resolveUserId(session);
        if (userId == null) {
            request.setAttribute("error", "Unable to resolve admin account.");
            doGet(request, response);
            return;
        }

        AdminProfileDAO dao = new AdminProfileDAO();
        AdminProfile current = dao.getProfileByUserId(userId);
        if (current == null) {
            current = buildFallbackProfile(session, userId);
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String existingImage = request.getParameter("existingImage");
        Part imagePart = request.getPart("imageFile");

        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Name and email are required.");
            request.setAttribute("profile", current);
            RequestDispatcher rd = request.getRequestDispatcher("/jsp/AdminDashboard/admin-profile.jsp");
            rd.forward(request, response);
            return;
        }

        AdminProfile profile = new AdminProfile();
        profile.setUserId(userId);
        profile.setName(name.trim());
        profile.setEmail(email.trim());
        profile.setPassword((password != null && !password.trim().isEmpty())
                ? password.trim()
                : current.getPassword());
        profile.setPhone(phone != null ? phone.trim() : "");
        profile.setAddress(address != null ? address.trim() : "");

        String imageName = existingImage != null ? existingImage.trim() : current.getImage();
        try {
            String uploaded = FileUploadUtil.saveImage(getServletContext(), imagePart);
            if (uploaded != null) {
                imageName = uploaded;
            }
        } catch (IOException e) {
            request.setAttribute("error", "Unable to upload profile image.");
            request.setAttribute("profile", current);
            RequestDispatcher rd = request.getRequestDispatcher("/jsp/AdminDashboard/admin-profile.jsp");
            rd.forward(request, response);
            return;
        }
        profile.setImage(imageName != null ? imageName : "");

        boolean status = dao.saveOrUpdateProfile(profile);
        if (status) {
            session.setAttribute("user", profile.getName());
            session.setAttribute("email", profile.getEmail());
            session.setAttribute("success", "Profile updated successfully.");
        } else {
            session.setAttribute("error", "Unable to update admin profile right now.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminProfileServlet");
    }
}
