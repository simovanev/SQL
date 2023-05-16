create database minions;
use minions;
-- 1 
CREATE TABLE minions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20),
    age INT
);
CREATE TABLE towns (
    town_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20)
);

-- 2
alter table towns
change column  town_id
id int  auto_increment;

alter table minions add column town_id int;
alter table minions
add constraint fk_minions_towns
foreign key minions(town_id)
references towns(id);
-- 3
insert into towns(id,name)
values(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna');

insert into minions(id,name,age ,town_id) 
value(1,'Kevin',22,1),
(2,'Bob',15,3),
(3,'Steward',null,2);

-- 4
alter table minions
drop constraint fk_minions_towns;

truncate table minions;

-- 5
drop table minions;
drop table towns; 

-- 6
create table people(
id int auto_increment primary key,
name varchar(200) not null,
picture blob,
height double(3,2),
weight double(5,2),
gender char(1) not null,
birthdate date not null,
 biography text
);

insert into people(id,name,gender,birthdate)
values
(1,'Pesho','m',now()),
(2,'Lena','f',now()),
(3,'Pesho','m',now()),
(4,'ela','f',now()),
(5,'Pesho','m',now());

-- 7 
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB,
    last_login_time DATETIME,
    is_deleted BOOLEAN
);

insert into  users(id,username,password)
values(1, 'user', 'user'),
(2, 'user', 'user'),
(3, 'user', 'user'),
(4, 'user', 'user'),
(5, 'user', 'user');

-- 8
alter table users
drop  primary key,
add constraint pk_user
primary key(id,username); 

-- 9
alter table users
change  last_login_time
last_login_time datetime default now();

-- 10
alter table users
drop primary key,
add constraint pk_user
primary key (id);

alter table users
change column username
username varchar(30) unique;

-- 11
create database Movies;
use Movies;

create table directors(
id int primary key auto_increment,
director_name varchar(50) not null,
notes varchar(250)
);
create table genres(
id int primary key auto_increment,
genre_name varchar(25) not null,
notes varchar(250)
);
create table categories(
id int primary key auto_increment,
category_name varchar(30) not null,
notes varchar(250) 
);
create table movies (
id int primary key auto_increment, 
title varchar(30) not null,
director_id int, 
copyright_year year , 
length double(5,3) , 
genre_id int, 
category_id int, 
rating double(3,1), 
notes varchar(250),
foreign key fk_movies_directors (director_id)
references directors (id),
foreign key fk_movies_genre (genre_id )
references genres(id),
foreign key fk_movies_categories (category_id)
references categories(id)

);

insert into directors(id, director_name)
values
(1,'director'),
(2,'director'),
(3,'director'),
(4,'director'),
(5,'director');

insert into genres (id,genre_name)
values
(1,'horror'),
(2,'horror'),
(3,'horror'),
(4,'horror'),
(5,'horror');

insert into categories(id,category_name)
values 
(1,'horror'),
(2,'horror'),
(3,'horror'),
(4,'horror'),
(5,'horror');

insert into movies(id,title,director_id,genre_id ,category_id )
values
(1,'test',1,1,1) ,
(2,'test',2,2,2) ,
(3,'test',3,3,3) ,
(4,'test',4,4,4) ,
(5,'test',5,5,5) ;

 -- 12
 create database car_renta;
 use car_renta;
 
 create table categories(
 id int primary key auto_increment,
 category varchar(20),
 daily_rate double(5,2) not null, 
 weekly_rate double(5,2) not null, 
 monthly_rate double(5,2) not null, 
 weekend_rated  double(5,2) not null
 );
 create table cars(
 id int primary key auto_increment,
 plate_number varchar(10) not null,
 make varchar(20) not null , 
 model varchar(20) not null, 
 car_year year, 
 category_id int, 
 doors int(1), 
 picture blob, 
 car_condition varchar(200) not null,
 available boolean,
 foreign key fk_categories_cars (category_id)
 references categories(id)
 );
create table employees(
id int primary key auto_increment,
first_name varchar (30) not null, 
last_name varchar (30) not null,
 title varchar(20),
 notes varchar(200)
);
create table customers(
id int primary key auto_increment,
driver_licence_number varchar(10) not null,
full_name varchar(50) not null,
address varchar(50), 
city varchar (30),
zip_code varchar(4), 
notes varchar(250)
);
create table rental_orders (
id int primary key auto_increment, 
employee_id int, 
customer_id int, 
car_id int, 
car_condition varchar(200),
 tank_level int ,
kilometrage_start  int(6) not null, 
kilometrage_end int(6) not null, 
total_kilometrage  int ,
 start_date date, 
 end_date date,
 total_days int,
 rate_applied double, 
 tax_rate double (5,2), 
 order_status varchar(10), 
 notes varchar(250),
 foreign key fk_orders_employees (employee_id)
 references employees(id),
 foreign key fk_order_customers (customer_id)
 references customers(id),
 foreign key fk_order_cars (car_id)
 references cars(id)
 );
 insert into categories(id, daily_rate, weekly_rate, monthly_rate, weekend_rated)
 values
 (1,5.0,5.0,5.0,5.0),
 (2,5,5,5,5),
 (3,5,5,5,5);
 
 insert into cars(id, plate_number, make, model,  category_id,car_condition)
 values
 (1, 'hgfh','jhgfjg','kgk',1,'kljh'),
 (2, 'hgfh','jhgfjg','kgk',2,'kljh'),
 (3, 'hgfh','jhgfjg','kgk',3,'kljh');
 insert into employees(id, first_name, last_name)
 values
 (1,'test','test'),
 (2,'test','test'),
 (3,'test','test');
 insert into customers (id, driver_licence_number, full_name)
 values
  (1,'test','test'),
 (2,'test','test'),
 (3,'test','test');
 insert into rental_orders (id, employee_id, customer_id, car_id, kilometrage_start, kilometrage_end)
 values
 (1,1,1,1,6,6),
 (2,2,2,2,7,7),
 (3,3,3,3,8,8);
 
 -- 13
 create database soft_uni;
 use soft_uni;
 
 create table towns (
 id int primary key auto_increment, 
 name varchar(20)
 );
 create table addresses (
 id int primary key auto_increment, 
 address_text varchar(30), 
 town_id int,
 foreign key fk_towns_adressess (town_id)
 references towns(id)
 );
 create table departments (
 id int primary key auto_increment,
 name varchar(30)
 );
 create table employees (
 id int primary key auto_increment,
 first_name varchar(30) not null, 
 middle_name varchar(30) not null, 
 last_name varchar(30) not null, 
 job_title varchar(30) not null, 
 department_id int, 
 hire_date date, 
 salary double(6,2), 
 address_id int,
 foreign key fk_employees_department (department_id)
 references departments(id),
 foreign key fk_adresses_employees (address_id)
 references addresses(id)
 );

insert into towns(name)
values('Sofia'),('Plovdiv'),( 'Varna'), ('Burgas');

insert into departments (name)
values
('Engineering'),(' Sales'),(' Marketing'),('Software Development'),('Quality Assurance'); 

insert into employees(first_name ,  middle_name, last_name ,  job_title ,  department_id ,  hire_date ,  salary )
values
('Ivan','Ivanov','Ivanov','.NET Developer',4, '2013-02-01', 3500.00),
('Petar','Petrov',' Petrov', 'Senior Engineer',1, '2004-03-02', 4000.00),
('Maria',' Petrova' ,' Ivanova' ,' Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev' ,'Ivanov' ,'CEO', 2, '2007-12-09' ,3000.00),
('Peter',' Pan', ' Pan',' Intern',3, '2016-08-28', 599.88);

 -- 14.15 
select * from towns as t order by t.name;
select * from departments as d order by d.name;
select * from employees as e order by e.salary desc;

-- 16
select towns.name from towns as t order by t.name;
select departments.name from departments as d order by d.name;
select employees.first_name, last_name, job_title, salary from employees as e order by e.salary desc; 

-- 17
use soft_uni;

update employees
set salary= salary*1.1;
select salary from employees; 
