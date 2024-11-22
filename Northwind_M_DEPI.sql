use master;
go
-- Creating the database
create database Northwind;
go
use Northwind;
go

-- Creating the OrderItem table
create table OrderItem (
    OrderItemid int constraint pk_OrderItemid primary key,
	OrderId int constraint nn_OrderId not null,		
	ProductId int constraint nn_ProductId not null,
	UnitPrice decimal(10,2) constraint chk_unitprice check (UnitPrice >= 0),
	Quantity int constraint d_Quantity default 1 
);
go
-- Creating the Orders table
create table Orders (
   Orderid int constraint pk_orderid primary key,
   OrderDate date constraint nn_OrderDate not null
				  constraint chk_orderdate  check (OrderDate <= getdate()),
   OrderNumber int constraint nn_OrderNumber not null
                   constraint un_OrderNumber unique,
   CustomerId int constraint nn_CustomerId not null,
   TotalAmount decimal(10,2) constraint nn_TotalAmount not null,
   PriceVersion varchar(3)
); 
go
-- Creating the Customer table
create table Customer (
   Customerid int constraint pk_Customerid primary key,
   FirstName nvarchar(20) constraint nn_FirstName not null,
   LastName nvarchar(20) constraint nn_LastName not null,
   City varchar(20) constraint nn_City not null,
   Country varchar(20) constraint nn_Country not null,
   Phone nvarchar(20) constraint un_Phone unique
); 

go
-- Creating the Product table
create table Product (
   Productid int constraint pk_Productid primary key,
   ProductName nvarchar(50) constraint nn_ProductName not null,
   ProductCategory varchar(50),
   SupplierId int constraint nn_SupplierId not null ,
   NewPrice decimal(10,2) constraint chk_Product_NewPrice check (NewPrice >= 0),
   UnitCost decimal(10,2) constraint nn_UnitCost not null,
   Package nvarchar(50) constraint nn_Package not null,
   IsDiscontinued bit constraint nn_IsDiscontinued not null default 0,
   OldPrice decimal(10,2) constraint chk_Product_OldPrice check (OldPrice >= 0),
   constraint chk_nn_NewPrice_OldPrice check (OldPrice is not null  or NewPrice is not null)
); 
go

-- Creating the Supplier table
create table Supplier (
   Supplierid int constraint pk_Supplierid primary key,
   CompanyName nvarchar(50) constraint nn_CompanyName not null,
   ContactName varchar(50),
   City varchar(50) constraint nn_City not null,
   Country varchar(50) constraint nn_Country not null,
   Phone varchar(50) constraint nn_Phone not null,
   Fax varchar(50)
); 
go
--Data Modelling
alter table OrderItem
      add constraint fk_orderitem_orders foreign key (orderid) references orders(orderid) on delete cascade on update cascade,
	  constraint fk_orderitem_products foreign key (productid) references product(productid) on delete cascade on update cascade;
alter table orders
      add constraint fk_orders_customer foreign key (customerid) references customer(customerid);  
alter table product
      add constraint fk_product_supplier foreign key (supplierid) references supplier(supplierid); 

--Inserting data into the OrderItem table
bulk insert OrderItem
from 'C:\Users\Hassa_mjmdtbp\Desktop\last\Final\orderitem.csv'
with
( fieldterminator = ',',
  rowterminator = '\n',
  firstrow = 2 ); 

--Inserting data into the customer table
bulk insert customer
from 'C:\Users\Hassa_mjmdtbp\Desktop\last\Final\customer.csv'
with
( fieldterminator = ',',
  rowterminator = '\n',
  firstrow = 2); 

--Inserting data into the Supplier table
bulk insert supplier
from 'C:\Users\Hassa_mjmdtbp\Desktop\last\Final\supplier.csv'
with (
       fieldterminator = ',',
	   rowterminator = '\n',
	   firstrow = 2); 

--Inserting data into the Orders table
bulk insert Orders
from 'C:\Users\Hassa_mjmdtbp\Desktop\last\Final\orders.csv'
with (
      fieldterminator = ',',
	  rowterminator = '\n',
	  firstrow = 2); 

--Inserting data into the Product table
bulk insert Product
from 'C:\Users\Hassa_mjmdtbp\Desktop\last\Final\product.csv'
with (
       fieldterminator =  ',',
	   rowterminator = '\n',
	   firstrow = 2 ); 

select top(20) * from Customer;
select top(20) * from OrderItem;
select top(20) * from Orders;
select top(20) * from Product;
select top(20) * from Supplier;