package com.example.security.handler;

import com.example.security.model.User;
import com.example.security.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {

    private static final Logger logger = LoggerFactory.getLogger(CustomAuthenticationFailureHandler.class);
    private static final int MAX_FAILED_ATTEMPTS = 5;
    private final UserRepository userRepository;

    public CustomAuthenticationFailureHandler(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                       AuthenticationException exception) throws IOException, ServletException {
        
        String username = request.getParameter("username");
        String errorMessage;

        if (exception instanceof BadCredentialsException) {
            errorMessage = "Invalid username or password";
            handleFailedLoginAttempt(username);
            logger.warn("Failed login attempt for user: {}", username);
        } else if (exception instanceof DisabledException) {
            errorMessage = "Your account has been disabled";
            logger.warn("Login attempt for disabled account: {}", username);
        } else if (exception instanceof LockedException) {
            errorMessage = "Your account has been locked due to multiple failed login attempts";
            logger.warn("Login attempt for locked account: {}", username);
        } else if (exception instanceof UsernameNotFoundException) {
            errorMessage = "User not found";
            logger.warn("Login attempt for non-existent user: {}", username);
        } else {
            errorMessage = "Authentication failed";
            logger.error("Authentication failed for user: {} with exception: {}", username, exception.getMessage());
        }

        String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
        response.sendRedirect("/login?error=true&message=" + encodedMessage);
    }

    private void handleFailedLoginAttempt(String username) {
        userRepository.findByUsername(username).ifPresent(user -> {
            int attempts = user.getFailedLoginAttempts() + 1;
            user.setFailedLoginAttempts(attempts);

            if (attempts >= MAX_FAILED_ATTEMPTS) {
                user.setAccountNonLocked(false);
                logger.warn("Account locked for user: {} after {} failed attempts", username, attempts);
            }

            userRepository.save(user);
        });
    }
}