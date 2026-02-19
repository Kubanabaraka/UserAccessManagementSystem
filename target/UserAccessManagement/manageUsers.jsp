<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String role = (session != null) ? (String) session.getAttribute("role") : null;
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (!"Admin".equals(role)) {
        response.sendRedirect("login.jsp?error=Unauthorized+access.+Admin+role+required");
        return;
    }
    request.setAttribute("activePage", "users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - AccessManager</title>
    <%@ include file="WEB-INF/jsp/partials/head.jspf" %>
</head>
<body>
    <%@ include file="WEB-INF/jsp/partials/header.jspf" %>

    <main class="app-main">
        <div class="container">
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

            <div class="row">
                <!-- Add/Edit User Form -->
                <div class="col-lg-4 col-md-5 mb-4">
                    <div class="card p-4">
                        <c:choose>
                            <c:when test="${not empty editUser}">
                                <h4 class="section-title"><i data-lucide="pencil"></i> Edit User</h4>
                                <form action="AdminUserServlet" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="${editUser.id}">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">
                                            <i data-lucide="user"></i> Username
                                        </label>
                                        <input type="text" class="form-control" id="username" name="username" value="${editUser.username}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            <i data-lucide="lock"></i> Password
                                        </label>
                                        <input type="password" class="form-control" id="password" name="password" value="${editUser.password}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="role" class="form-label">
                                            <i data-lucide="shield"></i> Role
                                        </label>
                                        <select class="form-select" id="role" name="role" required>
                                            <option value="Employee" ${editUser.role == 'Employee' ? 'selected' : ''}>Employee</option>
                                            <option value="Manager" ${editUser.role == 'Manager' ? 'selected' : ''}>Manager</option>
                                            <option value="Admin" ${editUser.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-accent w-100">
                                        <i data-lucide="save"></i> Update User
                                    </button>
                                    <a href="AdminUserServlet?action=list" class="btn btn-secondary w-100 mt-2">
                                        <i data-lucide="x"></i> Cancel
                                    </a>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <h4 class="section-title"><i data-lucide="user-plus"></i> Add User</h4>
                                <form action="AdminUserServlet" method="POST">
                                    <input type="hidden" name="action" value="create">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">
                                            <i data-lucide="user"></i> Username
                                        </label>
                                        <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" required minlength="3">
                                    </div>
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            <i data-lucide="lock"></i> Password
                                        </label>
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required minlength="6">
                                    </div>
                                    <div class="mb-3">
                                        <label for="role" class="form-label">
                                            <i data-lucide="shield"></i> Role
                                        </label>
                                        <select class="form-select" id="role" name="role" required>
                                            <option value="" disabled selected>Select role</option>
                                            <option value="Employee">Employee</option>
                                            <option value="Manager">Manager</option>
                                            <option value="Admin">Admin</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i data-lucide="user-plus"></i> Create User
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Users List Table -->
                <div class="col-lg-8 col-md-7 mb-4">
                    <div class="card p-4">
                        <h4 class="section-title"><i data-lucide="users"></i> User Directory</h4>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
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
                                                    <c:when test="${u.role == 'Admin'}">
                                                        <span class="badge-role badge-role-admin"><i data-lucide="shield"></i> Admin</span>
                                                    </c:when>
                                                    <c:when test="${u.role == 'Manager'}">
                                                        <span class="badge-role badge-role-manager"><i data-lucide="briefcase"></i> Manager</span>
                                                    </c:when>
                                                    <c:when test="${u.role == 'Employee'}">
                                                        <span class="badge-role badge-role-employee"><i data-lucide="user"></i> Employee</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="AdminUserServlet?action=edit&id=${u.id}" class="btn btn-sm btn-outline-warning me-1" title="Edit">
                                                    <i data-lucide="pencil"></i>
                                                </a>
                                                <a href="AdminUserServlet?action=delete&id=${u.id}" class="btn btn-sm btn-outline-delete"
                                                   title="Delete" onclick="return confirm('Delete this user?')">
                                                    <i data-lucide="trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty userList}">
                                        <tr><td colspan="4" class="text-center text-muted py-4">No users found.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="WEB-INF/jsp/partials/footer.jspf" %>
</body>
</html>
