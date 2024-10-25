package com.gzu.demo;

//查看倒数第二条记录

import java.sql.*;

public class JDBCWorkRetrieve {
    public static void main(String[] args) {
        String url="jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";//数据库地址
        String user="root";//用户名
        String password="lily1212";//密码
        String sql="SELECT id,name,course,birthday FROM teacher";//查询sql语句

        try(Connection conn = DriverManager.getConnection(url,user,password);//获取Connection对象
            //获取PreparedStatement对象（指定TYPE_SCROLL_INSENSITIVE来允许在结果集中自由移动，指定CONCUR_READ_ONLY来允许结果集只能以只读方式访问）
            PreparedStatement ps = conn.prepareStatement
                    (sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = ps.executeQuery();//获取结果集对象
        ){
            //控制台输出查询的结果
            rs.absolute(-2);//移动至倒数第二行记录
            System.out.println("id     name    course    birthday");
            System.out.println(rs.getInt("id")+"   " +rs.getString("name")+" "
                    +rs.getString("course")+" "+rs.getDate("birthday"));
        }catch (SQLException e){
            e.printStackTrace();
        }

    }
}
