<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Manage Users" />
    <jsp:param name="pageTitle" value="User Management" />
    <jsp:param name="activePage" value="manageUser" />
</jsp:include>

<div>
    <h2 class="page-header mb-4">User Management</h2>

    <!-- User Form -->
    <div class="card mb-4">
        <div class="modal-header">
            <h5>User Form</h5>
        </div>
        <div class="modal-body">
            <form action="manageUser" method="post" id="userForm">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="id" id="userId" value="">

                <div class="row">
                    <div class="mb-3 col-md-4">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>

                    <div class="mb-3 col-md-4">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>

                    <div class="mb-3 col-md-4">
                        <label for="role" class="form-label">Role</label>
                        <select class="form-select" id="role" name="role" required>
                            <option value="">Select Role</option>
                            <option value="admin">Admin</option>
                            <option value="stock_manager">Stock Manager</option>
                            <option value="viewer">Viewer</option>
                        </select>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-secondary" onclick="resetForm()">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="submitBtn">Create User</button>
                </div>
            </form>
        </div>
    </div>

    <!-- User Table -->
    <div class="card">
        <div class="modal-header">
            <h5>All Users</h5>
        </div>
        <div class="modal-body">
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${userList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${user.username}</td>
                                <td>${user.email}</td>
                                <td><span class="badge bg-primary">${user.role}</span></td>
                                <td>
                                    <button class="btn btn-sm btn-warning" onclick="editUser(${user.id}, '${user.username}', '${user.email}', '${user.role}')">Edit</button>
                                    <form action="manageUser" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${user.id}">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    function editUser(id, username, email, role) {
        document.getElementById('formAction').value = 'update';
        document.getElementById('userId').value = id;
        document.getElementById('username').value = username;
        document.getElementById('email').value = email;
        document.getElementById('role').value = role;
        document.getElementById('submitBtn').textContent = 'Update User';
    }

    function resetForm() {
        document.getElementById('formAction').value = 'create';
        document.getElementById('userId').value = '';
        document.getElementById('username').value = '';
        document.getElementById('email').value = '';
        document.getElementById('role').value = '';
        document.getElementById('submitBtn').textContent = 'Create User';
    }
</script>
