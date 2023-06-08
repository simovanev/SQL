CREATE DATABASE restaurant_db;

# 1
CREATE TABLE products
(
    id    INT PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(30)    NOT NULL UNIQUE,
    type  VARCHAR(30)    NOT NULL,
    price DECIMAL(10, 2) NOT NULL

);


CREATE TABLE clients
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birthdate  DATE        NOT NULL,
    card       VARCHAR(50),
    review     TEXT

);
CREATE TABLE tables
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    floor    INT NOT NULL,
    reserved BOOLEAN,
    capacity INT NOT NULL
);
CREATE TABLE waiters
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(50) NOT NULL,
    phone      VARCHAR(50),
    salary     DECIMAL(10, 2)
);
CREATE TABLE orders
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    table_id     INT  NOT NULL,
    waiter_id    INT  NOT NULL,
    order_time   TIME NOT NULL,
    payed_status BOOLEAN,
    CONSTRAINT fk_order_table FOREIGN KEY (table_id)
        REFERENCES tables (id),
    CONSTRAINT fk_order_waiter FOREIGN KEY (waiter_id)
        REFERENCES waiters (id)
);

CREATE TABLE orders_clients
(
    order_id  INT,
    client_id INT,
    CONSTRAINT FOREIGN KEY (order_id)
        REFERENCES orders (id),
    CONSTRAINT FOREIGN KEY (client_id)
        REFERENCES clients (id)
);
CREATE TABLE orders_products
(
    order_id   INT,
    product_id INT,
    CONSTRAINT FOREIGN KEY (order_id)
        REFERENCES orders (id),
    CONSTRAINT FOREIGN KEY (product_id)
        REFERENCES products (id)
);

# 2
INSERT INTO products(name, type, price)
VALUES (CONCAT_WS(' ', (SELECT last_name
                        FROM waiters
                        WHERE id = 7), 'specialty'), 'Cocktail', CEIL(0.01 * (SELECT salary
                                                                              FROM waiters
                                                                              WHERE waiters.id = 7))),
       (CONCAT_WS(' ', (SELECT last_name
                        FROM waiters
                        WHERE id = 8), 'specialty'), 'Cocktail', CEIL(0.01 * (SELECT salary
                                                                              FROM waiters
                                                                              WHERE waiters.id = 8))),
       (CONCAT_WS(' ', (SELECT last_name
                        FROM waiters
                        WHERE id = 9), 'specialty'), 'Cocktail', CEIL(0.01 * (SELECT salary
                                                                              FROM waiters
                                                                              WHERE waiters.id = 9))),
       (CONCAT_WS(' ', (SELECT last_name
                        FROM waiters
                        WHERE id = 10), 'specialty'), 'Cocktail', CEIL(0.01 * (SELECT salary
                                                                               FROM waiters
                                                                               WHERE waiters.id = 10)));

# 3
UPDATE orders
SET table_id=table_id - 1
WHERE orders.id BETWEEN 12 AND 23;

# 4
SELECT waiters.id
FROM waiters
         LEFT JOIN orders o ON waiters.id = o.waiter_id
WHERE waiter_id IS NULL;

DELETE
FROM waiters
WHERE id IN (5, 7);

# 5
SELECT *
FROM clients
ORDER BY birthdate DESC, id DESC;

# 6
SELECT first_name, last_name, birthdate, review
FROM clients AS c
WHERE c.card IS NULL
  AND YEAR(c.birthdate) BETWEEN 1978 AND 1993
ORDER BY last_name DESC, c.id
LIMIT 5;

#7
SELECT CONCAT(last_name, first_name, LENGTH(first_name), 'Restaurant') AS username,
       REVERSE(SUBSTRING(email, 2, 12))                                AS password
FROM waiters
WHERE salary IS NOT NULL
ORDER BY password DESC;

# 8

SELECT p.id, p.name, COUNT(op.product_id) AS count
FROM orders_products AS op
         JOIN products p ON p.id = op.product_id
GROUP BY op.product_id
HAVING count >= 5
ORDER BY count DESC;

# 9
SELECT t.id                AS table_id,
       capacity,
       COUNT(oc.client_id) AS count_clients,
       CASE
           WHEN t.capacity > COUNT(oc.client_id) THEN 'Free seats'
           WHEN t.capacity = COUNT(oc.client_id) THEN 'Full'
           ELSE 'Extra seats'
           END             AS availability
FROM tables AS t
         JOIN orders o ON t.id = o.table_id
         JOIN orders_clients oc ON o.id = oc.order_id
WHERE floor = 1
GROUP BY o.table_id
ORDER BY table_id DESC;

# 10
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50))
RETURNS DECIMAL(10,2)
    DETERMINISTIC
RETURN (SELECT sum(p.price)
        from clients as c
        JOIN orders_clients oc ON c.id = oc.client_id
        JOIN orders o ON o.id = oc.order_id
        JOIN orders_products op ON o.id = op.order_id
        JOIN products as p ON op.product_id = p.id
        WHERE concat_ws(' ',c.first_name,c.last_name)=full_name
        GROUP BY c.id);



SELECT sum(p.price)
from clients as c
         JOIN orders_clients oc ON c.id = oc.client_id
         JOIN orders o ON o.id = oc.order_id
         JOIN orders_products op ON o.id = op.order_id
         JOIN products as p ON op.product_id = p.id
WHERE concat_ws(' ',c.first_name,c.last_name)='Silvio Blyth'
GROUP BY c.id;

# 11
DELIMITER $$
create PROCEDURE udp_happy_hour(type VARCHAR(50))
    BEGIN
        update products
            SET price=price*0.8
        WHERE price>=10;
    END $$

SELECT *
FROM products
WHERE type= 'Cognac';



