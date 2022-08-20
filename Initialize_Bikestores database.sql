CREATE DATABASE [BikeStores]
GO

USE [BikeStores]
GO

CREATE SCHEMA [production]
GO

CREATE SCHEMA [sales]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[production].[categories]') AND type in (N'U'))
DROP TABLE [production].[categories]
GO

CREATE TABLE [production].[categories] (
	[category_id] INT IDENTITY (1, 1) NOT NULL,
	[category_name] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_categories] PRIMARY KEY ([category_id])
);


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[production].[brands]') AND type in (N'U'))
DROP TABLE [production].[brands]
GO

CREATE TABLE [production].[brands] (
	[brand_id] INT IDENTITY (1, 1) NOT NULL,
	[brand_name] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_brands] PRIMARY KEY ([brand_id])
);


/*Do not run this command in the first time you run the query 'create the table', it has an error will occur

ALTER TABLE [production].[products] DROP CONSTRAINT [FK_production_products_categories]
GO

ALTER TABLE [production].[products] DROP CONSTRAINT [FK_production_products_brands]
GO*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[production].[products]') AND type in (N'U'))
DROP TABLE [production].[products]
GO

CREATE TABLE [production].[products] (
	[product_id] INT IDENTITY (1, 1) NOT NULL,
	[product_name] VARCHAR (255) NOT NULL,
	[brand_id] INT NOT NULL,
	[category_id] INT NOT NULL,
	[model_year] SMALLINT NOT NULL,
	[list_price] DECIMAL (10, 2) NOT NULL,
    CONSTRAINT [PK_products] PRIMARY KEY ([product_id]),
	CONSTRAINT [FK_production_products_categories] FOREIGN KEY([category_id]) 
		REFERENCES [production].[categories] (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_production_products_brands] FOREIGN KEY([brand_id]) 
		REFERENCES [production].[brands] (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sales].[contacts]') AND type in (N'U'))
DROP TABLE [sales].[contacts]
GO

CREATE TABLE [sales].[contacts](
    [contact_id] INT IDENTITY(1,1) NOT NULL,
    [first_name] NVARCHAR(100) NOT NULL,
    [last_name] NVARCHAR(100) NOT NULL,
    [email] NVARCHAR(255) NOT NULL,
    CONSTRAINT [PK_contacts] PRIMARY KEY ([contact_id])
);


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sales].[customers]') AND type in (N'U'))
DROP TABLE [sales].[customers]
GO

CREATE TABLE [sales].[customers] (
	[customer_id] INT IDENTITY (1, 1) NOT NULL,
	[first_name] VARCHAR (255) NOT NULL,
	[last_name] VARCHAR (255) NOT NULL,
	[phone] VARCHAR (25),
	[email] VARCHAR (255) NOT NULL,
	[street] VARCHAR (255),
	[city] VARCHAR (50),
	[state] VARCHAR (25),
	[zip_code] VARCHAR (5),
	CONSTRAINT [PK_customers] PRIMARY KEY ([customer_id])
);


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sales].[stores]') AND type in (N'U'))
DROP TABLE [sales].[stores]
GO

CREATE TABLE sales.stores (
	[store_id] INT IDENTITY (1, 1) NOT NULL,
	[store_name] VARCHAR (255) NOT NULL,
	[phone] VARCHAR (25),
	[email] VARCHAR (255),
	[street] VARCHAR (255),
	[city] VARCHAR (255),
	[state] VARCHAR (10),
	[zip_code] VARCHAR (5),
	CONSTRAINT [PK_stores] PRIMARY KEY ([store_id])
);


/*Do not run this command in the first time you run the query 'create the table', it has an error will occur

ALTER TABLE [sales].[staffs]  DROP CONSTRAINT [FK_sales_staffs_stores]
GO

ALTER TABLE [sales].[staffs]  DROP CONSTRAINT [FK_sales_staffs_salesstaffs]
GO*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sales].[staffs]') AND type in (N'U'))
DROP TABLE [sales].[staffs]
GO

CREATE TABLE [sales].[staffs] (
	[staff_id] INT IDENTITY (1, 1) NOT NULL,
	[first_name] VARCHAR (50) NOT NULL,
	[last_name] VARCHAR (50) NOT NULL,
	[email] VARCHAR (255) NOT NULL UNIQUE,
	[phone] VARCHAR (25),
	[active] tinyint NOT NULL,
	[store_id] INT NOT NULL,
	[manager_id] INT,
	CONSTRAINT [PK_staffs] PRIMARY KEY ([staff_id]),
	CONSTRAINT [FK_sales_staffs_stores] FOREIGN KEY ([store_id]) 
	  REFERENCES [sales].[stores] (store_id) ON DELETE CASCADE ON UPDATE CASCADE ,
	CONSTRAINT [FK_sales_staffs_salesstaffs] FOREIGN KEY ([manager_id]) 
	 REFERENCES [sales].[staffs](staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


/*Do not run this command in the first time you run the query 'create the table', it has an error will occur

ALTER TABLE [sales].[orders] DROP CONSTRAINT [FK_sales_orders_customers]
GO

ALTER TABLE [sales].[orders] DROP CONSTRAINT [FK_sales_orders_stores]
GO

ALTER TABLE [sales].[orders] DROP CONSTRAINT [FK_sales_orders_staffs]
GO*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sales].[orders]') AND type in (N'U'))
DROP TABLE [sales].[orders]
GO

CREATE TABLE [sales].[orders] (
	[order_id] INT IDENTITY (1, 1) NOT NULL,
	[customer_id] INT,
	[order_status] tinyint NOT NULL,
	[order_date] DATE NOT NULL,
	[required_date] DATE NOT NULL,
	[shipped_date] DATE,
	[store_id] INT NOT NULL,
	[staff_id] INT NOT NULL,
    CONSTRAINT [PK_orders] PRIMARY KEY ([order_id]),
	CONSTRAINT [FK_sales_orders_customers] FOREIGN KEY ([customer_id])
	 REFERENCES [sales].[customers] (customer_id) ON DELETE CASCADE ON UPDATE CASCADE ,
	CONSTRAINT [FK_sales_orders_stores] FOREIGN KEY ([store_id]) 
	 REFERENCES [sales].[stores] (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_sales_orders_staffs] FOREIGN KEY ([staff_id]) 
	 REFERENCES [sales].[staffs] (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


/*Do not run this command in the first time you run the query 'create the table', it has an error will occur

ALTER TABLE [sales].[order_items] DROP CONSTRAINT [FK_sales_order_items_orders]
GO

ALTER TABLE [sales].[order_items] DROP CONSTRAINT [FK_sales_order_items_products]
GO*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sales].[order_items]') AND type in (N'U'))
DROP TABLE [sales].[order_items]
GO

CREATE TABLE [sales].[order_items] (
	[order_id] INT,
	[item_id] INT,
	[product_id] INT NOT NULL,
	[quantity] INT NOT NULL,
	[list_price] DECIMAL (10, 2) NOT NULL,
	[discount] DECIMAL (4, 2) NOT NULL DEFAULT 0,
	CONSTRAINT [PK_sales_order_items] PRIMARY KEY ([order_id], [item_id]),
	CONSTRAINT [FK_sales_order_items_orders] FOREIGN KEY ([order_id]) 
	  REFERENCES [sales].[orders] (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_sales_order_items_products] FOREIGN KEY ([product_id]) 
	 REFERENCES [production].[products] (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);


/*Do not run this command in the first time you run the query 'create the table', it has an error will occur

ALTER TABLE [production].[stocks] DROP CONSTRAINT [FK_production_stocks_stores]
GO

ALTER TABLE [production].[stocks] DROP CONSTRAINT [FK_production_stocks_products]
GO*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[production].[stocks]') AND type in (N'U'))
DROP TABLE [production].[stocks]
GO

CREATE TABLE [production].[stocks] (
	[store_id] INT,
	[product_id] INT,
	[quantity] INT,
	CONSTRAINT [PK_production_stocks] PRIMARY KEY ([store_id], [product_id]),
	CONSTRAINT [FK_production_stocks_stores] FOREIGN KEY ([store_id]) 
	 REFERENCES [sales].[stores] (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_production_stocks_products] FOREIGN KEY ([product_id]) 
	 REFERENCES [production].[products] (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);
