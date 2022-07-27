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


