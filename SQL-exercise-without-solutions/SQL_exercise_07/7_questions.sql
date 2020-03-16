-- Planet_Express 
-- 7.1 Who receieved a 1.5kg package?
    -- The result is "Al Gore's Head".

SELECT * FROM package LEFT JOIN client ON package.recipient=client.accountnumber WHERE weight=1.5;

-- 7.2 What is the total weight of all the packages that he sent?
SELECT sum(weight) FROM package LEFT JOIN client ON package.sender=client.accountnumber WHERE name='Al Gore IS Head' AND sender=accountnumber;
SELECT * FROM package;
SELECT * FROM client;