<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Category" %>
<%@ page import="com.warehouse.dao.CategoryDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Manage Suppliers" />
    <jsp:param name="activePage" value="manageSupplier" />
</jsp:include>

<style>
    .page-header {
        font-size: 24px;
        font-weight: 600;
        color: #1f2937;
        margin-bottom: 24px;
        font-family: 'Poppins', sans-serif;
    }
    .form-control {
        border: 1px solid #e5e7eb;
        border-radius: 6px;
        padding: 8px 12px;
        font-family: 'Inter', sans-serif;
    }
    .form-control:focus {
        border-color: #16a34a;
        box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.1);
    }
    .btn-warning {
        background: #f59e0b;
        border-color: #f59e0b;
        color: white;
    }
    .btn-danger {
        background: #ef4444;
        border-color: #ef4444;
    }
    .btn-sm {
        padding: 6px 12px;
        font-size: 13px;
        border-radius: 6px;
        font-weight: 500;
    }
</style>

<div>
    <h2 class="page-header">Supplier Management</h2>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div></div>
        <div class="d-flex gap-2">
            <input type="text" id="searchInput" class="form-control" style="width: 250px;" placeholder="Search by supplier name...">
            <button class="custom-add-btn" data-bs-toggle="modal" data-bs-target="#addModal">Add Supplier</button>
        </div>
    </div>

    <div class="table-container">
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Contact Person</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="supplierTable">
                <c:forEach var="s" items="${suppliers}">
                    <tr data-id="${s.supplierId}">
                        <td>${s.supplierId}</td>
                        <td class="name">${s.name}</td>
                        <td class="contact">${s.contactPerson}</td>
                        <td class="phone">${s.phone}</td>
                        <td class="email">${s.email}</td>
                        <td>
                            <button class="btn btn-sm btn-warning editBtn">Edit</button>
                            <button class="btn btn-sm btn-danger deleteBtn">Delete</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <form id="addForm" class="modal-content">
                <div class="modal-header"><h5>Add Supplier</h5></div>
                <div class="modal-body">
                    <input type="text" name="name" class="form-control mb-2" placeholder="Supplier Name" required/>
                    <input type="text" name="contactPerson" class="form-control mb-2" placeholder="Contact Person" required/>
                    <input type="text" name="phone" class="form-control mb-2" placeholder="Phone" required/>
                    <input type="email" name="email" class="form-control mb-2" placeholder="Email" required/>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Save</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <form id="editForm" class="modal-content">
                <input type="hidden" name="id"/>
                <div class="modal-header"><h5>Edit Supplier</h5></div>
                <div class="modal-body">
                    <input type="text" name="name" class="form-control mb-2" required/>
                    <input type="text" name="contactPerson" class="form-control mb-2" required/>
                    <input type="text" name="phone" class="form-control mb-2" required/>
                    <input type="email" name="email" class="form-control mb-2" required/>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Update</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/manage_supplier_script.js"></script>
</div>
