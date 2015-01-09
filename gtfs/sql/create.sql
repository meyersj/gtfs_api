BEGIN;

DROP SCHEMA IF EXISTS import CASCADE;
CREATE SCHEMA import;

DROP SCHEMA IF EXISTS gtfs CASCADE;
CREATE SCHEMA gtfs;

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

CREATE TABLE gtfs.trips
(
    route_id INTEGER,
    direction_id INTEGER,
    trip_id INTEGER PRIMARY KEY,
    block_id INTEGER
);

CREATE TABLE gtfs.stops
(
    stop_id INTEGER PRIMARY KEY,
    stop_name VARCHAR,
    geom GEOMETRY
);

CREATE TABLE gtfs.stop_times
(
    trip_id INTEGER,
    arrival_time TIME,
    stop_id INTEGER,
    stop_sequence INTEGER,
    PRIMARY KEY (trip_id, stop_sequence)
);

CREATE TABLE gtfs.routes
(
    route_id INTEGER,
    route_desc VARCHAR,
    route_sort_order INTEGER
);

CREATE TABLE gtfs.route_directions
(
    route_id INTEGER,
    direction_id INTEGER,
    direction_name VARCHAR
);

-- create indexes on gtfs tables
--CREATE INDEX ON gtfs.trips (route_id);
--CREATE INDEX ON gtfs.trips (direction_id);
--CREATE INDEX ON gtfs.trips (route_id, direction_id);
--CREATE INDEX ON gtfs.stops (stop_name);
--CREATE INDEX ON gtfs.stops USING gist(geom);
--CREATE INDEX ON gtfs.stop_times (trip_id);
--CREATE INDEX ON gtfs.stop_times (arrival_time);

COMMIT;


