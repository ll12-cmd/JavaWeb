package gzu;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class UserStore {//存储用户名和密码便于登录验证（每次启动服务器都会清空）
    private static final Map<String, String> users = new HashMap<>(); // 存储用户名和密码

    //检查是否注册成功
    public static boolean registerUser(String username, String password) {
        if (users.containsKey(username)) {
            return false; // 用户已存在
        }
        users.put(username, password);
        return true; // 注册成功
    }

    public static boolean validateUser(String username, String password) {
        return password.equals(users.get(username)); // 验证用户（匹配用户名和密码）
    }

    public static Collection<String> getRegisteredUsers() {
        return users.keySet(); // 返回已注册用户
    }
}