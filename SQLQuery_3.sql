/*1. Write a query to display the first name, last name and salary of the top 5 highest paid employees. Put them in descending order. Use tables Person.person, HumanResources.EmployeePayHistory. */

/*SELECT TOP 5  pp.FirstName, pp.LastName, ep.Rate
FROM HumanResources.EmployeePayHistory as ep, Person.Person as pp
WHERE pp.BusinessEntityID = ep.BusinessEntityID
ORDER BY Rate DESC; */

/*2. Show BusinessEntityID, territory name and SalesYTD of all sales persons whose SalesYTD is greater than $500,000, regardless of whether they are assigned a territory. Use Sales.SalesPerson table and Sales.SalesTerritory table.*/

/*SELECT sp.SalesYTD, st.CountryRegionCode, sp.BusinessEntityID
FROM Sales.SalesTerritory as st 
FULL OUTER JOIN Sales.SalesPerson as sp
ON st.TerritoryID = sp.TerritoryID
WHERE sp.SalesYTD > '500000';*/

/*3. Show ProductID, LocationID, Quantity of all the products whose inventory is less than 100.  Use Production.ProductInventory*/

/*Select ProductID, LocationID, Quantity
from Production.ProductInventory
Where Quantity < '100';*/

/*4. Are high earning (those earning more than average pay rate) male and female employees compensated equitably at Adventureworks? Consider both Payrate and Vacation time.
The final table should show for each gender, the average vacation and average payrates but consider only those employees above the average pay.
Use HumanResources.Employee and HumanResources.EmployeePayHistory.
hint: you may use subqueries to find the average pay of all employees or run two different queries to find the average pay of all employees */

/*SELECT he.Gender, AVG(he.VacationHours) as 'Vacation', AVG(ep.rate) as 'AVG_Rate'
FROM  HumanResources.Employee as he, HumanResources.EmployeePayHistory as ep
WHERE he.BusinessEntityID = ep.BusinessEntityID AND ep.rate > 
    (SELECT AVG(ep.Rate) as 'AVG_Salary'
    FROM HumanResources.Employee as he, HumanResources.EmployeePayHistory as ep
    WHERE he.BusinessEntityID = ep.BusinessEntityID)
Group BY he.Gender;*/

/*5. Show the customerIDs, total taxAmt, number of orders for all the customers who paid a total of more than 21000 in taxes and made more than 10 orders in store (OnlineFlag=0). Use Sales.SalesOrderHeader*/
/*
Select sum(TaxAmt) as total_taxAmt, count(customerID) as Total_Orders, CustomerID
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = 0
GROUP BY CustomerID
HAVING sum(TaxAmt) > 21000 AND count(CustomerID) > 10; */


/*6. Does John T. Campbell wish to receive any email promotions (that is, the value for the column email promotions will be 1)? Use Person.person table. */
/*SELECT FirstName, LastName, MiddleName, EmailPromotion
FROM Person.person
WHERE FirstName = 'John' AND LastName = 'Campbell' AND MiddleName = 'T' ; */

/*7. Write a query to display each sales person's first name, last name, job title and the number of sales from last year, as well as this year YTD. In addition, Add a column showing the difference between the two to show whether the person is already selling more or less.
Use Sales.SalesPerson, Person.Person, HumanResources.Employee */

/*SELECT *
FROM Sales.SalesPerson;

SELECT *
FROM Person.Person;

SELECT *
FROM HumanResources.Employee;

SELECT pp.FirstName, pp.LastName, he.JobTitle, ss.SalesYTD as 'Sales_This_Year', ss.SalesLastYear as 'Sales_Last_Year', 
       ss.SalesYTD - ss.SalesLastYear as 'Difference'
FROM Sales.SalesPerson as ss, Person.Person as pp, HumanResources.Employee as he
WHERE pp.BusinessEntityID = ss.BusinessEntityID and ss.BusinessEntityID = he.BusinessEntityID AND JobTitle like '%Sales%';*/

/*8. Show OrderQty, the Name and the ListPrice of the order made by CustomerID 11000. Use Sales.SalesOrderHeader, Sales.SalesOrderDetail, Production.Product */


SELECT so.OrderQty, pp.Name,pp.ListPrice
FROM Sales.SalesOrderDetail as so, Production.Product as pp, Sales.SalesOrderHeader as oh
WHERE oh.CustomerID = 11000 AND oh.SalesOrderID = so.SalesOrderID AND so.ProductID = pp.ProductID;
