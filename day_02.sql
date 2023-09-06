select name
from pizzeria
left join public.person_visits pv on pizzeria.id = pv.pizzeria_id
where pv.pizzeria_id is null;

SELECT missing_date
FROM (
    SELECT DATE(generate_series('2022-01-01'::timestamp, '2022-01-10'::timestamp, '1 day')) AS missing_date
) AS date_series
LEFT JOIN (
    SELECT DISTINCT visit_date
    FROM person_visits
    WHERE person_id IN (1, 2)
) AS visits ON date_series.missing_date = visits.visit_date
WHERE visits.visit_date IS NULL
ORDER BY visit_date ASC;


select CASE WHEN p.name IS NULL THEN '-' ELSE  p.name END as person_name,
       CASE WHEN pv.visit_date IS NULL THEN NULL ELSE pv.visit_date END as visit_date,
       CASE WHEN pi.name IS NULL THEN '-' ELSE  pi.name END as pizzeria_name
       from person p
right join person_visits pv on p.id = pv.person_id
right join pizzeria pi on pv.pizzeria_id = pi.id
order by  person_name, visit_date, pizzeria_name;


SELECT missing_date
FROM (
    SELECT DATE(generate_series('2022-01-01'::timestamp, '2022-01-10'::timestamp, '1 day')) AS missing_date
) AS date_series
LEFT JOIN (
    SELECT DISTINCT visit_date
    FROM person_visits
    WHERE person_id IN (1, 2)
) AS visits ON date_series.missing_date = visits.visit_date
WHERE visits.visit_date IS NULL
ORDER BY visit_date ASC;


select pizza_name, pizzeria.name as pizzeria_name, price
from menu
left join pizzeria on menu.pizzeria_id = pizzeria.id
where menu.pizza_name = 'mushroom pizza' or menu.pizza_name = 'pepperoni pizza'
order by pizza_name, pizzeria_name;


select name
from person
where age > 25 and gender = 'female'
order by name;


select pizza_name, pizzeria.name as pizzeria_name
from person_order
join menu on menu_id = menu.id
join pizzeria on menu.pizzeria_id = pizzeria.id
join person on person_order.person_id = person.id
where person.name = 'Anna' or person.name = 'Denis'
order by pizza_name, pizzeria_name


SELECT pizzeria.name
FROM person_order
JOIN person ON person_order.person_id = person.id
JOIN menu ON person_order.menu_id = menu.id
JOIN pizzeria ON pizzeria.id = menu.pizzeria_id
WHERE person.name = 'Dmitriy' AND person_order.order_date = '2022-01-08' AND menu.price < 800;


SELECT person.name
from person_order
join menu on person_order.menu_id = menu.id
join person on person_order.person_id = person.id
where (person.address = 'Samara' or person.address = 'Moscow')
  and (person.gender = 'male')
  and (menu.pizza_name = 'pepperoni pizza' or menu.pizza_name = 'mushroom pizza')
order by name desc;


SELECT person.name
from person_order
join menu on person_order.menu_id = menu.id
join person on person_order.person_id = person.id
where (person.gender = 'female')
  and (menu.pizza_name = 'pepperoni pizza' or menu.pizza_name = 'cheese pizza')
order by name;


SELECT p1.name AS person_name1, p2.name AS person_name2, p1.address AS common_address
FROM person p1
JOIN person p2 ON p1.address = p2.address AND p1.name < p2.name
ORDER BY person_name1, person_name2, common_address;

