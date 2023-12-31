SELECT name, age FROM person WHERE address = 'Kazan';

SELECT name, age FROM person WHERE address = 'Kazan' AND  gender = 'female' ORDER BY NAME;

SELECT name, rating FROM pizzeria WHERE rating >= 3.5 and rating <= 5 ORDER BY rating;
SELECT name, rating FROM pizzeria WHERE rating BETWEEN 3.5 and 5 ORDER BY rating;

SELECT DISTINCT person_id
FROM person_visits
WHERE (visit_date BETWEEN '2022-01-06' AND '2022-01-09')
  OR (person_id = '2')
ORDER BY person_id DESC;


SELECT CONCAT(
   name,
   ' (age:', age,
   ',gender:', '''', gender, '''',
   ',address:', '''', address, ''')'
) AS person_information
FROM person
ORDER BY person_information;

SELECT
   (SELECT name
          FROM person
          WHERE person.id = person_order.person_id) AS NAME 
FROM person_order
WHERE (menu_id = 13 OR menu_id = 14 OR menu_id = 18) AND order_date = '2022-01-07';

SELECT
   (SELECT name
          FROM person
          WHERE person.id = person_order.person_id) AS NAME,
   (SELECT name ='Denis'
         FROM person
         WHERE person.id = person_order.person_id) as check_name
FROM person_order
WHERE (menu_id = 13 OR menu_id = 14 OR menu_id = 18) AND order_date = '2022-01-07';


SELECT id, name,
   CASE
       WHEN age >= 10 AND age <= 20 THEN 'interval #1'
       WHEN age > 20 AND age < 24 THEN 'interval #2'
       ELSE 'interval #3'
   END AS interval_info
   FROM person
   ORDER BY interval_info ASC;


SELECT *
FROM person_order
WHERE id % 2 = 0
ORDER BY id;


SELECT (SELECT name
       FROM person
       WHERE pv.person_id = person.id) AS person_name,
       (SELECT name
       FROM pizzeria
       WHERE pv.pizzeria_id = pizzeria.id) AS pizzeria_name
FROM (SELECT pizzeria_id, person_id
     FROM person_visits
     WHERE visit_date BETWEEN '2022-01-07' AND '2022-01-09') AS pv
ORDER BY person_name ASC, pizzeria_name DESC;
