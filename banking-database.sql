--Banking management System Database
--In this bank db contain these table
-- 1. CUSTOMER
-- 2. ACCOUNT
-- 3. TRANSACTION
-- 4. FUND TRANSFER
-- 5. LOAN
-- 6. LOAN PAYMENT


--Fisrt we create Database

CREATE DATABASE BankingDB;

USE BankingDB;

DROP DATABASE BankingDB;

--1. Create Customer Table 
-- This table store customer details and concept use in this table are primary key, constraints and normalization.
CREATE TABLE Customer(
       customer_Id int Identity(1,1) primary key, --Identity use for autoIncrement
       cust_name varchar(50) not null,
       email varchar(50) unique,
       phone varchar(15) unique,
       Dob date,
       addhar_no bigint unique not null,
       Pan_no varchar(30) unique not null,
       cust_address varchar(300),
);

--2. Create Account table
-- This store All account related to customer
-- show one-to-many relationship (one customer -> multiple accounts)
 CREATE TABLE Account(
        account_no bigint primary key,
        customer_id int not null,
        account_type varchar(15) check(account_type in ('saving' , 'current')),
        balance decimal(18,2)  check (balance >=0),
        createdAt DATETIME2 DEFAULT SYSDATETIME(),

        foreign key (customer_id) 
        references Customer(customer_Id) 
        on delete cascade
        on update cascade
         
 );

-- 3. Create Transaction table
-- store all deposit / withdrawals
-- transaction concept , check constraint and indexing on txn_date.
CREATE TABLE Transactions(
       txn_id varchar(50) primary key,
       account_number bigint not null,
       txn_type varchar(15) not null check(txn_type in ('credit','debit')), --credit/debit
       amount decimal(18,2) check(amount > 0),
       txn_date DATETIME2 DEFAULT SYSDATETIME(),
       description_ varchar(200)
       
       foreign key (account_number)
       references Account(account_no)
       on delete cascade
       on update cascade
);

--4. Create Found Transfer table
-- used to record money transfer between two account
-- self-referencing FK , complex constraints
CREATE TABLE FundTransfer(
       transfer_id bigint identity(1,1)  primary key,
       from_account bigint not null,
       to_account bigint not null,
       amount decimal(18,2) check (amount > 0),
       transfer_time DATETIME2 default SYSDATETIME(),

       foreign key(from_account) 
       references Account(account_no),

       foreign key(to_account)
       references Account(account_no)

);

--5. Create Loan table
-- Loan information for customer
-- another banking feature and relationship
CREATE TABLE Loan(
       loan_id int identity(1,1) primary key,
       customer_id int not null,
       loan_type varchar(50) not null,
       principal_amount decimal(18,2) check(principal_amount > 0),
       interest_rate decimal(5,2),
       issue_date DATETIME2 default SYSDATETIME(),

       foreign key(customer_id)
       references Customer(customer_Id)
       on delete cascade
       on update cascade
);

--6.create loan payment table
-- track EMI payment for loan
-- 
CREATE TABLE Loan_payment(
   payment_id int identity(1,1) primary key,
   loan_id int not null, 
   amount_paid decimal(18,2) check( amount_paid > 0),
   payment_date DATETIME2 default SYSDATETIME()

   foreign key (loan_id)
   references Loan(loan_id)
   on delete cascade
   on update cascade
);


--Insert data into customer table 
INSERT INTO Customer (cust_name, email, phone, Dob, addhar_no, Pan_no, cust_address) VALUES
('Rahul Sharma', 'rahul@gmail.com', '9876543210', '1995-03-15', 123456789012, 'ABCDE1234F', 'Delhi'),
('Priya Verma', 'priya@gmail.com', '9876501234', '1998-07-20', 234567890123, 'PQRSX5678L', 'Mumbai'),
('Amit Kumar', 'amit@gmail.com', '9998887776', '1992-01-10', 345678901234, 'LMNOP3456Q', 'Kolkata'),
('Sneha Singh', 'sneha@gmail.com', '9988776655', '1999-09-25', 456789012345, 'WXYZA7890R', 'Chennai'),
('Himanshu Kumar', 'himanshu@gmail.com', '9123456780', '2001-06-18', 567890123456, 'HIMAN1234K', 'Ranchi'),
('Deepak Yadav', 'deepak@gmail.com', '9456123789', '1994-11-12', 678901234567, 'DEEPA5678T', 'Lucknow'),
('Rohit Gupta', 'rohit@gmail.com', '9876123490', '1997-04-04', 789012345678, 'ROHIT4567Z', 'Pune'),
('Komal Rathore', 'komal@gmail.com', '9988123476', '1996-02-28', 890123456789, 'KOMAL8912Y', 'Jaipur'),
('Arjun Mehta', 'arjun@gmail.com', '9876001122', '1995-12-19', 901234567890, 'ARJUN2345S', 'Ahmedabad'),
('Pooja Mishra', 'pooja@gmail.com', '9800123456', '1993-08-08', 112233445566, 'POOJA9988P', 'Bhopal'),
('Vikas Singh', 'vikas@gmail.com', '9797979797', '1994-05-05', 223344556677, 'VIKAS6677J', 'Patna'),
('Neha Kapoor', 'neha@gmail.com', '9666554433', '1998-10-10', 334455667788, 'NEHA1122A', 'Hyderabad');

--Insert into account table 
INSERT INTO Account(account_no, customer_id, account_type, balance) VALUES
(1010001, 1, 'saving', 25000.00),
(1010002, 2, 'saving', 15000.00),
(1010003, 3, 'current', 52000.00),
(1010004, 4, 'saving', 18000.00),
(1010005, 5, 'current', 75000.00),
(1010006, 6, 'saving', 21000.00),
(1010007, 7, 'current', 90000.00),
(1010008, 8, 'saving', 32000.00),
(1010009, 9, 'saving', 14500.00),
(1010010, 10, 'current', 67000.00),
(1010011, 11, 'saving', 19500.00),
(1010012, 12, 'saving', 28500.00);

--Insert into transaction table 
INSERT INTO Transactions(txn_id, account_number, txn_type, amount, description_) VALUES
('TXN001',1010001,'credit',5000,'Salary credit'),
('TXN002',1010001,'debit',1200,'Mobile recharge'),
('TXN003',1010002,'credit',3000,'UPI received'),
('TXN004',1010003,'debit',8000,'Bill payment'),
('TXN005',1010004,'credit',15000,'Refund'),
('TXN006',1010005,'debit',25000,'Cash withdrawal'),
('TXN007',1010006,'credit',4000,'Transfer received'),
('TXN008',1010007,'debit',6000,'Shopping'),
('TXN009',1010008,'credit',9000,'Bonus'),
('TXN010',1010009,'debit',2000,'Electricity bill'),
('TXN011',1010010,'credit',12000,'Client payment'),
('TXN012',1010012,'debit',3500,'Grocery');

--Insert into Found transfer table 
INSERT INTO FundTransfer(from_account, to_account, amount) VALUES
(1010001, 1010002, 1500.00),
(1010002, 1010003, 2200.00),
(1010003, 1010004, 5000.00),
(1010004, 1010005, 1800.00),
(1010005, 1010006, 7500.00),
(1010006, 1010007, 1300.00),
(1010007, 1010008, 4200.00),
(1010008, 1010009, 900.00),
(1010009, 1010010, 2750.00),
(1010010, 1010011, 3200.00),
(1010011, 1010012, 2100.00),
(1010012, 1010001, 3500.00);

--Insert into Loan table
INSERT INTO Loan (customer_id, loan_type, principal_amount, interest_rate) VALUES
(1,  'Home Loan',        1200000.00, 7.50),
(2,  'Personal Loan',      250000.00, 12.00),
(3,  'Car Loan',           600000.00, 9.10),
(4,  'Education Loan',     450000.00, 8.20),
(5,  'Business Loan',     1500000.00, 10.50),
(6,  'Home Loan',        1800000.00, 7.50),
(7,  'Personal Loan',      300000.00, 12.00),
(8,  'Car Loan',           550000.00, 9.10),
(9,  'Business Loan',      900000.00, 10.50),
(10, 'Education Loan',     380000.00, 8.20),
(11, 'Home Loan',        1400000.00, 7.50),
(12, 'Personal Loan',      220000.00, 12.00);

--Insert into loan_payment table
INSERT INTO Loan_payment (loan_id, amount_paid) VALUES
(1,  25000.00),
(2,  5000.00),
(3,  12000.00),
(4,  8000.00),
(5,  35000.00),
(6,  30000.00),
(7,  6000.00),
(8,  10000.00),
(9,  18000.00),
(10, 7000.00),
(11, 22000.00),
(12, 4000.00);



SELECT * from Customer;

SELECT * from Account;

UPDATE  Customer SET  email = 'rahul12@gmail.com' , cust_name = 'Rahul kumar' WHERE customer_Id = 1;

SELECT * from Customer where customer_Id = 3;

SELECT COUNT(*) AS totalCustomer from Customer;

SELECT * from Customer INNER JOIN Account ON Customer.customer_Id = Account.customer_id WHERE Account.account_no = 1010001;

UPDATE Customer set status = 'Closed' WHERE customer_Id = 3; -- delete the user data but we not want to delete every thing regarding transaction that way used status column and update it .


/* ============================================================
   BANKING SYSTEM QUERIES  
   Based on Tables: Customer, Account, Transactions, FundTransfer,
   Loan, Loan_payment
   ============================================================ */


/* ============================================================
   1. OPEN A NEW CUSTOMER ACCOUNT  
   ============================================================ */

-- Step 1: Add Customer
INSERT INTO Customer (cust_name, email, phone, Dob, addhar_no, Pan_no, cust_address)
VALUES ('Saurav Jaiswal', 'saurav@gmail.com', '9999001122', '1997-05-15',
        889977665544, 'SAURV5678T', 'Delhi');

-- Step 2: Create an account for the new customer
INSERT INTO Account (account_no, customer_id, account_type, balance)
VALUES (1010013, SCOPE_IDENTITY(), 'saving', 5000);



/* ============================================================
   2. CHECK ACCOUNT BALANCE 
   ============================================================ */

SELECT account_no, balance
FROM Account
WHERE account_no = 1010005;



/* ============================================================
   3. DEPOSIT MONEY  
   ============================================================ */

BEGIN TRANSACTION;

-- Add credit transaction record
INSERT INTO Transactions (txn_id, account_number, txn_type, amount, description_)
VALUES ('TXN100', 1010005, 'credit', 8000, 'Cash deposit');

-- Update account balance
UPDATE Account 
SET balance = balance + 8000
WHERE account_no = 1010005;

COMMIT;



/* ============================================================
   4. WITHDRAW MONEY  
   ============================================================ */

BEGIN TRANSACTION;

-- Add debit transaction
INSERT INTO Transactions (txn_id, account_number, txn_type, amount, description_)
VALUES ('TXN101', 1010002, 'debit', 5000, 'ATM withdrawal');

-- Deduct balance
UPDATE Account
SET balance = balance - 5000
WHERE account_no = 1010002;

COMMIT;



/* ============================================================
   5. FUND TRANSFER 
   ============================================================ */

BEGIN TRANSACTION;

-- Save transfer record
INSERT INTO FundTransfer (from_account, to_account, amount)
VALUES (1010001, 1010008, 3000);

-- Deduct from sender
UPDATE Account
SET balance = balance - 3000
WHERE account_no = 1010001;

-- Add to receiver
UPDATE Account
SET balance = balance + 3000
WHERE account_no = 1010008;

-- Log debit transaction
INSERT INTO Transactions (txn_id, account_number, txn_type, amount, description_)
VALUES ('TXN102', 1010001, 'debit', 3000, 'Fund transfer to 1010008');

-- Log credit transaction
INSERT INTO Transactions (txn_id, account_number, txn_type, amount, description_)
VALUES ('TXN103', 1010008, 'credit', 3000, 'Fund transfer from 1010001');

COMMIT;



/* ============================================================
   6. GENERATE ACCOUNT STATEMENT  
   ============================================================ */

SELECT T.txn_date, T.txn_type, T.amount, T.description_
FROM Transactions T
WHERE T.account_number = 1010001
ORDER BY T.txn_date DESC;



/* ============================================================
   7. MINI STATEMENT (Last 5 Transactions)
   ============================================================ */

SELECT TOP 5 *
FROM Transactions
WHERE account_number = 1010001
ORDER BY txn_date DESC;



/* ============================================================
   8. VIEW CUSTOMER PROFILE + ACCOUNTS 
   ============================================================ */

SELECT C.cust_name, C.email, C.phone, C.Pan_no, C.addhar_no,
       A.account_no, A.account_type, A.balance
FROM Customer C
JOIN Account A ON C.customer_Id = A.customer_id
WHERE C.customer_Id = 5;



/* ============================================================
   9. APPLY FOR A LOAN 
   ============================================================ */

INSERT INTO Loan (customer_id, loan_type, principal_amount, interest_rate)
VALUES (5, 'Home Loan', 900000, 7.2);



/* ============================================================
   10. PAY LOAN EMI  
   ============================================================ */

BEGIN TRANSACTION;

INSERT INTO Loan_payment (loan_id, amount_paid)
VALUES (3, 15000);

COMMIT;



/* ============================================================
   11. CHECK LOAN STATUS (Paid vs Remaining Amount)
   ============================================================ */

SELECT 
    L.loan_id,
    L.principal_amount,
    SUM(P.amount_paid) AS total_paid,
    (L.principal_amount - SUM(P.amount_paid)) AS remaining_amount
FROM Loan L
LEFT JOIN Loan_payment P ON L.loan_id = P.loan_id
WHERE L.loan_id = 3
GROUP BY L.loan_id, L.principal_amount;



/* ============================================================
   12. CUSTOMER LOAN LEDGER  
   ============================================================ */

SELECT C.cust_name, L.loan_type, L.principal_amount, 
       P.amount_paid, P.payment_date
FROM Customer C
JOIN Loan L ON C.customer_Id = L.customer_id
LEFT JOIN Loan_payment P ON L.loan_id = P.loan_id
WHERE C.customer_Id = 3;



/* ============================================================
   13. BANK TOTAL DEPOSITS  
   ============================================================ */

SELECT SUM(balance) AS total_bank_deposits
FROM Account;



/* ============================================================
   14. TOTAL LOANS ISSUED  
   ============================================================ */

SELECT SUM(principal_amount) AS total_loans_issued
FROM Loan;


