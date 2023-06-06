# 1
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
    SELECT first_name, last_name
    FROM employees
    WHERE salary > 35000
    ORDER BY first_name, last_name, employee_id;
END $$
DELIMITER ;
CALL usp_get_employees_salary_above_35000();

# 2
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(salary_limit DECIMAL(10, 4))
BEGIN
    SELECT first_name, last_name
    FROM employees
    WHERE salary >= salary_limit
    ORDER BY first_name, last_name, employee_id;
END $$

# 3
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(string VARCHAR(10))
BEGIN
    SELECT t.name
    FROM towns AS t
    WHERE t.name LIKE CONCAT(string, '%')
    ORDER BY t.name;
END $$
DELIMITER ;
CALL usp_get_towns_starting_with('b');

# 4
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(25))
BEGIN
    SELECT first_name, last_name
    FROM employees AS e
             JOIN addresses a ON a.address_id = e.address_id
             JOIN towns AS t ON a.town_id = t.town_id
    WHERE t.name = town_name
    ORDER BY first_name, last_name, employee_id;
END $$
DELIMITER ;
CALL usp_get_employees_from_town('Sofia');

# 5
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(10, 4))
    RETURNS VARCHAR(7)
    DETERMINISTIC
    RETURN (SELECT CASE
                       WHEN salary < 30000 THEN 'Low'
                       WHEN salary <= 50000 THEN 'Average'
                       ELSE 'High'
                       END);
SELECT ufn_get_salary_level(30000);

# 6
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(7))
BEGIN
    SELECT first_name, last_name
    FROM employees AS e
    WHERE ufn_get_salary_level(e.salary) = salary_level
    ORDER BY first_name DESC, last_name DESC;
END $$
DELIMITER ;
CALL usp_get_employees_by_salary_level('High');

#7
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
    RETURNS BIT
    DETERMINISTIC
    RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));

# 8
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
    SELECT CONCAT_WS(' ', first_name, last_name) AS full_name
    FROM account_holders
    ORDER BY full_name;
END $$

# 9
DELIMITER &&
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(amount DECIMAL(19, 4))
BEGIN
    SELECT first_name, last_name
    FROM account_holders
             JOIN accounts a ON account_holders.id = a.account_holder_id
    GROUP BY account_holders.id
    HAVING SUM(a.balance) > amount
    ORDER BY account_holder_id;
END &&
DELIMITER ;
CALL usp_get_holders_with_balance_higher_than(7000);

# 10
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(
    sum DECIMAL(19, 4),
    yearly_interest_rate DOUBLE,
    years INT)
    RETURNS DECIMAL(19, 4)
    DETERMINISTIC
BEGIN
    DECLARE result DECIMAL(19, 4);
    SET result = sum * POWER((1 + yearly_interest_rate), years);
    RETURN result;
END $$
DELIMITER ;


SELECT ufn_calculate_future_value(1000, 0.5, 5);

# 11
DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, interest_rate DECIMAL(7, 4))
BEGIN
    SELECT a.id,
           first_name,
           last_name,
           a.balance           AS current_balance,
           (SELECT ufn_calculate_future_value(
                           current_balance,
                           interest_rate,
                           5)) AS balance_in_5_years
    FROM accounts AS a
             JOIN account_holders ah ON ah.id = a.account_holder_id
    WHERE a.id = id;
END $$
DELIMITER ;
CALL usp_calculate_future_value_for_account(2, 0.05);

# 12
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    START TRANSACTION;
    IF (money_amount <= 0)
    THEN
        ROLLBACK;
    ELSE
        UPDATE accounts
        SET balance= balance + money_amount
        WHERE id = account_id;
    END IF;
END $$

# 13
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    START TRANSACTION ;
    IF money_amount < 0 AND (SELECT balance
                             FROM accounts
                             WHERE id = account_id) < money_amount THEN
        ROLLBACK;
    ELSE
        UPDATE accounts
        SET balance= balance - money_amount
        WHERE id = account_id;
    END IF;

END $$
CALL usp_withdraw_money(1, 10);

# 14
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19, 4))
BEGIN
    START TRANSACTION;

    IF (SELECT id
        FROM accounts
        WHERE id = from_account_id) IS NULL OR (SELECT id
                                                FROM accounts
                                                WHERE id = to_account_id) IS NULL OR
       amount <= 0 OR
       (SELECT balance FROM accounts WHERE id = from_account_id) - amount < 0 OR from_account_id = to_account_id THEN
        ROLLBACK;
    ELSE
        UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
        UPDATE accounts
        SET balance= balance + amount
        WHERE id = to_account_id;
    END IF;
END $$
DROP PROCEDURE usp_transfer_money;
CALL usp_transfer_money(1, 2, 10);












