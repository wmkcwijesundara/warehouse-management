<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Reports" />
    <jsp:param name="pageTitle" value="Reports" />
    <jsp:param name="activePage" value="reports" />
</jsp:include>

<div>
    <h2 class="page-header mb-4">Generate Report</h2>

    <div class="card mb-4">
        <div class="modal-header">
            <h5>Report Criteria</h5>
        </div>
        <div class="modal-body">
            <form action="ReportServlet" method="post">
                <input type="hidden" name="action" value="generate">

                <div class="row">
                    <div class="mb-3 col-md-6">
                        <label class="form-label">Report Type</label>
                        <select name="reportType" class="form-select" required>
                            <option value="inventory">Inventory Report</option>
                            <option value="stockMovement">Stock Movement Report</option>
                        </select>
                    </div>

                    <div class="mb-3 col-md-3">
                        <label class="form-label">Start Date</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>

                    <div class="mb-3 col-md-3">
                        <label class="form-label">End Date</label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>

                    <div class="mb-3 col-md-6">
                        <label class="form-label">Category (optional)</label>
                        <select name="categoryId" class="form-select">
                            <option value="">All Categories</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.category_id}">${category.category_name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3 col-md-6">
                        <label class="form-label">Product (optional)</label>
                        <select name="productId" class="form-select">
                            <option value="">All Products</option>
                            <c:forEach items="${products}" var="product">
                                <option value="${product.product_id}">${product.product_name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">Generate Report</button>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty reportData}">
        <div class="card">
            <div class="modal-header">
                <h5>${reportTitle} (${startDate} to ${endDate})</h5>
            </div>
            <div class="modal-body">
                <div class="table-container">
                    <c:choose>
                        <c:when test="${reportTitle eq 'Inventory Report'}">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Product Name</th>
                                        <th>Category</th>
                                        <th>Weight</th>
                                        <th>Quantity</th>
                                        <th>Expiry Date</th>
                                        <th>Arrival Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${reportData}" var="row">
                                        <tr>
                                            <td>${row[0]}</td>
                                            <td>${row[1]}</td>
                                            <td>${row[2]}</td>
                                            <td>${row[3]}</td>
                                            <td>${row[4]}</td>
                                            <td>${row[5]}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:when test="${reportTitle eq 'Stock Movement Report'}">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Product Name</th>
                                        <th>Category</th>
                                        <th>Stock In</th>
                                        <th>Stock Out</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${reportData}" var="row">
                                        <tr>
                                            <td>${row[0]}</td>
                                            <td>${row[1]}</td>
                                            <td>${row[2]}</td>
                                            <td>${row[3]}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                    </c:choose>
                </div>

                <div class="mt-3">
                    <form action="ReportServlet" method="post">
                        <input type="hidden" name="action" value="export">
                        <input type="hidden" name="reportType" value="${param.reportType}">
                        <input type="hidden" name="startDate" value="${param.startDate}">
                        <input type="hidden" name="endDate" value="${param.endDate}">
                        <input type="hidden" name="categoryId" value="${param.categoryId}">
                        <input type="hidden" name="productId" value="${param.productId}">
                        <button type="submit" class="btn btn-secondary">Export to CSV</button>
                    </form>
                </div>
            </div>
        </div>
    </c:if>
</div>
