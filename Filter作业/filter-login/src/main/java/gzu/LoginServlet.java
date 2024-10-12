package gzu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {//处理login页面
    @Override
    protected void doPost(HttpServletRequest httpRequest, HttpServletResponse httpResponse)
            throws ServletException, IOException {

        httpResponse.setContentType("text/html;charset=UTF-8");//定义编码

        //获取用户名和密码
        String username = httpRequest.getParameter("username");
        String password = httpRequest.getParameter("password");

        // 检查用户是否已注册
        if (!UserStore.getRegisteredUsers().contains(username)) {
            httpResponse.getWriter().write("用户未注册，请先注册。<br><a href='register.html'>点击这里注册</a>");
            return;
        }

        // 验证用户名和密码
        if (UserStore.validateUser(username, password)) {// 验证成功
            //设置 session
            HttpSession session = httpRequest.getSession();
            session.setAttribute("user", username);

            // 登录成功，重定向到welcome页面(将用户名作为参数传输到 welcome.html)
            httpResponse.sendRedirect("welcome.html" );
        } else {
            httpResponse.getWriter().write("用户名或密码错误，请检查后重试。");
            httpResponse.sendRedirect("login.html");//验证失败，重定向到登录页面，重新登录
        }
    }
}