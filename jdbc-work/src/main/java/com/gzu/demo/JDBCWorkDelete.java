package com.gzu.demo;

import java.sql.*;
import java.util.Scanner;

//根据输入的id删除一条记录

public class JDBCWorkDelete {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8"; // 数据库地址
        String user = "root"; // 用户名
        String password = "lily1212"; // 密码
        String sql = "DELETE FROM teacher WHERE id= ? "; // 更新sql语句
        // 获取需要用到的对象
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            conn.setAutoCommit(false); // 设置不自动提交
            Scanner input = new Scanner(System.in);
            System.out.println("请输入你想修改的教师id");
            int teacherId = input.nextInt(); // 获取教师id
            try (PreparedStatement ps = conn.prepareStatement(sql)){
                // 设置删除参数并执行更新操作
                ps.setInt(1, teacherId);
                 ps.executeUpdate();
                System.out.println("删除成功！");
                conn.commit(); // 提交
            } catch (SQLException e) {
                conn.rollback(); // 回滚
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true); // 恢复自动提交
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}