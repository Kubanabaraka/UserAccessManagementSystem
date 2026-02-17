# User Access Management System — Final Project Report

---

## Table of Contents

1. [Abstract](#1-abstract)
2. [Introduction](#2-introduction)
3. [Project Proposal](#3-project-proposal)
4. [System Analysis](#4-system-analysis)
5. [System Design](#5-system-design)
6. [Implementation Details](#6-implementation-details)
7. [Testing & Results](#7-testing--results)
8. [Conclusion & Future Enhancements](#8-conclusion--future-enhancements)
9. [References](#9-references)
10. [Appendices](#10-appendices)

---

## 1. Abstract

The **User Access Management System** is a web-based Java enterprise application designed to manage software access requests within an organization. Built using the Model-View-Controller (MVC) architecture with Jakarta Servlets, JSP, JDBC, and PostgreSQL, the system implements role-based access control (RBAC) for three user roles: **Admin**, **Manager**, and **Employee**. Employees can request access to software applications, Managers can approve or reject those requests, and Admins can manage both users and software catalogs. The system features server-side validation, session management, authentication filters, and a responsive enterprise-grade UI built with Bootstrap 5.3.2 and Lucide Icons. A structured design system with CSS custom properties ensures visual consistency across all pages. The application is packaged as a WAR file using Apache Maven and deployed on Apache Tomcat 10.1.

---

## 2. Introduction

### 2.1 Background

In modern organizations, managing who has access to which software applications is critical for security, compliance, and operational efficiency. Manual access management through emails, spreadsheets, or verbal requests is error-prone, lacks audit trails, and introduces unnecessary delays. A centralized digital system is needed to streamline the entire access lifecycle — from request submission to managerial approval — while enforcing role-based authorization.

### 2.2 Purpose

This project implements a **User Access Management System** that automates the process of requesting, reviewing, and approving access to software applications. The system provides:

- A structured workflow for access requests with clear status tracking
- Role-based access control ensuring appropriate authorization at every layer
- An audit trail of all requests and their resolution statuses
- Full CRUD operations for managing users and software catalogs
- A modern, enterprise-grade user interface with consistent design language

### 2.3 Technology Stack

| Component           | Technology                                      |
|----------------------|-------------------------------------------------|
| Language             | Java 17                                         |
| Web Framework        | Jakarta Servlet 6.0, Jakarta Server Pages 3.1   |
| Database             | PostgreSQL 14+                                  |
| Data Access          | JDBC with DAO Pattern                           |
| Application Server   | Apache Tomcat 10.1                              |
| Build Tool           | Apache Maven 3.6+                               |
| Frontend Framework   | Bootstrap 5.3.2                                 |
| Icon Library         | Lucide Icons (via CDN)                          |
| Typography           | Google Fonts – Inter                            |
| Tag Library          | JSTL (Jakarta Standard Tag Library 3.0)         |
| Architecture         | MVC (Model-View-Controller)                     |

---

## 3. Project Proposal

### 3.1 Title

**User Access Management System — A Role-Based Web Application for Software Access Control**

### 3.2 Problem Statement

Organizations face several challenges in managing software access:

- **No centralized system** to track who has access to what software
- **Manual approval workflows** through email are slow and lack accountability
- **No audit trail** of access requests, approvals, and rejections
- **Security risks** arising from unmanaged and unmonitored access permissions
- **No role differentiation** between administrators, managers, and regular employees

These challenges lead to security vulnerabilities, compliance failures, and operational inefficiencies.

### 3.3 Objectives

1. Design and implement a web-based access management system using Java MVC architecture.
2. Implement role-based access control with three distinct user roles (Admin, Manager, Employee).
3. Create a structured approval workflow for software access requests.
4. Provide full CRUD functionality for users, software, and requests.
5. Ensure robust server-side validation and comprehensive error handling.
6. Build a modern, responsive enterprise UI with a consistent design system.
7. Deploy the application on a production-grade application server.

### 3.4 Scope

**In Scope:**

- **User Management**: Registration, authentication, role assignment (Admin, Manager, Employee)
- **Software Management**: CRUD operations for the software catalog (Admin only)
- **Access Requests**: Employees submit requests with justification and access type
- **Approval Workflow**: Managers approve or reject pending requests
- **Dashboard**: Role-specific views with contextual navigation
- **Security**: Authentication filter, session management, page-level authorization checks
- **UI/UX**: Enterprise design system with Lucide icons, Bootstrap grid, custom CSS theming

**Out of Scope:** Email notifications, password hashing (BCrypt), LDAP/SSO integration, REST APIs, connection pooling, unit test framework.

### 3.5 Expected Outcomes

- A fully functional web application accessible via browser
- Three user roles with appropriate access controls enforced at both UI and server layers
- Complete CRUD operations for all domain entities
- A streamlined request-approval workflow with status tracking
- A clean, professional, enterprise-ready user interface

---

## 4. System Analysis

### 4.1 Functional Requirements

| ID    | Requirement            | Description                                                         |
|-------|------------------------|---------------------------------------------------------------------|
| FR-01 | User Registration      | New users can sign up with username/password; assigned Employee role |
| FR-02 | User Authentication    | Users login with credentials; HTTP session is created               |
| FR-03 | Role-Based Dashboard   | Each role sees a customized dashboard with relevant action cards     |
| FR-04 | Software CRUD (Admin)  | Admin can create, read, update, and delete software entries         |
| FR-05 | User CRUD (Admin)      | Admin can create, read, update, and delete user accounts            |
| FR-06 | Access Request (Employee) | Employees submit requests for software with access type and reason |
| FR-07 | View My Requests       | Employees can view the status of their submitted requests           |
| FR-08 | Pending Requests (Manager) | Managers view all pending requests in a review queue             |
| FR-09 | Approve/Reject         | Managers approve or reject requests with one-click actions          |
| FR-10 | Request History        | Managers can view all historical requests with statuses             |
| FR-11 | All Requests (Admin)   | Admin can view all requests across the entire system                |
| FR-12 | Logout                 | Users can securely log out, invalidating their session              |
| FR-13 | Cancel Request         | Employees can cancel their own pending requests                     |

### 4.2 Non-Functional Requirements

| ID     | Requirement      | Description                                                  |
|--------|------------------|--------------------------------------------------------------|
| NFR-01 | Security         | Authentication required for all non-public pages via filter  |
| NFR-02 | Usability        | Responsive UI with Bootstrap grid; intuitive icon-based navigation |
| NFR-03 | Performance      | Database indexes on frequently queried columns (status, user_id) |
| NFR-04 | Maintainability  | Clean MVC separation; DAO pattern; reusable JSP partials     |
| NFR-05 | Reliability      | Server-side validation; error handling; database constraints  |
| NFR-06 | Portability      | Standard WAR deployment on any Jakarta EE compatible server   |
| NFR-07 | Visual Consistency | Design system with CSS custom properties and shared partials |

### 4.3 User Roles

| Role         | Permissions                                                              |
|--------------|--------------------------------------------------------------------------|
| **Admin**    | Manage software (CRUD), manage users (CRUD), view all requests           |
| **Manager**  | View pending requests, approve/reject requests, view request history     |
| **Employee** | Submit access requests, view own request statuses, cancel pending requests |

### 4.4 Use Cases

#### Use Case 1: User Registration
- **Actor**: Unregistered User
- **Precondition**: User is on the signup page
- **Flow**: User enters username, password, confirms password → System validates input (minimum lengths, password match, username uniqueness) → Creates account with Employee role → Redirects to login with success message
- **Postcondition**: User account exists and can be used to log in

#### Use Case 2: User Login
- **Actor**: Registered User
- **Precondition**: User has a valid account
- **Flow**: User enters credentials → System authenticates via UserDAO → Creates HTTP session with user attributes → Redirects to role-specific dashboard

#### Use Case 3: Submit Access Request
- **Actor**: Employee
- **Precondition**: Employee is logged in
- **Flow**: Employee selects software from dropdown → Selects access type (Read/Write/Admin) → Provides reason → Submits → System creates request with "Pending" status

#### Use Case 4: Approve/Reject Request
- **Actor**: Manager
- **Precondition**: Pending requests exist in the system
- **Flow**: Manager views pending requests table → Clicks Approve or Reject → System updates request status → Manager sees confirmation message

#### Use Case 5: Manage Software
- **Actor**: Admin
- **Precondition**: Admin is logged in
- **Flow**: Admin creates new software (name, description, access level) OR edits existing software via pre-populated form OR deletes software with confirmation

#### Use Case 6: Manage Users
- **Actor**: Admin
- **Precondition**: Admin is logged in
- **Flow**: Admin creates new user (username, password, role) OR edits existing user OR deletes user with confirmation

---

## 5. System Design

### 5.1 MVC Architecture

The application follows the **Model-View-Controller (MVC)** architectural pattern, ensuring clean separation of concerns:

```
┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│   Browser    │────▶│   Controller     │────▶│    Model     │
│   (Client)   │     │   (Servlets)     │     │ (DAO/Beans)  │
│              │◀────│                  │◀────│              │
└─────────────┘     └──────────────────┘     └─────────────┘
       │                     │                       │
       │              ┌──────┴──────┐         ┌──────┴──────┐
       │              │    View     │         │  Database   │
       └─────────────▶│   (JSP)     │         │ (PostgreSQL)│
                      └─────────────┘         └─────────────┘
```

- **Model Layer**: JavaBeans (`User`, `Software`, `Request`) and DAO classes (`UserDAO`, `SoftwareDAO`, `RequestDAO`) with `DBUtil` for connection management.
- **View Layer**: JSP pages with JSTL tags, shared layout partials (`head.jspf`, `header.jspf`, `footer.jspf`), Bootstrap 5.3.2 framework, Lucide icon library, and a centralized `theme.css` design system.
- **Controller Layer**: Jakarta Servlets handling HTTP request routing, input validation, business logic orchestration, and view forwarding.

### 5.2 Use Case Diagram

```
                    ┌───────────────────────────────┐
                    │   User Access Management      │
                    │          System                │
                    │                               │
  ┌────────┐       │  ┌──────────────────────┐     │
  │Employee│───────┼─▶│  Register / Login     │     │
  │        │───────┼─▶│  Submit Request       │     │
  │        │───────┼─▶│  View My Requests     │     │
  │        │───────┼─▶│  Cancel Request       │     │
  └────────┘       │  └──────────────────────┘     │
                    │                               │
  ┌────────┐       │  ┌──────────────────────┐     │
  │Manager │───────┼─▶│  Login                │     │
  │        │───────┼─▶│  View Pending Requests│     │
  │        │───────┼─▶│  Approve / Reject     │     │
  │        │───────┼─▶│  View Request History │     │
  └────────┘       │  └──────────────────────┘     │
                    │                               │
  ┌────────┐       │  ┌──────────────────────┐     │
  │ Admin  │───────┼─▶│  Login                │     │
  │        │───────┼─▶│  Manage Software(CRUD)│     │
  │        │───────┼─▶│  Manage Users (CRUD)  │     │
  │        │───────┼─▶│  View All Requests    │     │
  └────────┘       │  └──────────────────────┘     │
                    └───────────────────────────────┘
```

### 5.3 Class Diagram

**Model Classes:**
- `User` — Fields: `id`, `username`, `password`, `role`. Maps to `users` table.
- `Software` — Fields: `id`, `name`, `description`, `accessLevels`. Maps to `software` table.
- `Request` — Fields: `id`, `userId`, `softwareId`, `accessType`, `reason`, `status`, `createdAt`, `username`, `softwareName`. Maps to `requests` table with JOIN-derived display fields.

**DAO Classes:**
- `UserDAO` — Methods: `authenticate()`, `create()`, `findById()`, `findByUsername()`, `findAll()`, `update()`, `delete()`, `usernameExists()`
- `SoftwareDAO` — Methods: `create()`, `findById()`, `findByName()`, `findAll()`, `update()`, `delete()`
- `RequestDAO` — Methods: `create()`, `findById()`, `findAll()`, `findPending()`, `findByUserId()`, `updateStatus()`, `delete()`

**Controller Classes (Servlets):**
- `LoginServlet` — Handles POST for authentication, GET for redirection
- `SignUpServlet` — Handles POST for user registration with validation
- `LogoutServlet` — Handles GET for session invalidation
- `SoftwareServlet` — CRUD actions: list, create, edit, update, delete
- `RequestServlet` — Form display, submit request, delete request
- `ApprovalServlet` — POST for approve/reject
- `PendingRequestsServlet` — GET for pending and historical requests
- `AdminUserServlet` — CRUD actions for user management
- `AdminRequestServlet` — GET for all requests view

**Utility & Filter:**
- `DBUtil` — `getConnection()`, `close()` for JDBC connection management
- `AuthenticationFilter` — `@WebFilter("/*")` interceptor for authentication enforcement

### 5.4 Sequence Diagrams

**Login Sequence:**
1. User → `login.jsp`: Enters username and password
2. `login.jsp` → `LoginServlet` (POST): Submits form
3. `LoginServlet` → `UserDAO.authenticate()`: Validates credentials
4. `UserDAO` → PostgreSQL: `SELECT * FROM users WHERE username=? AND password=?`
5. PostgreSQL → `UserDAO`: Returns User object or null
6. `LoginServlet` → HttpSession: Stores `user`, `user_id`, `username`, `role`
7. `LoginServlet` → Browser: Redirects to `dashboard.jsp`

**Access Request Sequence:**
1. Employee → `RequestServlet` (GET, action=form): Navigates to form
2. `RequestServlet` → `SoftwareDAO.findAll()`: Retrieves software catalog
3. `RequestServlet` → `RequestDAO.findByUserId()`: Retrieves employee's requests
4. `RequestServlet` → `requestAccess.jsp`: Forwards with `softwareList` and `myRequests`
5. Employee → `RequestServlet` (POST, action=submit): Submits request
6. `RequestServlet` → `RequestDAO.create()`: Inserts new request with Pending status
7. `RequestServlet` → Browser: Redirects with success message

**Approval Sequence:**
1. Manager → `PendingRequestsServlet` (GET): Navigates to pending queue
2. `PendingRequestsServlet` → `RequestDAO.findPending()`: Retrieves pending requests
3. `PendingRequestsServlet` → `RequestDAO.findAll()`: Retrieves all requests for history
4. `PendingRequestsServlet` → `pendingRequests.jsp`: Forwards with both lists
5. Manager → `ApprovalServlet` (POST): Clicks Approve or Reject
6. `ApprovalServlet` → `RequestDAO.updateStatus()`: Updates status to Approved/Rejected
7. `ApprovalServlet` → Browser: Redirects to `PendingRequestsServlet` with message

### 5.5 Entity-Relationship Diagram

```
┌──────────────┐        ┌──────────────┐        ┌──────────────┐
│    users     │        │   requests   │        │   software   │
├──────────────┤        ├──────────────┤        ├──────────────┤
│ PK id        │───┐    │ PK id        │    ┌───│ PK id        │
│ username     │   │    │ FK user_id   │────┘   │ name         │
│ password     │   └───▶│ FK software_id│       │ description  │
│ role         │        │ access_type  │        │ access_levels│
│ created_at   │        │ reason       │        │ created_at   │
└──────────────┘        │ status       │        └──────────────┘
                        │ created_at   │
                        └──────────────┘
```

**Relationships:**
- `users` (1) ──── (N) `requests` : One user can submit many requests
- `software` (1) ──── (N) `requests` : One software can be referenced by many requests

**Normalization (3NF):**
- All tables have atomic values (1NF).
- No partial dependencies — all non-key attributes depend on the full primary key (2NF).
- No transitive dependencies — `username` and `softwareName` are JOIN-derived at query time, not stored redundantly in `requests` (3NF).

---

## 6. Implementation Details

### 6.1 Project Structure

```
UserAccessManagement/
├── pom.xml                                  # Maven build configuration
├── sql/
│   └── setup.sql                            # Database schema & sample data
├── docs/
│   └── FINAL_PROJECT_REPORT.md              # Project documentation
├── src/main/
│   ├── java/com/useraccess/
│   │   ├── controller/                      # Servlets (Controller layer)
│   │   │   ├── LoginServlet.java
│   │   │   ├── SignUpServlet.java
│   │   │   ├── LogoutServlet.java
│   │   │   ├── SoftwareServlet.java
│   │   │   ├── RequestServlet.java
│   │   │   ├── ApprovalServlet.java
│   │   │   ├── PendingRequestsServlet.java
│   │   │   ├── AdminUserServlet.java
│   │   │   └── AdminRequestServlet.java
│   │   ├── dao/                             # Data Access Objects
│   │   │   ├── UserDAO.java
│   │   │   ├── SoftwareDAO.java
│   │   │   └── RequestDAO.java
│   │   ├── filter/                          # Security filters
│   │   │   └── AuthenticationFilter.java
│   │   ├── model/                           # JavaBean model classes
│   │   │   ├── User.java
│   │   │   ├── Software.java
│   │   │   └── Request.java
│   │   └── util/                            # Utilities
│   │       └── DBUtil.java
│   └── webapp/
│       ├── css/
│       │   └── theme.css                    # Enterprise Design System (715 lines)
│       ├── WEB-INF/
│       │   ├── web.xml                      # Deployment descriptor
│       │   └── jsp/partials/                # Reusable JSP fragments
│       │       ├── head.jspf                # Shared <head> (fonts, Bootstrap, theme.css)
│       │       ├── header.jspf              # Navigation bar (role-based, Lucide icons)
│       │       └── footer.jspf              # Footer + Bootstrap JS + Lucide init
│       ├── login.jsp                        # Login page
│       ├── signup.jsp                       # Registration page
│       ├── dashboard.jsp                    # Role-based dashboard
│       ├── createSoftware.jsp               # Admin: Software management
│       ├── manageUsers.jsp                  # Admin: User management
│       ├── allRequests.jsp                  # Admin: All requests view
│       ├── requestAccess.jsp                # Employee: Request form & history
│       └── pendingRequests.jsp              # Manager: Approval queue & history
```

### 6.2 Database Configuration

The `DBUtil` utility class manages JDBC connections to a PostgreSQL database named `useraccess_db` on `localhost:5432`. It loads the PostgreSQL JDBC driver on initialization and provides static methods for obtaining and closing database connections.

```
Database URL:  jdbc:postgresql://127.0.0.1:5432/useraccess_db
Driver:        org.postgresql.Driver
```

Connection and resource management is handled with try-with-resources blocks throughout the DAO layer to prevent resource leaks.

### 6.3 Authentication Filter

The `AuthenticationFilter` implements `jakarta.servlet.Filter` with the annotation `@WebFilter("/*")` to intercept all incoming HTTP requests. The filter:

1. Identifies public resources (login page, signup page, CSS files, LoginServlet, SignUpServlet).
2. Allows public resources to pass through without authentication.
3. Checks for a valid HTTP session with a `user` attribute for all other requests.
4. Redirects unauthenticated users to `login.jsp` with an error message.

### 6.4 DAO Pattern Implementation

Each domain entity has a dedicated DAO class encapsulating all database operations:

| DAO Class      | Key Operations                                                             |
|----------------|---------------------------------------------------------------------------|
| `UserDAO`      | `authenticate()`, `create()`, `findAll()`, `findById()`, `update()`, `delete()`, `usernameExists()` |
| `SoftwareDAO`  | `create()`, `findAll()`, `findById()`, `findByName()`, `update()`, `delete()` |
| `RequestDAO`   | `create()`, `findAll()`, `findPending()`, `findByUserId()`, `updateStatus()`, `delete()` |

All DAO methods use `PreparedStatement` to prevent SQL injection. ResultSet rows are mapped to Java objects using internal mapping methods.

### 6.5 Server-Side Validation

All servlets perform robust input validation:

- Null and empty string checks for all required form fields
- Username minimum length enforcement (3 characters)
- Password minimum length enforcement (6 characters)
- Password confirmation matching during registration
- Duplicate username detection via `UserDAO.usernameExists()`
- Numeric ID parsing with error handling for malformed input
- Role authorization checks at the page level (JSP scriptlets) and servlet level

### 6.6 Session Management

- HTTP sessions are created upon successful login with a 30-minute timeout (configured in `web.xml`).
- Session attributes stored: `user` (User object), `user_id`, `username`, `role`.
- Session is invalidated upon logout via `session.invalidate()`.
- The `AuthenticationFilter` prevents access to protected resources without a valid session.
- Each JSP page performs role verification to prevent URL-based unauthorized access.

### 6.7 UI Architecture & Design System

The frontend is built on a structured enterprise design system with the following components:

#### 6.7.1 CSS Design System (`theme.css`)

The stylesheet is organized into 15 logical sections:

| Section           | Purpose                                          |
|-------------------|--------------------------------------------------|
| 1. Variables      | CSS custom properties for colors, spacing, radii, shadows, typography |
| 2. Global Layout  | Body, typography, selection, Lucide alignment     |
| 3. Navbar         | Sticky header, brand icon, role-based navigation  |
| 4. Main Content   | Flex-based page structure                         |
| 5. Cards          | White cards with border-radius, shadow, fade-in   |
| 6. Buttons        | Primary, Accent, Success, Danger, Secondary, Outline variants |
| 7. Forms          | Themed inputs, focus states, labels with icons    |
| 8. Tables         | Styled headers, striped rows, hover highlights    |
| 9. Badges         | Status (Pending/Approved/Rejected), Access level, Role badges |
| 10. Alerts        | Success and error alerts with left-border accent  |
| 11. Auth Pages    | Login/signup card layout with gradient headers    |
| 12. Footer        | Dark footer with brand accent                    |
| 13. Utilities     | Inline forms, text accents, dividers              |
| 14. Animations    | `fadeInUp` keyframe with staggered delays         |
| 15. Responsive    | Breakpoints at 992px, 768px, 576px                |

**Color Palette:**

| Token             | Hex     | Usage                         |
|--------------------|---------|-------------------------------|
| Primary Dark       | #742F14 | Navbar, table headers, structural elements |
| Primary Blue       | #5A84AC | Primary buttons, links, focus rings |
| Soft Background    | #C7AC9F | Body background               |
| Accent Orange      | #FC9C44 | Hover states, highlights, brand icon |
| Dark Accent        | #5C3C2C | Delete buttons, danger actions |

#### 6.7.2 Shared JSP Partials

Three reusable JSP fragment files eliminate code duplication across all pages:

- **`head.jspf`**: Loads Google Fonts (Inter), Bootstrap 5.3.2 CSS, and `theme.css` using `${pageContext.request.contextPath}` for portable path resolution.
- **`header.jspf`**: Renders a sticky navbar with the brand icon (Lucide `shield`), role-based navigation links with active page highlighting, user identity badge, and logout action. Uses underscore-prefixed variables (`_role`, `_username`, `_activePage`) to avoid conflicts with page-level variables.
- **`footer.jspf`**: Renders the page footer, loads Bootstrap Bundle JS, loads Lucide Icons via CDN, and initializes icons with `lucide.createIcons()` inside a `DOMContentLoaded` event listener.

#### 6.7.3 Lucide Icon Integration

All visual indicators use Lucide Icons exclusively — no other icon library is used. Icons are rendered via `<i data-lucide="icon-name"></i>` elements and initialized by the Lucide JavaScript library. Key icon mappings:

| Context         | Icon Name        |
|-----------------|------------------|
| Brand / Shield  | `shield`         |
| Dashboard       | `layout-dashboard` |
| Software        | `package`        |
| Users           | `users`          |
| Requests        | `file-text`      |
| Login           | `log-in`         |
| Logout          | `log-out`        |
| Add / Create    | `plus`, `plus-circle` |
| Edit            | `pencil`         |
| Delete          | `trash`          |
| Save            | `save`           |
| Approve         | `check-circle`   |
| Reject          | `x-circle`       |
| Pending         | `clock`          |
| Send / Submit   | `send`           |
| User            | `user`           |
| Lock            | `lock`           |
| Navigate        | `arrow-right`    |

#### 6.7.4 Micro-Interactions

- **Button hover**: `translateY(-1px) scale(1.02)` with `0.2s ease` transition
- **Card entrance**: `fadeInUp` animation with staggered delays per column
- **Feature card hover**: `translateY(-5px)` with enhanced shadow
- **Icon circle hover**: `scale(1.08)` with color shift to accent orange
- **Table row hover**: Subtle orange-tinted background highlight
- **Form focus**: Blue border with `3px` spread box-shadow ring

---

## 7. Testing & Results

### 7.1 Test Cases

| #  | Test Case                    | Input                          | Expected Result                          | Actual Result                            | Status |
|----|------------------------------|--------------------------------|------------------------------------------|------------------------------------------|--------|
| 1  | Login with valid Admin       | admin / admin123               | Redirect to dashboard (Admin view)       | Dashboard loads with 3 Admin cards       | PASS   |
| 2  | Login with valid Manager     | manager / manager123           | Redirect to dashboard (Manager view)     | Dashboard loads with 2 Manager cards     | PASS   |
| 3  | Login with valid Employee    | john_doe / employee123         | Redirect to dashboard (Employee view)    | Dashboard loads with 2 Employee cards    | PASS   |
| 4  | Login with invalid credentials | wrong / wrong                | Error message on login page              | Alert: "Invalid username or password"    | PASS   |
| 5  | Login with empty fields      | (empty)                        | Error message                            | Alert: "Username and password are required" | PASS |
| 6  | Sign up new user             | newuser / pass123 / pass123    | Account created, redirect to login       | Success message shown on login page      | PASS   |
| 7  | Sign up with existing username | admin / pass123 / pass123    | Error message                            | Alert: "Username already exists"         | PASS   |
| 8  | Sign up with short password  | user / abc / abc               | Error message                            | Alert: "Password must be at least 6 characters" | PASS |
| 9  | Sign up password mismatch    | user / pass123 / pass456       | Client-side error                        | "Passwords do not match" shown           | PASS   |
| 10 | Admin: Create software       | TestApp / Description / Read   | Software added to table                  | Row appears with Read badge              | PASS   |
| 11 | Admin: Edit software         | Change name to TestApp2        | Software updated in table                | Updated name displayed                   | PASS   |
| 12 | Admin: Delete software       | Delete TestApp2                | Software removed from table              | Row removed after confirmation           | PASS   |
| 13 | Admin: Create user           | testmgr / pass123 / Manager    | User added to table                      | Row appears with Manager role badge      | PASS   |
| 14 | Admin: Edit user role        | Change role to Employee        | User role updated                        | Employee badge displayed                 | PASS   |
| 15 | Admin: Delete user           | Delete testmgr                 | User removed from table                  | Row removed after confirmation           | PASS   |
| 16 | Admin: View all requests     | Navigate to All Requests       | All requests displayed                   | Table shows all requests with badges     | PASS   |
| 17 | Employee: Submit request     | Salesforce / Read / "Need CRM" | Request created as Pending               | Row appears with Pending badge           | PASS   |
| 18 | Employee: Submit without reason | No reason entered            | Validation error                         | HTML5 required validation fires          | PASS   |
| 19 | Employee: Cancel request     | Click trash icon on pending    | Request removed                          | Row removed after confirmation           | PASS   |
| 20 | Manager: View pending        | Navigate to Pending Requests   | Pending requests displayed               | Table shows pending items with actions   | PASS   |
| 21 | Manager: Approve request     | Click Approve                  | Status → Approved                        | Success message; badge updates           | PASS   |
| 22 | Manager: Reject request      | Click Reject                   | Status → Rejected                        | Success message; badge updates           | PASS   |
| 23 | Unauthorized URL access      | Employee navigates to /SoftwareServlet | Redirect to login with error    | Alert: "Unauthorized access"             | PASS   |
| 24 | Session timeout              | Access after 30 min inactivity | Redirect to login                        | Alert: "Please log in first"             | PASS   |
| 25 | Logout                       | Click Logout in navbar         | Session invalidated, redirect to login   | Login page with success message          | PASS   |

### 7.2 Sample Test Data

**Users:**

| Username   | Password     | Role     |
|------------|-------------|----------|
| admin      | admin123    | Admin    |
| manager    | manager123  | Manager  |
| john_doe   | employee123 | Employee |
| jane_smith | employee123 | Employee |
| bob_wilson | employee123 | Employee |

**Software:**

| Name              | Description                                       | Access Level |
|-------------------|---------------------------------------------------|-------------|
| Salesforce CRM    | Customer relationship management platform          | Read        |
| GitHub Enterprise | Source code repository and collaboration tool       | Write       |
| AWS Console       | Amazon Web Services cloud management console       | Admin       |
| Jira              | Project management and issue tracking software     | Read        |
| Slack Enterprise  | Team communication and collaboration platform      | Write       |

**Sample Requests:**

| Employee   | Software         | Access Type | Reason                                             | Status   |
|------------|------------------|-------------|-----------------------------------------------------|----------|
| john_doe   | Salesforce CRM   | Read        | Need CRM access for sales reporting project         | Pending  |
| john_doe   | GitHub Enterprise | Write       | Need to commit code for the Q1 feature sprint       | Approved |
| jane_smith | AWS Console      | Read        | Need to monitor server infrastructure               | Pending  |
| jane_smith | Jira             | Write       | Need to create and manage project tickets           | Rejected |
| bob_wilson | Slack Enterprise  | Read        | Need access to team communication channels          | Pending  |

### 7.3 Screenshots

---

**[Insert Screenshot Here – Login Page]**

*The login page with centered auth card, gradient header with shield icon, username and password fields, and "Sign In" button.*

---

**[Insert Screenshot Here – Sign Up Page]**

*The registration page with centered auth card, user-plus icon, three form fields (username, password, confirm password), and client-side validation.*

---

**[Insert Screenshot Here – Admin Dashboard]**

*The Admin dashboard showing the welcome panel with gradient background and three feature cards: Manage Software, Manage Users, All Requests.*

---

**[Insert Screenshot Here – Manager Dashboard]**

*The Manager dashboard showing the welcome panel and two feature cards: Pending Requests and Request History.*

---

**[Insert Screenshot Here – Employee Dashboard]**

*The Employee dashboard showing the welcome panel and two feature cards: Request Access and My Requests.*

---

**[Insert Screenshot Here – Software Management Page (Admin)]**

*The software management page with the "Add Software" form on the left and the Software Registry table on the right, showing access level badges.*

---

**[Insert Screenshot Here – Software Edit Mode (Admin)]**

*The software management page in edit mode, with the form pre-populated with existing software data and Update/Cancel buttons.*

---

**[Insert Screenshot Here – User Management Page (Admin)]**

*The user management page with the "Add User" form on the left and the User Directory table on the right, showing role badges (Admin, Manager, Employee).*

---

**[Insert Screenshot Here – All Requests Page (Admin)]**

*The all requests page showing a read-only table of every access request in the system with status badges (Pending, Approved, Rejected).*

---

**[Insert Screenshot Here – Request Access Page (Employee)]**

*The request access page with the "New Request" form on the left (software dropdown, access type, reason) and the "My Requests" table on the right.*

---

**[Insert Screenshot Here – Pending Requests Page (Manager)]**

*The pending requests page with the approval queue table (Approve/Reject buttons) at the top and the request history table below.*

---

**[Insert Screenshot Here – Manager Approving a Request]**

*The pending requests page after a Manager clicks "Approve", showing the success confirmation message.*

---

**[Insert Screenshot Here – Login Error Message]**

*The login page displaying a red alert banner with "Invalid username or password" after a failed login attempt.*

---

**[Insert Screenshot Here – Responsive Mobile View]**

*The application displayed on a mobile viewport showing the collapsed hamburger navigation and stacked card layout.*

---

**[Insert Screenshot Here – Navbar with Active Page Highlight]**

*The navigation bar showing the currently active page highlighted in accent orange, with the user badge on the right.*

---

## 8. Conclusion & Future Enhancements

### 8.1 Conclusion

The User Access Management System successfully implements all required functionality as specified in the project objectives:

- **Role-Based Access Control**: Three user roles (Admin, Manager, Employee) with distinct permissions enforced at both the UI and server layers.
- **Full CRUD Operations**: Complete create, read, update, and delete functionality for users, software, and access requests.
- **Structured Approval Workflow**: Clear status transitions (Pending → Approved/Rejected) with one-click manager actions.
- **Security Features**: Authentication filter intercepting all requests, HTTP session management with 30-minute timeout, and page-level authorization checks.
- **Server-Side Validation**: Comprehensive input validation across all servlets with meaningful error messages.
- **Clean MVC Architecture**: Proper separation of concerns with Model (JavaBeans + DAOs), View (JSP + JSTL), and Controller (Servlets) layers.
- **Enterprise-Grade UI**: Modern, responsive interface built with Bootstrap 5.3.2, Lucide Icons, Google Fonts (Inter), and a structured CSS design system with custom properties, micro-interactions, and staggered card animations.
- **Reusable Layout System**: Shared JSP partials for header, footer, and head content, eliminating code duplication and ensuring visual consistency.
- **Normalized Database**: PostgreSQL schema in Third Normal Form (3NF) with proper constraints, foreign keys, and performance indexes.

The application is fully packaged as a WAR file via Apache Maven and deployed on Apache Tomcat 10.1, demonstrating proficiency in Java web development, database design, MVC architecture, session-based authentication, role-based authorization, and enterprise UI engineering.

### 8.2 Challenges Encountered

| Challenge                        | Solution                                                    |
|----------------------------------|-------------------------------------------------------------|
| Consistent UI across 8 pages     | Created shared JSP partials and centralized CSS design system |
| Role-based navigation rendering  | Used session-aware scriptlets in `header.jspf` partial       |
| Icon library consistency         | Standardized exclusively on Lucide Icons with CDN delivery   |
| CSS path resolution in WAR       | Used `${pageContext.request.contextPath}` for portable paths  |
| Form validation feedback         | Combined HTML5 validation, client-side JS, and server-side checks |
| Preventing unauthorized URL access | Implemented AuthenticationFilter + page-level role checks   |

### 8.3 Future Enhancements

1. **Password Hashing**: Implement BCrypt password hashing for secure credential storage.
2. **Email Notifications**: Send email alerts when requests are submitted, approved, or rejected.
3. **Audit Logging**: Maintain a timestamped log of all system actions for compliance.
4. **Search & Filtering**: Add search and filter functionality to data tables.
5. **Pagination**: Implement server-side pagination for large datasets.
6. **REST API**: Add RESTful endpoints for mobile and third-party integration.
7. **SSO Integration**: Support LDAP, Active Directory, or OAuth 2.0 for enterprise single sign-on.
8. **Connection Pooling**: Implement HikariCP for efficient database connection management.
9. **Unit Testing**: Add JUnit 5 tests for DAO and Servlet layers with Mockito.
10. **Docker Deployment**: Containerize the application with Docker for cloud-native deployment.

---

## 9. References

1. Eclipse Foundation. "Jakarta Servlet Specification 6.0." Jakarta EE, 2022. https://jakarta.ee/specifications/servlet/6.0/
2. Eclipse Foundation. "Jakarta Server Pages Specification 3.1." Jakarta EE, 2022. https://jakarta.ee/specifications/pages/3.1/
3. PostgreSQL Global Development Group. "PostgreSQL Documentation." postgresql.org, 2024. https://www.postgresql.org/docs/
4. Apache Software Foundation. "Apache Tomcat 10.1 Documentation." tomcat.apache.org, 2024. https://tomcat.apache.org/tomcat-10.1-doc/
5. Apache Software Foundation. "Apache Maven Project." maven.apache.org, 2024. https://maven.apache.org/
6. Bootstrap Team. "Bootstrap 5.3 Documentation." getbootstrap.com, 2024. https://getbootstrap.com/docs/5.3/
7. Lucide Contributors. "Lucide Icons Documentation." lucide.dev, 2024. https://lucide.dev/
8. Google Fonts. "Inter Font Family." fonts.google.com, 2024. https://fonts.google.com/specimen/Inter
9. Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002.
10. Oracle. "JDBC API Documentation." docs.oracle.com, 2024. https://docs.oracle.com/en/java/javase/17/docs/api/java.sql/java/sql/package-summary.html

---

## 10. Appendices

### Appendix A: Database Schema (setup.sql)

The database consists of three tables in Third Normal Form:

```sql
-- Users table with role constraint
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Employee', 'Manager', 'Admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Software table with access level constraint
CREATE TABLE software (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    description TEXT,
    access_levels VARCHAR(50) CHECK (access_levels IN ('Read', 'Write', 'Admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Requests table with foreign keys and status constraint
CREATE TABLE requests (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    software_id INTEGER NOT NULL REFERENCES software(id) ON DELETE CASCADE,
    access_type VARCHAR(20) NOT NULL CHECK (access_type IN ('Read', 'Write', 'Admin')),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance indexes
CREATE INDEX idx_requests_status ON requests(status);
CREATE INDEX idx_requests_user_id ON requests(user_id);
```

### Appendix B: Key Code Explanations

#### B.1 Authentication Filter

The `AuthenticationFilter` implements `jakarta.servlet.Filter` with `@WebFilter("/*")` to intercept all HTTP requests. It maintains a list of public URI patterns (login, signup, CSS, servlet endpoints for login/signup). For each request, the filter checks if the URI matches a public resource. If not, it verifies the session contains a `user` attribute. Unauthenticated users are redirected to `login.jsp` with an appropriate error message.

#### B.2 DAO Pattern

Each DAO class encapsulates all database operations for its entity, following the Data Access Object pattern. Connections are obtained from `DBUtil.getConnection()` and managed with try-with-resources for automatic cleanup. All queries use `PreparedStatement` to prevent SQL injection. Internal mapping methods convert `ResultSet` rows to Java objects.

#### B.3 Servlet Request Routing

Servlets use an `action` parameter to route requests to appropriate handler methods. For example, `SoftwareServlet` handles: `list` (display all software), `create` (add new entry), `edit` (show form with data), `update` (save changes), `delete` (remove entry). GET requests handle navigation and display; POST requests handle data modifications following the POST-Redirect-GET pattern.

#### B.4 JSTL in JSP

JSP pages use Jakarta Standard Tag Library (JSTL) with `<c:forEach>`, `<c:if>`, and `<c:choose>` tags to iterate over data collections, conditionally render content, and display role-specific UI elements without inline Java scriptlet code in the presentation layer.

#### B.5 Shared JSP Partials

Three JSP fragment files (`.jspf`) are included via `<%@ include file="..." %>` directives:

- **`head.jspf`** — Provides consistent `<head>` content (Google Fonts, Bootstrap CSS, theme.css) across all pages.
- **`header.jspf`** — Renders the navigation bar with role-aware menu items and active page highlighting using the `activePage` request attribute.
- **`footer.jspf`** — Renders the footer, loads Bootstrap JS bundle, loads Lucide Icons library, and calls `lucide.createIcons()` to replace `data-lucide` attributes with rendered SVG icons.

#### B.6 CSS Design System

The `theme.css` file defines CSS custom properties (variables) on the `:root` element for the entire color palette, spacing scale, border radii, box shadows, font sizes, and transition timings. All component styles reference these variables, enabling consistent theming and easy maintenance. The file is organized into clearly labeled sections with ASCII art separators for readability.

### Appendix C: Deployment Instructions

```bash
# 1. Create database
sudo -u postgres psql -c "CREATE DATABASE useraccess_db;"

# 2. Run schema setup
PGPASSWORD=password123 psql -h 127.0.0.1 -U postgres -d useraccess_db -f sql/setup.sql

# 3. Build project
mvn clean package

# 4. Deploy to Tomcat
cp target/UserAccessManagement.war /opt/tomcat/webapps/

# 5. Start Tomcat
/opt/tomcat/bin/catalina.sh start

# 6. Access application
# http://localhost:8080/UserAccessManagement/
```

### Appendix D: Application URL Map

| URL                              | Description                  | Access Level  |
|----------------------------------|------------------------------|---------------|
| `/login.jsp`                     | Login page                   | Public        |
| `/signup.jsp`                    | Registration page            | Public        |
| `/dashboard.jsp`                 | Role-based dashboard         | Authenticated |
| `/SoftwareServlet?action=list`   | Software management          | Admin         |
| `/AdminUserServlet?action=list`  | User management              | Admin         |
| `/AdminRequestServlet?action=list` | All requests view          | Admin         |
| `/RequestServlet?action=form`    | Access request form          | Employee      |
| `/PendingRequestsServlet`        | Pending requests queue       | Manager       |
| `/ApprovalServlet`               | Approve/Reject (POST only)   | Manager       |
| `/LogoutServlet`                 | Session invalidation         | Authenticated |

### Appendix E: Maven Dependencies

| Dependency                          | Version | Scope    | Purpose                    |
|-------------------------------------|---------|----------|----------------------------|
| `jakarta.servlet-api`               | 6.0.0   | provided | Jakarta Servlet API        |
| `jakarta.servlet.jsp-api`           | 3.1.0   | provided | Jakarta JSP API            |
| `jakarta.servlet.jsp.jstl`          | 3.0.1   | compile  | JSTL Implementation        |
| `jakarta.servlet.jsp.jstl-api`      | 3.0.0   | compile  | JSTL API                   |
| `postgresql`                        | 42.7.2  | compile  | PostgreSQL JDBC Driver     |

### Appendix F: Frontend CDN Resources

| Resource           | CDN URL                                                           | Version |
|--------------------|--------------------------------------------------------------------|---------|
| Bootstrap CSS      | `cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css` | 5.3.2   |
| Bootstrap JS       | `cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js` | 5.3.2 |
| Google Fonts (Inter) | `fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700` | —       |
| Lucide Icons       | `unpkg.com/lucide@latest`                                         | Latest  |

---

*Document generated: February 2026*
*System: User Access Management System v1.0-SNAPSHOT*
*Deployed on: Apache Tomcat 10.1 / PostgreSQL 14+ / Java 17*
