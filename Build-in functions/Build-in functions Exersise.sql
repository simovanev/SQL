-- 1 
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    SUBSTRING(first_name, 1, 2) = 'sa';
     -- 2
     SELECT 
    first_name, last_name
FROM
    employees
WHERE
    last_name LIKE '%ei%';
    -- 3
    SELECT 
    first_name
FROM
    employees
WHERE
    department_id IN (3 , 10)
        AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;
-- 4
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    NOT job_title LIKE '%engineer%';
    -- 5
    SELECT 
    name
FROM
    towns
WHERE
    CHAR_LENGTH(name) = 5
        OR CHAR_LENGTH(name) = 6
ORDER BY name;
-- 6
SELECT 
    town_id, name
FROM
    towns
WHERE
    LOWER(LEFT(name,1)) REGEXP '[mkbe]'
ORDER BY name;
-- 7
 SELECT 
    town_id, name
FROM
    towns
WHERE
    NOT LOWER(LEFT(name,1)) REGEXP '[rbd]'
ORDER BY name;
-- 8
CREATE VIEW v_employees_hired_after_2000 AS
    SELECT 
        first_name, last_name
    FROM
        employees
    WHERE
        YEAR(hire_date) > 2000;
select * from v_employees_hired_after_2000;
-- 9
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    CHAR_LENGTH(last_name) = 5; 
    -- 10
    SELECT 
    country_name, iso_code
FROM
    countries
WHERE
    country_name LIKE '%a%a%a%'
ORDER BY iso_code;
    -- 11
    SELECT distinct
    peaks.peak_name,
    rivers.river_name,
   
   CONCAT(LOWER(peaks.peak_name),
            LOWER(right(rivers.river_name,length(rivers.river_name)-1))) AS mix
FROM
    peaks,
    rivers
WHERE
    RIGHT(peaks.peak_name, 1) = LEFT(rivers.river_name, 1)
ORDER BY mix;
-- 12
SELECT 
    name, DATE_FORMAT(start, '%Y-%m-%d') AS start
FROM
    games
WHERE
    YEAR(start) IN (2011 , 2012)
ORDER BY start , name
LIMIT 50;
-- 13
SELECT 
    user_name,
    SUBSTRING_INDEX(email, '@', - 1) AS 'email provider'
FROM
    users
ORDER BY `email provider` , user_name;
-- 14
SELECT 
    user_name, ip_address
FROM
    users
WHERE
    ip_address LIKE '___.1%.%.___'
ORDER BY user_name;
-- 15
select name,
case
when hour(start) < 12 then 'Morning'
when hour (start)<18 then 'Afternoon'
else 'Evening' end as 'Part of the Day',
case 
when duration <=3 then 'Extra Short'
when duration <=6 then 'Short'
when duration <=10 then 'Long'
else 'Extra Long' end as 'Duration'
from games;
use orders;
-- 16
SELECT 
    product_name,order_date,
    ADDDATE(order_date, INTERVAL 3 DAY) AS 'pay_due',
    ADDDATE(order_date, INTERVAL 1 MONTH) AS 'deliver_due'
FROM
    orders;
    
