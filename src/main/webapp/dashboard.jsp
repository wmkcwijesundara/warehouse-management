<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.warehouse.config.DBConnection" %>
<%@ page import="java.util.*" %>
<%@ page import="com.warehouse.dao.ProductDAO" %>
<%@ page import="com.warehouse.dao.InventoryDAO" %>

<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="Dashboard Overview" />
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
        
        // Get product count
        Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM products");
        if (rs1.next()) productCount = rs1.getInt(1);
        
        // Get low stock count
        List lowStockProducts = productDAO.getLowStockProducts();
        lowStockCount = lowStockProducts.size();
        
        // Get total stock
        ResultSet rs2 = stmt.executeQuery("SELECT COALESCE(SUM(quantity), 0) FROM inventory");
        if (rs2.next()) totalStock = rs2.getInt(1);
        
        // Get available stock (not expired)
        ResultSet rs3 = stmt.executeQuery("SELECT COALESCE(SUM(quantity), 0) FROM inventory WHERE expiry_date > CURDATE() OR expiry_date IS NULL");
        if (rs3.next()) availableStock = rs3.getInt(1);
        
        // Get total sales (mock data - adjust based on your schema)
        ResultSet rs4 = stmt.executeQuery("SELECT COALESCE(SUM(quantity), 0) FROM stock_out");
        if (rs4.next()) {
            totalSales = rs4.getInt(1) * 10.5; // Mock calculation
            salesReturn = rs4.getInt(1);
        }
        
        // Get purchases (stock in)
        ResultSet rs5 = stmt.executeQuery("SELECT COALESCE(COUNT(*), 0) FROM stock_in WHERE status = 'approved'");
        if (rs5.next()) purchases = rs5.getInt(1);
        
        // Total purchases value
        totalPurchases = purchases * 8.2; // Mock calculation
        
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<style>
    * {
        font-family: 'Inter', 'Poppins', sans-serif;
    }
    
    .dashboard-container {
        padding: 0;
        max-width: 100%;
    }
    
    .stat-card {
        background: white;
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        transition: all 0.2s ease;
        height: 100%;
        border: 1px solid #e5e7eb;
        display: flex;
        flex-direction: column;
    }
    
    .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        border-color: #16a34a;
    }
    
    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 16px;
        font-size: 22px;
        color: white;
    }
    
    .stat-icon.green {
        background: #16a34a;
    }
    
    .stat-icon.green-light {
        background: #22c55e;
    }
    
    .stat-icon.green-dark {
        background: #15803d;
    }
    
    .stat-icon.green-accent {
        background: #10b981;
    }
    
    .stat-label {
        font-size: 13px;
        color: #6b7280;
        font-weight: 500;
        margin-bottom: 8px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .stat-value {
        font-size: 28px;
        font-weight: 700;
        color: #1f2937;
        font-family: 'Poppins', sans-serif;
        line-height: 1.2;
    }
    
    .sales-overview-card {
        background: white;
        border-radius: 12px;
        padding: 28px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        border: 1px solid #e5e7eb;
        margin-bottom: 24px;
    }
    
    .sales-overview-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 24px;
        flex-wrap: wrap;
        gap: 16px;
    }
    
    .sales-overview-title {
        font-size: 18px;
        font-weight: 600;
        color: #1f2937;
        font-family: 'Poppins', sans-serif;
        margin: 0;
    }
    
    .sales-total {
        font-size: 32px;
        font-weight: 700;
        color: #1f2937;
        font-family: 'Poppins', sans-serif;
        margin: 12px 0 0 0;
        line-height: 1.2;
    }
    
    .time-selector {
        display: flex;
        gap: 8px;
        margin-bottom: 24px;
        flex-wrap: wrap;
    }
    
    .time-btn {
        padding: 8px 16px;
        border: 1px solid #e5e7eb;
        background: white;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 500;
        color: #6b7280;
        cursor: pointer;
        transition: all 0.2s;
        font-family: 'Inter', sans-serif;
    }
    
    .time-btn:hover {
        background: #f9fafb;
        border-color: #d1d5db;
    }
    
    .time-btn.active {
        background: #16a34a;
        color: white;
        border-color: #16a34a;
    }
    
    .chart-container {
        position: relative;
        height: 300px;
        margin-top: 24px;
    }
    
    .section-title {
        font-size: 16px;
        font-weight: 600;
        color: #1f2937;
        margin-bottom: 20px;
        font-family: 'Poppins', sans-serif;
    }
    
    .form-select {
        border: 1px solid #e5e7eb;
        border-radius: 6px;
        padding: 8px 12px;
        font-size: 13px;
        font-family: 'Inter', sans-serif;
    }
    
    .form-select:focus {
        border-color: #16a34a;
        box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.1);
    }
</style>

<div class="dashboard-container">
    <!-- Summary Cards -->
    <div class="row g-3 mb-4">
        <div class="col-lg-3 col-md-6 col-sm-6 mb-3">
            <div class="stat-card">
                <div class="stat-icon green">
                    <i class="bi bi-tag"></i>
                </div>
                <div class="stat-label">Total Sales</div>
                <div class="stat-value">$<%= String.format("%.2f", totalSales) %></div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 col-sm-6 mb-3">
            <div class="stat-card">
                <div class="stat-icon green-light">
                    <i class="bi bi-truck"></i>
                </div>
                <div class="stat-label">Total Purchases</div>
                <div class="stat-value">$<%= String.format("%.2f", totalPurchases) %></div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 col-sm-6 mb-3">
            <div class="stat-card">
                <div class="stat-icon green-accent">
                    <i class="bi bi-arrow-return-left"></i>
                </div>
                <div class="stat-label">Sales Return</div>
                <div class="stat-value"><%= salesReturn %></div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 col-sm-6 mb-3">
            <div class="stat-card">
                <div class="stat-icon green-dark">
                    <i class="bi bi-cart"></i>
                </div>
                <div class="stat-label">Purchases</div>
                <div class="stat-value"><%= purchases %></div>
            </div>
        </div>
    </div>

    <!-- Sales Overview Section -->
    <div class="row">
        <div class="col-lg-8 mb-4">
            <div class="sales-overview-card">
                <div class="sales-overview-header">
                    <div>
                        <h3 class="sales-overview-title">Sales Overview</h3>
                        <div class="sales-total">$<%= String.format("%.2f", totalSales) %></div>
                    </div>
                    <div>
                        <select class="form-select" style="width: auto; min-width: 180px;">
                            <option>Last year (2023)</option>
                            <option>This year (2024)</option>
                        </select>
                    </div>
                </div>
                
                <div class="time-selector">
                    <button class="time-btn active">12 Months</button>
                    <button class="time-btn">30 days</button>
                    <button class="time-btn">7 days</button>
                    <button class="time-btn">24 hours</button>
                </div>
                
                <div class="chart-container">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4 mb-4">
            <div class="sales-overview-card">
                <h4 class="section-title">Recent Activity</h4>
                <div class="list-group list-group-flush">
                    <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid #e5e7eb !important;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div style="font-weight: 500; color: #1f2937; font-size: 14px;">Stock In</div>
                                <div style="font-size: 12px; color: #6b7280;">Today, 10:30 AM</div>
                            </div>
                            <span class="badge rounded-pill" style="background: #16a34a;">+500</span>
                        </div>
                    </div>
                    <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid #e5e7eb !important;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div style="font-weight: 500; color: #1f2937; font-size: 14px;">Stock Out</div>
                                <div style="font-size: 12px; color: #6b7280;">Today, 09:15 AM</div>
                            </div>
                            <span class="badge rounded-pill" style="background: #22c55e;">-250</span>
                        </div>
                    </div>
                    <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid #e5e7eb !important;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div style="font-weight: 500; color: #1f2937; font-size: 14px;">New Order</div>
                                <div style="font-size: 12px; color: #6b7280;">Yesterday, 4:20 PM</div>
                            </div>
                            <span class="badge rounded-pill" style="background: #10b981;">New</span>
                        </div>
                    </div>
                    <div class="list-group-item border-0 px-0 py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div style="font-weight: 500; color: #1f2937; font-size: 14px;">Product Added</div>
                                <div style="font-size: 12px; color: #6b7280;">Yesterday, 2:10 PM</div>
                            </div>
                            <span class="badge rounded-pill" style="background: #15803d;">+1</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Inventory Stats -->
    <div class="row g-3">
        <div class="col-md-4 mb-3">
            <div class="stat-card">
                <div class="stat-icon green">
                    <i class="bi bi-box-seam"></i>
                </div>
                <div class="stat-label">Total Products</div>
                <div class="stat-value"><%= productCount %></div>
                <div style="margin-top: 12px; font-size: 12px; color: #6b7280;">
                    <i class="bi bi-arrow-up text-success"></i> 5% from last month
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="stat-card">
                <div class="stat-icon green-light">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="stat-label">Available Stock</div>
                <div class="stat-value"><%= availableStock %> kg</div>
                <div style="margin-top: 12px; font-size: 12px; color: #6b7280;">
                    <%= totalStock > 0 ? String.format("%.1f", (availableStock * 100.0 / totalStock)) : 0 %>% of total
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="stat-card">
                <div class="stat-icon green-dark">
                    <i class="bi bi-exclamation-triangle"></i>
                </div>
                <div class="stat-label">Low Stock Items</div>
                <div class="stat-value"><%= lowStockCount %></div>
                <div style="margin-top: 12px; font-size: 12px; color: #6b7280;">
                    Needs replenishment
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Sales Chart
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
                        backgroundColor: '#16a34a',
                        borderRadius: 8,
                        borderSkipped: false,
                    },
                    {
                        label: 'Expense',
                        data: [320, 380, 350, 420, 480, 450, 490, 470, 440, 400, 430, 460],
                        backgroundColor: '#22c55e',
                        borderRadius: 8,
                        borderSkipped: false,
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
                            padding: 15,
                            font: {
                                family: 'Inter',
                                size: 12
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 12,
                        titleFont: {
                            family: 'Inter',
                            size: 13
                        },
                        bodyFont: {
                            family: 'Inter',
                            size: 12
                        },
                        cornerRadius: 8
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 100,
                            font: {
                                family: 'Inter',
                                size: 11
                            },
                            color: '#6b7280'
                        },
                        grid: {
                            color: '#e5e7eb',
                            drawBorder: false
                        }
                    },
                    x: {
                        ticks: {
                            font: {
                                family: 'Inter',
                                size: 11
                            },
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
    
    // Time selector buttons
    const timeButtons = document.querySelectorAll('.time-btn');
    timeButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            timeButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
});
</script>
