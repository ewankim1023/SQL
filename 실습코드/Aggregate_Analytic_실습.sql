/* 0. ���� SQL */

-- order_items ���̺��� order_id �� amount ���ձ��� ǥ��
select order_id, line_prod_seq, product_id, amount
	, sum(amount) over (partition by order_id) as total_sum_by_ord from nw.order_items 

-- order_items ���̺����� rder_id�� line_prod_seq������  ���� amount �ձ��� ǥ��
select order_id, line_prod_seq, product_id, amount
	, sum(amount) over (partition by order_id) as total_sum_by_ord 
	, sum(amount) over (partition by order_id order by line_prod_seq) as cum_sum_by_ord
from nw.order_items;

-- order_items ���̺��� order_id�� line_prod_seq������  ���� amount �� - partition �Ǵ� order by ���� ���� ��� windows. 
select order_id, line_prod_seq, product_id�� amount
	, sum(amount) over (partition by order_id) as total_sum_by_ord 
	, sum(amount) over (partition by order_id order by line_prod_seq) as cum_sum_by_ord_01
	, sum(amount) over (partition by order_id order by line_prod_seq rows between unbounded preceding and current row) as cum_sum_by_ord_02
	, sum(amount) over ( ) as total_sum
from nw.order_items where order_id between 10248 and 10250;

-- order_items ���̺��� order_id �� ��ǰ �ִ� ���űݾ�, order_id�� ��ǰ ���� �ִ� ���űݾ�
select order_id, line_prod_seq, product_id, amount
	, max(amount) over (partition by order_id) as max_by_ord 
	, max(amount) over (partition by order_id order by line_prod_seq) as cum_max_by_ord
from nw.order_items;

-- order_items ���̺��� order_id �� ��ǰ �ּ� ���űݾ�, order_id�� ��ǰ ���� �ּ� ���űݾ�
select order_id, line_prod_seq, product_id, amount
	, min(amount) over (partition by order_id) as min_by_ord 
	, min(amount) over (partition by order_id order by line_prod_seq) as cum_min_by_ord
from nw.order_items;

-- order_items ���̺��� order_id �� ��ǰ ��� ���űݾ�, order_id�� ��ǰ ���� ��� ���űݾ�
select order_id, line_prod_seq, product_id, amount
	, avg(amount) over (partition by order_id) as avg_by_ord 
	, avg(amount) over (partition by order_id order by line_prod_seq) as cum_avg_by_ord
from nw.order_items;


/* 1. aggregation analytic �ǽ� */ 

-- ���� ���� �� �μ����� ���� �޿��� hiredate������ ���� �޿���. 
select empno, ename, deptno, sal, hiredate, sum(sal) over (partition by deptno order by hiredate) cum_sal from hr.emp; 

--���� ���� �� �μ��� ��� �޿��� ���� �޿����� ���� ���
select empno, ename, deptno, sal, avg(sal) over (partition by deptno) dept_avg_sal
	, sal - avg(sal) over (partition by deptno) dept_avg_sal_diff
from hr.emp;

-- analytic�� ������� �ʰ� ���� ������ ��� ���
with 
temp_01 as (
	select deptno, avg(sal) as dept_avg_sal 
	from hr.emp group by deptno
)
select a.empno, a.ename, a.deptno, b.dept_avg_sal,
	a.sal - b.dept_avg_sal as dept_avg_sal_diff
from hr.emp a 
	join temp_01 b
		on a.deptno = b.deptno
order by a.deptno
;

-- ���� ������ �μ��� �� �޿� ��� ���� �޿��� ���� ���(�Ҽ��� 2�ڸ������� ���� ���)
select empno, ename, deptno, sal, sum(sal) over (partition by deptno) as dept_sum_sal
	, round(sal/sum(sal) over (partition by deptno), 2) as dept_sum_sal_ratio
from hr.emp;


-- ���� ���� �� �μ����� ���� ���� �޿� ��� ���� ���(�Ҽ��� 2�ڸ������� ���� ���)
select empno, ename, deptno, sal, max(sal) over (partition by deptno) as dept_max_sal
	, round(sal/max(sal) over (partition by deptno), 2) as dept_max_sal_ratio
from hr.emp;


-- product_id �� ������� ���ϰ�, ��ü ���� ��� ���� ��ǰ�� �� ����� ������ �Ҽ���2�ڸ��� ���� �� ����� ���� ������������ ����
with 
temp_01 as (
	select product_id, sum(amount) as sum_by_prod
	from order_items
	group by product_id
)
select product_id, sum_by_prod
	, sum(sum_by_prod) over () total_sum
	, round(1.0 * sum_by_prod/sum(sum_by_prod) over (), 2) as sum_ratio
from temp_01
order by 4 desc;

-- ������ ���� ��ǰ �����, ������ ���� ���� ��ǰ ������� ���ϰ�, �������� ���� ���� ������ �ø��� ��ǰ�� ���� �ݾ� ��� ���� ��ǰ ���� ���� ���ϱ�
with 
temp_01 as (
	select b.employee_id, a.product_id, sum(amount) as sum_by_emp_prod
	from order_items a
		join orders b on a.order_id = b.order_id
	group by b.employee_id, a.product_id
)
select employee_id, product_id, sum_by_emp_prod
	, max(sum_by_emp_prod) over (partition by employee_id) as sum_by_emp
	, sum_by_emp_prod/max(sum_by_emp_prod) over (partition by employee_id) as sum_ratio
from temp_01
order by 1, 5 desc;



-- ��ǰ�� �������� ���ϵ�, ��ǰ ī�װ��� �������� 5% �̻��̰�, ���� ī�װ����� ���� 3�� ������ ��ǰ ���� ����. 
-- 1. ��ǰ�� + ��ǰ ī�װ��� �� ���� ���. (��ǰ�� + ��ǰ ī�װ��� �� ������ �ᱹ ��ǰ�� �� ������)
-- 2. ��ǰ ī�װ��� �� ���� ��� �� ���� ī�װ����� ��ǰ�� ��ŷ ����
-- 3. ��ǰ ī�װ� ������ 5% �̻��� ��ǰ ����� ���� ���� top 3 ��ǰ ����.  
with
temp_01 as (
	select a.product_id, max(b.category_id) as category_id , sum(amount) sum_by_prod
	from  order_items a
		join products b 
			on a.product_id = b.product_id 
	group by  a.product_id
), 
temp_02 as (
select product_id, category_id, sum_by_prod
	, sum(sum_by_prod) over (partition by category_id) as sum_by_cat
	, row_number() over (partition by category_id order by sum_by_prod desc) as top_prod_ranking
from temp_01
)
select * from temp_02 where sum_by_prod >= 0.05 * sum_by_cat and top_prod_ranking <=3;