--How many Pizza were ordered?
SELECT
	COUNT(*) AS Total_customer_order
FROM
	customer_orders;

--How many unique customer orders were made?
SELECT 
	COUNT (DISTINCT order_id) AS Unique_customer_order
FROM
	customer_orders;

--How many successful orders were delivered by each runner?
SELECT 
	runner_id,
	COUNT(order_id) AS order_per_runner
FROM
	runner_orders
WHERE
	cancellation IS NULL
GROUP BY
	runner_id;

--How many of each type of pizza was delivered?
SELECT
	CAST(pizza_name AS VARCHAR) AS pizza_name,
	COUNT (c.pizza_id) AS Delivered_pizza
FROM
	customer_orders c
INNER JOIN
	runner_orders r
ON c.order_id = r.order_id
INNER JOIN
	pizza_names p
ON c.pizza_id = p.pizza_id
WHERE
	cancellation IS NULL
GROUP BY
	CAST(pizza_name AS VARCHAR);

--How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
	CAST(pizza_name AS VARCHAR) AS Pizza_name,
	customer_id,
	COUNT(order_id) AS total_orders
FROM 
	customer_orders co
INNER JOIN
	pizza_names pn
ON co.pizza_id = pn.pizza_id
GROUP BY
	customer_id,
	CAST(pizza_name AS VARCHAR)
ORDER BY
	customer_id;

--What was the maximum number of pizzas delivered in a single order?
SELECT 
	TOP 1
	r.order_id,
	COUNT(c.pizza_id) AS total_delivered
FROM
	customer_orders c
INNER JOIN
	runner_orders r
ON c.order_id = r.order_id
WHERE
	r.cancellation IS NULL
GROUP BY
	r.order_id
ORDER BY
	total_delivered DESC;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT
	customer_id,
	SUM(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL
		THEN 1
		ELSE 0
		END) AS atleast_one_change,
	SUM(CASE WHEN exclusions IS NULL AND extras IS NULL
		THEN 1
		ELSE 0
		END) AS no_changes
FROM
	customer_orders co
INNER JOIN
	runner_orders ro
ON co.order_id = ro.order_id
WHERE 
	ro.cancellation IS NULL
GROUP BY
	customer_id;

--How many pizzas were delivered that had both exclusions and extras?
SELECT
	customer_id,
	COUNT(co.order_id) AS delivered_pizza
FROM	
	customer_orders co
INNER JOIN
	runner_orders ro
ON co.order_id = ro.order_id
WHERE cancellation IS NULL AND exclusions IS NOT NULL AND extras IS NOT NULL
GROUP BY
	customer_id;

--What was the total volume of pizzas ordered for each hour of the day?
SELECT
	DATEPART(HOUR, Order_time) AS total_volume_of_pizza_per_hour,
	COUNT(order_id) AS total_order
FROM	
	customer_orders
GROUP BY
	DATEPART(HOUR, Order_time)
ORDER BY
	total_volume_of_pizza_per_hour;

--What was the volume of orders for each day of the week?
SELECT
	DATENAME(WEEKDAY,order_time) AS Week_day,
	COUNT(order_id) AS Daily_orders
FROM
	customer_orders
GROUP BY
	DATENAME(WEEKDAY,order_time)
ORDER BY
	Daily_orders DESC;

