-- There is no specific luc for groceries.  
-- the groceries in the county have several lucs, but not limited, of 1100 (Stores, One Story), 1400 (Supermarkets), and 1600 (Community Shopping Centers).
-- the groceries have compiled depending on own1. 
-- the following query's where clause is general and to search for all possible groceries have compiled in this database
select p.parid, p.luc, p.luc_desc, o.own1, p.geom into volusia.groceries 
from select * from volusia.owner o join volusia.parcel p on o.parid=p.parid
where p.geom is not null 
and p.luc in ('1100', '1400', '1600')
and (
(o.own1 ilike '%publix%') 
or (o.own1 ilike '%walmart%') 
or (o.own1 ilike '%target%') 
or (o.own1 ilike '%family food%') 
or (o.own1 ilike '%wawa%') 
or (o.own1 ilike '%7-Eleven%')
or (o.own1 ilike '%mini market%')
or (o.own1 ilike '%D TOWN SUPERMARKET INC%')
or (o.own1 ilike '%PLACITA SUPERMARKET INC%')
or (o.own1 ilike '%WINN DIXIE SUPERMARKETS INC%')
or (o.own1 ilike '%LOVE WHOLE FOODS%')
or (o.own1 ilike '%grocery%')
or (o.own1 ilike '%food mart%')
or ((o.own1 ilike '%perrine%') and (o.own1 ilike '%s produce%'))
or (o.own1 ilike '%international food%')
or (o.own1 ilike '%asian market%')
or (o.own1 ilike '%dollar trend%')
or (o.own1 ilike '%gordon food%')
or (o.own1 ilike '%FLORIDAS CITRUS WORLD INC%')
or ((o.own1 ilike '%supermarket%') and (o.own1 not ilike '%pet%'))
/*or (o.own1 ilike '%winn dixie%')*/
)
order by p.luc

-- this where clause has shortened to conditions that get the equivalent result of the previous long where clause.
select p.parid, p.luc, p.luc_desc, o.own1, p.geom 
from volusia.owner o join volusia.parcel p on o.parid=p.parid
where p.geom is not null 
and p.luc in ('1100', '1400', '1600')
and (
(o.own1 ilike '%publix%') 
or (o.own1 ilike '%walmart%') 
or (o.own1 ilike '%7-Eleven%')
or (o.own1 ilike '%LOVE WHOLE FOODS%')
or (o.own1 ilike '%food mart%')
or (o.own1 ilike '%FLORIDAS CITRUS WORLD INC%')
)
order by p.luc


-- the 5 closest groceries to a given parcel (divided by 5280 for distances in miles)
select p.parid, p.geom, p.luc, p.luc_desc, ST_Distance(p.geom, (select p2.geom from volusia.parcel p2 where parid=3565215))/5280 as groc_distance  
from volusia.parcel p join volusia.groceries g on p.parid=g.parid
order by p.geom <-> (select p2.geom from volusia.parcel p2 where parid=3565215) 
limit 5;

-- the closet grocery to a random parcel (divided by 5280 for distances in miles)
select p.parid, p.geom, p.luc, p.luc_desc, ST_Distance(p.geom, (select p2.geom from volusia.parcel p2 where parid=3565215))/5280 as groc_distance  
from volusia.parcel p join volusia.groceries g on p.parid=g.parid
order by p.geom <-> (select p2.geom from volusia.parcel p2 where parid=3565215) 
limit 1;

-- add a column to the parcel table, and update to find distance from each parcel to closet grocery
alter table volusia.parcel add column groc_distance double precision;

-- to build a better parcel table, and not have to use the GIS Parcel table all the time.... bring the parcel geometry over to volusia.parcel

-- add the geometry column (which is different syntax)
SELECT AddGeometryColumn ('volusia','parcel','geom',2236,'MULTIPOLYGON',2);
update volusia.parcel a set geom = p.geom from volusia.gis_parcels p where a.parid=p.altkey;

-- this works for one parcel if you know (divided by 5280 for distances in miles)
update volusia.parcel p1 set groc_distance = ST_Distance(p1.geom, p2.geom)/5280 from volusia.parcel p2 where p1.parid=2004291 and p2.parid=2469498;

-- but you really need a script to loop over each parcel in the county, here's where indexes are vital

create index idx_parcel_luc on volusia.parcel (luc);
create index idx_parcel on volusia.parcel (parid);

CREATE INDEX parcel_geom_idx ON volusia.parcel USING GIST (geom);

vacuum analyze volusia.parcel;

select count(*) from volusia.parcel where groc_distance < 1;


-- run this script to combine the pieces and determine distance to closest grocery to every parcel in the county
update_grocery_distances.py 

