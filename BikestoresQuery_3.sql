USE [BikeStores]
GO

--- Task1: Write a query to get product information (product_name), order code (order_id) with that product (if any),
-- number of products (quantity) and daily orders transacted (order_date)

SELECT 
	p.[product_name]
	,i.[order_id]
	,i.[quantity]
	,o.[order_date]
FROM [production].[products] p
LEFT JOIN [sales].[order_items] i 
	ON p.[product_id] = i.[product_id]
LEFT JOIN [sales].[orders] o 
	ON i.[order_id] = o.[order_id]

---Task2 : Write a query to get brand information (brand_name) and average price (average_list_price)
-- for all products with model_year of 2018.

SELECT 
	b.[brand_name]
    ,AVG(p.[list_price]) as [average_list_price]
FROM [production].[products] p
INNER JOIN [production].[brands] b 
	ON p.[brand_id] = b.[brand_id]
WHERE p.[model_year] = 2018
GROUP BY b.[brand_name]

---Task3 :  Write a query to get information about order code (order_id), customer name (customer_name), store name (store_name),
-- total product quantity (total_quantity) and total order value (total_net_value) knowing order value (net_value)
-- calculated by the formula quantity * list_price * (1 - discount)

SELECT
	O.[order_id]
   ,CONCAT_WS(' ', C.[first_name], C.[last_name]) AS [customer_name]
	---,C.[first_name] + ' ' + C.[last_name] AS [customer_name]
	,S.[store_name]
	,SUM(OI.[quantity]) AS [total_quantity]
	,SUM(OI.[quantity] * OI.[list_price] * (1 - OI.[discount])) AS [total_net_value]
FROM [sales].[orders] O
JOIN [sales].[customers] C
	ON O.[customer_id] = C.[customer_id]
JOIN [sales].[stores] S
	ON O.[store_id] = S.[store_id]
JOIN [sales].[order_items] OI
	ON O.[order_id] = OI.[order_id]
GROUP BY 
	O.[order_id]
    ,CONCAT_WS(' ', C.[first_name],C.[last_name])
	--,C.[first_name] + ' ' + C.[last_name]
	,S.[store_name]  

---Task4 :  Write a query to get information about products that have not been sold at any stores or are out of stock (quantity = 0),
-- results should return store name and product name.

SELECT
	st.[store_name]
	,p.[product_name]
FROM [production].[stocks] stk
RIGHT JOIN [production].[products] p
	ON p.[product_id] = stk.[product_id]
LEFT JOIN [sales].[stores] st
	ON stk.[store_id] = st.store_id
WHERE stk.quantity = 0 OR stk.store_id IS NULL

