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