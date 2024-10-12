package gzu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest httpRequest, HttpServletResponse httpResponse)
            throws ServletException, IOException {
        httpResponse.setContentType("text/html;charset=UTF-8");

        //获取用户名和密码
        String username = httpRequest.getParameter("username");
        String password = httpRequest.getParameter("password");

        if (UserStore.registerUser(username, password)) {
            httpResponse.sendRedirect("login.html"); // 注册成功，重定向到登录页
        } else {
            httpResponse.getWriter().write("用户名已存在");
            httpResponse.sendRedirect("register.html"); // 用户名已存在，重定向到注册页，重新注册
        }
    }
}