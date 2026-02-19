<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String role = (session != null) ? (String) session.getAttribute("role") : null;
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (!"Employee".equals(role)) {
        response.sendRedirect("login.jsp?error=Unauthorized+access.+Employee+role+required");
        return;
    }
    request.setAttribute("activePage", "request");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Access - AccessManager</title>
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
                <!-- Request Form -->
                <div class="col-lg-4 col-md-5 mb-4">
                    <div class="card p-4">
                        <h4 class="section-title"><i data-lucide="send"></i> New Request</h4>
                        <form action="RequestServlet" method="POST">
                            <input type="hidden" name="action" value="submit">
                            <div class="mb-3">
                                <label for="software_id" class="form-label">
                                    <i data-lucide="package"></i> Software
                                </label>
                                <select class="form-select" id="software_id" name="software_id" required>
                                    <option value="" disabled selected>Select software</option>
                                    <c:forEach var="sw" items="${softwareList}">
                                        <option value="${sw.id}">${sw.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="access_type" class="form-label">
                                    <i data-lucide="key"></i> Access Type
                                </label>
                                <select class="form-select" id="access_type" name="access_type" required>
                                    <option value="" disabled selected>Select access level</option>
                                    <option value="Read">Read</option>
                                    <option value="Write">Write</option>
                                    <option value="Admin">Admin</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="reason" class="form-label">
                                    <i data-lucide="message-square"></i> Reason
                                </label>
                                <textarea class="form-control" id="reason" name="reason" rows="4"
                                          placeholder="Explain why you need this access" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i data-lucide="send"></i> Submit Request
                            </button>
                        </form>
                    </div>
                </div>

                <!-- My Requests Table -->
                <div class="col-lg-8 col-md-7 mb-4">
                    <div class="card p-4">
                        <h4 class="section-title"><i data-lucide="list"></i> My Requests</h4>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Software</th>
                                        <th>Access</th>
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
                                            <td>
                                                <c:if test="${req.status == 'Pending'}">
                                                    <form action="RequestServlet" method="POST" class="inline-form">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${req.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-delete" title="Cancel Request"
                                                                onclick="return confirm('Cancel this request?')">
                                                            <i data-lucide="trash"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty myRequests}">
                                        <tr><td colspan="7" class="text-center text-muted py-4">No requests submitted yet.</td></tr>
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
