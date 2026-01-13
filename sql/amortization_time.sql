-- 1) create temporary table with the data in the csv files to be able to reuse without having to re import using read_csv_auto
-- 2) join both bikeumeter_activities + bikeumeter_bike_costs
    -- what type of join? => LEFT JOIN => tables don't have columns in common, 
    -- so I need all the info from one table, and just one col from the second
-- 3) get the total which is the amount spent on the bike
-- 4) do a running total = cumulative sum
-- 5) check to see when it crosses 0 using running total against total spent on bike

WITH bikeumeter_activities AS (
    SELECT * FROM read_csv_auto('data/bikeumeter_activities.csv') AS activities
    LEFT JOIN read_csv_auto('data/bikeumeter_bike_costs.csv') AS bike_costs
        ON activities.id = bike_costs.total
    ORDER BY date
)

SELECT date, public_transport_fare, 
        ride_duration_minutes, total 
FROM bikeumeter_activities
LIMIT 10;
