
CREATE DATABASE Car_Dealership;

USE Car_Dealership;

-- Table for Dealership Branch Information
CREATE TABLE Dealership_branch (
  branch_name VARCHAR(20) PRIMARY KEY,
  branch_address VARCHAR(30),
  branch_city VARCHAR(15),
  branch_state VARCHAR(5),
  branch_revenue DECIMAL(15, 2)
);

-- Table for Sales Associate Information
CREATE TABLE Sales_associate (
  salesassociate_id INT PRIMARY KEY AUTO_INCREMENT,
  salesassociate_name VARCHAR(50),
  salesassociate_number VARCHAR(15),
  salesassociate_salary DECIMAL(10, 2),
  branch_name VARCHAR(20),
  FOREIGN KEY (branch_name) REFERENCES Dealership_branch(branch_name)
);

-- Table for Customer Information
CREATE TABLE Customer (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(50),
  customer_number VARCHAR(15),
  customer_address VARCHAR(50),
  customer_state VARCHAR(5)
);

-- Table for Cars Information
CREATE TABLE Cars (
  car_id INT PRIMARY KEY AUTO_INCREMENT,
  make VARCHAR(20),
  model VARCHAR(20),
  year INT,
  mileage INT,
  price DECIMAL(10, 2)
);

-- Table for Cars Sold
CREATE TABLE Cars_sold (
  sale_id INT PRIMARY KEY AUTO_INCREMENT,
  car_id INT,
  customer_id INT,
  salesassociate_id INT,
  sale_price DECIMAL(10, 2),
  sale_date DATE,
  FOREIGN KEY (car_id) REFERENCES Cars(car_id),
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
  FOREIGN KEY (salesassociate_id) REFERENCES Sales_associate(salesassociate_id)
);
USE Car_Dealership;

-- Insert data into Dealership_branch table
INSERT INTO Dealership_branch (branch_name, branch_address, branch_city, branch_state, branch_revenue)
VALUES
('Main Branch', '123 Main St', 'Metropolis', 'NY', 1000000.00),
('Downtown Branch', '456 Market St', 'Gotham', 'NJ', 750000.00),
('Uptown Branch', '789 Elm St', 'Star City', 'CA', 500000.00);

-- Insert data into Sales_associate table
INSERT INTO Sales_associate (salesassociate_name, salesassociate_number, salesassociate_salary, branch_name)
VALUES
('John Doe', '555-1234', 60000.00, 'Main Branch'),
('Jane Smith', '555-5678', 55000.00, 'Downtown Branch'),
('Bob Johnson', '555-9876', 50000.00, 'Uptown Branch');

-- Insert data into Customer table
INSERT INTO Customer (customer_name, customer_number, customer_address, customer_state)
VALUES
('Alice Brown', '555-4321', '101 Oak St', 'NY'),
('Charlie Green', '555-8765', '202 Pine St', 'NJ'),
('Diana Prince', '555-6543', '303 Cedar St', 'CA');

-- Insert data into Cars table
INSERT INTO Cars (make, model, year, mileage, price)
VALUES
('Toyota', 'Camry', 2020, 15000, 22000.00),
('Honda', 'Accord', 2019, 20000, 20000.00),
('Ford', 'Mustang', 2021, 5000, 35000.00);

-- Insert data into Cars_sold table
INSERT INTO Cars_sold (car_id, customer_id, salesassociate_id, sale_price, sale_date)
VALUES
(1, 1, 1, 21000.00, '2023-10-01'),
(2, 2, 2, 19500.00, '2023-10-10'),
(3, 3, 3, 34000.00, '2023-10-15');

SELECT C.make, C.model, C.year, C.mileage, C.price
FROM Cars C
JOIN Sales_associate SA ON C.car_id = SA.salesassociate_id
JOIN Dealership_branch DB ON SA.branch_name = DB.branch_name
WHERE DB.branch_name = 'Main Branch' 
AND C.car_id NOT IN (SELECT car_id FROM Cars_sold);

SELECT C.make, C.model, C.year, CS.sale_price, CS.sale_date
FROM Cars C
JOIN Cars_sold CS ON C.car_id = CS.car_id
WHERE CS.sale_price < 20000;

SELECT C.make, C.model, C.year, CS.sale_date
FROM Cars C
JOIN Cars_sold CS ON C.car_id = CS.car_id
JOIN Customer CU ON CS.customer_id = CU.customer_id
WHERE CU.customer_name = 'Alice Brown';

SELECT DB.branch_name, SUM(CS.sale_price) AS total_revenue
FROM Cars_sold CS
JOIN Sales_associate SA ON CS.salesassociate_id = SA.salesassociate_id
JOIN Dealership_branch DB ON SA.branch_name = DB.branch_name
GROUP BY DB.branch_name
ORDER BY total_revenue DESC
LIMIT 1;
