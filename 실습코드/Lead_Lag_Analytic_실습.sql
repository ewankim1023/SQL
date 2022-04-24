--lag() ���� �ຸ�� ���� ���� �����͸� ������. ���� �μ����� hiredate������ ���� ename�� ������. 
select empno, deptno, hiredate, ename
	, lag(ename) over (partition by deptno order by hiredate) as prev_ename
from hr.emp;

-- lead( ) ���� �ຸ�� ���� ���� �����͸� ������. ���� �μ����� hiredate������ ���� ename�� ������. 
select empno, deptno, hiredate, ename, 
	lead(ename) over (partition by deptno order by hiredate) as next_ename
from hr.emp;

-- lag() over (order by desc)�� lead() over (order by asc)�� �����ϰ� �����ϹǷ� ȥ���� �����ϱ� ���� order by �� asc�� �����ϴ°��� ����. 
select empno, deptno, hiredate, ename
	, lag(ename) over (partition by deptno order by hiredate desc) as lag_desc_ename
	, lead(ename) over (partition by deptno order by hiredate) as lead_desc_ename
from hr.emp; 

-- lag ���� �� windows���� ������ ���� ���� ��� default ���� ������ �� ����. �� ��� �ݵ�� offset�� ���� �����. 
select empno, deptno, hiredate, ename
	, lag(ename, 1, 'No Previous') over (partition by deptno order by hiredate) as prev_ename 
from hr.emp;

-- Null ó���� �Ʒ��� ���� ������ ���� ����. 
select empno, deptno, hiredate, ename
	, coalesce(lag(ename) over (partition by deptno order by hiredate), 'No Previous') as prev_ename 
from hr.emp;

-- �����ϰ� 1���� ���ⵥ���Ϳ� �� ���̸� ���. 1���� ���� �����Ͱ� ���� ��� ������ ���� �����͸� ����ϰ�, ���̴� 0
with
temp_01 as (
select date_trunc('day', b.order_date)::date as ord_date, sum(amount) as daily_sum
from nw.order_items a
	join nw.orders b on a.order_id = b.order_id
group by date_trunc('day', b.order_date)::date 
)
select ord_date, daily_sum
	, coalesce(lag(daily_sum) over (order by ord_date), daily_sum) as prev_daily_sum
	, daily_sum - coalesce(lag(daily_sum) over (order by ord_date), daily_sum) as diff_prev
from temp_01;