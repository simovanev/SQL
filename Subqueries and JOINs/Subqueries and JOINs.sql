# 1
SELECT employee_id, job_title, e.address_id, address_text
FROM employees AS e
         JOIN addresses a ON e.address_id = a.address_id
LIMIT 5;
# 2
SELECT first_name, last_name, name AS 'town', address_text
FROM employees
         JOIN addresses a ON employees.address_id = a.address_id
         JOIN towns t ON a.town_id = t.town_id
ORDER BY first_name, last_name
LIMIT 5;
# 3
SELECT employee_id, first_name, last_name, d.name AS 'department_name'
FROM employees AS e
         JOIN departments AS d ON e.department_id = d.department_id
WHERE name = 'Sales'
ORDER BY employee_id DESC;
# 4
SELECT employee_id, first_name, salary, d.name AS 'department_name'
FROM employees AS e
         JOIN departments AS d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY e.department_id DESC
LIMIT 5;
#5
SELECT e.employee_id, first_name
FROM employees AS e
         LEFT JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;
# 6
SELECT first_name, last_name, hire_date, d.name AS 'dept_name'
FROM employees AS e
         JOIN departments AS d ON e.department_id = d.department_id
WHERE e.hire_date > 1999 - 01 - 01
  AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date;
# 7
SELECT e.employee_id, first_name, p.name AS 'project_name'
FROM employees AS e
         JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
         LEFT JOIN projects AS p ON ep.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13'
  AND p.end_date IS NULL
ORDER BY e.first_name, project_name
LIMIT 5;
# 8
SELECT e.employee_id,
       first_name,
       CASE
           WHEN YEAR(p.start_date) >= 2005 THEN NULL
           ELSE p.name END AS 'project_name'
FROM employees AS e
         JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
         JOIN projects AS p ON ep.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY p.name;
# 9
SELECT e.employee_id, e.first_name, e.manager_id, m.first_name AS 'manager_name'
FROM employees AS e
         JOIN employees AS m ON e.manager_id = m.employee_id
WHERE m.employee_id IN (3, 7)
ORDER BY e.first_name;
# 10
SELECT e.employee_id
     , CONCAT_WS(' ', e.first_name, e.last_name) AS 'employee_name'
     , CONCAT_WS(' ', m.first_name, m.last_name) AS manager_name
     , d.name                                    AS 'department_name'
FROM employees AS e
         JOIN employees AS m ON e.manager_id = m.employee_id
         JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;
# 11
SELECT AVG(salary) AS 'min_average_salary'
FROM employees
GROUP BY department_id
ORDER BY min_average_salary
LIMIT 1;
#12

SELECT c.country_code, mountain_range, peak_name, elevation
FROM countries AS c
         JOIN mountains_countries MC ON c.country_code = MC.country_code
         JOIN mountains m ON m.id = MC.mountain_id
         JOIN peaks AS p ON p.mountain_id = m.id
WHERE country_name = 'Bulgaria'
  AND elevation > 2835
ORDER BY elevation DESC;
# 13
SELECT c.country_code, COUNT(mountain_range) AS 'mountain_range'
FROM countries AS c
         JOIN mountains_countries mc ON c.country_code = mc.country_code
         JOIN mountains m ON m.id = mc.mountain_id
WHERE country_name IN ('United States', 'Russia', 'Bulgaria')
GROUP BY country_code
ORDER BY mountain_range DESC;
# 14
SELECT country_name, river_name
FROM countries AS c
         LEFT JOIN countries_rivers cr ON c.country_code = cr.country_code
         LEFT JOIN rivers r ON r.id = cr.river_id
         JOIN continents c2 ON c.continent_code = c2.continent_code
WHERE continent_name = 'Africa'
ORDER BY country_name
LIMIT 5;
# 15
SELECT c.continent_code, currency_code, count(currency_code) as 'currency_usage'
from countries as c
GROUP BY c.continent_code, c.currency_code
HAVING currency_usage>1 and currency_usage=(select count(*) as 'max_currency'
                             from countries as c2
                             where c2.continent_code=c.continent_code
                             GROUP BY c2.currency_code
                             ORDER BY max_currency DESC
                             LIMIT 1);

# 16
SELECT COUNT(country_name) AS 'country_count'
FROM countries
         LEFT JOIN mountains_countries mc ON countries.country_code = mc.country_code
WHERE mountain_id IS NULL;
# 17
SELECT country_name
     , MAX(p.elevation) AS 'highest_peak_elevation'
     , MAX(r.length)    AS 'longest_river_length'
FROM countries AS c
         LEFT JOIN mountains_countries mc ON c.country_code = mc.country_code
         LEFT JOIN mountains m ON m.id = mc.mountain_id
         LEFT JOIN peaks p ON m.id = p.mountain_id
         LEFT JOIN countries_rivers cr ON c.country_code = cr.country_code
         LEFT JOIN rivers r ON r.id = cr.river_id
GROUP BY country_name
ORDER BY highest_peak_elevation DESC, longest_river_length DESC, country_name
LIMIT 5
