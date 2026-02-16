<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String role = (session != null) ? (String) session.getAttribute("role") : null;
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (!"Employee".equals(role)) {
        response.sendRedirect("login.jsp?error=Unauthorized+access.+Employee+role+required");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Access - User Access Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .status-pending { color: #ffc107; font-weight: bold; }
        .status-approved { color: #28a745; font-weight: bold; }
        .status-rejected { color: #dc3545; font-weight: bold; }
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
                    <li class="nav-item"><a class="nav-link active" href="RequestServlet?action=form"><i class="fas fa-paper-plane me-1"></i>Request Access</a></li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item"><span class="nav-link"><i class="fas fa-user-circle me-1"></i><%= username %> (Employee)</span></li>
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
            <!-- Request Form -->
            <div class="col-md-4 mb-4">
                <div class="card p-4">
                    <h4><i class="fas fa-paper-plane me-2"></i>New Access Request</h4>
                    <form action="RequestServlet" method="POST">
                        <input type="hidden" name="action" value="submit">
                        <div class="mb-3">
                            <label for="software_id" class="form-label">Software</label>
                            <select class="form-select" id="software_id" name="software_id" required>
                                <option value="" disabled selected>Select software</option>
                                <c:forEach var="sw" items="${softwareList}">
                                    <option value="${sw.id}">${sw.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="access_type" class="form-label">Access Type</label>
                            <select class="form-select" id="access_type" name="access_type" required>
                                <option value="" disabled selected>Select access type</option>
                                <option value="Read">Read</option>
                                <option value="Write">Write</option>
                                <option value="Admin">Admin</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="reason" class="form-label">Reason</label>
                            <textarea class="form-control" id="reason" name="reason" rows="4"
                                      placeholder="Explain why you need this access" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-paper-plane me-2"></i>Submit Request
                        </button>
                    </form>
                </div>
            </div>

            <!-- My Requests Table -->
            <div class="col-md-8 mb-4">
                <div class="card p-4">
                    <h4><i class="fas fa-list me-2"></i>My Requests</h4>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>#</th>
                                    <th>Software</th>
                                    <th>Access Type</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="req" items="${myRequests}" varStatus="loop">
                                    <tr>
                                        <td>${loop.count}</td>
                                        <td><strong>${req.softwareName}</strong></td>
                                        <td>${req.accessType}</td>
                                        <td>${req.reason}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${req.status == 'Pending'}">
                                                    <span class="badge bg-warning text-dark"><i class="fas fa-clock me-1"></i>Pending</span>
                                                </c:when>
                                                <c:when test="${req.status == 'Approved'}">
                                                    <span class="badge bg-success"><i class="fas fa-check me-1"></i>Approved</span>
                                                </c:when>
                                                <c:when test="${req.status == 'Rejected'}">
                                                    <span class="badge bg-danger"><i class="fas fa-times me-1"></i>Rejected</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td><small>${req.createdAt}</small></td>
                                        <td>
                                            <c:if test="${req.status == 'Pending'}">
                                                <form action="RequestServlet" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${req.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Cancel Request"
                                                            onclick="return confirm('Cancel this request?')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty myRequests}">
                                    <tr><td colspan="7" class="text-center text-muted">No requests submitted yet.</td></tr>
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
