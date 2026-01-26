<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.warehouse.models.Product" %>
<%@ page import="com.warehouse.dao.ProductDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Manage Products" />
    <jsp:param name="activePage" value="manageProduct" />
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
    <h2 class="page-header">Product Management</h2>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div></div>
        <div class="d-flex gap-2">
            <input type="text" id="searchInput" class="form-control" style="width: 250px;" placeholder="Search by product name...">
            <button class="custom-add-btn" data-bs-toggle="modal" data-bs-target="#addModal">Add Product</button>
        </div>
    </div>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Weight</th>
                    <th>Reorder Level</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="productTable">
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.productId}</td>
                        <td class="product-name">${product.productName}</td> <!-- Add class here -->
                        <td>${product.categoryName}</td>
                        <td>${product.weightValue} Kg</td>
                        <td>${product.reorderLevel}</td>
                        <td>
                            <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal" data-id="${product.productId}">Edit</button>
                            <button class="btn btn-danger btn-sm" onclick="deleteProduct(${product.productId})">Delete</button>
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
                <div class="modal-header"><h5>Add Product</h5></div>
                <div class="modal-body">
                    <input type="text" name="productName" class="form-control" placeholder="Product Name" required/>
                    <select name="categoryId" class="form-control mt-2" required>
                        <option value="">Select Category</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}">${category.name}</option>
                        </c:forEach>
                    </select>
                    <select name="weightId" class="form-control mt-2" required>
                        <option value="">Select Weight</option>
                        <c:forEach var="weight" items="${weights}">
                            <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                        </c:forEach>
                    </select>
                    <input type="number" name="reorderLevel" class="form-control mt-2" placeholder="Reorder Level" required/>
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
                <!-- Add dynamic content via JS if needed -->
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/manage_product_script.js"></script>
</body>
</html>
