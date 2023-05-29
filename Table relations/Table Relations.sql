-- 1
CREATE TABLE `people` (
    person_id INT,
    first_name VARCHAR(30),
    salary DECIMAL(8 , 2 ),
    passport_id INT
);
create table `passports`(
passport_id int primary key auto_increment,
 passport_number varchar(8) unique
 );
 
alter table `people`
add constraint primary key auto_increment (person_id);
alter table `people`
add constraint foreign key (passport_id)
references passports(passport_id);
alter table passports   auto_increment = 101;

insert into passports(passport_number)
values('N34FG21B'),
('K65LO4R7'),
('ZE657QP2');

insert into people(person_id,first_name, salary, passport_id)
values(1 ,'Roberto', 43300.00, 102),
 (2,'Tom', 56100.00, 103),
 (3,'Yana', 60200.00, 101);
 
 -- 2
 CREATE TABLE `manufacturers` (
    manufacturer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    established_on DATE
);
CREATE TABLE `models` (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    manufacturer_id INT,
    CONSTRAINT FOREIGN KEY (manufacturer_id)
        REFERENCES manufacturers (manufacturer_id)
);
 alter table `models` auto_increment=101;
 
 insert into manufacturers(name, established_on)
 values('BMW',' 1916-03-01'),
 ('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

insert into models (name, manufacturer_id)
values('X1', 1),
('i6', 1),
 ('Model S', 2),
 ('Model X', 2),
 ('Model 3', 2),
 ('Nova', 3);
 
 -- 3
 CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);
create table exams(
exam_id int  auto_increment primary key,
name varchar(20) not null
);
alter table exams auto_increment =101;
 CREATE TABLE students_exams (
    student_id INT,
    exam_id INT,
    CONSTRAINT PRIMARY KEY pk_students_exams (student_id , exam_id),
    CONSTRAINT FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT FOREIGN KEY (exam_id)
        REFERENCES exams (exam_id)
);
 insert into students(name)
 values('Mila'),
('Toni'),
('Ron');

insert into  exams (name)
values  ('Spring MVC'),
('Neo4j'),
('Oracle 11g');
insert into students_exams(student_id, exam_id)
values(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);
-- 4
CREATE TABLE teachers (
teacher_id int PRIMARY KEY, 
name varchar(30), 
manager_id int, 
CONSTRAINT sr_fk_tch_man FOREIGN KEY (manager_id) REFERENCES teachers(teacher_id)
);
insert into teachers(teacher_id, name, manager_id)
values( 101,' John', null),
(102 ,'Maya', 106),
(103 ,'Silvia',106),
(104, 'Ted', 105),
(105, 'Mark' ,101),
(106 ,'Greta', 101);
-- 5
create database orders;
use orders;

CREATE TABLE cities (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    birthday DATE,
    city_id INT,
    CONSTRAINT fk_cities_customers FOREIGN KEY (city_id)
        REFERENCES cities (city_id)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);
CREATE TABLE item_type (
    item_type_id INT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE items (
    item_id INT PRIMARY KEY,
    name VARCHAR(50),
    item_type_id INT NOT NULL,
    CONSTRAINT fk_item_item_type FOREIGN KEY (item_type_id)
        REFERENCES item_type (item_type_id)
);
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    CONSTRAINT PRIMARY KEY (order_id , item_id),
    CONSTRAINT FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT FOREIGN KEY (item_id)
        REFERENCES items (item_id)
);
-- 6
create database montains;
use montains;
create table majors(
major_id int auto_increment primary key,
name varchar (50)
);
create table students(
student_id int auto_increment primary key,
student_number varchar (12),
student_name varchar(50),
major_id int,
constraint fk_student_major foreign key (major_id)
references majors(major_id)
 );
 CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_date DATE,
    payment_amount DECIMAL(8 , 2 ),
    student_id INT,
    CONSTRAINT fk_payment_student FOREIGN KEY (student_id)
        REFERENCES students (student_id)
);
create table subjects(
subject_id int auto_increment primary key,
subject_name varchar(50)
);
create table agenda(
student_id int,
subject_id int,
constraint pk_agenda primary key (student_id,subject_id),
constraint fk_agenda_student_id foreign key (student_id)
references students(student_id),
constraint fk_agenda_subject_id foreign key (subject_id)
references subjects(subject_id)
);
-- 9
select mountain_range, peak_name, elevation
from mountains as m
join peaks as p
on m.id=p.mountain_id
where mountain_range='Rila'
order by elevation desc;


