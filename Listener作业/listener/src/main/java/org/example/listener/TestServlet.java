package org.example.listener;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/test")
public class TestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置响应内容类型
        response.setContentType("text/html;charset=UTF-8");

        // 获取请求参数（如果有）
        String name = request.getParameter("name");

        // 写入响应内容
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h1>Hello, " + (name != null ? name : "Listener") + "!</h1>");
        response.getWriter().println("</body></html>");
    }
}