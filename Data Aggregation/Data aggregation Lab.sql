-- 1
select department_id ,count(id)
from employees
group by department_id;
-- 2
select department_id, round(avg(salary),2) as 'Average salary'
from employees
group by department_id;
-- 3
select department_id, round(min(salary),2) as 'Minimum salary'
from employees
group by department_id
having `Minimum salary`>800;
-- 4
select count(id)
from products
where category_id=2;
-- 5
-- Category_id
-- • Average Price
-- • Cheapest Product
-- • Most Expensive Product
select category_id,
round(avg(price),2) as 'Average Price',
round(min(price),2) as 'Cheapest Product',
round(max(price),2) as 'Most Expensive Product'
from products
group by category_id;


