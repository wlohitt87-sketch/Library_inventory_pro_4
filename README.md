# Library_inventory

## Introduction

The Library Inventory Analysis project focuses on understanding the utilization, demand, and management of a library’s book inventory. By analyzing inventory data, the goal is to uncover insights that help in optimizing book procurement, circulation, and resource allocation.The entire project based on SQL Server. 

### 1.Creating a Database to store data

**Database Name**: Library_project_4

### 2.Data Exlopration and Cleaning 
```
SELECT COUNT (*)
FROM [dbo].[books] 
```
### 3. CRUD Operation

-- **Task: Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"**

INSERT INTO books (isbn,book_title,category,rental_price,status,author,publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co')
```
SELECT * FROM books
```
--**Task: Update an Existing Member's Address**
```
UPDATE members
SET member_address = '130 Main St'
WHERE member_id = 'C101'
```
--**Task: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS107' from the issued_status table.**
```
DELETE FROM issued_status
WHERE issued_id = 'IS107'
```
### 4. CTAS (Create Table As Select)

--**Task: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
```
SELECT b.isbn, 
	   b.book_title, 
	   COUNT(ist.issued_id) AS issue_count
FROM books b
JOIN issued_status ist
ON b.isbn = ist.issued_book_isbn
GROUP BY b.isbn, b.book_title
```
### 5. Data Analysis & Findings

-- **Task: Retrieve All Books in a Specific Category**
```
SELECT * FROM books
WHERE category = 'Classic'
```
--**Task: Find Total Rental Income by Category.**
```
SELECT b.category,
	   SUM(b.rental_price) AS Tot_rental_income,
	   COUNT(*) AS no_time_purchased
FROM books b
JOIN issued_status ist
ON b.isbn = ist.issued_book_isbn
GROUP BY category
```
### Advanced SQL Operations

**Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member_id, member's name, book title, issue date, and days overdue.**

--**issued_status == members== books==return_status
--filter books which is return
-- overdue > 30**
```
SELECT 
    ist.issued_member_id,
    m.member_name,
    b.book_title,
    ist.issued_date,
    rs.return_date,
    DATEDIFF(DAY, ist.issued_date, GETDATE()) AS Overdue_days
FROM 
    issued_status ist
JOIN 
    members m ON ist.issued_member_id = m.member_id
JOIN 
    books b ON ist.issued_book_isbn = b.isbn
LEFT JOIN 
    return_status rs ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND DATEDIFF(DAY, ist.issued_date, GETDATE()) > 30;
```
## Conclusion
Actionable insights into user engagement, inventory efficiency, and book circulation trends are offered by this library inventory analysis. The study facilitates improved decision-making about collection development, resource allocation, and library service optimization since structured data is saved and searched in SQL Server.
