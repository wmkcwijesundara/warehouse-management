<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.warehouse.config.DBConnection" %>
<%@ page import="java.util.*" %>
<%@ page import="com.warehouse.dao.ProductDAO" %>
<%@ page import="com.warehouse.dao.InventoryDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Dashboard" />
    <jsp:param name="pageTitle" value="Dashboard Overview" />
    <jsp:param name="activePage" value="dashboard" />
</jsp:include>

<%
    Connection conn = DBConnection.getConnection();
    int productCount = 0, lowStockCount = 0, totalStock = 0, availableStock = 0;
    double totalSales = 0.0, totalPurchases = 0.0;
    int salesReturn = 0, purchases = 0;
    
    try {
        ProductDAO productDAO = new ProductDAO();
        InventoryDAO inventoryDAO = new InventoryDAO();
        
        Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM products");
        if (rs1.next()) productCount = rs1.getInt(1);
        
        List lowStockProducts = productDAO.getLowStockProducts();
        lowStockCount = lowStockProducts.size();
        
        ResultSet rs2 = stmt.executeQuery("SELECT COALESCE(SUM(quantity), 0) FROM inventory");
        if (rs2.next()) totalStock = rs2.getInt(1);
        
        ResultSet rs3 = stmt.executeQuery("SELECT COALESCE(SUM(quantity), 0) FROM inventory WHERE expiry_date > CURDATE() OR expiry_date IS NULL");
        if (rs3.next()) availableStock = rs3.getInt(1);
        
        ResultSet rs4 = stmt.executeQuery("SELECT COALESCE(SUM(quantity), 0) FROM stock_out");
        if (rs4.next()) {
            totalSales = rs4.getInt(1) * 10.5;
            salesReturn = rs4.getInt(1);
        }
        
        ResultSet rs5 = stmt.executeQuery("SELECT COALESCE(COUNT(*), 0) FROM stock_in WHERE status = 'approved'");
        if (rs5.next()) purchases = rs5.getInt(1);
        
        totalPurchases = purchases * 8.2;
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<style>
    .stat-card {
        background: var(--bg);
        border: 1px solid var(--border);
        border-radius: 8px;
        padding: 20px;
        height: 100%;
    }
    
    .stat-icon {
        width: 40px;
        height: 40px;
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 12px;
        font-size: 20px;
        color: white;
        background: var(--primary-green);
    }
    
    .stat-label {
        font-size: 13px;
        color: var(--text-secondary);
        font-weight: 500;
        margin-bottom: 8px;
        text-transform: uppercase;
        letter-spacing: 0.02em;
    }
    
    .stat-value {
        font-size: 24px;
        font-weight: 600;
        color: var(--text-primary);
        line-height: 1.2;
    }
    
    .sales-overview-card {
        background: var(--bg);
        border: 1px solid var(--border);
        border-radius: 8px;
        padding: 24px;
    }
    
    .sales-overview-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 24px;
    }
    
    .sales-overview-title {
        font-size: 16px;
        font-weight: 600;
        color: var(--text-primary);
        margin: 0 0 8px 0;
    }
    
    .sales-total {
        font-size: 28px;
        font-weight: 600;
        color: var(--text-primary);
        margin: 0;
    }
    
    .time-selector {
        display: flex;
        gap: 8px;
        margin-bottom: 24px;
    }
    
    .chart-container {
        position: relative;
        height: 280px;
        margin-top: 16px;
    }
    
    .section-title {
        font-size: 16px;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 16px;
    }
</style>

<!-- Summary Cards -->
<div class="row g-3 mb-4">
    <div class="col-lg-3 col-md-6">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="bi bi-tag"></i>
            </div>
            <div class="stat-label">Total Sales</div>
            <div class="stat-value">$<%= String.format("%.2f", totalSales) %></div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="bi bi-truck"></i>
            </div>
            <div class="stat-label">Total Purchases</div>
            <div class="stat-value">$<%= String.format("%.2f", totalPurchases) %></div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="bi bi-arrow-return-left"></i>
            </div>
            <div class="stat-label">Sales Return</div>
            <div class="stat-value"><%= salesReturn %></div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="bi bi-cart"></i>
            </div>
            <div class="stat-label">Purchases</div>
            <div class="stat-value"><%= purchases %></div>
        </div>
    </div>
</div>

<!-- Sales Overview Section -->
<div class="row mb-4">
    <div class="col-lg-8">
        <div class="sales-overview-card">
            <div class="sales-overview-header">
                <div>
                    <h3 class="sales-overview-title">Sales Overview</h3>
                    <div class="sales-total">$<%= String.format("%.2f", totalSales) %></div>
                </div>
                <div>
                    <select class="form-select" style="width: auto; min-width: 160px;">
                        <option>Last year (2023)</option>
                        <option>This year (2024)</option>
                    </select>
                </div>
            </div>
            
            <div class="time-selector">
                <button class="tab-btn active">12 Months</button>
                <button class="tab-btn">30 days</button>
                <button class="tab-btn">7 days</button>
                <button class="tab-btn">24 hours</button>
            </div>
            
            <div class="chart-container">
                <canvas id="salesChart"></canvas>
            </div>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="sales-overview-card">
            <h4 class="section-title">Recent Activity</h4>
            <div class="list-group list-group-flush">
                <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid var(--border) !important;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div style="font-weight: 500; color: var(--text-primary); font-size: 14px;">Stock In</div>
                            <div style="font-size: 12px; color: var(--text-secondary);">Today, 10:30 AM</div>
                        </div>
                        <span class="badge bg-primary rounded-pill">+500</span>
                    </div>
                </div>
                <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid var(--border) !important;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div style="font-weight: 500; color: var(--text-primary); font-size: 14px;">Stock Out</div>
                            <div style="font-size: 12px; color: var(--text-secondary);">Today, 09:15 AM</div>
                        </div>
                        <span class="badge bg-success rounded-pill">-250</span>
                    </div>
                </div>
                <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid var(--border) !important;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div style="font-weight: 500; color: var(--text-primary); font-size: 14px;">New Order</div>
                            <div style="font-size: 12px; color: var(--text-secondary);">Yesterday, 4:20 PM</div>
                        </div>
                        <span class="badge bg-info rounded-pill">New</span>
                    </div>
                </div>
                <div class="list-group-item border-0 px-0 py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div style="font-weight: 500; color: var(--text-primary); font-size: 14px;">Product Added</div>
                            <div style="font-size: 12px; color: var(--text-secondary);">Yesterday, 2:10 PM</div>
                        </div>
                        <span class="badge bg-warning rounded-pill">+1</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Inventory Stats -->
<div class="row g-3">
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="bi bi-box-seam"></i>
            </div>
            <div class="stat-label">Total Products</div>
            <div class="stat-value"><%= productCount %></div>
            <div style="margin-top: 12px; font-size: 12px; color: var(--text-secondary);">
                <i class="bi bi-arrow-up text-success"></i> 5% from last month
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="bi bi-check-circle"></i>
            </div>
            <div class="stat-label">Available Stock</div>
            <div class="stat-value"><%= availableStock %> kg</div>
            <div style="margin-top: 12px; font-size: 12px; color: var(--text-secondary);">
                <%= totalStock > 0 ? String.format("%.1f", (availableStock * 100.0 / totalStock)) : 0 %>% of total
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="bi bi-exclamation-triangle"></i>
            </div>
            <div class="stat-label">Low Stock Items</div>
            <div class="stat-value"><%= lowStockCount %></div>
            <div style="margin-top: 12px; font-size: 12px; color: var(--text-secondary);">
                Needs replenishment
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const ctx = document.getElementById('salesChart');
    if (ctx) {
        const salesChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [
                    {
                        label: 'Income',
                        data: [450, 520, 480, 610, 750, 680, 720, 690, 650, 580, 620, 700],
                        backgroundColor: '#10b981',
                        borderRadius: 4,
                    },
                    {
                        label: 'Expense',
                        data: [320, 380, 350, 420, 480, 450, 490, 470, 440, 400, 430, 460],
                        backgroundColor: '#6b7280',
                        borderRadius: 4,
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        labels: {
                            usePointStyle: true,
                            padding: 12,
                            font: { size: 12 }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 8,
                        titleFont: { size: 12 },
                        bodyFont: { size: 12 },
                        cornerRadius: 4
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 100,
                            font: { size: 11 },
                            color: '#6b7280'
                        },
                        grid: {
                            color: '#e5e7eb',
                            drawBorder: false
                        }
                    },
                    x: {
                        ticks: {
                            font: { size: 11 },
                            color: '#6b7280'
                        },
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    const timeButtons = document.querySelectorAll('.time-btn');
    timeButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            timeButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
});
</script>

<jsp:include page="template/footer.jsp" />
