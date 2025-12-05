package com.example.security.config;

import com.example.security.model.Privilege;
import com.example.security.model.Role;
import com.example.security.model.User;
import com.example.security.repository.PrivilegeRepository;
import com.example.security.repository.RoleRepository;
import com.example.security.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Set;

@Configuration
public class DataInitializer {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    @Bean
    @Transactional
    public CommandLineRunner initData(UserRepository userRepository,
                                     RoleRepository roleRepository,
                                     PrivilegeRepository privilegeRepository,
                                     PasswordEncoder passwordEncoder) {
        return args -> {
            // Create privileges
            Privilege readPrivilege = createPrivilegeIfNotFound(privilegeRepository, "READ_PRIVILEGE");
            Privilege writePrivilege = createPrivilegeIfNotFound(privilegeRepository, "WRITE_PRIVILEGE");
            Privilege deletePrivilege = createPrivilegeIfNotFound(privilegeRepository, "DELETE_PRIVILEGE");
            Privilege adminPrivilege = createPrivilegeIfNotFound(privilegeRepository, "ADMIN_PRIVILEGE");

            // Create roles
            Set<Privilege> userPrivileges = new HashSet<>();
            userPrivileges.add(readPrivilege);

            Set<Privilege> managerPrivileges = new HashSet<>();
            managerPrivileges.add(readPrivilege);
            managerPrivileges.add(writePrivilege);

            Set<Privilege> adminPrivileges = new HashSet<>();
            adminPrivileges.add(readPrivilege);
            adminPrivileges.add(writePrivilege);
            adminPrivileges.add(deletePrivilege);
            adminPrivileges.add(adminPrivilege);

            Role userRole = createRoleIfNotFound(roleRepository, "ROLE_USER", userPrivileges);
            Role managerRole = createRoleIfNotFound(roleRepository, "ROLE_MANAGER", managerPrivileges);
            Role adminRole = createRoleIfNotFound(roleRepository, "ROLE_ADMIN", adminPrivileges);

            // Create default admin user if not exists
            if (!userRepository.existsByUsername("admin")) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setEmail("admin@example.com");
                admin.setPassword(passwordEncoder.encode("Admin@123"));
                admin.setFirstName("Admin");
                admin.setLastName("User");
                admin.setEnabled(true);
                admin.setAccountNonExpired(true);
                admin.setAccountNonLocked(true);
                admin.setCredentialsNonExpired(true);
                
                Set<Role> adminRoles = new HashSet<>();
                adminRoles.add(adminRole);
                admin.setRoles(adminRoles);
                
                userRepository.save(admin);
                logger.info("Default admin user created: username=admin, password=Admin@123");
            }

            // Create default manager user if not exists
            if (!userRepository.existsByUsername("manager")) {
                User manager = new User();
                manager.setUsername("manager");
                manager.setEmail("manager@example.com");
                manager.setPassword(passwordEncoder.encode("Manager@123"));
                manager.setFirstName("Manager");
                manager.setLastName("User");
                manager.setEnabled(true);
                manager.setAccountNonExpired(true);
                manager.setAccountNonLocked(true);
                manager.setCredentialsNonExpired(true);
                
                Set<Role> managerRoles = new HashSet<>();
                managerRoles.add(managerRole);
                manager.setRoles(managerRoles);
                
                userRepository.save(manager);
                logger.info("Default manager user created: username=manager, password=Manager@123");
            }

            // Create default regular user if not exists
            if (!userRepository.existsByUsername("user")) {
                User user = new User();
                user.setUsername("user");
                user.setEmail("user@example.com");
                user.setPassword(passwordEncoder.encode("User@123"));
                user.setFirstName("Regular");
                user.setLastName("User");
                user.setEnabled(true);
                user.setAccountNonExpired(true);
                user.setAccountNonLocked(true);
                user.setCredentialsNonExpired(true);
                
                Set<Role> userRoles = new HashSet<>();
                userRoles.add(userRole);
                user.setRoles(userRoles);
                
                userRepository.save(user);
                logger.info("Default user created: username=user, password=User@123");
            }
        };
    }

    @Transactional
    Privilege createPrivilegeIfNotFound(PrivilegeRepository repository, String name) {
        return repository.findByName(name).orElseGet(() -> {
            Privilege privilege = new Privilege(name);
            return repository.save(privilege);
        });
    }

    @Transactional
    Role createRoleIfNotFound(RoleRepository repository, String name, Set<Privilege> privileges) {
        return repository.findByName(name).orElseGet(() -> {
            Role role = new Role(name);
            role.setPrivileges(privileges);
            return repository.save(role);
        });
    }
}