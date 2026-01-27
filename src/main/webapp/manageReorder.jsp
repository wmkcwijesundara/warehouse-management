<%@ page import="java.util.List" %>
<%@ page import="com.warehouse.models.ReorderItem" %>
<%@ page import="com.warehouse.dao.ProductDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<ReorderItem> reorderList = (List<ReorderItem>) request.getAttribute("reorderList");
    ProductDAO productDAO = new ProductDAO();
%>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Manage Reorders" />
    <jsp:param name="pageTitle" value="Reorder Management" />
    <jsp:param name="activePage" value="manageReorder" />
</jsp:include>

<div>
    <h2 class="page-header mb-4">Reorder Management</h2>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Reorder ID</th>
                    <th>Product Name</th>
                    <th>Quantity</th>
                    <th>Reorder Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (ReorderItem item : reorderList) {
                    String productName = productDAO.getProductById(item.getProductId()).getProductName();
                    String statusClass = "badge bg-primary";
                    if ("pending".equals(item.getStatus())) statusClass = "badge bg-warning";
                    else if ("approved".equals(item.getStatus())) statusClass = "badge bg-primary";
                    else if ("delivered".equals(item.getStatus())) statusClass = "badge bg-success";
                %>
                <tr data-id="<%= item.getReorderId() %>">
                    <td><%= item.getReorderId() %></td>
                    <td><%= productName %></td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= item.getReorderDate() %></td>
                    <td><span class="<%= statusClass %>"><%= item.getStatus() %></span></td>
                    <td>
                        <button class="btn btn-sm btn-warning updateBtn"
                                data-id="<%= item.getReorderId() %>"
                                data-status="<%= item.getStatus() %>">
                            Update
                        </button>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Update Modal -->
    <div class="modal fade" id="updateModal" tabindex="-1">
        <div class="modal-dialog">
            <form method="post" action="Reorder" class="modal-content">
                <input type="hidden" name="reorderId" id="reorderId">
                <div class="modal-header">
                    <h5>Update Reorder Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="status" class="form-label">Status</label>
                        <select name="status" id="status" class="form-select" required>
                            <option value="pending">Pending</option>
                            <option value="approved">Approved</option>
                            <option value="delivered">Delivered</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        $('.updateBtn').click(function () {
            const id = $(this).data('id');
            const status = $(this).data('status');
            $('#reorderId').val(id);
            $('#status').val(status);
            new bootstrap.Modal(document.getElementById('updateModal')).show();
        });
    });
</script>

<jsp:include page="template/footer.jsp" />
