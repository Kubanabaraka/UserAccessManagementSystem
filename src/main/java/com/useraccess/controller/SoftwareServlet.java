package com.useraccess.controller;

import com.useraccess.dao.SoftwareDAO;
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
 * SoftwareServlet - handles CRUD operations for software management.
 * Only accessible by Admin users.
 */
@WebServlet(name = "SoftwareServlet", urlPatterns = {"/SoftwareServlet"})
public class SoftwareServlet extends HttpServlet {

    private final SoftwareDAO softwareDAO = new SoftwareDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check Admin role
        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listSoftware(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSoftware(request, response);
                break;
            default:
                listSoftware(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "create";

        switch (action) {
            case "create":
                createSoftware(request, response);
                break;
            case "update":
                updateSoftware(request, response);
                break;
            default:
                createSoftware(request, response);
        }
    }

    private void listSoftware(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Software> softwareList = softwareDAO.findAll();
        request.setAttribute("softwareList", softwareList);
        request.getRequestDispatcher("createSoftware.jsp").forward(request, response);
    }

    private void createSoftware(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String accessLevel = request.getParameter("access_level");

        // Validation
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("SoftwareServlet?action=list&error=Software+name+is+required");
            return;
        }

        if (accessLevel == null || accessLevel.trim().isEmpty()) {
            response.sendRedirect("SoftwareServlet?action=list&error=Access+level+is+required");
            return;
        }

        Software software = new Software(name.trim(), description != null ? description.trim() : "", accessLevel);
        boolean created = softwareDAO.create(software);

        if (created) {
            response.sendRedirect("SoftwareServlet?action=list&message=Software+created+successfully");
        } else {
            response.sendRedirect("SoftwareServlet?action=list&error=Software+name+already+exists+or+creation+failed");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Software software = softwareDAO.findById(id);
        if (software != null) {
            request.setAttribute("editSoftware", software);
        }
        listSoftware(request, response);
    }

    private void updateSoftware(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String accessLevel = request.getParameter("access_level");

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("SoftwareServlet?action=list&error=Software+name+is+required");
            return;
        }

        Software software = new Software(id, name.trim(), description != null ? description.trim() : "", accessLevel);
        boolean updated = softwareDAO.update(software);

        if (updated) {
            response.sendRedirect("SoftwareServlet?action=list&message=Software+updated+successfully");
        } else {
            response.sendRedirect("SoftwareServlet?action=list&error=Update+failed");
        }
    }

    private void deleteSoftware(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean deleted = softwareDAO.delete(id);

        if (deleted) {
            response.sendRedirect("SoftwareServlet?action=list&message=Software+deleted+successfully");
        } else {
            response.sendRedirect("SoftwareServlet?action=list&error=Delete+failed");
        }
    }

    /**
     * Check if the current user has Admin role.
     */
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
