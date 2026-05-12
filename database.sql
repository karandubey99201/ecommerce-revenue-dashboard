-- DAY - 1

drop table if exists customers;
create table customers(
    customer_id serial Primary key, 
	customer_name varchar(50),
	city Varchar(50)
);
select * from customers;

insert into customers(customer_name,city)
       values('Karan Dubey','Azamgarh'),
	         ('Kishan Dubey','Lucknow'),
			 ('Arjun Dubey','Delhi'),
			 ('Satyam Dubey','Mumbai');

-- DAY - 2

-- PRODUCTS TABLE
drop table if exists products;
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2)
);	
select * from products;

insert into products(product_name,category,price) values
        ('Laptop', 'Electronics', 50000),
        ('Mobile', 'Electronics', 20000),
        ('Shirt', 'Clothing', 1500),
        ('Shoes', 'Footwear', 3000);

-- ORDER TABLE
drop table if exists orders;
create table orders(
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount NUMERIC(10,2)
);
select * from orders;

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-01', 70000),
(2, '2024-01-02', 20000),
(3, '2024-01-03', 4500);


-- ORDER_ITEM TABLE
DROP TABLE if exists order_item;
create table order_item(
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price NUMERIC(10,2)
);
select * from order_item;

INSERT INTO order_item (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 50000),
(1, 2, 1, 20000),
(2, 2, 1, 20000),
(3, 3, 1, 1500),
(3, 4, 1, 3000);


SELECT SUM(price * quantity) AS total_revenue FROM order_item;


-- FIRST JOIN QUERY

SELECT o.order_id,c.customer_name,p.product_name,oi.quantity,oi.price From orders o
join
customers c 
ON 
o.customer_id = c.customer_id
join
order_item oi
on 
o.order_id = oi.order_id
join
products p
on 
oi.product_id = p.product_id;
	   

-- DAY - 3

-- STEP 1: Total Revenue
SELECT SUM(price * quantity) AS total_revenue FROM order_item;

-- STEP 2: Category-wise Revenue
SELECT p.category,SUM(oi.price * oi.quantity) AS revenue FROM order_item oi
JOIN
products p
ON
oi.product_id = p.product_id
GROUP BY p.category;


-- STEP 3: Top Selling Products

SELECT p.product_name,SUM(oi.quantity) AS total_sold FROM order_item oi
JOIN
products p 
ON
oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- STEP 4: Top Revenue Products

SELECT p.product_name,SUM(oi.price * oi.quantity) AS revenue FROM order_item oi
JOIN 
products p
ON
oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;


-- STEP 5: Customer-wise Revenue

SELECT c.customer_name,SUM(oi.price * oi.quantity) AS total_spent FROM customers c
JOIN
orders o 
ON c.customer_id = o.customer_id
JOIN order_item oi
ON
o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Day - 4

-- STEP 1: Daily Revenue (Time Analysis)

SELECT o.order_date,SUM(oi.price * oi.quantity) AS daily_revenue FROM orders o
JOIN
order_item oi 
ON
o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;


-- STEP 2: Growth Analysis

SELECT o.order_date,SUM(oi.price * oi.quantity) AS revenue,LAG(SUM(oi.price * oi.quantity)) OVER (ORDER BY o.order_date)
AS previous_day_revenue
FROM orders o
JOIN 
order_item oi
ON
o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;


-- STEP 3: Growth % nikalte hain

SELECT order_date,revenue,previous_revenue,((revenue - previous_revenue) * 100.0 / previous_revenue) AS growth_percent
FROM (SELECT o.order_date,SUM(oi.price * oi.quantity) AS revenue,LAG(SUM(oi.price * oi.quantity)) OVER (ORDER BY o.order_date)
AS previous_revenue FROM orders o
JOIN
order_item oi 
ON
o.order_id = oi.order_id
GROUP BY o.order_date
) sub;


-- STEP 4: CTE

WITH daily_revenue AS (SELECT o.order_date,SUM(oi.price * oi.quantity) AS revenue FROM orders o
JOIN
order_item oi 
ON
o.order_id = oi.order_id
GROUP BY o.order_date
)

SELECT order_date,revenue,LAG(revenue) OVER (ORDER BY order_date) AS previous_revenue
FROM daily_revenue;



