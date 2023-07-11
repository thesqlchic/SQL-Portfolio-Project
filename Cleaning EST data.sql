/*Previewing all columns on the data.
An attempt to find excess and unwanted tables.*/
SELECT *
FROM Quarter_4_Data;

/*Removing extra and unwanted columns
This columns are completely null and have no data
They were added into the table during data importation into the database.
The ALTER and DROP Statement will be used to achieve this*/
ALTER TABLE
	Quarter_4_Data
DROP COLUMN 
	F39,F40,F41,F42,F43,F44;

/*Trimming out excess spaces in all columns
SELECT
	LEN([Email Address]) as EA1,
	LEN([What's your AIESEC mail]) AS AM1,
	LEN(LC) AS LC1,
	LEN([What's your Functional Area]) as FA1,
	LEN([What's your present role?]) as Role1,
	LEN(TRIM([Email Address])) EA2,
	LEN(TRIM([What's your AIESEC mail])) AS AM2,
	LEN(TRIM(LC)) AS LC2,
	LEN(TRIM([What's your Functional Area])) AS FA2,
	LEN(TRIM([What's your present role?])) AS Role2
FROM
	Quarter_4_Data;*/

--FIXING NULL VALUES IN IMPORTANT COLUMNS
--DELETING NULL INFORMATION FROM FULL NAME COLUMN 
DELETE 
FROM 
	Quarter_4_Data
WHERE
	[Full Name] IS NULL

-- SECOND NULL SOLUTION
--FIXING NULL IN AIESEC MAIL COLUMN
SELECT
	[Full Name], [Email Address], [AIESEC Mail],
	COALESCE([AIESEC Mail], [Email Address], null) AS NEW_AIESEC_MAIL
FROM
	Quarter_4_Data
WHERE
	[AIESEC Mail] IS NULL;

--Inputing the new information gotten into the table using the update statement
UPDATE
	Quarter_4_Data
SET 
	[AIESEC Mail] = COALESCE([AIESEC Mail], [Email Address], null)
WHERE
	[AIESEC Mail] IS NULL;

--Consistency in strings
SELECT
	[AIESEC Mail],
	LOWER([AIESEC Mail])
FROM	
	Quarter_4_Data;
 
--Updating the table and creating a more consistent string in the AIESEC mail column 
UPDATE
	Quarter_4_Data
SET 
	[AIESEC Mail] = LOWER([AIESEC Mail]);

--Changing Qualitative data to Quantitative data for proper analysis
SELECT --DISTINCT
	[Quarter Rating],
	CASE WHEN [Quarter Rating] = 'Excellent' THEN 5
	WHEN [Quarter Rating] = 'Very Good' THEN 4
	WHEN [Quarter Rating] = 'Good' THEN 3
	WHEN [Quarter Rating] = 'Fair' THEN 2
	WHEN [Quarter Rating] = 'Bad' THEN 1
	ELSE ''
	END
FROM
	Quarter_4_Data;

--Updating the Quarter 4 Table with the rating
UPDATE 
	Quarter_4_Data
SET
	[Quarter Rating] = 	CASE
	WHEN [Quarter Rating] = 'Excellent' THEN 5
	WHEN [Quarter Rating] = 'Very Good' THEN 4
	WHEN [Quarter Rating] = 'Good' THEN 3
	WHEN [Quarter Rating] = 'Fair' THEN 2
	WHEN [Quarter Rating] = 'Bad' THEN 1
	ELSE ''
	END;

--Checking for duplicate records using Window functions:CTE and Row Number.
WITH Duplicatecte AS(
SELECT [Full Name], [AIESEC Mail],LC, [Functional Area],
	ROW_NUMBER() OVER(PARTITION BY [Full Name], [AIESEC MAIL] ORDER BY LC) AS Duplicate_Checker
FROM	
	Quarter_4_Data)

--Deleting Duplicate records using Delete Statement.
DELETE
FROM
	Duplicatecte 
WHERE 
	Duplicate_Checker >1;