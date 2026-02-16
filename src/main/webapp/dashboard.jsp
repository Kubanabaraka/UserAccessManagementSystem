<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Check login
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=Please+log+in+first");
        return;
    }
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - User Access Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .dashboard-card { border: none; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: transform 0.2s; }
        .dashboard-card:hover { transform: translateY(-5px); }
        .card-icon { font-size: 2.5rem; margin-bottom: 15px; }
        .welcome-section { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 12px; padding: 30px; margin-bottom: 30px; }
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
                    <li class="nav-item"><a class="nav-link active" href="dashboard.jsp"><i class="fas fa-home me-1"></i>Dashboard</a></li>
                    <% if ("Admin".equals(role)) { %>
                        <li class="nav-item"><a class="nav-link" href="SoftwareServlet?action=list"><i class="fas fa-cogs me-1"></i>Manage Software</a></li>
                        <li class="nav-item"><a class="nav-link" href="AdminUserServlet?action=list"><i class="fas fa-users me-1"></i>Manage Users</a></li>
                    <% } else if ("Manager".equals(role)) { %>
                        <li class="nav-item"><a class="nav-link" href="PendingRequestsServlet"><i class="fas fa-tasks me-1"></i>Pending Requests</a></li>
                    <% } else { %>
                        <li class="nav-item"><a class="nav-link" href="RequestServlet?action=form"><i class="fas fa-paper-plane me-1"></i>Request Access</a></li>
                    <% } %>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <span class="nav-link"><i class="fas fa-user-circle me-1"></i><%= username %> (<%= role %>)</span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet"><i class="fas fa-sign-out-alt me-1"></i>Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h2><i class="fas fa-hand-wave me-2"></i>Welcome, <%= username %>!</h2>
            <p class="mb-0">You are logged in as <strong><%= role %></strong>. Use the navigation or cards below to access your features.</p>
        </div>

        <!-- Dashboard Cards -->
        <div class="row">
            <% if ("Admin".equals(role)) { %>
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-cogs card-icon text-primary"></i>
                            <h5 class="card-title">Manage Software</h5>
                            <p class="card-text text-muted">Create, edit, and delete software applications</p>
                            <a href="SoftwareServlet?action=list" class="btn btn-primary"><i class="fas fa-arrow-right me-1"></i>Go</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-users card-icon text-success"></i>
                            <h5 class="card-title">Manage Users</h5>
                            <p class="card-text text-muted">View, edit roles, and delete user accounts</p>
                            <a href="AdminUserServlet?action=list" class="btn btn-success"><i class="fas fa-arrow-right me-1"></i>Go</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-chart-bar card-icon text-info"></i>
                            <h5 class="card-title">All Requests</h5>
                            <p class="card-text text-muted">View all access requests across the system</p>
                            <a href="AdminRequestServlet?action=list" class="btn btn-info text-white"><i class="fas fa-arrow-right me-1"></i>Go</a>
                        </div>
                    </div>
                </div>
            <% } else if ("Manager".equals(role)) { %>
                <div class="col-md-6 mb-4">
                    <div class="card dashboard-card text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-tasks card-icon text-warning"></i>
                            <h5 class="card-title">Pending Requests</h5>
                            <p class="card-text text-muted">Review and approve/reject pending access requests</p>
                            <a href="PendingRequestsServlet" class="btn btn-warning"><i class="fas fa-arrow-right me-1"></i>Go</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card dashboard-card text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-history card-icon text-secondary"></i>
                            <h5 class="card-title">Request History</h5>
                            <p class="card-text text-muted">View all processed and pending requests</p>
                            <a href="PendingRequestsServlet" class="btn btn-secondary"><i class="fas fa-arrow-right me-1"></i>Go</a>
                        </div>
                    </div>
                </div>
            <% } else { %>
                <div class="col-md-6 mb-4">
                    <div class="card dashboard-card text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-paper-plane card-icon text-primary"></i>
                            <h5 class="card-title">Request Access</h5>
                            <p class="card-text text-muted">Submit a new access request for software</p>
                            <a href="RequestServlet?action=form" class="btn btn-primary"><i class="fas fa-arrow-right me-1"></i>Go</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card dashboard-card text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-list card-icon text-success"></i>
                            <h5 class="card-title">My Requests</h5>
                            <p class="card-text text-muted">View the status of your submitted requests</p>
                            <a href="RequestServlet?action=form" class="btn btn-success"><i class="fas fa-arrow-right me-1"></i>Go</a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
