#00 
CREATE TABLE person_audit (
    created timestamp with time zone DEFAULT current_timestamp NOT NULL,
    type_event char(1) DEFAULT 'I' NOT NULL,
    row_id bigint NOT NULL,
    name varchar,
    age integer,
    gender varchar,
    address varchar,
    CONSTRAINT ch_type_event CHECK (type_event IN ('I', 'U', 'D'))
);


CREATE OR REPLACE FUNCTION fnc_trg_person_insert_audit()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO person_audit (
        created,
        type_event,
        row_id,
        name,
        age,
        gender,
        address
    )
    VALUES (
        current_timestamp,
        'I',
        NEW.id,
        NEW.name,
        NEW.age,
        NEW.gender,
        NEW.address
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_person_insert_audit
AFTER INSERT ON person
FOR EACH ROW
EXECUTE FUNCTION fnc_trg_person_insert_audit();


INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk');


#01
CREATE OR REPLACE FUNCTION  fnc_trg_person_update_audit()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO person_audit (
        created,
        type_event,
        row_id,
        name,
        age,
        gender,
        address
    )
    VALUES (
        current_timestamp,
        'U',
        OLD.id,
        OLD.name,
        OLD.age,
        OLD.gender,
        OLD.address
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_person_update_audit
BEFORE UPDATE ON person
FOR EACH ROW
EXECUTE FUNCTION fnc_trg_person_update_audit();


#02 
CREATE OR REPLACE FUNCTION  fnc_trg_person_delete_audit()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO person_audit (
        created,
        type_event,
        row_id,
        name,
        age,
        gender,
        address
    )
    VALUES (
        current_timestamp,
        'D',
        OLD.id,
        OLD.name,
        OLD.age,
        OLD.gender,
        OLD.address
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_person_delete_audit
BEFORE DELETE ON person
FOR EACH ROW
EXECUTE FUNCTION fnc_trg_person_delete_audit();

DELETE FROM person WHERE id = 10;


#03 
DROP TRIGGER trg_person_delete_audit ON person;
DROP FUNCTION fnc_trg_person_delete_audit();

DROP TRIGGER trg_person_update_audit ON person;
DROP FUNCTION fnc_trg_person_update_audit();

DROP TRIGGER trg_person_insert_audit ON person;
DROP FUNCTION fnc_trg_person_insert_audit();


-- Create or replace the trigger function
CREATE OR REPLACE FUNCTION fnc_trg_person_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO person_audit (
            created,
            type_event,
            row_id,
            name,
            age,
            gender,
            address
        )
        VALUES (
            current_timestamp,
            'D',
            OLD.id,
            OLD.name,
            OLD.age,
            OLD.gender,
            OLD.address
        );
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO person_audit (
            created,
            type_event,
            row_id,
            name,
            age,
            gender,
            address
        )
        VALUES (
            current_timestamp,
            'U',
            OLD.id,
            NEW.name,
            NEW.age,
            NEW.gender,
            NEW.address
        );
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO person_audit (
            created,
            type_event,
            row_id,
            name,
            age,
            gender,
            address
        )
        VALUES (
            current_timestamp,
            'I',
            NEW.id,
            NEW.name,
            NEW.age,
            NEW.gender,
            NEW.address
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_person_audit
AFTER INSERT OR UPDATE OR DELETE ON person
FOR EACH ROW
EXECUTE FUNCTION fnc_trg_person_audit();


INSERT INTO person(id, name, age, gender, address)
VALUES (10,'Damir', 22, 'male', 'Irkutsk');

UPDATE person SET name = 'Bulat' WHERE id = 10;

UPDATE person SET name = 'Damir' WHERE id = 10;

DELETE FROM person WHERE id = 10;

#04
CREATE FUNCTION fnc_persons_female()
RETURNS SETOF person AS
$$
SELECT * FROM person WHERE gender = 'female';
$$
LANGUAGE SQL;


CREATE FUNCTION fnc_persons_male()
RETURNS SETOF person AS
$$
SELECT * FROM person WHERE gender = 'male';
$$
LANGUAGE SQL;


#5
CREATE FUNCTION fnc_persons(pgender TEXT DEFAULT 'female')
RETURNS SETOF person AS $$
SELECT * FROM person WHERE gender = pgender;
$$
LANGUAGE SQL;


#6
CREATE FUNCTION fnc_person_visits_and_eats_on_date(
    pperson TEXT DEFAULT 'Dmitriy',
    pprice DOUBLE PRECISION DEFAULT 500,
    pdate DATE DEFAULT '2022-01-08'
)
RETURNS SETOF TEXT AS $$
BEGIN
    RETURN QUERY (
        SELECT DISTINCT p2.name::TEXT
        FROM person_order po
        JOIN person p ON po.person_id = p.id
        JOIN menu ON po.menu_id = menu.id
        JOIN pizzeria p2 ON menu.pizzeria_id = p2.id
        WHERE p.name = pperson AND price < pprice AND order_date = pdate
    );
END;
$$
LANGUAGE plpgsql;


#7
CREATE OR REPLACE FUNCTION func_minimum(arr DOUBLE PRECISION[])
RETURNS DOUBLE PRECISION AS $$
DECLARE
    i INT := 1;
    min_val DOUBLE PRECISION := arr[1];
BEGIN
    WHILE i <= array_length(arr, 1) LOOP
        IF arr[i] < min_val THEN
            min_val := arr[i];
        END IF;
        i := i + 1;
    END LOOP;
    RETURN min_val;
END;
$$ LANGUAGE plpgsql;


SELECT func_minimum(ARRAY[ -1.0, 5.0, 4.4]);


#8
CREATE OR REPLACE FUNCTION fnc_fibonacci(n INT)
RETURNS INT AS $$
BEGIN
    IF n <= 1 THEN
        RETURN n;
    ELSE
        RETURN fnc_fibonacci(n - 1) + fnc_fibonacci(n - 2);
    END IF;
END;
$$ LANGUAGE plpgsql;


