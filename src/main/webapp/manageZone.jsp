<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Manage Zones" />
    <jsp:param name="pageTitle" value="Zone Management" />
    <jsp:param name="activePage" value="manageZone" />
</jsp:include>

<div>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="page-header mb-0">Zone Management</h2>
        <button class="custom-add-btn" data-bs-toggle="modal" data-bs-target="#addModal">Add Zone</button>
    </div>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Capacity</th>
                    <th>Used</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="z" items="${zones}">
                    <tr data-id="${z.zoneId}">
                        <td>${z.zoneId}</td>
                        <td class="name">${z.zoneName}</td>
                        <td class="capacity">${z.zoneCapacity}</td>
                        <td class="used">${z.usedCapacity}</td>
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
                <div class="modal-header">
                    <h5>Add Zone</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Zone Name</label>
                        <input type="text" name="name" class="form-control" placeholder="Zone Name" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Total Capacity</label>
                        <input type="number" name="capacity" class="form-control" placeholder="Total Capacity" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Used Capacity</label>
                        <input type="number" name="used" class="form-control" placeholder="Used Capacity" required/>
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
                    <h5>Edit Zone</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Zone Name</label>
                        <input type="text" name="name" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Total Capacity</label>
                        <input type="number" name="capacity" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Used Capacity</label>
                        <input type="number" name="used" class="form-control" required/>
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
    <script src="js/manage_zone_script.js"></script>
</div>
