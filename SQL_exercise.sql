-- *************第一部分 查询***************

/*查询customer表中的名字dd*/
select first_name from  customer;
\d customer;
--查看表customer的结构
/*查询city表中的城市名称（过滤重复值）*/
select distinct city from city limit 10;
select count(distinct city) from city;
--共599个

/*查询customer表中的名字和姓氏，按照名字升序排列*/

select first_name,last_name from customer order by first_name asc;

/*查询customer表中的名字和姓氏，按照名字升序排列,当名字相同时，姓氏降序排列*/
select first_name,last_name from customer order by first_name asc, last_name ;
/*连接customer表中的名字和姓氏，以空格隔开，并重命名为"full_name"*/
--方法一
select first_name||' '||last_name as full_name from customer limit 10;
--方法二
select CONCAT(first_name,' ',last_name) as full_name from customer limit 10;
--sql中连接两个字符串用||，+是针对数字的

-- *************第二部分 筛选***************

/*查询customer表中名字为Aaron的名字和姓氏*/
select first_name,last_name from customer where first_name like 'Aaron';
/*查询customer表中没有去1号店的顾客的邮箱*/
select first_name,last_name,email from customer where store_id<>1;
/*查询支付租金的金额小于1美元或大于8美元的顾客编号，金额以及付款日期*/
select customer_id,amount,payment_date from payment where amount < 1 and amount > 8;
/*查询电影的租赁时长不等于5并且电影时长少于100或者租赁时长等于5并且电影时长大于
100的电影编号和名称*/
select customer_id,amount,to_char(payment_date,'yyyy-MM-dd hh24:mi:ss') from payment where amount < 1 and amount > 8;
--to_char(timestamp,format)能够将时间戳转换为固定格式的日期字符
/*查询customer表中名字为Alan或Alex的名字和姓氏和邮箱*/
select first_name,last_name,email from customer where first_name in ('Alan','Alex');
select first_name,last_name,email from customer where first_name = 'Alan' or first_name = 'Alex';
/*查询payment表中付款日期在2007-02-20-2007-02-21之间的顾客编号*/
select customer_id from payment where payment_date between to_timestamp('2007-02-20','yyyy-mm-dd') and to_timestamp('2007-02-21','yyyy-mm-dd');

/*查询address表中以Man开头的街区名称*/
select district from address where district like 'Man%';
/*查询customer表中名字含有"er"的名字和姓氏*/
select first_name,last_name from customer where first_name like '%er%';
/*查询customer表中名字以任一字符开头，中间为"her"的名字和姓氏*/
select first_name,last_name from customer where first_name like '_her%';
/*查询customer表中名字不以"Jen"开头的名字和姓氏*/
select first_name,last_name from customer where first_name not like 'Jen%';
/*查询customer表中名字以"BAR"或者"Bar"或者“BaR"开头的名字和姓氏（ILIKE运算符不区分大小写的值）*/
select first_name,last_name from customer where first_name Ilike  ('BAR%');

/*查询address表中电话号码不为空的街区名称*/

select district,phone from address where phone is not null;
/*查询film表中按标题排序的前五部电影*/
select * from film  order by title limit 5;
/*查询film表中从第3行之后（即第4行）开始的4行数据*/
select * from film limit 5 offset 3;

-- *************第三部分 连接***************

/*查询客户ID 2的客户租赁数据（两表内连接）*/
select * from payment,customer where payment.customer_id=customer.customer_id and customer.customer_id=2;
SELECT a.customer_id, a.email, b.amount, b.payment_date FROM customer a INNER JOIN payment b ON a.customer_id = b.customer_id WHERE a.customer_id = 2;
/*查询客户ID 2的客户租赁数据（三表内连接）*/
SELECT a.customer_id,a.first_name,a.last_name,a.email,b.first_name,b.last_name,c.amount,c.payment_date
FROM payment c INNER JOIN customer a ON c.customer_id = a.customer_id
               INNER JOIN staff b ON c.staff_id = b.staff_id
WHERE a.customer_id = 2;

/*查找具有相同长度的所有电影对（自连接）
自联接对于比较同一表中的一列行中的值很有用。
要形成自连接，请使用不同的别名指定同一个表两次，设置比较，并消除值等于自身的情况。*/
select a.film_id,a.title,a.length,b.title,b.length from film a,film b where a.length = b.length and a.title<>b.title;

select a.film_id,a.title,a.length,b.length,b.title from film a inner join film b on a.film_id <> b.film_id and a.length = b.length order by a.film_id;

/*查询客户ID 2的客户租赁数据（完整外连接）*/
select * from customer a full outer join rental b ON a.customer_id = b.customer_id where a.customer_id = 2;
/*查询客户ID 2的客户租赁数据（完全外连接,,不包括a,b的交集部分）*/
select * from customer a full OUTER JOIN rental b ON a.customer_id = b.customer_id where a.customer_id = 2 and (a.customer_id is null or b.customer_id is null);

CREATE TABLE T1 (label CHAR(1) PRIMARY KEY);
CREATE TABLE T2 (score INT PRIMARY KEY);
INSERT INTO T1 (label) VALUES ('A'),('B');
INSERT INTO T2 (score) VALUES (1),(2),(3);
--两种方式一样
SELECT * FROM T1 CROSS JOIN T2;
SELECT * FROM T1, T2;


-- *************第四部分 分组***************

/*按顾客编号分组，计算总金额，并按总金额降序排列*/
select customer_id,sum(amount) from payment group by customer_id order by sum(amount) desc;
/*按顾客编号分组,查询总金额超过200的顾客编号*/
select customer_id,sum(amount) from payment group by customer_id having sum(amount)>200 order by sum(amount) desc;

-- *************第五部分 集合***************

/*并集（UNION ALL包括重复值）*/
select first_name,last_name from customer where
first_name = 'Aaron' 
UNION
select first_name,last_name from customer where
first_name = 'Rene' ;
/*交集*/
select first_name,last_name from customer where
first_name = 'Aaron' 
intersect
select first_name,last_name from customer where
first_name = 'Rene' ;

/*差集（查询不在库存中的影片）*/
select film_id,title from film;
--film中有10001部影片
select distinct film_id from inventory;
--inventory中有958部影片
select film_id,title from film
EXCEPT
select distinct inventory.film_id,title from inventory inner join film on inventory.film_id = film.film_id order by title;
--1.注意distinct和order by 的字段不能是同一个
--2.若改为"select distinct inventory.film_id,film.title from inventory inner join film on
--inventory.film_id = film.film_id order by title"会报错，因为"select
--film_id,title from film"中也有一个film,系统会混淆，所以会报错
-- *************第六部分 子查询(嵌套查询)*************

/*查找租金率高于平均租金率的前3部电影*/
select * from film where rental_rate > (select AVG(rental_rate) from film) order by rental_rate limit 3;
/*查询按电影类别分组的所有电影的最大长度
最小值为178*/
--方法一
select max(length) from film inner join film_category on film.film_id = film_category.film_id group by category_id;

--方法二，首先建立一个视图，然后应用partiton by 
create view table1 as (select film.film_id,title,category_id,length from film inner join film_category on film.film_id = film_category.film_id);
select * from 
(select *,row_number() over (partition by category_id order by length) as row from table1) as temp where row = 1;
/*查询按电影评级分组的所有电影的平均长度
最大值为120.44*/
select round(avg(length),2) from film group by rating;

/*查询返回所有长度大于子查询返回的平均长度列表中最大值的影片

select * from film 
where length>all(select avg(length) from film group by rating)
order by length;

--ALL表示全部都满足才返回TRUE,即大于平均长度的最大值120.44才可*/

/*查找至少有一笔金额大于11的付款的客户
EXISTS运算符来测试子查询中是否存在行*/
select * from customer a where EXISTS (select * from payment b where a.customer_id=b.customer_id and  amount>11);
-- *************第七部分 修改数据*************

/*一次向表中添加多行*/
--INSERT INTO table (column1, column2, …)VALUES (value1, value2, …),(value1, value2, …) ,...;
/*插入来自另一个表的数据*/
--insert into table (column1,column2) select column1,column2 from another_table 


/*更改表中列的值*/
--update table set column1 = value1,column2 = value2 ,... WHERE condition;
/*根据另一个表中的值更新表的数据*/
--update a set a.c1=expression from b where a.c2=b.c2

/*从表中删除数据*/
--delete from table where condition
/*检查引用另一个表中的一个或多个列的条件来删除数据*/
--delete from table where table.id = (select id from another_table)

-- *************第八部分 管理表*************

/*创建表*/
create table QJK1
(DAT_DATE VARCHAR(200) null,
CLT_NAM varchar(200) null,--客户姓名
CLT_NUM varchar(200) null,--客户号
CLT_ID varchar(200) null,--客户身份证号
REG_NUM varchar(200) null,--企业注册编号
ORG_NAM varchar(200) null,--公司名称
ORG_STS varchar(200) null,--企业状态
REG_CAP varchar(200) null,--企业注册资本
HLD_CAP varchar(200) null);--持有资本



/*验证表*/
select * from QJK1;

/*向表中添加新列*/
alter table QJK1 add clt_flag varchar(200);
select * from QJK1;
/*删除现有列*/
ALTER TABLE qjk1 DROP COLUMN clt_flag;
/*重命名现有列*/
ALTER TABLE QJK1 RENAME COLUMN clt_nam TO CLT_NAME;
/*将assets表中name列的数据类型更改为VARCHAR*/
ALTER TABLE QJK1 ALTER COLUMN CLT_NAM TYPE CHAR;
ALTER TABLE QJK1 ALTER COLUMN CLT_NAM TYPE VARCHAR(200);

/*重命名表*/
ALTER TABLE QJK1 RENAME TO QJK;
/*删除表*/
DROP TABLE IF EXISTS QJK;
/*创建临时表*/

create TEMP TABLE FLAG(date varchar,endtime date);
SELECT * FROM FLAG;
select * from pg_tables where tablename='flag';

--使用on commit drop选项创建的临时表，一旦创建它的事务结束(运行COMMIT)，临时表和其中的数据也就消失了

/*删除表中所有数据*/
delete from oridata;

-- *************第九部分 约束*************

/*主键约束方式一：创建表时定义主键*/
drop table test;
create table test(id int PRIMARY key,value varchar)
select * from test;
/*主键约束方式二：如果主键由两列或更多列组成*/
create table sc(
    sno char(9),
    cno char(4),
    grade SMALLINT,
    primary key(sno,cno));
select * from sc;
/*主键约束方式三：更改现有表结构时定义主键*/
alter table test add primary key(id,value);
/*删除主键*/
alter table sc drop CONSTRAINT sc_pkey;
--sc_pkey是主键的名字，通过'\d sc'可以查看表结构
/*UNIQUE约束方式一：添加UNIQUE约束，确保存储在列或列组中的值在整个表中是唯一*/
CREATE TABLE person (
 id serial PRIMARY KEY,
 first_name VARCHAR (50),
 last_name VARCHAR (50),
 email VARCHAR (50) UNIQUE
);

/*UNIQUE约束方式二：列c2和c3中的值组合在整个表中是唯一的。列c2或c3的值不必是唯一的*/
alter table sc add constraint MyUniqueConstraint UNIQUE(sno,cno);

/*NOT NULL约束方式一：在创建新表时，将PostgreSQL非空约束添加到列*/
drop table person;
CREATE TABLE person (
 id serial PRIMARY KEY not null,
 first_name VARCHAR (50),
 last_name VARCHAR (50),
 email VARCHAR (50) UNIQUE
);
/*NOT NULL约束方式二：将PostgreSQL非空约束添加到现有表的列*/
alter table person alter first_name set not null;

/*CHECK约束，该约束根据布尔表达式约束表中列的值
一个CHECK约束是一种约束，使您可以指定是否在列中的值必须满足特定的要求。的CHECK约束使用布尔表达式插入或更新到列之前评估值。如果值通过检查，PostgreSQL将在列中插入或更新这些值。
首先，birth_date员工的出生日期（）必须大于01/01/1900。如果您之前尝试插入出生日期01/01/1900，您将收到一条错误消息。
其次，联合日期（joined_date）必须大于出生日期（birth_date）。此检查将阻止根据其语义含义更新无效日期。
第三，薪水必须大于零*/
CREATE TABLE employees (
 id serial PRIMARY KEY,
 first_name VARCHAR (50),
 last_name VARCHAR (50),
 birth_date DATE CHECK (birth_date > '1900-01-01'),
 joined_date DATE CHECK (joined_date > birth_date),
 salary numeric CHECK(salary > 0)
);

-- *************第十部分 条件表达式和运算符*************

/*为电影分配价格段：如果租金率为0.99，则为普通；如果租金率是1.99，则为经济；如果
出租率是4.99，则为豪华*/
alter table film add column flag varchar(200);
update film set flag=(
    case
    when rental_rate=0.99 then '普通'
    when rental_rate=1.99 then '经济'
    when rental_rate=4.99 then '豪华'
    else NULL
    end
); 
select DISTINCT flag from film;
/*从左到右计算参数，直到找到第一个非null参数*/
select COALESCE (2,1,null);

/*将字符串常量转换为整数*/
select cast('100' as integer);
--或者
select '100':: integer;

-- *************第十一部分 习题*************
/*1.将姓中含有“oo”的演员参演的电影的租赁期增加三天
Al Garland参演的电影的租赁期增加一天，
其他姓“Garland”的演员参演的电影的租赁期减两天，
展示所有演员的名字，过去的租赁期和当前最新的租赁期
问题出在把新的租赁期不知道往SELECT里面放*/
select a.first_name,a.last_name,b.rental_duration as old_rental_duration,
(case 
when last_name like '%oo%' then b.rental_duration+3 
when last_name='Garland' and first_name='Al' then b.rental_duration+1 
when last_name='Garland' and first_name!='Al' then b.rental_duration-2 
else b.rental_duration 
end) as new_rental_duration 
from actor a inner join film_actor c on a.actor_id=c.actor_id 
             inner join film b on b.film_id=c.film_id
WHERE a.last_name like '%oo%' or a.last_name='Garland';

/*2.展示播放时长为115分钟到125分钟的电影名称及时长,
并按播放时长排序,相同时长的电影按名字排序，但A开头
和名字中含有c（另一个字母）r的电影必须最后排列，即
该条件为第一满足的条件，即第一排序*/
select film_id,title,length from film where length BETWEEN 115 and 125 order by (case when title like 'A%' then 1 else 0 end )asc,length,title;
--两个LIKE不可直接用OR连接
SELECT title,length FROM film
WHERE length BETWEEN 115 AND 125 
ORDER BY title IN(SELECT title FROM film WHERE title LIKE 'A%' OR title LIKE 'c_r%'),length,title;
--in返回逻辑值
select title IN(SELECT title FROM film WHERE title LIKE 'A%' OR title LIKE '%c_r%') as a from film;
/*3.展示不同语言种类的电影数量，并按从小到大的顺序排列*/
select language_id,count(film_id) as row from film 
group by language_id 
order by row asc;
/*4.展示英语类电影的电影类型及相应数目*/
SELECT category_id,COUNT(film.film_id)
FROM film inner join film_category on film.film_id=film_category.film_id
WHERE film.language_id='1'
GROUP BY category_id;

/*5.展示有支付行为的每个城市的支付笔数*/
select  d.country_id,d.city_id,count(distinct payment_id)
from payment a inner join staff b on a.staff_id=b.staff_id 
               inner join address c on b.address_id=c.address_id
               inner join city d on c.city_id=d.city_id
               inner join country e on e.country_id=d.country_id
group by d.country_id,d.city_id;
/*6.找出每个国家按字母排序是排末位的城市中最高的支付金额*/
--先制造视图
create view view_1 as
select e.country_id,e.country,d.city_id,d.city,a.payment_id,a.amount
from payment a inner join staff b on a.staff_id=b.staff_id 
               inner join address c on b.address_id=c.address_id
               inner join city d on c.city_id=d.city_id
               inner join country e on e.country_id=d.country_id;
--基于视图找到每个国家的最末尾城市中最高的支付金额
select country,city,max(amount) from view_1 
group by country,city 
having city=min(city);

--错误做法
SELECT MAX(a.amount),d.city,e.country
FROM payment a JOIN staff b ON a.staff_id=b.staff_id
JOIN address c ON b.address_id=c.address_id
JOIN city d ON c.city_id=d.city_id
JOIN country e ON d.country_id=e.country_id
WHERE city<=ALL(SELECT city FROM country f WHERE e.country=f.country)
--这里使用where 无法保证是每个国家的最末尾城市
GROUP BY e.country,d.city;