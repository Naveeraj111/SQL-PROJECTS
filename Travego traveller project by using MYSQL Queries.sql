                                               --   TRAVEGO TRAVELLER 

-- 1. a. Create a schema named Travego and create the tables mentioned above with the mentioned
-- column names. Also, declare the relevant datatypes for each feature/column in the dataset

create database Travego;

-- creating the passenger table... 
create table passenger(Passenger_id  int8,
Passenger_name varchar(80),
Category char(10),
Gender char(10),
Boarding_City varchar(50),
Destination_City varchar(50),
Distance int4,
Bus_Type varchar(30));


-- creating the Price table.. 

create table Price ( id int8, bus_type varchar(30),Distance int4,Price int4);


-- 1. b. Insert the data in the newly created tables

-- Insert the values into passenger table... 

insert into passenger values (1, 'Sejal', 'AC', 'F', 'Bengaluru', 'Chennai', 350, 'Sleeper'),
(2, 'Anmol', 'Non-AC', 'M', 'Mumbai', 'Hyderabad', '700', 'Sitting'),
(3, 'Pallavi', 'AC', 'F', 'Panaji', 'Bengaluru', '600', 'Sleeper'),
(4, 'Khusboo', 'AC', 'F', 'Chennai', 'Mumbai', '1500', 'Sleeper'),
(5, 'Udit', 'Non-AC', 'M', 'Trivandrum', 'Panaji', '1000', 'Sleeper'),
(6, 'Ankur', 'AC', 'M', 'Nagpur', 'Hyderabad', '500', 'Sitting'),
(7, 'Hemant', 'Non-AC', 'M', 'Panaji', 'Mumbai', '700', 'Sleeper'),
(8, 'Manish', 'Non-AC', 'M', 'Hyderabad', 'Bengaluru', '500', 'Sitting'),
(9, 'Piyush', 'AC', 'M', 'Pune', 'Nagpur', '700', 'Sitting');

-- inserting the value into the Price Table... 
insert into Price value(1, 'Sleeper', 350, 770),
(2, 'Sleeper', 500, 1100),
(3, 'Sleeper', 600, 1320),
(4, 'Sleeper', 700, 1540),
(5, 'Sleeper', 1000, 2200),
(6, 'Sleeper', 1200, 2640),
(7, 'Sleeper', 1500, 2700),
(8, 'Sitting', 500 ,620),
(9, 'Sitting', 600, 744),
(10, 'Sitting', 700, 868),
(11, 'Sitting', 1000, 1240),
(12, 'Sitting', 1200, 1488),
(13, 'Sitting', 1500, 1860);

select * from price;
select * from passenger;

-- 2. a. How many female passengers traveled a minimum distance of 600 KMs?

select count(passenger_name) 
from passenger
 where gender like "F" and distance>600;

-- b. Write a query to display the passenger details whose travel distance is greater than 500 and
-- who are traveling in a sleeper bus. 

SELECT *
FROM passenger
WHERE distance > 500
AND bus_type = 'sleeper';

-- c. Select passenger names whose names start with the character 'S'

SELECT passenger_name
FROM passenger
WHERE passenger_name LIKE 'S%';

-- d. Calculate the price charged for each passenger, displaying the Passenger name, Boarding City,
-- Destination City, Bus type, and Price in the output

select a.passenger_name,a.Boarding_city,Destination_city,a.Bus_type,price
 from passenger a 
 join price b 
 on a.passenger_id=b.id;

-- e. What are the passenger name(s) and the ticket price for those who traveled 1000 KMs Sitting in
-- a bus?
select a.passenger_name,b.price 
from passenger a 
join price b
 on a.passenger_id=b.id 
 where a.distance=1000 and a.bus_type="Sitting";

  -- f.What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji?
  
select a.passenger_name,b.bus_type, b.price
from passenger a 
join price b
on a.passenger_id = b.id 
where a.Boarding_City='panaji' and a.Destination_City= 'bengaluru' and b.bus_type in ('Sitting','sleeper');

-- g.Alter the column category with the value "Non-AC" where the Bus_Type is sleeper

UPDATE passenger
SET category = 'Non-AC'
WHERE Bus_Type = 'sleeper';

-- h. Delete an entry from the table where the passenger name is Piyush and commit this change in
-- the database

DELETE FROM passenger
WHERE passenger_name = 'Piyush';
COMMIT;

select * from passenger;

-- i. Truncate the table passenger and comment on the number of rows in the table (explain if
-- required).

TRUNCATE TABLE passenger;
select * from passenger;         -- There is no any rows are left here...Only the schema  left... 


-- j. Delete the table passenger from the database.
drop table passenger;
