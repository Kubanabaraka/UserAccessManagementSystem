package com.useraccess.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

/**
 * Initializes the database schema on application startup.
 * This listener creates the required tables if they don't exist.
 */
@WebListener
public class DatabaseInitializationListener implements ServletContextListener {

    private static final String JDBC_URL = "jdbc:postgresql://127.0.0.1:5432/useraccess_db";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "password123";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Starting database initialization...");
        try {
            // Load PostgreSQL driver
            Class.forName("org.postgresql.Driver");
            
            // Create database if it doesn't exist
            createDatabase();
            
            // Create tables if they don't exist
            createTables();
            
            System.out.println("Database initialization completed successfully!");
        } catch (Exception e) {
            System.err.println("Error during database initialization: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void createDatabase() throws Exception {
        String masterUrl = "jdbc:postgresql://127.0.0.1:5432/postgres";
        try (Connection conn = DriverManager.getConnection(masterUrl, DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement()) {
            
            // Check if database exists
            stmt.executeQuery("SELECT 1 FROM pg_database WHERE datname = 'useraccess_db'");
            
            // If we get here, database exists
            System.out.println("Database 'useraccess_db' already exists.");
        } catch (Exception e) {
            System.out.println("Creating database 'useraccess_db'...");
            try (Connection conn = DriverManager.getConnection(masterUrl, DB_USER, DB_PASSWORD);
                 Statement stmt = conn.createStatement()) {
                stmt.execute("CREATE DATABASE useraccess_db");
                System.out.println("Database created successfully.");
            }
        }
    }

    private void createTables() throws Exception {
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement()) {
            
            // Drop existing tables for clean setup (only on initialization)
            try {
                stmt.execute("DROP TABLE IF EXISTS requests CASCADE");
                stmt.execute("DROP TABLE IF EXISTS software CASCADE");
                stmt.execute("DROP TABLE IF EXISTS users CASCADE");
            } catch (Exception e) {
                System.out.println("Tables didn't exist or couldn't be dropped: " + e.getMessage());
            }
            
            // Create users table
            stmt.execute("""
                    CREATE TABLE IF NOT EXISTS users (
                        id SERIAL PRIMARY KEY,
                        username VARCHAR(100) NOT NULL UNIQUE,
                        password VARCHAR(255) NOT NULL,
                        role VARCHAR(20) NOT NULL CHECK (role IN ('Employee', 'Manager', 'Admin')),
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                    """);
            System.out.println("Users table created.");
            
            // Create software table
            stmt.execute("""
                    CREATE TABLE IF NOT EXISTS software (
                        id SERIAL PRIMARY KEY,
                        name VARCHAR(200) NOT NULL UNIQUE,
                        description TEXT,
                        access_levels VARCHAR(50) CHECK (access_levels IN ('Read', 'Write', 'Admin')),
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                    """);
            System.out.println("Software table created.");
            
            // Create requests table
            stmt.execute("""
                    CREATE TABLE IF NOT EXISTS requests (
                        id SERIAL PRIMARY KEY,
                        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                        software_id INTEGER NOT NULL REFERENCES software(id) ON DELETE CASCADE,
                        access_type VARCHAR(20) NOT NULL CHECK (access_type IN ('Read', 'Write', 'Admin')),
                        reason TEXT,
                        status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                    """);
            System.out.println("Requests table created.");
            
            // Create indexes
            stmt.execute("CREATE INDEX IF NOT EXISTS idx_requests_status ON requests(status)");
            stmt.execute("CREATE INDEX IF NOT EXISTS idx_requests_user_id ON requests(user_id)");
            System.out.println("Indexes created.");
            
            // Insert sample data (only if tables are empty)
            insertSampleData(conn);
        }
    }

    private void insertSampleData(Connection conn) throws Exception {
        try (Statement stmt = conn.createStatement()) {
            // Check if users already exist
            var resultSet = stmt.executeQuery("SELECT COUNT(*) as count FROM users");
            if (resultSet.next() && resultSet.getInt("count") > 0) {
                System.out.println("Sample data already exists.");
                return;
            }
            
            // Insert users
            stmt.execute("""
                    INSERT INTO users (username, password, role) VALUES
                        ('admin', 'admin123', 'Admin'),
                        ('manager', 'manager123', 'Manager'),
                        ('john_doe', 'employee123', 'Employee'),
                        ('jane_smith', 'employee123', 'Employee'),
                        ('bob_wilson', 'employee123', 'Employee')
                    """);
            System.out.println("Sample users inserted.");
            
            // Insert software
            stmt.execute("""
                    INSERT INTO software (name, description, access_levels) VALUES
                        ('Salesforce CRM', 'Customer relationship management platform', 'Read'),
                        ('GitHub Enterprise', 'Source code repository and collaboration tool', 'Write'),
                        ('AWS Console', 'Amazon Web Services cloud management console', 'Admin'),
                        ('Jira', 'Project management and issue tracking software', 'Read'),
                        ('Slack Enterprise', 'Team communication and collaboration platform', 'Write')
                    """);
            System.out.println("Sample software inserted.");
            
            // Insert sample requests
            stmt.execute("""
                    INSERT INTO requests (user_id, software_id, access_type, reason, status) VALUES
                        (3, 1, 'Read', 'Need CRM access for sales reporting project', 'Pending'),
                        (3, 2, 'Write', 'Need to commit code for the Q1 feature sprint', 'Approved'),
                        (4, 3, 'Read', 'Need to monitor server infrastructure', 'Pending'),
                        (4, 4, 'Write', 'Need to create and manage project tickets', 'Rejected'),
                        (5, 5, 'Read', 'Need access to team communication channels', 'Pending')
                    """);
            System.out.println("Sample requests inserted.");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application shutting down...");
    }
}
