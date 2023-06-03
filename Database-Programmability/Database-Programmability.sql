USE soft_uni;
# 1
DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(25))
    RETURNS INT
    DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*)
            FROM employees AS e
                     JOIN addresses a ON a.address_id = e.address_id
                     JOIN towns ON a.town_id = towns.town_id
            WHERE towns.name = town_name);
END $$

DELIMITER ;
;

SELECT COUNT(*)
FROM employees AS e
         JOIN addresses a ON a.address_id = e.address_id
         JOIN towns ON a.town_id = towns.town_id
WHERE towns.name = 'Sofia';
#2
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(25))
BEGIN
    UPDATE employees AS e
        JOIN departments d ON d.department_id = e.department_id
    SET salary= salary * 1.05
    WHERE d.name = department_name;
END$$
DELIMITER ;
;
CALL usp_raise_salaries('Finance');
SELECT first_name, salary
FROM employees
         JOIN departments d ON d.department_id = employees.department_id
WHERE name = 'Finance'
ORDER BY first_name;

# 3
DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
    START TRANSACTION;
    IF ((SELECT COUNT(*)
         FROM employees
         WHERE employee_id = id) = 1)
    THEN
        UPDATE employees
        SET salary=salary * 1.05
        WHERE employee_id = id;
    ELSE
        ROLLBACK;
    END IF;
END $$

# 4 first_name, last_name, middle_name, job_title, deparment_id,
# salary
CREATE TABLE deleted_employees
(
    employee_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(20),
    last_name     VARCHAR(20),
    middle_name   VARCHAR(20),
    job_title     VARCHAR(50),
    department_id INT,
    salary        DOUBLE

);
DELIMITER $$
CREATE TRIGGER tr_deleted_employees
    AFTER DELETE
    ON employees
    FOR EACH ROW
BEGIN
    INSERT INTO deleted_employees(first_name, last_name, middle_name, job_title, department_id,
                                  salary)
        VALUE
        (OLD.first_name, OLD.last_name, old.middle_name, old.job_title, old.department_id,
         old.salary);
END$$
