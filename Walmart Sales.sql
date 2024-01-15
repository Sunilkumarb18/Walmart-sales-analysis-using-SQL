
select * from sales

select distinct [Product line] from sales

select top 1 [Product line],COUNT(*)[Total Sales] from sales
group by [Product line]
order by [Total Sales] desc

select FORMAT(cast(Date as date),'MM')[Month],
       SUM(cast(Total as decimal(18,2))) [Total Sales]
from sales
group by FORMAT(cast(Date as date),'MM') 

select FORMAT(cast(Date as date),'MM')[Month] 
from sales
where cogs =(select MAX(cogs) from sales)

select top 1 [Product line],
             SUM(cast (Total as decimal(18,2)))[Total Revenue] from sales
group by [Product line]
order by sum(cast(Total as decimal(18,2))) desc

select top 1 City,sum(cast(Total as decimal(18,2)))[Total Revenue] from sales
group by City
order by [Total Revenue] desc

select top 1 [Product line],
             max([Tax 5%])[Highest Tax] from sales
group by [Product line] 
order by [Highest Tax] desc

select [Product line],
       case when sum(cast(Total as decimal(18,2)))>(select AVG(cast(Total as decimal(18,2))) from sales) 
	        then 'Good' 
			else 'Bad' 
	   end           [Sales Review]
from sales
group by [Product line]

select [Product line],
       case when sum(cast(Quantity as int))>(select AVG(cast(Quantity as int)) from sales) then sum(cast(Quantity as int)) end [Total Qty]
from sales
group by [Product line]

select a.Gender,a.[Product line] from (
select Gender,
       [Product line],
	   SUM(cast(Quantity as int)) [Total Quantity],
	   DENSE_RANK() over (partition by gender order by  SUM(cast(Quantity as int)) desc) rnk
from sales
group by Gender,[Product line]) a where rnk=1

select [Product line],
       AVG(cast(Rating as decimal(18,2))) [Avg Rating]
from sales
group by [Product line]

select [Product line],
       AVG(cast(Rating as decimal(4,2))) [Avg rating]
from sales
group by [Product line]

select FORMAT(cast(Date as date),'dd') from sales

alter table sales add Weekday int
update s
set s.Weekday = case when cast(FORMAT(cast(Date as date),'MM') as int)=1 then 'Monday'
                     when cast(FORMAT(cast(Date as date),'MM') as int)=2 then 'Tuesday'
					 when cast(FORMAT(cast(Date as date),'MM') as int)=3 then 'Wednesday'
					 when cast(FORMAT(cast(Date as date),'MM') as int)=4 then 'Thursday'
					 when cast(FORMAT(cast(Date as date),'MM') as int)=5 then 'Friday'
					 when cast(FORMAT(cast(Date as date),'MM') as int)=6 then 'Saturday'
				else 'Sunday'
				end
from sales s

select Weekday,
       COUNT([Invoice ID]) [Total Orders]
from sales
group by Weekday
order by Weekday

select top 1 [Customer type],
       SUM(cast(Total as decimal(18,2)))[Total Sales] 
from sales
group by [Customer type]
order by [Total Sales] desc

select top 1 City,
       max(cast([Tax 5%] as decimal(18,2))) [VAT]
from sales
group by City
order by VAT

select s.[Customer type] from (
								select top 1 [Customer type],
									   avg(cast([Tax 5%] as decimal(18,2))) [AVG VAT]
								from sales
								group by [Customer type]
								order by [AVG VAT] desc
						      )s


select count(distinct [Customer type])[Total Customer Types] 
from sales

select COUNT(distinct Payment)[Payment Methods] from sales

select [Customer type] from (
				select top 1 [Customer type],
							 COUNT(*)[Total] 
				from sales
				group by [Customer type]
				order by Total desc
			  )s

select [Customer type] from(
							select top 1 [Customer type],
										 SUM(cast(Total as decimal(18,2))) [Total Sales]
							from sales
							group by [Customer type]
							order by [Total Sales] desc
			               )s

select Gender from (
				select top 1 
								Gender,
								COUNT(*) [Total Count] from sales
				group by Gender
				order by [Total Count] desc
				)s

select top 1 
								Gender
								--COUNT(*) [Total Count]
								from sales
				group by Gender
				order by COUNT(*) desc

select Branch,
       SUM(case when Gender='Male' then 1 else 0 end) [Males],
	   SUM(case when Gender='Female' then 1 else 0 end) [Females]
from sales
group by Branch

select top 1 Time 
				from sales
				group by Time
				order by COUNT(Rating) desc

select  Branch,Time from (
select  Branch,
       Time,
	   COUNT(Rating) [Total]
	   ,row_number() over(partition by Branch order by COUNT(Rating) desc) rnk
				from sales
				group by Time,Branch
				)s where rnk=1

select top 1  Weekday 
from sales
group by Weekday
order by AVG(cast(Rating as decimal(18,2))) desc


select Branch,Weekday from (
							select Branch,Weekday,
								   AVG(cast(Rating as decimal(5,2))) [AVG Rating] 
								   ,DENSE_RANK()over(partition by Branch order by AVG(cast(Rating as decimal(5,2))) desc) rnk
							from sales
							group by Branch,Weekday
							)s
where rnk=1