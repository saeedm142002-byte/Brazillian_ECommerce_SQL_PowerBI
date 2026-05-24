USE DataWarehouse


/*==================================
 Create Silver Customers Table
 ===================================*/
CREATE TABLE Silver.Customers(
	
	Customer_Id varchar(50) ,
	Customer_Unique_Id varchar(50) ,
	Customer_ZipCode INT ,
	Customer_City varchar(50) ,
	Customer_State varchar(50)
	

);
GO
/*==================================
Create Silver Geolocation Table
=====================================*/
CREATE TABLE Silver.Geolocation (
	GeoLocation_ZipCode Varchar(50) ,
	GeoLocation_Latitude varchar(50) ,
	GeoLocation_Langtitude varchar(50) ,
	GeoLocation_City varchar(50) ,
	GeoLocation_State varchar(50) ,
	

);

GO
/*===================================
 Create Silver Order Items Table
 ==================================*/
CREATE TABLE Silver.OrderItems (
	Order_Id varchar(50) ,
	OrderItem_Id INT ,
	Product_Id varchar(50) ,
	seller_id varchar(50) ,
	shipping_limit_date DateTime2 ,
	price DECIMAL(7,4) ,
	freight_value DECIMAL(7,4) 

);

GO

/*==================================== 
Create Silver Order Payment Table
======================================*/
CREATE TABLE Silver.Order_Payment (
	Order_Id varchar(50) ,
	payment_sequential INT ,
	payment_type varchar(50) ,
	payment_installments INT ,
	payment_value DECIMAL(7,4) 
	

);

GO
/*================================
 Create Silver Orders Table
 ===============================*/
CREATE TABLE Silver.Orders (
	Order_Id varchar(50) ,
	customer_id varchar(50) ,
	order_status varchar(50) ,
	order_purchase_timestamp DateTime2 ,
	order_approved_at DateTime2 ,
	order_delivered_carrier_date DateTime2 ,
	order_delivered_customer_date DateTime2 ,
	order_estimated_delivery_date DateTime2 
);

GO

/*=================================
-- Create Silver Products Table
=================================*/
CREATE TABLE Silver.Products (
	product_id varchar(50) ,
	product_category_name varchar(50) ,
	product_name_lenght INT ,
	product_description_lenght INT ,
	product_photos_qty INT ,
	product_weight_g DECIMAL(7,2) ,
	product_length_cm DECIMAL(7,2) ,
	product_height_cm DECIMAL(7,2) ,
	product_width_cm DECIMAL(7,2) 
);

GO

/*==============================
-- Create Silver Seller Table
==============================*/
CREATE TABLE Silver.Seller (
	seller_id varchar(50) ,
	seller_zipcode INT ,
	seller_city varchar(50) ,
	seller_state varchar(50) 
);

GO

/*=============================================
-- Create Silver English Category Name Table
===============================================*/
CREATE TABLE Silver.Product_CategoryNameTranslation (
	product_category_name varchar(50) ,
	product_category_name_english varchar(50) 
);

GO

/*==============================
-- Create Silver Reviews Table
===============================*/
CREATE TABLE Silver.Reviews (
	review_id varchar(50) ,
	order_id varchar(50) ,
	review_score DECIMAL(2,1) ,
	review_creation_date DATETIME2 ,
	review_answer_timestamp DATETIME2 
);

GO

/*===================================
-- Create Silver Closed Deals Table
===================================*/
CREATE TABLE Silver.Closed_Deals (
	mql_id varchar(50) ,
	seller_id varchar(50) ,
	sdr_id varchar(50) ,
	sr_id varchar(50) ,
	won_date DATETIME2 ,
	business_segment varchar(50) ,
	lead_type varchar(50) ,
	lead_behaviour_profile varchar(50) ,
	has_company varchar(50) ,
	has_gtin varchar(50) ,
	average_stock varchar(50) ,
	business_type varchar(50) ,
	declared_product_catalog_size DECIMAL(7,2) ,
	declared_monthly_revenue DECIMAL(12,2) 
);

GO

/*=================================================
-- Create Silver Marketing Qualified Leads Table
==================================================*/
CREATE TABLE Silver.Marketing_Qualified_Leads (
	mql_id varchar(50) ,
	first_contact_date DATETIME2 ,
	landing_page_id varchar(50) ,
	origin varchar(50) 
);

GO








/*==============================================
Copy Data from Row Data to Bronze Layer in DWH
================================================*/

/*==================================================================
-- Insert Data Into Silver Customers Table & edit column data type
-- Customers Table
====================================================================*/
INSERT INTO DataWarehouse.Silver.Customers
SELECT DISTINCT
	Customer_Id ,
	Customer_Unique_Id ,
	CAST(Customer_ZipCode as int) as Customer_ZipCode ,
	Customer_City ,
	Customer_State
FROM DataWarehouse.Bronze.Customers


GO


/*====================================================================
-- Insert Data Into Silver Closed Deal Table & edit columns data type
-- Closed Deal Table
=====================================================================*/
INSERT INTO DataWarehouse.Silver.Closed_Deals
SELECT 
	mql_id ,
	seller_id ,
	sdr_id,
	sr_id ,
	TRY_CAST(won_date as datetime2) as won_date ,
	business_segment ,
	lead_type,
	lead_behaviour_profile ,
	has_company ,
	has_gtin ,
	average_stock ,
	business_type ,
	TRY_CAST(declared_product_catalog_size as DECIMAL(7,2)) as declared_product_catalog_size ,
	TRY_CAST(declared_monthly_revenue as DECIMAL(12,2)) as declared_monthly_revenue 
FROM DataWarehouse.Bronze.Closed_Deals;

GO

/*==========================================
-- Insert Data Into Silver GeoLoction Table 

-- GeoLoction Table
===========================================*/
INSERT INTO DataWarehouse.Silver.Geolocation
SELECT Distinct
	GeoLocation_ZipCode  ,
	GeoLocation_Latitude ,
	GeoLocation_Langtitude ,
	GeoLocation_City ,
	GeoLocation_State 
	

FROM DataWarehouse.Bronze.Geolocation;

GO


/*=======================================================================
-- Insert Data Into Silver  Marketing Qualified Leads Table & cast column data type 
-- Marketing Qualified Leads Table
=======================================================================*/
INSERT INTO DataWarehouse.Silver.Marketing_Qualified_Leads
SELECT 
		mql_id ,
		TRY_CAST(first_contact_date as datetime2) as first_contact_date ,
		landing_page_id ,
		origin

FROM DataWarehouse.Bronze.Marketing_Qualified_Leads;


GO



/*=======================================================================

-- Insert Data Into Silver Order Payments Table & cast columns data type 

-- Order Payments table
=======================================================================*/
INSERT INTO DataWarehouse.Silver.Order_Payment
SELECT 
	Order_Id ,
	TRY_CAST(payment_sequential as INT) as Payment_Sequential  ,
	payment_type ,
	TRY_CAST(payment_installments as INT) as payment_installments  ,
	TRY_CAST(payment_value as DECIMAL(7,4)) as payment_value 
FROM DataWarehouse.Bronze.Order_Payment





GO





/*=====================================================================
-- Insert Data Into Silver  Order Items Table & cast columns data type 

-- Order Items Table
======================================================================*/
INSERT INTO DataWarehouse.Silver.OrderItems
SELECT 
	Order_Id ,
	CAST(OrderItem_Id as INT) as OrderItem_Id  ,
	Product_Id ,
	seller_id ,
	TRY_CAST(shipping_limit_date as DATETIME2) as Shipping_Limit_Date ,
	TRY_CAst(price as DECIMAL(7,4)) as Price  ,
	TRY_CAst(freight_value as  DECIMAL(7,4)) as Freight_Value


FROM DataWarehouse.Bronze.OrderItems
WHERE price is not null and freight_value is not null and shipping_limit_date is not null;

GO



/*================================================================
-- Insert Data Into Silver Orders Table & cast columns data type 

-- Orders Table
=================================================================*/
INSERT INTO DataWarehouse.Silver.Orders
SELECT DISTINCT
	Order_Id ,
	customer_id ,
	order_status ,
	TRY_CAST(order_purchase_timestamp as datetime2) as Order_Purchase_Time ,
	TRY_CAST(order_approved_at as datetime2) as Order_Approved_At ,
	TRY_CAST(order_delivered_carrier_date as datetime2) as Order_Delivered_Carrier_Date ,
	TRY_CAST(order_delivered_customer_date as datetime2) as Order_Delivered_Customer_Date ,
	TRY_CAST(order_estimated_delivery_date as datetime2) as Order_Estimated_Delivery_Date

FROM DataWarehouse.Bronze.Orders
WHERE order_purchase_timestamp is not null and order_approved_at is not null
and order_delivered_carrier_date is not null and order_delivered_customer_date is not null
and order_estimated_delivery_date is not null;

GO

/*===========================================================
-- Insert Data Into Silver Category Names In English Table 

-- Category Names In English Table
=============================================================*/
INSERT INTO DataWarehouse.Silver.Product_CategoryNameTranslation
SELECT * FROM DataWarehouse.Bronze.Product_CategoryNameTranslation;

GO

/*================================================================
-- Insert Data Into Silver Products Table & cast columns data type 

-- Products Table
=================================================================*/
INSERT INTO DataWarehouse.Silver.Products
SELECT DISTINCT
	product_id ,
	product_category_name ,
	TRY_CAST(product_name_lenght as INT) as Product_NameLenght ,
	TRY_CAST(product_description_lenght as INT) as Product_Description ,
	TRY_CAST(product_photos_qty as INT) as Product_Photos_Qty ,
	TRY_CAST(product_weight_g as decimal(7,2)) as Product_Weight_GM ,
	TRY_CAST(product_length_cm as decimal(7,2)) as Product_Length_CM ,
	TRY_CAST(product_height_cm as decimal(7,2)) as Product_Height_CM ,
	TRY_CAST(product_width_cm as decimal(7,2)) as Product_Width_CM

FROM DataWarehouse.Bronze.Products
WHERE product_name_lenght is not null and product_description_lenght is not null
and product_photos_qty is not null and product_weight_g is not null
and product_length_cm is not null and product_height_cm is not null
and product_width_cm is not null;

GO




/*===========================================================================
-- Insert Data Into Silver Products Reviews Table & cast columns data type 

-- Products Reviews Table
=======================================================================*/
INSERT INTO DataWarehouse.Silver.Reviews
SELECT Distinct
	review_id ,
	order_id ,
	TRY_CAST(review_score as decimal(2,1)) as Review_Score ,
	TRY_CAST(review_creation_date as datetime2) as Review_Creation_Date ,
	TRY_CAST(review_answer_timestamp as datetime2) as Review_Answer_Time 

FROM DataWarehouse.Bronze.Reviews
WHERE review_score is not null and review_creation_date is not null
and review_answer_timestamp is not null;

GO


/*===============================================================
-- Insert Data Into Silver Seller Table & cast columns data type 

-- Seller Table
==================================================================*/
INSERT INTO DataWarehouse.Silver.Seller
SELECT Distinct 
	seller_id ,
	TRY_CAST(seller_zipcode as INT) as Seller_ZipCode ,
	seller_city ,
	seller_state
FROM DataWarehouse.Bronze.Seller
WHERE seller_zipcode is not null;

/*
==================================================================
==================================================================
Now We will begin data cleansing Process
==================================================================
==================================================================
*/


/*
===================
Customers Table
===================
*/
-- Duplicate Value
select 
	Customer_Id ,
	Count(customer_Id) 'Counts'
from Silver.Customers
group by Customer_Id
having Count(customer_Id) >1

-- NULL Values

select
	*
	from Silver.Customers
	where Customer_Id is null


-- TRIM Categorical Values

update Silver.Customers
set   
customer_City = LOWER(TRIM(Customer_City))



/*
===================
Geolocation Table
===================
*/


select
	*
	from Silver.Geolocation
	where GeoLocation_ZipCode is null


select distinct
	Geolocation_city
	from Silver.Geolocation
	order by GeoLocation_City


update silver.Geolocation
set GeoLocation_City = LOWER(TRIM(GeoLocation_City))




UPDATE Silver.Geolocation
SET GeoLocation_City = 
    CASE 
		WHEN GeoLocation_City LIKE '%³%­' THEN REPLACE(GeoLocation_City, '³', 'o')
		WHEN GeoLocation_City LIKE '%-%­' THEN REPLACE(GeoLocation_City, '-', 'i')
		WHEN GeoLocation_City LIKE '%ھ­­%' THEN REPLACE(GeoLocation_City, 'ھ', '')
		WHEN GeoLocation_City LIKE '%؛%' THEN REPLACE(GeoLocation_City, '؛', '')
		WHEN GeoLocation_City LIKE '%أ%' THEN REPLACE(GeoLocation_City, 'أ', '')
		WHEN GeoLocation_City LIKE '%،%' THEN REPLACE(GeoLocation_City, '،', '')
		WHEN GeoLocation_City LIKE '%©%' THEN REPLACE(GeoLocation_City, '©', '')
		WHEN GeoLocation_City LIKE '%...%' THEN REPLACE(GeoLocation_City, '...', '')
        WHEN GeoLocation_City LIKE '%*%' THEN REPLACE(GeoLocation_City, '*', '')
		WHEN GeoLocation_City LIKE '%"%' THEN REPLACE(GeoLocation_City, '"', '')
        WHEN GeoLocation_City LIKE '%4o.%' THEN REPLACE(GeoLocation_City, '4o.', '')
		WHEN GeoLocation_City LIKE '%4آ؛%' THEN REPLACE(GeoLocation_City, '4آ؛', '')
		WHEN GeoLocation_City = 'abadiأ¢nia' THEN REPLACE(GeoLocation_City, 'abadiأ¢nia', 'abadiania')
		WHEN GeoLocation_City = 'abaetأ©' THEN REPLACE(GeoLocation_City, 'abaetأ©', 'abaet')
		WHEN GeoLocation_City = 'abarأ©' THEN REPLACE(GeoLocation_City, 'abarأ©', 'abare')
		WHEN GeoLocation_City = '4آ centenario' THEN REPLACE(GeoLocation_City, '4آ centenario', 'centenario')
		WHEN GeoLocation_City = 'آ´teresopolis' THEN REPLACE(GeoLocation_City, 'آ´teresopolis', 'teresopolis')
		WHEN GeoLocation_City LIKE '%ھ%' THEN REPLACE(GeoLocation_City, 'ھ', '')
		WHEN GeoLocation_City LIKE '%£%' THEN REPLACE(GeoLocation_City, '£', 'a')
		WHEN GeoLocation_City LIKE '% f %' THEN REPLACE(GeoLocation_City, ' f ', ' fe ')
		WHEN GeoLocation_City LIKE '%?­%' THEN REPLACE(GeoLocation_City, '?', 'a ')
		WHEN GeoLocation_City LIKE '%2­%' THEN REPLACE(GeoLocation_City, '2', '')
		WHEN GeoLocation_City LIKE '%§­%' THEN REPLACE(GeoLocation_City, '§', 'c')
		WHEN GeoLocation_City LIKE '%¢­%' THEN REPLACE(GeoLocation_City, '¢', 'a')
		WHEN GeoLocation_City LIKE '%d  oeste­%' THEN REPLACE(GeoLocation_City, 'd  oeste', 'd''oeste')
		WHEN GeoLocation_City = 'praia grande (fund£o) - distrito­' THEN REPLACE(GeoLocation_City, 'praia grande (fund£o) - distrito', 'praia grande')
        ELSE LOWER(TRIM(GeoLocation_City))
    END;

	UPDATE Silver.Geolocation
SET GeoLocation_City = REPLACE(GeoLocation_City, '§', 'c')
WHERE GeoLocation_City LIKE '%§%';


UPDATE Silver.Geolocation
SET GeoLocation_City = REPLACE(GeoLocation_City, '³', 'o')
WHERE GeoLocation_City LIKE '%³%';

UPDATE Silver.Geolocation
SET GeoLocation_City = REPLACE(GeoLocation_City, '¢', 'a')
WHERE GeoLocation_City LIKE '%¢%';

UPDATE Silver.Geolocation
SET GeoLocation_City = REPLACE(GeoLocation_City, NCHAR(173), 'i')
WHERE GeoLocation_City LIKE '%' + NCHAR(173) + '%';

UPDATE Silver.Geolocation
SET GeoLocation_City = REPLACE(GeoLocation_City, '¼', 'u')
WHERE GeoLocation_City LIKE '%¼%';


UPDATE Silver.Geolocation
SET GeoLocation_City = REPLACE(GeoLocation_City, 'saآao paulo', 'sao paulo')
WHERE GeoLocation_City = 'saآao paulo';



UPDATE Silver.Geolocation
SET GeoLocation_City = REPLACE(GeoLocation_City, 'sirinham', 'sirinhaem')
WHERE GeoLocation_City = 'sirinham';




select distinct
	GeoLocation_State
	from Silver.Geolocation
	order by GeoLocation_State


UPDATE Silver.Geolocation
SET GeoLocation_State = REPLACE(GeoLocation_State, ' bahia, brasil",BA', 'BA')
WHERE GeoLocation_State = ' bahia, brasil",BA';


UPDATE Silver.Geolocation
SET GeoLocation_State = REPLACE(GeoLocation_State, ' rio de janeiro, brasil",RJ', 'RJ')
WHERE GeoLocation_State = ' rio de janeiro, brasil",RJ';

UPDATE Silver.Geolocation
SET GeoLocation_State = TRIM(GeoLocation_State)





/*
===================
Order Payment Table
===================
*/

select Distinct
	payment_type
	from Silver.Order_Payment
	order by payment_type


UPDATE Silver.Order_Payment
SET payment_type = REPLACE(payment_type, '_', ' ')
WHERE payment_type LIKE '%_%';


select

	payment_type ,
	count(order_id) 'Counts'
	from
		(
			select 
				*
			from Silver.Order_Payment
			where payment_value is null

		) as t
	group by payment_type
	Order by count(order_id) desc



/*
===================
Order Items Table
===================
*/

SELECT
	*
FROM SILVER.OrderItems
WHERE freight_value IS NULL


update silver.OrderItems
set Order_Id = TRIM(Order_Id) ,
	seller_id = TRIM(seller_id) ,
	Product_Id = TRIM(Product_Id)


/*
===================
Orders Table
===================
*/

select 
	Order_Id ,
	count(order_id) 'Counts'
	from silver.Orders
	group by Order_Id
	order by count(order_id) desc



/*
========================================
Category English name translation Table
========================================
*/


select
	product_category_name,
	count(product_category_name) 'Counts'
	from Silver.Product_CategoryNameTranslation
	group by product_category_name
	order by product_category_name desc



update silver.Product_CategoryNameTranslation
set product_category_name = REPLACE(product_category_name , '_' , ' ') ,
	product_category_name_english = REPLACE(product_category_name_english
	,  '_' , ' ' )



/*
========================================
Products Table
========================================
*/

update silver.Products
set product_category_name = REPLACE(product_category_name , '_' , ' ') 

select
	p.[product_id]
      ,p.[product_category_name]
	  ,e.product_category_name_english
      ,p.[product_name_lenght]
      ,p.[product_description_lenght]
      ,p.[product_photos_qty]
      ,p.[product_weight_g]
      ,p.[product_length_cm]
      ,p.[product_height_cm]
      ,p.[product_width_cm]
	from silver.Products p
	inner join
	silver.Product_CategoryNameTranslation e
	on p.product_category_name = e.product_category_name


	/*
========================================
seller Table
========================================
*/

select distinct
	seller_city
	from silver.Seller
	order by seller_city


select 
	*
	from silver.Seller
	where seller_zipcode = '22790'



select
 seller_city
 from silver.Seller
 where seller_city LIKE '%janeiro%'

 update silver.Seller
 set seller_city = 'rio de janeiro'
 where seller_city = 'rio de janeiro \rio de janeiro' or 
 seller_city = 'rio de janeiro / rio de janeiro'
 or seller_city = 'rio de janeiro, rio de janeiro, brasil'
 or seller_city = '4482255'



 UPDATE Silver.Seller
SET seller_city =
CASE

    -- Angra dos Reis
    WHEN LOWER(seller_city) = 'angra dos reis rj'
        THEN 'angra dos reis'

    -- Balneário Camboriú
    WHEN LOWER(seller_city) IN (
        'balenario camboriu',
        'balneario camboriu'
    )
        THEN 'balneario camboriu'

    -- Cariacica
    WHEN LOWER(seller_city) = 'cariacica / es'
        THEN 'cariacica'

    -- Jacareí
    WHEN LOWER(seller_city) = 'jacarei / sao paulo'
        THEN 'jacarei'

    -- Lages
    WHEN LOWER(seller_city) = 'lages - sc'
        THEN 'lages'

    -- Mogi das Cruzes
    WHEN LOWER(seller_city) = 'mogi das cruzes / sp'
        THEN 'mogi das cruzes'

    -- Novo Hamburgo
    WHEN LOWER(seller_city) = 'novo hamburgo, rio grande do sul, brasil'
        THEN 'novo hamburgo'

    -- Paraíba do Sul
    WHEN LOWER(seller_city) = 'paraiba do sul'
        THEN 'paraiba do sul'

    -- Paraíso do Sul
    WHEN LOWER(seller_city) = 'paraiso do sul'
        THEN 'paraiso do sul'

    -- Pinhais
    WHEN LOWER(seller_city) = 'pinhais/pr'
        THEN 'pinhais'

    -- Ribeirão Preto
    WHEN LOWER(seller_city) IN (
        'ribeirao preto / sao paulo',
        'ribeirao preto',
        'ribeirao pretp',
        'riberao preto'
    )
        THEN 'ribeirao preto'

    -- Santa Bárbara d'Oeste
    WHEN LOWER(seller_city) IN (
        'santa barbara d oeste',
        'santa barbara d''oeste',
        'santa barbara dآ´oeste'
    )
        THEN 'santa barbara d''oeste'

    -- Santa Maria
    WHEN LOWER(seller_city) = 'santa maria'
        THEN 'santa maria'

    -- Santa Maria da Serra
    WHEN LOWER(seller_city) = 'santa maria da serra'
        THEN 'santa maria da serra'

    -- Santa Rosa
    WHEN LOWER(seller_city) = 'santa rosa'
        THEN 'santa rosa'

    -- Santa Rosa de Viterbo
    WHEN LOWER(seller_city) = 'santa rosa de viterbo'
        THEN 'santa rosa de viterbo'

    -- Santo André
    WHEN LOWER(seller_city) = 'santo andre/sao paulo'
        THEN 'santo andre'

    -- São Paulo
    WHEN LOWER(seller_city) IN (
        'sao  paulo',
        'sao paluo',
        'sao paulo',
        'sao paulo - sp',
        'sao paulo / sao paulo',
        'sao paulo sp',
        'sao paulop',
        'sao pauo',
        'saجƒo paulo',
        'sp',
        'sp / sp'
    )
        THEN 'sao paulo'

    -- São Pedro
    WHEN LOWER(seller_city) = 'sao pedro'
        THEN 'sao pedro'

    -- São Pedro da Aldeia
    WHEN LOWER(seller_city) = 'sao pedro da aldeia'
        THEN 'sao pedro da aldeia'

    -- São Sebastião
    WHEN LOWER(seller_city) IN (
        'sao sebastiao',
        'sao sebastiao da grama/sp'
    )
        THEN 'sao sebastiao'

    -- São Bernardo do Campo
    WHEN LOWER(seller_city) IN (
        'sbc',
        'sbc/sp'
    )
        THEN 'sao bernardo do campo'

    -- Taboão da Serra
    WHEN LOWER(seller_city) IN (
        'tabao da serra',
        'taboao da serra'
    )
        THEN 'taboao da serra'

    -- Invalid Email Value
    WHEN LOWER(seller_city) = 'vendas@creditparts.com.br'
        THEN NULL

    ELSE seller_city

END;

UPDATE Silver.Seller
SET seller_city =
CASE

    -- Andirá
    WHEN LOWER(seller_city) = 'andira-pr'
        THEN 'andira'

    -- Auriflama
    WHEN LOWER(seller_city) = 'auriflama/sp'
        THEN 'auriflama'

    -- Barbacena
    WHEN LOWER(seller_city) = 'barbacena/ minas gerais'
        THEN 'barbacena'

    -- Belo Horizonte
    WHEN LOWER(seller_city) IN (
        'belo horizont',
        'belo horizonte'
    )
        THEN 'belo horizonte'

    -- Brasília
    WHEN LOWER(seller_city) IN (
        'brasilia',
        'brasilia df'
    )
        THEN 'brasilia'

    -- Campo Largo
    WHEN LOWER(seller_city) = 'campo largo'
        THEN 'campo largo'

    -- Campo Magro
    WHEN LOWER(seller_city) = 'campo magro'
        THEN 'campo magro'

    -- Campo Mourão
    WHEN LOWER(seller_city) = 'campo mourao'
        THEN 'campo mourao'

    -- Carapicuíba
    WHEN LOWER(seller_city) = 'carapicuiba / sao paulo'
        THEN 'carapicuiba'

    -- Cascavel
    WHEN LOWER(seller_city) IN (
        'cascavael',
        'cascavel'
    )
        THEN 'cascavel'

    -- Ferraz de Vasconcelos
    WHEN LOWER(seller_city) IN (
        'ferraz de  vasconcelos',
        'ferraz de vasconcelos'
    )
        THEN 'ferraz de vasconcelos'

    -- Florianópolis
    WHEN LOWER(seller_city) IN (
        'floranopolis',
        'florianopolis'
    )
        THEN 'florianopolis'

    -- Formiga
    WHEN LOWER(seller_city) = 'formiga'
        THEN 'formiga'

    -- Formosa
    WHEN LOWER(seller_city) = 'formosa'
        THEN 'formosa'

    -- Mauá
    WHEN LOWER(seller_city) = 'maua/sao paulo'
        THEN 'maua'

    -- Mogi das Cruzes
    WHEN LOWER(seller_city) IN (
        'mogi das cruses',
        'mogi das cruzes'
    )
        THEN 'mogi das cruzes'

    -- São José do Rio Preto
    WHEN LOWER(seller_city) = 's jose do rio preto'
        THEN 'sao jose do rio preto'

    -- Santa Maria
    WHEN LOWER(seller_city) = 'santa maria'
        THEN 'santa maria'

    -- Santa Maria da Serra
    WHEN LOWER(seller_city) = 'santa maria da serra'
        THEN 'santa maria da serra'

    ELSE seller_city

END;


select distinct
	seller_state
	from silver.Seller
	order by seller_state






/*
========================================
Closed Deals Table
========================================
*/
use DataWarehouse

select distinct 
	business_segment
from silver.Closed_Deals
order by business_segment 



select
	*
	from Silver.Closed_Deals
	where [Marketing Qualified Lead] =
	(
select
	[Marketing Qualified Lead]
from Silver.Closed_Deals
where business_segment = ' '
)



update Silver.Closed_Deals
set business_segment =
	case
		when business_segment = ' ' then  'unknown' 
		
		else TRIM(business_segment)
		end 




update Silver.Closed_Deals
set business_segment =
	case
		when business_segment LIKE '%_%' then  REPLACE(business_segment , '_' , ' ') 
		
		else TRIM(business_segment)
		end 


select distinct 
	lead_type
from silver.Closed_Deals
order by lead_type 


update Silver.Closed_Deals
set lead_type =
	case
		when lead_type = ' ' then  'unknown' 
		
		else TRIM(lead_type)
		end 


update Silver.Closed_Deals
set lead_type =
	case
		when lead_type LIKE '%_%' then  REPLACE(lead_type , '_' , ' ') 
		
		else TRIM(lead_type)
		end 







select distinct 
	lead_behaviour_profile
from silver.Closed_Deals
order by lead_behaviour_profile 


update Silver.Closed_Deals
set lead_behaviour_profile =
	case
		when lead_behaviour_profile = ' ' then  'unknown' 
		
		else TRIM(lead_behaviour_profile)
		end 


update Silver.Closed_Deals
set lead_behaviour_profile =
	case
		when lead_behaviour_profile LIKE '%"%' then  REPLACE(lead_behaviour_profile , '"' , '') 
		
		else TRIM(lead_behaviour_profile)
		end 








-- has_company

select distinct 
	has_company
from silver.Closed_Deals
order by has_company 


update Silver.Closed_Deals
set has_company =
	case
		when has_company = ' ' then  'unknown' 
		
		else TRIM(has_company)
		end 


select
	*
	from silver.Closed_Deals
	where has_company = 'cat"' or has_company = 'wolf"'


update Silver.Closed_Deals
set has_company =
	case
		when has_company LIKE '%"%' then  REPLACE(has_company , '"' , '') 
		
		else TRIM(has_company)
		end 

update Silver.Closed_Deals
set has_company =
	case
		when has_company = 'cat' then  REPLACE(has_company , 'cat' , 'True')
		when has_company = 'wolf' then REPLACE(has_company , 'wolf' , 'True')
		
		else TRIM(has_company)
		end 



-- has_gtin


select distinct 
	has_gtin
from silver.Closed_Deals
order by has_gtin


update Silver.Closed_Deals
set has_gtin =
	case
		when has_gtin = ' ' then  'unknown' 
		
		else TRIM(has_gtin)
		end 



-- average_stock


select distinct 
	average_stock
from silver.Closed_Deals
order by average_stock



update Silver.Closed_Deals
set average_stock =
	case
		when average_stock = ' ' then  'unknown' 
		
		else TRIM(average_stock)
		end 


select 
	*
	from Silver.Closed_Deals
	where average_stock = 'False' or average_stock = 'True'


update Silver.Closed_Deals
set average_stock =
	case
		when average_stock = 'True' then  'unknown'
		when average_stock = 'False' then  'unknown'
		
		else TRIM(average_stock)
		end 



-- business_type

select distinct 
	business_type
from silver.Closed_Deals
order by business_type


select 
	*
	from Silver.Closed_Deals
	where business_type = '200+' or business_type = '50-200'
	or business_type = '5-20'



update Silver.Closed_Deals
set average_stock =
	case
		when business_type = '200+' then  '200+'
		when business_type = '50-200' then  '50-200'
		when business_type = '5-20' then  '5-20'
		
		else TRIM(average_stock)
		end 


update Silver.Closed_Deals
set business_type =
	case
		when business_type = '200+' then  'unknown'
		when business_type = '50-200' then  'unknown'
		when business_type = '5-20' then  'unknown'
		
		else TRIM(business_type)
		end 

update Silver.Closed_Deals
set business_type =
	case
		when business_type = ' ' then  'unknown' 
		
		else TRIM(business_type)
		end 

select distinct 
	business_type
from silver.Closed_Deals
order by business_type


-- declared product catalog size

select distinct 
	declared_product_catalog_size
from silver.Closed_Deals
order by declared_product_catalog_size

select 
	count(mql_id)
	from Silver.Closed_Deals
	where declared_product_catalog_size is null

-- declared_monthly_revenue

select distinct 
	declared_monthly_revenue
from silver.Closed_Deals
order by declared_monthly_revenue

select 
	count(mql_id)
	from Silver.Closed_Deals
	where declared_monthly_revenue = 0.00










select
	
	count([Marketing Qualified Lead])
	from Silver.Closed_Deals




update silver.Closed_Deals
set has_gtin = 'UNKNOWN'
where has_gtin <> 'True' or has_gtin <> 'False'

	

select 
	*
	from Silver.Closed_Deals
	where has_company = 'cat' or has_company = 'wolf'
	


select
	count([Marketing Qualified Lead])
	from Silver.Closed_Deals
	where has_gtin = ' '

ALTER TABLE Silver.Closed_Deals
DROP COLUMN has_gtin;



select  
	lead_type ,
	count(lead_type) 'Counts'
from silver.Closed_Deals
group by lead_type
order by lead_type


select 
	*
	from Silver.Closed_Deals
	where lead_type = ' '



select  
	lead_behaviour_profile ,
	count(lead_behaviour_profile) 'Counts'
from silver.Closed_Deals
group by lead_behaviour_profile
order by lead_behaviour_profile


select  
	average_stock ,
	count(average_stock) 'Counts'
from silver.Closed_Deals
group by average_stock
order by average_stock


update Silver.Closed_Deals
set average_stock = REPLACE(average_stock , 'True' , 'unknown') 


select  
	business_type ,
	count(business_type) 'Counts'
from silver.Closed_Deals
group by business_type
order by business_type


select
	*
	from Silver.Closed_Deals
	where business_type = '200+' or business_type = '50-200'
	or business_type = '5-20' 

update Silver.Closed_Deals
set average_stock =
	case
		when business_type = '5-20' then  '5-20' 
		when business_type = '200+' then '200+'
		when business_type = '50-200' then '50-200'
		else TRIM(average_stock)
		end  



update Silver.Closed_Deals
set business_type =
	case
		when business_type = '5-20' then  'unknown' 
		when business_type = '200+' then 'unknown'
		when business_type = '50-200' then 'unknown'
		when business_type = ' ' then 'unknown'
		else TRIM(business_type)
		end 


select  
	average_stock ,
	count(average_stock) 'Counts'
from silver.Closed_Deals
group by average_stock
order by average_stock



update Silver.Closed_Deals
set average_stock =
	case
		when average_stock = ' ' then  'unknown' 
		
		else TRIM(average_stock)
		end 


select  
	lead_behaviour_profile ,
	count(lead_behaviour_profile) 'Counts'
from silver.Closed_Deals
group by lead_behaviour_profile
order by lead_behaviour_profile


update Silver.Closed_Deals
set lead_behaviour_profile =
	case
		when lead_behaviour_profile = ' ' then  'unknown' 
		
		else TRIM(lead_behaviour_profile)
		end 



select  
	declared_monthly_revenue ,
	count(declared_monthly_revenue) 'Counts'
from silver.Closed_Deals
group by declared_monthly_revenue
order by declared_monthly_revenue




/*
=======================================
Marketing Qualifies Lead Table
=======================================
*/

select  
	origin ,
	count(origin) 'Counts'
from silver.Marketing_Qualified_Leads
group by origin
order by origin




update Silver.Marketing_Qualified_Leads
set origin =
	case
		when origin LIKE '%_%' then  REPLACE(origin , '_' , ' ')
		
		else TRIM(origin)
		end 

update Silver.Marketing_Qualified_Leads
set origin =
	case
		when origin = ' ' then  'unknown'
		
		else TRIM(origin)
		end
		


select  
	origin ,
	count(origin) 'Counts'
from silver.Marketing_Qualified_Leads
group by origin
order by origin


select  
	mql_id ,
	count(mql_id) 'Counts'
from silver.Marketing_Qualified_Leads
group by mql_id
order by mql_id desc




-- create enrichment 
use DataWarehouse


CREATE TABLE Silver.EnrichmentProducts (
	product_id varchar(50) ,
	product_category_name varchar(50) ,
	product_category_Ename varchar(50) ,
	product_name_lenght INT ,
	product_description_lenght INT ,
	product_photos_qty INT ,
	product_weight_g DECIMAL(7,2) ,
	product_length_cm DECIMAL(7,2) ,
	product_height_cm DECIMAL(7,2) ,
	product_width_cm DECIMAL(7,2) 
);



SELECT 
    p.*,
    t.product_category_name_english
INTO Silver.EnrichmentProducts
FROM Silver.Products p
LEFT JOIN Silver.Product_CategoryNameTranslation t
    ON p.product_category_name = t.product_category_name;


select distinct
	
	count(product_category_name_english) 'Counts'
	from Silver.EnrichmentProducts
	where product_category_name_english is null




select 
	*
	from Silver.EnrichmentProducts
	where product_category_name_english is null


update Silver.EnrichmentProducts
set product_category_name_english =
	case
		when product_category_name = 'pc gamer' then  'pc gamer'
		
		else TRIM(product_category_name_english)
		end


update Silver.EnrichmentProducts
set product_category_name_english =
	case
		when product_category_name = 'portateis cozinha e preparadores de alimentos' 
		then  'Kitchen Appliances & Food Processors'
		
		else TRIM(product_category_name_english)
		end



/*
nulls check
*/

select distinct
	business_segment 

	from Silver.Closed_Deals

update Silver.Closed_Deals
set business_segment =
	case
		when business_segment = 'unknown' then  'other'
		
		else TRIM(business_segment)
		end






	select distinct
	
	lead_type

	from Silver.Closed_Deals


update Silver.Closed_Deals
set lead_type =
	case
		when lead_type = 'unknown' then  'other'
		
		else TRIM(lead_type)
		end






	select distinct
	
	lead_behaviour_profile 

	from Silver.Closed_Deals

	update Silver.Closed_Deals
	set lead_behaviour_profile =
	case
		when lead_behaviour_profile = 'unknown' then  'other'
		
		else TRIM(lead_behaviour_profile)
		end










	select distinct
	
	has_company 
	

	from Silver.Closed_Deals




	select distinct
	
	has_gtin 
	

	from Silver.Closed_Deals




	select distinct
	
	average_stock 

	from Silver.Closed_Deals


	select distinct
	
	business_type 

	from Silver.Closed_Deals


		update Silver.Closed_Deals
		set business_type =
		case
			when business_type = 'unknown' then  'other'
		
			else TRIM(business_type)
			end


			/*================================================

			*/


	select distinct
	
	payment_type 

	from Silver.Order_Payment


	update Silver.Order_Payment
		set payment_type =
		case
			when payment_type = 'not defined' then  'unknown'
		
			else TRIM(payment_type)
			end



select
	mql_id , 
	count(mql_id) 'Counts'
	from Silver.Marketing_Qualified_Leads
	group by mql_id
	order by count(mql_id) desc









	


	USE DataWarehouse;





/*========================================================
    Add freight_value & shipping_limit_date to Orders
========================================================*/


-- Get freight_value per order
SELECT 
    o.order_id,
    MAX(oi.freight_value) AS 'freight_value'
FROM Silver.Orders o
LEFT JOIN Silver.OrderItems oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id;



-- Count total orders
SELECT 
    COUNT(order_id) AS 'Counts'
FROM Silver.Orders;



-- Check duplicate order_ids in Orders table
SELECT
    order_id,
    COUNT(order_id) AS 'Counts'
FROM Silver.Orders
GROUP BY order_id
ORDER BY COUNT(order_id) DESC;



-- Add freight_value column to Orders table
ALTER TABLE Silver.Orders
ADD freight_value DECIMAL(7,4);



-- Add shipping_limit_date column to Orders table
ALTER TABLE Silver.Orders
ADD shipping_limit_date DATETIME2;



-- Update freight_value in Orders table
UPDATE o
SET o.freight_value = x.freight_value
FROM Silver.Orders o
JOIN (
        SELECT 
            order_id,
            MAX(freight_value) AS freight_value
        FROM Silver.OrderItems
        GROUP BY order_id
     ) x
ON o.order_id = x.order_id;



-- Update shipping_limit_date in Orders table
UPDATE o
SET o.shipping_limit_date = x.shipping_limit_date
FROM Silver.Orders o
JOIN (
        SELECT 
            order_id,
            MAX(shipping_limit_date) AS shipping_limit_date
        FROM Silver.OrderItems
        GROUP BY order_id
     ) x
ON o.order_id = x.order_id;







/*========================================================
    Check NULL prices in OrderItems
========================================================*/


-- Find orders with NULL prices
SELECT
    order_id,
    COUNT(order_id) AS 'Counts'
FROM Silver.OrderItems
WHERE price IS NULL
GROUP BY order_id
ORDER BY order_id DESC;



-- Get product categories with NULL prices
SELECT
    -- oi.Product_Id,
    eo.product_category_name_english
    -- oi.price
FROM Silver.OrderItems oi
JOIN Silver.EnrichmentProducts eo
    ON oi.Product_Id = eo.product_id
WHERE price IS NULL
GROUP BY eo.product_category_name_english;



-- Average price across all products
SELECT
    AVG(price)
FROM Silver.OrderItems;





/*========================================================
    Product Price Statistics
========================================================*/


-- Product price stats with median calculation
SELECT 
    ep.product_category_name_english,
    AVG(oi.price) AS avg_price,
    MIN(oi.price) AS Min_price,
    MAX(oi.price) AS Max_price,
    PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY oi.price)
        OVER (
            PARTITION BY ep.product_category_name_english
        ) AS median_price
FROM Silver.EnrichmentProducts ep
JOIN Silver.OrderItems oi
    ON ep.product_id = oi.Product_Id
WHERE price IS NOT NULL
GROUP BY ep.product_category_name_english;





/*========================================================
    Median Calculation using CTE
========================================================*/


-- Booooooooming

WITH MedianCalc AS (
    SELECT 
        ep.product_category_name_english,
        oi.price,
        PERCENTILE_CONT(0.5) 
            WITHIN GROUP (ORDER BY oi.price) 
            OVER (
                PARTITION BY ep.product_category_name_english
            ) AS median_price
    FROM Silver.EnrichmentProducts ep
    JOIN Silver.OrderItems oi
        ON ep.product_id = oi.Product_Id
    WHERE oi.price IS NOT NULL
)

SELECT 
    product_category_name_english,
    AVG(price)        AS avg_price,
    MIN(price)        AS Min_price,
    MAX(price)        AS Max_price,
    MAX(median_price) AS median_price
FROM MedianCalc
GROUP BY product_category_name_english
ORDER BY product_category_name_english;





/*========================================================
    Create Product Price Statistics View
========================================================*/


CREATE VIEW Silver.vw_ProductPriceStats AS

WITH MedianCalc AS (
    SELECT 
        ep.product_category_name_english,
        oi.price,
        PERCENTILE_CONT(0.5) 
            WITHIN GROUP (ORDER BY oi.price) 
            OVER (
                PARTITION BY ep.product_category_name_english
            ) AS median_price
    FROM Silver.EnrichmentProducts ep
    JOIN Silver.OrderItems oi
        ON ep.product_id = oi.Product_Id
    WHERE oi.price IS NOT NULL
)

SELECT 
    product_category_name_english,
    AVG(price)        AS avg_price,
    MIN(price)        AS Min_price,
    MAX(price)        AS Max_price,
    MAX(median_price) AS median_price
FROM MedianCalc
GROUP BY product_category_name_english;





/*========================================================
    Replace NULL prices with category median
========================================================*/


-- Preview rows before update
SELECT 
    oi.Product_Id,
    eo.product_category_name_english,
    oi.price AS current_price,
    stats.median_price AS will_be_replaced_with
FROM Silver.OrderItems oi
JOIN Silver.EnrichmentProducts eo 
    ON oi.Product_Id = eo.product_id
JOIN Silver.vw_ProductPriceStats stats 
    ON eo.product_category_name_english = stats.product_category_name_english
WHERE oi.price IS NULL;



-- Update NULL prices using category median
UPDATE oi
SET oi.price = stats.median_price
FROM Silver.OrderItems oi
JOIN Silver.EnrichmentProducts eo 
    ON oi.Product_Id = eo.product_id
JOIN Silver.vw_ProductPriceStats stats 
    ON eo.product_category_name_english = stats.product_category_name_english
WHERE oi.price IS NULL;





/*========================================================
    Check remaining NULL prices
========================================================*/


SELECT 
    oi.Order_Id,
    oi.price,
    o.order_status
FROM Silver.OrderItems oi 
LEFT JOIN Silver.Orders o
    ON oi.Order_Id = o.Order_Id
WHERE oi.price IS NULL;





/*========================================================
    Global Median Replacement for NULL prices
========================================================*/


-- Preview global median replacement
SELECT 
    Product_Id,
    price AS current_price,
    (
        SELECT MAX(median_val) 
        FROM (
                SELECT PERCENTILE_CONT(0.5) 
                       WITHIN GROUP (ORDER BY price) 
                       OVER () AS median_val
                FROM Silver.OrderItems
                WHERE price IS NOT NULL
             ) AS sub
    ) AS will_be_replaced_with
FROM Silver.OrderItems
WHERE price IS NULL;



-- Replace remaining NULL prices with global median
UPDATE Silver.OrderItems
SET price = (
    SELECT MAX(median_val) 
    FROM (
            SELECT PERCENTILE_CONT(0.5) 
                   WITHIN GROUP (ORDER BY price) 
                   OVER () AS median_val
            FROM Silver.OrderItems
            WHERE price IS NOT NULL
         ) AS sub
)
WHERE price IS NULL;





/*========================================================
    Validation & Data Quality Checks
========================================================*/


-- Check Closed_Deals records
SELECT
    COUNT(mql_id) AS 'Counts'
FROM Silver.Closed_Deals;
-- WHERE declared_product_catalog_size IS NULL



-- Check NULL payment values
SELECT
    *
FROM Silver.Order_Payment
WHERE payment_value IS NULL;



-- Count payment records
SELECT
    COUNT(*)
FROM Silver.Order_Payment;





/*========================================================
    Orders Table Preview
========================================================*/


USE DataWarehouse;

SELECT TOP 10 *
FROM Silver.Orders;





/*========================================================
    Orders Time Series View
========================================================*/


-- Order Time Series
CREATE VIEW OrdersTimeSeries AS

SELECT
    DATENAME(YEAR , o.order_purchase_timestamp)    AS 'Year',
    DATENAME(QUARTER , o.order_purchase_timestamp) AS 'Quarter',
    DATENAME(MONTH , o.order_purchase_timestamp)   AS 'Month',
    MONTH(o.order_purchase_timestamp)              AS 'MOnthNo',
    COUNT(o.Order_id)                              AS 'Count of Orders',
    SUM(o.freight_value) + SUM(oi.price)           AS 'Total Revenue'
FROM Silver.Orders o
JOIN Silver.OrderItems oi
    ON o.Order_Id = oi.Order_Id
GROUP BY 
    DATENAME(YEAR , o.order_purchase_timestamp),
    DATENAME(QUARTER , o.order_purchase_timestamp),
    DATENAME(MONTH , o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY DATENAME(YEAR , o.order_purchase_timestamp);





/*========================================================
    Revenue Time Series Query
========================================================*/


SELECT
    DATENAME(YEAR , o.order_purchase_timestamp)    AS 'Year',
    DATENAME(QUARTER , o.order_purchase_timestamp) AS 'Quarter',
    DATENAME(MONTH , o.order_purchase_timestamp)   AS 'Month',
    MONTH(o.order_purchase_timestamp)              AS 'MOnthNo',
    SUM(o.freight_value) + SUM(oi.price)           AS 'Total Revenue'
FROM Silver.Orders o
JOIN Silver.OrderItems oi
    ON o.Order_Id = oi.Order_Id
GROUP BY 
    DATENAME(YEAR , o.order_purchase_timestamp),
    DATENAME(QUARTER , o.order_purchase_timestamp),
    DATENAME(MONTH , o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp);





/*========================================================
    Add customer_id to OrderItems
========================================================*/


-- Revenue by state

ALTER TABLE Silver.OrderItems
ADD customer_id VARCHAR(50);



-- Populate customer_id in OrderItems
UPDATE oi
SET oi.customer_id = o.customer_id
FROM Silver.OrderItems oi
JOIN Silver.Orders o
    ON oi.order_id = o.order_id;





/*========================================================
    Top Category Revenue View
========================================================*/


CREATE VIEW Top_Category_rev AS

SELECT
    p.product_category_name_english,
    SUM(oi.price) AS 'Total Revenue'
FROM Silver.EnrichmentProducts p
JOIN Silver.OrderItems oi
    ON p.product_id = oi.Product_Id
GROUP BY p.product_category_name_english;





/*========================================================
    State Revenue & Customer Distribution View
========================================================*/


CREATE VIEW State_Revenue_CstDis AS

SELECT
    c.customer_state,
    SUM(oi.price) AS 'Total Revenue',
    COUNT(c.customer_id) / CAST(
        (
            SELECT COUNT(customer_id) 
            FROM Silver.Customers
        ) AS DECIMAL(7,2)
    ) AS 'Cst Dis'
FROM Silver.Customers c
JOIN Silver.OrderItems oi
    ON c.Customer_Id = oi.customer_id
GROUP BY c.Customer_State;





/*========================================================
    Cities Orders & Revenue View
========================================================*/


CREATE VIEW Cities_Order_Rev AS

SELECT
    c.Customer_City,
    COUNT(o.Order_Id) AS 'Total Orders',
    SUM(oi.price)     AS 'Total Revenue'
FROM Silver.Customers c
JOIN Silver.Orders o
    ON c.Customer_Id = o.customer_id
JOIN Silver.OrderItems oi
    ON c.Customer_Id = oi.customer_id
GROUP BY c.Customer_City;





/*========================================================
    Payment Orders & Payment Value View
========================================================*/


CREATE VIEW pay_Orders_payValue AS

SELECT
    op.payment_type,
    COUNT(op.Order_Id)   AS 'Total Orders',
    SUM(op.Payment_value) AS 'Payment Value'
FROM Silver.Order_Payment op
GROUP BY op.payment_type;





/*========================================================
    Orders existing in OrderItems but missing in Orders so these havn't 
    any dates for orders
========================================================*/


CREATE VIEW null_Order_id_in_Orders AS

SELECT
    oi.*,
    o.order_purchase_timestamp
FROM Silver.Orders o
RIGHT JOIN Silver.OrderItems oi
    ON o.Order_id = oi.Order_id
WHERE o.Order_id IS NULL;