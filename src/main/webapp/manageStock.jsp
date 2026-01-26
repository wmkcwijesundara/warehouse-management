<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Stock Approvals" />
    <jsp:param name="pageTitle" value="Stock Approvals" />
    <jsp:param name="activePage" value="supply" />
</jsp:include>

<div>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="page-header mb-0">Stock Approvals</h2>
        <a class="custom-add-btn text-decoration-none" href="StockIn">Add Stock</a>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show">
            ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show">
            ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Supplier</th>
                    <th>Arrival Date</th>
                    <th>Created Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${Stocks}" var="stock">
                    <tr>
                        <td>${stock.id}</td>
                        <td>${stock.supplierName}</td>
                        <td>${stock.arrivalDate}</td>
                        <td>${stock.createdDate}</td>
                        <td>
                            <span class="badge 
                                <c:choose>
                                    <c:when test="${stock.status == 'pending'}">bg-warning</c:when>
                                    <c:when test="${stock.status == 'approved'}">bg-primary</c:when>
                                    <c:when test="${stock.status == 'rejected'}">bg-danger</c:when>
                                    <c:otherwise>bg-secondary</c:otherwise>
                                </c:choose>
                            ">${stock.status}</span>
                        </td>
                        <td>
                            <form action="StockIn" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="view">
                                <input type="hidden" name="id" value="${stock.id}">
                                <input type="hidden" name="disableUpdate" value="${stock.status != 'pending'}">
                                <button type="submit" class="btn btn-sm btn-primary">View</button>
                            </form>

                            <c:if test="${stock.status == 'pending'}">
                                <form action="Stocks" method="post" style="display: inline;">
                                    <input type="hidden" name="stockInId" value="${stock.id}">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-sm btn-primary">Approve</button>
                                </form>

                                <form action="Stocks" method="post" style="display: inline;">
                                    <input type="hidden" name="stockInId" value="${stock.id}">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
