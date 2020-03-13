-- Planet_Express 
-- 7.1 Who receieved a 1.5kg package?
    -- The result is "Al Gore's Head".

select * from package left join client on package.recipient=client.accountnumber where weight=1.5 and recipient=accountnumber;

-- 7.2 What is the total weight of all the packages that he sent?
select sum(weight) from package left join client on package.sender=client.accountnumber where name='Al Gore is Head' and sender=accountnumber;
select * from package;
select * from client;