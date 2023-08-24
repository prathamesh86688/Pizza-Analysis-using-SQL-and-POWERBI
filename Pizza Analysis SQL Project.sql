use pizzasales;
select * from pizza_types;
select * from pizzas;
select * from orders;
SELECT COUNT(*) 
FROM information_schema.columns 
WHERE table_schema = 'pizzasales' AND table_name = 'order_details';
SELECT COUNT(*) 
FROM order_details;
select * from order_details;

SELECT * FROM Orders;
SELECT * FROM Order_details;
SELECT * FROM Pizzas;
SELECT * FROM pizza_types;

CREATE VIEW Pizza_details AS
SELECT p.pizza_id,p.pizza_type_id,pt.name,pt.category,p.size,p.price,pt.ingredients
FROM pizzas p
JOIN pizza_types pt
ON pt.pizza_type_id = p.pizza_type_id

SELECT * FROM pizza_details;

ALTER TABLE orders
MODIFY date Date;

ALTER TABLE orders
MODIFY time TIME;

#what we have done so far is we have imported our raw data then we transformed our data nad combine our data then we are modify our data type.

#Total Revenue
SELECT ROUND(SUM(od.quantity* p.price),2) AS total_revenue
FROM order_details od
join pizza_details p 
ON od.pizza_id = p.pizza_id;

#Total no of pizza sold
SELECT SUM(od.quantity) AS pizza_sold
FROM order_details od;

#Total orders
SELECT COUNT(Distinct(order_id)) AS total_orders
FROM order_details;

#Average order value
SELECT SUM(od.quantity * p.price) / COUNT(DISTINCT(od.order_id)) AS avg_order_value
FROM order_details od
join pizza_details p 
ON od.pizza_id = p.pizza_id;


#average number of pizza per order
SELECT ROUND(SUM(od.quantity) / COUNT(DISTINCT(od.order_id)),0) AS avg_no_pizza_per_order
FROM order_details od;

#totalrevenue and no of order per category
SELECT P.CATEGORY, SUM(od.quantity * p.price) AS total_revenue, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
join pizza_details p 
ON od.pizza_id = p.pizza_id
GROUP BY p.category;

#Total revenue and number of orders per size
SELECT p.size, SUM(od.quantity * p.price) AS total_revenue, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
join pizza_details p 
ON od.pizza_id = p.pizza_id
GROUP BY p.size;

#Hourly, daily and monthly trend of orders and revenue of pizza
SELECT
	CASE
		WHEN HOUR(O.time) BETWEEN 12  AND 15 THEN 'Lunch'
		WHEN HOUR(O.time) BETWEEN 15 AND 18 THEN 'Mid Afternoon'
		WHEN HOUR(O.time) BETWEEN 18 AND 21 THEN 'Dinner'
		WHEN HOUR(O.time) BETWEEN 21 AND 23 THEN 'Late Night'
		ELSE 'orders'
		END AS meal_time, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY meal_time
ORDER BY total_orders DESC;

SELECT
    DATE(o.time) AS order_date,
    CASE
        WHEN HOUR(o.time) BETWEEN 12 AND 15 THEN 'Lunch'
        WHEN HOUR(o.time) BETWEEN 15 AND 18 THEN 'Mid Afternoon'
        WHEN HOUR(o.time) BETWEEN 18 AND 21 THEN 'Dinner'
        WHEN HOUR(o.time) BETWEEN 21 AND 23 THEN 'Late Night'
        ELSE 'Other'
    END AS meal_time,
    SUM(od.order_id) AS total_revenue
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY order_date, meal_time
ORDER BY order_date, total_revenue DESC;

#Weekdays
SELECT DAYNAME(o.date) AS day_name, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
GROUP BY DAYNAME(o.date)
ORDER BY total_orders DESC

#Monthwise trend
SELECT MONTHNAME(o.date) AS day_name, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
GROUP BY MONTHNAME(o.date)
ORDER BY total_orders DESC


#Most ordertrend pizza
SELECT p.name, COUNT(od.order_id) AS count_pizzas
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id 
GROUP BY p.name
ORDER BY count_pizzas DESC
Limit 1;


#Top 5 pizzas by revenue
SELECT p.name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER BY total_revenue DESC
LIMIT 5;


#Top pizzas by sale
SELECT p.name, SUM(od.quantity) AS Pizzas_sold
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER BY pizzas_sold DESC
LIMIT 5;

#Pizzas Analysis
SELECT name, price
FROM pizza_details
ORDER BY price DESC
LIMIT 1;

#Top used ingrediants
SELECT * FROM pizza_details;
SELECT 'Barbecued Chicken' AS ingredient
UNION
SELECT 'Red Peppers'
UNION
SELECT 'Green Peppers'
UNION
SELECT 'Tomatoes'
UNION
SELECT 'Red Onions'
UNION
SELECT 'Barbecue Sauce';


CREATE TEMPORARY TABLE numbers AS ( 
	SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
	SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 
);

SELECT ingredient, COUNT(ingredient) AS ingredient_count
FROM (
		SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ingredients,',', n), ',', -1) AS ingredient
        FROM order_details
        JOIN pizza_details ON pizza_details.pizza_id = order_details.pizza_id
        JOIN numbers ON CHAR_LENGTH(ingredients) - CHAR_LENGTH(REPLACE(ingredients, ',','')) >= n-1
        ) AS subquery
GROUP BY ingredient
ORDER BY ingredient_count DESC;










