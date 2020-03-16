-- 9.1 give the total number of recordings in this table
SELECT count(*) FROM cran_logs;
-- 9.2 the number of packages listed in this table?
SELECT count(distinct(package)) FROM cran_logs;
-- 9.3 How many times the package "Rcpp" was downloaded?
SELECT count(*) FROM cran_logs WHERE package='Rcpp';
-- 9.4 How many recordings are from China ("CN")?
SELECT count(*) FROM cran_logs WHERE country='CN';
-- 9.5 Give the package name and how many times they're downloaded. Order by the 2nd column descently.
SELECT package,count(*) FROM cran_logs GROUP BY (package) ORDER BY count(*);
-- 9.6 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
SELECT package,count(*) 
FROM cran_logs 
WHERE time BETWEEN '09:00:00' AND '11:00:00' 
GROUP BY (package) 
ORDER BY count(*);
-- 9.7 How many recordings are from China ("CN") or Japan("JP") or Singapore ("SG")?
SELECT count(*) 
FROM cran_logs 
WHERE country IN ('CN','JP','SG');
-- 9.8 Print the countries whose downloaded are more than the downloads from China ("CN")
SELECT country,count(*) INTO TEMP FROM cran_logs
GROUP BY (country);

SELECT country 
FROM temp 
WHERE count>(select COUNT FROM temp WHERE country='CN');

-- 9.9 Print the average length of the package name of all the UNIQUE packages
SELECT avg(length(package)) FROM
(SELECT package,count(*) FROM cran_logs
GROUP BY (package) 
HAVING count(*)=1) AS a;

-- 9.10 Get the package whose downloading count ranks 2nd (print package name and it's download count).
SELECT * FROM
(SELECT *,row_number() over (ORDER BY COUNT desc) AS row 
FROM (SELECT package,count(*) AS COUNT FROM cran_logs
GROUP BY package) AS a) AS b
WHERE b.row=2;
-- 9.11 Print the name of the package whose download count is bigger than 1000.
SELECT * FROM 
(SELECT package,count(*) AS COUNT FROM cran_logs
GROUP BY (package) 
) AS a
WHERE count>1000;
-- 9.12 The field "r_os" is the operating system of the users.
    -- 	Here we would like to know what main system we have (ignore version number), the relevant counts, and the proportion (in percentage).
SELECT r_os,count(*) AS COUNT INTO temp1 FROM cran_logs GROUP BY (r_os) ORDER BY count(*) DESC;
SELECT sum(count) INTO temp2 FROM temp1;
SELECT *,concat(round((count/sum)::numeric,2)*100,'%') AS percentage FROM temp1,temp2;
--或者
SELECT *,round((count/sum)::numeric,2)*100||'%' AS percentage FROM temp1,temp2;
