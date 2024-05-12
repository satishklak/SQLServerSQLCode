/* all columns all rows - * , filter columns/print - select clause , filter rows - where clause, sort data - order by clause default asc */
select * from AMASTER -- all columns all rows - *
select acid,name from AMASTER -- some columns all rows
select * from AMASTER where BRID='BR3' -- all columns some rows
select acid,name from AMASTER where PID='FD' -- some columns some rows
select 5, 'Java' , 5+6 [My No] -- alias, custom info, constant, 18% tax,status, use for space in between [   ] , + to merge columns or concatenate
select acid,name+'hi' from AMASTER where PID='FD'
-- type cast fns to change datatypes cast(col as datatype) ansi fn, convert(datatype,col,stylenum) sqlserver fn ; Int to string ok as char/varchar accepts numbers ; convert data and time to various styles
select cbal,cast(cbal as varchar) + 'INR', convert(varchar,cbal) + 'INR' from AMASTER
select doo, convert(varchar,doo,131) from AMASTER -- 1 to 21 yy 101 to 131 yyyy
-- aggr fns count(*),min(c1),max(c1),sum(c1) -- execution of query -- from,where,aggregation,select/display -- count(c1) doesn't count NULL values
select avg(cbal) from AMASTER --avg bal in bank
select brid, count(*) from AMASTER group by brid -- branch wise no of acts
select brid, month(doo) , count(*) from AMASTER group by brid,month(doo) --  branch wise mth wise no of acts
-- execution of query -- from,where,group by group by,aggregation,select/display ; grp within grp
select brid, pid , sum(cbal) from AMASTER where year(doo) = 2011 group by brid, pid--  branch wise prod wise no of acts in yr 2011
-- any field present in select list other than aggregate, should be present in the group by clause BUT NOT vice-versa
-- do not use group by clause if no aggregs wrong select brid from amstaer group by brid
select distinct brid from AMASTER
select count(distinct brid) from AMASTER -- how many branches in bank -- use distinct with aggrgs
-- data and time funcs getdate() returns curr date from system --convert(datatype,date and time val,stylenum)
select getdate()
select convert(varchar, getdate()) -- todays date
select convert(varchar, getdate()-1) --yesterdays date
select convert(varchar, getdate(),101) -- 04/02/2024
select convert(varchar, getdate(),2) -- 24.04.02
-- datediff() diff between 2 dates in days/months/weeks/years etc., takes 3 args
select datediff(yy,'04/08/1980',getdate()) -- what is my age
select acid, name, datediff(yy,doo,getdate()) from amaster -- age of each act in bank
select acid, name, datediff(yy,doo,getdate()) from amaster where datediff(yy,doo,getdate()) = 0 -- acts opened in curr year -- today
select acid, name, datediff(yy,doo,getdate()) from amaster where datediff(yy,doo,getdate()) = 1 -- acts opened in last year -- last week
select acid, name, datediff(yy,doo,getdate()) from amaster where datediff(yy,doo,getdate()) <= 3 -- lasts 3 years
-- datepart() returns part of the date , always int, takes 2 args
select datepart(dd,getdate()) -- as current_day,mth,yr,week,hr,min dd,mm,yy,ww,hh,mi
select datepart(yy,doo) , count(*) from amaster group by datepart(yy,doo) order by 1 desc -- yr wise no of acts opened
select datepart(yy,doo) , count(*) from amaster where datepart(yy,doo) = 2011 group by datepart(yy,doo) -- list custs who oepned acts in 2011 , 
--doo = '12/04/2020' not recommended rather use datepart() split for each in 12 apr 2020
-- datename() returns name of day or month , always string, takes 2 args
select datename(dw,getdate()) -- dd,dw,mm -- find out last month name , last day of the curr month, first day name of curr month -- customized cal engmonthname, telugumonthname
-- dateadd() adds/substracts days or months or years to given date and returns past/future date, takes 3 args
select dateadd(dd,40,getdate()) -- mm -50 yy -180
--eomonth() gives last day from given date doo duedate, takes 1 arg -- rather datepart() use shortuct fns day() month() year()
-- yr wise qtr wise tot month bal
select datepart(yy,doo), 'Q'+ cast(datepart(QQ,doo) as varchar), sum(cbal) from amaster where brid='BR1' and datepart(yy,doo)=2011
group by datepart(yy,doo),datepart(QQ,doo), datename(mm,doo)
--exercises
SELECT DATENAME(month, DATEADD(month, -1, GETDATE())) AS LastMonthName -- March to find out last month name
SELECT EOMONTH(GETDATE()) AS LastDayOfMonth -- 2024-04-30 to find out last day of current month
SELECT DATENAME(WEEKDAY, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)) AS FirstDayNameOfMonth -- Monday  to find out first day name of current month
SELECT DATEPART(WEEK, DOO) AS WeekNumber,    COUNT(*) AS NumberOfAccountsOpened FROM AMASTER -- to find out week wise no of accounts opened last month
WHERE DOO >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0) -- First day of last month
    AND DOO < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) -- First day of current month
GROUP BY DATEPART(WEEK, DOO) ORDER BY WeekNumber;
SELECT NAME FROM AMASTER WHERE DATEDIFF(DAY, DOO, GETDATE()) <= 5 -- list the names of account holders who have opened accounts in last 5 days
SELECT BRID,PID, SUM(CBAL) AS TotalAmount FROM AMASTER WHERE  -- list branch-wise, product-wise total amount as on last friday
DATEPART(WEEKDAY, DOO) = 6 -- Friday 
AND DOO <= DATEADD(DAY, -2 - DATEPART(WEEKDAY, GETDATE()), CONVERT(DATE, GETDATE())) -- Last Friday
GROUP BY BRID,PID
SELECT name FROM AMASTER  -- list the customers who opened accounts in the first week of last month
WHERE DOO >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0) -- First day of last month
    AND DOO < DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), 0) -- First day of current week makes sure we're only considering accounts opened before the current week
SELECT COUNT(*) AS NumberOfCustomers FROM AMASTER -- how many customers opened accounts in last date of previous month
WHERE CONVERT(DATE, DOO) = DATEADD(DAY, -DAY(GETDATE()), GETDATE()) AND -- calculates the last day of the previous month
      CONVERT(DATE, DOO) = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) -- calculates the last day of the last month
-- Using TOP select * banned in real time , production hangs
-- TOP(n) gets the first n rows from table, TOP(n) percent gets the first n percent rows from table
select top(3) * from amaster
select top(3) percent name from amaster
-- find out month-wise no of accounts opened in the year 2011
SELECT YEAR(DOO) AS OpenYear, MONTH(DOO) AS OpenMonth, COUNT(*) AS NumberOfAccountsOpened FROM AMASTER WHERE YEAR(DOO) = 2011
GROUP BY YEAR(DOO), MONTH(DOO) ORDER BY OpenYear, OpenMonth
SELECT DATENAME(MM,DOO) AS OpenMonth, COUNT(*) AS NumberOfAccountsOpened FROM AMASTER WHERE DATEPART(YY,DOO) = 2011
GROUP BY DATEPART(MM,DOO), DATENAME(MM,DOO) ORDER BY DATEPART(MM,DOO) ASC
-- WHERE filters all rows before aggregation HAVING(used when there is an aggregation/group by) filters rows after aggregation
-- sequence select into table, from, where, group by, having, order by
-- to find branch wise total amount in the month of jan, provide details if branch=BR2
SELECT BRID, SUM(CBAL) AS TotalAmount FROM AMASTER WHERE YEAR(DOO) = 2011 AND MONTH(DOO) = 1 GROUP BY BRID
SELECT BRID, SUM(CBAL) AS TotalAmount FROM AMASTER WHERE YEAR(DOO) = 2011 AND MONTH(DOO) = 1 GROUP BY BRID HAVING BRID='BR2'
SELECT BRID, SUM(CBAL) AS TotalAmount FROM AMASTER WHERE YEAR(DOO) = 2011 AND MONTH(DOO) = 1 AND BRID='BR2' GROUP BY BRID -- not recommended as WHERE clause can filter before grouping itself
SELECT PID, COUNT(*) AS Cnt FROM AMASTER WHERE BRID='BR1' GROUP BY PID HAVING COUNT(*) > 5 -- prod wise no of custs in branch br1 , provide details if cust exceeds 5
SELECT PID, sum(cbal) AS totbal FROM AMASTER WHERE BRID='BR1' GROUP BY PID HAVING sum(cbal) > 50000 order by sum(cbal) desc -- br wise tota amt in jan month, if exceeds >50k pro ide details
-- INTO keyword last year aggregated data keep into table and query from there improves performance ; branch wise total balance , last christmas sales
SELECT BRID, SUM(CBAL) AS TotalAmount INTO AGGRBAL FROM AMASTER WHERE YEAR(DOO) = 2011 AND MONTH(DOO) = 1 GROUP BY BRID
select * from AGGRBAL
-- INTO keyword also can be planned for backup tables but no constraints (PK/FK) will be created only column names and data
-- TEMP tables created with # , only valid till session active
SELECT BRID, SUM(CBAL) AS TotalAmount INTO #AGGRBAL1 FROM AMASTER WHERE YEAR(DOO) = 2011 AND MONTH(DOO) = 1 GROUP BY BRID
select * from #AGGRBAL1
-- Blank tables like original table structure can be created without data with false conditions
SELECT * INTO AGGRBAL2 FROM AMASTER WHERE 1=2
select * from AGGRBAL2

/*
Why Joins - to retrive data from more than one table
How many tables we can join in sql - 255 tables and we must have common column
which tables to join - check DB diagram for relations ; acct,product,trans master
SQL Joins types - 4 types  ANSI inner join/join, left join, right join, full join
1.Inner/Simple/Natural/Equi - matched rows, n tables n-1 join conditions
2.Outer - LEft/Right/Full - matched+unmatched NULLs cannto be comapred
3.Cross Join (cartesian product) - no of rows in first table multiplied by no of rows in second table
4.Self join - joining table to itself, can have inner and outer joins, FK referring its own table PK
*/

select name, pname from amaster,pmaster where amaster.pid=pmaster.pid -- list names of acct holders and theiur product names
select name, txntype,count(*) from amaster join tmaster on amaster.acid=tmaster.acid group by name, txntype -- find out customer name wise , transtype wise no of transactions
select name, txntype,count(*) from amaster inner join tmaster on amaster.acid=tmaster.acid where datediff(yy,dot,getdate()) = 1 group by name, txntype -- last year trasnsactions
select name, txntype,count(*) from amaster inner join tmaster on amaster.acid=tmaster.acid where datepart(yy,dot) = 2011 group by name, txntype -- 2011 trasnsactions
select distinct name,pid from amaster inner join tmaster on amaster.acid=tmaster.acid where txntype = 'CD' -- -- list names of act holders who deposited cash, and their product names ; select distinct transacs if duplicates

select * from amaster left join tmaster on amaster.acid=tmaster.acid where tno is null -- -- list names of act holders who did not do transacs
select e1.name as emp e1, e2.name as mgr e2 from emp join mgr on e1.empid=e2.mgrid

-- Union (is merge not matched records pk/fk like joins)
-- combine results of two or more select stats, same no of cols in each query, corr cols to be of same datatype, duplicates eliminated by default, union sorts the data
-- union all keeps duplicates and faster
select name,address from customer
union all
select name,address from vendor 

-- LIKE operator

select * from amaster where name like 'k%' 				-- 1st letter is k
select * from amaster where name like '_k%' 		    -- 2nd letter is k
select * from amaster where name not like 'k%'          -- 1st letter cannot be k
select * from amaster where name not like '%k'          -- end letter is k
select * from amaster where name not like 'k%o'         -- starts with k and ends with o
select * from amaster where name not like '%k%'         -- name contains k
select * from amaster where name not like 'b%n'         -- name starts with b and ends with n
select * from amaster where name not like '%Reddy'      -- end with Rao

-- ISNULL() returns constant value, when the column contains NULL value ; check schema for column NULLs
select acid,name,isnull(cbal,0) from AMASTER

select coalesce(fn,mn,ln) as ename from emp -- returns first non-null value ; if all values are NULLs gives NULLs
select isnull(fn,' ')+isnull(mn,' ')+isnull(ln,' ') as ename from emp
select concat(fn,mn,ln) as fullname from emp

--string functions
select upper(name) uppercname, lower(name) lowercname, left(name,3) as first3chars, right(name,2) as last2chrs,
len(name), reverse(name), ltrim(name), rtrim(name), ltrim(rtrim(name)), trim(name) ,
substring(name,3 starting letter,4 no of letters), reverse(substring(reverse(name),1,5)), -- works without condition
stuff(name, 1, 3, 'data') no condition , replace(name, 'ee' searchstring, 'i' replacestring) condition based -- works if condition is true
datediff(yy,dob,getdate()) >= 21 and datediff(yy,dob,getdate()) <= 58
-- space() gives space in between strings
fn + space(1) + ln
charindex(searchingletter, colname, startlocation) -- 'o' in string charindex(' ', 'Hello World')
--find emailid correct or not charindex('@', 'bhaskargmail.com')
patindex('%reach%','all guys ensure that,reach class on time') --23 returns starting pos of the first occurence of a pattern in a specified expression , or zeros if pattern is not found
--patindex('%pattern%', expression)
--emailid correct or not 
email varchar(100) not null check (charindex('@',email) <> 0)
dob datetime datediff(yy,dob,getdate()) >= 21 and datediff(yy,dob,getdate()) <= 58
Sql server can have .net code assembly for complex patterns/expressions ex @,.

-- between operator
-- list the names of the customers whose balance between 10k and 50k, who have opened accounts between 2010 and 2012
SELECT Name FROM Customers WHERE Balance BETWEEN 10000 AND 50000;
SELECT Name FROM Customers WHERE YEAR(OpenDate) BETWEEN 2010 AND 2012; DATEPART(YEAR, OpenDate)


select col1,col2,
  case
    when <expression> then <constant>
    ....
    else <constant>
  end as alias
from tablename 

select acid,name,cbal,
  CustType =
  case 
      when cbal < 10000 then 'Silver'
      when cbal between 10000 and 50000 then 'Gold'
      else 'Platinum'
  end
from amaster

select acid,name,cbal,
  popularity =
  case 
      when cbal < 10000 then 'Silver'
      when cbal between 10000 and 50000 then 'Gold'
      else 'Diamond'
  end
from amaster

select eid, 
       empname =
	   case
	       when gender = 'M' then 'Mr.'+Name
		   else 'Ms.'+Name
	   end
from emp

string_Agg(ename, ' ')  string_Agg(ename, ',')  -- concatenate rows
isnull(fn,'')+isnull(ln,'') -- concatenate columns

-- Programming (programing lang) means processing ram + processor, storing means storage; sql/c or rdbms


SELECT COUNT(*) AS NumberOfEmployees FROM emp;
SELECT COUNT(*) AS NumberOfEmployeesInChennai FROM emp WHERE city = 'Chennai';
SELECT COUNT(*) AS NumberOfEmployeesInChennaiHyderabad FROM emp WHERE city IN ('Chennai', 'Hyderabad');
SELECT COUNT(*) AS NumberOfMaleEmployeesInBangalore FROM emp WHERE city = 'Bangalore' AND gender = 'M';
SELECT city, COUNT(*) AS NumberOfEmployees FROM emp WHERE city IN ('Hyderabad', 'Chennai', 'Bangalore') GROUP BY city;
SELECT city, SUM(salary) AS TotalSalary, COUNT(*) AS NumberOfEmployees FROM emp GROUP BY city;
SELECT gender, city, COUNT(*) AS NumberOfEmployees FROM emp WHERE city = 'Hyderabad' GROUP BY gender, city;
SELECT MAX(salary) AS MaxSalaryInChennai FROM emp WHERE city = 'Chennai';



-- subquery or nested query or inner query
--who has the highest balance in the bank? what is the max bal?
select max(cbal) from amaster 709700.00
select name, max(cbal) from amaster group by name
select top 1 name from amaster order by cbal desc
select * from amaster where cbal = max(cbal)
select name,cbal from amaster where cbal = (select max(cbal) from amaster) valid

/*
subquery - a query in WHERE/SELECT/HAVING clause ; execution - bottom to top ; always sq gets executed first and result is passed to outer query;
sq returns multiple values 'IN' or single value '=' (single col) ; doesnot support multiple cols in sq
*/

select acid, name, cbal - avg(cbal) from amaster //invalid
select acid, name, cbal - (select avg(cbal) from amaster) from amaster

select max(cbal) from amaster where cbal < (select max(cbal) from amaster)

select name from amaster where cbal = 
					( 
						select max(cbal) from amaster where cbal < 
											   ( select max(cbal) from amaster)
                                        )
										/* max 32 levels nesting is allowed */


select name from amaster where cbal = 
                                        (
                                           select min(cbal) from amaster where cbal in 
                                                                                          ( select distinct top 2 cbal from amaster order by cbal desc)
                                        )

--who has the 2nd highest balance in the bank? max 32 levels nesting is allowed in the sub queries
select max(bal) from amaster where cbal < (select max(bal) from amaster)
select name from amaster where cbal = 
					( 
						select max(cbal) from amaster where cbal < 
											   ( select max(cbal) from amaster)
                                        )

who has the 10th highest balance in the bank?
select name from amaster where cbal = 
                                        (
                                           select distinct cbal from amaster a where 10 =
                                                                                          ( select count(distinct cbal) from amaster b where a.cbal<=b.cbal)
                                        )
1.sort the cbal in desc 2.distinct 3.Top 4 4.min 5.name
select name from amaster where cbal = 
                                        (
                                           select min(cbal) from amaster where cbal in 
                                                                                          ( select distinct top 2 cbal from amaster order by cbal desc)
                                        )

-- machine vs human understandable code key that’s why c lang big cocern(code maint) then oops easiness of code ur own code can be 
--executed c++/java/.net(easy maint)

--list the ACID and the name where the account holder has done more than 3 transactions for the month of November 2011
select acid, name from amaster where acid in
                                        (
                                          select acid from tmaster where month(dot)=11 and year(dot)=2011 group by acid having count(*) > 3
                                        )
--find employees with salary higher than their department average

SELECT e.employee_id, e.employee_name, e.salary, d.department_name, d.avg_salary FROM employees e
INNER JOIN ( SELECT department_id, AVG(salary) AS avg_salary FROM employees GROUP BY department_id ) d 
ON e.department_id = d.department_id WHERE e.salary > d.avg_salary;

select 'select * from '+ name from sys.tables

/*
correlated subquery
it is similar to loop in a loop concept of any PLang; in this outer query is executed first and then result is passed to the inner query ; then inner query 
is executed repeatedly for each value of the outer query ; here the execution is from top to bottom ; inner query is dependent on outer query

exists() is a boolean ,fn returns T or F , used to find existence of at least one matched rows (T atleast a row , F no rows)
list the names of the act holders who have done transactions, not doen transactions not exists
select name from amaster am where exists (select * from tmaster tm where am.acid=tm.acid)

databases (32767) 2 types -system dbs (master,model,msdb,tempdb) -user dbs 
tables 2 types of tables - system tables - user tables
*/
-- alltables info , system table
select * from sys.tables where object_id = 160719625
-- how many tables
select count(*) as nooftables from sys.tables
-- all cols in a db
select * from sys.colums where name = 'cbal'
-- colname,identify the table
select a.name, b.name from sys.tables as a join sys.columns as b on a.object_id=b.object_id where b.name='ubal'
-- check emp tables exists or not
if exists (select * from sys.tables where name = 'emp')
     drop table emp
go
-- all db name
select * from sys.databases
-- if exists , u drop it
if exists (select * from sys.databases where name = 'School') 
      drop database School
go
  create database School
go

--status , get cols of AM table
select * from sys.columns where object_id=165575628
select count(*) from sys.columns where object_id = ( select object_id from sys.tables where name = )
-- find out no of cols in am table
select count(*) from sys.colums where object_id = 
if not exists ( select * from sys.databses where name = 'School')
   create database School1
go
-- all sp . triggers
select * from sys.procedures , sys.triggers
-- get all tables
select 'select * from '+ name from sys.tables

-- if emp table exists in db, then drop it and create it
-- Drop the employees table if it exists
DROP TABLE IF EXISTS employees;

-- Create the employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(255),
    department_id INT,
    salary DECIMAL(10, 2)
);

-- month wise no of new customers
SELECT 
    YEAR(registration_date) AS registration_year,   MONTH(registration_date) AS registration_month,     COUNT(customer_id) AS new_customers
FROM  customers
GROUP BY 
    YEAR(registration_date),  MONTH(registration_date)
ORDER BY 
    registration_year, registration_month;

	select a.acid,name, count(*) as nooftransacs from amaster as A join tmaster as T on a.acid=t.acid where datepart(yy,dot)=2011 group by a.acid,name


-- Derived Table - A query in the FROM clause , must have alias, can also be used in Joins
select * from (select * from amaster) as k 
-- query in WHERE clause is sub query but query in FROM cluase is DT, more than one value is possible here
-- list the acid,name and no of transcs where the acctholder has done more than 3 transacs for the year 2011
select a.acid,name, count(*) as nooftransacs from amaster as A join tmaster as T on a.acid=t.acid group by a.acid,name
select a.acid,name, count(*) as nooftransacs from amaster as A join tmaster as T on a.acid=t.acid where datepart(yy,dot)=2011 group by a.acid,name
--dt 
select a.acid, name , nooftranscs from amaster as a
join ( select acid, count(*) as nooftranscs from tmaster where datepart(yy,dot)=2011 group by acid) as k on a.acid=k.acid
-- eliminate asap and join alap , elimination with where post joins having millions of records hits performance badly, avoid using lengthy cols in group by
select a.acid, name , nooftranscs from amaster as a
join ( select acid, count(*) as nooftranscs from tmaster where datepart(yy,dot)=2011 group by acid having count(*)>3) as k on a.acid=k.acid

-- find out month wise, no of new customers
select datename(mm,mindate) as monthnm, count(*) as cnt
from 
	( select cid, min(dos) as mindate from customers group by cid) as k
group by datename(mm,mindate), datepart(mm,mindate)
order by datepart(mm,mindate) asc

-- list branch wise total amt and % of total amt of all branches

SELECT branch_id, SUM(amount) AS total_amount,  100.0 * SUM(amount) / (SELECT SUM(amount) FROM transactions) AS percentage_of_total
FROM transactions GROUP BY     branch_id;

SELECT t.branch_id,SUM(t.amount) AS total_amount,100.0 * SUM(t.amount) / total.total_amount AS percentage_of_total
FROM transactions t 
JOIN 
    (SELECT SUM(amount) AS total_amount FROM transactions) AS total
GROUP BY  t.branch_id;



/*
These many queries to be written , if thousands …. mad so SSAS performs all above table aggrgs ; multi dim analysis ; query with cube
helps all p&c (creates multi dim aggrgs  implemented same in SSAS s/w) ; roll up aggrgs subset only left to right aggrgs gives , 
will give less p&c vs all p&c
*/
select itemname, color, sum(qnty) as total from item group by itemname,color with CUBE
select itemname, color, sum(qnty) as total from item group by itemname,color with ROLLUP
/*
ranking fns - used to provide ranking for rows, based on one or more conditions, introduced in 2005
row_number(), rank(), dense_rank(), ntile()-splits the data. partition by - groups the data
ranking fns syntax
select col, rank_fnname() over (order by col desc/asc) as alias from table
*/
-- row no
select acid, name, cbal, row_number() over (order by acid asc) as rno from amaster
-- get 5th row
select * from 
(
  select acid, name, cbal, row_number() over (order by acid asc) as rno from amaster
) as k 
where rno=5
-- partition by
select acid, name, cbal, brid, row_number() over (partition by brid order by acid desc) as rno from amaster
-- each and every branch first guy to know
select * from 
(
  select acid, name, cbal, brid, row_number() over (partition by brid order by acid desc) as rno from amaster
) as k 
where rno=1

-- get every 5th row from the table
select * from 
(
  select *, row_number() over (order by acid) as rno from amaster
) as k 
where rno%5=0

-- get alternate rows from table
select * from 
(
  select *, row_number() over (order by acid asc) as rno from amaster
) as k 
where rno%2=0

-- If there is no derived table RNO will not work as it is not table col name ; second and fourth highest balance
select acid, name, cbal, brid, RANK() over (Order By cbal desc) as RnkNo,
                               Dense_Rank() over (Order By cbal desc) as RnkNo
from amaster
-- RANK() GAP Dense_Rank() NoGap
-- who is having highest balance in the bank
select * from
( select acid, name, cbal, brid, Dense_Rank() over (Order By cbal desc) as RnkNo from amaster) as K
where RnkNo = 1
-- branch wise highest balance customers
select * from
( select acid, name, cbal, brid, Dense_Rank() over (Partition By BRID Order By cbal desc) as RnkNo from amaster) as K
where RnkNo = 1
-- cut data into parts/tiles below 4 grps/tiles
select * from
( select acid, name, cbal, NTILE(4) over (Order By acid asc) as GrpNo from amaster) as K
where GrpNo = 2
----
/*
CTE - Common Table Expression
similar to derived table , introduced in 2005, can be declared once...use it many times
syntax :
with <cte name>
as (select statements)
-- read the data from CTE
select * from <cte name>
*/
with k
as (select acid,name,cbal,row_number() over(order by acid asc) as rno from amaster)
select * from k where rno = 1

/*
cte - declared once use many times, query scope, reusability
dts - declared once use only once , query scope, no reusability

find out the branch which has highest no of customers using derived table
*/
SELECT 
    branch_id, COUNT(customer_id) AS total_customers
FROM customers
GROUP BY branch_id
HAVING COUNT(customer_id) = (
        SELECT COUNT(customer_id) FROM customers GROUP BY branch_id
        ORDER BY COUNT(customer_id) DESC
        LIMIT 1
    );

/*

In this query:

The inner subquery calculates the count of customers for each branch, orders the results in descending order, and selects the 
first row using the LIMIT 1 clause, thus obtaining the highest count of customers among all branches.
The outer query then selects the branch ID and the count of customers for branches where the count matches the maximum count 
obtained from the inner subquery.
*/

WITH CustomerCounts AS (
    SELECT branch_id, COUNT(customer_id) AS total_customers
    FROM customers GROUP BY branch_id
)
SELECT branch_id,total_customers
FROM CustomerCounts
WHERE total_customers = (
        SELECT MAX(total_customers) FROM CustomerCounts
    );

/*
In this query:

The CTE named CustomerCounts calculates the count of customers for each branch.
The main query then selects the branch ID and the count of customers from the CTE where the count matches the maximum count 
obtained from the CTE.
The subquery (SELECT MAX(total_customers) FROM CustomerCounts) calculates the maximum count of customers among all branches.
*/

-- Create a temporary table and insert data into it
SELECT branch_id,COUNT(customer_id) AS total_customers INTO #Temp_CustomerCounts
FROM customers GROUP BY branch_id;

-- Retrieve the branch with the highest number of customers
SELECT branch_id,total_customers FROM #Temp_CustomerCounts
WHERE total_customers = ( SELECT MAX(total_customers) FROM #Temp_CustomerCounts);

-- Drop the temporary table once it's no longer needed
DROP TABLE IF EXISTS #Temp_CustomerCounts;

-- Retrieve the first branch ID with the highest number of customers
SELECT branch_id FROM #Temp_CustomerCounts
WHERE total_customers = ( SELECT MAX(total_customers) FROM #Temp_CustomerCounts )
LIMIT 1;

SELECT TOP 1 branch_id
FROM #Temp_CustomerCounts
WHERE total_customers = ( SELECT MAX(total_customers) FROM #Temp_CustomerCounts
    );

-- SECOND BRANCH ID
SELECT TOP 1 branch_id FROM #Temp_CustomerCounts
WHERE total_customers = (
        SELECT MAX(total_customers) FROM #Temp_CustomerCounts
    )
AND 
    branch_id NOT IN ( 
        SELECT TOP 1 branch_id FROM #Temp_CustomerCounts
        WHERE total_customers = (
                SELECT MAX(total_customers) FROM #Temp_CustomerCounts
            )
    ) LIMIT 1 ;

-- 4th branchid
SELECT TOP 1 branch_id
FROM (
    SELECT branch_id, ROW_NUMBER() OVER (ORDER BY total_customers DESC) AS row_num
    FROM #Temp_CustomerCounts
) AS ranked
WHERE row_num = 4;

/*
derived tables - 	        create once, use once , 		scope : single query
cte - 		 				create once, use many times, 	scope : single query
local temp table (#)-        create once, use many times, 	scope : window level
global temp table (##)-      create once, use many times, 	scope : across window level
*/

WITH DuplicateRows AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY (SELECT NULL)) AS row_num
    FROM emp
)
DELETE FROM DuplicateRows WHERE  row_num > 1;

In this query:

We use a CTE named DuplicateRows to assign a row number to each row within each group of duplicate rows based on the employee_id. The ROW_NUMBER() function 
is used for this purpose.
The DELETE statement then deletes the duplicate rows where the row_num is greater than 1, meaning only keeping the first occurrence of each row.

/*
Window functions are used to perform calculations across a set of rows related to the current row within a query result set. 
They are particularly useful for calculating running totals, moving averages, rankings, and other analytics functions. 
Here's how you can use window functions to calculate a running total:
*/

SELECT *, SUM(cbal) OVER (PARTITION BY branch_id ORDER BY acid asc) AS running_total FROM amaster;
-- RUNNING TOTAL using sub query , joins

-- system tables
sys.tables, sys.databases, sys.columns, sys.views, sys.triggers, sys.procedures, sys.objects


-- merge statement to perform incremental loading
-- dml statement is a combination statement that can perform INSERT, UPDATE, DELETE statements based on whether rows that match the selection criteria 
-- exist in the target table or not
-- merge syntax
merge target_table as target using source_table as source on condition
when matched            then update set col = source.col, ...
when target not matched then insert values (source.col1, source.col2,)
