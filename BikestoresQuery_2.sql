USE [BikeStores]
GO

--Task 1 : Write a query to get all customer information (customers) with first_name
-- has the end next character between 't' and 'z' and zip_code starts with '11',
-- sort by first_name.

SELECT 
[customer_id]
      ,[first_name]
      ,[last_name]
      ,[phone]
      ,[email]
      ,[street]
      ,[city]
      ,[state]
      ,[zip_code]
  FROM [sales].[customers]
  WHERE [first_name] LIKE '%[T-Z]_'
  AND [zip_code] LIKE  '11%'
  ORDER BY [first_name]


----Task 2: Write a query to get all product information (products)
-- has a price (list_price) equal to 999.99 or 1999.99 or 2999.99.

--Method 1 : 
SELECT 
 [product_id]
      ,[product_name]
      ,[brand_id]
      ,[category_id]
      ,[model_year]
      ,[list_price]
  FROM [production].[products]
  WHERE [list_price] = 999.99
  OR [list_price] = 1999.99
  OR [list_price] =  2999.99

--Method 2 : 
SELECT 
 [product_id]
      ,[product_name]
      ,[brand_id]
      ,[category_id]
      ,[model_year]
      ,[list_price]
  FROM [production].[products]
  WHERE [list_price] IN ( 999.99,1999.99,2999.99)


--- Task 3: Write a query that returns the total number of products whose names start with 'Trek'
-- and priced from 199.99 to 999.99.

--Method 1: 
SELECT 
      COUNT([product_name]) AS [total number of products]    
FROM [production].[products]
WHERE [product_name] LIKE 'Trek%'
AND 
[list_price] >= 199.99 AND [list_price] <= 999.99

---Method 2
SELECT 
      COUNT([product_name]) AS [total number of products]
FROM [BikeStores].[production].[products]
WHERE 
[product_name] LIKE 'Trek%'
AND ([list_price] BETWEEN 199.99 AND 999.99)

---- Task 4: Write a query that returns product name, total price and total quantity of products
-- for products with the keyword 'Ladies' in the product name.

SELECT 
[product_name]
,COUNT([product_name]) AS [total quantity of products]
,SUM([list_price]) AS [total price]
FROM [production].[products]
WHERE [product_name] LIKE '%Ladies%'
GROUP BY [product_name]
ORDER BY [total quantity of products], [total price]

---Task 5: Write a query to output information about orders (order_id)
-- have a total net value (net_value) greater than 20,000 on the sales.order_items table,
-- know the net_ value calculated by the formula quantity * list_price * (1 - discount)

SELECT 
[order_id],
SUM([quantity] * [list_price] * (1 - [discount])) AS [total net value]
FROM [sales].[order_items]
GROUP BY [order_id]
HAVING SUM([quantity] * [list_price] * (1 - [discount])) > 20000
ORDER BY  [total net value]

