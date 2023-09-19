-- -- 1 session
-- BEGIN;

-- -- 1 session
-- UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
-- COMMIT;

-- -- 2 session
-- SELECT * FROM pizzeria;

-- -- 2 session
-- SELECT * FROM pizzeria;


#1



#2
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
