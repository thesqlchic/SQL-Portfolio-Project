--Question 1: Total amount spent by each customer at the resturant
SELECT
	Sales.customer_id,sum(menu.price) as total_amount
FROM sales
INNER JOIN menu
ON sales.product_id=menu.product_id
GROUP BY sales.customer_id

--Question 2: Total days each customer visited the resturant
SELECT
	Sales.customer_id,COUNT(DISTINCT sales.order_date) as total_visit
FROM Sales
GROUP BY sales.customer_id;

--Question 3: First item purchased by each customer
WITH firstitemcte AS (
SELECT 
	Sales.customer_id,sales.product_id,menu.product_name, DENSE_RANK() OVER(PARTITION BY Sales.customer_id ORDER BY sales.order_date) as Item_Rank
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id)

SELECT *
FROM firstitemcte
WHERE Item_Rank=1;

--Question 4: Most purchased item on the menu and the number of times it was purchased by all customers
SELECT 
	 TOP(1) menu.product_name,COUNT(sales.product_id) as Numberoftimepurchased
FROM sales
INNER JOIN menu
ON sales.product_id= menu.product_id
GROUP BY menu.product_name
ORDER BY Numberoftimepurchased desc

--Question 5: Most popular item for each customer
WITH Mostpopularitemcte AS(
SELECT
	Sales.customer_id,COUNT(sales.product_id) as total_order,menu.product_name,DENSE_RANK() OVER(PARTITION BY sales.customer_id ORDER BY COUNT(sales.product_id) DESC) as ITEM_DENSE_RANK
FROM sales
INNER JOIN menu
ON sales.product_id=menu.product_id
GROUP BY SALES.customer_id,Menu.product_name)

SELECT *
FROM Mostpopularitemcte
WHERE ITEM_DENSE_RANK =1

--Question 6: First item purchased by customer after membership
WITH firstorderasamembercte AS(
SELECT 
	sales.customer_id,sales.order_date,menu.product_name,members.join_date, DENSE_RANK() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date) as Firstmembershipitemrank
FROM Sales 
INNER JOIN menu
ON sales.product_id=menu.product_id
inner join members
ON sales.customer_id=members.customer_id
WHERE sales.order_date > members.join_date
)

SELECT *
FROM firstorderasamembercte
WHERE Firstmembershipitemrank =1

--Question 7: Item purchased just before the customer became a member
WITH lastitembeforemembershipcte AS (
SELECT
	Sales.customer_id,Sales.order_date,menu.product_name,members.join_date, DENSE_RANK() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) as lastitembeforemembershiprank
FROM Sales
INNER JOIN menu
ON sales.product_id=menu.product_id
INNER JOIN members
on sales.customer_id = members.customer_id
WHERE sales.order_date < members.join_date
)

SELECT *
FROM lastitembeforemembershipcte
WHERE lastitembeforemembershiprank = 1;

--Question 8: Total item and amount spent by each member after membership
SELECT 
	sales.customer_id,COUNT(sales.product_id) AS total_item, SUM(menu.price) AS total_amount_spent_after_membership
FROM Sales
INNER JOIN Menu
ON sales.product_id=menu.product_id
INNER JOIN members 
ON sales.customer_id=members.customer_id
WHERE sales.order_date > members.join_date
GROUP BY sales.customer_id;

--Question 9: Points of each customer
WITH customerpointcte AS(
SELECT 
	*,
	CASE WHEN product_name='Sushi' THEN (price * 10)*2
	ELSE price*10
	END Points
FROM menu
)

SELECT customer_id, sum(points) as total_points
FROM customerpointcte
inner JOIn sales
on customerpointcte.product_id=sales.product_id
GROUP BY customer_id;

--Question 10: Point heard by customers after becoming members
WITH Aftermembershippointscte AS(
SELECT
	sales.customer_id,sales.order_date,sales.product_id,members.join_date,menu.product_name,menu.price
	,CASE 
	WHEN sales.order_date < members.join_date THEN null
	WHEN sales.order_date BETWEEN members.join_date AND DATEADD(day,7,members.join_date) THEN (menu.price *10)*2
	ELSE CASE 
	WHEN menu.product_name='Sushi' THEN (menu.price *10)*2
	END 
	END CUSTOMER_POINTS
FROM sales
INNER JOIN menu
ON sales.product_id=menu.product_id
INNER JOIN members
ON sales.customer_id=members.customer_id)

SELECT customer_id,SUM(customer_points) AS total_points
FROM Aftermembershippointscte
WHERE order_date BETWEEN '2021-01-01' AND '2021-01-31'
GROUP BY customer_id

--BONUS QUESTION: Joining all Tables
SELECT sales.customer_id,sales.order_date,menu.product_name,menu.price,
CASE WHEN sales.order_date >= members.join_date THEN 'Y'
ELSE 'N'
END member
FROM sales
INNER JOIN menu
ON sales.product_id=menu.product_id
LEFT JOIN members 
on sales.customer_id=members.customer_id;

--Ranking all cutomers
WITH customerrankcte AS(
SELECT sales.customer_id,sales.order_date,menu.product_name,menu.price,
CASE WHEN sales.order_date >= members.join_date THEN 'Y'
ELSE 'N'
END member
FROM sales
INNER JOIN menu
ON sales.product_id=menu.product_id
LEFT JOIN members 
ON sales.customer_id=members.customer_id
)

SELECT *,
	CASE
	WHEN member = 'Y' THEN DENSE_RANK() OVER(PARTITION BY customer_id,member ORDER BY order_date)
	ELSE NULL
	END Customer_ranking
FROM customerrankcte
