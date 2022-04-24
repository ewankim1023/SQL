/************************************************
cume_dist, percent_rank, ntile �ǽ�
 *************************************************/

-- cume_dist�� percentile�� ��Ƽ�ǳ��� �Ǽ��� �����ϰ� 0 ~ 1 ���� ������ ��ȯ. 
-- ��Ƽ�ǳ��� �ڽ��� ������ ���� �ο��/ ��Ƽ�ǳ��� �ο� �Ǽ��� ���� �� ����. 
select a.empno, ename, job, sal
	, rank() over(order by sal desc) as rank 
	, cume_dist() over (order by sal desc) as cume_dist
	, cume_dist() over (order by sal desc)*12.0 as xxtile
from hr.emp a;

select * from nw.order_items;

select a.order_id 
	, rank() over(order by amount desc) as rank 
	, cume_dist() over (order by amount desc) as cume_dist
from nw.order_items a;


-- percent_rank�� rank�� 0 ~ 1 ���� ������ ����ȭ ��Ŵ. 
-- (��Ƽ�ǳ��� rank() �� - 1) / (��Ƽ�ǳ��� �ο� �Ǽ� - 1)
select a.empno, ename, job, sal
    , rank() over(order by sal desc) as rank 
	, percent_rank() over (order by sal desc) as percent_rank
	, 1.0 * (rank() over(order by sal desc) -1 )/11 as percent_rank_calc
from hr.emp a;

-- ntile�� ������ ���ڸ�ŭ�� ������ ���Ͽ� �׷����ϴµ� ���. 
select a.empno, ename, job, sal
	, ntile(5) over (order by sal desc) as ntile
from hr.emp a;


-- ��ǰ ���� ���� ���� 10%�� ��ǰ �� �����
with 
temp_01 as ( 
	select product_id, sum(amount) as sum_amount
	from nw.orders a 
		join nw.order_items b 
			on a.order_id = b.order_id
	group by product_id
)
select * from (
	select a.product_id, b.product_name, a.sum_amount
		, cume_dist() over (order by sum_amount) as percentile_norm
		, 1.0 * row_number() over (order by sum_amount)/count(*) over () as rnum_norm
	from temp_01 a
		join nw.products b on a.product_id = b.product_id
) a where percentile_norm >= 0.9;

/************************************************
percentile_disc/percentile_cont �ǽ�
 *************************************************/

-- 4������ sal ���� ��ȯ. 
select percentile_disc(0.25) within group (order by sal) as qt_1
	, percentile_disc(0.5) within group (order by sal) as qt_2
	, percentile_disc(0.75) within group (order by sal) as qt_3
	, percentile_disc(1.0) within group (order by sal) as qt_4
from hr.emp;  

-- percentile_disc�� cume_dist�� inverse ���� ��ȯ. 
-- percentile_disc�� 0 ~ 1 ������ ���������� �Է��ϸ� �ش� ������ �� �̻��� �� �߿��� �ּ� cume_dist ���� ������ ���� ��ȯ
with
temp_01 as 
(
	select percentile_disc(0.25) within group (order by sal) as qt_1
	, percentile_disc(0.5) within group (order by sal) as qt_2
	, percentile_disc(0.75) within group (order by sal) as qt_3
	, percentile_disc(1.0) within group (order by sal) as qt_4
from hr.emp
)
select a.empno, ename, sal
	, cume_dist() over (order by sal) as cume_dist
	, b.qt_1, b.qt_2, b.qt_3, b.qt_4
from hr.emp a
	cross join temp_01 b
order by sal;


-- products ���̺��� category�� percentile_disc ���ϱ� 
with
temp_01 as 
(
	select a.category_id, max(b.category_name) as category_name 
	, percentile_disc(0.25) within group (order by unit_price) as qt_1
	, percentile_disc(0.5) within group (order by unit_price) as qt_2
	, percentile_disc(0.75) within group (order by unit_price) as qt_3
	, percentile_disc(1.0) within group (order by unit_price) as qt_4
from nw.products a
	join nw.categories b on a.category_id = b.category_id
group by a.category_id
)
select * from temp_01;

-- percentile_disc�� cume_dist ���ϱ� 
with
temp_01 as 
(
	select a.category_id, max(b.category_name) as category_name 
	, percentile_disc(0.25) within group (order by unit_price) as qt_1
	, percentile_disc(0.5) within group (order by unit_price) as qt_2
	, percentile_disc(0.75) within group (order by unit_price) as qt_3
	, percentile_disc(1.0) within group (order by unit_price) as qt_4
from nw.products a
	join nw.categories b on a.category_id = b.category_id
group by a.category_id
)
select product_id, product_name, a.category_id, b.category_name
	, unit_price
	, cume_dist() over (partition by a.category_id order by unit_price) as cume_dist_by_cat
	, b.qt_1, b.qt_2, b.qt_3, b.qt_4
from nw.products a 
	join temp_01 b on a.category_id = b.category_id;



--�Է� ���� �������� Ư�� �ο츦 ��Ȯ�ϰ� �������� ���ϰ�, �� �ο� �����϶� 
--percentile_cont�� �������� �̿��Ͽ� �����ϸ�, percentile_cont�� �� �ο쿡�� ���� ���� ��ȯ
select 'cont' as gubun 
	, percentile_cont(0.25) within group (order by sal) as qt_1
	, percentile_cont(0.5) within group (order by sal) as qt_2
	, percentile_cont(0.75) within group (order by sal) as qt_3
	, percentile_cont(1.0) within group (order by sal) as qt_4
from hr.emp
union all
select 'disc' as gubun 
	, percentile_disc(0.25) within group (order by sal) as qt_1
	, percentile_disc(0.5) within group (order by sal) as qt_2
	, percentile_disc(0.75) within group (order by sal) as qt_3
	, percentile_disc(1.0) within group (order by sal) as qt_4
from hr.emp;

-- percentile_cont�� percentile_disc�� cume_dist�� ��. 
with 
temp_01 as ( 
select 'cont' as gubun 
	, percentile_cont(0.25) within group (order by sal) as qt_1
	, percentile_cont(0.5) within group (order by sal) as qt_2
	, percentile_cont(0.75) within group (order by sal) as qt_3
	, percentile_cont(1.0) within group (order by sal) as qt_4
from hr.emp
union all
select 'disc' as gubun 
	, percentile_disc(0.25) within group (order by sal) as qt_1
	, percentile_disc(0.5) within group (order by sal) as qt_2
	, percentile_disc(0.75) within group (order by sal) as qt_3
	, percentile_disc(1.0) within group (order by sal) as qt_4
from hr.emp
)
select a.empno, ename, sal
	, cume_dist() over (order by sal)
	, b.qt_1, b.qt_2, b.qt_3, b.qt_4
from hr.emp a
	cross join temp_01 b
where b.gubun = 'disc'
;