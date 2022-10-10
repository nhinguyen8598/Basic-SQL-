USE BikeStores
GO 

-- Task 1: Create a table sales.customers_audit, write triggers to store change information for INSERT, UPDATE, DELETE on sales.customers table
CREATE TABLE sales.customers_audit(
    change_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    first_name VARCHAR (255) NOT NULL,
    last_name VARCHAR (255) NOT NULL,
    phone   VARCHAR (25) NOT NULL,
    email   VARCHAR (255) NOT NULL,
    street VARCHAR (255) NOT NULL,
    city   VARCHAR (50) NOT NULL,
    [state] VARCHAR (25) NOT NULL,
    zip_code VARCHAR (5) NOT NULL,
    updated_at DATETIME NOT NULL,
    operation CHAR(7) NOT NULL,
    CHECK(operation IN ('INS', 'UPD-NEW', 'UPD-DEL', 'DEL'))
	)
	GO 
CREATE TRIGGER [sales].[trg_customers_audit]       
ON [sales].[customers]
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
	 INSERT INTO  [sales].[customers_audit] (
	 [customer_id]
      ,[first_name]
      ,[last_name]
      ,[phone]
      ,[email]
      ,[street]
      ,[city]
      ,[state]
      ,[zip_code]
	  ,[updated_at] 
       ,[operation]
    )
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
        ,GETDATE()
        ,'INS'
    FROM inserted
	UNION ALL 
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
       , GETDATE()
       ,'DEL'
    FROM deleted
END
GO
    CREATE TRIGGER [sales].[trg_customers_audit2]
ON [sales].[customers]
AFTER UPDATE
AS
BEGIN 
SET NOCOUNT ON;
	INSERT INTO  [sales].[customers_audit] (
	 [customer_id]
      ,[first_name]
      ,[last_name]
      ,[phone]
      ,[email]
      ,[street]
      ,[city]
      ,[state]
      ,[zip_code]
	  ,[updated_at] 
        ,[operation]
    )
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
        ,GETDATE()
        ,'UPD-NEW'
    FROM inserted
	UNION ALL 
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
       , GETDATE()
        ,'UPD-DEL'
    FROM deleted
END


--Task 2: Create a table sales.staffs_audit, write triggers to store change information for INSERT, UPDATE, DELETE actions on sales.staffs table
CREATE TABLE sales.staffs_audit (
    change_id INT IDENTITY PRIMARY KEY,
    staff_id INT NOT NULL,
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    email VARCHAR (255) NOT NULL,
    phone VARCHAR (25) NOT NULL,
    active TINYINT NOT NULL,
    store_id INT NOT NULL,
    manager_id INT NOT NULL,
    updated_at DATETIME NOT NULL,
    operation CHAR(7) NOT NULL,
    CHECK(operation IN ('INS', 'UPD-NEW', 'UPD-DEL', 'DEL'))
	)
    GO
	CREATE TRIGGER [sales].[trg_staffs_audit]
	ON [sales].[staffs]
	AFTER INSERT, DELETE
    AS
    BEGIN
    SET NOCOUNT ON;
	INSERT INTO [sales].[staffs_audit](                 
	 [staff_id]
      ,[first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
	  ,[updated_at] 
        ,[operation]
             )                  
	   SELECT
       [staff_id]
      ,[first_name]
      ,[last_name]        
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
        ,GETDATE()
        ,'INS'
    FROM inserted
	
	UNION ALL 
	
	SELECT
        [staff_id]
      ,[first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
       , GETDATE()
       , 'DEL'
    FROM deleted
END
 GO 
 CREATE TRIGGER [sales].[trg_staffs_audit2]
ON [sales].[staffs]
AFTER UPDATE
AS
BEGIN 
SET NOCOUNT ON;
	INSERT INTO [sales].[staffs_audit] (
	 [staff_id]
      ,[first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
	  ,[updated_at]
      ,[operation]
    )
	SELECT
       	 [staff_id]
      ,[first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
        ,GETDATE()
       , 'UPD-NEW'
    FROM inserted
	
	UNION ALL 
		
		SELECT
        [staff_id]
      ,[first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
       , GETDATE()
       , 'UPD-DEL'
    FROM deleted
END