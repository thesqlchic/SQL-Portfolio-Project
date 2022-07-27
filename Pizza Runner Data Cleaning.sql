--CLEANING customer_orders table
--Checking the data type of the columns
SELECT 
	*
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customer_orders'

--Creating a temp_customer_orders table
DROP TABLE IF EXISTS #Temp_customer_orders
CREATE TABLE #Temp_customer_orders(
Order_id int null,
Customer_id int null,
pizza_id int null,
exclusions varchar(4) null,
extras varchar(4) null,
order_time datetime null
);

INSERT INTO #Temp_customer_orders 
SELECT *
FROM customer_orders

--Fixing 'null' values in #temp_customer_orders
SELECT *,
	CASE WHEN exclusions IS NULL or Exclusions LIKE '%NULL%' THEN ''
	ELSE Exclusions 
	END Exclusions,
	CASE WHEN Extras IS NULL or Extras LIKE '%null%' THEN ''
	ELSE extras
	END Extras
FROM #Temp_customer_orders

UPDATE #temp_customer_orders
SET Exclusions = CASE WHEN exclusions IS NULL or Exclusions LIKE '%NULL%' THEN ''
	ELSE Exclusions 
	END ,
	Extras=	CASE WHEN Extras IS NULL or Extras LIKE '%null%' THEN ''
	ELSE extras
	END;

--SELECT *
--FROM #Temp_customer_orders;

----Checking and Removing duplicates from #temp_customer_orders table
--WITH #duplicate_temp_customer_orderscte AS (
--SELECT *,
--	ROW_NUMBER() OVER(PARTITION BY Order_id,Pizza_id,exclusions ORDER BY customer_id) as Duplicates_rownumber
--FROM #Temp_customer_orders
--)

--DELETE
--FROM #duplicate_temp_customer_orderscte
--WHERE duplicates_rownumber > 1

--CLEANING RUNNER_ORDERS TABLE
SELECT *,
	CASE WHEN pickup_time IS NULL OR pickup_time LIKE '%null%' then '' 
	ELSE pickup_time
	END runner_pickup_time,
	CASE WHEN DISTANCE LIKE 'NULL' THEN ''
	WHEN DISTANCE LIKE '%km' THEN TRIM('km' FROM Distance)
	ELSE DISTANCE
	END Distances,
	CASE WHEN duration LIKE 'null' THEN ''
	WHEN duration like '%minutes' THEN TRIM('minutes' FROM duration)
	WHEN duration like '%mins%' THEN TRIM('mins' FROM duration)
	WHEN duration like '%minute%' THEN TRIM ('minute' FROM duration)
	ELSE duration
	END durations,
	CASE WHEN cancellation IS NULL OR cancellation LIKE '%null%' THEN ''
	ELSE cancellation
	END cancellations
INTO #temp_runners_order
FROM runner_orders

--SELECT *
--FROM #temp_runners_order

--Altering Data types
ALTER TABLE #temp_runners_order
ALTER COLUMN runner_pickup_time datetime

ALTER TABLE #temp_runners_order
ALTER COLUMN Distances float;

ALTER TABLE #temp_runners_order
ALTER COLUMN Durations int;

--DROPPING IRRELEVANT COLUMNS FROM #TEMP_RUNNERS_ORDER
ALTER TABLE #temp_runners_order
DROP COLUMN pickup_time, distance,duration,cancellation


SELECT *
FROM #temp_runners_order

---------------------------------------------------------------------------------------------------------------------------
--QUESTION 1: How many pizzas were ordered
SELECT COUNT(order_id) AS total_order
FROM #Temp_customer_orders

--Question 2: How many unique customer orders were made?
SELECT COUNT(DISTINCT Order_id) as total_customer_order
FROM #Temp_customer_orders

--Question 3: How many successful orders were delivered by each runner?
SELECT COUNT(Order_id) AS total_successful_order,runner_id
FROM #temp_runners_order 
WHERE Distances > 0
GROUP BY runner_id

--Question 4: How many of each type of pizza was delivered?
SELECT COUNT(c.pizza_id) as Total_order, CAST(p.pizza_name as Nvarchar) AS pizza_name
FROM #Temp_customer_orders c
INNER JOIN #temp_runners_order r
ON c.Order_id=r.order_id
INNER JOIN pizza_names p
ON c.pizza_id=p.pizza_id
WHERE Distances > 0
GROUP BY CAST(p.pizza_name as nvarchar) 

--Question 5: How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.Customer_id,COUNT(C.pizza_id) as total_order,CAST(P.pizza_name as nvarchar) as pizza_name
FROM #Temp_customer_orders c
INNER JOIN pizza_names p
ON c.pizza_id=p.pizza_id
GROUP BY CAST(p.pizza_name as nvarchar), c.Customer_id;

--Question 6: What was the maximum number of pizzas delivered in a single order?
SELECT TOP(1) COUNT(C.pizza_id) as total_pizza,c.Order_id
FROM #Temp_customer_orders c
INNER JOIN #temp_runners_order r
ON c.order_id = r.order_id
WHERE r.distances > 0
GROUP BY c.Order_id
ORDER BY total_pizza desc
 
 --Question 7: For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.Customer_id,SUM(CASE WHEN c.exclusions <> ' ' or c.extras <> '' then 1 ELSE 0
END) AS at_least_1_change,
SUM(CASE WHEN C.exclusions = '' AND c.extras = '' then 1 else 0
END) AS no_changes
FROM #Temp_customer_orders c
INNER JOIN #temp_runners_order r
ON c.order_id = r.order_id
WHERE r.distances > 0 
GROUP BY c.Customer_id

--QUESTION 8: How many pizzas were delivered that had both exclusions and extras?
SELECT sum(c.pizza_id) as total_pizza, sum(CASE WHEN C.exclusions <>'' and c.extras <> '' then 1 else 0
END) testing
FROM #Temp_customer_orders c
INNER JOIN #temp_runners_order r
ON c.order_id = r.order_id
WHERE r.distances > 0
GROUP BY testing



