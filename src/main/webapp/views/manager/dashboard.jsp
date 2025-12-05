<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Your Application</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: #f5f7fa;
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            font-size: 24px;
            font-weight: 700;
        }
        
        .navbar-user {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info {
            font-size: 14px;
        }
        
        .btn-logout {
            padding: 8px 20px;
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }
        
        .btn-logout:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .welcome-card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .welcome-card h1 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .welcome-card p {
            color: #666;
            font-size: 16px;
        }
        
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .card-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            margin-bottom: 15px;
        }
        
        .card h3 {
            color: #333;
            margin-bottom: 10px;
            font-size: 18px;
        }
        
        .card p {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .role-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-right: 5px;
            margin-bottom: 5px;
        }
        
        .role-admin {
            background: #fee;
            color: #c33;
        }
        
        .role-manager {
            background: #fef3cd;
            color: #856404;
        }
        
        .role-user {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .info-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .info-section h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 20px;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #666;
            font-weight: 500;
        }
        
        .info-value {
            color: #333;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">Your Application</div>
        <div class="navbar-user">
            <div class="user-info">
                <sec:authentication property="principal.username" var="username"/>
                Welcome, <strong>${username}</strong>
            </div>
            <form action="<c:url value='/logout'/>" method="get" style="margin: 0;">
                <button type="submit" class="btn-logout">Logout</button>
            </form>
        </div>
    </nav>
    
    <div class="container">
        <div class="welcome-card">
            <h1>Dashboard</h1>
            <p>Welcome to your secure dashboard. You have successfully logged in.</p>
        </div>
        
        <div class="cards-grid">
            <sec:authorize access="hasAnyRole('USER', 'MANAGER', 'ADMIN')">
                <div class="card">
                    <div class="card-icon">📊</div>
                    <h3>User Dashboard</h3>
                    <p>Access your personal dashboard and manage your profile.</p>
                </div>
            </sec:authorize>
            
            <sec:authorize access="hasAnyRole('MANAGER', 'ADMIN')">
                <div class="card">
                    <div class="card-icon">👥</div>
                    <h3>Team Management</h3>
                    <p>Manage your team members and track their progress.</p>
                </div>
            </sec:authorize>
            
            <sec:authorize access="hasRole('ADMIN')">
                <div class="card">
                    <div class="card-icon">⚙️</div>
                    <h3>Admin Panel</h3>
                    <p>Access administrative features and system settings.</p>
                </div>
            </sec:authorize>
            
            <div class="card">
                <div class="card-icon">📈</div>
                <h3>Reports</h3>
                <p>View detailed reports and analytics for your account.</p>
            </div>
        </div>
        
        <div class="info-section">
            <h2>Account Information</h2>
            <div class="info-item">
                <span class="info-label">Username:</span>
                <span class="info-value">
                    <sec:authentication property="principal.username"/>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">Email:</span>
                <span class="info-value">
                    <sec:authentication property="principal.email"/>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">Roles:</span>
                <span class="info-value">
                    <sec:authentication property="principal.authorities" var="authorities"/>
                    <c:forEach items="${authorities}" var="auth">
                        <c:choose>
                            <c:when test="${auth.authority == 'ROLE_ADMIN'}">
                                <span class="role-badge role-admin">ADMIN</span>
                            </c:when>
                            <c:when test="${auth.authority == 'ROLE_MANAGER'}">
                                <span class="role-badge role-manager">MANAGER</span>
                            </c:when>
                            <c:when test="${auth.authority == 'ROLE_USER'}">
                                <span class="role-badge role-user">USER</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">Account Status:</span>
                <span class="info-value" style="color: #28a745; font-weight: 600;">Active</span>
            </div>
        </div>
    </div>
</body>
</html>