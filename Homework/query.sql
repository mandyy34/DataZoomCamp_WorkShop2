Q0:
Select taxi_zone.zone from trip_data left join taxi_zone on trip_data.dolocationid = taxi_zone.location_
id where trip_data.tpep_dropoff_datetime = (select max(trip_data.tpep_dropoff_datetime) from trip_data);

Q1:
CREATE MATERIALIZED VIEW min_max_avg_trip AS (select (tz1.zone, tz2.zone) as trip_zones, pulocationid, dolocationid, Max(tpep_dropoff_datetime - tpep_pickup_datetime) AS max_trip_time, AVG(tpep_dropoff_datetime - tpep_pickup_datetime) AS avg_trip_time, Min(tpep_dropoff_datetime - tpep_pickup_datetime) AS min_trip_time from trip_data join taxi_zone tz1 on trip_data.pulocationid = tz1.location_id join taxi_zone tz2 on trip_data.dolocationid = tz2.location_id group by (tz1.zone, tz2.zone), pulocationid, dolocationid);
select trip_zones from min_max_avg_trip where avg_trip_time = (select max(avg_trip_time) from min_max_avg_trip);

Q2:
CREATE MATERIALIZED VIEW min_max_avg_count_trip AS (select (tz1.zone, tz2.zone) as trip_zones, pulocationid, dolocationid, Max(tpep_dropoff_datetime - tpep_pickup_datetime) AS max_trip_time, AVG(tpep_dropoff_datetime - tpep_pickup_datetime) AS avg_trip_time, Min(tpep_dropoff_datetime - tpep_pickup_datetime) AS min_trip_time, count(*) as num_trips from trip_data join taxi_zone tz1 on trip_data.pulocationid = tz1.location_id join ta
xi_zone tz2 on trip_data.dolocationid = tz2.location_id group by (tz1.zone, tz2.zone), pulocationid, dolocatio
nid);
select * from min_max_avg_count_trip where avg_trip_time = (select max(avg_trip_time) from min_max_avg_c
ount_trip);

Q3:
Create view busiestzones_latest17hours as select pulocationid, taxi_zone.zone, count(*) as num_trip from trip_data join taxi_zone on trip_data.pulocationid = taxi_zone.location_id  where tpep_pickup_datetime >= ((select max(tpep_pickup_datetime) from trip_data) - INTERVAL '17' hour) group by pulocationid,
 taxi_zone.zone order by count(*) desc;
select * from busiestzones_latest17hours order by num_trip desc limit 3;


