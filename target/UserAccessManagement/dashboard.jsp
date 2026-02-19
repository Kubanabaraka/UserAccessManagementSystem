<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=Please+log+in+first");
        return;
    }
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    request.setAttribute("activePage", "dashboard");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - AccessManager</title>
    <%@ include file="WEB-INF/jsp/partials/head.jspf" %>
</head>
<body>
    <%@ include file="WEB-INF/jsp/partials/header.jspf" %>

    <main class="app-main">
        <div class="container">
            <!-- Welcome Panel -->
            <div class="welcome-panel">
                <h2><i data-lucide="layout-dashboard"></i> Welcome, <%= username %>!</h2>
                <p class="mb-0 opacity-75">You are signed in as <strong><%= role %></strong>. Select an option below to get started.</p>
            </div>

            <!-- Role-based Feature Cards -->
            <div class="row">
                <% if ("Admin".equals(role)) { %>
                    <div class="col-md-4 mb-4">
                        <div class="card feature-card text-center p-4 h-100">
                            <div class="card-body d-flex flex-column align-items-center">
                                <div class="icon-circle"><i data-lucide="package"></i></div>
                                <h5 class="card-title">Manage Software</h5>
                                <p class="card-text text-muted small">Create, edit, and remove software applications</p>
                                <a href="SoftwareServlet?action=list" class="btn btn-primary mt-auto">
                                    <i data-lucide="arrow-right"></i> Open
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="card feature-card text-center p-4 h-100">
                            <div class="card-body d-flex flex-column align-items-center">
                                <div class="icon-circle"><i data-lucide="users"></i></div>
                                <h5 class="card-title">Manage Users</h5>
                                <p class="card-text text-muted small">View, edit roles, and manage user accounts</p>
                                <a href="AdminUserServlet?action=list" class="btn btn-primary mt-auto">
                                    <i data-lucide="arrow-right"></i> Open
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="card feature-card text-center p-4 h-100">
                            <div class="card-body d-flex flex-column align-items-center">
                                <div class="icon-circle"><i data-lucide="file-text"></i></div>
                                <h5 class="card-title">All Requests</h5>
                                <p class="card-text text-muted small">View all access requests across the system</p>
                                <a href="AdminRequestServlet?action=list" class="btn btn-primary mt-auto">
                                    <i data-lucide="arrow-right"></i> Open
                                </a>
                            </div>
                        </div>
                    </div>
                <% } else if ("Manager".equals(role)) { %>
                    <div class="col-md-6 mb-4">
                        <div class="card feature-card text-center p-4 h-100">
                            <div class="card-body d-flex flex-column align-items-center">
                                <div class="icon-circle"><i data-lucide="clock"></i></div>
                                <h5 class="card-title">Pending Requests</h5>
                                <p class="card-text text-muted small">Review and approve or reject pending access requests</p>
                                <a href="PendingRequestsServlet" class="btn btn-primary mt-auto">
                                    <i data-lucide="arrow-right"></i> Review
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-4">
                        <div class="card feature-card text-center p-4 h-100">
                            <div class="card-body d-flex flex-column align-items-center">
                                <div class="icon-circle"><i data-lucide="archive"></i></div>
                                <h5 class="card-title">Request History</h5>
                                <p class="card-text text-muted small">Browse all processed and pending requests</p>
                                <a href="PendingRequestsServlet" class="btn btn-secondary mt-auto">
                                    <i data-lucide="arrow-right"></i> View
                                </a>
                            </div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="col-md-6 mb-4">
                        <div class="card feature-card text-center p-4 h-100">
                            <div class="card-body d-flex flex-column align-items-center">
                                <div class="icon-circle"><i data-lucide="send"></i></div>
                                <h5 class="card-title">Request Access</h5>
                                <p class="card-text text-muted small">Submit a new access request for software</p>
                                <a href="RequestServlet?action=form" class="btn btn-primary mt-auto">
                                    <i data-lucide="arrow-right"></i> Request
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-4">
                        <div class="card feature-card text-center p-4 h-100">
                            <div class="card-body d-flex flex-column align-items-center">
                                <div class="icon-circle"><i data-lucide="list"></i></div>
                                <h5 class="card-title">My Requests</h5>
                                <p class="card-text text-muted small">Track the status of your submitted requests</p>
                                <a href="RequestServlet?action=form" class="btn btn-secondary mt-auto">
                                    <i data-lucide="arrow-right"></i> View
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <%@ include file="WEB-INF/jsp/partials/footer.jspf" %>
</body>
</html>
