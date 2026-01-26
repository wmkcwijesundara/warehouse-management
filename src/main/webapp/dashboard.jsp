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
    }
    
    .stat-card {
        background: white;
        border-radius: 16px;
        padding: 24px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        transition: all 0.3s ease;
        height: 100%;
        border: 1px solid #e2e8f0;
    }
    
    .stat-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
    }
    
    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 16px;
        font-size: 24px;
        color: white;
    }
    
    .stat-icon.blue {
        background: linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%);
    }
    
    .stat-icon.pink {
        background: linear-gradient(135deg, #f472b6 0%, #ec4899 100%);
    }
    
    .stat-icon.orange {
        background: linear-gradient(135deg, #fb923c 0%, #f97316 100%);
    }
    
    .stat-icon.purple {
        background: linear-gradient(135deg, #a78bfa 0%, #8b5cf6 100%);
    }
    
    .stat-label {
        font-size: 14px;
        color: #64748b;
        font-weight: 500;
        margin-bottom: 8px;
    }
    
    .stat-value {
        font-size: 28px;
        font-weight: 700;
        color: #1e293b;
        font-family: 'Poppins', sans-serif;
    }
    
    .sales-overview-card {
        background: white;
        border-radius: 16px;
        padding: 24px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        border: 1px solid #e2e8f0;
        margin-bottom: 24px;
    }
    
    .sales-overview-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }
    
    .sales-overview-title {
        font-size: 20px;
        font-weight: 600;
        color: #1e293b;
        font-family: 'Poppins', sans-serif;
    }
    
    .sales-total {
        font-size: 36px;
        font-weight: 700;
        color: #1e293b;
        font-family: 'Poppins', sans-serif;
        margin: 16px 0;
    }
    
    .time-selector {
        display: flex;
        gap: 8px;
        margin-bottom: 24px;
    }
    
    .time-btn {
        padding: 8px 16px;
        border: 1px solid #e2e8f0;
        background: white;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 500;
        color: #64748b;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .time-btn:hover {
        background: #f1f5f9;
        border-color: #cbd5e1;
    }
    
    .time-btn.active {
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
        color: white;
        border-color: transparent;
    }
    
    .chart-container {
        position: relative;
        height: 300px;
        margin-top: 24px;
    }
    
    .section-title {
        font-size: 18px;
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 20px;
        font-family: 'Poppins', sans-serif;
    }
</style>

<div class="dashboard-container">
    <!-- Summary Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-3 col-sm-6">
            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="bi bi-tag"></i>
                </div>
                <div class="stat-label">Total Sales</div>
                <div class="stat-value">$<%= String.format("%.2f", totalSales) %></div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="stat-card">
                <div class="stat-icon pink">
                    <i class="bi bi-truck"></i>
                </div>
                <div class="stat-label">Total Purchases</div>
                <div class="stat-value">$<%= String.format("%.2f", totalPurchases) %></div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="bi bi-arrow-return-left"></i>
                </div>
                <div class="stat-label">Sales Return</div>
                <div class="stat-value"><%= salesReturn %></div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="stat-card">
                <div class="stat-icon orange">
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
                        <select class="form-select" style="width: auto; display: inline-block; border-radius: 8px; border: 1px solid #e2e8f0;">
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
                    <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid #e2e8f0 !important;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div style="font-weight: 500; color: #1e293b; font-size: 14px;">Stock In</div>
                                <div style="font-size: 12px; color: #64748b;">Today, 10:30 AM</div>
                            </div>
                            <span class="badge bg-primary rounded-pill">+500</span>
                        </div>
                    </div>
                    <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid #e2e8f0 !important;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div style="font-weight: 500; color: #1e293b; font-size: 14px;">Stock Out</div>
                                <div style="font-size: 12px; color: #64748b;">Today, 09:15 AM</div>
                            </div>
                            <span class="badge bg-success rounded-pill">-250</span>
                        </div>
                    </div>
                    <div class="list-group-item border-0 px-0 py-3" style="border-bottom: 1px solid #e2e8f0 !important;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div style="font-weight: 500; color: #1e293b; font-size: 14px;">New Order</div>
                                <div style="font-size: 12px; color: #64748b;">Yesterday, 4:20 PM</div>
                            </div>
                            <span class="badge bg-info rounded-pill">New</span>
                        </div>
                    </div>
                    <div class="list-group-item border-0 px-0 py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div style="font-weight: 500; color: #1e293b; font-size: 14px;">Product Added</div>
                                <div style="font-size: 12px; color: #64748b;">Yesterday, 2:10 PM</div>
                            </div>
                            <span class="badge bg-warning rounded-pill">+1</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Inventory Stats -->
    <div class="row g-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon purple">
                    <i class="bi bi-box-seam"></i>
                </div>
                <div class="stat-label">Total Products</div>
                <div class="stat-value"><%= productCount %></div>
                <div style="margin-top: 12px; font-size: 12px; color: #64748b;">
                    <i class="bi bi-arrow-up text-success"></i> 5% from last month
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="stat-label">Available Stock</div>
                <div class="stat-value"><%= availableStock %> kg</div>
                <div style="margin-top: 12px; font-size: 12px; color: #64748b;">
                    <%= totalStock > 0 ? String.format("%.1f", (availableStock * 100.0 / totalStock)) : 0 %>% of total
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon orange">
                    <i class="bi bi-exclamation-triangle"></i>
                </div>
                <div class="stat-label">Low Stock Items</div>
                <div class="stat-value"><%= lowStockCount %></div>
                <div style="margin-top: 12px; font-size: 12px; color: #64748b;">
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
                        backgroundColor: 'rgba(99, 102, 241, 0.8)',
                        borderRadius: 8,
                        borderSkipped: false,
                    },
                    {
                        label: 'Expense',
                        data: [320, 380, 350, 420, 480, 450, 490, 470, 440, 400, 430, 460],
                        backgroundColor: 'rgba(251, 146, 60, 0.8)',
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
                            color: '#64748b'
                        },
                        grid: {
                            color: '#e2e8f0',
                            drawBorder: false
                        }
                    },
                    x: {
                        ticks: {
                            font: {
                                family: 'Inter',
                                size: 11
                            },
                            color: '#64748b'
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
