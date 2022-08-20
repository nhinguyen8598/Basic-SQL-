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


--Task 2 : Write a function to calculate the net value of each invoice item (order_id and item_id)
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

-- Task 3 : Write a function to calculate the total net value of each invoice (order_id)
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

