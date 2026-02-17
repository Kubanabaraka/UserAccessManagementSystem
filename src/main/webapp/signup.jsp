<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("activePage", "signup"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - AccessManager</title>
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
                            <span class="auth-icon"><i data-lucide="user-plus"></i></span>
                            <h3>Create Account</h3>
                            <p class="mb-0 opacity-75">Register as a new Employee</p>
                        </div>
                        <div class="card-body p-4">
                            <% String error = request.getParameter("error"); %>
                            <% if (error != null && !error.isEmpty()) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i data-lucide="alert-circle" class="me-2"></i><%= error %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            <% } %>

                            <form action="SignUpServlet" method="POST" id="signupForm">
                                <div class="mb-3">
                                    <label for="username" class="form-label">
                                        <i data-lucide="user"></i> Username
                                    </label>
                                    <input type="text" class="form-control" id="username" name="username"
                                           placeholder="Choose a username (min 3 chars)" required minlength="3" autofocus>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">
                                        <i data-lucide="lock"></i> Password
                                    </label>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Create a password (min 6 chars)" required minlength="6">
                                </div>
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">
                                        <i data-lucide="lock"></i> Confirm Password
                                    </label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                           placeholder="Re-enter your password" required>
                                    <div id="passwordError" class="text-danger mt-1 small d-none">
                                        <i data-lucide="alert-circle" style="width:14px;height:14px;"></i> Passwords do not match
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 py-2 mt-2">
                                    <i data-lucide="user-plus"></i> Create Account
                                </button>
                            </form>
                            <hr>
                            <p class="text-center mb-0 auth-link">
                                Already have an account? <a href="login.jsp">Sign in</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="WEB-INF/jsp/partials/footer.jspf" %>
    <script>
        document.getElementById('signupForm').addEventListener('submit', function(e) {
            var pwd = document.getElementById('password').value;
            var cpwd = document.getElementById('confirmPassword').value;
            var errEl = document.getElementById('passwordError');
            if (pwd !== cpwd) {
                e.preventDefault();
                errEl.classList.remove('d-none');
                document.getElementById('confirmPassword').focus();
            } else {
                errEl.classList.add('d-none');
            }
        });
    </script>
</body>
</html>
