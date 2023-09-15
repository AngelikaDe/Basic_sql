create index idx_menu_pizzeria_id on menu (pizzeria_id);
create index idx_person_order_person_id on person_order (person_id);
create index idx_person_order_menu_id on person_order (menu_id);
create index idx_person_visits_person_id on person_visits (person_id);
create index idx_person_visits_pizzeria_id on person_visits (pizzeria_id);



set Enable_seqscan to off;
explain ANALYZE select pizza_name, p.name as pizzeria_name
from menu
join public.pizzeria p on menu.pizzeria_id = p.id
set Enable_seqscan to on;


create index idx_person_name on person(UPPER(name));
set Enable_seqscan  to off;
explain ANALYZE select *
from person
where upper(name) = 'ANDREY';
set Enable_seqscan to on;


create index idx_person_order_multi on person_order(person_id, menu_id,order_date);
set Enable_seqscan  to off;
explain ANALYZE SELECT person_id, menu_id,order_date
FROM person_order
WHERE person_id = 8 AND menu_id = 19;
set Enable_seqscan to on;


create unique index idx_menu_unique on menu(pizzeria_id, pizza_name);
set Enable_seqscan  to off;
explain ANALYZE SELECT pizzeria_id, pizza_name
FROM menu;
set Enable_seqscan to on;


create unique index idx_person_order_order_date on person_order(person_id, menu_id)
where order_date = '2022-01-01';
set Enable_seqscan  to off;
explain ANALYZE SELECT person_id, menu_id
FROM person_order;
set Enable_seqscan to on;


CREATE INDEX idx_1 ON pizzeria (rating);
set Enable_seqscan  to off;
explain ANALYZE SELECT
    m.pizza_name AS pizza_name,
    max(rating) OVER (PARTITION BY rating ORDER BY rating ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS k
FROM  menu m
INNER JOIN pizzeria pz ON m.pizzeria_id = pz.id
ORDER BY 1,2;
set Enable_seqscan to on;


