--Get all the details from the person table including email ID, phone
--number and phone number type

select * ,e.emailaddress, PN.PhoneNumber,PT.PhoneNumberTypeID
from [Person].[Person] as p
join person.emailAddress as e on
p.businessentityId=e.BusinessEntityID
join [Person].[PersonPhone] as PN on
p.BusinessEntityID=PN.BusinessEntityID 
join [Person].[PhoneNumberType] As PT on
p.BusinessEntityID=PN.BusinessEntityID

--Get the details of the sales header order made in May 2011

select* from [Sales].[SalesOrderHeader] where MONTH(OrderDate)=5
And year(OrderDate)=2011

--c. Get the details of the sales details order made in the month of May
--2011

select* from[Sales].[SalesOrderHeader]As SOH join
[sales].[SalesOrderDetail] AS SOD
on soh.salesorderId=sod.salesorderId
where MONTH(soh.orderdate)=5
And year(soh.Orderdate)=2011

--d. Get the total sales made in May 2011

select sum(LineTotal)'May_Total_sales'from [sales].[SalesOrderDetail] As SOD
join [Sales].[SalesOrderHeader]as SOH 
on soh.salesorderId=sod.salesorderId where
Month(soh.orderdate)=5 
and year(soh.orderdate)=2011

--e. Get the total sales made in the year 2011 by month order by
--increasing sales

select month(soh.orderdate)'Month', sum(sod.lineTotal)'Total_sales'
from [sales].[SalesOrderDetail]as SOD 
join [sales].[SalesOrderHeader]as SOH on
sod.SalesOrderID=soh.SalesOrderID 
where year(soh.orderdate)=2011
group by month(soh.orderdate) 
order by sum(sod.LineTotal)desc

--f. Get the total sales made to the customer with FirstName='Gustavo'
--and lastname ='Achong'
SELECT
      p.FirstName, p.LastName, tmp.TotalAmount
FROM Sales.Customer  c
     INNER JOIN Person.Person AS p ON p.BusinessEntityID=c.PersonID
     LEFT JOIN
       (
        SELECT
                  soh.CustomerID, SUM(LineTotal) AS TotalAmount
         FROM     Sales.SalesOrderDetail            AS sod
                  INNER JOIN Sales.SalesOrderHeader AS soh ON soh.SalesOrderID=sod.SalesOrderID
         GROUP BY soh.CustomerID
       )                      tmp ON tmp.CustomerID=c.CustomerID
	   where p.FirstName='Gustavo' and lastname='Achong'