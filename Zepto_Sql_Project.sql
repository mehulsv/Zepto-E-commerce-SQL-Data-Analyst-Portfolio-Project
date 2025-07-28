drop table if exists zepto;

create table zepto(
sku_id SERIAL primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);

--data exploration

-- count of rows
select count(*) from zepto;

--sample data
SELECT * FROM zepto
limit 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
or
category IS NULL
or
mrp IS NULL
or
discountPercent IS NULL
or
discountedSellingPrice IS NULL
or
availableQuantity IS NULL
or
outOfStock IS NULL
or
quantity IS NULL;

-- different product categories
select distinct category
from zepto
order by category;

--products in stock vs out of stock
select outOfStock, count(sku_id)
from zepto
group by outOfStock;

--product names present multiple times
select name, count(sku_id) as "number of SKUs"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning

--products with price =0
select * from zepto
where mrp =0 or discountedSellingPrice=0;

delete from zepto
where mrp =0;

-- convert paise to rupees
update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto;

--Q1. Find the top 10 best-value products based on the discount percentage.

select distinct name,mrp,discountPercent
from zepto
order by discountPercent desc
limit 10;

--Q2.What are the Products with High MAP but Out of Stock

 select distinct name, mrp
 from zepto
 where outOfStock = true and mrp>300
 order by mrp desc;

--Q3.Calculate Estimates Revenue, for each category

 select category,
 sum(discountedSellingPrice * availableQuantity) as total_revenue
 from zepto
 group by category
 order by total_revenue;
 
--04.Find all products where MRP is greater than see and discount is less than 10%. UPDQS. 

select distinct name, mrp,discountPercent
from zepto
where mrp> 500 and discountPercent<10
order by mrp desc, discountPercent desc;

--05.Identify the top 5 categories offering the highest average discount percentage.

select category,
round(avg(discountPercent),2) as avg_discount
from zepto
group by category 
order by avg_discount desc
limit 5;

--Q6. Find the price per gran for products above 100g and sort by best value. 
select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms >=100
order by price_per_gram;

--Q7.Group the products 1 into categories like Low, Medium, Bulk.

select distinct name, weightInGms,
case when weightInGms <1000 then 'low'
	when weightInGms <5000 then 'medium'
	else 'bulk'
	end as weight_category
from zepto;

--Q8.What is the Total Inventory Weight Per Category

select category,
sum(weightINGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;

