<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Order Management" />
    <jsp:param name="pageTitle" value="Order Management" />
    <jsp:param name="activePage" value="orders" />
</jsp:include>

<style>
    .badge-pending { background-color: var(--warning) !important; color: #fff; }
    .badge-approved { background-color: var(--primary-green) !important; color: #fff; }
    .badge-dispatched { background-color: var(--success) !important; color: #fff; }
    .badge-rejected { background-color: var(--danger) !important; color: #fff; }
</style>

<div>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a class="custom-add-btn text-decoration-none" href="StockOut?action=new">Add New Order</a>
    </div>

    <!-- Tab Buttons -->
    <div class="mb-4 text-center">
        <button class="tab-btn me-2" data-tab="pending" onclick="showTab('pending')">Pending</button>
        <button class="tab-btn me-2" data-tab="picking" onclick="showTab('picking')">Picking</button>
        <button class="tab-btn me-2" data-tab="packing" onclick="showTab('packing')">Packing</button>
        <button class="tab-btn" data-tab="delivered" onclick="showTab('delivered')">Delivered</button>
    </div>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Dispatch Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="stockOut" items="${stockOutList}">
                    <tr>
                        <td>${stockOut.id}</td>
                        <td>${stockOut.customerName}</td>
                        <td>${stockOut.dispatchDate}</td>
                        <td>
                            <span class="badge badge-${stockOut.status}">
                                ${stockOut.status}
                            </span>
                        </td>
                        </td>
                        <td>
                            <a href="StockOut?action=view&id=${stockOut.id}"
                               class="btn btn-sm btn-info">View</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</div>