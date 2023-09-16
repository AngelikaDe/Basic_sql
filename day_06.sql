create table person_discounts (
    id bigint primary key,
    person_id  bigint not null,
    pizzeria_id bigint not null,
    constraint fk_person_discounts_person_id foreign key(person_id) REFERENCES person(id),
    constraint fk_person_discounts_pizzeria_id foreign key(pizzeria_id )REFERENCES pizzeria(id),
    discount numeric not null default 0);


WITH tmp AS (
    SELECT person_id, pizzeria_id
    FROM person_order
    JOIN menu m ON person_order.menu_id = m.id
),
num_orders AS (
    SELECT person_id, COUNT(person_order.id) AS "order_count"
    FROM person_order
    JOIN person p ON p.id = person_order.person_id
    GROUP BY person_id
    ORDER BY person_id
)
INSERT INTO person_discounts (id, person_id, pizzeria_id, discount)
SELECT
    ROW_NUMBER() OVER () AS id,
    t.person_id,
    t.pizzeria_id,
    CASE
        WHEN no."order_count" = 1 THEN 10.5
        WHEN no."order_count" = 2 THEN 22
        ELSE 30
    END AS discount
FROM tmp AS t
JOIN num_orders AS no ON t.person_id = no.person_id;

SELECT distinct 
    p1.name,
    m.pizza_name,
    m.price,
    (m.price - (m.price * person_discounts.discount/100)) AS discount_price,
    p2.name AS pizzeria_name
FROM person_discounts
JOIN person p1 ON p1.id = person_discounts.person_id
JOIN person_order po ON p1.id = po.person_id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria p2 ON m.pizzeria_id = p2.id
order by p1.name, m.pizza_name;

set Enable_seqscan to off;
CREATE UNIQUE INDEX idx_person_discounts_unique
ON person_discounts (person_id, pizzeria_id)
explain ANALYZE SELECT person_id, pizzeria_id FROM person_discounts;
set Enable_seqscan to on;


ALTER TABLE person_discounts
ADD CONSTRAINT ch_nn_person_id CHECK (person_id IS NOT NULL),
ADD CONSTRAINT ch_nn_pizzeria_id CHECK (pizzeria_id IS NOT NULL),
ADD CONSTRAINT ch_nn_discount CHECK (discount IS NOT NULL),
ADD CONSTRAINT ch_range_discount CHECK (discount >= 0 AND discount <= 100),
ALTER COLUMN discount SET DEFAULT 0;


COMMENT ON TABLE person_discounts IS 'This table stores information about discounts applied to pizza orders by persons and pizzerias.';
COMMENT ON COLUMN person_discounts.person_id IS 'The identifier of the person who receives the discount.';
COMMENT ON COLUMN person_discounts.pizzeria_id IS 'The identifier of the pizzeria where the discount is applied.';
COMMENT ON COLUMN person_discounts.discount IS 'The percentage discount applied to the order (0 to 100 percent).';

CREATE TEMP SEQUENCE seq_person_discounts START WITH 1;
SELECT (SELECT setval('seq_person_discounts', max(id)) FROM person_discounts);
ALTER TABLE person_discounts
ALTER COLUMN id set default nextval('seq_person_discounts');