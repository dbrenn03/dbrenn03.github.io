

/* 1. Show ProductID, LocationID, Quantity of all the products whose inventory is 
less than 100. 
Use Production.ProductInventory 
[5 points] */

SELECT pi.ProductID, pi.LocationID, pi.Quantity
FROM Production.ProductInventory as pi
WHERE pi.Quantity < 100


/* 2. Does John T. Campbell wish to receive any email promotions? 
Use Person.person 
[5 points] */

SELECT pp.FirstName, pp.MiddleName, pp.LastName, pp.EmailPromotion
FROM Person.Person as pp
WHERE pp.FirstName = 'John' and pp.MiddleName = 'T' and pp.LastName = 'Campbell'

/* Yes */

/* 3. How many men and women take more sick leave hours than the average sick leave
hours of all employees? 
Use HumanResources.employee table 
[10 points] */
 
SELECT COUNT(hr.BusinessEntityID) as 'Number of People', hr.Gender
FROM HumanResources.employee as hr 
WHERE SickLeaveHours > (SELECT AVG(tt.SickLeaveHours) FROM HumanResources.Employee as tt)
GROUP BY hr.Gender;

/* 4. Which is the name of the most popular product being sold (in terms of total 
quantities sold) in the year 2012? 
Use sales.SalesOrderDetail and Production.Product
[10 points] */

SELECT TOP 1 SUM(so.OrderQTY) as 'Total Quantity Sold', pp.Name
FROM sales.SalesOrderDetail as so
JOIN Production.Product as pp
ON so.ProductID = pp.ProductID
WHERE year(so.ModifiedDate) = 2012
GROUP BY pp.Name

/* AWC Logo Cap */ 


/* 5. Show the customerIDs, total taxAmt labeled as Total Tax Amount, number of 
orders labeled as Number of Orders for all the customers who paid a total of more 
than 21000 in taxes and made more than 10 orders in store 
( OnlineFlag=0 for in store purchase). 
Use Sales.SalesOrderHeader
[10 points]
*/

SELECT CustomerID, sum(TaxAmt) as 'Total Tax Amount', Count(SalesOrderID) as 'Number of Orders'
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = 0
GROUP BY CustomerID
HAVING sum(TaxAmt) > 21000 AND Count(SalesOrderID) > 10
ORDER BY sum(TaxAmt) ASC

/* 6 Show the product category, subcategory, name, and product ID for all products 
that belong to a category and subcategory. 
These should be sorted alphabetically by category, then by subcategory, and then by
product name.
Use, Production.Product, Production.ProductSubcategory,Production.ProductCategory
[10 points]
*/

SELECT ps.Name as 'Category', pc.Name as 'SubCategory', pp.Name, pp.ProductID 
FROM Production.Product as pp, Production.ProductSubcategory as ps, Production.ProductCategory as pc
WHERE ps.ProductCategoryID = pc.ProductCategoryID AND ps.ProductSubcategoryID = pp.ProductSubcategoryID
ORDER BY ps.Name ASC, pc.Name ASC, pp.Name ASC

/* 7. Show the product ID, product name, and list price for each product where the 
list price is higher than the average standard cost for all products. 
use production.product
[10 points] */

SELECT pp.ProductID, pp.Name, pp.ListPrice
FROM production.product as pp
WHERE pp.ListPrice > (SELECT AVG(tt.StandardCost) FROM production.product as tt)
ORDER BY ListPrice DESC

/* 8.  Find the product model IDs that have no product associated with them. 
Use Production.Product table and the Production.ProductModel table  
[10 points] */

SELECT pm.ProductModelID, pp.ProductID
FROM Production.ProductModel as pm
FULL OUTER JOIN Production.Product as pp  
ON pp.ProductModelID = pm.ProductModelID
WHERE pp.ProductID is NULL

/* 9 How many unique products were sold each year? This should be sorted by the 
year.
Use sales.salesorderdetail
[10 points]
*/

SELECT DISTINCT COUNT (SalesOrderID) as 'Number of Unique Products', year(ModifiedDate) as 'Year'
FROM sales.salesorderdetail
GROUP BY year(ModifiedDate)
ORDER BY year(ModifiedDate) DESC

/* 10 In your own words, write a business question that you can answer by querying 
the database and using at least 2 of the SQL concepts covered in class.
 Then write the complete SQL query that will provide the information that you are 
seeking.
 [10 points] */

 /*  What is the Total Sales per country region? Make sure to order the countryregion code alphabetically. Use the sales.SalesTerritory */

 SELECT SUM(SalesYTD) as "Total Sales", Countryregioncode
 FROM sales.SalesTerritory
 GROUP BY CountryRegionCode
 ORDER BY CountryRegionCode ASC
