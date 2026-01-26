<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.RequestDispatcher" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><%= request.getParameter("title") != null ? request.getParameter("title") : "Warehouse Management" %></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <!-- Google Fonts - Poppins and Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    :root {
      --sidebar-width: 260px;
      --header-height: 70px;
      --sidebar-bg: #ffffff;
      --sidebar-active-bg: #f0f4ff;
      --primary-color: #6366f1;
      --primary-dark: #4f46e5;
      --text-primary: #1e293b;
      --text-secondary: #64748b;
      --border-color: #e2e8f0;
      --bg-light: #f8fafc;
      --success: #10b981;
      --warning: #f59e0b;
      --danger: #ef4444;
      --info: #3b82f6;
    }

     body {
          font-family: 'Inter', 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
          background-color: var(--bg-light);
          color: var(--text-primary);
        }

    #sidebar {
      position: fixed;
      top: 0;
      left: 0;
      width: var(--sidebar-width);
      height: 100vh;
      background-color: var(--sidebar-bg);
      overflow-y: auto;
      z-index: 1001;
      box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
      border-right: 1px solid var(--border-color);
    }

    #sidebar .sidebar-header {
      color: var(--text-primary);
      padding: 20px;
      border-bottom: 1px solid var(--border-color);
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 80px;
    }

    #sidebar .sidebar-header p {
      color: white;
      font-weight: 600;
      font-size: 18px;
      margin: 0;
      font-family: 'Poppins', sans-serif;
    }

    #sidebar ul {
      list-style: none;
      padding-left: 0;
      margin: 0;
    }

    #sidebar ul li a {
      display: flex;
      align-items: center;
      color: var(--text-secondary);
      padding: 14px 20px;
      text-decoration: none;
      transition: all 0.3s ease;
      font-weight: 500;
      font-size: 14px;
      border-left: 3px solid transparent;
    }

    #sidebar ul li a i {
      margin-right: 12px;
      font-size: 18px;
      width: 20px;
    }

    #sidebar ul li a:hover {
      color: var(--primary-color);
      background-color: var(--sidebar-active-bg);
      border-left-color: var(--primary-color);
    }

    #sidebar ul li.active > a {
      color: var(--primary-color);
      background-color: var(--sidebar-active-bg);
      border-left-color: var(--primary-color);
      font-weight: 600;
    }

    #sidebar ul li .dropdown-toggle::after {
      margin-left: auto;
    }

    #sidebar ul li .collapse {
      background-color: #f8fafc;
    }

    #sidebar ul li .collapse li a {
      padding-left: 50px;
      font-size: 13px;
    }

    #header {
      position: fixed;
      top: 0;
      left: var(--sidebar-width);
      height: var(--header-height);
      width: calc(100% - var(--sidebar-width));
      background: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 30px;
      z-index: 1000;
      color: var(--text-primary);
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      border-bottom: 1px solid var(--border-color);
    }

    .header-left {
      display: flex;
      flex-direction: column;
    }

    .header-title {
      font-size: 24px;
      font-weight: 600;
      color: var(--text-primary);
      margin: 0;
      font-family: 'Poppins', sans-serif;
    }

    .header-date {
      font-size: 13px;
      color: var(--text-secondary);
      margin-top: 2px;
    }

    .header-center {
      flex: 1;
      max-width: 500px;
      margin: 0 30px;
    }

    .search-bar {
      position: relative;
    }

    .search-bar input {
      width: 100%;
      padding: 10px 15px 10px 45px;
      border: 1px solid var(--border-color);
      border-radius: 10px;
      font-size: 14px;
      background-color: var(--bg-light);
      transition: all 0.3s;
    }

    .search-bar input:focus {
      outline: none;
      border-color: var(--primary-color);
      background-color: white;
      box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
    }

    .search-bar i {
      position: absolute;
      left: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-secondary);
    }


    #content {
      position: absolute;
      top: var(--header-height);
      left: var(--sidebar-width);
      width: calc(100% - var(--sidebar-width));
      height: calc(100vh - var(--header-height));
      overflow-y: auto;
      padding: 20px;
      scrollbar-width: none; /* Firefox */
    }

    .sidebar-header {
      position: relative;
      min-height: 80px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-shadow: 0 0 5px rgba(0,0,0,0.2);
    }

    .header-right {
      display: flex;
      align-items: center;
      gap: 20px;
    }

    .notification-icon {
      position: relative;
      cursor: pointer;
      padding: 8px;
      border-radius: 8px;
      transition: background-color 0.3s;
    }

    .notification-icon:hover {
      background-color: var(--bg-light);
    }

    .notification-badge {
      position: absolute;
      top: 0;
      right: 0;
      background: var(--danger);
      color: white;
      border-radius: 50%;
      width: 20px;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 11px;
      font-weight: 600;
    }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 12px;
      cursor: pointer;
      padding: 6px 12px;
      border-radius: 10px;
      transition: background-color 0.3s;
    }

    .user-profile:hover {
      background-color: var(--bg-light);
    }

    .user-profile img {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      border: 2px solid var(--border-color);
    }

    .user-profile .user-info {
      display: flex;
      flex-direction: column;
    }

    .user-profile .user-name {
      color: var(--text-primary);
      font-weight: 600;
      font-size: 14px;
      margin: 0;
    }

    .user-profile .user-role {
      color: var(--text-secondary);
      font-size: 12px;
      margin: 0;
    }

    .logout-btn {
      margin: 20px;
      padding: 0 !important;
    }

    .logout-btn a {
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
      color: white !important;
      padding: 12px 20px;
      border-radius: 10px;
      font-weight: 600;
      transition: all 0.3s;
      border-left: none !important;
    }

    .logout-btn a:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
    }

    /* Scrollbar styling */
    #sidebar::-webkit-scrollbar {
      width: 6px;
    }

    #sidebar::-webkit-scrollbar-track {
      background: transparent;
    }

    #sidebar::-webkit-scrollbar-thumb {
      background: var(--border-color);
      border-radius: 3px;
    }

    #sidebar::-webkit-scrollbar-thumb:hover {
      background: var(--text-secondary);
    }
  </style>
</head>
<body>


<!-- Sidebar -->
<div id="sidebar">
  <div class="sidebar-header">
    <p class="mb-0">panze studio.</p>
  </div>


  <ul class="components">
    <li class="<%= "dashboard".equals(request.getParameter("activePage")) || "index".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="dashboard.jsp"><i class="bi bi-grid"></i> Dashboard</a>
    </li>
    <li class="<%= "inventory".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="Inventory"><i class="bi bi-box-seam"></i> Inventory</a>
    </li>
    <li class="<%= "supply".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="Stocks"><i class="bi bi-truck"></i> Supply</a>
    </li>
    <li class="<%= "orders".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="manageOrders.jsp"><i class="bi bi-cart"></i> Orders</a>
    </li>
    <li class="<%= "asn".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="ASNManagement"><i class="bi bi-file-earmark-text"></i> ASN Management</a>
    </li>
    <li>
      <a href="#moreSubmenu" data-bs-toggle="collapse" class="dropdown-toggle">
        <i class="bi bi-gear me-2"></i> More
      </a>
      <ul class="collapse list-unstyled" id="moreSubmenu">
        <li class="<%= "manageCategory".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageCategory"><i class="bi bi-tags"></i> Manage Category</a>
        </li>
        <li class="<%= "manageProduct".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageProduct"><i class="bi bi-box"></i> Manage Product</a>
        </li>
        <li class="<%= "manageSupplier".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageSupplier"><i class="bi bi-people"></i> Manage Supplier</a>
        </li>
        <li class="<%= "manageWeights".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageWeights"><i class="bi bi-speedometer"></i> Manage Weights</a>
        </li>
        <li class="<%= "manageZone".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageZone"><i class="bi bi-geo-alt"></i> Manage Zone</a>
        </li>
        <li class="<%= "manageRacks".equals(request.getParameter("activePage")) ? "active" : "" %>">
          <a href="manageRacks"><i class="bi bi-hdd-stack"></i> Manage Rack</a>
        </li>
        <li class="<%= "manageUser".equals(request.getParameter("activePage")) ? "active" : "" %>">
           <a href="manageUser.jsp"><i class="bi bi-people-fill"></i> Manage Users</a>
        </li>
      </ul>
    </li>
    <li class="<%= "reports".equals(request.getParameter("activePage")) ? "active" : "" %>">
      <a href="reports.jsp"><i class="bi bi-graph-up"></i> Reports</a>
    </li>
    <li class="logout-btn">
      <a href="login.jsp"><i class="bi bi-box-arrow-left"></i> Logout</a>
    </li>
  </ul>
</div>

<!-- Header -->
<nav id="header">
  <div class="header-left">
    <h1 class="header-title">Dashboard Overview</h1>
    <div class="header-date"><%= new java.text.SimpleDateFormat("dd MMMM, yyyy").format(new java.util.Date()) %></div>
  </div>
  
  <div class="header-center">
    <div class="search-bar">
      <i class="bi bi-search"></i>
      <input type="text" placeholder="Search sales operations">
    </div>
  </div>
  
  <div class="header-right">
    <div class="notification-icon">
      <i class="bi bi-bell" style="font-size: 20px; color: var(--text-secondary);"></i>
      <span class="notification-badge">5</span>
    </div>
    
    <div class="dropdown">
      <div class="user-profile" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
        <img src="https://ui-avatars.com/api/?name=<%= session.getAttribute("user") != null ? ((com.warehouse.models.User)session.getAttribute("user")).getUsername() : "Admin" %>&background=6366f1&color=fff" alt="User">
        <div class="user-info">
          <p class="user-name"><%= session.getAttribute("user") != null ? ((com.warehouse.models.User)session.getAttribute("user")).getUsername() : "Admin" %></p>
          <p class="user-role"><%= session.getAttribute("role") != null ? ((String)session.getAttribute("role")).replace("_", " ").substring(0, 1).toUpperCase() + ((String)session.getAttribute("role")).replace("_", " ").substring(1) : "User" %></p>
        </div>
      </div>
      
      <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown" style="min-width: 280px; border: none; box-shadow: 0 10px 40px rgba(0,0,0,0.1);">
        <li class="px-3 py-3 border-bottom">
          <h6 class="mb-2" style="font-weight: 600; color: var(--text-primary);"><i class="bi bi-person-circle me-2"></i>User Information</h6>
          <div class="d-flex align-items-center mb-2" style="font-size: 13px; color: var(--text-secondary);">
            <i class="bi bi-person me-2"></i>
            <span>Logged in as: <strong style="color: var(--text-primary);"><%= session.getAttribute("role") != null ? session.getAttribute("role") : "User" %></strong></span>
          </div>
          <div class="d-flex align-items-center mb-2" style="font-size: 13px; color: var(--text-secondary);">
            <i class="bi bi-clock-history me-2"></i>
            <span>Last Login: <strong style="color: var(--text-primary);"><%= session.getAttribute("lastLogin") != null ? session.getAttribute("lastLogin") : "N/A" %></strong></span>
          </div>
        </li>
        <li class="px-3 py-2">
          <div class="d-flex justify-content-between gap-2">
            <a href="settings.jsp" class="btn btn-outline-primary btn-sm flex-fill"><i class="bi bi-gear me-1"></i>Settings</a>
            <a href="login.jsp" class="btn btn-danger btn-sm flex-fill"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
          </div>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- Page Content -->
<div id="content">
  <!-- Dashboard content will be inserted here -->
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</body>
</html>
