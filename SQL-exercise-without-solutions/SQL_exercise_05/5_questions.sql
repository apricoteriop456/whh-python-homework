-- Pieces_and_providers
-- 5.1 Select the name of all the pieces. 
select name from pieces;
-- 5.2  Select all the providers' data. 
select * from providers;
-- 5.3 Obtain the average price of each piece (show only the piece code and the average price).
select piece,avg(price) from provides group by piece; 
-- 5.4  Obtain the names of all providers who supply piece 1.
select name from providers where code in (select provider from provides where piece=1);
-- 5.5 Select the name of pieces provided by provider with code "HAL".
select name from pieces where code in (select piece from provides where provider='HAL');
-- 5.6
-- ---------------------------------------------
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Interesting and important one.
-- For each piece, find the most expensive offering of that piece and include the piece name, provider name, and price 
-- (note that there could be two providers who supply the same piece at the most expensive price).
-- ---------------------------------------------
select piece,name_piece,name as name_provide,price as max_price from 
(select *,row_number() over (partition by piece order by price DESC) as row
from provides left join (select code as code_piece,name as name_piece from pieces) as a on provides.piece = a.code_piece
              left join providers on providers.code = provides.provider) as TEMP
where row=1;
-- 5.7 Add an entry to the database to indicate that "Skellington Supplies" (code "TNBC") will provide sprockets (code "1") for 7 cents each.
insert into provides values(1,'TNBC',7);
-- 5.8 Increase all prices by one cent.
update provides set price=price+1;
select price+1 from provides;
-- 5.9 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply bolts (code 4).
DELETE from provides where piece=4 and provider='RBT';
-- 5.10 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply any pieces 
    -- (the provider should still remain in the database).

alter table provides drop CONSTRAINT provides_provider_fkey;
DELETE FROM providers CASCADE WHERE CODE='RBT';
delete from provides where provider='RBT';
ALTER TABLE provides ADD CONSTRAINT provides_provider_fkey FOREIGN KEY (provider) REFERENCES providers(code);