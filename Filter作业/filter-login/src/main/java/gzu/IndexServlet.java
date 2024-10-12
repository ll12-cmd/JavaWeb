package gzu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {//处理index页面（首页）
    protected void doGet(HttpServletRequest httpRequest, HttpServletResponse httpResponse)
            throws ServletException, IOException {

        //将该HTTP请求和响应转发到index.html上（数据传到index.html页面）
        httpRequest.getRequestDispatcher("index.jsp").forward(httpRequest, httpResponse);
    }
}
