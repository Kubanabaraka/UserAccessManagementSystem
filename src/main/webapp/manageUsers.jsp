<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String role = (session != null) ? (String) session.getAttribute("role") : null;
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (!"Admin".equals(role)) {
        response.sendRedirect("login.jsp?error=Unauthorized+access.+Admin+role+required");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - User Access Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="dashboard.jsp"><i class="fas fa-shield-alt me-2"></i>User Access Management</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="dashboard.jsp"><i class="fas fa-home me-1"></i>Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="SoftwareServlet?action=list"><i class="fas fa-cogs me-1"></i>Manage Software</a></li>
                    <li class="nav-item"><a class="nav-link active" href="AdminUserServlet?action=list"><i class="fas fa-users me-1"></i>Manage Users</a></li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item"><span class="nav-link"><i class="fas fa-user-circle me-1"></i><%= username %> (Admin)</span></li>
                    <li class="nav-item"><a class="nav-link" href="LogoutServlet"><i class="fas fa-sign-out-alt me-1"></i>Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Messages -->
        <% String error = request.getParameter("error"); %>
        <% String message = request.getParameter("message"); %>
        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <!-- Add/Edit User Form -->
            <div class="col-md-4 mb-4">
                <div class="card p-4">
                    <c:choose>
                        <c:when test="${not empty editUser}">
                            <h4><i class="fas fa-user-edit me-2"></i>Edit User</h4>
                            <form action="AdminUserServlet" method="POST">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${editUser.id}">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" value="${editUser.username}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" value="${editUser.password}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="role" class="form-label">Role</label>
                                    <select class="form-select" id="role" name="role" required>
                                        <option value="Employee" ${editUser.role == 'Employee' ? 'selected' : ''}>Employee</option>
                                        <option value="Manager" ${editUser.role == 'Manager' ? 'selected' : ''}>Manager</option>
                                        <option value="Admin" ${editUser.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-warning w-100"><i class="fas fa-save me-2"></i>Update User</button>
                                <a href="AdminUserServlet?action=list" class="btn btn-secondary w-100 mt-2"><i class="fas fa-times me-2"></i>Cancel</a>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <h4><i class="fas fa-user-plus me-2"></i>Add New User</h4>
                            <form action="AdminUserServlet" method="POST">
                                <input type="hidden" name="action" value="create">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" required minlength="3">
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required minlength="6">
                                </div>
                                <div class="mb-3">
                                    <label for="role" class="form-label">Role</label>
                                    <select class="form-select" id="role" name="role" required>
                                        <option value="" disabled selected>Select role</option>
                                        <option value="Employee">Employee</option>
                                        <option value="Manager">Manager</option>
                                        <option value="Admin">Admin</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-success w-100"><i class="fas fa-user-plus me-2"></i>Create User</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Users List Table -->
            <div class="col-md-8 mb-4">
                <div class="card p-4">
                    <h4><i class="fas fa-users me-2"></i>All Users</h4>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>#</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${userList}" varStatus="loop">
                                    <tr>
                                        <td>${loop.count}</td>
                                        <td><strong>${u.username}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.role == 'Admin'}"><span class="badge bg-danger">Admin</span></c:when>
                                                <c:when test="${u.role == 'Manager'}"><span class="badge bg-warning text-dark">Manager</span></c:when>
                                                <c:when test="${u.role == 'Employee'}"><span class="badge bg-primary">Employee</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="AdminUserServlet?action=edit&id=${u.id}" class="btn btn-sm btn-outline-warning" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="AdminUserServlet?action=delete&id=${u.id}" class="btn btn-sm btn-outline-danger"
                                               title="Delete" onclick="return confirm('Are you sure you want to delete this user?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty userList}">
                                    <tr><td colspan="4" class="text-center text-muted">No users found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
