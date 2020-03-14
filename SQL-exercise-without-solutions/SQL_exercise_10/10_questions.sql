-- 10.1 Join table PEOPLE and ADDRESS, but keep only one address information for each person (we don't mind which record we take for each person). 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
alter table address alter column updatedate type varchar;
select * into temp from  
(select *,row_number() over (PARTITION by id order by address)  as row from address) as a 
where a.row=1;

select * 
from temp right join PEOPLE on temp.id=PEOPLE.id;

-- 10.2 Join table PEOPLE and ADDRESS, but ONLY keep the LATEST address information for each person. 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
select * into temp1 from  
(select *,row_number() over (PARTITION by id order by updatedate desc) as row from address) as a 
where a.row=1;

select * 
from temp1 right join PEOPLE on temp1.id=PEOPLE.id;