select pizza_name, price, p2.name as pizzeria_name, pv.visit_date
from person p
    join person_visits pv on p.id = pv.person_id
    join pizzeria p2 on pv.pizzeria_id = p2.id
    join menu m on p2.id = m.pizzeria_id
where p.name = 'Kate' and m.price between 800 and 1000
order by pizza_name, price, p2.name;



select menu.id
from menu
where menu.id not in(select menu.id
                 from menu
    join person_order on menu.id = person_order.menu_id)



select menu.pizza_name, menu.price, p.name
from menu
join pizzeria p on menu.pizzeria_id = p.id
where menu.id not in(select menu.id
                 from menu
    join person_order on menu.id = person_order.menu_id)
order by pizza_name, price


WITH visits AS (
    SELECT pizzeria.id, pizzeria.name as pizzeria_name, person.gender
    FROM person_visits
    JOIN person ON person_visits.person_id = person.id
    JOIN pizzeria ON person_visits.pizzeria_id = pizzeria.id
),

male_visits AS (
    SELECT *
    FROM visits v
    WHERE v.gender = 'male'
),

female_visits AS (
    SELECT *
    FROM visits v
    WHERE v.gender = 'female'
),

female_count_visits AS (
    SELECT id, pizzeria_name, COUNT(*) AS visit_count, gender
    FROM female_visits
    GROUP BY id, pizzeria_name, gender
),

male_count_visits AS (
    SELECT id, pizzeria_name, COUNT(*) AS visit_count, gender
    FROM male_visits
    GROUP BY id, pizzeria_name, gender
),

equal as (
    select female_count_visits.pizzeria_name, female_count_visits.visit_count
    from female_count_visits
    inner join male_count_visits on male_count_visits.pizzeria_name = female_count_visits.pizzeria_name
    WHERE male_count_visits.visit_count = female_count_visits.visit_count
),

male_not_equal as (select pizzeria_name
             from male_count_visits
             except all
             select pizzeria_name
             from equal),

female_not_equal as (select pizzeria_name
             from female_count_visits
             except all
             select pizzeria_name
             from equal)

select * from female_not_equal
intersect
select * from male_not_equal
order by pizzeria_name


with visits_all as (select pizzeria_id, pizzeria.name as pizzeria_name, person_id
                   from person_visits
                   join pizzeria
                   on person_visits.pizzeria_id = pizzeria.id),

    male_visits as (select DISTINCT pizzeria_id, pizzeria_name
                         from visits_all
                         join person on person_id = person.id
                         where person.gender = 'male'),

    female_visits as (select DISTINCT pizzeria_id, pizzeria_name
                         from visits_all
                         join person on person_id = person.id
                         where person.gender = 'female'),

    female_only as (select pizzeria_id, pizzeria_name
                    from female_visits
                    except
                    select pizzeria_id, pizzeria_name  from male_visits),

    male_only as (select pizzeria_id, pizzeria_name
                    from male_visits
                    except
                    select pizzeria_id, pizzeria_name from female_visits)

select pizzeria_name
from  female_only
union
select pizzeria_name
from male_only

with visits_all as (select gender, pizzeria.name as pizzeria_name
                   from person_order
                       join person on person_order.person_id = person.id
                       join menu on person_order.menu_id = menu.id
                       join pizzeria on menu.pizzeria_id = pizzeria.id),

    male_visits as (select pizzeria_name
                         from visits_all
                         where gender = 'male'),

    female_visits as (select pizzeria_name
                       from visits_all
                       where gender = 'female'),

    female_only as (select pizzeria_name
                    from female_visits
                    except
                    select pizzeria_name  from male_visits),

    male_only as (select pizzeria_name
                    from male_visits
                    except
                    select pizzeria_name from female_visits)

select *
from female_only
union
select *
from male_only

with visits_all as (select person_id, pizzeria.name as pizzeria_name
                   from person_visits
                   join person on person_visits.person_id = person.id
                   join pizzeria on person_visits.pizzeria_id = pizzeria.id
                   where person_id = 2),

pizzerias_for_andrey AS (select all_orders.name as pizzeria_name
                        from (select person_id, menu_id, name
                         from person_order
                         join menu on person_order.menu_id = menu.id
                         join pizzeria on menu.pizzeria_id = pizzeria.id) as all_orders
                         where person_id = 2
)
SELECT pizzeria_name FROM visits_all
except
select pizzeria_name from pizzerias_for_andrey
order by pizzeria_name


WITH pizzerias AS (SELECT m.pizza_name, p.name AS pizzeria_name, m.price, p.id
                   FROM menu m
                    JOIN public.pizzeria p on m.pizzeria_id = p.id)
SELECT DISTINCT p2.pizza_name, p1.pizzeria_name AS pizzeria_name_1, p2.pizzeria_name AS pizzeria_name_2, p2.price
FROM pizzerias p1
JOIN pizzerias p2 ON (
      p2.pizza_name = p1.pizza_name
      AND p1.price = p2.price
      AND p1.pizzeria_name != p2.pizzeria_name
        and p1.id < p2.id
    )

insert into menu(id, pizzeria_id, pizza_name, price)
values (19, 2, 'greek pizza', 800)

insert into menu(id, pizzeria_id, pizza_name, price)
values ((select max(id)
         from menu) + 1, (select id
                          from pizzeria
                          where name = 'Dominos'), 'sicilian pizza', 900)


INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES
(
  (SELECT MAX(id) + 1 FROM person_visits),
  (SELECT id FROM person WHERE name = 'Denis'),
  (SELECT id FROM pizzeria WHERE name = 'Dominos'),
  '2022-02-22'
),
(
  (SELECT MAX(id) + 1 FROM person_visits),
  (SELECT id FROM person WHERE name = 'Irina'),
  (SELECT id FROM pizzeria WHERE name = 'Dominos'),
  '2022-02-22'
);


INSERT INTO person_order (id, person_id, menu_id, order_date)
VALUES
(
  (SELECT MAX(id) + 1 FROM person_order),
  (SELECT id FROM person WHERE name = 'Denis'),
  (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'),
  '2022-02-24'
),
(
  (SELECT MAX(id) + 2 FROM person_order),
  (SELECT id FROM person WHERE name = 'Irina'),
  (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'),
  '2022-02-24'
);



UPDATE menu
SET price = price * 0.90
WHERE pizza_name = 'greek pizza';


INSERT INTO person_order(ID, PERSON_ID, MENU_ID, ORDER_DATE)
SELECT generate_series((select max(id)+1 from person_order) +1,
                        (select max(id)+1 from person_order)  + (select count(*) from person)),
       generate_series((select min(id) from person), (select COUNT(*) from person)),
       (select menu.id from menu where menu.pizza_name = 'greek pizza'),
       '2022-02-25'


delete from person_order
where order_date = '2022-02-25'


delete from menu
where pizza_name = 'greek pizza'