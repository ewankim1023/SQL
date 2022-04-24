/************************************
   ���� �ǽ� - 1
*************************************/

-- ���� ������ ������ ���� �μ����� ��������
select a.*, b.dname 
from hr.emp a
	join hr.dept b on a.deptno = b.deptno;

-- job�� SALESMAN�� ���������� ������ ���� �μ����� ��������. 
select a.*, b.dname 
from hr.emp a
	join hr.dept b on a.deptno = b.deptno
where job = 'SALESMAN';
	
-- �μ��� SALES�� RESEARCH�� �Ҽ� �������� �μ���, ������ȣ, ������, JOB �׸��� ���� �޿� ���� ���� 
select a.dname, b.empno, b.ename, b.job, c.fromdate, c.todate, c.sal 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where a.dname in('SALES', 'RESEARCH')
order by a.dname, b.empno, c.fromdate;

-- �μ��� SALES�� RESEARCH�� �Ҽ� �������� �μ���, ������ȣ, ������, JOB �׸��� ���� �޿� ������ 1983�� ���� �����ʹ� �����ϰ� ������ ���� 
select a.dname, b.empno, b.ename, b.job, c.fromdate, c.todate, c.sal 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
and fromdate >= to_date('19830101', 'yyyymmdd')
order by a.dname, b.empno, c.fromdate;

-- �μ��� SALES�� RESEARCH �Ҽ� �������� ���ź��� ������� ��� �޿��� ������ ��� �޿�
with 
temp_01 as 
(
select a.dname, b.empno, b.ename, b.job, c.fromdate, c.todate, c.sal 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
order by a.dname, b.empno, c.fromdate
)
select empno, max(ename) as ename, avg(sal) as avg_sal
from temp_01 
group by empno; 



-- ������ SMITH�� ���� �Ҽ� �μ� ������ ���� ��. 
select a.ename, a.empno, b.deptno, c.dname, b.fromdate, b.todate  
from hr.emp a
	join hr.emp_dept_hist b on a.empno = b.empno
	join hr.dept c on b.deptno = c.deptno
where a.ename = 'SMITH';

/************************************
   ���� �ǽ� - 2
*************************************/

-- ���� Antonio Moreno�� 1997�⿡ �ֹ��� �ֹ� ������ �ֹ� ���̵�, �ֹ�����, �������, ��� �ּҸ� �� �ּҿ� �Բ� ���Ұ�.  
select a.contact_name, a.address, b.order_id, b.order_date, b.shipped_date, b.ship_address
from nw.customers a
	join nw.orders b on a.customer_id = b.customer_id
where a.contact_name = 'Antonio Moreno'
and b.order_date between to_date('19970101', 'yyyymmdd') and to_date('19971231', 'yyyymmdd')
;

-- Berlin�� ��� �ִ� ���� �ֹ��� �ֹ� ������ ���Ұ�
-- ����, �ֹ�id, �ֹ�����, �ֹ����� ������, ��۾�ü���� ���Ұ�. 
select a.customer_id, a.contact_name, b.order_id, b.order_date
	, c.first_name||' '||c.last_name as employee_name, d.company_name as shipper_name  
from nw.customers a
	join nw.orders b on a.customer_id = b.customer_id
	join nw.employees c on b.employee_id = c.employee_id
	join nw.shippers d on b.ship_via = d.shipper_id
where a.city = 'Berlin';

--Beverages ī�װ��� ���ϴ� ��� ��ǰ���̵�� ��ǰ��, �׸��� �̵� ��ǰ�� �����ϴ� supplier ȸ��� ���� ���Ұ� 
select a.category_id, a.category_name, b.product_id, b.product_name, c.supplier_id, c.company_name 
from nw.categories a
	join nw.products b on a.category_id = b.category_id
	join nw.suppliers c on b.supplier_id = c.supplier_id
where category_name = 'Beverages';


-- ���� Antonio Moreno�� 1997�⿡ �ֹ��� �ֹ� ��ǰ������ �� �ּ�, �ֹ� ���̵�, �ֹ�����, �������, ��� �ּ� ��
-- �ֹ� ��ǰ���̵�, �ֹ� ��ǰ��, �ֹ� ��ǰ�� �ݾ�, �ֹ� ��ǰ�� ���� ī�װ���, supplier���� ���� ��. 
select a.contact_name, a.address, b.order_id, b.order_date, b.shipped_date, b.ship_address
	, c.product_id, d.product_name, c.amount, e.category_name, f.contact_name as supplier_name
from nw.customers a
	join nw.orders b on a.customer_id = b.customer_id
	join nw.order_items c on b.order_id = c.order_id
	join nw.products d on c.product_id = d.product_id
	join nw.categories e on d.category_id = e.category_id
	join nw.suppliers f on d.supplier_id = f.supplier_id
where a.contact_name = 'Antonio Moreno'
and b.order_date between to_date('19970101', 'yyyymmdd') and to_date('19971231', 'yyyymmdd')
;

/************************************
   ���� �ǽ� - Outer ����. 
*************************************/	

-- �ֹ��� �� �ѹ��� ���� �� ���� ���ϱ�. 
select *
from nw.customers a
	left join nw.orders b on a.customer_id = b.customer_id
where b.customer_id is null;

-- �μ������� �μ��� �Ҽӵ� ������ ���� ���ϱ�. �μ��� ������ ������ ���� �ʴ��� �μ������� ǥ�õǾ�� ��. 
select a.*, b.empno, b.ename
from hr.dept a
	left join hr.emp b on a.deptno = b.deptno; 

-- Madrid�� ��� �ִ� ���� �ֹ��� �ֹ� ������ ���Ұ�.
-- ����, �ֹ�id, �ֹ�����, �ֹ����� ������, ��۾�ü���� ���ϵ�, 
-- ���� ���� �ֹ��� �ѹ��� ���� ���� ���� �������� ������ �ȵ�. �̰�� �ֹ� ������ ������ �ֹ�id�� 0���� �������� Null�� ���Ұ�. 
select a.customer_id, a.contact_name, coalesce(b.order_id, 0) as order_id, b.order_date
	, c.first_name||' '||c.last_name as employee_name, d.company_name as shipper_name  
from nw.customers a
	left join nw.orders b on a.customer_id = b.customer_id
	left join nw.employees c on b.employee_id = c.employee_id
	left join nw.shippers d on b.ship_via = d.shipper_id
where a.city = 'Madrid';

-- ���� �Ʒ��� ���� �߰��� ����Ǵ� ������ ��Ȯ�� left outer join ǥ������ ������ ���ϴ� ������ ���� �� �� ����.  
select a.customer_id, a.contact_name, coalesce(b.order_id, 0) as order_id, b.order_date
	, c.first_name||' '||c.last_name as employee_name, d.company_name as shipper_name  
from nw.customers a
	left join nw.orders b on a.customer_id = b.customer_id
	join nw.employees c on b.employee_id = c.employee_id
	join nw.shippers d on b.ship_via = d.shipper_id
where a.city = 'Madrid';

-- orders_items�� �ֹ���ȣ(order_id)�� ���� order_id�� ���� orders ������ ã�� 
select *
from nw.orders a
	left join nw.order_items b on a.order_id = b.order_id
where b.order_id is null;

-- orders ���̺� ���� order_id�� �ִ� order_items ������ ã��. 
select * 
from nw.order_items a 
	left join nw.orders b on a.order_id = b.order_id
where b.order_id is null;


/************************************
   ���� �ǽ� - Full Outer ����. 
*************************************/	

-- dept�� �Ҽ� ������ ���� ��� ����. ������ ������ �Ҽ� �μ��� ���� ��찡 ����. 
select a.*, b.empno, b.ename
from hr.dept a
	left join hr.emp b on a.deptno = b.deptno; 

-- full outer join �׽�Ʈ�� ���� �Ҽ� �μ��� ���� �׽�Ʈ�� ������ ����. 
drop table if exists hr.emp_test;

create table hr.emp_test
as
select * from hr.emp;

select * from hr.emp_test;

-- �Ҽ� �μ��� Null�� update
update hr.emp_test set deptno = null where empno=7934;

select * from hr.emp_test;

-- dept�� �������� left outer ���νÿ��� �Ҽ������� ���� �μ��� ���� ������. �Ҽ� �μ��� ���� ������ ������ �� ����.  
select a.*, b.empno, b.ename
from hr.dept a
	left join hr.emp_test b on a.deptno = b.deptno; 

-- full outer join �Ͽ� ���� ����� ������ �������� �ʵ��� ��. 
select a.*, b.empno, b.ename
from hr.dept a
	full outer join hr.emp_test b on a.deptno = b.deptno; 


/************************************
   ���� �ǽ� - Non Equi ���ΰ� Cross ����. 
*************************************/
-- ���������� �޿���� ������ ����. 
select a.*, b.grade as salgrade
from hr.emp a 
	join hr.salgrade b on a.sal between b.losal and b.hisal;


-- ���� �޿��� �̷������� ��Ÿ����, �ش� �޿��� ������ ���������� �μ���ȣ�� �Բ� �����ð�. 
select * 
from hr.emp_salary_hist a
	join hr.emp_dept_hist b on a.empno = b.empno and a.fromdate between b.fromdate and b.todate;

-- cross ����
with
temp_01 as (
select 1 as rnum 
union all
select 2 as rnum
)
select a.*, b.*
from hr.dept a 
	cross join temp_01 b;

/************************************
   Group by �ǽ� - 01 
*************************************/	

-- emp ���̺��� �μ��� �ִ� �޿�, �ּ� �޿�, ��� �޿��� ���Ұ�. 
select deptno, max(sal) as max_sal, min(sal) as min_sal, round(avg(sal), 2) as avg_sal
from hr.emp
group by deptno
;

-- emp ���̺��� �μ��� �ִ� �޿�, �ּ� �޿�, ��� �޿��� ���ϵ� ��� �޿��� 2000 �̻��� ��츸 ����. 
select deptno, max(sal) as max_sal, min(sal) as min_sal, round(avg(sal), 2) as avg_sal
from hr.emp
group by deptno
having avg(sal) >= 2000
;

-- emp ���̺��� �μ��� �ִ� �޿�, �ּ� �޿�, ��� �޿��� ���ϵ� ��� �޿��� 2000 �̻��� ��츸 ����(with ���� �̿�)
with
temp_01 as (
select deptno, max(sal) as max_sal, min(sal) as min_sal, round(avg(sal), 2) as avg_sal
from hr.emp
group by deptno
)
select * from temp_01 where avg_sal >= 2000;


-- �μ��� SALES�� RESEARCH �Ҽ� �������� ���ź��� ������� ��� �޿��� ������ ��� �޿�
select b.empno, max(b.ename) as ename, avg(c.sal) as avg_sal --, count(*) as cnt
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
group by b.empno
order by 1;

-- �μ��� SALES�� RESEARCH �Ҽ� �������� ���ź��� ������� ��� �޿��� ������ ��� �޿�(with ���� Ǯ��)
with 
temp_01 as 
(
select a.dname, b.empno, b.ename, b.job, c.fromdate, c.todate, c.sal 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
order by a.dname, b.empno, c.fromdate
)
select empno, max(ename) as ename, avg(sal) as avg_sal
from temp_01 
group by empno; 

-- �μ��� SALES�� RESEARCH �μ��� ��� �޿��� �Ҽ� �������� ���ź��� ������� ��� �޿��� �����Ͽ� ���Ұ�. 
select a.deptno, max(a.dname) as dname, avg(c.sal) as avg_sal, count(*) as cnt 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
group by a.deptno
order by 1;

-- �μ��� SALES�� RESEARCH �μ��� ��� �޿��� �Ҽ� �������� ���ź��� ������� ��� �޿��� �����Ͽ� ���Ұ�(with���� Ǯ��)
with 
temp_01 as 
(
select a.deptno, a.dname, b.empno, b.ename, b.job, c.fromdate, c.todate, c.sal 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
order by a.dname, b.empno, c.fromdate
)
select deptno, max(dname) as dname, avg(sal) as avg_sal
from temp_01 
group by deptno
order by 1; 

/************************************
   Group by �ǽ� - 02(�����Լ��� count(distinct))
*************************************/
-- �߰����� �׽�Ʈ ���̺� ����. 
drop table if exists hr.emp_test;

create table hr.emp_test
as
select * from hr.emp;

insert into hr.emp_test
select 8000, 'CHMIN', 'ANALYST', 7839, TO_DATE('19810101', 'YYYYMMDD'), 3000, 1000, 20
;

select * from hr.emp_test;

-- Aggregation�� Null���� ó������ ����. 
select deptno, count(*) as cnt
	, sum(comm), max(comm), min(comm), avg(comm)
from hr.emp_test
group by deptno;

select mgr, count(*), sum(comm)
from hr.emp
group by mgr;

-- max, min �Լ��� ���ڿ� �Ӹ� �ƴ϶�, ���ڿ�,��¥/�ð� Ÿ�Կ��� ���밡��. 
select deptno, max(job), min(ename), max(hiredate), min(hiredate) --, sum(ename) --, avg(ename)
from hr.emp
group by deptno;

-- count(distinct �÷���)�� ������ �÷������� �ߺ��� ������ ������ �Ǽ��� ����
select count(distinct job) from hr.emp_test;

select deptno, count(*) as cnt, count(distinct job) from hr.emp_test group by deptno;


/************************************
   Group by �ǽ� - 03(Group by���� ���� �÷� �� case when ����)
*************************************/
-- emp ���̺��� �Ի�⵵�� ��� �޿� ���ϱ�.  
select to_char(hiredate, 'yyyy') as hire_year, avg(sal) as avg_sal --, count(*) as cnt
from hr.emp
group by to_char(hiredate, 'yyyy')
order by 1;


-- 1000�̸�, 1000-1999, 2000-2999�� ���� 1000���� �������� sal�� �ִ� ������ group by �ϰ� �ش� �Ǽ��� ����. 
select floor(sal/1000)*1000, count(*) from hr.emp
group by floor(sal/1000)*1000;

select *, floor(sal/1000)*1000 as bin_range --, sal/1000, floor(sal/1000)
from hr.emp; 

-- job�� SALESMAN�� ���� �׷��� ���� ��츸 ����� ���/�ּ�/�ִ� �޿��� ���ϱ�. 
select case when job = 'SALESMAN' then 'SALESMAN'
		      else 'OTHERS' end as job_gubun
	   , avg(sal) as avg_sal, max(sal) as max_sal, min(sal) as min_sal --, count(*) as cnt
from hr.emp
group by case when job = 'SALESMAN' then 'SALESMAN'
		      else 'OTHERS' end ;

/************************************
   Group by �ǽ� - 04(Group by�� Aggregate �Լ��� case when �� �̿��� pivoting)
*************************************/

select job, sum(sal) as sales_sum
from hr.emp a
group by job;


-- deptno�� group by�ϰ� job���� pivoting 
select sum(case when job = 'SALESMAN' then sal end) as sales_sum
	, sum(case when job = 'MANAGER' then sal end) as manager_sum
	, sum(case when job = 'ANALYST' then sal end) as analyst_sum
	, sum(case when job = 'CLERK' then sal end) as clerk_sum
	, sum(case when job = 'PRESIDENT' then sal end) as president_sum
from emp;


-- deptno + job ���� group by 		     
select deptno, job, sum(sal) as sal_sum
from hr.emp
group by deptno, job;


-- deptno�� group by�ϰ� job���� pivoting 
select deptno, sum(sal) as sal_sum
	, sum(case when job = 'SALESMAN' then sal end) as sales_sum
	, sum(case when job = 'MANAGER' then sal end) as manager_sum
	, sum(case when job = 'ANALYST' then sal end) as analyst_sum
	, sum(case when job = 'CLERK' then sal end) as clerk_sum
	, sum(case when job = 'PRESIDENT' then sal end) as president_sum
from emp
group by deptno;

-- group by Pivoting�� ���ǿ� ���� �Ǽ� ��� ����(count case when then 1 else null end)
select deptno, count(*) as cnt
	, count(case when job = 'SALESMAN' then 1 end) as sales_cnt
	, count(case when job = 'MANAGER' then 1 end) as manager_cnt
	, count(case when job = 'ANALYST' then 1 end) as analyst_cnt
	, count(case when job = 'CLERK' then 1 end) as clerk_cnt
	, count(case when job = 'PRESIDENT' then 1 end) as president_cnt
from emp
group by deptno;

-- group by Pivoting�� ���ǿ� ���� �Ǽ� ��� �� �߸��� ���(count case when then 1 else null end)
select deptno, count(*) as cnt
	, count(case when job = 'SALESMAN' then 1 else 0 end) as sales_cnt
	, count(case when job = 'MANAGER' then 1 else 0 end) as manager_cnt
	, count(case when job = 'ANALYST' then 1 else 0 end) as analyst_cnt
	, count(case when job = 'CLERK' then 1 else 0 end) as clerk_cnt
	, count(case when job = 'PRESIDENT' then 1 else 0 end) as president_cnt
from emp
group by deptno;

-- group by Pivoting�� ���ǿ� ���� �Ǽ� ��� �� sum()�� �̿�
select deptno, count(*) as cnt
	, sum(case when job = 'SALESMAN' then 1 else 0 end) as sales_cnt
	, sum(case when job = 'MANAGER' then 1 else 0 end) as manager_cnt
	, sum(case when job = 'ANALYST' then 1 else 0 end) as analyst_cnt
	, sum(case when job = 'CLERK' then 1 else 0 end) as clerk_cnt
	, sum(case when job = 'PRESIDENT' then 1 else 0 end) as president_cnt
from emp
group by deptno;

/************************************
   Group by rollup 
*************************************/

--deptno + job���� �ܿ� dept���� ��ü job ����(�ᱹ dept����), ��ü Aggregation ����. 
select deptno, job, sum(sal)
from hr.emp
group by rollup(deptno, job)
order by 1, 2;


-- ��ǰ ī�װ� + ��ǰ�� ������ ���ϱ�
select c.category_name, b.product_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
group by c.category_name, b.product_name
order by 1, 2
;

-- ��ǰ ī�װ� + ��ǰ�� ������ ���ϵ�, ��ǰ ī�װ� �� �Ұ� ������ �� ��ü ��ǰ�� �������� �Բ� ���ϱ� 
select c.category_name, b.product_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
group by rollup(c.category_name, b.product_name)
order by 1, 2
;

-- ��+��+�Ϻ� ������ ���ϱ�
-- �� �Ǵ� ���� 01, 02�� ���� ���·� ǥ���Ϸ��� to_char()�Լ�, 1, 2�� ���� ���ڰ����� ǥ���Ϸ��� date_part()�Լ� ���. 
select to_char(b.order_date, 'yyyy') as year
	, to_char(b.order_date, 'mm') as month
	, to_char(b.order_date, 'dd') as day
	, sum(a.amount) as sum_amount
from nw.order_items a
	join nw.orders b on a.order_id = b.order_id
group by to_char(b.order_date, 'yyyy'), to_char(b.order_date, 'mm'), to_char(b.order_date, 'dd')
order by 1, 2, 3;

-- ��+��+�Ϻ� ������ ���ϵ�, ���� �Ұ� ������, �⺰ ������, ��ü �������� �Բ� ���ϱ�
with 
temp_01 as (
select to_char(b.order_date, 'yyyy') as year
	, to_char(b.order_date, 'mm') as month
	, to_char(b.order_date, 'dd') as day
	, sum(a.amount) as sum_amount
from nw.order_items a
	join nw.orders b on a.order_id = b.order_id
group by rollup(to_char(b.order_date, 'yyyy'), to_char(b.order_date, 'mm'), to_char(b.order_date, 'dd'))
)
select case when year is null then '�Ѹ���' else year end as year
	, case when year is null then null
		else case when month is null then '�� �Ѹ���' else month end
	  end as month
	, case when year is null or month is null then null
		else case when day is null then '�� �Ѹ���' else day end
	  end as day
	, sum_amount
from temp_01
order by year, month, day
;


/************************************
   Group by cube
*************************************/

-- deptno, job�� ������ �������� Group by ����. 
select deptno, job, sum(sal)
from hr.emp
group by cube(deptno, job)
order by 1, 2;

-- ��ǰ ī�װ� + ��ǰ�� + �ֹ�ó�������� ����
select c.category_name, b.product_name, e.last_name||e.first_name as emp_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
	join nw.orders d on a.order_id = d.order_id
	join nw.employees e on d.employee_id = e.employee_id
group by c.category_name, b.product_name, e.last_name||e.first_name
order by 1, 2, 3
;

--��ǰ ī�װ�, ��ǰ��, �ֹ�ó�������� ������ �������� Group by ����
select c.category_name, b.product_name, e.last_name||e.first_name as emp_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
	join nw.orders d on a.order_id = d.order_id
	join nw.employees e on d.employee_id = e.employee_id
group by cube(c.category_name, b.product_name, e.last_name||e.first_name)
order by 1, 2, 3
;