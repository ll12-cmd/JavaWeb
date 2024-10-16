
-- 1. 查询所有学生的信息。
SELECT * 
FROM student;

-- 2. 查询所有课程的信息。
SELECT *
FROM course;

-- 3. 查询所有学生的姓名、学号和班级。
SELECT name ,student_id ,my_class
FROM student;

-- 4. 查询所有教师的姓名和职称。
SELECT name,title
FROM teacher;

-- 5. 查询不同课程的平均分数。
SELECT course_id,AVG(score) '平均分数'
FROM score
GROUP BY course_id;

-- 6. 查询每个学生的平均分数。
SELECT student_id,AVG(score) '平均分数'
FROM score
GROUP BY student_id;

-- 7. 查询分数大于85分的学生学号和课程号。
SELECT student_id,course_id
FROM score
WHERE score > 85;

-- 8. 查询每门课程的选课人数。
SELECT course_id,COUNT(student_id) '选课人数'
FROM score
GROUP BY course_id;

-- 9. 查询选修了"高等数学"课程的学生姓名和分数。
SELECT s.name,sc.score
FROM student s,score sc,course c
WHERE s.student_id=sc.student_id and sc.course_id=c.course_id and c.course_name='高等数学';

-- 10. 查询没有选修"大学物理"课程的学生姓名(course 外连接 student 和score)
SELECT s.name  
FROM student s  
LEFT JOIN score sc ON s.student_id = sc.student_id 
AND sc.course_id = (SELECT course_id FROM course WHERE course_name='大学物理')
WHERE sc.course_id IS NULL;

-- 11. 查询C001比C002课程成绩高的学生信息及课程分数。
SELECT   
    s.*, -- 学生信息
    sc1.score AS 'C001成绩',
    sc2.score AS 'C002成绩'
FROM score sc1  
JOIN score sc2 ON sc1.student_id = sc2.student_id  
JOIN student s ON s.student_id = sc1.student_id  
WHERE sc1.course_id = 'C001' AND sc2.course_id = 'C002' AND sc1.score > sc2.score;

-- 12. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
SELECT   
    c.course_id,  
    c.course_name,  
    -- 计算各科任意分数段选课人数 （在范围内取1否则取0，sum:计算值 n个1值为n）
    SUM(CASE WHEN sc.score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) AS '100-85人数',  
    SUM(CASE WHEN sc.score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) AS '85-70人数',  
    SUM(CASE WHEN sc.score BETWEEN 60 AND 69 THEN 1 ELSE 0 END) AS '70-60人数',  
    SUM(CASE WHEN sc.score < 60 OR sc.score IS NULL THEN 1 ELSE 0 END) AS '60-0人数',  
    COUNT(sc.student_id) AS total_students,  -- 计算各科选课总人数
    -- 计算各科任意分数段选课人数百分比
    (SUM(CASE WHEN sc.score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) / COUNT(sc.student_id)) * 100 AS '100-85百分比',  
    (SUM(CASE WHEN sc.score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) / COUNT(sc.student_id)) * 100 AS '85-70百分比',  
    (SUM(CASE WHEN sc.score BETWEEN 60 AND 69 THEN 1 ELSE 0 END) / COUNT(sc.student_id)) * 100 AS '70-60百分比',  
    (SUM(CASE WHEN sc.score < 60 OR sc.score IS NULL THEN 1 ELSE 0 END) / COUNT(sc.student_id)) * 100 AS '60-0百分比'  
FROM   
    course c  LEFT JOIN score sc ON c.course_id = sc.course_id  
GROUP BY c.course_id;

-- 13. 查询选择C002课程但没选择C004课程的学生的成绩情况(不存在时显示为 null )。
SELECT DISTINCT student_id,course_id,score
FROM score
WHERE student_id in
(SELECT student_id FROM score WHERE course_id='C002' 
AND  student_id NOT IN 
(SELECT student_id FROM score WHERE course_id='C004' )
);

-- 14. 查询平均分数最高的学生姓名和平均分数。
SELECT s.name,avg(sc.score) AS '平均分数'
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
ORDER BY 平均分数 DESC
LIMIT 1;

-- 15. 查询总分最高的前三名学生的姓名和总分。
SELECT s.name,SUM(sc.score) AS '总分'
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
ORDER BY 总分 DESC
LIMIT 3;

-- 16. 查询各科成绩最高分、最低分和平均分。要求如下：
-- 以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
-- 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
SELECT c.course_id,c.course_name,
 MAX(sc.score) '最高分',MIN(sc.score) '最低分',AVG(sc.score) '平均分',
 SUM(CASE WHEN sc.score >=60 THEN 1 ELSE 0 END) AS '及格人数',
 SUM(CASE WHEN sc.score BETWEEN 70 AND 80 THEN 1 ELSE 0 END) AS '中等人数',
 SUM(CASE WHEN sc.score BETWEEN 80 AND 90 THEN 1 ELSE 0 END) AS '优良人数',
 SUM(CASE WHEN sc.score >=90 THEN 1 ELSE 0 END) AS '优秀人数',
 COUNT(sc.student_id) AS '选修人数',
 -- 比率用百分比
 (SUM(CASE WHEN sc.score >=60 THEN 1 ELSE 0 END) / COUNT(sc.student_id)) *100 AS '及格率',
 (SUM(CASE WHEN sc.score BETWEEN 70 AND 80 THEN 1 ELSE 0 END) / COUNT(sc.student_id)) *100 AS '中等率',
 (SUM(CASE WHEN sc.score BETWEEN 80 AND 90 THEN 1 ELSE 0 END) / COUNT(sc.student_id)) *100 AS '优良率',
 (SUM(CASE WHEN sc.score >=90 THEN 1 ELSE 0 END) / COUNT(sc.student_id))*100 AS '及格率'
FROM course c JOIN score sc ON c.course_id=sc.course_id
GROUP BY c.course_id
ORDER BY 选修人数 DESC,sc.course_id ASC;

-- 17. 查询男生和女生的人数（学生）。
SELECT gender, COUNT(student_id) '人数'
FROM student 
GROUP BY gender;


-- 18. 查询年龄最大的学生姓名。
-- 法一 order by
SELECT name
FROM student
ORDER BY birth_date ASC
LIMIT 1;

-- 法二 嵌套
SELECT name
FROM student
WHERE birth_date=
(SELECT MIN(birth_date) FROM student 
);

-- 19. 查询年龄最小的教师姓名。
-- 法一 order by
SELECT name
FROM teacher
ORDER BY birth_date DESC
LIMIT 1;

-- 法二 嵌套
SELECT name
FROM teacher
WHERE birth_date=
(SELECT MAX(birth_date) FROM teacher
);

-- 20. 查询学过「张教授」授课的同学的信息。
SELECT s.* 
FROM teacher t,course c ,score sc ,student s
WHERE t.teacher_id=c.teacher_id 
 AND c.course_id=sc.course_id 
 AND sc.student_id=s.student_id
 AND t.name='张教授' ;

-- 21. 查询至少有一门课与学号为"2021001"的同学所学相同的同学的信息 。
SELECT DISTINCT s.* 
FROM student s JOIN score sc ON s.student_id=sc.student_id
WHERE sc.course_id IN
(SELECT course_id FROM score WHERE student_id='2021001');

-- 22. 查询每门课程的平均分数，并按平均分数降序排列。
SELECT course_id,AVG(score) '平均分数'
FROM score
GROUP BY course_id
ORDER BY 平均分数 DESC;

-- 23. 查询学号为"2021001"的学生所有课程的分数。
SELECT course_id,score
FROM score
WHERE student_id='2021001';

-- 24. 查询所有学生的姓名、选修的课程名称和分数。
SELECT s.name,c.course_name,sc.score
FROM score sc
 JOIN student s ON sc.student_id=s.student_id
 JOIN course c ON sc.course_id=c.course_id;

-- 25. 查询每个教师所教授课程的平均分数。
SELECT t.teacher_id,AVG(sc.score) '平均分数'
FROM course c
 JOIN teacher t ON t.teacher_id=c.teacher_id
 JOIN score sc ON sc.course_id=c.course_id
 GROUP BY t.teacher_id;

-- 26. 查询分数在80到90之间的学生姓名和课程名称。
SELECT s.name,c.course_name
FROM score sc
 JOIN student s ON sc.student_id=s.student_id
 JOIN course c ON sc.course_id=c.course_id
WHERE sc.score BETWEEN 80 AND 90;

-- 27. 查询每个班级的平均分数。
SELECT s.my_class,AVG(sc.score) '平均分数'
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.my_class;

-- 28. 查询没学过"王讲师"老师讲授的任一门课程的学生姓名。
SELECT name FROM student 
EXCEPT 
SELECT  s.name
FROM student s JOIN score sc ON s.student_id=sc.student_id
WHERE sc.course_id IN
(SELECT c.course_id 
 FROM course c JOIN teacher t ON t.teacher_id=c.teacher_id
 WHERE t.name='王讲师'
 );
 
-- 29. 查询两门及其以上小于85分的同学的学号，姓名及其平均成绩。
SELECT s.student_id,s.name,AVG(sc.score) '平均成绩',
 SUM(CASE WHEN sc.score <85 THEN 1 ELSE 0 END) AS count_less_85
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
HAVING count_less_85>=2;

-- 30. 查询所有学生的总分并按降序排列。
SELECT student_id,SUM(score) AS 总分
FROM score
GROUP BY student_id
ORDER BY 总分 DESC;

-- 31. 查询平均分数超过85分的课程名称。
SELECT c.course_name,AVG(sc.score) AS 平均分数
FROM score sc JOIN course c ON sc.course_id=c.course_id
GROUP BY sc.course_id
HAVING 平均分数>85;

-- 32. 查询每个学生的平均成绩排名。
SELECT student_id,AVG(score) AS 平均成绩,
RANK() OVER (ORDER BY AVG(score) DESC) AS 排名
FROM score
GROUP BY student_id
ORDER BY 排名;

-- 33. 查询每门课程分数最高的学生姓名和分数。
WITH rankedScore AS (  
    SELECT course_id,score, student_id,
	RANK() OVER (PARTITION BY course_id ORDER BY score DESC) AS rank_score  
    FROM score
)  
SELECT r.course_id,s.name,r.score  
FROM rankedScore r JOIN student s ON r.student_id =s.student_id 
WHERE rank_score = 1;

-- 34. 查询选修了"高等数学"和"大学物理"的学生姓名。
SELECT s.name
FROM score sc
 JOIN student s ON sc.student_id=s.student_id
 JOIN course c ON sc.course_id=c.course_id
WHERE c.course_name IN ('高等数学','大学物理')
GROUP BY s.student_id
HAVING COUNT(DISTINCT c.course_id)=2;

-- 35. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩（！！！没法处理没有选课则为空）。
SELECT s.student_id,sc.course_id,sc.score,
AVG(sc.score) OVER (PARTITION BY s.student_id) AS 平均成绩
FROM student s 
LEFT JOIN score sc ON s.student_id = sc.student_id  
LEFT JOIN course c ON sc.course_id=c.course_id
ORDER BY 平均成绩 DESC ,s.student_id,c.course_id;

-- 36. 查询分数最高和最低的学生姓名及其分数。（所有成绩比较?）
WITH rankedScore AS(  
 SELECT s.name AS 学生姓名,  
        sc.score AS 分数,  
        RANK() OVER (ORDER BY sc.score DESC) AS rdesc,  
        RANK() OVER (ORDER BY sc.score ASC) AS rasc  
 FROM student s JOIN score sc ON s.student_id = sc.student_id  
)  
SELECT 学生姓名, 分数  
FROM rankedScore 
WHERE rdesc = 1 OR rasc = 1;

-- 分开来实现
 SELECT s.name,MAX(sc.score) AS 最高分数
 FROM student s JOIN score sc ON s.student_id=sc.student_id
 WHERE score
 GROUP BY s.student_id
 ORDER BY 最高分数 DESC LIMIT 1;
 
 SELECT s.name,MIN(sc.score) AS 最低分数
 FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
ORDER BY 最低分数 ASC LIMIT 1;

-- 37. 查询每个班级的最高分和最低分。
SELECT s.my_class AS 班级, MAX(sc.score) AS 最高分, MIN(sc.score) AS 最低分  
FROM student s JOIN score sc ON s.student_id = sc.student_id  
GROUP BY s.my_class;

-- 38. 查询每门课程的优秀率（优秀为90分）。
SELECT course_id,
 ( SUM(CASE WHEN score >=90 THEN 1 ELSE 0 END) / COUNT(score) ) * 100 AS 优秀率（百分比）
FROM score
GROUP BY course_id;

-- 39. 查询平均分数超过班级平均分数的学生。
-- 班级平均分子表
WITH classAvgScore AS(
 SELECT s.my_class,AVG(sc.score) AS 班级平均分
 FROM student s JOIN score sc ON s.student_id=sc.student_id
 GROUP BY s.my_class
)
SELECT s.*,AVG(sc.score) AS 学生平均分,cas.班级平均分
 FROM student s 
 JOIN score sc ON s.student_id=sc.student_id
 JOIN classAvgScore cas ON s.my_class=cas.my_class
 GROUP BY s.student_id
 HAVING 学生平均分> cas.班级平均分;

-- 40. 查询每个学生的分数及其与课程平均分的差值。
-- 课程平均成绩子表
WITH courseAvgScore AS(
 SELECT course_id,AVG(score) AS 课程平均分
 FROM score
 GROUP BY course_id
)
SELECT sc.student_id,sc.course_id,sc.score,cas.课程平均分,
ABS(sc.score - cas.课程平均分) AS 与课程平均分的差值
FROM score sc JOIN courseAvgScore cas ON sc.course_id = cas.course_id;

-- 41. 查询至少有一门课程分数低于80分的学生姓名。
SELECT s.name
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN sc.score<80 THEN 1 ELSE 0 END) >=1;

-- 42. 查询所有课程分数都高于85分的学生姓名。
SELECT s.name
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN sc.score>85 THEN 1 ELSE 0 END) = COUNT(sc.course_id);

-- 43. 查询平均成绩大于等于90分的同学的学生编号和学生姓名和平均成绩。
SELECT s.student_id,s.name,AVG(sc.score) AS 平均成绩
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id
HAVING 平均成绩>=90;

-- 44. 查询选修课程数量最少的学生姓名。（都选三门即查询出全部的学生）
SELECT name 
FROM 
(SELECT s.name,COUNT(sc.course_id),
RANK() OVER(ORDER BY COUNT(sc.course_id)) AS rank_course
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id) AS minCourseCount
WHERE minCourseCount.rank_course=1;

-- 45. 查询每个班级的第2名学生（按平均分数排名）。
SELECT my_class,student_id,name,平均分数
FROM
(
SELECT s.student_id,s.name,s.my_class,AVG(sc.score) AS 平均分数,
RANK() OVER(PARTITION BY s.my_class ORDER BY AVG(sc.score) DESC) AS rank_avg_score
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.student_id) AS rankAvgScore
WHERE rank_avg_score=2;

-- 46. 查询每门课程分数前三名的学生姓名和分数。
SELECT course_id,name,score
FROM (
SELECT sc.course_id,s.name,sc.score,
RANK() OVER(PARTITION BY sc.course_id ORDER BY sc.score DESC) AS rank_score
FROM student s JOIN score sc ON s.student_id=sc.student_id
) AS courseScoreRank
WHERE rank_score <=3;

-- 47. 查询平均分数最高和最低的班级。
WITH classAvgRank AS (
SELECT my_class,  AVG(sc.score) AS 平均分数,
RANK() OVER(ORDER BY AVG(sc.score) DESC) AS rdesc,
RANK() OVER(ORDER BY AVG(sc.score) ASC) AS rasc
FROM student s JOIN score sc ON s.student_id=sc.student_id
GROUP BY s.my_class
)
SELECT  my_class,平均分数
FROM classAvgRank
WHERE rdesc=1 or rasc =1;

-- 48. 查询每个学生的总分和他所在班级的平均分数。
-- 班级平均分子表
WITH classAvgScore AS(
 SELECT s.my_class,AVG(sc.score) AS 所在班级平均分
 FROM student s JOIN score sc ON s.student_id=sc.student_id
 GROUP BY s.my_class
)
SELECT sc.student_id,SUM(sc.score) AS 总分,cas.所在班级平均分
FROM score sc 
JOIN student s ON s.student_id=sc.student_id
JOIN classAvgScore cas ON s.my_class=cas.my_class
GROUP BY sc.student_id;

-- 49. 查询每个学生的最高分的课程名称, 学生名称，成绩。
WITH maxScoreCourse AS (
SELECT c.course_name,s.name,sc.score ,
RANK() OVER(PARTITION BY s.student_id ORDER BY sc.score DESC ) AS rank_score
FROM student s 
JOIN score sc ON s.student_id=sc.student_id
JOIN course c ON sc.course_id=c.course_id
)
SELECT name,course_name,score AS 最高分 
FROM maxScoreCourse
WHERE rank_score =1;

-- 50. 查询每个班级的学生人数和平均年龄。
SELECT my_class AS 班级,
COUNT(student_id) AS 学生人数,
AVG(YEAR(CURRENT_DATE() )-YEAR(birth_date)) AS 平均年龄
FROM student
GROUP BY my_class;
