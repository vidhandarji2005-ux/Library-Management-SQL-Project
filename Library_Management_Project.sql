-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'D:\SQL_Resume_Project-main\SQL_Resume_Project-main\Books.csv' 
CSV HEADER;


-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\SQL_Resume_Project-main\SQL_Resume_Project-main\Customers.csv'
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'D:\SQL_Resume_Project-main\SQL_Resume_Project-main\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books
WHERE genre = 'Fiction';

-- 2) Find books published after the year 1950:

SELECT * FROM Books
WHERE Published_Year > 1950;

-- 3) List all customers from the Canada:

SELECT * FROM Customers
WHERE country = 'Canada';
 
-- 4) Show orders placed in November 2023:

SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT SUM(stock ) AS Total_Stock
FROM Books;

SELECT COUNT(stock ) AS Total_Stock
FROM Books;

-- 6) Find the details of the most expensive book:

SELECT * FROM Books AS Expensive_Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 3 quantity of a book:

SELECT * FROM Orders
WHERE quantity > 3;

-- 8) Retrieve all orders where the total amount exceeds $50:

SELECT * FROM Orders
WHERE total_amount > 50;

-- 9) List all genres available in the Books table:

SELECT DISTINCT genre from Books;


-- 10) Find the book with the lowest stock:

SELECT * FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- OR 

SELECT Book_ID, Title, Stock
FROM Books
WHERE Stock < 10
ORDER BY Stock ASC;

-- 11) Calculate the total revenue generated from all orders:

SELECT SUM(total_amount) AS Total_Revenue 
FROM Orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT * FROM Orders;

SELECT b.genre , SUM(o.quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
Group by genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT ROUND(AVG(Price),2) AS Average_price
FROM Books
Where genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT o.customer_id,c.name,COUNT(o.order_id) AS Customers_Orders_Count
FROM Orders o
JOIN Customers c ON o.Customer_id = c.Customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(o.order_id) >= 2 



-- 4) Find the most frequently ordered book:

SELECT book_id,COUNT(order_id) AS Order_Count
FROM Orders
GROUP BY book_id
ORDER BY Order_Count DESC;

-- OR

SELECT b.book_id,b.title,COUNT(o.order_id) AS Order_Count
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.book_id,b.title
ORDER BY Order_Count DESC 
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT title,price AS Expensive_Books
FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author,SUM(o.quantity) AS Total_Books_Sold_By_Author
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.author;

-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city,o.total_amount AS Citywise_customers_Spent_rupees
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.total_amount >30;

-- 8) Find the customer who spent the most on orders:

SELECT c.customer_id,c.name,SUM(o.total_amount) AS Total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY Total_spent DESC
LIMIT 1;


-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id , b.title , b.stock , COALESCE(SUM(quantity),0) AS Order_Quality,
b.stock-COALESCE(SUM(quantity),0) AS Remaining_Quantity
FROM Books b
LEFT JOIN Orders o ON b.book_id=o.book_id
GROUP BY b.book_id;


--Books Related Bussiness Problem Queries

-- 1) Find Top 10 Most Expensive Books

SELECT title , author , price
FROM Books
Order BY price DESC
LIMIT 10;

-- 2) Find Low Stock Books

SELECT Book_ID, Title, Stock
FROM Books
WHERE Stock < 10
ORDER BY Stock ASC;

-- 3) Calculate Total Inventory Value

SELECT SUM(Price * Stock) AS Total_Inventory_Value
FROM Books;

-- 4) Find Top 5 Authors with Highest Number of Books

SELECT author,COUNT(*) AS Total_Books
FROM Books
GROUP BY author
ORDER BY Total_Books DESC
LIMIT 5;

-- 5) Find Oldest Published Books

SELECT title , author , published_year AS Oldest_Books
FROM Books
ORDER BY published_year ASC
LIMIT 10;

-- 6) Find Genre with Highest Total Stock

SELECT genre,SUM(Stock) AS Total_Stock
FROM Books
Group BY genre
ORDER BY Total_Stock DESC;

-- 7) Find Books Published After 2000 with High Price

SELECT Title, Author, Published_Year, Price
FROM Books
WHERE Published_Year > 2000
AND Price > 30
ORDER BY Price DESC;

-- 8)Find Highest Inventory Value Books

SELECT 
    Title,
    Price,
    Stock,
    (Price * Stock) AS Inventory_Value
FROM Books
ORDER BY Inventory_Value DESC
LIMIT 10;

-- 9) Find Genre-wise Average Book Price

SELECT Genre,ROUND(AVG(Price),2) AS Avg_Price
FROM Books
GROUP BY Genre
ORDER BY Avg_Price DESC;


-- 10) Find Out-of-Stock Risk Books


SELECT Title,Stock,
    CASE
        WHEN Stock <= 5 THEN 'Critical'
        WHEN Stock <= 15 THEN 'Warning'
        ELSE 'Safe'
    END AS Stock_Status
FROM Books
ORDER BY Stock ASC;


--Customer Related Bussiness Problem Queries


--1). Find Total Number of Customers

SELECT COUNT(*) AS Total_Customers
FROM Customers;


--2). Find Top 10 Countries with Most Customers

SELECT Country,COUNT(*) AS Total_Customers
FROM Customers
GROUP BY Country
ORDER BY Total_Customers DESC
LIMIT 10;


--3). Find Cities with Highest Customers

SELECT City,COUNT(*) AS Customer_Count
FROM Customers
GROUP BY City
ORDER BY Customer_Count DESC
LIMIT 10;

--4). Find Duplicate Customer Names

SELECT Name,COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY name
HAVING COUNT(*) > 1;

--5). Find Gmail Users

SELECT * FROM Customers
WHERE Email LIKE '%gmail.com';

--6). Count Customers Country-wise

SELECT Country,COUNT(Customer_ID) AS Total_Customers
FROM Customers
GROUP BY Country
ORDER BY Total_Customers DESC;

--7). Find Customers from Specific Country

SELECT * FROM Customers
WHERE Country = 'India';

--8). Find Customers with Yahoo Emails

SELECT Name, Email
FROM Customers
WHERE Email LIKE '%yahoo.com';

--9). Find Unique Countries Served

SELECT COUNT(DISTINCT Country) AS Unique_Countries
FROM Customers;

--10). Find Country with Least Customers

SELECT Country,COUNT(*) AS Total_Customers
FROM Customers
GROUP BY Country
ORDER BY Total_Customers ASC
LIMIT 5;






