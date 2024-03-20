/* 1. How many products have a unit price of more than $500?
Use Production.Product */

SELECT COUNT(ProductID) as 'Number of Products' 
FROM Production.Product
WHERE ListPrice > 500;

/* 2. What is the average sick leave ? use HumanResources.Employee */

SELECT AVG(SickLeaveHours) as 'Average Sick Leave'
FROM HumanResources.Employee;

/* 3. Display the total amount (sum of linetotal) collected from selling the products, from 700 to 800. Only list those products that have sold more than 3000 units.
Use sales.SalesOrderDetail */

SELECT *
FROM sales.SalesOrderDetail;

SELECT SUM(LineTotal) as 'Total Amount Collected', SUM(OrderQty) 'As Units Sold', ProductID
FROM sales.SalesOrderDetail
WHERE ProductID BETWEEN 700 and 800
GROUP BY ProductID
HAVING SUM(LineTotal) > 3000
ORDER BY ProductID ASC
;

/* 4. How many single (marital status is 'S') male and female employees are there?
Use HumanResources.Employee.*/

SELECT *
FROM HumanResources.Employee;

SELECT COUNT(GENDER) as 'Number of People Single', Gender
FROM HumanResources.Employee
WHERE MaritalStatus = 'S'
GROUP BY Gender;

/* 5. Display the first and last name of all the people along with their their job title and hire date even if they do not have that info on file.
Use Person.Person and HumanResources.Employee tables.*/
SELECT * 
FROM Person.Person; 

SELECT * 
FROM HumanResources.Employee; 

SELECT pp.FirstName, pp.LastName, he.JobTitle, he.HireDate
FROM Person.Person as pp
FULL OUTER JOIN HumanResources.Employee as he
ON pp.BusinessEntityID = he.BusinessEntityID
;

/* 6. Provide the total number of employees by job title and gender who take more sick leave hours than the average sick leave hours of all employees.
Use HumanResources.Employee r*/

SELECT * 
FROM HumanResources.Employee;

SELECT COUNT(BusinessEntityID) as 'Total Number of People', JobTitle, Gender
FROM HumanResources.Employee
WHERE SickLeaveHours > (SELECT AVG(SickLeaveHours) FROM HumanResources.Employee )
GROUP BY JobTitle, Gender
;

/* 7. Does the marital status of the sales person have an effect on their sales? Show the average SalesYTD and Sales from Last year for each Marital Status.
Use [AdventureWorks2012].[Sales].[SalesPerson],[AdventureWorks2012].[HumanResources].[Employee]*/
SELECT *
FROM Sales.SalesPerson;

SELECT *
FROM HumanResources.Employee;

SELECT AVG(ss.SalesYTD) as 'Average Sales This Year', AVG(ss.SalesLastYear) as 'Average Sales Last Year' , hr.MaritalStatus
FROM Sales.SalesPerson as ss, HumanResources.Employee as hr
WHERE ss.BusinessEntityID = hr.BusinessEntityID
GROUP BY MaritalStatus
;


/* 8. Which sales person received the biggest bonus this year? Include FirstName, LastName, JobTitle, and Bonus.
Use: Sales.SalesPerson, Person.Person, HumanResources.Employee */

SELECT *
FROM Sales.SalesPerson

SELECT *
FROM Person.Person

SELECT *
FROM HumanResources.Employee

SELECT TOP 1 ss.Bonus as "Biggest Bonus", pp.FirstName, pp.LastName, hr.JobTitle
FROM Sales.SalesPerson as ss, Person.Person as pp, HumanResources.Employee as hr
WHERE ss.BusinessEntityID = pp.BusinessEntityID AND pp.BusinessEntityID = hr.BusinessEntityID
ORDER BY Bonus DESC
;


/* 9. In your own words, write a business question that you can answer by querying the database and using SQL concepts covered in class.
Then write the complete SQL query that will provide the information that you are seeking. */
