<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.RequestDispatcher" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= request.getParameter("title") != null ? request.getParameter("title") : "Warehouse Management" %></title>
  
  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  
  <!-- Inter Font -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  
  <!-- Global Styles -->
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    :root {
      --sidebar-width: 240px;
      --header-height: 64px;
      --primary-green: #10b981;
      --primary-green-hover: #059669;
      --text-primary: #111827;
      --text-secondary: #6b7280;
      --border: #e5e7eb;
      --bg: #ffffff;
      --bg-secondary: #f9fafb;
    }

    * {
      box-sizing: border-box;
    }

    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: var(--bg-secondary);
      color: var(--text-primary);
      margin: 0;
      padding: 0;
      font-size: 14px;
      line-height: 1.5;
    }

    /* Sidebar */
    #sidebar {
      position: fixed;
      top: 0;
      left: 0;
      width: var(--sidebar-width);
      height: 100vh;
      background: var(--bg);
      border-right: 1px solid var(--border);
      overflow-y: auto;
      z-index: 1000;
    }

    .sidebar-header {
      padding: 20px 16px;
      border-bottom: 1px solid var(--border);
      height: var(--header-height);
      display: flex;
      align-items: center;
    }

    .sidebar-header p {
      margin: 0;
      font-size: 16px;
      font-weight: 600;
      color: var(--text-primary);
      letter-spacing: -0.01em;
    }

    #sidebar ul {
      list-style: none;
      padding: 8px;
      margin: 0;
    }

    #sidebar ul li {
      margin: 2px 0;
    }

    #sidebar ul li a {
      display: flex;
      align-items: center;
      padding: 10px 12px;
      color: var(--text-secondary);
      text-decoration: none;
      border-radius: 6px;
      font-size: 14px;
      font-weight: 500;
      transition: all 0.15s;
    }

    #sidebar ul li a i {
      width: 20px;
      margin-right: 10px;
      font-size: 16px;
      text-align: center;
    }

    #sidebar ul li a:hover {
      background: var(--bg-secondary);
      color: var(--text-primary);
    }

    #sidebar ul li.active > a {
      background: var(--bg-secondary);
      color: var(--primary-green);
    }

    #sidebar ul li .collapse {
      background: transparent;
      padding-left: 0;
    }

    #sidebar ul li .collapse li a {
      padding-left: 40px;
      font-size: 13px;
    }

    .logout-btn {
      margin: 8px;
      padding: 0 !important;
    }

    .logout-btn a {
      color: var(--text-secondary) !important;
      border: 1px solid var(--border) !important;
    }

    .logout-btn a:hover {
      background: var(--bg-secondary) !important;
      color: var(--text-primary) !important;
    }

    /* Header */
    #header {
      position: fixed;
      top: 0;
      left: var(--sidebar-width);
      right: 0;
      height: var(--header-height);
      background: var(--bg);
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 24px;
      z-index: 999;
    }

    .header-left h1 {
      margin: 0;
      font-size: 18px;
      font-weight: 600;
      color: var(--text-primary);
      line-height: 1.2;
    }

    .header-date {
      font-size: 12px;
      color: var(--text-secondary);
      margin-top: 2px;
    }

    .header-center {
      flex: 1;
      max-width: 400px;
      margin: 0 24px;
    }

    .search-bar {
      position: relative;
    }

    .search-bar input {
      width: 100%;
      padding: 8px 12px 8px 36px;
      border: 1px solid var(--border);
      border-radius: 6px;
      font-size: 14px;
      background: var(--bg-secondary);
      transition: all 0.15s;
    }

    .search-bar input:focus {
      outline: none;
      border-color: var(--primary-green);
      background: var(--bg);
      box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
    }

    .search-bar i {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-secondary);
      font-size: 14px;
    }

    .header-right {
      display: flex;
      align-items: center;
      gap: 16px;
    }

    .notification-icon {
      position: relative;
      padding: 8px;
      cursor: pointer;
      border-radius: 6px;
      transition: background 0.15s;
    }

    .notification-icon:hover {
      background: var(--bg-secondary);
    }

    .notification-badge {
      position: absolute;
      top: 4px;
      right: 4px;
      width: 18px;
      height: 18px;
      background: #ef4444;
      color: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 10px;
      font-weight: 600;
    }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 4px 8px;
      border-radius: 6px;
      cursor: pointer;
      transition: background 0.15s;
    }

    .user-profile:hover {
      background: var(--bg-secondary);
    }

    .user-profile img {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      border: 1px solid var(--border);
    }

    .user-info {
      display: flex;
      flex-direction: column;
    }

    .user-name {
      font-size: 13px;
      font-weight: 500;
      color: var(--text-primary);
      margin: 0;
      line-height: 1.2;
    }

    .user-role {
      font-size: 11px;
      color: var(--text-secondary);
      margin: 0;
      line-height: 1.2;
    }

    /* Content Area */
    #content {
      margin-left: var(--sidebar-width);
      margin-top: var(--header-height);
      padding: 24px;
      min-height: calc(100vh - var(--header-height));
    }

    /* Scrollbar */
    #sidebar::-webkit-scrollbar,
    #content::-webkit-scrollbar {
      width: 6px;
    }

    #sidebar::-webkit-scrollbar-track,
    #content::-webkit-scrollbar-track {
      background: transparent;
    }

    #sidebar::-webkit-scrollbar-thumb,
    #content::-webkit-scrollbar-thumb {
      background: var(--border);
      border-radius: 3px;
    }

    #sidebar::-webkit-scrollbar-thumb:hover,
    #content::-webkit-scrollbar-thumb:hover {
      background: var(--text-secondary);
    }
  </style>
</head>
<body>

<!-- Sidebar -->
<div id="sidebar">
  <div class="sidebar-header">
    <p>panze studio.</p>
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
        <i class="bi bi-gear"></i> More
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
    <h1><%= request.getParameter("pageTitle") != null ? request.getParameter("pageTitle") : (request.getParameter("title") != null ? request.getParameter("title") : "Dashboard") %></h1>
    <div class="header-date"><%= new java.text.SimpleDateFormat("dd MMMM, yyyy").format(new java.util.Date()) %></div>
  </div>
  
  <div class="header-center">
    <div class="search-bar">
      <i class="bi bi-search"></i>
      <input type="text" placeholder="Search...">
    </div>
  </div>
  
  <div class="header-right">
    <div class="notification-icon">
      <i class="bi bi-bell" style="font-size: 18px; color: var(--text-secondary);"></i>
      <span class="notification-badge">5</span>
    </div>
    
    <div class="dropdown">
      <div class="user-profile" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
        <img src="https://ui-avatars.com/api/?name=<%= session.getAttribute("user") != null ? ((com.warehouse.models.User)session.getAttribute("user")).getUsername() : "Admin" %>&background=10b981&color=fff" alt="User">
        <div class="user-info">
          <p class="user-name"><%= session.getAttribute("user") != null ? ((com.warehouse.models.User)session.getAttribute("user")).getUsername() : "Admin" %></p>
          <p class="user-role"><%= session.getAttribute("role") != null ? ((String)session.getAttribute("role")).replace("_", " ").substring(0, 1).toUpperCase() + ((String)session.getAttribute("role")).replace("_", " ").substring(1) : "User" %></p>
        </div>
      </div>
      
      <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown" style="min-width: 240px; border: 1px solid var(--border); box-shadow: 0 4px 12px rgba(0,0,0,0.08);">
        <li class="px-3 py-2 border-bottom">
          <h6 class="mb-1" style="font-weight: 600; font-size: 13px; color: var(--text-primary);">User Information</h6>
          <div style="font-size: 12px; color: var(--text-secondary);">
            <div class="mb-1">Role: <strong style="color: var(--text-primary);"><%= session.getAttribute("role") != null ? session.getAttribute("role") : "User" %></strong></div>
          </div>
        </li>
        <li class="px-3 py-2">
          <div class="d-flex gap-2">
            <a href="login.jsp" class="btn btn-sm flex-fill" style="background: var(--primary-green); color: white; border: none;">Logout</a>
          </div>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- Page Content -->
<div id="content">
