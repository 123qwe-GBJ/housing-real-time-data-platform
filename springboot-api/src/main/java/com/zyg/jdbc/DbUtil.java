package com.zyg.jdbc;

import java.sql.*;
import java.time.LocalDateTime;

public class DbUtil {
    // 使用简单的URL避免编码问题
    private static final String URL = "jdbc:mysql://localhost:3306/housing_db";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";

    static {
        try {
            // 加载MySQL 8.x驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC驱动加载成功");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC驱动加载失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 获取数据库连接
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功");
            return conn;
        } catch (SQLException e) {
            System.err.println("数据库连接失败: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // 登录验证
    public static boolean checkLogin(String username, String password) {
        String sql = "SELECT id FROM users WHERE username = ? AND password = ?";
        System.out.println("检查登录: " + username);

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("id");
                    System.out.println("用户ID: " + userId + " 登录成功");
                    updateLastLogin(userId);
                    return true;
                } else {
                    System.out.println("用户名或密码错误");
                    return false;
                }
            }
        } catch (SQLException e) {
            System.err.println("登录验证失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // 更新最后登录时间
    private static void updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setInt(2, userId);

            int rows = pstmt.executeUpdate();
            System.out.println("更新登录时间，影响行数: " + rows);
        } catch (SQLException e) {
            System.err.println("更新登录时间失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 检查用户名是否已存在
    public static boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) as count FROM users WHERE username = ?";
        System.out.println("检查用户名是否存在: " + username);

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt("count");
                    System.out.println("用户名 " + username + " 已存在: " + (count > 0));
                    return count > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("检查用户名失败: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // 注册新用户
    public static boolean registerUser(String username, String password) {
        System.out.println("注册用户: " + username);

        // 先检查用户名是否已存在
        if (isUsernameExists(username)) {
            System.out.println("注册失败：用户名已存在 - " + username);
            return false;
        }

        String sql = "INSERT INTO users (username, password) VALUES (?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            pstmt.setString(2, password);

            int rows = pstmt.executeUpdate();
            boolean success = rows > 0;

            if (success) {
                System.out.println("注册成功: " + username + "，影响行数: " + rows);
            } else {
                System.out.println("注册失败: 没有行被插入");
            }

            return success;
        } catch (SQLException e) {
            System.err.println("用户注册失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // 测试连接
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("数据库连接测试成功！");

            // 测试查询
            String sql = "SELECT COUNT(*) as user_count FROM users";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("当前用户数: " + rs.getInt("user_count"));
                }
            }
        } catch (SQLException e) {
            System.err.println("数据库连接测试失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
}