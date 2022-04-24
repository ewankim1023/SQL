-- �μ����� ���� hiredate�� ������ ����� sal ��������.
select empno, ename, deptno, hiredate, sal 
	, first_value(sal) over (partition by deptno order by hiredate) as first_hiredate_sal 
from emp;

-- �μ����� ���� hiredate�� �ֱ��� ����� sal ��������. windows���� rows between unbounded preceding and unbounded following�� �Ǿ�� ��. 
select empno, ename, deptno, hiredate, sal 
, last_value(sal) over (partition by deptno order by hiredate
						rows between unbounded preceding and unbounded following) as last_hiredate_sal_01
, last_value(sal) over (partition by deptno order by hiredate 
						rows between unbounded preceding and current row) as last_hiredate_sal_02
from emp;

-- last_value() over (order by asc) ��� first_value() over (order by desc)�� ���� ����. 
select empno, ename, deptno, hiredate, sal 
, last_value(sal) over (partition by deptno order by hiredate rows between unbounded preceding and unbounded following) as last_hiredate_sal
, first_value(sal) over (partition by deptno order by hiredate desc) as last_hiredate_sal
from emp;

-- first_value()�� min() ����
select empno, ename, deptno, hiredate, sal 
	, first_value(sal) over (partition by deptno order by hiredate) as first_hiredate_sal 
	, min(sal) over (partition by deptno order by hiredate) as min_sal
from emp;


-- ���ӵ� ������ �帧���� ���� Null�� ��� �ٷ� ���� �ִ� �ٷ� ���� �����͸� ���� ����. 
with ref_days
as (
	select generate_series('1996-07-04'::date , '1996-07-23'::date, '1 day'::interval)::date as ord_date
), 
temp_01 as (
	select date_trunc('day', b.order_date)::date as ord_date, sum(amount) as daily_sum
	from nw.order_items a
		join nw.orders b on a.order_id = b.order_id
	group by date_trunc('day', b.order_date)::date 
),
temp_02 as (
	select a.ord_date, b.daily_sum as daily_sum
	from ref_days a
		left join temp_01 b on a.ord_date = b.ord_date
), 
temp_03 as 
(
select *
, first_value(daily_sum) over (order by ord_date)
, case when daily_sum is null then 0
	else row_number() over () end as rnum
from temp_02
),
temp_04 as (
select *
	, max(lpad(rnum::text, 6, '0')||daily_sum) over (order by ord_date rows between unbounded preceding and current row) as temp_str
from temp_03 order by ord_date
)
select * 
	, substring(temp_str, 7)::float as inherited_daily_sum
from temp_04;