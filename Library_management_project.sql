CREATE DATABASE library;

-- creating table "branch"
drop table if exists branch;
create table branch(
branch_id varchar(10) primary key,
manager_id varchar(10),
branch_address varchar(30),
contact_no varchar(15));

-- creating table "employees"
drop table if exists employees;
create table employees(
emp_id varchar(10) primary key,
emp_name varchar(30),
position varchar(30),
salary decimal,
branch_id varchar(10),
foreign key (branch_id) references branch(branch_id)
);

-- creating table "members"
drop table if exists members;
create table members(
member_id varchar(10) primary key,
member_name varchar(30),
member_address varchar(30),
reg_date date
);

-- Create table "Books"
drop table if exists books;
create table books(
isbn VARCHAR(50) PRIMARY KEY,
book_title VARCHAR(80),
category VARCHAR(30),
rental_price DECIMAL(10,2),
status VARCHAR(10),
author VARCHAR(30),
publisher VARCHAR(30)
);

-- Create table "IssueStatus"
drop table if exists issued_status;
create table issued_status(
issued_id VARCHAR(10) PRIMARY KEY,
issued_member_id VARCHAR(30),
issued_book_name VARCHAR(80),
issued_date DATE,
issued_book_isbn VARCHAR(50),
issued_emp_id VARCHAR(10),
FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);

-- Create table "ReturnStatus"
drop table if exists return_status;
create table return_status(
return_id VARCHAR(10) PRIMARY KEY,
issued_id VARCHAR(30),
return_book_name VARCHAR(80),
return_date DATE,
return_book_isbn VARCHAR(50),
FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

select * from books;
select * from branch;
select * from employees;
select * from members;
select * from return_status;
select * from issued_status;


-- 1. Create a New Book Record -- ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.').
delete from books where isbn = '978-1-60129-456-2';
insert into books(isbn, book_title, category, rental_price, status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


-- 2. Update an Existing Member's Address.
update members
set member_address = '125 oak st'
where member_id = 'C103';
select * from members;


-- 3. Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issued_status where issued_id = 'ISI121';
select * from issued_status;


-- 4. Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select issued_book_name from issued_status where issued_emp_id = 'E101';


-- 5. List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id, count(*) from issued_status
group by issued_emp_id
having count(*) > 1;


-- 6. Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt.
create table book_issued_cnt as
select b.isbn, b.book_title,
count(ist.issued_id) as total_issued_count
from books as b
left join issued_status as ist
on b.isbn = ist.issued_book_isbn
group by b.isbn, b.book_title;
select * from book_issued_cnt;


-- 7. Retrieve All Books in a Specific Category.
select * from books where category = 'Fiction';


-- 8. Find Total Rental Income by Category.
select category, sum(rental_price) as total_revenue from books
group by category;


-- 9. List Members Who Registered in the Last 180 Days.
select * from members
where reg_date >= curdate() - interval 180 day;


-- 10. List Employees with Their Branch Manager's Name and their branch details.
select e.emp_id, e.emp_name, b.manager_id, b.branch_id, b.branch_address
from employees as e
join branch as b
on e.branch_id = b.branch_id;


-- 11. Create a Table of Books with Rental Price Above a Certain Threshold.
select * from books where rental_price >= '7';


-- 12. Retrieve the List of Books Not Yet Returned.
select ist.*, rst.return_id, rst.return_date
from issued_status as ist
left join return_status as rst
on ist.issued_id = rst.issued_id
where rst.return_id is null;