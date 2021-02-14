# 1、查找最晚入职员工的所有信息，为了减轻入门难度，目前所有的数据里员工入职的日期都不是同一天(sqlite里面的注释为--,mysql为comment)
select emp_no,birth_date ,first_name ,last_name ,gender,hire_date
from employees
order by hire_date desc
limit 1;

# 2、查找入职员工时间排名倒数第三的员工所有信息，为了减轻入门难度，目前所有的数据里员工入职的日期都不是同一天
select emp_no,birth_date,first_name,last_name,gender,hire_date
from employees
order by hire_date desc
limit 2,1;

# 3、查找各个部门当前(dept_manager.to_date='9999-01-01')领导当前(salaries.to_date='9999-01-01')薪水详情以及其对应部门编号dept_no
# (注:输出结果以salaries.emp_no升序排序，并且请注意输出结果里面dept_no列是最后一列)
select s.* ,d.dept_no from salaries s inner join dept_manager d
on s.emp_no = d.emp_no
where d.to_date = '9999-01-01' and s.to_date='9999-01-01'
order by s.emp_no ;

# 4、查找所有已经分配部门的员工的last_name和first_name以及dept_no(请注意输出描述里各个列的前后顺序)
select e.last_name,e.first_name,d.dept_no from dept_emp d  left join employees e
on d.emp_no = e.emp_no;

# 5、查找所有员工的last_name和first_name以及对应部门编号dept_no，也包括暂时没有分配具体部门的员工(请注意输出描述里各个列的前后顺序)
select e.last_name,e.first_name,d.dept_no from employees e left join dept_emp d
on e.emp_no = d.emp_no;

# 6、查找所有员工入职时候的薪水情况，给出emp_no以及salary， 并按照emp_no进行逆序(请注意，一个员工可能有多次涨薪的情况)
select e.emp_no,s.salary from employees e inner join salaries s on e.emp_no = s.emp_no
group by e.emp_no order by e.emp_no desc;

# 7、查找薪水变动超过15次的员工号emp_no以及其对应的变动次数t
select emp_no,count(salary) as t from salaries group by emp_no having t > 15 order by  t desc;

# 8、找出所有员工当前(to_date='9999-01-01')具体的薪水salary情况，对于相同的薪水只显示一次,并按照逆序显示
select distinct salary from salaries where to_date = '9999-01-01' order by salary desc;

# 9、获取所有部门当前(dept_manager.to_date='9999-01-01')manager的当前(salaries.to_date='9999-01-01')薪水情况，
# 给出dept_no, emp_no以及salary，输出结果按照dept_no升序排列(请注意，同一个人可能有多条薪水情况记录)
select d.dept_no,d.emp_no,s.salary from dept_manager d inner join salaries s
on d.emp_no = s.emp_no
where d.to_date = '9999-01-01'and s.to_date = '9999-01-01'
order by d.dept_no ;

# 10、获取所有非manager的员工emp_no
select e.emp_no from employees e left  join dept_manager dm
on e.emp_no = dm.emp_no where dm.emp_no is null ;

# 11、获取所有员工当前的(dept_manager.to_date='9999-01-01')manager，如果员工是manager的话不显示(也就是如果当前的manager是自己的话结果不显示)。
# 输出结果第一列给出当前员工的emp_no,第二列给出其manager对应的emp_no。
select de.emp_no ,dm.emp_no as manager_no from dept_manager dm join dept_emp de on dm.dept_no = de.dept_no
and de.emp_no != dm.emp_no where dm.to_date = '9999-01-01';

# 12、获取所有部门中当前(dept_emp.to_date = '9999-01-01')员工当前(salaries.to_date='9999-01-01')薪水最高的相关信息，
# 给出dept_no, emp_no以及其对应的salary，按照部门编号升序排列。
select de.dept_no,de.emp_no,max(s.salary)as salary from dept_emp de inner join salaries s
on de.emp_no = s.emp_no
where de.to_date = '9999-01-01' and s.to_date = '9999-01-01' order by de.emp_no ;

# 13、从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
select title,count(title) as t from titles group by title having count(title) >=2;

# 14、从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
# 注意对于重复的emp_no进行忽略(即emp_no重复的title不计算，title对应的数目t不增加)。
select title,count(distinct emp_no) as t from titles group by title having count(title)>=2;

# 15、查找employees表所有emp_no为奇数，且last_name不为Mary(注意大小写)的员工信息，并按照hire_date逆序排列
select * from employees e where e.last_name !='Mary'and e.emp_no %2 !=0
order by e.hire_date desc ;

# 16、统计出当前(titles.to_date='9999-01-01')各个title类型对应的员工当前(salaries.to_date='9999-01-01')薪水对应的平均工资。
# 结果给出title以及平均工资avg。
select t.title,avg(s.salary) as avg from salaries s inner join titles t
on s.emp_no = t.emp_no  where  t.to_date = '9999-01-01'and s.to_date='9999-01-01'
group by t.title;

# 17、获取当前（to_date='9999-01-01'）薪水第二多的员工的emp_no以及其对应的薪水salary
select s.emp_no,s.salary from salaries s where s.to_date = '9999-01-01'
order by s.salary desc limit 1,1;

# 18、查找当前薪水(to_date='9999-01-01')排名第二多的员工编号emp_no、薪水salary、last_name以及first_name，
# 你可以不使用order by完成吗
select s.emp_no,max(s.salary) as salary,e.last_name,e.first_name from salaries s join employees e
on s.emp_no = e.emp_no where s.to_date = '9999-01-01'
and s.salary <(select max(salary) from salaries);

# 19、查找所有员工的last_name和first_name以及对应的dept_name，也包括暂时没有分配部门的员工
select e.last_name,e.first_name,d.dept_name from employees e left join dept_emp de on e.emp_no = de.emp_no
left join departments d on de.dept_no = d.dept_no;

# 20、查找员工编号emp_no为10001其自入职以来的薪水salary涨幅(总共涨了多少)growth(可能有多次涨薪，没有降薪)
select (max(salary)-min(salary)) as growth from salaries s where s.emp_no='10001';

# 21、查找所有员工自入职以来的薪水涨幅情况，给出员工编号emp_no以及其对应的薪水涨幅growth，并按照growth进行升序
# （注:可能有employees表和salaries表里存在记录的员工，有对应的员工编号和涨薪记录，但是已经离职了，离职的员工salaries表的最新的to_date!='9999-01-01'，这样的数据不显示在查找结果里面）

select a.emp_no,(a.salary-b.salary) as growth from (select emp_no,salary from salaries where to_date = '9999-01-01') a  inner join
              (select e.emp_no,s.salary from employees e inner join salaries s on e.emp_no = s.emp_no where e.hire_date = s.from_date) b
on a.emp_no = b.emp_no order by growth; # 思路：先建新工资表减去旧工资表

# 22、统计各个部门的工资记录数，给出部门编码dept_no、部门名称dept_name以及部门在salaries表里面有多少条记录sum，按照dept_no升序排序
select d.dept_no,d.dept_name,count(salary) as sum from departments d left join dept_emp de on d.dept_no = de.dept_no
left join salaries s on de.emp_no = s.emp_no group by d.dept_no order by d.dept_no;

# 23、对所有员工的当前(to_date='9999-01-01')薪水按照salary进行按照1-N的排名，相同salary并列且按照emp_no升序排列
select emp_no,salary,dense_rank() over (order by salary desc )  as t_rank  from salaries
where to_date = '9999-01-01' order by t_rank,emp_no;

# 24、获取所有非manager员工当前的薪水情况，给出dept_no、emp_no以及salary ，当前表示to_date='9999-01-01'
select de.dept_no,e.emp_no,s.salary from employees e
inner join salaries s on e.emp_no = s.emp_no
inner join dept_emp de on e.emp_no = de.emp_no
where de.to_date ='9999-01-01'and s.to_date='9999-01-01'
and e.emp_no not in (select emp_no from dept_manager where dept_manager.to_date  ='9999-01-01');
## 思路：先内接三张表，然后条件判断塞个not in .

# 25、获取员工其当前的薪水比其manager当前薪水还高的相关信息，当前表示to_date='9999-01-01',
# 结果第一列给出员工的emp_no，
# 第二列给出其manager的manager_no，
# 第三列给出该员工当前的薪水emp_salary,
# 第四列给该员工对应的manager当前的薪水manager_salary

# 这种场景，最重要的是学会拆分，把复杂的查询分成一个个简单的查询，最后再将其组合在一起，这便是分合的思想。
select a.emp_no,manager_no,emp_salary,manager_salary
from(
    select dept_no,de.emp_no,salary emp_salary
    from dept_emp de inner join salaries s on de.emp_no=s.emp_no
    where de.to_date='9999-01-01' and s.to_date='9999-01-01'
    ) a
inner join(
    select dept_no,dm.emp_no manager_no,salary manager_salary
    from dept_manager dm inner join salaries s on dm.emp_no=s.emp_no
    where dm.to_date='9999-01-01' and s.to_date='9999-01-01'
    ) b
on a.dept_no=b.dept_no
where a.emp_salary>b.manager_salary;

# 26、汇总各个部门当前员工的title类型的分配数目，即结果给出部门编号dept_no、dept_name、其部门下所有的当前(dept_emp.to_date
# = '9999-01-01')员工的当前(titles.to_date = '9999-01-01')title以及该类型title对应的数目count，结果按照dept_no升序排序
# (注：因为员工可能有离职，所有dept_emp里面to_date不为'9999-01-01'就已经离职了，不计入统计，而且员工可能有晋升，所以如果titles.to_date
# 不为 '9999-01-01'，那么这个可能是员工之前的职位信息，也不计入统计)
select de.dept_no,d.dept_name,t.title, count(t.title) count from dept_emp de join departments d on de.dept_no = d.dept_no
join titles t on de.emp_no = t.emp_no where de.to_date = '9999-01-01' and t.to_date = '9999-01-01'
group by  de.dept_no,t.title order by de.dept_no;

# 27、给出每个员工每年薪水涨幅超过5000的员工编号emp_no、薪水变更开始日期from_date以及薪水涨幅值salary_growth，并按照salary_growth逆序排列。
# 提示：在sqlite中获取datetime时间对应的年份函数为strftime('%Y', to_date)
# (数据保证每个员工的每条薪水记录to_date-from_date=1年，而且同一员工的下一条薪水记录from_data=上一条薪水记录的to_data)
select s1.emp_no,s2.from_date,(s2.salary-s1.salary) salary_growth from salaries s1 join salaries s2 on s1.emp_no = s2.emp_no
where (date_format(s2.from_date,'%Y')-date_format(s1.from_date,'%Y') = 1 or date_format(s2.to_date,'%Y')-date_format(s1.to_date,'%Y') = 1 )
and s2.salary-s1.salary >5000
order by salary_growth desc ;

# 32、将employees表的所有员工的last_name和first_name拼接起来作为Name，中间以一个空格区分
# (注：sqllite,字符串拼接为 || 符号，不支持concat函数，mysql支持concat函数)
select concat(e.last_name,' ',e.first_name) Name from employees e;

# 39、针对salaries表emp_no字段创建索引idx_emp_no，查询emp_no为10005, 使用强制索引。
# create index idx_emp_no on salaries(emp_no)
select * from salaries force index (idx_emp_no) where emp_no = 10005;

# 40、构造一个触发器audit_log，在向employees_test表中插入一条数据的时候，触发插入相关的数据到audit中。
# 先建两表
CREATE TABLE employees_test(
ID INT PRIMARY KEY NOT NULL,
NAME TEXT NOT NULL,
AGE INT NOT NULL,
ADDRESS CHAR(50),
SALARY REAL
);
CREATE TABLE audit(
EMP_no INT NOT NULL,
NAME TEXT NOT NULL
);
# 再开始创建触发器
drop trigger if exists audit_log ;# 先删除原有的触发器
create trigger audit_log after insert on employees_test for each row
begin
    insert into audit values (NEW.ID,NEW.NAME);
end;
# 触发器简述：
# 1.创建触发器使用语句：CREATE TRIGGER trigname;
# 2.指定触发器触发的事件在执行某操作之前还是之后，使用语句：BEFORE/AFTER [INSERT/UPDATE/ADD] ON tablename
# 3.触发器触发的事件写在BEGIN和END之间；
# 4.触发器中可以通过NEW获得触发事件之后2对应的tablename的相关列的值，OLD获得触发事件之前的2对应的tablename的相关列的值


#42、删除emp_no重复的记录，只保留最小的id对应的记录。
# 先创建表再执行操作：
CREATE TABLE IF NOT EXISTS titles_test (
id int(11) not null primary key,
emp_no int(11) NOT NULL,
title varchar(50) NOT NULL,
from_date date NOT NULL,
to_date date DEFAULT NULL);

insert into titles_test
values  ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
        ('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
        ('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
        ('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
        ('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
        ('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
        ('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');
# 创建语句
delete from titles_test where id not in
(select M.id from (select min(id) id  from titles_test group by emp_no )M);

# 最后删掉表titles_test
drop table if exists titles_test;

# 43、将所有to_date为9999-01-01的全部更新为NULL,且 from_date更新为2001-01-01。
CREATE TABLE IF NOT EXISTS titles_test (
id int(11) not null primary key,
emp_no int(11) NOT NULL,
title varchar(50) NOT NULL,
from_date date NOT NULL,
to_date date DEFAULT NULL);

insert into titles_test values ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');
# 基本的数据更新语法，UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值 update titles_test set to_date = null ,
# from_date = '2001-01-01' where to_date = '9999-01-01'
update titles_test  set to_date = null,from_date='2001-01-01' where to_date = '9999-01-01';
# 删除创建的titles_test:
drop table titles_test;
# 44、将id=5以及emp_no=10001的行数据替换成id=5以及emp_no=10005,其他数据保持不变，使用replace实现，直接使用update会报错了。
CREATE TABLE titles_test (
   id int(11) not null primary key,
   emp_no  int(11) NOT NULL,
   title  varchar(50) NOT NULL,
   from_date  date NOT NULL,
   to_date  date DEFAULT NULL);

insert into titles_test values
('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');

# 创建语句：
update titles_test set emp_no= replace(emp_no,10001,10005) where id = 5;

# 45、将titles_test表名修改为titles_2017。
#相关用法：
#ALTER TABLE 表名 ADD 列名/索引/主键/外键等；
#ALTER TABLE 表名 DROP 列名/索引/主键/外键等；
#ALTER TABLE 表名 ALTER 仅用来改变某列的默认值；
#ALTER TABLE 表名 RENAME 列名/索引名 TO 新的列名/新索引名；
#ALTER TABLE 表名 RENAME TO/AS 新表名;
#ALTER TABLE 表名 MODIFY 列的定义但不改变列名；
#ALTER TABLE 表名 CHANGE 列名和定义都可以改变。
alter table titles_test rename to titles_2017;

#46、在audit表上创建外键约束，其emp_no对应employees_test表的主键id。
alter table audit add foreign key(EMP_no) references employees_test(ID);

#48、请你写出更新语句，将所有获取奖金的员工当前的(salaries.to_date='9999-01-01')薪水增加10%。
# (emp_bonus里面的emp_no都是当前获奖的所有员工)
create table emp_bonus(
emp_no int not null,
btype smallint not null);
INSERT INTO emp_bonus VALUES (10001,1);
update salaries set salary= salary*1.1 where to_date ='9999-01-01'and emp_no
in (select emp_no from emp_bonus );
drop table emp_bonus;
# 50、将employees表中的所有员工的last_name和first_name通过(')连接起来。(sqlite不支持concat，请用||实现，mysql支持concat)
select concat(last_name,"'",first_name) name from employees;

# 51、查找字符串'10,A,B' 中逗号','出现的次数cnt。
select length('10,A,B')-length(replace('10,A,B',',','')) cnt;

# 52、获取Employees中的first_name，查询按照first_name最后两个字母，按照升序进行排列
select first_name from employees order by substr(first_name,-2,2);

# 53、按照dept_no进行汇总，属于同一个部门的emp_no按照逗号进行连接，结果给出dept_no以及连接出的结果employees
# group_concat(X,Y)函数返回X的非null值的连接后的字符串。如果给出了参数Y，将会在每个X之间用Y作为分隔符。如果省略了Y，“，”将作为默认的分隔符。
# 每个元素连接的顺序是随机的。
select dept_no,group_concat(emp_no,'')  from dept_emp group by dept_no;

# 54、查找排除最大、最小salary之后的当前(to_date = '9999-01-01' )员工的平均工资avg_salary。
select avg(salary) avg_salary from salaries where to_date = '9999-01-01'
and salary !=(select max(salary)from salaries where to_date = '9999-01-01')
and salary !=(select min(salary)from salaries where to_date = '9999-01-01');

# 55、分页查询employees表，每5行一页，返回第2页的数据
select * from employees limit 5,5;

# 56、获取所有员工的emp_no、部门编号dept_no以及对应的bonus类型btype和received，没有分配奖金的员工不显示对应的bonus类型btype和received
CREATE TABLE `emp_bonus`(
emp_no int(11) NOT NULL,
received datetime NOT NULL,
btype smallint(5) NOT NULL);

SELECT e.emp_no,d.dept_no,b.btype,b.received
FROM employees e JOIN dept_emp d ON e.emp_no = d.emp_no
LEFT JOIN emp_bonus b ON e.emp_no = b.emp_no;

# 57、使用含有关键字exists查找未分配具体部门的员工的所有信息。
select * from employees e
where not exists(select emp_no from dept_emp where e.emp_no = dept_emp.emp_no);

# 59、获取有奖金的员工相关信息。
# 给出emp_no、first_name、last_name、奖金类型btype、对应的当前薪水情况salary以及奖金金额bonus。
# bonus类型btype为1其奖金为薪水salary的10%，btype为2其奖金为薪水的20%，其他类型均为薪水的30%。 当前薪水表示to_date='9999-01-01'
create table emp_bonus(
emp_no int not null,
received datetime not null,
btype smallint not null);

# 创建查询语句：
SELECT e.emp_no, e.first_name, e.last_name, b.btype, s.salary,
(CASE b.btype
 WHEN 1 THEN s.salary * 0.1
 WHEN 2 THEN s.salary * 0.2
 ELSE s.salary * 0.3 END) AS bonus
FROM employees AS e INNER JOIN emp_bonus AS b ON e.emp_no = b.emp_no
INNER JOIN salaries AS s ON e.emp_no = s.emp_no AND s.to_date = '9999-01-01';

drop table if exists emp_bonus;

# 60、按照salary的累计和running_total，其中running_total为前N个当前( to_date = '9999-01-01')员工的salary累计和，其他以此类推。
# 具体结果如下Demo展示。
select emp_no,salary,
sum(salary) over(order by emp_no) as running_total
from salaries
where to_date= '9999-01-01';

# 61、对于employees表中，输出first_name排名(按first_name升序排序)为奇数的first_name
SELECT
    e.first_name
FROM employees e JOIN
(
    SELECT
        first_name
        , ROW_NUMBER() OVER(ORDER BY first_name) AS r_num
    FROM employees
) AS t
ON e.first_name = t.first_name
WHERE t.r_num % 2 = 1;





































