BEGIN;

DROP SCHEMA IF EXISTS import CASCADE;
CREATE SCHEMA import;
CREATE TABLE import.trips
(
    route_id INTEGER,
    service_id VARCHAR,
    trip_id INTEGER,
    direction_id INTEGER,
    block_id INTEGER,
    shape_id INTEGER,
    trip_type VARCHAR
);
CREATE TABLE import.stops
(
    stop_id VARCHAR,
    stop_code INTEGER,
    stop_name VARCHAR,
    stop_desc VARCHAR,
    stop_lat REAL,
    stop_lon REAL,
    zone_id VARCHAR,
    stop_url VARCHAR,
    location_type INTEGER,
    parent_station VARCHAR,
    direction VARCHAR,
    position VARCHAR
);
CREATE TABLE import.stop_times
(
    trip_id INTEGER,
    arrival_time VARCHAR,
    departure_time VARCHAR,
    stop_id INTEGER,
    stop_sequence INTEGER,
    stop_headsign VARCHAR,
    pickup_type INTEGER,
    drop_off_type INTEGER,
    shape_dist_traveled REAL,
    timepoint INTEGER,
    continuous_stops INTEGER
);
CREATE TABLE import.routes
(
    route_id INTEGER,
    route_short_name VARCHAR,
    route_long_name VARCHAR,
    route_type VARCHAR,
    route_url VARCHAR,
    route_sort_order INTEGER
);
CREATE TABLE import.route_directions
(
    route_id INTEGER,
    direction_id INTEGER,
    direction_name VARCHAR
);
CREATE TABLE import.calendar_dates
(
    service_id VARCHAR,
    "date" VARCHAR,
    exception_type VARCHAR
);

DELETE FROM gtfs.trips;
DELETE FROM gtfs.stops;
DELETE FROM gtfs.stop_times;
DELETE FROM gtfs.routes;
DELETE FROM gtfs.route_directions;
DELETE FROM gtfs.calendar_dates;

\copy import.trips FROM '/tmp/gtfs/trips.txt' DELIMITER ',' CSV HEADER
\copy import.stops FROM '/tmp/gtfs/stops.txt' DELIMITER ',' CSV HEADER
\copy import.stop_times FROM '/tmp/gtfs/stop_times.txt' DELIMITER ',' CSV HEADER
\copy import.routes FROM '/tmp/gtfs/routes.txt' DELIMITER ',' CSV HEADER
\copy import.route_directions FROM '/tmp/gtfs/route_directions.txt' DELIMITER ',' CSV HEADER
\copy import.calendar_dates FROM '/tmp/gtfs/calendar_dates.txt' DELIMITER ',' CSV HEADER

INSERT INTO gtfs.trips (
    route_id,
    direction_id,
    trip_id,
    block_id,
    service_id
)
SELECT
    route_id,
    direction_id,
    trip_id,
    block_id,
    service_id
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
    route_long_name,
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

INSERT INTO gtfs.calendar_dates (
    service_id,
    "date",
    exception_type
)
SELECT
    service_id,
    "date"::date,
    exception_type
FROM import.calendar_dates;

ALTER TABLE gtfs.stop_times ADD FOREIGN KEY (trip_id) REFERENCES gtfs.trips (trip_id);
ALTER TABLE gtfs.stop_times ADD FOREIGN KEY (stop_id) REFERENCES gtfs.stops (stop_id);
ALTER TABLE gtfs.trips ADD FOREIGN KEY (route_id) REFERENCES gtfs.routes (route_id);
ALTER TABLE gtfs.trips ADD FOREIGN KEY (route_id, direction_id)
    REFERENCES gtfs.route_directions (route_id, direction_id);



COMMIT;


