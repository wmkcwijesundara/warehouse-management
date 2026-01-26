<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Stock Out" />
    <jsp:param name="pageTitle" value="New Stock Out Request" />
    <jsp:param name="activePage" value="orders" />
</jsp:include>

<style>
    .loading {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        z-index: 9999;
        justify-content: center;
        align-items: center;
    }
    .loading-content {
        background: white;
        padding: 20px;
        border-radius: 8px;
    }
    .stock-error {
        color: var(--danger);
        font-size: 0.8rem;
        display: none;
        margin-top: 4px;
    }
    .available-qty {
        font-weight: 600;
        color: var(--primary-color);
    }
</style>

<div class="loading">
    <div class="loading-content">
        <div class="spinner-border text-primary" role="status">
            <span class="sr-only">Loading...</span>
        </div>
        <p class="mt-2">Processing your request...</p>
    </div>
</div>

<div>
    <h2 class="page-header mb-4">New Stock Out Request</h2>

    <div id="messageArea" style="display: none;"></div>

    <div class="card">
        <div class="modal-header">
            <h5>Stock Out Details</h5>
        </div>
        <div class="modal-body">
            <form id="stockOutForm">
                <input type="hidden" name="action" value="create">

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="customer_id" class="form-label">Customer</label>
                        <select name="customerId" class="form-select" required>
                            <option value="">Select Customer</option>
                            <c:forEach var="customer" items="${customerList}">
                                <option value="${customer.customerId}">${customer.name}</option>
                            </c:forEach>
                        </select>
                        <div class="stock-error" id="customerError">Please select a customer</div>
                    </div>
                    <div class="col-md-4">
                        <label for="dispatch_date" class="form-label">Dispatch Date</label>
                        <input type="date" name="dispatch_date" class="form-control" required>
                        <div class="stock-error" id="dateError">Please select a dispatch date</div>
                    </div>
                    <div class="col-md-4">
                        <label for="order_id" class="form-label">Order ID (Optional)</label>
                        <input type="number" name="orderId" class="form-control">
                    </div>
                </div>

                <div class="mb-3">
                    <button type="button" class="btn btn-secondary" onclick="addRow()">Add New Item</button>
                </div>

                <div class="table-container">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Product Name</th>
                                <th>Product Weight</th>
                                <th>Available Qty</th>
                                <th>Request Qty</th>
                                <th>Expiry Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="stockTableBody">
                            <tr data-row-id="0">
                                <td>
                                    <select name="productId" class="form-select product-select" required>
                                        <option value="">Select Product</option>
                                        <c:forEach var="product" items="${productList}">
                                            <option value="${product.productId}" data-weight="${product.weightId}">${product.productName}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="stock-error" id="productError_0">Please select a product</div>
                                </td>
                                <td>
                                    <select name="weightId" class="form-select weight-select" required>
                                        <option value="">Select Weight</option>
                                        <c:forEach var="weight" items="${weightList}">
                                            <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                                        </c:forEach>
                                    </select>
                                    <div class="stock-error" id="weightError_0">Please select a weight</div>
                                </td>
                                <td>
                                    <span class="available-qty">0</span>
                                </td>
                                <td>
                                    <input type="number" name="quantity" class="form-control qty-input" min="1" required>
                                    <div class="stock-error" id="qtyError_0">Invalid quantity</div>
                                </td>
                                <td>
                                    <input type="date" name="expire_date" class="form-control" required>
                                    <div class="stock-error" id="expireError_0">Please select expiry date</div>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">Remove</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="StockOut" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Submit Request</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const inventoryData = JSON.parse('${inventoryListJson}');
    const productWeightMap = {};
    let rowCount = 1;

    <c:forEach var="product" items="${productList}">
        productWeightMap[${product.productId}] = ${product.weightId};
    </c:forEach>

    $(document).ready(function() {
        $(document).on('change', '.product-select', function() {
            const row = $(this).closest('tr');
            const productId = $(this).val();
            const weightSelect = row.find('.weight-select');
            const availableSpan = row.find('.available-qty');
            const qtyInput = row.find('.qty-input');

            weightSelect.val('');
            availableSpan.text('0');
            qtyInput.val('').removeAttr('max');

            if (productId) {
                const weightId = productWeightMap[productId];
                if (weightId) {
                    weightSelect.val(weightId);
                }

                let availableQty = 0;
                inventoryData.forEach(item => {
                    if (item.productId == productId) {
                        availableQty += item.quantity;
                    }
                });

                availableSpan.text(availableQty);
                if (availableQty > 0) {
                    qtyInput.attr('max', availableQty);
                }
            }
        });

        $('#stockOutForm').on('submit', function(e) {
            e.preventDefault();
            submitStockOutForm();
        });
    });

    function addRow() {
        const tableBody = $('#stockTableBody');
        const newRow = `
            <tr data-row-id="${rowCount}">
                <td>
                    <select name="productId" class="form-select product-select" required>
                        <option value="">Select Product</option>
                        <c:forEach var="product" items="${productList}">
                            <option value="${product.productId}" data-weight="${product.weightId}">${product.productName}</option>
                        </c:forEach>
                    </select>
                    <div class="stock-error" id="productError_${rowCount}">Please select a product</div>
                </td>
                <td>
                    <select name="weightId" class="form-select weight-select" required>
                        <option value="">Select Weight</option>
                        <c:forEach var="weight" items="${weightList}">
                            <option value="${weight.weightId}">${weight.weightValue} Kg</option>
                        </c:forEach>
                    </select>
                    <div class="stock-error" id="weightError_${rowCount}">Please select a weight</div>
                </td>
                <td>
                    <span class="available-qty">0</span>
                </td>
                <td>
                    <input type="number" name="quantity" class="form-control qty-input" min="1" required>
                    <div class="stock-error" id="qtyError_${rowCount}">Invalid quantity</div>
                </td>
                <td>
                    <input type="date" name="expire_date" class="form-control" required>
                    <div class="stock-error" id="expireError_${rowCount}">Please select expiry date</div>
                </td>
                <td>
                    <button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">Remove</button>
                </td>
            </tr>
        `;
        tableBody.append(newRow);
        rowCount++;
    }

    function removeRow(button) {
        if ($('#stockTableBody tr').length > 1) {
            $(button).closest('tr').remove();
        } else {
            alert('At least one item is required');
        }
    }

    function validateForm() {
        let isValid = true;
        const today = new Date().toISOString().split('T')[0];
        $('.stock-error').hide();

        if (!$('select[name="customerId"]').val()) {
            $('#customerError').show();
            isValid = false;
        }

        const dispatchDate = $('input[name="dispatch_date"]').val();
        if (!dispatchDate) {
            $('#dateError').show();
            isValid = false;
        } else if (dispatchDate < today) {
            $('#dateError').text('Dispatch date cannot be in the past').show();
            isValid = false;
        }

        $('#stockTableBody tr').each(function(index) {
            const row = $(this);
            const productSelect = row.find('.product-select');
            const weightSelect = row.find('.weight-select');
            const qtyInput = row.find('.qty-input');
            const dateInput = row.find('input[name="expire_date"]');
            const availableQty = parseInt(row.find('.available-qty').text()) || 0;
            const requestedQty = parseInt(qtyInput.val()) || 0;

            if (!productSelect.val()) {
                row.find('#productError_' + index).show();
                isValid = false;
            }
            if (!weightSelect.val()) {
                row.find('#weightError_' + index).show();
                isValid = false;
            }
            if (!qtyInput.val() || requestedQty < 1) {
                row.find('#qtyError_' + index).text('Quantity must be at least 1').show();
                isValid = false;
            } else if (requestedQty > availableQty) {
                row.find('#qtyError_' + index).text('Not enough stock available').show();
                isValid = false;
            }
            if (!dateInput.val()) {
                row.find('#expireError_' + index).show();
                isValid = false;
            }
        });

        return isValid;
    }

    function submitStockOutForm() {
        if (!validateForm()) {
            showMessage('Please correct the errors in the form', 'danger');
            return;
        }

        $('.loading').show();
        let formData = 'action=create';
        formData += '&customerId=' + encodeURIComponent($('select[name="customerId"]').val());
        formData += '&dispatch_date=' + encodeURIComponent($('input[name="dispatch_date"]').val());

        const orderId = $('input[name="orderId"]').val();
        if (orderId) {
            formData += '&orderId=' + encodeURIComponent(orderId);
        }

        $('#stockTableBody tr').each(function(index) {
            formData += '&productId=' + encodeURIComponent($(this).find('select[name="productId"]').val());
            formData += '&weightId=' + encodeURIComponent($(this).find('select[name="weightId"]').val());
            formData += '&quantity=' + encodeURIComponent($(this).find('input[name="quantity"]').val());
            formData += '&expire_date=' + encodeURIComponent($(this).find('input[name="expire_date"]').val());
        });

        $.ajax({
            url: 'StockOut',
            type: 'POST',
            data: formData,
            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
            success: function(response) {
                $('.loading').hide();
                if (response.success) {
                    showMessage('Stock out request created successfully! Redirecting...', 'success');
                    setTimeout(function() {
                        window.location.href = 'StockOut?action=view&id=' + response.stockOutId;
                    }, 2000);
                } else {
                    showMessage(response.message || 'Error processing request', 'danger');
                }
            },
            error: function(xhr, status, error) {
                $('.loading').hide();
                let errorMsg = 'Error processing request';
                try {
                    const response = JSON.parse(xhr.responseText);
                    errorMsg = response.message || errorMsg;
                } catch (e) {
                    errorMsg = xhr.statusText || errorMsg;
                }
                showMessage(errorMsg, 'danger');
            }
        });
    }

    function showMessage(message, type) {
        const messageArea = $('#messageArea');
        messageArea.html(`
            <div class="alert alert-${type} alert-dismissible fade show">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `);
        messageArea.show();
    }
</script>
