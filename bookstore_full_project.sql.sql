--Create Database

CREATE DATABASE OnlineBookstore;

--Switch to the database
\c OnlineBookstore;

--Create Tables

DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

SELECT * FROM Books;

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(50),
	City VARCHAR(50),
	Country VARCHAR(150)
);

SELECT * FROM Customers;


DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);


SELECT * FROM Orders;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


--PROJECT
--Basic Queries

--1) Retrieve all books in the "Fiction" genre

SELECT title, genre
FROM Books
WHERE genre = 'Fiction';

--2) Find books published after the year 1950

SELECT title, published_year
FROM Books
WHERE published_year >= 1950;

--3) List all customers from Canada

SELECT name, country
FROM Customers
WHERE country = 'Canada';

--4) Show orders placed in November 2023

SELECT order_id, order_date
FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of books available

SELECT SUM(stock) AS Total_Stock_of_Books
FROM Books;


--6) Find the details of the most expensive book

SELECT title, author, genre, price
FROM Books
ORDER BY price DESC
LIMIT 1;

--7) Show all customers who ordered more than 1 quantity of a book

SELECT *
FROM Orders
WHERE quantity >=1;

--8) Retrieve all orders where the total amount exceeds $20

SELECT order_id, total_amount
FROM Orders
WHERE total_amount >= 20;

--9) List all genres available in the Books table

SELECT DISTINCT genre
FROM Books;

--10) Find the book with the lowest stock

SELECT title, stock
FROM Books
ORDER BY stock
LIMIT 1;

--11) Calculate the total revenue generated from all orders

SELECT SUM(total_amount) AS Total_Revenue
FROM Orders;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


--Advance Queries

--1) Retrieve the total number of books sold for each genre

SELECT b.genre, SUM(o.quantity)
FROM Books b
JOIN Orders o
ON o.book_id = b.book_id
GROUP BY b.genre;

--2) Find the average price of books in the "Fantasy" genre

SELECT AVG(price) AS Average_Price, genre
FROM Books
WHERE genre = 'Fantasy'
GROUP BY genre;


--3) List customers who have placed at least 2 orders

SELECT o.customer_id, c.name, COUNT(o.order_id) AS Order_Count
FROM Orders o
JOIN Customers c
ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(o.order_id) >=2;

--4) Find the most frequently ordered book

SELECT o.book_id, b.title, COUNT(o.order_id) AS Book_Count
FROM Orders o
JOIN Books b
ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
ORDER BY Book_Count DESC
LIMIT 1;

--5) Show the top 3 most expensive books of the 'Fantasy' Genre

SELECT  title, genre, price
FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

--6) Retrieve the total quantity of books sold by each author

SELECT b.author, sum(o.quantity) AS Books_Sold
FROM Books b
JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.author;


--7) List the cities where customers who spent over $30 are located

SELECT c.city, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 30;



--8) Find the customer who spent the most on orders

SELECT c.name, sum(total_amount) AS Total_Amount
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY Total_Amount DESC
LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders

SELECT b.Book_ID, b.Title, b.Stock AS original_stock,
    COALESCE(SUM(o.Quantity), 0) AS total_sold,
    (b.Stock - COALESCE(SUM(o.Quantity), 0)) AS remaining_stock
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;
