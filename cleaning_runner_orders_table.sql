--This script is to clean the runner_orders table

------------------------------------------------------------------------------------------------------
--Cleaning the runner_orders table
--Using the SELECT statement to retrieve all information from the runner_orders table
SELECT *
FROM
	runner_orders;

--Cleaning the pickup_time column
--Replacing values written as 'null' in the Pickup_time column using the CASE statement
SELECT
	pickup_time,
	CASE WHEN pickup_time = 'null'
	THEN NULL
	ELSE pickup_time
	END clean_pickup_time
FROM
	runner_orders;

--Using the update statement to update/change the records written as strings 'null' in the pickup_time column to NULL
UPDATE 
	runner_orders
SET 
	pickup_time = CASE WHEN pickup_time = 'null'
	THEN NULL
	ELSE pickup_time
	END; 

--Cleaning the distance column in the runner_orders table
--The values within this column are not consistent
--First creating a new column called new_distance that will hold the original and dirty data to avoid data loss while cleaning the column
ALTER TABLE 
	runner_orders 
ADD 
	new_distance VARCHAR(10); 

--Using the update statement the copy the data from the distance column to the new_distance column
UPDATE
	runner_orders
SET 
	new_distance = distance;

--Extracting the numeric values in records that have 'KM' in them.
SELECT
	distance,
	SUBSTRING(distance,1,PATINDEX('%km%', distance)-1) AS numeric_values
FROM	
	runner_orders
WHERE
	distance LIKE '%KM%';

--Updating the distance column
UPDATE
	runner_orders
SET 
	distance = SUBSTRING(distance,1,PATINDEX('%km%', distance)-1)
WHERE
	distance LIKE '%KM%';

--Changing values written as 'null' strings to null values
SELECT
	distance,
	CASE WHEN distance = 'null'
	THEN NULL
	ELSE distance
	END null_values
FROM
	runner_orders;

--Updating the distance column
UPDATE 
	runner_orders
SET
	distance = CASE WHEN distance = 'null'
	THEN NULL
	ELSE distance
	END;

--Removing excess space at the end of values in the distance column
SELECT 
	distance,
	RTRIM(distance)
FROM
	runner_orders
WHERE 
	distance IS NOT NULL;

--Updating the distance column 
UPDATE
	runner_orders
SET
	distance = RTRIM(distance);

--Adding KM to non null values in the distance column
SELECT
	distance,
	CONCAT(distance,'km') AS Distance_with_km
FROM
	runner_orders
WHERE
	distance IS NOT NULL;

--Updating the distance column to add KM to every non null values
UPDATE
	runner_orders
SET
	distance = CONCAT(distance,'km')
WHERE
	distance IS NOT NULL;

--Cleaning the duration column
/*Creating a new column called old_duration
This new column will hold the original data in the duration column*/
ALTER TABLE 
	runner_orders
ADD 
	old_duration VARCHAR(50);

--Updating the old_duratin column with values in the duration column
UPDATE
	runner_orders
SET 
	old_duration = duration;

--Changing string null records to NULL values
SELECT
	duration,
	CASE WHEN duration = 'null'
	THEN NULL
	ELSE duration
	END new_duration
FROM
	runner_orders;

--Updating the duration column with appropriate null values
UPDATE 
	runner_orders
SET
	duration = CASE WHEN duration = 'null'
	THEN NULL
	ELSE duration
	END;

--Cleaning the inconsistent strings in the duration column
SELECT
	duration,
	SUBSTRING(duration,1,PATINDEX('%min%',duration)-1) AS clean_duration
FROM
	runner_orders
WHERE
	duration LIKE '%min%'

--Updating the duration column
UPDATE
	runner_orders
SET
	duration = SUBSTRING(duration,1,PATINDEX('%min%',duration)-1)
WHERE
	duration LIKE '%min%';

--Triming the excess spaces at the end of values in the duration column
SELECT
	duration,
	RTRIM(duration) AS trimmed_column
FROM
	runner_orders
WHERE
	duration IS NOT NULL;

--Updating the duration column with trimmed values
UPDATE
	runner_orders
SET
	duration = RTRIM(duration)
WHERE
	duration IS NOT NULL;

--Adding Minutes to non null values in the duration column
SELECT
	duration,
	CONCAT(duration, ' ', 'minutes') AS clean_duration
FROM
	runner_orders
WHERE
	duration IS NOT NULL;

--Creating CTE to check the LEN of the clean_duration_column
WITH Durationlen AS (
	SELECT
		duration,
		CONCAT(duration,' ', 'minutes') AS clean_duration
	FROM
		runner_orders
	WHERE
		duration IS NOT NULL
)

SELECT 
	*, 
	LEN(clean_duration) AS Duration_len
FROM
	Durationlen;

--Updating the duration column
UPDATE
	runner_orders
SET
	duration = CONCAT(duration,' ','minutes')
WHERE
	duration IS NOT NULL;

--Cleaning the cancellation column
--Changing blank records to NULL and values written as null to NULL
SELECT 
	cancellation,
	CASE WHEN cancellation = 'null' OR cancellation = ' '
	THEN NULL
	ELSE cancellation
	END Clean_cancellation
FROM
	runner_orders;

--Updating the cancellation column to have consistent null records
UPDATE
	runner_orders
SET
	cancellation = CASE WHEN cancellation = 'null' OR cancellation = ' '
	THEN NULL
	ELSE cancellation
	END;

--Dropping columns that are no longer relevant
ALTER TABLE 
	runner_orders
DROP COLUMN 
	new_distance;

ALTER TABLE 
	runner_orders
DROP COLUMN
	old_duration;
------------------------------------------------------------------------------------------------------------------