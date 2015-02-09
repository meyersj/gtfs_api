BEGIN;

DROP SCHEMA IF EXISTS gtfs CASCADE;
CREATE SCHEMA gtfs;

-- trips.txt
CREATE TABLE gtfs.trips
(
    trip_id INTEGER PRIMARY KEY,
    service_id VARCHAR,
    route_id INTEGER,
    direction_id INTEGER,
    block_id INTEGER
);
-- stops.txt
CREATE TABLE gtfs.stops
(
    stop_id INTEGER PRIMARY KEY,
    stop_name VARCHAR,
    geom GEOMETRY
);
-- stop_times.txt
CREATE TABLE gtfs.stop_times
(
    trip_id INTEGER,
    arrival_time TIME,
    stop_id INTEGER,
    stop_sequence INTEGER,
    PRIMARY KEY (trip_id, stop_id, stop_sequence)
);
-- routes.txt
CREATE TABLE gtfs.routes
(
    route_id INTEGER PRIMARY KEY,
    route_long_name VARCHAR,
    route_sort_order INTEGER
);
-- route_directions.txt
CREATE TABLE gtfs.route_directions
(
    route_id INTEGER,
    direction_id INTEGER,
    direction_name VARCHAR,
    PRIMARY KEY(route_id, direction_id)
);
--calendar_dates.txt
CREATE TABLE gtfs.calendar_dates
(
    service_id VARCHAR,
    "date" DATE,
    exception_type VARCHAR
);

COMMIT;


