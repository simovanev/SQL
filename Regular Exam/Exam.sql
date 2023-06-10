CREATE DATABASE universities_db;
USE universities_db;

# 1
CREATE TABLE countries
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) UNIQUE NOT NULL

);
CREATE TABLE cities
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(40) UNIQUE NOT NULL,
    population INT,
    country_id INT                NOT NULL,
    CONSTRAINT fk_cities_countries FOREIGN KEY (country_id)
        REFERENCES countries (id)
);
CREATE TABLE universities
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(60)    NOT NULL UNIQUE,
    address         VARCHAR(80)    NOT NULL UNIQUE,
    tuition_fee     DECIMAL(19, 2) NOT NULL,
    number_of_staff INT,
    city_id         INT,
    CONSTRAINT fk_universities_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)
);
CREATE TABLE students
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    first_name   VARCHAR(40)  NOT NULL,
    last_name    VARCHAR(40)  NOT NULL,
    age          INT,
    phone        VARCHAR(20)  NOT NULL UNIQUE,
    email        VARCHAR(255) NOT NULL UNIQUE,
    is_graduated BOOLEAN      NOT NULL,
    city_id      INT,
    CONSTRAINT fk_students_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)
);
CREATE TABLE courses
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    name           VARCHAR(40)        NOT NULL UNIQUE,
    duration_hours DECIMAL(19, 2),
    start_date     DATE,
    teacher_name   VARCHAR(60) UNIQUE NOT NULL,
    description    TEXT,
    university_id  INT,
    CONSTRAINT fk_courses_universities FOREIGN KEY (university_id)
        REFERENCES universities (id)
);
CREATE TABLE students_courses
(
    grade      DECIMAL(19, 2) NOT NULL,
    student_id INT            NOT NULL,
    course_id  INT            NOT NULL,
    CONSTRAINT fk_students_courses_student_id FOREIGN KEY (student_id)
        REFERENCES students (id),
    CONSTRAINT fk_students_courses_course_id FOREIGN KEY (course_id)
        REFERENCES courses (id)
);

# 2
INSERT INTO courses (name, duration_hours, start_date, teacher_name, description, university_id)
SELECT CONCAT_WS(' ', teacher_name, 'course'),
       LENGTH(name) / 10,
       ADDDATE(start_date, INTERVAL 5 DAY),
       REVERSE(teacher_name),
       CONCAT('Course', teacher_name, REVERSE(description)),
       DAY(start_date)
FROM courses
WHERE id <= 5;

# 3
UPDATE universities
SET tuition_fee= tuition_fee + 300
WHERE id BETWEEN 5 AND 12;

# 4
DELETE
FROM universities
WHERE number_of_staff IS NULL;

# 5
SELECT id, name, population, country_id
FROM cities
ORDER BY population DESC;

# 6
SELECT first_name, last_name, age, phone, email
FROM students
WHERE age >= 21
ORDER BY first_name DESC, email, id
LIMIT 10;

# 7
SELECT CONCAT_WS(' ', first_name, last_name) AS full_name,
       SUBSTRING(email, 2, 10)               AS username,
       REVERSE(phone)                        AS password
FROM students
         LEFT JOIN students_courses sc ON students.id = sc.student_id
WHERE course_id IS NULL
ORDER BY password DESC;

# 8
SELECT COUNT(*) AS student_count, u.name AS university_name
FROM universities AS u
         JOIN courses c ON u.id = c.university_id
         JOIN students_courses sc ON c.id = sc.course_id
GROUP BY university_id
HAVING student_count >= 8
ORDER BY student_count DESC, 'university_name' DESC;

# 9
SELECT u.name                   AS university_name,
       c.name                   AS city_name,
       u.address,
       CASE
           WHEN tuition_fee < 800 THEN 'cheap'
           WHEN tuition_fee < 1200 THEN 'normal'
           WHEN tuition_fee < 2500 THEN 'high'
           ELSE 'expensive' END AS price_rank,
       tuition_fee
FROM universities AS u
         JOIN cities c ON c.id = u.city_id
ORDER BY tuition_fee;

# 10
CREATE FUNCTION udf_average_alumni_grade_by_course_name(course_name VARCHAR(60))
    RETURNS DECIMAL(19, 2)
    DETERMINISTIC
    RETURN (SELECT AVG(grade)
            FROM students_courses AS sc
                     JOIN courses c ON c.id = sc.course_id
            JOIN students s ON sc.student_id = s.id
            WHERE c.name = course_name and s.is_graduated=1
            GROUP BY course_id);


SELECT udf_average_alumni_grade_by_course_name('Quantum Physics');

DROP FUNCTION udf_average_alumni_grade_by_course_name;

# 11
DELIMITER $$
CREATE PROCEDURE udp_graduate_all_students_by_year (year_started INT)
BEGIN
    UPDATE students as s
    JOIN students_courses sc ON s.id = sc.student_id
    JOIN courses as c on c.id=sc.course_id
    SET is_graduated=1
    WHERE year(c.start_date)=year_started;
END $$
    DELIMITER ;



