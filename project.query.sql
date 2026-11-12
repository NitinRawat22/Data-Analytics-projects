drop table if exists Books;
create table Books (
Book_ID serial primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int
);

drop table if exists Customers;
create table Customers(
Customer_ID serial primary key,
Name varchar(100),
Email varchar(100),
Phone varchar(15),
City varchar(50),
Country varchar(150)
);

drop table if exists Orders;
create table Orders(
Order_ID serial primary key,
Customer_ID int references Customers(Customer_ID),
Book_ID int references Books(Book_ID),
Order_Date date,
Quantity int,
Total_Amount numeric(10,2)
);

select * from Books;
select * from Customers;
select * from Orders;

--importing data
copy Books (Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
from 'C:\Users\JATIN RAWAT\OneDrive\Desktop\New\Books.csv'
csv header;

COPY Customers(Customer_ID,Name,Email,Phone,City,Country)
from 'C:\Users\JATIN RAWAT\OneDrive\Desktop\New\Customers.csv'
csv header;

copy Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'C:\Users\JATIN RAWAT\OneDrive\Desktop\New\Orders.csv'
csv header;

--basic question
--1 
select *
from Books
where genre = 'Fiction';

--2
select * from Books
where published_year> 1950;

--3
select * from Customers
where Country = 'Canada';
--4
select * from Orders
where order_date >= '2023-11-01' and order_date <= '2023-11-30';
--order_date between '2023-11-01' and order_date '2023-11-30';
--5
select sum(stock) as total_stock from Books;
--6
select * from Books
order by Price desc
limit 1;
--7
select *from Orders
where quantity > 0;
--8
select * from Orders
where total_amount > 20;
--9
select distinct(genre) from Books;
--10
select * from Books
order by stock asc
limit 5;
--11
select sum(total_amount) from Orders;
--advance
--1 total number of books sold for each genre
Select b.genre, sum(o.quantity)
from  orders o 
join books b
on o.Book_ID = b.book_ID
group by genre;
--2 find the avg price of the books in the "fantasy" genre
select avg(price) as avg_price from Books
where genre = 'Fantasy';

select * from Books;
select * from Customers;
select * from Orders;
--3 list customers who have placed at least 2 orders
select c.name,o.customer_ID,count(o.order_ID) as order_count
from orders o join customers c
on o.customer_ID = c.customer_ID
group by o.customer_id,c.name
having count(o.order_ID) >= 2;

select customer_id,count(order_id) as order_cont
from orders
group by customer_id
having count(order_id) >= 2;
--4 find the most frequently ordered book
select book_id, count(order_id) as frequently_ordered
from orders
group by book_id
order by count(order_id) desc;

select o.book_id,b.title, count(o.order_id) as frequently_ordered
from orders o join books b
on o.book_id = b.book_id
group by o.book_id,b.title
order by count(o.order_id) desc;
--5 show the top 3 most expensive book of fantasy genre
select * from books
where genre = 'Fantasy'
order by price desc
limit 3;
--6 retreive the total qunty of books sold by each author
select b.author,sum(o.quantity) as total_sold
from orders o join books b
on o.book_ID = b.book_ID
group by b.author;
--7 list the cities where customers who spend over 30 are located;
select distinct c.city , o.total_amount  
from orders o join customers c
on o.customer_ID = c.customer_ID
where o.total_amount > 30;
--8 list the customers who spend most on orders
select c.name,c.customer_ID , sum(o.total_amount) as total_spend 
from orders o join customers c
on o.customer_ID = c.customer_ID
group by c.customer_ID , c.name
order by total_spend desc;
--9 calulate the stock remaning after fulfilling all orders
select b.book_ID , b.title, b.stock , coalesce(sum(o.quantity),0) as quantity_ordered,
b.stock - coalesce(sum(o.quantity),0) as remaning_stock
from books b left join orders o
on b.book_ID = o.book_ID
group by b.book_ID order by b.book_ID;
