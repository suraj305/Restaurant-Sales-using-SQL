select * from RestaurantOrders;

/*Data preprocessing*/

/*add column*/
alter table RestaurantOrders
add new_order_data Date;

/*convert data type*/
update RestaurantOrders
set new_order_data = convert(Date, Order_Date);

alter table RestaurantOrders
add new_order_time Time;

update RestaurantOrders
set new_order_time = CONVERT(Time, Order_Date, 120);

alter table RestaurantOrders
alter column quantity_of_items int;

/*Drop unwanted columns*/
alter table RestaurantOrders
drop column order_date;

/*rename columns name*/
EXEC sp_rename 'restaurantorders.new_order_data', 'Order_data';
EXEC sp_rename 'restaurantorders.new_order_time', 'Order_time';

/*Checking for null values*/
select Customer_Name from RestaurantOrders
where Customer_Name is null;

select Restaurant_ID from RestaurantOrders
where Restaurant_ID is null;

select Order_Amount from RestaurantOrders
where Order_Amount is null;

select Payment_Mode from RestaurantOrders
where Payment_Mode is null;

select Quantity_of_Items from RestaurantOrders
where Quantity_of_Items is null;


/*What is the Total amount of orders?*/
select AVG(customer_rating_food) as average_customer_rating
from RestaurantOrders;

select SUM(Quantity_of_items) as Total_items_sold
from RestaurantOrders;

select sum(Quantity_of_items) as Total_Items_Sold
from RestaurantOrders;

select sum(Order_Amount) as Total_Orders
from RestaurantOrders;

select avg(delivery_time_taken_mins) as Average_Delivery_Time
from RestaurantOrders;

select * from RestaurantOrders;

/*Join two table */
select * from RestaurantOrders t1
inner join Restaurants t2 on t1.Restaurant_ID = t2.RestaurantID;

/*What amount of customers did each zone have*/﻿
with Count_customer_each_zone as 
(select t2.RestaurantName, t2.Cuisine, t2.Zone, t2.Category, t1.Payment_Mode, t1.Customer_Name, t1.Order_Amount, t1.Quantity_of_Items, t1.Delivery_Time_Taken_mins
from RestaurantOrders t1
inner join Restaurants t2
on t1.Restaurant_ID = t2.RestaurantID)
select COUNT(distinct (Customer_Name)) as Total_Customers, Zone
from Count_customer_each_zone
group by Zone
order by COUNT(distinct (Customer_Name)) desc;

/*What restaurant had the most orders?*/
with most_order_restaurant as 
(select t2.RestaurantName, t2.Cuisine, t2.Zone, t2.Category, t1.Payment_Mode, t1.Customer_Name, t1.Order_Amount, t1.Quantity_of_Items, t1.Delivery_Time_Taken_mins
from RestaurantOrders t1
inner join Restaurants t2
on t1.Restaurant_ID = t2.RestaurantID)
select top 5 sum(Order_Amount) as Total_orders, RestaurantName
from most_order_restaurant
group by RestaurantName;

/*What payment mode was used frequently by customers?*/﻿
with Mode_Of_Payment as 
(Select Payment_Mode, 
case 
when Payment_Mode = 'Debit Card' then 'Card'
when Payment_Mode = 'Credit Card' then 'Card'
else 'Cash'
end as Mode_of_Payment
from RestaurantOrders)
select count (Mode_of_Payment) as 'Quantity',
Mode_of_Payment
from Mode_Of_Payment
group by Mode_of_Payment
order by count (Mode_of_Payment) desc;

/*What is the most liked cuisine?*/
with most_liked_cuisine as 
(select t2.RestaurantName, t2.Cuisine, t2.Zone, t2.Category, t1.Payment_Mode, t1.Customer_Name, t1.Order_Amount, t1.Quantity_of_Items, t1.Delivery_Time_Taken_mins
from RestaurantOrders t1
inner join Restaurants t2
on t1.Restaurant_ID = t2.RestaurantID)
select top 5 SUM(Order_amount) as Total_order, Cuisine 
from most_liked_cuisine 
group by Cuisine
order by  SUM(Order_amount) desc;

/*Which zone had the most orders?*/
with Most_Order as
(select 
case
when order_time between '12:00:00' and  '17:59:00' then 'Afternoon'
when Order_time between '18:00:00' and  '23:59:00' then 'Night'
else 'Morning'
end as Time_of_day
from RestaurantOrders)
select time_of_day, COUNT(Time_of_day) as Order_by_time_of_day
from Most_Order
group by Time_of_day
order by Order_by_time_of_day desc;