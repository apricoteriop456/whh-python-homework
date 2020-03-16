-- LINK: The_computer_store
-- 1.1 Select the names of all the products in the store.
SELECT * FROM products LIMIT 3;
SELECT DISTINCT name FROM products;
-- 1.2 Select the names and the prices of all the products in the store.
SELECT name,price FROM products;
-- 1.3 Select the name of the products with a price less than or equal to $200.
SELECT name FROM products WHERE price<=200;
-- 1.4 Select all the products with a price between $60 and $120.
SELECT * FROM products WHERE price BETWEEN 60 AND 120;
-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
SELECT name,100*price AS cents_price FROM products;
-- 1.6 Compute the average price of all the products.
SELECT avg(price) AS avg_price FROM products;
-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
--方法一
SELECT avg(price) FROM products WHERE manufacturer=2;
--方法二
SELECT avg(price) FROM products GROUP BY manufacturer HAVING manufacturer=2;
-- 1.8 Compute the number of products with a price larger than or equal to $180.
SELECT count(*) FROM products WHERE price>=180;
-- 1.9 Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order), and then by name (in ascending order).
SELECT name,price FROM products WHERE price>=180 ORDER BY price desc,name ASC;
-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
SELECT * FROM products,manufacturers WHERE products.manufacturer=manufacturers.code ORDER BY products.code;
-- 1.11 Select the product name, price, and manufacturer name of all the products.
SELECT products.name,price,manufacturers.name FROM products,manufacturers WHERE products.manufacturer=manufacturers.code ORDER BY products.code;
-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
SELECT manufacturer,avg(price) FROM products GROUP BY manufacturer;
-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
SELECT manufacturers.name,avg(price) FROM products,manufacturers WHERE products.manufacturer=manufacturers.code GROUP BY manufacturers.name;
-- 1.14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
SELECT manufacturers.name,avg(price) 
FROM products,manufacturers 
WHERE products.manufacturer=manufacturers.code 
GROUP BY manufacturers.name 
HAVING avg(price)>=150;
-- 1.15 Select the name and price of the cheapest product.
--方法一:min
SELECT name,price FROM products WHERE price=(select min(price) FROM products);
--方法二:all
SELECT name,price FROM products WHERE price<=ALL(select price FROM products);
--方法三:exists
SELECT name,price FROM products a WHERE EXISTS (SELECT * FROM products b WHERE a.code=b.code AND price<=ALL(select price FROM products));
--方法四:QL SERVER SOLUTION (T-SQL)
SELECT TOP 1 name,price 
FROM products 
ORDER BY price ASC;
-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
--方法一：这种方法不够好，可能存在某个组的最高价格在别的组中不是最高价格，这样用in筛选出来多余的。
SELECT b.name,a.name,price 
FROM products a INNER JOIN manufacturers b ON a.manufacturer=b.code 
WHERE price IN 
    (SELECT max(price) 
    FROM products a INNER JOIN manufacturers b ON a.manufacturer=b.code 
    GROUP BY b.code);
--方法二：用partition by
SELECT mname,pname,price FROM
(SELECT b.name AS mname,a.name AS pname,price,row_number() over (PARTITION BY b.code ORDER BY price desc) AS row 
FROM products a INNER JOIN manufacturers b ON a.manufacturer=b.code) 
AS temp WHERE temp.row=1;
--方法三：
select max_price_mapping.name as manu_name, max_price_mapping.price, products_with_manu_name.name as product_name
from 
    (SELECT manufacturers.Name, MAX(price) price
     FROM products, manufacturers
     WHERE products.manufacturer = manufacturers.Code
     GROUP BY manufacturers.Name)
     as max_price_mapping
   left join
     (select products.*, manufacturers.name manu_name
      from products join manufacturers
      on (products.manufacturer = manufacturers.code))
      as products_with_manu_name
 on
   (max_price_mapping.name = products_with_manu_name.manu_name
    and
    max_price_mapping.price = products_with_manu_name.price); 
-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
INSERT INTO products(Code,Name,Price,Manufacturer) VALUES(11,'Loudspeakers',70,2);
-- 1.18 Update the name of product 8 to "Laser Printer".
UPDATE products SET name='Laser Printer' WHERE Code=8;
-- 1.19 Apply a 10% discount to all products.
UPDATE products SET price=0.1*price;
--还原回去
UPDATE products SET price=10*price;
-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
UPDATE products SET price=0.1*price WHERE price>=120;
SELECT * FROM products;