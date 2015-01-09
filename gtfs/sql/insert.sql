BEGIN;

DELETE FROM import.trips;
DELETE FROM import.stops;
DELETE FROM import.stop_times;
DELETE FROM import.routes;
DELETE FROM import.route_directions;
DELETE FROM gtfs.trips;
DELETE FROM gtfs.stops;
DELETE FROM gtfs.stop_times;
DELETE FROM gtfs.routes;
DELETE FROM gtfs.route_directions;

\copy import.trips FROM '/tmp/trips.txt' DELIMITER ',' CSV HEADER
\copy import.stops FROM '/tmp/stops.txt' DELIMITER ',' CSV HEADER
\copy import.stop_times FROM '/tmp/stop_times.txt' DELIMITER ',' CSV HEADER
\copy import.routes FROM '/tmp/routes.txt' DELIMITER ',' CSV HEADER
\copy import.route_directions FROM '/tmp/route_directions.txt' DELIMITER ',' CSV HEADER


INSERT INTO gtfs.trips (
    route_id,
    direction_id,
    trip_id,
    block_id
)
SELECT
    route_id,
    direction_id,
    trip_id,
    block_id
FROM import.trips;

INSERT INTO gtfs.stops (
    stop_id,
    stop_name,
    geom
)
SELECT
    stop_id::integer,
    stop_name,
    ST_SetSRID(ST_MakePoint(stop_lon, stop_lat), 4326)
FROM import.stops
-- ignore landmark data
WHERE stop_id NOT LIKE 'landmark-%';


INSERT INTO gtfs.stop_times (
    trip_id,
    arrival_time,
    stop_id,
    stop_sequence
)
SELECT
    trip_id,
    to_timestamp(arrival_time, 'HH24:MI:SS"'),
    stop_id,
    stop_sequence
FROM import.stop_times;

INSERT INTO gtfs.routes (
    route_id,
    route_desc,
    route_sort_order
)
SELECT
    route_id,
    route_long_name,
    route_sort_order
FROM import.routes;

INSERT INTO gtfs.route_directions (
    route_id,
    direction_id,
    direction_name
)
SELECT
    route_id,
    direction_id,
    direction_name
FROM import.route_directions;


ALTER TABLE gtfs.stop_times
  ADD FOREIGN KEY (trip_id)
  REFERENCES gtfs.trips (trip_id);

ALTER TABLE gtfs.stop_times
  ADD FOREIGN KEY (stop_id)
  REFERENCES gtfs.stops (stop_id);

COMMIT;


