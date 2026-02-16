<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String role = (session != null) ? (String) session.getAttribute("role") : null;
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (!"Manager".equals(role)) {
        response.sendRedirect("login.jsp?error=Unauthorized+access.+Manager+role+required");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Requests - User Access Management</title>
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
                    <li class="nav-item"><a class="nav-link active" href="PendingRequestsServlet"><i class="fas fa-tasks me-1"></i>Pending Requests</a></li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item"><span class="nav-link"><i class="fas fa-user-circle me-1"></i><%= username %> (Manager)</span></li>
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

        <!-- Pending Requests -->
        <div class="card p-4 mb-4">
            <h4><i class="fas fa-clock me-2 text-warning"></i>Pending Requests</h4>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Employee</th>
                            <th>Software</th>
                            <th>Access Type</th>
                            <th>Reason</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="req" items="${pendingRequests}" varStatus="loop">
                            <tr>
                                <td>${loop.count}</td>
                                <td><strong>${req.username}</strong></td>
                                <td>${req.softwareName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${req.accessType == 'Read'}"><span class="badge bg-info">Read</span></c:when>
                                        <c:when test="${req.accessType == 'Write'}"><span class="badge bg-warning text-dark">Write</span></c:when>
                                        <c:when test="${req.accessType == 'Admin'}"><span class="badge bg-danger">Admin</span></c:when>
                                    </c:choose>
                                </td>
                                <td>${req.reason}</td>
                                <td><small>${req.createdAt}</small></td>
                                <td>
                                    <form action="ApprovalServlet" method="POST" style="display:inline;">
                                        <input type="hidden" name="request_id" value="${req.id}">
                                        <button type="submit" name="action" value="Approve" class="btn btn-sm btn-success" title="Approve">
                                            <i class="fas fa-check me-1"></i>Approve
                                        </button>
                                        <button type="submit" name="action" value="Reject" class="btn btn-sm btn-danger" title="Reject">
                                            <i class="fas fa-times me-1"></i>Reject
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pendingRequests}">
                            <tr><td colspan="7" class="text-center text-muted">No pending requests.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- All Requests History -->
        <div class="card p-4">
            <h4><i class="fas fa-history me-2 text-secondary"></i>Request History</h4>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Employee</th>
                            <th>Software</th>
                            <th>Access Type</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="req" items="${allRequests}" varStatus="loop">
                            <tr>
                                <td>${loop.count}</td>
                                <td><strong>${req.username}</strong></td>
                                <td>${req.softwareName}</td>
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
                            </tr>
                        </c:forEach>
                        <c:if test="${empty allRequests}">
                            <tr><td colspan="7" class="text-center text-muted">No requests found.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
