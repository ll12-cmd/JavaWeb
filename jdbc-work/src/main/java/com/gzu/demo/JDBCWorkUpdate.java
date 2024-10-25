package com.gzu.demo;

import java.sql.*;
import java.util.Scanner;

public class JDBCWorkUpdate {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8"; // 数据库地址
        String user = "root"; // 用户名
        String password = "lily1212"; // 密码
        String sqlu = "UPDATE teacher SET course= ? WHERE id = ?"; // 更新sql语句
        String sqlr = "SELECT id, name, course, birthday FROM teacher WHERE id=?"; // 查询修改前后的记录

        // 获取需要用到的对象
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            conn.setAutoCommit(false); // 设置不自动提交

            Scanner input = new Scanner(System.in);
            System.out.println("请输入你想修改课程名的教师id");
            int teacherId = input.nextInt(); // 获取教师id
            input.nextLine(); // 清除上一个输入留下的换行符
            System.out.println("请输入修改后的课程名");
            String courseName = input.nextLine(); // 获取课程名

            try (PreparedStatement psu = conn.prepareStatement(sqlu);
                 PreparedStatement psr = conn.prepareStatement(sqlr)) {//获取更新、查询语句对象

                // 设置查询参数并查询修改前的记录
                psr.setInt(1, teacherId);
                ResultSet rs1 = psr.executeQuery();

                if (rs1.next()) { // 检查是否有结果
                    //输出修改前的记录
                    System.out.println("修改前的记录为：");
                    System.out.println("id     name    course    birthday");
                    System.out.println(rs1.getInt("id") + "   " + rs1.getString("name") + " "
                            + rs1.getString("course") + " " + rs1.getDate("birthday"));
                } else {
                    System.out.println("未找到该教师的记录。");
                    return; // 如果没有找到记录，结束程序
                }

                // 设置更新参数并执行更新操作
                psu.setString(1, courseName);
                psu.setInt(2, teacherId);
                psu.executeUpdate();

                // 再次查询以获取修改后的记录
                ResultSet rs2 = psr.executeQuery();
                if (rs2.next()) { // 检查是否有结果
                    //输出修改后的记录
                    System.out.println("修改后的记录为：");
                    System.out.println("id     name    course    birthday");
                    System.out.println(rs2.getInt("id") + "   " + rs2.getString("name") + " "
                            + rs2.getString("course") + " " + rs2.getDate("birthday"));
                } else {
                    System.out.println("未找到该教师的记录。");
                }

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