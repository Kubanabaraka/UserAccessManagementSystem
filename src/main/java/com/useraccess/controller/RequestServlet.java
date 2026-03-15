package com.useraccess.controller;

import com.useraccess.dao.RequestDAO;
import com.useraccess.dao.SoftwareDAO;
import com.useraccess.model.Request;
import com.useraccess.model.Software;
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
 * RequestServlet - handles access requests from Employees.
 * Supports creating new requests and viewing own requests.
 */
@WebServlet(name = "RequestServlet", urlPatterns = {"/RequestServlet"})
public class RequestServlet extends HttpServlet {

    private final RequestDAO requestDAO = new RequestDAO();
    private final SoftwareDAO softwareDAO = new SoftwareDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkEmployee(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "form";

        switch (action) {
            case "form":
                showRequestForm(request, response);
                break;
            case "myRequests":
                showMyRequests(request, response);
                break;
            default:
                showRequestForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkEmployee(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "submit";

        switch (action) {
            case "submit":
                submitRequest(request, response);
                break;
            case "delete":
                deleteRequest(request, response);
                break;
            default:
                submitRequest(request, response);
        }
    }

    private void showRequestForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Get software list for the dropdown
        List<Software> softwareList = softwareDAO.findAll();
        request.setAttribute("softwareList", softwareList);

        // Get user's previous requests
        List<Request> myRequests = requestDAO.findByUserId(user.getId());
        request.setAttribute("myRequests", myRequests);

        request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
    }

    private void showMyRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<Software> softwareList = softwareDAO.findAll();
        request.setAttribute("softwareList", softwareList);

        List<Request> myRequests = requestDAO.findByUserId(user.getId());
        request.setAttribute("myRequests", myRequests);

        request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
    }

    private void submitRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String softwareIdStr = request.getParameter("software_id");
        String accessType = request.getParameter("access_type");
        String reason = request.getParameter("reason");

        // Validation
        if (softwareIdStr == null || softwareIdStr.trim().isEmpty()) {
            response.sendRedirect("RequestServlet?action=form&error=Please+select+a+software");
            return;
        }

        if (accessType == null || accessType.trim().isEmpty()) {
            response.sendRedirect("RequestServlet?action=form&error=Please+select+an+access+type");
            return;
        }

        if (reason == null || reason.trim().isEmpty()) {
            response.sendRedirect("RequestServlet?action=form&error=Please+provide+a+reason");
            return;
        }

        int softwareId;
        try {
            softwareId = Integer.parseInt(softwareIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("RequestServlet?action=form&error=Invalid+software+selection");
            return;
        }

        Request accessRequest = new Request();
        accessRequest.setUserId(user.getId());
        accessRequest.setSoftwareId(softwareId);
        accessRequest.setAccessType(accessType);
        accessRequest.setReason(reason.trim());

        boolean created = requestDAO.create(accessRequest);

        if (created) {
            response.sendRedirect("RequestServlet?action=form&message=Request+submitted+successfully");
        } else {
            response.sendRedirect("RequestServlet?action=form&error=Failed+to+submit+request");
        }
    }

    private void deleteRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("id"));
        requestDAO.delete(requestId);
        response.sendRedirect("RequestServlet?action=form&message=Request+deleted+successfully");
    }

    private boolean checkEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please+log+in");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!"Employee".equals(user.getRole())) {
            response.sendRedirect("login.jsp?error=Unauthorized+access.+Employee+role+required");
            return false;
        }
        return true;
    }
}
