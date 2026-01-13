-- 1) create temporary table with the data in the csv files to be able to reuse without having to re import using read_csv_auto
-- 2) join both bikeumeter_activities + bikeumeter_bike_costs
    -- what type of join? => CROSS JOIN => tables don't have columns in common, 
    -- so I need all the info from one table, and just one col from the second.
WITH bikeumeter_activities AS (
    SELECT * FROM read_csv_auto('data/bikeumeter_activities.csv') AS activities
    CROSS JOIN read_csv_auto('data/bikeumeter_bike_costs.csv') AS costs
),
-- 3) get the total which is the amount spent on the bike
    -- a) strip the public_transport_fare of the euro symbol
cleaned_fare AS (
    SELECT *, 
            REPLACE(public_transport_fare, '€', '') AS cleaned_fare
    FROM bikeumeter_activities
),
    -- b) convert it to a numeric value
numeric_fare AS (
    SELECT *,
            CAST(cleaned_fare AS DECIMAL(10, 2)) AS numeric_fare
    FROM cleaned_fare
)
    -- c) convert total to negative value
    -- d) do the cumulative sum
SELECT date, ride_duration_minutes, 
        public_transport_fare, total, (total * -1) AS bike_cost,
        numeric_fare,
        SUM(numeric_fare) OVER( ORDER BY date)
FROM numeric_fare
LIMIT 10;
-- 4) check to see when it crosses 0 using running total against total spent on bike

