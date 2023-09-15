with recursive travel as (
        select
        point1,
        point2,
        cost AS cost
        FROM nodes n
        WHERE point1 = 'a'
    union
        select
        curr_node.point1,
        curr_node.point2,
        curr_node.cost + prev.cost AS cost
        from nodes curr_node
            join travel prev on curr_node.point1 = prev.point2
            where curr_node.point1 != prev.point2)

SELECT * FROM travel;