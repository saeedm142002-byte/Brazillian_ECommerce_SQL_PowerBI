-- use Empty DataBase
USE DataWarehouse

/*
Create simple same tables varchar 
for all in the begining
*/

-- Create Bronze Customers Table
CREATE TABLE Bronze.Customers (
	Customer_Id varchar(50) ,
	Customer_Unique_Id varchar(50) ,
	Customer_ZipCode varchar(50) ,
	Customer_City varchar(50) ,
	Customer_State varchar(50)

);
GO

-- Create Bronze Geolocation table
CREATE TABLE Bronze.Geolocation (
	GeoLocation_ZipCode varchar(50) ,
	GeoLocation_Latitude varchar(50) ,
	GeoLocation_Langtitude varchar(50) ,
	GeoLocation_City varchar(50) ,
	GeoLocation_State varchar(50) ,
	

);
GO
-- Create Bronze OrderItems Table
CREATE TABLE Bronze.OrderItems (
	Order_Id varchar(50) ,
	OrderItem_Id varchar(50) ,
	Product_Id varchar(50) ,
	seller_id varchar(50) ,
	shipping_limit_date varchar(50) ,
	price varchar(50) ,
	freight_value varchar(50) 

);

GO

-- Create Bronze Order Payments Table
CREATE TABLE Bronze.Order_Payment (
	Order_Id varchar(50) ,
	payment_sequential varchar(50) ,
	payment_type varchar(50) ,
	payment_installments varchar(50) ,
	payment_value varchar(50) 
	

);


GO

-- Create Bronze Orders Table
CREATE TABLE Bronze.Orders (
	Order_Id varchar(50) ,
	customer_id varchar(50) ,
	order_status varchar(50) ,
	order_purchase_timestamp varchar(50) ,
	order_approved_at varchar(50) ,
	order_delivered_carrier_date varchar(50) ,
	order_delivered_customer_date varchar(50) ,
	order_estimated_delivery_date varchar(50) 
);

GO
-- Create Bronze Products Table
CREATE TABLE Bronze.Products (
	product_id varchar(50) ,
	product_category_name varchar(50) ,
	product_name_lenght varchar(50) ,
	product_description_lenght varchar(50) ,
	product_photos_qty varchar(50) ,
	product_weight_g varchar(50) ,
	product_length_cm varchar(50) ,
	product_height_cm varchar(50) ,
	product_width_cm varchar(50) 
);

GO

-- Create Bronze Seller Table
CREATE TABLE Bronze.Seller (
	seller_id varchar(50) ,
	seller_zipcode varchar(50) ,
	seller_city varchar(50) ,
	seller_state varchar(50) 
);

GO

-- Create Bronze Category Names English version table
CREATE TABLE Bronze.Product_CategoryNameTranslation (
	product_category_name varchar(50) ,
	product_category_name_english varchar(50) 
);

GO

-- Create Bronze Products Reviews Table
CREATE TABLE Bronze.Reviews (
	review_id varchar(50) ,
	order_id varchar(50) ,
	review_score varchar(50) ,
	review_creation_date varchar(50) ,
	review_answer_timestamp varchar(50) 
);
GO

-- Create Bronze Closed Deals Table
CREATE TABLE Bronze.Closed_Deals (
	mql_id varchar(50) ,
	seller_id varchar(50) ,
	sdr_id varchar(50) ,
	sr_id varchar(50) ,
	won_date varchar(50) ,
	business_segment varchar(50) ,
	lead_type varchar(50) ,
	lead_behaviour_profile varchar(50) ,
	has_company varchar(50) ,
	has_gtin varchar(50) ,
	average_stock varchar(50) ,
	business_type varchar(50) ,
	declared_product_catalog_size varchar(50) ,
	declared_monthly_revenue varchar(50) 
);

GO



-- Create Bronze Marketing Qualified Leads Table
CREATE TABLE Bronze.Marketing_Qualified_Leads (
	mql_id varchar(50) ,
	first_contact_date varchar(50) ,
	landing_page_id varchar(50) ,
	origin varchar(50) 
);

GO
/*
Copy Data from Row Data to Bronze Layer in DWH
*/

-- Insert Data Into Bronze Customers Table
INSERT INTO DataWarehouse.Bronze.Customers
SELECT * FROM [Brazillian E-Commerce].dbo.olist_customers_dataset$;

GO


-- Insert Data Into Bronze Closed Deal Table
INSERT INTO DataWarehouse.Bronze.Closed_Deals
SELECT * FROM [Brazillian E-Commerce].dbo.olist_closed_deals_dataset;

GO


-- Insert Data Into Bronze GeoLoction Table
INSERT INTO DataWarehouse.Bronze.Geolocation
SELECT * FROM DataWarehouse.dbo.Geolocation;

GO


-- Insert Data Into Bronze Marketing Qualified Leads Table
INSERT INTO DataWarehouse.Bronze.Marketing_Qualified_Leads
SELECT * FROM [Brazillian E-Commerce].dbo.olist_marketing_qualified_leads_dataset;

GO


-- Insert Data Into Bronze Order Payments table
INSERT INTO DataWarehouse.Bronze.Order_Payment
SELECT * FROM [Brazillian E-Commerce].dbo.olist_order_payments_dataset$;

GO



-- Insert Data Into Bronze Order Items Table
INSERT INTO DataWarehouse.Bronze.OrderItems
SELECT * FROM [Brazillian E-Commerce].dbo.olist_order_items_dataset$;

GO

-- Insert Data Into Bronze Orders Table
INSERT INTO DataWarehouse.Bronze.Orders
SELECT * FROM [Brazillian E-Commerce].dbo.olist_orders_dataset$;

GO


-- Insert Data Into Bronze Category Names In English Table
INSERT INTO DataWarehouse.Bronze.Product_CategoryNameTranslation
SELECT * FROM [Brazillian E-Commerce].dbo.product_category_name_translati$;

GO



-- Insert Data Into Bronze Products Table
INSERT INTO DataWarehouse.Bronze.Products
SELECT * FROM [Brazillian E-Commerce].dbo.olist_products_dataset$;

GO


-- Insert Data Into Bronze Products Reviews Table
INSERT INTO DataWarehouse.Bronze.Reviews
SELECT * FROM [Brazillian E-Commerce].dbo.Reviews$;

GO

-- Insert Data Into Bronze Seller Table
INSERT INTO DataWarehouse.Bronze.Seller
SELECT * FROM [Brazillian E-Commerce].dbo.olist_sellers_dataset$;

GO




