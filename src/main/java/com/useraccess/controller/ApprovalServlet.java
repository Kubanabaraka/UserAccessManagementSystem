package com.useraccess.controller;

import com.useraccess.dao.RequestDAO;
import com.useraccess.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * ApprovalServlet - handles approval/rejection of access requests.
 * Accessible by Manager and Admin users.
 */
@WebServlet(name = "ApprovalServlet", urlPatterns = {"/ApprovalServlet"})
public class ApprovalServlet extends HttpServlet {

    private final RequestDAO requestDAO = new RequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please+log+in");
            return;
        }
        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        if (!"Manager".equals(role) && !"Admin".equals(role)) {
            response.sendRedirect("login.jsp?error=Unauthorized+access");
            return;
        }

        // Determine redirect target based on role
        String redirectTarget = "Admin".equals(role) ? "AdminRequestServlet" : "PendingRequestsServlet";

        String requestIdStr = request.getParameter("request_id");
        String action = request.getParameter("action");

        // Validation
        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            response.sendRedirect(redirectTarget + "?error=Invalid+request+ID");
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(requestIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectTarget + "?error=Invalid+request+ID");
            return;
        }

        // Determine new status
        String newStatus;
        if ("Approve".equals(action)) {
            newStatus = "Approved";
        } else if ("Reject".equals(action)) {
            newStatus = "Rejected";
        } else {
            response.sendRedirect(redirectTarget + "?error=Invalid+action");
            return;
        }

        // Update the request status
        boolean updated = requestDAO.updateStatus(requestId, newStatus);

        if (updated) {
            response.sendRedirect(redirectTarget + "?message=Request+has+been+" + newStatus.toLowerCase());
        } else {
            response.sendRedirect(redirectTarget + "?error=Error+processing+request");
        }
    }
}
