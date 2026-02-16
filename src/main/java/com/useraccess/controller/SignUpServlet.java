package com.useraccess.controller;

import com.useraccess.dao.UserDAO;
import com.useraccess.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * SignUpServlet - handles new user registration.
 * All new users are assigned the "Employee" role by default.
 */
@WebServlet(name = "SignUpServlet", urlPatterns = {"/SignUpServlet"})
public class SignUpServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Server-side validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("signup.jsp?error=All+fields+are+required");
            return;
        }

        username = username.trim();
        password = password.trim();

        if (username.length() < 3) {
            response.sendRedirect("signup.jsp?error=Username+must+be+at+least+3+characters");
            return;
        }

        if (password.length() < 6) {
            response.sendRedirect("signup.jsp?error=Password+must+be+at+least+6+characters");
            return;
        }

        if (confirmPassword != null && !password.equals(confirmPassword.trim())) {
            response.sendRedirect("signup.jsp?error=Passwords+do+not+match");
            return;
        }

        // Check if username already exists
        if (userDAO.usernameExists(username)) {
            response.sendRedirect("signup.jsp?error=Username+already+exists.+Please+choose+another");
            return;
        }

        // Create new user with Employee role
        User newUser = new User(username, password, "Employee");
        boolean created = userDAO.create(newUser);

        if (created) {
            response.sendRedirect("login.jsp?message=Registration+successful!+Please+log+in");
        } else {
            response.sendRedirect("signup.jsp?error=Registration+failed.+Please+try+again");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("signup.jsp");
    }
}
