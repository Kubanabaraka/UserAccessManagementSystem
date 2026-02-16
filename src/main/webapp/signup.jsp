<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - User Access Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; }
        .signup-card { border: none; border-radius: 15px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
        .signup-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 15px 15px 0 0; padding: 30px; text-align: center; }
        .signup-header i { font-size: 3rem; margin-bottom: 10px; }
        .btn-success { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); border: none; color: #333; font-weight: bold; }
        .btn-success:hover { background: linear-gradient(135deg, #38d96e 0%, #30e0c2 100%); color: #333; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card signup-card">
                    <div class="signup-header">
                        <i class="fas fa-user-plus"></i>
                        <h3>Create Account</h3>
                        <p class="mb-0">Register as a new Employee</p>
                    </div>
                    <div class="card-body p-4">
                        <% String error = request.getParameter("error"); %>
                        <% if (error != null && !error.isEmpty()) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        <form action="SignUpServlet" method="POST" onsubmit="return validateForm()">
                            <div class="mb-3">
                                <label for="username" class="form-label"><i class="fas fa-user me-1"></i> Username</label>
                                <input type="text" class="form-control" id="username" name="username"
                                       placeholder="Choose a username (min 3 characters)" required minlength="3">
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label"><i class="fas fa-lock me-1"></i> Password</label>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="Create a password (min 6 characters)" required minlength="6">
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label"><i class="fas fa-lock me-1"></i> Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                       placeholder="Re-enter your password" required>
                                <div id="passwordError" class="text-danger mt-1" style="display:none;">Passwords do not match</div>
                            </div>
                            <button type="submit" class="btn btn-success w-100 py-2">
                                <i class="fas fa-user-plus me-2"></i>Sign Up
                            </button>
                        </form>
                        <hr>
                        <p class="text-center mb-0">
                            Already have an account? <a href="login.jsp" class="text-decoration-none">Login here</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validateForm() {
            var pwd = document.getElementById('password').value;
            var cpwd = document.getElementById('confirmPassword').value;
            if (pwd !== cpwd) {
                document.getElementById('passwordError').style.display = 'block';
                return false;
            }
            document.getElementById('passwordError').style.display = 'none';
            return true;
        }
    </script>
</body>
</html>
