-- 9.1 give the total number of recordings in this table
select count(*) from cran_logs;
-- 9.2 the number of packages listed in this table?
select count(distinct(package)) from cran_logs;
-- 9.3 How many times the package "Rcpp" was downloaded?
select count(*) from cran_logs where package='Rcpp';
-- 9.4 How many recordings are from China ("CN")?
select count(*) from cran_logs where country='CN';
-- 9.5 Give the package name and how many times they're downloaded. Order by the 2nd column descently.
select package,count(*) from cran_logs group by (package) order by count(*);
-- 9.6 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
select package,count(*) 
from cran_logs 
where time BETWEEN '09:00:00' and '11:00:00' 
group by (package) 
order by count(*);
-- 9.7 How many recordings are from China ("CN") or Japan("JP") or Singapore ("SG")?
select count(*) 
from cran_logs 
where country in ('CN','JP','SG');
-- 9.8 Print the countries whose downloaded are more than the downloads from China ("CN")
SELECT country,count(*) into TEMP FROM cran_logs
GROUP BY (country);

select country 
from temp 
where count>(select count from temp where country='CN');

-- 9.9 Print the average length of the package name of all the UNIQUE packages
select avg(length(package)) from
(select package,count(*) from cran_logs
group by (package) 
having count(*)=1) as a;

-- 9.10 Get the package whose downloading count ranks 2nd (print package name and it's download count).
select * from
(select *,row_number() over (order by count desc) as row 
from (select package,count(*) as count from cran_logs
group by package) as a) as b
where b.row=2;
-- 9.11 Print the name of the package whose download count is bigger than 1000.
select * from 
(select package,count(*) as count from cran_logs
group by (package) 
) as a
where count>1000;
-- 9.12 The field "r_os" is the operating system of the users.
    -- 	Here we would like to know what main system we have (ignore version number), the relevant counts, and the proportion (in percentage).
select r_os,count(*) as count into temp1 from cran_logs group by (r_os) order by count(*) desc;
select sum(count) into temp2 from temp1;
select *,concat(round((count/sum)::numeric,2)*100,'%') as percentage from temp1,temp2;
--或者
select *,round((count/sum)::numeric,2)*100||'%' as percentage from temp1,temp2;