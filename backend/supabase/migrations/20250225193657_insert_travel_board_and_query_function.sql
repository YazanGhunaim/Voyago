set
check_function_bodies = off;

CREATE
OR REPLACE FUNCTION public.insert_travel_board_and_query(user_id uuid, plan jsonb, images jsonb, sight_recommendations jsonb, destination_image jsonb, destination text, days integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
travel_board_id int;
BEGIN
    -- Insert into travel_boards and get the ID
INSERT INTO travel_boards (user_id, plan, images, sight_recommendations, destination_image)
VALUES (user_id, plan, images, sight_recommendations, destination_image) -- Cast user_id to uuid
    RETURNING id
INTO travel_board_id;

-- Insert into board_queries with the travel_board_id
INSERT INTO board_queries (board_id, destination, days)
VALUES (travel_board_id, destination, days);

-- No return value
RETURN;
END;
$function$
;