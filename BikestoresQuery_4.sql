USE [BikeStores]
GO

/*Task 1
- Write a query to get information about product name (product_name), order number (order_id), product quantity (quantity)
- and order transaction date (order_date)

- Then create a stored procedure to perform order_date filtering on the newly created dataset as you like:
- - if order_date is found: output the above result according to the order_date entered by the user
- - if order_date is not found: output the following sentence ('No order_date information found in the system')*/

SELECT 
	p.[product_name]
	,i.[order_id]
	,i.[quantity]
	,o.[order_date]
FROM [production].[products] p
JOIN [sales].[order_items] i 
	ON p.[product_id] = i.[product_id]
JOIN [sales].[orders] o 
	ON i.[order_id] = o.[order_id]
--WHERE [order_date] = '2017-07-02'
GO

CREATE PROCEDURE sp_GetSalesDatabyOrderDate_1
  @order_date DATE = NULL 

  AS 
  BEGIN 
  IF  @order_date IS NULL 
   BEGIN
        SELECT 
            p.[product_name]
            ,i.[order_id]
            ,i.[quantity]
            ,o.[order_date]
        FROM [production].[products] p
        JOIN [sales].[order_items] i 
            ON p.[product_id] = i.[product_id]
        JOIN [sales].[orders] o 
            ON i.[order_id] = o.[order_id]
        WHERE @order_date IS NULL OR o.[order_date] = @order_date
        END 
        ELSE 
        PRINT N'No order_date information found in the system'
    END
GO 

 ---DROP PROCEDURE sp_GetSalesDatabyOrderDate_1;

EXEC sp_GetSalesDatabyOrderDate_1 @order_date = '2017-07-02'
GO

EXEC sp_GetSalesDatabyOrderDate_1 @order_date = '2017-07-01'
GO

---Task 2 :  Write a query to get information about product name (product_name), price of each product (list_price) and model_year.
-- Then create a stored procedure to filter data by 2 criteria:
--- - product name according to the model
-- - how many tops (top 1, 5, 10,...) the highest priced product by model_year or the highest priced product by model_year's ranking
-- (eg 2nd highest priced product by model_year)

SELECT
    [product_name]
    ,[list_price]
    ,[model_year]
FROM [production].[products]
ORDER BY [list_price] DESC, [model_year]
GO

CREATE PROCEDURE sp_GetProductbyNameandRankingPrice1
    @productNamePattern VARCHAR(255)
    ,@fromRank INT
    ,@toRank INT
    ,@modelYear INT = NULL
AS
    BEGIN
        WITH _TEMP
        AS 
        (
            SELECT
                [product_name]
                ,[list_price]
                ,[model_year]
                ,DENSE_RANK() OVER (PARTITION BY model_year ORDER BY list_price DESC) AS [ranking]
            FROM [production].[products]
        )
        SELECT
            [product_name]
            ,[list_price]
            ,[model_year]
        FROM _TEMP
        WHERE [product_name] LIKE @productNamePattern
            AND [ranking] BETWEEN @fromRank AND @toRank
            AND (@modelYear IS NULL OR model_year = @modelYear)
              END
              GO 

            ---DROP PROCEDURE sp_GetProductbyNameandRankingPrice1;

    EXEC sp_GetProductbyNameandRankingPrice1 @productNamePattern = '%', @fromRank = 1, @toRank = 1 --, @modelYear = 2017
   GO

--EXEC sp_GetProductbyNameandRankingPrice1 @productNamePattern = '_%', @fromRank = 1, @toRank = 1 , @modelYear = 2016
--GO

--Task 3 : Write a function to calculate the net value of each invoice item (order_id and item_id)
-- know the net value is calculated by the formula quantity * list_price * (1 - discount).

CREATE FUNCTION sales.udfNetSale(
    @quantity INT,
    @list_price DEC(10,2),
    @discount DEC(4,2)

)
RETURNS DEC(10,2)
AS
BEGIN
    RETURN @quantity * @list_price * (1 - @discount)
END
GO

-- Task 4 : Write a function to calculate the total net value of each invoice (order_id)
-- know the net value is calculated by the formula quantity * list_price * (1 - discount).

CREATE FUNCTION [sales].[udfTotalNetSale2](
    @order_id INT
)
RETURNS DEC(10,2)
AS
BEGIN
    DECLARE 
        @total DEC(10,2)

    SELECT
        @total = SUM(sales.udfNetSale([quantity], [list_price], [discount]))
    FROM [sales].[order_items]
    WHERE order_id = @order_id
    GROUP BY order_id

    RETURN @total
END
GO

--Task 5
-- Create a view that returns the 3 products with the highest net_value of each order,
-- then create 1 more view to statistics the frequency of appearance of those products.

CREATE VIEW [dbo].[vw_top3_netsale]
AS
WITH _TEMP
AS
(
	SELECT
		[order_id]
		,[product_name]
		,[quantity] * oi.[list_price] * (1 - [discount]) AS [net_sale]
        --, sales.udfNetSale([quantity],oi.[list_price], [discount]) AS [net_sale]
	FROM [sales].[order_items] oi
	LEFT JOIN [production].[products] p
		ON oi.[product_id] = p.[product_id]
)
,_RANKING
AS
(
	SELECT
		[order_id]
		,[product_name]
		,[net_sale]
        ,ROW_NUMBER() OVER (PARTITION BY [order_id] ORDER BY [net_sale] DESC) AS [ranking]
	FROM _TEMP
)
SELECT
	[order_id]
	,[product_name]
	,[net_sale]
FROM _RANKING
WHERE [ranking] <= 3
GO

/*SELECT 
*
FROM  [dbo].[vw_top3_netsale]*/

 --DROP   VIEW [dbo].[vw_top3_netsale];

CREATE VIEW [dbo].[vw_productSales_frequency]
AS
SELECT
	[product_name]
	,COUNT(*) AS [frequency]
FROM [dbo].[vw_top3_netsale]
GROUP BY [product_name]
GO

/*SELECT 
*
FROM  [dbo].[vw_productSales_frequency]*/

--Drop VIEW [dbo].[vw_productSales_frequency]
