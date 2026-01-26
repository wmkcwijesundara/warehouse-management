<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.warehouse.models.Category" %>
<%@ page import="com.warehouse.dao.CategoryDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Manage Weights" />
    <jsp:param name="pageTitle" value="Weight Management" />
    <jsp:param name="activePage" value="manageWeights" />
</jsp:include>

<div>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="page-header mb-0">Weight Management</h2>
        <button class="custom-add-btn" data-bs-toggle="modal" data-bs-target="#addModal">Add Weight</button>
    </div>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Weight</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="weightTable">
                <c:forEach var="w" items="${weights}">
                    <tr data-id="${w.weightId}">
                        <td>${w.weightId}</td>
                        <td class="value">${w.weightValue} Kg</td>
                        <td>
                            <button class="btn btn-sm btn-warning editBtn" data-id="${w.weightId}">Edit</button>
                            <button class="btn btn-sm btn-danger deleteBtn" data-id="${w.weightId}">Delete</button>
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
                <div class="modal-header">
                    <h5>Add Weight</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Weight (Kg)</label>
                        <input type="number" step="0.01" name="weightValue" class="form-control" placeholder="Weight" required/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <form id="editForm" class="modal-content">
                <input type="hidden" name="id"/>
                <div class="modal-header">
                    <h5>Edit Weight</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Weight (Kg)</label>
                        <input type="number" step="0.01" name="weightValue" class="form-control" required/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/manage_weights_script.js"></script>
</div>
