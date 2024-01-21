create database casestudy_3
Use casestudy_3
select*from customers where customer_id=1
select*from [Transaction] where customer_id=1

--Questions
--1) Display the count of customer in each region who has done the transaction in year 2020
select c.region_id,count(distinct t.customer_id)'count' from customers c, [transaction] t  
where t.customer_id=c.customer_id and year(t.txn_date)=2020 group by c.region_id

--2) Display the maximum, minimum of transaction amount of each transaction type.
select txn_type,max(txn_amount)'Max',min(txn_amount)'Min'from [transaction]
group by txn_type 
--3) Display customer id, region name and transaction amount where transaction type is deposit and
--transaction amount > 2000.
select c.customer_id,co.region_name,t.txn_amount from customers c,
continent CO,[transaction] t 
where c.customer_id=t.customer_id and c.region_id=co.region_id
and t.txn_amount>2000
--4) Find duplicate records in a customer table.
select customer_id,count(*)'Duplicate'
from customers
group by customer_id
having count(*)>1
order by customer_id

--5) Display the detail of customer id, region name, transaction type and transaction amount for the
--minimum transaction amount in deposit.
select 
		c.customer_id,
		co.region_name,
		min(t.txn_amount)'Min Transaction',
		t.txn_type
from	customers c,
		continent CO,
		[transaction] t 
where   c.customer_id=t.customer_id
	and c.region_id=co.region_id
	and t.txn_type='Deposit'
Group by c.customer_id,
		 co.region_name,
		 t.txn_type
Order by c.customer_id
--6) Create a stored procedure to display details of customer and transaction table where transaction
--date is greater than Jun 2020.
create procedure Customer_transaction (@customer_id int)			
As
Begin
	select *
	from customers c , [transaction] t 
	where c.customer_id=t.customer_id
	and c.customer_id=@customer_id
	and year(txn_date)>2020
	and month(txn_date)>6
End
Exec Customer_transaction 1
--7) Create a stored procedure to insert a record in the continent table.
create procedure insert_continent 
@Region_id int,
@Region_name varchar(50)
As
Begin
	Set nocount on;
	insert into continent
				(region_id,region_name)
		   Values (@Region_id,@Region_name)
End
--8) Create a stored procedure to display the details of transactions that happened on a specific day.
create procedure txnOndate (@txn_date date)
As
Begin
	select *
	from [transaction] 
	Where txn_date=@txn_date
End
Exec txnOndate '2020-04-01'
--9) Create a user defined function to add 10% of the transaction amount in a table.
create function IncreaseTxnamt()
returns table 
As
Return 
		  select customer_id,
				 txn_date,
				 txn_type,
				 txn_amount,
				 txn_amount*1.1 '!0%incresed'
		  from [transaction]
select*from IncreaseTxnamt()

--10) Create a user defined function to find the total transaction amount for a given transaction type.
create function ttltxnamount(@txn_type varchar(50))
Returns int
As
Begin
	declare @txn int;
	select @txn=sum(txn_amount)
	from [transaction]
	where txn_type=@txn_type
	Return @txn
End
Select  ttltxnamount(txn_type)from [transaction] where 
txn_type='deposit'

--11) Create a table value function which comprises of the following columns customer_id,
--region_id ,txn_date , txn_type , txn_amount which will retrieve data from the above table.
create function ct()
Returns Table
As
return
	  Select c.customer_id,
			 c.region_id,
			 t.txn_type,
			 t.txn_amount
	  from Customers c,[transaction] t
	  where c.customer_id=t.customer_id
select*from ct()
--12) Create a try catch block to print a region id and region name in a single column.

begin Try
		select concat(cast(region_id as nvarchar ),region_name) as id_name 
		from Continent
end  try
begin catch
		print 'cannot be printed'
end catch	 

--13) Create a try catch block to insert a value in the continent table.
create procedure insertcontinent 
@Region_id int,
@Region_name varchar(50)
As
Begin
	Set nocount on;
	insert into continent
				(region_id,region_name)
		   Values (@Region_id,@Region_name)
End
begin try 
	exec insertcontinent 6,'Africa'
end try
begin catch
	select
	error_message() as errormessage
end catch
--14) Create a trigger to prevent deleting a table in a database.
CREATE TRIGGER drop_safe
ON DATABASE 
FOR DROP_TABLE 
AS 
   PRINT 'You must disable Trigger "drop_safe" to drop table!' 
   ROLLBACK;
--15) Create a trigger to audit the data in a table.
create table r_audit(Audit_id int identity(1,1),
					region_id int,
					region_name nvarchar(50),
					UpdatedBy nvarchar(128),
					UpdatedTime datetime)
Go
create trigger TG_audit on continent
after Update,insert
As
Begin	
	insert into r_audit
	(region_id,region_name,updatedBy,updatedTime)
	select i.region_id,i.region_name,SUSER_SNAME(),GETDATE()
	from continent c
	join inserted i on c.region_id=i.region_id
end
--check
insert into Continent values(7,'North America')
select*from r_audit
--16) Create a trigger to prevent login of the same user id in multiple pages.
create login sam with Password = 123123
Grant view server state to sam

create trigger tg_limit_login
on all server with excute as 'sam'
FOR LOGON  
AS  
BEGIN  
IF ORIGINAL_LOGIN() = 'Sam' AND  
    (SELECT COUNT(*) FROM sys.dm_exec_sessions  
            WHERE is_user_process = 1 AND  
                original_login_name = 'sam') > 1
    ROLLBACK;  
END;
--17) Display top n customers on the basis of transaction type.
select top n-1 *from [transaction] where txn_type=''
--18) Create a pivot table to display the total purchase, withdrawal and deposit for all the customers
select*from [Transaction]
select 'sumoftxns'As totalamount_by_txn_type,
[deposit],[purchase],[withdrawal]  
from (select txn_amount,txn_type from [Transaction]) As sourceTable
Pivot (sum(txn_amount) for txn_type In ([deposit],[Purchase],[withdrawal]))
As PivotTable
