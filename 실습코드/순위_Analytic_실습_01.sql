/* 0. ���� SQL */

-- rank, dense_rank, row_number ����ϱ� - 1
select a.empno, ename, job, sal 
	, rank() over(order by sal desc) as rank 
	, dense_rank() over(order by sal desc) as dense_rank
	, row_number() over (order by sal desc) as row_number 
from hr.emp a;

-- rank, dense_rank, row_number ����ϱ� - 2
select a.empno, ename, job, deptno, sal 
	, rank() over(partition by deptno order by sal desc) as rank 
	, dense_rank() over(partition by deptno order by sal desc) as dense_rank
	, row_number() over (partition by deptno order by sal desc) as row_number 
from hr.emp a

/* 1. ���� �Լ� �ǽ� */

-- ȸ�系 �ٹ� �Ⱓ ����(hiredate) : ���� ������ ���� ��� �������� �з��� ���� ����
select a.*
	, rank() over (order by hiredate) as hire_rank 
from hr.emp a;

-- �μ����� ���� �޿��� ����/���� ������ ����: ���� ���� �� �������� �и��� ����.
select a.*
	, dense_rank() over (partition by deptno order by sal desc) as sal_rank_desc
	, dense_rank() over (partition by deptno order by sal ) as sal_rank_asc
from hr.emp a;

-- �μ��� ���� �޿��� ���� ���� ����:  ���� ������ ������ �ݵ�� ���� ������ ����.  
select * 
from 
(
	select a.*
		, row_number() over (partition by deptno order by sal desc) as sal_rn
	from hr.emp a
) a where sal_rn = 1;

-- �μ��� �޿� top 2 ���� ����: ���� ������ ������ �ݵ�� ���� ������ ����. 
select * 
from 
(
	select a.*
		, row_number() over (partition by deptno order by sal desc) as sal_rn
	from hr.emp a
) a where sal_rn <=2;

-- �μ��� ���� �޿��� ���� ������ ���� �޿��� ���� ���� ����. ���� ������ ������ �ݵ�� ���� ������ ����
select a.*
	, case when sal_rn_desc=1 then 'top'
	       when sal_rn_asc=1 then 'bottom'
	       else 'middle' end as gubun
from (
	select a.*
		, row_number() over (partition by deptno order by sal desc) as sal_rn_desc
		, row_number() over (partition by deptno order by sal asc) as sal_rn_asc
	from hr.emp a
) a where sal_rn_desc = 1 or sal_rn_asc=1;


-- �μ��� ���� �޿��� ���� ������ ���� �޿��� ���� ���� ���� �׸��� �� �������� �޿����̵� �Բ� ����. ���� ������ ������ �ݵ�� ���� ������ ����
with
temp_01 as (
	select a.*
		, case when sal_rn_desc=1 then 'top'
		       when sal_rn_asc=1 then 'bottom'
		       else 'middle' end as gubun
	from (
		select a.*
			, row_number() over (partition by deptno order by sal desc) as sal_rn_desc
			, row_number() over (partition by deptno order by sal asc) as sal_rn_asc
		from hr.emp a
	) a where sal_rn_desc = 1 or sal_rn_asc=1
),
temp_02 as (
	select deptno
		, max(sal) as max_sal, min(sal) as min_sal
	from temp_01 group by deptno
)
select a.*, b.max_sal - b.min_sal as diff_sal 
from temp_01 a 
	join temp_02 b on a.deptno = b.deptno
order by a.deptno, a.sal desc;

-- ȸ�系 Ŀ�̼� ���� ����. rank�� row_number ��� ����. 
select a.*
	, rank() over (order by comm desc) as comm_rank
	, row_number() over (order by comm desc) as comm_rnum
from hr.emp a;

/* 2. ���� �Լ����� null ó�� �ǽ� */

-- null�� ���� ���� ������ ó��
select a.*
	, rank() over (order by comm desc nulls first ) as comm_rank
	, row_number() over (order by comm desc nulls first) as comm_rnum
from hr.emp a;

-- null�� ���� ������ ������ ó��
select a.*
	, rank() over (order by comm desc nulls last ) as comm_rank
	, row_number() over (order by comm desc nulls last) as comm_rnum
from hr.emp a;

-- null�� ��ó���Ͽ� ���� ����. 
select a.*
	, rank() over (order by COALESCE(comm, 0) desc ) as comm_rank
	, row_number() over (order by COALESCE(comm, 0) desc) as comm_rnum
from hr.emp a;
