-- 1
SELECT 
    employee_id,
    CONCAT(first_name,' ', last_name) AS 'full_name',
    d.department_id,
    d.name
FROM
    employees AS e
        JOIN
    departments AS d ON d.manager_id = e.employee_id
ORDER BY employee_id
LIMIT 5;
-- 2

 SELECT 
    a.town_id, name, address_text
FROM
    addresses AS a
        JOIN
    towns AS t ON a.town_id = t.town_id
WHERE
    name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY town_id , address_id;
-- 3
SELECT 
    employee_id, first_name, last_name, department_id, salary
FROM
    employees
WHERE
    manager_id IS NULL;
-- 4    
SELECT 
    COUNT(*)
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);     