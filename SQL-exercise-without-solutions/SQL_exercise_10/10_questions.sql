-- 10.1 Join table PEOPLE and ADDRESS, but keep only one address information for each person (we don't mind which record we take for each person). 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
ALTER TABLE address ALTER column updatedate type varchar;
SELECT * INTO temp FROM  
(SELECT *,row_number() over (PARTITION BY id ORDER BY address)  AS row FROM address) AS a 
WHERE a.row=1;

SELECT * 
FROM temp RIGHT JOIN people ON temp.id=people.id;
 
-- 10.2 Join table PEOPLE and ADDRESS, but ONLY keep the LATEST address information for each person. 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
SELECT * INTO temp1 FROM  
(SELECT *,row_number() over (PARTITION BY id ORDER BY updatedate desc) AS row FROM address) AS a 
WHERE a.row=1;

SELECT * 
FROM temp1 RIGHT JOIN PEOPLE ON temp1.id=PEOPLE.id;