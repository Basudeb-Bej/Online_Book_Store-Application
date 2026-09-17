package controller;

import dao.UserProfileDAO;
import util.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;

@WebServlet("/UserProfileServlet")
@MultipartConfig
public class UserProfileServlet extends HttpServlet {

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/dashboard");
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

        if ("admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
            return;
        }

        Integer userId = resolveUserId(session);
        if (userId == null) {
            session.setAttribute("error", "Unable to resolve your account.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        UserProfileDAO dao = new UserProfileDAO();
        String currentImage = dao.getImageByUserId(userId);
        Part imagePart = request.getPart("imageFile");
        String uploadedImage = FileUploadUtil.saveImage(getServletContext(), imagePart);
        String imageName = uploadedImage != null ? uploadedImage : currentImage;

        if (imageName == null || imageName.trim().isEmpty()) {
            session.setAttribute("error", "Please choose a profile image to upload.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        if (!dao.saveOrUpdateImage(userId, imageName)) {
            session.setAttribute("error", "Unable to update profile image right now.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        session.setAttribute("profileImage", imageName);
        session.setAttribute("success", "Profile image updated successfully.");
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
