SELECT id as object_id, pizza_name as object_name
FROM menu
UNION
SELECT id as object_id, name as object_name
FROM person
ORDER BY object_id, object_name;

SELECT object_name
FROM (
    SELECT name as object_name, 1 as source_order
    FROM person
    UNION ALL
    SELECT pizza_name as object_name, 2 as source_order
    FROM menu
) AS combined_data
ORDER BY source_order, object_name;

SELECT DISTINCT pizza_name
FROM menu
ORDER BY pizza_name;

SELECT action_date, person_id
FROM (
    SELECT visit_date as action_date, person_id
    FROM person_visits
    INTERSECT
    SELECT order_date as action_date, person_id
    FROM person_order
) AS combined_data
ORDER BY action_date, person_id DESC;


SELECT person_id
FROM person_order
WHERE order_date = '2022-01-07'
UNION ALL
SELECT person_id
FROM person_visits
WHERE visit_date = '2022-01-07';

SELECT person.id, person.name, person.age, person.gender, person.address, pizzeria.id, pizzeria.id, pizzeria.name, pizzeria.rating
FROM person, pizzeria
ORDER BY person.id, pizzeria.id;

SELECT action_date, person.name as person_name
FROM (
    SELECT visit_date as action_date, person_id
    FROM person_visits
    INTERSECT
    SELECT order_date as action_date, person_id
    FROM person_order
) AS combined_data
INNER JOIN person ON combined_data.person_id = person.id
ORDER BY action_date ASC, person_name DESC;

SELECT order_date, CONCAT( person.name,' (age:', age, ')') as person_information
FROM (
    SELECT order_date as order_date, person_id
    FROM person_order
) AS combined_data
JOIN person ON combined_data.person_id = person.id
ORDER BY order_date ASC, person_information ASC;


SELECT order_date, CONCAT(person.name, ' (age:', age, ')') as person_information
FROM person_order
NATURAL JOIN person
ORDER BY order_date ASC, person_information ASC;


SELECT name
FROM pizzeria
WHERE pizzeria.id NOT IN (
    SELECT pizzeria_id
    FROM person_visits
    WHERE pizzeria.id = person_visits.pizzeria_id
);

SELECT name
FROM pizzeria
WHERE NOT EXISTS (
    SELECT 1
    FROM person_visits
    WHERE pizzeria.id = person_visits.pizzeria_id
);

SELECT person.name as person_name, menu.pizza_name as pizza_name, pizzeria.name as pizzeria_name
FROM person
INNER JOIN person_order ON person.id = person_order.person_id
INNER JOIN menu ON person_order.menu_id = menu.id
INNER JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
ORDER BY person_name ASC, pizza_name ASC, pizzeria_name ASC;