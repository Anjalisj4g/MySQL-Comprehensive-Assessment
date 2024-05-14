# Creating Datadase
create database LIBRARY;
use library;
#Creating Tables
create table BRANCH (
branch_no int primary key,
manager_id int,
branch_address varchar(50),
contact_no int
);

insert into BRANCH values (010, 1001, 'Trivandrum', 11111), (020, 1002, 'Kochi', 22222),
(030, 1003, 'Thrissur', 33333), (040, 1004, 'Kozhikode', 44444), 
(050, 1005, 'Idukki', 55555) ;
select * from branch;

create table EMPLOYEE (
emp_id int auto_increment primary key,
emp_name varchar(20),
position varchar(15),
salary float,
branch_no int,
foreign key(branch_no) references branch(branch_no) on delete cascade
);

insert into EMPLOYEE (emp_name, position, salary, branch_no) values ('Anjali','Analyst',45000,010),
('Aiswarya','Librarian',35000,020), ('Sushma','Cleaner',10000,030), ('Lincy','Accountant',30000,040), 
('Neethu','Clerk',25000,050);
insert into EMPLOYEE (emp_name, position, salary, branch_no) values ('Rakhi','Analyst',55000,010),
('Gargi','Developer',65000,020), ('Soumya','Accountant',50000,050),
('Govind','Clerk',35000,020);
insert into EMPLOYEE (emp_name, position, salary, branch_no) values ('Rahul','StoreKeeper',25000,020),
('Vineeth','Assistant',24000,020), ('Avinash','Manager',70000,020);
select * from employee;

create table BOOKS (
ISBN int primary key,
book_title varchar(20),
category varchar(10),
rental_price decimal(10,2),
status enum('yes','no'),
author varchar(20),
publisher varchar(50)
);

insert into BOOKS values (101, 'Harry Potter', 'Fantasy',50,'no', 'JK Rowling','abc'),
(102, 'The Hobbit', 'Fantasy',45,'no', 'JRR Tolkien','abc'),
(103, 'Gone Girl', 'Crime',50,'yes', 'Gillian Flynn','abc'),
(104, 'A Tale Of Two Cities', 'Fiction',50,'yes', 'Charles Dickens','abc'),
(105, 'Jaws', 'Horror',50,'no', 'Peter Benchley','abc') ;
insert into BOOKS values (106, 'ArgumentiveIndian', 'History',20,'yes', 'Amartya Sen','abc');
select * from books ;

create table CUSTOMER (
customer_id int auto_increment primary key,
customer_name varchar(20),
customer_address varchar(100),
reg_date date
);

insert into CUSTOMER values (10001, 'Syam', 'Trivandrum', '2023-06-27');
insert into CUSTOMER (customer_name, customer_address,reg_date) values ('Latha', 'Thrissur', '2023-08-27'),
('Anjitha', 'Thrissur', '2023-04-27'), ('Smitha', 'Kochi', '2023-12-27'), 
('Lovy', 'Kozhikode', '2023-01-27'), ('Prajeetha', 'Idukki', '2023-07-27');
insert into CUSTOMER (customer_name, customer_address,reg_date) values ('Latha', 'Thrissur', '2021-08-27');
select * from customer ;

create table IssueStatus (
issue_id int primary key,
issued_cust int,
issued_book_name varchar(50),
issued_date date,
ISBN_book int,
foreign key(issued_cust) references CUSTOMER(customer_id),
foreign key(ISBN_book) references BOOKS(ISBN)
);

insert into IssueStatus values (001,10002, 'Harry Potter','2024-01-01', 101), 
(002,10006, 'The Hobbit','2024-03-01', 102), (003,10001, 'Harry Potter','2024-02-01', 101),
(004,10003, 'A Tale Of Two Cities','2024-01-11', 104), (005,10005, 'Jaws','2024-02-21', 105),
(006,10002, 'Gone Girl','2024-01-31', 103), (007,10002, 'Gone Girl','2024-03-31', 103) ;
select * from IssueStatus ;

create table ReturnStatus (
return_id int primary key,
return_cust int,
return_book_name varchar(50),
return_date date,
ISBN_book2 int,
foreign key(ISBN_book2) references BOOKS(ISBN) on delete cascade
);

insert into ReturnStatus values (1, 10001, 'Harry Potter', '2024-03-01',101),
(2, 10002, 'Harry Potter', '2024-02-01',101), (3, 10006, 'The Hobbit', '2024-04-01',102),
(4, 10003, 'A Tale of Two Cities', '2024-02-01',104), (5, 10005, 'Jaws', '2024-03-01',105),
(6, 10002, 'Gone Girl', '2024-04-23',103) ;
select * from ReturnStatus ;

-- 1. Retrieve the book title, category, and rental price of all available books. 
select book_title, category, rental_price from books where status = 'yes';

-- 2. List the employee names and their respective salaries in descending order of salary. 
select emp_name, salary from employee order by salary desc;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books. 
select books.book_title, customer.customer_name from books
join IssueStatus on books.isbn = IssueStatus.isbn_book
join customer on IssueStatus.issued_cust = customer.customer_id;

-- 4. Display the total count of books in each category. 
select category, count(*) as 'Total count of books' from books group by category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000.
select emp_name, position from employee where salary > 50000;

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
select customer_name from customer where reg_date < '2022-01-01' and 
customer_id not in (select issued_cust from IssueStatus);

-- 7. Display the branch numbers and the total count of employees in each branch. 
select branch_no, count(*) as 'Total Count of Employees' from employee group by branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
select issued_cust from IssueStatus where issued_date between '2023-06-01' and '2023-06-30';

-- 9. Retrieve book_title from book table containing history.
select book_title from books where category = 'History' ;

-- 10.Retrieve the branch numbers along with the count of employees for branches having more than 5 employees
select branch_no, count(*) as 'Total Employees' from employee group by branch_no having count(*) > 5 ;

-- 11. Retrieve the names of employees who manage branches and their respective branch addresses.
select E.emp_name, B.branch_address from employee E
join branch B on E.emp_id = B.manager_id ;

-- 12.  Display the names of customers who have issued books with a rental price higher than Rs. 25.
select customer.customer_name from customer 
join IssueStatus on customer.customer_id = IssueStatus.issued_cust
join books on IssueStatus.isbn_book = books.isbn
where rental_price > 25 ;
