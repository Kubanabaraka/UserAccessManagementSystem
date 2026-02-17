<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String role = (session != null) ? (String) session.getAttribute("role") : null;
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (!"Admin".equals(role)) {
        response.sendRedirect("login.jsp?error=Unauthorized+access.+Admin+role+required");
        return;
    }
    request.setAttribute("activePage", "software");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Software - AccessManager</title>
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
                <!-- Create / Edit Software Form -->
                <div class="col-lg-4 col-md-5 mb-4">
                    <div class="card p-4">
                        <c:choose>
                            <c:when test="${not empty editSoftware}">
                                <h4 class="section-title"><i data-lucide="pencil"></i> Edit Software</h4>
                                <form action="SoftwareServlet" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="${editSoftware.id}">
                                    <div class="mb-3">
                                        <label for="name" class="form-label">
                                            <i data-lucide="tag"></i> Software Name
                                        </label>
                                        <input type="text" class="form-control" id="name" name="name" value="${editSoftware.name}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="description" class="form-label">
                                            <i data-lucide="align-left"></i> Description
                                        </label>
                                        <textarea class="form-control" id="description" name="description" rows="3" required>${editSoftware.description}</textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="access_level" class="form-label">
                                            <i data-lucide="key"></i> Access Level
                                        </label>
                                        <select class="form-select" id="access_level" name="access_level" required>
                                            <option value="Read" ${editSoftware.accessLevels == 'Read' ? 'selected' : ''}>Read</option>
                                            <option value="Write" ${editSoftware.accessLevels == 'Write' ? 'selected' : ''}>Write</option>
                                            <option value="Admin" ${editSoftware.accessLevels == 'Admin' ? 'selected' : ''}>Admin</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-accent w-100">
                                        <i data-lucide="save"></i> Update Software
                                    </button>
                                    <a href="SoftwareServlet?action=list" class="btn btn-secondary w-100 mt-2">
                                        <i data-lucide="x"></i> Cancel
                                    </a>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <h4 class="section-title"><i data-lucide="plus-circle"></i> Add Software</h4>
                                <form action="SoftwareServlet" method="POST">
                                    <input type="hidden" name="action" value="create">
                                    <div class="mb-3">
                                        <label for="name" class="form-label">
                                            <i data-lucide="tag"></i> Software Name
                                        </label>
                                        <input type="text" class="form-control" id="name" name="name" placeholder="e.g. Salesforce CRM" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="description" class="form-label">
                                            <i data-lucide="align-left"></i> Description
                                        </label>
                                        <textarea class="form-control" id="description" name="description" rows="3" placeholder="Brief description of the software" required></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="access_level" class="form-label">
                                            <i data-lucide="key"></i> Access Level
                                        </label>
                                        <select class="form-select" id="access_level" name="access_level" required>
                                            <option value="" disabled selected>Select access level</option>
                                            <option value="Read">Read</option>
                                            <option value="Write">Write</option>
                                            <option value="Admin">Admin</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i data-lucide="plus"></i> Create Software
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Software List Table -->
                <div class="col-lg-8 col-md-7 mb-4">
                    <div class="card p-4">
                        <h4 class="section-title"><i data-lucide="package"></i> Software Registry</h4>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Name</th>
                                        <th>Description</th>
                                        <th>Access Level</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="sw" items="${softwareList}" varStatus="loop">
                                        <tr>
                                            <td>${loop.count}</td>
                                            <td><strong>${sw.name}</strong></td>
                                            <td>${sw.description}</td>
                                            <td>
                                                <span class="badge-access badge-access-${sw.accessLevels == 'Read' ? 'read' : sw.accessLevels == 'Write' ? 'write' : 'admin'}">${sw.accessLevels}</span>
                                            </td>
                                            <td>
                                                <a href="SoftwareServlet?action=edit&id=${sw.id}" class="btn btn-sm btn-outline-warning me-1" title="Edit">
                                                    <i data-lucide="pencil"></i>
                                                </a>
                                                <a href="SoftwareServlet?action=delete&id=${sw.id}" class="btn btn-sm btn-outline-delete"
                                                   title="Delete" onclick="return confirm('Delete this software?')">
                                                    <i data-lucide="trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty softwareList}">
                                        <tr><td colspan="5" class="text-center text-muted py-4">No software entries found.</td></tr>
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
