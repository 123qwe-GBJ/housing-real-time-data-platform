package com.zyg.controller;

import com.zyg.jdbc.DbUtil;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/api")
public class LoginController {

    // 静态代码块加载数据库驱动
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL驱动加载成功");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL驱动加载失败: " + e.getMessage());
        }
    }

    @PostMapping("/login")
    public ApiResponse login(@RequestParam String username,
                             @RequestParam String password,
                             HttpServletRequest request) {

        System.out.println("登录请求: username=" + username);

        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            return ApiResponse.error("请输入用户名");
        }
        if (password == null || password.trim().isEmpty()) {
            return ApiResponse.error("请输入密码");
        }

        username = username.trim();

        boolean success = DbUtil.checkLogin(username, password);

        if (success) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setMaxInactiveInterval(30 * 60); // 30分钟

            System.out.println("登录成功: " + username);
            return ApiResponse.success("登录成功", "/page/toIndex");
        } else {
            System.out.println("登录失败: " + username);
            return ApiResponse.error("用户名或密码错误");
        }
    }

    @PostMapping("/register")
    public ApiResponse register(@RequestParam String username,
                                @RequestParam String password) {

        System.out.println("注册请求: username=" + username);

        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            return ApiResponse.error("用户名不能为空");
        }
        if (password == null || password.trim().isEmpty()) {
            return ApiResponse.error("密码不能为空");
        }

        username = username.trim();
        password = password.trim();

        // 用户名格式验证
        if (!username.matches("^[a-zA-Z0-9]{3,16}$")) {
            return ApiResponse.error("用户名应为3-16位字母数字组合");
        }

        // 密码格式验证
        if (!password.matches("^(?=.*[A-Za-z])(?=.*\\d).{8,}$")) {
            return ApiResponse.error("密码至少8位，包含字母和数字");
        }

        boolean success = DbUtil.registerUser(username, password);

        if (success) {
            System.out.println("注册成功: " + username);
            return ApiResponse.success("注册成功！请返回登录", null);
        } else {
            System.out.println("注册失败: " + username);
            return ApiResponse.error("注册失败，用户名可能已存在");
        }
    }

    @GetMapping("/checkUsername")
    public ApiResponse checkUsername(@RequestParam String username) {
        if (username == null || username.trim().isEmpty()) {
            return ApiResponse.error("用户名不能为空");
        }

        boolean exists = DbUtil.isUsernameExists(username.trim());
        if (exists) {
            return ApiResponse.error("用户名已存在");
        }
        return ApiResponse.success("用户名可用");
    }

    // API响应类 - 添加JSON序列化支持
    public static class ApiResponse {
        private boolean success;
        private String message;
        private String redirectUrl;

        // 必须有无参构造函数
        public ApiResponse() {}

        public ApiResponse(boolean success, String message, String redirectUrl) {
            this.success = success;
            this.message = message;
            this.redirectUrl = redirectUrl;
        }

        public static ApiResponse success(String message) {
            return new ApiResponse(true, message, null);
        }

        public static ApiResponse success(String message, String redirectUrl) {
            return new ApiResponse(true, message, redirectUrl);
        }

        public static ApiResponse error(String message) {
            return new ApiResponse(false, message, null);
        }

        // Getter和Setter（必须添加）
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }

        public String getRedirectUrl() { return redirectUrl; }
        public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }
    }
}