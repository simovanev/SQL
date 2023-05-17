USE soft_uni;
-- 1 
SELECT 
    *
FROM
    departments
ORDER BY department_id; 
-- 2
SELECT 
    name
FROM
    departments
ORDER BY department_id; 
-- 3
SELECT  first_name,last_name,salary
FROM employees;
-- 4
SELECT  first_name,middle_name,last_name
FROM employees; 
-- 5
SELECT 
CONCAT(first_name,'.'last_name,'@','softuni.bg') as 'full_
email_address'
FROM employees;

-- 6
SELECT DISTINCT salary
FROM employees ;
-- 7
SELECT 
    *
FROM
    employees
WHERE
    job_title = 'Sales Representative';
    -- 8
    SELECT 
    first_name, last_name, job_title
FROM
    employees
WHERE
    salary BETWEEN 20000 AND 30000;
    -- 9
    SELECT 
    CONCAT_WS(' ', first_name, middle_name, last_name) AS 'Full name'
FROM
    employees
WHERE
    salary IN (25000 , 14000, 12500, 23600);
    -- 10
    SELECT 
    first_name, last_name
FROM
    employees
WHERE
    manager_id IS NULL;
    -- 11
    SELECT 
    first_name, last_name, salary
FROM
    employees
WHERE
    salary > 50000
ORDER BY salary DESC;
    -- 12
    SELECT 
    first_name, last_name
FROM
    employees
ORDER BY salary DESC
LIMIT 5;
-- 13
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    NOT department_id = 4;
    -- 14

SELECT *
FROM employees
ORDER BY salary DESC,first_name, last_name DESC,middle_name;
-- 15
CREATE VIEW v_employees_salaries AS
    SELECT 
        first_name, last_name, salary
    FROM
        employees;
-- 16
CREATE VIEW v_employees_job_titles AS
    SELECT 
        CONCAT_WS(' ', first_name, middle_name, last_name) AS full_name,
        job_title
    FROM
        employees;
-- 17
SELECT DISTINCT
    job_title
FROM
    employees
ORDER BY job_title;
-- 18
SELECT 
    *
FROM
    projects
ORDER BY start_date , name
LIMIT 10;
 -- 19
 SELECT 
    first_name, last_name, hire_date
FROM
    employees
ORDER BY hire_date DESC
LIMIT 7;
-- 20
-- Engineering, Tool Design, Marketing or
-- Information Services  
UPDATE employees 
SET 
    salary = salary * 1.12
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            departments
        WHERE
            name IN ('Engineering' , 'Tool Design',
                'Marketing',
                'Information Services'));
 SELECT 
    salary
FROM
    employees;

-- 21
 SELECT peak_name
 FROM peaks
 ORDER BY peak_name;
 
 -- 22
 SELECT country_name, population
 FROM countries
 WHERE continent_code='EU'
 order by population DESC, country_name
 limit 30;
 
 -- 23
 SELECT 
 country_name, 
 country_code,
 if (currency_code ='EUR','Euro','Non Euro') AS 'currency'
 FROM countries
 ORDER BY country_name;

-- 24
 use diablo;
 SELECT name
 FROM characters
 ORDER BY name;
 