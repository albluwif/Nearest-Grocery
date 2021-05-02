-- create a table to load the data into
drop table if exists volusia.groceries_distances
create table volusia.groceries_distances (parid int, groc_distance double precision);
copy volusia.groceries_distances from 'C:\temp\cs540\groceries_distances.txt' WITH (FORMAT 'csv',DELIMITER E',', NULL '', HEADER);
ALTER TABLE volusia.groceries_distances OWNER to postgres;

-- add a column to the parcel table, and update to find distance from each parcel to closet grocery
alter table volusia.parcel add column groc_distance double precision;

-- update parcel table to combine the distance to closest grocery to every parcel in the county
update volusia.parcel p set groc_distance = g.groc_distance 
from volusia.groceries_distances g where p.parid=g.parid;