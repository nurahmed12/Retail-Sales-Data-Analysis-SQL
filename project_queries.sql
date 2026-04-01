-- Database Creation
CREATE DATABASE retail_sales_analysis_project;

-- Table Creation
-- DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- Load The Data (CSV) Into The Table

-- Check if All Data Have Been Loaded
SELECT COUNT(*) FROM retail_sales;

-- Check the Top 10 Data from Table
SELECT TOP 10 * FROM retail_sales;

-- Check for Empty Data
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Remove Missing Values
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

-- How Many Sales Do We Have?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- How Many Customers Do We Have?
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;

-- How Many Categories Do We Have?
SELECT DISTINCT category total_categories FROM retail_sales;

-- Data Analysis (Business Questions & Answers)

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 -> Answer
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 -> Answer
SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing' AND
	quantiy > 10 AND
	YEAR(sale_date) = 2022 AND 
	MONTH(sale_date) = 11;

-- Q.3 -> Answer
SELECT 
	category Categories,
	SUM(total_sale) Total_Sales,
	COUNT(*) Total_Orders
FROM retail_sales
GROUP BY category;

-- Q.4 -> Answer
SELECT 
	ROUND(AVG(age), 2) Average_Age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 -> Answer
SELECT 
	*
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 -> Answer
SELECT 
	category,
	gender,
	COUNT(*) Total_Transactions
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY category;

-- Q.7 -> Answer
SELECT
	Selling_Year,
	Selling_Month,
	Average_Sales
FROM
(
	SELECT 
		YEAR(sale_date) Selling_Year,
		MONTH(sale_date) Selling_Month,
		ROUND(AVG(total_sale), 2) Average_Sales,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) Sale_Rank
	FROM retail_sales
	GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE Sale_Rank = 1;

-- Q.8 -> Answer
SELECT TOP 5
	customer_id,
	SUM(total_sale) Total_Sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC;

-- Q.9 -> Answer
SELECT DISTINCT
	category Category,
	COUNT(customer_id) Unique_Customers
FROM retail_sales
GROUP BY category;

-- Q.10 -> Answer
SELECT
	CASE
		WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shifts,
	COUNT(*) Number_of_Orders
FROM retail_sales
GROUP BY
	CASE
		WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END;



	-- Thank YOU by Nur Ahmed