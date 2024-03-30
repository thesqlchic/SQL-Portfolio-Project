--This script is used to clean the customer_orders table
--An issue of inconsistent strings has been observed in two columns: exclusions and extras columns
--Removing duplicates data from the table

--------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM
	customer_orders;

--Cleaning the exclusions column
--Changing null strings and blank values to NULL values
SELECT
	exclusions,
	CASE WHEN exclusions = ' '
	OR exclusions = 'null'
	THEN NULL
	ELSE exclusions
	END new_exclusions
FROM
	customer_orders;

--Updating the exclusions column
UPDATE
	customer_orders
SET
	exclusions = CASE WHEN exclusions = ' '
	OR exclusions = 'null'
	THEN NULL
	ELSE exclusions
	END;

--Cleaning the extras column
--Changing null strings and blank values to NULL values
SELECT
	extras,
	CASE WHEN extras = ' '
	OR extras = 'null'
	THEN NULL
	ELSE extras
	END new_extras
FROM
	customer_orders;

--Updating the extras column
UPDATE
	customer_orders
SET
	extras = CASE WHEN extras = ' '
	OR extras = 'null'
	THEN NULL
	ELSE extras
	END;

--Removing duplicate data from the table
--Using ROW_NUMBER and CTE to identify and remove duplicate data
WITH duplicate_order_time AS (
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY customer_id,order_time ORDER BY pizza_id DESC) AS rownumvers
FROM
	customer_orders
)

DELETE 
	duplicate_order_time
WHERE
	rownumvers = 3;