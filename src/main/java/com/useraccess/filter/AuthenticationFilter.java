package com.useraccess.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication filter that protects servlet endpoints.
 * Ensures only logged-in users can access application resources.
 * Public pages (login, signup) are excluded.
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Allow access to public resources without authentication
        boolean isPublic = path.equals("/login.jsp")
                || path.equals("/signup.jsp")
                || path.equals("/index.html")
                || path.equals("/LoginServlet")
                || path.equals("/SignUpServlet")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.equals("/")
                || path.equals("");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(contextPath + "/login.jsp?error=Please+log+in+first");
            return;
        }

        chain.doFilter(request, response);
    }
}
