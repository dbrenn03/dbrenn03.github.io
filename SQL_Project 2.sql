/*Display all the unique store names. Table: Sales.Store*/

SELECT * 
FROM Sales.Store; 

SELECT DISTINCT Name 
FROM Sales.Store;

/*Display all sales info about Product (ID = 843, 845, 847). 
Table: Sales.SalesOrderDetail*/

SELECT * 
FROM Sales.SalesOrderDetail;

SELECT *
FROM Sales.SalesOrderDetail
WHERE ProductID = 843 OR ProductID =845 OR ProductID =847; 

/*Display all sales info of all the products of which unit price 
is between 100 and 200. Table: Sales.SalesOrderDetail*/

SELECT *
FROM Sales.SalesOrderDetail
WHERE UnitPrice BETWEEN 100 AND 200
ORDER BY UnitPrice;

SELECT *
FROM Sales.SalesOrderDetail
/*WHERE UnitPrice BETWEEN 100 AND 200*/
WHERE UnitPrice >= 100 AND UnitPrice <= 200
ORDER BY UnitPrice;

/*Display store names that contain "Bike". Table: sales.Store */

SELECT name 
FROM sales.Store
WHERE name like '%Bike%'
;
/*Display the product ID, product name, list price and standard 
cost of all products with a standard cost greater than zero. 
Table: Production.Product*/

SELECT *
FROM Production.Product;

SELECT ProductID, Name, ListPrice, StandardCost
FROM Production.Product
WHERE StandardCost > 0;

/*Display First name and last name of employees whose job title 
is , ranking from oldest to youngest. Tables: 
HumanResources.Employee table and Person.Person table. */

SELECT pp.FirstName, pp.LastName, hr.JobTitle
FROM Person.Person as pp, HumanResources.Employee as hr 
WHERE pp.BusinessEntityID = hr.BusinessEntityID AND hr.JobTitle = 'Sales Representative'
ORDER BY hr.BirthDate DESC;

/*Display all the products which sold more than $5000 in total. 
Show product ID and name and total amount collected after selling
the products. You may use LineTotal from Sales.SalesOrderDetail 
table and Production.Product table.*/

SELECT *
FROM Sales.SalesOrderDetail as ss, Production.Product as pp
WHERE ss.ProductID = pp.ProductID

SELECT ss.ProductID, pp.Name, sum(ss.LineTotal) as 'Total Collected'
FROM Sales.SalesOrderDetail as ss, Production.Product as pp
WHERE ss.ProductID = pp.ProductID
GROUP BY ss.ProductID, pp.Name
HAVING sum(ss.LineTotal) > 5000

/*Display BusinessEntityID, territory name and SalesYTD of all 
sales persons whose SalesYTD is greater than $500,000, regardless
of whether they are assigned a territory. Tables: 
Sales.SalesPerson table and Sales.SalesTerritory table. */

SELECT ss.BusinessEntityID, st.Name, ss.SalesYTD 
FROM Sales.SalesPerson as ss
RIGHT JOIN Sales.SalesTerritory as st
ON ss.TerritoryID = st.TerritoryID
WHERE ss.SalesYTD > 500000;

/*Display the sales order ID of those orders in the year 2008 of 
which the total due is great than the average total due of all 
the orders of the same year. Table: sales.SalesOrderHeader*/

SELECT SalesOrderID,TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > 
    (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader WHERE year(OrderDate) = 2011 ) 
      AND year(OrderDate) = 2011





SELECT SalesOrderID, TotalDue
FROM sales.SalesOrderHeader
WHERE Year(OrderDate)=2008
and TotalDue>
(SELECT avg(TotalDue)
FROM sales.SalesOrderHeader
WHERE Year(OrderDate)=2008
)
/*Write a query to display the Business Entities (IDs, names) of 
the customers that have the 'Vista' credit card. Tables: 
Sales.CreditCard, Sales.PersonCreditCard, Person.Person */



