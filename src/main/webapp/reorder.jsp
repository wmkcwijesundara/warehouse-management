<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.warehouse.models.Inventory" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Create Reorder" />
    <jsp:param name="pageTitle" value="Create Reorder Request" />
    <jsp:param name="activePage" value="reorder" />
</jsp:include>

<div>
    <h2 class="page-header mb-4">Create Reorder Request</h2>

    <div class="card">
        <div class="modal-header">
            <h5>Reorder Details</h5>
        </div>
        <div class="modal-body">
            <form action="ReorderServlet" method="post">
                <div class="mb-4">
                    <label for="supplierId" class="form-label">Select Supplier</label>
                    <select name="supplierId" id="supplierId" class="form-select" required>
                        <option value="">Select Supplier</option>
                        <c:forEach var="s" items="${suppliers}">
                            <option value="${s.supplierId}">${s.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <h5 class="mb-3">Selected Product</h5>
                <div class="table-container mb-4">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Current Stock</th>
                                <th>Reorder Qty</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <input type="hidden" name="productIds" value="${selectedProduct.productId}" />
                                    ${selectedProduct.productName}
                                </td>
                                <td>${selectedProduct.currentStock}</td>
                                <td>
                                    <input type="number" name="quantities" class="form-control" value="${selectedProduct.reorderLevel}" required />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <h5 class="mb-3">Other Low Stock Products</h5>
                <div class="table-container mb-4">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Add</th>
                                <th>Product</th>
                                <th>Stock</th>
                                <th>Reorder Qty</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${lowStockProducts}">
                                <c:if test="${p.productId != selectedProduct.productId}">
                                    <tr>
                                        <td>
                                            <input type="checkbox" name="addProduct" value="${p.productId}" class="form-check-input" />
                                        </td>
                                        <td>${p.productName}</td>
                                        <td>${p.currentStock}</td>
                                        <td>
                                            <input type="number" name="qty_${p.productId}" class="form-control" value="${p.reorderLevel}" />
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">Send Reorder Request</button>
                </div>
            </form>
        </div>
    </div>
</div>
