<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.warehouse.models.ASN" %>
<%@ page import="com.warehouse.dao.ASNDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="ASN Management" />
    <jsp:param name="pageTitle" value="ASN Management" />
    <jsp:param name="activePage" value="asn" />
</jsp:include>

<style>
    .status-pending {
        color: var(--warning);
        font-weight: 500;
    }
    .status-approved {
        color: var(--primary-green);
        font-weight: 500;
    }
    .status-rejected {
        color: var(--danger);
        font-weight: 500;
    }
    .toast-container {
        position: fixed;
        top: 80px;
        right: 24px;
        z-index: 1100;
    }
</style>

<c:if test="${not empty successMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% session.removeAttribute("successMessage"); %>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% session.removeAttribute("errorMessage"); %>
</c:if>

<div>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="page-header mb-0">Advanced Shipping Notices (ASN)</h2>
        <button class="custom-add-btn" data-bs-toggle="modal" data-bs-target="#createASNModal">
            Create New ASN
        </button>
    </div>

    <div class="card">
        <div class="modal-header">
            <h5>ASN List</h5>
        </div>
        <div class="modal-body">
            <div class="table-container">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>ASN ID</th>
                            <th>Supplier</th>
                            <th>Reference</th>
                            <th>Expected Arrival</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="asn" items="${asnList}">
                            <tr>
                                <td>ASN-${asn.asnId}</td>
                                <td>${asn.supplier != null ? asn.supplier.name : 'N/A'}</td>
                                <td>${asn.referenceNumber}</td>
                                <td><fmt:formatDate value="${asn.expectedArrivalDate}" pattern="yyyy-MM-dd" /></td>
                                <td>
                                    <span class="status-${asn.status.toLowerCase()}">
                                        ${asn.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="ASNManagement?action=view&asnId=${asn.asnId}" class="btn btn-sm btn-primary">View</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Create ASN Modal -->
    <div class="modal fade" id="createASNModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5>Create New ASN</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="createASNForm" action="ASNManagement" method="POST">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Supplier</label>
                                <select name="supplierId" class="form-select" required>
                                    <option value="">Select Supplier</option>
                                    <c:forEach var="supplier" items="${suppliers}">
                                        <option value="${supplier.supplierId}">${supplier.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Reference Number</label>
                                <input type="text" name="referenceNumber" class="form-control" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Expected Arrival Date</label>
                                <input type="date" name="expectedArrivalDate" class="form-control" required>
                            </div>
                        </div>

                        <h5 class="mt-4 mb-3">ASN Items</h5>
                        <div class="table-container">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Category</th>
                                        <th>Product</th>
                                        <th>Weight</th>
                                        <th>Quantity</th>
                                        <th>Product Expiry Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="asnItemsTable">
                                    <tr>
                                        <td>
                                            <select name="categoryId" class="form-select" required>
                                                <option value="">Select Category</option>
                                                <c:forEach var="category" items="${categoryList}">
                                                    <option value="${category.categoryId}">${category.name}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <select name="productId" class="form-select" required>
                                                <option value="">Select Product</option>
                                                <c:forEach var="product" items="${products}">
                                                    <option value="${product.productId}">${product.productName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <select name="weightId" class="form-select" required>
                                                <option value="">Select Weight</option>
                                                <c:forEach var="weight" items="${weights}">
                                                    <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="number" name="quantity" class="form-control" min="1" value="1" required>
                                        </td>
                                        <td>
                                            <input type="date" name="expiryDate" class="form-control" required>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-danger" onclick="removeASNItem(this)">Remove</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <button type="button" class="btn btn-secondary btn-sm mt-2" onclick="addASNItem()">Add Item</button>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Create ASN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function addASNItem() {
        const row = `
            <tr>
                <td>
                    <select name="categoryId" class="form-select" required>
                        <option value="">Select Category</option>
                        <c:forEach var="category" items="${categoryList}">
                            <option value="${category.categoryId}">${category.name}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <select name="productId" class="form-select" required>
                        <option value="">Select Product</option>
                        <c:forEach var="product" items="${products}">
                            <option value="${product.productId}">${product.productName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <select name="weightId" class="form-select" required>
                        <option value="">Select Weight</option>
                        <c:forEach var="weight" items="${weights}">
                            <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <input type="number" name="quantity" class="form-control" min="1" value="1" required>
                </td>
                <td>
                    <input type="date" name="expiryDate" class="form-control" required>
                </td>
                <td>
                    <button type="button" class="btn btn-sm btn-danger" onclick="removeASNItem(this)">Remove</button>
                </td>
            </tr>
        `;
        $('#asnItemsTable').append(row);
    }

    function removeASNItem(button) {
        if ($('#asnItemsTable tr').length > 1) {
            $(button).closest('tr').remove();
        } else {
            alert('You must have at least one item in the ASN');
        }
    }

    $('#createASNForm').submit(function(e) {
        if ($('#asnItemsTable tr').length === 0) {
            e.preventDefault();
            alert('Please add at least one item to the ASN');
            return false;
        }
    });
</script>

<jsp:include page="template/footer.jsp" />
