create database Pizza_Sales;
use Pizza_Sales;
create table orders(order_id int not null,
 order_date datetime not null, order_time time not null,
 primary key(order_id));
 select * from orders;
 create table order_details(order_details_id int not null,
 order_id int not null,
 pizza_id text not null,
 quantity int not null,
 primary key (order_details_id));
 select * from order_details;

# RETRIEVE THE TOTAL NO OF ORDERS PLACED?
select count(order_id) as Total_orders from orders;
 
#CALCULATE THE TOTAL NO OF REVENUE GENERATED FROM PIZZAS SALES?
 select round(sum(price* quantity),2)as Total_revenue 
 from  order_details
 inner join pizzas using (pizza_id);
 
# identify the highest priced pizza?
select pizza_types.name, pizzas. price from pizza_types join pizzas on 
pizza_types.pizza_type_id = pizzas.pizza_type_id order by price desc limit 1;

 
 # IDENTIFY THE MOST COMMON PIZZA SIZE ORDERED?
select count(order_details.order_details_id) as count, pizzas.size
from pizzas join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size order by count desc limit 1;
            #OR
 WITH PizzaCounts AS (
    SELECT pizzas.size, COUNT(order_details.order_details_id) AS count,
           RANK() OVER (ORDER BY COUNT(order_details.order_details_id) DESC) AS rnk
    FROM pizzas 
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizzas.size
)
SELECT size, count FROM PizzaCounts WHERE rnk = 1;



# LIST THE TOP 5 MOST ORDERED PIZZA TYPES ALONG WITH THEIR QUANTITIS?

SELECT pizza_types.name,sum(order_details.quantity)as total
from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by total desc limit 5;


# FIND THE TOTAL QUANTITY OF EACH PIZZA category?
select pizza_types.category, sum(order_details.quantity) as quantity
 from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
 join order_details on order_details.pizza_id = pizzas.pizza_id 
 group by pizza_types.category order by quantity desc ;
 select * from orders;
 
 # DETERMINE THE DISTRIBUTION OF ORDERS ON HOUR BASIS?
 select hour(order_time)as hour, count(order_id) as total_orders
 from orders group by hour order by hour;
 
 #FIND THE CATEGORY WISE DISTRIBUTION OF PIZZAS?
 select category, count(name) from pizza_types
 group by category;
 
 # GROUP THE ORDERS BY DATE AND CALCULATE THE AVERAGE NO OF PIZZAS ORDERED PER DAY?
select avg(quantity_sum)as avg_pizza_perday from
(select orders.order_date, sum(order_details.quantity)as quantity_sum from 
orders join order_details on order_details.order_id= orders.order_id
group by orders.order_date)as order_quantity;

# DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE
select pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue from order_details
join pizzas on order_details.pizza_id= pizzas.pizza_id join
pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name order by revenue desc limit 3 ;

# DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPE BASED ON REVENUE FOR EACH PIZZA CATEGORY?
select name, revenue,rk from 
(select category, name , revenue, dense_rank() over
(partition  by category order by revenue desc) as rk from
(select pizza_types.category, pizza_types.name, sum((order_details.quantity * pizzas.price))
as revenue from 
pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
 on order_details.pizza_id = pizzas.pizza_id 
group by pizza_types.category, pizza_types.name )as a)as b
where rk<=3;





 
 

 
 
 
 
 