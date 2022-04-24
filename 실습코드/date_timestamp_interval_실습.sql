/******************************************************
to_date, to_timestamp �� ���ڿ��� Date, Timestamp�� ��ȯ.
to_char�� Date, Timestamp�� ���ڿ��� ��ȯ. 
*******************************************************/

-- ���ڿ��� formating�� ���� Date, Timestamp�� ��ȯ. 
select to_date('2022-01-01', 'yyyy-mm-dd');

select to_timestamp('2022-01-01', 'yyyy-mm-dd');

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss')

-- Date�� Timestamp�� ��ȯ
select to_date('2022-01-01', 'yyyy-mm-dd')::timestamp;

-- Timestamp�� Text�� ��ȯ
select to_timestamp('2022-01-01', 'yyyy-mm-dd')::text;

-- Timestamp�� Date�� ��ȯ. 
select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss')::date


-- to_date, to_timestamp, to_char �ǽ�-1
with
temp_01 as (
select a.*
	  , to_char(hiredate, 'yyyy-mm-dd') as hiredate_str
from hr.emp a
)
select empno, ename, hiredate, hiredate_str
	, to_date(hiredate_str, 'yyyy-mm-dd') as hiredate_01
	, to_timestamp(hiredate_str, 'yyyy-mm-dd') as hiretime_01
	--, to_timestamp(hiredate_str, 'yyyy-mm-dd hh24:mi:ss') as hiretime_02
	, to_char(hiredate, 'yyyymmdd hh24:mi:ss') as hiredate_str_01
	, to_char(hiredate, 'month dd yyyy') as hiredate_str_02
	, to_char(hiredate, 'MONTH dd yyyy') as hiredate_str_03
	, to_char(hiredate, 'yyyy month') as hiredate_str_04
	-- w �� �ش� ���� week, d�� �Ͽ���(1) ���� �����(7)
	, to_char(hiredate, 'MONTH w d') as hiredate_str_05
	-- day�� ������ ���ڿ��� ��Ÿ��. 
	, to_char(hiredate, 'Month, Day') as hiredate_str_06
from temp_01;

-- to_date, to_timestamp, to_char �ǽ�-2 
with
temp_01 as (
select a.*
	  , to_char(hiredate, 'yyyy-mm-dd') as hire_date_str
	  , hiredate::timestamp as hiretime
from hr.emp a
)
select empno, ename, hiredate, hire_date_str, hiretime
	, to_char(hiretime, 'yyyy/mm/dd hh24:mi:ss') as hiretime_01
	, to_char(hiretime, 'yyyy/mm/dd PM hh12:mi:ss') as hiretime_02
	, to_timestamp('2022-03-04 22:10:15', 'yyyy-mm-dd hh24:mi:ss') as timestamp_01
	, to_char(to_timestamp('2022-03-04 22:10:15', 'yyyy-mm-dd hh24:mi:ss'), 'yyyy/mm/dd AM hh12:mi:ss') as timestr_01
from temp_01;  


/********************************************************************
extract�� date_part�� �̿��Ͽ� Date/Timestamp���� ��,��,��/�ð�,��,�� ����
*********************************************************************/

-- extract�� date_part�� �̿��Ͽ� ��, ��, �� ����
select a.* 
	, extract(year from hiredate) as year
	, extract(month from hiredate) as month
	, extract(day from hiredate) as day
from hr.emp a;

select a.*
	, date_part('year', hiredate) as year
	, date_part('month', hiredate) as month
	, date_part('day', hiredate) as day
from hr.emp a;

-- extract�� date_part�� �̿��Ͽ� �ð�, ��, �� ����. 
select date_part('hour', '2022-02-03 13:04:10'::timestamp) as hour
	, date_part('minute', '2022-02-03 13:04:10'::timestamp) as minute
	, date_part('second', '2022-02-03 13:04:10'::timestamp) as second
;

select extract(hour from '2022-02-03 13:04:10'::timestamp) as hour
	, extract(minute from '2022-02-03 13:04:10'::timestamp) as minute
	, extract(second from '2022-02-03 13:04:10'::timestamp) as second


/******************************************************
��¥�� �ð� ����. interval�� Ȱ��. 
*******************************************************/

-- ��¥ ���� 
-- Date Ÿ�Կ� ���ڰ��� ���ϰų�/���� ���ڰ��� �ش��ϴ� ���ڸ� ���ذų�/���� ��¥ ���. 
select to_date('2022-01-01', 'yyyy-mm-dd') +  2 as date_01;

-- Date Ÿ�Կ� ���ϱ⳪ ������� �� �� ����. 
select to_date('2022-01-01', 'yyyy-mm-dd') * 10 as date_01;

-- Timestamp ����. +7�� �ϸ� �Ʒ��� ������ �߻�. 
select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + 7;

-- Timestamp�� interval Ÿ���� �̿��Ͽ� ���� ����. 
select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '7 hour' as timestamp_01;

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '2 days' as timestamp_01;

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '2 days 7 hours 30 minutes' as timestamp_01;

-- Date Ÿ�Կ� interval�� ���ϸ� Timestamp�� ��ȯ��. 
select to_date('2022-01-01', 'yyyy-mm-dd') + interval '2 days' as date_01;

-- interval '2 days'�� ���� ' '������ days�� day�� ȥ���ص� ������ interval '2' day�� ���. 
select to_date('2022-01-01', 'yyyy-mm-dd') + interval '2' day as date_01;

-- ��¥ ���� ���� ���ϱ�. ���̰��� ������.  
select to_date('2022-01-03', 'yyyy-mm-dd') - to_date('2022-01-01', 'yyyy-mm-dd') as interval_01
	, pg_typeof(to_date('2022-01-03', 'yyyy-mm-dd') - to_date('2022-01-01', 'yyyy-mm-dd')) as type ;

-- Timestamp���� ���� ���ϱ�. ���̰��� interval 
select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') 
     - to_timestamp('2022-01-01 12:36:52', 'yyyy-mm-dd hh24:mi:ss') as time_01
     , pg_typeof(to_timestamp('2022-01-01 08:36:52', 'yyyy-mm-dd hh24:mi:ss') 
     - to_timestamp('2022-01-01 12:36:52', 'yyyy-mm-dd hh24:mi:ss')) as type
;

-- date + date�� ������� ����. 
select to_date('2022-01-03', 'yyyy-mm-dd') +  to_date('2022-01-01', 'yyyy-mm-dd')

-- now(), current_timestamp, current_date, current_time 
-- interval�� ��, ��, �Ϸ� ǥ���ϱ�. justify_interval�� age ��� ����
with 
temp_01 as (
select empno, ename, hiredate, now(), current_timestamp, current_date, current_time
	, date_trunc('second', now()) as now_trunc
	, now() - hiredate as �ټӱⰣ
from hr.emp
)
select *
	, date_part('year', �ټӱⰣ)
	, justify_interval(�ټӱⰣ)
	, age(hiredate)
	, date_part('year', justify_interval(�ټӱⰣ))||'�� '||date_part('month', justify_interval(�ټӱⰣ))||'��' as �ټӳ��
	, date_part('year', age(hiredate))||'�� '||date_part('month', age(hiredate))||'��' as �ټӳ��_01
from temp_01;




/******************************************************
date_trunc �Լ��� �̿��Ͽ� ��/��/��/�ð�/��/�� ���� ���� 
*******************************************************/

select trunc(99.9999, 2);

--date_trunc�� ���ڷ� ���� �������� �־��� ��¥�� ����(?),
select date_trunc('day', '2022-03-03 14:05:32'::timestamp)

-- dateŸ���� date_trunc�ص� ��ȯ���� timestampŸ����. 
select date_trunc('day', to_date('2022-03-03', 'yyyy-mm-dd')) as date_01;

-- ���� date Ÿ���� �״�� �����Ϸ��� ::date�� ����� ����ȯ 
select date_trunc('day', '2022-03-03'::date)::date as date_01

-- ��, ������ ����. 
select date_trunc('month', '2022-03-03'::date)::date as date_01;

-- week�� ���� ��¥ ���ϱ�. ������ ����.
select date_trunc('week', '2022-03-03'::date)::date as date_01;

-- week�� ������ ��¥ ���ϱ�. ������ ����(�Ͽ����� ������ ��¥)
select (date_trunc('week', '2022-03-03'::date) + interval '6 days')::date as date_01;

-- week�� ���� ��¥ ���ϱ�. �Ͽ��� ����.
select date_trunc('week', '2022-03-03'::date)::date -1 as date_01;

-- week�� ������ ��¥ ���ϱ�. �Ͽ��� ����(������� ������ ��¥)
select (date_trunc('week', '2022-03-03'::date)::date - 1 + interval '6 days')::date as date_01;

-- month�� ������ ��¥ 
select (date_trunc('month', '2022-03-03'::date) + interval '1 month' - interval '1 day')::date;

-- �ú��ʵ� ���� ����. 
select date_trunc('hour', now());

--date_trunc�� ��, ��, �� ������ Group by ���� �� �� ����.
drop table if exists hr.emp_test;

create table hr.emp_test
as
select a.*, hiredate + current_time
from hr.emp a;

select * from hr.emp_test;

-- �Ի���� group by
select date_trunc('month', hiredate) as hire_month, count(*)
from hr.emp_test
group by date_trunc('month', hiredate);

-- �ú��ʰ� ���Ե� �Ի����� ��� �ú��ʸ� ������ ������ group by 
select date_trunc('day', hiredate) as hire_day, count(*)
from hr.emp_test
group by date_trunc('day', hiredate);