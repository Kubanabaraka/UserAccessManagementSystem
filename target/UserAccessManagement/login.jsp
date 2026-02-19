<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<% request.setAttribute("activePage", "login"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - AccessManager</title>
    <%@ include file="WEB-INF/jsp/partials/head.jspf" %>
</head>
<body class="auth-body">
    <%@ include file="WEB-INF/jsp/partials/header.jspf" %>

    <main class="app-main">
        <div class="container auth-wrapper">
            <div class="row justify-content-center w-100">
                <div class="col-lg-5 col-md-7 col-sm-10">
                    <div class="card auth-card">
                        <div class="auth-header">
                            <span class="auth-icon"><i data-lucide="shield"></i></span>
                            <h3>Welcome Back</h3>
                            <p class="mb-0 opacity-75">Sign in to your account</p>
                        </div>
                        <div class="card-body p-4">
                            <% String error = request.getParameter("error"); %>
                            <% String message = request.getParameter("message"); %>
                            <% if (error != null && !error.isEmpty()) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i data-lucide="alert-circle" class="me-2"></i><%= error %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            <% } %>
                            <% if (message != null && !message.isEmpty()) { %>
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i data-lucide="check-circle" class="me-2"></i><%= message %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            <% } %>

                            <form action="LoginServlet" method="POST">
                                <div class="mb-3">
                                    <label for="username" class="form-label">
                                        <i data-lucide="user"></i> Username
                                    </label>
                                    <input type="text" class="form-control" id="username" name="username"
                                           placeholder="Enter your username" required autofocus>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">
                                        <i data-lucide="lock"></i> Password
                                    </label>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Enter your password" required>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 py-2 mt-2">
                                    <i data-lucide="log-in"></i> Sign In
                                </button>
                            </form>
                            <hr>
                            <p class="text-center mb-0 auth-link">
                                Don't have an account? <a href="signup.jsp">Create one</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="WEB-INF/jsp/partials/footer.jspf" %>
</body>
</html>
