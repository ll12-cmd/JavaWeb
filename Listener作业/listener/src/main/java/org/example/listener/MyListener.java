package org.example.listener;

import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletRequestEvent;
import jakarta.servlet.ServletRequestListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpServletRequest;

import java.text.SimpleDateFormat;
import java.util.Date;

@WebListener
public class MyListener implements ServletRequestListener {

    //请求开始
    public void requestInitialized(ServletRequestEvent sre){

    ServletRequest sr=sre.getServletRequest();//获取监听对象
    sr.setAttribute("startTime",System.currentTimeMillis());//设置startTime为请求开始的时间（毫秒为单位）
    String startTime = getCurrentTimestamp();//请求开始时间（标准Tomcat日志格式）
    HttpServletRequest hsr = (HttpServletRequest) sr;//为方便后续方法的调用，将ServletRequest转为HttpServletRequest
    String remoteAddr = hsr.getRemoteAddr();//获取客户端地址
    String requestMethod = hsr.getMethod();//获取请求方法（GET,POST）
    String uri = hsr.getRequestURI()   ;//获取请求URI
    String queryString = hsr.getQueryString() !=null ? hsr.getQueryString() : "No queryString";//获取字符串
    String user_agent = hsr.getHeader("User-Agent") !=null ? hsr.getHeader("User-Agent") : "No User-Agent";//获取User-Agent

    // 按顺序格式化输出日志内容
    System.out.println(String.format("%s 请求开始 [%s][%s][%s][%s][%s]",startTime,remoteAddr,requestMethod,uri,queryString,user_agent));
    }

    //请求处理完成
    public void requestDestroyed(ServletRequestEvent sre){

        ServletRequest sr=sre.getServletRequest();//获取监听对象
        sr.setAttribute("endTime",System.currentTimeMillis());//设置startTime为请求开始的时间（毫秒为单位）
        String endTime = getCurrentTimestamp();//请求开始时间（标准Tomcat日志格式）
        HttpServletRequest hsr = (HttpServletRequest) sr;//为方便后续方法的调用，将ServletRequest转为HttpServletRequest
        String remoteAddr = hsr.getRemoteAddr();//获取客户端地址
        String requestMethod = hsr.getMethod();//获取请求方法（GET,POST）
        String uri = hsr.getRequestURI()   ;//获取请求URI
        String queryString = hsr.getQueryString() !=null ? hsr.getQueryString() : "No queryString";//获取字符串
        String user_agent = hsr.getHeader("User-Agent");//获取User-Agent

        long handingTime = (long)sr.getAttribute("endTime") - (long) sr.getAttribute("startTime");//处理请求时间（结束-开始）

        // 按顺序格式化输出日志内容
        System.out.println(String.format("%s 请求处理完成 [%s][%s][%s][%s][%s] 处理时间：%d 毫秒",endTime,remoteAddr,requestMethod,uri,queryString,user_agent,handingTime));

    }

    //按Tomcat标准日志格式获取当前时间
    private String getCurrentTimestamp() {
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm:ss.SSS");
        return sdf.format(new Date());
    }
}
