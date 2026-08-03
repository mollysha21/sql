 /* ASSIGNMENT 1 */
--Please write responses between the QUERY # and END QUERY blocks
/* SECTION 2 */


--SELECT
/* 1. Write a query that returns everything in the customer table. */
--QUERY 1
SELECT *
From customer;
--END QUERY


/* 2. Write a query that displays all of the columns and 10 rows from the customer table, 
sorted by customer_last_name, then customer_first_ name. */
--QUERY 2
Select *
From customer
Order by customer_last_name, customer_first_name
LIMIT 10;
--END QUERY


--WHERE
/* 1. Write a query that returns all customer purchases of product IDs 4 and 9. 
Limit to 25 rows of output. */
--QUERY 3
Select *
From customer_purchases
Where product_id IN (4,9)
Limit 25;
--END QUERY



/*2. Write a query that returns all customer purchases and a new calculated column 'price' (quantity * cost_to_customer_per_qty), 
filtered by customer IDs between 8 and 10 (inclusive) using either:
	1.  two conditions using AND
	2.  one condition using BETWEEN
Limit to 25 rows of output.
*/
--QUERY 4
Select *, (quantity * cost_to_customer_per_qty) as price
From customer_purchases
Where customer_id BETWEEN 8 AND 10
Limit 25;
--END QUERY


--CASE
/* 1. Products can be sold by the individual unit or by bulk measures like lbs. or oz. 
Using the product table, write a query that outputs the product_id and product_name
columns and add a column called prod_qty_type_condensed that displays the word “unit” 
if the product_qty_type is “unit,” and otherwise displays the word “bulk.” */
--QUERY 5
Select product_id, product_name,
Case
	When product_qty_type = 'unit' Then 'unit'
	Else 'bulk'
End as prod_qty_type_condensed
From product;
--END QUERY


/* 2. We want to flag all of the different types of pepper products that are sold at the market. 
add a column to the previous query called pepper_flag that outputs a 1 if the product_name 
contains the word “pepper” (regardless of capitalization), and otherwise outputs 0. */
--QUERY 6
Select product_id, product_name,
Case
	When product_qty_type = 'unit' Then 'unit'
	Else 'bulk'
End as prod_qty_type_condensed,
Case
	When product_name LIKE '%pepper%' Then 1
	Else 0
End as pepper_flag
From product;
--END QUERY


--JOIN
/* 1. Write a query that INNER JOINs the vendor table to the vendor_booth_assignments table on the 
vendor_id field they both have in common, and sorts the result by market_date, then vendor_name.
Limit to 24 rows of output. */
--QUERY 7
select *
From vendor v
inner join vendor_booth_assignments vba
on v.vendor_id = vba.vendor_id
Order by vba.market_date, v.vendor_name
Limit 24;
--END QUERY



/* SECTION 3 */

-- AGGREGATE
/* 1. Write a query that determines how many times each vendor has rented a booth 
at the farmer’s market by counting the vendor booth assignments per vendor_id. */
--QUERY 8
select vendor_id, 
Count(*) as booth_rentals
from vendor_booth_assignments
group by vendor_id;
--END QUERY


/* 2. The Farmer’s Market Customer Appreciation Committee wants to give a bumper 
sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list 
of customers for them to give stickers to, sorted by last name, then first name. 

HINT: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword. */
--QUERY 9
select c.customer_id, c.customer_first_name, c.customer_last_name,
Sum(cp.quantity * cp.cost_to_customer_per_qty) as total_spent
From customer c
inner join customer_purchases cp
on c.customer_id = cp.customer_id
group by c.customer_id, c.customer_first_name, c.customer_last_name
Having total_spent > 2000
Order by c.customer_last_name, c.customer_first_name;
--END QUERY


--Temp Table
/* 1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: 
Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal

HINT: This is two total queries -- first create the table from the original, then insert the new 10th vendor. 
When inserting the new vendor, you need to appropriately align the columns to be inserted 
(there are five columns to be inserted, I've given you the details, but not the syntax) 

-> To insert the new row use VALUES, specifying the value you want for each column:
VALUES(col1,col2,col3,col4,col5) 
*/
--QUERY 10
drop table if exists temp.new_vendor;
create table temp.new_vendor as
select * 
from vendor;
insert into temp.new_vendor (vendor_id, vendor_name, vendor_type, vendor_owner_first_name, vendor_owner_last_name)
values (10, 'Thomass Superfood Store', 'Fresh Focused', 'Thomas', 'Rosenthal');	
--END QUERY
