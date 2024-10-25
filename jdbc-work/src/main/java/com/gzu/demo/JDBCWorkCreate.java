package com.gzu.demo;

/*
* 注意：运行时运行JDBCWork类的main函数而不是Tomcat10服务
* */

import java.sql.*;

public class JDBCWorkCreate {
    public static void main(String[] args) {
        String url="jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";//数据库地址
        String user="root";//用户名
        String password="lily1212";//密码

        //sql语句
        String sql="INSERT  INTO `teacher` VALUES (?,?,?,?)";
        try(Connection conn = DriverManager.getConnection(url,user,password);){
            conn.setAutoCommit(false);//设置不自动提交
            try(PreparedStatement ps = conn.prepareStatement(sql)){

                for(int i=1;i<=500;i++)//插入500条记录
                {
                    //设置sql参数
                    ps.setInt(1,i);//id
                    ps.setString(2,"name"+i);//姓名
                    ps.setString(3,"course"+i);//课程
                    ps.setDate(4, Date.valueOf("2003-10-17"));//生日
                    ps.addBatch();//添加到批处理列表
                    if(i%100==0)
                    {//每插入100条数据提交一次
                        ps.executeBatch();//执行批处理
                        ps.clearBatch();//清空批处理列表，防止多插漏插
                    }
                }
                ps.executeBatch();//执行for循环剩下的批处理语句
                conn.commit();//提交
            }catch (SQLException e){
                conn.rollback();//回滚
                e.printStackTrace();
            }finally {
                conn.setAutoCommit(true);//恢复自动提交
            }

        }catch (SQLException e){
            e.printStackTrace();
        }

    }
}
