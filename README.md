# Nearest-Grocery

**Objective:**
as part of CS540 project, this GitHub repository aims to determine the distance in miles from all parcels in Volusia County to it's nearest grocery, 
as this data is not readily available in the Volusia data set.(Dataset Source: volusia.org).

**Process:**
1. Collecting all possible groceries in the VC dataset that only associated with their geoms.
	Groceries are not just listed under one LUC, but several LUCs, and not limited, of 1100 (Stores, One Story), 1400 (Supermarkets), and 1600 (Community Shopping Centers).
	Therefore, groceries were compiled depending on Owner  attribute, own1, and by searching manually for all possible known groceries.
	Important note: This dataset does not include all actual groceries in the county. 
			Thus, further data compiling and manual searching is needed for getting all actual groceries in the county.
	You can find the extracted groceries data in groceries_data.txt
	
2. KNN was used with a limit of 1 to find the nearest grocery geom for each individual parcel.
3. ST_Distance() was then used to find the distance in miles between the parcel geom and the grocery geom.
	You can find the SQL queries in Nearest Grocery.sql
4. Step #2 and #3 process were looped through the entire volusia.parcel table for all parid's.
	Run the python script update_grocery_distances.py to update all possible parcels with their nearest grocery.

**Usage of groceries dataset:**
For use the dataset in your database, run these queries load_groceries_distances_data.sql to create a temp table with parid and groc_distance, load the data into, 
and then update joined with parcel table  based on parid. 

This is a sample of groceries_distance.txt

![image](https://user-images.githubusercontent.com/82927514/116818847-71775c00-ab3b-11eb-8c97-58de9f363fb0.png)


**Further details:**
See the PDF file Nearest Grocery Store.pdf


