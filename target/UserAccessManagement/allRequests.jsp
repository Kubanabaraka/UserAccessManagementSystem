<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String role = (session != null) ? (String) session.getAttribute("role") : null;
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (!"Admin".equals(role)) {
        response.sendRedirect("login.jsp?error=Unauthorized+access.+Admin+role+required");
        return;
    }
    request.setAttribute("activePage", "allrequests");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Requests - AccessManager</title>
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

            <div class="card p-4">
                <h4 class="section-title"><i data-lucide="file-text"></i> All Access Requests</h4>
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Employee</th>
                                <th>Software</th>
                                <th>Access</th>
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
                                    <td>
                                        <span class="badge-access badge-access-${req.accessType == 'Read' ? 'read' : req.accessType == 'Write' ? 'write' : 'admin'}">${req.accessType}</span>
                                    </td>
                                    <td>${req.reason}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${req.status == 'Pending'}">
                                                <span class="badge-status badge-pending"><i data-lucide="clock"></i> Pending</span>
                                            </c:when>
                                            <c:when test="${req.status == 'Approved'}">
                                                <span class="badge-status badge-approved"><i data-lucide="check-circle"></i> Approved</span>
                                            </c:when>
                                            <c:when test="${req.status == 'Rejected'}">
                                                <span class="badge-status badge-rejected"><i data-lucide="x-circle"></i> Rejected</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td><small>${req.createdAt}</small></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allRequests}">
                                <tr><td colspan="7" class="text-center text-muted py-4">No requests found.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="WEB-INF/jsp/partials/footer.jspf" %>
</body>
</html>
