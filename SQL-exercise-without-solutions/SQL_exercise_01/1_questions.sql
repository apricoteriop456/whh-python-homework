-- LINK: The_computer_store
-- 1.1 Select the names of all the products in the store.
select * from products limit 3;
select distinct name from products;
-- 1.2 Select the names and the prices of all the products in the store.
select name,price from products;
-- 1.3 Select the name of the products with a price less than or equal to $200.
select name from products where price<=200;
-- 1.4 Select all the products with a price between $60 and $120.
select * from products where price between 60 and 120;
-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
select name,100*price as cents_price from products;
-- 1.6 Compute the average price of all the products.
select avg(price) as avg_price from products;
-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
--方法一
select avg(price) from products where manufacturer=2;
--方法二
select avg(price) from products group by manufacturer HAVING manufacturer=2;
-- 1.8 Compute the number of products with a price larger than or equal to $180.
select count(*) from products where price>=180;
-- 1.9 Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order), and then by name (in ascending order).
select name,price from products where price>=180 order by price desc,name asc;
-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
select * from products,manufacturers where products.manufacturer=manufacturers.code order by products.code;
-- 1.11 Select the product name, price, and manufacturer name of all the products.
select products.name,price,manufacturers.name from products,manufacturers where products.manufacturer=manufacturers.code order by products.code;
-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
select manufacturer,avg(price) from products group by manufacturer;
-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
select manufacturers.name,avg(price) from products,manufacturers where products.manufacturer=manufacturers.code group by manufacturers.name;
-- 1.14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
select manufacturers.name,avg(price) from products,manufacturers where products.manufacturer=manufacturers.code group by manufacturers.name having avg(price)>=150;
-- 1.15 Select the name and price of the cheapest product.
--方法一:min
select name,price from products where price=(select min(price) from products);
--方法二:all
select name,price from products where price<=ALL(select price from products);
--方法三:exists
select name,price from products a where EXISTS (select * from products b where a.code=b.code and price<=ALL(select price from products));
-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
--方法一：这种方法不够好，可能存在某个组的最高价格在别的组中不是最高价格，这样用in筛选出来多余的。
select b.name,a.name,price 
from products a inner join manufacturers b on a.manufacturer=b.code 
where price in 
    (select max(price) 
    from products a inner join manufacturers b on a.manufacturer=b.code 
    group by b.code);
--方法二：用partition by
select mname,pname,price from
(select b.name as mname,a.name as pname,price,row_number() over (PARTITION by b.code order by price desc) as row 
from products a inner join manufacturers b on a.manufacturer=b.code) 
as temp where temp.row=1;

-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
INSERT into products(Code,Name,Price,Manufacturer) VALUES(11,'Loudspeakers',70,2);
-- 1.18 Update the name of product 8 to "Laser Printer".
UPDATE products set name='Laser Printer' where Code=8;
-- 1.19 Apply a 10% discount to all products.
update products set price=0.1*price;
--还原回去
update products set price=10*price;
-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
update products set price=0.1*price where price>=120;
select * from products;