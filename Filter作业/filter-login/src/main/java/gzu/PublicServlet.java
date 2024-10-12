package gzu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/public")
public class PublicServlet extends HttpServlet {
    protected void doGet(HttpServletRequest httpRequest, HttpServletResponse httpResponse)
            throws ServletException, IOException {

        //将该HTTP请求和响应转发到public.html上（数据传到public.html页面）
        httpRequest.getRequestDispatcher("public.html").forward(httpRequest, httpResponse);
    }
}