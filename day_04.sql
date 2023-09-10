CREATE VIEW v_persons_female AS
SELECT *
FROM person
WHERE gender = 'female'


CREATE VIEW v_persons_male AS
SELECT *
FROM person
WHERE gender = 'male'


select name
from v_persons_female
union
select name
from v_persons_male
order by name


CREATE VIEW v_generated_dates AS (
    SELECT generated_date::date
    from generate_series(
      '2022-01-01'::date,
        '2022-01-31'::date,
        '1 day'::interval
    ) AS generated_date
);


select generated_date as missing_date
from v_generated_dates
except
select visit_date
from person_visits
order by missing_date

04??


create view v_price_with_discount as (select p.name, pizza_name, price, m.price - (m.price * 0.1) AS discount_price
from person_order
join person p on p.id = person_order.person_id
join menu m on person_order.menu_id = m.id)