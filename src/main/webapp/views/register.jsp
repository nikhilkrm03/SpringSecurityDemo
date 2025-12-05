<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Secure Application</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }
        .register-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            padding: 40px;
            max-width: 500px;
            width: 100%;
            margin: 20px;
        }
        .register-title {
            color: #667eea;
            margin-bottom: 30px;
            font-weight: 600;
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2 class="text-center register-title">
            Create Account
        </h2>

        <c:if test="${errorMessage != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error!</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form:form action="${pageContext.request.contextPath}/register" method="post" 
                   modelAttribute="user">
            
            <div class="mb-3">
                <label for="username" class="form-label">Username *</label>
                <form:input path="username" class="form-control" id="username" 
                           placeholder="Choose a username" required="true"/>
                <form:errors path="username" cssClass="text-danger small"/>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email *</label>
                <form:input path="email" type="email" class="form-control" id="email" 
                           placeholder="your.email@example.com" required="true"/>
                <form:errors path="email" cssClass="text-danger small"/>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="firstName" class="form-label">First Name *</label>
                    <form:input path="firstName" class="form-control" id="firstName" 
                               placeholder="First name" required="true"/>
                    <form:errors path="firstName" cssClass="text-danger small"/>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="lastName" class="form-label">Last Name *</label>
                    <form:input path="lastName" class="form-control" id="lastName" 
                               placeholder="Last name" required="true"/>
                    <form:errors path="lastName" cssClass="text-danger small"/>
                </div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password *</label>
                <form:password path="password" class="form-control" id="password" 
                              placeholder="Min 8 characters" required="true"/>
                <form:errors path="password" cssClass="text-danger small"/>
                <small class="text-muted">Must be at least 8 characters long</small>
            </div>

            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm Password *</label>
                <form:password path="confirmPassword" class="form-control" id="confirmPassword" 
                              placeholder="Re-enter password" required="true"/>
                <form:errors path="confirmPassword" cssClass="text-danger small"/>
            </div>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <button type="submit" class="btn btn-primary btn-register w-100 mb-3">
                Register
            </button>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">
                    Already have an account? Login here
                </a>
            </div>
        </form:form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>