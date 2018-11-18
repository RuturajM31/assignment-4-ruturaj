libname rutu "C:\Users\rmokashi\Documents\BusinessReportingTools-master\Extra_dataset";
run;


proc sql;


select distinct A.LastName, A.FirstName, C.SupportRepId, sum(B.Total) as tot

From rutu.Employees A, rutu.Invoices B, rutu.Customers C   
where  B.CustomerId = C.CustomerId
and A.EmployeeId = C.SupportRepId
and year(datepart(B.InvoiceDate)) = 2009
group by 1,2,3

having sum(B.Total) = (select max(maxsales)
from (select sum(B.Total) as maxsales
from rutu.Employees A, rutu.Invoices B, rutu.Customers C   
where  B.CustomerId = C.CustomerId
and A.EmployeeId = C.SupportRepId
and year(datepart(B.InvoiceDate)) = 2009
))
;

quit;


proc sql outobs= 5;

select B.Name, sum(Quantity)
From rutu.Invoice_Items A, rutu.Tracks B  
where A.TrackId = B.TrackId
group by 1 
order by 2 desc ;
quit;

proc sql;
select case when  B.customerId IN (select CustomerID 
from rutu.Customers 
where A.Country = "USA") 
Then "US"
else "Non-US"
End as location,max(Total)
from rutu.customers A, rutu.invoices B
where A.customerid = B.customerid
group by 1;
quit;



proc sql outobs=1;
select distinct A.country, sum(B.Total)
from rutu.customers A,rutu.invoices B
where A.CustomerId = B.CustomerId
group by 1
order by 2 desc;
quit;


proc sql;
select CustomerId ,sum(total) 
from rutu.Invoices 
group by 1
having sum(Total) >= ALL(select 0.8 * sum(total)  
from rutu.Invoices 
group by CustomerId)
order by 1 ;
quit;


proc sql;
select Firstname,LastName ,INT(YRDIF(datepart(Birthdate),Today())) as Age_emp
from rutu.Employees
where year(datepart(Birthdate)) < (select year(datepart(Birthdate)) 
from rutu.Employees
 where Title = 'General Manager');
quit;


proc sql;
select A.TrackId, A.Name
from rutu.Tracks A,rutu.Invoice_Items B
where A.TrackId = B.TrackId
and A.Composer contains ('Alanis')
group by 1,2
having sum(quantity) > ALL (select sum(quantity) 
from rutu.Tracks A,rutu.Invoice_Items B
where A.TrackId = B.TrackId 
and composer contains 'Aerosmithâ€™s tracks'
group by A.TrackId);
quit;

proc sql;
select TrackId,milliseconds
from rutu.Tracks
where milliseconds < ALL (select milliseconds 
from rutu.Tracks
where composer like 'A%')
order by 1;
quit;










