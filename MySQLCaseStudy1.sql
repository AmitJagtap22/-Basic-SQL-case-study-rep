--steps of importing dataset from CSV files covered in 3rd June session avaiable on LMS
use SQL_TRAINING

select * from Fact
select * from Locations
select * from Product


-- 1. Display the number of states present in the LocationTable.
select count(distinct state) as No_of_States from Locations

-- 2. How many products are of regular type?
select count(*) as Regular_Product from Product where type='Regular'

-- 3. How much spending has been done on marketing of product ID 1?
select sum(marketing) as Marketing_Expense from Fact where productid=1 

-- 4. What is the minimum sales of a product?
select min(sales) as Minimum_Sales from Fact

-- 5. Display the max Cost of Good Sold (COGS).
select max(COGS)as Max_COGS from Fact

-- 6. Display the details of the product ID where product type is coffee.
select * from Product where product_type='Coffee'

-- 7. Display the details where total expenses are greater than 40.
select * from Fact where total_expenses>40

-- 8. What is the average sales in area code 719?
select avg(sales) as Average_Sales from Fact where area_code=719

-- 9. Find out the total profit generated by Colorado state.
select sum(profit) as Total_Colorado_profit from Fact f join Locations l on f.area_code=l.area_code where l.state='Colorado'	

-- 10. Display the average inventory for each product ID.
select ProductID,avg(inventory) as Average_Inventory from Fact group by productid order by productid

-- 11. Display state in a sequential order in a LocationTable.
select distinct state from Locations order by state

-- 12. Display the average budget margin where the average budget margin should be greater than 100.
select Area_code,avg(budget_margin) as Average_Budget_Margin from Fact group by area_code having avg(budget_margin)>100 order by area_code

-- 13. What is the total sales done on date 2010-01-01?
select sum(sales) as Total_Sales from Fact where Date='2010-01-01'

-- 14. Display the average total expense of each product ID on an individual date.
select Productid,avg(total_expenses) as Average_Total_Expense,Date from Fact group by productid,date order by date,productid

-- 15. Display the table with the following attributes such as date, product ID, product_type, product, sales, profit, state, area_code.
select Date,F.Productid,Product_type,Product,Sales,Profit,State,F.Area_code from Fact F join Locations L on F.area_code=L.area_code join Product P on F.productid=P.productID

-- 16. Display the rank without any gap to show the sales wise rank.
select Sales,dense_rank()over(order by sales desc) as Drank from Fact

-- 17. Find the state wise profit and sales.  
select l.State,sum(f.profit) as Total_Profit,sum(f.sales) as Total_Sales from Fact F join Locations L on F.area_code=L.area_code group by l.state order by l.state

-- 18. Find the state wise profit and sales along with the product name.
select l.State,p.Product,sum(f.profit) as Total_Profit,sum(f.sales) as Total_Sales from Fact F join Locations L on F.area_code=L.area_code join Product P on F.productid=P.productid group by l.state,p.product order by l.state,p.product

-- 19. If there is an increase in sales of 5%, calculate the increased sales.
select Sales,Sales+0.05*Sales as Increased_Sales from Fact

-- 20. Find the maximum profit along with the product ID and product type.
select p.Productid,Product_type,max(profit) as Maximum_Profit from Fact f join Product p on f.productid=p.productid group by p.productid,product_type

-- 21. Create a stored procedure to fetch the result according to the product type from ProductTable.
alter procedure sp_getProductType @product_type varchar(20)
as  
	select * from Product where product_type=@product_type

exec sp_getProductType'Tea'

-- 22. Write a query by creating a condition in which if the total expenses is less than 60 then it is a profit or else loss.
select Total_expenses,iif(Total_expenses<60,'Profit','Loss') as Result from Fact 

-- 23. Give the total weekly sales value with the date and product ID details. Use roll-up to pull the data in hierarchical order.
select datepart(week,date) as Week_number,productid,sum(sales) as Total_Sales from Fact group by datepart(week,date),productid with rollup  order by datepart(week,date),productid

-- 24. Apply union and intersection operator on the tables which consist of attribute area code.
select Area_code from Fact
union
select Area_code from Locations

select Area_code from Fact
intersect
select Area_code from Locations

-- 25. Create a user-defined function for the product table to fetch a particular product type based upon the user�s preference.
create function func_product(@type varchar (20))
returns table
return
(select * from Product where Product_type=@type)

select * from func_product('coffee')

-- 26. Change the product type from coffee to tea where product ID is 1 and undo it.
begin transaction
update Product set product_type='Tea' where productid=1

rollback transaction

-- 27. Display the date, product ID and sales where total expenses are between 100 to 200.
select Date, ProductID,Sales from Fact where total_expenses between 100 and 200

-- 28. Delete the records in the ProductTable for regular type.
begin transaction
delete from Product where type='Regular'

rollback transaction

-- 29. Display the ASCII value of the fifth character from the column Product.
select Product,substring(product,5,1) as Characters,ASCII(substring(product,5,1)) as ASCII_Values from Product