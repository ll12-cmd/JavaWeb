-- 1.查询所有员工的姓名、邮箱和工作岗位。
SELECT  concat(first_name,' ' ,last_name) AS 'name',email,job_title
FROM employees;

-- 2. 查询所有部门的名称和位置。
SELECT dept_name,location
FROM departments;

-- 3. 查询工资超过70000的员工姓名和工资。
SELECT CONCAT(first_name,' ',last_name) AS name,salary
FROM employees
WHERE salary>70000;

-- 4. 查询IT部门的所有员工。
SELECT employees.*
FROM employees,departments
WHERE employees.dept_id=departments.dept_id AND departments.dept_name='IT';

-- 5. 查询入职日期在2020年之后的员工信息。
SELECT * 
FROM employees
WHERE YEAR(hire_date)>2019;

SELECT * 
FROM employees
WHERE hire_date>'2020-01-01';

-- 6. 计算每个部门的平均工资。
SELECT dept_id,AVG(salary) as '平均工资'
FROM employees
GROUP BY dept_id;

-- 7. 查询工资最高的前3名员工信息。
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 3;

-- 8. 查询每个部门员工数量。
SELECT dept_id,COUNT(emp_id) '员工数量'
FROM employees
GROUP BY dept_id;

-- 9. 查询没有分配部门的员工。
SELECT *
FROM employees
WHERE dept_id IS NULL;

-- 10. 查询参与项目数量最多的员工。
SELECT e.* ,COUNT(project_id) as count_product_id
FROM employees e JOIN employee_projects ep ON e.emp_id=ep.emp_id
GROUP BY(e.emp_id)
HAVING count_product_id=
(
	SELECT MAX(count_product_id)
	FROM(SELECT COUNT(project_id) as count_product_id from employee_projects GROUP BY(emp_id)) AS subquery
) ;

-- 11. 计算所有员工的工资总和。
SELECT SUM(salary) '工资总和'
FROM employees;

-- 12. 查询姓"Smith"的员工信息。
SELECT * 
FROM employees
WHERE last_name='Smith';

-- 13. 查询即将在半年内到期的项目。
-- datediff(a,b) a到b经历的天数
SELECT *  
FROM projects  
WHERE DATEDIFF(end_date, CURDATE()) <= 180 AND DATEDIFF(end_date, CURDATE()) >= 0;

-- 14. 查询至少参与了两个项目的员工。
SELECT e.*,COUNT(project_id) as count_product_id
FROM employees e JOIN employee_projects ep ON e.emp_id=ep.emp_id 
GROUP BY e.emp_id
HAVING count_product_id>=2;

-- 15. 查询没有参与任何项目的员工。
SELECT *
FROM employees e 
LEFT  JOIN employee_projects ep ON e.emp_id=ep.emp_id
WHERE ep.project_id IS NULL;
 
-- 16. 计算每个项目参与的员工数量。
SELECT project_id, COUNT(emp_id)
FROM employee_projects
GROUP BY project_id;

-- 17. 查询工资第二高的员工信息。
SELECT * 
FROM employees 
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

-- 18. 查询每个部门工资最高的员工。
SELECT *
FROM employees
WHERE salary in(
SELECT MAX(salary) AS max_salary
FROM employees
GROUP BY dept_id
HAVING salary=max_salary
);

-- 19. 计算每个部门的工资总和,并按照工资总和降序排列。
SELECT dept_id,SUM(salary) AS '工资总和'
FROM employees
GROUP BY dept_id
ORDER BY 工资总和 DESC; -- 工资总和不加引号

-- 20. 查询员工姓名、部门名称和工资。
SELECT CONCAT(e.first_name,' ',e.last_name) AS name,dept_name,salary
FROM employees e LEFT JOIN departments d ON e.dept_id=d.dept_id;

-- 21. 查询每个员工的上级主管(假设emp_id小的是上级)。
SELECT e1.emp_id, e2.emp_id AS '主管id'
FROM employees e1 JOIN employees e2 ON e1.emp_id=e2.emp_id+1;

-- 22. 查询所有员工的工作岗位,不要重复。
SELECT DISTINCT emp_id,(job_title)
FROM employees;

-- 23. 查询平均工资最高的部门。
SELECT dept_id,AVG(salary) '平均工资'
FROM employees
GROUP BY dept_id
ORDER BY 平均工资 DESC
LIMIT 1;

-- 24. 查询工资高于其所在部门平均工资的员工。
SELECT e.* 
FROM employees e JOIN(
SELECT dept_id,AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id
)AS dept_avg_salary ON e.dept_id = dept_avg_salary.dept_id
WHERE salary>avg_salary;

-- 28. 查询本月过生日的员工(假设hire_date是生日)。
SELECT * 
FROM employees
WHERE MONTH(hire_date)=MONTH(CURDATE());

-- 30. 计算每个项目的持续时间(天数)。
SELECT project_id, DATEDIFF(end_date,start_date) '持续时间（天数）'
FROM projects
GROUP BY project_id;

-- 34. 计算每个员工的薪资涨幅(假设每年涨5%)。
SELECT emp_id,salary*0.05*(YEAR(CURDATE())-YEAR(hire_date)) AS '薪资涨幅'
FROM employees;

-- 35. 查询入职时间最长的3名员工。
SELECT *
FROM employees
ORDER BY hire_date
LIMIT 3;

-- 36. 查询名字和姓氏相同的员工。
SELECT *
FROM employees
WHERE first_name=last_name;

-- 39. 查询姓名包含"son"的员工信息。
SELECT *
FROM employees
WHERE first_name LIKE '%son%' or last_name LIKE '%son%';

-- 43. 查询工作岗位名称里包含"Manager"但不在管理岗位(salary<70000)的员工。
SELECT *
FROM employees
WHERE job_title LIKE '%Manager' and salary<70000;

-- 47. 查询员工姓名和他参与的项目数量。
SELECT CONCAT(first_name,' ',last_name) 'name',COUNT(ep.project_id) '项目数量'
FROM employees e JOIN employee_projects ep ON e.emp_id=ep.emp_id
GROUP BY e.emp_id;
