create database MyBank;
use MyBank;
 go

CREATE TABLE UserLogins-----------------------------parent1
(
	UserLoginID smallint NOT NULL primary key identity(1,1),
	UserLogin varchar(50) NOT NULL,
	UserPassword Varchar(20) NOT NULL);
go

insert into UserLogins values('Sreesh', 'Sreeshsh29');
insert into UserLogins values('Jaswin', 'Jaswin25');
insert into UserLogins values('Sahana', 'Sahana07');
insert into UserLogins values('Nilesh', 'Nilesh11');
insert into UserLogins values('Abhil', 'Abhil6');
go

Select * from UserLogins
go

Create table UserSecurityQuestions------------------------------------parent2
(
	UserSecurityQuestionID tinyint not null primary key identity(1,1),
	UserSecurityQuestion varchar(50) not null);
go

insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite colour?');
insert into UserSecurityQuestions values('What is your favourite sports?');
go

Select * from UserSecurityQuestions
go

Create table UserSecurityAnswers----------------------parent3/child1
(
	UserLoginID SMALLINT NOT NULL primary key identity(1,1),
	UserSecurityAnswers VARCHAR(25) NOT NULL,
	UserSecurityQuestionID TINYINT NOT NULL, 
	constraint UserSecurityQuestionID foreign key(UserSecurityQuestionID) references UserSecurityQuestions(UserSecurityQuestionID));
go

insert into UserSecurityAnswers values('Apple', 1);
insert into UserSecurityAnswers values('red', 2);
insert into UserSecurityAnswers values('Basketball', 3);
insert into UserSecurityAnswers values('Blue', 2);
insert into UserSecurityAnswers values('basketball', 3);
go

Select * from UserSecurityAnswers
go

Create table AccountType--------------------------------parent4
(
	AccountTypeID tinyint not null primary key identity(1,1),
	AccountTypeDescription varchar(30) not null);
go

Insert into AccountType values('Savings');
Insert into AccountType values('Checking');

Select * from AccountType
go

Create table SavingsInterestRates----------------------------parent5
(
	InterestSavingRatesID tinyint not null primary key identity(1,1),
	InterestRatesValue numeric (9,9) not null, 
	InterestRatesDescription VARCHAR(20) not null);
go
insert into SavingsInterestRates values(0.5,'Low');
insert into SavingsInterestRates values(0.9,'Medium');
insert into SavingsInterestRates values(0.9,'High');
go

Select * from SavingsInterestRates
go


Create table AccountStatusType-----------------------parent6
(
	AccountStatusTypeID tinyint not null primary key identity(1,1),
	AccountStatusTypeDescription VARCHAR(30) not null);
go

insert into AccountStatusType values('Active');
insert into AccountStatusType values('inactive');
go
Select * from AccountStatusType
go

Create table Account----------------Parent7/Child2
(
	AccountID int not null  primary key identity(1,1),
	DateOpened Date not null,
	OpeningBalance money,
	CurrentBalance int not null,
	AccountTypeID tinyint not null, 
	AccountStatusTypeID tinyint not null,
	InterestSavingRatesID tinyint not null);
go

alter table account
	add foreign key(AccountTypeID) references AccountType(AccountTypeID);
alter table account
	add  foreign key(AccountStatusTypeID) references AccountStatusType(AccountStatusTypeID);
alter table account
	add foreign key (InterestSavingRatesID) references SavingsInterestRates(InterestSavingRatesID); 
go

insert into Account values
	('2000/6/29',30000,70000,1,2,1),
	('2001/6/25',30000,80000,1,2,2),
	('2002/4/15',20000,50000,2,2,1),
	('2003/7/25',25000,55015,1,2,2),
	('2004/10/17',20000,45879,2,1,1);
 go
 select * from Account
 go


 Create table LoginAccount-------------------------child3
(
	UserLoginID smallint not null,
	AccountID int not null);


	Alter table LoginAccount
	add foreign key (UserLoginID) REFERENCES UserLogins(UserLoginID);
	Alter table LoginAccount
	add foreign key(AccountID) REFERENCES Account(AccountID);
go

insert into LoginAccount values(1, 1);
insert into LoginAccount values(2, 2);
insert into LoginAccount values(3, 3);
insert into LoginAccount values(4, 4);
insert into LoginAccount values(5, 5);
go
select * from LoginAccount
 go


Create table OverDraftLog------------------parent8
(
	AccountID int not null primary key identity(1,1),
	OverDraftDate datetime not null,
	OverDraftAmount Money not null,
	OverDraftTransactionXML XML not null,
	constraint AccountID foreign key(AccountID) references Account(AccountID)
);

Alter table OverDraftLog
add constraint AccountID foreign key(AccountID) references Account(AccountID);
go

insert into OverDraftLog values('2018/6/29 06:35:56', 0,'close');
insert into OverDraftLog values('2013/6/25 12:34:57', 5,'Pending');
insert into OverDraftLog values('2012/4/15 02:25:00', 10,'close');
insert into OverDraftLog values('2020/12/24 01:14:00',8,'pending');
insert into OverDraftLog values('2012/4/15 10:11:00', 12, 'close');
insert into OverDraftLog values('2012/4/15 02:08:00', 10, 'close');
go

select * from OverDraftLog
go

Create table Customer-----------------------parent 9
(
	CustomerID int not null primary key identity(1,1),
	AccountID int not null,
	CustomerAddress1 varchar (30) not null,
	CustomerAddress2  varchar(30),
	CustomerFirstName  varchar(30) not null,
	CustomerMiddleInitial varchar(1),
	CustomerLastName  varchar(30) not null,
	City varchar(20) not null,
	province char(2) not null,
	ZipCode char(10) not null,
	EmailAddress char(40) not null,
	HomePhone varchar(10) not null,
	CellPhone varchar(10) not null,
	WorkPhone varchar(10) not null,
	SSN varchar(9),
	UserLoginID smallint NOT NULL);
go

Alter table Customer
	add foreign key(AccountID) REFERENCES Account(AccountID);
go

insert into Customer values(1,'5''jeffry rd','11'' Canoe Cres','Sreesh','s','kugan','S','ON','g2g5k5','Sreesh@gmail.com','6478584655','4168657799','4165585585','ssn12',1);
insert into Customer values(2, '3'' alton', '60''kingston rd', 'Jaswin', 'J', 'Kuganthan', 'Hamilton', 'ON','l1y8h8','jaswin6@gmail.com','4168586366','9055570047','4163375941','ssn13',2);
insert into Customer values(3, '4''steel rd', '302''elson rd', 'Nilesh', 'N', 'Chandran', 'Ottawa','ON','m5k4m4','nilash@gmailr.com', '6478691425','6478963254','4165851236','ssn14',3);
insert into Customer values(4, '8''westney rd', '44''belbrook', 'Sahana', 'S', 'Mohan', 'London', 'ON','s3m8t8','saha@gmail.com','4165557788','9058473625','4168793245','ssn15',4);
insert into Customer values(5, '7''newland rd', '2'' markham rd', 'Abhil', 'A', 'Siva', 'Hamilon', 'ON','a5d7g7','abi@gmail.com','4169875238','9054459932','4169872358','ssn16',5);
go

select * from Customer
go


Create table TransactionLog-------------------parent 10
(
	TransactionID int not null primary key identity(1,1),
	TransactionDate datetime not null,
	TransactionTypeID tinyint not null,
	TransactionAmount Money not null,
	NewBalance Money not null,
	AccountID int not null,
	CustomerID int not null,
	EmployeeID int not null,
	UserLoginID smallint not null);

	Alter table TransactionLog
	add foreign key (TransactionTypeID) references TransactionType(TransactionTypeID);

	Alter table TransactionLog
	add foreign key (AccountID) references Account(AccountID);

	Alter table TransactionLog
	add foreign key (CustomerID) references Customer(CustomerID);

	Alter table TransactionLog
	add foreign key (EmployeeID) references Employee(EmployeeID);

	Alter table TransactionLog
	add foreign key (UserLoginID) references UserLogins(UserLoginID);


	
insert into TransactionLog values('2012/7/8',1, 555, 40000, 1, 1, 1, 1);
insert into TransactionLog values('2010/8/14',2, 1000, 25000, 2, 2, 2, 2);
insert into TransactionLog values('2003/12/25',3, 7958.3, 8622, 3, 3, 3, 3);
insert into TransactionLog values('2013/7/5 ',4, 9857.5, 1800, 4, 4, 4, 4);
insert into TransactionLog values('2019/10/12',5, 7500.5, 2000, 5, 5, 5, 5);

go

select * from TransactionLog;
go

Create table Employee-------------------parent11
(
	EmployeeID int not null primary key identity(1,1),
	EmployeeFirstName varchar(25) not null,
	EmployeeMiddleInitial char(1),
	EmployeeLastName varchar(25),
	EmployeeisManager bit);
	go

insert into Employee values('Nilesh', 'c', 'chandran', '1');
insert into Employee values('Abil', 's', 'siva', '1');
insert into Employee values('Rose', 'G', 'john', '2');
insert into Employee values('Shan', 'r', 'kumar', '1');
insert into Employee values('Jaswin', 'K', 'kuganthan', '1');
go

select * from employee;
go

Create table TransactionType---------------------parent12
(
	TransactionTypeID tinyint not null primary key identity(1,1),
	TransactionTypeName char(10) not null,
	TransactionTypeDescription varchar(50),
	TransactionFeeAmount smallmoney);
go

insert into TransactionType values ('Paid', 'Pay bills', '50');
insert into TransactionType values('Transfer', 'Sending money', '25');
insert into TransactionType values('withraw', 'Get money', '0');
insert into TransactionType values('Balance', 'Account Balance', '0');
insert into TransactionType values('Statement', 'monthly summary','0');
GO

select * from TransactionType;

Create table LoginErrorLog---------------------------parent13
(
	ErrorLogID int not null primary key identity(1,1),
	ErrorTime datetime not null,
	FailedTransactionXML XML);

go

insert into LoginErrorLog values('2020/12/24 10:08:22','InvalidUser');
insert into LoginErrorLog values('2020/12/23 09:12:45','invalid Password');
insert into LoginErrorLog values('2016/12/4 06:08:12','Net work down');
insert into LoginErrorLog values('2020/12/2507:56:21','Serverdown');


select * from LoginErrorLog


Create table FailedTransactionLog--------------------Parent14
(
	FailedTransactionID int not null primary key identity(1,1) ,
	FailedTransactionErrorTypeID tinyint not null,
	FailedTransactionErrorTime datetime,
	FailedTransactionErrorXML XML);
	
	Alter table FailedTransactionLog
	add foreign key (FailedTransactionErrorTypeID) references FailedTransactionErrorType(FailedTransactionErrorTypeID);
go

insert into FailedTransactionLog values(1,'2020/12/4 06:08:58','Unknown');
insert into FailedTransactionLog values(2,'2018/12/25 08:07:15','known');
insert into FailedTransactionLog values(3,'2020/7/9 11:03:14','known');
insert into FailedTransactionLog values(4,'2020/12/24 02:03:19','Unknown');
insert into FailedTransactionLog values(5,'2019/10/12 10:08:20','known');

select * from FailedTransactionLog


Create table FailedTransactionErrorType--------------------------parent15
(
	FailedTransactionErrorTypeID tinyint not null primary key identity(1,1),
	FailedTransactionErrorTypeDescription Varchar(50) NOT NULL);
go
insert into FailedTransactionErrorType values('declined');
insert into FailedTransactionErrorType values('transaction failed');
insert into FailedTransactionErrorType values('No tenough balance');

select * from FailedTransactionErrorType

go



------------------------------------------------------------------------------
Phase 2
------------------------------------------------------------------------------


--Q1.	Create a view to get all customers with checking account from ON province. [Moderate]

Select * from Customer
Select * from Account
Select * from AccountType
go


Create View VQ1 As
select distinct c.* from Customer c
Join Account a
on c.AccountID = a.AccountID
Join AccountType t
on a.AccountTypeID = t.AccountTypeID
where t.AccountTypeDescription = 'Checking' and c.province='ON'

 
Select * from VQ1

--Q2.	Create a view to get all customers with total account balance (including interest rate) greater than 5000. [Advanced]

Select * from Customer
Select * from Account
Select * from SavingsInterestRates
go

create View VQ2 As
Select c.CustomerFirstName, Sum(a.CurrentBalance) As Ac_Balance, Sum(a.CurrentBalance+(a.currentBalance * S.InterestSavingRatesID/100))/12 As TotalAccountBalance
from Customer c
Join Account a
on c.AccountID = a.AccountID
Join SavingsInterestRates s
on a.InterestSavingRatesID= s.InterestSavingRatesID
group by c.CustomerFirstName
having sum(a.currentBalance +(a.CurrentBalance * s.InterestSavingRatesID)/100/12)> 5000;

select * from VQ2
go

--Q3.Create a view to get counts of checking and savings accounts by customer. [Moderate]
Select * from Customer
Select * from Account
Select * from AccountType
go

create view VQ3
As
select c.customerFirstName, t.AccountTypeDescription,COUNT(*)As Total_AC_Types from Customer c
Join Account a
on c.AccountID = a.AccountID
join AccountType t 
on a.AccountTypeID = t.AccountTypeID
group by c.CustomerfirstName, t. AccountTypeDescription;
go
Select * from VQ3

--Q4 Create a view to get any particular user’s login and password using AccountId. [Moderate]
Select * from Account
Select * from LoginAccount
Select * from UserLogins
go

create view V4
As
select Distinct ul.UserLogin, ul.UserPassword
from UserLogins ul
join LoginAccount la
on ul.UserLoginID = la.UserLoginID
join Account a
on la.AccountID = a.AccountID
where la.AccountID='1'
 go

Select * from V4
go

--Q5.Create a view to get all customers’ overdraft amount. [Moderate]

Select * from Customer
Select * from OverDraftLog
go

create view V5
as
select Distinct c.CustomerFirstName, o.OverDraftAmount
from OverDraftLog o
join Customer c
on o.AccountID = c.AccountID
go

Select * from V5
go


--Q6.Create a stored procedure to add “User_” as a prefix to everyone’s login (username). [Moderate]

Create Procedure S_Q6
As
Update UserLogins
set UserLogin = CONCAT('User_', UserLogin);
go
exec S_Q6;

Select * from UserLogins;
go

--Q7.Create a stored procedure that accepts AccountId as a parameter and returns customer’s full name. [Advanced]

create procedure sp_Q7 @AccountID int
as
select c.CustomerFirstName + ' '+c.CustomerMiddleInitial+ ' '+c.CustomerLastName as CustomerFullName
from Customer c
join Account a
on c.AccountID =a.AccountID
where a.AccountID = @AccountID;
go
exec sp_Q7 3; 
go

--Q8, Create a stored procedure that returns error logs inserted in the last 24 hours. [Advanced]

create procedure sQ8
as
select * from LoginErrorLog
where ErrorTime between DATEADD(hh, -24, GETDATE()) and getdate();
go
 Exec  sQ8 
 go

--Q9.Create a stored procedure that takes a deposit as a parameter and updates CurrentBalance value for that particular account. [Advanced]
go
create procedure sQ9 @AccountId int, @Deposit money
as
update Account
set CurrentBalance = CurrentBalance+ @Deposit
where AccountID = @AccountID;
go

exec sQ9 2,500;
go
Select * from Account
go
--Q10.Create a stored procedure that takes a withdrawal amount as a parameter and updates 

create procedure sQ10 @AccountID int, @Withdraw Money
as
update Account
set CurrentBalance = CurrentBalance - @Withdraw
where AccountID = @AccountID;
go

exec sQ10 2,300;
go
Select * from Account


















go
























































