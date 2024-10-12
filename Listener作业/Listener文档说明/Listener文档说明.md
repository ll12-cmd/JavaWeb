# Listener文档说明

使用了 Servlet 监听器（`ServletRequestListener`）来记录请求的开始和结束事件，同时还创建了一个简单的 Servlet 来测试这个监听器。

## 1. 实现方式说明

1. **Servlet 监听器 (`MyListener`)**:
   - **功能**: 监听所有的请求事件，并在请求开始和结束时记录相关信息（如请求时间、客户端地址、请求方法、URI、查询字符串和用户代理）。
     - 请求时间：`System.currentTimeMillis()`
     - 客户端地址：`HttpServletRequest` 的 `getRemoteAddr()`
     - 请求方法：`HttpServletRequest` 的 `getMethod()`
     - URI：`HttpServletRequest` 的 `getRequestURI()`
     - 查询字符串：`HttpServletRequest` 的 `getQueryString()`
     - 用户代理: `HttpServletRequest` 的 `getHeader("User-Agent")`
   - **方法**:
     - `requestInitialized(ServletRequestEvent sre)`: 当请求初始化时触发。它记录请求开始的时间，并输出请求的相关信息。
     - `requestDestroyed(ServletRequestEvent sre)`: 当请求处理完成时触发。它计算请求的处理时间并输出结束日志和处理时间。
   - **时间格式**: 使用 `SimpleDateFormat` 格式化当前时间，以便输出符合标准的日志格式。

2. **测试 Servlet (`TestServlet`)**:
   - **功能**: 提供一个简单的 HTTP GET 接口，返回包含请求参数的 HTML 响应。
   - **方法**:
     - `doGet(HttpServletRequest request, HttpServletResponse response)`: 处理 GET 请求，获取请求参数并生成 HTML 响应。

### 2. 运行结果
- **多出来的两次请求**：

  1.**第一次请求**

  - `10-10月-2024 20:29:46.628 请求开始 [127.0.0.1][GET][/listener_war_exploded/][No queryString][IntelliJ IDEA/241.18034.62]`
  
  - `10-10月-2024 20:29:46.636 处理完成 [127.0.0.1][GET][/listener_war_exploded/][No queryString][IntelliJ IDEA/241.18034.62] 处理时间：11 毫秒`

  2.**第二次请求**

  - `10-10月-2024 20:29:47.002 请求开始 [0:0:0:0:0:0:0:1][GET][/listener_war_exploded/][No queryString][Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36]`

  - `10-10月-2024 20:29:47.003 处理完成 [0:0:0:0:0:0:0:1][GET][/listener_war_exploded/][No queryString][Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36] 处理时间：1 毫秒`

  3.**请求`/test`**

  ![alt text](image-1.png)

    - `10-10月-2024 20:29:52.536 请求开始 [0:0:0:0:0:0:0:1][GET][/listener_war_exploded/test][No queryString][Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36]`

  - `10-10月-2024 20:29:52.537 处理完成 [0:0:0:0:0:0:0:1][GET][/listener_war_exploded/test][No queryString][Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36] 处理时间：1 毫秒`

  4.**请求`/test?xiaoliu`**

  ![alt text](image-2.png)

  - `10-10月-2024 21:13:27.753 请求开始 [0:0:0:0:0:0:0:1][GET][/listener_war_exploded/test][name=xiaoliu][Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36]`

  - `10-10月-2024 21:13:27.754 请求处理完成 [0:0:0:0:0:0:0:1][GET][/listener_war_exploded/test][name=xiaoliu][Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36] 处理时间：1 毫秒`

### 3. 需要注意的事项

1. **异常处理**:
   - 目前的实现没有对可能发生的异常进行处理（例如，类型转换异常、IO异常等）。建议在关键操作中添加异常处理，以提高代码的健壮性。

2. **日志输出**:
   - 目前使用 `System.out.println` 输出日志。在生产环境中，建议使用日志框架（如 SLF4J、Log4j 或 java.util.logging）来管理日志记录，以便更好地控制日志级别和输出格式。

3. **时间单位一致性**:
   - 在计算处理时间时，确保 `startTime` 和 `endTime` 的单位一致。你的代码中已经正确使用了毫秒，但在其他情况下需要注意。

### 4. 我的问题
1. **异常处理**：
- 我知道用更专业，但我不太会用，所以我的代码里并无这一方面的内容

2. **日志格式**：
- 我没有用专业的日志类而是根据标准的`Tomcat`日志格式通过 `String` 的`format()`方法来实现格式转换

3. **日志输出**：
- 我定义了一个`TestServlet`测试类，请求两次（一次无name,一次有name，即有无查询字符串）但是我运行代码却多了两个请求

4. **代码重复**：
- 由于请求开始和请求处理完成所要记录的内容大致相同，导致我的代码重复率较高
