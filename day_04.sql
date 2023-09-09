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