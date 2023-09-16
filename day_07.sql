select p.id AS person_id, COUNT(pv.id) AS count_of_visits --different output
from person p
join person_visits pv on p.id = pv.person_id
GROUP BY p.id
order by count_of_visits desc, person_id;


select p.name AS person_id, COUNT(pv.id) AS count_of_visits
from person p
join person_visits pv on p.id = pv.person_id
GROUP BY p.id
order by count_of_visits desc, p.name
LIMIT 4;


with id_order as(SELECT p.id AS p_id, COUNT(po.id) AS count, 'order' AS action_type
FROM person_order po
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria p ON m.pizzeria_id = p.id
GROUP BY p.id
ORDER BY count DESC
limit 3),
    id_visit as (SELECT pizzeria_id as p_id, count(pv.pizzeria_id) as count, 'visit' as action_type
from person_visits pv
group by pizzeria_id
order by count desc
limit 3)
select name, count, action_type from (
    select * from id_visit
    union all
    select  * from id_order) as data
join pizzeria on p_id = id
order by action_type, count desc;


SELECT p.name AS person_id, COUNT(pv.id) AS count_of_visits
    FROM person p
    JOIN person_visits pv ON p.id = pv.person_id
    GROUP BY p.name
    HAVING COUNT(pv.id) > 3
    ORDER BY count_of_visits DESC, p.name



select name
from person
where id in (select person_id from person_order)
order by name


select p.name, COUNT(*) count_of_orders, AVG(price), max(price), min(price)
from pizzeria p
join public.menu m on p.id = m.pizzeria_id
join person_order po on m.id = po.menu_id
group by p.name
order by p.name;



select round(avg(rating)) as global_rating
from pizzeria


select p.address, p1.name as pizzeria_name , COUNT(*) count_of_orders
from person p
join person_order po on p.id = po.person_id
join menu m on po.menu_id = m.id
join pizzeria p1 on m.pizzeria_id = p1.id
group by p.address, p1.name
order by address, p1.name


SELECT p.address,
    round(max(age::numeric) - (min(age::numeric) / max(age::numeric)), 2) AS formula,
    round(AVG(p.age),2) AS average,
    CASE WHEN (round(max(age::numeric) - (min(age::numeric) / max(age::numeric)), 2)) > AVG(p.age)
        THEN 'true' ELSE 'false' END AS comparison
FROM person p
GROUP BY p.address
ORDER BY p.address;
