USE [BikeStores]
GO

---Task 1: The query retrieves order_date information 
--in the sales.orders table (return results are unique), sorted in ascending order.

SELECT DISTINCT 
[order_date]
FROM [sales].[orders]
ORDER BY [order_date] 
GO 

---Task 2 :  Query brand_id information and category_id in table production.products (return results are unique).

SELECT DISTINCT 
[brand_id],
[category_id]
FROM [production].[products]
ORDER BY [brand_id], [category_id]
GO 

----Task 3 : Write a query to get all employee information (sales.staffs table) 
---with store_id equal to 1 and manager_id equal to 2, sorted in ascending order by first_name.

--Method 1 :

SELECT 
 *
FROM [sales].[staffs]
WHERE [store_id] = 1 
AND [manager_id] = 2 
ORDER BY [first_name]

 --Method 2 : 

SELECT 
  [staff_id]
      ,[first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
FROM [sales].[staffs]
WHERE [store_id] = 1 
AND [manager_id] = 2 
ORDER BY [first_name]

---Task 4 : Write a query that gets all product information (production.products table) 
--with brand_id equal to 1 or 9, and has a price (list_price) between 199.99 and 499.99.

--Method 1 : 

SELECT 
*
FROM [production].[products]
WHERE (brand_id = 1 OR brand_id = 9)
AND ([list_price] >= 199.99 AND [list_price] <= 499.99)

--Method 2 : 

SELECT 
[product_id]
      ,[product_name]
      ,[brand_id]
      ,[category_id]
      ,[model_year]
      ,[list_price]
FROM [production].[products]
WHERE (brand_id = 1 OR brand_id = 9)
AND ([list_price] BETWEEN 199.99 AND  499.99)

---Task 5 : Write a query that lists the names of the 5 products (production.products table) 
---with the highest price (list_price) provided that the product has a model_year equal to 2018.

SELECT TOP 5 
[product_name]
FROM[production].[products]
WHERE [model_year] = 2018
ORDER BY [list_price] DESC 