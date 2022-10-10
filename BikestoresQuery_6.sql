----- Write a statistical query for sales information in the following form: year, month, order_date, net_sale, MTD (month-to-date), YTD (year-to-date)
WITH _TEMP
AS
(
	SELECT 
		YEAR([order_date]) AS [year]
		,DATEPART(QUARTER, [order_date]) AS [quarter]
		,MONTH([order_date]) AS [month]
		,[order_date]
		,[quantity] * [list_price] * (1- [discount]) AS [net_sale]
	FROM [BikeStores].[sales].[orders] o
	JOIN [sales].[order_items] oi
		ON o.[order_id] = oi.order_id
)
SELECT
	[year]
	,[month]
	,[order_date]
	,[net_sale]
	,SUM([net_sale]) OVER (PARTITION BY [year], [quarter] ORDER BY [order_date]) AS [QTD]
	,SUM([net_sale]) OVER (PARTITION BY [year], [month] ORDER BY [order_date]) AS [MTD]
	,SUM([net_sale]) OVER (PARTITION BY [year] ORDER BY [order_date]) AS [YTD]
FROM _TEMP

-- Write a statistical query for sales information according to the following form:
-- year, month, total_net_sale (TNS)
-- ,last_month_TNS, diff_months (total_net_sale - last_month_TNS)
-- ,same_period_last_year_TNS, diff_between_same_period_last_year_TNS (total_net_sale - same_period_last_year_TNS)

;WITH _TEMP
AS
(
	SELECT 
		YEAR([order_date]) AS [year]
		,MONTH([order_date]) AS [month]
		,SUM([quantity] * [list_price] * (1- [discount])) AS [total_net_sale]
	FROM [BikeStores].[sales].[orders] o
	JOIN [sales].[order_items] oi
		ON o.[order_id] = oi.order_id
	GROUP BY YEAR([order_date])
		,MONTH([order_date])
)
SELECT
	[year]
	,[month]
	,[total_net_sale]
	,LAG([total_net_sale]) OVER (ORDER BY [year], [month]) [last_month]
	--,LAG([total_net_sale]) OVER (PARTITION BY [year] ORDER BY [month]) [last_month]
	,[total_net_sale] - LAG([total_net_sale]) OVER (PARTITION BY [year] ORDER BY [month]) AS [diff_between_months]
	,LAG([total_net_sale]) OVER (PARTITION BY [month] ORDER BY [year]) [same_period_last_year]
	,[total_net_sale] - LAG([total_net_sale]) OVER (PARTITION BY [month] ORDER BY [year]) AS [diff_between_same_period_last_year]
FROM _TEMP
ORDER BY [year], [month]

--- From the above query, create 2 views for these queries.

CREATE VIEW [dbo].[vw_sales_summary]
AS
WITH _TEMP
AS
(
	SELECT 
		YEAR([order_date]) AS [year]
		,MONTH([order_date]) AS [month]
		,[order_date]
		,[quantity] * [list_price] * (1- [discount]) AS [net_sale]
	FROM [BikeStores].[sales].[orders] o
	JOIN [sales].[order_items] oi
		ON o.[order_id] = oi.order_id
)
SELECT
	[year]
	,[month]
	,[order_date]
	,[net_sale]
	,SUM([net_sale]) OVER (PARTITION BY [year], [month] ORDER BY [order_date]) AS [MTD]
	,SUM([net_sale]) OVER (PARTITION BY [year] ORDER BY [order_date]) AS [YTD]
FROM _TEMP
GO

CREATE VIEW [dbo].[vw_sales_summary2]
AS
WITH _TEMP
AS
(
	SELECT 
		YEAR([order_date]) AS [year]
		,MONTH([order_date]) AS [month]
		,SUM([quantity] * [list_price] * (1- [discount])) AS [total_net_sale]
	FROM [BikeStores].[sales].[orders] o
	JOIN [sales].[order_items] oi
		ON o.[order_id] = oi.order_id
	GROUP BY YEAR([order_date])
		,MONTH([order_date])
)
SELECT
	[year]
	,[month]
	,[total_net_sale]
	--,LAG([total_net_sale]) OVER (PARTITION BY [year] ORDER BY [month]) [last_month]
	,LAG([total_net_sale]) OVER (ORDER BY [month]) [last_month]
	,[total_net_sale] - LAG([total_net_sale]) OVER (PARTITION BY [year] ORDER BY [month]) AS [diff_between_months]
	,LAG([total_net_sale]) OVER (PARTITION BY [month] ORDER BY [year]) [same_period_last_year]
	,[total_net_sale] - LAG([total_net_sale]) OVER (PARTITION BY [month] ORDER BY [year]) AS [diff_between_same_period_last_year]
FROM _TEMP
--ORDER BY [year], [month]
GO

/*Create a view that returns the 3 products with the highest net_value of each order,
then create 1 more view to statistics the frequency of appearance of those products.*/

CREATE VIEW [dbo].[vw_top3_netsale]
AS
WITH _TEMP
AS
(
	SELECT
		[order_id]
		,[product_name]
		,[quantity] * oi.[list_price] * (1 - [discount]) AS [net_sale]
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

select 
*
from  [dbo].[vw_top3_netsale]

 --DROP   VIEW [dbo].[vw_top3_netsale];

CREATE VIEW [dbo].[vw_productSales_frequency]
AS
SELECT
	[product_name]
	,COUNT(*) AS [frequency]
FROM [dbo].[vw_top3_netsale]
GROUP BY [product_name]
--ORDER BY [frequency] DESC
GO
--drop VIEW [dbo].[vw_productSales_frequency]