package com.example.security.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    @GetMapping("/user/dashboard")
    @PreAuthorize("hasAnyRole('USER', 'MANAGER', 'ADMIN')")
    public String userDashboard(Model model, Authentication authentication) {
        model.addAttribute("username", authentication.getName());
        model.addAttribute("authorities", authentication.getAuthorities());
        return "user/dashboard";
    }

    @GetMapping("/manager/dashboard")
    @PreAuthorize("hasAnyRole('MANAGER', 'ADMIN')")
    public String managerDashboard(Model model, Authentication authentication) {
        model.addAttribute("username", authentication.getName());
        model.addAttribute("authorities", authentication.getAuthorities());
        return "manager/dashboard";
    }

    @GetMapping("/admin/dashboard")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminDashboard(Model model, Authentication authentication) {
        model.addAttribute("username", authentication.getName());
        model.addAttribute("authorities", authentication.getAuthorities());
        return "admin/dashboard";
    }

    @GetMapping("/profile")
    @PreAuthorize("isAuthenticated()")
    public String profile(Model model, Authentication authentication) {
        model.addAttribute("username", authentication.getName());
        return "profile";
    }
}

// REST API Controllers with role-based access
@org.springframework.web.bind.annotation.RestController
@org.springframework.web.bind.annotation.RequestMapping("/api")
class ApiController {

    @GetMapping("/public/info")
    public java.util.Map<String, String> publicInfo() {
        return java.util.Map.of(
                "message", "This is public information",
                "timestamp", java.time.LocalDateTime.now().toString()
        );
    }

    @GetMapping("/user/data")
    @PreAuthorize("hasAnyRole('USER', 'MANAGER', 'ADMIN')")
    public java.util.Map<String, Object> userData(Authentication authentication) {
        return java.util.Map.of(
                "message", "User data",
                "user", authentication.getName(),
                "roles", authentication.getAuthorities()
        );
    }

    @GetMapping("/manager/data")
    @PreAuthorize("hasAnyRole('MANAGER', 'ADMIN')")
    public java.util.Map<String, Object> managerData(Authentication authentication) {
        return java.util.Map.of(
                "message", "Manager data",
                "user", authentication.getName(),
                "roles", authentication.getAuthorities()
        );
    }

    @GetMapping("/admin/data")
    @PreAuthorize("hasRole('ADMIN')")
    public java.util.Map<String, Object> adminData(Authentication authentication) {
        return java.util.Map.of(
                "message", "Admin data",
                "user", authentication.getName(),
                "roles", authentication.getAuthorities(),
                "timestamp", java.time.LocalDateTime.now()
        );
    }
}