--Library Management System Project 4

--  ### 1. CREATING DATABASE

-- DATABASE NAME 'Library_project_4'

-- Importing data into Database

--Project Task 

-- ### 2. CRUD Operations

--Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books (isbn,book_title,category,rental_price,status,author,publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co')

SELECT * FROM books

--Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '130 Main St'
WHERE member_id = 'C101'

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS107' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS107'

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * 
FROM issued_status
WHERE issued_emp_id = 'E101'

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
	issued_emp_id,
	COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt


SELECT b.isbn, 
	   b.book_title, 
	   COUNT(ist.issued_id) AS issue_count
FROM books b
JOIN issued_status ist
ON b.isbn = ist.issued_book_isbn
GROUP BY b.isbn, b.book_title


-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic'

-- Task 8: Find Total Rental Income by Category.

SELECT b.category,
	   SUM(b.rental_price) AS Tot_rental_income,
	   COUNT(*) AS no_time_purchased
FROM books b
JOIN issued_status ist
ON b.isbn = ist.issued_book_isbn
GROUP BY category

--- Task 9. List Members Who Registered in the Last 180 Days

SELECT *
FROM members
WHERE reg_date >= DATEADD(DAY, -180, GETDATE())

-- Task 10: List Employees with Their Branch Manager's Name and their branch details

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7 USD

SELECT * 
FROM books
WHERE rental_price > '7'

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status ist
LEFT JOIN return_status rst
ON ist.issued_id = rst.issued_id
WHERE rst.return_id IS NULL

--### Advanced SQL Operations

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member_id, member's name, book title, issue date, and days overdue.
*/

-- issued_status == members== books==return_status
--filter books which is return
-- overdue > 30


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

-- END OF THE PROJECT