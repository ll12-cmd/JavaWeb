package gzu;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter(filterName = "LoginFilter" , urlPatterns = "/*")//配置过滤器,使其应用于所有 URL 路径
public class LoginFilter implements Filter{

    //创建一个排除列表,包含不需要登录就能访问的路径("/login", "/register", "/public","/index")
    private static final List<String> excludedPath = Arrays.asList("/login", "/register", "/index","/public");
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {//初始化方法
        System.out.println("LoginFilter初始化");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {//实现对请求和响应的拦截处理

        /*将servletRequest转换为HttpServletRequest类型，方便后面方法的调用
        将servletRespone转换为HttpServletResponse类型，方便后面方法的调用
        */
        HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
        HttpServletResponse httpRespone = (HttpServletResponse) servletResponse;

        //获取URL并将其转变为小写字母
        String httpRequestURI = httpRequest.getRequestURI().toLowerCase();

        if(isExcludedPath(httpRequestURI)){
            //如果在排除列表中，直接放行请求
            filterChain.doFilter(servletRequest,servletResponse);
            return;//避免继续向下执行（检查用户的session）
        }

        //检查用户的 session 中是否存在表示已登录的属性
        HttpSession httpSession = httpRequest.getSession(false);//创建默认session
        if(httpSession != null && httpSession.getAttribute("user") != null){
            //用户已登录,允许请求继续。
            filterChain.doFilter(servletRequest,servletResponse);
        }else{
            //用户未登录,将请求重定向到登录页面（以“/login"结尾）
            httpRespone.sendRedirect(httpRequest.getContextPath()+"/login.html");
        }
    }


    @Override
    public void destroy() {//销毁方法
        System.out.println("销毁LoginFilter");
    }

    //检查当前请求路径是否在排除列表中（包含/login", "/register", "/public"，"/index"中的一个）
    boolean isExcludedPath(String httpRequestURI){
        return excludedPath.stream().anyMatch(httpRequestURI::contains);
    }

}