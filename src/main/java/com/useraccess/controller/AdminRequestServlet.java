package com.useraccess.controller;

import com.useraccess.dao.RequestDAO;
import com.useraccess.model.Request;
import com.useraccess.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * AdminRequestServlet - displays all requests for Admin view.
 * Only accessible by Admin users.
 */
@WebServlet(name = "AdminRequestServlet", urlPatterns = {"/AdminRequestServlet"})
public class AdminRequestServlet extends HttpServlet {

    private final RequestDAO requestDAO = new RequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdmin(request, response)) return;

        List<Request> pendingRequests = requestDAO.findPending();
        List<Request> allRequests = requestDAO.findAll();
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("allRequests", allRequests);
        request.getRequestDispatcher("allRequests.jsp").forward(request, response);
    }

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please+log+in");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!"Admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp?error=Unauthorized+access.+Admin+role+required");
            return false;
        }
        return true;
    }
}
